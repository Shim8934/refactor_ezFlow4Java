var fractionsymbol;
function setDocNumFormat() {
    var Arr_Header = new Array();
    var Header, Tail;
    var i;
    var d = new Date();

    var numHeader = "";
    var DeptSymbol = arr_userinfo[5];

    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "receiptnumber");
    if (!field) return

    var fieldValue;
    try {
        fieldValue = field.getAttribute("Format");
        if(fieldValue == null || fieldValue == "")
            fieldValue = "@dp-@nn";
    }
    catch (e) {
        fieldValue = "@dp-@nn";
    }
    if (fieldValue != "" && fieldValue.replace("@", "") == fieldValue) {
        pDocNo = fieldValue;
        var tempString = pDocNo.split("-");
        var tempNumString = "";
        if (tempString.length - 1 > 0)
            tempNumString = tempString[tempString.length - 1];
        var i = 0;
        var templen = tempNumString.length;
        for (i = 0; i < 6 - templen; i++)
            tempNumString = "0" + tempNumString;
        pDocNumCode = arr_userinfo[4] + tempNumString;
        return false;
    }
    else if (fieldValue == "") {
        fieldValue = getfieldValue(field);
    }
    Arr_Header = fieldValue.split("@");
    for (i = 1; i < Arr_Header.length; i++) {
        Header = Arr_Header[i].substr(0, 2);
        Tail = Arr_Header[i].substr(2);
        switch (Header) {
            case "DP":
                numHeader = numHeader + DeptSymbol + Tail;
                break;

            case "dp":
                numHeader = numHeader + DeptSymbol + Tail;
                break;

            case "YY":
                numHeader = numHeader + d.getYear() + Tail;
                break;

            case "yy":
                var yyear = d.getYear();
                numHeader = numHeader + yyear.toString().substr(2) + Tail;
                break;

            case "MM":
                var mmonth = d.getMonth() + 1;
                if (parseInt(mmonth) < 10) mmonth = "0" + mmonth;
                numHeader = numHeader + mmonth + Tail;
                break;

            case "mm":
                numHeader = numHeader + (d.getMonth() + 1) + Tail;
                break;

            case "NN":
                break;

            case "nn":
                break;

            case "cs":
                numHeader = numHeader + strLang107 + Tail;
                break;

            default:
                numHeader = numHeader + fieldValue;
                break;
        }
    }
    field.textContent = numHeader;
    return true;
}
function getfieldValue(pfield) {
    var rtnVal = "";

    if (pfield) {

        switch (pfield.tagName) {
            case "TD":
                rtnVal = pfield.textContent;
                break;
            case "SELECT":
                rtnVal = pfield.textContent;
                break;
            case "INPUT":
                rtnVal = pfield.textContent;
                break;
        }
    }
    return rtnVal;
}
function getRecvDocNumber(pDeptID) {
    try {
        var fields = message.GetFieldsList();
        var name, docnumber;
        var rtnval;

        name = "receiptnumber";
        var field = message.GetListItem(fields, name);
        if (!field) {
            var DeptSymbol = arr_userinfo[5];
        	var result = "";
        	
        	$.ajax({
        		type : "POST",
        		dataType : "text",
        		async : false,
        		url : "/ezApprovalG/getCabinetSN.do",
        		data : {
        			docID : pDocID,
        			deptID : pDeptID
        		},
        		success: function(xml){
        			result = loadXMLString(xml);
        		}
        	});

            var SN = getNodeText(GetChildNodes(result)[0]);
            pDocNo = DeptSymbol + "-" + SN;
            var tempNumString = SN;
            var i = 0;
            var templen = tempNumString.length;
            for (i = 0; i < 6 - templen; i++)
                tempNumString = "0" + tempNumString;
            pDocNumCode = pDeptID + tempNumString;
            SaveFile();
            return true;
        }
        var rtnVal = setDocNumFormat();
        if (!rtnVal)
            return true;

        fractionsymbol = field.textContent;

    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getCabinetSN.do",
    		data : {
    			docID : pDocID,
    			deptID : pDeptID
    		},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}
    	});
    	
        var SN = getNodeText(GetChildNodes(result)[0]);
        if (SN == "") {
            pDocNumCode = "";
            pDocNo = "";
            field.textContent = "";
            return false;
        }
        else {
            field.textContent = fractionsymbol + SN;
            pDocNo = fractionsymbol + SN;
            var tempNumString = SN;
            var i = 0;
            var templen = tempNumString.length;
            for (i = 0; i < 6 - templen; i++)
                tempNumString = "0" + tempNumString;
            pDocNumCode = pDeptID + tempNumString;
            SaveFile();
            return true;
        }
    } catch (e) {
        if (SN != "") {
            field.textContent = fractionsymbol + SN;
            rollbackDocNumber(pDeptID, pDocID);
            return false;
        }
        else {
            field.value = "";
            pDocNo = "";
        }
    }
}
function rollbackDocNumber(pDeptID, pDocID) {
    try {
        var fields = message.GetFieldsList();
        var name, docnumber;
        var rtnval;

        name = "receiptnumber";
        var field = message.GetListItem(fields, name);
        if (!field) return true;

        docnumber = field.textContent;
        if (fractionsymbol == "") {
            var tempList = docnumber.split("-");
            fractionsymbol = tempList[0] + "-";
        }
        docnumber = docnumber.replace(fractionsymbol, "");

        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "PARAMETER");
        createNodeAndInsertText(xmlpara, objNode, "DATA", pDeptID);
        createNodeAndInsertText(xmlpara, objNode, "DATA", docnumber);
        createNodeAndInsertText(xmlpara, objNode, "DATA", pDocID);

        xmlhttp.open("Post", "../docnum/aspx/rollbackCabinetSN.aspx", false);
        xmlhttp.send(xmlpara);

        rtnval = getNodeText(GetChildNodes(xmlhttp.responseXML)[0]);
        field.textContent = "";

        if (rtnval == "FALSE") {
            pDocNumCode = "";
            pDocNo = "";
        }
        else {
            SaveFile();
            pDocNumCode = "";
            pDocNo = "";
        }
    } catch (e) {
        field.textContent = "";
        pDocNumCode = "";
        pDocNo = "";
    }
}
function SaveFile() {
    try {
    	var result = "";
        var mhtBody = "";
    	mhtBody = message.Get_EditorBodyHTML();
    	EmbedContentIntoXML(mhtBody);
    	mhtBody = ConvertHTMLtoMHT(mhtBody);
    	
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/saveFile.do",
    		data : {
    			docID : pDocID,
    			html  : mhtBody
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});

        return result;
    } catch (e) {
        alert("SaveFile : " + e.description);
    }
}

function EmbedContentIntoXML(bodyhtml) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = bodyhtml;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0 && !imgColl.item(i).src.toLowerCase().indexOf(".tmp")) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";
            if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
                if (imgColl.item(i).style.width != "")
                    ImgWidth = imgColl.item(i).style.width.replace("px", "");
                if (imgColl.item(i).style.height != "")
                    ImgHeight = imgColl.item(i).style.height.replace("px", "");
            }
            else {
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgWidth = result[1];
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgHeight = result[1];
            }
            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }
    }
    return bodyhtml;
}