<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/email_tree.css" type="text/css">	   	
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css">
		<title><spring:message code="ezBoard.t52" /></title>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
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
	        var SS_ServerName = "${serverName}";
	        var xmlDom_treeview = createXmlDom();
	        var curMenuIndex = 1;
	        var TopBoardID_01;
	        var TreeCtrl_onNodeClick_01;
    
	        //var RedirectBoardGroupID = "${redirectBoardGroupID}";
	        //var RedirectBoardID = "${redirectBoardID}";	   
 
		    function BoardRedirect() {
		        var spans = document.getElementById("TopBoard").getElementsByTagName("div");
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

	        var AccessLevel = "0";
	        function TopBoard_onclick(obj, ID) {
	            AccessLevel = "1";
	            var rootBoardID = ID;
	            SelectedBoardID = ID;
	            SelectedBoardGroupID = ID;
	            SelectedBoardParentBoardID = 'top';
	            var num = obj.split("TreeCtrl");
	            document.getElementById(obj + "obj").innerHTML = "";
	            SetTreeConfig();
	            var treeView = new TreeView();
	            treeView.SetID("TreeView" + obj);
	            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
	            treeView.SetNodeClick("TreeCtrl_onNodeClick");            
	            treeView.DataSource(GetSubBoard(rootBoardID, "1"));
	            treeView.DataBind(obj + "obj");
	        }

	        function SetTreeConfig() {
	            try{
	                var xmlHTTP = createXMLHttpRequest();
	                xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
	                xmlHTTP.send();

	                if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                    var treeView = new TreeView();
	                    treeView.SetConfig(xmlHTTP.responseXML);
	                }
	            }catch(e){
	                alert(e);
	            }
	        }

	        function GetSubBoard(pRootBoardID, pSubFlag) {
	        	$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/admin/ezBoard/getSubBoards.do",	        			
					data : { rootBoardID : pRootBoardID, subFlag : pSubFlag, selectFlag : "0"},
					success: function(result){
						
					}        			
				});	            
	        }

	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            try {
	                AccessLevel = "0";
	                var treeNode = new TreeNode();
	                treeNode.LoadFromID(pNodeID);
	                SelectedBoardID = treeNode.GetNodeData("DATA1");
	                SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
	                var chkPhotoBrd = treeNode.GetNodeData("DATA5");

	                if (RedirectBoardID != "") {
	                    if (RedirectBoardGroupID != "") {
	                        window.parent.frames["board_main"].location.href = "/myoffice/ezBoardSTD/admin/admin_board_config.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(treeNode.GetNodeData("DATA2")) + "&BoardType=" + chkPhotoBrd + "&ParentBoardID=" + SelectedBoardParentBoardID + "&TabId=1tab2";
	                    }
	                }
	                else {
	                    window.parent.frames["board_main"].location.href = "/myoffice/ezBoardSTD/admin/admin_board_config.aspx?BoardID=" + SelectedBoardID + "&BoardName=" + escape(treeNode.GetNodeData("DATA2")) + "&BoardType=" + chkPhotoBrd + "&ParentBoardID=" + SelectedBoardParentBoardID;
	                }
	                
	                
	                
	            }
	            catch (e) {
	                alert(e.description);
	            }
	        }

	        function OpenRightMenu(pIndex) {
	            if (SelectedBoardID == "" && pIndex == 5 && pIndex != 8) {
	                alert("<spring:message code='ezBoard.t56' />");
	                return;
	            }

	            curMenuIndex = pIndex;

	            if (SelectedBoardID == "" && pIndex != 1 && pIndex != 5 && pIndex != 8) {
	                alert("<spring:message code='ezBoard.t56' />");
	                return;
	            }

	            if (SelectedBoardID == SelectedBoardGroupID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 5 && pIndex != 6 && pIndex != 7 && pIndex != 8) {
	                alert("<spring:message code='ezBoard.t138' />");
	                return;
	            }

	            switch (pIndex) {
	                case 1:
	                    window.open("/admin/ezBoard/boardGroupCreate.do", "board_main");
	                    break;
	                case 2:
	                    window.open("/admin/ezBoard/boardCreate.do?parentBoardID=" + SelectedBoardID + "&boardGroupID=" + SelectedBoardGroupID, "board_main");
	                    break;
	                case 3:	                	
	                    window.open("/admin/ezBoard/boardOrder.do?boardID=" + SelectedBoardID + "&parentBoardID=" + SelectedBoardParentBoardID, "board_main");
	                    break;
	                case 4:
	                    if (window.ActiveXObject)
	                        window.open("BoardMove.aspx?BoardID=" + SelectedBoardID + "&BoardGroupID=" + SelectedBoardGroupID, "board_main");
	                    else
	                        window.open("BoardMove_Cross.aspx?BoardID=" + SelectedBoardID + "&BoardGroupID=" + SelectedBoardGroupID, "board_main");
	                    break;
	                case 5:
	                    if (CrossYN())
	                        window.open("BoardDelete_Cross.aspx?BoardID=" + SelectedBoardID + "&BoardGroupID=" + SelectedBoardGroupID, "board_main");
	                    else
	                        window.open("BoardDelete.aspx?BoardID=" + SelectedBoardID + "&BoardGroupID=" + SelectedBoardGroupID, "board_main");
	                    break;
	                case 6:
	                    window.open("/myoffice/ezBoardSTD/admin/BoardProperty.aspx?BoardID=" + SelectedBoardID, "board_main");
	                    break;
	                case 7:
	                    window.open("/myoffice/ezBoardSTD/admin/BoardACL.aspx?PARENTNEED=Y&BoardID=" + SelectedBoardID + "&ParentBoardID=" + SelectedBoardParentBoardID + "&AccessLevel=" + AccessLevel, "board_main");
	                    break;
	                case 8:
	                    window.open("/myoffice/ezBoardSTD/admin/BoardBackGround.aspx?PARENTNEED=Y&BoardID=" + SelectedBoardID + "&ParentBoardID=" + SelectedBoardParentBoardID, "board_main");
	                    break;
	                default:
	                    break;
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
	    </script>
	</head>
	<body class="leftbody" style="overflow-y: auto; overflow-x: hidden">
	    <div id="left">
	        <div class="left_admin"><spring:message code="ezBoard.t58" /></div>
	        <div id="TopBoard"></div>	
	        <h3><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(1)"><spring:message code="ezBoard.t122" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(6)"><spring:message code="ezBoard.t0004" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(7)"><spring:message code="ezBoard.t500" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(2)"><spring:message code="ezBoard.t62" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(3)"><spring:message code="ezBoard.t64" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(4)"><spring:message code="ezBoard.t65" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(5)"><spring:message code="ezBoard.t66" /></span></h3>
	        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(8)"><spring:message code="ezBoard.t5006" /></span></h3>
		</div>
		<script>		
	    	var strHTML = "", data = "";
			var cnt = 0;	        		
			
			$.ajax({
				type : "POST",
				dataType : "json",
				async : false,
				url : "/admin/ezBoard/get_Admin_TopBoardList.do",	        			
				data : { boardType : "top"},
				success: function(result){
					$.each(result, function(idx, item){	        					
						$.each(item, function(idx, i){
							strHTML += "<h2><div AccessLevel='1' id='TreeCtr" + idx + "' value='" + i.boardId;
	                        strHTML += "' onclick=\"TopBoard_onclick('TreeCtrl" + idx + "','" + i.boardId + "')\">";
	                        strHTML += i.boardName + "</div></h2>";
	                        strHTML += "<ul><div class='tree' name='BoardTree' id='TreeCtrl" + idx + "obj' style='width: auto; overflow: auto; padding-left: 10px; padding-bottom: 20px; max-height: 200px;'>";
	                        strHTML += "</div></ul>";
						});
						cnt = item.length;
						data = item[0].boardId;
					});
					$("#TopBoard").html(strHTML);
	
	                if (cnt > 0){         	
						TopBoard_onclick("TreeCtrl0", data);
	                }
				}        			
			});
			
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	    
	</body>
</html>