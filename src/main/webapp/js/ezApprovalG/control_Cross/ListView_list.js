var PressCtrlKey = false;
var PressShiftKey = false;
var m_strColorSelect = "#f1f8ff";
var m_strColorDefault =  "#FFFFFF";
var m_strColorOver = "#f4f5f5";
var m_UrgentColor = "#E9101A";

function add_key_event() {
    remove_key_event();

    if (document.attachEvent) {
        document.attachEvent("onkeydown", keydown_handler);
        document.attachEvent("onkeyup", keyup_handler);
    }
    else if (document.addEventListener) {
        document.addEventListener("keydown", keydown_handler, false);
        document.addEventListener("keyup", keyup_handler, false);
    }
}

function keydown_handler(evt) {
    switch (evt.keyCode) {
        case 16: PressShiftKey = true; break;
        case 17: PressCtrlKey = true; break;
    }
}

function keyup_handler(evt) {
    switch (evt.keyCode) {
        case 16: PressShiftKey = false; break;
        case 17: PressCtrlKey = false; break;
    }
}

function remove_key_event() {
    if (document.attachEvent) {
        document.detachEvent("onkeydown", keydown_handler);
        document.detachEvent("onkeyup", keyup_handler);
    }
    else if (document.addEventListener) {
        document.removeEventListener("keydown", keydown_handler, false);
        document.removeEventListener("keyup", keyup_handler, false);
    }
}

function disable_browser_selection() {
    if (typeof (document.body.onselectstart) != "undefined") 
        document.body.onselectstart = function() { return false; }
    else if (typeof (document.body.style.MozUserSelect) != "undefined")
        document.body.style.MozUserSelect = "none";
    else 
        document.body.onmousedown = function() { return false; }

    document.body.style.cursor = "default";
}

function ListView() {
    this.DataSource = DataSource;
    this.DataBind = DataBind;
    this.SetID = SetID;
    this.GetID = GetID;
    this.SetMulSelectable = SetMulSelectable;
    this.GetRowCount = GetRowCount;
    this.GetDataRows = GetDataRows;
    this.LoadFromID = LoadFromID;
    this.AddRow = AddRow;
    this.NewAddRow = NewAddRow;
    this.DeleteRow = DeleteRow;
    this.GetSelectedRows = GetSelectedRows;
    this.GetSelectedIndexes = GetSelectedIndexes;
    this.GetUnSelectedIndexes = GetUnSelectedIndexes;
    this.SetSelectedID = SetSelectedID;
    this.SetSelectedIndex = SetSelectedIndex;
    this.GetSelectedRowID = GetSelectedRowID;
    this.CreateTabelCell = CreateTabelCell;
    this.ExistRow = ExistRow;
    this.RowDataBind = RowDataBind;
    this.SetUseOCS = SetUseOCS;
    this.SetTitle = SetTitle;
    this.RowMoveUp = RowMoveUp;
    this.RowMoveDown = RowMoveDown;
    this.SetTitleIdx = SetTitleIdx;
    this.SetSecIdx = SetSecIdx;
    this.SetWidthFlag = SetWidthFlag;
    this.SetSelectFlag = SetSelectFlag;
    this.AddDataRow = AddDataRow;
    this.SetAlignLeft = SetAlignLeft;
    this.SetUrgentFlag = SetUrgentFlag;
    this.SetAlignArr = SetAlignArr;
    this.GetTableWidth = GetTableWidth;
    this.SetTableWidth = SetTableWidth;
    this.SetListType = SetListType;
    
    this.SetHeaderOnClick = SetHeaderOnClick;
    this.SetHeaderOnDblClick = SetHeaderOnDblClick;
    this.SetRowOnClick = SetRowOnClick;
    this.SetRowOnDblClick = SetRowOnDblClick;
    this.SetContextHandler = SetContextHandler;
    this.SetUnSelected = SetUnSelected;

    this.SetDebugMode = SetDebugMode;
    this.toString = ListView_ToString;
    this.SetHeightFree = SetHeightFree;

    var _dataSource = null;
    var _thisID = "";
    var _isMultiSelectable = false;
    var _rowCount = 0;
    var _debugMode = false;
    var _useOcs = false;
    var _IE = true;
    var _title = "";

    var _headeronclick = null;
    var _headerondblclick = "";
    var _rowonclick = null;
    var _rowondblclick = "";
    var _contextHandler = null;
    var _titleIdx = null;
    var _SecIdx = null;
    var _TableWidth = 0;
    var _WidthFlag = true;
    var _SelectFlag = true;
    var _firstRowID = "";
    var _AlignLeft = null;
    var _UrgentFlag = false;
    var _Align = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    var _ListType = 0;
    var _SetHeightFree = false;

    function SetID(pObjID) {
        if (pObjID != "")
            _thisID = pObjID;
    }
    function GetID() {
        return _thisID;
    }
    function SetTitleIdx(idx) {
        if (idx != "")
            _titleIdx = idx;
    }
    function SetSecIdx(idx) {
        if (idx != "")
            _SecIdx = idx;
    }
    function SetWidthFlag(flag) {
        _WidthFlag = flag;
    }
    function SetSelectFlag(flag) {
        _SelectFlag = flag;
    }
    function DataSource(pDataSource) {
        _dataSource = pDataSource;
    }

    function SetAlignLeft(pAlign) {
        _AlignLeft = pAlign;
    }
    function SetUrgentFlag(flag) {
        _UrgentFlag = flag;
    }

    function SetAlignArr(arry) {
        _Align = arry;
    }
    
    function SetListType(pListType) {
        _ListType = pListType;
    }

    function SetHeaderOnClick(pHeaderOnClick) {
        _headeronclick = pHeaderOnClick;
    }

    function SetHeaderOnDblClick(pHeaderOnDblClick) {
        _headerondblclick = pHeaderOnDblClick;
    }

    function SetRowOnClick(pRowOnClick) {
        _rowonclick = pRowOnClick;
    }

    function SetRowOnDblClick(pRowOnDblClick) {
        _rowondblclick = pRowOnDblClick;
    }

    function SetContextHandler(pContextHandler) {
        _contextHandler = pContextHandler;
    }

    function SetMulSelectable(pSelectable) {
        _isMultiSelectable = pSelectable;

        if (_isMultiSelectable)
            add_key_event();
    }

    function SetUseOCS(pUseOcs) {
        _useOcs = pUseOcs;
        SetUserBrower();
    }

    function SetTitle(pTitle) {
        _title = pTitle;
    }

    function GetTableWidth() {
        return _TableWidth;
    }
    
    function SetTableWidth(pTableWidth) {
        _TableWidth = pTableWidth;
    }

    function SetDebugMode(pDebugMode) {
        _debugMode = pDebugMode;
    }
    
    function SetHeightFree(pSetHeightFree)
    {
        _SetHeightFree = pSetHeightFree;
    }
    

    function LoadFromID(pTableID) {
        var oList = document.getElementById(pTableID);
        if (!oList)
            return;

        if (typeof (document.body.onselectstart) != "undefined") 
            oList.onselectstart = function() { return false; }
        else if (typeof (document.body.style.MozUserSelect) != "undefined") 
            oList.style.MozUserSelect = "none";

        _isMultiSelectable = false;
        var strAttribute = GetAttribute(oList, "multiselectable");
        if (strAttribute == "true")
            _isMultiSelectable = true;

        strAttribute = GetAttribute(oList, "useocs");
        if (strAttribute == "true")
            _useOcs = true;
        else
            _useOcs = false;

        SetUseOCS(_useOcs);

        strAttribute = GetAttribute(oList, "rowonclick");
        if (strAttribute != "")
            _rowonclick = strAttribute;

        strAttribute = GetAttribute(oList, "rowondblclick");
        if (strAttribute != "")
            _rowondblclick = strAttribute;

        strAttribute = GetAttribute(oList, "contextHandler");
        if (strAttribute != "")
            _contextHandler = strAttribute;

        _thisID = oList.id;

        var arrRow = GetDataRows();
        _rowCount = (arrRow != null) ? arrRow.length : 0;

        arrRow = null;
    }

    function DataBind(pTagetID) {
        if (_thisID == "") {
            alert("리스트의 ID가 지정되지 않았습니다.");
            return;
        }

        if (_dataSource == null) {
            return;
        }
        var objElm = document.getElementById(pTagetID);
        if (objElm) {
            var oTable = document.createElement("TABLE");
            oTable.id = _thisID;

            oTable.cellSpacing = 0;
            oTable.cellPadding = 0;

            oTable.setAttribute("multiselectable", _isMultiSelectable);
            oTable.setAttribute("useocs", _useOcs);

            if (_rowonclick != null)
                oTable.setAttribute("rowonclick", _rowonclick);

            if (_rowondblclick != null)
                oTable.setAttribute("rowondblclick", _rowondblclick);

            if (_contextHandler != null)
                oTable.setAttribute("contextHandler", _contextHandler);

            if (typeof (document.body.onselectstart) != "undefined") 
                oTable.onselectstart = function() { return false; }
            else if (typeof (document.body.style.MozUserSelect) != "undefined") 
                oTable.style.MozUserSelect = "none";

            var oTHeader = GetTableHeaderObj();
            var oTBody = GetTableBodyObj();

            if (_SelectFlag && _firstRowID != "") {
                oTable.setAttribute("lastSelectedRowID", _firstRowID);
            }

            oTable.appendChild(oTHeader);
            oTable.appendChild(oTBody);

            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {

                    oTable.setAttribute("width", "100%");

                oTable.setAttribute("border", "0");
                oTable.setAttribute("cellpadding", "0");
                oTable.setAttribute("cellspacing", "0");
                if(_SetHeightFree)
                {
                    oTable.setAttribute("class", "mainlist_free");
                }
                else
                {
                    oTable.setAttribute("class", "mainlist");
                }
                
            }
            else {
                oTable.border = 0;
                oTable.cellSpacing = 0;
                oTable.cellPadding = 0;
                if(_SetHeightFree)
                {
                    oTable.className = "mainlist_free";
                }
                else
                {
                    oTable.className = "mainlist";
                }

                    oTable.width = "100%";
            }

            objElm.appendChild(oTable);

            if (_debugMode) yjTest("oTable", objElm.innerHTML);

            objElm = null;
        }
    }

    function RowDataBind() {
        if (_thisID == "") {
            alert("리스트의 ID가 지정되지 않았습니다.");
            return;
        }

        if (_dataSource == null) {
            return;
        }

        var oList = document.getElementById(_thisID);
        if (!oList)
            return;

        RemoveDataBody();

        var newTBody = GetTableBodyObj();


        oList.appendChild(newTBody);

        oldTbody = null;
        newTBody = null;
        oList = null;
    }

    function GetTableHeaderObj() {
        var objTr = document.createElement("TR");
        objTr.id = _thisID + "_TH";

        var oHeaders = _dataSource.getElementsByTagName("HEADER");

        for (var i = 0; i < oHeaders.length; i++) {
            var strWidth = SelectSingleNodeValue(oHeaders[i], "WIDTH");

            if (strWidth != "0") { 
                var strName = SelectSingleNodeValue(oHeaders[i], "NAME");

                var strStyle = SelectSingleNodeValue(oHeaders[i], "STYLE");
                var strClass = "";

                var strColName = SelectSingleNodeValue(oHeaders[i], "COLNAME");
                if (strColName == "DocTitle")
                    _titleIdx = i;

                var objTd = document.createElement("TH");

                objTd.id = _thisID + "_TH_" + i;

                if (_headeronclick != null && _headeronclick != "") {
                    objTd.style.cursor = "pointer";
                    objTd.onclick = new Function(_headeronclick + "('" + strName + "');");
                }


                if (strStyle != "") {
                    if (_headeronclick != null && _headeronclick != "") {
                        strStyle += "cursor:pointer;";
                    }

                    if (new RegExp(/MSIE/).test(navigator.userAgent)) {
                        objTd.style.setAttribute("cssText", strStyle);
                    }
                    else {
                        strStyle = strStyle.replace(/center/gi, "-moz-center");
                        objTd.setAttribute("style", strStyle);
                    }
                }

                if (strColName == "HASATTACHYN")
                    objTd.style.textAlign = "center";                

                if (strClass != "") {
                    if (i == 0) {    
                        objTd.className = "";
                    }
                    else
                        objTd.className = strClass;
                }

                if (strWidth != "") {
                    if (i != _titleIdx) {

                        if (strColName == "AttachName") {
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "60%");
                            }
                            else {
                                objTd.width = "60%";
                            }
                        }
                        else if (strColName == "AttachUserName") {
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "20%");
                            }
                            else {
                                objTd.width = "20%";
                            }
                        }
                        else if (strColName == "AttachUserDeptName") {
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "20%");
                            }
                            else {
                                objTd.width = "20%";
                            }
                        }
                        else {
                            if (_titleIdx == null && i == oHeaders.length - 1) {
                                objTd.width = strWidth + "px";
                            }
                            else {
                                if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                    objTd.setAttribute("width", strWidth + "px");
                                }
                                else {
                                    objTd.width = strWidth + "px";
                                }
                            }
                        }
                    }
                    else {
                        if (_WidthFlag) {
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "80%");
                            }
                            else {
                                objTd.width = "80%";
                            }
                        }
                        else
                            objTd.width = strWidth + "px";
                    }
                    _TableWidth = _TableWidth + parseInt(strWidth);
                }

                try {
                    if (OrderCell == strName) {
                        if (OrderOption.lastIndexOf("DESC") > -1)
                            strName += "<img src='/images/view-sortdown.gif'>";
                        else
                            strName += "<img src='/images/view-sortup.gif'>";
                    }
                } catch (e) { }

                var oText = document.createTextNode(strName);
                objTd.innerHTML = strName;
                objTr.appendChild(objTd);

                objTd = null;
                oText = null;
                oNames = null;
                oWidths = null;
            }
        }

        var objTheader = document.createElement("THEAD");
        objTheader.id = _thisID + "_THEAD";
        objTheader.appendChild(objTr);
        objTr = null;

        return objTheader;
    }

    function GetTableBodyObj() {
        var oTbody = document.createElement("TBODY");
        oTbody.style.backgroundColor = m_strColorDefault;

        var oRows = _dataSource.getElementsByTagName("ROW");
        _rowCount = oRows.length;
        
        var oHeaders;
        var colCount;
        oHeaders = _dataSource.getElementsByTagName("HEADER");
        colCount = oHeaders.length;
       if(_rowCount == 0)
        {
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + "noItems");
            oTbody.appendChild(objTr);
            var oText = document.createTextNode(strLang944);
            var objTd = document.createElement("TD");
            objTd.align = "center";
            if (colCount != 0)
                objTd.colSpan = colCount;
            objTd.appendChild(oText);
            objTr.appendChild(objTd);

             return oTbody;
        }
        for (var i = 0; i < oRows.length; i++) {
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + i);
            objTr.style.cursor = "pointer";

            objTr.onmouseover = new Function("tr_mouseover(this)");
            objTr.onmouseout = new Function("tr_mouseout(this)");

            if (_rowonclick != null)
                objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\", " + _rowonclick + ");");
            else
                objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\");");

            if (_rowondblclick != null)
                objTr.ondblclick = new Function(_rowondblclick + "(this.id);");

            if (_contextHandler != null)
                objTr.oncontextmenu = new Function(_contextHandler + "(this.id);");

            var oCells = GetElementsByTagName(oRows[i], "CELL");
           
            if (_SelectFlag && i == 0) {  
                objTr.setAttribute("selected", "true");
                objTr.style.backgroundColor = m_strColorSelect;
                _firstRowID = _thisID + "_TR_" + i;      
            }
            else {
                objTr.setAttribute("selected", "false");
            }
            var oDatas = GetDataElements(oCells[0]);
            for (var j = 0; j < oDatas.length; j++) {
                var strData = oDatas[j].tagName;
                var strValue = "";
                if (oDatas[j].firstChild != null && oDatas[j].firstChild.nodeValue != null)
                    strValue = oDatas[j].firstChild.nodeValue;

                objTr.setAttribute(strData, strValue);
            }

            oTbody.appendChild(objTr);

            for (var j = 0; j < oCells.length; j++) {
                var strValue = SelectSingleNodeValue(oCells[j], "VALUE");
                var strStyle = SelectSingleNodeValue(oCells[j], "STYLE");
                var strClass = SelectSingleNodeValue(oCells[j], "CLASSNAME");
                var oText = document.createTextNode(strValue.replace(/&amp;/gi, "&"));
                var objTd = document.createElement("TD");
                if (strStyle != "") {
                    if (new RegExp(/MSIE/).test(navigator.userAgent)) {
                        objTd.style.setAttribute("cssText", strStyle);
                    }
                    else {
                        strStyle = strStyle.replace(/center/, "-moz-center");
                        objTd.setAttribute("style", strStyle);
                    }
                }               
                if (strClass != "") {
                    objTd.className = strClass;
                }
                else {
                    if (_titleIdx == null) {            
                        if (_Align[j] == 0)
                            objTd.align = "left";
                        else
                            objTd.align = "center";

                        objTd.style.overflow = "hidden";
                        objTd.style.textOverflow = "ellipsis";
                        objTd.style.whiteSpace = "nowrap";
                    }
                    else {  
                            objTd.title = strValue;
                            objTd.style.overflow = "hidden";
                            objTd.style.textOverflow = "ellipsis";
                            objTd.style.whiteSpace = "nowrap";                           

                        if (_titleIdx == j) {
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                if (_UrgentFlag && getNodeText(oDatas[13]) == "Y") { 
                                    objTd.style.color = m_UrgentColor;
                                }
                            }
                            else {
                                if (getNodeText(_UrgentFlag && oDatas[13]) == "Y") { 
                                    objTd.style.color = m_UrgentColor;
                                }
                            }
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "80%");
                            }
                            else {
                                objTd.width = "80%";
                            }
                            objTd.className = "title";
                        }
                    
                        if (_Align[j] == 0)
                            objTd.align = "left";
                        else
                            objTd.align = "center";
                    }
                }
                if (_rowCount < 100) {
                    if (_SecIdx != j) {
                        if (_UrgentFlag && _titleIdx == j) {    
                            objTd.onmouseover = new Function("td_mouseover(this, " + _titleIdx + ")");
                            objTd.onmouseout = new Function("td_mouseout(this, " + _titleIdx + ")");
                        }
                        else {
                            objTd.onmouseover = new Function("td_mouseover(this)");
                            objTd.onmouseout = new Function("td_mouseout(this)");
                        }
                    }
                }
                if (oHeaders[j] != undefined) {
                    if (SelectSingleNodeValue(oHeaders[j], "COLNAME") == "HASATTACHYN") {
                        objTd.style.textAlign = "center";
                        if (SelectSingleNodeValue(oCells[j], "HASATTACHYN") != "N") {
                            var _img = document.createElement("img");
                            _img.src = "/images/newAttach.gif";
                            objTd.appendChild(_img);
                        }
                    }
                    else if (SelectSingleNodeValue(oHeaders[j], "COLNAME") == "ISPUBLIC") {
                        objTd.style.textAlign = "center";
                        if (SelectSingleNodeValue(oCells[j], "ISPUBLIC") == "N") {
                            var _img = document.createElement("img");
                            _img.src = "/images/icon_lock.png";
                            objTd.appendChild(_img);
                        }
                    }
                    else {
                        objTd.appendChild(oText);
                    }
                }
                else
                    objTd.appendChild(oText);
                
                objTr.appendChild(objTd);
                objTd = null;
                oText = null;
            }
            objTr = null;
            oCells = null;
            oDatas = null;
        }
        oRows = null;

        return oTbody;
    }

    function AddDataRow(objTr, addXml) {

        objTr.style.cursor = "pointer";
        objTr.onmouseover = new Function("tr_mouseover(this)");
        objTr.onmouseout = new Function("tr_mouseout(this)");

        if (_rowonclick != null)
            objTr.onclick = new Function("tr_select(\"" + objTr.id + "\", \"" + _thisID + "\", " + _rowonclick + ");");
        else
            objTr.onclick = new Function("tr_select(\"" + objTr.id + "\", \"" + _thisID + "\");");

        var oCells = GetElementsByTagName(addXml, "CELL");

        var oDatas = GetDataElements(oCells[0]);
        for (var j = 0; j < oDatas.length; j++) {
            var strData = oDatas[j].tagName;
            var strValue = "";
            if (oDatas[j].firstChild != null && oDatas[j].firstChild.nodeValue != null)
                strValue = oDatas[j].firstChild.nodeValue;

            objTr.setAttribute(strData, strValue);
        }

        for (var j = 0; j < oCells.length; j++) {
            var strValue = SelectSingleNodeValue(oCells[j], "VALUE");
            var strStyle = SelectSingleNodeValue(oCells[j], "STYLE");
            var strClass = SelectSingleNodeValue(oCells[j], "CLASSNAME");


            var oText = document.createTextNode(strValue);
            var objTd = document.createElement("TD");

            if (strStyle != "") {
                if (new RegExp(/MSIE/).test(navigator.userAgent)) {
                    objTd.style.setAttribute("cssText", strStyle);

                }
                else {
                    strStyle = strStyle.replace(/center/, "-moz-center");
                    objTd.setAttribute("style", strStyle);
                }
            }

            if (strClass != "") {
                objTd.className = strClass;
            }
            else {
            }
            
            if (_Align[j] == 0)
                objTd.align = "left";
            else
                objTd.align = "center";

            if (_SecIdx != j) {
                objTd.onmouseover = new Function("td_mouseover(this)");
                objTd.onmouseout = new Function("td_mouseout(this)");
            }
            objTd.appendChild(oText);
            objTr.appendChild(objTd);

            objTd = null;
            oText = null;
        }

        objTr = null;
        oCells = null;
        oDatas = null;
    }

    function GetDataElements(pObjElm) {
        var elements = new Array();

        var idx = 0;
        for (var i = 0; i < pObjElm.childNodes.length; i++) {
            if (pObjElm.childNodes[i].tagName != null && pObjElm.childNodes[i].tagName != "VALUE") {
                elements[idx++] = pObjElm.childNodes[i];
            }
        }
        return elements;
    }

    function RemoveDataBody() {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;
            
         if (oList.childNodes.length <=1)
            return;
        
        for(var i=oList.childNodes.length -1 ; i >= 0 ; i--)
        {
            if(oList.childNodes[i].nodeName =="TBODY")
                oList.removeChild(oList.childNodes[i]);
        }
        
        for (var i = oList.rows.length - 1; i > 0; i--) {
            if (oList.rows[i].id.indexOf("TR") >= 0) {
                oList.deleteRow(i);
            }
        }
        
        
    }

    function GetRowCount() {
        var arrRow = GetDataRows();
        if (arrRow != null)
            _rowCount = arrRow.length;
        else
            _rowCount = 0;

        arrRow = null;

        return _rowCount;
    }

    function GetDataRows() {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;

        var elements = null;

        if (oList.rows.length > 0) {
            elements = new Array();
            var idx = 0;
            for (var i = 0; i < oList.rows.length; i++) {
                if (oList.rows[i].id.indexOf("TR") >= 0)
                    elements[idx++] = oList.rows[i];
            }
        }
        oList = null;

        return elements;
    }

    function ExistRow(pAttribute, pValue) {
        var bFlag = false;
        var oList = document.getElementById(_thisID);
        if (!oList)
            return bFlag;

        var arrRow = GetDataRows();
        if (arrRow != null) {
            for (var i = 0; i < arrRow.length; i++) {
                var strAttribute = GetAttribute(arrRow[i], pAttribute);
                if (strAttribute.toUpperCase() == pValue.toUpperCase()) {
                    bFlag = true;
                    break;
                }
            }
        }
        return bFlag;
    }

    function AddRow(pIdx) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return null;

        if (pIdx == null || pIdx == "undefined")
            pIdx = 0;

        var objTr = null;
        if (new RegExp(/MSIE/).test(navigator.userAgent)) {
            objTr = oList.insertRow((pIdx + 1));
            objTr.setAttribute("id", _thisID + "_TR_" + pIdx);
        }
        else {
            var oBody = oList.childNodes[1];

            objTr = oBody.insertRow((pIdx));
            objTr.setAttribute("id", _thisID + "_TR_" + pIdx);
        }

        objTr.style.cursor = "pointer";
        objTr.onmouseover = new Function("tr_mouseover(this)");
        objTr.onmouseout = new Function("tr_mouseout(this)");

        if (_rowonclick != null)
        {
            objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\", " + _rowonclick + ");");
        }
        else
        {
            objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\");");
        }
        
        if (_rowondblclick != null)
            objTr.ondblclick = new Function(_rowondblclick + "(this.id);");
        else
            objTr.ondblclick = new Function(_rowondblclick + "(this.id);");

        return objTr;
    }

    function NewAddRow(pIdx, id) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return null;

        if (pIdx == null || pIdx == "undefined")
            pIdx = 0;

        var objTr = null;
        if (new RegExp(/MSIE/).test(navigator.userAgent)) {
            objTr = oList.insertRow((pIdx + 1));
            objTr.setAttribute("id",  id);
        }
        else {
            var oBody = oList.childNodes[1];

            objTr = oBody.insertRow((pIdx));
            objTr.setAttribute("id", id);
        }

        objTr.style.cursor = "pointer";
        objTr.onmouseover = new Function("tr_mouseover(this)");
        objTr.onmouseout = new Function("tr_mouseout(this)");

        if (_rowonclick != null)
        {
            objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\", " + _rowonclick + ");");
        }
        else
        {
            objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\");");
        }
        
        if (_rowondblclick != null)
            objTr.ondblclick = new Function(_rowondblclick + "(this.id);");
        else
            objTr.ondblclick = new Function(_rowondblclick + "(this.id);");

        return objTr;
    }
    
    function DeleteRow(pIds) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return null;

        var arrIds = pIds.split(",");
        for (var i = 0; i < arrIds.length; i++) {
            var arrRow = GetDataRows();

            for (var j = 0; j < arrRow.length; j++) {
                if (arrRow[j].id == arrIds[i]) {
                    var tmpIdx = j + 1;
                    oList.deleteRow(tmpIdx);
                    break;
                }
            }
        }
    }    
    
    function GetSelectedRowID(pIdx) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;
        return oList.childNodes[1].childNodes[pIdx].id;
    }

    function CreateTabelCell(pText) {
        var oText = document.createTextNode(pText);
        var objTd = document.createElement("TD");
        objTd.appendChild(oText);

        oText = null;
        return objTd;
    }

    function GetSelectedRows() {
        var elements = new Array();
        var arrRow = GetDataRows();

        var length = (arrRow != null) ? arrRow.length : 0;

        var idx = 0;
        for (var i = 0; i < length; i++) {
            var strAttribute = GetAttribute(arrRow[i], "selected");
            if (strAttribute == "true") {
                elements[idx++] = arrRow[i];
            }
        }

        return elements;
    }

    function GetSelectedIndexes() {
        var strIdx = "";

        var arrRow = GetDataRows();
        for (var i = 0; i < arrRow.length; i++) {
            var strAttribute = GetAttribute(arrRow[i], "selected");
            if (strAttribute == "true") {
                strIdx += i + ",";
            }
        }

        if (strIdx.substring(strIdx.length - 1) == ",")
            strIdx = strIdx.substring(0, strIdx.length - 1);

        return strIdx;
    }
    
    function GetUnSelectedIndexes() {
        var strIdx = "";

        var arrRow = GetDataRows();
        for (var i = 0; i < arrRow.length; i++) {
            var strAttribute = GetAttribute(arrRow[i], "selected");
            if (strAttribute == "false") {
                strIdx += i + ",";
            }
        }

        if (strIdx.substring(strIdx.length - 1) == ",")
            strIdx = strIdx.substring(0, strIdx.length - 1);

        return strIdx;
    }

    function SetSelectedIndex(pIdx) {
        tr_unselectedAll(_thisID);

        var strRowID = _thisID + "_TR_" + pIdx;
        var objTr = document.getElementById(strRowID);

        if (objTr) {
            objTr.setAttribute("selected", "true");
            objTr.style.backgroundColor=m_strColorSelect;

            var oList = document.getElementById(_thisID);
            oList.setAttribute("lastSelectedRowID", strRowID);
        }
    }
    
    function SetSelectedID(pID) {
        tr_unselectedAll(_thisID);
        
        var objTr = document.getElementById(pID);

        if (objTr) {
            objTr.setAttribute("selected", "true");
            objTr.style.backgroundColor=m_strColorSelect;

            var oList = document.getElementById(_thisID);
            oList.setAttribute("lastSelectedRowID", pID);
        }
    }

    function RowMoveUp() {
        var stridx = this.GetSelectedIndexes();

        if (stridx.indexOf(",") > -1)
            return;

        if (stridx == 0)
            return;

        var tBody = document.getElementById(_thisID).childNodes[1];
        var selectNode = tBody.childNodes[parseInt(stridx)];
        var targetNode = tBody.childNodes[parseInt(stridx) - 1];

        tBody.insertBefore(selectNode, targetNode);
    }

    function RowMoveDown() {
        var stridx = this.GetSelectedIndexes();

        if (stridx.indexOf(",") > -1)
            return;

        var tBody = document.getElementById(_thisID).childNodes[1];
        if (stridx == tBody.childNodes.length - 1)
            return;

        var selectNode = tBody.childNodes[parseInt(stridx)];
        var targetNode = tBody.childNodes[parseInt(stridx) + 1];

        tBody.insertBefore(selectNode, targetNode.nextSibling);
    }

    function SetUserBrower() {
        if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
            _IE = false;
            _useOcs = false;
        }
    }

    function ListView_ToString() {
        return "KAONI ListView";
    }    
}

function tr_select(pRowID, pTableID, callbackFunc) {

    var oList = document.getElementById(pTableID);
    if (!oList)
        return;

    var oSourceTr = document.getElementById(pRowID);
    if (!oSourceTr)
        return;

    var bMultiSelectable = false;
    var strAttribute = GetAttribute(oList, "multiselectable");
    if (strAttribute == "true") {
        bMultiSelectable = true;
    }

    if (bMultiSelectable && PressShiftKey) {
        tr_selectBlock(pRowID, pTableID);
        return;
    }

    if (bMultiSelectable == false || PressCtrlKey == false)
        tr_unselectedAll(pTableID);       

    strAttribute = GetAttribute(oSourceTr, "selected");

    if (strAttribute == "true") {
        oSourceTr.setAttribute("selected", "false");
    }
    else {
        oSourceTr.setAttribute("selected", "true");
        oSourceTr.style.backgroundColor =  m_strColorSelect;
    }

    oList.setAttribute("lastSelectedRowID", pRowID);

    oList = null;
    oSourceTr = null;

    if (PressCtrlKey == false && PressShiftKey == false) {
        if (callbackFunc && typeof (callbackFunc) == "function")
            callbackFunc(pRowID);
    }
}

function tr_unselectedAll(pTableID) {
    var oList = document.getElementById(pTableID);
    if (!oList)
        return;

    for (var i = 0; i < oList.rows.length; i++) {
        var strID ;
       if(oList.rows[i].id.indexOf(pTableID)>-1)
        strID = oList.rows[i].id;
        var objTr = document.getElementById(strID);

        if (objTr) {
            objTr.setAttribute("selected", false);
            
            objTr.style.backgroundColor = m_strColorDefault;
           
                objTr.style.backgroundColor = m_strColorDefault;

                
                
        }
        objTr = null;
    }
}

function tr_selectBlock(pRowID, pTableID) {
    var oList = document.getElementById(pTableID);
    if (!oList)
        return;

    var lastSelectedRowID = GetAttribute(oList, "lastSelectedRowID");

    tr_unselectedAll(pTableID);

    var lastSelectedIndex = "0";
    if (lastSelectedRowID != "")
        lastSelectedIndex = lastSelectedRowID.substring(lastSelectedRowID.lastIndexOf("_") + 1);

    var currentSelectedIndex = pRowID.substring(pRowID.lastIndexOf("_") + 1);

    var currentIdx = 0;
    var lastIdx = 0;

    if (parseInt(lastSelectedIndex) > parseInt(currentSelectedIndex)) {
        currentIdx = parseInt(currentSelectedIndex);
        lastIdx = parseInt(lastSelectedIndex);
    }
    else {
        currentIdx = parseInt(lastSelectedIndex);
        lastIdx = parseInt(currentSelectedIndex);
    }

    for (var i = currentIdx; i <= lastIdx; i++) {
        var strID = pTableID + "_TR_" + i;
        var objTr = document.getElementById(strID);

        if (objTr) {
            objTr.setAttribute("selected", true);
            objTr.style.backgroundColor = m_strColorSelect;
        }

        objTr = null;
    }
}

function tr_mouseover(pRow) {
    var strAttribute = GetAttribute(pRow, "selected");
    if (strAttribute != "true") {
        pRow.style.backgroundColor=m_strColorOver;              

    }

    pRow = null;
}

function tr_mouseout(pRow) {
    var strAttribute = GetAttribute(pRow, "selected");
    if (strAttribute != "true")
        pRow.style.backgroundColor=m_strColorDefault;
    else
        pRow.style.backgroundColor=m_strColorSelect;

    pRow = null;
}

function td_mouseover(td) {

}

function td_mouseout(td, titIdx) {
}

function yjTest(pArea, pStr) {
    var testText = document.getElementById("txtTest");

    if (!testText) {
        testText = document.createElement("TEXTAREA");
        testText.id = "txtTest";
        testText.rows = "30";
        testText.cols = "170";
    }

    testText.value += "## " + pArea + " 시작 #########################################################\r\n";
    testText.value += pStr + "\r\n";
    testText.value += "## " + pArea + " 끝 ###########################################################\r\n";

    document.body.appendChild(testText);
    testText = null;
}

try {
    HTMLElement.prototype.__defineGetter__
	(
		"innerText", function()
		{
		    var textRange = this.ownerDocument.createRange();
		    textRange.selectNodeContents(this);
		    return textRange.toString().trim();
		}
	);
}
catch (e)
{ }
String.prototype.trim = function() {
    var str = this.replace(/(\s+$)/g, "");
    return str.replace(/(^\s*)/g, "");
}
function getOriginXML(pTagetID)
{    
    var objElm = document.getElementById(pTagetID);
        
    var objHeader = objElm.getElementsByTagName("TH");
    var objBody = objElm.getElementsByTagName("TBODY");
    var objBodyData = objElm.getElementsByTagName("TR");
    var xmlHeader="";
    var xmlBody="";
    
    for(var i=0; i<objHeader.length; i++)
    {
        xmlHeader += "<HEADER>";
        xmlHeader += "<NAME>" + getNodeText(objHeader[i]) + "</NAME>";                
        var width = GetAttribute(objHeader[i], "width");
        
        if(width.indexOf("px") > -1)
        {
            width = width.substring(0, width.length - 2);            
        }        
        xmlHeader += "<WIDTH>" + width + "</WIDTH>";
        xmlHeader += "<COLNAME></COLNAME>";
        xmlHeader += "</HEADER>";
    }
    for(var i=1; i<objBodyData.length; i++)
    {
        alert(objBodyData[i].cells.length);
        xmlBody += "<ROW><CELL>";
        xmlBody += "<VALUE>" + getNodeText(objBodyData[i]) + "</VALUE>";
        for(var x=0; x<1; x++)
        {
        }
        
        xmlBody += "</CELL></ROW>";
    } 
}

function SetUnSelected(pTableID) {
    tr_unselectedAll(pTableID);
}