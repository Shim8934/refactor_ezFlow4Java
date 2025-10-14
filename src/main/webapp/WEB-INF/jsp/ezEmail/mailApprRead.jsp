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
	<style> 
		P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm }
		#tag_td { padding: 5px; }
		#tag_add { height: 22px; }
		#tag_view > span + img { width: 11px; height: 11px; cursor: pointer; margin: 0 7px 0 4px; }
	</style>
</head>

<body id="parentBody" class="popup" onload="javascript:window_onload()"   style="overflow:hidden;"> 
	<table id="normalScreen" class="layout"> 
	    <tr> 
	        <td height="20">
	            <div id="menu">
	                <ul>
						<c:if test="${not empty type && type eq 'appr'}">
						<li class="important off"><span onclick="setApproval()"><spring:message code='email.appr.approval' /></span></li> <% // 발송승인 %>
						<li><span onclick="setReject()"><spring:message code='email.appr.reject' /></span></li> <% // 발송거부 %>
						</c:if>
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
	                    <%-- <td nowrap class="pos2" id="btnInsertAddr">
	                    	<c:if test="${mailWritePreview != true}">
		                    	<a style="margin-right:5px;"><span onClick="func_addaddr()" id="btn_addaddr"><img title="<spring:message code='ezEmail.t554' />" src="/images/email/icon_address_add.png" style="border:0px" /></span></a>
	                    		<c:if test="${(shareId == null) || (shareId ne '' && managePermission eq 'Y')}">
	                    			<a style="margin-right:5px;"><span onClick="func_reject()" id="btn_reject"><img title="<spring:message code='ezEmail.t270' />" src="/images/email/icon_mail_refusal.png" style="border:0px" /></span></a>
		                    	</c:if>
		                    </c:if>
	                    </td> --%>
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
	
	                <tr id="SentBcc" style="display:none">
	                <th><spring:message code="ezEmail.t562" /></th>
	                <td colspan="4"><div id="MsgBCCGot" style="padding-left:5px;"> 
	                <span id="LabelBCC">${bccStr}</span>
	                </div></td>
	                </tr>
	       
	        
	                <tr>
	                <th><spring:message code="ezEmail.t556" /></th>
	                <td colspan="4"><div id="mailSubject" style="OVERFLOW-Y: auto;padding-left:5px;"> 
	                <span id="LabelSubject">${subject}</span>
	                </div></td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td class="pad1">
	        <iframe  id="message" name="message" frameborder="0" style="width:100%;height:100%;BORDER:#ddd 1px solid; background:#fff;" ></iframe>
	        </td>
	    </tr>
	</table>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
	<span class="loading_layer" style="z-index:6000;position:absolute;top:50%;left:45%;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>
	<form name="form1" action="mailReadContent.do" method="post" target="message" >
		<input  type="hidden" id="iptFolderPath"  name="iptFolderPath" value="">
	    <input  type="hidden" id="iptURL"  name="iptURL" value="">
	    <input  type="hidden" id="iSecurity"  name="iSecurity" value="">
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
	<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<script type="text/javascript">	
	    var g_paramURL = "${url}";
	    var g_encryptedUrl = "${encryptedUrl}";
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
	    var g_uid = "${uid}";
	    var countryName = "${countryName}";
	    var countryIP = "${countryIP}";
	    var countryCode = "${countryCode}";
	    var systemCountryCode = "${systemCountryCode}";
	    var useCountryIP = "${useCountryIP}";
	    var useShowSystemCountry = "${useShowSystemCountry}";
	    
	    window.onresize = window_onresize;
	    
		function window_onload()
		{
		    window_onresize();
			
			var g_szRootFolderName = g_paramURL.split('/');
		    
		    if (useReSend == "YES" && sentItems.toUpperCase() == "TRUE") {
	    		$('#liReSend').css('display', 'block');
	   		}
		    
		    if (g_notiSSO == "1") {
	            if(navigator.appVersion.indexOf("MSIE 6")>-1) 
	            { 
	                self.resizeTo(800,600); 
	            } 
	            else if(navigator.appVersion.indexOf("MSIE 7")>-1) 
	            { 
	                normalScreen.style.width="850"; 
	                normalScreen.style.height="650"; 
	            } 
		    }
		    
		    form1.iptFolderPath.value = "${folderPath}";
	        form1.iptURL.value = "${uid}";
	        form1.submit();
	        
	        if (useCountryIP == "YES" && mailWritePreview != "true") {
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
		    catch (e) { }
		    
		    if (mailWritePreview == "true") {
		    	$("#menu > ul:first-child").css("display","none");
		    }
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
			document.getElementById("message").style.height = resizeHeight + "px";
	        mailPrevSentDateChk();
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
	        
	        var newwin = GetOpenWindow(pURI, "", 890, 840, "yes");
	        newwin.focus();
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
		
		function setApproval(){
			if (confirm("<spring:message code='email.appr.pending.approve.confirm' />")) {
				showProgress();
				var allHandsFlag = new URLSearchParams(window.location.search).get("type");
				var pUrl;
				if (allHandsFlag == "allHands") {
					pUrl = "/admin/ezEmail/appr/allHands/setApproval.do";
				} else if (allHandsFlag == "appr") {
					pUrl = "/ezEmail/appr/setApproval.do";
				}
				$.ajax({
					type	: "POST",
					contentType	: "application/json",
					data	: JSON.stringify({hrefArray: [g_encryptedUrl]}),
					url		: pUrl,
					async	: true,
					success	: function(result) {
						hideProgress();
						if ("OK" == result) {
							alert("<spring:message code='email.appr.pending.approve.complete' />");
						} else if ("DONE" == result) {
							alert("<spring:message code='email.appr.pending.done' />");
						} else {
							alert("<spring:message code='ezEmail.ls013' />");
						}
						try{
							window.opener.reloadPage();
						} catch (e) { console.log(e);
						} finally { window.close();
						}
					},
					error	: function(error) {
						console.log(error);
						alert("<spring:message code='ezEmail.ls013' />");
						try{
							window.opener.reloadPage();
						} catch (e) { console.log(e);
						} finally { window.close();
						}
					}
				});
			}
		}
		var appr_reject_arg = new Object();
		function setReject() {
			appr_reject_arg.complete = setRejectAction;
			GetOpenWindow("/ezEmail/appr/setReject.do", "setReject", 500, 275, "no");
		}

		function setRejectAction(memo) {
			showProgress();
			var allHandsFlag = new URLSearchParams(window.location.search).get("type");
			var pUrl;
			if (allHandsFlag == "allHands") {
				pUrl = "/admin/ezEmail/appr/allHands/setRejectAction.do";
			} else if (allHandsFlag == "appr") {
				pUrl = "/ezEmail/appr/setRejectAction.do";
			}
			$.ajax({
				type	: "POST",
				contentType	: "application/json",
				data	: JSON.stringify({hrefArray: [g_encryptedUrl], memo: memo}),
				url		: pUrl,
				async	: true,
				success	: function(result) {
					hideProgress();
					if ("OK" == result) {
						alert("<spring:message code='email.appr.pending.reject.complete' />");
					} else if ("DONE" == result) {
						alert("<spring:message code='email.appr.pending.done' />");
					} else {
						alert("<spring:message code='ezEmail.ls013' />");
					}
					try{
						window.opener.reloadPage();
					} catch (e) { console.log(e);
					} finally { window.close();
					}
				},
				error	: function(error) {
					console.log(error);
					alert("<spring:message code='ezEmail.ls013' />");
					try{
						window.opener.reloadPage();
					} catch (e) { console.log(e);
					} finally { window.close();
					}
				}
			});
		}
		
		function showProgress() {
			document.getElementById("progressPanel").style.display = "";
			document.getElementById("loadingLayer").style.display = "";
		}

		function hideProgress() {
			document.getElementById("progressPanel").style.display = "none";
			document.getElementById("loadingLayer").style.display = "none";
		}
    </script>
</body>
</html>
