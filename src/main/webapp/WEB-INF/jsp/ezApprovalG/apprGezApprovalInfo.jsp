<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html id="htmlhag" style="overflow:hidden">
	<head>
	    <title><spring:message code='ezApprovalG.t1742'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
	    <script src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/TabMenu.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/TreeView.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/ListView_list.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/AprlineG.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/AprlineV.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/TempLineinfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/LineinfoIni.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/Lineinfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/SelectSubTitles.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/Receptinfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/TempReceptinfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/TempCirculationInfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/Cabinetinfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/CabCategoryInfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/Docinfo.js')}" type="text/javascript"></script>
	    <script src="${util.addVer('/js/ezApprovalG/Draftinfo.js')}" type="text/javascript"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <script src="${util.addVer('/js/Common.js')}" type="text/javascript"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
	    <style type="text/css">
	    	.h2_dot {
	    		background: url(/images/kr/left/left_dot02.gif) no-repeat 0px 70%;
	    	}
	    </style>
	    <script type="text/javascript">
	    	var approvalFlag = "${approvalFlag}";
	        var OrderCell = "";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user"; 							// 사용자-부서구분
	        arr_userinfo[1] = "${userInfo.id}";           // 사용자ID
	        arr_userinfo[2] = "${userInfo.displayName}";      // 사용자명
	        arr_userinfo[3] = "${userInfo.title}";            // 사용자 직위
	        arr_userinfo[4] = "${userInfo.deptID}";           // 사용자 부서 ID
	        arr_userinfo[5] = "${userInfo.deptName}";         // 사용자 부서 이름
	        arr_userinfo[6] = "${userInfo.jikChek}";          // 사용자 직책            
	        arr_userinfo[7] = "N";                                        // 부재중 설정
	        arr_userinfo[8] = "${userInfo.email}";            // E-Mail Address 
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";             // 수신 접수담당자
	        arr_userinfo[11] = "${userInfo.displayName1}"; 	// 사용자명(P)
	        arr_userinfo[12] = "${userInfo.displayName2}"; 	// 사용자명(S)
	        arr_userinfo[13] = "${userInfo.title1}"; 			// 사용자 직위(P)
	        arr_userinfo[14] = "${userInfo.title2}"; 			// 사용자 직위(S)
	        arr_userinfo[15] = "${userInfo.deptName1}"; 		// 사용자 부서 이름(P)
	        arr_userinfo[16] = "${userInfo.deptName2}"; 		// 사용자 부서 이름(S)
	        var CompanyID = "${userInfo.companyID}";
	        var companyID = "${userInfo.companyID}";
	        var UserLang = "${userInfo.lang}";
	        var DeptID = "${userInfo.deptID}";
	        var USE_OCS = "${useOcs}";
	        var linealt1 = "<spring:message code='ezApprovalG.t1742'/>";
	        var linealt2 = "<spring:message code='ezApprovalG.t228'/>";
	        var linealt3 = "<spring:message code='ezApprovalG.t226'/>";
	        var linealt4 = "<spring:message code='ezApprovalG.t227'/>";
	        var linealt5 = "<spring:message code='ezApprovalG.t396'/>";
	        var linealt6 = "<spring:message code='ezApprovalG.t394'/>";
	        var linealt7 = "<spring:message code='ezApprovalG.t395'/>";
	        var linealt8 = "<spring:message code='ezApprovalG.t396'/>";
	        var linealt9 = "<spring:message code='ezApprovalG.t393'/>";
	        var linealt10 = "<spring:message code='ezApprovalG.t399'/>";
	        var linealt11 = "<spring:message code='ezApprovalG.t400'/>";
	        var linealt12 = "<spring:message code='ezApprovalG.t228'/>";
	        var linealt13 = "<spring:message code='ezApprovalG.t2001'/>";
	        var linealt14 = "<spring:message code='ezApprovalG.t322'/>";
	        var linealt15 = "<spring:message code='ezApprovalG.t323'/>";
	        if(approvalFlag == "G"){
	        	var linealt16 = "<spring:message code='ezApprovalG.t324'/>";	
	        } else {
	        	var linealt16 = "<spring:message code='ezApproval.t212'/>";
	        }
	       
	        var linealt17 = "<spring:message code='ezApprovalG.t1178'/>";
	        var Cabinet1 = "<spring:message code='ezApprovalG.t379'/>";
	        var Cabinet2 = "<spring:message code='ezApprovalG.t572'/>";
	        var Cabinet3 = "<spring:message code='ezApprovalG.t573'/>";
	        var Cabinet4 = "<spring:message code='ezApprovalG.t1081'/>";
	        var Cabinet5 = "<spring:message code='ezApprovalG.t1065'/>";
	        var Cabinet6 = "<spring:message code='ezApprovalG.t1160'/>";
	        var Docalt1 = "<spring:message code='ezApprovalG.t1202'/>";
	        var Docalt2 = "<spring:message code='ezApprovalG.t288'/>";
	        var Docalt3 = "<spring:message code='ezApprovalG.t289'/>";
	        var Docalt4 = "<spring:message code='ezApprovalG.t10030'/>";
	        var pUserID = arr_userinfo[1];
	        var tempAprTypeXML = "${aprTypeXML}";
	        var AprTypeXML = createXmlDom();   //Xml Dom 구조
	        var pAprLineTempletFlag = false; //결재선템플릿사용여부플래그
	        var p_CheckAprLineTempletSN;       //사용한 결재선의 Index값 
	        var p_CheckAprLineTempletName;     //[2006.06.14]사용한 결재선의 이름
	        var pDocID;
	        var pFormID;
	        var pSignCount;
	        var pHapYuiCount;
	        var pGamSaCount;
	        var pReDraftFlag;               // 재기안 Flag
	        var pSuSinFlag;                //수신처 셀 Flag
	        var pChamJoFlag;               //참조 셀 Flag
	        var pGongramCount;
	        var pReDraftAprLineFlag;       //재기안 결재선 변경 Flag
	        var chkReDraft = "";
	        var pAprLineArea;
	        var pHapyuiArea;
	        var ppDocType;
	        var pSelAprLineState;
	        var WorkFlowXML = createXmlDom();
	        var WorkFlowString = "";
	        var WorkFlowOption = "AUTO";	// "AUTO" - 로딩시에 자동 입력 및 삭제. else - 확인시에만 체크.
	        var optGamsabu = "${optGamsabu}";        
	        var ProcessorXML = createXmlDom();
	        var InsertMode = "Add";
	        var pAprLineXml = new Array(); // 결재선 , 수신처 Xml Return Value
	        var DeptAddIndex = 1;
	        var Draftinfoini = false;
	        var Lineinfoini = false;
	        var Lineinfoini2 = false;
	        var Recinfoini = false;
	        var Recinfoini2 = false;
	        var Recinfoini3 = false;
	        var Recinfoini4 = false;
	        var Opinionini = false;
	        var internalTab = true;
	        var pSelAprLineType;           // 결재자 선택시 결재방법
	        var pUrgentFlag;
	        var pPublicFlag;
	        var psecuritylevel;
	        var pkeeperiod;
	        var pkeyword;
	        var ret = new Array();
	        var CurAprLine;
	        var pReDraftAprLineChangeFlag = false;
	        var pHapyuiArea = 0;
	        var pAprLineArea = 0;
	        var onlydocinfiview;
	        var onlyviewsusin = false;
	        var pIniGubun = "${guBun}";
	        var AdminYN = "FALSE";
	        var szRoleInfo = "${userInfo.rollInfo}";
	        var g_bRecAdmin = false;	//기록물 관리책임자 여부
	        var g_bDeptCharger = false;	//부서업무 담당자 여부
	        var g_InitFlag = "${initFlag}";
	        var bDisplayFlag = "0";
	        var bSpecialFlag = "0";
	        var arrTask = new Array();
	        var rtnVal = new Array();
	        var g_SelCabID = "";
	        var pItemCode = "";
	        var pItemName = "";
	        var pItemName2 = "";
	        var APRLINE = "";
	        var vSecurity, vAprUrgency, vSummery, vAprSecurity;
	        var vdocdisplay, vPublicFlag, vPublicFlag2 , vtreatment, vPageNum;
	        var chkReporter = false;
	        var chkSuggester = false;
	        var SummaryFlag;
	        var pDocSn = "${docSN}";
	        var SusinGroupUseFlag = "${susinGroupUseFlag}";
	        /* 2015-06-23 추가 - KSK */
	        var T1361andT1362 = "<spring:message code='ezApprovalG.t1361'/>" + "<br>" + "<spring:message code='ezApprovalG.t1362'/>";
	        var SummaryOuterReceiverList = "";
			var useAddressOpenAPI = "${useAddressOpenAPI}";
			var checkdocinfo = false;
			var startDateTime = '${startDateTime}';
			var pSignImage_Size = "${signImageSize}";
			var pAdmin = "N";
			var pGongRamDocID;
			//기안(DRAFT), 접수(RECV), 합의(HABYUI) 여부
			var approvalType;
			var chamjoAfterYN = "${chamjoAfterYN}";
			var isUsed = "${isUsed}";
			var beforeDocID = "${beforeDocID}";
			var receptGubunYN = "${receptGubunYN}";
			var addLastKyulJeYN = "${addLastKyulJeYN}";
	        var ext = "${ext}";
	        var nonElecRec = "";
	        var nonElecRecInfoXml = "";
	        var g_CabID = "";
	        var useReceiveInfoName = "${useReceiveInfoName}";
	        
	        $(function () {
	        	if (document.getElementById("AprSecurity").checked){
	        		$("#idDatepicker").attr('disabled',false);
	        	} else {
	        		$("#idDatepicker").attr('disabled',true);
	        	}
	        	
	        	$("#idDatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
				
	        	initdatepicker();
	        });
	        
	        window.onload = function () {        	
	        	if(approvalFlag == "G") {
	        		$(".approvalG").css("display","");
	        		$(".approval").css("display","none");
	        	} else{
	        		$(".approvalG").css("display","none");
	        		$(".approval").css("display","");
	        	}
	        	
	            if (MACSAFARIYN()) {
	                window.resizeBy(0, 35);
	            }
	            /* if (screen.height >= 900) {
	                document.getElementById("orgbtnArea").style.display = "";
	                document.getElementById("btnArea").style.display = "none";
	            }
	            else {
	                document.getElementById("orgbtnArea").style.display = "none";
	                document.getElementById("btnArea").style.display = "inline";
	            } */
	
	            GetDocInfo(); 
	            AprTypeXML = loadXMLString(tempAprTypeXML);
	            ChangeTab(document.getElementById("1tab1"));
	            document.getElementById('textUser').focus();            
	            if (SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0] == null) {
	                document.getElementById("deptaddbtn").style.display = "none";
	            }
            
	            if(approvalFlag == "G") {
		            CheckGubunInit();
		
		            if (pReDraftFlag == "DRAFT") {
		                document.getElementById("btnaddress").style.display = "";
		            }
		            if (window.screen.height <= 768) {
		                window.resizeTo(1000, 720);
		                document.getElementById("bodytag").style.overflow = "auto";
		                document.getElementById("htmlhag").style.overflow = "auto";
		            }
	            } else {
	            	//회람 추가
	            	if (approvalType != "DRAFT") {
	            		document.getElementById("showHRAprLine").style.display = "none";
	            	}
	            	 try {
	                     if (pIniGubun == "1") {
	                         if (CrossYN())
	                             document.getElementById("1tab1").onclick();
	                         else
	                             document.getElementById("1tab1").click();
	                     }
	                     else if (pIniGubun == "2") {
	                         if (CrossYN())
	                             document.getElementById("1tab2").onclick();
	                         else
	                             document.getElementById("1tab2").click();
	                     }
	                     else if (pIniGubun == "3") {
	                         if (CrossYN())
	                             document.getElementById("1tab3").onclick();
	                         else
	                             document.getElementById("1tab3").click();
	                     }
	                     else if (pIniGubun == "4") {
	                         if (CrossYN())
	                             document.getElementById("1tab4").onclick();
	                         else
	                             document.getElementById("1tab4").click();
	                     }
	                     else if (pIniGubun == "5") {
	                         if (CrossYN())
	                             document.getElementById("1tab2").onclick();
	                         else
	                             document.getElementById("1tab2").click();
	                     }
	                     else if (pIniGubun == "10") { //수신자
	                    	onlydocinfiview = true;
	     	                document.getElementById("showDocinfo").style.display = "none";
	     	                document.getElementById("showAprLine").style.display = "none";
	     	                document.getElementById("showCabinetinfo").style.display = "none";
	     	                document.getElementById("Lineinfo").style.display = "none";
	     	                document.getElementById("Cabinetinfo").style.display = "none";
	     	                document.getElementById("Docinfo").style.display = "none";
	     	                document.getElementById("1tab2").onclick();
	     	                ChangeTab(document.getElementById("1tab2"));
	     	             }
	                     else if (pIniGubun == "14") { //결재선 뺴고
	     	                document.getElementById("showAprLine").style.display = "none";
	     	                document.getElementById("Lineinfo").style.display = "none";
	     	                document.getElementById("1tab2").onclick();
	     	                ChangeTab(document.getElementById("1tab2"));
	     	                liniReceptOuter();
	     	            }
	                 }
	                 catch (e) {
	                 }
	                     if (pHapYuiCount == 0) {
	                         document.getElementById("deptaddbtn").style.display = "none";
	                 }

	            }
	        };
	
	        function KeEventControl(obj) {
	            useragt = navigator.userAgent.toUpperCase();
	            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
	            {
	                useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
	                if (parseInt(useragt) > 5) {
	                    return;
	                }
	            }
	            obj.onkeydown = function () {
	                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
	                    return false;
	                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
	                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
	                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
	                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
	                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
	                    return false;
	            };
	        }
	        var RetValue;
	        var ReturnFunction;
	        function GetDocInfo() {
	            try {
	                RetValue = parent.ezapprovalinfo_dialogArguments[0];
	                ReturnFunction = parent.ezapprovalinfo_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.ezapprovalinfo_dialogArguments[0];
	                    ReturnFunction = opener.ezapprovalinfo_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            pDocID = RetValue[0];        //문서ID
	            pFormID = RetValue[1];        //FormID
	            pSignCount = RetValue[2];        //사인칸 수
	            pSignInfo = RetValue[3];        //사인정보
	            pHapYuiCount = RetValue[4];        //합의칸 수
	            pReDraftFlag = RetValue[5];        //재기안 Flag : REDRAFT / DRAFT
	            pSuSinFlag = RetValue[6];        //수신자유뮤 Flag : Y  / N
	            pChamJoFlag = RetValue[7];        //참조유무 Flag : Y / N
	            pGongramCount = RetValue[8];       //공람수
	            pReDraftAprLineFlag = RetValue[9]; //결재기:결재선 변경 Flag
	            pDocType = RetValue[10];
	            pGamSaCount = RetValue[11];
	            approvalType = RetValue[12];
	            chkReDraft = RetValue[13];
	            if (pReDraftAprLineFlag) pOrgApruserid = RetValue[13];

	            onlyviewsusin = RetValue[27];
	            onlydocinfiview = RetValue[28];
	            pItemCode = RetValue[29];
	            pkeeperiod = RetValue[20];
	            pItemName = RetValue[41];
	            pItemName2 = RetValue[42];
	            pUrgentFlag = RetValue[32];
	            psecuritylevel = RetValue[31]; 
	            pPublicFlag = RetValue[35];
	            g_SelCabID = RetValue[30];
	            //문서정보 추가
	            vSecurity = RetValue[31];
	            vAprUrgency = RetValue[32];
	            vSummery = RetValue[33];
	            vdocdisplay = RetValue[34];
	            vPublicFlag = RetValue[35];
	            vtreatment = RetValue[36];
	            vPageNum = RetValue[37];
// 	            vAprSecurity = trim(RetValue[38]);
	            vAprSecurity = RetValue[38];
	            SummaryFlag = RetValue[39];
	            vPublicFlag2 = RetValue[45];
	            
	            nonElecRec = RetValue[46];
	            
	            if (nonElecRec == "Y") {
	            	g_CabID = RetValue[47];
	            	nonElecRecInfoXml = RetValue[48];
	            	g_SepAttachLVXml = RetValue[49];
	            	g_szSCListXml = RetValue[50];
	            	sepAttachCheckYN = RetValue[51];
	            }
	            
	            if (pSuSinFlag == "N" || pDocType == "002") {
	                document.getElementById("showReceptinfo").style.display = "none";//.innerHTML = "";
	            }
	            
	            if (approvalFlag == "S") {
		            if (g_SelCabID != "") {
		            	document.getElementById("cabinetID").value = g_SelCabID;
		            }
	            }
	
	            try {
	                //2015-06-30 표준모듈:추가(외부수신자요약) - KSK
	                SummaryOuterReceiverList = RetValue[40];
	                if (SummaryOuterReceiverList != "" && SummaryOuterReceiverList != undefined) {
	                    document.getElementById("inputSummaryOuterReceiverList").value = SummaryOuterReceiverList;
	                    document.getElementById("trSummaryOuterReceiverList").style.display = "";
	                }
	            } catch (e) { alert(e.description); }
	        }
	        function CheckGubunInit() {
	            if (pIniGubun == "1") {
	                document.getElementById("1tab1").onclick();
	                document.getElementById("2tab1").onclick();
	                liniReceptOuter();
	            }
	            else if (pIniGubun == "2") {
	                document.getElementById("1tab2").click();
	                liniReceptOuter();
	            }
	            else if (pIniGubun == "3") {
	                document.getElementById("1tab3").onclick();
	                liniReceptOuter();
	            }
	            else if (pIniGubun == "4") {
	                document.getElementById("1tab4").onclick();
	                liniReceptOuter();
	            }
	            else if (pIniGubun == "5") { //수신자, 결재정보
	            	//기안문일경우 수신자탭 안뜨게 하기위해 if문 추가 2018-07-25 강민수92
	            	if (pDocType == "002") {
		                document.getElementById("showAprLine").style.display = "none";
		                document.getElementById("showCabinetinfo").style.display = "none";
		                document.getElementById("Lineinfo").style.display = "none";
		                document.getElementById("Cabinetinfo").style.display = "none";
		                document.getElementById("1tab4").onclick();
	                	ChangeTab(document.getElementById("1tab4"));
	            	} else {
		                document.getElementById("showAprLine").style.display = "none";
		                document.getElementById("showCabinetinfo").style.display = "none";
		                document.getElementById("Lineinfo").style.display = "none";
		                document.getElementById("Cabinetinfo").style.display = "none";
		                document.getElementById("1tab2").onclick();
		                ChangeTab(document.getElementById("1tab2"));
		                liniReceptOuter();
	            	}
	            }
	            else if (pIniGubun == "6") { //결재선, 결재정보
	                document.getElementById("showReceptinfo").style.display = "none";
	                document.getElementById("showCabinetinfo").style.display = "none";
	                document.getElementById("Receptinfo").style.display = "none";
	                document.getElementById("Cabinetinfo").style.display = "none";
	                document.getElementById("1tab1").onclick();
	                document.getElementById("2tab1").onclick();
	            }
	            else if (pIniGubun == "7") { //결재정보
	                document.getElementById("showAprLine").style.display = "none";
	                document.getElementById("showReceptinfo").style.display = "none";
	                document.getElementById("showCabinetinfo").style.display = "none";
	                document.getElementById("Lineinfo").style.display = "none";
	                document.getElementById("Receptinfo").style.display = "none";
	                document.getElementById("Cabinetinfo").style.display = "none";
	                document.getElementById("1tab4").onclick();
	                ChangeTab(document.getElementById("1tab4"));
	            }
	            else if (pIniGubun == "8") { //결재선, 수신자, 결재정보
	                document.getElementById("showCabinetinfo").style.display = "none";
	                document.getElementById("Cabinetinfo").style.display = "none";
	                document.getElementById("1tab1").onclick();
	                document.getElementById("2tab1").onclick();
	                liniReceptOuter();
	            }
	            else if (pIniGubun == "9") { //결재선
	                document.getElementById("showDocinfo").style.display = "none";
	                document.getElementById("showReceptinfo").style.display = "none";
	                document.getElementById("showCabinetinfo").style.display = "none";
	                document.getElementById("Receptinfo").style.display = "none";
	                document.getElementById("Cabinetinfo").style.display = "none";
	                document.getElementById("Docinfo").style.display = "none";
	                document.getElementById("1tab1").onclick();
	                document.getElementById("2tab1").onclick();
	            }
	            else if (pIniGubun == "10") { //수신자
	                document.getElementById("showDocinfo").style.display = "none";
	                document.getElementById("showAprLine").style.display = "none";
	                document.getElementById("showCabinetinfo").style.display = "none";
	                document.getElementById("Lineinfo").style.display = "none";
	                document.getElementById("Cabinetinfo").style.display = "none";
	                document.getElementById("Docinfo").style.display = "none";
	                document.getElementById("1tab2").onclick();
	                ChangeTab(document.getElementById("1tab2"));
	                liniReceptOuter();
	            }
	            else if (pIniGubun == "11") { //결재선, 기록물철, 결재정보
	                document.getElementById("showReceptinfo").style.display = "none";
	                document.getElementById("Receptinfo").style.display = "none";
	                document.getElementById("1tab1").onclick();
	                document.getElementById("2tab1").onclick();
	            }
	            else if (pIniGubun == "12") { //기록물철, 결재정보
	                document.getElementById("showAprLine").style.display = "none";
	                document.getElementById("showReceptinfo").style.display = "none";
	                document.getElementById("Lineinfo").style.display = "none";
	                document.getElementById("Receptinfo").style.display = "none";
	                document.getElementById("1tab3").onclick();
	                ChangeTab(document.getElementById("1tab3"));
	            }
	            else if (pIniGubun == "13") { //기록물철
	                document.getElementById("showAprLine").style.display = "none";
	                document.getElementById("showReceptinfo").style.display = "none";
	                document.getElementById("showDocinfo").style.display = "none";
	                document.getElementById("Lineinfo").style.display = "none";
	                document.getElementById("Receptinfo").style.display = "none";
	                document.getElementById("Docinfo").style.display = "none";
	                document.getElementById("1tab3").onclick();
	                ChangeTab(document.getElementById("1tab3"));
	            }
	            if (pHapYuiCount == 0) {
	                document.getElementById("deptaddbtn").style.display = "none";
	            }
	            
	            if (nonElecRec == "Y" && pIniGubun == "1") { // 비전자문서등록 - 문서정보, 기록물정보
                    document.getElementById("showAprLine").style.display = "none";
                    document.getElementById("showReceptinfo").style.display = "none";
                    document.getElementById("showCabinetinfo").style.display = "none";
                    document.getElementById("showDocinfo").style.display = "";
                    document.getElementById("showNonElecRecInfo").style.display = "";
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "";
                    document.getElementById("NonElecRecInfo").style.display = "";
                    document.getElementById("1tab6").onclick();
                    ChangeTab(document.getElementById("1tab6"));
                } else if (nonElecRec == "Y" && pIniGubun == "11") { // 비전자문서등록 - 결재선, 기록물철, 문서정보, 기록물정보
                	document.getElementById("showAprLine").style.display = "";
                    document.getElementById("showReceptinfo").style.display = "none";
                    document.getElementById("showCabinetinfo").style.display = "";
                    document.getElementById("showDocinfo").style.display = "";
                    document.getElementById("showNonElecRecInfo").style.display = "";
                    document.getElementById("Lineinfo").style.display = "";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "";
                    document.getElementById("Docinfo").style.display = "";
                    document.getElementById("NonElecRecInfo").style.display = "";
                    document.getElementById("1tab1").onclick();
                    ChangeTab(document.getElementById("1tab1"));
                } else if (nonElecRec == "Y" && pIniGubun == "6") {
                	document.getElementById("showAprLine").style.display = "";
                    document.getElementById("showReceptinfo").style.display = "none";
                    document.getElementById("showCabinetinfo").style.display = "none";
                    document.getElementById("showDocinfo").style.display = "";
                    document.getElementById("showNonElecRecInfo").style.display = "";
                    document.getElementById("Lineinfo").style.display = "";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "";
                    document.getElementById("NonElecRecInfo").style.display = "";
                    document.getElementById("1tab1").onclick();
                    ChangeTab(document.getElementById("1tab1"));
                }
	        }
	
	        var bool = false;
	        var bool2 = false;
	        var bool3 = false;
	        var bool4 = false;
	        var bool5 = false;
	        var bool6 = false;
	        // 결재정보 창에서 보이는 탭 이동 관련 함수.
	        function ChangeTab(obj) {
	            //DisabledTab();
	            var pSelectTab = obj.getAttribute("divname");
	            document.getElementById(pSelectTab).style.display = "";
	
	            switch (pSelectTab) {
	                case "Lineinfo":
	                    document.getElementById("Receptinfo").style.display = "none";
	                    document.getElementById("Cabinetinfo").style.display = "none";
	                    document.getElementById("Docinfo").style.display = "none";

	                    if (approvalFlag == "G") {
	                    	document.getElementById("NonElecRecInfo").style.display = "none";
	                    }
	                    
	                    if (approvalFlag == "S") {
		                    document.getElementById("Circulation").style.display = "none";
	                    }
	                    
	                    if (!bool) {
	                        Lineinfo_ini();
	                    }
	                    bool = true;
	                    break;
	                case "Receptinfo":
	                    document.getElementById("Lineinfo").style.display = "none";
	                    document.getElementById("Cabinetinfo").style.display = "none";
	                    document.getElementById("Docinfo").style.display = "none";

	                    if (approvalFlag == "G") {
		                    document.getElementById("NonElecRecInfo").style.display = "none";
	                    }
	                    
	                    if (approvalFlag == "S") {
		                    document.getElementById("Circulation").style.display = "none";
	                    }
	                    
	                    if (!bool2) {
	                        Receptinfo_ini();
	                    }
	                    bool2 = true;
	                    break;
	                case "Cabinetinfo":
	                    document.getElementById("Lineinfo").style.display = "none";
	                    document.getElementById("Receptinfo").style.display = "none";
	                    document.getElementById("Docinfo").style.display = "none";
	                    
	                    if (approvalFlag == "G") {
		                    document.getElementById("NonElecRecInfo").style.display = "none";
	                    }
	                    
	                    if (approvalFlag == "S") {
		                    document.getElementById("Circulation").style.display = "none";
	                    }
	                    
	                    if (!bool3) {
	                    	if (approvalFlag == "G") {
		                        Cabinetinfo_ini();
		                        //Docinfo_ini();
		                        
			                    bool3 = true;
			                    //bool4주석처리 이유,결재정보창에서 기록물철을 먼저 선택했을 시 문서정보의 쪽수에 디폴트를 찍어주지 못한다. 
			                    //bool4 = true;
	                    	} else {
	                    		Draftinfo_ini();
			                    bool3 = true;
	                    	}
	                    }
	                    break;
	                case "Docinfo":
	                    document.getElementById("Lineinfo").style.display = "none";
	                    document.getElementById("Receptinfo").style.display = "none";
	                    document.getElementById("Cabinetinfo").style.display = "none";
	                    
	                    if (approvalFlag == "G") {
		                    document.getElementById("NonElecRecInfo").style.display = "none";
	                    }
	                    
	                    if (approvalFlag == "S") {
		                    document.getElementById("Circulation").style.display = "none";
	                    }
	                    
	                    if (approvalFlag == "G") {
		                    if (!bool4) {
		                        Docinfo_ini();
		                    }
	                    } else {
		                    if (!bool3) {
		                    	Draftinfo_ini();
		                    }
		                    if (!bool4)
		                    	CheckDraftinfo();
		                    
		                    bool3 = true;
	                    }
	                    
	                    bool4 = true;
	                    break;
	                case "Opinioninfo":
	                    break;
					//회람 추가
	                case "Circulation":
	                	document.getElementById("Lineinfo").style.display = "none";
	                    document.getElementById("Receptinfo").style.display = "none";
	                    document.getElementById("Cabinetinfo").style.display = "none";
	                    document.getElementById("Docinfo").style.display = "none";
	                    if (!bool5)
	                        circulation_ini();
	                    bool5 = true;
	                    break;
	                    
	                case "NonElecRecInfo":
	                    document.getElementById("Lineinfo").style.display = "none";
	                    document.getElementById("Receptinfo").style.display = "none";
	                    document.getElementById("Cabinetinfo").style.display = "none";
	                    document.getElementById("Docinfo").style.display = "none";
	                    
	                    if (!bool6) {
	                    	nonElecRecInit();
	                    }
	                    setCabInfoInit();
	                    
	                    if (pIniGubun == "1") {
		                    bool3 = true;
	                    }
	                    
	                    bool6 = true;
	                    break;
	            }
	        }
	
	        //발의자여부
	        function Suggester_onclick() {
	            try {
	                var pAPRLINE = new ListView();      //// ListView 선언
	                pAPRLINE.LoadFromID("lvAPRLINE");
	
	                var CurSelRow = pAPRLINE.GetSelectedRows();
	
	                if (CurSelRow.length <= 0) {
	                    OpenAlertUI("<spring:message code='ezApprovalG.t389'/>");
		            Suggester.checked = false;
		            return;
			        }
		
		            if (CurSelRow.length > 0) {
		
		                var pSelectedRow = pAPRLINE.GetSelectedRows();
		                if (pSelectedRow) {
		                    var RCheckVal = Suggester.checked;
		                    var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
		                }
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t389'/>");
		                Suggester.checked = false;
		                return;
		            }
		
		            var pTmpAprLineType;
		            pTmpAprLineType = "003";
		            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");
		
		            if (pSelectedRow.length != 0 && (p_CurAprStat != pTmpAprLineType || pReDraftFlag == "REDRAFT")) {
		
		                if (RCheckVal) {
		                    SetAttribute(pSelectedRow[0], "DATA8", "Y");
		                    if (CrossYN()) {
		                        if (pSelectedRow[0].cells[0].textContent.indexOf("★") == -1)
		                            pSelectedRow[0].cells[0].textContent = "★" + pSelectedRow[0].cells[0].textContent;
		                    }
		                    else {
		                        if (pSelectedRow[0].cells[0].innerText.indexOf("★") == -1)
		                            pSelectedRow[0].cells[0].innerText = "★" + pSelectedRow[0].cells[0].innerText;
		                    }
		                    chkSuggester = true;
		                } else {
		                    SetAttribute(pSelectedRow[0], "DATA8", "N");
		                    var rep = /★/g;
		                    if (CrossYN()) {
		                        pSelectedRow[0].cells[0].textContent = pSelectedRow[0].cells[0].textContent.replace(rep, "");
		                    }
		                    else {
		                        pSelectedRow[0].cells[0].innerText = pSelectedRow[0].cells[0].innerText.replace(rep, "");
		                    }
		                    chkSuggester = false;
			            }
			        }
		        } catch (e) {
		            alert("Suggester_onclick :: " + e.description);
		        }
		    }
		
		    //보고자여부
		    function Reporter_onclick() {
		        try {
		            var pAPRLINE = new ListView();
		            pAPRLINE.LoadFromID("lvAPRLINE");
		
		            var CurSelRow = pAPRLINE.GetSelectedRows();
		
		            if (CurSelRow.length <= 0) {
		                OpenAlertUI("<spring:message code='ezApprovalG.t390'/>");
			            Reporter.checked = false;
			            return;
			        }
		
		            if (CurSelRow.length > 0) {
		                var pSelectedRow = pAPRLINE.GetSelectedRows();
		                if (pSelectedRow) {
		                    var RCheckVal = Reporter.checked;
		                    var p_CurAprStat = pSelectedRow[0].cells[5].innerText;
		                }
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t390'/>");
		                Reporter.checked = false;
		                return;
		            }
		
		            var pTmpAprLineType;
		
		            pTmpAprLineType = "003";
		            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");
		            if (pSelectedRow.length != 0 && (p_CurAprStat != pTmpAprLineType || pReDraftFlag == "REDRAFT")) {
		                if (RCheckVal) {
		                    SetAttribute(pSelectedRow[0], "DATA9", "Y");
		                    if (CrossYN()) {
		                        if(pSelectedRow[0].cells[0].textContent.indexOf("⊙") == -1)
		                            pSelectedRow[0].cells[0].textContent = "⊙" + pSelectedRow[0].cells[0].textContent;
		                    }
		                    else {
		                        if(pSelectedRow[0].cells[0].innerText.indexOf("⊙") == -1)
		                            pSelectedRow[0].cells[0].innerText = "⊙" + pSelectedRow[0].cells[0].innerText;
		                    }
		                    chkReporter = true;
		                } else {
		                    SetAttribute(pSelectedRow[0], "DATA9", "N");
		                    var rep = /⊙/g;
		                    if (CrossYN()) {
		                        pSelectedRow[0].cells[0].textContent = pSelectedRow[0].cells[0].textContent.replace(rep, "");
		                    }
		                    else {
		                        pSelectedRow[0].cells[0].innerText = pSelectedRow[0].cells[0].innerText.replace(rep, "");
		                    }
		                    chkReporter = false;
		                }
		            }
		        } catch (e) {
		            alert("Reporter :: " + e.description);
		        }
		    }
		
		
		    function btnSearchDept_onKeyPress(e) {
		        if (e.keyCode == "13") {
		            document.getElementById("Span2").onclick();
		        }
		    }
		    function btnSearchDept_onKeyPress2(e) {
		        if (e.keyCode == "13") {
		            document.getElementById("Span7").onclick();
		        }
		    }
		
		
		    function getGyulJeDateDB() {
		        try {
		            var xmlhttp = createXMLHttpRequest();
		 
		            xmlhttp.open("POST", "/ezApprovalG/getDate.do", false);
		            xmlhttp.send();
		
		            return xmlhttp.responseText;
		        }
		        catch (e) {
		            alert("getGyulJeDateDB()" + e.description);
		        }
		    }
		    
		    function checkReceptLine() {
		    	var listview = new ListView();
		        listview.LoadFromID("lvRECEPTLIST");
		        var receptRow = listview.GetDataRows();

		        var CurListLen = receptRow.length;
		        if (CurListLen == 0 || (CurListLen == 1 && receptRow[0].id == "lvRECEPTLIST_TR_noItems")) {
		            OpenAlertUI(linealt14);
		            var tabshow = document.getElementById("1tab2");
		            Tab1_MouseClick(tabshow);
		            return false;
		        }
		        
		        return true;
		    }
		
		    function btn_OK() {
		        try {
		            if (!onlydocinfiview) {
		                var line = Checkline();
		                if (line == false) {
		                    return;
		                }

		                if (approvalFlag == "G") {
			                if (pIniGubun != 5 && pIniGubun != 7 && pIniGubun != 10 && pIniGubun != 12) {
			                    var rtnVal = CheckSignCellValueLast();
			
			                    if (!rtnVal)
			                        return;
			                }
			                
			                if (pIniGubun != 5 && pIniGubun != 6 && pIniGubun != 7 && pIniGubun != 8 && pIniGubun != 9 && pIniGubun != 10) {
		                    	if (nonElecRec != "Y" || pIniGubun == "11") {
				                    var List = new ListView();
				                    List.LoadFromID("DivTaskSCateList");
				
				                    var MyList = new ListView();
				                    MyList.LoadFromID("DivMyTaskSCateList");
				
				                    var totalRows = List.GetSelectedRows();
				                    var MyRows = MyList.GetSelectedRows();
				                    if (totalRows.length == 0 && MyRows.length == 0) {
				                        OpenAlertUI(Cabinet4);
				                        document.getElementById("1tab3").onclick();
				                        return;
				                    } else {
				                        if (MyRows.length > 0) {
				                            if (GetAttribute(MyRows[0], "DATA1") == "") {
				                                OpenAlertUI(Cabinet4);
				                                document.getElementById("1tab3").onclick();
				                                return;
				                            }
				                            else
				                                totalRows = MyRows;
				                        } else if (totalRows.length > 0) {
				                            if (GetAttribute(totalRows[0], "DATA1") == "") {
				                                OpenAlertUI(Cabinet4);
				                                document.getElementById("1tab3").onclick();
				                                return;
				                            }
				                        }
				                    }
		                    	}
			                }

			                if (SummaryFlag) {
			                    Docinfo_ini();
			                }
			
			                var chkDocinfoFlag = checkDocinfo();
			                if (!chkDocinfoFlag) {
			                    var tabshow = document.getElementById("1tab4");
			                    Tab1_MouseClick(tabshow);
			                    return;
			                }
			                
			                ret[0] = "OK";
			                ret[1] = SaveAprLineList(); //결재선 저장 XML
		                } else {
		                    var lineArea = CheckLineArea();

		                    if (!lineArea)
		                        return;

		                    var lineuser = SCheckLineUser();
		                    if (lineuser == false) {
		                        return;
		                    }

		                    //회람
		                    var lineUserCC = CheckAprlineCC();
		                    
		                    if (lineUserCC == 1 || lineUserCC == 2) {
		                    	ret[22] = APRLINEXMLParsingCC();
		                    } else if (lineUserCC == -1) {
		                    	ret[22] = "noItem";
		                    } else if (lineUserCC == 0) {
		                    	ret[22] = "sameItem";
		                    }

		                	docinfo = MakeDocInfo();
		                	ReDraftSaveAprLine();
			                ret[0] = "OK";
			                ret[1] = SAPRLINETEMPLETXMLParsing(); //결재선 저장 XML
		                }
		
		                CheckAprPerson();
		                var listview = new ListView();
		                listview.LoadFromID("lvRECEPTLIST");
		                var receptRow = listview.GetDataRows();
		
		                if (receptRow.length > 0 && receptRow[0].id.indexOf("noItems") == -1 && pDocType != "002") {
		                    ret[2] = AprDeptListXML(); //수신자 저장 XML
		                    ret[3] = MakertnVal(); //문서 매핑 XML
		                }
		                else
		                    ret[2] = "";
		
		                if (pIniGubun != 5 && pIniGubun != 6 && pIniGubun != 7 && pIniGubun != 8 && pIniGubun != 9 && pIniGubun != 10) {
			                if (approvalFlag == "G") {
			                    ret[4] = GetSelCabInfoXml(totalRows); //기록물철 XML
			                    var cabinetXml = loadXMLString(ret[4]);
			                    var cabIdNode = SelectNodes(cabinetXml, "CABINETINFO/CABINET/CABINETID");
			                    var cabIdValue = getNodeText((cabIdNode)[0]);
			                    if (cabIdValue == "null" || cabIdValue == "") {
			                    	OpenAlertUI("<spring:message code='ezApprovalG.t1117'/>");
			                    	return;
			                    }
			                } else {
			                	ret[4] = setCabInfoXML();
			                }
		                }
	
		                if (pReDraftAprLineChangeFlag || pReDraftFlag == "REDRAFT") {
		                    ret[5] = "R";
		                } else {
		                    ret[5] = "C";
		                }
		
		                if (approvalFlag == "G") {
			                ret[7] = selSecLevel.value;
			                
			                if (AprUrgency.checked)
			                    ret[8] = "Y";
			                else
			                    ret[8] = "N";
		                } else {
			                ret[7] = SelectSingleNodeValueNew(docinfo, "PARAMETER/psecuritylevel");
			                ret[8] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pUrgentFlag");
			                ret[16] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pkeeperiod");
			                ret[17] = SelectSingleNodeValueNew(docinfo, "PARAMETER/tbItemName");
			                ret[18] = SelectSingleNodeValueNew(docinfo, "PARAMETER/tbItemName2");
			                ret[19] = SelectSingleNodeValueNew(docinfo, "PARAMETER/psecuritylevelvaltemp");
			                ret[20] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pkeeperiodvaltemp");
		                }
		                ret[9] = document.getElementById("taSummery").value;

		                if (approvalFlag == "G") {
			                ret[10] = getdocdisplay();
			                ret[11] = getPublicFlag();
			                ret[12] = txtLimitRange.value;
			                ret[13] = txtPageNum.value;
			                ret[21] = getPublicFlag2();
		                } else {
		                	ret[11] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pPublicFlag");
		                	ret[12] = "";
		                	ret[13] = "";
		                	ret[21] = "";
		                }
	
		                if (document.getElementById("AprSecurity").checked)
		                    ret[14] = document.getElementById("idDatepicker").value.substring(0, 10);
		                else
		                    ret[14] = "";
		
		                if (approvalFlag == "G") {
			                if (document.getElementById("inputSummaryOuterReceiverList").value != "") {
			                    ret[15] = document.getElementById("inputSummaryOuterReceiverList").value;
			                } else {
			                    ret[15] = "";
			                }
			                
			                if (nonElecRec == "Y") {
			                	if (!bool6) {
			                    	nonElecRecInit();
			                    }
			                	
			                	if (pIniGubun == "11") {
			                		setCabInfoInit();
			                	} else if (!CheckInputField()) { // 기록물정보 입력란 유효성 검사
			                		return;
			                	}
			                	
			                	if (g_SepAttachLVXml != "") {
			                		if (sepAttachCheckYN != "TRUE" && pIniGubun != "6") {
			                			OpenAlertUI("분리첨부가 있습니다. 확인해주세요.");
			                			document.getElementById("1tab6").onclick();
			    		                return;
			                		}
			                	}
			                	
			                	ret[23] = getNonElecRecInfo(); // 비전자문서 기본등록사항 + 분리첨부 + 특수목록
			                	ret[24] = g_SepAttachLVXml; // 분리첨부
			                	ret[25] = g_szSCListXml; // 특수목록
			                	ret[26] = sepAttachCheckYN; // 분리첨부 확인여부
			                }
		                }
		
		                if (ReturnFunction != null) {
		                    ReturnFunction(ret);
		                }
		                else {
		                    window.returnValue = ret;
		                }
		                
		                window.close();
		            }
		            else {
		            	if (approvalFlag == "S") {
		            		if (onlyviewsusin) {
		            			if (!checkReceptLine()) {
		            				return ;
		            			}
		            			
		                        ret[0] = "OK";
		                        ret[2] = AprDeptListXML();
		                        ret[5] = MakertnVal();
		                        
		                        if (ReturnFunction != null) {
				                    ReturnFunction(ret);
				                } else {
				                    window.returnValue = ret;
				                }
		                    } else {
		                        var docinfo = MakeDocInfo();
		                        ret[0] = "OK";
		                        ret[1] = docinfo;
		                        ret[6] = "OnlyDocInfo";
		                        
		                        if (ReturnFunction != null) {
				                    ReturnFunction(ret);
				                } else {
				                    window.returnValue = ret;
				                }
		                    }
		            	} else {
			                var docinfo = MakeDocInfo();
			                ret[0] = "OK";
			                ret[1] = docinfo;
			                ret[6] = "OnlyDocInfo";
		            	}
		            	
                        window.close();
		            }
		        }
		        catch (e) {
		            OpenAlertUI("<spring:message code='ezApprovalG.t1600'/>");
		            ret[0] = "FALSE";
		        }
		    }
		    
		    function setCabInfoXML() {
		    	var i;
		        var rtnXml = createXmlDom();
		        var Root, objItem, objData;
		        
		        Root = createNodeInsert(rtnXml, Root, "CABINETINFO");
		        objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "CABINET");
		        createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETID", document.getElementById("cabinetID").value);
		        createNodeAndAppandNodeText(rtnXml, objItem, objData, "TASKCODE", document.getElementById("tbItemCode").value);
		        
		        return getXmlString(rtnXml);
		    }
		
		    function CheckAprPerson() {  	    	
		        var pAPRLINE = new ListView();
		        pAPRLINE.LoadFromID("lvAPRLINE");
		
		        var msg = "";
		
		        for (var i = 0; i < pAPRLINE.GetRowCount() ; i++) {
		            msg += "'" + document.getElementById("lvAPRLINE").childNodes[1].childNodes[i].getAttribute("DATA4") + "',";
		        }
		  
		        msg = msg.substring(0, msg.lastIndexOf(','));
		        
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/checkAprPerson.do",
		    		data : {
		    			cell : msg
		    		},
		    		success: function(text){
		    			resultCheckAprPerson(text);
		    		}        			
		    	});
		    }
		
		    function resultCheckAprPerson(text) {
		        var temp = loadXMLString(text);
		        alertMsg = "";
		        var selNodes = SelectNodes(temp, "DATA/ROW");
		        for (var i = 0; i < selNodes.length; i++) {
		            var StartDT = getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[3];
		            var EndDT = getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[4];
		            var NowDT = new Date();
		            if (NowDT.getFullYear() >= StartDT.split('-')[0] && NowDT.getFullYear() <= EndDT.split('-')[0] && NowDT.toLocaleString().split(' ')[1].split("<spring:message code='ezPersonal.t287'/>")[0] >= Number(StartDT.split('-')[1]) && NowDT.toLocaleString().split(' ')[1].split("<spring:message code='ezPersonal.t287'/>")[0] <= Number(EndDT.split('-')[1])) {
		                if (StartDT.split('-')[1] != EndDT.split('-')[1]) {
		                    if (NowDT.toLocaleString().split(' ')[1].split("<spring:message code='ezPersonal.t287'/>")[0] == Number(StartDT.split('-')[1]) && NowDT.getDate() >= Number(StartDT.split('-')[2].split(' ')[0])) {
		                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
		                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
		                    }
		                    else if (NowDT.toLocaleString().split(' ')[1].split("<spring:message code='ezPersonal.t287'/>")[0] > Number(StartDT.split('-')[1]) && NowDT.toLocaleString().split(' ')[1].split("<spring:message code='ezPersonal.t287'/>")[0] < Number(EndDT.split('-')[1])) {
		                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
		                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
		                    }
		                    else if (NowDT.toLocaleString().split(' ')[1].split("<spring:message code='ezPersonal.t287'/>")[0] == Number(EndDT.split('-')[1]) && NowDT.getDate() <= Number(EndDT.split('-')[2].split(' ')[0])) {
		                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
		                        alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
		                    }
		                }
		                else if (NowDT.getDate() >= Number(StartDT.split('-')[2].split(' ')[0]) && NowDT.getDate() <= Number(EndDT.split('-')[2].split(' ')[0])) {
		                    alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
		                    alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
		                }
		            }
		        }
		
		        if (alertMsg != "") {
		            alert(alertMsg);                 
		        }
		    }
		
		    function MakertnVal() {
		        var listview = new ListView();                          // ListView 선언
		        listview.LoadFromID("lvRECEPTLIST");                              // ID 지정
		
		        var i;
		        var rows = listview.GetDataRows();
		        if (rows.length == 0)
		            return "";
		
		        var xmlpara = createXmlDom();
		        var objRoot, objRow, objDocinfoNode;
		        objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");
		
		        for (i = 0; i < rows.length; i++) {
		            objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", rows[i].cells[1].innerText);
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTID", rows[i].getAttribute("DATA1"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME", rows[i].getAttribute("DATA2"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EXTRECEPTYN", rows[i].getAttribute("DATA3"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "PROCESSYN", rows[i].getAttribute("DATA4"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "CANEDITYN", rows[i].getAttribute("DATA5"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EMAIL", rows[i].getAttribute("DATA6"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "JOBTITLE", rows[i].getAttribute("DATA9"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME1", rows[i].getAttribute("DATA10"));
		            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME2", rows[i].getAttribute("DATA11"));
		        }
		        return getXmlString(xmlpara);
		    }
		
		    function btn_Close() {
		        ret[0] = "false";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(ret);
		            window.close();
		        }
		        else {
		            window.returnValue = ret;
		            window.close();
		        }
		    }
		    function CabinetSearch_Press(e) {
		        if (window.event) {
		            if (e.keyCode != 13)
		                return;
		        }
		        else {
		            if (e.which != 13)
		                return;
		        }
		        CabinetSearch_onclick();
		    }
		
		    var createcabinet_cross_dialogArguments = new Array();
		    function btnCreateCab_onclick() {
		        var List = new ListView();
		        List.LoadFromID("DivTaskSCateList");
		
		        var selnodes = List.GetSelectedRows();
		        if (selnodes.length > 0) {
		            var selnode = selnodes[0];
		            var para = new Array();
		
		            para[0] = GetAttribute(selnode, "DATA7");
		            para[1] = selnode.cells[1].innerHTML;
		            para[2] = GetAttribute(selnode, "DATA9");
		            para[3] = GetAttribute(selnode, "DATA8");
		            para[4] = GetAttribute(selnode, "DATA15");
		            para[5] = GetAttribute(selnode, "DATA16");
		            para[6] = GetAttribute(selnode, "DATA10");
		            para[7] = GetAttribute(selnode, "DATA11");
		            para[8] = GetAttribute(selnode, "DATA12");
		            para[9] = GetAttribute(selnode, "DATA13");
		            para[10] = GetAttribute(selnode, "DATA14");
		            para[11] = GetAttribute(selnode, "DATA17");
		            para[12] = GetAttribute(selnode, "DATA18");
		
		            var url = "/ezApprovalG/createCabinet.do";
		
		            createcabinet_cross_dialogArguments[0] = para;
		            createcabinet_cross_dialogArguments[1] = btnCreateCab_onclick_Complete;
		
		            if (CrossYN()) {
		                if (UserLang == "2" || UserLang == "3") {
		                    DivPopUpShow(440, 450, url);
		                }
		                else {
		                    DivPopUpShow(440, 450, url);
		                }
		            }
		            else {
		                if (UserLang == "2" || UserLang == "3") {
		                    var feature = "dialogWidth:440px;dialogHeight:438px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
		                    feature = feature + GetShowModalPosition(440, 415);
		                }
		                else {
		                    var feature = "dialogWidth:350px;dialogHeight:438px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
		                    feature = feature + GetShowModalPosition(350, 415);
		                }
		                var rtn = window.showModalDialog(url, para, feature);
		                if (rtn[0] == "TRUE") {
		                    selTaskMCategory_onchange();
		                }
		            }
		        } else {
		            alert("<spring:message code='ezApprovalG.t784'/>");
		        }
		    }
		
		    function btnCreateCab_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            selTaskMCategory_onchange();
		        }
		    }
		
		    function btnNewVolume_onclick() {
		        var ListCab = new ListView();
		        ListCab.LoadFromID("DivTaskSCateList");
		        var selnodes = ListCab.GetSelectedRows();
		
		        if (selnodes.length > 0) {
		            var selnode = selnodes[0];
		            if (trim(GetAttribute(selnode, "DATA1")) == "" || trim(GetAttribute(selnode, "DATA3")) == "") {
		                alert("<spring:message code='ezApprovalG.t10028'/>");
		                return;
		            }
		            var rtn = NewVolume(trim(GetAttribute(selnode, "DATA1")), trim(GetAttribute(selnode, "DATA3")));
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t478'/>");
		        }
		    }
		    function Docinfo_ini() {
		        SummaryFlag = false;
		        var rtnVal = new Array();
		        initdatepicker();
		        document.getElementById("taSummery").value = "";

		        if (vSecurity.trim() == "")
		            document.getElementById("selSecLevel").options[0].selected = true;
		        else
		            document.getElementById("selSecLevel").value = vSecurity;
		        
		        if (vAprUrgency.trim() == "Y")
		            document.getElementById("AprUrgency").checked = true;
		        else
		            document.getElementById("AprUrgency").checked = false;
		        if (vSummery.trim() != "") document.getElementById("taSummery").value = vSummery;

		        if (vdocdisplay.trim() != "")
		            setdocdisplay(vdocdisplay);
		        if (vPublicFlag.trim() != "")
		            setPublicFlag(vPublicFlag);
		        else
		            rdoSecType_onclick("1");

		        if (vPublicFlag2.trim() != "") 
		            setPublicFlag2(vPublicFlag2);

		        if (vAprSecurity.trim() != "") {
		            document.getElementById("AprSecurity").checked = true;
		            
		            $("#idDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#idDatepicker").datepicker('setDate', new Date(vAprSecurity));
		        }
		        else {
		            document.getElementById("AprSecurity").checked = false;
		            AprSecurity_onClick();
		        }

		        document.getElementById("txtLimitRange").value = vtreatment;
		        document.getElementById("txtPageNum").value = vPageNum;
		        rtnVal[0] = document.getElementById("selSecLevel").value;
		        if (document.getElementById("AprUrgency").checked)
		            rtnVal[1] = "Y";
		        else
		            rtnVal[1] = "N";

		        rtnVal[2] = document.getElementById("taSummery").value;
		        rtnVal[3] = getdocdisplay();
		        rtnVal[4] = getPublicFlag();

		        rtnVal[5] = document.getElementById("txtLimitRange").value;
		        rtnVal[6] = document.getElementById("txtPageNum").value;
		        if (document.getElementById("AprSecurity").checked)
		            rtnVal[7] = vAprSecurity;
		        else
		            rtnVal[7] = "";
		
		        if (!CrossYN()) {
		            window.returnValue = rtnVal;
		        }
		    }
		    
	        function CheckDraftinfo() {
				initdatepicker();
				
				if (vAprSecurity.trim() != "") {
				    document.getElementById("AprSecurity").checked = true;
				    
				    $("#idDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#idDatepicker").datepicker('setDate', new Date(vAprSecurity));
				}
				else {
				    document.getElementById("AprSecurity").checked = false;
				    AprSecurity_onClick();
				}
				
				if (document.getElementById("AprSecurity").checked)
				    rtnVal[7] = vAprSecurity;
				else
				    rtnVal[7] = "";
				
	            if (pkeeperiod == "" && !checkdocinfo) {
	                document.getElementById("btndocinfo").style.display = "";
	                document.getElementById("btndocinfo2").style.display = "";
	            }
	            else {
	                document.getElementById("btndocinfo").style.display = "none";
	                document.getElementById("btndocinfo2").style.display = "none";

	                if (!checkdocinfo) {
	                    for (Cnt = 0; Cnt < RSecurity.length; Cnt++) {
	                        if (psecuritylevel == RSecurity[Cnt].value) {
	                            RSecurity[Cnt].checked = true; break;
	                        }
	                    }
	                    for (Cnt = 0; Cnt < RKeeptype.length; Cnt++) {
	                        if (pkeeperiod == RKeeptype[Cnt].value) {
	                            RKeeptype[Cnt].checked = true; break;
	                        }
	                    }
	                    for (Cnt = 0; Cnt < isPublic.length; Cnt++) {
	                        if (pPublicFlag == isPublic[Cnt].value) {
	                            isPublic[Cnt].checked = true; break;
	                        }
	                    }

	                    setNodeText(document.getElementById("tbitemCodeName"),"[" + pItemCode + "]" + pItemName);
	                    document.getElementById("tbItemCode").value = pItemCode;
	                    document.getElementById("tbItemName").value = pItemName;
	                    document.getElementById("tbItemName2").value = pItemName2;

						//요약 넣어야됨
						document.getElementById("taSummery").value = vSummery;
	                }
	            }
	        }
	        
		    function initdatepicker() {
		    	$("#idDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#idDatepicker").datepicker('setDate', new Date(startDateTime.substring(0, 10)));

				$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    }
		    var aprdeptname_cross_dialogArguments = new Array();
		    function btnaddressChange() {
		        var listview = new ListView();
		        listview.LoadFromID("lvRECEPTLIST");
		        var CurSelRow = listview.GetSelectedRows();
		        var windowName = "/ezApprovalG/aprDeptName.do";
		        var parameter = "status:no;dialogWidth:340px;dialogHeight:195px;scroll:no;edge:sunken;help:no";
		
		        if (CurSelRow[0] == undefined) {
		            alert("<spring:message code='ezApprovalG.t10501'/>");
		            return;
		        }
		
		        if (CurSelRow[0].getAttribute("DATA6") != "") {
		            alert("<spring:message code='ezApprovalG.t10500'/>");
		            return;
		        }
		
		        var dialogValue = CurSelRow[0].cells[1].innerText;
		        if (CrossYN()) {
		            aprdeptname_cross_dialogArguments[0] = dialogValue;
		            aprdeptname_cross_dialogArguments[1] = btnaddressChange_Complete;
		
		            DivPopUpShow(360, 220, windowName);
		        }
		        else {
		            parameter = parameter + GetShowModalPosition(330, 205);
		            var AddressName = window.showModalDialog(windowName, dialogValue, parameter);
		            if (AddressName == "cancel" || AddressName == undefined)
		                return;
		            if (CrossYN()) {
		                CurSelRow[0].cells[1].textContext = AddressName;
		                CurSelRow[0].cells[1].innerText = AddressName;
		            }
		            else {
		                CurSelRow[0].cells[1].innerText = AddressName;
		            }
		            SetAttribute(CurSelRow[0], "DATA10", AddressName);
		            SetAttribute(CurSelRow[0], "DATA11", AddressName);
		        }
		    }
		
		    function btnaddressChange_Complete(AddressName) {
		        DivPopUpHidden();
		        if (AddressName == "cancel" || AddressName == undefined)
		            return;
		
		        var listview = new ListView();
		        listview.LoadFromID("lvRECEPTLIST");
		        var CurSelRow = listview.GetSelectedRows();
		
		        if (CrossYN()) {
		            CurSelRow[0].cells[1].textContext = AddressName;
		            CurSelRow[0].cells[1].innerText = AddressName;
		        }
		        else {
		            CurSelRow[0].cells[1].innerText = AddressName;
		        }
		        SetAttribute(CurSelRow[0], "DATA10", AddressName);
		        SetAttribute(CurSelRow[0], "DATA11", AddressName);
		    }
		    
	        function movedraftinfo() {
	            if (CrossYN())
	                document.getElementById("1tab3").onclick();
	            else
	                document.getElementById("1tab3").click();
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
	            			result = xml;
	            		}
	            	});
	            	
	                pGongRamDocID = getNodeText(GetChildNodes(loadXMLString(result))[0]);

	                if (pGongRamDocID == "NONE")
	                    pGongRamDocID = "";

	            } catch (e) {
	                pGongRamDocID = "";
	                alert("getGongRamDocInfo :: " + e.description);
	            }
	        }
	        
		    function ChangeReceptTabCC(divName) {
		        try {
		            if (divName == "Organ") {
		                document.getElementById("Organ").style.display = "";
		                document.getElementById("ReceptTempCC").style.display = "none";
		            } else if (divName == "Save") {
		                document.getElementById("Organ").style.display = "none";
		                document.getElementById("ReceptTempCC").style.display = "";
		                GetReceptTempletListCC();
		            }
		        } catch (e) {
		            alert("AprGongRamLine_Cross_ChangeReceptTab::" + e.description);
		        }
		    }
		    /*
			 * 비전자 기록물 정보 유효성 검사		    
		     */
		    function CheckInputField() {
		        var pRegType = selRegisterType.value;
				if (txtTitle.value == "") {
		            alert("<spring:message code='ezApprovalG.t955'/>");
		            return false;
		        }
				if (txtRegY.value == "" || txtRegD.value == "" || txtRegM.value == "") {
		            alert("<spring:message code='ezApprovalG.t1045'/>");
		            return false;
		        } else {
		        	if (!ValidateYearValue(txtRegY.value)) {
			            alert("<spring:message code='ezApprovalG.t1046'/>");
			            return false;
			        }
			        if (!ValidateNumber(txtRegM.value)) {
			            alert("<spring:message code='ezApprovalG.t1047'/>");
			            return false;
			        }
			        if (!ValidateNumber(txtRegD.value)) {
			            alert("<spring:message code='ezApprovalG.t1048'/>");
			            return false;
			        }
			        if (!ValidateNumber(txtRegH.value)) {
			            alert("<spring:message code='ezApprovalG.t1049'/>");
			            return false;
			        }
			        if (!ValidateNumber(txtRegMi.value)) {
			            alert("<spring:message code='ezApprovalG.t1050'/>");
			            return false;
			        }
			        if (!ValidateYearValue(txtExeY.value)) {
			            alert("<spring:message code='ezApprovalG.t1051'/>");
			            return false;
			        }
			        if (!ValidateNumber(txtExeM.value)) {
			            alert("<spring:message code='ezApprovalG.t1052'/>");
			            return false;
			        }
			        if (!ValidateNumber(txtExeD.value)) {
			            alert("<spring:message code='ezApprovalG.t1053'/>");
			            return false;
			        }
		        }
				if (txtDrafter.value == "") {
		            alert("<spring:message code='ezApprovalG.t1055'/>");
		            return false;
		        }
				if (txtReceiptMember.value == "") {
	                alert("<spring:message code='ezApprovalG.t1056'/>");
	                return false;
	            }
				
				if (pRegType == "1" || pRegType == "3") {
					if (txtAprMemberTitle.value == "") {
		                alert("<spring:message code='ezApprovalG.t1054'/>");
		                return false;
		            }
				}
				if (pRegType == "5" || pRegType == "6") {
					if (txtSummary.value == "") {
		                alert("<spring:message code='ezApprovalG.t1058'/>");
		                return false;
		            }
		            if (GetAVTypeCode() == "") {
		                alert("<spring:message code='ezApprovalG.t1059'/>");
		                return false;
		            }
				}
				if (pRegType == "2" || pRegType == "4" || pRegType == "7" || pRegType == "8") {
					if (txtOriginSN.value == "") {
		                alert("<spring:message code='ezApprovalG.t1057'/>");
		                return false;
		            }
				}
		        return true;
		    }
		    
		    var g_SepAttachLVXml = "";
		    var inssepattach_cross_dialogArguments = new Array();
		    function btnAddSepAttach_onclick() {
		    	if (pIniGubun != "1") {
		    		setCabInfoInit();
		    	}
		        if (g_CabID != "" && g_CabID != "null") {
		            var para = new Array();
		            para[0] = g_SepAttachLVXml;
		            para[1] = g_CabID;
					para[3] = ext;
					para[4] = nonElecRec;
					
					if (pIniGubun == "11") {
						para[2] = "1";	
					} else if (pIniGubun == "6") {
						para[2] = "2";
					}
					
		            var url = "/ezApprovalG/insSepAttach.do";

		            inssepattach_cross_dialogArguments[0] = para;
		            inssepattach_cross_dialogArguments[1] = btnAddSepAttach_onclick_Complete;

		            DivPopUpShow(950, 630, url);
		        }
		        else
		        {
		            OpenAlertUI(Cabinet4);
                    document.getElementById("1tab3").onclick();
                    return;
		            //alert("기록물철을 먼저 선택하여주십시오.");
		            //btnChangeCabinet_onclick();
		        }
		    }

		    var sepAttachCheckYN = "";
		    function btnAddSepAttach_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
			        sepAttachCheckYN = rtn[0];
		            g_SepAttachLVXml = rtn[1];
		        }
		    }
		    
		    function btn_AprDeptTempletModify_onclick() {
		    	/* var listview = new ListView();
		        listview.LoadFromID("lvRECEPTLIST");
		        var CurSelRow = listview.GetSelectedRows();
		        var DeleteState;
		        if (CurSelRow.length != 0) {
	                listview.DeleteRow(GetAttribute(CurSelRow[0], "id"));
		        } */
		    }
	    </script>
	    <style>
	    	.mainlist_free tr th {text-align:center}
	    	.mainlist_free tr td {text-align:center}
	    	#lvAPRTEMPLIST_TH_0 {text-align:left}
	    	#lvAPRTEMPLIST td {text-align:left}
	    	#lvAPRTEMPLIST_TR_noItems td {text-align:center}
	    	#lvRecSaveList_TH_0 {text-align:left}
	    	#lvRecSaveList td {text-align:left}
	    	#lvRecSaveList_TR_noItems td {text-align:center}
	    	#lvRecSaveListCC_TH_0 {text-align:left}
	    	#lvRecSaveListCC td {text-align:left}
	    	#lvRecSaveListCC_TR_noItems td {text-align:center}
	    	#lvRecGroupList_TH_0 {text-align:left}
	    	#lvRecGroupList td {text-align:left}
	    	#lvRecGroupList_TR_noItems td {text-align:center}
	    	#lvRecGroupDetail_TH_0 {text-align:left}
	    	#lvRecGroupDetail td {text-align:left}
	    	#lvRecGroupDetail_TR_noItems td {text-align:center}
	    </style>
	</head>
	<body id="bodytag" class="popup" style="background-color: #ffffff; overflow: hidden">
	    <h1>
	    	<spring:message code='ezApprovalG.t1742'/>
	        <div id="btnArea" style="display:none;float:right;">
	            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>
	            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_Close()"><spring:message code='ezApprovalG.t1761'/></span></a>
	        </div>	        
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <div class="portlet_tabpart02" style="margin: 5px 0px 15px">
	        <div class="portlet_tabpart02_top" id="tab1">
	            <p id="showAprLine"><span divname="Lineinfo" id="1tab1"><spring:message code='ezApprovalG.t1769'/></span></p>
	            <p id="showReceptinfo"><span divname="Receptinfo" id="1tab2"><c:if test="${approvalFlag eq 'G'}" ><spring:message code='ezApprovalG.t448'/></c:if><c:if test="${approvalFlag  eq 'S'}"><spring:message code='ezApprovalG.t999932'/></c:if></span></p>
	            <c:if test="${approvalFlag eq 'G'}" >
	            	<p id="showCabinetinfo"><span divname="Cabinetinfo" id="1tab3"><spring:message code='ezApprovalG.t51'/></span></p>
	           	</c:if>
	           	<c:if test="${approvalFlag eq 'S'}" >
	            	<p id="showCabinetinfo"><span divname="Cabinetinfo" id="1tab3"><spring:message code='ezApproval.t335'/></span></p>
	           	</c:if>
	            <p id="showDocinfo"><span divname="Docinfo" id="1tab4">
	            <c:if test="${approvalFlag eq 'G' }">
	            	<spring:message code='ezApprovalG.t1204'/>
	            </c:if>
	            <c:if test="${approvalFlag eq 'S' }">
	            	<spring:message code='ezApprovalG.jjh03'/>
	            </c:if></span></p>
	            <c:if test="${approvalFlag eq 'S' }">
		            <p id="showHRAprLine"><span divname="Circulation" id="1tab5"><spring:message code='ezApprovalG.hyj06'/></span></p>
	            </c:if>
				<c:if test="${approvalFlag eq 'G'}">
					<p id="showNonElecRecInfo" style="display: none;"><span divname="NonElecRecInfo" id="1tab6">기록물정보</span></p>
				</c:if>
	        </div>
	    </div>
	    <div id="Approvallist">
	        <!-- 결재선 -->
	        <div id="Lineinfo" style="width: 100%; height: 597px;">
	            <table>
	                <tr>
	                    <td style="vertical-align: top">
	                        <div class="portlet_tabpart01" style="margin-top: 3px;">
	                            <div class="portlet_tabpart01_top" id="tab2">
	                                <p><span divname="Organ" id="2tab1"><spring:message code='ezApprovalG.t232'/></span></p>
	                                <p><span divname="Temp" id="2tab2"><spring:message code='ezApprovalG.G0001'/></span></p>
	                            </div>
	                        </div>
	                        <div id="OrganLineTab" style="display: none; width:390px">
	                            <table style="width:99.5%;table-layout: fixed">
	                            <c:if test="${approvalFlag == 'G'}">
									 <tr>
	                                    <td style="vertical-align: top;">	                                    	
	                                        <span>	                                        	
	                                            <div id="TreeView" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 247px; width: 387px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 1px;"></div>
	                                            <div class="border_gray" style="Width: 388px; Height: 273px;">
	                                                <div id="UserList" style="margin: 0px 1px 1px 1px; Width: 386px; Height: 100%; overflow: auto;"></div>
	                                            </div>
	                                        </span>
	                                    </td>
	                                </tr>
	                            </c:if>
	                            <c:if test="${approvalFlag =='S'}">
	                               <tr>
                                    <td style="vertical-align: top;">                                    	
                                        <div id="TreeView" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 387px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
                                        </div>
                                    </td>
                               	 	</tr>
                                	<tr>
                                    <td style="border: 1px solid #ddd;">
                                        <div class="border_gray" style="border: 0px;">
                                            <div id="UserList" style="border: 0px; margin: 0px 1px 1px 1px; Width: 386px; Height: 223px; overflow: auto;">
                                            </div>
                                        </div>
                                    </td>
                                	</tr>
                                </c:if>
	                                <tr>
	                                <c:if test="${approvalFlag == 'S'}">
	                                    <td style="background-color: transparent; height: 28px; padding-top: 10px; vertical-align: top;">
	                                    <input id="textUser" style="width: 150px;height:22px" name="textUser" onkeypress="return textUser_onkeypress(event)"  maxlength="50">
	                                        <a class="imgbtn imgbck"><span name="btn_searchUser" id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
	                                        <a class="imgbtn imgbck" onclick="APRDEPTADD();" id="deptaddbtn"><span><spring:message code='ezApprovalG.G0002'/></span></a>
	                                    </td>
	                                </c:if>
	                                <c:if test="${approvalFlag == 'G'}">
	                                    <td style="background-color: transparent; height: 38px; padding-right: 5px;margin-top: auto;margin-bottom: auto;" >
	                                    	<input id="textUser" style="width: 150px;height:22px" name="textUser" onkeypress="return textUser_onkeypress(event)"  maxlength="50">
	                                    	<a class="imgbtn imgbck" style="vertical-align: middle; margin: auto;"><span name="btn_searchUser" id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
	                                    	<a class="imgbtn imgbck" style="vertical-align: middle; margin: auto;" onclick="APRDEPTADD();" id="deptaddbtn"><span><spring:message code='ezApprovalG.G0002'/></span></a>
	                                    </td>
	                                </c:if>
	                                </tr>
	                            </table>
	                        </div>
	                        <div id="TempLineTab" style="display: none;">
	                            <table>
	                                <tr>
	                                    <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                        <h2 class="h2_dot" style="padding-top: 2px;"><spring:message code='ezApprovalG.G0003'/></h2>
	                                        <div class="border_gray"">
	                                            <div id="APRTEMPLIST" style="border: 0px; Width: 386px; Height: 182px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="background-color: transparent; text-align: center; height: 30px;">
	                                        <table class="content" style="margin-bottom: 5px; width: 100%;">
	                                            <tr>
	                                                <td style="vertical-align: middle; text-align: center; padding-top: 3px;">
	                                                    <a class="imgbtn imgbck"><span id="btn_DelAprLineTemplet" onclick="return btn_DelAprLineTemplet_onclick()"><spring:message code='ezApprovalG.G0004'/></span></a>
	                                                    <a class="imgbtn imgbck"><span id="Span1" onclick="return btn_ModifyToAprLine_onclick()"><spring:message code='ezApprovalG.G0005'/></span></a>
	                                                    <a class="imgbtn imgbck"><span onclick="return btn_AddToAprLine_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="vertical-align: top;">
	                                        <c:if test="${approvalFlag == 'G' }">
	                                        <div class="border_gray">
	                                            <div id="APRTEMP" style="Width: 386px; Height: 266px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                            </div>
	                                        </c:if>
	                                        <c:if test="${approvalFlag == 'S' }">
	                                        <div class="border_gray">
	                                            <div id="APRTEMP" style="Width: 386px; Height: 260px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                            	</div>
                                            </c:if>
	                                        </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </div>
	                    </td>
	                    <td style="vertical-align: top">
	                    <c:if test="${approvalFlag == 'G' }">
	                        <table style="margin-left: 5px;">
	                    </c:if>
	                    <c:if test="${approvalFlag == 'S' }">
	                        <table>
	                    </c:if>
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <h2 class="h2_dot"><spring:message code='ezApprovalG.t407'/>
	                                        <div style="text-align: right; margin-top: -23px;">
	                                            <a class="imgbtn" onclick="AprlineUpper_onclick();" style="height:22px;box-shadow:0px 2px 0px 0px rgba(0,0,0,0.1)"><span>
	                                                <img src="/images/ImgIcon/prev.gif" alt="<spring:message code='ezApprovalG.pjj28'/>" style="vertical-align:middle"/></span></a>
	                                            <a class="imgbtn" onclick="AprlineDown_onclick();" style="height:22px;box-shadow:0px 2px 0px 0px rgba(0,0,0,0.1)"><span>
	                                                <img src="/images/ImgIcon/next.gif" alt="<spring:message code='ezApprovalG.pjj29'/>" style="vertical-align:middle"/></span></a>
	                                        </div>
	                                    </h2>
	                                  
	                                        <c:if test="${approvalFlag == 'G' }">
		                                        <div class="border_gray" style="margin-top:7px">
		                                        <div id="APRLINE" style="Width: 723px; Height: 488px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: auto; padding-top: 0px;">
		                                        </div>
		                                        </div>
	                                        </c:if>
	                                        <c:if test="${approvalFlag == 'S' }">
		                                        <div class="border_gray" style="margin-top:7px; margin-left:4px;">
		                                        <div id="APRLINE" style="Width: 717px; Height: 518px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        	</div>
	                                        	</div>
                                        	</c:if>
	                                </td>
	                            </tr>
	                            <tr class="approvalG">
	                                <td>
	                                    <div>
	                                        <table class="content" style="margin-top: 6px; width: 100%;">
	                                            <tr>
	                                                <td colspan="2" style="margin-top: 3px; text-align: center; background-color: #f8f8fa">
	                                                    <input type="checkbox" name="Reporter" id="Reporter" value="checkbox" onclick="return Reporter_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
	                                                    <span><spring:message code='ezApprovalG.t409'/></span>
	                                                    <input type="checkbox" id="Suggester" name="Suggester" value="checkbox" onclick="return Suggester_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
	                                                    <span><spring:message code='ezApprovalG.t410'/></span>
	                                                </td>
	                                            </tr>
	                                            <tr style="display: none">
	                                                <th><spring:message code='ezApprovalG.t411'/></th>
	                                                <td>
	                                                    <table>
	                                                        <tr>
	                                                            <td>
	                                                                <input id="ReasonNoAprTxt" name="ReasonNoAprTxt" type="text" style="width: 100%">
	                                                            </td>
	                                                            <td style="text-align: right; width: 55px;"><a class="imgbtn">
	                                                                <span id="ReasonNoApr" onclick="return ReasonNoApr_onclick()" style="width: 40px"><spring:message code='ezApprovalG.t336'/></span></a>
	                                                            </td>
	                                                        </tr>
	                                                    </table>
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                            	<c:if test ="${approvalFlag =='G'}">
	                                <td style="text-align: right;">
	                                    <a style="margin-top: 8px;" class="imgbtn imgbck">
	                                 </c:if>
	                                 <c:if test = "${approvalFlag=='S'}">
	                                 <td style="padding-top: 10px; text-align: right; vertical-align: top;" id="SaveAprLineTemplet">
	                                 <a class="imgbtn imgbck">
	                                 </c:if>
	                                 <span id="btn_SaveAprLineTemplet" onclick="return btn_SaveAprLineTemplet_onclick()"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t384'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t270'/></c:if></span></a>
	                                </td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	            </table>
	        </div>
	    </div>
	
	    <!-- 수신처 -->
	    <div id="Receptinfo" style="width: 100%; height: 597px; display: none;">
	        <table>
	            <tr>
	            	<c:if test= "${approvalFlag eq 'G'}">
	                <td style="border: 0px solid red; height: 580px; width: 390px; margin-left: 5px; vertical-align: top;">
	                </c:if>
	                <c:if test= "${approvalFlag eq 'S'}">
	                <td style="border: 0px solid red; height: 580px; width: 390px; margin-left: 5px; vertical-align: top;">
	                </c:if>
	                    <div class="portlet_tabpart01" style="margin-top: 3px; text-align: right;">
	                        <div class="portlet_tabpart01_top" id="tab3">
	                        	<c:if test="${approvalFlag eq 'G'}">
		                        	<c:choose>
		                        		<c:when test="${receptGubunYN eq 'Y'}">
		                        			<c:if test="${docType eq '001'}">
					                            <p><span id="3tab4" divname="Outer" class ="approvalG"><spring:message code='ezApprovalG.t330'/></span></p>
	           		                            <p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
		                        			</c:if>
		                        			<c:if test="${docType ne '001'}">
					                            <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
					                            <p><span id="3tab4" style="display: none;" divname="Outer" class ="approvalG"><spring:message code='ezApprovalG.t330'/></span></p>
           		                            	<p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
           		                            	<p><span id="3tab3" divname="Group"><c:if test="${approvalFlag =='G' }"><spring:message code='ezApprovalG.t1568'/></c:if><c:if test="${approvalFlag =='S' }"><spring:message code='ezApproval.t227'/></c:if></span></p>
		                        			</c:if>
		                        		</c:when>
		                        		<c:otherwise>
				                            <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
				                            <p><span id="3tab4" style="display: none;" divname="Outer" class ="approvalG"><spring:message code='ezApprovalG.t330'/></span></p>
           		                            <p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
		          			                <p><span id="3tab3" divname="Group"><c:if test="${approvalFlag =='G' }"><spring:message code='ezApprovalG.t1568'/></c:if><c:if test="${approvalFlag =='S' }"><spring:message code='ezApproval.t227'/></c:if></span></p>
		                        		</c:otherwise>
		                        	</c:choose>
	                        	</c:if>
	                        	<c:if test="${approvalFlag ne 'G'}">
		                            <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
		                            <p><span id="3tab4" style="display: none;" divname="Outer" class ="approvalG"><spring:message code='ezApprovalG.t330'/></span></p>
		                            <p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
		                            <p><span id="3tab3" divname="Group"><c:if test="${approvalFlag =='G' }"><spring:message code='ezApprovalG.t1568'/></c:if><c:if test="${approvalFlag =='S' }"><spring:message code='ezApproval.t227'/></c:if></span></p>
	                        	</c:if>
	                        </div>
	                    </div>
	                    <div id="ReceptOrgan" style="display: none;">
	                        <table style="margin-left: 0px;">
	                            <tr>
	                                <td style="vertical-align: top;">
	                                	<c:if test="${approvalFlag =='G' }">
		                                    <div id="TreeView2" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 523px; width: 388px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
		                                    </div>
	                                    </c:if>
	                                    <c:if test="${approvalFlag == 'S' }">
                                        	<div id="TreeView2" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 386px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
		                                    </div>
	                                    </c:if>
	                                </td>
	                            </tr>
	                            <c:if test="${approvalFlag == 'S' }">
	                            <tr>
                                    <td style="border: 1px solid #ddd;">
                                        <div class="border_gray" style="border: 0px;">
                                            <div id="UserList2" style="border: 0px; margin: 0px 1px 1px 1px; Width: 386px; Height: 223px; overflow: auto;">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </c:if>
	                            <tr>
	                                <td height="36px;" style="background-color: transparent; padding-top: 10px;vertical-align: top">
	                                <c:if test="${approvalFlag == 'G'}">
	                                    <input id="txtDeptName" style="width: 150px;height:22px" name="textUser" onkeyup="return btnSearchDept_onKeyPress(event)"  maxlength="50">
	                                    <a class="imgbtn imgbck" style="vertical-align: middle; margin: auto;"><span id="Span2" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                	<a class="imgbtn imgbck" style="vertical-align: middle; margin: auto;" id="AprDeptAdd" onclick="AprDeptAdd_onclick('DEPT');"><span><spring:message code='ezApprovalG.G0002'/></span></a>
	                                </c:if>
	                                <c:if test="${approvalFlag == 'S'}">
	                                 	<input id="textUser2" style="width: 150px;height:22px" name="textUser" onkeypress="return textUser_onkeypress2()" maxlength="50">
                                        <a class="imgbtn imgbck"><span name="btn_searchUser" id="Span2" onkeypress="return btn_searchUser_onclick2()" onclick="return btn_searchUser_onclick2()"><spring:message code='ezApproval.t175'/></span></a>
	                                	<a class="imgbtn imgbck" id="AprDeptAdd"  onclick="AprDeptAdd_onclick('DEPT');"><span><spring:message code='ezApproval.t1101'/></span></a>
	                                </c:if>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	
	                    <div id="ReceptOuter" style="display: none;">
	                        <table style="margin-left: 0px;">
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div id="TreeView3" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 523px; width: 388px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; height: 30px;">
	                                    <input id="txtOuterDeptName" style="width: 150px;height:22px; margin-top:7px;" name="textUser2" onkeyup="return btnSearchDept_onKeyPress2(event)"  maxlength="50">
	                                    <a style=" margin-top:7px;" class="imgbtn imgbck"><span id="Span7" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                    <a class="imgbtn imgbck" style="margin-top:7px;" id="AprDeptOuterAdd" onclick="AprDeptOuterAdd_onclick();"><span><spring:message code='ezApprovalG.t1236'/></span></a>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	
	                    <div id="ReceptTemp" style="display: none;">
	                        <table>
	                            <tr>
	                                <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                    <h2 class="h2_dot" style="padding-top:2px;"><spring:message code='ezApprovalG.G0003'/></h2>
	                                    <div class="border_gray">
	                                        <div id="RecSaveList" style="border: 0px; Width: 386px; Height: 182px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; text-align: center; height: 30px;">
	                                    <table class="content" style="margin-bottom: 5px; width: 100%;">
	                                        <tr>
	                                            <td style="text-align: center; padding-top: 3px">
	                                                <a class="imgbtn imgbck"><span id="Span3" onclick="return btn_AprDeptTempletDel_onclick()"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t252'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t219'/></c:if></span></a>
	                                                <a class="imgbtn imgbck"><span id="Span4" onclick="return btn_AprDeptTempletSave_onclick('MODIFY')"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t308'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApprovalG.G0006'/></c:if></span></a>
	                                                <a class="imgbtn imgbck"><span onclick="return btn_AprDeptTempletAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div class="border_gray">
	                                        <div id="RecSaveDetail" style="Width: 386px; Height: 266px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	                    <div id="ReceptGroup" style="display: none;">
	                        <table>
	                            <tr>
	                                <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                    <h2 class="h2_dot" style="padding-top:2px;"><spring:message code='ezApprovalG.G0007'/></h2>
	                                    <div class="border_gray">
	                                        <div id="RecGroupList" style="border: 0px; Width: 386px; Height: 182px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; text-align: center; height: 30px;">
	                                    <table class="content" style="margin-bottom: 5px; width: 100%">
	                                        <tr>
	                                            <td style="text-align: center; padding-top: 3px">
	                                                <a class="imgbtn imgbck"><span onclick="return btn_GroupReceptAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.G0008'/></span></a>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div class="border_gray">
	                                        <div id="RecGroupDetail" style="Width: 386px; Height: 266px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	                </td>
	                <!-- 2015-06-23 표준모듈:추가 - KSK -->
	                <td class ="approvalG" style="width: 16px; text-align: center;" >
	                    <div style="display: inline-block; margin:auto; padding-left:2.5px;" id="AddRemoveBTN">
	                        <img src="/images/arr_rr.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsertAll" onclick="return InsertRecAll();">
	                        <br>
	                        <img src="/images/arr_r.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsert" onclick="return InsertRec();">
	                        <br>
	                        <img src="/images/arr_l.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDelete" onclick="return DeleteRec();">
	                        <br>
	                        <img src="/images/arr_ll.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDeleteAll" onclick="return DeleteRecAll();">
	                        <br>
	                    </div>
	                </td>
	                <td style="vertical-align: top">
	                    <table style="margin-left: 5px;">
	                        <tr>
	                            <td style="vertical-align: top;" colspan="2">
	                                <h2 class="h2_dot"> <c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t253'/></c:if> <c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t220'/></c:if></h2>
	                                <div class="border_gray" style="margin-top: 7px">
	                                <c:if test="${approvalFlag == 'G'}">
	                                    <div id="RECEPTLIST" style="Width: 703px; Height: 524px; overflow: auto; border: 0; font-size: 9pt; margin: auto; padding-top: 0px;">
	                                    </div>
	                                </c:if>
	                                <c:if test="${approvalFlag == 'S'}">
	                                    <div id="RECEPTLIST" style="Width: 716px; Height: 518px; overflow: auto; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </c:if>
	                                </div>
	                            </td>
	                        </tr>
	                        <!-- 2015-06-30 표준모듈:추가(외부수신자요약) - KSK -->
	                        <!-- <tr style="display:none;" id="trSummaryOuterReceiverList">
	                            <td style="width: 120px;">
	                                <h2 class="h2_dot">외부수신자 요약:</h2>
	                            </td>
	                            <td>
	                                <input id="inputSummaryOuterReceiverList" style="width: 97%; margin-top: 5px;" value="" />
	                            </td>
	                        </tr> -->
	                        <tr>
	                            <td class="approvalG" style="text-align:left">
	                            	<c:choose>
		                        		<c:when test="${receptGubunYN eq 'Y'}">
		                        			<c:if test="${docType eq '001'}">
				                                <a style="margin-top: 10px; display: none;"  class="imgbtn imgbck" id="btnaddress"><span  onclick="return btnAddAddress()" ><spring:message code='ezApprovalG.t334'/></span></a>
		                        			</c:if>
		                        			<c:if test="${docType ne '001'}">
<!-- 		                        				btnaddress 아이디 참조 스크립트때문에 살려줌 -->
				                                <a style="display: none;" id="btnaddress"></a>
		                        			</c:if>
		                        		</c:when>
		                        		<c:otherwise>
			                                <a style="margin-top: 10px; display: none;"  class="imgbtn imgbck" id="btnaddress"><span  onclick="return btnAddAddress()" ><spring:message code='ezApprovalG.t334'/></span></a>
		                        		</c:otherwise>
		                        	</c:choose>
	                                <a style="margin-top: 10px; display: none;" class="imgbtn imgbck" id="btnaddressChange" ><span onclick="return btnaddressChange()" ><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t348'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t1104'/></c:if></span></a>
	                            	<!-- 2018-08-08 천성준 - 외부수신자요약 UI때문에 이동 -->
	                            	<span style="display: inline-block; margin-top: 8px;">
	                            		<a class="h2_dot" style="display: none;" id="trSummaryOuterReceiverList">외부수신자 요약:&nbsp;<input id="inputSummaryOuterReceiverList" value="" style="width: 470px; height: 22px;"/></a>
	                            	</span>
	                            </td>
	                            <td style="text-align:right">
	                            	<c:if test="${useReceiveInfoName == '1'}"><a class="imgbtn imgbck" style="margin-top:10px;"><span id="Span6" onclick="return btn_AprDeptTempletModify_onclick()"><c:if test="${approvalFlag == 'G'}"><spring:message code = 'ezApprovalG.lhj19' /></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code = 'ezApprovalG.lhj20' /></c:if></span></a></c:if>
	                                <a class="imgbtn imgbck" style="margin-top:10px;"><span id="Span5" onclick="return btn_AprDeptTempletSave_onclick('NEW')"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t308'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApprovalG.G0009'/></c:if></span></a>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	        </table>
	    </div>
	    <c:if test="${approvalFlag eq 'G' }">
		    <!-- 기록물철 -->
		    <div id="Cabinetinfo" style="width: 100%; height: 597px; display: none;">
		        <table style="width: 100%">
		            <tr>
		                <td colspan="2">
		                    <h2 class="h2_dot" style="margin-left:5px;"><spring:message code='ezApprovalG.t1039'/></h2>
		                    <table class="content" style="width: 99.8%; margin-left:3px ">
		                        <tr>
		                            <th style="width: 50px"><spring:message code='ezApprovalG.t592'/></th>
		                            <td style="width: 105px">
		                                <select id="selTaskCategory" onchange="return selTaskCategory_onchange()" style="width: 100px; height:24px">
		                                </select>
		                            </td>
		                            <th style="width: 50px"><spring:message code='ezApprovalG.t593'/></th>
		                            <td style="width: auto;">
		                                <select id="selTaskMCategory" onchange="return selTaskMCategory_onchange()" style="width: 100px; margin-top: 2px; height:24px">
		                                </select>		                                
		                                        <span id="trCreateCab">
		                                        	<c:if test="${initFlag == '1'}">
			                                            <a class="imgbtn imgbck" style="margin-top: 3px"><span onclick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></a>
			                                            <a class="imgbtn imgbck" style="margin-top: 3px; display:none;"><span onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></a>
		                                        	</c:if>
		                                        </span>
		                                <span id="trCreateCabDummy" style="display: none"></span>
		                                <span  style="vertical-align: middle; margin-left: 247px;">
		                                    <select id="selSearchOption" style="vertical-align: none;height:24px">
		                                        <option>
		                                            <spring:message code='ezApprovalG.t10026'/>
		                                        </option>
		                                        <option>
		                                            <spring:message code='ezApprovalG.t577'/>
		                                        </option>
		                                    </select>
		                                    <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)" style="vertical-align:baseline;">
		                                    <a class="imgbtn imgbck" style="margin-top: 3px"><span name="btnSearch" onclick="return CabinetSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
		                                    <a class="imgbtn imgbck" style="margin-top: 3px"><span name="btnSearch" onclick="return Cabinetinfo_ini()"><spring:message code='ezApprovalG.t165'/></span></a>
		                                </span>
		                            </td>
		                        </tr>
		                    </table>
		                    <div class="border_gray" style="margin-top: 5px; margin-left: 3px">
		                        <div id="TaskSCateList" style="border: 0; HEIGHT: 295px; WIDTH: 99.9%; overflow-x: hidden; overflow-y: auto; margin: 0px 1px 1px 1px;"></div>
		                    </div>
		                </td>
		            </tr>
		            <tr>
		                <td>                    
		                    <h2 class="h2_dot"><spring:message code='ezApprovalG.t00001'/></h2>
		                </td>
		                <td style="padding-top:5px;">
		                    <div align="right">
		                        <a class="imgbtn imgbck"><span onclick="return Set_MyTask('INS')"><spring:message code='ezApprovalG.t00002'/></span></a>
		                        <a class="imgbtn imgbck"><span onclick="return Set_MyTask('DEL')"><spring:message code='ezApprovalG.t00003'/></span></a>
		                    </div>
		                </td>
		            </tr>
		            <tr>
		                <td colspan="2">
		                    <div class="border_gray" style="margin-top: 5px; margin-left: 3px">
		                        <div id="MyTaskSCateList" style="border: 0; HEIGHT: 180px; WIDTH: 99.9%; overflow-x: hidden; overflow-y: auto; margin: 0px 1px 1px 1px;"></div>
		                    </div>
		                </td>
		            </tr>
		        </table>
		    </div>
	    </c:if>
	    
	    <c:if test="${approvalFlag eq 'S' }">
	        <div id="Cabinetinfo" style="width: 1110px; height: 597px; display: none;">
	            <table>
	                <tr>
	                    <td style="border: 0px solid red; height: 580px; width: 971px; vertical-align: top">
	                        <table style="width: 100%">
	                            <tr style="height:33px">
	                                <td>
	                                    <h2 class="h2_dot"><spring:message code='ezApproval.t335'/></h2>
	                                </td>
	                                <td>
	                                    <span style="float: right;">
	                                        <select id="selSearchOption" style="vertical-align: middle;height:22px">
	                                            <option id="ITEMNAME">
	                                                <spring:message code='ezApproval.t79'/>
	                                            </option>
	                                            <option id="GROUPNAME">
	                                                <spring:message code='ezApprovalG.t114'/>
	                                            </option>
	                                        </select>
	                                        <input type="text" style="height:22px" id="txtCodeSearch" onkeypress="CodeSearch_Press(event)" />
	                                        <a class="imgbtn imgbck" onclick="return CodeSearch_onclick()">
	                                        	<span style="height:22px;line-height:22px" name="btnSearch"><spring:message code='ezApproval.t236'/></span>
	                                        </a>
	                                        <a class="imgbtn imgbck">
	                                        	<span style="height:22px;line-height:22px" name="btnSearch" onclick="Draftinfo_reload()"><spring:message code='ezApproval.t1042'/></span>
	                                        </a>
	                                    </span>
	                                </td>
	                            </tr>
	                        </table>
					        <div>
					            <table>
					                <tr>
					                    <td>
					                        <div class="border_gray">
					                        	<div id="infotree" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; HEIGHT: 350px; WIDTH: 200px; margin: 1px 1px 1px 1px;"></div>
				                            </div>
					                    </td>
					                    <td style="padding-left: 3px;">
					                        <div class="border_gray">
					                            <div id="infolist" style="border: 0px; HEIGHT: 350px; WIDTH: 901px; overflow-x: hidden; overflow-y: auto; margin: 1px 1px 1px 1px; padding-top: 0px;"></div>
					                        </div>
					                    </td>
					                </tr>					                
					                <tr style="height:30px">
					                    <td>
					                       <h2 class="h2_dot"><spring:message code='ezApproval.t1100'/></h2>
					                    </td>
					                    <td style="padding-top:10px;padding-bottom:5px">
					                        <div align="right">
					                            <a class="imgbtn imgbck"><span style="text-align: center;" onclick="btnAddCode_onclick()"><spring:message code='ezApproval.t00001'/></span></a>
					                            <a class="imgbtn imgbck"><span style="text-align: center;" onclick="btnDelCode_onclick()"><spring:message code='ezApproval.t00002'/></span></a>
					                        </div>
					                    </td>
					                </tr>
					                <tr>
					                    <td colspan="2">
					                        <div class="border_gray">
					                            <div id="infofrequencylist" style="border: 0px; HEIGHT: 155px; WIDTH: 1108px; overflow-x: hidden; overflow-y: auto; margin: 1px 1px 1px 1px; padding-top: 0px;"></div>
					                        </div>
					                    </td>
					                </tr>
					            </table>
					        </div>
				        </td>
                	</tr>
            	</table>
    		</div>
	    </c:if>
	    
	    <!-- 문서정보 -->
	    <c:if test="${approvalFlag eq 'G' }">
		    <div id="Docinfo" style="border: 0px solid #dbdbda; width: 100%; height: 597px; display: none;">		
		        <h2 class="h2_dot" style="margin-left: 5px;"><spring:message code='ezApprovalG.t1204'/></h2>
		        <table class="content" style="margin-left: 3px;">
		            <tr>
		                <th><spring:message code='ezApprovalG.t875'/></th>
		                <td>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="special1" id="special1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="special1"><span> <spring:message code='ezApprovalG.t1205'/></span></label>
		                    </div>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="special2" id="special2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="special2"><span> <spring:message code='ezApprovalG.t984'/></span></label>
		                    </div>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="special3" id="special3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="special3"><span> <spring:message code='ezApprovalG.t1206'/></span></label>
		                    </div>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="special4" id="special4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="special4"><span> <spring:message code='ezApprovalG.t986'/></span></label>
		                    </div>
		                    <div style="padding-top: 5px; padding-bottom: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="special5" id="special5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="special5"><span> <spring:message code='ezApprovalG.t1207'/></span></label>
		                    </div>
		
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t118'/></th>
		                <td>
		                    <select id="selSecLevel" name="select" style="WIDTH: 85px">
		                        ${securityNode3}
		                    </select>
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.kes06'/></th>
		                <td>
		                    <div style="padding-left: 3px; padding-top: 5px; padding-bottom: 5px;">
		                        <spring:message code='ezApprovalG.t10029'/><br />
		                    </div>
		                    <div style="padding-left: 3px; padding-bottom: 5px;">
		                        <input type="radio" name="rdoSecType" value="1" checked onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><spring:message code='ezApprovalG.t47'/></span>&nbsp;
		                        <input type="radio" name="rdoSecType" value="2" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><spring:message code='ezApprovalG.t150'/></span>&nbsp;
		                        <input type="radio" name="rdoSecType" value="3" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><spring:message code='ezApprovalG.t46'/></span>&nbsp;
		                    </div>
		                </td>
		
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t989'/></th>
		                <td>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="selSecLevel1" id="selSecLevel1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 1<spring:message code='ezApprovalG.t991'/>&nbsp;</span>
		                        <input type="checkbox" name="selSecLevel2" id="selSecLevel2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 2<spring:message code='ezApprovalG.t991'/></span>
		                        <input type="checkbox" name="selSecLevel3" id="selSecLevel3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 3<spring:message code='ezApprovalG.t991'/></span>
		                        <input type="checkbox" name="selSecLevel4" id="selSecLevel4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 4<spring:message code='ezApprovalG.t991'/></span><br>
		                    </div>
		                    <div style="padding-top: 5px; padding-bottom: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="selSecLevel5" id="selSecLevel5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 5<spring:message code='ezApprovalG.t991'/>&nbsp;</span>
		                        <input type="checkbox" name="selSecLevel6" id="selSecLevel6" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 6<spring:message code='ezApprovalG.t991'/></span>
		                        <input type="checkbox" name="selSecLevel7" id="selSecLevel7" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 7<spring:message code='ezApprovalG.t991'/></span>
		                        <input type="checkbox" name="selSecLevel8" id="selSecLevel8" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 8<spring:message code='ezApprovalG.t991'/></span>
		                    </div>
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t876'/></th>
		                <td>
		                    <input type="text" name="txtLimitRange" id="txtLimitRange" class="text" style="Width: 170px; font-size: 9pt"><span>(<spring:message code='ezApprovalG.t1209'/></span></td>
		                <tr>
		                    <th><spring:message code='ezApprovalG.t979'/></th>
		                    <td>
		                        <input type="text" name="txtPageNum" id="txtPageNum" class="text" style="Width: 170px; font-size: 9pt"></td>
		                </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t1199'/></th>
		                <td>
		                    <input type="checkbox" name="AprUrgency" id="AprUrgency" value="checkbox"><spring:message code='ezApprovalG.t10090'/>
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t1210'/></th>
		                <td>
		                    <input type="checkbox" name="AprSecurity" id="AprSecurity" value="checkbox" onclick="AprSecurity_onClick()">
		                    <input readonly="readonly" id='idDatepicker' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t109'/></th>
		                <td>
		                    <div style="padding-left: 3px; padding-bottom: 5px;">
		                    	<div style="padding-left: 3px; padding-top: 5px;">
<%-- 			                        <input id="rdoSecType2Y" type="radio" name="rdoSecType2" value="Y" checked onclick="return rdoSecType2_onclick(this.value)" style="height: 13px; width: 13px; padding-top: 5px; padding-bottom: 5px; margin: 0px; vertical-align: top;"><label for="rdoSecType2Y"><span><spring:message code='ezApprovalG.t47'/> (<spring:message code='ezApproval.t2000'/>)</span></label> --%>
			                        <input id="rdoSecType2Y" type="radio" name="rdoSecType2" value="Y" checked style="height: 13px; width: 13px; padding-top: 5px; padding-bottom: 5px; margin: 0px; vertical-align: top;"><label for="rdoSecType2Y"><span><spring:message code='ezApprovalG.t47'/> (<spring:message code='ezApproval.t2000'/>)</span></label>
		                    	</div>
		                    	<div style="padding-left: 3px; padding-top: 5px;">
<%-- 			                        <input id="rdoSecType2N" type="radio" name="rdoSecType2" value="N" onclick="return rdoSecType2_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="rdoSecType2N"><span><spring:message code='ezApprovalG.t46'/> (<spring:message code='ezApproval.t2001'/>)</span></label> --%>
			                        <input id="rdoSecType2N" type="radio" name="rdoSecType2" value="N" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><label for="rdoSecType2N"><span><spring:message code='ezApprovalG.t46'/> (<spring:message code='ezApproval.t2001'/>)</span></label>
		                    	</div>
		                    </div>
		                </td>
		           </tr>
		        </table>

		        <h2 class="h2_dot"><spring:message code='ezApprovalG.t1203'/></h2>
		        <textarea id="taSummery" name="taSummery" style="HEIGHT: 160px; WIDTH: 99.7%; resize:none; box-sizing: border-box; -moz-box-sizing: border-box; margin-left:3px;"></textarea>
		    </div>
	    </c:if>
	    
	    <c:if test="${approvalFlag eq 'S' }">
	    	<div id="Docinfo" style="width: 1110px; height: 594px; display: none; padding-top:3px">
        		<td style="border: 0px solid red; height: 580px; width: 390px; margin-left: 5px; vertical-align: top">
		            <h2 class="h2_dot"><spring:message code='ezApproval.t334'/></h2>
		            <table class="content" style="margin-top:4px">
		                <tr>
		                    <th><spring:message code='ezApproval.t706'/></th>
		                    <td>
		                        <table>
		                            <tr>
		                                <td>
		                                    <div id="tbitemCodeName" style="height: 20px; width:auto; vertical-align:middle; padding-top:5px; text-align:left;" ></div>
		                                    <input type="hidden" id="tbItemCode" style="WIDTH: 80px; height: 20px;" />
		                                    <input type="hidden" id="cabinetID" style="WIDTH: 80px; height: 20px;" />
		                                    <input type="hidden" id="tbItemName" style="WIDTH: 100px; height: 20px;" />
		                                    <input type="hidden" id="tbItemName2" />
		                                </td>
		                                <td>
		                                    <a class="imgbtn imgbck" id="btndocinfo"><span id="btndocinfo2" onclick="movedraftinfo()"><spring:message code='ezApproval.t335'/><spring:message code='ezApproval.t321'/></span></a>
		                                </td>
		                            </tr>
		                        </table>                                                
		                    </td>
		                </tr>
		                <tr>
		                    <th><spring:message code='ezApproval.t81'/></th>
		                    <td>
		                        <table class="popuplist" style="width: auto;">
		                            <tr>
		                                <td style="width: auto; padding-left: 4px; padding-bottom: 4px">${securityNode3}</td>
		                            </tr>
		                        </table>
		
		                    </td>
		                </tr>
		                <tr>
		                    <th><spring:message code='ezApproval.t80'/></th>
		                    <td>
		                        <table class="popuplist" style="width: auto;">
		                            <tr>
		                                <td style="width: auto; padding-left: 4px; padding-bottom: 4px">${periodnode}</td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr>
		                    <th><spring:message code='ezApproval.t82'/></th>
		                    <td>
		                        <table class="popuplist" style="width: 100%;">
		                            <tr>
		                                <td style="width: 100%; padding-left: 4px; height: 18px; padding-top: 4px; padding-bottom: 4px">
		                                    <input type="radio" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: middle;" id="isPublic" name="isPublic" value="Y" />&nbsp;<span><spring:message code='ezApproval.t50'/> (<spring:message code='ezApproval.t2000'/>)</span></td>
		                            </tr>
		                            <tr>
		                                <td style="width: 100%; padding-left: 4px; height: 18px; padding-bottom: 4px">
		                                    <input type="radio" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: middle;" id="isPublic" name="isPublic" value="N" />&nbsp;<span><spring:message code='ezApproval.t49'/> (<spring:message code='ezApproval.t2001'/>)</span></td>
		                            </tr>
		                        </table>
		                    </td>
		                </tr>
		                <tr>
		                    <th><spring:message code='ezApproval.t337'/></th>
		                    <td>
		                        <input id="urgent" type="checkbox" name="checkbox" value="checkbox" />&nbsp;(<spring:message code='ezApproval.t2002'/>)</td>
		                </tr>
<!-- 		                보안결재 추가 -->
			            <tr style="display: none;">
			                <th><spring:message code='ezApprovalG.t1210'/></th>
			                <td>
			                    <input type="checkbox" name="AprSecurity" id="AprSecurity" value="checkbox" onclick="AprSecurity_onClick()">
			                    <input readonly="readonly" id='idDatepicker' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
			                </td>
			            </tr>
		                <%-- <tr>
		                    <td colspan="2">
		                        <h2 class="h2_dot"><spring:message code='ezApproval.t339'/></h2>
		                    </td>
		                </tr> --%>
		                <tr>
		                	<th><spring:message code='ezApproval.t339'/></th>
		                    <td>		                    	
		                        <!-- <div class="nobox"> -->
		                            <textarea id="taSummery" name="taSummery" style="HEIGHT: 370px; WIDTH: 99.7%; resize:none; box-sizing: border-box; -moz-box-sizing: border-box; margin: 2px 2px 2px 2px"></textarea>
		                        <!-- </div> -->
		                    </td>
		                </tr>
		            </table>
		        </td>
		    </div>
	    </c:if>
	    <c:if test="${approvalFlag eq 'S' }">
<!-- 	    회람 -->
	    	<div id="Circulation" style="width: 1110px; height: 597px; display: none;">
        		<table>
			        <tr>
			            <td style="vertical-align: top">
			                <div class="portlet_tabpart01" style="margin-top: 3px;">
			                    <div class="portlet_tabpart01_top" id="tab5">
			                        <p><span id="5tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
			                        <p><span id="5tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
			                    </div>
			                </div>
			                <!-- 조직도 -->
			                <div id="Organ" style="width:390px">
			                	<table style="width:99.5%;table-layout: fixed">
			                		<tr>
	                                    <td style="vertical-align: top;">                                    	
	                                        <div id="TreeViewCC" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 387px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
	                                        </div>
	                                    </td>
                               	 	</tr>
                                	<tr>
	                                    <td style="border: 1px solid #ddd;">
                                        <div class="border_gray" style="border: 0px;">
                                            <div id="UserListCC" style="border: 0px; margin: 0px 1px 1px 1px; Width: 386px; Height: 223px; overflow: auto;">
                                            </div>
                                        </div>
                                    </td>
                                	</tr>
			                    	<tr>
	                                    <td style="background-color: transparent; height: 28px; padding-top:10px; vertical-align: top">
	                                        <input id="textUserCC" style="width: 150px;height:22px" name="textUserCC" onkeypress="return textUserCC_onkeypress(event)"  maxlength="50">
	                                        <a class="imgbtn imgbck"><span name="btn_searchUserCC" id="btn_searchUserCC" onkeypress="return btn_searchUserCC_onclick()" onclick="return btn_searchUserCC_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
											<!-- 부서추가 -->
											<a class="imgbtn imgbck"><span id="btn_addDept" onclick="return btn_addDepartment()"><spring:message code='ezApproval.t1101'/></span></a>
	                                    </td>
	                                </tr>
			                    </table>
			                </div>
			                <!-- 즐겨찾기 -->
			                <div id="ReceptTempCC" style="display: none">
			                    <table style="padding-left: 5px;">
			                        <tr>
			                            <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
			                                <h2 class="h2_dot" style="padding-top: 2px;"><spring:message code='ezApprovalG.G0003'/></h2>
			                                <div class="border_gray">
			                                    <div id="RecSaveListCC" style="border: 0px; Width: 386px; Height: 237px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
			                                    </div>
			                                </div>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td style="background-color: transparent; text-align: center; height: 30px;">
			                                <table class="content" style="margin-bottom: 5px; width: 100%; ">
			                                    <tr>
			                                        <td style="text-align: center;">
			                                            <a class="imgbtn imgbck"><span id="Span3" onclick="return btn_AprDeptTempletDelCC_onclick()"><spring:message code='ezApprovalG.G0001'/> <spring:message code='ezApprovalG.t266'/></span></a>
			                                            <a class="imgbtn imgbck"><span id="Span4" onclick="return btn_AprDeptTempletSaveCC_onclick('MODIFY')"><spring:message code='ezApprovalG.G0001'/> <spring:message code='ezApprovalG.t269'/></span></a>
			                                            <a class="imgbtn imgbck"><span onclick="return btn_AprDeptTempletAddCC_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
			                                        </td>
			                                    </tr>
			                                </table>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td style="vertical-align: top;">
			                                <div class="border_gray">
			                                    <div id="RecSaveDetailCC" style="Width: 386px; Height: 208px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
			                                    </div>
			                                </div>
			                        	</td>
			                    	</tr>
			                	</table>
		                    	<table style="width: 100%;">
		                        	<tr>
		                            	<td style="text-align: left; height: 30px;">
		                        	</tr>
		                    	</table>
			                </div>
			            </td>
			            <td style="vertical-align: top;">
			                <h2 class="h2_dot"><spring:message code='ezApprovalG.hyj20'/>
			                </h2>
			                <div class="border_gray" style="margin-top:7px; margin-left:4px;">
                                <div id="APRLINECC" style="Width: 717px; Height: 518px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                              	</div>
                            </div>
			                <div style="text-align: right;">
			                    <a class="imgbtn imgbck" style="padding-right: 5px; margin-top: 10px;"><span id="Span5" onclick="return btn_AprDeptTempletSaveCC_onclick('NEW')"><spring:message code='ezApprovalG.hyj07'/> </span></a>
			                </div>
			            </td>
			        </tr>
			    </table>
		    </div>
	    </c:if>
	    <c:if test="${approvalFlag eq 'G' }">
			<!-- 비전자문서 정보 -->
			<div id="NonElecRecInfo" style="width: 100%; height: 597px; display: none;">
				<c:if test="${guBun eq '6'}">
				<h2 class="h2_dot"><spring:message code='ezApprovalG.t1018'/></h2><!-- 기록물철 정보 -->
				<table style="width:100%" class="content">
					<tr>
        				<th><spring:message code='ezApprovalG.t1063'/></th><!-- 기록물철 이름 -->
						<td style="padding-right:15px;white-space:nowrap">
							<table style="width:100%">
            					<tr>
            						<td id="tdCabinetName">&nbsp;</td>
            					</tr>
     						</table>
						</td>
						<th><spring:message code='ezApprovalG.t572'/></th><!-- 연번 -->
						<td id="tdCabinetSN" style="padding-right:15px;width:300px;white-space:nowrap">&nbsp;</td>
					</tr>
					<tr>
	        			<th><spring:message code='ezApprovalG.t1065'/></th><!-- 형태 -->
						<td id="tdCabinetType" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
						<th><spring:message code='ezApprovalG.t573'/></th><!-- 권호수 -->
						<td id="tdCabinetVolNo" style="padding-right:15px;white-space:nowrap">&nbsp;</td>
            		</tr>
	        	</table>
	        	</c:if>
				<table style="width: 100%;">
					<tr>
	        			<td>
            				<h2 class="h2_dot"><spring:message code='ezApprovalG.t1066'/></h2><!-- 기록물 기본등록사항 -->
							<table style="width: 100%;" id="tblBasicInfo" class="content">
								<tr>
	        						<th><spring:message code='ezApprovalG.t859'/></th><!-- 등록구분 -->
									<td>
	        							<select id="selRegisterType" style="width:150px" onChange="return selRegisterType_onchange()" name="select"></select>
	        						</td>
								</tr>
								<tr>
									<th><spring:message code='ezApprovalG.t1067'/></th><!-- 기록물 제목 -->
									<td>
	        							<input type="text" name="txtTitle" id="txtTitle" class="text" style="Width:100%;">
	        						</td>
								</tr>
								<tr>
	        						<th><spring:message code='ezApprovalG.t831'/></th><!-- 등록일자 -->
									<td>
								        <input type="text" class="text" style="height:16px;padding:0px;margin:0px;" value="${regY}" name="txtRegY" id="txtRegY" maxlength = "4" size="4">
							            <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t456'/></span>
							            <input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" value="${regM}" name="txtRegM"  id="txtRegM" maxlength = "2" size="2">
							            <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t968'/></span>
							            <input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" value="${regD}" name="txtRegD"  id="txtRegD" maxlength = "2" size="2">
							            <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t662'/></span>
							            <input type="text" class="text" style="height:16px;padding:0px;margin:0px;" value="${regH}" name="txtRegH"  id="txtRegH" maxlength = "2" size="2">
							            <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t977'/></span>
							            <input type="text" class="text" style="height:16px;padding:0px;margin:0px;" value="${regMi}"  name="txtRegMi"  id="txtRegMi" maxlength = "2" size="2">
							            <span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t1068'/></span>
							        </td>
								</tr>
								<tr style="display: none;">
									<th><spring:message code='ezApprovalG.t979'/></th><!-- 쪽수 -->
									<td>
	        							<input type="text" name="txtTotalPage" id="txtTotalPage" class="text" style="Width:60px;padding:0px;margin:0px;">&nbsp;
										<span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t980'/></span>
	        						</td>
								</tr>
								<tr id="trAprMemberTitle">
	        						<th><spring:message code='ezApprovalG.t862'/></th><!-- 결재권자 -->
									<td>
	        							<input type="text" name="txtAprMemberTitle" id="txtAprMemberTitle" class="text" style="Width:100%;">
	        						</td>
								</tr>
								<tr>
	        						<th><spring:message code='ezApprovalG.t445'/></th><!-- 기안자 -->
									<td>
	        							<input type="text" name="txtDrafter" id="txtDrafter" class="text" style="Width:100%;">
		    						</td>
								</tr>
								<tr>
            						<th><spring:message code='ezApprovalG.t863'/></th><!-- 시행일자 -->
  	    							<td>
										<input type="text" class="text" style="Width:40px;height:16px;padding:0px;margin:0px;" name="txtExeY" id="txtExeY" maxlength = "4">
										<span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t456'/></span>
										<input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" name="txtExeM"  id="txtExeM" maxlength = "2">
										<span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t968'/></span>
										<input type="text" class="text" style="Width:25px;height:16px;padding:0px;margin:0px;" name="txtExeD"  id="txtExeD" maxlength = "2">
										<span style="height:14px;padding:0px;margin:0px;vertical-align:middle;"><spring:message code='ezApprovalG.t662'/></span>
            						</td>
	        					</tr>
	       						<tr>
									<th >발신기관명</th><!--발신기관명-->
									<td>
							        	<input type="text" name="txtReceiptMember" id="txtReceiptMember" class="text" style="Width:100%;">
							        </td>
								</tr>
								<tr id="trDeliveryNo" style="display: none;">
						 	        <th><spring:message code='ezApprovalG.t1069'/></th><!-- 문서과 배부번호 -->
									<td>
							       		<input type="text" name="txtDeliveryNo" id="txtDeliveryNo" class="text" style="Width:100%;" maxlength="5">
								    </td>
								</tr>
								<tr id="trOriginSN" style="display: none;">
								    <th>문서번호</th><!-- 문서번호 -->
									<td>
							        	<input type="text" name="txtOriginSN" id="txtOriginSN" class="text" style="Width:100%;" maxlength="9">
								    </td>
								</tr>
								<c:if test="${guBun ne '1'}">
									<tr>
									    <th><spring:message code='ezApprovalG.t94'/></th><!-- 특수목록 -->
										<td>
								        	<table border="0" style="width:100%;border-collapse:collapse; border-spacing:0;padding:0px;" >
								       			<tr>
								               		<td id="tdSpecialFlag">&nbsp;</td>
								               		<td style="width:70px">
								                       <img src="/images/btn_add.gif" style="display:none;cursor:pointer;vertical-align:middle" id="btnAddSC" name="btnAddSC" onClick="return btnAddSpecialCatalog_onclick()" width="39" height="20">
						                            </td>
							                    </tr>
								            </table>
								    	</td>
									</tr>
								</c:if>
								<tr>
								    <th><spring:message code='ezApprovalG.t868'/></th><!-- 전자기록물여부 -->
									<td style="text-align:left">
										<input type="radio" name="rdoElectronicFlag" value="1" style="height:13px;width:13px;padding:0px;margin:0px;vertical-align:top; display: none;" disabled="disabled">
										<%-- <span><spring:message code='ezApprovalG.t981'/></span> --%>
										<input type="radio" name="rdoElectronicFlag" style="height:13px;width:13px;padding:0px;margin:0px;" value="2" checked>
										<span><spring:message code='ezApprovalG.t1070'/></span>
								    </td>
								</tr>
								<tr>
								    <th><spring:message code='ezApprovalG.t58'/></th><!-- 분리첨부 -->
									<td>
								        <a class="imgbtn">
						     	           <span id="btnAddSepAttach" onClick="return btnAddSepAttach_onclick()" style="" >
						     	           <c:choose>
						     	           		<c:when test="${guBun eq '1'}">
							     	           		<spring:message code='ezApprovalG.t949'/>
						     	           		</c:when>
						     	           		<c:otherwise>
						     	           			<spring:message code='ezPersonal.jjs01'/>
						     	           		</c:otherwise>
						     	           </c:choose>
						     	           </span>
				                        </a>
					                </td>
				                </tr>
			        		</table>
			        		<div id="divAudioVisualDummy" style="display:none"></div>
			        		<div id="divAudioVisual" style="display: none">
			        			<h2 class="h2_dot"><spring:message code='ezApprovalG.t1074'/></h2><!-- 시청각 기록물 추가등록 사항 -->
			        			<table style="width:100%;" class="content">
									<tr>
				        				<th><spring:message code='ezApprovalG.t1075'/></th>
										<td>
				        					<TextArea style="width:99%; height:60px" id=txtSummary name=txtSummary></TextArea>
				        				</td>
									</tr>
									<tr>
				        				<th><spring:message code='ezApprovalG.t826'/></th>
										<td>
				        					<div id=tdAVType style="overflow:auto;"></div>
											<div id="lstAttachLink" style="display: none;"></div>
	                                    </td>
	                        	    </tr>
			                    </table>
			        		</div>
						</td>
						<%-- <td>
			        		<div id="divAudioVisualDummy" style="display:none"></div>
							<div id="divAudioVisual" style="display: none">
								<h2><spring:message code='ezApprovalG.t1074'/></h2><!-- 시청각 기록물 추가등록 사항 -->
								<table style="width:100%; margin-left:5px;" class="content">
									<tr>
				        				<th><spring:message code='ezApprovalG.t1075'/></th>
										<td>
				        					<TextArea style="width:98%; height:180px" id=txtSummary name=txtSummary></TextArea>
				        				</td>
									</tr>
									<tr>
				        				<th><spring:message code='ezApprovalG.t826'/></th>
										<td>
				        					<div id=tdAVType style="overflow:auto;"></div>
											<div id="lstAttachLink" style="display: none;"></div>
	                                    </td>
	                        	    </tr>
			                    </table>
		                    </div>
	                    </td> --%>
		            </tr>
			    </table>
			</div>
		</c:if>
	    <br />
	    <div style="text-align: center;" id="orgbtnArea">
	        <table style="width: 100%">
	            <tr>
	                <td style="text-align: center;">
	                	<div class="btnpositionNew">
	                    	<a class="imgbtn"><span style="text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>
	                    </div>	
	                </td>
	            </tr>
	        </table>
	    </div>
	    <!-- 사용자 정보 해더 xml -->
	    <xml id="userlist_h" style="display: none">
		    <LISTVIEWDATA>
		    <HEADERS>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.G0028'/></NAME>
		        <WIDTH>70</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.G0029'/></NAME>
		        <WIDTH>100</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.G0030'/></NAME>
		        <WIDTH>60</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t231'/></NAME>
		        <WIDTH>80</WIDTH>
		        </HEADER>
		    </HEADERS>
		    <ROWS></ROWS>
		    </LISTVIEWDATA>
		</xml>
	    <xml id="Category_h" style="display: none">
		    <LISTVIEWDATA>
		    <HEADERS>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t10026'/></NAME>
		        <WIDTH>17%</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t693'/> (<spring:message code='ezApprovalG.t10091'/>)</NAME>
		        <WIDTH>24%</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t577'/> (<spring:message code='ezApprovalG.t10091'/>)</NAME>
		        <WIDTH>24%</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t1065'/></NAME>
		        <WIDTH>15%</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t10027'/></NAME>
		        <WIDTH>10%</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.t10092'/></NAME>
		        <WIDTH>10%</WIDTH>
		        </HEADER>
		    </HEADERS>
		    <ROWS></ROWS>
		    </LISTVIEWDATA>
		</xml>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <!-- 사용자 정보 해더 xml -->
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	    Tab2_NewTabIni("tab2");
	    Tab3_NewTabIni("tab3");
	    if (approvalFlag == "S") {
		    Tab5_NewTabIni("tab5");
	    }
	</script>
</html>
