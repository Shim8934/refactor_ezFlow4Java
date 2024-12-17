<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.t1001'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfo_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docListView_Cross.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
<script ID="clientEventHandlersJS" type="text/javascript">
    var OrderCell = "";
    var flag = false;
    var flag2 = false;
    var condition = new Array();
    var DocList_Flag, DeptID,DATA,NodeList,pStartNum,pEndNum,ContainerID,DelListYN,UserID,Init_Flag,AdminYN ;
    var xmlhttp;
    var g_ParamXml,ListTypeFlag,DeptName;
    var Rows,NodeList,HeaderList;
    var gTotalDocList;
    var Resultxml;
    var RetValue;
    var ReturnFunction;
    window.onload = function () {
        try {
            RetValue = parent.doclistview_cross_dialogArguments[0];
            ReturnFunction = parent.doclistview_cross_dialogArguments[1];
        } catch (e) {
            try {
                RetValue = opener.doclistview_cross_dialogArguments[0];
                ReturnFunction = opener.doclistview_cross_dialogArguments[1];
            } catch (e) {
                RetValue = window.dialogArguments;
            }
        }
        DocList_Flag = RetValue[0];
        DeptID = RetValue[1];
        ContainerID = RetValue[2];
        DelListYN = RetValue[3];
        condition = RetValue[4];
        UserID = RetValue[5];
        Init_Flag = RetValue[6];
        AdminYN = RetValue[7];
        ListTypeFlag = RetValue[8];
        g_ParamXml = RetValue[9];
        DeptName = RetValue[10];
        gTotalDocList = RetValue[11];
        if(gTotalDocList < 1) {
            document.getElementById("StartNum").value = "0";
        } else {
            document.getElementById("StartNum").value = "1";
        }
        if (parseInt(gTotalDocList) > 1000)
            gTotalDocList = "1000";
        document.getElementById("EndNum").value = gTotalDocList;
        PrintLimit_onclick();
    }
    function KeEventControl(obj) {
        useragt = navigator.userAgent.toUpperCase();
        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
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
    function RecDocLoad() {
        if (DocList_Flag == "CABINET")
            DATA = GetCabListForPrint();
        else if (DocList_Flag == "RECORD")
            DATA = GetRecListForPrint();
        else if (DocList_Flag == "CABHIST" || DocList_Flag == "RECHIST" || DocList_Flag == "SCLIST" || DocList_Flag == "ATTACH" || DocList_Flag == "DISTLIST")
            DATA = GetCabListForPrint();
        else if (DocList_Flag == "Delivery")
            DATA = GetDeliveryListForPrint();
    }

    function GetDeliveryListForPrint() {
        xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        xmlpara = loadXMLString(g_ParamXml);

        setNodeText(SelectNodes(xmlpara, "PAGESIZE")[0], document.getElementById("StartNum").value);
        setNodeText(SelectNodes(xmlpara, "PAGENO")[0], document.getElementById("EndNum").value);
        setNodeText(SelectNodes(xmlpara, "ISDOCPRINT")[0], "TRUE");

        xmlhttp.open("POST", "/ezApprovalG/getDeliveryList.do", true);
        xmlhttp.onreadystatechange = listviewbind;
        RequestXMLinfo = xmlpara;
        xmlhttp.send(xmlpara);
    }

    function PrintLimit_onclick() {
        var startcnt = parseInt(StartNum.value);
        var endcnt = parseInt(EndNum.value);
        if (StartNum.value == "" || EndNum.value == "") {
            alert("<spring:message code='ezApprovalG.t1004'/>");
        } else if (startcnt < 1 && endcnt != 0) {
        	alert("<spring:message code='ezApprovalG.garm03'/>")
        	$('#StartNum').val(1);
        } else if (startcnt > endcnt) {
            alert("<spring:message code='ezApprovalG.t1005'/>");
        } else if ((endcnt - startcnt) >= 1000) {
            alert("<spring:message code='ezApprovalG.t1900'/>");
        } else {
            document.getElementById("lvtDoclist").innerHTML = "<table style='width:100%;height:100%;'><tr><td style='text-align:center'><img src='/images/email/progress_01.gif' style='vertical-align:middle'><td></tr></table>";
            RecDocLoad();
        }
    }
    var RequestXMLinfo;
    var RequestXMLinfo2;
    function GetCabListForPrint() {
        xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        xmlpara = loadXMLString(g_ParamXml);

        setNodeText(SelectNodes(xmlpara, "PAGESIZE")[0], StartNum.value);
        setNodeText(SelectNodes(xmlpara, "PAGENO")[0], EndNum.value);

        var objNodes = SelectNodes(xmlpara, "PARAMETERS")[0];
        var objChildNodes;
        createNodeAndAppandNodeText(xmlpara, objNodes, objChildNodes, "ISDOCPRINT", "TRUE");

        if (ListTypeFlag == 2 || ListTypeFlag == 3 || ListTypeFlag == 4)
            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetTransList.aspx", true);
        else
            xmlhttp.open("POST", "/ezApprovalG/getCabinetList.do", true);

        xmlhttp.onreadystatechange = listviewbind;
        RequestXMLinfo = xmlpara;
        xmlhttp.send(xmlpara);

    }
    function GetRecListForPrint() {
        xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        xmlpara = loadXMLString(g_ParamXml);

        setNodeText(SelectNodes(xmlpara, "PAGESIZE")[0], StartNum.value);
        setNodeText(SelectNodes(xmlpara, "PAGENO")[0], EndNum.value);

        var objNodes = SelectNodes(xmlpara, "PARAMETERS")[0];
        var objChildNodes;
        createNodeAndAppandNodeText(xmlpara, objNodes, objChildNodes, "ISDOCPRINT", "TRUE");

        if (ListTypeFlag == 2 || ListTypeFlag == 3 || ListTypeFlag == 4)
            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetTransList.aspx", true);
        else
            xmlhttp.open("POST", "/ezApprovalG/getRecordList.do", true);

        xmlhttp.onreadystatechange = listviewbind;
        RequestXMLinfo = xmlpara;
        xmlhttp.send(xmlpara);

    }
    function listviewbind() {
        if (xmlhttp.readyState != "4" || xmlhttp == null) {
            return;
        }
        else {
            
            Resultxml = xmlhttp.responseXML;
            RequestXMLinfo2 = xmlhttp.responseXML;
            DATA = getXmlString(Resultxml);
            document.getElementById("lvtDoclist").innerHTML = "";
            var listview = new ListView();
            listview.SetID("DEPTLIST");
            listview.DataSource(Resultxml);
            listview.DataBind("lvtDoclist");
        }
    }
    
    function btnPrint_onclick() {

		var tmpNodeList = SelectSingleNodeNew(Resultxml,"DOCLIST/TOTALDOCCOUNT");
		var resultCnt = getNodeText(tmpNodeList);
		
    	document.getElementById("saveExcelData").value = getXmlString(Resultxml);
    	
        if (!CrossYN()) {
            document.getElementById("userAgent").value = "MSIE";
        }

        if (resultCnt == 0) {
			alert("<spring:message code='ezApprovalG.pjg03'/>");
        } else {
        	document.getElementById("formAgent").target = "saveExcel";
        	document.getElementById("formAgent").submit();     	
        }     

    }
    
    function btnSave_onclick() {
        var csvstring;
        csvstring = mskecsvstr();
        if (csvstring == "FALSE") {
            var pAlertContent = "<spring:message code='ezApprovalG.t1006'/>";
            OpenAlertUI(pAlertContent);
            return;
        }
        savecsv(csvstring);
    }
    function pzFormProc_DocumentComplete() {
    }
    function pzFormProc_FieldsAvailable() {
        SetAutoPropertyValue();
    }
    function SetAutoPropertyValue() {
        var i;
        var rowLen;
        var currDate = new Date();
        var isfirst = true;
        var vtable1, vtable2, NodeList;
        var Resultxml = createXmlDom();

        Resultxml.async = false;
        Resultxml.loadXML(DATA);
        vtable1 = pzFormProc.Fields("table1");
        vtable2 = pzFormProc.Fields("table2");
        pzFormProc.specialTableObject = vtable1.TagObject;
        pzFormProc.specialTableObject = vtable2.TagObject;

        pzFormProc.ShowWorkingDlg("\n<spring:message code='ezApprovalG.t1007'/>", true);

        if (DocList_Flag == "CABINET" || DocList_Flag == "RECORD" || DocList_Flag == "CABHIST" || DocList_Flag == "RECHIST" || DocList_Flag == "SCLIST" || DocList_Flag == "ATTACH" || DocList_Flag == "DISTLIST")
            CabAddCol();
        else
            DocListAddCol();

        pzFormProc.ShowWorkingDlg("", false);
    }
    function btnClose_onclick() {
        window.close();
    }

    function checkForNumber() {
        if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || event.keyCode == 8 || event.keyCode == 9) {
        } else {
            event.returnValue = false;
        }
    }

    function fn_onlyNumber(loc) {
        if (/[^0123456789]/g.test(loc.value)) {
            loc.value = loc.value.substring(0, loc.value.length - 1);
            loc.focus();
        }
    }

</script>
<script language="javascript" FOR="pzFormProc" EVENT="DocumentComplete">
    pzFormProc_DocumentComplete()
</script>
<script language="javascript" FOR="pzFormProc" EVENT="FieldsAvailable">
    pzFormProc_FieldsAvailable()
</script>
<script language="javascript" FOR="pzFormProc" EVENT="InvalidDocument">
    pzFormProc_InvalidDocument()
</script>
<script language=javascript FOR=pzFormProc EVENT="ElementKeyEvent(nKey, bShiftKey, bCtlrKey)">
    pzFormProc_ElementKeyEvent(nKey, bShiftKey, bCtlrKey)
</SCRIPT>
<script language=javascript FOR=pzFormProc EVENT=ControlNotifyEvent(Element)>
    pzFormProc_ControlNotifyEvent(Element)
</SCRIPT>
</head>
<body class="popup">
<div id="menu">
	<ul>
		<li><span onClick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t530'/></span></li> 
	</ul>
</div>
<div id="close"><ul><li id=btnClose ><span onClick="return btnClose_onclick()"></span></li></ul></div>
<table style="table-layout:fixed; width:100%; height:480px">
	<tr> 
		<td style="height:30px">
			<spring:message code='ezApprovalG.t1008'/>
			<input name="StartNum" id="StartNum" type="text" size="4" onkeyup="fn_onlyNumber(this)" onkeydown="return checkForNumber()">
			~
			<input name="EndNum" id="EndNum" type="text" size="4" onkeyup="fn_onlyNumber(this)" onkeydown="return checkForNumber()">
			<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="return PrintLimit_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>  
			<span id = countInfo class="point"> </span>
		</td>
	</tr>
	<tr> 
		<td style="height:100%">
			<div class="div_scroll"  style="width:100%;HEIGHT:480px;border:1px solid #dbdbda; overflow:AUTO" id="divList">
                <div ID="lvtDoclist" style="height:100%"></div>
            </div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	selToggleList(document.getElementById("menu"), "ul", "li", "0");
</script>

    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezApprovalG/excelExportOut.do">
      <input type=hidden id="saveExcelData" name="saveExcelData" value="">
        <input type=hidden id="listType" name="listType" value="PRINT">
        <input type=hidden id="MODE" name="MODE" value="m99">
        <input type=hidden id="userAgent" name="userAgent" value="">
</form>
<iframe id="saveExcel" name="saveExcel" style="display:none"></iframe>
</body>
</html>


