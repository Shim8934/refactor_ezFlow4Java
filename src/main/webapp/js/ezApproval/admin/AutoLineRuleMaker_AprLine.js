
var pDocID;
var pFormID;
var pSignCount;
var pHapYuiCount;
var pGamSaCount;

var pReDraftFlag;               
var pReDraftAprLineChangeFlag = false; 
var pSuSinFlag;                
var pChamJoFlag;               
var pGongramCount;
var pReDraftAprLineFlag;       

var pSelAprLineType;           
var pAprLineAddIndex;          
var pTotalIndex;               
var pAprLineXml = new Array(); 
var pAprLineTempletFlag = false; 
var p_CheckAprLineTempletSN;       
var pAprLineTempletUIFlag = false;

var hotTrackingValue = false;
var enableValue = true;
var InitTreeVal = "";
var pOrgApruserid;
var CompID;
var pUserID;
var chkReDraft = "";
var USE_APRLINEVIEWER = "";



function Tree_setconfig() {
    var xmlHTTP = createXMLHttpRequest();
    xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
    xmlHTTP.send();

    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
        var treeView = new TreeView();
        treeView.SetConfig(loadXMLString(xmlHTTP.responseText));
    }
}

function displayUserList(DeptID) {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "CELL", "displayname;Description;Title");
    createNodeAndInsertText(xmlpara, objNode, "PROP", "DEPARTMENT;DISPLAYNAME;DESCRIPTION;TITLE;PHYSICALDELIVERYOFFICENAME");
    createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");

    g_xmlHTTP = createXMLHttpRequest();
    g_xmlHTTP.open("POST", "/ezOrgan/getDeptMemberList.do", true);
    g_xmlHTTP.onreadystatechange = event_displayUserList;
    g_xmlHTTP.send(xmlpara);
}

function LineAprTyepSet() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var pSelectedRow = pAPRLINE.GetSelectedRows();
    
    var p_isDept = GetAttribute(pSelectedRow[0], "DATA7");
    var AprTyepID = "";
    if (p_isDept == "Y") {
        
        var AprTypeObj = ChangeAprlineType("group", GetAttribute(pSelectedRow[0], "DATA4"));
        AprTyepID = GetAttribute(pSelectedRow[0], "id") + "select";
        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchange(this)\" >" + AprTypeObj + "</select>";
        pSelectedRow[0].childNodes[4].innerHTML = AprTypeObj;
    } else {
        
        var AprTypeObj = ChangeAprlineType("user", GetAttribute(pSelectedRow[0], "DATA4"));
        AprTyepID = GetAttribute(pSelectedRow[0], "id") + "select";
        AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchange(this)\" >" + AprTypeObj + "</select>";
        pSelectedRow[0].childNodes[4].innerHTML = AprTypeObj;
    }
}

function TreeViewNodeDbClick() {
    return;
}

function textUser_onkeypress() {
    if (window.event.keyCode == "13") {
        document.getElementById("btn_searchUser").click();
    }
}


function btn_searchUser_onclick() {
    searchUserList();
}


function TreeCtrl_onReqData() {
    var xmlRtn = createXmlDom();
    displayMemberTreeReq();
}


function list2_onSel_Click() {
}


function list2_onSel_DBclick() {
    var pUserList = new ListView();
    pUserList.LoadFromID("lvUserList");

    var selnode = pUserList.GetSelectedRows();
    var RtnVal = CheckSignCellValue();
    InsertMode = "Add";
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");

    if (RtnVal) {
        APRLINEATTENDADDFunction(selnode, "PERSON");
        initJunGyul();
    }
}

function TreeViewNodeClick() {
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");
    var selnode = treeView.GetSelectNode();
    DeptID = selnode.GetNodeData("CN");
    displayUserList(DeptID);
}

var g_progresswin = null;	
function showProgress() {
    g_progresswin = modelessWindow("/myoffice/ezApproval/show_progress_Cross.aspx?fileinfo=" + escape(strLang313), "", 390, 185, g_progresswin);
}
function hideProgress() {
    try {
        if (g_progresswin)
            g_progresswin.close();
    } catch (e) { }
}
// 중복된 소스
//function OpenInformationUI(pInformationContent) {
//    var parameter = pInformationContent;
//    var url = "/admin/ezApproval/ezAprOpinion.do";
//    var feature = "status:no;dialogWidth:330px;dialogHeight:230px;help:no;scroll:no;edge:sunken";
//    feature = feature + GetShowModalPosition(330, 205);
//    var RtnVal = window.showModalDialog(url, parameter, feature);
//    return RtnVal;
//}
//
//function OpenAlertUI(pAlertContent) {
//    var parameter = pAlertContent;
//    var url = "/admin/ezApproval/ezAprAlert.do";
//    var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
//    feature = feature + GetShowModalPosition(330, 205);
//    var RtnVal = window.showModalDialog(url, parameter, feature);
//}

function OnSelChange_onclick() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var pSelectedRow = pAPRLINE.GetSelectedRows();
    

    if (pSelectedRow.length > 0) {
        if (GetAttribute(pSelectedRow[0], "DATA19") == "Y")
            FixYN.checked = true;
        else
            FixYN.checked = false;
        
    }
}


function FixFlag_onclick() {
    var SCheckVal = document.getElementById("FixYN").checked;

    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var CurSelRow = pAPRLINE.GetSelectedRows();

    if (CurSelRow.length == 0) {
        OpenAlertUI(strLang574);
        document.getElementById("FixYN").checked = false;
        return;
    }

    if (CurSelRow.length > 0) {
        FixYNCheck(SCheckVal, CurSelRow);
    }
}


function FixYNCheck(SCheckVal, CurSelRow) {
    if (SCheckVal) {
        CurSelRow[0].setAttribute("DATA19", "Y");
        CurSelRow[0].cells[0].innerHTML = "★" + CurSelRow[0].cells[0].innerHTML;
    } else {
        CurSelRow[0].setAttribute("DATA19", "N");
        CurSelRow[0].cells[0].innerHTML = CurSelRow[0].cells[0].innerHTML.replace("★", "");
    }
}



function AprTypeToName(tempCode) {
    var retVal = "";

    switch (tempCode) {
        case "A03001":
            retVal = strLangAprType1;
            break;

        case "A03002":
            retVal = strLangAprType2;
            break;

        case "A03003":
            retVal = strLangAprType3;
            break;

        case "A03004":
            retVal = strLangAprType4;
            break;

        case "A03005":
            retVal = strLangAprType5;
            break;

        case "A03006":
            retVal = strLangAprType6;
            break;

        case "A03007":
            retVal = strLangAprType7;
            break;

        case "A03008":
            retVal = strLangAprType8;
            break;

        case "A03009":
            retVal = strLangAprType9;
            break;

        case "A03011":
            retVal = strLangAprType11;
            break;

        case "A03012":
            retVal = strLangAprType12;
            break;

        case "A03013":
            retVal = strLangAprType13;
            break;

        case "A03014":
            retVal = strLangAprType14;
            break;

        case "A03015":
            retVal = strLangAprType15;
            break;

        case "A03016":
            retVal = strLangAprType16;
            break;

        case "A03017":
            retVal = strLangAprType17;
            break;

        case "A03031":
            retVal = strLangAprType31;
            break;

        case "A03032":
            retVal = strLangAprType32;
            break;

        case "A03040":
            retVal = strLangAprType40;
            break;

        default:
            retVal = "";
            break;
    }
    return retVal;
}

function MakeAprLineListXML( pAutoRuleGuid) {
    
    var AprRuleLineXML = loadXMLString(bodyForm.hidAprRuleLine.value);

    
    if (thisSelGUID != "") {
        for (var i = GetElementsByTagName(AprRuleLineXML, "ROW").length - 1; i > -1 ; i--) {
            if (getNodeText(GetElementsByTagName(AprRuleLineXML, "AUTORULEGUID")[i]) == thisSelGUID) {
                AprRuleLineXML.documentElement.removeChild(GetElementsByTagName(AprRuleLineXML, "ROW")[i]);
            }
        }
    }

    var pAPRRULELINE = new ListView();
    pAPRRULELINE.LoadFromID("lvAPRAUTORULELINE");

    if (pAPRRULELINE.GetID() != "") {
        var AprRuleLineRow = pAPRRULELINE.GetDataRows();
        var CurListLen = AprRuleLineRow.length;
        var i;
        var GetXml;
        
        

        if (CurListLen > 0) {
            if (AprRuleLineRow[0].id != (pAPRRULELINE.GetID() + "_TR_noItems")) {
                for (i = 0; i < CurListLen; i++) {
                    newNode = createNode(AprRuleLineXML, "ROW");
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "FORMID", GetAttribute(AprRuleLineRow[i], "DATA1"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "DOCTYPE", GetAttribute(AprRuleLineRow[i],"DATA2"));
                    
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERSN", getNodeText(AprRuleLineRow[i].cells[0]).replace("★", "").replace("⊙", ""));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRTYPE", GetAttribute(AprRuleLineRow[i],"DATA4"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRSTATE", GetAttribute(AprRuleLineRow[i],"DATA5"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERID", GetAttribute(AprRuleLineRow[i],"DATA6"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERISDEPTYN", GetAttribute(AprRuleLineRow[i],"DATA7"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERNAME", GetAttribute(AprRuleLineRow[i],"DATA8"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERNAME2", GetAttribute(AprRuleLineRow[i],"DATA9"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERJOBTITLE", GetAttribute(AprRuleLineRow[i],"DATA10"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERJOBTITLE2",GetAttribute( AprRuleLineRow[i],"DATA11"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERDEPTID",GetAttribute( AprRuleLineRow[i],"DATA12"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERDEPTNAME", GetAttribute(AprRuleLineRow[i],"DATA13"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERDEPTNAME2",GetAttribute( AprRuleLineRow[i],"DATA14"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERLDAPPATH", GetAttribute(AprRuleLineRow[i],"DATA15"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "RECEIVEDDATE", GetAttribute(AprRuleLineRow[i],"DATA16"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "PROCESSDATE",GetAttribute( AprRuleLineRow[i],"DATA17"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "REASONDONOTAPPROV", GetAttribute(AprRuleLineRow[i],"DATA18"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "ISPROPOSERYN", GetAttribute(AprRuleLineRow[i],"DATA19"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "ISBRIEFUSERYN", GetAttribute(AprRuleLineRow[i],"DATA20"));
                    createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "AUTORULEGUID",GetAttribute( AprRuleLineRow[i],"DATA21"));

                    x = AprRuleLineXML.getElementsByTagName("DATA")[0];
                    x.appendChild(newNode);
                }
            }
        }

        bodyForm.hidAprRuleLine.value = getXmlString(AprRuleLineXML);
    }

    
    var pListXml = "<LISTVIEWDATA>";
    pListXml = pListXml + "<HEADERS>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang230 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang107 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang49 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang108 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang38 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang109 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang231 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "</HEADERS>";
    pListXml = pListXml + "<ROWS>";

    AprLineXML = loadXMLString(bodyForm.hidAprRuleLine.value);
    var pIsRow = false;
    for (var i = 0; i < GetElementsByTagName(AprLineXML, "ROW").length; i++) {
        if (getNodeText(GetElementsByTagName(AprLineXML, "AUTORULEGUID")[i]) == pAutoRuleGuid) {
            pListXml = pListXml + "<ROW>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + "<VALUE>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERSN")[i]) + "</VALUE>";
            pListXml = pListXml + "<DATA1>" + getNodeText(GetElementsByTagName(AprLineXML, "FORMID")[i]) + "</DATA1>";
            pListXml = pListXml + "<DATA2></DATA2>";
            
            pListXml = pListXml + "<DATA3>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERSN")[i]) + "</DATA3>";
            pListXml = pListXml + "<DATA4>" + getNodeText(GetElementsByTagName(AprLineXML, "APRTYPE")[i]) + "</DATA4>";
            pListXml = pListXml + "<DATA5>" + getNodeText(GetElementsByTagName(AprLineXML, "APRSTATE")[i]) + "</DATA5>";
            pListXml = pListXml + "<DATA6>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERID")[i]) + "</DATA6>";
            pListXml = pListXml + "<DATA7>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERISDEPTYN")[i]) + "</DATA7>";
            pListXml = pListXml + "<DATA8>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERNAME")[i]) + "</DATA8>";
            pListXml = pListXml + "<DATA9>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERNAME2")[i]) + "</DATA9>";
            pListXml = pListXml + "<DATA10>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERJOBTITLE")[i]) + "</DATA10>";
            pListXml = pListXml + "<DATA11>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERJOBTITLE2")[i]) + "</DATA11>";   
            pListXml = pListXml + "<DATA12>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERDEPTID")[i]) + "</DATA12>";  
            pListXml = pListXml + "<DATA13>" + ReplaceText(getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERDEPTNAME")[i]), "&", "&amp;") + "</DATA13>";
            pListXml = pListXml + "<DATA14>" + ReplaceText(getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERDEPTNAME2")[i]), "&", "&amp;") + "</DATA14>";
            pListXml = pListXml + "<DATA15>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERLDAPPATH")[i]) + "</DATA15>";
            pListXml = pListXml + "<DATA16>" + getNodeText(GetElementsByTagName(AprLineXML, "RECEIVEDDATE")[i]) + "</DATA16>";
            pListXml = pListXml + "<DATA17>" + getNodeText(GetElementsByTagName(AprLineXML, "PROCESSDATE")[i]) + "</DATA17>";
            pListXml = pListXml + "<DATA18>" + getNodeText(GetElementsByTagName(AprLineXML, "REASONDONOTAPPROV")[i]) + "</DATA18>";
            pListXml = pListXml + "<DATA19>" + getNodeText(GetElementsByTagName(AprLineXML, "ISPROPOSERYN")[i]) + "</DATA19>";
            pListXml = pListXml + "<DATA20>" + getNodeText(GetElementsByTagName(AprLineXML, "ISBRIEFUSERYN")[i]) + "</DATA20>";
            pListXml = pListXml + "<DATA21>" + getNodeText(GetElementsByTagName(AprLineXML, "AUTORULEGUID")[i]) + "</DATA21>";

            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";

            switch (getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERID")[i])) {
                case "#boss":
                    pListXml = pListXml + "<VALUE>" + strLang1115 + "</VALUE>";
                    break;
                case "#upboss":
                    pListXml = pListXml + "<VALUE>" + strLang1116 + "</VALUE>";
                    break;
                case "#upupboss":
                    pListXml = pListXml + "<VALUE>" + strLang1117 + "</VALUE>";
                    break;
                case "#upupupboss":
                    pListXml = pListXml + "<VALUE>" + strLang1118 + "</VALUE>";
                    break;
                case "#upupupupboss":
                    pListXml = pListXml + "<VALUE>" + strLang1119 + "</VALUE>";
                    break;
                case "#drafter":
                    pListXml = pListXml + "<VALUE>" + strLang514 + "</VALUE>";
                    break;
                case "#selboss":
                    pListXml = pListXml + "<VALUE>" + strLang1120 + "</VALUE>";
                    break;
                default:
                    pListXml = pListXml + "<VALUE>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERNAME")[i]) + "</VALUE>";
                    break;
            }

            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + "<VALUE>" + getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERJOBTITLE")[i]) + "</VALUE>";
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";

            switch (getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERID")[i])) {
                case "#boss":
                case "#upboss":
                case "#upupboss":
                case "#upupupboss":
                case "#upupupboss":
                case "#drafter":
                    pListXml = pListXml + "<VALUE></VALUE>";
                    break;
                case "#selboss":
                default:
                    pListXml = pListXml + "<VALUE>" + ReplaceText(getNodeText(GetElementsByTagName(AprLineXML, "APRMEMBERDEPTNAME")[i]), "&", "&amp;") + "</VALUE>";
                    break;
            }

            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + "<VALUE>" + "" + "</VALUE>";
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + "<VALUE>" + strLangAprState1 + "</VALUE>";
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL><VALUE></VALUE></CELL>"
            pListXml = pListXml + "</ROW>";
            pIsRow = true;
        }
    }

    pListXml = pListXml + "</ROWS>";
    pListXml = pListXml + "</LISTVIEWDATA>";

    thisSelGUID = pAutoRuleGuid;

    if (document.getElementById("APRLINE").innerHTML != "")
        document.getElementById("APRLINE").innerHTML = "";

    AprListViewXML = loadXMLString(pListXml);

    var pAPRLINE = new ListView();
    pAPRLINE.SetID("lvAPRAUTORULELINE");
    pAPRLINE.SetMulSelectable(false);
    pAPRLINE.SetHeightFree(true);
    pAPRLINE.SetRowOnClick("OnSelChange_onclick");
    pAPRLINE.SetRowOnDblClick("AprAutoRuleLineDel_onclick");
    pAPRLINE.SetSelectFlag(false);
    pAPRLINE.DataSource(AprListViewXML);
    pAPRLINE.DataBind("APRLINE");

    if (pAPRLINE.GetDataRows().length > 0) {
        LineAprTyepSetAll();
    }

    initJunGyul();
}

function LineAprTyepSetAll() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var pTotalRows = pAPRLINE.GetDataRows();

    if (pTotalRows[0].id != (pAPRLINE.GetID() + "_TR_noItems")) {
        for (var i = 0; i < pTotalRows.length; i++) {
            var Mark = ""
            if (GetAttribute(pTotalRows[i], "DATA19").toUpperCase() == "Y")
                Mark = "★";

            if (GetAttribute(pTotalRows[i], "DATA20").toUpperCase() == "Y")
                Mark = Mark + "⊙";

            pTotalRows[i].cells[0].innerHTML = Mark + pTotalRows[i].cells[0].innerHTML;

            var p_isDept = GetAttribute(pTotalRows[i], "DATA7");
            if (p_isDept == "Y") {
                var AprTypeObj = ChangeAprlineType("group", GetAttribute(pTotalRows[i], "DATA4"));
                AprTyepID = GetAttribute(pTotalRows[i], "id") + "select";
                AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchange(this)\">" + AprTypeObj + "</select>";
                pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
            } else {
                var AprTypeObj = ChangeAprlineType("user", GetAttribute(pTotalRows[i], "DATA4"));
                AprTyepID = GetAttribute(pTotalRows[i], "id") + "select";
                AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchange(this)\">" + AprTypeObj + "</select>";
                pTotalRows[i].childNodes[4].innerHTML = AprTypeObj;
            }
        }
    }
}

function isgetUser(DeptID) {
    var rtnVal = true;
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "DEPTID", DeptID);
    createNodeAndInsertText(xmlpara, objNode, "CELL", "displayname");
    createNodeAndInsertText(xmlpara, objNode, "PROP", "");
    createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");

    xmlhttp.open("POST", "/ezOrgan/getDeptMemberList.do", false);
    xmlhttp.send(xmlpara);

    var XmlNode = loadXMLString(xmlhttp.responseText);

    if (XmlNode.xml == "") rtnVal = false;
    var nodes = SelectNodes(XmlNode, "LISTVIEWDATA/ROWS/ROW");

    if (rtnVal) {
        nodeCnt = nodes.length;

        if (nodeCnt > 0) {
            rtnVal = true;
        }
        else
            rtnVal = false;
    }
    return rtnVal;
}

function GetProcessAprType(AprLineAddIndex, AprLineRow, pClass) {
    var retVal = "";
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var tr = pAPRLINE.GetSelectedRows();
    if (InsertMode == "Edit" && tr.length > 0) {
        
        retVal = GetAttribute(tr[0], "DATA4");
    }

    if (retVal == "A03011" || retVal == "A03012") {
        if (pClass != "DEPT") {
            retVal = "";
        }
    }
    else {
        if (pClass == "DEPT") {
            retVal = "";
        }
    }

    return retVal;
}

function AprlineNullAdd_onclick(Mode) {
    switch (Mode) {
        case "all":
            AddRow_AprLine(strAprType1, strAprState1, "#drafter", "N", strResx436, strResx436, "", "", "", "", "", companyID);
            AddRow_AprLine(strAprType1, strAprState1, "#boss", "N", strLang1115, strLang1115, "", "", "", "", "", companyID);
            AddRow_AprLine(strAprType1, strAprState1, "#upboss", "N", strLang1116, strLang1116, "", "", "", "", "", companyID);
            AddRow_AprLine(strAprType1, strAprState1, "#upupboss", "N", strLang1117, strLang1117, "", "", "", "", "", companyID);
            AddRow_AprLine(strAprType1, strAprState1, "#upupupboss", "N", strLang1118, strLang1118, "", "", "", "", "", companyID);
            AddRow_AprLine(strAprType1, strAprState1, "#upupupupboss", "N", strLang1119, strLang1119, "", "", "", "", "", companyID);
            break;
        case "temp":
            AddRow_AprLine(strAprType1, strAprState1, "#drafter", "N", strResx436, strResx436, "", "", "", "", "", companyID);
            AddRow_AprLine(strAprType1, strAprState1, "#boss", "N", strLang1115, strLang1115, "", "", "", "", "", companyID);
            break;
        case "user":
            AddRow_AprLine(strAprType1, strAprState1, "", "N", "", "", "", "", "", "", "", companyID);
            break;
        case "draft":
            AddRow_AprLine(strAprType1, strAprState1, "#drafter", "N", strResx436, strResx436, "", "", "", "", "", companyID);
            break;
        case "dept":
            var treeView = new TreeView();
            treeView.LoadFromID("LineUserTree");

            var pTreeSelNode = treeView.GetSelectNode();
            APRLINEATTENDADDFunction(pTreeSelNode, "DEPT");
            break;
    }
}

function MakeHeader() {
    pparsingXML = "<HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang230 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang107 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang49 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang108 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang38 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang109 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + strLang231 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS>";

    return pparsingXML;
}

function GetRowIndex() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");

    var AprLineRow = pAPRLINE.GetDataRows();
    AprLineAddIndex = AprLineRow.length;
    if (AprLineAddIndex == 1) {
        var tr = pAPRLINE.GetDataRows();
        if (tr[0].id.indexOf("noItems") > 0)
            AprLineAddIndex = 0;
    }
    AprLineAddIndex = AprLineAddIndex + 1;

    return AprLineAddIndex;
}

function AddRow_AprLine(pAPRTYPE, pAPRSTATE, pAPRMEMBERID, pAPRMEMBERISDEPTYN, pAPRMEMBERNAME, pAPRMEMBERNAME2, pAPRMEMBERJOBTITLE,
    pAPRMEMBERJOBTITLE2, pAPRMEMBERDEPTID, pAPRMEMBERDEPTNAME, pAPRMEMBERDEPTNAME2, pAPRMEMBERLDAPPATH) {
    var AprLineAddIndex = GetRowIndex();
    

    var nAprType = "";

    ListXML = "<LISTVIEWDATA>";
    ListXML = ListXML + MakeHeader();
    ListXML = ListXML + "<ROWS>";
    ListXML = ListXML + "<ROW>";
    ListXML = ListXML + "<CELL>";
    ListXML = ListXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
    ListXML = ListXML + "<DATA1>" + pFormID + "</DATA1>";
    ListXML = ListXML + "<DATA2></DATA2>";
    ListXML = ListXML + "<DATA3>" + AprLineAddIndex + "</DATA3>";
    ListXML = ListXML + "<DATA4>" + pAPRTYPE + "</DATA4>";
    ListXML = ListXML + "<DATA5>" + pAPRSTATE + "</DATA5>";
    ListXML = ListXML + "<DATA6>" + pAPRMEMBERID + "</DATA6>";
    ListXML = ListXML + "<DATA7>" + pAPRMEMBERISDEPTYN + "</DATA7>";
    ListXML = ListXML + "<DATA8>" + pAPRMEMBERNAME + "</DATA8>";
    ListXML = ListXML + "<DATA9>" + pAPRMEMBERNAME2 + "</DATA9>";
    ListXML = ListXML + "<DATA10>" + pAPRMEMBERJOBTITLE + "</DATA10>";
    ListXML = ListXML + "<DATA11>" + pAPRMEMBERJOBTITLE2 + "</DATA11>";
    ListXML = ListXML + "<DATA12>" + pAPRMEMBERDEPTID + "</DATA12>";
    ListXML = ListXML + "<DATA13>" + pAPRMEMBERDEPTNAME + "</DATA13>";
    ListXML = ListXML + "<DATA14>" + pAPRMEMBERDEPTNAME2 + "</DATA14>";
    ListXML = ListXML + "<DATA15>" + pAPRMEMBERLDAPPATH + "</DATA15>";  
    ListXML = ListXML + "<DATA16>" + "" + "</DATA16>";
    ListXML = ListXML + "<DATA17>" + "" + "</DATA17>";
    ListXML = ListXML + "<DATA18>" + "" + "</DATA18>";
    ListXML = ListXML + "<DATA19>" + "" + "</DATA19>";
    ListXML = ListXML + "<DATA20>" + "" + "</DATA20>";
    ListXML = ListXML + "<DATA21>" + thisSelGUID + "</DATA21>";
    ListXML = ListXML + "</CELL>";
    ListXML = ListXML + "<CELL>";
    ListXML = ListXML + "<VALUE>" + pAPRMEMBERNAME + "</VALUE>";
    ListXML = ListXML + "</CELL>";
    ListXML = ListXML + "<CELL>";
    ListXML = ListXML + "<VALUE>" + pAPRMEMBERJOBTITLE + "</VALUE>";
    ListXML = ListXML + "</CELL>";
    ListXML = ListXML + "<CELL>";
    ListXML = ListXML + "<VALUE>" + pAPRMEMBERDEPTNAME + "</VALUE>";
    ListXML = ListXML + "</CELL>";
    ListXML = ListXML + "<CELL>";
    ListXML = ListXML + "<VALUE>" + AprTypeToName(pAPRTYPE) + "</VALUE>";
    ListXML = ListXML + "</CELL>";
    ListXML = ListXML + "<CELL>";
    ListXML = ListXML + "<VALUE>" + strLangAprState1 + "</VALUE>";
    ListXML = ListXML + "</CELL>";
    ListXML = ListXML + "<CELL><VALUE></VALUE></CELL>";
    ListXML = ListXML + "</ROW></ROWS></LISTVIEWDATA>";

    Resultxml = loadXMLString(ListXML);
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");

    var InitTr = pAPRLINE.GetDataRows();

    var MaxID = 0;

    for (var j = 0; j < InitTr.length; j++) {
        var curnum = Number(pAPRLINE.GetSelectedRowID(j).substring(pAPRLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAPRLINE.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (InitTr.length == 0 || InitTr[0].id.indexOf("noItems") > 0) {
        if (document.getElementById("APRLINE").innerHTML != "")
            document.getElementById("APRLINE").innerHTML = "";

        var pAPRLINE = new ListView();
        pAPRLINE.SetID("lvAPRAUTORULELINE");
        pAPRLINE.SetMulSelectable(false);
        pAPRLINE.SetRowOnClick("OnSelChange_onclick");
        pAPRLINE.SetRowOnDblClick("AprAutoRuleLineDel_onclick");
        pAPRLINE.SetSelectFlag(false);
        pAPRLINE.SetHeightFree(true);
        pAPRLINE.DataSource(Resultxml);
        pAPRLINE.DataBind("APRLINE");
        pAPRLINE.SetSelectedIndex(0);
    }
    else {
        var objTr = pAPRLINE.NewAddRow(0, "lvAPRAUTORULELINE" + "_TR_" + eval(MaxID + 1));
        pAPRLINE.AddDataRow(objTr, Resultxml);
        pAPRLINE.SetSelectedIndex(MaxID + 1);
    }

    LineAprTyepSet();
}

function APRLINEATTENDADDFunction(pCurSelectedRow, Mode) {
    switch (Mode.toUpperCase()) {
        case "PERSON":
            AddAprLine_Person(pCurSelectedRow);
            break;
        case "DEPT":
            AddAprLine_Dept(pCurSelectedRow);
            break;
        case "DEPTHEAD":
            AddAprLine_DeptHeader(pCurSelectedRow);
            break;
    }
}

function AddAprLine_Person(pCurSelectedRow) {
    var chkDuplflag = false;
    if (pCurSelectedRow == null) {
    }
    else {
        var pAPRMEMBERID = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA2"));
        var pAPRMEMBERISDEPTYN = "N";
        var pAPRMEMBERNAME = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA7"));
        var pAPRMEMBERNAME2 = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA8"));
        var pAPRMEMBERJOBTITLE = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA11"));
        var pAPRMEMBERJOBTITLE2 = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA12"));
        var pAPRMEMBERDEPTID = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA3"));
        var pAPRMEMBERDEPTNAME = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA9"));
        var pAPRMEMBERDEPTNAME2 = MakeXMLString(GetAttribute(pCurSelectedRow[0], "DATA10"));

        var treeView = new TreeView();
        treeView.LoadFromID("LineUserTree");
        var selnode = treeView.GetSelectNode();     

        var pAPRMEMBERLDAPPATH = MakeXMLString(selnode.GetNodeData("EXTENSIONATTRIBUTE2")); 

        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        var totalRow = pAPRLINE.GetDataRows();

        for (i = 0; i < totalRow.length; i++) {
            if (GetAttribute(totalRow[i], "DATA2") == pAPRMEMBERID && GetAttribute(totalRow[i], "DATA10") == pAPRMEMBERDEPTID) {
                chkDuplflag = true;
                break;
            }
        }

        if (chkDuplflag) {
            var pInformationContent = strLang228 + "<br>" + strLang229;
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans) {
                return;
            }
        }

        AddRow_AprLine(strAprType1, strAprState1, pAPRMEMBERID, pAPRMEMBERISDEPTYN, pAPRMEMBERNAME, pAPRMEMBERNAME2, pAPRMEMBERJOBTITLE,
            pAPRMEMBERJOBTITLE2, pAPRMEMBERDEPTID, pAPRMEMBERDEPTNAME, pAPRMEMBERDEPTNAME2, pAPRMEMBERLDAPPATH);
    }
}

function AddAprLine_Dept(pCurSelectedRow) {
    var chkDuplflag = false;
    if (pCurSelectedRow == null) {
    }
    else {
        if (!isgetUser(pCurSelectedRow.GetNodeData("CN"))) {
            var pAlertContent = strLang222 + "<br>" + strLang223;
            OpenAlertUI(pAlertContent);
            return;
        }

        var pAPRMEMBERID = MakeXMLString(pCurSelectedRow.GetNodeData("CN"));
        var pAPRMEMBERISDEPTYN = "Y";
        var pAPRMEMBERNAME = "";
        var pAPRMEMBERNAME2 = "";
        var pAPRMEMBERJOBTITLE = "";
        var pAPRMEMBERJOBTITLE2 = "";
        var pAPRMEMBERDEPTID = MakeXMLString(pCurSelectedRow.GetNodeData("CN"));
        var pAPRMEMBERDEPTNAME = MakeXMLString(pCurSelectedRow.GetNodeData("DISPLAYNAME1"));
        var pAPRMEMBERDEPTNAME2 = MakeXMLString(pCurSelectedRow.GetNodeData("DISPLAYNAME2"));
        var pAPRMEMBERLDAPPATH = MakeXMLString(pCurSelectedRow.GetNodeData("EXTENSIONATTRIBUTE2"));

        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        var totalRow = pAPRLINE.GetDataRows();

        for (i = 0; i < totalRow.length; i++) {
            
            if (GetAttribute(totalRow[i], "DATA12") == pAPRMEMBERDEPTID && GetAttribute(totalRow[i], "DATA6") == pAPRMEMBERID) {
                chkDuplflag = true;
                break;
            }
        }

        if (chkDuplflag) {
            var pInformationContent = strLang227;
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans) {
                return;
            }
        }
        
        var AprTypeTopValue = ChangeAprlineType("group", strAprType1);
        AprTypeTopValue = AprTypeTopValue.substring(AprTypeTopValue.indexOf("value=") + 6, AprTypeTopValue.indexOf(" value2="));
        strAprType1 = AprTypeTopValue;

        AddRow_AprLine(strAprType1, strAprState1, pAPRMEMBERID, pAPRMEMBERISDEPTYN, pAPRMEMBERNAME, pAPRMEMBERNAME2, pAPRMEMBERJOBTITLE,
            pAPRMEMBERJOBTITLE2, pAPRMEMBERDEPTID, pAPRMEMBERDEPTNAME, pAPRMEMBERDEPTNAME2, pAPRMEMBERLDAPPATH);
    }
}

function AddAprLine_DeptHeader(pCurSelectedRow) {
    var chkDuplflag = false;
    if (pCurSelectedRow == null) {
    }
    else {
        if (!isgetUser(pCurSelectedRow.GetNodeData("CN"))) {
            var pAlertContent = strLang222 + "<br>" + strLang223;
            OpenAlertUI(pAlertContent);
            return;
        }

        var pAPRMEMBERID = "#selboss";
        var pAPRMEMBERISDEPTYN = "N";
        var pAPRMEMBERNAME = strLang678;
        var pAPRMEMBERNAME2 = "";
        var pAPRMEMBERJOBTITLE = "";
        var pAPRMEMBERJOBTITLE2 = "";
        var pAPRMEMBERDEPTID = MakeXMLString(pCurSelectedRow.GetNodeData("CN"));
        var pAPRMEMBERDEPTNAME = MakeXMLString(pCurSelectedRow.GetNodeData("DISPLAYNAME1"));
        var pAPRMEMBERDEPTNAME2 = MakeXMLString(pCurSelectedRow.GetNodeData("DISPLAYNAME2"));
        var pAPRMEMBERLDAPPATH = MakeXMLString(pCurSelectedRow.GetNodeData("EXTENSIONATTRIBUTE2"));

        var pAPRLINE = new ListView();      
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        var totalRow = pAPRLINE.GetDataRows();

        for (i = 0; i < totalRow.length; i++) {
            if (GetAttribute(totalRow[i], "DATA12") == pAPRMEMBERDEPTID && GetAttribute(totalRow[i], "DATA6") == pAPRMEMBERID) {
                chkDuplflag = true;
                break;
            }
        }

        if (chkDuplflag) {
            var pInformationContent = strLang227;
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans) {
                return;
            }
        }

        AddRow_AprLine(strAprType1, strAprState1, pAPRMEMBERID, pAPRMEMBERISDEPTYN, pAPRMEMBERNAME, pAPRMEMBERNAME2, pAPRMEMBERJOBTITLE,
            pAPRMEMBERJOBTITLE2, pAPRMEMBERDEPTID, pAPRMEMBERDEPTNAME, pAPRMEMBERDEPTNAME2, pAPRMEMBERLDAPPATH);
    }
}


function ChangeAprlineType(CheckGPerson, CurrentAprType) {
    var ReturnValue = "";
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        if (CheckGPerson == "group") {
            var selDeptID = GetAttribute(pAPRLINE.GetSelectedRows()[0], "DATA12");
            var p_AprlineValue = new Array();
            var p_AprlineCode = new Array();

            var i = 0;
            var j = 0;

            for (i = 0; i < SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE").length; i++) {
                if (SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE") == strAprType13) {
                    p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");
                    p_AprlineCode[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE");
                    j = j + 1;
                }
                else {
                    p_AprlineValue[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "NAME");
                    p_AprlineCode[j] = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/DEPTTYPES/APRTYPE")[i], "CODE");
                    j = j + 1;
                }
            }

            var p_Aprlinelen = p_AprlineValue.length;
            for (i = 0; i < p_Aprlinelen; i++) {
                var p_Option = document.createElement("OPTION");
                setNodeText(p_Option,p_AprlineValue[i]);
                p_Option.setAttribute("value", p_AprlineCode[i]);
                p_Option.setAttribute("value2", p_AprlineValue[i]);

                if (CurrentAprType == p_AprlineCode[i])
                    p_Option.selected = true;

                ReturnValue = ReturnValue + p_Option.outerHTML;
            }
        }
        else if (CheckGPerson == "user") {
            var p_AprlineValue = new Array();
            var p_AprlineCode = new Array();
            var i = 0;
            var j = 0;
            var tempName = "";
            var tempCode = "";
            var selLength = SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE").length;

            for (i = 0; i < selLength; i++) {
                tempName = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[i], "NAME");
                tempCode = SelectSingleNodeValue(SelectNodes(AprTypeXML, "APRTYPES/USERTYPES/APRTYPE")[i], "CODE");

                switch (tempCode) {
                    case "A03001":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;

                    case "A03002":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;

                    case "A03003":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;

                    case "A03004":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;

                    case "A03007":
                        if (pChamJoFlag == "Y" && pReDraftFlag != "GAMSABU") {
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                        }
                        break;
                    case "A03008":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;
                    case "A03009":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;

                    case "A03031":
                    case "A03032":    
                        if (pReDraftFlag == "DRAFT" || pReDraftFlag == "REDRAFT") {
                            p_AprlineValue[j] = tempName;
                            p_AprlineCode[j] = tempCode;
                            j = j + 1;
                        }
                        break;
                    default:
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;
                }
            }

            var p_Aprlinelen = p_AprlineValue.length;
            for (i = 0; i < p_Aprlinelen; i++) {
                var p_Option = document.createElement("OPTION");
                setNodeText(p_Option,p_AprlineValue[i]);
                p_Option.setAttribute("value", p_AprlineCode[i]);
                p_Option.setAttribute("value2", p_AprlineValue[i]);

                if (CurrentAprType == p_AprlineCode[i])
                    if (CrossYN())
                        p_Option.setAttribute("selected", "true")
                    else
                        p_Option.selected = true;

                ReturnValue = ReturnValue + p_Option.outerHTML;

            }
        }
    }
    catch (e) {
        alert("ChangeAprlineType :: " + e.description);
    }
    return ReturnValue;
}

function initJunGyul() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var pTotalRows = pAPRLINE.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;

    for (var i = pTotalRowsLen - 1; i > 0; i--) {
        if (GetAttribute(pTotalRows[i], "DATA7") == "N") {
            for (var z = 0; z < pTotalRows[i].cells[4].childNodes[0].length; z++) {
                if (pTotalRows[i].cells[4].childNodes[0].options[z].selected && getNodeText(pTotalRows[i].cells[4].childNodes[0].options[z]) == strLangAprType4) {
                    for (var y = 0; y < i; y++) {
                        var SelectObjectId = GetAttribute(pTotalRows[y], "id") + "select";

                        var p_Option = document.createElement("OPTION");
                        setNodeText(p_Option,strLangAprType3);
                        p_Option.setAttribute("value", "A03003");
                        p_Option.setAttribute("value2", strLangAprType3);

                        var AprTypeObj = "<select id='" + SelectObjectId + "' disabled style='width:100px;'>" + p_Option.outerHTML + "</select>";
                        pTotalRows[y].cells[4].innerHTML = AprTypeObj;

                        SetAttribute(pTotalRows[y], "DATA11", strAprType3);
                    }
                }
            }
        }
    }
}

function CheckSignCellValue() {
    return true;
}


function AddDeptmentSelected() {
    var treeView = new TreeView();
    treeView.LoadFromID("FromTreeView");

    var pTreeSelNode = treeView.GetSelectNode();
    APRLINEATTENDADDFunction(pTreeSelNode, "DEPTHEAD");
}


function AprlineType_onchange(obj) {
    try {
        var pCheckTypevalue = obj.value;
        var TypeName = getNodeText(obj.childNodes[obj.selectedIndex]);
        APRLINETYPECHANGEFunction(pCheckTypevalue, TypeName);
    } catch (e) {
        alert("AprlineType_onchange :: " + e.description);
    }
}

function APRLINETYPECHANGEFunction(valuecode, valueName) {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
    var pCurSelRow = pAPRLINE.GetSelectedRows();
    AprLineTypeCheck(valueName, valuecode, pCurSelRow);
}


function AprLineTypeCheck(p_AprLineValueName, p_AprLineValueCode, CurSelRow) {
    if (CurSelRow != null) {
        var ReasonNoCheck;
        var p_AprlineTypeVal;
        var p_AprlineTypeValCode;
        var RtnVal = true;
        p_AprlineTypeValCode = GetAttribute(CurSelRow[0], "DATA4");
        if (RtnVal) {
            if (p_AprLineValueCode == "A03004") {
                var pCurSelIndex = getNodeText(CurSelRow[0].cells[0]);
                var pTmpAprLineTypeCode, pTmpAprLineTypeName;
                pTmpAprLineTypeCode = strAprType3;
                pTmpAprLineTypeName = strLangAprType3;
                rtnvalue = ApplyJunGyulFunction(pCurSelIndex, pTmpAprLineTypeCode, pTmpAprLineTypeName);
                if (rtnvalue == "check") {
                    return;
                }
            }
            else if (p_AprlineTypeValCode == "A03004") {
                var pAPRLINE = new ListView();      
                pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
                var pAprLineRow = pAPRLINE.GetDataRows();
                var pAprLineRowLen = pAprLineRow.length;

                for (i = 0; i < pAprLineRowLen; i++) {
                    var templinevalue = parseInt(getNodeText(pAprLineRow[i].cells[0]));
                    var temprowvalue = parseInt(getNodeText(CurSelRow[0].cells[0]));
                    

                    if (templinevalue > temprowvalue) {
                        if (GetAttribute(pAprLineRow[i], "DATA4") == strAprType3) {

                            var cnt = pAprLineRow[i].cells[4].childNodes[0].length;
                            if (pAprLineRow[i].cells[4].childNodes[0].value == strAprType3) {
                                if (pAprLineRow[i].cells[4].childNodes[0].disabled) {
                                    var AprTypeObj = ChangeAprlineType("user", strAprType1);
                                    AprTyepID = GetAttribute(pAprLineRow[i], "id") + "select";
                                    AprTypeObj = "<select id='" + AprTyepID + "' onChange=\"return AprlineType_onchange(this)\" >" + AprTypeObj + "</select>";
                                    pAprLineRow[i].cells[4].innerHTML = AprTypeObj;
                                    SetAttribute(pAprLineRow[i], "DATA11", strAprType1);
                                }
                            }
                        }
                    }
                    else {
                        break;
                    }
                }
                pAPRLINE = null;
            }

            SetAttribute(CurSelRow[0], "DATA4", p_AprLineValueCode);
        }
    }
}


function AprlineDown_onclick() {
    APRLINESNDownFunction();
}


function AprlineUpper_onclick() {
    APRLINESNUPPERFunction();
}

function APRLINESNDownFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        var pSelectedRow = pAPRLINE.GetSelectedRows();

        if (pSelectedRow[0] == undefined) {
            OpenAlertUI(strLang574);
            return;
        }

        
        
        
        

        var pSelAprLineState = GetAttribute(pSelectedRow[0], "DATA5");
        if (pSelectedRow.length != 0) {
            var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) + 1];
            if (p_NextSelRow == undefined)
                return;

            
            
            
            

            if (GetAttribute(pSelectedRow[0], "DATA7") == "N") {
                if (pSelectedRow[0].cells[4].childNodes[0].value == strAprType3 || pSelectedRow[0].cells[4].childNodes[0].value == strAprType4) {
                    OpenAlertUI(strLang577);
                    return;
                }

                if (GetAttribute(p_NextSelRow, "DATA7") == "N") {
                    if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                        OpenAlertUI(strLang576);
                        return;
                    }
                }

            }
            else {
                if (GetAttribute(p_NextSelRow, "DATA7") == "N") {
                    if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                        OpenAlertUI(strLang576);
                        return;
                    }
                }
            }

            if (p_NextSelRow != null) {
                var p_NextAprStat = GetAttribute(p_NextSelRow, "DATA5");
                if ((pSelAprLineState == "A04003" || p_NextAprStat == "A04003") && pReDraftFlag == "DRAFT") {
                    var pAlertContent = strLang237;
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else if (pReDraftFlag == "REDRAFT") {
                    if (pSelAprLineState == "A04002" || pSelAprLineState == "A04003" || pSelAprLineState == "A04004") {
                        Ans = ture;
                        if (Ans) {
                            AprLineChangeType();
                            DoAprLineDown(pSelectedRow);
                            pReDraftAprLineChangeFlag = true;
                            if (USE_APRLINEVIEWER == "YES")
                                SetTask(pAPRLINE.GetDataRows(), "");
                        }
                    }
                    else {
                        DoAprLineDown(pSelectedRow);
                        if (USE_APRLINEVIEWER == "YES")
                            SetTask(pAPRLINE.GetDataRows(), "");
                    }
                }
                else {
                    var temproevalue = getNodeText(pSelectedRow[0].cells[0]);

                    if (pReDraftAprLineFlag) {
                        if (((p_NextAprStat == "A04002" || p_NextAprStat == "A04005") && GetAttribute(p_NextSelRow, "DATA6") == pUserID || p_NextAprStat == "A04003")) {
                            var pAlertContent = strLang239;
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                        else if ((pSelAprLineState == "A04002" && GetAttribute(pSelectedRow[0], "DATA6") == pUserID)) {
                            var pAlertContent = strLang239;
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                        else if (CurAprLine > temproevalue) {
                            var pAlertContent = strLang241;
                            OpenAlertUI(pAlertContent);
                            return;
                        }
                        else {
                            DoAprLineDown(pSelectedRow);
                            if (USE_APRLINEVIEWER == "YES")
                                SetTask(pAPRLINE.GetDataRows(), "");
                        }
                    }
                    else {
                        DoAprLineDown(pSelectedRow);
                        if (USE_APRLINEVIEWER == "YES")
                            SetTask(pAPRLINE.GetDataRows(), "");
                    }
                }
            }
        }
    } catch (e) {
        alert("APRLINESNDownFunction :: " + e.description);
    }
}


function DoAprLineDown(pSelectedRow) {
    try {
        var RowDownCheck;
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;

        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var CIndex = pSelectedIndex;
        var NIndex;
        var Rtnval = "N";
        var Mark = "";
        NIndex = pSelectedIndex + 1;
        if (NIndex < pTotalRowsLen) {
            RowDownCheck = getNodeText(pTotalRows[NIndex].cells[0]);

            if (CrossYN()) {
                setNodeText(pTotalRows[NIndex].childNodes[0] , getNodeText(pTotalRows[CIndex].cells[0]).replace("★", "").replace("⊙", ""));
                setNodeText(pTotalRows[CIndex].childNodes[0] , RowDownCheck.replace("★", "").replace("⊙", ""));

                if ((GetAttribute(pTotalRows[NIndex], "DATA19") != null ? GetAttribute(pTotalRows[NIndex], "DATA19").toUpperCase() : "")== "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[NIndex], "DATA20") != null ? GetAttribute(pTotalRows[NIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[NIndex].childNodes[0] , Mark + getNodeText(pTotalRows[NIndex].cells[0]));
                Mark = "";
                if ((GetAttribute(pTotalRows[CIndex], "DATA19") != null ? GetAttribute(pTotalRows[CIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[CIndex], "DATA20") != null ? GetAttribute(pTotalRows[CIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[CIndex].childNodes[0] , Mark + getNodeText(pTotalRows[CIndex].cells[0]));
            }
            else {
                setNodeText(pTotalRows[NIndex].cells[0],getNodeText(pTotalRows[CIndex].cells[0]).replace("★", "").replace("⊙", ""));
                setNodeText(pTotalRows[CIndex].cells[0],RowDownCheck.replace("★", "").replace("⊙", ""));

                if ((GetAttribute(pTotalRows[NIndex], "DATA19") != null ? GetAttribute(pTotalRows[NIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[NIndex], "DATA20") != null ? GetAttribute(pTotalRows[NIndex], "DATA20").toUpperCase() : "").toUpperCase() == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[NIndex].childNodes[0],Mark + getNodeText(pTotalRows[NIndex].cells[0]));
                Mark = "";

                if ((GetAttribute(pTotalRows[CIndex], "DATA19") != null ? GetAttribute(pTotalRows[CIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[CIndex], "DATA20") != null ? GetAttribute(pTotalRows[CIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";
                setNodeText(pTotalRows[CIndex].childNodes[0],Mark + getNodeText(pTotalRows[CIndex].cells[0]));
            }
            Rtnval = "Y";
        }
        if (Rtnval == "Y")
            pAPRLINE.RowMoveDown();
    } catch (e) {
        alert("DoAprLineDown :: " + e.description);
    }
}


function AprlineUpper_onclick() {
    APRLINESNUPPERFunction();
}

function APRLINESNUPPERFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        var pSelectedRows = pAPRLINE.GetSelectedRows();

        if (pSelectedRows[0] == undefined) {
            OpenAlertUI(strLang574);
            return;
        }

        var pSelAprLineState = GetAttribute(pSelectedRows[0], "DATA5");
        
        
        
        

        if (pSelectedRows.length != 0) {
            var p_NextSelRow = pAPRLINE.GetDataRows()[Number(pAPRLINE.GetSelectedIndexes().split(',')[0]) - 1];
            if (p_NextSelRow == undefined)
                return;

            if (GetAttribute(pSelectedRows[0], "DATA7") == "N") {
                if (pSelectedRows[0].cells[4].childNodes[0].value == strAprType3 || pSelectedRows[0].cells[4].childNodes[0].value == strAprType4) {
                    OpenAlertUI(strLang577);
                    return;
                }
                if (p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                    OpenAlertUI(strLang287);
                    return;
                }
                if (pAPRLINE.GetDataRows().length != parseInt(pSelectedRows[0].childNodes[0].innerHTML)) {
                    if (GetAttribute(p_NextSelRow, "DATA7") == "N") {
                        if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                            OpenAlertUI(strLang576);
                            return;
                        }
                    }
                }
            }
            else {
                if (GetAttribute(p_NextSelRow, "DATA7") == "N") {
                    if (p_NextSelRow.cells[4].childNodes[0].value == strAprType3 || p_NextSelRow.cells[4].childNodes[0].value == strAprType4) {
                        OpenAlertUI(strLang576);
                        return;
                    }
                }
            }
            if (pSelAprLineState == "A04003" && pReDraftFlag != "REDRAFT") {
                var pAlertContent = strLang237;
                OpenAlertUI(pAlertContent);
                return;
            }
            else if (pReDraftFlag == "REDRAFT") {
                if (pSelAprLineState == "A04002" || pSelAprLineState == "A04003" || pSelAprLineState == "A04004" || GetAttribute(pSelectedRows[0], "DATA4") == pUserID) {
                    Ans = true;
                    if (Ans) {
                        UpperAprLineSN(pSelectedRows);
                        AprLineChangeType();
                        pReDraftAprLineChangeFlag = true;
                    }
                } else {
                    UpperAprLineSN(pSelectedRows);
                    if (USE_APRLINEVIEWER == "YES")
                        SetTask(pAPRLINE.GetDataRows(), "");
                }
            }
            else {
                if (pReDraftAprLineFlag) {
                    var TmpAprLineState = GetAttribute(pSelectedRows[0], "DATA5");
                    var tempcellvalue = getNodeText(pSelectedRows[0].cells[0]);
                    if (((TmpAprLineState == "A04002" || TmpAprLineState == "A04005") && GetAttribute(pSelectedRows[0], "DATA6") == pUserID || tempcellvalue == "1")) {
                        var pAlertContent = strLang245;
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                    else if (CurAprLine > tempcellvalue) {
                        var pAlertContent = strLang241;
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                    else {
                        UpperAprLineSN(pSelectedRows);
                        if (USE_APRLINEVIEWER == "YES")
                            SetTask(pAPRLINE.GetDataRows(), "");
                    }
                } else {
                    UpperAprLineSN(pSelectedRows);
                    if (USE_APRLINEVIEWER == "YES")
                        SetTask(pAPRLINE.GetDataRows(), "");
                }
            }
        }
    } catch (e) {
        alert("APRLINESNUPPERFunction :: " + e.description);
    }
}

function UpperAprLineSN(pSelectedRow) {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
        var RowUpCheck;
        var NIndex = pSelectedIndex - 1;
        var CIndex = pSelectedIndex;
        var Rtnval = "N";
        var Mark = "";
        if (NIndex >= 0) {
            RowUpCheck = getNodeText(pTotalRows[NIndex].cells[0]);

            if (CrossYN()) {
                setNodeText(pTotalRows[NIndex].childNodes[0] , getNodeText(pTotalRows[CIndex].cells[0]).replace("★", "").replace("⊙", ""));
                setNodeText(pTotalRows[CIndex].childNodes[0] , RowUpCheck.replace("★", "").replace("⊙", ""));

                if ((GetAttribute(pTotalRows[NIndex], "DATA19") != null ? GetAttribute(pTotalRows[NIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[NIndex], "DATA20") != null ? GetAttribute(pTotalRows[NIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[NIndex].childNodes[0] , Mark + getNodeText(pTotalRows[NIndex].cells[0]));

                Mark = "";

                if ((GetAttribute(pTotalRows[CIndex], "DATA19") != null ? GetAttribute(pTotalRows[CIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[CIndex], "DATA20") != null ? GetAttribute(pTotalRows[CIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[CIndex].childNodes[0] , Mark + getNodeText(pTotalRows[CIndex].cells[0]));
            }
            else {
                setNodeText(pTotalRows[NIndex].cells[0],getNodeText(pTotalRows[CIndex].cells[0]).replace("★", "").replace("⊙", ""));
                setNodeText(pTotalRows[CIndex].cells[0],RowUpCheck.replace("★", "").replace("⊙", ""));

                if ((GetAttribute(pTotalRows[NIndex], "DATA19") != null ? GetAttribute(pTotalRows[NIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[NIndex], "DATA20") != null ? GetAttribute(pTotalRows[NIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[NIndex].childNodes[0],Mark + getNodeText(pTotalRows[NIndex].cells[0]));
                Mark = "";

                if ((GetAttribute(pTotalRows[CIndex], "DATA19") != null ? GetAttribute(pTotalRows[CIndex], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[CIndex], "DATA20") != null ? GetAttribute(pTotalRows[CIndex], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[CIndex].childNodes[0],Mark + getNodeText(pTotalRows[CIndex].cells[0]));
            }
            Rtnval = "Y";
        }

        if (Rtnval == "Y")
            pAPRLINE.RowMoveUp();

    } catch (e) {
        alert("UpperAprLineSN :: " + e.description);
    }
}


function AprAutoRuleLineDel_onclick() {
    var Event_ID = "";
    if (!CrossYN()) {
        
        Event_ID = GetAttribute(window.event.srcElement, "id")
        if (Event_ID == null) {
            Event_ID = "";
        }
    }
    else if (navigator.userAgent.indexOf('Firefox') > -1) {
        Event_ID = "";
        if (Event_ID == null) {
            Event_ID = "";
        }
    }
    else {
        Event_ID = event.target.id || event.srcElement.id;
        if (Event_ID == null) {
            Event_ID = "";
        }
    }
    if (Event_ID.indexOf("lvAPRAUTORULELINE_TR_") == -1) {
        APRLINEATTENDERDELFunction();
    }
}

function APRLINEATTENDERDELFunction() {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");
        var pSelectedRow = pAPRLINE.GetSelectedRows();

        pSelAprLineState = GetAttribute(pSelectedRow[0], "DATA5");

        if (pSelectedRow.length != 0 && pSelectedRow != null && pAPRLINE.GetSelectedIndexes().split(',')[0] != -1) {
            if (pSelAprLineState == "A04003" && pReDraftFlag != "REDRAFT") {
                var pAlertContent = strLang247;
                OpenAlertUI(pAlertContent);
                return;
            }
            else if (pReDraftFlag == "REDRAFT") {
                var pDraftSN = getNodeText(pSelectedRow[0].cells[0]);
                if (pSelAprLineState == "A04002" || pSelAprLineState == "A04003" || pSelAprLineState == "A04004" || pDraftSN == "1") {
                    Ans = true;
                    if (Ans) {
                        AprLineChangeType();
                        DoDelete(pSelectedRow);
                        pReDraftAprLineChangeFlag = true;
                    }
                } else {
                    DoDelete(pSelectedRow);
                }
            } else {
                if (pReDraftAprLineFlag) {
                    var TmpAprLineState = GetAttribute(pSelectedRow[0], "DATA5");
                    var tempcellvalue = getNodeText(pSelectedRow[0].cells[0]);
                    if ((TmpAprLineState == "A04002" || TmpAprLineState == "A04005") && GetAttribute(pSelectedRow[0], "DATA6") == pUserID || tempcellvalue == "1") {
                        var pAlertContent = strLang249;
                        OpenAlertUI(pAlertContent);
                        return;
                    }
                    else {
                        DoDelete(pSelectedRow)
                    }
                } else {
                    DoDelete(pSelectedRow)
                }
            }
        }
    } catch (e) {
        alert("APRLINEATTENDERDELFunction :: " + e.description);
    }
}

function DoDelete(pSelectedRow) {
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvAPRAUTORULELINE");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var RowDelCheck;
        var Rtnval = "N";
        TIndex = pTotalRows.length;
        NIndex = pSelectedIndex;

        for (i = 0; i <= NIndex; i++) {
            var Mark = ""
            if (CrossYN()) {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]).replace("★", "").replace("⊙", "");
                setNodeText(pTotalRows[i].childNodes[0] , RowDelCheck - 1);
                if ((GetAttribute(pTotalRows[i], "DATA19") != null ? GetAttribute(pTotalRows[i], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[i], "DATA20") != null ? GetAttribute(pTotalRows[i], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[i].childNodes[0] , Mark + Number(RowDelCheck - 1));
            }
            else {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]).replace("★", "").replace("⊙", "");
                setNodeText(pTotalRows[i].cells[0],RowDelCheck - 1);
                if ((GetAttribute(pTotalRows[i], "DATA19") != null ? GetAttribute(pTotalRows[i], "DATA19").toUpperCase() : "") == "Y")
                    Mark = "★";
                if ((GetAttribute(pTotalRows[i], "DATA20") != null ? GetAttribute(pTotalRows[i], "DATA20").toUpperCase() : "") == "Y")
                    Mark = Mark + "⊙";

                setNodeText(pTotalRows[i].cells[0],Mark + Number(RowDelCheck - 1));
            }

            Rtnval = "Y";
        }

        if (Rtnval == "Y") {
            var selIdx = GetAttribute(pAPRLINE.GetSelectedRows()[0], "id");
            pAPRLINE.DeleteRow(selIdx);
        }
    } catch (e) {
        alert("DoDelete :: " + e.description);
    }
}


function InitAprLineListXML() {
    var pListXml = "<LISTVIEWDATA>";
    pListXml = pListXml + "<HEADERS>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang230 + "</NAME><WIDTH>30</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang107 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang49 + "</NAME><WIDTH>60</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang108 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang38 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang109 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "<HEADER><NAME>" + strLang231 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pListXml = pListXml + "</HEADERS>";
    pListXml = pListXml + "<ROWS>";
    pListXml = pListXml + "</ROWS>";
    pListXml = pListXml + "</LISTVIEWDATA>";

    if (document.getElementById("APRLINE").innerHTML != "")
        document.getElementById("APRLINE").innerHTML = "";

    AprListViewXML = loadXMLString(pListXml);

    var pAPRLINE = new ListView();
    pAPRLINE.SetID("lvAPRAUTORULELINE");
    pAPRLINE.SetMulSelectable(false);
    pAPRLINE.SetHeightFree(true);
    pAPRLINE.SetRowOnClick("OnSelChange_onclick");
    pAPRLINE.SetRowOnDblClick("AprAutoRuleLineDel_onclick");
    pAPRLINE.SetSelectFlag(false);
    pAPRLINE.DataSource(AprListViewXML);
    pAPRLINE.DataBind("APRLINE");

    if (pAPRLINE.GetDataRows().length > 0) {
        LineAprTyepSetAll();
    }

    initJunGyul();
}

function MakeFormAutoRuleXML() {
    var pDataCheck = false;
    var pErrorMsg = "";
    var retValue = new Array();

    if (bodyForm.hidAprRule.value != "") {
        OnChange_DocType(); 
        var AprRuleXML;
        var AprRuleLineXML;

        try {
            AprRuleXML = loadXMLString(bodyForm.hidAprRule.value);
            AprRuleLineXML = loadXMLString(bodyForm.hidAprRuleLine.value);
            pDataCheck = true;
        }
        catch (e) {
            pDataCheck = false;
            pErrorMsg = e.message;
        }
    }

    if (pDataCheck) {
        retValue[0] = "TRUE";
        retValue[1] = AprRuleXML.xml;
        retValue[2] = AprRuleLineXML.xml;
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = pErrorMsg;
    }

    return retValue;
}
