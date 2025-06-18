var eopi = "false";
var eattach = "false";
var balsongopi = "";
var tempType;
function PrintClick(Type, DocID, Mode) {
    var rtnVal = "";
    tempType = Type;
    if (Mode != "") {
        rtnVal = getdetail(DocID, Mode);
    }

    if ((CrossYN()) || rtnVal == "close")
        if (Mode != "")
            return;

    var bodycontent = "";
    if (typeof draftAllFlag != "undefined" && draftAllFlag == "Y")
        bodycontent = document.getElementById("ifrm" + currentTabIdx).contentWindow.Get_EditorBodyHTML() + rtnVal;
    else if (Type == "FormProc") {
        bodycontent = pzFormProc.Editor.DOM.body.innerHTML + rtnVal;
    }
    else if (Type == "Cross") {
        bodycontent = message.Get_EditorBodyHTML() + rtnVal;
    }
    else if (Type == "Enforce") {
        bodycontent = message2.Get_EditorBodyHTML() + rtnVal;
    }

    PrtBodyContent = bodycontent;
    var feature = "width=800, height=500, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
    // feature = feature + GetOpenPosition(800, 500);
    showPopup("/ezApprovalG/ezApprovalPrint.do", 800, 500, "", feature, "");
}
/**
 * [인쇄]
 * 작성된 '의견' 내용 불러오기
 * */
function addOpinion(DocID, pFlag) {
	var rowidx, rtnString, colidx;
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
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

    xmlrtn = loadXMLString(result);
    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    if (Rows.length == 0) {
        eopi = "false";
    }

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eopi = "true";

        rtnString = rtnString + "<TR style='height:25px'>";
        for (colidx = 0; colidx < GetChildNodes(Rows[rowidx]).length; colidx++) {
            if (colidx == 0)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px;' bgColor=#f8f8fa align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 1)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 3)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:30px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else if (colidx == 4)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:100px' align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:373px'>" + MakeXMLString(getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0])) + "</TD>";
        }
        rtnString = rtnString + "</TR>";
    }

    if (balsongopi != "") {
        eopi = "true";
    }

    return rtnString;
}
/**
 * [인쇄]
 * 첨부정보 추출
 * */
function addAttach(DocID, pFlag) {
    var rowidx, rtnString, colidx;
	var result = "";
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	
   	  $.ajax({
   			type : "POST",
   			dataType : "text",
   			async : false,
   			url : "/ezApprovalG/getLineMode.do",
   			data : {
   					docID : DocID,
   					orgCompanyID : orgCompanyID
   					},
   			success: function(xml){
   				pFlag = xml;
   			}        			
   	  });
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getTotalAttachInfo.do",
		data : {
			docID : DocID,
			mode  : pFlag,
			orgCompanyID : orgCompanyID
		},
		success: function(xml){
			result = xml;
		}        			
	});
	
    xmlrtn = loadXMLString(result);
    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    if (Rows.length == 0)
        eattach = "false";

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eattach = "true";

        rtnString = rtnString + "<TR style='height:25px'><TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' width=60 bgColor=#f8f8fa align=center>";

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
    
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getLineList.do",
		data : {
			docID : DocID,
			mode  : pFlag,
			orgCompanyID : orgCompanyID
		},
		success: function(xml){
			result = xml;
		}        			
	});

    xmlrtn = loadXMLString(result);

    var Rows = SelectNodes(xmlrtn, "LISTVIEWDATA/ROWS/ROW");
    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        rtnString = rtnString + "<TR style='height:25px'>";

        for (colidx = 0; colidx < 7; colidx++) {

            if (getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) != "") {
                if (colidx == 0)
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;' width=60 bgColor=#f8f8fa align=center>" + getNodeText(GetChildNodes(GetChildNodes(Rows[rowidx])[colidx])[0]) + "</TD>";
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

function summaryForPrint(DocID, pFlag) {
    var rowidx, rtnString, colidx;
    var result = "";
    
	if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING") {
		pFlag = "APR";
	} else {
		pFlag = "END";
	}
	
	$.ajax({
		type : "GET",
		async : false,
		url : "/ezApprovalG/printContentApprGSummary.do",
		data : {
			docID : DocID,
			mode  : pFlag
		},
		success: function(xml){
            var path = xml;
            
            var summaryContentHtml = ConvertMHTtoHTML(path);
            var tempXML = loadXMLString(summaryContentHtml);
            var XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
            result = getNodeText(XmlBodyDATA);
		}        			
	});
    return "<TR><TD>" + result + "</TD></TR>";
}

var temptextOpi;
var temptextAttatch;
var tempDocID;
var temppFlag;
function getdetail(DocID, pFlag) {
    var textOpi = addOpinion(DocID, pFlag);     // 의견정보 추출
    var textAttatch = addAttach(DocID, pFlag);  // 첨부정보 추출
    
    if (CrossYN()) {
        temptextOpi = textOpi;
        temptextAttatch = textAttatch;
        tempDocID = DocID;
        temppFlag = pFlag;
    }
    var ret = OpenQuestionUI();
    if ((CrossYN()) || !ret)
        return;

    if (ret[0] == "0" && ret[1] == "0" && ret[2] == "0")
        return "close";
    var rtnVal = "";
    
    /* 2020-07-09 홍승비 - 전자결재문서 인쇄 시, 하단 정보 영역의 폰트 스타일 수정 (다국어 css의 기본 폰트를 따라가도록 함) */
    if (ret[0] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='5'><P>" + "▶ " + strLan880 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textOpi;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[1] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='4'><P>" + "▶ " + strLang1148 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textAttatch;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[2] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ " + strLang1149 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + addLineInfo(DocID, pFlag);
        rtnVal = rtnVal + "</table>";
    }
    if (ret[3] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ " + strLang1149 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + summaryForPrint(DocID, pFlag); // 요약전정보 추출
        rtnVal = rtnVal + "</table>";
    }

    return rtnVal;
}

var ezprtquestion_cross_dialogArguments = new Array();
/**
 * [인쇄]
 * 범위 옵션 화면 출력
 * ex) 의견정보, 첨부정보, 결재선정보, 요약전정보
 * */
function OpenQuestionUI() {
    var parameter = "";
    var url = "/ezApprovalG/ezprtQuestion.do?opinion=" + encodeURI(eopi) + "&attach=" + encodeURI(eattach);

    if (CrossYN()) {
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
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='5'><P>" + "▶ " + strLang880 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + temptextOpi;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[1] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='4'><P>" + "▶ " + strLang1148 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + temptextAttatch;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[2] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ " + strLang1149 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + addLineInfo(tempDocID, temppFlag);
        rtnVal = rtnVal + "</table>";
    }
    if (ret[3] == "Y") {
        rtnVal = rtnVal + "<table style='font-family:" + strLangHSBPR01 + "; font-size:9pt; BORDER-COLLAPSE: collapse; width:625px ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ " + strLangJIH_Summary05 + " ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + summaryForPrint(tempDocID, temppFlag);// 요약전정보 추출
        rtnVal = rtnVal + "</table>";
    }
    
    var bodycontent = "";
    if (typeof draftAllFlag != "undefined" && draftAllFlag == "Y")
        bodycontent = document.getElementById("ifrm" + currentTabIdx).contentWindow.Get_EditorBodyHTML() + rtnVal;
    else if (tempType == "FormProc")
        bodycontent = pzFormProc.Editor.DOM.body.innerHTML + rtnVal;
    else if (tempType == "Cross")
        bodycontent = message.Get_EditorBodyHTML() + rtnVal;
    else if (tempType == "Enforce")
        bodycontent = message2.Get_EditorBodyHTML() + rtnVal;

    PrtBodyContent = bodycontent;
    var feature = "width=800, height=500, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1, background=#fff";
    feature = feature + GetOpenPosition(800, 500);
    showPopup("/ezApprovalG/ezApprovalPrint.do", 800, 500, "", feature, "");
}
