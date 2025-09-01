<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML>
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t1308'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/docnumberG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Recvdocnumber_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Recev_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/signSplit_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
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
			var RootURL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port;  
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
			var _USE_DirectSign = "<c:out value='${useDirectSign}'/>";    //20090112 직접서명
			
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
			var approvalFlag = "${approvalFlag}";
			var junGyulFlag = "${junGyulFlag}";
			var pSignImage_Size = "${signImageSize}";
			var docNumZeroCnt = "${docNumZeroCnt}";
			var curDocNum = "";
			var draftDeptID = "${draftDeptID}";
			var orgCompanyID = "${userInfo.companyID}";
			var ext = "mht";
			var isHWP = "";
			var signImageType = "<c:out value ='${signImageType}'/>";
			
			var isReDraft = '${isReDraft}';

            var useOpenGov = "<c:out value='${useOpenGov}' />";
			var basis = "", reason = "", listOpenFlag = "", fileOpenFlagList = "", limitDate="";
			//부서순차합의를 위해 아래 파라미터 추가. 2019-02-08 홍대표
			//최종결재시 채번
			var useReceiveDocNo = "${useReceiveDocNo}";
			var nonElecRec = "${nonElecRec}";
			
			//부서감사 관련 2020-01-14 홍대표
			var deptgamsaCount = 0;
			
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var upperDeptName = "<c:out value ='${upperDeptName}'/>";
			
			// 창마다 고유한 id 지정용
			var windowUuid = getRandomId();
			var ReturnFunction;

			window.onload = function () {
				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
				
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
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
			                    if (pAprState == "006") {
			                        pInformationContent = "<spring:message code='ezApprovalG.t124'/><br> <spring:message code='ezApprovalG.t125'/>";
			                    } else {
			                        pInformationContent = "<spring:message code='ezApprovalG.t126'/><br> <spring:message code='ezApprovalG.t125'/>";
			                    }
			                    
			                    Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
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
			                    Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
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
			                    Ans = OpenInformationUI(pInformationContent, CheckOpinionYN_complete);
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
			        showAlert(e.description);
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
			  }catch(e){  
			    showAlert("setAutoProperty : " +e.description);    
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
			
			    if (GetNamedItem(document.getElementById('message'), "keepperiod")) {
		            if (GetNamedItem(document.getElementById('message2'), "keepperiod")) {
		                if (GetNamedItem(document.getElementById('message'), "keepperiod").options != undefined) {
		                    for (var i = 0; i < GetNamedItem(document.getElementById('message'), "keepperiod").options.length ; i++) {
		                        if (GetNamedItem(document.getElementById('message2'), "keepperiod").innerHTML == GetNamedItem(document.getElementById('message'), "keepperiod").options[i].innerHTML)
		                            GetNamedItem(document.getElementById('message'), "keepperiod").options.textContent = CKediter_Trim(GetNamedItem(document.getElementById('message'), "keepperiod").options[i].textContent);
		                    }
		                }
		
		                var a = GetNamedItem(document.getElementById('message2'), "keepperiod").innerHTML;
		                var re = new RegExp("&nbsp;", "gi");
		                var b = a.replace(re, "");
		                var c = parseInt(b);
		
		                if (!isNaN(c))
		                    GetNamedItem(document.getElementById('message'), "keepperiod").options.textContent = c;
		                else
		                    GetNamedItem(document.getElementById('message'), "keepperiod").textContent = "<spring:message code='ezApprovalG.t1692'/>";
		            }
		        }
			    
			    if (message.GetListItem(fields, "docnumber")) {
			        if (message2.GetListItem(fields2, "docnumber")) {
			            message.GetListItem(fields, "docnumber").innerHTML = message2.GetListItem(fields2, "docnumber").innerHTML;
			        }
			    }
			
			    var lastKyulName = "";
			    lastKyulName = message.GetAttribute('lastKyulName');
			    if (lastKyulName) {
			        lastKyulName = lastKyulName + "(" + message.GetAttribute('astKyuljikwee') + ")";
			        if (message.GetListItem(fields, "lastKyulName"))
			            message.GetListItem(fields, "lastKyulName").textContent = lastKyulName;
			    }

				var xmlInfo = message2.getConnInfoXml();
				if (xmlInfo) {
					var wrapper = document.createDocumentFragment();
					wrapper.appendChild(xmlInfo);
					message.setXmlInfo(wrapper);
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
				connInit();
			}
			
			//웹에디터 교체 -> 기존 : pzFormProc2_FieldsAvailable
			
			
			// 결재선지정 버튼 선택시 처리함수
			function btnSetAprLine_onclick() {
				var ret = openAprLineUI();
				if(ret[3] != "" && ret[3] != "cancel") 
					pPublic = ret[3];
				if (ret[0] != "cancel" && ret[3] != "cancel")
				{	   
					IsSkipDrafter = "FALSE";			  
					document.getElementById('btnSendDraft').Enable = "true";

					if (approvalFlag == "S") {
	                    SGetDraftAprLineInfo(ret);
                    } else {
	                    GetDraftAprLineInfo(ret);
                    }
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
		                    //if ("${approvalPWD}" != "N") {
		                    if (CheckUsePassword()) {
		                        chk_Passwd();
		                    }
		                    else {
		                        check_skipdraft();
		                    }
		                }
		            }
		        }
		        catch (e) {
		            showAlert("btnSendDraft_onclick : " + e.description);
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
		                RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
		                if (!RtnVal) {
		                    return;
		                }
		                if (RtnVal) 
		                	RtnVal = SaveDraftDocInfo();
		                
		                if (RtnVal == "TRUE") {
		                    RtnVal = setSusinUpdataDocID();
		                    RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
		                    if (!RtnVal) {
		                        return;
		                    }
		                    if (LastSignSN == 1 || DraftLastFlag) {
		                        RtnVal = ExcuteInfo("DOCNUM_END");
		                        if (!RtnVal) {
									RollbackNum();
		                            return;
		                        }
		
		                        //불필요한 로직 주석처리. 닷넷 동일. 2020-02-05 홍대표.
// 		                        if (pDraftFlag == "HAPYUI") {
// 		                        	LastHapyui();
// 		                        }
		
		                    }
		                    else {
		                    	 sendAlertMail("APR", "1", "RECEV");
		                    }
		                    pAlertContent = "<spring:message code='ezApprovalG.t1496'/>";
		                    OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		                    return;
		                }
		                else {
		                    UndoSignInfo(rtnSignInfo);
							RollbackNum();
		                    if (LastSignSN == 1 || DraftLastFlag) {
		                        RtnVal = ExcuteInfo("END_FAIL");
		                        if (!RtnVal) {
		                            return;
		                        }
		                    }
		                    pAlertContent = "[<spring:message code='ezApprovalG.t1495'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
						RollbackNum();
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("END_FAIL");
		                    if (!RtnVal) {
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
		            var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE");
		            var pAlertContent;
		            if (!RtnVal) {
		                RollbackNum();
		                return;
		            }
		            RtnVal = SaveDraftDocInfo();
		            if (RtnVal == "TRUE") {
		                RtnVal = ExcuteInfo("DRAFTSAVE_AFTER");
		                if (!RtnVal) {
		                    RollbackNum();
		                    return;
		                }
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("DOCNUM_END");
		                    if (!RtnVal) {
		                        RollbackNum();
		                        return;
		                    }
		                    sendAlertMail("END", "1", "RECEV");
		                }
		                else {
		                	sendAlertMail("APR", "1", "RECEV");
		                }
		                pAlertContent = "<spring:message code='ezApprovalG.t1496'/>";
		                OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		            }
		            else {
		                UndoSignInfo(rtnSignInfo);
		                if (LastSignSN == 1 || DraftLastFlag) {
		                    RtnVal = ExcuteInfo("END_FAIL");
		                    if (!RtnVal) {
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
		
		    function openSignUI_Complete(ret) {
		        if (ret == "cancel") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t145'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        pOrgHtml = ConvertHTMLtoMHT(message.Get_EditorBodyHTML());
		        if (LastSignSN == 1 || DraftLastFlag) {
		            var rtnVal;
		            rtnVal = ExcuteInfo("DOCNUM_BEFORE");
		            if (!rtnVal) {
		                return;
		            }
		        }
		        
		        if (LastSignSN == 1 || DraftLastFlag)
		            rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
		        else
		            rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
		
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
		                rtnval = getDocNumberNew(arr_userinfo[4], "", docNumZeroCnt);
		                if (rtnval) docAccess = 2; 
		            }
		            else {
		                rtnval = getDocNumberNew(arr_userinfo[4], "be", docNumZeroCnt);
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
		            rtnVal = ExcuteInfo("DOCNUM_AFTER");
		            if (!rtnVal) {
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
		        check_skipdraft();
		    }
		
		    function CheckAprLine(Ans) {
		        DivPopUpHidden();
		        if (Ans) {
		            //기록물철 선택과정에서 버그가 있어 파라미터를 14로 수정. 2019-03-12 홍대표
		        	btnApprovalInfo("15");
		            return;
		        }
		        else {
		            return;
		        }
		    }
			
			// 첨언창 오픈 함수
			function btnOpinion_onclick()
			{
				//var ret = openOpinionUI("N");
				openOpinionUI_New("");
			}
			
			//프린트 
			var PrtBodyContent;
			function btnPrint_onclick() {
			    PrintClick("Cross", pDocID, "");
			}
			
			
			// 종료
			// function btnClose_onclick()
			// {
			// 	window.close();
			// }
			window.onbeforeunload = function () {
				try{
					window.opener.openergetDocInfo();
				}catch(e){
					window.parent.openergetDocInfo();
				}
				// try{
				// 	window.opener.Refresh_Window();
				// }catch(e){ }
			};
			
			//유효한 문서가 아닌경우 
			function pzFormProc_InvalidDocument()
			{
				var pAlertContent = "<spring:message code='ezApprovalG.t12'/>";
			    OpenAlertUI(pAlertContent);
				FormProc.FileNew();
			}
			
			//지정
			function btnAssign_onclick() {
				var parameter = new Array();
				parameter[0] = pDocID;						//문서ID
				parameter[1] = pSusinSN;					//수발신SN
				parameter[2] = pAprState;					//결재상태
			  
				var url = "/ezApprovalG/ezReceiveAssignUI.do";
				var feature = "status:no;dialogWidth:800px;dialogHeight:600px;edge:sunken;scroll:no";
				 	
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
			var tempItemName2 = "";
			
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
				var feature	= "status:no;dialogWidth:370px;dialogHeight:555px;help:no;scroll:no;edge:sunken";
					 	
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
		    // var ezapprovalinfo_dialogArguments = new Array();
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
// 		        parameter[17] = AprLineArea;
// 		        parameter[18] = HapyuiArea;
		        parameter[20] = tempKeep;
		        parameter[28] = onlydocinfiview;
		        parameter[29] = TaskCode;
		        parameter[30] = cabinetID; // 기록물철
		        //문서 정보 추가
		        parameter[31] = tempSecurity;
		        parameter[32] = tempUrgent;
		        parameter[33] = pSummery;
		        parameter[34] = pSpecialRecordCode;
		        parameter[35] = pPublicityCode;
		        parameter[36] = pLimitRange;
		        parameter[37] = pPageNum;
		        parameter[38] = tempSecurityDate;
		        parameter[39] = SummaryFlag;
		        parameter[41] = tempItemName;
		        parameter[42] = tempItemName2;
		        parameter[43] = deptgamsaCount;
		        
		        if(pDocState == "012" || pDocState == "014") {
		        	parameter[45] = "";
		        	parameter[46] = "";
		        }
		        
		        if (useOpenGov == "YES") {
			        parameter[52] = basis;
			        parameter[53] = reason;
			        parameter[54] = listOpenFlag;
			        parameter[55] = fileOpenFlagList;
    		        parameter[56] = limitDate;
		        }

		        parameter[61] = tempKeyword;
		        
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		
		        // ezapprovalinfo_dialogArguments[0] = parameter;
		        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;		
				//
		        // var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&docType=" + pDocType, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750));
				//
		        // try { OpenWin.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = parameter;
				showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&docType=" + pDocType, 1210, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
		    }
		
		    function btnApprovalInfo_Complete(ret) {
				hidePopup();
		        if (ret != undefined && ret[0] == "OK") {
		            var savexmlhttp = createXMLHttpRequest();
		            //결재선 저장
		            if (ret[1] != false) {
		            	$.ajax({
                    		type : "POST",
                    		dataType : "text",
                    		async : false,
                    		url : "/ezApprovalG/aprLineSave.do",
                    		data : {
                    				ret    : ret[1]
                    				},
                    		success : function(result){
                    			
                    		}
                    	});
		            	
		                //var ret = getNodeText(dataNodes[0]);
		                //결재선 저장 후
		                btnSendDraftEnable = "true";

		                if (approvalFlag == "S") {
		                    SGetDraftAprLineInfo(ret);
	                    } else {
		                    GetDraftAprLineInfo(ret);
	                    }
		                
		                IsSkipDrafter = "FALSE";
		            }
		            
		            if (ret[4] != undefined) {
		                var g_SelCabXml = ret[4];
		                var xmlCab = createXmlDom();
		                xmlCab = loadXMLString(g_SelCabXml);
		                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
		                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
	                }

					tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
		            tempSecurity = ret[7];
	                tempUrgent = ret[8];
	                pSummery = ret[9];
	                tempSecurityDate = ret[14];
	                pPublicityCode = ret[11];
	                pPublicityYN = ret[21];
	                
// 	                tempKeep = ret[16];
//                 	tempItemName = ret[17];
//                 	tempItemName2 = ret[18];
                	pPageNum = ret[13];
                	pLimitRange = ret[12];
                	pSpecialRecordCode = ret[10];
//                 	tempPublic = ret[11];
//                 	SetDocOption(ret[20]);
					if (nonElecRec == "Y") {
		            	nonElecRecInfoXml = ret[23];
		            	nonSepAttachLVXml = ret[24];
		            	g_szSCListXml = ret[25];
		            	sepAttachCheckYN = ret[26];
		            	setNonElecRecInfo_mht(nonElecRecInfoXml);
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
		        }

		        SummaryFlag = true;
		        
		        savexmlhttp = null;
		    }
		    
		    var apropinion_cross_dialogArguments = new Array();
		    var temppDocSN;
		    function btnReturn_onclick() {
		    	if (isReDraft == "Y" && checkAprState()) {
		    		showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
	    			// window.close();
	    			return;
		    	}
		    	
		        var RecevState = getDocRecevState();
		        if (RecevState != "011" && RecevState != "012" && RecevState != "014" && RecevState != "013") {
		            if (RecevState == "015") {
		                var pAlertContent = strLang912;
		                OpenAlertUI(pAlertContent);
		            }
		            return false;
		        }
		        
		        /* 2023-05-19 홍승비 - 개선된 의견 작성창을 사용하도록 회송 코드 수정, 합의문에서는 의미가 없는 pDocSN 체크 제외 */
		        /*
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
		        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
		        parameter[99] = ext;
		        
		        temppDocSN = pDocSN;
		        apropinion_cross_dialogArguments[0] = parameter;
		        apropinion_cross_dialogArguments[1] = btnReturn_onclick_Complete;
		
		        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
		        */
		        openOpinionUI_New("HeSong", btnReturn_onclick_Complete);
		    }
		    function btnReturn_onclick_Complete(ret) {
		        DivPopUpHidden();
		        var hesongok = true;
		        if (ret != "cancel") {
					if (checkAprState()) {
						showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
						// window.close();
						return;
					}

					var rtnVal = ExcuteInfo("HESONG_BEFORE");
					if (!rtnVal) {
						return;
					}

		            setButtonReceiveTrue();
		
		            // pDocSN, temppDocSN 값은 접수번호(receiptnumber) 필드가 없는 부서합의문에서 체크할 필요가 없음
		            // 수신접수 페이지에서 회송을 위해 사용되던 변수 및 코드가 그대로 복사된 것으로 추정되어 주석 처리함
		            /*if (temppDocSN != "") {
		                hesongok = setCabinetHeSong(temppDocSN);
					}*/

					if (hesongok) {
						var docInfo = document.getElementById("DOCINFO").dataSource;
						var writerID = SelectSingleNodeValueNew(docInfo, "DOCINFO/DATA/WRITERID");
						var writerName = SelectSingleNodeValueNew(docInfo, "DOCINFO/DATA/WRITERNAME");
						var docTitle = SelectSingleNodeValueNew(docInfo, "DOCINFO/DATA/DOCTITLE");
						SendMailToDrafter_Hesong(writerID, writerName, docTitle);
						hesongok = setHeSongDocInfo();

						if (hesongok) {
							ExcuteInfo("HESONG_AFTER");
						} else {
							ExcuteInfo("HESONG_FAIL");
						}
					} else {
						ExcuteInfo("HESONG_FAIL");
					}
		        }
		    }
		
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=APR");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
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
			    			docState : pDocState,
			    			userID : '',
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
		            showAlert("getDocRecevState :: " + e.description);
		        }
		    }
		    
	    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
	    	function setAttachGuideText() {
	    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                
                if(bigSizeAttachDownloadLimitCount > 0) {
                	attachGuideText += strLangHSBAt06 + " <span style='color:#FF0000 ;'>" + bigSizeAttachDownloadLimitCount + strLangHSBAt09 + "</span> " + strLangHSBAt10;
                }
                
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += "</td>";
/*                 
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt05 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadPeriod + "</span></td>";
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt06 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadDay + strLangHSBAt07 + "</span>" + strLangHSBAt08;
                 */
                 
                 if (bigSizeAttachDownloadLimitCount > 0) {
                	 document.getElementById("apprAttachGuideTR").innerHTML = attachGuideText;
                 }
                 else {
                	 document.getElementById("apprAttachGuideTR").style.display = "none";
                 }
	    	}

	    	function connInit() {
				var connRootText = GetDocumentElement("CONNROOT");
				if (connRootText) {
					if (DraftFlag === "REDRAFT") {
						OpenAlertUI("연동문서는 다시 접수할 수 없습니다.<br/>문서보기 창으로 이동합니다.", function() {
							var url = "/ezApprovalG/aprDocView.do" +
								"?docID=" + pDocID +
								"&docHref=" + pFormHref +
								"&opinionFlag=" + pHasOpinionYN +
								"&docState=" + pDocState +
								"&listSusin=" + arr_userinfo[1] +
								"&oDoc=" + pOrgDocID +
								"&isOpinion=OPINION_SHOW" +
								"&listType=1" +
								"&CallBackType=" +
								"&ext=mht" +
								"&orgCompanyID=" + orgCompanyID;

							window.open(url, "_self");
						});
						return;
					}

					if (ConnExist(["conn;processidx;INIT", "conn;processtime;HAPYUI", "query;qtype;UA"]) || ConnExist(["conn;processidx;INIT", "conn;processtime;HAPYUI", "query;qtype;UA_EX"])) {
						document.querySelector("#btnConn").style.display = "";
					}

					setTimeout(function() {
						ExcuteInfo("INIT");
					}, 0);
				}
			}

			function btnConn_onclick() {
				ExcuteInfo("INIT");
			}
	    	
			/* 2023-05-19 홍승비 - 최초 로딩 시 의견 존재여부 체크 후 의견 레이어 팝업 표출을 위한 함수 추가 */
			function CheckOpinionYN_complete(Ans) {
				DivPopUpHidden();
		    	if (Ans) {
					openOpinionUI_New("");
		        }
			}
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout" >
		  <tr>
		    <td style="height:20px"><div id="menu">
				<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
		        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
		          <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo('15')" ><spring:message code="ezApprovalG.t1742"/></span></li>
		          <li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
		          <span style ="display:none" ><li id="btnSetAprLine"> <span onclick="return btnSetAprLine_onclick()" ><spring:message code='ezApprovalG.t153'/></span></li></span>
		          <li id="btnSendDraft"> <span onclick="return btnSendDraft_onclick()" ><spring:message code='ezApprovalG.t156'/></span></li>
		          <li id="btnReturn"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
		          <span style ="display:none" ><li id="btnDocInfo" style="display:none;"> <span onclick="return btnDocInfo_onclick()"  ><spring:message code='ezApprovalG.t54'/></span></li></span>
		          <li id="btnOpinion"> <span onclick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		          <li id="btnServerSave" style="display:none;"> <span onclick="return btnServerSave_onclick()" ><spring:message code='ezApprovalG.t59'/></span></li>
				  <li id="btnConn" style="display:none"><span  onClick="return btnConn_onclick()"  ><spring:message code='ezApprovalG.t157'/></span></li>
		          <li id="btnPrint"> <span onclick="return btnPrint_onclick()" ><spring:message code='ezApprovalG.t60'/></span></li>
		          <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        </ul>
				<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
		        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
		        </ul>
		      </div>
		      <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
		        <ul>
		          <li id="btnClose" ><span onclick="return btnClose_onclick()"></span></li>
		        </ul>
		      </div>
		      <script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");				
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
		                    <iframe id="message2" name="message2" src="recevContentTwo.do" style="background-color: White; height: 0px; width: 0px; border: none"></iframe>
		                </td>
		            </tr>
		        </table>
		    </td>
		  </tr>
		  <tr>
		    <td style="height:20px">
	                <table class="file" style="height:80px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                        </td>
	                        <td style=" width:30%;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
							</td>
							<td class="pos2" style="width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
							</td>
	                    </tr>
	                </table>
	                
					<%-- 대용량첨부 가이드 메세지 영역 --%>
	                <table class="file" style="height: 20px;">
	                    <tr id="apprAttachGuideTR"></tr>
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
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="RECEIPTDEPTID" style="display: none"></div>
	</body>
</html>
