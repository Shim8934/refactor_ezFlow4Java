<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezResource.kwc03'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=uft-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/organtreeview.htc.js')}"></script> 
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<style type="text/css">
			select {
				height: auto;
				font-size: 12px !important;
			}
			
			.resTr {
				height:30px;
				border:1px solid #f5f6f6;
			}
			
			.resTd {
				width:150px;
				text-align:center;
				BORDER-RIGHT:#f5f6f6 1px solid;
				cursor: default;
			}
		
		</style>
		<script ID="clientEventHandlersJS" type="text/javascript">
			var tenantId = "<c:out value ='${tenantId}'/>";
			var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
			var pCompanyName = "<c:out value ='${userInfo.companyName}'/>";
			var searchStartTime = "";
			var searchEndTime = "";
			var startDate = "";
			var endDate = "";
			var resOccuListLength = 0;
			var resOccuList;
			
			window.onload = function () {
				listLoading(true);
				setTimeout(function() {
		   			getResourceList();
		   		}, 0);
			}
			
			$(function () {
	            $("#Sdatepicker").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true,
	                onSelect: function(selected) {
	                	compareDateStart();
		    		}
	            });
	            $("#Sdatepicker2").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true,
	                onSelect: function(selected) {
		    			compareDateEnd();
		    		}
	            });
	            var NowDate = new Date();
	            var NowDate2 = new Date();
	            NowDate.setDate(NowDate.getDate() - 30);
	            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker").datepicker('setDate', NowDate);
	            $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker2").datepicker('setDate', NowDate2);
	        });
			
	        $(function () {
	        	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
	        		closeText: "<spring:message code='main.t3' />",
	 		        prevText: "<spring:message code='main.t0604' />",
	 		        nextText: "<spring:message code='main.t0605' />",
	 		        currentText: "<spring:message code='main.t0606' />",
	 		        monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	 		                     "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	 		                     "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	 		                     "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	 		        monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	 		                          "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	 		                          "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	 		                          "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	 		        dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	 		                   "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	 		                   "<spring:message code='main.t0627' />"],
	 		        dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	 				                   "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	 				                   "<spring:message code='main.t0627' />"],
	 		        dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	 			                   "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	 			                   "<spring:message code='main.t0627' />"],
	 		        weekHeader: "Wk",
	 		        dateFormat: "yy-mm-dd",
	 		        firstDay: 0,
	 		        isRTL: false,
	 		        duration: 200,
	 		        showAnim: "show",
	 		        showMonthAfterYear: true
	            };
	        	$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	        });
	        
	        function compareDateStart() {
				startDate = new Date($("#Sdatepicker").datepicker("getDate"));
				endDate = new Date($("#Sdatepicker2").datepicker("getDate"));
				
				if (startDate - endDate > 0) {
					std = $('#Sdatepicker').val();
    				$('#Sdatepicker2').val(std);
				}		
				
			}
		   	
		   	function compareDateEnd() {
				startDate = new Date($("#Sdatepicker").datepicker("getDate"));
				endDate = new Date($("#Sdatepicker2").datepicker("getDate"));
				
				if (endDate - startDate < 0) {
					etd = $('#Sdatepicker2').val();
					$('#Sdatepicker').val(etd);
				} 
			}
		   	
		   	function search() {
		   		listLoading(true);
		   		setTimeout(function() {
		   			getResourceList();
		   		}, 0);
		   	}
		   	
		   	function getResourceList() {
		   		
		   		searchStartTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		   		searchEndTime = $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		   		
		   		$.ajax({
            		type : "GET",
            		dataType : "json",
            		async : false,
            		url : "/ezResource/getResOccuList.do",
            		data : {
            			searchStartTime : searchStartTime,
            			searchEndTime : searchEndTime,
            			pCompanyID : pCompanyID,
            			pCompanyName : pCompanyName
            		},
            		success: function(data) {
						resOccuList = data.getResOccuList;
						var totalTime = data.totalTime;
						makeList(resOccuList, totalTime);
            		}        			
            	});
		   	}
		   	
		   	function makeList(resOccuList, totalTime) {
		   		var list = "";
		   		if (resOccuList.length > 0) {
		   			for (var i = 0; i < resOccuList.length; i++) {
		   				list += "<tr class=\"resTr\">";
		   				list += "<td class=\"resTd\">" + resOccuList[i].companyName + "</td>";
		   				list += "<td class=\"resTd\">" + resOccuList[i].brdNm + "</td>";
		   				list += "<td class=\"resTd\">" + resOccuList[i].count + "</td>";
		   				list += "<td class=\"resTd\">" + resOccuList[i].usageTime + "</td>";
		   				if (i == 0) {
		   					list += "<td rowspan=\"" + resOccuList.length + "\" id=\"rowspan\" class=\"resTd\">" + totalTime + "</td>";
		   				}
		   				list += "<td class=\"resTd\">" + resOccuList[i].occupancy + "</td>";
		   				list += "</tr>"
		   			}
		   		} else {
		   			
		   			list += "<tr class=\"resTr\">";
		   			list += "<td colspan=\"6\" class=\"resTd\">" + "<spring:message code="ezResource.kwc05"/>" + "</td>";
		   			list += "</tr>"
		   		}
		   		resOccuListLength = resOccuList.length;
		   		document.getElementById("resBody").innerHTML = list;
		   		listLoading(false);
		   	}
		   	
		   	function close_onclick() {
		   		parent.resClose_onclick();
		   	}
		   	
		   	function outExcel() {
		   		document.getElementById("searchStartTime").value = searchStartTime;
		   		document.getElementById("searchEndTime").value = searchEndTime;
		   		document.getElementById("pCompanyID").value = pCompanyID;
		   		document.getElementById("pCompanyName").value = pCompanyName;
		   		if (resOccuListLength == 0) {
		   			alert("<spring:message code='ezApprovalG.pjg03'/>");
		   		} else {
		   			document.getElementById("formAgent").target = "saveExcel";
		        	document.getElementById("formAgent").submit();
		   		}
		   	}
		</script>
	
	</head>
	<body class="popup">
		<div>
			<h1><spring:message code='ezResource.kwc03'/></h1>
			<div id="close">
	            <ul>
	                <li><span onclick="return close_onclick();"></span></li>
	            </ul>
	        </div>
	        
	        <div>
	        	<input type="text" id="Sdatepicker" class="hasDatapicker" style="width: 100px; text-align: center; margin-left:15px" readonly="readonly" /> ~ 
				<input type="text" id="Sdatepicker2" class="hasDatapicker" style="width: 100px; text-align: center;" readonly="readonly" />
				<a class="imgbtn" style="margin-left:7px;">
					<span onclick="javascript:search();"><spring:message code="ezResource.kwc02"></spring:message></span>
				</a>
				<a class="imgbtn" style="margin-left:7px;">
					<span onclick="javascript:outExcel();"><spring:message code="ezResource.kwc04"></spring:message></span>
				</a>
	        </div>
		</div>
        
        <div>
	        <div id="ResList">
	        	<table id="resTable" style="width:100%; cursor: default; margin-top:20px;">
	       			<tr height="30px">
	       				<th style="width:100px; text-align:center; font-weight:bold"><spring:message code="ezResource.header.kwc1"/></th>
	       				<th style="width:150px; text-align:center; font-weight:bold"><spring:message code="ezResource.header.kwc2"/></th>
	       				<th style="width:100px; text-align:center; font-weight:bold"><spring:message code="ezResource.header.kwc3"/></th>
	       				<th style="width:150px; text-align:center; font-weight:bold"><spring:message code="ezResource.header.kwc4"/></th>
	       				<th style="width:150px; text-align:center; font-weight:bold"><spring:message code="ezResource.header.kwc5"/></th>
	       				<th style="width:150px; text-align:center; font-weight:bold"><spring:message code="ezResource.header.kwc6"/></th>
	       			</tr>
	       			<tbody id="resBody" style="overflow:auto;">
	       			</tbody>
	        	</table>
	        </div>
      	</div>
      	<div class="btnposition btnpositionNew">
      		<a class="imgbtn">
      			<span id="btn_close" onClick="return close_onclick()"><spring:message code="main.t3"/></span>
      		</a>
      	</div>
      	<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezResource/excelExportOut.do">
      		<input type=hidden id="searchStartTime" name="searchStartTime" value="">
      		<input type=hidden id="searchEndTime" name="searchEndTime" value="">
      		<input type=hidden id="tenantID" name="tenantID" value="">
      		<input type=hidden id="pCompanyID" name="pCompanyID" value="">
      		<input type=hidden id="pCompanyName" name="pCompanyName" value="">
		</form>
		<iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>