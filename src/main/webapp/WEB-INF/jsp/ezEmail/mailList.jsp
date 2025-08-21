<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezEmail.t177"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/previewmail.css')}">
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/search_mail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/NewMailList.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>		
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/date_component.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/leftmenu-util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tag.js')}"></script>
		<script type="text/javascript">
		    var g_bdraft = false;
		    var g_moveUrl = "<c:out value='${url}' escapeXml='false'/>";
		    var g_servername = "${serverName}";	
			var g_expath = "exchange";
			var g_userID = "${userId}";
		    var g_szRootFolderName = "<c:out value='${folderName}'/>";
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
		    var searchMode = ${not empty tagName};
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
		    var previewSubTree = "${mailGeneral.previewSubTree}";
		    var previewMailImage = "${mailGeneral.previewMailImage}";
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
		    var webSocket =  null;
		    var socketUserkey = "";
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
		    var currentMoverId = '';
		    var currentFixingId = null;
		    var currentFixingIdTemp = null;
		    var useReceivingChk = false;
		    var reSendMsg = "<spring:message code='ezEmail.t569' />";
		    var noReadMsg = "<spring:message code='ezPoll.t137'/>"; // 읽지 않음
		    var isSentItems = "${isSentItems}";
		    var importExportMode = false;
		    var useCountryIP = "${useCountryIP}";
		    var shareId = "${shareId}";
		    var deletePermission = "${deletePermission}";
		    var sendPermission = "${sendPermission}";
		    var managePermission = "${managePermission}";
		    var systemCountryCode = "${systemCountryCode}";
		    var useShowSystemCountry = "${useShowSystemCountry}";
		    var file 		 = new Array();
		    var useMailConfirm = "${useMailConfirm}";
		    var mailsearchDetail = "N";
		    var mailSearchDetailCheck = "N";// 메일 검색을 위해 height를 200을 줄였는지 체크하는 config
		    var pDeleteBoxID = "${pDeleteBoxID}";
		    var offsetMin = "${offsetMin}";
		    var searchCArray = new Array();
			var searchKArray = new Array();
			var startDate = "";
			var endDate = "";
			var listType = "mailList";
			var tagName = "<c:out value='${tagName}' />";
			var useMailTag = ${useMailTag};
			var mailSearchPeriod = "${mailGeneral.mailSearchPeriod}";
			var mailSearchPeriodLang = "";
			var mailSearchPeriodSDate = "";
			var searchRequiredKeyword = [];
			var searchRequiredCategory = [];
			var searchRequirement = [];
			let drawTagConsumeCallback;
			var usePreviewMail = ${usePreviewMail};
		    var url = "<c:out value='${url}'/>";
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
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });

		        $("#SdatepickerSimple").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });

		        $("#EdatepickerSimple").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });

		        switch (mailSearchPeriod) {
			        case 'oneWeek':
			        	mailSearchPeriodLang = "<spring:message code='ezEmail.pyy17' />";
			        	mailSearchPeriodSDate = "-1w";
			        	break;
			        case 'oneMonth' :
			        	mailSearchPeriodLang = "<spring:message code='ezEmail.pyy18' />";
			        	mailSearchPeriodSDate = "-1m";
			        	break;
			        case 'threeMonth' :
			        	mailSearchPeriodLang = "<spring:message code='ezEmail.pyy19' />";
			        	mailSearchPeriodSDate = "-3m";
			        	break;
			        case 'sixMonth' :
			        	mailSearchPeriodLang = "<spring:message code='ezEmail.ls001' />";
			        	mailSearchPeriodSDate = "-6m";
			        	break;
			        case 'oneYear' :
			        	mailSearchPeriodLang = "<spring:message code='ezEmail.ls002' />";
			        	mailSearchPeriodSDate = "-1y";
			        	break;
			        default :
			        	mailSearchPeriodLang = "<spring:message code='ezEmail.ls001' />";
			        	mailSearchPeriodSDate = "-6m";
		        }

		        document.getElementById("keywordSearch").placeholder= "<spring:message code='ezEmail.ls005' /> " + mailSearchPeriodLang + " <spring:message code='ezEmail.ls006' />";

		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', mailSearchPeriodSDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate);
		        $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";

		        $("#SdatepickerSimple").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#SdatepickerSimple").datepicker('setDate', mailSearchPeriodSDate);
		        $("#EdatepickerSimple").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#EdatepickerSimple").datepicker('setDate', NowDate);
		        $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
		    });
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		            closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
		            currentText: "<spring:message code='main.t0606' />",
		            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
		            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
		            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
		            weekHeader: "Wk",
		            dateFormat: "yy-mm-dd",
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: "show",
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    window.onload = function () {
		    	
		    	var listWidth = 0;
		    	$(document).on("click","#ifrmPreViewW_div",function(event){
		    		window.parent.event_secondRightClick();
		          })

		    	if (useReSend == "YES" && g_szRootFolderName == compareFolderName) {
		    		$('#liReSend').css('display', 'block');
		    	}
		    	
		    	if (g_moveUrl == 'receiveChk') {
		    		document.getElementById("reply").style.display = "none";
		    		document.getElementById("replyMenu").style.display = "none";
		    		document.getElementById("toggle_flag_btn").style.display = "none"; 
		    		document.getElementById("read_stat").style.display = "none";
		    		document.getElementById("unread_stat").style.display = "none";
		    		document.getElementById("deleteone").style.display = "none";
		    		document.getElementById("trashBtn").style.display = "none";
		    		document.getElementById("trashUnreadBtn").style.display = "none";
		    		$('#liReSend').css('display', 'block');
		    		document.getElementById("MailHeader").style.minWidth = "600px";
		    		document.getElementById("contentlist").style.minWidth = "600px";
		    		useReceivingChk = true;
		    		g_foldertype = g_moveUrl;
		    		p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
	                document.getElementById("select").selectedIndex = 3;
	                document.getElementById("select").item(3).selected = true;
		    	} else {
		    		document.getElementById("MailHeader").style.minWidth = "400px";
		    		document.getElementById("contentlist").style.minWidth = "400px";
		    	}
		    	
		        CurrentHeight = document.body.clientHeight;
		        CurrenWidth = document.body.clientWidth;
		        
		        switch (g_foldertype) {
		            case "allMail":
		                trashUnreadBtn.style.display = 'none';
		                importBtn.style.display = 'none';
		                break;
		            case "sent":
		                receivecheck.style.display = "";
		                reply.style.display = 'none';
		                replyMenu.style.display = 'none';
		                p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile2.xml";
		                p_ListOrderby = "http://schemas.microsoft.com/exchange/date-iso";
		                p_Listoption = "2";
		                document.getElementById("select").selectedIndex = 3;
		                document.getElementById("select").item(3).selected = true;
		                break;
		            case "draft":
		                reply.style.display = 'none';
		                replyMenu.style.display = 'none';
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
		            	g_moveUrl = "${sentFolderId}";
		            	break;
					case "tag":
						p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFileTagTable.xml";
						// 2024-08-13 안읽은 메일 일괄삭제 기능은 태그 지원 안함
                        // 태그는 기본적으로 읽은 메일이며, 중요도 높은 메일로 본 기능과 연관성이 매우 낮음
                        // 하지만 스팩 변경의 경우를 대비하여 function과 backend에는 코드 남겨둠
						document.getElementById("trashUnreadBtn").style.display = "none";
						importBtn.style.display = 'none';
						break;
		        }
		        
		        if (g_foldertype != "sent" && g_foldertype != "draft") {
		        	btnReject.style.display = "";
		        }
				
		        if (shareId != "" && managePermission != "Y") {
		        	btnReject.style.display = 'none';
		        }
		        
		        if (shareId != "" && sendPermission != "Y") {
		        	newMailBtn.style.display = 'none';
		        	reply.style.display = 'none';
		        	replyAllBtn.style.display = 'none';
		        	liReSend.style.display = 'none';
		        	relayBtn.style.display = 'none';
		        	receivecheck.style.display = 'none';
		        	replyAllMenu.style.display = 'none';
		        	relayMenu.style.display = 'none';
		        	replyMenu.style.display = 'none';
		        }
		        
		        if (shareId != "" && deletePermission != "Y") {
		        	importBtn.style.display = 'none';
		        	moveBtn.style.display = 'none';
		        	trashBtn.style.display = 'none';
		        	trashUnreadBtn.style.display = 'none';
		        	deleteone.style.display = 'none';
		        	deleteall.style.display = 'none';
		        	moveMenu.style.display = 'none';
		        	theBody.onkeyup = function(){};
		        	theBody.onkeydown = function(){};
		        }
		        
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
// 		                document.getElementById("PreviewRayerW").style.height = pMailPreHeightW + "px";
		                document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 80) + "px";
		                document.getElementById("PreW_subject").style.width = (CurrenWidth - 155) + "px";
		                
		                pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
		                pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);
		                
		                listWidth = CurrenWidth;
		            } else {
		                if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
		                    pMailListDiv_H = 50; pMailPreVDiv_H = 50;
		                }
		                
		                document.getElementById("MailListRayer").style.display = "inline-block";
		                document.getElementById("PreviewRayerH").style.display = "inline-block";
		
		                CurrenWidth = document.documentElement.clientWidth - 20;
		                CurrentHeight = document.documentElement.clientHeight - 92 - (document.getElementById("mainmenu").clientHeight - 28);
		                pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
		                pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;
		                document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
		                document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
		                document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		                document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
		                document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
						document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
		                document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH) + "px";
		                document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 2 + "px";
		                document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 88) + "px";
		                document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 152) + "px";
		                
		                pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
		                pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
		                
		                listWidth = pMailListWidthH;
		            }
		            
		        } else {
		            CurrentHeight = document.documentElement.clientHeight - 92 - (document.getElementById("mainmenu").clientHeight - 28);
		            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		            document.getElementById("MailListRayer").style.width = "100%";
		            document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";

	                listWidth = document.documentElement.clientWidth - 20;
		        }
		     	
		        if (listWidth <= 470) {
                    if (!useReceivingChk) {
                    	if (g_foldertype == "sent" || g_foldertype == "draft") {
                			p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile2_1.xml";
						} else if (g_foldertype == "tag") {
							p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFileTagTableShort.xml";
                		} else {
                        	p_HeaderViewXML = "/js/ezEmail/Controls_cross/" + g_userLang + "/viewXMLFile1_1.xml";
                		}
                    	
                        SmallSizeList = true;
                        OldSmallSizeList = true;
                    }
                }
		        
		        var HeaderObject = document.getElementById("MailHeader");
		        var ContentObject = document.getElementById("MailList");	        
		        HeaderIni(HeaderObject);       
		        GetListInfo(HeaderObject, ContentObject);	        
		        PreviewMode_ChangeBtn();
		        window_onunload_Event = true;
		        document.getElementById("select2").value = "<c:out value='${folderName}'/>";
		        $("#Sdatepicker").datepicker('disable');
			    $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
			    $("#Edatepicker").datepicker('disable');

				// 미리보기에서 태그 인풋 엔터시 추가
				$("#pre_h_tag_add, #pre_w_tag_add").on("keydown", function(e) {
					if (e.keyCode == 13) onEnterPreviewTagInput_previewShow();
				}).each(function(i, element) {
					inputUtil.makeNotAllowTyping(element, /[!@#$%^&()\\\/:*?"<>|'`]/g);
					inputUtil.makeReplaceTyping(element, /\s/g, '_');
				}).autocomplete({
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
					//autoFocus: false,
				}).on("input", function(e) {
					var pageType = pPreviewShow_HOW == "H" ? "_h" : "_w";
					var inputWrap = document.getElementById("input_wrap"+pageType);

					// 클래스에 "on"이 있으면 제거
					if (inputWrap.classList.contains("on")) {
						inputWrap.classList.remove("on");
					}
				});

				$("#input_wrap_h + .imgbtn, #input_wrap_w + .imgbtn").on("click", onEnterPreviewTagInput_previewShow);

				var layerSelect = null;
				var viewMore = null;

				function hideLayer(event) {
					document.querySelectorAll('.view_more.on').forEach(el => {
						el.classList.remove('on');
						el.querySelector('.layer_select').style.display = 'none';
					});
					/*if (!event || !event.target) {
						layerSelect.style.display = 'none';
						viewMore.classList.remove('on');
						return;
					}
					
					if (layerSelect && !event.target.closest('.layer_select')) {
						layerSelect.style.display = 'none'; 
						viewMore.classList.remove('on');
					}*/
				}

				function showLayer(layer, button) {
					if (button.classList.contains('on')) {
						hideLayer();
						button.classList.remove('on');
						return;
					}

					hideLayer();
					if (button.dataset.beforeShow) {
						window[button.dataset.beforeShow]();
					}

					var rect = button.getBoundingClientRect();
					
					layer.style.position = 'fixed';
					layer.style.display = 'block';
					layer.style.top = rect.bottom + "px";
					layer.style.left = rect.left + "px";
					button.classList.add('on');

				}

				function setUpLayerToggle() {
					/*viewMore = document.querySelector('.view_more');
					layerSelect = document.querySelector('.layer_select');
					if (!viewMore || !layerSelect) return;*/

					window.parent.parent.parent.frames['topFrame'].contentWindow.document.addEventListener('click', hideLayer);
					
					window.parent.frames['left'].document.addEventListener('click', hideLayer);

					document.addEventListener('click', hideLayer);
					
					Array.from(window.frames).forEach((frame) => {
						try {
							frame.document.addEventListener('click', hideLayer);
						} catch (e) {
							console.error('frame error :', e);
						}
					});

					document.querySelectorAll(".view_more").forEach(viewMore => {
						const layerSelect = viewMore.querySelector('.layer_select');

						if (!layerSelect) {
							return;
						}

						// keep_alive 클래스가 있으면 클릭해도 사라지지 않도록 함
						if (layerSelect.classList.contains('keep_alive')) {
							layerSelect.addEventListener('click', (event) => {
								event.stopPropagation();
							});
						}

						viewMore.addEventListener('click', (event) => {
							event.stopPropagation();
							showLayer(event.currentTarget.querySelector('.layer_select'), event.currentTarget);
						});
					});
				}

				setUpLayerToggle();

				if (useMailTag) {
					const labelInput = document.getElementById('label-input');
					// 입력 시 특수문자 입력 못하도록 함
					inputUtil.makeNotAllowTyping(labelInput, /[!@#$%^&()\\\/:*?"<>|'`]/g);
					// 띄어쓰기 입력 시 언더바로 치환
					inputUtil.makeReplaceTyping(labelInput, /\s/g, '_');
					inputUtil.addOnEnterEvent(labelInput, addLabel);
					reloadTagsForLabelLayer();
					window.addEventListener('message', event => {
						if (event.data.ajaxUrl === 'getUserTagList') {
							drawTagsToLabelLayer(event.data.tags);

							if (event.data.reloadPrev) {
								prevShow();
							}

							if (event.data.reloadList) {
								MailListRefresh();
							}
						}
					});
				}
			}
		    
		    $(document).ready(function() {
		    	var clickOutside;
		    	
		      // 2022-11-02 이사라 - [닷넷연동] 메일 가져오기 실행 시 분기처리 필요하여 추가
		      <c:if test="${!isDotNetIntegration}">
		    	if (navigator.userAgent.toLowerCase().indexOf("msie") != -1 || (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1)) { 
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame']?.document);
		    	} else {
		    		clickOutside = $(window.parent.parent.parent.frames['topFrame']?.contentWindow.document);
		    	}	    	
		    	
		    	clickOutside.mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		      </c:if>
		    	
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
		    	
		    	var dragDropAreaElmt = document.getElementById("dragDropArea");
				dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
				dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
				dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
		    });
		    
		    function ReSendWithURLOnly(pURL) {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        if (conWidth > 890)
		            conWidth = 890;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px,width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
		        var requestUrl = "/ezEmail/mailWrite.do?url=" + encodeURIComponent(pURL) + "&cmd=RESEND";
		        
		        if (shareId != "") {
		        	requestUrl += "&shareId=" + encodeURIComponent(shareId);
		        }
		        
		        window.open(requestUrl, "", feature);
		    }

		    // 스크롤을 맨 위로 이동시키는 함수
            function scrollToTop() {
                $('#contentlistDiv').scrollTop(0);
            }
		    
		    function mailGeneralSave() {
		    	// 2022-12-29 이사라 : Search 후 페이지를 벗어날 때 검색조건을 비움
		    	searchRequiredKeyword = [];
		    	searchRequiredCategory = [];

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
				createNodeAndInsertText(xmlpara, objNode, "INMAILBOX", "YES");
	            createNodeAndInsertText(xmlpara, objNode, "LISTCOUNT", document.getElementById("MailList").getAttribute("listpageCount"));
	            createNodeAndInsertText(xmlpara, objNode, "REFRESHINTERVAL", "${mailGeneral.refreshInterval}");
	            createNodeAndInsertText(xmlpara, objNode, "KEEPDELETELENGTH", "${mailGeneral.keepDeleteLength}");
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWMODE", _pPreview);
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWWLIST", parseInt(pMailListDiv));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWWCONTENT", parseInt(pMailPreVDiv));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWHLIST", parseInt(pMailListDiv_H));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWHCONTENT", parseInt(pMailPreVDiv_H));
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWSUBTREE", previewSubTree);
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWMAILIMAGE", previewMailImage);
	            createNodeAndInsertText(xmlpara, objNode, "PREVIEWMAIL", "${mailGeneral.previewMail}");
	            createNodeAndInsertText(xmlpara, objNode, "MAILSEARCHPERIOD", mailSearchPeriod);
	            createNodeAndInsertText(xmlpara, objNode, "MAILSENDRESULT", "${mailGeneral.mailSendResult}");
	            createNodeAndInsertText(xmlpara, objNode, "TEXTOPTION", "${mailGeneral.textOption}");
	            createNodeAndInsertText(xmlpara, objNode, "DEFAULTCURSORPOSITION", "${mailGeneral.defaultCursorPosition}");
	            createNodeAndInsertText(xmlpara, objNode, "DEFAULTSEPARATESEND", "${mailGeneral.defaultSeparateSend}");
				createNodeAndInsertText(xmlpara, objNode, "EDITORFONTFAMILY", "${mailGeneral.editorFontFamily}");
				createNodeAndInsertText(xmlpara, objNode, "EDITORFONTSIZE", "${mailGeneral.editorFontSize}");
				createNodeAndInsertText(xmlpara, objNode, "SELFCCOPTION", "${mailGeneral.selfCcOption}");
	            
	            xmlhttp.open("POST", "/ezEmail/mailGeneralSave.do", true);
	            xmlhttp.onreadystatechange = function() {
		        	if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
		        	}
	            }
	            xmlhttp.send(xmlpara);		  
		    }
		    
		    var Save_unloadSave = false;
		    
		    function Window_onunload() {
		        console.log("Window_onunload started. Save_unloadSave=" + Save_unloadSave);
		        
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
		        	if($("#moreSearch").css("display") == "none"){ 
						start_search2();
		        	} else {
		        		set_searchKey();
		        	}
		            
		        }
		    }
		    
		    var searchFromList = false;
		    function start_search2() {
		    	searchCArray = [];
		    	searchKArray = [];
		        ContextMenuHidden();
		    	searchMode = true;
		        var inputkeyword = document.getElementsByName('keyword').item(0);

		        if(inputkeyword.value.length == 1) {
		            alert("<spring:message code='ezSystem.yja01' />");
		            return;
		        }

		        if (inputkeyword.value.indexOf("%") != -1) {
		            alert("'%'" + strLang148);
		            return;
		        }
		        
		        if (inputkeyword.value == "") {
		        // 2022-12-29 이사라 : 기본검색 시 검색기간을 추가하여 keyword 없이도 검색이 가능하도록 수정
		        //    alert(strLang254);
		        //    return;
		        }
		        
		        startDate = $("#SdatepickerSimple").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
		        endDate = $("#EdatepickerSimple").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

		        var searchField = document.getElementById("searchCheck");
		        SearchKeyword = searchField.value + "=" + inputkeyword.value;
		        
		        if (inputkeyword.value){
		      		searchCArray.push(TrimText(searchField.value));
		  			searchKArray.push(TrimText(inputkeyword.value));
	    		}
		        mailsearchDetail = "N";
		        
		        goToPageByNum("1");
		        scrollToTop();

				try {
					if (document.getElementById("HeaderAllCheckBox") != null)
						document.getElementById("HeaderAllCheckBox").checked = false;
				} catch (e) {console.log(e);}
		    }
		    
		    function start_search() {
		    	mailsearchDetail = "Y";
		    	ContextMenuHidden();
		    	searchMode = true;
		        listContentArry = new Array();
		        listEventCheckbox = false;
		        PressShiftKey = false;
		        PressCtrlKey = false;
		        
		        if (!searchKArray) {
		            alert(strLang254);
		            return;
		        }

		        if (g_searchHttp != null)
		            return;

		        resultCount.innerHTML = "";
		        recordCount = 0;

		        var sYear, sMonth, sDay, eYear, eMonth, eDay, sTime, eTime;
		        var i;
		        var bError = false;
		        startDate = "", endDate = "";

		        if (usepostDate) {
		            startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
		            endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

		            var sDate = new Date(startDate.split(' ')[0].split('-')[0], startDate.split(' ')[0].split('-')[1], startDate.split(' ')[0].split('-')[2]);
		            var eDate = new Date(endDate.split(' ')[0].split('-')[0], endDate.split(' ')[0].split('-')[1], endDate.split(' ')[0].split('-')[2]);

		            if (startDate > endDate) {
		                alert(strLang312);
		                return;
		            }
		        }

		        var baseURL = document.location.protocol + "//" + g_servername + "/" + g_expath + "/" + g_userID + "/";

		        var sMailFolder = TrimText(select2.value);
		        ShowMailProgress();
		        goToPageByNum("1");
		        scrollToTop();
		    }
		    
		    function searchInThisBoxByName() {
		    	searchMode = true;
		        var keywordFromList = "";
		        searchCArray = [];
		    	searchKArray = [];

                // default 검색기간 지원 start
                startDate = $("#SdatepickerSimple").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
                endDate = $("#EdatepickerSimple").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

                var sDate = new Date(startDate.split(' ')[0].split('-')[0], startDate.split(' ')[0].split('-')[1], startDate.split(' ')[0].split('-')[2]);
                var eDate = new Date(endDate.split(' ')[0].split('-')[0], endDate.split(' ')[0].split('-')[1], endDate.split(' ')[0].split('-')[2]);
                // default 검색기간 지원 end

		        if (isSentItems == "true") {
		    		var receiver = currentFixingId.cells[5].getAttribute('data-name');
		    		
		    		if (receiver.indexOf(';') != -1) {
			    		receiver = receiver.split(';')[0];
		    		} else {
		    			receiver = currentFixingId.cells[5].getAttribute('data-name');	
		    		}
		    		
		    		if (receiver.indexOf('\"') != -1) {
		    			keywordFromList = receiver.replace(/\"/g,"");
		    		} else {
		    			keywordFromList = receiver;
		    		}
		    		
		    	} else {
		    		keywordFromList = currentFixingId.cells[5].getAttribute('data-name');
		    		
                    if (keywordFromList.indexOf('\"') != -1) {
                        keywordFromList = keywordFromList.replace(/\"/g,"");
                    }		    		
		    	}
		       
		    	
		    	if (g_foldertype != "sent" && g_foldertype != "draft") {
		    		$("#searchCheck").val("FROM").prop("selected", true);
		    	} else {
		    		$("#searchCheck").val("RECEIVE").prop("selected", true);
		    	}

		    	var searchField = $("#searchCheck").val();

		    	var inputkeyword = document.getElementsByName('keyword').item(0);
		    	inputkeyword.value = keywordFromList;
		    	 
		    	var searchField = document.getElementById("searchCheck");
		        SearchKeyword = searchField.value + "=" + inputkeyword.value;
		        
		        if (inputkeyword.value != null){
		      		searchCArray.push(TrimText(searchField.value));
		  			searchKArray.push(TrimText(inputkeyword.value));
	    		}
		    	
		    	SearchKeyword = searchField + "=" + inputkeyword.value;
		        goToPageByNum("1");
		        scrollToTop();
		    	
		    }
		    
		    function searchAllBoxByName() {
		        var keywordFromList = "";

                // default 검색기간 지원 start
		        startDate = $("#SdatepickerSimple").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
                endDate = $("#EdatepickerSimple").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

                var sDate = new Date(startDate.split(' ')[0].split('-')[0], startDate.split(' ')[0].split('-')[1], startDate.split(' ')[0].split('-')[2]);
                var eDate = new Date(endDate.split(' ')[0].split('-')[0], endDate.split(' ')[0].split('-')[1], endDate.split(' ')[0].split('-')[2]);
                // default 검색기간 지원 end
		        
		        if (isSentItems == "true") {
		    		var receiver = currentFixingId.cells[5].getAttribute('data-name');
		    		
		    		if (receiver.indexOf(';') != -1) {
			    		receiver = receiver.split(';')[0];
		    		} else {
		    			receiver = currentFixingId.cells[5].getAttribute('data-name');	
		    		}
		    		
		    		if (receiver.indexOf('\"') != -1){
		    			keywordFromList = receiver.replace(/\"/g,"");
		    		} else {
		    			keywordFromList = receiver;
		    		}
		    		
		    	} else {
		    		keywordFromList = currentFixingId.cells[5].getAttribute('data-name');
		    	}
		    	
		        if (g_foldertype != "sent" && g_foldertype != "draft") {
		    		$("#searchCheck").val("FROM").prop("selected", true);
		    	} else {
		    		$("#searchCheck").val("RECEIVE").prop("selected", true);
		    	}
		        
		        var searchField = $("#searchCheck").val();
				searchFromList = true;
		    	
	            try {
	                var url = "/ezEmail/mailSearchView.do?keywordFromList=" + encodeURIComponent(keywordFromList) 
	                		+ "&searchCheck=" + encodeURIComponent(searchField) 
	                		+ "&searchFromList=" + encodeURIComponent(searchFromList);
	                
	                if (shareId != "") {
	                	url += "&shareId=" + encodeURIComponent(shareId);
	                }
	                
	                parent.document.querySelector("iframe[name=right]").src = url;
	            } catch (e) { }
	            
	            var inputkeyword = document.getElementsByName('keyword').item(0);
		    	inputkeyword.value = keywordFromList;
	            
		        SearchKeyword = searchField + "=" + inputkeyword.value;
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

                if (typeof folderTotalCount === "undefined" || folderTotalCount === "") {
                	setTimeout (function() {
                		mailbox_export();
                    }, 1000);
                } else {
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
					} else {
						if (confirm("<spring:message code='ezEmail.lhm36' />")) {
							mailbox_export_start();
						}
					}
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

                    if (state == "CANCEL") {
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
	            
				var folderPath = url == 'receiveChk' ? 'Sent' : url;
				
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : requestUrl,
					data : { folderPath : folderPath, userkey : socketUserkey},
					error : function() {
						alert("<spring:message code='ezEmail.ls011' />");
					}
				});
		    }
		    
		 	// 메일박스 가져오기
			function mailbox_attach_import(pwd, tempId, userkey) {
				var encryptPw = (typeof pwd != "undefined") ? pwd : "";
		    	var path = (typeof tempId != "undefined") ? tempId : "";
		    	var tempname = "";
	            socketUserkey = mailbox_getUserKey();
		        
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
			
	            var curr = "";
	            
	        	ShowMailProgressNew();
	            if (path != "") {
	            	ShowPercent(dec);
	            } else {
		            ShowPercent(uploading);
	            }
	            mailboxProgressFun(true, socketUserkey, mailboxImportStateHandler);
            	
	            var frm = document.getElementById("importMailboxform");
	            var requestUrl = "/ezEmail/mailboxImportZip.do?folderPath="
					+ encodeURIComponent("<c:out value='${url}'/>") 
					+ "&userkey=" + encodeURIComponent(socketUserkey)
					+ "&encryptPw=" + encodeURIComponent(encryptPw)
					+ "&tempId=" + encodeURIComponent(path);
		        
		        if (typeof(shareId) != "undefined" && shareId != "") {
		        	requestUrl += "&shareId=" + encodeURIComponent(shareId);
		    	}
	            
				frm.action = requestUrl;
				frm.submit();
			}
		 	
			// 유진-리소스확인
	        function mailboxImportStateHandler(progress, result, userkey) {
				if (!result) {
					return;
				}

				HiddenMailProgressNew();
				mailboxProgressFun(false);
				
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

				if (result == "NO_APPEND") { // 메일용량 초과시
					alert("<spring:message code='ezEmail.ksa16' />");
					document.importMailboxform.file1.value = "";
					MailListRefresh();
				}
				
				if (result == "OK") {
					document.importMailboxform.file1.value = "";
					MailListRefresh(); 
					location.reload();
				}
				
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
							data : { folderPath : "<c:out value='${url}'/>", userkey : socketUserkey},
							success : function(result) {
								if (result == "") {
									alert("<spring:message code='ezEmail.lhm33' />");
								} else if (result == "CANCEL") {
									console.log('User Cancel');
								} else {
									
									if (useEncryptZipForEmail == 'YES' && encryptPw != ""){
										ShowPercent(enc);
									}
									
									var fullpath = "/ezEmail/downloadMailboxZip.do?folderName="
											+ encodeURIComponent("<c:out value='${folderName}'/>")
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
						
		            } /* else if (obj.status == 'progress') {
		            	
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
		        
		        window.onbeforeunload = function(){
			        webSocket = null;
			        importExportMode = false;
		        };
		    }
			
			// 메일박스 가져오기
			function mailbox_attach_import2(pwd, tempId, userkey) {
	        
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
		        	
		        	importExportMode = true;
		            var curr = "";
		        	var obj = JSON.parse(message.data);
		            ShowMailProgressNew();
		            
		            if (path != ""){
		            	ShowPercent(dec);
		            } else {
			            ShowPercent(uploading);
		            }
		            
		        	if (obj.status == "transferStart") {
		        		socketUserkey = obj.userkey;
			            mailboxProgressFun(true, socketUserkey);
		            	
			            var frm = document.getElementById("importMailboxform");
			            var requestUrl = "/ezEmail/mailboxImportZip.do?folderPath="
							+ encodeURIComponent("<c:out value='${url}'/>") 
							+ "&userkey=" + encodeURIComponent(socketUserkey)
							+ "&encryptPw=" + encodeURIComponent(encryptPw)
							+ "&tempId=" + encodeURIComponent(path);
				        
				        if (typeof(shareId) != "undefined" && shareId != "") {
				        	requestUrl += "&shareId=" + encodeURIComponent(shareId);
				    	}
			            
						frm.action = requestUrl;
						frm.submit();
						
		            } /* else if (obj.status == 'progress') {
		            	if (obj.percent <= 100) {
			            	ShowPercent(obj.percent);
		            	}
		            }  */
       
		        };
		        
		        webSocket.onclose = function(event){
		        	webSocket = null;
		        	importExportMode = false;
		        };
		        
		        window.onbeforeunload = function(){
		        	webSocket = null;
		        	importExportMode = false;
		        };
		        				
			}
			
	        function sendMessage(data) {
	        	var sendObj = {};
	            sendObj.status = encodeURIComponent(data);
	            sendObj.userkey = encodeURIComponent(socketUserkey);
	            
	            var json = JSON.stringify(sendObj);
	            webSocket.send(json);
	        }
			
	        // 유진-리소스확인
	        function mailboxImportComplete2(result, tempId, userkey) {

	        	webSocket.close();
				HiddenMailProgressNew();
				mailboxProgressFun(false);
				
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

				if (result == "NO_APPEND") { // 메일용량 초과시
					alert("<spring:message code='ezEmail.ksa16' />");
					document.importMailboxform.file1.value = "";
					MailListRefresh();
				}
				
				if (result == "OK") {
					document.importMailboxform.file1.value = "";
					MailListRefresh(); 
					location.reload();
				}
				
			}
	        
	        function mail_import_onclick() {
	        	document.getElementById("file").click();
	        }
	        
	        function mail_import() {
        		var fileCount = file.length;
        		
        		for (var i = 0; i < fileCount; i++) {
        			var fileExtension = file[i].name.substr(file[i].name.lastIndexOf('.')).toLowerCase();
        			if (fileExtension != '.eml') {
        				alert("<spring:message code='ezEmail.lsd05'/>");
        				return;
        			}
        		}
        		
        		if (fileCount > 100) {
        			alert("<spring:message code='ezEmail.jje04'/>");
        			return;
        		}
	        	
        		ShowMailProgressNew();
	        	document.getElementById("MailProgress").style.backgroundColor = "";
	        	document.getElementById("cancleProgressBtn").style.display = "none";
        		
        		var data = new FormData();
        		data.append("folderid", g_moveUrl);
        		
        		for (var i = 0; i < fileCount; i++) {
        			data.append("file1", file[i]);
        		}
        		
        		if (shareId != "") {
        			data.append("shareId", shareId);
        		}
        		
        		$.ajax({
        			type: 'POST',
        			enctype: 'multipart/form-data',
        			url: '/ezEmail/mailImportUpload.do',
        			data: data,
        			processData: false,
                    contentType: false,
                    cache: false,
        			success: function(result) {
        				HiddenMailProgressNew();
        				
        				if (result == "OK") {
        	                alert("<spring:message code='ezEmail.t403' />");
        	                MailListRefresh();
        	            } else if (result.indexOf("NO APPEND failed.") > -1) {
        		        	alert(strLang241);
        		        	MailListRefresh();
        	            } else {
        	            	alert("<spring:message code='ezEmail.t404' />");
        	            }
        			},
        			error: function(e) {
        				HiddenMailProgressNew();
        				alert("<spring:message code='ezEmail.t404' />" + e.responseText);
        			}
        		});
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
				
			  <c:if test="${!isDotNetIntegration}">
				if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame")?.contentWindow.hideProgress();
				} 
			  </c:if>
			}

			function ShowMailProgressNew() {
			    document.getElementById("mailPanel").style.display = "block";
			    document.getElementById("mailPanel").style.opacity = 0.5;
			    document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
			    document.getElementById("MailProgress").style.backgroundColor = "#ffffff";
			    document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 150 + "px";
			    // IE 지원이 안되어 기존 것 유지, 아래 사용 시 리사이즈 자동처리 됨
			    //document.getElementById("MailProgress").style.top = "50%";
			    //document.getElementById("MailProgress").style.left = "50%";
			    //document.getElementById("MailProgress").style.transform = "translate(calc(-50% - 110px), calc(-50% - 27px))"; // lnb width/2= 110, topmenu height/2 = 27
			    document.getElementById("MailProgress").style.display = "";
			    document.getElementById("cancleProgressBtn").style.display = "block";
			    parent.document.getElementById("left").contentWindow.showProgress();
			    
		     <c:if test="${!isDotNetIntegration}">
			    if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
					parent.parent.document.getElementById("topFrame")?.contentWindow.showProgress();
				} 
			 </c:if>
			}

			function cancleProgress(){
	        	HiddenMailProgressNew();
	        	mailboxProgressFun(false);
	        	// 편지함 가져오기 업로드 도중 취소가 안되는 문제 수정
	        	//webSocket.close();
	        	location.reload();
			}
			
			function mailListScroll(di) {
				$(di).parent("div").find("#MailHeaderDiv").scrollLeft(di.scrollLeft);	
				ContextMenuHidden();
			}
			
			function on_changeViewList(value) {
				on_changeView(value);
				ContextMenuHidden();
			}
			
			function event_listContextMenuAndId(event){
				// 가져오기 도중에 콘텍스트 메뉴 삭제 안되도록
				if (psSetTimeFlag) {
					return;
				}

				event_listContextMenu(event);

		        if (currentMoverId != '') {
		        	currentFixingId = document.getElementById(currentMoverId);
		        } else {
		        	currentFixingId = document.getElementById(listContentArry[listContentArry.length-1]);
		        }
			}
			
			function onDragEnter(evt) {
				evt.dataTransfer.dropEffect = "copy";
				evt.stopPropagation();
				evt.preventDefault();
			}

			function onDragOver(evt) {
				evt.dataTransfer.dropEffect = "copy";
				evt.stopPropagation();
				evt.preventDefault();
			}

			function onDrop(evt) {
				file = new Array();
				
				if (evt !== undefined) {
					evt.stopPropagation();
					evt.preventDefault();
				}
					
				var filelist = (evt === undefined) ? document.getElementById("file").files : evt.dataTransfer.files;
				
				if (filelist.length == 0) {
					return;
				}
				
				for (var i = 0; i < filelist.length; i++) {
					file[i] = filelist[i];
				}
				
				mail_import();
				
				if (!evt) {
					document.getElementById("file").value = null;
				}
			}

			// 20200407 조진호 - 한국고용정보원에서 개발된 해킹의심메일 신고 기능 표준 적용
			var xmlhttp_HackinMail;
			var hacking_mail_report_message_cross_dialogArguments = new Array();
			function moveHackingMail(fromPreviewMail) {
				var szItemID = "";

				if (fromPreviewMail) {
					// 메일 미리보기에서 스팸신고 시 "_href" 값을 fromPreviewMail에 넣어줌
					szItemID = fromPreviewMail;

				} else {
					if (listContentArry.length < 1) {
						alert("<spring:message code='ezEmail.zno001' />");
						return;
					}

					for (var i = 0; i < listContentArry.length; i++) {
						szItemID += document.getElementById(listContentArry[i]).getAttribute("_href") + ",";
					}
				}
				var message = new Array;
				
				message['message'] = "";
				message['szItemID'] = szItemID;

				hacking_mail_report_message_cross_dialogArguments[0] = message;
				hacking_mail_report_message_cross_dialogArguments[1] = reportHackingMessage_complete;
				hacking_mail_report_message_cross_dialogArguments[2] = DivPopUpHidden_sub;

				DivPopUpShow_sub(450, 320, "/ezEmail/hackingMailReportMessage.do");
				$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;'></div>").appendTo(parent.frames["left"].document.body);

			}

			function reportHackingMessage_complete(rtn) {
				$(parent.frames["left"].document.getElementById("blockLeft")).remove();
				var message = rtn['message'];
				var szItemID = rtn['szItemID'];
				var xmlpara = createXmlDom();
				var objNode;
				xmlhttp_HackinMail = createXMLHttpRequest();
				createNodeInsert(xmlpara, objNode, "DATA");
				createNodeAndInsertText(xmlpara, objNode, "CMD", "MOVE");
				createNodeAndInsertText(xmlpara, objNode, "MESSAGE", message);
				createNodeAndInsertText(xmlpara, objNode, "UNIQUEID", szItemID);

				var requestUrl = "/ezEmail/hackingMailMoveAndSend.do";

				xmlhttp_HackinMail.open("POST", requestUrl, true);
				xmlhttp_HackinMail.onreadystatechange = moveHackingMail_complete;
				xmlhttp_HackinMail.send(xmlpara);
			}

			function moveHackingMail_complete() {
				if (xmlhttp_HackinMail != null && xmlhttp_HackinMail.readyState == 4) {
					if (xmlhttp_HackinMail.status >= 200 && xmlhttp_HackinMail.status < 300) {
						pRtnMessage = xmlhttp_HackinMail.responseText;

						if (pRtnMessage.indexOf("NO COPY processing failed.") > -1) {
							alert(strLang241);
						} else if (pRtnMessage.indexOf("OK") > -1) {
							MailListRefresh();
							prevShow_Clear();
							alert("<spring:message code='ezEmail.zno003' />");
						} else {
							alert(strLang5);
						}
					}
					else {
						alert(strLang5);
					}
				}
			}
			function addSearch() {
				if($("#moreSearch").css("display") == "none"){   
					document.getElementById("mailPanel").style.display = "";
				    $("#moreSearch").css("display", "block");   
				    $("#searchButton").css("display", "");   
				    document.getElementsByName("keyword")[0].disabled = true;
				    document.getElementById("searchCheck").style.backgroundColor="rgb(235,235,228)";
				    document.getElementById("searchCheck").disabled = true;
				} else {  
					document.getElementById("mailPanel").style.display == "none";
				    $("#moreSearch").css("display", "none");   
				    $("#searchButton").css("display", "none");   
				    document.getElementsByName("keyword")[0].disabled = false;
				    document.getElementById("searchCheck").disabled = false;
				    document.getElementById("searchCheck").style.backgroundColor="rgb(255,255,255)";
				} 
			}
			function doLayerPopup() {
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#srarchpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	// 검색 레이어 팝업 열기 전에 input 내용 지워주도록 처리. 2019-08-02 홍대표.
	        	var inputElem = document.getElementById("srarchpopup").getElementsByTagName("input");
	        	[].forEach.call(inputElem, function(elem){
	        		if(elem.type == "checkbox") {
	        			elem.checked = false;
	        		}
	        		
	        		elem.value = "";
	        	});
	        	
	        	$("#srarchpopup").modal();
	        }
			function initializationSearchData(){
				$("#selectDetail1").val("SUBJECT");
				$("#selectDetail2").val("CONTENT");
				$("#selectDetail3").val("FROM");
				$("#all").val("FROM");
				$('input:radio[name="attachment"][id="all"]').prop('checked', true);
				$('input:radio[name="andor"][value="and"]').prop('checked', true);
				$("#selectRange").val(mailSearchPeriod);
				$("input:text[name='prekeyword']").val("");
				var today = new Date();
				$("#Sdatepicker").datepicker('setDate', mailSearchPeriodSDate);
				$("#Edatepicker").datepicker('setDate', today);
				changeLangeEvent();
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
							if (!psSetTimeFlag) { return; }
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

			/** @param {Function} successCallback */
			function reloadTagsForLabelLayer() {
				$.ajax({
					cache: false,
					method: 'get',
					data: { shareId: shareId },
					url: '/ezEmail/getUserTagList.do',
					success: function(result) {
						if (result.status === 'error') {
							alert(strLang321);
							return;
						}

						drawTagsToLabelLayer(result.data);
					},
					error: function() { alert(strLang321); }
				});
			}

			function drawTagsToLabelLayer(tags) {
				/** @type HTMLTableElement */
				const labelTable = document.getElementById('label-table');
				labelTable.innerHTML = '';

				const checkedTagIdxArray = Array.from(labelTable.querySelectorAll(":checked")).map(input => input.value);
				const indeterminateTagIdxArray = Array.from(labelTable.querySelectorAll(":indeterminate")).map(input => input.value);

				tags.forEach(function(tag) {
					const row = document.createElement('li');
					const checkbox = document.createElement('input');
					checkbox.type = 'checkbox';
					checkbox.id = 'label-check-' + tag.idx;
					checkbox.value = tag.idx;
					checkbox.dataset.name = tag.name;

					if (checkedTagIdxArray.includes(tag.idx)) {
						checkbox.checked = true;
					} else if (indeterminateTagIdxArray.includes(tag.idx)) {
						checkbox.checked = false;
						checkbox.indeterminate = true;
					}

					row.appendChild(checkbox);
					row.appendChild(document.createTextNode(' '));
					/** @type HTMLLabelElement */
					const title = document.createElement('label');
					title.textContent = tag.name;
					title.title = tag.name;
					title.htmlFor = 'label-check-' + tag.idx;
					row.appendChild(title);
					labelTable.appendChild(row);
				});

				if (drawTagConsumeCallback) {
					drawTagConsumeCallback();
					drawTagConsumeCallback = null;
				}
			}

			function showLabelLayer() {
				if (listContentArry.length === 0 && listSubContentArry.length === 0 && currentFixingId == null) {
					document.querySelectorAll("#label-table input[type='checkbox']").forEach(/** @type HTMLInputElement */checkbox => {
						checkbox.checked = false;
						checkbox.indeterminate = false;
					});
					return;
				}

				const rows = [];
				if (listContentArry.length > 0) {
					for (var i = 0; i < listContentArry.length; i++) {
						rows.push(document.getElementById(listContentArry[i]));
					}
				} else if (listSubContentArry.length > 0) {
					for (var i = 0; i < listSubContentArry.length; i++) {
						rows.push(document.getElementById(listSubContentArry[i]));
					}
				} else {
					rows.push(currentFixingId);
				}

				const tagCount = {};

				for (const row of rows) {
					if (row.dataset.tags) {
						row.dataset.tags.split('|').forEach(tag => {
							if (tagCount[tag]) {
								tagCount[tag]++;
							} else {
								tagCount[tag] = 1;
							}
						});
					}
				}

				document.querySelectorAll("#label-table input[type='checkbox']").forEach(/** @type HTMLInputElement */checkbox => {
					const count = tagCount[checkbox.dataset.name];

					if (count === rows.length) {
						checkbox.checked = true;
						checkbox.indeterminate = false;
					} else if (count === undefined) {
						checkbox.checked = false;
						checkbox.indeterminate = false;
					} else {
						checkbox.checked = false;
						checkbox.indeterminate = true;
					}
				});
			}

			function addLabel() {
				const labelInput = document.getElementById('label-input');

				if (!labelInput.value.trim()) {
					return;
				}

				$.ajax({
					cache: false,
					method: 'post',
					url: '/ezEmail/createTag.do',
					data: { tagName: labelInput.value.trim(), shareId },
					success: function(result) {
						if (result.status === 'error') {
							showError();
							return;
						}

						if (window.leftMenu) {
							leftMenu.reloadTags();
						}

						drawTagConsumeCallback = () => {
							labelInput.value = "";

							const addedTag = document.querySelector(`#label-table [value='\${result.data}']`).parentElement;
							addedTag.addEventListener('blur', e => {
								e.currentTarget.removeAttribute('tabindex');
							});
							addedTag.tabIndex = 0;
							addedTag.contentEditable = true;
							addedTag.focus();
							addedTag.contentEditable = false;
						};
					},
					error: function() {
						showError();
					}
				});
			}

			function saveChangesTags() {
				if (listContentArry.length === 0 && listSubContentArry.length === 0 && currentFixingId == null) {
					alert(strLang42);
					document.body.click();
					return;
				}

				const mailPathList = [];
				const enableTagList = Array.from(document.querySelectorAll("#label-table input:checked:not(:indeterminate)")).map(input => input.value);
				const disableTagList = Array.from(document.querySelectorAll("#label-table input:not(:checked):not(:indeterminate)")).map(input => input.value);

				if (listContentArry.length > 0) {
					for (var i = 0; i < listContentArry.length; i++) {
						mailPathList.push(document.getElementById(listContentArry[i]).getAttribute("_href"));
					}
				} else if (listSubContentArry.length > 0) {
					for (var i = 0; i < listSubContentArry.length; i++) {
						mailPathList.push(document.getElementById(listSubContentArry[i]).getAttribute("_href"));
					}
				} else {
					mailPathList.push(currentFixingId.getAttribute("_href"));
				}

				$.ajax({
					cache: false,
					method: 'post',
					url: "/ezEmail/saveChangesTags.do",
					data: JSON.stringify({ shareId, mailPathList, enableTagList, disableTagList }),
					dataType: 'json',
					contentType: 'application/json',
					success: function(result) {
						if (result.status === "error") {
							showError();
							return;
						}

						prevShow();
						MailListRefresh();
					},
					error: function() {
						showError();
					},
					complete: function() {
						document.body.click();
					}
				});
			}


			var previewMail_cross_dialogArguments = new Array();
			function previewMail(element, event) {
				const grandparent = element.closest('td').parentElement;
				const _href = grandparent.getAttribute("_href");
				const isSecureMail = grandparent.getAttribute("securemail");

				if (checkBlockedMail(_href) == '1') {
					alert(strLangLDH07);
					event.stopPropagation()
					return;
				}

				const parameter = new Map();
				parameter.set('_href', _href);
				parameter.set('isSecureMail', isSecureMail);

				previewMail_cross_dialogArguments[0] = parameter;
				
				try {
					const rightHeight = window.innerHeight;
					const clickY = event.clientY;

					let top = clickY + 12;
					if (top + 350 > rightHeight) {
						top = rightHeight - 350 - 12;
					}

					const rightWidth = window.innerWidth;
					const clickX = event.clientX;
					let right = clickX + 12;
					if (right + 500 > rightWidth) {
						right = rightWidth - 510;
					}

					const iFramePanel_mail_preview = document.getElementById("iFramePanel_mail_preview");

					document.getElementById("mail_preview_Layer").src = "/ezEmail/previewMail.do";
					iFramePanel_mail_preview.style.top = top + "px";
					iFramePanel_mail_preview.style.left = right + "px";
					iFramePanel_mail_preview.style.height = "350px";
					iFramePanel_mail_preview.style.display = "";
					iFramePanel_mail_preview.style.border = "1px solid #E5E5E5";
					iFramePanel_mail_preview.style.boxShadow = "0 3px 6px rgba(0,0,0,0.16)";
					iFramePanel_mail_preview.classList.toggle('on');
					
					document.getElementById("mail_preview_Layer").style.width = "500px";
					document.getElementById("mail_preview_Layer").style.height = "350px";


				} catch (e) { }
				event.stopPropagation();
			}
		</script>
		<style>
			<c:if test="${useMailTag}">
			.tagli > span:first-child { width: 55px; display: inline-block; }
			.tagli > input { height: 22px; vertical-align: middle; }
			.tagli > input + .imgbtn { margin: 0px; vertical-align: middle; }
			#pre_h_tag_view > img, #pre_w_tag_view > img { width: 11px; height: 11px; cursor: pointer; margin: 0 7px 0 4px; }
			<c:if test="${not empty tagName}">
			#tag_subtitle { display: inline-block; max-width: 400px; text-overflow: ellipsis; overflow: hidden; word-break: keep-all; vertical-align: middle; font-size: 17px; padding-bottom: 5px; }
			</c:if>
			</c:if>
		</style>
	</head>
	<body style="overflow:hidden;margin-bottom:0px;" id="theBody" class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);"  onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
		<c:if test="${not empty tagName}">
		<c:set var="tagNameSpan" ><span id='tag_subtitle' title='<c:out value="${tagName}"/>'><c:out value="${tagName}"/></span></c:set>
		<h1><spring:message code="ezEmail.tag.title" arguments="${tagNameSpan}" argumentSeparator="|"/><span id="mailBoxInfo"></span><span id ="resultCount" style="display:none;"></span>
		</c:if>
		<c:if test="${empty tagName}">
		<h1><c:out value='${folderName}'/><span id="mailBoxInfo"></span><span id ="resultCount" style="display:none;"></span>
		</c:if>
		<span id ="searchDate" style="display:;font-weight:normal;"></span>
			<span class="searchForm" style="padding-right:30px;">
				<!-- 2022-12-29 이사라 : 기본검색 시 검색기간을 추가 -->
				<span id="datepickerSimple" style="display:none;">
					<input type="text" id="SdatepickerSimple" style="height:30px;" disabled="" readonly size="10" readonly> ~ 
					<input type="text" id="EdatepickerSimple" style="height:30px;" size="10" disabled="" readonly>
				</span>

				<select name="searchCheck searchFilter" id="searchCheck" class="text" style="height: 27px; margin-right: 0px; border: 1px solid #cbcbcb;">
					<option selected value="SUBJECT"><spring:message code="ezEmail.t98" /></option>
					<c:if test="${isSentItems != true}">
						<option value="FROM"><spring:message code="ezEmail.t161" /></option>
					</c:if>
					<c:if test="${isSentItems == true}">
						<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option>
					</c:if>
					<c:if test="${useSearchContent == 'YES'}">
						<option value="CONTENT"><spring:message code="ezEmail.t649" /></option>
					</c:if>
				</select>
			  
				<input name="keyword" id="keywordSearch" class="searchinputBox" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb; height: 27px !important;" onKeyPress="onkeydown_start_search(event);"
					   placeholder="";/>
				<a class="searchBtn"><img src="/images/bsearch_new2.png" border="0" onclick="start_search2()"></a>
				<a class="searchFilterBtn"><img src="/images/bsearch_new2_filter.png" border="0" onclick="addSearch()"></a>
				<div class="layerPopup_new" id="moreSearch" style="display:none;z-index:6000;" >
		        	<ul class="content_layout">
		        		<li class="content_layout_left">
							<p class="text_th"><spring:message code="ezEmail.pyy22" /><span class="point_red">*</span></p>
						</li>
						<li class="content_layout_center">
							<ul class="content_layout">
								<li class="content_layout_center">
									<span class="radio_design">
										<input type="radio" id="and" name="andor" checked="checked" value="and">
										<label for="and">AND</label>
									</span>
									<span class="radio_design">
										<input type="radio" id="or" name="andor" value="or">
										<label for="or">OR</label>
							        </span>
							    </li>
							</ul>
							<ul class="content_layout">
								<li class="content_layout_left mr10">
									<select name="select" class="text" id="selectDetail1" style="height: 25px;margin-right: 3px;width: 86px;">
										<option selected value="SUBJECT"><spring:message code="ezEmail.t98" /></option> 
										<option value="CONTENT"><spring:message code="ezEmail.t649" /></option> 
										<option value="FROM"><spring:message code="ezEmail.t161" /></option> 
										<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
										<option value="FILE"><spring:message code="ezEmail.pyy12" /></option> 
									</select>
								</li>
								<li class="content_layout_center">
									<span class="textbox_design"><input type="text" name="prekeyword" id="prekeywordDetail1" style="vertical-align: top;height: 25px;" onKeyPress="onkeydown_start_search(event);"/></span>
								</li>
							</ul>
							<ul class="content_layout">
								<li class="content_layout_left mr10">
									<select name="select" class="text" id="selectDetail2" style="height: 25px;margin-right: 3px;width: 86px;">
										<option value="SUBJECT"><spring:message code="ezEmail.t98" /></option> 
										<option selected value="CONTENT"><spring:message code="ezEmail.t649" /></option> 
										<option value="FROM"><spring:message code="ezEmail.t161" /></option> 
										<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
										<option value="FILE"><spring:message code="ezEmail.pyy12" /></option> 
									</select>
								</li>
								<li class="content_layout_center">
									<span class="textbox_design"><input type="text" name="prekeyword" id="prekeywordDetail2" style="vertical-align: top;height: 25px;" onKeyPress="onkeydown_start_search(event);"/></span>
								</li>
							</ul>
							<ul class="content_layout">
								<li class="content_layout_left mr10">
									<select name="select" class="text" id="selectDetail3" style="height: 25px;margin-right: 3px;width: 86px;">
										<option value="SUBJECT"><spring:message code="ezEmail.t98" /></option> 
										<option value="CONTENT"><spring:message code="ezEmail.t649" /></option> 
										<c:if test="${isSentItems != true}">
											<option selected value="FROM"><spring:message code="ezEmail.t161" /></option> 
											<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
										</c:if>
										<c:if test="${isSentItems == true}">
											<option value="FROM"><spring:message code="ezEmail.t161" /></option> 
											<option selected value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
										</c:if>
										<option value="FILE"><spring:message code="ezEmail.pyy12" /></option> 
									</select>
								</li>
								<li class="content_layout_center">
									<span class="textbox_design"><input type="text" name="prekeyword" id="prekeywordDetail3" style="vertical-align: top;height: 25px;" onKeyPress="onkeydown_start_search(event);"/></span>
								</li>
							</ul>
						</li>
					</ul>
						
					<ul class="content_layout">
						<li class="content_layout_left">
		<%-- 					<p class="text_th"><spring:message code="ezEmail.pyy13" /></p> --%>
							<p class="text_th"><spring:message code="ezEmail.t557" /></p>
						</li>
						<li class="content_layout_center">
							<ul class="content_layout">
								<li class="content_layout_center">
									<span class="radio_design">
		                                 <input type="radio" id="all" name="attachment" checked="checked" value="all">
		                                 <label for="all"><spring:message code="ezEmail.pyy14" /></label>
		                             </span>
		                             <span class="radio_design">
		                                 <input type="radio" id="contain" name="attachment" value="contain">
		                                 <label for="contain"><spring:message code="ezEmail.pyy15" /></label>
		                             </span>
		                             <span class="radio_design">
		                                 <input type="radio" id="Ncontain" name="attachment" value="Ncontain">
		                                 <label for="Ncontain"><spring:message code="ezEmail.pyy16" /></label>
		                             </span>
								</li>
							</ul>
						</li>
					</ul>
					<ul class="content_layout">
						<li class="content_layout_left">
							<p class="text_th"><spring:message code="ezEmail.t653" /></p>
						</li>
						<li class="content_layout_center">
							<ul class="content_layout">
								<li class="content_layout_left mr10">
									<select name="select" class="text" id="selectRange" onchange="changeLangeEvent()" style="height: 25px;margin-right: 5px;width: 86px;">
										<option value="oneWeek" <c:if test="${mailGeneral.mailSearchPeriod == 'oneWeek'}">selected</c:if>><spring:message code="ezEmail.pyy17" /></option>
										<option value="oneMonth" <c:if test="${mailGeneral.mailSearchPeriod == 'oneMonth'}">selected</c:if>><spring:message code="ezEmail.pyy18" /></option>
										<option value="threeMonth" <c:if test="${mailGeneral.mailSearchPeriod == 'threeMonth'}">selected</c:if>><spring:message code="ezEmail.pyy19" /></option>
										<option value="sixMonth" <c:if test="${mailGeneral.mailSearchPeriod == 'sixMonth'}">selected</c:if>><spring:message code="ezEmail.ls001" /></option>
										<option value="oneYear" <c:if test="${mailGeneral.mailSearchPeriod == 'oneYear'}">selected</c:if>><spring:message code="ezEmail.ls002" /></option>
										<option value="all">ALL</option>
										<option value="direct"><spring:message code="ezEmail.pyy20" /></option>
									</select>
								</li>
							</ul>
							<ul class="content_layout">
								<li class="content_layout_center">
									<span id="datepickerData">
										<input type="text" id="Sdatepicker" style="height:30px;" disabled="" readonly size="10" readonly> ~ 
			    						<input type="text" id="Edatepicker" style="height:30px;" size="10" disabled="" readonly>
									</span>
								</li>
							</ul>
						</li>
					</ul>
					<div class="layerPopup_button">
						<ul class="content_layout">
							<li class="content_layout_right ml15" onclick="set_searchKey()"><span class="button_style01"><spring:message code="ezEmail.t37" /></span></li>
							<li class="content_layout_right ml15" style="display:none;"><span class="button_style02"><spring:message code="ezEmail.t39" /></span></li> <!-- 확인/취소 시에 사용예정 -->
							<li class="content_layout_right" onclick="initializationSearchData();"><span class="button_style03"><spring:message code="ezEmail.pyy21" /></span></li>
						</ul>
					</div>
				</div>
			</span>
	    </h1>
	    
        <div id="mainmenu">
	        <ul id="tb_Parent">
	          <li id="newMailBtn" class="important"><span onClick="new_mail_onclick()"><spring:message code="ezEmail.t510" /></span></li>
	          <li class="important" id="reply"><span onClick="reply_mail_onclick()"><spring:message code="ezEmail.t511" /></span></li>
	          <li id="replyAllBtn" class="important"><span onClick="all_reply_mail_onclick()"><spring:message code="ezEmail.t512" /></span></li>
	          <li class="important" id="liReSend" style="display: none;"><span id="btnReSend" onClick="reSend_onClick()"><spring:message code="ezEmail.kyj19" /></span></li>
	          <li id="relayBtn" class="important"><span onClick="transmission_mail_onclick()"><spring:message code="ezEmail.t513" /></span></li>
	          <!-- <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
	          <li id="read_stat"><span onClick="Read_StatusChange('R');" ><spring:message code="ezEmail.t99000006" /></span></li>
	          <li id="moveBtn"><span onClick="move_mail_onclick()"><spring:message code="ezEmail.t482" /></span></li>
	          <!-- <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
	          <li id="deleteone"><span onClick="deleteWork(true)"><spring:message code="ezEmail.t156" /></span></li>
	          <li id="deleteall" style="display:none"><span onClick="delAllFile()"><spring:message code="ezEmail.t514" /></span></li>
	          <li id="receivecheck" style="display:none" ><span onClick="receiveCheck_onClick()"><spring:message code="ezEmail.t516" />/<spring:message code="ezEmail.t549" /></span></li>
	          <li id="toggle_flag_btn" onClick="toggle_flag();" ><span class="icon16 icon16_star"></span></li>
	          <li id="trashBtn" onClick="deleteWork(false)"><span class="icon16 icon16_delete"></span></li>
              <li id="trashUnreadBtn" title="<spring:message code="ezEmail.unread.delete" />" onClick="deleteUnreadWork()"><span class="icon16 icon16_unreadMail_del"></span></li>
	          <li onClick="MailListRefresh()"><span class="icon16 icon16_refresh"></span></li>
	          <c:if test="${useHackingMailReport == 'YES'}">
			  <li id="hackingMail" title="<spring:message code="ezEmail.zno002" />" onClick="moveHackingMail()"><span class="icon16 icon16_spam"></span></li>		
			  </c:if>
				<c:if test="${useMailTag}">
				<li class="view_more" data-before-show="showLabelLayer" style="position: relative;">
					<span><spring:message code="ezEmail.tag" /></span>
					<div id="label-layer" class="layer_select keep_alive tagArea" style="display: none; position: fixed; top: 85px;">
						<p class="tagAdd">
							<input id="label-input" type="text" maxlength="100" placeholder="<spring:message code="ezEmail.tag.user.input.placeholder" />" />
							<a class="imgbtn imgbck" onclick="addLabel()"><span><spring:message code="ezEmail.tag.user.addbtn" /></span></a>
						</p>
						<ul id="label-table" class="tagUL">
						</ul>
						<p class="tag_btnSave">
							<a class="imgbtn imgbck" onclick="saveChangesTags()"><span><spring:message code="main.sp09" /></span></a>
						</p>
					</div>
				</li>
				</c:if>
			  <li class="view_more">
				  <span class="view_icon"><img src="/images/ImgIcon/view_more.png"></span>
				  <ul class="layer_select">
					  <li id="unread_stat" onClick="Read_StatusChange('U');"><spring:message code="ezEmail.t99000007" /></li>
					  <li id="EmailPCSave" onClick="g_moveUrl === 'allMail' ? mail_export_exec(true) : mail_export()"><spring:message code="ezEmail.t378" /></li>
					  <li id="importBtn" onClick="mail_import_onclick();"><spring:message code="ezEmail.t407" /></li>
					  <li id="btnReject" onClick="reject_onclick()" style="display:none"><spring:message code="ezEmail.t270" /></li>
					  <c:if test="${useMailConfirm == 'YES'}">
						  <li onClick="mailConfirm_flag_btn()"><spring:message code="ezEmail.ksa13" /></li>
					  </c:if>
				  </ul>
			  </li>
	          
			 <!--  <li id="right">
	          	<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
	           	<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
				<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
				<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" class="maillistoptiondivbtn" onclick="MailOptionView(this);" />
			  </li>  -->
			  <div class="sub_frameIcon" style="float:right">	
				<div class="sub_frameIconUL">
				   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
				    <p class="frameIconLI"><span class="icon16 btn_bottomframe" id="PreViewBottom" onclick="PreviewRayerChange('W')"></span></p>
				    <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H')"></span></p>
				</div>
				<div class="sub_frameIconUL02">
				  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this);"></span></p>  
				</div>
			 </div>
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
	                   <select id="listcount" style="WIDTH:50px;height:20px;" onChange="ListCount(this.value);">
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
                  <tr id="selectViewList">
                    <th><spring:message code="ezEmail.t99000035" /></th>
                    <td>
                    	<select name="select" id="select" onChange="on_changeViewList(this.value)" style="height:20px;width:120px;">       
                    		<option VALUE="BASE" selected><spring:message code="ezEmail.t518" /></option>
                    		<option VALUE="PREVIEW"><spring:message code="ezEmail.t843" /></option>
                    		<option VALUE="UNREAD"><spring:message code="ezEmail.t519" /></option>
                    		<option VALUE="RECEIV"><spring:message code="ezEmail.t66" /></option>
						<c:if test="${isSentItems != true}">
                    		<option VALUE="INTERNAL"><spring:message code="ezEmail.kes003" /></option>
                    		<option VALUE="EXTERNAL"><spring:message code="ezEmail.kes004" /></option>
						</c:if>
						<c:if test="${'YES'.equalsIgnoreCase(useSecureMail)}">
                    		<option VALUE="SECUREMAIL"><spring:message code="ezEmail.yja001" /></option>
                   		</c:if>
                    		<option VALUE="IMPORTANT"><spring:message code="ezEmail.kes047" /></option>
                    		<option VALUE="ATTACH"><spring:message code="ezEmail.t557"/> </option>
                    	</select>
	                </td>
                  </tr>
              </table>
            </div>
          </div>
	      <div class="shadow"></div>
        </div>
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="ContextMenuHidden();" oncontextmenu="event_listContextMenuAndId(event); return false;">&nbsp;</div>
        <div style="width:8px;height:100%;background-color:#808080;position:absolute;z-index:10000;display:none;" id="ResizeBarH"></div>
        <div style="width:100px;height:8px;background-color:#808080;position:absolute;z-index:10000;display:none;" id="ResizeBarW"></div>
        <div style="width:200px; padding:20px 0; border-radius:8px; text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
            <img src="/images/email/progress_img.gif"/>
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
            <a class="btnposition" id="cancleProgressBtn" style="display: none; padding-top: 10px; width: 50px; height:20px; 
      			cursor:pointer; margin:0 auto;" onclick="cancleProgress();">
            <input type="button" value="<spring:message code="ezEmail.t39" />"/></a>
           
        </div>
        <span id="MailListRayer" style="border:0px solid blue;width:500px;height:100%;vertical-align:top;overflow:hidden;" > 
		    <div id="dragDropArea">
		        <div id="MailHeaderDiv" style="overflow-x: hidden; ">
	    	        <table style="width:100%;border:1px solid #ddd; min-width:400px;" id="MailHeader" class="mainlist" >               
	        	    </table>
	        	</div>
	        	<div id="contentlistDiv" style="overflow-y: auto;" onscroll="mailListScroll(this);ContextMenuHidden()" onclick="event_secondRightClick();">
		            <div id="contentlist" name="contentlist" style="border:0px solid blue;height:350px;width:100%;min-width:400px;" onblur  onscroll="ContextMenuHidden()">
		                <table class="mainlist" style="width:100%;" id="MailList" listpageCount="${mailGeneral.listCount}" curPage="1" MaxCount="0" MaxPage="0" oncontextmenu="event_listContextMenuAndId(event); return false;">
		                </table>
		            </div>
		        </div>
		    </div>
            <div id="tblPageRayer"  style="width:470px; margin:6px auto;" onclick="event_secondRightClick();"></div>
        </span>
        <div id="PreviewRayerH" style="border:0px;width:500px;height:100%;overflow:hidden;vertical-align:top;display:none;margin-left:-5px;" onclick="event_secondRightClick();">
            <div class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor:w-resize;display:inline-block;">
				<p class="hbar_dotted"><img src="/images/prevview_hbar_dotted.gif"></p>
            </div>
            <div id="PreContent_RayerH" style="position:absolute; border:0px; margin-left:7px;">
                <div class="previewmail" onclick="event_secondRightClick();">            
	                <div class="previewmail_info">
                       	<dl class="previewmailDL" id="Preview_HeaderH" style="display:none;" onclick="event_secondRightClick();">
			            	<dt class="prepic"><img id="preHSenderImage" width="55px" height="55px"></dt>
			                <dd class="pretext">
			                	<ul class="pretextUL">
			                    	<li class="preSubject">
			                    		<span class="popup_open" onclick="MailReadOpen();">
			                    			<img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />" title="<spring:message code='ezEmail.t99000001' />">
			                    		</span>
			                    		<span class="subjectText" id="PreH_subject" style="display:none;">
			                    			<span class="subjectText" id="PreH_sub_subject"></span>
			                    		</span>
			                    	</li>
			                        <li class="preT_list">
                                        <span class="cblack"><spring:message code="ezEmail.t693" /></span>
                                        <span id="PreH_MailSender">
                                            <span id="PreH_sub_MailSender"></span>
                                        </span>
			                        </li>
			                        <li class="preT_list"><span class="cblack"><spring:message code="ezEmail.t527" /></span> <span id="PreH_MailReceiver" style="display:inline-block"></span>
				                    	<span id="PreH_MailReceiver_sub"></span>
				                    	<span class="icon_graydown" onclick="ReceiverDetail_view(this);" id="PreH_ReceiverDetail"></span>
				                    	<p class="hidden_area" id="PreH_MailReceiverDetail_Rayer" style="display:none;"><span id="PreH_MailReceiverDetail"></span></p>
				                    </li>
                                    <li class="preT_list">
                                        <c:if test="${folderType == 'sent' or folderType == 'draft'}">
                                            <span class="cblack"><spring:message code="ezEmail.t704" /> : </span>
                                        </c:if>
                                         <c:if test="${folderType != 'sent' and folderType != 'draft'}">
                                            <span class="cblack"><spring:message code="ezEmail.t657" /> : </span>
                                        </c:if>
                                        <span id="PreH_date"><span id="PreH_sub_date" style="display:none;"></span></span>
                                    </li>
			                        <li class="preT_list" id="PreH_CCMain" style="display:none;"><span class="cblack"><spring:message code="ezEmail.t526" /></span> <span id="PreH_MailCC" style="display:inline-block"></span>
				                    	<span id="PreH_MailCC_sub"></span>
				                    	<span class="icon_graydown" onclick="CCDetail_view(this);" id="PreH_CCDetail" style="display:none;"></span>
				                    	<p class="hidden_area" id="PreH_MailCC_Rayer" style="display:none;"><span id="PreH_MailCCDetail"></span></p>
				                    </li>
									<c:if test="${useMailTag}">
										<li class="preT_list tagli"><span class="cblack"><spring:message code="ezEmail.tag" /></span>
											<span class="input_select">
												<sapn class="input_wrap" id="input_wrap_h">
													<input id="pre_h_tag_add" type="text" maxlength="100" />
													<span class="input_select_arrow" onclick="$('#input_wrap_h').toggleClass('on');getTagList('h')"></span>
												</sapn>
												<a class="imgbtn"><span><spring:message code="ezEmail.tag.user.addbtn" /></span></a>
												<ul class="layer_select" id="layer_select_h">

												</ul>
											</span>
											<div id="pre_h_tag_view" style="padding-left: 60px;"></div>
										</li>
									</c:if>
			                    </ul>
			                </dd>
			            </dl>
	                </div>
					<span style="width: 100%;" onclick="event_secondRightClick();">
						<iframe onclick="event_secondRightClick();" id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code="main.kms4" />" frameborder="0" style="width:100%;height:100%;border:solid 0px green;display:inline-block;"></iframe>
					</span>
                </div>
            </div>
        </div>        
        <div id="PreviewRayerW" style="border:0px;width:100%;overflow:hidden;display:none;">
            <div onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width:100%;display:list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
				<img src="/images/prevview_bar_dotted.gif">
            </div>
            <div id="PreContent_RayerW" style="display:block;border:0px;">
                <div class="previewmail" onclick="event_secondRightClick();">
	                <div class="previewmail_info" style="display:block;width:100%;">
	                	<dl class="previewmailDL" id="Preview_HeaderW" style="display:none;">
			            	<dt class="prepic"><img id="preWSenderImage" width="55px" height="55px"></dt>
			                <dd class="pretext">
			                	<ul class="pretextUL">
			                    	<li class="preSubject">
			                    		<span class="popup_open" onclick="MailReadOpen();">
			                    			<img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />" title="<spring:message code='ezEmail.t99000001' />">
			                    		</span>
			                    		<span class="subjectText" id="PreW_subject" style="display:none;">
			                    			<span class="subjectText" id="PreW_sub_subject"></span>
			                    		</span>
			                    	</li>
			                        <li class="preT_list">
			                        	<span class="t_left">
			                        		<span class="cblack">
			                        			<spring:message code="ezEmail.t693" />
			                        		</span>
				                        	<span id="PreW_MailSender">
				                        		<span id="PreW_sub_MailSender"></span>
				                        	</span>
			                        	</span>
			                        	<span class="t_right" style="margin-right:3px;">
			                        		<c:if test="${folderType == 'sent' or folderType == 'draft'}">
				                        		<span class="cblack"><spring:message code="ezEmail.t704" /> : </span>
                  							</c:if>
			                        		 <c:if test="${folderType != 'sent' and folderType != 'draft'}">
				                        		<span class="cblack"><spring:message code="ezEmail.t657" /> : </span>
                 							</c:if>
			                        		<span id="PreW_date">
			                        			<span id="PreW_sub_date" style="display:none;"></span>
			                        		</span>
			                        	</span>
			                        </li>
			                        <li class="preT_list">
			                        	<span class="cblack"><spring:message code="ezEmail.t527" /></span> 
			                        	<span id="PreW_MailReceiver" style="display:inline-block"></span>
				                    	<span id="PreW_MailReceiver_sub"></span>
				                    	<span class="icon_graydown" onclick="ReceiverDetail_view(this);" id="PreW_ReceiverDetail"></span>
				                    	<p class="hidden_area" id="PreW_MailReceiverDetail_Rayer" style="display:none;"><span id="PreW_MailReceiverDetail"></span></p>
				                    </li>
			                        <li class="preT_list" id="PreW_CCMain" style="display:none;"><span class="cblack"><spring:message code="ezEmail.t526" /></span> <span id="PreW_MailCC" style="display:inline-block"></span>
				                    	<span id="PreW_MailCC_sub"></span>
				                    	<span class="icon_graydown" onclick="CCDetail_view(this);" id="PreW_CCDetail" style="display:none;"></span>
				                    	<p class="hidden_area" id="PreW_MailCCDetail_Rayer" style="display:none;"><span id="PreW_MailCCDetail"></span></p>
				                    </li>
									<c:if test="${useMailTag}">
										<li class="preT_list tagli"><span class="cblack"><spring:message code="ezEmail.tag" /></span>
											<span class="input_select">
												<sapn class="input_wrap" id="input_wrap_w" style="float: revert">
													<input id="pre_w_tag_add" type="text" maxlength="100" />
													<span class="input_select_arrow" onclick="$('#input_wrap_w').toggleClass('on');getTagList('w')"></span>
												</sapn>
												<a class="imgbtn"><span><spring:message code="ezEmail.tag.user.addbtn" /></span></a>
												<ul class="layer_select" id="layer_select_w">

												</ul>
											</span>
											<div id="pre_w_tag_view" style="padding-left: 60px;"></div>
										</li>
									</c:if>
			                    </ul>
			                </dd>
			            </dl>
	                </div>
                    <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" frameborder="0" style="width:100%;height:100%;border:0px solid black;z-index:0;"></iframe>
                </div>
            </div>
        </div>   
		<iframe name="AttachDownFrame" id="AttachDownFrame" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none"></iframe>  
		<div id="GroupSubObject" style="display:none;">
			<table style="width:100%;" id="GroupSubHeader" class="mainlist_depth" >               
			</table>
			<div id="GroupSubContentlist"  style="border:0px solid red;height:auto;width:100%;overflow-y:auto;">
			    <table class="mainlist" style="width:100%;" id="GroupSubList" oncontextmenu="event_listContextMenuAndId(event); return false;">
			    </table>
			</div>
		</div>
		<div id="ContextMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
		    <table cellpadding=2 cellspacing=1 border=0 class="popuplist">
		    <tr id="replyAllMenu">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="all_reply_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_reall.gif" alt=""  align="absmiddle" hspace="5"><spring:message code="ezEmail.t512" /></span></td>
		    </tr>
		    <tr id="relayMenu">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="transmission_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_fw.gif" alt="" align="absmiddle" border="0" hspace="5"><spring:message code="ezEmail.t513" /></span></td>
		    </tr>
		    <tr id="replyMenu">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="reply_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/i_mailreply.gif" alt="" align="absmiddle"  border="0" hspace="5"><spring:message code="ezEmail.t511" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="Read_StatusChange('R');HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-msg-read.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t99000006" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="Read_StatusChange('U');HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/view-document.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t99000007" /></span></td>
		    </tr>
		    <tr id="moveMenu">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="move_mail_onclick();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/move.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t482" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="MailListRefresh();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/recur.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t515" /></span></td>
		    </tr>
		    <tr>
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="toggle_flag();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/icon-flag.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.t550" /></span></td>
		    </tr>
		    <c:if test="${useMailConfirm == 'YES'}">
		    <tr id="mailConfirm">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="mailConfirm_flag_btn();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/view-document-confirm.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.ksa13" /></span></td>
		    </tr>
		    </c:if>
		    <tr id="searchName">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span style="font-size:12px;width:100%;display:inline-block;"><img src="/images/ImgIcon/i_nsearch.gif" align="absmiddle" hspace="5"/><spring:message code="ezEmail.kr.lsd03" /></span></td>
		    </tr>
		    <tr id="searchInThisBoxByName">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="searchInThisBoxByName();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;">&nbsp;&nbsp; - <spring:message code="ezEmail.kr.lsd06" /></span></td>
		    </tr>
		    <tr id="searchAllBoxByName">
		        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onClick="searchAllBoxByName();HiddenContextMenu();" style="font-size:12px;width:100%;display:inline-block;">&nbsp;&nbsp; - <spring:message code="ezEmail.kr.lsd07" /></span></td>
		    </tr>
		    </table>
		</div>
		<form name="PrevViewFormH" action="/ezEmail/mailPreviewContent.do" method="post" target="ifrmPreViewH" >
			<input  type="hidden"  name="iptURL" value="">
			<input  type="hidden" name="iSecurity" value="">
			<c:if test="${shareId != null and shareId != ''}">
				<input  type="hidden" name="shareId" value="${shareId}">
			</c:if>
		</form>
		<form name="PrevViewFormW" action="/ezEmail/mailPreviewContent.do" method="post" target="ifrmPreViewW">
			<input  type="hidden"  name="iptURL" value="">
			<input  type="hidden" name="iSecurity" value="">
			<c:if test="${shareId != null and shareId != ''}">
				<input  type="hidden" name="shareId" value="${shareId}">
			</c:if>
		</form>
	    <input type="file" name="file" id="file" accept=".eml" onchange="onDrop()" style="display: none;" multiple />
		<iframe name="importMailboxIframe" src="about:blank" style="display: none"></iframe>
		<form method="post" id="importMailboxform" name="importMailboxform" enctype="multipart/form-data" target="importMailboxIframe">
	        <input type="file" name="file1" id="file1" accept=".zip" onchange="mailbox_attach_import()" style="display: none"/>
	    </form>
	    <div class="layerpopup"  style="z-index: 10000; position: absolute;display: none;" id="iFramePanel">
	    	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_sub">&nbsp;</div>
		<div class="layerpopup"  style="z-index:2000; position:absolute; display:none; overflow:hidden;" id="iFramePanel_sub">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer_sub"></iframe>
		</div>
		<div class="layerpopup"  style="z-index:3000; position:absolute; display:none; overflow:hidden; border:1px solid;" id="iFramePanel_mail_preview">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="mail_preview_Layer"></iframe>
		</div>
	    <div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<input name="keyword" id="keyword" style="vertical-align: top; display: none;" onkeyup="return search_keypress(event)">
		<input name="prekeyword" id="ALL" style="vertical-align: top;height:25px; margin-right:5px;display:none;" onkeyup="return search_keypress(event)" placeholder=<spring:message code="ezEmail.t641" />>
		<span style="display:none;" value="<c:out value='${folderName}'/>"/>
		<select id="select2" style="height: 25px;margin-right: 5px; display:none;">
			    	<option value="ALL"><spring:message code="ezEmail.t643" /></option>      
				    <c:forEach var="folderName" items="${topLevelFolderNames}" varStatus="status">
				    <option value="<c:out value='${folderName}'/>">
						<c:choose>
							<c:when test="${folderName eq 'INBOX'}">
								<spring:message code="ezEmail.t644" />
							</c:when>
							<c:when test="${folderName eq 'Sent'}">
								<spring:message code="ezEmail.t645" />
							</c:when>
							<c:when test="${folderName eq 'Drafts'}">
								<spring:message code="ezEmail.t646" />
							</c:when>
							<c:when test="${folderName eq 'Trash'}">
								<spring:message code="ezEmail.t647" />
							</c:when>
							<c:when test="${folderName eq 'Personal folder'}">
								<spring:message code="ezEmail.t648" />
							</c:when>
							<c:otherwise>
								<c:out value='${folderName}'/>
							</c:otherwise>
						</c:choose>      	
				    </option>
				    </c:forEach>
			    </select>
				
		
	</body>
	<script>
	function set_searchKey() {
    	searchCArray = [];
    	searchKArray = [];
    	var usepostDate = document.getElementById("selectRange").value;

    	if(usepostDate == "all"){
			this.usepostDate = false;	
		} else {
			this.usepostDate = true;
		}

    	if (TrimText(prekeywordDetail1.value).length == 1 || TrimText(prekeywordDetail2.value).length == 1 || TrimText(prekeywordDetail3.value).length == 1) {
    	    alert("<spring:message code='ezSystem.yja01' />");
    	    return;
    	}

   		if (!TrimText(prekeywordDetail1.value) && !TrimText(prekeywordDetail2.value) && !TrimText(prekeywordDetail3.value) && !this.usepostDate ) {
    		alert(strLang254);
            return;
   		} 

       	if (prekeywordDetail1.value) {
       		searchCArray.push(TrimText(selectDetail1.value));
   			searchKArray.push(TrimText(prekeywordDetail1.value));
       	} 
       	if (prekeywordDetail2.value) {
       		searchCArray.push(TrimText(selectDetail2.value));
   			searchKArray.push(TrimText(prekeywordDetail2.value));
       	} 
       	if (prekeywordDetail3.value) {
       		searchCArray.push(TrimText(selectDetail3.value));
   			searchKArray.push(TrimText(prekeywordDetail3.value));
       	} 
       	searchCArray.push("ATTACHSTATUS");
       	searchKArray.push(document.querySelector("input[name=attachment]:checked").value);
       	
       	searchCArray.push("ANDOR");
       	searchKArray.push(document.querySelector("input[name=andor]:checked").value);

    	start_search();
    }
	function SearchOptionHidden() {
     	$.modal.close();
     }
	function changeLangeEvent(){
    	var usepostDate = document.getElementById("selectRange").value;
		if(usepostDate == "direct"){
			document.getElementById("datepickerData").style.display = "";
		    $("#Sdatepicker").datepicker('enable');
		    $("#Edatepicker").datepicker('enable');
		    $(".ui-datepicker-trigger").style="margin-left:5px;margin-top:0px;margin-bottom:3px;vertical-align:middle;cursor:pointer";
		} else if(usepostDate == "all"){
		    $("#Sdatepicker").datepicker('disable');
		    $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
		    $("#Edatepicker").datepicker('disable');
		} else {
		    $("#Sdatepicker").datepicker('disable');
		    $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
		    $("#Edatepicker").datepicker('disable');
		}
		
		var today = new Date();
		switch(usepostDate) {
			case "oneWeek":
				$("#Sdatepicker").datepicker('setDate', '-7d');
				$("#Edatepicker").datepicker('setDate', today);
			break;
			case "oneMonth":
				$("#Sdatepicker").datepicker('setDate', '-1m');
				$("#Edatepicker").datepicker('setDate', today);
			break;
			case "threeMonth":
				$("#Sdatepicker").datepicker('setDate', '-3m');
				$("#Edatepicker").datepicker('setDate', today);
			break;
			case "sixMonth":
				$("#Sdatepicker").datepicker('setDate', '-6m');
				$("#Edatepicker").datepicker('setDate', today);
			break;
			case "oneYear":
				$("#Sdatepicker").datepicker('setDate', '-12m');
				$("#Edatepicker").datepicker('setDate', today);
			break;
		}
    }
	</script>
</html>
