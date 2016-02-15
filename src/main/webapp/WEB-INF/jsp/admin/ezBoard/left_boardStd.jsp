<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css">
		<title></title>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" language="javascript">
	        var SSUserID = "${user.id}";
	        var SSUserName = "${user.displayName1}";
	        var SSDeptID = "${user.deptID}";
	        var SSDeptName = "${user.deptName1}";
	        var SSCompanyID = "${user.companyID}";
	        var SSCompanyName = "${user.companyName1}";
	        var xmlhttp = createXMLHttpRequest();
	        var SelectedBoardID = "";
	        var SelectedBoardParentBoardID = "";
	        var SelectedBoardGroupID = "";
	        var SS_ServerName = "test.yoonz44.com";
	        var xmlDom_treeview = createXmlDom();
	        var curMenuIndex = 1;
	        var TopBoardID_01;
	        var TreeCtrl_onNodeClick_01;
	        
	        var RedirectBoardGroupID = "${redirectBoardGroupID}";
	        var RedirectBoardID = "${redirectBoardID}";
	   
		    window.onload = function () {  
		    	if (RedirectBoardID != "") {
	                if (RedirectBoardGroupID != "") {
	                    BoardRedirect();
	                    return;
	                }	                
	            }
		    }
		    function BoardRedirect() {
		        var spans = document.getElementById("TopBoardsList").getElementsByTagName("div");
		        for (var i = 0 ; i < spans.length ; i++) {
		            if (spans[i].getAttribute("value") == RedirectBoardGroupID) {
		                LoadTreeViewByPath(spans[i], RedirectBoardID, RedirectBoardGroupID);
		            }
		        }
		    }
		    function LoadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID) {
	            pObjSpan.parentElement.onclick();
	            var TreeCtrl = getFirstChild(pObjSpan.parentElement);
	            TreeCtrl.onclick();

	            TreeCtrl.onclick();
	            var selectItem;

	            var totalboard = "";
	            if (pObjSpan.parentElement.nextSibling.nodeType == 1) {
	                totalboard = getFirstChild(pObjSpan.parentElement.nextSibling)
	            }
	            else {
	                totalboard = getFirstChild(pObjSpan.parentElement.nextSibling.nextSibling)
	            }

	            var cnt = totalboard.children[0].getElementsByTagName("div").length;

	            for (var i = 0; i < cnt; i++) {
	                if (RedirectBoardID == totalboard.children[0].getElementsByTagName("div")[i].getAttribute("data1")) {
	                    selectItem = totalboard.children[0].getElementsByTagName("div")[i];
	                    break;
	                }
	                else {
	                    var parentNodeid = totalboard.children[0].getElementsByTagName("div")[i].id;
	                    var imgtag = "imgNode_" + totalboard.children[0].getElementsByTagName("div")[i].id;
	                    if (imgtag.indexOf("sub") > -1) {
	                        var treecnt = document.getElementById(parentNodeid).childNodes.length;
	                        cnt += treecnt;
	                    }

	                    var rtnval = SearchTreeViewByPath(imgtag, parentNodeid);
	                    cnt += rtnval
	                }
	            }
	            selectItem.getElementsByTagName("span")[0].onclick();
	            var tempid = selectItem.id.split("_");
	            var tempidlength = tempid.length;
	            var clicknode = new Array();
	            if (CrossYN()) {
	                for (var i = 0; i < tempidlength; i++) {
	                    if (selectItem.getAttribute("DATA3") != pBoardGroupID) {
	                        if (selectItem.id != null && selectItem.id != "0" && selectItem.id.indexOf("sub") == -1)
	                            clicknode[i] = selectItem.id;
	                        else
	                            i--;
	                        selectItem = selectItem.parentElement;
	                    }
	                    else if (selectItem.getAttribute("DATA3") == pBoardGroupID) {
	                        selectItem.childNodes[0].onclick();
	                        var j = clicknode.length;
	                        for (var k = j; k > 0; k--) {
	                            document.getElementById(clicknode[k - 1]).childNodes[k - 1].onclick();
	                        }
	                        return;
	                    }
	                }
	            }
	            else {
	                for (var i = 0; i < tempidlength; i++) {
	                    if (selectItem.getAttribute("DATA3") != pBoardGroupID) {
	                        if (selectItem.id != null && selectItem.id != "0" && selectItem.id.indexOf("sub") == -1)
	                            clicknode[i] = selectItem.id;
	                        else
	                            i--;
	                        selectItem = selectItem.parentElement;
	                    }
	                    else if (selectItem.getAttribute("DATA3") == pBoardGroupID) {
	                        selectItem.childNodes[0].click();
	                        var j = clicknode.length;
	                        for (var k = j; k > 0; k--) {
	                            document.getElementById(clicknode[k - 1]).childNodes[k - 1].click();
	                        }
	                        return;
	                    }
	                }
	            }
	        }
		    function SearchTreeViewByPath(imgtag, parentNodeid) {
		        if (imgtag.indexOf("sub") == -1 && document.getElementById(imgtag).src.indexOf("plus") > -1) {
		            document.getElementById(imgtag).onclick();
		            document.getElementById(imgtag).onclick();
		            return 0;
		        }
		        else {
		            return document.getElementById(parentNodeid).childNodes.length;
		        }
		    }
		
		    function GetBoardTreeByPath(pBoardID, pBoardGroupID) {
		    }
		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")
		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            }
		            else {
		                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
		            }
		        }
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
		    function TreeCtrl_onNodeClickNew(pNodeID, pTreeID) {
		        try {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);
		            var SelectedBoardID = treeNode.GetNodeData("DATA3");
		            var selectedBoardtype = treeNode.GetNodeData("DATA4");
		            var SelectedBoardName = treeNode.GetNodeData("VALUE");
		            //var SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
		            //var chkPhotoBrd = treeNode.GetNodeData("DATA5");
		            if (selectedBoardtype == "BOARD" || SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		
		                GetBoardInfo(SelectedBoardID);
		
		                if (gubun == 3)
		                    window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Photo.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(pBoardName) + "&BoardType=" + gubun;
		                else if (gubun == 4)
		                    window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Thumbnail.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(pBoardName) + "&BoardType=" + gubun;
		                else {
		                    if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		                        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/New_BoardItemList.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(pBoardName) + "&BoardType=N";
		                    }
		                    else
		                        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(pBoardName) + "&BoardType=" + gubun;
		                }
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    var pBoardName = "";
		    var AttachLimit = "";
		    var ExpireDays = "";
		    var gubun = "";
		    function GetBoardInfo(SelBoardID) {
		        var xmlhttp_boardinfo = createXMLHttpRequest();
		        xmlhttp_boardinfo.open("POST", "interASP/GetBoardInfo.aspx?BoardID=" + SelBoardID, false);
		        xmlhttp_boardinfo.send();
		        if (xmlhttp_boardinfo.status == 200) {
		            pBoardName = getNodeText(SelectNodes(xmlhttp_boardinfo.responseXML, "BOARDNAME")[0]);
		            AttachLimit = getNodeText(SelectNodes(xmlhttp_boardinfo.responseXML, "ATTACHLIMIT")[0]);
		            ExpireDays = getNodeText(SelectNodes(xmlhttp_boardinfo.responseXML, "EXPIREDAYS")[0]);
		            gubun = getNodeText(SelectNodes(xmlhttp_boardinfo.responseXML, "GUBUN")[0]);
		        }
		        xmlhttp_boardinfo = null;
		    }
		    function TreeCtrl_onNodeExpandedNew(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        xmlRtn = GetMyBoardItem(treeNode.GetNodeData("DATA1"))
		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            }
		            else {
		                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
		            }
		        }
		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
		
		    function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
		        try {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);
		            var SelectedBoardID = treeNode.GetNodeData("DATA1");
		            var SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
		            var chkPhotoBrd = treeNode.GetNodeData("DATA5");
		
		            if (chkPhotoBrd == 3)
		                window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Photo.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(treeNode.GetNodeData("DATA2")) + "&BoardType=" + chkPhotoBrd;
		            else if (chkPhotoBrd == 4)
		                window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Thumbnail.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(treeNode.GetNodeData("DATA2")) + "&BoardType=" + chkPhotoBrd;
		            else {
		                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		                    window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/New_BoardItemList.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(treeNode.GetNodeData("DATA2")) + "&BoardType=N";
		                }
		                else
		                    window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(treeNode.GetNodeData("DATA2")) + "&BoardType=" + chkPhotoBrd;
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    function DisplayTopBoard() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/myoffice/ezBoardSTD/interASP/GetSubBoards.aspx?RootBoardID=top&SubFlag=0", false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText != "ERROR") {
		            MakeTopBoardView(xmlhttp.responseText);
		        }
		        xmlhttp = null;
		    }
		
		    function ShowMyBoardItem() {
		        SetTreeConfig();
		        document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		        var treeView = new TreeView();
		        treeView.SetID("FromTreeView");
		
		        treeView.SetNodeClick("TreeCtrl_onNodeClickNew");
		        treeView.SetRequestData("TreeCtrl_onNodeExpandedNew");
		        treeView.DataSource(GetMyBoardItem("0"));
		        treeView.DataBind("TreeCtrl_MyBoardTree");
		        first++;
		    }
		    function GetMyBoardItem(pRootTreeID) {
		        var xmlhttp4 = new XMLHttpRequest();
		        xmlhttp4.open("POST", "/kaoni/test/web/GetMyBoards_Config.do?RootTreeID=" + pRootTreeID + "&COUNTFLAG=YES", false);
		        //xmlhttp4.open("POST", "/myoffice/ezBoardSTD/interASP/GetMyBoards.aspx", false);
		        xmlhttp4.send();
		        var ret = xmlhttp4.responseXML;
		        xmlhttp4 = null;
		        return ret;
		    }
		    var tempID;
		    var clickFlag = false;
		    function TopBoard_onclick(obj, ID) {
		        if (tempID == ID)
		            clickFlag = true;
		        else
		            clickFlag = false;
		
		        if (!clickFlag) {    
		            var rootBoardID = ID;
		            var num = obj.split("TreeCtrl");
		            document.getElementById(obj + "obj").innerHTML = "";
		            SetTreeConfig();
		            var treeView = new TreeView();
		            treeView.SetID("TreeView" + obj);
		            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
		            treeView.SetNodeClick("TreeCtrl_onNodeClick");
		            treeView.DataSource(GetSubBoard(rootBoardID, "1"));
		            treeView.DataBind(obj + "obj");
		            tempID = ID;
		        }
		    }
		    function GetSubBoard(pRootBoardID, pSubFlag) {
		        var xmlhttp3 = createXMLHttpRequest();
		        xmlhttp3.open("POST", "/myoffice/ezBoardSTD/interASP/GetSubBoards.aspx?RootBoardID=" + pRootBoardID + "&SubFlag=" + pSubFlag + "&SelectFlag=0", false);
		        xmlhttp3.send();
		        var ret = xmlhttp3.responseXML;
		        xmlhttp3 = null;
		        return ret;
		    }
		    function MakeTopBoardView(strXML) {
		        var xmldom = createXmlDom();
		        var strHTML = "";
		        xmldom = loadXMLString(strXML);
		        strHTML = "";
		        var xmldomNodes = SelectNodes(xmldom, "TREEVIEWDATA/NODE");
		        for (i = 0; i < xmldomNodes.length; i++) {
		            var tid = SelectSingleNodeValue(xmldomNodes[i], "DATA1");
		            tid = tid.substring(1, 37);
		            strHTML += "<h2><span id='TreeCtrl" + i.toString() + "' value='" + SelectSingleNodeValue(xmldomNodes[i], "DATA1") + "' onclick='TopBoard_onclick(\"TreeCtrl" + i.toString() + "\" ,\"" + tid + "\"" + ")'>" + SelectSingleNodeValue(xmldomNodes[i], "DATA2") + "</span></h2>";
		            strHTML += "  <ul>";
		            strHTML += "	  <div  class='tree' id='TreeCtrl" + i.toString() + "obj" + "' style='display:none;height:auto;width:auto;overflow-x:auto;overflow-y:auto;padding-left:10px' ></div>";
		            strHTML += "  </ul>";
		        }
		        xmldomNodes = null;
		        xmldom = null;
		        document.getElementById("TopBoardsList").innerHTML = strHTML;
		    }
		    function AdminMenu_onclick() {
		        window.open("/myoffice/ezBoardSTD/admin/index_admin.aspx", "", "height=" + window.screen.availHeight + ",width=" + window.screen.availWidth + ", status = no, toolbar=no, menubar=no, location=no, resizable=1, left=0, top=0", "");
		    }
		    function DeleteMyBoard() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
		        if (treeNode.GetNodeData("DATA1") == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		            alert("새 게시 게시판은 삭제할 수 없습니다.");
		            return;
		        }
		        var ret = confirm(treeNode.GetNodeData("DATA2") + " 게시판을 마이게시판에서 삭제하시겠습니까?");
		        if (ret) {
		            var xmlhttp5 = createXMLHttpRequest();
		            xmlhttp5.open("POST", "/myoffice/ezBoardSTD/interASP/DeleteMyBoard.aspx?BoardID=" + treeNode.GetNodeData("DATA1"), false);
		            xmlhttp5.send();
		            xmlhttp5 = null;
		            document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		            treeView.DataSource(GetMyBoardItem());
		            treeView.DataBind('TreeCtrl_MyBoardTree');
		        }
		    }
		    function OrderMyBoard() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var ret;
		        ret = showModalDialog("MyBoardOrder_Cross.aspx", null, "dialogHeight:350px; dialogWidth:305px; status:no; help:no; scroll:no; edge:sunken");
		        if (ret == 1) {
		            document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		            treeView.DataSource(GetMyBoardItem());
		            treeView.DataBind('TreeCtrl_MyBoardTree');
		        }
		    }
		    function Open_Func(idx) {
		        if (CrossYN()) {
		            if (idx == 1) {
		                window.parent.frames["right"].location.href = "/myoffice/ezQuestion/poll/Qst_List_Cross.aspx?brd_ID=5";
		            }
		            else {
		                window.parent.frames["right"].location.href = "/myoffice/ezQuestion/poll/Qst_Step1_Cross.aspx?brd_ID=5";
		            }
		        } else {
		            if (idx == 1)
		                window.parent.frames["right"].location.href = "/myoffice/ezQuestion/poll/Qst_List.aspx?brd_ID=5";
		            else
						window.parent.frames["right"].location.href = "/myoffice/ezQuestion/poll/Qst_Step1_Cross.aspx?brd_ID=5";
		                //window.parent.frames["right"].location.href = "/myoffice/ezQuestion/poll/Qst_Step1.aspx?brd_ID=5"
		            SetTreeviewUnSelect("");
		        }
		    }
		    function WebPartToggle(obj) {
		        for (var i = 0; i < level1El.length; i++) {
		            if (i != obj.listNum) {
		                level1El.item(i).className = "off";
		                level2El.item(i).className = "off";
		            }
		            else {
		                level1El.item(i).className = "on";
		                level2El.item(i).className = "on";
		            }
		        }
		        currentListNum = obj.listNum;
		        setMenu(level2El.item(obj.listNum));
		    }
		    function SetTreeviewUnSelect(TreeviewID) {
		        if (TreeviewID != "TreeCtrl_MyBoardTree_ul") {
		        }
		        for (var i = 0; i < items; i++) {
		            if (TreeviewID != "TreeCtrl" + i + "obj") {
		            }
		        }
		    }
		    function SetTreeConfig() {
		        var xmlHTTP = new XMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
		        xmlHTTP.send();
		
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
		    function favoriteList() {
		        window.parent.frames["right"].location.href = "/ezEKP/ezBoard/web/boardItemList_Favorite.do";
		    }
		    function ConfigMyBoard() {
		        var OpenWin = window.open("/myoffice/ezBoardSTD/MyBoardConfig.aspx?TYPE=CONFIG", "MyBoardConfig", GetOpenWindowfeature(450, 415));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function MyBoard() {
		        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_MyList.aspx";
		    }
		    function TempBoard() {
		        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Temp.aspx";
		    }
		    function board_config() {
		        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/Board_config.aspx";
		    }
		    function ReservationItem_onclick() {
		        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardReservedItemList_Cross.aspx?";
		    }
		    function Apprboard() {
		        window.parent.frames["right"].location.href = "/myoffice/ezBoardSTD/BoardItemList_Appr.aspx";
		    }
	    </script>
	</head>
	<body class="leftbody" style="overflow-y: auto; overflow-x: hidden">
	    <div id="left">
	        <div class="left_admin"><spring:message code="ezBoard.t58" /></div>
	        <div id="TopBoard">
	        	<script>
	        	
	        	</script>
	        </div>	
	        <h3><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(1)"><spring:message code="ezBoard.t122" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(6)"><spring:message code="ezBoard.t0004" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(7)"><spring:message code="ezBoard.t500" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(2)"><spring:message code="ezBoard.t62" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(3)"><spring:message code="ezBoard.t64" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(4)"><spring:message code="ezBoard.t65" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(5)"><spring:message code="ezBoard.t66" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(8)"><spring:message code="ezBoard.t5006" /></span></h3>
		</div>
	    <script type="text/javascript">
	    	initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	</body>
</html>