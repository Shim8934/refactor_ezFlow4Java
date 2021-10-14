<%@ Page Language="c#" Inherits="Kaoni.ezStandard.ezSimsaG_Doc24" CodeFile="ezsimsag_Doc24.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title><%=RM.GetString("t257")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript"> var pNoneActiveX = "<%=NoneActiveX%>"; </script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <link type="text/css" rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>">
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAPRATTACH/attachG.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAprDocAttach/getDocAttach.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("ezSimsaG_Doc24.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
    <script type="text/javascript">
<%--         var pDocID = '<%=_DocID%>';
       var pDocHref = '<%=_DocHref%>';
        var pOrgDocID = '<%=_OrgDocID%>';--%>
        var pDocID = "<%=_DocID%>";
        var pDocHref = "";
        var pOrgDocID = "";
        var pDoc24Code ="<%=_DeptCode%>";
        var pDoc24Name ="<%=_DeptName%>";


        var pUserID;
        var flag = false;
        var flag2 = false;
        var stampFlag = false;
        var NostampFlag = false;
        var modeflag = false;
        var companyID = "<%=userinfo.CompanyID%>";
        var companyName = "<%=userinfo.CompanyName%>";
        var maxwidth = 659;
        var arr_userinfo = new Array();
        arr_userinfo[0] = "user";
        arr_userinfo[1] = "<%=userinfo.UserID%>";
        arr_userinfo[2] = "<%=userinfo.DisplayName%>";
        arr_userinfo[3] = "<%=userinfo.Title%>";
        arr_userinfo[4] = "<%=userinfo.DeptID%>";
        arr_userinfo[5] = "<%=userinfo.DeptName%>";
        arr_userinfo[6] = "<%=userinfo.Jikchek%>";
        arr_userinfo[8] = "<%=userinfo.Email%>";
        arr_userinfo[9] = companyID;
        arr_userinfo[11] = "<%=userinfo.DisplayName1%>";
        arr_userinfo[12] = "<%=userinfo.DisplayName2%>";
        arr_userinfo[13] = "<%=userinfo.Title1%>";
        arr_userinfo[14] = "<%=userinfo.Title2%>";
        arr_userinfo[15] = "<%=userinfo.DeptName1%>";
        arr_userinfo[16] = "<%=userinfo.DeptName2%>";
        pUserID = arr_userinfo[1];
        var is_Enc = "NONE";
        var isExternal = false;
        var isAddress = false;
        var APRDEPTXML = createXmlDom();
        var sealPath = "";
        var sealName = "";
        var attachName = new Array();
        var attachPath = new Array();
        var attachType = new Array();
        var encodePass = "";
        var encodePath = "";
        var attachxmlName = "";
        var attachxslName = "";
        var attachxmlPath = "";
        var attachxslPath = "";
        var attachbodyPath = "";
        var psignName = new Array();
        var psignPath = new Array();
        var psignCount = 1;
        var BaseURL = new Array();
        var AddInfo = new Array();
        var isGPKI = new Array();
        var sendCNT = new Array();
        var pDocInfoXML = createXmlDom();
        var pDomainName = document.location.protocol + "//" + document.location.hostname;
        var symbolPath = "";
        var symbolName = "";
        var logoPath = "";
        var logoName = "";
        var pAprType = "";
        var tempAttachSN = 0;
        var arrDelFiles = new Array();
        arrDelFiles[0] = "c:\\" + pDocID + ".xml";
        arrDelFiles[1] = "c:\\" + pOrgDocID + ".xml";
        var pUse_Editor = "<%= Use_Editor%>";
        var pNoneActiveX_Cross = "<%=NoneActiveX_Cross%>";  //메일보내기 엑티브엑스 사용체크(20161110)
        var pSpanCode = "<%=SpanCode_%>";  //소방기관코드(20170216)
        function btnPrint_onclick() {
            HwpCtrl.PrintDocument("", true);
        }

        function window_onbeforeunload() {
            try {
                window.opener.openergetDocInfo();
            } catch (e) { }
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

        function OpenAlertUI(pAlertContent) {
            var parameter = pAlertContent;
            var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            var RtnVal = window.showModelessDialog(url, parameter, feature);
        }

        function chk_Passwd(pPwd) {
            var parameter = pUserID
            var url = "/myoffice/ezApprovalG/ezchkPasswd.aspx";
            var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
            var ret = window.showModalDialog(url, parameter, feature);
            return ret
        }

        function window_onload() {
            try {
                window.onresize();
                HwpCtrl.SetSaveMode(1);
                
                var pFormHref="/Upload_ApprovalG/0000KFI/Form/2009000003.hwp";

                    showProgress("<%=RM.GetString("t368")%>");
                    var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pFormHref);
                    var isTrue = HwpCtrl.LoadFile(URL, false);
                FieldsAvailable(isTrue);

                HwpCtrl.SetFieldFocus("doctitle");
                HwpCtrl.ezSetScrollPosInfo(0);

            } catch (e) {
                alert("<%=RM.GetString("t1373")%>" + e.description);
                hideProgress();
            }
        }

        window.onresize = function () {
            HwpCtrl.style.height = null;
            HwpCtrl.height = document.documentElement.clientHeight - 150;
        }

        function setArrAttachInfo() {

            try {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();



                var objNode;

                createNodeInsert(xmlpara, objNode, "PARAMETER");
                //createNodeAndInsertText(xmlpara, objNode, "NODE", pOrgDocID);
                createNodeAndInsertText(xmlpara, objNode, "NODE", pDocID); //소방 수정 발송시 현재문서의 첨부파일 정보를 가져온다(20170208)
                //createNodeAndInsertText(xmlpara, objNode, "NODE", "END");
                createNodeAndInsertText(xmlpara, objNode, "NODE", "APR"); //소방 현재문서이기떄문에 진행문서 첨부 가져옴(20170208)


                xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getTotalAttachInfo.aspx", false);
                xmlhttp.send(xmlpara);

                var xmlRtn = loadXMLString(xmlhttp.responseText).selectNodes("LISTVIEWDATA/ROWS/ROW");

                if (xmlRtn.length > 0) {
                    var strAttach = " &nbsp ";
                    var rep = /'/g
                    for (i = 0; i < xmlRtn.length; i++) {

                        if (getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA4")).toLowerCase().indexOf("file") > -1) {
                            attachName[i] = getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA5"));
                            var SeqNum = escapenew(getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA2")));
                            attachPath[i] = getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA1"));
                            attachType[i] = "N";
                        } else {

                        }
                    }
                }
            } catch (e) {
                alert("ezsimsag_hwp.aspx.setArrAttachInfo()" + e.description);
            }
        }

        function FieldsAvailable(isTrue) {

            try {
                if (isTrue) {

                    ObjGPKI.ServerName = "ldap.gcc.go.kr";

                    //setAttachInfo(pOrgDocID, "END", lstAttachLink);
                   // setAttachInfo(pDocID, "APR", lstAttachLink);  //소방 수정 발송시 현재문서의 첨부파일 정보를 가져온다(20170208)

                    //setArrAttachInfo();
                    GetAprDeptXML();
                    GetExchInfo();

                    if ((attachxml.length > 0) && (attachxsl.length > 0)) {
                        btnXMLEdit.style.display = "";
                        attachxmlPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxml;
                        attachxmlName = attachxml.replace(PackDocID, "");
                        attachxslPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxsl;
                        attachxslName = attachxsl.replace(PackDocID, "");
                    }

                    hideProgress();


                    if (HwpCtrl.CheckFieldExist("sealsign")) {
                        var tmpSUrl = GetDocumentElement(HwpCtrl, "surl");

                        if (tmpSUrl != "") {
                            if (tmpSUrl == "/Upload_ApprovalG/SealImg/nostamp.gif")
                                NostampFlag = true;
                            //else
                                //stampFlag = true;
                        }
                    }
                                    if (HwpCtrl.CheckFieldExist("recipient")) {
                    HwpCtrl.SetFieldText("recipient", pDoc24Name);
                }
                    HwpCtrl.SetImgReg();

                } else {
                    hideProgress();
                    var pAlertContent = "<%=RM.GetString("t369")%>";
                    OpenAlertUI(pAlertContent);
                    HwpCtrl.ClearDocument();
                }
            } catch (e) {
                alert("ezsimsag_hwp.aspx.FieldsAvailable()" + e.description);
            }
        }

        function btnSetReceivLine_onclick() {
            var url = "/myoffice/ezApprovalG/ezDocInfo/ezReceiptInfo.aspx?pDocID=" + pDocID;
            var feature = "status:no;dialogWidth:540px;dialogHeight:230px;help:no;scroll:no;edge:sunken";
            var ret = window.showModalDialog(url, "", feature);
        }

        function btnOpinion_onclick() {
            //var parameter = new Array();
            //parameter[0] = pOrgDocID;
            //parameter[1] = "Show";

            //var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
            //var feature = "status:no;dialogWidth:530px;dialogHeight:520px;scroll:no;edge:sunken"
            //var ret = window.showModalDialog(url, parameter, feature);
        }

        function btnSend_onclick() {

            try {
                if (!stampFlag && !NostampFlag) {
                    var pAlertContent = "<%=RM.GetString("t216")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                var pInformationContent = "<%=RM.GetString("t205")%>";
                var Ans = OpenInformationUI(pInformationContent);
                if (!Ans) return;

                var chkpass = chk_Passwd(pUserID);
                if (chkpass == "False") {
                    var pAlertContent = "<%=RM.GetString("t27")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                } else if (chkpass == "cancel") {
                    return;
                }
                setArrAttachInfo(); //20190108 접수 회신 발송시 첨부파일도 발송되도록
                //SaveFile(); //소방 원문서 안바뀌도록 수정(20170213)

                var rtnVal = "FALSE";
                
                if (sendExt()) {
                    DeleteLocalFiles();
                    rtnVal = "TRUE";
                } else {
                    rtnVal = "FALSE";
                }

                if (rtnVal == "TRUE") {
                    HwpCtrl.SetFieldFocus("doctitle");

                    var pAlertContent = "<%=RM.GetString("t206")%>";
                    OpenAlertUI(pAlertContent);
                    setBtnDisable();
                } else {
                    var pAlertContent = "<%=RM.GetString("t217")%>";
                    OpenAlertUI(pAlertContent);
                }
            } catch (e) {
                alert("ezsimsag_hwp.aspx.btnSend_onclick()" + e.description);
            }
        }

        function DeleteLocalFiles() {

            var ezUtil = new ActiveXObject("EzUtil.MiscFunc");

            for (var i = 0 ; i < arrDelFiles.length ; i++) {
                ezUtil.UseUTF8 = true;
                ezUtil.DeleteFile(arrDelFiles[i]);
            }

            ezUtil = null;
        }

        function btnBoard_onclick() {
            if (!stampFlag && !NostampFlag) {
                var pAlertContent = "<%=RM.GetString("t216")%>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var pInformationContent = "<%=RM.GetString("t218")%><br><%=RM.GetString("t219")%>";
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans)
                return;

            SaveFile();

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
                        window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pOrgDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
                    }
                    else {
                        window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pOrgDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
                    }
                }
            }
        }

    <%--    function btnReject_onclick() {
            var pInformationContent = "<%=RM.GetString("t36")%>";
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans) return;

            var chkpass = chk_Passwd(pUserID);
            if (chkpass == "False") {
                var pAlertContent = "<%=RM.GetString("t27")%>";
                OpenAlertUI(pAlertContent);
                return;
            } else if (chkpass == "cancel") {
                return;
            }

            var ret = openOpinionUI("BanSong");
            if (ret != "cancel") {
                SaveFile();

                var xmlpara = createXmlDom();
                var xmlhttp = createXMLHttpRequest();



                var objNode;
                createNodeInsert(xmlpara, objNode, "PARAMETERS");
                createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
                createNodeAndInsertText(xmlpara, objNode, "SUserID", pUserID);


                xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendOfferReject.aspx", false);
                xmlhttp.send(xmlpara);

                if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE") {
                    var pAlertContent = "<%=RM.GetString("t256")%>";
                    OpenAlertUI(pAlertContent);
                    setBtnDisable();
                } else {
                    var pAlertContent = "<%=RM.GetString("t258")%>";
                    OpenAlertUI(pAlertContent);
                }
            }
        }--%>

        function openOpinionUI(ret) {
            var parameter = new Array();
            parameter[0] = pDocID;
            parameter[1] = ret;
            parameter[2] = "002";
            parameter[3] = pOrgDocID;

            var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
            var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no;help:no"
            var ret = window.showModalDialog(url, parameter, feature);
            return ret;
        }

        function SuccessBoard() {
            var rtnVal = SetContainer();
            if (rtnVal == "TRUE") {
                var pAlertContent = "<%=RM.GetString("t211")%>";
                OpenAlertUI(pAlertContent);
                setBtnDisable();
            } else {
                var pAlertContent = "<%=RM.GetString("t220")%>";
                OpenAlertUI(pAlertContent);
            }
        }

        function SetContainer() {
            //소방 수정 외부발송 문서 아닌 일반 수신문으로 발송시 시행문 DOCID 자체를 보낸다(20170731)
            if (isExternal == false && isAddress == false) {
                pOrgDocID = pDocID;
            }

            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();


            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "pOrgDocID", pOrgDocID);
            createNodeAndInsertText(xmlpara, objNode, "SUserID", pUserID);
            createNodeAndInsertText(xmlpara, objNode, "SUserName", arr_userinfo[11]);
            createNodeAndInsertText(xmlpara, objNode, "SDeptID", arr_userinfo[4]);
            createNodeAndInsertText(xmlpara, objNode, "SUserName2", arr_userinfo[12]);


            xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendOfferAprove.aspx", false);
            xmlhttp.send(xmlpara);

            return getNodeText(loadXMLString(xmlhttp.responseText))
        }

        function setBtnDisable() {
            //btnOpinion.style.display = "none";
            //btnSetReceivLine.style.display = "none";
            btnFileAttach.style.display = "none";
            btnStamp.style.display = "none";
            btnNoStamp.style.display = "none";
            btnSend.style.display = "none";
            btnBoard.style.display = "none";
            //btnReject.style.display = "none";
        }


        function SaveFile() {

            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();


            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            //createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);
            createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID); //원시행문 파일 변환(20170213)
            createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));


            xmlhttp.open("POST", "aspx/SaveEndFileHWP.aspx", false);
            xmlhttp.send(xmlpara);

            var xmlhttp2 = createXMLHttpRequest();
            var xmlpara = createXmlDom();


            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));


            xmlhttp2.open("POST", "aspx/SaveFileHWP.aspx", false);
            xmlhttp2.send(xmlpara);

            return xmlhttp.responseText;
        }


        function GetSealInfo() {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "Flag", "LIST");

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezSealInfo/aspx/GetSealList.aspx", false);
            xmlhttp.send(xmlpara);

            return loadXMLString(xmlhttp.responseText);
        }

        function GetDeptSealInfo() {
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();
            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "Flag", "LIST");
            createNodeAndInsertText(xmlpara, objNode, "DeptID", arr_userinfo[4]);

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezSealInfo/aspx/GetDeptSealList.aspx", false);
            xmlhttp.send(xmlpara);

            return loadXMLString(xmlhttp.responseText);
        }

        function btnStamp_onclick() {
            if (!HwpCtrl.CheckFieldExist("sealsign")) {
                var pAlertContent = "<%=RM.GetString("t201")%><br><%=RM.GetString("t191")%>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (!stampFlag) {

                var DeptSealXML = GetDeptSealInfo();
                var CompSealXML = GetSealInfo();

                if (DeptSealXML.selectNodes("ROWS/ROW").length > 0 && CompSealXML.selectNodes("ROWS/ROW").length > 0) {
                    var pInformationContent = "<%=RM.GetString("t192")%><BR><%=RM.GetString("t193")%>";
                    var Ans = OpenInformationUI(pInformationContent);
                    if (!Ans)
                        SealXML = CompSealXML;
                    else
                        SealXML = DeptSealXML;
                } else if (DeptSealXML.selectNodes("ROWS/ROW").length <= 0 && CompSealXML.selectNodes("ROWS/ROW").length <= 0) {
                    var pAlertContent = "<%=RM.GetString("t194")%><br><%=RM.GetString("t195")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    } else if (DeptSealXML.selectNodes("ROWS/ROW").length > 0) {
                        SealXML = DeptSealXML;
                    } else if (CompSealXML.selectNodes("ROWS/ROW").length > 0) {
                        SealXML = CompSealXML;
                    }

                var SealHref = getNodeText(SealXML.selectNodes("ROWS/ROW/CELL").item(0).selectSingleNode("DATA2"));
                var SealWidth = parseInt(getNodeText(SealXML.selectNodes("ROWS/ROW/CELL").item(1).selectSingleNode("VALUE")));
                var SealHeight = parseInt(getNodeText(SealXML.selectNodes("ROWS/ROW/CELL").item(2).selectSingleNode("VALUE")));

                if (HwpCtrl.CheckFieldExist("sealsign")) {
                    HwpCtrl.SetFieldText("sealsign", "");
                    HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SealHref), 6);
                    SetDocumentElement(HwpCtrl, "surl", SealHref);
                    SetDocumentElement(HwpCtrl, "swidth", SealWidth);
                    SetDocumentElement(HwpCtrl, "sheight", SealHeight);
                    stampFlag = true;
                }
            } else {
                if (HwpCtrl.CheckFieldExist("sealsign")) {
                    HwpCtrl.SetFieldText("sealsign", "");
                    HwpCtrl.SetFieldBackImage("sealsign", "");
                }
                stampFlag = false;
            }
        }

        function btnNoStamp_onclick() {
            var strimg;
            if (!HwpCtrl.CheckFieldExist("sealsign")) {
                var pAlertContent = "<%=RM.GetString("t201")%><br><%=RM.GetString("t191")%>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (!NostampFlag) {
                var SealHref = "/Upload_ApprovalG/SealImg/nostamp.gif"
                var SealWidth = 30;
                var SealHeight = 10;

                if (HwpCtrl.CheckFieldExist("sealsign")) {
                    HwpCtrl.SetFieldText("sealsign", "");
                    HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SealHref), 12);
                    NostampFlag = true;
                    SetDocumentElement(HwpCtrl, "surl", SealHref);


                    SetDocumentElement(HwpCtrl, "swidth", SealWidth);
                    SetDocumentElement(HwpCtrl, "sheight", SealHeight);
                }
            } else {
                if (HwpCtrl.CheckFieldExist("sealsign")) {
                    HwpCtrl.SetFieldText("sealsign", "");
                    HwpCtrl.SetFieldBackImage("sealsign", "");
                }
                NostampFlag = false;
            }
        }

        function getPixel(pLength) {
            try {
                var tempLength = parseInt(pLength);
                tempLength = tempLength * 7 / 2;
                return tempLength;

            } catch (e) {
                return 30;
            }
        }

        function PixelToMillimeter(size) {
            var Num;
            if (size.indexOf("mm") > -1) {
                Num = size;
            }
            else {
                Num = parseInt(size);
                try {
                    Num = (Num * 0.264583).toPrecision(5);
                } catch (e) {
                    alert(e.description);
                }
            }
            return Num;
        }

        function PointToMillimeter(strPoint) {
            var mmResult;
            if (strPoint.indexOf("mm") > -1) {
                mmResult = strPoint;
            }
            else {
                var mmResult = parseInt(strPoint);
                try {
                    //mmResult = (mmResult * 0.35277777).toPrecision(5);
                    mmResult = (mmResult * 0.264583).toPrecision(5);
                } catch (e) {
                    alert(e.description);
                }
            }
            return mmResult;
        }

        function Encode(text) {
            try {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;

                createNodeInsert(xmlpara, objNode, "PARAMETER");
                createNodeAndInsertText(xmlpara, objNode, "DEFAULTFONTFAMILY", "");
                createNodeAndInsertText(xmlpara, objNode, "DEFAULTFONTSIZE", "");
                createNodeAndInsertText(xmlpara, objNode, "CONTENT", text);
                xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/GetContentXml.aspx", false);
                xmlhttp.send(xmlpara);

                var Content = document.createElement("DIV");
                var pTemp = xmlhttp.responseXML;

                if (getNodeText(pTemp.getElementsByTagName("RESULT")[0]) === "OK") {
                    Content.innerHTML = getNodeText(pTemp.getElementsByTagName("CONTENT")[0]);
                }
                else {
                    alert(getNodeText(pTemp.getElementsByTagName("CONTENT")[0]));
                    return "";
                }

                // 태그는 GetContentXml페이지에서 처리하여 리턴되므로 Element의 Attribute중 필요없는 것만 제거한다.
                var ElementsRows = Content.getElementsByTagName("*");
                var ArrAttr = null;
                for (var Cnt = 0; Cnt < ElementsRows.length; Cnt++) {
                    switch (ElementsRows.item(Cnt).tagName) {
                        case "SUB":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "SUP":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "I":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "B":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "U":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "P":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "align":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }

                            var LastTag = ElementsRows.item(Cnt).outerHTML.substring(ElementsRows.item(Cnt).outerHTML.length - 4).toUpperCase();
                            if (LastTag != "</P>")
                                ElementsRows.item(Cnt).outerHTML = ElementsRows.item(Cnt).outerHTML + "</P>";
                            break;
                        case "UL":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "OL":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "LI":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "A":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "name":
                                    case "href":
                                    case "rel":
                                    case "rev":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "IMG":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "src":
                                    case "alt":
                                    case "name":
                                    case "longdesc":
                                    case "height":
                                    case "height_kaoni":
                                    case "width":
                                    case "width_kaoni":
                                    case "align":
                                    case "border":
                                    case "hspace":
                                    case "vspace":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TABLE":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "summary":
                                    case "width":
                                    case "width_kaoni":
                                    case "height":
                                    case "height_kaoni":
                                    case "border":
                                    case "cellspacing":
                                    case "cellpadding":
                                    case "align":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "CAPTION":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "align":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "COLGROUP":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "span":
                                    case "width":
                                    case "width_kaoni":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "COL":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "span":
                                    case "width":
                                    case "width_kaoni":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "THEAD":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TFOOT":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TBODY":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TR":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TH":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "abbr":
                                    case "axis":
                                    case "headers":
                                    case "scope":
                                    case "rowspan":
                                    case "colspan":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                    case "nowrap":
                                    case "width":
                                    case "width_kaoni":
                                    case "height":
                                    case "height_kaoni":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TD":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "abbr":
                                    case "axis":
                                    case "headers":
                                    case "scope":
                                    case "rowspan":
                                    case "colspan":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                    case "nowrap":
                                    case "width":
                                    case "width_kaoni":
                                    case "height":
                                    case "height_kaoni":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                    }
                }

                var rtnVal = Content.innerHTML.replace(/width_kaoni/g, "width").replace(/height_kaoni/g, "height");
                rtnVal = rtnVal.replace(/\r/g, "").replace(/\n/g, "").replace(/&nbsp; /g, "&nbsp;&nbsp;");
                return rtnVal;

                //return Content.innerHTML;
            } catch (e) {
                alert(e.description);
                return "</ERROR/>";
            }
        }

function GetHTMLBody(strHTML) {
    var objElem = document.createElement('div');
    try {
        objElem.innerHTML = strHTML;
        return objElem.innerHTML;
    } catch (e) {
        alert(e.description);
        return objElem.innerHTML;
    }
}

function PercentToMillimeter(strFontSize, strPercent) {
    var num1 = parseInt(strFontSize).toPrecision(5);
    var num2 = parseInt(strPercent).toPrecision(5);
    try {
        //var result = (((num1 * num2) * 0.352777778) / 100).toPrecision(5);
        var result = (((num1 * num2) * 0.264583) / 100).toPrecision(5);
        return result;
    } catch (e) {
        alert(e.description);
    }
        }
                function btnFileAttach_onclick() {
            try {
                var ret = openFileAttachUI();
            } catch (e) {
                alert("ezdraftui_hwp.aspx.btnFileAttach_onclick()::" + e.description);
            }
        }
    </script>
</head>
<body class="popup" onload="return window_onload()" style="overflow: hidden" onbeforeunload="return window_onbeforeunload()">
    <object id="oPoster" classid="clsid:19E224CA-6992-425C-8006-8FA6FD2BD9E5" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px" viewastext>
    </object>
    <object classid="clsid:80009476-666B-4869-8C04-AB03492561CD" id="ObjGPKI" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px" viewastext>
    </object>
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul>
                        <%-- <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><%=RM.GetString("t55")%></span></li> --%>
                        <%--<li id="btnSetReceivLine"><span onclick="return btnSetReceivLine_onclick()"><%=RM.GetString("t53")%></span></li>--%>
                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><%=RM.GetString("t56")%></span></li>
                        <li id="btnStamp"><span onclick="return btnStamp_onclick()"><%=RM.GetString("t213")%></span></li>
                        <li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><%=RM.GetString("t222")%></span></li>
                        <li id="btnSend"><span onclick="return btnSend_onclick()"><%=RM.GetString("t214")%></span></li>
                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><%=RM.GetString("t215")%></span></li>
                        <%--<li id="btnReject"><span onclick="return btnReject_onclick()"><%=RM.GetString("t49")%></span></li>--%>
                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><%=RM.GetString("t60")%></span></li>
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

                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "2", "1", "<%=_HwpToolbar%>", "1");</script>
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
