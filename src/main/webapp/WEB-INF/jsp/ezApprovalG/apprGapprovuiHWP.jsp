<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t1'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ApprovUI_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezAprove_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
	        var OrgAprUserID = "<c:out value ='${orgAprUserID}'/>";
	        var OrgAprUserName = "<c:out value ='${orgAprUserName}'/>";
	        var OrgAprUserName2 = "";
	        var OrgAprUserDeptID = "<c:out value ='${orgAprUserDeptID}'/>";
	        var pEndDocHref = "<c:out value ='${dirPath}'/>";
	        var pDocID = "<c:out value ='${docID}'/>";
	        var pingUserID = "<c:out value ='${tempUserID}'/>";
	        var pDocInfo = null;
	        var pDocHref = new String("");
	        var pUserID = new String("");
	        var pHasAttachYN = new String("");
	        var pAprMemberSN = 0;
	        var flag = false;
	        var Btnflag = "true";
	        var FormProc = null;
	        var arrPrevDoc = new Array();
	        var arrNextDoc = new Array();
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var xmlaprline = createXmlDom();
	        var xmlattach = createXmlDom();
	        var Resultxml = createXmlDom();
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
	        var pOrgAprUserName;
	        var pOrgAprUserName2;
	        var pOrgAprUserJobTitle;
	        var pOrgAprUserDeptID;
	        var pOrgAprUserDeptName;
	        var docAccess = false;
	        var modeflag = true;
	        var isjunkyul = false;
	        var gPublic = "";
	        var pDocTitle = "";
	        var pFormID = "";
	        var drafterDeptid = "";
	        var pMaxFileSize = "5"
	        var LastSignNo;
	        var AppendFileAttach = "";
	        var AppenAprDocAttachList = "";
	        var TempsaveAprlineinfo;
	        var aprlineinfoTMP;
	        var modarpline = "";
	        var SignType = new Array();
	        var SignName = new Array();
	        var SignContent = new Array();
	        var RootURL = document.location.protocol + "//" + document.location.hostname;
	
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value ='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value ='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value ='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value ='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8]  = "<c:out value ='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
		    arr_userinfo[11]  = "<c:out value ='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value ='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value ='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value ='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value ='${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value ='${userInfo.deptName2}'/>";
	        var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
	        var companyID = "<c:out value ='${userInfo.companyID}'/>";
	        var KuyjeType = "002";
	        var signDateFormat = "<c:out value ='${optSignDateFormat}'/>";
		    var isSplit = "<c:out value ='${optisSplit}'/>";
	        var SplitKind = "<c:out value ='${optSplitKind}'/>";
	        var junKyukInfo = "<c:out value ='${optjunKyukInfo}'/>";
	        var FirstHtml = "";
	        var beforeHtml;
	        var beforeHwp = "";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pPublicityYN = "", pLimitRange = "", pPageNum = "";
	        var cabinetID = "";
	        var TaskCode = "";
	        var DocNumCode = "";
	        var allFlag = "<c:out value ='${allFlag}'/>";
		    var selectedDocID = "";
		    var OpinionAction = "";
		    var CurrYear = "<c:out value ='${oldYear}'/>";
		    var SummaryFlag = true;
		    var pGubun;
		    var isExtDoc;
		    var pUse_Editor = "<c:out value ='${useEditor}'/>";
	        var g_szUserID = arr_userinfo[8];
	        var g_senderinfo = "<c:out value ='${userInfo.companyName}'/>" + ", " + "<c:out value ='${userInfo.deptName}'/>" + ", " + "<c:out value ='${userInfo.title}'/>";
	        var isHWP = "<c:out value ='${isHWP}'/>";
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var ext = "hwp";
	        var aprDocTimeStamp = "";
	        var docState = "<c:out value ='${docState}'/>";
	        var nonElecRec = "<c:out value ='${nonElecRec}'/>";
	        var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
	        var useReceiveDocNo = "<c:out value ='${useReceiveDocNo}'/>";
	        var orgCompanyID = "<c:out value='${orgCompanyID}' />";
	        var docNumZeroCnt = "<c:out value ='${docNumZeroCnt}'/>";

	        //원문공개정보
            var useOpenGov = "<c:out value ='${useOpenGov}'/>";
			var basis = "<c:out value ='${basis}' />";
            var reason = "<c:out value ='${reason}' />";
            var listOpenFlag = "<c:out value ='${listOpenFlag}' />";
            var fileOpenFlagList = "<c:out value ='${fileOpenFlagList}' />";
	        
	        var curDocNum = "";
	        
	        var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			var formAprOption = "<c:out value='${formAprOption}'/>";
			
			var useWebHWP = "<c:out value ='${useWebHWP}'/>";
			
		    function getNextDocList() {
		        NextDocID = "";
		        if (selectedDocID != "") {
		            var xmldoclist = createXmlDom();
		            xmldoclist.async = false;
		            xmldoclist.loadXML(selectedDocID);
		            if (xmldoclist.documentElement.childNodes.length > 0) {
		                var breakflag = false;
		                for (var i = 0; i < xmldoclist.documentElement.childNodes.length; i++) {
		                    if (getNodeText(xmldoclist.documentElement.childNodes(i)) == pDocID)
		                        breakflag = true;
		                    else if (breakflag) {
		                        breakflag = false;
		                        getNextDocOne(getNodeText(xmldoclist.documentElement.childNodes(i)));
		                    }
		                }
		            }
		        }
		    }
	
		    function OpenAllApproveFlag() {
		        var window_left = window.screen.availWidth / 2 - 160;
		        var window_top = window.screen.availHeight / 2 - 90;
		
		        AllApprove.style.display = "none";
		        var parameter = "";
		        var url = "/ezApprovalG/ezAprAllAlert.do";
		        var feature = "status:no;dialogWidth:326px;dialogHeight:205px;help:no;scroll:no;dialogLeft:" + window_left + ";dialogTop:" + window_top + "";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		
		        AllApprove.style.display = "";
		
		        if (RtnVal == "0") {
		            btnApprove_onclick();
		        }
		        else if (RtnVal == "1") {
		
		            if (allFlag == "1")
		                //btnStay_onclick();
		            	LoadNextDocument("\n<spring:message code='ezApprovalG.t2'/>");
		            else if (allFlag == "2")
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t2'/>");
			    }
			    else if (RtnVal == "2") {
			        return;
			    }
			    else if (RtnVal == "3") {
			        window.close();
			        btnClose_onclick();
			    }
			}
	
			function LoadNextDocument(tempString) {
			    if (allFlag == "1")
			        getNextDocInfo();
			    else if (allFlag == "2")
			        getNextDocList();
			
			    if (NextDocID == "") {
			        if (tempString == "")
			            var pAlertContent = "<spring:message code='ezApprovalG.t3'/>";
				    else {
				        tempString = tempString.replace("\n<spring:message code='ezApprovalG.t2'/>", "");
				        tempString = tempString.replace("\n\n<spring:message code='ezApprovalG.t4'/>", "");
				        tempString = tempString.replace("\n", "");
				        var pAlertContent = tempString + "<br><spring:message code='ezApprovalG.t3'/>";
		            }
			        OpenAlertUI(pAlertContent, btnClose_onclick); // 알림창 확인 시 문서창 닫도록 수정
		            //window.parent.close();
		            //btnClose_onclick();
		        }
		        else {
		            if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() != "hwp") {
		                openOtherApprovUI();
		                return;
		            }
		
		
		            DocNumCode = "";
		
		            showProgress(tempString.replace("\n", ""));
		
		            if (pDocID == NextDocID) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t3'/>";
				        OpenAlertUI(pAlertContent);
				        window.parent.close();
				        btnClose_onclick();
				        return;
				    }
		
		            pDocID = NextDocID;
		            OrgAprUserID = NextDocUserID;
		            OrgAprUserName = NextDocUserName;
		            OrgAprUserName2 = NextDocUserName2;
		            OrgAprUserDeptID = NextDocDeptID;
		
		            getApprovInfo();
		            pUserID = pOrgAprUserID;
		            getDocInfo();
		            setAttachInfo(pDocID, "APR", lstAttachLink);
		            GetExchInfo();
		
		            if (pDocHref != "") {
		                var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pDocHref) + "&tempTime=" + aprDocTimeStamp;
		                var isTrue = HwpCtrl.LoadFile(URL, false);
		
		                FieldsAvailable(isTrue);
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
		        if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "doc") {
		            var openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word.aspx?DocID=" + escape(pArgument[0]);
		
		            openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]) + "&uName2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		        } else if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "hwp" && useWebHWP == "NO") {
		            var openLocation = "/ezApprovalG/approvuiHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&ID=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag);
		        } else if (NextDocExtended.substring(NextDocExtended.lastIndexOf(".") + 1).toLowerCase() == "hwp" && useWebHWP == "YES") {
		            var openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + escape(pArgument[0]);
		            openLocation = openLocation + "&ID=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]) + "&name2=" + escape(pArgument[4]);
		            openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=" + escape(allFlag);
		        } else {
		            if (pUse_Editor == "TAGFREE") {
		                var openLocation = "/myoffice/ezApprovalG/ApprovUI/approvui_IE.aspx?DocID=" + escape(pArgument[0]);
		                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]) + "&uName2=" + escape(pArgument[4]);
		                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		            } else {
		                var openLocation = "/ezApprovalG/approvuiWHWP.do?docID=" + escape(pArgument[0]);
		                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]) + "&uName2=" + escape(pArgument[4]);
		                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=" + escape(allFlag);
		            }
		        }
		
		        try {
		            window.opener.openwindow(openLocation, "", 880, 550);
		            window.close();
		        } catch (e) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t5'/>";
				        OpenAlertUI(pAlertContent);
				        window.close();
				        btnClose_onclick();
				    }
		        }
	
		        window.onresize = function () {
		            HwpCtrl.style.height = null;
		            HwpCtrl.height = document.documentElement.clientHeight - 150;
		        }
	
		        function window_onload() {
		            window.onresize();
		
		            if (allFlag == "2") {
		                try {
		                    selectedDocID = window.opener.selectedDocIDS;
		                }
		                catch (e) { }
		            }
		
		            try {
		            	var agent = navigator.userAgent.toLowerCase();
		            	
		            	if (!((navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || agent.indexOf("msie") != -1)) {
		            		throw "hwp";
		            	}
		                HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
		                HwpCtrl.SetImgReg();
		                HwpCtrl.SetSaveMode(1);
		
		                getApprovInfo();
		
		                pUserID = pOrgAprUserID;
		                getDocInfo();
		                setAttachInfo(pDocID, "APR", lstAttachLink);
		                GetExchInfo();
		                
		                if (nonElecRec == "Y") {
					        getNonElecInfoSusinInit();
					        document.getElementById("btnAddSepAttach").style.display = "none";
				        }
		
		                if (pDocHref != "") {
		                    showProgress("<spring:message code='ezApprovalG.t368'/>");
				        var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pDocHref) + "&tempTime=" + aprDocTimeStamp;
				        var isTrue = HwpCtrl.LoadFile(URL, false);

				        FieldsAvailable(isTrue);
				        
				        if(useExternalMailServer == "NO") {
				    		$("#btnMail").css("display","");
				    	}
				    }
		            HwpCtrl.ChangeMode(3);
		
		
		            HwpCtrl.SetFieldFocus("doctitle");
		            HwpCtrl.ezSetScrollPosInfo(0);
		        }
		        catch (e) {
		        	if (e == "hwp") {
		        		alert("한글(hwp)결재문서는 Internet Explorer에서만 열람 가능합니다.");	
		        		window.close();
		        	} else {
			            alert("<spring:message code='ezApprovalG.t1373'/>" + e.description);
		        	}
			        hideProgress();
			    }
		    }
	
		    function FieldsAvailable(isTrue) {
		        if (isTrue) {
		            var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT", "")
		            if (!rtnVal) {
		                var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
				        OpenAlertUI(pAlertContent);
				        return;
		            }
		
		            process_AfterOpen();
		            hideProgress();
		            CheckOpinionYN();
		
		            AllApprove.style.display = "";
		            if (allFlag == "1" || allFlag == "2")
		                OpenAllApproveFlag();
		
		            HwpCtrl.SetImgReg();
		        }
		        else {
		            hideProgress();
		            var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			        OpenAlertUI(pAlertContent);
			        HwpCtrl.ClearDocument();
		        }
		    }
	
		    function CheckOpinionYN() {
		        if (pHasOpinionYN == "Y") {
		            var pInformationContent = "<spring:message code='ezApprovalG.t1374'/><br> <spring:message code='ezApprovalG.t10'/>";
			        var Ans = OpenInformationUI(pInformationContent);
		
			        if (Ans) {
			            //openOpinionUI("Display");
			        	openOpinionUI_New("");
			        }
			    }
		
		        if (pDraftFlag == "SUSIN")
		            getSusinSNInfo();
		        else
		            pSusinSN = "0";
		    }
	
		    function process_AfterApprove(mode) {
		        if (FirstHtml != "")
		            UpdateDocHistory(FirstHtml);
		
		        if (mode == "1") {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1375'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1376'/>";
				        OpenAlertUI(pAlertContent);
				        btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        
				      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				        	parent.opener.clearAbsence(true);
				        }
				        return;
				    }
		        }
		        else if (mode == "2") {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1377'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1378'/>";
				        OpenAlertUI(pAlertContent);
				        btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        
				      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				        	parent.opener.clearAbsence(true);
				        }
				        return;
				    }
		        }
		        else if (mode == "3") {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1379'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1380'/>";
				        OpenAlertUI(pAlertContent);
				        btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        
				      //2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
				        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				        	parent.opener.clearAbsence(true);
				        }
				        return;
				    }
		        }
		        else {
		            if (allFlag == "1" || allFlag == "2") {
		                LoadNextDocument("\n<spring:message code='ezApprovalG.t1381'/>");
				    }
				    else {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1382'/>";
				        OpenAlertUI(pAlertContent);
				        btnClose_onclick();
				        Btnflag = "false";
				        ChangeBtnState();
				        return;
				    }
		        }
			}
	
			function setbutton() {
			    ChangeBtnState();
			}
	
			function process_AfterOpen() {
			    getCurApproverAprLine();
			    pGubun = "8";
			    
			    if (pAprLineType == strAprType2 || pAprLineType == strAprType7 || pAprLineType == strAprType8 || pAprLineType == strAprType9 || pAprLineType == strAprType11 || pAprLineType == strAprType12) {
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
			
			    if (KuyjeType == "001")
			        setBtnDisableAprLineType();
			
			    if (pDraftFlag == "SUSIN") {
			        if (HwpCtrl.CheckFieldExist("susinbody"))
			            setMenuBar("btnEdit", true);
			        else
			            setMenuBar("btnEdit", false);
			
			
			        setMenuBar("btnModAprDept", false);
			        setMenuBar("btnFileAttach", false);
			        setMenuBar("btnAprDocAttach", false);
			        pGubun = "6";
			    }
			
			    else {
			        pSuSinFlag = "Y";
			
			        var RtnVal = HwpCtrl.CheckFieldExist("recipient");
			        if (RtnVal) {
			            pSuSinFlag = "Y";
			            setMenuBar("btnModAprDept", true);
			        } else {
			            pSuSinFlag = "N";
			            setMenuBar("btnModAprDept", false);
			            if (pGubun == "5") {
			                pGubun = "7";
			            }
			            else {
			                pGubun = "6";
			            }
			        }
			
			        if (pDraftFlag == "HABYUI") {
			            setMenuBar("btntotaldocinfo", false);
			        }
				}
			    //SignCheck();
			}
	
			function btnApprove_onclick() {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getExtTotalAttachSize.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(text){
		    			result = text;
		    		}        			
		    	});
		    	
		    	var strClone = HwpCtrl.GetCloneData("", "HWPML2X");
		    	var strBytes = parseInt(getByteLength(strClone));
		    	
                var rtnAttachXML = new ActiveXObject("Microsoft.XMLDOM");
                rtnAttachXML.loadXML(result);
                
                var attachTotalSize = getNodeText(rtnAttachXML.getElementsByTagName("TOTALSIZE").item(0));
                
                
                if (getNodeText(rtnAttachXML.getElementsByTagName("FLAG").item(0)) == "Y") {
                    OpenAlertUI("외부발송문서 총 첨부용량은 최대 6MB 입니다" + "<br>" + "첨부용량을 줄여주시기 바랍니다.");
                    return;
                    
                }

                // 본문과 첨부파일의 총합이 7.4mb가 초과시 알러트 결재라인 수정시에도 2018-07-19 강민수92
                if (getNodeText(rtnAttachXML.getElementsByTagName("EXTFLAG").item(0)) == "Y" && strBytes + parseInt(attachTotalSize) > 7400000) {
                	OpenAlertUI("외부발송문서 총 용량은 최대 7.4MB 입니다" + "<br>" + "첨부파일이나 본문용량을 줄여주시기 바랍니다.");
                    return;
                }
				
			    setMenuDisable("btnApprove", true);
			
			    var parameter = new Array();
			    parameter[0] = pDocID;
			    var signInfo
			
			    if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			        if (pDraftFlag == "HABYUI" || pDraftFlag == "B_GAMSA" || pDraftFlag == "A_GAMSA")
			            getLastOpinon();
			        if (HwpCtrl.CheckFieldExist("lastdraftdate"))
			            HwpCtrl.SetFieldText("lastdraftdate", getGyulJeDate());
			    }
			
			    if (!isjunkyul) {
			        //if ("${approvalPWD}" != "N") {
			        if (CheckUsePassword()) {
			            var chkpass = chk_Passwd(pingUserID);
			            if (chkpass == "False") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
			                OpenAlertUI(pAlertContent);
			                setMenuDisable("btnApprove", false);
		
			                return;
			                
			            } else if (chkpass == "cancel" || chkpass == undefined) {
		                	var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
		                    OpenAlertUI(pAlertContent);
		                    setMenuDisable("btnApprove", false);
	
		                    return;
		                }
		            }
			    } else {
			    	isjunkyul = false;
			    } 
			
			        var ret = "NAME";
			
			        if ((pAprLineType != strAprType2) && (pAprLineType != strAprType7) && (pAprLineType != strAprType15) && (pAprLineType != strAprType17))
			            ret = openSingUI(parameter);
			        if (ret == "NAME") {
			            var Rtnval;
			            var Ans = true
			            if (!Ans) ret = "cancel";
			        }
			
			        if (ret == "cancel" || ret == undefined) {
			            var pAlertContent = "[<spring:message code='ezApprovalG.t29'/>";
				        OpenAlertUI(pAlertContent);
				        setMenuDisable("btnApprove", false);
				        return;
				    }
				    else {
				        UpdateLineHistory();
				        OrgHtml = HwpCtrl.GetCloneData("", "HWP");
				        if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
				            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
				                var rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")
				                if (!rtnVal) {
				                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }
			                }
			            }
			
			            if (pDraftFlag != "SUSIN" && pDraftFlag != "HABYUI" || pDraftFlag != "B_GAMSA") {
			                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                        var rtnval;
			                        //rtnval = getDocNumber(drafterDeptid, "");
			                        rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);
			
			                        if (!rtnval) {
			                            var pAlertContent = "[<spring:message code='ezApprovalG.t1384'/>";
								        OpenAlertUI(pAlertContent);
								        setMenuDisable("btnApprove", false);
								        return;
								    }
			                    }
			                }
			            } else {
			            	//useReceiveDocNo 처리
				            if (useReceiveDocNo == 'NO') {
				            	if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
					            	// 1 : 결재, 2 : 확인, 4 : 전결, 16 : 대결, 18 : 기안, 19 : 검토
					                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
					                    var rtnval;
	//				                    rtnval = getDocNumber(drafterDeptid, "");
					                    rtnval = getDocNumberNew(drafterDeptid, "", docNumZeroCnt);
					                    
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
			
			            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                    var rtnVal = ExcuteInfo("DOCNUM_AFTER", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }
			                }
			            }
			
			            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			
			                    var rtnVal = ExcuteInfo("LAST_SIGN_BEFORE", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }
			
			                }
			            }
			            else {
			                var rtnVal = ExcuteInfo("MIDDLE_SIGN_BEFORE", "")
			                if (!rtnVal) {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
			
			            }
			            signInfo = AprrovMappingSign(ret);
			            var rtnVal = true;
			            if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			                if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                    SetAutoPropFinal();
			                    var rtnVal = ExcuteInfo("LAST_SIGN_AFTER", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }
			                }
			            }
			            else {
			                var rtnVal = ExcuteInfo("MIDDLE_SIGN_AFTER", "")
			                if (!rtnVal) {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        setMenuDisable("btnApprove", false);
						        return;
						    }
			            }
			
			            if (rtnVal) rtnVal = SaveApproveInfo("1");
			            if (rtnVal != "TRUE") {
			                if (pDraftFlag != "SUSIN") {
			                    if (docAccess) {
			                        rollbackDocNumber(drafterDeptid, pDocID);
			                        docAccess = false;
			                        if (fractionsymbol == "") {
			                            var pAlertContent = "[<spring:message code='ezApprovalG.t1385'/>";
							            OpenAlertUI(pAlertContent);
							            setMenuDisable("btnApprove", false);
							            return;
							        }
			                    }
			                }
			
			                UndoSignInfo(signInfo);
			                if (LastKyulSN == pAprMemberSN || pAprLineType == strAprType4 || pAprLineType == strAprType16) {
			                    if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			                        var rtnVal = ExcuteInfo("END_FAIL", "")
			                        if (!rtnVal) {
			                            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
								        OpenAlertUI(pAlertContent);
								        setMenuDisable("btnApprove", false);
								        return;
								    }
			                    }
			                }
			                else {
			                    var rtnVal = ExcuteInfo("MIDDLE_END_FAIL", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
							    }
			                }
			                var pAlertContent = "[<spring:message code='ezApprovalG.t34'/>";
					        OpenAlertUI(pAlertContent);
					        setMenuDisable("btnApprove", false);
					        return;
					    }
					    else {
					        if ((LastKyulSN == pAprMemberSN && pAprLineType != strAprType2)|| pAprLineType == strAprType4 || pAprLineType == strAprType16) {
					            if (pAprLineType == strAprType18 || pAprLineType == strAprType19 || pAprLineType == strAprType1 || pAprLineType == strAprType4 || pAprLineType == strAprType16 || pAprLineType == strAprType2) {
			
					                var rtnVal = ExcuteInfo("LAST_END_AFTER", "")
					                if (!rtnVal) {
					                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
								        OpenAlertUI(pAlertContent);
								        setMenuDisable("btnApprove", false);
								        return;
					                }
					                getOpinionInfo(pDocID, "END");
					                SendMailToDrafter();
					                SendMailToReceiveDept_Approv();
			                    }
			                }
			                else {
			                    var rtnVal = ExcuteInfo("MIDDLE_END_AFTER", "")
			                    if (!rtnVal) {
			                        var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
							        OpenAlertUI(pAlertContent);
							        setMenuDisable("btnApprove", false);
							        return;
			                    }
								CurrentAprType = pAprLineType;
								CurrentAprUserID = pUserID;
					            sendAlertMail("APR", pAprMemberSN, "APPROV");
			                }
			
			                if ((pDraftFlag == "SUSIN" || pAprLineType == strAprType7) && KuyjeType == "001") {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1387'/>";
						        OpenAlertUI(pAlertContent);
						        btnClose_onclick();
						        Btnflag = "false";
						        ChangeBtnState();
						    }
						    else {
						        if (pAprLineType == strAprType7) {
						            process_AfterApprove("4");
						        }
						        else {
						            process_AfterApprove("1");
						        }
						    }
			            }
			        }
			
			        setMenuDisable("btnApprove", false);
			    }
	
			    function btnReject_onclick() {
			        var pInformationContent = "<spring:message code='ezApprovalG.t36'/>";
			        var Ans = OpenInformationUI(pInformationContent);
			        if (!Ans) return;
			        
			        //if ("${approvalPWD}" != "N") {
			        if (CheckUsePassword()) {
				        var chkpass = chk_Passwd(pingUserID);
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
			
			        //var ret = openOpinionUI("BanSong");
			        var ret = openOpinionUI_New("BanSong");
			        if (ret != "cancel" && ret != undefined ) {
			            UpdateLineHistory();
			
			            OrgHtml = HwpCtrl.GetCloneData("", "HWPML2X");
			
			            var rtnVal = ExcuteInfo("BANSONG_BEFORE", "")
			            if (!rtnVal) {
			                var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					        OpenAlertUI(pAlertContent);
					        return;
					    }
			
			            var RtnVal = SaveApproveInfo("2");
			            if (RtnVal != "TRUE") {
			                var rtnVal = ExcuteInfo("BANSONG_FAIL", "")
			                if (!rtnVal) {
			                    var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        return;
						    }
			
			                var pAlertContent = "<spring:message code='ezApprovalG.t1388'/>";
					        OpenAlertUI(pAlertContent);
					        return;
					    }
					    else {
					        var rtnVal = ExcuteInfo("BANSONG_AFTER", "")
					        if (!rtnVal) {
					            var pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
						        OpenAlertUI(pAlertContent);
						        return;
						    }
			                process_AfterApprove("2");
			            }
			        } else if (ret == "cancel" || ret == undefined) {
			        	var pAlertContent = "<spring:message code='ezApprovalG.t38'/>";
			        	OpenAlertUI(pAlertContent);
				        return;
			        }
			    }
	
			    function btnStay_onclick() {
			        var pInformationContent = "<spring:message code='ezApprovalG.t39'/>";
			        var Ans = OpenInformationUI(pInformationContent);
			        if (!Ans) return;
			        
			        //if ("${approvalPWD}" != "N") {
			        if (CheckUsePassword()) {
				        var chkpass = chk_Passwd(pingUserID);
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
			
			        //var ret = openOpinionUI("BoRyu");
			        var ret = openOpinionUI_New("BoRyu");
			        if (ret != "cancel" && ret != undefined) {
			            UpdateLineHistory();
			            var RtnVal = SaveApproveInfo("3");
			
			            if (RtnVal != "TRUE") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t1389'/>";
					        OpenAlertUI(pAlertContent);
					        return;
					    }
					    else {
					        process_AfterApprove("3");
					    }
			        } else if (ret == "cancel" || ret == undefined) {
			        	var pAlertContent = "<spring:message code='ezApprovalG.t392'/>";
			        	OpenAlertUI(pAlertContent);
				        return;
			        }
			    }
	
			    function btnJunKyul_onclick() {
			    	//if ("${approvalPWD}" != "N") {
			    	if (CheckUsePassword()) {
				        var checkpass = chk_Passwd(pingUserID);
				
				        if (checkpass == "False") {
				            var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
					        OpenAlertUI(pAlertContent);
					        return;
				        } else if (checkpass == "cancel" || checkpass == undefined) {
					        var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
				            OpenAlertUI(pAlertContent);
				            return;
				        }
			    	}
			    	
			        isjunkyul = true;
			
			        var rtnVal = upDateAprLine();
			        if (rtnVal == "TRUE") {
			            getCurApproverAprLine();
			            btnApprove_onclick();
			        }
			        else {
			            var pAlertContent = "<spring:message code='ezApprovalG.t1390'/>";
				        OpenAlertUI(pAlertContent);
				    }
			    }
	
			    function btnEdit_onclick() {
			        if (modeflag) {
			            modeflag = false;
			            chkBtnConfirm("1");
			            chkBtn(false);
			
			            beforeHwp = HwpCtrl.GetCloneData("", "HWP");
			
			            HwpCtrl.ChangeMode(2);
			
			            setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t42'/>");
			        } else {
			            var pInformationContent = "<spring:message code='ezApprovalG.t43'/>";
				        var Ans = OpenInformationUI(pInformationContent);
			
				        HwpCtrl.ChangeMode(3);
			
				        setNodeText(btnEdit.childNodes[0], "<spring:message code='ezApprovalG.t44'/>");
			
					    if (Ans) {
					        if (FirstHtml == "") {
					            FirstHtml = beforeHwp;
					        }
					    } else {
					        HwpCtrl.SetCloneData(beforeHwp, "", "HWP");
					    }
			
					    modeflag = true;
					    chkBtnConfirm("2");
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
			                if (HwpCtrl.CheckFieldExist("hrecipients"))
			                    HwpCtrl.SetFieldText("hrecipients", "");
			
			                if (HwpCtrl.CheckFieldExist("recipient"))
			                    HwpCtrl.SetFieldText("recipient", "");
			
			                if (HwpCtrl.CheckFieldExist("recipients"))
			                    HwpCtrl.SetFieldText("recipients", "");
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
			        //openOpinionUI("");
			    	openOpinionUI_New("");
			    }
	
			    function btnFileAttach_onclick() {
			        var ret = openFileAttachUI();
			    }
			
			    function btnAprDocAttach_onclick() {
			        var ret = openAaprDocAttachUI();
			    }
	
			    function btnPrint_onclick() {
			        HwpCtrl.PrintDocument("", true);
			    }
			
			    function btnClose_onclick() {
			        window.close();
			    }
	
			    function window_onbeforeunload() {
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
			    }
	
			    function btnSave_onclick() {
			       /*  HwpCtrl.SetSaveMode(1);
			        HwpCtrl.SetDocumentInfo(pFormID);
			        HwpCtrl.SaveFile("", HwpCtrl.GetFieldText("doctitle"));
			        HwpCtrl.ChangeMode(3); */
			        
			    	window.open("/ezApprovalG/downloadHWPdoc.do?DocId=" + pDocID);
			    }
			
			    function btnMail_onclick() {
			        SaveFile();
					var pheight = window.screen.availHeight;
					var conHeight = pheight * 0.8;
					var pwidth = window.screen.availWidth;
					var conWidth = pwidth * 0.8;
					if (conWidth > 890)
						conWidth = 890;
					var pTop = (pheight - conHeight) / 2;
					var pLeft = (pwidth - 890) / 2;
					var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
					
					var requestUrl = "/ezEmail/mailWrite.do?docHref=" + pDocHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG";
		
					window.open(requestUrl, "", feature);
			        // window.open("/ezEmail/mailWrite.do?docHref=" + pDocHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
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
			    var tempItemName2 = "";
	
			    function btnDocInfo_onclick() {
			        openDocExinfo();
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
			                var xmlCab = createXmlDom();
			                xmlCab.loadXML(g_SelCabXml);
			                cabinetID = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/CABINETID"));
			                TaskCode = getNodeText(xmlCab.selectSingleNode("CABINETINFO/CABINET/TASKCODE"));
			            }
			        } catch (e) {
			            alert("btnSetTaskCode_onclick : " + e.description);
			        }
			    }
	
			    function btnAddSepAttach_onclick() {
			        if (cabinetID == "") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t48'/>";
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
			
			        if (url != "")
			            var rtn = window.showModalDialog(url, para, feature);
			
			        if (rtn[0] == "TRUE") {
			            g_SepAttachLVXml = rtn[1];
			            SetDocumentElement(HwpCtrl, "SepAttachLVXml", g_SepAttachLVXml)
			        }
			    }
			  	//2019-01-18 천성준 - 새로운 HWP 분리첨부 XML파싱 소스 생성
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
			    		alert("ezapprovui_hwp.GetSepAttParamXml() : " + e.description);
			    	}
			    }
	
			    function btnhistory_onclick() {
			        getHistory();
			    }
			    
			    var ezapprovalinfo_dialogArguments = new Array();
			    function btnApprovalInfo() {
			    			        CheckDocCellInfo();
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
			    			        parameter[9] = true;
			    			        parameter[10] = pDocType;
			    			        parameter[11] = gamsaCount;
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
			    				        parameter[51] = sepAttachCheckYN; // 분첨
			    			        }

			    			        if (useOpenGov == "YES") {
			                            parameter[52] = basis;
			                            parameter[53] = reason;
			                            parameter[54] = listOpenFlag;
			                            parameter[55] = fileOpenFlagList;
			    					}

			    			        if (tempItemCode != "")
			    			            tempdocnumcode = tempItemCode;
			                        
			                        ezapprovalinfo_dialogArguments[0] = parameter;
			    		            ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;

			    		            var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType + "&ext=" + "hwp", "ezApprovalInfo", GetOpenWindowfeature(1144, 750));
			    		            try { OpenWin.focus(); } catch (e) { }

			    			        
			                    }

			    function btnApprovalInfo_Complete(ret) {

			    			        if (ret != undefined && ret[0] == "OK") {
			    			            try {
			    			                HwpCtrl.ChangeMode(2);
			    			                if (pGubun != "5" && pGubun != "7" && pGubun != "10") {
			    			
			    			                    if (ret[1] != false) {
			    			                    	$.ajax({
			    			                    		type : "POST",
			    			                    		dataType : "json",
			    			                    		async : false,
			    			                    		url : "/ezApprovalG/aprLineSave.do",
			    			                    		data : {
			    			                    				ret    : ret[1]
			    			                    				},
			    			                    		success : function(result){
			    			                    			
			    			                    		}
			    			                    	});
			    			
			    			                        IsSkipDrafter = "FALSE";
			    			                        btnSendDraftEnable = "true";
			    			                        ReAprLineSingMapping(ret);
			    			                        SaveFile();
			    			                        getCurApproverAprLine();
			    			                    }
			    			                    savexmlhttp = null;
			    			                    savexmlhttp = createXMLHttpRequest();
			    			                }
			    			
			    			                if (pGubun != "6" && pGubun != "7" && pGubun != "9" && pGubun != "11" && pGubun != "12" && pGubun != "13") {
			    			                	$.ajax({
			    		                    		type : "POST",
			    		                    		dataType : "text",
			    		                    		async : false,
			    		                    		url : "/ezApprovalG/aprDeptSave.do",
			    		                    		data : {
			    		                    				aprDeptInfo : ret[2]
			    		                    				},
			    		                    		success : function(result){
			    		                    			if (result == 'TRUE') {
			    		                    				
			    		                    			} else {
			    		                    				alert(strLang163);
			    		                    			}
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

											tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
			    			                tempSecurity = ret[7];                // 보안등급 관련
			    			                tempUrgent = ret[8];                  // 긴급 결재 여부
			    			                pSummery = ret[9];                    // 요약 내용 관련
			    			                tempSecurityDate = ret[14];           // 보안 결재 체크 관련
			    			                pPublicityCode = ret[11];             // 대민공개여부 및 공개등급 관련 
			    			                pPublicityYN = ret[21];             // 공개여부 및 공개등급 관련 
			    			                pSpecialRecordCode = ret[10];
			    			                pLimitRange = ret[12];
			    			                pPageNum = ret[13];
			    			                // 문서 공개 범위 설정 (대민 공개 여부)
			    			                // setPublicFlag2();
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

			    							//2020-05-08 : 결재정보확인 시 문서정보 저장 후 문서 반영
			    							setApprDocInfo();	
			    							SaveFile();

			    			                SummaryFlag = true;
			    			                savexmlhttp = null;
			    			                HwpCtrl.ChangeMode(3);
			    			            }
			    			            catch (e) {
			    			                alert("저장시 오류 발생");
			    			            }
			    			        }

			    }



			    
			    function btnHelper_onclick() {
			        var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT", "");
			        if (!rtnVal) {
			        }
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
	    </script>
	</head>
	<body class="popup" onbeforeunload="return window_onbeforeunload()" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul id="AllApprove">
	                        <li id="btnApprove"><span onclick="return btnApprove_onclick()"><spring:message code='ezApprovalG.t1'/></span></li>
	                        <li id="btnReject"><span onclick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
	                        <li id="btnStay"><span onclick="return btnStay_onclick()"><spring:message code='ezApprovalG.t50'/></span></li>
	                        <span style="display: none">
	                            <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><spring:message code='ezApprovalG.t9994'/></span></li>
	                        </span>
	                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><spring:message code='ezApprovalG.t1742'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnJunKyul" style="display: none"><span onclick="return btnJunKyul_onclick()"><spring:message code='ezApprovalG.t25'/></span></li>
	                        <span style="display: none">
	                            <li id="btnModAprLine"><span onclick="return btnModAprLine_onclick()"><spring:message code='ezApprovalG.t52'/></span></li>
	                        </span>
	                        <span style="display: none">
	                            <li id="btnModAprDept"><span onclick="return btnModAprDept_onclick()"><spring:message code='ezApprovalG.t53'/></span></li>
	                        </span>
	                        <li id="btnEdit"><span onclick="return btnEdit_onclick()"><spring:message code='ezApprovalG.t44'/></span></li>
	                        <span style="display: none">
	                            <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        </span>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><spring:message code='ezApprovalG.t56'/></span></li>
	                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><spring:message code='ezApprovalG.t57'/></span></li>
	                        <li id="btnAddSepAttach"><span onclick="btnAddSepAttach_onclick()"><spring:message code='ezApprovalG.t58'/></span></li>
	                        <li id="btnSave"><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="btnMail" style="display:none"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t62'/></span></li>
	                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><spring:message code='ezApprovalG.t157'/></span></li>
	                        <li id="tbtnTotalSave" style="display: none"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	
	            </td>
	        </tr>
	
	        <tr>
	            <td class="pad1">
	                <div style="height: 100%">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "${hwpToolbar}", "1");</script>
	
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
							<td class="pos2" style="display:none;width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
							</td>
	                    </tr>
	                </table>
	
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	    <xml id="ATTACHINFO"></xml>
	    <xml id="DOCINFO"></xml>
	    <xml id="APRLINEINFO"></xml>
	    <div id="AprMemberSN" style="display: none"></div>
	</body>
</html>