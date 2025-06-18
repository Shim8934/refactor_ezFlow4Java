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
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draft_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/draftG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AutoAprLine_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDraft_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
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
	        arr_userinfo[5] = "<c:out value ='${userInfo.deptName}'/>";
	        arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}'/>";
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
	        var isUsed = "";
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
			//원문정보공개
			var useOpenGov = "<c:out value='${useOpenGov}' />";
			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			var newpDocID = "";
	        var useRedraftOpinionKeep = "<c:out value='${useRedraftOpinionKeep}'/>";
	        var formAprOption = "<c:out value='${formAprOption}'/>";
	        var passAprLine = "";
	        var useWebHWP = "<c:out value ='${useWebHWP}'/>";

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";
	        
	        var gpGubun;
			//부서감사 관련 2020-01-14 홍대표
			var deptgamsaCount = 0;

			// 창마다 고유한 id 지정용
			var windowUuid = getRandomId();
	        
	        window.onload = function () {
	            try {
	                window.onresize();
	                pSusinSN = SusinSN;
	                setMenuBar("btnSendDraft", true);
	                dragNdrapNo();
	
	                HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
	                HwpCtrl.SetImgReg();
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
	                
	                /**
	                	기안인 경우에는 hwp파일이 실존하지 않아 로컬로 저장하는 것이 불가능하므로 저장버튼 display:none처리
	                	또한, 일반 mht쪽에서도 기안을 올릴 때 저장 기능이 없음.
	                */
	                if(DraftFlag === 'DRAFT') {
	                	$("#btnSave").css('display', 'none');
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
		        try{
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
	

						var targetText = GetDocumentElement(HwpCtrl, "CONNROOT", true);

						if (targetText != null && targetText.length > 0 ) {

							  var xmlData = loadXMLString(targetText);
    	
    						  var connNodes = GetChildNodes(xmlData.documentElement);

							  if(connNodes.length > 0) {
								  document.getElementById('btnSaveServer').style.display = 'none';		
							  }

							
						} 
	
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
			    openFormUIHwp();
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
			                      //openOpinionUI("Display");
			                	  openOpinionUI_New("");
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
					  	  		  //openOpinionUI("Display");
					  	  		  openOpinionUI_New("");
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
					  	  		    //openOpinionUI("Display");
					  	  			openOpinionUI_New("");
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
			                
			                if (isUsed == "reuse") {
                                if (apprReuseConfig != '1') {
                                    getDocInfo();
                                    setAttachInfo(pDocID, "APR", lstAttachLink);
                                    copySummaryForReuse(beforeDocID, pDocID);
                                }
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
			    var check = Form_checkHwp();
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
	        	var deptCheckFlag = checkDeptAndCabinetId();
	        	
				if (deptCheckFlag == "3") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n겸직부서를'" + arr_userinfo[5] + "'부서로 변경하시거나 기안창을 새로 띄워주시기바랍니다." );
					return;
				} else if (deptCheckFlag == "4") {
					alert("기안창의 부서정보가 '" + arr_userinfo[5] + "'부서로 되어있습니다. \n사용자의 부서가 변경되거나 겸직이 삭제되었으니 기안창을 새로 띄워주시기바랍니다.");
					return;
				} else if (deptCheckFlag == "2") {
					alert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}	
	        
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

					var FieldLists = HwpCtrl.GetFieldList();
					var Fields = FieldLists.split(";");
					var tempFields = FieldLists.split(";");

					tempFields = Fields.reduce(function(tempArr,curr,index) {
						tempArr.indexOf(curr) > -1 ? tempArr : tempArr.push(curr);
						return tempArr;
					},[]);

					if (Fields.length !== tempFields.length) {
						OpenAlertUI("동일한 Field가 존재합니다. 문서를 다시 확인해주세요.");
						return;
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
	                	var pAlertContent = "";
		            	//재기안의 경우 결재선 확인하라는 메세지 출력
		            	if (pDraftFlag == "REDRAFT") {
							pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
		            	} else {
		                    pAlertContent = "<spring:message code='ezApprovalG.t1398'/>" + "<br>" + "<spring:message code='ezApprovalG.t1399'/>";
		            	}
		            	
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
	
	                /* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
	                if (pDraftFlag == "REDRAFT" && useRedraftOpinionKeep != "YES") {
	                    delOpinionInfo();
	                }
	
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
	
	                //if ("${approvalPWD}" != "N") {
	                if (CheckUsePassword()) {
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
		
		                    if (ret == "cancel" || ret == undefined) {
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
	                          
	              		        //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
	              		        if (parent.opener != null && parent.opener.getApprovalList != undefined) { 
	              		        	parent.opener.clearAbsence(true);
	              		        }
	                            
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
	            //var ret = openOpinionUI("N");
	        	openOpinionUI_New("");
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

		        if (PublicType == "Y" || PublicType == "B")
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
	
			function btnAddSepAttach_onclick() {
				var deptCheckFlag = checkDeptAndCabinetId();
				
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
			    getHistory();
			}
			
			// var ezapprovalinfo_dialogArguments = new Array();
			function btnApprovalInfo(pGubun) {
				
				gpGubun = pGubun;
				
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
					
			        // ezapprovalinfo_dialogArguments[0] = parameter;
			        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
			        
					if(DraftFlag == "REDRAFT" && SusinSN == "1" && DocState == "011" && AprState == "004") {
						gpGubun = "11";
					}
					
			        var OpenUrl = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + gpGubun +"&docType=" + pDocType + "&ext=" + "hwp";
			        
			        if (ListType == "21") {
			            OpenUrl += "&docSN=" + DocSN;
					}
			        if (isUsed == "reuse") {
			        	OpenUrl +=  "&isUsed=" + isUsed + "&beforeDocID=" +beforeDocID
			        }
			        // var OpenWin = window.open(OpenUrl , "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1144, 750));
			        //
			        // try { OpenWin.focus(); } catch (e) { }
			        ezCommon_cross_dialogArguments[0] = parameter;
			        showPopup(OpenUrl, 1144, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1144, 750), btnApprovalInfo_Complete);
			    } catch (e) {
			        alert("ezdraftui_hwp.btnApprovalInfo()::" + e.description);
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

			            if (gpGubun != "5" && gpGubun != "6" && gpGubun != "7" && gpGubun != "8" && gpGubun != "9" && gpGubun != "10") {
			                var g_SelCabXml = ret[4];
			                var xmlCab = new ActiveXObject("Microsoft.XMLDOM");
			                xmlCab = loadXMLString(g_SelCabXml);
			                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
			            }

						tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
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
			            } else if (ret[21].substring(0,1) == "Y") {
		                	tempPublic = "Y";
		                } else if (ret[21].substring(0,1) == "B") {
							tempPublic = "B";
						}
			            setPublicFlag();
			            SummaryFlag = true;
			            
			            if (nonElecRec == "Y") {
			                nonElecRecInfoXml = ret[23];
			                nonSepAttachLVXml = ret[24];
			                sepAttachCheckYN = ret[26];
			                setNonElecRecInfo(nonElecRecInfoXml);
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
			        }
			  
			    }
			    
			function btnSaveServer_onclick(AutoSave) {
			    try {
					if (!!checkJobTransferStatus &&
							!checkJobTransferStatus("<c:out value ='${userInfo.id}'/>",
									"<c:out value ='${userInfo.deptID}'/>",
									"<c:out value ='${userInfo.jobId}'/>")) {
						window.close();
						return;
					}
					
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
			
			        //임시저장문서 삭제와 생성을 동시에
// 			        if (ListType == "21" && DraftFlag == "REDRAFT") {
// 			            RemoveTmpDoc(DocSN);
// 			        }
			        
			        if(Saveflag) {
		        		newpDocID = createNewDoc();
		        	}
			
			        var rtnVal = SaveTMPFile();
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
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
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
	                        <li id="btnAddSepAttach"><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSave"><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="btnConn" style="display: none"><span onclick="return btnConn_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="btnSaveServer"><span onclick="return btnSaveServer_onclick()"><spring:message code='ezApprovalG.t4000'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                    </ul>
	                    <ul style="display: none;">
	                    <li id="btnDocInfo"><span><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnSetTaskCode"><span><spring:message code='ezApprovalG.t9994'/></span></li>
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
	                <div style="height: 100%;">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "2", "1", "<c:out value ='${hwpToolbar}'/>", "1");</script>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style="width:30%;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <xml id="SA_coredata"></xml>
	</body>
</html>
