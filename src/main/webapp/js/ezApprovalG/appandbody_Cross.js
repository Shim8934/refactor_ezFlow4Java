var eopi = "false";
var eattach = "false";
var balsongopi = "";
var tempType;
function PrintClick(Type, DocID, Mode) {
    var rtnVal = "";
    tempType = Type;
    if (Mode != "")
        rtnVal = getdetail(DocID, Mode);

    if ((CrossYN() || NonActiveX == "YES") || rtnVal == "close")
        if (Mode != "")
            return;

    var bodycontent = "";
    if (Type == "FormProc")
        bodycontent = pzFormProc.Editor.DOM.body.innerHTML + rtnVal;
    else if (Type == "Cross")
        bodycontent = message.Get_EditorBodyHTML() + rtnVal;
    else if (Type == "Enforce")
        bodycontent = message2.Get_EditorBodyHTML() + rtnVal;

    PrtBodyContent = bodycontent;
    var feature = "width=800, height=500, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
    feature = feature + GetOpenPosition(800, 500);
    window.open("/ezApprovalG/ezApprovalPrint.do", "", feature);
}

function addOpinion(DocID, pFlag) {
	var rowidx, rtnString, colidx;
	var pFlag = "";
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getOpinionInfo.do",
		data : {
			docID : DocID,
			mode  : pFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});

    xmlrtn = result;
    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    if (Rows.length == 0)
        eopi = "false";

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eopi = "true";

        rtnString = rtnString + "<TR style='height:25px'>";
        for (colidx = 0; colidx < GetChildNodes(Rows[rowidx]).length; colidx++) {
            if (colidx == 0)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px;' bgColor=#d2e2fd align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 1)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 3)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:30px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 4)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:100px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:373px'>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
        }
        rtnString = rtnString + "</TR>";
    }

    if (balsongopi != "")
        eopi = "true";

    return rtnString;
}
function addAttach(DocID, pFlag) {
    var rowidx, rtnString, colidx;
	var result = "";
	var pFlag = "";
	
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getTotalAttachInfo.do",
		data : {
			docID : DocID,
			mode  : pFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    xmlrtn = result;
    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    if (Rows.length == 0)
        eattach = "false";

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eattach = "true";

        rtnString = rtnString + "<TR style='height:25px'><TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' width=60 bgColor=#d2e2fd align=center>";

        for (colidx = 0; colidx < GetChildNodes(Rows[rowidx]).length; colidx++) {

            if (colidx == 0)
                rtnString = rtnString + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
        }
        rtnString = rtnString + "</TR>";
    }
    return rtnString;
}

function addLineInfo(DocID, pFlag) {
    var rowidx, rtnString, colidx;
    var result = "";
	var pFlag = "";
	
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : "/ezApprovalG/getLineList.do",
		data : {
			docID : DocID,
			mode  : pFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});

    xmlrtn = result;

    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        rtnString = rtnString + "<TR style='height:25px'>";

        for (colidx = 0; colidx < 7; colidx++) {

            if (getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) != "") {
                if (colidx == 0)
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;' width=60 bgColor=#d2e2fd align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
                else if (colidx == 1)
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;' width=60 align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
                else
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            }
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
        }
        rtnString = rtnString + "</TR>";
    }
    return rtnString;
}

var temptextOpi;
var temptextAttatch;
var tempDocID;
var temppFlag;
function getdetail(DocID, pFlag) {
    var textOpi = addOpinion(DocID, pFlag);
    var textAttatch = addAttach(DocID, pFlag);

    if (CrossYN() || NonActiveX == "YES") {
        temptextOpi = textOpi;
        temptextAttatch = textAttatch;
        tempDocID = DocID;
        temppFlag = pFlag;
    }
    var ret = OpenQuestionUI();
    if ((CrossYN() || NonActiveX == "YES") || !ret)
        return;

    if (ret[0] == "0" && ret[1] == "0" && ret[2] == "0")
        return "close";
    var rtnVal = "";

    if (ret[0] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='5'><P>" + "▶ 의견 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textOpi;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[1] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='4'><P>" + "▶ 첨부 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textAttatch;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[2] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ 결재선 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + addLineInfo(DocID, pFlag);
        rtnVal = rtnVal + "</table>";
    }

    return rtnVal;
}

var ezprtquestion_cross_dialogArguments = new Array();
function OpenQuestionUI() {
    var parameter = "";
    var url = "/ezApprovalG/ezprtQuestion.do?opinion=" + encodeURI(eopi) + "&attach=" + encodeURI(eattach);

    if (CrossYN() || NonActiveX == "YES") {
        ezprtquestion_cross_dialogArguments[0] = parameter;
        ezprtquestion_cross_dialogArguments[1] = OpenQuestionUI_Complete;

        DivPopUpShow(380, 260, url);
    }
    else {
        var feature = "status:no;dialogWidth:380px;dialogHeight:260px;help:no;";
        feature = feature + GetShowModalPosition(380, 260);
        var RtnVal = window.showModalDialog(url, parameter, feature);

        return RtnVal;
    }
}

function OpenQuestionUI_Complete(ret) {
    DivPopUpHidden();

    if (ret[0] == "0" && ret[1] == "0" && ret[2] == "0")
        return;
    var rtnVal = "";

    if (ret[0] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='5'><P>" + "▶ 의견 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + temptextOpi;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[1] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='4'><P>" + "▶ 첨부 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + temptextAttatch;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[2] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ 결재선 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + addLineInfo(tempDocID, temppFlag);
        rtnVal = rtnVal + "</table>";
    }

    var bodycontent = "";
    if (tempType == "FormProc")
        bodycontent = pzFormProc.Editor.DOM.body.innerHTML + rtnVal;
    else if (tempType == "Cross")
        bodycontent = message.Get_EditorBodyHTML() + rtnVal;
    else if (tempType == "Enforce")
        bodycontent = message2.Get_EditorBodyHTML() + rtnVal;

    PrtBodyContent = bodycontent;
    var feature = "width=800, height=500, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
    feature = feature + GetOpenPosition(800, 500);
    window.open("/ezApprovalG/ezApprovalPrint.do", "", feature);
}