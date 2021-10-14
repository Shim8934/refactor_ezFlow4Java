<%@ Page Language="c#" Inherits="Kaoni.ezStandard.ezViewEnd_HWP" CodeFile="ezViewEnd_HWP.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title><%=RM.GetString("t367")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript"> var pNoneActiveX = "<%=NoneActiveX%>"; </script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css">
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAprDocAttach/getDocAttach.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/printer/appandbody.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
    <script type="text/javascript">
        var pDocID = '<%=_DocID%>';
        var pDocHref = '<%=_DocHref%>';
        var pListSusin = '<%=_ListSusin%>';
        var porgDocID = '<%=_orgDocID%>';
        var pFormID = '<%=_formID%>';
        var pTitle = '<%=_Doctitle%>';
        var pOpinionFlag;
        var pListTypeValue = 4;
        var flag = false;
        var PrevOpinionFlag = false;
        var NextOpinionFlag = true;
        var doctitle = "";
        var pOrgAttach = "";
        var pendDir = "<%=_endDir%>"
        var xmlhttp = createXMLHttpRequest();
        var arr_userinfo = new Array();
        arr_userinfo[0] = "user";
        arr_userinfo[1] = "<%=userinfo.UserID%>";
        arr_userinfo[2] = "<%=userinfo.DisplayName%>";
        arr_userinfo[3] = "<%=userinfo.Title%>";
        arr_userinfo[4] = "<%=userinfo.DeptID%>";
        arr_userinfo[5] = "<%=userinfo.DeptName%>";
        arr_userinfo[6] = "<%=userinfo.Jikchek%>";
        arr_userinfo[8] = "<%=userinfo.Email%>";
        arr_userinfo[9] = "";
        arr_userinfo[10] = "<%=_pSusinAdmin%>";
        arr_userinfo[11] = "<%=userinfo.DisplayName1%>";
        arr_userinfo[12] = "<%=userinfo.DisplayName2%>";
        arr_userinfo[13] = "<%=userinfo.Title1%>";
        arr_userinfo[14] = "<%=userinfo.Title2%>";
        arr_userinfo[15] = "<%=userinfo.DeptName1%>";
        arr_userinfo[16] = "<%=userinfo.DeptName2%>";
        var companyID = "<%=userinfo.CompanyID%>";
        var pUserID = arr_userinfo[1];
        var SignCheckFlag = "<%=SignCheck%>";
        var pUse_Editor = "<%= Use_Editor%>";
        var pNoneActiveX_Cross = "<%=NoneActiveX_Cross%>";  //메일보내기 엑티브엑스 사용체크(20161110)

        var pGovInfo_ = "<%=pGovInfo%>";  //소방 고도화 추가건(20170721)
        var pPublicityCode_GOV_ = "<%=pPublicityCode_GOV%>";
        var pLimitRange_GOV = "";

        window.onresize = function () {
            HwpCtrl.style.height = null;
            HwpCtrl.height = document.documentElement.clientHeight - 150;
        }

        function btnOpinion_onclick() {
            var parameter = new Array();
            parameter[0] = pDocID;
            parameter[1] = "Show";

            var url = "/myoffice/ezApprovalG/formContainer/AprEndOpinion.aspx";
            var feature = "status:no;dialogWidth:530px;dialogHeight:420px;scroll:no;edge:sunken"
            var ret = window.showModalDialog(url, parameter, feature);
        }

        function CheckOpinionInfo() {
            var xmlpara = createXmlDom();


            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);


            xmlhttp.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/getEndOpinionInfo.aspx", false);
            xmlhttp.send(xmlpara);

            Resultxml = loadXMLString(xmlhttp.responseText);

            var NodeList = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
            if (NodeList.length > 0)
                return true;
            else
                return false;
        }

        function window_onload() {
            window.onresize();



            HwpCtrl.SetSaveMode(1);

            if ("<%=PASS%>" != "<RESULT>TRUE</RESULT>") {
                QuitWindow();
            }
            else if (pDocHref != "") {
                showProgress("<%=RM.GetString("t368")%>");
                var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pDocHref);


                var isTrue = HwpCtrl.LoadFile(URL, false);

                if (isTrue) {

                    if (pFormID == "") {
                        btnSave.style.display = "none";
                    }

                    setAttachInfo(pDocID, "END", lstAttachLink);
                    hideProgress();

                    var Rtnval = CheckOpinionInfo();
                    if (Rtnval) {
                        var pInformationContent = "<%=RM.GetString("t9")%><br> <%=RM.GetString("t170")%>";
                        var Ans = OpenInformationUI(pInformationContent);

                        if (Ans) {
                            btnOpinion_onclick();
                        }
                    }


                    if (SignCheckFlag == "N") {
                        var boolDocID = CheckDocID(); //소방 문서바뀜 현상체크(20170405)
                        //SignCheck();
                        if (pFormID == "2009000118") {//협의문 개인합의사인으로 인한 사인칸빠지는 현상 보안 
                            SignCheck();
                        }

                    }

                    HwpCtrl.SetImgReg();
                }
                else {
                    hideProgress();
                    var pAlertContent = "<%=RM.GetString("t369")%>";
                    OpenAlertUI(pAlertContent);
                    HwpCtrl.ClearDocument();
                }
                HwpCtrl.ChangeMode(3);
            }
            if (pGovInfo_ == "Y") { //소방 고도화 수정(20170721)
                setPublicFlag_GOV();
                document.getElementById("btnMail").style.display = "none";
                document.getElementById("btnBoard").style.display = "none";
                document.getElementById("btnPrint").style.display = "none";
                document.getElementById("btnSave").style.display = "none";
                document.getElementById("btnDocInfo").style.display = "none";
                document.getElementById("btnhistory").style.display = "none";
                document.getElementById("btnClose").style.display = "none";
                document.getElementById("btnGov").style.display = "";
                alert("확인 버튼 클릭 후 문서정보가 변경됩니다.")
                //SaveFile();
            }
            else {
                if (pPublicityCode_GOV_ != "") {
                    setPublicFlag_GOV();
                    SaveFile();
                    HtmlFlagUpdate();
                }
            }

        HwpCtrl.SetFieldFocus("doctitle");
        HwpCtrl.ezSetScrollPosInfo(0);

        }

        function HtmlFlagUpdate() { //소방 문서 본문 공개/비공개 수정후 플래그값 업데이트(20170724)
            var xmlHTTP = createXMLHttpRequest();
            var xmlDom = "<DATA>" + "<DOCID>" + pDocID + "</DOCID>" + "</DATA>";
            xmlHTTP.open("POST", "/myoffice/ezApprovalG/ezViewHWP/aspx/HTMLBodyFlagUpdate.aspx", false);
            xmlHTTP.send(xmlDom);
        }

        function btnGov_onclick() { //소방고도화 수정(20170721)
            SaveFile();
            opener.parent.UpdateDocGov();
            window.close();

        }

    function setPublicFlag_GOV() { //소방 고도화 공개 비공개 찍어줌(20170721)
        try {
            if (!HwpCtrl.CheckFieldExist("publication"))
                return;

            var PublicType = pPublicityCode_GOV_.substring(0, 1);
            var PublicLevel = pPublicityCode_GOV_.substring(1, 9);
            var PublicText = "";

            if (pLimitRange_GOV != "")
                PublicText = " (" + pLimitRange_GOV + ")";

            if (PublicType == "1")
                PublicText = "<%=RM.GetString("t47")%>";
            else if (PublicType == "2")
                PublicText = "<%=RM.GetString("t150")%>" + getPublicLevel_GOV(PublicLevel);
                else if (PublicType == "3")
                    PublicText = "<%=RM.GetString("t46")%>" + getPublicLevel_GOV(PublicLevel);
        else
            PublicText = " ";

    HwpCtrl.SetFieldText("publication", PublicText);

} catch (e) {
    alert("ezdraftui_hwp.aspx.setPublicFlag()::" + e.description);
}
}

function getPublicLevel_GOV(PublicLevel) { //소방 고도화 공개 비공개 찍어줌(20170721)
    try {
        var strRtn = "";
        var firstFlag = true;
        for (i = 0; i < 8; i++) {
            if (PublicLevel.substring(i, i + 1) == "Y") {
                if (firstFlag) {
                    strRtn = "(" + (i + 1);
                    firstFlag = false;
                } else {
                    strRtn = strRtn + "," + (i + 1);
                }
            }
        }

        if (!firstFlag)
            strRtn = strRtn + ")";
        return strRtn;
    } catch (e) {
        alert("ezdraftui_hwp.aspx.getPublicLevel()::" + e.description);
    }
}

function CheckDocID() {
    if (pDocHref.length != 0) {
        var rtnValue = false;
        var pCheckDocHref = pDocHref.substring(pDocHref.indexOf(".hwp") - 20, pDocHref.indexOf(".hwp"));
        if (pDocID == pCheckDocHref) {
            rtnValue = true;
        } else {
            FailLogDocID();
        }
    }
    return rtnValue;
}

function FailLogDocID() {
    try {
        var xmlhttp = createXMLHttpRequest();
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pDocHref", pDocHref);
        xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/FailLogDocID.aspx", false);
        xmlhttp.send(xmlpara);
    } catch (e) {
    }
}

function QuitWindow() {
    menu.style.display = "none";
    OpenAlertUI("<%=RM.GetString("t1443")%><br><%=RM.GetString("t1444")%>");
    btnClose_onclick();
    window.close();
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}


function btnPrint_onclick() {
    HwpCtrl.PrintDocument("", true);
}

function btnClose_onclick() {
    window.close();
}

function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);

    return RtnVal;
}

function btnSave_onclick() { //완료문서 DRM 암호화 처리(20161215)
    if (pDocHref.indexOf(".mht") > -1) {
        HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
        HwpCtrl.SetDocumentInfo(pFormID);
        var hwpDoctitle = HwpCtrl.GetFieldText("doctitle").replace("\r\n", "");
        hwpDoctitle = hwpDoctitle.replace(/\\/ig, '').replace(/\//ig, '').replace(/:/ig, '').replace(/\*/ig, '').replace(/\?/ig, '').replace(/“/ig, '').replace(/</ig, '').replace(/>/ig, '').replace(/|/ig, '').replace("“", "").replace("|", "");
        HwpCtrl.SaveFile("", hwpDoctitle);
    }
    else {
        try {   //2016.12.15 DRM HWP 파일 저장 처리.
            ClearSealsign();
            var xmlHttp = createXMLHttpRequest();
            var xmlDom = "<DATA>" + "<DOCID>" + pDocID + "</DOCID>" + "</DATA>";
            xmlHttp.open("POST", "aspx/SaveDrmFileHwp.aspx", false);
            xmlHttp.send(xmlDom);
            var xmlDoc = xmlHttp.responseXML;
            var pFileUrl = "";
            var hwpDoctitle = "";
            if (CrossYN()) {
                pFileUrl = xmlDoc.getElementsByTagName("HREF")[0].textContent;
                hwpDoctitle = xmlDoc.getElementsByTagName("DOCTITLE")[0].textContent;
            }
            else {
                pFileUrl = xmlDoc.getElementsByTagName("HREF")[0].text;
                hwpDoctitle = xmlDoc.getElementsByTagName("DOCTITLE")[0].text;
            }
            hwpDoctitle = hwpDoctitle.replace("\n", ""); //소방 간의기안문시 제목이 두줄로 나오는 현상으로 띄어쓰기 replace 처리(20180208)
            window.open("/myoffice/common/ezCommon_InterFace.aspx?drm=Y&TYPE=APPROVALG&Gubun=body&filepath=" + escape(pFileUrl) + "&filename=" + escape(hwpDoctitle + ".hwp"), "", "height=0px, width=0px");
        }
        catch (e) {
            alert(e.message);
        }
    }
}

// 2012.02.28 :: PC 저장 시 직인 제거 (기존커스터마이징) 2016 AS-IS 적용
function ClearSealsign() {
    if (HwpCtrl.CheckFieldExist("sealsign"))
        HwpCtrl.SetFieldBackImage("sealsign", "");
}
//2012.02.28 DRM HWP 파일 저장 처리.

function btnMail_onclick() {
    if (pNoneActiveX_Cross == "YES") { //소방 엑티브엑스 처리(20161110)
        window.open("/myoffice/ezEmail/mail_write_Cross.aspx?DocHref=<%=_DocHref%>&cmd=docsend&DocID=<%=_DocID%>" + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
    }
    else {
        window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=<%=_DocHref%>&cmd=docsend&DocID=<%=_DocID%>" + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
    }
}

function btnBoard_onclick() {
    var wWeight = "345";
    var wHeight = "660";

    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;

    var left = (width - wWeight) / 2;
    var top = (heigth - wHeight) / 2;
    var ret = window.showModalDialog("/myoffice/ezBoardSTD/WriteBoardSelect_Modal.aspx", "",
        "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);

    if (typeof (ret) != "undefined") {
        pBoardID = ret[0];

        if (pBoardID == "" || typeof (pBoardID) == "undefined") {
            return;
        }

        var pheight = window.screen.availHeight;
        var pwidth = window.screen.availWidth;
        var pTop = (pheight - 720) / 2;
        var pLeft = (pwidth - 765) / 2;

        if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
            alert(strLang1031);
        }
        else {
            if (pUse_Editor == "" || pUse_Editor == "CK") {
                window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
            }
            else {
                if (pNoneActiveX_Cross == "YES") { //소방 엑티브엑스 사용안함 처리(20161110)
                    window.open("/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
                }
                else {
                    window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
                }
            }
        }
    }
}

function btnhistory_onclick() {
    getHistory();
}

function getHistory() {
    var URL = "/myoffice/ezApprovalG/ezAPRHISTORY/ezAPRHISTORY_Cross.aspx?DocID=" + pDocID;
    centerOpenWindow(URL, 730, 430);
}

function centerOpenWindow(wfileLocation, wWeight, wHeight) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;

        var left = (width - wWeight) / 2;
        var top = (heigth - wHeight) / 2;

        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);

    } catch (e) {
        alert("centerOpenWindow :: " + e.description);
    }
}

function btnDocInfo_onclick() {
    var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG_View.aspx?DocID=" + pDocID + "&IngFlag=END";
    var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
    var RtnVal = window.showModalDialog(url, "", feature);
}


function SignCheck() {
    var SignXML = createXmlDom();

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);

    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/getSignInfo.aspx", false);
    xmlhttp.send(xmlpara);

    if (loadXMLString(xmlhttp.responseText).xml == "") {
        SaveSignCheck();
        return;
    }

    var NodeList;
    NodeList = loadXMLString(xmlhttp.responseText).selectNodes("SIGNINFOS/SIGNINFO");
    if (NodeList.length <= 0) {
        SaveSignCheck();
        return;
    }

    SignXML = loadXMLString(xmlhttp.responseText);
    var rtnVal = putSignXML(SignXML);
    if (rtnVal) {
        SaveFile();

        SaveSignCheck();
    }
}

function putSignXML(SignXML) {
    var retVal = false;
    try {
        var NodeList;
        NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
        if (NodeList.length > 0) {
            for (i = 0; i < NodeList.length; i++) {
                var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
                var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
                var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));

                if (HwpCtrl.CheckFieldExist(SignName)) {
                    retVal = true;
                    if (SignType == "TEXT") { //소방 결재 사인칸 변경으로 주석처리(20161207)
                        //HwpCtrl.SetFieldText(SignName, SignCont);
		        if (pFormID == "2009000118") //협의문 개인합의사인으로 인한 사인칸빠지는 현상 보안 
                        {
                            HwpCtrl.SetFieldText(SignName, SignCont);
			}
                    }
                    else if (SignType == "HTML") {

                        HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
                    }
                    else if (SignType == "PROXY") {
                        HwpCtrl.SetFieldText(SignName, " ");
                        HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SignCont), 3, 0, 0, true, 2);
                        HwpCtrl.AppendFieldText(SignName, strLang17, true);
                    }
                    else if (SignType == "IMAGE") {
                        var img = SignCont.split("::");
                        HwpCtrl.SetFieldText(SignName, "");
                        if (img.length >= 1)
                            HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]), 3, 0, 0, true, 2);

                        if (img.length >= 2)
                            HwpCtrl.AppendFieldText(SignName, img[1], true);

                    }
                }
            }
        }
    } catch (e) {
        alert("putSignXML : " + e.description);
        return false;
    }
    return retVal;
}


function SaveFile() {

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));


    xmlhttp.open("POST", "aspx/saveendfilehwp.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}


function SaveSignCheck() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "SignCheck", "Y");

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/UpdateSignCheck.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
        function btnDoc24Return_onclick() { //20190103 문서24 회신
            var pArgument = new Array();
            pArgument[0] = pUserID;
            pArgument[1] = "/Upload_ApprovalG/0000KFI/Form/2009000127.hwp"; ///Upload_ApprovalG/0000KFI/Form/2009000127.hwp
            pArgument[2] = "DRAFT";
            pArgument[3] = "003";
            pArgument[4] = "0";
            pArgument[5] = "";
            pArgument[6] = "";
            pArgument[7] = "";

            var openLocation = "";
            openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDraftUI_HWP.aspx?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
            openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=" + escape(pListTypeValue) + "&AprState=" + escape(pArgument[6]);
            openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]) + "&OpenFlag=" + "Y";
            openLocation = openLocation + "&DeptCode=" + escape("<%=_Doc24Code%>") +"&DeptName=" + escape("<%=_Doc24Name%>");

            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;

            var left = 0;
            var top = 0;

            if (window.screen.width > 800) {
                var pleftpos;

                pleftpos = parseInt(width) - 1150;
                heigth = parseInt(heigth) - 85;

                if (CrossYN())
                    heigth = parseInt(heigth) - 25;

                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                    heigth = parseInt(heigth) - 40;

                width = parseInt(width) - pleftpos;

                left = pleftpos / 2;
            }
            else {

                heigth = parseInt(heigth) - 85;

                if (CrossYN())
                    heigth = parseInt(heigth) - 25;

                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
                    heigth = parseInt(heigth) - 40;

                width = parseInt(width) - 10;
            }

            window.open(openLocation, "완료회신",  "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        }

    </script>
</head>
<body class="popup" style="overflow: hidden" onload="javascript:window_onload()">

    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul>
                        <li id="btnMail"><span onclick="return btnMail_onclick()"><%=RM.GetString("t1436")%></span></li>
                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><%=RM.GetString("t1445")%></span></li>
                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><%=RM.GetString("t60")%></span></li>
                        <li id="btnSave"><span onclick="return btnSave_onclick()">PC<%=RM.GetString("t59")%></span></li>
                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><%=RM.GetString("t54")%></span></li>
                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><%=RM.GetString("t61")%></span></li>
                        <li id="btnGov" style="display: none"><span onclick="btnGov_onclick()">확인</span></li>
                        <%if (CheckbtnReqReSend)
                            { %>
                        <li id="btnDoc24Return"><span onclick="btnDoc24Return_onclick()">문서24 완료 회신</span></li><!--20190103 문서 24 회신-->
                        <%} %>
                    </ul>
                </div>
                <div id="close">
                    <ul>
                        <li id="btnClose"><span onclick="return btnClose_onclick()"><%=RM.GetString("t64")%></span></li>
                    </ul>
                </div>
                <script type="text/javascript">
                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
                    selToggleList(document.getElementById("close"), "ul", "li", "0");
                </script>

            </td>
        </tr>
        <tr>
            <td style="padding-bottom: 10px">
                <div style="height: 100%">
                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<%=_HwpToolbar%>", "");</script>

                </div>
            </td>
        </tr>
        <tr>
            <td height="20">
                <table class="file">
                    <tr>
                        <th><%=RM.GetString("t65")%></th>
                        <td>
                            <div id="lstAttachLink"></div>
                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0"></iframe>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
