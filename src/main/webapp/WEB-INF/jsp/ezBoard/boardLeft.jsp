<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
	    <style>
	    	.tree {
	    		min-height : 100px;
	    	}
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
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
		            WebPartToggle(level1El.item(level1El.length - 2));
		            Open_Func(1);
		        }
		        else if (Func == "3") {
		        	WebPartToggle(level1El.item(level1El.length - 1));
		        	Poll_Open(1);
				} else if (Func == "4") {
					WebPartToggle(level1El.item(level1El.length - 1));
					ladder_Func(1);
				}
		        else if (RedirectBoardID == "" || RedirectBoardGroupID == "") {
		            ShowMyBoardItem();
		        }
		
		        if (Func != "1" && Func != "3" && Func != "4") {
		            if (subFunc == "1") {
		                MyBoard();
		            }
		            else if (subFunc == "2") {
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

		    };
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
			                }
			                else {
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
		        var node = document.getElementById(TreeIdx);
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
		        }
		        
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
		        
		        /* 18-05-16 김민성 - tootip 추가 및 글자수 관련 style 수정 */
				var node = $(".node_normal");
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].parentElement.getAttribute("DATA2"));
					node[i].style.width = '152px';
					node[i].style.textOverflow = 'ellipsis';
					node[i].style.overflow = 'hidden';
				} 
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
				$(".fList h2").attr("class", "off");
				$(".qst h2").attr("class", "off");
				$(".pollDiv h2").attr("class", "off");
				$(".myb h2").attr("class", "off");
				$(".myb").next().attr("class", "off");//마이게시판 하위 ul off
				$(".ApprDiv").attr("class", "off");
					
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

		            /* 18-05-17 김민성 - tootip 추가 및 글자수 관련 style 수정 */
					var node = $(".node_normal");
					for(var i=0; i<node.length; i++) {
						node[i].setAttribute("TITLE", node[i].parentElement.getAttribute("DATA2"));
						node[i].style.width = '152px';
						node[i].style.textOverflow = 'ellipsis';
						node[i].style.overflow = 'hidden';
					} 
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
		    	$(".on").attr("class", "off");
		    	$(".qst h2").attr("class", "on");
				$(".qst").next().attr("class", "on");
				
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
				$(".on").attr("class", "off");
				$(".pollDiv h2").attr("class", "on");
				$(".pollDiv").next().attr("class", "on");
				
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
				$(".on").attr("class", "off");
				$(".ladder h2").attr("class", "on");
				$(".ladder").next().attr("class", "on");
				
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
		    	$(".on").attr("class", "off");
		    	$(".fList h2").attr("class", "on");
		    	$(".fList").next().attr("class", "on");
		    	
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
		      	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardSearchView.do";
				} else {
		    		window.parent.frames["right"].location.href = "/ezBoard/boardSearchView.do";
				}
		    }
	    </script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
	    <div id="left" style="overflow: auto">
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
		            <h2>
	<%-- 	            <span style="background:url('/images/i_group.gif') no-repeat 8px; border-bottom:1px solid #aeabab; display: inline-block; width: 100%;"><spring:message code="ezBoard.t360"/></span> --%>
		            	<span><spring:message code="ezBoard.t360"/></span><img style="margin-left: 7px;vertical-align: middle" alt="" src="/images/i_group_new.gif" width="14px" />
		            </h2>
		        </div>
		        <ul id="TreeCtrl_MyBoardTree_ul">
		            <div class="tree" style='width:auto;overflow-x:hidden;overflow-y:auto; margin-left: 5px; height: 100%; border-bottom:1px solid #eaeaea' id='TreeCtrl_MyBoardTree'></div>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="ConfigMyBoard()"><spring:message code="ezBoard.t10044" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="MyBoard()"><spring:message code="ezBoard.t10032" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="ReservationItem_onclick()"><spring:message code="ezBoard.t229" /></span></h3>
		            <h3><span style="width: 100%; display: inline-block;width: 100%;" onclick="TempBoard()"><spring:message code="ezBoard.t10030" /></span></h3>
		        </ul>
	        </c:if>
	        <div id='TopBoardsList'>
	        	<script type="text/javascript">
	        		parser = new DOMParser();
        		    xmlDoc = parser.parseFromString("${resultXML}","text/xml");
        			var i = 0;
        			$(xmlDoc).find("NODE").each(function(){
       			        document.write("<h2>");
           				document.write("<div id='TreeCtr" + i + "' class='groupBoard' value='" + $(this).find("DATA1").text() + "' onclick='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()
           					+ "\")'>" + $(this).find("DATA2").text() + "</div>"); 
           				document.write("</h2>\n");
           				document.write("<ul>\n");
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
		            <h2>
	<%-- 	            <span style="background:url('/images/i_group.gif') no-repeat 8px; border-bottom:1px solid #aeabab; display: inline-block; width: 100%;"><spring:message code="ezBoard.t360"/></span> --%>
		            	<span><spring:message code="ezBoard.t360"/></span><img style="margin-left: 7px;vertical-align: middle" alt="" src="/images/i_group_new.gif" align="middle" />
		            </h2>
		        </div>
		        <ul id="TreeCtrl_MyBoardTree_ul">
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
		    	<%-- <ul>
	            	<li><span style="width: 100%; display: inline-block;" onclick="Open_Func(1)"><spring:message code="ezBoard.t366" /></span></li>
	            	<c:if test="${questionAdmin == 'true' }">
	            		<li><span style="width: 100%; display: inline-block;" onclick="Open_Func(2)"><spring:message code="ezBoard.t367" /></span></li>
	            	</c:if>
	        	</ul> --%>
		    </c:if>
		  <%--   <c:if test="${applyFlag == 'OK'}">
	            <div class="ApprDiv" onclick="Apprboard()">
			        <h2>
			            <span><spring:message code="ezBoard.t999001" /> <span id="applyCount">(${applyCount})</span></span>
			        </h2>
	            </div>
		    </c:if> --%>
		    <div class="pollDiv" onclick="Poll_Open(1)" style="display: ${(pollFlag == 'YES') ? 'block' : 'none'};">
	        	<h2><span><spring:message code="ezBoard.t371" /></span></h2>
	        </div>
	        <ul>
	            <%-- <li><span style="width: 100%; display: inline-block;" onclick="Poll_Open(1)"><spring:message code="ezBoard.t372" /></span></li>	            
	            <li><span style="width: 100%; display: inline-block;" onclick="Poll_Open(2)"><spring:message code="ezBoard.t373" /></span></li> --%>	            
	        </ul>
			
			 <c:if test="${ladderFlag == 'YES'}">
			<div class="ladder" onclick="ladder_Func(1)">
				<h2><span><spring:message code="ezBoard.l001" /></span></h2>
			</div>
			</c:if>
			<ul></ul>

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
	    </script>
	</body>
</html>
