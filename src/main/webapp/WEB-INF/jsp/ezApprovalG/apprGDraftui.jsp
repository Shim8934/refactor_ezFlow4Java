<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:97%">
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
		<script type="text/javascript" src="/js/ezApprovalG/signSplit_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/docnumberG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AutoAprLine_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CheckLines_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendMailApprove.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Circulation.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var FormHref	=	"${formURL}";
		    var DraftFlag	=	"${draftFlag}";
		    var DocType		=	"${formDocType}";
		    var SusinSN		=	"${susinSN}";
		    var DocState	=	"${docState}";
		    var ListType	=	"${listType}";
		    var AprState    =   "${aprState}";
		    var pEndDocHref	=   "${dirPath}";
		    var pFormHref = new String("");
		    var pFormID = new String();
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
		    var isTmpDocID = "${isTmpDoc}";
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
		    var approvalFlag = "${approvalFlag}";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[7] = "N";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var pCompanyID = "${userInfo.companyID}";
		    var pUserID = arr_userinfo[1];
		    var KuyjeType = "002";
		    var signDateFormat = "${optSignDateFormat}";
		    var isSplit = "${optisSplit}";
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
		    var HapyuiArea = 0;
		    var AprLineArea = 0;
		    var CheckGubun = "1";
		    var DocSN = "${docSN}";
		    var AutoSave = "save";//자동임시저장
		    var Saveflag = false;//임시저장Flag
		    var pPageType = "DRAFTUI";
		    var pUse_Editor = "${useEditor}";
		    var hideCabinet = "${hideCabinet}";
		    /* 2015-06-30 표준모듈:추가(외부수신자요약) - KSK */
		    var SummaryOuterReceiverList = "";
		    var hideCabinet = "${hideCabinet}";
		    var checkdocinfo = false;
		    //var DocType = ""; // 이미 위에 선언되어있음
		    var junGyulFlag = "${junGyulFlag}";
		    var draftJunGyulFlag = "${draftJunGyulFlag}";
		    var pSignImage_Size = "${signImageSize}";
		    var docNumZeroCnt = "${docNumZeroCnt}";
			var beforeUrl = "${beforeUrl}";
			//회람
			var type = "ING";
			var pGongRamDocID = "";
			var singImageType = "${signImageType}";
			var isUsed = "${isUsed}";
			var beforeDocID = "${beforeDocID}";
			var addLastKyulJeYN = "${addLastKyulJeYN}";
			var totalMemSN = "0";
			var reuseTitleYN = "${reuseTitleYN}";
			var agreeResultType = "${agreeResultType}";
			var curDocNum = "";
			var isEditorComplete = false;
			var orgCompanyID = "${userInfo.companyID}";
		    window.onload = function ()
		    {
		        try {
		            pSusinSN = SusinSN;
		            setMenuBar("btnSendDraft", true);
		            dragNdrapNo();	
		        } catch(e){
		            alert(e.description + ": window_onload");
		        }
		        
		        if(approvalFlag == "G") {
		        	$("#btnAddSepAttach").css("display","");
	        	}
		    };
		    function dragNdrapNo()
		    {
		        try{
		            var div = document.getElementById('lstAttachLink');
		            div.ondragenter = div.ondragover = function (e) 
		            {
		                return false;
		            }
		            div.ondrop = function (e) {
		                alert("<spring:message code='ezApprovalG.pjj30'/>");
		                return false;
		            }
		        }
		        catch(e)
		        {
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
		            /*
		            * 재기안인 경우
		            * 1. 임시보관함에서는 기존에 저장된 내용이 있어서 수신처 값을 초기화하지 않는다.
		            * 2. 반송된 문서를 재기안할 때는 고정수신처 값을 불러온다.
		            */
		            if (pDraftFlag == "REDRAFT") {
		            	if (ListType == "21") {
		            		//임시보관함일경우 사인 초기화??
		            		setFirstDrafter(isUsed, "");
		            	} else {
		            		getFormRecv();	
		            	}
		            	
		                //getFormRecv();
		                message.SetEditable(true);
		            }
		
		            if (pDraftFlag != "REDRAFT")
		                setFirstDrafter(isUsed, beforeDocID);
		            
		            if (approvalFlag == "S") {
			            SetAutoDocnumItem();
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
		
		    function Conn_Initial() {
		        if (ConnExist("INIT", "")) {
		            setMenuBar("btnHelper", true);
		        }
		        else {
		            setMenuBar("btnHelper", false);
		        }
		
		        var rtnVal = ExcuteInfo("INIT", "");
		        if (!rtnVal) {
		            if (OpenInformationUI("<spring:message code='ezApprovalG.t87'/>")) {
		                    btnClose_onclick();
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
		        var rtnVal = ExcuteInfo("INIT", "");
		        if (!rtnVal) {
		        }
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
		                    
		                    if (pHasOpinionYN == "Y") {
		                        if (AprState == "<spring:message code='ezApprovalG.t49'/>")
		                            pInformationContent = "<spring:message code='ezApprovalG.t124'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        else
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		
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
		                        
		                     	if (isUsed == "reuse") {
			                		getDocInfo();
			                	}
		                    }
		                }
		            }
		        } catch (e) {
		            alert("process_AfterOpen : " + e.description);
		        }
		    }
		
		    function process_AfterOpen_Complete(Ans) {
		        DivPopUpHidden();
		        if (Ans) {
		            openOpinionUI("Display");
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
		            alert("btnSetAprLine_onclick : " + e.description);
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
		            alert("btnSetReceivLine_onclick : " + e.description);
		        }
		    }
		    function btnSendDraft_onclick() {
		        try {
		        	
		        	if (isEditorComplete == true) {
		        	
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
			            var rtnSignInfo;
			            var fields = message.GetFieldsList();
			            pDocTitle = trim_Cross(message.GetDocTitle());
			            if (pDocTitle == "") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t131'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			            if (pDocTitle.length > 127) {
			                var pAlertContent = "<spring:message code='ezApprovalG.t132'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			            
			            if (hideCabinet == "0") {
				            if (approvalFlag == "G") {
					            if (cabinetID == "") {
					                var pAlertContent = "<spring:message code='ezApprovalG.t134'/>";
					                OpenAlertUI(pAlertContent, check_btnSendDraft);
					                return;
					            }
					            
					            if (cabinetID.substring(0, arr_userinfo[4].length).toLowerCase() != arr_userinfo[4].toLowerCase()) {
					                var pAlertContent = "<spring:message code='ezApprovalG.t135'/>" + "<br>" + "<spring:message code='ezApprovalG.t136'/>";
					                OpenAlertUI(pAlertContent);
					                return;
					            }
				            } else {
					            if (cabinetID == "") {
					                var pAlertContent = "<spring:message code='ezApprovalG.t137'/>";
					                OpenAlertUI(pAlertContent, check_btnSendDraft);
					                return;
					            }
				            }
			            } else {
				            if (cabinetID == "") {
				            	//하드코딩 방산끝나면 삭제 ㄱㄱ
				            	cabinetID = "devteamZZ3782312017000002001";
				            	TaskCode = "ZZ378231";
				            }
			            }
			            
			            if (btnSendDraftEnable == "false") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t139'/>" + "<br>" + "<spring:message code='ezApprovalG.t140'/>";
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
			            if (pDocType == "003" && pSuSinFlag == "Y" && !btnReceivLineEnable) {
					        var fields = message.GetFieldsList();
					        
							if (getNodeText(message.GetListItem(fields, "recipient")) == "") {
				                var pAlertContent = "<spring:message code='ezApprovalG.t141'/>" + "<br>" + "<spring:message code='ezApprovalG.t142'/>";
				                OpenInformationUI(pAlertContent, check_btnSendDraft3);
				                return;								
							} 

			            }
			            
			            if (isUsed ==  "reuse") {
			            	var pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
			            	OpenInformationUI(pAlertContent, check_ReUsed);	
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
			            
			            setDrafterAddress();
			            if (pDraftFlag == "REDRAFT")
			                delOpinionInfo();
			            if (LastSignSN == 1 || DraftLastFlag) {
			                var pInformationContent = "<spring:message code='ezApprovalG.t143'/>" + "<br>" + "<spring:message code='ezApprovalG.t144'/>";
			                OpenInformationUI(pInformationContent, check_btnSendDraft4);
			            }
			            else
			                CheckPassWord();
		        		
		        	} else {
		        		OpenAlertUI("<spring:message code='ezApprovalG.pjg02'/>");
		        	}		            
		        } catch (e) {
		            alert("btnSendDraft_onclick()" + e.description);
		        }
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
		            if (IsSkipDrafter == "FALSE") {
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
		
		        if (IsSkipDrafter == "FALSE") {
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
		                RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "");
		                if (!RtnVal) {
		                    pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		                if (RtnVal) RtnVal = SaveDraftDocInfo();
		                if (RtnVal == "TRUE") {
		                    RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "");
		                    if (!RtnVal) {
		                        pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
		                    if (LastSignSN == 1 || DraftLastFlag) {
		                        RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "");
		                        if (!RtnVal) {
		                            pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                            OpenAlertUI(pAlertContent);
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
		                        RtnVal = ExcuteInfo("END_FAIL", "");
		                        if (!RtnVal) {
		                            pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                            OpenAlertUI(pAlertContent);
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
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("END_FAIL", "");
		
		                    if (!RtnVal) {
		                        pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
		                }
		                SetBtnStateTrue();
		                btnSendDraftEnable = "true";
		                pAlertContent = "<spring:message code='ezApprovalG.t147'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        else {
		            var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "");
		            var pAlertContent;
		            if (!RtnVal) {
		                pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		
		            if (LastSignSN == 1 || DraftLastFlag)
		                SetAutoPropFinal();
		
		            if (LastSignSN == 1 || DraftLastFlag) {
		                message.DocumentBodySetAttribute("SA_LastUserID", pUserID);
		                message.DocumentBodySetAttribute("SA_ProcUserID", pUserID);
		                var rtnVal = ExcuteInfo("LAST_SEND_BEFORE", "");
		                if (!rtnVal) {
		                    return;
		                }
		            }
		            RtnVal = SaveDraftDocInfo();
		
		            if (RtnVal == "TRUE") {
		                RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "");
		                if (!RtnVal) {
		                    pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("DOCNUM_END", "");
		
		                    if (!RtnVal) {
		                        pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
		                    Gyuljedate = GetDocInfoData("END", "STARTDATE");
		                  
		                    SendMailToReceiveDept(pDocTitle, arr_userinfo[2], Gyuljedate, pDocID);
		                } else {
		                	Gyuljedate = GetDocInfoData("APR", "STARTDATE");
	                        CurrentAprType = "001";
	                        CurrentAprUserID = pUserID;
	                        sendAlertMail("APR", 1, "DRAFT");
		                }
		                UpdateLineHistory();
		                if (LastSignSN == 1) {
		                    SendAckForExch("approval", "END");
		                }
		                else {
		                    SendAckForExch("submit", "ING");
		                }
		
		                pAlertContent = "<spring:message code='ezApprovalG.t146'/>";
		                OpenAlertUI(pAlertContent, Complete_Deaft2);
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		                if (LastSignSN == 1)
		                    rollbackDocNumber(arr_userinfo[4], "", pDocID);
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("END_FAIL", "");
		
		                    if (!RtnVal) {
		                        pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
		                }
		                SetBtnStateTrue();
		                pAlertContent = "<spring:message code='ezApprovalG.t147'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		    }
		
		    function Complete_Deaft() {
		        draftFlag = true;
		        window.close();
		    }
		
		    function Complete_Deaft2() {
		        draftFlag = true;
		        if (ListType == "21") {
		            RemoveTmpDoc(DocSN);
		        }
		        window.close();
		    }
		
		    function openSignUI_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
		            OpenAlertUI(pAlertContent);
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
		            rtnVal = ExcuteInfo("DOCNUM_BEFORE", "");
		            if (!rtnVal) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        
		        var rtnval;
		        if ((LastSignSN == 1 && totalMemSN == 0)|| DraftLastFlag)
		            rtnval = getDocNumber(arr_userinfo[4], "", docNumZeroCnt);
		        else
		            rtnval = getDocNumber(arr_userinfo[4], "be", docNumZeroCnt);
		
		        if (!rtnval) {
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        if (LastSignSN == 1 || DraftLastFlag) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_AFTER", "");
		            if (!rtnVal) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }

		        rtnSignInfo = SendDraftMappingSign(ret);

		        saveDraftInfo();
		    }
		
		    function check_btnSendDraft() {
		        DivPopUpHidden();
		        btnApprovalInfo(3);
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
		            alert("btnFileAttach_onclick : " + e.description);
		        }
		    }
		    function btnAprDocAttach_onclick() {
		        var ret = openAaprDocAttachUI();
		    }
		    function btnOpinion_onclick() {
		        var ret = openOpinionUI("N");
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
		        PrintClick("Cross", pDocID, "ING");
		    }
		    function btnClose_onclick() {
		        bAttachProcess = false;
		        OpenInformationUI("<spring:message code='ezApprovalG.t148'/>" + "<br>" + "<spring:message code='ezApprovalG.t149'/>", btnClose_onclick_Complete);
		            //window.close();
		    }
		
		    function btnClose_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn)
		            window.close();
		    }
		    function window_onbeforeunload() {
		        if (bAttachProcess == false) {
		            if (!draftFlag) {
		                UndoDoc();
		            }
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
		    function btnConn_onclick() {
		        var pIdx = FormProc.editor.DOM.body.getAttribute("processkey");
		        if (pIdx)
		            rtnVal = ExcuteInfo(pIdx, "");
		    }
		    function btn_Attach_onclick() {
		        btnFileAttach_onclick();
		    }
		    function btnMail_onclick() {
		        window.open("/myoffice/ezEmail/newmail.aspx?cmd=docsend&DocID=" + pDocID + "&DocHref=" + pFormHref, '', 'height=700,width=690,resizable=yes,scrollbars=no');
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
		        var PublicType2 = pPublicityCode2;
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
		        
		        if (PublicType2 == "1")
		            PublicText = "<spring:message code='ezApprovalG.t47'/>";
		        else if (PublicType2 == "2")
		            PublicText = "<spring:message code='ezApprovalG.t150'/>";
		        else
		            PublicText = " ";
		        field.innerHTML = PublicText;
		    }
			
		    /*기존의 공개여부 함수 2018-04-04 김은석 수정*/
		    function setPublicFlag2() {
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "publication");
		        if (!field) return;
		        var PublicType = pPublicityYN.substring(0, 1);

		        var PublicText = "";
		        if (PublicType == "Y")
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
		            alert("btnSetTaskCode_onclick : " + e.description);
		        }
		    }
		    var inssepattach_cross_dialogArguments = new Array();
		    function btnAddSepAttach_onclick() {
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
		
		        var url = "/ezApprovalG/insSepAttach.do";
		        inssepattach_cross_dialogArguments[0] = para;
		        inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;
		
		        DivPopUpShow(730, 630, url);
		    }
		
		    function btnAddSepAttach_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            g_SepAttachLVXml = rtn[1];
		            message.DocumentBodySetAttribute("SepAttachLVXml", g_SepAttachLVXml);
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
		                DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
		                drafterDeptid = arr_userinfo[4];
		                getDraftInfo();
		                if (pFormHref != "") {
		                    if (pFormHref == "PC") {
		                        pReadPC = true;
		                    } else {
		                        message.Set_EditorContentURL(pFormHref);
		                    }
		                    
		                    if (beforeUrl != "") {
	                            Insert_ReUse_Content();
	                        }
		                }
		                else {
		                    DraftFlag = "DRAFT";
		                    pDraftFlag = "DRAFT";
		                    message.Set_EditorContentURL(sihangURL);
		                }
		            }
		        }
		        catch (e) {
		            OpenAlertUI("DocumentComplete : " + e.description);
		        }
		    }
		
		    var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo(pGubun) {
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
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		
		        ezapprovalinfo_dialogArguments[0] = parameter;
		        ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
		        
				if(DraftFlag == "REDRAFT" && SusinSN == "1" && DocState == "011" && AprState == "004") {
					pGubun = "11";
				}
		        var OpenUrl = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun ;
		        if (ListType == "21") {
		            OpenUrl += "&docSN=" + DocSN;
				}
		        if (isUsed == "reuse") {
		        	OpenUrl +=  "&isUsed=" + isUsed + "&beforeDocID=" +beforeDocID
		        }
		        var OpenWin = window.open(OpenUrl , "ezApprovalInfo", GetOpenWindowfeature(1144, 750));
		        
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    function btnApprovalInfo_Complete(ret) {
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
		                    
		                    if (approvalFlag == "S") {
			                    SGetDraftAprLineInfo(ret);
		                    } else {
			                    GetDraftAprLineInfo(ret);
		                    }
		                    
		                    IsSkipDrafter = "FALSE";
		                }    
		                
		                if (pSuSinFlag == "Y" && typeof (ret[2]) == "string" && pDocType != "002") {
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
		                    DeleteDeptInfo();
		                    setRecevInfo("");
		                }
		                
		                if (ret[4] != undefined) {
			                var g_SelCabXml = ret[4];
			                var xmlCab = createXmlDom();
			                xmlCab = loadXMLString(g_SelCabXml);
			                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		                }
		
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
			                }
// 			                setPublicFlag();
			                setPublicFlag2();
		                } else {
		                	//회람
		                	if (ret[22] == "noItem") {
		                		delAprLineInfoCC();
		                		//없으니깐 암것도 안해도되려나 싶은데 기존꺼를 뺏을수도 있으니까 무조건 삭제
		                	} else if (ret[22] == "sameItem") {
		                		//같으니깐 암것도 안해도 되려나
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
		                
		                SummaryFlag = true;
		                isUsed = ""; // 재사용 여부 초기화
		
		            }
		            catch (e) {
		                alert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        }
		    }
		
		    function btnSaveServer_onclick(AutoSave) //(한양대 20111117)
		    {
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
			                OpenAlertUI(pAlertContent, check_btnSendDraft);
			                return;
			            }
		            }
		        }        
		        if (DraftFlag == "REDRAFT" && ListType == "21") {
					RemoveTmpDoc(DocSN);
		        }
		
		        var rtnVal = SaveTMPFile(AutoSave);
		        if (rtnVal == "TRUE") {
		            rtnVal = SaveTMPDocInfo(AutoSave);
		
		            if (rtnVal.indexOf("TRUE") > -1) {
		                savetempflag = false; //닫기시 임시저장 로직 타지 않음 (바로 닫힘) - noonpark
		                
		                if (ListType == "1") {
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
		                }
		                
		                var pAlertContent = "<spring:message code='ezApprovalG.t1581'/>";
		                OpenAlertUI(pAlertContent, btnSaveServer_onclick_Complete);
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
		        window.close();
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
	            var reUseContent = "";

	            for (var i = 0; i < TDRows.length; i++) {
	                if (GetAttribute(TDRows.item(i), "id") == "body") {
	                    reUseContent = TDRows.item(i).innerHTML;
	                    break;
	                }
	            }
	            message.Editor_ReUseContent(reUseContent);
	        }
		</script>
	</head>
	<body class="popup" onbeforeunload="return window_onbeforeunload()" style="height:100%;">
			<input type="hidden" id="regNum1" value="">
		<table  class="layout" ID="Table1">
		  <tr>
		    <td style="height:20px;">
		        <div id="menu">
		            <ul>
		                <li id="btnSelForm"><span  onClick="return btnSelForm_onclick()"><spring:message code='ezApprovalG.t152'/></span></li>
		                <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo('1')" ><spring:message code='ezApprovalG.t1742'/></span></li>        
		                <span style="display:none"><li id="btnSetAprLine"><span  onClick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li></span>
		                <span style="display:none"><li id="btnSetReceivLine"><span  onClick="return btnSetReceivLine_onclick()" ><spring:message code='ezApprovalG.t154'/></span></li></span>
		                <span style="display:none"><li id="btnSetTaskCode"><span  onClick="btnSetTaskCode_onclick()" ><spring:message code='ezApprovalG.t9994'/></span></li></span>
		                <li id="btnReturn" style="display:none"><span  onClick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t155'/></span></li>
		                <li id="btnSendDraft"><span  onClick="return btnSendDraft_onclick()"  ><spring:message code='ezApprovalG.t156'/></span></li>
		                <span style="display:none"><li id="btnDocInfo"><span  onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li></span>
		                <li id="btnOpinion"><span  onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
		                <li id="btnFileAttach"><span  onClick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
		                <li id="btnAprDocAttach"><span  onClick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
		                <li id="btnAddSepAttach" style="display:none"><span  onClick="btnAddSepAttach_onclick()" ><spring:message code='ezApprovalG.t58'/></span></li>
		                <li id="btnSave" style="display:none"><span  onClick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
		                <li id="btnConn" style="display:none"><span  onClick="return btnConn_onclick()"  ><spring:message code='ezApprovalG.t157'/></span></li>
		                <li id="btnPrint"><span  onClick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
		                <li id="btnhistory"><span  onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
		                <li id="btnHelper" style="display:none"><span  onClick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t158'/></span></li>
		                <li id="btnSaveServer" <c:if test ="${approvalFlag == 'S'}">style="display:none"</c:if>><span onClick="return btnSaveServer_onclick()" ><spring:message code='ezApprovalG.t4000'/></span></li>
		            </ul>
		        </div>        
		      <div id="close">
		        <ul>
		          <li><span id="btnClose" onClick="return btnClose_onclick()" ></span></li>
		        </ul>
		      </div></td>
		  </tr>
		  <tr>
		    <td  style="padding-bottom:10px;height:90%;" >
		      <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/draftContent.do?isUsed=${isUsed}" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		      </td>
		  </tr>
		  <tr>
		    <td height="20"><table class="file" ID="Table2">
		        <tr>
		          <th id="btn_Attach" ><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
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
	</body>
</html>