<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t427'/></title>
	    <meta http-equiv="Content-Type" content="text/html;charset=utf-8;">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <link rel="stylesheet" type="text/css" href="/css/Tab.css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TabMenu.js"></script>
	    <script type="text/javascript" src="/js/escapenew.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript">
	        var OrderCell = "";
	        var labelcolor = "c6c6c6";
	        var xmlhttp = createXMLHttpRequest();
	        var InitTreeVal = "";
	        var pDocID;
	        var pReceiveSN;
	        var pReceivedDeptID;
	        var pAprSate;
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var pUserID = arr_userinfo[1];
	        var RetValue;
	        var ReturnFunction;
	        /* 2015-04-13 경기대학교추가-KSK */
	        var listveiwHeader1 = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + "<spring:message code='ezApprovalG.t401'/>" + "</NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS></ROWS></LISTVIEWDATA>";
	        var pFormID = "XXXXXXX";
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
	        var CompanyID = "${userInfo.companyID}";
	
	        window.onload = function () {
	            try {
	                try {
	                    RetValue = parent.ezreceivedistributeui_cross_dialogArguments[0];
	                    ReturnFunction = parent.ezreceivedistributeui_cross_dialogArguments[1];
	                } catch (e) {
	                    try {
	                        RetValue = opener.ezreceivedistributeui_cross_dialogArguments[0];
	                        ReturnFunction = opener.ezreceivedistributeui_cross_dialogArguments[1];
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	               
	                pDocID = RetValue[0];
	                pReceiveSN = RetValue[1];
	                psentDeptID = RetValue[2];
	                pAprSate = RetValue[3];
	                pReceivedDeptID = RetValue[4];
	                if (pReceiveSN == "s")
	                    pReceiveSN = "1";
	                else
	                    pReceiveSN = pReceiveSN.replace("s", "");
	
	                InitTreeVal = arr_userinfo[4];
	                Tree_setconfig();
	                initTreeInfo();
	                AprLineInit();
	
	                if (!CrossYN())
	                    window.returnValue = "cancel";
	            } catch (ErrMsg) {
	                alert(ErrMsg.description);
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
	        function AprLineInit() {
	            var strXML;
	            var objXML = createXmlDom();
	            strXML = "<LISTVIEWDATA><HEADERS>";
	            strXML = strXML + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t428'/>" + "</NAME><WIDTH>156</WIDTH></HEADER>";
	            strXML = strXML + "</HEADERS><ROWS> </ROWS></LISTVIEWDATA>";
	            objXML = loadXMLString(strXML);
	            var listview = new ListView();
	            listview.SetTableWidth = 170 - 14;
	            listview.SetID("listAPRLINE1");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnDblClick("btn_DeptDel_onclick");
	            listview.DataSource(objXML);
	            listview.DataBind("APRLINE1");
	        }
	        function initTreeInfo() {
	            try {
	                TreeViewinitialize(InitTreeVal, "${userInfo.companyID}", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName", "");
	            } catch (ErrMsg) {
	                alert(ErrMsg.description);
	            }
	        }
	    function initListInfo1() {
	        try {
	            var strXML;
	            var objXML = createXmlDom();
	            strXML = "<LISTVIEWDATA><HEADERS>";
	            strXML = strXML + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t249'/>" + "</NAME><WIDTH>156</WIDTH></HEADER>";
	            strXML = strXML + "</HEADERS></LISTVIEWDATA>";
	            objXML = loadXMLString(strXML);
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            listview.SetTableWidth = 170 - 14;
	            listview.DataSource(objXML);
	            listview.DataBind("APRLINE1");
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	    function btnAssign_onclick() {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            if (listview.GetDataRows().length > 0) {
	                var RtnVal = setReceiveDistribute();
	                if (RtnVal == "TRUE") {
	                    if (ReturnFunction != null) {
	                            var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
	                            if (CrossYN()) {
	                        ReturnFunction("true");
	                        window.close();
	                            } else {
	                                OpenAlertUI(pAlertContent);
	                                try { opener.btnDistribute_onclick_Complete(true); } catch (e) { }
	                    }
	                            window.close();
	                        } else {
	                        window.returnValue = "true";
	                        window.close();
	                    }
	                    } else {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t426'/>" + RtnVal;
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	                } else {
	                var pAlertContent = "<spring:message code='ezApprovalG.t429'/>";
	                return;
	                OpenAlertUI(pAlertContent);
	            }
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	        function btnCancel_onclick() {
	            if (ReturnFunction != null) {
	                ReturnFunction("cancel");
	                window.close();
	            }
	            else {
	                window.returnValue = "cancel";
	                window.close();
	            }
	    }
	    function setReceiveDistribute(pCurSelRow) {
	        try {
	            var xmlpara = createXmlDom();
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            var objRoot, objRow, custData;
	            var xmlhttp = createXMLHttpRequest();
	            var pSelRows = listview.GetDataRows();
	            var i;
	            objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");
	            SetAttribute(objRoot, "DocID", pDocID);
	            SetAttribute(objRoot, "ReceiveSN", pReceiveSN);
	            SetAttribute(objRoot, "SendDeptID", psentDeptID);
	            SetAttribute(objRoot, "DocState", pAprSate);
	            SetAttribute(objRoot, "ReceivedDeptID", pReceivedDeptID);
	            for (i = 0; i < pSelRows.length; i++) {
	                var SelRow = pSelRows[i];
	
	                objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
	                custData = createNodeAndAppandNodeText(xmlpara, objRow, custData, "RECEIVEDEPTID", SelRow.getAttribute("DATA1"));
	                custData = createNodeAndAppandNodeText(xmlpara, objRow, custData, "RECEIVEDEPTNAME", MakeXMLString(SelRow.getAttribute("DATA4")));
	                custData = createNodeAndAppandNodeText(xmlpara, objRow, custData, "RECEIVEDEPTNAME2", MakeXMLString(SelRow.getAttribute("DATA5")));
	            }
	            if ("${mode}" == "add") 
	                xmlhttp.open("POST", "/ezApprovalG/addBebu.do", false);
	            else
	                xmlhttp.open("POST", "/ezApprovalG/setBebu.do", false);
	            xmlhttp.send(xmlpara);
	            return getNodeText(GetChildNodes(xmlhttp.responseXML)[0]);
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	    function list1_onSel_DBclick() {
	        try {
	            var selnode = window.event.result;
	            InitTreeVal = selnode.getAttribute("DATA1");
	            initTreeInfo();
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	    function GetEntryInfo(_DEPTID) {
        	var result = "";
	        var ReceiveDocument = "";
        	
        	$.ajax({
        		type : "POST",
        		dataType : "text",
        		async : false,
        		url : "/admin/ezOrgan/getEntryInfo.do",
        		data : {
        			cn 	  : _DEPTID,
        			prop  : "extensionAttribute11",
        			mode  : "dept"
        		},
        		success: function(xml){
        			result = loadXMLString(xml);
        		}        			
        	});
	        	
	
            XmlDom = result;
            ReceiveDocument = SelectSingleNodeValueNew(XmlDom, "DATA/EXTENSIONATTRIBUTE11").trim();
	
	        return ReceiveDocument;
	    }
	
	
	    function TreeViewNodeDbClick() {
	        var strXML;
	        var objXML = createXmlDom();
	        var chkDuplflag = false;
	        var listview = new ListView();
	        listview.LoadFromID("listAPRLINE1");
	        var treeView = new TreeView();
	        treeView.LoadFromID("FromTreeView");
	
	        if (GetEntryInfo(treeView.GetSelectNode().GetNodeData("CN")) == "N") {
	            var pAlertContent = strLang1105;
	            OpenAlertUI(pAlertContent);
	            return;
	        }
	
	        var lastRowIdx = listview.GetDataRows().length;
	        if (lastRowIdx == 1) {
	            var tr = listview.GetDataRows();
	            if (tr[0].id.indexOf("noItems") > 0)
	                lastRowIdx = 0;
	        }
	
	        if (MakeXMLString(treeView.GetSelectNode().GetNodeData("CN")) == arr_userinfo[4]) {
	            var pAlertContent = "<spring:message code='ezApprovalG.t2000'/>";
	            OpenAlertUI(pAlertContent);
	            return;
	        }
	        if (lastRowIdx != 0) {
	            for (var i = 0; i < lastRowIdx; i++) {
	                if (listview.GetDataRows()[i].getAttribute("DATA1") == MakeXMLString(treeView.GetSelectNode().GetNodeData("CN"))) {
	                    chkDuplflag = true;
	                    break;
	                }
	            }
	            if (chkDuplflag) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t2001'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        }
	        if (lastRowIdx < 1) {
	            strXML = "<LISTVIEWDATA><HEADERS>";
	            strXML = strXML + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t428'/>" + "</NAME><WIDTH>156</WIDTH></HEADER>";
	            strXML = strXML + "</HEADERS><ROWS><ROW><CELL>";
	            strXML = strXML + "<VALUE>" + MakeXMLString(treeView.GetSelectNode().GetNodeData("VALUE")) + "</VALUE>";
	            strXML = strXML + "<DATA1>" + treeView.GetSelectNode().GetNodeData("CN") + "</DATA1>";
	            strXML = strXML + "<DATA2>" + "" + "</DATA2>";
	            strXML = strXML + "<DATA3>" + "" + "</DATA3>";
	            strXML = strXML + "<DATA4>" + MakeXMLString(treeView.GetSelectNode().GetNodeData("DISPLAYNAME1")) + "</DATA4>";
	            strXML = strXML + "<DATA5>" + MakeXMLString(treeView.GetSelectNode().GetNodeData("DISPLAYNAME2")) + "</DATA5>";
	            strXML = strXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";
	            objXML = loadXMLString(strXML);
	            document.getElementById("APRLINE1").innerHTML = "";
	            var listview = new ListView();
	            listview.SetID("listAPRLINE1");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnDblClick("btn_DeptDel_onclick");
	            listview.DataSource(objXML);
	            listview.DataBind("APRLINE1");
	            } else {
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            var InitTr = listview.GetDataRows();
	            var MaxID = 0;
	
	            for (var j = 0  ; j < InitTr.length  ; j++) {
	                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                if (MaxID < curnum)
	                    MaxID = curnum;
	            }
	            strXML = "<ROW><CELL><VALUE>" + MakeXMLString(treeView.GetSelectNode().GetNodeData("VALUE")) + "</VALUE>";
	            strXML = strXML + "<DATA1>" + treeView.GetSelectNode().GetNodeData("CN") + "</DATA1>";
	            strXML = strXML + "<DATA2>" + "" + "</DATA2>";
	            strXML = strXML + "<DATA3>" + "" + "</DATA3>";
	            strXML = strXML + "<DATA4>" + MakeXMLString(treeView.GetSelectNode().GetNodeData("DISPLAYNAME1")) + "</DATA4>";
	            strXML = strXML + "<DATA5>" + MakeXMLString(treeView.GetSelectNode().GetNodeData("DISPLAYNAME2")) + "</DATA5>";
	            strXML = strXML + "</CELL></ROW>";
	            if (listview.GetSelectedRows().length == 0) {
	                var objTr = listview.AddRow(0);
	                SetAttribute(objTr, "id", "listAPRLINE1" + "_TR_" + eval(MaxID + 1));
	                listview.AddDataRow(objTr, loadXMLString(strXML));
	            }
	            else {
	                var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
	                SetAttribute(objTr, "id", "listAPRLINE1" + "_TR_" + eval(MaxID + 1));
	                listview.AddDataRow(objTr, loadXMLString(strXML));
	            }
	        }
	    }
	    function btn_DeptDel_onclick() {
	        var listview = new ListView();
	        listview.LoadFromID("listAPRLINE1");
	        var selRow = listview.GetSelectedIndexes();
	        if (selRow) {
	            listview.DeleteRow(listview.GetSelectedRowID(listview.GetSelectedIndexes()));
	        }
	    }
	    function btn_searchDept_onclick() {
	        try {
	            var strSearch = textDept.value + "";
	            if (textDept.value == "") {
	                var pAlertContent = "<spring:message code='ezApprovalG.t430'/>";
	                OpenAlertUI(pAlertContent);
	                initListInfo1();
	            }
	            else if (strSearch.length < 2) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t227'/>";
	                OpenAlertUI(pAlertContent);
	            }
	            else {
	                var xmlpara = createXmlDom();
	                var xmlRtn = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "LISTVIEWDATA");
	                createNodeAndInsertText(xmlpara, objNode, "CELL", textDept.value);
	                xmlhttp.open("POST", "aspx/GetDeptListVInfo.aspx", false);
	                xmlhttp.send(xmlpara);
	                xmlRtn = loadXMLString(xmlhttp.responseXML);
	                var NodeList = SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW");
	                if (NodeList.length != "0") {
	                    var listview = new ListView();
	                    listview.LoadFromID("listAPRLINE1");
	                    listview.SetTableWidth = 170 - 14;
	                    listview.DataSource(xmlRtn);
	                    listview.RowDataBind();
	                    if (listview.GetDataRows().length == 0) {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t431'/>";
	                        OpenAlertUI(pAlertContent);
	                        initListInfo2();
	                    }
	                }
	                else {
	                    textDept.value = "";
	                }
	            }
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
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
	
	function textDept_onkeypress() {
	    try {
	        var pKeycode = window.event.keyCode;
	        if (pKeycode == "13") {
	            btn_searchDept_onclick();
	        }
	    } catch (e) {
	        alert("textDept_onkeypress :: " + e.description);
	    }
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
	    if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
	    for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document); return x;
	}
	function MM_swapImage() {
	    var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
	        if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
	}
	var nodeIdx;
	function TreeViewNodeClick() {
	    var treeView = new TreeView();
	    treeView.LoadFromID("FromTreeView");
	
	    var nodeIdx = treeView.GetSelectNode();
	}
	    /* 2015-04-13 경기대학교 추가 - KSK */
	    var ezapropinion_cross_dialogArguments = new Array();
	    function OpenInformationUI(pInformationContent, CompleteFunction) {
	        var parameter = pInformationContent;
	        var url = "/ezApprovalG/ezAprOpinion.do";
	
	        if (CrossYN()) {
	            ezapropinion_cross_dialogArguments[0] = parameter;
	            if (CompleteFunction != undefined)
	                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
	            else
	                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
	            DivPopUpShow(330, 205, url);
	        }
	        else {
	            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	            feature = feature + GetShowModalPosition(330, 205);
	            var RtnVal = window.showModalDialog(url, parameter, feature);
	            if (RtnVal && CompleteFunction != undefined)
	                CompleteFunction(RtnVal);
	        }
	        return RtnVal;
	    }
	
	    function OpenInformationUI_Complete() {
	        DivPopUpHidden();
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
	            alert("ezReceiveDistributeUI_Cross_ChangeReceptTab::" + e.description);
	        }
	    }
	    function AddReceptAll() {
	        try {
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	
	            if (GetEntryInfo(treeView.GetSelectNode().GetNodeData("CN")) == "N") {
	                var pAlertContent = strLang1105;
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	
	            if (CrossYN()) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t1361'/>" + "<br>" + "<spring:message code='ezApprovalG.t1362'/>";
	                var Ans = OpenInformationUI(pAlertContent, Complete_AddReceptAll);
	            } else {
	                var pAlertContent = "<spring:message code='ezApprovalG.t1361'/>" + "<br>" + "<spring:message code='ezApprovalG.t1362'/>";
	                var Ans = OpenInformationUI(pAlertContent);
	
	                if (!Ans)
	                    return;
	
	                nodeIdx = treeView.GetSelectNodeID();
	                insertInnerDept(treeView.GetSelectNode().GetNodeData("CN"), treeView.GetSelectNode().GetNodeData("VALUE"));
	            }
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_AddReceptAll::" + e.description);
	        }
	    }
	    function Complete_AddReceptAll(ret) {
	        DivPopUpHidden();
	        if (!ret)
	            return;
	
	        var treeView = new TreeView();
	        treeView.LoadFromID("FromTreeView");
	        nodeIdx = treeView.GetSelectNodeID();
	        insertInnerDept(treeView.GetSelectNode().GetNodeData("CN"), treeView.GetSelectNode().GetNodeData("VALUE"));
	    }
	    function insertInnerDept(innserdeptid, innserdeptname) {
	
	        var selfInsert = false;
	
	        try {
	
	            if (innserdeptid == arr_userinfo[4] && "${USE_SELFDISTRIBUTE}" == "N") {
	                var pAlertContent = "<spring:message code='ezApprovalG.t2000'/>";
	                OpenAlertUI(pAlertContent);
	                selfInsert = true;
	            }
	
	            if (nodeIdx != "") {
	                if (isExistDept(true)) {
	                    var pAlertContent = strLang244 + "</br>" + strLang245;
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	                var treeNode = new TreeNode();
	                treeNode.LoadFromID(nodeIdx);
	                var DuplicateFlag = DuplicateAprDeptCheck(APRLINE1, innserdeptid);
	                if (DuplicateFlag && !selfInsert)
	                    addInnerDept(innserdeptid, innserdeptname);
	
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "DEPTID", innserdeptid);
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "EXTENSIONATTRIBUTE2");
	
	                xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptSubTreeInfo.aspx", false);
	                xmlHTTP.send(xmlpara);
	
	                var xmlNodes = createXmlDom();
	                xmlNodes = loadXMLString(xmlHTTP.responseText);
	
	                var objNodes = SelectNodes(xmlNodes, "NODES/NODE");
	
	                if (objNodes.length > 0) {
	                    for (var i = 0; i < objNodes.length; i++) {
	                        insertInnerDept(objNodes[i].getElementsByTagName("CN")[0].childNodes[0].nodeValue, objNodes[i].getElementsByTagName("VALUE")[0].childNodes[0].nodeValue);
	                    }
	                }
	            }
	            return;
	        }
	        catch (e) { alert(e.description); }
	    }
	    function addInnerDept(STRDEPTID, STRDEPTNAME) {
	
	        var strXML;
	        var objXML = createXmlDom();
	        var chkDuplflag = false;
	        var listview = new ListView();
	        listview.LoadFromID("listAPRLINE1");
	        var treeView = new TreeView();
	        treeView.LoadFromID("FromTreeView");
	        var lastRowIdx = listview.GetDataRows().length;
	        if (lastRowIdx == 1) {
	            var tr = listview.GetDataRows();
	            if (tr[0].id.indexOf("noItems") > 0)
	                lastRowIdx = 0;
	        }
	
	        if (lastRowIdx != 0) {
	            for (var i = 0; i < lastRowIdx; i++) {
	                if (listview.GetDataRows()[i].getAttribute("DATA1") == STRDEPTID) {
	                    chkDuplflag = true;
	                    break;
	                }
	            }
	            if (chkDuplflag) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t2001'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	        }
	        if (lastRowIdx < 1) {
	            strXML = "<LISTVIEWDATA><HEADERS>";
	            strXML = strXML + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t428'/>" + "</NAME><WIDTH>156</WIDTH></HEADER>";
	            strXML = strXML + "</HEADERS><ROWS><ROW><CELL>";
	            strXML = strXML + "<VALUE>" + MakeXMLString(STRDEPTNAME) + "</VALUE>";
	            strXML = strXML + "<DATA1>" + STRDEPTID + "</DATA1>";
	            strXML = strXML + "<DATA2>" + "" + "</DATA2>";
	            strXML = strXML + "<DATA3>" + "" + "</DATA3>";
	            strXML = strXML + "<DATA4>" + MakeXMLString(STRDEPTNAME) + "</DATA4>";
	            strXML = strXML + "<DATA5>" + MakeXMLString(STRDEPTNAME) + "</DATA5>";
	            strXML = strXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";
	            objXML = loadXMLString(strXML);
	            document.getElementById("APRLINE1").innerHTML = "";
	            var listview = new ListView();
	            listview.SetID("listAPRLINE1");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnDblClick("btn_DeptDel_onclick");
	            listview.DataSource(objXML);
	            listview.DataBind("APRLINE1");
	        } else {
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            var InitTr = listview.GetDataRows();
	            var MaxID = 0;
	
	            for (var j = 0  ; j < InitTr.length  ; j++) {
	                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                if (MaxID < curnum)
	                    MaxID = curnum;
	            }
	            strXML = "<ROW><CELL><VALUE>" + MakeXMLString(STRDEPTNAME) + "</VALUE>";
	            strXML = strXML + "<DATA1>" + STRDEPTID + "</DATA1>";
	            strXML = strXML + "<DATA2>" + "" + "</DATA2>";
	            strXML = strXML + "<DATA3>" + "" + "</DATA3>";
	            strXML = strXML + "<DATA4>" + MakeXMLString(STRDEPTNAME) + "</DATA4>";
	            strXML = strXML + "<DATA5>" + MakeXMLString(STRDEPTNAME) + "</DATA5>";
	            strXML = strXML + "</CELL></ROW>";
	            if (listview.GetSelectedRows().length == 0) {
	                var objTr = listview.AddRow(0);
	                SetAttribute(objTr, "id", "listAPRLINE1" + "_TR_" + eval(MaxID + 1));
	                listview.AddDataRow(objTr, loadXMLString(strXML));
	            } else {
	                var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
	                SetAttribute(objTr, "id", "listAPRLINE1" + "_TR_" + eval(MaxID + 1));
	                listview.AddDataRow(objTr, loadXMLString(strXML));
	            }
	        }
	    }
	    function isExistDept(ExtFlag) {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
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
	            alert("ezReceiveDistributeUI_Cross_isExistDept::" + e.description);
	        }
	    }
	    function DuplicateAprDeptCheck(APRDEPT, arrUserInfo) {
	        var listview = new ListView();
	        listview.LoadFromID("listAPRLINE1");
	        var AprDeptList = listview.GetDataRows();
	        var AprDeptListLen = AprDeptList.length;
	        var i;
	
	        for (i = 0 ; i < AprDeptListLen; i++) {
	            if (AprDeptList[0].getAttribute("DATA1") == null) {
	                return true; break;
	            }
	            if (AprDeptList[i].getAttribute("DATA1") == arrUserInfo) {
	                return false;
	                break;
	            }
	        }
	        return true;
	    }
	    function isgetUser(DeptID) {
	        var rtnVal = true;
	        var xmlhttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "DATA");
	        createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
	        createNodeAndInsertText(xmlpara, objNode, "CELL", "displayname;Description;Title;telephonenumber;extensionattribute1");
	        createNodeAndInsertText(xmlpara, objNode, "PROP", "Department");
	        createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");
	
	        xmlhttp.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptMemberList.aspx", false);
	        xmlhttp.send(xmlpara);
	
	        if (getXmlString(xmlhttp.responseXML) == "") rtnVal = false;
	        var nodes = SelectNodes(xmlhttp.responseXML, "LISTVIEWDATA/ROWS/ROW");
	        if (rtnVal) {
	            nodeCnt = nodes.length;
	
	            if (nodeCnt > 0)
	                rtnVal = true;
	            else
	                rtnVal = false;
	        }
	        return rtnVal;
	    }
	    function isReceiverChk(DeptID) {
	        var xmlhttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "DATA");
	        createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
	
	        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/Receiver_Chk.aspx", false);
	        xmlhttp.send(xmlpara);
	
	        if (xmlhttp.responseText == "False")
	            return false;
	        else
	            return true;
	    }
	    function removeAllReception() {
	        var listview = new ListView();
	        listview.LoadFromID("listAPRLINE1");
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
	            lvTest.LoadFromID("listAPRLINE1");
	            ListViewLen = lvTest.GetDataRows();
	
	            if (ListViewLen.length == 0) {
	                alert("<spring:message code='ezApprovalG.pjj31'/>");
	                return;
	            }
	            if (ListViewLen.length == 1) {
	                if (GetAttribute(ListViewLen[0], "id") == "listAPRLINE1_TR_noItems") {
	                    alert("<spring:message code='ezApprovalG.pjj31'/>");
	                    return;
	                }
	            }
	
	            var listview = new ListView();
	
	            if (mode == "NEW") {
	                listview.LoadFromID("listAPRLINE1");
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
	
	                    DivPopUpShow(340, 205, windowName);
	                } else {
	                    parameter = parameter + GetShowModalPosition(340, 205);
	
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
	            alert("ezReceiveDistributeUI_Cross_btn_AprDeptTempletSave_onclick::" + e.description);
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
	            alert("ezReceiveDistributeUI_Cross_btn_AprDeptTempletSave_onclick_Complete::" + e.description);
	        }
	    }
	    function CreateNewAprDeptTemplet(p_AprDeptTempletName) {
	        try {
	            var AprDeptTemplet = createXmlDom();
	            var Result;
	            var p_AprDeptTempletID;
	            AprDeptTemplet = AprDeptTempletXmlParsing(p_AprDeptTempletName);
	            var AprDeptXml = APRDeptXMLParsing(APRLINE1, pDocID);
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
	            xmlhttp.open("POST", "/ezApprovalG/createAprDeptTemplet.do", false);
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
	            alert("ezReceiveDistributeUI_Cross_CreateNewAprDeptTemplet::" + e.description);
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
	            createNodeInsert(xmlpara, objNode, "APRDEPT");
	            createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	            createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);
	            createNodeAndInsertText(xmlpara, objNode, "pAprDeptSN", p_AprDeptSN);
	            createNodeAndInsertText(xmlpara, objNode, "p_AprDeptTempletName", p_AprDeptTempletName);
	
	            return xmlpara;
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_AprDeptTempletXmlParsing::" + e.description);
	        }
	    }
	    function APRDeptXMLParsing(APRDEPT, pDocID) {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            var AprDeptRow = listview.GetDataRows();
	            var CurListLen = AprDeptRow.length;
	            var CurCellLen = 0;
	            var i;
	            var j;
	            var GetXml;
	
	            if (AprDeptRow.length == 0)
	                return;
	            if (AprDeptRow[0].getAttribute("id") == "listAPRLINE1_TR_noItems")
	                return;
	
	            GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang170 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang171 + "</NAME><WIDTH>600</WIDTH></HEADER></HEADERS>";
	            GetXml = GetXml + "<ROWS>";
	
	            var SeqNo = 1;
	
	            for (i = 0; i < CurListLen; i++) {
	                GetXml = GetXml + "<ROW>";
	                GetXml = GetXml + "<COLUMN>" + MakeXMLString(SeqNo.toString()) + "</COLUMN>";
	                GetXml = GetXml + "<COLUMN>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA4")) + "</COLUMN>";
	                GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceiptPointID'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA1")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='ExtReceptYN'>N</DATA >";
	                GetXml = GetXml + "<DATA name='ProcessYN'>N</DATA>";
	                GetXml = GetXml + "<DATA name='CanEditYN'>N</DATA>";
	                GetXml = GetXml + "<DATA name='ExtReceptEmail'>" + MakeXMLString(CompanyID) + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceiptMemberID'>" + "" + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceiptMemberName'>" + "" + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle'>" + "" + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprMemberDeptName'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA4")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='AprMemberDeptName2'>" + MakeXMLString(AprDeptRow[i].getAttribute("DATA5")) + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceiptMemberName2'>" + "" + "</DATA>";
	                GetXml = GetXml + "<DATA name='ReceiptMemberJobTitle2'>" + "" + "</DATA>";
	                GetXml = GetXml + "</ROW>";
	
	                SeqNo++;
	            }
	
	            GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
	
	            return GetXml;
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_APRDeptXMLParsing::" + e.description);
	        }
	    }
	    var xmlhttp;
	    function GetReceptTempletList() {
	        try {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : true,
	        		url : "/ezApprovalG/getReceptTemplist.do",
	        		data : {
	        				userID : pUserID,
	        				formID : pFormID
	        				},
	        		success: function(text){
	        			event_GetReceptTempletList(text);
	        		}        			
	        	});
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_GetReceptTempletList::" + e.description);
	        }
	    }
	    function event_GetReceptTempletList(text) {
	        try {
	            if (document.getElementById("RecSaveList").innerHTML != "") document.getElementById("RecSaveList").innerHTML = "";
	            var liveView = new ListView();
	            liveView.SetID("lvRecSaveList");
	            liveView.SetRowOnClick("lvRecSaveList_onSel_Click");
	            liveView.SetSelectFlag(true);
	            liveView.SetHeightFree(true);
	            liveView.DataSource(loadXMLString(text));
	            liveView.DataBind("RecSaveList");
	
	            var pCurSelRow = liveView.GetSelectedRows();
	            if (pCurSelRow.length != 0) {
	                GetReceptTempletInfo(pCurSelRow[0].getAttribute("DATA1"));
	            }
	            else {
	                document.getElementById("RecSaveDetail").innerHTML = "";
	            }
	        }
	        catch (e) {
	            alert("ezReceiveDistributeUI_Cross_event_GetReceptTempletList::" + e.description);
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
	        		url : "/ezApprovalG/getAprDeptTempletListInfo.do",
	        		data : {
	        				userID : pUserID,
	        				formID : pFormID,
	        				aprSN  : p_AprLineTempletID
	        				},
	        		success: function(text){
	        			event_GetReceptTempletInfo(text);
	        		}        			
	        	});
	
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_GetReceptTempletInfo::" + e.description);
	        }
	    }
	    function event_GetReceptTempletInfo(text) {
	        try {
	            if (document.getElementById("RecSaveDetail").innerHTML != "")
	                document.getElementById("RecSaveDetail").innerHTML = "";
	            var pAPRTEMP = new ListView();
	            pAPRTEMP.SetID("lvRecSaveDetail");
	            pAPRTEMP.SetMulSelectable(false);
	            pAPRTEMP.SetHeightFree(true);
	            pAPRTEMP.SetSelectFlag(false);
	            pAPRTEMP.DataSource(loadXMLString(text));
	            pAPRTEMP.DataBind("RecSaveDetail");
	        }
	        catch (e) {
	            alert("ezReceiveDistributeUI_Cross_event_GetReceptTempletInfo::" + e.description);
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
	            alert("ezReceiveDistributeUI_Cross_btn_AprDeptTempletDel_onclick::" + e.description);
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
	        		url : "/ezApprovalG/delAprDeptTempletList.do",
	        		data : {
	        				userID : pUserID,
	        				formID : pFormID,
	        				aprSN  : p_SelAprDeptTempletSN
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
	            alert("ezReceiveDistributeUI_Cross_DelAprDeptTempletList::" + e.description);
	        }
	    }
	    function btn_AprDeptTempletAdd_onclick() {
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
	        } else {
	            AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN);
	            pAprDeptTempletUseFlag = false;
	        }
	    }
	    function AddToAprDeptFromAprDeptTemplet(p_CheckAprDeptTempletSN) {
	        try {
	        	var result = "";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/getAprDeptTempletListInfo.do",
	        		data : {
	        				userID : pUserID,
	        				formID : pFormID,
	        				aprSN  : p_CheckAprDeptTempletSN
	        				},
	        		success: function(xml){
	        			result = loadXMLString(xml);
	        		}        			
	        	});
	
	            SetBaeBuList(result);
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_AddToAprDeptFromAprDeptTemplet::" + e.description);
	        }
	    }
	    function SetBaeBuList(pstrXML) {
	        try {
	            var listnodes = SelectNodes(pstrXML, "LISTVIEWDATA/ROWS/ROW");
	
	            var strXML;
	            var objXML = createXmlDom();
	            var listview = new ListView();
	            listview.LoadFromID("listAPRLINE1");
	            var objRows = listview.GetDataRows();
	            var lastRowIdx = listview.GetDataRows().length;
	
	            if (GetAttribute(objRows[0], "id") == "listAPRLINE1_TR_noItems") {
	                listview.DeleteRow("listAPRLINE1_TR_noItems");
	                lastRowIdx = 1;
	            }
	
	            for (var cnt = 0; cnt < listnodes.length; cnt++) {
	
	                var chkDuplflag = false;
	                for (var i = 0; i < objRows.length; i++) {
	                    if (GetAttribute(objRows[i], "DATA1").toLowerCase() == getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[1], "DATA1").toLowerCase()) {
	                        chkDuplflag = true;
	                        if (getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[1], "DATA1").toLowerCase() == arr_userinfo[4].toLowerCase() && "${USE_SELFDISTRIBUTE}" == "N") {
	                            chkDuplflag = true;
	                        }
	                    }
	                }
	
	                if (chkDuplflag) {
	                    continue;
	                } else {
	
	                    strXML = "<LISTVIEWDATA><HEADERS>";
	                    strXML = strXML + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t428'/>" + "</NAME><WIDTH>156</WIDTH></HEADER>";
	                    strXML = strXML + "</HEADERS><ROWS><ROW><CELL>";
	                    strXML = strXML + "<VALUE>" + MakeXMLString(getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[6], "DATA6")) + "</VALUE>";
	                    strXML = strXML + "<DATA1>" + getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[1], "DATA1") + "</DATA1>";
	                    strXML = strXML + "<DATA2>" + "" + "</DATA2>";
	                    strXML = strXML + "<DATA3>" + "" + "</DATA3>";
	                    strXML = strXML + "<DATA4>" + MakeXMLString(getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[6], "DATA6")) + "</DATA4>";
	                    strXML = strXML + "<DATA5>" + MakeXMLString(getNodeText(GetChildNodes(GetChildNodes(listnodes[cnt])[0])[6], "DATA6")) + "</DATA5>";
	                    strXML = strXML + "</CELL></ROW></ROWS></LISTVIEWDATA>";
	                    objXML = loadXMLString(strXML);
	
	                    var tr = listview.GetSelectedRows();
	                    var InitTr = listview.GetDataRows();
	                    var MaxID = 0;
	
	                    for (var j = 0  ; j < InitTr.length  ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        if (MaxID < curnum)
	                            MaxID = curnum;
	                    }
	
	                    if (tr.length == 0) {
	                        if (InitTr.length == 0) {
	                            if (document.getElementById("APRLINE1").innerHTML != "")
	                                document.getElementById("APRLINE1").innerHTML = "";
	
	                            var listview = new ListView();
	                            listview.SetID("listAPRLINE1");
	                            listview.SetMulSelectable(false);
	                            listview.SetRowOnDblClick("btn_DeptDel_onclick");
	                            listview.SetSelectFlag(false);
	                            listview.DataSource(objXML);
	                            listview.DataBind("APRLINE1");
	                        } else {
	                            var objTr = listview.NewAddRow(0, "listAPRLINE1" + "_TR_" + eval(MaxID + 1));
	                            listview.AddDataRow(objTr, objXML);
	                        }
	                    } else {
	                        var objTr = listview.NewAddRow(0, "listAPRLINE1" + "_TR_" + eval(MaxID + 1));
	                        listview.AddDataRow(objTr, objXML);
	                    }
	
	                }
	            }
	        } catch (e) {
	            alert("ezReceiveDistributeUI_Cross_SetBaeBuList::" + e.description);
	        }
	    }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t427'/></h1>
	    <div class="portlet_tabpart02">
	        <div class="portlet_tabpart02_top" id="tab1">
	            <p id="showAprLine"><span divname="Lineinfo" id="1tab1"><spring:message code='ezApprovalG.t427'/></span></p>
	        </div>
	    </div>
	    <table>
	        <tr>
	            <td style="vertical-align: top;">
	                <div class="portlet_tabpart01" style="margin-top: 3px; text-align: right;">
	                    <div class="portlet_tabpart01_top" id="tab3">
	                        <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
	                        <p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
	                    </div>
	                </div>
	                <div id="Organ">
	                    <div style="overflow: auto; height: 550px; width: 388px; background-color: #FFFFFF; border: 1px solid #b6b6b6" id="TreeView"></div>
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
	                    <img id="AddAllSubDepts" style="border: 0px; width: 16px; height: 16px; cursor: pointer;" src="/images/arr_rr.gif" onclick="return AddReceptAll();" />
	                    <img id="AprlineAdd" style="border: 0px; width: 16px; height: 16px; cursor: pointer;" src="/images/arr_r.gif" onclick="return TreeViewNodeDbClick();" />
	                    <img id="AprlineDel" style="border: 0px; width: 16px; height: 16px; cursor: pointer;" src="/images/arr_l.gif" onclick="return btn_DeptDel_onclick();" />
	                    <img id="RemoveAllList" style="border: 0px; width: 16px; height: 16px; cursor: pointer;" src="/images/arr_ll.gif" onclick="return removeAllReception();" />
	                </div>
	            </td>
	            <td style="vertical-align: top;">
	                <h2 class="h2_dot"><spring:message code='ezApprovalG.t432'/></h2>
	                <div class="listview">
	                    <div id="APRLINE1" style="border: 0; Width: 550px; Height: 550px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                </div>
	                <div style="text-align: right;">
	                    <a class="imgbtn" style="padding-right: 5px; margin-top: 5px;"><span id="Span5" onclick="return btn_AprDeptTempletSave_onclick('NEW')"><spring:message code='ezApprovalG.G0009'/></span></a>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
	        <a class="imgbtn"><span onclick="return btnCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
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