<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t141'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/lang/ezSchedule.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		
		<script type="text/javascript">
			var attModId = "<c:out value='${attModId}'/>";
			var companyId = "${companyId}";
			
			window.onload = function () {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
				
				history();
			}
			
			function history() {				
	 			$.ajax({
					type : 'get',
					url : '/ezAttitude/getAttHistory.do',
				    data : {
				    	attModId : attModId,
				    	companyId : companyId
				    },
			    	dataType : "json",
			    	error: function(xhr, status, error){
			    	ajaxRunning = false;
			    	},
					success : function(json){
				    	if (json.length == 0) {
				    		var objTr = $("<tr></tr>").append($("<td colspan='6' style='text-align:center; width:440px;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
				    		
				    		$("#addpopup_list tbody").append(objTr);
				    	}
				    	
				    	for(var i = 0; i < json.length; i++) {
							if (json.length == 1 && json[i].apprStatus == 0) {
								var objTr = $("<tr></tr>").append($("<td colspan='6' style='text-align:center; width:440px;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
					    		
					    		$("#addpopup_list tbody").append(objTr);
				    		} else {
				    			var name = json[i].apprUserName;
				    			
				    			if (json[i].apprStatus == 1) {
					    			json[i].apprStatus = "<spring:message code='ezAttitude.t210'/>";
					    		} else if (json[i].apprStatus == 2){
					    			json[i].apprStatus = "<spring:message code='ezAttitude.t211'/>";
					    		} else {
					    			json[i].apprStatus = "<spring:message code='ezAttitude.t209'/>";
					    		}
					    		
				    			if (json[i].apprDate != null) {
				    				json[i].apprDate = json[i].apprDate.substring(0,16);
				    			}
				    			
				    			if (json[i].apprDate == null) {
				    				json[i].apprDate = "";
				    			}
				    			
				    			if (json[i].apprUserName == null) {
				    				json[i].description = "";
				    				json[i].apprUserName = "";
				    				json[i].title = "";
				    				name = "";
				    			}
				    			
				    			//"\u00a0"
					    		var objTr = $("<tr></tr>").append($("<td style='width:15%'></td>").append($("<div style='text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(json[i].originDate.substring(0,11))));
					    		objTr.append($("<td style='width:15%'></td>").append($("<div style='text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(json[i].originDate.substring(11,16))));
					    		objTr.append($("<td style='width:15%'></td>").append($("<div style='text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(json[i].changeDate.substring(11,16))));
					    		objTr.append($("<td style='width:15%' title='" + json[i].description + " " + json[i].apprUserName + " " + json[i].title + "'></td>").append($("<div style='padding-left: 5px;padding-right: 5px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(name)));
					    		objTr.append($("<td style='width:25%'></td>").append($("<div style='text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(json[i].apprDate)));
					    		objTr.append($("<td style='width:15%'></td>").append($("<div style='text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(json[i].apprStatus)));
					    		
					    		$("#addpopup_list tbody").append(objTr);
				    		}
				    	}
					}
				});
			}
	 			
			
		   
		</script>
	</head>
	<body class="popup"">
		<h1>
			<spring:message code='ezAttitude.t141'/>
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <!-- 리스트 -->
		<div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
					<th style="width:15%;text-align:center"><spring:message code='ezAttitude.t107'/></th>
					<th style="width:15%;text-align:center"><spring:message code='ezAttitude.t206'/></th>
					<th style="width:15%;text-align:center"><spring:message code='ezAttitude.t207'/></th>
					<th style="width:15%;text-align:center"><spring:message code='ezAttitude.t104'/></th>
					<th style="width:25%;text-align:center"><spring:message code='ezAttitude.t116'/></th>
					<th style="width:15%;text-align:center"><spring:message code='ezAttitude.t208'/></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 156px; overflow-y: auto;">
                <table id="addpopup_list" class="mainlist" style="width: 100%;">
                	<tbody>
                    </tbody>
                </table>
            </div>
        </div>
	</body>
</html>