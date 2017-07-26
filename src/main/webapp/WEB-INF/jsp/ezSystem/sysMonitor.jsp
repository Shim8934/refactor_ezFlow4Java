<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="<spring:message code='main.e15'/>" type="text/css">
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jui/lib/core.min.js"></script>
<script type="text/javascript" src="/js/jui/dist/chart.min.js"></script>
<script type="text/javascript">

	function chkServerList_onclick(listNum) {	
		var checkedId = "chkVal_" + listNum;
		var graphId = "graph_" + listNum;
		
		if (document.getElementById(checkedId).checked) {
			var str = "";
			
			str += "<div class='infoMain' id="+ graphId +" target="+ graphId +">";
			str += "	<div class='serverInfo'>";
			str += "		<p id='serverName'></p>";
			str += "		<p id='osName'></p>";
			str += "		<p id='osVer'></p>";
			str += "	</div>";
			str += "	<div class='graphInfo'>";
			str += "		<div id='cpuMemInfo'>";						
			str += "		</div>";
			str += "		<div id='diskioInfo'>";						
			str += "		</div>";
			str += "	</div>";
			str += "	<div class='graphInfo'>";
			str += "		<div id='networkInfo'>";						
			str += "		</div>";
			str += "		<div id='filesysInfo'>";
			str += "			<div id='filesysGraph'></div>";
			str += "			<div id='filesysUsed'>";			
			str += "				<table class='filesys'>";
			str += "					<tbody id='filesysBody'>";
			str += "					</tbody>";
			str += "				</table>";
			str += "			</div>";
			str += "		</div>";			 
			str += "	</div>";
			str += "</div>";				
			
			$("#monitoringForm").append(str);
			
			makingGraph(graphId);
		} else {
			document.getElementById(graphId).remove();
		}
	}	
	
	function makingGraph(graphId) {
		var fileSysData = [];
		var cpuMemoryData = [];
		var diskioData = [];
		var networkData = [];
		
		var oldTx=0;
		var curTx=0;
		var oldRx=0;
		var curRx=0;		
		
		jui.ready(["chart.builder"], function (builder) {
			var current = new Date();
			var start = current - 1000 * 60;
			var diskDomain = [];
			
			// CPU & Memory 관련 그래프
			var cpuMemoryChart = builder ("#cpuMemInfo", {		
				axis: [{
					x: {
						type: "date",
						domain: [new Date() - 1000 * 60, new Date()],
						realtime: "seconds",
						interval: 10,
						format: "hh:mm:ss",
						key: "time"
					},
					y: {
						type: "range",
						domain: [0, 100],
						step: 5,
						line: true,
						format: function(value) {
							return value + "%";
						}
					}
				}],
				brush: [{
					type: "line"
				}, {
					type: "scatter",
					target: ["cpu", "memory"],
					symbol: "circle",
					size: 8
				}],
				widget: [{
					type: "legend",
					filter: false
				}, {
					type: "tooltip",
					brush: [1]
				}, {
					type: "title",
					text: "CPU & Memory 사용량",
					align:"end",
					size: 14
				}]
			});

			// Disk I/O 관련 그래프
 			var diskioChart = builder ("#diskioInfo", {
				axis: [{
					x: {
						type: "date",
						domain: [new Date() - 1000 * 60, new Date()],
						realtime: "seconds",
						interval: 10,
						format: "hh:mm:ss",
						key: "time"
					},
					y: {
						type: "range",
						domain: [0, 50],
						step: 5,
						line: true,
						format: function(value) {
							return value + "KB/s";
						}
					}
				}],
				brush: [{
					type: "line"
				}, {
					type: "scatter"
				}], 
				widget: [{
					type: "legend"
				},{
					type: "title",
					text: "DISK I/O",
					align:"end",
					size: 14
				}]
			});

			// Network Traffic 관련 그래프
			var networkChart = builder ("#networkInfo", {
				axis: [{
					x: {
						type: "date",
						domain: [new Date() - 1000 * 60, new Date()],
						realtime: "seconds",
						interval : 10,
						format: "hh:mm:ss",
						key: "time"
					},
					y: {
						type: "range",
						domain: [0, 50],
						step: 5,
						line: true,
						format: function(value) {
							return value + "Mbps";
						}
					},
				}],
				brush: [{
					type: "line"
				}, {
					type: "scatter",
					target: ["receive", "transfer"],
					symbol: "circle",
					size: 8
				}],
				widget: [{
					type: "legend"
				}, {
					type: "tooltip",
					brush: [1]
				}, {
					type: "title",
					text: "네트워크 트래픽",
					align:"end",
					size: 14
				}]
			});

			// Filesystem 용량 관련 그래프
			var filesysChart = builder ("#filesysGraph", {
				axis: [{
					area: {
						height: 200
					},
					data: fileSysData
				}],
				brush : [{
					type: "bargauge",
					size: 40,
					format: function(value) {
						return parseInt(value) + "%";
					}
				}],
				widget: [{
					type: "title",
					text: "DISK 사용량",
					align:"end",
					size: 14
				}]
			});
			
	      	var intervalId =  setInterval(function() {
	   	    	var current = new Date();
	   	    	var start = new Date - 1000 * 60;
	   	    	var domain = [start , current];
		    	getInfo();

		    	cpuMemoryChart.axis(0).update(cpuMemoryData);   	    	
		    	cpuMemoryChart.axis(0).updateGrid("x", {
		            domain : domain
		        });
		    	cpuMemoryChart.updateBrush(0, {
		    		type: "line",
		    		target: ["cpu", "memory"]
		    	});
		    	cpuMemoryChart.render(true);

 		    	diskioChart.axis(0).update(diskioData);
		    	diskioChart.axis(0).updateGrid("x", {
		    		domain : domain
		        });
		    	diskioChart.updateBrush(0, {
		    		type: "line",
		    		target: diskDomain
		    	})
 		    	diskioChart.updateBrush(1, {
		    		type: "scatter",
		    		target: diskDomain,
		    		symbol: "circle",
		    		size: 8
		    	})
 		    	diskioChart.addWidget({
		    		type: "tooltip",
		    		brush: [1]
		    	})
		    	diskioChart.render(true); 
		    	
		    	networkChart.axis(0).update(networkData);
		    	networkChart.axis(0).updateGrid("x", {
		    		domain : domain
		        });
		    	networkChart.updateBrush(0, {
		    		type: "line",
		    		target: ["receive", "transfer"]
		    	});
		    	networkChart.render(true);
		    	
		    	filesysChart.axis(0).update(fileSysData);	   
		    	filesysChart.render(true);
		    	//$("#filesysUsed").html("<p>ddddddddddd</p>");
		    }, 3000);
	      	
	    	function getInfo() {
	    		$.ajax ({
	    			url : "/admin/ezSystem/sysMonitorInfo.do",
	    			type : "POST",
	    			async : false,
	    			dataType : "json",
	    			success : function (data) {
	    				getFileSysData(data.fileSysInfoList);
	    				getCpuMemoryData(data.cpuInfo, data.memoryInfo);
	    				getNetworkData(data.netTrafficList);
	    				getDiskioData(data.diskioInfo);
	    				setOsInfo(data.osInfo);
	    			}
	    		});
	    	};
	    	
	    	function setOsInfo(list) {
	    		var serverName = "<p id='serverName'>" + list.osName + "</p>"
	    		var osName = "<p id='osName'><strong>OS : </strong>" + list.osName + "</p>";
	    		var osVer = "<p id='osVer'><strong>Version : </strong>" + list.osVer + "</p>";
	    		
	    		$("#serverName").html(serverName);
	    		$("#osName").html(osName);
	    		$("#osVer").html(osVer);
	    	}
	    	
	    	// 네트워크 트래픽 속도 계산 공식
	    	function getMbps(old, current) { 		
	    		return result = (old - current) / 3 * 128 / 1000;
	    	}
	    	
	    	// 네트워크 관련 데이터
	    	function getNetworkData(str) {
	    		var obj = JSON.parse(str);
	    		var netInfo = obj.getNetByteInfo;
	    		var receive;
	    		var transfer;
	    		
	    		if (networkData.length > 20) {
	    			networkData.shift();
	    		}
	    		
	    		receive = getMbps(oldRx, parseInt(netInfo[0].rBytes));
	    		transfer = getMbps(oldTx, parseInt(netInfo[0].tBytes));

	    		// 처음 시작할 경우 마이너스 값이 나오기 때문에 0으로 초기화.
	    		if (receive < 0) {
	    			receive = 0;
	    		}
	    		
	    		if (transfer < 0) {
	    			transfer = 0;
	    		}
	    		
	    		networkData.push({
	    			time: new Date(),
	    			receive: receive.toFixed(2),
	    			transfer: transfer.toFixed(2)			
	    		});	    		
	    		oldRx = netInfo[0].rBytes;
	    		oldTx = netInfo[0].tBytes;
	    	}
	    	
	    	// 디스크 io 관련 데이터
	    	function getDiskioData(str) {
	    		var obj = JSON.parse(str);
	    		var ioInfo = obj.getDiskioInfo;
	    		var current = new Date();

	    		if (diskioData.length > 20) {
	    			diskioData.shift();
	    		}
	    		
	    		for (var i = 0; i < ioInfo.length; i++) {
	    			diskDomain = Object.keys(ioInfo[i]);
	    			ioInfo[i].time = current;
	    			diskioData.push(ioInfo[i]);
	    		}
	    	}
	    	
	    	function getCpuMemoryData(cpu, memory) {
	    		
	    		if (cpuMemoryData.length > 20) {
	    			cpuMemoryData.shift();
	    		}
	    		
	    		cpuMemoryData.push({
	    			time: new Date(),			
	    			cpu: parseInt(cpu.totalUsedCpu),
	    			memory: parseInt(memory.usedMemPer)
	    		});
	    	}
	    	
	    	// 킬로바이트 - > 기가바이트
			function getGByte(kbyte) {
	    		return kbyte / 1024 /1024;
	    	}

	    	// 그래프에 파일시스템 관련 데이터 입력.
	    	function getFileSysData(fileSystem) {
	    		fileSysData = [];
	    		var str = "";	    		
	    		for (var i = 0; i < fileSystem.length; i++ ){
		    		var total = (getGByte(fileSystem[i].totalVolume)).toFixed(2);
		    		var used = (getGByte(fileSystem[i].usedVolume)).toFixed(2);
		    		var avail = (getGByte(fileSystem[i].availVolume)).toFixed(2);	 
		    		
	    			fileSysData.push({
	    				title : fileSystem[i].diskName,
	    				value : parseInt(fileSystem[i].usedVolumePer)
	    			});
	    			str += '<tr id="tableRow">';
	    			str += '<td id="tData"><strong>'+ fileSystem[i].diskName +'</strong></td>';
	    			str += '<td id="tData">■ 총용량 '+ total + 'GB</td>';
	    			str += '<td id="tData">■ 사용중 '+ used +'GB</td>';
	    			str += '<td id="tData">■ 사용가능 '+ avail +'GB</td>';
	    			str += '</tr>';
	    		}
	    		$("#filesysBody").html(str);
	    	} 
		});		
	}	
</script>
<style type="text/css">
.infoMain   { border : 1px solid; color : #b6b6b6; height : 600px; margin : 20px 0px 0px; }
.serverInfo { float : left; width : 15%; height : 100%;	color : #000000; padding-left : 10px; }
.graphInfo  { float : left; width : 84%; height : 50%; }

#serverName { color : #000000; font-weight : bold; font-size : 30px; text-align : left; }
#cpuMemInfo { width : 50%; height: 95%;float : left; }
#diskioInfo { width : 50%; height: 95%; display : inline-block; }
#networkInfo { width : 50%; height: 95%; float : left; }
#filesysInfo { width : 50%; height: 95%; display : inline-block; }
#filesysGraph { height: 70%; }
#filesysUsed { padding-left: 5%; }
#tableRow {padding-left:5px;}
#tData { padding-bottom: 2%; padding-right: 5px; }
</style>
</head>
<body class="mainbody">
 	<h1>시스템 모니터링</h1>
	<table class="content">
		<tbody>
			<tr>
				<th width="110">서버목록</th>
				<td>
					<input type="checkbox" name="chkValue" id="chkVal_0" onClick="chkServerList_onclick(0)">${serverList.osName}
				</td>
			</tr>
		</tbody>
	</table>

	<div id="monitoringForm">
	</div>
	<div id='testdiv'>
	
	</div>
</body>
</html>