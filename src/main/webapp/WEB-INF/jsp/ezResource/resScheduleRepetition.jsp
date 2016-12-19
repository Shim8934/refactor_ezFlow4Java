<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t274"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code="ezResource.e1"/>"></script>
		<script type="text/javascript" src="/js/ezResource/dlg_recurrence_cross.js"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript">
			var lang = "${userInfo.lang}";
			
		    function windows_close() {
		        window.close();
		    }
		    
	    	var RetValue;
	    	
	    	window.onload = function () {
		        window_onload();
	        	datepicker();
	        	datetimepicker();
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
	        	//사파리 브라우저일 경우
	        	if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0)  {
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

	        	var SDate, EDate;
	        	if (m_dlgArgs["alldaycheck"] == "1") {
		            try {
		                SDate = new Date(m_dlgArgs["startTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["startTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["startTime"].split(' ')[0].split('-')[2], m_dlgArgs["startTime"].split(' ')[1].split(':')[0], m_dlgArgs["startTime"].split(' ')[1].split(':')[1], 0, 0);
	                	EDate = new Date(m_dlgArgs["endTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["endTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["endTime"].split(' ')[0].split('-')[2], m_dlgArgs["endTime"].split(' ')[1].split(':')[0], m_dlgArgs["endTime"].split(' ')[1].split(':')[1], 0, 0);
	            	} catch (e) {
		                SDate = new Date(m_dlgArgs["startTime"]);
	                	EDate = new Date(m_dlgArgs["endTime"]);
	            	}            
	        	} else {
	            	try {
		                SDate = new Date(m_dlgArgs["startTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["startTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["startTime"].split(' ')[0].split('-')[2], m_dlgArgs["startTime"].split(' ')[1].split(':')[0], m_dlgArgs["startTime"].split(' ')[1].split(':')[1], 0, 0);
		                EDate = new Date(m_dlgArgs["endTime"].split(' ')[0].split('-')[0], parseInt(m_dlgArgs["endTime"].split(' ')[0].split('-')[1]) - 1, m_dlgArgs["endTime"].split(' ')[0].split('-')[2], m_dlgArgs["endTime"].split(' ')[1].split(':')[0], m_dlgArgs["endTime"].split(' ')[1].split(':')[1], 0, 0);
	    	        } catch (e) {
	                	SDate = new Date(m_dlgArgs["startTime"]);
	                	EDate = new Date(m_dlgArgs["endTime"]);
	            	}
	        	}

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
	    	
	    	if (lang == "1") {
	    		function datetimepicker() {
	        		$.datepicker.regional['ko'] = {
	            		closeText: '닫기',
	            		prevText: '이전달',
	            		nextText: '다음달',
	            		currentText: '오늘',
	            		monthNames: ['1<spring:message code="main.t00049"/>', '2<spring:message code="main.t00049"/>', '3<spring:message code="main.t00049"/>', '4<spring:message code="main.t00049"/>', '5<spring:message code="main.t00049"/>', '6<spring:message code="main.t00049"/>',
	            		'7<spring:message code="main.t00049"/>', '8<spring:message code="main.t00049"/>', '9<spring:message code="main.t00049"/>', '10<spring:message code="main.t00049"/>', '11<spring:message code="main.t00049"/>', '12<spring:message code="main.t00049"/>'],
	            		monthNamesShort: ['1<spring:message code="main.t00049"/>', '2<spring:message code="main.t00049"/>', '3<spring:message code="main.t00049"/>', '4<spring:message code="main.t00049"/>', '5<spring:message code="main.t00049"/>', '6<spring:message code="main.t00049"/>',
	            		'7<spring:message code="main.t00049"/>', '8<spring:message code="main.t00049"/>', '9<spring:message code="main.t00049"/>', '10<spring:message code="main.t00049"/>', '11<spring:message code="main.t00049"/>', '12<spring:message code="main.t00049"/>'],
	            		dayNames: ['일', '<spring:message code="main.t00049"/>', '화', '수', '목', '금', '토'],
	            		dayNamesShort: ['일', '<spring:message code="main.t00049"/>', '화', '수', '목', '금', '토'],
	            		dayNamesMin: ['일', '<spring:message code="main.t00049"/>', '화', '수', '목', '금', '토'],
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
		<h1><spring:message code="ezResource.t274"/></h1>
		<div id="TB_Promise">
  			<h2><spring:message code="ezResource.t275"/></h2>
  			<table class="content">
    			<tr>
      				<th><spring:message code="ezResource.t276"/><u>T</u>)</th>
      				<td>
      					<div>
          					<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
        					<label for="btnT1" accesskye="T"></label>
        					<input type="checkbox" value="1" id="alldaycheck" NAME="alldaycheck" />
        						<spring:message code="ezResource.t277"/></div></td>
    			</tr>
    			<tr>
      				<th><spring:message code="ezResource.t278"/><u>N</u>)</th>
      				<td>
          				<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
        				<label for="btnT2" accesskye="N"></label>
      				</td>
    			</tr>
  			</table>
		</div>
		<br>
		<h2><spring:message code="ezResource.t279"/></h2>
  		<table style="width:100%" class="content">
			<tr>
    			<td>
    				<input id="mpDaily" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(0);'>
      					<label for="mpDaily" accesskey="D"><spring:message code="ezResource.t280"/><u>D</u>)</label>
      				<input id="mpWeekly" type="radio" name="optMainPattern" value="radiobutton" checked onClick='showMainPattern(1);'>
      					<label for="mpWeekly" accesskey="W"><spring:message code="ezResource.t281"/><u>W</u>)</label>
      				<input id="mpMontly" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(2);'>
      					<label for="mpMontly" accesskey="M"><spring:message code="ezResource.t282"/><u>M</u>)</label>
      				<input id="mpYealy" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(3);'>
      					<label for="mpYealy" accesskey="Y"><spring:message code="ezResource.t283"/><u>Y</u>)</label>
    			</td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns" style="display:none">
    			<td  style="padding:10px;height:85px"><input id="id0D1" type="radio" name="optDaily" checked>            <label for="txt_De" accesskey="V"><spring:message code="ezResource.t285"/><u>V</u>)&nbsp;
            		<input name="text" type="text" id="txt_De" style="Width:40px;" onFocus='window.document.all["optDaily"][0].checked=true;' value="1" maxlength='3'>
          			&nbsp;<spring:message code="ezResource.t286"/></label><br>
					<input id="id0D2" type="radio" name="optDaily">          <label for="id0D2" accesskey="K"><spring:message code="ezResource.t287"/><u>K</u>)</label> </td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns">
    			<td  style="padding:10px;height:85px">&nbsp;<spring:message code="ezResource.t288"/>
      				<label for="txt_We" accesskey="C">
      					<input id="txt_We" type="text" name="textfield222" class="textarea" style="width:50px" value="1"> <spring:message code="ezResource.t289"/>
      				</label>
      				<div>
      					<input type="checkbox" name="day" id="day0" value="0"> <spring:message code="ezResource.t290"/>
						<input type="checkbox" name="day" id="day1" value="1"> <spring:message code="ezResource.t291"/>
						<input type="checkbox" name="day" id="day2" value="2"> <spring:message code="ezResource.t292"/>
						<input type="checkbox" name="day" id="day3" value="3"> <spring:message code="ezResource.t293"/><br>
            			<input type="checkbox" name="day" id="day4" value="4"> <spring:message code="ezResource.t294"/>
						<input type="checkbox" name="day" id="day5"  value="5"> <spring:message code="ezResource.t295"/>
						<input type="checkbox" name="day" id="day6" value="6"> <spring:message code="ezResource.t296"/></div></td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns" style="display:none">
    			<td  style="padding:10px;height:85px"><input type="radio" name='optMonthly' id="idOM1" checked>
            		<label for="idOM1" accesskey="A"><spring:message code="ezResource.t297"/><u>A</u>)&nbsp;</label>
            		<input name="Input" id="list_MonthInterval" style="Width:40px;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="1" maxlength="3">
					&nbsp;<spring:message code="ezResource.t298"/>
            		<input name="Input" id="list_MonthlyDays" style="Width:40px;" onFocus='window.document.all["optMonthly"][0].checked=true;' maxlength="2">
					&nbsp;<spring:message code="ezResource.t299"/><br>
					<input id="id0M2" type="radio" name='optMonthly'>          <label for="id0M2" accesskey="E"><spring:message code="ezResource.t300"/><u>E</u>)&nbsp;</label>
            		<input name="Input" id="list_MonthInterval2" style="Width:40px;" onFocus='window.document.all["optMonthly"][1].checked=true;' value="1" maxlength="3">
					&nbsp;<spring:message code="ezResource.t298"/>
            		<select name="select" id="list_MonthlyEach" onFocus='window.document.all["optMonthly"][1].checked=true;'>
              			<option value="1"><spring:message code="ezResource.t301"/></option>
              			<option value="2"><spring:message code="ezResource.t302"/></option>
              			<option value="3"><spring:message code="ezResource.t303"/></option>
              			<option value="4"><spring:message code="ezResource.t304"/></option>
              			<option value="-1"><spring:message code="ezResource.t305"/></option>
            		</select>
            		<select name="select" id="list_MonthlyDay" onFocus='window.document.all["optMonthly"][1].checked=true;'>
              			<option value="8"><spring:message code="ezResource.t306"/></option>
              			<option value="9"><spring:message code="ezResource.t307"/></option>
              			<option value="0"><spring:message code="ezResource.t290"/></option>
              			<option value="1"><spring:message code="ezResource.t291"/></option>
              			<option value="2"><spring:message code="ezResource.t292"/></option>
              			<option value="3"><spring:message code="ezResource.t308"/></option>
              			<option value="4"><spring:message code="ezResource.t294"/></option>
              			<option value="5"><spring:message code="ezResource.t295"/></option>
              			<option value="6"><spring:message code="ezResource.t296"/></option>
            		</select>
					&nbsp;<spring:message code="ezResource.t309"/>
				</td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns" style="display:none">
    			<td  style="padding:10px;height:85px"><input id="optY1" type="radio" name="optYearly" value="radiobutton" checked>
            		<label for="optY1" accesskey="A"><spring:message code="ezResource.t297"/><u>A</u>)&nbsp;</label>
            		<select name="select" id="list_Month" onFocus='window.document.all["optYearly"][0].checked=true;'>
              			<option value="1">1<spring:message code="main.t00049"/></option>
              			<option value="2">2<spring:message code="main.t00049"/></option>
              			<option value="3">3<spring:message code="main.t00049"/></option>
              			<option value="4">4<spring:message code="main.t00049"/></option>
              			<option value="5">5<spring:message code="main.t00049"/></option>
              			<option value="6">6<spring:message code="main.t00049"/></option>
              			<option value="7">7<spring:message code="main.t00049"/></option>
              			<option value="8">8<spring:message code="main.t00049"/></option>
              			<option value="9">9<spring:message code="main.t00049"/></option>
              			<option value="10">10<spring:message code="main.t00049"/></option>
              			<option value="11">11<spring:message code="main.t00049"/></option>
              			<option value="12">12<spring:message code="main.t00049"/></option>
            		</select>
            		
            		<input name="Input" class="text" id="list_YearlyDays" style="Width:40px;" onFocus='window.document.all["optYearly"][0].checked=true;' maxlength="2">
					&nbsp;<spring:message code="ezResource.t311"/><br>
					<input id="optY2" type="radio" name="optYearly" value="radiobutton">          <label for="optY2" accesskey="E"><spring:message code="ezResource.t300"/><u>E</u>)&nbsp;</label>
					
            		<select name="select" id="list_Month2" onFocus='window.document.all["optYearly"][1].checked=true;'>
              			<option value="1">1<spring:message code="main.t00049"/></option>
              			<option value="2">2<spring:message code="main.t00049"/></option>
              			<option value="3">3<spring:message code="main.t00049"/></option>
              			<option value="4">4<spring:message code="main.t00049"/></option>
              			<option value="5">5<spring:message code="main.t00049"/></option>
              			<option value="6">6<spring:message code="main.t00049"/></option>
              			<option value="7">7<spring:message code="main.t00049"/></option>
              			<option value="8">8<spring:message code="main.t00049"/></option>
              			<option value="9">9<spring:message code="main.t00049"/></option>
              			<option value="10">10<spring:message code="main.t00049"/></option>
              			<option value="11">11<spring:message code="main.t00049"/></option>
              			<option value="12">12<spring:message code="main.t00049"/></option>
            		</select>
            		<select name="select" id="list_YearlyEach" onFocus='window.document.all["optYearly"][1].checked=true;'>
              			<option value="1"><spring:message code="ezResource.t301"/></option>
              			<option value="2"><spring:message code="ezResource.t302"/></option>
              			<option value="3"><spring:message code="ezResource.t303"/></option>
              			<option value="4"><spring:message code="ezResource.t304"/></option>
              			<option value="-1"><spring:message code="ezResource.t305"/></option>
            		</select>
            		<select name="select" id="list_YearlyDay" onFocus='window.document.all["optYearly"][1].checked=true;'>
              			<option value="8"><spring:message code="ezResource.t306"/></option>
              			<option value="9"><spring:message code="ezResource.t307"/></option>
              			<option value="0"><spring:message code="ezResource.t290"/></option>
              			<option value="1"><spring:message code="ezResource.t291"/></option>
              			<option value="2"><spring:message code="ezResource.t292"/></option>
              			<option value="3"><spring:message code="ezResource.t308"/></option>
              			<option value="4"><spring:message code="ezResource.t294"/></option>
              			<option value="5"><spring:message code="ezResource.t295"/></option>
              			<option value="6"><spring:message code="ezResource.t296"/></option>
            		</select>
					&nbsp;<spring:message code="ezResource.t309"/></td>
  			</tr>
		</table>
  		<br>
		<h2><spring:message code="ezResource.t312"/></h2>
		<table class="content">
  			<tr>
    			<th style="text-align:right"><spring:message code="ezResource.t313"/><u>S</u>)</th>
    			<td width="100%">
        			<input type="text" id="Sdatepicker" style="width:80px;text-align:center">
     			</td>
  			</tr>
  			<tr>
    			<th style="text-align:right">    </th>
    			<td><input type="radio" name="optRangeEnd" value="radiobutton" checked><spring:message code="ezResource.t314"/></td>
  			</tr>
  			<tr>
    			<th align="right"></th>
    			<td>
    				<input type="radio" id="Instances" name="optRangeEnd"  value="radiobutton"> <spring:message code="ezResource.t315"/>
      				<input id="list_ReCount" maxlength="3" onFocus="Instances.checked = true" size="4" value='10'>
      					<spring:message code="ezResource.t316"/>
      			</td>
  			</tr>
  			<tr>
    			<th align="right"></th>
    			<td>
    				<input id="EndTimeSet" type="radio" name="optRangeEnd" value="radiobutton"><spring:message code="ezResource.t317"/>
      				<input type="text" id="Edatepicker" style="width:80px;text-align:center">
      			</td>
  			</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"  onclick='event_btnOk_onclick()'><span><spring:message code="ezResource.t15"/></span></a>
    		<a class="imgbtn" onclick='event_btnCancel_onclick()'><span><spring:message code="ezResource.t16"/></span></a>
    		<a class="imgbtn" onclick='event_btnRemoveRecurrence_onclick()'><span><spring:message code="ezResource.t318"/></span></a>
		</div>
		<form name="postaldata" style="display:none">
  			<input type="hidden" name="ZipCode">
  			<input type="hidden" name="Addr">
		</form>
		<div id="fordisplay" style="DISPLAY: none"></div>
		<div id="printScreen" style="DISPLAY: none; width:100%"></div>
	</body>
</html>