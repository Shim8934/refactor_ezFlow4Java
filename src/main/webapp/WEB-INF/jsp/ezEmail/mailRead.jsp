<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<style> 
			P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm }
			#tag_td { padding: 5px; }
			#tag_add { height: 22px; }
			#tag_view > span + img { width: 11px; height: 11px; cursor: pointer; margin: 0 7px 0 4px; }
		</style>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email.address.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tag.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript">	
		    var g_paramURL = "${url}";
			var g_expath = "exchange";
			var g_servername = ""; 
			var g_userID = "${ userinfo.EmailID }";
			var g_loginID = "${ userinfo.UserID }";
			var g_author = ""; 
			var g_exchNBName = "${ userinfo.ExchNBName }";
			var g_userName = "${ userinfo.DisplayName }";
			var g_fromEmail = "${fromEmail}";
		    var g_userLang = "${ userinfo.lang }";
			var g_rejectWord = "";
			var g_date = "${_date}";
			var g_notiSSO = "${ _notiSSO }";
			var searchPage = "${ _searchPage }";
			var usedMoveDel = "0";
			var messageid = "${ _messageid }";
			var g_useremail = "${ userinfo.Email }";
			var g_MailSpamURL = "${ _MailSpamURL }";
			var g_itsmtitle = "${ _MailTitle }";
			var _ITSMAdmin = "${ _ITSMAdmin }";
			var ITSMEmail = "${ _ITSMEmail }";
			var ITSMName = "${ _ITSMName }";
			var sentItems = "${isSentItems}";
			var IsSecurityMail = "Normal";
			var ReadCountCheck ="${pReadFlag}";
		    var IsAttach = "${pIsAttach}";
		    var pUse_Editor = "${Use_Editor}";
		    var pisDelete = "${isDelete}";
		    var pContentClass = "${pContentClass}";
		    var pNoneActiveX = "${NoneActiveX}";
		    var isSecureMail = "${isSecureMail}";
		    var useReSend = "${useReSend}";
		    var sentDateMsg = "${sentDateMsg}"; // 전달, 회신 시 보낸 시간
		    var dotNetIntegration = "${dotNetIntegration}";
		    var shareId = "${shareId}";
		    var deletePermission = "${deletePermission}";
		    var sendPermission = "${sendPermission}";
		    var managePermission = "${managePermission}";
		    var mailWritePreview = "${mailWritePreview}"; // 메일 작성 > 미리보기
		    var mailWritePreviewSend = "${mailWritePreviewSend}"; // 메일 작성 > 발송 전 미리보기
		    var g_uid = "${uid}";
		    var countryName = "${countryName}";
		    var countryIP = "${countryIP}";
		    var countryCode = "${countryCode}";
		    var systemCountryCode = "${systemCountryCode}";
		    var useCountryIP = "${useCountryIP}";
		    var useShowSystemCountry = "${useShowSystemCountry}";
			var mailBox = "${mailBox}";
		    
		    window.onresize = window_onresize;
		    
			function window_onload()
			{
			    window_onresize();
				
				var g_szRootFolderName = g_paramURL.split('/');
			    
			    if (useReSend == "YES" && sentItems.toUpperCase() == "TRUE") {
		    		$('#liReSend').css('display', 'block');
		   		}
				
				$(parent.document).mouseup(function (e) {
					hiddenMoreMenu(e);
				});
				
				$(document).mouseup(function (e) {
					hiddenMoreMenu(e);
				});
			    
			    if (g_notiSSO == "1")
				{
		            if(navigator.appVersion.indexOf("MSIE 6")>-1) 
		            { 
		                self.resizeTo(800,600); 
		            } 
		            else if(navigator.appVersion.indexOf("MSIE 7")>-1) 
		            { 
		                normalScreen.style.width="850"; 
		                normalScreen.style.height="650"; 
		            } 
		
					HideMenu();
			    }
			    
			    document.getElementById("PcSave").style.display = "none";
			    
			    form1.iptFolderPath.value = "${folderPath}";
		        form1.iptURL.value = "${uid}";
		        form1.submit();
		        
		        if(_ITSMAdmin == "Y")
		        {
		             btnITSM.style.display = "";
		        }
		        if (sentItems.toUpperCase() == "TRUE")
		        {
		        	document.getElementById("HolderSent").style.display = "";
		            document.getElementById("HolderElse").style.display = "none";
		            /* SentBcc.style.display = ""; */
		        } else {
		        	document.getElementById("HolderSent").style.display = "none";
		            document.getElementById("HolderElse").style.display = "";
		        }
		        
		        /* if (shareId != "" && managePermission != "Y") {
		        	document.getElementById("btn_reject").parentNode.style.display = "none";
		        } */
		        
		        if (shareId != "" && sendPermission != "Y") {
		        	btnReply.style.display = "none";
		        	btnAllReply.style.display = "none";
		        	btnForward.style.display = "none";
		        	liReSend.style.display = "none";
		        	HolderSent.style.display = "none";
		        }
		        
		        if (shareId != "" && deletePermission != "Y") {
		        	btnMove.style.display = "none";
		        	btnDelete.style.display = "none";
		        }
		        
		        if (useCountryIP == "YES" && (mailWritePreview != "true" ||  mailWritePreviewSend == "false")) {
		        	if (useShowSystemCountry == "YES" || (useShowSystemCountry != "YES" && countryCode != systemCountryCode)) {
			        	
		        		if (document.getElementById("nationalFlag") != null) {
			        		countryCode = countryCode == "unknown" ? "qm" : countryCode;
			        		
			        		document.getElementById("nationalFlag").src = "/images/countryIcon/" + countryCode + ".png";
				        	document.getElementById("nationalFlag").style.display = "";
			        	}
		        	}
		        } 
		        
		        try{
		            if(ReadCountCheck=="N")
		            {
		                opener.refreshUnreadCount();
		            }
		        } 
			    catch (e) {console.log(e);}
			    
			    if (mailWritePreview == "true") {
			    	$("#menu > ul:first-child").css("display","none");
			    	$("#menu > ul:nth-child(2)").css("display", "none");
			    } else if (mailWritePreviewSend == "true") {
			        $("#menu > ul:first-child").css("display","none");
			        $("#menu > ul:nth-child(2)").css("display", "block");
			    }

				<c:if test="${useMailTag}">
					var tagAddInput = document.getElementById("tag_add");
					// 태그 입력 시 특수문자 입력 못하도록 함
					inputUtil.makeNotAllowTyping(tagAddInput, /[!@#$%^&()\\\/:*?"<>|'`]/g);
					inputUtil.makeReplaceTyping(tagAddInput, /\s/g, '_');
					// 엔터 시 태그로 추가되도록 함
					tagAddInput.addEventListener("keydown", function(e) {
						if (e.keyCode == 13) onEnterPreviewTagInput();
					});
					document.querySelector(".input_wrap + .imgbtn").addEventListener("click", function(e) { onEnterPreviewTagInput(); });
					// 태그 X 버튼 클릭시 삭제
					$(".tag_del").on("click", function() { removeTag(this.nextElementSibling); });

					// 태그 추가 시 자동완성
					$(tagAddInput).autocomplete({
						source: function(request, response) {
							if (!window.cacheTags) {
								$.ajax({
									cache: false,
									async: false,
									url: "/ezEmail/getUserTagList.do",
									success: function(result) {
										if (result.status == "error") {
											alert(strLang321);
											return;
										}
										var tags = result.data;
										window.cacheTags = $.map(tags, function(ul, item) { return ul.name; });
									}
								});
							}

							response($.grep(window.cacheTags, function(tag) {
								return tag.indexOf(request.term) > -1;
							}));
						},
						minLength: 2,
						selectFirst: true,
						// autoFocus: true,
					});

					tagAddInput.addEventListener("input", function() {
						var inputWrap = document.getElementById("input_wrap");
	
						// 클래스에 "on"이 있으면 제거
						if (inputWrap.classList.contains("on")) {
							inputWrap.classList.remove("on");
						}
					});
				</c:if>
			}

			function send() {
			    window.opener.previewSend();
			    window.close();
			}

		    function btnPrint_onClick()
		    {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        if (conWidth > 890)
		            conWidth = 890;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
				var url = "/ezEmail/mailPrint.do?URL=" + encodeURIComponent(g_paramURL);
		        
				if (typeof(shareId) != "undefined" && shareId != "") {
					url += "&shareId=" + encodeURIComponent(shareId);
				}
				
		        window.open(url, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1, scrollbars=1");
		    }
			function window_onresize()
		    {
		        if (g_notiSSO == "1")
		            return;
		        if (document.getElementById('message').style.width != document.documentElement.clientWidth - 20)
		            if (document.body.clientWidth - 20 > 0)
		                document.getElementById('message').style.width = document.documentElement.clientWidth - 20;
		
				var resizeHeight;
		        if("${pIsCCFg}"!="N")
					resizeHeight = document.documentElement.clientHeight - 220;
		        else
					resizeHeight = document.documentElement.clientHeight - 190;
				<c:if test="${useMailTag}">
				resizeHeight -= document.getElementById("tag_td").clientHeight;
				</c:if>

				if(sentItems.toUpperCase() == "TRUE") {
					document.getElementById("message").style.height = resizeHeight + "px";
					var messeageValue = document.getElementById("message");
					var messeageHeight = messeageValue.style.height
					messeageHeight = parseFloat(messeageHeight) - parseFloat("14");
					messeageValue.style.setProperty('height', messeageHeight + 'px', 'important');
				} else {
					document.getElementById("message").style.height = resizeHeight + parseFloat("14") + "px";
				}
				
		        mailPrevSentDateChk();
		    }	
			
			function HideMenu()
			{
				btnReply.style.display = "none";
				btnAllReply.style.display = "none";
				btnForward.style.display = "none";
				btnMove.style.display = "none";
				btnDelete.style.display = "none";
				btnEncode.style.display = "none";
				btnBoard.style.display = "none";				
				btnBookmark.style.display = "none";
				btnViewWeb.style.display = "none";
				btn_KMS.style.display = "none";
				btnInsertAddr.style.display = "none";
			}
			
			function ToKMS()
			{
			    var url = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezKMS/kasset/KAssetConvert_Cross.aspx?Mode=new&Flag=email&url=" + encodeURIComponent(g_paramURL);
			    var OpenWin = window.open(url, "mail_foldermanage_Cross", GetOpenWindowfeature(800, 780));
			    try { OpenWin.focus(); } catch (e) {console.log(e);}
			}
			
			function OnBtnClose()
			{
			    if (g_notiSSO == "1")
					window.location = "btn:action|close";
				else
					window.close();
			}	
			
			function window_onbeforeunload()
			{
			   if(searchPage == "1" && usedMoveDel == "1")
			        opener.callback();
			   
			   mailWritePreviewDel();
			}
			
			function deliver()
			{
			    var url = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezEmail/remote/delivershow.aspx?Mode=new&messageid="+ encodeURIComponent(messageid) + "&mailsender="+ encodeURIComponent(g_fromEmail);	
			    var feature = "status:no;dialogWidth:780px;dialogHeight:290px;help:no;scroll:no;edge:sunken";
			    feature = feature + GetShowModalPosition(780, 290);
			    window.showModalDialog(url, "", feature);
			
			}
			
			function ITSM_send()
			{
			    try 
		        {                 	 
		            window.open("/myoffice/ezPortal/SSO/SSO_Link.aspx?TYPE=ITSMAPPDOC&DOCTITLE=" + encodeURIComponent(g_itsmtitle) + "&EMAIL=" + encodeURIComponent(ITSMEmail) + "&NAME=" + encodeURIComponent(ITSMName) + "&DEPT=", '', '');
		        } 
		        catch(e) {console.log(e);}
			}
			
			function SecurityFG()
		    {
		        var xmlDOM = new ActiveXObject("Microsoft.XMLDOM");
		        var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
		    			
			    var objRoot = xmlDOM.createNode(1,"DATA","");
			    xmlDOM.appendChild(objRoot);
		    	
			    var objNode = xmlDOM.createNode(1, "URL", "");
			    objNode.text = "${_url}";
			    objRoot.appendChild(objNode);
		    	
			    xmlHTTP.open("POST", "/myoffice/ezEmail/remote/GetSecurity.aspx", false);
			    xmlHTTP.send(xmlDOM.xml);
		    	
			    IsSecurityMail = xmlHTTP.responseText;
		    }
		    function ShowHiddenTo(obj)
		    {
		    	var currHeight = $(".content tbody tr:nth-child(2)").outerHeight();
		    	var heightForChange = "";
		        if(MsgToGotHidden.style.display=="none")
		        {
		        	MsgToGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		            heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		        else
		        {
		        	MsgToGotHidden.style.display = "none";
		            obj.src ="/images/expnd.gif";
		            heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		    }
		    function ShowHiddenCc(obj)
		    {
		    	var currHeight = $(".content tbody tr:nth-child(3)").outerHeight();
		    	var heightForChange = "";
		        if(MsgCCGotHidden.style.display=="none")
		        {
		            MsgCCGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		            heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		        else
		        {
		            MsgCCGotHidden.style.display = "none";    
		            obj.src ="/images/expnd.gif";
		            heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		    }
		    function mtg_onClick(mtgid) {
		        var requestType = "";
		        switch (mtgid) {
		            case "ACCEPT":
		                requestType = "<spring:message code='ezEmail.t901' />";
		                break;
		            case "DECLINE":
		                requestType = "<spring:message code='ezEmail.t902' />";
		                break;
		            case "TENT":
		                requestType = "<spring:message code='ezEmail.t903' />";
		                break;
		        }
		
		        var g_saveHttp = createXMLHttpRequest();
		        var xmlDoc = createXmlDom();
		        var rootNode;
		        createNodeInsert(xmlDoc, rootNode, "DATA");
		        createNodeAndInsertText(xmlDoc, rootNode, "ITEMID", g_paramURL);
		        createNodeAndInsertText(xmlDoc, rootNode, "REQUEST", mtgid);
		        g_saveHttp.open("POST", "/myoffice/ezEmail/remote/mail_response_meeting.aspx", false);
		        g_saveHttp.setRequestHeader("Content-Type", "text/xml");
		        g_saveHttp.send(xmlDoc);
		        if (g_saveHttp.status >= 200 && g_saveHttp.status < 300) {
		            if (g_saveHttp.responseText == "OK") {
		                alert(requestType + strLang320);
		                window.opener.MailListRefresh();
		                OnBtnClose();
		            }
		            else
		                alert(strLang321);
		        }
		        else
		            alert(strLang321);
		        g_saveHttp = null;
		    }
		
		    var writeboardselect_modal_dialogArguments = new Array();
		    
			function GetOpenWindowfeatureNoScrollbar(popUpW, popUpH) {
			
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = 0;
				var top = 0;
				var pleftpos;
				pleftpos = parseInt(width) - popUpW;
				heigth = parseInt(heigth) - popUpH;
				width = parseInt(width) - pleftpos;
				left = pleftpos / 2;
				top = heigth / 2;
				var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=no";
				return feature;
			}
		    
            // 닷넷 게시판 선택 모듈을 호출하는 경우엔 Cross Origin(서로 도메인이 다름)으로 인해 opener를 통한 NewItem_onclick_Complete에
            // 직접적 접근이 허용되지 않아 window.postMessage와 Message Event Listener를 사용함
            if (dotNetIntegration == "YES") {
            	window.addEventListener("message", function(e) {
                    var ret = new Array();

                    // 사용자가 선택한 게시판의 ID가 리턴됨
                    ret = e.data;
                    
                    NewItem_onclick_Complete(ret);
                });
            }
		    
		    // 메일읽기창에서 '게시' 버튼을 누를 때 호출됨		    
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            
		            if (dotNetIntegration == "YES") {
		            	// IE가 window.postMessage를 Cross Origin에서 지원하지 않는 관계로 동일 사이트의 윈도우를
			            // 띄운 후 그 안에서 iframe으로 처리해야 한다.
			            var OpenWin = window.open("/ezBoard/writeBoardSelectModalDotNet.do", "WriteBoardSelect_Modal", GetOpenWindowfeatureNoScrollbar(355, 660));
		            } else {
		            	// 자체 게시판 선택 모듈을 호출하는 경우
			            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
		            }
		            
		            try { OpenWin.focus(); } catch (e) {console.log(e);}
		        }
		        else {
		            var wWeight = "355";
		            var wHeight = "600";
		
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:600px;DialogWidth:355px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
		            if (typeof (ret) != "undefined") {
		
		                var pheight = window.screen.availHeight;
		                var pwidth = window.screen.availWidth;
		                var pTop = (pheight - 720) / 2;
		                var pLeft = (pwidth - 765) / 2;
		
		                pBoardID = ret[0];
		
		                if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                    return;
		                }
		
		                if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8" || (ret[3] != "null" && ret[3] != null && ret[3] != "")) {
		                    alert(strLang337);
		                }
		                else {
		                	var requestUrl = "/ezBoard/boardNewItem.do?mode=new1&boardID=" + encodeURIComponent(pBoardID) + "&url=" + encodeURIComponent(g_paramURL);
		                	
		                	if (typeof(shareId) != "undefined" && shareId != "") {
		                		requestUrl += "&mailShareId=" + encodeURIComponent(shareId);
		    				}
		                	
		                    window.open(requestUrl, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                }
		            }
		        }
		    }
		
		    function NewItem_onclick_Complete(ret) {
				if (ret == "cancel" || typeof (ret) == "undefined") {
					return;
				} else if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
					var boardWidth = 765;
					var boardHeight = 720;
					var boardTarget = "";
					if (dotNetIntegration == "YES") {
						boardWidth = 900;
						boardHeight = 800;
						boardTarget = "NewBoardItem";
					}
		            
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - boardWidth) / 2;
		            var pLeft = (pwidth - boardHeight) / 2;
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8") {
		                alert(strLang337);
		            }
		            else {
		            	var requestUrl; 
		            	
		            	if (dotNetIntegration == "YES") {
		            		requestUrl = "${dotNetUrl}/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL) + "&pagetype=POPUP&javaflag=true";
		            	} else {
		            		requestUrl = "/ezBoard/boardNewItem.do?mode=new1&boardID=" + encodeURIComponent(pBoardID) + "&url=" + encodeURIComponent(g_paramURL);
		            	}
	                	
	                	if (typeof(shareId) != "undefined" && shareId != "") {
	                		requestUrl += "&mailShareId=" + encodeURIComponent(shareId);
	    				}
		            	
	                	window.open(requestUrl, boardTarget, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + boardHeight + ",width=" + boardWidth + ",top=" + pTop + ",left=" + pLeft, "");
		            }
		        }
		    }
		
		    function SuccessBoard() {
		        // 게시 완료 후 페이지 리로드 방지
		    }
		    
		    function reloadReadContent(url) {
		    	g_paramURL = url;
		    	form1.iptFolderPath.value = url.split('/')[0];
		        form1.iptURL.value = url.split('/')[1];
		        form1.submit();
		        window.opener.MailListRefresh();
		        window.opener.reloadReadContent(url);
		    }
		    
		    function secureInfo_onClick() {
		    	var url = "/ezEmail/secureMailInfo.do?url=" + encodeURIComponent(g_paramURL);
		    	
		    	if (typeof(shareId) != "undefined" && shareId != "") {
		    		url += "&shareId=" + encodeURIComponent(shareId);
		    	}
		    	
		    	DivPopUpShow(550, 500, url);
		    }
		    
		    function reSend_onClick() {
		        var pURI = "/ezEmail/mailWrite.do?cmd=RESEND&URL=" + encodeURIComponent(g_paramURL);
		        
		        if (typeof(shareId) != "undefined" && shareId != "") {
		        	pURI += "&shareId=" + encodeURIComponent(shareId);
		    	}
		        
		        var newwin = GetOpenWindow(pURI, "", 1200, 840, "yes");
		        newwin.focus();
		    }
		    
			function addRelatedCabinet() {
				//* moon 2018.07.26
				var openWidth = 480;
				
				if (navigator.userAgent.includes("Edg")) {
					openWidth = 600;
				}
				window.open("/ezCabinet/cabinetAddRelated.do?module=email", "addRelated", getOpenWindowfeature(openWidth, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
				return feature;
			}
			
		    function mailPrevSentDateChk() {
		    	if (sentDateMsg != "") { // 전달 및 회신시 보낸시각
		    		var sentDateHeight = $(".sentDateStr").innerHeight();
		    		sentDateHeight = (Math.ceil(sentDateHeight/10) * 10);
		    		
		    		var messageH = $("#message").height();
		    		$("#message").height(messageH - sentDateHeight);
		    	}
		    }
		    
		    window.onbeforeunload = function () {
		    	mailWritePreviewDel();
		    }
		    
		    function mailWritePreviewDel() {
		        // 기존 mailWritePreview는 브라우저 오픈 후 + 닫힐 때 2번 실행, mailWritePreviewSend는 닫힐 때 1번 실행
		        // mailWritePreviewSend 일때 send와 함께 작동하면서 isDelted 가 true로 변경되어 '발송전 미리보기' 기능 사용 시 메일 삭제 되지 않는 오류 발생
		        // delDrafts_preview 함수로 우회하여 isDelted가 false가 되도록 수정
		    	if (mailWritePreview == "true" || mailWritePreviewSend == "true") {
                    // 메일 작성 > 미리보기 메일 삭제
                    window.opener.parent.delDrafts_preview(g_uid);
                    window.parent.opener.parent.previewChk = false;
				}
			}
			
		    
		    /* 2020-08-31 홍승비 - 메일 커뮤니티 게시판에 게시 기능 추가 */
		    // 메일읽기창에서 '커뮤니티 게시' 버튼을 누를 때 호출됨
		    var writeCommboardselect_modal_dialogArguments = new Array();
		    function NewItemCommu_onclick() {
				writeCommboardselect_modal_dialogArguments[1] = NewItemCommu_onclick_Complete; // 커뮤니티 게시판 선택 완료 시의 동작
	           
				var OpenWin = window.open("/ezCommunity/communityBoardSelectForMail.do", "communityBoardSelectForMail", GetOpenWindowfeature(355, 600));
				try { OpenWin.focus(); } catch (e) {console.log(e);}
		    }
		    
		    function NewItemCommu_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		            
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		            
					var boardWidth = 765;
					var boardHeight = 720;
					var boardTarget = "";
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - boardWidth) / 2;
		            var pLeft = (pwidth - boardHeight) / 2;
		            	
	            	// 커뮤니티 신규 게시물 작성창으로 연결
	            	var requestUrl; 
	            	requestUrl = "/ezCommunity/newBoardItem.do?mode=new1&boardID=" + encodeURIComponent(pBoardID) + "&url=" + encodeURIComponent(g_paramURL);
                	
                	if (typeof(shareId) != "undefined" && shareId != "") {
                		requestUrl += "&mailShareId=" + encodeURIComponent(shareId);
    				}
	            	
                	window.open(requestUrl, boardTarget, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + boardHeight + ",width=" + boardWidth + ",top=" + pTop + ",left=" + pLeft, "");
		        }
		    }
			
			function toggleMoreMenu() {
				document.getElementById("view_more").classList.toggle('on');
				var element = document.getElementById("layer_menu");
				if (element) {
					if (element.style.display === 'none') {
						element.style.display = '';
					} else {
						element.style.display = 'none';
					}
				}
			}
			
			function hiddenMoreMenu(e) {
				var element = document.getElementById("layer_menu");
				var clickedElementClass = e.target.className;

				if (element) {
					if (element.style.display !== 'none' && !clickedElementClass.includes('view_more')) {
						document.getElementById("view_more").classList.remove('on');
						element.style.display = 'none';
					}
				}
				var tagLayerElement = document.getElementById("layer_select");
				if (tagLayerElement) {
					tagLayerElement.scroll({top:0});
					var tagLayerStyle = getComputedStyle(tagLayerElement);
					if (tagLayerStyle.display !== 'none' && !clickedElementClass.includes('input_select_arrow')) {
						document.getElementById("input_wrap").classList.remove("on");
					}
				}


				let usingMailPreview = document.getElementById("iFramePanel_mail_preview")?.className.includes('on');
				if (usingMailPreview) {
					hiddenPreviewMail();
				}
			}
			
	    </script>
		    
		<%-- 웹폴더 첨부 레이어팝업을 위한 스크립트 추가--%>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/relay/webfolderFileUploadOpener.js')}"></script>
		<%@ include file="/WEB-INF/jsp/ezWebFolder/relay/webfolderFileListUploadParentHead.jsp" %>
		<script type="text/javascript">
		function completeListener() {
			document.getElementById("mailPanel").style.display = "none";
			document.getElementById("loadingLayer").style.display = "none";
		}
		duplicateFile.setOnCompleteListener(completeListener);
		</script>
	</head>

	<body id="parentBody" class="popup" onload="javascript:window_onload()"   style="overflow:hidden;"> 
		<table id="normalScreen" class="layout"> 
		    <tr> 
		        <td height="20">
		            <div id="menu">
		                <ul>
		                    <li><span id="btnReply" onClick="reply_onClick()"><spring:message code="ezEmail.t511" /></span></li>
		                    <li><span id="btnAllReply" onClick="allreply_onClick()"><spring:message code="ezEmail.t512" /></span></li>
		                    <li><span id="btnForward" onClick="pass_onClick()"><spring:message code="ezEmail.t513" /></span></li>
		                    <li id="liReSend" style="display: none;"><span id="btnReSend" onClick="reSend_onClick()"><spring:message code="ezEmail.kyj19" /></span></li>
		                    <li><span id="btnMove" onClick="move_onClick()"><spring:message code="ezEmail.t482" /></span></li>
		                    <li id="PcSave"><span id="btnSave" onClick="download_mail()">PC <spring:message code="ezEmail.t48" /></span></li>
							<li><span class="icon16 popup_icon16_star" id="btnBookmark" onClick="toggle_flag()"></span></li>
							<li><span class="icon16 popup_icon16_delete" id="btnDelete" onClick="delete_mail()"></span></li>
							<li><span class="icon16 popup_icon16_print" id="btnPrint" onClick="btnPrint_onClick()"></span></li>
		                    <c:if test="${pnFlag=='Y'}">
			                    <li id="iprev"><span id="btnpre" onclick="get_mail('prev')" style="padding-top:0px;"><img src="/images/ImgIcon/prev.gif" alt="<spring:message code='ezEmail.t1000' />"  /></span></li>
			                    <li id="inext" ><span id="btnnext" onclick="get_mail('next')" style="padding-top:0px;"><img src="/images/ImgIcon/next.gif" alt="<spring:message code='ezEmail.t1001' />" /></span></li>
		                    </c:if>
							<li class="view_more" onclick="toggleMoreMenu()"><span class="view_more" id="view_more"><img class="view_more" src="/images/ImgIcon/view_more.png"></span>
								<ul class="layer_select" id="layer_menu" style="display: none">
									<c:if test="${packageType != 'mail'}">
										<li id="BoardItem"><span id="btnBoard" onClick="NewItem_onclick()"><spring:message code="ezEmail.t548" /></span></li>
										<c:if test="${useMailToCommunity == 'YES'}">
											<li id="CommunityItem"><span id="btnCommunity" onClick="NewItemCommu_onclick()"><spring:message code="ezEmail.hsbCM01" /></span></li>
										</c:if>
									</c:if>
									<li id="HolderSent"><span id="btnReceiveList" onClick="receiveCheck_onClick()"><spring:message code="ezEmail.t516" />/<spring:message code="ezEmail.t549" /></span></li>
									<li id="HolderElse"><span id="btnViewWeb" onClick="view_original()"><spring:message code="ezEmail.t551" /></span></li>
									<c:if test="${useCabinet == 'YES'}">
										<li><span id="addCabinet" onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
									</c:if>
									<c:if test="${isSecureMail == true && mailBox == 'Sent'}">
										<li><span id="btnSecureInfo" onClick="secureInfo_onClick()"><spring:message code="ezEmail.lhm44" /></span></li>
									</c:if>
									<li id="btnViewOriginText"><span onclick="view_OriginalEML()"><spring:message code='ezEmail.kdh03' /></span></li>
									<li id="btnExport"><span onclick="download_Single_mail()"><spring:message code="ezEmail.t378" /></span></li>
								</ul>
							</li>
		                </ul>
		                <ul style="display:none">
                            <li><span id="" onClick="send()"><spring:message code='ezEmail.t674' /></span></li>
                            <li><span id="" onClick="OnBtnClose()"><spring:message code='ezEmail.t39' /></span></li>
                        </ul>
		            </div>
		            <div id="close"><ul><li><span onClick="OnBtnClose()"></span></li></ul></div>	
		        </td> 
		    </tr>  
		    <tr> 
		        <td>
		            <table class="content">
		                <tr>
		                    <th><spring:message code="ezEmail.t161" /></th>
		                    <td class="pos1" style="vertical-align:middle;">
		                        <DIV id="MsgToPut" onMouseOver="this.style.color='#006BB6'" title="${fromEmail}" style="CURSOR: pointer; padding-left: 5px; vertical-align: middle;" onMouseOut="this.style.color='#393939'">	
			                        <a onClick="show_senderprofile()">					
			                            <span id="LabelFromName">${fromStr}</span>
			                            <span id="LabelFromEmail">&lt;${fromEmail}&gt;</span>
			                            <span id="LabelSenderInfo"></span>	
			                        </a>
				                    <c:if test="${useCountryIP == 'YES'}">
				                    	<span id="country" title= ${countryName}> 
				                    	<c:set var="data" value="${useShowSystemCountry}" />
										<c:if test="${countryName != ''}">	
											<c:choose>
												<c:when test="${useShowSystemCountry eq 'YES'}">
						                        	<img id="nationalFlag" src="" style="vertical-align: middle; padding: 0px 0px 3px;display:none;">
												</c:when>
												<c:otherwise>
													<c:if test="${countryIP != systemCountryCode}">
							                        	<img id="nationalFlag" src="" style="vertical-align: middle; padding: 0px 0px 3px;display:none;">
							                        </c:if>
												</c:otherwise>
											</c:choose>
										</c:if>
										<c:if test="${countryIP != ''}">
											<span> ( ${countryIP} )</span>
										</c:if>
										</span>		
				                    </c:if>		                    
		                        </DIV>
		                    </td>
		                    <th>
		                    <c:if test="${isSentItems == true}">
		                    <spring:message code="ezEmail.t704" />
		                    </c:if>		                    
		                    <c:if test="${isSentItems != true}">
		                    <spring:message code="ezEmail.t657" />
		                    </c:if>
		                    </th>
		                    <td style="border-right:0px;">
		                        <div id="ReceiveDate" style="OVERFLOW-Y: auto;padding-top:2px;padding-left:5px;padding-right:5px; width:150px;"> 
		                        <span id="LabelReceiveDate">${dateStr}</span> 
		                        </div>
		                    </td>
		                    <td nowrap class="pos2" id="btnInsertAddr" <c:if test="${mailWritePreview == true || mailWritePreviewSend == true}">style="display:none"</c:if>>
			                    	<a style="margin-right:5px;"><span onClick="func_addaddr()" id="btn_addaddr"><img title="<spring:message code='ezEmail.t554' />" src="/images/email/icon_address_add.png" style="border:0px" /></span></a>
		                    		<c:if test="${(shareId == null) || (shareId ne '' && managePermission eq 'Y')}">
		                    			<a style="margin-right:5px;"><span onClick="func_reject()" id="btn_reject"><img title="<spring:message code='ezEmail.t270' />" src="/images/email/icon_mail_refusal.png" style="border:0px" /></span></a>
			                    	</c:if>
		                    </td>
		                </tr>
		                <tr>
		                    <th><spring:message code="ezEmail.t66" /></th>
		                    <td colspan="4" style="OVERFLOW-Y:auto;">
		                    <div id="MsgToGot" style="padding-left:5px;"> 
		                    <span id="LabelTo">${toStr}</span> 
		                    </div> 
		                    <div id="MsgToGotHidden" style="margin-bottom:5px;display:none;padding-left:8px;padding-left:5px;"> 
		                    <span id="LabelToHidden">${toHiddenStr}</span> 
		                    </div>
		                    </td>
		                </tr>
		        
					<c:if test="${pIsCCFg != 'N'}">
		                <tr>
		                <th><spring:message code="ezEmail.t555" /></th>
		                <td colspan="4" style="OVERFLOW-Y:auto;height:100%;">
		                <div id="MsgCCGot" style="padding-left:5px;"> 
		                <span id="LabelCC">${ccStr}</span> 
		                </div>
		              
		                <div id="MsgCCGotHidden" style="margin-bottom:5px;display:none;padding-left:5px;"> 
		                <span id="LabelCCHidden">${ccHiddenStr}</span> 
		                </div>
		                </td>
		                </tr>
					</c:if>
		            <c:if test="${bccStr ne ''}">
		                <tr id="SentBcc">
		                <th><spring:message code="ezEmail.t562" /></th>
		                <td colspan="4"><div id="MsgBCCGot" style="padding-left:5px;"> 
		                <span id="LabelBCC">${bccStr}</span>
		                </div></td>
		                </tr>
		            </c:if>
		        
		                <tr>
		                <th><spring:message code="ezEmail.t556" /></th>
		                <td colspan="4"><div id="mailSubject" style="OVERFLOW-Y: auto;padding-left:5px;"> 
		                <span id="LabelSubject">${subject}</span>
		                </div></td>
		                </tr>
						<c:if test="${useMailTag}">
							<tr>
								<th><spring:message code='ezEmail.tag' /></th>
								<td id="tag_td" colspan="4">
									<div class="input_select">
										<div class="input_wrap" id="input_wrap">
											<input id="tag_add" type="text" maxlength="100"/>
											<span class="input_select_arrow" onclick="$('.input_wrap').toggleClass('on');getTagList()"></span>
										</div>
										<a class="imgbtn"><span><spring:message code="ezEmail.tag.user.addbtn" /></span></a>
										<ul class="layer_select" id="layer_select">

										</ul>
									</div>
									
									<div id="tag_view">
										<c:forEach items="${tags}" var="name">
											<div class="tag_list">
												<span class="tag_del" id="tag_del"></span>
												<span class="tag_name" id="tag_name">${name}</span>
											</div>
										</c:forEach>
									</div>
								</td>
							</tr>
						</c:if>
		            </table>
		        </td>
		    </tr>
		    <tr>
		        <td class="pad1">
		        <iframe  id="message" name="message" frameborder="0" style="width:100%;height:100%;BORDER:#ddd 1px solid; background:#fff;" ></iframe>
		        </td>
		    </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			window_onresize();
		</script>
		<%-- 메일 다운로드 iframe--%>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none"></iframe>
		<form name="form1" action="mailReadContent.do" method="post" target="message" >
			<input  type="hidden" id="iptFolderPath"  name="iptFolderPath" value="">
		    <input  type="hidden" id="iptURL"  name="iptURL" value="">
		    <input  type="hidden" id="iSecurity"  name="iSecurity" value="">
		    <input  type="hidden" id="toAddr"  name="toAddr" value="${g_useremail}">
		    <input  type="hidden" id="fromAddr"  name="fromAddr" value="${fromEmail}">
		    <c:if test="${shareId != null && shareId != ''}">
		    	<input  type="hidden" id="shareId"  name="shareId" value="${shareId}">
		    </c:if>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>

	    <%-- 웹폴더 첨부 레이어팝업을 위한 태그 추가--%>
		<%@ include file="/WEB-INF/jsp/ezWebFolder/relay/webfolderFileListUploadParentBody.jsp" %>
	</body>
</html>
