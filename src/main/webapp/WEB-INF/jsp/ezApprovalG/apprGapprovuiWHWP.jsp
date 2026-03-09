<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t1'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprovUI_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezAprove_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
	        var OrgAprUserID = "<c:out value ='${orgAprUserID}'/>";
	        var OrgAprUserName = "<c:out value ='${orgAprUserName}'/>";
	        var OrgAprUserName2 = "";
	        var OrgAprUserDeptID = "<c:out value ='${orgAprUserDeptID}'/>";
	        var pEndDocHref = "<c:out value ='${dirPath}'/>";
	        var pDocID = "<c:out value ='${docID}'/>";
	        var pingUserID = "<c:out value ='${tempUserID}'/>";
	        var pDocInfo = null;
	        var pDocHref = new String("");
	        var pUserID = new String("");
	        var pHasAttachYN = new String("");
	        var pAprMemberSN = 0;
	        var flag = false;
	        var Btnflag = "true";
	        var FormProc = null;
	        var arrPrevDoc = new Array();
	        var arrNextDoc = new Array();
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var xmlaprline = createXmlDom();
	        var xmlattach = createXmlDom();
	        var Resultxml = createXmlDom();
	        var hapyuiCount = 0;
	        var gongramCount = 0;
	        var pSuSinFlag;
	        var pChamJoFlag;
	        var pReDraftAprLineFlag;
	        var SignCount = 0;
	        var SignInfo;
	        var pAprLineType;
	        var gamsaCount = 0;
	        var pDraftFlag;
	        var pSusinSN;
	        var pOrgDocID;
	        var pDocType;
	        var OrgHtml;
	        var SaveHtml;
	        var invalidflag = false;
	        var LineModify = false;
	        var pOrgAprUserID;
	        var pOrgAprUserName;
	        var pOrgAprUserName2;
	        var pOrgAprUserJobTitle;
	        var pOrgAprUserDeptID;
	        var pOrgAprUserDeptName;
	        var docAccess = false;
	        var modeflag = true;
	        var isjunkyul = false;
	        var gPublic = "";
	        var pDocTitle = "";
	        var pFormID = "";
	        var drafterDeptid = "";
	        var pMaxFileSize = "5"
	        var LastSignNo;
	        var AppendFileAttach = "";
	        var AppenAprDocAttachList = "";
	        var TempsaveAprlineinfo;
	        var aprlineinfoTMP;
	        var modarpline = "";
	        var SignType = new Array();
	        var SignName = new Array();
	        var SignContent = new Array();
	        var RootURL = document.location.protocol + "//" + document.location.hostname;
	
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
	        var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
	        var companyID = "<c:out value ='${userInfo.companyID}'/>";
	        var KuyjeType = "002";
	        var signDateFormat = "<c:out value ='${optSignDateFormat}'/>";
		    var isSplit = "<c:out value ='${optisSplit}'/>";
	        var SplitKind = "<c:out value ='${optSplitKind}'/>";
	        var junKyukInfo = "<c:out value ='${optjunKyukInfo}'/>";
	        var FirstHtml = "";
	        var beforeHtml;
	        var beforeHwp = "";
	        var totalMemSN = "0";
	        var beforeWholeHwp_B = "";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "";
	        var cabinetID = "";
	        var TaskCode = "";
	        var DocNumCode = "";
	        var allFlag = "<c:out value ='${allFlag}'/>";
		    var selectedDocID = "";
		    var OpinionAction = "";
		    var CurrYear = "<c:out value ='${oldYear}'/>";
		    var SummaryFlag = true;
		    var pGubun;
		    var isExtDoc;
		    var pUse_Editor = "<c:out value ='${useEditor}'/>";
	        var g_szUserID = arr_userinfo[8];
	        var g_senderinfo = "<c:out value ='${userInfo.companyName}'/>" + ", " + "<c:out value ='${userInfo.deptName}'/>" + ", " + "<c:out value ='${userInfo.title}'/>";
	        var isHWP = "<c:out value ='${isHWP}'/>";
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var ext = "hwp";
	        var aprDocTimeStamp = "";
	        var docState = "<c:out value ='${docState}'/>";
	        var nonElecRec = "<c:out value ='${nonElecRec}'/>";
	        var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
	        var useReceiveDocNo = "<c:out value ='${useReceiveDocNo}'/>";
	        var orgCompanyID = "<c:out value='${orgCompanyID}' />";
	        var docNumZeroCnt = "<c:out value ='${docNumZeroCnt}'/>";

	        //원문공개정보
            var useOpenGov = "<c:out value ='${useOpenGov}'/>";
			var basis = "<c:out value ='${basis}' />";
            var reason = "<c:out value ='${reason}' />";
            var listOpenFlag = "<c:out value ='${listOpenFlag}' />";
            var fileOpenFlagList = "<c:out value ='${fileOpenFlagList}' />";
	        
	        var curDocNum = "";
	        
	        var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			var formAprOption = "<c:out value='${formAprOption}'/>";
			
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
			
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
			var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>";
			
			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			var type = "ING"; // 2023-05-23 임정은 - 공람 추가
	        
			// 2024-06-11 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부
			var useReceiptDeptFileAttach = "<c:out value ='${useReceiptDeptFileAttach}'/>";

			// 2024-06-24 양지혜 - 지정반송 기능 사용여부
			var useReturnByDesignation = "<c:out value ='${useReturnByDesignation}'/>";
			
		    var junGyulFlag = "<c:out value ='${junGyulFlag}'/>";
			var draftJunGyulFlag = "<c:out value ='${draftJunGyulFlag}'/>"; // 일반버전 서명 remapping 시 전결문자 표출 확인용 (0 : 미표출 / 1 : 표출, default)
			var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임)
			var addLastKyulJeYN = "<c:out value ='${addLastKyulJeYN}'/>";
			var totalMemSN = "0";
			var signImageType = "<c:out value ='${signImageType}'/>";
			var pADMIN = "N";
			var AprLineArea = 0;
			var HapyuiArea = 0;
		  	//회람
			var type = "ING";
			var pGongRamDocID = "";
			
			// 2024-12-10 기민혁 - 수정버전 변경 기능 사용여부
			var editVersionYN = "<c:out value ='${editVersionYN}'/>";
			// 2024-12-10 기민혁 - 수정버전
			var editVersion = "";
			// 2024-12-10 기민혁 - 수정버전 모드
			var editMode = "";
			// 수정후 히스토리 및 문서 저장 시 오류로 인해 전역변수로 변경함
			var beforeDocURL;
			
			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";

            // 2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
            var snapshotCode = "<c:out value ='${snapshotCode}'/>";

            var isPreview = "${isPreview}";
            
            // 일괄 타입 B
            var draftAllTypeB = "<c:out value ='${draftAllTypeB}'/>";
            var pMode;
			var draftAllFlag = "N";
			var groupDocSN = "<c:out value ='${groupDocSN}'/>"; // 일괄기안된 문서가 가지는 TBL_APRDOCGROUPINFO의 GROUPDOCSN값 (1안의 DOCID)
			var pDocHrefAry = new Array();
	        var pFormIDAry = new Array();
	        var pSuSinFlagAry = new Array();
	        var pDocIDAry = new Array();
	        var pOrgDocIDAry = new Array();
	        var pDocTypeAry = new Array();
	        var pDocTitleAry = new Array();
	        var pDocNumCodeAry = new Array(); // 문서번호 배열
	        var pDocNumSnAry = new Array(); // 문서번호 숫자부분(tempNumString) 배열
	        
	        var pHasAttachYNAry = new Array();
	        var pHasDocAttachYN = new String("N");
	        var pHasDocAttachYNAry = new Array();
	        var attachReload = new Array();
	        var pHasOpinionYN = new String("N");
	        var pHasOpinionYNAry = new Array();
	        
	        var SignInfoAry = new Array();
	    	var hapyuiCountAry = new Array();
	    	var SignCountAry = new Array();
	    	var gamsaCountAry = new Array();

	    	var extAry = new Array();

			var htmlDataAry = new Array(""); // 웹한글기안기의 GetHTML 함수가 비동기로 동작하므로, 이 배열에 가져온 data를 넣어준다. 
			var pOrgHtmlAry = new Array(""); // 결재 중 오류 발생 시 원래 문서로 돌려주기 위한 데이터 저장 배열. 기본적으로 htmlDataAry값과 동일하다.
            
			var pDocInfoAry = new Array();
			var pAttachInfoAry = new Array();
			var currentTabIdx = 0;
			var attachHTML = new Array();
			var docAttachHTML = new Array();
			var attachLoad = new Array();
			var anCnt = 1;
			var FirstHtmlAry = new Array();
			var SaveHtmlAry = new Array();
			var extYNAry = new Array();
			var strBytesAry = new Array();
			
			var wAprMemberSN = "";
            var isPreview = "${isPreview}";
            
		    function getNextDocList() {
		        NextDocID = "";
		        if (selectedDocID != "") {
		            var xmldoclist = createXmlDom();
		            xmldoclist.async = false;
		            xmldoclist.loadXML(selectedDocID);
		            if (xmldoclist.documentElement.childNodes.length > 0) {
		                var breakflag = false;
		                for (var i = 0; i < xmldoclist.documentElement.childNodes.length; i++) {
		                    if (getNodeText(xmldoclist.documentElement.childNodes(i)) == pDocID)
		                        breakflag = true;
		                    else if (breakflag) {
		                        breakflag = false;
		                        getNextDocOne(getNodeText(xmldoclist.documentElement.childNodes(i)));
		                    }
		                }
		            }
		        }
		    }
	
		    var ezaprallalert_cross_dialogArguments = new Array();
		    var getformcont_Cross_OpenWin = "";
		    function OpenAllApproveFlag() {
		        var window_left = window.screen.availWidth / 2 - 160;
		        var window_top = window.screen.availHeight / 2 - 90;
		        
		        ezaprallalert_cross_dialogArguments[0] = "";
		        ezaprallalert_cross_dialogArguments[1] = OpenAllApproveFlag_Complete;
		
		        AllApprove.style.display = "none";
		        var parameter = "";
		        var url = "/ezApprovalG/ezAprAllAlert.do";
		        //var feature = "status:no;dialogWidth:326px;dialogHeight:205px;help:no;scroll:no;dialogLeft:" + window_left + ";dialogTop:" + window_top + "";
		        //var RtnVal = window.showModalDialog(url, parameter, feature);
		
		        DivPopUpShow(326, 205, url);
			}
		    
		    /**
		    * RtnVal -> 0 : 결재, 1 : 다음문서, 2 : 문서보기, 3 : 취소
		    */
		    function OpenAllApproveFlag_Complete(RtnVal) {
		    	DivPopUpHidden();
		    	
		    	if ("<c:out value ='${isPreview}'/>" != "Y") {
		    		AllApprove.style.display = "";
		    	}
				
		        if (RtnVal == "0") {
		            btnApprove_onclick();
		        }
		        else if (RtnVal == "1") {
		
		            if (allFlag == "1")
		                //btnStay_onclick();
		            	LoadNextDocument("\n<spring:message code='ezApprovalG.t2'/>");
		            else if (allFlag == "2")
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t2'/>");
			    }
			    else if (RtnVal == "2") {
			        return;
			    }
			    else if (RtnVal == "3") {
			        window.close();
			        btnClose_onclick();
			    }
			}
	
			function LoadNextDocument(tempString) {
			    if (allFlag == "1")
			        getNextDocInfo();
			    else if (allFlag == "2")
			        getNextDocList();
			
			    if (NextDocID == "") {
			        if (tempString == "")
			            var pAlertContent = "<spring:message code='ezApprovalG.t3'/>";
				    else {
				        tempString = tempString.replace("\n<spring:message code='ezApprovalG.t2'/>", "");
				        tempString = tempString.replace("\n\n<spring:message code='ezApprovalG.t4'/>", "");
				        tempString = tempString.replace("\n", "");
				        var pAlertContent = tempString + "<br><spring:message code='ezApprovalG.t3'/>";
		            }
			        OpenAlertUI(pAlertContent, btnClose_onclick); // 알림창 확인 시 문서창 닫도록 수정
		            //window.parent.close();
		            //btnClose_onclick();
		        }
		        else {
		            if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() != "hwp") {
		                openOtherApprovUI();
		                return;
		            }
		            
		            DocNumCode = "";
		            
		            showLoadingProgress();
		            
		            if (pDocID == NextDocID) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t3'/>";
				        OpenAlertUI(pAlertContent);
				        window.parent.close();
				        btnClose_onclick();
				        return;
				    }
		
		            pDocID = NextDocID;
		            OrgAprUserID = NextDocUserID;
		            OrgAprUserName = NextDocUserName;
		            OrgAprUserName2 = NextDocUserName2;
		            OrgAprUserDeptID = NextDocDeptID;
		
		            getApprovInfo();
		            pUserID = pOrgAprUserID;
		            getDocInfo();
		            setAttachInfo(pDocID, "APR", lstAttachLink);
		            GetExchInfo();
		            if(nonElecRec=="Y"){
						getNonElecInfoSusinInit();
					}
		
		            if (pDocHref != "") {
		            	var URL;
		            	URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
	                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
		            }
		        }
		    }
	
		    function openOtherApprovUI() {
		        var pArgument = new Array();
		        pArgument[0] = NextDocID;
		        pArgument[1] = NextDocUserID;
		        pArgument[2] = NextDocUserName;
		        pArgument[4] = NextDocUserName2;
		        pArgument[3] = NextDocDeptID;
		
		        var formURL = NextDocHref;
		        if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "doc") {
		            var openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word.aspx?DocID=" + escape(pArgument[0]);
		
		            openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]) + "&uName2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		        } else if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "hwp" && useWebHWP == "NO") {
		            var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&ID=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag);
		        } else if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "hwp" && useWebHWP == "YES") {
		            var openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag);
		        }
		        /* 2020-12-24 홍승비 - 모두결재 시 웹한글문서 다음에 일반 mht문서가 위치하는 경우, 연결 URL 수정 */
		        else if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "mht") {
		        	openLocation = "/ezApprovalG/approvui.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag) + "&orgCompanyID=" + orgCompanyID;
		        }
		        else {
		            if (pUse_Editor == "TAGFREE") {
		                var openLocation = "/myoffice/ezApprovalG/ApprovUI/approvui_IE.aspx?DocID=" + escape(pArgument[0]);
		                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]) + "&uName2=" + escape(pArgument[4]);
		                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		            } else {
		                var openLocation = "/myoffice/ezApprovalG/ApprovUI/approvui.aspx?DocID=" + escape(pArgument[0]);
		                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]) + "&uName2=" + escape(pArgument[4]);
		                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		            }
		        }
		
		        try {
		            window.opener.openwindow(openLocation, "", 880, 550);
		            window.close();
		        } catch (e) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t5'/>";
				        OpenAlertUI(pAlertContent);
				        window.close();
				        btnClose_onclick();
				    }
		        }
	
		    window.onresize = function () {
	       		document.getElementById("messageWHWPEditor").style.height = document.documentElement.clientHeight - 150 + "px";
	       		var mHeight = document.documentElement.clientHeight - 110 - document.getElementById("messageWHWPEditor").offsetTop + "px";
	       		message.Resize(mHeight);
	        }
	
		        function window_onload() {
		            if (allFlag == "2") {
		                try {
		                    selectedDocID = window.opener.selectedDocIDS;
		                }
		                catch (e) {
							selectedDocID = window.parent.selectedDocIDS;
						}
		            }
		
		            try {
		            	var agent = navigator.userAgent.toLowerCase();
		
		                getApprovInfo();
		
		                pUserID = pOrgAprUserID;
		                getDocInfo();
		                setAttachInfo(pDocID, "APR", lstAttachLink);
		                GetExchInfo();
		                
		                if (nonElecRec == "Y") {
					        getNonElecInfoSusinInit();
					        document.getElementById("btnAddSepAttach").style.display = "none";
				        }
		                
				        if(useExternalMailServer == "NO") {
				    		$("#btnMail").css("display","");
				    	}

						if (useReturnByDesignation == "YES") {
							document.getElementById("btnReject2").style.display = "";
						}
				        
						// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
						setAttachGuideText();
		                
                        // 일괄기안 B
                        <c:if test="${fn:length(group) > 0}">
                            anCnt = an.options.length;
                            anCnt > 1 ? draftAllFlag = "Y" : draftAllFlag = "N";
                            pDocIDAry.push("");
                            pDocHrefAry.push("");
                            pDocTypeAry.push("");
                            extAry.push("");
                            extYNAry.push("");
        
                            <c:forEach items="${group}" var="item">
                                pDocIDAry.push("${item.docID}");
                                pDocHrefAry.push("${item.docHref}"); // 문서경로
                                pDocTypeAry.push("${item.docType}"); // 문서타입 (내부결재, 수신문...)
                                extAry.push("${item.docHref}".substring("${item.docHref}".lastIndexOf(".") + 1)); // 확장자
                                extYNAry.push("${item.extYN}"); // extYN
                            </c:forEach>		                
                            pMode = getDocMode();
                            getApprovInfoAll(pDocIDAry); // 결재문서 기본 정보
                            getAttachInfoAll(pDocIDAry); // 첨부파일 정보
                        </c:if>
			        }
			        catch (e) {
			        	alert("<spring:message code='ezApprovalG.t1373'/>" + e);
			        	
				        hideProgress();
				    }
		    }
	
            function getApprovInfoAll(pDocIDAry) {
                try {
                    var result = new Array(); // 배열로 결재문서 정보 받기
                    
                    $.ajax({
                        type : "POST",
                        dataType : "json",
                        async : false,
                        url : "/ezApprovalG/getApproveDocInfoAll.do",
                        data : {
                            docIDArr : pDocIDAry,
                            deptID : OrgAprUserDeptID,
                            mode : pMode,
                            chamState : docState,
                            orgCompanyID : orgCompanyID
                        },
                        success : function(xml) {
                            result = xml;
                            
                            for (var i = 1; i < result.length; i++) { // [0] 인덱스는 미사용, [1]부터 사용
                                pDocInfoAry[i] = result[i];
                                var info = loadXMLString(result[i]);
                                pFormIDAry[i] = info.getElementsByTagName("FORMID").item(0).textContent;
                                pHasAttachYNAry[i] = info.getElementsByTagName("HASATTACHYN").item(0).textContent;
                                var opinion = info.getElementsByTagName("HASOPINIONYN").item(0).textContent;
                                pHasOpinionYNAry[i] = !opinion ? "N" : opinion;
                                pDocTitleAry[i] = info.getElementsByTagName("DOCTITLE").item(0).textContent;
                            }
                        },
                        error : function (e) {
                            console.log(e);
                        }
                    });
                }
                 catch (e) {
                    console.log(e);
                }
            }
            
            function getAttachInfoAll(pDocIDAry) {
                try {
                    var result = new Array(); // 배열로 첨부파일 정보 받기
                    
                    $.ajax({
                        type : "POST",
                        dataType : "json",
                        async : false,
                        url : "/ezApprovalG/getTotalAttachInfoAll.do",
                        data : {
                            docIDArr : pDocIDAry,
                            mode : pMode,
                            orgCompanyID : orgCompanyID
                        },
                        success: function(xml){
                            result = xml;
                            
                            for (var i = 1; i < result.length; i++) { // [0] 인덱스는 미사용, [1]부터 사용
                                pAttachInfoAry[i] = result[i];
                            }
                        },
                        error : function (e) {
                            console.log(e);
                        }
                    });
                }
                catch (e) {
                    console.log(e);
                }
            }
	        var isLastSaveDoc = false;
		    function FieldsAvailable(isTrue) {
		        if (isTrue) {
		            var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT", "")
		            if (!rtnVal) {
		                var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
				        OpenAlertUI(pAlertContent);
				        return;
		            }
		
		            process_AfterOpen();
		            hideLoadingProgress();
		            CheckOpinionYN();
		
		            if ("<c:out value ='${isPreview}'/>" != "Y") {
		            	AllApprove.style.display = "";
		            }
		            
		            if (allFlag == "1" || allFlag == "2") {
		                OpenAllApproveFlag();
		            }
		            message.EditMode(0);
					message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            
		            window.onresize();
		            
		            if(anCnt > 1){
                        scrollPos[0] = 0;
                        message.HwpCtrl.AddEventListener(2, function(){
                            for(var i = scrollPos.length - 1; i >= 0; i--){
                                if(message.HwpCtrl.ScrollPosInfo.Item("VertPos") >= scrollPos[i]){
                                    if(currentTabIdx != i + 1){
                                        changeAn(i + 1, true);
                                    }
                                    break;
                                }
                            }
                        });
                        for(var i = 0; i < anCnt; i++){
                            pSuSinFlagAry[i + 1] = message.FieldExist("recipient{{" + i + "}}")
                        }
                        hwpChange(() => scrollSetBefore(1));
                    }
		        }
		        else {
		        	hideLoadingProgress();
		            var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			        OpenAlertUI(pAlertContent);
			        message.Clear();
		        }
		        message.FreeUndoHistory();
		    }
	
		    function CheckOpinionYN() {
		    	if (pDraftFlag == "SUSIN"){
		            getSusinSNInfo();
		    	} else {
		            pSusinSN = "0";
		    	}
		        if (pHasOpinionYN == "Y") {
		            var pInformationContent = "<spring:message code='ezApprovalG.t1374'/><br> <spring:message code='ezApprovalG.t10'/>";
			        var Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
			    }
		    }
		    
		    function CheckOpinionYN_complete(Ans) {
		    	DivPopUpHidden();
		    	if (Ans) {
		            //openOpinionUI("Display");
		        	openOpinionUI_New("");
		        }
		    }
	
		    function process_AfterApprove(mode) {
		    	
		    	/*  2023-02-08 홍승비 - WHWP 문서의 편집모드 적용 후 수정이력 비교 기능을 위해 isBeforeDoc, beforeDocURL 파라미터 추가 */
		    	// MHT 문서와는 다르게 편집모드 적용 시 수정이력이 *바로 반영되지 않으므로* 주의 (2023-02-09 기준, 필요 시 차후 동일 스펙으로 수정 가능)
				// 2023-08-24 강동주 - MHT 문서와는 마찬가지로 편집모드 적용 시 수정이력을 *바로 반영*하도록 수정함
//				if (FirstHtml != "") {
//					var beforeDocURL = UpdateDocHistory(FirstHtml, "Y", ""); // 수정전 문서 이력저장
//					UpdateDocHistory(SaveHtml, "N", beforeDocURL); // 수정후 문서 이력저장
//		        }
		    	/*
		    	if(anCnt > 1){
		    	    for(var i = 0; i < FirstHtmlAry.length; i++){
		    	        if(FirstHtmlAry[i]){
		    	            pDocID = pDocIDAry[i + 1];
                            var beforeDocURL = UpdateDocHistory(FirstHtmlAry[i], "Y", ""); // 수정전 문서 이력저장
                            UpdateDocHistory(SaveHtmlAry[i], "N", beforeDocURL); // 수정후 문서 이력저장
		    	        }
		    	    }
		    	    pDocID = pDocIDAry[1];
		    	}else if (FirstHtml != "") {
					var beforeDocURL = UpdateDocHistory(FirstHtml, "Y", ""); // 수정전 문서 이력저장
					UpdateDocHistory(SaveHtml, "N", beforeDocURL); // 수정후 문서 이력저장
		        }
		        */
		        
		        if (mode == "1") {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1375'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1376'/>";
				        OpenAlertUI(pAlertContent, Draft_Complete);
				        /* btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        
				      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				        	parent.opener.clearAbsence(true);
				        }
				        return; */
				    }
		        }
		        else if (mode == "2") {
		        	/* 2022-03-24 홍승비 - 웹한글문서 반송 시에도 반송알림메일 발송 */
		        	SendMailBansongtoDrafter();
		        	
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1377'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1378'/>";
				        OpenAlertUI(pAlertContent, Draft_Complete);
				        /* btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        
				      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				        	parent.opener.clearAbsence(true);
				        }
				        return; */
				    }
		        }
		        else if (mode == "3") {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1379'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1380'/>";
				        OpenAlertUI(pAlertContent, Draft_Complete);
				       /*  btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        
				      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				        	parent.opener.clearAbsence(true);
				        }
				        return; */
				    }
		        }
		        else {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1381'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1382'/>";
				        OpenAlertUI(pAlertContent, Draft_Complete);
				        /* btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        return; */
				    }
		        }
			}
		    
		    function Draft_Complete() {
		        btnClose_onclick();
		        Btnflag = "false";
		        ChangeBtnState();
		        
		        //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
		        	parent.opener.clearAbsence(true);
		        }
		    }
		    
		    function btnApprove_chkpassword_Complete(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            
		            return;
		        }
		        else if (chkpass == "cancel" || chkpass == undefined) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            
		            return;
		        }
		        check_openSingUI();
		    }
	
			function setbutton() {
			    ChangeBtnState();
			}
	
			function process_AfterOpen() {
			    getCurApproverAprLine();
			    pGubun = "8";
			    
			    /* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
		        message.startRemapAllAprSign_WHWP(pDocID, orgCompanyID);
		        
		        // 현재 문서가 수신문이면서 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
		        if (pDraftFlag == "SUSIN" && pOrgDocID != null && typeof(pOrgDocID) != "undefined" && pOrgDocID != "") {
		        	message.startRemapAllAprSign_WHWP(pOrgDocID, orgCompanyID);
		        }

			    if (approvalFlag == "S") {
                    if (pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
                        if (pAprLineType != strAprType8 && pAprLineType != strAprType9) {
                            setMenuBar("btntotaldocinfo", false);
                        }
                        setMenuBar("btnJunKyul", false);
                        setMenuBar("btnModAprLine", false);
                        setMenuBar("btnEdit", false);
                        setMenuBar("btnDocInfo", false);
                        setMenuBar("btnFileAttach", false);
                        setMenuBar("btnAprDocAttach", false);
                        setMenuBar("btnModAprDept", false);
                        setMenuBar("btnSetTaskCode", false);
                        setMenuBar("btnAddSepAttach", false);
                        pGubun = "10";
                    } else if (pAprLineType == strAprType4) {
                        setMenuBar("btnJunKyul", false);
                        setMenuBar("btnModAprLine", false);
                        setMenuBar("btnModAprDept", false);
                        setMenuBar("btnEdit", false);
                        setMenuBar("btnFileAttach", false);
                        setMenuBar("btnAprDocAttach", false);
                        pGubun = "14";
                    }
                } else {
                    if (pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
                        if (pAprLineType != strAprType8 && pAprLineType != strAprType9) {
                            setMenuBar("btntotaldocinfo", false);
                        }
                        setMenuBar("btnJunKyul", false);
                        setMenuBar("btnModAprLine", false);
                        setMenuBar("btnEdit", false);
                        setMenuBar("btnDocInfo", false);
                        setMenuBar("btnFileAttach", false);
                        setMenuBar("btnAprDocAttach", false);
                        setMenuBar("btnModAprDept", false);
                        setMenuBar("btnSetTaskCode", false);
                        setMenuBar("btnAddSepAttach", false);
                        pGubun = "10";
                    }
                    else if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
                        setMenuBar("btnModAprLine", false);
                        pGubun = "5";
                    }
			    }
			
			    if (KuyjeType == "001")
			        setBtnDisableAprLineType();
			
			    if (pDraftFlag == "SUSIN") {
			        if (message.FieldExist("susinbody"))
			            setMenuBar("btnEdit", true);
			        else
			            setMenuBar("btnEdit", false);
			
			        setMenuBar("btnModAprDept", false);
			        
			        if (useReceiptDeptFileAttach == "NO") {
		            	setMenuBar("btnFileAttach", false);
			            setMenuBar("btnAprDocAttach", false);	
		            }
			        
			        pGubun = "6";
			    }
			
			    else {
			        pSuSinFlag = "Y";
			
			        var RtnVal = message.FieldExist("recipient{{0}}");
			        if (RtnVal) {
			            pSuSinFlag = "Y";
			            setMenuBar("btnModAprDept", true);
			        } else {
			            pSuSinFlag = "N";
			            setMenuBar("btnModAprDept", false);
			            if (pGubun == "5") {
			                pGubun = "7";
			            }
			            else {
			                pGubun = "6";
			            }
			        }
			
			        if (pDraftFlag == "HABYUI") {
			            setMenuBar("btntotaldocinfo", false);
			        }
				}
			    //SignCheck();

				// 2024-06-27 임정은 - 협조자도 공람자 지정할 수 있도록 변경
				if (approvalFlag == "G" && pGubun == "6" && (pAprLineType == strAprType8 || pAprLineType == strAprType9)) {
					pGubun = "14";
				}
			}
	
			// btnApprove_onclick 시작
			var approveResult;
            var ingFlag = false;
            var tryCnt = 0;
			function btnApprove_onclick() {
			    tryCnt = 0;
                if (ingFlag) {
                    return;
                }
                if(anCnt > 1)
                    changeAn(1, true);
                
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getExtTotalAttachSize.do",
		    		data : {
		    			docID : anCnt > 1 ? pDocIDAry.toString() : pDocID
		    		},
		    		success: function(text){
		    			approveResult = text;
		    		}        			
		    	});

	    		GetHTML2(Approve);
		    }
			 // btnApprove_onclick 끝
				 
			 function GetHTML(callback) {
                ingFlag = true;
                if(anCnt > 1)
                    lastAnSave(callback);
                else
			        message.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data); });
			 }
			 
			 function GetHTML2(callback) {
                ingFlag = true;
                if(anCnt > 1){
                    var lengthCnt = 0;
                    for(var i = 1; i <= anCnt; i++){
                        if(extYNAry[i] == "Y"){
                            message.HwpCtrl.MoveToField("body{{" + (i-1) + "}}", true, true, true);
                            message.HwpCtrl.SaveAs("","PUBDOCBODY", "saveblock", function (data) {
                                strBytesAry[i] = data.size;
                                if(++lengthCnt == anCnt)
                                    callback("");
                            });
                        }else
                            if(++lengthCnt == anCnt)
                                callback("");
                    }
                }else
    			    message.GetTextFile("HWPML2X", "", function (data) { ingFlag = false; callback(data); });
			 }
			 
			 function SetHTML(data, callback) {
			    message.SetTextFile(data, "HWP", "", function (result) { callback(result) });
			 }
			 
			 // btnApprove_onclick -> Approve 시작
			 function Approve(html) {
				var strBytes = parseInt(getByteLength(html));
			    	
                var rtnAttachXML = loadXMLString(approveResult);
	                
	            var attachTotalSize = getNodeText(rtnAttachXML.getElementsByTagName("TOTALSIZE").item(0));
	            
	            var tmpAn = getNodeText(rtnAttachXML.getElementsByTagName("PAGENUM").item(0));

                if(getNodeText(rtnAttachXML.getElementsByTagName("FLAG").item(0)) == "Y") {
                    OpenAlertUI("외부발송문서 총 첨부용량은 최대 6MB 입니다" + "<br>" + (tmpAn ? tmpAn + "<spring:message code='ezApprovalG.HSBDa04_1'/> " : "") + "첨부용량을 줄여주시기 바랍니다.");
                    return;
                }

                // 본문과 첨부파일의 총합이 7.4mb가 초과시 알러트 결재라인 수정시에도 2018-07-19 강민수92
                if(anCnt > 1){
                    attachTotalSize = getNodeText(rtnAttachXML.getElementsByTagName("TOTALSIZE").item(1)).split(",");
                    for(var i = 1; i <= anCnt; i++){
                        if (strBytesAry[i] && strBytesAry[i] + parseInt(attachTotalSize[i]) > 7400000) {
                            OpenAlertUI("외부발송문서 총 용량은 최대 7.4MB 입니다" + "<br>" + i + "<spring:message code='ezApprovalG.HSBDa04_1'/> 첨부파일이나 본문용량을 줄여주시기 바랍니다.");
                            return;
                        }
                    }
                }else if (getNodeText(rtnAttachXML.getElementsByTagName("EXTFLAG").item(0)) == "Y" && strBytes + parseInt(attachTotalSize) > 7400000) {
                	OpenAlertUI("외부발송문서 총 용량은 최대 7.4MB 입니다" + "<br>" + (tmpAn ? tmpAn + "<spring:message code='ezApprovalG.HSBDa04_1'/> " : "") + "첨부파일이나 본문용량을 줄여주시기 바랍니다.");
                    return;
                }
                
                if (OrgAprUserID != arr_userinfo[1]) {
                    if (!confirm(OrgAprUserName + "<spring:message code='ezApprovalG.t2106'/>")) {
                    	window.returnValue = "CLOSE";
                    	btnClose_onclick();
                        return;
                    }
                }
                
				/* 백단 결재 실패한 이력이 있는 doc은 프론트 결재 로직 */
                if(getCheckNotFailDoc()){
                    backFailFlag = true;
                }
                
			    setMenuDisable("btnApprove", true);
				
			    var parameter = new Array();
			    parameter[0] = pDocID;
			    var signInfo;
				
			    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			        if (pDraftFlag == "HABYUI" || pDraftFlag == "B_GAMSA" || pDraftFlag == "A_GAMSA")
			            getLastOpinon();
			        if (message.FieldExist("lastdraftdate"))
			            message.PutFieldText("lastdraftdate", getGyulJeDate());
			    }
				
			    if (!isjunkyul) {
			        //if ("${approvalPWD}" != "N") {
			        if (CheckUsePassword()) {
			            chk_Passwd(pingUserID, btnApprove_chkpassword_Complete);
		            } else {
		            	check_openSingUI();
		            }
			    } else {
			    	check_openSingUI();
			    }
			 }
			 // Approve 끝
			 
			 function check_openSingUI() {
	            var ret = "NAME"
	            
	            if ((pAprLineType != strAprType2) && (pAprLineType != strAprType7) && (pAprLineType != strAprType15) && (pAprLineType != strAprType17)) {
	                var parameter = new Array();
	                parameter[0] = pDocID;
	                openSingUI(parameter);
	            } else {
	            	Approv_Complete_BackEnd(ret);
	            
					/* UpdateLineHistory();	// 결재완료시 변경 이력 남기도록 변경
			        
		        	setMenuDisable("btnApprove", false);
			        GetHTML(Approve_complete); */
	            }
	        }
			 
			 function openSingUI_Complete(ret) {
				 DivPopUpHidden();
				 if (ret == "cancel" || ret == undefined) {
		            var pAlertContent = "[<spring:message code='ezApprovalG.t29'/>";
			        OpenAlertUI(pAlertContent);
			        setMenuDisable("btnApprove", false);
			        return;
			     }else if(ret == "NAME"){
			        Approv_Complete_BackEnd(ret);
			     }else{
			        Approve_complete(ret);
			     }
				 //Approve_complete(ret);
				 
				 /* if (ret == "NAME") {
		            var Rtnval;
		            var Ans = true
		            if (!Ans) ret = "cancel";
		         }
				
		         if (ret == "cancel" || ret == undefined) {
		            var pAlertContent = "[<spring:message code='ezApprovalG.t29'/>";
			        OpenAlertUI(pAlertContent);
			        setMenuDisable("btnApprove", false);
			        return;
			     } else { 
			        UpdateLineHistory();	// 결재완료시 변경 이력 남기도록 변경
			        
		        	setMenuDisable("btnApprove", false);
			        GetHTML(Approve_complete);
			 	 } */
			 }

            /**
            * BackEnd에서 결재(서명, db처리 등) 처리
            */
            var backFailFlag = false;
            // B타입 최종결재 시 1안 저장 플래그 : saveBtypeFlag
            var saveBtypeFlag = false;
            function Approv_Complete_BackEnd(signtype){
                if (checkAprState()) {
                    alert("<spring:message code='ezApprovalG.bhs23'/>");
                    //모두결재인 경우 다음 문서로 넘어가도록 설정
                    if (allFlag == "1") {
                        LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
                    } else {
                        window.returnValue = "CLOSE";
                        btnClose_onclick();
                    }
                    return;
                }
                
                var res = "";
                if(!backFailFlag){
		            DivPopUpHidden();
                    res = SaveApproveInfoInBackEnd("1");
                    if(res){
                        var resCode = res.status;    // ok / error
                        if(resCode == "ok"){
                            var resData = res.data;  // SUCCESS / FAIL
                            if(typeof resData != "undefined" && resData.toUpperCase() == "SUCCESS"){
                                // 결재 완료
                                setMenuDisable("btnApprove", false);
                                
                                if ((pDraftFlag == "SUSIN" || pAprLineType == strAprType7) && KuyjeType == "001") {
                                    var pAlertContent = "<spring:message code='ezApprovalG.t35'/>";
                                    OpenAlertUI(pAlertContent, Draft_Complete);
                                    return;
                                } else {
                                    if (pAprLineType == strAprType7) {
                                        process_AfterApprove("4");
                                    } else {
                                        process_AfterApprove("1");
                                    }
                                }
                            }else if(typeof resData != "undefined" && resData.toUpperCase() == "FAIL"){
                                // 결재 실패
                                backFailFlag = true;
                            }
                        }else{ // 호출시 데이터 문제(type) or 백단 결재 로직 오류
                            backFailFlag = true;
                        }
                    }
                    /* 백단 결재 로직 실패 시 프론트로 결재*/
                    if(backFailFlag){
                        Approve_complete(signtype);
                    }
                }else{
                    Approve_complete(signtype);
                }
		    }

			   // Approve -> (openSingUI_Complete) -> Approve_complete 시작
			   function Approve_complete(ret) {
				   DivPopUpHidden();

                   var habYuiAprStateFlag = true;
				   if (approvalFlag == "S") {
                        if(checkAprState()){
                            alert("<spring:message code='ezApprovalG.bhs23'/>");
                            window.returnValue = "CLOSE";
                            btnClose_onclick();
                            return;
                        }

                        //공유결재 - 결재, 전결 일때만 사인칸을 다시그리도록 조건추가
                        if (pAprLineType == strAprType1 || pAprLineType == strAprType4) {
                            var reMappingAprLine = getAprLineList("");

                            //참조가 END인 경우 종료된 문서임으로 굳이 sign이나 수신처를 remap할 필요가 없다.
                            if (reMappingAprLine != "END") {
                                SReAprLineSingMapping(reMappingAprLine);

                                if (pSuSinFlag == "Y") {
                                    var reMappingReceipt = getReceiptList();

                                    setRecevInfo(reMappingReceipt);
                                }
                            }
                        }

                        if (addLastKyulJeYN != "0") {
                            var hDocID ;
                            if (pDraftFlag == "HABYUI") {
                                hDocID = pOrgDocID;
                            } else {
                                hDocID = pDocID;
                            }
                            $.ajax({
                                type : "POST",
                                dataType : "text",
                                async : false,
                                url : "/ezApprovalG/lastKyulJeHabYuiYN.do",
                                data : {
                                        docID     : hDocID,
                                        flag      : "approvUi"
                                        },
                                success : function(result){
                                    totalMemSN = result;
                                }
                            });

                            $.ajax({
                                type : "POST",
                                dataType : "text",
                                async : false,
                                url : "/ezApprovalG/checkHabYuiState.do",
                                data : {
                                        docID     : hDocID,
                                        },
                                success : function(result) {
                                    if (result == "FALSE") {
                                        habYuiAprStateFlag = false;
                                    }
                                }
                            });
                        }
                    }
				   
				   if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                var rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")
			                if (!rtnVal) {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
		                }
		            }
				   
				   if (pDraftFlag != "SUSIN" && pDraftFlag != "HABYUI") {
				        if (approvalFlag == "S") {
                            // '현재진행 중인 결재가 개인순차합의가 아닌 경우' 추가
                            // 마지막 결재자가 합의인 경우 totalMemSN 값으로 해당 조건절 사용.
                            if ((LastKyulSN == pAprMemberSN && lastHabYuiSN != 0 && pAprLineType != strAprType8 && pAprLineType != strAprType7 && habYuiAprStateFlag) || pAprLineType == strAprType4 || totalMemSN > 0) {
                                if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType8) {
                                    var rtnval;
                                    //rtnval = getDocNumber(drafterDeptid, "", docNumZeroCnt);
                                    //rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);
                                    if(anCnt < 2)
                                        rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);
                                    else{
                                        approvBack = "Y";
                                        rtnval = true;
                                    }
                                    
                                    if (!rtnval) {
                                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
                                        OpenAlertUI(pAlertContent);
                                        setMenuDisable("btnApprove", false);
                                        return;
                                    }
                                }
                            }
                        } else {
                            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
                                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
                                    var rtnval;
                                    //rtnval = getDocNumber(drafterDeptid, "");
                                    if(anCnt < 2)
                                        rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);
                                    else{
                                        approvBack = "Y";
                                        rtnval = true;
                                    }

                                    if (!rtnval) {
                                        var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
                                        OpenAlertUI(pAlertContent);
                                        setMenuDisable("btnApprove", false);
                                        return;
                                    }
                                }
                            }
                        }
			         } else {
			            	//useReceiveDocNo 처리
				            if (useReceiveDocNo == 'NO') {
				                if (approvalFlag == "S") {
                                    //일반 미처리
                                    if (pDraftFlag == "HABYUI") {
                                        // pDraftFlag != "HABYUI" <- 추가되서 일부서합의 채번작업 코드추가
                                        // '현재진행 중인 결재가 개인순차합의가 아닌 경우' 추가
                                        // 마지막 결재자가 합의인 경우 totalMemSN 값으로 해당 조건절 사용.
                                        if ((LastKyulSN == pAprMemberSN && lastHabYuiSN != 0 && pAprLineType != strAprType8 && pAprLineType != strAprType7 && habYuiAprStateFlag) || pAprLineType == strAprType4 || totalMemSN > 0) {
                                            if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType8) {
                                                var rtnval;
                                                //rtnval = getDocNumber(drafterDeptid, "", docNumZeroCnt);
                                                rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);
                                                if (!rtnval) {
                                                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
                                                    OpenAlertUI(pAlertContent);
                                                    setMenuDisable("btnApprove", false);
                                                    return;
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
                                        // 1 : 결재, 2 : 확인, 4 : 전결, 16 : 대결, 18 : 기안, 19 : 검토
                                        if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
                                            var rtnval;
    //					                    rtnval = getDocNumber(drafterDeptid, "");
                                            rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);

                                            if (!rtnval) {
                                                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
                                                OpenAlertUI(pAlertContent);
                                                setMenuDisable("btnApprove", false);
                                                return;
                                            }
                                        }
                                    }
                                }
				            }
			            }
				   
				   if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    var rtnVal = ExcuteInfo("DOCNUM_AFTER", "")
		                    if (!rtnVal) {
		                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
		                }
		            }
						
				   if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		
		                    var rtnVal = ExcuteInfo("LAST_SIGN_BEFORE", "")
		                    if (!rtnVal) {
		                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
		                }
		            } else {
		                var rtnVal = ExcuteInfo("MIDDLE_SIGN_BEFORE", "")
		                if (!rtnVal) {
		                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent);
					        setMenuDisable("btnApprove", false);
					        return;
					    }
		            }
				   
                    AprrovMappingSign(ret);
				   
		            var rtnVal = true;
		            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    SetAutoPropFinal();
		                    var rtnVal = ExcuteInfo("LAST_SIGN_AFTER", "")
		                    if (!rtnVal) {
		                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
		                }
		            } else {
		                var rtnVal = ExcuteInfo("MIDDLE_SIGN_AFTER", "")
		                if (!rtnVal) {
		                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent);
					        setMenuDisable("btnApprove", false);
					        return;
					    }
		            }
		            
		           // GetHTML(Before_SaveApproveInfo);		// 사인 추가된 문서 데이터 저장
			   }
			   // Approve_complete 끝
			   
			   // Approve_complete -> Before_SaveApproveInfo 시작
			   function Before_SaveApproveInfo(html) {
                   SaveHtml = html;
				   
				   var rtnVal = SaveApproveInfo("1");
				   
				   if(isLastSaveDoc){
				        var pAlertContent = "<spring:message code='ezApprovalG.t1376'/>";
                        OpenAlertUI(pAlertContent, Draft_Complete);
				   }
		            
		            if (rtnVal != "TRUE") {
		                if (pDraftFlag != "SUSIN") {
                            if (approvalFlag == "S") {
                                if ((LastKyulSN == pAprMemberSN && lastHabYuiSN != 0 && pAprLineType != strAprType8 && pAprLineType != strAprType7  && habYuiAprStateFlag) || pAprLineType == strAprType4 || totalMemSN > 0) {
                                    if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType8) {
                                        rollbackDocNumber(drafterDeptid, "doc", pDocID);
                                    }
                                }
                            } else {
                                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
                                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
                                        rollbackDocNumber(drafterDeptid, "doc", pDocID);
                                    }
                                }
                            }
                            
                            // 일괄 B타입 결재 실패 시 문서 복구
                            if(isLastSaveDoc && beforeWholeHwp_B){
                                changeAn(1, true);
                                message.SetTextFile(beforeWholeHwp_B, "HWP", "", function(){
                                    message.GetTextFile("HWP", "", function(data){
                                        SaveHtml = data;
                                        SaveFile();
                                        alert("결재에 실패하였습니다.");
                                    });
                                });
                            }
		                } else {
                            if (useReceiveDocNo == 'NO') {
                                if (approvalFlag == "G") {
                                    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
                                        if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
                                            rollbackDocNumber(drafterDeptid, "receipt", pDocID);
                                        }
                                    }
                                }
                            }
                        }
		
		                UndoSignInfo(newSignInfo);
		                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                        var rtnVal = ExcuteInfo("END_FAIL", "")
		                        if (!rtnVal) {
		                            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }
		                    }
		                } else {
		                    var rtnVal = ExcuteInfo("MIDDLE_END_FAIL", "")
		                    if (!rtnVal) {
		                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
		                }
		                var pAlertContent = "[<spring:message code='ezApprovalG.t34'/>";
				        OpenAlertUI(pAlertContent);
				        setMenuDisable("btnApprove", false);
                        GetHTML(before_SaveFile);
				        return;
				    } else {
				    	UpdateLineHistory();
				    
				        if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2)|| pAprLineType == strAprType4 || pAprLineType == strAprType16) {
				            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		
				                var rtnVal = ExcuteInfo("LAST_END_AFTER", "")
				                if (!rtnVal) {
				                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
				                }
				                getOpinionInfo(pDocID, "END");
				                SendMailToDrafter();
				                SendMailToReceiveDept_Approv();
		                    }
		                }
		                else {
		                    var rtnVal = ExcuteInfo("MIDDLE_END_AFTER", "")
		                    if (!rtnVal) {
		                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
		                    }
				            sendAlertMail("APR", pAprMemberSN, "APPROV");
		                }
		
		                if ((pDraftFlag == "SUSIN" || pAprLineType == strAprType7) && KuyjeType == "001") {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1387'/>";
					        OpenAlertUI(pAlertContent);
					        btnClose_onclick();
					        Btnflag = "false";
					        ChangeBtnState();
					    }
					    else {
					        if (pAprLineType == strAprType7) {
					            process_AfterApprove("4");
					        }
					        else {
					            process_AfterApprove("1");
					        }
					    }
		            }
		            
		            setMenuDisable("btnApprove", false);
			   }
			   // Before_SaveApproveInfo 끝
			   
			   
			   // 반송 btnReject_onclick 시작
			    function btnReject_onclick() {
			        var pInformationContent = "<spring:message code='ezApprovalG.t36'/>";
			        OpenInformationUI(pInformationContent, btnReject_onclick_Complete);
			    }
			        
			    function btnReject_onclick_Complete(Ans) {
			    	DivPopUpHidden();
			        if (!Ans) return;
			        
			        if(anCnt > 1)
			            changeAn(1, true);
			        
			        if (CheckUsePassword()) {
				        chk_Passwd(pingUserID, btnReject_chkpassword_Complete);
			        } else {
			        	openOpinionUI_New("BanSong", btnReject_option_Complete);
			        }
			    }
			        
			    function btnReject_chkpassword_Complete(chkpass) {
			    	DivPopUpHidden();
			    	if (chkpass == "FALSE") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			        else if (chkpass == "cancel") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			        openOpinionUI_New("BanSong", btnReject_option_Complete);
			    }

				var returnUserSN = "";
			    function btnReject_option_Complete(ret) {
					DivPopUpHidden();
					if(anCnt > 1){
					    changeAn(1, true);
					}
					// 2024-06-24 양지혜 - 전자결재 > 지정반송
					if (ret != "cancel" && returnUserSN != "" && returnUserSN != "1") {
						returnByDesignation(ret, returnUserSN);
						return;
					}

			        if (ret != "cancel" && ret != undefined ) {
			            /* 지정반송은 백단 결재 로직 사용 X */
                        /* 반송 백단로직 start */
                        backFailFlag = false;
                        var res = SaveApproveInfoInBackEnd("2");
                        if(res){
                            var resCode = res.status;    // ok / error
                            if(resCode == "ok"){
                                var resData = res.data;  // SUCCESS / FAIL
                                if(typeof resData != "undefined" && resData.toUpperCase() == "SUCCESS"){
                                    // 결재 완료
                                    process_AfterApprove("2");
                                }else if(typeof resData != "undefined" && resData.toUpperCase() == "FAIL"){
                                    // 결재 실패
                                    backFailFlag = true;
                                }
                            }else{ // 호출시 데이터 문제(type) or 백단 결재 로직 오류
                                backFailFlag = true;
                            }
                        }
                        if(!backFailFlag){
                            return;
                        }
                        /* 반송 백단 로직 실패 시 프론트 로직 시작 */
			        
			            UpdateLineHistory();
			
			            var rtnVal = ExcuteInfo("BANSONG_BEFORE", "")
			            if (!rtnVal) {
			                var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent, OpenAlertUI_Complete);
					        return;
					    }
			            
			            var objXML = createXmlDom();
				        objXML = loadXMLString(ret);
				        
				        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
				        if (NodeList.length != 0) {
				            pHasOpinionYN = "Y";
				        } else {
				            pHasOpinionYN = "N";
				            ret = "cancel";
				        }
				        makeOpinionList(objXML);
			
			            GetHTML(btnReject_option_Complete2);
			        } else if (ret == "cancel" || ret == undefined) {
			        	var pAlertContent = "<spring:message code='ezApprovalG.t38'/>";
						if (returnChk == "Y") {
							pAlertContent = "<spring:message code='ezApprovalG.yjh05'/>";
							returnChk = "N";
						}
			        	OpenAlertUI(pAlertContent, null);
				        return;
			        }
			    }
			    
			    function btnReject_option_Complete2(html) {
			    	SaveHtml = html;
			    
			    	var RtnVal = SaveApproveInfo("2");
		            if (RtnVal != "TRUE") {
		                var rtnVal = ExcuteInfo("BANSONG_FAIL", "")
		                if (!rtnVal) {
		                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent);
					        return;
					    }
		
		                var pAlertContent = "<spring:message code='ezApprovalG.t1388'/>";
				        OpenAlertUI(pAlertContent);
				        return;
				    }
				    else {
				        var rtnVal = ExcuteInfo("BANSONG_AFTER", "")
				        if (!rtnVal) {
				            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent);
					        return;
					    }
		                process_AfterApprove("2");
		            }
			    }
			    // 반송관련 로직 끝
	
			    // 보류 btnStay_onclick 시작
			    function btnStay_onclick() {
			        var pInformationContent = "<spring:message code='ezApprovalG.t39'/>";
			        var Ans = OpenInformationUI(pInformationContent, btnStay_onclick_Complete);
			    }
			        
			    function btnStay_onclick_Complete(Ans) {
			    	DivPopUpHidden();
			        if (!Ans) return;
			        
			    	if (CheckUsePassword()) {
				        chk_Passwd(pingUserID, btnStay_chkpassword_Complete);
			        } else {
			        	openOpinionUI_New("BoRyu", btnStay_option_Complete);
			        }
			    }
			    
			    function btnStay_chkpassword_Complete(chkpass) {
			    	DivPopUpHidden();
			    	
			    	if (chkpass == "False") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
				        OpenAlertUI(pAlertContent);
				        return;
			        } else if (chkpass == "cancel" || chkpass == undefined) {
				        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
				        OpenAlertUI(pAlertContent);
				        return;
				    }
			    	openOpinionUI_New("BoRyu", btnStay_option_Complete)
			    }
			    
			    function btnStay_option_Complete(ret) {
			    	DivPopUpHidden();
			    	
			    	if (ret != "cancel" && ret != undefined) {
			    		var objXML = createXmlDom();
				        objXML = loadXMLString(ret);
				        
				        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
				        if (NodeList.length != 0) {
				            pHasOpinionYN = "Y";
				        } else {
				            pHasOpinionYN = "N";
				        }
				        makeOpinionList(objXML);
			    		
			    	    /* 보류 백단로직 start */
                        backFailFlag = false;
                        var res = SaveApproveInfoInBackEnd("3");
                        if(res){
                            var resCode = res.status;    // ok / error
                            if(resCode == "ok"){
                                var resData = res.data;  // SUCCESS / FAIL
                                if(typeof resData != "undefined" && resData.toUpperCase() == "SUCCESS"){
                                    // 결재 완료
                                    process_AfterApprove("3");
                                }else if(typeof resData != "undefined" && resData.toUpperCase() == "FAIL"){
                                    // 결재 실패
                                    backFailFlag = true;
                                }
                            }else{ // 호출시 데이터 문제(type) or 백단 결재 로직 오류
                                backFailFlag = true;
                            }
                        }
                        if(!backFailFlag){
                            return;
                        }
                        /* 보류 백단 로직 실패 시 프론트 로직 시작 */
			    	    
			            UpdateLineHistory();
			            GetHTML(btnStay_option_Complete2);
			        } else if (ret == "cancel" || ret == undefined) {
			        	var pAlertContent = "<spring:message code='ezApprovalG.t392'/>";
			        	OpenAlertUI(pAlertContent);
			        }
			    }
			    
			    function btnStay_option_Complete2(html) {
			    	SaveHtml = html;
			    	
			    	var RtnVal = SaveApproveInfo("3");
					
		            if (RtnVal != "TRUE") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1389'/>";
				        OpenAlertUI(pAlertContent);
				        return;
				    }
				    else {
				        process_AfterApprove("3");
				    }
			    }
			 	// 보류관련 로직 끝
	
			 	// 전결관련 로직 시작
			    function btnJunKyul_onclick() {
			    	//if ("${approvalPWD}" != "N") {
			    	if (CheckUsePassword()) {
				        chk_Passwd(pingUserID, btnJunKyul_onclick_complete);
			    	} else {			    		
			    		btnJunKyul_onclick_complete2();
			    	}
			    }
			    	
			    function btnJunKyul_onclick_complete(checkpass) {
			    	DivPopUpHidden();
			    
			    	if (checkpass == "False") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
				        OpenAlertUI(pAlertContent);
				        return;
			        } else if (checkpass == "cancel" || checkpass == undefined) {
				        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			    	
			    	btnJunKyul_onclick_complete2();
			    }
			    	
			    function btnJunKyul_onclick_complete2() {
			    	isjunkyul = true;
					
			        var rtnVal = upDateAprLine();
			        if (rtnVal == "TRUE") {
			            getCurApproverAprLine();
			            btnApprove_onclick();
			        }
			        else {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1390'/>";
				        OpenAlertUI(pAlertContent);
				    }
			    }
	
			    // btnEdit_onclick 편집모드 시작
			    function btnEdit_onclick() {
                    if (approvalFlag == "S") {
                        if(checkAprState()){
                            alert("<spring:message code='ezApprovalG.bhs23'/>");
                            window.returnValue = "CLOSE";
                            btnClose_onclick();
                            return;
                        }
                    }

                    if(!(draftAllTypeB == "Y" && anCnt > 1)){
                        if (getSnapshotCode() !== snapshotCode) {
                            alert("<spring:message code='ezApprovalG.edit.pgb01'/>");
                            if (allFlag == "1") {
                                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
                            } else {
                                window.returnValue = "CLOSE";
                            }
                            return;
                        }
                    }
					
			        if (modeflag) {
			            modeflag = false;
			            chkBtnConfirm("1");
			            chkBtn(false);
			
			            //beforeHwp = HwpCtrl.GetCloneData("", "HWP");
			            message.EditMode(1);
			
			            setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t42'/>");
			            if(anCnt > 1){
			                an.disabled = true;
                            message.HwpCtrl.AddEventListener(2, function(){
                            });
                            for(var i = 0; i < anCnt; i++){
                                if(an.selectedIndex == i)
                                    continue;
                                cellProtect("doctitle{{" + i + "}}", true);
                                cellProtect("body{{" + i + "}}", true);
                            }
                            message.MoveToFieldEx("body{{" + an.selectedIndex + "}}");
                            if($("#before").length == 0){
                                $("body").append("<iframe name=\"beforeFrame\" id=\"before\" style=\"width:0px; height:0px; border:0px\" src=\"/ezApprovalG/WHWPEditor.do?type=before\"></iframe>");
                                return;
                            }
                            beforeHwpBodyAll();
                            var tmp = message.document.getElementById("hwpctrl_frame");
                            if (tmp) {
                                tmp.contentDocument.getElementById("ImeWrapper_Elm").focus();
                            }
			            }else
			                GetHTML(beforeHWPBody);
			        } else {
                        var index = an.selectedIndex == -1 ? 0 : an.selectedIndex;

						if (message.FieldExist("doctitle{{" + index + "}}")) {
							pDocTitle = trim(message.GetFieldText("doctitle{{" + index + "}}"));
						} else {
							pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
						}

						if (pDocTitle == "") {
							var pAlertContent = "<spring:message code='ezApprovalG.t1491'/>";
							OpenAlertUI(pAlertContent);
							return;
						}else if(anCnt > 1){
						    beforeFrame.PutFieldText("doctitle{{" + index + "}}", pDocTitle);
						    pDocTitleAry[index + 1] = pDocTitle;
						}
						
			            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
						
						var Ans = "";
						if(editVersionYN && editVersionYN == "Y"){
							Ans = OpenInformationUI(pInformationContent, btnEdit_onclick_Complete, "Y");
						}else{
							Ans = OpenInformationUI(pInformationContent, btnEdit_onclick_Complete);
						}
			        }
			    }
			    
			    function beforeHwpBodyAll(){
			        message.GetTextFile("HWP", "", function(data){
			            // 편집 취소 시 복구할 body 
			            beforeWholeHwp_B = data;
			            
			            // beforeFrame에 편집할 안의 수정 전 버전 세팅(이력관리용)
                        beforeFrame.SetTextFile(data, "HWP", "", function(){
                            for(var i = 0; i < anCnt - 1; i++){
                                deleteAn_B(beforeFrame.HwpCtrl, i < an.selectedIndex ? 0 : 1);
                            }
                            beforeFrame.GetTextFile("HWP", "", function(data){
                                beforeHwp = data;
                            });
                        });
			        });
			    }
			    function beforeHWPBody(hwpBody) {
		            beforeHwp = hwpBody;
		        }
			    
			    function btnEdit_onclick_Complete(Ans, PeditMode) {
                    if(!(draftAllTypeB == "Y" && anCnt > 1)){
                        if (getSnapshotCode() !== snapshotCode) {
                            alert("<spring:message code='ezApprovalG.edit.pgb01'/>");
                            if (allFlag == "1") {
                                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
                            } else {
                                window.returnValue = "CLOSE";
                            }
                            return;
                        }
                    }
					
			    	DivPopUpHidden();
			    
			        for(var i = 0; i < anCnt; i++){
                        cellProtect("doctitle{{" + i + "}}", false);
                        cellProtect("body{{" + i + "}}", false);
                    }
			    	message.EditMode(3);
			        setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t44'/>");
		
				    if (Ans) {
						FirstHtml = beforeHwp;

						if(editVersionYN && editVersionYN == "Y"){
							editMode = PeditMode;
							$.ajax({
								type : "POST",
								dataType: "text",
								async : false,
								url : "/ezApprovalG/getEditVersion.do",
								data : {
									docID : pDocID,
									editMode : editMode
								},
								success: function(result){
									editVersion = result;
								}
							});
						}
						
                        if(anCnt > 1){
                            an.disabled = false;
                            var index = an.selectedIndex;
                            showLoadingProgress();
                            
                            beforeFrame.PutFieldText("doctitle", message.GetFieldText("doctitle{{" + index + "}}"));
                            
                            message.GetCloneData("body{{" + index + "}}", "HWP", function(data){
                                beforeFrame.SetCloneDataCallback(data, "body", "HWP", function(){
                                    beforeFrame.GetTextFile("HWP", "", function(data){
                                        var tempDocID = pDocID;
                                        pDocID = pDocIDAry[index+1];
                                        var beforeDocURL = UpdateDocHistory(beforeHwp, "Y", ""); // 수정전 문서 이력저장
                                        UpdateDocHistory(data, "N", beforeDocURL); // 수정후 문서 이력저장
                                        var tmp = {
                                                docID : pDocID,
                                                html  : data,
                                                draftAllB : lidx == 1 ? "OA" : ""
                                            }
                                        
                                        $.ajax({
                                            type : "POST",
                                            dataType : "text",
                                            url : "/ezApprovalG/saveFileHWP.do",
                                            contentType : "application/json",
                                            data : JSON.stringify(tmp),
                                            success: function(text){
                                            }
                                        });
                                        pDocID = tempDocID;
                                    });
                                });
                            });
                            
                            message.GetTextFile("HWP", "", function(data){
                                SaveFileForApprovAllTypeB(data);
                            });
                            
                            pos = message.HwpCtrl.GetPos();
                            if(an.selectedIndex < an.options.length - 1)
                                scrollSetBefore(an.selectedIndex + 1);
                            message.HwpCtrl.AddEventListener(2, function(){
                                for(var i = scrollPos.length - 1; i >= 0; i--){
                                    if(message.HwpCtrl.ScrollPosInfo.Item("VertPos") >= scrollPos[i]){
                                        if(currentTabIdx != i + 1){
                                            changeAn(i + 1, true);
                                        }
                                        break;
                                    }
                                }
                            });
                            
                            hideLoadingProgress();
                        }else{
                            // 수정 후 바로 문서 save
                            GetHTML(before_SaveFile2);// 수정후 문서 이력 및 파일 저장 스택 마지막임.
                            beforeDocURL = UpdateDocHistory(FirstHtml, "Y", ""); // 수정전 문서 이력저장
    // 						UpdateDocHistory(SaveHtml, "N", beforeDocURL);
                            message.EditMode(0);
                        }
				    	modeflag = true;
				    	chkBtnConfirm("2");
				    	message.EditMode(0);
				    	if(!(draftAllTypeB == "Y" && anCnt > 1)){
						    snapshotCode = getSnapshotCode(); 
				    	}
				    } else {
				        if(anCnt > 1){
		                    SetHTML(beforeWholeHwp_B, btnEdit_Cancel_Complete)
				        }else{
		                    SetHTML(beforeHwp, btnEdit_Cancel_Complete)
				        }
		            } 
			    }
			    
			    function btnEdit_Cancel_Complete(result) {
		            message.EditMode(0);
		            modeflag = true;
		            chkBtnConfirm("2");
		            
		            if(anCnt > 1){
		                an.disabled = false;
		            }
		        }
			    // btnEdit_onclick 편집모드 끝
	
			    function btnModAprLine_onclick() {
			        var ret = openAprLineUI();
			        TempsaveAprlineinfo = ret[0];
			
			        if (ret[0] != "cancel" && ret[0] != "EXIST") {
			            if (approvalFlag == "S") {
                            SReAprLineSingMapping(ret);
                        } else {
                            ReAprLineSingMapping(ret);
                        }
			            SaveFile();
			            getCurApproverAprLine();
			        }
			    }
	
			    function btnModAprDept_onclick() {
			        try {
			            var ret = openReceivUI();
			            if (ret == "NONE") {
			                if (message.FieldExist("hrecipients"))
			                	message.PutFieldText("hrecipients", "");
			
			                if (message.FieldExist("recipient"))
			                	message.PutFieldText("recipient", "");
			
			                if (message.FieldExist("recipients"))
			                	message.PutFieldText("recipients", "");
			            }
			            else if (ret != "cancel") {
			                setRecevInfo(ret);
			            }
			        }
			        catch (e) {
			            alert("btnModAprDept_onclick : " + e.description);
			        }
			    }
	
			    function btnOpinion_onclick() {
			        //openOpinionUI("");
			    	openOpinionUI_New("");
			    }
	
			    function btnFileAttach_onclick() {
			        var ret = openFileAttachUI();
			    }
			
			    function btnAprDocAttach_onclick() {
			        var ret = openAaprDocAttachUI();
			    }
	
			    function btnPrint_onclick() {
			    	message.PrintDocument();
			    }
			
			    function btnClose_onclick() {
			        window.close();
			    }
	
			    function window_onbeforeunload() {
			        try {
			            /* if (pAprLineType == "<spring:message code='ezApprovalG.t19'/>")
				            SaveApproveInfo("1"); */	// 분기 타는 위치 확인이 필요함
				    } catch (e) { }
			
                    if (isPreview != "Y") {
                        try {
                            window.opener.openergetDocInfo();
                        } catch (e) {
                            window.parent.openergetDocInfo();
                        }    
                    }
			
			        // try {
			        //     window.opener.Refresh_Window();
			        // } catch (e) { }
			        
			        // try {
			        //     window.opener.getApprGraph("appr");
			        // } catch (e) { }
			    }
	
			    function btnSave_onclick() {
			    	var hwpDoctitle = message.GetFieldText("doctitle").replace(/\r\n/g, " ");
		        	hwpDoctitle += ".hwp";
		            message.SaveFile(hwpDoctitle, "HWP", "");
			    }
			
			    function btnMail_onclick() {
                    if(anCnt > 1)
                        changeAn(1, true);
			    	// window.open("/ezEmail/mailWrite.do?docHref=" + pDocHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
					showPopup("/ezEmail/mailWrite.do?docHref=" + pDocHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", 1200, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
			    }
			    
			    var tempSecurity = "";
			    var tempKeep = "";
			    var tempUrgent = "N";
			    var tempPublic = "Y";
			    var tempKeyword = "";
			    var tempItemCode = "";
			    var tempItemName = "";
			    var tempdocnumcode = "<spring:message code='ezApprovalG.t45'/>";
			    var tempSecurityDate = "";
			    var tempItemName2 = "";
	
			    function btnDocInfo_onclick() {
			        openDocExinfo();
			    }
	
			    function btnSetTaskCode_onclick() {
			        try {
			            var para = new Array();
			            para[0] = cabinetID;
			            var url = "/myoffice/ezApprovalG/ezCabinet/SelectCabinet.aspx?initFlag=1";
			            var feature = "dialogWidth:850px;dialogHeight:455px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
			
			            if (url != "")
			                var rtn = window.showModalDialog(url, para, feature);
			
			
			            if (rtn[0] == "TRUE") {
			                var g_SelCabXml = rtn[1];
			                var xmlCab = createXmlDom();
			                xmlCab.loadXML(g_SelCabXml);
			                cabinetID = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/CABINETID"));
			                TaskCode = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/TASKCODE"));
			            }
			        } catch (e) {
			            alert("btnSetTaskCode_onclick : " + e.description);
			        }
			    }
	
			    var inssepattach_cross_dialogArguments = new Array();
			    function btnAddSepAttach_onclick() {
			        if (cabinetID == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t48'/>";
				        OpenAlertUI(pAlertContent);
				        return;
				    }
			
			        var g_SepAttachLVXml = "";
			        g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
			        if (!g_SepAttachLVXml)
			            g_SepAttachLVXml = "";
			
			        var para = new Array();
			        para[0] = g_SepAttachLVXml;
			        para[1] = cabinetID;
					para[3] = ext;
					
					inssepattach_cross_dialogArguments[0] = para;
			        inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

			        DivPopUpShow(930, 630, "/ezApprovalG/insSepAttach.do");
			    }
			    
			    function btnAddSepAttach_onclick_Complete(rtn) {
			        DivPopUpHidden();
			        if (rtn[0] == "TRUE") {
			            g_SepAttachLVXml = rtn[1];
			            SetDocumentElement("sepattachlvxml", g_SepAttachLVXml)
			        }
			    }
			    
			  	//2019-01-18 천성준 - 새로운 HWP 분리첨부 XML파싱 소스 생성
			    function GetSepAttParamXml(g_SepAttachLVXml) {
			    	try {
			    		var sepAtt, Data;
			    		var rtnXml = createXmlDom();
			    		var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
			    		
			    		if (g_SepAttachLVXml != "") {
			    			var sepLVXml = createXmlDom();
			    				sepLVXml = loadXMLString(g_SepAttachLVXml);
			    				
			    			var pRows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
			    			if (pRows) {
			    				for (var i = 0; i < pRows.length; i++) {
			    					sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID",	getNodeText(pRows.item(i).childNodes(0).selectSingleNode("DATA1")));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", 	getNodeText(pRows.item(i).childNodes(1).selectSingleNode("VALUE")));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE",	getNodeText(pRows.item(i).childNodes(4).selectSingleNode("VALUE")));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", 	getNodeText(pRows.item(i).childNodes(0).selectSingleNode("DATA2")));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY",	getNodeText(pRows.item(i).childNodes(6).selectSingleNode("VALUE")));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE",	getNodeText(pRows.item(i).childNodes(0).selectSingleNode("DATA3")));
			    				}
			    			} else {
			    				var oRows = sepLVXml.getElementsByTagName("ROW");
			    				for (var i = 0; i < oRows.length; i++) {
			    					sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA1"));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[1], "VALUE"));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(GetChildNodes(oRows[i])[4], "VALUE"));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA2"));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[6], "VALUE"));
			    					Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", 	SelectSingleNodeValue(GetChildNodes(oRows[i])[0], "DATA3"));
			    				}
			    			}
			    		}
			    		
			    		return getXmlString(rtnXml);
			    	} catch (e) {
			    		alert("ezapprovui_hwp.GetSepAttParamXml() : " + e.description);
			    	}
			    }
	
			    function btnhistory_onclick() {
			        getHistory();
			    }
			    
			    // var ezapprovalinfo_dialogArguments = new Array();
			    function btnApprovalInfo() {
   			        CheckDocCellInfo();
   			        var onlydocinfiview = false;
   			        var parameter = new Array();
   			        parameter[0] = pDocID;
   			        parameter[1] = pFormID;
   			        parameter[2] = SignCount;
   			        parameter[3] = SignInfo;
   			        parameter[4] = hapyuiCount;
   			        parameter[5] = pDraftFlag;
   			        parameter[6] = pSuSinFlag;
   			        parameter[7] = pChamJoFlag;
   			        parameter[8] = gongramCount;
   			        parameter[9] = true;
   			        parameter[10] = pDocType;
   			        parameter[11] = gamsaCount;
   			        parameter[12] = "DRAFT";
   			        parameter[28] = onlydocinfiview;
   			        parameter[29] = TaskCode;
   			        parameter[30] = cabinetID;
   			        parameter[31] = tempSecurity;
   			        parameter[32] = tempUrgent;
   			        parameter[33] = pSummery;
   			        parameter[34] = pSpecialRecordCode;
   			        parameter[35] = pPublicityCode;
   			        parameter[36] = pLimitRange;
   			        parameter[37] = pPageNum;
   			        parameter[38] = tempSecurityDate;
   			        parameter[39] = SummaryFlag;
   			        parameter[40] = "";
   			        parameter[45] = pPublicityYN;
   			        parameter[46] = nonElecRec;
		            parameter[52] = OrgAprUserDeptID;
   				    
   				    if (nonElecRec == "Y") {
   				    	if (pGubun != "1") {
   				        	parameter[47] = cabinetID;
   			        	} else {
   				        	parameter[47] = "nonElecRecTempCabinet";
   			        	}
   				        parameter[48] = nonElecRecInfoXml; // 기록물 기본등록 정보
   				        parameter[49] = nonSepAttachLVXml; // 분첨
   				        parameter[50] = g_szSCListXml;
   				        parameter[51] = sepAttachCheckYN; // 분첨
   			        }

   			        if (approvalFlag == "S") {
                        parameter[13] = pOrgAprUserID;
                        parameter[14] = aprlineinfoTMP;
                        parameter[17] = AprLineArea;
                        parameter[18] = HapyuiArea;
                        parameter[19] = "ING";
                        parameter[20] = tempKeep;
                        parameter[23] = tempPublic;
                        parameter[25] = tempItemCode;
                        parameter[29] = TaskCode;
                        parameter[33] = pSummery;
                        parameter[41] = tempItemName;
                        parameter[42] = tempItemName2;
                    }

   			        if (useOpenGov == "YES") {
                        parameter[52] = basis;
                        parameter[53] = reason;
                        parameter[54] = listOpenFlag;
                        parameter[55] = fileOpenFlagList;
   					}

   			        if (tempItemCode != "")
   			            tempdocnumcode = tempItemCode;
   			        
   			     	parameter[61] = tempKeyword;
                       
                    ezCommon_cross_dialogArguments[0] = parameter;
					showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp" + "&formID=" + pFormID + (anCnt > 1 ? "&draftAllFlag=Y" : ""), 1210, 750, "ezApprovalInfo", GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
				}

			    function btnApprovalInfo_Complete(ret) {
					hidePopup();
   			        if (ret != undefined && ret[0] == "OK") {
   			            try {
   			                //결재선 저장
                            if (approvalFlag == "S") {
                                if (pGubun != "14" && pGubun != "10") {
                                    if (ret[1] != false) {
                                        $.ajax({
                                            type : "POST",
                                            dataType : "json",
                                            async : false,
                                            url : "/ezApprovalG/aprLineSave.do",
                                            data : {
                                                    ret    : ret[1],
                                                    orgCompanyID : orgCompanyID
                                                    },
                                            success : function(result){

                                            }
                                        });

                                        btnSendDraftEnable = "true";
                                        SReAprLineSingMapping(ret);
                                        IsSkipDrafter = "FALSE";
                                        //SaveFile();
                                        getCurApproverAprLine("");
                                    }
                                    savexmlhttp = null;
                                    savexmlhttp = createXMLHttpRequest();
                                }
                            } else {
                                if (pGubun != "5" && pGubun != "7" && pGubun != "10") {
                                    if (ret[1] != false) {
                                        var url = draftAllTypeB == "Y" ? "/ezApprovalG/aprLineSaveAll.do" : "/ezApprovalG/aprLineSave.do";
                                        $.ajax({
                                            type : "POST",
                                            dataType : "json",
                                            async : false,
                                            url : url,
                                            data : {
                                                    ret    : ret[1],
                                                    docIDAry : pDocIDAry
                                                    },
                                            success : function(result){

                                            }
                                        });

                                        IsSkipDrafter = "FALSE";
                                        btnSendDraftEnable = "true";
                                        ReAprLineSingMapping(ret);
                                        //SaveFile();
                                        getCurApproverAprLine();
                                    }
                                    savexmlhttp = null;
                                    savexmlhttp = createXMLHttpRequest();
                                }
                            }
   			
   			                if (pGubun != "6" && pGubun != "7" && pGubun != "9" && pGubun != "11" && pGubun != "12" && pGubun != "13") {
   			                	$.ajax({
   		                    		type : "POST",
   		                    		dataType : "text",
   		                    		async : false,
   		                    		url : "/ezApprovalG/aprDeptSave.do",
   		                    		data : {
   		                    				aprDeptInfo : ret[2]
   		                    				},
   		                    		success : function(result){
   		                    			if (result == 'TRUE') {
   		                    				
   		                    			} else {
   		                    				alert(strLang163);
   		                    			}
   		                    		}
   		                    	});
   			                	
   			                    btnReceivLineEnable = false;
   			                    var changeIdx = "";
   			                    if(anCnt > 1){
   			                        var tmpDoc = loadXMLString(ret[2]).getElementsByName("DocID")[0].textContent;
   			                        changeIdx = pDocIDAry.indexOf(tmpDoc);
   			                    }
   			                    setRecevInfo(ret[3], changeIdx);
   			                }
   			
   			                if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
   			                    var g_SelCabXml = ret[4];
   			                    var xmlCab = createXmlDom();
   			                    xmlCab = loadXMLString(g_SelCabXml);
   			                    cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
   			                    TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
   			                }

							tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
   			                tempSecurity = ret[7];                // 보안등급 관련
   			                tempUrgent = ret[8];                  // 긴급 결재 여부
   			                pSummery = ret[9];                    // 요약 내용 관련
   			                tempSecurityDate = ret[14];           // 보안 결재 체크 관련
   			                pPublicityCode = ret[11];             // 대민공개여부 및 공개등급 관련 
   			                pPublicityYN = ret[21];             // 공개여부 및 공개등급 관련

   			                if (approvalFlag == "G") {
                                pSpecialRecordCode = ret[10];
                                pLimitRange = ret[12];
                                pPageNum = ret[13];
                                // 문서 공개 범위 설정 (대민 공개 여부)
                                // setPublicFlag2();
                                setPublicFlag();

                                if (nonElecRec == "Y") {
                                    nonElecRecInfoXml = ret[23];
                                    nonSepAttachLVXml = ret[24];
                                    g_szSCListXml = ret[25];
                                    sepAttachCheckYN = ret[26];
                                    if (ext == "hwp") {
                                        setNonElecRecInfo_whwp(nonElecRecInfoXml);
                                    }
                                }

                                if (useOpenGov == "YES") {
                                       $.ajax({
                                           type : "POST",
                                           dataType : "text",
                                           async : false,
                                           url : "/ezApprovalG/openGovInfoSave.do",
                                           data : {
                                               openGovListFlag : ret[27],
                                               fileOpenFlagList : ret[28],
                                               basis : ret[29],
                                               reason : ret[30],
                                               publicity : ret[11],
                                               docID : pDocID,
                                               limitDate : ret[31]
                                           }
                                       });

                                       listOpenFlag = ret[27];
                                       fileOpenFlagList = ret[28];
                                       basis = ret[29];
                                       reason = ret[30];
                                       limitDate = ret[31];
                                }
                            } else {
                                //회람
                                if (ret[22] == "noItem") {
                                    // ret[22] 값이 "noItem"일 경우 기존 데이터가 있을 수 있으므로 삭제함
                                    delAprLineInfoCC();
                                } else if (ret[22] == "sameItem") {
                                    // ret[22] 값이 "sameItem"일 경우 동작 없음
                                } else {
                                    //회람 저장
                                    SaveAprLineInfoCC(ret[22]);
                                }

                                tempKeep = ret[16];
                                tempItemName = ret[17];
                                tempItemName2 = ret[18];
                                pPageNum = "1";
                                pLimitRange = "1";
                                pSpecialRecordCode = "1";
                                tempPublic = ret[11];
                                SetDocOption(ret[20], ret[19]);
                            }

   							//2020-05-08 : 결재정보확인 시 문서정보 저장 후 문서 반영
   							setApprDocInfo();	
							// 2022-02-04 박기범 : 결재정보 > 확인 후에 한글문서는 저장되지 않던 문제 수정
							GetHTML(before_SaveFile);

							SummaryFlag = true;
   			                savexmlhttp = null;

							// 2023-05-23 임정은 - 공람 추가
							if (ret[22] == "noItem") {
								delAprLineInfoCC();
							} else if (ret[22] == "sameItem") {
							} else {
								SaveAprLineInfoCC(ret[22]);
							}
   			            }
   			            catch (e) {
   			                alert("저장시 오류 발생");
   			            }
   			        }
			    }



			    
			    function btnHelper_onclick() {
			        var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT", "");
			        if (!rtnVal) {
			        }
			    }
			    
		    	function getByteLength(s){
		    		var bytes;
		    		var i;
		    		var c;
		    		
		    	    for(bytes=i=0; c=s.charCodeAt(i++); bytes += c >> 11? 3 : c >> 7 ? 2 : 1);
		    	    return bytes;
		    	}
		    	
		    	/* 2019-01-02 천성준 #14647
			            결재암호 사용유무 조회 (Y / N)
			    */
		    	function CheckUsePassword() {
			    	var result = "";
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/getApprovalPWD.do",
			    		success: function(text) {
			    			result = text;
			    		}        			
			    	});
			    	
			    	if (result != "N") {
			    		return true;
			    	} else {
			    		return false;
			    	}
			    }
		    	
		    	// 웹 한글 기안기용
		    	function Editor_Complete() {
		    		showLoadingProgress();

		    		if (pDocHref != "") {
	                    var URL;
	                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
	                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
		        	} else {
	                    DraftFlag = "DRAFT";
	                    pDraftFlag = "DRAFT";
	                    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(sihangURL.replace(".mht", ".hwp"));
			        	message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	                }
		    	}
		    	
		    	// 통합 PC 저장 시작
		    	// var totalsavefileinfo_dialogArguments = new Array();
			    function TotalSave_onclick() {
			        if(anCnt > 1)
                        changeAn(1, true);
			    
			        ezCommon_cross_dialogArguments[0] = "";
			        ezCommon_cross_dialogArguments[1] = TotalSave_onclick_Complete;
			
			        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=" + getDocMode() + "&orgCompanyID=" + orgCompanyID);
			    }
			    
			    function TotalSave_onclick_Complete() {
			        DivPopUpHidden();
			    }
			    
			    function getDocMode() {
			    	var rtnVal = "APR";
			    	try {
			    		$.ajax({
			     			type : "POST",
			     			dataType : "text",
			     			async : false,
			     			url : "/ezApprovalG/getLineMode.do",
			     			data : {
			     					docID : pDocID,
			     					orgCompanyID : orgCompanyID
			     					},
			     			success: function(result) {
			     				rtnVal = result;
			     			}
			            });
			    	} catch (e) {
			    		alert("getDocMode() :: " + e.description);
			    	}
			    	
			    	return rtnVal;
			    }
			 // 통합 PC 저장 끝
			 
	    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
	    	function setAttachGuideText() {
	    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                
                if(bigSizeAttachDownloadLimitCount > 0) {
                	attachGuideText += strLangHSBAt06 + " <span style='color:#FF0000 ;'>" + bigSizeAttachDownloadLimitCount + strLangHSBAt09 + "</span> " + strLangHSBAt10;
                }
                
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += "</td>";
/*                 
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt05 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadPeriod + "</span></td>";
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt06 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadDay + strLangHSBAt07 + "</span>" + strLangHSBAt08;
                 */
                 
                 if (bigSizeAttachDownloadLimitCount > 0) {
                	 document.getElementById("apprAttachGuideTR").innerHTML = attachGuideText;
                 }
                 else {
                	 document.getElementById("apprAttachGuideTR").style.display = "none";
                 }
	    	}

			/* 2024-06-24 양지혜 - 전자결재 > 지정반송 */
			var returnChk = "N";
			function btnReturnDesignation_onclick() {
				returnChk = "Y";
				if (checkAprState()) {
					alert("<spring:message code='ezApprovalG.bhs23'/>");
					window.returnValue = "CLOSE";
					btnClose_onclick();
					return;
				}
				var pInformationContent = "<spring:message code='ezApprovalG.yjh04'/>";
				OpenInformationUI(pInformationContent, btnReject_onclick_Complete);
			}

			 function getAprLineList(type) {
                var result = "";
                var pMode = "";
                if (docState == "017") {
                      $.ajax({
                            type : "POST",
                            dataType : "text",
                            async : false,
                            url : "/ezApprovalG/getLineMode.do",
                            data : {
                                    docID : pDocID
                                    },
                            success: function(xml){
                                    pMode = xml;
                            }
                      });
                }

                if (pMode != "END") {
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        url : "/ezApprovalG/aprLineRequest.do",
                        data : {
                                docID    : pDocID,
                                userID 	 : "",
                                formID   : "",
                                orgCompanyID : orgCompanyID,
                                isUsed   : type,
                                mode     : pMode
                                },
                        success: function(xml){
                            result = xml;
                        }
                    });
                } else {
                    return pMode;
                }
                return result;
            }

            function getReceiptList() {
                var result = "";

                $.ajax({
                    type : "POST",
                    dataType : "text",
                    async : false,
                    url : "/ezApprovalG/aprDeptRequest.do",
                    data : {
                        docID : pDocID,
                        orgCompanyID : orgCompanyID
                    },
                    success: function(xml){
                        result = loadXMLString(xml);
                    }
                });

                var rows = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");

                var xmlpara = createXmlDom();
                var objRoot, objRow, objDocinfoNode;
                objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");

                for (var i = 0; i < rows.length; i++) {
                    var dataNodes = GetChildNodes(rows[i]);
                    objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");

                    /* 2022-08-03 홍승비 - 수신처그룹에는 "장"을 붙이지 않으며, 수신자에 "장" 붙이는 컨피그 옵션 미사용 분기 추가 */
                    if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0 || useReceiveInfoName == "0") {
                        createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", SelectSingleNodeValue(dataNodes[1], "VALUE").trim());
                    } else {
                        createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", SelectSingleNodeValue(dataNodes[1], "VALUE").trim() + (SelectSingleNodeValue(dataNodes[2], "VALUE").trim() == "" ? strLang93 : ""));
                    }
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTID", SelectSingleNodeValue(dataNodes[0], "DATA1").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME", SelectSingleNodeValue(dataNodes[0], "DATA2").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EXTRECEPTYN", SelectSingleNodeValue(dataNodes[0], "DATA3").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "PROCESSYN", SelectSingleNodeValue(dataNodes[0], "DATA4").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "CANEDITYN", SelectSingleNodeValue(dataNodes[0], "DATA5").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EMAIL", SelectSingleNodeValue(dataNodes[0], "DATA6").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "JOBTITLE", SelectSingleNodeValue(dataNodes[0], "DATA9").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME1", SelectSingleNodeValue(dataNodes[0], "DATA10").trim());
                    createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME2", SelectSingleNodeValue(dataNodes[0], "DATA11").trim());
                }

                return getXmlString(xmlpara);
            }

            function SetDocOption(pkeeperiodvaltemp) {
                if (message.FieldExist("keepperiod"))
                    message.PutFieldText("keepperiod" , pkeeperiodvaltemp);

                if (message.FieldExist("securitylevel"))
                    message.PutFieldText("securitylevel" , tempSecurityValue);

                if (message.FieldExist("publication")){
                    if (tempPublic == "N")
                        message.PutFieldText("publication" , "비공개");
                    else
                        message.PutFieldText("publication" , "공개");
                }

                if (message.FieldExist("docnumber") && tempItemCode != ""){
                    var tempdocnumber = message.GetFieldText("docnumber");
                    tempdocnumber = tempdocnumber.replace(tempdocnumcode, tempItemCode);
                    message.PutFieldText("docnumber" , tempdocnumber);
                }
            }

            function checkAprState() {
                editedFlag = false;
                var result = "";

                if (approvalFlag == "S") {
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        url : "/ezApprovalG/checkAprState.do",
                        data : {
                            docID : pDocID,
                            docState : docState,
                            userID : OrgAprUserID,
                            aprMemberSN : wAprMemberSN,
                            orgCompanyID : orgCompanyID
                        },
                        success : function(text) {
                            result = text;
                        }
                    });
                }
                return result == "FALSE" ? true : false;
            }

            function cellProtect(field, bool){
                message.MoveToField(field);
                var dact = message.HwpCtrl.CreateAction("TablePropertyDialog");
                var dset = dact.CreateSet();
                dact.GetDefault(dset);
                var dcellset = dset.CreateItemSet("ShapeTableCell", "Cell");
                dcellset.SetItem("Protected", bool ? 1 : 0);
                dact.Execute(dset);
            }

            function getCheckNotFailDoc() {
                var checkNotFailDoc = "";
                
                $.ajax({
                    type : "GET",
                    url : "/ezApprovalG/getCheckNotFailDoc.do",
                    dataType : "text",
                    async : false,
                    data : {
                        pDocID : pDocID
                    },
                    success : function(data) {
                        checkNotFailDoc = data;
                    },
                    error : function(xhr, status, error) {
                        
                    }
                });
                
                return checkNotFailDoc == "TRUE" ? true : false;
            }

	    </script>
	</head>
	<body class="popup" onbeforeunload="return window_onbeforeunload()" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                	<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
	                    <ul id="AllApprove" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                        <li id="btnApprove"><span onclick="return btnApprove_onclick()"><spring:message code='ezApprovalG.t1'/></span></li>
	                        <li id="btnReject"><span onclick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
							<li id="btnReject2" style="display: none"><span onClick="return btnReturnDesignation_onclick()"><spring:message code='ezApprovalG.yjh02'/></span></li>
	                        <li id="btnStay"><span onclick="return btnStay_onclick()"><spring:message code='ezApprovalG.t50'/></span></li>
	                        <span style="display: none">
	                            <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><spring:message code='ezApprovalG.t9994'/></span></li>
	                        </span>
	                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnJunKyul" style="display: none"><span onclick="return btnJunKyul_onclick()"><spring:message code='ezApprovalG.t25'/></span></li>
	                        <span style="display: none">
	                            <li id="btnModAprLine"><span onclick="return btnModAprLine_onclick()"><spring:message code='ezApprovalG.t52'/></span></li>
	                        </span>
	                        <span style="display: none">
	                            <li id="btnModAprDept"><span onclick="return btnModAprDept_onclick()"><spring:message code='ezApprovalG.t53'/></span></li>
	                        </span>
	                        <li id="btnEdit"><span onclick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
	                        <span style="display: none">
	                            <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        </span>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
	                        <li id="btnAddSepAttach"<c:if test="${approvalFlag == 'S'}"> style="display:none"</c:if>><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSave" style="display:none"><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
	                        <li id="btnMail" style="display:none"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
                            <select class="draftAllTypeB" id="an" onchange="changeAn()" <c:if test="${fn:length(group) < 2}">style="display:none"</c:if>>
                            <c:forEach var="item" items="${group}">
                                <option value="<c:out value='${item.docID}'/>"><c:out value='${item.tabSN}'/><spring:message code='ezApprovalG.HSBDa04'/></option>
                            </c:forEach>
                            </select>
	                    </ul>
						<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
				        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
				        </ul>
	                </div>
	                <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	
	            </td>
	        </tr>
	
	        <tr>
	            <!-- <td class="pad1">
	                <div style="height: 100%">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "${hwpToolbar}", "1");</script>
	
	                </div>
	            </td> -->
	            <td style="padding-bottom:10px;height:800px;" id="messageWHWPEditor">
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5; overflow: auto;">

	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style=" width:30%; overflow: auto;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
							</td>
							<td class="pos2" style="width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
							</td>
	                    </tr>
	                </table>
	
					<%-- 대용량첨부 가이드 메세지 영역 --%>
	                <table class="file" style="height: 20px;">
	                    <tr id="apprAttachGuideTR"></tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	    <xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	    <div id="AprMemberSN" style="display: none"></div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	</body>
</html>
