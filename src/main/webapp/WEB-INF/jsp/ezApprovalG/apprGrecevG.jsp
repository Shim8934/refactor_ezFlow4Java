<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t1308'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style>
			.IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
		</style>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Recvdocnumber_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/RecevG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/RecevIng_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		<script type="text/javascript"ID="clientEventHandlersJS">
		    var pWriterDeptID;
		    var pDocID = "<c:out value = '${docID}'/>";
		    var pFormHref = new String("");
		    var pFormID = new String();
		    var zFormID = new String();
		    var pUserID = "<c:out value = '${userInfo.id}'/>";
		    var pHasAttachYN = new String("N");
		    var pHasOpinionYN = new String("N");
		    var FormProc = null;
		    var CurrentDate;
		    var flag = false;
		    var fieldflag = false;
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
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
		    var pOrg_orgDocID = "<c:out value = '${orgDocID}'/>";
		    var chkOK = false;
		    var isReDraft = "<c:out value = '${isReDraft}'/>";
		    var LastSignNo;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
		    var btnSendDraftEnable = "false";
		    var gPublic = "";
		    var s_nCallCnt = false;
		    var sCompanyID   = "<c:out value = '${userInfo.companyID}'/>";
		    var cabinetID = "";
		    var TaskCode = "";
		    var pDocNumCode, pOrgDocNumCode, pDocNo;
		    var maxwidth = 659;
		    var RootURL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port;  
		    var arr_userinfo = new Array();
		    var retValue = "";
		    
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName1}'/>";
		    arr_userinfo[3]  = "<c:out value = '${userInfo.title1}'/>";
		    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName1}'/>";
		    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";
		    arr_userinfo[9]  = sCompanyID;
		    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}'/>";
		    var arrDelFiles = new Array();
		    var CurrYear = "<c:out value = '${dirYear}'/>";
		    var ConvertYN = "Y";
		    var isSplit = "<c:out value = '${optIsSplit}'/>";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pLimitRange = "", pPageNum = "1";
		    var SummaryFlag = false;
		    var pGubun;
		    var xmluserInfo = createXmlDom();
		    var g_DraftFlag = "<c:out value = '${draftFlag}'/>";
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var arrDelFiles = new Array();
		    var junGyulFlag = "<c:out value = '${junGyulFlag}'/>";
			var dirPath = "<c:out value = '${approvalROOT}'/>";
			var ext = "hwp";
			var approvalFlag = "<c:out value = '${approvalFlag}'/>";
			var orgCompanyID = ""
			
			//유통문서 접수를 위해 추가.
			var useReceiveDocNo = "<c:out value = '${useReceiveDocNo}'/>";
			var docNumZeroCnt = "<c:out value = '${docNumZeroCnt}'/>";
		    var nonElecRec = "<c:out value = '${isNonElecRec}'/>";
		    var nonElecRecInfoXml = "", nonSepAttachLVXml = "", g_szSCListXml = "", sepAttachCheckYN = "";
		    var pSusinAdmin = "<c:out value = '${susinAdmin}'/>";
		    
			var useRedraftOpinionKeep = "<c:out value='${useRedraftOpinionKeep}'/>";

			// 문서정보 조회시 사용됨.
			var orgCompanyID_ = "<c:out value = '${orgCompanyID}'/>";

			var isRelay = GetRelayDocInfo(); // 중계문서인지의 여부를 true/false로 반환;

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";
			var allowDeptIDs = "<c:out value ='${allowDeptIDs}'/>"
			var ReturnFunction;

            var isPreview = "<c:out value ='${isPreview}'/>";

			$(function () {
				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
			});
			
		    function process_AfterOpen() {
		        try {
		            if (pFormHref == "") {
		                GetAprDocFormID();
		                setAttachInfo(pDocID, "APR", lstAttachLink);
		                getDocInfo();
		                GetExchInfo();
		            }
		            else {
		                if (pDraftFlag == "REDRAFT") {
		                    var len;
		                    var pInformationContent;
		                    var Ans;
		
		                    len = pFormHref.lastIndexOf("/");
		                    pDocID = pFormHref.substr(len + 1, 20);
		                    GetAprDocFormID();
		                    setAttachInfo(pDocID, "APR", lstAttachLink);
		                    getDocInfo();
		                    GetExchInfo();
		                    if (pHasOpinionYN == "Y") {
		                        if (pAprState == "006")
		                            pInformationContent = "<spring:message code='ezApprovalG.t124'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        else
		                            pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		
		                        Ans = OpenInformationUI(pInformationContent);
		                        if (Ans) {
		                            openOpinionUI("Display");
		                        }
		                    }
		                }
		                else {
		                    var len;
		                    len = pFormHref.lastIndexOf("/");
		
		                    GetAprDocFormID();
		                    setAttachInfo(pDocID, "APR", lstAttachLink);
		                    getDocInfo();
		                    GetExchInfo();
// 		                    if (pHasOpinionYN == "Y") {
// 		                        var pInformationContent;
// 		                        var Ans;
// 		                        pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
// 		                        Ans = OpenInformationUI(pInformationContent);
		
// 		                        if (Ans) {
// 		                            openOpinionUI("Display");
// 		                        }
// 		                    }
		                }
		            }
		        } catch (e) {
		            showAlert("process_AfterOpen : " + e.description);
		        }
		    }
		    function setAutoProperty() {
		        try {
		            SetAutoPropertyValue();
		        } catch (e) {
		            showAlert("setAutoProperty : " + e.description);
		        }
		    }
		
		    function setProperty() {
		        try {
		            getDraftUserInfo();
		            SetPropertyValue();
		
		            var rtnVal = ExcuteInfo("INIT", "");
		            if (!rtnVal) {
		            }
		        } catch (e) {
		            showAlert("setAutoProperty : " + e.description);
		        }
		    }
		
		    function FieldsAvailable() {
	            if (isRelay) {
	            	document.getElementById("btnReqReSend").style.display = ""; 
	            }
	            
		        if (ConvertYN == "N") {
		            pGubun = "11";
		            setProperty();
		            process_AfterOpen();
		            CheckOpinionYN();
		            document.getElementById('form2').style.display = "none";
		
		            if (SignCount < 1) {
		                pGubun = "12";
		                //document.getElementById("btnSetAprLine").style.display = "none";
		                document.getElementById("btnSendDraft").style.display = "none";
		                document.getElementById("btnRJunkyul").style.display = "none";
		                document.getElementById("btntotaldocinfo").style.display = "none";
		            }
		        }
		    }
		    
		    function CheckOpinionYN() {
		        if (pHasOpinionYN == "Y") {
		            var pInformationContent = "<spring:message code='ezApprovalG.t9'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		            OpenInformationUI(pInformationContent, CheckOpinionYN_Complete);
		        }
		    }
		    function CheckOpinionYN_Complete(Ans) {
		        DivPopUpHidden();
		        if (Ans)
		            //openOpinionUI("", CheckOpinionYN_Complete_Complete);
		        	openOpinionUI_New("", CheckOpinionYN_Complete_Complete);
		    }
		
		    function CheckOpinionYN_Complete_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "Clear") {
					pHasOpinionYN = "N";
				} else if (ret == "cancel") {
					//do_nothing
				} else {
			        var objXML = createXmlDom();
			        objXML = loadXMLString(ret);
			        
			        var NodeList = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
			        if (NodeList.length != 0) {
			            pHasOpinionYN = "Y";
			        } else {
			            pHasOpinionYN = "N";
			        }
				}
		    }
		    
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		            IsSkipDrafter = "TRUE";
		
		            getReceiveDocInfo();
		            DocumentComplete2();
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
		            else if (pRelayURL != "") {
		                message.Set_EditorContentURL(pRelayURL);
		                var reVal = GetRelayDocInfo();
		                if (!reVal) {
		                    return;
		                }
		                var tempFlag = getExtInfo();
		                if (tempFlag) {
		                    pGubun = "11";
		                    setProperty();
		                    setAutoProperty();
		                    // updateReceivedDept();
		                }
		            }
		        }
		        
		        //재배부 요청 버튼 보이는 함수. 2020-04-23 홍대표.
		        setBtnEnable();
		        
		        // 문서과에서 접수 후 반송했을 때, 배부버튼이 보이지 않도록 처리하는 부분.
	            if (g_DraftFlag == "REDRAFT" && pDraftFlag == "SUSIN") {
	                setMenuBar("btnDistribute", false);
	            }
		        
		        setProperty();
		        setAutoProperty();
		        document.getElementById('form2').style.display = "none";
		
		        if (SignCount < 1) {
		            pGubun = "12";
		            document.getElementById("btnSendDraft").style.display = "none";
		            document.getElementById("btnRJunkyul").style.display = "none";
		            document.getElementById("btntotaldocinfo").style.display = "none";
	                // 사인칸이 없을 때만, 편철 버튼 보이도록 수정. 닷넷참고.
		            document.getElementById("btnCabinet").style.display = "";
		        }
		        
		        ClearDocCellInfo(); // 재배부시 문서 결재선 초기화
		    }
		    function FieldsAvailable2() {
		        setAutoProperty();
		        var message2FildList = GetFieldsList(document.getElementById('message2'));
		
		        if (GetNamedItem(document.getElementById('message'), "body")) {
		            if (GetNamedItem(document.getElementById('message2'), "body")) {
		                GetNamedItem(document.getElementById('message'), "body").innerHTML = GetListItem(message2FildList, "body").innerHTML;
		            }
		        }
		        if (GetNamedItem(document.getElementById('message'), "doctitle")) {
		            if (GetNamedItem(document.getElementById('message2'), "doctitle")) {
		                GetNamedItem(document.getElementById('message'), "doctitle").innerHTML = CKediter_Trim(GetNamedItem(document.getElementById('message2'), "doctitle").innerHTML);
		                var doctitle = GetNamedItem(document.getElementById('message'), "doctitle").textcontent;
		            }
		        }
		        if (GetNamedItem(document.getElementById('message'), "publication")) {
		            if (GetNamedItem(document.getElementById('message2'), "publication")) {
		                GetNamedItem(document.getElementById('message'), "publication").textContent = CKediter_Trim(GetNamedItem(document.getElementById('message2'), "publication").innerText);
		                var publication = GetNamedItem(document.getElementById('message'), "publication").textContent;
		            }
		        }
		        if (GetNamedItem(document.getElementById('message'), "department")) {
		            if (GetNamedItem(document.getElementById('message2'), "department")) {
		                GetNamedItem(document.getElementById('message'), "department").innerHTML = CKediter_Trim(GetNamedItem(document.getElementById('message2'), "department").innerHTML);
		                var department = GetNamedItem(document.getElementById('message'), "department").textContent;
		            }
		        }
		        if (GetNamedItem(document.getElementById('message'), "position")) {
		            if (GetNamedItem(document.getElementById('message2'), "position")) {
		                GetNamedItem(document.getElementById('message'), "position").innerHTML = CKediter_Trim(GetNamedItem(document.getElementById('message2'), "position").innerHTML);
		                var position = GetNamedItem(document.getElementById('message'), "position").textContent;
		            }
		        }
		        if (GetNamedItem(document.getElementById('message'), "telephone")) {
		            if (GetNamedItem(document.getElementById('message2'), "telephone")) {
		                GetNamedItem(document.getElementById('message'), "telephone").innerHTML = CKediter_Trim(GetNamedItem(document.getElementById('message2'), "telephone").innerHTML);
		                var position = GetNamedItem(document.getElementById('message'), "telephone").textContent;
		            }
		        }
		        if (GetNamedItem(document.getElementById('message'), "draftername")) {
		            if (GetNamedItem(document.getElementById('message2'), "draftername")) {
		                GetNamedItem(document.getElementById('message'), "draftername").innerHTML = CKediter_Trim(GetNamedItem(document.getElementById('message2'), "draftername").innerHTML);
		                var draftername = GetNamedItem(document.getElementById('message'), "draftername").textContent;
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
		                    GetNamedItem(document.getElementById('message'), "keepperiod").textContent = "<spring:message code='ezApprovalG.t776'/>";
		            }
		        }
		        var lastKyulName = "";
		        lastKyulName = message.GetAttribute('lastKyulName');
		        if (lastKyulName) {
		            lastKyulName = lastKyulName + "(" + message.GetAttribute('astKyuljikwee') + ")";
		            if (GetNamedItem(document.getElementById('message'), "lastKyulName"))
		                GetNamedItem(document.getElementById('message'), "lastKyulName").textContent = lastKyulName;
		        }
		        document.getElementById('form2').style.display = "none";
		        process_AfterOpen();
		        CheckOpinionYN();
		    }
		    function DocumentComplete2() {
		        var URL = encodeURI(pFormHref);
		        try {
		   	    	var html = "";
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : { href: URL },
						success: function(result){
							html = result;
						}
					});
					
					var doc = document.getElementById('message2').contentWindow.document;
					doc.open();
					doc.write(html);
					doc.close();
					var message2 = $('message2'); 
					message2.html(html);
					FieldsAvailable2();
		   	    } catch (e) {
		   	        showAlert(e.description);
		   	    }
		        // document.getElementById('message2').src = "/ezCommon/mhtToHTMLContent.do?href=" + URL;
		        // document.getElementById('message2').setAttribute("onload", "javascript:FieldsAvailable2();");
		    }
		    function btnFileAttach_onclick() {
		        var ret = openFileAttachUI();
		    }
		    function btnAprDocAttach_onclick() {
		        var ret = openAaprDocAttachUI();
		    }
		    function btnOpinion_onclick() {
		        //var ret = openOpinionUI("N");
		    	openOpinionUI_New("");
		    }
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "");
		    }
		    // function btnClose_onclick() {
		    //     window.close();
		    // }
		    window.onbeforeunload = function () {
                if (isPreview != "Y") {
                    try {
                        window.opener.openergetDocInfo();
                    }
                    catch (e) {
                        window.parent.openergetDocInfo();
                    }
                }
		
		        // try {
		        //     window.opener.Refresh_Window();
		        // }
		        // catch (e) { }
		    };
		    function pzFormProc_InvalidDocument() {
		        var pAlertContent = "<spring:message code='ezApprovalG.t123'/>";
		        OpenAlertUI(pAlertContent);
		        FormProc.FileNew();
		    }
		    var ezreceivedistributeui_cross_dialogArguments = new Array();
		    function btnDistribute_onclick() {
		    	var deptCheckFlag = checkDeptAndCabinetId();
		    	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	}
		    	
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = arr_userinfo[4];
		        parameter[3] = pAprState;
		        parameter[4] = RECEIPTDEPTID.innerText;
		
		        ezreceivedistributeui_cross_dialogArguments[0] = parameter;
		        ezreceivedistributeui_cross_dialogArguments[1] = btnDistribute_onclick_Complete;
		
		        DivPopUpShow(800, 600, "/ezApprovalG/ezReceiveDistributeUI.do");
		    }
		    function btnDistribute_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "true") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1419'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        }
		    }
		    function OpenAlertUI_Close() {
		        window.close();
		    }
		    var ezreceiveassignui_cross_dialogArguments = new Array();
		    function btnAssign_onclick() {
		    	var deptCheckFlag = checkDeptAndCabinetId();
		    	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	}
		    	
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = pAprState;
		
		        ezreceiveassignui_cross_dialogArguments[0] = parameter;
		        ezreceiveassignui_cross_dialogArguments[1] = btnAssign_onclick_Complete;
		
		        DivPopUpShow(800, 600, "/ezApprovalG/ezReceiveAssignUI.do");
		    }
		    function btnAssign_onclick_Complete(ret) {
		        DivPopUpHidden();
		        if (ret == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1420'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		            return;
		        }
		    }
			function btnMail_onclick() {
 			    /*var feature = "height=700,width=690,resizable=yes,scrollbars=no";
				feature = feature + GetOpenPosition(690, 700);
				window.open("/myoffice/ezEmail/newmail_CK.aspx?cmd=docsend&docID=" + "<c:out value = '${docID}'/>" + "&docHref=" + pFormHref, '', feature);*/

				// window.open("/ezEmail/mailWrite.do?docHref=" + pFormHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
				showPopup("/ezEmail/mailWrite.do?docHref=" + pFormHref + "&cmd=docsend&docID=" + pDocID + "&TARGET=APPROVALG", 1200, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1200, window.screen.availHeight * 0.8), hidePopup);
			}
		    
		    var selectcabinet_cross_dialogArguments = new Array();
		    function btnCabinet_onclick() {
		    	var deptCheckFlag = checkDeptAndCabinetId();
		    	
		    	if (deptCheckFlag == "3") {
		    		showAlert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		showAlert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	}
		    	
		        var para = new Array();
		        para[0] = cabinetID;
		        var url = "/ezApprovalG/selectCabinet.do?initFlag=1";
		
		        selectcabinet_cross_dialogArguments[0] = para;
		        selectcabinet_cross_dialogArguments[1] = btnCabinet_onclick_Complete;
		
		        DivPopUpShow(1000, 620, "/ezApprovalG/selectCabinet.do?initFlag=1");
		    }
		
		    function btnCabinet_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            var g_SelCabXml = rtn[1];
		            var xmlCab = createXmlDom();
		            xmlCab = loadXMLString(g_SelCabXml);

		            cabinetID = getNodeText(SelectSingleNodeNew(xmlCab, "CABINETINFO/CABINET/CABINETID"));
		            TaskCode = getNodeText(SelectSingleNodeNew(xmlCab, "CABINETINFO/CABINET/TASKCODE"));
		        }
		
		        if (cabinetID != "") {
		        	LastSignSN = "1";
		        	getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
		        	setSusinUpdataDocID();
		
		         	$.ajax({
                		type : "POST",
                		dataType : "text",
                		async : false,
                		url : "/ezApprovalG/setRecvComplete.do",
                		data : {
        		            tempDocID : pDocID,
        		            tempDocNo : pDocNo,
        		            tempDocNumCode : pDocNumCode,
        		            tempOrgDocNumCode : pOrgDocNumCode,
        		            tempCabinetID : cabinetID,
        		            tempTaskCode : TaskCode,
        		            tempUserID : pUserID,
        		            tempUserName : arr_userinfo[11],
        		            tempDeptID : arr_userinfo[4],
        		            tempTitle : arr_userinfo[3],
        		            tempDeptName : arr_userinfo[5],
        		            tempCompanyID : arr_userinfo[9],
        		            tempUserName2 : arr_userinfo[12],
        		            tempTitle2 : arr_userinfo[14],
        		            tempDeptName2 : arr_userinfo[16]
                		},
                		success : function(result){
	               			 if (result == "TRUE") {
	       		                var pAlertContent = "<spring:message code='ezApprovalG.t1693'/>";
	       		                OpenAlertUI(pAlertContent, OpenAlertUI_Close);
	        		         } else {
	       		                var pAlertContent = "<spring:message code='ezApprovalG.t1694'/>";
	       		                OpenAlertUI(pAlertContent);
	        		         }
                		}, 
                		error : function () {
                			var pAlertContent = "<spring:message code='ezApprovalG.t1694'/>";
       		                OpenAlertUI(pAlertContent);
                		}
                	});
		        }
		    }
		    
		    function btnReAssign_onclick() {
		        var ret = openOpinionUI("BanSong");
		        if (ret != "cancel" && ret != undefined) {
		            var xmlpara = createXmlDom();
		            var xmlhttp = createXMLHttpRequest();
		
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
		            createNodeAndInsertText(xmlpara, objNode, "pReceivSN", pSusinSN);
		            createNodeAndInsertText(xmlpara, objNode, "pProcessorID", pUserID);
		
		            xmlhttp.open("Post", "aspx/setReJijung.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            if (xmlhttp.responseText == "TRUE") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1425'/>";
		                OpenAlertUI(pAlertContent);
		                btnClose_onclick();
		            }
		        }
		    }
		    function btnReDistribute_onclick() {
		        var ret = openOpinionUI_New("ReBebu", openOpinionUI_Distribute_Complete);
		    }
		    
	        function btnReDistribute_onclick_complete() {
	        	$.ajax({
                    type : "POST",
                    dataType : "text",
                    async : false,
                    url : "/ezApprovalG/setReBebu.do",
                    data : {
						docID : pDocID,
						receiveSN : pSusinSN,
						deptID : arr_userinfo[4],
                    },
                    success : function(text){
						result = text;
						if (result == "TRUE") {
							delOpinionInfoAll2();
							var pAlertContent = "<spring:message code='ezApprovalG.t1426'/>";
							OpenAlertUI(pAlertContent, OpenAlertUI_Close);
						}
                    },
					error : function() {
						var pAlertContent = "재배부를 요청하는 도중 오류가 발생했습니다.";
						OpenAlertUI(pAlertContent);
						return;
					}
            	});
	        }
		    
		    var writeboardselect_modal_dialogArguments = new Array();
		    /*function btnBoard_onclick() {
		        if (pFormHref == "") {
		            pFormHref = "/Upload_ApprovalG/" + sCompanyID + "/doc/" + CurrYear + "/1000/" + (pDocID % 1000) + "/" + pDocID + ".mht";
		        }
		        SaveFile();
		
		        writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		        var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
		        try { OpenWin.focus(); } catch (e) { }
		    }*/
		
		    function NewItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 870) / 2;
		            var pLeft = (pwidth - 765) / 2;
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8") {
		                showAlert(strLang1031);
		            }
		            else {
		                window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mod=new&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pFormHref, '', "top=" + pTop.toString() + ", left=" + pLeft.toString() + ',height=870,width=765,resizable=yes,scrollbars=no');
		            }
		        }
		    }
		
		    function btnRJunkyul_onclick() {
		        var RecevState = getDocRecevState();
				
		        //대외문서 접수 > 반송 > 재기안 시 결재올림, 전결 할 때 화면 꺼지는 버그 수정 2020-05-12 홍대표
		        if (isReDraft != "Y") {
			        if (RecevState != "011" && RecevState != "012" && RecevState != "014" && RecevState != "") {
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
		        }
		
		        var Resultxml;
		
		        var UserID = "<c:out value = '${userInfo.id}'/>";
		        var DisplayName = "<c:out value = '${userInfo.displayName1}'/>";
			    var DepID = "<c:out value = '${userInfo.deptID}'/>";
			    var DeptName = "<c:out value = '${userInfo.deptName1}'/>";
			    var Position = "<c:out value = '${userInfo.title1}'/>";
			    var CompanyID = "<c:out value = '${userInfo.companyID}'/>";
		
			    var d = new Date();
			    var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();
			
			    Resultxml = "<LISTVIEWDATA><HEADERS>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t1421'/>%" + "</NAME><WIDTH>30</WIDTH></HEADER>";
		        Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t379'/>%" + "</NAME><WIDTH>50</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t230'/>" + "</NAME><WIDTH>60</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t108'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t380'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t381'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t382'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "<HEADER><NAME>" + "<spring:message code='ezApprovalG.t383'/>" + "</NAME><WIDTH>80</WIDTH></HEADER>";
			    Resultxml = Resultxml + "</HEADERS><ROWS><ROW>";
			    Resultxml = Resultxml + "<COLUMN>1</COLUMN>";
			    Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(DisplayName) + "</COLUMN>";
			    Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(Position) + "</COLUMN>";
			
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
			    
				$.ajax({
               		type : "POST",
               		dataType : "text",
               		async : false,
               		url : "/ezApprovalG/aprLineSave.do",
               		data : {
               				ret    : Resultxml
               				},
               		success : function(result){
               			if (result == 'TRUE') {
	               			var retvalue = new Array();
	    			        retvalue[0] = Resultxml;
	    			        retvalue[1] = "NONE";
	    			        retvalue[2] = "R";
	    			        retvalue[3] = "";

							btnSendDraftEnable = "true";
	    			
	    			        if (approvalFlag == "S") {
	    	                    SGetDraftAprLineInfo(retvalue);
	    	                } else {
	    	                    GetDraftAprLineInfo(retvalue);
	    	                }
	    			        
	    			        var pAlertContent = "<spring:message code='ezApprovalG.t1423'/>";
        		            OpenAlertUI(pAlertContent);
	    		            btnSendDraft_onclick();
               			} else {
               				var pAlertContent = "<spring:message code='ezApprovalG.t1423'/>";
        		            OpenAlertUI(pAlertContent);
               			}
               		},
               		error : function() {
	               			var pAlertContent = "<spring:message code='ezApprovalG.t1423'/>";
	    		            OpenAlertUI(pAlertContent);
               		}
               	});
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
		    // var ezapprovalinfo_dialogArguments = new Array();
		    function btnApprovalInfo() {
		    	pGubun = 11;
		        var onlydocinfiview = false;
		        var parameter = new Array();
		        //CheckDocCellInfo();
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
		        parameter[11] = "";
		        parameter[12] = "DRAFT";
		        //parameter[17] = AprLineArea;
		        //parameter[18] = HapyuiArea;
		        parameter[28] = onlydocinfiview;
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
	        	parameter[45] = "";
	        	parameter[46] = "";
		
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
				
		        // ezapprovalinfo_dialogArguments[0] = parameter;
				// ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;		
				//
				// var OpenWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&docType=" + pDocType, "ezApprovalInfo", GetOpenWindowfeature(1144, 750));
				//
				// try { OpenWin.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = parameter;
				showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&docType=" + pDocType, 1144, 750, "ezApprovalInfo", GetOpenWindowfeature(1144, 750), btnApprovalInfo_Complete);
		    }
		    
		    function btnApprovalInfo_Complete(ret) {
				hidePopup();
		    	if (ret != undefined && ret[0] == "OK") {
		            try {
		                var savexmlhttp = createXMLHttpRequest();
		
		                //결재선 저장
		                if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {
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
		                    }
		                }
		                
		                if (ret[1] != false) {
		                    IsSkipDrafter = "FALSE";
		                    btnSendDraftEnable = "true";
		                    
		                    if (approvalFlag == "S") {
			                    SGetDraftAprLineInfo(ret);
		                    } else {
			                    GetDraftAprLineInfo(ret);
		                    }
		                }
		                
		                savexmlhttp = null;
		                savexmlhttp = createXMLHttpRequest();
		
		                if (pGubun != "11" && pGubun != "12" && ret[2] != "") {
							$.ajax({
	                    		type : "POST",
	                    		dataType : "text",
	                    		async : false,
	                    		url : "/ezApprovalG/aprDeptSave.do",
	                    		data : {
	                    				aprDeptInfo : ret[2]
	                    				},
	                    		success : function(result){
	                    			
	                    		}
		                    });
		
		                    //수신자 저장 후
		                    btnReceivLineEnable = false;
		                    setRecevInfo(ret[3]);
		                }
		                
	                    if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
			                //기록물철 매핑
			                var g_SelCabXml = ret[4];
			                var xmlCab = createXmlDom();
			                xmlCab = loadXMLString(g_SelCabXml);
			                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
	                    }
		
		                //문서 정보
						tempKeyword = ret[6]; 				//2021-03-10 박기범 - 키워드 추가
		                tempSecurity = ret[7];
		                tempUrgent = ret[8];
		                pSummery = ret[9];
		                pSpecialRecordCode = ret[10];
		                pPublicityCode = ret[11];
		                pLimitRange = ret[12];
		                pPageNum = ret[13];
		                tempSecurityDate = ret[14];
		                pPublicityYN = ret[21];
		                
		                //setPublicFlag();
		                SummaryFlag = true;
		                savexmlhttp = null;
		            }
		            catch (e) {
		                showAlert("<spring:message code='ezApprovalG.pjj02'/>");
		            }
		        }
		    }
		
		    function btnSendDraft_onclick() {
		        try {
		            var RecevState = getDocRecevState();
		            
			    	//접수된 문서인지 확인하기
			    	$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/isReceivedDoc.do",
			    		data : {
			    			docID : pDocID
			    		},
			    		success : function(result) {
			    			if (result != 0) {
			    				showAlert("<spring:message code='ezApprovalG.pjg04'/>", "");
			    				// window.close();
								return;
			    			}
			    		}
			    		
			    	});	
		            //대외문서 접수 > 반송 > 재기안 시 결재올림, 전결 할 때 화면 꺼지는 버그 수정 2020-05-12 홍대표
		            if (isReDraft != "Y") {
			            if (RecevState != "011" && RecevState != "012" && RecevState != "014" && RecevState != "" ) {
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
		            }
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
		            showAlert("btnSendDraft_onclick : " + e.description);
		        }
		    }
		    
		    function btnSendDraft_onclick_Complete(Ans) {
		        if (Ans) {
		            btnSetReceivLine_onclick();
		        }
		        TaskCode_Check();
		    }
		    
		    function TaskCode_Check() {
		        if (cabinetID == "") {
		        	if (nonElecRec != "Y") {
			            btnSetTaskCode_onclick();
		        	} else {
			            TaskCode_Save();
		        	}
		        } else {
		            TaskCode_Save();
		        }
		    }
		    
		    //편철시 철지정
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
		        
				/* 2020-03-31 홍승비 - 재기안 시 반송의견 유지여부 컨피그 추가 */
	            if (g_DraftFlag == "REDRAFT" && useRedraftOpinionKeep != "YES") {
	                delOpinionInfo();
	            }
				
		        pDocTitle = trim(message.GetDocTitle());
		        if (pDocTitle == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1695'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else {
		            //if ("${approvalPWD}" != "N") {
		            if (CheckUsePassword()) {
		                chk_Passwd();
		            } else {
		                check_skipdraft();
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
		            var pAlertContent = "[" + "<spring:message code='ezApprovalG.t1413'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        check_skipdraft();
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
		    
		    function saveSuSinDocInfo() {
		        var rtnval = true;
		        if (approvalFlag == "G") {
		        	rtnval = getRecvDocNumber(arr_userinfo[4], docNumZeroCnt);
		        }
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
		                    
		                    /* 2022-08-16 홍승비 - 부서수신함에서 수신문 접수기안(또는 전결) 시, 기안 시와 동일하게 결재선 변경이력 남기도록 수정 */
		                    UpdateLineHistory();
		                    
		                    if (LastSignSN == 1) {
		                        pAlertContent = "<spring:message code='ezApprovalG.t1697'/>";
		                    } else {
		                        pAlertContent = "<spring:message code='ezApprovalG.t1698'/>";
		                    }
		                    
			                //중계문서 접수 시 재배부의견은 삭제처리 2020-05-11 홍대표
			                delOpinionInfoAll3();
		                    
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
		                
		                UpdateLineHistory();
		
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
		
		    function getLastAprLine() {
		        try {
					var result = "";
		            
		            $.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/aprLineRequest.do",
		        		data : {
		        				docID    : pDocID, 
		        				userID 	 : pUserID,
		        				formID   : pFormID,
		        				mode     : ""
		        				},
		        		success: function(xml){
		        			result = loadXMLString(xml);
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
		            showAlert("getLastAprLine :: " + e.description);
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
		
		    // var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        ezCommon_cross_dialogArguments[0] = "";
		        ezCommon_cross_dialogArguments[1] = TotalSave_onclick_Complete;
		
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
	    	

            //성남시의료원 문서유통 접수창 최초 오픈 시, 접수부서 아이디를 바꾸어준다.
            function updateReceivedDept() {
                var result;
	            $.ajax({
	                    type : "POST",
	                    dataType : "text",
	                    async : false,
	                    url : "/ezApprovalG/updateReceivedDept.do",
	                    data : {
		       		            docID : pDocID,
		       		         	processorID : pUserID,
		       		         	processorName : arr_userinfo[11],
		       		         	receivedDeptID : arr_userinfo[4],
		       		         	processorJobTitle : arr_userinfo[3],
		       		         	receivedDeptName : arr_userinfo[5],
		       		            companyID : arr_userinfo[9],
			                    processorName2 : arr_userinfo[12],
			                    processorJobTitle2 : arr_userinfo[14],
		       		         	receivedDeptName2 : arr_userinfo[16]
                                },
	                    success : function(text){
	                            result = text;
	                    }
	            });
	            return result;
            }
			function getDocMode() {
				var rtnVal = "APR";

				try {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/getLineMode.do",
						data : {
							docID : pDocID,
							orgCompanyID : orgCompanyID_
						},
						success: function(result) {
							rtnVal = result;
						}
					});
				} catch (e) {
					showAlert("getDocMode() :: " + e.description);
				}

				return rtnVal;
			}
			var ezdocinfog_view_cross_dialogArguments = new Array();
			function btnDocInfo_onclick() {
				ezdocinfog_view_cross_dialogArguments[0] = "";
				ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;

				var mode = getDocMode();
				if (typeof approvalFlag !== "undefined" && approvalFlag == "G") {
					DivPopUpShow(430, 400, "/ezApprovalG/ezDocInfoView.do?docID=" + pDocID + "&ingFlag=" + mode);
				}else {
					DivPopUpShow(430, 300, "/ezApprovalG/ezDocInfoView.do?docID=" + pDocID + "&ingFlag=" + mode);
				}
			}
			function btnDocInfo_onclick_Complete() {
				DivPopUpHidden();
			}
			function ReplaceString(Origin, Source, Target) {
				return Origin.split(Source).join(Target);
			}
			var ezaprhistory_cross_dialogArguments = new Array();
			function btnhistory_onclick() {
				//회람 변경내역 볼 시 원본 내역을 봐야 하기 때문에 변경
				if (pDocState == strDocState15) {
					var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pOrgDocID + "&ext=" + "mht";
				} else {
					var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + "mht";
				}

				ezaprhistory_cross_dialogArguments[0] = "";
				ezaprhistory_cross_dialogArguments[1] = getHistory_Complete;

				DivPopUpShow(740, 450, URL);
			}

			function getHistory_Complete() {
				DivPopUpHidden();
			}
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
		  <tr> 
		    <td style="height:20px"> 
			<div id="menu">
				<%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
				<ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
					<c:choose>
						<%-- 문서보기 버튼으로 창을 open할 경우 (viewDocFlag 문서보기 Flag)--%>
						<c:when test="${viewDocFlag eq 'Y'}">
							<li id="btnReqReSend"><span onclick="return btnReqReSend_onclick()"><spring:message code='ezApprovalG.t1435'/></span></li>
							<li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
							<li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
							<li id="btnhistory"><span id="span_btnhistory" onClick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
						</c:when>
						<c:otherwise>
							<li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>
							<li id="btnSummary"><span onclick="return btnSummaryEdit()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
							<li id="btnSendDraft"><span onClick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
							<li id="btnRJunkyul" ><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li>
							<li id=btnCabinet style="display:none"><span  onClick="return btnCabinet_onclick()" ><spring:message code='ezApprovalG.t1406'/></span></li>
							<li id=btnAssign><span  onClick="return btnAssign_onclick()" ><spring:message code='ezApprovalG.t1430'/></span></li>
							<li id=btnReAssign style="display:none"><span  onClick="return btnReAssign_onclick()" ><spring:message code='ezApprovalG.t1431'/></span></li>
							<li id=btnDistribute><span  onClick="return btnDistribute_onclick()" ><spring:message code='ezApprovalG.t1432'/></span></li>
							<li id=btnReDistribute style="display:none"><span  onClick="return btnReDistribute_onclick()" ><spring:message code='ezApprovalG.t1433'/></span></li>
							<li id=btnOpinion><span  onClick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
							<li id="btnReqReSend" style="display: none"><span onclick="return btnReqReSend_onclick()"><spring:message code='ezApprovalG.t1435'/></span></li>
						</c:otherwise>
					</c:choose>
					<li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
					<li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
					<c:if test="${useExternalMailServer == 'NO'}">
						<li id="btnMail"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
					</c:if>
				</ul>
				<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
		        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
		        </ul>
			</div>
			<div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
		        <ul>
		          <li id="btnClose" ><span onClick="return btnClose_onclick()"></span></li>
		        </ul>
		      </div>
		    </td>
		  </tr>
		
		  <tr> 
		    <td style="padding-bottom:10px; height:90%;">
			<table style="width:100%;height:100%">
		        <tr>
		          <td style="vertical-align:middle;height:100%" id="form1">
					<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="recevEndContent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		            </td>
		        </tr>
		        <tr id="form2">
		          <td style="vertical-align:middle">
					<iframe id="message2"  style="background-color:White;height:1px;width:1px;"></iframe>		
			</td>
		  </tr>
		  </table></td>
		  </tr>
		   <tr>
		    <td style="height:20px">
                <table class="file" style="height:80px;">
                    <tr>
                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
                            <div id="lstAttachLink" style="height:70px;"></div>
                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
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
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
		
		<XML ID="ATTACHINFO"></XML>
		<XML ID="DOCINFO"></XML>
		<XML ID="OPTIONINFO"></XML>
		<XML ID="APRLINEINFO"></XML>
		<XML ID="PREVNEXTDOCINFO"></XML>
		<XML ID="CONNINFO"></XML>
		<DIV ID="RECEIPTDEPTID" style="display:none"></DIV>
		
		<div id="AprMemberSN" style="display:none"></div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
