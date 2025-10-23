<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>left_mail</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <!-- 재은 수정 -->
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/NewMailList.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/unit/openWindowForMail.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <script type="text/javascript">
	        var pUse_Editor = "${useEditor}";
	        var subCode = '<c:out value="${subCode}"/>';
	        var funcCode = '<c:out value="${funCode}"/>';
	        var g_firstOpen = true;
	        var lang = "${userinfo.lang}";
	        var pNoneActiveX = "${noneActiveX}";
	        var reloadRetryCount = 1;
	      	var previewSubTree = "${previewSubTree}";
	      	var usePreviewSubTree = "${usePreviewSubTree}";
	      	var useBottomFrameOnly = "${useBottomFrameOnly}";
	      	var useMailBoxBackUp = "${useMailBoxBackUp}";
	      	var useMailReceiveScreen = "${useMailReceiveScreen}";
	      	var operatorMailAddress = "${operatorMailAddress}";
	      	var receiveText = "<spring:message code='ezEmail.t516' />";
	      	var pRefreshinterval = "${refreshInterval}";
	      	var spamOutLoginURI = "${spamOutLoginURI}";
	      	var pSaveInterval = 0;
		    var nextMailListRefreshTime = 0;
		    var refreshIntervalTimerId = 0;
		    var refreshTimeoutTimerId = 0;
	      	var shareId = "";
	      	var deletePermission = "";
	      	var sendPermission = "";
	      	var managePermission = "";
	      	var treeviewStr = "PostTreeView";
	      	var cryptResult = '<c:out value="${cryptResult}"/>';
			var spamSniperUrl = '<c:out value="${spamSniperUrl}"/>';
			var useSpamSniper = '<c:out value="${useSpamSniper}"/>';
			var shareCryptResult = "";
			var configFlag = "false";
			var shareInfoList = [
                                <c:forEach items="${shareInfoList}" var="info" varStatus="status">
                                    {
                                        shareId: '${info.shareId}',
                                        deletePermission: '${info.deletePermission}',
                                        sendPermission: '${info.sendPermission}',
                                        managePermission: '${info.managePermission}'
                                    }<c:if test="${!status.last}">,</c:if>
                                </c:forEach>
                                ];
	      	
	        document.onselectstart = function () { return false; };
	        window.onresize = function () {
	        }
	        
	        window.onload = function () {
	        	detailView();
				attachTagClickEvent();
				openTagFolder("on");
		    	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            Function_Flag(funcCode);
	            previewSubTreeCall();
	            leftResize();
		        // $(".taskListBox").mCustomScrollbar({
	        	// 	theme : "dark"
	        	// });
	            
	            if (pRefreshinterval != "") {
		            console.log('Setting Mail List Refresh Timer...');
		            
	                pSaveInterval = parseInt(pRefreshinterval) * 1000;		            
		            setMailListRefreshTimer();
		            
	                // 브라우저가 Page Visibility API를 지원할 때의 처리
	                if ('hidden' in document) {
	                    console.log('adding visibilitychange event handler');

	                    document.addEventListener('visibilitychange', onVisibilityChange);
	                    recordNextMailListRefreshTime();
	                }
		        }

				window.parent.frames['left'].document.addEventListener('click', HiddenFolderMenu);

				const topFrame = window.parent?.parent?.parent?.frames['topFrame'];
				if (topFrame && topFrame.contentWindow && topFrame.contentWindow.document) {
					topFrame.contentWindow.document.addEventListener('click', HiddenFolderMenu);
				}

				document.getElementById("taskListBox").addEventListener("scroll", function() {
                    HiddenFolderMenu();
				});
	        }
	        
	        function getCurrentTime() {
		        return new Date().getTime();		        
		    }
		    
		    function setMailListRefreshTimer() {
	            if (refreshIntervalTimerId != 0) {
	                clearInterval(refreshIntervalTimerId);
	                refreshIntervalTimerId = 0;
	            }
	            
		        if (pSaveInterval != 0) {
		        	refreshIntervalTimerId = setInterval(function() {
						if (parent.right.psSetTimeFlag) {
							return;
						}

		        		getUnreadCountAll();
		                recordNextMailListRefreshTime();

		            }, pSaveInterval);
		        }
		    }
		    
		    function recordNextMailListRefreshTime() {
		        nextMailListRefreshTime = getCurrentTime() + pSaveInterval;
		        
		        console.log('currentTime=' + new Date() + ',Interval=' + pSaveInterval);
		    }
		    
		    function onVisibilityChange() {
                var remainingTime = nextMailListRefreshTime - getCurrentTime();
              
                console.log(remainingTime/1000);
		        // 메일 목록 페이지 상태가 보임으로 변경될 때의 처리
 		        if (!document.hidden) { 		            
 		           console.log('remainingTime=' + remainingTime + ',showing...');
 		           
 		            // 다음 번 갱신 시간이 이미 지났으면 즉시 목록 갱신을 수행하고 갱신 타이머를 설정한다.
 		            if (remainingTime <= 0) {
 		                console.log('refresh time already passed. Refresing...');
 		                
	                	getUnreadCountAll();
 		                
                        // 다음 자동 갱신 시간을 기록한다.
                        recordNextMailListRefreshTime();
 		                
 		                setMailListRefreshTimer();
 		            // 다음 번 갱신 시간이 아직 남아 있으면 해당 시간에 갱신이 되도록 타이머를 등록한다.
 		            } else {

 		            	console.log('refresh time not yet passed. Registering Timer...');
 		            	
 		            	refreshTimeoutTimerId = setTimeout(function() {
 		            		
 		            		getUnreadCountAll();
 		            		
 		            		// 다음 자동 갱신 시간을 기록한다.
 		            		recordNextMailListRefreshTime();
 		            		
 		            		// 다시 주기적으로 갱신 타이머가 동작하도록 등록한다.
 		            		setMailListRefreshTimer();
 		            	}, remainingTime);

 		            }
 	            // 메일 목록 페이지 상태가 숨김으로 변경될 때의 처리     
		        } else {
		        	console.log('remainingTime=' + remainingTime + ',hiding...');
		            
		            // 목록 갱신 타이머를 제거한다.
		            if (refreshIntervalTimerId != 0) {
		                clearInterval(refreshIntervalTimerId);
		                refreshIntervalTimerId = 0;
		            }
		            
		            if (refreshTimeoutTimerId != 0) {
		                clearTimeout(refreshTimeoutTimerId);
		                refreshTimeoutTimerId = 0;
		            }
		        }
		    }
	        
	        /**
	        	메일함 ellipsis 추가.
	        	박종균
	        */
	        function applyEllipsisMailTree() {
	        	/**
	        		1. 왼쪽 메뉴에 존재하는 트리 node를 전부 가져온다.
	        		2. 그 안에서 들여쓰기가 된 img 갯수를 가져온다.
	        		3. 이미지 갯수를 통해 list가 표현될 width를 재설정한다.
	        	*/
	        	$("[id^='" + treeviewStr + "_node']").each(function(index, element){
	        		
	        		var imgCnt = $(element).parent().children('.sub_iconLNB').length - 2;
	        		
	        		if (imgCnt > 0) {
	        			// 최초값 170, 한 블럭의 값 16 이지만 길이가 맞지 않아 14로 설정
	        			var customWidth = 170 - (14 * imgCnt);
	        			$(element).css("width", customWidth+"px");
	        			$(element).css("text-align", "justify");
	        		}
							
	        	});
	        }
	        
	        // 수정 수아 재은
	        function detailView(_shareId) {
	        	
	        	var requestUrl = "/ezEmail/mailGetUse.do";
	        	
	        	if (typeof(_shareId) != "undefined" && _shareId != "") {
	            	requestUrl += "?shareId=" + encodeURIComponent(_shareId);
	            }
	        	
                $.ajax({
                    url: requestUrl,
                    type: "POST",
                    dataType: "xml",
                    error : function(error) {
                        console.log(error);
                    },
                    success : function(xml_http) {
                       var result = xml_http;
                 	   var totalVolume = ""; 
                 	   var useVolume = "";
                 	   var percent = "";
                 	            
                 	   if (CrossYN()) { 
                 	        totalVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].textContent;
                 	        useVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].textContent; 
                 	        percent = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent;                    
                 	   } else { 
                 	        totalVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].text;
                 	        useVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].text; 
                 	        percent = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text;
                 	   }

                 	   //뿌려주기
                 	   $("#myBar").css({
                 	       "width" : percent + "%"
                 	   });                 	                   
                 	   //$("#useVol").html(useVolume + "<span>/ " + totalVolume + "</span>");
                 	   $("#usePer").text(percent+"% " + "(" + useVolume + " / " + totalVolume + ")");
                 	   
                 	   //용량 체크(색깔로)
                 	   if (percent >= 80) {
                 		  $("#myBar").removeClass().addClass("mailBar danger");
                 	   } else if (percent >= 70) {
                 		  $("#myBar").removeClass().addClass("mailBar warning");
                 	   } else {
							$("#myBar").removeClass().addClass("mailBar");
                 	   }               		   
                    }
                });        	    
	        }	        
	        
        	// 2017.12.27 단암 시스템 트리 열기 
            // plus 이미지의 갯수를 확인 한 후 하위 트리를 재귀적으로 호출하여 오픈시킨다. 오픈된 하위트리는 minus 이미지로 바꿔준다.
            // 환경설정에서 기존설정값과 신규설정값이 다르면 트리를 재호출하여 적용시킨다. 
            // 편지함 관리에서도 닫기버튼을 누르면 트리를 재호출하여 적용시킨다.
	        function previewSubTreeCall(type){
				if (typeof type != "undefined") {
        			previewSubTree = type;

            		if (usePreviewSubTree == "YES" && previewSubTree == "N") {
    	            	var treeArrNum = $('.tree_plus').length;

    		          	for (var i = 0; i < treeArrNum; i++) {
    		        	    var getSubtree = $('.tree_plus').eq(i).attr('name');
    		        	    var idx = getSubtree.split(treeviewStr + '_img_');
    		        	    
    		        	    if (typeof idx[1] != "undefined") {
    		        	    	var attr = $('#' + treeviewStr + '_img_' + idx[1]).attr("class").split(' ');
    		        	    	
    		        	    	if (attr[1] != "tree_plus") {
    		        	    		window[treeviewStr].toggle(idx[1]);
    		        	    	}
    		        	    }
    		          	}
    		          	treeArrNum = $('.tree_plus').length;
    		          	if(treeArrNum > 0){
    		          		previewSubTreeCall(type);
    		          	}
    	            }
        		}
	           
        		 if (usePreviewSubTree == "YES" && previewSubTree == "Y") {
		            var treeArrNum = $('#' + treeviewStr + ' .tree_plus').length;

		          	while(treeArrNum > 0) {
		        	    var getSubtree = $('#' + treeviewStr + ' .tree_plus').eq(0).attr('name');
		        	    var idx = getSubtree.split(treeviewStr + '_img_');
		        	    
		        	    if (typeof idx[1] != "undefined") {
		        	    	var childxml = get_childXML(window[treeviewStr].getvalue(idx[1], "href"), false, true, false);
		        	    	window[treeviewStr].putchildxml(idx[1], childxml);
		        	    	$('#' + treeviewStr + '_img_' + idx[1]).attr("class", "sub_iconLNB tree_minus");
		        	    	treeArrNum--;
		        	    }
		          	}
		          	treeArrNum = $('#' + treeviewStr + ' .tree_plus').length;
		          	if(treeArrNum > 0){
		          		previewSubTreeCall();
		          	}
	            }
	        }
        	
	        function write_Letter() {
				openWindowForMail("/ezEmail/mailWrite.do?cmd=NEW", "", null);
	        }
	        
	        function write_LetterToMe() {
	            openWindowForMail("/ezEmail/mailWrite.do?cmd=NEW&isMailToMe=YES", "", null);
	        }
	        
	        function LoadEmailTree() {
	            var PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            PostTreeView.attachEvent('requestdata', requestdata);
	            PostTreeView.attachEvent('nodeselect', selectnode);
	            PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
	            PostTreeView.attachEvent('dragdrop', email_dragdrop);
	            PostTreeView.dragdrop(true);
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false); 
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            } else {
	                treeconfig = xmlHTTP.responseXML;
	            }
	
	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + document.getElementById("RootFolderXML").innerHTML + "</nodes></tree>");
	            PostTreeView.update();
	            
	            if (subCode != "1" && subCode != "") {
	                PostTreeView.select(subCode);
	            } else {
	                PostTreeView.select(2); // inbox를 defualt로 셀렉트
	            }
	            
	            <c:if test="${not withoutNodeSelect}">
                selectnode();
                </c:if>
                previewSubTreeCall();
	        }
	        function requestdata(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_childXML(window[treeviewStr].getvalue(nodeIdx, "href"), false, true, false);
	            window[treeviewStr].putchildxml(nodeIdx, childxml);
	            
	            /**
	            	ellipsis 적용을 위해 함수 호출
	            */
	            applyEllipsisMailTree();
	        }
	        
	        function selectnode(event) {
	        	if (!event) event = window.event;
				/* 2018-08-06 장진혁 스크립트 오류로 undefined 걸름 */
	        	if (typeof(event) !== "undefined") {
		        	if (event.which != 3) {
					    var nodeIdx = window[treeviewStr].selectedIndex();
						openRightFrameDefault(window[treeviewStr].getvalue(nodeIdx, "foldername"),
											  window[treeviewStr].getvalue(nodeIdx, "href"),
											  shareId);
		        	}
	        	}

	        	openFolder();
	        }
	        
	        function email_dragdrop(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	
	            var szCommand = (event.bctrl) ? "copy" : "move";
	            var szSubCommand = event.command;
	
	            if (CrossYN()) {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").move_on_dragdrop(window[treeviewStr].getvalue(event.nodeIdx, "href"));
	                    } catch (e) {console.log(e);}
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").copy_on_dragdrop(window[treeviewStr].getvalue(event.nodeIdx, "href"));
	                    } catch (e) {console.log(e);}
	                }
	            }
	            else {
	                if (szCommand == "move" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.move_on_dragdrop(window[treeviewStr].getvalue(event.nodeIdx, "href"));
	                    } catch (e) {console.log(e);}
	                }
	                else if (szCommand == "copy" && szSubCommand == "ViewMailListMove") {
	                    try {
	                        window.parent.frames("right").document.Script.copy_on_dragdrop(window[treeviewStr].getvalue(event.nodeIdx, "href"));
	                    } catch (e) {console.log(e);}
	                }
	            }
	        }
	        var xmlHTTP_Unread = null;
	        function get_unreadcount_2010() {
	            if (xmlHTTP_Unread != null)
	                return;
	            try {
	                xmlHTTP_Unread = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
                	var href = window[treeviewStr].getvalue(window[treeviewStr].selectedIndex(), "href");
                	
                	createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "URL", href);
	                
	                if (shareId != "") {
		                createNodeAndInsertText(xmlpara, objNode, "SHAREID", shareId);
	                }
	                
	                xmlHTTP_Unread.open("POST", "/ezEmail/getFolderUnreadCount.do", true);
	                xmlHTTP_Unread.onreadystatechange = get_unreadend_2010;
	                get_unreadend_2010.href = href;
	                xmlHTTP_Unread.send(xmlpara);
	            }
	            catch (e) {
	                xmlHTTP_Unread = null;
	            }
	        }
	        function get_unreadend_2010() {
	            if (xmlHTTP_Unread == null || xmlHTTP_Unread.readyState != 4)
	                return;
	            if (xmlHTTP_Unread.status >= 200 && xmlHTTP_Unread.status < 300) {
            		var unreadcount = getNodeText(SelectNodes(xmlHTTP_Unread.responseXML, "FOLDERUNREADCOUNT")[0]);
            		var totalUnreadCount = getNodeText(SelectNodes(xmlHTTP_Unread.responseXML, "TOTALUNREADCOUNT")[0]);
	                var caption = window[treeviewStr].getvalue(window[treeviewStr].selectedIndex(), "foldername");
	                var href = window[treeviewStr].getvalue(window[treeviewStr].selectedIndex(), "href");
	
	                if (get_unreadend_2010.href == window[treeviewStr].getvalue(window[treeviewStr].selectedIndex(), "href")) {
	                    if (unreadcount == "0") {
	                    	window[treeviewStr].putcaption(window[treeviewStr].selectedIndex(), caption);
	                        //window[treeviewStr].putstyle(window[treeviewStr].selectedIndex(), "font-weight : ''");
	                    } else if ("allMail" != href) {
	                        // 2023-06-23 황인경 - 디자인 개선 > 메일 > 좌측 메뉴 > 카운트 괄호 추가
							window[treeviewStr].putcaption(window[treeviewStr].selectedIndex(), caption + "(" + unreadcount + ")");
	                    }

	                    // rightFrame을 새로 고침할 필요는 없으나, left tree의 전체 메일함 카운트 값을 수정하기 위해 사용
	                    // 안읽은 모든 메일 삭제를 하는 경우 unreadcount가 0일때에 속하기 때문에 모든 상황에 적용
	                    getUnreadCountAll('no');

						var rightFrame = parent.frames["right"];
                        if (rightFrame != "undefined" && typeof rightFrame.folderUnreadCount !== 'undefined') {
                            if (rightFrame != null){
                                var pageSrc = rightFrame.document.location.toString();
								if (pageSrc.indexOf("mailList.do") != -1) {
                                    try { rightFrame.folderUnreadCount.innerText = " " + unreadcount + " "; } catch (e) {console.log(e);}
			                    }
		                    }
	                  	}
	                }
	                
	                setTotalUnreadCount(shareId, parseInt(totalUnreadCount));
	            }
	            
	            xmlHTTP_Unread = null;
	            applyEllipsisMailTree();
	        }
	        
	        function getUnreadCountAll(refreshRight) {
	        	var refreshRightOff = refreshRight== 'no';
	        	var mailboxList = [];
	        	var nodeCount = window[treeviewStr].nodecount();
	        	
	        	for (var i = 0; i < nodeCount; i++) {
	        		mailboxList.push(window[treeviewStr].getvalue(i + 1, "href"));
	        	}
	        	
	        	var requestData = {
        			"mailboxList" : mailboxList
	        	}
	        	
	        	if (shareId != "") {
	        		requestData.shareId = shareId;
                }
	        	
	        	$.ajax({
                    url: "/ezEmail/getUnreadCountAll.do",
                    type: "POST",
                    contentType: "application/json",
                    dataType: "json",
                    data : JSON.stringify(requestData),
                    success : function(result) {
						if (parent.right.psSetTimeFlag) {
							return;
						}

                    	try {
	                    	if (result.resultCode === "OK") {
	                    		var unreadCountMap = result.unreadCountMap;
	                    		var href, caption, unreadCount;
	                    		var totalUnreadCount = result.totalUnreadCount;
	                    		var shareInfoList = result.shareInfoList;
	                    		
	                    		if (shareId === result.shareId) {
	                    			for (var i = 0; i < nodeCount; i++) {
		                    			href = window[treeviewStr].getvalue(i + 1, "href");
	                    				caption = window[treeviewStr].getvalue(i + 1, "foldername");
		                    			unreadCount = unreadCountMap[href];
	                    				
	                    				if (typeof(unreadCount) === 'undefined' || unreadCount === 0) {
		        	                    	window[treeviewStr].putcaption(i + 1, caption);
		        	                    } else {
		        	                    	// 2023-06-23 황인경 - 디자인 개선 > 메일 > 좌측 메뉴 > 카운트 괄호 추가
		        	                    	window[treeviewStr].putcaption(i + 1, caption + "(" + unreadCount + ")");
		        	                    }
		                    		}
	                    		}
	                    		
	                    		setTotalUnreadCount("", totalUnreadCount);
	                    		
	                    		if ("${useSharedMailbox}" == "YES") {
	                    			for (var i = 0; i < shareInfoList.length; i++) {
		                    			shareInfo = shareInfoList[i];
		                    			setTotalUnreadCount(shareInfo.shareId, parseInt(shareInfo.totalUnreadCount));
		                    		}
	                    		}
	                    		
	                    		if (refreshRightOff) { return; }

                   				try {
                    				var pageSrc = parent.frames["right"].document.location.toString();
            	                    
                    				if (pageSrc.indexOf("mailList.do") > -1) {
                    				    if (parent.frames["right"].searchMode != true){
                    				        parent.frames["right"].MailListRefresh();
                    				    }
            	                    }
                   				} catch (e) {console.log(e);}
	                    		
	                    		applyEllipsisMailTree();
	                    	} else {
	                    		console.error(result.resultCode);
	                    	}
                    	} catch (e) {
                    		console.error(e);
                    	}
                    },
                    error : function(error) {
                        console.error(error);
                    }
                });
	        }
	        
	        function get_unreadcount() {
	            return get_unreadcount_2010();
	        }
	        function check_pop3() {
	            var OpenWin = window.open("/ezEmail/mailGetPop3.do", "mail_getpop3_cross", GetOpenWindowfeature(460, 375));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        var mail_foldermanage_Cross_dialogArguments = new Array();
	        function folder_manage() {
	            mail_foldermanage_Cross_dialogArguments[1] = folder_manager_after;
	            
	            var requestUrl = "/ezEmail/mailFolderManage.do";
	            
	            if (shareId != "") {
	            	requestUrl += "?shareId=" + encodeURIComponent(shareId);
	            }
	            
	            var OpenWin = window.open(requestUrl, "mail_foldermanage_Cross", GetOpenWindowfeature(570, 500));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        function folder_manager_after(RtnVal) {
	            setTimeout(function() {
		            if (RtnVal) {
		            	var href = window[treeviewStr].getvalue(1, "href");
		            	
		            	window[treeviewStr].source("<tree><nodes>" + get_childXML("", true, true, false, true) + "</nodes></tree>");
		            	window[treeviewStr].update();
		                
		                if (window[treeviewStr].selectedIndex() == -1) {
		                	window[treeviewStr].select(2);
		                }
		                
						// openRightFrameDefault()가능?
		                var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(window[treeviewStr].getvalue(2, "foldername")) + "&url=" + encodeURIComponent(window[treeviewStr].getvalue(2, "href"));
		                
		            	if (shareId != "") {
		            		url += "&shareId=" + encodeURIComponent(shareId);
			            }
		                
		                parent.document.querySelector("iframe[name=right]").src = url;
		                
		                previewSubTreeCall();
		                applyEllipsisMailTree();
		            	detailView();
		            }
	            }, 10);
	        }
	        
	        /**
	        	메일함 트리뷰 reload 함수
	        */
	        function mailbox_treeview_reload() {
	        	setTimeout(function() {
	        		window[treeviewStr].source("<tree><nodes>" + get_childXML("", true, true, false, true) + "</nodes></tree>");
	        		window[treeviewStr].update();
	                
	        		getUnreadCountAll();
	                previewSubTreeCall();
	                applyEllipsisMailTree();
	                detailView();
	        	}, 100);
	        }
	        
	        function Function_Flag(v_data) {
	            v_data = parseInt(v_data);
	
	            switch (v_data) {
	                case 1:
	                    LoadEmailTree();
	                    break;
	                case 2:
	                    LoadEmailTree();
	                    WebPartToggle(level1El.item(level1El.length - 1));
	                    break;
	            }
	        }
	        function WebPartToggle(obj) {
	
	            if (obj.listNum && currentListNum != obj.listNum + 1) {
	                level1El.item(currentListNum - 1).className = null;
	                level2El.item(currentListNum - 1).className = "off";
	            }
	
	            if (level2El.item(obj.listNum).className == "on") {
	                level1El.item(obj.listNum).className = null;
	                level2El.item(obj.listNum).className = "off";
	            }
	            else {
	                level1El.item(obj.listNum).className = "on";
	                level2El.item(obj.listNum).className = "on";
	            }
	
	            currentListNum = obj.listNum + 1;
	
	            setMenu(level2El.item(obj.listNum));
	        }
	        function TreeView_toggle(TreeView, TreeFunc, subfolder) {
	            if (TreeView.style.display == "none") {
	                if (typeof (subfolder) != "undefined")
	                    TreeFunc(subfolder);
	                else
	                    TreeFunc();
	            }
	            else
	                TreeView.style.display = "none";
	        }
	        function Open_Mail(treeid) {
	            PostTreeView.select(treeid);
	        }
	        function Open_Search() {
	            try {
					var url = "/ezEmail/mailSearchView.do";
	                
	                if (shareId != "") {
	                	url += "?shareId=" + encodeURIComponent(shareId);
	                }
	                
	                parent.document.querySelector("iframe[name=right]").src = url;
	            } catch (e) {console.log(e);}
	            liSelcted();
	        }
	        
	        function openSpamBox() {
	            try {
	                var url;
	                
	             	// 2024.03.26 한슬기 : 스팸메시지함 호출 url변경
	                //url = "https://gwspam.bizmeka.com/personal/index.php?email=${credentialForBizmekaSpambox}&init=mail";
	                //parent.document.querySelector("iframe[name=right]").src = url;
	                url = "https://gwspam.ktbizoffice.com/personal/index.php?email=${credentialForBizmekaSpambox}&init=mail";
	                window.open(url, "_blank", "width=870, height=500");
	            } catch (e) {	              
					console.log(e);  
	            }	            
	        }
	        
			function oepnSpamOutBox() {
				try {
                    parent.document.querySelector("iframe[name=right]").src = spamOutLoginURI;
				} catch (e) {
				    console.log(e);
				}
			}

		    function Open_ApprMail(t) {
		    	let url = "";
		    	switch(t.dataset.type) {
			    	case "p" : url = "/ezEmail/appr/pendingList.do?startNum=1"; break;
			    	case "c" : url = "/ezEmail/appr/completeList.do?startNum=1"; break;
			    	case "r" : url = "/ezEmail/appr/requestList.do?startNum=1"; break;
		    	}
		    	
		    	if($(t).data("id")) {
		    		url += "&shareId=" + $(t).data("id");
		    	}
		    	
		    	parent.document.querySelector("iframe[name=right]").src = url;
		    }
		    
	        function Open_ReservationManage(shareId) {
				var requestUrl = "/ezEmail/mailReservation.do";
				requestUrl += shareId? "?shareId=" + encodeURIComponent(shareId) : "";
				var OpenWin = window.open(requestUrl, "mail_reservation_cross", GetOpenWindowfeature(560, 380));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        function Open_Restore() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 500) / 2;
	            var pLeft = (pwidth - 700) / 2;
	            var name = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
	            var path = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
	            var OpenWin;
	            if (!CrossYN())
	                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted.aspx?name=" + encodeURIComponent(name) + "&path=" + encodeURIComponent(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
	            else
	                OpenWin = window.open("/myoffice/ezEmail/mail_restore_deleted_cross.aspx?name=" + encodeURIComponent(name) + "&path=" + encodeURIComponent(path), "mail_restore_deleted", GetOpenWindowfeature(700, 490));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        function spam_mail() {
	            frmSpam.target = "right";
	            frmSpam.submit();
	        }
	        function mail_Config(shareId) {
	        	var requestUrl = "/ezEmail/mailConfig.do?flag=email";
	        	
	        	if (typeof(shareId) != "undefined" && shareId != "") {
	        		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	        	}
	        	
	            parent.document.querySelector("iframe[name=right]").src = requestUrl;
	            detailView(shareId);
	            liSelcted();
	        }
	        
	        function Email_Menu_Click() {
	        	shareId = "";
	        	deletePermission = "";
	        	sendPermission = "";
	        	managePermission = "";
	        	treeviewStr = "PostTreeView";
	        	
	        	HiddenFolderMenu();
	        	
		    	if (useMailBoxBackUp == "YES") {
			    	document.getElementById("mailbox_import").style.display = "";
		    	}
		    	
			    document.getElementById("mailbox_delete").style.display = "";
				
				if (document.getElementById("tagtitle") != null) {
					document.getElementById("tagtitle").style.display="";
				}
				
	        	detailView();
	        	window[treeviewStr].select(2);
	        	openFolder();
	        	openTagFolder("on");
	        }
	        
	        function showProgress() {
			    document.getElementById("progressPanel").style.display = "block";
			    document.getElementById("progressPanel").style.opacity = 0.5;
			    document.getElementById("progressPanel").style.background = "rgba(0,0,0,0.7)";
			}
	        
	        function hideProgress() {
	        	document.getElementById("progressPanel").style.display = "none";
	        }
	        
		    function goPage(idx) {
				var url = "";
				
				switch (idx) {
				    case 1:
				        url = "/admin/ezOrgan/organRight.do";
						break;
				    case 2:
				        url = "/admin/ezEmail/mailDistributionList.do";
						break;
					case 3:
						url = "/admin/ezEmail/mailDefaultQuota.do" ;
						break;
					case 4:
						url = "/admin/ezEmail/mailConfigColor.do";
						break;
					case 5:
						url = "/admin/ezOrgan/retireUserManage.do";
						break;
					case 6:
						url = "/ezStatistics/statisticsMailMain.do";
						break;
				    case 7:
				        url = "/ezStatistics/statisticsMailDept.do";
					    break;
			        case 8:
			            url = "/ezStatistics/statisticsMailUser.do";
			            break;
			        case 9:
			            url = "/ezStatistics/statisticsQuantityDept.do";
			            break;
			        case 10:
			            url = "/ezStatistics/statisticsQuantityUser.do";
			            break;
			        case 11:
			        	url = "/ezStatistics/statisticsMailRecieveLogList.do";
			        	break;
			        case 12:
			        	url = "/ezStatistics/statisticsMailSendLogList.do";
			        	break;			            
			        case 13:
			        	url = "/admin/ezSystem/systemMainMenu.do";
			        	break;			            
			        case 14:
			        	url = "/admin/ezEmail/mailQuotaList.do";
			        	break;			            
				}
				
				parent.document.querySelector("iframe[name=right]").src = url;
			}

			// scroll한 뒤 컨텍스트 메뉴의 위치가 잘못 나오는 현상이 있어 수정  
			var scrollTop = 0;
			$(window).scroll(function() {
				scrollTop = $(this).scrollTop();
			});

 			function event_folderMenu(event) {
 				event.preventDefault();
 				
 				// 전체메일인 경우 실행하지 않는다.
                var nodeIdx = window[treeviewStr].selectedIndex();
                var folderPath = window[treeviewStr].getvalue(nodeIdx, "href");
                
                if ("allMail" == folderPath) {
                    return;
                }
 				
		    	if (!event) event = window.event;
		        var EventMouseX = event.clientX;
		        var EventMouseY = event.clientY;

		        var listsizeheight = document.documentElement.clientHeight;
		        var listsizewidth = document.documentElement.clientWidth;

				var EventDivSize = EventMouseX + 140;
				if (listsizewidth < EventDivSize) {
		            var Div_ = EventDivSize - listsizewidth;
		            EventMouseX = EventMouseX - Div_;
		        }

                if (scrollTop > 0) {
                	EventMouseY += scrollTop;
                }

		        //document.getElementById("folderPanel").style.display = "";
		        document.getElementById("folderMenuDiv").style.left = EventMouseX + "px";
		        document.getElementById("folderMenuDiv").style.top = EventMouseY + "px";
		        document.getElementById("folderMenuDiv").style.display = "";
		        
		        if (parent.frames["right"].document.getElementById("mailPanel")) {
			        if ( parent.frames["right"].document.getElementById("mailPanel").style.display == "none") {
				        parent.frames["right"].document.getElementById("mailPanel").style.display = "";
			        }
		        }
		    }
		    
		    function HiddenFolderMenu(){
		    	document.getElementById("folderPanel").style.display = "none";
		        document.getElementById("folderMenuDiv").style.display = "none";
		    	
		        if (typeof parent.frames["right"] != "undefined") {
		        	if (document.getElementById("mailPanel") != null){
				        if (parent.frames["right"].document.getElementById("mailPanel").style.display == "") {
				        	parent.frames["right"].document.getElementById("mailPanel").style.display = "none";
				        }
		        	}
		        }
		    }
		    
		    //편지함 모두 읽기
		    function folder_ReadChange(pGubun){
		    	var xmlHTTP = createXMLHttpRequest();
		    	var nodeIdx = window[treeviewStr].selectedIndex();
	            var href = window[treeviewStr].getvalue(nodeIdx, "href");
	            var foldername = window[treeviewStr].getvalue(nodeIdx, "foldername");
	            var isRead = "FALSE";
	            
	            if (pGubun == "R") {
	            	isRead = "TRUE";
	            }
	            
	            var requestUrl = "/ezEmail/folderSetReadChange.do?url=" + encodeURIComponent(href) + "&isRead=" + isRead;
	            
	            if (shareId != "") {
	            	requestUrl += "&shareId=" + encodeURIComponent(shareId);
	            }
	            
	            xmlHTTP.open("POST",requestUrl, false);
	            xmlHTTP.send();
	            
				openRightFrameDefault(foldername, href, shareId);
		    }
		    
		    function mailbox_export(){
		    	try {
		    		var nodeIdx = window[treeviewStr].selectedIndex();
		    		var folderPath = window[treeviewStr].getvalue(nodeIdx, "href");
		    		
		    		if (typeof (parent.frames["right"].g_moveUrl) == "undefined" || parent.frames["right"].g_moveUrl != folderPath) {
		            	var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(folderPath);
		            	
		            	if (shareId != "") {
		            		url += "&shareId=" + encodeURIComponent(shareId);
			            }
		            	
		            	parent.document.querySelector("iframe[name=right]").src = url;
		    		}
	            	
            		setTimeout(function() {
	            		parent.frames["right"].mailbox_export();
		        	}, 1000);
	            	
	            } catch (e) {
	            	console.log("mailbox_export error!");
	            }
		    }
		    
		    function mailbox_import(){
		    	try {
		    		var nodeIdx = window[treeviewStr].selectedIndex();
		    		var folderPath = window[treeviewStr].getvalue(nodeIdx, "href");
		    		
		    		if (typeof (parent.frames["right"].g_moveUrl) == "undefined" || parent.frames["right"].g_moveUrl != folderPath) {
		            	var url = "/ezEmail/mailList.do?dispname=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "foldername")) + "&url=" + encodeURIComponent(folderPath);
		            	
		            	if (shareId != "") {
		            		url += "&shareId=" + encodeURIComponent(shareId);
			            }
		            	
		            	parent.document.querySelector("iframe[name=right]").src = url;
		    		}
		    		
	            	parent.frames["right"].mailbox_import();
	            } catch (e) {
	            	console.log("mailbox_import error!");
	            }
		    }
		    
		   function mailbox_delete() {
			   try {
				   var nodeIdx = window[treeviewStr].selectedIndex();
		    	   var folderPath = window[treeviewStr].getvalue(nodeIdx, "href");
		    	   
		    	   var trashBoxURL = "${pDeleteBoxID}";
			        
			      	//지운편지함의 메일 영구삭제
			        if (folderPath == trashBoxURL) {
			            if (confirm("<spring:message code='ezEmail.t470' />")) {
				            if (confirm("<spring:message code='ezEmail.ksa03' />")) {
				                delete_mail(folderPath, true, "");
				            }
			            }
			        }
			      	//편지함의 메일 지운편지함으로 이동  
			        else {
			            if (confirm("<spring:message code='ezEmail.t475' />")) {
			            	if (confirm("<spring:message code='ezEmail.ksa04' />")) {
				                delete_mail(folderPath, false, trashBoxURL);	
			            	}
			            }
			        }
			      	
			   } catch (e) {
				   console.log("mailbox_delete error!");
			   }
		   }
		   
		   var xmlHTTP2 = null;
		   var deltype = null;
		   function delete_mail(szURL, bDelete, destURL) {
		    	xmlHTTP2 = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        
		        if (bDelete) {
		            deltype = "MAILREALDEL";
		        } else {
		            deltype = "MAILDEL";
		        }
		        
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", destURL);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", deltype);
		        
		        var requestUrl = "/ezEmail/mailMakeFolder.do";
		        
		        if (shareId != "") {
		        	requestUrl += "?shareId=" + encodeURIComponent(shareId);
	            }
		        
		        xmlHTTP2.open("POST", requestUrl, true);
		        xmlHTTP2.onreadystatechange = delete_mail_complete;
		        xmlHTTP2.send(xmlDOM);
		        
		        ShowMailProgressNew();
		    }
		   
			function delete_mail_complete() {
				if (xmlHTTP2 != null && deltype != null && xmlHTTP2.readyState == 4) {
					var nodeIdx = window[treeviewStr].selectedIndex();
					var foldername = window[treeviewStr].getvalue(nodeIdx, "foldername");
					var href = window[treeviewStr].getvalue(nodeIdx, "href");
					
					HiddenMailProgressNew();
					HiddenFolderMenu();
		        	 
		            //지운편지함의 메일 영구삭제
		            if (deltype == "MAILREALDEL") {
		            	if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300) {
							if (xmlHTTP2.responseText == "OK") {
								alert("<spring:message code='ezEmail.t473' />");

								openRightFrameDefault(foldername, href, shareId);
					    	} else {
					    		alert("<spring:message code='ezEmail.t472' />");
					    	}
					    } else {
					    	alert("<spring:message code='ezEmail.t472' />");
					    }
		            }
		            //편지함의 메일 지운편지함으로 이동
					else {
						if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300) {
							if (xmlHTTP2.responseText == "OK") {
								alert("<spring:message code='ezEmail.t478' />");
								openRightFrameDefault(foldername, href, shareId);
		            		} else if (xmlHTTP2.responseText.indexOf("NO COPY processing failed.") > -1) {
		            			alert(strLang241);
		            		} else if (xmlHTTP2.responseText.indexOf("MAIL_NOT_EXISTS") > -1) {
		            			alert("<spring:message code='ezEmail.pyy23' />");
		            		} else {
		            			alert("<spring:message code='ezEmail.t477' />");
		            		}
						} else {
		            		alert("<spring:message code='ezEmail.t477' />");
		            	}
		            }
		        }
		    }
		   
			function HiddenMailProgressNew() {
				var CurrentHeight = parent.frames["right"].document.CurrentHeight;
				var CurrenWidth = parent.frames["right"].document.CurrenWidth;
				
			   parent.frames["right"].document.getElementById("mailPanel").style.display = "none";
			   parent.frames["right"].document.getElementById("mailPanel").style.backgroundColor = "";
			   parent.frames["right"].document.getElementById("MailProgress").style.display = "none";
			   hideProgress();
			   
			   if (useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
				} 
			}
		   
			function ShowMailProgressNew() {
				var CurrentHeight = parent.frames["right"].document.CurrentHeight;
				var CurrenWidth = parent.frames["right"].document.CurrenWidth;
				
				parent.frames["right"].document.getElementById("mailPanel").style.display = "block";
				parent.frames["right"].document.getElementById("mailPanel").style.opacity = 0.5;
				parent.frames["right"].document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
				parent.frames["right"].document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
				parent.frames["right"].document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
				parent.frames["right"].document.getElementById("MailProgress").style.display = "";
			    showProgress();
			    
			    if (useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
				}
			}
			
			// 수신확인 메뉴 클릭
			function reception_check() {
	            openRightFrame(encodeURIComponent("<spring:message code='ezEmail.t516' />"), "receiveChk", "");
	            liSelcted();
			}

			// parent.document.querySelector("iframe[name=right]").src = url; 구절이 중복되어 통일함.
			function openRightFrame(dispname, url, extra) {
				// 메일 페이지로 처음 진입 시 (대 메뉴 "메일" 클릭)
				// : parent.frames["right"]는 있지만 빈 frame의 Window_onunload()는 없는 상태이기 때문에(window.open(right) 이 후 → Window_onunload() 있음.)
				// parent.frames["right"].Window_onunload(); 에러나는 것을 무시한다.(try-catch)
				try {
					if (typeof (parent.frames["right"]) != "undefined") {
						parent.frames["right"].Window_onunload();
					}
				} catch (e) {console.log(e);}

				// 메일 페이지로 처음 진입 시 (대 메뉴 "메일" 클릭)
				// : function selectnode(event)이 두 번 실행되어, 첫번째에는 window.open 실행하지 않도록 함. (왜 두 번 실행되는지는 분석 포기)
				if (g_firstOpen) {
					g_firstOpen = false;

				} else {
                    parent.document.querySelector("iframe[name=right]").src = "/ezEmail/mailList.do?dispname=" + dispname + "&url=" + url + extra;
				}

				get_unreadcount();
			}
			
			/**
			 * 원 함수(openRightFrame())는 : String과 extra를 받도록 하는데,
			 * String에 encodeURIComponent() 기본적용하고, shareId인 것은 : default로 공통적용할 수 있도록 함.
			 */
			function openRightFrameDefault(foldername, href, shareId) {
				openRightFrame(encodeURIComponent(foldername),
							   encodeURIComponent(href),
							   (shareId != "")? "&shareId=" + encodeURIComponent(shareId) : "");
			}

			function operatorSendMail() {
				openWindowForMail("/ezEmail/mailWrite.do?cmd=NEW&operatorMailAddress=" + operatorMailAddress, "", null);
		    }
			
			function leftResize(){
                $(".taskListBox").css("max-height", window.innerHeight - 220);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});

			// 2018-10-16 공유사서함 관련 함수 추가
			function Share_Menu_Click(_shareId, _deletePermission, _sendPermission, _managePermission) {
				shareId = _shareId;
				deletePermission = _deletePermission;
				sendPermission = _sendPermission;
				managePermission = _managePermission;
				treeviewStr = 'shareTreeView_' + shareId;
				var tagtitleId = "tagtitle_"  + shareId;

			    if (document.getElementById(treeviewStr).innerHTML === "") {
			        var xmlHTTP = createXMLHttpRequest();
			        var xmlDOM = createXmlDom();
			        var objNode;
			        createNodeInsert(xmlDOM, objNode, "DATA");
			        createNodeAndInsertText(xmlDOM, objNode, "URL", "");
			        createNodeAndInsertText(xmlDOM, objNode, "BCOUNT", "-1");
			        
			        xmlHTTP.open("POST", "/ezEmail/getFolderList.do?shareId=" + encodeURIComponent(shareId) + "&am=y", false);
			        xmlHTTP.send(xmlDOM);

			        var nodeTreeXml = xmlHTTP.responseText.replace("<DATA>", "").replace("</DATA>", "");
			        LoadEmailTree2(nodeTreeXml);
			    } else {
			    	window[treeviewStr].select(2);
			    }
			    
			    HiddenFolderMenu();
			    
			    if (deletePermission == "Y") {
			    	if (useMailBoxBackUp == "YES") {
				    	document.getElementById("mailbox_import").style.display = "";
			    	}
			    	
				    document.getElementById("mailbox_delete").style.display = "";
			    } else {
				    document.getElementById("mailbox_import").style.display = "none";
				    document.getElementById("mailbox_delete").style.display = "none";
			    }
				if (document.getElementById("tagtitleId") != null) {
			    	document.getElementById("tagtitleId").style.display="none";
				}
			    detailView(shareId);
			    openFolder();
			    openTagFolder("on");
			}
			
			function LoadEmailTree2(RootShareFolderXML) {
			    if (RootShareFolderXML.trim() == "") {
			        return;
			    }
			    
			    var shareTreeView = new TreeView('shareTreeView_' + shareId, 'shareTreeView_' + shareId);
			    shareTreeView.attachEvent('requestdata', requestdata);
			    shareTreeView.attachEvent('nodeselect', selectnode);
			    shareTreeView.attachEvent('nodedblclick', function () { shareTreeView.toggle(shareTreeView.selectedIndex()) });
			    
			    if (deletePermission == "Y") {
			    	shareTreeView.attachEvent('dragdrop', email_dragdrop);
			    	shareTreeView.dragdrop(true);
			    }
			    
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
			    xmlHTTP.send();
				
			    var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            } else {
	                treeconfig = xmlHTTP.responseXML;
	            }
			    
			    shareTreeView.config(treeconfig);
			    shareTreeView.source("<tree><nodes>" + RootShareFolderXML + "</nodes></tree>");
			    shareTreeView.update();
			    shareTreeView.select(2);
			    
			    selectnode();
			    previewSubTreeCall();
			}

			function SharefindID() {
			    var str = "";
			    
			    for (var i = 0; i < document.getElementsByTagName("ul").length; i++) {
			        if (document.getElementsByTagName("ul")[i].className == "on") {
			            str = document.getElementsByTagName("ul")[i];
			        }
			    }
			    
			    str = str.getElementsByTagName("div")[0].id;
			    var rtn = GetAttribute(document.getElementById(str), "value");
			    
			    return rtn;
			}

			function SharefindIndex() {
			    var str = "";
			    
			    for (var i = 0; i < document.getElementsByTagName("ul").length; i++) {
			        if (document.getElementsByTagName("ul")[i].className == "on") {
			            str = document.getElementsByTagName("ul")[i];
			        }
			    }
			    
			    str = str.getElementsByTagName("div")[0].id;
			    var rtn = GetAttribute(document.getElementById(str), "index");
			    
			    return rtn;
			}
			
			function setTotalUnreadCount(shareId, totalUnreadCount) {
				var totalUnreadCountId = "totalUnreadCount";
				var h2TitleId = "h2TitleMail";
				
				if (shareId != "") {
					totalUnreadCountId = "totalUnreadCount_" + shareId;
					h2TitleId = "h2Title_" + shareId;
				}
				
				var totalUnreadCountElem = document.getElementById(totalUnreadCountId);
				var h2TitleElem = document.getElementById(h2TitleId);
				
				if (totalUnreadCountElem != null) {
					// 2023-06-23 황인경 - 디자인 개선 > 메일 > 좌측 메뉴 > 카운트 괄호 추가
					totalUnreadCountElem.innerHTML = "(" + totalUnreadCount + ")";
					h2TitleElem.style.maxWidth = (155 - totalUnreadCountElem.offsetWidth) + "px";
				}
			}
			
			function openFolder() {
				var h2Id = "h2Mail";
				var ulId = "ulMail";

				if (shareId != "") {
					h2Id = "h2_" + shareId;
					ulId = "ul_" + shareId;
				}
				
				if ($("[id='"+h2Id+"']").attr("class") == "off") {
	        		$(".lnb H2").attr("class", "off");
	        		$(".lnb UL").attr("class", "lnbUL off");
	        		
	        		$("[id='"+h2Id+"']").attr("class", "on")
	        		$("[id='"+ulId+"']").attr("class", "lnbUL");
	        		$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
					$("#"+h2Id).children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
	        	}
				
				/* openTagFolder 함수에서 일괄적으로 처리하도록 주석
				$("#tagtitle").attr("class", "off");
				$("#tagtitle").children().eq(0).attr("class", "sub_iconLNB tree_plus");
				$("#tagcontent").attr("class", "lnbUL off");*/
				
	        	/* if ($("#" + h2Id).attr("class") == "off") {
	        		$(".lnb H2").attr("class", "off");
	        		$(".lnb UL").attr("class", "lnbUL off");
	        		
	        		$("#" + h2Id).attr("class", "on")
	        		$("#" + ulId).attr("class", "lnbUL");
	        	} */
	        	
	        }
			
			function shareMailAddress(){
				if(useSpamSniper == ''){
					return;
				}
				if (shareId == "") {
					return;
				}
				
            	$.ajax ({
    				type:"GET",
    				async: true,
    				url : "/ezEmail/shareBoxSpam.do",
    				data : { 
    					 "shareId"   		: shareId
    					},
    				dataType: "JSON",
    				success : function (data) {
    					shareCryptResult = data.cryptResult;
    					spamMailBox();
    				},
    				error : function(error) {
    					console.log(error);
    				}
    			});
			}
			
			function spamMailBox(){
				var cryptValue = "";
				
				if(shareId == ""){
					cryptValue = cryptResult;
				} else {
					cryptValue = shareCryptResult;
				}
				
				if (cryptValue == '' || spamSniperUrl == '' ){
					alert("<spring:message code='ezEmail.lhm14' />");
					return;
				}
				
                var url = spamSniperUrl + "?email=" + cryptValue + "&init=mail";
                parent.document.querySelector("iframe[name=right]").src = url;
			}
			
			function goAdress() {
	            openWindowForMail("/ezEmail/mailMain.do?funCode=2", "", null);
			}

			function openTagFolder(param) {
			    var tagtitleId = "tagtitle";
                var tagcontentId = "tagcontent";
                var isOn = param === "on";

                if (shareId != "") {
                	tagtitleId = "tagtitle_" + shareId;
                	tagcontentId = "tagcontent_" + shareId;
                }

                if ($("#" + tagtitleId).attr("class") == "off" || isOn) {
					/* reloadTags 함수 안에서 처리 하여 주석
					$("#tagtitle").attr("class", "off");
                    $("#tagtitle").children().eq(0).attr("class", "sub_iconLNB tree_plus");
                    $("#tagcontent").attr("class", "lnbUL off");*/
                    reloadTags();
				} else {
				    $("#" + tagtitleId).attr("class", "off");
                    $("#" + tagtitleId).children().eq(0).attr("class", "sub_iconLNB tree_plus");
                    $("#" + tagcontentId).attr("class", "lnbUL off");
				}
			}
			
			function attachTagClickEvent() {
                var tagcontentId = "tagcontent";

                if (shareId != "") {
                    tagcontentId = "tagcontent_" + shareId;
                }
				$("#" + tagcontentId + " a").on("click", function() {
                    parent.document.querySelector("iframe[name=right]").src = "/ezEmail/mailList.do?tagName=" + encodeURIComponent(this.innerText) + "&shareId=" + shareId;
				});
			}

			function reloadTags(additionalArgs) {
				$.ajax({
					cache: false,
					method: "get",
					data: { shareId: shareId },
					url: "/ezEmail/getUserTagList.do",
					success: function(result) {
						if (result.status == "error") {
							alert(strLang321);
							return;
						}

						parent.frames["right"].postMessage({ajaxUrl: 'getUserTagList', tags: result.data, ...additionalArgs});

						var tags = result.data;
						var tagtitleId = "tagtitle";
						var tagcontentId = "tagcontent";

						if (shareId != "") {
                        	tagtitleId = "tagtitle_" + shareId;
                        	tagcontentId = "tagcontent_" + shareId;
                        }

						var tagContentLi = $("#" + tagcontentId + " > li");

						tagContentLi.find("a").remove();
						tags.forEach(function(tag) {
							tagContentLi.append("<a data-idx='" + tag.idx + "'>" + tag.name + "</a> ");
						});
						attachTagClickEvent();

						if (tags.length == 0) {
						    $("#" + tagtitleId).attr("class", "off");
						    $("#" + tagtitleId).children().eq(0).attr("class", "sub_iconLNB tree_blank");
						    $("#" + tagcontentId).attr("class", "lnbUL off");
						} else {
						    $("#" + tagtitleId).attr("class", "on")
                            $("#" + tagtitleId).children().eq(0).attr("class", "sub_iconLNB tree_minus");
                            $("#" + tagcontentId).attr("class", "lnbUL");
						}
					},
					error: function() { alert(strLang321); }
				});
			}

			//address start
			function Address_Menu_Click() {
				LoadAddressTree(true);
				// TODO: mailLeft.jsp의 주소록 부분과 addressLeft.jsp의 주소록 부분은 공통 처리할 수 없는지? (c:import 또는 selectnode_address)
				if (AddressTreeView.selectedIndex() == -1)
					AddressTreeView.select(1);
				else
					selectnode_address();

				// openFolder
        		$(".lnb H2").attr("class", "off");
        		$(".lnb UL").attr("class", "lnbUL off");

        		$("#h2Address").attr("class", "on");
				$("#ul_address").attr("class", "lnbUL");

				applyEllipsisAddressTree();
			}

			function applyEllipsisAddressTree() {
				/**
					1. 왼쪽 메뉴에 존재하는 트리 node를 전부 가져온다.
					2. 그 안에서 들여쓰기가 된 img 갯수를 가져온다.
					3. 이미지 갯수를 통해 list가 표현될 width를 재설정한다.
				 */
				$($("[id^='AddressTreeView_node']"))
					.each(
						function(index, element) {
							var imgCnt = $(element).parent().children('.sub_iconLNB').length - 2;
							var title = $(element)[0].innerHTML;

							if (imgCnt > 0) {
								// 최초값 170, 한 블럭의 값 16 이지만 길이가 맞지않아 14로 설정
								var customWidth = 170 - (14 * imgCnt);
								$(element).css("width", customWidth + "px");
								$(element).css("text-align", "justify");
							}
						});
			}

			function selectnode_address() {
				var nodeIdx = AddressTreeView.selectedIndex();
				var url = "/ezAddress/addressMainList.do?folderid="
						+ encodeURIComponent(AddressTreeView.getvalue(nodeIdx,
								"folderid")) + "&type="
						+ encodeURIComponent(AddressTreeView.getvalue(nodeIdx, "type"));
				parent.document.querySelector("iframe[name=right]").src = url;
			}

			function address_Search() {
                parent.document.querySelector("iframe[name=right]").src = "/ezAddress/addressMainSearch.do";
				// liSelcted();
				/**
				 * TODO: $("#" + treeViewValue + " span.node_selected").attr("class", "node_normal");
				 * 		 → $(".node_selected").attr("class", "node_normal"); 로 바꿀 수는 없는 건지?
				 */
				$(".node_selected").attr("class", "node_normal");
			}

			var AddressTreeView = null;
			function LoadAddressTree() {
				if (AddressTreeView == null) {
					AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');

					AddressTreeView.attachEvent('requestdata', requestdata_address);
					AddressTreeView.attachEvent('nodeselect', selectnode_address);
				}

				var xmlHTTP = createXMLHttpRequest();
				xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
				xmlHTTP.send();
				var treeconfig;

				if (CrossYN()) {
					treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
				} else {
					treeconfig = new ActiveXObject("Microsoft.XMLDOM");
					treeconfig.async = false;
					treeconfig.loadXML(xmlHTTP.responseText);
				}

				AddressTreeView.config(treeconfig);
				AddressTreeView.source(document.getElementById("AddressFolderXML").innerHTML);
				AddressTreeView.update();

				if (funcCode == "2") {
					if (subCode != "1" && subCode != "") {
						AddressTreeView.select(subCode);
						selectnode_address();
					} else
						AddressTreeView.select(1);
				}
			}

			function requestdata_address(event) {
				if (!event) {
					event = window.event;
				}

				var nodeIdx = event.nodeIdx;

				if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
					nodeIdx = arguments[0].nodeIdx;
				}

				var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), 
						AddressTreeView.getvalue(nodeIdx, "ownerid"),
						AddressTreeView.getvalue(nodeIdx, "type"))
						AddressTreeView.putchildxml(nodeIdx, childxml);

				/**
					주소록 ellipsis 추가
				 */
				applyEllipsisAddressTree();
			}

			var address_foldermanage_dialogArguments = new Array();
			function address_foldermanage() {
				address_foldermanage_dialogArguments[1] = address_foldermanage_Complete;
				var OpenWin = window.open("/ezAddress/addressFolderManage.do",
						"address_foldermanage", GetOpenWindowfeature(500, 500));
				try {
					OpenWin.focus();
				} catch (e) {
				    console.log(e);
				}
			}

			function address_foldermanage_Complete(ret) {
				if (ret != undefined) {
					$.ajax({
						type : "GET",
						url : "/ezAddress/getRootAddressXML.do",
						dataType : "text",
						success : function(data) {
							document.getElementById("AddressFolderXML").innerHTML = data;
							LoadAddressTree();
						},
						error : function(ee) {
							alert("error: " + ee.status);
						}
					});
				}
			}

			// 주소록 트리 이름
			function send_AddressTitle() {
				var addressNames = document.getElementById('AddressTreeView').getElementsByClassName("node_selected");
				var addressTitle = addressNames[0].innerText;
				return addressTitle;
			}

			// 환경설정 호출
			function address_Config() {
				detailView();
		 		parent.document.querySelector("iframe[name=right]").src = "/ezEmail/mailConfig.do?flag=address";
				// liSelcted();
				$(".node_selected").attr("class", "node_normal");

			}
			//address end
			
			// 2023-06-28 황인경 - 디자인 개선 > 메일 > 좌측메뉴 > 트리구조 메일함/하단 메뉴 선택시 클래스 제어
			function liSelcted() {
                var treeViewValue = "PostTreeView";
                var tagtitleId = "tagtitle";
                var tagcontentId = "tagcontent";

                if (shareId != "") {
                    treeViewValue = "shareTreeView_" + shareId;
                    tagtitleId = "tagtitle_" + shareId;
                    tagcontentId = "tagcontent_" + shareId;
                }

	            $("#" + treeViewValue + " span.node_selected").attr("class", "node_normal");
	            $(".list_text.node_selected").removeClass("node_selected");

	            var mailBoxMenu = $(event.target);

	            <%-- 2024-06-12 이사라 - 계정 별로 태그를 지원하기 위해 위치 변경하여 아래 태그조건이 맞지 않아 주석처리
	            if (mailBoxMenu.prop("tagName") == "LI") {
	            	mailBoxMenu.children().attr("class", "list_text node_selected");
	            } else {
	            	mailBoxMenu.attr("class", "list_text node_selected");
	            }--%>
			}

			function Open_BigAttachManage() {
				try {
					let url = "/ezEmail/bigAttachManageView.do";

					if (shareId != "") {
						url += "?shareId=" + encodeURIComponent(shareId);
					}

					window.open(url, "right");
				} catch (e) {console.log(e);}
				liSelcted();
			}
			
	    </script>
		<style type="text/css">
			.myBar_red {
				height: 7px;				  
			  	background-color: #ff4040;
			}
			.myBar_yellow {
			  	height: 7px;				  
			  	background-color: #ff9c00;
			}
			.myBar_green {
			  	height: 7px;				  
			  	background-color: #82b9f6;
			}
			.userPer {
				font-family: Malgun gothic;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
			#mCSB_1 {
 				height: calc(100% - 90px);
			}
			/* tag css */
            .tag_area{margin: 13px 20px 13px 24px; border-top: 1px solid #E9E9E9; padding-top: 10px;}
            .tag_normal{font-size: 14px; height: 26px; line-height: 26px; color: #333; display: inline-block; padding: 0px 0px 0px 3px; font-family: 'Noto Sans KR', sans-serif; cursor: pointer; width: 76%; white-space: nowrap; text-overflow: ellipsis; overflow: hidden; box-sizing: border-box;}
            .lnbUL li.tagcontent{padding: 0px 6px 0px 8px; margin: 0px 10px; width: 100%;}
            .tag_area .lnbUL{padding: 2px 0px 10px 0px;}
            .tagcontent {word-break: keep-all;}
            .tagcontent a {
                padding: 3px 5px;
                border-radius: 4px;
                display: inline-block;
                max-width: 89%;
                white-space: nowrap;
                text-overflow: ellipsis;
                overflow: hidden;
                line-height: normal;
                background: #e8eef2;
                float: left;
                margin: 0 5px 5px 0;
            }
            .tagcontent a:hover {background: #c7d6e5; color: #000000;}
			/*#tagcontent { word-break: break-all; line-height: 215%; }
			#tagcontent a { padding: 4px; border-radius: 4px; }
			#tagcontent a:hover { background: #c0ccd5; color: #0470e4; }*/

			#taskListBox::-webkit-scrollbar {
				position: absolute;
				width: 9px;
				height: auto;
			}
		</style>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<div class="left_title" title="<spring:message code="ezEmail.t99000012" />"><spring:message code="ezEmail.t99000012" />
	    	<%-- 2023-07-31 이사라 - 주소록 email 아래 메뉴로 붙이면서 불필요하여 주석 처리
	    	<c:if test="${dotNetIntegration eq 'YES'}">
	    		<span class="sub_iconLNB tree_addressPop" title="<spring:message code="ezEmail.t99000041" />" onclick="goAdress()"></span>
	    	</c:if> --%>
	        	<span class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezEmail.t99000044" />" onclick="mail_Config()"></span>
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write02" onclick="write_LetterToMe()"><spring:message code="ezEmail.t99000010" /></p> 
	        	<p class="btn_write01" onclick="write_Letter()"><spring:message code="ezEmail.t99000013" /></p>
	        </div>
        	<div id="taskListBox" class="taskListBox" style="overflow:auto; padding-right: 0; max-height: 160px">
		        <h2 class="on" id="h2Mail" onclick="Email_Menu_Click();">
		        	<span class="sub_iconLNB tree_arrow_down"></span>
		        	<span class="h2Title" id="h2TitleMail" style="display:inline-block"><spring:message code="ezEmail.t99000012" /></span><span id="totalUnreadCount" class="txt_color" style="position:absolute;"></span>
		        </h2>
		        <ul class="lnbUL" id="ulMail">
		        	<div class="tree" id="PostTreeView" oncontextmenu="event_folderMenu(event); return false;" onclick="HiddenFolderMenu();"></div>
		        	<li onclick="reception_check();"><span class="list_text" title="<spring:message code="ezEmail.t516" />"><spring:message code="ezEmail.t516" /></span></li>
		            <li onclick="Open_Search();"><span class="list_text" title="<spring:message code="ezEmail.t641" />"><spring:message code="ezEmail.t641" /></span></li>
		            <c:if test="${useOnlyInnerMail != 'YES'}">
		            	<li onclick="check_pop3()"><span class="list_text" title="<spring:message code="ezEmail.t490" />"><spring:message code="ezEmail.t490" /></span></li>
		            </c:if>	
		            <li onclick="mail_exportall()" style="display: none;"><span class="list_text" title="<spring:message code="ezEmail.t99000014" />"><spring:message code="ezEmail.t99000014" /></span></li>
		            <li onclick="Open_ReservationManage()"><span class="list_text" title="<spring:message code='ezEmail.t605' />"><spring:message code="ezEmail.t605" /></span></li>
		            <li onclick="Open_BigAttachManage()"><span class="list_text"><spring:message code="ezEmail.bigAttach.kdh03" /></span></li>
                    <c:if test="${useBizmekaSpambox == 'YES'}">
		            	<li onclick="openSpamBox()"><span class="list_text" title="<spring:message code="ezEmail.ldh01" />"><spring:message code="ezEmail.ldh01" /></span></li>
		            </c:if>
		            <c:if test="${operatorMailAddress ne null && operatorMailAddress != ''}">
		            	<li onclick="operatorSendMail()"><span class="list_text" title="<spring:message code='ezEmail.0hun01' />"><spring:message code="ezEmail.0hun01" /></span></li>
		            </c:if>	
		            <c:if test="${useSpamSniper ne null && useSpamSniper != '' && useSpamSniper != 'NO'}">
		            	<li onclick="spamMailBox()"><span class="list_text"><spring:message code="ezEmail.ldh01" /></span></li>
		            </c:if>
		            <c:if test="${useSpamOut}">
		            	<li onclick="oepnSpamOutBox()"><span class="list_text"><spring:message code="ezEmail.ldh01" /></span></li>
		            </c:if>
		            <br/>
		            <c:if test="${useApprMail}"> <% // 승인메일 정책에서 하나라도 사용이면 true %>
		            	<c:if test="${isApprMailApprover}">
							<li onclick="Open_ApprMail(this)" data-type="p"><span class="list_text"><spring:message code="email.appr.title.pending" /></span></li> <% // 발송승인대기 %>
	                        <li onclick="Open_ApprMail(this)" data-type="c"><span class="list_text"><spring:message code="email.appr.title.complete" /></span></li> <% // 발송완료목록 %>
	                    </c:if>
                        <li onclick="Open_ApprMail(this)" data-type="r"><span class="list_text"><spring:message code="email.appr.title.request" /></span></li> <% // 발송요청목록 %>
	            	</c:if>
		            <%-- 태그 --%>
		            <c:if test="${useMailTag}">
                        <div class="tag_area">
                            <span>
                                <div id="tagtitle" class="on" onclick='openTagFolder();'>
                                    <span class="sub_iconLNB tree_blank"></span>
                                    <span class="tag_normal" style="text-align: justify;"><spring:message code="ezEmail.tag" /></span>
                                </div>
                                <ul class="lnbUL" id="tagcontent">
                                    <li class="tagcontent">
                                        <c:forEach items="${tags}" var="tag">
                                            <a data-idx="${tag.idx}" ><c:out value="${tag.name}" /></a>
                                        </c:forEach>
                                    </li>
                                </ul>
                            </span>
                        </div>
                    </c:if>
		        </ul>
		        <!-- 주소록 -->
		        <c:if test="${dotNetIntegration eq 'YES'}">
			        <div class="addressListBox"	style="overflow: hidden; padding-right: 0;">
						<h2 class="off" id="h2Address" onclick="Address_Menu_Click();">
							<span class="sub_iconLNB tree_arrow_up"></span>
							<span class="h2Title" id="h2TitleMail" style="display: inline-block">
								<spring:message code="ezEmail.t99000041" />
							</span>
						</h2>
						<ul class="lnbUL off" id="ul_address">
							<div class="tree" id="AddressTreeView">
								<div class="node_div">
									<span class="sub_iconLNB tree_blank"></span>
									<span class="sub_iconLNB tree_adress_individual"></span>
									<span class="list_text"><spring:message code='ezAddress.t145'/></span>
								</div>
								<div class="node_div">
									<span class="sub_iconLNB tree_blank"></span>
									<span class="sub_iconLNB tree_adress_department"></span>
									<span class="list_text"><spring:message code='ezAddress.t146' /></span>
								</div>
								<div class="node_div">
									<span class="sub_iconLNB tree_blank"></span>
									<span class="sub_iconLNB tree_adress_company"></span>
									<span class="list_text"><spring:message code='ezAddress.t147' /></span>
								</div>
							</div>
							<li onclick="address_Search()">
								<span class="list_text" title="<spring:message code="ezEmail.t99000042" />"><spring:message code="ezEmail.t99000042" /></span>
							</li>
							<li onclick="address_Config()">
								<span class="sub_iconLNB tree_rightconfig"></span>
								<span class="list_text" title="<spring:message code="ezEmail.t99000042" />"><spring:message code="ezAddress.ls001" /></span>
							</li>
						</ul>
					</div>
				</c:if>
				<!-- 공유사서함  -->
		        <c:if test="${useSharedMailbox == 'YES'}">
			        <c:forEach items="${shareInfoList}" var="shareInfo">
			        	<h2 class="off" id="h2_${shareInfo.shareId}" title="${shareInfo.shareName}" 
			        		 onclick="Share_Menu_Click('${shareInfo.shareId}', '${shareInfo.deletePermission}', '${shareInfo.sendPermission}', '${shareInfo.managePermission}');">
			        		<span class="sub_iconLNB tree_plus"></span>
			        		<span class="h2Title" id="h2Title_${shareInfo.shareId}" style="display:inline-block"><c:out value="${shareInfo.shareName}" /></span>
			        		<span id="totalUnreadCount_${shareInfo.shareId}" class="txt_color" style="position:absolute;">
			        			<c:if test="${shareInfo.totalUnreadCount != '0'}">(${shareInfo.totalUnreadCount})</c:if>
			        		</span>
			        	</h2>
			        	<ul class="lnbUL off" id="ul_${shareInfo.shareId}">
			        		<div class="tree" id="shareTreeView_${shareInfo.shareId}" oncontextmenu="event_folderMenu(event); return false;" onclick="HiddenFolderMenu();"></div>
			        		<li onclick="Open_Search();"><span class="list_text"><spring:message code="ezEmail.t641" /></span></li>
			        		<c:if test="${shareInfo.sendPermission eq 'Y'}">
								<li onclick="Open_ReservationManage('${shareInfo.shareId}')"><span class="list_text"><spring:message code="ezEmail.t605" /></span></li>
			        		</c:if>
			        		<c:if test="${shareInfo.managePermission eq 'Y'}">
			        			<li onclick="mail_Config('${shareInfo.shareId}')"><span class="list_text"><spring:message code="ezEmail.t99000044" /></span></li>
			        		</c:if>
			        		<c:if test="${useSpamSniper ne null && useSpamSniper != '' && useSpamSniper != 'NO'}">
				            	<li onclick="shareMailAddress()"><span class="list_text">스팸편지함</span></li>
				            </c:if>		
				            <br/>
				            <c:if test="${useApprMail}"> <% // 승인메일 정책에서 하나라도 사용이면 true %>
		                        <li onclick="Open_ApprMail(this)" data-id="${shareInfo.shareId}" data-type="r"><span class="list_text"><spring:message code="email.appr.title.request" /></span></li> <% // 발송요청목록 %>
			            	</c:if>
                            <%-- 태그 --%>
                            <c:if test="${shareInfo.enable eq '1'}">
                                <div class="tag_area">
                                    <span>
                                        <div id="tagtitle_${shareInfo.shareId}" class="on" onclick='openTagFolder();'>
                                            <span class="sub_iconLNB tree_blank"></span>
                                            <span class="tag_normal" style="width: 156px; text-align: justify;"><spring:message code="ezEmail.tag" /></span>
                                        </div>
                                        <ul class="lnbUL" id="tagcontent_${shareInfo.shareId}">
                                            <li class="tagcontent"></li>
                                        </ul>
                                    </span>
                                </div>
                            </c:if>
			        	</ul>
			        	<script>
			        		setTotalUnreadCount("${shareInfo.shareId}", parseInt("${shareInfo.totalUnreadCount}"));
			        	</script>
			        </c:forEach>
		        </c:if>
				<%-- 2024-06-14 이사라 - 태그 계정별로 지원하여 위치 변경
				<c:if test="${useMailTag}">
					<h2 id="tagtitle" onclick='openTagFolder();'>
						<span class="sub_iconLNB tree_plus"></span>
						<span class="h2Title" style="display:inline-block"><spring:message code="ezEmail.tag" /></span>
					</h2>
					<ul class="lnbUL off" id="tagcontent">
						<li>
							<c:forEach items="${tags}" var="tag">
								<a data-idx="${tag.idx}" onclick='openTagContent();' ><c:out value="${tag.name}" /></a>
							</c:forEach>
						</li>
					</ul>
				</c:if>--%>
	        </div>
	        <xml id="RootFolderXML" style="display: none;">
		    	${rootFolderXML}
		    </xml>
		    <xml id="AddressFolderXML" style="display: none;">
				${rootAddressXML} 
			</xml>
		    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;display:none;" id="progressPanel">&nbsp;</div>
			<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="folderPanel" onclick="HiddenFolderMenu();" >&nbsp;</div>   		    		               
			<div id="folderMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
			    <table cellpadding=2 cellspacing=1 border=0 style="width:130px;" class="popuplist">
			    <tr>
			        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="folder_ReadChange('R');HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-msg-read.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.jyh01" /></span></td>
			    </tr>
			    <tr id="mailbox_export" <c:if test="${useMailBoxBackUp ne 'YES'}">style="display:none"</c:if>>
			        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailbox_export();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_mailreply.gif" alt="" align="absmiddle" border="0" hspace="5"><spring:message code="ezEmail.lhm31" /></span></td>
			    </tr>
			    <tr id="mailbox_import" <c:if test="${useMailBoxBackUp ne 'YES'}">style="display:none"</c:if>>
			        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailbox_import();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_fw.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.lhm32" /></span></td>
			    </tr>
			    <tr id="mailbox_delete">
			        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailbox_delete();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/deleted.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.t483" /></span></td>
			    </tr>
			    </table>
			</div>
			<script>
				// 웹소켓 지원을 안할 경우 '편지함 내려받기/가져오기' 버튼 숨김
		        if ('WebSocket' in window) {
		       	} else if ('MozWebSocket' in window) {
		       	} else {
		       		document.getElementById("mailbox_export").style.display = "none";
					document.getElementById("mailbox_import").style.display = "none";
		       	}
			</script>
	    </div>
	    <div class="mail_space">
	        	<span class="mail_spaceText"><spring:message code="main.t00045" />&nbsp;<span class="userPer" id="usePer"></span></span><span  id="myBar" class="mailBar"></span>
        </div>
	</body>
</html>
