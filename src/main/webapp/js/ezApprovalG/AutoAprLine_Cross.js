function getAutoAprLine() {
    try {
        getFormRecv();

        var retvalue = new Array();
        retvalue[0] = "NONE";
        retvalue[1] = "NONE";
        retvalue[2] = "R";
        retvalue[3] = "";

        var xmlhttp = createXMLHttpRequest();
        var result = "";
        
        $.ajax({
    		type : "POST",
    		dataType : "xml",
    		async : false,
    		url : "/ezApprovalG/aprLineRequest.do",
    		data : {
    				docID    : pDocID, 
    				userID 	 : pUserID,
    				formID   : pFormID
    				},
    		success: function(xml){
    			result = xml;
    		}        			
    	});
        
        var NodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");
        if (NodeList.length > 0) {
            var Resultxml = APRLINEXMLParsing(result);
            xmlhttp.open("Post", "/ezApprovalG/aprLineSave.do", false);
            xmlhttp.send(Resultxml);

            var ret = SelectSingleNodeValue(xmlhttp.responseXML, "RESULT");
            if (ret == "TRUE") {
                retvalue[0] = getXmlString(Resultxml);
                return retvalue;
            }
        }
        return retvalue;

    } catch (e) {
        alert("getAutoAprLine :: " + e.description);
    }
}

function APRLINEXMLParsing(APRLINE) {
    var AprLineRow = SelectNodes(APRLINE, "LISTVIEWDATA/ROWS/ROW");
    var CurListLen = AprLineRow.length;
    var CurCell = GetChildNodes(AprLineRow[0]);
    var CurCellLen = CurCell.length;
    var i;
    var j;
    var k = 0;
    var GetXml;
    var AprLineTotalLen;
    AprLineTotalLen = CurListLen;

    GetXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + strLang331 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang29 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang32 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang61 + "</NAME><WIDTH>150</WIDTH></HEADER><HEADER><NAME>" + strLang125 + "</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>" + strLang332 + "</NAME><WIDTH>120</WIDTH></HEADER><HEADER><NAME>" + strLang333 + "</NAME><WIDTH>120</WIDTH></HEADER></HEADERS>";
    GetXml = GetXml + "<ROWS>";

    for (i = 0 ; i < CurListLen ; i++) {
        var Row = AprLineRow[i];
        var Cell = GetChildNodes(Row);
        if (i == CurListLen - 1) {
            GetXml = GetXml + "<ROW>";
            GetXml = GetXml + "<COLUMN>" + (AprLineTotalLen - k) + "</COLUMN>";
            GetXml = GetXml + "<COLUMN>" + SelectSingleNodeValue(Cell[1], "VALUE") + "</COLUMN>";
            GetXml = GetXml + "<COLUMN>" + arr_userinfo[3] + "</COLUMN>";
            GetXml = GetXml + "<COLUMN>" + MakeXMLString(arr_userinfo[5]) + "</COLUMN>";
            GetXml = GetXml + "<COLUMN>" + SelectSingleNodeValue(Cell[4], "VALUE") + "</COLUMN>";
            GetXml = GetXml + "<COLUMN>" + SelectSingleNodeValue(Cell[5], "VALUE") + "</COLUMN>";

            GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
            GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
            GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA4")) + "</DATA>";
            GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + SelectSingleNodeValue(Cell[0], "DATA5") + "</DATA>";
            GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + arr_userinfo[4] + "</DATA>";
            GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA7")) + "</DATA>";
            GetXml = GetXml + "<DATA name='isProposerYN'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA8")) + "</DATA>";
            GetXml = GetXml + "<DATA name='isBriefUserYN'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA9")) + "</DATA>";
            GetXml = GetXml + "<DATA name='isCompanyID'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA10")) + "</DATA>";

            GetXml = GetXml + "<DATA name='AprType'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA11")) + "</DATA>";
            if (MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA12")) == "001")
                GetXml = GetXml + "<DATA name='AprState'>002</DATA>"; //기안자는 진행으로 표시
            else
                GetXml = GetXml + "<DATA name='AprState'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA12")) + "</DATA>";
            GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA13")) + "</DATA>";		
            GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA14")) + "</DATA>";		
            GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA15")) + "</DATA>";		
            GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA16")) + "</DATA>";	
            GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA17")) + "</DATA>";	
            GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA18")) + "</DATA>";	

            GetXml = GetXml + "</ROW>";

        }
        else {
            GetXml = GetXml + "<ROW>";
            GetXml = GetXml + "<COLUMN>" + (AprLineTotalLen - k) + "</COLUMN>";
            for (j = 1 ; j < CurCellLen - 1; j++)
                GetXml = GetXml + "<COLUMN>" + MakeXMLString(getNodeText(Cell[j])) + "</COLUMN>";

            GetXml = GetXml + "<DATA name='ProcessDate'></DATA>";
            GetXml = GetXml + "<DATA name='ReceivedDate'></DATA>";
            GetXml = GetXml + "<DATA name='DocID'>" + pDocID + "</DATA>";
            GetXml = GetXml + "<DATA name='AprMemberID'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA4")) + "</DATA>";
            GetXml = GetXml + "<DATA name='AprmemberIsDeptYN'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA5")) + "</DATA>";
            GetXml = GetXml + "<DATA name='AprMemberDeptID'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA6")) + "</DATA>";
            GetXml = GetXml + "<DATA name='ReasonDoNotApprov'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA7")) + "</DATA>";
            GetXml = GetXml + "<DATA name='isProposerYN'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA8")) + "</DATA>";
            GetXml = GetXml + "<DATA name='isBriefUserYN'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA9")) + "</DATA>";
            GetXml = GetXml + "<DATA name='isCompanyID'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA10")) + "</DATA>";
            GetXml = GetXml + "<DATA name='AprType'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA11")) + "</DATA>";
            GetXml = GetXml + "<DATA name='AprState'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA12")) + "</DATA>";
            GetXml = GetXml + "<DATA name='PMemberName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA13")) + "</DATA>";		
            GetXml = GetXml + "<DATA name='SMemberName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA14")) + "</DATA>";		
            GetXml = GetXml + "<DATA name='PMemberDeptName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA15")) + "</DATA>";		
            GetXml = GetXml + "<DATA name='SMemberDeptName'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA16")) + "</DATA>";	
            GetXml = GetXml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA17")) + "</DATA>";	
            GetXml = GetXml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(SelectSingleNodeValue(Cell[0], "DATA18")) + "</DATA>";	

            GetXml = GetXml + "</ROW>";
        }
        k = k + 1;
    }

    GetXml = GetXml + "</ROWS></LISTVIEWDATA>";

    var TmpAprLineState = "002";
    TmpAprLineState = strLang18;
    var ChangeXml = createXmlDom();
    ChangeXml = loadXMLString(GetXml);
    var NodeList = SelectNodes(ChangeXml, "LISTVIEWDATA/ROWS/ROW");
    if (NodeList.length != 0) {
        var pDraftDay = getGyulJeDate();
        var child = GetChildNodes(NodeList[NodeList.length - 1]);
        setNodeText(child[5], TmpAprLineState);
        setNodeText(child[7], pDraftDay);
    }
    return ChangeXml;
}

function MakeXMLString(p_str) {
    p_str = ReplaceText(p_str, "&", "&amp;");
    p_str = ReplaceText(p_str, "<", "&lt;");
    p_str = ReplaceText(p_str, ">", "&gt;");
    return p_str;
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}

function getGyulJeDate() {
    var GyulJeDate;
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);

    xmlhttp.open("POST", "../aspx/GetDate.aspx", false);
    xmlhttp.send(xmlpara);
    GyulJeDate = xmlhttp.responseText;
    return GyulJeDate;
}


function getFormRecv() {
	var result = "";

	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getFormRecv.do",
		data : {
				docID    : pDocID, 
				formID   : pFormID
				},
		success: function(xml){
			result = xml;
		}        			
	});

    setRecevInfo(result);
}
