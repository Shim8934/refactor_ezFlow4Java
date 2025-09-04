<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html id="htmlhag" style="overflow:hidden">
	<head>
	    <title><spring:message code='ezApprovalG.t1742'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Circulation.js')}"></script>
	    
	    <style type="text/css">
	    	.h2_dot {
	    		background: url(/images/kr/left/left_dot02.gif) no-repeat 0px 70%;
	    	}
	    	.h2_dot.temp_h2_dot {
		    	background: url(/images/kr/left/left_dot02.gif) no-repeat 0px 60%;
		    	height: 30px;
		    	line-height: 32px;
		    	margin-bottom: 1px;
	    	}
	    	.sub_iconLNB.tree_plus, .sub_iconLNB.tree_minus {
	    		margin-top : 0px !important;
	    	} 
	    	#lvinfofrequencylist{
	    		border: 1px solid #ddd !important;
	    	}

			<c:if test="${userInfo.lang == '3'}">
				.popuplist tr td {
					display: flex;
					align-items: center; 
				}
	r
				.popuplist input {
					vertical-align: middle; 
				}
	
				.popuplist span {
					vertical-align: middle;
					line-height: 21px;
				}
			</c:if>

		</style>
	    <script type="text/javascript">
	    	var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var OrderCell = "";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user"; 							// 사용자-부서구분
	        arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";           // 사용자ID
	        arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";      // 사용자명
	        arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";            // 사용자 직위
	        arr_userinfo[4] = "<c:out value ='${userInfo.deptID}'/>";           // 사용자 부서 ID
	        arr_userinfo[5] = "${userInfo.deptName}";         // 사용자 부서 이름
	        arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";          // 사용자 직책            
	        arr_userinfo[7] = "N";                                        // 부재중 설정
	        arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";            // E-Mail Address 
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";             // 수신 접수담당자
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>"; 	// 사용자명(P)
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>"; 	// 사용자명(S)
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>"; 			// 사용자 직위(P)
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>"; 			// 사용자 직위(S)
	        arr_userinfo[15] = "${userInfo.deptName1}"; 		// 사용자 부서 이름(P)
	        arr_userinfo[16] = "${userInfo.deptName2}"; 		// 사용자 부서 이름(S)
	        arr_userinfo[17] = "<c:out value ='${userInfo.companyID}'/>";
	        var primary = "<c:out value ='${primary}'/>"; // 다국어 여부 - 1(primary) / 2(secondary)
	        var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
	        var companyID = "<c:out value ='${userInfo.companyID}'/>";
	        var UserLang = "<c:out value ='${userInfo.lang}'/>";
	        var DeptID = "<c:out value ='${userInfo.deptID}'/>";
	        var USE_OCS = "<c:out value ='${useOcs}'/>";
	        var useDoc24 = "<c:out value ='${useDoc24}'/>";
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
	        var linealt18 = "<spring:message code='ezApprovalG.kmsg02'/>"
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
	        var optGamsabu = "<c:out value ='${optGamsabu}'/>";        
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
	        var pkeyword = "";
	        var ret = new Array();
	        var CurAprLine;
	        var pReDraftAprLineChangeFlag = false;
	        var pHapyuiArea = 0;
	        var pAprLineArea = 0;
	        var onlydocinfiview;
	        var onlyviewsusin = false;
	        var pIniGubun = "<c:out value ='${guBun}'/>";
	        var AdminYN = "FALSE";
	        var szRoleInfo = "<c:out value ='${userInfo.rollInfo}'/>";
	        var g_bRecAdmin = false;	//기록물 관리책임자 여부
	        var g_bDeptCharger = false;	//부서업무 담당자 여부
	        var g_InitFlag = "<c:out value ='${initFlag}'/>";
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
	        var pDocSn = "<c:out value ='${docSN}'/>";
	        var SusinGroupUseFlag = "<c:out value ='${susinGroupUseFlag}'/>";
	        /* 2015-06-23 추가 - KSK */
	        var T1361andT1362 = "<spring:message code='ezApprovalG.t1361'/>" + "<spring:message code='ezApprovalG.t1362'/>";
	        var SummaryOuterReceiverList = "";
			var useAddressOpenAPI = "<c:out value ='${useAddressOpenAPI}'/>";
			var checkdocinfo = false;
			var startDateTime = "<c:out value ='${startDateTime}'/>";
			var pSignImage_Size = "<c:out value ='${signImageSize}'/>";
			var pAdmin = "N";
			var pGongRamDocID;
			// 기안(DRAFT), 접수(RECV), 합의(HABYUI), 접수기안된 수신문서(SUSIN) 여부
			var approvalType;
			var chamjoAfterYN = "<c:out value ='${chamjoAfterYN}'/>";
			var isUsed = "<c:out value ='${isUsed}'/>";
			var beforeDocID = "<c:out value ='${beforeDocID}'/>";
			var receptGubunYN = "<c:out value ='${receptGubunYN}'/>";
			var addLastKyulJeYN = "<c:out value ='${addLastKyulJeYN}'/>";
	        var orgCompanyID = "<c:out value ='${orgCompanyID}'/>";
	        var ext = "<c:out value ='${ext}'/>";
	        var nonElecRec = "";
	        var nonElecRecInfoXml = "";
	        var g_CabID = "";
	        var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>";
	        var useConfirmParallelAgreement = "<c:out value ='${useConfirmParallelAgreement}'/>";
	        var filterTimerId;
	        //원문정보공개
	        var useOpenGov = "<c:out value ='${useOpenGov}'/>";
	        var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate = "";
	        var OrgAprUserDeptID = "";
	        var useDynamicAprLine = "<c:out value ='${useDynamicAprLine}'/>";
			var passAprLine = "";
			var isOuterForm = ${isOuterForm};
			// 2020-11-23 등급 툴팁 추가 - 박기범
	        var tooltipLevelFlag = "Y"
	        
	        // 부서감사 관련 2020-01-14 홍대표
	        var pDeptgamsaCount = 0;
			
			/* 2021-04-19 홍승비 - 수신문서 회송여부를 판단하기 위한 변수 추가 */
			var isSusinReset = false;
			var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>";
			
			/* 2022-01-14 홍승비 - 일괄기안 관련 변수 추가 */
			var curDocID = "";
			var draftAllFlag = "<c:out value ='${draftAllFlag}'/>";
			var pDocIDAry = new Array();
			var receiptFlag = opener != null ? opener.receiptFlag : parent.receiptFlag;
			
			// 일괄기안 B타입 플래그 추가
            var draftAllTypeB = "<c:out value='${draftAllTypeB}'/>";

			var doctitle;

            var isfileup = false;
			var convertedImgInfo;

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";

	        $(function () {
	        	if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
	        		document.getElementById("tblwrap").style.height = (document.documentElement.clientHeight - 143) + 'px';
	        		document.getElementById("tblwrap").style.overflowY = 'auto';
	        	}
	        	
	        	if (document.getElementById("AprSecurity").checked){
	        		$("#idDatepicker").attr('disabled',false);
	        	} else {
	        		$("#idDatepicker").attr('disabled',true);
	        	}

                if (useOpenGov == "YES") {
                    if (document.getElementById("openGovLimitDate").checked){
                        $("#idDatepickerForOpenGov").attr('disabled',false);
                    } else {
                        $("#idDatepickerForOpenGov").attr('disabled',true);
                    }

                    $("#idDatepickerForOpenGov").datepicker({
                        changeMonth: true,
                        changeYear: true,
                        autoSize: true,
                        showOn: "both",
                        buttonImage: "/images/ImgIcon/calendar-month.png",
                        buttonImageOnly: true
                    });
                }

	        	$("#idDatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
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
	            
				if (!navigator.maxTouchPoints > 4 && isTeamsDesktop()) {
					document.getElementById('textUser').focus();
				}
	            
	            if (SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0] == null) {
	                document.getElementById("deptaddbtn").style.display = "none";
	            }
	            
                for (i = 0; i < SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length; i++) {
                    if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE") == strAprType13) {
                        if (pDeptgamsaCount == 0) {
                            var node = SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i];
                            var pnode = SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES")[0];
                            pnode.removeChild(node);
                            break;
                        }
                    }
                }

//                 for (i = 0; i < SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length; i++) {
//                     if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE") == strAprType21) {
//                         if (pYesanCount == 0) {
//                             var node = SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i];
//                             var pnode = SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES")[0];
//                             pnode.removeChild(node);
//                             break;
//                         }
//                     }
//                 }

                if (pDeptgamsaCount > 0) {
                    document.getElementById("btnAddGamsaDept").style.display = "";
                }
                
                if (pDeptgamsaCount > 0) {
                    GetGamsaYesanDeptInfo();
                }
            
	            if (approvalFlag == "G") {
		            CheckGubunInit();
		            
		         	// 2023-06-12 임정은 - 공람 추가
		         	if ((approvalType != "DRAFT" && approvalType != "RECV" && approvalType != "SUSIN") || nonElecRec == "Y") {
	            		document.getElementById("showHRAprLine").style.display = "none";
	            	}
					
		            if (pReDraftFlag == "DRAFT" || pReDraftFlag == "REDRAFT") {
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
	            
	            $("input[name=auditApprLine]").unbind().on("change", function() {
                	var attrArray = new Array();
    				var propArray = new Array();
    				var rows = new Array();
    				var apprLineList = new ListView();
    				
    	        	attrArray.push("userId");
    	        	attrArray.push("userNm");
    	        	attrArray.push("deptId");
    	        	attrArray.push("deptNm");
    	        	attrArray.push("userNm2");
    	        	attrArray.push("deptNm2");
    	        	attrArray.push("position");
    	        	attrArray.push("auditApprLineId");
    	        	attrArray.push("orderBy");
    	        	
    	        	propArray.push("userNm");
    	        	propArray.push("deptNm");
    	        	propArray.push("position");
    	        	propArray.push("telephoneNumber");
    	        	propArray.push("absence");
    	        	
    	        	apprLineList.LoadFromID("lvAPRLINE");
    	        	rows = apprLineList.GetDataRows();
    	        	
   	        		for(var i=0; i<rows.length; i++) {
   	        			if($(rows[i]).attr("DATA11") == "005" && $(rows[i]).attr("DATA12") == "001") {
	   	 					$(rows[i]).trigger("click");
	   	 					AprLineDel_onclick_action();
	   	 				}
	   	 			}
    				
    				$.ajax({
    		        	type : "POST",
    		        	dataType : "text",
    		        	async : false,
    		        	url : "/admin/ezOrgan/getAuditApprLineList.do",
    		        	data : {
    		        		companyID : companyID,
    		        		pageNum : 1,
    		        		pageSize : 15,
    		        		searchType : "",
    		        		searchValue : "",
    		        		auditApprLineId : this.value,
    		        		propArray : JSON.stringify(propArray),
    		        		attrArray : JSON.stringify(attrArray),
    		        		value : "userNm"
    		        	},
    		        	success : function(xml){
    		        		var validUserArray = new Array();
    		        		var xmlResult = loadXMLString(xml);
    		        		var xmlRow = xmlResult.documentElement.getElementsByTagName("ROW");
    		        		
    		        		if(xmlRow.length == 0) {
    		        			OpenAlertUI("<spring:message code='ezApprovalG.auditApprLine.06'/>");
    		        			return;
    		        		}
    		        		
    		        		for(var i=0; i<xmlRow.length; i++) {
    		        			var isValidUser = false;
    		        			var xmlRowCell = xmlRow[i].getElementsByTagName("CELL");
    		        			var xmlDoc = createXmlDom();
    		        			var data1 = xmlDoc.createElement("DATA1");
    		        			var data2 = xmlDoc.createElement("DATA2");
    		        			var data3 = xmlDoc.createElement("DATA3");
    		        			var data4 = xmlDoc.createElement("DATA4");
    		        			var data5 = xmlDoc.createElement("DATA5");
    		        			var data6 = xmlDoc.createElement("DATA6");
    		        			var data7 = xmlDoc.createElement("DATA7");
    		        			var data8 = xmlDoc.createElement("DATA8");
    		        			var data9 = xmlDoc.createElement("DATA9");
    		        			var data10 = xmlDoc.createElement("DATA10");
    		        			var data11 = xmlDoc.createElement("DATA11");
    		        			var data12 = xmlDoc.createElement("DATA12");
    		        			var absence = xmlDoc.createElement("ABSENCE");
    		        			var junbubYn = xmlDoc.createElement("JUNBUBYN");
    		        			var apprLineType = xmlDoc.createElement("APPRLINETYPE");
    		        			
    		        			data1.appendChild(xmlDoc.createTextNode("user"));
    		        			data2.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("userId")[0].textContent));
    		        			data3.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("deptId")[0].textContent));
    		        			data4.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("VALUE")[0].textContent));
    		        			data5.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("deptNm")[0].textContent));
    		        			data6.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("position")[0].textContent));
    		        			data7.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("userNm")[0].textContent));
    		        			data8.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("userNm2")[0].textContent));
    		        			data9.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("deptNm")[0].textContent));
    		        			data10.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("deptNm2")[0].textContent));
    		        			data11.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("position")[0].textContent));
    		        			data12.appendChild(xmlDoc.createTextNode(xmlRowCell[0].getElementsByTagName("position")[0].textContent));
    		        			absence.appendChild(xmlDoc.createTextNode(""));
    		        			junbubYn.appendChild(xmlDoc.createTextNode(""));
    		        			apprLineType.appendChild(xmlDoc.createTextNode("audit_add"));
    		        			
    		        			xmlRowCell[0].appendChild(data1);
    		        			xmlRowCell[0].appendChild(data2);
    		        			xmlRowCell[0].appendChild(data3);
    		        			xmlRowCell[0].appendChild(data4);
    		        			xmlRowCell[0].appendChild(data5);
    		        			xmlRowCell[0].appendChild(data6);
    		        			xmlRowCell[0].appendChild(data7);
    		        			xmlRowCell[0].appendChild(data8);
    		        			xmlRowCell[0].appendChild(data9);
    		        			xmlRowCell[0].appendChild(data10);
    		        			xmlRowCell[0].appendChild(data11);
    		        			xmlRowCell[0].appendChild(data12);
    		        			xmlRowCell[0].appendChild(absence);
    		        			xmlRowCell[0].appendChild(junbubYn);
    		        			xmlRowCell[0].appendChild(apprLineType);
    		        			
    		        			// 존재하는 사용자인지 검증
    		        			$.ajax({
    		        				type : "POST",
    		        				dataType : "text",
    		        				async : false,
    		        				url : "/ezOrgan/getSearchList.do",
    		        				data : {
    		        					search : "displayName::" + xmlRowCell[0].getElementsByTagName("VALUE")[0].textContent + ";;PhysicalDeliveryOfficeName::" + companyID,
    		        					cell   : "displayName;description;title;telephoneNumber;extensionattribute5",
    		        					prop   : "department;displayName;description;title",
    		        					type   : "user"
    		        				},
    		        				success: function(xml){
    		        					
    		        					var xmlfy = loadXMLString(xml);
    		        					var rows = xmlfy.getElementsByTagName("ROW");
    		        					
    		        					for(var i=0; i<rows.length; i++) {
    		        						var userId = rows[i].getElementsByTagName("CELL")[0].getElementsByTagName("DATA2")[0].textContent;
    		        						var deptId = rows[i].getElementsByTagName("CELL")[0].getElementsByTagName("DATA3")[0].textContent;
    		        						if(userId == xmlRowCell[0].getElementsByTagName("userId")[0].textContent
    		        							&& deptId == xmlRowCell[0].getElementsByTagName("deptId")[0].textContent) {
    		        							isValidUser = true;
    		        						}
    		        					}
    		        					
    		        					if(!isValidUser) {
    		        						validUserArray.push({
    		        							userNm : xmlRowCell[0].getElementsByTagName("VALUE")[0].textContent
    		        							,deptNm : xmlRowCell[0].getElementsByTagName("deptNm")[0].textContent
    		        						});
    		        					}
    		        				}
    		        			});
    		        		}
    		        		
    		        		if(validUserArray.length == 0) {
    		        			var isResult = listViewStart(xmlResult, $("div[divname='listView']").attr("id"));
        		        		if(isResult) {
        		        			list2_onSel_DBclick_audit("tb_"+$("div[divname='listView']").attr("id"));
        		        		}
    		        		} else {
    		        			var msg = "";
    		        			for(var i=0; i<validUserArray.length; i++) {
    		        				msg += "<spring:message code='main.t76' /> : " + validUserArray[i].userNm;
    		        				msg += ", <spring:message code='main.t75' /> : " + validUserArray[i].deptNm;
    		        				msg += "</br>";
    		        			}
    		        			msg += "<spring:message code='ezApprovalG.auditApprLine.06' />";
    		        			
    		        			OpenAlertUI(msg);
    		        		}
    		        	},
    		        	error : function(error){
    		        	    showAlert("<spring:message code='ezOrgan.t2' />" + error);
    		        	}
    		        });
    				$(this).prop("checked", true);
    	    	});
                
                $("#auditAddBtn").unbind().on("click", function() {
		    		// 준법지원인이 들어가있는 확인
			    	var listview = new ListView();
			        listview.LoadFromID("lvAPRLINE");
			    	var rows = listview.GetDataRows();
			    	for(var i=0; i<rows.length; i++) {
			    		if($(rows[i]).attr("JUNBUBYN") == "Y" || $(rows[i]).attr("APPRLINETYPE") == "audit_add" || $(rows[i]).attr("DATA11") == "005") {
			    			OpenAlertUI("<spring:message code='ezApprovalG.auditApprLine.01' />");
			    			return;
			    		}
			    	}
			     
			        // 준법지원인을 가져오기
		    		$.ajax({
		    			type : "POST",
			        	dataType : "text",
			        	url : "/ezApprovalG/getAuditAdd.do",
			        	data : {
			        		companyID : "${userInfo.companyID}",
			        		type : "s=1",
			        		pageNum : "1",
			        		pageSize : "1",
			        		searchType : "displayname",
			        		searchValue : "",
			        		cell : "displayName;description;title;junbubYn;extensionattribute5",
			        		prop : "department;displayName;description;title"
			        	},
			        	success : function(xml) {
			        		var isResult = listViewStart(loadXMLString(xml), $("div[divname='listView']").attr("id"));
			        		
			        		if(isResult) {
			        			OpenInformationUI("<spring:message code='ezApprovalG.auditApprLine.05'/>", function(result) {
				        			if(result) {
				        				list2_onSel_DBclick_audit("tb_"+$("div[divname='listView']").attr("id"));
				        			} else {
				        				OpenInformationUI_Complete();
				        			}
				        		});
			        		}
			        	},
			        	error : function(error){
			        	    showAlert("<spring:message code='ezOrgan.t2' />" + error);
			        	}
			    	});
		    	});
	            
	            if (approvalFlag != "G" || useOpenGov != "YES") {
	            	$(".openGov").hide();
	            }

                if (pReDraftFlag == "SUSIN") {
                	$('.openGov').hide();
				}
                
             	// 2020-11-23 등급 툴팁 추가 - 박기범
                giveTooltipLevel();
             	if(useDoc24 == "YES"){
             		getDoc24List();
             	}
             	
             	/* 2022-02-21 홍승비 - 일괄기안문서의 경우, 부서합의는 사용 불가하므로 부서추가버튼 숨김처리 (개인병렬, 개인순차합의는 가능) */
             	 if (draftAllFlag == "Y") {
 	                document.getElementById("deptaddbtn").style.display = "none";
 	            }
             	
             	if (receiptFlag == "R") {
	             	// 2024-05-13 조수빈 - 일괄접수 시 문서정보 탭이 나타나지 않도록 처리
             		document.getElementById("showDocinfo").style.display = "none";
	             	// 2024-05-21 조수빈 - 일괄접수 시 문서 정보가 유지됨을 안내하는 문구 추가
             		var h1_header = document.getElementById("h1_header");
             		h1_header.parentNode.style.display = 'flex';
	             	var newH2 = document.createElement('h1');
	             	var h2Text = document.createTextNode("<spring:message code='ezApprovalG.jsb01'/>");
	             	newH2.appendChild(h2Text);
	             	newH2.style.marginLeft = '10px';
	             	newH2.style.color = 'red';
	             	
	             	h1_header.parentNode.insertBefore(newH2, h1_header.nextSibling);
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
	                if (isParentCommonArgsUsed()) {
						RetValue = opener == null ? parent.ezCommon_cross_dialogArguments[0] : opener.ezCommon_cross_dialogArguments[0];
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					} else {
						RetValue = parent.ezapprovalinfo_dialogArguments[0];
						ReturnFunction = parent.ezapprovalinfo_dialogArguments[1];
					}
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
                pReDraftFlag = RetValue[5];        //기안 Flag : REDRAFT / DRAFT / SUSIN
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
	            OrgAprUserDeptID = RetValue[52];
	            pkeyword = RetValue[61];
	            
	            if (nonElecRec == "Y") {
	            	g_CabID = RetValue[47];
	            	nonElecRecInfoXml = RetValue[48];
	            	g_SepAttachLVXml = RetValue[49];
	            	g_szSCListXml = RetValue[50];
	            	sepAttachCheckYN = RetValue[51];
	            	
	            	if (pIniGubun == "1") {
		        		document.title = "문서정보";
	                    document.getElementById("h1_header").innerHTML = "문서정보";
		        	}
	            }
	            
	            basis = RetValue[52];
	            reason = RetValue[53];
	            listOpenFlag = RetValue[54];
	            fileOpenFlagList = RetValue[55];
	            limitDate = RetValue[56];
	            passAprLine = RetValue[60];
	            
	            /* 2022-01-14 홍승비 - 일괄기안 관련 파라미터 추가 */
	            if (RetValue[62] != undefined) { // 일괄기안 플래그
		            draftAllFlag = RetValue[62];
	            }
	            if (RetValue[63] != undefined && RetValue[63].length > 1) { // 전체 문서ID 배열
	            	pDocIDAry = RetValue[63];
	            }
	            if (RetValue[64] != undefined) { // 현재 선택한 탭의 문서ID
	            	curDocID = RetValue[64]; 
	            }
				if (RetValue[65] != null && RetValue[65].trim() !== "") {
					doctitle = RetValue[65];
				}
	            
				//기결재통과 버튼 표출 체크
				showPassAprLineBtn();
	            pDeptgamsaCount = RetValue[43];
	            
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
	            } catch (e) { showAlert(e.description); }

	            if(useOpenGov == "YES") {
                    getAttachList();
				}

	            if (approvalFlag == "S") {
	            	//(재)기안, 수신접수, 합의접수가 아닌 구분 상태에서는 결재선 즐겨찾기(탭, 버튼) 숨김처리
		            if (pIniGubun != "1" && pIniGubun != "9" && pIniGubun != "11") {
		            	document.getElementById("2tab2").style.display = "none";
		            	document.getElementById("SaveAprLineTemplet").style.display = "none";
		            }
	            }
	            
	            /* 2020-07-30 홍승비 - 실제 양식 상에 가변결재선이 없다면, 분기를 타지 않도록 수정 */
				// 2021-02-19 박희찬 - 가변결재선이 G버전에도 동작가능하도록 조건문 수정
	            if (useDynamicAprLine == "1") { // 사용 여부 체크 분기 추가 (일반버전 + 테넌트컨피그)
	            	var autoAprLineField = $(opener.document).find("#message").contents().find("td[id^='autoLine']");
	            
					// 가변결재양식 사용 시, 최대 사인칸 20개로 고정
					// 2021-02-19 박희찬, 최대 사인칸 10개로 수정
		    	    if (autoAprLineField.length > 0) {
		    	    	pSignCount = 10;
		    	    	// (개인,부서)합의는 기안할때만 사용하도록
		    	    	if (approvalType == "DRAFT") {
			    	    	pHapYuiCount = 10;
		    	    	}
		    	    }
	            }
	            
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
				else if (pIniGubun == "14") { //공람
					document.getElementById("showAprLine").style.display = "none";
					document.getElementById("showCabinetinfo").style.display = "none";
					document.getElementById("showDocinfo").style.display = "none";
					document.getElementById("1tab5").onclick();
					ChangeTab(document.getElementById("1tab5"));
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
	                    document.getElementById("Circulation").style.display = "none";

	                    if (approvalFlag == "G") {
	                    	document.getElementById("NonElecRecInfo").style.display = "none";
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
	                    document.getElementById("Circulation").style.display = "none";

	                    if (approvalFlag == "G") {
		                    document.getElementById("NonElecRecInfo").style.display = "none";
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
	                    document.getElementById("Circulation").style.display = "none";
	                    
	                    if (approvalFlag == "G") {
		                    document.getElementById("NonElecRecInfo").style.display = "none";
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
	                    document.getElementById("Circulation").style.display = "none";
	                    
	                    if (approvalFlag == "G") {
		                    document.getElementById("NonElecRecInfo").style.display = "none";
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
		            showAlert("Suggester_onclick :: " + e.description);
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
		            showAlert("Reporter :: " + e.description);
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
		
		    function btnSearchDoc24_onKeyPress(e) {
		        if (e.keyCode == "13") {
		            document.getElementById("Span8").onclick();
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
		            showAlert("getGyulJeDateDB()" + e.description);
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
		    
		    /* 2020-08-03 홍승비 - 결재자가 한 명인 경우(기안자 = 최종결재자), 수신처 회송 시 기결재기능 사용하지 못하도록 수정 */
			function btn_OK() {

				if (!window.opener || window.opener.closed) {
					OpenAlertUI("<spring:message code='ezApprovalG.km03' />", btn_Close2);
					return;
				}
				
				var chkReceivedDoc = 0;

				/* 2022-04-26 홍승비 - 중복 접수 방지 로직은 접수창(approvalType="RECV")에서만 동작하도록 분기처리 추가 */
				if (approvalType == "RECV") {
					// 이미 접수된 문서인지 확인하기
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
	
					if (chkReceivedDoc != 0) {
						showAlert("<spring:message code='ezApprovalG.pjg04'/>", "");
						// opener.close();
						// window.close();
						return;
					}
				}

		    	var aprLineCnt = $("#lvAPRLINE").find("tr[data11='001']"); // 결재
		    	var draftLineCnt = $("#lvAPRLINE").find("tr[data11='018']"); // 기안
		    	var aprJLineCnt = $("#lvAPRLINE").find("tr[data11='004']"); // 전결
		    	var aprDLineCnt = $("#lvAPRLINE").find("tr[data11='016']"); // 대결
		    	
		    	/* 2020-10-30 홍승비 - 일반버전과 G버전의 기결재통과 조건 분리 */
		    	if (approvalFlag == "S") {
			    	if (document.getElementById('passAprLine').checked && pReDraftFlag === 'REDRAFT' && aprLineCnt.length <= 1) {
			    		OpenAlertUI("결재자가 한 명인 경우, 기결재통과 기능을 사용할 수 없습니다.");
			    		return;
			    	}
		    	} else { // 기안자 = 최종결재자인 경우 기안자의 유형은 "결재" / 기안자 != 최종결재자인 경우 기안자의 유형은 "기안" 
		    		// G버전의 경우, 최종결재자는 결재/전결/대결 타입이 가능함
		    		var aprLineCntSum = (aprLineCnt.length + aprJLineCnt.lenght + aprDLineCnt.length);
			    	if (document.getElementById('passAprLine').checked && pReDraftFlag === 'REDRAFT' && (draftLineCnt.length <= 0 && aprLineCntSum <= 1)) {
			    		OpenAlertUI("결재자가 한 명인 경우, 기결재통과 기능을 사용할 수 없습니다.");
			    		return;
			    	}
					/* 2024-03-26 양지혜 - 공개가 아닌경우 공개등급 선택 필수 */
					if (document.querySelector('input[name="rdoSecType"]:checked').value != '1') {
						var checkboxes = document.querySelectorAll('input[name^="selSecLevel"]:checked');
						if (checkboxes.length === 0) {
							OpenAlertUI("<spring:message code='ezApprovalG.yjh01'/>");
							return;
						}
					}
		    	}
		    	
				if(document.getElementById('passAprLine').checked && pReDraftFlag === 'REDRAFT') {
					OpenInformationUI('기결재통과가 체크되어 있습니다.<br>계속 진행하시겠습니까?', btn_OK_Confirm);
	        		return;
	        	} else {
	        		btn_OK_Confirm(true);
	        	}
			}
			
			function btn_OK_Confirm(Ans) {
		        try {
		        	if (Ans != true) { // 기결재통과 기능 사용 시 OpenInformationUI의 리턴값 체크
		        		DivPopUpHidden();
		        		return;
		        	}
		        	
		            if (!onlydocinfiview) {
		                var line = Checkline();
		                if (line == false) {
		                    return;
		                }

		                if (approvalFlag == "G") {
			                if (pIniGubun != 5 && pIniGubun != 7 && pIniGubun != 10 && pIniGubun != 12) {
			                	if (!$("input:checkbox[id='passAprLine']").is(":checked")) {
				                    var rtnVal = CheckSignCellValueLast();
				
				                    if (!rtnVal)
				                        return;
			                	}
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
			                
			                if (useOpenGov == 'YES' && document.getElementById("openListFlag").checked == false) {
			                	if (receiptFlag != "R" && $("#txt_Basis").val() == "") {
			                		OpenAlertUI("목록비공개사유를 입력해주세요");
			                		return;
			                	}
			                }
			                
			                ret[0] = "OK";
			                ret[1] = SaveAprLineList(); //결재선 저장 XML
			                
			              	// 2023-05-23 임정은 - 공람 추가
		                    var lineUserCC = CheckAprlineCC();
			                
		                    if (lineUserCC == 1 || lineUserCC == 2) {
		                    	ret[22] = APRLINEXMLParsingCC();
		                    } else if (lineUserCC == -1) {
		                    	ret[22] = "noItem";
		                    } else if (lineUserCC == 0) {
		                    	ret[22] = "sameItem";
		                    }
		                } else {
		                	var checkAprCheckFN;
		                	try {
		                		checkAprCheckFN = parent.checkAprState(); 
		                	} catch (e) {
		                		try {
			                		checkAprCheckFN = opener.checkAprState();
		                		} catch (e) {
		                			
		                		}
		                	}
		                	
		                	if (checkAprCheckFN != null && checkAprCheckFN && (pReDraftAprLineFlag || pReDraftFlag == "REDRAFT") && opener.ListType != "21") {
		                		if(draftAllFlag != "Y" && draftAllTypeB != "Y"){
                                    showAlert("<spring:message code='ezApprovalG.bhs23'/>");
                                    
                                    ret[0] = "DUPL";
                                    if (ReturnFunction != null) {
                                        ReturnFunction(ret);
                                    }
                                    else {
                                        window.returnValue = ret;
                                    }
                                    
                                    window.close();
                                    return;
		                		}
		                	}
		                	
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
		                
		            	// 2021.03.09 박기범 - 키워드 추가
						ret[6] = document.querySelector("input[name=keyword]").value;
		
		                if (approvalFlag == "G") {
			                ret[7] = selSecLevel.value;
			                
			                if (AprUrgency.checked)
			                    ret[8] = "Y";
			                else
			                    ret[8] = "N";
		                } else {
			                ret[7] = RSecurity.value;
			                ret[8] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pUrgentFlag");
			                ret[16] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pkeeperiod");
			                ret[17] = SelectSingleNodeValueNew(docinfo, "PARAMETER/tbItemName");
			                ret[18] = SelectSingleNodeValueNew(docinfo, "PARAMETER/tbItemName2");
			                ret[19] = SelectSingleNodeValueNew(docinfo, "PARAMETER/psecuritylevelvaltemp");
			                ret[20] = SelectSingleNodeValueNew(docinfo, "PARAMETER/pkeeperiodvaltemp");
		                }
		                // ret[9] = document.getElementById("taSummery").value;

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
		                
		                if (document.getElementById("passAprLine").checked) {
		                	ret[32] = "Y";
		                } else {
		                	ret[32] = "N";
		                }
		
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

									if (nonElecRec === "Y" && !CheckInputField()) {
										return;
									}
			                	} else if (!CheckInputField()) { // 기록물정보 입력란 유효성 검사
			                		return;
			                	} else if (convertedImgInfo != undefined) { // 본문첨부 존재할 경우 본문에 이미지 추가
									setConvertedImg(convertedImgInfo);
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
			                if (useOpenGov == "YES") {
                                //원문정보공개 목록공개
                                if (document.getElementById("openListFlag").checked) {
                                    ret[27] = "Y"
                                } else {
                                    ret[27] = "N"
                                }

                                // 원문정보 첨부파일 공개/비공개
                                ret[28] = "";

                                // 일괄기안 시, 원문정보 첨부파일 공개/비공개 플래그를 배열 데이터로 삽입
                                if (draftAllFlag != undefined && draftAllFlag == "Y") {
    			                	var fileOpenFlagListArr = new Array();
    			                	var fileOpenFlagListTemp = "";
    			                	for (var i = 1; i < pDocIDAry.length; i++) { // 0번 인덱스는 제외하고 1안부터 확인
    			                		fileOpenFlagListTemp = "";
    			                		for (j = 0; j < $('input[anno="' + i + '"]').length; j++) { // 첨부파일 인덱스는 0부터 시작
    				                		if ($('input[anno="' + i + '"]')[j].checked) {
    				                			fileOpenFlagListTemp += "Y";
    					                	} else {
    					                		fileOpenFlagListTemp += "N";
    					                	}
    			                		}
    			                		fileOpenFlagListArr[i] = fileOpenFlagListTemp;
    			                	}
    			                	ret[28] = fileOpenFlagListArr;
    			                }
                                else {
	                                for (var i = 0; i < document.getElementsByClassName('fileOpenFlagChk').length; i++) {
	                                    if (document.getElementsByClassName('fileOpenFlagChk')[i].checked) {
	                                        ret[28] += "Y";
	                                    } else {
	                                        ret[28] += "N";
	                                    }
	                                }
    			                }

                                ret[29] = $("#txt_Basis").val();
                                ret[30] = $("#txt_Reason").val();

                                if (document.getElementById("openGovLimitDate").checked) {
                                    ret[31] = document.getElementById("idDatepickerForOpenGov").value.substring(0, 10);
                                } else {
                                    ret[31] = "";
                                }
							}
		                }
		                
			            /* 2020-07-30 홍승비 - 실제 양식 상에 가변결재선이 없다면, 분기를 타지 않도록 수정 */
			            /* 2020-10-19 한글버전은 opener 호출시 오류발생, G버전은 가변 결재선을 사용하지 않음 */
						// 2021-02-19 박희찬 - G버전에도 가변결재선 동작위해 조건문 수정
// 						var autoAprLineField = $(opener.document).find("#message").contents().find("td[id^='autoLine']");
			            try {
							var autoAprLineField = $(opener.document).find("#message").contents().find("td[id^='autoLine']");
						} catch (e) {
							var autoAprLineField = $(parent.document).find("#message").contents().find("td[id^='autoLine']");
						}

						if (useDynamicAprLine == "1" && autoAprLineField.length > 0) {
							ret[27] = SAPRLINETEMPLETXMLParsing();
						}
						
		                if (ReturnFunction != null) {
		                    ReturnFunction(ret);
		                }
		                else {
		                    window.returnValue = ret;
		                }
						
		                // 일괄접수, 일괄접수자전결일 경우에는 결재정보창 유지
		                if (receiptFlag == '' || typeof receiptFlag == 'undefined') {
			                window.close();
		                } else if (receiptFlag == "R") {
		                	var pAlertContent = "";
		                	showLoadingProgress();
		                	setTimeout(function() {
			                	var RtnVal;
		                		RtnVal = opener.receiptAll_btnSendDraft();
	     		        		hideLoadingProgress();
								var arrRtnVal = RtnVal.split("/");
			    		        
			     		        if (arrRtnVal[0] == "OK") {
			     		        	pAlertContent = strLang933 + (Number(arrRtnVal[1])) + strLang934_1 + "<br/>";

									if (arrRtnVal[2] != 0) {
										pAlertContent += strLang935 + arrRtnVal[2] + strLang934_1;
									}
									
									if (arrRtnVal[3] != 0) {
										if (arrRtnVal[2] != 0) {
											pAlertContent += " / ";
										}
									    
										pAlertContent += strLang936 + arrRtnVal[3] + strLang934_1;
									}
									
									if (arrRtnVal[4] != 0) {
										if (arrRtnVal[2] != 0 || arrRtnVal[3] != 0) {
											pAlertContent += " / ";
										}
									    
										pAlertContent += strLang938 + arrRtnVal[4] + strLang934_1;
									}
									  
									// 불필요한 분기 제거 (이미 receiptFlag == "R" 분기 내부임)
									pAlertContent += "<br/>" + strLangLGEAR01;
									
									/* 2024-11-18 홍승비 - 전자결재 G > 일괄접수 시에도 공람 기능이 정상 동작하도록 수정 (접수기안창 페이지 참고, 일반버전은 접수기안 시 회람 불가능) */
									if (arrRtnVal[5] != 0) {
										var gongramDocIDArr = arrRtnVal[5].split(";"); // 실제로 일괄접수가 성공한 문서의 docID 배열
										
										if (ret[22] == "noItem") {
											delAprLineInfoCC_receiptAll(gongramDocIDArr);
										} else if (ret[22] == "sameItem") {
										} else {
											SaveAprLineInfoCC_receiptAll(ret[22], gongramDocIDArr);
										}
									}
									
			     		        } else {
			     		        	if (receiptFlag == "R") {
			     			            pAlertContent = strLangLGEAR02;
			     		        	} else {
			     			            pAlertContent = strLangLGEAR04;
			     		        	}
			     		        }
			     		        
	     		        		// 2023-08-22 조수빈 - 작업을 완료한 후에는 부서수신함을 리로딩
								if (window.opener && window.opener.pListTypeValue) {
									if (window.opener.pListTypeValue == "97") {
										window.opener.parent.frames[0].convMain('97', '');
									} else {
										window.opener.parent.frames[0].convMain('4', '');
									}
								}

								OpenAlertUI(pAlertContent, window.close);
		     		            
		                	}, 0);
		                }
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
		            showAlert(alertMsg);            
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
		            showAlert("<spring:message code='ezApprovalG.t784'/>");
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
		                showAlert("<spring:message code='ezApprovalG.t10028'/>");
		                return;
		            }
		            var rtn = NewVolume(trim(GetAttribute(selnode, "DATA1")), trim(GetAttribute(selnode, "DATA3")));
		        }
		        else {
		            showAlert("<spring:message code='ezApprovalG.t478'/>");
		        }
		    }
		    function Docinfo_ini() {
		        SummaryFlag = false;
		        var rtnVal = new Array();
		        initdatepicker();
		        // document.getElementById("taSummery").value = "";

		        if (vSecurity.trim() == "" || vSecurity.trim() == "999")
		            document.getElementById("selSecLevel").options[0].selected = true;
		        else
		            document.getElementById("selSecLevel").value = vSecurity;
		        
		        if (vAprUrgency.trim() == "Y")
		            document.getElementById("AprUrgency").checked = true;
		        else
		            document.getElementById("AprUrgency").checked = false;
		        // if (vSummery.trim() != "") document.getElementById("taSummery").value = vSummery;

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
		            document.getElementById("idDatepicker").disabled = "";
		            $("#idDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#idDatepicker").datepicker('setDate', new Date(vAprSecurity));
		        }
		        else {
		            document.getElementById("AprSecurity").checked = false;
		            AprSecurity_onClick();
		        }
		        
		        // basis, reason, listOpenFlag, fileOpenFlagList;
	            
		        if (limitDate != "") {
		        	document.getElementById("openGovLimitDate").checked = true;
		        	document.getElementById("idDatepickerForOpenGov").disabled = "";
		        	$("#idDatepickerForOpenGov").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#idDatepickerForOpenGov").datepicker('setDate', new Date(limitDate));
		        }
		        
		        if (listOpenFlag != "") {
		        	if (listOpenFlag == "Y") {
			        	document.getElementById("openListFlag").checked = true;
			        	$("#basis").hide();
			        	$("#txt_Basis").val("");
		        	} else {
			        	document.getElementById("openListFlag").checked = false;
			        	$("#txt_Basis").val(basis);
		        	}
		        } else {
		        	document.getElementById("openListFlag").checked = true;
		        	$("#basis").hide();
		        }
		        
		        if (vPublicFlag != "") {
		        	if (vPublicFlag == "1") {
			        	$("#txt_Reason").val("");
		        	} else {
		        		$("#txt_Reason").attr("disabled", false);		        		
			        	$("#txt_Reason").val(reason);
		        	}
		        }

		        document.getElementById("txtLimitRange").value = vtreatment;
		        document.getElementById("txtPageNum").value = vPageNum;
		        rtnVal[0] = document.getElementById("selSecLevel").value;
		        if (document.getElementById("AprUrgency").checked)
		            rtnVal[1] = "Y";
		        else
		            rtnVal[1] = "N";

		        // rtnVal[2] = document.getElementById("taSummery").value;
		        rtnVal[3] = getdocdisplay();
		        rtnVal[4] = getPublicFlag();

		        rtnVal[5] = document.getElementById("txtLimitRange").value;
		        rtnVal[6] = document.getElementById("txtPageNum").value;
		        document.querySelector("input[name=keyword]").value = pkeyword ? pkeyword : '';
		        
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
						// document.getElementById("taSummery").value = vSummery;
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
		            showAlert("<spring:message code='ezApprovalG.t10501'/>");
		            return;
		        }
		
		        // if (CurSelRow[0].getAttribute("DATA6") != "" && useReceiveInfoName != '1') {
		        //    showAlert("<spring:message code='ezApprovalG.t10500'/>");
		        //    return;
		        // }
		
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
	            	var paramDocID = pDocID;
	            	var pMode = "";
	            	
	           	 /* 2021-04-19 홍승비 - 수신부서에서 회송된 문서의 경우, 원문서(완료문서)의 회람문서 정보를 가져오도록 수정 */
	                if (typeof(isSusinReset) != "undefined" && isSusinReset == true) {
	                	paramDocID = getOrgDocID();
	                }
	            	
	            	$.ajax({
	            		type : "POST",
	            		dataType : "text",
	            		async : false,
	            		url : "/ezApprovalG/gongRamDocInfo.do",
	            		data : {
	            			docID : paramDocID,
	            			orgCompanyID : orgCompanyID
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
	                showAlert("getGongRamDocInfo :: " + e.description);
	            }
	        }
	        
		    function ChangeReceptTabCC(divName) {
		        try {
		            if (divName == "Organ") {
		                document.getElementById("Organ").style.display = "";
		                document.getElementById("ReceptTempCC").style.display = "none";
						if (approvalFlag == "G") {
							document.getElementById("ArrBtnCC").style.visibility = "";
						}
		            } else if (divName == "Save") {
		                document.getElementById("Organ").style.display = "none";
		                document.getElementById("ReceptTempCC").style.display = "";
						if (approvalFlag == "G") {
							document.getElementById("ArrBtnCC").style.visibility = "hidden";
						}
		                GetReceptTempletListCC();
		            }
		        } catch (e) {
		            showAlert("AprGongRamLine_Cross_ChangeReceptTab::" + e.description);
		        }
		    }

			function viewDocInfoAndFocusNode(focusTarget) {
				document.getElementById("1tab6").onclick();

				focusTarget.focus();
			}

		    /*
			 * 비전자 기록물 정보 유효성 검사		    
		     */
		    function CheckInputField() {
		        var pRegType = selRegisterType.value;
				if (txtTitle.value.trim() == "") {
		            showAlert("기록물 제목을 입력해 주세요.");
					viewDocInfoAndFocusNode(txtTitle);

		            return false;
		        }
		        
		        if (regDate.value.trim() == "" || regTime.value.trim() == "") {
		            showAlert("<spring:message code='ezApprovalG.t1045'/>");
		            return false;
		        }
		             
				if (txtDrafter.value.trim() == "") {
		            showAlert("<spring:message code='ezApprovalG.jje01'/>");
					viewDocInfoAndFocusNode(txtDrafter);

		            return false;
		        }
				if (txtReceiptMember.value.trim() == "") {
	                showAlert("발신기관명을 입력해 주세요.");
					viewDocInfoAndFocusNode(txtReceiptMember);

	                return false;
	            }
				
				if (pRegType == "1" || pRegType == "3") {
					if (txtAprMemberTitle.value.trim() == "") {
		                showAlert("<spring:message code='ezApprovalG.t1054'/>");
						viewDocInfoAndFocusNode(txtAprMemberTitle);

		                return false;
		            }
				}
				if (pRegType == "5" || pRegType == "6") {
					if (txtSummary.value.trim() == "") {
		                showAlert("<spring:message code='ezApprovalG.t1058'/>");
						viewDocInfoAndFocusNode(txtSummary);

		                return false;
		            }
		            if (GetAVTypeCode() == "") {
		                showAlert("<spring:message code='ezApprovalG.t1059'/>");

		                return false;
		            }
				}
				if (pRegType == "2" || pRegType == "4" || pRegType == "7" || pRegType == "8") {
					if (txtOriginSN.value.trim() == "") {
		                showAlert("문서번호를 입력해 주세요.");
						viewDocInfoAndFocusNode(txtOriginSN);

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
		            //showAlert("기록물철을 먼저 선택하여주십시오.");
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

		    function showTooltip_MouseOver(obj, e) {
		        var tTip = document.getElementById('tooltip');
		        var tTable = document.createElement("TABLE");
		        var tTr = document.createElement("TR");
		        var tTh = document.createElement("TH");
		        
		        tTip.innerHTML = "";
		        tTable.className = "calendar_layer";
		        tTable.setAttribute("cellpadding", "0");
		        tTable.setAttribute("cellspacing", "0");
		        tTable.setAttribute("border", "0");
		        tTable.setAttribute("width", "100%");
		        tTh.setAttribute("scope", "col");
		        tTh.style.background = "#edf4fd";
		        tTh.style.border = "1px solid #d1ddec";
		        
		        setNodeText(tTh,obj.innerHTML);
		        tTr.appendChild(tTh);
		        tTable.appendChild(tTr);

		        var tTr = document.createElement("TR");
		        var tTd = document.createElement("TD");
		        
		        tTd.style.borderTop = "0px";
		        tTd.style.backgroundColor = "white";
		        tTd.className = "text";
		        
		        var sTable = document.createElement("TABLE");
		        var sTr = document.createElement("TR");
		        var sTd = document.createElement("TD");
		        
		        sTable.style.backgroundColor = "white";
		        sTable.className = "td_list";
		        sTable.setAttribute("cellpadding", "0");
		        sTable.setAttribute("cellspacing", "0");
		        sTable.setAttribute("border", "0");
		        sTable.setAttribute("width", "100%");
		        sTd.className = "individual";

		        var sSpan = document.createElement("SPAN");
		        sTd.appendChild(sSpan);
		        
		        var strHTML = "";

				switch ($(obj).prev().attr('id')) {
				case 'selSecLevel1':
					strHTML = "법률 또는 명령에 의하여 비밀로 유지되거나 비공개사항으로 규정된 항목";
					break;

				case 'selSecLevel2':
					strHTML = "공개될 경우 국가안보,국방,통일 외교관계 등 국익을 해할 우려가 있는 정보";
					break;
				case 'selSecLevel3':
					strHTML = "공개될 경우 국민의 생명,신체,재산 등 공공안전 및 이익을 해할 우려가 있는 정보";
					break;
				case 'selSecLevel4':
					strHTML = "수사,재판,범죄예방 등의 관련정보로서 공개될 경우 직무수행이 곤란하거나 형사피고인의 공정한 재판받을 권리를 침해할 우려가 있는 정보";
					break;
				case 'selSecLevel5':
					strHTML = "감사,감독,검사,시험,규제,입찰계약,기술개발,인사관리,의사결정 또는 내부검토과정에 있는 사항으로서 공개될 경우 업무수행 등에 지장을 초래할 우려가 있는 정보";
					break;
				case 'selSecLevel6':
					strHTML = "이름,주민등록번호 등에 의해 특정인을 식별할 수 있는 개인에 관한 정보";
					break;
				case 'selSecLevel7':
					strHTML = "법인,단체 또는 개인의 영업상 비밀에 관한 정보로서 공개될 경우 법인 등의 정당한 이익을 해할 우려가 있는 정보";
					break;
				case 'selSecLevel8':
					strHTML = "공개될 경우 부동산투기,매점매석 등으로 특정인에게 이익 보는 불이익을 줄 우려가 있는 정보";
					break;
				}
		        
		        sTd.innerHTML = "<b>" + strHTML + "</b>";
	            sTr.appendChild(sTd);
	            sTable.appendChild(sTr);
	            tTd.appendChild(sTable);
	            tTr.appendChild(tTd);
	            tTable.appendChild(tTr);
		            
		        tTip.appendChild(tTable);
		        tTip.style.left = getMouseXLocation(e) + 'px';
		        tTip.style.top = getMouseYLocation(e) + 'px';
		        tTip.style.visibility = 'visible';
		    }
		    
		    function getMouseXLocation(e) {
		        if (e)
		            var E = e;
		        else
		            var E = window.event;

		        if (E.clientX > 1000) {
		            var tTip = document.getElementById("tooltip");
		            var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
		        } else {
		        	var locationX = E.clientX + document.body.scrollLeft + 20;
		        }

		        return locationX
		    }
		    
		    function getMouseYLocation(e) {
		        if (e)
		            var E = e;
		        else
		            var E = window.event;

		        var tTip = document.getElementById("tooltip");
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            if (E.clientY > 500) {
		                var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
		            } else {
		                if (document.documentElement.scrollTop > 0) {
		                    //var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
		                    var locationY
		                    //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면 - 메디톡스 수정
		                    if (tTip.clientHeight > E.clientY) {
		                        locationY = E.clientY + document.documentElement.scrollTop;
		                    } else {
		                        locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
		                    }
		                } else {
		                    var locationY = E.clientY + document.documentElement.scrollTop;
		                }
		            }
		        } else {
		            if (E.clientY > 500) {
		                var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
		            } else {
		                if (document.body.scrollTop > 0) {
		                    var locationY
		                    //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면 - 메디톡스 수정
		                    if (tTip.clientHeight > E.clientY) {
		                        locationY = E.clientY + document.body.scrollTop;
		                    } else {
		                        locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
		                    }
		                } else {
		                    var locationY = E.clientY + document.body.scrollTop;
		                }
		            }
		        }

		        return locationY
		    }
		    
		    function hideTooltip() {
		        document.getElementById('tooltip').style.visibility = 'hidden';
		    }
		    
		    function getAttachList() {
		    	var url = "/ezApprovalG/getAttachListForOpenGov.do";
		    	if (draftAllFlag == "Y") {
		    		url = "/ezApprovalG/getAttachListForOpenGovDraftAll.do"
		    	}
		    	
            	$.ajax({
            		type : "POST",
            		dataType : "json",
            		async : false,
            		url : url,
            		data : {
            			docID : pDocID,
            			draftAllFlag : draftAllFlag, // 일괄기안 관련 변수
            			pDocIDAry : pDocIDAry
            		},
            		success: function(xml){
            			result = xml;
            			if (result.length > 0) {
           					var attachTr;
	            			$.each(result, function(index, item) {
	            				attachTr = "";
	            				
	            				// 일괄기안이 아닌 경우 (기존 코드)
	            				if (draftAllFlag != "Y") {
		            				if (item.fileOpenFlag == "Y") {
		            					attachTr = "<tr><td style='width:30px'><input onClick='fileOpenFlagChk_onClick(this)' class='fileOpenFlagChk' id='fileOpenFlagChk_" + item.sn + "' type='checkbox' checked /></td>"
			            				+ "<td style='width:30px'>" + item.sn + "</td><td style='width:350px'>" + item.fileName + "</td>"
			            				+ "<td style='width:70px'>" + item.fileSize + "</td>"
			            				+ "<td class='fileOpenFlag' id='fileOpenFlag_" + item.sn + "' style='width:60px'>" + "공개" + "</td></tr>";
		            				} else {
		            					attachTr = "<tr><td style='width:30px'><input onClick='fileOpenFlagChk_onClick(this)' class='fileOpenFlagChk' id='fileOpenFlagChk_" + item.sn + "' type='checkbox'/></td>"
			            				+ "<td style='width:30px'>" + item.sn + "</td><td style='width:350px'>" + item.fileName + "</td>"
			            				+ "<td style='width:70px'>" + item.fileSize + "</td>"
			            				+ "<td class='fileOpenFlag' id='fileOpenFlag_" + item.sn + "' style='width:60px'>" + "비공개" + "</td></tr>";
		            				}
	            				}
	            				// 일괄기안인 경우, 각 첨부파일 별 안번호를 표시
	            				else {
	            					if (item.fileOpenFlag == "Y") {
		            					attachTr = "<tr><td style='width:30px'><input onClick='fileOpenFlagChk_onClick(this)' anNo='" + pDocIDAry.indexOf(item.docID) + "' class='fileOpenFlagChk' id='fileOpenFlagChk_" + item.sn + "' type='checkbox' checked /></td>"
		            					+ "<td class='anNo' style='width:30px'>" + pDocIDAry.indexOf(item.docID) + "안</td>"
			            				+ "<td style='width:30px'>" + item.sn + "</td><td style='width:350px'>" + item.fileName + "</td>"
			            				+ "<td style='width:70px'>" + item.fileSize + "</td>"
			            				+ "<td class='fileOpenFlag' id='fileOpenFlag_" + item.sn + "' style='width:60px'>" + strLang82 + "</td></tr>";
		            				} else {
		            					attachTr = "<tr><td style='width:30px'><input onClick='fileOpenFlagChk_onClick(this)' anNo='" + pDocIDAry.indexOf(item.docID) + "' class='fileOpenFlagChk' id='fileOpenFlagChk_" + item.sn + "' type='checkbox'/></td>"
		            					+ "<td class='anNo' style='width:30px'>" + pDocIDAry.indexOf(item.docID) + "안</td>"
			            				+ "<td style='width:30px'>" + item.sn + "</td><td style='width:350px'>" + item.fileName + "</td>"
			            				+ "<td style='width:70px'>" + item.fileSize + "</td>"
			            				+ "<td class='fileOpenFlag' id='fileOpenFlag_" + item.sn + "' style='width:60px'>" + strLang84 + "</td></tr>";
		            				}
	            				}
	            				
	            				$("#attachList").append(attachTr);	
	            			});
	            			
	            			$("#attachList > tr").children("td").css({"border-bottom": "1px solid #e0e0e0", "overflow": "hidden", "text-overflow": "ellipsis", "white-space":"nowrap", "padding-left":"10px", "height":"10px"});
            			} else {
	            			$("#attachList").append("<td colspan='5' align='center'>데이터가 존재하지 않습니다.</td>")
            			}
            		}
            	});
		    }
		    
		    function fileOpenFlagChk_onClick(chk) {
		    	if (chk.checked == true) {
		    		chk.parentElement.parentElement.lastElementChild.textContent = "공개";
		    	} else {
		    		chk.parentElement.parentElement.lastElementChild.textContent = "비공개";
		    	}
		    }
		    
		    function openListFlag_onClick(chk) {
		    	if (chk.checked == true) {
		    		$("#basis").hide();
		    	} else {
		    		$("#basis").show();
		    	}
		    }
		    
		    function openGovLimitDate_onClick() {
		        if (document.getElementById("openGovLimitDate").checked) {
		            document.getElementById("idDatepickerForOpenGov").disabled = "";
		        } else {
		            document.getElementById("idDatepickerForOpenGov").disabled = "disabled";
		        }
		    }
		    
		    function passAprLine_onchange(chk) {
				if (chk.checked == true) {
					$("#APRLINE").empty();
					Lineinfoini = false;
					Lineinfo_ini();
					$('tr[data12="004"] select,[data12="003"]  select').attr("disabled","disabled");
				} else {
					$('tr[data12="004"] select,[data12="003"]  select').attr("disabled", false);
				}
			}
	    	function showPassAprLineBtn() {
		    	if (pReDraftFlag != "REDRAFT") {
					$("#passAprLineSpan").hide();
					return;
				}
				
		    	// 2020-08-03 기준 반송, 회송 시 모두 기결재통과기능 사용가능
		    	// 반송 시에는 기결재 통과를 막는다고 고객과 협의 2019-11-15 임민석
				if(parent.pAprState !== '004') {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/isPassAprLineShow.do",
						data : {
							docID : pDocID,
							formID : pFormID
						},
						success: function(xml) {
							if (xml == "Y") {
								$("#passAprLineSpan").show();
								document.getElementById('passAprLine').checked = true;
							} else {
								$("#passAprLineSpan").hide();
							}
						}
					});
				}
				
				if (passAprLine == "Y") {
					$("#passAprLine").prop("checked", true);
				}
			}
	    	
	    	// 2020-11-23 공개등급 tooltip 추가 - 박기범
	    	function giveTooltipLevel() {
	    		if (tooltipLevelFlag != "Y"){
	    			return;
	    		}
	    		// 일반버전에서 스크립트 오류 발생하지 않도록 수정
	    		if (document.querySelector('input[name=selSecLevel1]') != null) {
		    		document.querySelector('input[name=selSecLevel1]').nextSibling.setAttribute('title','법률 또는 명령에 의하여 비밀로 유지되거나 비공개사항으로 규정된 항목'														);
		    		document.querySelector('input[name=selSecLevel2]').nextSibling.setAttribute('title','공개될 경우 국가안보,국방,통일 외교관계 등 국익을 해할 우려가 있는 정보'													);
		    		document.querySelector('input[name=selSecLevel3]').nextSibling.setAttribute('title','공개될 경우 국민의 생명,신체,재산 등 공공안전 및 이익을 해할 우려가 있는 정보'													);
		    		document.querySelector('input[name=selSecLevel4]').nextSibling.setAttribute('title','수사,재판,범죄예방 등의 관련정보로서 공개될 경우 직무수행이 곤란하거나 형사피고인의 공정한 재판받을 권리를 침해할 우려가 있는 정보'					);
		    		document.querySelector('input[name=selSecLevel5]').nextSibling.setAttribute('title','감사,감독,검사,시험,규제,입찰계약,기술개발,인사관리,의사결정 또는 내부검토과정에\n있는 사항으로서 공개될 경우 업무수행 등에 지장을 초래할 우려가 있는 정보'	);
		    		document.querySelector('input[name=selSecLevel6]').nextSibling.setAttribute('title','이름,주민등록번호 등에 의해 특정인을 식별할 수 있는 개인에 관한 정보'														);
		    		document.querySelector('input[name=selSecLevel7]').nextSibling.setAttribute('title','법인,단체 또는 개인의 영업상 비밀에 관한 정보로서 공개될 경우 법인 등의 정당한 이익을 해할 우려가 있는 정보'								);
		    		document.querySelector('input[name=selSecLevel8]').nextSibling.setAttribute('title','공개될 경우 부동산투기,매점매석 등으로 특정인에게 이익 보는 불이익을 줄 우려가 있는 정보'											);
	    		}
	    	}

		    
	        function GetGamsaYesanDeptInfo() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();

	            xmlhttp.open("POST", "/ezApprovalG/getGamsaYesanDeptInfo.do", false);
	            xmlhttp.send(xmlpara);

	            GamsaYesanInfoXML = loadXMLString(xmlhttp.responseText);

	        }
	        
	        function ShowMailProgress() {
	    		var CurrenWidth = document.documentElement.clientWidth;
	    		
	            document.getElementById("mailPanel").style.display = "";
	            document.getElementById("loadingProgress").style.top = "600px";
	            document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
	            document.getElementById("loadingProgress").style.display = "";
		    }
	    	
		    function HiddenMailProgress() {
		    	document.getElementById("mailPanel").style.display = "none";
	        	document.getElementById("loadingProgress").style.display = "none";
		    }

			function btnfileup() {
				if (!isfileup) {
					document.getElementById("file").click();
				}
			}

			function filechange(e) {
				onDrop();
			}

			function onDrop(evt) {
				if (evt != undefined) {
					evt.stopPropagation();
					evt.preventDefault();
				}

				if (evt == undefined) {
					filelist = document.getElementById("file").files;
				} else {
					filelist = evt.dataTransfer.files;
				}

				if(filelist.length > 1) {
					showAlert("<spring:message code='ezOrgan.x0001'/>");
					return;
				}

				for (var i = 0; i < filelist.length; i++) {
					//파일명체크
					var tmpFileName = ReplaceHTML(filelist[i].name);

					if (tmpFileName.indexOf(">") > -1 || tmpFileName.indexOf("<") > -1 || tmpFileName.indexOf("\"") > -1 ||
							tmpFileName.indexOf("/") > -1 || tmpFileName.indexOf("\\") > -1 || tmpFileName.indexOf(":") > -1 ||
							tmpFileName.indexOf("*") > -1 || tmpFileName.indexOf("|") > -1 || tmpFileName.indexOf("?") > -1) {
						showAlert("<spring:message code='ezApproval.t936'/>");
						return;
					}

					var FileFilter = /\.(doc|docx|ppt|pptx|xls|xlsx|pdf|jpg|jpeg|png|gif|bmp|txt|text|html|htm|hwp)$/i;

					if (!tmpFileName.match(FileFilter)) {
						showAlert("<spring:message code='ezApproval.t937'/>");
						return;
					}
				}

				document.getElementById("filename").value = tmpFileName;	
				fileupload();
			}

			function fileupload() {

				isfileup = true;

				var formData = new FormData();
				formData.append("fileToUpload", filelist[0]);
				formData.append("docId", opener.pDocID);
				formData.append("tenantId", opener.pTenantID);
				formData.append("companyId", opener.pCompanyID);
				formData.append("userId", opener.pUserID);

				$("#loading").css("display", "");

				$.ajax({
					type : "post",
					data : formData,
					url : "/ezApprovalG/officeUpload.do",
					processData: false,
					contentType: false,
					success : function(result) {
						$("#mailPanel", parent.document).css("display", "none");
						$("#layerpopup", parent.document).css("display", "none");
						convertedImgInfo = result;
					},
					error : function() {
						showAlert("<spring:message code='ezApprovalG.nonElecAt01'/>");
					},
					complete : function() {
						$("#loading").css("display", "none");
						isfileup = false;
					}
				});
			}

			function setConvertedImg(convertedImgInfo) {
				var divLength = parent.opener.document.getElementById("message").contentWindow.document.getElementById("body").getElementsByClassName("divImg").length;
				
				if (divLength > 0) {
					opener.document.getElementById("message").contentWindow.document.getElementById("body").remove();
				}
				var iTd = document.createElement('td');
				iTd.setAttribute("class", "FIELD");
				iTd.setAttribute("id", "body");
				iTd.setAttribute("receiptnumber", "@dp-@nn");
				iTd.vAlign = "top";
				iTd.style.borderImage = "none 100% / 1 / 0 stretch";
				iTd.style.width = "523px";
				iTd.style.height = "150px";
				iTd.style.fontSize= "14px";
				
				var div = document.createElement('div');
				$(div).addClass("divImg");
				$(div).css("overflow", "auto");
				iTd.appendChild(div);
				
				if (divLength == 0){
					opener.document.getElementById("message").contentWindow.document.getElementById("info").style.display = "none";
					opener.document.getElementById("message").contentWindow.document.getElementById("body").id = "docNotebody";
					
				}
				
				opener.document.getElementById("message").contentWindow.document.getElementById("area").appendChild(iTd);

				var imgURL = convertedImgInfo;
				
				var pagesIndexOf = imgURL.indexOf("pages");
				var pagesURL = imgURL.substr(pagesIndexOf);
				var pagesIndexOf2 = pagesURL.indexOf("&");
				var pagesURL2 = pagesURL.substr(0, pagesIndexOf2);
				var pagesIndexOf3 = pagesURL2.indexOf("=")+1;
				var pages = pagesURL2.substr(pagesIndexOf3);

				var fileIndexOf = imgURL.indexOf("filename");
				var fileURL = imgURL.substr(fileIndexOf);
				var fileIndexOf2 = fileURL.indexOf(".png");

				var imgURLF = imgURL.substr(0, fileIndexOf);
				var imgURLL = fileURL.substr(fileIndexOf2);
				
				for(var i = 1; i <= pages; i++) {
					var imgSrc = document.createElement('img');
					var fileNm;

					if (i < 10) {
						fileNm = "filename=0000" + i;
					} else if (i < 100) {
						fileNm = "filename=000" + i;
					} else {
						fileNm = "filename=00" + i;
					}

					imgSrc.src = imgURLF + fileNm + imgURLL;
					imgSrc.style.width = "654px";
					imgSrc.style.border = "1px solid rgb(200, 200, 200)";
					imgSrc.style.boxSizing = "border-box";
					$(imgSrc).addClass("office-image");
					$(imgSrc).css("position", "relative");
					$(imgSrc).attr("z-index", 100);


					imgDiv = document.createElement('div');
					$(imgDiv).css("overflow", "auto");
					$(imgDiv).css("text-align", "center");
					$(imgDiv).addClass("imgDiv");
					
					imgDiv.appendChild(imgSrc);
					div.appendChild(imgDiv);
				}
				
			}

			function btn_Close2() {
				window.close();
			}
			
			innerIfrmaeOffset();
			window.addEventListener("resize", function() {
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					document.getElementById("tblwrap").style.height = (document.documentElement.clientHeight - 143) + 'px';
					document.getElementById("tblwrap").style.overflowY = 'auto';
	        	}
			})
			
			window.addEventListener("message", function (event) {
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					if (event.data && event.data.type == "height") {
						var innerIframe = window.parent.document.querySelector("iframe#iFrameLayer");
						var innerIframe2 = window.parent.document.querySelector(".layerpopup_top");
						var innerFrameHeight = event.data.value * 0.95;
						innerIframe.style.height = innerFrameHeight + "px";
						innerIframe2.style.height = innerFrameHeight + "px";
					}
				}
			});
	    </script>
	    <style>
	    	/* .mainlist_free tr th {text-align:center} */
	    	/* .mainlist_free tr td {text-align:center} */
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
		<div>
	    	<h1 id="h1_header"><spring:message code='ezApprovalG.t1742'/></h1>
	        <div id="btnArea" style="display:none;float:right;">
	            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>
	            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_Close()"><spring:message code='ezApprovalG.t1761'/></span></a>
	        </div>	        
		</div>
	    <div id="close">
            <ul>
                <li><span onclick="btn_Close()"></span></li>
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
		            <p id="showHRAprLine"<c:if test="${draftAllFlag eq 'Y'}"> style="display:none"</c:if>><span divname="Circulation" id="1tab5"><spring:message code='ezApprovalG.hyj06'/></span></p>
	            </c:if>
	            <c:if test="${approvalFlag eq 'G' and draftAllFlag ne 'Y'}">
		            <p id="showHRAprLine"><span divname="Circulation" id="1tab5"><spring:message code='ezApprovalG.LJEAppr06'/></span></p>
	            </c:if>
				<c:if test="${approvalFlag eq 'G'}">
					<p id="showNonElecRecInfo" style="display: none;"><span divname="NonElecRecInfo" id="1tab6">기록물정보</span></p>
				</c:if>
	        </div>
	    </div>
	    <div id="tblwrap">
	    <div id="Approvallist">
	        <!-- 결재선 -->
	        <div id="Lineinfo" style="width: 100%;">
	            <table>
	                <tr>
	                    <td style="vertical-align: top">
	                        <div class="portlet_tabpart01" style="margin-top: 3px;">
	                            <div class="portlet_tabpart01_top" id="tab2">
	                                <p><span divname="Organ" id="2tab1"><spring:message code='ezApprovalG.t232'/></span></p>
	                                <p><span divname="Temp" id="2tab2"><spring:message code='ezApprovalG.G0001'/></span></p>
	                            </div>
	                        </div>
	                        <div id="OrganLineTab" style="width:440px">
	                            <table style="width:99.5%;table-layout: fixed">
	                            <c:if test="${approvalFlag == 'G'}">
									 <tr>
	                                    <td style="vertical-align: top;">	                                    	
	                                        <span>	                                        	
	                                            <div id="TreeView" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 247px; width: 437px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 1px;"></div>
	                                            <div class="border_gray" style="Width: 438px; Height: 273px;">
	                                                <div id="UserList" style="margin: 0px 1px 1px 1px; Width: 436px; Height: 100%; overflow: auto;"></div>
	                                                <div id="auditUserList" divname="listView" style="display:none;"></div>
	                                            </div>
	                                        </span>
	                                    </td>
	                                </tr>
	                            </c:if>
	                            <c:if test="${approvalFlag =='S'}">
	                               <tr>
                                    <td style="vertical-align: top;">                                    	
                                        <div id="TreeView" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 436px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
                                        </div>
                                    </td>
                               	 	</tr>
                                	<tr>
                                    <td style="border: 1px solid #ddd;">
                                        <div class="border_gray" style="border: 0px;">
                                            <div id="UserList" style="border: 0px; margin: 0px 1px 1px 1px; Width: 436px; Height: 223px; overflow: auto;">
                                            <div id="auditUserList" divname="listView" style="display:none;"></div>
                                            </div>
                                        </div>
                                    </td>
                                	</tr>
                                </c:if>
	                                <tr>
	                                <c:if test="${approvalFlag == 'S'}">
	                                    <td style="background-color: transparent; height: 28px; padding-top: 10px; vertical-align: top;">
	                                    <input id="textUser" style="width: 145px;height:22px" name="textUser" onkeypress="return textUser_onkeypress(event)"  maxlength="50">
											<a class="imgbtn imgbck2"><span name="btn_searchUser" id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
											<a class="imgbtn imgbck2"><span onclick="return btnAprLineSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                        <a class="imgbtn imgbck2" onclick="APRDEPTADD();" id="deptaddbtn"><span><spring:message code='ezApprovalG.G0002'/></span></a>
	                                    </td>
	                                </c:if>
	                                <c:if test="${approvalFlag == 'G'}">
	                                    <td style="background-color: transparent; height: 38px; padding-right: 5px;margin-top: auto;margin-bottom: auto;" >
	                                    	<input id="textUser" style="width: 145px;height:22px" name="textUser" onkeypress="return textUser_onkeypress(event)"  maxlength="50">
											<a class="imgbtn imgbck2" style="vertical-align: middle; margin: auto;"><span name="btn_searchUser" id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
											<a class="imgbtn imgbck2" style="vertical-align: middle; margin: auto;"><span onclick="return btnAprLineSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                    	<a class="imgbtn imgbck2" style="vertical-align: middle; margin: auto;" onclick="APRDEPTADD();" id="deptaddbtn"><span><spring:message code='ezApprovalG.G0002'/></span></a>
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
	                                        <div class="border_gray">
	                                            <div id="APRTEMPLIST" style="border: 0px; Width: 436px; Height: 182px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                            </div>
	                                        </div>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="background-color: transparent; text-align: center; height: 30px;">
	                                        <table class="content" style="margin-bottom: 5px; width: 100%;">
	                                            <tr>
	                                                <td style="vertical-align: middle; text-align: center; padding-top: 3px;">
	                                                    <a class="imgbtn imgbck2"><span id="btn_DelAprLineTemplet" onclick="return btn_DelAprLineTemplet_onclick()"><spring:message code='ezApprovalG.G0004'/></span></a>
	                                                    <a class="imgbtn imgbck2"><span id="Span1" onclick="return btn_ModifyToAprLine_onclick()"><spring:message code='ezApprovalG.G0005'/></span></a>
	                                                    <a class="imgbtn imgbck2"><span onclick="return btn_AddToAprLine_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </td>
	                                </tr>
	                                <tr>
	                                    <td style="vertical-align: top;">
	                                        <c:if test="${approvalFlag == 'G' }">
	                                        <div class="border_gray">
	                                            <div id="APRTEMP" style="Width: 436px; Height: 266px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                            </div>
	                                        </c:if>
	                                        <c:if test="${approvalFlag == 'S' }">
	                                        <div class="border_gray">
	                                            <div id="APRTEMP" style="Width: 436px; Height: 260px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                            	</div>
                                            </c:if>
	                                        </div>
	                                    </td>
	                                </tr>
	                            </table>
	                        </div>
	                    </td>
	                    <!-- 2024-06-19 이주원 화살표ui 추가 -->
	                    <td style="width: 16px; text-align: center; padding-left: 4px;" >
                            <!-- <div style="display: inline-block; margin:auto; padding-left:2.5px;" id="AddRemoveBTN"> -->
                            <div style="display: inline-block; margin:auto;" id="AddRemoveBTN2">
                                <img src="/images/kr/cm/arr_right.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsert" onclick="return list2_onSel_DBclick();">
                                <br>
                                <img src="/images/kr/cm/arr_left.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDelete" onclick="return AprlineDel_onclick();">
                                <br>
                            </div>
                        </td>
	                    <td style="vertical-align: top;">
	                    <c:if test="${approvalFlag == 'G' }">
	                        <table style="margin-left: 5px;">
	                    </c:if>
	                    <c:if test="${approvalFlag == 'S' }">
	                        <table>
	                    </c:if>
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <h2 class="h2_dot" style="margin-top:6px;"><spring:message code='ezApprovalG.t407'/>
	                                        <div style="text-align: right; margin-top: -23px;">
	                                        	<%-- <c:if test="${approvalFlag == 'G' }">
		                                        	<a id="auditAddBtn" class="imgbtn">
														<span><spring:message code='ezOrgan.t9903'/></span>
													</a>
												</c:if> --%>
	                                            <a class="imgbtn" onclick="AprlineUpper_onclick();" style="height:22px;box-shadow:0px 2px 0px 0px rgba(0,0,0,0.1)"><span>
	                                                <img src="/images/ImgIcon/prev.gif" alt="<spring:message code='ezApprovalG.pjj28'/>" style="margin-top: 4px;"/></span></a>
	                                            <a class="imgbtn" onclick="AprlineDown_onclick();" style="height:22px;box-shadow:0px 2px 0px 0px rgba(0,0,0,0.1)"><span>
	                                                <img src="/images/ImgIcon/next.gif" alt="<spring:message code='ezApprovalG.pjj29'/>" style="margin-top: 4px;"/></span></a>
	                                        </div>
	                                    </h2>
	                                  
	                                        <c:if test="${approvalFlag == 'G' }">
		                                        <div class="border_gray" style="margin-top:7px">
		                                        <div id="APRLINE" style="Width: 723px; Height: 486px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: auto; padding-top: 0px;">
		                                        </div>
		                                        </div>
	                                        </c:if>
	                                        <c:if test="${approvalFlag == 'S' }">
		                                        <div class="border_gray" style="margin-top:7px; margin-left:4px;">
		                                        <div id="APRLINE" style="Width: 717px; Height: 515px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        	</div>
	                                        	</div>
                                        	</c:if>
	                                </td>
	                            </tr>
	                            <tr id="td_check_rep_sugg" class="approvalG">
	                                <td>
	                                    <div>
	                                        <table class="content" style="margin-top: 6px; width: 100%;">
	                                            <tr>
	                                                <td colspan="2" style="margin-top: 3px; text-align: center; background-color: #f8f8fa">
	                                                    <input type="checkbox" name="Reporter" id="Reporter" value="checkbox" onclick="return Reporter_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top; margin: 3px 2px 0 0;">
	                                                    <span style="display: inline-block; margin-top: 4px;"><spring:message code='ezApprovalG.t409'/></span>
	                                                    <input type="checkbox" id="Suggester" name="Suggester" value="checkbox" onclick="return Suggester_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top; margin: 3px 2px 0 0;">
	                                                    <span style="display: inline-block; margin-top: 4px;"><spring:message code='ezApprovalG.t410'/></span>
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
	                            <tr style="display:none;" id="tr_radio_audit">
	                                <td>
	                                    <div>
	                                        <table class="content" style="margin-top: 6px; width: 100%;">
	                                            <tr>
	                                            	<td id="td_radio_audit" colspan="2" style="text-align:center; background-color: #f8f8fa">
	                                                    <input type="radio" name="auditApprLine" value="AD0001"><span><spring:message code='ezAdmin.auditApprLine.02'/></span>&nbsp;&nbsp;
	                                                    <input type="radio" name="auditApprLine" value="AD0002"><span><spring:message code='ezAdmin.auditApprLine.03'/></span>&nbsp;&nbsp;
	                                                    <input type="radio" name="auditApprLine" value="AD0003"><span><spring:message code='ezAdmin.auditApprLine.04'/></span>&nbsp;&nbsp;
	                                                </td>
	                                            </tr>
	                                        </table>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                            	<c:if test ="${approvalFlag =='G'}">
	                                <td style="text-align: right;">
	                                	<span id="passAprLineSpan" style="float:left;display:none"><input id="passAprLine" type="checkbox" style="vertical-align: middle" onchange="passAprLine_onchange(this)"><span style="vertical-align: middle"> <spring:message code='ezApprovalG.garm09'/></span></span>
	                                	<a id="btnAddGamsaDept" style="margin-top: 8px; display: none;" class="imgbtn imgbck">
	                                		<span onclick="return btnAddEtcDept_onclick('013')">감사추가</span>
	                                	</a>
	                                    <a style="margin-top: 8px !important;" class="imgbtn imgbck">
	                                 </c:if>
	                                 <c:if test = "${approvalFlag=='S'}">
	                                 <td style="padding-top: 10px; text-align: right; vertical-align: top;" id="SaveAprLineTemplet">
	                                 	<span id="passAprLineSpan" style="float:left;display:none"><input id="passAprLine" type="checkbox" style="vertical-align: middle" onchange="passAprLine_onchange(this)"><span style="vertical-align: middle"> <spring:message code='ezApprovalG.garm09'/></span></span>
	                                 <a class="imgbtn imgbck2">
	                                 </c:if>
	                                 	<span id="btn_SaveAprLineTemplet" onclick="return btn_SaveAprLineTemplet_onclick()"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t384'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t270'/></c:if></span>
	                                 </a>
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
		                        			<c:if test="${docType eq '001' && isOuterForm}">
					                            <p><span id="3tab4" divname="Outer" class ="approvalG"><spring:message code='ezApprovalG.t330'/></span></p>
		                        			</c:if>
		                        			<c:if test="${docType ne '001' || (docType eq '001' && not isOuterForm)}">
					                            <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
		                        			</c:if>
											<c:if test="${useDoc24 eq 'YES'}">
											<p><span id="3tab5" divname="Doc24" class ="approvalG">문서24</span></p>
											</c:if>
											<p><span id="3tab2" divname="Save"><spring:message code='ezApprovalG.G0001'/></span></p>
											<p><span id="3tab3" divname="Group"><spring:message code='ezApprovalG.t1568'/></span></p>
		                        		</c:when>
		                        		<c:otherwise>
				                            <p><span id="3tab1" divname="Organ"><spring:message code='ezApprovalG.t232'/></span></p>
				                            <p><span id="3tab4" style="display: none;" divname="Outer" class ="approvalG"><spring:message code='ezApprovalG.t330'/></span></p>
				                            <c:if test="${useDoc24 eq 'YES'}">
					                        <p><span id="3tab5" divname="Doc24" class ="approvalG">문서24</span></p>
					                        </c:if>
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
<!-- 	                                	 정주환 G 버전에서 개인 수신자 설정 기능 추가 -->
<!-- 		                                    <div id="TreeView2" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 517px; width: 388px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;"> -->
                                        	<div id="TreeView2" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 436px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
		                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
                                    <td>
                                        <div class="border_gray" style="margin-right: 1px;">
                                            <div id="UserList2" style="border: 0px; margin: 0px 1px 1px 1px; Width: 436px; Height: 223px; overflow: auto;">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
	                            <tr>
	                                <td height="36px;" style="background-color: transparent; padding-top: 10px;vertical-align: top">
	                                 	<input id="textUser2" style="width: 111px;height:22px" name="textUser" onkeypress="return textUser_onkeypress2()" maxlength="50">
                                        <a class="imgbtn imgbck2"><span name="btn_searchUser" id="Span2" onkeypress="return btn_searchUser_onclick2()" onclick="return btn_searchUser_onclick2()"><spring:message code='ezApproval.t175'/></span></a>
                                        <a class="imgbtn imgbck2" style="vertical-align: middle; margin: auto; <c:if test="${isOuterForm}">display: none;</c:if>"><span onclick="return btnReceiptSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                	<a class="imgbtn imgbck2" id="AprDeptAdd"  onclick="AprDeptAdd_onclick('DEPT');"><span><spring:message code='ezApproval.t1101'/></span></a>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	
	                    <div id="ReceptOuter" style="display: none;">
	                        <table style="margin-left: 0px;">
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div id="TreeView3" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 517px; width: 436px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; height: 36px; padding-top: 10px; vertical-align: top;">
	                                    <input id="txtOuterDeptName" style="width: 150px;height:22px;" name="textUser2" onkeyup="return btnSearchDept_onKeyPress2(event)"  maxlength="50">
	                                    <a class="imgbtn imgbck2"><span id="Span7" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                    <a class="imgbtn imgbck2" id="AprDeptOuterAdd" onclick="AprDeptOuterAdd_onclick();"><span><spring:message code='ezApprovalG.t1236'/></span></a>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	
	                    <div id="ReceptDoc24" style="display: none;">
	                        <table style="margin-left: 0px;">
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div id="TreeView4" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 517px; width: 436px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; height: 36px; padding-top: 10px; vertical-align: top;">
	                                    <input id="txtDoc24Name" style="width: 150px;height:22px;" name="textUser2" onkeyup="return btnSearchDoc24_onKeyPress(event)"  maxlength="50">
	                                    <a class="imgbtn imgbck2"><span id="Span8" onkeyup="return btnSearchDoc24_onClick()" onclick="return btnSearchDoc24_onClick()" ><spring:message code='ezApprovalG.t250'/></span></a>
	                                    <a class="imgbtn imgbck2" id="doc24Detail" onclick="doc24Detail_onclick();"><span>상세보기</span></a>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	
	                    <div id="ReceptTemp" style="display: none;margin-right: 1px;">
	                        <table>
	                            <tr>
	                                <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                    <h2 class="h2_dot" style="padding-top:2px;"><spring:message code='ezApprovalG.G0003'/></h2>
	                                    <div class="border_gray">
	                                        <div id="RecSaveList" style="border: 0px; Width: 436px; Height: 182px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; text-align: center; height: 30px;">
	                                    <table class="content" style="margin-bottom: 5px; width: 100%;">
	                                        <tr>
	                                            <td style="text-align: center; padding-top: 3px">
	                                                <a class="imgbtn imgbck2"><span id="Span3" onclick="return btn_AprDeptTempletDel_onclick()"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t252'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t219'/></c:if></span></a>
	                                                <a class="imgbtn imgbck2"><span id="Span4" onclick="return btn_AprDeptTempletSave_onclick('MODIFY')"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.kje01'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApprovalG.G0006'/></c:if></span></a>
	                                                <a class="imgbtn imgbck2"><span onclick="return btn_AprDeptTempletAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div class="border_gray">
	                                        <div id="RecSaveDetail" style="Width: 436px; Height: 262px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	                    <div id="ReceptGroup" style="display: none;margin-right: 1px;">
	                        <table>
	                            <tr>
	                                <td style="background-color: #f8f8f8; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
	                                    <h2 class="h2_dot" style="padding-top:2px;"><spring:message code='ezApprovalG.G0007'/></h2>
	                                    <div class="border_gray">
	                                        <div id="RecGroupList" style="border: 0px; Width: 436px; Height: 182px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="background-color: transparent; text-align: center; height: 30px;">
	                                    <table class="content" style="margin-bottom: 5px; width: 100%">
	                                        <tr>
	                                            <td style="text-align: center; padding-top: 3px">
	                                                <%-- <a class="imgbtn imgbck2"><span onclick="return btn_GroupReceptAdd_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.G0008'/></span></a> --%>
                                                    <a class="imgbtn imgbck2"><span onclick="return btn_GroupReceptAdd_onclick('each')" style="width: 80px;"><spring:message code='ezApprovalG.t336'/></span></a>
                                                    <a class="imgbtn imgbck2"><span onclick="return btn_GroupReceptAdd_onclick('group')" style="width: 80px;"><spring:message code='ezApprovalG.KMH01'/></span></a>
	                                            </td>
	                                        </tr>
	                                    </table>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td style="vertical-align: top;">
	                                    <div class="border_gray">
	                                        <div id="RecGroupDetail" style="Width: 436px; Height: 262px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
	                                        </div>
	                                    </div>
	                                </td>
	                            </tr>
	                        </table>
	                    </div>
	                </td>
	                <!-- 2015-06-23 표준모듈:추가 - KSK -->
	                <td style="width: 16px; text-align: center; padding-left: 4px;" >
	                    <!-- <div style="display: inline-block; margin:auto; padding-left:2.5px;" id="AddRemoveBTN"> -->
	                    <div style="display: inline-block; margin:auto;" id="AddRemoveBTN">
	                        <img src="/images/kr/cm/arr_rright.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsertAll" onclick="return InsertRecAll();">
	                        <br>
	                        <img src="/images/kr/cm/arr_right.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsert" onclick="return InsertRec();">
	                        <br>
	                        <img src="/images/kr/cm/arr_left.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDelete" onclick="return DeleteRec();">
	                        <br>
	                        <img src="/images/kr/cm/arr_lleft.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDeleteAll" onclick="return DeleteRecAll();">
	                        <br>
	                    </div>
	                </td>
	                <td style="vertical-align: top">
	                    <table style="margin-left: 5px;">
	                        <tr>
	                            <td style="vertical-align: top;" colspan="2">
	                                <h2 class="h2_dot temp_h2_dot"> <c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t253'/></c:if> <c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t220'/></c:if></h2>
	                                <div class="border_gray">
	                                <c:if test="${approvalFlag == 'G'}">
	                                    <div id="RECEPTLIST" style="Width: 700px; Height: 519px; overflow: auto; border: 0; font-size: 9pt; margin: 0; padding-top: 0px;">
	                                    </div>
	                                </c:if>
	                                <c:if test="${approvalFlag == 'S'}">
	                                    <div id="RECEPTLIST" style="Width: 718px; Height: 518px; overflow: auto; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
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
				                                <a style="margin-top: 10px; display: none;"  class="imgbtn imgbck2" id="btnaddress"><span  onclick="return btnAddAddress()" ><spring:message code='ezApprovalG.t334'/></span></a>
		                        			</c:if>
		                        			<c:if test="${docType ne '001'}">
<!-- 		                        				btnaddress 아이디 참조 스크립트때문에 살려줌 -->
				                                <a style="display: none;" id="btnaddress"></a>
		                        			</c:if>
		                        		</c:when>
		                        		<c:otherwise>
			                                <a style="margin-top: 10px; display: none;"  class="imgbtn imgbck2" id="btnaddress"><span  onclick="return btnAddAddress()" ><spring:message code='ezApprovalG.t334'/></span></a>
		                        		</c:otherwise>
		                        	</c:choose>
	                                <%--<a style="margin-top: 10px; display: none;" class="imgbtn imgbck2" id="btnaddressChange" ><span onclick="return btnaddressChange()" ><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t348'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t1104'/></c:if></span></a>--%>
	                            	<!-- 2018-08-08 천성준 - 외부수신자요약 UI때문에 이동 -->
	                            	<span style="display: inline-block; margin-top: 8px;">
	                            		<a class="h2_dot" style="display: none;" id="trSummaryOuterReceiverList">외부수신자 요약:&nbsp;<input id="inputSummaryOuterReceiverList" value="" style="width: 280px; height: 22px;"/></a>
	                            	</span>
	                            </td>
	                            <td style="text-align:right;padding-top: 10px;">
	                            	<a class="imgbtn imgbck2"><span id="Span6" onclick="return btnaddressChange()"><c:if test="${approvalFlag == 'G'}"><spring:message code = 'ezApprovalG.lhj19' /></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code = 'ezApprovalG.lhj20' /></c:if></span></a>
	                                <a class="imgbtn imgbck2"><span id="Span5" onclick="return btn_AprDeptTempletSave_onclick('NEW')"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t308'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApprovalG.G0009'/></c:if></span></a>
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
			                                            <a class="imgbtn imgbck2" style="margin-top: 3px"><span onclick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></a>
			                                            <a class="imgbtn imgbck2" style="margin-top: 3px; display:none;"><span onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></a>
		                                        	</c:if>
		                                        </span>
		                                        <!-- 부서철보기 -->
                                                <a class="imgbtn imgbck2" style="margin-top: 3px;"><span onclick="return viewDeptBinder()"><spring:message code='ezApprovalG.t1119'/></span></a>
		                                <span id="trCreateCabDummy" style="display: none"></span>
		                                <span  style="vertical-align: middle; float: right;">
		                                    <select id="selSearchOption" style="vertical-align: top;height:22px;margin-top:3px">
		                                        <option>
		                                            <spring:message code='ezApprovalG.t10026'/>
		                                        </option>
		                                        <option>
		                                            <spring:message code='ezApprovalG.t577'/>
		                                        </option>
		                                    </select>
		                                    <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)" style="vertical-align: top;height:22px;margin-top:3px">
		                                    <a class="imgbtn imgbck2" style="margin-top: 3px"><span name="btnSearch" onclick="return CabinetSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
		                                    <a class="imgbtn imgbck2" style="margin-top: 3px"><span name="btnSearch" onclick="return Cabinetinfo_ini()"><spring:message code='ezApprovalG.t165'/></span></a>
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
		                        <a class="imgbtn imgbck2"><span onclick="return Set_MyTask('INS')"><spring:message code='ezApprovalG.t00002'/></span></a>
		                        <a class="imgbtn imgbck2"><span onclick="return Set_MyTask('DEL')"><spring:message code='ezApprovalG.t00003'/></span></a>
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
	        <div id="Cabinetinfo" style="width: 1110px; height: 595px; display: none;">
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
	                                        <select id="selSearchOption" style="vertical-align: top;height:22px">
	                                            <option id="ITEMNAME">
	                                                <spring:message code='ezApproval.t79'/>
	                                            </option>
	                                            <option id="GROUPNAME">
	                                                <spring:message code='ezApprovalG.t114'/>
	                                            </option>
	                                        </select>
	                                        <input type="text" style="height:22px" id="txtCodeSearch" onkeypress="CodeSearch_Press(event)" />
	                                        <a class="imgbtn imgbck2" onclick="return CodeSearch_onclick()">
	                                        	<span style="height:22px;line-height:22px" name="btnSearch"><spring:message code='ezApproval.t236'/></span>
	                                        </a>
	                                        <a class="imgbtn imgbck2">
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
					                            <div id="infolist" style="border: 0px; HEIGHT: 350px; WIDTH: 952px; overflow-x: hidden; overflow-y: auto; margin: 1px 1px 1px 1px; padding-top: 0px;"></div>
					                        </div>
					                    </td>
					                </tr>					                
					                <tr style="height:30px">
					                    <td>
					                       <h2 class="h2_dot"><spring:message code='ezApproval.t1100'/></h2>
					                    </td>
					                    <td style="padding-top:10px;padding-bottom:5px">
					                        <div align="right">
					                            <a class="imgbtn imgbck2"><span style="text-align: center;" onclick="btnAddCode_onclick()"><spring:message code='ezApproval.t00001'/></span></a>
					                            <a class="imgbtn imgbck2"><span style="text-align: center;" onclick="btnDelCode_onclick()"><spring:message code='ezApproval.t00002'/></span></a>
					                        </div>
					                    </td>
					                </tr>
					                <tr>
					                    <td colspan="2">
					                        <div class="">
					                            <div id="infofrequencylist" style="border: 0px; HEIGHT: 155px; overflow-x: hidden; overflow-y: auto; margin: 1px 1px 1px 1px; padding-top: 0px;"></div>
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
		    <div id="Docinfo" style="border: 0px solid #dbdbda; width: 100%; height: 597px; display: none; overflow: auto; padding-bottom: 30px;">		
		        <h2 class="h2_dot" style="margin-left: 5px;"><spring:message code='ezApprovalG.t1204'/></h2>
		        <table class="content" style="margin-left: 3px;">
		            <tr>
		                <th><spring:message code='ezApprovalG.t875'/></th>
		                <td>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="special1" id="special1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><label for="special1"><span> <spring:message code='ezApprovalG.t1205'/></span></label>&nbsp;
		                        <input type="checkbox" name="special2" id="special2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><label for="special2"><span> <spring:message code='ezApprovalG.t984'/></span></label>&nbsp;
		                        <input type="checkbox" name="special3" id="special3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><label for="special3"><span> <spring:message code='ezApprovalG.t1206'/></span></label>&nbsp;
		                        <input type="checkbox" name="special4" id="special4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><label for="special4"><span> <spring:message code='ezApprovalG.t986'/></span></label>&nbsp;
		                        <input type="checkbox" name="special5" id="special5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><label for="special5"><span> <spring:message code='ezApprovalG.t1207'/></span></label>
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
					<tr style="display:none">
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
		                <th><spring:message code='ezApprovalG.t944'/></th>
		                <td style="padding-left: 5px; padding-right: 5px;">
							<select id="rdoSecType2" name="rdoSecType2" style="WIDTH: 85px">
								<option value="Y"><spring:message code='ezApprovalG.kmh03'/></option>
								<option value="B"><spring:message code='ezApprovalG.kmh04'/></option>
								<option value="N"><spring:message code='ezApprovalG.kmh05'/></option>
							</select>
							<%--<div style="padding-left: 3px; padding-bottom: 5px;">
								<div style="padding-left: 3px; padding-top: 5px;">
										&lt;%&ndash; 			                        <input id="rdoSecType2Y" type="radio" name="rdoSecType2" value="Y" checked onclick="return rdoSecType2_onclick(this.value)" style="height: 13px; width: 13px; padding-top: 5px; padding-bottom: 5px; margin: 0px 2px 0 0;"><label for="rdoSecType2Y"><span><spring:message code='ezApprovalG.t47'/> (<spring:message code='ezApproval.t2000'/>)</span></label> &ndash;%&gt;
									<input id="rdoSecType2Y" type="radio" name="rdoSecType2" value="Y" checked style="height: 13px; width: 13px; padding-top: 5px; padding-bottom: 5px; margin: 0px 3px 0 0"><label for="rdoSecType2Y"><span><spring:message code='ezApprovalG.t47'/> (<spring:message code='ezApproval.t2000'/>)</span></label>
								</div>
								<div style="padding-left: 3px; padding-top: 5px;">
										&lt;%&ndash; 			                        <input id="rdoSecType2N" type="radio" name="rdoSecType2" value="N" onclick="return rdoSecType2_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><label for="rdoSecType2N"><span><spring:message code='ezApprovalG.t46'/> (<spring:message code='ezApproval.t2001'/>)</span></label> &ndash;%&gt;
									<input id="rdoSecType2N" type="radio" name="rdoSecType2" value="N" style="height: 13px; width: 13px; padding: 0px; margin: 0px 2px 0 0;"><label for="rdoSecType2N"><span><spring:message code='ezApprovalG.t46'/> (<spring:message code='ezApproval.t2001'/>)</span></label>
								</div>
							</div>--%>
		                </td>
		           	</tr>
					<tr>
						<th><spring:message code='ezApprovalG.t1200'/></th>
						<td>
							<input type="text" name="keyword" style="width: 50%;" value="<c:out value="${keyword}"/>" />
						</td>
					</tr>
				</table>
				<h2 class="h2_dot" style="margin-left: 5px; margin-top: 15px;">대민공개</h2>
				<table class="content" style="margin-left: 3px;">
		            <tr>
		                <th><spring:message code='ezApprovalG.kes06'/> &nbsp;&nbsp;&nbsp;</th>
		                <td>
		                    <div style="padding-left: 3px; padding-top: 5px; padding-bottom: 5px;">
		                        <spring:message code='ezApprovalG.t10029'/><br />
		                    </div>
		                    <div style="padding-left: 3px; padding-bottom: 5px;">
		                        <input type="radio" name="rdoSecType" value="1" checked onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px 3px 0 0;"><span><spring:message code='ezApprovalG.t47'/></span>&nbsp;
		                        <input type="radio" name="rdoSecType" value="2" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px 3px 0 0;"><span><spring:message code='ezApprovalG.t150'/></span>&nbsp;
		                        <input type="radio" name="rdoSecType" value="3" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px 3px 0 0;"><span><spring:message code='ezApprovalG.t46'/></span>&nbsp;
		                        <span class="openGov">
		                        	<input type="checkbox" name="openListFlag" id="openListFlag" value="checkbox" onClick="openListFlag_onClick(this)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> 목록공개</span>
		                        </span>
		                    </div>
		                </td>
		            </tr>
        		    <tr id="basis" class="openGov">
						<th>목록비공개사유</th>
						<td>
							<input type="text" id="txt_Basis" name="txt_Basis" style="width: 50%; box-sizing: border-box; -moz-box-sizing: border-box;" maxlength="35" />
							* 35자 이내로 입력해주세요
						</td>
					</tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t989'/></th>
		                <td>
		                    <div style="padding-top: 5px; padding-left: 3px;">
		                        <input type="checkbox" name="selSecLevel1" id="selSecLevel1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 1호</span>
		                        <input type="checkbox" name="selSecLevel2" id="selSecLevel2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 2호</span>
		                        <input type="checkbox" name="selSecLevel3" id="selSecLevel3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 3호</span>
		                        <input type="checkbox" name="selSecLevel4" id="selSecLevel4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 4호</span>
		                        <input type="checkbox" name="selSecLevel5" id="selSecLevel5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 5호</span>
		                        <input type="checkbox" name="selSecLevel6" id="selSecLevel6" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 6호</span>
		                        <input type="checkbox" name="selSecLevel7" id="selSecLevel7" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 7호</span>
		                        <input type="checkbox" name="selSecLevel8" id="selSecLevel8" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px;"><span> 8호</span>
		                    </div>
		                    <div class="openGov">
		                         <textarea id="txt_Reason" name="txt_Reason" style="height: 40px; width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
		                    </div>
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezApprovalG.t876'/></th>
		                <td>
							<input type="text" name="txtLimitRange" id="txtLimitRange" class="text" style="Width: 170px; font-size: 9pt"><span>(<spring:message code='ezApprovalG.t1209'/></span>
						</td>
					</tr>
		            <tr class="openGov">
		                <th>원문공개열람제한일</th>
		                <td>
		                	<input type="checkbox" name="openGovLimitDate" id="openGovLimitDate" value="checkbox" onclick="openGovLimitDate_onClick()">
		                    <input readonly="readonly" id='idDatepickerForOpenGov' style="PADDING-BOTTOM: 0px; PADDING-LEFT: 3px; PADDING-RIGHT: 3px; PADDING-TOP: 2px; WIDTH: 80px;">
		                </td>
		            </tr>
		            <tr class="openGov">
		                <th>첨부정보</th>
		                <td>
		                <div style="overflow: auto; width: 100%; height: 115px;">
			               <table width="100%" class="popuplist" style="margin-top: 2px;">
			               <thead>
			               <%-- 2022-01-17 홍승비 - 일괄기안 사용 시 원문공개 첨부파일에 "안" 번호 데이터 추가 --%>
					    	<c:choose>
					    	<c:when test="${draftAllFlag == 'Y'}">
					    	<tr>
						    	<th id="lvAPRLINE_TH_0" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px"><spring:message code='ezApprovalG.t109'/></th>
						    	<th id="lvAPRLINE_TH_1" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px">안</th>
						    	<th id="lvAPRLINE_TH_2" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px"><spring:message code='ezApprovalG.t439'/></th>
						    	<th id="lvAPRLINE_TH_3" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:350px"><spring:message code='ezApprovalG.t00010'/></th>
						    	<th id="lvAPRLINE_TH_4" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:70px"><spring:message code='ezBoard.t376'/></th>
						    	<th id="lvAPRLINE_TH_5" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:60px"><spring:message code='ezCommunity.t66'/>/<spring:message code='ezCommunity.t67'/></th>
						    	<th id="lvAPRLINE_TH_6" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:60px;display:none;"></th>
						    </tr>
					    	</c:when>
					    	<c:otherwise>
					    	<tr>
						    	<th id="lvAPRLINE_TH_0" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px">공개여부</th>
						    	<th id="lvAPRLINE_TH_1" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:30px">순번</th>
						    	<th id="lvAPRLINE_TH_2" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:350px">파일이름</th>
						    	<th id="lvAPRLINE_TH_3" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:70px">파일크기</th>
						    	<th id="lvAPRLINE_TH_4" class="h4_center" bgcolor="#CCCCCC" style="height:10px;width:60px">공개/비공개</th>
						    </tr>
						    </c:otherwise>
						    </c:choose>
						  	</thead>
						  	<tbody  id="attachList">
						  	</tbody>
							</table> 
						</div>
		                </td>
		            </tr>					
				</table>
				<%--
		            <h2 class="h2_dot"><spring:message code='ezApprovalG.t1203'/></h2>
		            <textarea id="taSummery" name="taSummery" style="HEIGHT: 120px; WIDTH: 99.7%; resize:none; box-sizing: border-box; -moz-box-sizing: border-box; margin-left:3px;"></textarea>
                --%>
		    </div>
	    </c:if>
	    
	    <c:if test="${approvalFlag eq 'S' }">
	    	<div id="Docinfo" style="width: 1163px; height: 562px; display: none; padding-top:3px; padding-bottom: 30px;">
        		<td style="border: 0px solid red; height: 580px; width: 390px; margin-left: 5px; vertical-align: top">
		            <h2 class="h2_dot"><spring:message code='ezApproval.t334'/></h2>
		            <table class="content" style="margin-top:4px">
		                <tr>
		                    <th><spring:message code='ezApproval.t335'/></th>
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
		                                    <a class="imgbtn imgbck2" id="btndocinfo"><span id="btndocinfo2" onclick="movedraftinfo()"><spring:message code='ezApproval.t335'/><spring:message code='ezApproval.t321'/></span></a>
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
		                                <td style="width: auto; padding-left: 4px; padding-bottom: 4px">
											<select id="RSecurity" name="RSecurity" style="WIDTH: 85px">
												${securityNode3}
											</select>
										</td>
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
						<tr>
							<th><spring:message code='ezApprovalG.t1200'/></th>
							<td>
								<input type="text" name="keyword" style="width: 50%;" value="<c:out value="${keyword}"/>" />
							</td>
						</tr>
		                <%-- <tr>
		                    <td colspan="2">
		                        <h2 class="h2_dot"><spring:message code='ezApproval.t339'/></h2>
		                    </td>
		                </tr>
		                <tr>
		                	<th><spring:message code='ezApproval.t339'/></th>
		                    <td>		                    	
		                            <textarea id="taSummery" name="taSummery" style="HEIGHT: 345px; WIDTH: 99.7%; resize:none; box-sizing: border-box; -moz-box-sizing: border-box; margin: 2px 2px 2px 2px"></textarea>
		                    </td>
		                </tr> --%>
		            </table>
		        </td>
		    </div>
	    </c:if>
	    <c:if test="${approvalFlag eq 'S' }">
<!-- 	    회람 -->
	    	<div id="Circulation" style="width: 1110px; height: 590px; margin-bottom: 5px; display: none;">
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
			                <div id="Organ" style="width:440px">
			                	<table style="width:99.5%;table-layout: fixed">
			                		<tr>
	                                    <td style="vertical-align: top;">                                    	
	                                        <div id="TreeViewCC" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 437px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
	                                        </div>
	                                    </td>
                               	 	</tr>
                                	<tr>
	                                    <td style="border: 1px solid #ddd;">
                                        <div class="border_gray" style="border: 0px;">
                                            <div id="UserListCC" style="border: 0px; margin: 0px 1px 1px 1px; Width: 436px; Height: 223px; overflow: auto;">
                                            </div>
                                        </div>
                                    </td>
                                	</tr>
			                    	<tr>
	                                    <td style="background-color: transparent; height: 28px; padding-top:10px; vertical-align: top">
	                                        <input id="textUserCC" style="width: 150px;height:22px" name="textUserCC" onkeypress="return textUserCC_onkeypress(event)"  maxlength="50">
	                                        <a class="imgbtn imgbck2"><span name="btn_searchUserCC" id="btn_searchUserCC" onkeypress="return btn_searchUserCC_onclick()" onclick="return btn_searchUserCC_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
											<!-- 부서추가 -->
											<a class="imgbtn imgbck2"><span id="btn_addDept" onclick="return btn_addDepartment()"><spring:message code='ezApproval.psb02'/></span></a>
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
			                                    <div id="RecSaveListCC" style="border: 0px; Width: 436px; Height: 237px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
			                                    </div>
			                                </div>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td style="background-color: transparent; text-align: center; height: 30px;">
			                                <table class="content" style="margin-bottom: 5px; width: 100%; ">
			                                    <tr>
			                                        <td style="text-align: center;">
			                                            <a class="imgbtn imgbck2"><span id="Span3" onclick="return btn_AprDeptTempletDelCC_onclick()"><spring:message code='ezApprovalG.hsbFv01'/></span></a>
			                                            <a class="imgbtn imgbck2"><span id="Span4" onclick="return btn_AprDeptTempletSaveCC_onclick('MODIFY')"><spring:message code='ezApprovalG.hsbFv02'/></span></a>
			                                            <a class="imgbtn imgbck2"><span onclick="return btn_AprDeptTempletAddCC_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
			                                        </td>
			                                    </tr>
			                                </table>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td style="vertical-align: top;">
			                                <div class="border_gray">
			                                    <div id="RecSaveDetailCC" style="Width: 436px; Height: 208px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
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
			            <td>
			                <h2 class="h2_dot"><spring:message code='ezApprovalG.hyj20'/>
			                </h2>
			                <div class="border_gray" style="margin-top:7px; margin-left:4px;">
                                <div id="APRLINECC" style="Width: 717px; Height: 518px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                              	</div>
                            </div>
			                <div style="text-align: right;">
			                    <a class="imgbtn imgbck2" style="padding-right: 5px; margin-top: 10px;"><span id="Span5" onclick="return btn_AprDeptTempletSaveCC_onclick('NEW')"><spring:message code='ezApprovalG.hyj07'/> </span></a>
			                </div>
			            </td>
			        </tr>
			    </table>
		    </div>
	    </c:if>
	    <!-- 공람 -->
	    <c:if test="${approvalFlag eq 'G'}">
	    	<div id="Circulation" style="width: 1110px; height: 597px; margin-bottom: 5px; display: none;">
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
			                <div id="Organ" style="width:440px">
			                	<table style="width:99.5%;table-layout: fixed">
			                		<tr>
	                                    <td style="vertical-align: top;">                                    	
	                                        <div id="TreeViewCC" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 290px; width: 437px; border: 1px solid #ddd; background-color: #FFFFFF; margin: 1px 1px 1px 0px;">
	                                        </div>
	                                    </td>
                               	 	</tr>
                                	<tr>
	                                    <td style="border: 1px solid #ddd;">
                                        <div class="border_gray" style="border: 0px;">
                                            <div id="UserListCC" style="border: 0px; margin: 0px 1px 1px 1px; Width: 436px; Height: 223px; overflow: auto;">
                                            </div>
                                        </div>
                                    </td>
                                	</tr>
			                    	<tr>
	                                    <td style="background-color: transparent; height: 28px; padding-top:10px; vertical-align: top">
	                                        <input id="textUserCC" style="width: 150px;height:22px" name="textUserCC" onkeypress="return textUserCC_onkeypress(event)"  maxlength="50">
	                                        <a class="imgbtn imgbck2"><span name="btn_searchUserCC" id="btn_searchUserCC" onkeypress="return btn_searchUserCC_onclick()" onclick="return btn_searchUserCC_onclick()" ><spring:message code='ezApprovalG.t234'/></span></a>
											<!-- 부서추가 -->
											<a class="imgbtn imgbck2"><span id="btn_addDept" onclick="return btn_addDepartment()"><spring:message code='ezApproval.psb02'/></span></a>
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
			                                    <div id="RecSaveListCC" style="border: 0px; Width: 436px; Height: 237px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
			                                    </div>
			                                </div>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td style="background-color: transparent; text-align: center; height: 30px;">
			                                <table class="content" style="margin-bottom: 5px; width: 100%; ">
			                                    <tr>
			                                        <td style="text-align: center;">
			                                            <a class="imgbtn imgbck2"><span id="Span3" onclick="return btn_AprDeptTempletDelCC_onclick()"><spring:message code='ezApprovalG.hsbFv01'/></span></a>
			                                            <a class="imgbtn imgbck2"><span id="Span4" onclick="return btn_AprDeptTempletSaveCC_onclick('MODIFY')"><spring:message code='ezApprovalG.hsbFv02'/></span></a>
			                                            <a class="imgbtn imgbck2"><span onclick="return btn_AprDeptTempletAddCC_onclick()" style="width: 60px;"><spring:message code='ezApprovalG.t336'/></span></a>
			                                        </td>
			                                    </tr>
			                                </table>
			                            </td>
			                        </tr>
			                        <tr>
			                            <td style="vertical-align: top;">
			                                <div class="border_gray">
			                                    <div id="RecSaveDetailCC" style="Width: 436px; Height: 208px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
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
						<td style="width: 16px; text-align: center; padding-left: 4px;" >
							<div style="display: inline-block; margin:auto;" id="ArrBtnCC">
								<img src="/images/kr/cm/arr_rright.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsertAll" onclick="btn_addDepartment()">
								<br>
								<img src="/images/kr/cm/arr_lleft.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDeleteAll" onclick="list3_deleteAll()">
								<br>
								<img src="/images/kr/cm/arr_right.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgInsert" onclick="list3_onSel_DBclick()">
								<br>
								<img src="/images/kr/cm/arr_left.gif" alt="" width="16px" height="16px" border="0" style="cursor:pointer;" id="imgDelete" onclick="AprlineDel_onclickCC()">
								<br>
							</div>
						</td>
			            <td>
			                <h2 class="h2_dot"><spring:message code='ezApprovalG.LJEAppr07'/>
			                </h2>
			                <div class="border_gray" style="margin-top:7px; margin-left:4px;">
                                <div id="APRLINECC" style="Width: 700px; Height: 518px; overflow: auto; overflow-x:hidden; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                              	</div>
                            </div>
			                <div style="text-align: right;">
			                    <a class="imgbtn imgbck2" style="padding-right: 5px; margin-top: 10px;"><span id="Span5" onclick="return btn_AprDeptTempletSaveCC_onclick('NEW')"><spring:message code='ezApprovalG.LJEAppr08'/></span></a>
			                </div>
			            </td>
			        </tr>
			    </table>
		    </div>
	    </c:if>
	    <c:if test="${approvalFlag eq 'G' }">
			<!-- 비전자문서 정보 -->
			<div id="NonElecRecInfo" style="width: 100%; height: 597px; margin-bottom: 5px; display: none;">
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
								        <input type="date" class="text" name="regDate" id="regDate" /><input type="time" name="regTime" id="regTime" />
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
									<th >발신기관명</th><!--발신기관명-->
									<td>
							        	<input type="text" name="txtReceiptMember" id="txtReceiptMember" class="text" style="Width:100%;">
							        </td>
								</tr>
								<tr>
	        						<th>문서발신자</th><!-- 기안자 -->
									<td>
	        							<input type="text" name="txtDrafter" id="txtDrafter" class="text" style="Width:100%;">
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
							        	<input type="text" name="txtOriginSN" id="txtOriginSN" class="text" style="Width:100%;" maxlength="48">
								    </td>
								</tr>
								<tr>
            						<th>문서시행일자</th><!-- 시행일자 -->
  	    							<td>
										<input type="date" class="text" name="exeDate" id="exeDate" />
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
									<tr <c:if test="${nonElecRecType eq 'HWP' || nonUseDocAttachYN eq 'N' }"> style="display: none;"</c:if>>
									<th><spring:message code='ezApprovalG.nonElecAt02'/></th> <!-- 본문첨부 -->
									<td>
										<input type="text" readonly="" id="filename" style="width: 180px;">
										<c:if test="${guBun eq '1'}">
										<a class="imgbtn">
						     	           <span id="btnAddDocAttach" onClick="return btnfileup()" style="" >
											    <spring:message code='ezApprovalG.nonElecAt03'/>
						     	        	</span>
										</a>
											<span>* (image, OfficeFile, hwp )</span>
										</c:if>
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
		</div>
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
		        <NAME><spring:message code='main.t79'/></NAME>
		        <WIDTH>80</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezApprovalG.b12'/></NAME>
		        <c:choose>
					<c:when test="${userInfo.lang eq '6'}">
						<WIDTH>110</WIDTH>
					</c:when>
					<c:otherwise>
						<WIDTH>50</WIDTH>
					</c:otherwise>
				</c:choose>
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
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	    <!-- 사용자 정보 해더 xml -->
		<input id="file" type="file" onchange="filechange(event)" accept=".doc, .docx, .ppt, .pptx, .xls, .xlsx, .pdf, .jpg, .jpeg, .png, .gif, .bmp, .txt, .text, .html, .htm, .hwp" style="display:none;width:0px;height:0px;" />
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	    Tab2_NewTabIni("tab2");
	    Tab3_NewTabIni("tab3");
	    Tab5_NewTabIni("tab5");
	</script>
	<span id="loading" style="top: 300px; left: 550px; width: 100px; display: none; position: absolute;">
			<img src="/images/loading/loading_new.gif" style="width: 100px;">
	</span>
</html>