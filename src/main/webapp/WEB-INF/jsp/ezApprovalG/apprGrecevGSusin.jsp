<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t1308'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style>
			.IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
		</style>
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Recvdocnumber_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/recevG_Susin_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CheckLines_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AutoAprLine_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pWriterDeptID;
		    var pDocID = '${docID}';
		    var pFormHref = new String("");
		    var pFormID = new String();
		    var zFormID = new String();
		    var pUserID = "${userInfo.id}";
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
		    var pOrg_orgDocID = '${orgDocID}';
		    var chkOK = false;
		    var isReDraft = '${isReDraft}';
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
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = sCompanyID;
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pLimitRange = "", pPageNum = "1";
		    var cabinetID = "";
		    var TaskCode = "";
		    var DocNumCode = "";
		    var SummaryFlag = true;
		    var pDocTitle = "";
		    var pDocNumCode, pOrgDocNumCode, pDocNo;
		    var maxwidth = 659;
		    var KuyjeType = "002";
		    var signDateFormat = "${optSignDateFormat}";
		    var isSplit = "${optIsSplit}";
		    var SplitKind = "${optSplitKind}";
		    var sihangURL = "${sihangURL}";
		    var g_DraftFlag = "${draftFlag}";
		    var g_RetFlag = "${retFlag}";
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var isExtDoc = "N";
		    var pGubun;
		    var pMailEditor = "${crossEditor}";
		    var pPageType = "SUSIN";
		    var NonActiveX = "YES";
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
		
		                    if (pHasOpinionYN == "Y") {
		                        if (pAprState == "006")
		                            pInformationContent = "<spring:message code='ezApprovalG.t124'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        else
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		
		                        Ans = OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                        return;
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
		
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                            Ans = OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                            return;
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
		                        Ans = OpenInformationUI(pInformationContent, process_AfterOpen_Complete);
		                        return;
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
		        try {
		            getDraftUserInfo();
		            SetAutoPropertyValue();
		
		            var rtnVal = ExcuteInfo("INIT", "");
		            if (!rtnVal) {
		            }
		        } catch (e) {
		            alert("setAutoProperty : " + e.description);
		        }
		    }
		    function FieldsAvailable() {
		        pGubun = "11";
		        CheckSignImg();
		
		        SetReceiptNumber();
		
		        setMenuBar("btnEdit", false);
		
		        setAutoProperty();
		        process_AfterOpen();
		
		        setFirstDrafter();
		        if (SignCount < 1) {
		            pGubun = "12";
		            document.getElementById("btnSetAprLine").style.display = "none";
		            document.getElementById("btnSendDraft").style.display = "none";
		            if (CrossYN())
		                document.getElementById("btnRJunkyul").childNodes[0].textContent = "<spring:message code='ezApprovalG.t1406'/>";
		            else
		                document.getElementById("btnRJunkyul").childNodes[0].innerText = "<spring:message code='ezApprovalG.t1406'/>";
		
		
		            document.getElementById("btnSendAround").style.display = "";
		            document.getElementById("btntotaldocinfo").style.display = "none";
		        }
		        getGongRamDocInfo();
		        var g_SepAttachLVXml = "";
		        g_SepAttachLVXml = message.DocumentBodyGetAttribute("SepAttachLVXml");
		        if (!g_SepAttachLVXml)
		            g_SepAttachLVXml = "";
		        message.DocumentBodySetAttribute("SepAttachLVXml", SetSepAttParamXmlNull(g_SepAttachLVXml));
		
		        SignCheck();
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
		            var RecevState = getDocRecevState();
  
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
		            var rtnSignInfo;
		            var fields = message.GetFieldsList();
		            var field = message.GetListItem(fields, "doctitle");
		
		            if (btnSendDraftEnable == "false") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1408'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {
		                if (!checkLines())
		                    return;
		            }
		
		            try {
		                var pSusinNextSN = 0;
		
		                if (pSusinSN)
		                    pSusinNextSN = parseInt(pSusinSN, 10) + 1;
		                else
		                    pSusinNextSN = 1;
		                
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
		            alert("btnSendDraft_onclick : " + e.description);
		        }
		    }
		
		    function TaskCode_Check() {
		        if (cabinetID == "")
		            btnSetTaskCode_onclick();
		        else {
		            TaskCode_Save();
		        }
		    }
		
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
		
		        if (g_DraftFlag == "REDRAFT")
		            delOpinionInfo();
		
		        pDocTitle = trim(message.GetDocTitle());
		        if (pDocTitle == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1695'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else {
		            if ("${approvalPWD}" != "N") {
		                chk_Passwd();
		            }
		            else {
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
		            try {
		                btnSetAprLine_onclick();
		            }
		            catch (e) { }
		            return;
		        }
		
		        pOrgHtml = message.Get_EditorBodyHTML();
		        if (LastSignSN == 1) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_BEFORE", "");
		
		            if (!rtnVal) {
		                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		
		        if (LastSignSN == 1) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_AFTER", "");
		            if (!rtnVal) {
		                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		
		        if (LastSignSN == 1) {
		            var rtnVal = ExcuteInfo("LAST_SEND_BEFORE", "");
		            if (!rtnVal) {
		                return;
		            }
		        }
		
		        if (SignCount >= 1) {
		            rtnSignInfo = SendDraftMappingSign(ret);
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
		        rtnval = getRecvDocNumber(arr_userinfo[4]);
		        if (!rtnval) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t2101'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        if (LastSignSN != 1) {
		            var rtnVal = ExcuteInfo("LAST_APR_BEFORE", "");
		            if (!rtnVal) {
		                return;
		            }
		        }
		
		        if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
		            var RtnVal;
		            var pAlertContent;
		            RtnVal = setSusinUpdataDocID();
		
		            if (RtnVal == "TRUE") {
		                RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "");
		                if (!RtnVal) {
		                    pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		
		                if (pDraftFlag == "HAPYUI" && LastSignSN == 1) {
		                    var pInformationContent = "<spring:message code='ezApprovalG.t1503'/>";
		                    var Ans = OpenInformationUI(pInformationContent);
		                    if (Ans) RtnVal = HabyuiResultOpinion();
		                }
		
		                if (RtnVal) RtnVal = SaveDraftDocInfo();
		                if (RtnVal == "TRUE") {
		                    RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "");
		                    if (!RtnVal) {
		                        pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
		
		                    if (LastSignSN == 1) {
		                        RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "");
		                        if (!RtnVal) {
		                            pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                            OpenAlertUI(pAlertContent);
		                            return;
		                        }
		
		                        RtnVal = ExcuteInfo("LAST_END_AFTER", "");
		                        if (!RtnVal) {
		                            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                            OpenAlertUI(pAlertContent);
		                            return;
		                        }
		                    }
		                    if (LastSignSN == 1)
		                        pAlertContent = "<spring:message code='ezApprovalG.t1697'/>";
		                    else
		                        pAlertContent = "<spring:message code='ezApprovalG.t1698'/>";
		                    OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
		                    chkOK = true;
		                }
		                else {
		                    UndoSignInfo(rtnSignInfo);
		
		                    if (LastSignSN == 1) {
		                        RtnVal = ExcuteInfo("END_FAIL", "");
		                        if (!RtnVal) {
		                            pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                            OpenAlertUI(pAlertContent);
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
		                    RtnVal = ExcuteInfo("END_FAIL", "");
		                    if (!RtnVal) {
		                        pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
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
		            var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "");
		            var pAlertContent;
		
		            if (!RtnVal) {
		                pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		
		            RtnVal = SaveDraftDocInfo();
		            if (RtnVal == "TRUE") {
		                RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "");
		                if (!RtnVal) {
		                    pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		
		                if (LastSignSN == 1) {
		                    RtnVal = ExcuteInfo("DOCNUM_END", "");
		                    if (!RtnVal) {
		                        pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        return;
		                    }
		                }
		
		                pAlertContent = "<spring:message code='ezApprovalG.t1506'/>";
		                OpenAlertUI(pAlertContent);
		                chkOK = true;
		                window.close();
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		
		                if (LastSignSN == 1) {
		                    RtnVal = ExcuteInfo("END_FAIL", "");
		                    if (!RtnVal) {
		                        pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
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
		        if (chkpass == "False") {
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
		        		dataType : "xml",
		        		async : false,
		        		url : "/ezApprovalG/aprLineRequest.do",
		        		data : {
		        				docID    : pDocID, 
		        				userID 	 : pUserID,
		        				formID   : pFormID
		        				},
		        		success: function(xml){
		        			result = xml;
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
		        var ret = openOpinionUI("N");
		    }
		    function btnSave_onclick() {
		    }
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "ING");
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    window.onbeforeunload = function () {
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
		        } catch (e) { }
		    };
		    var ezreceivedistributeui_cross_dialogArguments = new Array();
		    function btnDistribute_onclick() {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = arr_userinfo[4];
		        parameter[3] = pAprState;
		        parameter[4] = RECEIPTDEPTID.innerText;
		
		        ezreceivedistributeui_cross_dialogArguments[0] = parameter;
		        ezreceivedistributeui_cross_dialogArguments[1] = btnDistribute_onclick_Complete;
		
		        DivPopUpShow(1000, 740, "/ezApprovalG/ezReceiveDistributeUI.do");
		    }
		    function btnDistribute_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "true") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
		        }
		    }
		
		    var ezreceiveassignui_cross_dialogArguments = new Array();
		    function btnAssign_onclick() {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = pAprState;
		
		        ezreceiveassignui_cross_dialogArguments[0] = parameter;
		        ezreceiveassignui_cross_dialogArguments[1] = btnAssign_onclick_Complete;
		
		        DivPopUpShow(460, 375, "/ezApprovalG/ezReceiveAssignUI.do");
		    }
		
		    function btnAssign_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1420'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
		        }
		    }
		
		    var apropinion_cross_dialogArguments = new Array();
		    var temppDocSN;
		    function btnReturn_onclick() {
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
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "HeSong";
		        parameter[2] = KuyjeType;
		        parameter[3] = "";
		
		        if (pDocSN != "")
		            parameter[4] = "Y";
		        else
		            parameter[4] = "N";
		        temppDocSN = pDocSN;
		        apropinion_cross_dialogArguments[0] = parameter;
		        apropinion_cross_dialogArguments[1] = btnReturn_onclick_Complete;
		
		        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
		    }
		    function btnReturn_onclick_Complete(ret) {
		        DivPopUpHidden();
		        var hesongok = true;
		        if (ret != "cancel") {
		            setButtonReceiveTrue();
		
		            if (temppDocSN != "")
		                hesongok = setCabinetHeSong(temppDocSN);
		
		            if (hesongok) {
		                hesongok = setHeSongDocInfo();
		            }
		        }
		    }
		    function btnEdit_onclick() {
		        if (pzFormProc.StartMode == "0") {
		            modeflag = false;
		            chkBtnConfirm("1");
		            beforeHtml = pzFormProc.DocumentHTML;
		
		            pzFormProc.ShowToolbar("1");
		
		            btnEdit.childNodes(0).innerText = "<spring:message code='ezApprovalG.t42'/>";
		
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
		        var RecevState = getDocRecevState();
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
		
		        var Resultxml;
		
		        var UserID = '${userInfo.id}';
		        var DisplayName = '${userInfo.displayName}';
		        var DepID = '${userInfo.deptID}';
		        var DeptName = '${userInfo.deptName}';
		        var Position = '${userInfo.title}';
		        var CompanyID = '${userInfo.companyID}';
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
		        Resultxml = Resultxml + "<COLUMN>" + DisplayName + "</COLUMN>";
		        Resultxml = Resultxml + "<COLUMN>" + Position + "</COLUMN>";
		
		        Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(DeptName) + "</COLUMN>";
		
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
		        Resultxml = Resultxml + "<DATA name='PMemberDeptName'>" + MakeXMLString(arr_userinfo[15]) + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='SMemberDeptName'>" + MakeXMLString(arr_userinfo[16]) + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(arr_userinfo[13]) + "</DATA>";
		        Resultxml = Resultxml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(arr_userinfo[14]) + "</DATA>";
		
		        Resultxml = Resultxml + "</ROW></ROWS></LISTVIEWDATA>";
		
		        xmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
		        xmlhttp.send(Resultxml);
		
		        if (getNodeText(GetChildNodes(xmlhttp.responseXML)[0])) {
		            var retvalue = new Array();
		            retvalue[0] = Resultxml;
		            retvalue[1] = "NONE";
		            retvalue[2] = "R";
		            retvalue[3] = "";
		
		            GetDraftAprLineInfo(retvalue);
		            btnSendDraftEnable = "true";
		            CurAprType = "<spring:message code='ezApprovalG.t25'/>";
		            LastSignSN = "1";
		            btnSendDraft_onclick();
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1423'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btnMail_onclick() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pFormHref);
// 				var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(pFormHref) + "&cmd=docsend&docID=" + pDocID + "&imageCnt=&target=APPROVALG";					
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
		        var feature = "status:no;dialogWidth:430px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
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
		    function SetDocOption(tempSecurityValue) {
		        var fields = message.GetFieldsList();
		
		        field = message.GetListItem(fields, "keepperiod");
		        if (field)
		            field.textContent = tempKeep;
		
		        field = message.GetListItem(fields, "securitylevel");
		        if (field)
		            field.textContent = tempSecurityValue;
		
		        field = message.GetListItem(fields, "publication");
		        if (field) {
		            if (tempPublic == "N")
		                field.textContent = "<spring:message code='ezApprovalG.t46'/>";
		            else
		                field.textContent = "<spring:message code='ezApprovalG.t47'/>";
		        }
		    }
		    function btnSendAround_onclick() {
		        var para = new Array();
		        para[0] = pDocID;
		
		        var url = "AprGongRamLine_Cross.aspx";
		        var feature = "dialogWidth:557px;dialogHeight:530px;scroll:no;resizable:yes;status:no;help:no;edge:sunken";
		        feature = feature + GetShowModalPosition(557, 530);
		        var rtn = window.showModalDialog(url, para, feature);
		        if (rtn == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1424'/>";
		            OpenAlertUI(pAlertContent);
		            JiJungBeBuDisable();
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
		        		dataType : "xml",
		        		async : false,
		        		url : "/ezApprovalG/gongRamDocInfo.do",
		        		data : {
		        			docID : pDocID
		        		},
		        		success: function(xml){
		        			result = xml;
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
		        	
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/getDocState.do",
		        		data : {
		        			docID : pDocID,
		        			deptID: arr_userinfo[4]
		        		},
		        		success: function(text){
		        			result = text;
		        		}
		        	});
		        	
		            return result;
		        }
		        catch (e) {
		            alert("getDocRecevState :: " + e.description);
		        }
		    }
		    var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo() {
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
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		
		        ezapprovalinfo_dialogArguments[0] = parameter;
		        ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
		
		        var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun, "ezApprovalInfo", GetOpenWindowfeature(1000, 750));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function btnApprovalInfo_Complete(ret) {
		        if (ret != undefined && ret[0] == "OK") {
		            try {
		                var savexmlhttp = createXMLHttpRequest();
		
		                if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {
		                    if (ret[1] != false) {
		                        savexmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
		                        savexmlhttp.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		                        savexmlhttp.send(ret[1]);
		
		                        var dataNodes = GetChildNodes(savexmlhttp.responseXML);
		                    }
		
		                }
		                if (ret[1] != false) {
		                    IsSkipDrafter = "FALSE";
		                    btnSendDraftEnable = "true";
		                    GetDraftAprLineInfo(ret);
		                }
		                savexmlhttp = null;
		                savexmlhttp = createXMLHttpRequest();
		
		                if (pGubun != "11" && pGubun != "12") {
		                    savexmlhttp.open("Post", "/ezApprovalG/aprDeptSave.do", false);
		                    savexmlhttp.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		                    savexmlhttp.send(ret[2]);
		
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
		
		                tempSecurity = ret[7];
		                tempUrgent = ret[8];
		                pSummery = ret[9];
		                pSpecialRecordCode = ret[10];
		                pPublicityCode = ret[11];
		                pLimitRange = ret[12];
		                pPageNum = ret[13];
		                tempSecurityDate = ret[14];
		                SummaryFlag = true;
		
		                savexmlhttp = null;
		
		            }
		            catch (e) {
		                alert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        }
		    }
		</script>
	</head>
	<body class="popup" style="height:100%;">
		<table class="layout">
		  <tr>
		    <td style="height:20px;">
			<div id="menu">
			<ul>
		    <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>        
			<span style ="display:none" ><li id="btnSetAprLine"><span onClick="return btnSetAprLine_onclick()"><spring:message code='ezApprovalG.t153'/></span></li></span>
			<span style ="display:none" ><li id="btnSetReceivLine" style="display:none"><span  onClick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t154'/></span></li></span>
			<li id="btnSendDraft"><span onClick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
			<li id="btnRJunkyul" ><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li>
			<span style ="display:none" ><li id="btnSendAround" style="display:none"><span  onClick="return btnSendAround_onclick()" ><spring:message code='ezApprovalG.t1428'/></span></li></span>
			<span style ="display:none" ><li id="btnSetTaskCode"><span onClick="btnSetTaskCode_onclick()"  ><spring:message code='ezApprovalG.t51'/></span></li></span>
			<span style ="display:none" ><li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li></span>
			<li id="btnOpinion"><span onClick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
			<li id="btnFileAttach"style="display:none" ><span onClick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
			<li id="btnAprDocAttach" style="display:none"><span  onClick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t1429'/></span></li>
			<li id="btnAddSepAttach"><span  onClick="btnAddSepAttach_onclick()"  ><spring:message code='ezApprovalG.t58'/></span></li>
			<li id="btnAssign" ><span  onClick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t1430'/></span></li>
			<li id="btnDistribute"><span  onClick="return btnDistribute_onclick()"><spring:message code='ezApprovalG.t1432'/></span></li>
			<li id="btnReturn"><span  onClick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
			<li id="btnEdit"><span  onClick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
			<li id="btnPrint"><span  onClick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
			<li id="btnMail"><span  onClick="return btnMail_onclick()"><spring:message code='ezApprovalG.t1513'/></span></li>
			</ul>
			</div>
			<div id="close">
		        <ul>
		          <li id="btnClose" ><span onClick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
		        </ul>
		      </div>
		</td>
		  </tr>
		  <tr>
		    <td style="padding-bottom:10px;height:100%;">
		        <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="recevEndContent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		    </td>
		  </tr>
		   <tr>
		    <td style="height:20px;"><table class="file">
		        <tr>
		          <th id="btn_Attach" ><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
		  </tr>
		</table>
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<XML ID="ATTACHINFO"></XML>
		<XML ID="DOCINFO"></XML>
		<XML ID="OPTIONINFO"></XML>
		<XML ID="APRLINEINFO"></XML>
		<XML ID="PREVNEXTDOCINFO"></XML>
		<XML ID="CONNINFO"></XML>
		<DIV ID="RECEIPTDEPTID" style="display:none"></DIV>
		<div id="AprMemberSN" style="display:none"></div>
	</body>
</html>