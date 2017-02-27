<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>        
		<title><spring:message code='ezSchedule.t233'/></title>
		<script>
			var scheduleid = "<c:out value='${scheduleId}'/>";
			var changekey = "";
			var scheduletype = "";
			var datetype = "";
			var pattern = "";
			var startTime = "";
		    var endTime = "";
		    var ownerid = "<c:out value='${ownerId}'/>";
								
		    function show_personinfo(userid) {
		        var feature = GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
			
		    var OpenWin;
		    var schedule_select_attendant_dialogArguments = new Array();
		    function add_attendant() {
		        schedule_select_attendant_dialogArguments[0] = "";
		        schedule_select_attendant_dialogArguments[1] = add_attendant_Complete;
		        OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.t234' />") + "&StartTime=" + startTime + "&EndTime=" + endTime, "schedule_group_write", GetOpenWindowfeature(950, 680));
		        try { OpenWin.focus(); } catch (e) { }     
		    }
			
		    function add_attendant_Complete(rtn) {
		        if (typeof (rtn) != "undefined") {
		            if (rtn["id"].length == 0)
		                return;
	
		            var memberList = new Array();
		            var count = 0;
		            
		            OpenWin.focus();
		            
		            for (var i = 0; i < rtn["id"].length; i++) {
		                var isExist = false;
		                var checks = document.getElementById("receivelist").getElementsByTagName("input");
		                for (var j = 0; j < checks.length; j++) {
		                    if (GetAttribute(checks.item(j), "attendantid") == rtn["id"][i]) {
		                    	OpenWin.alert("'" + rtn["name"][i] + "'<spring:message code='ezSchedule.t235' />");
		                        isExist = true;
		                        break;
		                    }
		                }
		                if (isExist) continue;
		                
		                var data = new Object();
	                    data.attendantId = rtn["id"][i];
	                    data.attendantName = rtn["name"][i];
	                    data.attendantName1 = rtn["name1"][i];
	                    data.attendantName2 = rtn["name2"][i];
	                    data.attendantDeptName = rtn["deptname"][i];
	                    data.attendantDeptName2 = rtn["deptname2"][i];

	                    memberList.push(data);
	                    count++;
		            }
	
		            if (count == 0) {
	                    return;
	                }	
     
		            $.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezSchedule/scheduleAddAttendant.do",
						data : {						
							scheduleId 	 : scheduleid,						
							memberList : JSON.stringify(memberList)
						},
						success: function(result) {							
							OpenWin.alert("<spring:message code='ezSchedule.t237' />");
							OpenWin.close();
							
			                try {
			                    window.opener.location.reload(false);
			                } catch (e) { }
		
			                window.location.reload(false);			              	
						},
						error: function() {							
							OpenWin.alert("<spring:message code='ezSchedule.t236' />");
							OpenWin.close();
						}
		            });	
		        }
		    }
	
		    function del_attendant() {
		        var checks = document.getElementById("receivelist").getElementsByTagName("input")
		        var check_Value = true;		        	
		        var count = 0;		        
		        var attendantIdList = new Array();
		        
		        for (var i = 0; i < checks.length; i++) {
		            if (checks.item(i).checked == check_Value) {
		                count++;
		                
		                attendantIdList[i] = GetAttribute(checks.item(i), "attendantid");	                
		            }
		        }

		        check_Value = count;
	
		        if (check_Value == 0) {
		            alert("<spring:message code='ezSchedule.t238' />");
		            return;
		        }
	
		        if (!confirm((check_Value) + "<spring:message code='ezSchedule.t239' />"))
		            return;
		        
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleDelAttendant.do",
					data : {						
						scheduleId 	 : scheduleid,						
						attendantIdList : attendantIdList
					},
					success: function(result) {
						alert((check_Value) + "<spring:message code='ezSchedule.t241' />");
						
			            try {
			                window.opener.location.reload(false);
			            } catch (e) { }
		
			            window.location.reload(false);
					},
					error: function() {
						alert("<spring:message code='ezSchedule.t240' />");
					}
				});		       
		    }
		</script>
	</head>
	
	<body class="popup" style="overflow:hidden"> 
		<form method="post"> 
			<div id="menu">
		  		<ul>
		    		<li><span onClick="add_attendant()" title="<spring:message code='ezSchedule.t247' />"><spring:message code='ezSchedule.t186' /></span></li>
		    		<li><span onClick="del_attendant()" title="<spring:message code='ezSchedule.t248' />"><spring:message code='ezSchedule.t188' /></span></li>
		  		</ul>
			</div>
			<div id="close">
		  		<ul>
		    		<li><span onClick="window.close()"><spring:message code='ezSchedule.t16' /></span></li>
		  		</ul>
			</div>		
			<div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:auto; WIDTH:505px; HEIGHT:277px"> 
		  		<table style="width:100%" class="popuplist">
		    		<tr> 
		            	<th style="width:40px; text-align:center"><spring:message code='ezSchedule.t190' /></th> 
		            	<th style="width:60px; white-space:nowrap"><spring:message code='ezSchedule.t163' /></th> 
		            	<th style="width:100px; white-space:nowrap"><spring:message code='ezSchedule.t250' /></th> 
		            	<th style="width:60px; white-space:nowrap"><spring:message code='ezSchedule.t164' /></th> 
		            	<th style="white-space:nowrap"><spring:message code='ezSchedule.t165' /></th> 
		            </tr> 
		            <c:forEach var="item" items="${attendantList}">
		            <tr> 
		            	<td style="text-align:center">
		            		<input type='checkbox' value="1" attendantid='${item.attendantId}' attendantstatus='${item.status}' />
		            	</td> 
		                <td title="<spring:message code='ezSchedule.t162' />" onClick="show_personinfo('${item.attendantId}')"  style="cursor:pointer; white-space:nowrap">
		                	<c:if test="${primary == '1'}">${item.attendantName}</c:if>
		                	<c:if test="${primary != '1'}">${item.attendantName2}</c:if>
						</td>
		                <td noWrap>
		                	<c:if test="${primary == '1'}">${item.attendantDeptName}</c:if>
		                	<c:if test="${primary != '1'}">${item.attendantDeptName2}</c:if>
		                </td>
		                <td style="white-space:nowrap">
		                	<c:if test="${item.status == '0'}"><spring:message code='ezSchedule.t166' /></c:if>
		                	<c:if test="${item.status == '1'}"><spring:message code='ezSchedule.t251' /></c:if>
		                	<c:if test="${item.status == '2'}"><spring:message code='ezSchedule.t168' /></c:if>
		                	<c:if test="${item.status == '3'}"><spring:message code='ezSchedule.t169' /></c:if>		                	
		                </td> 
		                <td style="white-space:nowrap">
		                	<c:if test="${item.status == '0'}">&nbsp;</c:if>
		                	<c:if test="${item.status != '0'}">${fn:substring(item.responseDate,0,16)}</c:if>		                	
		                </td> 
					</tr>	
		            </c:forEach>            
				</table> 
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			</script>
		</form> 
	</body>
</html>