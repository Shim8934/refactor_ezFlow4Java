var g_strSelectedTab;

var g_arrayTabXMLInitialized = {
    "0": false,
    "1": false,
    "2": false
};

var g_arrayDIV;
var rtnPara = new Array();
var g_RecID, g_SepAttNo;
var g_BInfoXml, g_EInfoXml;
var g_SCFlag;	
var RetValue;
var ReturnFunction;
function window_onload() {
    g_arrayDIV = new Array(divTabDis1, divTabDis2, divTabDis3);

    try {
        RetValue = parent.viewrecinfo_cross_dialogArguments[0];
        ReturnFunction = parent.viewrecinfo_cross_dialogArguments[1];
    } catch (e) {
        try {
            RetValue = opener.viewrecinfo_cross_dialogArguments[0];
            ReturnFunction = opener.viewrecinfo_cross_dialogArguments[1];
        } catch (e) {
            RetValue = window.dialogArguments;
        }
    }
    g_RecID = RetValue[0];
    g_SepAttNo = RetValue[1];

    GetRecInfo();

    if (g_BInfoXml)
        InitBasicInfo();

    if (g_EInfoXml)
        tab_onclick("0");
}


function btnPrint_onclick() {
    PrintMetaData("RECORD", g_RecID, g_SepAttNo);
}

function GetRecInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();	

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 	
    createNodeAndInsertText(xmlpara, objNode, "RECORDID", g_RecID);
    createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", g_SepAttNo);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/ezApprovalG/getRecordInfo.do", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;

    if(getNodeText(GetChildNodes(rtnXml)[0])=="NORECORD")
	{
		alert(strLang713);//"기록물 정보를 찾을 수 없습니다."
		g_BInfoXml=null;
		g_EInfoXml=null;
	}
	else if(getNodeText(GetChildNodes(rtnXml)[0])=="FALSE")
	{
		alert(strLang703);
		g_BInfoXml=null;
		g_EInfoXml=null;
	}
	else
	{
		g_BInfoXml=SelectSingleNode(rtnXml.documentElement, "BASICINFO");
		g_EInfoXml=SelectSingleNode(rtnXml.documentElement, "EXTRAINFO");
	}
}

function InitBasicInfo() {
    if (g_BInfoXml) {
        InsValueIntoTD(tdTitle, SelectSingleNodeValue(g_BInfoXml, "TITLE"));
        InsValueIntoTD(tdRegType, SelectSingleNodeValue(g_BInfoXml, "REGTYPE"));
        InsValueIntoTD(tdDeptName, SelectSingleNodeValue(g_BInfoXml, "DEPTNAME"));
        InsValueIntoTD(tdRegNo, SelectSingleNodeValue(g_BInfoXml, "REGNO"));
        InsValueIntoTD(tdSepAttNo, SelectSingleNodeValue(g_BInfoXml, "SEPATTACHNO"));
        InsValueIntoTD(tdDrafter, SelectSingleNodeValue(g_BInfoXml, "DRAFTER"));
        InsValueIntoTD(tdApprover, SelectSingleNodeValue(g_BInfoXml, "APRMEMBER"));
        InsValueIntoTD(tdRegDate, SelectSingleNodeValue(g_BInfoXml, "REGDATE"));

        g_SCFlag = SelectSingleNodeValue(g_BInfoXml, "SPECIALFLAG");
    }
}

function tab_onclick(strTabNum) {
    var i;

    g_strSelectedTab = strTabNum;

    for (i = 0; i < 3; i++) {
        if (i.toString() != g_strSelectedTab)

            g_arrayDIV[i].style.display = "none";
        else
            g_arrayDIV[i].style.display = "block";
    }
    InitializeTab(strTabNum);
}


function InitializeTab(strTabNum) {
    if (!(g_arrayTabXMLInitialized[strTabNum])) {
        switch (strTabNum) {
            case "0":
                InitExtraInfo();	 
                g_arrayTabXMLInitialized[strTabNum] = true;
                break;

            case "1":
                InitClassInfo();	
                g_arrayTabXMLInitialized[strTabNum] = true;
                break;

            case "2":
                if (g_SCFlag == "2")	
                {
                    InitSCInfo();	
                }
                else {
                    tdSCInfo.innerHTML = strLang711;
                }
                g_arrayTabXMLInitialized[strTabNum] = true;
                break;
        }
    }
}

function InitExtraInfo() {
    InsValueIntoTD(tdExeDate, SelectSingleNodeValue(g_EInfoXml, "EXECUTEDATE"));
    InsValueIntoTD(tdReceipt, SelectSingleNodeValue(g_EInfoXml, "RECEIPTMEMBER"));
    InsValueIntoTD(tdDeliveryNo, SelectSingleNodeValue(g_EInfoXml, "DELIVERYNO"));
    InsValueIntoTD(tdProdRegNo, SelectSingleNodeValue(g_EInfoXml, "PRODUCEDEPTSN"));

    if (SelectSingleNodeValue(g_EInfoXml, "ELECTRONICFLAG") == "1")
        InsValueIntoTD(tdElectronic, "Y");
    else
        InsValueIntoTD(tdElectronic, "N");

    if (SelectSingleNodeValue(g_EInfoXml, "OLDFLAG") == "1")
        InsValueIntoTD(tdOldFlag, "N");
    else
        InsValueIntoTD(tdOldFlag, "Y");

    InsYNIntoTD(tdModifyFlag, SelectSingleNodeValue(g_EInfoXml, "MODIFYFLAG"))
    InsYNIntoTD(tdRejectFlag, SelectSingleNodeValue(g_EInfoXml, "REJECTFLAG"));

    InsValueIntoTD(tdOldProdDept, SelectSingleNodeValue(g_EInfoXml, "OLDPRODUCEDEPT"));
    InsValueIntoTD(tdOldSN, SelectSingleNodeValue(g_EInfoXml, "OLDRECNO"));
    InsValueIntoTD(tdAVSummary, SelectSingleNodeValue(g_EInfoXml, "AVSUMMARY"));
    InsValueIntoTD(tdAVType, SelectSingleNodeValue(g_EInfoXml, "AVTYPE"));
    InsValueIntoTD(tdNumOfPage, SelectSingleNodeValue(g_EInfoXml, "NUMOFPAGE"));
    InsValueIntoTD(tdOldKP, SelectSingleNodeValue(g_EInfoXml, "OLDRECKP"));
}

function InitClassInfo() {
    var rtnXml = GetRecClassInfo();
    if (getNodeText(GetChildNodes(rtnXml)[0]) == "FALSE") {
        alert(strLang716);
    }
    else {
        var clsInfo = SelectSingleNode(rtnXml.documentElement, "CLASSINFO");
        InsValueIntoTD(tdClassNo, SelectSingleNodeValue(clsInfo, "CABCLASSID"));
        InsValueIntoTD(tdCabName, SelectSingleNodeValue(clsInfo, "CABTITLE"));
        InsValueIntoTD(tdSpecialRec, SelectSingleNodeValue(clsInfo, "SPECIALRECCODE"));
        InsValueIntoTD(tdPublic, SelectSingleNodeValue(clsInfo, "PUBLICCODE"));
        InsValueIntoTD(tdLimit, SelectSingleNodeValue(clsInfo, "LIMITRANGE"));

        InsYNIntoTD(tdConfirm, SelectSingleNodeValue(clsInfo, "CONFIRMFLAG"));

        InsYNIntoTD(tdCataTransFlag, SelectSingleNodeValue(clsInfo, "CATATRANSFLAG"));
        InsValueIntoTD(tdCataTransYear, SelectSingleNodeValue(clsInfo, "CATATRANSYEAR"));

        InsYNIntoTD(tdFileTransFlag, SelectSingleNodeValue(clsInfo, "DOCTRANSFLAG"));
        InsValueIntoTD(tdFileTransYear, SelectSingleNodeValue(clsInfo, "DOCTRANSYEAR"));
    }
}

function GetRecClassInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();	

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 	
    createNodeAndInsertText(xmlpara, objNode, "RECORDID", g_RecID);
    createNodeAndInsertText(xmlpara, objNode, "SEPATTACHNO", g_SepAttNo);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "STRLANG", strLang);

    xmlhttp.open("POST", "/ezApprovalG/getRecClassInfo.do", false);
    xmlhttp.send(xmlpara);
    return xmlhttp.responseXML;
}


function InitSCInfo() {
    rtnXml = GetRecSCInfo();
    var dataNodes = GetChildNodes(rtnXml);
    var ret = getNodeText(dataNodes[0]);

    if (ret == "FALSE") {
        alert("" + strLang708 + "");
    }
    else {
        //SCList.dataSource=rtnXml;
        var listview = new ListView();                          
        listview.SetID("lvtSCList");                            
        listview.SetMulSelectable(false);                       
        listview.DataSource(rtnXml);                            
        listview.DataBind("SCList")
    }
}

function GetRecSCInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();	

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 	
    createNodeAndInsertText(xmlpara, objNode, "RECORDID", g_RecID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezCabinet/aspx/API_GetRecSCInfo.aspx", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseXML;
}

function MM_swapImagesub(nSel) {
    if (nSel != g_strSelectedTab) {
        g_strSelectedTab = nSel;

        var i;
        for (i = 0 ; i < 3; i++) {
            if ((g_strSelectedTab != i)) {
                var str = "tab_ViewRec" + i + ".src" + "=" + "\"/images/tab_ViewRec" + i + "a.gif\"";
                eval(str);
            }
        }
    }
}

function btnClose_onclick() {
    window.close();
}


function window_onunload() {
    window.returnValue = rtnPara;
}