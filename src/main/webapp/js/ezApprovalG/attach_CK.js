/**
 * 첨부파일 리스트 추출
 * */
function InitAttach(pDocID) {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/attachRequest.do",
		data : {
			docID : pDocID,
			orgCompanyID : orgCompanyID
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

function orgInitAttach(pDocID) {
	var result = "";
	var returnXml = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/attachRequest.do",
		data : {
			docID : pDocID,
			orgCompanyID : orgCompanyID,
			mode : "END"
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    returnXml = loadXMLString(result);
    return returnXml;
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

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang214 + "</NAME><WIDTH>80</WIDTH></HEADER><HEADER><NAME>" + strLang215 + "</NAME><WIDTH>250</WIDTH></HEADER><HEADER><NAME>" + strLang216 + "</NAME><WIDTH>80</WIDTH></HEADER></HEADERS>";
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
        
        // 대용량첨부, 대용량첨부 삭제여부 플래그
        var isBigAttach = "N";
        if (MakeXMLString(GetAttribute(AttachRow[i], "ISBIGATTACH")) == "Y") {
        	isBigAttach = "Y";
        }
        GetXml = GetXml + "<ISBIGATTACH>" + isBigAttach + "</ISBIGATTACH>";
        
        var isBigAttachDel = "N";
        if (MakeXMLString(GetAttribute(AttachRow[i], "ISBIGATTACHDEL")) == "Y") {
        	isBigAttachDel = "Y";
        }
        GetXml = GetXml + "<ISBIGATTACHDEL>" + isBigAttachDel + "</ISBIGATTACHDEL>";
        
        GetXml = GetXml + "<DELETE>" + MakeXMLString(GetAttribute(AttachRow[i], "DELETE")) + "</DELETE>";

        for (j = 1 ; j < pCurCellLen ; j++) {
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(GetChildNodes(AttachRow[i])[j].innerHTML) + "</COLUMN>";
        }

        GetXml = GetXml + "</ROW>";

    }
    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";
    return GetXml;
}
/**
 * [첨부] -> [삭제]
 * 데이터베이스의 접근하지 않고 XML ROW만 삭제
 * */
function DelAttachFileAtList(pAttachCurSel) {
    var pAttachList = new ListView();
    pAttachList.LoadFromID("attachList");

    /* 2020-03-19 홍승비 - 전자결재 첨부파일 레이어 팝업에서 첨부파일 다중선택 및 다중삭제 가능하도록 수정 */
    var pSelectedRow = pAttachList.GetSelectedRows();
    var pSelectedRowLength = pSelectedRow.length;
    var totalRows = "";
    
    for (var i = 0; i < pSelectedRowLength; i++) {
    	totalRows = GetAttribute(pSelectedRow[i], "id");
    	
	    pAttachList.DeleteRow(totalRows);
	    if (pAttachFlag > 0) {
	        pAttachFlag = pAttachFlag - 1;
	    }
    }
}

function SaveAttachListInfo(Attachxml) {
    var ReturnVal;
    xmlhttp.open("Post", "/ezApprovalG/aprAttachSave.do?orgCompanyID="+orgCompanyID, false);
    xmlhttp.send(Attachxml);
    
    if (xmlhttp.responseText == "TRUE") {
    	if (CrossYN()) {
    		if (isIE() && window.dialogArguments) {
    			CheckHistory(1);
    			window.returnValue = Attachxml;
    			window.close();
    		} else {
    			CheckHistory(1);
    			parent.setAttachInfo(pDocID, "APR", parent.lstAttachLink);
    			parent.DivPopUpHidden();
    		}
        } else {
            CheckHistory(1);
            window.returnValue = Attachxml;
            window.close();
        }
    }
    else {
    	var pAlertContent = strLang217;
        OpenAlertUI(pAlertContent);
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
        DivPopUpShow(330, 220, windowName);
    } else {
        var parameter = "status:no;dialogWidth:330px;dialogHeight:190px;scroll:no;edge:sunken;help:no";
        parameter = parameter + GetShowModalPosition(330, 220);
        var AddressName = window.showModalDialog(windowName, dialogValue, parameter);
        return AddressName;
    }
}

function AddAttachFileInfoXmlParsing_Complete(retValue) {
    DivPopUpHidden();
    if (approvalFlag == "G") {
    	pAttachxml = "<LISTVIEWDATA><HEADERS>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang214 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang215 + "</NAME><WIDTH>250</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang220 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang221 + "</NAME><WIDTH>0</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "</HEADERS><ROWS><ROW><CELL>";
    	pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(pUserName) + "</VALUE>";
    	pAttachxml = pAttachxml + "<DATA1><![CDATA[" + temppFileLocation + "]]></DATA1>";
    	pAttachxml = pAttachxml + "<DATA2>" + pAttachSN + "</DATA2>";
    	pAttachxml = pAttachxml + "<DATA3>" + pDocID + "</DATA3>";
    	pAttachxml = pAttachxml + "<DATA4>" + MakeXMLString(pUserID) + "</DATA4>";
    	pAttachxml = pAttachxml + "<DATA5>" + MakeXMLString(pUserJobTitle) + "</DATA5>";
    	pAttachxml = pAttachxml + "<DATA6>" + MakeXMLString(pDeptID) + "</DATA6>";
    	pAttachxml = pAttachxml + "<DATA7>" + MakeXMLString(pDeptName) + "</DATA7>";
    	pAttachxml = pAttachxml + "<DATA8>" + temppFileSize + "</DATA8>";
    	//pAttachxml = pAttachxml + "<DATA9>" + MakeXMLString(retValue[1]) + "</DATA9>";
    	pAttachxml = pAttachxml + "<DATA9>1</DATA9>";
    	pAttachxml = pAttachxml + "<DATA10><![CDATA[" + temppFileName + "]]></DATA10>";
    	pAttachxml = pAttachxml + "<DATA11>" + MakeXMLString(BodyAttach) + "</DATA11>";
    	//pAttachxml = pAttachxml + "<DATA12>" + MakeXMLString(retValue[2]) + "</DATA12>";
    	pAttachxml = pAttachxml + "<DATA12><![CDATA[" + retValue + "]]></DATA12>";
    	pAttachxml = pAttachxml + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";
    	pAttachxml = pAttachxml + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";
    	pAttachxml = pAttachxml + "<DATA15>" + MakeXMLString(arr_userinfo[13]) + "</DATA15>";
    	pAttachxml = pAttachxml + "<DATA16>" + MakeXMLString(arr_userinfo[14]) + "</DATA16>";
    	pAttachxml = pAttachxml + "<DATA17>" + MakeXMLString(arr_userinfo[15]) + "</DATA17>";
    	pAttachxml = pAttachxml + "<DATA18>" + MakeXMLString(arr_userinfo[16]) + "</DATA18>";
    	pAttachxml = pAttachxml + "<ISBIGATTACH>" + tempAddToBigAttach + "</ISBIGATTACH>"; // 대용량첨부 플래그
    	pAttachxml = pAttachxml + "<ISBIGATTACHDEL>N</ISBIGATTACHDEL>"; // 대용량첨부 삭제여부 플래그 (신규 첨부파일 추가 시 값은 N으로 고정)
    	pAttachxml = pAttachxml + "</CELL><CELL>";
    	//pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue[2]) + "</VALUE>";
    	pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue) + "</VALUE>";
    	pAttachxml = pAttachxml + "</CELL><CELL>";
    	
    	/* 2021-12-22 홍승비 - 전자결재 G버전 첨부파일도 일반버전과 동일하게 용량 단위 수정 */
    	var strSize;
    	if (temppFileSize > 1024 * 1024) {
    		temppFileSize = temppFileSize / 1024 / 1024;
    		strSize = parseInt(temppFileSize) + "MB";
    		//strSize = temppFileSize.toFixed(1) + " MB";
    	}
    	else if (temppFileSize > 1024) {
    		temppFileSize = temppFileSize / 1024;
    		strSize = parseInt(temppFileSize) + "KB";
    		//strSize = temppFileSize.toFixed(1) + " KB";
    	}
    	else
    		strSize = parseInt(temppFileSize) + "B";
    	
    	pAttachxml = pAttachxml + "<VALUE>" + strSize + "</VALUE>";
    	pAttachxml = pAttachxml + "</CELL><CELL>";
    	pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue[1]) + "</VALUE>"; //2018-08-24 쪽수 부분이 disaply:none처리 되어있어서 스크립트 에러 발생-> 주석 제거
    	pAttachxml = pAttachxml + "</CELL></ROW></ROWS></LISTVIEWDATA>";
    } else {
    	pAttachxml = "<LISTVIEWDATA><HEADERS>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang214 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang215 + "</NAME><WIDTH>250</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang220 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    	pAttachxml = pAttachxml + "</HEADERS><ROWS><ROW><CELL>";
    	pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(pUserName) + "</VALUE>";
    	pAttachxml = pAttachxml + "<DATA1><![CDATA[" + temppFileLocation + "]]></DATA1>";
    	pAttachxml = pAttachxml + "<DATA2>" + pAttachSN + "</DATA2>";
    	pAttachxml = pAttachxml + "<DATA3>" + pDocID + "</DATA3>";
    	pAttachxml = pAttachxml + "<DATA4>" + MakeXMLString(pUserID) + "</DATA4>";
    	pAttachxml = pAttachxml + "<DATA5>" + MakeXMLString(pUserJobTitle) + "</DATA5>";
    	pAttachxml = pAttachxml + "<DATA6>" + MakeXMLString(pDeptID) + "</DATA6>";
    	pAttachxml = pAttachxml + "<DATA7>" + MakeXMLString(pDeptName) + "</DATA7>";
    	pAttachxml = pAttachxml + "<DATA8>" + temppFileSize + "</DATA8>";
    	pAttachxml = pAttachxml + "<DATA9>1</DATA9>";
    	pAttachxml = pAttachxml + "<DATA10><![CDATA[" + temppFileName + "]]></DATA10>";
    	pAttachxml = pAttachxml + "<DATA11>" + MakeXMLString(BodyAttach) + "</DATA11>";
    	pAttachxml = pAttachxml + "<DATA12><![CDATA[" + retValue + "]]></DATA12>";
    	pAttachxml = pAttachxml + "<DATA13>" + MakeXMLString(arr_userinfo[11]) + "</DATA13>";
    	pAttachxml = pAttachxml + "<DATA14>" + MakeXMLString(arr_userinfo[12]) + "</DATA14>";
    	pAttachxml = pAttachxml + "<DATA15>" + MakeXMLString(arr_userinfo[13]) + "</DATA15>";
    	pAttachxml = pAttachxml + "<DATA16>" + MakeXMLString(arr_userinfo[14]) + "</DATA16>";
    	pAttachxml = pAttachxml + "<DATA17>" + MakeXMLString(arr_userinfo[15]) + "</DATA17>";
    	pAttachxml = pAttachxml + "<DATA18>" + MakeXMLString(arr_userinfo[16]) + "</DATA18>";
    	pAttachxml = pAttachxml + "<ISBIGATTACH>" + tempAddToBigAttach + "</ISBIGATTACH>"; // 대용량첨부 플래그
    	pAttachxml = pAttachxml + "<ISBIGATTACHDEL>N</ISBIGATTACHDEL>"; // 대용량첨부 삭제여부 플래그 (신규 첨부파일 추가 시 값은 N으로 고정)
    	pAttachxml = pAttachxml + "</CELL><CELL>";
    	pAttachxml = pAttachxml + "<VALUE>" + MakeXMLString(retValue) + "</VALUE>";
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
    	
    	pAttachxml = pAttachxml + "<VALUE>" + strSize + "</VALUE></CELL>";
    	pAttachxml = pAttachxml + "</ROW></ROWS></LISTVIEWDATA>";
    	
    }

    Resultxml = loadXMLString(pAttachxml);
    InsertAttachFileInfo(ATTACH, Resultxml);
    pAttachFlag = pAttachFlag + 1;
    pAttachSN = pAttachSN + 1;
    btn_AttachAdd.disabled = false;
}

var temppFileLocation;
var temppFileSize;
var temppFileName;
var tempAddToBigAttach;
function AddAttachFileInfoXmlParsing(pFileName, pFileSize, pFileLocation, pAddToBigAttach) {
    var pAttachxml;
    var re = /&/g;
    var ptmpArray = new Array();
    var pTempURL = "";
    ptmpArray = pFileLocation.split("/");
    var pTmp = ptmpArray[ptmpArray.length - 1];
    pTempURL = pFileLocation.replace(pTmp, "");

    pFileLocation = pTempURL + pTmp;
    
    tempAddToBigAttach = pAddToBigAttach; // 대용량첨부 플래그 설정
    
    if (CrossYN()) {
	    if (approvalFlag == "G") {
	    	/*if (BodyAttach == "Y") {
	    		var retValue = getAttachFilePageNum("1", "(" + strLang219 + pFileName, AddAttachFileInfoXmlParsing_Complete);
	    	} else {
	    		var retValue = getAttachFilePageNum("1", pFileName, AddAttachFileInfoXmlParsing_Complete);
	    	}*/
	    	
	    	temppFileLocation = pFileLocation;
	        temppFileSize = pFileSize;
	        temppFileName = pFileName;
	        AddAttachFileInfoXmlParsing_Complete(pFileName);
	        return;
	    } else {
	    	temppFileLocation = pFileLocation;
	        temppFileSize = pFileSize;
	        temppFileName = pFileName;
	    	AddAttachFileInfoXmlParsing_Complete(pFileName);
	    	return;
	    }
    }
    
    pAttachxml = "<LISTVIEWDATA><HEADERS>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang214 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang215 + "</NAME><WIDTH>250</WIDTH></HEADER>";
    pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang220 + "</NAME><WIDTH>100</WIDTH></HEADER>";
    //pAttachxml = pAttachxml + "<HEADER><NAME>" + strLang221 + "</NAME><WIDTH>50</WIDTH></HEADER>";
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
/**
 * 첨부파일 관련된 XML데이터를 화면에 출력
 * */
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

        const trElements = document.querySelectorAll('tr');
        const filteredTrElements = Array.from(trElements).filter(tr => tr.id.startsWith('attachList_TR_'));
        filteredTrElements.forEach(tr => tr.setAttribute("draggable", true));
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
			docID : pDocID,
			orgCompanyID : orgCompanyID
		},
		success: function(text){
			result = text;
		}        			
	});
    
    return result;
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
/**
 * 첨부파일의 이력관리
 * [번경내역] -> [첨부파일이력]에서 확인 가능
 * */
function UpdateAttachHistory(tempAttachSN, pModifyFlag) {
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
			userDeptName2 : arr_userinfo[16],
			orgCompanyID : orgCompanyID
		},
		success: function(result){
			if (result == "TRUE") {
				
			} else {
				var pAlertContent = strLang226;
		        OpenAlertUI(pAlertContent);
			}
		}, error : function() {
			var pAlertContent = strLang226;
	        OpenAlertUI(pAlertContent);
		}	
	});
}

function setAttachSortable() {
    $("#ATTACH").multipleSortable({
        items : "tr[data1]",
        opacity: 0.3,
        start : function(event, elem) {
            $("#ATTACH tr").removeClass("multiple-sortable-selected");
            $("#ATTACH tr").removeClass("ui-sortable-helper");
        },
        click : function(event) {
            $("#ATTACH tr").removeClass("multiple-sortable-selected");
            $("#ATTACH tr").removeClass("ui-sortable-helper");
        },
        stop : function(event, elem) {
            var listview = new ListView();
            listview.LoadFromID("attachList");
            var afterRows = listview.GetDataRows();
            var cnt = listview.GetRowCount();
            for (var j = 0; j < cnt; j++) {
                SetAttribute(afterRows[j], "ID", ("attachList_TR_" + j));
            }
        }
    });
    
}

