<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t388'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Tree_View.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/OrganAprline_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprlineV_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprLineTemplet_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SelectSubTitles_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Aprline_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
		<script type="text/javascript" src="/js/NameControl_Cross.js"></script>
		<script ID="clientEventHandlersJS">
		    var OrderCell = "";
		    var pDocID;
		    var pFormID;
		    var pSignCount;
		    var pHapYuiCount;
		    var pGamSaCount;
		    var pReDraftFlag;
		    var pReDraftAprLineChangeFlag = false;
		    var pSuSinFlag;
		    var pChamJoFlag;
		    var pGongramCount;
		    var pReDraftAprLineFlag;
		    var pSuSinReDraftFlag;
		    var pSelAprLineType;
		    var pAprLineAddIndex;
		    var pTotalIndex;
		    var pAprLineXml = new Array();
		    var pAprLineTempletFlag = false;
		    var p_CheckAprLineTempletSN;
		    var pAprLineTempletUIFlag = false;
		    var hotTrackingValue = false;
		    var enableValue = true;
		    var InitTreeVal = "";	
		    var pOrgApruserid;
		    var CompID;
		    var pUserID;
		    var chkReDraft = "";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName1}";
		    arr_userinfo[3]  = "${userInfo.title1}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName1}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[7]  = "N";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var companyID = "${userInfo.companyID}";
		    var GCompanyName = "${userInfo.companyName1}";
		    var tempAprTypeXML = "${aprTypeXML}";
		    var AprTypeXML = createXmlDom();
		    var Resultxml = createXmlDom();
		    var xmlpara   = createXmlDom();
		    var xmlhttp   = createXMLHttpRequest();
		    var optGamsabu = "${optGamsabu}";
		    var chkReporter = false;
		    var chkSuggester = false;
		    var USE_OCS = "${useOcs}";
		    var Udomain = "${userEmail}";
		    var UserLang = "${userInfo.lang}";
		    var InsertMode = "Add";
		    window.onload = function () {
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("textUser"));
		            }
		            AprTypeXML = loadXMLString(tempAprTypeXML);
		            var InitDeptID;
		            var rtnval = new Array();
		            GetDocInfo();
		            if (pReDraftAprLineFlag) {
		                pUserID = pOrgApruserid;
		
		                btn_EditAprLineTemplet.disabled = true;
		                btn_SaveAprLineTemplet.disabled = true;
		                btn_AddToAprLine.disabled = true;
		            }
		            else
		                pUserID = arr_userinfo[1];
		            InitDeptID = arr_userinfo[4];
		            Tree_setconfig();
		            TreeViewinitialize(InitDeptID, companyID, "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayname", "${serverName}");
		            InitListView();
		            InitAprlineTemplet();
		            hideProgress();
		            document.getElementById("ReasonNoAprTxt").disabled = true;
		            document.getElementById("ReasonNoApr").disabled = true;
		            document.getElementById("AprlineType").disabled = true;
		            var treeView = new TreeView();
		            treeView.LoadFromID("FromTreeView");
		            var selnode = treeView.GetSelectNode();
		            DeptID = selnode.GetNodeData("CN");
		            displayUserList(DeptID);
		            rtnval[0] = "cancel";
		            rtnval[1] = "cancel";
		            var pAPRLINE = new ListView();
		            pAPRLINE.LoadFromID("pAPRLINE");
		            var TotalRow = pAPRLINE.GetDataRows();
		            if (TotalRow.length < 1)
		                rtnval[2] = "cancel";
		            else
		                rtnval[2] = "exist";
		            rtnval[3] = "cancel";
		            window.returnValue = rtnval;
		        } catch (e) {
		            alert("window_onload :: " + e.description);
		        }
		        MM_preloadImages('/images/arr_up.gif', '/images/arr_down.gif');
		    };
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		        xmlHTTP.send();
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
		    function AprlineDown_onclick() {
		        APRLINESNDownFunction();
		        OnSelChange_onclick();
		    }
		    function AprlineUpper_onclick() {
		        APRLINESNUPPERFunction();
		        OnSelChange_onclick();
		    }
		    function AprlineDel_onclick() {
		        APRLINEATTENDERDELFunction();
		    }
		    function OnSelChange_onclick() {
		        try {
		            var pAPRLINE = new ListView();
		            pAPRLINE.LoadFromID("pAPRLINE");
		            var pSelectedRow = pAPRLINE.GetSelectedRows();
		            if (pSelectedRow.length > 0) {
		                var p_IsDept = GetAttribute(pSelectedRow[0], "DATA5");
		                document.getElementById("AprlineType").disabled = true;
		                if (p_IsDept == "Y") {
		                    ChangeAprlineType("group");
		                } else if (p_IsDept == "N") {
		                    ChangeAprlineType("user");
		                }
		                OnSelChangeDoEvent(pSelectedRow);
		            }
		        } catch (e) {
		            alert("OnSelChange_onclick :: " + e.description);
		        }
		    }
		    function AprlineType_onchange() {
		        try {
		            var pCheckTypevalue = document.getElementById("AprlineType").value;
		            var Rtnval = true;
		            if (pCheckTypevalue.replace("<spring:message code='ezApprovalG.t22'/>", "") != pCheckTypevalue || pCheckTypevalue.replace("<spring:message code='ezApprovalG.t23'/>", "") != pCheckTypevalue) {
		                if (pHapYuiCount != "0")
		                    Rtnval = CheckHapYuiCellValue();
		            }
		            if (Rtnval)
		                APRLINETYPECHANGEFunction();
		        }
		        catch (e) {
		            alert("AprlineType_onchange :: " + e.description);
		        }
		    }
		    function SaveAprline_onclick() {
		        var rtnVal = CheckSignCellValueLast();
		        if (rtnVal) APRLINEATTENDSAVEFunction();
		    }
		    function CancelAprline_onclick() {
		        var rtnval = new Array();
		        rtnval[0] = "cancel";
		        rtnval[1] = "cancel";
		        var pAPRLINE = new ListView();
		        pAPRLINE.LoadFromID("pAPRLINE");
		        if (pAPRLINE.GetDataRows().length < 1)
		            rtnval[2] = "cancel";
		        else
		            rtnval[2] = "exist";
		        rtnval[3] = "cancel";
		        window.returnValue = rtnval;
		        window.close();
		    }
		    function Suggester_onclick() {
		        try {
		            var pAPRLINE = new ListView();
		            pAPRLINE.LoadFromID("pAPRLINE");
		            var CurSelRow = pAPRLINE.GetSelectedRows();
		            if (CurSelRow.length <= 0) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t389'/>");
		                Suggester.checked = false;
		                return;
		            }
		            if (CurSelRow.length > 0) {
		                var pSelectedRow = pAPRLINE.GetSelectedRows();
		                if (pSelectedRow) {
		                    var RCheckVal = Suggester.checked;
		                    var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
		                }
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t389'/>");
		                Suggester.checked = false;
		                return;
		            }
		            var pTmpAprLineType;
		            pTmpAprLineType = "003";
		            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");
		            if (pSelectedRow.length != 0 && p_CurAprStat != pTmpAprLineType) {
		
		                if (RCheckVal) {
		                    SetAttribute(pSelectedRow[0], "DATA8", "Y");
		                    if (CrossYN()) {
		                        pSelectedRow[0].cells[0].textContent = "★" + pSelectedRow[0].cells[0].textContent;
		                    }
		                    else {
		                        pSelectedRow[0].cells[0].innerText = "★" + pSelectedRow[0].cells[0].innerText;
		                    }
		                    chkSuggester = true;
		                } else {
		                    SetAttribute(pSelectedRow[0], "DATA8", "N");
		                    var rep = /★/g;
		                    if (CrossYN()) {
		                        pSelectedRow[0].cells[0].textContent = pSelectedRow[0].cells[0].textContent.replace(rep, "");
		                    }
		                    else {
		                        pSelectedRow[0].cells[0].innerText = pSelectedRow[0].cells[0].innerText.replace(rep, "");
		                    }
		                    chkSuggester = false;
		                }
		            }
		        } catch (e) {
		            alert("Suggester_onclick :: " + e.description);
		        }
		    }
		    function Reporter_onclick() {
		        try {
		            var pAPRLINE = new ListView();
		            pAPRLINE.LoadFromID("pAPRLINE");
		            var CurSelRow = pAPRLINE.GetSelectedRows();
		            if (CurSelRow.length <= 0) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t390'/>");
		                Reporter.checked = false;
		                return;
		            }
		            if (CurSelRow.length > 0) {
		                var pSelectedRow = pAPRLINE.GetSelectedRows();
		                if (pSelectedRow) {
		                    var RCheckVal = Reporter.checked;
		                    var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
		                }
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t390'/>");
		                Reporter.checked = false;
		                return;
		            }
		            var pTmpAprLineType;
		            pTmpAprLineType = "003";
		            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");
		            if (pSelectedRow.length != 0 && p_CurAprStat != pTmpAprLineType) {
		                if (RCheckVal) {
		                    SetAttribute(pSelectedRow[0], "DATA9", "Y");
		                    if (CrossYN()) {
		                        pSelectedRow[0].cells[0].textContent = "⊙" + pSelectedRow[0].cells[0].textContent;
		                    }
		                    else {
		                        pSelectedRow[0].cells[0].innerText = "⊙" + pSelectedRow[0].cells[0].innerText;
		                    }
		                    chkReporter = true;
		                } else {
		                    SetAttribute(pSelectedRow[0], "DATA9", "N");
		                    var rep = /⊙/g;
		                    if (CrossYN()) {
		                        pSelectedRow[0].cells[0].textContent = pSelectedRow[0].cells[0].textContent.replace(rep, "");
		                    }
		                    else {
		                        pSelectedRow[0].cells[0].innerText = pSelectedRow[0].cells[0].innerText.replace(rep, "");
		                    }
		                    chkReporter = false;
		                }
		            }
		        } catch (e) {
		            alert("Reporter :: " + e.description);
		        }
		    }
		    function AprlineAdd_onclick(pMode) {
		        try {
		
		            var pUserList = new ListView();
		            pUserList.LoadFromID("pUserList");
		            var pCurSelRow = pUserList.GetSelectedRows();
		            var RtnVal;
		            InsertMode = pMode;
		            if (pCurSelRow.length != 0) {
		                RtnVal = CheckSignCellValue();
		                if (RtnVal) {
		                    APRLINEATTENDADDFunction(pCurSelRow, "PERSON");
		                }
		            }
		            else {
		                RtnVal = CheckHapYuiCellValue();
		                if (RtnVal) {
		                    if (GetChildNodes(SelectSingleNodeNew(AprTypeXML, "APRTYPES/DEPTTYPES")).length <= 0) {
		                        OpenAlertUI("<spring:message code='ezApprovalG.t391'/>");
		                        return;
		                    }
		
		                    var treeView = new TreeView();
		                    treeView.LoadFromID("FromTreeView");
		                    var pTreeSelNode = treeView.GetSelectNode();
		                    APRLINEATTENDADDFunction(pTreeSelNode, "DEPT");
		                }
		            }
		        } catch (e) {
		            alert("AprlineAdd_onclick :: " + e.description);
		        }
		    }
		    function ReasonNoApr_onclick() {
		        var tr = APRLINE.multiselects;
		        var checkvalue = document.getElementById("ReasonNoAprTxt").value;
		        if (checkvalue == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t256'/>";
		            OpenAlertUI(pAlertContent);
		            document.getElementById("ReasonNoAprTxt").focus();
		        }
		        else {
		            tr.item(0).cells(0).DATA7 = document.getElementById("ReasonNoAprTxt").value;
		            document.getElementById("ReasonNoAprTxt").disabled = true;
		            document.getElementById("ReasonNoApr").disabled = true;
		        }
		    }
		var g_SelectAprLineTempletName;
		function stl_AprLineTemplet_onchange() {
		    var p_AprLineTempletID = stl_AprLineTemplet.value;
		    g_SelectAprLineTempletName = stl_AprLineTemplet[stl_AprLineTemplet.selectedIndex].innerText;
		    GetAprLineTempletInfo(pUserID, pFormID, p_AprLineTempletID);
		    DelstlAprLineTemplet("<spring:message code='ezApprovalG.t257'/>");
		}
		    function btn_DelAprLineTemplet_onclick() {
		        if (stl_AprLineTemplet.value == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t394'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        var p_SelAprLineTempletSN;
		        var pInformationContent = "<spring:message code='ezApprovalG.t395'/>";
		        var Ans = OpenInformationUI(pInformationContent);
		        if (Ans) {
		            p_SelAprLineTempletSN = stl_AprLineTemplet.value;
		            DelAprLineTempletList(p_SelAprLineTempletSN);
		        }
		    }
		    function btn_SaveAprLineTemplet_onclick() {
		        var pAPRLINE = new ListView();
		        pAPRLINE.LoadFromID("pAPRLINE");
		        var ListViewLen = pAPRLINE.GetDataRows();
		        if (ListViewLen.length != "0") {
		            var windowName = "/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/AprLineTempletName_Cross.aspx";
		            var parameter = "status:no;dialogWidth:340px;dialogHeight:205px;scroll:no;edge:sunken";
		            var dialogValue = new Array();
		            dialogValue[0] = pUserID;
		            dialogValue[1] = pFormID;
		            if (pAprLineTempletFlag) {
		                dialogValue[2] = p_CheckAprLineTempletSN;
		                dialogValue[3] = g_SelectAprLineTempletName;
		
		            } else {
		                dialogValue[2] = "";
		                dialogValue[3] = "";
		            }
		            parameter = parameter + GetShowModalPosition(340, 205);
		            var ret = window.showModalDialog(windowName, dialogValue, parameter);
		            if (ret != "cancel") {
		                CreateNewAprLineTemplet(ret);
		            }
		        } else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t260'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		function btn_EditAprLineTemplet_onclick()
		{
		    var pAPRLINE = new ListView();
		    pAPRLINE.LoadFromID("pAPRLINE");
			var ListViewLen = pAPRLINE.GetDataRows();
			if (stl_AprLineTemplet.value == "")
			{
				var pAlertContent = "<spring:message code='ezApprovalG.t397'/>";
				OpenAlertUI(pAlertContent);
				return;
			}
			if(ListViewLen.length != "0")
			{
				var windowName  = "/myoffice/ezApprovalG/ezAPRLINE/ezAPRTEMPLET/AprLineTempletName_Cross.aspx";
				var parameter   = "status:no;dialogWidth:340px;dialogHeight:205px;scroll:no;edge:sunken;help:no"; 
				var dialogValue = new Array();
				dialogValue[0]  = pUserID;
				dialogValue[1]  = pFormID;
				dialogValue[2]  = stl_AprLineTemplet.item(stl_AprLineTemplet.selectedIndex).innerText;
			    parameter =  parameter + GetShowModalPosition(340, 205);
				var ret = window.showModalDialog(windowName,dialogValue, parameter);
				if(ret != "cancel")
				{
					pAprLineTempletFlag = true;
					p_CheckAprLineTempletSN = stl_AprLineTemplet.value;
					CreateNewAprLineTemplet(ret);
				}
			}else{
				var pAlertContent = "<spring:message code='ezApprovalG.t396'/>";
				OpenAlertUI(pAlertContent);
			}
		}
		    function btn_AddToAprLine_onclick() {
		        p_CheckAprLineTempletSN = stl_AprLineTemplet.value;
		        if (p_CheckAprLineTempletSN == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t398'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (p_CheckAprLineTempletSN == "<spring:message code='ezApprovalG.t393'/>") {
		            p_CheckAprLineTempletSN = "1";
		        }
		        if (pReDraftAprLineFlag) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t399'/>";
		            OpenAlertUI(pAlertContent);
		        }
		        else {
		            AddToAprLineFromAprLineTemplet(p_CheckAprLineTempletSN);
		            pAprLineTempletFlag = true;
		        }
		    }
		    function TreeCtrl_onReqData() {
		        var xmlRtn = createXmlDom();
		        displayMemberTreeReq();
		    }
		    function list2_onSel_Click() {
		    }
		    function list2_onSel_DBclick() {
		        var pUserList = new ListView();
		        pUserList.LoadFromID("pUserList");
		
		        var selnode = pUserList.GetSelectedRows();
		        var RtnVal = CheckSignCellValue();
		        InsertMode = "Add";
		        var pAPRLINE = new ListView();
		        pAPRLINE.LoadFromID("pAPRLINE");
		        var pSelRow = pAPRLINE.GetSelectedRows();
		        if (RtnVal) {
		            APRLINEATTENDADDFunction(selnode, "PERSON");
		        }
		    }
		    function textUser_onkeypress() {
		        if (window.event.keyCode == "13") {
		            if (CrossYN()) {
		                searchUserList();
		                btn_searchUser.focus();
		            }
		            else {
		                btn_searchUser.focus();
		            }
		        }
		    }
		    function btn_searchUser_onclick() {
		        searchUserList();
		    }
		    function searchUserList() {
		        try {
		            var strSearch = textUser.value + "";
		            if (textUser.value == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t226'/>";
		                OpenAlertUI(pAlertContent);
		                TreeViewNodeClick();
		            }
		            else if (strSearch.length < 2) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t227'/>";
		                OpenAlertUI(pAlertContent);
		                textUser.focus();
		            }
		            else {
		                var xmlHTTP = createXMLHttpRequest();
		                var xmlDOM = createXmlDom();
		                var objNode;
		                createNodeInsert(xmlDOM, objNode, "DATA");
		                createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "displayname::" + strSearch + ";;PhysicalDeliveryOfficeName::" + "${userInfo.companyID}");
		                createNodeAndInsertText(xmlDOM, objNode, "CELL", "displayname;Description;Title;extensionAttribute5;telephonenumber");
		                createNodeAndInsertText(xmlDOM, objNode, "PROP", "Department;DisplayName;Description;Title;extensionAttribute4;extensionAttribute5");
		                createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");
		                g_xmlHTTP = createXMLHttpRequest();
		                g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx", true);
		                g_xmlHTTP.onreadystatechange = event_displayUserList;
		                g_xmlHTTP.send(xmlDOM);
		            }
		        } catch (ErrMsg) {
		            alert(ErrMsg.description);
		        }
		    }
		    function MM_swapImgRestore(){
		      var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
		    }
		
		    function MM_preloadImages() {
		      var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		        var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
		    }
		
		    function MM_swapImage() {
		      var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		       if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
		    }
		
		    function TreeViewNodeDbClick() {
		        return;
		    }
		    function TreeViewNodeClick() {
		        var nodeIdx = 1;
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var selnode = treeView.GetSelectNode();
		        DeptID = selnode.GetNodeData("CN");
		        displayUserList(DeptID);
		    }
		
		    function displayUserList(DeptID) {
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
		        createNodeAndInsertText(xmlpara, objNode, "CELL", "displayname;Description;Title;extensionAttribute5;telephonenumber");
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "Department;DisplayName;Description;Title;extensionAttribute4;extensionAttribute5");
		        createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");
		        g_xmlHTTP = createXMLHttpRequest();
		        g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptMemberList.aspx", true);
		        g_xmlHTTP.onreadystatechange = event_displayUserList;
		        g_xmlHTTP.send(xmlpara);
		    }
		    function event_displayUserList() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                var retXml = createXmlDom();
		
		                if (document.getElementById("UserList").innerHTML != "")
		                    document.getElementById("UserList").innerHTML = "";
		                var headerData = createXmlDom();
		                headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
		                if (g_xmlHTTP.responseText != "") {
		                    if (CrossYN()) {
		                        var xmlRtn = g_xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
		                        var Node = headerData.importNode(xmlRtn, true);
		                        headerData.documentElement.appendChild(Node);
		                    }
		                    else {
		                        var xmlRtn = g_xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
		                        headerData.documentElement.appendChild(xmlRtn);
		                    }
		                }
		                var pUserList = new ListView();
		                pUserList.SetID("pUserList");
		                pUserList.SetRowOnClick("list2_onSel_Click");
		                pUserList.SetRowOnDblClick("list2_onSel_DBclick");
		                pUserList.SetSelectFlag(false);
		                pUserList.SetHeightFree(true);
		                pUserList.DataSource(headerData);
		                pUserList.DataBind("UserList");
		                var userRows = pUserList.GetDataRows();
		                if (userRows.length <= 0) {
		                    return;
		                }
		                else if (USE_OCS.toUpperCase() == "YES") {
		                }
		            }
		            else
		                OpenAlertUI("<spring:message code='ezApprovalG.t228'/>" + g_xmlHTTP.statusText);
		
		            g_xmlHTTP = null;
		        }
		    }
		    function check_presence() {
		        var pUserList = new ListView();
		        pUserList.LoadFromID("pUserList");
		        var userRows = pUserList.GetDataRows();
		        try {
		            var pCNList = new Array();
		            for (var i = 0; i < userRows.length ; i++) {
		                var tr = userRows[i];
		                var userid = GetAttribute(tr, "DATA2");
		                pCNList[i] = userid;
		            }
		            var pSIPUriList = getSIPUri(pCNList.join(';').toString(), "").split(';');
		            pCNList = null;
		            for (var i = 0; i < userRows.length ; i++) {
		                var tr = userRows[i];
		                tr.cells[0].innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + GetGUID() + ",type=smtp'  onload='PresenceControl(\"" + pSIPUriList[i] + "\", this);'/>" + tr.cells[0].innerHTML + "</span>";
		            }
		            pSIPUriList = null;
		        }
		        catch (e) { alert("ERROR on check_presence " + e.description); }
		    }
		    function MM_findObj(n, d) {
		        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
		            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
		        }
		        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
		        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
		        if (!x && d.getElementById) x = d.getElementById(n); return x;
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="userlist_h" style="display:none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t401'/></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t249'/></NAME>
		        <WIDTH>80</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t402'/></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t1789'/></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t231'/></NAME>
		        <WIDTH>90</WIDTH>
		      </HEADER>
		    </HEADERS>
		    <ROWS></ROWS>
		  </LISTVIEWDATA>
		</xml>
		<OBJECT classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="behavelist1" style="HEIGHT: 0px; WIDTH: 0px;display:none">
		</OBJECT>
		
		<h1><spring:message code='ezApprovalG.t388'/></h1>
		<table style="margin-top:-20px;" >
		  <tr>
		    <td valign="top"><table>
		        <tr>
		          <td valign="top" ><h2 style="margin-top:10px" ><spring:message code='ezApprovalG.t232'/></h2><div class="listview" style="margin-top:5px;overflow-x:auto;overflow-y:auto;height:280px;width:280px;border:1px solid #b6b6b6;">
		            <div id ="TreeView"></div></div></td>
		        </tr>
		        <tr style="height:2px;">
		            <td></td>
		        </tr>
		        <tr>
		          <td style="border:1px solid #b6b6b6;"><div class="listview" style="overflow:auto;border:0;Width:280px; Height:236px;"><%--<DIV id="UserList" style="BEHAVIOR: url(#behavelist1#ListView); border:0;Width:280px; Height:215px" onrowdblclick="list2_onSel_DBclick()" onselchanged="list2_onSel_Click()"></DIV>--%>
		          <DIV id="UserList" style="border:0;Width:370px; Height:215px;margin:1px 1px 1px 1px;"></DIV>
		          </div></td>
		        </tr>
		      </table>
		    </td>
		    <td width="30" align="center">
		    <img id="AprlineUpper" name="Image12" alt="<spring:message code='ezApprovalG.t403'/>" border="0" style="cursor:pointer" language="javascript" onClick="return AprlineUpper_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image12','','/images/arr_up.gif',1)" src="/images/arr_up.gif" width="16" height="16" hspace="3" vspace="2"> <br />
		    <img id="AprlineDown" name="Image13" alt="<spring:message code='ezApprovalG.t404'/>" border="0" style="cursor:pointer" language="javascript" onClick="return	AprlineDown_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image13','','/images/arr_down.gif',1)" src="/images/arr_down.gif" width="16" height="16" > 
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>
		      <br>      
		      <%--<IMG id="AprlineEdit" name="Image9" language="javascript" onClick="return AprlineAdd_onclick('Edit')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image9','','/images/arr_both.gif',1)" src="/images/arr_both.gif" title="" style="cursor:pointer" width="16" height="16" hspace="3" vspace="2" > --%>
		      <IMG id="AprlineAdd" name="Image10" alt="<spring:message code='ezApprovalG.t405'/>" style="cursor:pointer" language="javascript" onClick="return AprlineAdd_onclick('Add')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','/images/arr_right.gif',1)" src="/images/arr_right.gif" width="16" height="16" hspace="3" vspace="2">
		      <IMG id="AprlineDel" name="Image11" alt="<spring:message code='ezApprovalG.t406'/>" border="0" style="CURSOR: hand" language="javascript" onClick="return	AprlineDel_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image11','','/images/arr_left.gif',1)" src="/images/arr_left.gif" width="16" height="16" hspace="3" vspace="2"> </td>
		    <td align="center" valign="top"><table>
		        <tr>
		          <td valign="top" ><h2 style="margin-top:10px" ><spring:message code='ezApprovalG.t407'/></h2><%--<div class="listview">--%>
		          <div class="listview" style="margin-top:5px; Width:447px;Height:470;">
		            <%--<DIV id="APRLINE" style="BEHAVIOR: url(#behavelist1#ListView); 
												border:0px;Width:405px; Height:470px;" LANGUAGE="javascript" OnSelChanged="return OnSelChange_onclick()" onRowDblClick="return AprlineDel_onclick();"></DIV></div></td>--%>
					<DIV id="APRLINE" style="overflow:auto;border:0px;Width:445px; Height:470px;margin:1px 1px 1px 1px;"></DIV></div></td>
		        </tr>
		      </table>
		      <table  class="content" style="margin-top:5px; width:100%;">
		        <tr>
		          <th height="25" nowrap><spring:message code='ezApprovalG.t408'/></th>
		          <td><select id="AprlineType" name="AprlineType" style="WIDTH: 200px" language="javascript" onChange="return AprlineType_onchange()">
		            </select></td>
		        </tr>
		        <TR>
		          <td colspan="2" align=center style="margin-top:3px" ><input type="checkbox" name="Reporter" id="Reporter" value ="checkbox" LANGUAGE="javascript" onClick="return Reporter_onclick()" style="height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;">
		            <span><spring:message code='ezApprovalG.t409'/></span>
		            <input type="checkbox" id ="Suggester" name="Suggester" value="checkbox" language="javascript" onClick="return Suggester_onclick()" style="height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;">
		            <span><spring:message code='ezApprovalG.t410'/></span>
		            </td>
		        </TR>
		        <tr style="display:none">
		          <th><spring:message code='ezApprovalG.t411'/></th>
		          <td><table>
		              <tr>
		                <td><input id="ReasonNoAprTxt" name="ReasonNoAprTxt" type="text" style="width:100%">
		                </td>
		                <td align="right" width="55"><a  class="imgbtn"><span  id="ReasonNoApr" onClick="return ReasonNoApr_onclick()" style="width:40px" ><spring:message code='ezApprovalG.t336'/></span></a></td>
		              </tr>
		            </table></td>
		        </tr>
		      </table></td>
		    <td valign="top" style="" ><table style="margin-left:5px; margin-top:5px;">
		        <tr>
		          <td height="20" style="background-color:#f3f3f3; padding:4px 0 3px 0;"><a  class="imgbtn"><span id="btn_AddToAprLine" onClick="return btn_AddToAprLine_onclick()"  ><spring:message code='ezApprovalG.t336'/></span></a>
		          <select id="stl_AprLineTemplet"  LANGUAGE="javascript" style="width:73%;height:20px;" onChange="return stl_AprLineTemplet_onchange()"></select></td>
		        </tr>
		        <tr>
		          <td valign="top"><div class="listview" style="margin-top:5px; _margin-top:0px;">
		          <div id="APRTEMP" style="overflow:auto;border:0;Width:200px; Height:520px;margin:1px 1px 1px 1px;"></div>
		          <%--<DIV id="APRTEMP" style="BEHAVIOR: url(#behavelist1#ListView); 
												border:0;Width:200px; Height:500px;"></DIV>--%></div></td>
		        </tr>
		      </table></td>
		  </tr>
		  <tr style="height:30px;">
		    <td style="padding-left:5px;">
		            <input id="textUser" class="text" style="width:180px" name="textUser" onKeyPress="return textUser_onkeypress()" tabindex="1" maxlength="50">
		            <input id="btn_searchUser" type=button name="btn_searchUser" onKeyPress="return textUser_onkeypress()" onClick="return btn_searchUser_onclick()" tabindex="1" value="<spring:message code='ezApprovalG.t234'/>"  class="imginput" style="">
		    </td>
		    <td>&nbsp;</td>
		    <td align="center">
		
		    </td>
		    <td align="center">
		            <a  class="imgbtn"><span id="btn_SaveAprLineTemplet" onClick="return btn_SaveAprLineTemplet_onclick()"><spring:message code='ezApprovalG.t412'/></span></a><a  class="imgbtn"><span id="btn_EditAprLineTemplet" onClick="return btn_EditAprLineTemplet_onclick()" style="width:40px" ><spring:message code='ezApprovalG.t269'/></span></a><a  class="imgbtn"><span id="btn_DelAprLineTemplet" onClick="return btn_DelAprLineTemplet_onclick()" style="width:40px" ><spring:message code='ezApprovalG.t266'/></span></a>
		    </td>
		  </tr>
		  <tr>
		    <td colspan="4" align="right">
		          <a class="imgbtn" ><span id="SaveAprline" name="SaveAprline" onClick="return SaveAprline_onclick()"><spring:message code='ezApprovalG.t413'/></span></a>
		         <a class="imgbtn" style="margin-right:20px;"><span id="CancelAprline" name="CancelAprline" onClick="return CancelAprline_onclick()"><spring:message code='ezApprovalG.t414'/></span></a>
		    </td>
		  </tr>
		</table>
		
		<div class="btnposition" >
		
		  <%--<input id="SaveAprline" name="SaveAprline" type="submit" value="<%=RM.GetString("t413")%>" onClick="return SaveAprline_onclick()" >
		  <input id="CancelAprline" name="CancelAprline" type="submit" value="<%=RM.GetString("t414")%>" onClick="return CancelAprline_onclick()">--%>
		</div>
	</body>
</html>