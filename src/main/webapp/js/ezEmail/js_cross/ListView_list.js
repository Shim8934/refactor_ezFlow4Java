var PressCtrlKey = false;
var PressShiftKey = false;
var m_strColorSelect =  "#f1f8ff";
var m_strColorDefault =  "#FFFFFF";
var m_strColorOver = "#f4f5f5";
var m_UrgentColor = "#E9101A";
var HeaerCnt = 0;

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
    if (typeof (document.body.onselectstart) != "undefined") //IE route
        document.body.onselectstart = function() { return false; }
    else if (typeof (document.body.style.MozUserSelect) != "undefined") //Firefox route
        document.body.style.MozUserSelect = "none";
    else //All other route (ie: Opera)
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
    this.RowDataBind2 = RowDataBind2;
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
    
    //사용자 정의 이벤트 지정
    this.SetHeaderOnClick = SetHeaderOnClick;
    this.SetHeaderOnDblClick = SetHeaderOnDblClick;
    this.SetRowOnClick = SetRowOnClick;
    this.SetRowOnDblClick = SetRowOnDblClick;
    this.SetContextHandler = SetContextHandler;

    this.SetDebugMode = SetDebugMode;
    this.toString = ListView_ToString;
    this.SetHeightFree = SetHeightFree;
    this.SetUseCheckBox = SetUseCheckBox;
    /* Public Member 선언 끝 */

    /* Private Member 선언 시작 */
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
    var _UseCheckBox = false;
    /* Private Member 선언 끝 */

    //ID 지정
    function SetID(pObjID) {
        if (pObjID != "")
            _thisID = pObjID;
    }
    function GetID() {
        return _thisID;
    }
    //TitleIdx 
    function SetTitleIdx(idx) {
        if (idx != "")
            _titleIdx = idx;
    }
    //보안등급Idx 
    function SetSecIdx(idx) {
        if (idx != "")
            _SecIdx = idx;
    }
    //Width 1024 여부
    function SetWidthFlag(flag) {
        _WidthFlag = flag;
    }
    //첫번째값 선택여부 
    function SetSelectFlag(flag) {
        _SelectFlag = flag;
    }
    //리스트뷰의 DataSource 지정 (XML)
    function DataSource(pDataSource) {
        _dataSource = pDataSource;
    }

    //왼쪽정렬이 필요한 필드
    function SetAlignLeft(pAlign) {
        _AlignLeft = pAlign;
    }
    // 긴급결재 표시처리
    function SetUrgentFlag(flag) {
        _UrgentFlag = flag;
    }

    // 리스트헤더 정렬 배열
    function SetAlignArr(arry) {
        _Align = arry;
    }
    
    // 리스트 타입 추가  // 9 : 수신문서의 경우 읽지않은 문서 볼드처리를 위해 추가함.
    function SetListType(pListType) {
        _ListType = pListType;
    }

    //헤더 클릭 이벤트 핸들러 지정
    function SetHeaderOnClick(pHeaderOnClick) {
        _headeronclick = pHeaderOnClick;
    }

    //헤더 더블클릭 이벤트 핸들러 지정
    function SetHeaderOnDblClick(pHeaderOnDblClick) {
        _headerondblclick = pHeaderOnDblClick;
    }

    //로우 클릭 이벤트 핸들러 지정
    function SetRowOnClick(pRowOnClick) {
        _rowonclick = pRowOnClick;
    }

    //로우 더블 클릭 이벤트 핸들러 지정
    function SetRowOnDblClick(pRowOnDblClick) {
        _rowondblclick = pRowOnDblClick;
    }

    //로우 컨텍스트 메뉴 핸들러 지정
    function SetContextHandler(pContextHandler) {
        _contextHandler = pContextHandler;
    }

    //멀티 선택 기능 지정 (true : 멀티선택 가능, false : 멀티선택 불가)
    function SetMulSelectable(pSelectable) {
        _isMultiSelectable = pSelectable;

        if (_isMultiSelectable)
            add_key_event();
    }

    //OCS 사용여부 지정
    function SetUseOCS(pUseOcs) {
        _useOcs = pUseOcs;
        SetUserBrower();
    }

    //풍선 도움말 지정
    function SetTitle(pTitle) {
        _title = pTitle;
    }

    function GetTableWidth() {
        return _TableWidth;
    }
    
    //List View 크기 지정
    function SetTableWidth(pTableWidth) {
        _TableWidth = pTableWidth;
    }

    //디버그 모드
    //리스트뷰의 HTML을 document.body에 출력
    function SetDebugMode(pDebugMode) {
        _debugMode = pDebugMode;
    }
    
    function SetHeightFree(pSetHeightFree)
    {
        _SetHeightFree = pSetHeightFree;
    }
    
    // 체크박스 사용여부
    function SetUseCheckBox(pUseCheckBox) { 
    	_UseCheckBox = pUseCheckBox;
    }

    //이미 만들어진 리스트뷰 ID를 이용하여 리스트뷰 객체 생성	
    function LoadFromID(pTableID) {
        var oList = document.getElementById(pTableID);
        if (!oList)
            return;

        if (typeof (document.body.onselectstart) != "undefined") //IE route
            oList.onselectstart = function() { return false; }
        else if (typeof (document.body.style.MozUserSelect) != "undefined") //Firefox route
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

    //리스트뷰 DataSource를 이용하여 DataBind 하기
    function DataBind(pTagetID) {
        if (_thisID == "") {
            alert(strLangLHM03);
            return;
        }

        if (_dataSource == null) {
            //alert(strLangLHM04);
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

            if (typeof (document.body.onselectstart) != "undefined") //IE route
                oTable.onselectstart = function() { return false; }
            else if (typeof (document.body.style.MozUserSelect) != "undefined") //Firefox route
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

    function RowDataBind2()
    {
        if (_thisID == "")
        {
            alert(strLangLHM03);
            return;
        }

        if (_dataSource == null)
        {
            alert(strLangLHM04);
            return;
        }
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;



        
        if (gubunid = "simple") {

            var newTBody = GetTableBodyObj3();

        }
        else {
            var newTBody = GetTableBodyObj2();
        }


        oList.appendChild(newTBody);

        oldTbody = null;
        newTBody = null;
        oList = null;
    }

    function RowDataBind() {
        if (_thisID == "") {
            alert(strLangLHM03);
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

    //리스트뷰 헤더 생성
    function GetTableHeaderObj() {
        var objTr = document.createElement("TR");
        objTr.id = _thisID + "_TH";

        var oHeaders = _dataSource.getElementsByTagName("HEADER");
        
        for (var i = 0; i < oHeaders.length; i++) {
            var strWidth = SelectSingleNodeValue(oHeaders[i], "WIDTH");
            
            if(strWidth != "0"){ 
                var strName = SelectSingleNodeValue(oHeaders[i], "NAME");
                
                var strStyle = SelectSingleNodeValue(oHeaders[i], "STYLE");
                var strClass = "h5_center";  
                
                var strColName = SelectSingleNodeValue(oHeaders[i], "COLNAME");
                if(strColName == "DocTitle")
                    _titleIdx = i;

                var strIsCheckBox = SelectSingleNodeValue(oHeaders[i], "ISCHECKBOX");
                
                var objTd = document.createElement("TH");

                objTd.id = _thisID + "_TH_" + i;

                if (_headeronclick != null && _headeronclick != "" ) {
                    objTd.style.cursor = "pointer";
                    objTd.onclick = new Function(_headeronclick + "('" + strName + "');");
                }


                if (strStyle != "") {
                    if (_headeronclick != null && _headeronclick != ""  ) {
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

                if (strClass != "") {
                    if (i == 0) {       
                        objTd.className = "h4_center";
                        objTd.setAttribute("bgcolor", "#CCCCCC");
                    }
                    else
                        objTd.className = strClass;
                }        

                if (strWidth != "") {
                    if (i != _titleIdx) {
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

                var oText = document.createTextNode(strName);
                
                if (strIsCheckBox != "" && _UseCheckBox) {
            		var inputChkBox = document.createElement("input");
            		inputChkBox.type = "checkbox";
            		inputChkBox.className = "checkAll";
            		
            		oText = inputChkBox;
                }
                
                objTd.appendChild(oText);
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


    function GetTableBodyObj2() {

        var oTbody = document.createElement("TBODY");
        oTbody.style.backgroundColor = m_strColorDefault;

        var oRows = _dataSource.getElementsByTagName("ROW");
        _rowCount = oRows.length;

        var oHeaders = _dataSource.getElementsByTagName("HEADER");
        var colCount = oHeaders.length;

        for (var i = 0; i < oRows.length; i++) {
            susinTo++;
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + susinTo);
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
                objTr.className = "";
                objTr.style.backgroundColor = m_strColorDefault;
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

            var colcnt = oCells.length;
            if (HeaerCnt < colcnt)
                colcnt = HeaerCnt;

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

                    objTd.className = "l_txt";
                    objTd.style.overflow = "hidden";

                    if (!_SetHeightFree)
                        objTd.height = "24";

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
                            if (_UrgentFlag && oDatas[13].textContent == "Y") {   
                                objTd.style.color = m_UrgentColor;
                            }
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "80%"); 
                            }
                            else {
                                objTd.width = "80%"; 
                            }

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




    function GetTableBodyObj3() {

        var oTbody = document.createElement("TBODY");
        oTbody.style.backgroundColor = m_strColorDefault;

        var oRows = _dataSource.getElementsByTagName("ROW");
        _rowCount = oRows.length;

        var oHeaders = _dataSource.getElementsByTagName("HEADER");
        var colCount = oHeaders.length;


        for (var i = 0; i < oRows.length; i++) {
            susinTo++;

            var objTr = document.createElement("TR");
            
            var testcount = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).childNodes.length;
            
            for (var a = 0; a < testcount; a++) {
                if (document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children.item(a).id == _thisID + "_TR_" + susinTo) {
                    susinTo = susinTo + 10;
                }
            }
            objTr.setAttribute("id", _thisID + "_TR_" + susinTo);
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

            if (_SelectFlag && i == 0) {   //첫번째 row 선택지정 or 특정 row 선택
                objTr.setAttribute("selected", "true");
                objTr.style.backgroundColor = m_strColorSelect;

                _firstRowID = _thisID + "_TR_" + i;
            }
            else {
                objTr.setAttribute("selected", "false");
                objTr.className = "";
                objTr.style.backgroundColor = m_strColorDefault;
            }

            //DATA1, DATA2, DATA3... 등의 값 세팅
            var oDatas = GetDataElements(oCells[0]);
            for (var j = 0; j < oDatas.length; j++) {
                var strData = oDatas[j].tagName;
                var strValue = "";
                if (oDatas[j].firstChild != null && oDatas[j].firstChild.nodeValue != null)
                    strValue = oDatas[j].firstChild.nodeValue;

                objTr.setAttribute(strData, strValue);
            }

            oTbody.appendChild(objTr);

            var colcnt = oCells.length;
            if (HeaerCnt < colcnt)
                colcnt = HeaerCnt;

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

                    objTd.className = "l_txt";
                    objTd.style.overflow = "hidden";

                    if (!_SetHeightFree)
                        objTd.height = "24";

                    if (_titleIdx == null) {                 
                        if (_Align[j] == 0)
                            objTd.align = "left"; 
                        else
                            objTd.align = "center";

                        objTd.style.overflow = "hidden";
                        objTd.style.textOverflow = "ellipsis";
                        objTd.style.whiteSpace = "nowrap";
                    }
                    else {  //상단 리스트일경우

                        objTd.title = strValue;
                        objTd.style.overflow = "hidden";
                        objTd.style.textOverflow = "ellipsis";
                        objTd.style.whiteSpace = "nowrap";

                        if (_titleIdx == j) {
                            if (_UrgentFlag && oDatas[13].textContent == "Y") {   
                                objTd.style.color = m_UrgentColor;
                            }
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "80%"); 
                            }
                            else {
                                objTd.width = "80%"; 
                            }

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
    

    //리스트뷰 바디 생성
    function GetTableBodyObj() {
        var oTbody = document.createElement("TBODY");
        oTbody.style.backgroundColor = m_strColorDefault;

        var oRows = _dataSource.getElementsByTagName("ROW");
        _rowCount = oRows.length;
        
        var oHeaders = _dataSource.getElementsByTagName("HEADER");
        var colCount = oHeaders.length;


        
        for (var i = 0; i < oRows.length; i++) {
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + i);
            objTr.style.cursor = "move"; // [수신자 설정] TO/CC/BCC란 로드 직후 MsgTo/CC/BCCList

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
                objTr.className = "";
                objTr.style.backgroundColor = m_strColorDefault;
            }

            //DATA1, DATA2, DATA3... 등의 값 세팅
            var oDatas = GetDataElements(oCells[0]);
            for (var j = 0; j < oDatas.length; j++) {
                var strData = oDatas[j].tagName;
                var strValue = "";
                if (oDatas[j].firstChild != null && oDatas[j].firstChild.nodeValue != null)
                    strValue = oDatas[j].firstChild.nodeValue;

                objTr.setAttribute(strData, strValue);
            }

            oTbody.appendChild(objTr);

            if (_UseCheckBox) {
                var M_TR_TD_Chk = document.createElement("TD");
                M_TR_TD_Chk.style.padding = "5px";
                M_TR_TD_Chk.innerHTML = "<input type='checkbox' class='checkUser' />";
                objTr.appendChild(M_TR_TD_Chk);
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
                    
                    if(!_SetHeightFree)
                        objTd.height = "24";                    
                        
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
                            if (_UrgentFlag && oDatas[13].textContent == "Y") {   //DATA14값
                                objTd.style.color = m_UrgentColor;
                            }
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "80%");
                            }
                            else {
                                objTd.width = "80%";
                            }

                        }
                    
                        if (_Align[j] == 0)
                            objTd.align = "left";
                        else
                            objTd.align = "center";
                    }

                }

                if (_rowCount < 100) {
                    if (_SecIdx != j) {
                        if (_UrgentFlag && _titleIdx == j) {       //2010.05.04 제목 긴급일 경우 붉은색 처리로 추가함.
                            objTd.onmouseover = new Function("td_mouseover(this, " + _titleIdx + ")");
                            objTd.onmouseout = new Function("td_mouseout(this, " + _titleIdx + ")");
                        }
                        else {
                            objTd.onmouseover = new Function("td_mouseover(this)");
                            objTd.onmouseout = new Function("td_mouseout(this)");
                        }
                    }
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
        oRows = null;

        return oTbody;
    }

    //리스트뷰에 Row 추가
    function AddDataRow(objTr, addXml) {

        objTr.style.cursor = "move"; // [수신자 설정] TO/CC/BCC란으로 이동 후 MsgTo/CC/BCCList
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
                objTd.style.overflow = "hidden";
                objTd.style.textOverflow = "ellipsis";
                objTd.style.whiteSpace = "nowrap";
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
            
            // 수정 수아 재은
            objTr.draggable = "true";
            
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

        if (document.getElementById(_thisID).childNodes[1].innerHTML == "") {
            return "";
        }

        return oList.childNodes[1].childNodes[pIdx].getAttribute("id");
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
    
    //지정한 ID에 해당하는 Row 선택
    function SetSelectedID(pID) {
        tr_unselectedAll(_thisID);
        
        var objTr = document.getElementById(pID);

        if (objTr) {
            objTr.setAttribute("selected", "true");
            objTr.style.backgroundColor=m_strColorSelect;

            //마지막 선택 ID 지정
            var oList = document.getElementById(_thisID);
            oList.setAttribute("lastSelectedRowID", pID);
        }
    }

    //선택된 ROW를 위로 한 단계 이동
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

    //선택된 ROW를 아래로 한 단계 이동
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

    //사용자 브라우저 확인
    //IE가 아닌경우 OCS Presence 무조건 사용안함
    function SetUserBrower() {
        if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
            _IE = false;
            _useOcs = false;
        }
    }

    function ListView_ToString() {
        return "KAONI ListView";
    }    
} // ListView 클래스 끝

// 리스트 클래스 끝
//###########################################################################################

//ROW 선택 함수
function tr_select(pRowID, pTableID, callbackFunc) {
	
	pTableID = document.getElementById(pRowID).parentNode.parentNode.id;

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
        oSourceTr.style.backgroundColor = m_strColorDefault;
    }
    else {
        oSourceTr.setAttribute("selected", "true");
        oSourceTr.style.backgroundColor =  m_strColorSelect;
    }

    //각 리스트마다 마지막으로 선택한 ID를 보관한다.
    oList.setAttribute("lastSelectedRowID", pRowID);

    oList = null;
    oSourceTr = null;

    if (PressCtrlKey == false && PressShiftKey == false) {
        if (callbackFunc && typeof (callbackFunc) == "function")
            callbackFunc(pRowID);
    }
}

//모든 ROW를 선택 해제하는 함수
function tr_unselectedAll(pTableID) {
    var oList = document.getElementById(pTableID);
    if (!oList)
        return;

    for (var i = 0; i < oList.rows.length; i++) {

        var strID ;
       //if(oList.rows[i].id.indexOf(pTableID)>-1)
        strID = oList.rows[i].id;
        var objTr = document.getElementById(strID);

        if (objTr) {
            objTr.setAttribute("selected", false);
            objTr.className = "";
            objTr.style.backgroundColor =  m_strColorDefault;
        }
        objTr = null;
    }
}

//컨트롤 혹은 쉬프트 키를 이용한 멀티 선택 함수
function tr_selectBlock(pRowID, pTableID) {
    var oList = document.getElementById(pTableID);
    var moveReceive = false;
    if (!oList)
        return;

    var lastSelectedRowID = GetAttribute(oList, "lastSelectedRowID");

    tr_unselectedAll(pTableID);
    
    if (pTableID == 'MsgToList' || pTableID == 'MsgCCList' || pTableID == 'MsgBCCList') {
    	moveReceive = true;
    }

    var lastSelectedIndex = "0";
    var currentSelectedIndex = "0";
    
    if (lastSelectedRowID != "") {
    	if (moveReceive == true) {
    		lastSelectedIndex = $("#" + pTableID + " tr").index($("#" + lastSelectedRowID));
    		currentSelectedIndex = $("#" + pTableID + " tr").index($("#" + pRowID));
    	} else {
    		lastSelectedIndex = lastSelectedRowID.substring(lastSelectedRowID.lastIndexOf("_") + 1);
    		currentSelectedIndex = pRowID.substring(pRowID.lastIndexOf("_") + 1);
    	}
    }
    
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
        if (moveReceive) {
    		var objTr = $("#" + pTableID + " tr:eq(" + i + ")")[0];
    	} else {
    		var strID = pTableID + "_TR_" + i;
    		var objTr = document.getElementById(strID);
    	}
    	

        if (objTr) {
            objTr.setAttribute("selected", true);
            objTr.style.backgroundColor = m_strColorSelect;
        }

        objTr = null;
    }
}

//마우스 오버
function tr_mouseover(pRow) {
    var strAttribute = GetAttribute(pRow, "selected");
    if (strAttribute != "true") {
        pRow.style.backgroundColor=m_strColorOver;      

    }

    pRow = null;
}

//마우스 아웃
function tr_mouseout(pRow) {
    var strAttribute = GetAttribute(pRow, "selected");
    if (strAttribute != "true")
        pRow.style.backgroundColor=m_strColorDefault;
    else
        pRow.style.backgroundColor=m_strColorSelect;

    pRow = null;
}

//마우스 오버
function td_mouseover(td) {

}

//마우스 아웃
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
{console.log(e);}
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
        xmlHeader += "<NAME>" + objHeader[i].innerText + "</NAME>";                
        var width = objHeader[i].getAttribute("width");
        
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
        xmlBody += "<VALUE>" + objBodyData[i].innerText + "</VALUE>";
        for(var x=0; x<1; x++)
        {
        }
        
        xmlBody += "</CELL></ROW>";
    } 
}
