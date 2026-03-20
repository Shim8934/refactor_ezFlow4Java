<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t1308'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style>
			.IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
		</style>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/signSplit_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Recvdocnumber_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/recevG_Susin_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Office.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pWriterDeptID;
		    var pDocID = "<c:out value = '${docID}'/>";
		    var pFormHref = new String("");
		    var pFormID = new String();
		    var zFormID = new String();
		    var pUserID = "<c:out value = '${userInfo.id}'/>";
		    var pHasAttachYN = new String("N");
		    var pHasOpinionYN = new String("N");
		    var FormProc = null;
		    var CurrentDate
		    var flag = false;
		    var fieldflag = false;
		    var xmlhttp = createXMLHttpRequest();	
		    var xmldoc = createXmlDom();
		    var xmluserInfo = createXmlDom();
		    var SignCount = 0;
		    var hapyuiCount = 0;
		    var gongramCount = 0;
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
		    var IsSkipDrafter;
		    var badForm = false;
		    var g_docnumber = "";
		    var docAccess = false;
		    var pCurSelRow;
		    var pSusinDocURL = "";
		    var pOrg_orgDocID = "<c:out value = '${orgDocID}'/>";
		    var chkOK = false;
		    var isReDraft = "<c:out value = '${isReDraft}'/>";
		    var LastSignNo;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
		    var btnSendDraftEnable = "false";
		    var gPublic = "";
		    var s_nCallCnt = false;
		    var sCompanyID   = "<c:out value = '${userInfo.companyID}'/>";
		    var CurAprType = "";
		    var NextAprType = "";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value = '${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";
		    arr_userinfo[9]  = sCompanyID;
		    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}'/>";
		    arr_userinfo[17]  = "<c:out value = '${userInfo.primary}'/>";
		    var pCompanyID = "<c:out value = '${userInfo.companyID}'/>";
		    var companyID = "<c:out value = '${userInfo.companyID}'/>";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "1";
		    var cabinetID = "";
		    var TaskCode = "";
		    var DocNumCode = "";
		    var SummaryFlag = true;
		    var pDocTitle = "";
		    var pDocNumCode, pOrgDocNumCode, pDocNo;
		    var maxwidth = 659;
		    var KuyjeType = "002";
		    var signDateFormat = "<c:out value = '${optSignDateFormat}'/>";
		    var isSplit = "<c:out value = '${optIsSplit}'/>";
		    var SplitKind = "<c:out value = '${optSplitKind}'/>";
		    var sihangURL = "<c:out value = '${sihangURL}'/>";
		    var g_DraftFlag = "<c:out value = '${draftFlag}'/>";
		    var g_RetFlag = "<c:out value = '${retFlag}'/>";
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var isExtDoc = "N";
		    var pGubun;
		    var pMailEditor = "<c:out value = '${crossEditor}'/>";
		    var pPageType = "SUSIN";
		    var approvalFlag = "<c:out value = '${approvalFlag}'/>";
		    var junGyulFlag = "<c:out value = '${junGyulFlag}'/>";
		    var pSignImage_Size = "<c:out value = '${signImageSize}'/>";
		    var pADMIN = "N";
		    var signImageType = "<c:out value = '${signImageType}'/>";
		    var curDocNum = "";
		    var isReceived = "<c:out value = '${isReceived}'/>";
		    var orgCompanyID = "";
		    var ext = "mht";
		    var nonElecRec = "<c:out value = '${isNonElecRec}'/>";
		    var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
		    var useReceiveDocNo = "<c:out value = '${useReceiveDocNo}'/>";
			var wAprMemberSN = "1";
			var docNumZeroCnt = "<c:out value = '${docNumZeroCnt}'/>";
			//원문정보공개
			var useOpenGov = "<c:out value = '${useOpenGov}'/>";
			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			
			var useRedraftOpinionKeep = "<c:out value='${useRedraftOpinionKeep}'/>";
			var passAprLine = "";
		    
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
			
			// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부
			var useHideHeaderArea = "<c:out value ='${useHideHeaderArea}'/>";

			var tenantID = "<c:out value ='${userInfo.tenantId}'/>";

			// 2024-06-04 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부
			var useReceiptDeptFileAttach = "<c:out value ='${useReceiptDeptFileAttach}'/>";

			var type = "ING"; // 2023-07-24 임정은 - 공람 추가

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";
			var allowDeptIDs = "<c:out value ='${allowDeptIDs}'/>"
			var ReturnFunction;

            var isPreview = "<c:out value ='${isPreview}'/>";

		    $(document).ready(function(){
				if (approvalFlag == 'S') {
					$(".approvalS").show();
					$(".approvalG").hide();
				} else {
					$(".approvalG").show();
					$(".approvalS").hide();
				}

				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
				
				if (isReceived != 0) {
					showAlert("<spring:message code='ezApprovalG.pjg04'/>");
					// window.close();
					btnClose_onclick();
				}
				
				if (nonElecRec == "Y") {
					document.getElementById("btnAddSepAttach").style.display = "none";
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
				
				if (useReceiptDeptFileAttach == "YES") {
					document.getElementById("btnFileAttach").style.display = "";
					document.getElementById("btnAprDocAttach").style.display = "";
				}
			});
		    
		    function process_AfterOpen() {
		        try {
		            if (pFormHref == "") {
		                SetBtnStateFalse();
		            }
		            else {
		                if (pDraftFlag == "REDRAFT") {
		                    var len;
		                    var pInformationContent;
		                    var Ans;
		
		                    SetBtnStateTrue();
		                    len = pFormHref.lastIndexOf("/");
		                    pDocID = pFormHref.substr(len + 1, 20);
		                    GetAprDocFormID();
		                    setAttachInfo(pDocID, "APR", lstAttachLink);
		                    getDocInfo();
		                    
		                    /* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
					        message.startRemapAllAprSign_MHT(pDocID, orgCompanyID);
		                    
							// 현재 문서가 수신문이므로 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
					        if (pOrgDocID != null && typeof(pOrgDocID) != "undefined" && pOrgDocID != "") {
					        	message.startRemapAllAprSign_MHT(pOrgDocID, orgCompanyID);
					        }
					        
							if (pHasOpinionYN == "Y") {
		                        if (pAprState == "006")
		                            pInformationContent = "<spring:message code='ezApprovalG.t124'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        else
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		
		                        OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                    }
		                }
		                else if (pDraftFlag == "SUSIN" || pDraftFlag == "GONGRAM") {
		                    var len;
		                    len = pFormHref.lastIndexOf("/");
		
		                    GetAprDocFormID();
		                    setAttachInfo(pDocID, "APR", lstAttachLink);
		                    getDocInfo();
		                    
		                    /* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
					        message.startRemapAllAprSign_MHT(pDocID, orgCompanyID);
		                    
					     	// 현재 문서가 수신문이면서 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
					        if (pDraftFlag == "SUSIN" && pOrgDocID != null && typeof(pOrgDocID) != "undefined" && pOrgDocID != "") {
					        	message.startRemapAllAprSign_MHT(pOrgDocID, orgCompanyID);
					        }
					     	
		                    if (g_DraftFlag == "REDRAFT") {
// 		                        setMenuBar("btnAssign", false);
// 		                        setMenuBar("btnDistribute", false);
		                    }
		
		                    if (g_RetFlag == "Y") {
		                        btnReturn_onclick();
		                    }
		                    else {
								if (pHasOpinionYN == "Y") {
		                            var pInformationContent;
		                            var Ans;
		
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                            OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                        }
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
		        try {
		            getDraftUserInfo();
		            SetAutoPropertyValue();
		        } catch (e) {
		            showAlert("setAutoProperty : " + e.description);
		        }
		    }
		    function FieldsAvailable() {
		        pGubun = "11";
		        CheckSignImg();
		
		        SetReceiptNumber();
		
		        setMenuBar("btnEdit", false);

		        setAutoProperty();
		        process_AfterOpen();
				connInit();
		        
		        if ($("#message").contents().find("#RecvautoAprLine").length == 0) {
		        	//가변결재선을 사용하는 수신문인데 수신결재선 필드를 그리지 못하고 수신된 문서일 경우, 접수 할 때 그려주도록. (voc #55612)
		        	if ($("#message").contents().find("#autoLine").length > 0 && pDocType == "003" && pDraftFlag == "SUSIN") {
						var oDIV = document.createElement("DIV");
						oDIV.className = "FIELD";
						oDIV.id = "RecvautoAprLine";
							
                		$("#message").contents().find("#autoLine").append(oDIV);
                		setFirstDrafter();
                	} else {
				        if (SignCount < 1) {
				        	if (approvalFlag == "G") {
					            pGubun = "12";
					            if (CrossYN())
					                document.getElementById("btnRJunkyul").childNodes[0].textContent = "<spring:message code='ezApprovalG.t1406'/>";
					            else
					                document.getElementById("btnRJunkyul").childNodes[0].innerText = "<spring:message code='ezApprovalG.t1406'/>";
				        	} else {
				        		document.getElementById("btnRJunkyul").childNodes[0].textContent = "<spring:message code='ezApprovalG.csj001'/>";
				        	}
				            document.getElementById("btnSetAprLine").style.display = "none";
				            document.getElementById("btnSendDraft").style.display = "none";
				            document.getElementById("btntotaldocinfo").style.display = "none";
				        } else {
				        	setFirstDrafter();
				        }
                	}
		        } else {
		        	if (g_DraftFlag != "REDRAFT") {
			        	setFirstDrafter();
		        	} else {
		        		LastSignSN = 1;
		        	}
		        	setAutoProperty();
		        }
		        getGongRamDocInfo();
		        var g_SepAttachLVXml = "";
		        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
		        if (!g_SepAttachLVXml)
		            g_SepAttachLVXml = "";
		        message.DocumentBodySetAttribute("SepAttachLVXml", SetSepAttParamXmlNull(g_SepAttachLVXml));
		        
		        checkHeaderAction();
		
		        //없이 테스트
// 		        SignCheck();
		    }
		    function DocumentComplete() {
		        if (pFormHref == "PC") {
		            pFormID = "";
		            pDocID = "";
		            pFormID = message.DocumentBodyGetAttribute("FORMID");
		            setClearSusinCellInfo();
		
		            if (!pFormID) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t123'/>";
		                OpenAlertUI(pAlertContent);
		                FormProc.FileNew();
		                pFormHref = "";
		            }
		        }
		        if (flag == false) {
		            flag = true;
		            IsSkipDrafter = "FALSE";
		            SetBtnStateTrue();
		            getReceiveDocInfo();
		            
		            if (nonElecRec == "Y") {
			            getNonElecInfoSusinInit();
		            }
		            
		            if (pSusinDocURL != "") {
		                message.Set_EditorContentURL(pSusinDocURL);
		            }
		        }
		    }
		    function btnSetAprLine_onclick() {
		        var ret;
		        if (SignCount < 1) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1407'/>";
		            OpenAlertUI(pAlertContent);
		            return
		        }
		
		        ret = openAprLineUI();
		        if (ret[0] != "cancel" && ret[3] != "cancel") {
		            btnSendDraftEnable = "true";
		            IsSkipDrafter = "FALSE";
		            btnSendDraft.Enable = "true";
		            
		            if (approvalFlag == "S") {
	                    SGetDraftAprLineInfo(ret);
                    } else {
	                    GetDraftAprLineInfo(ret);
                    }
		        }
		        else {
		            if (ret[2] == "cancel") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t127'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		    }
		    function btnSetReceivLine_onclick() {
		        try {
		            var ret = openReceivUI();
		            if (ret != "cancel") {
		                setRecevInfo(ret);
		            }
		        }
		        catch (e) {
		            showAlert("btnSetReceivLine_onclick : " + e.description);
		        }
		    }
		    function btnSendDraft_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
					showAlert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}
		    	
		        try {
		        	if (isReDraft == "Y" && checkAprState()) {
		        		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
		    			// window.close();
		    			return;
			    	}
		        	
			    	//접수된 문서인지 확인하기
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/isReceivedDoc.do",
			    		data : {
			    			docID : pDocID
			    		},
			    		success : function(result) {
			    			if (result != 0) {
			    				showAlert("<spring:message code='ezApprovalG.pjg04'/>", "");
			    				// window.close();
								return;
			    			}
			    		}
			    		
			    	});		
			    	
		            var RecevState = getDocRecevState();
  
		            if (isReDraft != "Y") {
			            if (RecevState != "011" && RecevState != "012" && RecevState != "014") {
			                if (RecevState == "015") {
			                    var pAlertContent = strLang912;
			                    OpenAlertUI(pAlertContent);
			                }
			                else if (RecevState == "013") {
			                    var pAlertContent = strLang913;
			                    OpenAlertUI(pAlertContent);
			                }
		
			                btnClose_onclick();
			                return false;
			            }
		            }
		            
			        /* 2021-08-20 홍승비 - 가변결재선을 사용하는 수신문의 경우, 접수기안 시 서명 이전에 SignCount를 한번 더 체크하도록 수정 */
			        if ($("#message").contents().find("#autoLine").length > 0 ) {
			        	SignCount = getSignCountForAutoLine();
			        }
		            
		            var rtnSignInfo;
		            var fields = message.GetFieldsList();
		            var field = message.GetListItem(fields, "doctitle");
		
		            if (btnSendDraftEnable == "false") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
		                OpenAlertUI(pAlertContent, check_btnSendDraft);
		                return;
		            }
		            if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {
		                if (!checkLines())
		                    return;
		            }
		
		            try {
		                var pSusinNextSN = 0;
		
		                if (pSusinSN) {
		                    pSusinNextSN = parseInt(pSusinSN, 10) + 1;
		                } else {
		                    pSusinNextSN = 1;
		                }
		                
		                var fieldname = pSusinNextSN + "sign1";
		                if (message.GetListItem(fields, fieldname) && CheckDeptLinesXML == "") {
		                    var pInformationContent = "<spring:message code='ezApprovalG.t1409'/>" + "<br><br>" +
		                                "<spring:message code='ezApprovalG.t1410'/>";
		                    OpenInformationUI(pInformationContent, btnSendDraft_onclick_Complete);
		                }
		                else {
		                    TaskCode_Check();
		                }
		            }
		            catch (e) { }
		        }
		        catch (e) {
		            showAlert("btnSendDraft_onclick : " + e.description);
		        }
		    }
		
		    function TaskCode_Check() {
		        if (cabinetID == "") {
// 		        	if (!nonElecRec == "Y") {
		        	if (nonElecRec != "Y") {
			            btnSetTaskCode_onclick();
		        	} else {
			            TaskCode_Save();
		        	}
		        } else {
		            TaskCode_Save();
		        }
		    }
		    
		    //편철시 철지정
		    function TaskCode_Save() {
		        if (cabinetID == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t134'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        var g_SepAttachLVXml = "";
		        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
		        if (!g_SepAttachLVXml)
		            g_SepAttachLVXml = "";

		        if (!CheckSepAttParamXmlNull(g_SepAttachLVXml)) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1411'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        
		        /* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
		        if (g_DraftFlag == "REDRAFT" && useRedraftOpinionKeep != "YES") {
		            delOpinionInfo();
		        }
		
		        pDocTitle = trim(message.GetDocTitle());
		        if (pDocTitle == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1695'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else {
		            //if ("${approvalPWD}" != "N") {
		            if (CheckUsePassword()) {
		                chk_Passwd();
		            } else {
		                check_skipdraft();
		            }
		        }
		    }
		
		    function openSignUI_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1696'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        if (getLastAprLine() == false) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1414'/>" + "<br>" +
		                                    "<spring:message code='ezApprovalG.t1415'/>";
		            OpenAlertUI(pAlertContent);
		            
		            //2020-01-17 천성준 - 사용하지 않는 버튼을 호출해서 에러 알람나오는 현상 수정(결재선 지정 버튼)
		            /* try {
		                btnSetAprLine_onclick();
		            }
		            catch (e) { } */
		            return;
		        }
		
		        pOrgHtml = message.Get_EditorBodyHTML();
		        if (LastSignSN == 1) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		        }
		
		        if (LastSignSN == 1) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_AFTER");
		            if (!rtnVal) {
		                return;
		            }
		        }
		
		        if (LastSignSN == 1) {
		            var rtnVal = ExcuteInfo("LAST_SEND_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		        }
		        
		        if (SignCount >= 1) {
					if (LastSignSN == 1) {
						var rtnVal = ExcuteInfo("LAST_SIGN_BEFORE");
						if (!rtnVal) {
							return;
						}
					}

		            rtnSignInfo = SendDraftMappingSign(ret);

					if (LastSignSN == 1) {
						var rtnVal = ExcuteInfo("LAST_SIGN_AFTER");
						if (!rtnVal) {
							return;
						}
					}
		        }
		        saveSuSinDocInfo();
		    }
		
		    function check_skipdraft() {
		        if (IsSkipDrafter == "FALSE") {
		            var ret;
		            var parameter = new Array();
		            parameter[0] = pDocID;
		
		            if (SignCount < 1) {
		                ret = "NAME";
		                openSignUI_Complete("NAME");
		            }
		            else {
		                openSignUI(parameter);
		            }
		        }
		        else {
		            saveSuSinDocInfo();
		        }
		    }
		
		    function saveSuSinDocInfo() {
		        var rtnval = true;
		        if (approvalFlag == "G") {
		        	rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
		        }
		        if (!rtnval) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t2101'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        if (LastSignSN != 1) {
		            var rtnVal = ExcuteInfo("LAST_APR_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		        }
		
		        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
		            var RtnVal;
		            var pAlertContent;
		            RtnVal = setSusinUpdataDocID();

		            if (RtnVal == "TRUE") {
		                RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
		                if (!RtnVal) {
		                    return;
		                }
		
		                if (pDraftFlag == "HAPYUI" && LastSignSN == 1) {
		                    var pInformationContent = "<spring:message code='ezApprovalG.t1503'/>";
		                    var Ans = OpenInformationUI(pInformationContent);
		                    if (Ans) RtnVal = HabyuiResultOpinion();
		                }
		
		                if (RtnVal) RtnVal = SaveDraftDocInfo();
		                if (RtnVal == "TRUE") {
		                    RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
		                    if (!RtnVal) {
		                        return;
		                    }
		
		                    if (LastSignSN == 1) {
		                        RtnVal = ExcuteInfo("DOCNUM_END");
		                        if (!RtnVal) {
		                            return;
		                        }
		
		                        RtnVal = ExcuteInfo("LAST_END_AFTER");
		                        if (!RtnVal) {
		                            return;
		                        }
		                    }
		                    if (LastSignSN == 1) {
		                        pAlertContent = "<spring:message code='ezApprovalG.t1697'/>";
								if (document.getElementById("attAprStatus") && document.getElementById("attAprStatus").value == "ok") {
									CurAprType = strAprType1;
								}
		                      	//2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 접수자 전결
		                        if ((CurAprType == strAprType4 || CurAprType == strAprType1) && document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {
			    		        	var code = document.getElementById('message').contentWindow.document.getElementById('annual-conn-script').getAttribute("code");
			    		        	var script = document.createElement("script");
			    					script.type = "text/javascript";
			    					script.innerHTML = code;
			    					document.querySelector("head").appendChild(script);
			    					
			    		        	attitude_annual_conn(pOrgDocID);
			    		        }
		                        
		                        SendMailToDrafter();
		                    } else {
								/* 2021-10-14 홍승비 - 수신문서 접수(=수신부서 내부기안 시작) 시에도 다음 결재자에게 메일 발송 */
								sendAlertMail("APR", "1", "RECEV_END");
		                        pAlertContent = "<spring:message code='ezApprovalG.t1698'/>";
		                    }
		                    
		                    /* 2022-08-16 홍승비 - 부서수신함에서 수신문 접수기안(또는 전결) 시, 기안 시와 동일하게 결재선 변경이력 남기도록 수정 */
		                    UpdateLineHistory();
		                    
		                    OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
		                    chkOK = true;
		                }
		                else {
		                    UndoSignInfo(rtnSignInfo);
		
		                    if (LastSignSN == 1) {
								rollbackDocNumber(arr_userinfo[4], pDocID);
		                        RtnVal = ExcuteInfo("END_FAIL");
		                        if (!RtnVal) {
		                            return;
		                        }
		                    }
		                    pAlertContent = "[" + "<spring:message code='ezApprovalG.t1495'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		
		                if (LastSignSN == 1) {
		                    RtnVal = ExcuteInfo("END_FAIL");
		                    if (!RtnVal) {
		                        return;
		                    }
		                }
		
		                SetBtnStateTrue();
		                btnSendDraft.Enable = "true";
		
		                pAlertContent = "[" + "<spring:message code='ezApprovalG.t1495'/>";
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
		
		            RtnVal = SaveDraftDocInfo();
		            if (RtnVal == "TRUE") {
		                RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
		                if (!RtnVal) {
		                    return;
		                }
		
		                if (LastSignSN == 1) {
		                    RtnVal = ExcuteInfo("DOCNUM_END");
		                    if (!RtnVal) {
		                        return;
		                    }
		                }
		                
	                    UpdateLineHistory();
		                
		                pAlertContent = "<spring:message code='ezApprovalG.t1506'/>";
		                OpenAlertUI(pAlertContent);
		                chkOK = true;
		                window.close();
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		
		                if (LastSignSN == 1) {
		                    RtnVal = ExcuteInfo("END_FAIL");
		                    if (!RtnVal) {
		                        return;
		                    }
		                }
		                SetBtnStateTrue();
		                pAlertContent = "[" + "<spring:message code='ezApprovalG.t1495'/>";
		                OpenAlertUI(pAlertContent);
		                return;
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
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t1413'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        check_skipdraft();
		    }
		
		    function btnSendDraft_onclick_Complete(Ans) {
		        if (Ans) {
		            btnSetReceivLine_onclick();
		        }
		        TaskCode_Check();
		    }
		    function getLastAprLine() {
		        try {
		        	var result = "";
		            
		            $.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/aprLineRequest.do",
		        		data : {
		        				docID    : pDocID, 
		        				userID 	 : pUserID,
		        				formID   : pFormID,
		        				mode     : "",
								docState : pDocState
		        				},
		        		success: function(xml){
		        			result = loadXMLString(xml);
		        		}        			
		        	});
		            
		            var NodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");
		            if (NodeList.length > 0) {
		                var bResult = CheckFirstDrafter(result);
		                return bResult;
		            }
		
		            return false;
		        }
		        catch (e) {
		            return false;
		            showAlert("getLastAprLine :: " + e.description);
		        }
		    }
		    function CheckFirstDrafter(APRLINE) {
		        var AprLineRow = SelectNodes(APRLINE, "LISTVIEWDATA/ROWS/ROW");
		        var CurListLen = AprLineRow.length;
		        var i;
		        var AprLineTotalLen;
		        var pCheckUserID = "";
		
		        for (var i = 0 ; i < CurListLen; i++) {
		            if (i == CurListLen - 1) {
		                pCheckUserID = trim(getNodeText(GetChildNodes(AprLineRow[i])[0].getElementsByTagName("DATA4")[0]));
		
		                if (pCheckUserID == pUserID)
		                    return true;
		                else
		                    return false;
		
		                break;
		            }
		        }
		        return true;
		    }
		    function btnFileAttach_onclick() {
		        var ret = openFileAttachUI();
		    }
		    function btnAprDocAttach_onclick() {
		        var ret = openAaprDocAttachUI();
		    }
		    function btnOpinion_onclick() {
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		        //var ret = openOpinionUI("N");
		    	openOpinionUI_New("");
		    }
		    function btnSave_onclick() {
		    }
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        headerAction("open");
		    	PrintClick("Cross", pDocID, "ING");
		    }
		    // function btnClose_onclick() {
		    //     window.close();
		    // }
		    window.onbeforeunload = function () {
                if (isPreview != "Y") {
                    try {
                        window.opener.openergetDocInfo();
                        if (!chkOK) {
                            if (isReDraft == "N")
                                delDocInfo();
                        }
                    }
                    catch (e) {
                        window.parent.openergetDocInfo();
                        if (!chkOK) {
                            if (isReDraft == "N")
                                delDocInfo();
                        }
                    }
                }
		        // try {
		        //     window.opener.Refresh_Window();
		        // } catch (e) { }
		    };
		    
		    var ezreceivedistributeui_cross_dialogArguments = new Array();
		    function btnDistribute_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
					showAlert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}
				
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = arr_userinfo[4];
		        parameter[3] = pAprState;
		        parameter[4] = RECEIPTDEPTID.innerText;
		        parameter[5] = pDocState;
				parameter[6] = isReDraft;	
		        parameter[7] = orgCompanyID;
		        
		        ezreceivedistributeui_cross_dialogArguments[0] = parameter;
		        ezreceivedistributeui_cross_dialogArguments[1] = btnDistribute_onclick_Complete;
		
		        DivPopUpShow(800, 600, "/ezApprovalG/ezReceiveDistributeUI.do");
		    }
		    function btnDistribute_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "true") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
		        } else if (ret == "DUPL") {
		        	showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
		        }
		    }
		
		    var ezreceiveassignui_cross_dialogArguments = new Array();
		    function btnAssign_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	}
				
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = pAprState;
				parameter[3] = pDocState;
				parameter[4] = isReDraft;	
		        parameter[5] = orgCompanyID;
				
		        ezreceiveassignui_cross_dialogArguments[0] = parameter;
		        ezreceiveassignui_cross_dialogArguments[1] = btnAssign_onclick_Complete;
		
		        DivPopUpShow(800, 600, "/ezApprovalG/ezReceiveAssignUI.do"); //460
		    }
		
		    function btnAssign_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1420'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
		        } else if (ret == "DUPL") {
		        	showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
		        }
		    }
		
		    var apropinion_cross_dialogArguments = new Array();
		    var temppDocSN;
		    function btnReturn_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
					showAlert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}	
		    
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		        var RecevState = getDocRecevState();
		        if (RecevState != "011" && RecevState != "012" && RecevState != "014" && RecevState != "013") {
		            if (RecevState == "015") {
		                var pAlertContent = strLang912;
		                OpenAlertUI(pAlertContent);
		            }
		            return false;
		        }
		        var pDocSN = "";
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "receiptnumber");
		        if (field) {
		            var fieldValue = trim(field.textContent);
		            if (fieldValue != "" && fieldValue.replace("@", "") == fieldValue) {
		                var tmpDocSN = fieldValue.substr(fieldValue.lastIndexOf("-") + 1);
		                if (!isNaN(tmpDocSN))
		                    pDocSN = tmpDocSN;
		            }
		        }
		        temppDocSN = pDocSN;
		        
		        openOpinionUI_New("HeSong", btnReturn_onclick_Complete);
		        
		        /* var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "HeSong";
		        parameter[2] = KuyjeType;
		        parameter[3] = "";
		
		        if (pDocSN != "")
		            parameter[4] = "Y";
		        else
		            parameter[4] = "N";
		        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
		        parameter[99] = ext;
		        
		        apropinion_cross_dialogArguments[0] = parameter;
		        apropinion_cross_dialogArguments[1] = btnReturn_onclick_Complete;
		
		        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do"); */
		    }
		    function btnReturn_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		        var hesongok = true;
		        if (ret != "cancel") {
					var RtnVal = ExcuteInfo("HESONG_BEFORE");
		        	if (!RtnVal) {
		                return;
		            }
		        	
		            setButtonReceiveTrue();		            

		        	var Rtnxml = createXmlDom();
		            Rtnxml = loadXMLString(ret);
		            makeOpinionList4Hesong(Rtnxml);
		            // delOpinionsExceptHesong();
		            // SaveFile();
		
		            if (temppDocSN != "")
		                hesongok = setCabinetHeSong(temppDocSN);
		
		            if (hesongok) {
						var docInfo = document.getElementById("DOCINFO").dataSource;
						var writerID = SelectSingleNodeValueNew(docInfo, "DOCINFO/DATA/WRITERID")
						var writerName = SelectSingleNodeValueNew(docInfo, "DOCINFO/DATA/WRITERNAME")
						var docTitle = SelectSingleNodeValueNew(docInfo, "DOCINFO/DATA/DOCTITLE")
		            	SendMailToDrafter_Hesong(writerID, writerName, docTitle);
		                hesongok = setHeSongDocInfo();

						if (hesongok) {
							ExcuteInfo("HESONG_AFTER");
						} else {
							ExcuteInfo("HESONG_FAIL");
						}
		            }
		        } else {
                    var pAlertContent = "<spring:message code='ezApprovalG.cancelHesong.JIH01'/>";
                    OpenAlertUI(pAlertContent);
		        }
		    }
		    
		    function delOpinionsExceptHesong() {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/delOpinionsExceptHesong.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(result) {
		    			
		    		}
		    	});
		    }
		    
		    function makeOpinionList4Hesong(OpinionXML) {
		    	var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "opinions");
		        if (!field) return;

		        field.innerHTML = " ";
		    	SaveFile();
		    }
		 
		    function makeOpinionList(OpinionXML) {
		    	var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "opinions");
		        if (!field) return;

		        var NodeList = SelectNodes(OpinionXML, "LISTVIEWDATA/ROWS/ROW");
		        field.innerHTML = " ";
		        if (NodeList.length > 0) {
		            for (i = NodeList.length - 1; i >= 0; i--) {
		        		var opinionsTable = '<p style="margin-top: 10px;margin-left: 3px;margin-bottom: 3px;">▶ ' + getNodeText(NodeList[i].childNodes[3]) + ' - ' + getNodeText(NodeList[i].childNodes[2]) + ' - ' + getNodeText(NodeList[i].childNodes[1]) + '</p><p style="margin-top: 0px;margin-left: 10px;margin-bottom: 0px;">' + MakeXMLString(getNodeText(NodeList[i].childNodes[6])) + '</p>';
		        		$(field).append(opinionsTable);
		            }
		        	SaveFile();
		        }
		    }
		    function btnEdit_onclick() {
		        if (pzFormProc.StartMode == "0") {
		            modeflag = false;
		            chkBtnConfirm("1");
		            beforeHtml = pzFormProc.DocumentHTML;
		
		            pzFormProc.ShowToolbar("1");
		
		            btnEdit.childNodes(0).innerText = "<spring:message code='ezApprovalG.t1767'/>";
		
		            var FormProc = pzFormProc.object;
		            var fields = FormProc.Fields;
		
		            for (i = 0 ; i < fields.Count ; i++) {
		                var field = fields.item(i + 1);
		                if (field.FieldID != "SA_AssignReasons" && field.FieldID.substring(0, 10) != "susinbody_")
		                    field.TagObject.removeAttribute("free");
		
		                if (!fields) return;
		            }
		
		        } else {
		            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
		            var Ans = OpenInformationUI(pInformationContent);
		
		            pzFormProc.ShowToolbar("0");
		            btnEdit.childNodes(0).innerText = "<spring:message code='ezApprovalG.t44'/>";
		
		            if (Ans) {
		            } else {
		                pzFormProc.DocumentHTML = beforeHtml;
		            }
		            modeflag = true;
		            chkBtnConfirm("2");
		        }
		    }
		    function btnRJunkyul_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
					showAlert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}	
		    
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		        var RecevState = getDocRecevState();
		        
		        if (isReDraft != "Y") {
			        if (RecevState != "011" && RecevState != "012" && RecevState != "014") {
			            if (RecevState == "015") {
			                var pAlertContent = strLang912;
			                OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
			            }
			            else if (RecevState == "013") {
			                var pAlertContent = strLang913;
			                OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
			            }
			            return false;
			        }
			    }
		
		        var Resultxml;
		
		        var UserID = "<c:out value = '${userInfo.id}'/>";
		        var DisplayName = "<c:out value = '${userInfo.displayName}'/>";
		        var DepID = "<c:out value = '${userInfo.deptID}'/>";
		        var DeptName = "<c:out value = '${userInfo.deptName}'/>";
		        var Position = "<c:out value = '${userInfo.title}'/>";
		        var CompanyID = "<c:out value = '${userInfo.companyID}'/>";
		        var d = new Date();
		        var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();
		        Resultxml = "<LISTVIEWDATA><HEADERS>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t1421'/>" + "</NAME><WIDTH>30</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t379'/>" + "</NAME><WIDTH>50</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t230'/>" + "</NAME><WIDTH>60</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t108'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t380'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t381'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t382'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t383'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
		        Resultxml = Resultxml + "</HEADERS><ROWS><ROW>";
		        Resultxml = Resultxml + "<COLUMN>1</COLUMN>";
		        Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(DisplayName) + "</COLUMN>";
		        Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(Position) + "</COLUMN>";
		        
		        /* 2021-06-03 홍승비 - 부서명에 특수문자를 허용 + c:out 처리되었으므로 특수문자 역 인코딩 및 CDATA 처리 진행 */
		        Resultxml = Resultxml + "<COLUMN><![CDATA[" + ConvMakeXMLString(DeptName) + "]]></COLUMN>";
		
		        Resultxml = Resultxml + "<COLUMN>" + "<spring:message code='ezApprovalG.t25'/>" + "</COLUMN>";
		        Resultxml = Resultxml + "<COLUMN>" + "<spring:message code='ezApprovalG.t1422'/>" + "</COLUMN>";
		        Resultxml = Resultxml + "<DATA name='ProcessDate'>" + "" + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='ReceivedDate'>" + RecieveDay + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='DocID'>" + pDocID + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='AprMemberID'>" + UserID + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='AprmemberIsDeptYN'>N</DATA>";
		        Resultxml = Resultxml + "<DATA name='AprMemberDeptID'>" + DepID + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='ReasonDoNotApprov'></DATA>";
		        Resultxml = Resultxml + "<DATA name='isProposerYN'>N</DATA>";
		        Resultxml = Resultxml + "<DATA name='isBriefUserYN'>N</DATA>";
		        Resultxml = Resultxml + "<DATA name='isCompanyID'>" + CompanyID + "</DATA>";
		
		        Resultxml = Resultxml + "<DATA name='AprType'>" + strAprType4 + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='AprState'>" + strAprState2 + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='PMemberName'>" + MakeXMLString(arr_userinfo[11]) + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='SMemberName'>" + MakeXMLString(arr_userinfo[12]) + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='PMemberDeptName'><![CDATA[" + ConvMakeXMLString(arr_userinfo[15]) + "]]></DATA>";
		        Resultxml = Resultxml + "<DATA name='SMemberDeptName'><![CDATA[" + ConvMakeXMLString(arr_userinfo[16]) + "]]></DATA>";
		        Resultxml = Resultxml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(arr_userinfo[13]) + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(arr_userinfo[14]) + "</DATA>";
		
		        Resultxml = Resultxml + "</ROW></ROWS></LISTVIEWDATA>";

		        $.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezApprovalG/aprLineSave.do",
            		data : {
            				ret    : Resultxml
            				},
            		success : function(result){
            			if (result == 'TRUE') {
	            			var retvalue = new Array();
	    		            retvalue[0] = Resultxml;
	    		            retvalue[1] = "NONE";
	    		            retvalue[2] = "R";
	    		            retvalue[3] = "";
	    		
	    		            if (approvalFlag == "S") {
	    	                    SGetDraftAprLineInfo(retvalue);
	                        } else {
	    	                    GetDraftAprLineInfo(retvalue);
	                        }
	    		            passAprLine = "N";
	    		            btnSendDraftEnable = "true";
	    		            CurAprType = strAprType4; // 결재유형을 '전결' 문자가 아닌 코드(004)로 수정
	    		            LastSignSN = "1";
	    		            btnSendDraft_onclick();
            			} else {
	            			var pAlertContent = "<spring:message code='ezApprovalG.t1423'/>";
	    		            OpenAlertUI(pAlertContent);
            			}
            		}, 	error : function() {
            			var pAlertContent = "<spring:message code='ezApprovalG.t1423'/>";
	    		        OpenAlertUI(pAlertContent);
            			}
            	});
		    }
		    
// 		    function btnMail_onclick() {
// 		    		  $.ajax({
// 	                        type:"POST",
// 	                        dataType:"text",
// 	                        async: false,
// 	                        data : {
// 	                        	imgUrl : pFormHref,
// 	                        	docID: pDocID
// 	                        },
// 	                        url: "/ezApprovalG/createMailImg.do",
// 	                        success: function (data) {
// 	                        	var pheight = window.screen.availHeight;
// 	                	        var conHeight = pheight * 0.8;
// 	                	        var pwidth = window.screen.availWidth;
// 	                	        var pTop = (pheight - conHeight) / 2;
// 	                	        var pLeft = (pwidth - 890) / 2;
// 	                	        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pFormHref);
// //	                				var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pFormHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";					
// 	                	        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
// 	                	        newwin.focus();
// 	                        }
// 	                    });
// 		    		  }
	        
		      function btnMail_onclick() {
				headerAction("open");
		    	var imgUrl="";
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
	        var pLeft = (pwidth - 1200) / 2;
	        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pFormHref);
//				var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pFormHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";					
// 	        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
// 	        newwin.focus();
				  showPopup(pURL, 1200, conHeight, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
		    }
		      
		    var tempSecurity = "";
		    var tempKeep = "";
		    var tempUrgent = "N";
		    var tempPublic = "Y";
		    var tempKeyword = "";
		    var tempItemCode = "";
		    var tempItemName = "";
		    var tempItemName2 = "";
		    var tempdocnumcode = "<spring:message code='ezApprovalG.t45'/>";
		    var tempSecurityDate = "";
		    function btnDocInfo_onclick() {
		        var parameter = new Array();
		        parameter[0] = tempSecurity;
		        parameter[1] = tempUrgent;
		        parameter[2] = pSummery;
		        parameter[3] = pSpecialRecordCode;
		        parameter[4] = pPublicityCode;
		        parameter[5] = pLimitRange;
		        parameter[6] = pPageNum;
		        parameter[7] = tempSecurityDate;
		
		        var url = "../ezDocInfo/ezDocInfoG_Cross.aspx";
		        var feature = "status:no;dialogWidth:430px;dialogHeight:625px;help:no;scroll:no;edge:sunken;";
		        feature = feature + GetShowModalPosition(430, 605);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		
		        tempSecurity = RtnVal[0];
		        tempUrgent = RtnVal[1];
		        pSummery = RtnVal[2];
		        pSpecialRecordCode = RtnVal[3];
		        pPublicityCode = RtnVal[4];
		        pLimitRange = RtnVal[5];
		        pPageNum = RtnVal[6];
		        tempSecurityDate = RtnVal[7];
		        SummaryFlag = true;
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
	        }
		    
		    function JiJungBeBuDisable() {
		        btnAssign.style.display = "none";
		        btnDistribute.style.display = "none";
				var btnReturn = document.getElementById("btnReturn");
				if (btnReturn) {
					btnReturn.style.display = "none";
				}
		    }
		    function getGongRamDocInfo() {
		        try {
		        	var result = "";
		        	
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/gongRamDocInfo.do",
		        		data : {
		        			docID : pDocID
		        		},
		        		success: function(xml){
		        			result = loadXMLString(xml);
		        		}
		        	});
		        	
		            var pGongRamDocID = getNodeText(GetChildNodes(result)[0]);
		            if (pGongRamDocID != "NONE" && pGongRamDocID != "" && pGongRamDocID.length == 20)
		                JiJungBeBuDisable();
		        }
		        catch (e) {
		            showAlert("getGongRamDocInfo :: " + e.description);
		        }
		    }
		    function SetReceiptNumber() {
		        var fields = message.GetFieldsList();
		
		        if (pSusinSN > 1) {
		            var field = message.GetListItem(fields, "receiptnumber");
		
		            if (field) {
		                var ReceiptNumber = trim(field.textContent);
		
		                if (ReceiptNumber != "") {
		                    if (g_DraftFlag == "SUSIN") {
		                        field.textContent = "";
		                    }
		                }
		            }
		        }
		    }
		    function getDocRecevState() {
		        try {
					var result = "FALSE";

					var pDeptID = arr_userinfo[4];
					if (typeof upperDeptCode !== "undefined" && upperDeptCode !== "") {
						pDeptID = upperDeptCode;
					}
		        	
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/getDocState.do",
		        		data : {
		        			docID : pDocID,
		        			deptID: pDeptID
		        		},
		        		success: function(text){
		        			result = text;
		        		}
		        	});
		        	
		            return result;
		        } 
		        catch (e) {
		            showAlert("getDocRecevState :: " + e.description);
		        }
		    }
		    // var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	}	
		    
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		    	var chkReceivedDoc = 0;
		    	
		    	//접수된 문서인지 확인하기
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/isReceivedDoc.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success : function(result) {
		    			chkReceivedDoc = result;
		    		}
		    		
		    	});
		    	
		        isExtDoc = message.DocumentBodyGetAttribute("EXTDOC");
		
		        if (isExtDoc != "Y") isExtDoc = "N";
		
		        var onlydocinfiview = false;
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pFormID;
		        parameter[2] = SignCount;
		        parameter[3] = SignInfo;
		        parameter[4] = hapyuiCount;
		        parameter[5] = g_DraftFlag;
		        parameter[6] = pSuSinFlag;
		        parameter[7] = pChamJoFlag;
		        parameter[8] = gongramCount;
		        parameter[9] = false;
		        parameter[10] = pDocType;
		        parameter[11] = "";
		        parameter[12] = "RECV";
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
		        parameter[45] = pPublicityYN;
		        parameter[46] = nonElecRec;
		        
		        if (nonElecRec == "Y") {
		        	if (pGubun == "11") {
			        	parameter[47] = cabinetID;
		        	} else {
			        	parameter[47] = "nonElecRecTempCabinet";
		        	}
			        parameter[48] = nonElecRecInfoXml; // 기록물 기본등록 정보
			        parameter[49] = nonSepAttachLVXml; // 분첨
			        parameter[50] = g_szSCListXml; // 특수목록
			        parameter[51] = sepAttachCheckYN; // 특수목록
		        }
		        
		        if (approvalFlag == "S") {
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
			        parameter[56] = limitDate;
		        }
		        
		        parameter[60] = passAprLine;
		        parameter[61] = tempKeyword;
		        
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		
		        // ezapprovalinfo_dialogArguments[0] = parameter;
		        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
		
		        if (chkReceivedDoc != 0) {
		        	showAlert("<spring:message code='ezApprovalG.pjg04'/>", "");
		        	// window.close();
		        } else {
		        	// var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType, "ezApprovalInfo", GetOpenWindowfeature(1210, 750));
		        	// try { OpenWin.focus(); } catch (e) { }
					ezCommon_cross_dialogArguments[0] = parameter;
					showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType, 1210, 750, "ezApprovalInfo", GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
		        }

		    }
		    function btnApprovalInfo_Complete(ret) {
				hidePopup();
		        if (ret != undefined && ret[0] == "OK") {
		            try {
		                if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {
		                    if (ret[1] != false) {
		                    	$.ajax({
		                    		type : "POST",
		                    		dataType : "text",
		                    		async : false,
		                    		url : "/ezApprovalG/aprLineSave.do",
		                    		data : {
		                    				ret    : ret[1]
		                    				},
		                    		success : function(result){
		                    			
		                    		}
		                    	});
		                    }
		
		                }
		                if (ret[1] != false) {
		                    btnSendDraftEnable = "true";

		                    if (approvalFlag == "S") {
		                    	SGetDraftAprLineInfo(ret);
		                    } else {
			                    GetDraftAprLineInfo(ret);
		                    }
		                    
		                    IsSkipDrafter = "FALSE";
		                }
		
		                if (pGubun != "11" && pGubun != "12") {
		                	$.ajax({
		                		type : "POST",
		                		dataType : "text",
		                		async : false,
		                		url : "/ezApprovalG/aprDeptSave.do",
		                		data : {
		                				aprDeptInfo : ret[2]
		                				},
		                		success : function(result){
		                			
		                		}
		                	});
		                	
		                    btnReceivLineEnable = false;
		                    setRecevInfo(ret[3]);
		                }
		
		                if (ret[4] != undefined) {
			                var g_SelCabXml = ret[4];
			                var xmlCab = createXmlDom();
			                xmlCab = loadXMLString(g_SelCabXml);
			                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		                }

						tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
		                tempSecurity = ret[7];
		                tempUrgent = ret[8];
		                pSummery = ret[9];
		                pPublicityCode = ret[11];
		                tempSecurityDate = ret[14];
		                pPublicityYN = ret[21]; 
		                
		                if (approvalFlag == "G") {
			                pSpecialRecordCode = ret[10];
			                pLimitRange = ret[12];
			                pPageNum = ret[13];
			                
			                /*2018-04-05 김은석 수정 건설공사 공개여부*/
// 			                setPublicFlag();
			                if (isIE()){
			                	try {
					                setPublicFlag2();
			                	} catch (e) {
			                		setPublicFlag();
			                	}
			                }
			                
			                if (nonElecRec == "Y") {
				            	nonElecRecInfoXml = ret[23];
				            	nonSepAttachLVXml = ret[24];
				            	g_szSCListXml = ret[25];
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
							}

							// 2023-07-24 임정은 - 공람 추가
							if (ret[22] == "noItem") {
								delAprLineInfoCC();
							} else if (ret[22] == "sameItem") {
							} else {
								SaveAprLineInfoCC(ret[22]);
							}
		                } else {
		                	tempKeep = ret[16];
		                	tempItemName = ret[17];
		                	tempItemName2 = ret[18];
		                	pPageNum = "1";
		                	pLimitRange = "1";
		                	pSpecialRecordCode = "1";
		                	tempPublic = ret[11];
		                	SetDocOption(ret[20], ret[19]);
		                }
		                passAprLine = ret[32];
		                SummaryFlag = true;
		
		            }
		            catch (e) {
		                showAlert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        } else if (ret != undefined && ret[0] == "DUPL") {
		        	window.returnValue = "CLOSE";
	    			window.close();
		        }
		    }
		    
		    function check_btnSendDraft() {
		        DivPopUpHidden();
		        btnApprovalInfo();
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
			    			docState : pDocState,
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
	    	
	    	function connInit() {
				var connRootText = GetDocumentElement("CONNROOT");
				if (connRootText) {
					if (g_DraftFlag === "REDRAFT") {
						OpenAlertUI("연동문서는 다시 접수할 수 없습니다.<br/>문서보기 창으로 이동합니다.", function() {
							var url = "/ezApprovalG/aprDocView.do" +
								"?docID=" + pDocID +
								"&docHref=" + pFormHref +
								"&opinionFlag=Y" +
								"&docState=" + pDocState +
								"&listSusin=" + arr_userinfo[1] +
								"&oDoc=" + pOrgDocID +
								"&isOpinion=OPINION_SHOW" +
								"&listType=1" +
								"&CallBackType=" +
								"&ext=mht" +
								"&orgCompanyID=" + orgCompanyID;

							window.open(url, "_self");
						});
						return;
					}

					setConnDefaultKey(pDraftFlag);

					if (ConnExist(["conn;processidx;INIT", "conn;processtime;SUSIN", "query;qtype;UA"]) || ConnExist(["conn;processidx;INIT", "conn;processtime;SUSIN", "query;qtype;UA_EX"])) {
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
			
		    /* 2021-06-03 홍승비 - 특수문자 역인코딩 처리 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		        str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");	    
		        return str;
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
			
	<c:choose>
		<c:when test="${isNonElecRec eq 'Y'}">
			function btnDel_onclick() { 
				if (nonElecRec == "Y") {
					if (confirm(strLang962)) {
						RemoveSusinNonElecRecDoc(pDocID);
					}
				}
			}
		</c:when>
	</c:choose>
		</script>
	</head>
	<body class="popup" style="height:100%;">
		<table class="layout">
		  <tr>
		    <td style="height:20px;">
			<div id="menu">
				<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
				<ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
					<c:choose>
						<c:when test="${userInfo.lang eq '1'}">
							<li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>        
							<li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
							<span style ="display:none" ><li id="btnSetAprLine"><span onClick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li></span>
							<span style ="display:none" ><li id="btnSetReceivLine" style="display:none"><span  onClick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t154'/></span></li></span>
							<li id="btnSendDraft"><span onClick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
				<%-- 			<li id="btnRJunkyul" class = 'approvalG'><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li> --%>
							<li id="btnRJunkyul"><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li>
							<span style ="display:none" ><li id="btnSetTaskCode"><span onClick="btnSetTaskCode_onclick()"  ><spring:message code='ezApprovalG.t51'/></span></li></span>
							<span style ="display:none" ><li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li></span>
							<li id="btnOpinion"><span onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
							<li id="btnFileAttach" style ="display:none"><span onClick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
							<li id="btnAprDocAttach" style ="display:none"><span  onClick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
							<c:if test="${approvalFlag == 'G'}">
								<li id="btnAddSepAttach"><span  onClick="btnAddSepAttach_onclick()"  ><spring:message code='ezApprovalG.t58'/></span></li>
							</c:if>
							<li id="btnAssign" ><span  onClick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t1430'/></span></li>
							<li id="btnDistribute"><span  onClick="return btnDistribute_onclick()"><spring:message code='ezApprovalG.t1432'/></span></li>
							<c:if test="${isNonElecRec != 'Y'}">
								<li id="btnReturn"><span onClick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
							</c:if>
							<li id="btnEdit"><span  onClick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
					<c:choose>
						<c:when test="${isNonElecRec eq 'Y'}">
							<li id="btnDel"><span onclick="return btnDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></li>
						</c:when>
					</c:choose>
							<li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
							<li id="btnConn" style="display:none"><span  onClick="return btnConn_onclick()"  ><spring:message code='ezApprovalG.t157'/></span></li>
							<c:if test="${useExternalMailServer == 'NO'}">
							<li id="btnMail"><span class="icon16 popup_icon16_mail_gray" onClick="return btnMail_onclick()"></span></li>
							</c:if>
							</c:when>
						<c:otherwise>
							<li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>        
							
							<span style ="display:none" ><li id="btnSetAprLine"><span onClick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li></span>
							<span style ="display:none" ><li id="btnSetReceivLine" style="display:none"><span  onClick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t154'/></span></li></span>
							<li id="btnSendDraft"><span onClick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
				<%-- 			<li id="btnRJunkyul" class = 'approvalG'><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li> --%>
							<li id="btnRJunkyul"><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li>
							<span style ="display:none" ><li id="btnSetTaskCode"><span onClick="btnSetTaskCode_onclick()"  ><spring:message code='ezApprovalG.t51'/></span></li></span>
							<span style ="display:none" ><li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li></span>
							<li id="btnFileAttach" style ="display:none"><span onClick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
							<li id="btnAprDocAttach" style ="display:none"><span  onClick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
							<c:if test="${approvalFlag == 'G'}">
								<li id="btnAddSepAttach"><span  onClick="btnAddSepAttach_onclick()"  ><spring:message code='ezApprovalG.t58'/></span></li>
							</c:if>
							<c:if test="${isNonElecRec != 'Y'}">
								<li id="btnReturn"><span onClick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
							</c:if>
							<li id="btnEdit"><span  onClick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
					<c:choose>
						<c:when test="${isNonElecRec eq 'Y'}">
							<li id="btnDel"><span onclick="return btnDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></li>
						</c:when>
					</c:choose>
							<li id="btnPrint"><span class="icon16 popup_icon16_print" onClick="return btnPrint_onclick()"></span></li>
							<li id="btnConn" style="display:none"><span  onClick="return btnConn_onclick()"  ><spring:message code='ezApprovalG.t157'/></span></li>
							<c:if test="${useExternalMailServer == 'NO'}">
							<li id="btnMail"><span class="icon16 popup_icon16_mail_gray" onClick="return btnMail_onclick()"></span></li>
							</c:if>
							<li id="moreBoardIcon" class="view_moreboarditem" style="display: block;">
								<span class="view_icon" onclick="this.parentNode.classList.toggle('on')">
									<img src="/images/ImgIcon/view_more.png">
								</span>
								<ul class="layer_select">
									<li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
									<li id="btnOpinion"><span onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
									<li id="btnAssign" ><span  onClick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t1430'/></span></li>
									<li id="btnDistribute"><span  onClick="return btnDistribute_onclick()"><spring:message code='ezApprovalG.t1432'/></span></li>
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
		          <li id="btnClose" ><span onClick="return btnClose_onclick()"></span></li>
		        </ul>
		      </div>
		</td>
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
		    <td style="padding-bottom:10px;height:90%;">
		        <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="recevEndContent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
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
		  		<img src="/images/icviewer_expend.png" class="allImg" id="all" onclick="allImg(this)" style="cursor:pointer; position: relative; top: 13px;" width="25" height="25">
			</div>
		</div>
		  </td>
		  </tr>
		   <tr>
			<td style="height:20px;">
                <table class="file" style="height:80px;">
                    <tr>
                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
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
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
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
		
		<XML ID="ATTACHINFO"></XML>
		<XML ID="DOCINFO"></XML>
		<XML ID="OPTIONINFO"></XML>
		<XML ID="APRLINEINFO"></XML>
		<XML ID="PREVNEXTDOCINFO"></XML>
		<XML ID="CONNINFO"></XML>
		<DIV ID="RECEIPTDEPTID" style="display:none"></DIV>
		<div id="AprMemberSN" style="display:none"></div>
		<input type="hidden" id="attAprStatus" value="">
	</body>
</html>
