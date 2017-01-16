var g_ctlEditInput; 
var g_ctlSelect;    

function btnApply_click() {
    switch (g_ctlSelect.selectedIndex) {
        case 0:
            if (pEditorType == "HWP")
                message.SetAttribute(getNodeText(BottonTDValue[1]));
            else
                if (isFree)
                    message.SetAttribute("LOCK", "", "");
                else
                    message.SetAttribute("INS", getNodeText(BottonTDValue[1]) + EditInput.value, "FIELD");
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
    }
}

function btnCancel_click() {
    message.SetAttribute("DEL", "", "");
}

var BeforeClickID = "";
var isFree = false;
function fnValueClick() {
    if (BottonTDValue.length) {
        var parentTR = window.event.srcElement.parentElement;

        if (BeforeClickID == "")
            parentTR.cells[0].style.backgroundColor = "#c7d7ed";
        else {
            BeforeClickID.style.backgroundColor = "#fff";
            parentTR.cells[0].style.backgroundColor = "#c7d7ed";
        }

        BeforeClickID = parentTR.cells[0];
        setNodeText(BottonTDValue[0] , "FIELD");
        setNodeText(BottonTDValue[1] , GetAttribute(parentTR.cells[0], "ID"));
        setNodeText(BottonTDValue[2] , getNodeText(parentTR.cells[0]));
        document.getElementById("EditInput").value = "";

        var idText = GetAttribute(parentTR, "PARENTID");

        isFree = false;
        if (idText == "approvalinfo" || idText == "recvapprovalinfo" || idText == "userdefinedinfo") {
            document.getElementById("EditInput").disabled = false;
            document.getElementById("EditInput").focus();

            if (GetAttribute(parentTR.cells[0], "ID") == "free") {
                isFree = true;
                setNodeText(BottonTDValue[1], "");
                document.getElementById("EditInput").value = "free";
                document.getElementById("EditInput").disabled = true
            }
        }
        else {
            document.getElementById("EditInput").disabled = true;
            
            g_ctlSelect.disabled = false;
            document.getElementById("EditInput").disabled = true;
            g_ctlSelect.selectedIndex = 0;
        }
    }
}

var xmlpara = createXmlDom();
function add_doc_maker() {
	var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApprovalG/getFormPropList.do",
		data : {
			companyID  : companyID
		},
		success: function(text){
			result = text;
		}
	});

    if (result != "") {
    	xmlpara = loadXMLString(result);
        PROPERTY_TABLEINIT();
    }
}

function PROPERTY_TABLEINIT() {
    var ROOTTD = document.getElementById('rootTD');
    var TABLE = document.createElement("TABLE");
    var TBODY = document.createElement("TBODY");
    var TR_1 = document.createElement("TR");
    var TD_1 = document.createElement("TD");
    var TR_2 = document.createElement("TR");
    var TD_2 = document.createElement("TD");
    TABLE.height = "100%";
    TABLE.width = "100%";
    TABLE.border = 0;
    TABLE.cellPadding = 0;
    TABLE.cellSpacing = 0;
    
    TD_1.style.verticalAlign = "top";
    TD_1.style.height = "613px";

    ROOTTD.appendChild(TABLE);
    TABLE.appendChild(TBODY);

    TBODY.appendChild(TR_1);
    TR_1.appendChild(TD_1);

    TBODY.appendChild(TR_2);
    TR_2.appendChild(TD_2);

    TopPropertyTable(TD_1);
    BottomPropertyTable(TD_2);
}

var rootTop;
var rootDiv;
var click_TR;
function TopPropertyTable(parentTD) {
    rootTop = parentTD;
    parentTD.style.verticalAlign = "top";

    var DIV = document.createElement("DIV");
    var TABLE = document.createElement("TABLE");
    var TBODY = document.createElement("TBODY");
    var TR_1 = document.createElement("TR");
    var TD = document.createElement("TD");

    DIV.className = "content_property";
    DIV.style.height = "613px";
    DIV.style.overflow = "auto";
    TABLE.width = "100%";
    TABLE.border = 0;
    TABLE.cellPadding = 0;
    TABLE.cellSpacing = 0;
    parentTD.appendChild(DIV);
    DIV.appendChild(TABLE);
    TABLE.appendChild(TBODY);

    var nodeList = SelectNodes(xmlpara.documentElement, "PROPERTY");
    for (var i = 0 ; i < nodeList.length; i++) {
        var node = nodeList[i];
        var TR_1 = document.createElement("TR");
        TR_1.id = GetAttribute(node, "ID");
        var TD = document.createElement("TD");
        TD.className = "tabTitle";
        setNodeText(TD , GetAttribute(node, "NAME"));
        TBODY.appendChild(TR_1);
        TR_1.appendChild(TD);
        TR_1.onclick = showHideSubTable;

        var newSubTr = document.createElement("TR");
        var newSubTd = document.createElement("TD");
        newSubTd.className = "tabList";
        newSubTr.appendChild(newSubTd);
        TBODY.appendChild(newSubTr);
        createNewSubTable(newSubTd, node);
        newSubTr.style.display = "none";
    }
    rootDiv = DIV;
}

function createNewSubTable(newSubTd, node) {
    var i;
    var ROWS = GetChildNodes(node);
    var TABLE = document.createElement("TABLE");
    var TBODY = document.createElement("TBODY");
    TABLE.width = "100%";
    TABLE.border = 0;
    TABLE.cellPadding = 0;
    TABLE.cellSpacing = 0;    
    newSubTd.appendChild(TABLE);
    TABLE.appendChild(TBODY);

    for (i = 0; i < ROWS.length; i++) {
        createNewSubTR(TBODY, ROWS[i], GetAttribute(node, "ID"));
    }
}

function createNewSubTR(TBODY, row, parentID) {
    var TR_1 = document.createElement("TR");
    var TD_1 = document.createElement("TD");
    TR_1.style.height = "20px";
    TD_1.width = "100%";
    TBODY.appendChild(TR_1);
    TR_1.appendChild(TD_1);
    setNodeText(TD_1 , getNodeText(SelectSingleNode(row, "NAME")));
    SetAttribute(TD_1, "id", getNodeText(SelectSingleNode(row, "ID")));
    SetAttribute(TR_1, "PARENTID", parentID);
    TD_1.onclick = fnValueClick;
    TR_1.onmouseover = fnMouseOver;
    TR_1.onmouseout = fnMouseOut;
}

function fnMouseOver() {
    this.style.backgroundColor = "#ddddff";
}

function fnMouseOut() {
    this.style.backgroundColor = "";
}

function showHideSubTable() {    
    var nextElement = window.event.srcElement.parentElement.nextSibling;
    click_TR = window.event.srcElement.parentElement.id;
    
    if (nextElement.style.display == "none") {
        nextElement.style.display = "";
    }
    else {
        nextElement.style.display = "none";
    }
}

var BottomValue = new Array("ClassName", "ID", strLang29, strLang783);
var BottonTDValue = new Array();
var rootBottom;
function BottomPropertyTable(parentTD) {
    parentTD.style.verticalAlign = "top";

    var DIV = document.createElement("DIV");
    var TABLE = document.createElement("TABLE");
    var TBODY = document.createElement("TBODY");

    DIV.className = "content_propertyInfo";
    TABLE.width = "100%";
    TABLE.border = 0;
    TABLE.cellSpacing = 0;
    TABLE.cellPadding = 0;
    parentTD.appendChild(DIV);
    DIV.appendChild(TABLE);
    TABLE.appendChild(TBODY);

    for (var i = 0; i < BottomValue.length; i++) {
        var TR_1 = document.createElement("TR");
        var TH_1 = document.createElement("TH");
        var TD_2 = document.createElement("TD");

        setNodeText(TH_1 , BottomValue[i]);
        TH_1.width = "50px";
        TH_1.style.textAlign = "center";
        TD_2.id = "displayid";
        TD_2.width = "100%";
        TD_2.style.textAlign = "center";

        BottonTDValue[i] = TD_2;
        TBODY.appendChild(TR_1);
        TR_1.appendChild(TH_1);
        TR_1.appendChild(TD_2);

        if (i == (BottomValue.length - 1)) {
            var SPAN = document.createElement("SPAN");
            SPAN.className = "selectLayout";
            var ctlSelect = document.createElement("SELECT");
            var ctlOption1 = document.createElement("OPTION");
            ctlSelect.appendChild(ctlOption1);
            setNodeText(ctlOption1 , "TD");
            SPAN.appendChild(ctlSelect)
            TD_2.appendChild(SPAN);
            g_ctlSelect = ctlSelect;
            ctlSelect.disabled = true;
            ctlSelect.style.width = "158px";
        }
        else {
            setNodeText(TD_2 , " ");
        }
        if (i == 0) {
            TR_1.style.display = "none";
        }
    }

    var newEditTr = document.createElement("TR");
    var newEditTd1 = document.createElement("TD");
    var newEditTd2 = document.createElement("TD");
    var newSpan = document.createElement("SPAN");
    var newEditInput = document.createElement("INPUT");

    newEditInput.id = "EditInput";
    newEditInput.style.width = "158px";

    TBODY.appendChild(newEditTr);
    newEditTr.appendChild(newEditTd1);
    newEditTr.appendChild(newEditTd2);
    setNodeText(newEditTd1 , strLang779);

    newSpan.className = "inputLayout";
    newSpan.appendChild(newEditInput);
    newEditTd2.width = "100%";
    newEditTd2.appendChild(newSpan);

    newEditTd1.style.textAlign = "center";
    BottonTDValue[i] = newEditTd2;

    var TR_1 = document.createElement("TR");
    var TD = document.createElement("TD");
    TBODY.appendChild(TR_1);
    TR_1.appendChild(TD);
    TD.align = "center";
    TD.colSpan = 2;
    TD.height = "40px";

    var MENUDIV = document.createElement("DIV");
    MENUDIV.id = "mainmenu";
    var UL = document.createElement("UL");
    var LI1 = document.createElement("LI");
    var LI2 = document.createElement("LI");
    var SPAN1 = document.createElement("SPAN");
    var SPAN2 = document.createElement("SPAN");

    setNodeText(SPAN1 , strLang786);
    SPAN1.onclick = btnApply_click;
    setNodeText(SPAN2 , strLang787);
    SPAN2.onclick = btnCancel_click;
    LI1.appendChild(SPAN1);
    LI2.appendChild(SPAN2);
    UL.appendChild(LI1);
    UL.appendChild(LI2);
    MENUDIV.appendChild(UL);
    TD.appendChild(MENUDIV);
    rootBottom = parentTD;
}

function DrawAutoAprLine(ret, pDraftFlag, sn) {
    var SignCnt = 0;
    var HapyCnt = 0;
    var SSignCnt = 0;
    var SHapyCnt = 0;
    var SignHTML = "";
    var HapyHTML = "";
    var SSignHTML = "";
    var SHapyHTML = "";
    var pFormTagName = new Array();
    var i, j, p, k, z;
    var xmldom = createXmlDom();
    xmldom.loadXML(ret);

    var susinSN = "1";
    var Recv = "";

    if (pDraftFlag == "SUSIN") {
        susinSN = parseInt(sn) + 1;
        Recv = sn + "Recv";
    }

    var nodeName = "PROCESSOR/FLOW/APRLINES" + susinSN + "/APRLINE";
    objNodes = xmldom.selectNodes(nodeName);
    FormProc = pzFormProc.object;
    fields = FormProc.Fields;
    count = objNodes.length;

    for (i = 0; i < count; i++) {
        var KyljeaType = getNodeText(objNodes.item(i).childNodes(1))


        if (KyljeaType == "A03001" || KyljeaType == "A03003" || KyljeaType == "A03004" || KyljeaType == "A03015" || KyljeaType == "A03040") {
            SignCnt = SignCnt + 1;
        }


        if (KyljeaType == "A03008" || KyljeaType == "A03009" || KyljeaType == "A03011" || KyljeaType == "A03012") {
            HapyCnt = HapyCnt + 1;
        }
    }
    var tempLen = 0;
    var SignLen = 0;
    var tempLen1 = parseInt(SignCnt / 10);
    SignLen = (SignCnt % 10 > 0) ? tempLen1 + 1 : tempLen1;

    var HapyLen = 0;
    var tempLen2 = parseInt(HapyCnt / 10);
    HapyLen = (HapyCnt % 10 > 0) ? tempLen2 + 1 : tempLen2;


    field = fields.Item(Recv + "AprLine");
    if (field && SignCnt > 0) {

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


    if (field && SignCnt <= 0) {
        field.TagObject.innerHTML = "&nbsp;";
    }


    field = fields.Item(Recv + "AprHapuiLine");


    if (field && HapyCnt <= 0) {
        field.TagObject.innerHTML = "&nbsp;";
    }

    if (field && HapyCnt > 0) {

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
