<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t1681'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
   		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/escapenew.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TabMenu.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/AprGongRamLine_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/SelectSubTitles_Cross.js"></script>
	    <script type="text/javascript">
		    var pDocID;
		    var OrderCell = "";
		    var pUserID = "${userInfo.id}";
		    var DeptID;
		    var pGongRamDocID;
		    var arr_userinfo = new Array();
		    arr_userinfo[0] = "user";
		    arr_userinfo[1] = "${userInfo.id}";
		    arr_userinfo[2] = "${userInfo.displayName}";
		    arr_userinfo[3] = "${userInfo.title}";
		    arr_userinfo[4] = "${userInfo.deptID}";
		    arr_userinfo[5] = "${userInfo.deptName}";
		    arr_userinfo[6] = "${userInfo.jikChek}";
		    arr_userinfo[8] = "${userInfo.email}";
		    arr_userinfo[11] = "${userInfo.displayName1}";
		    arr_userinfo[12] = "${userInfo.displayName2}";
		    arr_userinfo[13] = "${userInfo.title1}";
		    arr_userinfo[14] = "${userInfo.title2}";
		    arr_userinfo[15] = "${userInfo.deptName1}";
		    arr_userinfo[16] = "${userInfo.deptName2}";
		    var companyID = "${userInfo.companyID}";
		    var type = "${type}";
		    var RetValue;
		    var ReturnFunction;
	        var listveiwHeader1 = "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezApprovalG.t401'/></NAME><WIDTH>50</WIDTH></HEADER><HEADER><NAME><spring:message code='ezApprovalG.t249'/></NAME><WIDTH>80</WIDTH></HEADER><HEADER><NAME><spring:message code='ezApprovalG.t402'/></NAME><WIDTH>60</WIDTH></HEADER><HEADER><NAME><spring:message code='ezApprovalG.t231'/></NAME><WIDTH>100</WIDTH></HEADER></HEADERS><ROWS></ROWS></LISTVIEWDATA>";
	        var pFormID = "ZZZZZZZZ";
	        var linealt1 = "<spring:message code='ezApprovalG.t1742'/>";
	        var linealt2 = "<spring:message code='ezApprovalG.t228'/>";
	        var linealt3 = "<spring:message code='ezApprovalG.t226'/>";
	        var linealt4 = "<spring:message code='ezApprovalG.t227'/>";
	        var linealt5 = "<spring:message code='ezApprovalG.t396'/>";
	        var linealt6 = "<spring:message code='ezApprovalG.t394'/>";
	        var linealt7 = "<spring:message code='ezApprovalG.t395'/>";
	        var linealt8 = "<spring:message code='ezApprovalG.t396'/>";
	        var linealt9 = "<spring:message code='ezApprovalG.t393'/>";
	        var linealt10 = "<spring:message code='ezApprovalG.t399'/>";
	        var linealt11 = "<spring:message code='ezApprovalG.t400'/>";
	        var linealt12 = "<spring:message code='ezApprovalG.t228'/>";
	        var linealt13 = "<spring:message code='ezApprovalG.t2001'/>";
	        var linealt14 = "<spring:message code='ezApprovalG.t322'/>";
	        var linealt15 = "<spring:message code='ezApprovalG.t323'/>";
	        var linealt16 = "<spring:message code='ezApprovalG.t324'/>";
	        var linealt17 = "<spring:message code='ezApprovalG.t1178'/>";
	        var Cabinet1 = "<spring:message code='ezApprovalG.t379'/>";
	        var Cabinet2 = "<spring:message code='ezApprovalG.t572'/>";
	        var Cabinet3 = "<spring:message code='ezApprovalG.t573'/>";
	        var Cabinet4 = "<spring:message code='ezApprovalG.t1081'/>";
	        var Cabinet5 = "<spring:message code='ezApprovalG.t1065'/>";
	        var Cabinet6 = "<spring:message code='ezApprovalG.t1160'/>";
	        var Docalt1 = "<spring:message code='ezApprovalG.t1202'/>";
	        var Docalt2 = "<spring:message code='ezApprovalG.t288'/>";
	        var Docalt3 = "<spring:message code='ezApprovalG.t289'/>";
	        var Docalt4 = "<spring:message code='ezApprovalG.t10030'/>";
	   		window.onload = function () {
        	try {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("textUser"));
	            }
	            try {
	                    RetValue = opener.aprgongramline_cross_dialogArguments[0];
	                    ReturnFunction = opener.aprgongramline_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.aprgongramline_cross_dialogArguments[0];
	                    ReturnFunction = opener.aprgongramline_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            pDocID = RetValue[0];
	
	            getGongRamDocInfo();
	
	            var InitDeptID;
	            InitDeptID = arr_userinfo[4];
	
	            Tree_setconfig();
	
	            TreeViewinitialize(InitDeptID, "${userInfo.companyID}", "extensionAttribute2;extensionAttribute3", "${serverName}");
	
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	
                var UserListViewHeader = loadXMLString(listveiwHeader1);
	
	            var listview = new ListView();
	            listview.SetID("DivUserList");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("list2_onSel_Click");
	            listview.SetRowOnDblClick("list2_onSel_DBclick");
	            listview.SetSelectFlag(false);
                listview.DataSource(UserListViewHeader);
	            listview.DataBind("UserList");
	
	            var selnode = treeView.GetSelectNode();
	            DeptID = selnode.GetNodeData("CN");
	
	            displayUserList(DeptID);
	
	            InitListView();
	        }
	        catch (e) {
	            alert("window_onload :: " + e.description);
	        }
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
	    function TreeViewinitialize(targetDeptID, TopDeptID, tProperty, ServerName) {
	        try {
	
	            var xmlpara = createXmlDom();
	            var xmlHTTP = createXMLHttpRequest();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", targetDeptID);
	            createNodeAndInsertText(xmlpara, objNode, "TOPID", TopDeptID);
	            createNodeAndInsertText(xmlpara, objNode, "PROP", tProperty);
	
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	
	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLString(xmlHTTP.responseText);
	
	            document.getElementById('TreeView').innerHTML = "";
	            var treeView = new TreeView();
	            treeView.SetID("FromTreeView");
	            treeView.SetRequestData("RequestData");
	            treeView.SetNodeClick("TreeViewNodeClick");
	            treeView.SetNodeDblClick("TreeViewNodeDbClick");
	            treeView.DataSource(xmlDom);
	            treeView.DataBind("TreeView");
	
	        } catch (ErrMsg) {
	            alert(" TreeViewinitialize : " + ErrMsg.description);
	        }
	    }
	    function list2_onSel_DBclick() {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("DivUserList");
	
	            var selnode = listview.GetSelectedRows();
	            APRLINEATTENDADDFunction(selnode[0], "PERSON");
	        }
	        catch (e) {
	            alert("list2_onSel_DBclick :: " + e.description);
	        }
	    }
	    function list2_onSel_Click() {
	    }
	    function textUser_onkeypress() {
	        if (window.event.keyCode == "13") {
	            searchUserList();
	            btn_searchUser.focus();
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
	                TreeViewNodeClick()
	            }
	            else if (strSearch.length < 2) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t227'/>";
	                    OpenAlertUI(pAlertContent);
	                    textUser.focus();
	                }
	                else {
	                	$.ajax({
	                		type : "POST",
	                		dataType : "text",
	                		async : true,
	                		url : "/ezOrgan/getSearchList.do",
	                		data : {
	                			search : "displayName::" + strSearch,
	                			cell   : "displayName;description;title;telephonenumber",
	                			prop   : "department;extensionAttribute4;displayname;description;title",
	                			type   : "user"
	                		},
	                		success: function(xml){
	                			event_displayUserList(loadXMLString(xml));
	                		}        			
	                	});
	                }
	        }
	        catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	    function SaveAprline_onclick() {
	        var pAlertContent = "";
	        var ret = CheckAprline();
	        if (ret == -1) {
	            pAlertContent = "<spring:message code='ezApprovalG.t1682'/>";
	            OpenAlertUI(pAlertContent);
	            return;
	        }
	        else if (ret == 0) {
	            pAlertContent = "<spring:message code='ezApprovalG.t1683'/><br> <spring:message code='ezApprovalG.t1684'/>";
	            OpenAlertUI(pAlertContent);
	            return;
	        }
	        else if (ret == 1) {
	            pAlertContent = "<spring:message code='ezApprovalG.t1685'/><br>";
	        }
	
	        pAlertContent += "<spring:message code='ezApprovalG.t1686'/>";
	
	        OpenInformationUI(pAlertContent, SaveAprline_onclick_Complete);
	        try {
	
	        } catch (e) {
	
	        }
	    }
	    function SaveAprline_onclick_Complete(ret) {
	        DivPopUpHidden();
	        if (ret)
	            APRLINEATTENDSAVEFunction();
	    }
	    function CheckAprline() {
	        var listview = new ListView();
	        listview.LoadFromID("pAPRLINE");
	
	        var objRows = listview.GetDataRows();
	        var totCnt = objRows.length;
	        var newCnt = 0;
	
	        for (var i = 0 ; i < totCnt ; i++) {
	            if (GetAttribute(objRows[i], "DATA12") == "001") {
	                newCnt++;
	            }
	        }
	        var beforeCnt = totCnt - newCnt;
	
	        if (totCnt == 0)
	            return -1;
	        else if (beforeCnt == totCnt)
	            return 0;
	        else if (beforeCnt != 0 && beforeCnt < totCnt)
	            return 1;
	        else
	            return 2;
	    }
	    function CancelAprline_onclick() {
	        if (ReturnFunction != null)
	            ReturnFunction("cancel");
	        window.close();
	    }
	    function AprlineDown_onclick() {
	        APRLINESNDownFunction();
	    }
	    function AprlineUpper_onclick() {
	        APRLINESNUPPERFunction();
	    }
	    function AprlineAdd_onclick() {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("DivUserList");
	
	            var pSelectedRow = listview.GetSelectedRows();
	            if (pSelectedRow.length != "0") {
	                APRLINEATTENDADDFunction(pSelectedRow[0], "PERSON");
	            }
	            else {
	                var pAlertContent = "<spring:message code='ezApprovalG.t1688'/>";
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        catch (e) {
	            alert("AprlineAdd :: " + e.description);
	        }
	    }
	    function AprlineDel_onclick() {
	        APRLINEATTENDERDELFunction();
	    }
	    function MM_swapImgRestore() {
	        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
	    }
	    function MM_preloadImages() {
	        var d = document; if (d.images) {
	            if (!d.MM_p) d.MM_p = new Array();
	            var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
	                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
	        }
	    }
	    function MM_findObj(n, d) {
	        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
	            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
	        }
	        if (!(x = d[n]) && d.all) x = d.all[n];
	        for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
	        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
	        return x;
	    }
	    function MM_swapImage() {
	        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
	            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
	    }
	    function ChangeReceptTab(_OBJ) {
	        try {
	            if (_OBJ.getAttribute("divname") == "Organ") {
	                document.getElementById("Organ").style.display = "";
	                document.getElementById("AddUser").style.display = "";
	                document.getElementById("ReceptTemp").style.display = "none";
	            } else if (_OBJ.getAttribute("divname") == "Save") {
	                document.getElementById("Organ").style.display = "none";
	                document.getElementById("AddUser").style.display = "none";
	                document.getElementById("ReceptTemp").style.display = "";
	                GetReceptTempletList();
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_ChangeReceptTab::" + e.description);
	        }
	    }
	    var xmlhttp;
	    function GetReceptTempletList() {
	        try {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : true,
	        		url : "/ezApprovalG/getLineTemplist.do",
	        		data : {
	        				userID 	 : pUserID,
	        				formID   : pFormID
	        				},
	        		success: function(text){
	        			event_GetReceptTempletList(text);
	        		}        			
	        	});
	        	
	        } catch (e) {
	            alert("AprGongRamLine_Cross_GetReceptTempletList::" + e.description);
	        }
	    }
	    function event_GetReceptTempletList(result) {
	        try {
	            if (document.getElementById("RecSaveList").innerHTML != "") document.getElementById("RecSaveList").innerHTML = "";
	            var liveView = new ListView();
	            liveView.SetID("lvRecSaveList");
	            liveView.SetRowOnClick("lvRecSaveList_onSel_Click");
	            liveView.SetSelectFlag(true);
	            liveView.SetHeightFree(true);
	            liveView.DataSource(loadXMLString(result));
	            liveView.DataBind("RecSaveList");
	
	            var pCurSelRow = liveView.GetSelectedRows();
	            if (pCurSelRow.length != 0) {
	                GetReceptTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
	            }
	            else {
	                document.getElementById("RecSaveDetail").innerHTML = "";
	            }
	            xmlhttp = null;
	        }
	        catch (e) {
	            alert("AprGongRamLine_Cross_event_GetReceptTempletList::" + e.description);
	        }
	    }
	    function lvRecSaveList_onSel_Click() {
	        try {
	            var liveView = new ListView();
	            liveView.SetID("lvRecSaveList");
	            var pCurSelRow = liveView.GetSelectedRows();
	            if (pCurSelRow.length != 0) {
	                GetReceptTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_lvRecSaveList_onSel_Click::" + e.description);
	        }
	    }
	    var xmlHTTP;
	    function GetReceptTempletInfo(p_AprLineTempletID) {
	        try {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : true,
	        		url : "/ezApprovalG/aprLineTempletListInfo.do",
	        		data : {
	        				userID 	 : pUserID,
	        				formID   : pFormID,
	        				aprLineSN: p_AprLineTempletID
	        				},
	        		success: function(text){
	        			event_GetReceptTempletInfo(text);
	        		}        			
	        	});
	        } catch (e) {
	            alert("AprGongRamLine_Cross_GetReceptTempletInfo::" + e.description);
	        }
	    }
	    function event_GetReceptTempletInfo(result) {
	        try {
	            if (document.getElementById("RecSaveDetail").innerHTML != "")
	                document.getElementById("RecSaveDetail").innerHTML = "";
	            var pAPRTEMP = new ListView();
	            pAPRTEMP.SetID("lvRecSaveDetail");
	            pAPRTEMP.SetMulSelectable(false);
	            pAPRTEMP.SetHeightFree(true);
	            pAPRTEMP.SetSelectFlag(false);
	            pAPRTEMP.DataSource(loadXMLString(result));
	            pAPRTEMP.DataBind("RecSaveDetail");
	            xmlHTTP = null;
	        }
	        catch (e) {
	            alert("AprGongRamLine_Cross_event_GetReceptTempletInfo::" + e.description);
	        }
	    }
	    function btn_AprDeptTempletAdd_onclick() {
	        try {
	            var p_CheckAprDeptTempletSN;
	            var pAPRTemplist = new ListView();
	            pAPRTemplist.LoadFromID("lvRecSaveList");
	            var ListViewLen = pAPRTemplist.GetSelectedRows();
	
	            if (ListViewLen.length < 1) {
	                return;
	            }
	
	            p_CheckAprDeptTempletSN = ListViewLen[0].getAttribute("DATA1");
	            if (p_CheckAprDeptTempletSN == "") {
	                var pAlertContent = linealt14;
	                OpenAlertUI(pAlertContent);
	            }
	            else {
	                AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN);
	                pAprDeptTempletUseFlag = false;
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_btn_AprDeptTempletAdd_onclick::" + e.description);
	        }
	    }
	    var temp_CheckAprDeptTempletSN;
	    function btn_AprDeptTempletDel_onclick() {
	        try {
	            var p_CheckAprDeptTempletSN;
	            var pAPRTemplist = new ListView();
	            pAPRTemplist.LoadFromID("lvRecSaveList");
	            var ListViewLen = pAPRTemplist.GetSelectedRows();
	
	            if (ListViewLen.length < 1) {
	                var pAlertContent = linealt15;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	
	            p_CheckAprDeptTempletSN = ListViewLen[0].getAttribute("DATA1");
	
	            if (p_CheckAprDeptTempletSN == "") {
	                var pAlertContent = linealt15;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            temp_CheckAprDeptTempletSN;
	            temp_CheckAprDeptTempletSN = p_CheckAprDeptTempletSN;
	            var pInformationContent = linealt16;
	            var Ans = OpenInformationUI(pInformationContent, btn_AprDeptTempletDel_onclick_Complete);
	            if (!CrossYN() && Ans) {
	                DelAprDeptTempletList(pUserID, pFormID, p_CheckAprDeptTempletSN);
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_btn_AprDeptTempletDel_onclick::" + e.description);
	        }
	    }
	
	    function btn_AprDeptTempletDel_onclick_Complete() {
	        DivPopUpHidden();
	        DelAprDeptTempletList(pUserID, pFormID, temp_CheckAprDeptTempletSN);
	    }
	    function DelAprDeptTempletList(pUserID, pFormID, p_SelAprDeptTempletSN) {
	        try {
	        	var result = "";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/delAprLineTempletList.do",
	        		data : {
	        				userID 	 : pUserID,
	        				formID   : pFormID,
	        				aprLineSN: p_SelAprLineTempletSN
	        				},
	        		success: function(xml){
	        			result = loadXMLString(xml);
	        		}        			
	        	});
	        	
	            var dataNodes = GetChildNodes(result);
	            var RtnVal = getNodeText(dataNodes[0]);
	
	            if (RtnVal == "TRUE") {
	                GetReceptTempletList();
	            }
	            else {
	                var parameter = strLang163 + "<br> " + strLang164;
	                OpenAlertUI(parameter);
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_DelAprDeptTempletList::" + e.description);
	        }
	    }
	    function btn_AprDeptTempletAdd_onclick() {
	        try {
	            var p_CheckAprDeptTempletSN;
	            var pAPRTemplist = new ListView();
	            pAPRTemplist.LoadFromID("lvRecSaveList");
	            var ListViewLen = pAPRTemplist.GetSelectedRows();
	
	            if (ListViewLen.length < 1) {
	                return;
	            }
	
	            p_CheckAprDeptTempletSN = ListViewLen[0].getAttribute("DATA1");
	            if (p_CheckAprDeptTempletSN == "") {
	                var pAlertContent = linealt14;
	                OpenAlertUI(pAlertContent);
	            }
	            else {
	                AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN);
	                pAprDeptTempletUseFlag = false;
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_btn_AprDeptTempletAdd_onclick::" + e.description);
	        }
	    }
	    function AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN) {
	        try {
	        	var result = "";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/aprLineTempletListInfo.do",
	        		data : {
	        				userID 	 : pUserID,
	        				formID   : pFormID,
	        				aprLineSN: p_CheckAprDeptTempletSN
	        				},
	        		success: function(xml){
	        			result = loadXMLString(xml);
	        		}        			
	        	});
	        	
	            SetGongRamList(result);
	        } catch (e) {
	            alert("AprGongRamLine_Cross_AddToAprDeptFromAprDeptTemplet::" + e.description);
	        }
	    }
	    function SetGongRamList(pstrXML) {
	
	        try {
	
	            var listnodes = SelectNodes(pstrXML, "LISTVIEWDATA/ROWS/ROW");
	
	            var AprLineAddIndex = 0;
	            var pAPRLINE = new ListView();
	            pAPRLINE.LoadFromID("pAPRLINE");
	            var objRows = pAPRLINE.GetDataRows();
	            var totCnt = objRows.length;
	            var newCnt = 0;
	            AprLineAddIndex = totCnt + 1;
	
	            if (GetAttribute(objRows[0], "id") == "pAPRLINE_TR_noItems") {
	                pAPRLINE.DeleteRow("pAPRLINE_TR_noItems");
	                AprLineAddIndex = 1;
	            }
	
	            for (var cnt = 0; cnt < listnodes.length; cnt++) {
	
	                var DuplicateFlag = false;
	                for (i = 0; i < objRows.length; i++) {
	                    if (GetAttribute(objRows[i], "DATA4").toLowerCase() == getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[5], "DATA5").toLowerCase() && GetAttribute(objRows[i], "DATA6").toLowerCase() == getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[8], "DATA8").toLowerCase())
	                        DuplicateFlag = true;
	                }
	
	                if (DuplicateFlag) {
	                    continue;
	                } else {
	                    var preDeptName = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
	                    var preDeptJobTitle = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
	                    var preDeptName1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
	                    var preDeptName2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[9], "DATA9");
	                    var preWriterName1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[2])[0], "VALUE");
	                    var preWriterName2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[2])[0], "VALUE");
	                    var preDeptJobTitle1 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
	                    var preDeptJobTitle2 = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[7], "DATA7");
	                    var preDeptID = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[8], "DATA8");
	                    var preUserID = getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[5], "DATA5");
	
	                    var pparsingXML = "";
	                    pparsingXML = "<LISTVIEWDATA><HEADERS>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang300 + "</NAME><WIDTH>30</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>60</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>80</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang61 + "</NAME><WIDTH>80</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang125 + "</NAME><WIDTH>80</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang301 + "</NAME><WIDTH>80</WIDTH></HEADER>";
	                    pparsingXML = pparsingXML + "</HEADERS><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW>";
	                    pparsingXML = pparsingXML + "<CELL>";
	                    pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
	                    pparsingXML = pparsingXML + "<DATA1>" + "" + "</DATA1>";
	                    pparsingXML = pparsingXML + "<DATA2>" + "" + "</DATA2>";
	                    pparsingXML = pparsingXML + "<DATA3>" + pDocID + "</DATA3>";
	                    pparsingXML = pparsingXML + "<DATA4>" + preUserID + "</DATA4>";
	                    pparsingXML = pparsingXML + "<DATA5>" + "N" + "</DATA5>";
	                    pparsingXML = pparsingXML + "<DATA6>" + preDeptID + "</DATA6>";
	                    pparsingXML = pparsingXML + "<DATA7>" + "" + "</DATA7>";
	                    pparsingXML = pparsingXML + "<DATA8>" + "N" + "</DATA8>";
	                    pparsingXML = pparsingXML + "<DATA9>" + "N" + "</DATA9>";
	                    pparsingXML = pparsingXML + "<DATA10>7001388</DATA10>";
	                    pparsingXML = pparsingXML + "<DATA11>015</DATA11>";
	                    pparsingXML = pparsingXML + "<DATA12>001</DATA12>";
	                    pparsingXML = pparsingXML + "<DATA13>" + MakeXMLString(preWriterName1) + "</DATA13>";
	                    pparsingXML = pparsingXML + "<DATA14>" + MakeXMLString(preWriterName2) + "</DATA14>";
	                    pparsingXML = pparsingXML + "<DATA15>" + MakeXMLString(preDeptName1) + "</DATA15>";
	                    pparsingXML = pparsingXML + "<DATA16>" + MakeXMLString(preDeptName2) + "</DATA16>";
	                    pparsingXML = pparsingXML + "<DATA17>" + MakeXMLString(preDeptJobTitle1) + "</DATA17>";
	                    pparsingXML = pparsingXML + "<DATA18>" + MakeXMLString(preDeptJobTitle2) + "</DATA18>";
	                    pparsingXML = pparsingXML + "</CELL><CELL>";
	                    pparsingXML = pparsingXML + "<VALUE>" + preWriterName1 + "</VALUE>";
	                    pparsingXML = pparsingXML + "</CELL><CELL>";
	                    pparsingXML = pparsingXML + "<VALUE>" + preDeptJobTitle + "</VALUE>";
	                    pparsingXML = pparsingXML + "</CELL><CELL>";
	                    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(preDeptName) + "</VALUE>";
	                    pparsingXML = pparsingXML + "</CELL><CELL>";
	                    pparsingXML = pparsingXML + "<VALUE>" + strLang752 + "</VALUE>";
	                    pparsingXML = pparsingXML + "</CELL><CELL>";
	                    pparsingXML = pparsingXML + "<VALUE>" + strLang72 + "</VALUE>";
	                    pparsingXML = pparsingXML + "</CELL><CELL><VALUE></VALUE></CELL></ROW></ROWS></LISTVIEWDATA>";
	
	                    objXML = loadXMLString(pparsingXML);
	
	                    var tr = pAPRLINE.GetSelectedRows();
	                    var InitTr = pAPRLINE.GetDataRows();
	                    var MaxID = 0;
	
	                    for (var j = 0  ; j < InitTr.length  ; j++) {
	                        var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
	                        if (MaxID < curnum)
	                            MaxID = curnum;
	                    }
	
	                    if (tr.length == 0) {
	                        if (InitTr.length == 0) {
	                            if (document.getElementById("APRLINE").innerHTML != "")
	                                document.getElementById("APRLINE").innerHTML = "";
	
	                            var pAPRLINE = new ListView();
	                            pAPRLINE.SetID("pAPRLINE");
	                            pAPRLINE.SetMulSelectable(false);
	                            pAPRLINE.SetRowOnDblClick("AprlineDel_onclick");
	                            pAPRLINE.SetSelectFlag(false);
	                            pAPRLINE.DataSource(objXML);
	                            pAPRLINE.DataBind("APRLINE");
	                            AprLineAddIndex++;
	                        } else {
	                            var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
	                            pAPRLINE.AddDataRow(objTr, objXML);
	                            AprLineAddIndex++;
	                        }
	                    } else {
	                        var objTr = pAPRLINE.NewAddRow(0, "pAPRLINE" + "_TR_" + eval(MaxID + 1));
	                        pAPRLINE.AddDataRow(objTr, objXML);
	                        AprLineAddIndex++;
	                    }
	                }
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_SetGongRamList::" + e.description);
	        }
	    }
	    var aprlinetempletname_cross_dialogArguments = new Array();
	    var tempmode;
	    function btn_AprDeptTempletSave_onclick(mode) {
	
	        try {
	            tempmode = mode;
	            if (isExistDept(true)) {
	                return;
	            }
	
	            var templistviewsn = "";
	            var templisttviewname = "";
	            var ListViewLen = "";
	
	            var lvTest = new ListView();
	            lvTest.LoadFromID("pAPRLINE");
	            ListViewLen = lvTest.GetDataRows();
	
	            if (ListViewLen.length == 0 || GetAttribute(ListViewLen[0], "id") == "pAPRLINE_TR_noItems") {
	                alert("<spring:message code='ezApprovalG.pjj27'/>");
	                return;
	            }
	
	            var listview = new ListView();
	
	            if (mode == "NEW") {
	                listview.LoadFromID("pAPRLINE");
	                ListViewLen = listview.GetDataRows();
	            } else {
	                listview.LoadFromID("lvRecSaveList");
	                ListViewLen = listview.GetSelectedRows();
	            }
	
	            if (mode == "MODIFY" && ListViewLen.length < 1) {
	                return;
	            } else if (mode == "MODIFY" && ListViewLen.length >= 1) {
	                templistviewsn = ListViewLen[0].getAttribute("DATA1");
	                templisttviewname = ListViewLen[0].getAttribute("DATA2");
	            }
	
	            if (ListViewLen.length != "0" && ListViewLen[0].id != "lvRecSaveList_TR_noItems") {
	                var windowName = "/ezApprovalG/aprLineTempletName.do";
	                var parameter = "status:no;dialogWidth:340px;dialogHeight:205px;scroll:no;edge:sunken";
	                var dialogValue = new Array();
	                dialogValue[0] = pUserID;
	                dialogValue[1] = pFormID;
	                dialogValue[2] = "";
	                dialogValue[3] = "";
	                if (mode == "MODIFY") {
	                    dialogValue[2] = templistviewsn;
	                    dialogValue[3] = templisttviewname;
	                }
	                if (CrossYN()) {
	                    aprlinetempletname_cross_dialogArguments[0] = dialogValue;
	                    aprlinetempletname_cross_dialogArguments[1] = btn_AprDeptTempletSave_onclick_Complete;
	
	                    DivPopUpShow(340, 250, windowName);
	                } else {
	                    parameter = parameter + GetShowModalPosition(340, 250);
	
	                    var ret = window.showModalDialog(windowName, dialogValue, parameter);
	                    if (ret != "cancel") {
	                        if (mode == "NEW")
	                            pAprDeptTempletUseFlag = true;
	                        else
	                            pAprDeptTempletUseFlag = false;
	
	                        CreateNewAprDeptTemplet(ret);
	                    }
	                }
	            } else {
	                var pAlertContent = linealt14;
	                OpenAlertUI(pAlertContent);
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_SetGongRamList::" + e.description);
	        }
	    }
	    var pAprDeptTempletUseFlag;
	    function btn_AprDeptTempletSave_onclick_Complete(ret) {
	        try {
	            DivPopUpHidden();
	            if (ret != "cancel") {
	                if (tempmode == "NEW")
	                    pAprDeptTempletUseFlag = true;
	                else
	                    pAprDeptTempletUseFlag = false;
	
	                CreateNewAprDeptTemplet(ret);
	            }
	        } catch (e) {
	            alert("AprGongRamLine_Cross_btn_AprDeptTempletSave_onclick_Complete::" + e.description);
	        }
	    }
	    function isExistDept(ExtFlag) {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("pAPRLINE");
	            var CurSelRow = listview.GetDataRows();
	            var rtnVal = false;
	            for (i = 0; i < CurSelRow.length; i++) {
	                if (ExtFlag) {
	                    if (GetAttribute(CurSelRow[0], "DATA3") == "Y")
	                        rtnVal = true;
	                }
	                else {
	                    if (GetAttribute(CurSelRow[0], "DATA3") == "N")
	                        rtnVal = true;
	                }
	
	                if (GetAttribute(CurSelRow[0], "DATA1") == "Address") {
	                    rtnVal = true;
	                }
	            }
	            return rtnVal;
	        } catch (e) {
	            alert("AprGongRamLine_Cross_isExistDept::" + e.description);
	        }
	    }
	    function CreateNewAprDeptTemplet(p_AprDeptTempletName) {
	        try {
	            var AprDeptTemplet = createXmlDom();
	            var Result;
	            var p_AprDeptTempletID;
	            AprDeptTemplet = AprDeptTempletXmlParsing(p_AprDeptTempletName);
	            var AprDeptXml = APRDeptXMLParsing(APRLINE, pDocID);
	            var AprDeptInfo = createXmlDom();
	            AprDeptInfo = loadXMLString(AprDeptXml);
	
	            if (CrossYN()) {
	                var xmlRtn = AprDeptTemplet.documentElement;
	                var Node = AprDeptInfo.importNode(xmlRtn, true);
	                AprDeptInfo.documentElement.appendChild(Node);
	            }
	            else {
	                var xmlRtn = AprDeptTemplet.documentElement;
	                AprDeptInfo.documentElement.appendChild(xmlRtn);
	            }
	
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezApprovalG/createAprLineTemplet.do", false);
	            xmlhttp.send(AprDeptInfo);
	
	            var dataNodes = GetChildNodes(xmlhttp.responseXML);
	            var RtnVal = getNodeText(dataNodes[0]);
	
	            if (RtnVal == "TRUE") {
	                OpenAlertUI(strLang814, CreateNewAprDeptTemplet_Complete);
	                if (!CrossYN())
	                    GetReceptTempletList();
	            }
	            else {
	                OpenAlertUI(strLang131);
	            }
	
	            GetReceptTempletList();
	        } catch (e) {
	            alert("AprGongRamLine_Cross_CreateNewAprDeptTemplet::" + e.description);
	        }
	    }
	    function CreateNewAprDeptTemplet_Complete() {
	        DivPopUpHidden();
	        InitReceptTemplet();
	    }
	    function AprDeptTempletXmlParsing(p_AprDeptTempletName) {
	        try {
	            var p_AprDeptSN;
	            var xmlpara = createXmlDom();
	            if (pAprDeptTempletUseFlag) {
	                p_AprDeptSN = "";
	            } else {
	
	                var pAPRTemplist = new ListView();
	                pAPRTemplist.LoadFromID("lvRecSaveList");
	                var ListViewLen = pAPRTemplist.GetSelectedRows();
	                p_AprDeptSN = ListViewLen[0].getAttribute("DATA1");
	            }
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "APRTEMP");
	            createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	            createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);
	            createNodeAndInsertText(xmlpara, objNode, "pAprDeptSN", p_AprDeptSN);
	            createNodeAndInsertText(xmlpara, objNode, "p_AprDeptTempletName", p_AprDeptTempletName);
	
	            return xmlpara;
	        } catch (e) {
	            alert("AprGongRamLine_Cross_AprDeptTempletXmlParsing::" + e.description);
	        }
	    }
	    function APRDeptXMLParsing(APRDEPT, pDocID) {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("pAPRLINE");
	            var AprDeptRow = listview.GetDataRows();
	            var CurListLen = AprDeptRow.length;
	            var CurCellLen = 0;
	            if (CurListLen > 0)
	                CurCellLen = AprDeptRow[0].cells.length - 1;
	            var i;
	            var j;
	            var GetXml;
	
	            GetXml = "<LISTVIEWDATA><HEADERS></HEADERS>";
	            GetXml = GetXml + "<ROWS>";
	
	            for (i = 0; i < CurListLen; i++) {
	                GetXml = GetXml + "<ROW>";
	                for (j = 0; j < CurCellLen; j++)
	                    GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprDeptRow[i].cells[j].innerText) + "</COLUMN>";
	
	                GetXml = GetXml + "<DATA name='ProcessDate'>" + AprDeptRow[i].getAttribute("DATA1") + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceivedDate'>" + AprDeptRow[i].getAttribute("DATA2") + "</DATA>";
	                GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprMemberID'>" + AprDeptRow[i].getAttribute("DATA4") + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + AprDeptRow[i].getAttribute("DATA5") + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + AprDeptRow[i].getAttribute("DATA6") + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + AprDeptRow[i].getAttribute("DATA7") + "</DATA>";
	                GetXml = GetXml + "<DATA name='isProposerYN'>" + AprDeptRow[i].getAttribute("DATA8") + "</DATA>";
	                GetXml = GetXml + "<DATA name='isBriefUserYN'>" + AprDeptRow[i].getAttribute("DATA9") + "</DATA>";
	                GetXml = GetXml + "<DATA name='isCompanyID'>" + AprDeptRow[i].getAttribute("DATA10") + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprType'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA11")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprState'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA12")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA13")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA14")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA15")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA16")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA17")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA18")) + "</DATA>";
	                GetXml = GetXml + "</ROW>";
	            }
	
	            GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
	            return GetXml;
	        } catch (e) {
	            alert("AprGongRamLine_Cross_APRDeptXMLParsing::" + e.description);
	        }
	    }
	    function removeAllReception() {
	        var listview = new ListView();
	        listview.LoadFromID("pAPRLINE");
	        var CurSelRow = listview.GetDataRows();
	        var DeleteState;
	        for (var i = 0; i < CurSelRow.length; i++) {
	            try {
	                DeleteState = DeptRowDelelte(listview.GetSelectedIndexes().split(',')[0], listview.GetDataRows());
	                if (DeleteState == "Y")
	                    listview.DeleteRow(GetAttribute(CurSelRow[i], "id"));
	            } catch (e) {
	                alert(e.description);
	            }
	        }
	    }
	
	    function DeptRowDelelte(SelectIndex, ColRow) {
	        var RowDelCheck;
	        var ReturnVal = "N";
	        TIndex = ColRow.length;
	        NIndex = SelectIndex;
	        for (i = 0; i <= NIndex; i++) {
	            RowDelCheck = ColRow[i].cells[0].innerText;
	            if (CrossYN())
	                ColRow[i].childNodes[0].textContent = RowDelCheck - 1;
	            else
	                ColRow[i].cells[0].innerText = RowDelCheck - 1;
	
	            var ReturnVal = "Y";
	        }
	        return ReturnVal;
	    }
	    function CheckReceiverList() {
	        var listview = new ListView();
	        listview.LoadFromID("pAPRLINE");
	        ListViewLen = listview.GetDataRows();
	
	        try {
	            if (ListViewLen[0].getAttribute("id") == "pAPRLINE_TR_noItems")
	                btn_AprDeptTempletAdd_onclick();
	        } catch (e) { }
	
	        try {
	            if (ListViewLen.length == 0)
	                btn_AprDeptTempletAdd_onclick();
	        } catch (e) { }
	
	    }
	</script>
	</head>
	<body class="popup" style="overflow-y: hidden;">
	    <h1><spring:message code='ezApprovalG.t1681'/></h1>
	    <div class="portlet_tabpart02">
	        <div class="portlet_tabpart02_top" id="tab1">
	            <p id="showAprLine"><span divname="Lineinfo" id="1tab1"><spring:message code='ezApprovalG.t1214'/></span></p>
	        </div>
	    </div>
	    <table>
	        <tr>
	            <td style="vertical-align: top">
	                <div class="portlet_tabpart01" style="margin-top: 3px; text-align: right;">
	                    <div class="portlet_tabpart01_top" id="tab3">
	                        <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
	                        <p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
	                    </div>
	                </div>
	                <!-- 조직도 -->
	                <div id="Organ">
	                    <div class="listview" style="">
	                        <div class="box" style="overflow: auto; height: 350px; width: 388px;" id="TreeView"></div>
	                </div>
	                <div class="listview" style="margin-top: 5px">
	                        <div id="UserList" style="overflow: auto; Width: 388px; Height: 190px; border: 0; margin: 1px 0px 1px 1px;"></div>
	                </div>
	                <table style="width: 100%;">
	                    <tr>
	                            <td style="text-align: left; height: 30px;">
	                                <input id="textUser" style="width: 188px;" name="textUser" onkeypress="return textUser_onkeypress()" tabindex="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="imgbtn" style="vertical-align: middle;"><span id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()"><spring:message code='ezApprovalG.t234'/></span></a></td>
	                        </tr>
	                    </table>
	                </div>
	                <!-- 즐겨찾기 -->
	                <div id="ReceptTemp" style="display: none; padding-left: 5px">
	                    <table>
	                        <tr>
	                            <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                <h2 class="h2_dot"><spring:message code='ezApprovalG.G0003'/></h2>
	                                <div class="border_gray">
	                                    <div id="RecSaveList" style="border: 0px; Width: 388px; Height: 237px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                    </div>
	                                </div>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td style="background-color: transparent; text-align: center; height: 30px;">
	                                <table class="content" style="margin-bottom: 5px; width: 100%;">
	                                    <tr>
	                                        <td style="text-align: center;">
	                                            <a class="imgbtn"><span id="Span3" onclick="return btn_AprDeptTempletDel_onclick()"><spring:message code='ezApprovalG.t252'/></span></a>
	                                            <a class="imgbtn"><span id="Span4" onclick="return btn_AprDeptTempletSave_onclick('MODIFY')"><spring:message code='ezApprovalG.G0006'/></span></a>
	                                            <a class="imgbtn"><span onclick="return btn_AprDeptTempletAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
	                                        </td>
	                                    </tr>
	                                </table>
	                            </td>
	                        </tr>
	                        <tr>
	                            <td style="vertical-align: top;">
	                                <div class="border_gray">
	                                    <div id="RecSaveDetail" style="Width: 388px; Height: 240px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                    </div>
	                                </div>
	                        </td>
	                    </tr>
	                </table>
	                    <table style="width: 100%;">
	                        <tr>
	                            <td style="text-align: left; height: 30px;">
	                        </tr>
	                    </table>
	                </div>
	            </td>
	            <td style="width: 25px; text-align: center;">
	                <div id="AddUser">
	                    <img id="AprlineAdd" onclick="return AprlineAdd_onclick()" style="cursor: pointer" src="/images/arr_r.gif" width="16" height="16">
	                    <img id="AprlineDel" onclick="return AprlineDel_onclick()" style="cursor: pointer" src="/images/arr_l.gif" width="16" height="16">
	                </div>
	            </td>
	            <td style="vertical-align: top;">
	                <h2 class="h2_dot"><spring:message code='ezApprovalG.t1689'/>
	                    <div style="text-align: right; margin-top: -23px; padding-right: 5px">
	                        <a class="imgbtn" onclick="return AprlineUpper_onclick();"><span>
	                            <img src="/images/ImgIcon/prev.gif" height="16" alt="<spring:message code='ezApprovalG.pjj28'/>" style="vertical-align: middle" /></span></a>
	                        <a class="imgbtn" onclick="return AprlineDown_onclick();"><span>
	                            <img src="/images/ImgIcon/next.gif" height="16" alt="<spring:message code='ezApprovalG.pjj29'/>" style="vertical-align: middle" /></span></a>
	                </div>
	                </h2>
	                <div class="listview" style="margin-top: 5px">
	                    <div id="APRLINE" style="overflow: auto; border: 0px solid #B6B6B6; width: 550px; height: 550px; background-color: #ffffff; margin: 1px 1px 1px 1px;"></div>
	                </div>
	                <div style="text-align: right;">
	                    <a class="imgbtn" style="padding-right: 5px; margin-top: 5px;"><span id="Span5" onclick="return btn_AprDeptTempletSave_onclick('NEW')"><spring:message code='ezApprovalG.G0009'/></span></a>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div style="text-align: center;" id="orgbtnArea">
	        <table style="width: 976px">
	            <tr>
	                <td style="text-align: center;">
	                    <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="SaveAprline_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
	                    <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="CancelAprline_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
	            </td>
	        </tr>
	    </table>
	    </div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
	<script type="text/javascript">
	    Tab3_NewTabIni("tab1");
	    Tab3_NewTabIni("tab3");
	</script>
</html>