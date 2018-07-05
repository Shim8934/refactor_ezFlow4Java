<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	out.clear();
%>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<link rel="stylesheet" type="text/css" href="/css/previewmail.css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/NewMailList.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/Newemail.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/newMail_Cross.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>		
		<script type="text/javascript">
		    var g_bdraft = false;
		    var g_moveUrl = "${url}";
		    var g_expath = "exchange";
		    var g_szRootFolderName = '${folderName}';
		    var g_bPrevShow = false;
		    var g_ViewID = null;
		    var g_PreViewID = null;
		    var g_PageInput = null;
		    var g_PageCount = 0;
		    var g_PreView = null;
		    var g_PreviewTitle = null;
		    var g_moveStart = false;
		    var g_startPosition = 0;
		    var g_foldertype = "${folderType}";
		    var importanceColor = "${importanceColor}";
		    var g_userLang = "${userLang}";
		    var USE_OCS = "${useOcs}";
		    var g_useremail = g_loginID + "@${domainName}";	    
		    var searchMode = false;
		    var SearchKeyword = "";
		    var g_loginID = "${userId}";
		    var SecurityMailReadUndo = true;
		    var p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1.xml";
		    var p_Listoption = "1";
		    var p_ListOrderby = "urn:schemas:httpmail:datereceived";
		    var p_ListOrderOption = "DESC";
		    var p_ListorderType = "";
		    var p_ListorderValue = "";
		    var pListCount = "${mailGeneral.listCount}";
		    var pFolderTotalCount;
		    var pFolderUnReadCount;
		    var CopyMsg = "<spring:message code="ezEmail.t635" />";
		    var MoveMsg = "<spring:message code="ezEmail.t636" />";
		    var pPreviewMode = "${mailGeneral.previewMode}";
		    var pPreviewWList = "${mailGeneral.previewWList}";
		    var pPreviewWContent = "${mailGeneral.previewWContent}";
		    var pPreviewHList = "${mailGeneral.previewHList}";
		    var pPreviewHContent = "${mailGeneral.previewHContent}";
		    var pRefreshinterval = "${mailGeneral.refreshInterval}";
		    var previewSubTree = "${mailGeneral.previewSubTree}";
		    var CurrentHeight = 0;
		    var CurrenWidth = 0;
		    var pMailListHeightW = 0;
		    var pMailPreHeightW = 0;
		    var pMailListDiv = 0;
		    var pMailPreVDiv = 0;
		    var pMailListWidthH = 0;
		    var pMailPreWidthH = 0;
		    var pMailListDiv_H = 0;
		    var pMailPreVDiv_H = 0;
		    var tmp_href;
		    var pUse_Editor = "${useEditor}";
		    var pNoneActiveX = "YES";
		    var pSaveInterval = 0;
		    var nextMailListRefreshTime = 0;
		    var refreshIntervalTimerId = 0;
		    var refreshTimeoutTimerId = 0;
		    var webSocket =  null;
		    var userkey = "";
		    var pclose = "close";
		    var protocol = window.location.protocol;
		    var host = defineHost(protocol) + window.location.host + '/websocket/${userId}';
		    var useEncryptZipForEmail = "${useEncryptZipForEmail}";
		    var uploading = "uploading";
			var useMailBoxBackUp = "${useMailBoxBackUp}";
			var useMailWriteSenderClick = "${useMailWriteSenderClick}"; // 수아 수정 useMailWriteSenderClick추가
		    var enc = "encrypt";
		    var dec = "decrypt";
		    var compareFolderName = "<spring:message code="ezEmail.t645" />";
		    var useReSend = "${useReSend}";
		    var useSearchContent = "${useSearchContent}";
		    var useMailNewWindow = "${useMailNewWindow}";
		    var useReceivingChk = false;
		    var noReadMsg = "<spring:message code='ezPoll.t137'/>"; // 읽지 않음
		    
		    function defineHost(protocol){
	    		var host = "";

	    		if (protocol == "https:") {
			    	host = 'wss://';
			    } else {
			    	host = 'ws://';
			    }
	    		
		    	return host;
		    }
		    
		    // commented out to allow users to be able to select text in the preview : dhlee
			// document.onselectstart = function () { return false; };
		    window.onresize = Window_resize;
		    window.onunload = Window_onunload;
		    var window_onunload_Event = false;
		    window.onload = function () {
		    	
		    	if (useReSend == "YES" && g_szRootFolderName == compareFolderName) {
		    		$('#liReSend').css('display', 'block');
		    	}
		    	
		    	if (g_moveUrl == 'receiveChk') {
		    		document.getElementById("toggle_flag_btn").style.display = "none"; 
		    		document.getElementById("read_stat").style.display = "none";
		    		document.getElementById("unread_stat").style.display = "none";
		    		useReceivingChk = true;
		    		g_foldertype = g_moveUrl;
		    		p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
		    		select.selectedIndex = 3;
		    	}
		    	
		        CurrentHeight = document.body.clientHeight;
		        CurrenWidth = document.body.clientWidth;
		        
		        switch (g_foldertype) {
		            case "sent":
		                receivecheck.style.display = "";
		                reply.style.display = 'none';
		                p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile2.xml";
		                p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
		                p_Listoption = "2";
		                document.getElementById("select").selectedIndex = 3;
		                document.getElementById("select").item(3).selected = true;
		                break;
		            case "draft":
		                reply.style.display = 'none';
		                p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile2.xml";
		                p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
		                p_Listoption = "2";
		                document.getElementById("select").selectedIndex = 3;
		                document.getElementById("select").item(3).selected = true;
		                g_bdraft = true;
		                break;
		            case "delete":
		                deleteone.style.display = 'none';
		                deleteall.style.display = '';
		                break;
		            
		            case "receiveChk":
		            	p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile5.xml";
		            	g_foldertype = "sent";
		            	g_moveUrl = "<spring:message code='ezEmail.t645'/>";
		            	break;
		        }
		        
		        if (g_foldertype != "sent" && g_foldertype != "draft")
		            btnReject.style.display = "";
		
		        pMailListDiv = pPreviewWList;
		        pMailPreVDiv = pPreviewWContent;
		        pMailListDiv_H = pPreviewHList;
		        pMailPreVDiv_H = pPreviewHContent;
		        g_bPrevShow = false;
		        pPreviewShow_HOW = pPreviewMode;
		        ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code="ezEmail.t99000002" />";
		        ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerText = "<spring:message code="ezEmail.t99000002" />";
		        
		        if (pPreviewMode != "OFF") {
		            g_bPrevShow = true;
		            
		            /* 단암 일정사이즈 이하로 width가 줄어도 좌우 미리보기 유지
		            if (parseInt(document.documentElement.clientWidth) < 1000) { 
		                document.getElementById("PreViewleft").style.display = "none";
		                pPreviewShow_HOW = "W";
		            }
		            else {
		                document.getElementById("PreViewleft").style.display = "";
		            }*/

		            if (pPreviewShow_HOW == "W") {
		
		                if (pMailListDiv == 0 || pMailPreVDiv == 0) {
		                    pMailListDiv = 50; pMailPreVDiv = 50;
		                }
		                
		                document.getElementById("MailListRayer").style.display = "inline-block";
		                document.getElementById("PreviewRayerW").style.display = "block";
		
		                CurrenWidth = document.documentElement.clientWidth - 10;
		                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
		                document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
		                pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
		                pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
		                document.getElementById("MailListRayer").style.width = "100%";
		                document.getElementById("PreviewRayerW").style.width = "100%";
		                document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
		                document.getElementById("contentlist").style.height = (pMailListHeightW - 100) + "px";
		                document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
		                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 100) + "px";
		                pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
		                pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
		                
		            } else {
		            	
		                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
		                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
		                }
		                
		                document.getElementById("MailListRayer").style.display = "inline-block";
		                document.getElementById("PreviewRayerH").style.display = "inline-block";
		
		                CurrenWidth = document.documentElement.clientWidth - 20;
		                CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
		                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;
		                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
		                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
		                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
		                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
		                document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
		                document.getElementById("PreviewRayerH").style.width = pMailPreWidthH + "px";
		                document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 5 + "px";
		                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
		                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
		                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
		                
		                if (pMailListWidthH <= 470) {
		                    if (g_foldertype != "sent") {
		                        p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
		                        SmallSizeList = true;
		                        OldSmallSizeList = true;
		                    }
		                }
		                
		            }
		            
		        } else {
		            CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		            document.getElementById("MailListRayer").style.width = "100%";
		            document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
		        }
		
		        var HeaderObject = document.getElementById("MailHeader");
		        var ContentObject = document.getElementById("MailList");	        
		        HeaderIni(HeaderObject);       
		        GetListInfo(HeaderObject, ContentObject);	        
		        PreviewMode_ChangeBtn();
		        window_onunload_Event = true;
		                        
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
		    }
		    
		    $(document).ready(function() {
		    	var clickOutside;
		    	
		    	if (navigator.userAgent.toLowerCase().indexOf("m sie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].document);
		    	} else {
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame'].contentWindow.document);
		    	}	    	
		    	
		    	clickOutside.mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$($(window.parent.frames['left'].document)).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(parent.document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(window.frames['ifrmPreViewH']).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(window.frames['ifrmPreViewW']).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    });
		    
		    function getCurrentTime() {
		        return new Date().getTime();		        
		    }
		    
		    function setMailListRefreshTimer() { 
		        if (pSaveInterval != 0) {
		        	refreshIntervalTimerId = setInterval(function() {
		            	/* 수아 재은 수정 (메일 검색시 자동 새로고침 X) */
		            	if (!searchMode) {
			                MailListRefresh();
			                
			                // 다음 자동 갱신 시간을 기록한다.
			                recordNextMailListRefreshTime();
		            	}
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
 		                console.log('refresh time already passed. Refresing...')
 		                
 		                // 수정 재은 
 		                if (!searchMode) {
 		                	MailListRefresh();
 		                }
 		                
                        // 다음 자동 갱신 시간을 기록한다.
                        recordNextMailListRefreshTime();
 		                
 		                setMailListRefreshTimer();
 		            // 다음 번 갱신 시간이 아직 남아 있으면 해당 시간에 갱신이 되도록 타이머를 등록한다.
 		            } else {
 		               console.log('refresh time not yet passed. Registering Timer...')
 		               
 		               refreshTimeoutTimerId = setTimeout(function() {
 		            	   
 		            	   // 수정 재은
 		            	   if (!searchMode) {
 		            		   MailListRefresh();
 		            	   }
 		                   
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
		    
		    function mailGeneralSave() {
	            var _pPreview;
	            
	            if (g_bPrevShow)
	                _pPreview = pPreviewShow_HOW;
	            else
	                _pPreview = "OFF";
	
	            if (parseInt(pMailListDiv) + parseInt(pMailPreVDiv) != 100)
	                pMailPreVDiv = 100 - parseInt(pMailListDiv);
	            
	            if (parseInt(pMailListDiv_H) + parseInt(pMailPreVDiv_H) != 100)
	                pMailPreVDiv_H = 100 - parseInt(pMailListDiv_H);
	
	            var xmlpara = createXmlDom();
	            var objNode;
	            objNode = createNodeInsert(xmlpara, objNode, "DATA");
	            var xmlhttp = createXMLHttpRequest();
	            createNodeAndInsertText(xmlpara, objNode, "USERID", g_loginID);
	            createNodeAndInsertText(xmlpara, objNode, "LISTCOUNT", document.getElementById("MailList").getAttribute("listpageCount"));
	            createNodeAndInsertText(xmlpara, objNode, "REFRESHINTERVAL", " ${mailGeneral.refreshInterval}");
	            createNodeAndInsertText(xmlpara, objNode, "KEEPDELETELENGTH", " ${mailGeneral.keepDeleteLength} ");
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWMODE", _pPreview);
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWWLIST", parseInt(pMailListDiv));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWWCONTENT", parseInt(pMailPreVDiv));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWHLIST", parseInt(pMailListDiv_H));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWHCONTENT", parseInt(pMailPreVDiv_H));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWSUBTREE", previewSubTree);
	            
	            xmlhttp.open("POST", "/ezEmail/mailGeneralSave.do", false);
	            xmlhttp.send(xmlpara);		  
		    }
		    
		    var Save_unloadSave = false;
		    
		    function Window_onunload() {
		        if (window_onunload_Event && !Save_unloadSave) {		        	
		            mailGeneralSave();
		            
		            Save_unloadSave = true;
		        }
		    }
		    
		    function keyword_Clear() {
		        document.getElementsByName('keyword').item(0).value = "";
		    }
		    
		    function onkeydown_start_search(evt) {
		        var curevent = (typeof event == 'undefined' ? evt : event)
		        if (curevent.keyCode == "13") {
		            start_search();
		        }
		    }
		    
		    function start_search() {
		        searchMode = true;
		        var inputkeyword = document.getElementsByName('keyword').item(0);
		        
		        if (inputkeyword.value.indexOf("%") != -1) {
		            alert("'%'" + strLang148);
		            return;
		        }
		        
		        if (inputkeyword.value == "") {
		            alert(strLang254);
		            return;
		        }
		        
		        SearchKeyword = MakeSQL(inputkeyword.value);
		        goToPageByNum("1");
		
		    }
		    
		    function MakeSQL(key) {
		        var radiosearch = document.getElementsByName('searchCheck');
		        
		        if (radiosearch.item(0).checked)
		            return radiosearch.item(0).value + "=" + key;
		        else if (radiosearch.item(1).checked)
		            return radiosearch.item(1).value + "=" + key;
		        else if (radiosearch.item(2).checked)
		            return radiosearch.item(2).value + "=" + key;
		    }
		    
		    function reloadReadContent(url) {
		    	g_moveUrl = url.split('/')[0];
		    	
		    	if (pPreviewShow_HOW == "H") {
	                PrevViewFormH.iptURL.value = url;
	                PrevViewFormH.submit();
	            }
	            else {
	                PrevViewFormW.iptURL.value = url;
	                PrevViewFormW.submit();
	            }
		    	
		        MailListRefresh();
		    }

		    // 메일박스 내보내기 config 확인
			function mailbox_export() {
		    	
				var folderTotalCount = document.getElementById("folderTotalCount").innerText;
				
				if (folderTotalCount < 1) {
			    	alert("<spring:message code='ezEmail.kyj13' />");
					return;
				}
		    	
		    	var exportType = "MAILBOX";
		    	
		    	if (useEncryptZipForEmail == "YES") {
		    			mailExportOption_onClick(exportType);
		    	} else {
			    	if (confirm("<spring:message code='ezEmail.lhm36' />")) {
			    		mailbox_export_start();
			    	}
		    	}
		    	
			}
		    
		    // 메일박스 내보내기
		    function mailbox_export_start(pwd){
		    	
		    	// 웹소켓 연결
	            webSocket= new WebSocket(host);
		    	var encryptPw = "";
	            
		    	if (typeof pwd != "undefined") {
		    		encryptPw = pwd;
		    	}
		    	
		        // 서버로부터 메세지가 왔을 때 실행되는 함수 
 				webSocket.onmessage = function(message){
		        	var obj = JSON.parse(message.data);
		        	
		        	if (obj.status == "transferStart") {
		            	userkey = obj.userkey;
			            ShowMailProgressNew();
			            ShowPercent(0);
			            
						$.ajax({
							type : "POST",
							dataType : "text",
							async : true,
							url : "/ezEmail/mailboxExportZip.do",
							data : { folderPath : '${url}', userkey : userkey},
							success : function(result) {
								if (result == "") {
									alert("<spring:message code='ezEmail.lhm33' />");
									webSocket.close();
					            	HiddenMailProgressNew();
								} else if (result == "CANCEL") {
									console.log('User Cancel');
									webSocket.close();
					            	HiddenMailProgressNew();
								} else {
									
									if (useEncryptZipForEmail == 'YES' && encryptPw != ""){
										ShowPercent(enc);
									}
									
									var fullpath = "/ezEmail/downloadMailboxZip.do?folderName="
											+ encodeURIComponent('${folderName}')
											+ "&temp=" + result + "&encryptPw=" + encodeURIComponent(encryptPw)
											+ "&userkey=" + encodeURIComponent(userkey);
									AttachDownFrame.location.href = fullpath;
									AttachDownFrame.target = "_blank";
					          
								}
							}
						});
						
		            } else if (obj.status == 'progress') {
		            	
		            	if (obj.percent <= 100) {
			            	ShowPercent(obj.percent);
		            	}
		            	
		            } else if (obj.status == 'end') {
		            	webSocket.close();
		            	HiddenMailProgressNew();
		            }
		        };
		        
		        // 웹소켓 연결 해제시 실행 되는 함수
		        webSocket.onclose = function(event){
		        	webSocket = null;
		        };
		        
		        window.onbeforeunload = function(){
			        webSocket = null;
		        };
		    }
			
			// 메일박스 가져오기
			function mailbox_attach_import(pwd, tempId, userkey) {
	        
				console.log('mailbox_attach_import started.');
				
				var encryptPw = "";
		    	var path = "";
		    	var tempname = "";
		    	
				if (typeof pwd != "undefined") {
		    		encryptPw = pwd;
		    	}
				
				if (typeof tempId != "undefined") {
					path = tempId;
				}
				
				// mailbox_attach_import() function이 2번 호출됨으로 인해 websocket 객체 존재유무를 판단하여 진입을 막는다.
				if (webSocket != null) {
					console.log('websocket is not null');
					return;			
				}
				
		        webSocket = new WebSocket(host);
		        
				if (encryptPw == "") {
	        		tempname =	document.importMailboxform.file1.value;
					
	        		if (tempname == "") {
						return;
					}
	        		
					var last = tempname.split(".").length;
					var extension = tempname.split(".")[last - 1];
	
					if (extension.toUpperCase() != "ZIP") {
						alert("<spring:message code='ezEmail.lhm34' />");
						return;
					}
				}
			
		        webSocket.onmessage = function(message){
		        	
		            var curr = "";
		        	var obj = JSON.parse(message.data);
		            ShowMailProgressNew();
		            
		            if (path != ""){
		            	ShowPercent(dec);
		            } else {
			            ShowPercent(uploading);
		            }
		            
		        	if (obj.status == "transferStart") {
		            	userkey = obj.userkey;
			            var frm = document.getElementById("importMailboxform");
						frm.action = "/ezEmail/mailboxImportZip.do?folderPath="
								+ encodeURIComponent('${url}') 
								+ "&userkey=" + encodeURIComponent(userkey)
								+ "&encryptPw=" + encodeURIComponent(encryptPw)
								+ "&tempId=" + encodeURIComponent(path);
						frm.submit();
						
		            } else if (obj.status == 'progress') {
		            	if (obj.percent <= 100) {
			            	ShowPercent(obj.percent);
		            	}
		            } 
       
		        };
		        
		        webSocket.onclose = function(event){
		        	webSocket = null;
		        };
		        
		        window.onbeforeunload = function(){
		        	webSocket = null;
		        };
		        				
			}
			
	        function sendMessage(data) {
	        	var sendObj = {};
	            sendObj.status = encodeURIComponent(data);
	            sendObj.userkey = encodeURIComponent(userkey);
	            
	            var json = JSON.stringify(sendObj);
	            webSocket.send(json);
	        }
			
	        // 유진-리소스확인
	        function mailboxImportComplete(result, tempId, userkey) {

	        	webSocket.close();
				HiddenMailProgressNew();
				
				if (result == "NOTSUPPORT"){ // 암호화된 파일 지원하지 않음
					alert("<spring:message code='ezEmail.kyj08' />");
					document.importMailboxform.file1.value = "";
 					MailListRefresh(); 
				}
				
				if (result == "NOT" && tempId == "NONE") { // 암호화된 파일이므로 옵션창 활성화
					mailImportOption_onClick();
				}
				
				if (result == "NOT" && tempId != "NONE") { // 암호화된 파일이므로 옵션창 활성화
					mailImportOption_onClick(tempId, userkey);
					document.importMailboxform.file1.value = "";
				}

				if (result == "DIFF") { // 암호가 다름
					alert("<spring:message code='ezEmail.lhm51' />"); 
					mailImportOption_onClick(tempId, userkey);
					document.importMailboxform.file1.value = "";
				}
				
				if (result == "ERROR") { // 에러발생
					alert("<spring:message code='ezEmail.lhm35' />");
					document.importMailboxform.file1.value = "";
					MailListRefresh();
				}
				
				if (result == "ABORT") { // marformd 에러  
					alert("<spring:message code='ezEmail.kyj15' />");
					document.importMailboxform.file1.value = "";
					MailListRefresh();
				}
				
				if (result == "ZEROEML") { // eml파일이 없을 경우
					alert("<spring:message code='ezEmail.kyj16' />");
					document.importMailboxform.file1.value = "";
					MailListRefresh();
				}
				
				if (result == "OK") {
					document.importMailboxform.file1.value = "";
					MailListRefresh(); 
					location.reload();
				}
				
			}
	        
			function mailbox_import() {
				document.getElementById("file1").click();
			}
			
			function ScriptEngineMinorVersion(){                                        
				var agt = navigator.userAgent.toLowerCase();
				// IE 10 이하 버전 체크
				if (agt.indexOf("msie") != -1){
			   		alert('Internet Explorer');
			        return 'YES';
			    } 
			}
			
			function ShowPercent(data) {
				$('#progressNum').text('');
				
				if (data == uploading){ // 리소스 정리예정
					$('#progressNum').text("<spring:message code='ezEmail.kyj10' />");
				} else if (data == dec) {
					$('#progressNum').text("<spring:message code='ezEmail.kyj11' />");
				} else if (data == enc) {
					$('#progressNum').text("<spring:message code='ezEmail.kyj12' />");
				} else {
					$('#progressNum').text("<spring:message code='ezEmail.kyj01' /> : " + data + " %");
				} 
			}
			
			function HiddenMailProgressNew() {
				$('#progressNum').text('');
				document.getElementById("mailPanel").style.display = "none";
				document.getElementById("mailPanel").style.backgroundColor = "";
				document.getElementById("MailProgress").style.backgroundColor = "";
				document.getElementById("MailProgress").style.display = "none";
			    document.getElementById("cancleProgressBtn").style.display = "none";
				parent.document.getElementById("left").contentWindow.hideProgress();
				
				if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
				} 
			}

			function ShowMailProgressNew() {
			    document.getElementById("mailPanel").style.display = "block";
			    document.getElementById("mailPanel").style.opacity = 0.5;
			    document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
			    document.getElementById("MailProgress").style.backgroundColor = "#ffffff";
			    document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 150 + "px";
			    document.getElementById("MailProgress").style.display = "";
			    document.getElementById("cancleProgressBtn").style.display = "block";
			    parent.document.getElementById("left").contentWindow.showProgress();
			    
			    if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
				} 
			}

			function cancleProgress(){
	        	HiddenMailProgressNew();
	        	webSocket.close();
	        	location.reload();
			}
		</script>	
	</head>
	<body style="overflow:hidden;" id="theBody" class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);"  onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
		<h1>${folderName}<span id="mailBoxInfo"></span>
	      <span style="float:right;font-weight:normal;color:black;">
	          <input name="searchCheck" id="Radio1" type="radio" value="SUBJECT" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;"><label for="Radio1">&nbsp;<spring:message code="ezEmail.t98" /></label>
	          <c:if test="${isSentItems == true}">
	          <input name="searchCheck" id="Radio2" type="radio" value="RECEIVE" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;"><label for="Radio2">&nbsp;<spring:message code="ezEmail.t66" /></label>
	          </c:if>
	          <c:if test="${isSentItems != true}">
			  <input name="searchCheck" id="Radio3" type="radio" value="FROM" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;"><label for="Radio3">&nbsp;<spring:message code="ezEmail.t161" /></label>
			  </c:if>
			  <c:if test="${useSearchContent == 'YES'}">
			  <input name="searchCheck" id="Radio4" type="radio" value="CONTENT" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;"><label for="Radio4">&nbsp;<spring:message code="ezEmail.t649" /></label>
			  </c:if>
			  &nbsp;
			  <input name="keyword" class="Mail_Input" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb; border-right:0px;" onKeyPress="onkeydown_start_search(event);"  onmousedown="keyword_Clear();" /> 
	          <a href="#" style="float:right"><img src="../../images/bsearch_new.gif" border="0" onClick="start_search()"></a>
	      </span>
	    </h1>	
        <div id="mainmenu">
        <ul id="tb_Parent">
          <li><span onClick="new_mail_onclick()"><spring:message code="ezEmail.t510" /></span></li>
          <li id="reply"><span onClick="reply_mail_onclick()"><spring:message code="ezEmail.t511" /></span></li>
          <li><span onClick="all_reply_mail_onclick()"><spring:message code="ezEmail.t512" /></span></li>
          <li id="liReSend" style="display: none;"><span id="btnReSend" onClick="reSend_onClick()"><spring:message code="ezEmail.kyj19" /></span></li>
          <li><span onClick="transmission_mail_onclick()"><spring:message code="ezEmail.t513" /></span></li>
          <!-- <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
          <li id="read_stat"><span onClick="Read_StatusChange('R');" ><spring:message code="ezEmail.t99000006" /></span></li>
          <li id="unread_stat"><span onClick="Read_StatusChange('U');"><spring:message code="ezEmail.t99000007" /></span></li>
          <li onClick="mail_export();" id="EmailPCSave"><span><spring:message code="ezEmail.t378" /></span></li>
          <li id="toggle_flag_btn" onClick="toggle_flag();" ><span class="img_Newbtn"><spring:message code="ezEmail.t550" /></span></li>
          <li><span onClick="move_mail_onclick()"><spring:message code="ezEmail.t482" /></span></li>
          <!-- <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
          <li><span onClick="deleteWork(false)"><spring:message code="ezEmail.t95" /></span></li>
          <li id="deleteone"><span onClick="deleteWork(true)"><spring:message code="ezEmail.t156" /></span></li>
          <li id="deleteall" style="display:none"><span onClick="delAllFile()"><spring:message code="ezEmail.t514" /></span></li>
          <li onClick="MailListRefresh()"><span class="img_Newbtn"><spring:message code="ezEmail.t515" /></span></li>
          <li id="receivecheck" style="display:none" ><span onClick="receiveCheck_onClick()"><spring:message code="ezEmail.t516" />/<spring:message code="ezEmail.t549" /></span></li>
          <li id="btnReject" style="display:none"><span onClick="reject_onclick()"><spring:message code="ezEmail.t270" /></span></li>
		  <li id="right">
	            	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	            	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
					<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" class="maillistoptiondivbtn" onclick="MailOptionView(this);" />
		  </li> 
        </ul>
        </div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
        <div id="layer_popup" style="width:250px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
          <div class="popupwrap1" style="background-color:#ffffff; position: relative;">
            <div class="popupwrap2">
              <table style="width:100%;border-spacing:0px;border-collapse:collapse;border:none;"  class="list_element">
		          <colgroup>
	                <col style="width:90px;"><col>
	              </colgroup>
              	  <tr>
                    <th><spring:message code="ezEmail.t179" /></th>
                    <td> 
	                   <select id="listcount" style="WIDTH:46px;height:20px;" onChange="ListCount(this.value);">
	                        <option value=10 <c:if test="${mailGeneral.listCount == '10'}">selected</c:if>>10</option>
	                        <option value=20 <c:if test="${mailGeneral.listCount == '20'}">selected</c:if>>20</option>
	                        <option value=30 <c:if test="${mailGeneral.listCount == '30'}">selected</c:if>>30</option>
	                        <option value=40 <c:if test="${mailGeneral.listCount == '40'}">selected</c:if>>40</option>
	                        <option value=50 <c:if test="${mailGeneral.listCount == '50'}">selected</c:if>>50</option>
	                        <option value=60 <c:if test="${mailGeneral.listCount == '60'}">selected</c:if>>60</option>
	                        <option value=70 <c:if test="${mailGeneral.listCount == '70'}">selected</c:if>>70</option>
	                        <option value=80 <c:if test="${mailGeneral.listCount == '80'}">selected</c:if>>80</option>
	                        <option value=90 <c:if test="${mailGeneral.listCount == '90'}">selected</c:if>>90</option>
	                        <option value=100 <c:if test="${mailGeneral.listCount == '100'}">selected</c:if>>100</option>
	                    </select>
	                </td>
                  </tr>
                  <tr>
                    <th><spring:message code="ezEmail.t99000035" /></th>
                    <td>
                    	<select name="select" id="select" onChange="on_changeView(this.value)" style="height:20px;width:120px;">       
                    		<option VALUE="BASE" selected><spring:message code="ezEmail.t518" /></option>
                    		<option VALUE="PREVIEW"><spring:message code="ezEmail.t843" /></option>
                    		<option VALUE="UNREAD"><spring:message code="ezEmail.t519" /></option>
                    		<option VALUE="RECEIV"><spring:message code="ezEmail.t66" /></option>
                    	</select>
	                </td>
                  </tr>
              </table>
            </div>
          </div>
	      <div class="shadow"></div>
        </div>
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="ContextMenuHidden();" >&nbsp;</div>
        <div style="width:8px;height:100%;background-color:#808080;position:absolute;z-index:10000;display:none;" id="ResizeBarH"></div>
        <div style="width:100px;height:8px;background-color:#808080;position:absolute;z-index:10000;display:none;" id="ResizeBarW"></div>
        <div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
            <a class="btnposition" id="cancleProgressBtn" style="display: none; padding-top: 10px; width: 50px; height:20px; 
      			cursor:pointer; margin:0 auto;" onclick="cancleProgress();">
            <input type="button" value="<spring:message code="ezEmail.t39" />"/></a>
           
        </div>
        <span id="MailListRayer" style="border:0px solid blue;width:500px;height:100%;vertical-align:top;overflow:hidden;" > 
            <table style="width:100%;border:1px solid #ddd;" id="MailHeader" class="mainlist" >               
            </table>
            <div id="contentlist" name="contentlist" style="border:0px solid blue;height:350px;width:100%;overflow-y:auto;" onblur  onscroll="ContextMenuHidden()">
                <table class="mainlist" style="width:100%;" id="MailList" listpageCount="${mailGeneral.listCount}" curPage="1" MaxCount="0" MaxPage="0" oncontextmenu="event_listContextMenu(event); return false;">
                </table>
            </div>
            <div id="tblPageRayer"  style="width:470px; margin:6px auto;"></div>
        </span>
        <span id="PreviewRayerH" style="border:0px solid red;width:500px;height:100%;overflow:hidden;vertical-align:top;display:none;margin-left:-5px;">
            <span class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor:w-resize;display:inline-block;">
				<p class="hbar_dotted"><img src="/images/prevview_hbar_dotted.gif"></p>
            </span>
            <span id="PreContent_RayerH" style="position:absolute; border:0px solid red;">
                <span style="width:100%;height:100px;display:block;">            
	                <span class="previewmail_info" style="display:block;width:100%;">
                        <div id="Preview_HeaderH" style="border-bottom: solid 1px #e8e8e8; width:100%;display:none;">
		                    <p class="mail_title" style="margin-left:0px;"><span class="icon_btn"><span onclick="MailReadOpen();" style="cursor:pointer;padding-right:5px;"><img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />" border="0"></span></span><span id="PreH_subject" style="display:none;"><span id="PreH_sub_subject" class="title_blodtxt"></span></span></p>
		                    <span class="mail_date" style="margin-right:10px;display:inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display:none;"></span></span></span>
		                    <dl class="mail_item">
			                    <dt><spring:message code="ezEmail.t693" /></dt>
			                    <dd><span id="PreH_MailSender"><span id="PreH_sub_MailSender"></span></span></dd>
			                    <dt><spring:message code="ezEmail.t527" /></dt>
			                    <dd>
			                    	<span id="PreH_MailReceiver" style="display:inline-block"></span>
			                    	<span id="PreH_MailReceiver_sub"></span>
			                    	<span class="icon_graydown" onclick="ReceiverDetail_view(this);" id="PreH_ReceiverDetail"></span>
			                    	<p class="hidden_area" id="PreH_MailReceiverDetail_Rayer" style="display:none;"><span id="PreH_MailReceiverDetail"></span></p>
	                            </dd>
	                            <dt id="PreH_CCMain" style="display:none;"><spring:message code="ezEmail.t526" /></dt>
			                    <dd>
			                    	<span id="PreH_MailCC" style="display:inline-block"></span>
			                    	<span id="PreH_MailCC_sub"></span>
			                    	<span class="icon_graydown" onclick="CCDetail_view(this);" id="PreH_CCDetail" style="display:none;"></span>
			                    	<p class="hidden_area" id="PreH_MailCC_Rayer" style="display:none;"><span id="PreH_MailCCDetail"></span></p>
								</dd>
		                    </dl>
                        </div>
	                </span>
					<span style="width: 100%;">
						<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code="main.kms4" />" frameborder="0" style="width:100%;height:100%;border:solid 0px green;display:inline-block;"></iframe>
					</span>
                </span>
            </span>
        </span>        
        <span id="PreviewRayerW" style="border:0px solid red;width:100%;height:300px;overflow:hidden;display:none;">
            <span onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width:100%;display:list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
				<img src="/images/prevview_bar_dotted.gif">
            </span>
            <span id="PreContent_RayerW" style="display:block;border:0px solid red;">
                <span style="width:100%;height:100px;display:block;">
	                <span class="previewmail_info" style="display:block;width:100%;">
                        <div id="Preview_HeaderW" style="border-bottom: solid 1px #e8e8e8; display:none;">
		                    <p class="mail_title"><span class="icon_btn"><span onclick="MailReadOpen();" style="cursor:pointer;padding-right:5px;"><img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />" border="0"></span></span><span id="PreW_subject" ><span id="PreW_sub_subject" class="title_blodtxt"></span></span></p>
		                    <span class="mail_date" style="margin-right:10px;display:inline-block;"><span id="PreW_date" ><span id="PreW_sub_date"></span></span></span>
		                    <dl class="mail_item">
			                    <dt><spring:message code="ezEmail.t693" /></dt>
			                    <dd><span id="PreW_MailSender"><span id="PreW_sub_MailSender"></span></span></dd>
	                            <dt><spring:message code="ezEmail.t527" /></dt>
			                    <dd>
			                    	<span id="PreW_MailReceiver" style="display:inline-block"></span>
			                    	<span id="PreW_MailReceiver_sub"></span>
			                    	<span class="icon_graydown" onclick="ReceiverDetail_view(this);" id="PreW_ReceiverDetail" style="display:inline-block;"></span>
			                    	<p class="hidden_area" id="PreW_MailReceiverDetail_Rayer" style="display:none;"><span id="PreW_MailReceiverDetail"></span></p>
			                    </dd>
	                            <dt id="PreW_CCMain" style="display:none;"><spring:message code="ezEmail.t526" /></dt>
	                            <dd>
	                            	<span id="PreW_MailCC" style="display: inline-block"></span>
	                            	<span id="PreW_MailCC_sub"></span>
	                            	<span class="icon_graydown" onclick="CCDetail_view(this);" id="PreW_CCDetail" style="display:none;"></span>
	                                <p class="hidden_area" id="PreW_MailCCDetail_Rayer" style="display: none;"><span id="PreW_MailCCDetail"></span></p>
	                            </dd>
		                    </dl>
                        </div>
	                </span>
                    <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" frameborder="0" style="width:100%;height:100%;border:0px solid black;z-index:0;"></iframe>
                </span>
            </span>
        </span>   
		<iframe name="AttachDownFrame" id="AttachDownFrame" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none"></iframe>  
		<div id="GroupSubObject" style="display:none;">
			<table style="width:100%;" id="GroupSubHeader" class="mainlist_depth" >               
			</table>
			<div id="GroupSubContentlist"  style="border:0px solid red;height:auto;width:100%;overflow-y:auto;">
			    <table class="mainlist" style="width:100%;" id="GroupSubList" oncontextmenu="event_listContextMenu(event); return false;">
			    </table>
			</div>
		</div>
		<div id="ContextMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
		    <table cellpadding=2 cellspacing=1 border=0 style="width:150px;" class="popuplist">
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="all_reply_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_reall.gif" alt=""  align="absmiddle" hspace="5"><spring:message code="ezEmail.t512" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="transmission_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_fw.gif" alt="" align="absmiddle" border="0" hspace="5"><spring:message code="ezEmail.t513" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="reply_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_mailreply.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.t511" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="Read_StatusChange('R');HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-msg-read.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t99000006" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="Read_StatusChange('U');HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/view-document.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t99000007" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="move_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/move.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t482" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="MailListRefresh();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/recur.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t515" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="toggle_flag();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-flag.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t550" /></span></td>
		    </tr>
		    </table>
		</div>
		<form name="PrevViewFormH" action="mailPreviewContent.do" method="post" target="ifrmPreViewH" >
		<input  type="hidden"  name="iptURL" value="">
		<input  type="hidden" name="iSecurity" value="">
		</form>
		<form name="PrevViewFormW" action="mailPreviewContent.do" method="post" target="ifrmPreViewW">
		<input  type="hidden"  name="iptURL" value="">
		<input  type="hidden" name="iSecurity" value="">
		</form>
		<form name="mailWriteSenderClick" action="mailWrite.do" method="post"> <!-- 추가 -->
		<input  type="hidden"  name="cmd" value="NEW">
		<input  type="hidden" name="msgto" value="">
		</form>
		<iframe name="importMailboxIframe" src="about:blank" style="display: none"></iframe>
		<form method="post" id="importMailboxform" name="importMailboxform" enctype="multipart/form-data" target="importMailboxIframe">
	        <input type="file" name="file1" id="file1" accept=".zip" onchange="mailbox_attach_import()" style="display: none"/>
	    </form>
	    <div class="layerpopup"  style="z-index: 10000; position: absolute;display: none;" id="iFramePanel">
	    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
	</body>
</html>
