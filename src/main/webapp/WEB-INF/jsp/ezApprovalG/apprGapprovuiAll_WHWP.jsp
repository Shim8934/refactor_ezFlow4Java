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
		<style>
			.contentlist_layout {
    			padding: 0px 15px;
    			box-sizing: border-box;
			}
			.contentlist_layout {
    			padding: 0px 15px;
    			box-sizing: border-box;
			}
			
			.tab_menu {
    			clear: both;
    			height: 30px;
    			margin: 0px 0px -1px 0px;
    			padding: 0px 0px 0px 1px;
   		 		border-bottom: 1px solid #d4d4d4;
			}
			.tab_menuBox {
    			height: 31px;
    			margin-bottom: -1px;
    			overflow: hidden;
			}
			.tab_menu dt {
    			float: left;
   				margin: 0px;
    			padding: 0px;
			}
			.tab_menu dt span {
			    display: block;
			    height: 29px;
			    line-height: 29px;
			    padding: 0px 20px;
			    margin: 0px 0px 0px -1px;
			    border: 1px solid #d4d4d4;
			    border-bottom: 0 none;
			    background: #e7e7e7;
			    font-size: 12px;
			    font-weight: bold;
			    color: #777;
			    cursor: pointer;
			}
			.tab_menu dt:hover span {
    			position: relative;
    			border: 1px solid #828282;
    			border-bottom: 1px solid #ffffff;
    			background: #ffffff;
    			color: #333;
			}
			.tab_menu dt.on span {
    			position: relative;
    			border: 1px solid #828282;
    			border-bottom: 1px solid #ffffff;
    			background: #ffffff;
    			color: #333;
			}
			
			dl {
    			display: block;
    			margin-block-start: 1em;
    			margin-block-end: 1em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
			}
		</style>
		
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberGAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprovUI_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezAproveAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
	    <script type="text/javascript">
	        var OrgAprUserID = "<c:out value ='${orgAprUserID}'/>";
	        var OrgAprUserName = "<c:out value ='${orgAprUserName}'/>";
	        var OrgAprUserName2 = "";
	        var OrgAprUserDeptID = "<c:out value ='${orgAprUserDeptID}'/>";
	        var pEndDocHref = "<c:out value ='${dirPath}'/>";
	        var pDocID = "<c:out value ='${docID}'/>"; // 1안의 대표 docID
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
	        var pDraftFlag = "DRAFT"; // 일괄기안문서 전용 결재창이므로, 부서수신이나 부서합의가 아닌 "DRAFT"로 고정
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
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "";
	        var cabinetID = "";
	        var TaskCode = "";
	        var DocNumCode = "";
	        var allFlag = "0"; // 일괄기안에는 모두결재 사용 불가능이므로 0으로 고정
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
			
			// 일괄기안 관련
			var draftAllFlag = "Y";
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
	        
	        var pHasAttachYN = new String("N");
	        var pHasAttachYNAry = new Array();
	        var pHasDocAttachYN = new String("N");
	        var pHasDocAttachYNAry = new Array();
	        var pHasOpinionYN = new String("N");
	        var pHasOpinionYNAry = new Array();
	        
	        var SignInfoAry = new Array();
	    	var hapyuiCountAry = new Array();
	    	var SignCountAry = new Array();
	    	var gamsaCountAry = new Array();

	    	var extAry = new Array();

	    	// 결재정보는 모든 안에서 공유하므로, 굳이 배열을 쓰지 않아도 된다. (첨부파일 공개리스트 등은 개별로 유지)
	    	var btnReceivLineEnableAry = new Array(); // 수신처 존재 여부 (별도 유지)
			var SummaryOuterReceiverListAry = new Array(); // 외부수신자 리스트 (별도 유지)
	        var fileOpenFlagListArr = new Array(); // 원문정보공개 관련 첨부파일 별 공개여부 (별도 유지)
	        
			var htmlDataAry = new Array(""); // 웹한글기안기의 GetHTML 함수가 비동기로 동작하므로, 이 배열에 가져온 data를 넣어준다. 
			var pOrgHtmlAry = new Array(""); // 결재 중 오류 발생 시 원래 문서로 돌려주기 위한 데이터 저장 배열. 기본적으로 htmlDataAry값과 동일하다.
			
			// 일괄기안을 위하여 각 안마다 공통으로 사용되는 변수 부모창으로 이동함 (기존 ezDraftAll_WHWP.js 파일에 선언된 변수들)
			var lastKyulName, lastKyuljiwee, LastSignSN;
			var LastKyulSN;
			var DraftLastFlag = false;
	        
			var currentTabIdx = 0; // 안별 탭 구분용 인덱스 (selTab 함수로 현재 선택된 탭 인덱스)
			var allTabNum = "<c:out value ='${groupDocInfoListCnt}'/>"; //  현재 안의 갯수 (groupDocInfoListCnt)
			var wh = window.innerHeight - 100;
			
			var HwpCtrl = "";
			var lstAttachLink = ""; // 안별로 첨부파일 등의 관리를 위한 변수 
	        var titleOptionFlag = false;
	        var contentOptionFlag = false;
    		var attachOptionFlag = false;
    		var docAttachOptionFlag = false;
    		var seperateAttachOptionFlag = false;
    		var opinionOptionFlag = false;
    		var addFlag = false; // 최초 1안이 추가되었는지 판단하기 위한 변수
    		var reDraftFlag = false;
    		
    		var docMaxTabNumForApprov = 0; // 결재올림 동작 시, 전역변수로 사용하기 위한 총 안의 갯수 카운트
    		var docLoadCompleteCnt = 0; // 각 안의 문서들이 로딩되었는지 판단하기 위한 카운트 변수
    		// 초기 문서 로딩 시 사용하며, 초기 문서 로딩을 전부 완료한 후에는 더이상 카운트를 증가시키지 않는다.
    		
    		var docApprovInfoChkCnt = 0; // 결재진행 동작 시, 실제 결재올림 이전에 결재정보 체크가 정상 완료되었을 때 증가시킨다.
    		// 문서제목, 결재선, 수신자여부, 기록물철 등이 전부 정상일때마다 하나씩 증가시킨다.
    		// 결재동작 최초 체크 시 0으로 초기화한다. (오류 발생 시 return 되므로 -> 다시 결재올림 버튼을 클릭할때 초기화)
    		// 이 값이 최대 안의 갯수와 동일해졌을 때, 단 한번 결재암호체크 및 서명체크 동작을 진행한다.
    		
			var docApprovSignChkCnt = 0; // 결재진행 동작 도중, 각 안의 서명이 정상적으로 부여됐을 때 카운트를 증가시킨다.
			// 이 값이 최대 안의 갯수와 동일해졌을 때, GetHTML(Before_SaveApproveInfo)을 호출한다.
			
			var docGetHTMLCnt = 0; // 웹한글 함수의 비동기 html 리턴 동작에 대응하기 위한 전역변수 카운트.
			// 각 안의 html 데이터를 정상적으로 가져올때마다 하나씩 증가시킨다. 이 값이 최대 안의 값과 같아지는 경우에만 이후 동작을 진행한다.
    		
			var docApprovCompleteCnt = 0; // 각 안의 결재진행 동작이 완료되었을때 카운트를 증가시킨다.
			
			/* 2023-04-20 홍승비 - 각 안별 탭 생성 및 웹에디터 로딩 이전, 순차실행이 보장되도록 결재문서 데이터를 가져와 각 안이 사용할 수 있게 분리 */
			var pDocInfoAry = new Array();
			var pAttachInfoAry = new Array();
			var pModeForAllDocInfo = "APR"; // 일괄기안 문서는 모든 문서가 결재선을 공통으로 사용
			var pModeForAllAttachInfo = "APR"; // 첨부파일 정보를 가져오기 위한 pMode값 분리

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "${useAprFilePrvw}";
			
			// 2024-01-11 김우철 - 다안기안문서 전체 탭 호출 후 selTab(1)을 위한 setTimeout 시간
			var loadTime = "${loadTimeForApprAll}";
            var isPreview = "<c:out value ='${isPreview}'/>";
			
			// 모두결재 관련 함수
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
		    function OpenAllApproveFlag() {
		        var window_left = window.screen.availWidth / 2 - 160;
		        var window_top = window.screen.availHeight / 2 - 90;
		        
		        ezaprallalert_cross_dialogArguments[0] = "";
		        ezaprallalert_cross_dialogArguments[1] = OpenAllApproveFlag_Complete;
		
		        AllApprove.style.display = "none";
		        var parameter = "";
		        var url = "/ezApprovalG/ezAprAllAlert.do";
		        
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
			    if (allFlag == "1") {
			        getNextDocInfo();
			    } else if (allFlag == "2") {
			        getNextDocList();
			    }
			    
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
		        }
		        else {
		            if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() != "hwp") {
		                openOtherApprovUI();
		                return;
		            }
		            
		            DocNumCode = "";
		            
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
	       		getReSize();
				// 자식 iframe은 자기 자신을 리사이즈 할수 없으므로, 부모창에서 대신 조절함
					$(".tab_container").find("iframe").each(function(index, item) {
						this.contentWindow.Resize();
					});
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
	            	
	            	// 1안을 의미하는 [1] 인덱스 부터 배열 데이터가 들어가도록, [0]에는 공백 데이터를 부여함
					pDocIDAry.push("");
					pDocHrefAry.push("");
					pDocTypeAry.push("");
					extAry.push("");

	            <c:forEach items="${groupDocInfoList}" var="item">
               		pDocIDAry.push("${item.docID}");
               		pDocHrefAry.push("${item.docHref}"); // 문서경로
        			pDocTypeAry.push("${item.docType}"); // 문서타입 (내부결재, 수신문...)
        			extAry.push("${item.docHref}".substring("${item.docHref}".lastIndexOf(".") + 1)); // 확장자
        		</c:forEach>
        			
        			/* 2023-04-20 홍승비 - 각 안별 탭 생성 및 웹에디터 로딩 이전, 순차실행이 보장되도록 결재문서 데이터를 한 번에 가져와 각 안이 사용할 수 있게 분리 */
        			getLineModeAll(pDocIDAry[1]); // 결재진행중/완료여부 체크
        			getApprovInfoAll(pDocIDAry); // 결재문서 기본 정보
        			getAttachInfoAll(pDocIDAry); // 첨부파일 정보
        			
        			// 각 안별 탭 생성 및 로딩 진행
        			makeTabs();
        			dragNdrapNo();
        			
	                // 일괄기안창과 비전자문서 호환불가
	                /*
	                if (nonElecRec == "Y") {
				        getNonElecInfoSusinInit();
				        document.getElementById("btnAddSepAttach").style.display = "none";
			        }
	                */
	                
			        if (useExternalMailServer == "NO") {
			    		$("#btnMail").css("display","");
			    	}
			        
					// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가 (부모창)
					setAttachGuideText();
	                
		        }
		        catch (e) {
		        	alert("<spring:message code='ezApprovalG.t1373'/>" + e);
		        	
			        hideProgress();
			    }
		    }
	        
	        function dragNdrapNo() {
	            try {
	                var div = document.getElementById('lstAttachLink');
	                div.ondragenter = div.ondragover = function (e) {
	                    return false;
	                }
	                div.ondrop = function (e) {
	                    alert("드래그 앤 드랍 기능을 이용할 수 없습니다.\n[첨부] 메뉴를 이용해 주시기 바랍니다.");
	                    return false;
	                }
	            } catch (e) {
	                alert("apprGdraftuiAllContent_WHWP.jsp > dragNdrapNo()::" + e.description);
	            }
	        }
	        
		    function CheckOpinionYN(currIdx) {
		    	if (pDraftFlag == "SUSIN"){
		            getSusinSNInfo();
		    	} else {
		            pSusinSN = "0";
		    	}
		        if (pHasOpinionYNAry[currIdx] == "Y") {
		            var pInformationContent = "<spring:message code='ezApprovalG.t1374'/><br> <spring:message code='ezApprovalG.t10'/>";
			        var Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
			    }
		    }
		    
		    function CheckOpinionYN_complete(Ans) {
		    	DivPopUpHidden();
		    	if (Ans) {
		        	openOpinionUI_New("");
		        }
		    }
	
		    // 결재동작 완료 후, 문서의 변경이력을 업데이트하고 알러트 메세지를 표출하는 부분
		    // 알러트 메세지의 경우, 최종 안까지 전부 결재완료한 경우에 단 한번만 표출하도록 한다.
		    function process_AfterApprove(mode) {
		    	// 일괄기안 결재문서는 편집모드의 사용이 불가능하므로, FirstHtml값은 항상 ""으로 유지된다. 따라서 UpdateDocHistory 함수는 호출되지 않는다.
		    	/*
		        if (FirstHtml != "") {
		            UpdateDocHistory(FirstHtml);
		        }*/
		        
		        // allFlag는 으로 고정된 상태임 (모두결재, 일괄결재 호환불가)
		        if (docApprovCompleteCnt == docMaxTabNumForApprov) {
			        if (mode == "1") {
			            if (allFlag == "1" || allFlag == "2") {
			                LoadNextDocument("\n<spring:message code='ezApprovalG.t1375'/>");
					    }
					    else {
					    	// 문서를 [결재] 하였습니다.
					        var pAlertContent = "<spring:message code='ezApprovalG.t1376'/>";
					        HiddenMailProgress();
					        OpenAlertUI(pAlertContent, Draft_Complete);
					    }
			        }
			        else if (mode == "2") {
			        	// 1안을 기준으로 반송알림메일 발송
			        	if(backFailFlag) { /* 프론트로 반송 로직 태웠을때만 발송 */
			        	    document.getElementById("ifrm1").contentWindow.SendMailBansongtoDrafter();
			        	}
			        	
			            if (allFlag == "1" || allFlag == "2") {
			                LoadNextDocument("\n<spring:message code='ezApprovalG.t1377'/>");
					    }
					    else {
					    	// 문서를 [반송] 하였습니다.
					        var pAlertContent = "<spring:message code='ezApprovalG.t1378'/>";
					        HiddenMailProgress();
					        OpenAlertUI(pAlertContent, Draft_Complete);
					    }
			        }
			        else if (mode == "3") { // 보류알림메일은 없음
			            if (allFlag == "1" || allFlag == "2") {
			                LoadNextDocument("\n<spring:message code='ezApprovalG.t1379'/>");
					    }
					    else {
					    	// 문서를 [보류] 하였습니다.
					        var pAlertContent = "<spring:message code='ezApprovalG.t1380'/>";
					        HiddenMailProgress();
					        OpenAlertUI(pAlertContent, Draft_Complete);
					    }
			        }
			        else {
			            if (allFlag == "1" || allFlag == "2") {
			                LoadNextDocument("\n<spring:message code='ezApprovalG.t1381'/>");
					    }
					    else {
					    	// 문서를 [참조] 하였습니다.
					        var pAlertContent = "<spring:message code='ezApprovalG.t1382'/>";
					        HiddenMailProgress();
					        OpenAlertUI(pAlertContent, Draft_Complete);
					    }
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
		            HiddenMailProgress();
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        else if (chkpass == "cancel" || chkpass == undefined) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            HiddenMailProgress();
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        check_openSingUI();
		    }
	
			function setbutton() {
			    ChangeBtnState();
			}
			
			var approveResultAry = new Array();
            var ingFlag = false;
			function btnApprove_onclick() {
                if (ingFlag) {
                    return;
                }
                
                HiddenMailProgress();
                
                // 일괄기안을 위한 결재용 전역변수들 초기화
				docMaxTabNumForApprov = pDocIDAry.length -1; // 0번 인덱스 제거, 1안부터 결재 진행하도록 전역변수 셋팅
				docApprovInfoChkCnt = 0; // 각 안 별 결재정보 체크 카운트 전역변수 초기화
				docApprovSignChkCnt = 0; // 각 안 별 서명부여 체크 카운트 전역변수 초기화
				docApprovCompleteCnt = 0; // 각 안 별 결재성공 카운트 전역변수 초기화
				docGetHTMLCnt = 0; // 각 안 별 웹한글HTML 데이터 가져오기 성공 카운트 전역변수 초기화
				htmlDataAry = [""]; // 각 안 별 웹한글HTML 데이터 저장 배열 초기화
				pOrgHtmlAry = [""]; // 오류발생 시 이전 문서로 되돌리기 위한 HTML 데이터 저장 배열 초기화 
				pDocNumCodeAry = [""]; // 각 안 별 문서번호 저장 배열 초기화
				pDocNumSnAry = [""]; // 각 안 별 문서번호 숫자부분(tempNumString) 저장 배열 초기화
				
                //  암호체크 및 서명선택 동작은 단 한번만 동작하도록 한다. (모든 체크가 끝난 뒤, 카운트를 확인하여 호출)
                for (var i = 1; i <= docMaxTabNumForApprov; i++) {
                	var pApprovDocID = pDocIDAry[i];
                	
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/getExtTotalAttachSize.do",
			    		data : {
			    			docID : pApprovDocID
			    		},
			    		success: function(text){
			    			approveResultAry[i] = text; // 인덱스 접근을 위해 배열로 관리
			    		}
			    	});
                    GetHTML2(Approve, i, docMaxTabNumForApprov); // 웹한글 비동기 함수에 호환되도록 반드시 인덱스 사용
				}
		    }
			
			 // 웹한글함수로 문서 로딩 완료 후 비동기적으로 콜백함수를 호출한다. 따라서 인덱스와 전역변수를 사용하여 제어한다.
			 // 결재인 경우 before_SaveFile, 반송인 경우 btnReject_option_Complete2, 보류인 경우 btnStay_option_Complete2 함수를 각각 콜백함수로 사용한다.
			 function GetHTML(callback) {
                ingFlag = true;
                docGetHTMLCnt = 0; // 문서로딩 카운트 초기화
                htmlDataAry = [""]; // 각 안 별 웹한글HTML 데이터 저장 배열 초기화
				pOrgHtmlAry = [""]; // 오류발생 시 이전 문서로 되돌리기 위한 HTML 데이터 저장 배열 초기화 
				
                // 내부에서 각 안 별로 iframe을 찾아 each루프를 돌려준다.
                var ifrms = $(".tab_container").find("iframe"); // == document.getElementById("ifrm" + i) 와 동일하다.
                
                ifrms.each(function(index, item) {
                	item.contentWindow.GetTextFile("HWP", "", function (data) {
                		ingFlag = false;
                		
                		docGetHTMLCnt ++; // 웹한글 비동기함수 동작 정상 완료 시 카운트 증가
                		htmlDataAry[index + 1] = data; // html data 리턴받은것을 배열에 저장 -> 콜백함수 내부에서 이걸 사용한다. 
                		pOrgHtmlAry[index + 1] = data; // 오류 시 문서 원복을 위해 사용할 데이터
                		callback(); // 전역변수인 htmlDataAry를 사용하게 되므로, data 파라미터는 넘겨주지 않는다.
                	});
                });
			 }
			 
			// 콜백함수명, 현재 루프를 진행중인 안 인덱스, 전체 안의 갯수(모든 안의 결재정보 확인 카운트를 파악하기 위해 전달)
			 function GetHTML2(callback, currIdx, maxIdx) {
                ingFlag = true;
			    document.getElementById("ifrm" + currIdx).contentWindow.GetTextFile("HWPML2X", "", function (data) { ingFlag = false; callback(data, currIdx, maxIdx); });
			 }
			
			 // 특정 안의 의견작성 이후 파일저장동작 전용 함수 (하나의 안에 대해서만 동작하므로, 루프 없음)
			 function GetHTMLForOpinion(callback, currIdx) {
				 ingFlag = true;
				 document.getElementById("ifrm" + currIdx).contentWindow.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data); });
			 }
			 
			 function SetHTML(data, callback, currIdx) {
				 document.getElementById("ifrm" + currIdx).contentWindow.SetTextFile(data, "HWP", "", function (result) { callback(result) });
			 }
			 
			 // btnApprove_onclick -> Approve 시작
			 function Approve(html, currIdx, maxIdx) {
				var currIfrm = document.getElementById("ifrm" + currIdx); // 각 안별 웹한글기안기 iframe을 사용
				var strBytes = parseInt(getByteLength(html));
                var rtnAttachXML = loadXMLString(approveResultAry[currIdx]);
	            var attachTotalSize = getNodeText(rtnAttachXML.getElementsByTagName("TOTALSIZE").item(0));

                if (getNodeText(rtnAttachXML.getElementsByTagName("FLAG").item(0)) == "Y") {
                	HiddenMailProgress();
                    OpenAlertUI("외부발송문서 총 첨부용량은 최대 6MB 입니다" + "<br>" + currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "첨부용량을 줄여주시기 바랍니다.");
                    return;
                }

                // 본문과 첨부파일의 총합이 7.4mb가 초과시 알러트 결재라인 수정시에도 2018-07-19 강민수92
                if (getNodeText(rtnAttachXML.getElementsByTagName("EXTFLAG").item(0)) == "Y" && strBytes + parseInt(attachTotalSize) > 7400000) {
                	HiddenMailProgress();
                	OpenAlertUI("외부발송문서 총 용량은 최대 7.4MB 입니다" + "<br>" + currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "첨부파일이나 본문용량을 줄여주시기 바랍니다.");
                    return;
                }
                
                // OrgAprUserName님의 결재 문서입니다.\\n대결을 진행하시겠습니까? (1안인 경우에만 확인 알러트 표출)
                if (OrgAprUserID != arr_userinfo[1] && docApprovInfoChkCnt == 0) {
                    if (!confirm(OrgAprUserName + "<spring:message code='ezApprovalG.t2106'/>")) { // 취소 시 창 닫음
                    	HiddenMailProgress();
                    	window.returnValue = "CLOSE";
                    	btnClose_onclick();
                        return;
                    }
                }
                
                // 결재버튼 다중클릭 방지
			    setMenuDisable("btnApprove", true);
				
			    var parameter = new Array();
			    parameter[0] = pDocIDAry[currIdx];
			    var signInfo;
				
			    // 최종결재, 전결, 대결
			    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			        if (pDraftFlag == "HABYUI" || pDraftFlag == "B_GAMSA" || pDraftFlag == "A_GAMSA") {
			        	currIfrm.contentWindow.getLastOpinonForDraftAll(currIdx); // 의견정보를 memo 필드에 부여
			        }
			        if (currIfrm.contentWindow.FieldExist("lastdraftdate")) {
			        	currIfrm.contentWindow.PutFieldText("lastdraftdate", getGyulJeDate());
			        }
			    }
				
			    // 각 안의 결재 전 체크가 끝난 경우, 카운트를 증가
			    docApprovInfoChkCnt ++;
			    
			    // 모든 안의 체크가 완료된 경우, 최종 안 하나만 암호를 체크 + 서명을 선택한다.
			    if (docApprovInfoChkCnt == maxIdx) {
				    if (!isjunkyul) { // 전결이 아닌 경우 (전결버튼 클릭 시에만 isjunkyul값이 true가 된다.)
				        if (CheckUsePassword()) {
				            chk_Passwd(pingUserID, btnApprove_chkpassword_Complete);
			            } else {
			            	check_openSingUI();
			            }
				    } else {
				    	check_openSingUI();
				    }
			    }
			    
			 }
			 // Approve 끝
			 
			 function check_openSingUI() {
	            var ret = "NAME"
	            
	            if ((pAprLineType != strAprType2) && (pAprLineType != strAprType7) && (pAprLineType != strAprType15) && (pAprLineType != strAprType17)) {
	                openSingUI(); // 파라미터 전달할 필요 없음, 서명선택 레이어팝업 호출
	            }
	            else { // 확인, 참조, 후열, 공람 등 결재서명을 부여하지 않는 분기
	            	//Approve_complete(ret);
	            	Approv_Complete_BackEnd(ret);
	            }
	        }
			 
			 function openSingUI_Complete(ret) {
				 DivPopUpHidden();
				 ShowMailProgress();
				 
				 if (ret == "cancel" || ret == undefined) {
		            var pAlertContent = "[<spring:message code='ezApprovalG.t29'/>";
		            HiddenMailProgress();
			        OpenAlertUI(pAlertContent);
			        setMenuDisable("btnApprove", false);
			        return;
			     }else if(ret == "NAME"){
                    Approv_Complete_BackEnd(ret);
                 }else{
                    Approve_complete(ret);
                 }
                 // Approve_complete(ret);
			 }

			   // Approve -> (openSingUI_Complete) -> Approve_complete 시작
			   function Approve_complete(ret) {
				   DivPopUpHidden();
				   ShowMailProgress();
				   
				   // 각 안 별로 루프를 돌리며 진행한다.
				   /*
				   if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                // 일괄기안문서 연동 호환 불가
			            	var rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")
			                if (!rtnVal) {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
		                }
		            }
				   */
				   for (var i = 1; i <= docApprovInfoChkCnt; i++) {
					   var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
					   
					   if (pDraftFlag != "SUSIN" && pDraftFlag != "HABYUI") { // 일반 결재
			                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) { // 최종결재 분기
			                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                        var rtnval;
			                        
			                    	 // getDocNumberNew 는 자식 프레임에 직접 접근하여 사용하도록 한다.
			    	        		// 문서번호 부여는 공통 작업이 아니라 각 안 별 작업이므로, 각 자식 프레임의 동작이 되도록 로직을 정리함 (인덱스는 반드시 전달)
			                        rtnval = currIfrm.contentWindow.getDocNumberNew(drafterDeptid, "", docNumZeroCnt, i);
			                        
			                        if (!rtnval) {
			                        	HiddenMailProgress();
			                            var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
								        OpenAlertUI(pAlertContent);
								        setMenuDisable("btnApprove", false);
								        return;
								    }
			                    }
			                }
				         } else { // 수신문서, 합의문서의 결재 (일괄기안 결재창에서 접근하지는 못할듯?)
				            	//useReceiveDocNo 처리
					            if (useReceiveDocNo == 'NO') {
					            	if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
						            	// 1 : 결재, 2 : 확인, 4 : 전결, 16 : 대결, 18 : 기안, 19 : 검토
						                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
						                    var rtnval;
						                    rtnval = currIfrm.contentWindow.getDocNumberNew(drafterDeptid, "", docNumZeroCnt, i);
						                    
						                    if (!rtnval) {
						                    	HiddenMailProgress();
						                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
						                        OpenAlertUI(pAlertContent);
						                        setMenuDisable("btnApprove", false);
						                        return;
						                    }
						                }
						            }
					            }
				            }
					   
					   // 연동 호환불가
					   /*
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
							*/
							// 연동 호환불가
							/*
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
			            }*/
					   
					   currIfrm.contentWindow.AprrovMappingSign(ret, docMaxTabNumForApprov);
					   
			            var rtnVal = true;
			            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                	currIfrm.contentWindow.SetAutoPropFinal();
			                    /*
			                    var rtnVal = ExcuteInfo("LAST_SIGN_AFTER", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }*/
			                }
			            } else {/*
			                var rtnVal = ExcuteInfo("MIDDLE_SIGN_AFTER", "")
			                if (!rtnVal) {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }*/
			            }
				   }
			   }
			   // Approve_complete 끝
			   
			   /**
               * BackEnd에서 결재 처리
               */
               var backFailFlag = false;
               function Approv_Complete_BackEnd(signtype){
                   var res = "";
                   
                   /* 백단 결재 실패한 이력이 있는 doc은 프론트 결재 로직 */
                   if(getCheckNotFailDoc()){
                       backFailFlag = true;
                   }
                   
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
                                   
                                   docApprovCompleteCnt = docMaxTabNumForApprov;
                                   
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
                       /* 백단 결재 로직 실패 시 프론트로 결재 */
                       if(backFailFlag){
                           docApprovCompleteCnt = 0;
                           //showLoadingProgress();
                           Approve_complete(signtype);
                           //hideLoadingProgress();
                       }
                   }else{
                       Approve_complete(signtype);
                   }
               }
			   
			   // AprrovMappingSign() 함수로 서명 부여 후, GetHTML에서 비동기 웹한글함수의 동작 성공 시 콜백으로 이 함수를 부르게 된다.
			   // Approve_complete -> Before_SaveApproveInfo 시작
			   function Before_SaveApproveInfo() {
				  // 각 안 별로 GetHTML에서 한글파일 data를 모두 가져오는 것에 성공한다면, 다음 단계로 넘어간다.
				if (docGetHTMLCnt < docMaxTabNumForApprov) {
					return;
				}
				// 최종 안에서 아래 동작이 단 한번만 동작하게 된다. 따라서 내부에서 루프를 돌린다.
				else {
					var rollBackFlag = false; // 결재진행 중 안이 하나라도 오류를 발생시키는지 체크하는 플래그
					for (var i = 1; i <= docMaxTabNumForApprov; i++) {
						var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
			        	
			        	 // 자식창 iframe 전용 js를 쓰고 있어, 내부적으로 parent의 변수에 접근한다.
			        	  var rtnVal = currIfrm.contentWindow.SaveApproveInfo("1", i);
			        	 
			        	 // 결재문서 hwp 파일 저장, 결재 로직 진행에 실패한 경우 FALSE를 리턴 -> 일괄적으로 롤백 진행
			        	 // 오류 발생 시 자식 안에 접근하여 서명 제거 (하단의 개별 루프로 분리)
				            if (rtnVal != "TRUE") {
				            	rollBackFlag = true;
	                    		break; // 현재 루프 빠져나가서 하단으로 이동
						    } else {
						    	// 일괄기안용 결재선 업데이트함수로 변경 (pDocIDAry에 접근)
		                        UpdateLineHistoryForDraftAll(i);
						    	
						    	docApprovCompleteCnt ++; // 각 안의 결재가 정상적으로 완료된 경우, 전역변수 카운트 증가
						    
						        if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2)|| pAprLineType == strAprType4 || pAprLineType == strAprType16) {
						            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
				
						            	/*
						                var rtnVal = ExcuteInfo("LAST_END_AFTER", "")
						                if (!rtnVal) {
						                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
									        OpenAlertUI(pAlertContent);
									        setMenuDisable("btnApprove", false);
									        return;
						                }
						            	*/
						            	// 결재문서 완료 알림메일은 1안의 정보를 기준으로 한번만 발송한다. (단, 수신처로 발송하는 메일은 예외)
						            	if (docApprovCompleteCnt == docMaxTabNumForApprov) {
							                getOpinionInfo(pDocIDAry[1], "END"); // 1안의 의견정보 추출해서 SendMailApprove.js 파일의 전역변수인 valueOpinion에 부여함
							                SendMailToDrafterForDraftAll();
						            	}
						            	// 각각의 수신처로 알림메일 발송 (각 안 별 XML에 지정된 DOCINFO 정보 사용함)
						            	//currIfrm.contentWindow.SendMailToReceiveDept_Approv();
						            	// 해당 수신알림메일 발송 부분 서비스단으로 이동함 (스케줄러 대응)
				                    }
				                }
				                else {
				                	/*
				                    var rtnVal = ExcuteInfo("MIDDLE_END_AFTER", "")
				                    if (!rtnVal) {
				                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
								        OpenAlertUI(pAlertContent);
								        setMenuDisable("btnApprove", false);
								        return;
				                    }
				                	*/
				                	// 결재문서 도착 알림메일은 1안의 정보를 기준으로 한번만 발송한다.
				                	if (docApprovCompleteCnt == docMaxTabNumForApprov) {
						            	sendAlertMail("APR", pAprMemberSN, "DRAFTALL_APPROV");  // 일괄기안용 메일알림분기 DRAFTALL_APPROV 추가
				                	}
				                }
				
				                if ((pDraftFlag == "SUSIN" || pAprLineType == strAprType7) && KuyjeType == "001") { // KuyjeType은 002로 고정되어있기 때문에, 이 분기는 타지 않는다.
				                	// 최종 안까지 전부 기안올림 성공 시 메세지 한번만 표출
				                	if (docApprovCompleteCnt == docMaxTabNumForApprov) {
			                        	// 문서를 [접수]하였습니다. -> 창 닫음
					                    var pAlertContent = "<spring:message code='ezApprovalG.t1387'/>";
					                    HiddenMailProgress();
								        OpenAlertUI(pAlertContent);
								        btnClose_onclick();
								        Btnflag = "false";
								        ChangeBtnState();
				                	}
							    }
							    else {
							    	// process_AfterApprove 함수 내부에서 알림 메세지 표출함
							        if (pAprLineType == strAprType7) { // 참조 성공
							            process_AfterApprove("4");
							        }
							        else { // 결재 성공
							            process_AfterApprove("1");
							        }
							    }
				            }
						}
					
						// 결재진행 도중 SaveApproveInfo에서 오류가 발생한 경우, 모든 안에 대해 롤백을 진행한다.
						if (rollBackFlag == true) {
							for (var i = 1; i <= docMaxTabNumForApprov; i++) {
								var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
								
								if (pDraftFlag != "SUSIN") {
		                            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                                	currIfrm.contentWindow.rollbackDocNumber(drafterDeptid, "doc", pDocIDAry[i], i);
		                                }
		                            }
				                } else {
		                            if (useReceiveDocNo == 'NO') {
		                                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                                    	currIfrm.contentWindow.rollbackDocNumber(drafterDeptid, "receipt", pDocIDAry[i], i);
		                                    }
		                                }
		                            }
		                        }
								
								// newSignInfo는 AprrovMappingSign()함수에서 부여한 서명관련 배열 데이터임 
								currIfrm.contentWindow.UndoSignInfo(newSignInfo);
				                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
				                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
				                        /*
				                    	var rtnVal = ExcuteInfo("END_FAIL", "")
				                        if (!rtnVal) {
				                            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
									        OpenAlertUI(pAlertContent);
									        setMenuDisable("btnApprove", false);
									        return;
									    }
				                    	*/
				                    }
				                } else {
				                	/*
				                    var rtnVal = ExcuteInfo("MIDDLE_END_FAIL", "")
				                    if (!rtnVal) {
				                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
								        OpenAlertUI(pAlertContent);
								        setMenuDisable("btnApprove", false);
								        return;
								    }
				                	*/
				                }
							}
							// 롤백완료 알러트 표출 및 GetHTML() 함수의 호출은 루프 종료 이후 한번만 진행
			                var pAlertContent = "[<spring:message code='ezApprovalG.t34'/>"; // 결재] 처리가 되지 않았습니다.
			                HiddenMailProgress();
					        OpenAlertUI(pAlertContent);
					        setMenuDisable("btnApprove", false);
	                        GetHTML(before_SaveFile);
					        return;
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
			        if (!Ans) {return;}
			        ShowMailProgress();
			        
			        docMaxTabNumForApprov = pDocIDAry.length -1; // 0번 인덱스 제거, 1안부터 결재 진행하도록 전역변수 셋팅
					docGetHTMLCnt = 0; // 각 안 별 웹한글HTML 데이터 가져오기 성공 카운트 전역변수 초기화
					docApprovCompleteCnt = 0; // 결재완료 플래그. 여기에서는 반송동작 완료 플래그로 사용한다.
					htmlDataAry = [""]; // 각 안 별 웹한글HTML 데이터 저장 배열 초기화
					pOrgHtmlAry = [""]; // 오류발생 시 이전 문서로 되돌리기 위한 HTML 데이터 저장 배열 초기화 
					
					selTab(1); // 의견 정보 접근을 위해 1안으로 변경
			        if (CheckUsePassword()) {
				        chk_Passwd(pingUserID, btnReject_chkpassword_Complete);
			        } else {
			        	HiddenMailProgress();
			        	openOpinionUI_New("BanSong", btnReject_option_Complete);
			        }
			    }
			        
			    function btnReject_chkpassword_Complete(chkpass) {
			    	DivPopUpHidden();
			    	ShowMailProgress();
			    	
			    	if (chkpass == "FALSE") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
			            HiddenMailProgress();
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			        else if (chkpass == "cancel") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
			            HiddenMailProgress();
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			    	HiddenMailProgress();
			        openOpinionUI_New("BanSong", btnReject_option_Complete);
			    }
			    
			 // 1안을 기준으로 작성한 반송의견을 모든 안에 추가한다. (기존 의견은 유지한 상태로 진행)
			    function btnReject_option_Complete(ret) {
			    	DivPopUpHidden();
			    	ShowMailProgress();
			    	
					if (ret != "cancel" && ret != undefined ) {
			            /*
			            var rtnVal = ExcuteInfo("BANSONG_BEFORE", "")
			            if (!rtnVal) {
			                var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent, OpenAlertUI_Complete);
					        return;
					    }
			            */
			            if(backFailFlag){
                            for (var i = 1; i <= docMaxTabNumForApprov; i++) {
                               var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
                               
                               // 1안의 반송의견을 각 안으로 복사 (1안인 경우에는 동작하지 않도록 분기처리)
                               if (i > 1) {
                                    copyFirstTabOpinion(pDocIDAry[1], pDocIDAry[i], "002");
                               }
                               // 모든 안에 대하여 반송의견이 반영되었으므로 의견존재여부 플래그를 변경
                               pHasOpinionYNAry[i] = "Y";
                               
                                currIfrm.contentWindow.setInitOpinion(); // 자식 프레임에 접근하여 각 안 별로 문서에 의견 맵핑 진행
                                UpdateLineHistoryForDraftAll(i); // 결재선 변경내역 보류상태로 업데이트
                            }
			                GetHTML(btnReject_option_Complete2);
			            }
			            else{
                        /* 백단 반송 로직 */
                            for (var i = 1; i <= docMaxTabNumForApprov; i++) {
                               // 1안의 반송의견을 각 안으로 복사 (1안인 경우에는 동작하지 않도록 분기처리)
                               if (i > 1) {
                                    copyFirstTabOpinion(pDocIDAry[1], pDocIDAry[i], "002");
                               }
                               // 모든 안에 대하여 반송의견이 반영되었으므로 의견존재여부 플래그를 변경
                               pHasOpinionYNAry[i] = "Y";
                            }
                            var res = SaveApproveInfoInBackEnd("2");
                            if(res){
                                var resCode = res.status;    // ok / error
                                if(resCode == "ok"){
                                    var resData = res.data;  // SUCCESS / FAIL
                                    if(typeof resData != "undefined" && resData.toUpperCase() == "SUCCESS"){
                                        docApprovCompleteCnt = docMaxTabNumForApprov;
                                        // 반송 완료
                                        process_AfterApprove("2");
                                    }else if(typeof resData != "undefined" && resData.toUpperCase() == "FAIL"){
                                        // 결재 실패
                                        backFailFlag = true;
                                    }
                                }else{ // 호출시 데이터 문제(type) or 백단 결재 로직 오류
                                    backFailFlag = true;
                                }
                            }
                            if(backFailFlag){
                                btnReject_option_Complete(ret);
                            }
			            }
			        } else if (ret == "cancel" || ret == undefined) {
			        	var pAlertContent = "<spring:message code='ezApprovalG.t38'/>";
			        	HiddenMailProgress();
			        	OpenAlertUI(pAlertContent, null);
				        return;
			        }
			    }
			    
			    function btnReject_option_Complete2() {
			    	// GetHTML에 의해 모든 안의 문서 로딩이 끝난 경우에 다음으로 진행
					if (docGetHTMLCnt < docMaxTabNumForApprov) {
						return;
					} else {
						// 최종 안까지 로딩된 후, 아래 동작 진행
						for (var i = 1; i <= docMaxTabNumForApprov; i++) {
							var currIfrm = document.getElementById("ifrm" + i);
							 // 자식창 iframe 전용 js를 쓰고 있어, 내부적으로 parent의 변수에 접근한다.
							var RtnVal = currIfrm.contentWindow.SaveApproveInfo("2", i);
							
							// 반송동작 완료 시 전역변수 카운트 증가
							docApprovCompleteCnt ++;
							
				            if (RtnVal != "TRUE") {
				            	/*
				                var rtnVal = ExcuteInfo("BANSONG_FAIL", "")
				                if (!rtnVal) {
				                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        return;
							    }*/
				                var pAlertContent = "<spring:message code='ezApprovalG.t1388'/>";
				                HiddenMailProgress();
						        OpenAlertUI(pAlertContent);
						        return;
						    }
						    else {
						    	/*
						        var rtnVal = ExcuteInfo("BANSONG_AFTER", "")
						        if (!rtnVal) {
						            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        return;
							    }*/
							 // 매 루프마다 호출되나, 내부적으로 docApprovCompleteCnt값을 체크하여 최종 안까지 보류가 완료되었는지 체크하여 한번만 동작한다.
				                process_AfterApprove("2");
				            }
						}
					}
			    }
			    // 반송관련 로직 끝
	
			    // 보류 btnStay_onclick 시작
			    function btnStay_onclick() {
			        var pInformationContent = "<spring:message code='ezApprovalG.t39'/>";
			        var Ans = OpenInformationUI(pInformationContent, btnStay_onclick_Complete);
			    }
			    
			    // 보류의견 작성은 1안을 기준으로 진행
			    function btnStay_onclick_Complete(Ans) {
			    	DivPopUpHidden();
			        if (!Ans) {return;}
			        ShowMailProgress();
			        
			        docMaxTabNumForApprov = pDocIDAry.length -1; // 0번 인덱스 제거, 1안부터 결재 진행하도록 전역변수 셋팅
					docGetHTMLCnt = 0; // 각 안 별 웹한글HTML 데이터 가져오기 성공 카운트 전역변수 초기화
					docApprovCompleteCnt = 0; // 결재완료 플래그. 여기에서는 보류동작 완료 플래그로 사용한다.
					htmlDataAry = [""]; // 각 안 별 웹한글HTML 데이터 저장 배열 초기화
					pOrgHtmlAry = [""]; // 오류발생 시 이전 문서로 되돌리기 위한 HTML 데이터 저장 배열 초기화 
			        
			        selTab(1); // 의견 정보 접근을 위해 1안으로 변경
			    	if (CheckUsePassword()) {
				        chk_Passwd(pingUserID, btnStay_chkpassword_Complete);
			        } else {
			        	HiddenMailProgress();
			        	openOpinionUI_New("BoRyu", btnStay_option_Complete);
			        }
			    }
			    
			    function btnStay_chkpassword_Complete(chkpass) {
			    	DivPopUpHidden();
			    	ShowMailProgress();
			    	
			    	if (chkpass == "False") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
			            HiddenMailProgress();
				        OpenAlertUI(pAlertContent);
				        return;
			        } else if (chkpass == "cancel" || chkpass == undefined) {
				        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
				        HiddenMailProgress();
				        OpenAlertUI(pAlertContent);
				        return;
				    }
			    	HiddenMailProgress();
			    	openOpinionUI_New("BoRyu", btnStay_option_Complete)
			    }
			    
			    // 1안을 기준으로 작성한 보류의견을 모든 안에 추가한다. (기존 의견은 유지한 상태로 진행)
			    function btnStay_option_Complete(ret) {
			    	DivPopUpHidden();
			    	ShowMailProgress();
			    	
					if (ret != "cancel" && ret != undefined) {
						if(backFailFlag){
                            // 모든 안에 대하여 1안의 보류의견 복사 + 문서 상에 의견 맵핑 + 문서파일 저장동작 진행
                            for (var i = 1; i <= docMaxTabNumForApprov; i++) {
                               var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
                               
                               // 1안의 보류의견을 각 안으로 복사 (1안인 경우에는 동작하지 않도록 분기처리)
                               if (i > 1) {
                                    copyFirstTabOpinion(pDocIDAry[1], pDocIDAry[i], "003");
                                }
                                // 모든 안에 대하여 보류의견이 반영되었으므로 의견존재여부 플래그를 변경
                                pHasOpinionYNAry[i] = "Y";
                               
                                currIfrm.contentWindow.setInitOpinion(); // 자식 프레임에 접근하여 각 안 별로 문서에 의견 맵핑 진행
                                UpdateLineHistoryForDraftAll(i); // 결재선 변경내역 보류상태로 업데이트
                            }
						
						    GetHTML(btnStay_option_Complete2); // 내부적으로 루프를 돌리면서 웹한글 텍스트 로딩 완료 후 btnStay_option_Complete2 함수를 각 안마다 호출함
						}
						else{
                            for (var i = 1; i <= docMaxTabNumForApprov; i++) {
                               // 1안의 보류의견을 각 안으로 복사 (1안인 경우에는 동작하지 않도록 분기처리)
                               if (i > 1) {
                                    copyFirstTabOpinion(pDocIDAry[1], pDocIDAry[i], "003");
                               }
                               // 모든 안에 대하여 보류의견이 반영되었으므로 의견존재여부 플래그를 변경
                               pHasOpinionYNAry[i] = "Y";
                            }
                            var res = SaveApproveInfoInBackEnd("3");
                            if(res){
                                var resCode = res.status;    // ok / error
                                if(resCode == "ok"){
                                    var resData = res.data;  // SUCCESS / FAIL
                                    if(typeof resData != "undefined" && resData.toUpperCase() == "SUCCESS"){
                                        docApprovCompleteCnt = docMaxTabNumForApprov;
                                        // 보류 완료
                                        process_AfterApprove("3");
                                    }else if(typeof resData != "undefined" && resData.toUpperCase() == "FAIL"){
                                        // 결재 실패
                                        backFailFlag = true;
                                    }
                                }else{ // 호출시 데이터 문제(type) or 백단 결재 로직 오류
                                    backFailFlag = true;
                                }
                            }
                            if(backFailFlag){
                                btnStay_option_Complete(ret);
                            }
						}
			        } else if (ret == "cancel" || ret == undefined) {
			        	var pAlertContent = "<spring:message code='ezApprovalG.t392'/>";
			        	HiddenMailProgress();
			        	OpenAlertUI(pAlertContent);
			        	return;
			        }
			    }
			    
			    function btnStay_option_Complete2() {
			    	// GetHTML에 의해 모든 안의 문서 로딩이 끝난 경우에 다음으로 진행
			    	if (docGetHTMLCnt < docMaxTabNumForApprov) {
		        		return;
		        	} else {
		        		// 최종 안까지 로딩된 후, 아래 동작 진행
		        		for (var i = 1; i <= docMaxTabNumForApprov; i++) {
		        			var currIfrm = document.getElementById("ifrm" + i);
					    	 // 자식창 iframe 전용 js를 쓰고 있어, 내부적으로 parent의 변수에 접근한다.
					    	var RtnVal = currIfrm.contentWindow.SaveApproveInfo("3", i);
					    	// 보류동작 완료 시 전역변수 카운트 증가
					    	docApprovCompleteCnt ++;
							
				            if (RtnVal != "TRUE") {
				                var pAlertContent = "<spring:message code='ezApprovalG.t1389'/>";
				                HiddenMailProgress();
						        OpenAlertUI(pAlertContent);
						        return;
						    }
						    else {
						    	// 매 루프마다 호출되나, 내부적으로 docApprovCompleteCnt값을 체크하여 최종 안까지 보류가 완료되었는지 체크하여 한번만 동작한다.
						        process_AfterApprove("3");
						    }
		        		}
		        	}
			    }
			 	// 보류관련 로직 끝
	
			 	// 전결관련 로직 시작
			    function btnJunKyul_onclick() {
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
	
			    // btnEdit_onclick 편집모드 시작 (일괄기안 지원불가)
			    /*
			    function btnEdit_onclick() {
			        if (modeflag) {
			            modeflag = false;
			            chkBtnConfirm("1");
			            chkBtn(false);
			
			            //beforeHwp = HwpCtrl.GetCloneData("", "HWP");
			            message.EditMode(1);
			
			            setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t42'/>");
			            GetHTML(beforeHWPBody);
			        } else {
						if (message.FieldExist("doctitle")) {
							pDocTitle = trim(message.GetFieldText("doctitle"));
						} else {
							pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
						}

						if (pDocTitle == "") {
							var pAlertContent = "<spring:message code='ezApprovalG.t1491'/>";
							OpenAlertUI(pAlertContent);
							return;
						}
			            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
				        var Ans = OpenInformationUI(pInformationContent, btnEdit_onclick_Complete);
			        }
			    }
			    
			    function beforeHWPBody(hwpBody) {
		            beforeHwp = hwpBody;
		        }
			    
			    function btnEdit_onclick_Complete(Ans) {
			    	DivPopUpHidden();
			    
			    	message.EditMode(3);
			        setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t44'/>");
		
				    if (Ans) {
				        if (FirstHtml == "") {
				            FirstHtml = beforeHwp;
				        }
				        message.EditMode(0);
				    	modeflag = true;
				    	chkBtnConfirm("2");
				    } else {
		                SetHTML(beforeHwp, btnEdit_Cancel_Complete)
		            } 
			    }
			    
			    function btnEdit_Cancel_Complete(result) {
		            message.EditMode(0);
		            modeflag = true;
		            chkBtnConfirm("2");
		        }
			    */
			    // btnEdit_onclick 편집모드 끝
	
			    // 결재선 지정기능
			    function btnModAprLine_onclick() {
			        var ret = openAprLineUI();
			        TempsaveAprlineinfo = ret[0];
			
			        if (ret[0] != "cancel" && ret[0] != "EXIST") {
			            ReAprLineSingMapping(ret);
			            SaveFile();
			            getCurApproverAprLine();
			        }
			    }
	
			    // 모든 js에서 .aspx로 연결되는 사용되지 않는 기능임
			    /*
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
	*/
	
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
					var formFileLocation = pDocHrefAry[currentTabIdx];
					var currentExt = formFileLocation.substring(formFileLocation.lastIndexOf(".") + 1);
					if (currentExt === "mht") {
						PrintClick("Cross", pDocID, "ING");
					} else {
						var currIfrm = document.getElementById("ifrm" + currentTabIdx);
						currIfrm.contentWindow.PrintDocument();
					}
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
			    	/* 2024-12-27 홍승비 - MHT 양식의 일괄기안 기능이 추가되며 발생한 사이드 이펙트 수정 (WHWP 문서의 메일발송 오류 수정) */
			        if (document.getElementById("ifrm" + currentTabIdx).contentWindow.isHWP == "Y") {
    			    	// window.open("/ezEmail/mailWrite.do?docHref=" + pDocHrefAry[currentTabIdx] + "&cmd=docsend&docID=" + pDocIDAry[currentTabIdx] + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
						showPopup("/ezEmail/mailWrite.do?docHref=" + pDocHrefAry[currentTabIdx] + "&cmd=docsend&docID=" + pDocIDAry[currentTabIdx] + "&TARGET=APPROVALG", 1200, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
			        } else {
                        var imgUrl = "";
                        html2canvas(document.getElementById("ifrm" + currentTabIdx).contentWindow.document.getElementById("div_Content")).then(function(canvas) {
                            $.ajax({
                                type:"POST",
                                dataType:"text",
                                data : {
                                    imgUrl : canvas.toDataURL("image/png"),
                                    docID: pDocIDAry[currentTabIdx]
                                },
                                url: "/ezApprovalG/createMailImg.do",
                                success: function (data) {
                                }
                            });
                        }
                    );
                    var pheight = window.screen.availHeight;
                    var conHeight = pheight * 0.8;
                    var pwidth = window.screen.availWidth;
                    var pTop = (pheight - conHeight) / 2;
                    var pLeft = (pwidth - 1200) / 2;
                    //기존
                    var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocIDAry[currentTabIdx] + "&docHref=" + encodeURIComponent(pDocHrefAry[currentTabIdx])+"&orgCompanyID="+orgCompanyID;
                    // var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
                    // newwin.focus();
						showPopup(pURL, 1200, conHeight, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
                    }
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
			    
			    var inssepattach_cross_dialogArguments = new Array();
			    function btnAddSepAttach_onclick() {
			        if (cabinetID == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t48'/>";
				        OpenAlertUI(pAlertContent);
				        return;
				    }
			        
					// 안별 웹한글기안기 iframe 내부에 접근하여 분리첨부정보 가져오는 함수를 실행
					var currIfrm = document.getElementById("ifrm" + allTabNum);
			        var g_SepAttachLVXml = "";
			        g_SepAttachLVXml = currIfrm.contentWindow.GetDocumentElementForDraftAll("sepattachlvxml", true);
			        if (!g_SepAttachLVXml) {
			            g_SepAttachLVXml = "";
			        }
			        
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
			        var currIfrm = document.getElementById("ifrm" + allTabNum);
			        
			        if (rtn[0] == "TRUE") {
			            g_SepAttachLVXml = rtn[1];
			            currIfrm.contentWindow.SetDocumentElementForDraftAll("sepattachlvxml", g_SepAttachLVXml);
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

   			        if (useOpenGov == "YES") {
                        parameter[52] = basis;
                        parameter[53] = reason;
                        parameter[54] = listOpenFlag;
                        parameter[55] = fileOpenFlagList;
   					}

   			        if (tempItemCode != "")
   			            tempdocnumcode = tempItemCode;
   			        
   			     	parameter[61] = tempKeyword;
                       
                    // ezapprovalinfo_dialogArguments[0] = parameter;
   		         	// ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;

   		            // var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp" + "&formID=" + pFormID, "ezApprovalInfo", GetOpenWindowfeature(1210, 750));
   		            // try { OpenWin.focus(); } catch (e) { }
					ezCommon_cross_dialogArguments[0] = parameter;
					showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp" + "&formID=" + pFormID, 1210, 750, "ezApprovalInfo", GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
				}
			    
			    function btnApprovalInfo_Complete(ret) {
					hidePopup();
   			        if (ret != undefined && ret[0] == "OK") {
   			            try {
   			                if (pGubun != "5" && pGubun != "7" && pGubun != "10") {
   			                    if (ret[1] != false) {
   			                    	$.ajax({
   			                    		type : "POST",
   			                    		dataType : "json",
   			                    		async : false,
   			                    		url : "/ezApprovalG/aprLineSave.do",
   			                    		data : {
   			                    				ret    : ret[1]
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
   			                    setRecevInfo(ret[3]);
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

   							//2020-05-08 : 결재정보확인 시 문서정보 저장 후 문서 반영
   							setApprDocInfo();	
							// 2022-02-04 박기범 : 결재정보 > 확인 후에 한글문서는 저장되지 않던 문제 수정
							GetHTML(before_SaveFile);

							SummaryFlag = true;
   			                savexmlhttp = null;
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
		    	
		    	// 웹 한글 기안기용 (각 안별 iframe에서 부모창의 함수를 동작시킴)
	 	    	function Editor_Complete(iframeID, docHref) {
		    		var iframe = document.getElementById(iframeID);
		    		
		    		if (iframe == null || typeof(iframe) == "undefined") {
		    			return;
		    		}
		    		
		    		var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(docHref);
	                iframe.contentWindow.Open(URL, "", "", function (res) {iframe.contentWindow.FieldsAvailable(res.result);}, null);
		    	}
		    	
		    	/*
		    	// 일괄기안문서는 통합PC저장 불가능
		    	// 통합 PC 저장 시작
		    	var totalsavefileinfo_dialogArguments = new Array();
			    function TotalSave_onclick() {
			        totalsavefileinfo_dialogArguments[0] = "";
			        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
			
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
			 */
			 
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
			 
	    	function ShowMailProgress() {
	    		var CurrenWidth = document.documentElement.clientWidth;
	    		
	            document.getElementById("mailPanel").style.display = "";
	            document.getElementById("loadingProgress").style.top = "600px";
	            document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
	            document.getElementById("loadingProgress").style.display = "";
		    }
	    	
		    function HiddenMailProgress() {
		    	document.getElementById("mailPanel").style.display = "none";
	        	document.getElementById("loadingProgress").style.display = "none";
		    }
			 
	    	/************************* 일괄기안 전용 함수 ***************************/	
	    	
	    	// 각 안별 탭 생성
	    	function makeTabs() {
                ShowMailProgress();
                
                var viewTabCnt = pDocIDAry.length - 1; // 임시저장된 문서 갯수만큼 탭을 만들어줄 예정이므로, 변수는 미리 설정해뒀음 (안 갯수는 0번배열 제외하기 위해 -1처리)
                
                for (var i = 1; i <= viewTabCnt; i++) {
                    var viewNewTabCnt = Number(i); // 1안부터 시작
                    
                    // 탭의 요소 길이 자체는 0부터 시작하게 되며, 루프를 진행하면서 1, 2... 로 증가한다.
                    var viewTabIdx = viewNewTabCnt; // 최초 루프 시 0 -> 1로 현재 탭 인덱스 증가
                    
					var addString = "";
					if (viewTabIdx == 1) { // 1안인 경우, 선택된 상태로 스타일 처리
                        $("dl.tab_menu").append("<dt class=\"on\" id=\"dt" + viewTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + viewTabIdx + "')\"  id=\"sp" + viewTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
                        addString = "<div class=\"tab_content\" id=\"tab" + viewTabIdx + "\" style=\"height:0px; overflow:visible;\"> ";
					}
                    else {
                        $("dl.tab_menu").append("<dt id=\"dt" + viewTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + viewTabIdx + "')\"  id=\"sp" + viewTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
                        addString = "<div class=\"tab_content\" id=\"tab" + viewTabIdx + "\" style=\"height:0px; overflow:hidden;\">";
                    }

					// formID는 자식 프레임에서 process_AfterOpen() > getApprovInfo() 등으로 알아서 가져오게 된다. 안 넘겨줘도 됨

					var iframeURL = (extAry[i] == "mht" ? "/ezApprovalG/approvUIcontent.do" : "/ezApprovalG/approvContentAll_WHWP.do") + "?frameNum=" + viewTabIdx + "&docHref=" + encodeURI(pDocHrefAry[viewTabIdx]) + "&docID=" + encodeURI(pDocIDAry[viewTabIdx]);
					addString = addString + "<iframe name=\"ifrm" + viewTabIdx + "\" id=\"ifrm" + viewTabIdx + "\" style=\"width:100%; height:" + wh + "px; border:0px\" onload=\"getReSize()\" src=\"" + iframeURL + "\"></iframe></div>";
					
                    $("div.tab_container").append(addString);
                    HiddenMailProgress();
                }
	        }
	    	
	        // 안별 탭 선택 (objNum는 선택한 탭의 인덱스)
	        function selTab(objNum) {
	            $("dl.tab_menu dt").removeClass("on"); // 기존 탭 활성화 모두 제거
	            $("#dt" + objNum).addClass("on"); // 현재 선택한 탭 활성화

//	            $("div.tab_content").attr("style", "display:none"); // 생성된 iframe 영역을 전부 안보이게 처리
//	            $("#tab" + objNum).attr("style", "display:block"); // 현재 선택한 탭의 iframe을 보이게 함
	            $("div.tab_content").css("overflow", "hidden");
	            $("#tab" + objNum).css("overflow", "visible");

	            currentTabIdx = objNum; //현재 선택된 탭 인덱스 변경
	            
	            // 현재 선택한 탭의 배열 데이터를 부모 파라미터로 사용
	            setTabInfo(objNum);
	            
	        	// 선택한 안의 첨부파일정보를 표출
	            document.getElementById("attachFileTR").style.display = ""; // 숨겨둔 첨부파일영역 표출
	            setAttachInfo(pDocIDAry[objNum], "APR", lstAttachLink);
	        }
	        
	        function setTabInfo(setNum) {
        		if (setNum) { // 주어진 번호가 있다면 바로 사용
        			currentTabIdx = setNum;
        		} else { // 아니라면 현재 활성화된 탭에서 가져옴
        			currentTabIdx = $("#container").find("dt.on").attr("id").replace("dt", "");
        		}
        		
        		HwpCtrl = document.getElementById("ifrm" + currentTabIdx).contentWindow.HwpCtrl; // 웹한글기안기 내부 컨트롤에 접근
        		lstAttachLink = document.getElementById("lstAttachLink");
        		
        		SignInfo = undefined2EmptyString(SignInfoAry[currentTabIdx]);
        		pFormID = undefined2EmptyString(pFormIDAry[currentTabIdx]);
        		pDocID = undefined2EmptyString(pDocIDAry[currentTabIdx]);
        		hapyuiCount = undefined2EmptyString(hapyuiCountAry[currentTabIdx]);
        		SignCount = undefined2EmptyString(SignCountAry[currentTabIdx]);
        		gamsaCount = undefined2EmptyString(gamsaCountAry[currentTabIdx]);
        		pSuSinFlag = undefined2EmptyString(pSuSinFlagAry[currentTabIdx]);
        		btnReceivLineEnable = undefined2EmptyString(btnReceivLineEnableAry[currentTabIdx]);
        		pDocHref = undefined2EmptyString(pDocHrefAry[currentTabIdx]);
        		pHasAttachYN = undefined2EmptyString(pHasAttachYNAry[currentTabIdx]);
        		pHasDocAttachYN = undefined2EmptyString(pHasDocAttachYNAry[currentTabIdx]);
        		pHasOpinionYN = undefined2EmptyString(pHasOpinionYNAry[currentTabIdx]);
				
				SummaryOuterReceiverList = undefined2EmptyString(SummaryOuterReceiverListAry[currentTabIdx]);
   		        fileOpenFlagList = undefined2EmptyString(fileOpenFlagListArr[currentTabIdx]);
   		        
				pDocType = undefined2EmptyString(pDocTypeAry[currentTabIdx]);
				pDocTitle = undefined2EmptyString(pDocTitleAry[currentTabIdx]);
        	}
        	
        	function undefined2EmptyString(value) {
        		if (value == undefined) {
	        		return ""; 
        		} else {
	        		return value; 
        		}
        	}
        	
        	 // iframe 리사이즈 (1안이 존재하는 경우에만, 모든 안에 대하여 루프를 돌며 적용하므로 한번만 호출됨)
	        function getReSize() {
	            var ifrm1 = document.getElementById("ifrm1");
	            if (ifrm1 != null && typeof(ifrm1) != "undefined") {
	                var viewTabCnt = Number(allTabNum); // 모든 안의 갯수
	                
	                for (var i = 0; i < viewTabCnt; i++) {
	                    var viewTabNo = Number(i) + 1;
	                 //   var wh = window.innerHeight - 69;
	                 	var wh = window.innerHeight - 169; // 첨부파일영역 추가로 리사이즈 조정
	                    var Frame_name = document.all("ifrm" + viewTabNo);
	                    
	                    if (Frame_name != null && typeof(Frame_name) != "undefined") { // 각 iframe이 존재하면 높이를 셋팅
	                        Frame_name.style.height = wh + "px";
	                    }
	                }
	            }                       
	        }
        	 
        	 // 전달한 1안의 문서ID를 기준으로 가장 최신의 보류의견, 또는 반송의견을 각 안으로 복사하는 함수
        	 // pOpinionType -> OPINIONGB칼럼 : 001(일반), 002(반송), 003(보류), 004(회송) 
			function copyFirstTabOpinion(pGroupDocSN, pDocID, pOpinionType) {
				var result = "";
			    
			    $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/copyFirstTabOpinion.do",
					data : {
						docID : pDocID,
						groupDocSN : pGroupDocSN,
						opinionType : pOpinionType,
						orgCompanyID : orgCompanyID
					},
					success: function(xml) {},
					error : function () {}
				});
			}
			
			/* 2023-04-20 홍승비 - 일괄기안된 문서는 모든 안에 대해 결재선이 동일하므로, 부모창에서 한번만 호출 */
			function getLineModeAll(pDocID) {
				// 기본적으로 결재(APR)이나, 공통적으로 사용하는 함수이므로 명시적으로 pMode를 가져오도록 호출 (일괄기안문서는 결재완료 시 각 안이 분리됨)
				$.ajax({
		 			type : "POST",
		 			dataType : "text",
		 			async : false,
		 			url : "/ezApprovalG/getLineMode.do",
		 			data : {
		 					docID : pDocID,
		 					orgCompanyID : orgCompanyID
		 					},
		 			success : function(xml) {
		 				pModeForAllDocInfo = xml;
		 				pModeForAllAttachInfo = xml;
		 				
		 				if (docState == "017") { // 결재유형이 참조인 경우 추가 조정
			 				if (xml == "END") {
			 					pModeForAllDocInfo = "CHAMJOEND";
			 				} else {
			 					pModeForAllDocInfo = "CHAMJOAPR";
			 				}
		 				}
		 			},
		    		error : function (e) {
		    			console.log(e);
		    		}
				});
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
			    			mode : pModeForAllDocInfo,
			    			chamState : docState,
			    			orgCompanyID : orgCompanyID
			    		},
			    		success : function(xml) {
			    			result = xml;
			    			
			    			for (var i = 1; i < result.length; i++) { // [0] 인덱스는 미사용, [1]부터 사용
			    				pDocInfoAry[i] = result[i];
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
							mode : pModeForAllAttachInfo,
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

            function DocumentComplete(frame){
                frame.Set_EditorContentURL(pDocHrefAry[frame.name.substring(4)]);
            }

            function FieldsAvailable(frame) {
                try {
                    var frameName = frame.name;
                    var frameNum = frameName.substring(4);

                    frame.process_AfterOpen(frameNum);

                    // 현재 안 탭의 정보를 부모페이지에도 부여 (결과적으로는 로딩 완료 후 1안을 다시 선택하게 된다.)
                    setTabInfo(frameNum);
                    frame.setInitOpinion(frameNum); // 문서에 opinions 필드가 있는 경우, 각 안별 의견정보 셋팅 진행

                    // 부모창의 문서로딩완료 카운트를 하나 증가시킨다.
                    docLoadCompleteCnt ++;

                    // 로딩된 문서의 전체 갯수가 재기안 시작 시 가져온 전체 안의 갯수와 일치한다면, addFlag 등을 변경시킨다.
                    if (docLoadCompleteCnt == (pDocIDAry.length - 1)) {
                        titleOptionFlag = true;
                        contentOptionFlag = true;
                        attachOptionFlag = true;
                        docAttachOptionFlag = true;
                        seperateAttachOptionFlag = true;
                        opinionOptionFlag = true;
                        addFlag = true;

                        HiddenMailProgress(); // 전부 완료 시 로딩중 이미지 제거
                        CheckOpinionYN(1); // 모든 문서가 완료된 다음, 대표로 1안에 대해서만 의견 존재 여부를 확인하고, 레이어 팝업을 호출한다.

                        setTimeout(function() {
                            selTab(1); // 각 안을 전부 로딩한 뒤, 기본으로 1안을 선택하도록 한다.
                        }, loadTime);
                    }
                } catch (e) {
                    alert("apprGdraftuiAllContent_WHWP.FieldsAvailable()  ::  " + e);
                }
            }
            
            function getCheckNotFailDoc(docid) {
                var checkNotFailDoc = "";
                
                $.ajax({
                    type : "GET",
                    url : "/ezApprovalG/getCheckNotFailDoc.do",
                    dataType : "text",
                    async : false,
                    data : {
                        pDocID : pDocIDAry.toString()
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
	<body class="popup" style="overflow:hidden;" onbeforeunload="return window_onbeforeunload()" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                	<%-- 2022-06-30 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
	                    <ul id="AllApprove" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                        <li id="btnApprove"><span onclick="return btnApprove_onclick()"><spring:message code='ezApprovalG.t1'/></span></li>
	                        <li id="btnReject"><span onclick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
	                        <li id="btnStay"><span onclick="return btnStay_onclick()"><spring:message code='ezApprovalG.t50'/></span></li>
	                        <%-- 닷넷스펙 기준 일괄기안문서는 결재창에서 중간결재자가 결재정보의 변경이 불가능하도록 버튼을 막아둔 상태임 (차후 필요하다면 기능 구현 진행 필요) --%>
	                        <li style="display: none" id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnJunKyul" style="display: none"><span onclick="return btnJunKyul_onclick()"><spring:message code='ezApprovalG.t25'/></span></li>
	                        <span style="display: none">
	                            <li id="btnModAprLine"><span onclick="return btnModAprLine_onclick()"><spring:message code='ezApprovalG.t52'/></span></li>
	                        </span>
	                        <%-- 실제로 사용되지 않는 버튼 정리 --%>
<%-- 	                        <span style="display: none">
	                            <li id="btnModAprDept"><span onclick="return btnModAprDept_onclick()"><spring:message code='ezApprovalG.t53'/></span></li>
	                        </span> --%>
	                        <%-- 일괄기안문서는 도중 편집 불가능 --%>
	                        <%--
	                        <li id="btnEdit"><span onclick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
	                        --%>
	                        <span style="display: none">
	                            <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        </span>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
	                        <li id="btnAddSepAttach"<c:if test="${approvalFlag eq 'S'}"> style="display:none"</c:if>><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSave" style="display:none"><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <%-- 일괄기안문서는 결재진행 도중 문서저장 불가능 --%>
	                        <li id="tbtnTotalSave" style="display: none"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
	                        <li id="btnMail" style="display:none"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
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
	
		<%-- 각 웹에디터 파트는 content 페이지로 이동 --%>
		<%-- 버튼 하단 안별 탭 영역 --%>
			<tr>
			    <td  style="height:86%;vertical-align: top;" >
			    	<div id="container">        
	        			<div class="tab_menuBox contentlist_layout">
	            			<dl class="tab_menu" >              
	            			</dl>
	        			</div>
	        			<div class="tab_container" style="margin-top:5px;"> 
	        			</div>
	    			</div>
			    </td>
			</tr>
			
	        <tr id="attachFileTR" style="display:none;">
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style=" width:30%;">
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
		<%-- 로딩 이미지 표출 영역 --%>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
        	<img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
    	</div>
	</body>
</html>
