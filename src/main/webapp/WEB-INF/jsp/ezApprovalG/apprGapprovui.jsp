<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t1'/></title>
		<meta http-equiv="Content-Type" content="text/html;" charset="utf-8" />
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
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
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    arr_userinfo[17]  = "${userInfo.primary}";
		    var pCompanyID = "${userInfo.companyID}";
		    var KuyjeType = "002";
		    var signDateFormat = "${optSignDateFormat}";
		    var isSplit = "${optIsSplit}";
		    var SplitKind = "${optSplitKind}";
		    var junKyulInfo = "${optJunKyulInfo}";
		    var FirstHtml = "";
		    var beforeHtml;
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "";
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
		    var approvalFlag = "${approvalFlag}";
		    var junGyulFlag = "${junGyulFlag}";
		    var pSignImage_Size = "${signImageSize}";
		    var pADMIN = "N";
		    var docNumZeroCnt = "${docNumZeroCnt}";
		  	//회람
			var type = "ING";
			var pGongRamDocID = "";
			var approvalType = "DRAFT";
			var signImageType = "${signImageType}";
			
			//최종 결재 개인합의 추가
			var addLastKyulJeYN = "${addLastKyulJeYN}";
			var totalMemSN = "0";
			var LastTotalKyulSN = "0";
			var lastHabYuiSN;
			var agreeReturnType = "${agreeReturnType}";
			var curDocNum = "";
			var draftDeptID = "${draftDeptID}";
			var isHWP = "";
			var ext = "mht";
			var nonElecRec = "${nonElecRec}";
	        var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
			
			var docState = "${docState}";
			var orgCompanyID = "${orgCompanyID}";
			
			//최종결재시 채번
			var useReceiveDocNo = "${useReceiveDocNo}";
			
			//2018-11-07 배현상, 결재자 순번
			var wAprMemberSN = "";
			
		    window.onload = function () {
		        if (allFlag == "2") {
		            selectedDocID = window.opener.selectedDocIDS;
		        }
		        
		    	if(approvalFlag == "G") {
	        		$("#btnAddSepAttach").css("display","");
	        	} 
		    	
		    	if (nonElecRec == "Y") {
			        getNonElecInfoSusinInit();
					document.getElementById("btnAddSepAttach").style.display = "none";
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
		    /**
		    * RtnVal -> 0 : 결재, 1 : 다음문서, 2 : 문서보기, 3 : 취소
		    */
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
		            OpenAlertUI(pAlertContent);
		            window.parent.close();
		            btnClose_onclick();
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
		            pEndDocHref = "/fileroot/" + "${userInfo.tenantId}" + "/files/upload_approvalG/" + pCompanyID + "/doc/" + CurrYear + "/" + (pDocID % 1000) + "/" + pDocID + ".mht";
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
		        } else if (NextDocExtended.toLowerCase() == "hwp") {
		            var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&ID=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
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
		            if (pDocHref != "")
		            {
		                message.Set_EditorContentURL(pDocHref);
		                setDocNumFormat("");
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
		                var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT","");
		                if(!rtnVal) {
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
			/**
			* 각 결재타입마다 나타나는 경고창 출력 함수
			* 결재, 반송, 보류, 참조 등
			*/
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
		        getCurApproverAprLine("${isUsed}");
		
		        pGubun = "8";
		        
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
			        } else if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			            setMenuBar("btnModAprLine", false);
			            pGubun = "5";
			        }
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
		        if(pDraftFlag == "SUSIN") {
		            var fields = message.GetFieldsList();
		            var field = message.GetListItem(fields, "susinbody");
		            if(field) {
		                setMenuBar("btnEdit", true);
		            } else {
		                setMenuBar("btnEdit", false);
		            }
		
		            setMenuBar("btnModAprDept", false);
		            setMenuBar("btnFileAttach", false);
		            setMenuBar("btnAprDocAttach", false);
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

		    }
		    function btnApprove_onclick()
		    {
	    		if (checkAprState()) {
	    			alert("<spring:message code='ezApprovalG.bhs23'/>");
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
		    /**
		    * ExcuteInfo()를 통한 연동관리
		    * getDocNumber()를 통한 문서번호 채번
		    * ApprovMappingSign()를 통한 결재정보 내용 출력
		    * SaveApproveInfo()를 통한 xml 생성 및 Contoller 호출
		    */
		    function Approv_Complete(signtype) {
		        DivPopUpHidden();
		        if (checkAprState()) {
		        	alert("<spring:message code='ezApprovalG.bhs23'/>");
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
		        }
		        
		        // getDocNumber를 이용한 문서번호 채번
		        if (pDraftFlag != "SUSIN") {
		        	if (approvalFlag == "S") {
		        		// '현재진행 중인 결재가 개인순차합의가 아닌 경우' 추가
		        		// 마지막 결재자가 합의인 경우 totalMemSN 값으로 해당 조건절 사용.
			            if ((LastKyulSN == pAprMemberSN && lastHabYuiSN != 0 && pAprLineType != strAprType8 && pAprLineType != strAprType7) || pAprLineType == strAprType4 || totalMemSN > 0) {
			                if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType8) {
			                    var rtnval;
			                    rtnval = getDocNumber(drafterDeptid, "", docNumZeroCnt);
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
			                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                    var rtnval;
			                    rtnval = getDocNumber(drafterDeptid, "", docNumZeroCnt);
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
			        	} else {
			        		// 일단 복사해봄
			        		if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
				            	// 1 : 결재, 2 : 확인, 4 : 전결, 16 : 대결, 18 : 기안, 19 : 검토
				                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
				                    var rtnval;
				                    rtnval = getDocNumber(drafterDeptid, "", docNumZeroCnt);
				                    
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
		        
		        signInfo = ApprovMappingSign(signtype); // 현재 양식에 결재 관련 정보 출력( ex. 서명 서명 날짜 등등)

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
		        		if (approvalFlag == "S") {
		        			if ((LastKyulSN == pAprMemberSN && lastHabYuiSN != 0 && pAprLineType != strAprType8 && pAprLineType != strAprType7) || pAprLineType == strAprType4 || totalMemSN > 0) {
		        				if (pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType8) {
		        					rollbackDocNumber(drafterDeptid, "", pDocID);
		        				}
		        			}
		        		} else {
		        			if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		        				if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		        					rollbackDocNumber(drafterDeptid, "", pDocID);
		        				}
		        			}
		        		}
		        	} else {
		        		if (useReceiveDocNo == 'NO') {
		        			if (approvalFlag == "G") {
		        				if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
		        					if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
		        						rollbackDocNumber(drafterDeptid, "", pDocID);
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
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
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
		        if ("${approvalPWD}" != "N") {
		            chk_Passwd(pingUserID, btnReject_chkpassword_Complete);
		        } else {
		            openOpinionUI("BanSong", btnReject_option_Complete);
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
		        openOpinionUI("BanSong", btnReject_option_Complete);
		    }
		    /**
		    * '반송'
		    */
		    function btnReject_option_Complete(ret) {
		        DivPopUpHidden();
		        if (ret != "cancel") {
		        	pHasOpinionYN = "Y";
		            UpdateLineHistory(); // '변경내역' 업데이트
		            var rtnVal = ExcuteInfo("BANSONG_BEFORE", "");
		            if (!rtnVal) {
		                var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            
		            if (checkAprState()) {
		            	alert("<spring:message code='ezApprovalG.bhs23'/>");
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
		    			return;
		    		}
		            
		            redrawMappingSign();
		            
		            signInfo = putBansongSign(); // '서명' 관련 정보 출력

		            var RtnVal = SaveApproveInfo("2");
		            if (RtnVal != "TRUE") {
		            	UndoSignInfo(signInfo);
		                var rtnVal = ExcuteInfo("BANSONG_FAIL", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t7'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		                var pAlertContent = "<spring:message code='ezApprovalG.t37'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            } else {
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
		        } else if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t38'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btnStay_onclick() {
		    	if (checkAprState()) {
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
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
		        if ("${approvalPWD}" != "N") {
		            chk_Passwd(pingUserID, btnStay_chkpassword_Complete);
		        }
		        else
		            openOpinionUI("BoRyu", btnStay_option_Complete);
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
		        openOpinionUI("BoRyu", btnStay_option_Complete);
		    }
		
		    function btnStay_option_Complete(ret) {
		        DivPopUpHidden();
		        if (ret != "cancel") {
		        	if (checkAprState()) {
		        		alert("<spring:message code='ezApprovalG.bhs23'/>");
		    			if (allFlag == "1") {
		    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
		    			} else {
			    			window.returnValue = "CLOSE";
			    			btnClose_onclick();
		    			}
		    			return;
		    		}
		        	
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
		            getCurApproverAprLine("${isUsed}");
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
		            getCurApproverAprLine("${isUsed}");
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
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
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
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		
		        ezapprovalinfo_dialogArguments[0] = parameter;
		        ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;

		        var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun +"&orgCompanyID=" + pCompanyID + "&docType=" + pDocType, "ezApprovalInfo", GetOpenWindowfeature(1144, 750));
		        
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
			                        getCurApproverAprLine("${isUsed}");
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
			                        getCurApproverAprLine("${isUsed}");
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
		                    				alert(strLang163);
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
		                
		                tempSecurity = ret[7];                // 보안등급 관련
		                tempUrgent = ret[8];                  // 긴급 결재 여부
		                pSummery = ret[9];                    // 요약 내용 관련
		                tempSecurityDate = ret[14];           // 보안 결재 체크 관련
		                pPublicityCode = ret[11];             // 대민공개여부 및 공개등급 관련 
		                pPublicityYN = ret[21];             // 공개여부 및 공개등급 관련  
		                
		                //tempPublic 추가
		                if (ret[11].substring(0,1) == '1') {
		                	tempPublic = 'Y';
		                } else {
		                	tempPublic = 'N';
		                }
		                
		                if (approvalFlag == "G") {
			                pSpecialRecordCode = ret[10];
			                pLimitRange = ret[12];
			                pPageNum = ret[13];
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
				            	}
				            }
			                
		                } else {
		                	//회람
		                	if (ret[22] == "noItem") {
		                		//없으니깐 암것도 안해도되려나 싶은데 기존꺼를 뺏을수도 있으니까 무조건 삭제
		                		delAprLineInfoCC();
		                	} else if (ret[22] == "sameItem") {
		                		//같으니깐 암것도 안해도 되려나
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
		                	SetDocOption(ret[20]);
		                }
		
		                SummaryFlag = true;
		
		            }
		            catch (e) {
		                alert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        } else if (ret != undefined && ret[0] == "DUPL") {
		        	window.returnValue = "CLOSE";
	    			btnClose_onclick();
		        }
		    }
		
		    function btnEdit_onclick()
		    {
		    	if (checkAprState()) {
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
		        if (modeflag) {
		            modeflag = false;
		            chkBtnConfirm("1");
		            chkBtn(false, approvalFlag);            
		            beforeHtml = message.Get_EditorBodyHTML();
		            message.SetEditable(true);
		            var contentEditable = message.DocumentBodyGetAttribute("contentEditable");
		            if (contentEditable)
		                message.DocumentBodySetAttribute("contentEditable", "inherit");
		            btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t1767'/>";
		        }
		        else {
		            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
		            OpenInformationUI(pInformationContent, btnEdit_onclick_Complete);
		        }
		    }
		    function btnEdit_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        
		        if (checkAprState()) {
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
	    			if (allFlag == "1") {
	    				LoadNextDocument("\n" + "<spring:message code='ezApprovalG.t4'/>");		    				
	    			} else {
		    			window.returnValue = "CLOSE";
		    			btnClose_onclick();
	    			}
	    			return;
	    		}
		        
		        if (Ans) {
			        var mustField = message.getMustFieldsInsert("${userInfo.lang}");
		            if (mustField && mustField != ""){
			            	var pAlertContent = "<spring:message code='ezApprovalG.psb131'/>";
			            	pAlertContent = pAlertContent.replace("@@", mustField);
			                OpenAlertUI(pAlertContent);
			                return;
		            }
		            if (FirstHtml == "")
		                FirstHtml = beforeHtml;
			        btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t44'/>";
		        }
		        else {
		            message.Set_EditorInputBodyHTML(modifiOrgBody);
		            message.Set_HtmlDocument();
		            noFieldsAvailable = true;
			        btnEdit.childNodes[0].textContent = "<spring:message code='ezApprovalG.t44'/>";
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
		
		        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=APR&orgCompanyID="+orgCompanyID);
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
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
					createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", SelectSingleNodeValue(dataNodes[1], "VALUE").trim() + (SelectSingleNodeValue(dataNodes[2], "VALUE").trim() == "" ? "<spring:message code='ezApprovalG.lhj18'/>" : ""));
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
			        var reMappingAprLine = getAprLineList("${isUsed}");
			        
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
			              <li id="btnAddSepAttach" style="display:none"><span onClick="btnAddSepAttach_onclick()" ><spring:message code='ezApprovalG.t58'/></span></li>
		                  <li id="btnSave" style="display:none"><span onClick="return btnSave_onclick()"  ><spring:message code='ezApprovalG.t1767'/></span></li>
		                  <li id="btnPrint"><span onClick="return btnPrint_onclick()"  ><spring:message code='ezApprovalG.t60'/></span></li>
		                  <li id="btnhistory"><span onClick="btnhistory_onclick()" ><spring:message code='ezApprovalG.t61'/></span></li>
		                  <li id="btnMail"><span onClick="return btnMail_onclick()" ><spring:message code='ezApprovalG.t62'/></span></li>
		                  <li id="btnConn" style="display:none"><span onClick="return btnConn_onclick()"><spring:message code='ezApprovalG.t63'/></span></li>
		                  <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		              </ul>
				</div>
			<div id="close"><ul><li><span id="btnClose" onClick="return btnClose_onclick()" ></span></li></ul></div>
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
	</body>
</html>
