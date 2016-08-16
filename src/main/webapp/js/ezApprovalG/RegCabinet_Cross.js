var pOwnerID, pOwnerName;
var bDisplayFlag = "0";
var bSpecialFlag = "0";
var arrTask = new Array();
var g_CodeInfoXml;
var g_nodeKeepMethod, g_nodeKeepPlace;
var g_CabID = "";
var arrDisplayInfo = new Array();
function InitTaskInfo() {

    tdTaskName.innerHTML = arrTask[6] ? arrTask[6] : "";
    if (typeof (tdTaskName2) == "object" && arrTask[7])
        tdTaskName2.innerHTML = arrTask[7];

    g_szSCListXml = "";
    
    SelectKeepingPeriod(arrTask[3]);

    DisplayCodeString("KEEPINGMETHOD", document.getElementById("tdKeepMethod"), arrTask[4]);

    DisplayCodeString("KEEPINGPLACE", document.getElementById("tdKeepPlace"), arrTask[5]);

    SwapDisplayInfo(bDisplayFlag);

    SwapSpecialInfo(bSpecialFlag);
}

function InitCode() {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getCodeList.do",
		data : {
			companyID : CompanyID
		},
		success: function(xml){
			result = xml;
		}        			
	});
    
    g_CodeInfoXml = result;

    if (SelectSingleNodeValue(result, "RESULT") == "FALSE") {
        alert(strLang615);
    }
    else {
        var nodesKeepPeriod = SelectNodes(g_CodeInfoXml, "CODELIST/KEEPINGPERIOD/CODE");
        InitCodeSelectBox(nodesKeepPeriod, selKeepPeriod);

        var nodesRecType = SelectNodes(g_CodeInfoXml, "CODELIST/RECORDTYPE/CODE");
        InitCodeSelectBox(nodesRecType, selRecTypeCode);

        g_nodeKeepMethod = SelectNodes(g_CodeInfoXml, "CODELIST/KEEPINGMETHOD");
        g_nodeKeepPlace = SelectNodes(g_CodeInfoXml, "CODELIST/KEEPINGPLACE");
    }
}

function DisplayCodeString(nodeCodeInfo, htmlObject, szValue) {
    if (CrossYN() && navigator.userAgent.indexOf('Trident') == -1) {
        var str = g_CodeInfoXml.evaluate("CODELIST/" + nodeCodeInfo + "/CODE[CODENUM='" + szValue + "']", g_CodeInfoXml, null, XPathResult.ANY_TYPE, null);
        var result = str.iterateNext();
        if (result) {
            result = result.childNodes[1].childNodes[0].nodeValue;
        }
    }
    else {
    	if (navigator.userAgent.indexOf('Trident') == -1) {
    		result = g_CodeInfoXml.selectSingleNode("CODELIST/" + nodeCodeInfo + "/CODE[CODENUM='" + szValue + "']").childNodes(1).text;
    	} else {
    		result = g_CodeInfoXml.getElementsByTagName(nodeCodeInfo)[0].childNodes[szValue - 1].childNodes[1].textContent;
    	}
    }
    
    htmlObject.innerHTML = result;

}

function SelectKeepingPeriod(strValue) {
    document.getElementById("selKeepPeriod").value = strValue;
    //selKeepPeriod.selectedIndex = selKeepPeriod.options(strValue).index;
}

function SwapDisplayInfo(strValue) {
    arrDisplayInfo[0] = "";
    arrDisplayInfo[1] = "";

    if (strValue == "1") {
        tdDisplayFlag.innerHTML = strLang616;
        btnDisplayInfo.style.display = "";
    }
    else {
        tdDisplayFlag.innerHTML = strLang617;
        btnDisplayInfo.style.display = "none";
    }
}

function SwapSpecialInfo(strValue) {
    if (strValue == "1")
    {
        tdSpecialFlag.innerHTML = strLang619;
        btnAddSC.style.display = "";
    }
    else {
        if (strValue == "2")
            tdSpecialFlag.innerHTML = strLang621;
        else
            tdSpecialFlag.innerHTML = strLang622;

        btnAddSC.style.display = "none";
    }
}

function RegisterCabinet() {

    if (typeof (arrDisplayInfo[0]) == "undefined") {
        arrDisplayInfo[0] = "";
        arrDisplayInfo[1] = "";
    }

    var xmlpara = createXmlDom();   
    var objRoot, objNode, scinfo, catalognode, cataloginfo, objSC, objSCNode;
    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETERS"); 
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTCODE", arr_userinfo[4]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTNAME", arr_userinfo[15]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTNAME2", arr_userinfo[16]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TASKCODE", arrTask[0]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TASKNAME", arrTask[6]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TASKNAME2", arrTask[7]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TITLE", document.getElementById("txtTitle").value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TITLE2", typeof txtTitle2 == "undefined" ? document.getElementById("txtTitle").value : document.getElementById("txtTitle2").value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "RECTYPE", document.getElementById("selRecTypeCode").value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "EXPIREYEAR", "");
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "KEEPPERIOD", document.getElementById("selKeepPeriod").value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "KEEPMETHOD", arrTask[4]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "KEEPPLACE", arrTask[5]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DISPLAYFLAG", bDisplayFlag);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DISPLAYENDDATE", arrDisplayInfo[0]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DISPLAYREASON", arrDisplayInfo[1]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "OWNERID", pOwnerID);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "OWNERNAME", arr_userinfo[11]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "OWNERNAME2", arr_userinfo[12]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VOLNUM", "1");
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SPECIALFLAG", bSpecialFlag);
    scinfo = createNodeAndAppandNode(xmlpara, objRoot, scinfo, "SPECIALCATALOGINFO");

    if (bSpecialFlag != "0")
    {
        cataloginfo = createNodeAndAppandNode(xmlpara, scinfo, cataloginfo, "SCNAME");
        createNodeAndAppandNodeText(xmlpara, cataloginfo, catalognode, "LIST1", g_arrSCName[0]);
        createNodeAndAppandNodeText(xmlpara, cataloginfo, catalognode, "LIST2", g_arrSCName[1]);
        createNodeAndAppandNodeText(xmlpara, cataloginfo, catalognode, "LIST3", g_arrSCName[2]);

        if (g_szSCListXml != "")
        {
            var i;
            var objSCXml = createXmlDom();
            objSCXml = loadXMLString(g_szSCListXml);

            var oRows = SelectNodes(objSCXml, "LISTVIEWDATA/ROWS/ROW");
            if (oRows.length > 0) {
                for (i = 0; i < oRows.length; i++) {
                    objSC = createNodeAndAppandNode(xmlpara, scinfo, objSC, "SCDATA");
                    var objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "SN", getNodeText(GetChildNodes(oRows[i])[0]));
                    for (var j = 1 ; j < 4; j++) {
                        if (j < oRows[i].childNodes.length)
                            objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST" + j, getNodeText(GetChildNodes(oRows[i])[j]));
                        else
                            objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST" + j, "");
                    }
                }
            }
        }
    }

    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/ezApprovalG/registerCabinet.do", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    if (SelectSingleNodeValue(xmlhttp.responseXML, "RESULT") == "FALSE") {
        alert(strLang649);
        return false;
    }
    else {
        g_CabID = SelectSingleNodeValue(xmlhttp.responseXML, "RESULT");
        return true;
    }
}

var InsDisplayInfo_Cross_dialogArguments = new Array();
function btnDisplayInfo_onclick() {
    var para = new Array();
    para[0] = arrDisplayInfo[0];
    para[1] = arrDisplayInfo[1];
    
    InsDisplayInfo_Cross_dialogArguments[0] = para;
    InsDisplayInfo_Cross_dialogArguments[1] = btnDisplayInfo_onclick_Complete;
    var url = "/ezApprovalG/insDisplayInfo.do";
    
    //var feature = "dialogWidth:350px;dialogHeight:242px;scroll:no;resizable:no;status:no; help:no;edge:sunken ";
    //feature = feature + GetShowModalPosition(350, 242);
    //if (url != "")
    //    var rtn = window.showModalDialog(url, para, feature);
    DivPopUpShow(350, 242, url);
}

function btnDisplayInfo_onclick_Complete(rtn) {
    DivPopUpHidden();

    if (rtn[0] == "TRUE") {
        arrDisplayInfo[0] = rtn[1];
        arrDisplayInfo[1] = rtn[2];
    }
}


function btnAddOwner_onclick() {

}


function trim(parm_str) {
    return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    str_temp = parm_str;
    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ") {
            str_temp = str_temp.substring(1, str_temp.length);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}
function rtrim(parm_str) {
    str_temp = parm_str;
    while (str_temp.length != 0) {
        int_last_blnk_pos = str_temp.lastIndexOf(" ");
        if ((str_temp.length - 1) == int_last_blnk_pos) {
            str_temp = str_temp.substring(0, str_temp.length - 1);
        } else {
            return str_temp;
        }
    }
    return str_temp;
}