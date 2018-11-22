<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
			#FromTreeView {
				height: 100%;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    
		<script type="text/javascript" >
	        var SSUserID = "${userInfo.id}";
	        var SSUserName = "${userInfo.name}";
	        var SSDeptID = "${userInfo.deptID}";
	        var SSDeptName = "${userInfo.deptName}";
	        var SSCompanyID = "${userInfo.companyID}";
	        var SSCompanyName = "${userInfo.companyName}";
	        var SelectedBoardID = "";
	        var SelectedBoardParentBoardID = "";
	        var RedirectBoardGroupID = "${redirectBoardGroupID}";
	        var RedirectBoardID = "${redirectBoardID}";
	        var Func = "${func}";
	        var subFunc = "${subFunc}";
	        var qstId = "${qstId}";
	        var PhotoType = "${photoType}";
	        var g_ReadyState = "";
	        var first = 1;
	        var items = "${resultCount}";
	        var rightFrame = "";
	        
		    window.onresize = function () {
		        var menuSize = (parseInt(items) + 2) * 30;
		        /* 18-05-18 김민성 - 게시판 maxHeight 제거 */
		        /* var height = parseInt(document.documentElement.clientHeight - menuSize);
		        for (var i = 0; i < items; i++) {
		            if (document.documentElement.clientHeight > 740) {
		            	document.getElementById("TreeCtrl" + i + "obj").style.maxHeight = "200px";
		            }
		            else {
		                document.getElementById("TreeCtrl" + i + "obj").style.maxHeight = (height * 0.38) + "px";
		            }
		        } */
		    };
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		    	rightFrame = window.parent.document.getElementsByName("right")[0];
		    	
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (Func == "1") {
		            //WebPartToggle(level1El.item(level1El.length - 2));
		            Open_Func(1);
		        }
		        else if (Func == "3") {
		        	//WebPartToggle(level1El.item(level1El.length - 1));
		        	Poll_Open(1);
				} else if (Func == "4") {
					//WebPartToggle(level1El.item(level1El.length - 1));
					ladder_Func(1);
				} else if (Func == "5") {
					//WebPartToggle(level1El.item(level1El.length - 1));
					memo_Func(1);
				}
		        /* 2018-09-20 홍승비 - 윈도우 온로드 시 마이게시판 우선적으로 열리는 부분 주석처리 */
		       /*  else if (RedirectBoardID == "" || RedirectBoardGroupID == "") {
		            ShowMyBoardItem();
		        } */
		
		        /* 2018-09-20 홍승비 - 게시판 서브메뉴로 나의게시물, 예약게시물 진입 시 좌측메뉴 하이라이트 수정 */
		        if (Func != "1" && Func != "3" && Func != "4" && Func != "5") {
		            if (subFunc == "1") {
		            	ShowMyBoardItem();
		                MyBoard();
		            }
		            else if (subFunc == "2") {
		            	ShowMyBoardItem();
		                ReservationItem_onclick();
		            }
		            else {
		                if (RedirectBoardID != "") {
		                    if (RedirectBoardGroupID != "" && RedirectBoardGroupID != "null" && g_ReadyState == "") {
		                        BoardRedirect();
		                        return;
		                    }

		                    if (typeof window.parent.frames["right"] == "undefined") {
								rightFrame.src = "/ezBoard/boardItemList.do?boardID=" + RedirectBoardID;
		                    }
		                    else {
		                    	window.parent.frames["right"].location.href = "/ezBoard/boardItemList.do?boardID=" + RedirectBoardID;
		                	}
						}
		
		                var menuSize = (parseInt(items) + 2) * 30;
		                /* 18-05-18 김민성 - 게시판 maxHeight 제거 */
		                /* var height = parseInt(document.documentElement.clientHeight - menuSize);
		
		                for (var i = 0; i < items; i++) {
		                    if (document.documentElement.clientHeight > 740) {
// 		                    	document.getElementById("TreeCtrl" + i + "obj").style.maxHeight = "200px";
		                    }
		                    else {
		                    	document.getElementById("TreeCtrl" + i + "obj").style.maxHeight = (height * 0.38) + "px";
		                    }
		                } */
		                document.getElementById('TreeCtrl_MyBoardTree').scrollTop = 0;

		                favoriteList();
		            }
		        }
		        leftResize();
		        $(".boardListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		    };
		    function BoardRedirect() {
		        var spans = document.getElementById("TopBoardsList").getElementsByTagName("span");
		        var cnt = 0;
		        for (var i = 0 ; i < spans.length ; i++) {
		            if (spans[i].getAttribute("value") == RedirectBoardGroupID) {
		                LoadTreeViewByPath(spans[i], RedirectBoardID, RedirectBoardGroupID);
		                cnt++;
		            }
		        }
		        if (cnt == 0) { //권한이 없을 경우
		        	var rightFrameDoc = "";
		        	if (typeof window.parent.frames["right"] == "undefined") {
		        		rightFrameDoc = rightFrame.document;
		        	} else {
		        		rightFrameDoc = window.parent.frames["right"].document;
		        	}
		        	
		        	rightFrameDoc.head.innerHTML = "<link rel='stylesheet' href='${util.addVer('ezBoard.i1', 'msg')}' type='text/css'>";
		        	rightFrameDoc.body.className = "mainbody";
		        	rightFrameDoc.body.innerHTML = "<div style='margin-top:100px;text-align:center'><spring:message code='ezBoard.t272'/></div>";
		        }
		    }
		    
		    function LoadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID) {
		        pObjSpan.onclick();
		        
		        var selectItem;

		        /*
		        var totalboard = "";
		        if (pObjSpan.parentElement.parentElement.nextSibling.nodeType == 1) {
		            totalboard = getFirstChild(pObjSpan.parentElement.parentElement.nextSibling);
		        }
		        else {
		            totalboard = getFirstChild(pObjSpan.parentElement.parentElement.nextSibling.nextSibling);
		        }
		
		        var cnt = totalboard.children[0].getElementsByTagName("div").length;
		        
		        // 2018-11-01 홍승비 - 접근권한 없는 게시판에 포탈 포틀릿 등으로 접근 시, 오류메세지 표출하도록 수정 
		        var accessCheck = "";
		        for (var i = 0; i < cnt; i++) {
		        	if (typeof(totalboard.children[0].getElementsByTagName("div")[i]) == "undefined") {
		        		accessCheck = "NO";
			        	break;
			        }
		        	else {
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
		        }
		        
		        if (accessCheck != "NO") {
			        selectItem.getElementsByTagName("span")[2].onclick();
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
		        */
				tId = pObjSpan.getAttribute("id").replace("TreeCtr", "TreeCtrl");
		        var spans = document.getElementById("TreeView" + tId).getElementsByClassName("h2_text");//게시판들
		 
		        var cnt = spans.length;
		        var accessCheck = "";
		        var checkCnt = 0;
		        for (var i = 0; i < cnt; i++) {
	                var parentNodeid = spans[i].parentNode.getAttribute("data1");
		        	if (RedirectBoardID == parentNodeid) {
		                selectItem = spans[i];
		                break;
		            }
		            else {
	                    var nodeDiv = spans[i].parentNode;
	                    if (nodeDiv.getAttribute("isleaf") != "TRUE") { //하위 존재
	                    	document.getElementById("imgNode_" + nodeDiv.getAttribute("id")).onclick(); //클릭해야 하위 폴더트리 생성되므로 클릭
	                    	cnt += document.getElementById(nodeDiv.getAttribute("id") + "_sub").childNodes.length;
	                    	document.getElementById("imgNode_" + nodeDiv.getAttribute("id")).onclick();
	                    }
		            }
		        	checkCnt++;
		        }
		        
		        if (cnt == 0 || checkCnt == cnt) { //권한이 없으면 리스트에 해당 게시판 존재하지 않음
		        	accessCheck = "NO";
		        }
		        
		        if (accessCheck != "NO") {
			        selectItem.onclick();
			        
			        var tempid = selectItem.id.split("_");
			        var tempidlength = tempid.length;
			        var clicknode = new Array();
					var tempSpanid = "imgNode_" + tempid[1]; 

		            for (var i = 2; i < tempidlength; i++) {
		            	tempSpanid += "_" + tempid[i];
                        document.getElementById(tempSpanid).click();
		            }
		        }
		        // 리다이렉트된 게시판에 접근권한이 없다면 우측프레임에 메세지 표출함 
		        else {
		        	var rightFrameDoc = "";
		        	if (typeof window.parent.frames["right"] == "undefined") {
		        		rightFrameDoc = rightFrame.document;
		        	} else {
		        		rightFrameDoc = window.parent.frames["right"].document;
		        	}
		        	
		        	rightFrameDoc.head.innerHTML = "<link rel='stylesheet' href='${util.addVer('ezBoard.i1', 'msg')}' type='text/css'>";
		        	rightFrameDoc.body.className = "mainbody";
		        	rightFrameDoc.body.innerHTML = "<div style='margin-top:100px;text-align:center'><spring:message code='ezBoard.t272'/></div>";
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
		    
		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {		// 일반 게시판 하위 게시판 확장
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
		        
		        /* 18-05-17 김민성 - tootip 추가 및 글자수 관련 style 수정 */
		        var node = document.getElementById(TreeIdx);
		        var title2 = node.getElementsByClassName("node_div");
   
		        /* 2018-10-11 홍승비 - 접근권한 등의 문제로 트리노드를 확장할 수 없는 경우에는 건너뛰도록 수정 */
		        /* if (typeof(title2[0]) != "undefined") {
			        var nodeLevel = title2[0].getAttribute("nodelevel");
			        
			        for(var i=0; i<title2.length; i++) {
			        	var spanW = 152 - (18 * nodeLevel);
			        	title3 = title2[i].getElementsByClassName("h2_text");
			        	title3[0].setAttribute("TITLE", title3[0].parentElement.getAttribute("DATA2"));
			        	
			        	if (spanW < 0) {
							 spanW = 0;
						 }
			        	title3[0].style.width = spanW + 'px';
			        	title3[0].style.textOverflow = 'ellipsis';
			        	title3[0].style.overflow = 'hidden';
			        }
		        } */
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
		                
		                /* 2018-08-07 홍승비 - url게시판 접근 후 window.parent.frames["right"]이 undefined인 경우, 다른 방법으로 게시판 접근 */
						  if (typeof window.parent.frames["right"] == "undefined") {
							if (gubun == 3) {
								rightFrame.src = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
							} else if (gubun == 4) {
								rightFrame.src = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else if (gubun == 7) {
				            	rightFrame.src = "/ezBoard/boardItemListMovie.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else {
				                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
									rightFrame.src = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=N";
				                }
				                else {
				                	rightFrame.src = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				                }
				            }
						}
						else {
			                if (gubun == 3) {
			                    window.parent.frames["right"].location.href = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
			                }
			                else if (gubun == 4) {
			                    window.parent.frames["right"].location.href = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
			                } else if (gubun == 7) {
			                	window.parent.frames["right"].location.href = "/ezBoard/boardItemListMovie.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else {
			                    if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
			                        window.parent.frames["right"].location.href = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=N";
			                    }
			                    else {
			                        window.parent.frames["right"].location.href = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
			                    }
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
		    function TreeCtrl_onNodeExpandedNew(pNodeID, pTreeID) {		// 마이 게시판 하위 게시판 확장
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

		        /* 18-05-17 김민성 - tootip 추가 및 글자수 관련 style 수정 */
		       /*  var node = document.getElementById(TreeIdx);
		        var title2 = node.getElementsByClassName("node_div");
		        var nodeLevel = title2[0].getAttribute("nodelevel");
		        if(nodeLevel > 9)
		        	nodeLevel = 9;
		        for(var i=0; i<title2.length; i++) {
		        	title3 = title2[i].getElementsByClassName("node_normal");
		        	title3[0].setAttribute("TITLE", title3[0].parentElement.getAttribute("DATA2")); 
		        	title3[0].style.width = 152 - 18*nodeLevel +'px';
		        	title3[0].style.textOverflow = 'ellipsis';
		        	title3[0].style.overflow = 'hidden';
		        } */
		        
		    }
		
		    function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
		        try {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);
		            var SelectedBoardID = treeNode.GetNodeData("DATA1");
		            var SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
		            var chkPhotoBrd = treeNode.GetNodeData("DATA5");
		            
		            /* 2018-08-07 홍승비 - url게시판 접근 후 window.parent.frames["right"]이 undefined인 경우, 다른 방법으로 게시판 접근 */
				  	if (typeof window.parent.frames["right"] == "undefined") {
						if (chkPhotoBrd == 3) {
							rightFrame.src = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
						} else if (chkPhotoBrd == 4) {
							rightFrame.src = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 7) {
			            	rightFrame.src = "/ezBoard/boardItemListMovie.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else {
			                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
								rightFrame.src = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=N";
			                }
			                else {
			                	rightFrame.src = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			                }
			            }
					}
					else {
			            if (chkPhotoBrd == 3) {
			                window.parent.frames["right"].location.href = "/ezBoard/boardItemListPhoto.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 4) {
			                window.parent.frames["right"].location.href = "/ezBoard/boardItemListThumbnail.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 7) {
		                	window.parent.frames["right"].location.href = "/ezBoard/boardItemListMovie.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else {
			                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
			                    window.parent.frames["right"].location.href = "/ezBoard/boardItemList_new.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=N";
			                }
			                else{
			                    window.parent.frames["right"].location.href = "/ezBoard/boardItemList.do?boardID=" + SelectedBoardID + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			                }
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
		
		    function ShowMyBoardItem(val01) {		// 마이 게시판 선택
		    	/* $(".on").attr("class", "off");
		    	$(".myb h2").attr("class", "on");
		    	$(".myb").next().attr("class", "on"); */
		    	
		        SetTreeConfig();
		        document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		        var treeView = new TreeView();
		        treeView.SetID("FromTreeView");
		
		        treeView.SetNodeClick("TreeCtrl_onNodeClickNew");
		        treeView.SetRequestData("TreeCtrl_onNodeExpandedNew");
		        treeView.DataSource(GetMyBoardItem("0"));
		        treeView.DataBind("TreeCtrl_MyBoardTree");
		        first++;
	            
	            $("h2.on").not($("#myBoardList")).attr("class","off");
	            $("#TopBoardsList .lnbUL").attr("class","off");
	            
	            if ($("#myBoardList").attr("class") == "off") {
	            	$("#myBoardList").attr("class","on");
	            	$("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL");
	            } else {
	            	$("#myBoardList").attr("class","off");
	            	$("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");	
	            }
	            
		        /* 18-05-16 김민성 - tootip 추가 및 글자수 관련 style 수정 */
				/* var node = $(".node_normal");
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].parentElement.getAttribute("DATA2"));
					node[i].style.width = '152px';
					node[i].style.textOverflow = 'ellipsis';
					node[i].style.overflow = 'hidden';
				}  */
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
		    
		    function TopBoard_onclick(obj, ID) {		// 일반 게시판 선택
		    	//leftcount refresh 때문에 주석중 사이드 이펙트 검사필수
// 		        if (tempID == ID)
// 		            clickFlag = true;
// 		        else
// 		            clickFlag = false;

// 		        if (!clickFlag) {
//					$(".on").attr("class", "off"); 게시물 등록,수정,삭제 등의 작업 완료시, 왼쪽 게시판 리스트가 초기화되는 버그때문에 주석처리

				//TopBoard가 아닌 게시판의 왼쪽 게시판 리스트를 닫는다.
				/* $(".fList h2").attr("class", "off"); // 즐겨찾기 off
				$(".qst h2").attr("class", "off"); // 전자설문 off
				$(".pollDiv h2").attr("class", "off"); // 투표 off
				$(".myb h2").attr("class", "off"); // 마이게시판 상위 off
				$(".myb").next().attr("class", "off");//마이게시판 하위 ul off
				$(".ApprDiv").attr("class", "off");
				$(".ladder h2").attr("class", "off"); // 사다리게임 off */
					
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

		            var ctr = $("#TreeCtr"+num[1]).closest("h2");
		            var ctrobj = $("#"+obj + "obj").closest("ul");
		            
		            $("h2.on").not(ctr).attr("class","off");
		            $("#TopBoardsList .lnbUL").attr("class","lnbUL off");
		            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
		            
		            if (ctr.attr("class") == "off") {
		            	ctr.attr("class","on");		            	
		            	ctrobj.attr("class","lnbUL");
		            	
		            	/* ctrobj.animate({
		            		maxHeight: "250px"
		            	}, 500, function(){
			            	ctrobj.attr("class","lnbUL");
		            	}); */		            	
		            } else {
		            	ctrobj.attr("class","lnbUL off");
		            	ctr.attr("class","off");
		            	
		            	/* ctrobj.animate({
		            		maxHeight: "0px"
		            	}, 500, function(){		            			
		            		ctrobj.attr("class","lnbUL off");
		            		ctr.attr("class","off")
		            	}); */		            	
		            }
// 		        }

		            /* 18-05-17 김민성 - tootip 추가 및 글자수 관련 style 수정 */
					/* var node = $(".node_normal");
					for(var i=0; i<node.length; i++) {
						node[i].setAttribute("TITLE", node[i].parentElement.getAttribute("DATA2"));
						node[i].style.width = '152px';
						node[i].style.textOverflow = 'ellipsis';
						node[i].style.overflow = 'hidden';
					} */ 
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
		            strHTML += "	  <div  class='tree' id='TreeCtrl" + i.toString() + "obj" + "' style='display:none;height:100%;width:auto;overflow-x:auto;overflow-y:auto;padding-left:10px' ></div>";
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
		    	$("h2.on").attr("class", "off");
		    	$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (typeof window.parent.frames["right"] == "undefined") {
					if (idx == 1) {
						rightFrame.src = "/ezQuestion/qstList.do?brdID=5";
					}
					else {
						rightFrame.src = "/ezQuestion/qstStep1.do?brdID=5";
					}
				}
				else {
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
		    }

			function Poll_Open(idx) {
				$("h2.on").attr("class", "off");
				$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (typeof window.parent.frames["right"] == "undefined") {
					 if (idx == 1) {
						rightFrame.src = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
						qstId = "";
					}
					else {
						rightFrame.src = "/ezPoll/pollCreate.do?brdID=6";
					}
				}
				else {
					if (CrossYN()) {
			            if (idx == 1) {
			                window.parent.frames["right"].location.href = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
			                qstId = "";
			            }
			            else {
			                window.parent.frames["right"].location.href = "/ezPoll/pollCreate.do?brdID=6";
			            }
			        } else {
			            if (idx == 1) {
			            	window.parent.frames["right"].location.href = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
			            	qstId = "";
			            }
			            else {
			            	window.parent.frames["right"].location.href = "/ezPoll/pollCreate.do?brdID=6";
			            }
			            SetTreeviewUnSelect("");
			        }
				}
		    }
			
			function ladder_Func(idx) {
				$("h2.on").attr("class", "off");
				$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezLadder/ladderMain.do?brdID=7";
				}
				else {
					if (CrossYN()) {
						window.parent.frames["right"].location.href = "/ezLadder/ladderMain.do?brdID=7";
			        } else {
			        	window.parent.frames["right"].location.href = "/ezLadder/ladderMain.do?brdID=7";
			        }
		            SetTreeviewUnSelect("");
				}
			}
			
			function memo_Func(idx) {
				$("h2.on").attr("class", "off");
				$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (CrossYN()) {
					window.parent.frames["right"].location.href = "/ezMemo/memoMain.do?brdID=8";
		        } else {
		        	window.parent.frames["right"].location.href = "/ezMemo/memoMain.do?brdID=8";
		        }
	            SetTreeviewUnSelect("");
			}

		    function toggleQuestionList() {
		    	if( prevSelMenu != null )
		    		prevSelMenu.className = "off";
		    	
		    	/* prevSelMenu = $(".qst").next().children().get(0);
		    	prevSelMenu.className = "on"; */
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
		    	$("h2.on").attr("class", "off");
		    	$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
		    	
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemList_favorite.do";
				} else {
		       		window.parent.frames["right"].location.href = "/ezBoard/boardItemList_favorite.do";
				}
		    }
		    function ConfigMyBoard() {
		        var OpenWin = window.open("/ezBoard/myBoardConfig.do?type=CONFIG", "MyBoardConfig", GetOpenWindowfeature(525, 418));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function MyBoard() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemListMyList.do";
				} else {
		        	window.parent.frames["right"].location.href = "/ezBoard/boardItemListMyList.do";
				}
		    }
		    function TempBoard() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemListTemp.do";
				} else {
		        	window.parent.frames["right"].location.href = "/ezBoard/boardItemListTemp.do";
				}
		    }
		    function boardConfig() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardConfig.do";
				} else {
		        	window.parent.frames["right"].location.href = "/ezBoard/boardConfig.do";
				}
		    }
		    function ReservationItem_onclick() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardReservedItemList.do";
				} else {
		        	window.parent.frames["right"].location.href = "/ezBoard/boardReservedItemList.do";
				}
		    }
		    function Apprboard() {
		    	$(".ApprDiv").attr("class", "on");
		        
		    	var applyCount = "0";
		        
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getApplyCount.do",
					success: function(text){
						applyCount = text;
					}     			
				});
		        
		       	$(document.getElementById("applyCount")).text("(" + applyCount + ")");
		       	
		       	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemListAppr.do";
				} else {
		        	window.parent.frames["right"].location.href = "/ezBoard/boardItemListAppr.do";
				}
		    }
		    function boardSearch(){
		    	$("h2.on").attr("class", "off");
		    	$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
	            
		      	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardSearchView.do";
				} else {
		    		window.parent.frames["right"].location.href = "/ezBoard/boardSearchView.do";
				}
		    }
		    
		    function folder_Manage() {
	        	var OpenWin = window.open("/ezMemo/memoFolderManage.do", "", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
		    
		    function boardWrite(){
		    	var wWeight = "355";
                var wHeight = "600";

                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;

                var left = (width - wWeight) / 2;
                var top = (heigth - wHeight) / 2;
                window.open("/ezBoard/writeBoardSelect.do", "",
                    "height = " + wHeight + ", width = " + wWeight + ", status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
		    
		    function leftResize(){
	        	$(".boardListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
		    
	 
	    </script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezBoard.t116'/>">
	    		<spring:message code='ezBoard.t116'/>
	        	<span onclick="boardConfig()" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezBoard.t0005" />"></span>
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write01" onclick="boardWrite();"><span class="sub_iconLNB tree_write"></span>게시글 등록</p>
	        </div>
	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
		        <div class="lnb_lay">
			        <h2 onclick="favoriteList()">
			            <span class="sub_iconLNB tree_board_star"></span><span class="h2Title"><spring:message code="ezBoard.t00010" /></span>
			        </h2>
			        <c:if test="${MyBoardTopFlag == 'NO'}">
				        <h2 class="off" id="myBoardList">
				            <span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="ShowMyBoardItem()"><spring:message code="ezBoard.t360" /></span><span onclick="ConfigMyBoard()" class="sub_iconLNB tree_manage"></span>
				        </h2>
				        <ul class="lnbUL off" id="TreeCtrl_MyBoardTree_ul">
				        	<div class="tree onlytree" id='TreeCtrl_MyBoardTree'></div>
				        </ul>
			        </c:if>
			        <div id='TopBoardsList'>
			        	<script type="text/javascript">
			        		parser = new DOMParser();
		        		    xmlDoc = parser.parseFromString("${resultXML}","text/xml");
		        			var i = 0;
		        			$(xmlDoc).find("NODE").each(function(){
		       			        document.write("<h2 class='off'>");
		       			     	document.write("<span>");
		       			     	document.write("<span class='sub_iconLNB tree_arrow_up'></span>");
		       			     	document.write("<span id='TreeCtr" + i + "' class='h2Title' value='" + $(this).find("DATA1").text() + "' onclick='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()
		               					+ "\")'>" + $(this).find("DATA2").text() + "</span>");
		       			     	document.write("</span>");
		           				/* document.write("<div id='TreeCtr" + i + "' class='groupBoard' value='" + $(this).find("DATA1").text() + "' onclick='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()
		           					+ "\")'>" + $(this).find("DATA2").text() + "</div>"); */ 
		           				document.write("</h2>\n");
		           				document.write("<ul class='lnbUL off'>\n");
		           				document.write("<div  class='tree onlytree' name='BoardTree' id='TreeCtrl" + i + "obj'></div>\n");
		           				document.write("</ul>\n");
		           				i++;
		        			});
			        	</script>
			        </div>
			        <c:if test="${MyBoardTopFlag != 'NO'}">
			        	<h2 class="off" id="myBoardList">
				            <span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title" onclick="ShowMyBoardItem(this)"><spring:message code="ezBoard.t360" /></span><span onclick="ConfigMyBoard()" class="sub_iconLNB tree_manage"></span>
				        </h2>
				        <ul class="lnbUL off" id="TreeCtrl_MyBoardTree_ul" style="overflow:hidden">
				        	<div class="tree onlytree" id='TreeCtrl_MyBoardTree'></div>
                           	<li><span class="sub_iconLNB tree_board_my"></span><span class="list_text" onclick="MyBoard()"><spring:message code="ezBoard.t10032" /></span></li>
                           	<li><span class="sub_iconLNB tree_board_reservation"></span><span class="list_text" onclick="ReservationItem_onclick()"><spring:message code="ezBoard.t229" /></span></li>
                           	<li><span class="sub_iconLNB tree_outbox"></span><span class="list_text" onclick="TempBoard()"><spring:message code="ezBoard.t10030" /></span></li>
				        </ul>
				    </c:if>
			        <ul class="lnbUL">
                		<c:if test="${useQuestion == 'YES'}">
                           	<li><span class="sub_iconLNB tree_board_qst"></span><span class="list_text" onclick="Open_Func(1)"><spring:message code="ezBoard.t365" /></span></li>
                    	</c:if>
						<li class="pollDiv" style="display: ${(pollFlag == 'YES') ? 'block' : 'none'};"><span class="sub_iconLNB tree_board_poll"></span><span class="list_text" onclick="Poll_Open(1)"><spring:message code="ezBoard.t371" /></span></li>
                    	<c:if test="${ladderFlag == 'YES'}">
                           	<li class="ladder"><span class="sub_iconLNB tree_board_ladder"></span><span class="list_text" onclick="ladder_Func(1)"><spring:message code="ezBoard.l001" /></span></li>
	                    </c:if>	
	                    <c:if test="${memoFlag == 'YES'}">
                           	<li class="memo"><span class="sub_iconLNB tree_board_memo"></span><span class="list_text" onclick="memo_Func(1)"><spring:message code="ezMemo.t001" /></span></li>
                    	</c:if>
			        </ul>
			        <ul class="lnbUL">
                       	<li><span class="sub_iconLNB tree_search"></span><span class="list_text" onclick="boardSearch()"><spring:message code="ezBoard.khj1" /></span></li>
                    	<c:if test="${applyFlag == 'OK'}">
                           	<li><span class="sub_iconLNB tree_env_firstPage"></span><span class="list_text" onclick="Apprboard()"><spring:message code="ezBoard.t999001" /><span id="applyCount">${applyCount}</span></span></li>
                    	</c:if>
			        </ul>
				</div>	
			</div>	        
	    </div>
	    <%-- <div id="left" style="overflow: auto">
	        <div class="left_board" title="<spring:message code='ezBoard.t116'/>"><span><spring:message code='ezBoard.t116'/></span></div>
	        <c:if test="${MyBoardTopFlag != 'NO'}">
	        	<div class="fList" onclick="favoriteList()">
	        		<h2>
	        			<span><spring:message code="ezBoard.t00010" /></span><img style="margin-left: 7px;vertical-align: middle" alt="" src="/images/ImgIcon/icon-flag.gif" />
	        			<!-- <h2 style="background:url('/images/ImgIcon/icon-flag.gif') no-repeat 20px 8px; border-bottom:1px solid #aeabab;"><span style="width: 100%; display: inline-block; font-weight: bold;" onclick="favoriteList()"></span></h2> -->
	        		</h2>	
	        	</div>
	        	<ul></ul>		        
		        <div class="myb" id="{00000000-0000-0000-0000-000000000000}" onclick="ShowMyBoardItem()">
		        2018-09-20 홍승비 - window.onload 시 마이게시판 디폴트 클래스를 off로 수정
		            <h2 class="off">
		            <span style="background:url('/images/i_group.gif') no-repeat 8px; border-bottom:1px solid #aeabab; display: inline-block; width: 100%;"><spring:message code="ezBoard.t360"/></span>
		            	<span><spring:message code="ezBoard.t360"/></span><img style="margin-left: 7px;vertical-align: middle" alt="" src="/images/i_group_new.gif" width="14px" />
		            </h2>
		        </div>
		        <ul id="TreeCtrl_MyBoardTree_ul" class="off">
		            <div class="tree" style='width:auto;overflow-x:hidden;overflow-y:auto; margin-left: 5px; height: 100%; border-bottom:1px solid #eaeaea' id='TreeCtrl_MyBoardTree'></div>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="ConfigMyBoard()"><spring:message code="ezBoard.t10044" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="MyBoard()"><spring:message code="ezBoard.t10032" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="ReservationItem_onclick()"><spring:message code="ezBoard.t229" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="TempBoard()"><spring:message code="ezBoard.t10030" /></span></h3>
		        </ul>
	        </c:if>
	        2018-09-20 홍승비 - window.onload 시 게시판리스트 디폴트 클래스를 off로 수정
	        <div id='TopBoardsList'>
	        	<script type="text/javascript">
	        		parser = new DOMParser();
        		    xmlDoc = parser.parseFromString("${resultXML}","text/xml");
        			var i = 0;
        			$(xmlDoc).find("NODE").each(function(){
       			        document.write("<h2 class='off'>");
           				document.write("<div id='TreeCtr" + i + "' class='groupBoard' value='" + $(this).find("DATA1").text() + "' onclick='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()
           					+ "\")'>" + $(this).find("DATA2").text() + "</div>"); 
           				document.write("</h2>\n");
           				document.write("<ul class='off'>\n");
           				document.write("<div  class='tree' name='BoardTree' id='TreeCtrl" + i + "obj' style='width: auto; height: 100%; padding-bottom: 20px; padding-left: 10px; overflow-x: hidden; overflow-y: auto;'></div>\n");
           				document.write("</ul>\n");
           				i++;
        			});
	        	</script>
	        </div>
	        <c:if test="${MyBoardTopFlag == 'NO'}">
		        <div class="fList" onclick="favoriteList()">
	        		<h2>
	        			<span><spring:message code="ezBoard.t00010" /></span><img style="margin-left: 7px;vertical-align: middle" alt="" src="/images/ImgIcon/icon-flag.gif" />
	        			<!-- <h2 style="background:url('/images/ImgIcon/icon-flag.gif') no-repeat 20px 8px; border-bottom:1px solid #aeabab;"><span style="width: 100%; display: inline-block; font-weight: bold;" onclick="favoriteList()"></span></h2> -->
	        		</h2>	
	        	</div>
	        	<ul></ul>
		        <div class="myb" id="{00000000-0000-0000-0000-000000000000}" onclick="ShowMyBoardItem()">
		            <h2 class="off">
		            <span style="background:url('/images/i_group.gif') no-repeat 8px; border-bottom:1px solid #aeabab; display: inline-block; width: 100%;"><spring:message code="ezBoard.t360"/></span>
		            	<span><spring:message code="ezBoard.t360"/></span><img style="margin-left: 7px;vertical-align: middle" alt="" src="/images/i_group_new.gif" align="middle" />
		            </h2>
		        </div>
		        <ul id="TreeCtrl_MyBoardTree_ul" class="off">
		            <div class="tree" style='width:auto;overflow-x:auto;overflow-y:auto; margin-left: 5px; height: 100%; border-bottom:1px solid #eaeaea' id='TreeCtrl_MyBoardTree'></div>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="ConfigMyBoard()"><spring:message code="ezBoard.t10044" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="MyBoard()"><spring:message code="ezBoard.t10032" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="ReservationItem_onclick()"><spring:message code="ezBoard.t229" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="TempBoard()"><spring:message code="ezBoard.t10030" /></span></h3>
		        </ul>
	        </c:if>
	        
		    <c:if test="${useQuestion == 'YES'}">
		    	<div class="qst" onclick="Open_Func(1)">
		        	<h2><span><spring:message code="ezBoard.t365" /></span></h2>		        
		    	</div>
		    	<ul></ul>
		    	<ul>
	            	<li><span style="width: 100%; display: inline-block;" onclick="Open_Func(1)"><spring:message code="ezBoard.t366" /></span></li>
	            	<c:if test="${questionAdmin == 'true' }">
	            		<li><span style="width: 100%; display: inline-block;" onclick="Open_Func(2)"><spring:message code="ezBoard.t367" /></span></li>
	            	</c:if>
	        	</ul>
		    </c:if>
		    <c:if test="${applyFlag == 'OK'}">
	            <div class="ApprDiv" onclick="Apprboard()">
			        <h2>
			            <span><spring:message code="ezBoard.t999001" /> <span id="applyCount">(${applyCount})</span></span>
			        </h2>
	            </div>
		    </c:if>
		    <div class="pollDiv" onclick="Poll_Open(1)" style="display: ${(pollFlag == 'YES') ? 'block' : 'none'};">
	        	<h2><span><spring:message code="ezBoard.t371" /></span></h2>
	        </div>
	        <ul>
	            <li><span style="width: 100%; display: inline-block;" onclick="Poll_Open(1)"><spring:message code="ezBoard.t372" /></span></li>	            
	            <li><span style="width: 100%; display: inline-block;" onclick="Poll_Open(2)"><spring:message code="ezBoard.t373" /></span></li>	            
	        </ul>
			
			 <c:if test="${ladderFlag == 'YES'}">
			<div class="ladder" onclick="ladder_Func(1)">
				<h2><span><spring:message code="ezBoard.l001" /></span></h2>
			</div>
			</c:if>
			<ul></ul>
			
			<c:if test="${memoFlag == 'YES'}">
			<div class="memo" onclick="memo_Func(1)">
				<h2><span><spring:message code="ezMemo.t001" /></span></h2>
			</div>
			</c:if>
			
			<ul>
				<!-- <div class="memoTree" style="width:auto;height:100%;padding-bottom:20px;padding-left:10px;overflow-x:auto;overflow-y:auto;cursor:pointer;"> 
					<div>
						<src class="memoFoldImage"></src>
						<img src="/images/ImgIcon/icon_approval.gif" style="width:18px;height:19px;">
						<span style="width:100%;height:21px; line-height:21px; font-size:12px;" onclick="memo_Func(1)" id="memoTot">전체메모<span id="countTotal"></span></span>
						<div class="memoFolders"></div>
					</div>
				</div>
				<h3 style="margin-top:12px;border-top:1px solid #eaeaea;border-bottom:1px solid #eaeaea;"><span id="MNGUSERCONT" onclick="folder_Manage()" style="width: 100%; display: inline-block;">메모함관리</span></h3> -->
			</ul>
			
		    
			<h3>
				<span onclick="boardSearch()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.khj1" /></span>
			</h3>
	        
			<h3>
		        <span onclick="boardConfig()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.t0005" /></span>
		    </h3>
		    <c:if test="${applyFlag == 'OK'}">
		    	<h3 style="border-top:0px">
			        <span onclick="Apprboard()"><spring:message code="ezBoard.t999001" /> <span id="applyCount">(${applyCount})</span></span>
			    </h3>	
		    </c:if>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	        $(".on").attr("class", "off");
	    </script> --%> 
	</body>
</html>
