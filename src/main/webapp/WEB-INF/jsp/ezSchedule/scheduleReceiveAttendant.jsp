<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
<%-- 		<title><spring:message code='ezSchedule.t332'/></title> --%>
		<script>
			var parentwin = null;
			var RetValue;
			var ReturnFunction;
			var serverFlag = "<c:out value='${serverFlag}' />";
			var receiveList = "<c:out value='${receiveList}' />";
			
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
			}
	
			function accept_schedule(status)
			{
			    var checks = document.getElementById("receivelist").getElementsByTagName("input");
				var count = 0;
				var scheduleIdList = new Array();
				
				for (var i=0; i<checks.length; i++) {
					if (checks.item(i).checked == true)	{
					    count++;
					    scheduleIdList[i] = GetAttribute(checks.item(i), 'scheduleid');					    
					}
				}
	
				if (count == 0) {
					alert("<spring:message code='ezSchedule.t333' />");
					return;
				}		
				
				var url = "/ezSchedule/scheduleAcceptAttendant.do";
				
				if (serverFlag == "dotNet") {
					url = "http://dev.mail.kttelecop.co.kr/ezSchedule/scheduleAcceptAttendant.do";
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
						scheduleIdList : scheduleIdList
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
					ReturnFunction("success");
					window.close();
				}
				if(parent.parent.frames["right"].groupcount == "0") {
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
			
			function makeScheduleTimeString(startDate, endDate) {
				var timeString = startDate.substring(0,16) + " ~ " + endDate.substring(0,16);
        		return timeString;
			}
			
			function makeAllDayScheduleTimeString(startDate, endDate) {
				var timeString;
				if (startDate.substring(0,10) == endDate.substring(0,10)) {
					timeString = startDate.substring(0,10) + " (" + strLang105 + ")";
				} else {
					timeString = startDate.substring(0,10) + " ~ " + endDate.substring(0,10) + " (" + strLang105 + ")";
				}
			}
			
			function makeRepetitionScheduleString(startDate, endDate, repetition) {
				var repeatinfo = "";
				var info = repetition.split("|");
				var repetitionType = info[2];
				
				switch (repetitionType) {
					case "0":
						repeatinfo += (info[3] == '0') ? strLang34 : info[3] + strLang81 + " ";
						break;
					case "1":
						if(info[3] == '1'){				
							repeatinfo += strLang35;
							if(info[4]){
								for (var i = 0; i< info[4].length; i++){
									var eachDayOfWeek = info[4].substr(i, 1);
									var dayOfWeekStringInfo = makeStringDayofWeekInfo(eachDayOfWeek);
									if (i>0) {
										repeatinfo += ',';
									}
									repeatinfo += dayOfWeekStringInfo;
								}
							}
						}else{
							repeatinfo += info[3] + strLang82 + " ";
							if(info[4]){
								for (var i = 0; i< info[4].length; i++){
									var eachDayOfWeek = info[4].substr(i, 1);
									var dayOfWeekStringInfo = makeStringDayofWeekInfo(eachDayOfWeek);
									if (i>0) {
										repeatinfo += ',';
									}
									repeatinfo += dayOfWeekStringInfo;
								}
							}
						}
						break;
				    case "2":
				    	if(info[3] == '1'){
							repeatinfo += info[4] + strLang83 + " ";
							repeatinfo += info[5] + strLang80 + " ";
						}else{					
							repeatinfo += info[4] + strLang83 + " ";
							for (var i = 0; i< info[5].length; i++){
								var weekNumberInfo = makeStringWeekNumber(info[5]);
								repeatinfo += weekNumberInfo; 
							}
							repeatinfo += " ";
							for (var i = 0; i < info[6].length; i++) {
								var idx = info[6].substr(i, 1);
								var dayOfWeekStringInfo = makeStringDayofWeekInfo(idx);
								if (i>0) {
									repeatinfo += ',';
								}
								repeatinfo += dayOfWeekStringInfo;
							}
						}
						break;
					case "3":
						if (info[3] == '1'){
							repeatinfo += strLang37 + " ";
							repeatinfo += info[4] + strLang122 + " ";
							repeatinfo += info[5] + strLang81;
						} else {	
							repeatinfo += strLang37 + " ";
							repeatinfo += info[4] + strLang122 + " ";
							for (var i = 0; i< info[5].length; i++){
								var weekNumberInfo = makeStringWeekNumber(info[5]);
								repeatinfo += weekNumberInfo;
							}
							repeatinfo += " ";
							for (var i = 0; i < info[6].length; i++) {
								var idx = info[6].substr(i, 1);
								var dayOfWeekStringInfo = makeStringDayofWeekInfo(idx);
								repeatinfo += dayOfWeekStringInfo;
							}
						}
					break;
				}	

				repeatinfo += " ";
				
				if (info[1] == "1") {					// 하루종일 일정
					repeatinfo += strLang39;
				} else {
					repeatinfo += startDate.substring(10,16) + " ~ " +endDate.substring(10,16);
				}
				
				if (info[0] == -1) {
				    repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + strLang46;
				} else if (info[0] == 0){
					repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + endDate.substring(0,10);
				} else {
					repeatinfo += " " + startDate.substring(0,10) + " ~ " + info[0] + strLang47;
				}
				
				return repeatinfo;
			}
			
			function makeStringDayofWeekInfo(dayOfWeek) {
				var dayOfWeekString;
				switch (dayOfWeek){
					case "0":
						dayOfWeekString = strLang48;
						break;
					case "1":
						dayOfWeekString = strLang49;
						break;
					case "2":
						dayOfWeekString = strLang50;
						break;
					case "3":
						dayOfWeekString = strLang51;
						break;
					case "4":
						dayOfWeekString = strLang52;
						break;
					case "5":
						dayOfWeekString = strLang53;
						break;
					case "6":
						dayOfWeekString = strLang54;
						break;
				}
				return dayOfWeekString;
			}
			
			function makeStringWeekNumber(number) {
				var weekNumber;
				switch (number){
					case "1":
						weekNumber = strLang55;
						break;
					case "2":
						weekNumber = strLang56;
						break;
					case "3":
						weekNumber = strLang57;
						break;
					case "4":
						weekNumber = strLang58;
						break;
					case "5":
						weekNumber = strLang59;
						break;
				}
				return weekNumber;
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
	
	        <div id="receivelist" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:100%; HEIGHT:370px"> 
	            <table class="popuplist" style="WIDTH: 100%">
	                <tr>
	                    <th style="white-space:nowrap; width:20px"><spring:message code='ezSchedule.t190' /></th> 
	                    <th style="white-space:nowrap; width:40px"><spring:message code='ezSchedule.t340' /></th> 
	                    <th style="white-space:nowrap; width:60px"><spring:message code='ezSchedule.t164' /></th> 
	                    <th style="white-space:nowrap; width:100px"><spring:message code='ezSchedule.t341' /></th> 
	                    <th style="white-space:nowrap"><spring:message code='ezSchedule.t272' /></th> 
	                    <th><spring:message code='ezSchedule.t318' /></th> 
	                </tr> 
	              	<c:forEach var="item" items="${receiveList}">
	              	<tr> 
	                    <td style="text-align:center">
	                    	<input type='checkbox' value="1" scheduleid='${item.scheduleId}' />
	                    </td> 
	                    <td title="<spring:message code='ezSchedule.t162' />" style="cursor:pointer" onClick="parentwin.show_personinfo('${item.creatorId}')">
	                    	<c:if test="${userInfo.primary == '1'}">${item.creatorName}</c:if>
	                    	<c:if test="${userInfo.primary != '1'}">${item.creatorName2}</c:if>	                    
	                    </td> 
	                    <td>
	                    	<c:if test="${item.status == '0'}"><spring:message code='ezSchedule.t166' /></c:if>
	                    	<c:if test="${item.status != '0'}"><spring:message code='ezSchedule.t169' /></c:if>
	                    </td> 
	                    <td><c:out value="${item.location }" /></td> 
	                    <td title="<spring:message code='ezSchedule.t342' />" style="word-break:break-all;cursor:pointer;text-overflow:ellipsis;overflow:hidden" onClick="parentwin.open_schedule('${item.scheduleId}')"><c:out value="${item.title}" /></td> 
	                    <td class="showDateType" style="white-space:nowrap" startDate="${item.startDate}" endDate="${item.endDate}" dateType="${item.dateType}" repetition="${item.repetition}">
	                    	
	                    </td> 
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