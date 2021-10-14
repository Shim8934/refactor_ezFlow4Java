<%@ Page Language="c#" Inherits="Kaoni.ezStandard.ezDraftUI_HWP" CodeFile="ezDraftUI_HWP.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title><%=RM.GetString("t30")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript"> var pNoneActiveX = "<%=NoneActiveX%>"; </script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <link type="text/css" rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>">
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("ezDraft_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/DraftUI/draftG.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/docnum/docnumberG_HWP.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/AutoAprLine.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAprDocAttach/getDocAttach.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAPRATTACH/attachG.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/printer/appandbody.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/CheckLines.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/ezApprovalG/js/SendMailApprove.js") %>"></script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/ezApprovalG/ezViewHWP/ezconv_hwp.js") %>"></script>
   <%--2016.11.23 원문공개문서 --%>
   <script type="text/javascript" src="<%= MakeFileVersionPath("../OpenGov/js/OpenGov.js") %>"></script>
    <script type="text/javascript">
        var FormHref = '<%=_formURL%>';
        var DraftFlag = '<%=_DraftFlag%>';
        var DocType = '<%=_formDocType%>';
        var SusinSN = '<%=_susinSN%>';
        var DocState = '<%=_DocState%>';
        var ListType = '<%=_ListType%>';
        var AprState = '<%=_AprState%>';
        var pEndDocHref = '<%=_dirpath%>';
        var _connkey_ = "<%=ReplaceXSS(Request.QueryString["_connkey_"])%>";
        var pFormHref = new String();
        var pFormID = new String();
        var pDocID = new String();
        var pHasAttachYN = new String("N");
        var pHasOpinionYN = new String("N");
        var CurrentDate
        var flag = false;
        var fieldflag = false;
        var xmldoc = createXmlDom();
        var xmluserInfo = createXmlDom();
        var xmlhttp = createXMLHttpRequest();
        var SignCount = 0;
        var hapyuiCount = 0;
        var gongramCount = 0;
        var gamsaCount = 0;
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
        var pReadPC = false;
        var DeptSymbol;
        var IsSkipDrafter;
        var badForm = false;
        var AppendFileAttach = "";
        var AppenAprDocAttachList = "";
        var pPublic = "P";
        var drafterDeptid
        var docdir = "";
        var pDocTitle;
        var pMaxFileSize = '5';
        var isExtDoc = "N";
        var isTmpDocID = '<%=_isTmpDoc%>';
        var gPublic = "";
        var draftFlag = false;
        var btnSendDraftEnable = "false"
        var LastSignNo;
        var TempsaveAprlineinfo;
        var pCCType = "0";
        var pLCatalogue = "";
        var pMCatalogue = "";
        var pperiod = "";
        var pLClass = "";
        var pMClass = "";
        var pLCasn, pMCasn, pPer, pLClsn, pMClsn;
        var arr_userinfo = new Array();
        arr_userinfo[0] = "user";
        arr_userinfo[1] = "<%=userinfo.UserID%>";
        arr_userinfo[2] = "<%=userinfo.DisplayName%>";
        arr_userinfo[3] = "<%=userinfo.Title%>";
        arr_userinfo[4] = "<%=userinfo.DeptID%>";
        arr_userinfo[5] = "<%=userinfo.DeptName%>";
        arr_userinfo[6] = "<%=userinfo.Jikchek%>";
        arr_userinfo[7] = "N";
        arr_userinfo[8] = "<%=userinfo.Email%>";
        arr_userinfo[9] = "";
        arr_userinfo[10] = "<%=_pSusinAdmin%>";
        arr_userinfo[11] = "<%=userinfo.DisplayName1%>";
        arr_userinfo[12] = "<%=userinfo.DisplayName2%>";
        arr_userinfo[13] = "<%=userinfo.Title1%>";
        arr_userinfo[14] = "<%=userinfo.Title2%>";
        arr_userinfo[15] = "<%=userinfo.DeptName1%>";
        arr_userinfo[16] = "<%=userinfo.DeptName2%>";
        var pCompanyID = "<%=userinfo.CompanyID%>";
        var pUserID = arr_userinfo[1];
        var KuyjeType = "002";
        var signDateFormat = "<%=_optSignDateFormat%>";
        var isSplit = "<%=_optisSplit%>";
        var SplitKind = "<%=_optSplitKind%>";
        var sihangURL = "<%=_sihangURL%>";
        var CurAprType = "";
        var NextAprType = "";
        var pSummery = "", pSpecialRecordCode = "", pPublicityCode = "";
        var pLimitRange = "", pPageNum = "1";
        var cabinetID = "";
        var TaskCode = "";
        var DocNumCode = "";
        var SummaryFlag = false;
        var btnReceivLineEnable = false;
        var SignType = new Array();
        var SignName = new Array();
        var SignContent = new Array();
        var CheckGubun = "1";
        var HapyuiArea = 0;
        var AprLineArea = 0;
        var DocSN = '<%=_DocSN %>';
        var AutoSave = "save";
        var Saveflag = false;
        var pUse_Editor = "<%= Use_Editor%>";
        var tempSecurity = "";
        var tempKeep = "";
        var tempUrgent = "N";
        var tempPublic = "Y";
        var tempKeyword = "";
        var tempItemCode = "";
        var tempItemName = "";
        var tempdocnumcode = "<%=RM.GetString("t45")%>";
        var tempSecurityDate = "";
        var tempItemName2 = "";
        var SummaryOuterReceiverList = "";
        var g_szUserID = arr_userinfo[8];
        var g_senderinfo = "<%= userinfo.CompanyName + ", " + userinfo.DeptName + ", " + userinfo.Title %>";
        var pPassAproveUseYN = "<%= _pPassAproveUseYN%>"; // 20161027 소방 기결재통과
        var pAprTempLine;
        //var pDeptAuth = "N" // 20161025 소방 비공개문서 부서원공개
        var pDeptAuth = "<%=pDeptAuth%>"; // 20161025 소방 비공개문서 부서원공개 //소방 수정 비곰개 문서 정보 가져오기(20170711)
        var connkey = "<%=connkey%>"; //연동키(20161103)
        var pConnDimsKey = "<%=_conndims%>"; //소방 위험물 관리 연동키(20161109)
        var pConnSobangKey = "<%=_connsobang%>"; //소방 연동키(20161109)
        var pConnTitle = "<%=_title%>"; //소방 제목(20161109)
        var ImageFormInfo = "<%=ImageInfo%>"; //양식별 사인팝업 분기처리(20161123)

        // 수정(2016.02.26) : 원문공개문서 변수 추가
        var OpenFlag = '<%=OpenFlag%>';
        var pOpenFlag = false;

        var pAuditDocID = "<%=_AuditDocID %>"; //20161212 소방 일상감사
        var pAuditAprType = "<%=_AuditAprType %>"; //20161212 소방 일상감사
        var pAuditDocIDAttach = "<%=_AuditDocIDAttach %>"; //20161212 소방 일상감사

        var pTemp_FormInfo = "<%=Temp_FormInfo%>"; //소방임시 저장 필요없는 양식(20161229)
        //소방일상감사 첨부파일 추가(20170112)
        var pAudit_Len = "";
        var GetXml = "";
        var AttDocXML = "";
        var pAddress_Gubun = "false"; //소방기안문 내부결재 기본처리(20170210)
        var pGamsaFormID = "<%=GamsaFormID %>"; //소방 일상감사의견서 formID 정보(20170216)
        var FormIDwith30Aggrement = "<%=FormIDwith30Aggrement %>"; // 합의 30명 넘는경우 오류 수정(20170727)
        
        var Doc24Code = "<%=_Doc24Code %>"; //20190104 문서24 부서코드
        var Doc24Name = "<%=_Doc24Name %>"; //20190104 문서24 부서이름

        window.onload = function () {

            try {
                window.onresize();
                pSusinSN = SusinSN;
                setMenuBar("btnSendDraft", true);
                dragNdrapNo();

                HwpCtrl.SetImgReg();
                HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
                HwpCtrl.SetSaveMode(1);

                IsSkipDrafter = "FALSE"
                DeptSymbol = getDeptSymbol(arr_userinfo[4], arr_userinfo[5]);
                drafterDeptid = arr_userinfo[4];
                getDraftInfo();
                SetBtnStateFalse();

                if (pFormHref != "") {
                    var URL;
                    showProgress("<%=RM.GetString("t368")%>");
                    URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pFormHref);
                    var isTrue = HwpCtrl.LoadFile(URL, false);
                    FieldsAvailable(isTrue);
                } else {
                    DraftFlag = "DRAFT";
                    pDraftFlag = "DRAFT";
                    showProgress("<%=RM.GetString("t368")%>");
                    var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(sihangURL.replace(".mht", ".hwp"));
                    var isTrue = HwpCtrl.LoadFile(URL, false);
                    FieldsAvailable(isTrue);
                }
                if (pAuditAprType != "") { //소방 일상감사 주요검토서 불러올시 결재문서 및 첨부정보 가져오기(20170112)
                    //소방 일상감사 접수일자 및 접수번호 가져오기(20170216)
                    var xmlhttp3 = createXMLHttpRequest();
                    var xmlpara3 = createXmlDom();
                    var objNode3;
                    createNodeInsert(xmlpara3, objNode3, "PARAMETER");
                    createNodeAndInsertText(xmlpara3, objNode3, "PDOCID", pAuditDocIDAttach);
                    xmlhttp3.open("Post", "/myoffice/ezApprovalG/ezViewHWP/aspx/Get_GamsaNumAndDate.aspx", false);
                    xmlhttp3.send(xmlpara3);
                    if (xmlhttp3.responseText != "") {
                        var GamsaInfo = loadXMLString(xmlhttp3.responseText);
                        var pGamssaNo = getNodeText(SelectNodes(GamsaInfo, "DISPREGISTERNO")[0]);
                        var pGamssaEnddate = getNodeText(SelectNodes(GamsaInfo, "ENDDATE")[0]);
                        if (HwpCtrl.CheckFieldExist("s_enforcedate")) {
                            HwpCtrl.SetFieldText("s_enforcedate", pGamssaEnddate);
                        }
                        if (HwpCtrl.CheckFieldExist("s_docnumber")) {
                            HwpCtrl.SetFieldText("s_docnumber", pGamssaNo);
                        }
                    }
                    var xmlhttp = createXMLHttpRequest();
                    var xmlpara = createXmlDom();
                    var objNode;
                    createNodeInsert(xmlpara, objNode, "PARAMETER");
                    createNodeAndInsertText(xmlpara, objNode, "PDOCID", pAuditDocIDAttach);
                    createNodeAndInsertText(xmlpara, objNode, "PMODE", pAuditAprType);
                    createNodeAndInsertText(xmlpara, objNode, "PGUBUN", "AUDIT");
                    xmlhttp.open("Post", "../aspx/Get_TotalDoc.aspx", false);
                    xmlhttp.send(xmlpara);
                    if (xmlhttp.responseText != "") {
                        var attSN = 1;
                        var docAttach = loadXMLString(xmlhttp.responseText);
                        var pFilePath = "";
                        var pFileName = "";
                        var pFileSize = "";
                        var pPageNum = "";
                        var pTitle_GS = "";
                        var pType = "";
                        var SN_info = 0;
                        var Attach_dan = "B";
                        var pDocTitle_Gamsa = "";
                        var AttDocLeng = 0;
                        pAudit_Len = SelectNodes(docAttach, "ROW").length;
                        GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang214 + "</NAME><WIDTH>50</WIDTH></HEADER><HEADER><NAME>" + strLang215 + "</NAME><WIDTH>260</WIDTH></HEADER><HEADER><NAME>" + strLang216 + "</NAME><WIDTH>80</WIDTH></HEADER></HEADERS>";
                        GetXml = GetXml + "<ROWS>";
                        AttDocXML = "<ROWS>";
                        for (var i = 0; i < SelectNodes(docAttach, "ROW").length; i++) {
                            pType = getNodeText(SelectNodes(docAttach, "TYPE")[i]);
                            pFilePath = getNodeText(SelectNodes(docAttach, "FILEPATH")[i]);
                            pFileName = getNodeText(SelectNodes(docAttach, "FILENAME")[i]).replace(/&amp;/gi, "&");
                            pFileSize = getNodeText(SelectNodes(docAttach, "ATTACHFILESIZE")[i]);
                            pPageNum = getNodeText(SelectNodes(docAttach, "PAGENUM")[i]);
                            pTitle_GS = getNodeText(SelectNodes(docAttach, "TITLE")[i]);

                            if (pType == "ATTDOC") { //문서첨부
                                AttDocXML += "<ROW>";
                                AttDocXML += "<DATA1><![CDATA[" + pFilePath + "]]></DATA1>";
                                if (AttDocLeng == 0) {
                                    AttDocXML += "<DATA2></DATA2>";
                                }
                                else {
                                    AttDocXML += "<DATA2><![CDATA[" + AttDocLeng + "]]></DATA2>";
                                }
                                AttDocXML += "<DATA3><![CDATA[" + pDocID + "]]></DATA3>";
                                AttDocXML += "<DATA4><![CDATA[" + arr_userinfo[1] + "]]></DATA4>";
                                AttDocXML += "<DATA5><![CDATA[" + arr_userinfo[3] + "]]></DATA5>";
                                AttDocXML += "<DATA6><![CDATA[" + arr_userinfo[4] + "]]></DATA6>";
                                AttDocXML += "<DATA7><![CDATA[" + arr_userinfo[5] + "]]></DATA7>";
                                AttDocXML += "<DATA8><![CDATA[" + arr_userinfo[2] + "]]></DATA8>";
                                AttDocXML += "<DATA9><![CDATA[" + "N" + "]]></DATA9>";
                                AttDocXML += "<DATA10><![CDATA[" + pFileName + "]]></DATA10>";
                                AttDocXML += "<DATA11><![CDATA[" + arr_userinfo[2] + "]]></DATA11>";
                                AttDocXML += "<DATA12><![CDATA[" + arr_userinfo[2] + "]]></DATA12>";
                                AttDocXML += "<DATA13><![CDATA[" + arr_userinfo[3] + "]]></DATA13>";
                                AttDocXML += "<DATA14><![CDATA[" + arr_userinfo[3] + "]]></DATA14>";
                                AttDocXML += "<DATA15><![CDATA[" + arr_userinfo[5] + "]]></DATA15>";
                                AttDocXML += "<DATA16><![CDATA[" + arr_userinfo[5] + "]]></DATA16>";
                                AttDocXML += "</ROW>";
                                AttDocLeng = (AttDocLeng + 1);
                                
                            }
                            else { //일반첨부
                                if (pFileSize == "0") {
                                    pFileSize = "102400";
                                }
                                if (pPageNum == "0") {
                                    pPageNum = 1;
                                }
                                if (pType == "DOC") {
                                    pDocTitle_Gamsa = pTitle_GS; //본문 제목추가(20170124)
                                    pFileName = "(의뢰서)" + pFileName + ".hwp"; //외뢰서 본문첨부 이름 수정(20170215)
                                }

                                GetXml = GetXml + "<ROW>";
                                var re = /&/g
                                GetXml = GetXml + "<COLUMN><![CDATA[" + arr_userinfo[2] + "]]></COLUMN>";
                                GetXml = GetXml + "<DATA1><![CDATA[" + pFilePath + "]]></DATA1>";
                                GetXml = GetXml + "<DATA2><![CDATA[" + (SN_info + 1) + "]]></DATA2>";
                                SN_info = SN_info + 2;
                                GetXml = GetXml + "<DATA3><![CDATA[" + pDocID + "]]></DATA3>";
                                GetXml = GetXml + "<DATA4><![CDATA[" + arr_userinfo[1] + "]]></DATA4>";
                                GetXml = GetXml + "<DATA5><![CDATA[" + arr_userinfo[3] + "]]></DATA5>";
                                GetXml = GetXml + "<DATA6><![CDATA[" + arr_userinfo[4] + "]]></DATA6>";
                                GetXml = GetXml + "<DATA7><![CDATA[" + arr_userinfo[5] + "]]></DATA7>";
                                GetXml = GetXml + "<DATA8><![CDATA[" + pFileSize + "]]></DATA8>";
                                GetXml = GetXml + "<DATA9><![CDATA[" + pPageNum + "]]></DATA9>";
                                GetXml = GetXml + "<DATA10><![CDATA[" + pFileName + "]]></DATA10>";
                                GetXml = GetXml + "<DATA11><![CDATA[" + "N" + "]]></DATA11>";
                                GetXml = GetXml + "<DATA12><![CDATA[" + pFileName + "]]></DATA12>";
                                GetXml = GetXml + "<DATA13><![CDATA[" + arr_userinfo[2] + "]]></DATA13>";
                                GetXml = GetXml + "<DATA14><![CDATA[" + arr_userinfo[2] + "]]></DATA14>";
                                GetXml = GetXml + "<DATA15><![CDATA[" + arr_userinfo[3] + "]]></DATA15>";
                                GetXml = GetXml + "<DATA16><![CDATA[" + arr_userinfo[3] + "]]></DATA16>";
                                GetXml = GetXml + "<DATA17><![CDATA[" + arr_userinfo[5] + "]]></DATA17>";
                                GetXml = GetXml + "<DATA18><![CDATA[" + arr_userinfo[5] + "]]></DATA18>";
                                GetXml = GetXml + "<COLUMN><![CDATA[" + pFileName + "]]></COLUMN>";
                                if (pFileSize > 1024) {
                                    pFileSize = Math.floor(pFileSize / 1024);
                                    Attach_dan = "KB";
                                    if (pFileSize > 1024) {
                                        pFileSize = Math.floor(pFileSize / 1024);
                                        Attach_dan = "MB";
                                    }
                                }
                                pFileSize = pFileSize + Attach_dan;
                                GetXml = GetXml + "<COLUMN><![CDATA[" + pFileSize + "]]></COLUMN>";
                                GetXml = GetXml + "<COLUMN><![CDATA[" + pPageNum + "]]></COLUMN>";
                                GetXml = GetXml + "</ROW>";
                            }
                        }
                        if (HwpCtrl.CheckFieldExist("doctitle")) { //일상감사 제목도 가져온다(20170124)
                            HwpCtrl.SetFieldText("doctitle", pDocTitle_Gamsa);
                        }
                        
                        GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
                        AttDocXML += "</ROWS>";

                        if (pFormID == pGamsaFormID) { //의견서는 첨부 안가져온다(20170216)
                            return;
                        }
                        if (AttDocXML != "<ROWS></ROWS>") { //문서첨부
                            try{
                                var rtnXML;
                                var xmlhttp2 = createXMLHttpRequest();
                                xmlhttp2.open("Post", "/myoffice/ezApprovalG/ezAPRDOCATTACH/aspx/updateDocattach.aspx", false);
                                xmlhttp2.send(AttDocXML);
                                var rtnval = loadXMLString(xmlhttp2.responseText);
                                if (SelectSingleNodeValue(rtnval, "RESULT") == "TRUE") {
                                    rtnXML = AttDocXML;
                                }
                                else {
                                    rtnXML = "<ROWS></ROWS>"
                                }
                            }
                            catch (e) {
                                alert(e.message);
                            }
                        }
                        SaveAttachListInfo(GetXml); //일반첨부
                    }
                }
                if (Doc24Name != null && Doc24Name != "") {  //20190104 문서24 기안문 수신처정보 SET
                    if (HwpCtrl.CheckFieldExist("recipient")) {
                        HwpCtrl.SetFieldText("recipient", Doc24Name);
                    }
                }

                HwpCtrl.SetFieldFocus("doctitle");
                HwpCtrl.ezSetScrollPosInfo(0);
            }
            catch (e) {
                alert("ezdraftui_hwp.aspx.window.onload::" + e.description);
                hideProgress();
            }
        }

        // 합의 30명 넘는경우 오류 수정(20170727)
        function IsAgreementSize30() {
            if (FormIDwith30Aggrement.indexOf(pFormID) != -1 ) {
                return true;
            }
            else {
                return false;
            }
        }

        function SaveAttachListInfo(Attachxml) { //소방 일상감사 첨부파일 가져오기(20170112)
            var ReturnVal;
            xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRATTACH/aspx/AprAttachSave.aspx", false);
            xmlhttp.send(Attachxml);
            
            if (SelectSingleNodeValue(loadXMLString(xmlhttp.responseText), "RESULT") == "FALSE") {
                var pAlertContent = strLang217;
                OpenAlertUI(pAlertContent);
            }
            else {
                CheckHistory(1);
                setAttachInfo(pDocID, "APR", lstAttachLink);
                DivPopUpHidden();
            }
        }

        function CheckHistory(pFlag) { //소방 일상감사 첨부파일 가져오기(20170112)
            var i, j;
            var xmlpara = createXmlDom();
            xmlpara.loadXML(GetXml);
            var docAttach2 = loadXMLString(GetXml);
            pAudit_Len = SelectNodes(docAttach2, "ROW").length;
            
            for (i = 0; i < pAudit_Len; i++) {
                var tempSN = getNodeText(xmlpara.getElementsByTagName("DATA2").item(i));
                var tempFileName = getNodeText(xmlpara.getElementsByTagName("DATA10").item(i));
                var AddFlag = true;
                UpdateAttachHistory(tempSN, "<%=RM.GetString("t268")%>");
            }
        }


        function UpdateAttachHistory(tempAttachSN, pModifyFlag) { //소방 일상감사 첨부파일 가져오기(20170112)
            var xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "pAttachSN", tempAttachSN);
            createNodeAndInsertText(xmlpara, objNode, "pUserID", arr_userinfo[1]);
            createNodeAndInsertText(xmlpara, objNode, "pUserName", arr_userinfo[2]);
            createNodeAndInsertText(xmlpara, objNode, "pUserJobTitle", arr_userinfo[3]);
            createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
            createNodeAndInsertText(xmlpara, objNode, "pUserDeptName", arr_userinfo[5]);
            createNodeAndInsertText(xmlpara, objNode, "pModifyFlag", pModifyFlag);
            createNodeAndInsertText(xmlpara, objNode, "PUSERNAME2", arr_userinfo[2]);
            createNodeAndInsertText(xmlpara, objNode, "PUSERJOBTITLE2", arr_userinfo[3]);
            createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTNAME2", arr_userinfo[5]);

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRHISTORY/aspx/UpdateAttachHistory.aspx", false);
            xmlhttp.send(xmlpara);
            if (SelectSingleNodeValue(loadXMLString(xmlhttp.responseText), "RESULT") == "TRUE") {
            }
            else {
                var pAlertContent = strLang226;
                OpenAlertUI(pAlertContent);
            }
        }

        window.onresize = function () {
            HwpCtrl.style.height = null;
            HwpCtrl.height = document.documentElement.clientHeight - 150;
        }

        function dragNdrapNo() {
            try {
                var div = document.getElementById('lstAttachLink');
                div.ondragenter = div.ondragover = function (e) {
                    return false;
                }
                div.ondrop = function (e) {
                    alert("드래그 앤 드랍 기능을 이용할 수 없습니다.\n[첨부] 메뉴를 이용해 주시기 바랍니다.");
                    return false;
                }
            } catch (e) {
                alert("ezdraftui_hwp.aspx.dragNdrapNo()::" + e.description);
            }
        }

        function FieldsAvailable(isTrue) {
            try {
                if (isTrue) {

                    SetBtnStateTrue();
                    setAutoProperty();
                    hideProgress();
                    window.focus();
                    HwpCtrl.focus();

                    if (pFormHref == "") {
                        hideProgress();
                        getExtInfo();
                    }

                    if (pReadPC) {
                        var DocumentInfo = createXmlDom();
                        DocumentInfo.loadXML(HwpCtrl.GetDocumentInfo());

                        if (GetDocumentElement(HwpCtrl, "CONNROOT") != "") {
                            var pAlertContent = "<%=RM.GetString("t1391")%><br><br><%=RM.GetString("t1392")%>";
                            OpenAlertUI(pAlertContent);
                            HwpCtrl.ClearDocument();
                        }

                        if (DocumentInfo.getElementsByTagName("TITLE").length > 0) {
                            if (getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0)) != "") {
                                pFormID = getNodeText(DocumentInfo.getElementsByTagName("TITLE").item(0));
                                DocType = GetFormType(pFormID);
                                if (DocType != "")
                                    pDocType = DocType;
                                else {
                                    var pAlertContent = "PC<%=RM.GetString("t1393")%>";
                                    OpenAlertUI(pAlertContent);
                                    HwpCtrl.ClearDocument();
                                    return;
                                }
                            }
                        }
                    }

                    process_AfterOpen();

                    // 2012-12-06 LBY 소방 시스템 연동 결재 - 첨부 정보 입력 AS-IS 커스터마이징 반영(20161109)
                    if (pConnDimsKey != "" && pConnSobangKey == "") {
                        if (HwpCtrl.CheckFieldExist("_connattachsn") && HwpCtrl.CheckFieldExist("_conndims"))
                            setConnAttach(1);

   			if (pConnTitle != "")
                        {
                            if (HwpCtrl.CheckFieldExist("doctitle"))
                                HwpCtrl.SetFieldText("doctitle", pConnTitle);

                        }
                    }

                    if (pConnDimsKey != "" && pConnSobangKey != "") { //소방 연동정보 AS-IS 커스터마이징(20161109)
                        HwpCtrl.SetFieldText("_conndims", pConnDimsKey);
                        if (HwpCtrl.CheckFieldExist("_connattachsn") && HwpCtrl.CheckFieldExist("_conndims"))
                            setConnAttach(2);

                        if (HwpCtrl.CheckFieldExist("doctitle"))
                            HwpCtrl.SetFieldText("doctitle", pConnTitle);
                    }


                    if (connkey != "") { //연동키
                        try {
                            if (HwpCtrl.CheckFieldExist("connkey"))
                                HwpCtrl.SetFieldText("connkey", connkey);
                        } catch (e) { }
                    }

                    var rtnVal = ExcuteInfo("INIT", "");
                    if (!rtnVal) {
                        if (OpenInformationUI("<%=RM.GetString("t122")%>")) {
                            btnClose_onclick();
                        }
                    }

                    if (pDraftFlag != "REDRAFT")
                        setFirstDrafter();
                    else
                        SignCheck();

                    HwpCtrl.SetFieldFocus("doctitle");
                    HwpCtrl.ezSetScrollPosInfo(0);
                    HwpCtrl.SetImgReg();

                } else {
                    hideProgress();
                    var pAlertContent = "<%=RM.GetString("t369")%>";
                    OpenAlertUI(pAlertContent);
                    HwpCtrl.ClearDocument();
                }
            } catch (e) {
                alert("ezdraftui_hwp.aspx.FieldsAvailable()::" + e.description);
            }
        }


        // 2012-12-06 LBY 소방 시스템 연동 결재 - 첨부 정보 입력
        function setConnAttach(pConnType) { //AS-IS 커스터 마이징 반영(20161109)
            try {
                var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                var xmlpara = new ActiveXObject("Microsoft.XMLDOM");

                var objRoot = xmlpara.createNode(1, "PARAMETER", "");
                xmlpara.appendChild(objRoot);

                var objNode = xmlpara.createNode(1, "pDocID", "");
                objNode.text = pDocID;
                xmlpara.documentElement.appendChild(objNode);

                var objNode = xmlpara.createNode(1, "pConnKey", "");
                objNode.text = pConnDimsKey;
                xmlpara.documentElement.appendChild(objNode);

                if (pConnType == 2)
                    xmlhttp.open("POST", "aspx/setConnAttach_Sobang.aspx", false);
                else
                    xmlhttp.open("POST", "aspx/setConnAttach.aspx", false);
                xmlhttp.send(xmlpara);

                if (xmlhttp.statusText == "OK") {
                    if (xmlhttp.responseXML.getElementsByTagName("DATA").length > 0) {
                        pKeepAttach = xmlhttp.responseXML.getElementsByTagName("DATA").item(0).text;
                        if (pKeepAttach.indexOf("FAIL") > -1) {
                            alert("파일을 가져오는 중 오류가 발생하였습니다. - " + pKeepAttach.substring(5, pKeepAttach.length));
                        }
                        else {
                            if (Number(pKeepAttach) > 0) {
                                setAttachInfo(pDocID, "APR", lstAttachLink);
                                HwpCtrl.SetFieldText("_connattachsn", pKeepAttach);
                                HwpCtrl.SetFieldText("_conndims", pConnDimsKey);
                            }
                        }
                    }
                }

            } catch (e) {
                alert("setSusinUpdataDocID()" + e.description);
            }
        }


function GetFormType(pFormID) {
    try {
        var Result = "";
        var xmlpara = createXmlDom();
        var xmlhttp = createXMLHttpRequest();


        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "FORMID", pFormID);
        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", pCompanyID);


        xmlhttp.open("Post", "aspx/GetFormDetail.aspx", false);
        xmlhttp.send(xmlpara);

        if (xmlhttp.statusText == "OK") {
            if (loadXMLString(xmlhttp.responseText).getElementsByTagName("FORMDOCTYPE").length > 0) {
                Result = getNodeText(loadXMLString(xmlhttp.responseText).getElementsByTagName("FORMDOCTYPE").item(0));
            }
        }

        xmlpara = null;
        xmlhttp = null;
        return Result;

    } catch (e) {
        alert("ezdraftui_hwp.aspx.GetFormType()::" + e.description);
    }
}


function openForm() {
    openFormUI();
}


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

                if (isTmpDocID == "") {
                    len = pFormHref.lastIndexOf("/");
                    pDocID = pFormHref.substr(len + 1, 20);
                } else {
                    pDocID = isTmpDocID;
                }

                GetAprDocFormID();
                setAttachInfo(pDocID, "APR", lstAttachLink);
                GetExchInfo();
                getDocInfo();

                if (pHasOpinionYN == "Y") {
                    if (AprState == "<%=RM.GetString("t49")%>")
                                pInformationContent = "<%=RM.GetString("t124")%><br> <%=RM.GetString("t10")%>";
	  		    else
	  		        pInformationContent = "<%=RM.GetString("t126")%><br> <%=RM.GetString("t10")%>";

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
              GetExchInfo();
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
            } else if (pDraftFlag == "HAPYUI") {
                var len;
                len = pFormHref.lastIndexOf("/");
                ClearDocCellInfo();
                setClearSusinCellInfo();
                pOrgDocID = pFormHref.substr(len + 1, 20);
                pDocID = pOrgDocID;
                GetAprDocFormID();
                setAttachInfo(pDocID, "APR", lstAttachLink);

                GetExchInfo();
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
            } else {
                SetBtnStateTrue();
                pDraftFlag = "DRAFT";
                GetExchInfo();

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
    alert("ezdraftui_hwp.aspx.process_AfterOpen()::" + e.description);
}
}

function setAutoProperty() {
    getDraftUserInfo();
    SetAutoPropertyValue();
}

function btnSelForm_onclick() {
    var check = Form_check();
    if (check == "OK")
        openForm();
}

function btnSetAprLine_onclick() {
    try {
        var ret;
        ret = openAprLineUI();
        TempsaveAprlineinfo = ret[0];

        if (ret[3] != "" && ret[3] != "cancel")
            pPublic = ret[3];

        if (ret[0] != "cancel" && ret[3] != "cancel") {
            IsSkipDrafter = "FALSE";
            btnSendDraftEnable = "true";
            // 합의 30명 넘는경우 오류 수정(20170727)
            if (IsAgreementSize30()) {
                GetDraftAprLineInfoWith30(ret);
            } else {
                GetDraftAprLineInfo(ret);
            }
            return true;
        } else {
            if (ret[2] == "cancel") {
                var pAlertContent = "<%=RM.GetString("t127")%>";
                        OpenAlertUI(pAlertContent);
                    }
                }
                return false;
            } catch (e) {
                alert("ezdraftui_hwp.aspx.btnSetAprLine_onclick()::" + e.description);
            }
        }

        function btnSetReceivLine_onclick() {
            try {
                var ret = openReceivUI();

                if (ret != "cancel") {
                    btnReceivLineEnable = false;
                    setRecevInfo(ret);
                }
            } catch (e) {
                alert("ezdraftui_hwp.aspx.btnSetReceivLine_onclick()::" + e.description);
            }
        }

        function btnSendDraft_onclick() {
            try {
                var xmlpara3 = createXmlDom();


                var objNode;
                createNodeInsert(xmlpara3, objNode, "PARAMETER");
                createNodeAndInsertText(xmlpara3, objNode, "pDocID", pDocID);


                var xmlhttp3 = createXMLHttpRequest();
                xmlhttp3.open("Post", "/myoffice/ezApprovalG/ezAPRATTACH/aspx/GetExtTotalAttachSize.aspx", false);
                xmlhttp3.send(xmlpara3);

                var rtnAttachXML = createXmlDom();
                rtnAttachXML.loadXML(loadXMLString(xmlhttp3.responseText).xml);


                //if (getNodeText(rtnAttachXML.getElementsByTagName("FLAG").item(0)) == "Y") {
                //    OpenAlertUI("외부발송문서 총 첨부용량은 최대 6MB 입니다" + "<br>" + "첨부용량을 줄여주시기 바랍니다.");
                //    return;
                //}

                bAttachProcess = false;

                var rtnSignInfo;
                if (GetDocumentElement(HwpCtrl, "WORKFLOWXML") != "") {
                    var rtn = checkValidation(GetDocumentElement(HwpCtrl, "WORKFLOWXML"))
                    if (rtn == "FALSE")
                        return;
                    else if (rtn != "TRUE") {
                        var pInformationContent = rtn + "<%=RM.GetString("t130")%>";
                        var Ans = OpenInformationUI(pInformationContent);

                        if (Ans) {
                            var Ans = btnSetAprLine_onclick();
                            return;
                        } else {
                            return;
                        }
                    }
            }

            if (HwpCtrl.CheckFieldExist("doctitle"))
                pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
            else
                pDocTitle = "<%=RM.GetString("t1394")%>";

                if (pDocTitle == "") {
                    var pAlertContent = "<%=RM.GetString("t1395")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                var pAlertContent = "임원 결재문서는 원문공개 대상 문서이므로 공개여부에 유의 하시기 바랍니다."; //소방 경고창 추가(20170214)
                OpenAlertUI(pAlertContent);

                if (pDocTitle.length > 127) {
                    var pAlertContent = "<%=RM.GetString("t132")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (btnSendDraftEnable == "false") {
                    btnApprovalInfo(1);

                }

                if (btnSendDraftEnable == "false") {
                    var pAlertContent = "<%=RM.GetString("t1398")%>" + "<br>" + "<%=RM.GetString("t1399")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (!checkLines())
                    return;


                if (pSuSinFlag == "Y" && !btnReceivLineEnable) {
                    btnApprovalInfo(2);
                }

                if (pSuSinFlag == "Y" && !btnReceivLineEnable) {
                    var pAlertContent = "<%=RM.GetString("t141")%>" + "<br>" + "<%=RM.GetString("t142")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (cabinetID == "")
                    btnApprovalInfo(3);
                if (cabinetID == "") {
                    var pAlertContent = "<%=RM.GetString("t1397")%>";
                    OpenAlertUI(pAlertContent);
                    return;
                }

                if (!SummaryFlag)
                    btnApprovalInfo(4);

                if (!SummaryFlag)
                    return;

                setDrafterAddress();


                if (pDraftFlag == "REDRAFT")
                    delOpinionInfo();

                if (LastSignSN == 1 || DraftLastFlag) {
                    var pInformationContent = "<%=RM.GetString("t143")%><br> <%=RM.GetString("t144")%>";
                    var Ans = OpenInformationUI(pInformationContent);

                    if (!Ans) return;

                    if (pDraftFlag == "HABYUI" || pDraftFlag == "GAMSABU" || pDraftFlag == "WHOKYUL") {
                        getLastOpinon();
                    }

                    if (HwpCtrl.CheckFieldExist("lastdraftdate"))
                        HwpCtrl.SetFieldText("lastdraftdate", getGyulJeDate());
                }

                if ("<%=GetApprovalPWD() %>" != "N") {
                    var chkpass = chk_Passwd();
                    if (chkpass == "False") {
                        var pAlertContent = "<%=RM.GetString("t1383")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    } else if (chkpass == "cancel") {
                        var pAlertContent = "<%=RM.GetString("t28")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                }

                //20161027 소방 기결재통과시 기안상신시점에 결재선 저장
                if (pPassAproveUseYN == "Y" && pDraftFlag == "REDRAFT" && AprState=="004") { //소방 기결재통과 임시저장문서는 적용안되도록 수정 (20161226)
                    var savexmlhttp = createXMLHttpRequest();
                    savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false);
                    savexmlhttp.send(pAprTempLine);
                    var dataNodes = GetChildNodes(loadXMLString(savexmlhttp.responseText));
                }
                if (pPassAproveUseYN == "N" && pDraftFlag == "REDRAFT" && AprState == "004") { //소방 기결재통과 안할시 승인자 --> 대기로  업데이트 (20170126)
                    var savexmlhttp = createXMLHttpRequest();
                    var XML_dom = "<DATA><PDOCID>" + pDocID + "</PDOCID><PGUBUN>Y</PGUBUN></DATA>";
                    savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave_passyn.aspx", false);
                    savexmlhttp.send(XML_dom);
                }

                if (IsSkipDrafter == "FALSE") {
                    var ret;
                    var parameter = new Array();

                    parameter[0] = pDocID;
                    ret = openSignUI(parameter);

                    if (ret == "cancel") {
                        var pAlertContent = "<%=RM.GetString("t145")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }

                    pOrgHtml = HwpCtrl.GetCloneData("", "HWP");

                    if (LastSignSN == 1 || DraftLastFlag) {
                        var rtnVal;
                        rtnVal = ExcuteInfo("DOCNUM_BEFORE", "");
                        if (!rtnVal) {
                            var pAlertContent = "[<%=RM.GetString("t69")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    }

                    var rtnval;
                    if (LastSignSN == 1 || DraftLastFlag)
                        rtnval = getDocNumber(arr_userinfo[4], "");
                    else
                        rtnval = getDocNumber(arr_userinfo[4], "be");

                    if (!rtnval) {
                        var pAlertContent = "[<%=RM.GetString("t1384")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }


                    if (LastSignSN == 1 || DraftLastFlag) {
                        var rtnVal;
                        rtnVal = ExcuteInfo("DOCNUM_AFTER", "");
                        if (!rtnVal) {
                            var pAlertContent = "[<%=RM.GetString("t69")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    }
                    rtnSignInfo = SendDraftMappingSign(ret);
                }

                if (pDraftFlag == "SUSIN" || pDraftFlag == "HAPYUI" || pSusinSN != "0") {
                    var RtnVal;
                    var pAlertContent;
                    RtnVal = setSusinUpdataDocID();
                    if (RtnVal == "true") {
                        RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_BEFORE", "");
                        if (!RtnVal) {
                            pAlertContent = "[<%=RM.GetString("t69")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }

                        if (RtnVal)
                            RtnVal = SaveDraftDocInfo();
                        if (RtnVal == "TRUE") {
                            RtnVal = ExcuteInfo("SUSIN_DRAFTSAVE_AFTER", "");
                            if (!RtnVal) {
                                pAlertContent = "[<%=RM.GetString("t69")%>";
                                OpenAlertUI(pAlertContent);
                                return;
                            }


                            if (LastSignSN == 1 || DraftLastFlag) {
                                RtnVal = ExcuteInfo("SUSIN_DOCNUM_END", "");
                                if (!RtnVal) {
                                    pAlertContent = "[<%=RM.GetString("t69")%>";
                                    OpenAlertUI(pAlertContent);
                                    return;
                                }
                            }

                            UpdateLineHistory();
                            pAlertContent = "<%=RM.GetString("t146")%>";
                            OpenAlertUI(pAlertContent);
                            draftFlag = true;
                            window.close();

                        } else {
                            UndoSignInfo(rtnSignInfo);

                            if (LastSignSN == 1 || DraftLastFlag) {
                                RtnVal = ExcuteInfo("END_FAIL", "");
                                if (!RtnVal) {
                                    pAlertContent = "[<%=RM.GetString("t69")%>";
                                    OpenAlertUI(pAlertContent);
                                    return;
                                }
                            }

                            pAlertContent = "[<%=RM.GetString("t1400")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                    } else {
                        UndoSignInfo(rtnSignInfo);

                        if (LastSignSN == 1 || DraftLastFlag) {
                            RtnVal = ExcuteInfo("END_FAIL", "")

                            if (!RtnVal) {
                                pAlertContent = "[<%=RM.GetString("t69")%>";
                                OpenAlertUI(pAlertContent);
                                return;
                            }
                        }

                        SetBtnStateTrue();
                        btnSendDraftEnable = "true";
                        pAlertContent = "[<%=RM.GetString("t1400")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                } else {
                    var RtnVal = ExcuteInfo("DRAFTSAVE_BEFORE", "");
                    var pAlertContent;
                    if (!RtnVal) {
                        pAlertContent = "[<%=RM.GetString("t69")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }

                    if (LastSignSN == 1 || DraftLastFlag)
                        SetAutoPropFinal();

                    if (LastSignSN == 1 || DraftLastFlag) {
                        var rtnVal = ExcuteInfo("LAST_SEND_BEFORE", "");
                        if (!rtnVal) {
                            return;
                        }
                    }

                    RtnVal = SaveDraftDocInfo();
                    if (RtnVal == "TRUE") {
                        RtnVal = ExcuteInfo("DRAFTSAVE_AFTER", "");
                        if (!RtnVal) {
                            pAlertContent = "[<%=RM.GetString("t69")%>";
                            OpenAlertUI(pAlertContent);
                            return;
                        }


                        if (LastSignSN == 1 || DraftLastFlag) {
                            RtnVal = ExcuteInfo("DOCNUM_END", "");
                            if (!RtnVal) {
                                pAlertContent = "[<%=RM.GetString("t69")%>";
                                OpenAlertUI(pAlertContent);
                                return;
                            }
                            Gyuljedate = GetDocInfoData("END", "STARTDATE");
                            SendMailToReceiveDept(pDocTitle, arr_userinfo[2], Gyuljedate, pDocID);
                        }
                        else {
                            Gyuljedate = GetDocInfoData("APR", "STARTDATE");
                            sendAlertMail("APR", 1, "DRAFT");
                        }

                        UpdateLineHistory();

                        if (LastSignSN == 1) {
                            SendAckForExch("approval", "END");
                            Send_Filter(); //기안자가 최종결재일때 필터링 정보 적용 (20161221)
                        } else {
                            SendAckForExch("submit", "ING");
                        }

                        pAlertContent = "<%=RM.GetString("t146")%>";
                        OpenAlertUI(pAlertContent);
                        draftFlag = true;


                        if (ListType == "21" && DraftFlag == "REDRAFT") {
                            RemoveTmpDoc(DocSN);
                        }

                        window.close();
                    } else {
                        UndoSignInfo(rtnSignInfo);
                        if (LastSignSN == 1)
                            rollbackDocNumber(arr_userinfo[4], "", pDocID);


                        if (LastSignSN == 1 || DraftLastFlag) {
                            RtnVal = ExcuteInfo("END_FAIL", "")

                            if (!RtnVal) {
                                pAlertContent = "[<%=RM.GetString("t69")%>";
                                OpenAlertUI(pAlertContent);
                                return;
                            }
                        }

                        SetBtnStateTrue();
                        pAlertContent = "[<%=RM.GetString("t1400")%>";
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                }
            } catch (e) {
                alert("ezdraftui_hwp.aspx.btnSendDraft_onclick()::" + e.description);
            }
        }

        //사용자 정보 파일필터링 전송 완료시점에 넘겨준다 (2016.10.25)
        function Send_Filter() {
            var xmlHTTP = createXMLHttpRequest();
            var xmlDom = "<DATA>" + "<DOCID>" + pDocID + "</DOCID>" + "</DATA>";
            xmlHTTP.open("POST", "/myoffice/ezApprovalG/ezViewHWP/aspx/FilterUser.aspx", false);
            xmlHTTP.send(xmlDom);
        }

        function btnFileAttach_onclick() {
            try {
                var ret = openFileAttachUI();
            } catch (e) {
                alert("ezdraftui_hwp.aspx.btnFileAttach_onclick()::" + e.description);
            }
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
            bAttachProcess = false;
            if (OpenInformationUI("<%=RM.GetString("t148")%><br><%=RM.GetString("t149")%>")) {
                if (OpenFlag == "Y") {
                    DelOpenInfo();
                }
                window.close();
            }

}

window.onbeforeunload = function () {

    if (bAttachProcess == false) {
        if ((!draftFlag && DraftFlag == "DRAFT") || (!draftFlag && AprState == "" && DraftFlag == "REDRAFT"))
            UndoDoc();
    }

    try {
        if (bAttachProcess == false)
            window.opener.openergetDocInfo();
    } catch (e) { }

    try {
        if (bAttachProcess == false)
            window.opener.Refresh_Window();
    } catch (e) { }

    try {
        bAttachProcess = true;
    } catch (e) { }
}

function btn_Attach_onclick() {
    btnFileAttach_onclick();
}

function btnMail_onclick() {
    window.open("/myoffice/ezEmail/newmail.aspx?cmd=docsend&DocID=" + pDocID + "&DocHref=" + pFormHref, '', 'height=700,width=690,resizable=yes,scrollbars=no' + GetOpenPosition(690, 700));
}

function btnDocInfo_onclick() {
    try {

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
        setPublicFlag();
        SummaryFlag = true;
    } catch (e) {
        alert("ezdraftui_hwp.aspx.btnDocInfo_onclick()::" + e.description);
    }
}

function setPublicFlag() {
    try {
        if (!HwpCtrl.CheckFieldExist("publication"))
            return;

        var PublicType = pPublicityCode.substring(0, 1);
        var PublicLevel = pPublicityCode.substring(1, 9);
        var PublicText = "";
        if (pLimitRange != "")
            PublicText = " (" + pLimitRange + ")";

        if (PublicType == "1")
            PublicText = "<%=RM.GetString("t47")%>";
	else if (PublicType == "2")
	    PublicText = "<%=RM.GetString("t150")%>" + getPublicLevel(PublicLevel);
	else if (PublicType == "3")
	    PublicText = "<%=RM.GetString("t46")%>" + getPublicLevel(PublicLevel);
	else
	    PublicText = " ";

    HwpCtrl.SetFieldText("publication", PublicText);

} catch (e) {
    alert("ezdraftui_hwp.aspx.setPublicFlag()::" + e.description);
}
}

function getPublicLevel(PublicLevel) {
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
        alert("ezdraftui_hwp.aspx.btnSetTaskCode_onclick()::" + e.description);
    }
}

function btnAddSepAttach_onclick() {
    try {
        if (cabinetID == "") {
            var pAlertContent = "<%=RM.GetString("t1401")%>";
	    OpenAlertUI(pAlertContent);
	    return;
	}

    var g_SepAttachLVXml = "";
    g_SepAttachLVXml = GetDocumentElement(HwpCtrl, "SepAttachLVXml");
    if (!g_SepAttachLVXml)
        g_SepAttachLVXml = "";

    var para = new Array();
    para[0] = g_SepAttachLVXml;
    para[1] = cabinetID;

    var url = "/myoffice/ezApprovalG/ezCabinet/InsSepAttach.aspx";
    var feature = "dialogWidth:730px;dialogHeight:353px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";

    if (url != "")
        var rtn = window.showModalDialog(url, para, feature);

    if (rtn[0] == "TRUE") {
        g_SepAttachLVXml = rtn[1];
        SetDocumentElement(HwpCtrl, "SepAttachLVXml", g_SepAttachLVXml);
    }
} catch (e) {
    alert("ezdraftui_hwp.aspx.btnAddSepAttach_onclick()::" + e.description);
}
}

function GetSepAttParamXml(g_SepAttachLVXml) {

    try {
        var rtnXml = createXmlDom();

        var root = createNodeInsert(rtnXml, root, "SEPATTACHINFO");
        var sepAtt, Data, i;
        if (g_SepAttachLVXml != "") {
            var sepLVXml = createXmlDom();
            sepLVXml = loadXMLString(g_SepAttachLVXml);
            var rows = SelectNodes(sepLVXml, "LISTVIEWDATA/ROWS/ROW")
            for (i = 0; i < rows.length; i++) {

                sepAtt = createNodeAndAppandNode(sepLVXml, root, sepAtt, "SEPATTACH");
                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "CABINETID", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA1")));
                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "TITLE", getNodeText(rows.item(i).childNodes(1).selectSingleNode("VALUE")));
                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "NUMOFPAGE", getNodeText(rows.item(i).childNodes(4).selectSingleNode("VALUE")));
                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "REGTYPE", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA2")));
                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "SUMMARY", getNodeText(rows.item(i).childNodes(6).selectSingleNode("VALUE")));
                Data = createNodeAndAppandNodeText(sepLVXml, root, Data, "AVTYPE", getNodeText(rows.item(i).childNodes(0).selectSingleNode("DATA3")));

            }
        }
        return getXmlString(rtnXml);
    } catch (e) {
        alert("ezdraftui_hwp.aspx.GetSepAttParamXml()::" + e.description);
    }
}

function btnhistory_onclick() {
    getHistory();
}
function btnApprovalInfo(pGubun) {

    try {

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
        parameter[11] = gamsaCount;
        parameter[12] = "DRAFT";
        parameter[17] = AprLineArea;
        parameter[18] = HapyuiArea;
        parameter[28] = onlydocinfiview
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
        parameter[40] = SummaryOuterReceiverList;
        parameter[41] = tempKeyword;
        parameter[42] = pPassAproveUseYN; // 20161025 소방 기결재통과
        parameter[43] = pDeptAuth;
        parameter[44] = pAddress_Gubun; //소방 기안문 내부결재 기본처리(20170210)
        if (tempItemCode != "")
            tempdocnumcode = tempItemCode;

        if (pGubun == undefined)
            pGubun = CheckGubun;

        //2016.02.26 원문공개 Flag 추가
        var url = "/myoffice/ezApprovalG/ezLINE/ezApprovalInfo.aspx?initFlag=1&Gubun=" + pGubun + "&OpenFlag=" + OpenFlag + "&pAprState=" + AprState;
        url = url + "&DeptCode=" + escape(Doc24Code) + "&DeptName=" + escape(Doc24Name);//20190104 문서24 부서코드

        var feature = "status:no;dialogWidth:1000px;dialogHeight:740px;help:no;scroll:no;;edge:sunken;";
        var ret = window.showModalDialog(url, parameter, feature);

        if (ret != undefined && ret[0] == "OK") {

            var savexmlhttp = createXMLHttpRequest();

            if (ret[1] != false) {

                pPassAproveUseYN = ret[17]; // 20161025 소방 기결재통과
                if (pPassAproveUseYN == "Y" && pDraftFlag == "REDRAFT" && AprState=="004") { //소방 반송만 기결재 통과(2017016)
                    pAprTempLine = ret[1];
                }
                else {
                    savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave.aspx", false); 
                    savexmlhttp.send(ret[1]);

                    var dataNodes = GetChildNodes(loadXMLString(savexmlhttp.responseText));
                }

                if (pPassAproveUseYN == "N" && pDraftFlag == "REDRAFT" && AprState == "004") { //소방 기결재 취소시 데이터 인설트 및 업데이트(20170131)
                    var XML_dom = "<DATA><PDOCID>" + pDocID + "</PDOCID>"+"<PGUBUN>N</PGUBUN></DATA>";
                    savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezViewHWP/aspx/UpdatePassYN.aspx", false);
                    savexmlhttp.send(XML_dom);
                }

                IsSkipDrafter = "FALSE";
                btnSendDraftEnable = "true";
                // 합의 30명 넘는경우 오류 수정(20170727)
                if (IsAgreementSize30()) {
                    GetDraftAprLineInfoWith30(ret);
                } else {
                    GetDraftAprLineInfo(ret);
                }
            }

            savexmlhttp = null;

            if (pSuSinFlag == "Y" && typeof (ret[2]) == "object") {
                savexmlhttp = createXMLHttpRequest();
                savexmlhttp.open("Post", "/myoffice/ezApprovalG/ezLine/aspx/AprDeptSave.aspx", false);
                savexmlhttp.send(ret[2]);
                btnReceivLineEnable = false;
                SummaryOuterReceiverList = ret[15];
                setRecevInfo(ret[3]);

            } else if (pSuSinFlag == "Y" && ret[2] == "") {
                DeleteDeptInfo();
                setRecevInfo("");
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
            setPublicFlag();
            SummaryFlag = true;
            savexmlhttp = null;
            pAddress_Gubun = ret[25]; //소방 기안문 내부결재 기본처리(20170210)

        }
    } catch (e) {
        alert("ezdraftui_hwp.aspx.GetSepAttParamXml()::" + e.description);
    }
}

function btnSaveServer_onclick(AutoSave) {
    try {
        if (pDraftFlag == "REDRAFT") {

            if (AutoSave == "save") {
                AutoSave = "";
                return;
            } else if (ListType != "21") {
                var pAlertContent = "재기안시 임시저장 할 수 없습니다.";
                OpenAlertUI(pAlertContent);
                return;
            }
        }

        if (AutoSave != "save") {
            if (HwpCtrl.CheckFieldExist("doctitle"))
                pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
            else
                pDocTitle = "<%=RM.GetString("t1394")%>";

            if (pDocTitle == "") {
                var pAlertContent = "<%=RM.GetString("t1395")%>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (pDocTitle.length > 127) {
                var pAlertContent = "<%=RM.GetString("t132")%>";
                OpenAlertUI(pAlertContent);
                return;
            }
        } else {

            if (HwpCtrl.CheckFieldExist("doctitle"))
                pDocTitle = trim(HwpCtrl.GetFieldText("doctitle"));
            if (pDocTitle == "")
                return;
        }

        if (btnSendDraftEnable == "false" && ListType != "21") {
            setFirstDrafterAuto();
        }


        if (ListType == "21" && DraftFlag == "REDRAFT") {

            RemoveTmpDoc(DocSN);
        }

        var rtnVal = SaveTMPFile();
        if (rtnVal == "TRUE") {
            rtnVal = SaveTMPDocInfo(AutoSave, Saveflag);
            if (rtnVal == "TRUE") {
                if (AutoSave != "save") {
                    var pAlertContent = "<%=RM.GetString("t1581") %>";
                    OpenAlertUI(pAlertContent);
                    Saveflag = true;
                    window.close();
                } else {
                    Saveflag = true;
                }
            } else {
                var pAlertContent = strLang217;
                OpenAlertUI(pAlertContent);
                return false;
            }

        } else {
            var pAlertContent = strLang217;
            OpenAlertUI(pAlertContent);
            return false;
        }

    } catch (e) {
        alert("ezdraftui_hwp.aspx.btnSaveServer_onclick()::" + e.description);
    }
}

        function btnHelper_onclick() {
            var rtnVal = ExcuteInfo("INIT", "");
            if (!rtnVal) {
            }
        }

        function window_onbeforeunload() {
            if (bAttachProcess == false) {
                if ((!draftFlag && DraftFlag == "DRAFT") || (!draftFlag && AprState == "" && DraftFlag == "REDRAFT"))
                    UndoDoc();
            }
            try {
                if (bAttachProcess == false)
                    window.opener.openergetDocInfo();
            }
            catch (e)
            { }
            try {
                if (bAttachProcess == false)
                    window.opener.Refresh_Window();
            }
            catch (e)
            { }
            try {
                bAttachProcess = true;
            }
            catch (e) { }
        }
    </script>
</head>
<body class="popup">
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul>
                        <li id="btnSelForm"><span onclick="return btnSelForm_onclick()"><%=RM.GetString("t152")%></span></li>
                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo()"><%=RM.GetString("t1742")%></span></li>
                        <li id="btnReturn" style="display: none"><span onclick="return btnSendDraft_onclick()"><%=RM.GetString("t155")%></span></li>
                        <li id="btnSendDraft"><span onclick="return btnSendDraft_onclick()"><%=RM.GetString("t156")%></span></li>
                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><%=RM.GetString("t55")%></span></li>
                        <li id="btnFileAttach"><span onclick="return btnFileAttach_onclick()"><%=RM.GetString("t56")%></span></li>
                        <li id="btnAprDocAttach"><span onclick="return btnAprDocAttach_onclick()"><%=RM.GetString("t57")%></span></li>
                        <li id="btnAddSepAttach"><span onclick="btnAddSepAttach_onclick()"><%=RM.GetString("t58")%></span></li>
                        <li id="btnSave"><span onclick="return btnSave_onclick()"><%=RM.GetString("t59")%></span></li>
                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><%=RM.GetString("t60")%></span></li>
                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><%=RM.GetString("t61")%></span></li>
                        <li id="btnConn" style="display: none"><span onclick="return btnConn_onclick()"><%=RM.GetString("t157")%></span></li>
                        <li id="btnSaveServer"><span onclick="return btnSaveServer_onclick()"><%=RM.GetString("t4000")%></span></li>
                        <li id="btnHelper" style="display: none"><span onclick="return btnHelper_onclick()"><%=RM.GetString("t157")%></span></li>
                    </ul>
                    <ul style="display: none;">
                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><%=RM.GetString("t54")%></span></li>
                        <li id="btnSetTaskCode"><span onclick="btnSetTaskCode_onclick()"><%=RM.GetString("t9994")%></span></li>
                        <li id="btnSetReceivLine"><span onclick="return btnSetReceivLine_onclick()"><%=RM.GetString("t154")%></span></li>
                        <li id="btnSetAprLine"><span onclick="return btnSetAprLine_onclick()"><%=RM.GetString("t153")%></span></li>
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
    <xml id="SA_coredata"></xml>
</body>
</html>
