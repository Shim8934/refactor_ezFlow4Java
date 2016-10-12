<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t9997'/></title>
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		    var cnt = "${cnt}";
		    var arr_userinfo = new Array();
		    arr_userinfo[0] = "user"; 							
		    arr_userinfo[1] = "${userInfo.id}";              
		    arr_userinfo[2] = "${userInfo.displayName}";         
		    arr_userinfo[3] = "${userInfo.title}";               
		    arr_userinfo[4] = "${userInfo.deptID}";              
		    arr_userinfo[5] = "${userInfo.deptName}";            
		    arr_userinfo[6] = "${userInfo.jikChek}";                         
		    arr_userinfo[7] = "N";
		    arr_userinfo[8] = "${userInfo.email}";               
		    arr_userinfo[9] = "";
		    arr_userinfo[10] = "";
		    var pCompanyID = "${userInfo.companyID}";
		    var NonActiveX = "YES";
		    var ezchkpasswd_all_cross_dialogArguments = new Array();
		    function chk_Passwd(pPwd) {
		        var parameter = pPwd;
		
		        ezchkpasswd_all_cross_dialogArguments[0] = parameter;
		        ezchkpasswd_all_cross_dialogArguments[1] = chk_Passwd_Complete;
		
		        DivPopUpShow(330, 200, "/ezApprovalG/ezchkPasswdall.do");
		    }
		    function chk_Passwd_Complete(chkpass) {
		        if (chkpass == "False") {
		            var pAlertContent = strLang581;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = strLang582;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        setpause(500);
		        var xmlpara = createXmlDom();
		        var objRoot, objNode, doc, objNode2, objNodes, objDocinfoNode;
		        objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "USERID", arr_userinfo[1]);
		        createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME", arr_userinfo[2]);
		        createNodeAndInsertText(xmlpara, objNode, "TITLE", arr_userinfo[3]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
		        createNodeAndInsertText(xmlpara, objNode, "JIKCHEK", arr_userinfo[6]);
		        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", pCompanyID);
		        createNodeAndInsertText(xmlpara, objNode, "PASSWD", "");
		        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", "${userInfo.lang}");
		        var list = createNodeAndAppandNode(xmlpara, objRoot, list, "DOCIDS");
		        if (parseInt(cnt) > 1) {
		            for (var i = 0; i < parseInt(cnt) ; i++) {
		                if (eval(document.frm.chk[i]).checked) {
		                    doc = createNodeAndAppandNode(xmlpara, list, doc, "DOC");
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCID", document.frm.chk[i].value.split("|")[0]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGAPRUSERID", document.frm.chk[i].value.split("|")[1]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FORMID", document.frm.chk[i].value.split("|")[2]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TYPE", document.frm.chk[i].value.split("|")[3]);
		                }
		            }
		        }
		        else {
		            if (eval(document.frm.chk).checked) {
		                doc = createNodeAndAppandNode(xmlpara, list, doc, "DOC");
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCID", document.frm.chk.value.split("|")[0]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGAPRUSERID", document.frm.chk.value.split("|")[1]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FORMID", document.frm.chk.value.split("|")[2]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TYPE", document.frm.chk[i].value.split("|")[3]);
		            }
		        }
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezApprovalG/doApprovAllG.do", false);
		        xmlhttp.send(xmlpara);
		        var RtnVal = xmlhttp.responseText;
		        var arrRtnVal = new Array();
		        arrRtnVal[0] = RtnVal.split("/")[0];
		        arrRtnVal[1] = RtnVal.split("/")[1];
		        arrRtnVal[2] = RtnVal.split("/")[2];
		        arrRtnVal[3] = RtnVal.split("/")[3];
		        if (arrRtnVal[0] == "OK") {
		            hideProgress();
		            pAlertContent = strLang933 + arrRtnVal[1] + strLang934;
		            pAlertContent += strLang935 + arrRtnVal[2] + strLang934;
		            if (arrRtnVal[3] != 0)
		                pAlertContent += strLang936 + arrRtnVal[3] + strLang934;
		            pAlertContent += strLang931;
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        }
		        else {
		            hideProgress();
		            pAlertContent = strLang932;
		            pAlertContent += arrRtnVal[1];
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function OpenAlertUI_Close() {
		        btnClose_onclick();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
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
		    function checkAll(obj) {
		        if (document.getElementById(obj).checked) {
		            if (parseInt(cnt) > 1) {
		                for (var i = 0; i < parseInt(cnt) ; i++) {
		                    eval(document.frm.chk[i]).checked = true;
		                }
		            }
		            else if (parseInt(cnt) == 1) {
		                eval(document.frm.chk).checked = true;
		            }
		        }
		        else {
		            if (parseInt(cnt) > 1) {
		                for (var i = 0; i < parseInt(cnt) ; i++) {
		                    eval(document.frm.chk[i]).checked = false;
		                }
		            }
		            else if (parseInt(cnt) == 1) {
		                eval(document.frm.chk).checked = false;
		            }
		        }
		
		    }
		    function btnApprove_onclick() {
		        if (parseInt(cnt) == 0) {
		            var pAlertContent = strLang937;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (parseInt(cnt) > 1) {
		            var j = 0;
		            for (var i = 0; i < parseInt(cnt) ; i++) {
		                if (eval(document.frm.chk[i]).checked)
		                    j++;
		            }
		            if (j == 0) {
		                var pAlertContent = strLang930;
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        else {
		            if (!document.frm.chk.checked) {
		                var pAlertContent = strLang930;
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        if ("${approvalPWD}" != "N") {
		            chk_Passwd(arr_userinfo[1]);
		            return;
		        }
		        else {
		            chk_Passwd_Complete("true");
		        }
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    var g_progresswin = null;
		    function showProgress() {
		    }
		    function hideProgress() {
		        try {
		            if (g_progresswin)
		                g_progresswin.close();
		        }
		        catch (e) { }
		    }
		    function setpause(numberMillis) {
		        var now = new Date();
		        var exitTime = now.getTime() + numberMillis;
		        while (true) {
		            now = new Date();
		            if (now.getTime() > exitTime)
		                return;
		        }
		    }
		    window.onbeforeunload = function () {
		        try {
		            parent.ALLapproval_afterCall();
		        }
		        catch (e) {
		            opener.ALLapproval_afterCall();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<form name="frm">
		    <h1><spring:message code='ezApprovalG.t9997'/></h1>
		    <table >
		        <tr>
		            <td >                
		                <div id="close">
		                    <ul>
		                        <li id="btnApprove"><span onClick="return btnApprove_onclick('003')" ><spring:message code='ezApprovalG.t1'/></span></li>
		                        <li id="btnClose" ><span onClick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
		                    </ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td style="height:20px;vertical-align:middle;"><spring:message code='ezApprovalG.t9998'/></td>
		        </tr>
		        <tr>
		            <td  style="padding-bottom:10px;text-align:center;">
		                <div style="OVERFLOW-Y:AUTO;HEIGHT:280px;">
		                    <table class="mainlist" >
		                        <tr >
		                            <th style="padding:0;text-align:center;width:20px;"><input type="checkbox" id="mainChk" onclick="checkAll(this.id)" /></th>
		                            <th style="width:240px;"><spring:message code='ezApprovalG.t106'/></th>
		                            <th style="width:100px;"><spring:message code='ezApprovalG.t1331'/></th>
		                            <th style="width:80px;"><spring:message code='ezApprovalG.t445'/></th>
		                            <th ><spring:message code='ezApprovalG.t9996'/></th>
		                        </tr>
		                        ${sbStr}
		                    </table>
		                </div>
		            </td>
		        </tr>
		    </table>
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		     <script type="text/javascript">
		         selToggleList(document.getElementById("close"), "ul", "li", "0");
		    </script>
		</form>
	</body>
</html>