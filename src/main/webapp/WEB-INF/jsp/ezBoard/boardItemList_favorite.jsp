<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<!-- <html style="height: 99%;"> -->
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <!-- <link rel="stylesheet" href="${util.addVer('/css/tab_over.css')}" type="text/css"> -->
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <style type="text/css">
	    .tabpart01UL{
	    	position:absolute;
	    	top:35px;
	    	right:0px;
	    	background:white;
	    	padding:15px;
	    	border:1px solid #999;
	    	width:120px;
	    	list-style-image:url("/images/kr/cm/dot_blue.gif");
	    }
	    .tabpart01UL li {
	    	height:23px;
	    	color:#777;
			white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
	    }
	    </style>
	    <script type="text/javascript">
	        var userLang = "${userInfo.primary}";
	        var lang = "${userInfo.lang}";
	        var xmlhttp = createXMLHttpRequest();
	        var timer = null;
			var useRunTime = "${useRunTime}"
	        
			window.onresize = function () {
				var delay = 100;
				/**
					onresize의 경우 완료되는 경우 한 번에 실행되는 것이 아니라. 유저가 화면을 만질때마다 계속 발생.
					setTimeout을 이용해서 resize 작업이 끝날 경우에만 동작하도록 처리.
				*/
				clearTimeout(timer);
				timer = setTimeout(resizeMenuTab, delay);
				
				resizeIframe(document.getElementById("FBoard_ifrm"));
			}
			
	        window.onload = function () {
	            GetMyBoardItem();
				/* 2024-07-09 김유진 - RunTime 표시 기능 사용 시 즐겨찾기 페이지 높이 조절 */
				if (document.getElementById("FBoard_ifrm") != null) {
					var FBoardHeight = document.getElementById("FBoard_ifrm").clientHeight;
					var newHeight = FBoardHeight - 22 - document.getElementById("tab1").offsetHeight;
					document.getElementById("FBoard_ifrm").style.height = newHeight + "px";

				}
	        };
	        
	        /**
	        	브라우저 리사이즈 대비 tab 동적 변경
	        */
	        function resizeMenuTab() {
				var doNotRefresh = true;      // 화면을 리프레시 하는지 여부.
				var isOpenUL;                 // '...' 탭이 열리있는지 확인
				//var isResize = true;          // 리사이즈 중인지 확인.
				
				// '...'탭이 열려있는 경우를 판단
				if(document.getElementById("tabpart01UL") === null || document.getElementById("tabpart01UL").style.display == "none") {
					isOpenUL = false;
				} else {
					isOpenUL = true;	
				}
				
				var selectedNode = document.getElementById("curBoardID").value;
				
				document.getElementById("tab1").innerHTML = "";
				widthCheck = false;
				
				GetMyBoardItem_evnet(doNotRefresh);

				if(document.querySelectorAll('[data1="'+selectedNode+'"]')[0].tagName === "LI"){
					selectedNode = "overSpan";
				}				
				
				// GetMyBoardItem_event를 끝내고 '...'탭의 display상태를 유지
				if(isOpenUL && document.getElementById("tabpart01UL") !== null ) {
					document.getElementById("tabpart01UL").style.display = "";	
				}
				
				// 기존에 선택되는 0번탭 해제 후 재설정.
				document.getElementById("1tab0").className = "";
				
				// 선택된 탭이 리사이징으로 인해 '...' 탭으로 가게되는 경우
				if (document.getElementById(selectedNode) !== null) {
					document.getElementById(selectedNode).className = "tabon";
					Tab1_SelectID = selectedNode;
				} else {
					// '...' 탭에서 보통 탭으로 나올 경우
					selectedNode = document.querySelectorAll('[data1="'+selectedNode+'"]')[0].id;	
					if (selectedNode != "") {
						document.getElementById(selectedNode).className = "tabon";
						Tab1_SelectID = selectedNode;
						
						if (document.getElementById("overSpan")) {
							document.getElementById("overSpan").className = "";
						}
					} else {
						if (document.getElementById("overSpan")) {
							document.getElementById("overSpan").className = "tabon";
						}
						
						Tab1_SelectID = "overSpan";
					}
					
					/* 2018-12-04 홍승비- '...'탭이 없는 경우 접근 시 스크립트 에러 수정 */
					if (document.getElementById("tabpart01UL") !== null || document.getElementById("tabpart01UL")) {
						document.getElementById("tabpart01UL").style.display = "none";
					}
					
				}
	        }
	        function GetMyBoardItem() {
	            xmlhttp.open("POST", "/ezBoard/get_favoriteList.do?mode=USE", true);
	            xmlhttp.onreadystatechange = GetMyBoardItem_evnet;
	            xmlhttp.send();
	        }
	        var overCnt = 0;
	        var widthCheck = false;
	        var overCntText = '...';
	        function GetMyBoardItem_evnet(doNotRefresh) {
            	if (xmlhttp == null || xmlhttp.readyState != 4) return;
	            try {
	                var xmlnode = SelectNodes(xmlhttp.responseXML, "ROOT/DATA/ROW");
	                if (xmlnode.length != 0) {
	                    for (var i = 0; i < xmlnode.length; i++) {
	                        var BoardName = MakeXMLString(getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME")));
	                        var BoardName2 = MakeXMLString(getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME2")));
	                        var BoardName3 = MakeXMLString(getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME3")));
	                        var BoardName4 = MakeXMLString(getNodeText(SelectSingleNode(xmlnode[i], "BOARDNAME4")));
	                        var BoardId = getNodeText(SelectSingleNode(xmlnode[i], "BOARDID"));
	                        var BoardType = getNodeText(SelectSingleNode(xmlnode[i], "GUBUN"));
	                        var _p = document.createElement("P");
	                        _p.id = "FBoard_sub" + i;
	
	                        var _span = document.createElement("SPAN");
	                        _span.id = "1tab" + i;
	                        _span.setAttribute("divname", "FBoard_div" + i);
	                        _span.setAttribute("name", "FBoard_div");
	                        _span.setAttribute("DATA1", BoardId);
	                        
	                        /* 2019-03-29 홍승비 - 새게시물 다국어 메세지 수정 */
	                        if (BoardId == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
								_span.setAttribute("DATA2", "<spring:message code='ezBoard.t480'/>");
								_span.innerHTML = "<spring:message code='ezBoard.t480'/>";
                        	} else {
								_span.setAttribute("DATA2", BoardName);
								_span.innerHTML = BoardName;
                        	}
	                        _span.setAttribute("DATA5", BoardType);
	                        
	                        _p.appendChild(_span);
	                        document.getElementById("tab1").appendChild(_p);
	
							var tabAllWidthVal = tabAllWidth(); 
	                        if (tabAllWidthVal >= document.getElementById("tab1").offsetWidth - 55 || widthCheck) {
	                            widthCheck = true;
	                            //overCnt = overCnt + 1;
	                            
	                            document.getElementById("tab1").removeChild(_p);
	                            if (document.getElementById("tabpartMore") == null) {
	                                var _p2 = document.createElement("P");
	                                _p2.className = "tabpartMore";
	                                _p2.id = "tabpartMore";
	                                //_p2.onclick = function () { Tab1_MouseClick_more(document.getElementById("overSpan"), false) }
	
	                                var _span2 = document.createElement("SPAN");
	                                _span2.id = "overSpan";
	                                if (document.getElementById("tabpart01UL") != null) {
	                                    _span2.textContent = document.getElementById("tabpart01UL").getElementsByTagName("li").length;
	                                }
	                                else {
	                                    //_span2.textContent = overCnt;
	                                	_span2.textContent = overCntText;
	                                }
	
	                                var _ul = document.createElement("UL");
	                                _ul.className = "tabpart01UL";
	                                _ul.id = "tabpart01UL";
	                                _ul.style.display = "none";
	
	                                var _li = document.createElement("LI");
	                                _li.setAttribute("DATA1", BoardId);
	                                _li.setAttribute("DATA5", BoardType);
	                                _li.textContent = ReplaceHTML(BoardName);
	                                _li.onclick = function () { Tab1_MouseClick2(this); };
	                                _li.style.cursor = "pointer";
	                                _ul.appendChild(_li);
	                                
	                                _p2.appendChild(_span2);
	                                _p2.appendChild(_ul);
	                                _p2.style.cursor = "pointer";
									
	                                document.getElementById("tab1").appendChild(_p2);
	                            }
	                            else {
	                                var _li = document.createElement("LI");
	                                _li.textContent = ReplaceHTML(BoardName);
	                                _li.setAttribute("DATA1", BoardId);
	                                _li.setAttribute("DATA5", BoardType);
	                                _li.style.cursor = "pointer";
	                                _li.onclick = function () { Tab1_MouseClick2(this); };
	
	
	                                document.getElementById("tabpart01UL").appendChild(_li);
	
	                                if (document.getElementById("tabpart01UL") != null) {
	                                    //document.getElementById("overSpan").textContent = document.getElementById("tabpart01UL").getElementsByTagName("li").length;
	                                    document.getElementById("overSpan").textContent = overCntText;
	                                }
	                                else {
	                                    //document.getElementById("overSpan").textContent = overCnt;
	                                	document.getElementById("overSpan").textContent = overCntText;
	                                }
	
	                                insertOption = "LAST";
	                            }
	                            //Tab1_MouseClick_more(document.getElementById("overSpan"), false);
	                        }
	                       
	                    }
	                    
	                    if (xmlnode.length > 0) {
	                        Tab1_NewTabIni("tab1");
	                    }    
						
	                    // 화면을 리사이징 할때는 현재 리스트는 그대로 유지
	                    if(doNotRefresh !== true) {
                    		document.getElementById("1tab0").setAttribute("class", "tabon");
                    		Tab1_SelectID = "1tab0";	                    	
                    		ChangeTab(document.getElementById("1tab0"));	
	                    }
	                }
	                else { // 사용자가 설정한 즐겨찾기가 없는 경우, 디폴트로 새게시물 표출
	                    var _p = document.createElement("P");
	                    _p.id = "FBoard_sub0";
	
	                    var _span = document.createElement("SPAN");
	                    _span.id = "1tab0";
	                    _span.setAttribute("divname", "FBoard_div0");
	                    _span.setAttribute("DATA1", "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}");
						_span.setAttribute("DATA2", "<spring:message code='ezBoard.t480'/>");
	                    _span.setAttribute("DATA5", "0");
	                    _span.innerHTML = "<spring:message code='ezBoard.t480'/>";
	
	                    _p.appendChild(_span);
	                    document.getElementById("tab1").appendChild(_p);
                    	
	                    if (xmlnode.length > 0) {
	                       	Tab1_NewTabIni("tab1");
	                    }	 	                    
	                    
	                    // 화면을 리사이징 할때는 현재 리스트는 그대로 유지
	                    if(doNotRefresh !== true) {
                    		document.getElementById("1tab0").setAttribute("class", "tabon");
                    		Tab1_SelectID = "1tab0";	                    	
                    		ChangeTab(document.getElementById("1tab0"));
	                    }
	                }
	
	            } catch (e) { }
	        }
	
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                        document.getElementById(Tab1_SelectID).className = "";
	
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                if (!displayFlag)
	                    document.getElementById("tabpart01UL").style.display = "";
	                else {
	                    if (document.getElementById("tabpart01UL").style.display == "")
	                        document.getElementById("tabpart01UL").style.display = "none";
	                    else
	                        document.getElementById("tabpart01UL").style.display = "";
	                }
	            }
	            else {
	                if (document.getElementById("tabpart01UL").style.display == "")
	                    document.getElementById("tabpart01UL").style.display = "none";
	                else
	                    document.getElementById("tabpart01UL").style.display = "";
	            }
	        }
	        function tabAllWidth() {
	            var allWidth = 0;
	            for (var i = 0; i < document.getElementById("tab1").getElementsByTagName("P").length; i++) {
	                allWidth += document.getElementById("tab1").getElementsByTagName("P")[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	            var SelectedBoardID = obj.getAttribute("DATA1");
	            var chkPhotoBrd = obj.getAttribute("DATA5");
	            
	            if (chkPhotoBrd == 3) {
	                document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemListPhoto.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            } else if (chkPhotoBrd == 4) {
	                document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemListThumbnail.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            } else if (chkPhotoBrd == 7) {
	                document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemListMovie.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            } else {
	                if (SelectedBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") {
	                    document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemList_new.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=N" + "&adminType=y&buttonHidden=N";
	                }
	                else
	                    document.getElementById("FBoard_ifrm").src = "/ezBoard/boardItemList.do?boardID=" + encodeURIComponent(SelectedBoardID) + "&boardName=" + encodeURIComponent(obj.getAttribute("DATA2")) + "&boardType=" + chkPhotoBrd + "&adminType=y&buttonHidden=N";
	            }
	            
	            document.getElementById("curBoardID").value = SelectedBoardID;
	        }
	
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id)
	                obj.className = "";
	        }
	        function Tab1_MouseClick(obj) {
	            if(document.getElementById("tabpart01UL") != null)
	                document.getElementById("tabpart01UL").style.display = "none";
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	            /* overSpan의 게시판을 선택하면 overSpan display:none처리*/
	            document.getElementById("tabpart01UL").style.display = "none";	            
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id != "overSpan")
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };
	                        else
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick_more(this, true); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	        
	        /* 2019-01-31 홍승비 - 즐겨찾기 > 권한설정 화면 리사이즈 시 스크롤 발생 높이 조정 */
	        function resizeIframe(obj) {
		        if (obj.contentWindow.location.href.indexOf("/ezBoard/boardACL.do") > -1) {
		        	obj.style.height = (document.documentElement.clientHeight - 85) + "px";
		        } else {
		        	obj.style.height = "100%";
					/* 2024-07-09 김유진 - RunTime 표시 기능 사용 시 즐겨찾기 페이지 높이 조절 */
					if (obj != null) {
// 						var FBoardHeight = obj.clientHeight;
// 						var newHeight = FBoardHeight - 22;
// 						obj.style.height = ((newHeight / FBoardHeight) * 100) + "%";
	 					var FBoardHeight = document.getElementById("FBoard_ifrm").clientHeight;
	 					var newHeight = FBoardHeight - document.getElementById("tab1").offsetHeight;
// 	 					document.getElementById("FBoard_ifrm").style.height = newHeight + "px";
	 					document.getElementById("FBoard_ifrm").style.height = ((newHeight / FBoardHeight) * 100) + "%";
					}
		        }
	        }
	        
	    </script>
	</head>
	<!-- <body class="mainbody" style="height: 89%;"> -->
	<body class="mainbody" style="height: 95%; overflow:hidden;margin-left:0px;margin-right:0px">
		<div style="padding-left:10px;padding-right:10px">
		    <h1><span id='mailBoxInfo'></span></h1>
		    <div class="portlet_tabnew01">
		        <div class="portlet_tabnew01_top" id="tab1"></div>
		    </div>
		</div>    
	    <iframe id="FBoard_ifrm" style="width: 100%; height: 100%;" onload="resizeIframe(this)" frameborder="0"></iframe>
	</body>
	<input type="hidden" id="curBoardID" namd="curBoardID" value=""/>
</html>