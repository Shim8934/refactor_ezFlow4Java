<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<article class="resources_portlet box_shadow">
    <div class="layDIV">
        <dl class="portlet_title">
            <dt class="portletText"><spring:message code="main.t00034"/></dt>
            <dd class="portletPlus" id="resourcePlus"><img src="/images/ezNewPortal/portlet_Plus<c:out value='${usedTheme }'/>.png"></dd>
            <dd class="resources_setting" id="resourceSetting"><img src="/images/ezNewPortal/resources_setting.png"></dd>
            <dd class="resources_calendal">
                <input type="text" class="DatePicker_class"  name="Datepicker_name" id="Sdatepicker"  size="10" readonly="readonly">
            </dd>
        </dl>
        <div class="resource_listBox">
        	<ul class="resource_listBoxUL" id="Resource_Portlet_List">

        	</ul>
    	</div>
    </div>        
</article>



		<input id='_T1' class='datepicker_time' readonly style="display:none">
		<IMG align="absmiddle" border="0" height="16" id="img_StartTime" src="/images/arr_right.gif" style="CURSOR: hand; POSITION: relative; display:none;" width="16">


<link rel="stylesheet" href="${util.addVer('ezResource.e2', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script>
	var dSun = "<spring:message code='main.t0621' />";
	var dMon = "<spring:message code='main.t0622' />";
	var dTue = "<spring:message code='main.t0623' />";
	var dWed = "<spring:message code='main.t0624' />";
	var dThu = "<spring:message code='main.t0625' />";
	var dFri = "<spring:message code='main.t0626' />";
	var dSat = "<spring:message code='main.t0627' />";
	
	$("#Sdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ezNewPortal/calIcon.png",
		buttonImageOnly: true
	});
	
	
	var SDate = new Date();
	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#Sdatepicker").datepicker('setDate', SDate);

	$.datepicker.regional[strLang602] = {
		closeText: strLang601,
		prevText: strLang599,
		nextText: strLang600,
		currentText: strLang598,
		monthNames: [strLang586, strLang587, strLang588, strLang589, strLang590, strLang591, strLang592, strLang593, strLang594, strLang595, strLang596, strLang597],
		monthNamesShort: [strLang586, strLang587, strLang588, strLang589, strLang590, strLang591, strLang592, strLang593, strLang594, strLang595, strLang596, strLang597],
		dayNames: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesShort: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesMin: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		weekHeader: "Wk",
		dateFormat: "yy-mm-dd",
		firstDay: 0,
		isRTL: false,
		duration: 200,
		showAnim: "show",
		showMonthAfterYear: true,
		onSelect: function(dateText, inst) {
			var date = $(this).val();
			getPersPortlet();
		}
	};
	$.datepicker.setDefaults($.datepicker.regional[strLang602]);
</script>
</body>
</html>