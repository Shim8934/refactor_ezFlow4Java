function getOpinionList() {
    try {
    	var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/opinionRequest.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});

        return loadXMLString(result);
    } catch (e) {
        alert("getOpinionList ::" + e.description);
    }
}

function getAprOpinionXML(pOpContent) {
    var KyljeaOrder = "";
    var KyljeaName = "";
    var KyljeaDeptName = arr_userinfo[5];
    var KyljeaType = "";
    var KyljeaStat = "";
    var KyljeaJobtitle = arr_userinfo[3];
    var KyljeaUserID = "";
    var KyljeaDeptID = arr_userinfo[4];


    var KyljeaDeptName = arr_userinfo[5];
    var KyljeaDeptName1 = arr_userinfo[15];
    var KyljeaDeptName2 = arr_userinfo[16];
    var KyljeaJobtitle = arr_userinfo[3];
    var KyljeaJobtitle1 = arr_userinfo[13];
    var KyljeaJobtitle2 = arr_userinfo[14];

    try {
    	var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/aprLineRequest.do",
    		data : {
    			docID : pDocID,
    			userID : pUserID,
    			formID : ""
    		},
    		success: function(text){
    			result = text;
    		}        			
    	});
    	
        var xmldom = createXmlDom();
        xmldom = loadXMLString(result);
        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
        count = objNodes.length - 1;

        for (var i = count; i >= 0; i--) {
            var cell = GetChildNodes(objNodes[i]);
            var cellzero = GetChildNodes(cell[0]);
            var KyljeaUserID = getNodeText(cellzero[4]);

            if (KyljeaUserID == pUserID && getNodeText(cell[5]) == strLang18) {
                var KyljeaOrder = getNodeText(cellzero[0]);
                var KyljeaName = getNodeText(cell[1]);
                var KyljeaDeptID = getNodeText(cellzero[6]);
                var KyljeaDeptName = getNodeText(cell[3]);
                var KyljeaType = getNodeText(cell[4]);
                var KyljeaStat = getNodeText(cell[5]);
                var KyljeaJobtitle = getNodeText(cell[2]);
                break;
            }
        }
    }
    catch (e) {
        alert("getAprOpinionXML1 :: " + e.description);
    }

    try {

        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        var pTotalRows = OpinionList.GetDataRows();
        var pOpinionLen = OpinionList.GetRowCount();
        var pAddIndex = pOpinionLen + 1;

        var LISTVIEW;
        var HEADERS;
        var HEADER;
        var NAME;
        var WIDTH;
        var ROWS;
        var ROW;
        var CELL;
        var CELLVALUE;
        var CELLDATA;
        var objNode;
        var objRoot;

        var objXML = createXmlDom();

        objRoot = createNodeInsert(objXML, objRoot, "LISTVIEWDATA");
        HEADERS = createNodeAndAppandNode(objXML, objRoot, HEADERS, "HEADERS");
        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang31);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "80");

        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang29);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "76");

        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang28);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "100");

        HEADER = createNodeAndAppandNode(objXML, HEADERS, HEADER, "HEADER");
        createNodeAndAppandNodeText(objXML, HEADER, NAME, "NAME", strLang32);
        createNodeAndAppandNodeText(objXML, HEADER, WIDTH, "WIDTH", "114");

        ROWS = createNodeAndAppandNode(objXML, objRoot, ROWS, "ROWS");
        ROW = createNodeAndAppandNode(objXML, ROWS, ROW, "ROW");
        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");


        createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", GetOpinionTypeName(pOpinionType));
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA1", pDocID);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA2", pUserID);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA3", pOpContent);

        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA4", KyljeaDeptID);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA5", pAddIndex);


        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA6", pOpinionType);

        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA7", arr_userinfo[11]);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA8", arr_userinfo[12]);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA9", arr_userinfo[13]);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA10", arr_userinfo[14]);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA11", arr_userinfo[15]);
        createNodeAndAppandNodeText(objXML, CELL, CELLDATA, "DATA12", arr_userinfo[16]);

        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");
        createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", arr_userinfo[2]);
        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");
        createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", KyljeaJobtitle);

        CELL = createNodeAndAppandNode(objXML, ROW, CELL, "CELL");
        createNodeAndAppandNodeText(objXML, CELL, CELLVALUE, "VALUE", KyljeaDeptName);

        return getXmlString(objXML);

    }
    catch (e) {
        alert("getAprOpinionXML2 ::" + e.description);
    }
}

function getOpinionListInfo() {
    try {

        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        var pTotalRows = OpinionList.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;
        var pTotalColsLen = pTotalRows[0].cells.length;
        var i;
        var j;
        var strXML;

        var LISTVIEWDATA;
        var HEADERS;
        var ROWS;
        var ROW;
        var COLUMN;
        var COLUMNDATA;
        var objRoot;

        var objXML = createXmlDom();

        objRoot = createNodeInsert(objXML, objRoot, "LISTVIEWDATA");
        HEADERS = createNodeAndAppandNode(objXML, objRoot, HEADERS, "HEADERS");
        ROWS = createNodeAndAppandNode(objXML, objRoot, ROWS, "ROWS");

        for (i = 0 ; i < pTotalRowsLen ; i++) {
            ROW = createNodeAndAppandNode(objXML, ROWS, ROW, "ROW");

            var tr = pTotalRows[i];

            for (j = 0 ; j < pTotalColsLen ; j++) {
                createNodeAndAppandNodeText(objXML, ROW, COLUMN, "COLUMN", tr.cells[j].innerText);
            }
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "DocID", trim_Cross(GetAttribute(tr, "DATA1")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserID", trim_Cross(GetAttribute(tr, "DATA2")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "Content", trim_Cross(GetAttribute(tr, "DATA3")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserDeptID", trim_Cross(GetAttribute(tr, "DATA4")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "OpinionSN", trim_Cross(GetAttribute(tr, "DATA5")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "OpinionGB", trim_Cross(GetAttribute(tr, "DATA6")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserName", trim_Cross(GetAttribute(tr, "DATA7")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserName2", trim_Cross(GetAttribute(tr, "DATA8")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserJobTitle", trim_Cross(GetAttribute(tr, "DATA9")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserJobTitle2", trim_Cross(GetAttribute(tr, "DATA10")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserDeptName", trim_Cross(GetAttribute(tr, "DATA11")));
            createNodeAndAppandNodeText(objXML, ROW, COLUMNDATA, "UserDeptName2", trim_Cross(GetAttribute(tr, "DATA12")));
        }
        return objXML;

    } catch (e) {
        alert("getOpinionListInfo :: " + e.description);
    }
}

function CheckOpinionExist() {
    try {
        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        var pTotalRows = OpinionList.GetDataRows();
        var pTotalRowsLen = pTotalRows.length;

        if (pTotalRowsLen == 0) {
            btn_OpinionAdd.textContent = strLang389;
        }
        else {
            for (var i = 0 ; i < pTotalRowsLen ; i++) {
                if (pUserID == trim_Cross(GetAttribute(pTotalRows[i], "DATA2"))) {
                    document.getElementById("btn_OpinionAdd").textContent = strLang390;
                    OpinionAddFlag = 1;
                    break;
                }

                if (pDisplay == "Display") {
                    document.getElementById("btn_OpinionAdd").textContent = strLang391;
                }
                else {
                    document.getElementById("btn_OpinionAdd").textContent = strLang389;
                }
            }
        }
    } catch (e) {
        alert("CheckOpinionExist :: " + e.description);
    }
}

function AddOpinionContent(Opstate, OpContent) {
    try {
        var objXML = createXmlDom();
        if (Opstate == strLang391) {
            document.getElementById("btn_OpinionAdd").textContent = strLang389;
            document.getElementById("txt_OpinionContent").readOnly = false;
            document.getElementById("txt_OpinionContent").value = "";
            document.getElementById("txt_OpinionContent").focus();
        }
        else if (Opstate == strLang389 && OpContent != "") {

            var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");

            //var pTotalRows = OpinionList.GetDataRows();
            var pTotalRows = OpinionList.GetDataRows().length;
            if (pTotalRows == 1) {
                var tr = OpinionList.GetDataRows();
                if (tr[0].id.indexOf("noItems") > 0)
                    pTotalRows = 0;
            }

            var pstrXML = getAprOpinionXML(OpContent);
            objXML = loadXMLString(pstrXML);

            if (pTotalRows < 1) {
                if (document.getElementById("OPINION").innerHTML != "")
                    document.getElementById("OPINION").innerHTML = "";

                OpinionList = new ListView();
                OpinionList.SetID("OpinionList");
                OpinionList.SetMulSelectable(false);
                OpinionList.SetSelectFlag(false);

                OpinionList.SetRowOnClick("OPINIONOnSelChange_onclick");
                OpinionList.DataSource(objXML);
                OpinionList.DataBind("OPINION");
            }
            else {
                var MaxID = 0;
                for (var j = 0 ; j < pTotalRows.length ; j++) {
                    var curnum = Number(OpinionList.GetSelectedRowID(j).substring(OpinionList.GetSelectedRowID(j).lastIndexOf('_') + 1), OpinionList.GetSelectedRowID(j).length);
                    if (MaxID < curnum)
                        MaxID = curnum;
                }
                var objTr = OpinionList.NewAddRow(0, "OpinionList_TR_" + eval(MaxID + 1));
                OpinionList.AddDataRow(objTr, objXML);

            }
            OpinionAddFlag = 1;

            document.getElementById("btn_OpinionAdd").textContent = strLang390;
            document.getElementById("btn_OpinionCancel").textContent = strLang397;
            document.getElementById("bbtn_OpinionAdd").style.display = "none";
        }
        else if (Opstate == strLang390 && OpContent != "") {
            var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");
            var pSelectedRow = OpinionList.GetSelectedRows();
            var pTotalRows = OpinionList.GetDataRows();
            var tr = pSelectedRow[0];


            if (pSelectedRow.length != 0) {
                if (trim_Cross(GetAttribute(tr, "DATA2")) == pUserID) {
                    tr.cells[0].innerHTML = GetOpinionTypeName(pOpinionType);
                    SetAttribute(tr, "DATA6", pOpinionType);
                    SetAttribute(tr, "DATA3", OpContent);
                    document.getElementById("btn_OpinionAdd").textContent = strLang390;
                    var tmpKyljeaDeptName = arr_userinfo[15];
                    var tmpKyljeaJobtitle = arr_userinfo[13];
                    var tmpKyljeaDeptID = arr_userinfo[4];
                    var tmpKyljeaDeptName2 = arr_userinfo[16];
                    var tmpKyljeaJobtitle2 = arr_userinfo[14];
                    try {
                    	var result = "";
                        
                        $.ajax({
                    		type : "POST",
                    		dataType : "text",
                    		async : false,
                    		url : "/ezApprovalG/aprLineRequest.do",
                    		data : {
                    			docID : pDocID,
                    			userID : pUserID,
                    			formID  : ""
                    		},
                    		success: function(text){
                    			result = text;
                    		}        			
                    	});
                    	
                        var xmldom = createXmlDom();
                        xmldom = loadXMLString(result);
                        objNodes = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
                        count = objNodes.length - 1;
                        var cell = GetChildNodes(objNodes);
                        var cellzero = cell[0];

                        for (var i = count ; i >= 0 ; i--) {
                            var tmpKyljeaUserID = getNodeText(GetChildNodes(cellzero[4]));

                            if (tmpKyljeaUserID == pUserID && getNodeText(GetChildNodes(cellzero[5])) == strLang18) {
                                tmpKyljeaDeptID = getNodeText(GetChildNodes(cellzero[6]));
                                tmpKyljeaDeptName = getNodeText(GetChildNodes(cellzero[15]));
                                tmpKyljeaJobtitle = getNodeText(GetChildNodes(cellzero[17]));
                                tmpKyljeaDeptName2 = getNodeText(GetChildNodes(cellzero[16]));
                                tmpKyljeaJobtitle2 = getNodeText(GetChildNodes(cellzero[18]));

                                break;
                            }
                        }
                    }
                    catch (e) { }

                    var tr = GetChildNodes(pSelectedRow[0]);

                    setNodeText(tr[3], UserLang == "1" ? tmpKyljeaDeptName : tmpKyljeaDeptName2);
                    setNodeText(tr[2], UserLang == "1" ? tmpKyljeaJobtitle : tmpKyljeaJobtitle2);
                    SetAttribute(pSelectedRow[0], "DATA4", tmpKyljeaDeptID);
                    SetAttribute(pSelectedRow[0], "DATA9", tmpKyljeaJobtitle);
                    SetAttribute(pSelectedRow[0], "DATA10", tmpKyljeaJobtitle2);
                    SetAttribute(pSelectedRow[0], "DATA11", tmpKyljeaDeptName);
                    SetAttribute(pSelectedRow[0], "DATA12", tmpKyljeaDeptName2);
                    document.getElementById("btn_OpinionCancel").textContent = "" + strLang397 + "";

                    var pAlertContent = strLang1027;
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else {
                    var pAlertContent = strLang400 + "<br> " + strLang401;
                    OpenAlertUI(pAlertContent);
                    return;
                }
            }
            else {
                var pAlertContent = strLang401;
                OpenAlertUI(pAlertContent);
            }
        }
        else {
            var pAlertContent = strLang402;
            OpenAlertUI(pAlertContent);
            document.getElementById("txt_OpinionContent").focus();
        }
    } catch (e) {
        alert("AddOpinionContent :: " + e.description);
    }
}


function CheckOpinionType() {
    try {
        if (pDisplay == "BanSong") {
            pOpinionType = strOpinionType2;
        }
        else if (pDisplay == "BoRyu") {
            pOpinionType = strOpinionType3;
        }
        else if (pDisplay == "Show") {
            document.getElementById("bbtn_OpinionAdd").style.display = "none";
            document.getElementById("bbtn_OpinionDel").style.display = "none";
        }
        else if (pDisplay == "HeSong") {
            pOpinionType = strOpinionType4;
        }
    } catch (e) {
        alert("CheckOpinionType :: " + e.description);
    }
}

function InitOpinionInfo() {
    try {
        var objXML = createXmlDom();

        objXML = getOpinionList();

        if (document.getElementById("OPINION").InnerHTML != "")
            document.getElementById("OPINION").InnerHTML;

        var OpinionList = new ListView();
        OpinionList.SetID("OpinionList");
        OpinionList.SetMulSelectable(false);
        OpinionList.SetRowOnClick("OPINIONOnSelChange_onclick");
        OpinionList.SetSelectFlag(false);
        OpinionList.DataSource(objXML);
        OpinionList.DataBind("OPINION");

        CheckOpinionExist();

        var opCount = OpinionList.GetDataRows();
        var opCountLen = opCount.length;

        for (var x = 0; x < opCountLen; x++) {
            if (GetAttribute(opCount[x], "DATA2") == arr_userinfo[1] && pDisplay == "BanSong") {
                document.getElementById("txt_OpinionContent").value = GetAttribute(opCount[x], "DATA3");
            }
        }

        if (pDisplay == "Display" || pDisplay == "Show") {
            var pTotalRows = OpinionList.GetDataRows();
            var pTotalRowsLen = pTotalRows.length;

            if (pTotalRowsLen != 0) {
                document.getElementById("txt_OpinionContent").value = GetAttribute(pTotalRows[0], "DATA3");
                document.getElementById("txt_OpinionContent").readOnly = true;
            }
        } else if (pDisplay != "Show") {
            document.getElementById("txt_OpinionContent").focus();
        }
    } catch (e) {
        alert("InitOpinionInfo :: " + e.description);
    }
}

function deleteOpinionInfo() {
    try {
        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        var pSelectedRow = OpinionList.GetSelectedRows();
        if (pSelectedRow.length != "0") {
            var CheckValue;
            if (pOrgDocID == "REDRAFT") {
                var pInformationContent = strLang406;
                var Rtnval = OpenInformationUI(pInformationContent, deleteOpinionInfo_Complete);
                if (!CrossYN() && Rtnval) {
                    var selIdx = GetAttribute(pSelectedRow[0], "id");

                    OpinionList.DeleteRow(selIdx);
                    document.getElementById("txt_OpinionContent").value = "";
                    document.getElementById("btn_OpinionAdd").textContent = strLang389;
                    document.getElementById("btn_OpinionCancel").textContent = strLang397;
                    OpinionAddFlag = 0;
                }
            }
            else {
                deleteOpinion(pSelectedRow);
            }
        }
    } catch (e) {
        alert("deleteOpinionInfo ::" + e.description);
    }
}

function deleteOpinionInfo_Complete(Rtnval) {
    DivPopUpHidden();
    if (Rtnval) {
        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");
        var pSelectedRow = OpinionList.GetSelectedRows();

        var selIdx = GetAttribute(pSelectedRow[0], "id");
        OpinionList.DeleteRow(selIdx);
        document.getElementById("txt_OpinionContent").value = "";
        document.getElementById("btn_OpinionAdd").textContent = strLang389;
        document.getElementById("btn_OpinionCancel").textContent = strLang397;
        OpinionAddFlag = 0;
    }
}

function deleteOpinion(pSelectedRow) {
    try {
        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        if (pSelectedRow.length != "0") {
            var tr = pSelectedRow[0];
            var CheckValue = trim_Cross(GetAttribute(tr, "DATA2"));
            if (CheckValue != pUserID || pOrgDocID == "REDRAFT") {
                var pAlertContent = strLang408;
                OpenAlertUI(pAlertContent);
                return;
            }
            else {
                var pInformationContent = "" + strLang406 + "";
                var Rtnval = OpenInformationUI(pInformationContent, deleteOpinion_Complete);
                if (!CrossYN() && Rtnval) {
                    var selIdx = GetAttribute(tr, "id");
                    OpinionList.DeleteRow(selIdx);
                    document.getElementById("txt_OpinionContent").value = "";
                    document.getElementById("btn_OpinionAdd").textContent = strLang389;
                    document.getElementById("btn_OpinionCancel").textContent = strLang397;
                    OpinionAddFlag = 0;
                }
            }
        }
    } catch (e) {
        alert("deleteOpinionInfo ::" + e.description);
    }
}

function deleteOpinion_Complete(Rtnval) {
    DivPopUpHidden();
    if (Rtnval) {
        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");
        var pSelectedRow = OpinionList.GetSelectedRows();
        var tr = pSelectedRow[0];

        var selIdx = GetAttribute(tr, "id");
        OpinionList.DeleteRow(selIdx);
        document.getElementById("txt_OpinionContent").value = "";
        document.getElementById("btn_OpinionAdd").textContent = strLang389;
        document.getElementById("btn_OpinionCancel").textContent = strLang397;
        OpinionAddFlag = 0;
    }
}

function saveOpinionInfo() {
    try {
        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        var selRow = OpinionList.GetDataRows();

        if (selRow.length == 0 && document.getElementById("btn_OpinionAdd").textContent == strLang389 && document.getElementById("txt_OpinionContent").value == "")// 의견목록에 사용자가 추가한지 여부 판단      
        {
            if ((pDisplay == "BanSong" || pDisplay == "HeSong" || pDisplay == "BoRyu") && document.getElementById("btn_OpinionCancel").textContent != strLang407) {
                var pAlertContent = GetOpinionTypeName(pOpinionType) + strLang410;
                OpenAlertUI(pAlertContent);
                return;
            }
            else {
                var Rtnval = removeOpinionInfo();
                if (Rtnval != "TRUE") {
                    var pAlertContent = strLang199;
                    OpenAlertUI(pAlertContent);
                    return;
                }
                if (ReturnFunction != null) {
                    ReturnFunction("<LISTVIEWDATA><ROWS><RTN>Clear</RTN></ROWS></LISTVIEWDATA>");
                    window.close();
                }
                else {
                    window.returnValue = "<LISTVIEWDATA><ROWS><RTN>Clear</RTN></ROWS></LISTVIEWDATA>";
                    window.close();
                }
            }
        }
        else if (document.getElementById("btn_OpinionAdd").textContent == strLang389 && document.getElementById("txt_OpinionContent").value != "" && pDisplay != "Show") {
            var pInformationContent = strLang411;
            var Rtnval = OpenInformationUI(pInformationContent, saveOpinionInfo_Complete);
            if (!CrossYN() && Rtnval) {
                if (trim(document.getElementById("txt_OpinionContent").value) == "") {
                    var pAlertContent = strLang412 + "<br>" + strLang413;
                    OpenAlertUI(pAlertContent);
                    return;
                }
                else {
                    autosaveOpinionXMLInfo();
                }
            }
        }
        else if (pDisplay == "HeSong") {
            if (trim(document.getElementById("txt_OpinionContent").value) == "" && OpinionAddFlag == "0") {
                var pAlertContent = GetOpinionTypeName(pOpinionType) + strLang410;
                OpenAlertUI(pAlertContent);
                return;
            }
            else {
                saveHesoungOpinionXMLInfo();
            }
        }
        else {
            saveOpinionXMLInfo();
        }
    } catch (e) {
        alert("saveOpinionInfo :: " + e.description);
    }
}

function saveOpinionInfo_Complete(Rtnval) {
    DivPopUpHidden();
    if (Rtnval) {
        if (trim(document.getElementById("txt_OpinionContent").value) == "") {
            var pAlertContent = strLang412 + "<br>" + strLang413;
            OpenAlertUI(pAlertContent);
            return;
        }
        else {
            autosaveOpinionXMLInfo();0
        }
    }
}

function DoOpinionDisplay() {

}

function removeOpinionInfo() {
    try {
    	var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/opinionDel.do",
    		data : {
    			docID : pDocID
    		},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
        
        var dataNodes = GetChildNodes(loadXMLString(result));
        var RtnVal = getNodeText(dataNodes[0]);
        
        return RtnVal;

    } catch (e) {
        alert("removeOpinionInfo :: " + e.description);
    }

}

function AutoSaveOpinionInfo(pContent) {
    var GetXml;

    var OpinionList = new ListView();
    OpinionList.LoadFromID("OpinionList");

    var pOpinionLen = OpinionList.GetDataRows().length;
    var pAddIndex = pOpinionLen + 1;

    GetXml = "<LISTVIEWDATA><HEADERS>";
    GetXml = GetXml + "<HEADER><NAME>" + strLang31 + "</NAME><WIDTH>80</WIDTH></HEADER>";
    GetXml = GetXml + "<HEADER><NAME>" + strLang29 + "</NAME><WIDTH>76</WIDTH></HEADER>";
    GetXml = GetXml + "<HEADER><NAME>" + strLang28 + "</NAME><WIDTH>91</WIDTH></HEADER>";
    GetXml = GetXml + "<HEADER><NAME>" + strLang32 + "</NAME><WIDTH>114</WIDTH></HEADER>";
    GetXml = GetXml + "</HEADERS><ROWS>";
    GetXml = GetXml + "<ROW>";
    GetXml = GetXml + "<COLUMN>" + GetOpinionTypeName(pOpinionType) + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + arr_userinfo[2] + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + arr_userinfo[3] + "</COLUMN>";
    GetXml = GetXml + "<COLUMN>" + arr_userinfo[5] + "</COLUMN>";
    GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
    GetXml = GetXml + "<DATA name='UserID'>" + pUserID + "</DATA>";
    GetXml = GetXml + "<DATA name='Content'>" + pContent + "</DATA>";
    GetXml = GetXml + "<DATA name='UserDeptID'>" + arr_userinfo[4] + "</DATA>";
    GetXml = GetXml + "<DATA name='OpinionSN'>" + pAddIndex + "</DATA>";
    GetXml = GetXml + "</ROW>";
    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";

    return GetXml;
}

function autosaveOpinionXMLInfo() {
    try {
        var OpSaveXml;
        var pTotalRows;
        var pstrXML;

        var objXML = createXmlDom();
        var xmlhttp = new createXMLHttpRequest();

        pstrXML = getAprOpinionXML(document.getElementById("txt_OpinionContent").value)
        objXML = loadXMLString(pstrXML);

        var OpinionList = new ListView();
        OpinionList.LoadFromID("OpinionList");

        pTotalRows = OpinionList.GetDataRows();
        if (pTotalRows.length == 0) {
            if (document.getElementById("OPINION").innerHTML != "")
                document.getElementById("OPINION").innerHTML = "";

            OpinionList = new ListView();
            OpinionList.SetID("OpinionList");
            OpinionList.SetMulSelectable(false);

            OpinionList.SetRowOnClick("OPINIONOnSelChange_onclick");
            OpinionList.DataSource(objXML);
            OpinionList.DataBind("OPINION");
        } else {
            var objTr = OpinionList.AddRow(pTotalRows.length);
            objTr.setAttribute("id", "OpinionList" + "_TR_" + pTotalRows.length);
            OpinionList.AddDataRow(objTr, objXML);
        }

        objXML = getOpinionListInfo();
        xmlhttp.open("Post", "/ezApprovalG/opinionSave.do", false);
        xmlhttp.send(objXML);

        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        var RtnVal = getNodeText(dataNodes[0]);
        if (RtnVal != "TRUE") {
            var pAlertContent = strLang416;
            OpenAlertUI(pAlertContent);
            return;
        } else {
            if (ReturnFunction != null) {
                ReturnFunction(getXmlString(objXML));
                window.close();
            }
            else {
                window.returnValue = getXmlString(objXML);
                window.close();
            }
            return;
        }
    } catch (e) {
        alert("autosaveOpinionXMLInfo :: " + e.description);
    }
}

function saveHesoungOpinionXMLInfo() {
    try {

        if (OpinionAddFlag == 0) {
            if (ReturnFunction != null) {
                ReturnFunction("Clear");
                window.close();
            }
            else {
                window.returnValue = "Clear";
                window.close();
            }
        }
        else {
            var pstrXML;
            var objXML = createXmlDom();
            var xmlhttp = new createXMLHttpRequest();
            var OpSaveState;

            if (OpinionModifyFlag) {
                var OpinionList = new ListView();
                OpinionList.LoadFromID("OpinionList");

                var pTotalRows = OpinionList.GetDataRows();;

                if (pTotalRows.length != "0") {
                    var pSelectedRow = OpinionList.GetSelectedRows();
                    if (pSelectedRow.length != "0") {
                        var tr = pSelectedRow[0];
                        tr.cells[0].innerHTML = GetOpinionTypeName(pOpinionType);
                        SetAttribute(tr, "DATA6", pOpinionType);

                        if (g_OpinionModifyFlagAdd)
                            SetAttribute(tr, "DATA3", document.getElementById("txt_OpinionContent").value);
                    }
                    else {
                        var i;
                        for (i = 0 ; i < pTotalRows.length ; i++) {
                            if (trim_Cross(GetAttribute(tr, "DATA2")) == pUserID) {
                                tr.cells[0].innerHTML = GetOpinionTypeName(pOpinionType);
                                SetAttribute(tr, "DATA6", pOpinionType);
                                SetAttribute(tr, "DATA3", document.getElementById("txt_OpinionContent").value);
                                break;
                            }
                        }
                    }
                }
            }
            objXML = getOpinionListInfo();
            xmlhttp.open("Post", "/ezApprovalG/opinionSave.do", false);
            xmlhttp.send(objXML);

            var dataNodes = GetChildNodes(xmlhttp.responseXML);
            var RtnVal = getNodeText(dataNodes[0]);
            if (RtnVal != "TRUE") {
                var pAlertContent = strLang417;
                OpenAlertUI(pAlertContent);
                return;
            }
            else {
                if (ReturnFunction != null) {
                    ReturnFunction("add");
                    window.close();
                }
                else {
                    window.returnValue = "add";
                    window.close();
                }
                return;
            }
        }
    } catch (e) {
        alert("saveHesoungOpinionXMLInfo :: " + e.description);
    }
}

function saveOpinionXMLInfo() {
    try {
        var pstrXML;
        var OpSaveState;
        var objXML = createXmlDom();
        if (OpinionModifyFlag) {
            var OpinionList = new ListView();
            OpinionList.LoadFromID("OpinionList");

            var pTotalRows = OpinionList.GetDataRows();

            if (pTotalRows.length != "0") {
                var pSelectedRow = OpinionList.GetSelectedRows();;

                if (pSelectedRow.length != "0") {
                    var tr = pSelectedRow[0];
                    tr.cells[0].innerHTML = GetOpinionTypeName(pOpinionType);
                    SetAttribute(tr, "DATA6", pOpinionType);

                    if (g_OpinionModifyFlagAdd)
                        SetAttribute(tr, "DATA3", document.getElementById("txt_OpinionContent").value);
                }
                else {
                    var i;
                    for (i = 0 ; i < pTotalRows.length ; i++) {
                        if (GetAttribute(tr, "DATA2") == pUserID) {
                            tr.cells[0].innerHTML = GetOpinionTypeName(pOpinionType);
                            SetAttribute(tr, "DATA6", pOpinionType);
                            SetAttribute(tr, "DATA3", document.getElementById("txt_OpinionContent").value);
                            break;
                        }
                    }
                }
            }
        }
        objXML = getOpinionListInfo();
        var xmlhttp = new createXMLHttpRequest();
        xmlhttp.open("Post", "/ezApprovalG/opinionSave.do", false);
        xmlhttp.send(objXML);

        var dataNodes = GetChildNodes(xmlhttp.responseXML);
        var RtnVal = getNodeText(dataNodes[0]);
        if (RtnVal != "TRUE") {
            var pAlertContent = strLang417;
            OpenAlertUI(pAlertContent);
            return;

        } else {
            if (btn_OpinionCancel.textContent == strLang407) {
                if (ReturnFunction != null) {
                    ReturnFunction("cancel");
                    window.close();
                }
                else {
                    window.returnValue = "cancel";
                    window.close();
                }
            }
            else {
                if (ReturnFunction != null) {
                    ReturnFunction(getXmlString(objXML));
                    window.close();
                }
                else {
                    window.returnValue = getXmlString(objXML);
                    window.close();
                }
            }
            return;
        }
    } catch (e) {
        alert("saveOpinionXMLInfo :: " + e.description);
    }
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


function GetOpinionTypeName(strOType) {
    switch (strOType) {
        case strOpinionType2:
            return strLangOpinionType2;
            break;
        case strOpinionType3:
            return strLangOpinionType3;
            break;
        case strOpinionType4:
            return strLangOpinionType4;
            break;
        case strOpinionType1:
        default:
            return strLangOpinionType1;
            break;
    }
}