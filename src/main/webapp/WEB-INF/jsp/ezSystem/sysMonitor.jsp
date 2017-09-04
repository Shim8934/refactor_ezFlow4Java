<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="<spring:message code='main.e15'/>" type="text/css">
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jui/lib/core.min.js"></script>
<script type="text/javascript" src="/js/jui/dist/chart.min.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		var obj = JSON.parse('${serverList}');
		var list = obj.getSysInfo;
		var str = "";
		
		// 서버의 갯수만큼 checkbox 생성
		for (var i = 0; i < list.length; i++) {
			str = '<input type="checkbox" name="chkValue" id="chkVal_'+ i +'" onClick="chkServerList_onclick('+ i +')" checked >' + list[i].hostname;
			$("#serverList").append(str);
			chkServerList_onclick(i);
		}
		//$("#serverList").append(str);
	});
	
	/**
	 * 각 서버를 checkbox로 제어
	 * checkedId, graphId를 이용한 그래프가 그려지는 div 구분
	 */
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
			monitoringForm.removeChild(document.getElementById(graphId));			
		} 
	}	

	/**
	 * 그래프 생성 함수
	 * jui.ready()가 반드시 필요
	 */
	function makingGraph(graphId) {
		var fileSysData = [];
		var cpuMemoryData = [];
		var diskioData = [];
		var networkData = [];
		var diskMax = [];
		//var diskioMax = 0;
		
		//범례 색상
		var cpuMemoryColor = ['#77B0A8', '#E96359'];
		var diskioColor = ['#4641D9', '#2F9D27', '#FF5E00', '#FFBB00', '#99004C', '#000093', '#FF0000'];
		var networkColor = ['#000093', '#FF0000'];
		
		var oldTx = 0;
		var oldRx = 0;		
		
		var current;
		var start;
		
		jui.ready(["chart.builder"], function (builder) {
			var diskTarget = [];
			
			// 2초마다 그래프 재생성
	      	var refreshIntervalID = setInterval(function() {
				setGraphForm();
				
		    	// 해당 그래프가 없을 경우 setInterval 종료
		    	if (document.getElementById(graphId) == null) {
		    		clearInterval(refreshIntervalID);
		    	}				
		    }, 2000);			
			
			// CPU & Memory 관련 그래프
			var cpuMemoryChart = builder ("#cpuMemInfo", {		
				axis: [{
					x: {
						type: "date",
						domain: [start, current],
						realtime: "seconds",
						interval: 10,
						format: "hh:mm:ss",
						line: true,
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
					type: "line",
					colors: cpuMemoryColor
				}, {
					type: "scatter",
					target: ["Cpu", "Memory"],
					symbol: "circle",
					clip: true,
					size: 8,
					colors: cpuMemoryColor
				}],
				widget: [{
					type: "legend",
					filter: false
				}, {
					type: "tooltip",
					brush: [1]
				}, {
					type: "title",
					text: "<spring:message code='ezSystem.pjg01'/>",
					align:"end",
					size: 14
				}]
			});

			// Disk I/O 관련 그래프
 			var diskioChart = builder ("#diskioInfo", {
				axis: [{
					x: {
						type: "date",
						domain: [start, current],
						realtime: "seconds",
						interval: 10,
						format: "hh:mm:ss",
						line: true,
						key: "time"
					},
					y: {
						type: "range",
						domain: [0, 1],
						step: 5,
						line: true,
						format: function(value) {
							//return value + "KB/s";
							return value + "MB/s"
						}
					}
				}],
				brush: [{
					type: "line",
					colors: diskioColor
				}, {
					type: "scatter",
					clip: true,
					colors: diskioColor
				}], 
				widget: [{
					type: "legend"
				},{
					type: "title",
					text: "<spring:message code='ezSystem.pjg02'/>",
					align:"end",
					size: 14
				}]
			});

			// Network Traffic 관련 그래프
			var networkChart = builder ("#networkInfo", {
				axis: [{
					x: {
						type: "date",
						domain: [start, current],
						realtime: "seconds",
						interval : 10,
						format: "hh:mm:ss",
						line: true,
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
					type: "line",
					colors: networkColor
				}, {
					type: "scatter",
					target: ["Receive", "Transfer"],
					symbol: "circle",
					size: 8,
					clip: true,
					colors: networkColor
				}],
				widget: [{
					type: "legend"
				}, {
					type: "tooltip",
					brush: [1]
				}, {
					type: "title",
					text: "<spring:message code='ezSystem.pjg03'/>",
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
					size: 20,
					format: function(value) {
						return parseInt(value) + "%";
					}
				}],
				widget: [{
					type: "title",
					text: "<spring:message code='ezSystem.pjg04'/>",
					align:"end",
					size: 14
				}]
			});
	      	
			// 그래프에 필요한 데이터 가져오기
	    	function getInfo() {
	    		$.ajax ({
	    			url : "/admin/ezSystem/sysMonitorInfo.do",
	    			type : "POST",
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
	    	
	    	// OS 관련 데이터
	    	function setOsInfo(list) {
	    		var obj = JSON.parse(list);
	    		var osInfo = obj.getSysInfo;
	    		
	    		var serverName = "<p id='serverName'>" + osInfo[0].hostname + "</p>"
	    		var osName = "<p id='osName'><strong>OS : </strong>" + osInfo[0].os + "</p>";
	    		var osVer = "<p id='osVer'><strong>Version : </strong>" + osInfo[0].version + "</p>";
	    		
	    		$("#serverName").html(serverName);
	    		$("#osName").html(osName);
	    		$("#osVer").html(osVer);
	    	}
	    	
	    	// 네트워크 트래픽 속도 계산 공식
	    	function getMbps(old, current) {
	    		
	    		if (old == 0) {
	    			result = 0;
	    		} else {
	    			// 2초간 조사한 값, Byte->bit(*8), bit->KBit(/1024)->Mbit(/1024)
	    			result = ( current - old ) / 2 * 8 / 1024 / 1024;
	    		}	    		
	    		return result;
	    	}
	    	
	    	// 네트워크 관련 데이터
	    	function getNetworkData(str) {
	    		var obj = JSON.parse(str);
	    		var netInfo = obj.getNetDataInfo;
	    		var receive;
	    		var transfer;
	    		
	    		if (networkData.length >= 30) {
	    			networkData.shift();
	    		}

	    		receive = getMbps(oldRx, parseInt(netInfo[0].rBytes));
	    		transfer = getMbps(oldTx, parseInt(netInfo[0].tBytes));
	    		
	    		networkData.push({
	    			time: current,
	    			//time: new Date(),
	    			Receive: receive.toFixed(4),
	    			Transfer: transfer.toFixed(4)			
	    		});	    	

	    		oldRx = parseInt(netInfo[0].rBytes);
	    		oldTx = parseInt(netInfo[0].tBytes);
	    	}
	    	
	    	// 디스크 io 관련 데이터
	    	function getDiskioData(str) {
	    		var obj = JSON.parse(str);
	    		var ioInfo = obj.getDiskioInfo;
	    		var maxInfo = obj.diskioMax;	
	    		var current = new Date();

	    		if (diskMax.length >= 30) {
	    			diskMax.shift();
	    		}	    		
	    		// diskio 관련 최대값을 저장
	    		diskMax.push(parseInt(maxInfo));
	    		
	    		if (diskioData.length >= 30) {
	    			diskioData.shift();
	    		}
	    		
 	    		for (var i = 0; i < ioInfo.length; i++) {
	    			diskTarget = Object.keys(ioInfo[i]);
	    			ioInfo[i].time = current;
	    			diskioData.push(ioInfo[i]);
	    		} 	    		
	    	}
	    	
	    	// 메모리 사용량 계산
	    	function getUsedMemoryPer(total, avail) {
	    		var result = ( parseInt(total) - parseInt(avail) ) / parseInt(total);	    		
	    		return result;
	    	}	    	
	    	
	    	// cpu & 메모리 관련 데이터 입력.
	    	function getCpuMemoryData(cpu, memory) {
	    		var cobj = JSON.parse(cpu);
	    		var mobj = JSON.parse(memory);

	    		var cpu = cobj.getCpuInfo;
	    		var memory = mobj.getMemoryInfo;	 
	       		var usedMemory = getUsedMemoryPer(memory[0].memtotal, memory[0].memavailable);
	    		
	    		if (cpuMemoryData.length >= 30) {
	    			cpuMemoryData.shift();
	    		}
	    		
 	    		cpuMemoryData.push({
	    			time: current,	
	    			Cpu: parseFloat(cpu[0].totalUsedPer).toFixed(2),
	    			Memory: (usedMemory * 100).toFixed(2)
	    		});  	
	    	}

	    	// 그래프에 파일시스템 관련 데이터 입력.
	    	function getFileSysData(str) {
	    		var obj = JSON.parse(str);
	    		var fileSystem = obj.getFileSysInfo;
	    		fileSysData = [];
	    		var str = "";	    		
	    		
	    		for (var i = 0; i < fileSystem.length; i++ ){
	    			fileSysData.push({
	    				title : fileSystem[i].diskName,
	    				value : parseInt(fileSystem[i].usedPer)
	    			});
 	    			str += '<tr id="tableRow">';
	    			str += '<td id="tData"><strong>'+ fileSystem[i].diskName +'</strong></td>';
	    			str += '<td id="tData"> ■ '+"<spring:message code='ezSystem.pjg05'/>" +' '+ fileSystem[i].total + '</td>';
	    			str += '<td id="tData"> ■ '+"<spring:message code='ezSystem.pjg06'/>" +' '+ fileSystem[i].used +'</td>';
	    			str += '<td id="tData"> ■ '+"<spring:message code='ezSystem.pjg07'/>"+' '+ fileSystem[i].avail +'</td>';
	    			str += '</tr>';
	    		}
	    		$("#filesysBody").html(str);
	    	} 	    	

			/**
			 *  그래프 업데이트 관련 함수
			 *  update() : 그래프 데이터 업데이트
			 *  updateGrid() : 그래프에 그려질 축 업데이트
			 */
			function setGraphForm() {
		   	    	current = new Date();
		   	    	start = new Date - 1000 * 60;
		   	    	var domain = [start , current];
		   	    	var networkMax = 0;
		   	    	var networkDomain;
		   	    	var networkStep;
		   	    	var networkTmp = 0;
		   	    	
		   	    	var diskioMax = 0;
		   	    	var diskioDomain;
		   	    	var diskioStep;
			    	getInfo(); // 그래프 데이터 가져오기

			    	cpuMemoryChart.axis(0).update(cpuMemoryData);   	    	
			    	cpuMemoryChart.axis(0).updateGrid("x", {
			            domain : domain
			        });
			    	cpuMemoryChart.updateBrush(0, {
			    		type: "line",
			    		target: ["Cpu", "Memory"]
			    	});
			    	cpuMemoryChart.render(true);

			    	// 디스크 입출력 y축을 동적으로 변하게 하기 위한 부분
	 		    	diskioChart.axis(0).update(diskioData);
			    	diskioChart.axis(0).updateGrid("x", {
			    		domain : domain
			        });		    			    	

			    	// diskMax 안에서 가장 큰 값을 찾는다.
			    	for (var i = 0; i < diskMax.length; i++) {
			    		if (diskMax[i] >= diskioMax) {
			    			diskioMax = diskMax[i];
			    		}
			    	}
			    	if (diskioMax > 1) {
			    		var domainVal = (parseInt(diskioMax/10)) * 10;
			    		if (domainVal < 10) {
			    			domainVal = 0;
			    		}
			    		diskioDomain = [0, domainVal + 10 ];
			    		diskioStep = 2;
			    	} else {
			    		diskioDomain = [0, 1];
			    		diskioStep = 5;
			    	}		    	
			    	diskioChart.axis(0).updateGrid("y", {
						type: "range",
						domain: diskioDomain,
						step: diskioStep,
						line: true,
						format: function(value) {
							return value + "MB/s";	 
						}
			    	});
			    	
			    	diskioChart.updateBrush(0, {
			    		type: "line",
			    		target: diskTarget
			    	})
	 		    	diskioChart.updateBrush(1, {
			    		type: "scatter",
			    		target: diskTarget,
			    		symbol: "circle",
			    		clip: true,
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
		    		
			    	/**
			    	 * 네트워크 데이터 y축을 동적으로 변하게 하기 위한 부분
			    	 * networkData에 있는 transfer, receive 값 중 가장 큰 값을 
			    	 * networkMax저장해서 y축 값을 변경
			    	 */
		    		for (var i = 0; i < networkData.length; i++) {
		    			
		    			if (networkData[i].Receive > networkData[i].Transfer) {
		    				networkTmp = networkData[i].Receive;
		    			} else {
		    				networkTmp = networkData[i].Transfer;
		    			}	    			
		    			if (networkTmp > networkMax) {
		    				networkMax = networkTmp;
		    			}
		    		}	
			    	
			    	if (networkMax > 50) { 				    		
			    		/** 
			    		 * 최대값의 10의 자리를 기준으로 + 10
			    		 * 예) 최대값이 63인 경우 70Mbps를 y축으로 설정 
			    		*/
			    		var step = parseInt(networkMax / 10);
			    		var result = (step * 10) + 10 ;

				        networkDomain = [0, result];
				        networkStep = step + 1;
			    	} else {
			    		networkDomain = [0, 50];
			    		networkStep = 5;	    		
			    	}
			    	
			    	networkChart.axis(0).updateGrid("y", {
						type: "range",
						domain: networkDomain,
						step: networkStep,
						line: true,
						format: function(value) {
							return value + "Mbps";
						}			
	    			});	 
			    	networkChart.updateBrush(0, {
			    		type: "line",
			    		target: ["Receive", "Transfer"]
			    	});
			    	networkChart.render(true);
			    	
			    	filesysChart.axis(0).update(fileSysData);	   
			    	filesysChart.render(true);				 
			 }			 
			// 최초 그래프 생성		 
			 setGraphForm(); 	    	
		});		
	}	
</script>
<style type="text/css">
.infoMain   { border : 1px solid; color : #b6b6b6; height : 600px; margin : 20px 0px 0px; }
.serverInfo { float : left; width : 15%; height : 100%;	color : #000000; padding-left : 10px; }
.graphInfo  { float : left; width : 84%; height : 50%; }

#serverName { color : #000000; font-weight : bold; font-size : 24px; text-align : left; }
#cpuMemInfo { width : 50%; height: 95%;float : left; }
#diskioInfo { width : 50%; height: 95%; display : inline-block; }
#networkInfo { width : 50%; height: 95%; float : left; }
#filesysInfo { width : 50%; height: 95%; display : inline-block; }
#filesysGraph { height: auto; overflow: hidden; }
#filesysUsed { height: auto; padding-left: 5%; }
#tableRow {padding-left:5px;}
#tData { padding-bottom: 2%; padding-right: 5px; }
</style>
</head>
<body class="mainbody">
 	<h1><spring:message code='ezSystem.pjg08'/></h1>
	<table class="content">
		<tbody>
			<tr>
				<th width="110"><spring:message code='ezSystem.pjg09'/></th>
				<td id="serverList">
				
				</td>
			</tr>
		</tbody>
	</table>

	<div id="monitoringForm">
	</div>
</body>
</html>