var sign = new Array();
var jikwee = new Array();	
var signDate = new Array();
var cellSize = 60;
var signlastSN = 1;
var jikweelastSN = 1;
var signDate = 1;

function findBaseCell() {
    var rtnVal = 1;
    return rtnVal
}

function fsignInfo(pSignKind, pSignNumber) {
    var signDorect;
    if (SusinSN == 0) SusinSN = ""

    var signName = SusinSN + "sign1"
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, signName);
    if (field)
        signDirect = field.direct;
    else
        return false;

    switch (signDirect) {
        case "H":
            H_makeSignCell(pSignKind, pSignNumber)
            break;

        case "V":
            V_makeSignCell()
            break;

        default:
            H_makeSignCell(pSignKind, pSignNumber)
            break;
    }
}

function H_makeSignCell(pSignKind, pSignNumber) {
    var signKinds = new Array();
    var hapyiKinds = new Array();

    switch (pSignKind) {
        case strLang126:
            signKinds[0] = "sign"
            signKinds[1] = "approdept"
            signKinds[2] = "jikwe"
            signKinds[3] = "seumyung"
            signKinds[4] = "seumyungdate"
            break;

        case strLang2:
            hapyKinds[0] = "habyuisign"
            hapyKinds[1] = "habyui"
            hapyKinds[2] = "habyuipositon"
            hapyKinds[3] = "habyuija"
            hapyKinds[4] = "habyuidate"
            break;

        case strLang752:
            break;

        default:
            break;
    }

    var BaseCell_idx = findBaseCell();
    var baseSign = SusinSN + signKinds[0] + BaseCell_idx;

    var fields = message.GetFieldsList();
    var currTD = message.GetListItem(fields, baseSign);
    var currTD_Idx = currTD.cellIndex;
    var currTBL;

    var i
    for (i = 0; i < 5; i++) {
        currTBL = currTD.parentElement;
        if (currTBL.tagName == "TABLE") break;
        currTD = currTBL;
    }

    var i, lastCell_idx, rowSpan_idx
    lastCell_idx = 0;
    rowSpan_idx = 0;

    for (i = BaseCell_idx; i < 30; i++) {
        var signName = SusinSN + signKinds[0] + i
        var field = message.GetListItem(fields, signName);
        if (!field) break;
        if (i == BaseCell_idx) cellSize = field.width;
        lastCell_idx = field.cellIndex;
    }

    var row_idx = currTBL.rows.length;
    if (row_idx > 0)
        rowSpan_idx = currTBL.rows(1).cells.length - currTBL.rows(0).cells.length;

    var oTRS = new Array();
    var oSignKind = new Array();

    var oTR, oTD, field;
    var cellidx, rowidx;
    var i

    for (i = 0; i < signKinds.length; i++) oTRS[i] = "NONE";

    for (i = 0; i < signKinds.length; i++) {
        signName = SusinSN + signKinds[i] + BaseCell_idx;
        oTD = message.GetListItem(fields, signName);
        if (oTD) {
            cellidx = oTD.cellIndex;
            oTR = oTD.parentElement
            rowidx = oTR.rowIndex;

            oTRS[rowidx] = cellidx;
            oSignKind[rowidx] = signKinds[i];
        }
    }

    deleteSignCell(currTBL, lastCell_idx, BaseCell_idx, rowSpan_idx);
    insertSignInfo(currTBL, oTRS, oSignKind, currTD_Idx, pSignNumber, rowSpan_idx)
}

function deleteSignCell(pTBL, plastIdx, pbaseIdx, offset_idx) {
    var i;
    for (i = plastIdx + 1; i > pbaseIdx; i--) {
        deleteCol(pTBL, i, offset_idx)
    }
}

function deleteCol(idSignmark, deleteIndex, offset_idx) {
    var rowsLen = idSignmark.rows.length;
    var countCol = getColCount(idSignmark);
    var i;

    if (countCol == 1)  
        return;

    if (deleteIndex >= 1 && deleteIndex <= countCol) {
        for (i = 0 ; i < rowsLen; i++) {
            var row = idSignmark.rows(i);
            if (i == 0)
                row.deleteCell(deleteIndex - 1);
            else
                row.deleteCell((deleteIndex + offset_idx) - 1);
        }

        if (idSignmark.border == "0") {
            fixedWidth(idSignmark, "?");
        }
        else {
            fixedWidth(idSignmark, "");
        }
    }
}

function getColCount(idSignmark) {
    var rowsLen = idSignmark.rows.length;
    var colsLen = idSignmark.cells.length / rowsLen;
    return colsLen;
}

function fixedWidth(idSignmark, borderType) {
    var countCol = getColCount(idSignmark);
    var i;
    var nPercent = 100 / countCol;

    idSignmark.width = cellSize * countCol;
    for (i = 0; i < countCol; i++) {
        var field = message.GetListItem(fields, "sign1");
        field.width = cellSize;
    }
}

function insertSignInfo(pTBL, pTRS, pSignKind, pTDIdx, pSignNum, offset_idx) {
    var i;
    var tr, td;

    FormProc.specialTableObject = pTBL;

    for (i = pTDIdx; i < pSignNum; i++)
        insertCol(pTBL, i, offset_idx);

    var j;

    for (j = 1; j < pSignNum; j++) 
    {
        for (i = 0; i < pTRS.length; i++) 
        {
            if (pTRS[i] != "NONE") {
                tr = pTBL.rows(i);
                td = tr.cells(pTRS[i] + j);
                td.id = SusinSN + pSignKind[i] + (pTRS[i] + j);
            }
        }
    }
}

function insertCol(idSignmark, currIndex, offset_idx) {
    var rowLen = idSignmark.rows.length;
    var i;

    for (i = 0; i < rowLen; i++) {
        var row = idSignmark.rows(i);
        if (i == 0)
            row.insertCell(currIndex - 1);
        else
            row.insertCell((currIndex + offset_idx) - 1);
    }
    fixedWidth(idSignmark, "");
}

function SplitSign(OrderType, OrderName, OrderDept, OrderStat, OrderJobtitle) {
    var idx, i, signidx, hapbyiidx, gongramidx
    signidx = new Array();

    hapbyiidx = 0;
    for (i = 0; i < OrderType.length; i++) {
        switch (OrderType[i]) {
            case strAprType2:
                break;

            case strAprType3:
                var j
                var flag = false;
                for (j = i - 1; j >= 0; j--)
                    if (OrderType[j] == strAprType4) flag = true;

                if (flag) signidx = signidx + 1;

                break;
            case strAprType4:
                signidx = signidx + 1;
                break;
            case strAprType11:
                hapbyiidx = hapbyiidx + 1;
                break;
            case strAprType12:
                hapbyiidx = hapbyiidx + 1;
                break;
            case strAprType8:
                hapbyiidx = hapbyiidx + 1;
                break;
            case strAprType1:
                signidx = signidx + 1;
                break;
            default:
                break;
        }
    }

    setSignBox("sign", signidx);
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, "habyuisign1");
    if (field)
        setSignBox("habyuisign", hapbyiidx);
}


function setSignID(psignKind) {
    var signKinds = new Array();
    if (psignKind == "sign") {
        signKinds[0] = "sign"
        signKinds[1] = "approdept"
        signKinds[2] = "jikwe"
        signKinds[3] = "seumyung"
        signKinds[4] = "seumyungdate"
    } else {
        signKinds[0] = "habyuisign"
        signKinds[1] = "habyui"
        signKinds[2] = "habyuipositon"
        signKinds[3] = "habyuija"
        signKinds[4] = "habyuidate"
    }
    return signKinds
}

function setStyle_display_none(pCellLength, pSuSin, pSignKinds) {
    var i;
    var fieldName;
    var field

    for (i = 1; i <= pCellLength; i++) {
        var j
        for (j = 0; j < pSignKinds.length; j++) {
            fieldName = pSuSin + pSignKinds[j] + i;
            field = message.GetListItem(fields, fieldName);
            if (field) {
                field.style.display = 'none'
            }
        }
    }
}

function setStyle_display(pSignNum, pSignKinds, pSusin) {
    var i, j;
    var fieldName;
    var field
    var fields = message.GetFieldsList();
    for (i = 1; i <= pSignNum; i++) {
        for (j = 0; j < pSignKinds.length; j++) {
            fieldName = pSusin + pSignKinds[j] + i;
            field = message.GetListItem(fields, fieldName);
            if (field) {
                field.style.display = "";
            }
        }
    }
}

function setSignBox(signKind, psignidx) {
    var fieldSize = 0;
    var headerSize = 0;
    var TableSize = 0;
    var signName;
    var strSusinSN;
    var currTBL;
    var hasSize = false;

    if (pSusinSN == "undefined") pSusinSN = 0;
    if (pSusinSN == 0) strSusinSN = ""; else strSusinSN = pSusinSN;

    signName = strSusinSN + signKind + "1"
    var fields = message.GetFieldsList();
    var field = message.GetListItem(fields, signName);
    if (field) {
        currTBL = field;
        if (currTBL.style.display == "none") hasSize = true;
        fieldSize = currTBL.width;

        var i
        for (i = 0; i < 5; i++) {
            currTBL = currTBL.parentElement;
            if (currTBL.tagName == "TABLE") break;
        }

        TableSize = currTBL.width;
        if (currTBL.rows.length > 1) {
            var hasrowSpan = currTBL.rows(0).cells.length - currTBL.rows(1).cells.length
            if (hasrowSpan > 0) {
                headerSize = currTBL.rows(0).cells(0).width;
                if (hasSize) {
                    if (SplitKind == "FIX")
                        fieldSize = currTBL.rows(0).cells(0).getAttribute("signSize");
                    else
                        TableSize = currTBL.rows(0).cells(0).getAttribute("signSize");
                }

                if (psignidx == "0") {
                    if (SplitKind == "FIX")
                        currTBL.rows(0).cells(0).setAttribute("signSize", fieldSize);
                    else
                        currTBL.rows(0).cells(0).setAttribute("signSize", TableSize);
                }
            }
        }
        else {
            if (field.cellIndex > 0) {
                headerSize = currTBL.rows(0).cells(0).width;
                if (hasSize) {
                    if (SplitKind == "FIX")
                        fieldSize = currTBL.rows(0).cells(0).getAttribute("signSize");
                    else
                        TableSize = currTBL.rows(0).cells(0).getAttribute("signSize");
                }

                if (psignidx == "0") {
                    if (SplitKind == "FIX")
                        currTBL.rows(0).cells(0).setAttribute("signSize", fieldSize);
                    else
                        currTBL.rows(0).cells(0).setAttribute("signSize", TableSize);
                }
            }
        }
    }

    if (!currTBL)
        return;

    var SignIDs = setSignID(signKind)

    setStyle_display_none(currTBL.rows(0).cells.length, strSusinSN, SignIDs);

    setStyle_display(psignidx, SignIDs, strSusinSN)

    if (SplitKind == "FIX" || psignidx == "0") {
        currTBL.width = parseInt(headerSize) + (parseInt(fieldSize) * parseInt(psignidx))
        if (headerSize > 0)
            currTBL.rows(0).cells(0).width = headerSize;

        var i, j
        for (i = 1; i <= psignidx; i++) {
            for (j = 0; j < SignIDs.length; j++) {
                signName = strSusinSN + SignIDs[j] + i;
                field = message.GetListItem(fields, signName);
                if (field) {
                    field.width = fieldSize;
                }
            }
        }
    }
    else {
        if (headerSize > 0)
            currTBL.rows(0).cells(0).width = headerSize;

        if (hasSize)
            currTBL.width = TableSize;

        var fieldsWidth = TableSize - headerSize;
        var fieldSize = fieldsWidth / psignidx;

        var i, j
        for (i = 1; i <= psignidx; i++) {
            for (j = 0; j < SignIDs.length; j++) {
                signName = strSusinSN + SignIDs[j] + i;
                field = message.GetListItem(fields, signName);
                if (field) {
                    field.width = fieldSize;
                }
            }
        }
    }
}