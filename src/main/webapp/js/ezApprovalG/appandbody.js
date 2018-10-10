var eopi = "false"
var eattach = "false"
var balsongopi = ""

function PrintClick(Type, DocID, Mode) {
    var rtnVal = "";
    if (Mode != "")
        rtnVal = getdetail(DocID, Mode);

    if (rtnVal == "close")
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
    window.open("/myoffice/ezApprovalG/printer/ezApproval_Print.aspx", "", feature);
}

function GetOpenPosition(popUpW, popUpH) {
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;

    left = pleftpos / 2;
    top = heigth / 2;

    var feature = ",left=" + left + ",top=" + top;

    return feature
}

function addOpinion(DocID, pFlag) {
    var rowidx, rtnString, colidx;

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlrtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", DocID);

    if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING")
        createNodeAndInsertText(xmlpara, objNode, pFlag, "APR");
    else
        createNodeAndInsertText(xmlpara, objNode, pFlag, "END");

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getOpinionInfo.aspx", false);
    xmlhttp.send(xmlpara);

    xmlrtn = loadXMLString(xmlhttp.responseText);

    var Rows = xmlrtn.selectNodes("LISTVIEWDATA/ROWS/ROW");

    if (Rows.length == 0)
        eopi = "false"

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eopi = "true";

        rtnString = rtnString + "<TR style='height:25px'>";

        for (colidx = 0; colidx < Rows(rowidx).childNodes.length; colidx++) {
            if (colidx == 0)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px;' bgColor=#f8f8fa align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
            else if (colidx == 1)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:60px' align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
            else if (colidx == 3)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:30px' align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
            else if (colidx == 4)
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:100px' align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid; width:373px'>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
        }
        rtnString = rtnString + "</TR>";
    }

    if (balsongopi != "")
        eopi = "true";

    return rtnString;
}

function addAttach(DocID, pFlag) {
    var rowidx, rtnString, colidx;

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlrtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", DocID);
    if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING")
        createNodeAndInsertText(xmlpara, objNode, pFlag, "APR");
    else
        createNodeAndInsertText(xmlpara, objNode, pFlag, "END");


    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getTotalAttachInfo.aspx", false);
    xmlhttp.send(xmlpara);

    xmlrtn = loadXMLString(xmlhttp.responseText);

    var Rows = xmlrtn.selectNodes("LISTVIEWDATA/ROWS/ROW");

    if (Rows.length == 0)
        eattach = "false"

    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {
        eattach = "true";

        rtnString = rtnString + "<TR style='height:25px'><TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' width=60 bgColor=#f8f8fa align=center>";

        for (colidx = 0; colidx < Rows(rowidx).childNodes.length; colidx++) {

            if (colidx == 0)
                rtnString = rtnString + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
        }
        rtnString = rtnString + "</TR>";
    }
    return rtnString;
}

function addLineInfo(DocID, pFlag) {
    var rowidx, rtnString, colidx;

    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var xmlrtn = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "pDocID", DocID);
    if (pFlag.toUpperCase() == "APR" || pFlag.toUpperCase() == "ING")
        createNodeAndInsertText(xmlpara, objNode, pFlag, "APR");
    else
        createNodeAndInsertText(xmlpara, objNode, pFlag, "END");

    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezLine/aspx/GetLineList.aspx", false);
    xmlhttp.send(xmlpara);

    xmlrtn = loadXMLString(xmlhttp.responseText);

    var Rows = xmlrtn.selectNodes("LISTVIEWDATA/ROWS/ROW");
    rtnString = "";
    for (rowidx = 0; rowidx < Rows.length; rowidx++) {

        rtnString = rtnString + "<TR style='height:25px'>";

        for (colidx = 0; colidx < 7; colidx++) {

            if (getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) != "") {
                if (colidx == 0)
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;' width=60 bgColor=#f8f8fa align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
                else if (colidx == 1)
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid;' width=60 align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
                else
                    rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
            }
            else
                rtnString = rtnString + "<TD style='BORDER-BOTTOM: black 1px solid; BORDER-LEFT: black 1px solid; BORDER-TOP: black 1px solid; BORDER-RIGHT: black 1px solid' align=center>" + getNodeText(Rows(rowidx).childNodes(colidx).childNodes(0)) + "</TD>"
        }
        rtnString = rtnString + "</TR>";
    }
    return rtnString;

}

function getdetail(DocID, pFlag) {
    var textOpi = addOpinion(DocID, pFlag);
    var textAttatch = addAttach(DocID, pFlag);
    var ret = OpenQuestionUI();
    if (!ret)
        return;

    if (ret[0] == "0" && ret[1] == "0" && ret[2] == "0")
        return "close";

    var rtnVal = "";;

    if (ret[0] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:97%; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='5'><P>" + "▶ 의견 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textOpi;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[1] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:97% ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='4'><P>" + "▶ 첨부 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + textAttatch;
        rtnVal = rtnVal + "</table>";
    }
    if (ret[2] == "Y") {
        rtnVal = rtnVal + "<table style='font-style:굴림체; font-size:9pt; BORDER-COLLAPSE: collapse; width:97% ; margin-left:11px'>";
        rtnVal = rtnVal + "<TR><TD style='height:30px; padding-top:10px' colspan='7'><P>" + "▶ 결재선 정보 ◀" + "</P></TD></TR>";
        rtnVal = rtnVal + addLineInfo(DocID, pFlag);
        rtnVal = rtnVal + "</table>";
    }

    return rtnVal;
}

function OpenQuestionUI() {
    var parameter = ""
    var url = "/myoffice/ezApprovalG/printer/ezprtQuestion.aspx?opinion=" + escape(eopi) + "&Attach=" + escape(eattach);
    var feature = "status:no;dialogWidth:380px;dialogHeight:260px;help:no;";
    var RtnVal = window.showModalDialog(url, parameter, feature);
    return RtnVal
}
