<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code="ezBoard.t52" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	   	<%-- <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css"> --%>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	.tree {
	    		min-height : 100px;
	    	}
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
				display:inline-block;
			}

			#mCSB_1_container {
				margin-right: 0px;
			}

			.companySelect {
				position: relative;
				display: inline-block;
				width: 100px; /* 원하는 너비로 조정하세요 */
			}
			
			/* IE10+ 에서 화살표 제거 */
			.companySelect select::-ms-expand {
				display: none;
			}

			/* 크로스 브라우저 화살표 스타일링 */
			.companySelect::after {
				content: "\25BC";
				position: absolute;
				top: 50%;
				right: 5px;
				transform: translateY(-50%);
				pointer-events: none;
			}
			
	    </style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
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
	        var useLeftCnt = "${useLeftCnt}";

	        window.onload = function () {
	            if (RedirectBoardID != "") {
	                if (RedirectBoardGroupID != "") {
	                    BoardRedirect();
	                    return;
	                }
	            }
	        }
 
	        /* 2018-12-28 홍승비 - 게시판그룹명 > div -> span 태그로 변경된 부분 id 찾도록 수정 */
		    function BoardRedirect() {
		        var spans = document.getElementById("TopBoard").getElementsByClassName("h2Title");
		        for (var i = 0 ; i < spans.length ; i++) {
		            if (spans[i].getAttribute("value") == RedirectBoardGroupID) {
		                LoadTreeViewByPath(spans[i], RedirectBoardID, RedirectBoardGroupID);
		            }
		        }
		    }
		    
	        /* 2018-12-31 홍승비 - 하위게시판 찾는 코드 변경된 태그로 수정 */
		    function LoadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID) {
	            pObjSpan.onclick();

	            var selectItem;
	            var totalboard = "";
	            
	            if (pObjSpan.parentElement.nextSibling.nodeType == 1) {
	                totalboard = getFirstChild(pObjSpan.parentElement.nextSibling)
	            }else{
	                totalboard = getFirstChild(pObjSpan.parentElement.nextSibling.nextSibling)
	            }
	            
	            var cnt = totalboard.children[0].getElementsByTagName("div").length;

	            for (var i = 0; i < cnt; i++) {
	            	
	            	// 각 하위게시판의 div를 얻는다. (class -> node_div, node_select)
	                if (RedirectBoardID == totalboard.children[0].getElementsByTagName("div")[i].getAttribute("data1")) {
	                    selectItem = totalboard.children[0].getElementsByTagName("div")[i];
	                    break;
	                } else { // 리다이렉트 게시판ID와 div의 게시판ID가 일치하지 않는 경우 -> 하위게시판을 확인
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
	            
	            var spanLevel = parseInt(selectItem.getAttribute("nodelevel")) + 2;
	            selectItem.getElementsByTagName("span")[spanLevel].onclick();
	            var tempid = selectItem.id.split("_");
	            var tempidlength = tempid.length;
	            var clicknode = new Array();
	            
	            if (CrossYN()) {
	                for (var i = 0; i < tempidlength; i++) {
	                    if (selectItem.getAttribute("DATA3") != pBoardGroupID) {
	                        if (selectItem.id != null && selectItem.id != "0" && selectItem.id.indexOf("sub") == -1) {
	                            clicknode[i] = selectItem.id;
	                        } else {
	                            i--;
	                        }
	                        // 다수의 태그가 부모로 존재 -> 반복해서 parentElement를 찾는다.
	                        selectItem = selectItem.parentElement.parentElement.parentElement.parentElement;
	                    } else if (selectItem.getAttribute("DATA3") == pBoardGroupID) {
	                    	// isleaf 속성이 FALSE인 경우에만 트리 확장 아이콘 진행
	                    	if (selectItem.getAttribute("isleaf") == "FALSE") {
	                        	selectItem.childNodes[0].onclick();
	                        }
	                        var j = clicknode.length;
	                        
	                        // 목표 게시판까지 도달한 경우(k=1), 마지막 확장은 불필요하므로 건너뛴다.
	                        for (var k = j; k > 1; k--) {
	                        	var exLevel = parseInt(document.getElementById(clicknode[k - 1]).getAttribute("nodelevel"));
	                            document.getElementById(clicknode[k - 1]).childNodes[exLevel].onclick();
	                        }
	                        return;
	                    }
	                }
	            } else {
	                for (var i = 0; i < tempidlength; i++) {
	                    if (selectItem.getAttribute("DATA3") != pBoardGroupID) {
	                        if (selectItem.id != null && selectItem.id != "0" && selectItem.id.indexOf("sub") == -1) {
	                            clicknode[i] = selectItem.id;
	                        } else {
	                            i--;
	                        }
	                        selectItem = selectItem.parentElement.parentElement.parentElement.parentElement;
	                    } else if (selectItem.getAttribute("DATA3") == pBoardGroupID) {
	                    	if (selectItem.getAttribute("isleaf") == "FALSE") {
	                        	selectItem.childNodes[0].click();
	                    	}
	                        var j = clicknode.length;
	                        
	                        for (var k = j; k > 1; k--) {
	                        	var exLevel = parseInt(document.getElementById(clicknode[k - 1]).getAttribute("nodelevel"));
	                            document.getElementById(clicknode[k - 1]).childNodes[exLevel].click();
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
		        /* var node = document.getElementById(TreeIdx);
		        var title2 = node.getElementsByClassName("node_div");
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
		        } */
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
				/* var node = $(".node_normal");
				for(var i=0; i<node.length; i++) {
					node[i].setAttribute("TITLE", node[i].parentElement.getAttribute("DATA2"));
					node[i].style.width = '152px';
					node[i].style.textOverflow = 'ellipsis';
					node[i].style.overflow = 'hidden';
				} */
				
				var ctr = $("#TreeCtr"+num[1]).closest("h2");
	            var ctrobj = $("#"+obj + "obj").closest("ul");
	            
	            $("h2.on").not(ctr).attr("class","off");
	            $("#TopBoard .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
	            
	            if (ctr.attr("class") == "off") {
	            	ctr.attr("class","on");		            	
	            	ctrobj.attr("class","lnbUL");
	            	/* 2023-06-22 황인경 - 디자인 개선 > 관리자 > 게시판 > 좌측메뉴 트리구조 확장 LNB 이미지 추가  */
	            	$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
	            	$(ctr).children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
	            	
	            	/* ctrobj.animate({
	            		maxHeight: "250px"
	            	}, 500, function(){
		            	ctrobj.attr("class","lnbUL");
	            	}); */		            	
	            } else {
	            	ctrobj.attr("class","lnbUL off");
	            	ctr.attr("class","off");
	            	$(ctr).children().eq(0).attr("class", "sub_iconLNB tree_plus");
	            	
	            	/* ctrobj.animate({
	            		maxHeight: "0px"
	            	}, 500, function(){		            			
	            		ctrobj.attr("class","lnbUL off");
	            		ctr.attr("class","off")
	            	}); */		            	
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
	            isAdminLeft = "Y";  // 2023-11-02 조소정 - 관리자단에서 접근했는지 판단하는 플래그 추가
		    	var xmlhttp3 = createXMLHttpRequest();
				var urlUtil = URLParamsUtils("/ezBoard/getSubBoards.do?");
				var url = urlUtil.put("rootBoardID", pRootBoardID).put("subFlag", pSubFlag)
						.put("selectFlag", "0").put("isAdminLeft", "Y").put("companyID",companySelectID).getFullUrl();
		        xmlhttp3.open("POST", url, false);
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
	                        window.parent.frames["board_main"].location.href = "/admin/ezBoard/boardConfig.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&tabID=1tab2";
	                    }
	                }else{                	
	                    window.parent.frames["board_main"].location.href = "/admin/ezBoard/boardConfig.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&boardType=" + chkPhotoBrd + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID);
	                }
	                
	                /* 2019-04-19 홍승비 - 하위게시판 진입 시 해당 게시판 좌측리스트의 게시물 카운트 갱신 */
	                refreshItemCnt(pNodeID);
	            }
	            catch (e) {
	                alert(e.description);
	            }
	        }

	        function OpenRightMenu(pIndex) {
	            curMenuIndex = pIndex;
				// 선택된 게시판/그룹이 있어야 하는 경우
				var needSelected = [2,3,4,5,6,7];
				// 선택된 게시판이 그룹이 아니어야 할경우
				var needNotGroup = [4];

				if (needSelected.indexOf(pIndex) > -1 && !SelectedBoardID) {
					alert("<spring:message code='ezBoard.t56' />");
					return;
				}

				if (needNotGroup.indexOf(pIndex) > -1 && SelectedBoardID === SelectedBoardGroupID) {
					alert("<spring:message code='ezBoard.t138' />");
					return;
				}

	            switch (pIndex) {
	                case 1:
	                    window.open("/admin/ezBoard/boardGroupCreate.do", "board_main");
	                    break;
	                case 2:
	                    window.open("/admin/ezBoard/boardCreate.do?parentBoardID=" + encodeURIComponent(SelectedBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID), "board_main");
	                    break;
	                case 3:	                	
	                    window.open("/admin/ezBoard/boardOrder.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID), "board_main");
	                    break;
	                case 4:	                    
                        window.open("/admin/ezBoard/boardMove.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID), "board_main");
	                    break;
	                case 5:	                    
	                    window.open("/admin/ezBoard/boardDelete.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardGroupID=" + encodeURIComponent(SelectedBoardGroupID), "board_main");	                    
	                    break;
	                case 6:
	                    window.open("/admin/ezBoard/boardProperty.do?boardID=" + encodeURIComponent(SelectedBoardID), "board_main");
	                    break;
	                case 7:
	                    window.open("/admin/ezBoard/boardACL.do?parentNeed=Y&boardID=" + encodeURIComponent(SelectedBoardID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID) + "&accessLevel=" + AccessLevel, "board_main");
	                    break;
	                case 8:
	                    window.open("/admin/ezBoard/boardBackGround.do?parentNeed=Y&boardID=" + encodeURIComponent(SelectedBoardID) + "&companyID=" + encodeURIComponent(companySelectID) + "&parentBoardID=" + encodeURIComponent(SelectedBoardParentBoardID), "board_main");
	                    break;
					/* 2022-09-27 홍승비 - 트리캐시 일괄생성기능 추가 */
	                case 9:
	                    window.open("/admin/ezBoard/boardMakeAllTreeCache.do", "board_main");
	                    break;
	                default:
						window.open("/admin/ezBoard/boardRight.do", "board_main");
	                    break;
	            }

        		// 2023-07-03 황인경 - 디자인 개선 > 관리자 > 게시판 > 좌측메뉴 하단 영역 > 메뉴 선택 시 on class 제어
    	        $("li.on").removeClass("on");
				if (!!event) $(event.target).parent().addClass("on");
	        }
	        
	        /* 2018-12-28 홍승비 - '+/-' 아이콘 > img -> span 태그로 변경된 부분 id 찾도록 수정 */
	        function SearchTreeViewByPath(imgtag, parentNodeid) {
	            if (imgtag.indexOf("sub") == -1 && document.getElementById(imgtag).className.indexOf("plus") > -1) {
	                document.getElementById(imgtag).onclick();
	                document.getElementById(imgtag).onclick();
	                return 0;
	            } else {
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
	        
	        /* 2018-12-28 홍승비 - 게시판그룹 열린 상태 유지하며 트리뷰를 갱신하는 기존 함수 추가 */
	        function treeViewRefresh(obj, ID) {
	        	var AccessLevel = "1";
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
	        
	        /* 2019-02-14 홍승비 - 좌측 게시판리스트의 펼치기 화살표 클릭 시 하위게시판 불러오도록 수정*/
		    function spanClick(divID) {
		    	document.getElementById(divID).click();
		    }
	        
		    /* 2019-07-08 홍승비 - 게시물 등록, 삭제, 복사, 이동시 좌측메뉴의 선택된 하위게시판 게시물 개수 갱신 함수 추가 */
		    function refreshItemCnt(pNodeID) {
		       	if (useLeftCnt == "YES") {
			    	var SelectedBoardID = document.getElementById(pNodeID).getAttribute("data1");
		            var orgBoardName = document.getElementById("spn_" + pNodeID).innerText;
		            var orgBoardTitle = document.getElementById(pNodeID).getAttribute("data2");// personalizedPortal용 변수 설정
				    var orgItemCount = orgBoardName.substring(orgBoardTitle.length + 1, orgBoardName.length);
				    
				    if (orgBoardTitle == orgBoardName) {
				    	orgItemCount = 0;
				    }
			    	
			    	 /* 2019-04-19 홍승비 - 하위게시판 진입 시 해당 게시판 좌측리스트의 게시물 카운트 갱신 */
			    	$.ajax({
						type : "GET",
						dataType : "text",
						async : false,
						url : "/ezBoard/getItemCount.do",
						data : {
							boardID : SelectedBoardID
						},
						success: function(resultCount) {
							if (orgItemCount != resultCount) {
								var newNodeName = "";
								if (resultCount > 0) {
									newNodeName = orgBoardTitle + " " + "(" + resultCount + ")";
								} else {
									newNodeName = orgBoardTitle;
								}
								document.getElementById("spn_" + pNodeID).innerText = newNodeName;
							}
						},
						error: function() {
							return;
						}
					});
		       	}
		    }
		    
		    function manageMealPlan() {
				window.open('/admin/ezBoard/boardACL.do?parentNeed=Y&boardID=%7BMMMMMMMM-MMMM-MMMM-MMMM-MMMMMMMMMMMM%7D&parentBoardID=None&accessLevel=1', 'board_main');
	            $("h2.on").attr("class","off");
	            $("#TopBoard .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
                $(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		    }
	    </script>
	</head>
	<body class="newLeft">
	    <div id="left" class="lnb" style="overflow: auto">
            <%--<select id="ListCompany" class="companySelect adminBoardLeft" onchange="changeCompany()">
                <c:forEach var="item" items="${listCompany}">
                    <option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
                </c:forEach>
            </select>--%>
            <div class="admin_left_title">
                <spring:message code="ezBoard.t58" />
            </div>
	        <div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	        	<div class="lnb_lay">
		        	<div id="TopBoard"></div>
					<c:if test="${useMealPlan == 'YES'}">
		        	<h2 id="mealPlan" onclick="manageMealPlan()">
						<span class="h2Title"><spring:message code='ezMealPlan.jsb001' /></span>
					</h2>
					</c:if>
		        	<ul class="lnbUL">
                       	<li><span class="list_text" onclick="OpenRightMenu(1)"><spring:message code="ezBoard.t122" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(6)"><spring:message code="ezBoard.t60" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(7)"><spring:message code="ezBoard.t500" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(2)"><spring:message code="ezBoard.t62" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(3)"><spring:message code="ezBoard.t64" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(4)"><spring:message code="ezBoard.t65" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(5)"><spring:message code="ezBoard.t66" /></span></li>
                       	<li><span class="list_text" onclick="OpenRightMenu(8)"><spring:message code="ezBoard.t5006" /></span></li>
                       	<%-- 2022-09-27 홍승비 - 트리캐시 일괄생성기능 추가 --%>
                       	<li style=""><span class="list_text" onclick="OpenRightMenu(9)"><spring:message code="ezBoard.HSBAt001" /></span></li>
			        </ul>
		        </div>
	        </div>
		</div>
		<script>		
	    	var strHTML = "", data = "";
			var cnt = 0;
			var companySelectID = '<c:out value="${userCompany}" />';

			window.onload = function () {
				initLeft();
			};

			function initLeft() {
				strHTML = "";
				$.ajax({
					type: "POST",
					dataType: "json",
					async: false,
					url: "/admin/ezBoard/get_Admin_TopBoardList.do",
					data: {boardType: "top", company: encodeURIComponent(companySelectID)},
					success: function (result) {
						$.each(result, function (idx, item) {
							$.each(item, function (idx, i) {
								strHTML += "<h2 class='off'><span class='sub_iconLNB tree_plus'></span><span AccessLevel='1' class='h2Title' id='TreeCtr" + idx + "' value='" + i.boardId;
								strHTML += "' onclick=\"TopBoard_onclick('TreeCtrl" + idx + "','" + i.boardId + "')\">";
								strHTML += i.boardName + "</span></h2>";
								strHTML += "<ul class='lnbUL off'><div class='tree onlytree' name='BoardTree' id='TreeCtrl" + idx + "obj'>";
								strHTML += "</div></ul>";
							});
							cnt = item.length;
							data = item[0].boardId;
						});
						$("#TopBoard").html(strHTML);
					}
				});
			}

			function changeCompany() {
				companySelectID = document.querySelector("#ListCompany").value;
				refreshLeft();
			}

			function refreshLeft() {
				SelectedBoardID = "";
				SelectedBoardGroupID = "";
				SelectedBoardParentBoardID = "";
				initLeft();
				OpenRightMenu();
			}
			
		</script>
	</body>
</html>