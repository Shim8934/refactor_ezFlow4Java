<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t274"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/dlg_recurrence_cross.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript">
			var lang = "${userInfo.lang}";
			var pRepetitionFlag = 1; //0:매일, 1:매주, 2:매월, 3:매년 (매주가 default이므로 초기설정)
			var sTimeTemp = "";
		    var eTimeTemp = "";
			
		    function windows_close() {
		        window.close();
		    }
		    
	    	var RetValue;
	    	window.onload = function () {
		        window_onload();
	        	datepicker();        
	        	allDayTime();
	        	clearAllDay();
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
	        	
		        sTimeTemp = $('#Stimepicker').val();
		        eTimeTemp = $('#Etimepicker').val();
	    	}
	    	
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
			
	    	function changeDate(isStartDate) {
	    		if (($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
					if (isStartDate) {
						$("#Edatepicker").datepicker('setDate', $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
					} else {
						$("#Sdatepicker").datepicker('setDate', $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
					}
	    		}
			}
	    	
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
	    	
	    	//#14117 천성준 - 반복예약 시, 시작일과 끝날짜의 날짜가 어긋나지 않게 로직추가 (ex. 끝날짜가 시작일보다 앞에있는경우, 시작일이 끝날짜보다 뒤에있는경우)
	    	function timeChecker(mode) {
	    		var ssDate = $("#Sdatepicker").datepicker().val();
	        	var eeDate = $("#Edatepicker").datepicker().val();
	        	
	        	if (mode == "sDate") {
		        	if (ssDate > eeDate) {
		        		$("#Edatepicker").datepicker().val(ssDate);
		        	} 
	        	} else if (mode == "eDate") {
		        	if (ssDate > eeDate) {
		        		$("#Sdatepicker").datepicker().val(eeDate);
		        	} 
	        	}
	    	}
	    	
	    	function setTimePickerReadOnly() {
		    	$('#Stimepicker').attr('disabled','disabled');
	    		$('#Etimepicker').attr('disabled','disabled');
		    }
		    
			function setTimePickerModifiable() {
				$('#Stimepicker').removeAttr('disabled');
	    		$('#Etimepicker').removeAttr('disabled');
		    }
	    	
	    	/* 2019-02-19 김민성 - 자원관리 하루종일 체크시 시간 00:00로 변경(일정관리와 스펙 맞춤)
	    								  - 하루종일 체크 해제시 현재 시간 기준 30분 단위 표시로 수정 */
	    	function allDayTime(){
	    		if(document.getElementById("alldaycheck").checked == true){
	    			sTimeTemp = $('#Stimepicker').val();
		    		eTimeTemp = $('#Etimepicker').val();
		    		$('#Stimepicker').timepicker("setTime", "00:00");
		    		$('#Etimepicker').timepicker("setTime", "00:00");
		    		setTimePickerReadOnly();
		    	}else if(sTimeTemp != null){
		    		setTimePickerModifiable();
		    		
		    		$('#Stimepicker').timepicker("setTime", sTimeTemp);
		    		$('#Etimepicker').timepicker("setTime", eTimeTemp == "23:59" ? "23:30" : eTimeTemp);
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
		    		if($('#Stimepicker').val() == "00:00" && $('#Etimepicker').val() == "00:00"){
		    			$("#alldaycheck").prop("checked", true);
		    			setTimePickerReadOnly();
		    		}
		    	});
		    	$('#Etimepicker').change(function(){
		    		if($("#alldaycheck").prop("checked") == true){
		    			$("#alldaycheck").prop("checked", false);
		    		}
		    		if(($('#Stimepicker').val() == "00:00") && ($('#Etimepicker').val() == "00:00")){
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
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code="ezResource.t274"/></h1>
		<div id="close">
            <ul>
                <li><span onclick="event_btnCancel_onclick()"></span></li>
            </ul>
        </div>
		<div id="TB_Promise">
  			<h2><spring:message code="ezResource.t275"/></h2>
  			<table class="content">
    			<tr>
      				<th><spring:message code="ezResource.t276"/></th>
      				<td>
       					<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:3px;text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
     					<label for="btnT1"></label>
     					<div class="custom_checkbox">
	     					<input type="checkbox" value="1" id="alldaycheck" NAME="alldaycheck" onclick="allDayTime()" />
     					</div>
     					<spring:message code="ezResource.t277"/>
        			</td>
    			</tr>
    			<tr>
      				<th><spring:message code="ezResource.t278"/></th>
      				<td>
          				<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:3px;text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
        				<label for="btnT2"></label>
      				</td>
    			</tr>
  			</table>
		</div>
		<br>
		<h2><spring:message code="ezResource.t279"/></h2>
  		<table style="width:100%" class="content">
			<tr>
    			<td>
    				<div class="custom_radio">
	    				<input id="mpDaily" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(0);'>
    				</div>
      					<label for="mpDaily"><spring:message code="ezResource.t280"/></label>
    				<div class="custom_radio">
    	  				<input id="mpWeekly" type="radio" name="optMainPattern" value="radiobutton" checked onClick='showMainPattern(1);'>
    				</div>
      					<label for="mpWeekly"><spring:message code="ezResource.t281"/></label>
    				<div class="custom_radio">
      					<input id="mpMontly" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(2);'>
    				</div>
      					<label for="mpMontly"><spring:message code="ezResource.t282"/></label>
    				<div class="custom_radio">
      					<input id="mpYearly" type="radio" name="optMainPattern" value="radiobutton" onClick='showMainPattern(3);'>
    				</div>
      					<label for="mpYearly"><spring:message code="ezResource.t283"/></label>
    			</td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns" style="display:none">
    			<td style="padding:10px;height:85px">
    				<div class="custom_radio">
	    				<input id="id0D1" type="radio" name="optDaily" checked>
    				</div>
    				<label for="txt_De">
    					<spring:message code="ezResource.t285"/>&nbsp;
            			<input name="text" type="text" id="txt_De" style="Width:40px;text-align:center;" onFocus='window.document.all["optDaily"][0].checked=true;' value="1" maxlength='3'>
          				&nbsp;<spring:message code="ezResource.t286"/>
          			</label>
          			<br>
    				<div class="custom_radio">
						<input id="id0D2" type="radio" name="optDaily">
    				</div>
					<label for="id0D2"><spring:message code="ezResource.t287"/></label>
				</td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns">
    			<td  style="padding:10px;height:85px">
    				<span style="margin-left:4px"><spring:message code="ezResource.t288"/></span>
      				<label for="txt_We">
      					<input id="txt_We" type="text" name="textfield222" class="textarea" style="width:50px;text-align:center;" value="1">
      					<spring:message code="ezResource.t289"/>
      				</label>
      				<div id="daytable">
      					<div class="custom_checkbox">
	      					<input type="checkbox" name="day" id="day0" value="0">
      					</div>
      					 <spring:message code="ezResource.t290"/>
      					<div class="custom_checkbox">
							<input type="checkbox" name="day" id="day1" value="1"> 
      					</div>
						<spring:message code="ezResource.t291"/>
      					<div class="custom_checkbox">
							<input type="checkbox" name="day" id="day2" value="2">
      					</div>
						 <spring:message code="ezResource.t292"/>
      					<div class="custom_checkbox">
							<input type="checkbox" name="day" id="day3" value="3">
      					</div>
						 <spring:message code="ezResource.t293"/><br>
      					<div class="custom_checkbox">
            				<input type="checkbox" name="day" id="day4" value="4">
      					</div>
           				 <spring:message code="ezResource.t294"/>
      					<div class="custom_checkbox">
							<input type="checkbox" name="day" id="day5" value="5">
      					</div>
						 <spring:message code="ezResource.t295"/>
      					<div class="custom_checkbox">
							<input type="checkbox" name="day" id="day6" value="6"> 
      					</div>
						<spring:message code="ezResource.t296"/>
					</div>
				</td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns" style="display:none">
    			<td style="padding:10px;height:85px">
	    			<div class="custom_radio">
	    				<input type="radio" name='optMonthly' id="idOM1" checked>
	    			</div>
            		<label for="idOM1"><spring:message code="ezResource.t297"/>&nbsp;</label>
            		<input name="Input" id="list_MonthInterval" style="Width:40px;text-align:center;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="1" maxlength="3">&nbsp;
					<spring:message code="ezResource.t298"/>
            		<input name="Input" id="list_MonthlyDays" style="Width:40px;text-align:center;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="" maxlength="2">&nbsp;
					<spring:message code="ezResource.t299"/>
					<br>
	    			<div class="custom_radio">
						<input id="id0M2" type="radio" name='optMonthly'>
	    			</div>
					<label for="id0M2"><spring:message code="ezResource.t300"/>&nbsp;</label>
            		<input name="Input" id="list_MonthInterval2" style="Width:40px;text-align:center;" onFocus='window.document.all["optMonthly"][1].checked=true;' value="1" maxlength="3">&nbsp;
					<spring:message code="ezResource.t298"/>
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
            		</select>&nbsp;
					<spring:message code="ezResource.t309"/>
				</td>
  			</tr>
  			<tr id='divRecurPatterns' name="divRecurPatterns" style="display:none">
    			<td  style="padding:10px;height:85px"><div class="custom_radio"><input id="optY1" type="radio" name="optYearly" value="radiobutton" checked></div>
            		<label for="optY1"><spring:message code="ezResource.t297"/>&nbsp;</label>
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
            		
            		<input name="Input" class="text" id="list_YearlyDays" style="Width:40px;text-align:center;" onFocus='window.document.all["optYearly"][0].checked=true;' maxlength="2">&nbsp;
					<spring:message code="ezResource.t311"/>
					<br>
					<div class="custom_radio">
						<input id="optY2" type="radio" name="optYearly" value="radiobutton">
					</div>
					<label for="optY2" accesskey="E"><spring:message code="ezResource.t300"/>&nbsp;</label>
					
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
            		</select>&nbsp;
					<spring:message code="ezResource.t309"/></td>
  			</tr>
		</table>
  		<br>
		<h2><spring:message code="ezResource.t312"/></h2>
			<!-- 2018-05-24 구해안  자원예약 반복설정 UI 수정-->
		<table class="content">
			<tr>
		    	<th align="right" rowspan="4">&nbsp;&nbsp;&nbsp;<spring:message code='ezTask.t65' />&nbsp;&nbsp;&nbsp;</th>
		    	<td width="100%">
		    		<span style="margin-left: 5px;" class="repeatRange"><spring:message code='ezTask.t121' /></span>
		        	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly" onchange="timeChecker('sDate')"/>
		    	</td>
		  	</tr>
		  	<%-- <tr>
		    	<td><input type="radio" name="optRangeEnd" value="radiobutton" value="-1" checked><spring:message code='ezResource.t314' /></td>
		  	</tr> --%>
		  	<tr>
		    	<td>
		    		<div class="custom_radio">
			    		<input type="radio" id="Instances" name="optRangeEnd"  value="radiobutton" value="1"/><spring:message code='ezResource.t315' />
		    		</div>
		      		<input id="list_ReCount" maxlength="3" onFocus="Instances.checked = true" style="text-align:center;" size="4" value='10' /><spring:message code='ezResource.t316' />		      		
		      	</td>
		  	</tr>
		  	<tr>
		    	<td>
		    		<div class="custom_radio">
			    		<input id="EndTimeSet" type="radio" name="optRangeEnd" value="radiobutton" value="0" checked/><spring:message code='ezResource.t317' />
		    		</div>
		      		<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly" onchange="timeChecker('eDate')"/>
		    	</td>
		  	</tr>
		</table>
		<div class="btnpositionNew">
		    <a class="imgbtn" onclick='event_btnOk_onclick()'><span><spring:message code="ezResource.t15"/></span></a>    		
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