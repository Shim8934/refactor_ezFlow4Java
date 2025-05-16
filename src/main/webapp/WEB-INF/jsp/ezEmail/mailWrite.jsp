<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
	    <title><spring:message code='ezEmail.t660' /></title>
	    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery.ui.all.css')}" type="text/css" />
		<c:if test="${shareId == null and options.useFromAddress == 'YES'}">
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
				width:calc(100% - 20px);
				overflow-y:auto;
				max-height: 19px;
				margin-bottom: 3px;
			}
			.viewtxtWrapper {
				display: table;
				height: 100%;
			}
			.viewtxt {
				min-height: 16px;
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
			.mailAddressAdd { position:relative; }
			.expnd { position:absolute; right:9px; top:50%; margin-top:-8px; cursor: pointer; content: url(/images/expnd.gif); }
			.cllps { position:absolute; right:9px; top:50%; margin-top:-8px; cursor: pointer; content: url(/images/cllps.gif); }
		</style>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.9.1.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/override.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/AttachMain_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/AttachItem_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email.autoComplete.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFilePick.js')}"></script>
        <c:if test="${options.isCrossBrowser != true}">
        	<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
        </c:if>
        <c:if test="${options.useHWP eq 'YES' and options.useHwpDownSecurity eq 'Y' and options.approvalFlag eq 'G'}">
	    	<script type="text/javascript" src="${options.webHWPUrl}js/hwpctrlapp/utils/util.js"></script>
			<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/hwpCtrlApp.js')}"></script>
    		<script type="text/javascript" src="${options.webHWPUrl}js/webhwpctrl.js"></script>
	    </c:if>
		<c:if test="${writetype.isReserve()}"> <!-- 예약발송수정에만 해당 js -->
			<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email.reserved.js')}"></script>
		</c:if>
	    <script type="text/javascript">
	    $(document).ready(function() {
	    	window.resizeTo(990, window.outerHeight);
        });

		window.addEventListener('beforeunload', function () {
			sessionStorage.removeItem('zipPassword');
		});
	    
	    var shareId = '<c:out value="${shareId}"/>';
	    var folderPath = "${drafts}";
		// cmd: cmdOwn 넘겨받은 그대로 넘김.
	    var g_cmd = '<c:out value="${cmdOwn}"/>';
	    var Org_cmd = '<c:out value="${cmdOwn}"/>';
	    var gg_cmd = '<c:out value="${cmdOwn}"/>';
		// writetype
		var writetype = {
			isEdit: <c:out value="${writetype.isEdit()}"/>, // true/false
			isResend: <c:out value="${writetype.isResend()}"/>, // var g_ReSendFlag = "${writetype == WriteType.RESEND_IN_SENT? 'Y' : 'N'}";
			isReserve: <c:out value="${writetype.isReserve()}"/>,
			useSaveDrafts: <c:out value="${writetype.useSaveDrafts()}"/>,
			useReplyMessage: <c:out value="${writetype.useReplyMessage()}"/>,
			useAppendAttach: <c:out value="${writetype.useAppendAttach()}"/>
		};
		var isReserve = writetype.isReserve? "YES" : "NO"; // newMail_Cross.js> Save_onClick_Complete 에서 사용해서..
		// loginInfo
		var g_servername = "${loginInfo.serverName}";
	    var tid = "${loginInfo.tenantId}";
	    var charsetControlFlag = "${loginInfo.lang}";
	    var userTimezone = "${loginInfo.offset}";
	    var isPrimary = "${loginInfo.primary}";
		// userInfo
	    var g_myname = "${userInfo.displayName}";
	    var g_sendername = "${userInfo.displayName}";
	    var g_myemail = "${userInfo.mail}";
	    var g_from = "${userInfo.mail}";
	    var from = "${from}";
	    var g_szUserID = "${userInfo.mailNickName}";
	    var g_companyID = "${userInfo.physicalDeliveryOfficeName}";
	    var g_senderinfo = "${userInfo.company}" + ", " + "${userInfo.description}" + ", " + "${userInfo.title}";
	    var g_DisplayNamePrintable = "${userInfo.displayName}";
		// general
		var previewMail = "${general.previewMail}";
	    var mailSendResult = "${general.mailSendResult}";
		var defaultCursorPosition = "${general.defaultCursorPosition}"; // 메일쓰기창 기본 커서 위치/ recipient: 받는사람, content : 내용
		// sign
	    var mailsel = "${sign.useFlag}";
		// color
	    var inMailColor = "${color.inmailColor}";
	    var outMailColor = "${color.outmailColor}";
		// message
	    var g_eImportance = "${message.importance}";
	    var g_bodyType = "${message.bodyType}";
	    var g_replySendTime = "${message.replySendTime}";
	    var g_replyReadTime = "${message.replyReadTime}";
	    var g_delaySendDate = "${message.delaySendDate}";
	    var g_url = "${message.url}"; // (String) uid or draftUID
	    var g_unread = "${message.unread}";
	    var gg_url = '<c:out value="${message.urlOwn}"/>'; // folderPath/uid (ex. "INBOX/4")
	    var iseachMail = "${message.isEach}";
	    var pCDOMessageId = '<c:out value="${message.cdoMessageID}"/>';
	    var defaultFontAndSize = "${message.defaultFontAndSize}";
	    var isSecureMail = "${message.isSecureMail}";
	    var securePassword = "${message.securePassword}";
	    var secureReadCount = "${message.secureMaxReadCount}";
	    var secureReadDate = "${message.secureMaxReadDate}";
		// options
		var g_ePostType = "${options.postType}";
	    var useMultiLangMail = "${options.useMultiLangMail}";
	    var g_charsetCheck = "${options.charsetCheck}";
	    var BigSizeAttachLimitCount = "${options.bigSizeAttachLimitCount}";
	    var BigSizeAttachDownloadLimitCount = "${options.bigSizeAttachDownloadLimitCount}";
	    var BigSizeAttachMBSize = "${options.bigSizeMailAttachLimit}";
	    var totBigSizeAttachMBSize = "${options.totBigSizeMailAttachLimit}";
	    var totSizeAttachMBSize = "${options.mailAttachLimit}";
	    var BigSizeAttachSize = BigSizeAttachMBSize * 1024 * 1024;
	    var totBigSizeAttachSize = totBigSizeAttachMBSize * 1024 * 1024;
	    var totSizeAttachSize = totSizeAttachMBSize * 1024 * 1024;
	    var FBigSizeAttachSize = parseInt(BigSizeAttachSize);
	    var FtotBigSizeAttachSize = parseInt(totBigSizeAttachSize);
	    var FtotSizeAttachSize = parseInt(totSizeAttachSize);
	    var BigSizeMailAttachDelDay = "${options.bigSizeMailAttachDelDate}";
	    var g_newid = "${options.newWindowId}";
	    var FileUploadtype = "${options.fileUploadType}";
	    var individualmailuser = "${options.individualMailUser}";
	    var pSecurity = '${options.security}';
	    var docHref = '<c:out value="${options.docHref}"/>';
	    var filedate = "${options.stateName}";
	    var _pBigAttachDownloadDay = "${options.bigAttachDownloadDay}";
	    var _pBigAttachDownloadPeriod = "${options.bigAttachDownloadPeriod}";
	    var InnerDomain = "${options.mailInnerDomain}";
	    var pUse_Editor = "${options.useEditor}";
	    var pDocID = '<c:out value="${options.docID}"/>';
	    var orgCompanyID = '<c:out value="${options.orgCompanyID}"/>';
	    var uploadCommonPath = "${options.uploadCommonPath}";
	    var uploadCommunityPath = "${options.uploadCommunityPath}";
	    var isCrossBrowser = "${options.isCrossBrowser}";
	    var useSecureMail = "${options.useSecureMail}";
	    var useMailWriteSenderClick = "${options.useMailWriteSenderClick}"; // 수아 수정
	    //업무일지 아이디
	    var journalId = '<c:out value="${options.journalId}"/>';
	    //근태관리 아이디
	    var attitudeId = '<c:out value="${options.attitudeId}"/>';
	    var attitudeIncludeMe = false;
	    var searchStartDate = '<c:out value="${options.searchStartDate}"/>';
	    var searchEndDate = '<c:out value="${options.searchEndDate}"/>';
	    // ezPMS 프로젝트 아이디
	    var ezPMSProjectId = "${options.ezPMSProjectId}";
	    // ezPMS 게시판 아이디
	    var ezPMSBoardId = "${options.ezPMSBoardId}";
	    var ezPMSRoleId = "${options.pmsRoleId}";
	    var ezPMSType = "${options.pmsType}";
	    var ezPMSToUserId = "${options.pmsToUserId}";
	    var ezPMSUserIdType = "${options.pmsUserIdType}";
	    var ezPMSTaskId = "${options.pmsTaskId}";
	    var isMailToMe = "<c:out value='${options.isMailToMe}'/>"; // 메일> 내게쓰기로 열었음
	    var receiverCount = 0;
        var groupAddressCountMap = {};
        var mailMaxReceiverCount = parseInt("${options.mailMaxReceiverCount}");
        var preview_g_url = "";
        var preview_g_url_delete = "";
        var preview_g_url_forRead = "";
        var previewChk = false;
        var ReadMailOpenNewWin;
        var g_useAdditionalInfo = Boolean(${options.useAdditionalInfo});
        /* 2023-05-15 김우철 - hwp결재문서를 배포용 문서로 저장하기 위한 변수 */
		var HwpCtrl;
		var useHwpDownSecurity = "<c:out value='${options.useHwpDownSecurity}'/>";
		var HwpSecurityNum = "<c:out value='${options.hwpSecurityNum}'/>";
		var isHwpCtrlOpen = false;

		/* 2023-07-04 김우철 - 전자결재 일반버전에서 테넌트 컨피그 useHwpDownSecurity값에 상관없이 대응하기 위한 변수 */
		var approvalFlag = "<c:out value='${options.approvalFlag}'/>";
		var useHWP = "<c:out value='${options.useHWP}'/>";

		var moduleEditor = "<c:out value='${options.moduleEditor}'/>";

	    var m_addrBook = null;
	    var m_rgParams4PostOption = new Array();
	    var g_xmldoc = createXmlDom();
	    var g_font = "<spring:message code='ezEmail.t409' />";
	    var g_isFormat = false;
	    var g_bDirty = false;
	    var g_bSended = false;
	    var g_szAuthor = "";
	    var g_szExchange = "exchange";
	    var g_simplemimeencoding = "7bit";
	    var g_simplemime = "";
	    var g_charset = "utf-8";
	    var g_encoding = "BASE64";
	    var g_showdisplay = "";
	    var g_showEnglishDisplay = "";
	    var objMHT;
	    var initFlag = false;
	    var Add_xmlhttp = "";
	    var mailpath = "";
	    var fileSize_add = "";
	    var fileName_add = "";
	    var fileType_add = "";
	    var bigtrue = 0;
	    var tmpXML = "";
	    var tempUrl = "";
	    var gubunlist = "1";
	    var tempvalue = "0";
	    var ua = navigator.userAgent;
		var securePasswordHint = "";
    	
    	// 웹폴더첨부용 변수
        var pickerData = "";
     	// 웹폴더첨부를 위한 파라미터 설정
		pickerData = {
				'mode'		: 'pickup', 					// pickup: 웹폴더 → 첨부
				'confirmBT' : fileUpload_ConfirmHandler, 	// 웹폴더첨부 확인 시 실행할 함수
				'cancelBT' : webFolderCancelBT 						// 웹폴더첨부 취소 시 실행할 함수
		};
     	
		<% // 승인메일 %>
		<c:if test="${options.useApprMail eq 'YES'}">
		var g_apprMail = false;
		var g_apprMailType = "";
		var g_apprMailApprover = "";
		</c:if>

		// email.autoComplete.js : jstl사용 중인 메시지(spring:message) → jsp에 변수로 분리함.
		var theadTr = "<li id='theadTr' onkeydown='keyEventNone(event)' style='background-color:#e9e9e9; border-bottom:1px solid #d1d1d1; height:22px; pointer-events: none;'><a><table class='width100percent' width='100%' height='100%' style='display:inline-table'><thead><tr>"
        + "<td style='width:20%; border:none; align:left'><spring:message code='ezAddress.t124' /></td>"
        + "<td style='width:20%; border:none; align:left'><spring:message code='ezApproval.t171' /></td>"
        + "<td style='width:15%; border:none; align:left'><spring:message code='ezPortal.t34' /></td>"
        + "<td style='max-width:45%; border:none; align:left'><spring:message code='ezEmail.t713' /></td>"
        + "</tr></thead></table></li></a>";

	    window.onload = function () {
	        // alias, 공용배포그룹 주소로 재전송 시 실제 sender 값 설정
	        if (["RESEND", "EDIT"].some(cmd => g_cmd.includes(cmd)) && g_from != from) {
	            var fromAddressElem = document.getElementById("fromAddressList").value;
	            fromAddressChange(fromAddressElem);
	        }

			// 2025.02.11 한슬기 : 나를 항상 참조에 포함 설정시
			if (g_cmd != "EDIT" && isMailToMe != "YES"){
				setSelfCcOrBcc();
			}

			/* 2025-01-08 홍승비 - 전자결재 메일 발송 > 웹한글문서 메일로 전송 시, 웹한글기안기의 로딩 순서를 보장하도록 수정 */
	    	// (BuildWebHwpCtrl() 함수 호출부를 Editor_Complete() 내부로 변경)
	    	
	        if (!CrossYN()) {
	            document.all.EzHTTPTrans.SetBigLang = "${loginInfo.lang}" == "1" ? 1 : 0;
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
	        if (document.getElementById("xmpSubject").outerText) // 값이 있으면 true
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
	        m_rgParams4PostOption["isSecureMail"] = isSecureMail;
	        m_rgParams4PostOption["secureMail"] = pSecurity;
	        
			var moduleType = "${options.moduleType}";
	        
	        if (moduleType == "attitudeAbsented") {
	        	getAttitudeAbsentedList("distinct");
	        } else if (moduleType == "ezPMS") {
	        	getPMSMemberList(ezPMSType);
	        }
	        
	        if (xmpTo.innerHTML != "") {
	            var xmpToValue = xmpTo.innerHTML;
                xmpToValue = ReplaceText(xmpToValue, "&amp;", "&");
                xmpToValue = ReplaceText(xmpToValue, "&lt;", "<");
                xmpToValue = ReplaceText(xmpToValue, "&gt;", ">");
                xmpToValue = ReplaceText(xmpToValue, "&#034;", "\"");
                // 세미콜론이 빠져있는 경우가 발견되어 추가함
                xmpToValue = ReplaceText(xmpToValue, "&#034", "\"");
                xmpToValue = ReplaceText(xmpToValue, "&#039;", "'");
                // 세미콜론이 빠져있는 경우가 발견되어 추가함
                xmpToValue = ReplaceText(xmpToValue, "&#039", "'");
	        	var moduleType = "<c:out value='${options.moduleType}'/>";

	        	if (moduleType == "attitudeAbsented") {
		        	getAttitudeAbsentedList("distinct");
		        } else if (moduleType == "ezPMS") {
		        	getPMSMemberList(ezPMSType);
		        }
	        	
	        	if (moduleType && moduleType == "poll") {
	        		var pollSendType = "<c:out value='${options.pollSendType}'/>";
		            var addrArr = getEmailAddressList2(xmpToValue, pollSendType);
		            addReceiverFromList(0, addrArr);
	        	} else {
		            var splitAddr = getEmailAddressList(xmpToValue);
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
	        
	        if (writetype.useAppendAttach && document.getElementById("AttachXmlList").innerHTML.trim() != "") {
	            AddAttachFileInfoXmlParsing(document.getElementById("AttachXmlList").innerHTML, true);
	        }
	        
	        SelMailSign.value = mailsel;
	        
			Simple_Choice();		
			var pSaveTime = "${general.keepDeleteLength}";
			var pSaveInterval = parseInt(pSaveTime) * 1000;
			if (pSaveInterval > 0)
			    window.setInterval("Mail_AutoSave()", pSaveInterval);
			
			var ua = navigator.userAgent;
			if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			    document.getElementById("file1").multiple = false;
			}
			
// 			if (document.getElementById("eSubject").value == "") {
// 			    document.getElementById("MsgTo").focus();
// 			}

			if (g_bodyType == "1") {
				document.getElementById("plainTextArea").style.display = "";
	        	document.getElementById("SelMailSign").disabled = true;
	        	dadiframe.document.getElementById("btnBigFileUpload").style.display = "none";
	        	document.getElementById("SelMailSign").classList.add("disabled"); // plainTextDisable style
			} else {
				document.getElementById("tbContentElement").style.display = "";
			}
			
			<c:if test="${message.overQuota == true}">
				// 전달의 경우 쿼터 초과 시 팝업창띄움
				alert(strLang241);
            </c:if>
            
            <c:if test="${shareId == null and options.useFromAddress == 'YES'}">
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
            <c:if test="${options.useMailAddrAutoComplete != 'YES'}">
            	$( "#MsgTo" ).autocomplete("disable");
            	$( "#MsgCC" ).autocomplete("disable");
            	$( "#MsgBCC" ).autocomplete("disable");
        	</c:if>
            
			$("textarea").keydown(function(e) {
				if (e.keyCode == 27) {
					return false;
				}
			});

			$(document).mouseup(function (e) {
				var clickedElementClass = e.target.className;
				if (!clickedElementClass.includes('view_more')) {
					hiddenMoreMenu();
				}
			});

			$(window.frames['tbContentElement']).mouseup(function (e) {
				hiddenMoreMenu(e);
			});

			// 2024-10-16 김은실 : [표준모듈] 메일쓰기창 To, Cc, Bcc 간 Drag & Drop 구현
			$("#MsgToGot, #MsgCCGot, #MsgBCCGot").sortable({
				connectWith: ".viewtxt"
			});

            var selectName = document.getElementById("mailSenderName");
            var selectedOption = selectName.options[selectName.selectedIndex];
            if (selectedOption.value != 'NONE') {
                g_showdisplay = selectedOption.text;
            }

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
        	$('.ui-autocomplete-input').autocomplete("close");
			
			mobileDistinction();
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
	            if ([189, 187, 220, 219, 221, 222, 186, 188, 190, 191, 32].includes(parseInt(window.event.keyCode)))
	                return false;
	        };
	    }
	    
//	    function JSleep(sTime) { // 쓰이지 않는 것으로 보임.
//	        var xmlhttp = createXMLHttpRequest();
//	        xmlhttp.open("GET", "remote/userSleep.aspx?time=" + sTime + "&newid=" + g_newid, false);
//	        xmlhttp.send();
//	        xmlhttp = null;
//	    }
	    var isClosedSave = false;
	    window.onbeforeunload = function () {
	        var retVal = "";
	        // ↑바로 위에서 초기화를 하는데 retVal != "0" 는 항상 true일 수 밖에 없음.
//	        if (retVal != "0" && g_url != "" && ("${folderPath}" != "Draft" && g_cmd != "EDIT")) {
            // 회신, 전달시 저장을 한 경우 g_cmd가 EDIT로 변경되어 g_cmd가 EDIT일 때는 삭제가 수행되지 않도록 g_cmd != "EDIT" 조건을 추가함
            // 단, 예약메일 수정의 경우에는 무조건 삭제되어야 하므로 writeType.isReserve 조건을 추가함
	        if (g_url && writetype.useSaveDrafts && !isDelted && (g_cmd != "EDIT" || writetype.isReserve)) { // 지우면 안됨: EDIT, EDIT_IN_DRAFTS
				delDrafts();
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

	            if(dadiframe.isfileup){
	                var pUrl = "/ezEmail/mailLargeFileUpload.do?CAPTION=" + encodeURIComponent("<spring:message code='ezEmail.t666' />") + "&MESSAGE=" + encodeURIComponent(strLang86) + "&BUTTONNAME=" + encodeURIComponent("<spring:message code='ezEmail.t38' />");
	                DivPopUpShow(330, 205, pUrl);
	                return;
	            }

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
	           	var tempSaveVal = Save_onClick("tempsave");
	            
	            // 2024.04.29 한슬기 : 제목이 입력되지 않았을 경우 화면이 닫히지 않도록 변경
	            if (tempSaveVal === "noSubject"){
	            	retVal = "2";
	            } else {
		            window.close();
	            }
	        }
	        
	        g_bDirty = false;
	        
	        // onbeforeunload 에서 같은 작업을 하니까 굳이 미리 할 필요 없지 않나?
//	        if (retVal == "1" && g_url != "" && ("${folderPath}" != "Draft" && g_cmd != "EDIT")) {
//	            delDrafts();
//	        }
	        
	        if (retVal != "2")
	            window.close();
	    }
	    var isDelted = false; // deleted의 오타 추정.
	    function delDrafts(del_uid) {
	    	var delDraftsURL = g_url;
	    	var delDraftsFiledate = filedate;
	    	
	    	if (typeof del_uid != "undefined"){
	    		delDraftsURL = del_uid;
	    		delDraftsFiledate = "";
	    	}
	    	
	        var xmlhttp = createXMLHttpRequest();
	        var requestUrl = "/ezEmail/delDrafts.do?itemid=" + encodeURIComponent(delDraftsURL) + "&delid=" + delDraftsFiledate;
	    	if (typeof(shareId) != "undefined" && shareId != "") {
	    		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	    	}
	        
	        xmlhttp.open("GET", requestUrl, true);
	        xmlhttp.send();
	        xmlhttp = null;
	        isDelted = true;
	    }
	    function delAttachListFile(filedate) {
	    	var xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("GET", "/ezEmail/delAttachListFile.do?&delid=" + filedate, true);
	        xmlhttp.send();
	        xmlhttp = null;
	        isDelted = true;
	    }
	    // display:none이고, 이후 풀어주는 곳도 없는 것으로 보임.
//	    var PrintEvent = false;
//	    function Print_onClick() {
//	        PrintEvent = true;
//	        document.getElementById("test").innerHTML = message.GetEditorContent();
//	        var obj = document.getElementById("frmPrint");
//	        var objDoc = obj.contentWindow || obj.contentDocument;
//	        objDoc.btnPrint_onClick();
//	    }
//	    var mail_formatlist_cross_dialogArguments = new Array();
//	    function LoadFormat_onClick() { // mailWrite=주석, mailEdit=display:none 되어 있음. → Letter_onClick()로 대체됨.
//	        mail_formatlist_cross_dialogArguments[1] = LoadFormat_onClick_Complete;
//	        mail_formatlist_cross_dialogArguments[2] = DivPopUpHidden;
//	        DivPopUpShow(460, 467, "mail_FormatList_cross.aspx");
//	    }
//	    function LoadFormat_onClick_Complete(strFileName) {
//	        DivPopUpHidden();
//	        if (typeof (strFileName) == "undefined")
//	            return;
//	        var fullPath = "/Email_Formats/" + strFileName;
//	        var xmpMailSign = "";
//	        try {
//	            xmpMailSign = message.CKEDITOR.instances.editor1.document.$.getElementById('MailSign').outerHTML;
//	        } catch (e) {
//	        }
//	        message.SetEditorContentURL_Format(fullPath);
//	        message.SetEditorContent(message.CKEDITOR.instances.editor1.document.$.body.innerHTML + xmpMailSign);
//	    }
	    function ReplaceText(orgStr, findStr, replaceStr) {
	        var re = new RegExp(findStr, "gi");
	        return (orgStr.replace(re, replaceStr));
	    }
	    function RenderFontStyleSet(BodyHtml) {
	        return "<span><P>&nbsp;</P><P>&nbsp;</P>" + BodyHtml + "</span>"
	    }
	    function Rebody() {
	    	var editorContentHTML = "";
	    	
	    	if (writetype.isResend && document.getElementById("bodyValue").innerHTML != "") { //재전송 시
	    		document.getElementById("bodyValue").innerHTML = document.getElementById("bodyValue").innerHTML.replace("id=\"MailSignSent\"", "id=\"MailSign\"");
	    		var indexSignValue = document.getElementById("bodyValue").innerHTML.indexOf("id=\"MailSign\"");
	    		
	            if (indexSignValue == -1) {
		    		switch (mailsel) {
		                case "0": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV>";
		                    break;
		                case "1": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>";
		                	tempvalue = "1";
		                    break;
		                case "2": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>";
		                    tempvalue = "1";
		                    break;
		                case "3": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML + "<P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>";
		                    tempvalue = "1";
		                    break;
		            }
	            } else {
	            	switch (mailsel) {
		                case "0": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML;
		                    break;
		                case "1": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML;
		                    tempvalue = "1";
		                    break;
		                case "2": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML;
		                    tempvalue = "1";
		                    break;
		                case "3": 
		                	editorContentHTML = document.getElementById("bodyValue").innerHTML;
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
	                case "0": 
	                	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV>" + bodyInnerHTML;
	                    break;
	                case "1": 
	                	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + bodyInnerHTML;
	                    tempvalue = "1";
	                    break;
	                case "2": 
	                	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + bodyInnerHTML;
	                    tempvalue = "1";
	                    break;
	                case "3": 
	                	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + bodyInnerHTML;
	                    tempvalue = "1";
	                    break;
	            }
	        }
	        else if (document.getElementById("tempbody").innerHTML != "") { //임시보관함에서 메일 더블클릭
				var indexSignValue = document.getElementById("tempbody").innerHTML.indexOf("id=\"MailSign\"");
	            if (indexSignValue == -1) {
	            	switch (mailsel) {
			            case "0": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV>";
			                break;
			            case "1": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>";
			                tempvalue = "1";
			                break;
			            case "2": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>";
			                tempvalue = "1";
			                break;
			            case "3": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML + "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>";
			                tempvalue = "1";
			                break;
		            }
	            } else {
	            	switch (mailsel) {
			            case "0": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML;
			                break;
			            case "1": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML;
			                tempvalue = "1";
			                break;
			            case "2": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML;
			                tempvalue = "1";
			                break;
			            case "3": 
			            	editorContentHTML = document.getElementById("tempbody").innerHTML;
			                tempvalue = "1";
			                break;
		            }
	            }
	            
	        }
	        else { //새메일쓰기
	            switch (mailsel) {
	                case "0": 
	                	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV>";
	                    break;
	                case "1": 
	                	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML;
	                	tempvalue = "1";
		                break;
		            case "2": 
		            	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML;
		                tempvalue = "1";
		                break;
		            case "3": 
		            	editorContentHTML = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML;
		                tempvalue = "1";
		                break;
	            }
	
	        }
	    	
	    	message.SetEditorContent(editorContentHTML);
	    	document.getElementById("plainTextArea").innerHTML = removeHTMLTag(editorContentHTML);
	    }
	
	    function MailSignSel() {
	        var sign = "";
	        var signcom = "";
        	var indexSignValue = message.GetEditorContent().indexOf("id=\"MailSign\"");
			var mailSignDiv = "<DIV id='MailSign'></DIV>";
	        mailSignDiv = editorPtagChk() + mailSignDiv;
	        
            if (indexSignValue == -1) {
                if (writetype.useReplyMessage) {
                    message.SetEditorContent(mailSignDiv + message.GetEditorContent());
                }
                else {
                    message.SetEditorContent(message.GetEditorContent() + mailSignDiv);
                }
            }

	        if (SelMailSign.value == "0") {
	            sign = "";
	            signcom = "";
	        }
	        else { // if (["1", "2", "3"].includes(SelMailSign.value))
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                sign = document.getElementById("xmpMailSign" + SelMailSign.value).innerHTML;
	            }
	            else {
	                sign = document.getElementById("xmpMailSign" + SelMailSign.value).innerText;
	            }
	        }

	        message.EditorElementSetHtml("MailSign", sign);
	    }
	
	    // 안쓰임.
//	    function MailSignLoad() {
//	        SelMailSign.value = "${mailSignSel}";
//	        MailSignSel();
//	    }
	
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
	        var OpenWin = window.open("/ezEmail/mailNewReceiverChoose.do?defaultwin=&type=" + type, "mail_foldermanage_Cross", GetOpenWindowfeature(1120, 720));
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
	            	if (!increaseReceiverCount()) {
	            		return;
	            	}
	            	
	                validDIV.appendChild(newElem);
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
			var alerted = false;
			var password = sessionStorage.getItem("zipPassword");
	        
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

					if (getNodeText(GetChildNodes(nodes[i])[6]) == "true" && !alerted) {
						alert("<spring:message code='ezEmail.zipEncryptedFile.001' />");
						alerted = true;
					}
	            }
	        }
	        
	        var requestUrl = "/ezEmail/mailInterAttachCK.do";
	        
	    	if (typeof(shareId) != "undefined" && shareId != "") {
	    		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	    	}
	        
	        xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("POST", requestUrl, false);
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
		            var serverName = "${serverName}"
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
			                aitem = "/ezEmail/downloadAttachInWriter.do?" 
			                				+ "mode=Attach"
			                				+ "&folderPath=" + encodeURIComponent(folderPath)
			                				+ "&filename=" + encodeURIComponent(filename);
			                
			                if (typeof(shareId) != "undefined" && shareId != "") {
			                	aitem += "&shareId=" + encodeURIComponent(shareId);
					    	}
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
	
	    /* 2018-12-10 홍승비 - IE에서 게시판, 커뮤니티 게시물 메일발송 시 다국어 폰트 적용 */
	    var pOrgAttachListXml = "";
	    var hwpChk = true;
	    function Editor_Complete() {
			/* 2025-01-08 홍승비 - 전자결재 메일 발송 > 웹한글문서 메일로 전송 시, 웹한글기안기의 로딩 순서를 보장하도록 수정 */
			// Editor_Complete() 함수 호출 시점은 iframe 태그 내부 "/ezEditor/selectEditor.do" 페이지의 로딩 시점에 의존함
			// useHwpDownSecurity가 Y일 때만 Whwp api 호출. 전자결재 일반버전에서는 useHwpDownSecurity의 값에 상관없이 Whwp api 호출하지 않음.
			<c:if test="${options.useHWP eq 'YES' and options.useHwpDownSecurity eq 'Y' and options.approvalFlag eq 'G'}">
				if (hwpChk) {
					// BuildWebHwpCtrl() 함수의 완료 후 콜백으로 다시 Editor_Complete()을 호출하여, 반드시 웹한글기안기 로딩이 끝난 시점에 한번 더 동작하도록 함
                    HwpCtrl = BuildWebHwpCtrl("hwpctrl", "${options.webHWPUrl}", function () {
	                    isHwpCtrlOpen = true;
	                    hwpChk = false;
	                    Editor_Complete();}); // Editor_Complete() 함수 내부에서 다시 호출된 Editor_Complete() 함수가 아래의 return 코드 이후 동작을 진행
                    return; // 반드시 return이 필요 (최초에 호출된 Editor_Complete()를 즉시 종료하기 위함으로, 중복 동작을 방지)
                }
			</c:if>
	        
	        if (initFlag == false) {
	            if (Org_cmd == "board") {
	                GetBoardItemInfo_New('<c:out value="${options.boardID}"/>', '<c:out value="${options.itemID}"/>', '<c:out value="${options.retransType}"/>', g_font);
	            }
	            else if (Org_cmd == "Community") {
	                GetBoardItemInfo_New3('<c:out value="${options.boardID}"/>', '<c:out value="${options.itemID}"/>', g_font);
	            }
	            
	            else if (Org_cmd == "report") {
	                GetUpmooItemInfo_New('<c:out value="${options.itemID}"/>', '<c:out value="${options.docHref}"/>');
	            }

	            else if (Org_cmd == "docsend" || Org_cmd == "docsenddoc") {
	                GetDocumentInfo(pDocID, docHref, '<c:out value="${options.docImagCnt}"/>', '<c:out value="${options.docTarget}"/>');
	            }
	            else if (Org_cmd == "docsendDotNet") {
	                GetDocumentInfo_DotNet(pDocID, docHref, '<c:out value="${options.docImagCnt}"/>', '<c:out value="${options.docTarget}"/>', '<c:out value="${options.docType}"/>');
	            }
	            else if (Org_cmd == "boardDotNet") {
	                GetBoardItemInfo_DotNet('<c:out value="${options.boardID}"/>', '<c:out value="${options.itemID}"/>', '<c:out value="${options.retransType}"/>');
	            }
	            else if (Org_cmd == "CommunityDotNet") {
	                GetBoardItemInfo_New3_DotNet('<c:out value="${options.boardID}"/>', '<c:out value="${options.itemID}"/>');
	            }	
	            //업무일지면...
	            else if (Org_cmd == "journal") {
	            	getJournalToMail();
	            	setOnclickFunction();
	            	return;
	            }
	            // ezPMS 게시판
	            else if (Org_cmd == "ezPMSBoard") {
	            	getEzPMSBoardToMail();
	            	setOnclickFunction();
	            	return;
	            }
	            else if (Org_cmd == "ezPMS") {
	            	getPMSMemberList(ezPMSType);
	            	setOnclickFunction();
	            	return;
	            }
	            else if (Org_cmd == "attitude") {
	            	getAttitudeToMail();
	            	setOnclickFunction();
	            	return;
	            }
	            else if (Org_cmd == "attitudeAbsented") {
	            	getAttitudeAbsentedList("duplicated");
	            	setOnclickFunction();
	            	return;
	            }
	            
	            initFlag = true;
	            pOrgAttachListXml = pAttachListXml;
	        }
	        
	        Rebody();
	        
	        g_originalHTML = message.GetEditorContent();
	        g_originalPlainText = document.getElementById("plainTextArea").value;
	        
	        setOnclickFunction();
	        
			// 2024.10.08 한슬기 :  메일쓰기화면 기본 커서 위치 설정. (recipient : 밭는사람, content : 내용, subject : 제목 / default : recipient)
			setDefaultCursorPosition();
	        
	    }
	    
	    /* 2020-09-11 홍승비 - 버튼에서 온클릭 이벤트를 분리하여 업무일지, ezPMS 등의 발송버튼 활성화되지 않는 오류 수정 */
	    function setOnclickFunction() {
	        return setTimeout(function () {
				if (writetype.isReserve) { // 예약발송수정
					document.getElementById("spanT48").setAttribute("onclick", "ReserverdMail_Save()");
				} else {
					document.getElementById("spanT674").setAttribute("onclick", "Send_onClick_preview()"); // 발송
					document.getElementById("spanT48").setAttribute("onclick", "Save_onClick('tempsave')"); // 저장
				}
	        }, 20);
	    }
		
	    function removeHTMLTag(html) {
	    	var resultStr = html;
    	    
    	    resultStr = resultStr.replace(/\r\n/gi, "\n");
    	    resultStr = resultStr.replace(/\n/gi, "");
    	    resultStr = resultStr.replace(/<p .*?>/gi, "<p>");
    	    resultStr = resultStr.replace(/<br .*?>/gi, "<br>");
    	    resultStr = resultStr.replace(/<hr .*?>/gi, "<hr>");
    	    resultStr = resultStr.replace(/<p>/gi, "\r\n");
    	    resultStr = resultStr.replace(/<br>/gi, "\r\n");
    	    resultStr = resultStr.replace(/<hr>/gi, "\r\n----------------------------------------------------------------------");
    	    resultStr = resultStr.replace(/<style .*?>/gi, "<style>");
    	    resultStr = resultStr.replace(/<style>.*?<\/style>/gi, "");
    	    resultStr = resultStr.replace(/<script .*?>/gi, "<script>");
    	    resultStr = resultStr.replace(/<script>.*?<\/script>/gi, "");
    	    resultStr = resultStr.replace(/<.*?>/gi, "");
			
    	    return  resultStr;
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
					
					// 2024.10.08 한슬기 :  메일쓰기화면 기본 커서 위치 설정. (recipient : 밭는사람, content : 내용, subject : 제목 / default : recipient)
					setDefaultCursorPosition();
				
					$("#eSubject").val("<spring:message code='ezJournal.t1' /><spring:message code='ezEmail.t674' /> : "+result.journalTitle);
					var journalContent = "<p></p><p></p><hr>" + (result.journalContent).replace(/&#39;/gi, "\'");
					
					switch (mailsel) {
		                case "0": 
		                	journalContent = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV>" + journalContent;
		                    break;
		                case "1": 
		                	journalContent = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + journalContent;
		                	tempvalue = "1";
			                break;
			            case "2": 
			            	journalContent = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + journalContent;
			                tempvalue = "1";
			                break;
			            case "3": 
			            	journalContent = "<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + journalContent;
			                tempvalue = "1";
			                break;
		            }
						
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
					$("#eSubject").val("<spring:message code='ezBoard.t342' /><spring:message code='ezEmail.t674' /> : " + result.title);
					var boardContent = "<p></p><p></p><hr>";
					boardContent += "<p><b>" + "<spring:message code='ezPMS.t210' /> " + "</b>" + result.writeDate.substring(0, result.writeDate.length - 2) + "<br/>";
					boardContent += "<b>" + "<spring:message code='ezPMS.t211' /> " + "</b>" + result.writerName + "<br/>";
					boardContent += "<b>" + "<spring:message code='ezPMS.t212' /> " + "</b>" + MakeXMLString(result.title) + "</p>";
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
		
/*		2023-07-21 이사라 - 본문타입 설정을 메일옵션으로 이동하여 메일쓰기창에서 아래 function 불필요하여 주석
	    function changeTextOption(bodyType) {
	    	if (bodyType == "1") {
	        	if (confirm("<spring:message code='ezEmail.lhm28' />")) {
	  	        	document.getElementById("plainTextArea").value =  message.GetEditorTextContent();
	        		document.getElementById("tbContentElement").style.display = "none";
					document.getElementById("plainTextArea").style.display = "";
	        		m_rgParams4PostOption["bodyType"] = document.getElementById("bodyType").value;
		        	document.getElementById("SelMailSign").disabled = true;
		        	dadiframe.document.getElementById("btnBigFileUpload").style.display = "none";
		        	document.getElementById("SelMailSign").classList.add("disabled"); // plainTextDisable style
		        	
		        	// 대용량 첨부파일 없애기
		        	dadiframe.btnfiledel('big');
	        	} else {
	        		document.getElementById("bodyType").options[0].selected = true;
	        	}
	    	} else {
	    		message.SetEditorTextContent(document.getElementById("plainTextArea").value);
	    		document.getElementById("tbContentElement").style.display = "";
				ckeditorReload();
				document.getElementById("plainTextArea").style.display = "none";
	    		m_rgParams4PostOption["bodyType"] = document.getElementById("bodyType").value;
        		document.getElementById("SelMailSign").disabled = false;
	        	document.getElementById("SelMailSign").classList.remove("disabled"); // plainTextDisable style remove
        		if(totBigSizeAttachMBSize == 0){
	        		dadiframe.document.getElementById("btnBigFileUpload").style.display = "none";
        		} else {
	        		dadiframe.document.getElementById("btnBigFileUpload").style.display = "";
        		}
	    	}
	    } */
	    
		function ckeditorReload() {
			if (/chrome/i.test(navigator.userAgent) && message.CKEDITOR) {
				try {
					message.CKEDITOR.instances.editor1.setMode("source");
					message.CKEDITOR.instances.editor1.setMode("wysiwyg");
				} catch (e) {}
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
		            // AppendFileAttachInfo(pAttachListXml);
		            dadiframe.fileupload2(pAttachListXml);
		        }
	        }
	    }
	
	    function DownloadAttach(DownloadUrl) {
	        AttachDownFrame.location.href = DownloadUrl;
	    }
		
	    function fromAddressChange(val) {
	    	//g_from = val;
	    	const lastIndex = val.lastIndexOf("||;");
            
            g_sendername = lastIndex == 0 ? g_myname : val.substring(0, lastIndex);
            g_from = val.substring(lastIndex + 3).trim();
	    }
	    	    
	    function GetDocumentInfo_DotNet(DocID, DocHref, ImagCnt, Target, docType) {
	        AttachFlag = true;
	        var docAttach = "";

	        if (DocHref.toLowerCase().indexOf(".doc") == -1 && DocHref.toLowerCase().indexOf(".hwp") == -1) {
	            if (DocHref == "IMAGE"  && docType.toLowerCase().indexOf("hwp") == -1) { // 2022-10-07 이사라 - 웹한글기안기 문서는 이미지 제외
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
	        if (Target == "APPROVALG")
	            xmlHTTP.open("GET", "${options.dotNetUrl}/myoffice/ezApprovalG/formContainer/aspx/aprattachMail.aspx?DocID=" + DocID, false);
	        else
	            xmlHTTP.open("GET", "${options.dotNetUrl}/myoffice/ezApproval/formContainer/aspx/aprattachMail.aspx?DocID=" + DocID, false);
	        xmlHTTP.withCredentials = true;
	        xmlHTTP.send();

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
	        xmlHTTP.open("GET", "${options.dotNetUrl}/myoffice/ezBoardSTD/interASP/GetItemInfo.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
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

	            xmlHTTP.open("GET", "${options.dotNetUrl}/myoffice/ezBoardSTD/interASP/GetItemAttachments.aspx?ItemID=" + pItemID + "&pMode=" + pRetransType + "&conLocation=" + encodeURIComponent(Rurl) + "&title=" + encodeURIComponent(getNodeText(SelectNodes(ReturnXML, "NODES/NODE/Title")[0])), false);
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
	        xmlHTTP.open("GET", "${options.dotNetUrl}/myoffice/ezCommunity/aspx/GetItemInfo.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
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

	            xmlHTTP.open("GET", "${options.dotNetUrl}/myoffice/ezCommunity/aspx/GetItemAttachments.aspx?ItemID=" + pItemID, false);
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
					companyId : '<c:out value="${options.companyId}"/>',
   					userName : '<c:out value="${options.searchUserName}"/>',
   					deptName : '<c:out value="${options.searchDeptName}"/>',
   					title : '<c:out value="${options.searchTitle}"/>',
   					deptId : '<c:out value="${options.searchDeptId}"/>',
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
						//2018-10-04 배현상, 근태관리 미입력자 메일 안내문구 삭제
						var resultHtml = "<hr>";
						
						resultHtml += "<p></p><p><span style='font-size:18px;'><strong>&nbsp;<spring:message code='ezAttitude.t75' /></strong></span></p><p></p>";
						resultHtml += "<table style='border-collapse:collapse; width:800px;'>";
						resultHtml += "<thead><tr>";
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'><spring:message code='ezAttitude.t133' /></th>" ;
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'><spring:message code='ezAttitude.t10' /></th>";
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'><spring:message code='ezAttitude.t11' /></th>";
						resultHtml += "<th style='text-align:left; border:1px solid #666; background-color: #f8f8fa;'><spring:message code='ezAttitude.t9' /></th>";
						resultHtml += "</thead><tbody>";
						
						result.list.forEach(function(vo, index) {
			    			resultHtml += "<tr><td style='border:1px solid #666'>" + vo.startDate+ " </td>";
			    			resultHtml += "<td style='border:1px solid #666'>" + vo.userName + "</td>";
			    			resultHtml += "<td style='border:1px solid #666'>" + vo.userTitle + "</td>";
			    			resultHtml += "<td style='border:1px solid #666'>" + vo.deptName + "</td></tr>";
			    		});
						
						resultHtml += "</tbody></table>";
						
						$("#eSubject").val("[<spring:message code='ezAttitude.t313'/>] " + searchStartDate + " ~ " + searchEndDate);
						
						switch (mailsel) {
		                case "0": 
			    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV>" + resultHtml);
		                    break;
		                case "1": 
			    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + resultHtml);
		                	tempvalue = "1";
			                break;
			            case "2": 
			    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + resultHtml);
			                tempvalue = "1";
			                break;
			            case "3": 
			    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + resultHtml);
			                tempvalue = "1";
			                break;
		            	}
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
	    			console.log(result.formVO.formHtml);
	    			var titleDate = "";
	    			var objDiv = $("<div></div>");
	    			var objTable = $("<table></table>").css({"clear":"both", "margin":"0px", "border-collapse":"collapse", "empty-cells":"show"});
	    			var objTr = $("<tr></tr>").append($("<th></th>").text("<spring:message code='ezAttitude.CSJ02'/>")).append($("<td></td>").text(result.attitudeVO.typeName));
	    			
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
	    			
	    			$("#eSubject").val("[<spring:message code='ezAttitude.CSJ01'/>] " + result.attitudeVO.typeName + "/ " + result.attitudeVO.writerDeptName + " " + result.attitudeVO.writerName + "/ " + titleDate + (result.attitudeVO.region != "" ? "/ " + result.attitudeVO.region : ""));
	    			
	    			objTable.find("#periodblock");
	    			objTable.find("#writerName").text(result.attitudeVO.writerName);
	    			objTable.find("#mobile").text(result.attitudeVO.mobile);
	    			objTable.find("#bizsub").text(result.attitudeVO.bizSub);
	    			objTable.find("#region").length == 0 ? "" : objTable.find("#region").text(result.attitudeVO.region);
	    			objTable.find("#content").html(result.attitudeVO.content);
	    			switch (mailsel) {
	                case "0": 
		    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'></DIV><p></p><p></p><hr><p></p><p><span style='font-size:18px;'><strong>&nbsp;<spring:message code='ezAttitude.CSJ01'/></strong></span></p><p></p>" + objDiv.html());
	                    break;
	                case "1": 
		    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign1").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + "<p></p><p></p><hr><p></p><p><span style='font-size:18px;'><strong>&nbsp;<spring:message code='ezAttitude.CSJ01'/></strong></span></p><p></p>" + objDiv.html());
	                	tempvalue = "1";
		                break;
		            case "2": 
		    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign2").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + "<p></p><p></p><hr><p></p><p><span style='font-size:18px;'><strong>&nbsp;<spring:message code='ezAttitude.CSJ01'/></strong></span></p><p></p>" + objDiv.html());
		                tempvalue = "1";
		                break;
		            case "3": 
		    			message.SetEditorContent("<P " + defaultFontAndSize + "><BR></P><P " + defaultFontAndSize + "><BR></P><DIV id='MailSign'>" + document.getElementById("xmpMailSign3").innerHTML + "</DIV>" + document.getElementById("bodyValue").innerHTML + "<p></p><p></p><hr><p></p><p><span style='font-size:18px;'><strong>&nbsp;<spring:message code='ezAttitude.CSJ01'/></strong></span></p><p></p>" + objDiv.html());
		                tempvalue = "1";
		                break;
	            	}
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
		
		function bodydragover(evt) {
				evt.dataTransfer.dropEffect = "none";
				evt.stopPropagation();
				evt.preventDefault();
		}
		
		/*
		   20190807 김수아 : 메일 작성 창의 미리보기 버튼 클릭 시
		*/
		function mailWritePreview() {
			if (Save_onClick_Complete.savemode == "tempsave" && MailStatus == "SEND" && !previewChk) { // 저장 중
				setTimeout(function() {
					mailWritePreview();
		        }, 1000);
			} else if (!previewChk){
				previewChk = true;
				Save_onClick('preview');
			}
		}

		function filePickerOpen() {
	    	filePick.open(pickerData);
	    }
	    
		function fileUpload_ConfirmHandler(selectedFileInfo) {
	        var webFolderFileList = JSON.parse(selectedFileInfo.fileList);
	    	var webFolderFileListCnt = webFolderFileList.length;
	    	
		    document.getElementById("mailPanel").style.display = "";
		    document.getElementById("loadingLayer").style.display = "";
		    document.getElementById("messageInSending").style.display = "none";
		    
			$.ajax({
				type : "GET",
				dataType : "JSON",
				async : true,
				url : "/ezCommon/attachWebFolderFile.do",
				data : {
					fileList: JSON.stringify(webFolderFileList),
					param:""
				},
				success : function(result) {
					if (result.status != "ERROR"){
						fileList = result.fileList;
						var pstrXML = "";
	
			            pstrXML += "<LISTVIEWDATA><HEADERS>";
			            pstrXML += "<HEADER><NAME>" + strLang1 + "</NAME><WIDTH>100</WIDTH></HEADER>";
			            pstrXML += "<HEADER><NAME>" + strLang3 + "</NAME><WIDTH>50</WIDTH></HEADER>";
			            pstrXML += "</HEADERS><ROWS>";
			            
			            for (var i = 0; i < fileList.length; i++) {
				            var filepath = fileList[i].downloadLink;
				            var filename = fileList[i].fileName;
				            var filesize = fileList[i].fileSize;
				            
				            if (filesize == 0) {
				            	alert(strLang167);
				            	break;
				            }
				
				            pstrXML += "<ROW><CELL><VALUE><![CDATA[" + filename + "]]></VALUE>";
				            pstrXML += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
				            pstrXML += "<DATA2><![CDATA[" + filepath + "]]></DATA2>";
				            pstrXML += "<DATA3></DATA3>";
				            pstrXML += "<DATA4>BOARD</DATA4>";
				            pstrXML += "<DATA5>N</DATA5>";
				            pstrXML += "<DATA6>" + filesize + "</DATA6>";
				            if (filesize > BigSizeAttachSize )
				                pstrXML += "<DATA7>Y</DATA7>";
				            else
				                pstrXML += "<DATA7>N</DATA7>";
				            pstrXML += "</CELL><CELL>";
				            pstrXML += "<VALUE>" + filesize + " Bytes" + "</VALUE>";
				            pstrXML += "</CELL></ROW>";
			            }
	
				        pstrXML += "</ROWS></LISTVIEWDATA>";
				        objXML = loadXMLString(pstrXML);
				        dadiframe.fileupload2(objXML);	    
				        
					} else {
						alert("<spring:message code='ezEmail.lhm14' />");
					}
			        document.getElementById("mailPanel").style.display = "none";
			        document.getElementById("loadingLayer").style.display = "none";	   
				}, error: function(error) {
					alert("<spring:message code='ezEmail.lhm14' />");
					return;
				}
	       });
	    }
		
		// 웹폴더첨부 취소 시 동작. 필요하다면 input file 부분을 초기화한다.
	    function webFolderCancelBT() {
	    	return;
	    }
	    
	    function mailTemplateLoadBtn() {
	    	DivPopUpShow(483, 495, "/ezEmail/userMailTemplateMain.do");
	    }
		
	    function mailTemplateSaveBtn() {
	    	DivPopUpShow(483, 145, "/ezEmail/saveUserMailTemplateMain.do");
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

		function hiddenMoreMenu() {
			var element = document.getElementById("layer_menu");
			if (element) {
				if (element.style.display !== 'none') {
					document.getElementById("view_more").classList.remove('on');
					element.style.display = 'none';
				}
			}
		}
	    
		// 2024.10.08 한슬기 : 메일쓰기화면 기본 커서 위치 설정. (recipient : 밭는사람, content : 내용, subject : 제목 / default : recipient)
	    function setDefaultCursorPosition(){
			// 커서를 받는사람에 위치시킴
			if (defaultCursorPosition == "recipient"){
				document.getElementById("MsgTo").focus();
			
			} else if (defaultCursorPosition == "content") {
				// 2025.05.16 한슬기 : 에디터에 커서를 위치시킴. 필요시 case를 추가하여 에디터별로 설정
				setTimeout(function() {
					switch (pUse_Editor){
						case "TAGFREE":
							// 태그프리
							var editorBody = document.querySelector('#tbContentElement')
									?.contentDocument?.querySelector('.xfeDesignFrame')
									?.contentDocument?.body;

							if (editorBody) {
								editorBody.focus();
							} else {
								console.warn("에디터 영역을 찾을 수 없습니다.");
							}
							break;
						case "KUKUDOCS":
							//쿠쿠닥스
							message.SetEditorFocus();
							break;

						default:
							//쿠쿠닥스
							message.SetEditorFocus();
							break;
					}
				   }, 500);

			} else if (defaultCursorPosition == "subject") {
				var inputValue = document.getElementById("eSubject").value;
			
				// 커서가 맨 뒤로 오도록 함
				document.getElementById("eSubject").focus();
				document.getElementById("eSubject").value = "";
				document.getElementById("eSubject").value = inputValue;
			
			}
	    }
	    
		// 수신자칸 : 접기, 펼치기 버튼
	    function changeMode(obj, className) {
			var mode = { expnd: {switch: 'cllps', height: '55px'},
						 cllps: {switch: 'expnd', height: '19px'} };
			obj.className = mode[className].switch;
			$(obj).siblings('.viewtxtScroller').css('max-height', mode[className].height);
	    }
		
		function mobileDistinction() {
  				var  userAgent = navigator.userAgent.toLowerCase();
			
			if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
				if (window.innerWidth > window.innerHeight) {
					document.getElementById("EdtorSize").style.height = 436 + "PX";
				}
			}
		}
	    </script>
        <c:if test="${options.isCrossBrowser != true}">
        <script language="javascript" for="EzHTTPTrans" event="AttachAddFile(filename)">  
            attach_Add(filename);
        </script>
        <script LANGUAGE="javascript" FOR="EzHTTPTrans" EVENT="DbClListFile(mPath,mUserlist)">
            if(mPath != "")
                DownloadAttach(mPath);
        </script>
        </c:if>
	</head>
	<body id="parentBody" class="popup mailWrite" style="overflow:hidden;">
	    <table id="normalScreen" class="layout">
	        <tr>
	            <td>
	                <div id="menu">
						<ul>
	                        <c:if test="${!writetype.isReserve()}">
	                            <li><span id="spanT674"><spring:message code='ezEmail.t674' /></span></li>
	                        </c:if>
	                        <li><span id="spanT48"><spring:message code='ezEmail.t48' /></span></li>
	                        <!-- <li  style="display:none"><span onclick="Print_onClick()">
	                            <spring:message code='ezEmail.t546' /></span></li> -->
	                        <!-- <li><span onclick="LoadFormat_onClick()">
	                            <spring:message code='ezEmail.t824' /></span></li> -->
	                        <!-- <li style="display:none;"><span onclick="NameCertify_onClick()">
	                            <spring:message code='ezEmail.t331' /></span></li> -->
	                        <li><span onclick="Option_onClick()" id="Span1">
	                            <spring:message code='ezEmail.t353' /></span></li>
	                        <li><span onclick="mailWritePreview()">
	                            <spring:message code='ezEmail.t487' /></span></li>
							<li class="view_more" onclick="toggleMoreMenu()"><span class="view_more" id="view_more"><img class="view_more" src="/images/ImgIcon/view_more.png"></span>
								<ul class="layer_select" id="layer_menu" style="display: none">
									<c:if test="${options.useLetter == 'YES'}">
										<li><span onclick="Letter_onClick()"><spring:message code='ezEmail.t824' /></span></li>
									</c:if>
									<li><span onclick="mailTemplateLoadBtn()">
										<spring:message code='ezEmail.kasMailTemplate01' /></span></li>
									<li><span onclick="mailTemplateSaveBtn()">
										<spring:message code='ezEmail.kasMailTemplate02' /></span></li>
								</ul>
							</li>
	                    </ul>
	                    <ul style="float:right;margin-right:50px">
	                    	<%-- <li class="sel securemail" style="background:none; border:none; padding:0px; padding-top:4px; display:none;">
	                        	<input type="checkbox" id="chkSecureMail" />
	                        	<label for="chkSecureMail" style="color:#333;margin-right:3px"><spring:message code='ezEmail.lhm63' /></label>	                        	
	                        </li>
	                        <li class="bar securemail" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default; display:none;">
	                            <img src="/images/pbar.gif">
	                        </li> --%>
	                        <li id="menuTable" class="sel" style="background:none;border:0; padding:0; margin:0; vertical-align:top;">
	                            <select name="importantSelect" id="importantSelect" onchange="important_change()" style="vertical-align:top;">
	                                <option value="0"><spring:message code='ezEmail.t359' /> <spring:message code='ezEmail.t360' /></option>
	                                <option value="1" selected="selected"><spring:message code='ezEmail.t359' /> <spring:message code='ezEmail.t361' /></option>
	                                <option value="2"><spring:message code='ezEmail.t359' /> <spring:message code='ezEmail.t362' /></option>
	                            </select>
	                        </li>
	                        <!-- <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default;  display:none;">
	                            <img src="/images/pbar.gif">
	                        </li> -->
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
	                        <!-- <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default;  display:none;">
	                            <img src="/images/pbar.gif">
	                        </li> -->
	                        <%-- <li class="sel" style="background:none; border:none; padding:0px;">
	                            <select id="bodyType" style="vertical-align:top;" onchange="changeTextOption(this.value);">
	                                <option value="0" <c:if test="${message.bodyType == '0'}">selected</c:if>>HTML</option>
                        		    <option value="1" <c:if test="${message.bodyType == '1'}">selected</c:if>>PlainText</option>
	                            </select>
	                        </li> --%>
	                        <input type="hidden" id="bodyType" name="bodyType" value="${message.bodyType}"/>
	                        <c:if test="${options.useOnlyInnerMail != 'YES' && shareId == null}">
	                        	<li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;cursor:default; display:none;"><img src="/images/pbar.gif"></li>
	                        	<li class="sel" style="background:none; border:none; padding:0px; width: 110px; ">
		                            <select id="mailSenderName" style="vertical-align:top; width: 100%; " onchange="ChangeSenderName(this);">
		                            ${general.mailSenderNm}
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
		      			
		      			/*if (useSecureMail == "YES") {
		    	        	$('.securemail').not('.bar').css('display', '');
		    	        	
		    	        	if (isSecureMail == "true") {
		    	        		document.getElementById("chkSecureMail").checked = true;
		    	        	}
		    	        }*/
		  			</script>
	            </td>
	        </tr>
	        <tr>
	            <td>
	                <table id="infoTable" class="popuplist" style="width:100%">
	                	<c:if test="${shareId == null and (options.useFromAddress == 'YES' or options.useDistributionSender == 'YES')}">
		                	<tr id="MsgFrom_TR">
		                		<th style="text-align: center;">
		                        	<span style="width: 50px;"><spring:message code='ezEmail.lhm30' /></span>
		                        </th>
		                        <td colspan="3">
		                        	<select id="fromAddressList" style="width: 100%" onchange="fromAddressChange(this.value);">
                                        <c:forEach var="alias" items="${fromAddressList}">
                                            <option value="${alias[2]}||;${alias[0]}" ${alias[0].equals(from) ? 'selected="selected"' : ''}>
                                                ${alias[2]} ${alias[0]}
                                            </option>
                                        </c:forEach>
                                    </select>
		                        </td>
		                	</tr>
	                	</c:if>
	                	<c:if test="${shareId != null}">
		                	<tr id="MsgFrom_TR">
		                		<th style="text-align: center;">
		                        	<span style="width: 50px;"><spring:message code='ezEmail.lhm30' /></span>
		                        </th>
		                        <td colspan="3" style="padding-left:10px;">
		                        	<span><c:out value="${sharedBox.shareName} <${sharedBox.shareMail}>" /></span>
		                        </td>
		                	</tr>
	                	</c:if>
	                    <tr id="MsgTo_TR">
	                        <th rowspan="2" style="width:1%">
	                            <a class="imgbtn"><span onclick="SelectReceiver_onClick('To')" style="width: 50px; text-align: center;">
	                                <spring:message code='ezEmail.t66' /></span></a>
	                            <div style="font-weight:normal; "><INPUT id="toMe" onclick="MailToMe_Onclick();" value="" type="checkbox" name="toMe" style="vertical-align: middle"/>
	                            <label for="toMe" style="margin-left:-3px;margin-top:1px; cursor:pointer" ><spring:message code='ezEmail.t99000010' /></label></div>
	                        </th>
	                        <td style="width: 76%">
								<input type="text" name="MsgTo" id="MsgTo" class="width100percent" onkeypress="return on_keydown(event)" onblur="onblurOnRecipientInputField(this.value)" tabindex="1" style="width: calc(100% - 27px); ime-mode: active;"><span class="btn_AutoCompleteResults"></span>
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
	                        <td colspan="3" class="mailAddressAdd">
	                        	<div class="viewtxtScroller">
	                            	<div id="MsgToGot" class="viewtxt"></div>
	                            </div>
	                            <img class="expnd" onclick="changeMode(this, this.className)" align="absmiddle">
	                        </td>
	                    </tr>
	                    <tr id="MsgCC_TR">
	                        <th rowspan="2">
	                            <a class="imgbtn"><span onclick="SelectReceiver_onClick('CC')" style="width: 50px; text-align: center;"> 
	                                <spring:message code='ezEmail.t594' /></span></a>
	                            <div onclick="MailBCCView(this);" style="cursor:pointer;" status="off" id="BccViewer">
	                            <img src="/images/ImgIcon/groupplus.gif" align="absmiddle"/><span><spring:message code='ezEmail.t562' /></span>
	                            </div>
	                        </th>
	                        <td style="width: 76%">
								<input type="text" name="MsgCC" id="MsgCC" class="width100percent" onkeypress="return on_keydown(event)" onblur="onblurOnRecipientInputField(this.value)" tabindex="2" style="width: calc(100% - 27px); ime-mode: active;"><span class="btn_AutoCompleteResults"></span>
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
	                        <td colspan="3" class="mailAddressAdd">
	                        	<div class="viewtxtScroller">
	                            	<div id="MsgCCGot" class="viewtxt"></div>
	                            </div>
	                            <img class="expnd" onclick="changeMode(this, this.className)" align="absmiddle">
	                        </td>
	                    </tr>
	                    <tr id="MsgBCC_TR"  style="display:none;">
	                        <th rowspan="2">
	                            <a class="imgbtn"><span onclick="SelectReceiver_onClick('BCC')" style="width: 50px; text-align: center;">
	                                <spring:message code='ezEmail.t562' /></span></a>
	                        </th>
	                        <td>
								<input type="text" name="MsgBCC" id="MsgBCC" class="width100percent" onkeypress="return on_keydown(event)" onblur="onblurOnRecipientInputField(this.value)" tabindex="3" style="width: calc(100% - 27px); ime-mode: active;"><span class="btn_AutoCompleteResults"></span>
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
	                        <td colspan="3" class="mailAddressAdd">
	                        	<div class="viewtxtScroller">
	                            	<div id="MsgBCCGot" class="viewtxt"></div>
	                            </div>
	                            <img class="expnd" onclick="changeMode(this, this.className)" align="absmiddle">
	                        </td>
	                    </tr>
	                    <tr style="height:33px">
	                        <th style="text-align: center;border-bottom:0px;">
	                            <spring:message code='ezEmail.t98' />
	                        </th>
	                        <td colspan="3" style="border-bottom:0px;">
	                            <input id="eSubject" name="eSubject" onkeyup="Subject_ReApply()" type="text" value="${message.encodedSubject}" tabindex="4" style="width: 100%;margin-top:-2px">
	                        </td>
	                    </tr>
	                </table>
	                
	                <xmp id="xmpTo" style="display: none"><c:out value='${message.to}'/></xmp>
	                <xmp id="xmpCc" style="display: none">${message.cc}</xmp>
	                <xmp id="xmpBcc" style="display: none">${message.bcc}</xmp>
	                <xmp id="xmpSubject" style="display: none">${message.subject}</xmp>
	                <!-- <xmp id="test" style="display: none"></xmp> -->
	                <xmp id="xmpMailSign1" style="display: none">${sign.content1}</xmp>
	                <xmp id="xmpMailSign2" style="display: none">${sign.content2}</xmp>
	                <xmp id="xmpMailSign3" style="display: none">${sign.content3}</xmp>
	                <xmp id="bodyValue" style="display: none">${message.bodyValue}</xmp>
	                <xmp id="tempbody" style="display: none">${message.tempBody}</xmp>
	            </td>
	        </tr>
	        <tr>
	            <td style="height:380px;" id="EdtorSize">
	                <table style="width:100%;height:100%;">
	                    <tr>
	                        <td style="height:100%;">
	                            <iframe id="tbContentElement" class="viewbox" src="/ezEditor/selectEditor.do?type=MAILWRITE" name="message" tabindex="5" 
	                            	style="display:none; padding:0; height:100%; width:100%; overflow:auto; margin-bottom:1px;"></iframe>
	                        	<textarea id="plainTextArea" style="display:none; height:100%; width:100%; overflow-y:scroll; font-size:13px; 
	                        		box-sizing:border-box; resize:none;"></textarea>
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
		<!-- #dadiframe로 대체된 것 같음.
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
	        </tr> -->
            <c:if test="${options.isCrossBrowser == true}">
	        <tr>
	            <td style="padding-top: 5px;height:20px;vertical-align:middle;">
	                <img src="/images/i_notice.gif" style="vertical-align: middle;padding-left:1px" /><span class="noti_txt" style="color:#3a76c3;height:18px;display:inline-block;margin-left:5px">${options.attachWarning}</span>
	                <c:choose>
	                	<c:when test="${shareId != null and shareId != ''}">
	                		<iframe id="dadiframe" name="dadiframe" style="width:100%;border:0px" src="/ezEmail/dragAndDrop.do?shareId=<c:out value='${shareId}'/>"></iframe>
	                	</c:when>
	                	<c:otherwise>
	                		<iframe id="dadiframe" name="dadiframe" style="width:100%;border:0px" src="/ezEmail/dragAndDrop.do"></iframe>
	                	</c:otherwise>
	                </c:choose>
	            </td>
	        </tr>
            </c:if>
            <c:if test="${options.isCrossBrowser != true}">
            <tr>
                <td height="20" style="padding-top: 10px;">
                    <span style="color: #3a76c3; font-weight: bold; height: 15px; display: inline-block;">
                        <img src="/images/i_notice.gif" style="vertical-align: middle" />&nbsp;${options.attachWarning}</span>
                    <table class="file" id="attachTable">
                        <tr>
                            <th><spring:message code='ezEmail.t557' /></th>
                            <td class="pos1">                                
                                <script type="text/javascript">EzHTTPTrans_ActiveX2("EzHTTPTrans","100%", "20");</script>                                
                            </td>
                            <td class="pos2">
                                <a class="imgbtn"><span id="btn_AttachAdd" onclick="attach_Add()"><spring:message code='ezEmail.t677' /></span></a>
                                <br>
                                <a class="imgbtn"><span id="btn_bigAttachAdd" onclick="bigattach_Add()"><spring:message code='ezEmail.t663' /></span></a>
                                <br>
                                <a class="imgbtn"><span id="btn_AttachDel" onclick="attach_Delete()"><spring:message code='ezEmail.t678' /></span></a></td>
                        </tr>
                    </table>
                </td>
            </tr>            
            </c:if>
	    </table>
	    <div id="AutoCompleteResults"></div>
	<!-- #loadingLayer로 대체된 것 같음.
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
	    </div> -->
	<!-- Print_onClick와 관련됨.
	    <iframe id="frmPrint" name="printname" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 5px; height: 5px;display:none"></iframe>
	    <iframe id="printtest" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 5px; height: 5px;display:none"></iframe>
		 -->
	    <input type="hidden" name="eImportant" style="display: none;">
	<!-- #dadiframe → fileupload() 로 대체된 것 같음.
	    <iframe name="ifrm" src="about:blank" style="display:none"></iframe>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezEmail/mailInterUploadXCK.do?timestamp=${options.stateName}" target="ifrm" style="display:none;" >
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;" multiple="true" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="newguid" id="newguid" />
	        <input type="hidden" name="newid" id="newid" />
	        <input type="hidden" name="bigmaxsize" id="bigmaxsize" />
	        <input type="hidden" name="changesize" id="changesize" />
	        <input type="hidden" name="txtName" id="txtName" />
	        <input type="hidden" name="endDay" id="endDay" />
	    </form> -->
	    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	    <span class="loading_layer" style="z-index:6000;position:absolute;top:50%;left:50%;transform: translate(-50%, -50%);display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><span id="messageInSending"><spring:message code='ezEmail.t679' /></span><spring:message code='ezEmail.t680' /></span></span>
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
	    	
	    	 // 메일> 내게쓰기로 열었음
	    	if (isMailToMe == 'YES') {
	         	document.getElementById('toMe').checked = 'checked';
	  	        MailToMe_Onclick();
         	}
	    </script>
	    <%-- 웹폴더 첨부 레이어팝업을 위한 태그 추가--%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_sub">&nbsp;</div>	
		<div class="layerpopup"  style="z-index:2000; position:absolute; display:none; overflow:hidden;" id="iFramePanel_sub">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer_sub"></iframe>
		</div>
	</body>
	<xmp id="AttachXmlList" style="display:none;">
	   ${message.attach}
	</xmp>
	<div id="hwpctrl"/>
</html>
