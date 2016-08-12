function RegAddCol() {
    var i, j, k;

    j = parseInt(pStartNum) - 1;

    for (i = 1 ; i <= pEndNum - pStartNum + 1; i++) {
        var newRow = pzFormProc.tableFlexibleAddRow(i, 1);

        if (NodeList.item(j).childNodes(0).childNodes(0).text == "")
            newRow.cells(0).innerText = " ";
        else
            newRow.cells(0).innerText = NodeList.item(j).childNodes(0).childNodes(0).text;

        if (NodeList.item(j).childNodes(1).text == "")
            newRow.cells(1).innerText = " ";
        else
            newRow.cells(1).innerText = NodeList.item(j).childNodes(1).text;

        if (NodeList.item(j).childNodes(2).text == "")
            newRow.cells(2).innerText = " ";
        else
            newRow.cells(2).innerText = NodeList.item(j).childNodes(2).text;

        if (NodeList.item(j).childNodes(3).text == "")
            newRow.cells(3).innerText = " ";
        else
            newRow.cells(3).innerText = NodeList.item(j).childNodes(3).text;

        if (NodeList.item(j).childNodes(4).text == "")
            newRow.cells(4).innerText = " ";
        else
            newRow.cells(4).innerText = NodeList.item(j).childNodes(4).text;

        if (NodeList.item(j).childNodes(5).childNodes(0).text == "")
            newRow.cells(5).innerText = " ";
        else
            newRow.cells(5).innerText = NodeList.item(j).childNodes(5).childNodes(0).text;

        if (NodeList.item(j).childNodes(6).text == "")
            newRow.cells(6).innerText = " ";
        else
            newRow.cells(6).innerText = NodeList.item(j).childNodes(6).text;

        if (NodeList.item(j).childNodes(7).childNodes(0).text == "")
            newRow.cells(7).innerText = " ";
        else
            newRow.cells(7).innerText = NodeList.item(j).childNodes(7).childNodes(0).text;

        j = j + 1;
    }
}

function RecAddCol() {
    var i, j, k;
    j = parseInt(pStartNum) - 1;

    for (i = 1 ; i <= pEndNum - pStartNum + 1; i++) {
        var newRow = pzFormProc.tableFlexibleAddRow(i, 1);

        if (NodeList.item(j).childNodes(0).childNodes(0).text == "")
            newRow.cells(0).innerText = " ";
        else
            newRow.cells(0).innerText = NodeList.item(j).childNodes(0).childNodes(0).text;

        if (NodeList.item(j).childNodes(1).text == "")
            newRow.cells(1).innerText = " ";
        else
            newRow.cells(1).innerText = NodeList.item(j).childNodes(1).text;

        if (NodeList.item(j).childNodes(2).childNodes(0).text == "")
            newRow.cells(2).innerText = " ";
        else
            newRow.cells(2).innerText = NodeList.item(j).childNodes(2).childNodes(0).text;

        if (NodeList.item(j).childNodes(3).text == "")
            newRow.cells(3).innerText = " ";
        else
            newRow.cells(3).innerText = NodeList.item(j).childNodes(3).text;

        if (NodeList.item(j).childNodes(4).text == "")
            newRow.cells(4).innerText = " ";
        else
            newRow.cells(4).innerText = NodeList.item(j).childNodes(4).text;

        if (NodeList.item(j).childNodes(5).childNodes(0).text == "")
            newRow.cells(5).innerText = " ";
        else
            newRow.cells(5).innerText = NodeList.item(j).childNodes(5).childNodes(0).text;

        j = j + 1;
    }
}


function DelAddCol() {
    var i, j, k;

    j = parseInt(pStartNum) - 1;

    for (i = 1 ; i <= pEndNum - pStartNum + 1; i++) {
        var newRow = pzFormProc.tableFlexibleAddRow(i, 1);

        if (NodeList.item(j).childNodes(0).childNodes(0).text == "")
            newRow.cells(0).innerText = " ";
        else
            newRow.cells(0).innerText = NodeList.item(j).childNodes(0).childNodes(0).text;

        if (NodeList.item(j).childNodes(1).text == "")
            newRow.cells(1).innerText = " ";
        else
            newRow.cells(1).innerText = NodeList.item(j).childNodes(1).text;

        if (NodeList.item(j).childNodes(2).childNodes(0).text == "")
            newRow.cells(2).innerText = " ";
        else
            newRow.cells(2).innerText = NodeList.item(j).childNodes(2).childNodes(0).text;

        if (NodeList.item(j).childNodes(3).text == "")
            newRow.cells(3).innerText = " ";
        else
            newRow.cells(3).innerText = NodeList.item(j).childNodes(3).text;

        if (NodeList.item(j).childNodes(4).text == "")
            newRow.cells(4).innerText = " ";
        else
            newRow.cells(4).innerText = NodeList.item(j).childNodes(4).text;

        if (NodeList.item(j).childNodes(5).childNodes(0).text == "")
            newRow.cells(5).innerText = " ";
        else
            newRow.cells(5).innerText = NodeList.item(j).childNodes(5).childNodes(0).text;

        j = j + 1;
    }
}


function DocListAddCol() {
    var i, j, k, y;

    var count = NodeList.item(0).childNodes.length;

    j = parseInt(pStartNum) - 1;

    for (i = 1 ; i <= pEndNum - pStartNum + 1; i++) {
        var newRow = pzFormProc.tableFlexibleAddRow(i, 1);

        if (NodeList.item(j).childNodes(0).childNodes(0).text == " ")
            newRow.cells(0).innerText = " ";
        else
            newRow.cells(0).innerText = NodeList.item(j).childNodes(0).childNodes(0).text;

        for (y = 1; y < count - 1; y++) {

            if (NodeList.item(j).childNodes(y).text == "")
                newRow.cells(y).innerText = " ";
            else
                newRow.cells(y).innerText = NodeList.item(j).childNodes(y).text;
        }
        j = j + 1;
    }
}

function CabAddCol() {
    var i, j, k;

    if (DocList_Flag == "RECORD" || DocList_Flag == "CABINET") {
        j = 0;
    }
    else {
        j = parseInt(pStartNum) - 1;
    }

    for (i = 1 ; i <= pEndNum - pStartNum + 1; i++) {
        var newRow = pzFormProc.tableFlexibleAddRow(i, 1);

        for (k = 0; k < NodeList.item(j).childNodes.length; k++) {
            if (newRow.cells(k)) {
                if (!NodeList.item(j).childNodes(k).childNodes(0).text || NodeList.item(j).childNodes(k).childNodes(0).text == "")
                    newRow.cells(k).innerText = " ";
                else
                    newRow.cells(k).innerText = NodeList.item(j).childNodes(k).childNodes(0).text;
            }
        }
        j = j + 1;
    }
}

function savecsv(csvstring) {
    var objSave = new ActiveXObject("EzUtil.MiscFunc");
    var strFilter = objSave.OpenSaveDlg("CSV files (*.csv)\0*.csv\0All Files (*.*)\0*.*\0\0", "text");
    if (strFilter.length > 0) {
        var bResult = objSave.SaveTextToFile(strFilter, csvstring);
        if (bResult) {
            var pAlertContent = strLang490;
            OpenAlertUI(pAlertContent);
            return;
        }
        else {
            var pAlertContent = strLang491;
            OpenAlertUI(pAlertContent);
            return;
        }
    }
}


function mskecsvstr() {
    var csvstring;
    var i, j;
    csvstring = "";
    if (HeaderList == null) return "FALSE"
    if (HeaderList.item(0) == null) return csvstring;
    for (i = 0; i < HeaderList.length; i++) {
        csvstring = csvstring + HeaderList.item(i).childNodes(0).text + ","
    }
    csvstring = csvstring + "\n ";

    if (NodeList.item(0) == null) return csvstring;

    var nodeStr = "";
    var regComma = /,/g;
    var regSColon = /;/g;

    var iEnd = parseInt(pEndNum) - parseInt(pStartNum) + 1;

    for (i = 0 ; i < iEnd ; i++) {
        for (j = 0; j < NodeList.item(i).childNodes.length; j++) {
            nodeStr = NodeList.item(i).childNodes(j).childNodes(0).text;
            nodeStr = nodeStr.replace(regComma, " ");
            nodeStr = nodeStr.replace(regSColon, " ");

            csvstring = csvstring + nodeStr + ",";
        }
        csvstring = csvstring + "\n ";
    }
    return csvstring;
}

function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERT_Cross.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}