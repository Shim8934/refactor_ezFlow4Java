<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1325'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getContainerInfo_Cross.js"></script>
		<!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script type="text/javascript" src="/js/NameControl_Cross.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var lastdate = "${monthEndDay}";
		    var initdate = "${initDate}";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";								
		    arr_userinfo[1]  = "${userInfo.id}";              
		    arr_userinfo[2]  = "${userInfo.displayName}";         
		    arr_userinfo[3]  = "${userInfo.title}";               
		    arr_userinfo[4]  = "${userInfo.deptID}";              
		    arr_userinfo[5]  = "${userInfo.deptName}";            
		    arr_userinfo[6]  = "${userInfo.jikChek}";                         
		    arr_userinfo[8]  = "${userInfo.email}";               
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";		
		    arr_userinfo[12]  = "${userInfo.displayName2}";		
		    arr_userinfo[13]  = "${userInfo.title1}";				
		    arr_userinfo[14]  = "${userInfo.title2}";				
		    arr_userinfo[15]  = "${userInfo.deptName1}";			
		    arr_userinfo[16]  = "${userInfo.deptName2}";		
		    var ReturnFunction;
		    var Type = "${type}";
		    var NonActiveX = "YES";
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.setsearchinfo_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.setsearchinfo_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("DocNumber"));
		            KeEventControl(document.getElementById("DocTitle"));
		            KeEventControl(document.getElementById("drafter"));
		            KeEventControl(document.getElementById("drafterdept"));
		        }
		        UserID = arr_userinfo[1];
		
		        if (Type == "APR") {
		            document.getElementById("displayTR1").style.display = "none";
		            document.getElementById("displayTR2").style.display = "none";
		            window.resizeBy(0, -60);
		        }
		
		        reset_onclick();
		        Submit3.focus();
		    };
		    $(function () {
		        $("#Sdatepickerapr").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerapr").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Sdatepickerend").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerend").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Sdatepickerapp").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepickerapp").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		    });
		    if ("${userInfo.lang}" == "1") {
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
		
		    function reset_onclick() {
		        document.getElementById("DocNumber").textContent = "";
		        document.getElementById("DocTitle").textContent = "";
		        document.getElementById("drafter").textContent = "";
		        document.getElementById("FormName").textContent = "";
		        document.getElementById("EndAprYear").textContent = "";
		    }
		    
		    function btnSearch_onclick() {
		        var RtnVal = new Array();
		        var chkVal = false;
		        var i;
		        var draftfrom, draftto, apprfrom, apprto, myapprfrom, myapprto;
		
		        draftfrom = $("#Sdatepickerapr").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        draftto = $("#Edatepickerapr").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        apprfrom = $("#Sdatepickerend").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        apprto = $("#Edatepickerend").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        myapprfrom = $("#Sdatepickerapp").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        myapprto = $("#Edatepickerapp").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		
		        if (draftfrom != "" && draftto != "") {
		            if (draftfrom > draftto) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t1326'/>" + "<br>" + "<spring:message code='ezApprovalG.t1327'/>");
		                return;
		            }
		        }
		
		        if (apprfrom != "" && apprto != "") {
		            if (apprfrom > apprto) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t1328'/>" + "<br>" + "<spring:message code='ezApprovalG.t1327'/>");
		                return;
		            }
		        }
		
		        if (myapprfrom != "" && myapprto != "") {
		            if (myapprfrom > myapprto) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t1552'/>" + "<br>" + "<spring:message code='ezApprovalG.t1327'/>");
		                return;
		            }
		        }
		
		        draftfrom = draftfrom.split("-");
		        draftto = draftto.split("-");
		        apprfrom = apprfrom.split("-");
		        apprto = apprto.split("-");
		        myapprfrom = myapprfrom.split("-");
		        myapprto = myapprto.split("-");
		        
		        RtnVal[0] = DocNumber.value;
		        RtnVal[1] = DocTitle.value;
		        RtnVal[2] = drafter.value;
		        RtnVal[3] = draftfrom[0];
		        RtnVal[4] = draftfrom[1];
		        RtnVal[5] = draftfrom[2];
		        RtnVal[6] = draftto[0];
		        RtnVal[7] = draftto[1];
		        RtnVal[8] = draftto[2];
		        RtnVal[9] = apprfrom[0];
		        RtnVal[10] = apprfrom[1];
		        RtnVal[11] = apprfrom[2];
		        RtnVal[12] = apprto[0];
		        RtnVal[13] = apprto[1];
		        RtnVal[14] = apprto[2];
		        RtnVal[15] = myapprfrom[0];
		        RtnVal[16] = myapprfrom[1];
		        RtnVal[17] = myapprfrom[2];
		        RtnVal[18] = myapprto[0];
		        RtnVal[19] = myapprto[1];
		        RtnVal[20] = myapprto[2];
		
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        RtnVal[21] = document.getElementsByName("FormName")[0].id;
		        RtnVal[22] = EndAprYear.value;
		        RtnVal[23] = drafterdept.value;
		
		        RtnVal[24] = "";
		        for (i = 0; i < 25; i++) {
		            if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
		                chkVal = true;
		                break;
		            }
		        }
		
		        if (!chkVal) {
		            RtnVal = "";
		            OpenAlertUI("<spring:message code='ezApprovalG.t1329'/>");
		        }
		        else {
		            if (ReturnFunction != null)
		                ReturnFunction(RtnVal);
		            else
		                window.returnValue = RtnVal;
		            window.close();
		        }
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN() || NonActiveX == "YES") {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function btncancel_onclick() {
		        window.close();
		    }
		    var getformcont_cross_dialogArguments = new Array();
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		        parameter[0] = arr_userinfo[4];
		        parameter[1] = "999";
		
		        getformcont_cross_dialogArguments[0] = parameter;
		        getformcont_cross_dialogArguments[1] = btn_FormSelect_onclick_Complete;
		
		        var url = "/ezApprovalG/getFormCont.do";
		        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
		        feature = feature + GetShowModalPosition(713, 570);
		
		        getformcont_Cross_OpenWin = window.open(url, "getformcont_Cross", GetOpenWindowfeature(713, 570));
		        try { getformcont_Cross_OpenWin.focus(); } catch (e) { }
		        //window.resizeTo(800, 650);
		        //var Positon = getPositionOpenWin(800, 650);
		        //opener.OpenWin2.moveTo(Positon[0], Positon[1]);
		        //setTimeout(function () { DivPopUpShow(713, 570, "/myoffice/ezApprovalG/formContainer/getFormCont_Cross.aspx"); }, 100);
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
		
		    function btn_FormSelect_onclick_Complete(retVal) {
		        //window.resizeTo(530, 410)
		        //var Positon = getPositionOpenWin(530, 410);
		        //opener.OpenWin2.moveTo(Positon[0], Positon[1]);
		        //DivPopUpHidden();
		        if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
		            document.getElementsByName("FormName")[0].id = retVal[2];
		            document.getElementsByName("FormName")[0].value = retVal[3];
		        }
		    }
		    function btnToDaySearch_onclick() {
		        var RtnVal = new Array();
		        var d = new Date();
		        
		        RtnVal[0] = DocNumber.value;
		        RtnVal[1] = DocTitle.value;
		        RtnVal[2] = drafter.value;
		
		        if (Type == "APR") {
		            RtnVal[3] = d.getFullYear();
		            RtnVal[4] = (d.getMonth() + 1);
		            RtnVal[5] = d.getDate();
		            RtnVal[6] = d.getFullYear();
		            RtnVal[7] = (d.getMonth() + 1);
		            RtnVal[8] = d.getDate();
		            RtnVal[9] = "";
		            RtnVal[10] = "";
		            RtnVal[11] = "";
		            RtnVal[12] = "";
		            RtnVal[13] = "";
		            RtnVal[14] = "";
		        }
		        else {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = "";
		            RtnVal[6] = "";
		            RtnVal[7] = "";
		            RtnVal[8] = "";
		            RtnVal[9] = d.getFullYear();
		            RtnVal[10] = (d.getMonth() + 1);
		            RtnVal[11] = d.getDate();
		            RtnVal[12] = d.getFullYear();
		            RtnVal[13] = (d.getMonth() + 1);
		            RtnVal[14] = d.getDate();
		        }
		
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = "";
		        RtnVal[20] = "";
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		
		        RtnVal[21] = document.getElementsByName("FormName")[0].id;
		        RtnVal[22] = EndAprYear.value;
		        RtnVal[23] = drafterdept.value;
		
		        RtnVal[24] = "";
		        if (ReturnFunction != null)
		            ReturnFunction(RtnVal);
		        else
		            window.returnValue = RtnVal;
		        window.close();
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
		        if (Type == "APR") {
		            
		            RtnVal[3] = sYear;
		            RtnVal[4] = sMonth;
		            RtnVal[5] = sDay;
		            RtnVal[6] = sYear2;
		            RtnVal[7] = sMonth2;
		            RtnVal[8] = sDay2;
		            RtnVal[9] = "";
		            RtnVal[10] = "";
		            RtnVal[11] = "";
		            RtnVal[12] = "";
		            RtnVal[13] = "";
		            RtnVal[14] = "";
		        }
		        else {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = "";
		            RtnVal[6] = "";
		            RtnVal[7] = "";
		            RtnVal[8] = "";
		            RtnVal[9] = sYear;
		            RtnVal[10] = sMonth;
		            RtnVal[11] = sDay;
		            RtnVal[12] = sYear2;
		            RtnVal[13] = sMonth2;
		            RtnVal[14] = sDay2;
		        }
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = "";
		        RtnVal[20] = "";
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        RtnVal[21] = document.getElementsByName("FormName")[0].id;
		        RtnVal[22] = EndAprYear.value;
		        RtnVal[23] = drafterdept.value;
		
		        RtnVal[24] = "";
		        
		        if (ReturnFunction != null)
		            ReturnFunction(RtnVal);
		        else
		            window.returnValue = RtnVal;
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
		    function btnMonthSearch_onclick() {
		        var RtnVal = new Array();
		        var d = new Date();
		
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
		        if (Type == "APR") {
		            RtnVal[3] = sYear;
		            RtnVal[4] = sMonth;
		            RtnVal[5] = "01";
		            RtnVal[6] = sYear2;
		            RtnVal[7] = sMonth2;
		            RtnVal[8] = sDay2;
		            RtnVal[9] = "";
		            RtnVal[10] = "";
		            RtnVal[11] = "";
		            RtnVal[12] = "";
		            RtnVal[13] = "";
		            RtnVal[14] = "";
		        }
		        else {
		            RtnVal[3] = "";
		            RtnVal[4] = "";
		            RtnVal[5] = "";
		            RtnVal[6] = "";
		            RtnVal[7] = "";
		            RtnVal[8] = "";
		            RtnVal[9] = sYear;
		            RtnVal[10] = sMonth;
		            RtnVal[11] = "01";
		            RtnVal[12] = sYear2;
		            RtnVal[13] = sMonth2;
		            RtnVal[14] = sDay2;
		        }
		       
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = "";
		        RtnVal[20] = "";
		
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        RtnVal[21] = document.getElementsByName("FormName")[0].id;
		        RtnVal[22] = EndAprYear.value;
		        RtnVal[23] = drafterdept.value;
		
		        RtnVal[24] = "";
		
		        if (ReturnFunction != null)
		            ReturnFunction(RtnVal);
		        else
		            window.returnValue = RtnVal;
		        window.close();
		    }
		    function btnItemCode_onclick() {
		        var url = "../DocNum/docnumui_Cross.aspx";
		        var retVal = window.showModalDialog(url, "", "dialogWidth:670px;dialogHeight:350px;status:no;help:no;scroll:no;edge:sunken");
		
		        if (retVal[0] != "cancel") {
		            tbItemCode.value = retVal[0];
		            tbItemName.value = retVal[1];
		        }
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
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1325'/></h1>
		<table  class="content">
		  <tr>
		    <th ><spring:message code='ezApprovalG.t442'/></th>
		    <c:choose>
		    	<c:when test="${userInfo.lang == '1'}">
				    <td ><input type="text" id="FormName" name="FormName" style="width:200px" disabled>
		      		<a  class="imgbtn" style="vertical-align:middle"><span onClick="return btn_FormSelect_onclick()"><spring:message code='ezApprovalG.t442'/></span></a></td>
		    	</c:when>
		    	<c:otherwise>
				    <td ><input type="text" id="FormName" name="FormName" style="width:193px" disabled>
		      		<a  class="imgbtn" style="vertical-align:middle"><span onClick="return btn_FormSelect_onclick()"><spring:message code='ezApprovalG.t442'/></span></a></td>
		    	</c:otherwise>
		    </c:choose>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApprovalG.t440'/></th>
		    <td ><input type="text" id="DocNumber" name="DocNumber" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApprovalG.t1330'/></th>
		    <td ><input type="text" id="DocTitle" name="DocTitle" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApprovalG.t445'/></th>
		    <td ><input type="text" id="drafter" name="drafter" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApprovalG.t1331'/></th>
		    <td ><input type="text" id="drafterdept" name="drafterdept" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr style="display:none">
		    <th ><spring:message code='ezApprovalG.t1553'/></th>
		    <td ><input type="text" id="EndAprYear" name="EndAprYear" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box" maxlength="50">
		    </td>
		  </tr>
		  <tr>
		    <th ><spring:message code='ezApprovalG.t1332'/></th>
		    <td >
		        <input type="text" id="Sdatepickerapr" style="width:80px;text-align:center">
		        <input type="text" id="Edatepickerapr" style="width:80px;text-align:center">
		    </td>
		  </tr>
		    
		  <tr id="displayTR1">
		    <th ><spring:message code='ezApprovalG.t1334'/></th>
		    <td >
		        <input type="text" id="Sdatepickerend" style="width:80px;text-align:center">
		        <input type="text" id="Edatepickerend" style="width:80px;text-align:center">
		    </td>
		  </tr>
		  <tr id="displayTR2">
		    <th ><spring:message code='ezApprovalG.t1554'/></th>
		    <td >
		        <input type="text" id="Sdatepickerapp" style="width:80px;text-align:center">
		        <input type="text" id="Edatepickerapp" style="width:80px;text-align:center">
		    </td>
		      </tr>
		</table>
		
		<div class="btnposition" >
		<a class="imgbtn"><span onClick="return btnSearch_onclick()" style="width:40px;" id="Submit3"><spring:message code='ezApprovalG.t111'/></span></a>
		<a class="imgbtn"><span onClick="return btnToDaySearch_onclick()" style="width:70px;" id="Submit0"><spring:message code='ezApprovalG.t1336'/></span></a>
		<a class="imgbtn"><span onClick="return btnWeekSearch_onclick()" style="width:70px;" id="Submit1"><spring:message code='ezApprovalG.t1556'/></span></a>
		<a class="imgbtn"><span onClick="return btnMonthSearch_onclick()" style="width:70px;" id="Submit2"><spring:message code='ezApprovalG.t1557'/></span></a>
		<a class="imgbtn"><span onClick="return btncancel_onclick()" style="width:40px;" id="Submit4"><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>