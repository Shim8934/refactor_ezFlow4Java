<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>
	    <c:choose>
			<c:when test="${nonElecRec eq 'Y'}">
            	비전자문서 등록
			</c:when>
			<c:otherwise>
            	<spring:message code='ezApprovalG.t30'/>
			</c:otherwise>
		</c:choose>
	    </title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draftG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDraft_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
	        var FormHref = "<c:out value ='${formURL}'/>";
	        var DraftFlag = "<c:out value ='${draftFlag}'/>";
	        var DocType = "<c:out value ='${formDocType}'/>";
	        var SusinSN = "<c:out value ='${susinSN}'/>";
	        var DocState = "<c:out value ='${docState}'/>";
	        var ListType = "<c:out value ='${listType}'/>";
	        var AprState = "<c:out value ='${aprState}'/>";
	        var pEndDocHref = "<c:out value ='${dirPath}'/>";
	        var _connkey_ = "<c:out value ='${connkey}'/>";
	        var pFormHref = new String();
	        var pFormID = new String();
	        var pDocID = new String();
	        var pHasAttachYN = new String("N");
	        var pHasOpinionYN = new String("N");
	        var CurrentDate
	        var flag = false;
	        var fieldflag = false;
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
	        var AutoSave = "save";
	        var Saveflag = true;
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
	        var nonElecRec = "<c:out value ='${nonElecRec}'/>";
	        var nonElecRecInfoXml = "", nonSepAttachLVXml = "", sepAttachCheckYN = "";
	        var useReceiveDocNo = "<c:out value ='${useReceiveDocNo}'/>";
	        var orgCompanyID = "<c:out value='${userInfo.companyID}'/>";
	        var docNumZeroCnt = "<c:out value ='${docNumZeroCnt}'/>";
			var isUsed = "<c:out value ='${isUsed}'/>";
			var beforeDocID = "<c:out value ='${beforeDocID}'/>";
			var beforeUrl = "<c:out value ='${beforeUrl}'/>";
			var apprReuseConfig = "<c:out value='${apprReuseConfig}' />";
            var wAprMemberSN = "1";
            //회람
            var type = "ING";
            var pGongRamDocID = "";
			//원문정보공개
			var useOpenGov = "<c:out value='${useOpenGov}' />";
			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			var newpDocID = "";
	        var useRedraftOpinionKeep = "<c:out value='${useRedraftOpinionKeep}'/>";
	        var formAprOption = "<c:out value='${formAprOption}'/>";
	        var passAprLine = "";
	        var rtnSignInfo = [];
	        var useWebHWP = "<c:out value ='${useWebHWP}'/>";
	        var pConnKey = "<c:out value ='${connKey}'/>";
	        var pConnFormCode = "<c:out value ='${connFormCode}'/>";
	        
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
			var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>";

			var formPath = "<c:out value ='${formPath}'/>";
			var type = "ING"; // 2023-05-23 임정은 - 공람 추가

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			var attachedDocList = "${ attachedDocList }";

			var pTenantID = "<c:out value='${userInfo.tenantId}'/>";
            var junGyulFlag = "<c:out value = '${junGyulFlag}'/>";
			var draftJunGyulFlag = "<c:out value ='${draftJunGyulFlag}'/>"; // 일반버전 서명 remapping 시 전결문자 표출 확인용 (0 : 미표출 / 1 : 표출, default)

			// 자동 임시저장
			var timer;
			var pSaveTime = "<c:out value ='${useAutoSaveTime}'/>";
			var pSaveInterval = parseInt(pSaveTime) * 1000;
			var DraftStatus = "NO";
			var autopDocID = "";
			var autopDocSN = "";
			var createAutoDoc = "N"

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";

			// 창마다 고유한 id 지정용
			var windowUuid = getRandomId();
			
	        window.onload = function () {
	            try {
	                pSusinSN = SusinSN;
	                setMenuBar("btnSendDraft", true);
	                setMenuBar("btntotaldocinfo", false);
	                dragNdrapNo();
	
	                IsSkipDrafter = "FALSE"
					DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
	                drafterDeptid = arr_userinfo[4];
	                getDraftInfo();
	                SetBtnStateFalse();
	                
					// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
					setAttachGuideText();
	                
	                window.onresize();
	            } catch (e) {
	                alert("ezdraftui_hwp.window.onload::" + e);
	            }
	        }
	
	       	window.onresize = function () {
	       		if(beforeUrl != "") {
	       			document.getElementById("messageWHWPEditor").style.height = document.documentElement.clientHeight - 170 + "px";
	       			var mHeight = document.documentElement.clientHeight - 180 - document.getElementById("messageWHWPEditor").offsetTop + "px";
	       		} else {
	       			document.getElementById("messageWHWPEditor").style.height = document.documentElement.clientHeight - 150 + "px";
	       			var mHeight = document.documentElement.clientHeight - 110 - document.getElementById("messageWHWPEditor").offsetTop + "px";
	       		}
	       		message.Resize(mHeight);
	        }
	
	        function dragNdrapNo() {
	            try {
		            var div = document.getElementById('lstAttachLink');
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
	                alert("ezdraftui_whwp.dragNdrapNo()::" + e.description);
	            }
	        }

	        var timeoutCnt = 0;
	        function FieldsAvailable(isTrue) {
	            try {
                    if(typeof DeptSymbol == "undefined"){
                        if(timeoutCnt++ == 6)
                            location.reload();
	                    setTimeout(function(){FieldsAvailable(isTrue)}, 500);
	                    return;
	                }
	                if (isTrue) {
	                    SetBtnStateTrue();
	                    setAutoProperty();
	                    setMenuBar("btntotaldocinfo", true);
	                    hideLoadingProgress();
	                    
	                    //window.focus();
	                    //HwpCtrl.focus();
	

						/* var targetText = GetDocumentElement(HwpCtrl, "CONNROOT", true);

						if (targetText != null && targetText.length > 0 ) {
							  var xmlData = loadXMLString(targetText);
	   						  var connNodes = GetChildNodes(xmlData.documentElement);
							  if(connNodes.length > 0) {
								  document.getElementById('btnSaveServer').style.display = 'none';		
							  }
						}  */
	
	                    if (pFormHref == "") {
	                        getExtInfo();
	                    }
	
	                    /* if (pReadPC) {
	                        var DocumentInfo = new ActiveXObject("Microsoft.XMLDOM");
	                        DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());
	
	                        if (GetDocumentElement(HwpCtrl, "CONNROOT", true) != "") {
	                            var pAlertContent = "<spring:message code='ezApprovalG.t1391'/><br><br><spring:message code='ezApprovalG.t1392'/>";
	                            OpenAlertUI(pAlertContent);
	                            HwpCtrl.ClearDocument();
	                        }
	
	                        if (DocumentInfo.getElementsByTagName("TITLE").length > 0) {
	                            if (getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0)) != "") {
	                                pFormID = getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0));
	                                DocType = GetFormType(pFormID);
	                                if (DocType != "")
	                                    pDocType = DocType;
	                                else {
	                                    var pAlertContent = "PC<spring:message code='ezApprovalG.t1393'/>";
	                                    OpenAlertUI(pAlertContent);
	                                    HwpCtrl.ClearDocument();
	                                    return;
	                                }
	                            }
	                        }
	                    } */
	
	                    process_AfterOpen();
						connInit();
	                    // if (_connkey_ != "") {
	                    //     try {
	                    //         if (message.FieldExist("_connkey_"))
	                    //             message.PutFieldText("_connkey_", _connkey_);
	                    //     } catch (e) { }
	                    // }
	                    
	                    // var rtnVal = ExcuteInfo("INIT", "");
	                    
	                    // if (!rtnVal) {
	                    //     if (OpenInformationUI("<spring:message code='ezApprovalG.t122'/>")) {
	                    //         btnClose_onclick();
	                    //     }
	                    // }
	                    
	                    if (pDraftFlag != "REDRAFT") {
	                        setFirstDrafter();
	                    }

                        if (approvalFlag == "S") {
                            // 임시보관함에서 기안할 때, 자동분류코드가 로드안되는 문제 해결 | 임시저장문서 재기안 시, 기존에 저장한 분류코드 설정이 있기 때문에 양식에 설정된 자동분류코드를 로드하지 않는다.
                            if (ListType != "21" || pDraftFlag != "REDRAFT")
                                SetAutoDocnumItem();
                        }

	                    message.EditMode(2);
						message.SetViewProperties(2, 100);
	                    message.MoveToField("doctitle");
	                    message.ScrollPosInfo(0, 0);
	                } else {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    message.Clear();
	                }
	                
	                if (nonElecRec == "Y") {
	                	document.getElementById("btnSelForm").style.display = "none"; <%-- 양식선택 --%>
	                	document.getElementById("btnAddSepAttach").style.display = "none"; <%-- 분리첨부 --%>
	                	document.getElementById("btnSaveServer").style.display = "none"; <%-- 임시저장 --%>
	                	document.getElementById("btnHelper").style.display = "none"; <%-- 연동 --%>
	                	document.getElementById("btnhistory").style.display = "none"; <%-- 변경내역 --%>
	                	document.getElementById("btnSave").style.display = "none"; <%-- 저장 --%>
	                	document.getElementById("btnOpinion").style.display = "none"; <%-- 의견 --%>
	                	document.getElementById("btnAprDocAttach").style.display = "none"; <%-- 문서첨부 --%>
	                	document.getElementById("btnPrint").style.display = "none"; <%-- 인쇄 --%>
	                	message.PutFieldText("docnumber","");
	                }
	                
	                /**
	                	기안인 경우에는 hwp파일이 실존하지 않아 로컬로 저장하는 것이 불가능하므로 저장버튼 display:none처리
	                	또한, 일반 mht쪽에서도 기안을 올릴 때 저장 기능이 없음.
	                */
	                if(DraftFlag === 'DRAFT') {
	                	$("#btnSave").css('display', 'none');
	                }

					//2024.07.04 자동 임시저장 기능 추가
					if (document.getElementById("btnSaveServer").style.display != "none" && approvalFlag == "G" && pSaveInterval != 0) { // 임시저장이 가능한 문서일때만 저장되도록 추가
						if (timer) {
							clearInterval(timer);
						}
						if (pSaveInterval > 0) {
							timer = setInterval(Draft_AutoSave, pSaveInterval);
						}
					}
					message.FreeUndoHistory();
	            } catch (e) {
	                alert("ezdraftui_whwp.FieldsAvailable()::" + e);
	            }
	        }
	        
	        function Insert_ReUse_Content() {
	        	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(beforeUrl);
                message2.Open(URL, "", "", function (res) { CopyAndPasteContent(res.result) }, null);
	        }

			function Editor_Form_Complete() {
				var URL =  "http://" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(formPath);
				message3.Open(URL, "", "", function (res) { res.result }, null);
			}

	        function CopyAndPasteContent(isTrue) {
	        	try {
		        	if(isTrue) {
		        		message2.GetCloneData("doctitle", "JSON", function (tempContent) { message.SetCloneData(tempContent, "doctitle", "JSON") });
		        		message2.GetCloneData("body", "JSON", function (tempContent) { message.SetCloneData(tempContent, "body", "JSON") });
		        	} else {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    message.Clear();
	                }
	        	} catch (e) {
		            alert("CopyAndPasteContent ::" + e);
		        }
	        }
	
			function GetFormType(pFormID) {
			    try {
			        var Result = "";
			        var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
			        var xmlhttp = createXMLHttpRequest();
			        var objNode;
			        createNodeInsert(xmlpara, objNode, "PARAMETER");
			        createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);
			        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", pCompanyID);
			
			        xmlhttp.open("Post", "aspx/GetFormDetail.aspx", false);
			        xmlhttp.send(xmlpara);
			
			        if (xmlhttp.status == 200) {
			            if (loadXMLString(xmlhttp.responseText).getElementsByTagName("FORMDOCTYPE").length > 0) {
			                Result = getNodeText(loadXMLString(xmlhttp.responseText).getElementsByTagName("FORMDOCTYPE").item(0));
			            }
			        }
			
			        xmlpara = null;
			        xmlhttp = null;
			        return Result;
			
			    } catch (e) {
			        alert("ezdraftui_hwp.GetFormType()::" + e.description);
			    }
			}
	
			function openForm() {
			    openFormUI();
			}
	
			function process_AfterOpen() {
			    try {
			        if (pFormHref == "") {
			            SetBtnStateFalse();
			        } else {
			            if (pDraftFlag == "REDRAFT") {
			                var len;
			                var pInformationContent;
			                var Ans;
			
			                SetBtnStateTrue();
			
			                if (isTmpDocID == "") {
			                    len = pFormHref.lastIndexOf("/");
			                    pDocID = pFormHref.substr(len + 1, 20);
			                } else {
			                    pDocID = isTmpDocID;
			                }
			
			                GetAprDocFormID();
			                setAttachInfo(pDocID, "APR", lstAttachLink);
			                GetExchInfo();
			                getDocInfo();
			                
			                /* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
		                    // 수신문서 > 수신부서 결재 중 반송 > 재기안인 경우에는 수신문서 접수 페이지로 열리므로, 내부기안 페이지에서는 해당 분기 처리하지 않음
					        message.startRemapAllAprSign_WHWP(pDocID, orgCompanyID);
		                    
			                if (pHasOpinionYN == "Y") {
			                    if (AprState == "<spring:message code='ezApprovalG.t49'/>") {
			                    	pInformationContent = "<spring:message code='ezApprovalG.t124'/><br> <spring:message code='ezApprovalG.t10'/>";
			                    } else {
				  		        	pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
			                    }
			                  
			                    OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
			                }
			          } else if (pDraftFlag == "SUSIN" || pDraftFlag == "GONGRAM") {
			              var len;
			
			              len = pFormHref.lastIndexOf("/");
			              pOrgDocID = pFormHref.substr(len + 1, 20);
			              pDocID = pOrgDocID;
			              GetAprDocFormID();
			              setAttachInfo(pDocID, "APR", lstAttachLink);
			              GetExchInfo();
			              getDocInfo();
			
			              if (pHasOpinionYN == "Y") {
			                  var pInformationContent;
			                  var Ans;
			                  pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
					  	  	  OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
			              }
			            } else if (pDraftFlag == "HAPYUI") {
			                var len;
			                len = pFormHref.lastIndexOf("/");
			                ClearDocCellInfo();
			                setClearSusinCellInfo();
			                pOrgDocID = pFormHref.substr(len + 1, 20);
			                pDocID = pOrgDocID;
			                GetAprDocFormID();
			                setAttachInfo(pDocID, "APR", lstAttachLink);
			
			                GetExchInfo();
			                getDocInfo();
			                if (pHasOpinionYN == "Y") {
			                    var pInformationContent;
			                    var Ans;
			
			                    pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
					  	  		OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
			                }
			            } else {
			                SetBtnStateTrue();
			                pDraftFlag = "DRAFT";
			                GetExchInfo();
			
			                if (pFormHref != "PC") {
			                    var len;
			                    len = pFormHref.lastIndexOf("/");
			                    pFormID = pFormHref.substr(len + 1, 10);
			                }
			
			                if (pDocID == "") {
			                    if (pReadPC) {
			                        ClearDocCellInfo();
			                        setClearSusinCellInfo();
			                    }
			                    pDocID = createNewDoc();

								// 기록물등록대장 첨부기안
								if (attachedDocList != "") {
									attachRecordDoc();
									setAttachInfo(pDocID, "APR", document.getElementById("lstAttachLink"));

									attachedDocList = "";
								}

								// 2024-04-19 조소정 - G버전 whwp문서 재사용 시 첨부파일 재사용 및 첨부파일이력 추가
			                    if (isUsed == "reuse") {
			                    	if (apprReuseConfig != '1') {
			                    		getDocInfo();
										setAttachInfo(pDocID, "APR", lstAttachLink);
                                        copySummary(beforeDocID, "END", pDocID);
			                    	}
								}
			                }
			            }
					}
				} catch (e) {
				    alert("ezdraftui_hwp.process_AfterOpen()::" + e.description);
				}
			}
			
			function process_AfterOpen_Complete(Ans) {
				DivPopUpHidden();
		        if (Ans) {
		            //openOpinionUI("Display");
		        	openOpinionUI_New("");
		        }
			}
	
			function setAutoProperty() {
			    getDraftUserInfo();
			    SetAutoPropertyValue();
			}
	
			function btnSelForm_onclick() {
				if(nonElecRec == "Y") {
			    	return;
			    }
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
			            if (approvalFlag == "S") {
                            SGetDraftAprLineInfo(ret);
                        } else {
                            GetDraftAprLineInfo(ret);
                        }
			            return true;
			        } else {
			            if (ret[2] == "cancel") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t127'/>";
			                OpenAlertUI(pAlertContent);
			            }
			        }
			        
			        return false;
		        } catch (e) {
		            alert("ezdraftui_hwp.btnSetAprLine_onclick()::" + e.description);
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
	                alert("ezdraftui_hwp.btnSetReceivLine_onclick()::" + e.description);
	            }
	        }
	
	        var sendDraftResult = "";
	        var ingFlag = false;
	        function btnSendDraft_onclick() {
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

	            if (approvalFlag == "S" && pDraftFlag == "REDRAFT" && checkAprState() && ListType != "21") {
	                alert("<spring:message code='ezApprovalG.bhs23'/>");
                    window.returnValue = "CLOSE";
                    window.close();
                    return;
                }

		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getExtTotalAttachSize.do",
		    		data : {
		    			docID : pDocID
		    			////////
		    		},
		    		success: function(text){
		    			sendDraftResult = text;
		    		}        			
		    	});
		    	
		    	// 본문의 용량을 구하기 위함 2018-07-13
		    	GetHTML2(sendDraft);
	        }
	        
	        // sendDraft 시작
	        function sendDraft(strClone) {
	        	var strBytes = parseInt(getByteLength(strClone));
		    	
		    	var rtnAttachXML = loadXMLString(sendDraftResult);
				
                var attachTotalSize = getNodeText(rtnAttachXML.getElementsByTagName("TOTALSIZE").item(0));
                
                
                if (getNodeText(rtnAttachXML.getElementsByTagName("FLAG").item(0)) == "Y") {
                    OpenAlertUI("외부발송문서 총 첨부용량은 최대 6MB 입니다" + "<br>" + "첨부용량을 줄여주시기 바랍니다.");
                    return;
                    
                }

                // 본문과 첨부파일의 총합이 7.4mb가 초과시 알러트 2018-07-13 강민수92
                if (getNodeText(rtnAttachXML.getElementsByTagName("EXTFLAG").item(0)) == "Y" && strBytes + parseInt(attachTotalSize) > 7400000) {
                	OpenAlertUI("외부발송문서 총 용량은 최대 7.4MB 입니다" + "<br>" + "첨부파일이나 본문용량을 줄여주시기 바랍니다.");
                    return;
                }

                bAttachProcess = false;

                if (GetDocumentElement("WORKFLOW", true)) {
                    var rtn = checkValidation();
                    if (rtn == "FALSE") {
                        return;
					}
	            }

				var Fields = message.GetFieldList(0, 1);
				var tempFields = message.GetFieldList(0, 1);

				tempFields = Fields.reduce(function(tempArr,curr,index) {
					tempArr.indexOf(curr) > -1 ? tempArr : tempArr.push(curr);
					return tempArr;
				},[]);

				if (Fields.length !== tempFields.length) {
					OpenAlertUI("동일한 Field가 존재합니다. 문서를 다시 확인해주세요.");
					return;
				}
	
	            if (message.FieldExist("doctitle"))
	                pDocTitle = trim(message.GetFieldText("doctitle"));
	            else
	                pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";

                if (pDocTitle == "") {
                    var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (pDocTitle.length > 127) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t132'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                
                if (nonElecRec == "Y" && nonElecRecInfoXml == "") {
                	var pAlertContent = "기록물 정보를 입력해 주세요.";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (btnSendDraftEnable == "false") {
                	var pAlertContent = "";
	            	//재기안의 경우 결재선 확인하라는 메세지 출력
	            	if (pDraftFlag == "REDRAFT") {
						pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
	            	} else {
	                    pAlertContent = "<spring:message code='ezApprovalG.t1398'/>" + "<br>" + "<spring:message code='ezApprovalG.t1399'/>";
	            	}
	            	
	            	OpenInformationUI(pAlertContent, check_btnSendDraft2);
                    return;
                }
                
                if (!checkLines())
                    return;

                if (pSuSinFlag == "Y" && !btnReceivLineEnable) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t141'/>" + "<br>" + "<spring:message code='ezApprovalG.t142'/>";
                    OpenInformationUI(pAlertContent, check_btnSendDraft);
                    return;
                }

                if(approvalFlag == "G") {
                    if (cabinetID == "") {
                        var pAlertContent = "<spring:message code='ezApprovalG.t1397'/>";
                        OpenInformationUI(pAlertContent, check_btnSendDraft3);
                        return;
                    }
                }else{
                    if (cabinetID == "") {
                        var pAlertContent = "<spring:message code='ezApprovalG.t137'/>";
                        OpenInformationUI(pAlertContent, check_btnSendDraft3);
                        return;
                    }
                }

                if (!SummaryFlag)
                    btnApprovalInfo(4);

                if (!SummaryFlag)
                    return;

                setDrafterAddress();

                if (pDraftFlag == "REDRAFT") {
                    delOpinionInfo();
                }
                
              	//2020-11-19 정소미 - 채용 양식일 경우
	            if (message.FieldExist("hiredatechk")) {
	            	var hiredate = trim(message.GetFieldText("hiredatechk"));
	            	if (hiredate == "") {
	            		OpenInformationUI("채용일자 없이 진행하시겠습니까?<br>- 채용일자는 면접 후 최종 보고 시에만 입력<br>- 채용계획, 서류 결과 보고 시에는 입력 불필요", check_btnSendDraft4);
	        			return;
	            	}
	            }

              	if (nonElecRec != "Y") {
					UpdateDocNum();

	                if (LastSignSN == 1 || DraftLastFlag) {
	                    var pInformationContent = "<spring:message code='ezApprovalG.t143'/><br> <spring:message code='ezApprovalG.t144'/>";
	                    OpenInformationUI(pInformationContent, check_btnSendDraft4);
	                } else {
	                	CheckUsePassword();
	                }
               	} else {
               		CheckUsePassword();
               	}
	        }
	        // sendDraft 끝
	        
	        // sendDraft2 시작
	        function sendDraft2(cloneHWP) {
	        	pOrgHtml = cloneHWP;
	        	
				// IsSkipDrafter == "FALSE" 에 대한 분기 시작	        	
	        	if (LastSignSN == 1 || DraftLastFlag) {
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_BEFORE");
                    if (!rtnVal) {
                        return;
                    }
                }

                var rtnval;
                if (LastSignSN == 1 || DraftLastFlag) {
                    //rtnval = getDocNumber(arr_userinfo[4], "", docNumZeroCnt);
                    rtnval = getDocNumberNew(arr_userinfo[4], "", docNumZeroCnt);
                }
                else {
                    //rtnval = getDocNumber(arr_userinfo[4], "be", docNumZeroCnt);
                    rtnval = getDocNumberNew(arr_userinfo[4], "be", docNumZeroCnt);
                }

                if (!rtnval) {
                    var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (LastSignSN == 1 || DraftLastFlag) {
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_AFTER");
                    if (!rtnVal) {
                        return;
                    }
                }
                SendDraftMappingSign(ret);
                //rtnSignInfo = SendDraftMappingSign(ret);
                // IsSkipDrafter == "FALSE" 에 대한 분기 끝
                
                //GetHTML(saveDraftInfo);
	        }
	        // sendDraft2 끝
	        
	        // saveDraftInfo 시작
	        function saveDraftInfo(html) {
	        	pSaveHtml = html;
	        	
	        	if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
                    var RtnVal;
                    var pAlertContent;
                    RtnVal = setSusinUpdataDocID();
                    if (RtnVal == "true") {
                        RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
                        if (!RtnVal) {
                            return;
                        }

                        if (RtnVal)
                            RtnVal = SaveDraftDocInfo();
                        if (RtnVal == "TRUE") {
                            RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
                            if (!RtnVal) {
                                return;
                            }

                            if (LastSignSN == 1 || DraftLastFlag) {
                                RtnVal = ExcuteInfo("DOCNUM_END");
                                if (!RtnVal) {
                                    return;
                                }
                            }

                            UpdateLineHistory();
                            
                            draftFlag = true;
                            pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
                            OpenAlertUI(pAlertContent, Complete_Draft);
                            /* draftFlag = true;
                          
              		        //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
              		        if (parent.opener != null && parent.opener.getApprovalList != undefined) { 
              		        	parent.opener.clearAbsence(true);
              		        }
                            
                            window.close(); */
                        } else {
                            UndoSignInfo(rtnSignInfo);

                            if (LastSignSN == 1 || DraftLastFlag) {
                                RtnVal = ExcuteInfo("END_FAIL");
                                if (!RtnVal) {
                                    return;
                                }
                            }

                            pAlertContent = "[<spring:message code='ezApprovalG.t1400'/>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    } else {
                        UndoSignInfo(rtnSignInfo);

                        if (LastSignSN == 1 || DraftLastFlag) {
                            RtnVal = ExcuteInfo("END_FAIL")
                            if (!RtnVal) {
                                return;
                            }
                        }

                        SetBtnStateTrue();
                        btnSendDraftEnable = "true";
                        pAlertContent = "[<spring:message code='ezApprovalG.t1400'/>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                } else {
                    var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
                    var pAlertContent;
                    if (!RtnVal) {
                        return;
                    }

                    if (LastSignSN == 1 || DraftLastFlag)
                        SetAutoPropFinal();

                    if (LastSignSN == 1 || DraftLastFlag) {
                        var rtnVal = ExcuteInfo("LAST_SEND_BEFORE");
                        if (!rtnVal) {
                            return;
                        }
                    }

                    RtnVal = SaveDraftDocInfo();
                    if (RtnVal == "TRUE") {
                        RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
                        if (!RtnVal) {
                            return;
                        }

                        if (LastSignSN == 1 || DraftLastFlag) {
                            RtnVal = ExcuteInfo("DOCNUM_END");
                            if (!RtnVal) {
                                return;
                            }
                            Gyuljedate = GetDocInfoData("END", "STARTDATE");
                            SendMailToReceiveDept(pDocTitle, arr_userinfo[2], Gyuljedate, pDocID);
                        }
                        else {
                            Gyuljedate = GetDocInfoData("APR", "STARTDATE");
                            CurrentAprType = "001";
	                        CurrentAprUserID = pUserID;
	                        
                            if (passAprLine != "Y") {	 //기결재통과 알림메일은 자바단에서 구현
                            	sendAlertMail("APR", 1, "DRAFT");
                            }
                        }

                        UpdateLineHistory();
                        
                        if (nonElecRec == "Y") {
                        	pAlertContent = "문서를 [등록]하였습니다.";
                        } else {
	                        pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
                        }
                        
                        draftFlag = true;
                        OpenAlertUI(pAlertContent, Complete_Draft2);
                        /* draftFlag = true;

                        if (ListType == "21" && DraftFlag == "REDRAFT") {
                            RemoveTmpDoc(DocSN);
                        }
                        
                        if (nonElecRec == "Y") {
                        	RemoveEndNonElecRecDoc(pDocID);
                        }

                        window.close(); */
                    } else {
                        UndoSignInfo(rtnSignInfo);
                        if (LastSignSN == 1)
                            rollbackDocNumber(arr_userinfo[4], "", pDocID);

                        if (LastSignSN == 1 || DraftLastFlag) {
                            RtnVal = ExcuteInfo("END_FAIL")

                            if (!RtnVal) {
                                return;
                            }
                        }

                        SetBtnStateTrue();
                        pAlertContent = "[<spring:message code='ezApprovalG.t1400'/>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                }
	        }
	        // saveDraftInfo 끝
	        
	        function GetHTML(callback) {
                ingFlag = true;
	            message.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data); });
	        }
	        
	        function GetHTML2(callback) {
                ingFlag = true;
	            message.GetTextFile("HWPML2X", "", function (data) { ingFlag = false; callback(data); });
	        }
	        
		    function Complete_Draft() {
		        draftFlag = true;
		      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && typeof(parent.opener.getApprovalList) != 'unknown' && parent.opener.getApprovalList != undefined) { 
		        	parent.opener.clearAbsence(true);
		        }
		        //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가
		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
		        	document.getElementById('message').contentWindow.document.getElementById('iframe_content').contentWindow.attitude_annual_conn("annual", "0");
		        }	        
		        
		        window.close();
		    }
		
		    function Complete_Draft2() {
		        draftFlag = true;
		        if (ListType == "21") {
		            RemoveTmpDoc(DocSN);
		        }

				if (autopDocSN != "") {
					RemoveTmpDoc(autopDocSN);
				}
		      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && typeof(parent.opener.getApprovalList) != 'unknown' && parent.opener.getApprovalList != undefined) {
		        	parent.opener.clearAbsence(true);
		        }
		        //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가--아직 개발중
		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
		        	document.getElementById('message').contentWindow.document.getElementById('iframe_content').contentWindow.attitude_annual_conn("annual", "0");
		        }
		        window.close();
		    }
	
	        function btnFileAttach_onclick() {
	        	try {
	                var ret = openFileAttachUI();
	            } catch (e) {
	                alert("ezdraftui_hwp.btnFileAttach_onclick()::" + e.description);
	            }
	        }
	
	        function btnAprDocAttach_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
	        	if(nonElecRec == "Y") {
			    	return;
			    }
				
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
	            //var ret = openOpinionUI("N");
	            if(nonElecRec == "Y") {
			    	return;
			    }
	        	openOpinionUI_New("");
	        }
	
	        function btnSave_onclick() {
	        	var hwpDoctitle = message.GetFieldText("doctitle").replace(/\r\n/g, " ");
	        	
	        	if (hwpDoctitle == "") {
	        		var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
                    OpenAlertUI(pAlertContent);
	        		message.MoveToField("doctitle");
	        		return;
	        	}
	        	
	        	hwpDoctitle += ".hwp";
	            message.SaveFile(hwpDoctitle, "HWP", "");
	        }
	
	        function btnPrint_onclick() {
	        	if(nonElecRec == "Y") {
			    	return;
			    }
	        	message.PrintDocument();
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
			    if (bAttachProcess == false) {
			        if ((!draftFlag && DraftFlag == "DRAFT") || (!draftFlag && AprState == "" && DraftFlag == "REDRAFT"))
			            UndoDoc();
			    }
			
			    try {
			        if (bAttachProcess == false)
			            window.opener.openergetDocInfo();
			    } catch (e) {
					if (bAttachProcess == false)
			            window.parent.openergetDocInfo();
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
	
			// function btnMail_onclick() {
			//     window.open("/ezEmail/mailWrite.do?cmd=docsend&docID=" + pDocID + "&docHref=" + pFormHref, '', 'height=700,width=690,resizable=yes,scrollbars=no' + GetOpenPosition(690, 700));
			// }
	
			function btnDocInfo_onclick() {
			    try {
			        var parameter = new Array();
			        parameter[0] = tempSecurity;
			        parameter[1] = tempUrgent;
			        parameter[2] = pSummery;
			        parameter[3] = pSpecialRecordCode;
			        parameter[4] = pPublicityCode;
			        parameter[5] = pLimitRange;
			        parameter[6] = pPageNum;
			        parameter[7] = tempSecurityDate;
			
			        var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG.aspx";
			        var feature = "status:no;dialogWidth:430px;dialogHeight:625px;help:no;scroll:no;edge:sunken;";
			        var RtnVal = window.showModalDialog(url, parameter, feature);
			
			        tempSecurity = RtnVal[0];
			        tempUrgent = RtnVal[1];
			        pSummery = RtnVal[2];
			        pSpecialRecordCode = RtnVal[3];
			        pPublicityCode = RtnVal[4];
			        pLimitRange = RtnVal[5];
			        pPageNum = RtnVal[6];
			        tempSecurityDate = RtnVal[7];
			        setPublicFlag();
			        SummaryFlag = true;
			    } catch (e) {
			        alert("ezdraftui_hwp.btnDocInfo_onclick()::" + e.description);
			    }
			}
			
			/*PublicType, PublicLevel 기존의 공개여부 2018-04-04 김은석 수정*/
			function setPublicFlag() {
			    try {
			        if (!message.FieldExist("publication"))
			            return;
			
			        var PublicType = pPublicityCode.substring(0, 1);
			        var PublicLevel = pPublicityCode.substring(1, 9);
			        //var PublicType2 = pPublicityCode2;
			        var PublicText = "";
			
			        if (pLimitRange != "")
			            PublicText = " (" + pLimitRange + ")";
			
			        if (PublicType == "1")
			            PublicText = "<spring:message code='ezApprovalG.t47'/>";
					else if (PublicType == "2")
					    PublicText = "<spring:message code='ezApprovalG.t150'/>" + getPublicLevel(PublicLevel);
					else if (PublicType == "3")
					    PublicText = "<spring:message code='ezApprovalG.t46'/>" + getPublicLevel(PublicLevel);
					else
					    PublicText = " ";
// 			        if (PublicType2 == "1")
// 			            PublicText = "<spring:message code='ezApprovalG.t47'/>";
// 			        else if (PublicType2 == "2")
// 			            PublicText = "<spring:message code='ezApprovalG.t150'/>";
// 			        else
// 			            PublicText = " ";
				    message.PutFieldText("publication", PublicText);
			
				} catch (e) {
				    alert("ezdraftui_hwp.setPublicFlag()::" + e);
				}
			}
	
		    /*기존의 공개여부 함수 2018-04-04 김은석 수정*/
		    function setPublicFlag2() {
		        if (!message.FieldExist("publication")) return;
		        var PublicType = pPublicityYN.substring(0, 1);

		        if (PublicType == "Y" || PublicType == "B")
		            PublicText = "<spring:message code='ezApprovalG.t47'/>";
		        else if (PublicType == "N")
		            PublicText = "<spring:message code='ezApprovalG.t46'/>";
		        else
		            PublicText = " ";
		        
		        message.PutFieldText("publication", PublicText);
		    }
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
			        alert("ezdraftui_hwp.getPublicLevel()::" + e.description);
			    }
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
			            var xmlCab = new ActiveXObject("Microsoft.XMLDOM");
			            xmlCab.loadXML(g_SelCabXml);
			            cabinetID = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/CABINETID"));
			            TaskCode = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/TASKCODE"));
			        }
			    } catch (e) {
			        alert("ezdraftui_hwp.btnSetTaskCode_onclick()::" + e.description);
			    }
			}
	
			var inssepattach_cross_dialogArguments = new Array();
			function btnAddSepAttach_onclick() {
				var deptCheckFlag = checkDeptAndCabinetId();
				
				if(nonElecRec == "Y") {
			    	return;
			    }
				
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
				
				    var g_SepAttachLVXml = "";
				    g_SepAttachLVXml = GetDocumentElement("sepattachlvxml", true);
				    if (!g_SepAttachLVXml)
				        g_SepAttachLVXml = "";
				
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

				    /* if (rtn[0] == "TRUE") {
				        g_SepAttachLVXml = rtn[1];
				        SetDocumentElement(HwpCtrl, "SepAttachLVXml", g_SepAttachLVXml);
				    } */
				} catch (e) {
				    alert("ezdraftui_hwp.btnAddSepAttach_onclick()::" + e);
				}
			}
			
			function btnAddSepAttach_onclick_Complete(rtn) {
				DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            g_SepAttachLVXml = rtn[1];
		            SetDocumentElement("sepattachlvxml", g_SepAttachLVXml);
		            
		            if (pDraftFlag == "REDRAFT") {
		            	GetHTML(before_saveFile);	            	
		            }
		        }
			}
			
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
					alert("ezdraftui_hwp.GetSepAttParamXml() : " + e.description);
				}
			}
	
			function btnhistory_onclick() {
				if(nonElecRec == "Y") {
			    	return;
			    }
				getHistory();
			}
			
			var pGubun;
			// var ezapprovalinfo_dialogArguments = new Array();
			function btnApprovalInfo(pGubun) {
				var deptCheckFlag = checkDeptAndCabinetId();
				
				if (deptCheckFlag == "3") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 기안창을 새로 띄워주시기바랍니다." );
					return;
				} else if (deptCheckFlag == "4") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 기안창을 새로 띄워주시기바랍니다.");
					return;
				}

				if (approvalFlag == "S" && pDraftFlag == "REDRAFT" && checkAprState() && ListType != "21") {
                    alert("<spring:message code='ezApprovalG.bhs23'/>");
                    window.returnValue = "CLOSE";
                    window.close();
                    return;
                }
			
			    try {
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
			        parameter[37] = pPageNum;
			        parameter[38] = tempSecurityDate;
			        parameter[39] = SummaryFlag;
			        parameter[40] = SummaryOuterReceiverList;
			        parameter[41] = tempItemName;
			        parameter[42] = tempItemName2;
			        parameter[45] = pPublicityYN;
			        parameter[46] = nonElecRec;
			        
			        if (nonElecRec == "Y") {
			        	parameter[2] = "1";
				        parameter[47] = "nonElecRecTempCabinet";
				        parameter[48] = nonElecRecInfoXml;
				        parameter[49] = nonSepAttachLVXml;
				        parameter[51] = sepAttachCheckYN;
			        }

			        if (useOpenGov == "YES") {
                        parameter[52] = basis;
                        parameter[53] = reason;
                        parameter[54] = listOpenFlag;
                        parameter[55] = fileOpenFlagList;
                        parameter[56] = limitDate;
					}

			        
			        if (tempItemCode != "")
			            tempdocnumcode = tempItemCode;
			
			        if (pGubun == undefined)
			            pGubun = CheckGubun;
			        
			        parameter[60] = passAprLine;
			        parameter[61] = tempKeyword;
			        
			        // ezapprovalinfo_dialogArguments[0] = parameter;
	                // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
			
	                var url = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun +"&docType=" + pDocType + "&ext=" + "hwp" + "&formID=" + pFormID;
			        //var feature = "status:no;dialogWidth:1140px;dialogHeight:750px;help:no;scroll:no;edge:sunken;";
			        //var ret = window.showModalDialog(url, parameter, feature);
			        // var ret = window.open(url, '', 'height=750,width=1210,scrollbars=no' + GetOpenPosition(1210, 750));
			        // var ret = window.open(url, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750));
					ezCommon_cross_dialogArguments[0] = parameter;
					showPopup(url, 1210, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
			    } catch (e) {
			        alert("ezdraftui_hwp.btnApprovalInfo()::" + e);
			    }
			}
			
			function btnApprovalInfo_Complete(ret) {
				hidePopup();
				if (ret != undefined && ret[0] == "OK") {
		            if (ret[1] != false) {
		            	$.ajax({
                    		type : "POST",
                    		dataType : "text",
                    		async : false,
                    		url : "/ezApprovalG/aprLineSave.do",
                    		data : {
                    				ret : ret[1]
                    				},
                    		success : function(text){
                    		}
                    	});
		
		                IsSkipDrafter = "FALSE";
		                btnSendDraftEnable = "true";
		                if (approvalFlag == "S") {
                            if (ret[32] == "Y") {
                                SReAprLineSingMapping(ret);
                            } else {
                                SGetDraftAprLineInfo(ret);
                            }
                        } else {
                            GetDraftAprLineInfo(ret);
                        }
		            }
		            
		            if (pSuSinFlag == "Y" && typeof (ret[2]) == "string") {
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
		                if (approvalFlag == "G") {
		                    SummaryOuterReceiverList = ret[15];
		                }
		                setRecevInfo(ret[3]);
		            } else if (pSuSinFlag == "Y" && ret[2] == "") {
		                DeleteDeptInfo();
		                setRecevInfo("");
		            }
		
		            if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
		                var g_SelCabXml = ret[4];
		                var xmlCab = loadXMLString(g_SelCabXml);
		                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
		                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		            }

					tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
		            tempSecurity = ret[7];
		            tempUrgent = ret[8];
		            pSummery = ret[9];
		            tempSecurityDate = ret[14];
		            pPublicityCode = ret[11];
		            pPublicityYN = ret[21];
		            if (approvalFlag == "G") {
                        pSpecialRecordCode = ret[10];
                        pLimitRange = ret[12];
                        pPageNum = ret[13];
                        if (ret[21].substring(0,1) == "N") {
                            tempPublic = "N";
                        } else if (ret[21].substring(0,1) == "Y") {
                            tempPublic = "Y";
                        } else if (ret[21].substring(0,1) == "B") {
                            tempPublic = "B";
                        }
                        setPublicFlag();

                        if (nonElecRec == "Y") {
                            nonElecRecInfoXml = ret[23];
                            nonSepAttachLVXml = ret[24];
                            sepAttachCheckYN = ret[26];
                            setNonElecRecInfo_whwp(nonElecRecInfoXml);
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
                            // passAprLine = ret[32];
                        }
		            }else{
                        //회람
                        if (ret[22] == "noItem") {
                            delAprLineInfoCC();
                            // ret[22] 값이 "noItem"일 경우 기존 데이터가 있을 수 있으므로 삭제함
                        } else if (ret[22] != "sameItem") {
                            //회람 저장
                            SaveAprLineInfoCC(ret[22]);
                        }

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

		         	// 2023-05-23 임정은 - 공람 추가
                	if (ret[22] == "noItem") {
                		delAprLineInfoCC();
                	} else if (ret[22] == "sameItem") {
                	} else {
                		SaveAprLineInfoCC(ret[22]);
                	}
					passAprLine = ret[32];
					SummaryFlag = true;
		        }
			}
	
			function btnSaveServer_onclick(AutoSave) {
				if (!!checkJobTransferStatus &&
						!checkJobTransferStatus("<c:out value ='${userInfo.id}'/>",
								"<c:out value ='${userInfo.deptID}'/>",
								"<c:out value ='${userInfo.jobId}'/>")) {
					window.close();
					return;
				}
				
				if(nonElecRec == "Y") {
			    	return;
			    }
				try {
			        if (pDraftFlag == "REDRAFT") {
			            if (AutoSave == "save") {
			                AutoSave = "";
			                return;
			            } else if (ListType != "21") {
			                var pAlertContent = "재기안시 임시저장 할 수 없습니다.";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			        }
			
			        if (AutoSave != "save") {
			            if (message.FieldExist("doctitle"))
			                pDocTitle = trim(message.GetFieldText("doctitle"));
			            else
			                pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
			
			            if (pDocTitle == "") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			
			            if (pDocTitle.length > 127) {
			                var pAlertContent = "<spring:message code='ezApprovalG.t132'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			        } else {
			            if (message.FieldExist("doctitle"))
			                pDocTitle = trim(message.GetFieldText("doctitle"));
			            if (pDocTitle == "")
			                return;
			        }
			
			        if (btnSendDraftEnable == "false" && ListType != "21") {
			            setFirstDrafterAuto();
			        }
			
			        //임시저장문서 삭제와 생성을 동시에
// 			        if (ListType == "21" && DraftFlag == "REDRAFT") {
// 			            RemoveTmpDoc(DocSN);
// 			        }
			        
			        if(Saveflag) {
		        		newpDocID = createNewDoc();
		        	}
			
			        message.GetTextFile("HWP", "", function (data) { exSaveTMPFile(data) }); 
			    } catch (e) {
			        alert("ezdraftui_hwp.btnSaveServer_onclick()::" + e.description);
			    }
			}
			
			function exSaveTMPFile(html, AutoSave) {
				var rtnVal = SaveTMPFile(html);
		        if (rtnVal == "TRUE") {
		            rtnVal = SaveTMPDocInfo(AutoSave, Saveflag);
		            if (rtnVal == "TRUE") {
		                if (AutoSave != "save") {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1581'/>";
		                    OpenAlertUI(pAlertContent);
		                    Saveflag = true;
		                    //window.close();
		                } else {
		                    Saveflag = true;
		                }
		            } else {
		                var pAlertContent = strLang217;
		                OpenAlertUI(pAlertContent);
		                return false;
		            }
		
		        } else {
		            var pAlertContent = strLang217;
		            OpenAlertUI(pAlertContent);
		            return false;
		        }
			}
	
	        function btnHelper_onclick() {
	        }
	
	        function window_onbeforeunload() {
	            if (bAttachProcess == false) {
	                if ((!draftFlag && DraftFlag == "DRAFT") || (!draftFlag && AprState == "" && DraftFlag == "REDRAFT"))
	                    UndoDoc();
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
		    		chk_Passwd();
		    	} else {
		    		 if (IsSkipDrafter == "FALSE" && nonElecRec != "Y") {
	                    //var ret;
	                    var parameter = new Array();
	
	                    parameter[0] = pDocID;
	                    openSignUI(parameter);
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
	    	
	    	// 웹 한글 기안기용
	    	function Editor_Complete() {
	    		showLoadingProgress();
	        	if (pFormHref != "") {
                    var URL;
                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(FormHref);
                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result); Editor_focus(); }, null);
	        	} else {
                    DraftFlag = "DRAFT";
                    pDraftFlag = "DRAFT";
                    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(sihangURL.replace(".mht", ".hwp"));
		        	message.Open(URL, "", "", function (res) { FieldsAvailable(res.result); Editor_focus(); }, null);
                }
	    	}
	    	
	    	function Editor_focus(){
	    		document.getElementById("message").contentDocument.getElementById("hwpctrl_frame").contentDocument.getElementById("ImeWrapper_Elm").focus();
	    	}
	    	
	    	function Editor_Complete2() {
	            setTimeout("Insert_ReUse_Content();", 1000);
	        }
	    	
	    	// OpenInformationUI 팝업용 메서드
	    	
	    	// 수신처 없을때 팝업
	    	function check_btnSendDraft(ans) {
		        DivPopUpHidden();
		        if (ans)
		            btnApprovalInfo(2);
		    }

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
	    		
	    		if (!Ans) return;
	    		
                if (pDraftFlag == "HABYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
                    getLastOpinon();
                }

                if (message.FieldExist("lastdraftdate"))
                    message.PutFieldText("lastdraftdate", getGyulJeDate());
                
                CheckUsePassword();
	    	}
	    	
	    	function chk_Passwd_Complete(chkpass) {
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
	    		
	    		if (IsSkipDrafter == "FALSE" && nonElecRec != "Y") {
                	//if (nonElecRec != "Y") {
	                    //var ret;
	                    var parameter = new Array();
	
	                    parameter[0] = pDocID;
	                    openSignUI(parameter);
                	//}
                } else {
                	GetHTML(saveDraftInfo);
                }
	    	}
	    	
	    	function openSignUI_Complete(ret) {
	    		DivPopUpHidden();
	    		
	    		if (ret == "cancel" || ret == undefined) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (approvalFlag == "S" && pDraftFlag == "REDRAFT" && checkAprState() && ListType != "21") {
                    alert("<spring:message code='ezApprovalG.bhs23'/>");
                    window.returnValue = "CLOSE";
                    window.close();
                    return;
                }
	    		
	    		// IsSkipDrafter == "FALSE" 에 대한 분기 시작	        	
	        	if (LastSignSN == 1 || DraftLastFlag) {
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_BEFORE");
                    if (!rtnVal) {
                        return;
                    }
                }

                var rtnval;
                if (LastSignSN == 1 || DraftLastFlag) {
                    //rtnval = getDocNumber(arr_userinfo[4], "", docNumZeroCnt);
                    rtnval = getDocNumberNew(arr_userinfo[4], "", docNumZeroCnt);
                }
                else {
                    //rtnval = getDocNumber(arr_userinfo[4], "be", docNumZeroCnt);
                    rtnval = getDocNumberNew(arr_userinfo[4], "be", docNumZeroCnt);
                }

                if (!rtnval) {
                    var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (LastSignSN == 1 || DraftLastFlag) {
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_AFTER");
                    if (!rtnVal) {
                        return;
                    }
                    rtnVal = ExcuteInfo("LAST_SIGN_BEFORE");
                    if (!rtnVal) {
                        return;
                    }
                }
                SendDraftMappingSign(ret);
                //rtnSignInfo = SendDraftMappingSign(ret);
                // IsSkipDrafter == "FALSE" 에 대한 분기 끝
                
				//GetHTML(saveDraftInfo);
	    	}
	    	
	    	function connInit() {
				var keywordXml = loadXMLString(GetDocumentElement("CONNROOT", true));
				var connNodes = SelectNodes(keywordXml, "CONNROOT/conn");

				if (connNodes.length>0) {
					if (pDraftFlag === "REDRAFT") {
						OpenAlertUI("연동문서는 다시 기안할 수 없습니다.<br/>문서보기 창으로 이동합니다.", function() {
							var url = "/ezApprovalG/ezviewAprWHWP.do" +
								"?docID=" + pDocID +
								"&docHref=" + pFormHref +
								"&opinionFlag=" + pHasOpinionYN +
								"&docState=" + DocState +
								"&listSusin=" + arr_userinfo[1] +
								"&oDoc=" + pOrgDocID +
								"&isOpinion=OPINION_SHOW" +
								"&listType=1" +
								"&CallBackType=" +
								"&ext=hwp" +
								"&orgCompanyID=" + orgCompanyID;

							window.open(url, "_self");
						});
						return;
					}
					
					if (pDraftFlag == "DRAFT") {
                        var connUrl = new URL(window.location.href);
                        var connParams = new URLSearchParams(connUrl.search);
                        
                        var connAttachCheck = connParams.get("connAttachCheck");
                        var messageStr = "";
                    
                        if (connAttachCheck != null && connAttachCheck != "") {
                            if (connAttachCheck != "TRUE") {
                                if (connAttachCheck == "ZERO_SIZE") {
                                    messageStr = "<spring:message code='ezApprovalG.connAttach01'/>";
                                } else if (connAttachCheck == "EXT_ERROR") {
                                    messageStr = "<spring:message code='ezApprovalG.connAttach02'/>";
                                } else if (connAttachCheck == "OVER_CNT") {
                                    messageStr = "<spring:message code='ezApprovalG.connAttach03'/>";
                                } else if (connAttachCheck == "OVER_SIZE") {
                                    messageStr = "<spring:message code='ezApprovalG.connAttach04'/>";
                                } else {
                                    messageStr = "<spring:message code='ezApprovalG.connAttach05'/>";
                                }
                                
                                messageStr += "<spring:message code='ezApprovalG.connAttach06'/>";
                                OpenAlertUI(messageStr, window.close);
                            }
                        }
                    }

					document.querySelector("#btnSaveServer").style.display = "none";

					setConnDefaultKey(pDraftFlag);
					if (pDraftFlag == "DRAFT") insertInitConnAttach();

					if (ConnExist(["conn;processidx;INIT", "conn;processtime;DRAFT", "query;qtype;UA"]) || ConnExist(["conn;processidx;INIT", "conn;processtime;DRAFT", "query;qtype;UA_EX"])) {
						document.querySelector("#btnConn").style.display = "";
					}

					setTimeout(function() {
						ExcuteInfo("INIT");
					}, 0);
				}
			}

			function btnConn_onclick() {
				ExcuteInfo("INIT");
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

			function UpdateDocNum() {
				if (!message.FieldExist("docnumber")) {
					console.log("message hasn't a docnumber field");
					return false;
				} else if (typeof message3 === "undefined" || message3 == null) {
					console.log("message3 is undefined");
					return false;
				} else if (!message3.FieldExist("docnumber")) {
					console.log("message3's docnumer property isn't exist");
					return false;
				} else if (typeof getDocNumByFormat === "undefined" || getDocNumByFormat == null) {
					console.log("function getDocNumByFormat is undefined");
					return false;
				}

				var numberFormat = message3.GetFieldText("docnumber");
				message.PutFieldText("docnumber", getDocNumByFormat(numberFormat));
			}
			
			function before_saveFile(html) {
				pSaveHtml = html;
				SaveFile();
			}

			// S버전 적용
            function SetAutoDocnumItem() {
                $.ajax({
                    type : "POST",
                    dataType : "text",
                    async : false,
                    url : "/ezApprovalG/getAutoDocNumItemCode.do",
                    data : {
                        formID : pFormID
                    },
                    success: function(result){
                        if (result.indexOf(';') == -1)
                            return;

                        var arrayVal = result.split(';');

                        if (arrayVal[4] == "Y") {
                            tempKeep = arrayVal[7];
                            tempSecurity = arrayVal[6];
                            tempPublic = arrayVal[0];
                            tempItemCode = arrayVal[1];
                            TaskCode = arrayVal[1];
                            cabinetID = arrayVal[8];
                            tempItemName = arrayVal[2];
                            tempItemName2 = arrayVal[3];
                            tempSecurityValue = arrayVal[6];
                            pPublicityCode = arrayVal[0];
                            SummaryFlag = true;
                            SetDocOption(arrayVal[5]);
                        }
                    }
                });
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
                var result = "";

                $.ajax({
                    type : "POST",
                    dataType : "text",
                    async : false,
                    url : "/ezApprovalG/checkAprState.do",
                    data : {
                        docID : pDocID,
                        docState : DocState,
                        userID : '',
                        aprMemberSN : wAprMemberSN,
                        orgCompanyID : orgCompanyID
                    },
                    success : function(text) {
                        result = text;
                    }
                });

                return result == "FALSE" ? true : false;
            }

			function Draft_AutoSave() {
				try{
					//상신중일때는 저장안되도록 추가
					if (DraftStatus == "ING") {
						return;
					}

					if (autopDocID != "") {
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezApprovalG/checkAutoSaveDocId.do",
							data : {
								docID : autopDocID
							},
							success: function(result){
								if(result != "TRUE"){
									autopDocSN = "";
									autopDocID = "";
									createAutoDoc = "N";
								}
							}
						});
					}

					if (autopDocSN == "") {
						autopDocSN = GetMaxTMPDocSN();
					}

					if (autopDocSN != "") {
						DraftStatus = "ING";
						var AutoSave2 = "autosave";

						if(Saveflag && autopDocID == "") {
							newpDocID = createNewDoc();
							autopDocID = newpDocID;
						}
						message.GetTextFile("HWP", "", function (data) { exSaveTMPFile2(data, AutoSave2) });
					}
				}
				catch(e)
				{
					DraftStatus = "NO"; //2024.02.06 자동저장관련 추가
				}

			}

			function exSaveTMPFile2(html, AutoSave) {
				var rtnVal = SaveTMPFile(html);
				if (rtnVal == "TRUE") {
					rtnVal = SaveTMPDocInfo(AutoSave, Saveflag);
					if (rtnVal == "TRUE") {
						draftFlag = "true";
						Saveflag = true;
						createAutoDoc = "Y";
						DraftStatus = "NO"; //2024.02.06 자동저장관련 추가
					}
				} 
			}

			// 자동 임시저장
			function GetMaxTMPDocSN() {
				var ret = "";

				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/getMaxTMPDocSN.do", // userInfo만 사용하므로 데이터는 전달할 필요 없음
					success: function(result) {
						if (result == "error") {
							var pAlertContent = strLang217;
							OpenAlertUI(pAlertContent);
							return false;
						} else {
							ret = result;
						}
					}, error : function () {} // 서버단에서 예외처리함. result를 error로 반환하므로 success에서 체크
				});

				return ret;
			}
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
						<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
				        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                        <li id="btnSelForm"><span onclick="return btnSelForm_onclick()"><spring:message code='ezApprovalG.t152'/></span></li>
	                        <%-- <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li> --%>
							<c:choose>
								<c:when test="${nonElecRec eq 'Y'}">
									<li id="btntotaldocinfo"><span onclick="return btnApprovalInfo('1')">문서정보</span></li>
	                        		<li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li>
			                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()">등록</span></li>
								</c:when>
								<c:otherwise>
									<li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
									<li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        		<li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li>
			                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
								</c:otherwise>
							</c:choose>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
	                        <li id="btnAddSepAttach"<c:if test="${approvalFlag == 'S'}"> style="display:none"</c:if>><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSave" style="display:none"><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnConn" style="display: none"><span onclick="return btnConn_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="btnSaveServer"><span onclick="return btnSaveServer_onclick()"><spring:message code='ezApprovalG.t4000'/></span></li>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
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
	        <c:if test="${empty beforeUrl}">
	        <tr>
	        	<td style="padding-bottom:10px;height:820px;" id="messageWHWPEditor">
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr>
	        </c:if>
	        <c:if test="${not empty beforeUrl}">
	        <tr>
	            <td>
	                <table width="100%" height="100%">
	                    <tr>
	                        <td style="padding-bottom:10px;height:800px;" id="messageWHWPEditor">
					    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
				            </td>
	                    </tr>
	                    <c:if test="${not empty beforeUrl}">
	                    <tr>
	                        <td style="vertical-align: top; height: 0%" id="form2">
					            <iframe id="message2" name="message2" src="/ezApprovalG/WHWPEditor.do?type=copyAppr"  style="background-color: White; height: 0px; width: 0px;"></iframe>
					        </td>
	                    </tr>
	                    </c:if>
	                </table>
	            </td>
	        </tr>
	        </c:if>
			<c:if test="${not empty formPath}">
			<tr style="display: none">
				<td style="vertical-align: top; height: 0%" id="form3">
					<iframe id="message3" name="message3" src="/ezApprovalG/WHWPEditor.do?type=form"  style="background-color: White; height: 0px; width: 0px;"></iframe>
				</td>
			</tr>
			</c:if>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style="width:30%;">
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
	                <table class="file" style="height: 20px;">
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
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	</body>
</html>
