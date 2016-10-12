function InitAttach(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/attachRequest.do",
		data : {
			docID : pDocID
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    Resultxml = loadXMLString(result);
    var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
    if (NodeList.length > 0) {
        pAttachSN = Number(SelectSingleNodeValue(GetLastChildNodes(NodeList[0], 2)[0], "DATA2")) + 1;
        window.returnValue = "EXIST";
    } else {
        pAttachSN = 1;
        window.returnValue = "cancel";
    }
    return Resultxml;
}
function GetAttachSN(Resultxml) {
    var rows = 0;
    if (SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW").length != 0) {
        rows = GetElementsByTagName(Resultxml, "DATA2");
    }
    var max = 0;
    for (i = 0 ; i < rows.length ; i++) {
        if (max < parseInt(getNodeText(rows.item(i)))) max = parseInt(getNodeText(rows.item(i)));
    }
    return max;
}
function APRAttachXMLParsing(ATTACH, pDocID) {
    var listview = new ListView();
    listview.LoadFromID("attachList");

    var AttachRow = listview.GetDataRows();
    var pCurListLen = AttachRow.length;

    var pCurCell = GetChildNodes(AttachRow[0]);
    var pCurCellLen = pCurCell.length;
    var i, j, GetXml;

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang214 + "</NAME><WIDTH>50</WIDTH></HEADER><HEADER><NAME>" + strLang215 + "</NAME><WIDTH>260</WIDTH></HEADER><HEADER><NAME>" + strLang216 + "</NAME><WIDTH>80</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    for (i = pCurListLen - 1 ; i > -1 ; i--) {
        var Row = AttachRow[i];
        var Cell = GetChildNodes(Row);

        GetXml = GetXml + "<ROW>";
        var re = /&/g;
        GetXml = GetXml + "<COLUMN>" + MakeXMLString(GetChildNodes(AttachRow[i])[0].innerHTML) + "</COLUMN>";
        GetXml = GetXml + "<DATA1>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA1")) + "</DATA1>";
        GetXml = GetXml + "<DATA2>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA2")) + "</DATA2>";
        GetXml = GetXml + "<DATA3>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA3")) + "</DATA3>";
        GetXml = GetXml + "<DATA4>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA4")) + "</DATA4>";
        GetXml = GetXml + "<DATA5>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA5")) + "</DATA5>";
        GetXml = GetXml + "<DATA6>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA6")) + "</DATA6>";
        GetXml = GetXml + "<DATA7>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA7")) + "</DATA7>";
        GetXml = GetXml + "<DATA8>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA8")) + "</DATA8>";
        GetXml = GetXml + "<DATA9>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA9")) + "</DATA9>";
        GetXml = GetXml + "<DATA10>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA10")) + "</DATA10>";
        GetXml = GetXml + "<DATA11>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA11")) + "</DATA11>";
        GetXml = GetXml + "<DATA12>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA12")) + "</DATA12>";
        GetXml = GetXml + "<DATA13>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA13")) + "</DATA13>";
        GetXml = GetXml + "<DATA14>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA14")) + "</DATA14>";
        GetXml = GetXml + "<DATA15>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA15")) + "</DATA15>";
        GetXml = GetXml + "<DATA16>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA16")) + "</DATA16>";
        GetXml = GetXml + "<DATA17>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA17")) + "</DATA17>";
        GetXml = GetXml + "<DATA18>" + MakeXMLString(GetAttribute(AttachRow[i], "DATA18")) + "</DATA18>";


        for (j = 1 ; j < pCurCellLen ; j++)
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(GetChildNodes(AttachRow[i])[j].innerHTML) + "</COLUMN>";

        GetXml = GetXml + "</ROW>";

    }
    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    return GetXml;
}
function DelAttachFileAtList(pAttachCurSel) {
    var pAttachList = new ListView();
    pAttachList.LoadFromID("attachList");

    var pSelectedRow = pAttachList.GetSelectedRows();
    var totalRows = GetAttribute(pSelectedRow[0], "id");

    pAttachList.DeleteRow(totalRows);
    if (pAttachFlag > 0)
        pAttachFlag = pAttachFlag - 1;
}
function SaveAttachListInfo(Attachxml) {
    var ReturnVal;
    xmlhttp.open("Post", "/ezApprovalG/aprAttachSave.do", false);
    xmlhttp.send(Attachxml);

    if (SelectSingleNodeValue(xmlhttp.responseXML, "RESULT") == "FALSE") {
        var pAlertContent = strLang217;
        OpenAlertUI(pAlertContent);
    }
    else {
        if (CrossYN()) {
            CheckHistory(1);
            parent.setAttachInfo(pDocID, "APR", parent.lstAttachLink);
            parent.DivPopUpHidden();
        }
        else {
            CheckHistory(1);
            window.returnValue = Attachxml;
            window.close();
        }
    }
}


var aprattachname_cross_dialogArguments = new Array();
function getAttachFilePageNum(PageNum, DisplayName, CompleteFunction) {
    var windowName = "/ezApprovalG/aprAttachName.do";
  
    var dialogValue = new Array();
    dialogValue[0] = PageNum;
    dialogValue[1] = DisplayName;

    aprattachname_cross_dialogArguments[0] = dialogValue;
    aprattachname_cross_dialogArguments[1] = CompleteFunction;

    if (CrossYN()) {
        DivPopUpShow(330, 230, windowName);
    }
    else {
        var parameter = "status:no;dialogWidth:340px;dialogHeight:230px;scroll:no;edge:sunken;help:no";
        parameter = parameter + GetShowModalPosition(340, 230);
        var AddressName = window.showModalDialog(windowName, dialogValue, parameter);
        return AddressName;
    }
}

function AddAttachFileInfoXmlParsing_Complete(retValue) {
    DivPopUpHidden();
    pAttachxml = "<LISTVIEWDATA><HEADERS>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang214 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang215 + "</NAME><WIDTH>260</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang220 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang221 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "</HEADERS><ROWS><ROW><CELL>";
    pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(pUserName) + "</VALUE>";
    pAttachxml = pAttachxml + "<DATA1>" + MakeXMLString(temppFileLocation) + "</DATA1>";
    pAttachxml = pAttachxml + "<DATA2>" + pAttachSN + "</DATA2>";
    pAttachxml = pAttachxml + "<DATA3>" + pDocID + "</DATA3>";
    pAttachxml = pAttachxml + "<DATA4>" + MakeXMLString(pUserID) + "</DATA4>";
    pAttachxml = pAttachxml + "<DATA5>" + MakeXMLString(pUserJobTitle) + "</DATA5>";
    pAttachxml = pAttachxml + "<DATA6>" + MakeXMLString(pDeptID) + "</DATA6>";
    pAttachxml = pAttachxml + "<DATA7>" + MakeXMLString(pDeptName) + "</DATA7>";
    pAttachxml = pAttachxml + "<DATA8>" + temppFileSize + "</DATA8>";
    pAttachxml = pAttachxml + "<DATA9>" + MakeXMLString(retValue[1]) + "</DATA9>";
    pAttachxml = pAttachxml + "<DATA10>" + MakeXMLString(temppFileName) + "</DATA10>";
    pAttachxml = pAttachxml + "<DATA11>" + MakeXMLString(BodyAttach) + "</DATA11>";
    pAttachxml = pAttachxml + "<DATA12>" + MakeXMLString(retValue[2]) + "</DATA12>";
    pAttachxml = pAttachxml + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";
    pAttachxml = pAttachxml + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";
    pAttachxml = pAttachxml + "<DATA15>" + MakeXMLString(arr_userinfo[13]) + "</DATA15>";
    pAttachxml = pAttachxml + "<DATA16>" + MakeXMLString(arr_userinfo[14]) + "</DATA16>";
    pAttachxml = pAttachxml + "<DATA17>" + MakeXMLString(arr_userinfo[15]) + "</DATA17>";
    pAttachxml = pAttachxml + "<DATA18>" + MakeXMLString(arr_userinfo[16]) + "</DATA18>";
    pAttachxml = pAttachxml + "</CELL><CELL>";
    pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue[2]) + "</VALUE>";
    pAttachxml = pAttachxml + "</CELL><CELL>";

    var strSize;
    if (temppFileSize > 1024 * 1024) {
        temppFileSize = temppFileSize / 1024 / 1024;
        strSize = parseInt(temppFileSize) + "MB";
    }
    else if (temppFileSize > 1024) {
        temppFileSize = temppFileSize / 1024;
        strSize = parseInt(temppFileSize) + "KB";
    }
    else
        strSize = parseInt(temppFileSize) + "B";

    pAttachxml = pAttachxml + "<VALUE>" + strSize + "</VALUE>";
    pAttachxml = pAttachxml + "</CELL><CELL>";
    pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue[1]) + "</VALUE>";
    pAttachxml = pAttachxml + "</CELL></ROW></ROWS></LISTVIEWDATA>";

    Resultxml = loadXMLString(pAttachxml);
    InsertAttachFileInfo(ATTACH, Resultxml);
    pAttachFlag = pAttachFlag + 1;
    pAttachSN = pAttachSN + 1;
    btn_AttachAdd.disabled = false;
}

var temppFileLocation;
var temppFileSize;
var temppFileName;
function AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation) {
    var pAttachxml;
    var re = /&/g;
    var ptmpArray = new Array();
    var pTempURL = "";
    ptmpArray = pFileLocation.split("/");
    var pTmp = ptmpArray[ptmpArray.length - 1];
    pTempURL = pFileLocation.replace(pTmp, "");

    pFileLocation = pTempURL + pTmp;
    if (BodyAttach == "Y")
        var retValue = getAttachFilePageNum("1", "(" + strLang219 + pFileName, AddAttachFileInfoXmlParsing_Complete);
    else
        var retValue = getAttachFilePageNum("1", pFileName, AddAttachFileInfoXmlParsing_Complete);

    if (CrossYN()) {
        temppFileLocation = pFileLocation;
        temppFileSize = pFileSize;
        temppFileName = pFileName;
        return;
    }

    pAttachxml = "<LISTVIEWDATA><HEADERS>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang214 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang215 + "</NAME><WIDTH>260</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang220 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang221 + "</NAME><WIDTH>50</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "</HEADERS><ROWS><ROW><CELL>";
    pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(pUserName) + "</VALUE>";
    pAttachxml = pAttachxml + "<DATA1>" + MakeXMLString(pFileLocation) + "</DATA1>";
    pAttachxml = pAttachxml + "<DATA2>" + pAttachSN + "</DATA2>";
    pAttachxml = pAttachxml + "<DATA3>" + pDocID + "</DATA3>";
    pAttachxml = pAttachxml + "<DATA4>" + MakeXMLString(pUserID) + "</DATA4>";
    pAttachxml = pAttachxml + "<DATA5>" + MakeXMLString(pUserJobTitle) + "</DATA5>";
    pAttachxml = pAttachxml + "<DATA6>" + MakeXMLString(pDeptID) + "</DATA6>";
    pAttachxml = pAttachxml + "<DATA7>" + MakeXMLString(pDeptName) + "</DATA7>";
    pAttachxml = pAttachxml + "<DATA8>" + pFileSize + "</DATA8>";
    pAttachxml = pAttachxml + "<DATA9>" + MakeXMLString(retValue[1]) + "</DATA9>";
    pAttachxml = pAttachxml + "<DATA10>" + MakeXMLString(pFileName) + "</DATA10>";
    pAttachxml = pAttachxml + "<DATA11>" + MakeXMLString(BodyAttach) + "</DATA11>";
    pAttachxml = pAttachxml + "<DATA12>" + MakeXMLString(retValue[2]) + "</DATA12>";
    pAttachxml = pAttachxml + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";
    pAttachxml = pAttachxml + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";
    pAttachxml = pAttachxml + "<DATA15>" + MakeXMLString(arr_userinfo[13]) + "</DATA15>";
    pAttachxml = pAttachxml + "<DATA16>" + MakeXMLString(arr_userinfo[14]) + "</DATA16>";
    pAttachxml = pAttachxml + "<DATA17>" + MakeXMLString(arr_userinfo[15]) + "</DATA17>";
    pAttachxml = pAttachxml + "<DATA18>" + MakeXMLString(arr_userinfo[16]) + "</DATA18>";
    pAttachxml = pAttachxml + "</CELL><CELL>";
    pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue[2]) + "</VALUE>";
    pAttachxml = pAttachxml + "</CELL><CELL>";

    var strSize;
    if (pFileSize > 1024 * 1024) {
        pFileSize = pFileSize / 1024 / 1024;
        strSize = parseInt(pFileSize) + "MB";
    }
    else if (pFileSize > 1024) {
        pFileSize = pFileSize / 1024;
        strSize = parseInt(pFileSize) + "KB";
    }
    else
        strSize = parseInt(pFileSize) + "B";

    pAttachxml = pAttachxml + "<VALUE>" + strSize + "</VALUE>";
    pAttachxml = pAttachxml + "</CELL><CELL>";
    pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue[1]) + "</VALUE>";
    pAttachxml = pAttachxml + "</CELL></ROW></ROWS></LISTVIEWDATA>";
    Resultxml = loadXMLString(pAttachxml);
    return Resultxml;
}
function EditAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation, pListSN)
{
    try {
        return;
    } catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}
function InsertAttachFileInfo(ATTACH, Resultxml) {
    var listview = new ListView();
    listview.LoadFromID("attachList");
    var cnTr = listview.GetDataRows();
    var MaxID = 0;
    if (cnTr.length > 0 && cnTr[0].id.indexOf("noItems") == -1) {
        MaxID = cnTr.length;
    }
    if (cnTr.length == 0) {
        document.getElementById("ATTACH").innerHTML = "";
        var AttachList = new ListView();
        AttachList.SetID("attachList");
        AttachList.SetSelectFlag(false);
        AttachList.SetMulSelectable(false);
        AttachList.SetRowOnDblClick("ATTACH_onDblclick");
        AttachList.DataSource(Resultxml);
        AttachList.DataBind("ATTACH");
    }
    else {
        var objTr = listview.AddRow(MaxID);
        listview.AddDataRow(objTr, Resultxml);
    }
}
function orderListView_id() {
    var attList = new ListView();
    attList.LoadFromID("attachList");
    var totalRows = attList.GetDataRows();
    var totalRowlength = totalRows.length;

    for (var i = 0; i < totalRowlength; i++) {
        totalRows[i].id = totalRows[i].id.substr(0, totalRows[i].id.lastIndexOf("_") + 1) + eval(i);
    }
}
function AttachRemoveAll() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/attachRemove.do",
		data : {
			docID : pDocID
		},
		success: function(text){
			result = text;
		}        			
	});

    Resultxml = result;
    
    return Resultxml;
}
var pDeleteFile = new Array();
var pDeleteFileSn = 0;
function DeleteFileAtServer(pAttachCurSelRow) {
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
    createNodeAndInsertText(xmlpara, objNode, "pAttachSN", GetAttribute(pAttachCurSelRow, "DATA2"));
    createNodeAndInsertText(xmlpara, objNode, "pFileName", GetChildNodes(pAttachCurSelRow)[1].innerHTML);
    pDeleteFile[pDeleteFileSn] = xmlpara;
    pDeleteFileSn = pDeleteFileSn + 1;
    return "TRUE";
}
function DeleteFileAtServer_true(xmlpara) {
    var xmlhttp = createXMLHttpRequest();
    xmlhttp.open("Post", "/ezApprovalG/deleteServerFile.do", false);
    xmlhttp.send(xmlpara);

    return xmlhttp.responseText;
}
function AttachFileListCancel() {
    var i;
    var Rtnval;
    var TotalList = new ListView();
    TotalList.LoadFromID("attachList");

    var pTotalRow = TotalList.GetDataRows();

    for (i = 0 ; i < pAttachFlag ; i++) {
        Rtnval = DeleteFileAtServer(pTotalRow[i]);
        if (Rtnval == "FALSE") {
            var pAlertContent = strLang223;
            OpenAlertUI(pAlertContent);
            break;
        }
    }

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


var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";

    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}
function chkFileFilter(cur_ExtName) {
    if (optExt == "" || optExt == "NONE") return true;

    var aExtNames = optExt.split(";");
    var plength = aExtNames.length;

    var s = cur_ExtName.lastIndexOf(".");
    if (s == -1)
        cur_ExtName = "";
    else
        cur_ExtName = cur_ExtName.substring(s + 1);

    var i;
    var chkflag = false;

    for (i = 0; i < plength; i++) {
        if (aExtNames[i].toLowerCase() == cur_ExtName.toLowerCase()) {
            chkflag = true;
            break;
        }
    }

    if (!chkflag) {
        var pAlertContent = strLang224 + "<BR>" + strLang225;
        OpenAlertUI(pAlertContent);
    }

    return chkflag;
}
function UpdateAttachHistory(tempAttachSN, pModifyFlag) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/updateAttachHistory.do",
		data : {
			docID : pDocID,
			attachSN : tempAttachSN,
			userID : arr_userinfo[1],
			userName : arr_userinfo[11],
			userJobTitle : arr_userinfo[13],
			userDeptID : arr_userinfo[4],
			userDeptName : arr_userinfo[15],
			modifyFlag : pModifyFlag,
			userName2 : arr_userinfo[12],
			userJobTitle2 : arr_userinfo[14],
			userDeptName2 : arr_userinfo[16]
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    if (SelectSingleNodeValue(loadXMLString(result), "RESULT") == "TRUE") {
    }
    else {
        var pAlertContent = strLang226;
        OpenAlertUI(pAlertContent);
    }
}