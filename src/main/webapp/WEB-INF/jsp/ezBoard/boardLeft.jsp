<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
				display:inline-block;
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
	        var RedirectBoardGroupID = "<c:out value='${redirectBoardGroupID}'/>";
	        var RedirectBoardID = "<c:out value='${redirectBoardID}'/>";
	        var Func = '<c:out value="${func}"/>';
	        var subFunc = '<c:out value="${subFunc}"/>';
	        var qstId = '<c:out value="${qstId}"/>';
	        var items = "<c:out value='${resultCount}'/>";
	        var rightFrame = "";
	        var useLeftCnt = "<c:out value='${useLeftCnt}'/>";
			var realIndexID = "<c:out value='${realIndexID}'/>";
	        var MyBoardScrapFlag = "<c:out value='${MyBoardScrapFlag}'/>";
	        
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
		        
		        /*2023-05-22 기민혁  나의 스크랩함 트리 표출  */
		        if(MyBoardScrapFlag == "TYPE2"){
			        Tree_setconfig();
		            var xmlDom2 = createXmlDom();
		            xmlDom2 = loadXMLString("${userScrapCont}");
		            var treeView = new TreeView();
		            treeView.SetID("UserScrapContTree");
		            treeView.SetUseAgency(true); //기본값이 true 여서 삭제 가능
		            treeView.SetRequestData("UserScrapContRequestData");
		            treeView.SetNodeClick("UserScrapContNodeClick");
		            treeView.DataSource(xmlDom2);
		            treeView.DataBind("divUserScrapContTree");
	
			        $(".node_normal").css("width", "145px");    
					var node = $(".node_normal");
				
					for(var i=0; i<node.length; i++) {
						node[i].setAttribute("TITLE", node[i].innerText);
						node[i].innerText = node[i].innerText;
					}
		        }	

		        /* 2019-09-16 홍승비 - 포탈 상단 게시판 메뉴로 게시판 접근 시, 기본으로 설정한 게시판을 보여주도록 수정 */
		        if ((Func == null || Func == "") && (subFunc == null || subFunc == "") && (qstId == null || qstId == "") && (RedirectBoardID == null || RedirectBoardID == "") && (RedirectBoardGroupID == null || RedirectBoardGroupID == "")) {
		        	var canRedirect = setDefaultBoard(); // 전역변수인 RedirectBoardID와 RedirectBoardGroupID 값을 임의로 설정
		        	if (canRedirect == "OK") {
		        		BoardRedirect(); // 설정한 게시판 값으로 리다이렉트를 진행
                        
                        document.getElementById('TreeCtrl_MyBoardTree').scrollTop = 0;
                        leftResize();
        		        $(".boardListBox").mCustomScrollbar({
        	        		theme : "dark"
        	        	});
        		        
		        		return;
		        	}
		        }
		        
		        if (Func == "1") {
		            //WebPartToggle(level1El.item(level1El.length - 2));
		            //Open_Func(1);
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
		            	/* 2019-09-16 홍승비 - 게시판 리다이렉트로 이동하는 경우, 게시판 좌측메뉴 스크롤 미생성 오류 수정 */
		                if (RedirectBoardID != "") {
		                    if (RedirectBoardGroupID != "" && RedirectBoardGroupID != "null") {
		                        BoardRedirect();
		                        
		                        document.getElementById('TreeCtrl_MyBoardTree').scrollTop = 0;
		                        leftResize();
		        		        $(".boardListBox").mCustomScrollbar({
		        	        		theme : "dark"
		        	        	});
		        		        
		                        return;
		                    }

		                    if (typeof window.parent.frames["right"] == "undefined") {
								rightFrame.src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(RedirectBoardID);
		                    }
		                    else {
		                    	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(RedirectBoardID);
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
		        
		        if (RedirectBoardID == "{MMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM}") {
		    		goMealPlanTable();
		        }
		        
		        $(".boardListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		    };
		    function BoardRedirect() {
		        var spans = document.getElementById("TopBoardsList").getElementsByTagName("span");
		        var cnt = 0;
		        var redirectOK = "";
		        for (var i = 0 ; i < spans.length ; i++) {
		            if (spans[i].getAttribute("value") == RedirectBoardGroupID) {
		                LoadTreeViewByPath(spans[i], RedirectBoardID, RedirectBoardGroupID);
		                cnt++;
		                redirectOK = "OK";
		            }
		        }
		        /* 2018-12-04 홍승비 - 접근권한 없는 게시판에 포탈 포틀릿 등으로 접근 시, 오류메세지 표출하도록 수정 */
		        if (cnt == 0 && redirectOK != "OK") {
					var rightFrameDoc = "";
					
		        	if (typeof window.parent.frames["right"] == "undefined") {
		        		rightFrameDoc = rightFrame.document;
		        	} else {
		        		rightFrameDoc = window.parent.frames["right"].document;
		        	}
		        	
		        	rightFrameDoc.head.innerHTML = "<link rel='stylesheet' href='${util.addVer('/css/default.css')}' type='text/css'>"
		        								 + "<link rel='stylesheet' href='${util.addVer('main.default.css', 'msg')}' type='text/css'>";
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
		        var spans = document.getElementById("TreeView" + tId).getElementsByClassName("node_normal");//게시판들
		 
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
		        	
		        	rightFrameDoc.head.innerHTML = "<link rel='stylesheet' href='${util.addVer('/css/default.css')}' type='text/css'>"
		        								 + "<link rel='stylesheet' href='${util.addVer('main.default.css', 'msg')}' type='text/css'>";
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
			        	title3 = title2[i].getElementsByClassName("node_normal");
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
								rightFrame.src = "/ezBoard/boardItemListPhoto.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
							} else if (gubun == 4) {
								rightFrame.src = "/ezBoard/boardItemListThumbnail.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else if (gubun == 7) {
				            	rightFrame.src = "/ezBoard/boardItemListMovie.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else if (gubun == 8) {
				            	rightFrame.src = "/ezBoard/boardItemViewHomePage.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else if (gubun == 9) {
				            	rightFrame.src = "/ezBoard/fileViewerBoard.do?boardID="  + encodeURIComponent(SelectedBoardID);
				            } else if (gubun == 10) {
								return;
							} else {
				                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
									rightFrame.src = "/ezBoard/boardItemList_new.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=N";
								} else if (SelectedBoardID == "{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}") {
									rightFrame.src = "/ezBoard/boardItemList_all.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=E";
				                } else if (SelectedBoardID == "{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") {
									rightFrame.src = "/ezBoard/boardItemList_allnew.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=R";
								} else {
				                	rightFrame.src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				                }
				            }
						}
						else {
			                if (gubun == 3) {
			                    window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListPhoto.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
			                }
			                else if (gubun == 4) {
			                    window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListThumbnail.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
			                } else if (gubun == 7) {
			                	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListMovie.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else if (gubun == 8) {
			                	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemViewHomePage.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
				            } else if (gubun == 9) {
								window.parent.document.querySelector("iframe[name=right]").src =  "/ezBoard/fileViewerBoard.do?boardID="  + encodeURIComponent(SelectedBoardID);
				            } else if (gubun == 10) {
								return;
							} else {
			                    if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
			                        window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_new.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=N";
                                } else if (SelectedBoardID == "{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}") {
                                    window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_all.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=E";
			                    } else if (SelectedBoardID == "{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") {
                                    window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_allnew.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=R";
                                } else {
			                        window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(pBoardName) + "&boardType=" + gubun;
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
		        xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + encodeURIComponent(SelBoardID), false);
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
		            var useGroupFlag = treeNode.GetNodeData("USEGROUPFLAG"); /* 그룹게시판 사용여부 */

		            /* 2018-08-07 홍승비 - url게시판 접근 후 window.parent.frames["right"]이 undefined인 경우, 다른 방법으로 게시판 접근 */
				  	if (typeof window.parent.frames["right"] == "undefined") {
						if (chkPhotoBrd == 3) {
							rightFrame.src = "/ezBoard/boardItemListPhoto.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
						} else if (chkPhotoBrd == 4) {
							rightFrame.src = "/ezBoard/boardItemListThumbnail.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 7) {
			            	rightFrame.src = "/ezBoard/boardItemListMovie.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 8) {
			            	rightFrame.src = "/ezBoard/boardItemViewHomePage.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 9) {
			            	rightFrame.src = "/ezBoard/fileViewerBoard.do?boardID="  + encodeURIComponent(SelectedBoardID);
			            } else if (chkPhotoBrd == 10) { // 카테고리 게시판인 경우 동작하지 않음.
							return;
						} else {
			                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
								rightFrame.src = "/ezBoard/boardItemList_new.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=N";
							} else if (SelectedBoardID == "{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}" || useGroupFlag == "Y") {
								rightFrame.src = "/ezBoard/boardItemList_all.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=E";
			                } else if (SelectedBoardID == "{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") {
								rightFrame.src = "/ezBoard/boardItemList_allnew.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=R";
							} else {
			                	rightFrame.src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			                }
			            }
					}
					else {
			            if (chkPhotoBrd == 3) {
			                window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListPhoto.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 4) {
			                window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListThumbnail.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 7) {
		                	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListMovie.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			            } else if (chkPhotoBrd == 8) {
		                	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemViewHomePage.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
						} else if (chkPhotoBrd == 9) {
							window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/fileViewerBoard.do?boardID="  + encodeURIComponent(SelectedBoardID);
			            } else if (chkPhotoBrd == 10) {
                            return;
						} else {
			                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
			                    window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_new.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=N";
							} else if (SelectedBoardID == "{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}" || useGroupFlag == "Y") {
								window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_all.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=E";
			                } else if (SelectedBoardID == "{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") {
								window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_allnew.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=R";
							} else{
			                    window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd;
			                }
			           }
					}
		            
				    /* 2019-07-08 홍승비 - 게시물 카운트 갱신 동작 함수로 분리 */
				  	refreshItemCnt(pNodeID);
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
			
		    /* 2023-06-22 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > 트리구조 LNB 이미지 수정 */
		    /* 2019-12-02 홍승비 - 게시판 좌측메뉴에서 마이게시판 설정 아이콘 표출, 의미없는 함수 파라미터 제거 */
		    function ShowMyBoardItem() {		// 마이 게시판 선택
		    	/* $(".on").attr("class", "off");
		    	$(".myb h2").attr("class", "on");
		    	$(".myb").next().attr("class", "on"); */
		    	var openSpan = $(event.target);
		    	
		    	SetTreeConfig();
		        document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		        var treeView = new TreeView();
		        treeView.SetID("FromTreeView");
		
		        treeView.SetNodeClick("TreeCtrl_onNodeClickNew");
		        treeView.SetRequestData("TreeCtrl_onNodeExpandedNew");
		        treeView.DataSource(GetMyBoardItem("0"));
		        treeView.DataBind("TreeCtrl_MyBoardTree");
	            
	            $("h2.on").not($("#myBoardList")).attr("class", "off");
	            $("#TopBoardsList .lnbUL").attr("class", "off");
				$("#scrapUL").attr("class", "lnbUL off");
				
	            if ($("#myBoardList").attr("class") == "off") {
	            	$("#myBoardList").attr("class", "on");
	            	$("#TreeCtrl_MyBoardTree_ul").attr("class", "lnbUL");
	            	$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
	            	$("#myBoardList").children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
	            } else {
	            	$("#myBoardList").attr("class", "off");
	            	$("#TreeCtrl_MyBoardTree_ul").attr("class", "lnbUL off");	
	            	$(".list_text.node_selected").removeClass("node_selected");
	            	$("#myBoardList").children().eq(0).attr("class", "sub_iconLNB tree_plus");
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
		    
		    /* 2020-11-06 홍승비 - personalizedPortal용 중복 클릭해도 닫히지 않고 마이게시판을 갱신하는 함수 */
		    function ShowMyBoardItemNew() {
		    	SetTreeConfig();
		        document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		        var treeView = new TreeView();
		        treeView.SetID("FromTreeView");
		
		        treeView.SetNodeClick("TreeCtrl_onNodeClickNew");
		        treeView.SetRequestData("TreeCtrl_onNodeExpandedNew");
		        treeView.DataSource(GetMyBoardItem("0"));
		        treeView.DataBind("TreeCtrl_MyBoardTree");
	            
	            $("h2.on").not($("#myBoardList")).attr("class","off");
	            $("#TopBoardsList .lnbUL").attr("class","off");
            	$("#myBoardList").attr("class","on");
            	$("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL");
            	$("#scrapUL").attr("class", "lnbUL off");
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
						// 2023-09-15 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > 마이게시판 > 마이게판목록 없을 시 여백 조정
						if (xml.includes("<NODE>")){
						} else {
							$("#TreeCtrl_MyBoardTree").css("padding-bottom", "0px");
						}
					}        			
				});	
		    	
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
 		            // 2023-06-22 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > 트리구조 LNB 이미지 수정
		            $("#myBoardList").children().eq(0).attr("class", "sub_iconLNB tree_plus");
					$("#scrapUL").attr("class", "lnbUL off");
					
		            if (ctr.attr("class") == "off") {
		            	ctr.attr("class", "on");		            	
		            	ctrobj.attr("class", "lnbUL");
		            	
		            	if ($(ctr).prop("tagName") == "H2") {
							$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		            	}
		            	
		            	$(ctr).children().children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
		            	
		            	/* ctrobj.animate({
		            		maxHeight: "250px"
		            	}, 500, function(){
			            	ctrobj.attr("class","lnbUL");
		            	}); */		            	
		            } else {
		            	ctrobj.attr("class","lnbUL off");
		            	ctr.attr("class","off");
		            	
		            	$(ctr).children().children().eq(0).attr("class", "sub_iconLNB tree_plus");
		            	
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
		        xmlhttp3.open("POST", "/ezBoard/getSubBoards.do?rootBoardID=" + encodeURIComponent(pRootBoardID) + "&subFlag=" + pSubFlag + "&selectFlag=0", false);
		        xmlhttp3.send();

		        var ret = xmlhttp3.responseXML;
		        xmlhttp3 = null;
		        return ret;
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
		            xmlhttp5.open("POST", "/ezBoard/deleteMyBoard.do?boardID=" + encodeURIComponent(treeNode.GetNodeData("DATA1")), false);
		            xmlhttp5.send();
		            xmlhttp5 = null;
		            document.getElementById('TreeCtrl_MyBoardTree').innerHTML = "";
		            treeView.DataSource(GetMyBoardItem());
		            treeView.DataBind('TreeCtrl_MyBoardTree');
		        }
		    }
		    
		    /* 2024-08-09 홍승비 - 구버전 전자설문(설문조사) 모듈은 더이상 사용하지 않는 것으로 확인, 관련 함수 Open_Func() 및 URL 호출 제거 */
		    // 신규 전자설문 모듈은 게시판 모듈과 분리되었음
		    
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
			                window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
			                qstId = "";
			            }
			            else {
			                window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollCreate.do?brdID=6";
			            }
			        } else {
			            if (idx == 1) {
			            	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
			            	qstId = "";
			            }
			            else {
			            	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollCreate.do?brdID=6";
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
						window.parent.document.querySelector("iframe[name=right]").src = "/ezLadder/ladderMain.do?brdID=7";
			        } else {
			        	window.parent.document.querySelector("iframe[name=right]").src = "/ezLadder/ladderMain.do?brdID=7";
			        }
		            SetTreeviewUnSelect("");
				}
			}
			
			function memo_Func(idx) {
				$("h2.on").attr("class", "off");
				$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (CrossYN()) {
					window.parent.document.querySelector("iframe[name=right]").src = "/ezMemo/memoMain.do?brdID=8";
		        } else {
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezMemo/memoMain.do?brdID=8";
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
		    
	    	/* 2023-06-22 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > '즐겨찾기' LNB 이미지 수정 */
		    function favoriteList() {
	    		$("h2.on").attr("class", "off");
				if (event) {
					var openSpan = $(event.target);
					openSpan.parent().addClass("on");
				} else {
					$("#favoriteList").addClass("on");
				}
		    	$(".list_text.node_selected").removeClass("node_selected");
	            $(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		    	$("#TopBoardsList .lnbUL").attr("class", "lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class", "lnbUL off");
				$("#scrapUL").attr("class", "lnbUL off");

	            if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemList_favorite.do";
				} else {
		       		window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_favorite.do";
				}
		    }
		    
		    /* 2020-11-05 홍승비 - 크롬 브라우저에서 부모창의 XMLHTTPRequest를 호출한 자식창이 닫히는 경우, send() 이후가 동작하지 않는 오류 수정(지원종료) */
		    var configmyboard_dialogArguments = new Array();
		    /* 2019-12-02 홍승비 - 마이게시판 설정 아이콘 표출, 이벤트 전파 방지 */
		    function ConfigMyBoard() {
		    	event.stopPropagation();
		    	configmyboard_dialogArguments[0] = "";
		    	
		        var OpenWin = window.open("/ezBoard/myBoardConfig.do?type=CONFIG", "MyBoardConfig", GetOpenWindowfeature(525, 418));
		        try {
		        	OpenWin.focus();
		        	
			        var winTimer = window.setInterval(function() {
			            if (OpenWin.closed !== false) {
			                window.clearInterval(winTimer);
			                if (configmyboard_dialogArguments[0] == "Y") {
			                	ShowMyBoardItemNew();
					    	}
			            }
			        }, 500);
		        } catch (e) { }
		    }
		    
		    function MyBoard() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemListMyList.do";
				} else {
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListMyList.do";
				}
		    	liSelected();
		    }
		    function TempBoard() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemListTemp.do";
				} else {
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListTemp.do";
				}
		    	liSelected();
		    }
		    function boardConfig() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardConfig.do";
				} else {
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardConfig.do";
				}
		    }
		    function ScrapBoard() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardMyScrapList.do";
				} else {
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardMyScrapList.do";
				}
				liSelected();
		    }
		    function ReservationItem_onclick() {
		    	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardReservedItemList.do";
				} else {
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardReservedItemList.do";
				}
		    	liSelected();
		    }
		    function Apprboard(h2) {
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
		        	window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemListAppr.do";
				}
		       	
		       	h2Selected(h2);
		    }
		    function boardSearch(h2){
		      	if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardSearchView.do";
				} else {
		    		window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardSearchView.do";
				}
		      	
		      	h2Selected(h2);
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
	        
	        /* 2018-12-31 홍승비 - 게시판그룹 열린 상태 유지하며 트리뷰를 갱신하는 기존 함수 추가 */
	        function treeViewRefresh(obj, ID) {
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
		    
		    /* 2019-02-14 홍승비 - 좌측 게시판리스트의 펼치기 화살표 클릭 시 하위게시판 불러오도록 수정*/
		    /* function spanClick(divID) {
		    	document.getElementById(divID).click();
		    } */
		    
		    /* 2019-07-08 홍승비 - 게시물 등록, 삭제, 복사, 이동시 좌측메뉴의 선택된 하위게시판 게시물 개수 갱신 함수 추가 */
		    function refreshItemCnt(pNodeID) {
				if(pNodeID.indexOf("UserScrapContTree") > -1){
					return;
				}
		       	if (useLeftCnt == "YES") {
			    	var SelectedBoardID = "";
			    	if(document.getElementById(pNodeID).id.indexOf("FromTreeView") > -1) {
			    		SelectedBoardID = document.getElementById(pNodeID).getAttribute("data3");
			    	} else {
			    		SelectedBoardID = document.getElementById(pNodeID).getAttribute("data1");
			    	}
			    	
			    	 /* 2019-04-19 홍승비 - 하위게시판 진입 시 해당 게시판 좌측리스트의 게시물 카운트 갱신 */
			    	$.ajax({
						type : "GET",
						dataType : "text",
						async : false,
						cache : false,
						url : "/ezBoard/getItemCount.do",
						data : {
							boardID : SelectedBoardID
						},
						success: function(resultCount) {
							var subBoardDiv = $('.node_div[data1="' +  SelectedBoardID + '"]');
							var subBoardDivMy = $('#TreeCtrl_MyBoardTree_ul').find('.node_div[data3="' +  SelectedBoardID + '"]');
							
							var subBoardSpan = subBoardDiv.children('span').last();
							var subBoardSpanMy = subBoardDivMy.children('span[id^="spn_"]'); // 마이게시판에는 동일한 하위게시판 중복 등록 가능
							var subBoardName = subBoardDiv.attr("data2");
							
							if (subBoardName == undefined || subBoardName.length < 0) {
								subBoardName = subBoardDivMy.attr("data2");
							}
							
							if (resultCount > 0) {
								// 2023-06-23 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > 카운트 괄호 추가
								subBoardName += ("(" + resultCount + ")");
							}
							
							subBoardSpanMy.text(subBoardName);
							subBoardSpan.text(subBoardName);
						},
						error: function() {
							return;
						}
					});
		       	}
		    }
		    
		    /* 2019-09-16 홍승비 - 기본 게시판으로 이동하기 위한 리다이렉트값 설정 함수 */
		    function setDefaultBoard() {
		    	var result = "";
		    	
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezBoard/getDefaultBoardID.do",
					success: function(resultStr) {
						if (resultStr != "") { // 기본 게시판ID가 테넌트 컨피그에 존재할때만 동작
					        RedirectBoardGroupID = resultStr.split(";")[0];
							RedirectBoardID = resultStr.split(";")[1];
							
							result = "OK";
						} else {
							result = "NO";
						}
					},
					error: function() {
						result = "NO";
					}
				});
		    	
		    	return result;
		    }
		    
			// 2023-06-28 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > 트리구조 서브메뉴 클래스 제어
			function liSelected() {
			  	if (event.target.classList.length == 1) {
			  		
			  		if ($(".node_selected").parent().is("div")) {
			  			$(".node_selected").attr("class", "node_normal");
			  		} else {
			  			$(".node_selected").attr("class", "list_text");
			  		}
			  		
			  		$(event.target).addClass("node_selected");
			  	}
	        }
			
			// 2023-10-27 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > 트리구조 메뉴 클래스 제어
			function h2Selected(h2){
				$("h2.on").attr("class", "off");
		    	$(".list_text.node_selected").removeClass("node_selected");
				$("#" + h2).parent().addClass("on");	
		    	$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		    	$("#TopBoardsList .lnbUL").attr("class", "lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class", "lnbUL off");
				$("#scrapUL").attr("class", "lnbUL off");
			}
			
		    /* 2023-05-22 기민혁 - 나의스크랩함 클릭 이벤트  */
		    function openScrapFolder(val01) {
				ScrapTreeViewRefresh();
	        	if ($("#" + val01 + "H2").attr("class") == "on") {	        	
	        		$("#" + val01 + "H2").attr("class", "off");
	        		$("#" + val01 + "UL").attr("class", "lnbUL off");
					$("#" + val01 + "H2").children().eq(1).attr("class", "sub_iconLNB tree_plus");
	        	} else {
					$("h2.on").not($("#myBoardList")).attr("class", "off");
					$("#TopBoardsList .lnbUL").attr("class", "off");
	        		$(".lnb H2").attr("class", "off");
					$("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
					$("#myBoardList").children().eq(0).attr("class", "sub_iconLNB tree_plus");
	        		//$(".lnb UL").not("#search").attr("class", "lnbUL off"); //검색 기능 선택 제외
					$("#" + val01 + "H2").children().eq(1).attr("class", "sub_iconLNB tree_arrow_down");
	        		$("#" + val01 + "H2").attr("class", "on")
	        		$("#" + val01 + "UL").attr("class", "lnbUL");
	        	}
	        }
		    
		    /* 2023-05-22 기민혁 - 나의스크랩함 config */
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/ezBoard/boardconttree_config.xml", false);
		        xmlHTTP.send();

		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
		        }
		    }
			
		    /* 2023-05-22 기민혁 - 나의스크랩함 노드 클릭 이벤트 */
		    function UserScrapContNodeClick(pNodeID, pNodeNM) {
		         	var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);
		            nodeIdx = pNodeID;
		            window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/getBoardScrapContItemListView.do?scrapContID=" + escape(treeNode.GetNodeData("DATA1")) + "&scrapContTitle=" + encodeURIComponent(treeNode.NodeName);
		    }
		    
		    /* 2023-05-22 기민혁 - 나의 스크랩함 data 호츌 */
		    function UserScrapContRequestData(pNodeID, pTreeID) {
	            nodeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);

	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + SSUserID + "</USERID><ParentScrapContID>" + treeNode.GetNodeData("DATA1") + "</ParentScrapContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/ezBoard/getUserScrapContSubTree.do", false);
	            xmlHTTP.send(strQuery);

	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(loadXMLString(xmlHTTP.responseText).documentElement, pNodeID);
	            
	            var node = document.getElementById(pNodeID);
		        var title2 = node.getElementsByClassName("node_div");
		        if (title2[0] !=null ) {
		        	var nodeLevel = title2[0].getAttribute("nodelevel");
		        }
		        
		        if (nodeLevel > 9) {
		        	nodeLevel = 9;
		        }
		        for (var i = 0; i < title2.length; i++) {
		        	var title3 = title2[i].getElementsByClassName("node_normal");
		        	//title3[0].setAttribute("TITLE", title3[0].innerHTML); 
		        	if (title3[0] != null) {
		        		title3[0].style.width = 145 - 16*(nodeLevel-1) +'px';
		        	//title3[0].style.textOverflow = 'ellipsis';
		        	//title3[0].style.overflow = 'hidden';
		        	// 개인문서함 하위폴더 확장 시, title 속성 부여
		        		title3[0].title = title3[0].innerText;
		        	}
		        }
	        }

		    /* 2023-05-22 기민혁 - 나의 스크랩함 새로고침 */
		    function ScrapTreeViewRefresh() {
	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><USERID>" + SSUserID + "</USERID><ParentScrapContID>ROOT</ParentScrapContID><NAME></NAME></DATA>";
	            xmlHTTP.open("POST", "/ezBoard/getUserScrapContSubTree.do", false);
	            xmlHTTP.send(strQuery);

	            var xmlDomRet = createXmlDom();
	            xmlDomRet = loadXMLString(getXmlString(loadXMLString(xmlHTTP.responseText).documentElement));

	            document.getElementById('divUserScrapContTree').innerHTML = '';
	            var treeView = new TreeView();
	            treeView.SetID("UserScrapContTree");
	            treeView.SetUseAgency(true);
	            treeView.SetRequestData("UserScrapContRequestData");
	            treeView.SetNodeClick("UserScrapContNodeClick");
	            treeView.DataSource(xmlDomRet);
	            treeView.DataBind("divUserScrapContTree");
	            
	            $(".node_normal").css("width", "145px");
 		          
				var node = $(".node_normal");
					
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].innerText);
				} 
	        }

			/* 2023-05-22 기민혁 - 나의스크랩함 관리 페이지 호출 */
		    var mnguserscrapcont_dialogArgument = new Array();
	        function MngUserOnclick() {
	            var url = "/ezBoard/mngUserScrapCont.do";
	            mnguserscrapcont_dialogArgument[0] = "";
	            mnguserscrapcont_dialogArgument[1] = MngUserOnclick_Complete;
	            var Opener = GetOpenWindow(url, "MngUserScrapCont", 465, 395, "NO");
	        }
	        
	        function MngUserOnclick_Complete(RtnVal) {
	            ScrapTreeViewRefresh();
	        }

			function AllBoard(h2) {
				if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemList_all.do?boardID=" + encodeURIComponent("{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}") + "&boardName=" + encodeURIComponent("<spring:message code="ezBoard.allboard.hth01" />") + "&boardType=E&buttonHidden=N";
				} else {
					window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_all.do?boardID=" + encodeURIComponent("{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}") + "&boardName=" + encodeURIComponent("<spring:message code="ezBoard.allboard.hth01" />") + "&boardType=E&buttonHidden=N";
				}
				h2Selected(h2);
			}

			function NewBoard(h2) {
				if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/boardItemList_allnew.do?boardID=" + encodeURIComponent("{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") + "&boardName=" + encodeURIComponent("<spring:message code="ezBoard.lyj01" />") + "&boardType=R&buttonHidden=N";
				} else {
					window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/boardItemList_allnew.do?boardID=" + encodeURIComponent("{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") + "&boardName=" + encodeURIComponent("<spring:message code="ezBoard.lyj01" />") + "&boardType=R&buttonHidden=N";
				}
				h2Selected(h2);
			}
			
			function goMealPlanTable() {

				// setH2Selected('mealPlan');
				h2Selected('mealPlan');
				if (typeof window.parent.frames["right"] == "undefined") {
					rightFrame.src = "/ezBoard/mealPlanView.do";
				} else {
					window.parent.document.querySelector("iframe[name=right]").src = "/ezBoard/mealPlanView.do";
				}
			}
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
	        	<p class="btn_write01" onclick="boardWrite();"><spring:message code="ezBoard.t999073" /></p>
	        </div>
	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
		        <div class="lnb_lay">
			        <h2 id="favoriteList" onclick="favoriteList()">
			            <span class="sub_iconLNB tree_plus"></span><span class="h2Title"><spring:message code="ezBoard.t00010" /></span>
			        </h2>
			        <c:if test="${MyBoardTopFlag != 'NO'}">
				        <h2 class="off" id="myBoardList"  onclick="ShowMyBoardItem()">
				            <span class="sub_iconLNB tree_plus"></span><span class="h2Title" style="display:inline-block;"><spring:message code="ezBoard.t360" /></span><span onclick="ConfigMyBoard()" class="sub_iconLNB tree_manage"></span>
				        </h2>
				        <ul class="lnbUL off" id="TreeCtrl_MyBoardTree_ul">
				        	<div class="tree onlytree" id='TreeCtrl_MyBoardTree'></div>
				        	<li><span class="list_text" onclick="MyBoard()"><spring:message code="ezBoard.t10032" /></span></li>
							<li><span class="list_text" onclick="ReservationItem_onclick()"><spring:message code="ezBoard.t229" /></span></li>
							<li><span class="list_text" onclick="TempBoard()"><spring:message code="ezBoard.t10030" /></span></li>
							<c:if test="${MyBoardScrapFlag eq 'TYPE1'}">
								<li><span class="list_text" onclick="ScrapBoard()"><spring:message code="ezBoard.kmh12" /></span></li>
							</c:if>
						</ul>
			        </c:if>
					<h2 class="off">
						<span class="sub_iconLNB tree_plus" onclick="NewBoard('newBoardList')"></span><span class="h2Title" id="newBoardList" onclick="NewBoard('newBoardList')"><spring:message code="ezBoard.lyj01" /></span>
					</h2>
					<h2 class="off">
						<span class="sub_iconLNB tree_plus" onclick="AllBoard('allBoardList')"></span><span class="h2Title" id="allBoardList" onclick="AllBoard('allBoardList')"><spring:message code="ezBoard.allboard.hth01" /></span>
					</h2>
			        <div id='TopBoardsList'>
			        	<script type="text/javascript">
			        		parser = new DOMParser();
                            xmlDoc = parser.parseFromString("${resultXML}","text/xml");
		        			var i = 0;
		        			$(xmlDoc).find("NODE").each(function(i) {
		       			        document.write("<h2 class='off'>");
		       			     	document.write("<span>");

								if (i == 0) {
									var nodeValue = $(this).text();
									document.write("<span class='sub_iconLNB tree_arrow_down' onclick ='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()+ "\")'></span>");
			       			    } else {
			       			    	document.write("<span class='sub_iconLNB tree_plus' onclick ='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()+ "\")'></span>");
			       			    }

		       			     	document.write("<span id='TreeCtr" + i + "' class='h2Title' value='" + $(this).find("DATA1").text() + "' onclick='TopBoard_onclick(\"TreeCtrl" + i + "\", \"" + $(this).find("DATA1").text()
		               					+ "\")'>" + MakeXMLString($(this).find("DATA2").text()) + "</span>");
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
			        <c:if test="${MyBoardTopFlag == 'NO'}">
			        	<h2 class="off" id="myBoardList" onclick="ShowMyBoardItem()">
				            <span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" style="display:inline-block;"><spring:message code="ezBoard.t360" /></span><span onclick="ConfigMyBoard()" class="sub_iconLNB tree_manage"></span>
				        </h2>
				        <ul class="lnbUL off" id="TreeCtrl_MyBoardTree_ul" style="overflow:hidden">
				        	<div class="tree onlytree" id='TreeCtrl_MyBoardTree'></div>
                           	<li><span class="sub_iconLNB tree_board_my"></span><span class="list_text" onclick="MyBoard()"><spring:message code="ezBoard.t10032" /></span></li>
                           	<li><span class="sub_iconLNB tree_board_reservation"></span><span class="list_text" onclick="ReservationItem_onclick()"><spring:message code="ezBoard.t229" /></span></li>
                           	<li><span class="sub_iconLNB tree_outbox"></span><span class="list_text" onclick="TempBoard()"><spring:message code="ezBoard.t10030" /></span></li>
				        	<c:if test="${MyBoardScrapFlag == 'TYPE1'}">
								<li><span class="sub_iconLNB tree_task_repeat"></span><span class="list_text" onclick="ScrapBoard()"><spring:message code="ezBoard.kmh12" /></span></li>
				        	</c:if>
				        </ul>
				    </c:if>
					<c:if test="${MyBoardScrapFlag == 'TYPE2'}">
						<h2 class="off" id="scrapH2">
							<span class="sub_iconLNB tree_manage" onclick="MngUserOnclick()"></span>
							<span class="sub_iconLNB tree_plus" onclick="openScrapFolder('scrap')"></span><span class="h2Title" onclick="openScrapFolder('scrap')"><spring:message code="ezBoard.kmh12" /></span>
						</h2>
						<ul class="lnbUL off" id="scrapUL">
							<div class="tree onlytree" id="divUserScrapContTree"></div>
						</ul>
					</c:if>
			        <ul class="lnbUL">
                       	<%-- 2023-06-22 황인경 - 디자인 개선 > 게시판 > 좌측메뉴 > '검색' 태그 구조, LNB 이미지 수정 --%>
						<h2 class="off">
                           	<span class="sub_iconLNB tree_plus" onclick="boardSearch('boardSearchH2')"></span><span id="boardSearchH2" class="h2Title" value="" onclick="boardSearch('boardSearchH2')"><spring:message code="ezBoard.khj1" /></span>
						</h2>
<%--                       	<li><span class="sub_iconLNB tree_search"></span><span class="list_text" onclick="boardSearch()"><spring:message code="ezBoard.khj1" /></span></li> --%>
                    	<c:if test="${applyFlag == 'OK'}">
	                    	<h2 class="off">	
	                           	<span class="sub_iconLNB tree_plus" onclick="Apprboard('apprboardH2')"></span><span id="apprboardH2" class="h2Title" onclick="Apprboard('apprboardH2')" title="<spring:message code='ezBoard.t999001' />"><spring:message code="ezBoard.t999001" /><span id="applyCount">(${applyCount})</span>
	                        </h2>
                    	</c:if>
						<c:if test="${useMealPlan == 'YES'}">
						<h2 id="mealPlan" onclick="goMealPlanTable()">
							<span class="h2Title"><spring:message code='ezMealPlan.jsb001' /></span>
						</h2>
						</c:if>
			        </ul>
				</div>
			</div>
		</div>
	    <%-- 
	<body class="leftbody" style="overflow: auto; height:100%">
	    <div id="left" style="overflow-x: hidden; overflow-y: auto;">
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
       			        document.write("<h2 class='off' onclick='spanClick(\"TreeCtr" + i + "\")'>");
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
