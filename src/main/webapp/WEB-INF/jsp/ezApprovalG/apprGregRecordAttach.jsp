<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code='ezApprovalG.t264'/></title>
<style> 
.IMG_BTN { behavior:url("../include/ImgBtn.htc") }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/escapenew.js"></script>
<script type="text/javascript" src="/js/ezApprovalG/attach_CK.js"></script>
<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
<script type="text/javascript" ID="clientEventHandlersJS">
    var pDocID = null;
    var OrderCell = "";
    var pAttachFlag	= 0;
    var pAttachSN;
    var pAttachAddFileSize =0;
    var Resultxml		= createXmlDom();
    var FirstAttach		= createXmlDom();
    var xmlhttp			= createXMLHttpRequest();
    var chkFlag			= false;
    var arr_userinfo = new Array();
    arr_userinfo[0]  = "user";
    arr_userinfo[1]  = "${userInfo.id}";              // 사용자ID
	arr_userinfo[2]  = "${userInfo.displayName}";         // 사용자명
	arr_userinfo[3]  = "${userInfo.title}";               // 사용자 직위
	arr_userinfo[4]  = "${userInfo.deptID}";              // 사용자 부서 ID 
	arr_userinfo[5]  = "${userInfo.deptName}";            // 사용자 부서 이름
	arr_userinfo[6]  = "${userInfo.jikChek}";             // 사용자 직책            
	arr_userinfo[8]  = "${userInfo.email}";               // E-Mail Address 
	arr_userinfo[9]  = "";
	arr_userinfo[10] = "${susinAdmin}";                  // 수신 접수담당자
	arr_userinfo[11]  = "${userInfo.displayName1}";		// 사용자명(P)
	arr_userinfo[12]  = "${userInfo.displayName2}";		// 사용자명(S)
	arr_userinfo[13]  = "${userInfo.title1}";				// 사용자 직위(P)
	arr_userinfo[14]  = "${userInfo.title2}";				// 사용자 직위(S)
	arr_userinfo[15]  = "${userInfo.deptName1}";			// 사용자 부서 이름(P)
	arr_userinfo[16]  = "${userInfo.deptName2}";			// 사용자 부서 이름(S)
    var pUserID			= arr_userinfo[1];
    var pUserName		= arr_userinfo[2];
    var pUserJobTitle	= arr_userinfo[3];
    var pDeptID			= arr_userinfo[4];
    var pDeptName		= arr_userinfo[5];
	var optExt = "${poptExt}";
	var maxSize = "${maxSize}";
	var isBody = "${isBody}";
    var BodyAttach = "N";
    var AttachDelFlag = false;
    var pServerName = "${serverName}";
    var _hasattach = "${hasattach}";
    var NonActiveX = "YES";
    function getDocInfo() {
        try {
            if (isBody == "YES") {
                BtnBodyAttach.style.display = "";
            }
            else {
                BtnBodyAttach.style.display = "none";
            }
        } catch (e) {
            BtnBodyAttach.style.display = "none";
        }
    }
    function CheckHistory(pFlag) {
        var listview = new ListView();
        listview.LoadFromID("attachList");
        var i, j;
        if (pFlag == 0) {
            var FirstData = SelectNodes(FirstAttach, "LISTVIEWDATA/ROWS/ROW")
            for (i = 0; i < FirstData.length; i++) {
                var tempSN = SelectSingleNodeValue(FirstData[i], "CELL/DATA2");
                var tempFileName = SelectSingleNodeValue(FirstData[i], "CELL/DATA10");
                var DelFlag = true;
                var attachRow = listview.GetDataRows();
                var attachLen = listview.length;
                for (j = 0; j < attachLen; j++) {
                    if (attachRow[j].getAttribute("DATA2") == tempSN && attachRow[j].getAttribute("DATA10") == tempFileName) {
                        DelFlag = false;
                    }
                }
                if (DelFlag)
					UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t266'/>");
            }
        }
        else {
            var FirstData = listview.GetDataRows();
            var FileData = SelectNodes(FirstAttach, "LISTVIEWDATA/ROWS/ROW");
            for (i = 0; i < FirstData.length; i++) {
                var tempSN = FirstData[i].getAttribute("DATA2");
                var tempFileName = FirstData[i].getAttribute("DATA10");
                var AddFlag = true;

                for (j = 0; j < FileData.length; j++) {
                    if (SelectSingleNodeValue(FileData[j], "CELL/DATA2") == tempSN && SelectSingleNodeValue(FileData[j], "CELL/DATA10") == tempFileName) {
                        AddFlag = false;
                    }
                }
                if (AddFlag) {
                    if (FirstData[i].getAttribute("DATA11") == "Y")
						UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t267'/>");
                    else
						UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t268'/>");
                }
                else {
                    if (FirstData[i].getAttribute("DATA12") == "EDITED")
						UpdateAttachHistory(tempSN, "<spring:message code='ezApprovalG.t269'/>");
                }
            }
        }
    }
    window.onload = function () {
        var doc;
        var form;
        getDocInfo();
        pDocID = "${docID}";
        pBoardFileSize = parseInt(maxSize);
        document.getElementById("docid").value = pDocID;
        document.getElementById("compid").value =  "${userInfo.companyID}";
        Resultxml = InitAttach(pDocID);
        var listview = new ListView();
        listview.SetID("attachList");
        listview.SetMulSelectable(false);
        listview.SetSelectFlag(false);
        listview.SetRowOnDblClick("ATTACH_onDblclick");
        listview.DataSource(Resultxml);
        listview.DataBind("ATTACH");
        if (typeof (Resultxml) == "string")
            FirstAttach = loadXMLString(Resultxml);
        else
            FirstAttach = Resultxml;
        pAttachSN = GetAttachSN(Resultxml);
        var pAttachRow = listview.GetDataRows();
        var pAttachRowLen = pAttachRow.length;
        pAttachSN = pAttachSN + 1;
        if (pAttachRow[0].id.indexOf("noItems") == -1) {
            for (var i = 0; i < pAttachRowLen; i++) {
                var f_size = GetChildNodes(pAttachRow[0])[2].innerHTML;
                pAttachAddFileSize = parseInt(pAttachAddFileSize) + parseInt(f_size);
            }
        }
        btn_AttachDel.disabled = true;
    }
    function ReplacText(f_size) {
        rep = /'/g;
        f_size = f_size.replace("bytes", "")
        return f_size
    }
    function attach_Add() {
        document.form.file1.click();
    }
    var g_progresswin;
    function btn_AttachAdd_onclick() {
        if (document.form.file1.value != "") {
            document.getElementById("btn_AttachDel").disabled = false;
            document.getElementById("attachsn").value = pAttachSN;
            document.getElementById("maxsize").value = pBoardFileSize * 1024 * 1024;
            var frm = document.getElementById('form');
            frm.submit();
        }
        else {
            alert("<spring:message code='ezApprovalG.pjj01'/>");
        }
    }
    function replace(str, s, d) {
        var i = 0;
        i = str.indexOf(s);
        while (i > -1) {
            str = str.substr(0, i) + d + str.substr(i + s.length, str.length);
            i = str.indexOf(s);
        }
        return str;
    }
    function show_progress(fileinfo) {
        g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken");
    }
    function status_change(fileinfo) {
        try {
            g_progresswin.document.Script.fileinfo_change(fileinfo);
        } catch (e) { }

    }
    function AttachCancel_onclick() {
        chkFlag = true;
        if (pAttachFlag != "0") {
            AttachFileListCancel();
        }
        parent.DivPopUpHidden();
    }
    function btn_AttachDel_onclick() {
        var listview = new ListView();
        listview.LoadFromID("attachList");
        var pAttachCurSel = listview.GetSelectedRows();
        if (pAttachCurSel.length > 0) {
            var pcheckID = pAttachCurSel[0].getAttribute("DATA4");
            if (pcheckID.toLowerCase() != pUserID.toLowerCase()) {
				var pAlertContent = "<spring:message code='ezApprovalG.t277'/>" + "<br>" + "<spring:message code='ezApprovalG.t278'/>";
                OpenAlertUI(pAlertContent);
            }
            else {
				var pInformationContent = "<spring:message code='ezApprovalG.t279'/>";
                var Ans = OpenInformationUI(pInformationContent, btn_AttachDel_onclick_Complete);
                if (Ans) {
                    var pAttachRow = listview.GetDataRows();
                    var delfileSize = ReplacText(getNodeText(GetChildNodes(pAttachRow[0])[2]))
                    var Rtnval = DeleteFileAtServer(pAttachCurSel[0]);
                    if (Rtnval == "TRUE") {
                        DelAttachFileAtList(pAttachCurSel);
                        DelfileSize(delfileSize);
                    }
                    else {
						var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
                        OpenAlertUI(pAlertContent);
                    }
                }
            }
        }
        else {
			var pAlertContent = "<spring:message code='ezApprovalG.t281'/>";
            OpenAlertUI(pAlertContent);
        }
    }
    function btn_AttachDel_onclick_Complete(Ans) {
        DivPopUpHidden();
        if (Ans) {
            var listview = new ListView();
            listview.LoadFromID("attachList");
            var pAttachCurSel = listview.GetSelectedRows();
            var pAttachRow = listview.GetDataRows();
            var delfileSize = ReplacText(getNodeText(GetChildNodes(pAttachRow[0])[2]))
            var Rtnval = DeleteFileAtServer(pAttachCurSel[0]);
            if (Rtnval == "TRUE") {
                DelAttachFileAtList(pAttachCurSel);
                DelfileSize(delfileSize);
            }
            else {
	            var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
                        OpenAlertUI(pAlertContent);
                    }
                }
    }
    function DelfileSize(delfileSize) {
    }
    function btn_AttachSaveSure_onclick() {
        var listview = new ListView();
        listview.LoadFromID("attachList");
        var Listlen = listview.GetDataRows();
        chkFlag = true;
        if (Listlen.length == 0) {
            CheckHistory(0);
            var RtnVal = AttachRemoveAll();
            if (RtnVal == "FALSE") {
				var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
                OpenAlertUI(pAlertContent);
            }
            for (i = 0 ; i < pDeleteFile.length ; i++) {
                DeleteFileAtServer_true(pDeleteFile[i]);
            }
            parent.setAttachInfo(pDocID, "APR", parent.lstAttachLink);
            parent.DivPopUpHidden();
        }
        else {
            CheckHistory(0);
            var Attachxml = APRAttachXMLParsing(ATTACH, pDocID);
            SaveAttachListInfo(Attachxml);
            for (i = 0 ; i < pDeleteFile.length ; i++) {
                DeleteFileAtServer_true(pDeleteFile[i]);
            }
        }
    }
    function AttachFileInfo(pFileName, pFileSize, pFileLocation) {
        if (pFileName == "Error") {
	        var pAlertContent = "<spring:message code='ezApprovalG.t280'/>";
            OpenAlertUI(pAlertContent);
            btn_AttachAdd.disabled = false;
        }
        else {
            Resultxml = AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation)
        }
    }
    function ATTACHonSelChange_onclick() {
        var pCurSelRow = window.event.result;
        var pAttachUserID = pCurSelRow.cells(0).DATA4;
        if (pAttachUserID.toLowerCase() == pUserID.toLowerCase()) {
            btn_AttachDel.Enable = "true";
            btn_AttachDel.disabled = false;
        }
        else {
            btn_AttachDel.Enable = "false";
            btn_AttachDel.disabled = true;
        }
    }
    
    function ATTACH_onDblclick() {
        var CurSelList = new ListView();
        CurSelList.LoadFromID("attachList");
        var pCurSelRow = CurSelList.GetSelectedRows();
        var pAttachUserID = GetAttribute(pCurSelRow[0], "DATA4");        
        if (pAttachUserID.toLowerCase() == pUserID.toLowerCase()) {
            getAttachFilePageNum(GetAttribute(pCurSelRow[0], "DATA9"), GetChildNodes(pCurSelRow[0])[1].innerHTML, ATTACH_onDblclick_Complete);
        }
    }

    function ATTACH_onDblclick_Complete(retValue) {
        DivPopUpHidden();
        if (retValue[0] == "OK") {
            var CurSelList = new ListView();
            CurSelList.LoadFromID("attachList");
            var pCurSelRow = CurSelList.GetSelectedRows();
            SetAttribute(pCurSelRow[0], "DATA9", retValue[1]);
            pCurSelRow[0].childNodes[1].innerHTML = retValue[2];
            pCurSelRow[0].childNodes[3].innerHTML = retValue[1];
            SetAttribute(pCurSelRow[0], "DATA12", retValue[2]);
        }
        else {
	        var pAlertContent = "<spring:message code='ezApprovalG.t282'/>" + "<br>" + "<spring:message code='ezApprovalG.t283'/>";
            OpenAlertUI(pAlertContent);
        }
    }

    var editattach_cross_dialogArguments = new Array();
    function btn_AttachEdit_onclick() {
        try {
            var listview = new ListView();
            listview.LoadFromID("attachList");
            var pSelectedRow = listview.GetSelectedRows();
            if (pSelectedRow.length != "0") {
                var pAttachUserID = pSelectedRow[0].getAttribute("DATA4");
                if (pAttachUserID.toLowerCase() != pUserID.toLowerCase()) {
			        var pAlertContent = "<spring:message code='ezApprovalG.t282'/>" + "<br>" + "<spring:message code='ezApprovalG.t283'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                var tempAttachFileName = pSelectedRow[0].getAttribute("DATA1");
                var tempAttachFileExt = tempAttachFileName.substring(tempAttachFileName.length - 3, tempAttachFileName.length);
                var tempAttachFileFlag = false;
                if (tempAttachFileExt == "xml" || tempAttachFileExt == "htm" || tempAttachFileExt == "log")
                    tempAttachFileFlag = true;
                var url = "/myoffice/ezApprovalG/ezAPRATTACH/EditFileAttach_Cross.aspx";
                if (tempAttachFileFlag) {
                    var parameter = pSelectedRow[0].getAttribute("DATA1");

                    editattach_cross_dialogArguments[0] = parameter;
                    editattach_cross_dialogArguments[1] = btn_AttachEdit_onclick_Complete;

                    var OpenWin = window.open(url, "EditFileAttach_Cross", GetOpenWindowfeature(720, 630));
                    try { OpenWin.focus(); } catch (e) { }
                }
                else {
                    var parameter = pSelectedRow[0].getAttribute("DATA1");

                    editattach_cross_dialogArguments[0] = parameter;
                    editattach_cross_dialogArguments[1] = btn_AttachEdit_onclick_Complete;

                    var OpenWin = window.open(url, "EditFileAttach_Cross", GetOpenWindowfeature(333, 205));
                    try { OpenWin.focus(); } catch (e) { }
                }
            }
            else {
			    var pAlertContent = "<spring:message code='ezApprovalG.t284'/>";
                OpenAlertUI(pAlertContent);
            }
        }
        catch (ErrMsg) {
            alert("btn_AttachEdit_onclick : " + ErrMsg.description);
        }
    }
    function btn_AttachEdit_onclick_Complete(RtnVal) {
        if (RtnVal == "OK") {
            tempAttachSN = pSelectedRow[0].getAttribute("DATA2");
            EditAttachFileInfoXmlParsing(pSelectedRow[0].cells[1].innerText, pSelectedRow[0].cells[2].innerText, pSelectedRow[0].getAttribute("DATA1"), tempAttachSN);
        }
    }
    function btn_AttachBodyAdd_onclick() {
        BodyAttach = "Y";
        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
        ezUtil.UseUTF8 = true;
        var file = ezUtil.OpenLoadDlgMulti("", "");
        if (!file)
            return;
        g_fileList = file.split(";");
        var fileSize = 0;
        for (var i = 0; i < g_fileList.length - 1; i++) {
            ezUtil.UseUTF8 = true;
            if (ezUtil.GetFileSize(g_fileList[i]) == 0) {
				alert("<spring:message code='ezApprovalG.t270'/>");
                return;
            }
            ezUtil.UseUTF8 = true;
            fileSize += ezUtil.GetFileSize(g_fileList[i]);
        }
        ezUtil = null;
        if (fileSize > pBoardFileSize * 1024 * 1024) {
			alert("<spring:message code='ezApprovalG.t271'/>" + pBoardFileSize + "MB" + "<spring:message code='ezApprovalG.t272'/>");
            return;
        }
        var fileNamelist = "";
        var fileName = "";
		show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "<spring:message code='ezApprovalG.t273'/>" + 1 + "/" + (g_fileList.length-1));
        for (var i = 0; i < g_fileList.length - 1; i++) {
            try {
                if (i > 0)
					status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "<spring:message code='ezApprovalG.t273'/>" + (i+1) + "/" + (g_fileList.length-1));
                oPoster.Clear();
                oPoster.UseUTF8 = true;
                oPoster.AddFormData("mode", "send");
                oPoster.AddFormData("UploadID", pDocID);
                oPoster.AddFormData("UploadSN", pAttachSN);
                oPoster.AddFormData("UploadMaxFileSize", pBoardFileSize);
                oPoster.AddFormData("UploadAddFileSize", pAttachAddFileSize);
                oPoster.AddFile("UploadFile", g_fileList[i], 0);
				oPoster.Host = "${serverName}";
                oPoster.PostURL = "/myoffice/ezApprovalG/ezAPRATTACH/aspx/AttachFile.aspx";
                if (window.location.protocol.toLowerCase() == "http:")
                    oPoster.Protocol = 0;
                else
                    oPoster.Protocol = 1;
                oPoster.Post();
                if (oPoster.Response.substr(0, 2) != "OK") {
                    try {
                        g_progresswin.close();
                    } catch (e) { }

                    if (oPoster.Response.indexOf("ERROR4") >= 0)
                        alert(g_fileList[i] + strLang926);
                    else
						alert(g_fileList[i] + " <spring:message code='ezApprovalG.t274'/>");
                    return;
                }
                else {
                    var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
                    ezUtil.UseUTF8 = true;
                    fileSize = ezUtil.GetFileSize(g_fileList[i]) + "bytes";
                    AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1), fileSize, oPoster.Response.substr(3, oPoster.Response.length - 3));
                }
            }
            catch (e) {
                try {
                    g_progresswin.close();
                } catch (e) { }

                if (e.number == -2147352567)
					alert("<spring:message code='ezApprovalG.t275'/>");
                else
					alert(g_fileList[i] + " <spring:message code='ezApprovalG.t276'/>" + "\n\n" + e.number + " - " + e.description);
                return;
            }
        }
        try {
            g_progresswin.close();
        } catch (e) { }
    }
    function returnvalue(result, filename, filelocation, filesize) {
        if (result == "true") {
            if (filesize == 0) {
                alert("<spring:message code='ezApprovalG.t270'/>");
                return;
            }
            AttachFileInfo(filename, filesize, filelocation, "")
        }
        else if (result == "overflow") {
            alert("<spring:message code='ezApprovalG.t271'/>" + pBoardFileSize + "MB"+ "<spring:message code='ezApprovalG.t272'/>");
        }
        else if (result == "denied") {
            alert(strLang1026);
        }
        else {
            alert(filename + "<spring:message code='ezApprovalG.t276'/>" + "\n\n" + result);
        }
    }
</script>
</HEAD>
<body class="popup">	
		<h1><spring:message code='ezApprovalG.t264'/></h1>
<table>
  <tr>
    <td style="width:285px;text-align:center"><div class="listview">
		<div id="ATTACH" style="overflow:auto; WIDTH: 550px;HEIGHT: 130px;margin:1px 1px 1px 1px"></div>
      </div></td>
  </tr>
</table>  
<iframe name="ifrm" src="about:blank" style="display:none"></iframe>

<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezApprovalG/upload.do" target="ifrm">
  <div class="btnposition">       
        <a class="file-btn" style="vertical-align:top">
          <input id="file1" name="file1" type="file" onchange="btn_AttachAdd_onclick()" /> 
		          <span for="file" id="btn_AttachAdd" ><spring:message code='ezApprovalG.t268'/></span>
        </a>
        <a class="imgbtn"><span id="btn_AttachDel" onClick="return btn_AttachDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></a>
        <a class="imgbtn"><span id="btn_AttachSaveSure" onclick="return btn_AttachSaveSure_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
        <span id="BtnBodyAttach" style="display:none">
            <a id="btn_AttachBodyAdd" class="imgbtn" onClick="return btn_AttachBodyAdd_onclick()"><span><spring:message code='ezApprovalG.t285'/></span></a>
        </span>
    </div>
<input type="hidden" name="compid" id="compid" />
<input type="hidden" name="docid" id="docid" />
<input type="hidden" name="attachsn" id="attachsn" />
<input type="hidden" name="maxsize" id="maxsize" />
</form>
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
</div>
</body>
</HTML>