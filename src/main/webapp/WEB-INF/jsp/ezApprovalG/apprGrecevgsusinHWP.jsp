<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1308'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Recvdocnumber_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/recevG_Susin_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezRecevG_Susin_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezRecevG_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CheckLines_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AutoAprLine_Cross.js"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendMailApprove.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/nonElecRec.js"></script>
		<script type="text/javascript">
		    var pWriterDeptID;
		    var pDocID = "${docID}";
		    var pFormHref = new String("");
		    var pFormID = new String();
		    var zFormID = new String();
		    var pUserID = "${userInfo.id}";
		    var pHasAttachYN = new String("N");
		    var pHasOpinionYN = new String("N");
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
		    var IsSkipDrafter 
		    var badForm = false;
		    var g_docnumber = "";
		    var docAccess = false;
		    var pCurSelRow;
		    var pSusinDocURL = "";
		    var pOrg_orgDocID = "${orgDocID}";
		    var chkOK = false;
		    var isReDraft = "${isReDraft}";
		    var LastSignNo;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
		    var btnSendDraftEnable = "false";
		    var gPublic = "";
		    var s_nCallCnt = false; 
		    var sCompanyID   = '${userInfo.companyID}';
		    var CurAprType = "";
		    var NextAprType = "";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";								
		    arr_userinfo[1]  = "${userInfo.id}";							
		    arr_userinfo[2]  = "${userInfo.displayName1}";
		    arr_userinfo[3]  = "${userInfo.title1}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName1}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";             
		    arr_userinfo[9]  = sCompanyID;
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";		
		    var pCompanyID = "${userInfo.companyID}";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "1";
		    var cabinetID = "";
		    var TaskCode = "";
		    var DocNumCode = "";
		    var SummaryFlag = false;
		    var pDocTitle = "";
		    var pDocNumCode, pOrgDocNumCode, pDocNo;
		    var maxwidth = 659;							
		    var KuyjeType = "002";
		    var signDateFormat = "${optSignDateFormat}";
		    var isSplit = "${optIsSplit}";
		    var SplitKind = "${optSplitKind}";
		    var sihangURL = "${sihangURL}";
		    var pReadPC = false;
		    var arrDelFiles = new Array();
		    var g_DraftFlag = "${draftFlag}";
		    var g_RetFlag = "${retFlag}";
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var isExtDoc = "N";   
		    var pGubun;
		    var pUse_Editor = "${useEditor}";
		    var g_szUserID = arr_userinfo[8];
		    var g_senderinfo = '${userInfo.companyID}' + ", " + "${userInfo.deptName1}" + ", " + "${userInfo.title1}";
		    var approvalFlag  = '${approvalFlag}';
		    var ext = "hwp";
		    var nonElecRec = "${isNonElecRec}";
		    var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
		    var dirPath = "${approvalRoot}";
		    
		    function process_AfterOpen() {
		        try {
		            if (pFormHref == "") {
		                SetBtnStateFalse();
		                GetAprDocFormID();
		                setAttachInfo(pDocID, "APR", lstAttachLink);
		                getDocInfo();
		            } else {
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
		
		                    if (pHasOpinionYN == "Y") {
		                        if (pAprState == "006")
		                            pInformationContent = "<spring:message code='ezApprovalG.t124'/><br> <spring:message code='ezApprovalG.t10'/>";
		                        else
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
		
		                        Ans = OpenInformationUI(pInformationContent);
		                        if (Ans)
		                            openOpinionUI("Display");
		                    }
		
		                }
		                else if (pDraftFlag == "SUSIN" || pDraftFlag == "GONGRAM") {
		                    var len;
		                    len = pFormHref.lastIndexOf("/");
		
		                    GetAprDocFormID();
		                    setAttachInfo(pDocID, "APR", lstAttachLink);
		                    getDocInfo();
		
		                    if (g_DraftFlag == "REDRAFT") {
		                        setMenuBar("btnAssign", false);
		                        setMenuBar("btnDistribute", false);
		                    }
		
		                    if (g_RetFlag == "Y") {
		                        btnReturn_onclick();
		                    }
		                    else {
		                        if (pHasOpinionYN == "Y") {
		                            var pInformationContent;
		                            var Ans;
		
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
		                            Ans = OpenInformationUI(pInformationContent);
		
		                            if (Ans)
		                                openOpinionUI("Display");
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
		
		                        pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
		                        Ans = OpenInformationUI(pInformationContent);
		
		                        if (Ans) {
		                            openOpinionUI("Display");
		                        }
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
		                SignCheck();
		            }
		        }
		        catch (e) {
		            alert("process_AfterOpen : " + e.description);
		        }
		    }
		
		
		    function setAutoProperty() {
		        try {
		            getDraftUserInfo();
		            SetAutoPropertyValue();
		
		            var rtnVal = ExcuteInfo("INIT", "");
		            if (!rtnVal) {
		            }
		        }
		        catch (e) {
		            alert("setAutoProperty : " + e.description);
		        }
		    }
		
		    window.onresize = function () {
		        HwpCtrl.style.height = null;
		        HwpCtrl.height = document.documentElement.clientHeight - 150;
		    }
		
			function window_onload() {
			    window.onresize();
			    HwpCtrl.SetSaveMode(1);
			    try {
			        IsSkipDrafter = "FALSE"
			        SetBtnStateTrue();
			
			        getReceiveDocInfo();
			        
			        if (nonElecRec == "Y") {
				        getNonElecInfoSusinInit();
	                	document.getElementById("btnAddSepAttach").style.display = "none";
			        }
			        
			        if (pSusinDocURL != "") {
			            if (pSusinDocURL == "PC") {
			
			                HwpCtrl.LoadFile("", false);
			                pReadPC = true;
			            }
			            else {
			                showProgress("<spring:message code='ezApprovalG.t368'/>");
						    URL = document.location.protocol + "//" + document.location.hostname  + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pSusinDocURL);
						    var isTrue = HwpCtrl.LoadFile(URL, false);
			
						    FieldsAvailable(isTrue);
						}
			        }
			
			        else {
			            showProgress("<spring:message code='ezApprovalG.t121'/>");
					    URL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath="+ escape(pRelayURL);
					    var isTrue = HwpCtrl.LoadFile(URL, false);
					    FieldsAvailable(isTrue);
					}
			        HwpCtrl.ChangeMode(3);
			
			        HwpCtrl.SetFieldFocus("doctitle");
			        HwpCtrl.ezSetScrollPosInfo(0);
			    }
			    catch (e) {
			        alert("<spring:message code='ezApprovalG.t1373'/>" + e.description);
				    hideProgress();
				}
			}
		
			function FieldsAvailable(isTrue) {
			    if (needDoubleFormFlag) {
			        var tempFlag = getExtInfo();
			        if (tempFlag) {
			            setAutoProperty();
			            process_AfterOpen();
			            SetBtnStateTrue();
			            hideProgress();
			        } else {
			            hideProgress();
			            var pAlertContent = "<spring:message code='ezApprovalG.t1403'/>";
						OpenAlertUI(pAlertContent);
						chkBtnConfirm("1");
			
						return;
			        }
			    } else {
			        if (pFormHref == "") {
			            var isRelay = GetRelayDocInfo();
			            if (isRelay) {
			                try {
			                    document.getElementById("btnReqReSend").style.display = "";
			                    if (getNodeText(pRelayDocInfo.getElementsByTagName("isPKI").item(0)) == "Y") {
			                        hideProgress();
			
			                        if (!getPasswdEnd()) {
			                            var pAlertContent = "<spring:message code='ezApprovalG.t27'/><br> <spring:message code='ezApprovalG.t237'/>";
			                            OpenAlertUI(pAlertContent);
			                            chkBtnConfirm("1");
			                        }
			                        else {
			                            var emlName = getNodeText(pRelayDocInfo.getElementsByTagName("emlURL").item(0));
			                            //이부분이 타는지 체크해야함 탄다면 어떤 의미인지도 체크
			                            if (!decodeUp(emlName)) {
			                                hideProgress();
			                                chkBtnConfirm("1");
			                                return;
			                            }
			                        }
			                    }
			                    
			                    var tempFlag = getExtInfo();
			                    if (tempFlag) {
			                        setAutoProperty();
			                        process_AfterOpen();
			                        SetBtnStateTrue();
			                        hideProgress();
			                    }
			                    else {
			                        document.getElementById("btnRefresh").style.display = "";
			                        if (!needDoubleFormFlag) {
			                            hideProgress();
			                            var pAlertContent = "<spring:message code='ezApprovalG.t1403'/>";
			                            OpenAlertUI(pAlertContent);
			                            chkBtnConfirm("1");
			                            return;
			                        }
			                    }
			                } catch (e) {
			                    document.getElementById("btnRefresh").style.display = "";
			                }
			            }
			            else {
			                hideProgress();
			                chkBtnConfirm("1");
			                document.getElementById("btnRefresh").style.display = "";
			                return;
			            }
			        }
			    }
			
			    if (isTrue) {
			        pGubun = "11";
			
			        SetReceiptNumber();
			        hideProgress();
			        setMenuBar("btnEdit", false);
			
			        setAutoProperty();
			        process_AfterOpen();
			        setFirstDrafter();
			
			        if (SignCount < 1) {
			            pGubun = "12";
			            btnSetAprLine.style.display = "none";
			            btnSendDraft.style.display = "none";
			            setNodeText(btnRJunkyul.childNodes[0], "<spring:message code='ezApprovalG.t1406'/>");
			
			            if (pDocType == "001") {
			                btnReturn.style.display = "none";
			
			                var NewIsRelay = GetRelayDocInfo();
			                if (NewIsRelay) {
			                    btnReqReSend.style.display = "";
			                } else {
			                    btnReqReSend.style.display = "none";
			                }
			
			                if (pAprState == "011") {
			                    btnDistribute.style.display = "";
			                    btnReDistribute.style.display = "none";
			                    btnAssign.style.display = "";
			                    btnReAssign.style.display = "none";
			                }
			                else if (pAprState == "012") {
			                    btnDistribute.style.display = "none";
			                    btnReDistribute.style.display = "none";
			                    btnAssign.style.display = "none";
			                    btnReAssign.style.display = "";
			                }
			                else if (pAprState == "014") {
			                    btnDistribute.style.display = "none";
			                    btnReDistribute.style.display = "";
			                    btnAssign.style.display = "";
			                    btnReAssign.style.display = "none";
			                }
			            }
			        }
			
			        getGongRamDocInfo();
			
			        var g_SepAttachLVXml = "";
			        g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
			
			        if (!g_SepAttachLVXml)
			            g_SepAttachLVXml = "";
			
			        SetDocumentElement(HwpCtrl, "SepAttachLVXml", SetSepAttParamXmlNull(g_SepAttachLVXml))
			
			        if (pReadPC) {
			            var DocumentInfo = createXmlDom();
			            DocumentInfo = loadXMLString(HwpCtrl.GetDocumentInfo());
			            if (DocumentInfo.getElementsByTagName("TITLE").length > 0) {
			                if (getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0)) == "")
			                    pFormID = getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0));
			            }
			        }
			    }
			    else {
			        hideProgress();
			        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			        OpenAlertUI(pAlertContent);
			        HwpCtrl.ClearDocument();
			    }
			    HwpCtrl.SetImgReg();
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
			        btnSendDraftEnable = "true"
			        IsSkipDrafter = "FALSE";
			        btnSendDraft.Enable = "true";
			        GetDraftAprLineInfo(ret);
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
			        alert("btnSetReceivLine_onclick : " + e.description);
			    }
			}
		
			function btnSendDraft_onclick() {
			    try {
			        var rtnSignInfo;
			        if (btnSendDraftEnable == "false") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			
			        if (!checkLines())
			            return;
			
			        try {
			            var pSusinNextSN = 0;
			
			
			            if (pSusinSN)
			                pSusinNextSN = parseInt(pSusinSN, 10) + 1;
			            else
			                pSusinNextSN = 1;
			
			            var fieldname = pSusinNextSN + "sign1";
			            if (HwpCtrl.CheckFieldExist(fieldname) && CheckDeptLinesXML == "") {
			                var pInformationContent = "<spring:message code='ezApprovalG.t1409'/><br><br>" +
										"<spring:message code='ezApprovalG.t1410'/>";
			                var Ans = OpenInformationUI(pInformationContent);
			
			                if (Ans) {
			                    btnSetReceivLine_onclick();
			                }
			            }
			        }
			        catch (e) { }
			
			        /* if (cabinetID == "")
			            btnApprovalInfo(); */
			
			        if (cabinetID == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t134'/>";
			            OpenAlertUI(pAlertContent);
			            btnApprovalInfo();
			            return;
			        }
			
			        var g_SepAttachLVXml = "";
			        g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
			        if (!g_SepAttachLVXml)
			            g_SepAttachLVXml = "";
			
			        if (!CheckSepAttParamXmlNull(g_SepAttachLVXml)) {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1411'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			
			        if (g_DraftFlag == "REDRAFT")
			            delOpinionInfo();
			
			        if (HwpCtrl.CheckFieldExist("doctitle"))
			            pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
			        else
			            pDocTitle = "<spring:message code='ezApprovalG.t1394'/>";
			        if (pDocTitle == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1395'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			        else {
			        	if ("${approvalPWD}" != "N") {
			                var chkpass = chk_Passwd();
			                if (chkpass == "False") {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
					            OpenAlertUI(pAlertContent);
					            return;
			                } else if (chkpass == "cancel" || chkpass == undefined) {
					            var pAlertContent = "[<spring:message code='ezApprovalG.t1413'/>";
					                OpenAlertUI(pAlertContent);
					                return;
					            }
			            }
			
			            if (IsSkipDrafter == "FALSE") {
			                var ret;
			                var parameter = new Array();
			                parameter[0] = pDocID;
			
			                if (SignCount < 1) {
			                    ret = "NAME";
			                }
			                else {
			                    ret = openSignUI(parameter);
			                }
			
			                if (ret == "cancel") {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t1413'/>";
			                    OpenAlertUI(pAlertContent);
			                    return;
			                }
			
			                if (getLastAprLine() == false) {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1414'/><br>" +
													"<spring:message code='ezApprovalG.t1415'/>";
			                      OpenAlertUI(pAlertContent);
			                      try {
			                          btnSetAprLine_onclick();
			                      }
			                      catch (e) { }
			                      return;
			                  }
			
			                  pOrgHtml = HwpCtrl.GetCloneData("", "HWP");
			
			                  if (LastSignSN == 1) {
			                      var rtnVal;
			                      rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")
			
			                      if (!rtnVal) {
			                          var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                        OpenAlertUI(pAlertContent);
			                        return;
			                    }
			                }
			
			                if (LastSignSN == 1) {
			                    var rtnVal;
			                    rtnVal = ExcuteInfo("DOCNUM_AFTER", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                          OpenAlertUI(pAlertContent);
			                          return;
			                      }
			                  }
			
			                  if (LastSignSN == 1) {
			                      var rtnVal = ExcuteInfo("LAST_SEND_BEFORE", "")
			                      if (!rtnVal) {
			                          return;
			                      }
			                  }
			
			                  if (SignCount >= 1) {
			                      rtnSignInfo = SendDraftMappingSign(ret);
			                  }
			              }
			
			              var rtnval = true;
			              rtnval = getRecvDocNumber(arr_userinfo[4]);
			              if (!rtnval) {
			                  var pAlertContent = "[접수 문서번호]를 가져오지 못했습니다!";
			                  OpenAlertUI(pAlertContent);
			
			                  return;
			              }
			
			              if (LastSignSN != 1) {
			                  var rtnVal = ExcuteInfo("LAST_APR_BEFORE", "")
			                  if (!rtnVal) {
			                      return;
			                  }
			              }
			
			              if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
			                  var RtnVal;
			                  var pAlertContent;
			                  RtnVal = setSusinUpdataDocID();
			
			                  if (RtnVal == "TRUE") {
			                      RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "")
			                      if (!RtnVal) {
			                          pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                          OpenAlertUI(pAlertContent);
			                          return;
			                      }
			
			                      RtnVal = SaveDraftDocInfo();
			                      if (RtnVal == "TRUE") {
			                          RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "")
			                          if (!RtnVal) {
			                              pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                              OpenAlertUI(pAlertContent);
			                              return;
			                          }
			
			                          if (LastSignSN == 1) {
			                              RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "")
			                              if (!RtnVal) {
			                                  pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                                  OpenAlertUI(pAlertContent);
			                                  return;
			                              }
			
			                              RtnVal = ExcuteInfo("LAST_END_AFTER", "")
			                              if (!RtnVal) {
			                                  var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                                  OpenAlertUI(pAlertContent);
			                                  return;
			                              }
			                              SendMailToDrafter();
			                          }
			                          else {
			                              sendAlertMail("APR", "1", "RECEV_END");
			                          }
			
			                          if (LastSignSN == 1)
			                              pAlertContent = "<spring:message code='ezApprovalG.t1697'/>";
			                        else
			                            pAlertContent = "<spring:message code='ezApprovalG.t1698'/>";
			                        OpenAlertUI(pAlertContent);
			                        chkOK = true;
			                        window.close();
			                    }
			                    else {
			                        UndoSignInfo(rtnSignInfo);
			
			
			                        if (LastSignSN == 1) {
			                            RtnVal = ExcuteInfo("END_FAIL", "")
			                            if (!RtnVal) {
			                                pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                                  OpenAlertUI(pAlertContent);
			                                  return;
			                              }
			                          }
			                          pAlertContent = "[<spring:message code='ezApprovalG.t1495'/>";
			                          OpenAlertUI(pAlertContent);
			                          return;
			                      }
			                  }
			                  else {
			                      UndoSignInfo(rtnSignInfo);
			
			
			                      if (LastSignSN == 1) {
			                          RtnVal = ExcuteInfo("END_FAIL", "")
			                          if (!RtnVal) {
			                              pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                              OpenAlertUI(pAlertContent);
			                              return;
			                          }
			                      }
			
			                      SetBtnStateTrue();
			                      btnSendDraft.Enable = "true";
			
			                      pAlertContent = "[<spring:message code='ezApprovalG.t1495'/>";
			                      OpenAlertUI(pAlertContent);
			                      return;
			                  }
			              }
			              else {
			                  var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "")
			                  var pAlertContent;
			
			                  if (!RtnVal) {
			                      pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                      OpenAlertUI(pAlertContent);
			                      return;
			                  }
			
			                  RtnVal = SaveDraftDocInfo();
			                  if (RtnVal == "TRUE") {
			                      RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "")
			                      if (!RtnVal) {
			                          pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                          OpenAlertUI(pAlertContent);
			                          return;
			                      }
			
			
			                      if (LastSignSN == 1) {
			                          RtnVal = ExcuteInfo("DOCNUM_END", "")
			                          if (!RtnVal) {
			                              pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                              OpenAlertUI(pAlertContent);
			                              return;
			                          }
			                      }
			
			                      pAlertContent = "<spring:message code='ezApprovalG.t1698'/>";
			                      OpenAlertUI(pAlertContent);
			                      chkOK = true;
			                      window.close();
			                  }
			                  else {
			                      UndoSignInfo(rtnSignInfo);
			
			
			                      if (LastSignSN == 1) {
			                          RtnVal = ExcuteInfo("END_FAIL", "")
			                          if (!RtnVal) {
			                              pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
				  			            OpenAlertUI(pAlertContent);
				  			            return;
				  			        }
			                      }
			                      SetBtnStateTrue();
			                      pAlertContent = "[<spring:message code='ezApprovalG.t1495'/>";
			                      OpenAlertUI(pAlertContent);
			                      return;
			                  }
			              }
			          }
			      }
			      catch (e) {
			          alert("btnSendDraft_onclick : " + e.description);
			      }
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
		        				mode     : ""
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
		            alert("getLastAprLine :: " + e.description);
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

			              if (pCheckUserID == pUserID) {
			                  return true;
			              } else {
			                  return false;
			              }
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
			      var ret = openOpinionUI("N");
			  }
			
			  function btnSave_onclick() {
			      HwpCtrl.SetDocumentInfo(pFormID);
			      HwpCtrl.SaveFile("");
			  }
			
			  function btnPrint_onclick() {
			      HwpCtrl.PrintDocument("", true);
			  }
			
			  function btnClose_onclick() {
			      window.close();
			  }
		
			  function window_onbeforeunload() {
			      try {
			          window.opener.openergetDocInfo();
			          if (!chkOK) {
			
			              if (isReDraft == "N")
			                  delDocInfo();
			          }
			      }
			      catch (e) { }
			
			      try {
			          window.opener.Refresh_Window();
			      }
			      catch (e) { }
			
			      //사용하지 않는게 좋을듯 엑티브엑스를 이용하여 템프파일 생성 후 지우는거 
// 			      DeleteLocalFiles();
			  }
		
			  function DeleteLocalFiles() {
			      var ezUtil = new ActiveXObject("EzUtil.MiscFunc");
			
			      for (var i = 0 ; i < arrDelFiles.length ; i++) {
			          ezUtil.UseUTF8 = true;
			          ezUtil.DeleteFile(arrDelFiles[i]);
			      }
			
			      ezUtil = null;
			  }
		
			  function btnDistribute_onclick() {
			      var parameter = new Array();
			      parameter[0] = pDocID;
			      parameter[1] = pSusinSN;
			      parameter[2] = arr_userinfo[4];
			      parameter[3] = pAprState;
			      parameter[4] = getNodeText(RECEIPTDEPTID);
			
			      var url = "/ezApprovalG/ezReceiveDistributeUI.do";
			      var feature = "status:no;dialogWidth:1000px;dialogHeight:760px;edge:sunken;scroll:no"
			      var ret = window.showModalDialog(url, parameter, feature);
			      if (ret == "true") {
			          var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
			          OpenAlertUI(pAlertContent);
			          btnClose_onclick();
			      }
			  }
			  
			  function btnAssign_onclick() {
			      var parameter = new Array();
			      parameter[0] = pDocID;
			      parameter[1] = pSusinSN;
			      parameter[2] = pAprState;
			
				  var url = "/ezApprovalG/ezReceiveAssignUI.do";
			      var feature = "status:no;dialogWidth:600px;dialogHeight:380px;edge:sunken;scroll:no"
			      var ret = window.showModalDialog(url, parameter, feature);
			      if (ret == "OK") {
			          var pAlertContent = "<spring:message code='ezApprovalG.t1420'/>";
			        OpenAlertUI(pAlertContent);
			        btnClose_onclick();
			        return;
			    }
			}
		
			function btnReturn_onclick() {
			    var pDocSN = "";
			    if (HwpCtrl.CheckFieldExist("receiptnumber")) {
			        var fieldValue = trim(HwpCtrl.GetFieldText("receiptnumber"));
			        if (fieldValue != "" && fieldValue.replace("@", "") == fieldValue) {
			            var tmpDocSN = fieldValue.substr(fieldValue.lastIndexOf("-") + 1);
			            if (!isNaN(tmpDocSN))
			                pDocSN = tmpDocSN;
			        }
			    }
			
			    var parameter = new Array();
			    parameter[0] = pDocID;
			    parameter[1] = "HeSong";
			    parameter[2] = KuyjeType;
			    parameter[3] = "";
			
			    if (pDocSN != "")
			        parameter[4] = "Y";
			    else
			        parameter[4] = "N";
			
			    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
			    parameter[99] = "hwp";
			    
			    var url = "/ezApprovalG/aprOpinion.do";
			    var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no;help:no"
			    var ret = window.showModalDialog(url, parameter, feature);
			    var hesongok = true;
			
			    if (ret != "cancel" && ret != undefined) {
			        setButtonReceiveTrue();
			
			        if (pDocSN != "")
			            hesongok = setCabinetHeSong(pDocSN);
			
			        if (hesongok) {
			            hesongok = setHeSongDocInfo();
			            if (hesongok) {
			                var ret2 = ExcuteInfo("SUSIN_HOISONG_AFTER", "")
			                if (!ret2) {
			                    pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
			                    OpenAlertUI(pAlertContent);
			                    return;
			                }
			
			                window.parent.close();
			
			                btnClose_onclick();
			            }
			        }
			    }
			}
		
			var modeflag = true;
			function btnEdit_onclick() {
			    if (modeflag) {
			        modeflag = false;
			        chkBtnConfirm("1");
			
			        beforeHtml = HwpCtrl.GetCloneData("", "HWP");;
			        HwpCtrl.ChangeMode(2);
			
			        setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t42'/>");
			      }
			      else {
			          var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
			          var Ans = OpenInformationUI(pInformationContent);
			
			          HwpCtrl.ChangeMode(3);
			          setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t44'/>");
				    if (Ans) {
				    }
				    else {
				        HwpCtrl.SetCloneData(beforeHtml, "", "HWP");
				    }
				    modeflag = true;
				    chkBtnConfirm("2");
			    }
			}
		
			function btnRJunkyul_onclick() {
			    var Resultxml;
			    var UserID = "${userInfo.id}";
			    var DisplayName =  "${userInfo.displayName}";
			    var DepID = "${userInfo.deptID}";
			    var DeptName = "${userInfo.deptName}";
			    var Position =  "${userInfo.title}";
			    var CompanyID = '${userInfo.companyID}';
			    var d = new Date();
			    var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();
			
			    Resultxml = "<LISTVIEWDATA><HEADERS>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t1421'/></NAME><WIDTH>30</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t379'/></NAME><WIDTH>50</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t230'/></NAME><WIDTH>60</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t108'/></NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t380'/></NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t381'/></NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t382'/></NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME><spring:message code='ezApprovalG.t383'/></NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "</HEADERS><ROWS><ROW>";
			    Resultxml = Resultxml + "<COLUMN>1</COLUMN>";
			    Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(DisplayName) + "</COLUMN>";
			    Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(Position) + "</COLUMN>";
			
			    Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(DeptName) + "</COLUMN>";
			    Resultxml = Resultxml + "<COLUMN><spring:message code='ezApprovalG.t25'/></COLUMN>";
			    Resultxml = Resultxml + "<COLUMN><spring:message code='ezApprovalG.t1422'/></COLUMN>";
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
			    Resultxml = Resultxml + "<DATA name='PMemberDeptName'>" + MakeXMLString(arr_userinfo[15]) + "</DATA>";
			    Resultxml = Resultxml + "<DATA name='SMemberDeptName'>" + MakeXMLString(arr_userinfo[16]) + "</DATA>";
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
	    		            btnSendDraftEnable = "true";
	    		            CurAprType = "<spring:message code='ezApprovalG.t25'/>";
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
		
			function btnMail_onclick() {
// 			    window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=" + pFormHref + "&cmd=docsend&DocID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
		        window.open("/ezEmail/mailWrite.do?docHref=" + pFormHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
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
			
			    var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG.aspx";
			    var feature = "status:no;dialogWidth:430px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
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
		
			function btnSendAround_onclick() {
			    var para = new Array();
			    para[0] = pDocID;
			    var url = "/myoffice/ezApprovalG/ReceivUI/AprGongRamLine.aspx";
			    var feature = "dialogWidth:557px;dialogHeight:535px;scroll:no;resizable:yes;status:no;help:no;edge:sunken";
			    var rtn = window.showModalDialog(url, para, feature);
			    if (rtn == "OK") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1424'/>";
			        OpenAlertUI(pAlertContent);
			        JiJungBeBuDisable();
			    }
			}
		
			function btnReAssign_onclick() {
			    var ret = openOpinionUI("BanSong");
			    if (ret != "cancel") {
			        var xmlpara = createXmlDom();
			        var xmlhttp = createXMLHttpRequest();
			        var objNode;
			        createNodeInsert(xmlpara, objNode, "PARAMETER");
			        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
			        createNodeAndInsertText(xmlpara, objNode, "pReceivSN", pSusinSN);
			        createNodeAndInsertText(xmlpara, objNode, "pProcessorID", pUserID);
			
			
			        xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/setReJijung.aspx", false);
			        xmlhttp.send(xmlpara);
			
			        if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1425'/>";
			            OpenAlertUI(pAlertContent);
			            btnClose_onclick();
			        }
			    }
			}
		
			function btnReDistribute_onclick() {
			    var ret = openOpinionUI("BanSong");
			    if (ret != "cancel") {
			        var xmlpara = createXmlDom();
			        var xmlhttp = createXMLHttpRequest();
			        var objNode;
			        createNodeInsert(xmlpara, objNode, "PARAMETER");
			        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
			        createNodeAndInsertText(xmlpara, objNode, "pReceivSN", pSusinSN);
			        createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
			
			
			        xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/setReBebu.aspx", false);
			        xmlhttp.send(xmlpara);
			
			        if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1426'/>";
			            OpenAlertUI(pAlertContent);
			            btnClose_onclick();
			        }
			    }
			}
		
			function JiJungBeBuDisable() {
			    btnAssign.style.display = "none";
			    btnDistribute.style.display = "none";
			    btnReturn.style.display = "none";
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
		            alert("getGongRamDocInfo :: " + e.description);
		        }
			}
		
		
			function SetReceiptNumber() {
			    if (pSusinSN > 1) {
			        if (HwpCtrl.CheckFieldExist("receiptnumber")) {
			            var ReceiptNumber = trim(HwpCtrl.GetFieldText("receiptnumber"));
			
			            if (ReceiptNumber != "") {
			
			                if (g_DraftFlag == "SUSIN") {
			                    HwpCtrl.SetFieldText("receiptnumber", "");
			                }
			            }
			        }
			    }
			}
		
		    var ezapprovalinfo_dialogArguments = new Array();
			function btnApprovalInfo() {
			    var onlydocinfiview = false;
			    var parameter = new Array();
				var chkReceivedDoc = 0;
		    	var url;
		    	var ret;
		    	var feature;
		    	
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
			    parameter[11] = "";
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
			        parameter[51] = sepAttachCheckYN; // 분첨 확인여부
		        }
			    
			    if (tempItemCode != "") {
			        tempdocnumcode = tempItemCode;
			    }
			    
			    if (chkReceivedDoc != 0) {
		        	alert("<spring:message code='ezApprovalG.pjg04'/>");
		        	window.close();
		        } else {
		        	  url = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&docType=" + pDocType + "&ext=" + "hwp";
				      feature = "status:no;dialogWidth:1140px;dialogHeight:750px;help:no;scroll:no;edge:sunken;";
					  ret = window.showModalDialog(url, parameter, feature);
		        }
			        if (ret != undefined && ret[0] == "OK") {
			            try {
			            	HwpCtrl.ChangeMode(2);
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
			
			                if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
				                var g_SelCabXml = ret[4];
				                var xmlCab = createXmlDom();
				                xmlCab = loadXMLString(g_SelCabXml);
				                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
				                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
				            }
			
			                tempSecurity = ret[7];
			                tempUrgent = ret[8];
			                pSummery = ret[9];
			                pPublicityCode = ret[11];
			                tempSecurityDate = ret[14];
			                
			                if (approvalFlag == "G") {
				                pSpecialRecordCode = ret[10];
				                pLimitRange = ret[12];
				                pPageNum = ret[13];
				                /*2018-04-05 김은석 수정 건설공사 공개여부*/
//	 			                setPublicFlag();
				                setPublicFlag2();
				                
				                if (nonElecRec == "Y") {
					            	nonElecRecInfoXml = ret[23];
					            	nonSepAttachLVXml = ret[24];
					            	g_szSCListXml =  ret[25];
					            	sepAttachCheckYN = ret[26];
					            	setNonElecRecInfo(nonElecRecInfoXml);
					            }
			                } else {
			                	tempKeep = ret[16];
			                	tempItemName = ret[17];
			                	tempItemName2 = ret[18];
			                	pPageNum = "1";
			                	pLimitRange = "1";
			                	pSpecialRecordCode = "1";
			                	tempPublic = ret[11];
			                	SetDocOption(ret[20]);
			                }
			                
			                
			                SummaryFlag = true;
			                HwpCtrl.ChangeMode(3);
			            } catch (e) {
			                alert("<spring:message code='ezApprovalG.pjj02'/>");
			            }
			        }
			    }
			 
			 
			function ReplaceString(Origin, Source, Target) {
			    return Origin.split(Source).join(Target);
			}
			
			function RefreshRecvDoc() {
			    SetHref("DEL");
			    window.location.reload(true);
			}
			
			function insertApprovConn() {
	        	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezConn/insertApprovConn.do",
            		data : {
            				htmlPK : "${htmlPK}",
            				docID : pDocID,
            				writerID : arr_userinfo[1],
            				formID : pFormID
            				},
            		success : function(data) {
            		}
            	});
	        }
			
			function updateApprovConn() {
		    	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezConn/updateApprovConn.do",
            		data : {
            				docID : pDocID,
            				formID : pFormID
            				},
            		success : function(data) {
            		}
            	});
		    }
	        
	        function ezNotieSetting() {
	        }
			
			function GetObject() {
				i_icd2.SetDocumentDisp(window.document);
                i_icd2.xmlURL = "http://" + document.location.hostname + ":" + location.port + "/ezPortal/componentListTransfer.do";
                i_icd2.CheckVersion();
                var nCount = i_icd2.nNeedDownload;

                if (nCount) {
                    if_Progress.StartOn();
                } else {
                    finish_download();
                }
			}
	
			function finish_download() {
				OfficeBugPatch();
			}
			
			function OfficeBugPatch() {
			}
			
			function btnDel_onclick() {
				if (nonElecRec == "Y") {
					if (confirm("삭제하시겠습니까 ?")) {
						RemoveSusinNonElecRecDoc(pDocID);
					}
				}
			}
		</script>
<!-- 		<script type="text/vbscript" language="vbscript"> -->
<!-- Function ConversionPt(cmm) -->
<!-- 	' 수정(2006.06.09) : 1pt = 0.35mm, 1mm = 2.86pt 로 계산 -->
<!-- 	'ConversionPt = cint(cmm * (CDbl(378) / CDbl(100))) -->
<!-- 	ConversionPt = Round(cmm * (CDbl(100) / CDbl(35)), 2) -->
<!-- End Function -->

<!-- Function ReplaceString(Origin, Source, Target) -->
<!-- 	ReplaceString = Replace(Origin, Source, Target) -->
<!-- End Function -->
<!--     	</script> -->
	</head>
	
	<body class="popup" onload="return window_onload()" onbeforeunload="return window_onbeforeunload()">
	    <object classid="clsid:80009476-666B-4869-8C04-AB03492561CD" id="ObjGPKI" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px"></object>
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <span style="display: none">
	                            <li id="btnSetAprLine"><span onclick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li>
	                        </span>
	                        <span style="display: none">
	                            <li id="btnSetReceivLine" style="display: none"><span onclick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t154'/></span></li>
	                        </span>
	                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
	                        <li id="btnRJunkyul"><span onclick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li>
	                        <li id="btnSendAround" style="display: none"><span onclick="return btnSendAround_onclick()"><spring:message code='ezApprovalG.t1428'/></span></li>
	                        <span style="display: none">
	                            <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><spring:message code='ezApprovalG.t9994'/></span></li>
	                        </span>
	                        <span style="display: none">
	                            <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        </span>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach" style="display: none"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach" style="display: none"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t1429'/></span></li>
	                        <li id="btnAddSepAttach"><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnAssign"><span onclick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t1430'/></span></li>
	                        <li id="btnReAssign" style="display: none"><span onclick="return btnReAssign_onclick()"><spring:message code='ezApprovalG.t1431'/></span></li>
	                        <li id="btnDistribute"><span onclick="return btnDistribute_onclick()"><spring:message code='ezApprovalG.t1432'/></span></li>
	                        <li id="btnReDistribute" style="display: none"><span onclick="return btnReDistribute_onclick()"><spring:message code='ezApprovalG.t1433'/></span></li>
	                        <c:choose>
		                        <c:when test="${isNonElecRec eq 'Y'}">
			                        <li id="btnDel"><span onclick="return btnDel_onclick()">삭제</span></li>
		                        </c:when>
		                        <c:otherwise>
			                        <li id="btnReturn"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
		                        </c:otherwise>
	                        </c:choose>
	                        <li id="btnReqReSend" style="display: none"><span onclick="return btnReqReSend_onclick()"><spring:message code='ezApprovalG.t1435'/></span></li>
	                        <li id="btnEdit"><span onclick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnMail"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t62'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()" style="display: none;"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="btnRefresh" style="display: none"><span onclick="return RefreshRecvDoc()"><spring:message code='ezApprovalG.t00013'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
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
	        <tr>
	            <td style="padding-bottom: 10px">
	                <div style="height: 100%" id="form1">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "${hwpToolbar}", "");</script>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td>
	                            <div id="lstAttachLink"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0"></iframe>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="OPTIONINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	    <xml id="PREVNEXTDOCINFO"></xml>
	    <xml id="CONNINFO"></xml>
	    <div id="RECEIPTDEPTID" style="display: none"></div>
	    <div id="AprMemberSN" style="display: none"></div>
	</body>
</html>