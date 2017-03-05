<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>poll_edit</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<!-- data picker -->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- time picker -->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css"/>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		
		
		<script type="text/javascript">
			window.onload = function() {
				
			}
			
			$(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        
		        var SDate = new Date("${pStartDate}");
		        var EDate = new Date("${pEndDate}");
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		        //$('#Stimepicker').timepicker();
		        //$('#Stimepicker').timepicker('setTime', SDate);
		        //$('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });

		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		        //$('#Etimepicker').timepicker();
		        //$('#Etimepicker').timepicker('setTime', EDate);
		        //$('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
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
			
			function trim(val){
				s=val.split(" ",val.length);
				
				return s.join("");
			}
			
			function endDate() {
				var now   = new Date();
				var day   = parseInt(poll_edit.startPollDay.value, 10);
				var month = parseInt(poll_edit.startPollMonth.value, 10)-1;
				var year  = parseInt(poll_edit.startPollYear.value, 10);	
				var year2 = parseInt(poll_edit.startPollYear.value, 10);
										
				switch (poll_edit.relatePollDay.value) {
					case "1<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 7);
						break;
					case "2<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 14);
						break;
					case "3<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 21);
						break;
					case "4<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 28);
						break;
				}
			}
									
			function endDateSetting(y,m,d) {
				var tovot = new Date(y, m, d);
				var day = parseInt(tovot.getDate());
				var month = parseInt(tovot.getMonth())-1;
				var year = parseInt(tovot.getFullYear());

				poll_edit.endPollYear.value = year;
				poll_edit.endPollMonth.value = "0" + month;
				poll_edit.endPollDay.value = day;

				day = day-1;
				eval ("poll_edit.endPollMonth.options[" + (month+1) + "].selected = true;");
				eval ("poll_edit.endPollDay.options[" + day + "].selected = true;");	
			}
			
			function poll_send()  {
				if(form_check() == false) {
					return;
				} else {
					poll_edit.submit();
				}
			}
			
			function form_check() {
			    document.getElementById("startPollYear").value = $("#Sdatepicker").datepicker({ dateFormat: 'yy' }).val().substring(0, 4);// document.getElementById("idDatepicker").value.substring(0, 4);
			    document.getElementById("startPollMonth").value = $("#Sdatepicker").datepicker({ dateFormat: 'mm' }).val().substring(5, 7);// document.getElementById("idDatepicker").value.substring(5, 7);
			    document.getElementById("startPollDay").value = $("#Sdatepicker").datepicker({ dateFormat: 'dd' }).val().substring(8, 10);// document.getElementById("idDatepicker").value.substring(8, 10);

			    document.getElementById("endPollYear").value = $("#Edatepicker").datepicker({ dateFormat: 'yy' }).val().substring(0, 4);// document.getElementById("_D2").value.substring(0, 4);
			    document.getElementById("endPollMonth").value = $("#Edatepicker").datepicker({ dateFormat: 'mm' }).val().substring(5, 7);// document.getElementById("_D2").value.substring(5, 7);
			    document.getElementById("endPollDay").value = $("#Edatepicker").datepicker({ dateFormat: 'dd' }).val().substring(8, 10);// document.getElementById("_D2").value.substring(8, 10);

			    var nowdate = new Date();
			    var nowmonth = nowdate.getMonth() + 1;
			    nowmonth = nowmonth < 10 ? "0" + nowmonth : nowmonth;
			    var nowdateDay = nowdate.getDate();
			    nowdateDay = nowdateDay < 10 ? "0" + nowdateDay : nowdateDay;
			    var nowdate2 = nowdate.getFullYear() + "-" + nowmonth + "-" + nowdateDay;

			    if ($("#Edatepicker").datepicker({ dateFormat: 'dd' }).val().substring(0, 10) < nowdate2) {
			        alert("<spring:message code='ezCommunity.t595' />");
			        return false;
			    }
			
				if (trim(poll_edit.pollSubject.value) == "") {
					alert("<spring:message code='ezCommunity.t592' />");
					poll_edit.pollSubject.value = "";
					poll_edit.pollSubject.focus();
					return false;
				}
									
				if (poll_edit.selType.value != 3 ) {
					if( ( poll_edit.selRes1[poll_edit.selRes1.selectedIndex].value == "0" ) && ( poll_edit.selRes2.value == "" ) ) {
						alert("<spring:message code='ezCommunity.t594' />");
						poll_edit.selRes1.focus();
						return false;
					}
				}
			}
			
			function selTypeChange( sel ) {
				poll_edit.selType.selectedIndex = parseInt( sel ) - 1;
			}
			
			function selResChange( sel ) {
				switch (parseInt(sel)) {
					case 0 :
						poll_edit.selRes1.selectedIndex = 0;
						break;				
					case 1 :
						poll_edit.selRes1.selectedIndex = 1;
						break;				
					case 2 :
						poll_edit.selRes1.selectedIndex = 2;
						break;				
					case 3 :
						poll_edit.selRes1.selectedIndex = 3;
						break;				
					case 11 :
						poll_edit.selRes1.selectedIndex = 4;
						break;				
					case 12 :
						poll_edit.selRes1.selectedIndex = 5;
						break;				
					case 13 :
						poll_edit.selRes1.selectedIndex = 6;
						break;				
					case 14 :
						poll_edit.selRes1.selectedIndex = 7;
						break;				
				}
			}
			
			var FixMonth=Array(0,1,2,3,4,5,6,7,8,9,10,11,12);
			var FixSDay=Array(0,31,28,31,30,31,30,31,31,30,31,30,31);
			var FixEDay=Array(0,31,28,31,30,31,30,31,31,30,31,30,31);
			
			function selsyear_onchange() {
				var Year = poll_edit.startPollYear.value;
				
				if((Year%4) && Year%100 || !(Year%400)) {
					return true;
				} else {
					FixSDay[2]=29;
				}
			}
			
			function selsday_onchange() {
				var Month = parseInt(poll_edit.startPollMonth.value);
				var Date = parseInt(poll_edit.startPollDay.value);
				
				if( FixSDay[Month] < Date ) {
					alert("<spring:message code='ezCommunity.t595' />");
					poll_edit.startPollDay.selectedIndex = 0;
					poll_edit.startPollDay.focus();
				}
			}
			
			function selsmonth_onchange() {
				var Month = parseInt(poll_edit.startPollMonth.value);
				
				for(var j = poll_edit.startPollDay.options.length; j >= 0; j--) {
					poll_edit.startPollDay.remove(j);
				}
				
				for(var i = 0;	i < FixSDay[Month]; i++ ) {
					var option = document.createElement("option");
					option.innerText = i+1;
					option.value = i+1;
					
					poll_edit.startPollDay.appendChild(option);  
				}
			}
			
			function seleyear_onchange() {
				if( poll_edit.startPollYear.value == "" || poll_edit.startPollMonth.value == "" || poll_edit.startPollDay.value == "" ) {
					alert("<spring:message code='ezCommunity.t596' />");
					poll_edit.endPollYear.selectedIndex = 0;
					poll_edit.startPollYear.focus();
					
					return;
				}
				
				var Year = poll_edit.endPollYear.value;
				
				if((Year%4) && Year%100 || !(Year%400)) {
					return true;
				} else {
					FixEDay[2]=29;
				}
			}
			
			function selemonth_onchange() {
				var Month = parseInt(poll_edit.endPollMonth.value);
				
				for(var j = poll_edit.endPollDay.options.length;	j >= 0;	j--) {
					poll_edit.endPollDay.remove(j);
				}
				
				for(var i = 0;	i < FixEDay[Month]; i++ ) {
					var option = document.createElement("option");
					option.innerText = i+1;
					option.value = i+1;
					
					poll_edit.endPollDay.appendChild(option);
				}
			}
			
			function seleday_onchange() {
				var Month = parseInt(poll_edit.endPollMonth.value);
				var Date = parseInt(poll_edit.endPollDay.value);
				
				if( FixEDay[Month] < Date ) {
					alert("<spring:message code='ezCommunity.t595' />");
					poll_edit.endPollDay.selectedIndex = 0;
					poll_edit.endPollDay.focus();
				}
			}
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t598' /></h1>
		<br>
		<br>
		<form action=/ezCommunity/pollEditOk.do	method=post name=poll_edit id="polledit">
			<input type="hidden" name="pClubNo" value="<c:out value ='${pClubNo}' />">
			<input type="hidden" name="managerID" value="<c:out value = '${managerID}' />">
			<input type="hidden" name="startPollYear" id ="startPollYear" value="">
			<input type="hidden" name="startPollMonth" id ="startPollMonth" value="">
			<input type="hidden" name="startPollDay" id ="startPollDay" value="">
			<input type="hidden" name="endPollYear" id ="endPollYear" value="">
			<input type="hidden" name="endPollMonth" id ="endPollMonth" value="">
			<input type="hidden" name="endPollDay" id ="endPollDay" value="">
			
			<table class="content">
				<tr>
					<th><spring:message code='ezCommunity.t599' /></th>
					<td><textarea name="pollSubject" style="width: 98%;height:130px" readonly><c:out value="${managerVO.pollSubject}" /></textarea></td>
				</tr>
				<tr>
					<th><spring:message code='ezCommunity.t600' /></th>
	      			<td>
	      				<select id="selType" name="selType" style="font-size: 13px;vertical-align: middle;text-align: center;height: 18px;cursor: pointer;" onChange="selTypeChange('${questionVO.answerType}');" disabled>
	      				
	      					<c:choose>
	      						<c:when test="${questionVO.answerType == '1' }">
	      							<option value="1" selected><spring:message code='ezCommunity.t601' />
	      						</c:when>
	      						
	      						<c:otherwise>
	      							<option value="1"><spring:message code='ezCommunity.t601' />
	      						</c:otherwise>
	      					</c:choose>
	      					
	      					<c:choose>
	      						<c:when test="${questionVO.answerType == '2' }">
	      							<option value="2" selected><spring:message code='ezCommunity.t602' />
	      						</c:when>
	      						
	      						<c:otherwise>
	      							<option value="2"><spring:message code='ezCommunity.t602' />
	      						</c:otherwise>
	      					</c:choose>
	      					
	      					<c:choose>
	      						<c:when test="${questionVO.answerType == '3' }">
	      							<option value="3" selected><spring:message code='ezCommunity.t603' />
	      						</c:when>
	      						
	      						<c:otherwise>
	      							<option value="3"><spring:message code='ezCommunity.t603' />
	      						</c:otherwise>
	      					</c:choose>
	      					
	        			</select>
	        			
	        			<select id="selRes1" name="selRes1" style="font-size: 13px;vertical-align: middle;text-align: center;height: 18px;cursor: pointer;" onChange="selResChange('${questionVO.answerViewType}');" disabled>
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '0' }">
	        						<option value="0" selected><spring:message code='ezCommunity.t661' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="0"><spring:message code='ezCommunity.t661' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '1' }">
	        						<option value="1" selected>5 Scale[<spring:message code='ezCommunity.t605' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="1">5 Scale[<spring:message code='ezCommunity.t605' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '2' }">
	        						<option value="2" selected>5 Scale[<spring:message code='ezCommunity.t606' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="2">5 Scale[<spring:message code='ezCommunity.t606' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '3' }">
	        						<option value="3" selected>5 Scale[<spring:message code='ezCommunity.t607' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="3">5 Scale[<spring:message code='ezCommunity.t607' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '11' }">
	        						<option value="11" selected>Yes/No
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="11">Yes/No
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '12' }">
	        						<option value="12" selected><spring:message code='ezCommunity.t608' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="12"><spring:message code='ezCommunity.t608' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '13' }">
	        						<option value="13" selected><spring:message code='ezCommunity.t609' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="13"><spring:message code='ezCommunity.t609' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        				<c:choose>
	        					<c:when test="${questionVO.answerViewType == '14' }">
	        						<option value="14" selected><spring:message code='ezCommunity.t610' />
	        					</c:when>
	        					
	        					<c:otherwise>
	        						<option value="14"><spring:message code='ezCommunity.t610' />
	        					</c:otherwise>
	        				</c:choose>
	        				
	        			</select>
	        			
	        			<input type="text" id="selRes2" name="selRes2" size="5" value="<c:out value = '${questionVO.answerCount}' />" disabled><spring:message code='ezCommunity.t611' />
	        		</td>
	    		</tr>
	    		<tr>
					<th rowspan="1"><spring:message code='ezCommunity.t612' /></th>
					<td><input type="text" id="Sdatepicker" style="width:80px;text-align:center"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center"></td>
				</tr>
			</table>
			
			<div class="btnposition">
				<a class="imgbtn"  name="Submit" id="outok" onClick="poll_send();" ><span><spring:message code='ezCommunity.t613' /></span></a>
				<a class="imgbtn" name="Submit2" id="outcancel" onClick="history.back();" ><span><spring:message code='ezCommunity.t246' /></span></a>
			</div>
		</form>
	</body>
</html>