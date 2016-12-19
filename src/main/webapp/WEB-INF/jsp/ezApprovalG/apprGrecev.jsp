<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE HTML>
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t1308'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/docnumber_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Recvdocnumber_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/Recev_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/signSplit_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CheckLines_Cross.js"></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pDocID = "${docID}";
			var DraftFlag = "${draftFlag}";
			var pFormHref = new String("");
			var pFormID = new String();
			var pUserID = "${userInfo.id}";
			var pHasAttachYN = new String("N");
			var pHasOpinionYN = new String("N");
			var FormProc = null;
			var CurrentDate;
			var flag = false;
			var fieldflag = false;
			var xmlhttp = createXMLHttpRequest();	
			var xmldoc = createXmlDom();
			var xmluserInfo = createXmlDom();
			var SignCount = 0;
			var hapyuiCount = 0;
			var gongramCount = 0;
			// 2012.02.08 프로세스 디자이너 추가
			var HapyuiArea = 0;
			var AprLineArea = 0;
			var SignInfo = "";
			var SignInfoFlag = true;
			var pDraftFlag; //재기안 Flag
			var pSuSinFlag; //수신칸 Flag
			var pChamJoFlag;//참조칸 Flag
			var pSusinSN;   //N수발신문서SN
			var pDocType;   //수발신문서 , 부서병렬합의 DocType
			var pDocState;  //수발신 문서 , 부서병렬합의 DocState
			var pOrgDocID;  //수발신 문서 , 부서병렬합의 원기안문서 DocID
			var pOrgHtml;
			var IsSkipDrafter;
			var badForm = false;
			var g_docnumber = "";
			var pCurSelRow;
			var pSusinDocURL = "";
			var DeptSymbol;
			var pPublic = "P";
			var drafterDeptid;
			var gPublic = "";
			var AppendFileAttach = "";
			var AppenAprDocAttachList = "";
			var pDocNumCode = "";
			var RootURL = document.location.protocol + "//" + document.location.hostname;  
			var arr_userinfo = new Array();
			arr_userinfo[0]  = "user";								// 사용자-부서구분
			arr_userinfo[1]  = "${userInfo.id}";              // 사용자ID
			arr_userinfo[2]  = "${userInfo.displayName}";         // 사용자명
			arr_userinfo[3]  = "${userInfo.title}";               // 사용자 직위
			arr_userinfo[4]  = "${userInfo.deptID}";              // 사용자 부서 ID
			arr_userinfo[5]  = "${userInfo.deptName}";            // 사용자 부서 이름
			arr_userinfo[6]  = "${userInfo.jikChek}";             // 사용자 직책            
			arr_userinfo[8]  = "${userInfo.email}";               // E-Mail Address 
			arr_userinfo[9]  = "";
			arr_userinfo[10] = "${susinAdmin}";                  // 수신 접수담당자
			// 수정(2007.06.18) : multidata 기능 추가
			arr_userinfo[11]  = "${userInfo.displayName1}";		// 사용자명(P)
			arr_userinfo[12]  = "${userInfo.displayName2}";		// 사용자명(S)
			arr_userinfo[13]  = "${userInfo.title1}";				// 사용자 직위(P)
			arr_userinfo[14]  = "${userInfo.title2}";				// 사용자 직위(S)
			arr_userinfo[15]  = "${userInfo.deptName1}";			// 사용자 부서 이름(P)
			arr_userinfo[16]  = "${userInfo.deptName2}";			// 사용자 부서 이름(S)
			
			var SignType = new Array();
			var SignName = new Array();
			var SignContent = new Array();
			var KuyjeType = "002";
			var signDateFormat = "${optSignDateFormat}";
			var isSplit = "${optisSplit}";
			var SplitKind = "${optSplitKind}";
			var ConvertYN = "Y";	// 이 값이 N이면, 원문서를 그대로 사용한다.
			var _USE_DirectSign = "${useDirectSign}";     //20090112 직접서명
			
			//20110201  기안일자 확인 
			var _DraftDate = "${draftDate}";
			var docAccess = 0 ;  //20110207 문서번호 채번후 연동 실패시에도 문서번호 롤백이 되어야 한다.
			//2011.05.11 결재알림메일 기능 추가
			var g_szUserID = arr_userinfo[8];  // E-Mail Address 
			var g_senderinfo = "${userInfo.companyName}" + ", " + "${userInfo.deptName}" + ", " + "${userInfo.title}";
			//CKEDITOR-추가
			var mhtData;
			var mhtData2;
			var StartMode = "0";
			var StartMode2 = "0";
			var SummaryFlag = true;
			var NonActiveX = "YES";
			window.onload = function () {
			};
			
			//양식HTML내용
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
			                len = pFormHref.lastIndexOf("/");
			                pDocID = pFormHref.substr(len + 1, 20);
			                GetAprDocFormID();
			                setAttachInfo(pDocID, "APR", lstAttachLink);
			                getDocInfo();
			
			                if (pHasOpinionYN == "Y") {
			                    if (pAprState == "006")
			                        pInformationContent = "<spring:message code='ezApprovalG.t124'/><br> <spring:message code='ezApprovalG.t125'/>";
			                    else
			                        pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t125'/>";
			
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
			                getDocInfo();
			                if (pHasOpinionYN == "Y") {
			                    var pInformationContent;
			                    var Ans;
			
			                    pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t125'/>";
			                    Ans = OpenInformationUI(pInformationContent);
			
			                    if (Ans) {
			                        openOpinionUI("Display");
			                    }
			
			                }
			            } else if (pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
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
			
			                    pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t125'/>";
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
			        }
			    } catch (e) {
			        alert(e.description);
			    }
			}
			
			
			//자동입력
			function setAutoProperty()
			{
			  try{
				//사용자정보
				getDraftUserInfo();
				//자동입력
				SetAutoPropertyValue();
			
				//INIT ======================================================================================
				var rtnVal = ExcuteInfo("INIT","");
				if(!rtnVal)
				{
					var pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
					OpenAlertUI(pAlertContent);
					return;				
				}  
			  }catch(e){  
			    alert("setAutoProperty : " +e.description);    
			  }	  
			}
			
			var messageload = false;
			var messageload2 = false;
			function FieldsAvailable() {
			    messageload = true;
			    if (ConvertYN == "N") {
			        setAutoProperty();
			        process_AfterOpen();
			    }
			    else {
			        message2.Set_EditorContentURL(pFormHref);
			    }
			}
			
			var setFildAvailable;
			function FieldsAvailable2() {
			
			    messageload2 = true;
			    if (!messageload || !messageload2) {
			        setFildAvailable = setInterval(FieldsAvailable2, 1000);
			        return;
			    }
			    clearInterval(setFildAvailable);
			
			    setAutoProperty();
			    var fields = message.GetFieldsList();
			    var fields2 = message2.GetFieldsList();
			
			    if (message.GetListItem(fields, "body")) {
			        if (message2.GetListItem(fields2, "body")) {
			            message.GetListItem(fields, "body").innerHTML = message2.GetListItem(fields2, "body").innerHTML;
			        }
			    }
			
			    if (message.GetListItem(fields, "doctitle")) {
			        if (message2.GetListItem(fields2, "doctitle")) {
			            message.GetListItem(fields, "doctitle").innerHTML = CKediter_Trim(message2.GetListItem(fields2, "doctitle").innerHTML);
			            var doctitle = message.GetListItem(fields, "doctitle").textcontent;
			        }
			    }
			
			    if (message.GetListItem(fields, "publication")) {
			        if (message2.GetListItem(fields2, "publication")) {
			            message.GetListItem(fields, "publication").textContent = CKediter_Trim(message2.GetListItem(fields2, "publication").innerText);
			            var publication = message.GetListItem(fields, "publication").textContent;
			        }
			    }
			
			    if (message.GetListItem(fields, "department")) {
			        if (message2.GetListItem(fields2, "department")) {
			            message.GetListItem(fields, "department").innerHTML = CKediter_Trim(message2.GetListItem(fields2, "department").innerHTML);
			            var department = message.GetListItem(fields, "department").textContent;
			        }
			    }
			
			    if (message.GetListItem(fields, "position")) {
			        if (message2.GetListItem(fields2, "position")) {
			            message.GetListItem(fields, "position").innerHTML = CKediter_Trim(message2.GetListItem(fields2, "position").innerHTML);
			            var position = message.GetListItem(fields, "position").textContent;
			        }
			    }
			
			    if (message.GetListItem(fields, "telephone")) {
			        if (message2.GetListItem(fields2, "telephone")) {
			            message.GetListItem(fields, "telephone").innerHTML = CKediter_Trim(message2.GetListItem(fields2, "telephone").innerHTML);
			            var position = message.GetListItem(fields, "telephone").textContent;
			        }
			    }
			
			
			    if (message.GetListItem(fields, "draftername")) {
			        if (message2.GetListItem(fields2, "draftername")) {
			            message.GetListItem(fields, "draftername").innerHTML = CKediter_Trim(message2.GetListItem(fields2, "draftername").innerHTML);
			            var draftername = message.GetListItem(fields, "draftername").textContent;
			        }
			    }
			
			    if (message.GetListItem(fields, "keepperiod")) {
			        if (message2.GetListItem(fields2, "keepperiod")) {
			            for (var i = 0; i < message.GetListItem(fields, "keepperiod").options.length ; i++) {
			                if (message2.GetListItem(fields2, "keepperiod").innerHTML == message.GetListItem(fields, "keepperiod").options[i].innerHTML)
			                    message.GetListItem(fields, "keepperiod").options.textContent = CKediter_Trim(message.GetListItem(fields, "keepperiod").options[i].textContent);
			            }
			
			            var a = message2.GetListItem(fields2, "keepperiod").innerHTML;
			            var re = new RegExp("&nbsp;", "gi");
			            var b = a.replace(re, "");
			            var c = parseInt(b);
			
			            if (!isNaN(c))
			                message.GetListItem(fields, "keepperiod").options.textContent = c;
			            else
			                message.GetListItem(fields, "keepperiod").textContent = "<spring:message code='ezApprovalG.t1692'/>";
			        }
			    }
			
			    var lastKyulName = "";
			    lastKyulName = message.GetAttribute('lastKyulName');
			    if (lastKyulName) {
			        lastKyulName = lastKyulName + "(" + message.GetAttribute('astKyuljikwee') + ")";
			        if (message.GetListItem(fields, "lastKyulName"))
			            message.GetListItem(fields, "lastKyulName").textContent = lastKyulName;
			    }
			    process_AfterOpen();
			}
			
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		            IsSkipDrafter = "TRUE";
		            DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
		            drafterDeptid = arr_userinfo[4];
		            SetBtnStateTrue();
		            getReceiveDocInfo();

		            if (pSusinDocURL != "") {
		                if (pSusinDocURL == "PC") {
		                    document.getElementById('pFile').click();
		                    var rtnval = pFile.value;
		                }
		                else {
		                    if (ConvertYN == "N") {
		                        message.Set_EditorContentURL(pFormHref);
		                    }
		                    else {
		                        message.Set_EditorContentURL(pSusinDocURL);
		                    }
		                }
		            }
		        }
		    }
			
			
			function DocumentComplete2()
			{
			    message2.Set_EditorContentURL(pFormHref);
			}
			
			//웹에디터 교체 -> 기존 : pzFormProc2_FieldsAvailable
			
			
			// 결재선지정 버튼 선택시 처리함수
			function btnSetAprLine_onclick()
			{
				var ret = openAprLineUI();
				if(ret[3] != "" && ret[3] != "cancel") 
					pPublic = ret[3];
				if (ret[0] != "cancel" && ret[3] != "cancel")
				{	   
					IsSkipDrafter = "FALSE";			  
					document.getElementById('btnSendDraft').Enable = "true";
					GetDraftAprLineInfo(ret); 
				}
				else
				{
					if(ret[2] == "cancel")
					{
				   		var pAlertContent = "<spring:message code='ezApprovalG.t1485'/>";
				   		OpenAlertUI(pAlertContent);
						return;	   
					}
				}
			}
			
			    function btnSendDraft_onclick() {
			        try {
			            var rtnSignInfo;
			            var fields = message.GetFieldsList();
			            var field = message.GetListItem(fields, "doctitle");
			
			            var pDocTitle;
			
			            if ((LastSignSN == 1 || typeof (LastSignSN) == "undefined") && IsSkipDrafter == "TRUE") {
			                var pAlertContent = "<spring:message code='ezApprovalG.t1489'/><BR> <spring:message code='ezApprovalG.t1490'/>";
			                var Ans = OpenInformationUI(pAlertContent, CheckAprLine);
			            }
			            else {
			                if (!checkLines())
			                    return;
			
			                pDocTitle = field.textContent;
			                pDocTitle = trim(pDocTitle);
			                var field = message.GetListItem(fields, "docnumber");
			                if (field) {
			                    if (trim(getfieldValue(field)) == "<spring:message code='ezApprovalG.t819'/>") {
			                        var pAlertContent = "<spring:message code='ezApprovalG.t1691'/>";
			                        OpenAlertUI(pAlertContent);
			                        return;
			                    }
			                }
			
			                if (pDocTitle == "") {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1491'/>";
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
			        }
			        catch (e) {
			            alert("btnSendDraft_onclick : " + e.description);
			        }
			    }
			
			    function check_skipdraft() {
			        if (LastSignSN == 1 || DraftLastFlag) {
			            getLastOpinon();
			        }
			
			        if (IsSkipDrafter == "FALSE") {
			            var ret;
			            var parameter = new Array();
			
			            parameter[0] = pDocID;
			            parameter[1] = _USE_DirectSign;
			            openSignUI(parameter);
			        }
			        else {
			            SaveRecevInfo();
			        }
			    }
			
			    function SaveRecevInfo() {
			        if ((pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") && pSusinSN != "0") {
			            var RtnVal;
			            var pAlertContent;
			            RtnVal = "true";
			            if (RtnVal == "true") {
			                RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "");
			                if (!RtnVal) {
			                    pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                    OpenAlertUI(pAlertContent);
			                    return;
			                }
			                if (RtnVal) RtnVal = SaveDraftDocInfo();
			                if (RtnVal == "TRUE") {
			                    RtnVal = setSusinUpdataDocID();
			                    RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "");
			                    if (!RtnVal) {
			                        pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                        OpenAlertUI(pAlertContent);
			                        return;
			                    }
			                    if (LastSignSN == 1 || DraftLastFlag) {
			                        RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "");
			                        if (!RtnVal) {
			                            pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                            OpenAlertUI(pAlertContent);
			                            return;
			                        }
			
			                        if (pDraftFlag == "HAPYUI") {
			                           
			                        }
			
			                    }
			                    else {
			                    }
			                    pAlertContent = "<spring:message code='ezApprovalG.t1494'/>";
			                    OpenAlertUI(pAlertContent, OpenAlertUI_Close);
			                    return;
			                }
			                else {
			                    UndoSignInfo(rtnSignInfo);
			                    if (LastSignSN == 1 || DraftLastFlag) {
			                        RtnVal = ExcuteInfo("END_FAIL", "");
			                        if (!RtnVal) {
			                            pAlertContent = "[<spring:message code='ezApprovalG.t781'/>";
			                            OpenAlertUI(pAlertContent);
			                            return;
			                        }
			                    }
			                    pAlertContent = "[<spring:message code='ezApprovalG.t552'/>";
			                    OpenAlertUI(pAlertContent);
			                    return;
			                }
			            }
			            else {
			                UndoSignInfo(rtnSignInfo);
			                if (LastSignSN == 1 || DraftLastFlag) {
			                    RtnVal = ExcuteInfo("END_FAIL", "");
			                    if (!RtnVal) {
			                        pAlertContent = "[<spring:message code='ezApprovalG.t781'/>";
			                        OpenAlertUI(pAlertContent);
			                        return;
			                    }
			                }
			                SetBtnStateTrue();
			                document.getElementById('btnSendDraft').Enable = "true";
			
			                pAlertContent = "[<spring:message code='ezApprovalG.t783'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			        }
			        else {
			            var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "");
			            var pAlertContent;
			            if (!RtnVal) {
			                pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                OpenAlertUI(pAlertContent);
			                RollbackNum();
			                return;
			            }
			            RtnVal = SaveDraftDocInfo();
			            if (RtnVal == "TRUE") {
			                RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "");
			                if (!RtnVal) {
			                    pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                    OpenAlertUI(pAlertContent);
			                    RollbackNum();
			                    return;
			                }
			                if (LastSignSN == 1 || DraftLastFlag) {
			                    RtnVal = ExcuteInfo("DOCNUM_END", "");
			                    if (!RtnVal) {
			                        pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                        OpenAlertUI(pAlertContent);
			                        RollbackNum();
			                        return;
			                    }
			                }
			                else {
			                }
			                pAlertContent = "<spring:message code='ezApprovalG.t1496'/>";
			                OpenAlertUI(pAlertContent, OpenAlertUI_Close);
			            }
			            else {
			                UndoSignInfo(rtnSignInfo);
			                if (LastSignSN == 1 || DraftLastFlag) {
			                    RtnVal = ExcuteInfo("END_FAIL", "");
			                    if (!RtnVal) {
			                        pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                        OpenAlertUI(pAlertContent);
			                        return;
			                    }
			                }
			                SetBtnStateTrue();
			                pAlertContent = "[<spring:message code='ezApprovalG.t147'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			        }
			    }
			
			    function openSignUI_Complete(ret) {
			        if (ret == "cancel") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			
			        pOrgHtml = ConvertHTMLtoMHT(message.Get_EditorBodyHTML());
			        if (LastSignSN == 1 || DraftLastFlag) {
			            var rtnVal;
			            rtnVal = ExcuteInfo("DOCNUM_BEFORE", "");
			            if (!rtnVal) {
			                var pAlertContent = "[<spring:message code='ezApprovalG.t7'/>";
			                OpenAlertUI(pAlertContent);
			                return;
			            }
			        }
			
			        if (LastSignSN == 1 || DraftLastFlag)
			            rtnval = getRecvDocNumber(arr_userinfo[4]);
			        else
			            rtnval = getRecvDocNumber(arr_userinfo[4]);
			
			        if (!rtnval) {
			            var pAlertContent = "[<spring:message code='ezApprovalG.t1493'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			
			        if (ConvertYN == "N" && pDraftFlag == "GAMSABU") {
			            rtnval = true;
			        }
			        else {
			            if (LastSignSN == 1 || DraftLastFlag) {
			                rtnval = getDocNumber(arr_userinfo[4], "");
			                if (rtnval) docAccess = 2; 
			            }
			            else {
			                rtnval = getDocNumber(arr_userinfo[4], "be");
			                if (rtnval) docAccess = 1; 
			            }
			        }
			
			        if (!rtnval) {
			            var pAlertContent = "[<spring:message code='ezApprovalG.t782'/>";
			            OpenAlertUI(pAlertContent);
			            return;
			        }
			
			        if (LastSignSN == 1 || DraftLastFlag) {
			            var rtnVal;
			            rtnVal = ExcuteInfo("DOCNUM_AFTER", "");
			            if (!rtnVal) {
			                var pAlertContent = "[<spring:message code='ezApprovalG.t781'/>";
			                OpenAlertUI(pAlertContent);
			                RollbackNum();   
			                return;
			            }
			        }
			        rtnSignInfo = SendDraftMappingSign(ret);

			        SaveRecevInfo();
			    }
			
			    function OpenAlertUI_Close() {
			        DivPopUpHidden();
			        window.close();
			    }
			
			    function chk_Passwd_Complete(chkpass) {
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
			        check_skipdraft();
			    }
			
			    function CheckAprLine(Ans) {
			        DivPopUpHidden();
			        if (Ans) {
			            btnApprovalInfo("9");
			            return;
			        }
			        else {
			            return;
			        }
			    }
			
			// 첨언창 오픈 함수
			function btnOpinion_onclick()
			{
				var ret = openOpinionUI("N");
			}
			
			//프린트 
			var PrtBodyContent;
			function btnPrint_onclick() {
			    PrintClick("Cross", pDocID, "");
			}
			
			
			// 종료
			function btnClose_onclick()
			{
				window.close();
			}
			window.onbeforeunload = function () {
				try{
					window.opener.openergetDocInfo();
				}catch(e){	}	
				try{
					window.opener.Refresh_Window();
				}catch(e){	}	
			};
			
			//유효한 문서가 아닌경우 
			function pzFormProc_InvalidDocument()
			{
				var pAlertContent = "<spring:message code='ezApprovalG.t12'/>";
			    OpenAlertUI(pAlertContent);
				FormProc.FileNew();
			}
			
			//지정
			function btnAssign_onclick() 
			{
				var parameter = new Array();
				parameter[0] = pDocID;						//문서ID
				parameter[1] = pSusinSN;					//수발신SN
				parameter[2] = pAprState;					//결재상태
			  
				var url = "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveAssignUI_Cross.aspx";
				var feature = "status:no;dialogWidth:388px;dialogHeight:345px;edge:sunken;scroll:no";
				 	
				feature =  feature + GetShowModalPosition(388, 345);
				var ret = window.showModalDialog(url,parameter,feature);
				if(ret == "OK")
				{
					setButtonReceiveTrue();
					var pAlertContent = "<spring:message code='ezApprovalG.t486'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
			}
			
			//회송
			function btnReturn_onclick() 
			{
				var parameter = new Array();
			    parameter[0]	= pDocID;
			    parameter[1]  = "HeSong";
			    parameter[2]  = KuyjeType;
				parameter[3]  = ""; 
			
				var url			= "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion_Cross.aspx";
				var feature = "status:no;dialogWidth:530px;dialogHeight:520px;help:no;edge:sunken;scroll:no";
				
				feature =  feature + GetShowModalPosition(530, 520);
				var ret = window.showModalDialog(url,parameter,feature);
				if(ret != "cancel")
				{
					setButtonReceiveTrue();
					setHeSongDocInfo();
				}
			}
			
			function btnMail_onclick()
			{
			}
			
			
			var tempSecurity = "";
			var tempKeep = "";
			var tempUrgent = "N";
			var tempPublic = "Y";
			var tempKeyword = "";
			var tempItemCode = "";
			var tempItemName = "";
			
			function btnDocInfo_onclick()
			{
				var parameter	= new Array();
				parameter[0]  = pDocID;
				parameter[1]  = "ING";
				parameter[2]  = tempKeep;				// pkeeperiod
				parameter[3]  = tempSecurity;				// psecuritylevel
				parameter[4]  = tempUrgent;			// pUrgentFlag
				parameter[5]  = tempPublic;			// pPublicFlag
				parameter[6]  = tempKeyword;			// tempKeyword
				parameter[7]  = tempItemCode;			// tempItemCode
				parameter[8]  = tempItemName;			// tempItemName
				
				var url			= "../ezDocInfo/ezDocInfo.aspx?arr1=" + escape(tempKeep) + "&arr2="+escape(tempSecurity);
				var feature	= "status:no;dialogWidth:370px;dialogHeight:535px;help:no;scroll:no;edge:sunken";
					 	
				feature =  feature + GetShowModalPosition(370, 535);
				var ret = window.showModalDialog(url,parameter,feature);
				
				if (ret[0] == "OK")
				{
					tempKeep = ret[1];
					tempSecurity = ret[2];
					tempUrgent = ret[3];
					tempPublic = ret[4];
					tempKeyword = ret[6];
					tempItemCode = ret[7];
					tempItemName = ret[8];
					tempItemName2 = ret[9];
					SetDocOption(ret[5]);
				}	
			}
			
			function SetDocOption(tempSecurityValue)
			{
				var fields = message.GetFieldsList();
			    
				//reckeepperiod		
			    field = message.GetListItem(fields, "keepperiod");
			    if(field)
					field.textContent = tempKeep;
			
			    field = message.GetListItem(fields, "securitylevel");
			    if(field)
					field.textContent = tempSecurityValue;
			
			    field = message.GetListItem(fields, "publication");
			    if(field)
			    {
					if (tempPublic == "N")
						field.textContent = "<spring:message code='ezApprovalG.t49'/>";
					else
						field.textContent = "<spring:message code='ezApprovalG.t50'/>";
				}
			}
			
			function btnHTML_onclick()
			{
				if (message.GetListItem(fields, "body"))
				{
					//CKEDITOR
					var parameter = message.GetListItem(fields, "body").innerHTML;
					var url = "../ezDocInfo/HtmlEditor.aspx";
					var feature = "status:no;dialogWidth:800px;dialogHeight:600px;edge:sunken;scroll:no";
					
				    feature =  feature + GetShowModalPosition(800, 600);
					var ret = window.showModalDialog(url,parameter,feature);
					
					if (ret != "cancel")
					{
						message.GetListItem(fields, "body").innerHTML = ret;
					}
				}
			}
			
			//20110207 문서번호 채번후 연동 실패시에도 문서번호 롤백이 되어야 한다.
			function RollbackNum()
			{  
			    if(docAccess > 0)
			   {		
			        if(docAccess > 1)	        
				        rollbackDocNumber(arr_userinfo[4],"");
				    else
				        rollbackDocNumber(arr_userinfo[4],"be"); 
				        
				    docAccess = 0;
				    if(fractionsymbol == "")
				    {
					    var pAlertContent = "[<spring:message code='ezApprovalG.t31'/><br> <spring:message code='ezApprovalG.t30'/>";
					    OpenAlertUI(pAlertContent);
					    return;				
				    }
			    }
				   
			}
		    var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo(pGubun) {
		        var onlydocinfiview = false;
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "9999999999";;
		        parameter[2] = SignCount;
		        parameter[3] = SignInfo;
		        parameter[4] = hapyuiCount;
		        parameter[5] = DraftFlag;
		        parameter[6] = pSuSinFlag;
		        parameter[7] = pChamJoFlag;
		        parameter[8] = gongramCount;
		        parameter[9] = false;
		        parameter[10] = pDocType;
		        parameter[11] = "";
		        parameter[12] = "";
		        parameter[13] = DraftFlag;
		        //parameter[17] = AprLineArea;
		        //parameter[18] = HapyuiArea;
		        parameter[28] = onlydocinfiview;
		        //parameter[30] = cabinetID; // 기록물철
		        //문서 정보 추가
		        parameter[31] = tempSecurity;
		        parameter[32] = tempUrgent;
		        parameter[33] = pSummery;
		        parameter[34] = pSpecialRecordCode;
		        parameter[35] = pPublicityCode;
		        //parameter[36] = pLimitRange;
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
		            var savexmlhttp = createXMLHttpRequest();
		            //결재선 저장
		            if (ret[1] != false) {
		                savexmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
		                savexmlhttp.send(ret[1]);
		
		                var dataNodes = GetChildNodes(savexmlhttp.responseXML);
		                //var ret = getNodeText(dataNodes[0]);
		                //결재선 저장 후
		                IsSkipDrafter = "FALSE";
		                btnSendDraftEnable = "true";
		                GetDraftAprLineInfo(ret);
		            }
		        }
		        SummaryFlag = true;
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
	<body class="popup" style="height:100%">
		<table class="layout" >
		  <tr>
		    <td style="height:20px"><div id="menu">
		        <ul>
		          <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo('9')" ><spring:message code="ezApprovalG.t1742"/></span></li>
		          <span style ="display:none" ><li id="btnSetAprLine"> <span onclick="return btnSetAprLine_onclick()" ><spring:message code='ezApprovalG.t153'/></span></li></span>
		          <li id="btnSendDraft"> <span onclick="return btnSendDraft_onclick()" ><spring:message code='ezApprovalG.t156'/></span></li>
		          <span style ="display:none" ><li id="btnDocInfo" style="display:none;"> <span onclick="return btnDocInfo_onclick()"  ><spring:message code='ezApprovalG.t54'/></span></li></span>
		          <li id="btnOpinion"> <span onclick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		          <li id="btnServerSave" style="display:none;"> <span onclick="return btnServerSave_onclick()" ><spring:message code='ezApprovalG.t59'/></span></li>
		          <li id="btnPrint"> <span onclick="return btnPrint_onclick()" ><spring:message code='ezApprovalG.t60'/></span></li>
		          <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		          <li id="btnClose" ><span onclick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
		        </ul>
		      </div>
		      <script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			  </script>
		    </td>
		  </tr>
		  <tr>
		    <td  style=" padding-bottom:10px; height:88%" >
		        <table style="height: 100%; width: 100%">
		            <tr>
		                <td style="vertical-align: top; height: 100%" id="form1">
		                    <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="recevContent.do" name="message" style="padding: 0; height: 100%; width: 100%; overflow: auto; border: none"></iframe>
		                </td>
		            </tr>
		            <tr>
		                <td style="vertical-align: top;">
		                    <iframe id="message2" name="message2" src="recevContent2.do" style="background-color: White; height: 0px; width: 0px; border: none"></iframe>
		                </td>
		            </tr>
		        </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="height:20px">
		        <table class="file">
		            <tr>
		              <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
		              <td ><div id="lstAttachLink"></div></td>
		            </tr>
		        </table>
		    </td>
		  </tr>
			<input type="file" id="pFile" style="display:none;" />	
		</table>
		<XML ID="ATTACHINFO"></XML>
		<XML ID="DOCINFO"></XML>
		<XML ID="APRLINEINFO"></XML>
		<XML ID="PREVNEXTDOCINFO"></XML>
		<div id="AprMemberSN" style="display:none"></div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>