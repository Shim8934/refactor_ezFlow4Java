<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t660' /></title>
	    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	    <link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery.ui.all.css')}" type="text/css" />
		<c:if test="${useFromAddress == 'YES'}">
		<style>
			.selectbox { position: relative; width: 100%; /* 너비설정 */ border: 0px; /* 테두리 설정 */ z-index: 1; } 
			.selectbox:before { /* 화살표 대체 */ content: ""; position: absolute; top: 50%; right: 15px; width: 0; height: 0; margin-top: -1px; border-left: 5px solid transparent; border-right: 5px solid transparent; border-top: 5px solid #333; } 
			.selectbox label { position: absolute; top: 1px; /* 위치정렬 */ left: 5px; /* 위치정렬 */ color: #999; z-index: -1; /* IE8에서 label이 위치한 곳이 클릭되지 않는 것 해결 */ } 
			.selectbox select { width: 100%; height: auto; /* 높이 초기화 */ line-height: normal; /* line-height 초기화 */ font-family: inherit; /* 폰트 상속 */ border: 0; opacity: 0; /* 숨기기 */ filter:alpha(opacity=0); /* IE8 숨기기 */ -webkit-appearance: none; /* 네이티브 외형 감추기 */ -moz-appearance: none; appearance: none; }
			.ui-autocomplete { height: 200px; max-height: 200px; overflow-y: auto; overflow-x: hidden; padding:0px;}
			#AutoCompleteResults .ui-state-focus { background: #f0f6ff;  border: none }
		</style>
		</c:if>
		<!-- 수신인란 height 작업 -->
		<style>
			.viewtxtScroller {
				min-height: 16px;
				max-height: 16px;
				overflow-y: auto;
				margin-bottom: 3px;
			}
			.viewtxtWrapper {
				display: table;
				height: 100%;
			}
			.viewtxt {
				display: table-cell;
				vertical-align: middle;
			}
			.viewtxt > span {
				display: inline-block;
				padding-right: 5px;
			}
			.viewtxt > span > span {
				font-size: 12px;
			}	
			
			#menu > ul:nth-child(2) > li {
				margin: 0 2px !important;
			}
			.ui-autocomplete { height: 200px; max-height: 200px; overflow-y: auto; overflow-x: hidden; padding : 0px}
			#AutoCompleteResults .ui-state-focus { background: #f0f6ff;  border: none }
		</style>
		
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.9.1.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/AttachMain_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/AttachItem_CK.js')}"></script>
        <c:if test="${isCrossBrowser != true}">
        	<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
        </c:if>
	    <script type="text/javascript">
	    var g_szAuthor = "";
	    var g_szExchange = "exchange";
	    var g_cmd = "${_cmd}";
	    var Org_cmd = "${_cmd}";
	    var g_servername = "${serverName}";
	    var g_myname = "${userInfo.displayName}";
	    var g_myemail = "${userInfo.mail}";
	    var g_from = "${userInfo.mail}";
	    var g_szUserID = "${userInfo.mailNickName}";
	    var g_companyID = "${userInfo.physicalDeliveryOfficeName}";
	    var g_senderinfo = "${userInfo.company}" + ", " + "${userInfo.description}" + ", " + "${userInfo.title}";
	    var tid = "${tenantId}";
	    var g_eImportance = "${importance}";
	    var g_bodyType = "${bodyType}";
	    var g_replySendTime = "${replySendTime}";
	    var g_replyReadTime = "${replyReadTime}";
	    var g_delaySendDate = "${delaySendDate}";
	    var g_ePostType = "${postType}";
	    var g_url = "${url}";
	    var g_unread = "${unread}";
	    var m_rgParams4PostOption = new Array();
	    var g_bDirty = false;
	    var m_addrBook = null;
	    var g_bSended = false;
	    var objMHT;
	    var g_charset = "utf-8";
	    var g_encoding = "BASE64";
	    var g_font = "<spring:message code='ezEmail.t409' />";
	    var g_showdisplay = "";
	    var g_simplemimeencoding = "7bit";
	    var g_simplemime = "";
	    var g_xmldoc = createXmlDom();
	    var useMultiLangMail = "${useMultiLangMail}";
	    var g_isFormat = false;
	    var g_DisplayNamePrintable = "${displayNamePrintable}";
	    var g_showEnglishDisplay = "";
	    var g_charsetCheck = "${charsetCheck}";
	    var g_ReSendFlag = "${reSendFlag}";
	    var BigSizeAttachMBSize = "${bigSizeMailAttachLimit}";
	    var totBigSizeAttachMBSize = "${totBigSizeMailAttachLimit}";
	    var totSizeAttachMBSize = "${mailAttachLimit}";
	    var BigSizeAttachSize = BigSizeAttachMBSize * 1024 * 1024;
	    var totBigSizeAttachSize = totBigSizeAttachMBSize * 1024 * 1024;
	    var totSizeAttachSize = totSizeAttachMBSize * 1024 * 1024;
	    var FBigSizeAttachSize = parseInt(BigSizeAttachSize);
	    var FtotBigSizeAttachSize = parseInt(totBigSizeAttachSize);
	    var FtotSizeAttachSize = parseInt(totSizeAttachSize);
	    var BigSizeMailAttachDelDay = "${bigSizeMailAttachDelDate}";
	    var charsetControlFlag = "${userLang}";
	    var userTimezone = "${userTimeset}";
	    var isPrimary = "${userPrimary}";
	    var initFlag = false;
	    var gg_cmd = "${cmdOwn}";
	    var gg_url = "${urlOwn}";        
	    var g_newid = "${newWindowId}";
	    var FileUploadtype = "${fileUploadType}";
	    var iseachMail = "${isEach}";
	    var individualmailuser = "${individualMailUser}";
	    var pSecurity = "${pSecurity}";
	    var docHref = "${docHref}";
	    var isReserve = "NO";
	    var pCDOMessageId = "";
	    var Add_xmlhttp = "";
	    var mailsel = "${mailSignSel}";
	    var mailpath = "";
	    var fileSize_add = "";
	    var fileName_add = "";
	    var fileType_add = "";
	    var bigtrue = 0;
	    var tmpXML = "";
	    var tempUrl = "";
	    var filedate = "${stateName}";
	    var gubunlist = "1";
	    var tempvalue = "0";
	    var _pBigAttachDownloadDay = "${pBigAttachDownloadDay}";
	    var _pBigAttachDownloadPeriod = "${pBigAttachDownloadPeriod}";
	    var ua = navigator.userAgent;
	    var InnerDomain = "${mailInnerDomain}";
	    var inMailColor = "${inMailColor}";
	    var outMailColor = "${outMailColor}";
	    var pUse_Editor = "${useEditor}";
	    var pDocID = "${docID}";
	    var uploadCommonPath = "${uploadCommonPath}";
	    var uploadCommunityPath = "${uploadCommunityPath}";
	    var defaultFontAndSize = "${defaultFontAndSize}";
	    var isCrossBrowser = "${isCrossBrowser}";
	    var useSecureMail = "${useSecureMail}";
	    var isSecureMail = "${isSecureMail}";
	    var securePassword = "";
	    var secureReadCount = "0";
	    var secureReadDate = "";
	    var useMailWriteSenderClick = "${useMailWriteSenderClick}"; // 수아 수정
	    var folderPath = "${drafts}";
	    var multipartFirstIdx = "${multipartFirstIdx}";

	    //업무일지 아이디
	    var journalId = "${journalId}";
	    //근태관리 아이디
	    var attitudeId = "${attitudeId}";
	    var attitudeIncludeMe = false; 
	    var searchStartDate = "${searchStartDate}";
	    var searchEndDate = "${searchEndDate}";
	    
	    // ezPMS 프로젝트 아이디
	    var ezPMSProjectId = "${ezPMSProjectId}";
	    // ezPMS 게시판 아이디
	    var ezPMSBoardId = "${ezPMSBoardId}";
	    var ezPMSRoleId = "${pmsRoleId}";
	    var ezPMSType = "${pmsType}";
	    var ezPMSToUserId = "${pmsToUserId}";
	    var ezPMSUserIdType = "${pmsUserIdType}";
	    var ezPMSTaskId = "${pmsTaskId}";
	    
	    window.onload = function () {
	        if (!CrossYN()) {
	            document.all.EzHTTPTrans.SetBigLang = "${userLang}" == "1" ? 1 : 0;
	            EzHTTPTrans.UseDbCl = true;
	            
	            var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	            ezUtil.UseUTF8 = true;	            
	        }
	
	        if (g_unread == "1") {
	            try {
	                window.opener.document.Script.refreshUnreadCount()
	            } catch (e) { }
	        }
	        
	        if (pSecurity == "Security") {
	            pSecurity = "3";
	        }
	        if (typeof (document.getElementById("xmpSubject").outerText) != "undefined" && document.getElementById("xmpSubject").outerText != "")
	            document.getElementById("eSubject").value = document.getElementById("xmpSubject").outerText;
	
	        importantSelect.selectedIndex = g_eImportance;
	        m_rgParams4PostOption["important"] = g_eImportance;
	        m_rgParams4PostOption["postType"] = g_ePostType;
	        m_rgParams4PostOption["replySendTime"] = g_replySendTime;
	        m_rgParams4PostOption["replyReadTime"] = g_replyReadTime;
	        m_rgParams4PostOption["delaySendDate"] = g_delaySendDate;
	        m_rgParams4PostOption["showMsgCC"] = true;
	        m_rgParams4PostOption["showMsgBCC"] = true;
	        m_rgParams4PostOption["tagMsgCC"] = MsgCC_TR;
	        m_rgParams4PostOption["tagMsgCCu"] = MsgCC_TRu;
	        m_rgParams4PostOption["tagMsgBCC"] = MsgBCC_TR;
	        m_rgParams4PostOption["tagMsgBCCu"] = MsgBCC_TRu;
	        m_rgParams4PostOption["bodyType"] = g_bodyType;
	        m_rgParams4PostOption["EachMail"] = iseachMail;
	        m_rgParams4PostOption["SecurityMail"] = pSecurity;
	        
			var moduleType = "${moduleType}";
	        
	        if (moduleType == "attitudeAbsented") {
	        	getAttitudeAbsentedList("distinct");
	        } else if (moduleType == "ezPMS") {
	        	getPMSMemberList(ezPMSType);
	        }
	        
	        if (xmpTo.innerHTML != "") {
	        	var moduleType = "<c:out value='${moduleType}'/>";

	        	if (moduleType == "attitudeAbsented") {
		        	getAttitudeAbsentedList("distinct");
		        } else if (moduleType == "ezPMS") {
		        	getPMSMemberList(ezPMSType);
		        }
	        	
	        	if (moduleType && moduleType == "poll") {
	        		var pollSendType = "<c:out value='${pollSendType}'/>";       		
		            var addrArr = getEmailAddressList2(xmpTo.innerHTML, pollSendType);
		            addReceiverFromList(0, addrArr);
	        	} else {
		            var splitAddr = getEmailAddressList(xmpTo.innerHTML);
		            addReceiverFromList(0, splitAddr);
	        	}
	        }
	        
	        if (xmpCc.innerHTML != "") {
	            splitAddr = getEmailAddressList(xmpCc.innerHTML);
	            addReceiverFromList(1, splitAddr);
	        }
	        
	        if (xmpBcc.innerHTML != "") {
	            splitAddr = getEmailAddressList(xmpBcc.innerHTML);
	            addReceiverFromList(2, splitAddr);
	            $('#BccViewer').find('img').attr('src', GroupminImg);
			    $('#BccViewer').attr("status","on");
			    document.getElementById("MsgBCC_TRu").style.display = "";
			    document.getElementById("MsgBCC_TR").style.display = "";
	        }
	        
	        Subject_ReApply();  
            window.onresize();
	        g_bDirty = false;
	        
	        if (g_charsetCheck == "0") {
	            if (confirm("<spring:message code='ezEmail.t665' />")) {
	                location.href = location.href + "&attach=1";
	            }
	        }        
	        
	        if ((g_cmd == "FORWARD" || g_cmd == "EDIT" || g_ReSendFlag == "Y") && document.getElementById("AttachXmlList").innerHTML.trim() != "") {
	            AddAttachFileInfoXmlParsing(document.getElementById("AttachXmlList").innerHTML);
	        }
	        
	        SelMailSign.value = "${mailSignSel}";
	        
			Simple_Choice();		
			var pSaveTime = "${pAutoSaveTime}";
			var pSaveInterval = parseInt(pSaveTime) * 1000;
			if (pSaveInterval > 0)
			    window.setInterval("Mail_AutoSave()", pSaveInterval);
			
			var ua = navigator.userAgent;
			if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			    document.getElementById("file1").multiple = false;
			}
			
			if (document.getElementById("eSubject").value == "") {
			    document.getElementById("MsgTo").focus();
			}
			
			if (m_rgParams4PostOption["bodyType"] == "1") {
				document.getElementById("tbContentElement").style.display = "none";
				document.getElementById("plainTextArea").style.display = "";
				document.getElementById("bodyType").options[1].selected = true;
	        	document.getElementById("SelMailSign").disabled = true;
			}
			
			<c:if test="${overQuota == true}">
				// 전달의 경우 쿼터 초과 시 팝업창띄움
				alert(strLang241);
            </c:if>
            
            <c:if test="${useFromAddress == 'YES'}">
	            var selectTarget = $('.selectbox select'); 
	            selectTarget.change(function(){ 
	            	var select_name = $(this).children('option:selected').text(); 
	            	$(this).siblings('label').text(select_name); 
	            });
            </c:if>
			
            // 수신인란 스크롤 UX 개선
            
            // viewtxtScroll elements (수신, 참조, 숨은참조 총 3개)
            var viewtxtScrollers = $(".viewtxtScroller");
            
            // viewtxtScroll 각각의 element에 이전 스크롤 위치를 저장
            viewtxtScrollers.each(function(index) {
            	$(this)[0].previousScrollPos = $(this).scrollTop();
            });
            
            // jquery scrollTop API를 이용한 스크롱이면 true, 아니면 false
            var scrollTopFlag = false;
            // 스크롤 단위
            var scrollFixedSpeed = 16;
            
            viewtxtScrollers.on("scroll", function(event) {
            	// 이벤트 발생 주체
            	var jqueryElement = $(this);
            	var domElement = jqueryElement[0];
            	// 이벤트 밸생 후 현재 스크롤 위치
            	var currentScrollPos = jqueryElement.scrollTop();
            	
            	if(scrollTopFlag) {
            		return;
            	}
            	
            	// 이벤트 발생 전 스크롤 위치
            	var previousScrollPos = domElement.previousScrollPos;
            	// 스크롤 거리
            	var posDistance = currentScrollPos - previousScrollPos;
            	
            	event.preventDefault();
            	
            	// 스크롤 거리가 0이면 이벤트 무시
            	if(posDistance == 0) {
            		return;
            	}
            	
            	// 다운스크롤, 업스크롤 여부
            	var isDown = posDistance > 0;
            	
            	// jquery scrollTop API를 쓰기 위해 플래그 활성화
            	scrollTopFlag = true;
            	
            	// 항상 고정 위치를 가지고 스크롤 하기 위함
            	var fixedScrollPos = previousScrollPos + scrollFixedSpeed * (isDown ? 1 : -1);
            	// 고정 스크롤 위치로 jquery scrollTop 발생
            	jqueryElement.scrollTop(fixedScrollPos);
            	scrollTopFlag = false;
            	
            	// 현재 스크롤 위치를 저장
            	currentScrollPos = jqueryElement.scrollTop();
            	domElement.previousScrollPos = currentScrollPos;
            });
            
            if (attitudeIncludeMe) {
 	         	document.getElementById('toMe').checked = 'checked';
    	        MailToMe_Onclick();
            }
            
         // 쓰기창에서 수신인 자동완성 기능 사용 유무
            <c:if test="${useMailAddrAutoComplete != 'YES'}">
            	$( "#MsgTo" ).autocomplete("disable");
            	$( "#MsgCC" ).autocomplete("disable");
            	$( "#MsgBCC" ).autocomplete("disable");
        	</c:if>
            
		}
	    
		var isAutoSave = false;
		var MailStatus = "NO";
		function Mail_AutoSave() {
		    if (MailStatus == "NO") {
		        isAutoSave = true;
		        Save_onClick("tempsave");
		    }
		}
	    window.onresize = function () {
        	if (isCrossBrowser == 'true') {
        		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 240 + "PX";
        	} else {
        		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 160 + "PX";
        	}
        	
        	// resize시 autoComplete창이 계속 유지되어서 display 처리
        	$(".ui-autocomplete").css('display', 'none');
	    }
	    function KeEventControl(obj) {
	        useragt = navigator.userAgent.toUpperCase();
	        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
	        {
	            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
	            if (parseInt(useragt) > 5) {
	                return;
	            }
	        }
	        obj.onkeydown = function () {
	            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
	                return false;
	            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
	                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
	                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
	                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
	                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
	                return false;
	        };
	    }
	    
	    function JSleep(sTime) {
	        var xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("GET", "remote/userSleep.aspx?time=" + sTime + "&newid=" + g_newid, false);
	        xmlhttp.send();
	        xmlhttp = null;
	    }
	    var isClosedSave = false;
	    window.onbeforeunload = function () {
	        var retVal = "";
	        if (retVal != "0" && g_url != "" && ("${folderPath}" != "Draft" && g_cmd != "EDIT")) {
	            if (!isDelted) {
	                delDrafts();
	            }
	        } else {
	        	delAttachListFile(filedate);
	        } 
	    }
	    var mail_message_cross_dialogArguments = new Array();
	    function window_close() {
	        var g_filelist = "";
	        if ((g_bDirty 
	        		|| (m_rgParams4PostOption["bodyType"] == "0" && (g_originalHTML != message.GetEditorContent())) 
	        		|| (m_rgParams4PostOption["bodyType"] == "1" && (g_originalPlainText != document.getElementById("plainTextArea").value))
	        		|| g_filelist != "") && g_saveHttp == null) {
	            if (!CrossYN()) {
	                EzHTTPTrans.style.display = "none";
	            }    
	            
	            mail_message_cross_dialogArguments[1] = window_close_Complete;
	            var pUrl = "/ezEmail/mailConfirmDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezEmail.t666' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezEmail.t667' />") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezEmail.t671' />");
	            DivPopUpShow(330, 205, pUrl);	            
	        } else {
	            window.close();
	        }
	    }
	    function window_close_Complete(retVal) {
	        DivPopUpHidden();
	        
	        if (retVal == "0") {
	            isClosedSave = true;
	            Save_onClick("tempsave");
	            window.close();
	        }
	        
	        g_bDirty = false;
	        
	        if (retVal == "1" && g_url != "" && ("${folderPath}" != "Draft" && g_cmd != "EDIT")) {
	            delDrafts();
	        }
	        
	        if (retVal != "2")
	            window.close();
	    }
	    var isDelted = false;
	    function delDrafts() {
	        var xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("GET", "/ezEmail/delDrafts.do?itemid=" + encodeURIComponent(g_url) + "&delid=" + filedate, false);
	        xmlhttp.send();
	        xmlhttp = null;
	        isDelted = true;
	    }
	    function delAttachListFile(filedate) {
	    	var xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("GET", "/ezEmail/delAttachListFile.do?&delid=" + filedate, false);
	        xmlhttp.send();
	        xmlhttp = null;
	        isDelted = true;
	    }
	    var PrintEvent = false;
	    function Print_onClick() {
	        PrintEvent = true;
	        document.getElementById("test").innerHTML = message.GetEditorContent();
	        var obj = document.getElementById("frmPrint");
	        var objDoc = obj.contentWindow || obj.contentDocument;
	        objDoc.btnPrint_onClick();
	    }
	    var mail_formatlist_cross_dialogArguments = new Array();
	    function LoadFormat_onClick() {
	        mail_formatlist_cross_dialogArguments[1] = LoadFormat_onClick_Complete;
	        mail_formatlist_cross_dialogArguments[2] = DivPopUpHidden;
	        DivPopUpShow(460, 467, "mail_FormatList_cross.aspx");
	    }
	    function LoadFormat_onClick_Complete(strFileName) {
	        DivPopUpHidden();
	        if (typeof (strFileName) == "undefined")
	            return;
	        var fullPath = "/Email_Formats/" + strFileName;
	        var xmpMailSign = "";
	        try {
	            xmpMailSign = message.CKEDITOR.instances.editor1.document.$.getElementById('MailSign').outerHTML;
	        } catch (e) {
	        }
	        message.SetEditorContentURL_Format(fullPath);
	        message.SetEditorContent(message.CKEDITOR.instances.editor1.document.$.body.innerHTML + xmpMailSign);
	    }
	    function ReplaceText(orgStr, findStr, replaceStr) {
	        var re = new RegExp(findStr, "gi");
	        return (orgStr.replace(re, replaceStr));
	    }
	    function RenderFontStyleSet(BodyHtml) {
	        return "<span><P>&nbsp;</P><P>&nbsp;</P>" + BodyHtml + "</span>"
	    }
	    function Rebody() {
	    	if (gg_cmd == "RESEND" && document.getElementById("bodyValue").innerHTML != "") { //재전송 시
	    		document.getElementById("bodyValue").innerHTML = document.getElementById("bodyValue").innerHTML.replace("id=\"MailSignSent\"", "id=\"MailSign\"");
	    		var indexSignValue = document.getElementById("bodyValue").innerHTML.indexOf("id=\"MailSign\"");
	            if (indexSignValue == -1) {
		    		switch (mailsel) {
		                case "0": message.SetEditorContent(document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'></DIV>");
		                    break;
		                case "1": message.SetEditorContent(document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>");
		                    tempvalue = "1";
		                    break;
		                case "2": message.SetEditorContent(document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>");
		                    tempvalue = "1";
		                    break;
		                case "3": message.SetEditorContent(document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>");
		                    tempvalue = "1";
		                    break;
		            }
	            } else {
	            	switch (mailsel) {
		                case "0": message.SetEditorContent(document.getElementById("bodyValue").innerHTML);
		                    break;
		                case "1": message.SetEditorContent(document.getElementById("bodyValue").innerHTML);
		                    tempvalue = "1";
		                    break;
		                case "2": message.SetEditorContent(document.getElementById("bodyValue").innerHTML);
		                    tempvalue = "1";
		                    break;
		                case "3": message.SetEditorContent(document.getElementById("bodyValue").innerHTML);
		                    tempvalue = "1";
		                    break;
	            	}
	            }
	    	}
	    	else if (document.getElementById("bodyValue").innerHTML != "") { //회신,전달 시
	    	    // ksc5601 메일 본문을 ms949로 해석한 경우 일부 메일에서 회신 혹은 전달 시 � 문자들이 끝에 
	    	    // 추가되는 현상이 발생하여 제거하는 코드 추가함
	    	    var bodyInnerHTML = document.getElementById("bodyValue").innerHTML.replace(/�/gi, "");
	    	
	            switch (mailsel) {
	                case "0": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'></DIV>" + bodyInnerHTML);
	                    break;
	                case "1": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + bodyInnerHTML);
	                    tempvalue = "1";
	                    break;
	                case "2": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + bodyInnerHTML);
	                    tempvalue = "1";
	                    break;
	                case "3": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + bodyInnerHTML);
	                    tempvalue = "1";
	                    break;
	            }
	        }
	        else if (document.getElementById("tempbody").innerHTML != "") { //임시보관함에서 메일 더블클릭
				var indexSignValue = document.getElementById("tempbody").innerHTML.indexOf("id=\"MailSign\"");
	            if (indexSignValue == -1) {
	            	switch (mailsel) {
			            case "0": message.SetEditorContent(document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'></DIV>");
			                break;
			            case "1": message.SetEditorContent(document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>");
			                tempvalue = "1";
			                break;
			            case "2": message.SetEditorContent(document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>");
			                tempvalue = "1";
			                break;
			            case "3": message.SetEditorContent(document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>");
			                tempvalue = "1";
			                break;
		            }
	            } else {
	            	switch (mailsel) {
			            case "0": message.SetEditorContent(document.getElementById("tempbody").innerHTML);
			                break;
			            case "1": message.SetEditorContent(document.getElementById("tempbody").innerHTML);
			                tempvalue = "1";
			                break;
			            case "2": message.SetEditorContent(document.getElementById("tempbody").innerHTML);
			                tempvalue = "1";
			                break;
			            case "3": message.SetEditorContent(document.getElementById("tempbody").innerHTML);
			                tempvalue = "1";
			                break;
		            }
	            }
	            
	        }
	        else { //새메일쓰기
	            switch (mailsel) {
	                case "0": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'></DIV>");
	                    break;
	                case "1": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML);
	                	tempvalue = "1";
		                break;
		            case "2": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML);
		                tempvalue = "1";
		                break;
		            case "3": message.SetEditorContent("<P " + defaultFontAndSize + ">&nbsp;</P><P " + defaultFontAndSize + ">&nbsp;</P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML);
		                tempvalue = "1";
		                break;
	            }
	
	        }
	    }
	
	    function MailSignSel() {
	        var sign = "";
	        var signcom = "";
        	var indexSignValue = message.GetEditorContent().indexOf("id=\"MailSign\"");
			var mailSignDiv = "<DIV id='MailSign'></DIV>";
	        mailSignDiv = editorPtagChk() + mailSignDiv;
	        
            if (indexSignValue == -1) {
                if (gg_cmd == "REPLY" || gg_cmd == "REPLYALL" || gg_cmd == "FORWARD") {
                    message.SetEditorContent(mailSignDiv + message.GetEditorContent());
                }
                else {
                    message.SetEditorContent(message.GetEditorContent() + mailSignDiv);
                }
            }
	        switch (SelMailSign.value) {
	            case "0":
	                sign = "";
	                signcom = "";
	                break;
	            case "1":
	                if (navigator.userAgent.indexOf('Firefox') != -1) {
	                    sign = document.getElementById("xmpMailSign1").innerHTML;
	                }
	                else {
	                    sign = document.getElementById("xmpMailSign1").innerText;
	                }
	                break;
	            case "2":
	                if (navigator.userAgent.indexOf('Firefox') != -1) {
	                    sign = document.getElementById("xmpMailSign2").innerHTML;
	                }
	                else {
	                    sign = document.getElementById("xmpMailSign2").innerText;
	                }
	                break;
	            case "3":
	                if (navigator.userAgent.indexOf('Firefox') != -1) {
	                    sign = document.getElementById("xmpMailSign3").innerHTML;
	                }
	                else {
	                    sign = document.getElementById("xmpMailSign3").innerText;
	                }
	                break;
	        }
	        message.EditorElementSetHtml("MailSign", sign);
	    }
	
	    function MailSignLoad() {
	        SelMailSign.value = "${mailSignSel}";
	        MailSignSel();
	    }
	
	    function setEachMail() {
	        if (chkeachmail.checked) {
	            iseachMail = "true";
	        }
	        else {
	            iseachMail = "false";
	        }
	
	        m_rgParams4PostOption["EachMail"] = iseachMail;
	    }
	
	    function new_Address() {
	        var type = "config";
	        var receiverData = new Array();
	        receiverData["window"] = this;
	        mail_newreceiverchoose_dialogArguments[0] = receiverData;
	        mail_newreceiverchoose_dialogArguments[1] = new_Address_Complete;
	        var OpenWin = window.open("/ezEmail/mailNewReceiverChoose.do?defaultwin=&type=" + type, "mail_foldermanage_Cross", GetOpenWindowfeature(970, 655));
	        try { OpenWin.focus(); } catch (e) { }
	    }
	
	    function new_Address_Complete() {
	        Simple_Choice();
	    }
	
	    function Simple_Choice() {
	        document.getElementById("SelectToAddress").innerHTML = "";
	        document.getElementById("SelectCcAddress").innerHTML = "";
	        document.getElementById("SelectBCCAddress").innerHTML = "";
	        newoption1 = new Option(strLang199, strLang199);
	        CCnewoption1 = new Option(strLang199, strLang199);
	        BCCnewoption1 = new Option(strLang199, strLang199);
	        document.getElementById("SelectToAddress").options[0] = newoption1;
	        document.getElementById("SelectToAddress").options[0].selected = true;
	        document.getElementById("SelectCcAddress").options[0] = CCnewoption1;
	        document.getElementById("SelectCcAddress").options[0].selected = true;
	        document.getElementById("SelectBCCAddress").options[0] = BCCnewoption1;
	        document.getElementById("SelectBCCAddress").options[0].selected = true;
	        Add_xmlhttp = createXMLHttpRequest();
	        Add_xmlhttp.open("Post", "/ezEmail/mailGetAddress.do", true);
	        Add_xmlhttp.onreadystatechange = Simple_Choice_complete;
	        Add_xmlhttp.send("");
	    }
	
	    function Simple_Choice_complete() {
	        try {
	            var gubunCount = 1;
	            if (Add_xmlhttp == null || Add_xmlhttp.readyState != 4)
	                return;
	            if (Add_xmlhttp.status >= 200 && Add_xmlhttp.status < 300) {
	                if (!CrossYN()) {
	                    var xmlDom = loadXMLString(Add_xmlhttp.responseText);
	                    var objNodes = xmlDom.selectNodes("NewDataSet/Table");
	                    for (var count = 0; count < objNodes.length; count++) {
	                        lastindex = document.all("SelectToAddress").length;
	                        newoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
	                        CCnewoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
	                        BCCnewoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
	                        document.getElementById("SelectToAddress").options[lastindex] = newoption;
	                        document.getElementById("SelectCcAddress").options[lastindex] = CCnewoption;
	                        document.getElementById("SelectBCCAddress").options[lastindex] = BCCnewoption;
	                    }
	                }
	                else if (CrossYN()) {
	                    var xmlDom = loadXMLString(Add_xmlhttp.responseText);
	                    var Nodeslength = xmlDom.childNodes.item(0).childElementCount;
	                    for (var count = 0; count < Nodeslength; count++) {
	                        //lastindex = document.all("SelectToAddress").length;
	                        lastindex = document.getElementById("SelectToAddress").childNodes.length;
	                        
                            newoption = new Option(xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent, xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(1).textContent);
                            CCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent, xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(1).textContent);
                            BCCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent, xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(1).textContent);

                            gubunCount = gubunCount + 2;
	                        document.getElementById("SelectToAddress").options[lastindex] = newoption;
	                        document.getElementById("SelectCcAddress").options[lastindex] = CCnewoption;
	                        document.getElementById("SelectBCCAddress").options[lastindex] = BCCnewoption;
	                    }
	                }
	            }
	        }
	        catch (e) {
	            alert(e.message);
	        }
	        Add_xmlhttp = null;
	    }
	
	    function simple_select(Type, obj) {
	        switch (Type) {
	            case "TO":
	                SimpleEmailAddress(SelectToAddress.value, MsgToGot, 0);
	                break;
	            case "CC":
	                SimpleEmailAddress(SelectCcAddress.value, MsgCCGot, 1);
	                break;
	            case "BCC":
	                SimpleEmailAddress(SelectBCCAddress.value, MsgBCCGot, 2);
	                break;
	            default:
	                break;
	        }
	        obj.item(0).selected = true;
	    }
	
	    function SimpleEmailAddress(formName, validDIV, iType) {
	        if (formName != "") {
	            var mailArr = String(formName).split(";");
	            var mailName = ReplaceText(mailArr[0], " ", "");
	            var pemail = ReplaceText(mailArr[1], " ", "");
	            var newElem;
	            newElem = PrepareMailTag(iType, "email", mailName, pemail, "");
	            var IsInsert = CheckMailReceiver(newElem);
	
	            if (!IsInsert) {
	                switch (iType) {
	                    case 0:
	                        MsgToGot.appendChild(newElem);
	                        break;
	
	                    case 1:
	                        MsgCCGot.appendChild(newElem);
	                        break;
	
	                    case 2:
	                        MsgBCCGot.appendChild(newElem);
	                        break;
	
	                }
	            }
	            formName = "";
	            g_bDirty = true;
	        }
	        return true;
	    }
	
	    function returnvalue(strXML) {
	        pAttachXml = loadXMLString(strXML);
	        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
	        for (i = 0; i < nodes.length; i++) {
	            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
	                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0)       //filesize
	                {
	                    alert(strLang89); return;
	                }
	            }
	            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
	                alert(strLang168 + AttachLimit + "MB" + strLang169);
	                return;
	            }
	            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
	                alert(strLang323);
	            }
	            else {
	                alert(filename + strLang85 + "\n\n" + result);
	            }
	        }
	        AttachFileInfo(strXML);
	    }
		
	    function FileUpdateAfter(strXML) {
	        
	    	tempXML = strXML;
	        pAttachXml = loadXMLString(strXML);
	        
	        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
	        var xmlDoc = createXmlDom();
	        var objNode;
	        var objRow;
	        var objRows;
	        var objRowRow;
	        
	        objNode = createNodeInsert(xmlDoc, objNode, "DATA");
	        createNodeAndInsertText(xmlDoc, objNode, "CMD", "ADD");
	        createNodeAndInsertText(xmlDoc, objNode, "URL", g_url);
	        objRow = createNodeAndAppandNode(xmlDoc, objNode, objRow, "FILELIST");
	        
	        for (var i = 0; i < nodes.length; i++) {
	            
	        	if (getNodeText(GetChildNodes(nodes[i])[1]) != "denied") {
	                objRows = createNodeAndAppandNode(xmlDoc, objRow, objRows, "FILE");
	                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "NAME", getNodeText(GetChildNodes(nodes[i])[2]));
	                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "PATH", getNodeText(GetChildNodes(nodes[i])[4]));
	                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "BIG", getNodeText(GetChildNodes(nodes[i])[5]));
	                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "SIZE", getNodeText(GetChildNodes(nodes[i])[3]));
	                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "ITEMID", "Y");
	            }
	        }
	        xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("POST", "/ezEmail/mailInterAttachCK.do", false);
	        xmlhttp.send(xmlDoc);
	        var aitem;
	        var xmlReturnValue = createXmlDom();
	        var objNode;
	        var objRow;
	        var objRows;
	        objNode = createNodeInsert(xmlReturnValue, objNode, "DATA");
	        
	        if (xmlhttp.status == "200") {
	        	
	        	if (xmlhttp.responseText.indexOf("NO APPEND failed.") > -1) {
	        		alert(strLang241);
	        	} else {
		        	xmlDoc = loadXMLString(xmlhttp.responseText);
		
		            if (CrossYN()) {
		                g_url = xmlDoc.getElementsByTagName("URL").item(0).textContent;
		            } else {
		                g_url = xmlDoc.getElementsByTagName("URL").item(0).text;
		            }
		            
		            var filelist = SelectNodes(xmlDoc, "DATA/FILELIST/FILE");
	        	    var scheme = document.location.protocol + "//" + document.location.hostname;
	        	    
	                if (document.location.port != "80") {
	                	scheme += ":" + document.location.port;
	                }
		            
		            /* 2018-04-25 김유진 - 파일 첨부시 href에 넣어줄 aitem 수정 */
		            for (var i = 0; i < filelist.length; i++) {
		                filename = SelectSingleNodeValue(filelist[i], "NAME");
		                path = SelectSingleNodeValue(filelist[i], "PATH");
		                big_yn = SelectSingleNodeValue(filelist[i], "BIG");
		                size = SelectSingleNodeValue(filelist[i], "SIZE");
		                attid = SelectSingleNodeValue(filelist[i], "ITEMID");
		                
		                if (big_yn == "Y") {
		                	// 대용량 첨부시 
		                	bigtrue = bigtrue + 1;
		                	aitem = scheme  + "/ezEmail/downloadAttachCommon.do?"
		                					+ "fileid=" + encodeURIComponent(path)
		                					+ "&filedate=" + encodeURIComponent(attid.split('/')[0])
		                					+ "&tid=" + tid;
		                } else {
		                	// 일반파일 첨부시
			                aitem = "/ezEmail/downloadAttach.do?" 
			                				+ "mode=Attach"
			                				+ "&folderPath=" + encodeURIComponent(folderPath)
			                				+ "&filename=" + encodeURIComponent(filename);
		                }
		                
		                objRows = createNodeAndAppandNode(xmlReturnValue, objNode, objRows, "ROW");
		                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "FILEPATH", path);
		                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "URL", aitem);
		                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "BIG", big_yn);
		                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "ITEMID", attid);
		                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "UID", g_url);
		            }
		            
		            returnvalue(strXML);
	        	}
	        	
	        } else {
	            alert(xmlhttp.status + " : " + strLang241);
	        }
	        
	        return xmlReturnValue;
	    }
	
	    var pOrgAttachListXml = "";
	    function Editor_Complete() {
	        if (initFlag == false) {
	            if (Org_cmd == "board") {
	                GetBoardItemInfo_New("${boardID}", "${itemID}", "${retransType}");
	            }
	            else if (Org_cmd == "Community") {
	                GetBoardItemInfo_New3("${boardID}", "${itemID}");
	            }
	            else if (Org_cmd == "report") {
	                GetUpmooItemInfo_New("${itemID}", "${docHref}")
	            }
	            else if (Org_cmd == "docsend" || Org_cmd == "docsenddoc") {
	                GetDocumentInfo(pDocID, docHref, "${docImagCnt}", "${docTarget}");
	            }
	            else if (Org_cmd == "docsendDotNet") {
	                GetDocumentInfo_DotNet(pDocID, docHref, "${docImagCnt}", "${docTarget}");
	            }
	            else if (Org_cmd == "boardDotNet") {
	                GetBoardItemInfo_DotNet("${boardID}", "${itemID}", "${retransType}");
	            }
	            else if (Org_cmd == "CommunityDotNet") {
	                GetBoardItemInfo_New3_DotNet("${boardID}", "${itemID}");
	            }	
	            //업무일지면...
	            else if (Org_cmd == "journal") {
	            	getJournalToMail();
	            	return;
	            }
	            // ezPMS 게시판
	            else if (Org_cmd == "ezPMSBoard") {
	            	getEzPMSBoardToMail();
	            	return;
	            }
	            else if (Org_cmd == "ezPMS") {
	            	getPMSMemberList(ezPMSType);
	            	return;
	            }
	            else if (Org_cmd == "attitude") {
	            	getAttitudeToMail();
	            	return;
	            }
	            else if (Org_cmd == "attitudeAbsented") {
	            	getAttitudeAbsentedList("duplicated");
	            	return;
	            }
	            
	            initFlag = true;
	            pOrgAttachListXml = pAttachListXml;
	        }
	        Rebody();
	        
	        document.getElementById("plainTextArea").value = message.GetEditorTextContent().replace(/\r\n\r\n/gi, "\r\n");
	        
	        g_originalHTML = message.GetEditorContent();
	        g_originalPlainText = document.getElementById("plainTextArea").value;
	        
	        mailSignInnerHtml();
	    }

		// 180517 : 메일 mailsign div에 메일을 작성 후 서명 등록 또는 변경 시 본문 사라지는 현상 수정
	    function mailSignInnerHtml() {
			if (mailsel == 0 && gg_cmd != "RESEND") {
				if (pUse_Editor == "KUKUDOCS") {
					setTimeout(function() {
							message.EditorElementSetHtml("MailSign", "");
					}, 300);
				} else {
					message.EditorElementSetHtml("MailSign", "");
				}
			}
	    }
	
	    function getJournalToMail(){
	    	var journal;
	    	$.ajax ({
				type : "POST",
				async : false,
				url : "/ezJournal/journalDetailJSON.do",
				data : {
					"journalId" : journalId
				},
				success : function(result) {
					$("#eSubject").val("<spring:message code='ezJournal.t1' /><spring:message code='ezEmail.t674' /> : "+result.journalTitle);
					var journalContent = "<p></p><p></p><hr>" + (result.journalContent).replace(/&#39;/gi, "\'");
					message.SetEditorContent(journalContent);
					var fileList = result.fileList;
					
					var pstrXML = "";

					//첨부파일이 있을 경우
			        if (fileList.length > 0) {
			            pstrXML += "<LISTVIEWDATA><HEADERS>";
			            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
			            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
			            pstrXML += "</HEADERS><ROWS>";
			        }
			        for (var i = 0; i < fileList.length; i++) {
			            var filepath = fileList[i].filePath;
			            var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
			            var filename = fileList[i].fileName;
			            var filesize = fileList[i].fileSize;

			            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
			            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
			            pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
			            pstrXML += "<DATA3></DATA3>";
			            pstrXML += "<DATA4>BOARD</DATA4>";
			            pstrXML += "<DATA5>N</DATA5>";
			            pstrXML += "<DATA6>" + filesize + "</DATA6>";
			            if(filesize > BigSizeAttachSize )
			                pstrXML += "<DATA7>Y</DATA7>";
			            else
			                pstrXML += "<DATA7>N</DATA7>";
			            pstrXML += "</CELL><CELL>";
			            pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
			            pstrXML += "</CELL></ROW>";
			        }
			        if (pstrXML != "") {
			            pstrXML += "</ROWS></LISTVIEWDATA>";
			            objXML = loadXMLString(pstrXML);
			            if (pAttachListXml == "") {
			                pAttachListXml = objXML;
			            }
			            else {
			                if (typeof (pAttachListXml) == "string")
			                    Rtnxml = loadXMLString(pAttachListXml);
			                else
			                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));

			                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
			                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
//			                    if (CrossYN())
//			                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
//			                    else
			                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
			                }
			                pAttachListXml = Rtnxml;
			            }
			            if (DragDropAttachObjetLoading) {
//			            	AppendFileAttachInfo(pAttachListXml);
			            	dadiframe.fileupload2(pAttachListXml,"/ezEmail/mailInterUploadCopyXCKFromJournal.do");
			            }
			        }
				}
			});
	    }
	    
	    function getEzPMSBoardToMail(){
	    	var journal;
	    	$.ajax ({
				type : "POST",
				async : false,
				url : "/ezPMS/boardDetailJSON.do",
				data : {
					projectId : ezPMSProjectId,
					itemId : ezPMSBoardId
				},
				success : function(result) {
					$("#eSubject").val("<spring:message code='ezBoard.t342' /><spring:message code='ezEmail.t674' /> : "+result.title);
					var boardContent = "<p></p><p></p><hr>";
					boardContent += "<p><b>" + "<spring:message code='ezPMS.t210' /> " + "</b>" + result.writeDate.substring(0, result.writeDate.length - 2) + "<br/>";
					boardContent += "<b>" + "<spring:message code='ezPMS.t211' /> " + "</b>" + result.writerName + "<br/>";
					boardContent += "<b>" + "<spring:message code='ezPMS.t212' /> " + "</b>" + result.title + "</p>";
					boardContent += "<p></p>";
					boardContent += (result.boardContent).replace(/&#39;/gi, "\'");
					
					message.SetEditorContent(boardContent);
					var fileList = result.fileList;
					
					var pstrXML = "";

					//첨부파일이 있을 경우
			        if (fileList.length > 0) {
			            pstrXML += "<LISTVIEWDATA><HEADERS>";
			            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
			            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
			            pstrXML += "</HEADERS><ROWS>";
			        }
			        for (var i = 0; i < fileList.length; i++) {
			            var filepath = fileList[i].filePath;
			            var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
			            var filename = fileList[i].fileName;
			            var filesize = fileList[i].fileSize;

			            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
			            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
			            pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
			            pstrXML += "<DATA3></DATA3>";
			            pstrXML += "<DATA4>BOARD</DATA4>";
			            pstrXML += "<DATA5>N</DATA5>";
			            pstrXML += "<DATA6>" + filesize + "</DATA6>";
			            if(filesize > BigSizeAttachSize )
			                pstrXML += "<DATA7>Y</DATA7>";
			            else
			                pstrXML += "<DATA7>N</DATA7>";
			            pstrXML += "</CELL><CELL>";
			            pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
			            pstrXML += "</CELL></ROW>";
			        }
			        if (pstrXML != "") {
			            pstrXML += "</ROWS></LISTVIEWDATA>";
			            objXML = loadXMLString(pstrXML);
			            if (pAttachListXml == "") {
			                pAttachListXml = objXML;
			            }
			            else {
			                if (typeof (pAttachListXml) == "string")
			                    Rtnxml = loadXMLString(pAttachListXml);
			                else
			                    Rtnxml = loadXMLString(getXmlString(pAttachListXml));

			                for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
			                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
//			                    if (CrossYN())
//			                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
//			                    else
			                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
			                }
			                pAttachListXml = Rtnxml;
			            }
			            if (DragDropAttachObjetLoading) {
//			            	AppendFileAttachInfo(pAttachListXml);
			            	dadiframe.fileupload2(pAttachListXml,"/ezEmail/mailInterUploadCopyXCKFromJournal.do");
			            }
			        }
				}
			});
	    }
	    
	    function btn_AttachSelect_onclick() {
	        document.getElementById('mode').value = "ATT";
	        document.form.file1.click();
	    }
	
	    function FieldsAvailable() {
	    }
	
	    var GroupplusImg = "/images/ImgIcon/groupplus.gif";
	    var GroupminImg = "/images/ImgIcon/groupmin.gif";
	    function MailBCCView(obj) {
	        if (obj.getAttribute("status") == "off") {
	            obj.childNodes.item(1).src = GroupminImg;
	            document.getElementById("MsgBCC_TRu").style.display = "";
	            document.getElementById("MsgBCC_TR").style.display = "";
	            obj.setAttribute("status", "on");
	        }
	        else {
	            obj.childNodes.item(1).src = GroupplusImg;
	            document.getElementById("MsgBCC_TRu").style.display = "none";
	            document.getElementById("MsgBCC_TR").style.display = "none";
	            obj.setAttribute("status", "off");
	        }
	        
        	if (isCrossBrowser == 'true') {
        		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 240 + "PX";
        	} else {
        		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 160 + "PX";
        	}
	    }
		
	    function changeTextOption(bodyType) {
	    	if (bodyType == "1") {
	        	if (confirm("<spring:message code='ezEmail.lhm28' />") == true) {
	  	        	message.SetEditorContent(message.GetEditorContent().replace(/<hr /gi, "<p>----------------------------------------------------------------------------------------------------</p><hr "));
	  	        	message.SetEditorContent(message.GetEditorContent().replace(/P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}/gi, ""));
	  	        	
                    if (pUse_Editor == "NAMO") {
                    	document.getElementById("plainTextArea").value = " \n \n" + message.GetEditorTextContent().replace(/\r\n\r\n/gi, "\r\n");
                    } else if (pUse_Editor == "CK") {
                    	document.getElementById("plainTextArea").value = " \n \n" + message.GetEditorTextContent().replace(/\r\n\r\n|\n\r\n\r/gi, "\r\n");	
                    } else {
                    	document.getElementById("plainTextArea").value =  message.GetEditorTextContent().replace(/\r\n\r\n|\n\r\n\r/gi, "\r\n");	
                    }	
                    
	        		document.getElementById("tbContentElement").style.display = "none";
					document.getElementById("plainTextArea").style.display = "";
	        		m_rgParams4PostOption["bodyType"] = document.getElementById("bodyType").value;
		        	document.getElementById("SelMailSign").disabled = true;

	        	} else {
	        		document.getElementById("bodyType").options[0].selected = true;
	        	}
	    	} else {
	    		var texts = document.getElementById("plainTextArea").value.split("\n");
	            var textData = "";
	            for (var i=0; i<texts.length; i++) {
	            	if (i == 0 && $.trim(texts[i]) == ""  && (pUse_Editor == "NAMO" || pUse_Editor == "CK")) {
	            		textData = "<br/>";
	            	}
	            	if (texts[i] != "" && texts[i] != " ") {
	            		texts[i] = texts[i].replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\r\n/gi, "\n");
	            		textData += "<p " + defaultFontAndSize + ">" + texts[i] + " " + "</p>";
	            	} 
	            }
	            
	    		message.SetEditorContent(textData);
	    		
	    		document.getElementById("tbContentElement").style.display = "";
				document.getElementById("plainTextArea").style.display = "none";
	    		m_rgParams4PostOption["bodyType"] = document.getElementById("bodyType").value;
        		document.getElementById("SelMailSign").disabled = false;
	    	}
	    }
	    
	    function ChangeSenderName(obj) {
	        if (obj.value != "NONE")
	            g_showdisplay = obj.value;
	        else
	            g_showdisplay = "";
	    }
	
	    function shownoti(str) {
	        if (str.trim() != "")
	            alert(str);
	    }
	
	    var DragDropAttachObjetLoading = false;
	    function DragObjectComplet() {
	        DragDropAttachObjetLoading = true;
	        if (pAttachListXml != "") {
		        var AttachRows = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW")
		
		        if (AttachRows.length > 0) {
		            AppendFileAttachInfo(pAttachListXml);
		            dadiframe.fileupload2(pAttachListXml);
		        }
	        }
	    }
	
	    function DownloadAttach(DownloadUrl) {
	        AttachDownFrame.location.href = DownloadUrl;
	    }
		
	    function fromAddressChange(val) {
	    	g_from = val;
	    }
	    	    
	    function GetDocumentInfo_DotNet(DocID, DocHref, ImagCnt, Target) {
	        AttachFlag = true;
	        var docAttach = "";

	        if (DocHref.toLowerCase().indexOf(".doc") == -1 && DocHref.toLowerCase().indexOf(".hwp") == -1) {
	            if (DocHref == "IMAGE") {
	                var HtmlBody = "<div style='position:relative;display:inline-block' class='margin' id='ezFormProc_div'><hr></hr><div align='center'>";
	                if (ImagCnt == "") {
	                    HtmlBody = HtmlBody + "<img src='" + "/Upload_Common" + "/" + GetDateFormatString() + "/" + DocID + ".png' embedding='1'/>";
	                }
	                else {
	                    for (var i = 1; i <= parseInt(ImagCnt) ; i++) {

	                        if (i != 1)
	                            HtmlBody = HtmlBody + "<br><img style='margin-top:-6px;' src='" + uploadCommonPath + "/" + GetDateFormatString() + "/" + DocID + "_" + i + ".png' embedding='1'/>";
	                        else
	                            HtmlBody = HtmlBody + "<img src='" + "/Upload_Common" + "/" + GetDateFormatString() + "/" + DocID + "_" + i + ".png' embedding='1'/>";
	                    }
	                }
	                HtmlBody = HtmlBody + "</div></div>";
	                document.getElementById("bodyValue").innerHTML = document.getElementById("bodyValue").innerHTML + HtmlBody;
	            }
	            else {
	                if (DocHref.toLowerCase().indexOf(".mht") > -1) {
	                    var fullPath = encodeURIComponent(DocHref);
	                    var tempXML = createXmlDom();
// 	                    var XmlBodyATT = createXmlDom();
	                    var XmlBodyDATA = createXmlDom();
	                    var tempStr = "";
	                    tempStr = ConvertMHTtoHTML(fullPath);
	                    tempXML = loadXMLString(tempStr);
// 	                    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	                    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	                    var htmlData = getNodeText(XmlBodyDATA);
	                    document.getElementById('docContent').innerHTML = htmlData;
	                    document.getElementById('docContent').style.height = "220px";
	                }
	            }
	        }
	        var xmlHTTP = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var xmlstring = "<DocID>" + DocID + "</DocID>";
	        xmlpara = loadXMLString(xmlstring);
	        if (Target == "APPROVALG")
	            xmlHTTP.open("POST", "${dotNetUrl}/myoffice/ezApproval/formContainer/aspx/aprattachMail.aspx", false);
	        else
	            xmlHTTP.open("POST", "${dotNetUrl}/myoffice/ezApproval/formContainer/aspx/aprattachMail.aspx", false);
	        xmlHTTP.withCredentials = true;
	        xmlHTTP.send(xmlpara);

	        if (xmlHTTP.status == 200) {
	            var ReturnXML = loadXMLString(xmlHTTP.responseText);
	            if (DocHref.toLowerCase().indexOf(".doc") > 0 || DocHref.toLowerCase().indexOf(".hwp") > 0) {
	                var FileExtention = DocHref.substring(DocHref.toLowerCase().lastIndexOf(".") + 1);
	                var pstrXML = "";
	                pstrXML += "<LISTVIEWDATA><HEADERS>";
	                pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
	                pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	                pstrXML += "</HEADERS><ROWS>";
	                pstrXML += "<ROW><CELL><VALUE>" + getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]) + "." + FileExtention + "</VALUE>";
	                pstrXML += "<DATA1>" + getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]) + "." + FileExtention + "</DATA1>";
	                pstrXML += "<DATA2>" + DocHref + "</DATA2>";
	                pstrXML += "<DATA3></DATA3>";
	                pstrXML += "<DATA4>APPROVALDOC</DATA4>";
	                pstrXML += "<DATA5>N</DATA5>";
	                pstrXML += "<DATA6>" + strLang116 + "</DATA6>";
	                pstrXML += "</CELL><CELL>";
	                pstrXML += "<VALUE>" + strLang116 + "</VALUE>";
	                pstrXML += "</CELL></ROW>";
	                pstrXML += "</ROWS></LISTVIEWDATA>";
	                objXML = loadXMLString(pstrXML);
	                if (pAttachListXml == "") {
	                    pAttachListXml = objXML;
	                }
	                else {
	                    if (typeof (pAttachListXml) == "string")
	                        Rtnxml = loadXMLString(pAttachListXml);
	                    else
	                        Rtnxml = loadXMLString(getXmlString(pAttachListXml));

	                    GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
	                    for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                        var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
	                        if (CrossYN()) 
	                            var Node = Rtnxml.importNode(objNewAttachNodes, true);                    
	                        else
	                            GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
	                    }
	                    pAttachListXml = Rtnxml;
	                }
	            }
	            eSubject.value = strLang117 + getNodeText(GetElementsByTagName(ReturnXML, "DOCTITLE")[0]);
	            var AttachRows = SelectNodes(ReturnXML, "ATTACHINFO/DATA/ROW");
	            var pstrXML = "";
	            if (AttachRows.length > 0) {
	                pstrXML += "<LISTVIEWDATA><HEADERS>";
	                pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
	                pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	                pstrXML += "</HEADERS><ROWS>";
	            }

	            for (var i = 0; i < AttachRows.length; i++) {
	                var filepath = SelectSingleNodeValue(AttachRows[i], "ATTACHFILEHREF");
	                var filename = SelectSingleNodeValue(AttachRows[i], "ATTACHNAME");
	                var filesize = SelectSingleNodeValue(AttachRows[i], "ATTACHFILESIZE");
	                if (filesize == "0" && filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "hwp") {
	                    filename = filename + ".hwp";
	                    filesize = strLang116;
	                }
	                else if (filepath.substring(filepath.toLowerCase().lastIndexOf(".") + 1) == "mht") {
	                    var extension = filename.substring(filename.length - 4);
	                    
	                    if (extension.toLowerCase() != ".mht") {
	                    	filename = filename + ".mht";
	                    }
	                    
	                    filesize = strLang116;
	                }

	                pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
	                pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
	                pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
	                pstrXML += "<DATA3></DATA3>";
	                pstrXML += "<DATA4>APPROVAL</DATA4>";
	                pstrXML += "<DATA5>N</DATA5>";
	                pstrXML += "<DATA6>" + filesize + "</DATA6>";
	                if (filesize > BigSizeAttachSize)
	                    pstrXML += "<DATA7>Y</DATA7>";
	                else
	                    pstrXML += "<DATA7>N</DATA7>";

	                pstrXML += "</CELL><CELL>";
	                pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
	                pstrXML += "</CELL></ROW>";
	            }
	            if (pstrXML != "") {
	                pstrXML += "</ROWS></LISTVIEWDATA>";
	                objXML = loadXMLString(pstrXML);
	                if (pAttachListXml == "") {
	                    pAttachListXml = objXML;
	                }
	                else {
	                    if (typeof (pAttachListXml) == "string")
	                        Rtnxml = loadXMLString(pAttachListXml);
	                    else
	                        Rtnxml = loadXMLString(getXmlString(pAttachListXml));

	                    GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
	                    for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                        var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
//	                      if (CrossYN())
//	                         var Node = Rtnxml.importNode(objNewAttachNodes, true);
//	                      else
	                            GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
	                    }
	                    pAttachListXml = Rtnxml;
	                }
	                if (DragDropAttachObjetLoading) {
//	                  AppendFileAttachInfo(pAttachListXml);
	                    dadiframe.fileupload2(pAttachListXml);              
	                }
	            }
	        }
	    }
	    
	    function GetBoardItemInfo_DotNet(pBoardID, pItemID, pRetransType) {
	    	AttachFlag = true;
	        var xmlHTTP = createXMLHttpRequest();
	        xmlHTTP.open("GET", "${dotNetUrl}/myoffice/ezBoardSTD/interASP/GetItemInfo.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
	        xmlHTTP.withCredentials = true;
	        xmlHTTP.send("");

	        if (xmlHTTP.status == 200) {
	            var ReturnXML = loadXMLString(xmlHTTP.responseText);
	            var Rurl = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ContentLocation")[0]);
	            var fullPath = Rurl;
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(fullPath);

	            tempXML = loadXMLString(tempStr);
// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            var htmlData = getNodeText(XmlBodyDATA);

	            eSubject.value = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0]);
	            var PostDate = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriteDate")[0]);
	            var Sender = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterName")[0]) + " (" +
	    	                 getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ExtensionAttribute3")[0]) + "," +
	    			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterDeptName")[0]) + "," +
	    			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterCompanyName")[0]) + ")";

	            if (Sender.indexOf("(,,)") > -1) Sender = Sender.split("(")[0];

	            htmlData = ReplaceText(htmlData, "<P ", "<DIV ");
	            htmlData = ReplaceText(htmlData, "/P>", "/DIV>");
	            htmlData = ReplaceText(htmlData, "<P>", "<DIV>");
	            htmlData = ReplaceText(htmlData, "</P>", "</DIV>");
	            htmlData = ReplaceText(htmlData, "<TD class=FIELD", "<TD");
	            if (pRetransType != "boardAttach") {
	                document.getElementById("bodyValue").innerHTML = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" + "<br><br><hr></hr><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender + "<br><B>" + strLang120 + "</B>" + MakeXMLString(eSubject.value) + "<br><br>" + htmlData;
	            }

	            xmlHTTP.open("POST", "${dotNetUrl}/myoffice/ezBoardSTD/interASP/GetItemAttachments.aspx?ItemID=" + pItemID + "&pMode=" + pRetransType + "&conLocation=" + encodeURIComponent(Rurl) + "&title=" + encodeURIComponent(getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0])), false);
	            xmlHTTP.send();
	            var ReturnXML = loadXMLString(xmlHTTP.responseText);
	            var AttachRows = SelectNodes(ReturnXML, "NODES/NODE");
	            var pstrXML = "";

	            //첨부파일이 있을 경우
	            if (AttachRows.length > 0) {
	                pstrXML += "<LISTVIEWDATA><HEADERS>";
	                pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
	                pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	                pstrXML += "</HEADERS><ROWS>";
	            }
	            for (var i = 0; i < AttachRows.length; i++) {
	                var filepath = SelectSingleNodeValue(AttachRows[i], "FilePath");
	                filepath = "/Upload_BoardSTD/" + filepath;
	                var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
	                var filename = MakeXMLString(filenameTemp.substring(filenameTemp.indexOf("_") + 1, filenameTemp.length));
	                var filesize = SelectSingleNodeValue(AttachRows[i], "FileSize2");

	                pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
	                pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
	                pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
	                pstrXML += "<DATA3></DATA3>";
	                pstrXML += "<DATA4>BOARD</DATA4>";
	                pstrXML += "<DATA5>N</DATA5>";
	                pstrXML += "<DATA6>" + filesize + "</DATA6>";
	                if(filesize > BigSizeAttachSize )
	                    pstrXML += "<DATA7>Y</DATA7>";
	                else
	                    pstrXML += "<DATA7>N</DATA7>";
	                pstrXML += "</CELL><CELL>";
	                pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
	                pstrXML += "</CELL></ROW>";
	            }
	            if (pstrXML != "") {
	                pstrXML += "</ROWS></LISTVIEWDATA>";
	                objXML = loadXMLString(pstrXML);
	                if (pAttachListXml == "") {
	                    pAttachListXml = objXML;
	                }
	                else {
	                    if (typeof (pAttachListXml) == "string")
	                        Rtnxml = loadXMLString(pAttachListXml);
	                    else
	                        Rtnxml = loadXMLString(getXmlString(pAttachListXml));

	                    for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                        var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
	                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
	                    }
	                    pAttachListXml = Rtnxml;
	                }
	                if (DragDropAttachObjetLoading) {
	                	dadiframe.fileupload2(pAttachListXml);
	                }
	            }
	            
	            eSubject.value = strLang121 + eSubject.value;
	            Subject_ReApply();
	        }
	    }
	    
	    function GetBoardItemInfo_New3_DotNet(pBoardID, pItemID) {
	        AttachFlag = true;
	        var xmlHTTP = createXMLHttpRequest();
	        xmlHTTP.open("GET", "${dotNetUrl}/myoffice/ezCommunity/aspx/GetItemInfo.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
	        xmlHTTP.withCredentials = true;
	        xmlHTTP.send("");

	        if (xmlHTTP.status == 200) {
	            var ReturnXML = loadXMLString(xmlHTTP.responseText);
	            var Rurl = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ContentLocation")[0]);
	            var fullPath = Rurl;
	            var tempXML = createXmlDom();
// 	            var XmlBodyATT = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            tempStr = ConvertMHTtoHTML(fullPath);
	            tempXML = loadXMLString(tempStr);
// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            var htmlData = getNodeText(XmlBodyDATA);
	            
	            eSubject.value = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0]);
	            var PostDate = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/StartDate")[0]);
	            var Sender = getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterName")[0]) + " (" +
	    	                 getNodeText(SelectNodes(ReturnXML, "NODES/NODE/ExtensionAttribute3")[0]) + "," +
	    			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterDeptName")[0]) + "," +
	    			         getNodeText(SelectNodes(ReturnXML, "NODES/NODE/WriterCompanyName")[0]) + ")";

	            if (Sender.indexOf("(,,)") > -1) Sender = Sender.split("(")[0];

	            htmlData = ReplaceText(htmlData, "<P ", "<DIV ");
	            htmlData = ReplaceText(htmlData, "/P>", "/DIV>");
	            htmlData = ReplaceText(htmlData, "<P>", "<DIV>");
	            htmlData = ReplaceText(htmlData, "</P>", "</DIV>");
	            htmlData = ReplaceText(htmlData, "<TD class=FIELD", "<TD");
	            document.getElementById("bodyValue").innerHTML = "<DIV style='LINE-HEIGHT: 15pt' ><br /><br /><DIV id='MailSign'></div><br /></DIV>" + "<br><br><hr></hr><B>" + strLang118 + "</B>" + PostDate + "<br><B>" + strLang119 + "</B>" + Sender + "<br><B>" + strLang120 + "</B>" + eSubject.value + "<br><br>" + htmlData;

	            xmlHTTP.open("POST", "${dotNetUrl}/myoffice/ezCommunity/aspx/GetItemAttachments.aspx?ItemID=" + pItemID, false);
	            xmlHTTP.send();
	            var ReturnXML = loadXMLString(xmlHTTP.responseText);
	            var AttachRows = SelectNodes(ReturnXML, "NODES/NODE");
	            var pstrXML = "";
	            if (AttachRows.length > 0) {
	                pstrXML += "<LISTVIEWDATA><HEADERS>";
	                pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
	                pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
	                pstrXML += "</HEADERS><ROWS>";
	            }
	            for (var i = 0; i < AttachRows.length; i++) {
	                var filepath = SelectSingleNodeValue(AttachRows[i], "FilePath");	                
	                var filenameTemp = filepath.split('/')[filepath.split('/').length - 1];
	                var filename = MakeXMLString(filenameTemp.substring(filenameTemp.indexOf("_") + 1, filenameTemp.length));	                
	                var filesize = SelectSingleNodeValue(AttachRows[i], "FileSize2");
	                
	                pstrXML += "<ROW><CELL><VALUE>" + filename + "</VALUE>";
	                pstrXML += "<DATA1>" + filename + "</DATA1>";
	                pstrXML += "<DATA2>" + "/Upload_Community" + "/" + filepath + "</DATA2>";
	                pstrXML += "<DATA3></DATA3>";
	                pstrXML += "<DATA4>BOARD</DATA4>";
	                pstrXML += "<DATA5>N</DATA5>";
	                pstrXML += "<DATA6>" + filesize + "</DATA6>";
	                if (filesize > BigSizeAttachSize)
	                    pstrXML += "<DATA7>Y</DATA7>";
	                else
	                    pstrXML += "<DATA7>N</DATA7>";
	                pstrXML += "</CELL><CELL>";
	                pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
	                pstrXML += "</CELL></ROW>";
	            }

	            if (pstrXML != "") {
	                pstrXML += "</ROWS></LISTVIEWDATA>";
	                objXML = loadXMLString(pstrXML);
	                if (pAttachListXml == "") {
	                    pAttachListXml = objXML;
	                }
	                else {
	                    if (typeof (pAttachListXml) == "string")
	                        Rtnxml = loadXMLString(pAttachListXml);
	                    else
	                        Rtnxml = loadXMLString(getXmlString(pAttachListXml));

	                    GetChildNodes(SelectNodes(objXML, "<LISTVIEWDATA><ROWS>")).length
	                    for (var i = 0; i < SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                        var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[i];
	                        var Node = Rtnxml.importNode(objNewAttachNodes, true);
	                        GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
	                    }
	                    pAttachListXml = Rtnxml;
	                }
	                if (DragDropAttachObjetLoading) {
//	                  AppendFileAttachInfo(pAttachListXml);
	                	dadiframe.fileupload2(pAttachListXml);
	                }
	            }
	            eSubject.value = strLang121 + eSubject.value;
	            Subject_ReApply();
	            
	        }
	    }
	    
	    // 재은 수정(편지지)
	    function Letter_onClick() {
	    	DivPopUpShow(583, 495, "/ezEmail/mailLetter.do");
	    }
	    
	    function getAttitudeAbsentedList(gubun) {
	    	$.ajax({
				type : "post",
				dastaType : "json",
				async : false,
				url : "/admin/ezAttitude/getAttitudeAbsentedList.do",
				data : {
					companyId : "${companyId}",
   					userName : "${searchUserName}",
   					deptName : "${searchDeptName}",
   					title : "${searchTitle}",
   					deptId : "${searchDeptId}",
   					startDate : searchStartDate,
   					endDate : searchEndDate,
   					pageNum : "",
   					listSize : "",
   					orderCell : "",
   					orderOption : "",
   					duplicated : gubun
				},
				success : function(result) {
					if (gubun == "distinct") {
						var resultHtml = "";
						
						result.list.forEach(function(vo, index) {
			    			resultHtml += "\"" + vo.userName + "\"";
			    			resultHtml += " <" + vo.userEmail + ">, ";
			    		});
						
						resultHtml = resultHtml.slice(0, -2);
						
						xmpTo.innerHTML = resultHtml;
					} else {
						var resultHtml = "<p>해당 메일을 받은 사원은 " + searchStartDate + "&nbsp;~&nbsp;" + searchEndDate + " 중 근태를 미입력한 사원입니다.</p><p>확인 후 근태를 등록해주시기 바랍니다.</p>";
						resultHtml += "<p>근태 수정 권한은  각 본부장님 또는 근태관리자, 경영지원실에 있사오니, 근태관리자 및 본부장님의 부재로 인해 근태 수정이 어려우신 경우 경영지원실로 메일 바랍니다.</p>";
						resultHtml += "<p>근태는 매년 인사평가에 반영되는 사항이기에 차일까지 반드시 수정 부탁 드리겠습니다.</p><p></p><hr>";
						
						resultHtml += "<p></p><p><span style='font-size:18px;'><strong>&nbsp;근태미입력자</strong></span></p><p></p>";
						resultHtml += "<table style='border-collapse:collapse; width:800px;'>";
						resultHtml += "<thead><tr>";
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>날짜</th>" ;
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>이름</th>";
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>직위</th>";
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'>부서</th>";
						resultHtml += "</thead><tbody>";
						
						result.list.forEach(function(vo, index) {
			    			resultHtml += "<tr><td style='border:1px solid #666'>" + vo.startDate+ " </td>";
			    			resultHtml += "<td style='border:1px solid #666'>" + vo.userName + "</td>";
			    			resultHtml += "<td style='border:1px solid #666'>" + vo.userTitle + "</td>";
			    			resultHtml += "<td style='border:1px solid #666'>" + vo.deptName + "</td></tr>";
			    		});
						
						resultHtml += "</tbody></table>";
						
						$("#eSubject").val("[근태미입력공지] " + searchStartDate + " ~ " + searchEndDate);
						
						message.SetEditorContent(resultHtml);
					}
				}
			});
	    }
	    
	    function getPMSMemberList(type) {
	    	var data = {
				projectId : ezPMSProjectId,
				roleId : ezPMSRoleId,
				type : ezPMSType,
				toUserId : ezPMSToUserId,
				userIdType : ezPMSUserIdType,
				taskId : ezPMSTaskId
	    	}
	    	
	    	$.ajax ({
	    		type : "post",
				dastaType : "json",
   				contentType: "application/json; charset=UTF-8",
				async : false,
				url : "/ezPMS/sendMail.do",
				data : JSON.stringify(data),
				success : function(result) {
					$("#eSubject").val("[" + result.project.projectName + "]");

					var resultHtml = "";
					
					if (ezPMSType == "group") {
						var memberList = result.list;
						var headManagerId = result.project.headManagerId;
						
						for (var i = 0; i < memberList.length; i++) {
							var userId = memberList[i].userId;
							
							if (headManagerId != userId) {
					    		resultHtml += "\"" + memberList[i].userName + "\"";
					    		resultHtml += " <" + memberList[i].userMail + ">, ";	
							}
						}
						
						resultHtml = resultHtml.slice(0, -2);
					} else if (ezPMSType == "one") {
						resultHtml += "\"" + result.list.userName + "\"";
						resultHtml += " <" + result.list.userMail + ">";
					}
					
					console.log(resultHtml);
					xmpTo.innerHTML = resultHtml;
				}
	    	});
	    }
	    
	    function getAttitudeToMail() {
	    	$.ajax ({
	    		type : "POST",
	    		async : false,
	    		url : "/ezAttitude/getAttitudeItem.do",
	    		data : {
	    			attitudeId : attitudeId
	    		},
	    		success : function(result) {
	    			var titleDate = "";
	    			var objDiv = $("<div></div>");
	    			var objTable = $("<table></table>").css({"clear":"both", "margin":"0px", "border-collapse":"collapse", "empty-cells":"show"});
	    			var objTr = $("<tr></tr>").append($("<th></th>").text("구분")).append($("<td></td>").text(result.attitudeVO.typeName));
	    			
	    			objTable.append(objTr);
	    			objTable.append(result.formVO.formHtml);
	    			objTable.find("input").remove();
	    			objTable.find("th").css({"border" : "1px solid #d2d2d2", "padding" : "0px", "width" : "100px", "height" : "29px", "background-color" : "#f8f8fa"});
	    			objTable.find("td").css({"border" : "1px solid #d2d2d2", "padding" : "0px", "width" : "730px", "padding-left":"10px"});
	    			
	    			//objTable.append($("<tr></tr>").append($("<td></td>").attr("colspan", 2).css({"border":"0px", "height":"10px"})));
	    			objTable.append($("<tr></tr>").append($("<td></td>").attr({"colspan" : 2, "id" : "content"}).css({"border" : "1px solid #ddd", "padding" : "10px", "width" : "100px", "height" : "300px", "vertical-align" : "top"})));
	    			objDiv.append(objTable);
	    			
	    			var dateType = result.attitudeVO.dateType;
	    			if (dateType == 5) {
	    				objTable.find("#periodblock").text(result.attitudeVO.startDate.substring(0,16) + " ~ " + result.attitudeVO.endDate.substring(0,16));
	    				titleDate = result.attitudeVO.startDate.split(" ")[0] + (result.attitudeVO.startDate.split(" ")[0] == result.attitudeVO.endDate.split(" ")[0] ? "" : " ~ " + result.attitudeVO.endDate.split(" ")[0]);
	    			} else if (dateType == 4) {
	    				objTable.find("#periodblock").text(result.attitudeVO.startDate.split(" ")[0] + " ~ " + result.attitudeVO.endDate.split(" ")[0]);
	    				titleDate = result.attitudeVO.startDate.split(" ")[0] + (result.attitudeVO.startDate.split(" ")[0] == result.attitudeVO.endDate.split(" ")[0] ? "" : " ~ " + result.attitudeVO.endDate.split(" ")[0]);
	    			} else if (dateType == 3) {
	    				objTable.find("#periodblock").text(result.attitudeVO.startDate.substring(0,16) + " ~ " + result.attitudeVO.endDate.substring(11,16));
	    				titleDate = result.attitudeVO.startDate.split(" ")[0];
	    			} else if (dateType == 2) {
	    				objTable.find("#periodblock").text(result.attitudeVO.startDate.substring(0,16));
	    				titleDate = result.attitudeVO.startDate.split(" ")[0];
	    			} else {
	    				objTable.find("#periodblock").text(result.attitudeVO.startDate.split(" ")[0]);
	    				titleDate = result.attitudeVO.startDate.split(" ")[0];
	    			}
	    			
	    			$("#eSubject").val("[근태보고] " + result.attitudeVO.typeName + "/ " + result.attitudeVO.writerDeptName + " " + result.attitudeVO.writerName + "/ " + titleDate + (result.attitudeVO.region != "" ? "/ " + result.attitudeVO.region : ""));
	    			
	    			objTable.find("#periodblock");
	    			objTable.find("#writerName").text(result.attitudeVO.writerName);
	    			objTable.find("#mobile").text(result.attitudeVO.mobile);
	    			objTable.find("#bizsub").text(result.attitudeVO.bizSub);
	    			objTable.find("#region").length == 0 ? "" : objTable.find("#region").text(result.attitudeVO.region);
	    			objTable.find("#content").html(result.attitudeVO.content);
	    			message.SetEditorContent("<p></p><p></p><hr><p></p><p><span style='font-size:18px;'><strong>&nbsp;근태보고</strong></span></p><p></p>" + objDiv.html());
	    		}
	    	});
	    }
	    
	    function editorPtagChk() {
	    	var editorBody = message.GetEditorBody();
	    	var editorBodyChild = editorBody.childNodes;
	    	var appPtag = "";
	    	
	    	for (var i = 0; i < editorBodyChild.length; i++) {
            	if (editorBodyChild[i].nodeName.indexOf("text") == 1 || editorBodyChild[i].tagName.toLowerCase() == "p" && message.GetEditorContent() != ""){
            		break;
            	}
            	
            	if (i + 1 == editorBodyChild.length) {
            		appPtag = "<P " + defaultFontAndSize + "></P><P " + defaultFontAndSize + "></P>";
            	}
            }
	    	
	    	return appPtag;
	    }
	    
	    function keyEventNone(e) {
	    	e.preventDefault();
	    }
	    /* 
	    $(document).on("click", "#MailSign", function() {
	    	if (mailsel == 0) {
				message.EditorElementSetHtml("MailSign", "");
			}
	    }) */
	    
	    // 20180628 자동완성창의 width 값 고정
	    jQuery.ui.autocomplete.prototype._resizeMenu = function () {
	    	var ul = this.menu.element;
	    	ul.outerWidth(this.element.outerWidth());
	    }
	    
	    var IsInsert_MsgTo = false;
		$(function() {
			var widgetInst = $("#MsgTo").autocomplete({}).data('ui-autocomplete');
			widgetInst._renderMenu = function(ul, items) {
				var self = this;
				ul.append("<li id='theadTr' onkeydown='keyEventNone(event)' style='background-color:#e9e9e9; border-bottom:1px solid #d1d1d1; height:22px; pointer-events: none;'><a><table class='width100percent' width='100%' height='100%' style='display:inline-table'><thead><tr>"
				+ "<td style='width:20%; border:none; align:left'><spring:message code='ezAddress.t124' /></td>"
				+ "<td style='width:20%; border:none; align:left'><spring:message code='ezApproval.t171' /></td>"
				+ "<td style='width:15%; border:none; align:left'><spring:message code='ezPortal.t34' /></td>"
				+ "<td style='max-width:45%; border:none; align:left'><spring:message code='ezEmail.t713' /></td>"
				+ "</tr></thead></table></li></a>");
				$.each( items, function( index, item ) {
					self._renderItem( ul, item );
				});
			};
			var widgetInst = $("#MsgCC").autocomplete({}).data('ui-autocomplete');
			widgetInst._renderMenu = function(ul, items) {
				var self = this;
				ul.append("<li id='theadTr' onkeydown='keyEventNone(event)' style='background-color:#e9e9e9; border-bottom:1px solid #d1d1d1; height:22px; pointer-events: none;'><a><table class='width100percent' width='100%' height='100%' style='display:inline-table'><thead><tr>"
				+ "<td style='width:20%; border:none; align:left'><spring:message code='ezAddress.t124' /></td>"
				+ "<td style='width:20%; border:none; align:left'><spring:message code='ezApproval.t171' /></td>"
				+ "<td style='width:15%; border:none; align:left'><spring:message code='ezPortal.t34' /></td>"
				+ "<td style='max-width:45%; border:none; align:left'><spring:message code='ezEmail.t713' /></td>"
				+ "</tr></thead></table></li></a>");
				$.each( items, function( index, item ) {
					self._renderItem( ul, item );
				});
			};
			var widgetInst = $("#MsgBCC").autocomplete({}).data('ui-autocomplete');
			widgetInst._renderMenu = function(ul, items) {
				var self = this;
				ul.append("<li id='theadTr' onkeydown='keyEventNone(event)' style='background-color:#e9e9e9; border-bottom:1px solid #d1d1d1; height:22px; pointer-events: none;'><a><table class='width100percent' width='100%' height='100%' style='display:inline-table'><thead><tr>"
				+ "<td style='width:20%; border:none; align:left'><spring:message code='ezAddress.t124' /></td>"
				+ "<td style='width:20%; border:none; align:left'><spring:message code='ezApproval.t171' /></td>"
				+ "<td style='width:15%; border:none; align:left'><spring:message code='ezPortal.t34' /></td>"
				+ "<td style='max-width:45%; border:none; align:left'><spring:message code='ezEmail.t713' /></td>"
				+ "</tr></thead></table></li></a>");
				$.each( items, function( index, item ) {
					self._renderItem( ul, item );
				});
			};
			$("#MsgTo").autocomplete(
					{
						source : function(request, response) {
							$.ajax({
								type : 'post',
								url : "/ezEmail/autoCompleteList.do",
								dataType : "json",
								data : {
									value : request.term
								},
								success : function(data) {
									var susinList = data.susinList;
									response($.map(susinList, function(ul, item) {
										return {
											label : ul.name + " " + ul.title + " "
													+ ul.description + " "
													+ "<" + ul.mail + ">",
											value : ul.name,
											email : ul.mail,
											dept : ul.description,
											title : ul.title,
											type : ul.type
										};
									}));

								}
							});
						},
						minLength : 2,
						selectFirst : false,
						autoFocus : false,
						select : function(event, ui) {
							var addressType = "email";
							if(ui.item.type == "G") {
								addressType = "mailgroup";
							}
							
							newElem = PrepareMailTag("0", addressType, ui.item.value,
									ui.item.email, "");
							IsInsert_MsgTo = CheckMailReceiver(newElem);
							if (!IsInsert_MsgTo) {
								MsgToGot.appendChild(newElem);
								document.getElementById("MsgTo").value = "";
								IsInsert_MsgTo = true;
							}
						},
						focus : function(event, ui) {
							return false;
						},
						close : function(event, ui) {
							if (IsInsert_MsgTo)
								document.getElementById("MsgTo").value = "";
							IsInsert_MsgTo = false;
						},
						appendTo : "#AutoCompleteResults"
					}).data("ui-autocomplete")._renderItem = function(ul, item) {
				return $("<li style='border-bottom:1px solid #e8e8ef'>")
						.data("ui-autocomplete-item", item)
						.append(
								"<a title='" + item.email + "'><table class='width100percent' width='100%' height='100%' style='display:inline-table;'><tr><td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
										+ item.value
										+ "</td><td style='width:15%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
										+ item.dept
										+ "</td><td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
										+ item.title
										+ "</td><td style='max-width:45%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
										+ item.email + "</td></tr></table></a>")
						.appendTo(ul);
			};
			var IsInsert_MsgCC = false;
			$("#MsgCC").autocomplete(
					{
						source : function(request, response) {
							$.ajax({
								type : 'post',
								url : "/ezEmail/autoCompleteList.do",
								dataType : "json",
								data : {
									value : request.term
								},
								success : function(data) {
									var susinList = data.susinList;
									response($.map(susinList, function(ul, item) {
										return {
											label : ul.name + " " + ul.title + " "
													+ ul.description + " "
													+ "<" + ul.mail + ">",
											value : ul.name,
											email : ul.mail,
											dept : ul.description,
											title : ul.title
										};
									}));

								}
							});
						},
						minLength : 2,
						selectFirst : false,
						select : function(event, ui) {
							newElem = PrepareMailTag("1", "email", ui.item.value,
									ui.item.email, "");
							IsInsert_MsgCC = CheckMailReceiver(newElem);
							if (!IsInsert_MsgCC) {
								MsgCCGot.appendChild(newElem);
								document.getElementById("MsgCC").value = "";
								IsInsert_MsgCC = true;
							}
						},
						focus : function(event, ui) {
							return false;
						},
						close : function(event, ui) {
							if (IsInsert_MsgCC)
								document.getElementById("MsgCC").value = "";
							IsInsert_MsgCC = false;
						},
						appendTo : "#AutoCompleteResults"
					}).data("ui-autocomplete")._renderItem = function(ul, item) {
				return $("<li style='border-bottom:1px solid #e8e8ef'>")
				.data("ui-autocomplete-item", item)
				.append(
						"<a title='" + item.email + "'><table class='width100percent' width='100%' height='100%' style='display:inline-table;'><tr><td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.value
								+ "</td><td style='width:15%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.dept
								+ "</td><td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.title
								+ "</td><td style='max-width:45%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.email + "</td></tr></table></a>")
				.appendTo(ul);
			};
			var IsInsert_MsgBCC = false;
			$("#MsgBCC").autocomplete(
					{
						source : function(request, response) {
							$.ajax({
								type : 'post',
								url : "/ezEmail/autoCompleteList.do",
								dataType : "json",
								data : {
									value : request.term
								},
								success : function(data) {
									var susinList = data.susinList;
									response($.map(susinList, function(ul, item) {
										return {
											label : ul.name + " " + ul.title + " "
													+ ul.description + " "
													+ "<" + ul.mail + ">",
											value : ul.name,
											email : ul.mail,
											dept : ul.description,
											title : ul.title
										};
									}));

								}
							});
						},
						minLength : 2,
						selectFirst : false,
						select : function(event, ui) {
							newElem = PrepareMailTag("2", "email", ui.item.value,
									ui.item.email, "");
							IsInsert_MsgBCC = CheckMailReceiver(newElem);
							if (!IsInsert_MsgBCC) {
								MsgBCCGot.appendChild(newElem);
								document.getElementById("MsgBCC").value = "";
								IsInsert_MsgBCC = true;
							}
						},
						focus : function(event, ui) {
							return false;
						},
						close : function(event, ui) {
							if (IsInsert_MsgBCC)
								document.getElementById("MsgBCC").value = "";
							IsInsert_MsgBCC = false;
						},
						appendTo : "#AutoCompleteResults"
					}).data("ui-autocomplete")._renderItem = function(ul, item) {
				return $("<li style='border-bottom:1px solid #e8e8ef'>")
				.data("ui-autocomplete-item", item)
				.append(
						"<a title='" + item.email + "'><table class='width100percent' width='100%' height='100%' style='display:inline-table;'><tr><td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.value
								+ "</td><td style='width:15%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.dept
								+ "</td><td style='width:20%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.title
								+ "</td><td style='max-width:45%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;'>"
								+ item.email + "</td></tr></table></a>")
				.appendTo(ul);
			};
		})
	    
	    </script>
        <c:if test="${isCrossBrowser != true}">
        <script language="javascript" for="EzHTTPTrans" event="AttachAddFile(filename)">  
            attach_Add(filename);
        </script>
        <script LANGUAGE="javascript" FOR="EzHTTPTrans" EVENT="DbClListFile(mPath,mUserlist)">
            if(mPath != "")
                DownloadAttach(mPath);
        </script>
        </c:if>
	</head>
	<body id="parentBody" class="popup" style="overflow:hidden;">
	    <table id="normalScreen" class="layout">
	        <tr>
	            <td style="">
	                <div id="menu">
	                    <ul>
	                        <li><span onclick="Send_onClick()"><spring:message code='ezEmail.t674' /></span></li>
	                        <li><span onclick="Save_onClick('tempsave')"><spring:message code='ezEmail.t48' /></span></li>
	                        <!-- 재은 수정(편지지) -->
	                        <c:if test="${useLetter == 'YES'}">
	                        <li><span onclick="Letter_onClick()"><spring:message code='ezEmail.t824' /></span></li>
	                        </c:if>
	                        <li  style="display:none"><span onclick="Print_onClick()">
	                            <spring:message code='ezEmail.t546' /></span></li>
	                        <!-- <li><span onclick="LoadFormat_onClick()">
	                            <spring:message code='ezEmail.t824' /></span></li> -->
	                        <li style="display:none;"><span onclick="NameCertify_onClick()">
	                            <spring:message code='ezEmail.t331' /></span></li>
	                        <li><span onclick="Option_onClick()" id="Span1">
	                            <spring:message code='ezEmail.t353' /></span></li>
	                    </ul>
	                    <ul style="float:right;margin-right:50px">
	                    	<li class="sel securemail" style="background:none; border:none; padding:0px; padding-top:4px; display:none;">
	                        	<input type="checkbox" id="chkSecureMail" />
	                        	<label for="chkSecureMail" style="color:#333;margin-right:3px"><spring:message code='ezEmail.lhm63' /></label>	                        	
	                        </li>
	                        <li class="bar securemail" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default; display:none;">
	                            <img src="/images/pbar.gif">
	                        </li>
	                        <li id="menuTable" class="sel" style="background:none;border:0; padding:0; margin:0; vertical-align:top;">
	                            <select name="importantSelect" id="importantSelect" onchange="important_change()" style="vertical-align:top;">
	                                <option value="0"><spring:message code='ezEmail.t359' /> <spring:message code='ezEmail.t360' /></option>
	                                <option value="1" selected="selected"><spring:message code='ezEmail.t359' /> <spring:message code='ezEmail.t361' /></option>
	                                <option value="2"><spring:message code='ezEmail.t359' /> <spring:message code='ezEmail.t362' /></option>
	                            </select>
	                        </li>
	                        <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default;  display:none;">
	                            <img src="/images/pbar.gif">
	                        </li> 
	                        <li class="sel" style="background:none; border:none; padding:0px;">
	                            <select id="SelMailSign" onchange="MailSignSel()" style="vertical-align:top;">
	                                <option value='0' selected>
	                                    <spring:message code='ezEmail.t825' /></option>
	                                <option value='1'>
	                                    <spring:message code='ezEmail.t826' /></option>
	                                <option value='2'>
	                                    <spring:message code='ezEmail.t827' /></option>
	                                <option value='3'>
	                                    <spring:message code='ezEmail.t828' /></option>
	                            </select>
	                        </li>
	                        <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default;  display:none;">
	                            <img src="/images/pbar.gif">
	                        </li> 
	                        <li class="sel" style="background:none; border:none; padding:0px;">
	                            <select id="bodyType" style="vertical-align:top;" onchange="changeTextOption(this.value);">
	                            	<option value="0">HTML</option>
	                            	<option value="1">PlainText</option>
	                            </select>
	                        </li>
	                        <c:if test="${useOnlyInnerMail != 'YES'}">
	                        	<li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default; display:none;"><img src="/images/pbar.gif"></li>
	                        	<li class="sel" style="background:none; border:none; padding:0px;">
		                            <select style="vertical-align:top;" onchange="ChangeSenderName(this);">
		                            ${mailSendObject}
		                            </select>
		                        </li>
	                        </c:if>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span onclick="window_close()"></span></li>
	                    </ul>
	                </div>
	                
	                <script type="text/javascript" >
		      			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		      			
		      			if (useSecureMail == "YES") {
		    	        	$('.securemail').not('.bar').css('display', '');
		    	        	
		    	        	if (isSecureMail == "true") {
		    	        		document.getElementById("chkSecureMail").checked = true;
		    	        	}
		    	        }
		  			</script>
	            </td>
	        </tr>
	        <tr>
	            <td>
	                <table id="infoTable" class="popuplist" style="width:100%">
	                	<c:if test="${useFromAddress == 'YES'}">
		                	<tr id="MsgFrom_TR">
		                		<th style="text-align: center;">
		                        	<span style="width: 50px;"><spring:message code='ezEmail.lhm30' /></span>
		                        </th>
		                        <td colspan="3">
		                        	<div class="selectbox">
		                        		${fromAddressHtml}
		                        	</div>
		                        </td>
		                	</tr>
	                	</c:if>
	                    <tr id="MsgTo_TR">
	                        <th rowspan="2" style="width:1%">
	                            <a href="#" class="imgbtn"><span onclick="SelectReceiver_onClick('To')" style="width: 50px; text-align: center;">
	                                <spring:message code='ezEmail.t66' /></span></a>
	                            <div style="font-weight:normal; "><INPUT id="toMe" onclick="MailToMe_Onclick();" value="" type="checkbox" name="toMe" style="vertical-align: middle"/>
	                            <label for="toMe" style="margin-left:-3px;margin-top:1px; cursor:pointer" ><spring:message code='ezEmail.t99000010' /></label></div>
	                        </th>
	                        <td style="width: 76%">
	                            <input type="text" name="MsgTo" id="MsgTo" class="width100percent" onkeyup="return on_keydown(event)" onblur="onblurOnRecipientInputField(this.value)" tabindex="1" style="width: 100%;
	                                ime-mode: active;"/>
	                        </td>
	                        <td style="width: 1%; border-left: #ffffff 1px solid;">
	                            <select id="SelectToAddress" style="width: 106px;height:24px" onchange="simple_select('TO',this)">
	                            </select>
	                        </td>
	                        <td style="width: 1%; border-left: #ffffff 1px solid;">
	                            <a class="imgbtn imgbck"><span onclick="new_Address()">
	                                <spring:message code='ezEmail.t832' /></span></a>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td colspan="3">
	                        	<div class="viewtxtScroller">
	                            	<div id="MsgToGot" class="viewtxt"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr id="MsgCC_TR">
	                        <th rowspan="2">
	                            <a href="#" class="imgbtn"><span onclick="SelectReceiver_onClick('CC')" style="width: 50px; text-align: center;"> 
	                                <spring:message code='ezEmail.t594' /></span></a>
	                            <div onclick="MailBCCView(this);" style="cursor:pointer;" status="off" id="BccViewer">
	                            <img src="/images/ImgIcon/groupplus.gif" align="absmiddle"/><span><spring:message code='ezEmail.t562' /></span>
	                            </div>
	                        </th>
	                        <td style="width: 76%">
	                            <input type="text" name="MsgCC" id="MsgCC" class="width100percent" onkeyup="return on_keydown(event)" onblur="onblurOnRecipientInputField(this.value)" tabindex="2" style="width: 100%">
	                        </td>
	                        <td style="width: 100px; border-left: #ffffff 1px solid;">
	                            <select id="SelectCcAddress" style="width: 106px;height:24px" onchange="simple_select('CC',this)">
	                            </select>
	                        </td>
	                        <td style="width: 200px; border-left: #ffffff 1px solid;">
	                            <a class="imgbtn imgbck"><span onclick="new_Address()">
	                                <spring:message code='ezEmail.t832' /></span></a>
	                        </td>
	                    </tr>
	                    <tr id="MsgCC_TRu">
	                        <td colspan="3">
	                        	<div class="viewtxtScroller">
	                            	<div id="MsgCCGot" class="viewtxt"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr id="MsgBCC_TR"  style="display:none;">
	                        <th rowspan="2">
	                            <a href="#" class="imgbtn"><span onclick="SelectReceiver_onClick('BCC')" style="width: 50px; text-align: center;">
	                                <spring:message code='ezEmail.t562' /></span></a>
	                        </th>
	                        <td>
	                            <input type="text" name="MsgBCC" id="MsgBCC" class="width100percent" onkeyup="return on_keydown(event)" onblur="onblurOnRecipientInputField(this.value)" tabindex="3" style="width: 100%">
	                        </td>
	                        <td style="width: 100px; border-left: #ffffff 1px solid;">
	                            <select id="SelectBCCAddress" style="width: 106px;height:24px" onchange="simple_select('BCC',this)">
	                            </select>
	                        </td>
	                        <td style="width: 200px; border-left: #ffffff 1px solid;">
	                            <a class="imgbtn imgbck"><span onclick="new_Address()">
	                                <spring:message code='ezEmail.t832' /></span></a>
	                        </td>
	                    </tr>
	                    <tr id="MsgBCC_TRu" style="display:none;">
	                        <td colspan="3">
	                        	<div class="viewtxtScroller">
	                            	<div id="MsgBCCGot" class="viewtxt"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr style="height:33px">
	                        <th style="text-align: center;border-bottom:0px;">
	                            <spring:message code='ezEmail.t98' />
	                        </th>
	                        <td colspan="3" style="border-bottom:0px;">
	                            <input id="eSubject" name="eSubject" onkeyup="Subject_ReApply()" type="text" value="${encodedSubject}" tabindex="4" style="width: 100%;margin-top:-2px">
	                        </td>
	                    </tr>
	                </table>
	                <div id="messageBody" mbody="${body}" style="display: none">
	                </div>
	                <xmp id="xmpTo" style="display: none">${to}</xmp>
	                <xmp id="xmpCc" style="display: none">${cc}</xmp>
	                <xmp id="xmpBcc" style="display: none">${bcc}</xmp>
	                <xmp id="xmpSubject" style="display: none">${subject}</xmp>
	                <xmp id="test" style="display: none"></xmp>
	                <xmp id="xmpMailSign1" style="display: none">${mailSign1}</xmp>
	                <xmp id="xmpMailSign2" style="display: none">${mailSign2}</xmp>
	                <xmp id="xmpMailSign3" style="display: none">${mailSign3}</xmp>
	                <xmp id="bodyValue" style="display: none">${bodyValue}</xmp>
	                <xmp id="tempbody" style="display: none">${tempBody}</xmp>
	            </td>
	        </tr>
	        <tr>
	            <td style="height:380px;" id="EdtorSize">
	                <table style="width:100%;height:100%;">
	                    <tr>
	                        <td style="height:100%;">
	                            <iframe id="tbContentElement" class="viewbox" src="/ezEditor/selectEditor.do" name="message" style="padding:0; height:100%; width:100%; overflow:auto;margin-bottom:1px"></iframe>
	                        	<textarea id="plainTextArea" style="height:100%; width:100%; overflow-y:scroll; font-size:13px; box-sizing:border-box; display:none;"></textarea>
	                        </td>
	                    </tr>
                		<!-- 2017-01-24 이효민 : 쓰이는 곳 없어서 우선 주석처리
                		<tr id="HolderDocSend" style="display:none">
                            <td style="height:150px;">
                                <div id="docContentBorder" style="border: #ddd 1px solid; background-color: white;margin-top: 5px;overflow:auto;text-align:center;">
                                    <div id="docContent" style="height: 100%; margin:auto;width:620px;border:none;text-align:center;" ></div>
                                </div>
                            </td>
                        </tr> -->
	                </table>
	            </td>
	        </tr>
	        <tr style="display:none;">
	        <td style="padding-top: 0px">
	            <table class="file">
	                <tr>
	                    <td>
	                       <div id="attachedfileDIV" style="display:none;"></div>
	                    </td>
	                </tr>
	            </table>
	        </td>
	        </tr>
            <c:if test="${isCrossBrowser == true}">
	        <tr>
	            <td style="padding-top: 5px;height:20px;vertical-align:middle;">
	                <img src="/images/i_notice.gif" style="vertical-align: middle;padding-left:1px" /><span style="color:#3a76c3;height:18px;display:inline-block;margin-left:5px">${pAttachWarning}</span>
	                <iframe id="dadiframe" name="dadiframe" style="width:100%;border:0px" src="/ezEmail/dragAndDrop.do"></iframe>
	            </td>
	        </tr>
            </c:if>
            <c:if test="${isCrossBrowser != true}">
            <tr>
                <td height="20" style="padding-top: 10px;">
                    <span style="color: #3a76c3; font-weight: bold; height: 15px; display: inline-block;">
                        <img src="/images/i_notice.gif" style="vertical-align: middle" />&nbsp;${pAttachWarning}</span>
                    <table class="file" id="attachTable">
                        <tr>
                            <th><spring:message code='ezEmail.t557' /></th>
                            <td class="pos1">                                
                                <script type="text/javascript">EzHTTPTrans_ActiveX2("EzHTTPTrans","100%", "20");</script>                                
                            </td>
                            <td class="pos2">
                                <a href="#" class="imgbtn"><span id="btn_AttachAdd" onclick="attach_Add()"><spring:message code='ezEmail.t677' /></span></a>
                                <br>
                                <a href="#" class="imgbtn"><span id="btn_bigAttachAdd" onclick="bigattach_Add()"><spring:message code='ezEmail.t663' /></span></a>
                                <br>
                                <a href="#" class="imgbtn"><span id="btn_AttachDel" onclick="attach_Delete()"><spring:message code='ezEmail.t678' /></span></a></td>
                        </tr>
                    </table>
                </td>
            </tr>            
            </c:if>
	    </table>
	    <div id="AutoCompleteResults"></div>
	    <div id="sendScreen" style="display:none;">
	      <table width="100%" cellspacing="0" cellpadding="0" class="message" style="background-image:url(/images/email/mailsendnoti.gif)">
	        <tr>
	          <td style="text-align:right">
	              <table border="0" style="width:80%;">
	                <tr>
	                    <td>
	                        <div><spring:message code='ezEmail.t679' /></div>
	                        <div style="margin-top:3px;"><spring:message code='ezEmail.t680' /></div>
	                        <img src="/images/email/progress_img.gif" style="vertical-align:middle;margin-top:5px;"/>
	                    </td>
	                </tr>
	              </table>
	        </tr>
	      </table>
	    </div>
	    <iframe id="frmPrint" name="printname" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 5px; height: 5px;display:none"></iframe>
	    <iframe id="printtest" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 5px; height: 5px;display:none"></iframe>
	    <input type="hidden" name="eImportant" style="display: none;">
	    <iframe name="ifrm" src="about:blank" style="display:none"></iframe>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezEmail/mailInterUploadXCK.do?timestamp=${stateName}" target="ifrm" style="display:none;" >
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;" multiple="true" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="newguid" id="newguid" />
	        <input type="hidden" name="newid" id="newid" />
	        <input type="hidden" name="bigmaxsize" id="bigmaxsize" />
	        <input type="hidden" name="changesize" id="changesize" />
	        <input type="hidden" name="txtName" id="txtName" />
	        <input type="hidden" name="endDay" id="endDay" />
	    </form>
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	    <span class="loading_layer" style="z-index:6000;position:absolute;top:400px;left:300px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><span id="messageInSending"><spring:message code='ezEmail.t679' /></span><spring:message code='ezEmail.t680' /></span></span>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	    <script type="text/javascript">
	    	if (isCrossBrowser == 'true') {
	    		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 240 + "PX";
	    	} else {
	    		document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - $('#infoTable').height() - 160 + "PX";
	    	}
	    </script>
	</body>
	<xmp id="AttachXmlList" style="display:none;">
	   ${attach}
	</xmp>
</html>