<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t1'/></title>
		<meta http-equiv="Content-Type" content="text/html;" charset="utf-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/signSplit_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/docnumberG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ApprovUI_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendMailApprove.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/html2canvas.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">                                                                                        
		    var OrgAprUserID		= '${uID}';
		    var OrgAprUserName		= '${name}';
		    var OrgAprUserName2		= '';
		    var OrgAprUserDeptID	= '${deptID}';
		    var pEndDocHref			= '${dirPath}';
		    var pDocID = '${docID}';
		    var pingUserID = "${tempUserID}";
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
		    var RootURL = document.location.protocol + "//" + document.location.hostname;  
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[7]  = "N";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    var pCompanyID = "${userInfo.companyID}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var KuyjeType = "002";
		    var signDateFormat = "${optSignDateFormat}";
		    var isSplit = "${optIsSplit}";
		    var SplitKind = "${optSplitKind}";
		    var junKyukInfo = "${optjunKyukInfo}";
		    var FirstHtml = "";
		    var beforeHtml;
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pLimitRange = "", pPageNum = "";
		    var cabinetID = "";
		    var TaskCode = "";
		    var DocNumCode = "";
		    var allFlag = "${allFlag}";
		    var selectedDocID = "";
		    var OpinionAction = "";
		    var CurrYear = "${oldYear}";  
		    var StartMode = "0";
		    var mhtData;
		    var pGubun;
		    var isExtDoc;
		    var pMailEditor = "${crossEditor}";
		    var pPageType = "APPROVUI";
		    var NonActiveX = "YES";
		    
		    window.onload = function () {
		        if (allFlag == "2") {
		            selectedDocID = window.opener.selectedDocIDS;
		        }
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
		    function OpenAllApproveFlag_Complete(RtnVal) {
		        DivPopUpHidden();
		        AllApprove.style.display = "";
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
		        if (allFlag == "1")
		            getNextDocInfo();
		        else if (allFlag == "2")
		            getNextDocList();
		
		        if (NextDocID == "")
		        {
		            if (tempString == "")
		                var pAlertContent = "<spring:message code='ezApprovalG.t3'/>";
		            else
		            {
		                tempString = tempString.replace("\n" + "<spring:message code='ezApprovalG.t2'/>", "");
		                tempString = tempString.replace("\n\n" + "<spring:message code='ezApprovalG.t4'/>", "");
		                tempString = tempString.replace("\n", "");
		                var pAlertContent = tempString + "<br>" + "<spring:message code='ezApprovalG.t3'/>";
		            }
		            OpenAlertUI(pAlertContent);
		            window.parent.close();
		            btnClose_onclick();
		        }
		        else
		        {
		            if(NextDocExtended.substring(NextDocExtended.lastIndexOf(".")+1) != "mht")
		            {
		                openOtherApprovUI();
		                return;
		            }
		            DocNumCode = "";
		            pDocID = NextDocID;
		            OrgAprUserID = NextDocUserID;
		            OrgAprUserName = NextDocUserName;
		            OrgAprUserName2 = NextDocUserName2;
		            OrgAprUserDeptID = NextDocDeptID;
		            pEndDocHref = "/files/upload_approvalG/" + pCompanyID + "/doc/"+CurrYear+"/" + (pDocID % 1000) + "/" + pDocID + ".mht";
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
		    function openOtherApprovUI()
		    {
		        var pArgument = new Array();
		        pArgument[0] = NextDocID;
		        pArgument[1] = NextDocUserID;
		        pArgument[2] = NextDocUserName;
		        pArgument[4] = NextDocUserName2;
		        pArgument[3] = NextDocDeptID;
		        var formURL = NextDocHref;
		        if (NextDocExtended.toLowerCase() == "doc")
		        {
		            var openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID="+escape(pArgument[0]);
		            openLocation = openLocation + "&uID="+escape(pArgument[1])+"&uName="+escape(pArgument[2]) + "&uName2="+escape(pArgument[4]);
		            openLocation = openLocation + "&uDeptID="+escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		        }
		        else if (NextDocExtended.toLowerCase() == "hwp")
		        {
		            var openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezAproveUI_HWP_Cross.aspx?DocID="+escape(pArgument[0]);
		            openLocation = openLocation + "&uID="+escape(pArgument[1])+"&uName="+escape(pArgument[2]) + "&uName2="+escape(pArgument[4]);
		            openLocation = openLocation + "&uDeptID="+escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		        }
		        else
		        {
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
		            if (pDocHref != "")
		            {
		                message.Set_EditorContentURL(pDocHref);
		            }
		        }
		    }
		    var noFieldsAvailable = false;
		    function FieldsAvailable()
		    {
		        var fields = message.GetFieldsList();
		        if (modeflag)
		        {
		            CheckSignImg();			
		            if (noFieldsAvailable)
		            {
		                noFieldsAvailable = false;
		            }
		            else
		            {
		                var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT","");
		                if(!rtnVal)
		                {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t8'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;				
		                }		
		                process_AfterOpen();
		                CheckOpinionYN();
		            }
		        }
		        message.SetEditable(false);
		    }
		    function CheckOpinionYN()
		    {
		        if (pHasOpinionYN == "Y") {
		            var pInformationContent = "<spring:message code='ezApprovalG.t9'/>" + "<br>" + "<spring:message code='ezApprovalG.t10'/>";
		            OpenInformationUI(pInformationContent, CheckOpinionYN_Complete);
		        }
		        else {
		            if (pDraftFlag == "SUSIN")
		                getSusinSNInfo();
		            else
		                pSusinSN = "0";
		
		            if (message.DocumentBodyGetAttribute(("KP_YGubun"))) {
		                setMenuBar("btnConn", true);
		                btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		            }
		            else
		                setMenuBar("btnConn", false);
		
		            AllApprove.style.display = "";
		            if (allFlag == "1" || allFlag == "2") {
		                OpenAllApproveFlag();
		            }
		        }
		    }
		    function CheckOpinionYN_Complete(Ans) {
		        DivPopUpHidden();
		        if (Ans)
		            openOpinionUI("Display", CheckOpinionYN_Complete_Complete);
		        else {
		            if (pDraftFlag == "SUSIN")
		                getSusinSNInfo();
		            else
		                pSusinSN = "0";
		
		            if (message.DocumentBodyGetAttribute(("KP_YGubun"))) {
		                setMenuBar("btnConn", true);
		                btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		        }
		        else
		            setMenuBar("btnConn", false);
		
		        AllApprove.style.display = "";
		        if (allFlag == "1" || allFlag == "2") {
		            OpenAllApproveFlag();
		        }
		        }
		    }
		
		    function CheckOpinionYN_Complete_Complete() {
		        DivPopUpHidden();
		        if (pDraftFlag == "SUSIN")
		            getSusinSNInfo();
		        else
		            pSusinSN = "0";
		
		        if (message.DocumentBodyGetAttribute(("KP_YGubun"))) {
		            setMenuBar("btnConn", true);
		            btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		        }
		        else
		            setMenuBar("btnConn", false);
		
		        AllApprove.style.display = "";
		        if (allFlag == "1" || allFlag == "2") {
		            OpenAllApproveFlag();
		        }
		    }
		
		    function process_AfterApprove(mode)
		    {
		        if (FirstHtml != "")
		            UpdateDocHistory(FirstHtml);
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
		        getCurApproverAprLine();
		        pGubun = "8";
		        if(pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12)
		        {
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
		        }
		        else if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            setMenuBar("btnModAprLine", false);
		            pGubun = "5";
		        }
		        if (KuyjeType == "001") {
		            if (pDraftFlag == "SUSIN" || pAprLineType == strAprType7 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
		                setMenuBar("btnReject", false);
		                setMenuBar("btnStay", false);
		                setMenuBar("btnModAprLine", false);
		                setMenuBar("btnModAprDept", false);
		                pGubun = "7";
		            }
		        }
		        if(pDraftFlag == "SUSIN")
		        {
		            var fields = message.GetFieldsList();
		            var field = message.GetListItem(fields, "susinbody");
		            if(field)
		                setMenuBar("btnEdit", true);
		            else
		                setMenuBar("btnEdit", false);
		
		            setMenuBar("btnModAprDept", false);
		            setMenuBar("btnFileAttach", false);
		            setMenuBar("btnAprDocAttach", false);
		            pGubun = "6";
		        }
		        else
		        {
		            pSuSinFlag = "N";		
		            var fields = message.GetFieldsList(); 
		            var RtnVal = message.GetListItem(fields, "recipient");
		            if(RtnVal != null)
		            { 
		                pSuSinFlag = "Y";
		                setMenuBar("btnModAprDept", true);
		                
		            }else{
		                pSuSinFlag = "N";
		                setMenuBar("btnModAprDept", false);
		                if (pGubun == "5") {
		                    pGubun = "7";
		                }
		                else {
		                    pGubun = "6";
		                }
		            }		
		        }
		        SignCheck();
		    }
		    function btnApprove_onclick()
		    {
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
		        if((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16)
		        {
		            if(pDraftFlag == "HABYUI" || pDraftFlag == "B_GAMSA" || pDraftFlag == "A_GAMSA")
		                getLastOpinon();
		            var fields = message.GetFieldsList(); 	
		            var field = message.GetListItem(fields, "lastdraftdate");
		            if(field)
		            {
		                var CurrentDate = getGyulJeDate();
		                setNodeText(field, CurrentDate);
		            }
		        }
		        if (!isjunkyul) {
		            if ("${approvalPWD}" != "N") {
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
		
		    function Approv_Complete(signtype) {
		        DivPopUpHidden();
		        UpdateLineHistory();
		        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                var rtnVal = ExcuteInfo("DOCNUM_BEFORE", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
		                    return;
		                }
		            }
		        }
		        if (pDraftFlag != "SUSIN") {
		            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    var rtnval;
		                    rtnval = getDocNumber(drafterDeptid, "");
		                    if (!rtnval) {
		                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t32'/>";
		                        OpenAlertUI(pAlertContent);
		                        setMenuDisable("btnApprove", false);
		                        return;
		                    }
		                }
		            }
		        }
		        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                var rtnVal = ExcuteInfo("DOCNUM_AFTER", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
		                    return;
		                }
		            }
		        }
		        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                var rtnVal = ExcuteInfo("LAST_SIGN_BEFORE", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
		                    return;
		                }
		            }
		        }
		        else {
		            var rtnVal = ExcuteInfo("MIDDLE_SIGN_BEFORE", "");
		            if (!rtnVal) {
		                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                setMenuDisable("btnApprove", false);
		                return;
		            }
		        }
		        signInfo = AprrovMappingSign(signtype);

		        var rtnVal = true;
		        if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                SetAutoPropFinal();
		                var rtnVal = ExcuteInfo("LAST_SIGN_AFTER", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
		                    return;
		                }
		            }
		        }
		        else {
		            var rtnVal = ExcuteInfo("MIDDLE_SIGN_AFTER", "");
		            if (!rtnVal) {
		                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                setMenuDisable("btnApprove", false);
		                return;
		            }
		        }
		        
		        if (rtnVal) {
		        	rtnVal = SaveApproveInfo("1");
		        }

		        if (rtnVal != "TRUE")  {
		            if (pDraftFlag != "SUSIN") {
		                if (docAccess) {
		                    rollbackDocNumber(drafterDeptid, "");
		                    docAccess = false;
		                    if (fractionsymbol == "") {
		                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t33'/>";
		                        OpenAlertUI(pAlertContent);
		                        setMenuDisable("btnApprove", false);
		                        return;
		                    }
		                }
		            }
		            UndoSignInfo(signInfo);
		            if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    var rtnVal = ExcuteInfo("END_FAIL", "");
		                    if (!rtnVal) {
		                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                         
		                        OpenAlertUI(pAlertContent);
		                        setMenuDisable("btnApprove", false);
		                        return;
		                    }
		                }
		            }
		            else {
		                var rtnVal = ExcuteInfo("MIDDLE_END_FAIL", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
		                    return;
		                }
		            }
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t34'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnApprove", false);
		            return;
		        }
		        else {
		            if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2) || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		                    var rtnVal = ExcuteInfo("LAST_END_AFTER", "");
		                    if (!rtnVal) {
		                        var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                        OpenAlertUI(pAlertContent);
		                        setMenuDisable("btnApprove", false);
		                        return;
		                    }
		                    getOpinionInfo(pDocID, "END");
		                    SendMailToDrafter();
		                    SendMailToReceiveDept_Approv();
		                } else {
		                	 CurrentAprType = pAprLineType;
		                     CurrentAprUserID = pUserID;
		                     sendAlertMail("APR", pAprMemberSN, "APPROV");
		                }
		            }
		            else {
		                var rtnVal = ExcuteInfo("MIDDLE_END_AFTER", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[ " + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
		                    return;
		                }
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
		        if (chkpass == "False") {
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
		    function btnReject_onclick()
		    {
		        var pInformationContent = "<spring:message code='ezApprovalG.t36'/>";
		        OpenInformationUI(pInformationContent, btnReject_onclick_Complete);
		    }
		
		    function btnReject_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
		        if ("${approvalPWD}" != "N") {
		            chk_Passwd(pingUserID, btnReject_chkpassword_Complete);
		        }
		        else {
		            openOpinionUI("BanSong", btnReject_option_Complete);
		        }
		    }
		    function btnReject_chkpassword_Complete(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        openOpinionUI("BanSong", btnReject_option_Complete);
		    }
		    function btnReject_option_Complete(ret) {
		        DivPopUpHidden();
		        if (ret != "cancel") {
		            UpdateLineHistory();
		            var rtnVal = ExcuteInfo("BANSONG_BEFORE", "");
		            if (!rtnVal) {
		                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            var RtnVal = SaveApproveInfo("2");
		            if (RtnVal != "TRUE") {
		                var rtnVal = ExcuteInfo("BANSONG_FAIL", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		                var pAlertContent = "<spring:message code='ezApprovalG.t37'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            else {
		                var rtnVal = ExcuteInfo("BANSONG_AFTER", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
      						return;
		                }
		                SendMailBansongtoDrafter();
		                SendAckForExch("approval", "ING");
		                process_AfterApprove("2");
		            }
		        }
		        else if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t38'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btnStay_onclick() 
		    {
		        var pInformationContent = "<spring:message code='ezApprovalG.t39'/>";
		       OpenInformationUI(pInformationContent, btnStay_onclick_Complete);
		    }
		
		    function btnStay_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
		        if ("${approvalPWD}" != "N") {
		            chk_Passwd(pingUserID, btnStay_chkpassword_Complete);
		        }
		        else
		            openOpinionUI("BoRyu", btnStay_option_Complete);
		    }
		
		    function btnStay_chkpassword_Complete(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        openOpinionUI("BoRyu", btnStay_option_Complete);
		    }
		
		    function btnStay_option_Complete(ret) {
		        DivPopUpHidden();
		        if (ret != "cancel") {
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
		        }
		    }
		    function btnJunKyul_onclick()
		    {
		        if ("${approvalPWD}" != "N") {
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
		            getCurApproverAprLine();
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
		            ReAprLineSingMapping(ret);
		            SaveFile();
		            getCurApproverAprLine();
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
		            alert("btnModAprDept_onclick : " + e.description);
		        }
		    }
		    function btnOpinion_onclick() {
		        openOpinionUI("");
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
		        PrintClick("Cross", pDocID, "ING");
		    }
		
		    function btnClose_onclick() {
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
		    };
		    
		    function btnConn_onclick() {
		    }
		    
		    function btnMail_onclick() {
		    	var imgUrl="";
		    html2canvas(document.getElementById("message").contentWindow.document.getElementById("div_Content"), {
		    	background:'#fff',onrendered: function(canvas) {
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
		    		});
	        var pheight = window.screen.availHeight;
	        var conHeight = pheight * 0.8;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - conHeight) / 2;
	        var pLeft = (pwidth - 890) / 2;
	        //기존
	        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref);
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
		        field = message.GetListItem(fields, "docnumber");
		        if (field && tempItemCode != "") {
		            var tempdocnumber = field.value;
		            tempdocnumber = tempdocnumber.replace(tempdocnumcode, tempItemCode);
		            field.textContent = tempdocnumber;
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
		            alert("btnSetTaskCode_onclick : " + e.description);
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
		
		        inssepattach_cross_dialogArguments[0] = para;
		        inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;
		
		        DivPopUpShow(730, 630, "/ezApprovalG/insSepAttach.do");
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
		    var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo() {
		        isExtDoc = message.DocumentBodyGetAttribute("EXTDOC");
		
		        if (isExtDoc != "Y") isExtDoc = "N";
		
		        var onlydocinfiview = false;
		        var parameter = new Array();
		        CheckDocCellInfo();
		        parameter[0] = pDocID;
		        parameter[1] = pFormID;
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
		        parameter[12] = "DRAFT";
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
		
		                //결재선 저장
		                if (pGubun != "5" && pGubun != "7" && pGubun != "10") {
		                    if (ret[1] != false) {
		                        savexmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
		                        savexmlhttp.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		                        savexmlhttp.send(ret[1]);
		
		                        var dataNodes = GetChildNodes(savexmlhttp.responseXML);
		                        IsSkipDrafter = "FALSE";
		                        btnSendDraftEnable = "true";
		                        ReAprLineSingMapping(ret);
		                        SaveFile();
		                        getCurApproverAprLine();
		                    }
		                    savexmlhttp = null;
		                    savexmlhttp = createXMLHttpRequest();
		                }
		
		                if (pSuSinFlag == "Y") {
		                    if (pSuSinFlag == "Y" && typeof (ret[2]) == "object") {
		                        savexmlhttp.open("Post", "/ezApprovalG/aprDeptSave.do", false);
		                        savexmlhttp.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
		                        savexmlhttp.send(ret[2]);
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
		
		                //문서 정보
		                tempSecurity = ret[7];
		                tempUrgent = ret[8];
		                pSummery = ret[9];
		                pSpecialRecordCode = ret[10];
		                pPublicityCode = ret[11];
		                pLimitRange = ret[12];
		                pPageNum = ret[13];
		                tempSecurityDate = ret[14];
		                setPublicFlag();
		                SummaryFlag = true;
		
		                savexmlhttp = null;
		
		            }
		            catch (e) {
		                alert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        }
		    }
		
		    function btnEdit_onclick()
		    {
		        if (modeflag) {
		            modeflag = false;
		            chkBtnConfirm("1");
		            chkBtn(false);            
		            beforeHtml = message.Get_EditorBodyHTML();
		            message.SetEditable(true);
		            var contentEditable = message.DocumentBodyGetAttribute("contentEditable");
		            if (contentEditable)
		                message.DocumentBodySetAttribute("contentEditable", "inherit");
		            btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t42'/>";
		        }
		        else {
		            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
		            OpenInformationUI(pInformationContent, btnEdit_onclick_Complete);
		        }
		    }
		    function btnEdit_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t44'/>";
		        if (Ans) {
		            if (FirstHtml == "")
		                FirstHtml = beforeHtml;
		        }
		        else {
		            message.Set_EditorInputBodyHTML(modifiOrgBody);
		            message.Set_HtmlDocument();
		            noFieldsAvailable = true;
		        }
		        message.SetEditable(false);
		        chkBtnConfirm("2");
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
		
		        DivPopUpShow(600, 450, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=APR");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
	<body class="popup" style="height:100%;">
		<table class="layout">
		  <tr>
		    <td style="height:20px;">
			<div id="menu">
		        <ul id="AllApprove">
		                  <li id="btnApprove"><span onClick="return btnApprove_onclick()"><spring:message code='ezApprovalG.t1'/></span></li>
		                  <li id="btnReject"><span onClick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
		                  <li id="btnStay"><span onClick="return btnStay_onclick()"><spring:message code='ezApprovalG.t50'/></span></li>
		                  <span style="display:none"><li id="btnSetTaskCode" style="display:none"><span onClick="btnSetTaskCode_onclick()" ><spring:message code='ezApprovalG.t9994'/></span></li></span>
		                  <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>        
		                  <li id="btnJunKyul" style="display:none"><span onClick="return btnJunKyul_onclick()"  ><spring:message code='ezApprovalG.t25'/></span></li>
		                  <span style="display:none"><li id="btnModAprLine"><span onClick="return btnModAprLine_onclick()" ><spring:message code='ezApprovalG.t52'/></span></li></span>
		                  <span style="display:none"><li id="btnModAprDept"><span onClick="return btnModAprDept_onclick()" ><spring:message code='ezApprovalG.t154'/></span></li></span>                 
		                  <li id="btnEdit"><span onClick="return btnEdit_onclick()"  ><spring:message code='ezApprovalG.t44'/></span></li>
		                  <span style="display:none"><li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()"  ><spring:message code='ezApprovalG.t54'/></span></li></span>            
		                  <li id="btnOpinion"><span onClick="return btnOpinion_onclick()"  ><spring:message code='ezApprovalG.t55'/></span></li>
		                  <li id="btnFileAttach"><span onClick="return btnFileAttach_onclick()" ><spring:message code='ezApprovalG.t56'/></span></li>
		                  <li id="btnAprDocAttach"><span onClick="return btnAprDocAttach_onclick()" ><spring:message code='ezApprovalG.t57'/></span></li>
		                  <li id="btnAddSepAttach" ><span onClick="btnAddSepAttach_onclick()" ><spring:message code='ezApprovalG.t58'/></span></li>
		                  <li id="btnSave" style="display:none"><span onClick="return btnSave_onclick()"  ><spring:message code='ezApprovalG.t1767'/></span></li>
		                  <li id="btnPrint"><span onClick="return btnPrint_onclick()"  ><spring:message code='ezApprovalG.t60'/></span></li>
		                  <li id="btnhistory"><span onClick="btnhistory_onclick()" ><spring:message code='ezApprovalG.t61'/></span></li>
		                  <li id="btnMail"><span onClick="return btnMail_onclick()" ><spring:message code='ezApprovalG.t62'/></span></li>
		                  <li id="btnConn" style="display:none"><span onClick="return btnConn_onclick()"><spring:message code='ezApprovalG.t63'/></span></li>
		                  <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		              </ul>
				</div>
			<div id="close"><ul><li><span id="btnClose" onClick="return btnClose_onclick()" ><spring:message code='ezApprovalG.t64'/></span></li></ul></div>
		</td> 
		  </tr>
		  <tr>
		      <td style="vertical-align:top;height:90%;">
		        <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="approvUIcontent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		          
		    </td>
		  </tr>
		  <tr>
		    <td style="height:20px;"><table class="file">
		        <tr>
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
		  </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<XML ID="ATTACHINFO"></XML>
		<XML ID="DOCINFO"></XML>
		<XML ID="APRLINEINFO"></XML>
		<div id="AprMemberSN" style="display:none"></div>
		<iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>