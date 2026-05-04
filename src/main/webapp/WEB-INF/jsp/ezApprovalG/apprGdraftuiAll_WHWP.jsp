<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>
            <spring:message code='ezApprovalG.HSBDa01'/>
	    </title>
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

		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draftG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberGAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDraftAll_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
<%-- 		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script> --%>
	    <script type="text/javascript">
	        var FormHref = "<c:out value ='${formURL}'/>";
	        var DraftFlag = "<c:out value ='${draftFlag}'/>";
	        var DocType = "<c:out value ='${formDocType}'/>";
	        var SusinSN = "<c:out value ='${susinSN}'/>";
	        var DocState = "<c:out value ='${docState}'/>";
	        var ListType = "<c:out value ='${listType}'/>";
	        var AprState = "<c:out value ='${aprState}'/>";
	        var pEndDocHref = "<c:out value ='${dirPath}'/>";
	        var pFormHref = new String();
	        var pFormID = new String();
	        var pDocID = new String();
	        var CurrentDate
	        var flag = false;
	        var fieldflag = false;
	        var xmluserInfo = createXmlDom();
	        var xmlhttp = createXMLHttpRequest();
	        var SignCount = 0;
	        var hapyuiCount = 0;
	        var gongramCount = 0;
	        var gamsaCount = 0;
	        var SignInfo = "";
	        var SignInfoFlag = true;
	        var pDraftFlag;
	        var pSuSinFlag;
	        var pChamJoFlag;
	        var pSusinSN;
	        var pDocType;
	        var pDocState;
	        var pOrgDocID;
	        var pOrgHtml;
	        var pReadPC = false;
	        var DeptSymbol;
	        var IsSkipDrafter;
	        var badForm = false;
	        var AppendFileAttach = "";
	        var AppenAprDocAttachList = "";
	        var pPublic = "P";
	        var drafterDeptid
	        var docdir = "";
	        var pDocTitle;
	        var pMaxFileSize = '5';
	        var isExtDoc = "N";
	        var isTmpDocID = "<c:out value ='${isTmpDoc}'/>";
	        var gPublic = "";
	        var draftFlag = false;
	        var btnSendDraftEnable = "false"
	        var LastSignNo;
	        var TempsaveAprlineinfo;
	        var pCCType = "0";
	        var pLCatalogue = "";
	        var pMCatalogue = "";
	        var pperiod = "";
	        var pLClass = "";
	        var pMClass = "";
	        var pLCasn, pMCasn, pPer, pLClsn, pMClsn;
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";
	        arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";
	        arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";
	        arr_userinfo[4] = "<c:out value ='${userInfo.deptID}'/>";
	        arr_userinfo[5] = "<c:out value ='${userInfo.deptName}' escapeXml='false'/>";
	        arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}' escapeXml='false'/>";
	        arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}' escapeXml='false'/>";
	        var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
	        var pUserID = arr_userinfo[1];
	        var KuyjeType = "002";
	        var signDateFormat = "<c:out value ='${optSignDateFormat}'/>";
	        var isSplit = "<c:out value ='${optIsSplit}'/>";
	        var SplitKind = "<c:out value ='${optSplitKind}'/>";
	        var sihangURL = "<c:out value ='${sihangURL}'/>";
	        var CurAprType = "";
	        var NextAprType = "";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "";
		    var pSummaryPath = "";
	        var pLimitRange = "", pPageNum = "1";
	        var cabinetID = "";
	        var TaskCode = "";
            var keepperiod = "";
	        var DocNumCode = "";
	        var SummaryFlag = false;
	        var btnReceivLineEnable = false;
	        var SignType = new Array();
	        var SignName = new Array();
	        var SignContent = new Array();
	        var CheckGubun = "1";
	        var HapyuiArea = 0;
	        var AprLineArea = 0;
	        var DocSN = "<c:out value ='${docSN}'/>";
	        var AutoSave = "";
	        var Saveflag = false;
	        var pUse_Editor = "<c:out value ='${useEditor}'/>";
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
	        var SummaryOuterReceiverList = "";
	        var g_szUserID = arr_userinfo[8];
	        var g_senderinfo = "<c:out value ='${userInfo.companyName}'/>" + ", " + "<c:out value ='${userInfo.deptName}'/>" + ", " + "<c:out value ='${userInfo.title}'/>";
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var isHWP = "<c:out value ='${isHWP}'/>";
	        var ext = "hwp";
	        //var nonElecRec = "<c:out value ='${nonElecRec}'/>";
	        //var nonElecRecInfoXml = "", nonSepAttachLVXml = "", sepAttachCheckYN = "";
	        var useReceiveDocNo = "<c:out value ='${useReceiveDocNo}'/>";
	        var orgCompanyID = "<c:out value='${userInfo.companyID}'/>";
	        var docNumZeroCnt = "<c:out value ='${docNumZeroCnt}'/>";
	        // 기존 기안창 내부의 양식선택 기능 관련. 필요없음
/* 			var isUsed = "<c:out value ='${isUsed}'/>";
			var beforeDocID = "<c:out value ='${beforeDocID}'/>";
			var beforeUrl = "<c:out value ='${beforeUrl}'/>"; */
			var apprReuseConfig = "<c:out value='${apprReuseConfig}' />";
			//원문정보공개
			var useOpenGov = "<c:out value='${useOpenGov}' />";
			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			var newpDocID = "";
	        var useRedraftOpinionKeep = "<c:out value='${useRedraftOpinionKeep}'/>";
	        var formAprOption = "<c:out value='${formAprOption}'/>";
	        var passAprLine = "";
	        var rtnSignInfo = [];
	        var useWebHWP = "<c:out value ='${useWebHWP}'/>";
	        
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
	        
	        // 외부수신처 그룹관리용
			var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>";
			
			// 일괄기안 관련
			var draftAllFlag = "Y";
			var DocSN = "<c:out value ='${docSN}'/>";
			var groupDocSN = "<c:out value ='${groupDocSN}'/>"; // 임시저장 또는 재기안된 문서가 가지는 TBL_APRDOCGROUPINFO의 GROUPDOCSN값
	        var DocSNAry = new Array();
			var pFormHrefAry = new Array();
	        var pFormID = new String();
	        var pFormIDAry = new Array();
	        var pSuSinFlagAry = new Array();
	        var pDocID = new String();
	        var pDocIDAry = new Array();
	        var newpDocIDAry = new Array(); // 임시저장 반복 시 새롭게 부여되는 문서ID
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
	        
			var htmlDataAry = new Array(""); // 웹한글기안기의 GetHTML 함수가 비동기로 동작하므로, 이 배열에 가져온 data를 넣어준다. ( 1안부터 시작하기 위해 인덱스 0의 값은 임의로 "" 부여)
			var pOrgHtmlAry = new Array(""); // 기안 중 오류 발생 시 원래 문서로 돌려주기 위한 데이터 저장 배열. 기본적으로 htmlDataAry값과 동일하다.
			
			// 일괄기안을 위하여 각 안마다 공통으로 사용되는 변수 부모창으로 이동함 (기존 ezDraftAll_WHWP.js 파일에 선언된 변수들)
			var lastKyulName, lastKyuljiwee, LastSignSN;
			var DraftLastFlag = false;
	        
			var maxTabNum = 10; // 이후 테넌트 컨피그로 뺄 수 있는 최대 추가 가능 안 숫자 (최대치는 항상 10)
			var currentTabIdx = 0; // 안별 탭 구분용 인덱스 (selTab 함수로 현재 선택된 탭 인덱스)
			var newTabIdx = 0; // 새로 추가한 탭의 인덱스 (가장 마지막으로 추가된 안의 탭)
			var viewTabNum = 0; // 실제로 보여지는 탭의 갯수(추가된 안 전체 갯수)
			var pMainDocID = new String(""); // 일괄기안 시 그룹ID (1안의 문서ID가 그룹ID = MAINDOCID가 된다.)
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
    		
    		var docMaxTabNumForDraft = 0; // 결재올림 동작 시, 전역변수로 사용하기 위한 총 안의 갯수 카운트
    		var docSaveCompleteCnt = 0; // 각 안의 문서들이 임시저장 완료되었는지 판단하기 위한 카운트 변수
    		var docLoadCompleteCnt = 0; // 각 안의 문서들이 로딩되었는지 판단하기 위한 카운트 변수
    		// 반송문서, 임시저장문서 재기안 > 초기 문서 로딩 시 사용하며, 초기 문서 로딩을 전부 완료한 후에는 더이상 카운트를 증가시키지 않는다.
    		
    		var docDraftInfoChkCnt = 0; // 결재올림 동작 시, 실제 결재올림 이전에 결재정보 체크가 정상 완료되었을 때 증가시킨다.
    		// 문서제목, 결재선, 수신자여부, 기록물철 등이 전부 정상일때마다 하나씩 증가시킨다.
    		// 결재동작 최초 체크 시 0으로 초기화한다. (오류 발생 시 return 되므로 -> 다시 결재올림 버튼을 클릭할때 초기화)
    		// 이 값이 최대 안의 갯수와 동일해졌을 때, 단 한번 결재암호체크 및 서명체크 동작을 진행한다.
    		
			var docDraftSignChkCnt = 0; // 결재올림 동작 도중, 각 안의 서명이 정상적으로 부여됐을 때 카운트를 증가시킨다.
			// 이 값이 최대 안의 갯수와 동일해졌을 때, GetHTML(saveDraftInfo)을 호출한다.
			
			var docGetHTMLCnt = 0; // 웹한글 함수의 비동기 html 리턴 동작에 대응하기 위한 전역변수 카운트.
			// 각 안의 html 데이터를 정상적으로 가져올때마다 하나씩 증가시킨다. 이 값이 최대 안의 값과 같아지는 경우에만 이후 동작을 진행한다.
    		
			var docDraftCompleteCnt = 0; // 각 안의 결재올림 동작이 완료되었을때 카운트를 증가시킨다.
			
			var delTabDocIDAry = new Array(); // 반송/회수문서의 재기안 시, 안삭제하는 경우 해당 문서를 삭제하기 위한 정보 배열
			var lowerSignCnt = 0; //  결재정보 호출 전, 모든 안의 양식을 체크하여 결재서명칸/합의서명칸의 갯수 중 가장 작은 값을 설정하기 위한 변수
			var lowerSignTab = 0;
			var lowerHapyuiCnt = 0;
			var lowerHapyuiTab = 0;
			
			/* 2023-04-20 홍승비 - 각 안별 탭 생성 및 웹에디터 로딩 이전, 순차실행이 보장되도록 결재문서 데이터를 가져와 각 안이 사용할 수 있게 분리 */
			var pDocInfoAry = new Array();
			var pAttachInfoAry = new Array();
			var pModeForAllDocInfo = "APR"; // 일괄기안 문서는 모든 문서가 결재선을 공통으로 사용
			var pModeForAllAttachInfo = "APR"; // 첨부파일 정보를 가져오기 위한 pMode값 분리
			var SendName = "";

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = '${useAprFilePrvw}';

			var parameters;
			var attachedDocList;

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var orgCompanyID_ = "<c:out value = '${orgCompanyID}'/>";
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";

			// 창마다 고유한 id 지정용
			var windowUuid = getRandomId();

            var isPreview = "<c:out value ='${isPreview}'/>";

    		// 일괄기안문서를 재기안하는 경우, 기존 문서와 양식 등의 정보를 배열에 부여
    		$(document).ready(function() {
                pDraftFlag = DraftFlag; // 모든 문서 공통이므로 ready 시 바로 부여
                
                getDraftUserInfo(); // 기안자 정보
    			SendName = getDeptSendName(arr_userinfo[4]); // 부서발신명의
                
				if (DraftFlag == "REDRAFT" && !reDraftFlag) {
					// 1안을 의미하는 [1] 인덱스 부터 배열 데이터가 들어가도록, [0]에는 공백 데이터를 부여함
					DocSNAry.push("");
					pDocIDAry.push("");
					pFormHrefAry.push("");
					pDocTypeAry.push("");
					extAry.push("");

	        		// 임시저장 또는 반송 후 재기안 문서 (안 번호는 ASC 정렬된 상태로 1안부터 전달됨)
                	<c:forEach items="${groupDocInfoList}" var="item">
                		DocSNAry.push("${item.docID}");
                		pDocIDAry.push("${item.docID}");
	        			pFormHrefAry.push("${item.docHref}"); // 문서경로
	        			pDocTypeAry.push("${item.docType}");
	        			extAry.push("${item.docHref}".substring("${item.docHref}".lastIndexOf(".") + 1)); // 확장자
	        		</c:forEach>
	        		
	        		reDraftFlag = true;
	        		
	        		/* 2024-02-05 김우철 - 임시저장을 위해 결재문서 데이터를 가져오는 방식 수정 */
	        		if (ListType != "21") {
	        			getLineModeAll(pDocIDAry[1]);
	        			getDocInfoAll(pDocIDAry);
	        			getAttachInfoAll(pDocIDAry);
	        		}
        			
	        		makeTabs(); // 기존 pDocIDAry에 문서정보가 있는 경우(재기안 시), 각 문서의 안을 만들어준다.
                }
			});
	        
	        window.onload = function () {
	            try {
					if (opener != null && opener.getformcont_cross_dialogArguments != null) {
						parameters = opener.getformcont_cross_dialogArguments[0];
					}

	                pSusinSN = SusinSN;
	                dragNdrapNo();
	                
	                IsSkipDrafter = "FALSE"
	                DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
	                drafterDeptid = arr_userinfo[4];
	                getDraftInfo();
	                
	      			 // draftInfo로 정보 부여 후 일괄기안 정보 배열에 데이터 추가
	                pFormHrefAry[0] = FormHref;
	                pDocTypeAry[0] = pDocType;
	                
					// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가 (모든 안 공통)
					setAttachGuideText();

					if (parameters != undefined && parameters.length != 0) {
						extractParameters();
					}
	            } catch (e) {
	                alert("ezdraftui_hwp.window.onload::" + e);
	            }
	        }

			function extractParameters() {
				attachedDocList = parameters[0] == null ? "" : parameters[0];	// 첨부기안 대상 리스트
			}
	
	       	window.onresize = function () {
			getReSize();
			// 자식 iframe은 자기 자신을 리사이즈 할수 없으므로, 부모창에서 대신 조절함
				$(".tab_container").find("iframe").each(function(index, item) {
					this.contentWindow.Resize();
				});
	        }
	       	
	        function dragNdrapNo() {
	            try {
	                var div = document.getElementById("lstAttachLink");
	                div.ondragenter = div.ondragover = function (e) {
	                    return false;
	                }
	                
		            div.ondrop = function (e) {
		                alert("<spring:message code='ezApprovalG.pjj30'/>");
		                return false;
		            }
		            
                    var div2 = document.getElementById('lstAttachLinkDoc');
                    div2.ondragenter = div.ondragover = function (e) {
		                return false;
		            }
		            
		            div2.ondrop = function (e) {
		                alert("<spring:message code='ezApprovalG.noDrag.jih01'/>");
		                return false;
		            }
		            
		            var html = document.getElementsByTagName('html')[0];
		            html.ondragover = function (e) {
		            	if (e.target.id == 'lstAttachLink' || e.target.id == 'lstAttachLinkDoc') { return false; }
		            	
		            	e.dataTransfer.dropEffect = "none";
				        e.stopPropagation();
				        e.preventDefault();
		            }	
	            } catch (e) {
	                alert("apprGdraftuiAllContent_WHWP.jsp > dragNdrapNo()::" + e.description);
	            }
	        }
	
			function openForm() {
			    openFormUI();
			}
			
			// 의견 존재 체크 및 레이어팝업 표출용 함수 분리
		    function CheckOpinionYN(currIdx) {
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
		    
			// getDraftUserInfo()의 호출은 부모 페이지에서 단 한 번만 호출되도록 한다. SetAutoPropertyValue()함수는 자식 iframe으로 이동시켰음
			/*
			function setAutoProperty() {
			    getDraftUserInfo();
			    SetAutoPropertyValue();
			}*/
	
			function btnSelForm_onclick() {
/* 				if(nonElecRec == "Y") {
			    	return;
			    } */
				var check = Form_check();
			    if (check == "OK")
			        openForm();
			}
	
			function btnSetAprLine_onclick() {
			    try {
			        var ret;
			        ret = openAprLineUI();
			        TempsaveAprlineinfo = ret[0];
			
			        if (ret[3] != "" && ret[3] != "cancel")
			            pPublic = ret[3];
			
			        if (ret[0] != "cancel" && ret[3] != "cancel") {
			            IsSkipDrafter = "FALSE";
			            btnSendDraftEnable = "true";
			            GetDraftAprLineInfo(ret);
			            return true;
			        } else {
			            if (ret[2] == "cancel") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t127'/>";
			                OpenAlertUI(pAlertContent);
			            }
			        }
			        
			        return false;
		        } catch (e) {
		            alert("apprGdraftuiAll_WHWP.jsp > btnSetAprLine_onclick()::" + e.description);
		        }
			}
	
	        function btnSetReceivLine_onclick() {
	            try {
	                var ret = openReceivUI();
	
	                if (ret != "cancel") {
	                    btnReceivLineEnable = false;
	                    setRecevInfo(ret);
	                }
	            } catch (e) {
	                alert("apprGdraftuiAll_WHWP.jsp > btnSetReceivLine_onclick()::" + e.description);
	            }
	        }
	
	        var sendDraftResultAry = new Array();
	        var ingFlag = false;
	        function btnSendDraft_onclick() {
	        	if (!btnChk()) {
					return false;
				}
	            if (ingFlag) {
                    return;
                }
	            
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
				if (deptCheckFlag == "3") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 기안창을 새로 띄워주시기바랍니다." );
					return;
				} else if (deptCheckFlag == "4") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 기안창을 새로 띄워주시기바랍니다.");
					return;
				} else if (deptCheckFlag == "2" && upperDeptCode == "") {
					alert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}	
				
				// 일괄기안에 대응하도록 루프 진행
				var ret = "";
				docMaxTabNumForDraft = pDocIDAry.length -1; // 0번 인덱스 제거, 1안부터 기안 진행하도록 전역변수 셋팅
				docDraftInfoChkCnt = 0; // 각 안 별 결재정보 체크 카운트 전역변수 초기화
				docDraftSignChkCnt = 0; // 각 안 별 서명부여 체크 카운트 전역변수 초기화
				docDraftCompleteCnt = 0; // 각 안 별 기안성공 카운트 전역변수 초기화
				docGetHTMLCnt = 0; // 각 안 별 웹한글HTML 데이터 가져오기 성공 카운트 전역변수 초기화
				htmlDataAry = [""]; // 각 안 별 웹한글HTML 데이터 저장 배열 초기화
				pOrgHtmlAry = [""]; // 오류발생 시 이전 문서로 되돌리기 위한 HTML 데이터 저장 배열 초기화 
				pDocNumCodeAry = [""]; // 각 안 별 문서번호 저장 배열 초기화
				pDocNumSnAry = [""]; // 각 안 별 문서번호 숫자부분(tempNumString) 저장 배열 초기화
				
				beforeSendDraft();
				
				// 결재올림 이전의 결재정보 체크 (결재선, 문서제목, 수신처 정상여부 등 판별) 동작은 루프를 돌면서 비동기적으로 진행한다.
				// 단, 암호체크 및 서명선택 동작은 단 한번만 동작하도록 한다. (모든 체크가 끝난 뒤, 카운트를 확인하여 호출)
				for (var i = 1; i <= docMaxTabNumForDraft; i++) {
					var pDraftDocID = pDocIDAry[i];
					var result = "";
					
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/getExtTotalAttachSize.do",
			    		data : {
			    			docID : pDraftDocID
			    		},
			    		success: function(text) {
			    			sendDraftResultAry[i] = text; // 인덱스 접근을 위해 배열로 관리
			    		}
			    	});
			    	// 본문의 용량을 구하기 위함 2018-07-13
			    	GetHTML2(sendDraft, i, docMaxTabNumForDraft); // 웹한글 비동기 함수에 호환되도록 반드시 인덱스 사용
				}
	        }

			// 2025-02-06 박기범 - #154451 -> 일괄 기안 전에 웹한글 내부함수 GetTextFile 실행시, 
			// display none 되어있는 창은 마우스 클릭이 툴바가 없는 것을 기준으로 클릭되는 버그가 생김. 웹한글 내부함수에서 
			// 클릭 이벤트를 생성시 디스플레이된 스크롤바의 높이를 측정하여 부여하는것으로 추측됨.
			// 현재 활성화된 창 외에 diplay를 잠시 복구한뒤 과정이 모두 끝나고 다시 감춤(리사이즈시 문제 방지)
			function beforeSendDraft() {
				var curTab = document.getElementById("tab" + currentTabIdx);
				var cont = document.querySelector("#container > .tab_container");
				// 현재 창 높이로 고정.
				cont.style.height = curTab.offsetHeight + 'px';
				cont.style.overflow = 'hidden';
				// 현재 선택된 탭을 제일 위쪽 위치로 고정
				cont.style.display = 'flex';
				cont.style.flexDirection = 'column';
				curTab.style.order = 1;
				cntGetTextFile = 0;
				// 다른 창들을 감춰진 아래쪽 영역에 표출
				for (var i = 1; i <= docMaxTabNumForDraft; i++) {
					var targetTab = document.getElementById("tab" + i);
					targetTab.style.display = 'block';
					if (currentTabIdx != i) {
						targetTab.style.order = 2;
					}
				}
			}
			
			var cntGetTextFile = 0;
			function afterGetTextFileInSendDraft(currIdx) {
				cntGetTextFile++;
				if (currentTabIdx != currIdx) {
					// GetTextFile가 완료된 탭은 다시 감춤
					document.getElementById("tab" + currIdx).style.overflow = "hidden";
				}
				if (docMaxTabNumForDraft == cntGetTextFile) {
					// 모든 GetTextFile가 실행되면 컨테이너 높이 원복. 원복하지 않으면 창크기변경시 컨테이너가 변하지 않음.
					document.querySelector("#container > .tab_container").style.height = '';
				}
			}

			function sendDraft(strClone, currIdx, maxIdx) {
				afterGetTextFileInSendDraft(currIdx);
	        	var currIfrm = document.getElementById("ifrm" + currIdx); // 각 안별 웹한글기안기 iframe을 사용
	        	var strBytes = parseInt(getByteLength(strClone));
		    	var rtnAttachXML = loadXMLString(sendDraftResultAry[currIdx]);
                var attachTotalSize = getNodeText(rtnAttachXML.getElementsByTagName("TOTALSIZE").item(0));

                if (pDraftFlag == "REDRAFT" && approvalFlag == "S" && ListType != "21" && currIdx == 1) {
                    var result = "";
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        url : "/ezApprovalG/checkAprState.do",
                        data : {
                            docID : pDocIDAry[1],
                            docState : DocState,
                            userID : '',
                            aprMemberSN : 1,
                            orgCompanyID : orgCompanyID
                        },
                        success : function(text) {
                            result = text;
                        }
                    });
                    if (result == "FALSE") {
                        alert("<spring:message code='ezApprovalG.bhs23'/>");
                        window.returnValue = "CLOSE";
                        window.close();
                        return;
                    }
                }

                // 1안의 첨부정보가 안추가 시 외부시행문으로 복사되더라도, 해당 알러트에서 체크해준다.
                // 외부시행문이 외부 수신처를 가지는 경우에만 체크한다. (수신자가 회사 내부 조직도만 존재한다면 첨부용량을 따지지 않는다.)
                if (getNodeText(rtnAttachXML.getElementsByTagName("FLAG").item(0)) == "Y") {
                	HiddenMailProgress();
                    OpenAlertUI("외부발송문서 총 첨부용량은 최대 6MB 입니다." + "<br>" + currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "첨부용량을 줄여주시기 바랍니다.");
                    return;
                }
                // 본문과 첨부파일의 총합이 7.4mb가 초과시 알러트 2018-07-13 강민수92
                if (getNodeText(rtnAttachXML.getElementsByTagName("EXTFLAG").item(0)) == "Y" && strBytes + parseInt(attachTotalSize) > 7400000) {
                	HiddenMailProgress();
                	OpenAlertUI("외부발송문서 총 용량은 최대 7.4MB 입니다." + "<br>" + currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "첨부파일이나 본문용량을 줄여주시기 바랍니다.");
                    return;
                }

                bAttachProcess = false;

                if (currIfrm.contentWindow.GetDocumentElementForDraftAll("WORKFLOW", true)) {
                    var rtn = checkValidation();
                    if (rtn == "FALSE") {
                    	HiddenMailProgress();
                        return;
					}
	            }
                
				var Fields = currIfrm.contentWindow.GetFieldList(0, 1);
				var tempFields = currIfrm.contentWindow.GetFieldList(0, 1);

				tempFields = Fields.reduce(function(tempArr,curr,index) {
					tempArr.indexOf(curr) > -1 ? tempArr : tempArr.push(curr);
					return tempArr;
				},[]);

				if (Fields.length !== tempFields.length) {
					HiddenMailProgress();
					OpenAlertUI("동일한 Field가 존재합니다. " + currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "문서를 다시 확인해주세요.");
					return;
				}
	            if (currIfrm.contentWindow.FieldExist("doctitle")) {
	                pDocTitle = trim(currIfrm.contentWindow.GetFieldText("doctitle"));
	            } else {
	                pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
	            }
                if (pDocTitle == "") {
                    var pAlertContent = currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "<spring:message code='ezApprovalG.t1395'/>";
                    HiddenMailProgress();
                    OpenAlertUI(pAlertContent);
                    return;
                }
                if (pDocTitle.length > 127) {
                    var pAlertContent = currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "<spring:message code='ezApprovalG.t132'/>";
                    HiddenMailProgress();
                    OpenAlertUI(pAlertContent);
                    return;
                }
                
				// 정상적인 문서제목이 존재한다면, 문서제목 배열에 각 안의 문서제목을 삽입
	            pDocTitleAry[currIdx] = pDocTitle;
                
                if (btnSendDraftEnable == "false") {
                	var pAlertContent = "";
	            	// 결재선 확인하라는 메세지 출력, 모든 안 공통이므로 안 특정 없이 공통으로 표출
	            	if (pDraftFlag == "REDRAFT") {
						pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
	            	} else {
	                    pAlertContent = "<spring:message code='ezApprovalG.t1398'/>" + "<br>" + "<spring:message code='ezApprovalG.t1399'/>";
	            	}
	            	
	            	HiddenMailProgress();
	            	OpenInformationUI(pAlertContent, check_btnSendDraft2);
                    return;
                }
                
                if (!checkLines()) { // 현재 결재선이 정상인지 체크 (결재선상의 사원 정보가 달라진 경우 알러트 표출 등의 동작)
                	HiddenMailProgress();
                    return;
                }
                // 수신문인데 수신처가 설정되지 않은 경우 (결재정보창 내부에서도 한번 확인함)
                // 몇 안에서 설정이 안되었는지도 알려준다.
                if (pSuSinFlagAry[currIdx] == "Y" && !btnReceivLineEnableAry[currIdx] && pDocTypeAry[currIdx] != '002') {
                    var pAlertContent = currIdx + "<spring:message code='ezApprovalG.HSBDa04_1'/> " + "<spring:message code='ezApprovalG.t141'/>" + "<br>" + "<spring:message code='ezApprovalG.t142'/>";
                    HiddenMailProgress();
                    if (OpenInformationUI(pAlertContent)) {
                    	btnApprovalInfo(2);
                    }
                    return;
                }
                
                // 기록물철은 모든 안 공통이므로, 그냥 공통 알러트 메세지 사용
                if (cabinetID == "") {
                    var pAlertContent = approvalFlag == "G" ? "<spring:message code='ezApprovalG.t1397'/>" : "<spring:message code='ezApprovalG.t137'/>";;
                    HiddenMailProgress();
                    OpenInformationUI(pAlertContent, check_btnSendDraft3);
                    return;
                }

                if (!SummaryFlag) { // 결재정보를 한번이라도 지정했다면 SummaryFlag는 true값
                	HiddenMailProgress();
                    btnApprovalInfo(4);
                    return;
                }
                
                // 부모창이 아닌 각 안 내부(apprGdraftuiAllContent_WHWP.jsp)에서 이 함수를 불러야 한다.
                currIfrm.contentWindow.setDrafterAddress();
                
                if (pDraftFlag == "REDRAFT") {
                	delOpinionInfoForDraftAll(currIdx);
                	pHasOpinionYNAry[currIdx] = chkOpinionInfoExist(currIdx); // 의견삭제 후 의견갯수 카운트하여 플래그 변경
                }
                
                // 각 안의 문서번호를 재설정한다. (기산일에 따라 년도 등을 재설정)
                currIfrm.contentWindow.UpdateDocNum();
                
                // 각 결재문서 안별로 사전 체크 동작이 전부 완료된 경우, 암호체크와 서명동작을 단 한번만 실행시키도록 한다.
                docDraftInfoChkCnt ++; // 각 안별로 모든 결재정보 체크가 정상적으로 완료되었음 -> 카운트 하나 증가

                // 모든 안의 결재정보 체크가 완료되었다면, 최종 안 하나만 암호체크 + 서명선택한다.
                if (docDraftInfoChkCnt == maxIdx) {
					// 기안자 = 최종결재자 분기
	                if (LastSignSN == 1 || DraftLastFlag) {
	                    var pInformationContent = "<spring:message code='ezApprovalG.t143'/><br> <spring:message code='ezApprovalG.t144'/>";
	                    OpenInformationUI(pInformationContent, check_btnSendDraft4);
	                } else {
	                	// 기안자 != 최종결재자 분기
	                	CheckUsePassword();
	                }
                }
	        }
	        
			// GetHTML에서 비동기 웹한글함수의 동작 성공 시 콜백으로 이 함수를 부르게 된다.
	        // 실제로 결재문서를 물리적으로 저장하고, DB에도 데이터를 삽입하는 동작이 일어나는 부분이다.
	        // 여기에서 실패하면 관련된 전역변수(결재암호체크, 서명선택 등)의 값을 초기화해준다.
	        function saveDraftInfo() {
	        	if (docGetHTMLCnt < docMaxTabNumForDraft) {
	        		return;
	        	}
	        	// 최종 안에서 아래 동작이 단 한번만 동작하게 된다. 따라서 내부에서 루프를 돌린다.
				else {
					var rollBackFlag = false;
	        		
					for (var i = 1; i <= docMaxTabNumForDraft; i++) {
			        	var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
			        	
			        	// 일괄기안은 연동양식과 호환되지 않는다. 따라서 ExcuteInfo()는 전부 주석처리한다.
			        	/*
						var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
	                    var pAlertContent;
	                    if (!RtnVal) {
	                        return false;
	                    }
						*/
						
	                    // 기안자 = 최종결재자인 경우
	                    if (LastSignSN == 1 || DraftLastFlag) {
	                    	currIfrm.contentWindow.SetAutoPropFinal();
	                        /*
	                        var rtnVal = ExcuteInfo("LAST_SEND_BEFORE");
	                        if (!rtnVal) {
	                            return false;
	                        }
	                        */
	                    }
	
	                    // 자식창 iframe 전용 js를 쓰고 있어, 내부적으로 parent의 변수에 접근한다.
	                    RtnVal = currIfrm.contentWindow.SaveDraftDocInfo(i);
	                    if (RtnVal == "TRUE") {
	                    	/*
	                        RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
	                        if (!RtnVal) {
	                            return false;
	                        }
	*/
	                        if (LastSignSN == 1 || DraftLastFlag) { // 기안자 = 최종결재자
	                        	/*
	                            RtnVal = ExcuteInfo("DOCNUM_END");
	                            if (!RtnVal) {
	                                return false;
	                            }
	                            */
	                            docDraftCompleteCnt ++; // 각 안의 기안이 정상적으로 완료된 경우, 전역변수 카운트 증가
	                            
	                            // 최종 안까지 전부 기안완료된 경우 안삭제된 문서를 삭제
								if (docDraftCompleteCnt == docMaxTabNumForDraft && pDraftFlag == "REDRAFT" && ListType != "21") {
									removeDelTabDoc();
								}
	                            
	                            // 내부결재 완료 후 각 안 별 수신처로 알림메일을 보낸다.
								Gyuljedate = GetDocInfoDataForDraftAll("END", "STARTDATE", i);
								SendMailToReceiveDept(pDocTitleAry[i], arr_userinfo[2], Gyuljedate, pDocIDAry[i]);
	                        }
	                        else {
								docDraftCompleteCnt ++; // 각 안의 기안이 정상적으로 완료된 경우, 전역변수 카운트 증가
		                        
		                        // 일괄기안과 기결재통과기능 함께 사용 못함, 최종 안까지 전부 기안완료된 경우 한번만 메일발송 진행 (데이터는 1안 기준) + 안삭제된 문서를 삭제
								if (docDraftCompleteCnt == docMaxTabNumForDraft) {
									// 최종 안까지 전부 기안완료된 경우 안삭제된 문서를 삭제
									if (pDraftFlag == "REDRAFT" && ListType != "21") {
										removeDelTabDoc();
									}
									
									// 메일발송
									Gyuljedate = GetDocInfoDataForDraftAll("APR", "STARTDATE", i);
		                            CurrentAprType = "001";
			                        CurrentAprUserID = pUserID;
			                        
	                            	sendAlertMail("APR", 1, "DRAFTALL"); // 일괄기안용 메일알림분기 DRAFTALL 추가
								}
	                        }
	
							// 기존 UpdateLineHistory() 함수 일괄기안용 결재선 업데이트함수로 변경 (pDocIDAry에 접근)
	                        UpdateLineHistoryForDraftAll(i);
                        
                        	// 최종 안까지 전부 기안올림 성공 시 메세지 한번만 표출
                        	if (docDraftCompleteCnt == docMaxTabNumForDraft) {
	                        	pAlertContent = "<spring:message code='ezApprovalG.t146'/>"; // 문서를 [기안]하였습니다. 
	                        	HiddenMailProgress();
	                        	OpenAlertUI(pAlertContent, Complete_Draft2);
                        	}
                    	} else {
                    		// 오류 발생 시 자식 안에 접근하여 서명 제거 (하단의 개별 루프로 분리)
                    		rollBackFlag = true;
                    		break; // 현재 루프 빠져나가서 하단으로 이동
						}
					}
					
					// 기안정보 저장 시 오류가 발생한 경우, 모든 안에 대하여 롤백을 진행한다. (rtnSignInfo 배열을 파라미터로 전달함)
					// openSignUI_Complete(ret)에서 getDocNumberNew 함수로 각 안별 문서번호 맵핑을 전부 끝낸 상태이므로, 
					// 기안자 = 최종결재자 분기의 경우 모든 안에 대해서 롤백한다.
					if (rollBackFlag == true) {
						for (var i = 1; i <= docMaxTabNumForDraft; i++) {
							var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
							currIfrm.contentWindow.UndoSignInfo(rtnSignInfo);
	                		
	                        if (LastSignSN == 1) {
	                        	currIfrm.contentWindow.rollbackDocNumber(arr_userinfo[4], "", pDocIDAry[i], i);
	                        }
	                        
	                        if (LastSignSN == 1 || DraftLastFlag) {
	                        	/*
								RtnVal = ExcuteInfo("END_FAIL");
	                            if (!RtnVal) {
	                                return false;
	                            }
	                            */
	                        }
						}
                        pAlertContent = "[<spring:message code='ezApprovalG.t1400'/>";
                        HiddenMailProgress();
                        OpenAlertUI(pAlertContent);
						return false;
					}
				}
	        }
	        
	        // callback함수인 saveDraftInfo()로 이동하기 위한 함수. 인덱스는 해당 함수 내부에서 루프돌리기 때문에 필요없음
	        // isSkipDrafter가 TRUE인 경우, 또는 모든 안의 결재정보/결재암호 체크 및 서명부여동작이 완료된 경우 최종 안에서 딱 한번 호출된다. 따라서 내부에 루프를 만든다.
	        function GetHTML(callback) {
                ingFlag = true;
                
                // 내부에서 각 안 별로 iframe을 찾아 each루프를 돌려준다. 웹한글 비동기문제때문에 순차실행이 보장되지 않으므로 인덱스를 사용해야 함
				// 각 안 별로 GetHTML에서 한글파일 html data를 모두 가져오는 것에 성공한다면, 다음 단계로 넘어간다. 가져온 html data는 배열로 저장한다.
                var ifrms = $(".tab_container").find("iframe"); // == document.getElementById("ifrm" + i) 와 동일하다.
                ifrms.each(function(index, item) {
                	item.contentWindow.GetTextFile("HWP", "", function (data) {
                		ingFlag = false;
                		docGetHTMLCnt ++; // 웹한글 비동기함수 동작 정상 완료 시 카운트 증가
                		htmlDataAry[index + 1] = data; // html data 리턴받은것을 배열에 저장 -> 콜백함수 내부에서 이걸 사용한다. 
                		pOrgHtmlAry[index + 1] = data; // 오류 시 문서 원복을 위해 사용할 데이터
                		callback(); // saveDraftInfo() 콜백함수 호출
                	});
                });
	        }
	        
	        // sendDraft 함수는 결재정보 체크 등을 위한 함수이므로, 인덱스를 함께 전달함
	        // 콜백함수명, 현재 루프를 진행중인 안 인덱스, 전체 안의 갯수(모든 안의 결재정보 확인 카운트를 파악하기 위해 전달)
	        function GetHTML2(callback, currIdx, maxIdx) {
                ingFlag = true;
                document.getElementById("ifrm" + currIdx).contentWindow.GetTextFile("HWPML2X", "", function (data) { ingFlag = false; callback(data, currIdx, maxIdx); });
	        }
	        
		    function Complete_Draft() {
		        draftFlag = true;
		      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && typeof(parent.opener.getApprovalList) != 'unknown' && parent.opener.getApprovalList != undefined) { 
		        	parent.opener.clearAbsence(true);
		        }
		        //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가
/* 		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
		        	document.getElementById('message').contentWindow.document.getElementById('iframe_content').contentWindow.attitude_annual_conn("annual", "0");
		        }	    */     
		        
		        window.close();
		    }
		
		    // Complete_Draft2함수는 한번만 호출되므로, 내부에서 필요한 루프를 진행한다.
		    function Complete_Draft2() {
		        draftFlag = true;
		        
		        for (var i = 1; i <= docMaxTabNumForDraft; i++) {
			        if (ListType == "21") {
			            RemoveTmpDoc(DocSNAry[i]); // 임시저장된 문서를 기안완료한 경우, 임시저장된 *기존 데이터*를 삭제한다.
			            // 임시저장문서를 다시 임시저장한 경우, DocSNAry을 갱신하지 않으므로 해당 문서는 유지되며 가장 처음으로 재기안을 위해 접근한 그 임시저장문서가 기안된다.
			        }

			    	 // 일괄기안 그룹의 임시저장 레코드(TMP)를 지우고, 기안된 레코드(APR)로 다시 저장해준다. 기준이 되는 GROUPDOCID를 잘 전달해주도록 한다.
		 			// 임시저장을 여러번 반복한 뒤 기안을 올리는 경우, *맨 처음으로 접근한 해당 임시저장문서*가 기안이 올라가게 된다. 따라서 처음에 가져온 그룹ID랑 DOCID를 그대로 사용한다.
		 			// 반송문서 재기안 시에도 안삭제, 안추가 등에 대응하기 위해 기존 레코드를 전부 지우고 새롭게 넣어준다. (groupDocSN값 존재함)
			        saveAprGroupAndDelTmp(groupDocSN, pDocIDAry[i], pDocIDAry[1], i);
		        }
		        
		        // 리프레시 동작은 한번만 진행하면 된다.
		      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && typeof(parent.opener.getApprovalList) != 'unknown' && parent.opener.getApprovalList != undefined) {
		        	parent.opener.clearAbsence(true);
		        }
		        window.close();
		    }
	
	        function btnFileAttach_onclick() {
	        	try {
	        		if (!btnChk()) {
						return false;
					}
	        		
	                var ret = openFileAttachUI();
	            } catch (e) {
	                alert("apprGdraftuiAll_WHWP.jsp > btnFileAttach_onclick()::" + e.description);
	            }
	        }
	
	        function btnAprDocAttach_onclick() {
	        	if (!btnChk()) {
					return false;
				}
	        	
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
	        	if (deptCheckFlag == "3") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 기안창을 새로 띄워주시기바랍니다." );
					return;
				} else if (deptCheckFlag == "4") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 기안창을 새로 띄워주시기바랍니다.");
					return;
				}	
	        
	            var ret = openAaprDocAttachUI();
	        }
	
	        function btnOpinion_onclick() {
	        	if (!btnChk()) {
					return false;
				}
	        	
	        	openOpinionUI_New("");
	        }
	
/* 	        function btnSave_onclick() {
	        	var hwpDoctitle = message.GetFieldText("doctitle").replace(/\r\n/g, " ");
	        	
	        	if (hwpDoctitle == "") {
	        		var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
                    OpenAlertUI(pAlertContent);
	        		message.MoveToField("doctitle");
	        		return;
	        	}
	        	
	        	hwpDoctitle += ".hwp";
	            message.SaveFile(hwpDoctitle, "HWP", "");
	        } */
	
	        function btnPrint_onclick() {
	        	if (!btnChk()) {
					return false;
				}
				var formFileLocation = document.getElementById("selForm").value;
				var currentExt = formFileLocation.substring(formFileLocation.lastIndexOf(".") + 1);
	        	if (currentExt === "mht") {
					PrintClick("Cross", pDocID, "ING");
				} else {
					var currIfrm = document.getElementById("ifrm" + currentTabIdx);
					currIfrm.contentWindow.PrintDocument();
				}

	        }
	
	        function btnClose_onclick() {
	            bAttachProcess = false;
	            OpenInformationUI("<spring:message code='ezApprovalG.t148'/><br><spring:message code='ezApprovalG.t149'/>", btnClose_onclick_Complete);
			}
	        
	        function btnClose_onclick_Complete(rtn) {
	        	DivPopUpHidden();
		        if (rtn)
		            window.close();
	        }
	
			window.onbeforeunload = function () {
				docMaxTabNumForDraft = pDocIDAry.length -1;
				
			    if (bAttachProcess == false) {
			        if ((!draftFlag && DraftFlag == "DRAFT") || (!draftFlag && AprState == "" && DraftFlag == "REDRAFT"))
			        	// 일괄기안 각 안별로 임시데이터 제거
			        	for (var i = 1; i <= docMaxTabNumForDraft; i++) {
			        		UndoDocForDraftAll(pDocIDAry[i]);
			        	}
			    }
			
                if (isPreview != "Y") {
                    try {
                        if (bAttachProcess == false)
                            window.opener.openergetDocInfo();
                    } catch (e) {
                        if (bAttachProcess == false)
                            window.parent.openergetDocInfo();
                    }
                }
			
			    try {
// 			        if (bAttachProcess == false)
			        	//Refresh_Window() 사용안함으로 주석처리
			            //window.opener.Refresh_Window();
			    } catch (e) { }
			
			    try {
			        bAttachProcess = true;
			    } catch (e) { }
			    
		        // try {
		        //     window.opener.getApprGraph("appr");
		        // } catch (e) { }
			}
	
			function btn_Attach_onclick() {
			    btnFileAttach_onclick();
			}
			
			/*PublicType, PublicLevel 기존의 공개여부 2018-04-04 김은석 수정*/
			function setPublicFlag() {
			    try {
			    	// 모든 안의 양식을 돌며 체크하되, 공개여부 필드의 존재를 확인한다.
			    	viewTabNum = $("dl.tab_menu dt").length;
			    	for (var i = 1; i <= viewTabNum; i++) { // 1안부터 시작
			    		var ifrm = document.getElementById("ifrm" + i);
				        if (!ifrm.contentWindow.FieldExist("publication")) { // 공개여부 필드가 양식에 없다면 다음 루프로 이동
				            continue;
				        }
				        
				        // 해당 문서정보는 모든 안에서 공유한다. 
				        var PublicType = pPublicityCode.substring(0, 1);
				        var PublicLevel = pPublicityCode.substring(1, 9);
				        var PublicText = "";
				
				        if (pLimitRange != "") {
				            PublicText = " (" + pLimitRange + ")";
				        }
				        
				        // 공개, 부분공개, 비공개 메세지 삽입
				        if (PublicType == "1") {
				            PublicText = "<spring:message code='ezApprovalG.t47'/>";
				        } else if (PublicType == "2") {
						    PublicText = "<spring:message code='ezApprovalG.t150'/>" + getPublicLevel(PublicLevel);
				        } else if (PublicType == "3") {
						    PublicText = "<spring:message code='ezApprovalG.t46'/>" + getPublicLevel(PublicLevel);
				        } else {
						    PublicText = " ";
				        }
						ifrm.contentWindow.PutFieldText("publication", PublicText);
			    	}
				} catch (e) {
				    alert("ezdraftui_hwp.setPublicFlag()  ::  " + e);
				}
			}
	
		    /*기존의 공개여부 함수 2018-04-04 김은석 수정*/
/* 		    function setPublicFlag2() {
		        if (!message.FieldExist("publication")) return;
		        var PublicType = pPublicityYN.substring(0, 1);

		        if (PublicType == "Y")
		            PublicText = "<spring:message code='ezApprovalG.t47'/>";
		        else if (PublicType == "N")
		            PublicText = "<spring:message code='ezApprovalG.t46'/>";
		        else
		            PublicText = " ";
		        
		        message.PutFieldText("publication", PublicText);
		    } */
			function getPublicLevel(PublicLevel) {
			    try {
			        var strRtn = "";
			        var firstFlag = true;
			        for (i = 0; i < 8; i++) {
			            if (PublicLevel.substring(i, i + 1) == "Y") {
			                if (firstFlag) {
			                    strRtn = "(" + (i + 1);
			                    firstFlag = false;
			                } else {
			                    strRtn = strRtn + "," + (i + 1);
			                }
			            }
			        }
			
			        if (!firstFlag)
			            strRtn = strRtn + ")";
			                    
			        return strRtn;
			    } catch (e) {
			        alert("apprGdraftuiAll_WHWP.jsp > getPublicLevel()::" + e.description);
			    }
			}
	
			function btnSetTaskCode_onclick() {
/* 			    try {
			        var para = new Array();
			        para[0] = cabinetID;
			        var url = "/myoffice/ezApprovalG/ezCabinet/SelectCabinet.aspx?initFlag=1";
			        var feature = "dialogWidth:850px;dialogHeight:455px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
			
			        if (url != "")
			            var rtn = window.showModalDialog(url, para, feature);
			
			        if (rtn[0] == "TRUE") {
			            var g_SelCabXml = rtn[1];
			            var xmlCab = new ActiveXObject("Microsoft.XMLDOM");
			            xmlCab.loadXML(g_SelCabXml);
			            cabinetID = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/CABINETID"));
			            TaskCode = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/TASKCODE"));
			        }
			    } catch (e) {
			        alert("ezdraftui_hwp.btnSetTaskCode_onclick()::" + e.description);
			    } */
			}
	
			var inssepattach_cross_dialogArguments = new Array();
			function btnAddSepAttach_onclick() {
				if (!btnChk()) {
					return false;
				}
				
				var deptCheckFlag = checkDeptAndCabinetId();
				
/* 				if(nonElecRec == "Y") {
			    	return;
			    } */
				
				if (deptCheckFlag == "3") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 기안창을 새로 띄워주시기바랍니다." );
					return;
				} else if (deptCheckFlag == "4") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 기안창을 새로 띄워주시기바랍니다.");
					return;
				}	
			
			    try {
			        if (cabinetID == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1401'/>";
					    OpenAlertUI(pAlertContent);
					    return;
					}
				
			        // 안별 웹한글기안기 iframe 내부에 접근하여 분리첨부정보 가져오는 함수를 실행
			        var currIfrm = document.getElementById("ifrm" + currentTabIdx);
				    var g_SepAttachLVXml = "";
				    g_SepAttachLVXml = currIfrm.contentWindow.GetDocumentElementForDraftAll("sepattachlvxml", true);
				    
				    if (!g_SepAttachLVXml) {
				        g_SepAttachLVXml = "";
				    }
				    
				    var para = new Array();
				    para[0] = g_SepAttachLVXml;
				    para[1] = cabinetID;
					para[3] = ext;
					
				    var url = "/ezApprovalG/insSepAttach.do";
				    //var feature = "dialogWidth:930px;dialogHeight:630px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";
			        //var rtn = window.showModalDialog(url, para, feature);
			        inssepattach_cross_dialogArguments[0] = para;
		        	inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;
		        	
		        	DivPopUpShow(920, 630, url);

				} catch (e) {
				    alert("ezdraftui_hwp.btnAddSepAttach_onclick()::" + e);
				}
			}
			
			function btnAddSepAttach_onclick_Complete(rtn) {
				DivPopUpHidden();
				var currIfrm = document.getElementById("ifrm" + currentTabIdx);
				
		        if (rtn[0] == "TRUE") {
		            g_SepAttachLVXml = rtn[1];
		            currIfrm.contentWindow.SetDocumentElementForDraftAll("sepattachlvxml", g_SepAttachLVXml);
		        }
			}
			
			// 부모창에서는 안쓰일지도? 일단 자식창에도 똑같이 복사해둿음
			//2019-01-18 천성준 - 새 HWP 분리첨부 XML파싱 소스 생성
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
					alert("apprGdraftuiAll_WHWP.jsp > GetSepAttParamXml() : " + e.description);
				}
			}
	
			function btnhistory_onclick() {
/* 				if(nonElecRec == "Y") {
			    	return;
			    } */
				getHistory();
			}
			
			var pGubun;
			// var ezapprovalinfo_dialogArguments = new Array();
			function btnApprovalInfo(pGubun) {
				
				// 안 추가 없이 결재정보 클릭하는 경우, 알러트 표출
				if (!btnChk()) {
					return false;
				}
				
				var deptCheckFlag = checkDeptAndCabinetId();
				
				if (deptCheckFlag == "3") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 기안창을 새로 띄워주시기바랍니다." );
					return;
				} else if (deptCheckFlag == "4") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 기안창을 새로 띄워주시기바랍니다.");
					return;
				}
				
			    try {
			        var onlydocinfiview = false;
			        var parameter = new Array();
			        
			        setLowerSignCount(); // 결재칸, 합의칸의 최소값과 각 안번호를 찾아 세팅
			        
			        // 현재 선택된 안의 정보를 기반으로 결재정보창을 호출한다. 따라서 내부결재문서, 수신문서 별로 탭이 다르게 나타나게 된다.
			        // cabinetID나 tempSecurity등의 정보는 모든 안에서 동일하다.
			        parameter[0] =  pDocIDAry[currentTabIdx];
			        parameter[1] = pFormID;
//			        parameter[2] = SignCount; // 각 안별로 양식의 결재칸, 합의칸 갯수 등이 다를 수 있다. 모든 안 중에서 가장 적은 갯수를 전달한다.
			        parameter[2] = lowerSignCnt;
			        parameter[3] = SignInfo;
//			        parameter[4] = hapyuiCount; // 일괄기안 시 부서합의 기능을 사용하지 않으며, 개인병렬/순차합의는 사용 가능하다. 부서추가 버튼만 숨겨주자. 모든 안 중에서 가장 적은 갯수를 전달한다.
			        parameter[4] = lowerHapyuiCnt;
			        parameter[5] = pDraftFlag;
			        parameter[6] = pSuSinFlag;
			        parameter[7] = pChamJoFlag;
//			        parameter[8] = gongramCount; // 마찬가지로, 0으로 전달한다. 공람문서는 기록물등록대장에서 완료된 개별 안을 발송하도록 한다.
			        parameter[8] = 0;
			        parameter[9] = false;
			        parameter[10] = pDocType;
			        parameter[11] = gamsaCount;
			        parameter[12] = "DRAFT";
			        parameter[17] = AprLineArea;
			        parameter[18] = HapyuiArea;
                    parameter[20] = tempKeep;
			        parameter[28] = onlydocinfiview
			        parameter[29] = TaskCode;
			        parameter[30] = cabinetID;
			        
			        parameter[31] = tempSecurity;
			        parameter[32] = tempUrgent;
			        parameter[33] = pSummery;
			        parameter[34] = pSpecialRecordCode;
			        parameter[35] = pPublicityCode;
			        parameter[36] = pLimitRange;
			        
			        parameter[37] = "1"; //쪽수 1고정
 			        parameter[38] = tempSecurityDate;
			        parameter[39] = SummaryFlag;
			       // parameter[40] = undefined2EmptyString(SummaryOuterReceiverListAry[0]);
			        parameter[40] = undefined2EmptyString(SummaryOuterReceiverListAry[currentTabIdx]); //외부수신자 요약
			        parameter[41] = tempItemName;
			        parameter[42] = tempItemName2;
			        parameter[45] = pPublicityYN;
			        parameter[46] = ""; // 일괄기안 페이지는 비전자기록물 등록 지원안함
			        
			        if (useOpenGov == "YES") {
			        	parameter[52] = basis;
                        parameter[53] = reason;
                        parameter[54] = listOpenFlag;
                        parameter[55] = fileOpenFlagList;
                        parameter[56] = limitDate;
					}
			        
			        if (tempItemCode != "") {
			            tempdocnumcode = tempItemCode;
			        }
			        if (pGubun == undefined) {
			            pGubun = CheckGubun;
			        }
			        parameter[60] = "N"; // 일괄기안 시 기결재통과 함께 사용 못함 (N으로 전달)
			        parameter[61] = tempKeyword;
			        
 					// 일괄기안 관련 추가 데이터
					parameter[62] = draftAllFlag;
			        parameter[63] = pDocIDAry;
					parameter[64] = pDocIDAry[currentTabIdx];
					//parameter[65] = docInfoFlag; // 문서정보 확인여부 플래그 -> 표준모듈에서 결재정보창 내부로 이동됨
			        
			        // ezapprovalinfo_dialogArguments[0] = parameter;
	                // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
					//
	                var url = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun +"&docType=" + pDocType + "&ext=" + "hwp" + "&formID=" + pFormID + "&draftAllFlag=Y";
			        // var ret = window.open(url, "ezApprovalInfo-" + windowUuid, 'height=750,width=1210,scrollbars=no' + GetOpenPosition(1210, 750));
					ezCommon_cross_dialogArguments[0] = parameter;
					showPopup(url, 1210, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
			    } catch (e) {
			        alert("ezdraftui_hwp.btnApprovalInfo()::" + e);
			    }
			}
			
			function btnApprovalInfo_Complete(ret) {
				hidePopup();
				var currIfrm = document.getElementById("ifrm" + currentTabIdx);
				
				if (ret != undefined && ret[0] == "OK") {
		            if (ret[1] != false) {
		            	$.ajax({
                    		type : "POST",
                    		dataType : "text",
                    		async : false,
                    		url : "/ezApprovalG/aprLineSaveAll.do",
                    		data : {
                    				ret : ret[1],
                    				docIDAry : pDocIDAry
                    		},
                    		success : function(text){}
                    	});
		
		                IsSkipDrafter = "FALSE";
		                btnSendDraftEnable = "true";
		                
		             //   열려있는 웹한글기안기마다 결재선을 그려줘야 하므로, 루프를 돌린다.
		                var ifrms = $(".tab_container").find("iframe");
		                for (var i = 0; i < ifrms.length; i++) {
		                	// 자식창 내부에서 결재선 확인 및 부모창의 LastSignSN, lastKyulName 값 등을 변경함 (모든 안 공통이므로)
		                	if(approvalFlag == "S")
		                	    ifrms[i].contentWindow.SGetDraftAprLineInfo(ret);
		                	else
		                	    ifrms[i].contentWindow.GetDraftAprLineInfo(ret);
						}
						TempsaveAprlineinfo = ret[1];
		            }
		            
		            // 수신처는 개별 안에만 적용하므로, 루프를 돌리지 않는다.
		            if (pSuSinFlag == "Y" && typeof (ret[2]) == "string") {

                        if ($(currIfrm).find("#autoLine") != null) {
                            var oDIV = document.createElement("DIV");
                            oDIV.className = "FIELD";
                            oDIV.id = "RecvautoAprLine";

                            if ($(currIfrm).contents().find("#RecvautoAprLine").length <= 0) {
                                $(currIfrm).contents().find("#autoLine").append(oDIV);
                            } else {
                                //수신문 회송받아서 재기안할 때, 수신사인칸 초기화작업
                                if (pDraftFlag == "REDRAFT") {
                                    $(currIfrm).contents().find("#RecvautoAprLine").remove();
                                    $(currIfrm).contents().find("#autoLine").append(oDIV);
                                }
                            }
                        }

		            	$.ajax({
                    		type : "POST",
                    		dataType : "text",
                    		async : false,
                    		url : "/ezApprovalG/aprDeptSave.do",
                    		data : {
                    				aprDeptInfo : ret[2]
                    		}
                    	});
		            	
		                btnReceivLineEnable = false;
		                if (approvalFlag == "G"){
                            SummaryOuterReceiverList = ret[15];
                            SummaryOuterReceiverListAry[currentTabIdx] = ret[15];
		                }
		                currIfrm.contentWindow.setRecevInfo(ret[3]); // 현재 선택한 안에 대해서만 수신자를 지정
		                btnReceivLineEnableAry[currentTabIdx] = true; // 일괄기안 데이터 배열의 수신처가 존재한다는 플래그 변경
		            } else if (pSuSinFlag == "Y" && ret[2] == "") {
		                DeleteDeptInfo();
		                currIfrm.contentWindow.setRecevInfo("");
		            }
		
		            var g_SelCabXml = ret[4];
		            var xmlCab = loadXMLString(g_SelCabXml);
		            // 기록물철과 단위업무 코드 설정
		            if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
		                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		            }

                    cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");

                    var currIfrm = document.getElementById("ifrm" + currentTabIdx);
                    if (currIfrm.contentWindow.FieldExist("keepperiod")) {
                        keepperiod = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/KEEPPERIOD");
                        currIfrm.contentWindow.PutFieldText("keepperiod", keepperiod);
                    }

                    tempKeyword = ret[6];
		            tempSecurity = ret[7];
		            tempUrgent = ret[8];
		            pSummery = ret[9];
		            pPublicityCode = ret[11];
		            tempSecurityDate = ret[14];
		            pPublicityYN = ret[21];
		            
		            if (pPublicityYN.substring(0,1) == "N") {
                        tempPublic = "N";
                    } else if (pPublicityYN.substring(0,1) == "Y") {
                        tempPublic = "Y";
                    } else if (pPublicityYN.substring(0,1) == "B") {
                        tempPublic = "B";
                    }

		            if (approvalFlag == "G") {
                        pSpecialRecordCode = ret[10];
                        pLimitRange = ret[12];
                        pPageNum = ret[13];

                        setPublicFlag();
                        setKeepPeriod(currIfrm);

/*                        if (nonElecRec == "Y") {
                            nonElecRecInfoXml = ret[23];
                            nonSepAttachLVXml = ret[24];
                            sepAttachCheckYN = ret[26];
                            setNonElecRecInfo_mht(nonElecRecInfoXml);
                        } */

					    // 모든 문서에 대해 동일한 원문공개정보 삽입 (각 안별 첨부파일 공개여부는 별도로 관리)
                        if (useOpenGov == "YES") {
                            listOpenFlag = ret[27];
                            fileOpenFlagList = ret[28];
                            basis = ret[29];
                            reason = ret[30];
                            limitDate = ret[31];

                            $.ajax({
                                type : "POST",
                                dataType : "text",
                                async : false,
                                url : "/ezApprovalG/openGovInfoSaveAll.do",
                                data : {
                                    openGovListFlag : listOpenFlag,
                                    fileOpenFlagList : fileOpenFlagList,
                                    basis : basis,
                                    reason :  reason,
                                    publicity : pPublicityCode,
                                    docID : pDocID,
                                    limitDate : limitDate,
                                    // 일괄기안용 추가 파라미터
                                    pDocIDAry : pDocIDAry,
                                    fileOpenFlagListAry : fileOpenFlagList // 배열로 전달됨
                                }
                            });
                            // 일괄기안일경우 현재 선택한 탭의 fileOpenFlag 변경 (첨부파일은 각 안별로 취급하므로, 공통이 아님)
                            fileOpenFlagListArr[currentTabIdx] = fileOpenFlagList;
                        }
                    } else {
                        //회람
                        /* if (ret[22] == "noItem") {
                            delAprLineInfoCC();
                        } else if (ret[22] == "sameItem") {
                            // ret[22] 값이 "sameItem"일 경우 동작 없음
                        } else {
                            //회람 저장
                             SaveAprLineInfoCC(ret[22]);
                        } */

                        tempKeep = ret[16];
                        tempItemName = ret[17];
                        tempItemName2 = ret[18];
                        tempSecurityValue = ret[19];
                        pPageNum = "1";
                        pLimitRange = "1";
                        pSpecialRecordCode = "1";
                        tempPublic = ret[11];
                        SetDocOption(ret[20]);
                    }

		            passAprLine = ret[32]; // "N"만 들어갈듯

		            SummaryFlag = true;
		            setTabInfo();
		        }
			}
	
			var tmpGroupDocSN = ""; // 일괄기안용 문서순번 -> 웹한글이 비동기식으로 동작하므로, 비동기 호출 이전에 이 순번을 고정하여 가져오도록 한다. 전역변수로 사용 가능함
			var beforeDocSN = "";  // 자동저장 관련 변수, 공백으로 전달
			function btnSaveServer_onclick() {
				try {
					if (!!checkJobTransferStatus &&
							!checkJobTransferStatus("<c:out value ='${userInfo.id}'/>",
									"<c:out value ='${userInfo.deptID}'/>",
									"<c:out value ='${userInfo.jobId}'/>")) {
						window.close();
						return;
					}
					
					if (!btnChk()) {
						return false;
					}
					
			        if (pDraftFlag == "REDRAFT") {
						if (ListType != "21") { // 임시보관함에서 열지 않은 경우 (결재할문서에서 재기안)
			                var pAlertContent = "재기안시 임시저장 할 수 없습니다.";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			        }
			        
			        // 프로그레스 이미지 발생
			        ShowMailProgress();
			        // 임시저장 이전, 각 안의 문서제목필드 존재여부를 확인한다.
			        var rtnVal = "TRUE";
			        var ret = btnSaveServer_onclick_before();
					// 정상적인 경우에만 다음 단계 진행
			        if (ret) {
			        	tmpGroupDocSN = getMaxTmpGroupDocSN(); // 임시저장 순번을 동기식으로 반환 (비동기로 호출하면 에러 발생 가능해서 여기로 분리함)
			        			
				        // 현재 열려있는 모든 안에 대하여 동작
				        var ifrms = $(".tab_container").find("iframe");
			        	
		            	ifrms.each(function(index, item) {
		                	setTabInfo(item.id.replace("ifrm", ""));
		                	
		                	// 결재선 확인동작이 없음 + 임시보관함에서 다시 임시저장하는 경우가 아님
		                	if (btnSendDraftEnable == "false" && ListType != "21") {
					            setFirstDrafterAuto(); // 저장된 결재선이 없다면 기안자를 결재선에 등록
					        }
		                	
		                	// 임시저장을 반복하는 경우, 새로운 문서로 임시저장함 (기존 임시저장 문서를 삭제하지 않고 계속 새롭게 증가시키는게 표준스펙임)
					        if (Saveflag) {
				        		newpDocID = createNewDoc();
				        		newpDocIDAry[index + 1] = newpDocID;// 새롭게 생성한 ID를 배열에 부여
				        	}
		                	
					        item.contentWindow.GetTextFile("HWP", "", function (data) {
					        	ret = exSaveTMPFile(data, index + 1, ifrms.length);
					        	
						        // 임시저장 루프 중 하나라도 실패하는 경우, exSaveTMPFile 함수는 정지한다. (오류 또는 성공 메세지는 exSaveTMPFile 함수 내부에서 표출)
	 					        if (typeof(ret) == "undefined" || ret == false) {
						        	rtnVal = "FALSE";
						        	return false;
			                	}
					        });
		            	});
			        }
			    } catch (e) {
			    	HiddenMailProgress();
			        alert("apprGdraftuiAll_WHWP.jsp > btnSaveServer_onclick()::" + e.description);
			    }
			}
			
			// 임시저장 이전, 각 안의 문서제목필드 존재여부를 확인
			function btnSaveServer_onclick_before() {
				  var ifrms = $(".tab_container").find("iframe");
			        
	                for (var i = 0; i < ifrms.length; i++) {
	                	setTabInfo(ifrms.get(i).id.replace("ifrm", ""));
	                	
	                	var tempDocTitle = "";
	                	// 각 안의 문서제목값을 설정
	    				if (ifrms.get(i).contentWindow.FieldExist("doctitle")) {
	    					tempDocTitle = trim(ifrms.get(i).contentWindow.GetFieldText("doctitle"));
	    				} else { // 문서제목 필드가 아예 없는 경우, "결재문서" 라는 제목을 임의로 부여
	    					tempDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
	    				}
	    				
	    				// 문서제목값이 없거나, 127자를 넘는 경우
	    	            if (tempDocTitle == "") {
	    	            	HiddenMailProgress();
	    	                var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
	    	                OpenAlertUI(pAlertContent);
	    	                return false;
	    	            } else if (tempDocTitle.length > 127) {
	    	            	HiddenMailProgress();
	    	                var pAlertContent = "<spring:message code='ezApprovalG.t132'/>";
	    	                OpenAlertUI(pAlertContent);
	    	                return false;
	    	            }
	                	
						// 정상적인 문서제목이 존재한다면, 문서제목 배열에 각 안의 문서제목을 삽입
	    	            pDocTitleAry[i] = tempDocTitle;
	                }
	                
	                // 모든 안이 정상적인 경우에만 true로 리턴
	                return true;
			}
			
			// currIdx : 현재 안의 인덱스 (1안, 즉 1부터 시작)
			// maxIdx : 전체 안의 갯수 인덱스
			function exSaveTMPFile(html, currIdx, maxIdx) {
				var currIfrm = document.getElementById("ifrm" + currIdx);
				var rtnVal = currIfrm.contentWindow.SaveTMPFile(Saveflag, html, currIdx);
				
		        if (rtnVal == "TRUE") {
		            rtnVal = currIfrm.contentWindow.SaveTMPDocInfo(Saveflag, currIdx);
		            
		            if (rtnVal == "TRUE") { // 저장완료
		            	rtnVal = SaveTmpGroup(currIdx, tmpGroupDocSN, "Y");
		            	docSaveCompleteCnt ++; // 임시저장 완료 카운트 하나 증가
		            	
                        // 모든 임시저장이 정상적으로 완료된 뒤 알림메세지 표출
        		        if (docSaveCompleteCnt == maxIdx) { // 최종 임시저장 루프인 경우
        	                if (rtnVal != "error") { // 저장완료 (SaveTmpGroup에 대한 rtnVal => 성공 시 임시저장된 순번 정보를 userID@docSN 형식으로 리턴함)
        	                	HiddenMailProgress();
        	                    var pAlertContent = "<spring:message code='ezApprovalG.t1581'/>";
        	                    OpenAlertUI(pAlertContent);
        	                    Saveflag = true;
        	                    docSaveCompleteCnt = 0; // 임시저장 완료 카운트 초기화
        		            } else {
        		            	HiddenMailProgress();
        		                var pAlertContent = strLang217;
        		                OpenAlertUI(pAlertContent);
        		                docSaveCompleteCnt = 0;
        		                return false;
        		            }
        		        }
		            } else {
		            	HiddenMailProgress();
		                var pAlertContent = strLang217;
		                OpenAlertUI(pAlertContent);
		                docSaveCompleteCnt = 0;
		                return false;
		            }
		        } else {
		        	HiddenMailProgress();
		            var pAlertContent = strLang217;
		            OpenAlertUI(pAlertContent);
		            docSaveCompleteCnt = 0;
		            return false;
		        }
			}
			
			// i는 탭순서 (1안부터 시작)
			function SaveTmpGroup(i, GroupDocSN, tmpYN) {
				var ret = "";
				var param = "";
				
				/*
				if (tmpYN == "N") { // tmpYN 값은 "Y"로만 전달된다. 필요하지 않은 분기 주석처리
					param = pDocIDAry[i];
				}*/
	            
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/saveTmpGroup.do",
					data : {
							docID : param,
							tabSN  : i,
							groupDocSN : GroupDocSN
					},
					success: function(result) {
						ret = result;
					}, error : function() {
						var pAlertContent = strLang217;
						OpenAlertUI(pAlertContent);
						return false;
					}
				});

	            return ret;
	        }
			
	        function window_onbeforeunload() {
	        	docMaxTabNumForDraft = pDocIDAry.length -1;
	        	
	            if (bAttachProcess == false) {
	                if ((!draftFlag && DraftFlag == "DRAFT") || (!draftFlag && AprState == "" && DraftFlag == "REDRAFT")) {
	                	// 일괄기안 각 안별로 임시데이터 제거
			        	for (var i = 1; i <= docMaxTabNumForDraft; i++) {
			        		UndoDocForDraftAll(pDocIDAry[i]);
			        	}
	                }
	            }
	            try {
	                if (bAttachProcess == false)
	                    window.opener.openergetDocInfo();
	            }
	            catch (e)
	            { 
					if (bAttachProcess == false)
	                    window.parent.openergetDocInfo();
				}
	            // try {
	            //     if (bAttachProcess == false)
	            //         window.opener.Refresh_Window();
	            // }
	            // catch (e) { }
	            try {
	                bAttachProcess = true;
	            }
	            catch (e) { }
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
		    // 이 함수는 btnSendDraft_onclick()의 루프 내부에서 호출되나, sendDraft()에서 추가적인 카운트를 체크하므로 단 한번만 호출된다.
		    // (각 안의 결재정보 체크를 전부 완료한 뒤 최종 안에서만 호출함)
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
		    	
		    	// 결재암호 사용 (로그인암호 또는 결재암호)
		    	if (result != "N") {
		    		chk_Passwd();
		    	}
		    	// 결재암호 미사용
		    	else {
					if (IsSkipDrafter == "FALSE") {
	                    openSignUI();
	                } else {
	                	GetHTML(saveDraftInfo);
	                }
		    	}
		    }
	    	
	    	function checkDeptAndCabinetId() {
	    		var result;
            	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezApprovalG/checkDeptAndCabinetId.do",
            		data : {
            				orgDeptId : arr_userinfo[4],
            				orgCabinetId : cabinetID
            				},
            		success : function(text){
            			result = text;
            		}
            	});
            	return result;
	    	}
	    	
	    	// 웹 한글 기안기용 (각 안별 iframe에서 부모창의 함수를 동작시킴)
 	    	function Editor_Complete(iframeID, formHref) {
	    		var iframe = document.getElementById(iframeID);
	    		if (iframe == null || typeof(iframe) == "undefined") {
	    			return;
	    		}
	    		
	    		var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(formHref);
                iframe.contentWindow.Open(URL, "", "", function (res) {
                	iframe.contentWindow.ShowToolBar(true);
                	iframe.contentWindow.ShowRibbon(true);
					iframe.contentWindow.attachedDocList = attachedDocList;
                	iframe.contentWindow.FieldsAvailable(res.result);
                	Editor_focus(iframeID);
                }, null);
	    	}
	    	
 	    	function Editor_focus(iframeID){
 	    		document.getElementById(iframeID).contentDocument.getElementById("hwpctrl_frame").contentDocument.getElementById("ImeWrapper_Elm").focus();
 	    	}
	    	
 	    	function Editor_Complete2() {
	            setTimeout("Insert_ReUse_Content();", 1000);
	        }
	    	
	    	// OpenInformationUI 팝업용 메서드
	    	// 결재정보 없을때 팝업
	    	function check_btnSendDraft2(ans) {
		        DivPopUpHidden();
		        if (ans)
		            btnApprovalInfo(1);
		    }
	    	
	    	// 기록물철 없을때 팝업
	    	function check_btnSendDraft3(ans) {
		        DivPopUpHidden();
		        if (ans)
		            btnApprovalInfo(3);
		    }
	    	
	    	// 기안자 == 최종 결재자
	    	function check_btnSendDraft4(Ans) {
	    		DivPopUpHidden();
	    		
	    		if (!Ans) {
	    			HiddenMailProgress();
	    			return;
	    		}
				
	    		// 사실상 필요없는 분기인듯? pDraftFlag는 DRAFT나 REDRAFT 둘중 하나임
	    		/*
                if (pDraftFlag == "HABYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
                    getLastOpinon();
                }
				*/

				// 각 안을 루프하며 필드에 값을 삽입
				for (var i = 1; i <= docMaxTabNumForDraft; i++) {
					var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
					
	                if (currIfrm.contentWindow.FieldExist("lastdraftdate")) {
	                	currIfrm.contentWindow.PutFieldText("lastdraftdate", getGyulJeDate());
	                }
				}
				
                CheckUsePassword();
	    	}
	    	
	    	function chk_Passwd_Complete(chkpass) {
	    		DivPopUpHidden();
	    		
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
	    		
	    		if (IsSkipDrafter == "FALSE") {
                    openSignUI();
                } else {
                	GetHTML(saveDraftInfo);
                }
	    	}
	    	
	    	// 한번만 호출되는 함수이므로, 내부에서 각 안별로 루프를 돌린다.
	    	function openSignUI_Complete(ret) {
	    		DivPopUpHidden();
	    		ShowMailProgress();
	    		
	    		if (ret == "cancel" || ret == undefined) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
                    HiddenMailProgress();
                    OpenAlertUI(pAlertContent);
                    return;
                }
	    		
	        	if (LastSignSN == 1 || DraftLastFlag) {
	        		/*
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_BEFORE");
                    if (!rtnVal) {
                        return;
                    }
                    */
                }
	        	
	        	// 각 안별 루프 시작 (문서번호 부여, 서명 부여 동작 등)
	        	for (var i = 1; i <= docMaxTabNumForDraft; i++) {
	        		var currIfrm = document.getElementById("ifrm" + i); // 각 안별 웹한글기안기 iframe을 사용
	                var rtnval;
	                
	        		// getDocNumberNew 는 자식 프레임에 직접 접근하여 사용하도록 한다.
	        		// 문서번호 부여는 공통 작업이 아니라 각 안 별 작업이므로, 각 자식 프레임의 동작이 되도록 호출함 (인덱스는 반드시 전달)
	                if (LastSignSN == 1 || DraftLastFlag) {
	                    rtnval = currIfrm.contentWindow.getDocNumberNew(arr_userinfo[4], "", docNumZeroCnt, i);
	                }
	                else {
	                    rtnval = currIfrm.contentWindow.getDocNumberNew(arr_userinfo[4], "be", docNumZeroCnt, i);
	                }
	
	                if (!rtnval) {
	                    var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
	                    HiddenMailProgress();
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	
	                if (LastSignSN == 1 || DraftLastFlag) {
	                	/*
	                    var rtnVal;
	                    rtnVal = ExcuteInfo("DOCNUM_AFTER");
	                    if (!rtnVal) {
	                        return;
	                    }
	                    rtnVal = ExcuteInfo("LAST_SIGN_BEFORE");
	                    if (!rtnVal) {
	                        return;
	                    }
	                    */
	                }
	                // 각 자식 프레임을 특정하고 그 내부에서 함수를 호출하므로, 인덱스는 필요없음
	                // 최대 안의 갯수는 전역변수이므로, 그냥 함수 내부에서 부모 접근하여 사용하면 됨. 일단 전달해주긴 함
	                currIfrm.contentWindow.SendDraftMappingSign(ret, docMaxTabNumForDraft);
	        	}
	    	}

			function btnConn_onclick() {
				ExcuteInfo("INIT");
			}
			
	    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
	    	function setAttachGuideText() {
	    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                
                if (bigSizeAttachDownloadLimitCount > 0) {
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
                	 document.getElementById("apprAttachGuideTBL").style.display = "none";
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
	    	// 안추가
	    	function btnAddApproval_onclick() {
	            ShowMailProgress(); // 로딩 이미지 표출
	            var selFormID = document.getElementById("selForm").value;
	            var formid = "";
	            var formdoctype = "";
	            var formFileLocation = "";
	            var formExt = "";
	            viewTabNum = $("dl.tab_menu dt").length;
	            
	            // 양식 선택하지 않고 안을 추가하는 경우 알러트
	            if (selFormID == "") {
	                HiddenMailProgress();
	            	OpenAlertUI(strLangHSBRDa02, null, ""); // 양식을 먼저 선택해 주세요.
	                return false;
	            } else {
	                formid = selFormID.split("|")[0];
	                formdoctype = selFormID.split("|")[1];
	                formFileLocation = selFormID.split("|")[2];
	                formExt = formFileLocation.substring(formFileLocation.lastIndexOf(".") + 1);
	            }
	            
	            // 탭은 10개까지 허용 (최대 허용 안의 갯수는 이후 테넌트 컨피그로 분리 예정)
	            if (viewTabNum >= maxTabNum) {
	                HiddenMailProgress();
	                OpenAlertUI(strLangHSBRDa03 + maxTabNum + strLangHSBRDa04, null, ""); // 안 추가 탭은 maxTabNum개까지만 가능합니다.
	                return false;
	            }

	            // 10개까지만 추가가능
	            if (viewTabNum < maxTabNum) {
	                var newTabCnt = Number(newTabIdx) + 1; // 마지막으로 새로 추가한 탭의 숫자 증가
	                newTabIdx = newTabCnt;

	                var viewTabIdx = Number(viewTabNum) + 1; // 전체 탭 인덱스 증가
	                
	                // 1안 이후 추가 시, addflag 등 추가 플래그 변경
	                if (newTabIdx > 1) {
		                titleOptionFlag = true;
			    		contentOptionFlag = true;
			    		attachOptionFlag = true;
			    		docAttachOptionFlag = true;
			    		seperateAttachOptionFlag = true;
			    		opinionOptionFlag = true;
			    		addFlag = true;
	                }
	                
	                // 임시저장 된 문서를 열고 새로 안을 추가하는 경우, 해당 안은 신규 기안이다. 굳이 안추가 시에 임시저장 처리할 필요 없음
	                // 배열 파라미터에 현재 안의 인덱스로 정보 추가
/* 	                if (ListType == "21") { // 임시저장된 문서는 sn(newTabIdx) 사용
		       			pDocIDAry[newTabIdx] = MakeTmp2Ing(pDocIDAry[newTabIdx]);
	       			} */
	                
	                pFormHrefAry[newTabIdx] = formFileLocation; // 양식경로
	                pFormIDAry[newTabIdx] = formid; // 양식ID 
	                pDocType  = formdoctype; // 양식 타입 (내부결재, 수신문, 시행문...)
	                pDocTypeAry[newTabIdx] = formdoctype; 
	                extAry[newTabIdx] = formExt;

	            	 // 문서정보를 부모 페이지의 배열에 복사 (결재정보를 지정하지 않은 경우, 해당 값들은 대부분 공백으로 부여된다.)
	            	 // undefined2EmptyString 함수를 사용하지 않는 이유?  => 하단에서 동작할 setTabInfo 함수에서 undefined 체크 후 특정한 디폴트 값을 부여하기 위함
	            	 // 결재정보 중 안마다 별도로 관리해야 하는 부분은 원문공개사용 시 첨부파일의 공개여부
		            
       		        fileOpenFlagListArr[newTabIdx] =  fileOpenFlagListArr[0];
		           // 문서정보 복사 여기까지
		            
	                
	                var addString = "";
	                if (newTabCnt == 1) { // 최초 1안 추가
	                    $("dl.tab_menu").append("<dt class=\"active\" id=\"dt" + newTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + newTabIdx + "')\"  id=\"sp" + newTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></li>");
	                    addString = "<div class=\"tab_content\" id=\"tab" + newTabIdx + "\" style=\"height:0px; overflow:visible;\"> ";
	                } else {
	                    $("dl.tab_menu").append("<dt id=\"dt" + newTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + newTabIdx + "')\" id=\"sp" + newTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></li>");
	                    addString = "<div class=\"tab_content\" id=\"tab" + newTabIdx + "\" style=\"height:0px; overflow:hidden;\"> ";
	                }
	                
	                var iframeURL = (formExt == "mht" ? "/ezApprovalG/draftContent.do" : "/ezApprovalG/draftContentAll_WHWP.do") + "?frameNum=" + newTabIdx + "&formID=" + encodeURI(pFormIDAry[newTabIdx]) + "&docHref=" + encodeURI(pFormHrefAry[newTabIdx]) + "&docID=" + encodeURI(pDocIDAry[newTabIdx]);
					addString = addString + "<iframe name=\"ifrm" + newTabIdx + "\" id=\"ifrm" + newTabIdx + "\" style=\"width:100%; height:" + wh + "px; border:0px\" onload=\"getReSize()\" src=\"" + iframeURL + "\"></iframe></div>";
							
	                $("div.tab_container").append(addString);
	                viewTabNum = viewTabNum + 1; // 전체 탭 갯수 증가
	                
					// 탭 추가 시 배열에 담아둔 데이터를 현재 부모창 파라미터로 부여
					setTabInfo(newTabIdx);
	             
					// 추가한 탭으로 이동
	                selTab(newTabCnt);
	                
	                HiddenMailProgress();
	            }
	        }
	        
	        // 안삭제
	    	function btnDelApproval_onclick() {
	            if (!btnChk()) {
	                return false;
	            }
	            if (currentTabIdx == 1) {
	                OpenAlertUI(strLangHSBRDa05, null, ""); // 1안은 삭제 불가능합니다.
	                return false;
	            }
	            
	         // 안삭제여부 확인 알러트 메세지 레이어 팝업으로 분리
	            var pAlertContent = strLangHSBRDa06 + document.getElementById("sp" + currentTabIdx).innerText + strLangHSBRDa07; // 현재 선택된 currentTabIdx안을 삭제하시겠습니까?
	            OpenInformationUI(pAlertContent, btnDelApproval_onclick_complete);
	        }
	        
	    	function btnDelApproval_onclick_complete(ans) {
	    		DivPopUpHidden();
	        	if (ans) {
					$("#dt" + currentTabIdx).remove();
	                $("#tab" + currentTabIdx).remove();
	                
	                // 기존 한글기안기와는 다르게, 저장 루프 시 웹한글기안기가 비동기식으로 동작하므로 정상 배열 유지를 위해 아예 해당 안의 배열을 잘라낸다. 
	                deleteAnAry(currentTabIdx);
	                
		            // 탭 안 순서명, 탭ID, iframe ID 변경
		          	var currDTLenght = $("dl.tab_menu dt").length;
		            for (var i = 0; i < currDTLenght; i++) { // 1안부터 가장 마지막으로 추가된 안까지, 하나 삭제된 전체 안 길이만큼 반복
		            	var newIdx = (i + 1);
		            
		                if (typeof($("dl.tab_menu dt").get(i).id) != "undefined") {
		                    $("dl.tab_menu dt").get(i).id = ("dt" + newIdx); // 안별 탭 상위 dt
		                    $("dl.tab_menu dt span").get(i).id = ("sp" + newIdx); // 안별 탭 ID
		                    $("dl.tab_menu dt span").get(i).setAttribute("onclick", "selTab('" + newIdx + "')"); // 안별 탭 클릭시 selTab 함수
		                    $("dl.tab_menu dt span").get(i).innerText = (newIdx + " " + strLangHSBRDa01); // 안별 탭 "n 안"
		                    
		                    $("div.tab_content").get(i).id = ("tab" + newIdx); // 안별 iframe 상위 div ID
		                    $("div.tab_content iframe").get(i).id = ("ifrm" + newIdx); // 안별 iframe ID
		                    $("div.tab_content iframe").get(i).name = ("ifrm" + newIdx); // 안별 iframe name
		                    
		                    // src 변경 시 리프레시될 수 있으므로, 일단 자식 프레임 내부의 frameNum만 수정하도록 함
		                    $("div.tab_content iframe").get(i).contentWindow.frameNum = String(newIdx); // 안별 iframe 내부 frameNum (문자열)
		                    
		                }
		            }
		            viewTabNum = $("dl.tab_menu dt").length; // 전체 추가된 안의 갯수를 재설정
		            newTabIdx = newTabIdx - 1; // 가장 마지막으로 추가된 안의 번호를 재설정
		            
	                selTab(1); // 안삭제 후 1안으로 이동
	        	}
	    	}
	        
	        // 안 추가여부 확인
	    	function btnChk() {
	            if (newTabIdx == 0) {
	                OpenAlertUI(strLangHSBRDa08, null, ""); // 추가된 안이 없습니다.<br/> [안추가]를 먼저 실행해 주세요.
	                return false;
	            } else {
	                return true;
	            };
	        }
	        
	        // 재기안 또는 임시저장된 문서의 기안 시, 문서별로 탭을 생성
	        function makeTabs() {
	        	if (ListType != '21') { // 반송문서 재기안
					ShowMailProgress();
	                var viewTabCnt = pDocIDAry.length - 1;
	        	
	                for (var i = 1; i <= viewTabCnt; i++) {
	                    var viewNewTabCnt = Number(i);
	                    newTabIdx = viewNewTabCnt;

	                    viewTabNum = $("dl.tab_menu dt").length;
	                    var viewTabIdx = Number(viewTabNum) + 1;
	                    
	                    var addString = "";
	                    if (viewNewTabCnt == 1) {
	                        $("dl.tab_menu").append("<dt class=\"on\" id=\"dt" + newTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + newTabIdx + "')\"  id=\"sp" + newTabIdx + "\">" + newTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
	                        addString = "<div class=\"tab_content\" id=\"tab" + newTabIdx + "\" style=\"height:0px; overflow:visible;\">";
	                    }
	                    else {
	                        $("dl.tab_menu").append("<dt id=\"dt" + newTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + newTabIdx + "')\"  id=\"sp" + newTabIdx + "\">" + newTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
	                        addString = "<div class=\"tab_content\" id=\"tab" + newTabIdx + "\" style=\"height:0px; overflow:hidden;\">";
	                    }
	                    
	                    var iframeURL = (extAry[i] == "mht" ? "/ezApprovalG/draftContent.do" : "/ezApprovalG/draftContentAll_WHWP.do") + "?frameNum=" + newTabIdx + "&docHref=" + encodeURI(pFormHrefAry[newTabIdx]) + "&docID=" + encodeURI(pDocIDAry[newTabIdx]);
                        addString = addString + "<iframe name=\"ifrm" + newTabIdx + "\" id=\"ifrm" + newTabIdx + "\" onload=\"getReSize()\" style=\"width:100%; height:" + wh + "PX; border:0px\" src=\"" + iframeURL + "\"></iframe></div>";
	                    
	                    $("div.tab_container").append(addString);
	                    HiddenMailProgress();
	                }
	                
					// 반송문서 재기안인 경우 임시저장 불가능 (버튼 클릭 시 "재기안시 임시저장 할 수 없습니다." 매세지 표출되므로, 그냥 버튼 자체를 숨김처리함)
	                document.getElementById("btnSaveServer").style.display = "none";
	            }
	            else if (ListType == "21" && pDocIDAry.length > 1) {   // 임시저장된 문서 기안 (0번배열 제외하므로 1개 초과하는지 체크)
	                ShowMailProgress();
	                var viewTabCnt = pDocIDAry.length - 1; // 임시저장된 문서 갯수만큼 탭을 만들어줄 예정이므로, 변수는 미리 설정해뒀음 (안 갯수는 0번배열 제외하기 위해 -1처리)
	             	
	                // 임시저장 문서를 위한 새로운 임시저장문서 정보를 생성(카피)
	                for (var i = 1; i <= viewTabCnt; i++) {
	                	pDocIDAry[i] = MakeTmp2Ing(pDocIDAry[i]);
	                }
	                
	                for (var i = 1; i <= viewTabCnt; i++) {
	                    var viewNewTabCnt = Number(i); // 1안부터 시작
	                    newTabIdx = viewNewTabCnt; // 지금부터 만들어질 새 안의 인덱스

	                    // 탭의 요소 길이 자체는 0부터 시작하게 되며, 루프를 진행하면서 1, 2... 로 증가한다.
	                    viewTabNum = $("dl.tab_menu dt").length;
	                    var viewTabIdx = Number(viewTabNum) + 1; // 최초 루프 시 0 -> 1로 현재 탭 인덱스 증가
	                    
						var addString = "";
 						if (newTabIdx == 1) { // 1안인 경우, 선택된 상태로 스타일 처리
	                        $("dl.tab_menu").append("<dt class=\"on\" id=\"dt" + newTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + newTabIdx + "')\"  id=\"sp" + newTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
	                        addString = "<div class=\"tab_content\" id=\"tab" + newTabIdx + "\" style=\"height:0px; overflow:visible;\"> ";
						}
	                    else {
	                        $("dl.tab_menu").append("<dt id=\"dt" + newTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + newTabIdx + "')\"  id=\"sp" + newTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
	                        addString = "<div class=\"tab_content\" id=\"tab" + newTabIdx + "\" style=\"height:0px; overflow:hidden;\">";
	                    }

 						// formID는 자식 프레임에서 process_AfterOpen() > GetAprDocFormID()로 알아서 가져오게 된다. 안 넘겨줘도 됨
 						var iframeURL = (extAry[i] == "mht" ? "/ezApprovalG/draftContent.do" : "/ezApprovalG/draftContentAll_WHWP.do") + "?frameNum=" + newTabIdx + "&docHref=" + encodeURI(pFormHrefAry[newTabIdx]) + "&docID=" + encodeURI(pDocIDAry[newTabIdx]);
 						addString = addString + "<iframe name=\"ifrm" + newTabIdx + "\" id=\"ifrm" + newTabIdx + "\" style=\"width:100%; height:" + wh + "px; border:0px\" onload=\"getReSize()\" src=\"" + iframeURL + "\"></iframe></div>";
 						
	                    $("div.tab_container").append(addString);
	                    HiddenMailProgress();
	                }
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
	            
	            // 자식창 내부 iframe 영역 리사이즈 (자식창의 함수가 로딩된 경우에만 동작)
	            var currIfrm = document.getElementById("ifrm" + objNum);
	            if (typeof(currIfrm.contentWindow.Resize) == "function") {
	            	//currIfrm.contentWindow.Resize();
	            }
	            
                var tmp = currIfrm.contentDocument.getElementById("hwpctrl_frame");
                if (tmp) {
	               // tmpVal = tmp.style.height;
	               // tmp.style.height = "100%";
	               // setTimeout(function(){tmp.style.height = tmpVal;},100);
	                tmp.contentDocument.getElementById("ImeWrapper_Elm").focus();
                }
	        }
	        
	        // 안 추가 이후 부모창 배열에 해당 안의 정보를 저장 (안 별도로 관리하는 파라미터만 배열 사용, 나머지 파라미터는 공통 사용)
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
        		FormHref = undefined2EmptyString(pFormHrefAry[currentTabIdx]);
        		pHasAttachYN = undefined2EmptyString(pHasAttachYNAry[currentTabIdx]);
        		pHasDocAttachYN = undefined2EmptyString(pHasDocAttachYNAry[currentTabIdx]);
        		pHasOpinionYN = undefined2EmptyString(pHasOpinionYNAry[currentTabIdx]);
				
				SummaryOuterReceiverList = undefined2EmptyString(SummaryOuterReceiverListAry[currentTabIdx]);
   		        fileOpenFlagList = undefined2EmptyString(fileOpenFlagListArr[currentTabIdx]);
   		        
				DocSN = undefined2EmptyString(DocSNAry[currentTabIdx]);
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
	        
	        // iframe 리사이즈 (1안이 존재하는 경우에만)
	        function getReSize() {
	            var ifrm1 = document.getElementById("ifrm1");
	            if (ifrm1 != null && typeof(ifrm1) != "undefined") {
	                var viewTabCnt = Number(newTabIdx);
	                $("div.tab_container").css("min-height", window.innerHeight - 169);
	                
	                for (var i = 0; i < viewTabCnt; i++) {
	                    var viewTabNo = Number(i) + 1;
//	                    var wh = window.innerHeight - 69;
	                    var wh = window.innerHeight - 169; // 첨부파일영역 추가로 리사이즈 조정
	                    var Frame_name = document.all("ifrm" + viewTabNo);
	                    
	                    if (Frame_name != null && typeof(Frame_name) != "undefined") { // 각 iframe이 존재하면 높이를 셋팅
	                        Frame_name.style.height = wh + "px";
	                    }
	                }
	            }                       
	        }
	        
	        // 1안 추가 시, 안 내부에서 호출한 부모창의 최초 onload 동작
			function winOnload() {
        		// iframe 객체로 HwpCtrl 초기화 (ifrm1을 사용)
        		HwpCtrl = document.getElementById("ifrm1").contentWindow.HwpCtrl;
        		lstAttachLink = document.getElementById("lstAttachLink");
	        	
                setMenuBar("btnSendDraft", true);

                IsSkipDrafter = "FALSE"
                DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
                
                pFormHrefAry[0] = FormHref;
                pSusinSN = SusinSN;
                pDocState = DocState; // 초기 기안 시나 임시저장된 문서를 여는 경우에는 값이 없다. 반송문서 재기안 시 001값을 가진다. (문서상태 : 001/대기, 결재상태 : 004/반송)
                pDocState = ConvertDocState(pDocState);
	        }
	        
	        // 안 삭제 시, 배열 데이터도 제거 (아예 배열 길이가 줄어들게 됨)
	        function deleteAnAry(idx) { // (1안부터 시작) 안별 idx
	        	idx = parseInt(idx);
	        	delTabDocIDAry.push(pDocIDAry[idx]); // 안삭제 시, DB상에서도 삭제할 문서의 DOCID를 배열에 저장
	        
	        	pDocIDAry = pDocIDAry.slice(0, idx).concat(pDocIDAry.slice(idx + 1)); // 문서ID
	        	newpDocIDAry = newpDocIDAry.slice(0, idx).concat(newpDocIDAry.slice(idx + 1)); // 임시저장 반복 시, 새로 부여되는 문서ID
	        	DocSNAry = DocSNAry.slice(0, idx).concat(DocSNAry.slice(idx + 1)); // 임시저장 또는 재기안 시, 순번 저장 배열
	        	pDocTypeAry = pDocTypeAry.slice(0, idx).concat(pDocTypeAry.slice(idx + 1)); // 문서타입
	        	pDocTitleAry = pDocTitleAry.slice(0, idx).concat(pDocTitleAry.slice(idx + 1)); // 문서제목
	        	pFormIDAry = pFormIDAry.slice(0, idx).concat(pFormIDAry.slice(idx + 1)); // 양식ID
	        	pFormHrefAry = pFormHrefAry.slice(0, idx).concat(pFormHrefAry.slice(idx + 1)); // 양식경로 (사실상 문서경로)
	        	
	        	pSuSinFlagAry = pSuSinFlagAry.slice(0, idx).concat(pSuSinFlagAry.slice(idx + 1)); // 수신플래그
	        	SignInfoAry = SignInfoAry.slice(0, idx).concat(SignInfoAry.slice(idx + 1)); // 서명정보
	        	hapyuiCountAry = hapyuiCountAry.slice(0, idx).concat(hapyuiCountAry.slice(idx + 1)); // 합의칸정보
	        	SignCountAry = SignCountAry.slice(0, idx).concat(SignCountAry.slice(idx + 1)); // 서명칸정보
	        	gamsaCountAry = gamsaCountAry.slice(0, idx).concat(gamsaCountAry.slice(idx + 1)); // 감사칸정보
	        	
	        	pHasAttachYNAry = pHasAttachYNAry.slice(0, idx).concat(pHasAttachYNAry.slice(idx + 1)); // 일반첨부 플래그
	        	pHasDocAttachYNAry = pHasDocAttachYNAry.slice(0, idx).concat(pHasDocAttachYNAry.slice(idx + 1)); // 문서첨부 플래그
	        	pHasOpinionYNAry = pHasOpinionYNAry.slice(0, idx).concat(pHasOpinionYNAry.slice(idx + 1)); // 의견 플래그
	        	
	        	// 결재정보 > 문서정보들 중 안별 관리 정보
				btnReceivLineEnableAry = btnReceivLineEnableAry.slice(0, idx).concat(btnReceivLineEnableAry.slice(idx + 1)); // 수신처 존재 여부
				SummaryOuterReceiverListAry = SummaryOuterReceiverListAry.slice(0, idx).concat(SummaryOuterReceiverListAry.slice(idx + 1)); // 외부수신자 리스트
				extAry = extAry.slice(0, idx).concat(extAry.slice(idx + 1)); // 확장자 리스트
				fileOpenFlagListArr = fileOpenFlagListArr.slice(0, idx).concat(fileOpenFlagListArr.slice(idx + 1)); // 첨부파일 공개여부 플래그
	        }
	        
	        // 반송 및 회수된 문서를 재기안하는 경우, 안삭제 -> 결재올림 완료 시 안삭제된 문서는 실제로 삭제한다. 
	        // 기존 일괄기안그룹 데이터는 결재올림 시 saveAprGroupAndDelTmp()함수로 자동 제거되며, 전체적으로 새롭게 삽입된다.
	        function removeDelTabDoc() {
	        	for (var i = 0; i < delTabDocIDAry.length; i++) {
	        		RemoveDoc(delTabDocIDAry[i], orgCompanyID);
	        		//delGroupDocInfoByDocID(delTabDocIDAry[i], "ONE");
	        	}
	        }
	        
	        // 결재정보 호출 전, 모든 안의 양식을 체크하여 결재서명칸/합의서명칸의 갯수 중 가장 작은 값을 설정한다.
	        function setLowerSignCount() {
	            // mht 자동결재선 용으로 20으로 먼저 설정
	        	lowerSignCnt = 20;
	        	lowerSignTab = 1;
	        	lowerHapyuiCnt = 20;
	        	lowerHapyuiTab = 1;
	        	
	        	for (var i = 1; i < pDocIDAry.length; i++) {
	        	    var isHWP = extAry[i] == "hwp";
	        	    var isAuto = document.getElementById("ifrm" + i).contentDocument.getElementById("autoLine");
	        		if (SignCountAry[i] < lowerSignCnt && (isHWP || !isAuto)) {
	        			lowerSignCnt = SignCountAry[i];
	        			lowerSignTab = i;
	        		}
	        		
	        		if (hapyuiCountAry[i] < lowerHapyuiCnt && (isHWP || !isAuto)) {
	        			lowerHapyuiCnt = hapyuiCountAry[i];
	        			lowerHapyuiTab = i;
	        		}
	        	}
	        }
	        
			/* 2023-04-20 홍승비 - 일괄기안된 문서는 모든 안에 대해 결재선이 동일하므로, 부모창에서 한번만 호출 */
			function getLineModeAll(pDocID) {
				// 재기안(APR), 임시저장(TMP) 분기처리
				if (DraftFlag == "REDRAFT" && ListType == "21") {
					pModeForAllDocInfo = "TMP";
	 				pModeForAllAttachInfo = "TMP";
				}
				else {
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
			 			},
			    		error : function (e) {
			    			console.log(e);
			    		}
					});
				}
			}
			
			function getDocInfoAll(pDocIDAry) {
				try {
				    var result = new Array(); // 배열로 결재문서 정보 받기
				    
					$.ajax({
			    		type : "POST",
			    		dataType : "json",
			    		async : false,
			    		url : "/ezApprovalG/getDocInfoAll.do",
			    		data : {
			    			docIDArr : pDocIDAry
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

			function DocumentComplete(frame) {
                try {
                    if (ListType == "21") {
                        btnSendDraftEnable = "true";
                        SummaryFlag = true;
                    }
                    var frameName = frame.name;
                    var frameNum = frameName.substring(4);
                    pFormID = pFormIDAry[frameNum];
                    setInitLoadDocCellInfo(document.getElementById(frameName).contentWindow);
                    if (!pFormID && DraftFlag == "REDRAFT" && !pDocIDAry[frameNum]) {
                        var pAlertContent = "잘못된 양식 문서입니다.";
                        OpenAlertUI(pAlertContent);
                    }
                    frame.Set_EditorContentURL(pFormHrefAry[frameNum]);
                }
                catch (e) {
                    OpenAlertUI("DocumentComplete : " + e.description);
                }
            }

            function setInitLoadDocCellInfo(message) {
                try {
                    var i;
                    var j;
                    var k;
                    var fieldsign;
                    var fieldTmpsign;
                    var fieldseumyung;
                    var fieldTmpseumyung;
                    var fieldseumyungdate;
                    var fieldTmpseumyungdate;
                    var field;
                    var RtnVal;
                    var SignArray = new Array();
                    var SignArrayLen;

                    SignArray[0] = "sign";
                    SignArray[1] = "habyuisign";

                    var fieldSN = 1;
                    var fieldNum = 1;
                    var fields = message.GetFieldsList();

                    SignArrayLen = SignArray.length;

                    if (!fields) return;

                    for (k = 0 ; k < SignArrayLen ; k++) {
                        for (i = 0 ; i < fieldNum ; i++) {
                            if (i == "0") {
                                fieldsign = SignArray[k];
                                fieldseumyung = "seumyung";
                                fieldseumyungdate = "seumyungdate";
                            } else {
                                fieldsign = i + SignArray[k];
                                fieldseumyung = i + "seumyung";
                                fieldseumyungdate = i + "seumyungdate";
                            }
                            fieldTmpsign = fieldsign + 1;
                            field = message.GetListItem(fields, fieldTmpsign);
                            if (field) {
                                for (j = 0 ; j < fieldSN ; j++) {
                                    fieldTmpsign = fieldsign + (parseInt(j) + 1);
                                    fieldTmpseumyung = fieldseumyung + (parseInt(j) + 1);
                                    fieldTmpseumyungdate = fieldseumyungdate + (parseInt(j) + 1);

                                    field = message.GetListItem(fields, fieldTmpsign);

                                    if (field) {
                                        field.textContent = "";
                                        field = message.GetListItem(fields, fieldTmpseumyung);
                                        if (field) {
                                            field.textContent = "";
                                        }

                                        field = message.GetListItem(fields, fieldTmpseumyungdate);
                                        if (field) {
                                            field.textContent = "";
                                        }

                                        fieldSN = parseInt(fieldSN) + 1;

                                    } else {
                                        fieldNum = parseInt(fieldNum) + 1;
                                        break;
                                    }
                                }
                            }
                            else {
                                break;
                            }
                        }
                    }
                } catch (e) {
                    alert("setInitLoadDocCellInfo()" + e.description);
                }
            }

            function FieldsAvailable(frame) {
                try {
                    var frameName = frame.name;
                    var frameNum = frameName.substring(4);
                    // 기안자 정보 xmluserInfo 변수는 onload 시 부모 페이지에서 가져온 값을 그대로 사용 (하단의 SetAutoPropertyValue에서 사용됨)
                    frame.SetAutoPropertyValue(frameNum);

                    frame.process_AfterOpen(frameNum);
                    // 현재 안 탭의 정보를 부모페이지에도 저장
                    setTabInfo(frameNum);

                    // 반송문서가 아닌 임시저장 문서의 경우, 안 추가 시 초기 고정수신처 세팅 진행
                    if (pDraftFlag != "REDRAFT" || (ListType == "21" && addFlag == true)) {
                        frame.setFirstDrafter(); // 기본 결재선 설정 및 고정수신처 설정 등을 진행 (ezDraftAll_WHWP.js > GetDraftAprLineInfo)
                        if(frameNum != 1 && TempsaveAprlineinfo != undefined){
                            var ret = new Array()
                            ret[0] = TempsaveAprlineinfo;
                            if(approvalFlag == "S")
                                frame.SGetDraftAprLineInfo(ret);
                            else
                                frame.GetDraftAprLineInfo(ret);
                        }
                    } else {
                        // 반송문서 재기안 또는 임시저장문서를 초기에 가져오는 분기 -> 이미 결재선 및 수신처가 지정된 상태이므로, 수신처가 존재하는지만 간단하게 확인해서 부모의 btnReceivLineEnableAry배열에 값을 넣는다.
                        if (ListType == "21") { // 임시저장된 문서
                            btnReceivLineEnableAry[frameNum] = frame.getReceiptExists(DocSNAry[frameNum], "TMP");
                        } else { // 반송된 문서 재기안
                            btnReceivLineEnableAry[frameNum] = frame.getReceiptExists(pDocIDAry[frameNum], "APR");
                        }
                    }

                    // 1안 이후에 추가된 안에는 1안의 정보를 복사해준다.
                    // 반송문서 또는 임시저장문서 재기안 시, 전체 문서 로딩 완료 이후 안 추가시에만 1안의 정보를 복사해준다.
                     if (addFlag == true) {
                         frame.CopyAndPasteContent(true);
                         frame.copyDoc();
                    }

                    //  모든 안이 순차적으로 로딩 완료되지 않으므로(비동기), 로딩 완료 카운트를 하나씩 증가시켜서 부모창의 파라미터에 부여한다.
                    // 재기안 상태이면서 addFlag가 아직 변경되지 않은 경우 (초기 로딩 상태 진행 중임)
                    if (pDraftFlag == "REDRAFT" && addFlag == false) {
                        if(extAry[frameNum] == "mht")
                            frame.SetEditable(true);

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

                            selTab(1); // 각 안을 전부 로딩한 뒤, 기본으로 1안을 선택하도록 한다.
                            HiddenMailProgress(); // 전부 완료 시 로딩중 이미지 제거
                            CheckOpinionYN(1); // 1안 기준으로 의견이 존재한다면 레이어팝업 표출
                        }
                    } else { // 한개씩 안추가하는 경우, 완료 후 바로 이미지 제거
                        HiddenMailProgress(); // 문서 로딩중 이미지 제거 (현재 iframe이 ready될때 호출된 ShowMailProgress를 문서 호출 완료하고 닫는 동작
                    }
                } catch (e) {
                    console.log(e);
                    alert("apprGdraftuiAllContent_WHWP.FieldsAvailable()  ::  " + e.description);
                }
            }

            function setKeepPeriod(currIfrm) {
                try {
                    // viewTabNum = $("dl.tab_menu dt").length;
                    // for (var i = 1; i < viewTabNum; i++) { // 1안부터 시작
                    // var ifrm = document.getElementById("ifrm" + i);
                    if (!currIfrm.contentWindow.FieldExist("keepperiod")) { // 보존연한 필드가 양식에 없다면 다음 루프로 이동
                        return;
                    }
                    var keepperiodText = "";

                    switch (keepperiod) {
                        case '01':
                            keepperiodText = "1년";
                            break;
                        case '03':
                            keepperiodText = "3년";
                            break;
                        case '05':
                            keepperiodText = "5년";
                            break;
                        case '10':
                            keepperiodText = "10년";
                            break;
                        case '20':
                            keepperiodText = "30년";
                            break;
                        case '30':
                            keepperiodText = "준영구";
                            break;
                        case '40':
                            keepperiodText = "영구";
                            break;
                    }
                    currIfrm.contentWindow.PutFieldText("keepperiod", keepperiodText);
                    // }
                } catch (e) {
                    alert("ezdraftuiAll.setKeepPeriod()  ::  " + e);
                }
            }

            //S전용
            function SetDocOption(pkeeperiodvaltemp) {
                try {
                    viewTabNum = $("dl.tab_menu dt").length;
                    for (var i = 1; i < viewTabNum; i++) { // 1안부터 시작
                        var ifrm = document.getElementById("ifrm" + i);
                        if (ifrm.contentWindow.FieldExist("keepperiod")) {
                            ifrm.contentWindow.PutFieldText("keepperiod", pkeeperiodvaltemp);
                        }
                        if (ifrm.contentWindow.FieldExist("securitylevel")) {
                            ifrm.contentWindow.PutFieldText("securitylevel", tempSecurityValue);
                        }
                        if (ifrm.contentWindow.FieldExist("publication")) {
                            ifrm.contentWindow.PutFieldText("publication", tempPublic == "N" ? "<spring:message code='ezApproval.t49'/>" : "<spring:message code='ezApproval.t50'/>");
                        }
                        if (ifrm.contentWindow.FieldExist("docnumber") && tempItemCode != "") {
                            var tempdocnumber = ifrm.contentWindow.GetFieldText("docnumber")
                            tempdocnumber = tempdocnumber.replace(tempdocnumcode, tempItemCode);
                            ifrm.contentWindow.PutFieldText("docnumber", tempdocnumber);
                        }
                    }
                } catch (e) {
                    alert("ezdraftuiAll.setKeepPeriod()  ::  " + e);
                }
            }
			
			// 안체크하여 존재하는 안이 있을때만 실행함
			function btnSummaryEdit_before() {
				if (!btnChk()) {
					return false;
				} else {
					btnSummaryEdit()
				}
			}
	    </script>
	</head>
	<body class="popup" style="overflow:hidden;">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
						<%-- 2022-06-30 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
				        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
							<li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
							<li id="btnSummary"><span onclick="return btnSummaryEdit_before()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
	                        <li id="btnAddSepAttach"<c:if test="${approvalFlag == 'S'}"> style="display:none"</c:if>><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSaveServer"><span onclick="return btnSaveServer_onclick()"><spring:message code='ezApprovalG.t4000'/></span></li>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
	                        
	                        <%-- 일괄기안 양식선택 및 안추가/삭제 영역 --%>
	                        <li class="sel">
	                    		<select id="selForm" style="height:29px;">
	                        		<option value="" style="text-align: center">=========== <spring:message code='ezApprovalG.t152'/> ===========</option>
	                        		<c:forEach var="item" items="${apprGFormVOList}">
	                        			<option value="<c:out value='${item.formID}'/>|<c:out value='${item.formDocType}'/>|<c:out value='${item.formFileLocation}'/>"><c:out value="${item.formName}"/></option>
	                        		</c:forEach>
	                    		</select>
	                		</li>
	                		<li id="btnAddApproval"><span  onClick="return btnAddApproval_onclick()"><spring:message code='ezApprovalG.HSBDa02'/></span></li>
	                		<li id="btnDelApproval"><span  onClick="return btnDelApproval_onclick()"><spring:message code='ezApprovalG.HSBDa03'/></span></li>
	                    </ul>
	                    
 	                    <ul style="display: none;">
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><spring:message code='ezApprovalG.t9994'/></span></li>
	                        <li id="btnSetReceivLine"><span onclick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t154'/></span></li>
	                        <li id="btnSetAprLine"><span onclick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li>
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
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>


<%-- 각 웹에디터 파트는 content 페이지로 이동 --%>
<%-- 	        <tr>
	        	<td style="padding-bottom:10px;height:820px;" id="messageWHWPEditor">
	        	<td style="padding-bottom:10px;height:800px;" >
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr> --%>

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
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px; solid #d5d5d5; overflow: auto;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style="width:30%; overflow: auto;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
	                        </td>
							<td class="pos2" style="display:none;width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
							</td>
	                        <!-- 2020-11-30 심기영 기안창에서 뺌 -->
	                    </tr>
	                </table> 
	                
	                <%-- 대용량첨부 가이드 메세지 영역 --%>
	                <table id="apprAttachGuideTBL" class="file" style="height: 20px;">
	                    <tr id="apprAttachGuideTR"></tr>
	                </table>
	            </td>
	        </tr>
	        
	    </table>
	    <xml id="SA_coredata"></xml>
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
