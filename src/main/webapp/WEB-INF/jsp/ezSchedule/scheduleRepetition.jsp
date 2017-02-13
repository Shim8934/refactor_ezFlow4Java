<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t59' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />		
        <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
	    <script type="text/javascript" src="/js/ezSchedule/dlg_schedule.js"></script>
	    
		<!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>		
	    <script type="text/javascript">
		    var RetValue;
		    var ReturnFunction;
		    
		    window.onload = function()
		    {   
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
		    				}
		    				else
		    				{
		    					id0M2.checked = true;
		    					list_MonthInterval2.value = info[4];
		    					list_MonthlyEach.value = info[5];
		    					list_MonthlyDay.value = info[6];
		    				}
		    			break;
		    			case "3":
		    				mpYearly.checked = true;
		    				if (info[3] == "1")
		    				{
		    					optY1.checked = true;
		    					list_Month.value = info[4];
		    					list_YearlyDays.value = info[5];
		    					
		    					
		    				}
		    				else
		    				{
		    					optY2.checked = true;
		    					list_Month2.value = info[4];
		    					list_YearlyEach.value = info[5];
		    					list_YearlyDay.value = info[6];
		    				}
		    		}
		    	}
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("txt_We"));
		                KeEventControl(document.getElementById("txt_De"));
		                KeEventControl(document.getElementById("list_MonthInterval"));
		                KeEventControl(document.getElementById("list_MonthlyDays"));
		                KeEventControl(document.getElementById("list_MonthInterval2"));
		                KeEventControl(document.getElementById("list_YearlyDays"));
		                KeEventControl(document.getElementById("list_ReCount"));		                
		            }
		        }
		        catch (e) { }
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
	
		    	if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) == parseInt(endDay))) {
		    	    if (document.getElementById("alldaycheck").checked == false && (shour > ehour || (shour == ehour && sminute >= eminute))) {
		    	        alert("<spring:message code='ezSchedule.t60' />");
		    	        return;
		    	    }
		    	}
		    	var allDayString = "";
		    	var scheduleTerm = "";	
		    	var occurrenceTerm = "";			
		    	var recurString = "";			
		        
		        scheduleTerm = getPickerDate();
		        occurrenceTerm = occurrencDate();
		        
		    	if (document.getElementsByName("optRangeEnd")[0].checked == true)
		    	{
		    		repetition = "-1";		
		    	}
		    	else if (document.getElementsByName("optRangeEnd")[1].checked == true)
		    	{
		    		if (list_ReCount.value == parseInt(list_ReCount.value) && parseInt(list_ReCount.value) > 0)
		    		{
		    			repetition = parseInt(list_ReCount.value);
		    		}
		    		else
		    		{
		    			alert("<spring:message code='ezSchedule.t61' />");
		    			list_ReCount.focus();
		    			return;
		    		}		
		    	}
		    	else
		    	{
		    		repetition = "0";				
		    	}
		    	
		    	if (alldaycheck.checked == true)
		    	{
		    		repetition += "|1";
		    		allDayString = strLang39;
		    	}
		    	else
		    	{
		    		repetition += "|0";
		    	}
		    		
		    	if (mpDaily.checked == true)
		    	{
		    		repetition += "|0";
		    		
		    		if (id0D2.checked == true)
		    		{
		    			repetition += "|0";						
		    			recurString = strLang45;
		    			
		    		}
		    		else
		    		{
		    			if (txt_De.value == parseInt(txt_De.value) && parseInt(txt_De.value) > 0)
		    				repetition += "|" + parseInt(txt_De.value);
		    			else
		    			{
		    				alert("<spring:message code='ezSchedule.t62' />");
		    				txt_De.focus();
		    				return;
		    			}
		    			
		    			if(txt_De.value == "1")
		    			{
		                    recurString = strLang34;						
		    			}
		    			else
		    			{
		    			    recurString = txt_De.value + strLang81;						
		    			}						
		    		}
		    	}
		    	else if (mpWeekly.checked == true)
		    	{
		    		repetition += "|1";				
		    		
		    		if (txt_We.value == parseInt(txt_We.value) && parseInt(txt_We.value) > 0)
		    			repetition += "|" + parseInt(txt_We.value);
		    		else
		    		{
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
		    				recurString = recurString + getDaystring(i);
		    											
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
		    			    recurString = strLang36 + " " + getOdinalString(parseInt(list_MonthlyEach.value)) + " " + getFullDaystring(parseInt(list_MonthlyDay.value));
		    			}
		    			else
		    			{					
		    			    recurString =  list_MonthInterval2.value + strLang83 + " " + getOdinalString(parseInt(list_MonthlyEach.value)) + " " + getFullDaystring(parseInt(list_MonthlyDay.value));					
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
		    			
		    			recurString = recurString + " " + getMonthString(parseInt(list_Month.value)) + list_YearlyDays.value + strLang80;					
		    			
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
		    			
		    			recurString = recurString + " " + getMonthString(parseInt(list_Month2.value)) + " " + getOdinalString(parseInt(list_YearlyEach.value)) + " " + getFullDaystring(parseInt(list_YearlyDay.value));
		    		}				
		    	}
		    	
		    	rtn["REPETITION"] = repetition;
		    	if(allDayString =="")
		    	{
		    	    rtn["REPDISPLAY"] = recurString + " " + occurrenceTerm + ", " + strLang79 + ":" + scheduleTerm;
		    	}
		    	else
		    	{
		    	    rtn["REPDISPLAY"] = recurString + " " + allDayString + ", " + strLang79 + ":" + scheduleTerm;
		    	}
		    	if (ReturnFunction != null) {
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
	
		        repeatinfo += reStartHour + ":" + reStartMinute + "" + " ~ " + "";
		        
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
	
		    function getDaystring(cnt)
		    {			
		        var rtnString = "";
		        switch (cnt)
		    	{
		    		case 0:					   
		    			rtnString = strLang48;
		    			break;
		    		case 1:
		    			rtnString = strLang49;
		    			break;
		    		case 2:
		    			rtnString = strLang50;
		    			break;
		    		case 3:
		    			rtnString = strLang51;
		    			break;
		    		case 4:
		    			rtnString = strLang52;
		    			break;
		    		case 5:
		    			rtnString = strLang53;
		    			break;
		    		case 6:
		    			rtnString = strLang54;
		    			break;	
		    	}				
		    	return " " + rtnString;
		    }
		    function getFullDaystring(cnt)
		    {
		        var rtnString = "";
		        switch (cnt)
		    	{
		    		case 0:
		    			rtnString = strLang60;
		    			break;
		    		case 1:
		    			rtnString = strLang61;
		    			break;
		    		case 2:
		    			rtnString = strLang62;
		    			break;
		    		case 3:
		    			rtnString = strLang63;
		    			break;
		    		case 4:
		    			rtnString = strLang64;
		    			break;
		    		case 5:
		    			rtnString = strLang65;
		    			break;
		    		case 6:
		    			rtnString = strLang66;
		    			break;	
		    	}
		    	return rtnString;
		    }
		    function getOdinalString(cnt)
		    {			
		        var rtnString = "";
		        switch (cnt)
		    	{					
		    		case 1:
		    			rtnString = strLang55;
		    			break;
		    		case 2:
		    			rtnString = strLang56;
		    			break;
		    		case 3:
		    			rtnString = strLang57;
		    			break;
		    		case 4:
		    			rtnString = strLang58;
		    			break;
		    		case 5:
		    			rtnString = strLang59;
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
		    }
		    if ("${lang}" == "1") {
			    function datetimepicker() {
			        $.datepicker.regional['ko'] = {
			            closeText: '닫기',
			            prevText: '이전달',
			            nextText: '다음달',
			            currentText: '오늘',
			            monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
			            '7월', '8월', '9월', '10월', '11월', '12월'],
			            monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
			            '7월', '8월', '9월', '10월', '11월', '12월'],
			            dayNames: ['일', '월', '화', '수', '목', '금', '토'],
			            dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
			            dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
			            weekHeader: 'Wk',
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['ko']);
			    }
		    } else {
			    function datetimepicker() {
			        $.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['en']);
			    }
		    }		    
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezSchedule.t59' /></h1>
		<div id="TB_Promise">
			<h2><spring:message code='ezSchedule.t67' /></h2>
		  	<table class="content">
		    	<tr>
		      		<th><spring:message code='ezSchedule.t68' /><u>T</u>)</th>
		      		<td>
		      			<div>
		          			<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
		        			<label for="btnT1" accesskye="T"></label>
		        			<input type="checkbox" value="1" id="alldaycheck" NAME="alldaycheck" />
		        			<spring:message code='ezSchedule.t69' />
		        		</div>
		        	</td>
		    	</tr>
			    <tr>
			    	<th><spring:message code='ezSchedule.t70' /><u>N</u>)</th>
			      	<td>
			        	<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
			        	<label for="btnT2" accesskye="N"></label>
			      	</td>
			    </tr>
			</table>
		</div><br/>		
		<h2><spring:message code='ezSchedule.t71' /></h2>
		<table width="100%" class="content">
	  		<tr>
	    		<td>
	    			<input id="mpDaily" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(0);' />
	      			<label for="mpDaily" accesskey="D"><spring:message code='ezSchedule.t72' /><u>D</u>)</label>
	      			<input id="mpWeekly" type="radio" name="optMainPattern" value="radiobutton" checked onClick='showMainPattern(1);' />
	      			<label for="mpWeekly" accesskey="W"><spring:message code='ezSchedule.t73' /><u>W</u>)</label>
	      			<input id="mpMonthly" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(2);' />
	      			<label for="mpMonthly" accesskey="M"><spring:message code='ezSchedule.t74' /><u>M</u>)</label>
	      			<input id="mpYealy" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(3);' />
	      			<label for="mpYealy" accesskey="Y"><spring:message code='ezSchedule.t75' /><u>Y</u>)</label>
	    		</td>
	  		</tr>
	  		<tr id='divRecurPatterns' style="display:none">
	    		<td  style="padding:10px;height:85px">
	    			<div>
		    			<input id="id0D1" type="radio" name="optDaily" checked />
	    				<label for="txt_De" accesskey="V">
	            			<input name="text" type="text" id="txt_De" style="Width:40px;" onFocus='window.document.all["optDaily"][0].checked=true;' value="1" maxlength='3' />
	          				&nbsp;<spring:message code='ezSchedule.t77' />
	          			</label>
	          		</div>
	          		<div style="margin-top:3px">	
        				<input id="id0D2" type="radio" name="optDaily" />
        				<label for="id0D2" accesskey="K"><spring:message code='ezSchedule.t78' /><u>K</u>)</label>
        			</div>	
	        	</td>
	  		</tr>
	  		<tr id='divRecurPatterns'>
	    		<td style="padding:10px;height:85px">
	    			&nbsp;<spring:message code='ezSchedule.t79' />
	      			<label for="txt_We" accesskey="C">
	      				<input id="txt_We" type="text" name="textfield222" class="textarea" style="width:50px" value="1" />
	      				<spring:message code='ezSchedule.t80' />
	      			</label>
	      			<div id="daytable">
	      				<input type="checkbox" name="day" id="day0" value="0" />
	            		<spring:message code='ezSchedule.t81' />
						<input type="checkbox" name="day" id="day1" value="1" />
	            		<spring:message code='ezSchedule.t82' />
						<input type="checkbox" name="day" id="day2" value="2" />
			            <spring:message code='ezSchedule.t83' />
						<input type="checkbox" name="day" id="day3" value="3" />
			            <spring:message code='ezSchedule.t84' /><br>
			            <input type="checkbox" name="day" id="day4" value="4" />
			            <spring:message code='ezSchedule.t85' />
						<input type="checkbox" name="day"id="day5"  value="5" />
			            <spring:message code='ezSchedule.t86' />
						<input type="checkbox" name="day" id="day6" value="6" />
			            <spring:message code='ezSchedule.t87' />
					</div>
				</td>
	  		</tr>
	  		<tr id='divRecurPatterns' style="display:none">
	    		<td style="padding:10px;height:85px">
	    			<div>
	    				<input type="radio" name='optMonthly' id="idOM1" checked />
	            		<label for="idOM1" accesskey="A"><spring:message code='ezSchedule.t88' /><u>A</u>)&nbsp;</label>	            	
		            	<input name="Input" id="list_MonthInterval" style="Width:40px;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="1" maxlength="3" />
						&nbsp;<spring:message code='ezSchedule.t89' />
		            	<input name="Input" id="list_MonthlyDays" style="Width:40px;" onFocus='window.document.all["optMonthly"][0].checked=true;' maxlength="2" />
						&nbsp;<spring:message code='ezSchedule.t90' />
					</div>
					<div style="margin-top:3px">						
						<input id="id0M2" type="radio" name='optMonthly' />
						<label for="id0M2" accesskey="E"><spring:message code='ezSchedule.t91' /><u>E</u>)&nbsp;</label>
		            	<input name="Input" id="list_MonthInterval2" style="Width:40px;" onFocus='window.document.all["optMonthly"][1].checked=true;' value="1" maxlength="3" />
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
		    			<input id="optY1" type="radio" name="optYearly" value="radiobutton" checked />
		            	<label for="optY1" accesskey="A"></label>
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
		            	<input name="Input" class="text" id="list_YearlyDays" style="Width:40px;" onFocus='window.document.all["optYearly"][0].checked=true;' maxlength="2" />
						&nbsp;<spring:message code='ezSchedule.t100' />
					</div>
		            <div style="margin-top:3px">	
						<input id="optY2" type="radio" name="optYearly" value="radiobutton" />
						<label for="optY2" accesskey="E"></label>
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
							<option value="-1"><spring:message code='ezSchedule.t96' /></option>
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
		<table class="content">
			<tr>
		    	<th align="right"><spring:message code='ezSchedule.t103' /><u>S</u>)</th>
		    	<td width="100%">
		        	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" />
		    	</td>
		  	</tr>
		  	<tr>
		    	<th align="right"></th>
		    	<td><input type="radio" name="optRangeEnd" value="radiobutton" value="-1" checked><spring:message code='ezSchedule.t111' /></td>
		  	</tr>
		  	<tr>
		    	<th align="right"></th>
		    	<td>
		    		<input type="radio" id="Instances" name="optRangeEnd"  value="radiobutton" value="1"/><spring:message code='ezSchedule.t112' />
		      		<input id="list_ReCount" maxlength="3" onFocus="Instances.checked = true" size="4" value='10' /><spring:message code='ezSchedule.t113' />		      		
		      	</td>
		  	</tr>
		  	<tr>
		    	<th align="right"></th>
		    	<td>
		    		<input id="EndTimeSet" type="radio" name="optRangeEnd" value="radiobutton" value="0"/><spring:message code='ezSchedule.t114' />
		      		<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
		    	</td>
		  	</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn" onClick="ok_click()" ><span><spring:message code='ezSchedule.t4' /></span></a>
		    <a class="imgbtn" onClick="windows_close()" ><span><spring:message code='ezSchedule.t5' /></span></a>
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