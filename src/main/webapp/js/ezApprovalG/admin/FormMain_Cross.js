function ChangeTab(obj) {
    var pSelectTab = GetAttribute(obj, "divname");
    switch (pSelectTab) {
        case "ApvForm_div1":
            if (document.getElementById("ApvForm_content1").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
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
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
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
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
                document.getElementById("TForm").style.height = "0px";
            }
            break;
        case "ApvForm_div4":
            if (document.getElementById("ApvForm_content4").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
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
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
                document.getElementById("TForm").style.height = "0px";
            }
            break;

        case "ApvForm_div6":
            if (document.getElementById("ApvForm_content6").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
                document.getElementById("TForm").style.height = "0px";
            }
            break;
        // FormBuilder
        case "ApvForm_div7":
            if (document.getElementById("ApvForm_content7").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
                document.getElementById("TForm").style.height = "0px";
            }
            break;
        case "ApvForm_div8":
            if (document.getElementById("ApvForm_content8").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "";
                }
                
                document.getElementById("TForm").style.height = "0px";
            }
            break;           
        // FormBuilder end
        case "ApvForm_div9":  //양식 세부설정
            if (document.getElementById("ApvForm_content9").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "";
                document.getElementById("ApvForm_content10").style.display = "none";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }
                
                document.getElementById("TForm").style.height = "0px";
            }
            break;            
        case "ApvForm_div10":
            if (document.getElementById("ApvForm_content10").style.display == "none") {
                document.getElementById("ApvForm_content1").style.display = "none";
                document.getElementById("ApvForm_content2").style.display = "none";
                document.getElementById("ApvForm_content3").style.display = "none";
                document.getElementById("ApvForm_content4").style.display = "none";
                document.getElementById("ApvForm_content5").style.display = "none";
                document.getElementById("ApvForm_content6").style.display = "none";
                document.getElementById("ApvForm_content9").style.display = "none";
                document.getElementById("ApvForm_content10").style.display = "";
                
                if (useReform) {
                    document.getElementById("ApvForm_content7").style.display = "none";
                    document.getElementById("ApvForm_content8").style.display = "none";
                }

                
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

var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";

    if (CrossYN() && ext != 'hwp') {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    } else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}

var xmlhttp = createXMLHttpRequest();
function SaveFormInfo() {
    var xmlRtn = createXmlDom();
    
    //양식 정보 XML
    var arrFormInfo = MakeFormInfoXML();
    if (arrFormInfo[0] == "TRUE") {
        formInfo = arrFormInfo[1];
    } else {
        OpenAlertUI(arrFormInfo[2]);
        document.getElementById("1tab1").click();
        return;
    }
    
    //작성양식 XML
    var arrFormMHT = MakeFormMHTXML();
    if (arrFormMHT[0] == "TRUE") {
        formMHT = arrFormMHT[1];
    } else {
        OpenAlertUI(arrFormMHT[2]);
        document.getElementById("1tab2").click();
        return;
    }
    
    //연동정보 XML
    var arrFormConn = "";
    arrFormConn = MakeFormConnXML();
    if (arrFormConn[0] == "TRUE") {
        if (arrFormConn[1] != "") { 
            formConn = arrFormConn[1];
        }
    } else {
        OpenAlertUI(arrFormConn[2]);
        document.getElementById("1tab3").click();
        return;
    }

    //WorkFlow XML
    var arrFormWorkFlow = "";
    arrFormWorkFlow = MakeFormWorkFlow();
    if (arrFormWorkFlow[0] == "TRUE") {
        if (arrFormWorkFlow[1] != "") {
            formWorkFlow = arrFormWorkFlow[1];
        }
    } else {
        OpenAlertUI(arrFormWorkFlow[2]);
        document.getElementById("1tab4").click();
        return;
    }
    
    //자동분류 XML
    var arrFormAutoRule = MakeFormAutoRuleXML();
    if (arrFormAutoRule[0] == "TRUE") {
        formAutoRule = arrFormAutoRule[1];
        formAutoRuleLine = arrFormAutoRule[2];
    } else {
        formAutoRule = "";
        formAutoRuleLine = "";
    }
    
    //고정수신처정보 XML
    var arrFormRecevGroup = MakeFormRecevGroupXML();
    if (arrFormRecevGroup[0] == "TRUE") {
        formRecevGroup = arrFormRecevGroup[1];
    } else {
        OpenAlertUI(strLangCSJ02);
        document.getElementById("1tab5").click();
        return;
    }
    
    var url = "";
    var params = {
		companyID: companyID,
		formContID: contID,
		formID: formID,
		formInfo: formInfo,
		formMHT: formMHT,
		formConn: formConn,
		formAutoRule: formAutoRule,
		formAutoRuleLine: formAutoRuleLine,
		formRecevGroup: formRecevGroup
	}
    
    if(useEditor == "HWP") {
    	url = "/admin/ezApprovalG/formSaveHWP.do";
    } else {
    	url = "/admin/ezApprovalG/formSave.do";
    	
		// FormBuilder
		if (document.getElementById("reform-checkbox") && document.getElementById("reform-checkbox").checked) {
			iframe_ApvReForm.processForSaving();
			
			var reformBodyStr = iframe_ApvReForm.GetEditorContent();
			reformBodyStr = "<body>" + reformBodyStr + "</body>"
			
			params.reformMht = ConvertHTMLtoMHT(reformBodyStr)
			params.reformHtml = reformBodyStr;
			params.reformFunction = document.getElementById("txt_reformFunction").value;
			
			iframe_ApvReForm.processAfterSaving();
		}
    }
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : url,
		data : params,
		success: function(text){
			SaveFormInfo_after(text);
		}
	});
}

function SaveHWPFormInfo(hwpData) {
    var xmlRtn = createXmlDom();
    var formMHT = "";
    
    //양식 정보 XML
    var arrFormInfo = MakeFormInfoXML();
    if (arrFormInfo[0] == "TRUE") {
        formInfo = arrFormInfo[1];
    } else {
        OpenAlertUI(arrFormInfo[2]);
        document.getElementById("1tab1").click();
        return;
    }
    
    //연동정보 XML
    var arrFormConn = "";
    arrFormConn = MakeFormConnXML();
    if (arrFormConn[0] == "TRUE") {
        if (arrFormConn[1] != "") { 
            formConn = arrFormConn[1];
        }
    } else {
        OpenAlertUI(arrFormConn[2]);
        document.getElementById("1tab3").click();
        return;
    }

    //WorkFlow XML
    var arrFormWorkFlow = "";
    arrFormWorkFlow = MakeFormWorkFlow();
    if (arrFormWorkFlow[0] == "TRUE") {
        if (arrFormWorkFlow[1] != "") {
            formWorkFlow = arrFormWorkFlow[1];
        }
    } else {
        OpenAlertUI(arrFormWorkFlow[2]);
        document.getElementById("1tab4").click();
        return;
    }

    //작성양식 XML
    if(formID != "") {
        var arrFormMHT = MakeFormMHTXML(hwpData);
        if (arrFormMHT[0] == "TRUE") {
            formMHT = arrFormMHT[1];
        } else {
            OpenAlertUI(arrFormMHT[2]);
            document.getElementById("1tab2").click();
            return;
        }
    }
    
    //자동분류 XML
    var arrFormAutoRule = MakeFormAutoRuleXML();
    if (arrFormAutoRule[0] == "TRUE") {
        formAutoRule = arrFormAutoRule[1];
        formAutoRuleLine = arrFormAutoRule[2];
    } else {
        formAutoRule = "";
        formAutoRuleLine = "";
    }
    
    //고정수신처정보 XML
    var arrFormRecevGroup = MakeFormRecevGroupXML();
    if (arrFormRecevGroup[0] == "TRUE") {
        formRecevGroup = arrFormRecevGroup[1];
    } else {
        OpenAlertUI(strLangCSJ02);
        document.getElementById("1tab5").click();
        return;
    }
    
    var params = {
		companyID: companyID,
		formContID: contID,
		formID: formID,
		formInfo: formInfo,
		formMHT: formMHT,
		formConn: formConn,
		formAutoRule: formAutoRule,
		formAutoRuleLine: formAutoRuleLine,
		formRecevGroup: formRecevGroup
	}
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApprovalG/formSaveHWP.do",
		data : params,
		success: function(text){
			SaveFormInfo_after(text);
		}
	});
}

function MakeFormInfoXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    if (document.getElementById("tbFormName").value.replace(/ /gi, "") == "") {
        pDataCheck = false;
        pErrorMsg = strLang1010;
    }

    if (document.getElementById("setAutoItemCode").checked && (document.getElementById("tbItemCode").value == "" || document.getElementById("tbItemName").value == "")) {
        pDataCheck = false;
        if (pErrorMsg == "") {
            pErrorMsg = strLang1011;
        }
        else {
            pErrorMsg = pErrorMsg + "<br>" + strLang1011;
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
    createNodeAndInsertText(xmlpara, objNode, "FormName", document.getElementById("tbFormName").value);
    createNodeAndInsertText(xmlpara, objNode, "FormName2", document.getElementById("tbFormName2").value);
    createNodeAndInsertText(xmlpara, objNode, "FormDescript", document.getElementById("tbDescript").value);
    createNodeAndInsertText(xmlpara, objNode, "FormKind", document.getElementById("selFormKind").value);

    if (document.getElementById("setAutoItemCode").checked) {
        createNodeAndInsertText(xmlpara, objNode, "USEFLAG", "Y"); 
    } else {
        createNodeAndInsertText(xmlpara, objNode, "USEFLAG", "N"); 
    }
    
    if (document.getElementById('setConnFlag').checked) {
    	createNodeAndInsertText(xmlpara, objNode, "ConnFlag", "Y"); // 연동양식 체크 
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "ConnFlag", "N");
    }
    
    // 2021-01-21 심기영 오피스 양식 여부 체크 (null 체크 조건 추가)
    if(document.getElementById('officeFlag') != null && document.getElementById('officeFlag').checked) {
    	createNodeAndInsertText(xmlpara, objNode, "officeFlag", "Y");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "officeFlag", "N");
    }
    
    if (document.getElementById('setOpenGovFlag').checked) {
    	createNodeAndInsertText(xmlpara, objNode, "openGovFlag", "Y"); // 원문공개 체크 
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "openGovFlag", "N");
    }
    if (document.getElementById("setPassAprLineFlag").checked) { //기결재통과 체크
    	createNodeAndInsertText(xmlpara, objNode, "passAprLineFlag", "Y");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "passAprLineFlag", "N");
    }
    
    /* 2022-01-07 홍승비 - 전자결재G 일괄결재 옵션 추가 */
    if (document.getElementById("setDraftAllFlag").checked) {
    	createNodeAndInsertText(xmlpara, objNode, "draftAllFlag", "Y");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "draftAllFlag", "N");
    }
    
    /* 2025-07-02 김유진 - 전자결재S 모바일 기안 옵션 추가 */
    if (document.getElementById("setMobileDraftFlag").checked) {
    	createNodeAndInsertText(xmlpara, objNode, "mobileDraftFlag", "Y");
    } else {
    	createNodeAndInsertText(xmlpara, objNode, "mobileDraftFlag", "N");
    }
    
    createNodeAndInsertText(xmlpara, objNode, "KEEPPERIOD", getNodeText(document.getElementById("keepperiod").options[document.getElementById("keepperiod").selectedIndex]));
    createNodeAndInsertText(xmlpara, objNode, "KEEPPERIODCODE", document.getElementById("keepperiod").value);
    createNodeAndInsertText(xmlpara, objNode, "SECURITYLEVEL", document.getElementById("securitylevel").value);
    createNodeAndInsertText(xmlpara, objNode, "ISPUBLIC", document.getElementById("isPublic").value);
    createNodeAndInsertText(xmlpara, objNode, "TBITEMCODE", document.getElementById("tbItemCode").value);
    createNodeAndInsertText(xmlpara, objNode, "TBITEMNAME", document.getElementById("tbItemName").value);
    createNodeAndInsertText(xmlpara, objNode, "TBITEMNAME2", document.getElementById("tbItemName2").value);
    //formXslt
    if(document.querySelector("#setBodyXslt").checked) {
        var formXslt = document.querySelector("#BodyXslt").value.trim();
        formXslt = ConvertCharToEntityReference(formXslt);

        createNodeAndInsertText(xmlpara, objNode, "FORMXSLT", formXslt);
    } else {
        createNodeAndInsertText(xmlpara, objNode, "FORMXSLT", "");
    }

    //formXslt end
    //양식 세부설정
    var formOptArr = new Array();
    var formOptTypeAtr = "";

    for (var k = 0 ; k < document.getElementsByName("aprOption").length ; k++) {
        var code = GetAttribute(document.getElementsByName("aprOption").item(k), "code");
        var optionName = "aprOption_" + code;

        for (var i = 0 ; i < document.getElementsByName(optionName).length ; i++) {
            if (document.getElementsByName(optionName)[i].checked) {
                formOptArr[formOptArr.length] = GetAttribute(document.getElementsByName(optionName)[i], "id");
            }
        }
    }
    formOptTypeAtr = formOptArr.join(",");

    createNodeAndInsertText(xmlpara, objNode, "APPROPTION", formOptTypeAtr);    

    if(document.getElementById("hidfileNM").value != "")
    	createNodeAndInsertText(xmlpara, objNode, "HWPFILEPATH", document.getElementById("hidfileNM").value);

    //    
    createNodeAndInsertText(xmlpara, objNode, "SIHANGTYPE", document.querySelector("#selSihangType").value);    
    
    return getXmlString(xmlpara.childNodes[0]);
}

function MakeFormMHTXML(pBodyData) {
    var retValue = new Array();
    var mustField;
  
    mustField = message.FormInfoCheck("null");
    if (mustField) {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = strLang1024;
    }

    mustField = message.FormInfoCheck("body");
    if (mustField === 0) {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = strLang1013;
    } else if (mustField > 1) {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = strLang1012;
    }

    mustField = message.FormInfoCheck("doctitle");
    if (mustField === 0) {
        mustField = message.FormInfoCheck("doctitlefield");
        if (!mustField) {
            retValue[0] = "FALSE";
            retValue[1] = "";
            retValue[2] = strLang1015;
        }
    } else if (mustField > 1) {
        retValue[0] = "FALSE";
        retValue[1] = "";
        retValue[2] = strLang1014;
    }
    
    var docTypeParam = $("#selFormKind option:selected").val();
    if (approvalFlag == "G" && docTypeParam == "003") {
         mustField = message.FormInfoCheck("receiptnumber");
         if (mustField === 0) {
            retValue[0] = "FALSE";
            retValue[1] = "";
            retValue[2] = strLangJIH_ChkRecvnum2;
        } else if (mustField > 1) {
            retValue[0] = "FALSE";
            retValue[1] = "";
            retValue[2] = strLangJIH_ChkRecvnum1;
        }
    }

    if (retValue.length === 0) {
        switch (useEditor) {
            case "HWP":
                retValue[0] = "TRUE";
                retValue[1] = message.HWP_GetCloneData();
                retValue[2] = "";
                break;
            case "WebHWP":
                retValue[0] = "TRUE";
                retValue[1] = pBodyData;
                retValue[2] = "";
                break;
            default:
                retValue[0] = "TRUE";
                retValue[1] = MakeFormMHTXML_Detail();
                retValue[2] = "";
                break;
        }
    }

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
        var connXmlStr = "", workflowXmlStr = "";

        if (txt_OpinionContent.value) {
            connXmlStr = txt_OpinionContent.value.replace(/\r/g, "").replace(/\n/g, "").replace(/\t/g, "");
            connXmlStr = "<CONNROOT>" + connXmlStr + "</CONNROOT>";
            connXmlStr = "<xml id='conn' style='display:none'>" + connXmlStr + "</xml>"
        }
    
        if (txt_OpinionContent1.value || txt_OpinionContent2.value) {
            var work1XmlStr = txt_OpinionContent1.value.replace(/\r/g, "").replace(/\n/g, "").replace(/\t/g, "");
            var work2XmlStr = txt_OpinionContent2.value.replace(/\r/g, "").replace(/\n/g, "").replace(/\t/g, "");
            workflowXmlStr = 
                "<WORKFLOW>" + 
                "<VALIDATIONS>" + work1XmlStr + "</VALIDATIONS>" + 
                "<APRLINES>" + work2XmlStr + "</APRLINES>" + 
                "</WORKFLOW>";
            workflowXmlStr = "<xml id='WORKFLOW' style='display:none;'>" + workflowXmlStr + "</xml>";
        }

        var Div = document.createElement("DIV");
        Div.innerHTML = message.GetEditorContent();
        
        //태그프리 에디터일 경우 FIELD클래스의 불필요한 문자제거 2019-03-19 홍대표
        if (useEditor === "TAGFREE") {
            Div.querySelectorAll('[class*="FIELD"]').forEach(el => {
                el.className = 'FIELD';
            });
        }
        
        if (message.GetEditorContent().indexOf("BodyContent") === -1) {
            Div.id = "BodyContent";
        }

        if (connXmlStr) {
            BODY.appendChild(loadXMLString(connXmlStr).documentElement);
        }
        if (workflowXmlStr) {
            BODY.appendChild(loadXMLString(workflowXmlStr).documentElement);
        }

        BODY.innerHTML += Div.innerHTML;
        
        HTML.appendChild(BODY);
        return ConvertHTMLtoMHT("<HTML>" + HTML.innerHTML + "</HTML>");
}

function SaveConnWHWPXML_Detail() {
    var connXmlStr = "", workflowXmlStr = "";

    if (txt_OpinionContent.value) {
        connXmlStr = txt_OpinionContent.value.replace(/\r/g, "").replace(/\n/g, "").replace(/\t/g, "");
        connXmlStr = "<CONNROOT>" + connXmlStr + "</CONNROOT>";
    }

    if (txt_OpinionContent1.value || txt_OpinionContent2.value) {
        var work1XmlStr = txt_OpinionContent1.value.replace(/\r/g, "").replace(/\n/g, "").replace(/\t/g, "");
        var work2XmlStr = txt_OpinionContent2.value.replace(/\r/g, "").replace(/\n/g, "").replace(/\t/g, "");
        workflowXmlStr = 
            "<WORKFLOW>" + 
            "<VALIDATIONS>" + work1XmlStr + "</VALIDATIONS>" + 
            "<APRLINES>" + work2XmlStr + "</APRLINES>" + 
            "</WORKFLOW>";
    }

    message.WHWP_SetDocumentElement(connXmlStr + workflowXmlStr);
}

function GetHTML(callback) {
    message.GetTextFile("HWP", "", function (data) { callback(data) });
}

function MakeFormConnXML() {
    var pDataCheck = true;
    var pErrorMsg = "";
    var retValue = new Array();

    /* 2020-07-16 홍승비 - 연동정보 > 연동 옵션 설정 시, 현재 연동정보가 아닌 양식 생성 시의 연동정보를 가져와 비교하는 오류 수정 */
    if (txt_OpinionContent.value.replace(/\r\n/g, "").replace( /\n/g, "").replace(/\r/g, "").replace(/ /g, "") != "") {
        try {
            var xmldom = createXmlDom();
            xmldom = loadXMLString("<conninfo>\n" + txt_OpinionContent.value.replace(/[\n|\t]/g, "") + "\n</conninfo>");

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
                    	//2018-07-03 이효진 query qtype에 service넣었을때 서버측 동작하게하려고 시점 중복시킴
                    	if (GetAttribute(SelectSingleNode(xmldom.getElementsByTagName("conn")[i], "query"), "qtype") != "service") {
                    		pConnArray[i] = GetAttribute(xmldom.getElementsByTagName("conn")[i], "processidx") + GetAttribute(xmldom.getElementsByTagName("conn")[i], "processtime");
                    	}
                    } else {
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

/* 2020-07-17 홍승비 - 저장한 연동정보의 개행과 탭이 제대로 표출되지 않는 오류 수정 */
function MakeFormConnXML_Detail() {
    return "<CONNXML><conninfo>" + txt_OpinionContent.value.replace(/[\n|\t]/g, "") + "</conninfo></CONNXML>"
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
	var rtnVal = new Array();
	var xmlData = MakeFormRecevGroupXML_Detail();
	
	if (xmlData == "FALSE") {
		rtnVal[0] = "FALSE";
		rtnVal[1] = "";
	} else {
		rtnVal[0] = "TRUE";
		rtnVal[1] = xmlData;
	}
	
	return rtnVal;
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
        if (selRow.length == 1 && (GetAttribute(selRow[0], "id") != null ? GetAttribute(selRow[0], "id").indexOf("_TR_noItems") : -1) > -1)
            return "<PARAMETER><DATAS></DATAS></PARAMETER>";

        for (i = 0; i < selRow.length; i++) {
        	if (GetAttribute(selRow[i], "data2").trim() != "") { //DEPTID
        		if (!userInfoChk(GetAttribute(selRow[i], "data2"), GetAttribute(selRow[i], "data1"))) { //DEPTID, USERID
        			return "FALSE";
        		} 
        	}
            subNode = createNodeAndAppandNodeText(xmlpara, objNode, objNode2, "DATA", "");
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTID", GetAttribute(selRow[i], "data1"));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTSN", (i + 1));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "USERID", GetAttribute(selRow[i], "data2"));
            createNodeAndAppandNodeText(xmlpara, subNode, objNode2, "DEPTNAME", selRow[i].cells[0].innerText);
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
    if (useEditor == "WebHWP") {
    	if (formID != "") {
            SaveConnWHWPXML_Detail(); // 한글연동/워크플로우 정보 저장
    		GetHTML(SaveHWPFormInfo);
    	} else {
    		SaveHWPFormInfo();
    	}
    } else {
    	SaveFormInfo();
    }
}
//고정수신처 부서 등록 시, 수발신담당자 유/무 체크
function isReceiverChk(DeptID)
{
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/receiverChk.do",
		data : {
				deptID   : DeptID 
				},
		success: function(text){
			result = text;
		},
		error : function () {
			result = "false";
		}
	});
			
	if(result == "false") 
	    return false;
	else
	    return true;
}
//양식 저장 시, 기존에 고정수신처로 등록 되어있는 사람의 부서정보가 일치하는지 체크
function userInfoChk(userID, deptID) {
	var xmlpara = createXmlDom();
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getADInfos.do",
		data : {
				cn   : userID,
				prop : "DEPARTMENT"
				},
		success: function(xml) {
			xmlpara = loadXMLString(xml);
		}
	});
	
	if (SelectSingleNodeValueNew(xmlpara, "DATA/DEPARTMENT") == deptID) {
		return true;
	} else {
		return false;
	}
}