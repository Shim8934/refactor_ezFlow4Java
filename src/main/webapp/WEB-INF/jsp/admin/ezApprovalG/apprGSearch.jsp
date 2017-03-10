<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1325' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/composeappt.js"></script>
		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var initdate = "<c:out value = '${initDate}' />";
	        var aprFlag = "<c:out value = '${aprFlag}' />";
	        var approvalFlag = "<c:out value = '${approvalFlag}' />";
	        
	        var ReturnFucntion;
	        
	        $(document).ready(function(){
	            if (CrossYN()) {
	                ReturnFucntion = opener.ezStatisticsSearch_Cross_dialogArguments[1];
	            }
	            
	            var ua = navigator.userAgent;
	            
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("DocNumber"));
	                KeEventControl(document.getElementById("DocTitle"));
	                KeEventControl(document.getElementById("drafter"));
	                KeEventControl(document.getElementById("drafterdept"));
	            }
	
	            if (aprFlag == 'END') {
	                document.getElementById("ENDDATETR").style.display = "";
	                document.getElementById("DOCNUM").style.display = "";
	            } else {
	                document.getElementById("ENDDATETR").style.display = "NONE";
	                document.getElementById("DOCNUM").style.display = "NONE";
	            }
	
	            initdatepicker();
	            initdatepicker1();
	
	            reset_onclick();
	            //Submit3.focus();
	        });
	
	        function initdatepicker() {
	            var idDatepicker = new datepicker('idDatepicker', 'idDatepicker0');
	            idDatepicker.attachEvent('datechange', onStartDateChanged);
	            idDatepicker.attachEvent('enddatechange', onEndDateChanged);
	
	            idDatepicker.elemDateButtons = "img_StartCalDisp0;img_EndCalDisp0";
	            idDatepicker.elemDateInputs = "idDatepicker0;_D02";
	            idDatepicker.popupType = "both";
	            idDatepicker.pickerDateFormat = "[yyyy]<spring:message code ='ezApprovalG.t1108' />";
		        idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
		        idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd]";
		        idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
		        idDatepicker.firstDayOfWeek = "0";
		        idDatepicker.textAM = "";
		        idDatepicker.textPM = "";
		        idDatepicker.textDecimal = ".";
		        idDatepicker.textHoursAbbrev = "<spring:message code ='ezApprovalG.t1092' />";
		        idDatepicker.daynameLetters = "<spring:message code ='ezApprovalG.t1111' />";
		        idDatepicker.daynamesShort = "<spring:message code ='ezApprovalG.t1111' />";
		        idDatepicker.daynamesLong = "<spring:message code ='ezApprovalG.t1112' />";
		        idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
		        idDatepicker.monthnamesLong = "1<spring:message code ='ezApprovalG.t1113' />";
		        <%-- idDatepicker.isoDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>";
		        idDatepicker.isoEndDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>"; --%>
		        idDatepicker.ready();
		    }
		    
	        function initdatepicker1() {
		        var initdatepicker1 = new datepicker('idDatepicker1', 'idDatepicker1');
		        initdatepicker1.attachEvent('datechange', onStartDateChanged);
		        initdatepicker1.attachEvent('enddatechange', onEndDateChanged);
		
		        initdatepicker1.elemDateButtons = "img_StartCalDisp1;img_EndCalDisp1";
		        initdatepicker1.elemDateInputs = "idDatepicker1;_D12";
		        initdatepicker1.popupType = "both";
		        initdatepicker1.pickerDateFormat = "[yyyy]<spring:message code ='ezApprovalG.t1108' />";
		        initdatepicker1.pickerTimeFormat = "[tt] [h]:[mm]";
		        initdatepicker1.inputDateFormat = "[yyyy]-[MM]-[dd]";
		        initdatepicker1.inputTimeFormat = "[tt] [h]:[mm]";
		        initdatepicker1.firstDayOfWeek = "0";
		        initdatepicker1.textAM = "";
		        initdatepicker1.textPM = "";
		        initdatepicker1.textDecimal = ".";
		        initdatepicker1.textHoursAbbrev = "<spring:message code ='ezApprovalG.t1092' />";
		        initdatepicker1.daynameLetters = "<spring:message code ='ezApprovalG.t1111' />";
		        initdatepicker1.daynamesShort = "<spring:message code ='ezApprovalG.t1111' />";
		        initdatepicker1.daynamesLong = "<spring:message code ='ezApprovalG.t1112' />";
		        initdatepicker1.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
		        initdatepicker1.monthnamesLong = "1<spring:message code ='ezApprovalG.t1113' />";
		        <%-- initdatepicker1.isoDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>";
		        initdatepicker1.isoEndDateUTF = "<%=DateTime.Parse(GetLocalTime(System.DateTime.UtcNow.ToShortDateString())).ToString("o")%>"; --%>
		        initdatepicker1.ready();
		    }
		
		    function reset_onclick() {
		        document.getElementById("DocNumber").value = "";
		        document.getElementById("DocTitle").value = "";
		        document.getElementById("drafter").value = "";
		        document.getElementById("FormName").value = "";
		        document.getElementById("idDatepicker0").value = "";
		        document.getElementById("idDatepicker1").value = "";
		        document.getElementById("_D02").value = "";
		        document.getElementById("_D12").value = "";
		        document.getElementById("keyword").value = "";
		    }
		    
		    function btnSearch_onclick() {
		        var RtnVal = new Array();
		        var chkVal = false;
		        var i;
		        var draftfrom, draftto, apprfrom, apprto;
		
		        draftfrom = document.getElementById("idDatepicker0").value;
		        draftto = document.getElementById("_D02").value;
		        apprfrom = document.getElementById("idDatepicker1").value;
		        apprto = document.getElementById("_D12").value;
		        
		        if (draftfrom != "" && draftto != "") {
		            if (draftfrom > draftto) {
		                OpenAlertUI("<spring:message code ='ezApprovalG.t1326' /><br><spring:message code ='ezApprovalG.t1327' />");
		                return;
		            }
		        }
		
		        if (apprfrom != "" && apprto != "") {
		            if (apprfrom > apprto) {
		                OpenAlertUI("<spring:message code ='ezApprovalG.t1328' /><br><spring:message code ='ezApprovalG.t1327' />");
		                return;
		            }
		        }
		        
		        if (draftfrom == "") {
		            draftfrom = "--";
		        }
		        if (draftto == "") {
		            draftto = "--";
		        }
		        if (apprfrom == "") {
		            apprfrom = "--";
		        }
		        if (apprto == "") {
		            apprto = "--";
		        }
		
		        draftfrom = draftfrom.split("-");
		        draftto = draftto.split("-");
		        apprfrom = apprfrom.split("-");
		        apprto = apprto.split("-");
		
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
		        
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        
		        RtnVal[15] = document.getElementsByName("FormName")[0].id;
		        RtnVal[16] = "";
		        RtnVal[17] = document.getElementById("drafterdept").value;
		        RtnVal[18] = "";
		        
		        if (keyword.value != "") {
		            RtnVal[18] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
		        } else {
		            RtnVal[18] = "";
		        }
		
		        if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
		            if (RtnVal[18] != "") {
		                RtnVal[18] = RtnVal[18] + " and ";
		            }
		            RtnVal[18] = RtnVal[18] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
		        }
		
		        RtnVal[19] = approvUser.value;
		
		        for (i = 0; i < 20; i++) {
		            if (RtnVal[i] != "" && typeof (RtnVal[i]) != "undefined") {
		                chkVal = true;
		                break;
		            }
		        }
		
		        if (!chkVal) {
		            RtnVal = "";
		            OpenAlertUI("<spring:message code ='ezApprovalG.t1329' />");
		        } else {
		            if (CrossYN()) {
		                ReturnFucntion(RtnVal);
		            } else {
		                window.returnValue = RtnVal;
		            }
		            
		            window.close();
		        }
		    }
		    
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = pAlertContent;
		            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		            try { ezAPRALERT_Cross.focus(); } catch (e) {
		            }
		        } else {
		            var parameter = pAlertContent;
		            var url = "/ezApprovalG/ezAprAlert.do";
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		    
		    function OpenAlertUI_Complete() {
		    }
		    
		    function btncancel_onclick() {
		        window.close();
		    }
		/*
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		        parameter[0] = arr_userinfo[4];
		        parameter[1] = "999";
		
		        var url = "getFormCont.aspx";
		        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no"
		        var retVal = window.showModalDialog(url, parameter, feature);
		
		        if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
		            document.getElementsByName("FormName")[0].id = retVal[2];
		            document.getElementsByName("FormName")[0].value = retVal[3];
		        }
		    }
		*/
		    var getformcont_cross_dialogArguments = new Array();//150709 이윤호 양식명으로 검색 추가
		    function btn_FormSelect_onclick() {
		        var parameter = new Array();
		        parameter[0] = "<c:out value = '${userInfo.deptID}' />";
		        parameter[1] = "999";
		        getformcont_cross_dialogArguments[0] = parameter;
		        getformcont_cross_dialogArguments[1] = btn_FormSelect_onclick_Complete;
		        var retVal = window.open("/ezApprovalG/getFormCont.do", "", GetOpenWindowfeature(705, 600));
		    }
		
		    function btn_FormSelect_onclick_Complete(retVal) {
		        if (typeof (retVal) != "undefined" && retVal[0] != "cancel") {
		            document.getElementsByName("FormName")[0].id = retVal[2];
		            document.getElementsByName("FormName")[0].value = retVal[3];
		        }
		    }
		
		    function btnToDaySearch_onclick() {
		        var RtnVal = new Array();
		        var d = new Date();
		
		        RtnVal[0] = document.getElementById("DocNumber").value;
		        RtnVal[1] = document.getElementById("DocTitle").value;
		        RtnVal[2] = document.getElementById("drafter").value;
		
		        if (aprFlag == 'END') {
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
		        } else {
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
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = approvUser.value;
		        RtnVal[20] = "";
		        
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        
		        RtnVal[21] = document.getElementsByName("FormName")[0].id;
		        RtnVal[22] = "";
		        RtnVal[23] = document.getElementById("drafterdept").value;
		        RtnVal[24] = "";
		        
		        if (document.getElementById("keyword").value != "") {
		            RtnVal[24] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
		        } else {
		            RtnVal[24] = "";
		        }
		
		        if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
		            if (RtnVal[24] != "") {
		                RtnVal[24] = RtnVal[24] + " and ";
		            }
		            
		            RtnVal[24] = RtnVal[24] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
		        }
		        
		        if(CrossYN()) {
		            ReturnFucntion(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        
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
		
		        RtnVal[0] = document.getElementById("DocNumber").value;
		        RtnVal[1] = document.getElementById("DocTitle").value;
		        RtnVal[2] = document.getElementById("drafter").value;
		        
		        if (aprFlag == 'END') {
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
		    	} else {
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
		        
			    RtnVal[15] = "";
			    RtnVal[16] = "";
			    RtnVal[17] = "";
			    RtnVal[18] = "";
			    RtnVal[19] = approvUser.value;
			    RtnVal[20] = "";
			    
			    if (document.getElementsByName("FormName")[0].id == "FormName") {
			        document.getElementsByName("FormName")[0].id = "";
			    }
			    
			    RtnVal[21] = document.getElementsByName("FormName")[0].id;
			    RtnVal[22] = "";
			    RtnVal[23] = document.getElementById("drafterdept").value;
			    RtnVal[24] = "";
			    
			    if (keyword.value != "") {
			        RtnVal[24] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
			    } else {
			        RtnVal[24] = "";
			    }
		
			    if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
			        if (RtnVal[24] != "") {
			            RtnVal[24] = RtnVal[24] + " and ";
			        }
			
			        RtnVal[24] = RtnVal[24] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
			    }
			    
			    if (CrossYN()) {
			        ReturnFucntion(RtnVal);
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
			
			    RtnVal[0] = document.getElementById("DocNumber").value;
			    RtnVal[1] = document.getElementById("DocTitle").value;
			    RtnVal[2] = document.getElementById("drafter").value;
			    
		    	if (aprFlag == 'END') {
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
		        } else {
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
		    	
		        RtnVal[15] = "";
		        RtnVal[16] = "";
		        RtnVal[17] = "";
		        RtnVal[18] = "";
		        RtnVal[19] = approvUser.value;
		        RtnVal[20] = "";
		
		        if (document.getElementsByName("FormName")[0].id == "FormName") {
		            document.getElementsByName("FormName")[0].id = "";
		        }
		        
		        RtnVal[21] = document.getElementsByName("FormName")[0].id;
		        RtnVal[22] = "";
		        RtnVal[23] = document.getElementById("drafterdept").value;
		        RtnVal[24] = "";
		        
		        if (document.getElementById("keyword").value != "") {
		            RtnVal[24] = " keyword like '%" + document.getElementById("keyword").value + "%' ";
		        } else {
		            RtnVal[24] = "";
		        }
		
		        if (document.getElementsByName("tbItemCode").value != "" && document.getElementsByName("tbItemCode").value != undefined) {
		            if (RtnVal[24] != "") {
		                RtnVal[24] = RtnVal[24] + " and ";
		            }
		
		            RtnVal[24] = RtnVal[24] + " itemcode = '" + document.getElementsByName("tbItemCode").value + "' ";
		        }
		        
		        if (CrossYN()) {
		            ReturnFucntion(RtnVal);
		        } else {
		            window.returnValue = RtnVal;
		        }
		        
		        window.close();
		    }
		    
			function btnItemCode_onclick() {
		        var url = "../DocNum/docnumui.aspx";
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
		        
		        if (nowMonth <= 0) {
		            RtnVal[0] = new Date(nowYear - 1, 11, nowDay);
		        } else {
		            RtnVal[0] = new Date(nowYear, nowMonth - 1, nowDay);
		        }
		        
		        RtnVal[1] = new Date(nowYear, nowMonth, nowDay);
		        return RtnVal;
		    }
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code ='ezApprovalG.t1325' /></h1>
	    <table class="content">
	        <tr style="display: none">
            	<th><spring:message code ='ezApprovalG.t1197' /></th>
	            <td>
	                <input type="text" name="tbItemCode" style="width: 60px" readonly="readonly">
	                <input type="text" name="tbItemName" style="width: 140px" readonly="readonly">
	                <a class="imgbtn"><span onclick="return btnItemCode_onclick()"><spring:message code ='ezApprovalG.t1197' /></span></a>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t442' /></th>
	            <td>
	                <input type="text" id="FormName" name="FormName" style="width: 200px;" disabled>
	                <a class="imgbtn"><span onclick="return btn_FormSelect_onclick()"><spring:message code ='ezApprovalG.t442' /></span></a>
	            </td>
	        </tr>
	        <c:if test="${approvalFlag == 'G'}">
		        <tr id="DOCNUM">
		            <th><spring:message code ='ezApprovalG.t440' /></th>
		            <td>
		                <input type="text" id="DocNumber" name="DocNumber" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
		            </td>
		        </tr>
	        </c:if>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t1330' /></th>
	            <td>
	                <input type="text" id="DocTitle" name="DocTitle" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t445' /></th>
	            <td>
	                <input type="text" id="drafter" name="drafter" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <c:if test="${approvalFlag == 'G'}">
		        <tr>
		            <th><spring:message code ='ezApprovalG.t15000' /></th>
		            <td>
		                <input type="text" id="approvUser" name="approvUser" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
		            </td>
		        </tr>
			</c:if>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t1331' /></th>
	            <td>
	                <input type="text" id="drafterdept" name="drafterdept" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="50">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code ='ezApprovalG.t1332' /></th>
	            <td>
	                <input readonly="readonly" class='datepicker' id='idDatepicker0' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
	                <img src="/images/i_scheduler.gif" id="img_StartCalDisp0" width="19" height="15" alt="" border="0" popuplocation='topleft' style="cursor: pointer; POSITION: relative">&nbsp;~&nbsp;
	                <input readonly="readonly" id='_D02' type="text" style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
	                <img src="/images/i_scheduler.gif" id="img_EndCalDisp0" width="19" height="15" alt="" border="0" popuplocation='topleft' style="cursor: pointer; POSITION: relative">
	            </td>
	        </tr>
	        <c:if test="${approvalFlag == 'G'}">
		        <tr id="ENDDATETR">
		            <th><spring:message code ='ezApprovalG.t1334' /></th>
		            <td>
		                <input readonly="readonly" class='datepicker' id='idDatepicker1' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
		                <img src="/images/i_scheduler.gif" id="img_StartCalDisp1" width="19" height="15" alt="" border="0" popuplocation='topleft' style="cursor: pointer; POSITION: relative">&nbsp;~&nbsp;
		                <input readonly="readonly" id='_D12' type="text" style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
		                <img src="/images/i_scheduler.gif" id="img_EndCalDisp1" width="19" height="15" alt="" border="0" popuplocation='topleft' style="cursor: pointer; POSITION: relative">
		            </td>
		        </tr>
			</c:if>
	        <tr id="KEYWORDTR" style="display: none">
	            <th><spring:message code ='ezApprovalG.t1200' /></th>
	            <td>
	                <input type="text" id="keyword" name="keyword" style="width: 100%" maxlength="50">
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return btnSearch_onclick()"><spring:message code ='ezApprovalG.t111' /></span></a>
	        <a class="imgbtn"><span onclick="return btnToDaySearch_onclick()"><spring:message code ='ezApprovalG.t1336' /></span></a>
	        <a class="imgbtn"><span onclick="return btnWeekSearch_onclick()"><spring:message code ='ezApprovalG.t1337' /></span></a>
	        <a class="imgbtn"><span onclick="return btnMonthSearch_onclick()"><spring:message code ='ezApprovalG.t1338' /></span></a>
	        <a class="imgbtn"><span onclick="return btncancel_onclick()"><spring:message code ='ezApprovalG.t119' /></span></a>
	    </div>
	</body>
</html>