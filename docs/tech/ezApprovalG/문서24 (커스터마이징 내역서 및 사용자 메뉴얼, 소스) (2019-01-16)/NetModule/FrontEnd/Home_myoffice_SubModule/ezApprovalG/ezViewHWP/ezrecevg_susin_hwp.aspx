<%@ Page Language="c#" Inherits="Kaoni.ezStandard.ezRecevG_Susin_HWP" CodeFile="ezRecevG_Susin_HWP.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title><%=RM.GetString("t1308")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript"> var pNoneActiveX = "<%=NoneActiveX%>"; </script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css">
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/docnum/Recvdocnumber_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("ezRecevG_Susin_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/printer/appandbody.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("ezRecevG_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAprDocAttach/getDocAttach.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/CheckLines.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/AutoAprLine.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/ezApprovalG/js/SendMailApprove.js") %>"></script>
    <script type="text/javascript">
        var pWriterDeptID;
        var pDocID = '<%=_DocID%>';
        var pFormHref = new String("");
        var pFormID = new String();
        var zFormID = new String();
        var pUserID = "<%=userinfo.UserID%>";
    var pHasAttachYN = new String("N");
    var pHasOpinionYN = new String("N");
    var CurrentDate
    var flag = false;
    var fieldflag = false;
    var xmlhttp = createXMLHttpRequest();
    var xmldoc = createXmlDom();
    var xmluserInfo = createXmlDom();
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
    var IsSkipDrafter
    var badForm = false;
    var g_docnumber = "";
    var docAccess = false;
    var pCurSelRow;
    var pSusinDocURL = "";
    var pOrg_orgDocID = '<%=_orgDocID%>';
    var chkOK = false;
    var isReDraft = '<%=_isReDraft%>';
    var LastSignNo;
    var AppendFileAttach = "";
    var AppenAprDocAttachList = "";
    var btnSendDraftEnable = "false";
    var gPublic = "";
    var s_nCallCnt = false;
    var sCompanyID = '<%=userinfo.CompanyID%>';
    var CurAprType = "";
    var NextAprType = "";
    var arr_userinfo = new Array();
    arr_userinfo[0] = "user";
    arr_userinfo[1] = "<%=userinfo.UserID%>";
    arr_userinfo[2] = "<%=userinfo.DisplayName%>";
        arr_userinfo[3] = "<%=userinfo.Title%>";
        arr_userinfo[4] = "<%=userinfo.DeptID%>";
        arr_userinfo[5] = "<%=userinfo.DeptName%>";
        arr_userinfo[6] = "<%=userinfo.Jikchek%>";
        arr_userinfo[8] = "<%=userinfo.Email%>";
        arr_userinfo[9] = sCompanyID;
        arr_userinfo[11] = "<%=userinfo.DisplayName1%>";
        arr_userinfo[12] = "<%=userinfo.DisplayName2%>";
        arr_userinfo[13] = "<%=userinfo.Title1%>";
        arr_userinfo[14] = "<%=userinfo.Title2%>";
        arr_userinfo[15] = "<%=userinfo.DeptName1%>";
        arr_userinfo[16] = "<%=userinfo.DeptName2%>";
        var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "", pLimitRange = "", pPageNum = "1";
        var cabinetID = "";
        var TaskCode = "";
        var DocNumCode = "";
        var SummaryFlag = false;
        var pDocTitle = "";
        var pDocNumCode, pOrgDocNumCode, pDocNo;
        var maxwidth = 659;
        var KuyjeType = "002";
        var signDateFormat = "<%=_optSignDateFormat%>";
        var isSplit = "<%=_optisSplit%>";
        var SplitKind = "<%=_optSplitKind%>";
        var sihangURL = "<%=_sihangURL%>";
        var pReadPC = false;
        var arrDelFiles = new Array();
        var g_DraftFlag = "<%=_DraftFlag%>";
        var g_RetFlag = "<%=_RetFlag%>";
        var SignType = new Array();
        var SignName = new Array();
        var SignContent = new Array();
        var isExtDoc = "N";
        var pGubun;
        var pUse_Editor = "<%= Use_Editor%>";
        var g_szUserID = arr_userinfo[8];
        var g_senderinfo = "<%= userinfo.CompanyName + ", " + userinfo.DeptName + ", " + userinfo.Title %>";
    var pPassAproveUseYN = "<%= _pPassAproveUseYN%>"; // 20161027 소방 기결재통과
        var pAprTempLine;
        var pDeptAuth = "<%= pDeptAuth%>"; // 20161025 소방 비공개문서 부서원공개
        var connkey = "<%=connkey%>"; //연동키 추가(20161107)
        var ExcuteFlag = "N"; //연동시점 중복 제거(20161103)
        var pNoneActiveX_Cross = "<%=NoneActiveX_Cross%>";  //메일보내기 엑티브엑스 사용체크(20161110)
        var ImageFormInfo = "<%=ImageInfo%>"; //소방 서명양식 사인 분기처리 (20161118)

        function process_AfterOpen() {
            try {
                if (pFormHref == "") {

                    //SetBtnStateFalse(); //소방임시 주석(20170208)
                    GetAprDocFormID();
                    setAttachInfo(pDocID, "APR", lstAttachLink);
                    getDocInfo();
                }
                else {

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
                                pInformationContent = "<%=RM.GetString("t124")%><br> <%=RM.GetString("t10")%>";
                        else
                            pInformationContent = "<%=RM.GetString("t126")%><br> <%=RM.GetString("t10")%>";

                        Ans = OpenInformationUI(pInformationContent);
                        if (Ans)
                            openOpinionUI("Display");
                    }

                }
                else if (pDraftFlag == "SUSIN" || pDraftFlag == "GONGRAM") {
                    var len;
                    len = pFormHref.lastIndexOf("/");

                    GetAprDocFormID();
                    setAttachInfo(pDocID, "APR", lstAttachLink);
                    getDocInfo();


                    if (g_DraftFlag == "REDRAFT") {
                        setMenuBar("btnAssign", false);
                        //setMenuBar("btnDistribute", false); //소방 배부문서 반송일경우 타부서 배부 가능하도록 수정(20171110)
                    }


                    if (g_RetFlag == "Y") {
                        btnReturn_onclick();
                    }
                    else {
                        if (pHasOpinionYN == "Y") {
                            var pInformationContent;
                            var Ans;

                            pInformationContent = "<%=RM.GetString("t126")%><br> <%=RM.GetString("t10")%>";
                            Ans = OpenInformationUI(pInformationContent);

                            if (Ans)
                                openOpinionUI("Display");
                        }
                    }
                }
                else if (pDraftFlag == "HAPYUI") {
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

                        pInformationContent = "<%=RM.GetString("t126")%><br> <%=RM.GetString("t10")%>";
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
                    //if (pDocID != "") { //소방 수정(20170306)
                    //    SignCheck();
                    //}
    }
}
    catch (e) {
        alert("process_AfterOpen : " + e.description);
    }
}


function setAutoProperty() {
    try {

        getDraftUserInfo();

        SetAutoPropertyValue();

        var rtnVal = ExcuteInfo("INIT", "")
        if (!rtnVal) {
        }
    }
    catch (e) {
        alert("setAutoProperty : " + e.description);
    }
}

window.onresize = function () {
    HwpCtrl.style.height = null;
    HwpCtrl.height = document.documentElement.clientHeight - 150;
}

function window_onload() {
    window.onresize();
    HwpCtrl.SetSaveMode(1);
    try {
        IsSkipDrafter = "FALSE"
        SetBtnStateTrue();

        getReceiveDocInfo();

        if (pSusinDocURL != "") {
            if (pSusinDocURL == "PC") {

                HwpCtrl.LoadFile("", false);
                pReadPC = true;
            }
            else {
                showProgress("<%=RM.GetString("t368")%>");
                URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pSusinDocURL);
                var isTrue = HwpCtrl.LoadFile(URL, false);

                FieldsAvailable(isTrue);
            }
        }

        else {
            showProgress("<%=RM.GetString("t1402")%>");
            URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pRelayURL);
            var isTrue = HwpCtrl.LoadFile(URL, false);
            FieldsAvailable(isTrue);
        }
        if (pFormID == "2006000001") { //소방 중계문서 본문 수정하도록 수정(20170209)
            setMenuBar("btnEdit", true);
        }


        HwpCtrl.ChangeMode(3);

        HwpCtrl.SetFieldFocus("doctitle");
        HwpCtrl.ezSetScrollPosInfo(0);
    }
    catch (e) {
        alert("<%=RM.GetString("t1373")%>" + e.description);
        hideProgress();
    }
}

function FieldsAvailable(isTrue) {
    if (needDoubleFormFlag) {
        var tempFlag = getExtInfo();
        if (tempFlag) {
            process_AfterOpen();
            setAutoProperty();
            SetBtnStateTrue();
            hideProgress();
        }
        else {
            hideProgress();
            var pAlertContent = "<%=RM.GetString("t1403")%>";
            OpenAlertUI(pAlertContent);
            chkBtnConfirm("1");

            return;
        }
    }
    else {
        if (pFormHref == "") {
            var isRelay = GetRelayDocInfo();
            if (isRelay) {
                try {
                    //document.getElementById("btnReqReSend").style.display = "";
                    if (getNodeText(pRelayDocInfo.getElementsByTagName("isPKI").item(0)) == "Y") {
                        hideProgress();

                        if (!getPasswdEnd()) {
                            var pAlertContent = "<%=RM.GetString("t1404")%><br> <%=RM.GetString("t1405")%>";
                            OpenAlertUI(pAlertContent);
                            chkBtnConfirm("1");
                        }
                        else {
                            var emlName = getNodeText(pRelayDocInfo.getElementsByTagName("emlURL").item(0));
                            if (!decodeUp(emlName)) {
                                hideProgress();
                                chkBtnConfirm("1");
                                return;
                            }
                        }
                    }
                    var tempFlag = getExtInfo();
                    if (tempFlag) {
                        process_AfterOpen();
                        setAutoProperty();
                        SetBtnStateTrue();
                        hideProgress();
                    }
                    else {
                        document.getElementById("btnRefresh").style.display = "";
                        if (!needDoubleFormFlag) {
                            hideProgress();
                            var pAlertContent = "<%=RM.GetString("t1403")%>";
                            OpenAlertUI(pAlertContent);
                            chkBtnConfirm("1");
                            return;
                        }
                    }
                } catch (e) {
                    document.getElementById("btnRefresh").style.display = "";
                }
            }
            else {
                hideProgress();
                chkBtnConfirm("1");
                document.getElementById("btnRefresh").style.display = "";
                return;
            }
        }
    }

    if (isTrue) {
        pGubun = "11";

        SetReceiptNumber();
        hideProgress();
        setMenuBar("btnEdit", false);
        //process_AfterOpen();
        setAutoProperty();
        setFirstDrafter();
        process_AfterOpen(); //소방 회송팝업이 나중에 나오도록(20170714)

        if (SignCount < 1) {
            pGubun = "12";
            btnSetAprLine.style.display = "none";
            btnSendDraft.style.display = "none";
            setNodeText(btnRJunkyul.childNodes[0], "<%=RM.GetString("t1406")%>");

            if (pDocType == "001") {
                btnReturn.style.display = "none";

                var NewIsRelay = GetRelayDocInfo();
                //if (NewIsRelay) {
                //    btnReqReSend.style.display = "";
                //} else {
                //    btnReqReSend.style.display = "none";
                //}

                if (pAprState == "011") {
                    btnDistribute.style.display = "";
                    btnReDistribute.style.display = "none";
                    btnAssign.style.display = "";
                    btnReAssign.style.display = "none";
                }
                else if (pAprState == "012") {
                    btnDistribute.style.display = "none";
                    btnReDistribute.style.display = "none";
                    btnAssign.style.display = "none";
                    btnReAssign.style.display = "";
                }
                else if (pAprState == "014") {
                    btnDistribute.style.display = "none";
                    btnReDistribute.style.display = "";
                    btnAssign.style.display = "";
                    btnReAssign.style.display = "none";
                }
            }
        }

        getGongRamDocInfo();

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml");

        if (!g_SepAttachLVXml)
            g_SepAttachLVXml = "";

        SetDocumentElement(HwpCtrl, "SepAttachLVXml", SetSepAttParamXmlNull(g_SepAttachLVXml))

        if (pReadPC) {
            var DocumentInfo = createXmlDom();
            DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());
            if (DocumentInfo.getElementsByTagName("TITLE").length > 0) {
                if (getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0)) == "")
                    pFormID = getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0));
            }
        }
    }
    else {
        hideProgress();
        var pAlertContent = "<%=RM.GetString("t369")%>";
        OpenAlertUI(pAlertContent);
        HwpCtrl.ClearDocument();
    }
    HwpCtrl.SetImgReg();
}

function btnSetAprLine_onclick() {
    var ret;
    if (SignCount < 1) {
        var pAlertContent = "<%=RM.GetString("t1407")%>";
        OpenAlertUI(pAlertContent);
        return
    }

    ret = openAprLineUI();
    if (ret[0] != "cancel" && ret[3] != "cancel") {
        btnSendDraftEnable = "true"
        IsSkipDrafter = "FALSE";
        btnSendDraft.Enable = "true";
        GetDraftAprLineInfo(ret);
    }
    else {
        if (ret[2] == "cancel") {
            var pAlertContent = "<%=RM.GetString("t127")%>";
            OpenAlertUI(pAlertContent);
            return;
        }
    }
}

function btnSetReceivLine_onclick() {
    try {
        var ret = openReceivUI();
        if (ret != "cancel") {
            setRecevInfo(ret);
        }
    }
    catch (e) {
        alert("btnSetReceivLine_onclick : " + e.description);
    }
}


function btnSendDraft_onclick() {
    try {
        var rtnSignInfo;
        if (btnSendDraftEnable == "false") {
            var pAlertContent = "<%=RM.GetString("t1408")%>";
            OpenAlertUI(pAlertContent);
            return;
        }

        if (!checkLines())
            return;


        try {
            var pSusinNextSN = 0;


            if (pSusinSN)
                pSusinNextSN = parseInt(pSusinSN, 10) + 1;
            else
                pSusinNextSN = 1;

            var fieldname = pSusinNextSN + "sign1";
            if (HwpCtrl.CheckFieldExist(fieldname) && CheckDeptLinesXML == "") {
                var pInformationContent = "<%=RM.GetString("t1409")%><br><br>" +
							"<%=RM.GetString("t1410")%>";
                var Ans = OpenInformationUI(pInformationContent);

                if (Ans) {
                    btnSetReceivLine_onclick();
                }
            }
        }
        catch (e) { }

        if (cabinetID == "")
            btnApprovalInfo();

        if (cabinetID == "") {
            var pAlertContent = "<%=RM.GetString("t134")%>";
            OpenAlertUI(pAlertContent);
            return;
        }

        var g_SepAttachLVXml = "";
        g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml")
        if (!g_SepAttachLVXml)
            g_SepAttachLVXml = "";

        if (!CheckSepAttParamXmlNull(g_SepAttachLVXml)) {
            var pAlertContent = "<%=RM.GetString("t1411")%>";
            OpenAlertUI(pAlertContent);
            return;
        }


        if (g_DraftFlag == "REDRAFT")
            delOpinionInfo();

        if (HwpCtrl.CheckFieldExist("doctitle"))
            pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
        else
            pDocTitle = "<%=RM.GetString("t1394")%>";
        if (pDocTitle == "") {
            var pAlertContent = "<%=RM.GetString("t1412")%>";
            OpenAlertUI(pAlertContent);
            return;
        }
        else {
            if ("<%=GetApprovalPWD() %>" != "N") {
                var chkpass = chk_Passwd();
                if (chkpass == "False") {
                    var pAlertContent = "<%=RM.GetString("t1383")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (chkpass == "cancel") {
                    var pAlertContent = "[<%=RM.GetString("t1413")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
            }

            //20161027 소방 기결재통과시 기안상신시점에 결재선 저장
            if (pPassAproveUseYN == "Y" && pDraftFlag == "REDRAFT") {
                var savexmlhttp = createXMLHttpRequest();
                savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false);
                savexmlhttp.send(pAprTempLine);

                var dataNodes = GetChildNodes(loadXMLString(savexmlhttp.responseText));
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
                    var pAlertContent = "[<%=RM.GetString("t1413")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }


                if (getLastAprLine() == false) {
                    var pAlertContent = "<%=RM.GetString("t1414")%><br>" +
										"<%=RM.GetString("t1415")%>";
                    OpenAlertUI(pAlertContent);
                    try {
                        btnSetAprLine_onclick();
                    }
                    catch (e) { }
                    return;
                }

                pOrgHtml = HwpCtrl.GetCloneData("", "HWP");

                if (LastSignSN == 1) {
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_BEFORE", "")

                    if (!rtnVal) {
                        var pAlertContent = "[<%=RM.GetString("t69")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                }


                if (LastSignSN == 1) {
                    var rtnVal;
                    rtnVal = ExcuteInfo("DOCNUM_AFTER", "")
                    if (!rtnVal) {
                        var pAlertContent = "[<%=RM.GetString("t69")%>";
                          OpenAlertUI(pAlertContent);
                          return;
                      }
                  }


                  if (LastSignSN == 1) {
                      var rtnVal = ExcuteInfo("LAST_SEND_BEFORE", "")
                      if (!rtnVal) {
                          return;
                      }
                  }

                  if (SignCount >= 1) {
                      rtnSignInfo = SendDraftMappingSign(ret);
                  }
              }




            //if (LastSignSN == 1) {
                var rtnval = true;
                rtnval = getRecvDocNumber(arr_userinfo[4]);
                if (!rtnval) {
                    var pAlertContent = "[접수 문서번호]를 가져오지 못했습니다!";
                    OpenAlertUI(pAlertContent);

                    return;
                }
            //}



              if (LastSignSN != 1) {
                  var rtnVal = ExcuteInfo("LAST_APR_BEFORE", "")
                  if (!rtnVal) {
                      return;
                  }
              }
              if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
                  var RtnVal;
                  var pAlertContent;
                  RtnVal = setSusinUpdataDocID();

                  if (RtnVal == "TRUE") {
                      if (LastSignSN != 1) { //수신시점 중복으로 타는 부분 수정(20161104)
                          RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "")
                          if (!RtnVal) {
                              pAlertContent = "[<%=RM.GetString("t69")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    }
                    if (RtnVal) RtnVal = SaveDraftDocInfo();
                    if (RtnVal == "TRUE") {
                        if (LastSignSN != 1) { //수신시점 중복으로 타는 부분 수정(20161104)
                            RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "")
                            if (!RtnVal) {
                                pAlertContent = "[<%=RM.GetString("t69")%>";
                                  OpenAlertUI(pAlertContent);
                                  return;
                              }
                          }

                          if (LastSignSN == 1) {
                              RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "")
                              if (!RtnVal) {
                                  pAlertContent = "[<%=RM.GetString("t69")%>";
                                  OpenAlertUI(pAlertContent);
                                  return;
                              }

                              RtnVal = ExcuteInfo("LAST_END_AFTER", "")
                              if (!RtnVal) {
                                  var pAlertContent = "[<%=RM.GetString("t69")%>";
                                  OpenAlertUI(pAlertContent);
                                  return;
                              }
                              SendMailToDrafter();
                          }
                          else {
                              sendAlertMail("APR", "1", "RECEV_END");
                          }

                          if (LastSignSN == 1)
                              pAlertContent = "<%=RM.GetString("t1416")%>";
                          else
                              pAlertContent = "<%=RM.GetString("t1417")%>";
                          OpenAlertUI(pAlertContent);
                          chkOK = true;
                          window.close();
                      }
                      else {
                          UndoSignInfo(rtnSignInfo);


                          if (LastSignSN == 1) {
                              RtnVal = ExcuteInfo("END_FAIL", "")
                              if (!RtnVal) {
                                  pAlertContent = "[<%=RM.GetString("t69")%>";
                                  OpenAlertUI(pAlertContent);
                                  return;
                              }
                          }
                          pAlertContent = "[<%=RM.GetString("t1418")%>";
                          OpenAlertUI(pAlertContent);
                          return;
                      }
                  }
                  else {
                      UndoSignInfo(rtnSignInfo);


                      if (LastSignSN == 1) {
                          RtnVal = ExcuteInfo("END_FAIL", "")
                          if (!RtnVal) {
                              pAlertContent = "[<%=RM.GetString("t69")%>";
                              OpenAlertUI(pAlertContent);
                              return;
                          }
                      }

                      SetBtnStateTrue();
                      btnSendDraft.Enable = "true";

                      pAlertContent = "[<%=RM.GetString("t1418")%>";
                      OpenAlertUI(pAlertContent);
                      return;
                  }
              }
              else {
                  var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "")
                  var pAlertContent;

                  if (!RtnVal) {
                      pAlertContent = "[<%=RM.GetString("t69")%>";
                      OpenAlertUI(pAlertContent);
                      return;
                  }

                  RtnVal = SaveDraftDocInfo();
                  if (RtnVal == "TRUE") {
                      RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "")
                      if (!RtnVal) {
                          pAlertContent = "[<%=RM.GetString("t69")%>";
                          OpenAlertUI(pAlertContent);
                          return;
                      }


                      if (LastSignSN == 1) {
                          RtnVal = ExcuteInfo("DOCNUM_END", "")
                          if (!RtnVal) {
                              pAlertContent = "[<%=RM.GetString("t69")%>";
                              OpenAlertUI(pAlertContent);
                              return;
                          }
                      }

                      pAlertContent = "<%=RM.GetString("t1417")%>";
                      OpenAlertUI(pAlertContent);
                      chkOK = true;
                      window.close();
                  }
                  else {
                      UndoSignInfo(rtnSignInfo);


                      if (LastSignSN == 1) {
                          RtnVal = ExcuteInfo("END_FAIL", "")
                          if (!RtnVal) {
                              pAlertContent = "[<%=RM.GetString("t69")%>";
                              OpenAlertUI(pAlertContent);
                              return;
                          }
                      }
                      SetBtnStateTrue();
                      pAlertContent = "[<%=RM.GetString("t1418")%>";
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




  function getLastAprLine() {
      try {
          var xmlhttp = createXMLHttpRequest();
          var xmlpara = createXmlDom();



          var objNode;
          createNodeInsert(xmlpara, objNode, "PARAMETER");
          createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
          createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
          createNodeAndInsertText(xmlpara, objNode, "pFormID", pFormID);

          xmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/AprLineRequest.aspx", false);
          xmlhttp.send(xmlpara);

          var NodeList = loadXMLString(xmlhttp.responseText).selectNodes("LISTVIEWDATA/ROWS/ROW");
          if (NodeList.length > 0) {
              var bResult = CheckFirstDrafter(loadXMLString(xmlhttp.responseText));
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
      var AprLineRow = APRLINE.selectNodes("LISTVIEWDATA/ROWS/ROW");
      var CurListLen = AprLineRow.length;
      var i;
      var AprLineTotalLen;
      var pCheckUserID = "";

      for (var i = 0 ; i < CurListLen; i++) {
          if (i == CurListLen - 1) {
              pCheckUserID = trim(getNodeText(AprLineRow.item(i).selectNodes("CELL").item(0).selectSingleNode("DATA4")));



              if (pCheckUserID == pUserID)
                  return true;
              else
                  return false;

              break;
          }
      }

      return true;
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


  function btnSave_onclick() {
      HwpCtrl.SetDocumentInfo(pFormID);
      HwpCtrl.SaveFile("");
  }


  function btnPrint_onclick() {
      HwpCtrl.PrintDocument("", true);
  }

  function btnClose_onclick() {
      window.close();
  }

  function window_onbeforeunload() {
      try {
          window.opener.openergetDocInfo();
          if (!chkOK) {

              if (isReDraft == "N")
                  delDocInfo();
          }
      }
      catch (e) { }

      try {
          window.opener.Refresh_Window();
      }
      catch (e) { }


      DeleteLocalFiles();
  }


  function DeleteLocalFiles() {
      var ezUtil = new ActiveXObject("EzUtil.MiscFunc");

      for (var i = 0 ; i < arrDelFiles.length ; i++) {
          ezUtil.UseUTF8 = true;
          ezUtil.DeleteFile(arrDelFiles[i]);
      }

      ezUtil = null;
  }


  function btnDistribute_onclick() {
      var parameter = new Array();
      parameter[0] = pDocID;
      parameter[1] = pSusinSN;
      parameter[2] = arr_userinfo[4];
      parameter[3] = pAprState;
      parameter[4] = getNodeText(RECEIPTDEPTID);

      var url = "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveDistributeUI.aspx";
      var feature = "status:no;dialogWidth:1000px;dialogHeight:740px;edge:sunken;scroll:no"
      var ret = window.showModalDialog(url, parameter, feature);
      if (ret == "true") {
          var pAlertContent = "<%=RM.GetString("t1419")%>";
          OpenAlertUI(pAlertContent);
          btnClose_onclick();
      }
  }


  function btnAssign_onclick() {
      var parameter = new Array();
      parameter[0] = pDocID;
      parameter[1] = pSusinSN;
      parameter[2] = pAprState;

      var url = "/myoffice/ezApprovalG/ezAPRRECEIVE/ezReceiveAssignUI_Cross.aspx";
      var feature = "status:no;dialogWidth:460px;dialogHeight:365px;edge:sunken;scroll:no"
      var ret = window.showModalDialog(url, parameter, feature);
      if (ret == "OK") {
          var pAlertContent = "<%=RM.GetString("t1420")%>";
          OpenAlertUI(pAlertContent);
          btnClose_onclick();
          return;
      }
  }

        function GetFormID() {
            try {
                var objRoot;
                var objNode;

                var xmlpara = createXmlDom();
                var xmlhttp = createXMLHttpRequest();

                var objNode;
                createNodeInsert(xmlpara, objNode, "PARAMETER");
                createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);

                xmlhttp.open("Post", "/myOffice/ezApprovalG/DraftUI/aspx/GetAprDocFormID.aspx", false);
                xmlhttp.send(xmlpara);

                var pFormID = getNodeText(loadXMLString(xmlhttp.responseText).childNodes(0));
                return pFormID;

            } catch (e) {
                alert(e.description);
            }
        }


        function btnReturn_onclick() {

            // 20170904 formid 체크, 유통 문서이면 popup 창을 띠운다
            var formID = GetFormID();;
            if (formID == '2006000001') {
                if (!confirm('본 문서를 발신처(외부기관)로 반송하시겠습니까? 타부서로 전달하시려면 배부 기능을 이용해주세요.')) {
                    return;
                }
            }

            var pDocSN = "";
            if (HwpCtrl.CheckFieldExist("receiptnumber")) {
                var fieldValue = trim(HwpCtrl.GetFieldText("receiptnumber"));
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

            var url = "/myoffice/ezApprovalG/ezAPROPINION/AprOpinion.aspx";
            var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no;help:no"
            var ret = window.showModalDialog(url, parameter, feature);
            var hesongok = true;

            if (ret != "cancel") {
                setButtonReceiveTrue();

                if (pDocSN != "")
                    hesongok = setCabinetHeSong(pDocSN);

                if (hesongok) {
                    hesongok = setHeSongDocInfo();
                    if (hesongok) {

                        var ret2 = ExcuteInfo("SUSIN_HOISONG_AFTER", "")
                        if (!ret2) {
                            pAlertContent = "[<%=RM.GetString("t69")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }

                        window.parent.close();

                        btnClose_onclick();
                    }
                }
            }
        }

  var modeflag = true;
  function btnEdit_onclick() {
      if (modeflag) {
          modeflag = false;
          chkBtnConfirm("1");

          beforeHtml = HwpCtrl.GetCloneData("", "HWP");;
          HwpCtrl.ChangeMode(2);

          setNodeText(btnEdit.childNodes[0], "<%=RM.GetString("t42")%>");
    }
    else {
        var pInformationContent = "<%=RM.GetString("t43")%>";
        var Ans = OpenInformationUI(pInformationContent);

        HwpCtrl.ChangeMode(3);
        setNodeText(btnEdit.childNodes[0], "<%=RM.GetString("t44")%>");
        if (Ans) {
        }
        else {
            HwpCtrl.SetCloneData(beforeHtml, "", "HWP");
        }
        modeflag = true;
        chkBtnConfirm("2");
    }
}

function btnRJunkyul_onclick() {
    var Resultxml;

    var UserID = '<%=userinfo.UserID%>';
      var DisplayName = '<%=userinfo.DisplayName%>';
      var DepID = '<%=userinfo.DeptID%>';
      var DeptName = '<%=userinfo.DeptName%>';
      var Position = '<%=userinfo.Title%>';
      var CompanyID = '<%=userinfo.CompanyID%>';

      var d = new Date();
      var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();

      Resultxml = "<LISTVIEWDATA><HEADERS>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t1421")%></NAME><WIDTH>30</WIDTH></HEADER>";
    Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t379")%></NAME><WIDTH>50</WIDTH></HEADER>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t230")%></NAME><WIDTH>60</WIDTH></HEADER>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t108")%></NAME><WIDTH>80</WIDTH></HEADER>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t380")%></NAME><WIDTH>80</WIDTH></HEADER>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t381")%></NAME><WIDTH>80</WIDTH></HEADER>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t382")%></NAME><WIDTH>80</WIDTH></HEADER>";
      Resultxml = Resultxml + "<HEADER><NAME><%=RM.GetString("t383")%></NAME><WIDTH>80</WIDTH></HEADER>";
      Resultxml = Resultxml + "</HEADERS><ROWS><ROW>";
      Resultxml = Resultxml + "<COLUMN>1</COLUMN>";
      Resultxml = Resultxml + "<COLUMN>" + DisplayName + "</COLUMN>";
      Resultxml = Resultxml + "<COLUMN>" + Position + "</COLUMN>";

      Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(DeptName) + "</COLUMN>";
      Resultxml = Resultxml + "<COLUMN><%=RM.GetString("t25")%></COLUMN>";
    Resultxml = Resultxml + "<COLUMN><%=RM.GetString("t1422")%></COLUMN>";
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

      xmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false);
      xmlhttp.send(Resultxml);

      if (xmlhttp.responseText) {
          var retvalue = new Array();
          retvalue[0] = Resultxml;
          retvalue[1] = "NONE";
          retvalue[2] = "R";
          retvalue[3] = "";

          GetDraftAprLineInfo(retvalue);
          btnSendDraftEnable = "true";
          CurAprType = "<%=RM.GetString("t25")%>";
        LastSignSN = "1";
        btnSendDraft_onclick();
    }
    else {
        var pAlertContent = "<%=RM.GetString("t1423")%>";
        OpenAlertUI(pAlertContent);
    }
}

        function btnMail_onclick() { //소방 엑티브엑스 처리(20161110)
            if (pNoneActiveX_Cross == "YES") {
                window.open("/myoffice/ezEmail/mail_write_Cross.aspx?DocHref=" + pFormHref + "&cmd=docsend&DocID=<%=_DocID%>" + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
            }
            else {
                window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=" + pFormHref + "&cmd=docsend&DocID=<%=_DocID%>" + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
            }
        }

var tempSecurity = "";
var tempKeep = "";
var tempUrgent = "N";
var tempPublic = "Y";
var tempKeyword = "";
var tempItemCode = "";
var tempItemName = "";
var tempdocnumcode = "<%=RM.GetString("t45")%>";

var tempSecurityDate = "";

function btnDocInfo_onclick() {
    var parameter = new Array();
    parameter[0] = tempSecurity;
    parameter[1] = tempUrgent;
    parameter[2] = pSummery;
    parameter[3] = pSpecialRecordCode;
    parameter[4] = pPublicityCode;
    parameter[5] = pLimitRange;
    parameter[6] = pPageNum;

    parameter[7] = tempSecurityDate;

    var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG.aspx";
    var feature = "status:no;dialogWidth:430px;dialogHeight:605px;help:no;scroll:no;edge:sunken;";
    var RtnVal = window.showModalDialog(url, parameter, feature);

    tempSecurity = RtnVal[0];
    tempUrgent = RtnVal[1];
    pSummery = RtnVal[2];
    pSpecialRecordCode = RtnVal[3];
    pPublicityCode = RtnVal[4];
    pLimitRange = RtnVal[5];
    pPageNum = RtnVal[6];

    tempSecurityDate = RtnVal[7];

    SummaryFlag = true;
}

function btnSendAround_onclick() {





    var para = new Array();
    para[0] = pDocID;
    var url = "/myoffice/ezApprovalG/ReceivUI/AprGongRamLine.aspx";
    var feature = "dialogWidth:557px;dialogHeight:535px;scroll:no;resizable:yes;status:no;help:no;edge:sunken";
    var rtn = window.showModalDialog(url, para, feature);
    if (rtn == "OK") {
        var pAlertContent = "<%=RM.GetString("t1424")%>";
        OpenAlertUI(pAlertContent);
        JiJungBeBuDisable();
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


        xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/setReJijung.aspx", false);
        xmlhttp.send(xmlpara);

        if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE") {
            var pAlertContent = "<%=RM.GetString("t1425")%>";
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


        xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/setReBebu.aspx", false);
        xmlhttp.send(xmlpara);

        if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE") {
            var pAlertContent = "<%=RM.GetString("t1426")%>";
            OpenAlertUI(pAlertContent);
            btnClose_onclick();
        }
    }
}

function JiJungBeBuDisable() {
    btnAssign.style.display = "none";
    btnDistribute.style.display = "none";
    btnReturn.style.display = "none";
}


function getGongRamDocInfo() {
    try {
        var objRoot;
        var objNode;

        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();


        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);


        xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/GongRamDocInfo.aspx", false);
        xmlhttp.send(xmlpara);

        var pGongRamDocID = getNodeText(loadXMLString(xmlhttp.responseText));
        if (pGongRamDocID != "NONE" && pGongRamDocID != "" && pGongRamDocID.length == 20)
            JiJungBeBuDisable();

    } catch (e) {
        alert("getGongRamDocInfo :: " + e.description);
    }
}


function SetReceiptNumber() {
    if (pSusinSN >= 1) {  //RECORD ID 중복패치(20180515) //(pSusinSN > 1) ==> (pSusinSN >= 1)

        if (HwpCtrl.CheckFieldExist("receiptnumber")) {
            var ReceiptNumber = trim(HwpCtrl.GetFieldText("receiptnumber"));

            if (ReceiptNumber != "") {

                if (g_DraftFlag == "SUSIN") {
                    HwpCtrl.SetFieldText("receiptnumber", "");
                }
            }
        }
    }
}

function btnApprovalInfo() {
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
    parameter[9] = false;
    parameter[10] = pDocType;
    parameter[11] = "";
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
    parameter[41] = tempKeyword
    parameter[42] = pPassAproveUseYN; // 20161025 소방 기결재통과
    parameter[43] = pDeptAuth;


    if (tempItemCode != "")
        tempdocnumcode = tempItemCode;
    var url = "/myoffice/ezApprovalG/ezLINE/ezApprovalInfo.aspx?initFlag=1&Gubun=" + pGubun;
    var feature = "status:no;dialogWidth:1000px;dialogHeight:740px;help:no;scroll:no;;edge:sunken;";
    var ret = window.showModalDialog(url, parameter, feature);

    if (ret != undefined && ret[0] == "OK") {
        try {
            HwpCtrl.ChangeMode(2);
            var savexmlhttp = createXMLHttpRequest();

            pPassAproveUseYN = ret[17]; // 20161025 소방 기결재통과
            if (pGubun != "5" && pGubun != "7" && pGubun != "10" && pGubun != "12") {

                if (ret[1] != false) {

                    if (pPassAproveUseYN == "Y" && pDraftFlag == "REDRAFT") {
                        pAprTempLine = ret[1];
                    }
                    else {
                        savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false);
                        savexmlhttp.send(ret[1]);

                        var dataNodes = GetChildNodes(loadXMLString(savexmlhttp.responseText));
                    }
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

                savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/AprDeptSave.aspx", false);
                savexmlhttp.send(ret[2]);


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

            tempSecurity = ret[7];
            tempUrgent = ret[8];
            pSummery = ret[9];
            pSpecialRecordCode = ret[10];
            pPublicityCode = ret[11];
            pLimitRange = ret[12];
            pPageNum = ret[13];
            tempSecurityDate = ret[14];
            tempKeyword = ret[16];
            pDeptAuth = ret[18]; // 20161025 소방 비공개문서 부서원공개
            SummaryFlag = true;

            savexmlhttp = null;

            HwpCtrl.ChangeMode(3);
        }
        catch (e) {
            alert("저장시 오류 발생");
        }
    }
        }


        function btnDoc24_onclick() {   //20190102 문서24 접수 회신
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

            window.open("/myoffice/ezApprovalG/ezViewHWP/ezsimsag_Doc24.aspx?DeptCode=" + "<%=_Doc24Code%>" +"&DeptName="+"<%=_Doc24Name%>", "접수회신", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        }


function ReplaceString(Origin, Source, Target) {
    return Origin.split(Source).join(Target);
}

function RefreshRecvDoc() {
    SetHref("DEL");
    window.location.reload(true);
}
    </script>
    <script type="text/vbscript" language="vbscript">

Function ConversionPt(cmm)
	' 수정(2006.06.09) : 1pt = 0.35mm, 1mm = 2.86pt 로 계산
	'ConversionPt = cint(cmm * (CDbl(378) / CDbl(100)))
	ConversionPt = Round(cmm * (CDbl(100) / CDbl(35)), 2)
End Function

Function ReplaceString(Origin, Source, Target)
	ReplaceString = Replace(Origin, Source, Target)
End Function

    </script>
</head>

<body class="popup" onload="return window_onload()" onbeforeunload="return window_onbeforeunload()">
    <object classid="clsid:80009476-666B-4869-8C04-AB03492561CD" id="ObjGPKI" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px"></object>
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul>
                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><%=RM.GetString("t1742")%></span></li>
                        <span style="display: none">
                            <li id="btnSetAprLine"><span onclick="return btnSetAprLine_onclick()"><%=RM.GetString("t153")%></span></li>
                        </span>
                        <span style="display: none">
                            <li id="btnSetReceivLine" style="display: none"><span onclick="return btnSetReceivLine_onclick()"><%=RM.GetString("t154")%></span></li>
                        </span>
                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><%=RM.GetString("t156")%></span></li>
                        <li id="btnRJunkyul"><span onclick="return btnRJunkyul_onclick()"><%=RM.GetString("t1427")%></span></li>
                        <li id="btnSendAround" style="display: none"><span onclick="return btnSendAround_onclick()"><%=RM.GetString("t1428")%></span></li>
                        <span style="display: none">
                            <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><%=RM.GetString("t9994")%></span></li>
                        </span>
                        <span style="display: none">
                            <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><%=RM.GetString("t54")%></span></li>
                        </span>
                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><%=RM.GetString("t55")%></span></li>
                        <li id="btnFileAttach" style="display: none"><span onclick="return btnFileAttach_onclick()"><%=RM.GetString("t56")%></span></li>
                        <li id="btnAprDocAttach" style="display: none"><span onclick="return btnAprDocAttach_onclick()"><%=RM.GetString("t1429")%></span></li>
                        <li id="btnAddSepAttach"><span onclick="btnAddSepAttach_onclick()"><%=RM.GetString("t58")%></span></li>
                        <li id="btnAssign"><span onclick="return btnAssign_onclick()"><%=RM.GetString("t1430")%></span></li>
                        <li id="btnReAssign" style="display: none"><span onclick="return btnReAssign_onclick()"><%=RM.GetString("t1431")%></span></li>
                        <li id="btnDistribute"><span onclick="return btnDistribute_onclick()"><%=RM.GetString("t1432")%></span></li>
                        <li id="btnReDistribute" style="display: none"><span onclick="return btnReDistribute_onclick()"><%=RM.GetString("t1433")%></span></li>
                        <li id="btnReturn"><span onclick="return btnReturn_onclick()"><%=RM.GetString("t1434")%></span></li>
                        <li id="btnReqReSend" style="display: none"><span onclick="return btnReqReSend_onclick()"><%=RM.GetString("t1435")%></span></li>
                        <%if (CheckbtnReqReSend)
                            { %>
                        <li id="btnDoc24ReSend"><span onclick="return btnDoc24_onclick()">문서24_접수회신</span></li><!--20190102 문서24 접수 회신-->
                        <%} %>
                        <li id="btnEdit"><span onclick="return btnEdit_onclick()"><%=RM.GetString("t44")%></span></li>
                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><%=RM.GetString("t60")%></span></li>
                        <li id="btnMail"><span onclick="return btnMail_onclick()"><%=RM.GetString("t1436")%></span></li>
                        <li id="btnRefresh" style="display: none"><span onclick="return RefreshRecvDoc()"><%=RM.GetString("t00013")%></span></li>
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
                <div style="height: 100%" id="form1">
                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<%=_HwpToolbar%>", "");</script>
                </div>
            </td>
        </tr>
        <tr>
            <td height="20">
                <table class="file">
                    <tr>
                        <th id="btn_Attach"><%=RM.GetString("t65")%></th>
                        <td>
                            <div id="lstAttachLink"></div>
                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0"></iframe>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <xml id="ATTACHINFO"></xml>
    <xml id="DOCINFO"></xml>
    <xml id="OPTIONINFO"></xml>
    <xml id="APRLINEINFO"></xml>
    <xml id="PREVNEXTDOCINFO"></xml>
    <xml id="CONNINFO"></xml>
    <div id="RECEIPTDEPTID" style="display: none"></div>
    <div id="AprMemberSN" style="display: none"></div>
</body>
</html>
