

function ChangeTab(obj) {
    var pSelectTab = obj.getAttribute("divname");
    switch (pSelectTab) {
        case "ApvForm_div1":    
            if (document.getElementById("ApvForm_content1").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content7").style.display = "none";
                document.getElementById("ApvForm_content8").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
                document.getElementById("iframe_ApvReForm").style.display = "none";
            }
            break;
        case "ApvForm_div2":    
            if (document.getElementById("ApvForm_content2").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content7").style.display = "none";
                document.getElementById("ApvForm_content8").style.display = "none";
                document.getElementById("TForm").style.height = "800px";
                document.getElementById("TForm").style.display = "";
                document.getElementById("iframe_ApvReForm").style.display = "none";
            }
            break;
        case "ApvForm_div3":    
            if (document.getElementById("ApvForm_content3").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content7").style.display = "none";
                document.getElementById("ApvForm_content8").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
                document.getElementById("iframe_ApvReForm").style.display = "none";
            }
            break;
        case "ApvForm_div4":    
            break;
        case "ApvForm_div5":    
            if (document.getElementById("ApvForm_content5").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content7").style.display = "none";
                document.getElementById("ApvForm_content8").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
                document.getElementById("iframe_ApvReForm").style.display = "none";
            }
            break;

        case "ApvForm_div6":    
            if (document.getElementById("ApvForm_content6").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "";
                document.getElementById("ApvForm_content7").style.display = "none";
                document.getElementById("ApvForm_content8").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
                document.getElementById("iframe_ApvReForm").style.display = "none";
            }
            break;
        case "ApvForm_div7":
            if (document.getElementById("ApvForm_content7").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content7").style.display = "";
                document.getElementById("ApvForm_content8").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
                document.getElementById("iframe_ApvReForm").style.display = "";
            }
            break;
        case "ApvForm_div8":
            if (document.getElementById("ApvForm_content8").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content7").style.display = "none";
                document.getElementById("ApvForm_content8").style.display = "";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
                document.getElementById("iframe_ApvReForm").style.display = "none";
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


function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/admin/ezApproval/ezAprOpinion.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/admin/ezApproval/ezAprAlert.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

var xmlhttp = createXMLHttpRequest();
function SaveFormInfo() {    
    var xmlRtn = createXmlDom();

    var arrFormInfo = MakeFormInfoXML();
    if (arrFormInfo[0] == "TRUE") {
        formInfo = arrFormInfo[1];
    }
    else {
        OpenAlertUI(arrFormInfo[2]);
        document.getElementById("1tab1").click();
        return;
    }

    
    var arrFormMHT = MakeFormMHTXML();
    if (arrFormMHT[0] == "TRUE") {
        formMHT = arrFormMHT[1];
    }
    else {
        OpenAlertUI(arrFormMHT[2]);
        document.getElementById("1tab2").click();
        return;
    }

    //2015.1.20 FormBuilder
    if (useReform && document.getElementById("setFormBuilder").checked)
    {
        var arrReFormMHT = MakeReFormMHTXML();
        if (arrReFormMHT[0] == "TRUE") {
            reformMHT = arrReFormMHT[1];
        }
        else {
            OpenAlertUI(arrReFormMHT[2]);
            document.getElementById("1tab7").click();
            return;
        }
    }

    
    var arrFormConn = "";
    arrFormConn = MakeFormConnXML();
    if (arrFormConn[0] == "TRUE") {
        if (arrFormConn[1] != "") { 
            formConn = arrFormConn[1];
        }
    }
    else {
        OpenAlertUI(arrFormConn[2]);
        document.getElementById("1tab3").click();
        return;
    }
       
    var arrFormAutoRule = MakeFormAutoRuleXML();
    if (arrFormAutoRule[0] == "TRUE") {
        formAutoRule = arrFormAutoRule[1];           
        formAutoRuleLine = arrFormAutoRule[2];
    }
    else {
        formAutoRule = "";
        formAutoRuleLine = "";
    }
   
    
    var arrFormRecevGroup = MakeFormRecevGroupXML();
    if (arrFormRecevGroup[0] == "TRUE") {
        formRecevGroup = arrFormRecevGroup[1];
    }
    else {
        OpenAlertUI(arrFormRecevGroup[2]);
        document.getElementById("1tab5").click();
        return;
    }

    //2015.1.20 FormBuilder
    if (setFormBuilder.checked) {
        formBuilder = "Y";
        formBuilderFunction = txt_reformFunction.innerText;
    }
    else {
        formBuilder = "N";
        formBuilderFunction = "";
    }
    
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/admin/ezApproval/formSaveReform.do",
		data : {
			companyID  : companyID,
			formContID : contID,
			formID     : formID,
			formInfo   : formInfo,
			formMHT    : formMHT,
			reformMHT  : reformMHT,
			formConn   : formConn,
			formAutoRule     : formAutoRule,
			formAutoRuleLine : formAutoRuleLine,
			formRecevGroup   : formRecevGroup,
			formBuilder      : formBuilder,
			formBuilderFunction : formBuilderFunction
		},
		success: function(text){
			SaveFormInfo_after(text);
		}
	});
}

function MakeFormInfoXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (tbFormName.value.replace(/ /gi, "") == "") {
        pDataCheck = false;
        pErrorMsg = strLang607;
    }

    if (setAutoItemCode.checked && (tbItemCode.value == "" || tbItemName.value == "")) {
        pDataCheck = false;
        if (pErrorMsg == "") {
            pErrorMsg = strLang608;
        }
        else {
            pErrorMsg = pErrorMsg + "<br>" + strLang608;
        }
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
    createNodeAndInsertText(xmlpara, objNode, "FormName", tbFormName.value); 
    createNodeAndInsertText(xmlpara, objNode, "FormName2", tbFormName2.value); 
    createNodeAndInsertText(xmlpara, objNode, "FormDescript", tbDescript.value); 
    createNodeAndInsertText(xmlpara, objNode, "FormKind", selFormKind.value); 

    if (setAutoItemCode.checked)
        createNodeAndInsertText(xmlpara, objNode, "USEFLAG", "Y"); 
    else
        createNodeAndInsertText(xmlpara, objNode, "USEFLAG", "N"); 

    //createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", keepperiod.options(keepperiod.selectedIndex).innerText); 
    //createNodeAndInsertText(xmlpara, objNode, "KEEPPERIODCODE", keepperiod.value);
    createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", GetSelectText("keepperiod"));
    createNodeAndInsertText(xmlpara, objNode, "KEEPPERIODCODE", GetSelectVal("keepperiod"));
    createNodeAndInsertText(xmlpara, objNode, "SECURITYLEVEL", securitylevel.value); 
    createNodeAndInsertText(xmlpara, objNode, "ISPUBLIC", isPublic.value); 
    createNodeAndInsertText(xmlpara, objNode, "TBITEMCODE", tbItemCode.value); 
    createNodeAndInsertText(xmlpara, objNode, "TBITEMNAME", tbItemName.value); 
    createNodeAndInsertText(xmlpara, objNode, "TBITEMNAME2", tbItemName2.value); 
    return xmlpara.xml;
}

function MakeFormMHTXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (pzFormProc.editor.DOM.body.innerText.replace(/ /gi, "") == "") {
        pDataCheck = false;
        pErrorMsg = strLang621;
    }

    if (pzFormProc.editor.DOM.all("body") != null) {
        if (typeof (pzFormProc.editor.DOM.all("body").length) != "undefined") {
            if (pzFormProc.editor.DOM.all("body").length > 1) {
                pDataCheck = false;
                pErrorMsg = strLang609;
            }
        }
    }
    else {
        pDataCheck = false;
        pErrorMsg = strLang610;
    }

    if (pzFormProc.editor.DOM.all("doctitle") != null) {
        if (typeof (pzFormProc.editor.DOM.all("doctitle").length) != "undefined") {
            if (pzFormProc.editor.DOM.all("doctitle").length > 1) {
                pDataCheck = false;
                pErrorMsg = strLang611;
            }
        }
    }
    else {
        if (pzFormProc.editor.DOM.body.getAttribute("doctitlefield") == null) {
            pDataCheck = false;
            pErrorMsg = strLang612;
        }
        else if (pzFormProc.editor.DOM.body.getAttribute("doctitlefield") == "") {
            pDataCheck = false;
            pErrorMsg = strLang612;
        }
    }

    if (pDataCheck) {
        retValue[0] = "TRUE";
        retValue[1] = MakeFormMHTXML_Detail();
        retValue[2] = "";
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = pErrorMsg;
    }
    return retValue;
}

function MakeFormMHTXML_Detail() {
    if (beforeHTML != pzFormProc.editor.DOM.body.outerHTML) {
        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "FORMMHT");
        createNodeAndInsertText(xmlpara, objNode, "FormData", pzFormProc.DocumentHTML); 
        return xmlpara.xml;
    }
    else {
        return "";
    }
}

function MakeFormConnXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (txt_OpinionContent.innerText.replace(/\r\n/g, "").replace(/ /g, "") != "") {
        try {
            var xmldom = createXmlDom();
            xmldom = loadXMLString("<CONNINFO>\n" + txt_OpinionContent.innerText + "\n</CONNINFO>");

            if (xmldom.getElementsByTagName("conn").length == 0) {
                
                pDataCheck = false;
                pErrorMsg = strLang613;
            }
            else {
                var pConnArray = new Array();
                var pCheck = true;
                for (var i = 0; i < xmldom.getElementsByTagName("conn").length; i++) {
                    pCheck = true;
                    if (xmldom.getElementsByTagName("conn")[i].getAttribute("processidx") == null) { pCheck = false; }
                    if (xmldom.getElementsByTagName("conn")[i].getAttribute("processtime") == null) { pCheck = false; }
                    if (xmldom.getElementsByTagName("conn")[i].selectSingleNode("connstring").getAttribute("flag") == null) { pCheck = false; }
                    if (xmldom.getElementsByTagName("conn")[i].selectSingleNode("connstring").text == null) { pCheck = false; }
                    if (xmldom.getElementsByTagName("conn")[i].selectSingleNode("query").getAttribute("qtype") == null) { pCheck = false; }
                    if (xmldom.getElementsByTagName("conn")[i].selectSingleNode("query").text == null) { pCheck = false; }
                    if (xmldom.getElementsByTagName("conn")[i].selectSingleNode("keys") == null) { pCheck = false; }

                    if (pCheck) {
                        pConnArray[i] = xmldom.getElementsByTagName("conn")[i].getAttribute("processidx") + xmldom.getElementsByTagName("conn")[i].getAttribute("processtime");
                    }
                    else {
                        
                        pDataCheck = false;
                        pErrorMsg = strLang614;
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
                            pErrorMsg = strLang615;
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
    createNodeAndInsertCDataText(xmlpara, objNode, "CONNINFO", MakeXMLString(txt_OpinionContent.innerText)); 
    return xmlpara.xml;
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
        if (selRow.length == 1 && GetAttribute(selRow[0], "id").indexOf("_TR_noItems") > -1)
            return;

        for (i = 0; i < selRow.length; i++) {
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, objNode2, "DATA", "");
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTID", GetAttribute(selRow[i], "data1"));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTSN", (i + 1));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "USERID", GetAttribute(selRow[i], "data2"));
        }
    }
    return xmlpara.xml;
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
    SaveFormInfo();
}

//2015.1.20 FormBuilder
function MakeReFormMHTXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();
    //if (iframe_ApvReForm.pzFormProc_reform.editor.DOM.body.innerText.replace(/ /gi, "") == "") {
    //    pDataCheck = false;
    //    pErrorMsg = strLang621;
    //}

    //if (iframe_ApvReForm.pzFormProc_reform.editor.DOM.all("body") != null) {
    //    if (typeof (pzFormProc.editor.DOM.all("body").length) != "undefined") {
    //        if (pzFormProc.editor.DOM.all("body").length > 1) {
    //            pDataCheck = false;
    //            pErrorMsg = strLang609;
    //        }
    //    }
    //}
    //else {
    //    pDataCheck = false;
    //    pErrorMsg = strLang610;
    //}

    //if (pzFormProc.editor.DOM.all("doctitle") != null) {
    //    if (typeof (pzFormProc.editor.DOM.all("doctitle").length) != "undefined") {
    //        if (pzFormProc.editor.DOM.all("doctitle").length > 1) {
    //            pDataCheck = false;
    //            pErrorMsg = strLang611;
    //        }
    //    }
    //}
    //else {
    //    if (pzFormProc.editor.DOM.body.getAttribute("doctitlefield") == null) {
    //        pDataCheck = false;
    //        pErrorMsg = strLang612;
    //    }
    //    else if (pzFormProc.editor.DOM.body.getAttribute("doctitlefield") == "") {
    //        pDataCheck = false;
    //        pErrorMsg = strLang612;
    //    }
    //}

    if (pDataCheck) {
        retValue[0] = "TRUE";
        retValue[1] = MakeReFormMHTXML_Detail();
        retValue[2] = "";
    }
    else {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = pErrorMsg;
    }
    return retValue;
}

function MakeReFormMHTXML_Detail() {
    if (beforeHTML != iframe_ApvReForm.pzFormProc_reform.editor.DOM.body.outerHTML) {
        iframe_ApvReForm.processForSaving();

        var xmlpara = createXmlDom();
        var objNode;
        createNodeInsert(xmlpara, objNode, "REFORMMHT");
        createNodeAndInsertText(xmlpara, objNode, "FormData", iframe_ApvReForm.pzFormProc_reform.DocumentHTML);
        return xmlpara.xml;
    }
    else {
        return "";
    }
}

function btn_reformSave_onclick() {
    var rtnVal = new Array();
    var pInformationContent = "변경한 함수을 반영하시겠습니까?";
    var Ans = OpenInformationUI(pInformationContent);
    if (Ans) {
        rtnVal[0] = "TRUE";
        rtnVal[1] = "<FORMBUILDERINFO>\n" + txt_reformFunction.innerText + "\n</FORMBUILDERINFO>";
    }
}
