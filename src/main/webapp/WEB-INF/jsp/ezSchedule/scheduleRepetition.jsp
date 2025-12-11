<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t59' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/dlg_schedule.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_read_Cross.js')}"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>	
		<style>
			.disabled {
				color: #a0a0a0;
			}
		</style>
	    <script type="text/javascript">
   	    	$(document).ready(function() {
   		    		// 반복이 100회 초과일때 알러트  
   		    	if ($('input:radio[name=optRangeEnd]').is(':checked')) {
   			    		$('#list_ReCount').blur(function() {
   			    		if ($('#list_ReCount').val() > 100 ) {
   			    			alert(strLangKMS1);
   			    			$('#list_ReCount').val("");
   			    		}
   			    	});
   			    }		
   		    });
	    	
		    var RetValue;
		    var ReturnFunction;
		    //2018.01.31 김기하 함수 사용을 위해 부모로부터 변수 가져옴
		    var companyID = window.parent.companyID;
		    var offSetMin = window.parent.offSetMin;
		    var sTimeTemp = "";
		    var eTimeTemp = "";
		    window.onload = function()
		    {   
				if (navigator.maxTouchPoints > 4) {
					// 태블릿 기기이면 높이 조정하여 하단 잘림 방지
					document.getElementById("tblwrap").style.height = (document.documentElement.clientHeight - 100) + 'px';
					document.getElementById("tblwrap").style.overflowY = 'auto';
				}
		    	
		        try {
		            RetValue = parent.schedule_repetition_cross_dialogArguments[0];
		            ReturnFunction = parent.schedule_repetition_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.schedule_repetition_cross_dialogArguments[0];
		                ReturnFunction = opener.schedule_repetition_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        datepicker();
		        datetimepicker();
		        var repetition = RetValue["REPETITION"];
		        var allday = RetValue["ALLDAYCHECK"];
		    				
		    	if (repetition != "")
		    	{
		    	    var info = repetition.split("|");
		    					
		    		switch (info[0])
		    		{
		    			case "-1":
		    				document.getElementsByName("optRangeEnd")[0].checked = true;
		    				break;
		    			case "0":
		    				document.getElementsByName("optRangeEnd")[2].checked = true;
		    				break;
		    			default:
		    				document.getElementsByName("optRangeEnd")[1].checked = true;
		    				list_ReCount.value = info[0];
		    				break;
		    		}
		    		
		    		if (info[1] == "1")
		    			alldaycheck.checked = true;
		    		
					var m_objStartTime = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
		    		
		    		var iDateNumber = m_objStartTime.getDate();
		            var iWeekdayNumber = m_objStartTime.getDay();
		            var iMonthNumber = m_objStartTime.getMonth();
		    			
		    		showMainPattern(info[2]);
		    		
		    		switch (info[2])
		    		{
		    			case "0":
		    				mpDaily.checked = true;
		    				if (info[3] == "0")
		    					id0D2.checked = true;
		    				else
		    				{
		    					id0D1.checked = true;
		    					txt_De.value = info[3];
		    				}
		    				document.getElementById("day" + iWeekdayNumber).checked = true;
		    			break;
		    			case "1":
		    				mpWeekly.checked = true;
		    				txt_We.value = info[3];
		    				for (var i=0; i<info[4].length; i++)
		    				{
		    					var idx = parseInt(info[4].substr(i, 1));
		    					daytable.getElementsByTagName("input").item(idx).checked = true;
		    				}
		    			break;
		    			case "2":
		    				mpMonthly.checked = true;
		    				if (info[3] == "1")
		    				{
		    					idOM1.checked = true;
		    					list_MonthInterval.value = info[4];
		    					list_MonthlyDays.value = info[5];
		    					
		    					var nEach = parseInt(iDateNumber / 7);
					            document.getElementById("list_MonthlyEach").selectedIndex = nEach;
					            SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
		    				}
		    				else
		    				{
		    					document.getElementById("list_MonthlyDays").value = iDateNumber;
		    					
		    					id0M2.checked = true;
		    					list_MonthInterval2.value = info[4];
		    					list_MonthlyEach.value = info[5];
		    					list_MonthlyDay.value = info[6];
		    				}
		    				document.getElementById("day" + iWeekdayNumber).checked = true;			// 매주 체크
		    				
				            document.getElementById("list_YearlyDays").value = iDateNumber;
				            
				            document.getElementById("list_Month").selectedIndex = iMonthNumber;
				            document.getElementById("list_Month2").selectedIndex = iMonthNumber;
				            
				            var nEach = parseInt(iDateNumber / 7);
				            document.getElementById("list_YearlyEach").selectedIndex = nEach;
				            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);							// 매년 체크
		    			break;
		    			case "3":
		    				mpYearly.checked = true;
		    				if (info[3] == "1")
		    				{
		    					optY1.checked = true;
		    					list_Month.value = info[4];
		    					list_YearlyDays.value = info[5];
		    					
		    					document.getElementById("list_Month2").selectedIndex = iMonthNumber;
		    					
		    					var nEach = parseInt(iDateNumber / 7);
					            document.getElementById("list_YearlyEach").selectedIndex = nEach;
					            
					            SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
		    				}
		    				else
		    				{
		    					optY2.checked = true;
		    					list_Month2.value = info[4];
		    					list_YearlyEach.value = info[5];
		    					list_YearlyDay.value = info[6];
		    					
		    					 document.getElementById("list_Month").selectedIndex = iMonthNumber;
		    					 
		    					 document.getElementById("list_YearlyDays").value = iDateNumber;
		    				}
		    				document.getElementById("day" + iWeekdayNumber).checked = true;			// 매주 체크
		    				
		    				document.getElementById("list_MonthlyDays").value = iDateNumber;
		    				
		    				document.getElementById("list_MonthlyEach").selectedIndex = nEach;
		    				SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);						// 매월 체크
		    		}
		    		
		    		if(info[2] == "0" || info[2] == "1") {
			    		SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
			            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);
			            
			            document.getElementById("list_MonthlyDays").value = iDateNumber;
			            document.getElementById("list_YearlyDays").value = iDateNumber;
		
			            document.getElementById("list_Month").selectedIndex = iMonthNumber;
			            document.getElementById("list_Month2").selectedIndex = iMonthNumber;
		
			            var nEach = parseInt(iDateNumber / 7);
			            document.getElementById("list_MonthlyEach").selectedIndex = nEach;
			            document.getElementById("list_YearlyEach").selectedIndex = nEach;
		    		}
		    	}
		    	else {
		    		if(allday == true) {			// 일정작성 탭에서 하루종일 체크하고 반복 클릭 시
		    			alldaycheck.checked = true;
		    		}
		    	
		    		// 2019-02-20 김민성 - 일정반복 데이터 없을 때 해당 요일 체크되도록 수정
		    		try {
		                m_objStartTime = new Date(RetValue["SDATE"].split(' ')[0].split('-')[0], parseInt(RetValue["SDATE"].split(' ')[0].split('-')[1]) - 1, RetValue["SDATE"].split(' ')[0].split('-')[2], RetValue["SDATE"].split(' ')[1].split(':')[0], RetValue["SDATE"].split(' ')[1].split(':')[1], 0, 0);
		            } catch (e) {
		                m_objStartTime = new Date(RetValue["SDATE"]);
		            }  
		    	
		            var iDateNumber = m_objStartTime.getDate();
		            var iWeekdayNumber = m_objStartTime.getDay();
		            var iMonthNumber = m_objStartTime.getMonth();

		    		document.getElementById("day" + iWeekdayNumber).checked = true;
		    		SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
		            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);
		            
		            document.getElementById("list_MonthlyDays").value = iDateNumber;
		            document.getElementById("list_YearlyDays").value = iDateNumber;
	
		            document.getElementById("list_Month").selectedIndex = iMonthNumber;
		            document.getElementById("list_Month2").selectedIndex = iMonthNumber;
	
		            var nEach = parseInt(iDateNumber / 7);
		            document.getElementById("list_MonthlyEach").selectedIndex = nEach;
		            document.getElementById("list_YearlyEach").selectedIndex = nEach;
		    	}
		    	allDayTime();
		    	clearAllDay();
				selectOptRangeEnd();
		    }
		    
		    function SetWeekdayDropDown(ddDay, value)
		    {
		    	var iList;
		    	var iLength = ddDay.length;
		        
		    	for (iList = 0; iList < iLength; iList++)
		    	{  
		    		if (ddDay[iList].value == value)
		    		{ 
		    			ddDay[iList].selected = true;
		    			
		    			return;
		    		}
		    	}						
		    	return;
		    }
		    
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
		        {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		    function ok_click()
		    {
		    	var rtn = new Array();

	    		
		    	rtn["SDATE"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		    	rtn["EDATE"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		    
		    	var repetition = "";
		    	
		    	var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()
		    	var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()
	
		    	var startYear = startDate.split("-")[0];
		    	var endYear = endDate.split("-")[0];
		    	var startMonth = startDate.split("-")[1];
		    	var endMonth = endDate.split("-")[1];
		    	var startDay = startDate.split("-")[2];
		    	var endDay = endDate.split("-")[2];
		    	var stime = $('#Stimepicker').val()
	
		    	var shour, sminute;
		    	var ehour, eminute;
	
		    	shour = stime.split(":")[0];
		    	sminute = stime.split(":")[1];
	
		    	var etime = $('#Etimepicker').val()
	
		    	ehour = etime.split(":")[0];
		    	eminute = etime.split(":")[1];
	
		    	if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) > parseInt(endDay))) {
		    	    if (document.getElementById("alldaycheck").checked == false && (shour > ehour || (shour == ehour && sminute >= eminute))) {
		    	        alert("<spring:message code='ezSchedule.t60' />");
		    	        return;
		    	    }
		    	}
		    	
		    	// 시작시간과 종료시간이 00시 00분이면 무조건 하루종일로
		    	if(stime == "00:00" && etime == "00:00") {
		    		document.getElementById("alldaycheck").checked = true;
		    	}
		    	
		    	var allDayString = "";
		    	var scheduleTerm = "";	
		    	var occurrenceTerm = "";			
		    	var recurString = "";			
		        
		        scheduleTerm = getPickerDate();
		        occurrenceTerm = occurrencDate();
		        
		    	if (document.getElementsByName("optRangeEnd")[0].checked == true) {		    		
		    		repetition = "-1";				    		
		    	} else if (document.getElementsByName("optRangeEnd")[1].checked == true) {		    		
		    		if (list_ReCount.value == parseInt(list_ReCount.value) && parseInt(list_ReCount.value) > 0) {		    			
		    			repetition = parseInt(list_ReCount.value);		    			
		    		} else {		    			
		    			alert("<spring:message code='ezSchedule.t61' />");
		    			list_ReCount.focus();
		    			return;		    			
		    		}		
		    	} else {		    		
		    	    if(!check_time()) {		    	    	
		    	        alert("<spring:message code='ezSchedule.t60' />");
		    	        return;		    	        
		    	    }		    	    
		    		repetition = "0";				
		    	}
		    	//2018.01-31 김기하 반복 시 시작일자 검사 
	    	    if (CheckPreviously(true)) {
	    	    	alert(strLang275);
	        		return;
	        	}
		    	
		    	if (alldaycheck.checked == true) {
		    		repetition += "|1";
		    		allDayString = strLang39;
		    		// 반복일정 상단표시
		    		window.parent.document.getElementById("topcheck").checked = false;
		    		window.parent.document.getElementById("topcheck").disabled = true;
		    	} else {
		    		repetition += "|0";
                    window.parent.document.getElementById("topcheck").disabled = false;
		    	}
		    		
		    	if (mpDaily.checked == true) {		    		
		    		repetition += "|0";		    		
		    		if (id0D2.checked == true) {		    			
		    			repetition += "|0";						
		    			recurString = strLang45;		    			
		    		} else {		    			
		    			if (txt_De.value == parseInt(txt_De.value) && parseInt(txt_De.value) > 0){
		    				
		    				repetition += "|" + parseInt(txt_De.value);	
		    			}		    				
		    			else {		    				
			    				alert("<spring:message code='ezSchedule.t62' />");
			    				txt_De.focus();
			    				return;
		    				 }
		    			
		    			if(txt_De.value == "1") {		    				
		                    recurString = strLang34;		                    
		    			} else {		    				
		    			    recurString = txt_De.value + strLang81;			    			    
		    			}						
		    		}
		    	} else if (mpWeekly.checked == true) {		    		
		    		repetition += "|1";						    		
		    		if (txt_We.value == parseInt(txt_We.value) && parseInt(txt_We.value) > 0)
		    			repetition += "|" + parseInt(txt_We.value);
		    		else {
			    			alert("<spring:message code='ezSchedule.t63' />");
			    			txt_We.focus();
			    			return;
			    		 }
		    		
		    		var days = "";
		    		var checks = daytable.getElementsByTagName("input");
		    		
		    		for (var i=0; i<checks.length; i++)
		    		{
		    			if (checks.item(i).checked == true)
		    			{						    
		    				days += checks.item(i).value;						
		    				recurString = recurString + " " + makeStringDayofWeekInfo(i.toString());
		    											
		    		        recurString = recurString + ","					        
		    			}
		    		}
		    		var index = recurString.lastIndexOf(",");
		    		recurString	= recurString.substring(0,recurString.length-1);
		    		if (days == "")
		    		{
		    			alert("<spring:message code='ezSchedule.t64' />");
		    			return;
		    		}
		    		
		    		repetition += "|" + days
		    		
		    		if(txt_We.value == "1")
		    		{
		    		    recurString = strLang35 + " " + recurString;
		    		}
		    		else
		    		{
		    		    recurString = txt_We.value + strLang82 + " " + recurString;
		    		}
		    		
		    	}
		    	else if (mpMonthly.checked == true)
		    	{
		    		repetition += "|2";
		    		
		    		if (idOM1.checked == true)
		    		{
		    			repetition += "|1";
		    			
		    			if (list_MonthInterval.value == parseInt(list_MonthInterval.value) && parseInt(list_MonthInterval.value) > 0)
		    				repetition += "|" + parseInt(list_MonthInterval.value);
		    			else
		    			{
		    				alert("<spring:message code='ezSchedule.t65' />");
		    				list_MonthInterval.focus();
		    				return;
		    			}
		    			
		    			if (list_MonthlyDays.value == parseInt(list_MonthlyDays.value) && parseInt(list_MonthlyDays.value) > 0 &&
		    				parseInt(list_MonthlyDays.value) < 32)
		    				repetition += "|" + parseInt(list_MonthlyDays.value);
		    			else
		    			{
		    				alert("<spring:message code='ezSchedule.t66' />");
		    				list_MonthlyDays.focus();
		    				return;
		    			}
		    			
		    			if(list_MonthInterval.value == 1)
		    			{
		    			    recurString = strLang36 + " " + list_MonthlyDays.value + strLang80;
		    			}
		    			else
		    			{
		    			    recurString = list_MonthInterval.value + strLang83 + " " + list_MonthlyDays.value + strLang80;						
		    			}
		    			
		    		}
		    		else
		    		{
		    			repetition += "|2";
		                
		    			if (list_MonthInterval2.value == parseInt(list_MonthInterval2.value) && parseInt(list_MonthInterval2.value) > 0)
		    			{
		    				repetition += "|" + parseInt(list_MonthInterval2.value);							
		    			}
		    			else
		    			{
		    				alert("<spring:message code='ezSchedule.t65' />");
		    				list_MonthInterval2.focus();
		    				return;
		    			}
	
		    			repetition += "|" + list_MonthlyEach.value;
		    			repetition += "|" + list_MonthlyDay.value;						
		    			
		    			if(list_MonthInterval2.value == 1)
		    			{
		    			    recurString = strLang36 + " " + makeStringWeekNumber(list_MonthlyEach.value) + " " + makeStringDayofWeekInfo2(list_MonthlyDay.value);
		    			}
		    			else
		    			{					
		    			    recurString =  list_MonthInterval2.value + strLang83 + " " + makeStringWeekNumber(list_MonthlyEach.value) + " " + makeStringDayofWeekInfo2(list_MonthlyDay.value);					
		    			}
		    		}
		    	}
		    	else
		    	{
		    		repetition += "|3";
		    		recurString = strLang37;
		    		if (optY1.checked == true)
		    		{
		    			repetition += "|1";
		    			repetition += "|" + list_Month.value;
		    			
		    			recurString = recurString + " " + getMonthString(parseInt(list_Month.value)) + " " + list_YearlyDays.value + strLang80;					
		    			
		    			if (list_YearlyDays.value == parseInt(list_YearlyDays.value) && parseInt(list_YearlyDays.value) > 0 &&
		    				parseInt(list_YearlyDays.value) < 32)
		    				repetition += "|" + parseInt(list_YearlyDays.value);
		    			else
		    			{
		    				alert("<spring:message code='ezSchedule.t66' />");
		    				list_YearlyDays.focus();
		    				return;
		    			}
		    			
		    		}
		    		else
		    		{
		    			repetition += "|2";
		    			repetition += "|" + list_Month2.value;
		    			repetition += "|" + list_YearlyEach.value;
		    			repetition += "|" + list_YearlyDay.value;
		    			
		    			recurString = recurString + " " + getMonthString(parseInt(list_Month2.value)) + " " + makeStringWeekNumber(list_YearlyEach.value) + " " + makeStringDayofWeekInfo2(list_YearlyDay.value);
		    		}				
		    	}
		    	
		    	rtn["REPETITION"] = repetition;
		    	/*2018-05-16 구해안 반복주기에서 표시되는 기간: -> 기간 : 으로 수정, 맨앞에 반복주기 : 추가*/
		    	if(allDayString =="")
		    	{
		    	    rtn["REPDISPLAY"] = strLang33 + " " + recurString + " " + occurrenceTerm + " " + strLang79 + " : " + scheduleTerm;
		    	}
		    	else
		    	{
		    	    rtn["REPDISPLAY"] = strLang33 + " " + recurString + " " + allDayString + " " + strLang79 + " : " + scheduleTerm;
		    	}
		    	if (ReturnFunction != null) {
		    	    //2018.01.30 김기하 일정반복 시 시간기준 점 변경  
		    		window.parent.timeCheck = true;
		    		ReturnFunction(rtn);
		    	    parent.DivPopUpHidden();
	
		    	}
		    	else {
		    	    
		    	    window.returnValue = rtn;
		    	    window.close();
		    	}
		    	
		    	
		    }
	
		    function getPickerDate()
		    {
		        var rtnString = "";
		        if(document.getElementsByName("optRangeEnd")[0].checked == true)
		        {
		        
	
		            var sdate = "";
		            //if (CrossYN()) {
		            //    sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		            //}
		            //else {
		                var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		                var sYear = sDate.split("-")[0];
		                var sMon = sDate.split("-")[1] -1;
		                var sDay = sDate.split("-")[2];
		                var sTime = $('#Stimepicker').val();
		                var sHour = sTime.split(":")[0];
		                var sMin = sTime.split(":")[1];
		                
		                if (sMin == undefined)
		                    sMin = "";
		                sdate = new Date(sYear, sMon, sDay, sHour, sMin);
		            //}
		            //var sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		            rtnString = makeTermDate(sdate) + " ~ " + strLang46;	          
		            
		            return rtnString;
		        }
		        else if(document.getElementsByName("optRangeEnd")[1].checked == true)
		        {
	
		            var sdate = "";
		            //if (CrossYN()) {
		            //    sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		            //}
		            //else {
		                var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		                var sYear = sDate.split("-")[0];
		                var sMon = sDate.split("-")[1] -1;
		                var sDay = sDate.split("-")[2];
		                var sTime = $('#Stimepicker').val();
		                var sHour = sTime.split(":")[0];
		                var sMin = sTime.split(":")[1];
	
		                if (sMin == undefined)
		                    sMin = "";
	
		                sdate = new Date(sYear, sMon, sDay, sHour, sMin);
		            //}
		            //var sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		            rtnString = makeTermDate(sdate) + " ~ " + list_ReCount.value + strLang47;
		        
		            return rtnString;
		        }
		        else if(document.getElementsByName("optRangeEnd")[2].checked == true)
		        {
		            var sdate = "";
		            var edate = "";
		            //if (CrossYN()) {
		            //    sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		            //    edate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val());
		            //}
		            //else {
		                var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		                var sYear = sDate.split("-")[0];
		                var sMon = sDate.split("-")[1] -1;
		                var sDay = sDate.split("-")[2];
		                var sTime = $('#Stimepicker').val();
		                var sHour = sTime.split(":")[0];
		                var sMin = sTime.split(":")[1];
	
	
		                var eDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		                var eYear = eDate.split("-")[0];
		                var eMon = eDate.split("-")[1] -1;
		                var eDay = eDate.split("-")[2];
		                var eTime = $('#Etimepicker').val();
		                var eHour = eTime.split(":")[0];
		                var eMin = eTime.split(":")[1];
	
		                if (sMin == undefined)
		                    sMin = "";
	
		                if (eMin == undefined)
		                    eMin = "";
	
		                sdate = new Date(sYear, sMon, sDay, sHour, sMin);
		                edate = new Date(eYear, eMon, eDay, eHour, eMin);
		            //}
		            //var sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		            //var edate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val());
		            
		            rtnString = makeTermDate(sdate) + " ~ " + makeTermDate(edate);
	
		            return rtnString;
		        }				 
		    }
	
		    function occurrencDate()
		    {			   
		        var repeatinfo = "";		
		        	
		        var sdate = "";
		        var edate = "";
		        //if (CrossYN()) {
		        //    sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		        //    edate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val());
		        //}
		        //else {
		            var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            var sYear = sDate.split("-")[0];
		            var sMon = sDate.split("-")[1] -1;
		            var sDay = sDate.split("-")[2];
		            var sTime = $('#Stimepicker').val();
		            var sHour = sTime.split(":")[0];
		            var sMin = sTime.split(":")[1];
	
	
		            var eDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            var eYear = eDate.split("-")[0];
		            var eMon = eDate.split("-")[1] -1;
		            var eDay = eDate.split("-")[2];
		            var eTime = $('#Etimepicker').val();
		            var eHour = eTime.split(":")[0];
		            var eMin = eTime.split(":")[1];
	
		            if (sMin == undefined)
		                sMin = "";
		            if (eMin == undefined)
		                eMin = "";
		            sdate = new Date(sYear, sMon, sDay, sHour, sMin);
		            edate = new Date(eYear, eMon, eDay, eHour, eMin);
		        //}
		        //var sdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val());
		        //var edate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val());
		    	    			
		        sdate = sdate.getFullYear() + "-" + (parseInt(sdate.getMonth()) + 1) + "-" + sdate.getDate() + " " + sdate.getHours() + ":" + sdate.getMinutes();
		        edate = edate.getFullYear() + "-" + (parseInt(edate.getMonth()) + 1) + "-" + edate.getDate() + " " + edate.getHours() + ":" + edate.getMinutes();		        
		        
		        var reStartHour = sdate.split(" ")[1].split(":")[0];
		        var reEndHour = edate.split(" ")[1].split(":")[0];
		    	
		        var reStartMinute = sdate.split(" ")[1].split(":")[1];
		        reStartMinute = reStartMinute.length==1?"0"+reStartMinute:reStartMinute;
		        var reEndMinute = edate.split(" ")[1].split(":")[1];
		        reEndMinute = reEndMinute.length==1?"0"+reEndMinute:reEndMinute;
	
		        repeatinfo += strLang104 + reStartHour + ":" + reStartMinute + "" + " ~ " + "";
		        
		        repeatinfo += reEndHour + ":" + reEndMinute;
		        return repeatinfo;
		    }
	
		    function makeTermDate(pdate)
		    {
		        var date = new Date(pdate);
		        var dateYear = date.getFullYear();
		        var dateMonth = (parseInt(date.getMonth()) + 1) 
		        var dateDay = date.getDate();
		        
		        if(dateMonth < 10)
		        {
		            dateMonth = "0" + dateMonth;
		        }
		        
		        if(dateDay < 10)
		        {
		            dateDay = "0" + dateDay;
		        }
	
		        return dateYear + "-" + dateMonth + "-" + dateDay;
		    }
	
		    function getMonthString(cnt)
		    {					
		        var rtnString = "";
		        switch (cnt)
		    	{				
		    		case 1:
		    			rtnString = strLang67;
		    			break;
		    		case 2:
		    			rtnString = strLang68;
		    			break;
		    		case 3:
		    			rtnString = strLang69;
		    			break;
		    		case 4:
		    			rtnString = strLang70;
		    			break;
		    		case 5:
		    			rtnString = strLang71;
		    			break;
		    		case 6:
		    			rtnString = strLang72;
		    			break;	
		    		case 7:
		    		    rtnString = strLang73;
		    		    break;	
		    		case 8:
		    		    rtnString = strLang74;
		    		    break;	
		    		case 9:
		    		    rtnString = strLang75;
		    		    break;	
		    		case 10:
		    		    rtnString = strLang76;
		    		    break;	
		    		case 11:
		    		    rtnString = strLang77;
		    		    break;	
		    		case 12:
		    		    rtnString = strLang78;
		    		    break;	
		    	}
		    	return rtnString;
		    }
	
		    function windows_close()
		    {
		        parent.DivPopUpHidden();
		        window.close();
		    }
	
		    function remove_click()
		    {
		    	//2018.01.30 김기하 반복 일정 취소 시 시가 기준 점 기존으로 변경
		    	window.parent.timeCheck = false;
		    	var rtn = new Array();
		    	rtn["SDATE"] = "";
		    	rtn["EDATE"] = "";
		    	rtn["REPETITION"] = "";
		    	if (ReturnFunction != null)
		    	    ReturnFunction(rtn);
		    	else
		    	    window.returnValue = rtn;
		    	parent.DivPopUpHidden();
		    	window.close();
		    }
		    			
		    function datepicker() {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",		            
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var SDate = new Date(RetValue["SDATE"]);
		        var EDate = new Date(RetValue["EDATE"]);
	
		        var SDate = "";
		        var EDate = "";
		       
		        var sDate = RetValue["SDATE"];
		        var sYear = sDate.split(" ")[0].split("-")[0];
		        var sMon = sDate.split(" ")[0].split("-")[1] - 1;
		        var sDay = sDate.split(" ")[0].split("-")[2];
		        var sHour = sDate.split(" ")[1].split(":")[0];
		        var sMin = sDate.split(" ")[1].split(":")[1];
	
	
		        var eDate = RetValue["EDATE"];
		        var eYear = eDate.split(" ")[0].split("-")[0];
		        var eMon = eDate.split(" ")[0].split("-")[1] - 1;
		        var eDay = eDate.split(" ")[0].split("-")[2];
		        var eHour = eDate.split(" ")[1].split(":")[0];
		        var eMin = eDate.split(" ")[1].split(":")[1];
	
		        SDate = new Date(sYear, sMon, sDay, sHour, sMin);
		        EDate = new Date(eYear, eMon, eDay, eHour, eMin);
	
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', SDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
	
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		        $('#Etimepicker').timepicker();
		        $('#Etimepicker').timepicker('setTime', EDate);
		        $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
		    
		        sTimeTemp = $('#Stimepicker').val();
		        eTimeTemp = $('#Etimepicker').val();

		        // 시작시간과 종료시간이 00시 00분이면 무조건 하루종일로
		        if(sTimeTemp == "00:00" && eTimeTemp == "00:00") {
		        	document.getElementById("alldaycheck").checked = true;
		        }
		    }
		    		    
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    function datetimepicker() {
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
		    }
		    
		    function setTimePickerReadOnly() {
		    	$('#Stimepicker').attr('disabled','disabled');
	    		$('#Etimepicker').attr('disabled','disabled');
		    }
		    
			function setTimePickerModifiable() {
				$('#Stimepicker').removeAttr('disabled');
	    		$('#Etimepicker').removeAttr('disabled');
		    }
		    
		    function allDayTime(){
	    		if(document.getElementById("alldaycheck").checked == true){
	    			sTimeTemp = $('#Stimepicker').val();
		    		eTimeTemp = $('#Etimepicker').val();
		    		$('#Stimepicker').timepicker("setTime", "00:00");
		    		$('#Etimepicker').timepicker("setTime", "23:59");
					setTimePickerReadOnly();
		    	}else if(sTimeTemp != null){
		    		setTimePickerModifiable();
		    		// 종일일정 해제 후 현재시각에 맞게 설정
		    		var now = new Date();

                    //시작시간
                    var startTime;
                    var hour = RetValue["SDATE"].split(" ")[1].split(":")[0];
                    var time = RetValue["SDATE"].split(" ")[1].split(":")[1];

                    if (parseInt(time) < 30) {
                        startTime = hour + ":00:00";
                    } else {
                        startTime = hour + ":30:00";
                    }

                    //종료시간
                    var endTime;
                    var hour = RetValue["EDATE"].split(" ")[1].split(":")[0];
                    var time = RetValue["EDATE"].split(" ")[1].split(":")[1];

                    if (parseInt(time) < 30) {
                        endTime = hour + ":00:00";
                    } else {
                        endTime = hour + ":30:00";
                    }

		    		$('#Stimepicker').timepicker("setTime", startTime);
		    		$('#Etimepicker').timepicker("setTime", eTimeTemp == "23:59" ? "23:30" :endTime);

		    		//$('#Stimepicker').timepicker("setTime", sTimeTemp);
		    		//$('#Etimepicker').timepicker("setTime", eTimeTemp == "23:59" ? "23:30" : eTimeTemp);
		    	}
		    	else {
		    		setTimePickerModifiable();
		    		
					var now = new Date();
		        	
		        	//시작시간
		        	var startTime;
		        	var hour = now.getHours();
		        	var time = now.getMinutes();
		        	
		        	if (parseInt(time) < 30) {
		        		startTime = hour + ":00:00";
		        	} else {
		        		startTime = hour + ":30:00";
		        	}
		        	
		        	//종료시간
		        	var endTime;
		        	now.setMinutes(now.getMinutes() + 30);
		        	
		        	hour = now.getHours();
		        	time = now.getMinutes();
		        	
		        	if (parseInt(time) < 30) {
		        		endTime = hour + ":00:00";
		        	} else {
		        		endTime = hour + ":30:00";
		        	}
		        	
		        	$('#Stimepicker').timepicker('setTime', startTime);
		        	$('#Etimepicker').timepicker('setTime', endTime);
		    	}
		    }
		    
		    function clearAllDay(){
		    	$('#Stimepicker').change(function(){
		    		if($("#alldaycheck").prop("checked") == true){
		    			$("#alldaycheck").prop("checked", false);
		    		}
		    		if($('#Stimepicker').val() == "00:00" && $('#Etimepicker').val() == "23:59"){
		    			$("#alldaycheck").prop("checked", true);
		    			setTimePickerReadOnly();
		    		}
		    	});
		    	$('#Etimepicker').change(function(){
		    		if($("#alldaycheck").prop("checked") == true){
		    			$("#alldaycheck").prop("checked", false);
		    		}
		    		if(($('#Stimepicker').val() == "00:00") && ($('#Etimepicker').val() == "23:59")){
		    			$("#alldaycheck").prop("checked", true);
		    			setTimePickerReadOnly();
		    		}
		    	});
		    	
		    	
		    }	
			
		    function KeEventControl(obj) {
	            if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
	                return false;
	            }
	            else obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	        }
			
			function selectOptRangeEnd() {
				var targetId =  $('input[name=optRangeEnd]:checked').attr('id');
				if (targetId == "Infinite") {
					$("#Edatepicker").datepicker('option','disabled', true); 
					$("#Edatepicker").addClass('disabled');
					$("#list_ReCount").prop('disabled', true); 
					$("#list_ReCount").addClass('disabled');
				} else if (targetId == "Instances") {
					$("#Edatepicker").datepicker('option','disabled', true); 
					$("#Edatepicker").addClass('disabled');
					$("#list_ReCount").prop('disabled', false); 
					$("#list_ReCount").removeClass('disabled')
				} else if (targetId == "EndTimeSet") {
					$("#Edatepicker").datepicker('option','disabled', false); 
					$("#Edatepicker").removeClass('disabled'); 
					$("#list_ReCount").prop('disabled', true); 
					$("#list_ReCount").addClass('disabled')
				}
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezSchedule.t59' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="windows_close()"></span></li>
            </ul>
        </div>
	        <div id="tblwrap">
			<div id="TB_Promise">
				<h2><spring:message code='ezSchedule.t67' /></h2>
			  	<table class="content">
			    	<tr>
			      		<th><spring:message code='ezSchedule.t68' /></th>
			      		<td>
			      			<div>
			          			<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:3px;text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
			        			<label for="btnT1"></label>
			        			<div class="custom_checkbox">
			        				<input type="checkbox" value="1" id="alldaycheck" NAME="alldaycheck" onChange="allDayTime()"/>
									<label for="alldaycheck"><spring:message code='ezSchedule.t69' /></label>
			        			</div>
			        		</div>
			        	</td>
			    	</tr>
				    <tr>
				    	<th><spring:message code='ezSchedule.t70' /></th>
				      	<td>
				        	<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:3px;text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
				        	<label for="btnT2"></label>
				      	</td>
				    </tr>
				</table>
			</div><br/>		
			<h2><spring:message code='ezSchedule.t71' /></h2>
			<table width="100%" class="content">
		  		<tr>
		    		<td>
		    			<div class="custom_radio">
		      				<input id="mpDaily" style="margin-top: -2px;" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(0);' />
		      				<label for="mpDaily"><spring:message code='ezSchedule.t72' /></label>
		      				<input id="mpWeekly" style="margin-top: -2px;" type="radio" name="optMainPattern" value="radiobutton" checked onClick='showMainPattern(1);' />
		      				<label for="mpWeekly"><spring:message code='ezSchedule.t73' /></label>
		      				<input id="mpMonthly" style="margin-top: -2px;" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(2);' />
		      				<label for="mpMonthly"><spring:message code='ezSchedule.t74' /></label>
		      				<input id="mpYearly" style="margin-top: -2px;" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(3);' />
		      				<label for="mpYearly"><spring:message code='ezSchedule.t75' /></label>
						</div>
		    		</td>
		  		</tr>
		  		<tr id='divRecurPatterns' style="display:none">
		    		<td  style="padding:10px;height:85px">
		    			<div>
		    				<div class="custom_radio">
			    				<input id="id0D1" type="radio" name="optDaily" checked />
			    			</div>
		    				<label for="txt_De">
		            			<input name="text" type="text" id="txt_De" style="Width:40px;text-align:center;" onFocus='window.document.all["optDaily"][0].checked=true;' value="1" maxlength='3' />
		          				&nbsp;<spring:message code='ezSchedule.t77' />
		          			</label>
		          		</div>
		          		<div style="margin-top:3px">	
		    				<div class="custom_radio">
		        				<input id="id0D2" type="radio" name="optDaily" />
								<label for="id0D2"><spring:message code='ezSchedule.t78' /></label>
			    			</div>
	        			</div>	
		        	</td>
		  		</tr>
		  		<tr id='divRecurPatterns'>
		    		<td style="padding:10px;height:85px">
		    			<span style="margin-left:4px"><spring:message code='ezSchedule.t79' /></span>	    			
		      			<label for="txt_We">
		      				<input id="txt_We" type="text" name="textfield222" class="textarea" style="width:50px;text-align:center;" value="1" />
		      				<spring:message code='ezSchedule.t80' />
		      			</label>
		      			<div id="daytable">
		      				<div class="custom_checkbox">
		      					<input type="checkbox" name="day" id="day0" value="0" />
		      					<label for="day0"><spring:message code='ezSchedule.t81' /></label>
								<input type="checkbox" name="day" id="day1" value="1" />
								<label for="day1"><spring:message code='ezSchedule.t82' /></label>
								<input type="checkbox" name="day" id="day2" value="2" />
								<label for="day2"><spring:message code='ezSchedule.t83' /></label>
								<input type="checkbox" name="day" id="day3" value="3" />
								<label for="day3"><spring:message code='ezSchedule.t84' /></label>
				            	<br>
				            	<input type="checkbox" name="day" id="day4" value="4" />
								<label for="day4"><spring:message code='ezSchedule.t85' /></label>
								<input type="checkbox" name="day"id="day5"  value="5" />
								<label for="day5"><spring:message code='ezSchedule.t86' /></label>
								<input type="checkbox" name="day" id="day6" value="6" />
								<label for="day6"><spring:message code='ezSchedule.t87' /></label>
		      				</div>
						</div>
					</td>
		  		</tr>
		  		<tr id='divRecurPatterns' style="display:none">
		    		<td style="padding:10px;height:85px">
		    			<div>
		    				<div class="custom_radio">
			    				<input type="radio" name='optMonthly' id="idOM1" checked />
								<label for="idOM1" ><spring:message code='ezSchedule.t88' />&nbsp;</label>
		    				</div>
			            	<input name="Input" id="list_MonthInterval" style="Width:40px;text-align:center;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="1" maxlength="3" />
							&nbsp;<spring:message code='ezSchedule.t89' />
			            	<input name="Input" id="list_MonthlyDays" style="Width:40px;text-align:center;" onFocus='window.document.all["optMonthly"][0].checked=true;' maxlength="2" />
							&nbsp;<spring:message code='ezSchedule.t90' />
						</div>
						<div style="margin-top:3px">		
							<div class="custom_radio">
								<input id="id0M2" type="radio" name='optMonthly' />
								<label for="id0M2" ><spring:message code='ezSchedule.t91' />&nbsp;</label>
							</div>				
			            	<input name="Input" id="list_MonthInterval2" style="Width:40px;text-align:center;" onFocus='window.document.all["optMonthly"][1].checked=true;' value="1" maxlength="3" />
							&nbsp;<spring:message code='ezSchedule.t89' />
			            	<select name="select" id="list_MonthlyEach" onFocus='window.document.all["optMonthly"][1].checked=true;'>
								<option value="1"><spring:message code='ezSchedule.t92' /></option>
								<option value="2"><spring:message code='ezSchedule.t93' /></option>
								<option value="3"><spring:message code='ezSchedule.t94' /></option>
								<option value="4"><spring:message code='ezSchedule.t95' /></option>
								<option value="5"><spring:message code='ezSchedule.t96' /></option>
			            	</select>
			            	<select name="select" id="list_MonthlyDay" onFocus='window.document.all["optMonthly"][1].checked=true;'>
			              		<option value="0"><spring:message code='ezSchedule.t81' /></option>
								<option value="1"><spring:message code='ezSchedule.t82' /></option>
								<option value="2"><spring:message code='ezSchedule.t83' /></option>
								<option value="3"><spring:message code='ezSchedule.t84' /></option>
								<option value="4"><spring:message code='ezSchedule.t85' /></option>
								<option value="5"><spring:message code='ezSchedule.t86' /></option>
								<option value="6"><spring:message code='ezSchedule.t97' /></option>
			            	</select>
							&nbsp;<spring:message code='ezSchedule.t98' />
						</div>	
					</td>
				</tr>
		  		<tr id='divRecurPatterns' style="display:none">
		    		<td style="padding:10px;height:85px">
		    			<div>
		    				<div class="custom_radio">
				    			<input id="optY1" type="radio" name="optYearly" value="radiobutton" checked />
								<label for="optY1"></label>
		    				</div>
			            	<select name="select" id="list_Month" onFocus='window.document.all["optYearly"][0].checked=true;'>
								<option value="1"><spring:message code='ezSchedule.t382' /></option>
								<option value="2"><spring:message code='ezSchedule.t383' /></option>
								<option value="3"><spring:message code='ezSchedule.t384' /></option>
								<option value="4"><spring:message code='ezSchedule.t385' /></option>
								<option value="5"><spring:message code='ezSchedule.t386' /></option>
								<option value="6"><spring:message code='ezSchedule.t387' /></option>
								<option value="7"><spring:message code='ezSchedule.t388' /></option>
								<option value="8"><spring:message code='ezSchedule.t389' /></option>
								<option value="9"><spring:message code='ezSchedule.t390' /></option>
								<option value="10"><spring:message code='ezSchedule.t391' /></option>
								<option value="11"><spring:message code='ezSchedule.t392' /></option>
								<option value="12"><spring:message code='ezSchedule.t393' /></option>
			            	</select>		            
			            	<input name="Input" class="text" id="list_YearlyDays" style="Width:40px;text-align:center;" onFocus='window.document.all["optYearly"][0].checked=true;' maxlength="2" />
							&nbsp;<spring:message code='ezSchedule.t100' />
						</div>
			            <div style="margin-top:3px">	
			            	<div class="custom_radio">
								<input id="optY2" type="radio" name="optYearly" value="radiobutton" />
								<label for="optY2"></label>
			            	</div>
			            	<select name="select" id="list_Month2" onFocus='window.document.all["optYearly"][1].checked=true;'>
								<option value="1"><spring:message code='ezSchedule.t382' /></option>
								<option value="2"><spring:message code='ezSchedule.t383' /></option>
								<option value="3"><spring:message code='ezSchedule.t384' /></option>
								<option value="4"><spring:message code='ezSchedule.t385' /></option>
								<option value="5"><spring:message code='ezSchedule.t386' /></option>
								<option value="6"><spring:message code='ezSchedule.t387' /></option>
								<option value="7"><spring:message code='ezSchedule.t388' /></option>
								<option value="8"><spring:message code='ezSchedule.t389' /></option>
								<option value="9"><spring:message code='ezSchedule.t390' /></option>
								<option value="10"><spring:message code='ezSchedule.t391' /></option>
								<option value="11"><spring:message code='ezSchedule.t392' /></option>
								<option value="12"><spring:message code='ezSchedule.t393' /></option>
			            	</select>
			            	<select name="select" id="list_YearlyEach" onFocus='window.document.all["optYearly"][1].checked=true;'>
								<option value="1"><spring:message code='ezSchedule.t92' /></option>
								<option value="2"><spring:message code='ezSchedule.t93' /></option>
								<option value="3"><spring:message code='ezSchedule.t94' /></option>
								<option value="4"><spring:message code='ezSchedule.t95' /></option>
								<option value="5"><spring:message code='ezSchedule.t96' /></option>
			            	</select>
			            	<select name="select" id="list_YearlyDay" onFocus='window.document.all["optYearly"][1].checked=true;'>
			              		<option value="0"><spring:message code='ezSchedule.t81' /></option>
			              		<option value="1"><spring:message code='ezSchedule.t82' /></option>
			              		<option value="2"><spring:message code='ezSchedule.t83' /></option>
			              		<option value="3"><spring:message code='ezSchedule.t84' /></option>
			              		<option value="4"><spring:message code='ezSchedule.t85' /></option>
			              		<option value="5"><spring:message code='ezSchedule.t86' /></option>
			              		<option value="6"><spring:message code='ezSchedule.t87' /></option>
			            	</select>
							&nbsp;<spring:message code='ezSchedule.t98' />
						</div>	
					</td>
		  		</tr>
			</table>
			<br/>
			<h2><spring:message code='ezSchedule.t102' /></h2>
				<!-- 2018-05-16 구해안 반복설정 UI 수정(테이블 td rowspan="4") 및 시작일 -->
			<table class="content">
				<tr>
			    	<th align="right" rowspan="4">&nbsp;&nbsp;&nbsp;<spring:message code='ezTask.t65' />&nbsp;&nbsp;&nbsp;</th>
			    	<td width="100%">
			    		<span style="margin-left: 5px;" class="repeatRange"><spring:message code='ezTask.t121' /></span>
			        	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"/>
			    	</td>
			  	</tr>
			  	<tr>
			    	<td><div class="custom_radio"><input type="radio" id="Infinite" name="optRangeEnd" style="margin-top: -2px;" value="radiobutton" value="-1" onclick="selectOptRangeEnd()" checked><label for="Infinite"><spring:message code='ezSchedule.t111' /></label></div></td>
			  	</tr>
			  	<tr>
			    	<td>
			    		<div class="custom_radio">
			    			<input type="radio" id="Instances" name="optRangeEnd" style="margin-top: -2px;" value="radiobutton" value="1" onclick="selectOptRangeEnd()" /><label for="Instances"><spring:message code='ezSchedule.t112' /></label>
			    		</div>
			      		<input id="list_ReCount" type="number" class="disabled" max="99" onFocus="Instances.checked = true" style="text-align:center; width:70px;" value='10' disabled/><spring:message code='ezSchedule.t113'/>		      		
			      	</td>
			  	</tr>
			  	<tr>
			    	<td>
			    		<div class="custom_radio">
				    		<input id="EndTimeSet" type="radio" name="optRangeEnd" style="margin-top: -2px;" value="radiobutton" value="0" onclick="selectOptRangeEnd()" /><label for="EndTimeSet"><spring:message code='ezSchedule.t114' /></label>
			    		</div>
			      		<input type="text" class="disabled" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly" disabled/>
			    	</td>
			  	</tr>
			</table>
		</div>
		<div class="btnpositionNew"> 
		    <a class="imgbtn" onClick="ok_click()" ><span><spring:message code='ezSchedule.t4' /></span></a>
		    <a class="imgbtn" onClick="remove_click()" ><span><spring:message code='ezSchedule.t115' /></span></a>
		</div>
		<form name="postaldata" style="display:none">
			<input type="hidden" name="ZipCode" />
		  	<input type="hidden" name="Addr" />
		</form>
		<div id="fordisplay" style="DISPLAY: none"></div>
		<div id="printScreen" style="DISPLAY: none" width="100%"></div>
	</body>
</html>