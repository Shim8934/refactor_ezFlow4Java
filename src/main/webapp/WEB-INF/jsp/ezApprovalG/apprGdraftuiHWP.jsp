<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t30'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/draft_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/draftG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/docnumberG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AutoAprLine_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CheckLines_Cross.js"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendMailApprove.js"></script>
		<script type="text/javascript" src="/js/showModalDialog.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezDraft_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/nonElecRec.js"></script>
	    <script type="text/javascript">
	        var FormHref = "${formURL}";
	        var DraftFlag = "${draftFlag}";
	        var DocType = "${formDocType}";
	        var SusinSN = "${susinSN}";
	        var DocState = "${docState}";
	        var ListType = "${listType}";
	        var AprState = "${aprState}";
	        var pEndDocHref = "${dirPath}";
	        var _connkey_ = "${connkey}";
	        var pFormHref = new String();
	        var pFormID = new String();
	        var pDocID = new String();
	        var pHasAttachYN = new String("N");
	        var pHasOpinionYN = new String("N");
	        var CurrentDate
	        var flag = false;
	        var fieldflag = false;
	        var xmldoc = new ActiveXObject("Microsoft.XMLDOM");
	        var xmluserInfo = new ActiveXObject("Microsoft.XMLDOM");
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
	        var isTmpDocID = "${isTmpDoc}";
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
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var pCompanyID = "${userInfo.companyID}";
	        var pUserID = arr_userinfo[1];
	        var KuyjeType = "002";
	        var signDateFormat = "${optSignDateFormat}";
	        var isSplit = "${optIsSplit}";
	        var SplitKind = "${optSplitKind}";
	        var sihangURL = "${sihangURL}";
	        var CurAprType = "";
	        var NextAprType = "";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "";
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
	        var DocSN = "${docSN}";
	        var AutoSave = "save";
	        var Saveflag = false;
	        var pUse_Editor = "${useEditor}";
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
	        var g_senderinfo = "${userInfo.companyName}" + ", " + "${userInfo.deptName}" + ", " + "${userInfo.title}";
	        var approvalFlag = "${approvalFlag}";
	        var isHWP = "${isHWP}";
	        var isUsed = "";
	        var ext = "hwp";
	        var nonElecRec = "${nonElecRec}";
	        var nonElecRecInfoXml = "", nonSepAttachLVXml = "";
	        
	        window.onload = function () {
	            try {
	                window.onresize();
	                pSusinSN = SusinSN;
	                setMenuBar("btnSendDraft", true);
	                dragNdrapNo();
	
	                HwpCtrl.SetImgReg();
	                HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
	                HwpCtrl.SetSaveMode(1);
	
	                IsSkipDrafter = "FALSE"
	                DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
	                drafterDeptid = arr_userinfo[4];
	                getDraftInfo();
	                SetBtnStateFalse();
	
	                if (pFormHref != "") {
	                    var URL;
	                    showProgress("<spring:message code='ezApprovalG.t368'/>");
	                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pFormHref);
	                    var isTrue = HwpCtrl.LoadFile(URL, false);
	                    FieldsAvailable(isTrue);
	                } else {
	                    DraftFlag = "DRAFT";
	                    pDraftFlag = "DRAFT";
	                    showProgress("<spring:message code='ezApprovalG.t368'/>");
	                    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(sihangURL.replace(".mht", ".hwp"));
	                    var isTrue = HwpCtrl.LoadFile(URL, false);
	                    FieldsAvailable(isTrue);
	                }
	
	                HwpCtrl.SetFieldFocus("doctitle");
	                HwpCtrl.ezSetScrollPosInfo(0);
	                
	                /* 
	                * 비전자문서 구분 값, 사용불가한 버튼들 가리기
	                */
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
	                	HwpCtrl.SetFieldText("docnumber","");
	                }
	            } catch (e) {
	                alert("ezdraftui_hwp.window.onload::" + e.description);
	                hideProgress();
	            }
	        }
	
	        window.onresize = function () {
	            HwpCtrl.style.height = null;
	            HwpCtrl.height = document.documentElement.clientHeight - 150;
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
	                alert("ezdraftui_hwp.dragNdrapNo()::" + e.description);
	            }
	        }
	
	        function FieldsAvailable(isTrue) {
	            try {
	                if (isTrue) {
	                    SetBtnStateTrue();
	                    setAutoProperty();
	                    hideProgress();
	                    window.focus();
	                    HwpCtrl.focus();
	
	                    if (pFormHref == "") {
	                        hideProgress();
	                        getExtInfo();
	                    }
	
	                    if (pReadPC) {
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
	                    }
	
	                    process_AfterOpen();
	
	                    if (_connkey_ != "") {
	                        try {
	                            if (HwpCtrl.CheckFieldExist("_connkey_"))
	                                HwpCtrl.SetFieldText("_connkey_", _connkey_);
	                        } catch (e) { }
	                    }
	                    
	                    var rtnVal = ExcuteInfo("INIT", "");
	                    
	                    if (!rtnVal) {
	                        if (OpenInformationUI("<spring:message code='ezApprovalG.t122'/>")) {
	                            btnClose_onclick();
	                        }
	                    }
	                    
	                    if (pDraftFlag != "REDRAFT") {
	                        setFirstDrafter();
	                    } else {
	                        SignCheck();
	                    }
	                    
	                    HwpCtrl.SetFieldFocus("doctitle");
	                    HwpCtrl.ezSetScrollPosInfo(0);
	                    HwpCtrl.SetImgReg();
	                } else {
	                    hideProgress();
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    HwpCtrl.ClearDocument();
	                }
	            } catch (e) {
	                alert("ezdraftui_hwp.FieldsAvailable()::" + e.description);
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
			
			        if (xmlhttp.statusText == "OK") {
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
			
			                if (pHasOpinionYN == "Y") {
			                    if (AprState == "<spring:message code='ezApprovalG.t49'/>")
			                                pInformationContent = "<spring:message code='ezApprovalG.t124'/><br> <spring:message code='ezApprovalG.t10'/>";
				  		    else
				  		        pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t10'/>";
			
			                  Ans = OpenInformationUI(pInformationContent);
			                  if (Ans) {
			                      openOpinionUI("Display");
			                  }
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
					  	  	  Ans = OpenInformationUI(pInformationContent);
				
					  	  	  if (Ans) {
					  	  		  openOpinionUI("Display");
					  	  	  }
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
					  	  		Ans = OpenInformationUI(pInformationContent);
				
					  	  		if (Ans) {
					  	  		    openOpinionUI("Display");
					  	  		}
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
			                }
			            }
					}
				} catch (e) {
				    alert("ezdraftui_hwp.process_AfterOpen()::" + e.description);
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
	
	        function btnSendDraft_onclick() {
// 	            try {
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
			    	
			    	// 본문의 용량을 구하기 위함 2018-07-13
			    	var strClone = HwpCtrl.GetCloneData("", "HWPML2X");
			    	var strBytes = parseInt(getByteLength(strClone));
								    	
			    	console.log(strBytes);
			    	
	                var rtnAttachXML = new ActiveXObject("Microsoft.XMLDOM");
	                rtnAttachXML.loadXML(result);
					
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
	
	                var rtnSignInfo;
	                if (GetDocumentElement(HwpCtrl, "WORKFLOWXML") != "") {
	                    var rtn = checkValidation(GetDocumentElement(HwpCtrl, "WORKFLOWXML"))
	                    if (rtn == "FALSE")
	                        return;
	                    else if (rtn != "TRUE") {
	                        var pInformationContent = rtn + "<spring:message code='ezApprovalG.t130'/>";
	                        var Ans = OpenInformationUI(pInformationContent);
	
	                        if (Ans) {
	                            var Ans = btnSetAprLine_onclick();
	                            return;
	                        } else {
	                            return;
	                        }
	                    }
		            }
		
		            if (HwpCtrl.CheckFieldExist("doctitle"))
		                pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
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
	                    btnApprovalInfo(1);
	                    return;
	                }
	
	                if (btnSendDraftEnable == "false") {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t1398'/>" + "<br>" + "<spring:message code='ezApprovalG.t1399'/>";
	                    OpenAlertUI(pAlertContent);
	                    btnApprovalInfo(1);
	                    
	                    return;
	                }
	                
	                if (!checkLines())
	                    return;
	
	                if (pSuSinFlag == "Y" && !btnReceivLineEnable) {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t141'/>" + "<br>" + "<spring:message code='ezApprovalG.t142'/>";
	                    if (OpenInformationUI(pAlertContent)) {
	                    	btnApprovalInfo(2);
	                    }
	                    return;
	                }
	
	                
	                if (cabinetID == "")
	                    btnApprovalInfo(3);
	                
	                if (cabinetID == "") {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t1397'/>";
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	
	                if (!SummaryFlag)
	                    btnApprovalInfo(4);
	
	                if (!SummaryFlag)
	                    return;
	
	                setDrafterAddress();
	
	                if (pDraftFlag == "REDRAFT")
	                    delOpinionInfo();
	
	                if (nonElecRec != "Y") {
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    var pInformationContent = "<spring:message code='ezApprovalG.t143'/><br> <spring:message code='ezApprovalG.t144'/>";
		                    var Ans = OpenInformationUI(pInformationContent);
		
		                    if (!Ans) return;
		
		                    if (pDraftFlag == "HABYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
		                        getLastOpinon();
		                    }
		
		                    if (HwpCtrl.CheckFieldExist("lastdraftdate"))
		                        HwpCtrl.SetFieldText("lastdraftdate", getGyulJeDate());
		                }
	                }
	
	                if ("${approvalPWD}" != "N") {
	                    var chkpass = chk_Passwd();
	                    if (chkpass == "False") {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    } else if (chkpass == "cancel" || chkpass == undefined) {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
	                }
	
	                if (IsSkipDrafter == "FALSE") {
	                	if (nonElecRec != "Y") {
		                    var ret;
		                    var parameter = new Array();
		
		                    parameter[0] = pDocID;
		                    ret = openSignUI(parameter);
		
		                    if (ret == "cancel") {
		                        var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
	                	}
	
	                    pOrgHtml = HwpCtrl.GetCloneData("", "HWP");
	
	                    if (LastSignSN == 1 || DraftLastFlag) {
	                        var rtnVal;
	                        rtnVal = ExcuteInfo("DOCNUM_BEFORE", "");
	                        if (!rtnVal) {
	                            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                            OpenAlertUI(pAlertContent);
	                            return;
	                        }
	                    }
	
	                    var rtnval;
	                    if (LastSignSN == 1 || DraftLastFlag)
	                        rtnval = getDocNumber(arr_userinfo[4], "");
	                    else
	                        rtnval = getDocNumber(arr_userinfo[4], "be");
	
	                    if (!rtnval) {
	                        var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	
	                    if (LastSignSN == 1 || DraftLastFlag) {
	                        var rtnVal;
	                        rtnVal = ExcuteInfo("DOCNUM_AFTER", "");
	                        if (!rtnVal) {
	                            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                            OpenAlertUI(pAlertContent);
	                            return;
	                        }
	                    }
	                    rtnSignInfo = SendDraftMappingSign(ret);
	                }
	
	                if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
	                    var RtnVal;
	                    var pAlertContent;
	                    RtnVal = setSusinUpdataDocID();
	                    if (RtnVal == "true") {
	                        RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "");
	                        if (!RtnVal) {
	                            pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                            OpenAlertUI(pAlertContent);
	                            return;
	                        }
	
	                        if (RtnVal)
	                            RtnVal = SaveDraftDocInfo();
	                        if (RtnVal == "TRUE") {
	                            RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "");
	                            if (!RtnVal) {
	                                pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                                OpenAlertUI(pAlertContent);
	                                return;
	                            }
	
	                            if (LastSignSN == 1 || DraftLastFlag) {
	                                RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "");
	                                if (!RtnVal) {
	                                    pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                                    OpenAlertUI(pAlertContent);
	                                    return;
	                                }
	                            }
	
	                            UpdateLineHistory();
	                            
	                            pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
	                            OpenAlertUI(pAlertContent);
	                            draftFlag = true;
	                            window.close();
	                        } else {
	                            UndoSignInfo(rtnSignInfo);
	
	                            if (LastSignSN == 1 || DraftLastFlag) {
	                                RtnVal = ExcuteInfo("END_FAIL", "");
	                                if (!RtnVal) {
	                                    pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                                    OpenAlertUI(pAlertContent);
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
	                            RtnVal = ExcuteInfo("END_FAIL", "")
	
	                            if (!RtnVal) {
	                                pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                                OpenAlertUI(pAlertContent);
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
	                    var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "");
	                    var pAlertContent;
	                    if (!RtnVal) {
	                        pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	
	                    if (LastSignSN == 1 || DraftLastFlag)
	                        SetAutoPropFinal();
	
	                    if (LastSignSN == 1 || DraftLastFlag) {
	                        var rtnVal = ExcuteInfo("LAST_SEND_BEFORE", "");
	                        if (!rtnVal) {
	                            return;
	                        }
	                    }
	
	                    RtnVal = SaveDraftDocInfo();
	                    if (RtnVal == "TRUE") {
	                        RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "");
	                        if (!RtnVal) {
	                            pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                            OpenAlertUI(pAlertContent);
	                            return;
	                        }
	
	                        if (LastSignSN == 1 || DraftLastFlag) {
	                            RtnVal = ExcuteInfo("DOCNUM_END", "");
	                            if (!RtnVal) {
	                                pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                                OpenAlertUI(pAlertContent);
	                                return;
	                            }
	                            Gyuljedate = GetDocInfoData("END", "STARTDATE");
	                            SendMailToReceiveDept(pDocTitle, arr_userinfo[2], Gyuljedate, pDocID);
	                        }
	                        else {
	                            Gyuljedate = GetDocInfoData("APR", "STARTDATE");
	                            sendAlertMail("APR", 1, "DRAFT");
	                        }
	
	                        UpdateLineHistory();
	                        
	                        if (nonElecRec == "Y") {
                            	pAlertContent = "문서를 [등록]하였습니다.";
                            } else {
		                        pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
                            }
	                        
	                        OpenAlertUI(pAlertContent);
	                        draftFlag = true;
	
	                        if (ListType == "21" && DraftFlag == "REDRAFT") {
	                            RemoveTmpDoc(DocSN);
	                        }
	                        
	                        if (nonElecRec == "Y") {
	                        	RemoveEndNonElecRecDoc(pDocID);
	                        }
	
	                        window.close();
	                    } else {
	                        UndoSignInfo(rtnSignInfo);
	                        if (LastSignSN == 1)
	                            rollbackDocNumber(arr_userinfo[4], "", pDocID);
	
	                        if (LastSignSN == 1 || DraftLastFlag) {
	                            RtnVal = ExcuteInfo("END_FAIL", "")
	
	                            if (!RtnVal) {
	                                pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
	                                OpenAlertUI(pAlertContent);
	                                return;
	                            }
	                        }
	
	                        SetBtnStateTrue();
	                        pAlertContent = "[<spring:message code='ezApprovalG.t1400'/>";
	                        OpenAlertUI(pAlertContent);
	                        return;
	                    }
	                }
// 	            } catch (e) {
// 	                alert("ezdraftui_hwp.btnSendDraft_onclick()::" + e.description);
// 	            }
	        }
	
	        function btnFileAttach_onclick() {
	            try {
	                var ret = openFileAttachUI();
	            } catch (e) {
	                alert("ezdraftui_hwp.btnFileAttach_onclick()::" + e.description);
	            }
	        }
	
	        function btnAprDocAttach_onclick() {
	            var ret = openAaprDocAttachUI();
	        }
	
	        function btnOpinion_onclick() {
	            var ret = openOpinionUI("N");
	        }
	
	        function btnSave_onclick() {
	            HwpCtrl.SetDocumentInfo(pFormID);
	            HwpCtrl.SaveFile("", HwpCtrl.GetFieldText("doctitle").replace(/\r\n/g, " "));
// 	            HwpCtrl.SaveFile("");
	        }
	
	        function btnPrint_onclick() {
	            HwpCtrl.PrintDocument("", true);
	        }
	
	        function btnClose_onclick() {
	            bAttachProcess = false;
	            if (OpenInformationUI("<spring:message code='ezApprovalG.t148'/><br><spring:message code='ezApprovalG.t149'/>"))
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
			    } catch (e) { }
			
			    try {
			        if (bAttachProcess == false)
			            window.opener.Refresh_Window();
			    } catch (e) { }
			
			    try {
			        bAttachProcess = true;
			    } catch (e) { }
			}
	
			function btn_Attach_onclick() {
			    btnFileAttach_onclick();
			}
	
			function btnMail_onclick() {
			    window.open("/ezEmail/mailWrite.do?cmd=docsend&docID=" + pDocID + "&docHref=" + pFormHref, '', 'height=700,width=690,resizable=yes,scrollbars=no' + GetOpenPosition(690, 700));
			}
	
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
			        setPublicFlag();
			        SummaryFlag = true;
			    } catch (e) {
			        alert("ezdraftui_hwp.btnDocInfo_onclick()::" + e.description);
			    }
			}
			
			/*PublicType, PublicLevel 기존의 공개여부 2018-04-04 김은석 수정*/
			function setPublicFlag() {
			    try {
			        if (!HwpCtrl.CheckFieldExist("publication"))
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
				    HwpCtrl.SetFieldText("publication", PublicText);
			
				} catch (e) {
				    alert("ezdraftui_hwp.setPublicFlag()::" + e.description);
				}
			}
	
		    /*기존의 공개여부 함수 2018-04-04 김은석 수정*/
		    function setPublicFlag2() {
		        if (!HwpCtrl.CheckFieldExist("publication")) return;
		        var PublicType = pPublicityYN.substring(0, 1);

		        if (PublicType == "Y")
		            PublicText = "<spring:message code='ezApprovalG.t47'/>";
		        else if (PublicType == "N")
		            PublicText = "<spring:message code='ezApprovalG.t46'/>";
		        else
		            PublicText = " ";
		        
		        HwpCtrl.SetFieldText("publication", PublicText);
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
	
			function btnAddSepAttach_onclick() {
			    try {
			        if (cabinetID == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1401'/>";
					    OpenAlertUI(pAlertContent);
					    return;
					}
				
				    var g_SepAttachLVXml = "";
				    g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml", true);
				    if (!g_SepAttachLVXml)
				        g_SepAttachLVXml = "";
				
				    var para = new Array();
				    para[0] = g_SepAttachLVXml;
				    para[1] = cabinetID;
					para[3] = ext;
					
				    var url = "/ezApprovalG/insSepAttach.do";
				    var feature = "dialogWidth:930px;dialogHeight:630px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";
			        var rtn = window.showModalDialog(url, para, feature);

				    if (rtn[0] == "TRUE") {
				        g_SepAttachLVXml = rtn[1];
				        SetDocumentElement(HwpCtrl, "SepAttachLVXml", g_SepAttachLVXml);
				    }
				} catch (e) {
				    alert("ezdraftui_hwp.btnAddSepAttach_onclick()::" + e.description);
				}
			}
	
			function GetSepAttParamXml(g_SepAttachLVXml) {
			    try {
			        var rtnXml = new ActiveXObject("Microsoft.XMLDOM");
			        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
			        var sepAtt, Data, i;
			        
			        if (g_SepAttachLVXml != "") {
			            var sepLVXml = new ActiveXObject("Microsoft.XMLDOM");
			            sepLVXml = loadXMLString(g_SepAttachLVXml);
			            var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW")
			            for (i = 0; i < rows.length; i++) {
			                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
			                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "CABINETID", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA1")));
			                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "TITLE", getNodeText(rows.item(i).childNodes(1).selectSingleNode("VALUE")));
			                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "NUMOFPAGE", getNodeText(rows.item(i).childNodes(4).selectSingleNode("VALUE")));
			                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "REGTYPE", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA2")));
			                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "SUMMARY", getNodeText(rows.item(i).childNodes(6).selectSingleNode("VALUE")));
			                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "AVTYPE", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA3")));
			
			            }
			        }
			        return getXmlString(rtnXml);
			    } catch (e) {
			        alert("ezdraftui_hwp.GetSepAttParamXml()::" + e.description);
			    }
			}
	
			function btnhistory_onclick() {
			    getHistory();
			}
			function btnApprovalInfo(pGubun) {
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
			        parameter[28] = onlydocinfiview
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
			        }
			        
			        if (tempItemCode != "")
			            tempdocnumcode = tempItemCode;
			
			        if (pGubun == undefined)
			            pGubun = CheckGubun;
			
			        var url = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&ext=" + "hwp";
			        var feature = "status:no;dialogWidth:1140px;dialogHeight:750px;help:no;scroll:no;edge:sunken;";
			        var ret = window.showModalDialog(url, parameter, feature);

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
			                GetDraftAprLineInfo(ret);
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
			                SummaryOuterReceiverList = ret[15];
			                setRecevInfo(ret[3]);
			            } else if (pSuSinFlag == "Y" && ret[2] == "") {
			                DeleteDeptInfo();
			                setRecevInfo("");
			            }
			
			            if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
			                var g_SelCabXml = ret[4];
			                var xmlCab = new ActiveXObject("Microsoft.XMLDOM");
			                xmlCab = loadXMLString(g_SelCabXml);
			                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
			            }
			            
			            tempSecurity = ret[7];
			            tempUrgent = ret[8];
			            pSummery = ret[9];
			            pSpecialRecordCode = ret[10];
			            pPublicityCode = ret[11];
			            pPublicityYN = ret[21];
			            pLimitRange = ret[12];
			            pPageNum = ret[13];
			            tempSecurityDate = ret[14];
			            if (ret[21].substring(0,1) == "N") {
		                	tempPublic = "N";
		                }
			            setPublicFlag();
			            SummaryFlag = true;
			            
			            if (nonElecRec == "Y") {
			            	nonElecRecInfoXml = ret[23];
			            	nonSepAttachLVXml = ret[24];
			            	
			            	setNonElecRecInfo(nonElecRecInfoXml);
			            }
			        }
			    } catch (e) {
			        alert("ezdraftui_hwp.GetSepAttParamXml()::" + e.description);
			    }
			}
	
			function btnSaveServer_onclick(AutoSave) {
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
			            if (HwpCtrl.CheckFieldExist("doctitle"))
			                pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
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
			            if (HwpCtrl.CheckFieldExist("doctitle"))
			                pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
			            if (pDocTitle == "")
			                return;
			        }
			
			        if (btnSendDraftEnable == "false" && ListType != "21") {
			            setFirstDrafterAuto();
			        }
			
			        if (ListType == "21" && DraftFlag == "REDRAFT") {
			            RemoveTmpDoc(DocSN);
			        }
			
			        var rtnVal = SaveTMPFile();
			        if (rtnVal == "TRUE") {
			            rtnVal = SaveTMPDocInfo(AutoSave, Saveflag);
			            if (rtnVal == "TRUE") {
			                if (AutoSave != "save") {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1581'/>";
			                    OpenAlertUI(pAlertContent);
			                    Saveflag = true;
			                    window.close();
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
			    } catch (e) {
			        alert("ezdraftui_hwp.btnSaveServer_onclick()::" + e.description);
			    }
			}
	
	        function btnHelper_onclick() {
	            var rtnVal = ExcuteInfo("INIT", "");
	            if (!rtnVal) {
	            }
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
	            { }
	            try {
	                if (bAttachProcess == false)
	                    window.opener.Refresh_Window();
	            }
	            catch (e)
	            { }
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
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btnSelForm"><span onclick="return btnSelForm_onclick()"><spring:message code='ezApprovalG.t152'/></span></li>
	                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li>
							<c:choose>
								<c:when test="${nonElecRec eq 'Y'}">
			                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()">등록</span></li>
								</c:when>
								<c:otherwise>
			                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
								</c:otherwise>
							</c:choose>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
	                        <li id="btnAddSepAttach"><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSave"><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="btnConn" style="display: none"><span onclick="return btnConn_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="btnSaveServer"><span onclick="return btnSaveServer_onclick()"><spring:message code='ezApprovalG.t4000'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                    </ul>
	                    <ul style="display: none;">
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><spring:message code='ezApprovalG.t9994'/></span></li>
	                        <li id="btnSetReceivLine"><span onclick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t154'/></span></li>
	                        <li id="btnSetAprLine"><span onclick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li>
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
	                <div style="height: 100%">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "2", "1", "${hwpToolbar}", "1");</script>
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
	    <xml id="SA_coredata"></xml>
	</body>
</html>