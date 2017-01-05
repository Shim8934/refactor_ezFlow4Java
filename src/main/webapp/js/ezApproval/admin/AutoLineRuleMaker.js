function S4() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}

function createGUID() {
    var guid = (S4() + S4() + "-" + S4() + "-4" + S4().substr(0, 3) + "-" + S4() + "-" + S4() + S4() + S4()).toLowerCase();
    return guid;
}

function ChangeStandVal() {
    if (document.getElementById("DDL_STANDVAL").value == "TitleCd") {
        document.getElementById("DDL_TITLE").style.display = "";
        document.getElementById("txtStandVal").value = "";
        document.getElementById("txtStandVal").aprId = "";
        document.getElementById("txtStandVal").style.display = "none";
        document.getElementById("txtStandVal").readOnly = true;
        document.getElementById("btnSelDept").style.display = "none";
    }
    else if (document.getElementById("DDL_STANDVAL").value == "DeptId") {
        document.getElementById("DDL_TITLE").style.display = "none";
        document.getElementById("txtStandVal").value = "";
        document.getElementById("txtStandVal").aprId = "";
        document.getElementById("txtStandVal").style.display = "";
        document.getElementById("txtStandVal").readOnly = true;
        document.getElementById("btnSelDept").style.display = "";
    }
    else {
        document.getElementById("DDL_TITLE").style.display = "none";
        document.getElementById("txtStandVal").value = "";
        document.getElementById("txtStandVal").aprId = "";
        document.getElementById("txtStandVal").style.display = "";
        document.getElementById("txtStandVal").readOnly = false;
        document.getElementById("txtStandVal").gubun = "Direct";
        document.getElementById("btnSelDept").style.display = "none";
    }
}

function OnChange_DocType() {
    try {
        if (bodyForm.hidAprRule.value == "") {
        	return;
        }

        var AprRuleXML = loadXMLString(bodyForm.hidAprRule.value);
        for (var i = GetElementsByTagName(AprRuleXML, "ROW").length - 1; i > -1 ; i--) {
            if (getNodeText(GetElementsByTagName(AprRuleXML, "DOCTYPE")[i]) == pDocType) {
                AprRuleXML.documentElement.removeChild(GetElementsByTagName(AprRuleXML, "ROW")[i]);
            }
        }

        var pAPRRULE = new ListView();
        pAPRRULE.LoadFromID("lvtAutoRule");
        var AprRuleRow = pAPRRULE.GetDataRows();
        var CurListLen = AprRuleRow.length;
        var i;
        var GetXml;
        var AprRuleTotalLen;
        AprRuleTotalLen = CurListLen;

        if (CurListLen > 0) {
            if (AprRuleRow[0].id != (pAPRRULE.GetID() + "_TR_noItems")) {
                for (i = 0; i < CurListLen; i++) {
                    newNode = createNode(AprRuleXML, "ROW");
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "FORMID", formID);
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "DOCTYPE", GetAttribute(AprRuleRow[i], "DATA2"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "AUTORULESN", getNodeText(AprRuleRow[i].cells[0]).replace("★", "").replace("⊙", ""));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "AUTORULEGUID", GetAttribute(AprRuleRow[i], "DATA4"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "CHECKFIELDTYPE", GetAttribute(AprRuleRow[i], "DATA5"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "CHECKFIELD", GetAttribute(AprRuleRow[i], "DATA6"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "OPERATORTYPE", GetAttribute(AprRuleRow[i], "DATA7"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "OPERATOR", GetAttribute(AprRuleRow[i], "DATA8"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "CONDTYPE", GetAttribute(AprRuleRow[i], "DATA9"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "CONDVALUE", GetAttribute(AprRuleRow[i], "DATA10"));
                    createNodeAndAppandNodeText(AprRuleXML, newNode, "", "CONDVALUEDEPTID", GetAttribute(AprRuleRow[i], "DATA11"));

                    x = AprRuleXML.getElementsByTagName("DATA")[0];
                    x.appendChild(newNode);
                }
            }
        }
        bodyForm.hidAprRule.value = getXmlString(AprRuleXML);

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
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "FORMID", formID);
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "DOCTYPE", GetAttribute(AprRuleLineRow[i], "DATA2"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERSN", getNodeText(AprRuleLineRow[i].cells[0]).replace("★", "").replace("⊙", ""));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRTYPE", GetAttribute(AprRuleLineRow[i], "DATA4"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRSTATE", GetAttribute(AprRuleLineRow[i], "DATA5"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERID", GetAttribute(AprRuleLineRow[i],"DATA6"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERISDEPTYN", GetAttribute(AprRuleLineRow[i],"DATA7"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERNAME", GetAttribute(AprRuleLineRow[i],"DATA8"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERNAME2", GetAttribute(AprRuleLineRow[i],"DATA9"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERJOBTITLE", GetAttribute(AprRuleLineRow[i],"DATA10"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERJOBTITLE2", GetAttribute(AprRuleLineRow[i],"DATA11"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERDEPTID", GetAttribute(AprRuleLineRow[i],"DATA12"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERDEPTNAME", GetAttribute(AprRuleLineRow[i],"DATA13"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERDEPTNAME2", GetAttribute(AprRuleLineRow[i],"DATA14"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "APRMEMBERLDAPPATH", GetAttribute(AprRuleLineRow[i],"DATA15"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "RECEIVEDDATE", GetAttribute(AprRuleLineRow[i],"DATA16"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "PROCESSDATE",GetAttribute( AprRuleLineRow[i],"DATA17"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "REASONDONOTAPPROV",GetAttribute( AprRuleLineRow[i],"DATA18"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "ISPROPOSERYN", GetAttribute(AprRuleLineRow[i],"DATA19"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "ISBRIEFUSERYN", GetAttribute(AprRuleLineRow[i],"DATA20"));
                        createNodeAndAppandNodeText(AprRuleLineXML, newNode, "", "AUTORULEGUID", GetAttribute(AprRuleLineRow[i],"DATA21"));
                        x = AprRuleLineXML.getElementsByTagName("DATA")[0];
                        x.appendChild(newNode);
                    }
                }
            }
            bodyForm.hidAprRuleLine.value = getXmlString(AprRuleLineXML);
        }
        pDocType = document.getElementsByName("selDocType")[0].options[document.getElementsByName("selDocType")[0].selectedIndex].value;
        MakeListXML(pDocType);
        document.getElementById("DIVAPRLINE").style.display = "NONE";
    }
    catch (e) {
    }
}

function ChangeAprlineType(CheckGPerson, CurrentAprType) {
    var ReturnValue = "";
    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvtAutoRule");
        if (CheckGPerson == "group") {
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
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
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
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
                        break;
                    case "A03032":
                        p_AprlineValue[j] = tempName;
                        p_AprlineCode[j] = tempCode;
                        j = j + 1;
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

                if (CurrentAprType == p_AprlineCode[i])
                    p_Option.setAttribute("selected", "true");

                ReturnValue = ReturnValue + p_Option.outerHTML;
            }
        }
    } catch (e) {
        alert("ChangeAprlineType :: " + e.description);
    }
    return ReturnValue;
}

var xmlhttp_FormCheck = createXMLHttpRequest();
function CheckForm(pFormHref) {
    var pFormMHT = "";
    pAprLineCnt = 0;
    pHapLineCnt = 0;
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "FORMHREF", pFormHref);
    createNodeAndInsertText(xmlpara, objNode, "FORMMHT", pFormMHT);
    xmlhttp_FormCheck.open("POST", "/myoffice/ezApproval/manage/FormMaker/aspx/FormAnalysis.aspx", true);
    xmlhttp_FormCheck.onreadystatechange = FormCheck_After;
    xmlhttp_FormCheck.send(xmlpara);
}

function FormCheck_After() {
    if (xmlhttp_FormCheck == null || xmlhttp_FormCheck.readyState != 4) return;

    try {
        if (xmlhttp_FormCheck.responseText == "") return;
        var listNode = SelectSingleNodeNew(loadXMLString(xmlhttp_FormCheck.responseText), "DATA/FIELDDATA");
        var node = GetElementsByTagName(listNode, "FIELD");
        var pObj = document.getElementById("DDL_FIELDIDLIST")

        pObj.innerHTML = "";
        var optn = document.createElement("OPTION");
        setNodeText(optn , "직접입력");
        optn.value = "";
        pObj.options.add(optn);
        optn = null;

        for (var i = 0; i < node.length; i++) {
            var optn = document.createElement("OPTION");
            setNodeText(optn ,getNodeText(node[i]));
            optn.value = getNodeText(node[i]);
            pObj.options.add(optn);
        }
        FieldIdList_onChange();
    }
    catch (e) {
        alert("FormCheck_After : " + e.description);
    }
}

function DDL_CHECKTYPE_onChange() {
    switch (document.getElementById("DDL_CHECKTYPE").value) {
        case "DRAFTER_POSITION":
            document.getElementById("DDL_DATATYPE").value = "TXT";
            document.getElementById("DDL_DATATYPE").disabled = true;

            document.getElementById("DDL_NUMBER_EQUAL").style.display = "NONE";

            document.getElementById("DDL_TEXT_EQUAL").style.display = "";
            document.getElementById("DDL_TEXT_EQUAL").disabled = true;
            document.getElementById("DDL_TEXT_EQUAL").value = "TXT_EQ";

            document.getElementById("DDL_STANDVAL").disabled = true;
            document.getElementById("DDL_STANDVAL").value = "TitleCd";

            document.getElementById("DDL_FIELDIDLIST").value = "";
            document.getElementById("DDL_FIELDIDLIST").disabled = true;
            document.getElementById("txtCondVal").disabled = true;
            break;
        case "DRAFTER_DEPT":
            document.getElementById("DDL_DATATYPE").value = "TXT";
            document.getElementById("DDL_DATATYPE").disabled = true;

            document.getElementById("DDL_NUMBER_EQUAL").style.display = "NONE";
            document.getElementById("DDL_TEXT_EQUAL").style.display = "";
            document.getElementById("DDL_TEXT_EQUAL").disabled = true;
            document.getElementById("DDL_TEXT_EQUAL").value = "TXT_EQ";

            document.getElementById("DDL_STANDVAL").disabled = true;
            document.getElementById("DDL_STANDVAL").value = "DeptId";

            document.getElementById("DDL_FIELDIDLIST").value = "";
            document.getElementById("DDL_FIELDIDLIST").disabled = true;
            document.getElementById("txtCondVal").disabled = true;
            break;
        case "FIELD":
            document.getElementById("DDL_DATATYPE").value = "TXT";
            document.getElementById("DDL_DATATYPE").disabled = false;

            document.getElementById("DDL_NUMBER_EQUAL").style.display = "NONE";
            document.getElementById("DDL_TEXT_EQUAL").style.display = "";
            document.getElementById("DDL_TEXT_EQUAL").disabled = false;
            document.getElementById("DDL_TEXT_EQUAL").value = "TXT_EQ";

            document.getElementById("DDL_STANDVAL").disabled = true;
            document.getElementById("DDL_STANDVAL").value = "Direct";

            document.getElementById("DDL_FIELDIDLIST").disabled = false;
            document.getElementById("txtCondVal").disabled = false;
            break;
    }
    ChangeStandVal();
}

function FieldIdList_onChange() {
    if (document.getElementById("DDL_FIELDIDLIST").value == "") {
        document.getElementById("txtCondVal").disabled = false;
    }
    else {
        document.getElementById("txtCondVal").disabled = true;
        document.getElementById("txtCondVal").value = "";
    }
}

function DDL_DATATYPE_onChange() {
    switch (document.getElementById("DDL_DATATYPE").value) {
        case "TXT":
            document.getElementById("DDL_NUMBER_EQUAL").style.display = "NONE";
            document.getElementById("DDL_TEXT_EQUAL").style.display = "";
            break;
        case "NUM":
            document.getElementById("DDL_NUMBER_EQUAL").style.display = "";
            document.getElementById("DDL_TEXT_EQUAL").style.display = "NONE";
            break;
    }
}

function CheckField() {
    var pMessage = "";
    
    switch (document.getElementById("DDL_CHECKTYPE").value) {
        case "FIELD":   
            if (document.getElementById("DDL_FIELDIDLIST").value == "") {
                if (document.getElementById("txtCondVal").value == "") {
                    pMessage = strLang1110;
                }
            }
            break;
        case "DRAFTER_POSITION":   
            break;
        case "DRAFTER_DEPT":   
            break;
    }
    
    switch (document.getElementById("DDL_STANDVAL").value) {
        case "DeptId":
            if (document.getElementById("txtStandVal").aprId == "") {
                pMessage = strLang1111;
            }
            break;
        case "TitleCd":
            if (document.getElementById("DDL_TITLE").value == "") {
                pMessage = strLang1112;
            }
            break;
        case "Direct":
            if (document.getElementById("txtStandVal").value == "") {
                pMessage = strLang1113;
            }
            else {
                if (document.getElementById("DDL_DATATYPE").value == "NUM") {
                    var onlyNum = getNumberOnly(document.getElementById("txtStandVal").value);

                    if (document.getElementById("txtStandVal").value != onlyNum) {
                        pMessage = strLang1114;
                    }
                }
            }
            break
    }

    if (pMessage != "") {
        alert(pMessage);
        return false;
    }
    else {
        return true;
    }
}

function getNumberOnly(obj) {
    var val = obj;
    val = new String(val);
    var regex = /[^0-9]/g;
    val = val.replace(regex, '');

    return val;
}

function SelectDept() {
    var Flag;
    var retVal = new Array();
    var url = "/admin/ezApproval/organ.do"
    retVal = window.showModalDialog(url, companyID, "dialogWidth:290px;dialogHeight:525px;status:no;help:no;edge:sunken;scroll:no");

    if (typeof (retVal) != "undefined") {
        document.getElementById("txtStandVal").aprId = retVal[0];
        document.getElementById("txtStandVal").value = retVal[1];
        document.getElementById("txtStandVal").gubun = "D";
    }
}


function MakeListXML(pDocType) {
    var ListHeaderXML = loadXMLString(bodyForm.hidListHeader.value);
    var pListXml = "<LISTVIEWDATA>";
    pListXml = pListXml + "<HEADERS>";

    for (var i = 0; i < GetElementsByTagName(ListHeaderXML, "ROW").length; i++) {
        pListXml = pListXml + "<HEADER>";
        pListXml = pListXml + "<NAME>" + getNodeText(GetElementsByTagName(ListHeaderXML, "NAME")[i]) + "</NAME>";
        pListXml = pListXml + "<WIDTH>" + getNodeText(GetElementsByTagName(ListHeaderXML, "WIDTH")[i]) + "</WIDTH>";
        pListXml = pListXml + "<COLNAME>" + getNodeText(GetElementsByTagName(ListHeaderXML, "COLNAME")[i]) + "</COLNAME>";
        pListXml = pListXml + "</HEADER>";
    }

    pListXml = pListXml + "</HEADERS>";
    pListXml = pListXml + "<ROWS>";
    AprRuleXML = loadXMLString(bodyForm.hidAprRule.value);
    for (var i = 0; i < GetElementsByTagName(AprRuleXML, "ROW").length; i++) {
        if (getNodeText(GetElementsByTagName(AprRuleXML, "DOCTYPE")[i]) == pDocType) {
            pListXml = pListXml + "<ROW>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + " <VALUE>" + getNodeText(GetElementsByTagName(AprRuleXML, "AUTORULESN")[i]) + "</VALUE>";
            pListXml = pListXml + " <DATA1>" + getNodeText(GetElementsByTagName(AprRuleXML, "FORMID")[i]) + "</DATA1>";
            pListXml = pListXml + " <DATA2>" + getNodeText(GetElementsByTagName(AprRuleXML, "DOCTYPE")[i]) + "</DATA2>";
            pListXml = pListXml + " <DATA3>" + getNodeText(GetElementsByTagName(AprRuleXML, "AUTORULESN")[i]) + "</DATA3>";
            pListXml = pListXml + " <DATA4>" + getNodeText(GetElementsByTagName(AprRuleXML, "AUTORULEGUID")[i]) + "</DATA4>";
            pListXml = pListXml + " <DATA5>" + getNodeText(GetElementsByTagName(AprRuleXML, "CHECKFIELDTYPE")[i]) + "</DATA5>";
            pListXml = pListXml + " <DATA6>" + getNodeText(GetElementsByTagName(AprRuleXML, "CHECKFIELD")[i]) + "</DATA6>";
            pListXml = pListXml + " <DATA7>" + getNodeText(GetElementsByTagName(AprRuleXML, "OPERATORTYPE")[i]) + "</DATA7>";
            pListXml = pListXml + " <DATA8>" + getNodeText(GetElementsByTagName(AprRuleXML, "OPERATOR")[i]) + "</DATA8>";
            pListXml = pListXml + " <DATA9>" + getNodeText(GetElementsByTagName(AprRuleXML, "CONDTYPE")[i]) + "</DATA9>";
            pListXml = pListXml + " <DATA10>" + getNodeText(GetElementsByTagName(AprRuleXML, "CONDVALUE")[i]) + "</DATA10>";
            pListXml = pListXml + " <DATA11>" + getNodeText(GetElementsByTagName(AprRuleXML, "CONDVALUEDEPTID")[i]) + "</DATA11>";
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + " <VALUE><![CDATA[" + getNodeText(GetElementsByTagName(AprRuleXML, "CHECKFIELD")[i]) + "]]></VALUE>";
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            switch (getNodeText(GetElementsByTagName(AprRuleXML, "OPERATORTYPE")[i])) {
                case "TXT":
                    pListXml = pListXml + " <VALUE><![CDATA[문자]]></VALUE>";
                    break;
                case "NUM":
                    pListXml = pListXml + " <VALUE><![CDATA[숫자]]></VALUE>";
                    break;
            }
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            switch (getNodeText(GetElementsByTagName(AprRuleXML, "OPERATOR")[i])) {
                case "NUM_GE":
                    pListXml = pListXml + " <VALUE><![CDATA[>= (이상)]]></VALUE>";
                    break;
                case "NUM_LE":
                    pListXml = pListXml + " <VALUE><![CDATA[<= (이하)]]></VALUE>";
                    break;
                case "NUM_GT":
                    pListXml = pListXml + " <VALUE><![CDATA[> (초과)]]></VALUE>";
                    break;
                case "NUM_LT":
                    pListXml = pListXml + " <VALUE><![CDATA[< (미만)]]></VALUE>";
                    break;
                case "NUM_EQ":
                    pListXml = pListXml + " <VALUE><![CDATA[= (동일)]]></VALUE>";
                    break;
                case "TXT_EQ":
                    pListXml = pListXml + " <VALUE><![CDATA[동일]]></VALUE>";
                    break;
                case "TXT_INC":
                    pListXml = pListXml + " <VALUE><![CDATA[포함]]></VALUE>";
                    break;
                case "TXT_NOTINC":
                    pListXml = pListXml + " <VALUE><![CDATA[미포함]]></VALUE>";
                    break;
            }
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "<CELL>";
            pListXml = pListXml + " <VALUE><![CDATA[" + getNodeText(GetElementsByTagName(AprRuleXML, "CONDVALUE")[i]) + "]]></VALUE>";
            pListXml = pListXml + "</CELL>";
            pListXml = pListXml + "</ROW>";
        }
    }

    pListXml = pListXml + "</ROWS>";
    pListXml = pListXml + "</LISTVIEWDATA>";

    if (document.getElementById("div_List_AutoRule").innerHTML != "")
        document.getElementById('div_List_AutoRule').innerHTML = "";

    AprRuleViewXML = loadXMLString(pListXml);

    var AutoRule_Listview = new ListView();
    AutoRule_Listview.SetID("lvtAutoRule");
    AutoRule_Listview.SetRowOnClick("lvtAutoRule_OnSelChange_onclick");
    AutoRule_Listview.SetRowOnDblClick("Del_onclick");
    AutoRule_Listview.SetSelectFlag(false);
    AutoRule_Listview.SetHeightFree(true);
    AutoRule_Listview.DataSource(AprRuleViewXML);
    AutoRule_Listview.DataBind("div_List_AutoRule");
}


function btn_Add() {
    var pGuid = createGUID();
    var pAUTOLINE = new ListView();
    pAUTOLINE.LoadFromID("lvtAutoRule");

    if (!CheckField()) {
        return;
    }

    var ListHeaderXML = loadXMLString(bodyForm.hidListHeader.value);
    var pparsingXML = "<LISTVIEWDATA>";
    pparsingXML = pparsingXML + "<HEADERS>";

    for (var i = 0; i < GetElementsByTagName(ListHeaderXML, "ROW").length; i++) {
        pparsingXML = pparsingXML + "<HEADER>";
        pparsingXML = pparsingXML + "<NAME>" + getNodeText(GetElementsByTagName(ListHeaderXML, "NAME")[i]) + "</NAME>";
        pparsingXML = pparsingXML + "<WIDTH>" + getNodeText(GetElementsByTagName(ListHeaderXML, "WIDTH")[i]) + "</WIDTH>";
        pparsingXML = pparsingXML + "<COLNAME>" + getNodeText(GetElementsByTagName(ListHeaderXML, "COLNAME")[i]) + "</COLNAME>";
        pparsingXML = pparsingXML + "</HEADER>";
    }

    pparsingXML = pparsingXML + "</HEADERS>";

    var FixYN = "N", ResearchYN = "N";
    var AprLineRow = pAUTOLINE.GetDataRows();
    var AprLineAddIndex = AprLineRow.length;
    if (AprLineAddIndex == 1) {
        if (AprLineRow[0].id.indexOf("noItems") > 0)
            AprLineAddIndex = 0;
    }

    AprLineAddIndex = AprLineAddIndex + 1;
    pparsingXML = pparsingXML + "<ROWS><ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + AprLineAddIndex + "</VALUE>";
    pparsingXML = pparsingXML + "<DATA1>" + formID + "</DATA1>";
    pparsingXML = pparsingXML + "<DATA2>" + pDocType + "</DATA2>";
    pparsingXML = pparsingXML + "<DATA3>" + AprLineAddIndex + "</DATA3>";
    pparsingXML = pparsingXML + "<DATA4>" + pGuid + "</DATA4>";
    pparsingXML = pparsingXML + "<DATA5>" + document.getElementById("DDL_CHECKTYPE").value + "</DATA5>";

    switch (document.getElementById("DDL_CHECKTYPE").value) {
        case "FIELD":
            if (document.getElementById("DDL_FIELDIDLIST").value == "") {
                pparsingXML = pparsingXML + "<DATA6>" + document.getElementById("txtCondVal").value + "</DATA6>";
            }
            else {
                pparsingXML = pparsingXML + "<DATA6>" + document.getElementById("DDL_FIELDIDLIST").value + "</DATA6>";
            }
            break;
        case "DRAFTER_POSITION":
            pparsingXML = pparsingXML + "<DATA6>" + getNodeText(document.getElementById("DDL_CHECKTYPE")[document.getElementById("DDL_CHECKTYPE").selectedIndex]) + "</DATA6>";
            break;
        case "DRAFTER_DEPT":
            pparsingXML = pparsingXML + "<DATA6>" + getNodeText(document.getElementById("DDL_CHECKTYPE")[document.getElementById("DDL_CHECKTYPE").selectedIndex]) + "</DATA6>";
            break;
    }

    pparsingXML = pparsingXML + "<DATA7>" + document.getElementById("DDL_DATATYPE").value + "</DATA7>";
    switch (document.getElementById("DDL_DATATYPE").value) {
        case "TXT":
            pparsingXML = pparsingXML + "<DATA8>" + document.getElementById("DDL_TEXT_EQUAL").value + "</DATA8>";
            break;
        case "NUM":
            pparsingXML = pparsingXML + "<DATA8>" + document.getElementById("DDL_NUMBER_EQUAL").value + "</DATA8>";
            break;
    }

    pparsingXML = pparsingXML + "<DATA9>" + document.getElementById("DDL_STANDVAL").value + "</DATA9>";
    switch (document.getElementById("DDL_STANDVAL").value) {
        case "DeptId":
            pparsingXML = pparsingXML + "<DATA10>" + document.getElementById("txtStandVal").value + "</DATA10>";
            pparsingXML = pparsingXML + "<DATA11>" + document.getElementById("txtStandVal").aprId + "</DATA11>";
            break;
        case "TitleCd":
            pparsingXML = pparsingXML + "<DATA10>" + document.getElementById("DDL_TITLE").value + "</DATA10>";
            pparsingXML = pparsingXML + "<DATA11>" + getNodeText(document.getElementById("DDL_TITLE")) + "</DATA11>";
            break;
        case "Direct":
            pparsingXML = pparsingXML + "<DATA10>" + document.getElementById("txtStandVal").value + "</DATA10>";
            pparsingXML = pparsingXML + "<DATA11></DATA11>";
            break;
    }

    pparsingXML = pparsingXML + "</CELL>";
    pparsingXML = pparsingXML + "<CELL>";

    switch (document.getElementById("DDL_CHECKTYPE").value) {
        case "FIELD":
            if (document.getElementById("DDL_FIELDIDLIST").value == "") {
                pparsingXML = pparsingXML + "<VALUE>" + document.getElementById("txtCondVal").value + "</VALUE>";
            }
            else {
                pparsingXML = pparsingXML + "<VALUE>" + document.getElementById("DDL_FIELDIDLIST").value + "</VALUE>";
            }
            break;
        case "DRAFTER_POSITION":
            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(document.getElementById("DDL_CHECKTYPE")[document.getElementById("DDL_CHECKTYPE").selectedIndex]) + "]]></VALUE>";
            break;
        case "DRAFTER_DEPT":
            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(document.getElementById("DDL_CHECKTYPE")[document.getElementById("DDL_CHECKTYPE").selectedIndex]) + "]]></VALUE>";
            break;
    }

    pparsingXML = pparsingXML + "</CELL>";

    switch (document.getElementById("DDL_DATATYPE").value) {
        case "TXT":
            pparsingXML = pparsingXML + "<CELL><VALUE><![CDATA[" + getNodeText(document.getElementById("DDL_DATATYPE")[document.getElementById("DDL_DATATYPE").selectedIndex]) + "]]></VALUE></CELL>";
            pparsingXML = pparsingXML + "<CELL><VALUE><![CDATA[" + getNodeText(document.getElementById("DDL_TEXT_EQUAL")[document.getElementById("DDL_TEXT_EQUAL").selectedIndex]) + "]]></VALUE></CELL>";
            break;
        case "NUM":
            pparsingXML = pparsingXML + "<CELL><VALUE><![CDATA[" + getNodeText(document.getElementById("DDL_DATATYPE")[document.getElementById("DDL_DATATYPE").selectedIndex]) + "]]></VALUE></CELL>";
            pparsingXML = pparsingXML + "<CELL><VALUE><![CDATA[" + getNodeText(document.getElementById("DDL_NUMBER_EQUAL")[document.getElementById("DDL_NUMBER_EQUAL").selectedIndex]) + "]]></VALUE></CELL>";
            break;
    }

    switch (document.getElementById("DDL_STANDVAL").value) {
        case "DeptId":
            pparsingXML = pparsingXML + "<CELL><VALUE>" + document.getElementById("txtStandVal").value + "</VALUE></CELL>";
            break;
        case "TitleCd":
            pparsingXML = pparsingXML + "<CELL><VALUE>" + getNodeText(document.getElementById("DDL_TITLE").options[document.getElementById("DDL_TITLE").selectedIndex]) + "</VALUE></CELL>";
            break;
        case "Direct":
            pparsingXML = pparsingXML + "<CELL><VALUE>" + document.getElementById("txtStandVal").value + "</VALUE></CELL>";
            break;
    }

    pparsingXML = pparsingXML + "</ROW></ROWS></LISTVIEWDATA>";

    var Resultxml = loadXMLString(pparsingXML);
    var InitTr = pAUTOLINE.GetDataRows();
    var MaxID = 0;
    for (var j = 0  ; j < InitTr.length  ; j++) {
        var curnum = Number(pAUTOLINE.GetSelectedRowID(j).substring(pAUTOLINE.GetSelectedRowID(j).lastIndexOf('_') + 1), pAUTOLINE.GetSelectedRowID(j).length);
        if (MaxID < curnum)
            MaxID = curnum;
    }

    if (AprLineRow.length == 0 || InitTr[0].id.indexOf("noItems") > 0) {
        if (document.getElementById("div_List_AutoRule").innerHTML != "")
            document.getElementById("div_List_AutoRule").innerHTML = "";

        pAUTOLINE.SetMulSelectable(false);
        pAUTOLINE.SetRowOnClick("lvtAutoRule_OnSelChange_onclick");
        pAUTOLINE.SetRowOnDblClick("Del_onclick");
        pAUTOLINE.SetSelectFlag(false);
        pAUTOLINE.SetHeightFree(true);
        pAUTOLINE.DataSource(Resultxml);
        pAUTOLINE.DataBind("div_List_AutoRule");
        pAUTOLINE.SetSelectedIndex(0);
    }
    else {
        var objTr = pAUTOLINE.NewAddRow(0, "lvtAutoRule" + "_TR_" + eval(MaxID + 1));

        pAUTOLINE.AddDataRow(objTr, Resultxml);
        pAUTOLINE.SetSelectedIndex(eval(MaxID + 1));
    }
    AprLineAddIndex = AprLineAddIndex + 1;

    var AprLineRow = pAUTOLINE.GetDataRows();
    var AprLineAddIndex = AprLineRow.length;
    if (AprLineAddIndex == 1) {
        if (AprLineRow[0].id.indexOf("noItems") > 0)
            return;
    }
    else {
        for (var i = 0; i < AprLineAddIndex; i++) {
            setNodeText(AprLineRow[i].childNodes[0],(i + 1));
            AprLineRow[i].setAttribute("DATA3", (i + 1).toString());
        }
    }
    document.getElementById("DDL_CHECKTYPE").value = "FIELD";
    document.getElementById("DDL_FIELDIDLIST").value = "";
    document.getElementById("txtCondVal").value = "";
    document.getElementById("txtCondVal").disabled = false;
    document.getElementById("txtStandVal").value = "";
    document.getElementById("txtStandVal").aprId = "";
    document.getElementById("txtStandVal").style.display = "";
    document.getElementById("txtStandVal").readOnly = false;
    document.getElementById("txtStandVal").gubun = "Direct";
    document.getElementById("btnSelDept").style.display = "none";
}


function lvtAutoRule_OnSelChange_onclick() {
    var pAPRLINE = new ListView();
    pAPRLINE.LoadFromID("lvtAutoRule");

    var pSelectedRow = pAPRLINE.GetSelectedRows();

    if (pSelectedRow.length > 0) {
        document.getElementById("DIVAPRLINE").style.display = "";
        MakeAprLineListXML(GetAttribute(pSelectedRow[0], "DATA4"));
    }
}

function MoveUp_List_AutoRule_onclick() {
    var AutoRule_Listview = new ListView();
    AutoRule_Listview.LoadFromID("lvtAutoRule");

    if (AutoRule_Listview.GetSelectedRows().length == 0) {
        alert(strLang1108);
        return;
    }

    var pTotalRows = AutoRule_Listview.GetDataRows();
    var pSelectedIndex = Number(AutoRule_Listview.GetSelectedIndexes().split(',')[0]);
    var RowUpCheck;
    var NIndex = pSelectedIndex - 1;
    var CIndex = pSelectedIndex;
    var Rtnval = "N";

    if (NIndex >= 0) {
        RowUpCheck = getNodeText(pTotalRows[NIndex].cells[0]);

        if (CrossYN()) {
            setNodeText(pTotalRows[NIndex].childNodes[0] , getNodeText(pTotalRows[CIndex].cells[0]));
            pTotalRows[NIndex].setAttribute("DATA3", getNodeText(pTotalRows[CIndex].cells[0]));
            setNodeText(pTotalRows[CIndex].childNodes[0] , RowUpCheck);
            pTotalRows[CIndex].setAttribute("DATA3", RowUpCheck);
        }
        else {
            setNodeText(pTotalRows[NIndex].cells[0],getNodeText(pTotalRows[CIndex].cells[0]));
            pTotalRows[NIndex].setAttribute("DATA3", getNodeText(pTotalRows[CIndex].cells[0]));
            setNodeText(pTotalRows[CIndex].cells[0],RowUpCheck);
            pTotalRows[CIndex].setAttribute("DATA3", RowUpCheck);
        }
        Rtnval = "Y";
    }

    if (Rtnval == "Y")
        AutoRule_Listview.RowMoveUp();
}

function MoveDown_List_AutoRule_onclick() {
    var AutoRule_Listview = new ListView();
    AutoRule_Listview.LoadFromID("lvtAutoRule");

    if (AutoRule_Listview.GetSelectedRows().length == 0) {
        alert(strLang1108);
        return;
    }
    var pTotalRows = AutoRule_Listview.GetDataRows();
    var pTotalRowsLen = pTotalRows.length;
    var pSelectedIndex = Number(AutoRule_Listview.GetSelectedIndexes().split(',')[0]);
    var CIndex = pSelectedIndex;
    var NIndex;
    var Rtnval = "N";
    var RowDownCheck;

    NIndex = pSelectedIndex + 1;
    if (NIndex < pTotalRowsLen) {
        RowDownCheck = getNodeText(pTotalRows[NIndex].cells[0]);

        setNodeText(pTotalRows[NIndex].childNodes[0],getNodeText(pTotalRows[CIndex].cells[0]));
        pTotalRows[NIndex].setAttribute("DATA3", getNodeText(pTotalRows[CIndex].cells[0]));
        setNodeText(pTotalRows[CIndex].childNodes[0],RowDownCheck);
        pTotalRows[CIndex].setAttribute("DATA3", RowDownCheck);
        
        Rtnval = "Y";
    }
    if (Rtnval == "Y")
        AutoRule_Listview.RowMoveDown();
}

function Del_onclick() {
    var AutoRule_Listview = new ListView();
    AutoRule_Listview.LoadFromID("lvtAutoRule");
    var selRow = AutoRule_Listview.GetSelectedRows();
    if (selRow.length == 0) {
        alert(strLang1109);
        return;
    }

    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvtAutoRule");

        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);

        var RowDelCheck;
        var Rtnval = "N";
        TIndex = pTotalRows.length;
        NIndex = pSelectedIndex;

        var pDelRowAutoRuleGuid = GetAttribute(pTotalRows[NIndex], "DATA4");

        for (i = NIndex; i < TIndex; i++) {
            var Marke = "";
            if (CrossYN()) {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]);
                setNodeText(pTotalRows[i].childNodes[0] , Marke + Number(RowDelCheck - 1));
                pTotalRows[i].setAttribute("DATA3", Number(RowDelCheck - 1).toString());
            }
            else {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]);
                setNodeText(pTotalRows[i].childNodes[0],Marke + Number(RowDelCheck - 1));
                pTotalRows[i].setAttribute("DATA3", Number(RowDelCheck - 1).toString());
            }

            Rtnval = "Y";
        }

        if (Rtnval == "Y") {
            var selIdx = GetAttribute(pAPRLINE.GetSelectedRows()[0], "id");
            pAPRLINE.DeleteRow(selIdx);


            var AprRuleLineXML = loadXMLString(bodyForm.hidAprRuleLine.value);


            if (pDelRowAutoRuleGuid != "") {
                for (var i = GetElementsByTagName(AprRuleLineXML, "ROW").length - 1; i > -1 ; i--) {
                    if (getNodeText(GetElementsByTagName(AprRuleLineXML, "AUTORULEGUID")[i]) == pDelRowAutoRuleGuid) {
                        AprRuleLineXML.documentElement.removeChild(GetElementsByTagName(AprRuleLineXML, "ROW")[i]);
                    }
                }
            }

            bodyForm.hidAprRuleLine.value = getXmlString(AprRuleLineXML);
            InitAprLineListXML();
            document.getElementById("DIVAPRLINE").style.display = "NONE";
        }
    } catch (e) {
        alert("Del_onclick :: " + e.description);
    }
}


function Del_onclick() {
    var AutoRule_Listview = new ListView();
    AutoRule_Listview.LoadFromID("lvtAutoRule");
    var selRow = AutoRule_Listview.GetSelectedRows();
    if (selRow.length == 0) {
        alert(strLang1109);
        return;
    }

    try {
        var pAPRLINE = new ListView();
        pAPRLINE.LoadFromID("lvtAutoRule");
        var pTotalRows = pAPRLINE.GetDataRows();
        var pSelectedIndex = Number(pAPRLINE.GetSelectedIndexes().split(',')[0]);
        var RowDelCheck;
        var Rtnval = "N";
        TIndex = pTotalRows.length;
        NIndex = pSelectedIndex;

        var pDelRowAutoRuleGuid = GetAttribute(pTotalRows[NIndex], "DATA4");

        for (i = NIndex; i < TIndex; i++) {
            var Marke = "";
            if (CrossYN()) {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]);
                setNodeText(pTotalRows[i].childNodes[0] , Marke + Number(RowDelCheck - 1));
                pTotalRows[i].setAttribute("DATA3", Number(RowDelCheck - 1).toString());
            }
            else {
                RowDelCheck = getNodeText(pTotalRows[i].cells[0]);
                setNodeText(pTotalRows[i].childNodes[0],Marke + Number(RowDelCheck - 1));
                pTotalRows[i].setAttribute("DATA3", Number(RowDelCheck - 1).toString());
            }

            Rtnval = "Y";
        }

        if (Rtnval == "Y") {
            var selIdx = GetAttribute(pAPRLINE.GetSelectedRows()[0], "id");
            pAPRLINE.DeleteRow(selIdx);


            var AprRuleLineXML = loadXMLString(bodyForm.hidAprRuleLine.value);


            if (pDelRowAutoRuleGuid != "") {
                for (var i = GetElementsByTagName(AprRuleLineXML, "ROW").length - 1; i > -1 ; i--) {
                    if (getNodeText(GetElementsByTagName(AprRuleLineXML, "AUTORULEGUID")[i]) == pDelRowAutoRuleGuid) {
                        AprRuleLineXML.documentElement.removeChild(GetElementsByTagName(AprRuleLineXML, "ROW")[i]);
                    }
                }
            }

            bodyForm.hidAprRuleLine.value = getXmlString(AprRuleLineXML);
            InitAprLineListXML();
            document.getElementById("DIVAPRLINE").style.display = "NONE";
        }
    } catch (e) {
        alert("Del_onclick :: " + e.description);
    }
}