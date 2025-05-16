<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t1'/></title>
		<meta http-equiv="Content-Type" content="text/html;" charset="utf-8" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/signSplit_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprovUI_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		
		<script ID="clientEventHandlersJS" type="text/javascript">                                                                                        
		    var OrgAprUserID		= "<c:out value ='${uID}'/>";
		    var OrgAprUserName		= "<c:out value ='${name}'/>";
		    var OrgAprUserName2		= '';
		    var OrgAprUserDeptID	= "<c:out value ='${deptID}'/>";
		    var pEndDocHref			= "<c:out value ='${dirPath}'/>";
		    var pDocID = "<c:out value ='${docID}'/>";
		    var pingUserID = "<c:out value ='${tempUserID}'/>";
		    var pDocInfo		= null;
		    var pDocHref		= new String("");
		    var pUserID			= new String("");
		    var pHasAttachYN	= new String("");
		    var pAprMemberSN	= 0;
		    var flag			= false;
		    var Btnflag   = "true";
		    var FormProc	= null;
		    var arrPrevDoc = new Array();
		    var arrNextDoc = new Array();
		    var xmlhttp		= createXMLHttpRequest();	
		    var xmldoc		= createXmlDom();
		    var xmlaprline	= createXmlDom();
		    var xmlattach	= createXmlDom();
		    var Resultxml   = createXmlDom();
		    var hapyuiCount = 0;
		    var gongramCount = 0;
		    var pSuSinFlag;
		    var pChamJoFlag;
		    var pReDraftAprLineFlag;
		    var HapyuiArea = 0;
	        var AprLineArea = 0;
		    var SignCount = 0;
		    var SignInfo;
		    var pAprLineType;
		    var gamsaCount = 0;
		    var pDraftFlag;
		    var pSusinSN;
		    var pOrgDocID;
		    var pDocType;
		    var OrgHtml;
		    var invalidflag = false;
		    var LineModify = false;
		    var pOrgAprUserID;
		    var	pOrgAprUserName;
		    var	pOrgAprUserJobTitle;
		    var	pOrgAprUserDeptID;
		    var	pOrgAprUserDeptName;
		    var docAccess = false;
		    var modeflag = true;
		    var isjunkyul = false;
		    var gPublic = "";
		    var pDocTitle = "";
		    var pFormID = "";
		    var drafterDeptid = "";
		    var pMaxFileSize = "5";
		    var LastSignNo;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
		    var TempsaveAprlineinfo;
		    var aprlineinfoTMP;
		    var modarpline = "";
		    var SummaryFlag = true;
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var RootURL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port;
		    var arr_userinfo = new Array();
		    var onlydocinfiview;
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[7]  = "N";
		    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
		    arr_userinfo[17]  = "<c:out value ='${userInfo.primary}'/>";
		    var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
		    var companyID = "<c:out value = '${userInfo.companyID}'/>";
		    var KuyjeType = "002";
		    var signDateFormat = "<c:out value ='${optSignDateFormat}'/>";
		    var isSplit = "<c:out value ='${optIsSplit}'/>";
		    var SplitKind = "<c:out value ='${optSplitKind}'/>";
		    var junKyulInfo = "<c:out value ='${optJunKyulInfo}'/>";
		    var FirstHtml = "";
		    var beforeHtml;
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "";
		    var cabinetID = "";
		    var TaskCode = "";
		    var DocNumCode = "";
		    var allFlag = "<c:out value ='${allFlag}'/>";
		    var selectedDocID = "";
		    var OpinionAction = "";
		    var CurrYear = "<c:out value ='${oldYear}'/>";  
		    var StartMode = "0";
		    var mhtData;
		    var pGubun;
		    var isExtDoc;
		    var pMailEditor = "<c:out value ='${crossEditor}'/>";
		    var pPageType = "APPROVUI";
		    var approvalFlag = "<c:out value ='${approvalFlag}'/>";
		    var junGyulFlag = "<c:out value ='${junGyulFlag}'/>";
		    var pSignImage_Size = "<c:out value ='${signImageSize}'/>";
		    var pADMIN = "N";
		    var docNumZeroCnt = "<c:out value ='${docNumZeroCnt}'/>";
		    var DeptSymbol; // 문서채번 시 사용되는 부서명 관련 변수
		  	//회람
			var type = "ING";
			var pGongRamDocID = "";
			var approvalType = "DRAFT";
			var signImageType = "<c:out value ='${signImageType}'/>";
			
			//최종 결재 개인합의 추가
			var addLastKyulJeYN = "<c:out value ='${addLastKyulJeYN}'/>";
			var totalMemSN = "0";
			var LastTotalKyulSN = "0";
			var lastHabYuiSN;
			var agreeReturnType = "<c:out value ='${agreeReturnType}'/>";
			var curDocNum = "";
			var draftDeptID = "<c:out value ='${draftDeptID}'/>";
			var isHWP = "";
			var ext = "mht";
			var nonElecRec = "<c:out value ='${nonElecRec}'/>";
	        var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
			
			var docState = "<c:out value ='${docState}'/>";
			var orgCompanyID = "<c:out value ='${orgCompanyID}'/>";
			
			//최종결재시 채번
			var useReceiveDocNo = "<c:out value ='${useReceiveDocNo}'/>";
			
			//2018-11-07 배현상, 결재자 순번
			var wAprMemberSN = "";
			
			//원문공개정보
            var useOpenGov = "<c:out value ='${useOpenGov}'/>";
			var basis = "<c:out value ='${basis}'/>";
			var reason = "<c:out value ='${reason}'/>";
			var listOpenFlag = "<c:out value ='${listOpenFlag}'/>";
			var fileOpenFlagList = "<c:out value ='${fileOpenFlagList}'/>";
			
			//2020-01-23 김은석 추가
			var useAnnualSusinYN = "<c:out value ='${useAnnualSusinYN}'/>";
			
			var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			var formAprOption = "<c:out value='${formAprOption}'/>";
			
			var isReform = "<c:out value='${isReform}'/>";
			var formId = "<c:out value='${formId}'/>";
			
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
		    
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
	        
			var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>";
			var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임)
			var draftJunGyulFlag = "<c:out value ='${draftJunGyulFlag}'/>"; // 일반버전 서명 remapping 시 전결문자 표출 확인용 (0 : 미표출 / 1 : 표출, default)
			
			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
			
			// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
			var useHideHeaderArea = "<c:out value ='${useHideHeaderArea}'/>";

			var tenantID = "<c:out value ='${userInfo.tenantId}'/>";
			
			// 2024-06-11 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부
			var useReceiptDeptFileAttach = "<c:out value ='${useReceiptDeptFileAttach}'/>";

			// 2024-06-24 양지혜 - 지정반송 기능 사용여부
			var useReturnByDesignation = "<c:out value ='${useReturnByDesignation}'/>";
			
			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";
	        
			// 2024-12-10 기민혁 - 수정버전 변경 기능 사용여부
			var editVersionYN = "<c:out value ='${editVersionYN}'/>";
			// 2024-12-10 기민혁 - 수정버전 
			var editVersion = "";
			// 2024-12-10 기민혁 - 수정버전 모드
			var editMode = "";

            // 2025-02-18 박기범 - 프론트에서 문서 편집시, 문서를 오픈한 이후로 다른 문서/결재진행 변화가 있었는지 체크하기 위한 코드
            var snapshotCode = "<c:out value ='${snapshotCode}'/>";
            
            var drafterName = "<c:out value ='${drafterName}'/>";
		    var drafterDept = "<c:out value ='${drafterDept}'/>";
		    var formName = "<c:out value ='${formName}'/>";
			
			window.onload = function () {
		        if (allFlag == "2") {
		            selectedDocID = window.opener.selectedDocIDS;
		        }
		        
		    	if(approvalFlag == "G") {
	        		$("#btnAddSepAttach").css("display","");
	        	} 
		    	
		    	if(useExternalMailServer == "NO") {
		    		$("#btnMail").css("display","");
		    	}

				if (useReturnByDesignation == "YES") {
					document.getElementById("btnReject2").style.display = "";
				}

		    	var officeFlag = this.officeFlag;
		    	
		    	if(isReform) {
		    		document.getElementById("message").src = "approvUIcontent.do?isReform=" + isReform + "&formId=" + formId;
		    	} else {
		    		document.getElementById("message").src = "approvUIcontent.do";
		    	}
		    	
		    	$("#message").load(function() {
					var selectOp = $("#selectImg option").length;
					if(selectOp == 1){
						$("#selectImg option").remove();
					}
					var val = parseInt($("#selectImg option:selected").val());
					var divImg = $("#message").contents().find(".divImg");
					var pages = $(divImg).children().length;
                    if (pFormID != "2021000000" ) {
						if (selectOp == 1) {
							for (var i = 1; i <= pages; i++) {
								if (i <= pages) {
									$("#selectImg").append("<option value='" + i + "'>" + i + " / " + pages + " Page</option>");
								}
							}
						}
						if (pages > 1) {
							window.resizeTo(1920, 1200);
							var sw = screen.width;
							var sh = screen.height;
							var cw = document.body.clientWidth;
							var ch = document.body.clientHeight;
							var top = sh / 2 - ch / 2 - 100;
							var left = sw / 2 - cw / 2;
							$("#officeBtn").css("display", "");
							var selectNum = $("#message").contents().find(".divImg").find(".imgDiv").index();
							$("#selectImg option:eq(" + selectNum + ")").prop('selected', true);
						}
					}

					if(divImg.length > 0){
					    imgTag = divImg.find("img").get(0);
					    if(typeof imgTag != "undefined"){
                            imgTag.onload = function() {
                                officeImgExist = true;
                            }
					    }
                        setTimeout(satImgCheck,3000);
					}
				});
				
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
		    };
		    
		    function getNextDocList()
		    {
		        NextDocID = "";
		        if (selectedDocID != "")
		        {
		            var xmldoclist = createXmlDom();
		            xmldoclist.async = false;
		            xmldoclist = loadXMLString(selectedDocID);
		            if (xmldoclist.documentElement.childNodes.length > 0)
		            {
		                var breakflag = false;
		                for (var i=0; i<xmldoclist.documentElement.childNodes.length; i++)
		                {
		                    if (xmldoclist.documentElement.childNodes(i).text == pDocID)
		                        breakflag = true;
		                    else if (breakflag)				
		                    {
		                        breakflag = false;
		                        getNextDocOne(xmldoclist.documentElement.childNodes(i).text);
		                    }
		                }
		            }		
		        }
		    }
		    var ezaprallalert_cross_dialogArguments = new Array();
		    function OpenAllApproveFlag()
		    {
		        AllApprove.style.display = "none";
		
		        ezaprallalert_cross_dialogArguments[0] = "";
		        ezaprallalert_cross_dialogArguments[1] = OpenAllApproveFlag_Complete;
		
		        DivPopUpShow(326, 205, "/ezApprovalG/ezAprAllAlert.do");
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
		            if (allFlag == "1") {
		                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t2'/>");
		            }
		            else if (allFlag == "2") {
		                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t2'/>");
		            }
		        }
		        else if (RtnVal == "2") {
		            return;
		        }
		        else if (RtnVal == "3") {
		            window.close();
		            btnClose_onclick();
		        }
		    }
		    function LoadNextDocument(tempString)
		    {
		        if (allFlag == "1") {
		            getNextDocInfo();
		        } else if (allFlag == "2") {
		            getNextDocList();
		        }
		
		        if (NextDocID == "") {
		            if (tempString == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t3'/>";
		            } else {
		                tempString = tempString.replace("\n" + "<spring:message code='ezApprovalG.t2'/>", "");
		                tempString = tempString.replace("\n\n" + "<spring:message code='ezApprovalG.t4'/>", "");
		                tempString = tempString.replace("\n", "");
		                var pAlertContent = tempString + "<br>" + "<spring:message code='ezApprovalG.t3'/>";
		            }
		            
					OpenAlertUI(pAlertContent, btnClose_onclick); // 알림창 확인 시 문서창 닫도록 수정
		            //window.parent.close();
		           // btnClose_onclick();
		        } else {
		            if(NextDocExtended.substring(NextDocExtended.lastIndexOf(".")+1) != "mht") {
		                openOtherApprovUI();
		                return;
		            }
		            DocNumCode = "";
		            pDocID = NextDocID;
		            OrgAprUserID = NextDocUserID;
		            OrgAprUserName = NextDocUserName;
		            OrgAprUserName2 = NextDocUserName2;
		            OrgAprUserDeptID = NextDocDeptID;
		            pEndDocHref = "/fileroot/" + "<c:out value ='${userInfo.tenantId}'/>" + "/files/upload_approvalG/" + pCompanyID + "/doc/" + CurrYear + "/" + (pDocID % 1000) + "/" + pDocID + ".mht";
		            getApprovInfo();
		            pUserID = pOrgAprUserID;
		            getDocInfo();  
		            setAttachInfo(pDocID, "APR", lstAttachLink);
		            GetExchInfo();
		            if (pDocHref != "")
		            {
		                message.Set_EditorContentURL(pDocHref);
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
		        if (NextDocExtended.toLowerCase() == "doc") {
		            var openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID="+escape(pArgument[0]);
		            openLocation = openLocation + "&uID="+escape(pArgument[1])+"&uName="+escape(pArgument[2]) + "&uName2="+escape(pArgument[4]);
		            openLocation = openLocation + "&uDeptID="+escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		        } else if (NextDocExtended.toLowerCase() == "hwp" && useWebHWP == "NO") {
		            var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&ID=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag);
		        } else if (NextDocExtended.toLowerCase() == "hwp" && useWebHWP == "YES") {
		            var openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag);
		        } else {
		            var openLocation = "/myoffice/ezApprovalG/ApprovUI/approvui_CK.aspx?DocID="+escape(pArgument[0]);
		            openLocation = openLocation + "&uID="+escape(pArgument[1])+"&uName="+escape(pArgument[2]) + "&uName2="+escape(pArgument[4]);
		            openLocation = openLocation + "&uDeptID="+escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		        }
		        try {
		            window.opener.openwindow(openLocation, "" , 880 , 550);
		            window.close();
		        } catch(e) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t5'/>";
		            OpenAlertUI(pAlertContent);
		            window.close();
		            btnClose_onclick();
		        }
		    }
		    
		    function DocumentComplete()
		    {
		        if (flag == false) 
		        {
		            flag = true;
		            getApprovInfo();
		            pUserID = pOrgAprUserID;
		            getDocInfo();
		            setAttachInfo(pDocID, "APR", lstAttachLink);
		            GetExchInfo();
					DeptSymbol = getDeptSymbol(arr_userinfo[4], replaceEntityCodeToStr(arr_userinfo[5]));
		            
			    	if (nonElecRec == "Y") {
				        getNonElecInfoSusinInit();
						document.getElementById("btnAddSepAttach").style.display = "none";
			        }
		            
		            if (pDocHref != "")
		            {
		                message.Set_EditorContentURL(pDocHref);
				        setInitOpinion();
						// 기안할때만 일련변호 전까지 세팅해주고 그 이후엔 할 필요가 없음.
						// 오류때문에 한다고는 하지만 그렇게 할 필요가 있나 싶음. 그리고 웹한글도 그런 로직은 없음.
						// if (pDraftFlag != "SUSIN") {
						//     setDocNumFormat(""); // 결재할문서 오픈 시, docnumber 필드 다시 그리는 로직.. 수정 필요
						// }
		            }
		        }
		    }
		    var noFieldsAvailable = false;
		    function FieldsAvailable() {
		        var fields = message.GetFieldsList();
		        if (modeflag) {
		            CheckSignImg();			
		            if (noFieldsAvailable) {
		                noFieldsAvailable = false;
		            } else {
		                var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT");
		                if(!rtnVal) {
		                    return;				
		                }		
		                process_AfterOpen();
		                CheckOpinionYN();
		            }
		        }
		        message.SetEditable(false);
		        
		        checkHeaderAction();
		    }

			/* 2023-06-26 민지수 - 완료문서일 경우 분기처리를 위해 docstate 전달 */
		    function setInitOpinion() {
		    	var field = message.GetListItem(message.GetFieldsList(), "opinions");
		    	if (field) {
		            try {
		            	var result = "";
		                
		                $.ajax({
		            		type : "POST",
		            		dataType : "text",
		            		async : false,
		            		url : "/ezApprovalG/opinionRequest.do",
		            		data : {
		            			docID : pDocID,
		            			orgCompanyID : orgCompanyID,
								state : docState
		            		},
		            		success: function(xml) {
		            			result = xml;
		            		}        			
		            	});
	
		                var OpinionXML = loadXMLString(result);
		                var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
		                field.innerHTML = " ";
		                if (NodeList.length > 0) {
		                    for (i = NodeList.length - 1; i >= 0; i--) {
		                		var opinionsTable = '<p style="margin-top: 10px;margin-left: 3px;margin-bottom: 3px;">▶ ' + getNodeText(NodeList[i].childNodes[0].childNodes[11]) + ' - ' + getNodeText(NodeList[i].childNodes[0].childNodes[9]) + ' - ' + getNodeText(NodeList[i].childNodes[0].childNodes[7]) + '</p><p style="margin-top: 0px;margin-left: 10px;margin-bottom: 0px;">' + MakeXMLString(getNodeText(NodeList[i].childNodes[0].childNodes[3])) + '</p>';
		                		$(field).append(opinionsTable);
		                    }
		                }
		            } catch (e) {
		                showAlert("setInitOpinion ::" + e.description);
		            }
				}
		    }
		    
		    function CheckOpinionYN() {
		        if (pHasOpinionYN == "Y") {
		            var pInformationContent = "<spring:message code='ezApprovalG.t9'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		            OpenInformationUI(pInformationContent, CheckOpinionYN_Complete);
		        } else {
		            if (pDraftFlag == "SUSIN")
		                getSusinSNInfo();
		            else
		                pSusinSN = "0";
		
		            if (message.DocumentBodyGetAttribute(("KP_YGubun"))) {
		                setMenuBar("btnConn", true);
		                btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		            }
		            else {
		                setMenuBar("btnConn", false);
		            }
		            
		            if ("<c:out value ='${isPreview}'/>" != "Y") {
		            	AllApprove.style.display = "";
		            }
		            
		            if (allFlag == "1" || allFlag == "2") {
		                OpenAllApproveFlag();
		            }
		        }
		    }
		    function CheckOpinionYN_Complete(Ans) {
		        DivPopUpHidden();
		        if (Ans) {
		            //openOpinionUI("", CheckOpinionYN_Complete_Complete);
		        	openOpinionUI_New("", CheckOpinionYN_Complete_Complete);
		        } else {
		            if (pDraftFlag == "SUSIN") {
		                getSusinSNInfo();
		            } else {
		                pSusinSN = "0";
		            }
		            if (message.DocumentBodyGetAttribute(("KP_YGubun"))) {
		                setMenuBar("btnConn", true);
		                btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		        	}
			        else {
			            setMenuBar("btnConn", false);
			        }
		            
					if ("<c:out value ='${isPreview}'/>" != "Y") {
			        	AllApprove.style.display = "";
					}
					
			        if (allFlag == "1" || allFlag == "2") {
			            OpenAllApproveFlag();
			        }
		        }
		    }
		
		    function CheckOpinionYN_Complete_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "Clear") {
					pHasOpinionYN = "N";
				} else if (ret == "cancel") {
					//do_nothing
				} else {
			        var objXML = createXmlDom();
			        objXML = loadXMLString(ret);
			        
			        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
			        if (NodeList.length != 0) {
			            pHasOpinionYN = "Y";
			        } else {
			            pHasOpinionYN = "N";
			        }
				}
		        
		        if (pDraftFlag == "SUSIN")
		            getSusinSNInfo();
		        else
		            pSusinSN = "0";
		
		        if (message.DocumentBodyGetAttribute(("KP_YGubun"))) {
		            setMenuBar("btnConn", true);
		            btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		        }
		        else {
		            setMenuBar("btnConn", false);
		        }
		        
		        if ("<c:out value ='${isPreview}'/>" != "Y") {
		        	AllApprove.style.display = "";
		        }
		        
		        if (allFlag == "1" || allFlag == "2") {
		            OpenAllApproveFlag();
		        }
		    }
			/**
			* 각 결재타입마다 나타나는 경고창 출력 함수
			* 결재, 반송, 보류, 참조 등
			*/
		    function process_AfterApprove(mode)
		    {
				/* 2020-02-24 홍승비 - 결재문서의 변경내역(수정이력) 저장 시점을 편집 -> 저장 직후로 변경 */
/* 		        if (FirstHtml != "") {
		            UpdateDocHistory(FirstHtml);
		        } */
				
		        if (mode == "1")
		        {
		            if (allFlag == "1" || allFlag == "2")
		            {
		                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t11'/>");
		            }
		            else
		            {
		                var pAlertContent = "<spring:message code='ezApprovalG.t12'/>";
		                OpenAlertUI(pAlertContent, Draft_Complete);
		                return;
		            }	
		        }
		        else if (mode == "2")
		        {
		            if (allFlag == "1" || allFlag == "2")
		            {
		                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t13'/>");
		            }
		            else
		            {
		                var pAlertContent = "<spring:message code='ezApprovalG.t14'/>";
		                OpenAlertUI(pAlertContent, Draft_Complete);
		                return;
		            }
		        }
		        else if (mode == "3")
		        {
		            if (allFlag == "1" || allFlag == "2")
		            {
		                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t15'/>");
		            }
		            else
		            {
		                var pAlertContent = "<spring:message code='ezApprovalG.t16'/>";
		                OpenAlertUI(pAlertContent, Draft_Complete);
		                return;
		            }	
		        }
		        else
		        {
		            if (allFlag == "1" || allFlag == "2")
		            {
		                LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t17'/>");
		            }
		            else
		            {
		                var pAlertContent = "<spring:message code='ezApprovalG.t18'/>";
		                OpenAlertUI(pAlertContent, Draft_Complete);
		                return;
		            }	
		        }
		    }
		    function setbutton()
		    {
		        ChangeBtnState();
		    }

		    function process_AfterOpen()
		    {
		        getCurApproverAprLine("<c:out value ='${isUsed}'/>");
		        pGubun = "8";
		        
		        /* 2023-12-05 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
		        message.startRemapAllAprSign_MHT(pDocID, orgCompanyID);
		        
		        // 현재 문서가 수신문이면서 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
		        if (pDraftFlag == "SUSIN" && pOrgDocID != null && typeof(pOrgDocID) != "undefined" && pOrgDocID != "") {
		        	message.startRemapAllAprSign_MHT(pOrgDocID, orgCompanyID);
		        }
		        
		        if (approvalFlag == "S") {
			        if(pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12)  {
			            setMenuBar("btntotaldocinfo", false);
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
			        if(pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
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
			        } else if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			            setMenuBar("btnModAprLine", false);
			            pGubun = "5";
			        }
		        }
		        
		        if (KuyjeType == "001") {
		            if (pDraftFlag == "SUSIN" || pAprLineType == strAprType7 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
		                setMenuBar("btnReject", false);
						setMenuBar("btnReject2", false);
		                setMenuBar("btnStay", false);
		                setMenuBar("btnModAprLine", false);
		                setMenuBar("btnModAprDept", false);
		                pGubun = "7";
		            }
		        }
		        if(pDraftFlag == "SUSIN") {
		            var fields = message.GetFieldsList();
		            var field = message.GetListItem(fields, "susinbody");
		            if(field) {
		                setMenuBar("btnEdit", true);
		            } else {
		                setMenuBar("btnEdit", false);
		            }
		
		            setMenuBar("btnModAprDept", false);
		            
		            if (useReceiptDeptFileAttach == "NO") {
		            	setMenuBar("btnFileAttach", false);
			            setMenuBar("btnAprDocAttach", false);	
		            }
		            
		            pGubun = "6";
		        }
		        else {
		            pSuSinFlag = "N";		
		            var fields = message.GetFieldsList(); 
		            var RtnVal = message.GetListItem(fields, "recipient");
		            if(RtnVal != null) { 
		                pSuSinFlag = "Y";
		                setMenuBar("btnModAprDept", true);
		                
		            }else{
		                pSuSinFlag = "N";
		                setMenuBar("btnModAprDept", false);
		                if (pGubun == "5") {
		                    pGubun = "7";
		                } else {
		                    pGubun = "6";
		                }
		            }		
				}
//  		        SignCheck(); 
		        
		        if (pDraftFlag == "HABYUI") {
		            setMenuBar("btntotaldocinfo", false);
		        }

				// 2024-06-27 임정은 - 협조자도 공람자 지정할 수 있도록 변경
				if (approvalFlag == "G" && pGubun == "6" && (pAprLineType == strAprType8 || pAprLineType == strAprType9)) {
					pGubun = "14";
				}

		    }
		    function btnApprove_onclick()
		    {
	    		if (checkAprState()) {
	    			showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
		        try {
		            if (OrgAprUserID != arr_userinfo[1]) {
		                if (!confirm(OrgAprUserName + "<spring:message code='ezApprovalG.t2106'/>")) {
		                    window.returnValue = "CLOSE";
		                    btnClose_onclick();
		                    return;
		                }
		            }
		        } catch (e) {
		        }
		        setMenuDisable("btnApprove", true);
		        var signInfo;
		        if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pDraftFlag == "HABYUI" || pDraftFlag == "B_GAMSA" || pDraftFlag == "A_GAMSA") {
		                getLastOpinon();
		            }
		            var fields = message.GetFieldsList(); 	
		            var field = message.GetListItem(fields, "lastdraftdate");
		            if (field) {
		                var CurrentDate = getGyulJeDate();
		                setNodeText(field, CurrentDate);
		            }
		        }
		        if (!isjunkyul) {
		            //if ("${approvalPWD}" != "N") {
		            if (CheckUsePassword()) {
		                chk_Passwd(pingUserID, btnApprove_chkpassword_Complete);
		            }
		            else
		                check_openSingUI();
		        }
		        else {
		            check_openSingUI();
		        }
		    }
		
		    function check_openSingUI() {
		        var ret = "NAME";
		        if ((pAprLineType != strAprType2) && (pAprLineType != strAprType7) && (pAprLineType != strAprType15) && (pAprLineType != strAprType17)) {
		            var parameter = new Array();
		            parameter[0] = pDocID;
		            openSingUI(parameter);
		        }
		        else {
		            Approv_Complete(ret);
		        }
		    }
		    /**
		    * ExcuteInfo()를 통한 연동관리
		    * getDocNumber()를 통한 문서번호 채번
		    * ApprovMappingSign()를 통한 결재정보 내용 출력
		    * SaveApproveInfo()를 통한 xml 생성 및 Contoller 호출
		    */
		    function Approv_Complete(signtype) {
		        DivPopUpHidden();
		        if (checkAprState()) {
		        	showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			//모두결재인 경우 다음 문서로 넘어가도록 설정
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
		        
		        redrawMappingSign();
		        //UpdateLineHistory(); //결재선 변경이력 남기는 로직 위치변경 770->1004
		        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                var rtnVal = ExcuteInfo("DOCNUM_BEFORE");
		                if (!rtnVal) {
		                    return;
		                }
		            }
		        }
		        
		        var habYuiAprStateFlag = true;
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
		        
		        // getDocNumber를 이용한 문서번호 채번
		        // 합의문서일 경우 채번하기 위해 조건 추가함. 2019-02-21 홍대표
		        if (pDraftFlag != "SUSIN" && (pDraftFlag != "HABYUI" || pDraftFlag != "B_GAMSA")) {
		        	if (approvalFlag == "S") {
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
		        	} else {
						// 1 : 결재, 4 : 전결, 16 : 대결
						if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
							// 1 : 결재, 2 : 확인, 4 : 전결, 16 : 대결, 18 : 기안, 19 : 검토
							if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
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
			        		// 일단 복사해봄
			        		if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
				            	// 1 : 결재, 2 : 확인, 4 : 전결, 16 : 대결, 18 : 기안, 19 : 검토
				                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
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
		        	}
		        }
		        
		        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                var rtnVal = ExcuteInfo("DOCNUM_AFTER");
		                if (!rtnVal) {
		                    return;
		                }
		            }
		        }
		        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                var rtnVal = ExcuteInfo("LAST_SIGN_BEFORE");
		                if (!rtnVal) {
		                    return;
		                }
		            }
		        }
		        else {
		            var rtnVal = ExcuteInfo("MIDDLE_SIGN_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		        }
		        
		        signInfo = ApprovMappingSign(signtype); // 현재 양식에 결재 관련 정보 출력( ex. 서명 서명 날짜 등등)

		        var rtnVal = true;
		        if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                SetAutoPropFinal();
		                var rtnVal = ExcuteInfo("LAST_SIGN_AFTER");
		                if (!rtnVal) {
		                    return;
		                }
		            }
		        }
		        else {
		            var rtnVal = ExcuteInfo("MIDDLE_SIGN_AFTER");
		            if (!rtnVal) {
		                return;
		            }
		        }
		        if (rtnVal) {
		        	rtnVal = SaveApproveInfo("1");
		        }

		        if (rtnVal != "TRUE")  {
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
		        	
		            UndoSignInfo(signInfo);
                    if (fractionsymbol == "") {
                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t33'/>";
                        OpenAlertUI(pAlertContent);
                        setMenuDisable("btnApprove", false);
                        return;
                    }
                    
		            if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    var rtnVal = ExcuteInfo("END_FAIL");
		                    if (!rtnVal) {
		                        return;
		                    }
		                }
		            }
		            else {
		                var rtnVal = ExcuteInfo("MIDDLE_END_FAIL");
		                if (!rtnVal) {
		                    return;
		                }
		            }
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t34'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        else {
		        	//결재처리가 완료되었을때 결재선 변경이력 남기도록
		        	UpdateLineHistory();
		        	
		            if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    var rtnVal = ExcuteInfo("LAST_END_AFTER");
		                    if (!rtnVal) {
		                        return;
		                    }
		                    getOpinionInfo(pDocID, "END");
		                    SendMailToDrafter();
		                    SendMailToReceiveDept_Approv();
		    		        
		                    //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 수신부서 완료
		    		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
		    		        	var code = document.getElementById('message').contentWindow.document.getElementById('annual-conn-script').getAttribute("code");
		    		        	var script = document.createElement("script");
		    		        	var tempDocId = "";
		    					script.type = "text/javascript";
		    					script.innerHTML = code;
		    					document.querySelector("head").appendChild(script);

		    					//2020-01-23 김은석
		    					if (useAnnualSusinYN == "1") {
	    							tempDocId = pDocID;
		    					} else {
		    						if (pDocType == "001") {
	    								tempDocId = pDocID;
		    						} else {
	    								tempDocId = pOrgDocID;
		    						}
		    					}
		    					
		    		        	attitude_annual_conn(tempDocId);
		    		        }
		                } else {
		                	 CurrentAprType = pAprLineType;
		                     CurrentAprUserID = pUserID;
		                     sendAlertMail("APR", pAprMemberSN, "APPROV");
		                }
		            }
		            else {
		                var rtnVal = ExcuteInfo("MIDDLE_END_AFTER");
		                if (!rtnVal) {
		                    return;
		                }
		                CurrentAprType = pAprLineType;
                        CurrentAprUserID = pUserID;
		                sendAlertMail("APR", pAprMemberSN, "APPROV");
		            }
		            if ((pDraftFlag == "SUSIN" || pAprLineType == strAprType7) && KuyjeType == "001") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t35'/>";
		                OpenAlertUI(pAlertContent, Draft_Complete);
		                return;
		            }
		            else {
		                if (pAprLineType == strAprType7) {
		                    process_AfterApprove("4");
		                }
		                else {
		                    if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                        SendAckForExch("approval", "END");
		                    }
		                    else {
		                        SendAckForExch("approval", "ING");
		                    }
		                    process_AfterApprove("1");
		                }
		            }
		        }
		        setMenuDisable("btnApprove", false);
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
		
		    function openSingUI_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "cancel") {
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t29'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        Approv_Complete(ret);
		    }
		
		    function btnApprove_chkpassword_Complete(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "FALSE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        check_openSingUI();
		    }
		    function btnReject_onclick() {
		    	if (checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			window.returnValue = "CLOSE";
	    			btnClose_onclick();
	    			return;
	    		}
		    	
		        var pInformationContent = "<spring:message code='ezApprovalG.t36'/>";
		        OpenInformationUI(pInformationContent, btnReject_onclick_Complete);
		    }
		
		    function btnReject_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
		        //if ("${approvalPWD}" != "N") {
		        if (CheckUsePassword()) {
		            chk_Passwd(pingUserID, btnReject_chkpassword_Complete);
		        } else {
		            //openOpinionUI("BanSong", btnReject_option_Complete);
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
		        //openOpinionUI("BanSong", btnReject_option_Complete);
		        openOpinionUI_New("BanSong", btnReject_option_Complete);
		    }
		    /**
		    * '반송'
		    */
			var returnUserSN = "";
		    function btnReject_option_Complete(ret) {
				DivPopUpHidden();
				// 2024-06-24 양지혜 - 전자결재 > 지정반송
				if (ret != "cancel" && returnUserSN != "" && returnUserSN != "1") {
					returnByDesignation(ret, returnUserSN);
					return;
				}

		        if (ret != "cancel") {
		        	pHasOpinionYN = "Y";
		            UpdateLineHistory(); // '변경내역' 업데이트
		            var rtnVal = ExcuteInfo("BANSONG_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		            
		            if (checkAprState()) {
		            	showAlert("<spring:message code='ezApprovalG.bhs23'/>");
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
		    			return;
		    		}
		            
		            redrawMappingSign();
		            
		            signInfo = putBansongSign(); // '서명' 관련 정보 출력
					
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
			        
		            var RtnVal = SaveApproveInfo("2");
		            if (RtnVal != "TRUE") {
		            	UndoSignInfo(signInfo);
		                var rtnVal = ExcuteInfo("BANSONG_FAIL");
		                if (!rtnVal) {
		                    return;
		                }
		                var pAlertContent = "<spring:message code='ezApprovalG.t37'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            } else {
		                var rtnVal = ExcuteInfo("BANSONG_AFTER");
		                if (!rtnVal) {
      						return;
		                }
		                
		                SendMailBansongtoDrafter();
		                SendAckForExch("approval", "ING");
		                process_AfterApprove("2");
		                
		                //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 반송
	    		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
	    		        	var code = document.getElementById('message').contentWindow.document.getElementById('annual-conn-del-script').getAttribute("code");
	    		        	var script = document.createElement("script");
	    					script.type = "text/javascript";
	    					script.innerHTML = code;
	    					document.querySelector("head").appendChild(script);
	    					
	    		        	attitude_annual_conn(pDocID);
	    		        }
		            }
		            
		            objXML = createXmlDom();
			        objXML = loadXMLString(ret);
			        makeOpinionList4Bansong(objXML);
			        
		        } else if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t38'/>";
					if (returnChk == "Y") {
						pAlertContent = "<spring:message code='ezApprovalG.yjh05'/>";
						returnChk = "N";
					}
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btnStay_onclick() {
		    	if (checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
		    	
		        var pInformationContent = "<spring:message code='ezApprovalG.t39'/>";
		       OpenInformationUI(pInformationContent, btnStay_onclick_Complete);
		    }
		
		    function btnStay_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
		        //if ("${approvalPWD}" != "N") {
		        if (CheckUsePassword()) {
		            chk_Passwd(pingUserID, btnStay_chkpassword_Complete);
		        }
		        else {
		            //openOpinionUI("BoRyu", btnStay_option_Complete);
			        openOpinionUI_New("BoRyu", btnStay_option_Complete);
		        }
		    }
		
		    function btnStay_chkpassword_Complete(chkpass) {
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
		        //openOpinionUI("BoRyu", btnStay_option_Complete);
		        openOpinionUI_New("BoRyu", btnStay_option_Complete);
		    }
		
		    function btnStay_option_Complete(ret) {
		        DivPopUpHidden();
		        if (ret != "cancel") {
	                pHasOpinionYN = "Y";
		        	if (checkAprState()) {
		        		showAlert("<spring:message code='ezApprovalG.bhs23'/>");
		    			if (allFlag == "1") {
		    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
		    			} else {
			    			window.returnValue = "CLOSE";
			    			btnClose_onclick();
		    			}
		    			return;
		    		}
		        	
		        	var Rtnxml = createXmlDom();
		            Rtnxml = loadXMLString(ret);
		            makeOpinionList(Rtnxml);
		            
		        	redrawMappingSign();
		        	
		            UpdateLineHistory();
		            var RtnVal = SaveApproveInfo("3");
		
		            if (RtnVal != "TRUE") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t40'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            else {
		                process_AfterApprove("3");
		            }
		        } else if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t392'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btnJunKyul_onclick()
		    {
		        //if ("${approvalPWD}" != "N") {
		        if (CheckUsePassword()) {
		            var checkpass = chk_Passwd(pingUserID);
		            if (checkpass == "False") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            else if (checkpass == "cancel") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        isjunkyul = true;
		        var rtnVal = upDateAprLine();
		        if(rtnVal == "TRUE")
		        {
		            getCurApproverAprLine("<c:out value ='${isUsed}'/>");
		            btnApprove_onclick();
		        }
		        else
		        {
		            var pAlertContent = "<spring:message code='ezApprovalG.t41'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
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
		            getCurApproverAprLine("<c:out value ='${isUsed}'/>");
		        }
		    }
		    function btnModAprDept_onclick() {
		        try {
		            var ret = openReceivUI();
		            if (ret == "NONE") {
		                var fields = message.GetFieldsList();
		                var field = message.GetListItem(fields, "hrecipients");
		                if (field) field.textContent = "";
		                var field = message.GetListItem(fields, "recipient");
		                if (field) field.textContent = "";
		                var field = message.GetListItem(fields, "recipients");
		                if (field) field.textContent = "";
		            }
		            else if (ret != "cancel") {
		                setRecevInfo(ret);
		            }
		        }
		        catch (e) {
		            showAlert("btnModAprDept_onclick : " + e.description);
		        }
		    }
		    function btnOpinion_onclick() {
		        //openOpinionUI("");
		    	openOpinionUI_New("");
		    }
		    function btnMemo_onclick() {
		        openMemoUI();
		    }
		    function btnFileAttach_onclick() {
		        var ret = openFileAttachUI();
		    }
		    function btnAprDocAttach_onclick() {
		        openAaprDocAttachUI();
		    }
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        headerAction("open");
		    	PrintClick("Cross", pDocID, "ING");
		    }
		
		    /* 2020-02-24 홍승비 - 편집모드 > 저장 시 원문서 정보와 수정이력을 바로 업데이트하도록 수정하여, 기존 경고창 주석처리 */
		    function btnClose_onclick() {
/* 		    	if (editedFlag) {
		    		var pInformationContent = "<spring:message code='ezApprovalG.t148'/>" + "<br>" + "<spring:message code='ezApprovalG.t149'/>";
				    OpenInformationUI(pInformationContent, btnClose_onclick_Complete);
		    	} else {
			        window.close();
		    	} */
		    	window.close();
		    }
		    
		    function btnClose_onclick_Complete(rtn) {
		    	DivPopUpHidden();
		        if (rtn)
		            window.close();	    	
		    }
		    
		    window.onbeforeunload = function () {
		        try {
		            if (pAprLineType == "<spring:message code='ezApprovalG.t19'/>")
		                SaveApproveInfo("1");
		        } catch (e) { }
		        try {
		            window.opener.openergetDocInfo();
		        } catch (e) { }
		        try {
		            window.opener.Refresh_Window();
		        } catch (e) { }
		        try {
		            window.opener.getApprGraph("appr");
		        } catch (e) { }
		    };
		    
		    function btnConn_onclick() {
		    }
		    
// 		    function btnMail_onclick() {
// 		    	  $.ajax({
//                     type:"POST",
//                     dataType:"text",
//                     data : {
//                     	imgUrl : pDocHref,
//                     	docID: pDocID,
//                     	async: false,
//                     },
//                     url: "/ezApprovalG/createMailImg.do",
//                       success: function (data) {
//                       	var pheight = window.screen.availHeight;
//                 	        var conHeight = pheight * 0.8;
//                 	        var pwidth = window.screen.availWidth;
//                 	        var pTop = (pheight - conHeight) / 2;
//                 	        var pLeft = (pwidth - 890) / 2;
//                 	        //기존
//                 	        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref);
//                 	        //수정
// //                		        var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pDocHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";
//                 	        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
//                 	        newwin.focus();
//                       }
//                   });
// 		    }
		    
		    function btnMail_onclick() {
		    	var imgUrl="";
		    	headerAction("open");
		    html2canvas(document.getElementById("message").contentWindow.document.getElementById("div_Content")).then(function(canvas) {
		    	    $.ajax({
                        type:"POST",
                        dataType:"text",
                        data : {
                        	imgUrl : canvas.toDataURL("image/png"),
                        	docID: pDocID
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
	        var pLeft = (pwidth - 890) / 2;
	        //기존
	        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref)+"&orgCompanyID="+orgCompanyID;
	        //수정
//		        var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pDocHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";
	        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        newwin.focus();
		    }
		     		
		    var tempSecurity = "";
		    var tempKeep = "";
		    var tempUrgent = "N";
		    var tempPublic = "Y";
		    var tempKeyword = "";
		    var tempItemCode = "";
		    var tempItemName = "";
		    var tempdocnumcode = "<spring:message code='ezApprovalG.t45'/>";
		    var tempItemName2 = "";
		    var tempSecurityDate = "";
		    function btnDocInfo_onclick() {
		        openDocExinfo();
		        return;
		    }
		    
		    //S전용
		    function SetDocOption(pkeeperiodvaltemp, tempSecurityValue) {
	            var fields = message.GetFieldsList();

	            field = message.GetListItem(fields, "keepperiod");
	            if (field)
	                setNodeText(field , pkeeperiodvaltemp);

	            field = message.GetListItem(fields, "securitylevel");
	            if (field)
	                setNodeText(field , tempSecurityValue);

	            field = message.GetListItem(fields, "publication");
	            if (field) {
	                if (tempPublic == "N")
	                    setNodeText(field , "<spring:message code='ezApproval.t49'/>");
	                else
	                    setNodeText(field , "<spring:message code='ezApproval.t50'/>");
	            }

	            field = message.GetListItem(fields, "docnumber");
	            if (field && tempItemCode != "") {
	                var tempdocnumber = getNodeText(field);
	                tempdocnumber = tempdocnumber.replace(tempdocnumcode, tempItemCode);
	                setNodeText(field , tempdocnumber);
	            }
	        }
		    
		    function btnSetTaskCode_onclick() {
		        try {
		            var para = new Array();
		            para[0] = cabinetID;
		            var url = "../ezCabinet/SelectCabinet_Cross.aspx?initFlag=1";
		            var feature = "dialogWidth:850px;dialogHeight:455px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
		            feature = feature + GetShowModalPosition(850, 430);
		            if (url != "")
		                var rtn = window.showModalDialog(url, para, feature);
		            if (rtn[0] == "TRUE") {
		                var g_SelCabXml = rtn[1];
		                var xmlCab = loadXMLString(g_SelCabXml);
		                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
		                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		            }
		        } catch (e) {
		            showAlert("btnSetTaskCode_onclick : " + e.description);
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
		        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
		        if (!g_SepAttachLVXml)
		            g_SepAttachLVXml = "";
		        var para = new Array();
		        para[0] = g_SepAttachLVXml;
		        para[1] = cabinetID;
		        para[3] = ext;
		        
		        inssepattach_cross_dialogArguments[0] = para;
		        inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

		        DivPopUpShow(920, 630, "/ezApprovalG/insSepAttach.do");
		    }
		
		    function btnAddSepAttach_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            g_SepAttachLVXml = rtn[1];
		            message.DocumentBodySetAttribute("SepAttachLVXml", g_SepAttachLVXml);
		            SaveFile();
		        }
		    }
		    function GetSepAttParamXml(g_SepAttachLVXml) {
		        var rtnXml = createXmlDom();
		        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
		        var sepAtt, Data, i;
		        if (g_SepAttachLVXml != "") {
		            var sepLVXml = createXmlDom();
		            sepLVXml = loadXMLString(g_SepAttachLVXml);
		            var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW");
		            for (i = 0; i < rows.length; i++) {
		            	    sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
			                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "CABINETID", SelectSingleNodeValue(rows[i].childNodes[0], "DATA1"));
			                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "TITLE", SelectSingleNodeValue(rows[i].childNodes[1], "VALUE"));
			                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "NUMOFPAGE", SelectSingleNodeValue(rows[i].childNodes[4], "VALUE"));
			                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "REGTYPE", SelectSingleNodeValue(rows[i].childNodes[0], "DATA2"));
			                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "SUMMARY", SelectSingleNodeValue(rows[i].childNodes[6], "VALUE"));
			                Data = createNodeAndAppandNodeText(sepLVXml, sepAtt, Data, "AVTYPE", SelectSingleNodeValue(rows[i].childNodes[0], "DATA3"));
		            }
		        }
		        return getXmlString(rtnXml);
		    }
		    function btnhistory_onclick() {		    	
		        getHistory();
		    }
		    var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo() {
		    	if (checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
		    	
		        isExtDoc = message.DocumentBodyGetAttribute("EXTDOC");
		
		        if (isExtDoc != "Y") isExtDoc = "N";
		
		        onlydocinfiview = false;
		        
		        var parameter = new Array();
		        CheckDocCellInfo();
		        parameter[0] = pDocID;
		        parameter[1] = pFormID
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
		        parameter[12] = approvalType;
		        parameter[28] = onlydocinfiview;
		        parameter[30] = cabinetID; // 기록물철
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
			        parameter[51] = sepAttachCheckYN;
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

		        if(useOpenGov == "YES") {
                    parameter[52] = basis;
                    parameter[53] = reason;
                    parameter[54] = listOpenFlag;
                    parameter[55] = fileOpenFlagList;
                }
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		        
		        parameter[61] = tempKeyword;
		
		        ezapprovalinfo_dialogArguments[0] = parameter;
		        ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;

		        var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun +"&orgCompanyID=" + pCompanyID + "&docType=" + pDocType + "&formID=" + pFormID, "ezApprovalInfo", GetOpenWindowfeature(1210, 750));
		        
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    function btnApprovalInfo_Complete(ret) {
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
			                        SaveFile();
			                        getCurApproverAprLine("<c:out value ='${isUsed}'/>");
			                    }
			                }
		                } else {
			                if (pGubun != "5" && pGubun != "7" && pGubun != "10") {
			                    if (ret[1] != false) {
			                    	$.ajax({
			                    		type : "POST",
			                    		dataType : "text",
			                    		async : false,
			                    		url : "/ezApprovalG/aprLineSave.do",
			                    		data : {
			                    				ret    : ret[1],
			                    				orgCompanyID : orgCompanyID
			                    				},
			                    		success : function(result){
			                    			
			                    		}
			                    	});
			                    	
			                        IsSkipDrafter = "FALSE";
			                        btnSendDraftEnable = "true";
			                        ReAprLineSingMapping(ret);
			                        SaveFile();
			                        getCurApproverAprLine("<c:out value ='${isUsed}'/>");
			                    }
			                }
		                }
		                
		                if (pSuSinFlag == "Y") {
		                    if (pSuSinFlag == "Y" && typeof (ret[2]) == "string") {
		                    	$.ajax({
		                    		type : "POST",
		                    		dataType : "text",
		                    		async : false,
		                    		url : "/ezApprovalG/aprDeptSave.do",
		                    		data : {
		                    				aprDeptInfo : ret[2],
		                    				orgCompanyID : orgCompanyID
		                    				},
		                    		success : function(result){
		                    			if (result == 'TRUE') {
		                    				
		                    			} else {
		                    				showAlert(strLang163);
		                    			}
		                    		}
		                    	});
		                    	
		                        //수신자 저장 후
		                        btnReceivLineEnable = false;
		                        setRecevInfo(ret[3]);
		                    }
		                    else if (pSuSinFlag == "Y" && ret[2] == "") {
		                        DeleteDeptInfo();
		                        setRecevInfo("");
		                    }
		                }
		                //기록물철 매핑
		                if (ret[4] != undefined) {
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
		                
		                //tempPublic 추가
		                /*if (ret[11].substring(0,1) == '1') {
		                	tempPublic = 'Y';
		                } else {
		                	tempPublic = 'N';
		                }*/
		                
		                if (approvalFlag == "G") {
			                pSpecialRecordCode = ret[10];
			                pLimitRange = ret[12];
			                pPageNum = ret[13];
                            tempPublic = ret[21]; //문서 공개/비공개
			                //문서 공개 범위 설정
			                //setPublicFlag();
			                setPublicFlag();
			                
			                if (nonElecRec == "Y") {
				            	nonElecRecInfoXml = ret[23];
				            	nonSepAttachLVXml = ret[24];
				            	g_szSCListXml = ret[25];
				            	sepAttachCheckYN = ret[26];
				            	if (ext == "hwp") {
					            	setNonElecRecInfo(nonElecRecInfoXml);
				            	} else {
				            		setNonElecRecInfo_mht(nonElecRecInfoXml);
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
				            
				         	// 2023-05-23 임정은 - 공람 추가
				            if (ret[22] == "noItem") {
				            	delAprLineInfoCC();
				            } else if (ret[22] == "sameItem") {
				            } else {
				            	SaveAprLineInfoCC(ret[22]);
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
						SaveFile();
		
		                SummaryFlag = true;
		
		            }
		            catch (e) {
		                showAlert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        } else if (ret != undefined && ret[0] == "DUPL") {
		        	window.returnValue = "CLOSE";
	    			btnClose_onclick();
		        }
		    }
		    
		    /* 2020-02-24 홍승비 - 편집모드 내부에 '취소' 버튼 추가 */
			var editedFlag = false;
		    function btnEdit_onclick()
		    {
		    	if (checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
				
				if (getSnapshotCode() !== snapshotCode) {
					showAlert("<spring:message code='ezApprovalG.edit.pgb01'/>");
					if (allFlag == "1") {
						LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
					} else {
						window.returnValue = "CLOSE";
					}
					return;
				}
				
		        if (modeflag) { // 편집모드 진입
		            modeflag = false;
		            chkBtnConfirm("1");
		            chkBtn(false, approvalFlag);            
		            setMenuBar("btnAddRelatedCabinet", false);
		            document.getElementById("btnEditCancle").style.display = ""; // 편집모드 내부 취소버튼 표출
		            
		            headerAction("open");
		            beforeHtml = message.Get_EditorBodyHTML();
		            message.SetEditable(true);
		            var contentEditable = message.DocumentBodyGetAttribute("contentEditable");
		            if (contentEditable)
		                message.DocumentBodySetAttribute("contentEditable", "inherit");
		            btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t1767'/>";
		        }
		        else { // 편집모드 내부에서 '저장'
		            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
					
					if(editVersionYN && editVersionYN == "Y"){
						OpenInformationUI(pInformationContent, btnEdit_onclick_Complete, "Y");
					}else{
						OpenInformationUI(pInformationContent, btnEdit_onclick_Complete);
					}
		        }
		    }
		    function btnEdit_onclick_Complete(Ans, PeditMode) {
		        DivPopUpHidden();
		        
		        if (checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
				
				if (getSnapshotCode() !== snapshotCode) {
					showAlert("<spring:message code='ezApprovalG.edit.pgb01'/>");
					if (allFlag == "1") {
						LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");
					} else {
						window.returnValue = "CLOSE";
					}
					return;
				}
		        
		        if (Ans) {
			        var mustField = message.getMustFieldsInsert("<c:out value ='${userInfo.lang}'/>");
		            if (mustField && mustField != ""){
			            	var pAlertContent = "<spring:message code='ezApprovalG.psb131'/>";
			            	pAlertContent = pAlertContent.replace("@@", mustField);
			                OpenAlertUI(pAlertContent);
			                return;
		            }
		            /* 2020-03-03 홍승비 - 화면 종료 없이 계속 편집 > 저장해도 정상적으로 수정이력을 저장하도록 수정 */
					FirstHtml = beforeHtml;

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
					
		            /* 2020-02-24 홍승비 - 편집모드 > 저장 > 즉시 편집 전&후의 html과 수정이력을 저장하도록 수정 */
		            message.SetEditable(false);
		            headerAction("open");
		            var afterEditDoc = message.Get_EditorBodyHTML();
		            afterEditDoc = EmbedContentIntoXML(afterEditDoc);
		            
					// 편집 전 본문 html > isBeforeDoc 값을 "Y"로 전달, 저장한 편집전문서 파일경로 URL 리턴
		            var beforeDocURL = UpdateDocHistory(FirstHtml, "Y", "");
		            UpdateDocHistory(afterEditDoc, "N", beforeDocURL);
		            SaveFile();
		            
			        btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t44'/>";
			        editedFlag = true;
					snapshotCode = getSnapshotCode();
		        }
		        else { // 저장 > 취소
		            message.Set_EditorInputBodyHTML(modifiOrgBody);
		            message.Set_HtmlDocument();
		            noFieldsAvailable = true;
			        btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t44'/>";
		        }
		        message.SetEditable(false);
		        chkBtnConfirm("2");
		        setMenuBar("btnAddRelatedCabinet", true);
		        document.getElementById("btnEditCancle").style.display = "none"; 
		        
		        modeflag = true;
		    }
		    
		    function btnSave_onclick() {
		        var pDocID_ = "", pDocTitle_ = "";
		        try {
		            pDocID_ = pDocID;
		            pDocTitle_ = message.document.getElementById("doctitle").textContent.trim();
		        } catch (e) {
		            pDocTitle = "No Title";
		            pDocID = "No DocID";
		        }
		        var rtnVal = SavePCFile(pDocID_, pDocTitle_);
		        AttachDownFrame.location.href = rtnVal;
		    }
		
		    function SavePCFile(pDocID_, pDocTitle_) {
		
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "DocTitle", pDocTitle_);
		        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID_);
		        createNodeAndInsertText(xmlpara, objNode, "Html", ConvertHTMLtoMHT("<HTML>" + message.Get_EditorBodyHTML() + "</HTML>"));
		
		        xmlhttp.open("POST", "../aspx/savePCTmpFile.aspx", false);
		        xmlhttp.send(xmlpara);
		        return xmlhttp.responseText;
		    }
		
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
		    		showAlert("getDocMode() :: " + e.description);
		    	}
		    	
		    	return rtnVal;
		    }
		    
		    function getCurDocNumber() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getCabinetSN.do",
		    		data : {
		    			docID : pDocID,
		    			deptID : draftDeptID,
		    			orgCompanyID : orgCompanyID
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		    	var dataNodes = GetChildNodes(loadXMLString(result));
		        var SN = getNodeText(dataNodes[0]);
		    	return SN;
		    }
			
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=apprv", "addRelated", getOpenWindowfeature(480, 505));
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
						createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", SelectSingleNodeValue(dataNodes[1], "VALUE").trim() + (SelectSingleNodeValue(dataNodes[2], "VALUE").trim() == "" ? "<spring:message code='ezApprovalG.lhj18'/>" : ""));
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
		    
		    function redrawMappingSign() {
		    	if (approvalFlag == "S") {
		    		//공유결재 - 결재, 전결 일때만 사인칸을 다시그리도록 조건추가
		    		if (pAprLineType == strAprType1 || pAprLineType == strAprType4) {
				        var reMappingAprLine = getAprLineList("<c:out value ='${isUsed}'/>");
				        
				        //참조가 END인 경우 종료된 문서임으로 굳이 sign이나 수신처를 remap할 필요가 없다.
				        if (reMappingAprLine != "END") {
					        SReAprLineSingMapping(reMappingAprLine);
					        
					        if (pSuSinFlag == "Y") {
						        var reMappingReceipt = getReceiptList();
						        
						        setRecevInfo(reMappingReceipt);
					        }
				        }
		    		}
		        }
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
		    
		    /* 2020-02-24 홍승비 - 편집모드 > 취소버튼 동작 구현 */
		    function btnEditCancle_onclick() {
				message.Set_EditorInputBodyHTML(modifiOrgBody);
	            message.Set_HtmlDocument();
	            noFieldsAvailable = true;
		        btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t44'/>";
		        
		        message.SetEditable(false);
		        chkBtnConfirm("2");
		        document.getElementById("btnEditCancle").style.display = "none"; 
		        
		        modeflag = true;
		    }
		    
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
	    	
	    	function checkHeaderAction() {
	    		if (useHideHeaderArea == "YES" && message.GetListItem(message.GetFieldsList(), "headerArea") != null) {
                	document.getElementById("headerTabTR").style.display = "";
                	$('#headerMenu').hover(function() {
                		$('#headerMenu').css('border-bottom', '3px black solid');
                		$('#headerHide').css({'color':'black', 'font-weight':'bold'});
                	}, function() {
                		$('#headerMenu').css('border-bottom', 'solid 1px #eaeaea');
                		$('#headerHide').css({'color':'#8f8e93', 'font-weight':'normal'});
                	}) 
                } else if (document.getElementById("headerTabTR") != null) {
                	document.getElementById("headerTabTR").style.display = "none";
                }
	    	}
	    	
	    	function headerAction(action) {
	    		if (useHideHeaderArea == "YES") {
	    			var fields = message.GetFieldsList();
		    	    var field = message.GetListItem(fields, "headerArea");
		    	    
		    	    if (field) {
		    	        if (field.style.display == "none" || action == "open") {
		    	        	field.style.display = "";
		    	            document.getElementById("headerHide").innerHTML = ezApproval_headerHide01;
		    	        } else {
		    	            field.style.display = "none";
		    	            document.getElementById("headerHide").innerHTML = ezApproval_headerHide02;
		    	        }
		    	    }
	    		}
	    	}

			/* 2024-06-24 양지혜 - 전자결재 > 지정반송 */
			var returnChk = "N";
			function btnReturnDesignation_onclick() {
				returnChk = "Y";
				if (checkAprState()) {
					showAlert("<spring:message code='ezApprovalG.bhs23'/>");
					window.returnValue = "CLOSE";
					btnClose_onclick();
					return;
				}
				var pInformationContent = "<spring:message code='ezApprovalG.yjh04'/>";
				OpenInformationUI(pInformationContent, btnReject_onclick_Complete);
			}

		</script>
	</head>
	<body class="popup" style="height:100%;">
		<table class="layout">
		  <tr>
		    <td style="height:20px;">
			<div id="menu">
				<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
		        <ul id="AllApprove" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
					  <li id="btnApprove"><span onClick="return btnApprove_onclick()"><spring:message code='ezApprovalG.t1'/></span></li>
	                  <li id="btnReject"><span onClick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
					  <li id="btnReject2" style="display: none"><span onClick="return btnReturnDesignation_onclick()"><spring:message code='ezApprovalG.yjh02'/></span></li>
	                  <li id="btnStay"><span onClick="return btnStay_onclick()"><spring:message code='ezApprovalG.t50'/></span></li>
	                  <span style="display:none"><li id="btnSetTaskCode" style="display:none"><span onClick="btnSetTaskCode_onclick()" ><spring:message code='ezApprovalG.t9994'/></span></li></span>
	                  <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>        
	                  <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>     
	                  <li id="btnJunKyul" style="display:none"><span onClick="return btnJunKyul_onclick()"  ><spring:message code='ezApprovalG.t25'/></span></li>
	                  <span style="display:none"><li id="btnModAprLine"><span onClick="return btnModAprLine_onclick()" ><spring:message code='ezApprovalG.t52'/></span></li></span>
	                  <span style="display:none"><li id="btnModAprDept"><span onClick="return btnModAprDept_onclick()" ><spring:message code='ezApprovalG.t154'/></span></li></span>                 
	                  <li id="btnEdit"><span onClick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
	                  <%-- 2020-02-24 홍승비 - 편집모드 내부 취소버튼 구현 --%>
	                  <li id="btnEditCancle" style="display:none"><span onClick="btnEditCancle_onclick()"><spring:message code='ezApprovalG.t1761'/></span></li>
	                  <span style="display:none"><li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()"  ><spring:message code='ezApprovalG.t54'/></span></li></span>            
	                  <li id="btnOpinion"><span onClick="return btnOpinion_onclick()"  ><spring:message code='ezApprovalG.t55'/></span></li>
	                  <li id="btnFileAttach"><span onClick="return btnFileAttach_onclick()" ><spring:message code='ezApprovalG.t56'/></span></li>
	                  <li id="btnAprDocAttach"><span onClick="return btnAprDocAttach_onclick()" ><spring:message code='ezApprovalG.t57'/></span></li>
		              <li id="btnAddSepAttach" style="display:none"><span onClick="btnAddSepAttach_onclick()" ><spring:message code='ezApprovalG.t58'/></span></li>
	                  <li id="btnSave" style="display:none"><span onClick="return btnSave_onclick()"  ><spring:message code='ezApprovalG.t1767'/></span></li>
	                  <li id="btnhistory"><span onClick="btnhistory_onclick()" ><spring:message code='ezApprovalG.t61'/></span></li>
	                  <li id="btnConn" style="display:none"><span onClick="return btnConn_onclick()"><spring:message code='ezApprovalG.t63'/></span></li>
	                  <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
					  <li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
	                  <li id="btnMail" style="display:none"><span class="icon16 popup_icon16_mail_gray" onClick="return btnMail_onclick()"></span></li>
	                  <c:if test="${useCabinet == 'YES'}">
							<li id="btnAddRelatedCabinet"><span onclick = "return addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
					  </c:if>
	              </ul>
				<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
		        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
		        </ul>
			</div>
			<div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
				<ul><li><span id="btnClose" onClick="return btnClose_onclick()" ></span></li></ul>
			</div>
		</td> 
		  </tr>
		  <c:if test="${useHideHeaderArea == 'YES'}">
			  <tr id="headerTabTR" style="display:none;">
			  	<td>
					  <div id="headerTab" style="width:90%; height:27px; margin:0 auto; border-bottom: solid 1px #eaeaea; box-sizing: border-box;">
					  	<div id="headerMenu" style="width:80px; height:100%; cursor:pointer; text-align:center" onclick="headerAction()">
					  		<span id="headerHide" style="color:#8f8e93; font-size:14px;"><spring:message code='ezApproval.headerHide01'/></span>
					  	</div>
					  </div>
			  	</td>
			  </tr>
		  </c:if>
		  <tr>
		      <td style="vertical-align:top;height:90%;">
		        <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		          
		    </td>
		  </tr>
		  <tr>
		  <td>
		  <div id="officeBtn" style="display:none;">
		  	<div style="text-align:center; background-color:rgba(0, 0, 0, 0.5); height: 50px;">
		  		<img id="zoomIn" onclick="zoomIn()" src="/images/icviewer_plus.png" width="25" height="25" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="zoomOut" onclick="zoomOut()" src="/images/icviewer_minus.png" width="25" height="25" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="zoomReset" src="/images/icviewer_reset.png" width="25" height="25" onclick="zoomReset()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="officeBar1" src="/images/icviewer_bar.png" style="position: relative; top: 13px;">
		  		<img id="prevAll" border="0" src="/images/icviewer_p_prev.png" width="25" height="25" onClick="prevClickAll()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="prev" border="0" src="/images/icviewer_prev.png" width="25" height="25" onClick="prevClick()" style="cursor:pointer; position: relative; top: 13px;">
		  			<select id="selectImg" class="imgSelect" onchange="selectImg()">
		  				<option value=""></option>
		  			</select>
		  		<img id="next" border="0" src="/images/icviewer_next.png" width="25" height="25" onClick="nextClick()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="nextAll" border="0" src="/images/icviewer_n_next.png" width="25" height="25" onClick="nextClickAll()" style="cursor:pointer; position: relative; top: 13px;">
		  		<img id="officeBar2" src="/images/icviewer_bar.png" style="position: relative; top: 13px;">
		  		<img src="/images/icviewer_expend.png" class="allImg" id="all" onclick="allImg(this)" style="cursor:pointer; position: relative; top: 13px;"" width="25" height="25">
			</div>
		</div>
		  </td>
		  </tr>
		  <tr>
		  
		  <%-- 기존 파일첨부 영역 --%>
		  <%--
		    <td style="height:20px;"><table class="file">
		        <tr>
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
		      --%>

		    <td style="height:20px;">
                <table class="file" style="height:80px;">
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
							<a class="imgbtn imgbck" style="width:70px;"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
							<a class="imgbtn imgbck" style="width:70px"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
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
		</script>
		<XML ID="ATTACHINFO"></XML>
		<XML ID="DOCINFO"></XML>
		<XML ID="APRLINEINFO"></XML>
		<div id="AprMemberSN" style="display:none"></div>
		<iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
        <c:if test="${useAI}">
            <c:import url="/WEB-INF/jsp/ezAI/aiSlide.jsp" />
        </c:if>
	</body>
</html>
