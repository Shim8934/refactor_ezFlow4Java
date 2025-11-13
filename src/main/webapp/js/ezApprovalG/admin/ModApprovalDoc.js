/**
 * 리딩투자증권
 * 관리자 -> 전제 문서 조회(진행문서) 편집 기능
 * 
 * made by. JongGyun Park
 */

function saveEditApprDoc() {
	
    //작성양식 XML
    var arrFormMHT = MakeFormMHTXML();
    if (arrFormMHT[0] == "TRUE") {
        formMHT = arrFormMHT[1];
    } else {
        OpenAlertUI(arrFormMHT[2]);
        return;
    }	
    
    var url = "";
    
    if(useEditor == "HWP") {
    	url = "/admin/ezApprovalG/editApprDocHWP.do";
    } else {
    	url = "/admin/ezApprovalG/editApprDoc.do";
    }
    
    $.ajax({
    	type : "POST",
    	dataType : "text",
    	async : false,
    	url : url,
    	data : {
    		companyID : companyID,
    		formMHT : formMHT,
    		formHTML : formHTML,
    		htmlData : htmlData,
    		docID : docID,
    		filePath : filePath
    	}, success : function(result) {
    		alert(strLang490);
    		window.close();
    	}
    	
    });
}

function MakeFormMHTXML() {
    var retValue = new Array();
    if (useEditor == "HWP") {
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
    
    debugger;
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
        ConnVal = "<conninfo>\n" + txt_OpinionContent.value + "\n</conninfo>";
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
        BODY.innerHTML = XMLInfo.replace(/\r\n/g, "").replace( /\n/g, "").replace(/\r/g, "") + Div.innerHTML;
    else {
        Div.id = "BodyContent";
        BODY.innerHTML = XMLInfo.replace(/\r\n/g, "").replace( /\n/g, "").replace(/\r/g, "") + Div.outerHTML;
    }
    
    HTML.appendChild(BODY);
    formHTML = "<HTML>" + HTML.innerHTML + "</HTML>";
    return ConvertHTMLtoMHT(formHTML);
}

//var ezapralert_cross_dialogArguments = new Array();
//function OpenAlertUI(pAlertContent, CompleteFunction) {
//    var parameter = pAlertContent;
//    var url = "/ezApprovalG/ezAprAlert.do";
//
//    if (CrossYN()) {
//        ezapralert_cross_dialogArguments[0] = parameter;
//        if (CompleteFunction != undefined)
//            ezapralert_cross_dialogArguments[1] = CompleteFunction;
//        else
//            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
//        DivPopUpShow(330, 205, url);
//    }
//    else {
//        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
//        feature = feature + GetShowModalPosition(330, 205);
//        var RtnVal = window.showModalDialog(url, parameter, feature);
//    }
//}
//
//function OpenAlertUI_Complete() {
//    DivPopUpHidden();
//}
