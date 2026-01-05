<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/mailbox_valid.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <script type = "text/javascript">
	        var pUse_Editor = "${userEditor}";
	        var pNoneActiveX = "${noneActiveX}";
	        var flag = "<c:out value='${flag}' />";
	        var dotnetFlag = "${dotnetFlag}";
	        var shareId = "${shareId}";
	        var CurrentHeight = 0;
		    var CurrenWidth = 0;
		    var selectFolderName = "";
			var selectFolderId = "";
			var selectFolderNameSpl = "";
			var protocol = window.location.protocol;
			var useEncryptZipForEmail = "${useEncryptZipForEmail}";
			var host = defineHost(protocol) + window.location.host + '/websocket/${userId}';
			var uploading = "uploading";
			var enc = "encrypt";
		    var dec = "decrypt";
		    var webSocket =  null;
		    var importExportMode = false;
			var useDisablePopImap = "${useDisablePopImap}";
			
			function defineHost(protocol){
	    		var host = "";

	    		if (protocol == "https:") {
			    	host = 'wss://';
			    } else {
			    	host = 'ws://';
			    }
	    		
		    	return host;
		    }
			var socketUserkey = "";
			
		    window.onload = window_onload;
	        document.onselectstart = function () { return false; };
	        function window_onload() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            if(flag === "email") {
					document.getElementById("1tab1").setAttribute("class", "tabon");
					Tab1_SelectID = "1tab1";
					ChangeTab(document.getElementById("1tab1"));	
				} else { // 주소록 환경설정
					document.getElementById("1tab1").setAttribute("class", "tabon");
					Tab1_SelectID = "1tab1";
					ChangeTab(document.getElementById("1tab1"));	
				}
	            
	            window_resize();
	        }
	        window.onresize = window_resize;
	        
	        function window_resize() {
				var titleH = parseFloat(window.getComputedStyle(document.getElementById("confTitle")).marginTop);
				titleH += parseFloat(window.getComputedStyle(document.getElementById("confTitle")).marginBottom);
				titleH += document.getElementById("confTitle").clientHeight;
				var tabH = document.getElementById("tab1").clientHeight;
				var pTags = document.getElementById("tab1").querySelectorAll('p');
				var totalWidthP = 0 ;
				
				for (var i = 0; i < pTags.length; i++) {
					totalWidthP += pTags[i].getBoundingClientRect().width;
				}
				
				if (totalWidthP > document.body.clientWidth) {
					tabH += 28;
					}
				
				document.getElementById("MailEnv_ifrm").style.height = (document.documentElement.clientHeight - titleH - tabH - 15) + "PX";
				}
			
	        function ChangeTab(obj) {
	            var pSelectTab = obj.getAttribute("divname");
	            switch (pSelectTab) {
	                case "MailEnv_div1":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailGeneral.do?dotnetFlag=" + dotnetFlag;
	                    break;
	                case "MailEnv_div2":
	                        document.getElementById("MailEnv_ifrm").src = "/ezAddress/addressConfig.do";
	                    break;
	                case "MailEnv_div3":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailPop3.do";
	                    break;
	                case "MailEnv_div4":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailAutoForward.do";
	                    break;
	                case "MailEnv_div5":
	                	var requestUrl = "/ezEmail/mailInboxRule.do";
	                	
	                	if (shareId != "") {
	                		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	                	}
	                	
	                    document.getElementById("MailEnv_ifrm").src = requestUrl;
	                    break;
	                case "MailEnv_div6":
	                	var requestUrl = "/ezEmail/mailAutoDelete.do";
	                	if (shareId != "") {
	                		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	                	}
	                    document.getElementById("MailEnv_ifrm").src = requestUrl;
	                    break;
	                case "MailEnv_div7":
	                	var requestUrl = "/ezEmail/mailSignature.do";
	                	
	                	if (shareId != "") {
	                		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	                	}
	                	
	                    document.getElementById("MailEnv_ifrm").src = requestUrl;
	                    break;
	                case "MailEnv_div8":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailOutOfOfficeMain.do";
	                    break;
	                case "MailEnv_div9":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailAddressSearchOrder.do";
	                    break;
	                case "MailEnv_div10":
	                	var requestUrl = "/ezEmail/folderQuotaAndManage.do";
	                    if (shareId != "") {
	                		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	                	}
	                    document.getElementById("MailEnv_ifrm").src = requestUrl;
	                    break;
	                case "MailEnv_div11":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailUserDistribution.do";
	                    break;
	                case "tag":
	                    var requestUrl = shareId != "" ? "/ezEmail/mailTagConfig.do?shareId=" + encodeURIComponent(shareId) : "/ezEmail/mailTagConfig.do";
                        document.getElementById("MailEnv_ifrm").src = requestUrl;
	                    break;
					case "MailEnv_div13" :
						document.getElementById("MailEnv_ifrm").src = shareId != "" ? "/ezEmail/userMailPop3Setting.do?shareId=" + encodeURIComponent(shareId) : "/ezEmail/userMailPop3Setting.do";
						break;
					case "MailEnv_div14" :
						document.getElementById("MailEnv_ifrm").src = shareId != "" ? "/ezEmail/userMailImapSetting.do?shareId=" + encodeURIComponent(shareId) : "/ezEmail/userMailImapSetting.do";
						break;
	            }
	        }
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if(Tab1_SelectID != obj.id)
	                obj.className = "";
	        }
	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if(Tab1_SelectID!="" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); }; ;
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); }; ;
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); }; ;
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	        
		 // 메일박스 내보내기 config 확인
			function mailbox_export(selectFolderName, selectFolderNameSpl, folderTotalCount, isDirect, startDate, endDate) {

				this.selectFolderName = selectFolderName;
            	this.selectFolderNameSpl = selectFolderNameSpl;
				console.log('folderTotalCount=' + folderTotalCount);
				if (folderTotalCount === null || typeof folderTotalCount === "undefined") {
					console.log('folderTotalCount is null or undefined');
					return;
				} else if (folderTotalCount < 1) {
					alert("<spring:message code='ezEmail.kyj13' />");
					return;
				}

				var exportType = "MAILBOX";

				if (useEncryptZipForEmail == "YES") {
					mailExportOption_onClick(exportType);
				} else if (!isDirect){
					//if (confirm("<spring:message code='ezEmail.lhm36' />")) {
						mailbox_export_start();
					//}
				} else {
					mailboxExportByPeriod(startDate, endDate, folderTotalCount);
				}
			}
		    
			function mailbox_getUserKey() {
		    	var userKey = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		url : "/ezEmail/getUserKey.do",
		    		async : false,
		    		success : function(result) {
		    			userKey = result;
		    		}
		    	});
		    	
		    	return userKey;
		    }

			// 2023-07-10 이사라 - 편지함관리> 내보내기> 기간설정 직집입력 시에는 아래 function을 사용
			function mailboxExportByPeriod(startDate, endDate, folderTotalCount) {
				var attachStatus = "all";
				var andorStatus = "and";

		    	socketUserkey = mailbox_getUserKey();

		    	var jsonData = {"FOLDERID" : selectFolderName,
						"KEYWORD" : ["all"], // KEYWORD, CATEGORY는 controller에서 null오류를 피하기 위해서 검색에 지장을 주지 않는 값을 입력 함
						"CATEGORY" : ["attachStatus"],
						"START" : "0",
						"STARTDATE" : startDate,
						"ENDDATE" : endDate,
						"ATTACHSTATUS" : attachStatus,
						"ANDORSTATUS" : andorStatus,
						"END" : folderTotalCount,
						"USERKEY" : socketUserkey
						};

	   			var _url = "/ezEmail/searchedMailExportZip.do";

	            ShowMailProgressNew();
	            ShowPercent(0);
	            mailboxProgressFun(true, socketUserkey, (progress, state, stateDescription) => {
					if (!state) {
						return;
					}

					if (state === "CANCEL") {
						console.log('User Cancel');
					} else if (state === "SUCCESS") {
						var fullpath = "/ezEmail/downloadMailZip.do?temp=" + stateDescription + "&encryptPw=" + "";

						if (typeof(shareId) != "undefined" && shareId != "") {
							fullpath += "&shareId=" + encodeURIComponent(shareId);
						}

						AttachDownFrame.location.href = fullpath;
						AttachDownFrame.target = "_blank";
					} else {
						alert("<spring:message code='ezEmail.ls010' />");
					}

					HiddenMailProgressNew();
					mailboxProgressFun(false); // progress percent
				}); // progress percent

				$.ajax({
					cache: false,
					method: "post",
					url: _url,
					data: JSON.stringify(jsonData),
					contentType : "application/json",
					error: function() {
						alert("<spring:message code='ezEmail.ls011' />");
					}
				});
		    }
		   
		    function mailbox_export_start(pwd) {
				var encryptPw = (typeof pwd != "undefined") ? pwd : "";
		    	socketUserkey = mailbox_getUserKey();
		    	
		    	var requestUrl = "/ezEmail/mailboxExportZip.do";
		    	
	            if (typeof(shareId) != "undefined" && shareId != "") {
	            	requestUrl += "?shareId=" + encodeURIComponent(shareId);
		    	}
	            
	            ShowMailProgressNew();
	            ShowPercent(0);
	            mailboxProgressFun(true, socketUserkey, (progress, state, stateDescription) => {
					if (!state) {
						return;
					}

					if (state === "CANCEL") {
						console.log('User Cancel');
					} else if (state === "SUCCESS") {
						if (useEncryptZipForEmail == 'YES' && encryptPw != ""){
							ShowPercent(enc);
						}

						var fullpath = "/ezEmail/downloadMailboxZip.do?folderName="
								+ encodeURIComponent("<c:out value='${folderName}'/>")
								+ "&temp=" + stateDescription + "&encryptPw=" + encodeURIComponent(encryptPw)
								+ "&userkey=" + encodeURIComponent(socketUserkey);

						if (typeof(shareId) != "undefined" && shareId != "") {
							fullpath += "&shareId=" + encodeURIComponent(shareId);
						}

						AttachDownFrame.location.href = fullpath;
						AttachDownFrame.target = "_blank";
					} else {
						alert("<spring:message code='ezEmail.lhm33' />");
					}

					HiddenMailProgressNew();
					mailboxProgressFun(false); // progress percent
				}); // progress percent
	            
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : requestUrl,
					data : { folderPath : selectFolderName, userkey : socketUserkey},
					error: function() {
						alert("<spring:message code='ezEmail.ls011' />");
					}
				});
		    }
		 
		    // 메일박스 내보내기
		    function mailbox_export_start2(pwd){
		    	
		    	// 웹소켓 연결
	            webSocket= new WebSocket(host);
		    	var encryptPw = "";
	            
		    	if (typeof pwd != "undefined") {
		    		encryptPw = pwd;
		    	}
		    	
		        // 서버로부터 메세지가 왔을 때 실행되는 함수 
 				webSocket.onmessage = function(message){
 					importExportMode = true;
		        	var obj = JSON.parse(message.data);
		        	
		        	if (obj.status == "transferStart") {
		        		socketUserkey = obj.userkey;
		            	ShowMailProgressNew();
			            ShowPercent(0);
			            
			            var requestUrl = "/ezEmail/mailboxExportZip.do";
			            
			            if (typeof(shareId) != "undefined" && shareId != "") {
			            	requestUrl += "?shareId=" + encodeURIComponent(shareId);
				    	}
			            
			            mailboxProgressFun(true, socketUserkey); // progress percent
			            
						$.ajax({
							type : "POST",
							dataType : "text",
							async : true,
							url : requestUrl,
							data : { folderPath : selectFolderName, userkey : socketUserkey},
							success : function(result) {
								if (result == "") {
									if(webSocket == null){
										return;
									} else {
										alert("<spring:message code='ezEmail.lhm33' />");
									}
								} else if (result == "CANCEL") {
									console.log('User Cancel');
								} else {
									
									if (useEncryptZipForEmail == 'YES' && encryptPw != ""){
										ShowPercent(enc);
									}
									
									var fullpath = "/ezEmail/downloadMailboxZip.do?folderName="
											+ encodeURIComponent('${folderName}')
											+ "&temp=" + result + "&encryptPw=" + encodeURIComponent(encryptPw)
											+ "&userkey=" + encodeURIComponent(socketUserkey);
									
									if (typeof(shareId) != "undefined" && shareId != "") {
										fullpath += "&shareId=" + encodeURIComponent(shareId);
							    	}
									
									AttachDownFrame.location.href = fullpath;
									AttachDownFrame.target = "_blank";
					          
								}
							}, complete : function() {
				            	webSocket.close();
				            	HiddenMailProgressNew();
					            mailboxProgressFun(false); // progress percent
							}
						});
						
		            }/*  else if (obj.status == 'progress') {
		            	
		            	if (obj.percent <= 100) {
			            	ShowPercent(obj.percent);
		            	}
		            	
		            } else if (obj.status == 'end') {
		            	webSocket.close();
		            	HiddenMailProgressNew();
		            } */
		        };
		     // 웹소켓 연결 해제시 실행 되는 함수
		        webSocket.onclose = function(event){
		        	webSocket = null;
		        	importExportMode = false;
		        };
		    }
		  
		    function ShowPercent(data) {
				$("#progressNum").text("");
				if (data == uploading){ // 리소스 정리예정
					$("#progressNum").text("<spring:message code='ezEmail.kyj10' />");
				} else if (data == dec) {
					$("#progressNum").text("<spring:message code='ezEmail.kyj11' />");
				} else if (data == enc) {
					$("#progressNum").text("<spring:message code='ezEmail.kyj12' />");
				} else {
					$("#progressNum").text("<spring:message code='ezEmail.kyj01' /> : " + data + " %");
				} 
			}
		    	        
	        function HiddenMailProgressNew() {
				document.getElementById("progressNum").text = '';
				document.getElementById("mailPanel").style.display = "none";
				document.getElementById("mailPanel").style.backgroundColor = "";
				document.getElementById("MailProgress").style.backgroundColor = "";
				document.getElementById("MailProgress").style.display = "none";
			    document.getElementById("cancleProgressBtn").style.display = "none";
				parent.document.getElementById("left").contentWindow.hideProgress();
				
			  if (dotnetFlag.toLowerCase()  == "YES"){
				if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
				} 
			  }
			}

			function ShowMailProgressNew() {
				CurrentHeight = document.body.clientHeight;
		        CurrenWidth = document.body.clientWidth;
			    document.getElementById("mailPanel").style.display = "block";
			    document.getElementById("mailPanel").style.opacity = 0.5;
			    document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
			    document.getElementById("MailProgress").style.backgroundColor = "#ffffff";
			    document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 150 + "px";
			    document.getElementById("MailProgress").style.display = "";
			    document.getElementById("cancleProgressBtn").style.display = "block";
			    parent.document.getElementById("left").contentWindow.showProgress();
			    
			  if (dotnetFlag.toLowerCase()  == "YES"){
			    if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
				} 
			  }
			}

			function cancleProgress(){
	        	HiddenMailProgressNew();
	        	mailboxProgressFun(false);
	        	// webSocket.close();
	        	$("#MailEnv_ifrm")[0].contentWindow.requestFolderList();
			}
			
			function showDim() {
				CurrentHeight = document.body.clientHeight;
		        CurrenWidth = document.body.clientWidth;
			    document.getElementById("mailPanel").style.display = "block";
			    document.getElementById("mailPanel").style.opacity = 0.5;
			    document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
				parent.document.getElementById("left").contentWindow.showProgress();
			    
		      if (dotnetFlag.toLowerCase()  == "YES"){
			    if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.showProgress();
				} 
		      }
			}
			
			function hiddenDim() {
				document.getElementById("mailPanel").style.display = "none";
				document.getElementById("mailPanel").style.backgroundColor = "";
				parent.document.getElementById("left").contentWindow.hideProgress();
				
			  if (dotnetFlag.toLowerCase()  == "YES"){
				if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
				} 
			  }
			}
			
			function DivPopUpShow(popUpW, popUpH, URL) {
		        try {
		            var Position = DivPopUpPosition(popUpW, popUpH);
		            document.getElementById("iFrameLayer").src = URL;
		            document.getElementById("iFramePanel").style.top = (Position[0]-10) + "px";
		            document.getElementById("iFramePanel").style.left = (Position[1]-220) + "px";
		            document.getElementById("iFramePanel").style.height = popUpH + "px";
		            document.getElementById("iFrameLayer").style.width = popUpW + "px";
		            document.getElementById("iFrameLayer").style.height = popUpH + "px";
		            showDim();
		            document.getElementById("iFramePanel").style.display = "";
		        } catch (e) {
		        	console.log(e);
		        }
		    }

		    function DivPopUpHidden() {
		        try {
		        	hiddenDim();
					document.getElementById("mailPanel").style.backgroundColor = "";
		            document.getElementById("iFramePanel").style.display = "none";
		            document.getElementById("iFrameLayer").src = "/blank.htm";
		        } catch (e) {console.log(e);}
		    }
		    
		    var inputNameDlg_cross_dialogArguments = new Array();
            function add_onclick(selectFolderName, selectFolderNameSpl) {
            	this.selectFolderName = selectFolderName;
            	this.selectFolderNameSpl = selectFolderNameSpl;
                inputNameDlg_cross_dialogArguments[0] = "";
                inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
                inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
                DivPopUpShow(330, 150, "/ezEmail/inputNameDlg.do");
            }

            function add_onclick_Complete(szName) {
				const jmochaSafeName = replaceMailboxNameForJmocha(szName);
		        DivPopUpHidden();

		        if (!jmochaSafeName || checkBadFolderName(jmochaSafeName)) {
		            return;
		        }
		        
				const result = mail_make_folder("NEW", selectFolderName, "", jmochaSafeName);

		        if (result != "OK") {
		            if (result == "ALREADY_EXISTS") {
		                alert("<spring:message code='ezEmail.t456' />");
		            } else {
		                alert("<spring:message code='ezEmail.t457' />");
		            }
		            return;
		        }
		        
                $("#MailEnv_ifrm")[0].contentWindow.requestFolderList();
                if(window.parent.frames["left"].configFlag == "false") {
			        window.parent.frames["left"].mailbox_treeview_reload();
		        }
		    }
            
            function modify_onclick(selectFolderName, selectFolderNameSpl) {
            	this.selectFolderName = selectFolderName;
            	this.selectFolderNameSpl = selectFolderNameSpl;
            	
		        if (selectFolderId == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		        else if (checkTopLevelFolder(selectFolderName)) {
		            alert("<spring:message code='ezEmail.t458' />");
		            return;
		        }
		        inputNameDlg_cross_dialogArguments[0] = selectFolderNameSpl;
		        inputNameDlg_cross_dialogArguments[1] = modify_onclick_Complete;
		        inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
		        DivPopUpShow(330, 150,"/ezEmail/inputNameDlg.do");
		    }

		    function modify_onclick_Complete(szName) {
				const jmochaSafeName = replaceMailboxNameForJmocha(szName);
		        DivPopUpHidden();

				if (selectFolderNameSpl === jmochaSafeName) {
		            return;
		        }
				if (!jmochaSafeName || checkBadFolderName(jmochaSafeName)) {
		            return;
		        }

				const result = mail_make_folder("MODIFY", selectFolderName, "", jmochaSafeName);
		        if (result != "OK") {
		        	if (result == "ALREADY_EXISTS") {
		        		alert("<spring:message code='ezEmail.lhm05' />");
		        	} else {
		        		alert("<spring:message code='ezEmail.t459' />");
		        	}
		        	return;
		        }
		        $("#MailEnv_ifrm")[0].contentWindow.requestFolderList();
		        if(window.parent.frames["left"].configFlag == "false") {
			        window.parent.frames["left"].mailbox_treeview_reload();
		        }
		    }
			
		 // 2016-12-28 이효민 추가
			function checkTopLevelFolder(nodeIdx) {
				var folderUrl = nodeIdx;
				if (folderUrl.indexOf(".") > -1) {
					return false;
				} else {
					return true;
				}
			}
		 
			var pgSetTimeout;
		    var pgSetTime = 2000;
		    var psSetTimeFlag = false;

			/** @callback ProgressStateHandler
			 * @param {number} progress
			 * @param {string} state
			 * @param {string} stateDescription
			 * 메일함 작업 진행상황 체크 시마다 호출되는 핸들러 */

			/** @param {boolean} act 작동 시 true, 취소 시 false
			 * @param {string} userKey
			 * @param {ProgressStateHandler} stateHandler */
			function mailboxProgressFun(act, userKey, stateHandler) { // mailboxProgress start or stop
				psSetTimeFlag = act;
				if (act) {
					mailboxProgress(userKey, stateHandler);
				} else {
					clearTimeout(pgSetTimeout);
					mailboxProgressDel(socketUserkey);
				}
			}

			/** @param {string} userKey
			 * @param {ProgressStateHandler} stateHandler */
			function mailboxProgress(userKey, stateHandler) { // get mailbox Export or Import progress
		    	var uk = userKey;
		    	
		    	pgSetTimeout = setTimeout(function getMailboxProgress() {
		    		if (!psSetTimeFlag) { return; }
		    		
		    		$.ajax({
		    			type : "POST",
		    			url : "/ezEmail/getMailboxProgress.do",
		    			data : {"userKey" : uk},
						dataType : "json", 
		    			async : true,
		    			success : function(data) {
		    				var pg = data.progress;
		    				
		    				if (pg > -1 && pg <= 100) {
		    					ShowPercent(pg);
		    				}
	    					if (pg < 100) { 
	    						setTimeout(getMailboxProgress, pgSetTime);
	    					}

							if (stateHandler) {
								stateHandler(pg, data.state, data.stateDescription);
							}
		    			}, error : function(e) {
		    				alert("error. " + e.status);
		    			}
		    		});
		    	}, pgSetTime)
		    }
		    
		    function mailboxProgressDel(userKey) {
		    	$.ajax({
		    		type : "POST",
	    			url : "/ezEmail/delMailboxProgress.do",
	    			data : {"userKey" : userKey}
		    	});
		    }
		    
		 	// 2024.08.12 한슬기 : 메일 환경설정 > 편지함관리 > 가져오기 추가
			function mailbox_attach_import(pwd, tempId, userkey, folderPath, frm, stateHandler) {
				var encryptPw = (typeof pwd != "undefined") ? pwd : "";
		    	var path = (typeof tempId != "undefined") ? tempId : "";
		    	var tempname = "";
	            socketUserkey = mailbox_getUserKey();
		        
				showDim();
	        	ShowMailProgressNew();
	        	
	            if (path != "") {
	            	ShowPercent(dec);
	            } else {
		            ShowPercent(uploading);
	            }
	            mailboxProgressFun(true, socketUserkey, stateHandler);
	  
	            var requestUrl = "/ezEmail/mailboxImportZip.do?folderPath="
					+ encodeURIComponent(folderPath) 
					+ "&userkey=" + encodeURIComponent(socketUserkey)
					+ "&encryptPw=" + encodeURIComponent(encryptPw)
					+ "&tempId=" + encodeURIComponent(path);
		        
		        if (typeof(shareId) != "undefined" && shareId != "") {
		        	requestUrl += "&shareId=" + encodeURIComponent(shareId);
		    	}
		        
		        setTimeout(function() {
		            frm.action = requestUrl;
		            frm.submit();
		        }, 100); 

			}
			// 2024.08.12 한슬기 : 메일 환경설정 > 편지함관리 > 가져오기 추가 end

			function HiddenFolderMenu(){
				if (typeof parent.frames['left'] != "undefined") {
					parent.frames['left'].document.getElementById("folderMenuDiv").style.display = "none";
				}
				
				if (document.getElementById("mailPanel") != null){
					if (document.getElementById("mailPanel").style.display == "") {
						document.getElementById("mailPanel").style.display = "none";
					}
				}
			}
		    
	    </script>
	    <title><spring:message code='ezEmail.t904' /></title>
	</head>
	<body class="mainbody" style="min-width: 835px">
		<c:choose>
			<c:when test="${flag eq 'email'}">
				<h1 id="confTitle"><spring:message code='ezEmail.t904' /><c:if test="${shareName != null}"> - <c:out value="${shareName}" /></c:if></h1>
		    </c:when>
		    <c:otherwise>
				<h1><spring:message code='ezAddress.hyh001' /></h1>
		    </c:otherwise>
	    </c:choose>
	        <div class="portlet_tabpart01">
		        <div class="portlet_tabnew01_top" id="tab1" style="border-bottom:none;">
		        	<c:choose>
						<c:when test="${flag eq 'email' && shareId == null}">
					    	<p id = "MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezPersonal.yej01' /></span></p>
		                    <c:if test="${useOnlyInnerMail != 'YES'}">
		                    <p id = "MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezEmail.t238' /></span></p>
		                    </c:if>
		                    <p id = "MailEnv_sub4"><span divname="MailEnv_div4" id="1tab4"><spring:message code='ezEmail.t137' /></span></p>
		                    <p id = "MailEnv_sub5"><span divname="MailEnv_div5" id="1tab5"><spring:message code='ezEmail.t146' /></span></p>
		                    <p id = "MailEnv_sub6"><span divname="MailEnv_div6" id="1tab6"><spring:message code='ezEmail.t117' /></span></p>
		                    <p id = "MailEnv_sub7"><span divname="MailEnv_div7" id="1tab7"><spring:message code='ezEmail.t283' /></span></p>
		                    <p id = "MailEnv_sub8"><span divname="MailEnv_div8" id="1tab8"><spring:message code='ezEmail.t203' /></span></p>
		                    <p id = "MailEnv_sub9"><span divname="MailEnv_div9" id="1tab9"><spring:message code='ezEmail.t99000084' /></span></p>
		                    <p id = "MailEnv_sub10"><span divname="MailEnv_div10" id="1tab10"><spring:message code='ezEmail.t455' /></span></p>
		                    <c:if test="${useUserDefinedDL eq 'YES'}">
		                    <p id = "MailEnv_sub11"><span divname="MailEnv_div11" id="1tab11"><spring:message code='ezEmail.t57' /></span></p>
		                    </c:if>
					    </c:when>
					    <c:when test="${flag eq 'email' && shareId != null}">
					    	<p id = "MailEnv_sub5"><span divname="MailEnv_div5" id="1tab1"><spring:message code='ezEmail.t146' /></span></p>
		                    <p id = "MailEnv_sub6"><span divname="MailEnv_div6" id="1tab6"><spring:message code='ezEmail.t117' /></span></p>
		        			<p id = "MailEnv_sub7"><span divname="MailEnv_div7" id="1tab7"><spring:message code='ezEmail.t283' /></span></p>
		                    <p id = "MailEnv_sub10"><span divname="MailEnv_div10" id="1tab10"><spring:message code='ezEmail.t455' /></span></p>
					    </c:when>
					    <c:otherwise>
							<p id = "MailEnv_sub2"><span divname="MailEnv_div2" id="1tab1"><spring:message code='ezPersonal.yej01' /></span></p>
					    </c:otherwise>
				    </c:choose>	
					<%--24.06.12 이사라 - 공유사서함 태그 지원--%>
					<c:if test="${useMailTag and flag ne 'address'}">
						<p><span divname="tag" id="1tab12"><spring:message code='ezEmail.tag.config' /></span></p>
					</c:if>
					<%-- [국립암센터] 25.06.24 김승연 - POP3/IMAP 사용 설정--%>
					<c:if test="${useDisablePopImap == 'YES' and (usePOP3Default == 'YES' or usePOP3 == '1')}">
						<p id = "MailEnv_sub13"><span divname="MailEnv_div13" id="1tab13"><spring:message code='ezEmail.POP3' /></span></p>
					</c:if>
					<c:if test="${useDisablePopImap == 'YES' and (useIMAPDefault == 'YES' or useIMAP == '1')}">
						<p id = "MailEnv_sub14"><span divname="MailEnv_div14" id="1tab14"><spring:message code='ezEmail.IMAP' /></span></p>
					</c:if>
	            </div>
	        </div>
	        <iframe id = "MailEnv_ifrm" style ="width:100%;height:100%;" frameborder="0" ></iframe>
		        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" oncontextmenu="event_listContextMenuAndId(event); return false;" onclick="HiddenFolderMenu();">&nbsp;</div>
			<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
	            <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;">4567467</div>
	            <a class="btnposition" id="cancleProgressBtn" style="display: none; padding-top: 10px; width: 50px; height:20px; 
	      			cursor:pointer; margin:0 auto;" onclick="cancleProgress();">
	            <input type="button" value="<spring:message code="ezEmail.t39" />"/></a>
	        </div>
<!-- 			<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="" oncontextmenu="event_listContextMenuAndId(event); return false;">&nbsp;</div> -->
			<div class="layerpopup"  style="z-index: 9009; position: absolute;display: none;" id="iFramePanel">
	    		<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
			</div>
			<iframe name="AttachDownFrame" id="AttachDownFrame" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none"></iframe>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>
