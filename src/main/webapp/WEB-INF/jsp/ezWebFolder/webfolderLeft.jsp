<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" >	        
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		    };

		    function LoadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID) {
		        pObjSpan.parentElement.onclick();
		        var TreeCtrl = getFirstChild(pObjSpan.parentElement);
		        TreeCtrl.onclick();
		
		        TreeCtrl.onclick();
		        var selectItem;
		
		        var totalboard = "";
		        if (pObjSpan.parentElement.nextSibling.nodeType == 1) {
		            totalboard = getFirstChild(pObjSpan.parentElement.nextSibling);
		        }
		        else {
		            totalboard = getFirstChild(pObjSpan.parentElement.nextSibling.nextSibling);
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
		                cnt += rtnval;
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
		                    selectItem.childNodes[0].click();
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

		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");
		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            } else {
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
		
		                if (gubun == 3){
		                    window.parent.frames["right"].location.href = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
		                }
		                else if (gubun == 4){
		                    window.parent.frames["right"].location.href = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
		                }
		                else {
		                    if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		                        window.parent.frames["right"].location.href = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=N";
		                    }
		                    else{
		                        window.parent.frames["right"].location.href = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
		                    }
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
		        xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + SelBoardID, false);
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

		        xmlRtn = GetMyBoardItem(treeNode.GetNodeData("DATA1"));
		        
		        try {
		        	if (SelectNodes(xmlRtn, "TREEVIEWDATA/NODE/VALUE").length > 0) {
			            if (CrossYN()) {
			                xmlRtn.getElementsByTagName("TREEVIEWDATA")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("TREEVIEWDATA")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
			            }
			            else {
			                xmlRtn.selectNodes("TREEVIEWDATA/NODE")[0].appendChild(xmlRtn.selectNodes("TREEVIEWDATA/NODE/VALUE")[0]);
			            }
			        } 
				} catch (e) {
			        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
			            if (CrossYN()) {
			                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
			            }
			            else {
			                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
			            }
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
		                window.parent.frames["right"].location.href = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
		            else if (chkPhotoBrd == 4)
		                window.parent.frames["right"].location.href = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
		            else {
		                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		                    window.parent.frames["right"].location.href = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=N";
		                }
		                else{
		                    window.parent.frames["right"].location.href = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
		                }
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    function DisplayTopBoard() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=top&subFlag=0", false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText != "ERROR") {
		            MakeTopBoardView(xmlhttp.responseText);
		        }
		        xmlhttp = null;
		    }
		
		    function ShowMyBoardItem(val01) {
		    	$(".on").attr("class", "off");
		    	$(".myb h2").attr("class", "on");
		    	$(".myb").next().attr("class", "on");
		    	
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
		    	var returnXML = "";
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getMyBoardsConfig.do",	        			
					data : { rootTreeID : pRootTreeID, 
							 countFlag : "YES"},
					success: function(xml){
						returnXML = xml;
					}        			
				});	
//FreeT 요구사항 마이게시판 트리 없을때 안보여주기~
//다시 메뉴 스펙이 바껴서 트리 안보여주기 없어도 안보여줄수있어서 재수정
// 		    	if (returnXML == "<TREEVIEWDATA></TREEVIEWDATA>") {
// 		    		$("#TreeCtrl_MyBoardTree").css("display", "none");
// 		    	} else {
// 		    		$("#TreeCtrl_MyBoardTree").css("display", "");
// 		    	}
		    	
		    	return loadXMLString(returnXML);
		    }
		    var tempID;
		    var clickFlag = false;
		    
		    function TopBoard_onclick(obj, ID) {
		    	//leftcount refresh 때문에 주석중 사이드 이펙트 검사필수
// 		        if (tempID == ID)
// 		            clickFlag = true;
// 		        else
// 		            clickFlag = false;

// 		        if (!clickFlag) {
					$(".on").attr("class", "off");
					
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
// 		        }
		    }
		    
		    function GetSubBoard(pRootBoardID, pSubFlag) {
		    	var xmlhttp3 = createXMLHttpRequest();
		        xmlhttp3.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0", false);
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
		        for (var i = 0; i < xmldomNodes.length; i++) {
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
		    
		    function DeleteMyBoard() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
		        if (treeNode.GetNodeData("DATA1") == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
		            alert("<spring:message code='ezBoard.t362' />");
		            return;
		        }
		        var ret = confirm(treeNode.GetNodeData("DATA2") + "<spring:message code='ezBoard.t363' />");
		        if (ret) {
		            var xmlhttp5 = createXMLHttpRequest();
		            xmlhttp5.open("POST", "/ezBoard/deleteMyBoard.do?boardID=" + treeNode.GetNodeData("DATA1"), false);
		            xmlhttp5.send();
		            xmlhttp5 = null;
		            document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		            treeView.DataSource(GetMyBoardItem());
		            treeView.DataBind('TreeCtrl_MyBoardTree');
		        }
		    }
		    function Open_Func(idx) {
		    	$(".on").attr("class", "off");
		    	$(".qst h2").attr("class", "on");
		    	$(".qst").next().attr("class", "on");
		    	
		        if (CrossYN()) {
		            if (idx == 1) {
		                window.parent.frames["right"].location.href = "/ezQuestion/qstList.do?brdID=5";
		            }
		            else {
		                window.parent.frames["right"].location.href = "/ezQuestion/qstStep1.do?brdID=5";
		            }
		        } else {
		            if (idx == 1)
		                window.parent.frames["right"].location.href = "/ezQuestion/qstList.do?brdID=5";
		            else
						window.parent.frames["right"].location.href = "/ezQuestion/qstStep1.do?brdID=5";
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
		    	$(".on").attr("class", "off");
		    	$(".fList h2").attr("class", "on");
		    	$(".fList").next().attr("class", "on");
		    	
		        window.parent.frames["right"].location.href = "/ezBoard/boardItemList_favorite.do";
		    }
		    function ConfigMyBoard() {
		        var OpenWin = window.open("/ezBoard/myBoardConfig.do?type=CONFIG", "MyBoardConfig", GetOpenWindowfeature(450, 415));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function MyBoard() {
		        window.parent.frames["right"].location.href = "/ezBoard/boardItemListMyList.do";
		    }
		    function TempBoard() {
		        window.parent.frames["right"].location.href = "/ezBoard/boardItemListTemp.do";
		    }
		    function boardConfig() {
		        window.parent.frames["right"].location.href = "/ezBoard/boardConfig.do";
		    }
		    function ReservationItem_onclick() {
		        window.parent.frames["right"].location.href = "/ezBoard/boardReservedItemList.do";
		    }
		    function Apprboard() {
		        window.parent.frames["right"].location.href = "/ezBoard/boardItemListAppr.do";
		    }
		    
		    
		    function goPage(idx) {
		    	switch (idx) {
		    		case 3:
		    			var url = "/ezWebFolder/test.do";
		    			window.parent.frames["right"].location.href = url;
		    			break;		    		
		    	}
		    }
	    </script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
	    <div id="left" style="overflow: auto">
	        <div class="left_webfolder" title="<spring:message code='ezWebFolder.t10' />"></div>	        
			<h2>
  				<span style="display:inline-block;width:100%;">회사폴더</span>
  			</h2>  
    		<ul>
		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >가온아이</span></li>
		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >하위폴더</span></li>		        
		    </ul>  	
		    
		    <h2>
  				<span style="display:inline-block;width:100%;">부서폴더</span>
  			</h2>  
    		<ul>
		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="goPage(3)" >오픈솔루션팀</span></li>
		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >ezEKP</span></li>		        
		    </ul>  
		    	
		   	<h2>
  				<span style="display:inline-block;width:100%;">개인폴더</span>
  			</h2>  
    		<ul>
		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >영화</span></li>
		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >문서</span></li>		        
		    </ul>  
		    
		    <h2>
  				<span style="display:inline-block;width:100%;">공유폴더</span>
  			</h2>  
    		<ul>
		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >공유받은 폴더</span></li>
		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >공유한 폴더</span></li>		        
		    </ul>  
		    
		    <h2>
  				<span style="display:inline-block;width:100%;">츨겨찾기</span>
  			</h2>  
    		<ul>
		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >테스트 5</span></li>
		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >테스트 6</span></li>		        
		    </ul>  	   
		    
		    <h2>
  				<span style="display:inline-block;width:100%;">휴지통</span>
  			</h2>  
    		<ul>
		        <li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >테스트  7</span></li>
		        <li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >테스트  8</span></li>		        
		    </ul>       

	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");	        
	    </script>
	</body>
</html>