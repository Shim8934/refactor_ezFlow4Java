<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
 <title><spring:message code='ezApprovalG.t1774'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/datepicker.htc.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/OpenSelWin_Cross.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ezComposeAppt_Cross.js"></script>
    <!-- data picker-->
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
<!-- time picker-->
<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
    <script id="clientEventHandlersJS" type="text/javascript">
        var rtnVal = new Array();
        var g_AdminYN, g_DeptCode, g_DeptCode2, g_DeptName;
        var g_SelChargerID = "";
        var CompanyID = "${userInfo.companyID}";
        var opnOption = "0";
        var RetValue;
        var ReturnFunction;

        $(function () {
            $("#Sdatepicker").datepicker({
                changeMonth: true,
                changeYear: true,
                autoSize: true,
                showOn: "both",
                buttonImage: "/images/calendar-month.gif",
                buttonImageOnly: true
            });
            $("#Edatepicker").datepicker({
                changeMonth: true,
                changeYear: true,
                autoSize: true,
                showOn: "both",
                buttonImage: "/images/calendar-month.gif",
                buttonImageOnly: true
            });

            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
            $("#Sdatepicker").datepicker('setDate', "");
            $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
            $("#Edatepicker").datepicker('setDate', "");
        });
    <% if("${userInfo.lang}".equals("1")){%>
        $(function () {
            $.datepicker.regional['ko'] = {
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
    <%}else {%>
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
    <%}%>
    window.onload = function () {
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
            KeEventControl(document.getElementById("txtTitle"));
            KeEventControl(document.getElementById("txtdebenturer"));
        }
        try {
            RetValue = parent.searchdelivery_cross_dialogArguments[0];
            ReturnFunction = parent.searchdelivery_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.searchdelivery_cross_dialogArguments[0];
                ReturnFunction = opener.searchdelivery_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        g_AdminYN = RetValue[0];
        g_DeptCode = "";
        g_DeptCode2 = RetValue[1];
        g_DeptName = RetValue[2];
        opnOption = RetValue[3];
        rtnVal[0] = "FALSE";


        //document.getElementById("txtDeptName2").value = g_DeptName;
        //initdatepicker();
        //document.getElementById("idDatepicker").value = "";
        //document.getElementById("Post_D2").value = "";
    }


    function reset_onclick() {
        document.getElementById("txtDeptName").value = "";
        document.getElementById("txtDeptName2").value = "";
        document.getElementById("txtTitle").value = "";
        document.getElementById("idDatepicker").value = "";
        document.getElementById("Post_D2").value = "";
        g_SelChargerID = "";
    }
    function initdatepicker() {
        var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
        idDatepicker.attachEvent('datechange', onStartDateChanged);
        idDatepicker.attachEvent('enddatechange', onEndDateChanged);
        idDatepicker.elemDateButtons = "img_Post_D1;img_Post_D2";
        idDatepicker.elemDateInputs = "idDatepicker;Post_D2";
        idDatepicker.popupType = "both";
        idDatepicker.pickerDateFormat = "[yyyy]<spring:message code='ezApprovalG.t1108'/>";
        idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
        idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
        idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
        idDatepicker.firstDayOfWeek = "0";
        idDatepicker.textAM = "";
        idDatepicker.textPM = "";
        idDatepicker.textDecimal = ".";
        idDatepicker.textHoursAbbrev = "<spring:message code='ezApprovalG.t1092'/>";
        idDatepicker.daynameLetters = "<spring:message code='ezApprovalG.t1111'/>";
        idDatepicker.daynamesShort = "<spring:message code='ezApprovalG.t1111'/>";
        idDatepicker.daynamesLong = "<spring:message code='ezApprovalG.t1112'/>";
        idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
        idDatepicker.monthnamesLong = "1<spring:message code='ezApprovalG.t1113'/>";
<%--         idDatepicker.isoDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>"; --%>
<%--         idDatepicker.isoEndDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>"; --%>
        idDatepicker.ready();
    }


    function btnSearch_onclick() {
        var oParamXml = GetDeliverySearchParamXml();

        if (getXmlString(oParamXml) != "") {
            rtnVal[0] = "TRUE";
            rtnVal[1] = getXmlString(oParamXml);

            window.close();
        }
        else {
            alert("<spring:message code='ezApprovalG.t1091'/>");
        }
    }

    function GetDeliverySearchParamXml() {
        var oXml = createXmlDom();
        var oRoot = "";
        var oData = "";
        createNodeInsert(oXml, oRoot, "SEARCHPARAM");
        createNodeAndInsertText(oXml, oData, "DEPTCODE", g_DeptCode);
        createNodeAndInsertText(oXml, oData, "DEPTCODE2", g_DeptCode2);
        createNodeAndInsertText(oXml, oData, "TITLE", document.getElementById("txtTitle").value);
        createNodeAndInsertText(oXml, oData, "SREGDATE", GetRegSDate());
        createNodeAndInsertText(oXml, oData, "EREGDATE", GetRegEDate());
        createNodeAndInsertText(oXml, oData, "DEBENTURER", document.getElementById("txtdebenturer").value);

        return oXml;
    }
    function GetRegSDate() {
        if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val().length > 0)
            return $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00:00.001";
        else
            return "";
    }
    function GetRegEDate() {
        if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val().length > 0)
            return $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "23:59:59.999";
        else
            return "";
    }

    var lang = "";
    function SelectDept_OnClick(compare) {
        lang = compare;
        SelectDept(undefined, SelectDept_OnClick_Complete);

       
    }
    function SelectDept_OnClick_Complete(rtn) {
        DivPopUpHidden();
        if (rtn[0] == "TRUE" && lang == 0) {
            g_DeptCode = rtn[1];
            document.getElementById("txtDeptName").value = rtn[2];
        }
        else if (rtn[0] == "TRUE" && lang == 1) {
            g_DeptCode2 = rtn[1];
            document.getElementById("txtDeptName2").value = rtn[2];
        }
    }

    function btnCancel_onclick() {
        rtnVal[0] = "FALSE";
        window.close();
    }
    window.onunload = function () {
        if (ReturnFunction != null)
            ReturnFunction(rtnVal);
        else
            window.returnValue = rtnVal;
    }
    </script>
</head>
<body class="popup" style="margin-left: 0px; margin-top: 0px;">
    <h1 style="height: 33px;"><spring:message code='ezApprovalG.t1774'/></h1>
    <table class="content" style="width: 440px">
        <tr>
            <th style="WIDTH: 50px"><spring:message code='ezApprovalG.t99993'/></th>
            <td style="WIDTH: 270px">
                <input class="text" style="WIDTH: 200px" name="txtDeptName2" id="txtDeptName2" disabled>
                <a class="imgbtn" style="vertical-align:middle;"><span onclick="return SelectDept_OnClick(1)" id="btnSelDept2" style="width: 40px; text-align: center"><spring:message code='ezApprovalG.t105'/></span></a>
            </td>
        </tr>
        <tr id="trDept">
            <th style="WIDTH: 50px"><spring:message code='ezApprovalG.t1105'/></th>
            <td style="WIDTH: 270px">
                <input class="text" style="WIDTH: 200px" name="txtDeptName" id="txtDeptName" disabled>
                <a class="imgbtn" style="vertical-align:middle;"><span onclick="return SelectDept_OnClick(0)" id="btnSelDept" style="width: 40px; text-align: center"><spring:message code='ezApprovalG.t105'/></span></a>
            </td>
        </tr>
        <tr>
            <th style="WIDTH: 50px"><spring:message code='ezApprovalG.t1092'/></th>
            <td style="WIDTH: 270px">
                <input class="text" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" name="txtTitle" id="txtTitle">
            </td>
        </tr>
        <tr>
            <th style="WIDTH: 50px"><spring:message code='ezApprovalG.t1775'/></th>
            <td style="WIDTH: 270px">
                <input type="text" id="Sdatepicker" style="width:80px;text-align:center"> 
                <input type="text" id="Edatepicker" style="width:80px;text-align:center">
            </td>
        </tr>
        <tr>
            <th style="WIDTH: 50px"><spring:message code='ezApprovalG.t999931'/></th>
            <td style="WIDTH: 270px">
                <input class="text" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" name="txtdebenturer" id="txtdebenturer">
            </td>
        </tr>
    </table>


    <div class="btnposition">
        <a class="imgbtn" id="reset" onclick="return reset_onclick()"><span><spring:message code='ezApprovalG.t621'/></span></a>
        <a class="imgbtn" id="Submit22223" onclick="return btnSearch_onclick()"><span><spring:message code='ezApprovalG.t111'/></span></a>
        <a class="imgbtn" id="btnClose" name="Submit22223" onclick="return btnCancel_onclick()"><span><spring:message code='ezApprovalG.t119'/></span></a>
    </div>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
