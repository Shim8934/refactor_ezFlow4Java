<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:97%">
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
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}">
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draftG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/signSplit_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var FormHref	=	"<c:out value ='${formURL}'/>";
		    var DraftFlag	=	"<c:out value ='${draftFlag}'/>";
		    var DocType		=	"<c:out value ='${formDocType}'/>";
		    var SusinSN		=	"<c:out value ='${susinSN}'/>";
		    var DocState	=	"<c:out value ='${docState}'/>";
		    var ListType	=	"<c:out value ='${listType}'/>";
		    var AprState    =   "<c:out value ='${aprState}'/>";
		    var pEndDocHref	=   "<c:out value ='${dirPath}'/>";
		    var pFormHref = new String("");
		    var pFormID = new String();
		    var formName = "<c:out value ='${formName}'/>";
		    var pDocID = new String("");
		    var pHasAttachYN = new String("N");
		    var pHasOpinionYN = new String("N");
		    var FormProc = null;
		    var CurrentDate;
		    var flag = false;
		    var fieldflag = false;
		    var xmldoc = createXmlDom();
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
		    var drafterDeptid;
		    var docdir = "";
		    var pDocTitle;
		    var pMaxFileSize ='5';
		    var isExtDoc = "N";
		    var isTmpDocID = "<c:out value ='${isTmpDoc}'/>";
		    var gPublic = "";
		    var draftFlag = false;
		    var btnSendDraftEnable = "false";
		    var LastSignNo;
		    var TempsaveAprlineinfo;
		    var pCCType = "0";
		    var pLCatalogue = "";
		    var pMCatalogue = "";
		    var pperiod = "";
		    var pLClass = "";
		    var pMClass = "";
		    var pLCasn, pMCasn, pPer, pLClsn, pMClsn;
		    var approvalFlag = "<c:out value ='${approvalFlag}'/>";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
		    arr_userinfo[7] = "N";
		    arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    arr_userinfo[17]  = "<c:out value ='${userInfo.primary}'/>";
		    var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
		    var pTenantID = "<c:out value='${userInfo.tenantId}'/>";
		    var pUserID = arr_userinfo[1];
		    var KuyjeType = "002";
		    var signDateFormat = "<c:out value ='${optSignDateFormat}'/>";
		    var isSplit = "<c:out value ='${optisSplit}'/>";
		    var SplitKind = "<c:out value ='${optSplitKind}'/>";
		    var sihangURL = "<c:out value ='${sihangURL}'/>";
		    var CurAprType = "";
		    var NextAprType = "";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "";
		    var pSummaryPath = "";
		    var pLimitRange = "", pPageNum = "1";
		    var cabinetID = "";
		    var TaskCode = "";
		    var keepperiod = ""; // 보존년한 2019-03-22 임민석
		    var DocNumCode = "";
		    var SummaryFlag = false;
		    var btnReceivLineEnable = false;
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var HapyuiArea = 0;
		    var AprLineArea = 0;
		    var CheckGubun = "1";
		    var DocSN = "<c:out value ='${docSN}'/>";
		    var AutoSave = "save";//자동임시저장
		    var Saveflag = true;//임시저장Flag
		    var pPageType = "DRAFTUI";
		    var pUse_Editor = "<c:out value ='${useEditor}'/>";
		    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
		    var SummaryOuterReceiverList = "";
		    var checkdocinfo = false;
		    var junGyulFlag = "<c:out value ='${junGyulFlag}'/>";
		    var draftJunGyulFlag = "<c:out value ='${draftJunGyulFlag}'/>";
		    var pSignImage_Size = "<c:out value ='${signImageSize}'/>";
		    var docNumZeroCnt = "<c:out value ='${docNumZeroCnt}'/>";
			var beforeUrl = "<c:out value ='${beforeUrl}'/>";
			//회람
			var type = "ING";
			var pGongRamDocID = "";
			var signImageType = "<c:out value ='${signImageType}'/>";
			var isUsed = "<c:out value ='${isUsed}'/>";
			var beforeDocID = "<c:out value ='${beforeDocID}'/>";
			var addLastKyulJeYN = "<c:out value ='${addLastKyulJeYN}'/>";
			var totalMemSN = "0";
			var apprReuseConfig = "<c:out value ='${apprReuseConfig}'/>";
			var agreeResultType = "<c:out value ='${agreeResultType}'/>";
			var curDocNum = "";
			var isEditorComplete = false;
			var orgCompanyID = "<c:out value ='${userInfo.companyID}'/>";
			var isHWP = "";
			var ext = "mht";
			var nonElecRec = "<c:out value ='${nonElecRec}'/>";
			var nonElecRecInfoXml = "";
			var nonSepAttachLVXml = "";
			var sepAttachCheckYN = "";
			var reformFlag = "${reformflag}";
			var wAprMemberSN = "1";
			<%-- 2021-01-21 심기영 오피스 양식 여부 --%>
			var officeFlag = "<c:out value='${officeFlag}'/>";
			//원문정보공개
            var useOpenGov = "<c:out value ='${useOpenGov}'/>";
			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			var newpDocID = "";
			var useRedraftOpinionKeep = "<c:out value='${useRedraftOpinionKeep}'/>";
			var formAprOption = "<c:out value='${formAprOption}'/>";
			var passAprLine = "";
	        var useDynamicAprLine = "<c:out value ='${useDynamicAprLine}'/>";
			var isTmpDocCanApprov = false;
			var pConnKey = "<c:out value ='${connKey}'/>";
	        var pConnFormCode = "<c:out value ='${connFormCode}'/>";
			var useWebHWP = "<c:out value ='${useWebHWP}'/>";
			
			//부서감사 관련 2020-01-14 홍대표
			var deptgamsaCount = 0;
			
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
			var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>";
	        
			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			var attachedDocList = "${ attachedDocList }";
			
			// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
			var useHideHeaderArea = "<c:out value ='${useHideHeaderArea}'/>";
            
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
			var ReturnFunction;

            var isPreview = "<c:out value ='${isPreview}'/>";
			
		    window.onload = function ()
		    {
		    	if (isParentCommonArgsUsed()) {
					ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
				}
				
				if(officeFlag == 'Y'){
		    		window.resizeTo(1920, 1200);
		    		 var sw = screen.width;
		    		 var sh = screen.height;
		    		 var cw = document.body.clientWidth;
		    		 var ch = document.body.clientHeight;
		    		 var top  = sh / 2 - ch / 2 - 100;
		    		 var left = sw / 2 - cw / 2;
		    		 window.moveTo(left, top);
		    	}
		        try {
		            pSusinSN = SusinSN;
		            setMenuBar("btnSendDraft", true);
		            dragNdrapNo();	
		        } catch(e){
		            showAlert(e.description + ": window_onload");
		        }
		        
		        if(approvalFlag == "G") {
		        	$("#btnAddSepAttach").css("display","");
	        	}
		        
		        if(officeFlag == "Y") {
		        	document.getElementById("mailPanel").style.display = "";
		        	document.getElementById("layerpopup").style.display = "";
		        	document.getElementById("iFrameLayer2").src = "/ezApprovalG/officeAttach.do";
		        	document.getElementById("message").src = "/ezApprovalG/draftContent.do?isUsed=${isUsed}&officeFlag=officeFlag";
		        } else {
		        	document.getElementById("message").src = "/ezApprovalG/draftContent.do?isUsed=${isUsed}";
		        }
		        
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
			};

			function dragNdrapNo() {
		        try{
		            var div = document.getElementById('lstAttachLink');
		            div.ondragenter = div.ondragover = function (e) {
		                return false;
		            }
		            div.ondrop = function (e) {
		                showAlert("<spring:message code='ezApprovalG.pjj30'/>");
		                return false;
		            }
		            
                    var div2 = document.getElementById('lstAttachLinkDoc');
                    div2.ondragenter = div.ondragover = function (e) {
		                return false;
		            }
		            div2.ondrop = function (e) {
		                showAlert("<spring:message code='ezApprovalG.noDrag.jih01'/>");
		                return false;
		            }
		            
		            var html = document.getElementsByTagName('html')[0];
		            html.ondragover = function (e) {
		            	if (e.target.id == 'lstAttachLink' || e.target.id == 'lstAttachLinkDoc') { return false; }
		            	
		            	e.dataTransfer.dropEffect = "none";
				        e.stopPropagation();
				        e.preventDefault();
		            }	            
		        } catch(e) {
		            showAlert("ezdraftui.dragNdrapNo()::" + e.description);
		        }
		    }
		    var noFieldsAvailable = false;
		    function FieldsAvailable() {
	    	
		        if (noFieldsAvailable) {
		            noFieldsAvailable = false;
		        }
		        else {
		            SetBtnStateTrue();
		            setAutoProperty();
		            if (pFormHref == "") {
		                getExtInfo();
		            }
		            if (pReadPC) {
		                pFormID = message.DocumentBodyGetAttribute("FORMID");
		
		                if (pFormID != "") {
		                    DocType = GetFormType(pFormID);
		                    pDocType = DocType;
		                }
		            }
		            process_AfterOpen();
					connInit();
		            /*
		            * 재기안인 경우
		            * 1. 임시보관함에서는 기존에 저장된 내용이 있어서 수신처 값을 초기화하지 않는다.
		            * 2. 반송된 문서를 재기안할 때는 고정수신처 값을 불러온다.
		            */
		            if (pDraftFlag == "REDRAFT") {
		            	if (ListType == "21") {
		            		setFirstDrafter(isUsed, "");
		            	}
						// 재기안시 고정수신처 여부와 상관없이 직전 수신처를 불러오도록 함
						/*else {
		            		if(approvalFlag == "G") {
		            			getFormRecv();	
		            		}
		            	}*/
		            	
		                //getFormRecv();
		                message.SetEditable(true);
		            }
		
					if (pDraftFlag != "REDRAFT") {
						if(isUsed == "reuse" && apprReuseConfig != "1") {
							setFirstDrafter(isUsed, beforeDocID);

							field = message.GetListItem(message.GetFieldsList(), "opinions");
							if (field) {
								field.innerHTML = " ";
							}
						}
						setFirstDrafter("", "");
					}
		            
		            if (approvalFlag == "S") {
		            	// 임시보관함에서 기안할 때, 자동분류코드가 로드안되는 문제 해결 | 임시저장문서 재기안 시, 기존에 저장한 분류코드 설정이 있기 때문에 양식에 설정된 자동분류코드를 로드하지 않는다.
	            		if (ListType == "21") {
	            			if (pDraftFlag != "REDRAFT") {
					            SetAutoDocnumItem();
	            			}
		            	} else {
				            SetAutoDocnumItem();
		            	}
		            }
		            
	                /* 2021-04-08 홍승비 - 비전자문서 구분 값, 사용불가한 버튼들 가리기 + 비전자문서 양식의 문서번호 초기화 */
			        if(nonElecRec == "Y") {
	                	document.getElementById("btnSelForm").style.display = "none"; // 양식선택
	                	document.getElementById("btnAddSepAttach").style.display = "none"; // 분리첨부
	                	document.getElementById("btnSaveServer").style.display = "none"; // 임시저장
	                	document.getElementById("btnHelper").style.display = "none"; // 연동
	                	document.getElementById("btnhistory").style.display = "none"; // 변경내역
	                	document.getElementById("btnSave").style.display = "none"; // 저장
	                	document.getElementById("btnOpinion").style.display = "none"; // 의견
	                	document.getElementById("btnAprDocAttach").style.display = "none"; // 문서첨부
	                	document.getElementById("btnPrint").style.display = "none"; // 인쇄
	                	
	                	var fields = message.GetFieldsList();
						field = message.GetListItem(fields, "docnumber");
	     	            if (field) {
	     	                setNodeText(field , "");
	     	            }
			        }
	                
	                checkHeaderAction();
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
		    }
		    
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
		
		    function addInput(form, name, value){
		        var hidden = document.createElement("input");
                hidden.type = "hidden";
                hidden.name = name;
                hidden.value = value;
                form.appendChild(hidden);
		    }
		    
	    	function connInit() {
				var connRootText = GetDocumentElement("CONNROOT");
				if (connRootText) {
					if (pDraftFlag === "REDRAFT") {
						OpenAlertUI("연동문서는 다시 기안할 수 없습니다.<br/>문서보기 창으로 이동합니다.", function() {
                            const form = document.createElement("form");
                            form.method = "post";
                            form.action = "/ezApprovalG/view.do";
                            addInput(form, "docID", pDocID);
                            addInput(form, "listSusin", arr_userinfo[1]);
                            addInput(form, "isOpinion", "OPINION_SHOW");
                            addInput(form, "listType", "1");
                            form.submit();
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
                                // OpenAlertUI(messageStr, window.close);
                                OpenAlertUI(messageStr, btnClose_onclick2);
                            }
					    }
					}

					if (isEditorComplete) {
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
			}
		
		    function GetFormType(pFormID) {
		        var Result = "";
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		data : {
		    			formID : pFormID,
		    			companyID : pCompanyID
		    		},
		    		url : "/ezApprovalG/getFormDetail.do",
		    		success: function(xml){
		    			xml = loadXMLString(xml);
			            if (xml.getElementsByTagName("FORMDOCTYPE").length > 0) {
			                Result = xml.getElementsByTagName("FORMDOCTYPE").item(0).text;
			            }
		    		}        			
		    	});

		        return Result;
		    }
		    function openForm() {
		        openFormUI();
		    }
		    function btnHelper_onclick() {
		        var rtnVal = ExcuteInfo("INIT");
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
		                    }
		                    else {
		                        pDocID = isTmpDocID;
		                    }
		                    GetAprDocFormID();
		                    setAttachInfo(pDocID, "APR", lstAttachLink);
		                    GetExchInfo();
		                    getDocInfo();
		                    
		                    /* 2023-12-05 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
		                    // 수신문서 > 수신부서 결재 중 반송 > 재기안인 경우에는 수신문서 접수 페이지로 열리므로, 내부기안 페이지에서는 해당 분기 처리하지 않음
					        message.startRemapAllAprSign_MHT(pDocID, orgCompanyID);
		                    
		                    if (pHasOpinionYN == "Y") {
		                        if (AprState == "<spring:message code='ezApprovalG.t49'/>") {
		                            pInformationContent = "<spring:message code='ezApprovalG.t124'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        } else {
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
								}
								
		                        OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                    }
		                }
		                else if (pDraftFlag == "SUSIN" || pDraftFlag == "GONGRAM") {
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
		
		                        pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        Ans = OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                    }
		                }
		                else if (pDraftFlag == "HAPYUI") {
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
		                        pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                    }
		                }
		                else {
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

		                     	if (isUsed == "reuse") {
									 // 재사용이고 문서의 모든정보를 재사용 할시
									ClearDocCellInfo();
				                	if( apprReuseConfig != '1' ){
			                			getDocInfo();
				                		setAttachInfo(pDocID, "APR", lstAttachLink);
                                        copySummary(beforeDocID, "END", pDocID);
				                	}
				                	
				                	if ($("#message").contents().find("#autoLine") != null && $("#message").contents().find("#RecvautoAprLine") != null) {
				                		$("#message").contents().find("#RecvautoAprLine").remove();
				                	}
			                	}
		                    }
		                }
		            }
		        } catch (e) {
		            showAlert("process_AfterOpen : " + e.description);
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
		        var check = Form_check();
		        if (check == "OK")
		            openForm();
		    }
		    function btnSetAprLine_onclick() {
		        try {
		            var ret;
		            ret = openAprLineUI();
		            TempsaveAprlineinfo = ret[0];
		            if (ret[3] != "" && ret[3] != "cancel") pPublic = ret[3];
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
		            showAlert("btnSetAprLine_onclick : " + e.description);
		        }
		    }
		    function btnSetReceivLine_onclick() {
		        try {
		            var ret = openReceivUI();
		            if (ret != "cancel") {
		                btnReceivLineEnable = false;
		                setRecevInfo(ret);
		            }
		            else {
		                var fields = message.GetFieldsList();
		                if (CrossYN()) {
		                    var field = message.GetListItem(fields, "recipients");
		                    if (field) field.textContent = "";
		                }
		                else {
		                    var field = pzFormProc.fields("recipients");
		                    if (field) field.textContent = "";
		                }
		            }
		        }
		        catch (e) {
		            showAlert("btnSetReceivLine_onclick : " + e.description);
		        }
		    }
		    function btnSendDraft_onclick() {
                if (GetDocumentElement("WORKFLOW")) {
                    var rtn = checkValidation();
                    if (rtn == "FALSE") {
                        return;
					}
	            }

	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
				if (deptCheckFlag == "3") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "' " + strLanggarm03 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm04 );
					return;
				} else if (deptCheckFlag == "4") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm05);
					return;
				} else if (deptCheckFlag == "2" && upperDeptCode == "") {
					showAlert("타부서의 철정보로 설정되어있습니다. \n'" + replaceEntityCodeToStr(arr_userinfo[5]) + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}

                if (useOpenGov == "YES") {
                    $.ajax({
                        type : "POST",
                        dataType : "text",
                        async : false,
                        url : "/ezApprovalG/openGovInfoSave.do",
                        data : {
                            openGovListFlag : listOpenFlag,
                            fileOpenFlagList : fileOpenFlagList,
                            basis : basis,
                            reason : reason,
                            publicity : pPublicityCode,
                            docID : pDocID,
                            limitDate : limitDate
                        }
                    });
                }
		    	
		        try {
		        	if (isEditorComplete == true) {
		        		if (pDraftFlag == "REDRAFT" && checkAprState() && ListType != "21") {
		        			showAlert("<spring:message code='ezApprovalG.bhs23'/>", "CLOSE");
			    			// window.returnValue = "CLOSE";
			    			// window.close();
			    			return;
				    	}
		        		//재기안 시, 문서내 기안일자와 현재일자가 다른지 체크 추가
		        		if (pDraftFlag == "REDRAFT") {
		        			compareDocDateCurDate();
		        		}
		        	
			        	var result = "";
			        	
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
				    			result = text;
				    		}        			
				    	});
				    	
			            var rtnAttachXML = createXmlDom();
			            rtnAttachXML = loadXMLString(result);
			            if (getNodeText(rtnAttachXML.getElementsByTagName("FLAG")[0]) == "Y") {
			                OpenAlertUI("<spring:message code='ezApprovalG.pjj04'/>" + "<br>" + "<spring:message code='ezApprovalG.pjj05'/>");
			                return;
			            }
			            bAttachProcess = false;
			            if (typeof (message.GetTagList("BODY").length) != "undefined") {
			                if (message.GetTagList("BODY").length > 1) {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t128'/>" + "<br>" + "<spring:message code='ezApprovalG.t129'/>";
			                    OpenAlertUI(pAlertContent);
			                    return;
			                }
			            }
			            
	                    //2017.07.12 건국대 시행문일경우 본문에 이미지 삽입되어있으면 상신안되게 변경
	                    //2020-01-20 홍대표. 외부발송문서 본문에 이미지와 링크를 입력하지 못하도록 수정. 닷넷참고
	                    if (approvalFlag == "G" && pDocType == "001") {
	                        var objElem = document.createElement("div");
	                        objElem.innerHTML = message.GetBodyHTML();
	                        var objElems = objElem.getElementsByTagName("*");
	                        for (var i = 0; i < objElems.length; i++) {
	                            if (objElems.item(i).tagName.toUpperCase() == "IMG" || objElems.item(i).tagName.toUpperCase() == "A") {
	                                var pAlertContent = strLang1038;
	                                OpenAlertUI(pAlertContent);
	                                return;
	                            }
	                        }

// 	                     	if (message.GetBodyHTML() != beforeEncode) {
// 	                            var pAlertContent = strLang1039;
// 	                            Alert_Message(pAlertContent, Document_Encode, "");
// 	                            return;
// 	                        }
	                    }
			            
			            var rtnSignInfo;
			            var fields = message.GetFieldsList();
			            pDocTitle = trim_Cross(message.GetDocTitle());
			            
			            var mustField = message.getMustFieldsInsert("<c:out value ='${userInfo.lang}'/>");
			            if (mustField && mustField != ""){
 			            	var pAlertContent = "<spring:message code='ezApprovalG.psb131'/>";
 			            	pAlertContent = pAlertContent.replace("@@", mustField);
 			                OpenAlertUI(pAlertContent);
 			                return;
			            }
			            if (pDocTitle.length > 127) {
			                var pAlertContent = "<spring:message code='ezApprovalG.t132'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			            
			            if (approvalFlag == "G") {
			            	if (nonElecRec == "Y" && nonElecRecInfoXml == "") {
			            		var pAlertContent = "기록물 정보를 입력해 주세요.";
				                OpenAlertUI(pAlertContent, setNonElecRecApprovalInfo);
				                return;
			            	}
			            	
				            if (cabinetID == "") {
				                var pAlertContent = "<spring:message code='ezApprovalG.t134'/>";
				                OpenAlertUI(pAlertContent, check_btnSendDraft);
				                return;
				            }
				            
				            if (nonElecRec != "Y") {
					            if (cabinetID.substring(0, arr_userinfo[4].length).toLowerCase() != arr_userinfo[4].toLowerCase() && upperDeptCode == "") { // 상위부서문서함 사용 > 타 부서 기록물철 사용 가능
					                var pAlertContent = "<spring:message code='ezApprovalG.t135'/>" + "<br>" + "<spring:message code='ezApprovalG.t136'/>";
					                OpenAlertUI(pAlertContent);
					                return;
					            }
				            }
			            } else {
				            if (cabinetID == "") {
				                var pAlertContent = "<spring:message code='ezApprovalG.t137'/>";
				                OpenAlertUI(pAlertContent, check_btnSendDraft);
				                return;
				            }
			            }
			            
			            if (btnSendDraftEnable == "false") {
			            	var pAlertContent = "";
			            	//재기안의 경우 결재선 확인하라는 메세지 출력
			            	if (DraftFlag == "REDRAFT") {
				                pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
			            	} else {
				                pAlertContent = "<spring:message code='ezApprovalG.t139'/>" + "<br>" + "<spring:message code='ezApprovalG.t140'/>";
			            	}
			            	
							OpenInformationUI(pAlertContent, check_btnSendDraft2);
			                return;
			            }
			            /* 2020-10-05 홍승비 - 임시보관함에서 결재선 지정 없이 기안하는 경우 예외처리 추가 (지정된 결재선이 존재한다면, 결재정보 확인 없이도 기안 가능) */
			            if (ListType == "21" && !checkTmpLines(DocSN) && isTmpDocCanApprov == false) {
			            	var pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
							OpenInformationUI(pAlertContent, check_btnSendDraft2);
			                return;
			            }
			            
			            if (!checkLines()) {
			                return;
			            }
			            // 재기안일 경우 pDocType에 DocType 넣기
			            if (DraftFlag == "REDRAFT") {
			            	pDocType = DocType;
			            }
			            
			            if (pDocType == "003" && pSuSinFlag == "Y") {
			            	if (!btnReceivLineEnable) {
						        var fields = message.GetFieldsList();
								if (getNodeText(message.GetListItem(fields, "recipient")) == "") {
					                var pAlertContent = "<spring:message code='ezApprovalG.t141'/>" + "<br>" + "<spring:message code='ezApprovalG.t142'/>";
					                OpenInformationUI(pAlertContent, check_btnSendDraft3);
					                return;								
								}
			            	}
							
							if ($("#message").contents().find("#autoLine") != null) {
		                		if ($("#message").contents().find("#RecvautoAprLine").length <= 0) {
									var oDIV = document.createElement("DIV");
									oDIV.className = "FIELD";
									oDIV.id = "RecvautoAprLine";
									
			                		$("#message").contents().find("#autoLine").append(oDIV);
		                		}
		                	}
			            }
			            
			            if (isUsed ==  "reuse") {
			            	var pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
			            	OpenInformationUI(pAlertContent, check_ReUsed);	
			            	return;
			            }
			            
				        //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 마이너스 연차 사용이 허용 안함일 경우
				        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {	
				        	if (document.message.document.iframe_content.useMinusAnnual == "0") {
				        		if(document.message.document.iframe_content.document.getElementById("remain_annual_cnt").innerHTML.indexOf("-") != -1) {
				        			OpenAlertUI("<spring:message code='ezAttitude.t266'/>");
				        			return;
				        		}
				        		
				        	}
				        	
				        	var reformTitle = document.message.document.iframe_content.document.getElementById("reform-title").value;
// 					        var titlePattern = /(\d{4})년(\d{1,2})월(\d{1,2})일~(\d{4})년(\d{1,2})월(\d{1,2})일\[(\d{1,2})일\]/
							
					        if (reformTitle == "" ) {
								OpenAlertUI("<spring:message code='ezAttitude.t307'/>");
								return;
							} 
// 					        else if (!titlePattern.test(reformTitle.replace(/ /gi, ""))) {
// 								OpenAlertUI("<spring:message code='ezAttitude.t308'/>");
// 								return;
// 							}
					        
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
		                				flag      : "draft"
		                				},
		                		success : function(result){
		                			totalMemSN = result;
		                		}
		                	});
				        }
			            
			            setDrafterAddress();
			            
			            if (pDraftFlag == "REDRAFT") {
			                delOpinionInfo();
			            }
			            
			          	//2020-11-19 정소미 - 채용 양식일 경우
			            if (message.GetListItem(message.GetFieldsList(), "hiredatechk") != null) {
			            	var fields = message.GetFieldsList();
			            	if (getNodeText(message.GetListItem(fields, "hiredatechk")) == "") {
			            		OpenInformationUI("채용일자 없이 진행하시겠습니까?<br>- 채용일자는 면접 후 최종 보고 시에만 입력<br>- 채용계획, 서류 결과 보고 시에는 입력 불필요", check_btnSendDraft4);
			        			return;
			            	}
			            }

			            /* 2022-03-23 홍승비 - 비전자문서가 아닌 경우, 결재올림 시 문서번호 재설정 진행 */
			        	if (nonElecRec != "Y") {
							UpdateDocNum();
			        	}
			        	
			            if (nonElecRec != "Y" && (LastSignSN == 1 || DraftLastFlag)) {
				            if (LastSignSN == 1 || DraftLastFlag) {
				                var pInformationContent = "<spring:message code='ezApprovalG.t143'/>" + "<br>" + "<spring:message code='ezApprovalG.t144'/>";
				                OpenInformationUI(pInformationContent, check_btnSendDraft4);
				            }
				            else
				                CheckPassWord();
			            } else {
			                CheckPassWord();
			            }
		        	} else {
		        		OpenAlertUI("<spring:message code='ezApprovalG.pjg02'/>");
		        	}		            
		        } catch (e) {
		            showAlert("btnSendDraft_onclick()" + e.description);
		        }
		    }
			
		    function delOpinionsExceptDrafters() {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/delOpinionsExceptDrafters.do",
		    		data : {
		    			docID : pDocID,
		    			userID : pUserID
		    		},
		    		success: function(result) {
		    			
		    		}
		    	});
		    }
		    
		    function check_ReUsed(ans) {
		    	DivPopUpHidden();
		    	if (ans) {
		    		btnApprovalInfo(1);
		    	} 
		    }
		    
		    function CheckPassWord() {
		    	var result = "";
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getApprovalPWD.do",
		    		success: function(text){
		    			result = text;
		    		}        			
		    	});
		    	
		        if (result != "N") {
		            chk_Passwd();
		        }
		        else {
		            if (IsSkipDrafter == "FALSE" && nonElecRec != "Y") {
		                var ret;
		                var parameter = new Array();
		
		                parameter[0] = pDocID;
		                openSignUI(parameter);
		            }
		            else {
		                saveDraftInfo();
		            }
		        }
		    }
		
		    function chk_Passwd_Complete(chkpass) {
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
		
		        if (IsSkipDrafter == "FALSE" && nonElecRec != "Y") {
		            var ret;
		            var parameter = new Array();
		
		            parameter[0] = pDocID;
		            openSignUI(parameter);
		        }
		        else {
		            saveDraftInfo();
		        }
		    }
		
		    function saveDraftInfo() {
		        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
		            var RtnVal;
		            var pAlertContent;
		            RtnVal = setSusinUpdataDocID();
		            if (RtnVal == "true") {
		                RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
		                if (!RtnVal) {
		                    return;
		                }
		                if (RtnVal) RtnVal = SaveDraftDocInfo();
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
		                    pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
		                    OpenAlertUI(pAlertContent, Complete_Deaft);
		                }
		                else {
		                    UndoSignInfo(rtnSignInfo);
		                    if (LastSignSN == 1 || DraftLastFlag) {
		                        RtnVal = ExcuteInfo("END_FAIL");
		                        if (!RtnVal) {
		                            return;
		                        }
		                    }
		                    pAlertContent = "<spring:message code='ezApprovalG.t147'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		                SetBtnStateTrue();
		                btnSendDraftEnable = "true";
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("END_FAIL");
		                    if (!RtnVal) {
		                        return;
		                    }
		                }
		                pAlertContent = "<spring:message code='ezApprovalG.t147'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        else {
		            var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
		            var pAlertContent;
		            if (!RtnVal) {
		                return;
		            }
		
		            if (LastSignSN == 1 || DraftLastFlag)
		                SetAutoPropFinal();
		
		            if (LastSignSN == 1 || DraftLastFlag) {
		                message.DocumentBodySetAttribute("SA_LastUserID", pUserID);
		                message.DocumentBodySetAttribute("SA_ProcUserID", pUserID);
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
		                } else {
		                	Gyuljedate = GetDocInfoData("APR", "STARTDATE");
	                        CurrentAprType = "001";
	                        CurrentAprUserID = pUserID;
	                        
	                        if (passAprLine != "Y") { //기결재통과 알림메일은 자바단에서 구현
		                        sendAlertMail("APR", 1, "DRAFT");
	                        }
		                }
		                UpdateLineHistory();
		
		                if (nonElecRec == "Y") {
                        	pAlertContent = "문서를 [등록]하였습니다.";
                        } else {
							pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
                        }
		                OpenAlertUI(pAlertContent, Complete_Deaft2);
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		                if (LastSignSN == 1) {
		                    rollbackDocNumber(arr_userinfo[4], "", pDocID);
						}
		                SetBtnStateTrue();
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("END_FAIL");
		                    if (!RtnVal) {
		                        return;
		                    }
		                }
		                pAlertContent = "<spring:message code='ezApprovalG.t147'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		    }
		
		    function Complete_Deaft() {
		        draftFlag = true;
		      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && typeof(parent.opener.getApprovalList) != 'unknown' && parent.opener.getApprovalList != undefined) { 
		        	parent.opener.clearAbsence(true);
		        }
		        //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가
		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
		        	document.getElementById('message').contentWindow.document.getElementById('iframe_content').contentWindow.attitude_annual_conn("annual", "0");
		        }	        
		        
		        // window.close();
				btnClose_onclick2();
		    }
		
		    function Complete_Deaft2() {
		        draftFlag = true;
		        if (ListType == "21") {
		            RemoveTmpDoc(DocSN);
		        }
		        
		        if (nonElecRec == "Y") {
                	RemoveEndNonElecRecDoc(pDocID);
                }

				if (autopDocSN != "") {
					RemoveTmpDoc(autopDocSN);
				}
				
		        
		      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		      if(pConnKey == "") {
		        if (parent.opener != null && typeof(parent.opener.getApprovalList) != 'unknown' && parent.opener.getApprovalList != undefined) {
		        	parent.opener.clearAbsence(true);
		        }
		        //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가--아직 개발중
		        if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
		        	document.getElementById('message').contentWindow.document.getElementById('iframe_content').contentWindow.attitude_annual_conn("annual", "0");
		        }
		      }
		        
		        // window.close();
				btnClose_onclick2();
		    }
		
		    function openSignUI_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        
		        if (pDraftFlag == "REDRAFT" && checkAprState() && ListType != "21") {
		        	showAlert("<spring:message code='ezApprovalG.bhs23'/>", "CLOSE");
	    			// window.returnValue = "CLOSE";
	    			// window.close();
	    			return;
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
                				flag      : "draft"
                				},
                		success : function(result){
                			totalMemSN = result;
                		}
                	});
		        }
		        
		        pOrgHtml = message.Get_EditorBodyHTML();
		        if ((LastSignSN == 1 && totalMemSN == 0) || DraftLastFlag) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		        }
		        
		        var rtnval;
		        if ((LastSignSN == 1 && totalMemSN == 0)|| DraftLastFlag) {
		            rtnval = getDocNumberNew(arr_userinfo[4], "", docNumZeroCnt);
		        }
		        else {
		            rtnval = getDocNumberNew(arr_userinfo[4], "be", docNumZeroCnt);
		        }
		
		        if (!rtnval) {
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
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

		        rtnSignInfo = SendDraftMappingSign(ret);
				rtnVal = ExcuteInfo("LAST_SIGN_AFTER");
				if (!rtnVal) {
					return;
				}

		        saveDraftInfo();
		    }
		
		    function check_btnSendDraft() {
		        DivPopUpHidden();
		        btnApprovalInfo(3);
		    }
		    /* 2020-06-19 홍승비 - 임시보관함에서 기안 > 결재선 지정 없이 임시저장하는 경우, 결재정보창 열릴때 결재선 탭이 열리도록 수정*/
		    function check_btnSendDraft_temp() {
		        DivPopUpHidden();
		        btnApprovalInfo(1);
		    }
		    function check_btnSendDraft2(ans) {
		        DivPopUpHidden();
		        if (ans)
		            btnApprovalInfo(1);
		    }
		    function check_btnSendDraft3(ans) {
		        DivPopUpHidden();
		        if (ans)
		            btnApprovalInfo(2);
		    }
		    function check_btnSendDraft4(ans) {
		        DivPopUpHidden();
		        if (!ans) return;
		        if (pDraftFlag == "HABYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
		            getLastOpinon();
		        }
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "lastdraftdate");
		        if (field) {
		            var CurrentDate = getGyulJeDate();
		            field.textContent = CurrentDate;
		        }
		
		        CheckPassWord();
		    }
		    
		    function btnFileAttach_onclick() {
		        try {
		            var ret = openFileAttachUI();
		        } catch (e) {
		            showAlert("btnFileAttach_onclick : " + e.description);
		        }
		    }
		    function btnAprDocAttach_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
				if (deptCheckFlag == "3") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "' " + strLanggarm03 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm04 );
					return;
				} else if (deptCheckFlag == "4") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm05);
					return;
				}
				
		        var ret = openAaprDocAttachUI();
		    }
		    function btnOpinion_onclick() {
		        //var ret = openOpinionUI("N");
		    	openOpinionUI_New("");
		    }
		    function btnSave_onclick() {
		        if (message.Get_EditorBodyHTML() == "") {
		            OpenAlertUI("<spring:message code='ezApprovalG.t96'/>");
		            return;
		        }
		
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "frame_doctitle");
		        if (field)
		            pDocTitle = field.value;
		
		        pDocTitle = trim_Cross(pDocTitle);
		
		        if (pDocTitle == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t101'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        var rtnVal = SavePCFile();
		        AttachDownFrame.location.href = rtnVal;
		    }
		
		    function SavePCFile() {
		
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "DocTitle", pDocTitle);
		        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
		        createNodeAndInsertText(xmlpara, objNode, "Html", ConvertHTMLtoMHT("<HTML>" + message.Get_EditorBodyHTML() + "</HTML>"));
		
		        xmlhttp.open("POST", "../aspx/savePCTmpFile.aspx", false);
		        xmlhttp.send(xmlpara);
		        return xmlhttp.responseText;
		    }
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		    	headerAction("open");
		    	PrintClick("Cross", pDocID, "ING");
		    }
		    function btnClose_onclick() {
		        bAttachProcess = false;
		        OpenInformationUI("<spring:message code='ezApprovalG.t148'/>" + "<br>" + "<spring:message code='ezApprovalG.t149'/>", btnClose_onclick_Complete); 
		            //window.close();
		    }
		
		    function btnClose_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn) {
					if (ReturnFunction != null) {
						ReturnFunction("cancel");
					}
		            window.close();
				}
		    }
		    function window_onbeforeunload() {
		        if (bAttachProcess == false) {
		            if (!draftFlag) {
		                UndoDoc();
		            }
		        }
                
                if (isPreview != "Y") {
                    try {
                        if (bAttachProcess == false)
                            window.opener.openergetDocInfo();
                    }
                    catch (e)
                    {
                        if (bAttachProcess == false)
                            window.parent.openergetDocInfo();
                    }
                }
		        // try {
		        //     if (bAttachProcess == false)
		        //         window.opener.Refresh_Window();
		        // }
		        // catch (e)
		        // { }
		        // try {
		        // 	if (bAttachProcess == false)
		        // 		window.opener.parent.frames["right"].openergetDocInfo();
		        // } catch (e)
		        // { }
		        try {
		            bAttachProcess = true;
		        }
		        catch (e) { }
		        // try {
		        //     window.opener.getApprGraph("appr");
		        // } catch (e) { }
		    }
			function btnConn_onclick() {
				ExcuteInfo("INIT");
			}
		    function btn_Attach_onclick() {
		        btnFileAttach_onclick();
		    }
		    // function btnMail_onclick() {
		    //     window.open("/myoffice/ezEmail/newmail.aspx?cmd=docsend&DocID=" + pDocID + "&DocHref=" + pFormHref, '', 'height=700,width=690,resizable=yes,scrollbars=no');
		    // }
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
// 		    function btnDocInfo_onclick() {
// 		        var parameter = new Array();
// 		        parameter[0] = tempSecurity;
// 		        parameter[1] = tempUrgent;
// 		        parameter[2] = pSummery;
// 		        parameter[3] = pSpecialRecordCode;
// 		        parameter[4] = pPublicityCode;
// 		        parameter[5] = pLimitRange;
// 		        parameter[6] = pPageNum;
// 		        parameter[7] = tempSecurityDate;
// 		        var url = "../ezDocInfo/ezDocInfoG_Cross.aspx";
// 		        if ("${userInfo.lang}".equals("3")) {
// 			        var feature = "status:no;dialogWidth:520px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
// 			        feature = feature + GetShowModalPosition(490, 605);
// 		        } else {
// 			        var feature = "status:no;dialogWidth:450px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
// 			        feature = feature + GetShowModalPosition(420, 605);
// 		        }
// 		        var RtnVal = window.showModalDialog(url, parameter, feature);
// 		        tempSecurity = RtnVal[0];
// 		        tempUrgent = RtnVal[1];
// 		        pSummery = RtnVal[2];
// 		        pSpecialRecordCode = RtnVal[3];
// 		        pPublicityCode = RtnVal[4];
// 		        pLimitRange = RtnVal[5];
// 		        pPageNum = RtnVal[6];
// 		        tempSecurityDate = RtnVal[7];
// 		        setPublicFlag();
// 		        SummaryFlag = true;
// 		        return;
// 		    }
			/*PublicType, PublicLevel 기존의 공개여부 2018-04-04 김은석 수정*/
		    function setPublicFlag() {
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "publication");
		        if (!field) return;
		        var PublicType = pPublicityCode.substring(0, 1);
		        var PublicLevel = pPublicityCode.substring(1, 9);
		        // var PublicType2 = pPublicityCode2;
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
		        
// 		        if (PublicType2 == "1")
// 		            PublicText = "<spring:message code='ezApprovalG.t47'/>";
// 		        else if (PublicType2 == "2")
// 		            PublicText = "<spring:message code='ezApprovalG.t150'/>";
// 		        else
// 		            PublicText = " ";

		        field.innerHTML = PublicText;
		    }
			
			// 보존연한 적용 2019-03-22 임민석(전자결재G)
			function setKeepPeriod() {
				var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "keepperiod");
		        
		        if (!field) return;
		        
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
		        
		        field.innerHTML = keepperiodText;
			}
			
		    /*기존의 공개여부 함수 2018-04-04 김은석 수정*/
		    function setPublicFlag2() {
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "publication");
		        if (!field) return;
		        var PublicType = pPublicityYN.substring(0, 1);

		        var PublicText = "";
		        if (PublicType == "Y" || PublicType == "B")
		            PublicText = "<spring:message code='ezApprovalG.t47'/>";
		        else if (PublicType == "N")
		            PublicText = "<spring:message code='ezApprovalG.t46'/>";
		        else
		            PublicText = " ";
		        
		        field.innerHTML = PublicText;
		    }
		    
		    function getPublicLevel(PublicLevel) {
		        var strRtn = "";
		        var firstFlag = true;
		        for (i = 0; i < 8; i++) {
		            if (PublicLevel.substring(i, i + 1) == "Y") {
		                if (firstFlag) {
		                    strRtn = "(" + (i + 1);
		                    firstFlag = false;
		                }
		                else {
		                    strRtn = strRtn + "," + (i + 1);
		                }
		            }
		        }
		        if (!firstFlag)
		            strRtn = strRtn + ")";
		        return strRtn;
		    }
		    
		    //S전용
	        function SetDocOption(pkeeperiodvaltemp) {
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
		            var feature = "dialogWidth:850px;dialogheight:455px;scroll:no;resizable:no;status:no;help:no;edge:sunken";
		            feature = feature + GetShowModalPosition(850, 455);
		            if (url != "")
		                var rtn = window.showModalDialog(url, para, feature);
		            if (rtn[0] == "TRUE") {
		                var g_SelCabXml = rtn[1];
		                var xmlCab = createXmlDom();
		                xmlCab = loadXMLString(g_SelCabXml);
		                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
		                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		            }
		        } catch (e) {
		            showAlert("btnSetTaskCode_onclick : " + e.description);
		        }
		    }
		    var inssepattach_cross_dialogArguments = new Array();
		    function btnAddSepAttach_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
				if (deptCheckFlag == "3") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "' " + strLanggarm03 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm04 );
					return;
				} else if (deptCheckFlag == "4") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm05);
					return;
				}
				
		        if (cabinetID.trim() == "") {
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
				
		        var url = "/ezApprovalG/insSepAttach.do";
		        inssepattach_cross_dialogArguments[0] = para;
		        inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;
		
		        DivPopUpShow(920, 630, url);
		    }
		
		    function btnAddSepAttach_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            g_SepAttachLVXml = rtn[1];
		            message.DocumentBodySetAttribute("SepAttachLVXml", g_SepAttachLVXml);

		            if (pDraftFlag == "REDRAFT") {
		            	SaveFile();
		            }
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
		    function DocumentComplete() {
		        try {
		            if (ListType == "21") {
		                btnSendDraftEnable = "true";
		                SummaryFlag = true;
		            }
		            if (pFormHref == "PC") {
		                pFormID = "";
		                pDocID = "";
		                pFormID = message.DocumentBodyGetAttribute("FORMID");
		                setInitLoadDocCellInfo();
		                if (!pFormID) {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t120'/>";
		                    OpenAlertUI(pAlertContent);
		                    FormProc.FileNew();
		                    pFormHref = "";
		                    SetBtnStateFalse();
		                }
		            }
		            if (flag == false) {
		                flag = true;
		                IsSkipDrafter = "FALSE";
		                DeptSymbol = getDeptSymbol(arr_userinfo[4], replaceEntityCodeToStr(arr_userinfo[5]));
		                drafterDeptid = arr_userinfo[4];
		                getDraftInfo();
		                if (isUsed == "reuse") {
		                	message.Set_EditorContentURL(beforeUrl);
		                } else {
							if (pFormHref != "") {
								if (pFormHref == "PC") {
									pReadPC = true;
								} else {
									var len;
									len = FormHref.lastIndexOf("/");
									pFormID = FormHref.substr(len + 1, 10);
									message.Set_EditorContentURL(pFormHref);
								}
								
								// if (beforeUrl != "") {
								// 	Insert_ReUse_Content();
								// }
							}
							else {
								DraftFlag = "DRAFT";
								pDraftFlag = "DRAFT";
								message.Set_EditorContentURL(sihangURL);
							}
		                }
		            }
		            setInitOpinion();
		        }
		        catch (e) {
		            OpenAlertUI("DocumentComplete : " + e.description);
		        }
		    }
		    
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
								state : AprState
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
		
		    // var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo(pGubun) {
	        	var deptCheckFlag = checkDeptAndCabinetId();

				if (deptCheckFlag == "3") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "' " + strLanggarm03 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm04 );
					return;
				} else if (deptCheckFlag == "4") {
					showAlert(strLanggarm02 + " '" + replaceEntityCodeToStr(arr_userinfo[5]) + "'" + strLanggarm05);
					return;
				}
				
		    	if (pDraftFlag == "REDRAFT" && checkAprState() && ListType != "21") {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "CLOSE");
	    			// window.returnValue = "CLOSE";
	    			// window.close();
	    			return;
		    	}
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
		        /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
		        parameter[40] = SummaryOuterReceiverList;
		        parameter[41] = tempItemName;
		        parameter[42] = tempItemName2;
		        parameter[45] = pPublicityYN;
		        parameter[46] = nonElecRec;
		        
		        if (nonElecRec == "Y") {
		        	parameter[2] = "1";
			        parameter[47] = "nonElecRecTempCabinet";
			        parameter[48] = nonElecRecInfoXml; // 기록물 기본등록 정보
			        parameter[49] = nonSepAttachLVXml; // 분첨
			        parameter[51] = sepAttachCheckYN;
		        }

                if (useOpenGov == "YES") {
                    parameter[52] = basis;
                    parameter[53] = reason;
                    parameter[54] = listOpenFlag;
                    parameter[55] = fileOpenFlagList;
                    parameter[56] = limitDate;
				}

		        parameter[43] = deptgamsaCount;
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		        
		        parameter[60] = passAprLine;
		        parameter[61] = tempKeyword;

				var frame_doctitle = message.document.getElementById("frame_doctitle");
				if (frame_doctitle != null) {
					parameter[65] = frame_doctitle.textContent;
				}

				// ezapprovalinfo_dialogArguments[0] = parameter;
		        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
		        
				if(DraftFlag == "REDRAFT" && SusinSN == "1" && DocState == "011" && AprState == "004") {
					pGubun = "11";
				}
				
		        var OpenUrl = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun +"&docType=" + pDocType + "&ext=" + "mht" + "&formID=" + pFormID;
		        
		        if (ListType == "21") {
		            OpenUrl += "&docSN=" + DocSN;
				}
		        if (isUsed == "reuse") {
		        	OpenUrl +=  "&isUsed=" + isUsed + "&beforeDocID=" +beforeDocID
		        }
		        // var OpenWin = window.open(OpenUrl , "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750));
		        //
		        // try { OpenWin.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = parameter;
				showPopup(OpenUrl, 1210, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
		    }
		
		    function btnApprovalInfo_Complete(ret) {
				hidePopup();
		        if (ret != undefined && ret[0] == "OK") {
		        	
		            try {
		                if (ret[1] != false) {
							var result = "";
							
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
		                	
		                    btnSendDraftEnable = "true";
		                    isTmpDocCanApprov = true;
		                    
		                    if (approvalFlag == "S") {
		                    	if (ret[32] == "Y") {
		                    		SReAprLineSingMapping(ret);
		                    	} else {
			                    	SGetDraftAprLineInfo(ret);
		                    	}
		                    } else {
			                    GetDraftAprLineInfo(ret);
		                    }
		                    
		                    IsSkipDrafter = "FALSE";
		                }    
		                
		                if (pSuSinFlag == "Y" && typeof (ret[2]) == "string" && pDocType != "002") {
		                	if ($("#message").contents().find("#autoLine") != null) {
								var oDIV = document.createElement("DIV");
								oDIV.className = "FIELD";
								oDIV.id = "RecvautoAprLine";
		                		
		                		if ($("#message").contents().find("#RecvautoAprLine").length <= 0) {
			                		$("#message").contents().find("#autoLine").append(oDIV);
		                		} else {
		                			//수신문 회송받아서 재기안할 때, 수신사인칸 초기화작업 
		                			if (pDraftFlag == "REDRAFT") {
		                				$("#message").contents().find("#RecvautoAprLine").remove();
				                		$("#message").contents().find("#autoLine").append(oDIV);
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
		
		                    if (approvalFlag == "G") {
			                    /* 2015-06-30 표준모듈:추가(외부수신자요약) */
			                    SummaryOuterReceiverList = ret[15];
		                    }

		                    btnReceivLineEnable = false;
		                    setRecevInfo(ret[3]);
		                } else if (pSuSinFlag == "Y" && ret[2] == "" && pDocType != "002") {
		                	if ($("#message").contents().find("#autoLine") != null) {
		                		$("#message").contents().find("#RecvautoAprLine").remove();
		                	}
		                	
		                    DeleteDeptInfo();
		                    setRecevInfo("");
		                }
		                
		                
		                if (ret[4] != undefined) {
			                var g_SelCabXml = ret[4];
			                var xmlCab = createXmlDom();
			                xmlCab = loadXMLString(g_SelCabXml);
			                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
			                keepperiod = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/KEEPPERIOD");
		                }

						tempKeyword = ret[6]; //2021-03-10 박기범 - 키워드 추가
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
			                
// 			                if (ret[11].substring(0,1) == 3) {
// 			                	tempPublic = "N";
// 			                }
			                if (ret[21].substring(0,1) == "N") {
			                	tempPublic = "N";
			                } else if (ret[21].substring(0,1) == "Y") {
			                	tempPublic = "Y";
			                } else if (ret[21].substring(0,1) == "B") {
								tempPublic = "B";
							}
 			                setPublicFlag();
 			                setKeepPeriod();
			                // setPublicFlag2();
			                
			                if (nonElecRec == "Y") {
			                	nonElecRecInfoXml = ret[23];
			                	nonSepAttachLVXml = ret[24];
			                	sepAttachCheckYN = ret[26];
			                	setNonElecRecInfo_mht(nonElecRecInfoXml);
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
		                		delAprLineInfoCC();
		                		// ret[22] 값이 "noItem"일 경우 기존 데이터가 있을 수 있으므로 삭제함
		                	} else if (ret[22] == "sameItem") {
		                		// ret[22] 값이 "sameItem"일 경우 동작 없음
		                	} else {
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
		                
		                passAprLine = ret[32];
		                
		                SummaryFlag = true;
		                isUsed = ""; // 재사용 여부 초기화
		
		            }
		            catch (e) {
		                showAlert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        } else if (ret != undefined && ret[0] == "DUPL") {
// 		        	window.returnValue = "CLOSE";
	    			// window.close();
					btnClose_onclick2("CLOSE");
		        }
		    }
		
		    function btnSaveServer_onclick(AutoSave) //(한양대 20111117)
		    {
				if (!!checkJobTransferStatus &&
						!checkJobTransferStatus("<c:out value ='${userInfo.id}'/>",
								"<c:out value ='${userInfo.deptID}'/>",
								"<c:out value ='${userInfo.jobId}'/>")) {
					// window.close();
					btnClose_onclick2();
					return;
				}
				
		        var fields = message.GetFieldsList();
		        var pTmpDocTitle = trim(message.GetDocTitle());
		
		        if (AutoSave != "Save") {
		            if (pTmpDocTitle == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		
		            // 수정(2007.03.15) : 문서제목 길이 제한하도록 수정
		            if (pTmpDocTitle.length > 127) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t132'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		
		            if ((btnSendDraftEnable == "false" && ListType != "21") && DraftFlag != "REDRAFT") {
		                setFirstDrafterAuto();//저장된 결재선 없을때 기안자를 결재선에 등록
		            } else {
			             if (typeof (LastSignSN) == "undefined") { // 임시보관함에서의 기안>임시저장은 결재선을 수동으로 지정해준다 2018-03-23 천성준
			            	var pAlertContent = "<spring:message code='ezApprovalG.t1485'/>";
			            	/* 2020-06-19 홍승비 - 결재선 지정 필요 메세지에 맞춰서 결재정보창 초기 탭을 결재선탭으로 변경 */
			                OpenAlertUI(pAlertContent, check_btnSendDraft_temp);
			                return;
			            }
		            }
		        }        
		        if (DraftFlag == "REDRAFT" && ListType == "21") {
					//RemoveTmpDoc(DocSN);
		        }
		        
		        if(Saveflag) {
		        	newpDocID = createNewDoc();
		        }
		        
		        var rtnVal = SaveTMPFile(AutoSave);
		        if (rtnVal == "TRUE") {
		            rtnVal = SaveTMPDocInfo(AutoSave);
                    if (useOpenGov == "YES") {
                        $.ajax({
                            type : "POST",
                            dataType : "text",
                            async : false,
                            url : "/ezApprovalG/openGovInfoSave.do",
                            data : {
                                openGovListFlag : listOpenFlag,
                                fileOpenFlagList : fileOpenFlagList,
                                basis : basis,
                                reason : reason,
                                publicity : pPublicityCode == "" ? "Y" : pPublicityCode,
                                docID : newpDocID,
                                limitDate : limitDate
                            }
                        });
                    }
		
		            if (rtnVal.indexOf("TRUE") > -1) {
		                savetempflag = false; //닫기시 임시저장 로직 타지 않음 (바로 닫힘) - noonpark
		                
		                draftFlag = "true";
		                Saveflag = true;
		                /* if (ListType == "1") {
			                $.ajax({
								type : "POST",
								dataType : "text",
								async : false,
								url : "/ezApprovalG/delDocInfo.do",
								data : {
										docID : pDocID,
										field  : "MUST"
										},
								success: function(result){
									if (result == "FALSE") {
										var pAlertContent = strLang872;
										OpenAlertUI(pAlertContent);
									}
									
									draftFlag = "true";
								}, error : function () {
									var pAlertContent = strLang872;
									OpenAlertUI(pAlertContent);
								}
							});
		                } */
		                
		                var pAlertContent = "<spring:message code='ezApprovalG.t1581'/>";
		                OpenAlertUI(pAlertContent);
		                //OpenAlertUI(pAlertContent, btnSaveServer_onclick_Complete);
		                //if(AutoSave != "Save")
		            }
		            else {
		                var pAlertContent = strLang217;
		                OpenAlertUI(pAlertContent);
		                return false;
		            }
		        }
		        else {
		            var pAlertContent = strLang217;
		            OpenAlertUI(pAlertContent);
		            return false;
		        }
		    }
		
		    function btnSaveServer_onclick_Complete() {
		        // window.close();
				btnClose_onclick2();
		    }
		    
	        function Insert_ReUse_Content() {
	            var tempXML = createXmlDom();
	            var XmlBodyDATA = createXmlDom();
	            var tempStr = "";
	            var URL = escape(beforeUrl);
	            tempStr = ConvertMHTtoHTML(URL);
	            
	            tempXML = loadXMLString(tempStr);
// 	            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	            var _DocContentHtml = getNodeText(XmlBodyDATA);
	            var ConXmlDiv = document.createElement("DIV");
	            ConXmlDiv.innerHTML = _DocContentHtml;
	            var TDRows = ConXmlDiv.getElementsByTagName("TD");
	            var reUseContent = {};

	            // for (var i = 0; i < TDRows.length; i++) {
	            //     if (GetAttribute(TDRows.item(i), "id") == "body") {
				// 		reUseContent.editorContent = TDRows.item(i).innerHTML;
	            //         break;
	            //     }
				// }
				
				reUseContent.editorContent = TDRows.body.innerHTML;
				reUseContent.titleContent = TDRows.doctitle.innerText;

	            message.Editor_ReUseContent(reUseContent);
	        }
			
			function addRelatedCabinet() {
				//* moon 2018.07.26
				// window.open("/ezCabinet/cabinetAddRelated.do?module=apprv", "addRelated", getOpenWindowfeature(480, 505));
                var openWidth = 480;
				
				if (navigator.userAgent.includes("Edg")) {
					openWidth = 600;
				}
				showPopup("/ezCabinet/cabinetAddRelated.do?module=apprv", openWidth, 505, "addRelated", getOpenWindowfeature(openWidth, 505), hidePopup);
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
		    	var result = "";
		    	
		    	if (approvalFlag == "S") {
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
		    	}
		    	
		    	return result == "FALSE" ? true : false;
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
	    	
	    	/* 2021-04-08 홍승비 - 비전자문서 > 기록물정보 미설정 상태에서 등록 시, 결재정보창 팝업 + 알러트창 숨김 함수*/
	    	function setNonElecRecApprovalInfo() {
	    		btnApprovalInfo("1");
	    		DivPopUpHidden();
	    	}
	    	
	    	/* 2022-03-23 홍승비 - 결재올림 시 일반버전, G버전에서 모두 동작하는 문서번호 재설정 함수 */
	    	// MHT양식은 body 필드에 orgdocnum 속성으로 문서번호 형식을 설정함 (SetAutoPropertyValue 참고)
			function UpdateDocNum() {
				if (!message.DocumentBodyGetAttribute("orgdocnum")) {
					console.log("message body hasn't a orgdocnum attribute");
					return false;
				} else if (typeof getDocNumByFormat === "undefined" || getDocNumByFormat == null) {
					console.log("function getDocNumByFormat is undefined");
					return false;
				}
				
				var numberFormat = message.DocumentBodyGetAttribute("orgdocnum");
				var fields = message.GetFieldsList();
				if (!fields) {
					return false;
				} else {
					var field = message.GetListItem(fields, "docnumber");
					if (field) {
						field.textContent = getDocNumByFormat(numberFormat);
					}
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
						
						var rtnVal = SaveTMPFile(AutoSave2);
						
						if (rtnVal == "TRUE") {
							rtnVal = SaveTMPDocInfo(AutoSave2);
						}
						
						if (rtnVal.indexOf("TRUE") > -1) {
							draftFlag = "true";
							Saveflag = true;
							createAutoDoc = "Y";
						}
						
						DraftStatus = "NO"; //2024.02.06 자동저장관련 추가
					}


				}
				catch(e)
				{
					DraftStatus = "NO"; //2024.02.06 자동저장관련 추가
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
	<body class="popup" onbeforeunload="return window_onbeforeunload()" style="height:100%;">
			<input type="hidden" id="regNum1" value="">
		<table  class="layout" ID="Table1">
		  <tr>
		    <td style="height:20px; vertical-align: top;">
		        <div id="menu">
			        <%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
			        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
		                <li id="btnSelForm"><span  onClick="return btnSelForm_onclick()"><spring:message code='ezApprovalG.t152'/></span></li>
		                
		                <c:choose>
							<c:when test="${nonElecRec eq 'Y'}">
								<li id="btntotaldocinfo"><span onclick="return btnApprovalInfo('1')">문서정보</span></li>
								<span style="display:none"><li id="btnSetAprLine"><span  onClick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li></span>
				                <span style="display:none"><li id="btnSetReceivLine"><span  onClick="return btnSetReceivLine_onclick()" ><spring:message code='ezApprovalG.t154'/></span></li></span>
				                <span style="display:none"><li id="btnSetTaskCode"><span  onClick="btnSetTaskCode_onclick()" ><spring:message code='ezApprovalG.t9994'/></span></li></span>
		                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()">등록</span></li>
							</c:when>
							<c:otherwise>
				                <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo('1')" ><spring:message code='ezApprovalG.t1742'/></span></li>        
				                <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
				                <span style="display:none"><li id="btnSetAprLine"><span  onClick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li></span>
				                <span style="display:none"><li id="btnSetReceivLine"><span  onClick="return btnSetReceivLine_onclick()" ><spring:message code='ezApprovalG.t154'/></span></li></span>
				                <span style="display:none"><li id="btnSetTaskCode"><span  onClick="btnSetTaskCode_onclick()" ><spring:message code='ezApprovalG.t9994'/></span></li></span>
				                <li id="btnSendDraft"><span  onClick="return btnSendDraft_onclick()"  ><spring:message code='ezApprovalG.t156'/></span></li>
							</c:otherwise>
						</c:choose>
		                <c:choose>
							<c:when test="${userInfo.lang eq '1'}">
								<li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li>
								<span style="display:none"><li id="btnDocInfo"><span  onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li></span>
								<li id="btnOpinion"><span  onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
								<li id="btnFileAttach"><span  onClick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
								<li id="btnAprDocAttach"><span  onClick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
								<li id="btnAddSepAttach" style="display:none"><span  onClick="btnAddSepAttach_onclick()" ><spring:message code='ezApprovalG.t58'/></span></li>
								<li id="btnSave" style="display:none"><span  onClick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
								<li id="btnConn" style="display:none"><span  onClick="return btnConn_onclick()"  ><spring:message code='ezApprovalG.t157'/></span></li>
								<li id="btnhistory"><span  onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
								<li id="btnHelper" style="display:none"><span  onClick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t158'/></span></li>
								<li id="btnSaveServer" <c:if test ="${approvalFlag == 'S'}">style="display:none"</c:if>><span onClick="return btnSaveServer_onclick()" ><spring:message code='ezApprovalG.t4000'/></span></li>
								<li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
								<c:if test="${officeFlag == 'Y' }">
								<li id="reOffice"><span class="" onClick="reOffice(this)">파일재선택</span></li>
								</c:if>
								<c:if test="${useCabinet == 'YES'}">
									<li><span onClick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
								</c:if>
							</c:when>
							<c:otherwise>
								<span style="display:none"><li id="btnDocInfo"><span  onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li></span>
								<li id="btnOpinion"><span  onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
								<li id="btnFileAttach"><span  onClick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
								<li id="btnAprDocAttach"><span  onClick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
								<li id="btnSave" style="display:none"><span  onClick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
								<li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
								<li id="moreBoardIcon" class="view_moreboarditem" style="display: block;">
									<span class="view_icon" onclick="this.parentNode.classList.toggle('on')">
										<img src="/images/ImgIcon/view_more.png">
									</span>
									<ul class="layer_select">
										<li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li>
										<li id="btnAddSepAttach" style="display:none"><span  onClick="btnAddSepAttach_onclick()" ><spring:message code='ezApprovalG.t58'/></span></li>
										<li id="btnConn" style="display:none"><span  onClick="return btnConn_onclick()"  ><spring:message code='ezApprovalG.t157'/></span></li>
										<li id="btnhistory"><span  onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
										<li id="btnHelper" style="display:none"><span  onClick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t158'/></span></li>
										<li id="btnSaveServer" <c:if test ="${approvalFlag == 'S'}">style="display:none"</c:if>><span onClick="return btnSaveServer_onclick()" ><spring:message code='ezApprovalG.t4000'/></span></li>
										<c:if test="${officeFlag == 'Y' }">
											<li id="reOffice"><span class="" onClick="reOffice(this)">파일재선택</span></li>
										</c:if>
										<c:if test="${useCabinet == 'YES'}">
											<li><span onClick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
										</c:if>
									</ul>
								</li>
							</c:otherwise>
						</c:choose>
		            </ul>
					<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
			        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
			        </ul>
		        </div>        
		      <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
		        <ul>
		          <li><span id="btnClose" onClick="return btnClose_onclick()" ></span></li>
		        </ul>
		      </div></td>
		  </tr>
		  <c:if test="${useHideHeaderArea == 'YES'}">
			  <tr id="headerTabTR" style="display:none;">
			  	<td>
					  <div id="headerTab" style="width:90%; height:27px; margin:0 auto; border-bottom: solid 1px #eaeaea; box-sizing: border-box;">
					  	<div id="headerMenu" style="width:155px; height:100%; cursor:pointer; text-align:center" onclick="headerAction()">
					  		<span id="headerHide" style="color:#8f8e93; font-size:14px;"><spring:message code='ezApproval.headerHide01'/></span>
					  	</div>
					  </div>
			  	</td>
			  </tr>
		  </c:if>
		  <tr>
		    <td  style="padding-bottom:10px;height:86%;" >
		      <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		      </td>
		  </tr>
		  <c:if test="${officeFlag == 'Y' }">
		  <tr>
		  	<td>
		  		<div id="officeBtn">
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
		  </c:if>
		  <tr>
		    <td height="20">
                <table class="file" style="height:80px;">
                    <tr>
                        <th id="btn_Attach" style="width:10%;"><spring:message code='ezApprovalG.t65'/></th>
                        <td style="width:62%; border-right:1px solid #d5d5d5; overflow: auto;">
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
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
		<XML id="SA_coredata"></XML>
		<iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
		<input type="file" id="pFile" style="display:none;" />
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="layerpopup" class="layerpopup" style="z-index: 1000; position: absolute; top: 50%; margin-top: -100px; height: 200px; left: 50%; margin-left: -250px; width: 500px; display: none;">
			<iframe src="<spring:message code='main.kms4' />" style="border:none; width: 100%; height: 100%;" id="iFrameLayer2"></iframe>
		</div>
        <c:if test="${useAI}">
            <c:import url="/WEB-INF/jsp/ezAI/aiSlide.jsp" />
        </c:if>
		<script type="text/javascript">
			var moreBoardIcon = document.getElementById("moreBoardIcon");
			var iframeContent = document.getElementById("message");
			var liBtn = document.querySelector(".layer_select");
			
			document.addEventListener("click", function(e) {
				if (moreBoardIcon && !moreBoardIcon.contains(e.target)) {
					moreBoardIcon.classList.remove("on");
				}
			});
			
			iframeContent.addEventListener("load", function() {
				try {
					var idoc = iframeContent.contentDocument || iframeContent.contentWindow.document;
					idoc.addEventListener("click", function() {
						if (moreBoardIcon) {
							moreBoardIcon.classList.remove("on");
						}
					});
				} catch (e) {}
			});
			
			if (liBtn) {
				liBtn.addEventListener("click", function(e) {
					moreBoardIcon.classList.remove("on");
				});
			}
		</script>
	</body>
</html>
