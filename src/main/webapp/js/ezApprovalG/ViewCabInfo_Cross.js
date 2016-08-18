var g_strSelectedTab;
var g_arrayTabXMLInitialized = { "0": false, "1": false, "2": false, "3": false };
var g_arrayDIV;
var rtnPara = new Array();
var g_CabID, g_CabClassNo;
var g_BInfoXml, g_EInfoXml, g_CInfoXml, g_TInfoXml;
var g_SCFlag, g_TransFlag, g_TCabID;
var RetValue;
var ReturnFunction;
function window_onload() {
    g_arrayDIV = new Array(divTabDis1, divTabDis2, divTabDis3, divTabDis4);
    try {
    	RetValue = parent.viewcabinfo_cross_dialogArguments[0];
        ReturnFunction = parent.viewcabinfo_cross_dialogArguments[1];
    } catch (e) {
        try {
            RetValue = opener.viewcabinfo_cross_dialogArguments[0];
            ReturnFunction = opener.viewcabinfo_cross_dialogArguments[1];
        } catch (e) {
            RetValue = window.dialogArguments;
        }
    }
    g_CabID = RetValue[0];
    g_CabClassNo = RetValue[1];

    GetCabInfo();

    InitBasicInfo();

    if (g_EInfoXml)	
        tab_onclick("0");
}

function GetCabInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();;	
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 	
    createNodeAndInsertText(xmlpara, objNode, "CABINETID", g_CabID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
    createNodeAndInsertText(xmlpara, objNode, "STRTYPE", UserLang);

    xmlhttp.open("POST", "/ezApprovalG/getCabinetDetailInfo.do", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    var dataNodes = GetChildNodes(xmlhttp.responseXML);
    var ret = getNodeText(dataNodes[0]);

    if (ret == "FALSE") {
        alert(strLang703);
        g_BInfoXml = null;
        g_EInfoXml = null;
        g_CInfoXml = null;
        g_TInfoXml = null;
    }
    else {
        g_BInfoXml = SelectSingleNode(rtnXml.documentElement, "BASICINFO");
        g_EInfoXml = SelectSingleNode(rtnXml.documentElement, "EXTRAINFO");
        g_CInfoXml = SelectSingleNode(rtnXml.documentElement, "CLASSINFO");
        g_TInfoXml = SelectSingleNode(rtnXml.documentElement, "TRANSINFO");
    }
}

function InitBasicInfo() {
    InsValueIntoTD(tdTitle, SelectSingleNodeValue(g_BInfoXml, "TITLE"));
    InsValueIntoTD(tdClassNo, SelectSingleNodeValue(g_BInfoXml, "CABCLASSID"));
    InsValueIntoTD(tdRecType, SelectSingleNodeValue(g_BInfoXml, "RECTYPE"));
    InsValueIntoTD(tdDeptName, SelectSingleNodeValue(g_BInfoXml, "DEPTNAME"));
    InsValueIntoTD(tdTaskName, SelectSingleNodeValue(g_BInfoXml, "TASKNAME"));
    InsValueIntoTD(tdProduceY, SelectSingleNodeValue(g_BInfoXml, "PRODUCEY"));
    InsValueIntoTD(tdRegSN, SelectSingleNodeValue(g_BInfoXml, "REGSN"));
    InsValueIntoTD(tdVolNo, SelectSingleNodeValue(g_BInfoXml, "VOLNO"));
    InsValueIntoTD(tdRegDate, SelectSingleNodeValue(g_BInfoXml, "REGDATE"));

    g_SCFlag = SelectSingleNodeValue(g_BInfoXml, "SCFLAG");
}


function InitExtraInfo() {
    InsValueIntoTD(tdNumOfRec, SelectSingleNodeValue(g_EInfoXml, "NUMOFREC"));
    InsValueIntoTD(tdNumOfPage, SelectSingleNodeValue(g_EInfoXml, "NUMOFPAGE"));
    InsValueIntoTD(tdNumOfElec, SelectSingleNodeValue(g_EInfoXml, "NUMOFFILE"));
    InsYNIntoTD(tdModifyFlag, SelectSingleNodeValue(g_EInfoXml, "MODIFYFLAG"))

    if (SelectSingleNodeValue(g_EInfoXml, "OLDFLAG") == "1")
        InsValueIntoTD(tdOldFlag, "N");
    else
        InsValueIntoTD(tdOldFlag, "Y");

    InsValueIntoTD(tdOldDept, SelectSingleNodeValue(g_EInfoXml, "OLDCREATEORGAN"));
    InsValueIntoTD(tdOldClassNo, SelectSingleNodeValue(g_EInfoXml, "OLDCLASSNO"));
}

function InitClassInfo() {
    InsValueIntoTD(tdEndY, SelectSingleNodeValue(g_CInfoXml, "ENDY"));

    InsValueIntoTD(tdKeepPeriod, SelectSingleNodeValue(g_CInfoXml, "KEEPPERIOD"));
    InsValueIntoTD(tdKeepMethod, SelectSingleNodeValue(g_CInfoXml, "KEEPMETHOD"));
    InsValueIntoTD(tdKeepPlace, SelectSingleNodeValue(g_CInfoXml, "KEEPPLACE"));
    InsValueIntoTD(tdDispEndD, SelectSingleNodeValue(g_CInfoXml, "DISPENDDATE"));
    InsValueIntoTD(tdDispReason, SelectSingleNodeValue(g_CInfoXml, "DISPREASON"));
    InsValueIntoTD(tdCharger, SelectSingleNodeValue(g_CInfoXml, "CABCHARGER"));

    InsYNIntoTD(tdConfirm, SelectSingleNodeValue(g_CInfoXml, "CONFIRMFLAG"));

    InsYNIntoTD(tdCataTransFlag, SelectSingleNodeValue(g_CInfoXml, "CATATRANSFLAG"));
    InsValueIntoTD(tdCataTransYear, SelectSingleNodeValue(g_CInfoXml, "CATATRANSYEAR"));

    InsYNIntoTD(tdFileTransFlag, SelectSingleNodeValue(g_CInfoXml, "DOCTRANSFLAG"));
    InsValueIntoTD(tdFileTransYear, SelectSingleNodeValue(g_CInfoXml, "DOCTRANSYEAR"));
}

//START
var View_OriginCabInfo_dialogArguments = new Array();
function View_OriginCabInfo() {
    var para = new Array();
    para[0] = g_TCabID;
    para[1] = "";

    View_OriginCabInfo_dialogArguments[0] = para;

    var url = "/myoffice/ezApprovalG/ezCabinet/ViewCabInfo_Cross.aspx";
    var OpenWin = window.open(url, "ViewCabInfo_Cross", GetOpenWindowfeature(672, 600));
    try { OpenWin.focus(); } catch (e) { }
}
//END

function InitTransInfo() {

    g_TransFlag = SelectSingleNodeValue(g_TInfoXml, "CABTRANSFLAG");
    g_TCabID = SelectSingleNodeValue(g_TInfoXml, "TCABID");    

    if (g_TransFlag == "0")
        InsValueIntoTD(tdTransfer, strLang704);
    else if (g_TransFlag == "1")
        document.getElementById("tdTransfer").innerHTML = strLang705 + "<Input type='button' class='btn' value='" + strLang706 + "' style='width:80;' LANGUAGE=javascript onclick='return View_OriginCabInfo()'>"
    else if (g_TransFlag == "2")
        InsValueIntoTD(tdTransfer, strLang707);
    else
        InsValueIntoTD(tdTransfer, strLang704);

    InsValueIntoTD(tdTransDate, SelectSingleNodeValue(g_TInfoXml, "TRANSDATE"));
    InsValueIntoTD(tdTDeptCode, SelectSingleNodeValue(g_TInfoXml, "TDEPTCODE"));
    InsValueIntoTD(tdTDeptName, SelectSingleNodeValue(g_TInfoXml, "TDEPTNAME"));

    InsValueIntoTD(tdTTaskCode, SelectSingleNodeValue(g_TInfoXml, "TTASKCODE"));
    InsValueIntoTD(tdTTaskName, SelectSingleNodeValue(g_TInfoXml, "TTASKNAME"));

    InsValueIntoTD(tdTProduceY, SelectSingleNodeValue(g_TInfoXml, "TPRODUCEY"));
    InsValueIntoTD(tdTRegSN, SelectSingleNodeValue(g_TInfoXml, "TREGSN"));
    InsValueIntoTD(tdTVolNo, SelectSingleNodeValue(g_TInfoXml, "TVOLNO"));
}

function InitSCInfo() {
    rtnXml = GetCabSCInfo();

    var dataNodes = GetChildNodes(rtnXml);
    var ret = getNodeText(dataNodes[0]);

    if (ret == "FALSE") {
        alert(strLang708);
    }
    else {
        var listview = new ListView();                          
        listview.SetID("lvtSCList");                            
        listview.SetMulSelectable(false);                       
        listview.DataSource(rtnXml);                            
        listview.DataBind("SCList")
    }
}

function GetCabSCInfo() {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();;	


    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETERS"); 	
    createNodeAndInsertText(xmlpara, objNode, "CABINETID", g_CabID);
    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);

    xmlhttp.open("POST", "/ezApprovalG/getCabSCInfo.do", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseXML;
}

function tab_onclick(strTabNum) {
    var i;

    g_strSelectedTab = strTabNum;

    for (i = 0; i < 4; i++) {
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
                InitTransInfo();
                g_arrayTabXMLInitialized[strTabNum] = true;
                break;

            case "3":
                if (g_SCFlag == "1")
                {
                    InitSCInfo();
                }
                else {
                    document.getElementById("tdSCInfo").innerHTML = strLang711;
                    document.getElementById("tdSCInfo").style.width = "610px";
                }
                g_arrayTabXMLInitialized[strTabNum] = true;
                break;
        }
    }
}


function MM_swapImagesub(nSel, e) {
    if (nSel != g_strSelectedTab) {
        g_strSelectedTab = nSel;

        var Event = e ? e : window.event;
        var Element = Event.target ? Event.target : Event.srcElement;


        Element.src = "/images/tab_ViewCab" + nSel + ".gif";

        var i;
        for (i = 0 ; i < 4; i++) {
            if ((g_strSelectedTab != i)) {
                var str = "tab_ViewCab" + i + ".src" + "=" + "\"/images/tab_ViewCab" + i + "a.gif\"";
                eval(str);
            }
        }
    }
}

function btnPrint_onclick() {
    PrintMetaData("CABINET", g_CabID, g_CabClassNo);
}

function btnClose_onclick() {
    window.close();
}

function window_onunload() {
    window.returnValue = rtnPara;
}