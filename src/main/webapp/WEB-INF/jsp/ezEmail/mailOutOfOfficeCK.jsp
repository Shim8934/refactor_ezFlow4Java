<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title>mail_outofoffice</title>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls_cross/composeappt.js"></script>
	    <!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
	    <!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
	    <script type="text/javascript">
		    var g_oofstate = "${gOofState}";
		    var g_startdate = "${gStartDate}";
		    var g_enddate = "${gEndDate}";
		    var g_externalaudience = "${gExternalAudience}";
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
		        var NowDate = new Date();
		        NowDate.setHours(NowDate.getHours() + 1);
		        var NowDate2 = new Date();
		        NowDate2.setHours(NowDate2.getHours() + 1);
		        //NowDate2.setMinutes(NowDate2.getMinutes() + 30);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate2);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		        $('#Etimepicker').timepicker();
		        $('#Etimepicker').timepicker('setTime', NowDate2);
		        $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
		    });
		    
		    <c:choose> 
				<c:when test="${userLang == '1'}">
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
				</c:when>
				<c:when test="${userLang == '3'}">
					$(function () {
				    	$.datepicker.regional['ja'] = {
				    		closeText: '閉じる',
				    		prevText: '<前',
			    	        nextText: '次>',
			    	        currentText: '今日',
			    	        monthNames: ['1月','2月','3月','4月','5月','6月',
			    	        '7月','8月','9月','10月','11月','12月'],
			    	        monthNamesShort: ['1月','2月','3月','4月','5月','6月',
			    	        '7月','8月','9月','10月','11月','12月'],
			    	        dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
			    	        dayNamesShort: ['日','月','火','水','木','金','土'],
			    	        dayNamesMin: ['日','月','火','水','木','金','土'],
			    	        weekHeader: '週',
			    	        dateFormat: 'yy-mm-dd',
			    	        firstDay: 0,
			    	        isRTL: false,
			    	        duration: 200,
				            showAnim: 'show',
			    	        showMonthAfterYear: true
				    	};
			    		$.datepicker.setDefaults($.datepicker.regional['ja']);
			    	});
				</c:when>
				<c:otherwise>
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
				</c:otherwise>
			</c:choose>
		    
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
		
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        try {
		            if (g_externalaudience == "none") {
		                chkOut.checked = false;
		                document.getElementById("SetOut0").checked = true;
		            }
		            else if (g_externalaudience == "known") {
		                chkOut.checked = true;
		                document.getElementById("SetOut0").checked = true;
		            }
		            else {
		                chkOut.checked = true;
		                document.getElementById("SetOut1").defaultChecked = true;
		            }
		            try{
		                var StarDate = new Date(g_startdate.replace(/-/gi, "/"));
		                var EndDate = new Date(g_enddate.replace(/-/gi, "/"));
		                $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		                $("#Sdatepicker").datepicker('setDate', StarDate);
		                $('#Stimepicker').timepicker('setTime', StarDate);
		                $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		                $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		                $("#Edatepicker").datepicker('setDate', EndDate);
		                $('#Etimepicker').timepicker('setTime', EndDate);
		                $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
		            } catch (e) { }
		          
		            if (g_oofstate == "disabled") {
		                document.getElementById("SetRadio0").defaultChecked = true;
		                document.getElementById("chkDate").defaultChecked = false;
		                SetToggle("0");
		            }
		            else if (g_oofstate == "scheduled") {
		                document.getElementById("SetRadio1").defaultChecked = true;
		                document.getElementById("chkDate").defaultChecked = true;
		                SetToggle("1");
		            }
		            else {
		                document.getElementById("SetRadio1").defaultChecked = true;
		                document.getElementById("chkDate").defaultChecked = false;
		
		                SetToggle("1");
		            }
		            //tbContentElement1.SetEditorContent("<span>" + document.getElementById("BujaeBody1").innerHTML + "</span>");
		            //tbContentElement2.SetEditorContent("<span>" + document.getElementById("BujaeBody2").innerHTML + "</span>");
		                        
		        }
		        catch (e) {
		            alert(e.message);
		        }
		    }
	        function Editor_Complete(){
		        DocumentComplete();
		    }
		    function DocumentComplete() {
		        try {
		            tbContentElement1.SetEditorContent(document.getElementById("BujaeBody1").innerHTML);
		        } catch (e) { }
		        
		        try {
		            tbContentElement2.SetEditorContent(document.getElementById("BujaeBody2").innerHTML);
		        } catch (e) { }
		        try {document.body.scrollTop = 0;} catch (e) {}
		        
		        
		    }
		    function SetToggle(param) {
		        document.getElementById("Stimepicker").disabled = true;
		        $("#Sdatepicker").datepicker('disable');
		        document.getElementById("Etimepicker").disabled = true;
		        $("#Edatepicker").datepicker('disable');
		        if (param == "0") {
		            chkDate.disabled = true;
		            chkOut.disabled = true;
		            document.getElementById("SetOut0").disabled = true;
		            document.getElementById("SetOut1").disabled = true;
		            document.getElementById("SetRadio1").checked = false;
		        }
		        else {
		
		            chkDate.disabled = false;
		            CheckDate();
		            chkOut.disabled = false;
		            CheckOut();
		            document.getElementById("SetRadio0").checked = false;
		        }
		    }
		    function CheckDate() {
		        if (document.getElementById("chkDate").checked) {
		            document.getElementById("Stimepicker").disabled = false;
		            $("#Sdatepicker").datepicker('enable');
		            document.getElementById("Etimepicker").disabled = false;
		            $("#Edatepicker").datepicker('enable');
		        }
		        else {
		            document.getElementById("Stimepicker").disabled = true;
		            $("#Sdatepicker").datepicker('disable');
		            document.getElementById("Etimepicker").disabled = true;
		            $("#Edatepicker").datepicker('disable');
		        }
		    }
		
		    function CheckOut(pObj) {
		        if (document.getElementById("chkOut").checked) {
		            document.getElementById("SetOut0").disabled = false;
		            document.getElementById("SetOut1").disabled = false;
		        }
		        else {
		            document.getElementById("SetOut0").disabled = true;
		            document.getElementById("SetOut1").disabled = true;
		
		        }
		    }
		    function BujaeTextFontCheck(BujaeText) {
		        var Div = document.createElement("DIV");
		        Div.innerHTML = BujaeText;
		    }
		    function Save() {
		        var pstartdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		        var penddate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		
		        var dateStart = new Date(pstartdate.substring(0, 4), (pstartdate.substring(5, 7) - 1), pstartdate.substring(8, 10), pstartdate.substring(11, 13), pstartdate.substring(14, 16), 0, 0);
		        var dateEnd = new Date(penddate.substring(0, 4), (penddate.substring(5, 7) - 1), penddate.substring(8, 10), penddate.substring(11, 13), penddate.substring(14, 16), 0, 0);
		        var now = new Date();
		
		        var poofstate = "disabled";
		        if (document.getElementById("SetRadio0").checked == true)
		            poofstate = "disabled";
		        else if (document.getElementById("SetRadio1").checked == true && chkDate.checked == true)
		            poofstate = "scheduled";
		        else if (document.getElementById("SetRadio1").checked == true && chkDate.checked == false)
		            poofstate = "enabled";
				
		        if (poofstate == "scheduled") {
		        	if (dateStart > dateEnd || dateStart < now) {
			            alert("<spring:message code='ezEmail.t99000036' />");
			            return;
			        }
			        else if (dateStart > dateEnd || dateEnd < now) {
			            alert("<spring:message code='ezEmail.t99000037' />");
			            return;
			        }
		        }
		        
		        var pexternalaudience = "none";
		        if (chkOut.checked == false)
		            pexternalaudience = "none"
		        else if (chkOut.checked == true && document.getElementById("SetOut0").checked == true)
		            pexternalaudience = "known"
		        else if (chkOut.checked == true && document.getElementById("SetOut1").checked == true)
		            pexternalaudience = "all"
		
		        var BujaeText1 = tbContentElement1.GetEditorContent();
		        var BujaeText2 = tbContentElement2.GetEditorContent();
		        BujaeTextFontCheck(BujaeText1);
		
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "OOFSTATE", poofstate);
		        createNodeAndInsertText(xmlDom, objNode, "STARTDATE", pstartdate);
		        createNodeAndInsertText(xmlDom, objNode, "ENDDATE", penddate);
		        createNodeAndInsertText(xmlDom, objNode, "INTERNAL", BujaeText1);
		        createNodeAndInsertText(xmlDom, objNode, "EXTERNAL", BujaeText2);
		        createNodeAndInsertText(xmlDom, objNode, "EXTERNALAUDIENCE", pexternalaudience);
		
		
		        xmlHTTP.open("POST", "/ezEmail/mailOutOfOfficeSave.do", false);
		        xmlHTTP.send(xmlDom);
		
		        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		            alert("<spring:message code='ezEmail.t201' />");
		        else
		            alert("<spring:message code='ezEmail.t202' />");
		
		        xmlHTTP = null;
		        xmlDom = null;
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;">	
	<br>
	<span class="txt"><spring:message code='ezEmail.t204' /><br>
	<spring:message code='ezEmail.t205' /></span>
	<table style="width:720px;margin-top:5px;" class="box">
	  <tr>
	    <td style="padding:5px">
	       <input name="SetRadio0" type="radio" onclick="SetToggle('0')" id = "SetRadio0">
	      <spring:message code='ezEmail.t206' /><br>
	       <input name="SetRadio1" type="radio" onclick="SetToggle('1')" id = "SetRadio1">
	      <spring:message code='ezEmail.t207' /><br>
	       <input type="checkbox" name="chkDate" value="checkbox" onclick="CheckDate()" id = "chkDate">
	      <spring:message code='ezEmail.t208' /></td>
	  </tr>
	</table>
	<table class="content" style="width:720px;margin-top:5px;">
	  <tr>
	    <th><spring:message code='ezEmail.t209' /></th>
	    <td>
	        <input type="text" id="Sdatepicker" style="width:80px;text-align:center"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	     </td>
	  </tr>
	  <tr>
	    <th><spring:message code='ezEmail.t217' /></th>
	    <td>
	        <input type="text" id="Edatepicker" style="width:80px;text-align:center"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	    </td>
	  </tr>
	</table>
	<div class="nobox" style="width:720px; height:380px;margin-top:5px;">
	<iframe id="tbContentElement1" class="viewbox" src="/ezEmail/mailCKEditor.do" name="tbContentElement1" style="padding:0; height:380px; width:100%; overflow:auto;border:1px solid gray;"></iframe>
	</div>
	<table style="width:720px;" class="box">
	  <tr>
	    <td style="padding:5px"><input type="checkbox" name="chkOut" onclick="CheckOut()" id="chkOut">
	      <spring:message code='ezEmail.t218' /><br>
	      <input name="SetOut" type="radio" id="SetOut0">
	      <spring:message code='ezEmail.t219' /><br>
	      <input name="SetOut" type="radio" id="SetOut1">
	      <spring:message code='ezEmail.t220' /></td>
	  </tr>
	</table>
	<div class="nobox" style="width:720px; height:380px;margin-top:5px;">
	<iframe id="tbContentElement2" class="viewbox" src="/ezEmail/mailCKEditor.do" name="tbContentElement2" style="padding:0; height:380px; width:100%; overflow:auto;border:1px solid gray;"></iframe>
	</div> 
	<div style="width:700px;text-align:center;margin-top:10px">
	    <a class="imgbtn" onClick="Save()"><span><spring:message code='ezEmail.t48' /></span></a>
	    <a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
	</div>
	<XMP id="BujaeBody1" style="DISPLAY: none">${gInternal}</XMP> 
	<XMP id="BujaeBody2" style="DISPLAY: none">${gExternal}</XMP> 
	</body>
</html>



