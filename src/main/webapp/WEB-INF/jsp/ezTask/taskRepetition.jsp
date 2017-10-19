<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezTask.t21' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script type="text/javascript">
		
		    var ReturnFunction;
		    var m_dialogArguments;
		    var lang = "{userInfo.lang}";
		    window.onload = function () {
		        try {
		            m_dialogArguments = parent.task_repetition_cross_dialogArguments[0];
		            ReturnFunction = parent.task_repetition_cross_dialogArguments[1];
		        }
		        catch (e) {
		            m_dialogArguments = window.dialogArguments;
		        }
		
		        if (m_dialogArguments["EDATE"] != $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() || m_dialogArguments["SDATE"] != $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) {
		            $("#Sdatepicker").datepicker('setDate', m_dialogArguments["SDATE"]);
		            $("#Edatepicker").datepicker('setDate', m_dialogArguments["EDATE"]);
		        }
		
		        var repetition = m_dialogArguments["REPETITION"];
		        
		
		        if (repetition != "") {
		            var info = repetition.split("|");
		
		            switch (info[0]) {
		                case "-1":
		                    range1.checked = true;
		                    break;
		                case "0":
		                    range3.checked = true;
		                    break;
		                default:
		                    range2.checked = true;
		                    list_ReCount.value = info[0];
		                    break;
		            }
		
		            if (info[1] == "1")
		                alldaycheck.checked = true;
		
		            showMainPattern(info[2]);
		
		            switch (info[2]) {
		                case "0":
		                    mpDaily.checked = true;
		                    if (info[3] == "0")
		                        id0D2.checked = true;
		                    else {
		                        id0D1.checked = true;
		                        txt_De.value = info[3];
		                    }
		                    break;
		                case "1":
		                    mpWeekly.checked = true;
		                    txt_We.value = info[3];
		                    for (var i = 0; i < info[4].length; i++) {
		                        var idx = parseInt(info[4].substr(i, 1));
		                        daytable.getElementsByTagName("input").item(idx).checked = true;
		                    }
		                    break;
		                case "2":
		                    mpMonthly.checked = true;
		                    if (info[3] == "1") {
		                        idOM1.checked = true;
		                        list_MonthInterval.value = info[4];
		                        list_MonthlyDays.value = info[5];
		                    }
		                    else {
		                        id0M2.checked = true;
		                        list_MonthInterval2.value = info[4];
		                        list_MonthlyEach.value = info[5];
		                        list_MonthlyDay.value = info[6];
		                    }
		                    break;
		                case "3":
		                    mpYearly.checked = true;
		                    if (info[3] == "1") {
		                        optY1.checked = true;
		                        list_Month.value = info[4];
		                        list_YearlyDays.value = info[5];
		
		                        if (info[6] == "2")
		                            moonday.checked = true;
		                    }
		                    else {
		                        optY2.checked = true;
		                        list_Month2.value = info[4];
		                        list_YearlyEach.value = info[5];
		                        list_YearlyDay.value = info[6];
		                    }
		            }
		        }
		    }
		
		    function cancel_click() {
		        if (ReturnFunction != null)
		            ReturnFunction("cancel");
		        window.close();
		    }
		
		    function ok_click() {
		
		        var rtn = new Array();
		        rtn["SDATE"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        rtn["EDATE"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		
		        var repetition = "";
		
		        var startdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
		        var enddate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
		
		        if (startdate > enddate) {
		            alert("<spring:message code='ezTask.t22' />");
		            return;
		        }
		
		        if (range1.checked == true)
		            repetition = "-1";
		        else if (range2.checked == true) {
		            if (list_ReCount.value == parseInt(list_ReCount.value) && parseInt(list_ReCount.value) > 0)
		                repetition = parseInt(list_ReCount.value);
		            else {
		                alert("<spring:message code='ezTask.t23' />");
		                list_ReCount.focus();
		                return;
		            }
		        }
		        else
		            repetition = "0";
		
		        if (alldaycheck.checked == true)
		            repetition += "|1";
		        else
		            repetition += "|0";
		
		        if (mpDaily.checked == true) {
		            repetition += "|0";
		
		            if (id0D2.checked == true)
		                repetition += "|0";
		            else {
		                if (txt_De.value == parseInt(txt_De.value) && parseInt(txt_De.value) > 0)
		                    repetition += "|" + parseInt(txt_De.value);
		                else {
		                    alert("<spring:message code='ezTask.t24' />");
		                    txt_De.focus();
		                    return;
		                }
		            }
		        }
		        else if (mpWeekly.checked == true) {
		            repetition += "|1";
		
		            if (txt_We.value == parseInt(txt_We.value) && parseInt(txt_We.value) > 0)
		                repetition += "|" + parseInt(txt_We.value);
		            else {
		                alert("<spring:message code='ezTask.t25' />");
		                txt_We.focus();
		                return;
		            }
		
		            var days = "";
		            var checks = daytable.getElementsByTagName("input");
		            for (var i = 0; i < checks.length; i++)
		                if (checks.item(i).checked == true)
		                    days += checks.item(i).value;
		
		            if (days == "") {
		                alert("<spring:message code='ezTask.t26' />");
		                return;
		            }
		
		            repetition += "|" + days
		        }
		        else if (mpMonthly.checked == true) {
		            repetition += "|2";
		
		            if (idOM1.checked == true) {
		                repetition += "|1";
		
		                if (list_MonthInterval.value == parseInt(list_MonthInterval.value) && parseInt(list_MonthInterval.value) > 0)
		                    repetition += "|" + parseInt(list_MonthInterval.value);
		                else {
		                    alert("<spring:message code='ezTask.t27' />");
		                    list_MonthInterval.focus();
		                    return;
		                }
		
		                if (list_MonthlyDays.value == parseInt(list_MonthlyDays.value) && parseInt(list_MonthlyDays.value) > 0 &&
		                    parseInt(list_MonthlyDays.value) < 32)
		                    repetition += "|" + parseInt(list_MonthlyDays.value);
		                else {
		                    alert("<spring:message code='ezTask.t28' />");
		                    list_MonthlyDays.focus();
		                    return;
		                }
		            }
		            else {
		                repetition += "|2";
		
		                if (list_MonthInterval2.value == parseInt(list_MonthInterval2.value) && parseInt(list_MonthInterval2.value) > 0)
		                    repetition += "|" + parseInt(list_MonthInterval2.value);
		                else {
		                    alert("<spring:message code='ezTask.t27' />");
		                    list_MonthInterval2.focus();
		                    return;
		                }
		
		                repetition += "|" + list_MonthlyEach.value;
		                repetition += "|" + list_MonthlyDay.value;
		            }
		        }
		        else {
		            repetition += "|3";
		
		            if (optY1.checked == true) {
		                repetition += "|1";
		                repetition += "|" + list_Month.value;
		
		                var enddate0;
		                var errorMeg;
		
		                if (list_Month.value == "2") {
		                    enddate0 = "30";
		                    errorMeg = "<spring:message code='ezTask.t237' />"
		
		                }
		                else if (list_Month.value == "4" || list_Month.value == "6" || list_Month.value == "9" || list_Month.value == "11") {
		                    enddate0 = "31";
		                    errorMeg = "<spring:message code='ezTask.t238' />"
		                }
		                else {
		                    enddate0 = "32";
		                    errorMeg = "<spring:message code='ezTask.t28' />"
		                }
		
		
		
		                if (list_YearlyDays.value == parseInt(list_YearlyDays.value) && parseInt(list_YearlyDays.value) > 0 &&
		                    parseInt(list_YearlyDays.value) < enddate0)
		                    repetition += "|" + parseInt(list_YearlyDays.value);
		                else {
		
		                    alert(errorMeg);
		                    list_YearlyDays.focus();
		                    return;
		                }
		
		
		
		                if (moonday.checked == true)
		                    repetition += "|2";
		                else
		                    repetition += "|1";
		            }
		            else {
		                repetition += "|2";
		                repetition += "|" + list_Month2.value;
		                repetition += "|" + list_YearlyEach.value;
		                repetition += "|" + list_YearlyDay.value;
		            }
		        }
		
		        rtn["REPETITION"] = repetition;
alert(repetition);
		        if (ReturnFunction != null)
		            ReturnFunction(rtn);
		        else
		            window.returnValue = rtn;
		        window.close();
		    }
					
		    function remove_click() {
		        var rtn = new Array();
		        rtn["SDATE"] = "";
		        rtn["EDATE"] = "";
		        rtn["REPETITION"] = "";
		
		        if (ReturnFunction != null)
		            ReturnFunction(rtn);
		        else
		            window.returnValue = rtn;
		        window.close();
		    }
		    function showMainPattern(idx) {
		        for (var x = 0; x < 4; x++) {
		            document.getElementById('divRecurPatterns' + x).style.display = "none";
		        }
		        document.getElementById('divRecurPatterns' + idx).style.display = "";
		    }
		    document.onkeydown = function (evt) {
		        var e = evt;
		        if (e == null) e = window.event;
		        if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
		            if ((e.keyCode > 47) && (e.keyCode < 58))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode > 95) && (e.keyCode < 106))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode > 64) && (e.keyCode < 91))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode == 106) ||
		                (e.keyCode == 107) ||
		                (e.keyCode == 109) ||
		                (e.keyCode == 110) ||
		                (e.keyCode == 111) ||
		                (e.keyCode == 186) ||
		                (e.keyCode == 187) ||
		                (e.keyCode == 188) ||
		                (e.keyCode == 189) ||
		                (e.keyCode == 190) ||
		                (e.keyCode == 191) ||
		                (e.keyCode == 192) ||
		                (e.keyCode == 219) ||
		                (e.keyCode == 220) ||
		                (e.keyCode == 221) ||
		                (e.keyCode == 222))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode == 229))
		            {
		                e.returnValue = false;
		            }
		        }
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
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		    });
		    if(lang == "1"){
			    $(function () {
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
			    });
		    } else {
			    $(function () {
			        $.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['en']);
			    });
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezTask.t21' /></h1>
		<div id="TB_Promise" style="display:none">
			<h2><spring:message code='ezTask.t29' /></h2>
			<table class="content">
				<tr>
					<th><spring:message code='ezTask.t30' /><u>T</u>)</th>
					<td><input readonly ="true" type="text" id='_T1' class="textarea">
					<label FOR="btnT1" ACCESSKEY="T"> <img id='btnT1' popupLocation='bottomleft' src="/images/i_scheduler.gif" width="19" height="15" style="cursor:pointer"> </label>
					<input type="checkbox" value="1" id="alldaycheck" checked>
					<spring:message code='ezTask.t31' /></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t32' /><u>N</u>)</th>
					<td><input readonly ="true" id='_T2' type="text" class="textarea" style="width:100px">
					<label FOR="btnT2" ACCESSKEY="N"> <img id='btnT2' popupLocation='bottomleft' src="/images/i_scheduler.gif" width="19" height="15" style="cursor:pointer"> </label></td>
				</tr>
			</table>
		</div>
		<h2><spring:message code='ezTask.t33' /></h2>
		<table class="popuplist" style="width:100%">
			<tr>
				<td>
					<input id="mpDaily" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" onClick='showMainPattern(0);'>
					<label for="mpDaily" style="vertical-align:middle;" accesskey="D"><spring:message code='ezTask.t34' /><u>D</u>)</label>
					<input id="mpWeekly" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked onClick='showMainPattern(1);'>
					<label for="mpWeekly" style="vertical-align:middle;" accesskey="W"><spring:message code='ezTask.t35' /><u>W</u>)</label>
					<input id="mpMonthly" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" onClick='showMainPattern(2);'>
					<label for="mpMonthly" style="vertical-align:middle;" accesskey="M"><spring:message code='ezTask.t36' /><u>M</u>)</label>
					<input id="mpYearly" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" onClick='showMainPattern(3);'>
					<label for="mpYearly" style="vertical-align:middle;" accesskey="Y"><spring:message code='ezTask.t37' /><u>Y</u>)</label>
				</td>
			</tr>
			<tr>
				<td style="height:90px; padding:10px">
					<div id='divRecurPatterns0' style="display:none;">
						<input id="id0D1" type="radio" name="optDaily" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked>
						<label for="txt_De" accesskey="V" style="vertical-align:middle;"><spring:message code='ezTask.t38' /><u>V</u>)&nbsp;
						<input name="text" type="text" id="txt_De" style="Width:40px;" onFocus='window.document.all["optDaily"][0].checked=true;' value="1" maxlength='3'>
						&nbsp;<spring:message code='ezTask.t39' /></label>
						<br>
						<input id="id0D2" type="radio" name="optDaily" style="margin:0px 0px 0px 0px;vertical-align:middle;">
						<label for="id0D2" accesskey="K" style="vertical-align:middle;"><spring:message code='ezTask.t40' /><u>K</u>)</label>
					</div>
					<div id='divRecurPatterns1'><spring:message code='ezTask.t41' />
						<label for="txt_We" accesskey="C">
						<input id="txt_We" type="text" name="textfield222" class="textarea" style="width:50px" value="1">
						<spring:message code='ezTask.t42' /></label>
						<table id="daytable">
							<tr>
								<td><input type="checkbox" name="day" value="0" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t43' /></span></td>
								<td><input type="checkbox" name="day" value="1" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t44' /></span></td>
								<td><input type="checkbox" name="day" value="2" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t45' /></span></td>
								<td><input type="checkbox" name="day" value="3" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t46' /></span></td>
							</tr>
							<tr>
								<td><input type="checkbox" name="day" value="4" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t47' /></span></td>
								<td><input type="checkbox" name="day" value="5" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t48' /></span></td>
								<td><input type="checkbox" name="day" value="6" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t49' /></span></td>
								<td>&nbsp;</td>
							</tr>
						</table>
					</div>
					<div  id='divRecurPatterns2' style="display:none">
						<input type="radio" name='optMonthly' id="idOM1" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked>
						<label for="idOM1" accesskey="A" style="vertical-align:middle"><spring:message code='ezTask.t50' /><u>A</u>)&nbsp;</label>
						<input name="Input" id="list_MonthInterval" style="Width:40px;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="1" maxlength="3">
						&nbsp;<spring:message code='ezTask.t51' />
						<input name="Input" id="list_MonthlyDays" style="Width:40px;" onFocus='window.document.all["optMonthly"][0].checked=true;' maxlength="2">
						&nbsp;<spring:message code='ezTask.t52' /><br>
						<input id="id0M2" type="radio" name='optMonthly' style="margin:0px 0px 0px 0px;vertical-align:middle;">
						<label for="id0M2" accesskey="E" style="vertical-align:middle"><spring:message code='ezTask.t53' /><u>E</u>)&nbsp;</label>
						<input name="Input" id="list_MonthInterval2" style="Width:40px;" onFocus='window.document.all["optMonthly"][1].checked=true;' value="1" maxlength="3">
						&nbsp;<spring:message code='ezTask.t51' />
						<select name="select" id="list_MonthlyEach" onFocus='window.document.all["optMonthly"][1].checked=true;'>
							<option value="1"><spring:message code='ezTask.t54' /></option>
							<option value="2"><spring:message code='ezTask.t55' /></option>
							<option value="3"><spring:message code='ezTask.t56' /></option>
							<option value="4"><spring:message code='ezTask.t57' /></option>
							<option value="5"><spring:message code='ezTask.t58' /></option>
						</select>
						<select name="select" id="list_MonthlyDay" onFocus='window.document.all["optMonthly"][1].checked=true;'>
							<option value="0"><spring:message code='ezTask.t43' /></option>
							<option value="1"><spring:message code='ezTask.t44' /></option>
							<option value="2"><spring:message code='ezTask.t45' /></option>
							<option value="3"><spring:message code='ezTask.t46' /></option>
							<option value="4"><spring:message code='ezTask.t47' /></option>
							<option value="5"><spring:message code='ezTask.t48' /></option>
							<option value="6"><spring:message code='ezTask.t49' /></option>
						</select>
						&nbsp;<spring:message code='ezTask.t60' />
					</div>
					<div id='divRecurPatterns3' style="display:none"><input id="optY1" type="radio" name="optYearly" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked>
						<label for="optY1" accesskey="A" style="vertical-align:middle"><spring:message code='ezTask.t50' /><u>A</u>)&nbsp;</label>
						<select name="select" id="list_Month" onFocus='window.document.all["optYearly"][0].checked=true;'>
							<option value="1"><spring:message code='ezTask.t225' /></option>
							<option value="2"><spring:message code='ezTask.t226' /></option>
							<option value="3"><spring:message code='ezTask.t227' /></option>
							<option value="4"><spring:message code='ezTask.t228' /></option>
							<option value="5"><spring:message code='ezTask.t229' /></option>
							<option value="6"><spring:message code='ezTask.t230' /></option>
							<option value="7"><spring:message code='ezTask.t231' /></option>
							<option value="8"><spring:message code='ezTask.t232' /></option>
							<option value="9"><spring:message code='ezTask.t233' /></option>
							<option value="10"><spring:message code='ezTask.t234' /></option>
							<option value="11"><spring:message code='ezTask.t235' /></option>
							<option value="12"><spring:message code='ezTask.t236' /></option>
						</select>
						<input name="Input" class="text" id="list_YearlyDays" style="Width:40px;" onFocus='window.document.all["optYearly"][0].checked=true;' maxlength="2">
						&nbsp;<spring:message code='ezTask.t62' />
						<c:if test="${userinfo.lang == 3}" >
							<input type="checkbox" value="1" id="moonday" style="margin:0px 0px 2px 0px;vertical-align:middle;">
						</c:if>
						<c:if test="${userinfo.lang != 3}" >
							<input type="checkbox" value="1" id="moonday" style="margin:0px 0px 2px 0px;vertical-align:middle;display:none;">
						</c:if>
						<spring:message code='ezTask.t63' /><br>
						<input id="optY2" type="radio" name="optYearly" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;">          
						<label for="optY2" accesskey="E" style="vertical-align:middle"><spring:message code='ezTask.t53' /><u>E</u>)&nbsp;</label>
						<select name="select" id="list_Month2" onFocus='window.document.all["optYearly"][1].checked=true;'>
							<option value="1"><spring:message code='ezTask.t225' /></option>
							<option value="2"><spring:message code='ezTask.t226' /></option>
							<option value="3"><spring:message code='ezTask.t227' /></option>
							<option value="4"><spring:message code='ezTask.t228' /></option>
							<option value="5"><spring:message code='ezTask.t229' /></option>
							<option value="6"><spring:message code='ezTask.t230' /></option>
							<option value="7"><spring:message code='ezTask.t231' /></option>
							<option value="8"><spring:message code='ezTask.t232' /></option>
							<option value="9"><spring:message code='ezTask.t233' /></option>
							<option value="10"><spring:message code='ezTask.t234' /></option>
							<option value="11"><spring:message code='ezTask.t235' /></option>
							<option value="12"><spring:message code='ezTask.t236' /></option>
						</select>
						<select name="select" id="list_YearlyEach" onFocus='window.document.all["optYearly"][1].checked=true;'>
							<option value="1"><spring:message code='ezTask.t54' /></option>
							<option value="2"><spring:message code='ezTask.t55' /></option>
							<option value="3"><spring:message code='ezTask.t56' /></option>
							<option value="4"><spring:message code='ezTask.t57' /></option>
							<option value="5"><spring:message code='ezTask.t58' /></option>
						</select>
						<select name="select" id="list_YearlyDay" onFocus='window.document.all["optYearly"][1].checked=true;'>
							<option value="0"><spring:message code='ezTask.t43' /></option>
							<option value="1"><spring:message code='ezTask.t44' /></option>
							<option value="2"><spring:message code='ezTask.t45' /></option>
							<option value="3"><spring:message code='ezTask.t46' /></option>
							<option value="4"><spring:message code='ezTask.t47' /></option>
							<option value="5"><spring:message code='ezTask.t48' /></option>
							<option value="6"><spring:message code='ezTask.t49' /></option>
						</select>
						&nbsp;<spring:message code='ezTask.t60' />
					</div>
				</td>
			</tr>
		</table><br>
		<h2><spring:message code='ezTask.t64' /></h2>
		<table class="content">
			<tr>
				<th style="vertical-align:top"><spring:message code='ezTask.t65' /></th>
				<td>
					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
					<br>
					<input type="radio" name="optRangeEnd" id="range1" value="-1" checked style="vertical-align:middle;margin-top:0px"><span style="vertical-align:middle"><spring:message code='ezTask.t73' /></span><br>
					<input type="radio" id="range2" name="optRangeEnd" value="1" style="vertical-align:middle;margin-top:0px"><span style="vertical-align:middle"><spring:message code='ezTask.t74' /></span>
					<input id="list_ReCount" maxlength="3" onFocus="range2.checked = true" size="4" value='10'>
					<span style="vertical-align:middle"><spring:message code='ezTask.t75' /></span><br>
					<input id="range3" type="radio" name="optRangeEnd" value="0" style="vertical-align:middle;margin-top:0px"><span style="vertical-align:middle"><spring:message code='ezTask.t76' /></span>
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
				</td>
			</tr>
		</table>
		<div class="btnposition">
			<a class="imgbtn" onClick="remove_click()" ><span><spring:message code='ezTask.t77' /></span></a>
			<a class="imgbtn" onClick="ok_click()" ><span><spring:message code='ezTask.t19' /></span></a>
			<a class="imgbtn" onClick="cancel_click()" ><span><spring:message code='ezTask.t20' /></span></a>
		</div>
	</body>
</html>