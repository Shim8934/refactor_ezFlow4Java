<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:97%">
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
		<script type="text/javascript" src="/js/ezApprovalG/Recvdocnumber_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/RecevG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/RecevIng_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CheckLines_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript"ID="clientEventHandlersJS">
		    var pWriterDeptID;
		    var pDocID = '${docID}';
		    var pFormHref = new String("");
		    var pFormID = new String();
		    var zFormID = new String();
		    var pUserID = "${userInfo.id}";
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
		    var cabinetID = "";
		    var TaskCode = "";
		    var pDocNumCode, pOrgDocNumCode, pDocNo;
		    var maxwidth = 659;
		    var RootURL = document.location.protocol + "//" + document.location.hostname;  
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName1}";
		    arr_userinfo[3]  = "${userInfo.title1}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName1}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = sCompanyID;
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var arrDelFiles = new Array();
		    var CurrYear = "${dirYear}";
		    var ConvertYN = "Y";
		    var isSplit = "${optIsSplit}";
		    var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pLimitRange = "", pPageNum = "1";
		    var SummaryFlag = false;
		    var pGubun;
		    var xmluserInfo = createXmlDom();
		    var g_DraftFlag = "${draftFlag}";
		    var SignType = new Array();
		    var SignName = new Array();
		    var SignContent = new Array();
		    var arrDelFiles = new Array();
		    var NonActiveX = "YES";
		
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
		                    if (pHasOpinionYN == "Y") {
		                        var pInformationContent;
		                        var Ans;
		                        pInformationContent = "<spring:message code='ezApprovalG.t126'/>" + "<br>" + "<spring:message code='ezApprovalG.t125'/>";
		                        Ans = OpenInformationUI(pInformationContent);
		
		                        if (Ans) {
		                            openOpinionUI("Display");
		                        }
		                    }
		                }
		            }
		        } catch (e) {
		            alert("process_AfterOpen : " + e.description);
		        }
		    }
		    function setAutoProperty() {
		        try {
		            SetAutoPropertyValue();
		        } catch (e) {
		            alert("setAutoProperty : " + e.description);
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
		            alert("setAutoProperty : " + e.description);
		        }
		    }
		
		    function FieldsAvailable() {
		        if (ConvertYN == "N") {
		            pGubun = "11";
		            setProperty();
		            process_AfterOpen();
		            document.getElementById('form2').style.display = "none";
		
		            if (SignCount < 1) {
		                pGubun = "12";
		                //document.getElementById("btnSetAprLine").style.display = "none";
		                document.getElementById("btnSendDraft").style.display = "none";
		                document.getElementById("btnRJunkyul").style.display = "none";
		                document.getElementById("btnSendAround").style.display = "";
		                document.getElementById("btntotaldocinfo").style.display = "none";
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
		                }
		            }
		        }
		        setProperty();
		        setAutoProperty();
		        document.getElementById('form2').style.display = "none";
		
		        if (SignCount < 1) {
		            pGubun = "12";
		            document.getElementById("btnSendDraft").style.display = "none";
		            document.getElementById("btnRJunkyul").style.display = "none";
		            document.getElementById("btnSendAround").style.display = "";
		            document.getElementById("btntotaldocinfo").style.display = "none";
		        }
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
		    }
		    function DocumentComplete2() {
		        var URL = encodeURI(pFormHref);
		        document.getElementById('message2').src = "/ezCommon/mhtToHTMLContent.do?href=" + URL;
		        document.getElementById('message2').setAttribute("onload", "javascript:FieldsAvailable2();");
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
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "");
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    window.onbeforeunload = function () {
		        try {
		            window.opener.openergetDocInfo();
		        }
		        catch (e) {
		        }
		
		        try {
		            window.opener.Refresh_Window();
		        }
		        catch (e) {
		        }
		    };
		    function pzFormProc_InvalidDocument() {
		        var pAlertContent = "<spring:message code='ezApprovalG.t123'/>";
		        OpenAlertUI(pAlertContent);
		        FormProc.FileNew();
		    }
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
		
		        DivPopUpShow(1000, 740, "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveDistributeUI_Cross.aspx");
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
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = pSusinSN;
		        parameter[2] = pAprState;
		
		        ezreceiveassignui_cross_dialogArguments[0] = parameter;
		        ezreceiveassignui_cross_dialogArguments[1] = btnAssign_onclick_Complete;
		
		        DivPopUpShow(460, 365, "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveAssignUI_Cross.aspx");
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
		        var feature = "height=700,width=690,resizable=yes,scrollbars=no";
		        feature = feature + GetOpenPosition(690, 700);
		        window.open("/myoffice/ezEmail/newmail_CK.aspx?cmd=docsend&docID=" + "${docID}" + "&docHref=" + pFormHref, '', feature);
		    }
		    function btnSendAround_onclick() {
		        var para = new Array();
		        para[0] = pDocID;
		        var url = "AprGongRamLine_Cross.aspx";
		        var feature = "dialogWidth:557px;dialogHeight:545px;scroll:no;resizable:yes;status:no;help:no";
		        feature = feature + GetShowModalPosition(557, 545);
		        var rtn = window.showModalDialog(url, para, feature);
		        if (rtn == "OK") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1424'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    var selectcabinet_cross_dialogArguments = new Array();
		    function btnCabinet_onclick() {
		        var para = new Array();
		        para[0] = cabinetID;
		        var url = "../ezCabinet/SelectCabinet_Cross.aspx?initFlag=1";
		
		        selectcabinet_cross_dialogArguments[0] = para;
		        selectcabinet_cross_dialogArguments[1] = btnCabinet_onclick_Complete;
		
		        DivPopUpShow(850, 455, "/myoffice/ezApprovalG/ezCabinet/SelectCabinet_Cross.aspx?initFlag=1");
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
		            getRecvDocNumber(arr_userinfo[4]);
		
		            var xmlpara = createXmlDom();
		            var xmlhttp = createXMLHttpRequest();
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "tempDocID", pDocID);
		            createNodeAndInsertText(xmlpara, objNode, "tempDocNo", pDocNo);
		            createNodeAndInsertText(xmlpara, objNode, "tempDocNumCode", pDocNumCode);
		            createNodeAndInsertText(xmlpara, objNode, "tempOrgDocNumCode", pOrgDocNumCode);
		            createNodeAndInsertText(xmlpara, objNode, "tempCabinetID", cabinetID);
		            createNodeAndInsertText(xmlpara, objNode, "tempTaskCode", TaskCode);
		            createNodeAndInsertText(xmlpara, objNode, "tempUserID", pUserID);
		            createNodeAndInsertText(xmlpara, objNode, "tempUserName", arr_userinfo[11]);
		            createNodeAndInsertText(xmlpara, objNode, "tempDeptID", arr_userinfo[4]);
		            createNodeAndInsertText(xmlpara, objNode, "tempTitle", arr_userinfo[3]);
		            createNodeAndInsertText(xmlpara, objNode, "tempDeptName", arr_userinfo[5]);
		            createNodeAndInsertText(xmlpara, objNode, "tempCompanyID", arr_userinfo[9]);
		            createNodeAndInsertText(xmlpara, objNode, "TEMPUSERNAME2", arr_userinfo[12]);
		            createNodeAndInsertText(xmlpara, objNode, "TEMPTITLE2", arr_userinfo[14]);
		            createNodeAndInsertText(xmlpara, objNode, "TEMPDEPTNAME2", arr_userinfo[16]);
		
		            xmlhttp.open("Post", "aspx/setRecvComplete.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            if (xmlhttp.responseText.indexOf("TRUE") > -1) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1693'/>";
		                OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		            }
		            else {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1694'/>";
		                OpenAlertUI(pAlertContent);
		            }
		        }
		    }
		    function btnReAssign_onclick() {
		        var ret = openOpinionUI("BanSong");
		        if (ret != "cancel") {
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
		        var ret = openOpinionUI("BanSong");
		        if (ret != "cancel") {
		            var xmlpara = createXmlDom();
		            var xmlhttp = createXMLHttpRequest();
		
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
		            createNodeAndInsertText(xmlpara, objNode, "pReceivSN", pSusinSN);
		            createNodeAndInsertText(xmlpara, objNode, "pDeptID", arr_userinfo[4]);
		
		            xmlhttp.open("Post", "aspx/setReBebu.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            if (xmlhttp.responseText == "TRUE") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1426'/>";
		                OpenAlertUI(pAlertContent);
		                btnClose_onclick();
		            }
		        }
		    }
		    var writeboardselect_modal_dialogArguments = new Array();
		    function btnBoard_onclick() {
		        if (pFormHref == "") {
		            pFormHref = "/Upload_ApprovalG/" + sCompanyID + "/doc/" + CurrYear + "/1000/" + (pDocID % 1000) + "/" + pDocID + ".mht";
		        }
		        SaveFile();
		
		        writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		        var OpenWin = window.open("/myoffice/ezBoardSTD/WriteBoardSelect_Modal.aspx", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
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
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
		                alert(strLang625);
		            }
		            else {
		                window.open("/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pFormHref, '', "top=" + pTop.toString() + ", left=" + pLeft.toString() + ',height=870,width=765,resizable=yes,scrollbars=no');
		            }
		        }
		    }
		
		    function btnRJunkyul_onclick() {
		        var RecevState = getDocRecevState();
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
		
		        var Resultxml;
		
		        var UserID = '${userInfo.id}';
		        var DisplayName = '${userInfo.displayName1}';
		    var DepID = '${userInfo.deptID}';
		    var DeptName = '${userInfo.deptName1}';
		    var Position = '${userInfo.title1}';
		    var CompanyID = '${userInfo.companyID}';
		
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
		
		    var tempSecurity = "";
		    var tempKeep = "";
		    var tempUrgent = "N";
		    var tempPublic = "Y";
		    var tempKeyword = "";
		    var tempItemCode = "";
		    var tempItemName = "";
		    var tempdocnumcode = "<spring:message code='ezApprovalG.t45'/>";
		    var tempSecurityDate = "";
		    function btnApprovalInfo() {
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
		
		
		        if (tempItemCode != "")
		            tempdocnumcode = tempItemCode;
		        var url = "/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun;
		        var feature = "status:no;dialogWidth:1000px;dialogHeight:740px;help:no;scroll:no;;edge:sunken;";
		        var ret = window.showModalDialog(url, parameter, feature);
		
		        if (ret != undefined && ret[0] == "OK") {
		            try {
		                var savexmlhttp = createXMLHttpRequest();
		
		                //결재선 저장
		                if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {
		                    if (ret[1] != false) {
		                        savexmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
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
		                    //수신자 저장
		                    savexmlhttp.open("Post", "/ezApprovalG/aprDeptSave.do", false);
		                    savexmlhttp.send(ret[2]);
		
		                    //수신자 저장 후
		                    btnReceivLineEnable = false;
		                    setRecevInfo(ret[3]);
		                }
		
		                //기록물철 매핑
		                var g_SelCabXml = ret[4];
		                var xmlCab = createXmlDom();
		                xmlCab = loadXMLString(g_SelCabXml);
		                cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
		                TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
		
		
		                //문서 정보
		                tempSecurity = ret[7];
		                tempUrgent = ret[8];
		                pSummery = ret[9];
		                pSpecialRecordCode = ret[10];
		                pPublicityCode = ret[11];
		                pLimitRange = ret[12];
		                pPageNum = ret[13];
		                tempSecurityDate = ret[14];
		                //setPublicFlag();
		                SummaryFlag = true;
		                savexmlhttp = null;
		            }
		            catch (e) {
		                alert("저장시 오류 발생");
		            }
		        }
		    }
		
		    function btnSendDraft_onclick() {
		        try {
		            var RecevState = getDocRecevState();
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
		                    var Ans = OpenInformationUI(pInformationContent);
		
		                    if (Ans) {
		                        btnSetReceivLine_onclick();
		                    }
		                }
		            }
		            catch (e) { }
		
		            if (cabinetID == "")
		                btnSetTaskCode_onclick();
		
		            if (cabinetID == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t134'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		
		            var g_SepAttachLVXml = "";
		            g_SepAttachLVXml = message.CKEDITOR.instances.editor1.document.$.body.getAttribute("SepAttachLVXml", 0);
		            if (!g_SepAttachLVXml)
		                g_SepAttachLVXml = "";
		
		            if (!CheckSepAttParamXmlNull(g_SepAttachLVXml)) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1411'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		
		            if (g_DraftFlag == "REDRAFT")
		                delOpinionInfo();
		
		            pDocTitle = field.textContent;
		            pDocTitle = trim(pDocTitle);
		            if (pDocTitle == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1695'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            else {
		                if ("${approvalPWD}" != "N") {
		                    var chkpass = chk_Passwd();
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
		                }
		
		                if (IsSkipDrafter == "FALSE") {
		                    var ret;
		                    var parameter = new Array();
		                    parameter[0] = pDocID;
		
		                    if (SignCount < 1) {
		                        ret = "NAME";
		                    }
		                    else {
		                        ret = openSignUI(parameter);
		                    }
		
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
		
		                    pOrgHtml = message.GetEditorContent();
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
		                }
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
		        }
		        catch (e) {
		            alert("btnSendDraft_onclick : " + e.description);
		        }
		    }
		
		    function getDocRecevState() {
		        try {
		            var objRoot;
		            var objNode;
		            var result = "FALSE";
		
		            var xmlpara = createXmlDom();
		            var xmlhttp = createXMLHttpRequest();
		
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
		            createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
		
		            xmlhttp.open("Post", "aspx/GetDocState.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            result = xmlhttp.responseText;
		
		            return result;
		        }
		        catch (e) {
		            alert("getDocRecevState :: " + e.description);
		        }
		    }
		
		    function getLastAprLine() {
		        try {
		            var xmlhttp = createXMLHttpRequest();
		            var xmlpara = createXmlDom();
		
		            var objNode;
		            createNodeInsert(xmlpara, objNode, "PARAMETER");
		            createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
		            createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
		            createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);
		
		            xmlhttp.open("Post", "../ezaprline/aspx/AprLineRequest.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            var NodeList = SelectNodes(xmlhttp.responseXML, "LISTVIEWDATA/ROWS/ROW");
		            if (NodeList.length > 0) {
		                var bResult = CheckFirstDrafter(xmlhttp.responseXML);
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
		
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(600, 450, "/myoffice/ezApprovalG/TotalSaveFileInfo.aspx?docid=" + pDocID + "&type=APR");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
		  <tr> 
		    <td style="height:20px"> 
			<div id="menu">
			<ul>
		        <li id="btntotaldocinfo"><span onClick="return btnApprovalInfo()" ><spring:message code='ezApprovalG.t1742'/></span></li>        
		        <li id="btnSendDraft"><span onClick="return btnSendDraft_onclick()"><spring:message code='ezApprovalG.t156'/></span></li>
		        <li id="btnRJunkyul" ><span  onClick="return btnRJunkyul_onclick()"><spring:message code='ezApprovalG.t1427'/></span></li>
			    <li id=btnCabinet><span  onClick="return btnCabinet_onclick()" ><spring:message code='ezApprovalG.t1406'/></span></li>
			    <span style ="display:none" ><li id=btnSendAround><span  onClick="return btnSendAround_onclick()" ><spring:message code='ezApprovalG.t1428'/></span></li></span>
			    <li id=btnAssign><span  onClick="return btnAssign_onclick()" ><spring:message code='ezApprovalG.t1430'/></span></li>
			    <li id=btnReAssign style="display:none"><span  onClick="return btnReAssign_onclick()" ><spring:message code='ezApprovalG.t1431'/></span></li>
			    <li id=btnDistribute><span  onClick="return btnDistribute_onclick()" ><spring:message code='ezApprovalG.t1432'/></span></li>
			    <li id=btnReDistribute style="display:none"><span  onClick="return btnReDistribute_onclick()" ><spring:message code='ezApprovalG.t1433'/></span></li>
			    <li id=btnOpinion><span  onClick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
			    <li id="btnReqReSend" style="display:none"><span  onClick="return btnReqReSend_onclick()" ><spring:message code='ezApprovalG.t1435'/></span></li>
			    <li id=btnBoard><span  onClick="return btnBoard_onclick()" ><spring:message code='ezApprovalG.t215'/></span></li>
			    <li id=btnPrint><span  onClick="return btnPrint_onclick()" ><spring:message code='ezApprovalG.t60'/></span></li>
		        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
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
		    <td style="height:20px"><table class="file">
		        <tr>
		          <th id="btn_Attach" ><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
		  </tr>
		  <input type="file" id="pFile" style="display:none;" />
		</table>
		
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
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>