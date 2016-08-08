﻿var g_CabListXml;
var bSpecialFlag = "0";
var g_szSCListXml = "";
var g_arrSCName = new Array();
var g_CodeInfoXml;
var g_RecTypeCode;
var g_CabID = "";
var g_TaskCode;
function InitCabinetInfo() {
    var CabXml = createXmlDom();
    CabXml = loadXMLString(g_CabListXml);

    g_CabID = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETID");

    g_TaskCode = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "TASKCODE");
    tdCabinetName.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETNAME");
    tdCabinetType.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "RECTYPE");
    tdCabinetSN.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETSN");
    tdCabinetVolNo.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETVOLNO");

    InitCabClassInfo(GetCabinetClassInfo(g_CabID));
}

function InitCabClassInfo(objCabInfoXml) {
    bSpecialFlag = objCabInfoXml.getElementsByTagName("SCFLAG")[0].textContent;
    g_RecTypeCode = objCabInfoXml.getElementsByTagName("RECTYPE")[0].textContent;
    g_arrSCName[0] = objCabInfoXml.getElementsByTagName("LIST1")[0].textContent;
    g_arrSCName[1] = objCabInfoXml.getElementsByTagName("LIST2")[0].textContent;
    g_arrSCName[2] = objCabInfoXml.getElementsByTagName("LIST3")[0].textContent;

    InitRegisterType();

    InitSCInputBox();
}

function InitRegisterType() {
    selRegisterType.innerHTML = "";

    var RegTypeCodeXml = createXmlDom();
    var objRoot, objNode;

    objRoot = createNodeInsert(RegTypeCodeXml, objRoot, "REGISTERTYPE");
    switch (g_RecTypeCode) {

        case "1":
            if (ListTypeFlag == "10") {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[1]);
            }
            else if (ListTypeFlag == "11") {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
            }
            else {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
            }
            break;

        case "2":
            if (ListTypeFlag == "10") {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[3]);
            }
            else if (ListTypeFlag == "11") {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);;
            }
            else {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);
            }
            break;

        case "3":
        	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[4]);
            break;

        case "4":
        	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[5]);
            break;

        case "5":

            if (ListTypeFlag == "10" || ListTypeFlag == "0") {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
            }

            if (ListTypeFlag == "11" || ListTypeFlag == "0") {
            	objRoot.appendChild(g_CodeInfoXml.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
            }

            break;
    }

    InitCodeSelectBox(RegTypeCodeXml.documentElement.childNodes, selRegisterType);

    selRegisterType_onchange();
}

function InitSCInputBox() {
    if (bSpecialFlag == "2")
    {
        btnAddSC.style.display = "";
        tdSpecialFlag.innerHTML = strLang652;
    }
    else {
        btnAddSC.style.display = "none";
        tdSpecialFlag.innerHTML = strLang622;
    }
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
        var nodesRegType = SelectNodes(result, "CODELIST/REGISTERTYPE/CODE");
        var nodesRegType = SelectNodes(result, "CODELIST/RECORDTYPE/CODE");
        InitCodeSelectBox(nodesRegType, selRegisterType);

//        g_NodesRcdgAVType = SelectNodes(result, "CODELIST/KEEPINGMETHOD/CODE");
        g_NodesPhotoAVType = SelectNodes(result, "CODELIST/PHOTOAVTYPE/CODE");
        g_NodesRcdgAVType = SelectNodes(result, "CODELIST/RECORDINGAVTYPE/CODE");
        
        InitCodeSelectBox(nodesRegType, selRegisterType);
    }
}



function RegisterRecord() {
    var pRegType = selRegisterType.value;

    var xmlpara = createXmlDom();   

    var objRoot = createNodeInsert(xmlpara, objRoot, "DATA");   

    var objNode;
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "MANUALFLAG", "1");
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTCODE", arr_userinfo[4]);   
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTNAME", arr_userinfo[15]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTNAME2", arr_userinfo[16]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "REGISTERTYPE", selRegisterType.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "REGISTERDATE", GetRegisterDate());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "REGISTERYEAR", GetRegisterYear());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TITLE", txtTitle.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "NUMOFPAGE", txtTotalPage.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "APRMEMBERTITLE", txtAprMemberTitle.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "APRMEMBERTITLE2", txtAprMemberTitle.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DRAFTERNAME", txtDrafter.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DRAFTERNAME2", txtDrafter.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "EXECUTEDATE", GetExecuteDate());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "RECEIPTMEMBER", txtReceiptMember.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SENDINGMEMBER", "");
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DELIVERYNO", txtDeliveryNo.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "ORIGINREGSN", txtOriginSN.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "ELECTRONICRECFLAG", GetElectronicRecFlag());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "CABINETID", trim_Cross(g_CabID));
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SPECIALREC", GetSpecialRecInfo());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "PUBLICCODE", GetPublicCode());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "LIMITRANGE", txtLimitRange.value);
    if (ListTypeFlag == "1") {
        if (pRegType == "2" || pRegType == "4")
        {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "2");
        }
        else if (pRegType == "8")
        {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "1");
        }
        else {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "0");
        }
    }
    else if (ListTypeFlag == "10") {
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "2");
    }
    else if (ListTypeFlag == "11") {
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "1");
    }

    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SPECIALCATALOGFLAG", bSpecialFlag);

    if (pRegType == "5" || pRegType == "6")
    {
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VISUALAUDIOFLAG", g_VisualAudioFlag);
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VISUALAUDIODESC", txtSummary.value);
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VISUALAUDIOTYPE", GetAVTypeCode());
    }

    var objSI, objSC, objData;
    objSI = createNodeAndAppandNode(xmlpara, objRoot, objSI, "SPECIALCATALOGINFO");

    if (bSpecialFlag == "2")
    {
        objSC = createNodeAndAppandNode(xmlpara, objSI, objSC, "SCNAME");
        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST1", g_arrSCName[0]);
        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST2", g_arrSCName[1]);
        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST3", g_arrSCName[2]);

        if (g_szSCListXml != "")
        {
            var i;
            var objSCXml = createXmlDom();
            objSCXml = loadXMLString(g_szSCListXml);

            var oRows = SelectSingleNode(objSCXml, "LISTVIEWDATA/ROWS/ROW");
            if (oRows.length > 0) {
                for (i = 0; i < oRows.length; i++) {
                    objData = createNodeAndAppandNode(xmlpara, objSC, objData, "SCDATA");
                    objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "SN", oRows.item(i).childNodes(0).childNodes(0).text);
                    if (oRows.item(i).childNodes(1))
                    {
                        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST1", oRows.item(i).childNodes(1).childNodes(0).text);
                    }
                    else {
                        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST1", "");
                    }

                    if (oRows.item(i).childNodes(2))
                    {
                        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST2", oRows.item(i).childNodes(2).childNodes(0).text);
                    }
                    else {
                        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST2", "");
                    }

                    if (oRows.item(i).childNodes(3))
                    {
                        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST3", oRows.item(i).childNodes(3).childNodes(0).text);
                    }
                    else {
                        objData = createNodeAndAppandNodeText(xmlpara, objSC, objData, "LIST3", "");
                    }
                }
            }
        }
    }
    var SepXml = GetSepAttParamXml();
    xmlpara.documentElement.appendChild(SepXml.documentElement);

    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "COMPANYID", CompanyID);   
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCID", pDocID);   

    var AttachFlag = '0';
    if (document.all.lstAttachLink.innerHTML != "")
        AttachFlag = '1';

    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "ATTACHFLAG", AttachFlag);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_RegisterRecord.aspx", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    if (getNodeText(GetChildNodes(rtnXml)[0]) == "TRUE") {
        return true;
    }
    else {
        alert(strLang677);
        return false;
    }
}
var selectcabinet_cross_dialogArguments = new Array();
function btnChangeCabinet_onclick() {
    var para = new Array();
    para[0] = g_CabID;
    var url = "/ezApprovalG/selectCabinet.do?initFlag=1";

    selectcabinet_cross_dialogArguments[0] = para;
    selectcabinet_cross_dialogArguments[1] = btnChangeCabinet_onclick_Complete;

    DivPopUpShow(850, 490, url);
}

function btnChangeCabinet_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        g_CabListXml = rtn[1];
        InitCabinetInfo();
    }
}

function InitAVTypeTD(nodeXml, objTD1, objTD2) {
    var szHtm1 = "";
    var szHtm2 = "";
    var i;
    szHtm1 = "<div style=\"width:100%;height:140px;overflow:auto;\">";

    for (i = 0; i < nodeXml.length; i++) {
        if (i % 2 == 0) {
            szHtm1 += "<input type='checkbox' name='chkAVType' id='chkAVType' style=\"height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;\" value='" +

                    getNodeText(GetChildNodes(nodeXml[i])[0]) + "'><span>&nbsp;" +
					getNodeText(GetChildNodes(nodeXml[i])[1]) + "</span><br>";
        }
        else {
            szHtm2 += "<input type='checkbox' name='chkAVType' id='chkAVType' style=\"height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;\" value='" +
                    getNodeText(GetChildNodes(nodeXml[i])[0]) + "'><span>&nbsp;" +
					getNodeText(GetChildNodes(nodeXml[i])[1]) + "</span><br>";
        }
    }
    objTD1.innerHTML = szHtm1 + szHtm2 + "</div>";
}

function GetAVTypeCode() {
    var colAVType = document.getElementsByName("chkAVType");
    var rtnStr = "";
    for (i = 0; i < colAVType.length; i++) {
        if (colAVType[i].checked) {
            if (rtnStr == "")
                rtnStr += colAVType[i].value;
            else
                rtnStr += "," + colAVType[i].value;
        }
    }
    return rtnStr;
}