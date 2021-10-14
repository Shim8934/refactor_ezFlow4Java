<%@ Page Language="C#" Inherits="Kaoni.ezStandard.ezApprovalInfo" CodeFile="ezApprovalInfo.aspx.cs" %>

<!DOCTYPE HTML>
<html id="htmlhag" style="overflow: hidden">
<head>
    <title><%=RM.GetString("t1742")%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript"> var pNoneActiveX = "<%=NoneActiveX%>"; </script>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css">
    <link rel="stylesheet" href="<%=MakeFileVersionPath("/css/organ_tree.css") %>" type="text/css">
    <link rel="stylesheet" href="<%=MakeFileVersionPath("/css/Tab.css") %>" type="text/css">
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_Cross.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezCabinet/MiscFunc_Cross.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/TabMenu.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/control_cross/TreeView.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/TreeViewCtrl_Cross.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/control_Cross/ListView_list.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/AprlineG.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/AprlineV.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/TempLineinfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/LineinfoIni.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/Lineinfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/SelectSubTitles.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/Receptinfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/TempReceptinfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/Cabinetinfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/CabCategoryInfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/CabRoleInfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezLine/js/Docinfo.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/control/composeappt.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/control/datepicker.htc.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/NameControl.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
        <!--2016.02.25 원문공개-->
   <%-- <script type="text/javascript" src="/myoffice/ezApprovalG/OpenGov/js/OpenGov.js"></script>--%>
    <script type="text/javascript">
        var OrderCell = "";
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
        var companyID = "<%=userinfo.CompanyID%>";
        var CompanyID = "<%=userinfo.CompanyID%>";
        var UserLang = "<%=userinfo.Lang%>";
        var DeptID = "<%=userinfo.DeptID%>";
        var USE_OCS = "<%= _USE_OCS %>";
        var linealt1 = "<%=RM.GetString("t1742")%>";
        var linealt2 = "<%=RM.GetString("t228")%>";
        var linealt3 = "<%=RM.GetString("t226")%>";
        var linealt4 = "<%=RM.GetString("t227")%>";
        var linealt5 = "<%=RM.GetString("t396")%>";
        var linealt6 = "<%=RM.GetString("t394")%>";
        var linealt7 = "<%=RM.GetString("t395")%>";
        var linealt8 = "<%=RM.GetString("t396")%>";
        var linealt9 = "<%=RM.GetString("t393")%>";
        var linealt10 = "<%=RM.GetString("t399")%>";
        var linealt11 = "<%=RM.GetString("t400")%>";
        var linealt12 = "<%=RM.GetString("t228")%>";
        var linealt13 = "<%=RM.GetString("t2001")%>";
        var linealt14 = "<%=RM.GetString("t322")%>";
        var linealt15 = "<%=RM.GetString("t323")%>";
        var linealt16 = "<%=RM.GetString("t324")%>";
        var linealt17 = "<%=RM.GetString("t1178")%>";
        var Cabinet1 = "<%=RM.GetString("t379")%>";
        var Cabinet2 = "<%=RM.GetString("t572")%>";
        var Cabinet3 = "<%=RM.GetString("t573")%>";
        var Cabinet4 = "<%=RM.GetString("t1081")%>";
        var Cabinet5 = "<%=RM.GetString("t1065")%>";
        var Cabinet6 = "<%=RM.GetString("t1160")%>";
        var Docalt1 = "<%=RM.GetString("t1202")%>";
        var Docalt2 = "<%=RM.GetString("t288")%>";
        var Docalt3 = "<%=RM.GetString("t289")%>";
        var Docalt4 = "<%=RM.GetString("t10030")%>";
        var pUserID = arr_userinfo[1];
        var tempAprTypeXML = "<%=_AprTypeXML%>";
        var AprTypeXML = createXmlDom();
        var pAprLineTempletFlag = false;
        var p_CheckAprLineTempletSN;
        var p_CheckAprLineTempletName;
        var pDocID;
        var pFormID;
        var pSignCount;
        var pHapYuiCount;
        var pGamSaCount;
        var pReDraftFlag;
        var pSuSinFlag;
        var pChamJoFlag;
        var pGongramCount;
        var pReDraftAprLineFlag;
        var chkReDraft = "";
        var pAprLineArea;
        var pHapyuiArea;
        var ppDocType;
        var pSelAprLineState;
        var WorkFlowXML = createXmlDom();
        var WorkFlowString = "";
        var WorkFlowOption = "AUTO";
        var optGamsabu = "<%=_optGamsabu%>";
        var ProcessorXML = createXmlDom();
        var InsertMode = "Add";
        var pAprLineXml = new Array();
        var DeptAddIndex = 1;
        var Draftinfoini = false;
        var Lineinfoini = false;
        var Lineinfoini2 = false;
        var Recinfoini = false;
        var Recinfoini2 = false;
        var Recinfoini3 = false;
        var Recinfoini4 = false;
		var Recinfoini5 = false;    //2018.11.25 문서24
        var Opinionini = false;
        var internalTab = true;
        var pSelAprLineType;
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
        var onlydocinfiview = true;
        var onlyviewsusin = false;
        var pIniGubun = "<%= pGubun %>";
        var AdminYN = "FALSE";
        var szRoleInfo = "<%=userinfo.RollInfo%>";
        var g_bRecAdmin = false;
        var g_bDeptCharger = false;
        var g_InitFlag = "<%=_InitFlag%>";
        var bDisplayFlag = "0";
        var bSpecialFlag = "0";
        var arrTask = new Array();
        var rtnVal = new Array();
        var g_SelCabID = "";
        var APRLINE = "";
        var vSecurity, vAprUrgency, vSummery, vAprSecurity;
        var vdocdisplay, vPublicFlag, vtreatment, vPageNum;
        var chkReporter = false;
        var chkSuggester = false;
        var SummaryFlag;
        
        var pDocSn = "<%=pDocSn%>";
        var SusinGroupUseFlag = "<%= SusinGroupUseFlag %>";
        var T1361andT1362 = "<%=RM.GetString("t1361")%><br><%=RM.GetString("t1362")%>";
        var SummaryOuterReceiverList = "";
        var UserTitle = "<%= UserTitle %>"; 
        var UserDeptID = "<%= UserDeptID %>";
        var pPassAproveUseYN = "N";  //20161025 소방 기결재통과
        var pDeptAuth = "";
        var DocOpenFlag = "1"; // 20161116 소방 원문공개(공개정보)
        var ListOpenFlag = "Y"; // 20161117 소방 원문공개(목록공개)

        //2016.11.23 원문공개
        var OpenFlag = "<%= OpenFlag %>";
        var Use_GovOpenDoc = "<%= Use_GovOpenDoc %>";
        var pAuditUserID = "<%=_AuditUserID %>";
        //20161226 소방 기결재통과 임시저장 구분값
        var pAprState = "<%=pAprState_ %>";
        //20170104 소방 기안자가 결재선 수정
        var pGian = "<%=pGian %>";
        var Address_Flag = "false"; //소방 기안문 내부결재 디폴트 처리(20170210)
        var DocGovCheckInfo = false; //소방 원문공재 체크했는지 확인(20180403)
                
        var Doc24Code = "<%=_Doc24Code %>"; //20190104 문서24 부서코드
        var Doc24Name = "<%=_Doc24Name %>"; //20190104 문서24 부서이름

        window.onload = function () {
            if (UserDeptID != "") {
                if (arr_userinfo[3] != UserTitle || arr_userinfo[4] != UserDeptID) {
                    OpenAlertUI(strLang364, btn_Close);

                    if (!CrossYN() && pNONEACTIVEX == "NO")
                        window.close();
                }
            }
            if (MACSAFARIYN()) {
                window.resizeBy(0, 35);
            }
            if (screen.height >= 900) {
                document.getElementById("orgbtnArea").style.display = "";
                document.getElementById("btnArea").style.display = "none";
            }
            else {
                document.getElementById("orgbtnArea").style.display = "none";
                document.getElementById("btnArea").style.display = "inline";
            }


            GetDocInfo();
            AprTypeXML = loadXMLString(tempAprTypeXML);
            //2016.04.05 원문공개 Frame 호출
            //ChangeTab(document.getElementById("1tab5"));
            ChangeTab(document.getElementById("1tab1"));
            document.getElementById('textUser').focus();
            if (SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[0] == null) {
                document.getElementById("deptaddbtn").style.display = "none";
            }

            if (pGamSaCount > 0)
                document.getElementById("auditaddbtn").style.display = "none"; //소방 일상감사 임시 숨김처리(20170208)
            else
                document.getElementById("auditaddbtn").style.display = "none";

            CheckGubunInit();
            if (pFormID == "2009000127" && Address_Flag == "false" && pReDraftFlag == "DRAFT") { //소방 기안문 수신처 내부결재 기본처리(20170210)
                Address_Flag="true"
                ChangeTab(document.getElementById("1tab2"));
                ChangeTab(document.getElementById("1tab1"));
                SuSinAddress();
            }

            if (window.screen.height <= 768) {
                window.resizeTo(1000, 720);
                document.getElementById("bodytag").style.overflow = "auto";
                document.getElementById("htmlhag").style.overflow = "auto";
            }
        }
        
        function SuSinAddress() {
            var passFlag = false;

            var listview = new ListView();
            listview.LoadFromID("lvRECEPTLIST");

            var InitTr = listview.GetDataRows();

            if (InitTr.length == 0) {
                passFlag = true;
            }
            else {
                if ((GetAttribute(InitTr[0], "DATA1") != null ? GetAttribute(InitTr[0], "DATA1").indexOf("Address") : -1) != -1) {
                    passFlag = true;
                }
                if (InitTr[0].id.indexOf("noItems") > 0)
                    passFlag = true;

            }
            AprLineAddDeptAddress_Gian("내부결재");
        }


        function AprLineAddDeptAddress_Gian(AddressName) {
            var Resultxml = "";
            Resultxml.async = false;
            Resultxml = loadXMLFile(strLangEtcFile1);

            var listview = new ListView();
            listview.SetID("lvRECEPTLIST");
            listview.SetRowOnDblClick("AprDeptDel_onclick");

            var DeptAddIndex = listview.GetDataRows().length;
            if (DeptAddIndex == 0 || listview.GetDataRows()[0].id.indexOf("noItems") == -1)
                DeptAddIndex = DeptAddIndex + 1;

            var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
            if (Doc24Code.substr(0, 2) == "MA") { //20190104 완료회신 수신처 변경
                setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
                setNodeText(GetChildNodes(objNodes[0])[1], Doc24Code);   //문서24code 
                setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
                setNodeText(GetChildNodes(objNodes[0])[3], "Y");
                setNodeText(GetChildNodes(objNodes[0])[4], "N");
                setNodeText(GetChildNodes(objNodes[0])[5], "N");
                setNodeText(GetChildNodes(objNodes[0])[6], "");
                setNodeText(GetChildNodes(objNodes[0])[7], "");
                setNodeText(GetChildNodes(objNodes[0])[8], "");
                setNodeText(GetChildNodes(objNodes[0])[9], "");
                setNodeText(GetChildNodes(objNodes[0])[10], Doc24Name);   //문서24 name
                setNodeText(GetChildNodes(objNodes[0])[11], Doc24Name);   //문서24 name
                setNodeText(GetChildNodes(objNodes[0])[12], "");
                setNodeText(GetChildNodes(objNodes[0])[13], "");
                setNodeText(GetChildNodes(objNodes[1])[0], Doc24Name);     //문서24 name
            } else {
                setNodeText(GetChildNodes(objNodes[0])[0], DeptAddIndex);
                setNodeText(GetChildNodes(objNodes[0])[1], "Address" + DeptAddIndex);
                setNodeText(GetChildNodes(objNodes[0])[2], pDocID);
                setNodeText(GetChildNodes(objNodes[0])[3], "Y");
                setNodeText(GetChildNodes(objNodes[0])[4], "N");
                setNodeText(GetChildNodes(objNodes[0])[5], "N");
                setNodeText(GetChildNodes(objNodes[0])[6], "");
                setNodeText(GetChildNodes(objNodes[0])[7], "");
                setNodeText(GetChildNodes(objNodes[0])[8], "");
                setNodeText(GetChildNodes(objNodes[0])[9], "");
                setNodeText(GetChildNodes(objNodes[0])[10], AddressName);
                setNodeText(GetChildNodes(objNodes[0])[11], AddressName);
                setNodeText(GetChildNodes(objNodes[0])[12], "");
                setNodeText(GetChildNodes(objNodes[0])[13], "");
                setNodeText(GetChildNodes(objNodes[1])[0], AddressName);
            }

            var tr = listview.GetSelectedRows();
            var InitTr = listview.GetDataRows();

            var MaxID = 0;
            for (var j = 0  ; j < InitTr.length  ; j++) {
                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
                if (MaxID < curnum)
                    MaxID = curnum;
            }

            if (tr.length == 0) {
                if (InitTr.length == 0) {
                    document.getElementById('RECEPTLIST').innerHTML = "";
                    var listview = new ListView();
                    listview.SetID("lvRECEPTLIST");
                    listview.SetMulSelectable(false);
                    listview.SetHeightFree(true);
                    listview.SetRowOnDblClick("AprDeptDel_onclick");
                    listview.DataSource(Resultxml);
                    listview.DataBind("RECEPTLIST");
                } else {
                    var SelIndex = Number(listview.GetSelectedIndexes().split(',')[0]);
                    var objTr = listview.AddRow(SelIndex);
                    SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                    listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);
                }
            } else {
                var objTr = listview.AddRow(Number(listview.GetSelectedIndexes().split(',')[0]));
                SetAttribute(objTr, "id", "lvRECEPTLIST" + "_TR_" + eval(MaxID + 1));
                listview.AddDataRow(objTr, Resultxml.documentElement.getElementsByTagName("ROW")[0]);

                ReSetAprLineDept(listview);
            }

            DeptAddIndex = DeptAddIndex + 1;

            return true;
        }


        function KeEventControl(obj) {
            useragt = navigator.userAgent.toUpperCase();
            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
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
        function pNodeDblClick() {
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
            pDocID = RetValue[0];
            pFormID = RetValue[1];
            pSignCount = RetValue[2];
            pSignInfo = RetValue[3];
            pHapYuiCount = RetValue[4];
            pReDraftFlag = RetValue[5];
            pSuSinFlag = RetValue[6];
            pChamJoFlag = RetValue[7];
            pGongramCount = RetValue[8];
            pReDraftAprLineFlag = RetValue[9];
            pDocType = RetValue[10];
            pGamSaCount = RetValue[11];
            chkReDraft = RetValue[13];
            if (pReDraftAprLineFlag) pOrgApruserid = RetValue[13];

            onlydocinfiview = RetValue[28];
            onlyviewsusin = RetValue[29]; // 20161114 수신전용
            g_SelCabID = RetValue[30];


            vSecurity = RetValue[31];
            vAprUrgency = RetValue[32];
            vSummery = RetValue[33];
            vdocdisplay = RetValue[34];
            vPublicFlag = RetValue[35];
            vtreatment = RetValue[36];
            vPageNum = RetValue[37];
            vAprSecurity = trim(RetValue[38]);
            SummaryFlag = RetValue[39];
            if (pSuSinFlag == "N") {
                document.getElementById("showReceptinfo").style.display = "none";
            }

            try {

                SummaryOuterReceiverList = RetValue[40];
                if (SummaryOuterReceiverList != "" && SummaryOuterReceiverList != undefined) {
                    document.getElementById("inputSummaryOuterReceiverList").value = SummaryOuterReceiverList;
                    document.getElementById("trSummaryOuterReceiverList").style.display = "";
                }

                pkeyword = RetValue[41];

                if (pkeyword != "" && pkeyword != undefined)
                {
                    document.getElementById("keyword").value = pkeyword;
                }

                pPassAproveUseYN = RetValue[42];  //20161025 소방 기결재통과

                pDeptAuth = RetValue[43]; // 20161031 소방 비공개문서 부서원공개

                Address_Flag = RetValue[44]; //소방 기안문 내부결재 기본처리(20170210)
                //2016.11.23 원문공개
                //if (Use_GovOpenDoc == "YES") {
                //    InitGovInfo(pDocID);
                //}


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
            else if (pIniGubun == "5") {
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("1tab2").onclick();
                ChangeTab(document.getElementById("1tab2"))
                liniReceptOuter();
            }
            else if (pIniGubun == "6") {
                if (pGian == "Y") { //소방 기안자 결재선 수정(20170106)
                    document.getElementById("showReceptinfo").style.display = "none";
                    document.getElementById("showCabinetinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("showDocinfo").style.display = "none";
                    document.getElementById("1tab1").onclick();
                    document.getElementById("2tab1").onclick(); 
                    document.getElementById("PassAproveUse").style.display = "none"; //소방 진행문서 기결재 통과 안보이도록(20170131)
                    document.getElementById("PassAproveUse_txt").style.display = "none";
                }
                else {
                    document.getElementById("showReceptinfo").style.display = "none";
                    document.getElementById("showCabinetinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("1tab1").onclick();
                    document.getElementById("2tab1").onclick();
                    document.getElementById("PassAproveUse").style.display = "none"; //소방 진행문서 기결재 통과 안보이도록(20170131)
                    document.getElementById("PassAproveUse_txt").style.display = "none";
                }
            }
            else if (pIniGubun == "7") {
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("1tab4").onclick();
                ChangeTab(document.getElementById("1tab4"))
            }
            else if (pIniGubun == "8") {
                if (pGian == "Y") { //소방 기안자 결재선 수정(20170106)
                    document.getElementById("showCabinetinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("showReceptinfo").style.display = "none";
                    //document.getElementById("showDocinfo").style.display = "none";
                    //소방고도화 결재진행문서 문서정보 보이도록(20170721)
                    document.getElementById("showDocinfo").style.display = ""; 
                    document.getElementById("Docinfo").disabled = true;
                    document.getElementById("txt_Reason").disabled = true;
                    document.getElementById("keyword").disabled = true;
                    document.getElementById("taSummery").disabled = true;
                    document.getElementById("txtLimitRange").disabled = true;
                    document.getElementById("txtPageNum").disabled = true;

                    document.getElementById("1tab1").onclick();
                    document.getElementById("2tab1").onclick();
                    document.getElementById("PassAproveUse").style.display = "none"; //소방 진행문서 기결재 통과 안보이도록(20170131)
                    document.getElementById("PassAproveUse_txt").style.display = "none";
                    liniReceptOuter();
                }
                else {
                    document.getElementById("showCabinetinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("1tab1").onclick();
                    document.getElementById("2tab1").onclick();
                    document.getElementById("PassAproveUse").style.display = "none"; //소방 진행문서 기결재 통과 안보이도록(20170131)
                    document.getElementById("PassAproveUse_txt").style.display = "none";
                    liniReceptOuter();
                }
            }
            else if (pIniGubun == "9") {
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
            }
            else if (pIniGubun == "10") {
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab2").onclick();
                ChangeTab(document.getElementById("1tab2"))
                liniReceptOuter();
            }
            else if (pIniGubun == "11") {
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("1tab1").onclick();
                document.getElementById("2tab1").onclick();
            }
            else if (pIniGubun == "12") {
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("1tab3").onclick();
                ChangeTab(document.getElementById("1tab3"))
            }
            else if (pIniGubun == "13") {
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showReceptinfo").style.display = "none";
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Receptinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab3").onclick();
                ChangeTab(document.getElementById("1tab3"))
            }
            else if (pIniGubun == "14") {
                document.getElementById("showDocinfo").style.display = "none";
                document.getElementById("showAprLine").style.display = "none";
                document.getElementById("showCabinetinfo").style.display = "none";
                document.getElementById("Lineinfo").style.display = "none";
                document.getElementById("Cabinetinfo").style.display = "none";
                document.getElementById("Docinfo").style.display = "none";
                document.getElementById("1tab2").onclick();
                ChangeTab(document.getElementById("1tab2"))
                ChangeReceptTab(document.getElementById("3tab4"));
                liniReceptOuter();
                initReceptListView();
                document.getElementById("3tab4").onclick();
            }
            //    //2016.02.26 원문공개
            //else if (pIniGubun == "15") {
            //    document.getElementById("1tab5").onclick();
            //}
            if (pHapYuiCount == 0) {
                document.getElementById("deptaddbtn").style.display = "none";
            }
            //2016.02.25 원문공개

            //document.getElementById("deptaddbtn").style.display = "none";

            //if (OpenFlag == "N") {
            //    document.getElementById("showOpeninfo").style.display = "none";
            //    document.getElementById("Openinfo").style.display = "none";
            //}
        }

        var bool = false;
        var bool2 = false;
        var bool3 = false;
        var bool4 = false;
        var bool5 = false;
        var Check_doc = false;
        function ChangeTab(obj) {

            var pSelectTab = GetAttribute(obj, "divname");
            document.getElementById(pSelectTab).style.display = "";

            switch (pSelectTab) {
                case "Lineinfo":
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "none";
                    //2016.02.26 원문공개
                    //document.getElementById("Openinfo").style.display = "none";
                    if (!bool)
                        Lineinfo_ini();
                    bool = true;
                    break;
                case "Receptinfo":
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "none";
                    //2016.02.26 원문공개
                    //document.getElementById("Openinfo").style.display = "none";
                    if (!bool2)
                        Receptinfo_ini();
                    bool2 = true;
                    break;
                case "Cabinetinfo":
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Docinfo").style.display = "none";
                    //2016.02.26 원문공개
                    //document.getElementById("Openinfo").style.display = "none";
                    if (!bool3) {
                        Cabinetinfo_ini();
                        //Docinfo_ini();
                    }
                    bool3 = true;
                    //bool4 = true;
                    break;
                case "Docinfo":
                    document.getElementById("Lineinfo").style.display = "none";
                    document.getElementById("Receptinfo").style.display = "none";
                    document.getElementById("Cabinetinfo").style.display = "none";
                    //2016.02.26 원문공개
                    //document.getElementById("Openinfo").style.display = "none";
                    if (!bool4)
                        Docinfo_ini();
                    bool4 = true;
                    Check_doc = true; //소방 비공개 수정(20170214)
                    OpenUseFlag = "Y"; //소방 문서정보 플래그추가(20170719)
                    DocGovCheckInfo = true; //소방 원문공개 확인했는지 체크(20180403)
                    break;
                //case "Openinfo":
                //    document.getElementById("Lineinfo").style.display = "none";
                //    document.getElementById("Receptinfo").style.display = "none";
                //    document.getElementById("Cabinetinfo").style.display = "none";
                //    document.getElementById("Docinfo").style.display = "none";
                //    if (!bool5) {
                //        OpenInfo_ini();
                //    }
                //    bool5 = true;
                //    break;
                case "Opinioninfo":
                    break;

            }
        }

        //2016.02.25 원문공개
        //function OpenInfo_ini() {
        //    document.getElementById("OpenFrame").src = "/myoffice/ezApprovalG/OpenGov/OpenGovInfo.aspx?TYPE=APR&DOCID=" + pDocID;
        //}


        function Suggester_onclick() {
            try {
                var pAPRLINE = new ListView();
                pAPRLINE.LoadFromID("lvAPRLINE");

                var CurSelRow = pAPRLINE.GetSelectedRows();

                if (CurSelRow.length <= 0) {
                    OpenAlertUI("<%=RM.GetString("t389")%>")
                    Suggester.checked = false;
                    return;
                }

                if (CurSelRow.length > 0) {

                    var pSelectedRow = pAPRLINE.GetSelectedRows();
                    if (pSelectedRow) {
                        var RCheckVal = Suggester.checked;
                        var p_CurAprStat = getNodeText(pSelectedRow[0].cells[5]);
                    }
                }
                else {
                    OpenAlertUI("<%=RM.GetString("t389")%>")
                Suggester.checked = false;
                return;
            }

            var pTmpAprLineType;
            pTmpAprLineType = "003";
            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");

            if (pSelectedRow.length != 0 && (p_CurAprStat != pTmpAprLineType || pReDraftFlag == "REDRAFT")) {

                if (RCheckVal) {
                    SetAttribute(pSelectedRow[0], "DATA8", "Y");

                    if (getNodeText(pSelectedRow[0].cells[0]).indexOf("★") == -1)
                        setNodeText(pSelectedRow[0].cells[0] , "★" + getNodeText(pSelectedRow[0].cells[0]));
                    
                    chkSuggester = true;
                } else {
                    SetAttribute(pSelectedRow[0], "DATA8", "N");
                    var rep = /★/g

                    setNodeText(pSelectedRow[0].cells[0] , getNodeText(pSelectedRow[0].cells[0]).replace(rep, ""));
                    
                    chkSuggester = false;
                }
            }
        } catch (e) {
            alert("Suggester_onclick :: " + e.description);
        }
    }


    function Reporter_onclick() {
        try {
            var pAPRLINE = new ListView();
            pAPRLINE.LoadFromID("lvAPRLINE");

            var CurSelRow = pAPRLINE.GetSelectedRows();

            if (CurSelRow.length <= 0) {
                OpenAlertUI("<%=RM.GetString("t390")%>")
                Reporter.checked = false;
                return;
            }

            if (CurSelRow.length > 0) {
                var pSelectedRow = pAPRLINE.GetSelectedRows();
                if (pSelectedRow) {
                    var RCheckVal = Reporter.checked;
                    var p_CurAprStat = getNodeText(pSelectedRow[0].cells[5]);
                }
            }
            else {
                OpenAlertUI("<%=RM.GetString("t390")%>")
                Reporter.checked = false;
                return;
            }

            var pTmpAprLineType;

            pTmpAprLineType = "003";
            pTmpAprLineType = ConvertAprLineState(pTmpAprLineType, "Value");
            if (pSelectedRow.length != 0 && (p_CurAprStat != pTmpAprLineType || pReDraftFlag == "REDRAFT")) {
                if (RCheckVal) {
                    SetAttribute(pSelectedRow[0], "DATA9", "Y")

                    if (getNodeText(pSelectedRow[0].cells[0]).indexOf("⊙") == -1)
                        setNodeText(pSelectedRow[0].cells[0] , "⊙" + getNodeText(pSelectedRow[0].cells[0]));
                    
                    chkReporter = true;
                } else {
                    SetAttribute(pSelectedRow[0], "DATA9", "N")
                    var rep = /⊙/g

                    setNodeText(pSelectedRow[0].cells[0] , getNodeText(pSelectedRow[0].cells[0]).replace(rep, ""));
                    
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
            var objNode;
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "getDate", "");

            xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/GetDateDB.aspx", false);
            xmlhttp.send(xmlpara);

            return xmlhttp.responseText;
        }
        catch (e) {
            alert("getGyulJeDateDB()" + e.description);
        }
    }

    function PassYNCheck() { //소방 기결재 통과 여부 확인 함수(20170131)
        try {
            var objNode;
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();

            createNodeInsert(xmlpara, objNode, "DATA");
            createNodeAndInsertText(xmlpara, objNode, "PDOCID", pDocID);

            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/aprlinesave_passyn_Check.aspx", false);
            xmlhttp.send(xmlpara);
            return xmlhttp.responseXML;
        }
        catch (e) {
            alert("PassYNCheck()" + e.description);
        }
    }


    var OpenUseFlag = "N"; //소방 문서정보 플래그추가(20170719)
    function btn_OK() {
        try {
            var PassXML = PassYNCheck(); //소방 기결재 통과 여부 확인 함수(20170131)
            var PassDocCheck = "";
            if (document.getElementsByName("rdoSecType")[2].checked) { //소방 비공개 문서일경우 비공개 사유무조건 적어야함(2017.08.10)
                if (document.getElementById("txt_Reason").value == "") {
                    alert("비공개 사유를 입력해야합니다.");
                    return;
                }
            }

            if (PassXML.getElementsByTagName("DOCID")[0] != null) {
                if (CrossYN()) {
                    PassDocCheck = PassXML.getElementsByTagName("DOCID")[0].textContent;
                }
                else {
                    PassDocCheck = PassXML.getElementsByTagName("DOCID")[0].text;
                }
            }

            if (!onlydocinfiview) {
                //20161027 소방 기결재통과
                if (pPassAproveUseYN == "Y" && pReDraftFlag == "REDRAFT" && pAprState=="004") { //소방 기결재통과 임시저장 예외처리(20161226)
                    if (PassDocCheck != "") {
                        var pAlertContent = "이미 기결재 통과를 취소한 문서입니다.";
                        OpenAlertUI(pAlertContent);
                        pPassAproveUseYN = "N";
                    }
                    else {
                        var pInformationContent = "" + strKFILang1 + "";
                        var ans = OpenInformationUI(pInformationContent);
                        if (!ans) {
                            pPassAproveUseYN = "N";
                        }
                    }
                }
                
                ret[0] = "OK";

                var line = Checkline();
                if (line == false) {
                    return;
                }
                if (pIniGubun != 5 && pIniGubun != 7 && pIniGubun != 10 && pIniGubun != 12) {
                    var rtnVal = CheckSignCellValueLast();

                    if (!rtnVal)
                        return;
                }
                if (pIniGubun != 5 && pIniGubun != 6 && pIniGubun != 7 && pIniGubun != 9 && pIniGubun != 10 && pIniGubun != 8) { //소방 결재선선택시 철 생략(20170201) pIniGubun=8 추가

                    if (DocGovCheckInfo == false) { //소방 문서정보 확인안하는 기안안되도록 수정(20180403)
                        alert("문서정보 확인을 해주시기 바랍니다.");
                        document.getElementById("1tab4").onclick();
                        return;
                    }

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
                    }
                    else {
                        if (MyRows.length > 0) {
                            if (GetAttribute(MyRows[0], "DATA1") == "") {
                                OpenAlertUI(Cabinet4);
                                document.getElementById("1tab3").onclick();
                                return;
                            }
                            else
                                totalRows = MyRows;
                        }
                        else if (totalRows.length > 0) {
                            if (GetAttribute(totalRows[0], "DATA1") == "") {
                                OpenAlertUI(Cabinet4);
                                document.getElementById("1tab3").onclick();
                                return;
                            }
                        }
                    }

                    if (MyTaskFlag != "") {
                        OpenAlertUI(MyTaskFlag + "</br>" + Cabinet4);
                        document.getElementById("1tab3").onclick();
                        return;
                    }
                }

                ////2016.02.25 원문공개
                //if (OpenFlag == "Y") {
                //    if (OpenFrame.pDocID == undefined) {
                //        OpenAlertUI("원문공개를 설정해주세요");
                //        document.getElementById("1tab5").onclick();
                //        return;
                //    }

                //    //2016.04.04 공개여부 체크
                //    if (OpenFrame.document.getElementById("OpenLevel").value == "0") {
                //        OpenAlertUI("공개여부를 선택하세요.");
                //        document.getElementById("1tab5").onclick();
                //        return;
                //    }

                //    //2016.04.04 비공개근거 체크
                //    if (OpenFrame.getPublicFlag() == "3NNNNNNNN") {
                //        OpenAlertUI("비공개근거 1~8호 중 하나라도 선택해주세요.");
                //        document.getElementById("1tab5").onclick();
                //        return;
                //    }
                //    //2016.04.04 비공개 사유내역 체크
                //    if (OpenFrame.document.getElementById("OpenLevel").value == "3" && OpenFrame.document.getElementById("txt_Reason").value == "") {
                //        OpenAlertUI("비공개 사유내역을 입력해주세요.");
                //        document.getElementById("1tab5").onclick();
                //        return;
                //    }
                //}

                if (SummaryFlag)
                    Docinfo_ini();

                var chkDocinfoFlag = checkDocinfo();
                if (!chkDocinfoFlag) {
                    var tabshow = document.getElementById("1tab4");
                    Tab1_MouseClick(tabshow);
                    return;
                }

                //20161117 소방 원문공개
                if (OpenUseFlag == "Y") { //소방 문서정보 플래그 추가(20170719)
                    if (!SaveOpenGovInfo())
                        return;
                }
                ret[1] = SaveAprLineList();
                if (ret[1]=="N") { //소방 기안자가 결재선 변경시 분기처리(20170106)
                    return;
                }

                CheckAprPerson();
                var listview = new ListView();
                listview.LoadFromID("lvRECEPTLIST");
                var receptRow = listview.GetDataRows();

                if (receptRow.length > 0 && receptRow[0].id.indexOf("noItems") == -1) {
                    ret[2] = AprDeptListXML();
                    ret[3] = MakertnVal();
                }
                else
                    ret[2] = "";

                if (pIniGubun != 5 && pIniGubun != 6 && pIniGubun != 7 && pIniGubun != 9 && pIniGubun != 10 && pIniGubun != 8) { //소방 결재선선택시 철 생략(20170201) pIniGubun=8 추가
                    ret[4] = GetSelCabInfoXml(totalRows);
                }

                if (pReDraftAprLineChangeFlag) {
                    ret[5] = "R";
                }
                else {
                    ret[5] = "C";
                }

                ret[7] = selSecLevel.value;
                if (AprUrgency.checked)
                    ret[8] = "Y";
                else
                    ret[8] = "N";
                ret[9] = document.getElementById("taSummery").value;
                ret[10] = getdocdisplay();
                ret[11] = getPublicFlag();
                ret[12] = txtLimitRange.value;
                ret[13] = txtPageNum.value;

                if (document.getElementById("AprSecurity").checked)
                    ret[14] = document.getElementById("idDatepicker").value.substring(0, 10);
                else
                    ret[14] = "";

                if (document.getElementById("inputSummaryOuterReceiverList").value != "") {
                    ret[15] = document.getElementById("inputSummaryOuterReceiverList").value;
                } else {
                    ret[15] = "";
                }

                //20161020 소방 키워드 추가
                if (document.getElementById("keyword").value != "") {
                    ret[16] = document.getElementById("keyword").value;
                } else {
                    ret[16] = "";
                }

                ret[17] = pPassAproveUseYN; //20161025 소방 기결재통과

                if (document.getElementsByName("rdoSecType")[2].checked && document.getElementById("etcSecType").value == "Y") {
                    ret[18] = "Y";
                }
                else if (document.getElementsByName("rdoSecType")[2].checked && document.getElementById("etcSecType").value == "A") { //소방고도화 전사공개 추가(20170711)
                    ret[18] = "A";
                }
                else if (document.getElementsByName("rdoSecType")[2].checked && document.getElementById("etcSecType").value == "N") { //결재선 공개
                    ret[18] = "N";
                }
                else {
                    ret[18] = "";
                }
                ////2016.02.25 원문공개
                //if (OpenFlag == "Y") {
                //    ret[19] = OpenFrame.document.getElementById("OpenLevel").value;
                //    ret[20] = SaveOpenGovInfo();
                //}

                ret[25] = Address_Flag; //소방 기안문 내부결재 디폴트 처리(20170210)

                if (ReturnFunction != null) {
                    ReturnFunction(ret);
                }
                else {
                    window.returnValue = ret;
                }
                window.close();
            }
            else if (onlyviewsusin) { //20161114 소방 시행문변환
                ret[0] = "OK";
                ret[2] = AprDeptListXML();
                ret[3] = MakertnVal();
                if (ReturnFunction != null) {
                    ReturnFunction(ret);
                }
                else
                    window.returnValue = ret;
                window.close();
            }
            else {
                var docinfo = MakeDocInfo();
                ret[0] = "OK";
                ret[1] = docinfo;
                ret[6] = "OnlyDocInfo";
            }
        }
        catch (e) {
            OpenAlertUI("<%=RM.GetString("t1600")%>");
            ret[0] = "FALSE";
        }
    }

    function CheckAprPerson() {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRLINE");

        var xmlpara = createXmlDom();
        xmlhttp = createXMLHttpRequest();
        var msg = "";
        var objNode;

        for (var i = 0; i < pAPRLINE.GetRowCount() ; i++) {
            msg += "'" + GetAttribute(document.getElementById("lvAPRLINE").childNodes[1].childNodes[i], "DATA4") + "',";
        }

        msg = msg.substring(0, msg.lastIndexOf(','));

        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "CELL", msg);
        xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/CheckAprPerson.aspx", false);
        xmlhttp.onreadystatechange = resultCheckAprPerson;
        xmlhttp.send(xmlpara);
    }

    function resultCheckAprPerson() {

        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

            var temp = loadXMLString(xmlhttp.responseText);
            alertMsg = "";
            var selNodes = SelectNodes(temp, "DATA/ROW");
            for (var i = 0; i < selNodes.length; i++) {
                var StartDT = getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[3];
                var EndDT = getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[4];
                var NowDT = new Date();
                if (NowDT.getFullYear() >= StartDT.split('-')[0] && NowDT.getFullYear() <= EndDT.split('-')[0] && NowDT.toLocaleString().split(' ')[1].split('월')[0] >= Number(StartDT.split('-')[1]) && NowDT.toLocaleString().split(' ')[1].split('월')[0] <= Number(EndDT.split('-')[1])) {
                    if (StartDT.split('-')[1] != EndDT.split('-')[1]) {
                        if (NowDT.toLocaleString().split(' ')[1].split('월')[0] == Number(StartDT.split('-')[1]) && NowDT.getDate() >= Number(StartDT.split('-')[2].split(' ')[0])) {
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
                        }
                        else if (NowDT.toLocaleString().split(' ')[1].split('월')[0] > Number(StartDT.split('-')[1]) && NowDT.toLocaleString().split(' ')[1].split('월')[0] < Number(EndDT.split('-')[1])) {
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[UserLang]) + strLang324 + "";
                            alertMsg += getNodeText(GetChildNodes(selNodes[i])[3]).split(':')[1] + strLang325 + "";
                        }
                        else if (NowDT.toLocaleString().split(' ')[1].split('월')[0] == Number(EndDT.split('-')[1]) && NowDT.getDate() <= Number(EndDT.split('-')[2].split(' ')[0])) {
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
    }

    function MakertnVal() {
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");

        var i;
        var rows = listview.GetDataRows();
        if (rows.length == 0)
            return "";

        var xmlpara = createXmlDom();
        var objRoot, objRow, objDocinfoNode;
        objRoot = createNodeInsert(xmlpara, objRoot, "ROWS");

        for (i = 0; i < rows.length; i++) {
            objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "NAME", getNodeText(rows[i].cells[1]));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTID", GetAttribute(rows[i], "DATA1"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME", GetAttribute(rows[i], "DATA2"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EXTRECEPTYN", GetAttribute(rows[i], "DATA3"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "PROCESSYN", GetAttribute(rows[i], "DATA4"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "CANEDITYN", GetAttribute(rows[i], "DATA5"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "EMAIL", GetAttribute(rows[i], "DATA6"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "JOBTITLE", GetAttribute(rows[i], "DATA9"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME1", GetAttribute(rows[i], "DATA10"));
            createNodeAndAppandNodeText(xmlpara, objRow, objDocinfoNode, "DEPTNAME2", GetAttribute(rows[i], "DATA11"));
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

            var url = "/myoffice/ezApprovalG/ezCabinet/CreateCabinet_Cross.aspx";

            createcabinet_cross_dialogArguments[0] = para;
            createcabinet_cross_dialogArguments[1] = btnCreateCab_onclick_Complete;

            if (CrossYN() || pNoneActiveX == "YES") {
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
                alert("<%=RM.GetString("t10028")%>");
                return;
            }
            var rtn = NewVolume(trim(GetAttribute(selnode, "DATA1")), trim(GetAttribute(selnode, "DATA3")));
        }
        else {
            alert("<%=RM.GetString("t478")%>");
        }
    }

    function Docinfo_ini() {
        SummaryFlag = false;
        var rtnVal = new Array();
        initdatepicker();
        document.getElementById("taSummery").value = "";

        onload_window();
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
        if (vPublicFlag.trim() != "") {
            setPublicFlag(vPublicFlag);
        }
        else {
            if (Check_doc == false) { //소방 비공개 문서 오류수정(20170214)
                rdoSecType_onclick("1");
            }
            
        }
        if (Check_doc == false) { //소방 비공개 문서 오류수정(20170214)
            if (pDeptAuth == "Y") {
                document.getElementById("etcSecType").value = "Y";
            }
            else if (pDeptAuth == "A") { //소방고도화 전사공개 추가(20170711)
                document.getElementById("etcSecType").value = "A";
            }
            else if (pDeptAuth == "N") {
                document.getElementById("etcSecType").value = "N"; //소방 디폴트 값은 전사공유(20170712)
            }
            else {
                document.getElementById("etcSecType").value = "A"; //소방 디폴트 값은 전사공유(20170712)
            }
            //소방 공개전환일자 고도화(20170718)
            if (pDeptAuth != "") {
                if (document.getElementById("selSecLevel5").checked == true) { //소방 비공개 5호일때만 공개전환 가능(20170718)
                    if (document.getElementById("selSecLevel1").checked == true || document.getElementById("selSecLevel2").checked == true || document.getElementById("selSecLevel3").checked == true || document.getElementById("selSecLevel4").checked == true ||
                        document.getElementById("selSecLevel6").checked == true || document.getElementById("selSecLevel7").checked == true || document.getElementById("selSecLevel8").checked == true) {
                        document.getElementById("LimitDateCheck_open").disabled = true;
                        document.getElementById("LimitDateCheck_open").checked = false;
                        document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                        document.getElementById("idDatepickerLimit_open").disabled = true;
                    }
                    else {
                        document.getElementById("LimitDateCheck_open").disabled = false;
                        //document.getElementById("img_Post_D1_Limit_open").style.display = "";
                        //document.getElementById("idDatepickerLimit_open").disabled = false;
                    }
                }
                else {
                    document.getElementById("LimitDateCheck_open").disabled = true;
                    document.getElementById("LimitDateCheck_open").checked = false;
                    document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                    document.getElementById("idDatepickerLimit_open").disabled = true;
                }
            }
        }

        if (vAprSecurity.trim() != "") {
            document.getElementById("AprSecurity").checked = true;
            var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
            idDatepicker.attachEvent('datechange', onStartDateChanged);
            idDatepicker.attachEvent('enddatechange', onEndDateChanged);
            idDatepicker.elemDateButtons = "img_Post_D1;img_Post_D2";
            idDatepicker.elemDateInputs = "idDatepicker;Post_D2";
            idDatepicker.popupType = "both";
            idDatepicker.pickerDateFormat = "[yyyy]<%=RM.GetString("t1108")%>";
            idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
            idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
            idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
            idDatepicker.firstDayOfWeek = "0";
            idDatepicker.textAM = "<%=RM.GetString("t971")%>";
            idDatepicker.textPM = "<%=RM.GetString("t972")%>";
            idDatepicker.textDecimal = ".";
            idDatepicker.textHoursAbbrev = "<%=RM.GetString("t1109")%>";
            idDatepicker.textMustSpecifyValidTime = "<%=RM.GetString("t1110")%>";
            idDatepicker.daynameLetters = "<%=RM.GetString("t1111")%>";
            idDatepicker.daynamesShort = "<%=RM.GetString("t1111")%>";
            idDatepicker.daynamesLong = "<%=RM.GetString("t1112")%>";
            idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
            idDatepicker.monthnamesLong = "1<%=RM.GetString("t1113")%>";
            idDatepicker.isoDateUTF = vAprSecurity + "T00:00:00.000Z";
            idDatepicker.isoEndDateUTF = vAprSecurity + "T00:00:00.000Z";
            idDatepicker.ready();
        }
        else {
            document.getElementById("AprSecurity").checked = false;
            AprSecurity_onClick();
        }
        document.getElementById("txtLimitRange").value = vtreatment;
        document.getElementById("txtPageNum").value = vPageNum;
        rtnVal[0] = document.getElementById("selSecLevel").value;

        //20161117 소방 원문공개
        if (pDocID != "") {
            if (pIniGubun == "11") { //소방 원문공개정보 수신처일경우 원부서 아이디를 가져간다(20171106)
                var OrgDocID = OrgDocID_Info(pDocID);
                InitGovInfo(OrgDocID);
                InitGovInfo_open(OrgDocID); //소방 공개전환일자 추가(20170719)
                InitAttach(OrgDocID);

            }
            else {
                InitGovInfo(pDocID);
                InitGovInfo_open(pDocID); //소방 공개전환일자 추가(20170719)
                InitAttach(pDocID);
            }
        }


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

        if (CrossYN() || pNoneActiveX == "YES") {
        }
        else
            window.returnValue = rtnVal;
    }
    function initdatepicker() {
        var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
        idDatepicker.attachEvent('datechange', onStartDateChanged);
        idDatepicker.attachEvent('enddatechange', onEndDateChanged);
        idDatepicker.elemDateButtons = "img_Post_D1;img_Post_D2";
        idDatepicker.elemDateInputs = "idDatepicker;Post_D2";
        idDatepicker.popupType = "both";
        idDatepicker.pickerDateFormat = "[yyyy]<%=RM.GetString("t1108")%>";
        idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
        idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
        idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
        idDatepicker.firstDayOfWeek = "0";
        idDatepicker.textAM = "<%=RM.GetString("t971")%>";
        idDatepicker.textPM = "<%=RM.GetString("t972")%>";
        idDatepicker.textDecimal = ".";
        idDatepicker.textHoursAbbrev = "<%=RM.GetString("t1109")%>";
        idDatepicker.textMustSpecifyValidTime = "<%=RM.GetString("t1110")%>";
        idDatepicker.daynameLetters = "<%=RM.GetString("t1111")%>";
        idDatepicker.daynamesShort = "<%=RM.GetString("t1111")%>";
        idDatepicker.daynamesLong = "<%=RM.GetString("t1112")%>";
        idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
        idDatepicker.monthnamesLong = "1<%=RM.GetString("t1113")%>";
        idDatepicker.isoDateUTF = "<%=DateTime.Parse(startDateTime.ToString()).ToString("o")%>"
        idDatepicker.isoEndDateUTF = "<%=DateTime.Parse(endDateTime.ToString()).ToString("o")%>"
        idDatepicker.ready();

        var idDatepickerLimit = new datepicker('idDatepickerLimit', 'idDatepickerLimit'); //소방 열람제한일자
        idDatepickerLimit.attachEvent('datechange', onStartDateChanged);
        idDatepickerLimit.attachEvent('enddatechange', onEndDateChanged);
        idDatepickerLimit.elemDateButtons = "img_Post_D1_Limit;img_Post_D2_Limit";
        idDatepickerLimit.elemDateInputs = "idDatepickerLimit;Post_D2_Limit";
        idDatepickerLimit.popupType = "both";
        idDatepickerLimit.pickerDateFormat = "[yyyy]<%=RM.GetString("t1108")%>";
        idDatepickerLimit.pickerTimeFormat = "[tt] [h]:[mm]";
        idDatepickerLimit.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
        idDatepickerLimit.inputTimeFormat = "[tt] [h]:[mm]";
        idDatepickerLimit.firstDayOfWeek = "0";
        idDatepickerLimit.textAM = "<%=RM.GetString("t971")%>";
        idDatepickerLimit.textPM = "<%=RM.GetString("t972")%>";
        idDatepickerLimit.textDecimal = ".";
        idDatepickerLimit.textHoursAbbrev = "<%=RM.GetString("t1109")%>";
        idDatepickerLimit.textMustSpecifyValidTime = "<%=RM.GetString("t1110")%>";
        idDatepickerLimit.daynameLetters = "<%=RM.GetString("t1111")%>";
        idDatepickerLimit.daynamesShort = "<%=RM.GetString("t1111")%>";
        idDatepickerLimit.daynamesLong = "<%=RM.GetString("t1112")%>";
        idDatepickerLimit.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
        idDatepickerLimit.monthnamesLong = "1<%=RM.GetString("t1113")%>";
        idDatepickerLimit.isoDateUTF = "<%=DateTime.Parse(startDateTime.ToString()).ToString("o")%>"
        idDatepickerLimit.isoEndDateUTF = "<%=DateTime.Parse(endDateTime.ToString()).ToString("o")%>"
        idDatepickerLimit.ready();

        var idDatepickerLimit_open = new datepicker('idDatepickerLimit_open', 'idDatepickerLimit_open'); //소방 공개전환일자 추가 (20170718)
        idDatepickerLimit_open.attachEvent('datechange', onStartDateChanged);
        idDatepickerLimit_open.attachEvent('enddatechange', onEndDateChanged);
        idDatepickerLimit_open.elemDateButtons = "img_Post_D1_Limit_open;img_Post_D2_Limit_open";
        idDatepickerLimit_open.elemDateInputs = "idDatepickerLimit_open;Post_D2_Limit_open";
        idDatepickerLimit_open.popupType = "both";
        idDatepickerLimit_open.pickerDateFormat = "[yyyy]<%=RM.GetString("t1108")%>";
        idDatepickerLimit_open.pickerTimeFormat = "[tt] [h]:[mm]";
        idDatepickerLimit_open.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
        idDatepickerLimit_open.inputTimeFormat = "[tt] [h]:[mm]";
        idDatepickerLimit_open.firstDayOfWeek = "0";
        idDatepickerLimit_open.textAM = "<%=RM.GetString("t971")%>";
        idDatepickerLimit_open.textPM = "<%=RM.GetString("t972")%>";
        idDatepickerLimit_open.textDecimal = ".";
        idDatepickerLimit_open.textHoursAbbrev = "<%=RM.GetString("t1109")%>";
        idDatepickerLimit_open.textMustSpecifyValidTime = "<%=RM.GetString("t1110")%>";
        idDatepickerLimit_open.daynameLetters = "<%=RM.GetString("t1111")%>";
        idDatepickerLimit_open.daynamesShort = "<%=RM.GetString("t1111")%>";
        idDatepickerLimit_open.daynamesLong = "<%=RM.GetString("t1112")%>";
        idDatepickerLimit_open.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
        idDatepickerLimit_open.monthnamesLong = "1<%=RM.GetString("t1113")%>";
        idDatepickerLimit_open.isoDateUTF = "<%=DateTime.Parse(startDateTime.ToString()).ToString("o")%>"
        idDatepickerLimit_open.isoEndDateUTF = "<%=DateTime.Parse(endDateTime.ToString()).ToString("o")%>"
        idDatepickerLimit_open.ready();
    }
    var aprdeptname_cross_dialogArguments = new Array();
    function btnaddressChange() {
        var listview = new ListView();
        listview.LoadFromID("lvRECEPTLIST");
        var CurSelRow = listview.GetSelectedRows();
        var windowName = "/myoffice/ezApprovalG/ezLine/AprDeptName.aspx";
        var parameter = "status:no;dialogWidth:340px;dialogHeight:195px;scroll:no;edge:sunken;help:no";

        if (CurSelRow[0] == undefined) {
            alert("<%=RM.GetString("t10501")%>");
            return;
        }

        if (GetAttribute(CurSelRow[0], "DATA6").trim() != "") {
            alert("<%=RM.GetString("t10500")%>");
            return;
        }

        var dialogValue = getNodeText(CurSelRow[0].cells[1]);
        if (CrossYN() || pNoneActiveX == "YES") {
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
                setNodeText(CurSelRow[0].cells[1] , AddressName);
            }
            else {
                setNodeText(CurSelRow[0].cells[1] , AddressName);
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
            setNodeText(CurSelRow[0].cells[1] , AddressName);
        }
        else {
            setNodeText(CurSelRow[0].cells[1] , AddressName);
        }
        SetAttribute(CurSelRow[0], "DATA10", AddressName);
        SetAttribute(CurSelRow[0], "DATA11", AddressName);
    }

    //20161025 소방 기결재통과
    function PassAproveUse_onclick() {
        if (document.getElementById("PassAproveUse").checked) {
            var PassXML = PassYNCheck(); //소방 기결재 통과 여부 확인 함수(20170131)
            var PassDocCheck = "";
            if (PassXML.getElementsByTagName("DOCID")[0] != null) {
                if (CrossYN()) {
                    PassDocCheck = PassXML.getElementsByTagName("DOCID")[0].textContent;
                }
                else {
                    PassDocCheck = PassXML.getElementsByTagName("DOCID")[0].text;
                }
            }

            var pInformationContent = strKFILang1;
            var pAlertContent = "이미 기결재 통과를 취소한 문서입니다.";
            if (PassDocCheck != "") {
                OpenAlertUI(pAlertContent);
                pPassAproveUseYN = "N";
                document.getElementById("PassAproveUse").checked = false;
            }
            else if (pPassAproveUseYN == "N") { //기결재 통과플래그값 변경(20170131)
                OpenAlertUI(pAlertContent);
                pPassAproveUseYN = "N";
                document.getElementById("PassAproveUse").checked = false;
            }
            else {
                var Ans = OpenInformationUI(pInformationContent);
                if (Ans) {
                    pPassAproveUseYN = "Y";
                    LineAprTyepSetAll();
                }
                else {
                    pPassAproveUseYN = "N";
                    document.getElementById("PassAproveUse").checked = false;
                    LineAprTyepSetAll();
                }
            }
        }
        else {
            pPassAproveUseYN = "N";
            LineAprTyepSetAll();
        }
    }

    var pAppType = "APR";
    var xmlhttpGov = createXMLHttpRequest();
    function InitGovInfo(pDocID) {
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
        createNodeAndInsertText(xmlpara, objNode, "pMode", pAppType);

        xmlhttpGov.open("Post", "/myoffice/ezApprovalG/OpenGov/aspx/GetOpenGovInfo.aspx", true);
        xmlhttpGov.onreadystatechange = InitGovInfo_after;
        xmlhttpGov.send(xmlpara);
    }

    function InitGovInfo_after() {
        if (xmlhttpGov.readyState == 4 && xmlhttpGov.status == 200) {
            var Resultxml = loadXMLString(xmlhttpGov.responseText);

            if (SelectNodes(Resultxml, "DATA/ROW").length > 0) {
                //document.getElementById("showOpeninfo").style.display = ""; //원문공개 탭정보(20161123)
                initOpenFlag = true;
                var InfoXml = SelectNodes(Resultxml, "DATA/ROW");
                DocOpenFlag = SelectSingleNodeValue(InfoXml[0], "OPENFLAG").substring(0, 1);
                document.getElementById("txt_Reason").value = SelectSingleNodeValue(InfoXml[0], "REASON");
                ListOpenFlag = SelectSingleNodeValue(InfoXml[0], "LISTOPENFLAG");
                if (ListOpenFlag == "Y") {
                    document.getElementById("ListOpenCheck").checked = true;
                }
                else {
                    document.getElementById("ListOpenCheck").checked = false;
                }

                if (DocOpenFlag != "3") {
                    document.getElementById("LimitDateCheck").checked = false;
                    document.getElementById("LimitDateCheck").disabled = false;
                }
                else {
                    document.getElementById("LimitDateCheck").checked = false;
                    document.getElementById("LimitDateCheck").disabled = true;
                }


                var OpenLimitDateValue = SelectSingleNodeValue(InfoXml[0], "OPENLIMITDATE")

                if (OpenLimitDateValue.length >= 10)
                    OpenLimitDateValue = OpenLimitDateValue.substring(0, 10);
                else
                    OpenLimitDateValue = "";

                if (OpenLimitDateValue.trim() != "") {
                    document.getElementById("LimitDateCheck").checked = true;
                    document.getElementById("LimitDateCheck").disabled = false;
                    document.getElementById("idDatepickerLimit").disabled = false;
                    document.getElementById("img_Post_D1_Limit").style.display = "";

                    var idDatepickerLimit = new datepicker('idDatepickerLimit', 'idDatepickerLimit');
                    idDatepickerLimit.attachEvent('datechange', onStartDateChanged);
                    idDatepickerLimit.attachEvent('enddatechange', onEndDateChanged);
                    idDatepickerLimit.elemDateButtons = "img_Post_D1_Limit;img_Post_D2_Limit";
                    idDatepickerLimit.elemDateInputs = "idDatepickerLimit;Post_D2_Limit";
                    idDatepickerLimit.popupType = "both";
                    idDatepickerLimit.pickerDateFormat = "[yyyy]<%=RM.GetString("t1108")%>";
                    idDatepickerLimit.pickerTimeFormat = "[tt] [h]:[mm]";
                    idDatepickerLimit.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
                    idDatepickerLimit.inputTimeFormat = "[tt] [h]:[mm]";
                    idDatepickerLimit.firstDayOfWeek = "0";
                    idDatepickerLimit.textAM = "<%=RM.GetString("t971")%>";
                    idDatepickerLimit.textPM = "<%=RM.GetString("t972")%>";
                    idDatepickerLimit.textDecimal = ".";
                    idDatepickerLimit.textHoursAbbrev = "<%=RM.GetString("t1109")%>";
                    idDatepickerLimit.textMustSpecifyValidTime = "<%=RM.GetString("t1110")%>";
                    idDatepickerLimit.daynameLetters = "<%=RM.GetString("t1111")%>";
                    idDatepickerLimit.daynamesShort = "<%=RM.GetString("t1111")%>";
                    idDatepickerLimit.daynamesLong = "<%=RM.GetString("t1112")%>";
                    idDatepickerLimit.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
                    idDatepickerLimit.monthnamesLong = "1<%=RM.GetString("t1113")%>";
                    idDatepickerLimit.isoDateUTF = OpenLimitDateValue + "T00:00:00.000Z";
                    idDatepickerLimit.isoEndDateUTF = OpenLimitDateValue + "T00:00:00.000Z";
                    idDatepickerLimit.ready();
                }
                else {
                    document.getElementById("LimitDateCheck").checked = false;
                    document.getElementById("idDatepickerLimit").disabled = true;
                    document.getElementById("img_Post_D1_Limit").style.display = "none";
                }
            }
            //else {
            //    if (OpenFlag == "Y") { //원문공개 플래그(20161123)
            //        document.getElementById("showOpeninfo").style.display = "";
            //    }
            //    else {
            //        document.getElementById("showOpeninfo").style.display = "none";
            //    }
            //}
    }
    }

        function OrgDocID_Info(pDocID) { //소방 원문공개 ORGDOCID 가져오기(20171106)
            var xmlHTTP_ = createXMLHttpRequest();
            var xmlDom_ = "<DATA>" + "<SDOCID>" + pDocID + "</SDOCID>" + "</DATA>";
            xmlHTTP_.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/OpenOrgDocIDInfo.aspx", false);
            xmlHTTP_.send(xmlDom_);
            var xmlDoc_ = xmlHTTP_.responseXML;
            var OrgDocID = "";
            if (CrossYN()) {
                OrgDocID = xmlDoc_.getElementsByTagName("ORGDOCID")[0].textContent;
            }
            else {
                if (xmlDoc_.getElementsByTagName("ORGDOCID")[0].text == undefined) {
                    OrgDocID = xmlDoc_.getElementsByTagName("ORGDOCID")[0].textContent;
                }
                else {
                    OrgDocID = xmlDoc_.getElementsByTagName("ORGDOCID")[0].text;
                }
            }
            return OrgDocID;
        }



        var xmlhttpGov_open = createXMLHttpRequest();
        function InitGovInfo_open(pDocID) { //소방 공개전환일자 추가(20170719)
            var xmlpara = createXmlDom();

            var objNode;
            createNodeInsert(xmlpara, objNode, "PARAMETER");
            createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "pMode", pAppType);

            xmlhttpGov_open.open("Post", "/myoffice/ezApprovalG/OpenGov/aspx/GetOpenGovInfo_open.aspx", true);
            xmlhttpGov_open.onreadystatechange = InitGovInfo_open_after;
            xmlhttpGov_open.send(xmlpara);
        }

        function InitGovInfo_open_after() {
            if (xmlhttpGov_open.readyState == 4 && xmlhttpGov_open.status == 200) {
                var Resultxml = loadXMLString(xmlhttpGov_open.responseText);

                if (SelectNodes(Resultxml, "DATA/ROW").length > 0) {
                    initOpenFlag = true;
                    var InfoXml = SelectNodes(Resultxml, "DATA/ROW");
                    DocOpenFlag = SelectSingleNodeValue(InfoXml[0], "OPENFLAG").substring(0, 1);
                    document.getElementById("txt_Reason").value = SelectSingleNodeValue(InfoXml[0], "REASON");
                    ListOpenFlag = SelectSingleNodeValue(InfoXml[0], "LISTOPENFLAG");
                    if (ListOpenFlag == "Y") {
                        document.getElementById("ListOpenCheck").checked = true;
                    }
                    else {
                        document.getElementById("ListOpenCheck").checked = false;
                    }

                    if (DocOpenFlag != "3") {
                        document.getElementById("LimitDateCheck").checked = false;
                        document.getElementById("LimitDateCheck").disabled = false;
                    }
                    else {
                        document.getElementById("LimitDateCheck").checked = false;
                        document.getElementById("LimitDateCheck").disabled = true;
                    }


                    var OpenLimitDateValue_open = SelectSingleNodeValue(InfoXml[0], "SENDOPENDATE")

                    if (OpenLimitDateValue_open.length >= 10)
                        OpenLimitDateValue_open = OpenLimitDateValue_open.substring(0, 10);
                    else
                        OpenLimitDateValue_open = "";
                    if (OpenLimitDateValue_open.trim() != "") {
                        document.getElementById("LimitDateCheck_open").checked = true;
                        document.getElementById("LimitDateCheck_open").disabled = false;
                        document.getElementById("idDatepickerLimit_open").disabled = false;
                        document.getElementById("img_Post_D1_Limit_open").style.display = "";

                        var idDatepickerLimit_open = new datepicker('idDatepickerLimit_open', 'idDatepickerLimit_open');
                        idDatepickerLimit_open.attachEvent('datechange', onStartDateChanged);
                        idDatepickerLimit_open.attachEvent('enddatechange', onEndDateChanged);
                        idDatepickerLimit_open.elemDateButtons = "img_Post_D1_Limit_open;img_Post_D2_Limit_open";
                        idDatepickerLimit_open.elemDateInputs = "idDatepickerLimit_open;Post_D2_Limit_open";
                        idDatepickerLimit_open.popupType = "both";
                        idDatepickerLimit_open.pickerDateFormat = "[yyyy]<%=RM.GetString("t1108")%>";
                        idDatepickerLimit_open.pickerTimeFormat = "[tt] [h]:[mm]";
                        idDatepickerLimit_open.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
                        idDatepickerLimit_open.inputTimeFormat = "[tt] [h]:[mm]";
                        idDatepickerLimit_open.firstDayOfWeek = "0";
                        idDatepickerLimit_open.textAM = "<%=RM.GetString("t971")%>";
                        idDatepickerLimit_open.textPM = "<%=RM.GetString("t972")%>";
                        idDatepickerLimit_open.textDecimal = ".";
                        idDatepickerLimit_open.textHoursAbbrev = "<%=RM.GetString("t1109")%>";
                        idDatepickerLimit_open.textMustSpecifyValidTime = "<%=RM.GetString("t1110")%>";
                        idDatepickerLimit_open.daynameLetters = "<%=RM.GetString("t1111")%>";
                        idDatepickerLimit_open.daynamesShort = "<%=RM.GetString("t1111")%>";
                        idDatepickerLimit_open.daynamesLong = "<%=RM.GetString("t1112")%>";
                        idDatepickerLimit_open.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
                        idDatepickerLimit_open.monthnamesLong = "1<%=RM.GetString("t1113")%>";
                        idDatepickerLimit_open.isoDateUTF = OpenLimitDateValue_open + "T00:00:00.000Z";
                        idDatepickerLimit_open.isoEndDateUTF = OpenLimitDateValue_open + "T00:00:00.000Z";
                        idDatepickerLimit_open.ready();
                    }
                    else {
                        document.getElementById("LimitDateCheck_open").checked = false;
                        document.getElementById("idDatepickerLimit_open").disabled = true;
                        document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                    }
                }
                //else {
                //    document.getElementById("LimitDateCheck_open").checked = false;
                //    document.getElementById("LimitDateCheck_open").disabled = true;
                //    document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                //    document.getElementById("idDatepickerLimit_open").disabled = true;

                //}
        }
    }

        function selOnclick(Gubun) { //소방고도화 전사공개 추가(20170711)
            var SelID = Gubun.id;
            if (SelID == "selEtc") {
                document.getElementById("selEtc").checked = true;
                document.getElementById("selCompany").checked = false;
            }
            else if (SelID == "selCompany") {
                document.getElementById("selEtc").checked = false;
                document.getElementById("selCompany").checked = true;
            }
        }

        function LimitDateCheck_open_onClick() { //소방고도화 공개전환일자 추가(20170718)
            if (document.getElementById("LimitDateCheck_open").checked == true) {
                document.getElementById("img_Post_D1_Limit_open").style.display = "";
                document.getElementById("idDatepickerLimit_open").disabled = "";
            }
            else {
                document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                document.getElementById("idDatepickerLimit_open").disabled = "disabled";
            }
        }

        function SendDocHo(val) { //소방 비공개 5호일경우에만 공개전환일자 가능(20170718)
            var CheckId = val.id;
            if (document.getElementById("selSecLevel5").checked == true && document.getElementById("etcSecType").disabled == false) {
                if (document.getElementById("selSecLevel1").checked == true || document.getElementById("selSecLevel2").checked == true || document.getElementById("selSecLevel3").checked == true || document.getElementById("selSecLevel4").checked == true ||
                    document.getElementById("selSecLevel6").checked == true || document.getElementById("selSecLevel7").checked == true || document.getElementById("selSecLevel8").checked == true) {
                    document.getElementById("LimitDateCheck_open").checked = false;
                    document.getElementById("LimitDateCheck_open").disabled = true;
                    document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                    document.getElementById("idDatepickerLimit_open").disabled = true;
                }
                else {
                    document.getElementById("LimitDateCheck_open").disabled = false;
                    //document.getElementById("img_Post_D1_Limit_open").style.display = "";
                    //document.getElementById("idDatepickerLimit_open").disabled = false;
                }
            }
            else {
                document.getElementById("LimitDateCheck_open").checked = false;
                document.getElementById("LimitDateCheck_open").disabled = true;
                document.getElementById("img_Post_D1_Limit_open").style.display = "none";
                document.getElementById("idDatepickerLimit_open").disabled = true;
            }

        }

    </script>
</head>
<body id="bodytag" class="popup" style="background-color: #ffffff; overflow: hidden">

    <h1><%=RM.GetString("t1742")%>
        <div id="btnArea" style="display: inline; float: right;">
            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_OK()"><%=RM.GetString("t1760")%></span></a>
            <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_Close()"><%=RM.GetString("t1761")%></span></a>
        </div>
    </h1>
    <div class="portlet_tabpart02">
        <div class="portlet_tabpart02_top" id="tab1">
            <p id="showAprLine"><span divname="Lineinfo" id="1tab1"><%=RM.GetString("t1769")%></span></p>
            <p id="showReceptinfo"><span divname="Receptinfo" id="1tab2"><%=RM.GetString("t448")%></span></p>
            <p id="showCabinetinfo"><span divname="Cabinetinfo" id="1tab3"><%=RM.GetString("t51")%></span></p>
            <p id="showDocinfo"><span divname="Docinfo" id="1tab4"><%=RM.GetString("t1204")%></span></p>
            <p id="showOpeninfo" style="display:none"><span divname="Openinfo" id="1tab5">원문공개</span></p>
        </div>
    </div>
    <div id="Approvallist">

        <div id="Lineinfo" style="border: 2px solid #dbdbda; width: 970px; height: 597px;">
            <table>
                <tr>
                    <td style="vertical-align: top">
                        <div class="portlet_tabpart01" style="margin-top: 3px;">
                            <div class="portlet_tabpart01_top" id="tab2">
                                <p><span divname="Organ" id="2tab1"><%=RM.GetString("t232")%></span></p>
                                <p><span divname="Temp" id="2tab2"><%=RM.GetString("G0001")%></span></p>
                            </div>
                        </div>
                        <div id="OrganLineTab" style="display: none; padding-left: 3px">
                            <table style="margin-left: 0px;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <span>
                                            <div id="TreeView" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 247px; width: 388px; border: 1px solid #b6b6b6; background-color: #FFFFFF; margin: 1px 1px 1px 1px;"></div>
                                            <div class="border_gray" style="Width: 389px; Height: 275px;">
                                                <div id="UserList" style="margin: 0px 1px 1px 1px; Width: 388px; Height: 250px; overflow: auto;"></div>
                                            </div>
                                            <div class="border_gray" style="Width: 389px; Height: 275px;display:none">
                                                <div id="AuditUserList" style="margin: 0px 1px 1px 1px; Width: 388px; Height: 250px; overflow: auto;"></div>
                                            </div>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="background-color: transparent; height: 28px;">
                                        <input id="textUser" style="width: 150px" name="textUser" onkeypress="return textUser_onkeypress(event)" maxlength="50">
                                        <a style="margin-top: 2px" class="imgbtn"><span name="btn_searchUser" id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()"><%=RM.GetString("t234")%></span></a>
                                        <a style="margin-top: 2px;display:none" class="imgbtn" onclick="APRDEPTADD();" id="deptaddbtn" ><span><%=RM.GetString("G0002")%></span></a>
										<%--소방 일상감사 임시 숨김처리(20170208)--%>
                                        <a style="margin-top: 2px;display:none" class="imgbtn" onclick="searchAuditUserList();" id="auditaddbtn"><span>일상감사</span></a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div id="TempLineTab" style="display: none;">
                            <table style="margin-left: 5px;">
                                <tr>
                                    <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                        <h2 class="h2_dot"><%=RM.GetString("G0003")%></h2>
                                        <div class="border_gray">
                                            <div id="APRTEMPLIST" style="border: 0px; Width: 386px; Height: 180px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="background-color: transparent; text-align: center; height: 30px;">
                                        <table class="content" style="margin-bottom: 5px; width: 100%;">
                                            <tr>
                                                <td style="vertical-align: middle; text-align: center; padding-top: 3px;">
                                                    <a class="imgbtn"><span id="btn_DelAprLineTemplet" onclick="return btn_DelAprLineTemplet_onclick()"><%=RM.GetString("G0004")%></span></a>
                                                    <a class="imgbtn"><span id="Span1" onclick="return btn_ModifyToAprLine_onclick()"><%=RM.GetString("G0005")%></span></a>
                                                    <a class="imgbtn"><span onclick="return btn_AddToAprLine_onclick()" style="width: 60px;"><%=RM.GetString("t336")%></span></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="vertical-align: top;">
                                        <div class="border_gray">
                                            <div id="APRTEMP" style="Width: 386px; Height: 295px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                    <td style="vertical-align: top">
                        <table style="margin-left: 5px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <h2 class="h2_dot"><%=RM.GetString("t407")%>
                                        <div style="text-align: right; margin-top: -23px; padding-right: 5px">
                                            <a class="imgbtn" onclick="AprlineUpper_onclick();"><span>
                                                <img src="/images/ImgIcon/prev.gif" height="16" alt="결재선 위로" style="vertical-align: middle" /></span></a>
                                            <a class="imgbtn" onclick="AprlineDown_onclick();"><span>
                                                <img src="/images/ImgIcon/next.gif" height="16" alt="결재선 아래로" style="vertical-align: middle" /></span></a>
                                        </div>
                                    </h2>
                                    <div class="border_gray">
                                        <div id="APRLINE" style="Width: 565px; Height: 490px; overflow: auto; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div>
                                        <table class="content" style="margin-top: 5px; width: 100%;">
                                            <tr>
                                                <td colspan="2" style="margin-top: 3px; text-align: center;">
                                                    <input type="checkbox" name="PassAproveUse" id="PassAproveUse" value="checkbox" onclick="return PassAproveUse_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
                                                    <span id="PassAproveUse_txt"><%=RM.GetString("KFI00001")%>&nbsp;</span>
                                                    <input type="checkbox" name="Reporter" id="Reporter" value="checkbox" onclick="return Reporter_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
                                                    <span><%=RM.GetString("t409")%></span>
                                                    <input type="checkbox" id="Suggester" name="Suggester" value="checkbox" onclick="return Suggester_onclick()" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;">
                                                    <span><%=RM.GetString("t410")%></span>
                                                </td>
                                            </tr>
                                            <tr style="display: none">
                                                <th><%=RM.GetString("t411")%></th>
                                                <td>
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <input id="ReasonNoAprTxt" name="ReasonNoAprTxt" type="text" style="width: 100%">
                                                            </td>
                                                            <td style="text-align: right; width: 55px;"><a class="imgbtn">
                                                                <span id="ReasonNoApr" onclick="return ReasonNoApr_onclick()" style="width: 40px"><%=RM.GetString("t336")%></span></a>
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
                                <td style="text-align: right;">
                                    <a style="margin-top: 2px; padding-right: 5px" class="imgbtn"><span id="btn_SaveAprLineTemplet" onclick="return btn_SaveAprLineTemplet_onclick()"><%=RM.GetString("t384")%></span></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

        </div>
    </div>


    <div id="Receptinfo" style="border: 2px solid #dbdbda; width: 970px; height: 597px; display: none;">
        <table>
            <tr>
                <td style="vertical-align: top">
                    <div class="portlet_tabpart01" style="margin-top: 3px; text-align: right;">
                        <div class="portlet_tabpart01_top" id="tab3">
                            <p><span id="3tab1" divname="Organ"><%=RM.GetString("t232")%></span></p>
                            <p><span id="3tab4" divname="Outer"><%=RM.GetString("t330")%></span></p>
                            <p><span id="3tab5" divname="OuterDoc24">문서 24</span></p>
                            <p><span id="3tab2" divname="Save"><%=RM.GetString("G0001")%></span></p>
                            <p><span id="3tab3" divname="Group"><%=RM.GetString("t1568")%></span></p>
                        </div>
                    </div>
                    <div id="ReceptOrgan" style="display: none; padding-left: 3px">
                        <table style="margin-left: 0px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <div id="TreeView2" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 524px; width: 388px; border: 1px solid #b6b6b6; background-color: #FFFFFF; margin: 1px 1px 1px 1px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td height="30" style="background-color: transparent">
                                    <input id="txtDeptName" style="width: 150px" name="textUser" onkeyup="return btnSearchDept_onKeyPress(event)" maxlength="50">
                                    <a style="margin-top: 2px" class="imgbtn"><span id="Span2" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()"><%=RM.GetString("t250")%></span></a>
                                    <a class="imgbtn" style="margin-top: 2px; margin-right: 5px" id="AprDeptAdd" onclick="AprDeptAdd_onclick('DEPT');"><span><%=RM.GetString("G0002")%></span></a>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div id="ReceptOuter" style="display: none; padding-left: 3px">
                        <table style="margin-left: 0px;">
                            <tr>
                                <td style="vertical-align: top;">
                                    <div id="TreeView3" style="margin-top: 5px; overflow-x: auto; overflow-y: auto; height: 518px; width: 388px; border: 1px solid #b6b6b6; background-color: #FFFFFF; margin: 1px 1px 1px 1px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; height: 30px;">
                                    <input id="txtOuterDeptName" style="width: 150px" name="textUser2" onkeyup="return btnSearchDept_onKeyPress2(event)" maxlength="50">
                                    <a style="margin-top: 2px" class="imgbtn"><span id="Span7" onkeyup="return btnSearchDept_onClick()" onclick="return btnSearchDept_onClick()"><%=RM.GetString("t250")%></span></a>
                                    <a class="imgbtn" style="margin-top: 3px;" id="AprDeptOuterAdd" onclick="AprDeptOuterAdd_onclick();">                                        
                                    <%if (userinfo.Lang == "2") {%><span style="width:113px; overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<%=RM.GetString("t1236")%>"><%=RM.GetString("t1236")%></span></a>
                                    <%} %>
                                    <% else {%>
                                   <span><%=RM.GetString("t1236")%></span></a>
                                    <%} %>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div id="ReceptOuterDoc24" style="display: none;">
                        <table>
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                    <div id="RecDoc24List" style="border: 0px; Width: 386px; Height: 518px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;border: 1px solid #b6b6b6; background-color: #FFFFFF; "></div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; height: 30px;">
                                    <input id="txtDoc24" style="width: 150px" name="textUser2" onkeyup="return btnSearchDoc24Dept_onKeyPress(event)" maxlength="50">
                                    <a style="margin-top: 2px" class="imgbtn"><span id="SpanDoc24" onkeyup="return btnSearchDoc24Dept_onClick()" onclick="return btnSearchDoc24Dept_onClick()"><%=RM.GetString("t250")%></span></a>
                                    <a class="imgbtn" id="OuterDoc24Add" onclick="AddDoc24_onclick();"><span><%=RM.GetString("t268")%></span></a>
                                    <a class="imgbtn" id="OuterDoc24Info" onclick="Doc24Info_onclick();"><span>상세보기</span></a>
                                </td>
                            </tr>
                           </table>
                      </div>

                    <div id="ReceptTemp" style="display: none; padding-left: 5px">
                        <table>
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                    <h2 class="h2_dot"><%=RM.GetString("G0003")%></h2>
                                    <div class="border_gray">
                                        <div id="RecSaveList" style="border: 0px; Width: 386px; Height: 237px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; text-align: center; height: 30px;">
                                    <table class="content" style="margin-bottom: 5px; width: 100%;">
                                        <tr>
                                            <td style="text-align: center;">
                                                <a class="imgbtn"><span id="Span3" onclick="return btn_AprDeptTempletDel_onclick()"><%=RM.GetString("t252")%></span></a>
                                                <a class="imgbtn"><span id="Span4" onclick="return btn_AprDeptTempletSave_onclick('MODIFY')"><%=RM.GetString("G0006")%></span></a>
                                                <a class="imgbtn"><span onclick="return btn_AprDeptTempletAdd_onclick()" style="width: 60px;"><%=RM.GetString("t336")%></span></a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top;">
                                    <div class="border_gray">
                                        <div id="RecSaveDetail" style="Width: 386px; Height: 240px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="ReceptGroup" style="display: none; padding-left: 5px">
                        <table>
                            <tr>
                                <td style="background-color: #f3f3f3; padding: 4px 0 3px 0; background-color: #ffffff; height: 20px;">
                                    <h2 class="h2_dot"><%=RM.GetString("G0007")%></h2>
                                    <div class="border_gray">
                                        <div id="RecGroupList" style="border: 0px; Width: 386px; Height: 190px; OVERFLOW: AUTO; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="background-color: transparent; text-align: center; height: 30px;">
                                    <table class="content" style="margin-bottom: 5px; width: 100%">
                                        <tr>
                                            <td style="text-align: center;">
                                                <a class="imgbtn"><span onclick="return btn_GroupReceptAdd_onclick()" style="width: 60px;"><%=RM.GetString("G0008")%></span></a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="vertical-align: top;">
                                    <div class="border_gray">
                                        <div id="RecGroupDetail" style="Width: 386px; Height: 295px; OVERFLOW: AUTO; border: 0px; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>

                <td style="width: 30px; text-align: center;">
                    <div style="display: inline-block;" id="AddRemoveBTN">
                        <img src="/images/arr_rr.gif" alt="" width="16" height="16" border="0" style="cursor: pointer;" id="imgInsertAll" onclick="return InsertRecAll();">
                        <br>
                        <img src="/images/arr_r.gif" alt="" width="16" height="16" border="0" style="cursor: pointer;" id="imgInsert" onclick="return InsertRec();">
                        <br>
                        <img src="/images/arr_l.gif" alt="" width="16" height="16" border="0" style="cursor: pointer;" id="imgDelete" onclick="return DeleteRec();">
                        <br>
                        <img src="/images/arr_ll.gif" alt="" width="16" height="16" border="0" style="cursor: pointer;" id="imgDeleteAll" onclick="return DeleteRecAll();">
                    </div>
                </td>
                <td style="vertical-align: top">
                    <table style="margin-left: 5px;">
                        <tr>
                            <td style="vertical-align: top;" colspan="2">
                                <h2 class="h2_dot"><%=RM.GetString("t253")%></h2>
                                <div class="border_gray">
                                    <div id="RECEPTLIST" style="Width: 550px; Height: 500px; overflow: auto; border: 0; font-size: 9pt; margin: 0px 1px 1px 1px; padding-top: 0px;">
                                    </div>
                                </div>
                            </td>
                        </tr>

                        <tr style="display: none;" id="trSummaryOuterReceiverList">
                            <td style="width: 120px;">
                                <h2 class="h2_dot"><%= RM.GetString("t20000") %>:</h2>
                            </td>
                            <td>
                                <input id="inputSummaryOuterReceiverList" style="width: 97%; margin-top: 5px;" value="" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left">
                                <a style="margin-top: 5px;" class="imgbtn" id="btnaddress"><span onclick="return btnAddAddress()"><%=RM.GetString("t334")%></span></a>
                            </td>
                            <td style="text-align: right">
                                <a style="margin-top: 5px; display: none;" class="imgbtn" id="btnaddressChange"><span onclick="return btnaddressChange()"><%=RM.GetString("t348")%></span></a>
                                <a class="imgbtn" style="padding-right: 5px; margin-top: 5px;"><span id="Span5" onclick="return btn_AprDeptTempletSave_onclick('NEW')"><%=RM.GetString("G0009")%></span></a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>

    <div id="Cabinetinfo" style="border: 2px solid #dbdbda; width: 976px; height: 597px; display: none;">
        <table>
            <tr>
                <td colspan="2">
                    <h2 class="h2_dot" style="margin-left: 10px"><%=RM.GetString("t1039")%></h2>
                    <table class="content" style="width: 100%; margin-left: 2px;">
                        <tr>
                            <th style="width: 50px"><%=RM.GetString("t592")%></th>
                            <td style="width: 105px">
                                <select id="selTaskCategory" onchange="return selTaskCategory_onchange()" style="width: 100px">
                                </select>
                            </td>
                            <th style="width: 50px"><%=RM.GetString("t593")%></th>
                            <td style="width: auto;">
                                <select id="selTaskMCategory" onchange="return selTaskMCategory_onchange()" style="width: 100px; margin-top: 3px">
                                </select>
                                &nbsp;
                                        <span id="trCreateCab">
                                            <% if (_InitFlag == "1")
                                               {%>
                                            <a class="imgbtn" style="margin-top: 2px"><span onclick="return btnCreateCab_onclick()"><%=RM.GetString("t1118")%></span></a>
                                            <a class="imgbtn" style="margin-top: 2px"><span onclick="return btnNewVolume_onclick()"><%=RM.GetString("t894")%></span></a>
                                            <% }%>
                                        </span>
                                <span id="trCreateCabDummy" style="display: none"></span>
                                <span style="vertical-align: middle; position: absolute; right: 20px">
                                    <select id="selSearchOption" style="vertical-align: middle;">
                                        <option>
                                            <%=RM.GetString("t10026")%>
                                        </option>
                                        <option>
                                            <%=RM.GetString("t577")%>
                                        </option>
                                    </select>
                                    <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)">
                                    <a class="imgbtn" style="margin-top: 2px"><span name="btnSearch" onclick="return CabinetSearch_onclick()"><%=RM.GetString("t111")%></span></a>
                                    <a class="imgbtn" style="margin-top: 2px"><span name="btnSearch" onclick="return Cabinetinfo_ini()"><%=RM.GetString("t165")%></span></a>
                                </span>
                            </td>
                        </tr>
                    </table>
                    <div class="border_gray" style="margin-top: 5px; margin-left: 3px">
                        <div id="TaskSCateList" style="border: 0; HEIGHT: 295px; WIDTH: 968px; overflow-x: hidden; overflow-y: auto; margin: 0px 1px 1px 1px;"></div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <h2 class="h2_dot" style="margin-left: 10px"><%=RM.GetString("t00001")%></h2>
                </td>
                <td style="padding-top: 5px; padding-right: 20px">
                    <div align="right">
                        <a class="imgbtn"><span onclick="return Set_MyTask('INS')"><%=RM.GetString("t00002")%></span></a>
                        <a class="imgbtn"><span onclick="return Set_MyTask('DEL')"><%=RM.GetString("t00003")%></span></a>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="border_gray" style="margin-top: 5px; margin-left: 3px">
                        <div id="MyTaskSCateList" style="border: 0; HEIGHT: 180px; WIDTH: 968px; overflow-x: hidden; overflow-y: auto; margin: 0px 1px 1px 1px;"></div>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div id="Docinfo" style="border: 2px solid #dbdbda; width: 976px; height: 597px; display: none;">

        <h2 class="h2_dot" style="margin-left: 5px;"><%=RM.GetString("t1204")%></h2>
        <table class="content">
            <tr>
                <th><%=RM.GetString("t875")%></th>
                <td>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special1" id="special1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <%=RM.GetString("t1205")%></span>
                        <input type="checkbox" name="special2" id="special2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <%=RM.GetString("t984")%></span>
                        <input type="checkbox" name="special3" id="special3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <%=RM.GetString("t1206")%></span>
                        </div>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="special4" id="special4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <%=RM.GetString("t986")%></span>
                        <input type="checkbox" name="special5" id="special5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span> <%=RM.GetString("t1207")%></span>
                    </div>

                </td>
            </tr>
            <tr>
                <th><%=RM.GetString("t118")%></th>
                <td>
                    <select id="selSecLevel" name="select" style="WIDTH: 85px">
                        <%=_securitynode3%>
                    </select>
                </td>
            </tr>
            <tr>
                <th><%=RM.GetString("t109")%></th>
                <td>
                    <div style="padding-left: 3px; padding-top: 5px; padding-bottom: 5px;">
                        <%=RM.GetString("t10029")%><br />
                    </div>
                    <div style="padding-left: 3px; padding-bottom: 5px;">
                        <input type="radio" name="rdoSecType" value="1" checked onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><%=RM.GetString("t47")%></span>&nbsp;
                        <input type="radio" name="rdoSecType" value="2" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><%=RM.GetString("t150")%></span>&nbsp;
                        <input type="radio" name="rdoSecType" value="3" onclick="return rdoSecType_onclick(this.value)" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"><span><%=RM.GetString("t46")%></span>
                      <%--  <span id="etcSecType">( 
                            <input type="checkbox" name="selEtc" id="selCompany" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" disabled="disabled" onclick="selOnclick(this)"><span> 전사 공개&nbsp;</span>
                            <input type="checkbox" name="selEtc" id="selEtc" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" disabled="disabled" onclick="selOnclick(this)"><span> <%=RM.GetString("t108")%> <%=RM.GetString("t47")%></span>
                            )
                        </span>--%>
                        <select id="etcSecType" disabled="disabled">
                            <option value="A">3단계:기술원 열람</option>
                            <option value="Y">2단계:부서 열람</option>
                            <option value="N">1단계:결재선 열람</option>
                        </select>
                        <input type="checkbox" name="ListOpenCheck" id="ListOpenCheck" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;"  onclick="ListOpenCheck_Onclick(this)"><span><%=RM.GetString("KFI00008")%></span> <!-- 목록공개 -->
                    </div>
                </td>

            </tr>
             <tr style="display:none">
                <th><%=RM.GetString("t5004")%></th> <!-- 열람제한일자 -->
                <td>
                        <input type="checkbox" name="LimitDateCheck" id="LimitDateCheck" value="checkbox" onclick="LimitDateCheck_onClick()">
                        <input readonly="true" type="text" class="datepicker" id="idDatepickerLimit" />
                        <img id="img_Post_D1_Limit" src="/images/i_scheduler.gif" width="19" height="15"
                            style="CURSOR: pointer; POSITION: relative; vertical-align: middle;" popuplocation='topleft'>
                        <input id='Post_D2_Limit'
                            class='datepicker_date'
                            readonly="true"
                            type="text"
                            style="width: 95px; display: none" name="Post_D2_Limit">
                        <img src="/images/i_scheduler.gif" id="img_Post_D2_Limit" border="0" width="19" height="15" popuplocation='topleft' style="display: none; CURSOR: pointer; POSITION: relative">
                </td>

            </tr>
            <tr>
                 <th>공개전환일자</th> <!-- 공개전환일자 -->
                <td>
                        <input type="checkbox" name="LimitDateCheck" id="LimitDateCheck_open" value="checkbox" onclick="LimitDateCheck_open_onClick()" disabled="disabled">
                        <input readonly="true" type="text" class="datepicker" id="idDatepickerLimit_open"  disabled="disabled"/>
                        <img id="img_Post_D1_Limit_open" src="/images/i_scheduler.gif" width="19" height="15"
                            style="CURSOR: pointer; POSITION: relative; vertical-align: middle;display:none" popuplocation='topleft'>
                        <input id='Post_D2_Limit_open'
                            class='datepicker_date'
                            readonly="true"
                            type="text"
                            style="width: 95px; display: none" name="Post_D2_Limit">
                        <img src="/images/i_scheduler.gif" id="img_Post_D2_Limit_open" border="0" width="19" height="15" popuplocation='topleft' style="display: none; CURSOR: pointer; POSITION: relative">
                </td>
            </tr>
            <tr>
                <th><%=RM.GetString("t10021")%></th> <!-- 첨부정보 -->
                <td>
                    <div id="ATTACH" STYLE="overflow:auto;WIDTH:100%;HEIGHT:115px;">
                    </div>
                </td>

            </tr>
            <tr>
                <th><%=RM.GetString("KFI00006")%><br />/ <%=RM.GetString("KFI00007")%></th>
                <td>
                    <div style="padding-top: 5px; padding-left: 3px;">
                        <input type="checkbox" name="selSecLevel1" id="selSecLevel1" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 1<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel2" id="selSecLevel2" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 2<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel3" id="selSecLevel3" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 3<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel4" id="selSecLevel4" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 4<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel5" id="selSecLevel5" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 5<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel6" id="selSecLevel6" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 6<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel7" id="selSecLevel7" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 7<%=RM.GetString("tkfi0003")%></span>
                        <input type="checkbox" name="selSecLevel8" id="selSecLevel8" value="checkbox" style="height: 13px; width: 13px; padding: 0px; margin: 0px; vertical-align: top;" onclick="SendDocHo(this)"><span> 8<%=RM.GetString("tkfi0003")%></span>
                    </div>
                    <br />
                    <textarea id="txt_Reason" name="txt_Reason" style="HEIGHT: 40px; WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
                </td>
            </tr>
            <tr>
                <th><%=RM.GetString("t876")%></th>
                <td>
                    <input type="text" name="txtLimitRange" id="txtLimitRange" class="text" style="Width: 170px; font-size: 9pt"><span>(<%=RM.GetString("t1209")%></span></td>
                <tr>
                    <th><%=RM.GetString("t979")%></th>
                    <td>
                        <input type="text" name="txtPageNum" id="txtPageNum" class="text" style="Width: 170px; font-size: 9pt"></td>
                </tr>
            <tr>
                <th><%=RM.GetString("t1199")%></th>
                <td>
                    <input type="checkbox" name="AprUrgency" id="AprUrgency" value="checkbox"><%=RM.GetString("t10090")%>
                </td>
            </tr>
            <tr>
                <th><%=RM.GetString("t1210")%></th>
                <td>
                    <input type="checkbox" name="AprSecurity" id="AprSecurity" value="checkbox" onclick="AprSecurity_onClick()">
                    <input readonly="true" type="text" class="datepicker" id="idDatepicker" />
                    <img id="img_Post_D1" src="/images/i_scheduler.gif" width="19" height="15"
                        style="CURSOR: pointer; POSITION: relative; vertical-align: middle;" popuplocation='topleft'>
                    <input id='Post_D2'
                        class='datepicker_date'
                        readonly="true"
                        type="text"
                        style="width: 95px; display: none" name="Post_D2">
                    <img src="/images/i_scheduler.gif" id="img_Post_D2" border="0" width="19" height="15" popuplocation='topleft' style="display: none; CURSOR: pointer; POSITION: relative">
                </td>
            </tr>
            <tr>
                    <th><%=RM.GetString("t1200")%></th>
                    <td>
                        <input id="keyword" type="text" name="keyword" maxlength="50" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" /></td>
                </tr>
        </table>
        <h2 style="margin-left: 5px;"><%=RM.GetString("t1203")%></h2>
        <textarea id="taSummery" name="taSummery" style="HEIGHT: 50px; WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box;"></textarea>
    </div>
<%--    <div id="Openinfo" style="height:600px; display:none;">
         <iframe id="OpenFrame" src="about:blank"   name="OpenFrame" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
    </div>--%>
    <br />
    <div style="text-align: center;" id="orgbtnArea">
        <table style="width: 976px">
            <tr>
                <td style="text-align: center;">
                    <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_OK()"><%=RM.GetString("t1760")%></span></a>
                    <a class="imgbtn"><span style="width: 60px; text-align: center;" onclick="btn_Close()"><%=RM.GetString("t1761")%></span></a>
                </td>
            </tr>
        </table>
    </div>
    <xml id="userlist_h" style="display: none">
    <LISTVIEWDATA>
    <HEADERS>
        <HEADER>
        <NAME><%=RM.GetString("G0028")%></NAME>
        <WIDTH>70</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("G0029")%></NAME>
        <WIDTH>100</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("G0030")%></NAME>
        <WIDTH>60</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("t231")%></NAME>
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
        <NAME><%=RM.GetString("t10026")%></NAME>
        <WIDTH>17%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("t693")%> (<%=RM.GetString("t10091")%>)</NAME>
        <WIDTH>24%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("t577")%> (<%=RM.GetString("t10091")%>)</NAME>
        <WIDTH>24%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("t1065")%></NAME>
        <WIDTH>15%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("t10027")%></NAME>
        <WIDTH>10%</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><%=RM.GetString("t10092")%></NAME>
        <WIDTH>10%</WIDTH>
        </HEADER>
    </HEADERS>
    <ROWS></ROWS>
    </LISTVIEWDATA>
</xml>

<xml id="OpenListHeader" style="display:none">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><%=RM.GetString("t109")%></NAME>
                <WIDTH>80</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><%=RM.GetString("t439")%></NAME>
                <WIDTH>30</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><%=RM.GetString("t5006")%></NAME>
                <WIDTH>300</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><%=RM.GetString("t5007")%></NAME>
                <WIDTH>100</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><%=RM.GetString("t47")%>/<%=RM.GetString("t46")%></NAME>
                <WIDTH></WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</xml>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
        <iframe src="/myoffice/blank.htm" style="border: none;" id="iFrameLayer"></iframe>
    </div>
</body>
<script type="text/javascript">
    Tab1_NewTabIni("tab1");
    Tab2_NewTabIni("tab2");
    Tab3_NewTabIni("tab3");
</script>
</html>
