<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t428'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var lastdate = "<c:out value='${monthEndDay}'/>";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "<c:out value='${userInfo.deptID}'/>";
	        var initdate = "<c:out value='${initDate}'/>";
	        var listType = "<c:out value='${listtype}'/>";
	        var ReturnFunction;	        
	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        window.onload = function () {
	            try{
	                ReturnFunction = opener.ezStatisticsSearch_dialogArguments[1];
	            }
	            catch (e) {
	                try {
	                    ReturnFunction = parent.ezStatisticsSearch_dialogArguments[1];
	                } catch (e) { }
	            }
	            if ("<c:out value='${aprFlag}'/>" == "END") {
	                document.getElementById("ENDDATETR").style.display = "";
	                document.getElementById("DOCNUM").style.display = "";
	            }
	            else {
	                document.getElementById("ENDDATETR").style.display = "NONE";
	                document.getElementById("DOCNUM").style.display = "NONE";
	            }
	
	            if ("<c:out value='${aprFlag}'/>" == "APR2") {
	                document.getElementById("DOCNUM").style.display = "";
	                document.getElementById("KEYWORDTR").style.display = "";
	                document.getElementById("FormN").style.display = "";
	            }
	
	            if (String(listType) == "9")
	                document.getElementById("approvdate").style.display = "none";
	
	            reset_onclick();
	            document.getElementById("Submit3").focus();
				try {
	                var ua = navigator.userAgent;
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    var input = document.getElementsByTagName("input");
	                    for (var i = 0; i < input.length; i++) {
	                        if (GetAttribute(input[i], "type") == "text")
	                            KeEventControl(input[i]);
	                    }
	                }
	            }
	            catch (e){ }
	        }
	        $(function () {
	            $("#Sdatepickerapp").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true
	            });
	            $("#Edatepickerapp").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true
	            });
	            $("#Sdatepickerend").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true
	            });
	            $("#Edatepickerend").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true
	            });
	        });
	        
	        var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
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
		    });
	    		
	        function reset_onclick() {
	            document.getElementById("DocNumber").value = "";
	            document.getElementById("DocTitle").value = "";
	            document.getElementById("drafter").value = "";
	            document.getElementById("FormName").value = "";
	            document.getElementById("keyword").value = "";
	        }
	        function btnSearch_onclick() {
	            var RtnVal = new Array()
	            var chkVal = false;
	            var i;
	            var draftfrom, draftto, apprfrom, apprto;
	
	            draftfrom = $("#Sdatepickerapp").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	            draftto = $("#Edatepickerapp").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	            apprfrom = $("#Sdatepickerend").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	            apprto = $("#Edatepickerend").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	
	            if (DocTitle.value.indexOf("%") != -1 || DocNumber.value.indexOf("%") != -1) {
	                alert("'%'" + "<spring:message code='ezApproval.hyj2'/>");
	                return;
	            } else if (drafter.value.indexOf("%") != -1) {
	                alert("'%'" + "<spring:message code='ezApproval.hyj2'/>");
	                return;
	            } else if (drafterdept.value.indexOf("%") != -1 || keyword.value.indexOf("%") != -1) {
	                alert("'%'" + "<spring:message code='ezApproval.hyj2'/>");
	                return;
	            }
	
	            if (draftfrom != "" && draftto != "") {
	                if (new Date(draftfrom) > new Date(draftto)) {
	                    alert("<spring:message code='ezApproval.t429'/>");
	                    return;
	                }
	            }
	
	            if (apprfrom != "" && apprto != "") {
	                if (new Date(apprfrom) > new Date(apprto)) {
	                    alert("<spring:message code='ezApproval.t431'/>");
		                return;
		            }
		        }
		        if (draftfrom != "")
		            draftfrom = draftfrom + " 00:00:01";
		
		        if (draftto != "")
		            draftto = draftto + " 23:59:59";
		
		        if (apprfrom != "")
		            apprfrom = apprfrom + " 00:00:01";
		
		        if (apprto != "")
		            apprto = apprto + " 23:59:59";
		        
		        RtnVal[0] = DocNumber.value;
		        RtnVal[1] = DocTitle.value;
		        RtnVal[2] = drafter.value;
		        RtnVal[3] = draftfrom;
		        RtnVal[4] = draftto;
		        RtnVal[5] = apprfrom;
		        RtnVal[6] = apprto;
		
		        if (GetAttribute(document.getElementById("FormName"), "pId") == "FormName")
		            RtnVal[7] = "";
		        else
		            RtnVal[7] = GetAttribute(document.getElementById("FormName"), "pId");
		
		        RtnVal[8] = approvUser.value;
		        RtnVal[9] = drafterdept.value;
		
		        RtnVal[10] = "";
		        if (document.getElementById("keyword").value != "") {
		            RtnVal[10] = document.getElementById("keyword").value;
		        } else {
		            RtnVal[10] = "";
		        }
		
		        if (document.getElementById("tbItemCode").value != "") {
		            if (RtnVal[10] != "")
		                RtnVal[10] = RtnVal[10] + " and ";
		
		            RtnVal[10] = RtnVal[10] + " itemcode = '" + document.getElementById("tbItemCode").value + "' ";
		        }
		    
		        /* for (i = 0; i < 12; i++) {
		            if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
		                chkVal = true;
		                break;
		            }
		        } */
		
		      	//RtnVal = SearchDateXML(RtnVal);
		
		        /* if (!chkVal) {
		            RtnVal = "";
		            OpenAlertUI("<spring:message code='ezApproval.t432'/>");
		        } else { */
		            if (ReturnFunction != null) {
		                ReturnFunction(RtnVal);
		            } else {
		                window.returnValue = RtnVal;
		            }
		            window.close();
		        /* } */
		    }
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "/admin/ezApproval/ezAprAlert.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(330, 205);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		
		    function btncancel_onclick() {
		        window.close();
		    }
		
		    var getformcont_cross_dialogArguments = new Array();
		    /* function btn_FormSelect_onclick() {
		        var parameter = new Array();
	alert(arr_userinfo[0])	        
		        parameter[0] = arr_userinfo[0];
		        parameter[1] = "000";
		
		        var url = "/ezApprovalG/getFormCont.do";
		
		        if (CrossYN() || pNoneActiveX == "YES") {            
		            getFormCont_dialogArguments[0] = parameter;
		            getFormCont_dialogArguments[1] = FormSelect_Complete;
		            var result = GetOpenWindow(url, "", 713, 570, "NO");
		        } else {
		            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no"
		            var retVal = window.showModalDialog(url, parameter, feature);
		            
		            if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
		                document.getElementById("FormName").value = retVal[3];
		                document.getElementById("FormName").setAttribute("pId", retVal[2]);
		            }
		        }
		    } */
		    
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		    
		        parameter[0] = arr_userinfo[0];
		        parameter[1] = "000";
	
		        var url = "/ezApprovalG/getFormCont.do";
		        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		        feature = feature + GetShowModalPosition(713, 570);
	
		        getformcont_cross_dialogArguments[0] = parameter;
		        getformcont_cross_dialogArguments[1] = FormSelect_Complete;
	
		        getformcont_Cross_OpenWin = window.open(url, "getformcont_Cross", GetOpenWindowfeature(713, 570));
		        
		        try { getformcont_Cross_OpenWin.focus(); } catch (e) { }
		    }
		
		    function getPositionOpenWin(popUpW, popUpH) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = 0;
		        var top = 0;
		        var pleftpos;
		        pleftpos = parseInt(width) - popUpW;
		        heigth = parseInt(heigth) - popUpH;
		        width = parseInt(width) - pleftpos;
		        left = pleftpos / 2;
		        top = heigth / 2;
		
		        var Positon = new Array(left, top);
		
		        return Positon;
		    }
		
		    function FormSelect_Complete(RtnVal) {
		        if (typeof (RtnVal) != "undefined" && RtnVal[0] != "cancel" && RtnVal != "") {
		            document.getElementById("FormName").value = RtnVal[3];
		            document.getElementById("FormName").setAttribute("pId", RtnVal[2]);
		        }	
		        DivPopUpHidden();
		    }
		
		    function btnToDaySearch_onclick() {
		        var RtnVal = new Array()
		
		        RtnVal[0] = DocNumber.value;
		        RtnVal[1] = DocTitle.value;
		        RtnVal[2] = drafter.value;
		
		        if ("<c:out value='${aprFlag}'/>" == "END") {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = initdate.substring(0, 10) + " 00:00:01";
		            RtnVal[6] = initdate.substring(0, 10) + " 23:59:59";
		        } else {
		            RtnVal[3] = initdate.substring(0, 10) + " 00:00:01";
		            RtnVal[4] = initdate.substring(0, 10) + " 23:59:59";
		            RtnVal[5] = "";
		            RtnVal[6] = "";
		        }
		
		        if (GetAttribute(document.getElementById("FormName"), "pId") == "FormName")
		            RtnVal[7] = "";
		        else
		            RtnVal[7] = GetAttribute(document.getElementById("FormName"), "pId");
		
		        RtnVal[8] = approvUser.value;
		        RtnVal[9] = drafterdept.value;
		
		        RtnVal[10] = "";
		        if (keyword.value != "") {
		            RtnVal[10] = " keyword like '%" + keyword.value + "%' ";
		        } else {
		            RtnVal[10] = "";
		        }
		
		        if (tbItemCode.value != "") {
		            if (RtnVal[10] != "")
		                RtnVal[10] = RtnVal[10] + " and ";
		
		            RtnVal[10] = RtnVal[10] + " itemcode = '" + tbItemCode.value + "' ";
		        }
		
		        //RtnVal = SearchDateXML(RtnVal);
		
		        if (ReturnFunction != null) {
		            ReturnFunction(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        window.close();
		    }
		    function getWeek() {	
		        var szYear = initdate.substring(0, 4);
		        var szMonth = initdate.substring(5, 7);
		        var szDay = initdate.substring(8, 10);
		        var szHr = initdate.substring(11, 13);
		        var szMin = initdate.substring(14, 16);
		        var szSec = initdate.substring(17, 19);
		
		        var now = new Date(szYear, szMonth - 1, szDay, szHr, szMin, szSec);
		
		        var nowDayOfWeek = now.getDay();
		        var nowDay = now.getDate();
		        var nowMonth = now.getMonth();
		        var nowYear = now.getYear();
		        nowYear += (nowYear < 2000) ? 1900 : 0;
		
		        var RtnVal = new Array();
		        RtnVal[0] = new Date(nowYear, nowMonth, nowDay - nowDayOfWeek);
		        RtnVal[1] = new Date(nowYear, nowMonth, nowDay + (6 - nowDayOfWeek));
		
		        return RtnVal;
		    }
		    function getMonth() {	
		        var szYear = initdate.substring(0, 4);
		        var szMonth = initdate.substring(5, 7);
		        var szDay = initdate.substring(8, 10);
		        var szHr = initdate.substring(11, 13);
		        var szMin = initdate.substring(14, 16);
		        var szSec = initdate.substring(17, 19);
		        var now = new Date(szYear, szMonth - 1, szDay, szHr, szMin, szSec);
		
		        var nowDayOfWeek = now.getDay();
		        var nowDay = now.getDate();
		
		        var nowMonth = now.getMonth();
		
		        var nowYear = now.getYear();
		        nowYear += (nowYear < 2000) ? 1900 : 0;
		
		        var RtnVal = new Array();
		        if (nowMonth <= 0)
		            RtnVal[0] = new Date(nowYear - 1, 11, nowDay);
		        else
		            RtnVal[0] = new Date(nowYear, nowMonth - 1, nowDay);
		
		        RtnVal[1] = new Date(nowYear, nowMonth, nowDay);
		
		        return RtnVal;
		    }
		    function btnMonthSearch_onclick() {
		        var RtnVal = new Array();
		        var CurrentWeek = new Array();
		        CurrentWeek = getMonth();
		
		        var sDay = makeString(2, "0", String(CurrentWeek[0].getDate()));
		        var sMonth = makeString(2, "0", String(CurrentWeek[0].getMonth() + 1));
		        var sYear = CurrentWeek[0].getFullYear();
		
		        var sDay2 = makeString(2, "0", String(CurrentWeek[1].getDate()));
		        var sMonth2 = makeString(2, "0", String(CurrentWeek[1].getMonth() + 1));
		        var sYear2 = CurrentWeek[1].getFullYear();
		        if (sMonth2 == "00") {
		            sMonth2 = "12";
		            sYear2 = String(Number(sYear2 - 1));
		        }
		
		        RtnVal[0] = DocNumber.value;
		        RtnVal[1] = DocTitle.value;
		        RtnVal[2] = drafter.value;
		        if ("<c:out value='${aprFlag}'/>" == "END") {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = sYear + "-" + sMonth + "-" + sDay + " 00:00:01";
		            RtnVal[6] = sYear2 + "-" + sMonth2 + "-" + sDay2 + " 23:59:59";
		        } else {
		            RtnVal[3] = sYear + "-" + sMonth + "-" + sDay + " 00:00:01";
		            RtnVal[4] = sYear2 + "-" + sMonth2 + "-" + sDay2 + " 23:59:59";
		            RtnVal[5] = "";
		            RtnVal[6] = "";	
		        }
		
		        if (GetAttribute(document.getElementById("FormName"), "pId") == "FormName")
		            RtnVal[7] = "";
		        else
		            RtnVal[7] = GetAttribute(document.getElementById("FormName"), "pId");
		
		        RtnVal[8] = approvUser.value;
		        RtnVal[9] = drafterdept.value;
		
		        RtnVal[10] = "";
		        if (keyword.value != "") {
		            RtnVal[10] = " keyword like '%" + keyword.value + "%' ";
		        } else {
		            RtnVal[10] = "";
		        }
		
		        if (tbItemCode.value != "") {
		            if (RtnVal[10] != "")
		                RtnVal[10] = RtnVal[10] + " and ";
		
		            RtnVal[10] = RtnVal[10] + " itemcode = '" + tbItemCode.value + "' ";
		        }
		
		        RtnVal[11] = approvUser.value;
		
		        //RtnVal = SearchDateXML(RtnVal);
		
		        if (ReturnFunction != null) {
		            ReturnFunction(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        window.close();
		    }
		    function makeString(strLen, empCh, custStr) {
		        var index;
		        var szEmpty = "";
		
		        for (index = custStr.length; index < strLen; index++) {
		            szEmpty += empCh;
		        }
		
		        return (szEmpty + custStr);
		    }
		    function btnWeekSearch_onclick() {
		        var RtnVal = new Array();	
		        var CurrentWeek = new Array();
		        CurrentWeek = getWeek();
		
		        var sDay = makeString(2, "0", String(CurrentWeek[0].getDate()));
		        var sMonth = makeString(2, "0", String(CurrentWeek[0].getMonth() + 1));
		        var sYear = CurrentWeek[0].getFullYear();
		
		        var sDay2 = makeString(2, "0", String(CurrentWeek[1].getDate()));
		        var sMonth2 = makeString(2, "0", String(CurrentWeek[1].getMonth() + 1));
		        var sYear2 = CurrentWeek[1].getFullYear();
		        
		        if (sMonth2 == "00") {
		            sMonth2 = "12";
		            sYear2 = String(Number(sYear2 - 1));
		        }
		
		        RtnVal[0] = DocNumber.value;
		        RtnVal[1] = DocTitle.value;
		        RtnVal[2] = drafter.value;
		
		        if ("<c:out value='${aprFlag}'/>" == "END") {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = sYear + "-" + sMonth + "-" + sDay + " 00:00:01";
		            RtnVal[6] = sYear2 + "-" + sMonth2 + "-" + sDay2 + " 23:59:59";
		        } else {
		            RtnVal[3] = sYear + "-" + sMonth + "-" + sDay + " 00:00:01";
		            RtnVal[4] = sYear2 + "-" + sMonth2 + "-" + sDay2 + " 23:59:59";
		            RtnVal[5] = "";
		            RtnVal[6] = "";
		        }
		
		        if (GetAttribute(document.getElementById("FormName"), "pId") == "FormName")
		            RtnVal[7] = "";
		        else
		            RtnVal[7] = GetAttribute(document.getElementById("FormName"), "pId");
		
		        RtnVal[8] = approvUser.value;
		        RtnVal[9] = drafterdept.value;
		
		        RtnVal[10] = "";
		        RtnVal[11] = drafterdept.value;
		
		        RtnVal[12] = "";
		        if (keyword.value != "") {
		            RtnVal[12] = " keyword like '%" + keyword.value + "%' ";
		        } else {
		            RtnVal[12] = "";
		        }
		
		        if (tbItemCode.value != "") {
		            if (RtnVal[12] != "")
		                RtnVal[12] = RtnVal[12] + " and ";
		
		            RtnVal[12] = RtnVal[12] + " itemcode = '" + tbItemCode.value + "' ";
		        }
		
		        //RtnVal = SearchDateXML(RtnVal);
		
		        if (ReturnFunction != null) {
		            ReturnFunction(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        window.close();
		    }
		    function btnItemCode_onclick() {
		        var url = "/myoffice/ezApproval/DocNum/docnumui_Cross.aspx";
		        var feature = "dialogWidth:745px;dialogHeight:370px;status:no;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(745, 370);
		        var retVal = window.showModalDialog(url, "", feature);
		
		        if (retVal[0] != "cancel") {
		            tbItemCode.value = retVal[0];
		            tbItemName.value = retVal[1];
		        }
		    }
		    function SearchDateXML(pArrDate) {
		        try {	
		            var PARAMETER;
		            var DATA;
		            var pDATE;	
		            var xmlpara = createXmlDom();
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");	
		
		            for (i = 3; i <= 6; i++) {
		                createNodeAndInsertText(xmlpara, objNode, "DATA", pArrDate[i]);
		            }
		            
		            xmlhttp.open("Post", "/myoffice/ezApproval/aspx/ConvertDate.aspx", false);
		            xmlhttp.send(xmlpara);	            
		            var XmlNode = loadXMLString(xmlhttp.responseText);
		            
		            if (XmlNode.xml) {
		                var pNode = XmlNode.selectSingleNode("PARAMETER");
		
		                for (i = 0; i <= 3; i++) {
		                    if (getNodeText(pNode.childNodes(i)) != "")
		                        pArrDate[3 + i] = getNodeText(pNode.childNodes(i));
		                }	
		            }
		            return pArrDate;	
		        } catch (e) {
		            alert("SearchDateXML ::" + e.description);
		        }
		    }
	    </script>
	</head>
	<body class="popup" style="overflow: hidden">
	    <h1><spring:message code='ezApproval.t428'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
	    <table class="content">
	        <tr style="display: none">
	            <th><spring:message code='ezApprovalG.t1197'/></th>
	            <td>
	                <input type="text" id="tbItemCode" name="tbItemCode" style="width: 60px" readonly="true" />
	                <input type="text" id="tbItemName" name="tbItemName" style="width: 140px" readonly="true" />
	                <a class="imgbtn" style="vertical-align: middle"><span onclick="return btnItemCode_onclick()"><spring:message code='ezApprovalG.t1197'/></span></a>
				</td>
	        </tr>
	        <tr id="FormN">
	            <th><spring:message code='ezApproval.t433'/></th>
	            <td>
	                <input type="text" id="FormName" name="FormName" style="width: 200px" disabled />
	                <a class="imgbtn" style="vertical-align: middle"><span onclick="return btn_FormSelect_onclick()"><spring:message code='ezApproval.t433'/></span></a>
				</td>
	        </tr>
	        <tr id="DOCNUM">
	            <th><spring:message code='ezApproval.t434'/></th>
	            <td>
	                <input type="text" id="DocNumber" name="DocNumber" style="width: 99%" maxlength="50" />
				</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t435'/></th>
	            <td>
	                <input type="text" id="DocTitle" name="DocTitle" style="width: 99%" maxlength="50" />
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t436'/></th>
	            <td>
	                <input type="text" id="drafter" name="drafter" style="width: 99%" maxlength="50" />
	            </td>
	        </tr>
	        <tr style="display:none">
	            <th><spring:message code='ezApproval.t570'/></th>
	            <td>
	                <input type="text" id="approvUser" name="approvUser" style="width: 99%" maxlength="50" />
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t437'/></th>
	            <td>
	                <input type="text" id="drafterdept" name="drafterdept" style="width: 99%" maxlength="50" />
	            </td>
	        </tr>
	        <tr id="approvdate">
	            <th><spring:message code='ezApproval.t438'/></th>
	            <td>
	                <input type="text" id="Sdatepickerapp" style="width:80px;text-align:center" />
	                <input type="text" id="Edatepickerapp" style="width:80px;text-align:center" />
	            </td>
	        </tr>
	        <tr id="ENDDATETR">
	            <th><spring:message code='ezApproval.t448'/></th>
	            <td>
	                <input type="text" id="Sdatepickerend" style="width:80px;text-align:center" />
	                <input type="text" id="Edatepickerend" style="width:80px;text-align:center" />
	            </td>
	        </tr>
	        <tr id="KEYWORDTR" style="display: none">
	            <th style="white-space: nowrap"><spring:message code='ezApproval.t338'/></th>
	            <td>
	                <input type="text" id="keyword" name="keyword" style="width: 99%" maxlength="50" />
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn" id="Submit3" onclick="return btnSearch_onclick()"><span><spring:message code='ezApproval.t236'/></span></a>
	        <c:if test="${listType != '9'}">
		        <a class="imgbtn" onclick="return btnToDaySearch_onclick()"><span><spring:message code='ezApproval.t449'/></span></a>
		        <a class="imgbtn" onclick="return btnWeekSearch_onclick()"><span><spring:message code='ezApproval.t450'/></span></a>
		        <a class="imgbtn" onclick="return btnMonthSearch_onclick()"><span><spring:message code='ezApproval.t620'/></span></a>
	        </c:if>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
        <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>