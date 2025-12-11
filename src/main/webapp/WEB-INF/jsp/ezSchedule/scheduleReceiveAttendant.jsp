<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_read_Cross.js')}"></script>
<%-- 		<title><spring:message code='ezSchedule.t332'/></title> --%>
		<script>
			var parentwin = null;
			var RetValue;
			var ReturnFunction;
			var serverFlag = "<c:out value='${serverFlag}' />";
			var receiveList = "<c:out value='${receiveList}' />";
			var dotnetURL = "<c:out value='${serverName}' />";
			
			window.onload = function () {
			    try {
			        RetValue = parent.schedule_receive_attendant_cross_dialogArguments[0];
			        ReturnFunction = parent.schedule_receive_attendant_cross_dialogArguments[1];
			    } catch (e) {
			        try {
			            RetValue = opener.schedule_receive_attendant_cross_dialogArguments[0];
			            ReturnFunction = opener.schedule_receive_attendant_cross_dialogArguments[1];
			        } catch (e) {
			            RetValue = window.dialogArguments;
			        }
			    }
			    parentwin = RetValue;
			    
			    showDateType();
			    
			    var checks2 = document.getElementById("receivelist").getElementsByTagName("input");
				if( checks2.length == 0)	{
					alert("<spring:message code='ezSchedule.mail.hth34'/>");
					window.close();
				}
			}
	
			function accept_schedule(status)
			{
			    var checks = document.getElementById("receivelist").getElementsByTagName("input");
				var count = 0;
				var scheduleIdList = new Array();
				var creatorList = new Array();
				
				for (var i=0; i<checks.length; i++) {
					if (checks.item(i).checked == true)	{
					    scheduleIdList[count++] = GetAttribute(checks.item(i), 'scheduleid');					    
					    //count++;
					    
					    var data = new Object();
					    data.creatorId = GetAttribute(checks.item(i), 'creatorId');	
					    data.creatorName = GetAttribute(checks.item(i), 'creatorName');	
					    data.title = checks.item(i).parentElement.parentElement.lastElementChild.previousElementSibling.textContent;
					    data.dateType = GetAttribute(checks.item(i).parentElement.parentElement.lastElementChild, 'dateType');
					    data.startDate = GetAttribute(checks.item(i).parentElement.parentElement.lastElementChild, 'startdate');
					    data.endDate = GetAttribute(checks.item(i).parentElement.parentElement.lastElementChild, 'enddate');
					    data.showtop = GetAttribute(checks.item(i).parentElement.parentElement.lastElementChild, 'showtop');
					    data.repetition = GetAttribute(checks.item(i).parentElement.parentElement.lastElementChild, 'repetition');
					    creatorList.push(data);
					}
				}
	
				if (count == 0) {
					alert("<spring:message code='ezSchedule.t333' />");
					return;
				}		
				
				var url = "/ezSchedule/scheduleAcceptAttendant.do";
				
				if (serverFlag == "dotNet") {
					url = dotnetURL + "/ezSchedule/scheduleAcceptAttendant.do";
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : url,
					data : {						
						status 	 : status,
						displayName : "${userInfo.displayName1}",
						displayName2 : "${userInfo.displayName2}",
						scheduleIdList : scheduleIdList,
						creatorList : JSON.stringify(creatorList)
					},
					success: function(result) {
						if (status == "1")
						{
							window.returnValue = "1";
							alert("<spring:message code='ezSchedule.t336' />");
						} else
							alert("<spring:message code='ezSchedule.t337' />");
		
					    var checks = document.getElementById("receivelist").getElementsByTagName("input");
						for (var i=checks.length-1; i>-1; i--)
						{
							if (checks.item(i).checked == true)
								checks.item(i).parentElement.parentElement.parentElement.removeChild(checks.item(i).parentElement.parentElement);
						}
						
					},
					error: function() {
						if (status == "1")
							alert("<spring:message code='ezSchedule.t334' />");
						else
							alert("<spring:message code='ezSchedule.t335' />");
					}					
				});
				var checks2 = document.getElementById("receivelist").getElementsByTagName("input");
				if( checks2.length==0 )	{
					if (ReturnFunction != null) {
						ReturnFunction("success");
					}
					
					window.close();
				}
				
				if(parent.parent.frames["right"].groupcount != null && parent.parent.frames["right"].groupcount == "0") {
					parent.parent.frames["left"].document.body.removeAttribute('style');
				}
			}
	
			function closePopup(){
				if(ReturnFunction != null) {
					
					if(parent.parent.frames["right"].groupcount == "0") {
						parent.parent.frames["left"].document.body.removeAttribute('style');
					}
					
					ReturnFunction("cancel");
					window.close();
				} else {
					window.close();
				}
				
			}
			
// 			window.onbeforeunload = function () {
// 		   		if (ReturnFunction != null) {
// 		        	ReturnFunction();	
// 		    	}
// 			}

			function showDateType() {
				$( ".showDateType" ).each(function(index) {
					var dateType = $( this ).attr('dateType');
					var startDate = $( this ).attr('startDate');
					var endDate = $( this ).attr('endDate');
					var showtop = $( this ).attr('showtop');
					var timeString = "";
					switch (dateType) {
						case "1":
							timeString = makeScheduleTimeString(startDate, endDate);
							$( this ).text(timeString);
							break;
						case "2":
							timeString = makeAllDayScheduleTimeString(startDate, endDate);
							$( this ).text(timeString);
							break;
						case "3":
							var repetition = $( this ).attr('repetition');
							timeString = makeRepetitionScheduleString(startDate, endDate, repetition);
							$( this ).text(timeString);
							break;
					}
				});
			}
			
			function open_schedule_in_receiveAttendant(scheduleid, isReceive) {
		        var feature = GetOpenPosition(790, 670);
		        window.open("/ezSchedule/scheduleRead.do?id=" + encodeURIComponent(scheduleid) + "&isReceive=" + encodeURIComponent(isReceive), "",
					"height = 670px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
			
			function show_personinfo(userid) {
		        var feature = GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + userid, "",
				    "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
			
		</script>
	</head>
	
	<body class="popup"> 
	    <form method="post">
			<div id="popuptitle"><h1><spring:message code='ezSchedule.t332'/></h1></div>
	        <div id="close">
	            <ul>
<%-- 	                <li><span onClick="window.close()"><spring:message code='ezSchedule.t16' /></span></li> --%>
	                <li><span onClick="closePopup()"></span></li>
	            </ul>
	        </div> 
	
	        <div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; max-height: 370px;">
	            <table class="popuplist" style="WIDTH: 100%">
	                <tr>
	                    <th style="white-space:nowrap; text-align:center; width:20px"><spring:message code='ezSchedule.t190' /></th> 
	                    <th style="white-space:nowrap; text-align:center; width:40px"><spring:message code='ezSchedule.t340' /></th> 
	                    <th style="white-space:nowrap; text-align:center; width:60px"><spring:message code='ezSchedule.t164' /></th> 
	                    <th style="white-space:nowrap; text-align:center; width:100px"><spring:message code='ezSchedule.t341' /></th> 
	                    <th style="white-space:nowrap; text-align:center;"><spring:message code='ezSchedule.t272' /></th> 
	                    <th style="text-align:center;"><spring:message code='ezSchedule.t318' /></th> 
	                </tr> 
	              	<c:forEach var="item" items="${receiveList}">
	              	<tr> 
	                    <td style="text-align:center">
	                    	<input type='checkbox' value="1" scheduleid='${item.scheduleId}' creatorId='${item.creatorId}' creatorName='${item.creatorName}' />
	                    </td>
	                    <c:choose>
	                    	<c:when test = "${from == 'mail'}">
	                    	<td title="<spring:message code='ezSchedule.t162' />" style="cursor:pointer; text-align:center;" onClick="show_personinfo('${item.creatorId}')">
	                    	</c:when>
	                    	<c:otherwise>
	                    	<td title="<spring:message code='ezSchedule.t162' />" style="cursor:pointer; text-align:center;" onClick="parentwin.show_personinfo('${item.creatorId}')">
	                    	</c:otherwise>
	                    </c:choose>
	                    	<c:if test="${userInfo.primary == '1'}">${item.creatorName}</c:if>
	                    	<c:if test="${userInfo.primary != '1'}">${item.creatorName2}</c:if>	                    
	                    </td> 
	                    <td style="text-align:center;">
	                    	<c:if test="${item.status == '0'}"><spring:message code='ezSchedule.t166' /></c:if>
	                    	<c:if test="${item.status != '0'}"><spring:message code='ezSchedule.t169' /></c:if>
	                    </td> 
	                    <td style="text-align:center;"><c:out value="${item.location }" /></td> 
	                    <td title="<spring:message code='ezSchedule.t342' />" style="word-break:break-all; cursor:pointer; text-overflow:ellipsis; overflow:hidden; text-align:center;" onClick="open_schedule_in_receiveAttendant('${item.scheduleId}', 'Y')"><c:out value="${item.title}" /></td> 
	                    <td class="showDateType" style="text-align:center;" startDate="${item.startDate}" endDate="${item.endDate}" dateType="${item.dateType}" repetition="${item.repetition}" showtop="${item.showtop}"></td>
	                </tr>	              		
	              	</c:forEach>	                 
	            </table>
	            <div class="btnposition btnpositionNew">
				    <a class="imgbtn" onClick="accept_schedule('1')" ><span><spring:message code='ezSchedule.t338' /></span></a>
				    <a class="imgbtn" onClick="accept_schedule('2')" ><span><spring:message code='ezSchedule.t339' /></span></a>
				</div>
	        </div>
	    </form> 
	</body>
</html>