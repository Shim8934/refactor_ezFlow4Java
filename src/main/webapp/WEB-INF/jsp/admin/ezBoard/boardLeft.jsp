<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code="ezBoard.t52" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">	   	
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	.tree {
	    		min-height : 100px;
	    	}
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
			#mCSB_1_container {
				margin-right: 0px;
			} 
	    </style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" language="javascript">
	        var SSUserID = "<c:out value='${user.id}'/>";
	        var SSUserName = "<c:out value='${user.displayName}'/>";
	        var SSDeptID = "<c:out value='${user.deptID}'/>";
	        var SSDeptName = "<c:out value='${user.deptName}'/>";
	        var SSCompanyID = "<c:out value='${user.companyID}'/>";
	        var SSCompanyName = "<c:out value='${user.companyName}'/>";
	        var xmlhttp = createXMLHttpRequest();
	        var SelectedBoardID = "";
	        var SelectedBoardParentBoardID = "";
	        var SelectedBoardGroupID = "";
	        var SS_ServerName = "<c:out value='${serverName}'/>";
	        var xmlDom_treeview = createXmlDom();
	        var curMenuIndex = 1;
	        var TopBoardID_01;
	        var TreeCtrl_onNodeClick_01;
    
	        var RedirectBoardGroupID = "<c:out value='${redirectBoardGroupID}'/>";
	        var RedirectBoardID = "<c:out value='${redirectBoardID}'/>";	   
	        
	        window.onload = function () {
	            if (RedirectBoardID != "") {
	                if (RedirectBoardGroupID != "") {
	                    BoardRedirect();
	                    return;
	                }
	            }
	        }
 
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

	            var selectItem;
	            var totalboard = "";
	            
	            if (pObjSpan.parentElement.nextSibling.nodeType == 1) {
	                totalboard = getFirstChild(pObjSpan.parentElement.nextSibling)
	            }else{
	                totalboard = getFirstChild(pObjSpan.parentElement.nextSibling.nextSibling)
	            }

	            var cnt = totalboard.children[0].getElementsByTagName("div").length;

	            for (var i = 0; i < cnt; i++) {
	                if (RedirectBoardID == totalboard.children[0].getElementsByTagName("div")[i].getAttribute("data1")) {
	                    selectItem = totalboard.children[0].getElementsByTagName("div")[i];
	                    break;
	                }else{
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
	                        if (selectItem.id != null && selectItem.id != "0" && selectItem.id.indexOf("sub") == -1){
	                            clicknode[i] = selectItem.id;
	                        }else{
	                            i--;
	                        }
	                        selectItem = selectItem.parentElement;
	                    }else if(selectItem.getAttribute("DATA3") == pBoardGroupID) {
	                        selectItem.childNodes[0].onclick();
	                        var j = clicknode.length;
	                        
	                        for (var k = j; k > 0; k--) {
	                            document.getElementById(clicknode[k - 1]).childNodes[k - 1].onclick();
	                        }
	                        return;
	                    }
	                }
	            }else{
	                for (var i = 0; i < tempidlength; i++) {
	                    if (selectItem.getAttribute("DATA3") != pBoardGroupID) {
	                        if (selectItem.id != null && selectItem.id != "0" && selectItem.id.indexOf("sub") == -1){
	                            clicknode[i] = selectItem.id;
	                        }else{
	                            i--;
	                        }
	                        selectItem = selectItem.parentElement;
	                    }else if(selectItem.getAttribute("DATA3") == pBoardGroupID) {
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
	            xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1");
	            
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
	       
	            /* 18-05-18 김민성 - tootip 추가 및 글자수 관련 style 수정 */
		        var node = document.getElementById(TreeIdx);
		        var title2 = node.getElementsByClassName("node_div");
		        var nodeLevel = title2[0].getAttribute("nodelevel");
		        
		        for(var i=0; i<title2.length; i++) {
		        	var spanW = 152 - (18 * nodeLevel);	
		        	title3 = title2[i].getElementsByClassName("node_normal");
		        	title3[0].setAttribute("TITLE", title3[0].parentElement.getAttribute("DATA2"));
		        	
		        	/* 2018-08-24 홍승비 - 게시판명의 width가 음수가 되는 경우 분기 처리 */
		        	if (spanW < 0) {
						 spanW = 0;
					 }
		        	title3[0].style.width = spanW + 'px';
		        	title3[0].style.textOverflow = 'ellipsis';
		        	title3[0].style.overflow = 'hidden';
		        }
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
	            
	            /* 18-05-18 김민성 - tootip 추가 및 글자수 관련 style 수정 */
				var node = $(".node_normal");
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].parentElement.getAttribute("DATA2"));
					node[i].style.width = '152px';
					node[i].style.textOverflow = 'ellipsis';
					node[i].style.overflow = 'hidden';
				} 
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
	        
	        /* 2018-10-16 홍승비 - 관리자단에서 좌측게시판리스트 하위에 접근하는지 판단하는 플래그 추가  */
	        function GetSubBoard(pRootBoardID, pSubFlag) {
		    	var xmlhttp3 = createXMLHttpRequest();
		        xmlhttp3.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + pRootBoardID + "&subFlag=" + pSubFlag + "&selectFlag=0&isAdminLeft=Y", false);
		        xmlhttp3.send();
		        var ret = xmlhttp3.responseXML;
		        xmlhttp3 = null;
		        return ret;
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
	                        window.parent.frames["board_main"].location.href = "/admin/ezBoard/boardConfig.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd + "&parentBoardID=" + SelectedBoardParentBoardID + "&tabID=1tab2";
	                    }
	                }else{                	
	                    window.parent.frames["board_main"].location.href = "/admin/ezBoard/boardConfig.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd + "&parentBoardID=" + SelectedBoardParentBoardID;
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
                        window.open("/admin/ezBoard/boardMove.do?boardID=" + SelectedBoardID + "&boardGroupID=" + SelectedBoardGroupID, "board_main");
	                    break;
	                case 5:	                    
	                    window.open("/admin/ezBoard/boardDelete.do?boardID=" + SelectedBoardID + "&boardGroupID=" + SelectedBoardGroupID, "board_main");	                    
	                    break;
	                case 6:
	                    window.open("/admin/ezBoard/boardProperty.do?boardID=" + SelectedBoardID, "board_main");
	                    break;
	                case 7:
	                    window.open("/admin/ezBoard/boardACL.do?parentNeed=Y&boardID=" + SelectedBoardID + "&parentBoardID=" + SelectedBoardParentBoardID + "&accessLevel=" + AccessLevel, "board_main");
	                    break;
	                case 8:
	                    window.open("/admin/ezBoard/boardBackGround.do?parentNeed=Y&boardID=" + SelectedBoardID + "&parentBoardID=" + SelectedBoardParentBoardID, "board_main");
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
	            }else{
	                return document.getElementById(parentNodeid).childNodes.length;
	            }
	        }	   
	        
	        $(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
	    </script>
	</head>
	<body class="leftbody">
	    <div id="left">
	        <div class="left_admin"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code="ezBoard.t58" /></div>
	        <div class="adminListBox" style="overflow:hidden; padding-right: 0;">
		        <div id="TopBoard"></div>	
		        <h3 style="border-top:1px solid #e8e8e8"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(1)"><spring:message code="ezBoard.t122" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(6)"><spring:message code="ezBoard.t0004" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(7)"><spring:message code="ezBoard.t500" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(2)"><spring:message code="ezBoard.t62" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(3)"><spring:message code="ezBoard.t64" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(4)"><spring:message code="ezBoard.t65" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(5)"><spring:message code="ezBoard.t66" /></span></h3>
		        <h3 style="border-top: 0px;"><span style="width: 100%; display: inline-block; width: 100%;" onclick="OpenRightMenu(8)"><spring:message code="ezBoard.t5006" /></span></h3>
	        </div>
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
							strHTML += "<h2><div AccessLevel='1' class='groupBoard' id='TreeCtr" + idx + "' value='" + i.boardId;
	                        strHTML += "' onclick=\"TopBoard_onclick('TreeCtrl" + idx + "','" + i.boardId + "')\">";
	                        strHTML += i.boardName + "</div></h2>";
	                        strHTML += "<ul><div class='tree' name='BoardTree' id='TreeCtrl" + idx + "obj' style='width: auto; overflow-x: hidden; overflow-y: auto; padding-left: 10px; padding-bottom: 20px;'>";
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