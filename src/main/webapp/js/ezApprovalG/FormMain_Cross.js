function ChangeTab(obj) {
    var pSelectTab = GetAttribute(obj,"divname");
    switch (pSelectTab) {
        case "ApvForm_div1":
            if (document.getElementById("ApvForm_content1").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
            }
            break;
        case "ApvForm_div2":
            if (document.getElementById("ApvForm_content2").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "770px";
            }
            break;
        case "ApvForm_div3":
            if (document.getElementById("ApvForm_content3").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
            }
            break;
        case "ApvForm_div4":
            if (document.getElementById("ApvForm_content5").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
            }
            break;
        case "ApvForm_div5":
            if (document.getElementById("ApvForm_content5").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "";
                document.getElementById("TForm").style.height = "0px";
            }
            break;
    }
}

var Tab1_SelectID = "";
function Tab1_MouserOver(obj) {
    obj.className = "tabover";
}

function Tab1_MouserOut(obj) {
    if (Tab1_SelectID != obj.id)
        obj.className = "";
}

function Tab1_MouseClick(obj) {
    obj.className = "tabon";
    if (obj.id != Tab1_SelectID) {
        if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
            document.getElementById(Tab1_SelectID).className = "";

        obj.className = "tabon";
        Tab1_SelectID = obj.id;
        ChangeTab(obj);
    }
}

function Tab1_NewTabIni(pTabNodeID) {
    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
        if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
            if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
                document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
                document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
                document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;

                if (i == 0) {
                    document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
                    Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
                }

            }
        }
    }
}

var xmlhttp = createXMLHttpRequest();
function SaveFormInfo() {
    var xmlpara = createXmlDom();
    var xmlRtn = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
    createNodeAndInsertText(xmlpara, objNode, "FORMCONTID", contID);
    createNodeAndInsertText(xmlpara, objNode, "FORMID", formID);

    var arrFormInfo = MakeFormInfoXML();
    if (arrFormInfo[0] == "TRUE") {
        createNodeAndInsertText(xmlpara, objNode, "FORMINFO", arrFormInfo[1]);
    }
    else {
        OpenAlertUI(arrFormInfo[2]);
        document.getElementById("1tab1").click();
        return;
    }


    var arrFormMHT = MakeFormMHTXML();
    if (arrFormMHT[0] == "TRUE") {
        createNodeAndInsertText(xmlpara, objNode, "FORMMHT", arrFormMHT[1]);
    }
    else {
        OpenAlertUI(arrFormMHT[2]);
        document.getElementById("1tab2").click();
        return;
    }

    var arrFormConn = "";
    arrFormConn = MakeFormConnXML();
    if (arrFormConn[0] == "TRUE") {
        if (arrFormConn[1] != "") {
            createNodeAndInsertText(xmlpara, objNode, "FORMCONN", arrFormConn[1]);
        }
    }
    else {
        OpenAlertUI(arrFormConn[2]);
        document.getElementById("1tab3").click();
        return;
    }

    var arrFormWorkFlow = "";
    arrFormWorkFlow = MakeFormWorkFlow();
    if (arrFormWorkFlow[0] == "TRUE") {
        if (arrFormWorkFlow[1] != "") {
            createNodeAndInsertText(xmlpara, objNode, "FORMWORKFLOW", arrFormWorkFlow[1]);
        }
    }
    else {
        OpenAlertUI(arrFormWorkFlow[2]);
        document.getElementById("1tab4").click();
        return;
    }

    var arrFormRecevGroup = MakeFormRecevGroupXML();
    if (arrFormRecevGroup[0] == "TRUE") {
        createNodeAndInsertText(xmlpara, objNode, "FORMRECEVGROUP", arrFormRecevGroup[1]);
    }
    else {
        OpenAlertUI(arrFormRecevGroup[2]);
        document.getElementById("1tab5").click();
        return;
    }    

    if(pEditorType == "HWP")
        xmlhttp.open("POST", "/myoffice/ezApprovalG/manage/FormMaker/aspx/FormSaveHwp.aspx", true);
    else
        xmlhttp.open("POST", "/myoffice/ezApprovalG/manage/FormMaker/aspx/FormSave.aspx", true);

    xmlhttp.onreadystatechange = SaveFormInfo_after;
    xmlhttp.send(xmlpara);
}

function MakeFormInfoXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (document.getElementById("tbFormName").value.replace(/ /gi, "") == "") {
        pDataCheck = false;
        pErrorMsg = strLang1010;
    }

    if (pDataCheck) {
        retValue[0] = "TRUE";
        retValue[1] = MakeFormInfoXML_Detail();
        retValue[2] = "";
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = pErrorMsg;
    }
    return retValue;
}

function MakeFormInfoXML_Detail() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "FORMINFO");
    createNodeAndInsertText(xmlpara, objNode, "FormName", document.getElementById("tbFormName").value); 
    createNodeAndInsertText(xmlpara, objNode, "FormName2", document.getElementById("tbFormName2").value);
    createNodeAndInsertText(xmlpara, objNode, "FormDescript", document.getElementById("tbDescript").value);
    createNodeAndInsertText(xmlpara, objNode, "FormKind", document.getElementById("selFormKind").value);

    if (document.getElementById('setConnFlag').checked)
        createNodeAndInsertText(xmlpara, objNode, "ConnFlag", "Y");
    else
        createNodeAndInsertText(xmlpara, objNode, "ConnFlag", "N");

    return getXmlString(xmlpara.childNodes[0]);
}

function MakeFormMHTXML() {
    var retValue = new Array();
    if (pEditorType == "HWP") {
        retValue[0] = "TRUE";
        retValue[1] = message.HWP_GetCloneData();
        retValue[2] = "";
        return retValue;
    }

    if (message.FormInfoCheck("null"))
    {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = strLang1024;
        return retValue;
    }

    if (message.FormInfoCheck("body") != 0) {
        if (message.FormInfoCheck("body") > 1) {
            retValue[0] = "FALSE";
            retValue[1] = "";
            retValue[2] = strLang1012;
            return retValue;
        }        
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = strLang1013;
        return retValue;
    }

    if (message.FormInfoCheck("doctitle") != 0) {
        if (message.FormInfoCheck("doctitle") > 1) {
            retValue[0] = "FALSE";
            retValue[1] = "";
            retValue[2] = strLang1014;
            return retValue;
        }
    }
    else {
        if (message.FormInfoCheck("doctitlefield") == null || message.FormInfoCheck("doctitlefield") == "") {
            retValue[0] = "FALSE";
            retValue[1] = "";
            retValue[2] = strLang1015;
            return retValue;
        }        
    }
    retValue[0] = "TRUE";
    retValue[1] = MakeFormMHTXML_Detail();
    retValue[2] = "";
    return retValue;
}

function MakeFormMHTXML_Detail() {
        var HTML = document.createElement("HTML");
        var HEAD = document.createElement("HEAD");
        var META = document.createElement("META");
        META.content = "text/html; charset=utf-8";
        META.httpEquiv = "Content-Type";
        var META2 = document.createElement("META");
        META2.name = "GENERATOR";
        META2.content = "MSHTML 10.00.9200.16721";
        var META3 = document.createElement("META");
        META3.httpEquiv = "X-UA-Compatible";
        META3.content = "IE=edge";
        HEAD.appendChild(META);
        HEAD.appendChild(META2);
        HEAD.appendChild(META3);
        HTML.appendChild(HEAD);

        var BODY = document.createElement("BODY");
        var ConnVal = "";
        var XMLInfo = "";
        if (txt_OpinionContent.value != "") {
            ConnVal = "<CONNINFO>\n" + txt_OpinionContent.value + "\n</CONNINFO>";
            XMLInfo = "<xml id='conn' style='display:none'>" + ConnVal + "</xml>\n";
        }

        var WorkVal = "";
        if (txt_OpinionContent1.value != "" || txt_OpinionContent2.value != "") {
            WorkVal += "\n<WORKFLOW>\n<VALIDATIONS>\n" + txt_OpinionContent1.value + "\n</VALIDATIONS>\n<STATUS>\n" + txt_OpinionContent2.value + "\n</STATUS>\n</WORKFLOW>\n";
            XMLInfo += "<xml id='WORKFLOW' style='display:none;'>" + WorkVal + "</xml>";
        }

        var Div = document.createElement("DIV");
        Div.innerHTML = message.GetEditorContent();

        if (message.GetEditorContent().indexOf("BodyContent") > -1)
            BODY.innerHTML = ReplaceAll(ReplaceAll(ReplaceAll(XMLInfo, /\r\n/g, "<br>"), /\n/g, "<br>"), /\r/g, "<br>") + Div.innerHTML;
        else {
            Div.id = "BodyContent";
            BODY.innerHTML = ReplaceAll(ReplaceAll(ReplaceAll(XMLInfo, /\r\n/g, "<br>"), /\n/g, "<br>"), /\r/g, "<br>") + Div.outerHTML;
        }
        HTML.appendChild(BODY);
        return HTML.innerHTML;
}

function MakeFormConnXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (getNodeText(txt_OpinionContent).replace(/\r\n/g, "").replace(/ /g, "") != "" && document.getElementById('setConnFlag').checked) {
        try {
            var xmldom = createXmlDom();
            xmldom = loadXMLString("<CONNINFO>\n" + getNodeText(txt_OpinionContent) + "\n</CONNINFO>");

            if (xmldom.getElementsByTagName("conn").length == 0) {
                pDataCheck = false;
                pErrorMsg = strLang1016;
            }
            else {
                var pConnArray = new Array();
                var pCheck = true;
                for (var i = 0; i < xmldom.getElementsByTagName("conn").length; i++) {
                    pCheck = true;
                    if (GetAttribute(xmldom.getElementsByTagName("conn")[i], "processidx") == null) { pCheck = false; }
                    if (GetAttribute(xmldom.getElementsByTagName("conn")[i], "processtime") == null) { pCheck = false; }
                    if (GetAttribute(SelectSingleNode(xmldom.getElementsByTagName("conn")[i], "connstring"), "flag") == null) { pCheck = false; }
                    if (getNodeText(SelectSingleNode(xmldom.getElementsByTagName("conn")[i], "connstring")) == null) { pCheck = false; }
                    if (GetAttribute(SelectSingleNode(xmldom.getElementsByTagName("conn")[i], "query"), "qtype") == null) { pCheck = false; }
                    if (getNodeText(SelectSingleNode(xmldom.getElementsByTagName("conn")[i], "query")) == null) { pCheck = false; }
                    if (SelectSingleNode(xmldom.getElementsByTagName("conn")[i], "keys") == null) { pCheck = false; }
                  
                    if (pCheck) {
                        pConnArray[i] = GetAttribute(xmldom.getElementsByTagName("conn")[i],"processidx") + GetAttribute(xmldom.getElementsByTagName("conn")[i],"processtime");
                    }
                    else {
                        
                        pDataCheck = false;
                        pErrorMsg = strLang1017;
                        break;
                    }
                }

                if (pDataCheck) {
                    var results = new Array();
                    for (var j = 0; j < pConnArray.length; j++) {
                        var key = pConnArray[j].toString(); 
                        if (!results[key]) {
                            results[key] = 1
                        } else {
                            results[key] = results[key] + 1;
                        }
                    }

                    var str = ""; 
                    for (var j in results) {
                        if (results[j] > 1) {
                            
                            pDataCheck = false;
                            pErrorMsg = strLang1018;
                            break;
                        }
                    }
                }
            }
        }
        catch (e) {
            pDataCheck = false;
            pErrorMsg = e.message;
        }
    }

    if (pDataCheck) {
        retValue[0] = "TRUE";
        retValue[1] = MakeFormConnXML_Detail();
        retValue[2] = "";
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = pErrorMsg;
    }

    return retValue;
}

function MakeFormConnXML_Detail() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "CONNXML");    
    createNodeAndInsertCDataText(xmlpara, objNode, "CONNINFO", MakeXMLString(txt_OpinionContent.value)); 
    return getXmlString(xmlpara.childNodes[0]);
}

function MakeFormWorkFlow() {
    var retValue = new Array();

    try {
        if (txt_OpinionContent1.value.replace(/\r\n/g, "").replace(/ /g, "") != "" || txt_OpinionContent2.value.replace(/\r\n/g, "").replace(/ /g, "")) {
            retValue[0] = "TRUE";
            retValue[1] = MakeFormWorkFlow_Detail();
        }
        else {
            retValue[0] = "TRUE";
            retValue[1] = "";
            retValue[2] = "";
        }
    } catch (e) {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = e.message;
    }
    return retValue;
}

function MakeFormWorkFlow_Detail() {
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "WORKFLOW");

    var workflow = "<WORKFLOW>\n<VALIDATIONS>\n" + txt_OpinionContent1.innerText + "\n</VALIDATIONS>\n<STATUS>\n" + txt_OpinionContent2.innerText + "\n</STATUS>\n</WORKFLOW>";
    createNodeAndInsertCDataText(xmlpara, objNode, "WORKFLOWINFO", MakeXMLString(workflow));
    return getXmlString(xmlpara.childNodes[0]);
}

function MakeFormRecevGroupXML() {
    var pDataCheck = false;
    var pErrorMsg = "";
    var retValue = new Array();

    var lvtFormView = new ListView();
    lvtFormView.LoadFromID("lvtForm");

    var selRow = lvtFormView.GetDataRows();

    
        pDataCheck = true;

    if (pDataCheck) {
        retValue[0] = "TRUE";
        retValue[1] = MakeFormRecevGroupXML_Detail();
        retValue[2] = "";
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = pErrorMsg;
    }
    return retValue;
}

function MakeFormRecevGroupXML_Detail() {
    var xmlpara = createXmlDom();

    var objRoot, objNode, subNode, objNode2;
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
    var objNode = createNodeAndInsertText(xmlpara, objRoot, "DATAS", "");

    var lvtFormView = new ListView();
    lvtFormView.LoadFromID("lvtForm");

    var selRow = lvtFormView.GetDataRows();
    if (selRow.length > 0) {
        if (selRow.length == 1 && (GetAttribute(selRow[0], "id") != null ?GetAttribute(selRow[0], "id").indexOf("_TR_noItems") : -1) > -1)
            return;

        for (i = 0; i < selRow.length; i++) {
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, objNode2, "DATA", "");
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTID", GetAttribute(selRow[i], "data1"));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTSN", (i + 1));
        }
    }
    return getXmlString(xmlpara.childNodes[0]);
}

function btnClose_onclick() {
    if(formID == "")
        var pAlertContent = strLang619;
    else
        var pAlertContent = strLang620;

    var Rtnval = OpenInformationUI(pAlertContent);
    var para = new Array();
    if (Rtnval) {
        para[0] = Rtnval;
        window.returnValue = para;
        window.close();
    }
    else
        return;
}

function btnSave_onclick() {
    try{
        message.View_CellProperty2();
    } catch (e) { }
    SaveFormInfo();
}
