<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>

<!DOCTYPE html>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<%-- <link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/jquery.scrollbar.css')}">
		<jsp:include page="/WEB-INF/jsp/bizmeka/defaultStyleSheet.jsp" />
		<link rel="stylesheet" href="${util.addVer('/css/toastr.css')}"> --%>
		<style>
			${mailWritePreview ? ".write_preview_hide" : ".write_preview_show"} {
				display: none;
			}

			@media print {
				body { overflow: visible !important; }
				.print_hide { display: none !important; }
				.print_show { display: block; }
				.scroll-wrapper { height: 100%; }
			}
			#tag_view > span + img { width: 11px; height: 11px; cursor: pointer; margin: 0 7px 0 4px; }
		</style>
		<link rel="stylesheet" href="${util.addVer('/css/print.min.css')}">
	</head>

	<body id="parentBody" onload="window_onload()" style="overflow:hidden;">
		<div style="height: 100%; display: flex; flex-direction: column;">
			<c:if test="${not isLoadedIframe}">
				<div class="mainmenu_btn write_preview_hide print_hide">
					<ul class="mainmenu_btnUL">
						<li class="rightbtn btn_setup nobg">
							<div class="icon_box">
								<a href="javascript:void(0);" class="icon" onclick="window.close();"><span class="newSubicon newSubicon003"></span></a>
							</div>
						</li>
					</ul>
				</div>
			</c:if>

			<div class="mail_read_wrap read_view" style="padding-bottom: 0; border-bottom: none;">
				<ul>
					<li>
						<div class="mail_readTitlebox">
							<div class="mail_readTitle" title="${subject}">${subject}<c:if test="${empty subject}"><br></c:if></div>
						</div>
					</li>
					<li>
						<dl>
							<dt>
								<div class="img">
									<div class="profile-img">
										<div class="photo-img s-60"><img id="preHSenderImage" src="/images/kr/main/profile.png"></div>
									</div>
								</div>
								<div class="icon_box small newsend print_hide"><a href="javascript:void(0);" class="icon reference newsend on" data-collapse=".address-container"></a></div>
								<spring:message code="ezEmail.t161" />
							</dt>
							<dd>
								<span class="name">
									<span id="MsgToPut" title="${fromEmail}" onclick="show_personinfo('${fromEmail}')">${fromStr}</span>
									<span id="LabelSenderInfo"></span>
								</span>
							</dd>
						</dl>
					</li>
					<li>
						<dl class="address-container print_show">
							<dt><spring:message code="ezEmail.t66" /></dt>
							<dd>
								<div class="recipient_list">
									<c:if test="${not empty recipientToList}">
										<span class="name" title="<e:forHtmlAttribute value="${recipientToList[0].address}" />" onclick="show_personinfo('${recipientToList[0].address}')"><c:out value="${recipientToList[0].personal}" /></span><span class="symbol"></span>
										<c:if test="${recipientToList.size() > 1}">
											<span>&nbsp;(<spring:message code='ezEmail.t10000' /> ${recipientToList.size()}<spring:message code='ezEmail.t10001' />)</span>
											<div class="icon_box small"><a href="javascript:void(0);" class="icon reference on" data-collapse="#MsgToGotHidden"></a></div>
											<div id="MsgToGotHidden" class="ToHiddenList">
												<%--${toHiddenStr}--%>
												<c:forEach var="to" items="${recipientToList}">
													<span class="name" title="<e:forHtmlAttribute value="${to.address}" />" onclick="show_personinfo('${to.address}')"><c:out value="${to.personal}" /></span><span class="symbol">;</span>
												</c:forEach>
											</div>
										</c:if>
									</c:if>
								</div>
								<div class="day_mark">
									<span class="day"><span>${dateStr}</span></span>
								</div>
							</dd>
						</dl>
					</li>
					<c:if test="${pIsCCFg != 'N'}">
						<li>
							<dl class="address-container print_show">
								<dt><spring:message code="ezEmail.t555" /></dt>
								<dd>
									<div class="recipient_list">
										<c:if test="${not empty recipientCcList}">
											<span class="name" title="<e:forHtmlAttribute value="${recipientCcList[0].address}" />" onclick="show_personinfo('${recipientCcList[0].address}')"><c:out value="${recipientCcList[0].personal}" /></span><span class="symbol"></span>
											<c:if test="${recipientCcList.size() > 1}">
												<span>&nbsp;(<spring:message code='ezEmail.t10000' /> ${recipientCcList.size()}<spring:message code='ezEmail.t10001' />)</span>
												<div class="icon_box small print_hide"><a href="javascript:void(0);" class="icon reference on" data-collapse="#MsgCCGotHidden"></a></div>
												<div id="MsgCCGotHidden" class="ToHiddenList">
													<c:forEach var="cc" items="${recipientCcList}">
														<span class="name" title="<e:forHtmlAttribute value="${cc.address}" />" onclick="show_personinfo('${cc.address}')"><c:out value="${cc.personal}" /></span><span class="symbol">;</span>
													</c:forEach>
												</div>
											</c:if>
										</c:if>
									</div>
								</dd>
							</dl>
						</li>
					</c:if>
				</ul>
			</div>
			<!-- 메일 컨텐츠 -->
			<iframe style="overflow:hidden; width:100%; flex: 1 1;" src="mailReadContent.do?iptFolderPath=<e:forHtmlAttribute value="${folderPath}" />&iptURL=<e:forHtmlAttribute value="${uid}" />&iSecurity=&<c:if test="${not empty shareId}">shareId=<e:forHtmlAttribute value="${shareId}" /></c:if>" id="message" name="message"></iframe>
		</div>
		<form name="form1" action="mailReadContent.do" method="get" target="message" >
			<input type="hidden" id="iptFolderPath"  name="iptFolderPath" value="">
		    <input type="hidden" id="iptURL"  name="iptURL" value="">
		    <input type="hidden" id="iSecurity"  name="iSecurity" value="">
		    <c:if test="${shareId != null && shareId != ''}">
		    	<input type="hidden" id="shareId"  name="shareId" value="${shareId}">
		    </c:if>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<script src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script src="${util.addVer('/js/input-util.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
		<script src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.js')}"></script>
		<script src="${util.addVer('/js/Common.js')}"></script>
		<script src="${util.addVer('/js/print.min.js')}"></script>
		<%-- <script src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script src="${util.addVer('/js/input-util.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script src="${util.addVer('/js/jquery/toastr/toastr.js')}"></script>
		<script src="${util.addVer('/js/ui.js')}"></script>
		<script src="${util.addVer('/js/ezEmail/js_cross/reademail.new.js')}"></script>
		<script src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.new.js')}"></script>
		<script src="${util.addVer('/js/Common.js')}"></script>
		<script src="${util.addVer('/js/print.min.js')}"></script> --%>
		<script type="text/javascript">
			var g_paramURL = "${url}";
			var g_userLang = "${ userinfo.lang }";
			var g_date = "${_date}";
			var g_useremail = "${ userinfo.Email }";
			var g_MailSpamURL = "${ _MailSpamURL }";
			var IsSecurityMail = "Normal";
			var IsAttach = "${pIsAttach}";
			var pUse_Editor = "${Use_Editor}";
			var isSecureMail = "${isSecureMail}";
			var dotNetIntegration = "${dotNetIntegration}";
			var shareId = "${shareId}";
			var g_uid = "${uid}";
			var senderProfileImageName = "<c:out value='${senderProfileImageName}' />"
			var	g_notiSSO = "0";

			window.onresize = window_onresize;

			function window_onload()
			{
				window_onresize();

				// 2024-02-26 이사라 - 프로필 이미지 처리
				if (senderProfileImageName !== "") {
                    document.getElementById("preHSenderImage").src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + senderProfileImageName;
                } else {
                    document.getElementById("preHSenderImage").src = "/images/kr/main/profile.png";
                }
			}

			function window_onresize() {
                if (document.getElementById('message').style.width != document.documentElement.clientWidth - 20)
                    if (document.body.clientWidth - 20 > 0)
                        document.getElementById('message').style.width = document.documentElement.clientWidth - 20;

                var resizeHeight;
                if("${pIsCCFg}"!="N") {
					resizeHeight = document.documentElement.clientHeight - 220;
                } else {
					resizeHeight = document.documentElement.clientHeight - 190;
                }

                document.getElementById("message").style.height = resizeHeight + "px";
			}

			// 승인메일이 필요한 것은 아니지만, mailReadContent.jsp는 일반메일과 공동으로 사용하기 때문에 추가
			function mailPrevSentDateChk() {
				if (sentDateMsg != "") { // 전달 및 회신시 보낸시각
					var sentDateHeight = $(".sentDateStr").innerHeight();
					sentDateHeight = (Math.ceil(sentDateHeight/10) * 10);

					var messageH = $("#message").height();
					$("#message").height(messageH - sentDateHeight);
				}
			}

			function OnBtnClose() {
				if (g_notiSSO == "1")
					window.location = "btn:action|close";
				else
					window.close();
			}

			function SecurityFG() {
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

			function ShowHiddenTo(obj) {
				var currHeight = $(".content tbody tr:nth-child(2)").outerHeight();
				var heightForChange = "";

				if(MsgToGotHidden.style.display=="none") {
					MsgToGotHidden.style.display = "";
					obj.src ="/images/cllps.gif";
					heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
					$("#message").outerHeight($("#message").outerHeight() - heightForChange );
				} else {
					MsgToGotHidden.style.display = "none";
					obj.src ="/images/expnd.gif";
					heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
					$("#message").outerHeight($("#message").outerHeight() - heightForChange );
				}
			}

			function ShowHiddenCc(obj) {
				var currHeight = $(".content tbody tr:nth-child(3)").outerHeight();
				var heightForChange = "";
				if(MsgCCGotHidden.style.display=="none") {
					MsgCCGotHidden.style.display = "";
					obj.src ="/images/cllps.gif";
					heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
					$("#message").outerHeight($("#message").outerHeight() - heightForChange );
				} else {
					MsgCCGotHidden.style.display = "none";
					obj.src ="/images/expnd.gif";
					heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
					$("#message").outerHeight($("#message").outerHeight() - heightForChange );
				}
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
				var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top 
							+ ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=no";
				
				return feature;
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

		</script>
	</body>
</html>
