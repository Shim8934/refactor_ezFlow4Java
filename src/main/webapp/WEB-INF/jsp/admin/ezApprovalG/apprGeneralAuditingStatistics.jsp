<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t98'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist tr th {
	    		border-top:0px;
	    	}
	    </style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>			
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')}"></script>
		<script type="text/javascript">
		var now = new Date();	// 현재 날짜 및 시간
		var curYear = now.getFullYear();
		var curMonth = now.getMonth()+1;
		var curDate = now.getDate();
		var oneMonthAgo = new Date(now.setMonth(now.getMonth() - 1));	// 한달 전
		var agoYear = oneMonthAgo.getFullYear();
		var agoMonth = oneMonthAgo.getMonth()+1;
		var agoDate = oneMonthAgo.getDate();
		var maxHeight = 0;
		var widthVal = 0;
		var thHtml = "";
		
		var addRows = function(idx, rows) {
			var html = "";
			
			if(rows.length > 0) {
				for(var i=0; i<rows.length; i++) {
					var processDate = "";
					var processDateSpl;
					var endDate = "";
					var endDateSpl;
					var thIndex = 0;
					
					if(rows[i].processDate.indexOf("<spring:message code='ezBoard.t212' />") > -1) {
						processDateSpl = rows[i].processDate.split("<spring:message code='ezBoard.t212' />");
						processDate += processDateSpl[0];
						processDate += "<br>";
						processDate += "<spring:message code='ezBoard.t212' />";
						processDate += processDateSpl[1];
					} else if(rows[i].processDate.indexOf("<spring:message code='ezBoard.t213' />") > -1) {
						processDateSpl = rows[i].processDate.split("<spring:message code='ezBoard.t213' />");
						processDate += processDateSpl[0];
						processDate += "<br>";
						processDate += "<spring:message code='ezBoard.t213' />";
						processDate += processDateSpl[1];
					}
					
					if(rows[i].endDate.indexOf("<spring:message code='ezBoard.t212' />") > -1) {
						endDateSpl = rows[i].endDate.split("<spring:message code='ezBoard.t212' />");
						endDate += endDateSpl[0];
						endDate += "<br>";
						endDate += "<spring:message code='ezBoard.t212' />";
						endDate += endDateSpl[1];
					} else if(rows[i].endDate.indexOf("<spring:message code='ezBoard.t213' />") > -1) {
						endDateSpl = rows[i].endDate.split("<spring:message code='ezBoard.t213' />");
						endDate += endDateSpl[0];
						endDate += "<br>";
						endDate += "<spring:message code='ezBoard.t213' />";
						endDate += endDateSpl[1];
					}
					
					html += "<tr name='tr_docList' style='cursor:pointer;'>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:left;'>";
					html += rows[i].docId;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:left;'>";
					html += rows[i].writerDeptName;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:left;'>";
					html += rows[i].docNo;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:left;'>";
					html += rows[i].docTitle;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:center;'>";
					html += processDate;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:center;'>";
					html += endDate;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:center;'>";
					html += rows[i].aprMemberName;
					html += "</td>";
					html += "<td style='width:"+$($("th[name=th_name]")[thIndex++]).css("width")+";text-align:left;'>";
					html += rows[i].content;
					html += "</td>";
					html += "</tr>";
				}
			} else {
				html += "<tr name='tr_docList' style='cursor:pointer;'>";
				html += "<td style='text-align:center;'>";
				html += "<spring:message code='main.t00026' />";
				html += "</td>";
				html += "</tr>";
			}
			
			$("#tbody_docList").html(html);
			
			if($("#table_docList").height() > maxHeight) {
				$("#div_docList").width(widthVal+20);
			} else {
				$("#div_docList").width(widthVal);
			}
		};
		
		$(function () {
			var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");     
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
			 
			$.datepicker.regional["<spring:message code='main.t0619' />"] = {
				closeText: "<spring:message code='main.t3' />",
			    prevText: "<spring:message code='main.t0604' />",
			    nextText: "<spring:message code='main.t0605' />",
			    currentText: "<spring:message code='main.t0606' />",
			    monthNames: monthStr,
			    monthNamesShort: monthStr,
			    dayNames: dayStr,
			    dayNamesShort: dayStr,
			    dayNamesMin: dayStr,
			    weekHeader: 'Wk',
			    dateFormat: 'yy-mm-dd',
			    firstDay: 0,
			    isRTL: false,
			    duration: 200,
			    showAnim: 'show',
			    showMonthAfterYear: true
			};
			$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	    });
		
		$(document).ready(function() {
			maxHeight = Number($("#div_docList").css("max-height").substring(0, $("#div_docList").css("max-height").length-2));	// px 문자열자르기
			
			// 브라우저별 width 인식 값 차이 조정
			if($("#lvSDoc").width() > $("#table_th").width()) {
				widthVal = $("#lvSDoc").width();
			} else {
				widthVal = $("#table_th").width();
			}
			
			$("#startDatePicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.png",
	            buttonImageOnly: true
	        });
	        $("#endDatePicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.png",
	            buttonImageOnly: true
	        });
	        
	        curMonth = curMonth.toString().addstring("L", "0", 2, 0);
	        curDate = curDate.toString().addstring("L", "0", 2, 0);
	        agoMonth = agoMonth.toString().addstring("L", "0", 2, 0);
	        agoDate = agoDate.toString().addstring("L", "0", 2, 0);
	        
	        $("#startDatePicker").val(agoYear+"-"+agoMonth+"-"+agoDate);
	        $("#endDatePicker").val(curYear+"-"+curMonth+"-"+curDate);
	        
	        thHtml += "<thead>";
	        thHtml += "<tr role='row'>";
	        thHtml += "<th name='th_name' class='sorting' style='width:120px;'><spring:message code='ezApprovalG.apprBlAudit.23' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:80px;'><spring:message code='ezApprovalG.apprBlAudit.24' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:80px;'><spring:message code='ezApprovalG.apprBlAudit.25' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:250px;'><spring:message code='ezApprovalG.apprBlAudit.26' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:75px;'><spring:message code='ezApprovalG.apprBlAudit.27' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:75px;'><spring:message code='ezApprovalG.apprBlAudit.28' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:100px;'><spring:message code='ezApprovalG.apprBlAudit.29' /></th>";
	        thHtml += "<th name='th_name' class='sorting' style='width:150px;'><spring:message code='ezApprovalG.apprBlAudit.30' /></th>";
	        thHtml += "</tr>";
	        thHtml += "</thead>";
	        $("#table_th").html(thHtml);
	        
	        $("#btnSave").unbind().on("click", function() {
	        	var startDate = $("#startDatePicker").val();
		    	var endDate = $("#endDatePicker").val();
		    	var idx = $("#idx").val();
		    	var startDateSpl;
		    	var endDateSpl;
		    	var params = "";
		    	
		    	if(startDate == "" || startDate == undefined || endDate == "" || endDate == undefined) {
		    		alert("<spring:message code='ezApprovalG.apprBlAudit.03' />");
		    		return;
		    	}
		    	
		    	try {
		    		startDateSpl = startDate.split("-");
			    	endDateSpl = endDate.split("-");
			    	startDate = "";
		    		endDate = "";
		    		
		    		if(startDateSpl.length != endDateSpl.length) {
		    			alert("<spring:message code='ezApprovalG.apprBlAudit.04' />");
			    		return;
		    		}
			    	
		    		// 20201212 form 으로 변경
			    	for(var i=0; i<startDateSpl.length; i++) {
			    		startDate += startDateSpl[i];
			    		endDate += endDateSpl[i];
			    	}
			    	startDate = startDate.addstring("R", "0", 14, 0);
			    	endDate += "235959";
		    	} catch(e) {
		    		alert("<spring:message code='ezApprovalG.apprBlAudit.04' />");
		    		return;
		    	}
		    	
		    	// 공통
		    	params += "fileType=" + "excel";
		    	params += "&fileName=" + "<spring:message code='main.t98' />";
		    	params += "&fileExt=" + "xlsx";
		    	params += "&listType=" + "list";
		    	params += "&listName=" + "getAuditStatisticsDocList";
		    	params += "&header=";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.23' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.24' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.25' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.26' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.27' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.28' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.29' />;";
		    	params += "<spring:message code='ezApprovalG.apprBlAudit.30' />";
		    	params += "&width=" + "6000;5000;5000;10000;5800;5800;3000;5000";
		    	// 그 외 (dao)
		    	params += "&startDate=" + startDate;
		    	params += "&endDate=" + endDate;
		    	params += "&idx=" + idx;
	        	
		    	listLoading(true);
		    	listExcelDown(params);
	        });
	        
			$("#btnInit").unbind().on("click", function() {
				$("#startDatePicker").val("");
				$("#endDatePicker").val("");
				$("#idx").val("4");
	        });
	        
		    $("#btnSearch").unbind().on("click", function() {
		    	var startDate = $("#startDatePicker").val();
		    	var endDate = $("#endDatePicker").val();
		    	var idx = $("#idx").val();
		    	var startDateSpl;
		    	var endDateSpl;
		    	
		    	if(startDate == "" || startDate == undefined || endDate == "" || endDate == undefined) {
		    		alert("<spring:message code='ezApprovalG.apprBlAudit.03' />");
		    		return;
		    	}
		    	
		    	try {
		    		startDateSpl = startDate.split("-");
			    	endDateSpl = endDate.split("-");
			    	startDate = "";
		    		endDate = "";
		    		
		    		if(startDateSpl.length != endDateSpl.length) {
		    			alert("<spring:message code='ezApprovalG.apprBlAudit.04' />");
			    		return;
		    		}
			    	
		    		// 20201212 form 으로 변경
			    	for(var i=0; i<startDateSpl.length; i++) {
			    		startDate += startDateSpl[i];
			    		endDate += endDateSpl[i];
			    	}
			    	startDate = startDate.addstring("R", "0", 14, 0);
			    	endDate += "235959";
		    	} catch(e) {
		    		alert("<spring:message code='ezApprovalG.apprBlAudit.04' />");
		    		return;
		    	}
		    	
		    	$("#tbody_docList").html("");
		    	listLoading(true);
		    	
		    	$.ajax({
		    		type : "POST"
		    		,dataType : "json"
		    		,async : true
		    		,url : "/admin/ezApprovalG/getAuditStatisticsDocList.do"
		    		,data : {
		    			startDate : startDate
		    			,endDate : endDate
		    			,idx : idx
		    		}
		    	})
		    	.success(function(res) {
		    		var rows = res.rows;
		    		var result = res.result;
		    		
		    		listLoading(false);
		    		
		    		if(result) {
		    			//console.log(res);
		    			addRows(idx, rows);
		    		} else {
		    			console.log("getAuditStatisticsDocList result false, " + result);
		    			alert("<spring:message code='ezApprovalG.apprBlAudit.17' />");
		    		}
		    	})
		    	.fail(function(fail) {
		    		console.log("getAuditStatisticsDocList fail, " + fail);
		    		var rows = JSON.parse(fail.responseText);
		    		var result = fail.result;
		    		
		    		listLoading(false);
		    		
		    		if(fail.status == 200) {
		    			addRows(idx, rows);
		    		} else {
		    			alert("<spring:message code='ezApprovalG.apprBlAudit.17' />");
		    		}
		    	});
		    });
		});
		</script>
	</head>
	
	<body class="mainbody">
		<h1>
			<spring:message code='main.t98'/>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select class="companySelect" id="ListCompany" onChange="selectCompanyID()">
	        	<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
		    </select>
		</h1>
		<table class="content" style="width: 980px;">
			<tr>
				<th><spring:message code='ezApprovalG.t1298'/></th>
				<td>
					<input readonly type="text" id="startDatePicker" class="text">
					<span>~</span>
       				<input readonly type="text" id="endDatePicker" class="text">
       				<span></span>
       				<select id="idx" style="margin-right:20px;">
						<option value="4"><spring:message code='ezApprovalG.select' /></option>
						<option value="0"><spring:message code='ezOrgan.t9904' /></option>
						<option value="1"><spring:message code='ezApprovalG.apprBlAudit.31' /></option>
						<option value="2"><spring:message code='ezOrgan.t9902' /></option>
						<option value="3"><spring:message code='ezOrgan.t9903' /></option>
       				</select>
   					<a id="btnSearch" class="imgbtn imgbck"><span><spring:message code='ezApprovalG.submit'/></span></a>
   					<a id="btnInit" class="imgbtn imgbck"><span><spring:message code='ezApprovalG.initialize'/></span></a>
   					<a id="btnSave" class="imgbtn imgbck"><span><spring:message code='main.sp09'/></span></a>
				</td>
			</tr>					
		</table>
		<br>
		<div id="lvSDoc" class="row align-items-center justify-content-between">
			<table id="table_th" class="mainlist dataTable no-footer"></table>
		</div>
		<div id="div_docList" class="row align-items-center justify-content-between" style="max-height:640px;overflow-x:hidden;overflow-y:auto;">
			<table id="table_docList" class="mainlist dataTable no-footer">
				<tbody id="tbody_docList" style="background-color: rgb(255, 255, 255);"></tbody>
			</table>
		</div>
	</body>
</html>