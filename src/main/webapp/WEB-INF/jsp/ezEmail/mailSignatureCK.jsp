<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>mail_signature</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
	    <script type="text/javascript" src="/js/ezEmail/js/dhtml.js"></script>
		<script type="text/javascript">
		    var pUserID = "${userId}"; //TODO: userinfo.userID 로 수정해야함
		    var pSigState = "0";
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        document.getElementById("1tab1").setAttribute("class", "tabon");
		        Tab1_SelectID = "1tab1";
		    }
		
		    function Editor_Complete() {
		        tbContentElement.SetEditorContent(document.getElementById("_signature1").innerHTML);
		    }
		
		    function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
		        var XmlHttp = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
		        createNodeAndInsertText(xmlDom, objNode, "HEIGHT", pImgHeight);
		        createNodeAndInsertText(xmlDom, objNode, "WIDTH", pImgWidth);
		        try {
		            XmlHttp.open("POST", "/myoffice/ezEmail/remote/SignatureToSaveFile.aspx", false);
		            XmlHttp.send(xmlDom);
		            return XmlHttp.responseText;
		        }
		        catch (e) { }
		    }
		    function Signature_ImagePathConvert(tbContent, obj) {
		        var tempDiv = document.createElement("DIV");
		        tempDiv.innerHTML = tbContent;
		        var imgColl = tempDiv.getElementsByTagName("IMG");
		        for (var i = 0; i < imgColl.length; i++) {
		            if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0) {
		                var OrgSrc = imgColl.item(i).src;
		                var ImgHeight = "0";
		                var ImgWidth = "0";
		                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
		                if (result.length == 2)
		                    ImgWidth = result[1];
		                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
		                if (result.length == 2)
		                    ImgHeight = result[1];
		
		                var NewSrc = ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
		                var OrgBody = obj.innerHTML;
		                OrgBody = OrgBody.replace(OrgSrc, NewSrc);
		                obj.innerHTML = OrgBody;
		            }
		        }
		    }
		    function SetSig() {
		        try {
		            switch (Tab1_SelectID) {
		                case "1tab1":
		                    document.getElementById("_signature1").innerHTML = tbContentElement.GetEditorContent();
		                    break;
		                case "1tab2":
		                    document.getElementById("_signature2").innerHTML = tbContentElement.GetEditorContent();
		                    break;
		                case "1tab3":
		                    document.getElementById("_signature3").innerHTML = tbContentElement.GetEditorContent();
		                    break;
		            }
		
		            var xmlHTTP = createXMLHttpRequest();
		            var xmlDOM = createXmlDom();
		            var sign1 = replaceAll(document.getElementById("_signature1").innerHTML, "<p>", "");
		            var sign2 = replaceAll(document.getElementById("_signature2").innerHTML, "<p>", "");
		            var sign3 = replaceAll(document.getElementById("_signature3").innerHTML, "<p>", "");
		            sign1 = replaceAll(sign1, "</p>", "");
		            sign2 = replaceAll(sign2, "</p>", "");
		            sign3 = replaceAll(sign3, "</p>", "");
		            
		            if (sign1 != "") {
		                Signature_ImagePathConvert(sign1, document.getElementById("_signature1"));
		                sign1 = "<DIV>" + removeoniondiv(document.getElementById("_signature1")).innerHTML + "</DIV>";
		            }
		            if (sign2 != "") {
		                Signature_ImagePathConvert(sign2, document.getElementById("_signature2"));
		                sign2 = "<DIV>" + removeoniondiv(document.getElementById("_signature2")).innerHTML + "</DIV>";
		            }
		            if (sign3 != "") {
		                Signature_ImagePathConvert(sign3, document.getElementById("_signature3"));
		                sign3 = "<DIV>" + removeoniondiv(document.getElementById("_signature3")).innerHTML + "</DIV>"
		            }
		
		            for (var i = 0 ; i < document.getElementsByName("SigState").length ; i++) {
		                if (document.getElementsByName("SigState").item(i).checked)
		                    pSigState = document.getElementsByName("SigState").item(i).value;
		            }
		
		            var objNode;
		            createNodeInsert(xmlDOM, objNode, "DATA");
		            createNodeAndInsertText(xmlDOM, objNode, "USERID", pUserID);
		            createNodeAndInsertText(xmlDOM, objNode, "USEFLAG", pSigState);
		            createNodeAndInsertText(xmlDOM, objNode, "CONTENT1", sign1);
		            createNodeAndInsertText(xmlDOM, objNode, "CONTENT2", sign2);
		            createNodeAndInsertText(xmlDOM, objNode, "CONTENT3", sign3);
		            xmlHTTP.open("POST", "/ezEmail/mailSignSave.do", false);
		            xmlHTTP.send(xmlDOM);
		            if (xmlHTTP.status == 200)
		                alert("<spring:message code='ezEmail.t42' />");
		            else
		                alert("<spring:message code='ezEmail.t228' />" + xmlHTTP.statusText);
		
		            xmlHTTP = null;
		        }
		        catch (e) {
		            alert("<spring:message code='ezEmail.t228' />" + e.description);
		        }
		    }
		    function replaceAll(pStrContent, pStrOrg, pStrRep) {
		        return pStrContent.split(pStrOrg).join(pStrRep);
		    }
		    function Cancel_Click() {
		        window.location.reload(true);
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function html_edit(obj) {
		        var rtnValue = "";
		        var sign = "";
		        if (obj != "") {
		            var feature = "dialogHeight:480px; dialogWidth:538px; status:no; scroll:no; help:no; edge:sunken";
		            feature = feature + GetShowModalPosition(538, 480);
		            if (obj == "tbContentElement1") {
		                sign = tbContentElement1.GetEditorContent();
		                rtnValue = window.showModalDialog("../htm/html_edit.aspx", sign, feature);
		                if (typeof (rtnValue) != "undefined")
		                    tbContentElement1.SetEditorContent(rtnValue);
		            }
		            else if (obj == "tbContentElement2") {
		                sign = tbContentElement2.GetEditorContent();
		                rtnValue = window.showModalDialog("../htm/html_edit.aspx", sign, feature);
		                if (typeof (rtnValue) != "undefined")
		                    tbContentElement2.SetEditorContent(rtnValue);
		            }
		            else if (obj == "tbContentElement3") {
		                sign = tbContentElement3.GetEditorContent();
		                rtnValue = window.showModalDialog("../htm/html_edit.aspx", sign, feature);
		                if (typeof (rtnValue) != "undefined")
		                    tbContentElement3.SetEditorContent(rtnValue);
		            }
		        }
		    }
		    function insert_image(obj) {
		        if (navigator.userAgent.indexOf("MSIE") == -1) {
		            alert("이미지 삽입은 인터넷 익스플로러에서 가능 합니다.");
		            return;
		        }
		        alert("<spring:message code='ezEmail.t280' />");
		        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		        var imgName = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "")
		        var ezUtil = null;
		        if (imgName == "")
		            return;
		
		        var fileName = "";
		
		        try {
		            EzHTTPTrans.AddUploadFile("", "");
		            EzHTTPTrans.AddUploadFile(imgName, "N");
		            var RemotePath = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/environ/mail_save_image.aspx";
		            var nCount = EzHTTPTrans.StartUpload(RemotePath, "/Upload_Personal", "Personal", "", "");
		            var newFileName = new Array();
		            for (var i = 0; i < nCount; i++) {
		                fileName = EzHTTPTrans.GetReturn(i);
		                fileName = fileName.split("/")[1] + "/" + fileName.split("/")[2] + "/" + fileName.split("/")[3];
		                if (fileName.length > 1000) {
		                    alert(imgName + "<spring:message code='ezEmail.t281' />");
		                    return;
		                }
		            }
		        }
		        catch (e) {
		            alert(imgName + "<spring:message code='ezEmail.t282' />" + "\n\n" + e.number + " - " + e.description);
		            return;
		        }
		        var selPosObj = document.getElementById(obj).editor.DOM.selection;
		        if (selPosObj.type.toUpperCase() == "TEXT" || selPosObj.type.toUpperCase() == "NONE") {
		            var rgElem = selPosObj.createRange();
		            rgElem.pasteHTML('<img src="http://' + '${serverName}' + '/' + fileName + '" embedding="1">');
		        }
		    }
		    function NoSign() {
		        for (var i = 1 ; i < 3; i++) {
		            document.getElementById("SigState" + i).checked = false;
		        }
		        if (confirm("저장하시겠습니까 ? ")) {
		            SetSig();
		        }
		    }
		    function removeoniondiv(currnode) {
		        var nextnode = null;
		        if (GetChildNodes(currnode).length == 1 && getFirstChild(currnode).nodeName.toLowerCase() == 'div') {
		            nextnode = getFirstChild(currnode);
		        }
		        if (nextnode == null) {
		            return currnode;
		        }
		        return removeoniondiv(nextnode);
		    }
		    function DocumentComplete() {
		        tbContentElement.SetEditorContent(document.getElementById("_signature1").innerHTML);
		    }
		    function FieldsAvailable() {
		    }
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
		            switch (Tab1_SelectID) {
		                case "1tab1":
		                    document.getElementById("_signature1").innerHTML = tbContentElement.GetEditorContent();
		                    break;
		                case "1tab2":
		                    document.getElementById("_signature2").innerHTML = tbContentElement.GetEditorContent();
		                    break;
		                case "1tab3":
		                    document.getElementById("_signature3").innerHTML = tbContentElement.GetEditorContent();
		                    break;
		            }
		
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
		
		                    if (i == 0) {
		                        document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
		                    }
		
		                }
		            }
		        }
		    }
		
		    function ChangeTab(obj) {
		        var pSelectTab = obj.getAttribute("divname");
		        switch (pSelectTab) {
		            case "MailEnv_div1":
		                tbContentElement.SetEditorContent(document.getElementById("_signature1").innerHTML);
		                break;
		            case "MailEnv_div2":
		                tbContentElement.SetEditorContent(document.getElementById("_signature2").innerHTML);
		                break;
		            case "MailEnv_div3":
		                tbContentElement.SetEditorContent(document.getElementById("_signature3").innerHTML);
		                break;
		        }
		    }
		
		</script>
	</head>

	<body style="margin-left:10px;margin-right:10px;"> 
		<br />
		<h2 class="h2_dot"><spring:message code='ezEmail.t284' /></h2> 
		<h2 class="h2_dot"><spring:message code='ezEmail.t99000062' /> :
		    <span style="padding-left:3px;"><input style="margin:0px;padding:0px;" <c:if test="${signState == '0'}">checked</c:if> type="radio" name="SigState" value="0" onclick="pSigState = 0" id="SigState0"><spring:message code='ezEmail.t99000063' /></span>
		    <span style="padding-left:3px;"><input style="margin:0px;padding:0px;" <c:if test="${signState == '1'}">checked</c:if> type="radio" name="SigState" value="1" onclick="pSigState = 1" id="SigState1"><spring:message code='ezEmail.t826' /></span>
		    <span style="padding-left:3px;"> <input style="margin:0px;padding:0px;" <c:if test="${signState == '2'}">checked</c:if> type="radio" name="SigState" value="2" onclick="pSigState = 2"  id="SigState2"><spring:message code='ezEmail.t827' /></span>
		    <span style="padding-left:3px;"> <input style="margin:0px;padding:0px;" <c:if test="${signState == '3'}">checked</c:if> type="radio" name="SigState" value="3"  onclick="pSigState = 3" id="SigState3"><spring:message code='ezEmail.t828' /></span>
		</h2> 
		    <div class="portlet_tabpart01" style="width:820px">
			    <div class="portlet_tabpart01_top" id="tab1" style="border-bottom:0px">
		                <p id = "MailEnv_sub6"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezEmail.t826' /></span></p>
		                <p id = "MailEnv_sub7"><span divname="MailEnv_div2" id="1tab2"><spring:message code='ezEmail.t827' /></span></p>
		                <p id = "MailEnv_sub8"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezEmail.t828' /></span></p>
			    </div>
		    </div>
		<table id="signtable1" class="content" style="width:780px;height:510px"> 
		  <TR> 
		    <TD style="height:510px;">
				<iframe id="tbContentElement" class="viewbox" src="/ezEmail/mailCKEditor.do" name="tbContentElement" style="padding:0; height:200px; width:100%; overflow:auto;border:none;height:100%"></iframe>
		    </TD> 
		  </TR> 
		</table>
		<div style="width:780px;text-align:center;margin-top:5px;">
		    <%--<a class="imgbtn" onClick="NoSign()"><span><%=RM.GetString("t99000009")%></span></a>--%>
		    <a class="imgbtn" onClick="SetSig()"><span><spring:message code='ezEmail.t48' /></span></a>
		    <a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezEmail.t39' /></span></a>
		</div>
		<xml id="_signature1" style="display: none;">${signature1}</xml>
		<xml id="_signature2" style="display: none;">${signature2}</xml>
		<xml id="_signature3" style="display: none;">${signature3}</xml>
	</body>
	
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</html>



