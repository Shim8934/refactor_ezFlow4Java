// 탭관련 함수 시작 ========================================================================================
// =========================================================================================================
function ChangeTab(obj) {
    var pSelectTab = obj.getAttribute("divname");
    switch (pSelectTab) {
        case "ApvForm_div1":    // 양식정보
            if (document.getElementById("ApvForm_content1").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
            }
            break;
        case "ApvForm_div2":    // 양식 작성
            if (document.getElementById("ApvForm_content2").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "800px";
                document.getElementById("TForm").style.display = "";
            }
            break;
        case "ApvForm_div3":    // 연동정보
            if (document.getElementById("ApvForm_content3").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
            }
            break;
        case "ApvForm_div4":    // Workflow
        	if (document.getElementById("ApvForm_content4").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
        	}
            break;
        case "ApvForm_div5":    // 고정수신처
            if (document.getElementById("ApvForm_content5").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "";
                document.getElementById("TForm").style.height = "0px";
                document.getElementById("TForm").style.display = "none";
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
// =========================================================================================================
// 탭관련 함수 종료 ========================================================================================
function OpenInformationUI(pInformationContent) {
    var parameter = pInformationContent;
    var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal;
}

function OpenAlertUI(pAlertContent) {
	//TODO 이효진 showModalDialog 크로스버전에서 실행안됨 -> open으로 수정
    /*var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);*/
	ezapralert_cross_dialogArguments[0] = pAlertContent;
	var url = "/ezApprovalG/ezAprAlert.do";
	window.open(url, "", GetOpenWindowfeature(330,205));
	
	
}

var xmlhttp = createXMLHttpRequest();
function SaveFormInfo() {
    var xmlRtn = createXmlDom();

    // 양식 정보 XML로 가져오기
    var arrFormInfo = MakeFormInfoXML();    
    if (arrFormInfo[0] == "TRUE") {
        formInfo = arrFormInfo[1];
    }
    else {
        OpenAlertUI(arrFormInfo[2]);
        document.getElementById("1tab1").click();
        return;
    }

    // 작성양식 XML로 가져오기
    var arrFormMHT = MakeFormMHTXML();

    if (arrFormMHT[0] == "TRUE") {
        formMht = arrFormMHT[1];
    }
    else {
        OpenAlertUI(arrFormMHT[2]);
        document.getElementById("1tab2").click();
        return;
    }
    
    //// 연동정보 XML로 가져오기
    var arrFormConn = "";
    arrFormConn = MakeFormConnXML();
    if (arrFormConn[0] == "TRUE") {
        if (arrFormConn[1] != "") { // 빈값일 경우 수정 안된것이므로 처리 안함.
            formConn = arrFormConn[1];
        }
    }
    else {
        OpenAlertUI(arrFormConn[2]);
        document.getElementById("1tab3").click();
        return;
    }

    // Workflow정보 XML로 가져오기
    var arrFormWorkFlow = "";
    arrFormWorkFlow = MakeFormWorkFlow();
    if (arrFormWorkFlow[0] == "TRUE") {
        if (arrFormWorkFlow[1] != "") {
            formWorkFlow = arrFormWorkFlow[1];
        }
    }
    else {
        OpenAlertUI(arrFormWorkFlow[2]);
        document.getElementById("1tab4").click();
        return;
    }

    //// 고정수신처정보 XML로 가져오기
    var arrFormRecevGroup = MakeFormRecevGroupXML();
    if (arrFormRecevGroup[0] == "TRUE") {
    	formRecevGroup = arrFormRecevGroup[1];
    }
    else {
        OpenAlertUI(arrFormRecevGroup[2]);
        document.getElementById("1tab5").click();
        return;
    }
    
    $.ajax({
    	type : "POST",
    	async : false,
    	url : "/admin/ezApprovalG/formSave.do",
    	dataType : "text",
    	data : {
    		companyID  : companyID,
			formContID : contID,
			formID     : formID,
			formInfo   : formInfo,
			formMHT    : formMht,
			formConn   : formConn,
			formWorkFlow : formWorkFlow,
			formRecevGroup   : formRecevGroup
    	},
    	success : function (result) {
    		SaveFormInfo_after(result);
    	}
    	
    })
}

function MakeFormInfoXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (tbFormName.value.replace(/ /gi, "") == "") {
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
    createNodeAndInsertText(xmlpara, objNode, "FormName", tbFormName.value); // 양식명 (한글)
    createNodeAndInsertText(xmlpara, objNode, "FormName2", tbFormName2.value); // 양식명 (영어)
    createNodeAndInsertText(xmlpara, objNode, "FormDescript", tbDescript.value); // 양식설명
    createNodeAndInsertText(xmlpara, objNode, "FormKind", selFormKind.value); // 양식종류
    
    if (document.getElementById('setConnFlag').checked)
        createNodeAndInsertText(xmlpara, objNode, "ConnFlag", "Y"); // 연동양식 체크 
    else
        createNodeAndInsertText(xmlpara, objNode, "ConnFlag", "N");
    
    return getXmlString(xmlpara.childNodes[0]);
}

function MakeFormMHTXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (pzFormProc.editor.DOM.body.innerText.replace(/ /gi, "") == "") {
        pDataCheck = false;
        pErrorMsg = strLang1024;
    }

    if (pzFormProc.editor.DOM.all("body") != null) {
        if (typeof (pzFormProc.editor.DOM.all("body").length) != "undefined") {
            if (pzFormProc.editor.DOM.all("body").length > 1) {
                pDataCheck = false;
                pErrorMsg = strLang1012;
            }
        }
    }
    else {
        pDataCheck = false;
        pErrorMsg = strLang1013;
    }

    if (pzFormProc.editor.DOM.all("doctitle") != null) {
    	if (typeof (pzFormProc.editor.DOM.all("doctitle").length) != "undefined") {
        	if (pzFormProc.editor.DOM.all("doctitle").length > 1) {
                pDataCheck = false;
                pErrorMsg = strLang1014;
            }
        }
    }
    else {
    	if (GetAttribute(pzFormProc.editor.DOM.body,"doctitlefield") == null) {
            pDataCheck = false;
            pErrorMsg = strLang1015;
        }
    	else if (GetAttribute(pzFormProc.editor.DOM.body,"doctitlefield") == "") {
            pDataCheck = false;
            pErrorMsg = strLang1015;
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
        return pzFormProc.DocumentHTML;
    }
    else {
        return "";
    }
}

function MakeFormConnXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (getNodeText(txt_OpinionContent).replace(/\r\n/g, "").replace(/ /g, "") != "") {
        try {
            var xmldom = createXmlDom();
            xmldom = loadXMLString("<CONNINFO>\n" + getNodeText(txt_OpinionContent) + "\n</CONNINFO>");
            
            if (xmldom.getElementsByTagName("conn").length == 0) {
                // XML로 Parsing이 되며 conn설정이 있는지 확인.
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
                        // conn 설정의 각 필드설정이 정상인지 확인
                        pDataCheck = false;
                        pErrorMsg = strLang1017;
                        break;
                    }
                }

                if (pDataCheck) {
                    var results = new Array();
                    for (var j = 0; j < pConnArray.length; j++) {
                        var key = pConnArray[j].toString(); // make it an associative array
                        if (!results[key]) {
                            results[key] = 1;
                        } else {
                            results[key] = results[key] + 1;
                        }
                    }

                    var str = ""; // Display the results
                    for (var j in results) {
                        if (results[j] > 1) {
                            // 연동설정에 중복된 시점이 있는지 확인
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
    createNodeAndInsertCDataText(xmlpara, objNode, "CONNINFO", MakeXMLString(getNodeText(txt_OpinionContent))); 
    
    return getXmlString(xmlpara.childNodes[0]);
}

function MakeFormWorkFlow() {
    var retValue = new Array();

    try {
        retValue[0] = "TRUE";
        retValue[1] = MakeFormWorkFlow_Detail();
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

    var workflow = "<WORKFLOW>\n<VALIDATIONS>\n" + txt_OpinionContent1.value + "\n</VALIDATIONS>\n<STATUS>\n" + txt_OpinionContent2.value + "\n</STATUS>\n</WORKFLOW>";

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
    } else {
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
    	if (selRow.length == 1 && (GetAttribute(selRow[0], "id") != null ? GetAttribute(selRow[0], "id").indexOf("_TR_noItems") : -1) > -1) {
            return "";
        }
        
        for (var i = 0; i < selRow.length; i++) {
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, objNode2, "DATA", "");
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTID", GetAttribute(selRow[i], "data1"));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTSN", (i + 1));
        }
    }
    
    return getXmlString(xmlpara.childNodes[0]);
}

function btnClose_onclick() {
    if(formID == "")
        var pAlertContent = strLang1022;
    else
        var pAlertContent = strLang1023;

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
