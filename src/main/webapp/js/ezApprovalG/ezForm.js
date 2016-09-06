var g_PropertyWidth = 140;  
var g_XmlDoc;
var g_okBtn;       
var g_cancelBtn;    
var g_ctlEditInput; 
var g_ctlSelect;    
function btnCancel_click() {
    var tdElement;
    if (BottonTDValue[1].innerText == "fixRecv") {
        pzFormProc.editor.DOM.body.removeAttribute("fixRecv");
        g_ctlEditInput.value = "";
        return;
    }

    if (pzFormProc.CurSelElement.tagName == "TABLE" || pzFormProc.CurSelElement.tagName == "SELECT" || pzFormProc.CurSelElement.tagName == "INPUT") {
        tdElement = pzFormProc.CurSelElement;
    }
    else {
        tdElement = pzFormProc.CurTDElement;
    }

    if (tdElement) {
        tdElement.removeAttribute("classname", 0);
        tdElement.removeAttribute("id", 0);
        pzFormProc.SetCheckFieldForAdmin(false, tdElement);
    }
}

function onCtlSelectChange() {
    switch (g_ctlSelect.selectedIndex) {
        case 2:
        case 3:
            g_ctlEditInput.disabled = false;
            break;

        default:
            g_ctlEditInput.disabled = true;
            g_ctlEditInput.value = "";
            break;
    }
}

function btnApply_click() {
    var curElement = pzFormProc.CurSelElement;
    if (BottonTDValue[1].innerText == "EXTDOC") {
        var isExtDoc = pzFormProc.editor.DOM.body.getAttribute("EXTDOC");
        if (isExtDoc == "Y") {
            pzFormProc.editor.DOM.body.removeAttribute("EXTDOC");
            g_ctlEditInput.value = strLang368;
        }
        else {
            pzFormProc.editor.DOM.body.setAttribute("EXTDOC", "Y");
            g_ctlEditInput.value = strLang367;
        }
        return;
    }

    if (BottonTDValue[1].innerText == "fixRecv") {
        if (g_ctlEditInput.value == "")
            alert(strLang401)
        else
            pzFormProc.editor.DOM.body.setAttribute("fixRecv", g_ctlEditInput.value);
        return;
    }

    switch (g_ctlSelect.selectedIndex) {
        case 0:
            {
                var tdElement;
                if (pzFormProc.CurSelElement.tagName == "TABLE" || pzFormProc.CurSelElement.tagName == "SELECT" || pzFormProc.CurSelElement.tagName == "INPUT") {
                    tdElement = pzFormProc.CurSelElement;
                }
                else {
                    tdElement = pzFormProc.CurTDElement;
                }

                if (tdElement) {
                    tdElement.className = BottonTDValue[0].innerText;
                    tdElement.id = BottonTDValue[1].innerText + g_ctlEditInput.value;
                    pzFormProc.SetCheckFieldForAdmin(true, tdElement);
                }
            }
            break;

        case 1:
            {
                if (curElement.tagName == "SELECT") {
                    var selectVar = BottonTDValue[1].innerText;
                    if (g_ctlEditInput.disabled == false) {
                        selectVar += g_ctlEditInput.value
                    }
                    curElement.className = BottonTDValue[0].innerText;
                    curElement.id = selectVar;
                }
                else {
                    var str = "<select class=";
                    str += BottonTDValue[0].innerText;
                    str += " id=";
                    str += BottonTDValue[1].innerText;
                    str += "></select>";
                    pzFormProc.InnerHTML(str);
                }
            }
            break;

        case 2:
            {
                if (curElement.tagName == "INPUT" && curElement.type == "checkbox") {
                    var selectVar = BottonTDValue[1].innerText;
                    if (g_ctlEditInput.disabled == false) {
                        selectVar += g_ctlEditInput.value
                    }
                    curElement.className = BottonTDValue[0].innerText;
                    curElement.id = selectVar;
                }
                else {
                    if (!g_ctlEditInput.value) {
                        alert(strLang405);
                        g_ctlEditInput.focus();
                        return;
                    }
                    var str = "<INPUT type=checkbox class=";
                    str += BottonTDValue[0].innerText;
                    str += " id=";
                    str += BottonTDValue[1].innerText;
                    str += " value=";
                    str += g_ctlEditInput.value;
                    str += ">";
                    pzFormProc.InnerHTML(str);
                }
            }
            break;

        case 3:
            {
                if (curElement.tagName == "INPUT" && curElement.type == "radio") {
                    curElement.className = BottonTDValue[0].innerText;
                    curElement.id = BottonTDValue[1].innerText + g_ctlEditInput.value;
                }
                else {
                    if (!g_ctlEditInput.value) {
                        alert(strLang405);
                        g_ctlEditInput.focus();
                        return;
                    }

                    var str = "<INPUT type=radio class=";
                    str += BottonTDValue[0].innerText;
                    str += " id=";
                    str += BottonTDValue[1].innerText;
                    str += " value=";
                    str += g_ctlEditInput.value;
                    str += ">";
                    pzFormProc.InnerHTML(str);
                }
            }
            break;

        case 4:    // HR
            {
                pzFormProc.InnerHTML("<hr>");
            }
            break;
    }
}

function fnValueClick() {
    if (BottonTDValue.length) {
        var parentTR = window.event.srcElement.parentElement;
        var i;
        var nChildLen = parentTR.cells.length;
        var tdElement = parentTR.cells(1);
        BottonTDValue[0].innerText = "FIELD";
        BottonTDValue[1].innerText = parentTR.cells(0).innerText;
        BottonTDValue[2].innerText = tdElement.innerText;
        g_ctlEditInput.innerText = "";

        var idText = parentTR.xmlNodeData.parentNode.parentNode.selectSingleNode("ID").text;
        if (idText == "approvalinfo") {
            g_ctlEditInput.disabled = false;
            g_ctlEditInput.focus();
            g_ctlEditInput.parentElement.parentElement.firstChild.innerText = strLang365;
        }
        else {
            g_ctlEditInput.disabled = true;
            g_ctlEditInput.parentElement.parentElement.firstChild.innerText = strLang783;

            if (parentTR.cells(0).innerText == "EXTDOC") {
                var isExtDoc = "";
                isExtDoc = pzFormProc.editor.DOM.body.getAttribute("EXTDOC");
                if (isExtDoc == "Y")
                    g_ctlEditInput.value = strLang367;
                else
                    g_ctlEditInput.value = strLang368;
                g_okBtn.disabled = false;
                g_cancelBtn.disabled = false;
                g_ctlSelect.disabled = true;
                g_ctlEditInput.disabled = true;
                g_ctlSelect.selectedIndex = 0;
            }
            else if (parentTR.cells(0).innerText == "fixRecv") {
                var pfixRecv = "";
                pfixRecv = pzFormProc.editor.DOM.body.getAttribute("fixRecv");
                g_ctlEditInput.parentElement.parentElement.firstChild.innerText = strLang116;
                if (!pfixRecv) pfixRecv = "";
                g_ctlEditInput.value = pfixRecv;

                g_okBtn.disabled = false;
                g_cancelBtn.disabled = false;
                g_ctlSelect.disabled = true;
                g_ctlEditInput.disabled = false;
                g_ctlEditInput.focus();
                g_ctlSelect.selectedIndex = 0;
            }
            else {
                g_okBtn.disabled = false;
                g_cancelBtn.disabled = false;
                g_ctlSelect.disabled = false;
                g_ctlEditInput.disabled = true;
                g_ctlSelect.selectedIndex = 0;
            }
        }
    }
}
  
function add_doc_maker() {
    if (document.getElementById('rootTD').style.display) {
        if (document.getElementById('rootTD').style.display == "block") {
            document.getElementById('rootTD').style.display = "none";
        }
        else {
            document.getElementById('rootTD').style.display = "block";
        }
    }
    else {        
        tableinit(g_PropertyWidth);
        document.getElementById('rootTD').style.display = "block";
    }
}

function tableinit($Size) {
    var onlyNum = parseInt(document.getElementById('TForm').width);
    onlyNum += $Size;
    //dialogWidth = onlyNum + "px";

    rootTD.vAlign = "top";
    rootTD.style.display = "block";

    var newTable = document.createElement("table");
    var newTBody = document.createElement("tbody");

    var newTr1 = document.createElement("tr");
    var newTd1 = document.createElement("td");

    var newTr2 = document.createElement("tr");
    var newTd2 = document.createElement("td");

    newTable.border = 0;
    newTable.cellPadding = 0;
    newTable.cellSpacing = 0;

    rootTD.appendChild(newTable);
    newTable.appendChild(newTBody);

    newTBody.appendChild(newTr1);
    newTr1.appendChild(newTd1);

    newTBody.appendChild(newTr2);
    newTr2.appendChild(newTd2);

    rootTD.width = $Size;

    newTable.width = $Size;
    newTable.height = "100%";

    // 실제값세팅
    newTd1.width = "100%";
    newTd1.height = "50%";

    newTd2.width = "100%";
    newTd2.height = "100%";

    // 변화하는 값 세팅
    TopPropertyTable(newTd1, $Size);
    BottomPropertyTable(newTd2);
}

var rootTop;
var rootDiv;
var TopValue = new Array;
var TopTDValue = new Array();

function TopPropertyTable(parentTD, $Size) {
    rootTop = parentTD;
    parentTD.vAlign = "top";

    var newDiv = document.createElement("DIV");
    var newTable = document.createElement("table");
    var newTBody = document.createElement("tbody");
    var newTr = document.createElement("tr");
    var newTd = document.createElement("td");

    newTable.style.backgroundColor = "#fefee7";
    newTable.style.Color = "#4b4b1f";
    newTable.width = parentTD.clientWidth;
    newTable.border = 1;
    newTable.cellSpacing = 0;
    newTable.cellPadding = 0;
    newTable.style.fontSize = "9pt";
    newTable.style.fontFamily = strLang369;
    newTable.style.borderCollapse = "collapse";
    parentTD.appendChild(newDiv);
    newDiv.appendChild(newTable);
    newTable.appendChild(newTBody);

    var i;
    g_XmlDoc = new ActiveXObject("Microsoft.XMLDOM");

    g_XmlDoc.async = false;
    g_XmlDoc.load(strLangFromFile);

    var nodeList = g_XmlDoc.documentElement.selectNodes("GROUP");

    // 몇개의 top value 가 있는지 조사한다.
    for (i = 0 ; i < nodeList.length; i++) {
        var node = nodeList[i];
        var newTr = document.createElement("tr");
        var newTd = document.createElement("td");
        newTd.innerText = node.selectSingleNode("NAME").text;
        newTd.align = "center";
        newTd.height = '18'
        newTd.style.backgroundColor = "#E4EAF5";
        newTd.style.cursor = "hand";
        newTBody.appendChild(newTr);
        newTr.appendChild(newTd);
        newTr.onclick = showHideSubTable;

        var newSubTr = document.createElement("tr");
        var newSubTd = document.createElement("td");
        newTBody.appendChild(newSubTr);
        newSubTr.appendChild(newSubTd);
        newSubTd.width = newTable.clientWidth;

        createNewSubTable(newSubTd, node);

        newSubTr.style.display = "none";
    }
    rootDiv = newDiv;

    newDiv.style.width = $Size - 4;//"100%";
    newDiv.style.height = 300;//"100%";
    newDiv.style.overflow = "auto";
}

function createNewSubTable(newSubTd, node) {
    var i;
    var rows = node.selectNodes("ROW");
    var newTable = document.createElement("table");
    var newTBody = document.createElement("tbody");
    newTable.border = 0;
    newTable.cellPadding = 2;
    newTable.cellSpacing = 0;
    newTable.width = newSubTd.offsetWidth - 2;

    newTable.style.fontSize = "9pt";
    newTable.style.fontFamily = strLang369;
    newSubTd.appendChild(newTable);
    newTable.appendChild(newTBody);

    for (i = 0; i < rows.length; i++) {
        createNewSubTR(newTBody, rows[i]);
    }
}

function createNewSubTR(newTBody, row) {
    var newTr = document.createElement("tr");
    var newTd1 = document.createElement("td");
    var newTd2 = document.createElement("td");

    newTBody.appendChild(newTr);
    newTr.appendChild(newTd1);
    newTr.appendChild(newTd2);

    newTd1.innerText = row.selectSingleNode("ID").text;
    newTd2.innerText = row.selectSingleNode("NAME").text;
    newTr.xmlNodeData = row.selectSingleNode("ID");

    newTr.onclick = fnValueClick;

    newTd1.style.display = "none";

    newTr.onmouseover = fnMouseOver;
    newTr.onmouseout = fnMouseOut;
}

function fnMouseOver() {
    this.style.backgroundColor = "#ddddff";
}

function fnMouseOut() {
    this.style.backgroundColor = "";
}

function showHideSubTable() {
    var nextElement = window.event.srcElement.parentElement.nextSibling;
    if (nextElement.style.display == "none") {
        nextElement.style.display = "";
    }
    else {
        nextElement.style.display = "none";
    }
}

var BottomValue = new Array("ClassName", "ID", strLang107, strLang783);
var BottonTDValue = new Array();
var rootBottom;

function BottomPropertyTable(parentTD) {
    parentTD.valign = "center";

    var newDiv = document.createElement("DIV");

    var newTable = document.createElement("table");
    var newTBody = document.createElement("tbody");

    newTable.width = parentTD.clientWidth;
    newTable.border = 1;
    newTable.cellSpacing = 0;
    newTable.cellPadding = 0;
    newTable.style.tableLayout = "fixed";
    newTable.style.fontSize = "9pt";
    newTable.style.fontFamily = strLang369;
    parentTD.appendChild(newDiv);
    newDiv.appendChild(newTable);
    newTable.appendChild(newTBody);
    newTable.style.borderCollapse = "collapse";

    for (var i = 0; i < BottomValue.length; i++) {

        var newTr = document.createElement("tr");
        var newTd1 = document.createElement("td");
        var newTd2 = document.createElement("td");

        newTd1.innerText = BottomValue[i];
        newTd1.width = 45;
        newTd1.align = "center";
        newTd2.align = "center";

        BottonTDValue[i] = newTd2;
        newTBody.appendChild(newTr);
        newTr.appendChild(newTd1);
        newTr.appendChild(newTd2);

        if (i == (BottomValue.length - 1)) {
            var ctlSelect = document.createElement("SELECT");
            var ctlOption1 = document.createElement("OPTION");
            var ctlOption2 = document.createElement("OPTION");
            var ctlOption3 = document.createElement("OPTION");
            var ctlOption4 = document.createElement("OPTION");
            var ctlOption5 = document.createElement("OPTION");

            newTd2.appendChild(ctlSelect);

            ctlSelect.appendChild(ctlOption1);
            ctlSelect.appendChild(ctlOption2);
            ctlSelect.appendChild(ctlOption3);
            ctlSelect.appendChild(ctlOption4);
            ctlSelect.appendChild(ctlOption5);

            ctlOption1.innerText = "TD";
            ctlOption2.innerText = "DropDownList";
            ctlOption3.innerText = "Check";
            ctlOption4.innerText = "Radio";
            ctlOption5.innerText = "HR";

            g_ctlSelect = ctlSelect;
            g_ctlSelect.onchange = onCtlSelectChange;

            ctlSelect.style.width = "100%";
        }
        else {
            newTd2.innerText = " ";
        }

        if (i == 0) {
            newTr.style.display = "none";
        }
    }

    var newEditTr = document.createElement("tr");
    var newEditTd1 = document.createElement("td");
    var newEditTd2 = document.createElement("td");
    var newEditInput = document.createElement("input");

    newEditInput.style.width = "97%";
    g_ctlEditInput = newEditInput;

    newTBody.appendChild(newEditTr);
    newEditTr.appendChild(newEditTd1);
    newEditTr.appendChild(newEditTd2);
    newEditTd1.innerText = strLang779;
    newEditTd2.appendChild(newEditInput);

    newEditTd1.align = "center";

    BottonTDValue[i] = newEditTd2;

    // 적용와 취소 Button

    var newTr = document.createElement("tr");
    var newTd = document.createElement("td");
    var newApplyBtn = document.createElement("button");
    var newCancelBtn = document.createElement("button");

    newTBody.appendChild(newTr);
    newTr.appendChild(newTd);
    newTd.appendChild(newApplyBtn);
    newTd.appendChild(newCancelBtn);

    newTd.colSpan = 2;
    newTd.align = "center";

    var btnStyle = "background-color:DFDFDF; font-size:9pt;width:68px;height:20px; border-color:#ffffff;border-width:1px";

    newApplyBtn.innerText = strLang786;
    newApplyBtn.onclick = btnApply_click;
    g_okBtn = newApplyBtn;
    g_okBtn.style.cssText = btnStyle;

    newCancelBtn.innerText = strLang787;
    newCancelBtn.onclick = btnCancel_click;
    g_cancelBtn = newCancelBtn;
    g_cancelBtn.style.cssText = btnStyle;

    rootBottom = parentTD;

    newDiv.width = "100%";
    newDiv.height = "100%";
}

function window_onload() {
    var img = document.images
    var len = img.length;
    var i;

    for (i = 0; i < len; i++) {
        var imgItem = img(i);
        imgItem.ondragstart = imgDragStart;
    }

    pzFormProc.setExpression("width", "fnResize()");
    button();
}

function imgDragStart() {
    return false;
}

var flag = false;
function pzFormProc_DocumentComplete() {
    if (flag == false) {
        flag = true;
    }
}

function pzFormProc_FPError() {

}

function pzFormProc_InvalidDocument() {
    alert("This Document isn't ezFlow200-Document");
}

function fnResize() {
    var reSize;
    reSize = parseInt(document.body.all.TForm.width) - 10;

    if (rootTD.style.display == "block") {
        reSize -= g_PropertyWidth;
    }
    return reSize;
}

function pzFormProc_ElementKeyEvent(nKey) {
    /*var tdElement = pzFormProc.CurTDElement;
  
    if(tdElement.id) {
      var TR = tdElement.parentElement; // tr
      var lastTR = TR.parentElement.rows[TR.parentElement.rows.length-1];
      if(lastTR) {
        var nextTD = lastTR.cells(0);
        pzFormProc.SetTDFocus(nextTD);
      }
    }*/
}

function pzFormProc_ElementChange(oldElement) {
    if (BottonTDValue.length) {
        var tdElement
        var tempElement = pzFormProc.CurSelElement;

        if (tempElement.tagName == "TABLE" || tempElement.tagName == "SELECT" || tempElement.tagName == "INPUT" || tempElement.tagName == "HR")
            tdElement = tempElement;
        else
            tdElement = pzFormProc.CurTDElement;

        g_ctlSelect.disabled = true;

        if (!tdElement) {
            BottonTDValue[1].innerText = " ";
            BottonTDValue[2].innerText = " ";
            g_ctlEditInput.value = "";
            return;
        }

        switch (tdElement.tagName) {
            case "SELECT":
                {
                    g_ctlSelect.selectedIndex = 1;
                }
                break;
            case "INPUT":
                {
                    if (tdElement.type == "checkbox") {
                        g_ctlSelect.selectedIndex = 2;
                    }
                    if (tdElement.type == "radio") {
                        g_ctlSelect.selectedIndex = 3;
                    }
                }
                break;
            case "HR":
                {
                    g_ctlSelect.selectedIndex = 4;
                }
                break;
            default:
                {
                    g_ctlSelect.selectedIndex = 0;
                }
                break;
        }

        if (tdElement.className) BottonTDValue[0].innerText = tdElement.className;
        else BottonTDValue[0].innerText = " ";

        if (tdElement.id) {
            BottonTDValue[1].innerText = tdElement.id;
        }
        else {
            BottonTDValue[1].innerText = " ";
        }

        BottonTDValue[2].innerText = " ";

        if (tdElement.value) {
            g_ctlEditInput.value = tdElement.value;
        }
        else {
            g_ctlEditInput.value = "";
        }

        g_okBtn.disabled = true;
        g_cancelBtn.disabled = false;
        g_ctlEditInput.disabled = true;

        var nodeList = g_XmlDoc.documentElement.selectNodes("GROUP");
        var i;
        // 몇개의 top value 가 있는지 조사한다.
        for (i = 0 ; i < nodeList.length; i++) {
            var node = nodeList[i];
            var childNodeList = node.selectNodes("ROW");

            var childCount;

            for (childCount = 0; childCount < childNodeList.length; childCount++) {
                var childNode = childNodeList[childCount];

                if (tdElement && (childNode.firstChild.text == tdElement.id)) {
                    var nameNode = childNode.selectSingleNode("NAME");
                    BottonTDValue[2].innerText = nameNode.text;
                    g_okBtn.disabled = false;
                    g_cancelBtn.disabled = false;
                    return;
                }
                else {
                    BottonTDValue[2].innerText = " ";
                }
            }
        }
    }
}

function DrawAutoAprLine(ret, pDraftFlag, sn) {

    var SignCnt = 0; // 결재칸 초기값 생성하기
    var HapyCnt = 0; // 합의칸 초기값 생성하기.
    var SSignCnt = 0; // 수신 사인칸 초기값 생성하기.
    var SHapyCnt = 0; // 수신 합의칸 초기값 생성하기.
    var SignHTML = "";
    var HapyHTML = "";
    var SSignHTML = "";
    var SHapyHTML = "";
    var pFormTagName = new Array();  //TagName, Width가져오기
    var i, j, p, k, z;
    var xmldom = new ActiveXObject("Microsoft.XMLDOM");
    xmldom.loadXML(ret);

    //결재칸에 대한 체크 부분
    var susinSN = "1";
    var Recv = "";

    if (pDraftFlag == "SUSIN") {
        susinSN = parseInt(sn) + 1;
        Recv = sn + "Recv";
    }

    //루프를 통해서 결재,합의를 만들어준다.
    var nodeName = "PROCESSOR/FLOW/APRLINES" + susinSN + "/APRLINE";
    objNodes = xmldom.selectNodes(nodeName);
    FormProc = pzFormProc.object;
    fields = FormProc.Fields;
    count = objNodes.length;

    for (i = 0; i < count; i++) {
        var KyljeaType = objNodes.item(i).childNodes(1).text;

        //결재 타입중 결재, 후결, 전결이 있을경우 생성한다.
        if (KyljeaType == "A03001" || KyljeaType == "A03003" || KyljeaType == "A03004" || KyljeaType == "A03015" || KyljeaType == "A03040") {
            SignCnt = SignCnt + 1;
        }

        //결재 타입중 개인 병렬 합의, 개인 순차 합의일 경우
        if (KyljeaType == "A03008" || KyljeaType == "A03009" || KyljeaType == "A03011" || KyljeaType == "A03012") {
            HapyCnt = HapyCnt + 1;
        }
    }
    /* 결재칸수 10개 이상일경우 테이블 여러개 만들기 2009.06.03*/
    var tempLen = 0;
    var SignLen = 0;
    var tempLen1 = parseInt(SignCnt / 10);
    SignLen = (SignCnt % 10 > 0) ? tempLen1 + 1 : tempLen1;

    var HapyLen = 0;
    var tempLen2 = parseInt(HapyCnt / 10);
    HapyLen = (HapyCnt % 10 > 0) ? tempLen2 + 1 : tempLen2;
    /* 결재칸수 10개 이상일경우 테이블 여러개 만들기 2009.06.03*/

    //결재 선 만들기..
    field = fields.Item(Recv + "AprLine");
    if (field && SignCnt > 0) {
        //TabName, Width가져오기
        if (Recv != "")
            pFormTagName[0] = "<P align=center>수</P><P align=center>신</P><P align=center>결</P><P align=center>재</P>";
        else
            pFormTagName[0] = "<P align=center>기</P><P align=center>안</P><P align=center>결</P><P align=center>재</P>";

        pFormTagName[1] = "18";

        var strHTML = "";
        k = 1;
        z = (SignCnt >= 10) ? 10 : SignCnt;

        strHTML = "<TABLE style='FONT-SIZE: 0pt' cellSpacing=0 cellPadding=0 align=right valign=top>";
        for (p = 1; SignLen >= p; p++) {
            strHTML += "<TR><TD>";
            if (p >= SignLen) {
                z = SignCnt;
            }

            strHTML += "<TABLE style='TABLE-LAYOUT:fixed; FONT-SIZE:9pt; FONT-FAMILY:굴림체; Design_Time_Lock:true' cellSpacing='0' borderColorDark='white' cellPadding='0' borderColorLight='black' border='1' align='right'>";
            for (i = 1; i <= 3; i++) {
                strHTML += "<TR>";
                for (j = k; j <= z; j++) {
                    if (i == "1" && (j % 10) == "1") {
                        strHTML += "<TD vAlign='middle' width='" + pFormTagName[1] + "' rowSpan='4' align='center' bgColor='#d2e2fd'><STRONG>" + pFormTagName[0] + "</STRONG></TD>";
                    }

                    switch (i.toString()) {
                        case "1":
                            strHTML += "<TD class='FIELD' id='" + sn + "jikwe" + j + "' vAlign='middle' align='center' width='64' height='17' bgColor='#efefef'>";

                            if (fields.Item(sn + "jikwe" + j))
                                strHTML += fields.Item(sn + "jikwe" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                            //                        case "2":
                            //                            strHTML += "<TD class='FIELD' id='" + sn + "seumyung" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                            //                            if (fields.Item(sn + "seumyung" + j))
                            //                                strHTML += fields.Item(sn + "seumyung" + j).TagObject.innerHTML + "</TD>";
                            //                            else
                            //                                strHTML += "&nbsp;</TD>";
                            //                            break;
                        case "2":
                            strHTML += "<TD class='FIELD' id='" + sn + "sign" + j + "' vAlign='middle' align='center' width='64' height='50'>";

                            if (fields.Item(sn + "sign" + j))
                                strHTML += fields.Item(sn + "sign" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "3":
                            strHTML += "<TD class='FIELD' id='" + sn + "seumyungdate" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                            if (fields.Item(sn + "seumyungdate" + j))
                                strHTML += fields.Item(sn + "seumyungdate" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                    }
                }

                strHTML += "</TR>";
            }
            strHTML += "</TABLE>";
            strHTML += "</TD></TR>";

            if (SignCnt > (p * 10)) {
                k = k + 10;
                z = z + 10;
            }
        }
        strHTML += "</TABLE>";
        field.TagObject.innerHTML = strHTML;

    }

    //만약  결재선이 없으면 초기화 시킨다.
    if (field && SignCnt <= 0) {
        field.TagObject.innerHTML = "&nbsp;";
    }

    //결재 선 만들기..
    field = fields.Item(Recv + "AprHapuiLine");

    //만약  협조선이 없으면 초기화 시킨다.
    if (field && HapyCnt <= 0) {
        field.TagObject.innerHTML = "&nbsp;";
    }

    if (field && HapyCnt > 0) {
        //TabName, Width가져오기
        pFormTagName[0] = "<P align=center>합</P><P align=center>의</P><P align=center>결</P><P align=center>재</P>";
        pFormTagName[1] = "18";


        k = 1;
        z = (HapyCnt >= 10) ? 10 : HapyCnt;
        strHTML = "<TABLE style='FONT-SIZE: 0pt' cellSpacing=0 cellPadding=0 align=right valign=top>";

        for (p = 1; HapyLen >= p; p++) {
            strHTML += "<TR><TD>";
            if (p >= HapyLen) {
                z = HapyCnt;
            }
            //TWidth = (HapyCnt * 64) + 20;
            strHTML += "<TABLE style='TABLE-LAYOUT:fixed; FONT-SIZE:9pt; FONT-FAMILY:굴림체; Design_Time_Lock:true' cellSpacing='0' borderColorDark='white' cellPadding='0' borderColorLight='black' border='1' align='right'>";
            for (i = 1; i <= 3; i++) {
                strHTML += "<TR>";
                for (j = k; j <= z; j++) {
                    if (i == "1" && (j % 10) == "1") {
                        strHTML += "<TD vAlign='middle' width='" + pFormTagName[1] + "' rowSpan='4' align='center' bgColor='#d2e2fd'><STRONG>" + pFormTagName[0] + "</STRONG></TD>";
                    }

                    switch (i.toString()) {
                        case "1":
                            strHTML += "<TD class='FIELD' id='" + sn + "habyuipositon" + j + "' vAlign='middle' align='center' width='64' height='17' bgColor='#efefef'>";

                            if (fields.Item(sn + "habyuipositon" + j))
                                strHTML += fields.Item(sn + "habyuipositon" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                            //                        case "2":
                            //                            strHTML += "<TD class='FIELD' id='" + sn + "habyuija" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                            //                            if (fields.Item(sn + "habyuija" + j))
                            //                                strHTML += fields.Item(sn + "habyuija" + j).TagObject.innerHTML + "</TD>";
                            //                            else
                            //                                strHTML += "&nbsp;</TD>";
                            //                            break;
                        case "2":
                            strHTML += "<TD class='FIELD' id='" + sn + "habyuisign" + j + "' vAlign='middle' align='center' width='64' height='50'>";

                            if (fields.Item(sn + "habyuisign" + j))
                                strHTML += fields.Item(sn + "habyuisign" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                        case "3":
                            strHTML += "<TD class='FIELD' id='" + sn + "habyuidate" + j + "' vAlign='middle' align='center' width='64' height='17'>";

                            if (fields.Item(sn + "habyuidate" + j))
                                strHTML += fields.Item(sn + "habyuidate" + j).TagObject.innerHTML + "</TD>";
                            else
                                strHTML += "&nbsp;</TD>";
                            break;
                    }
                }
                strHTML += "</TR>";
            }
            strHTML += "</TABLE>";
            strHTML += "</TD></TR>";

            if (HapyCnt > (p * 10)) {
                k = k + 10;
                z = z + 10;
            }
        }
        strHTML += "</TABLE>";
        field.TagObject.innerHTML = strHTML;
    }
}
