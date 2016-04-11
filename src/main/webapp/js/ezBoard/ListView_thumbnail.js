/*###########################################################################################



###########################################################################################*/


//###########################################################################################
// 컨트롤, 쉬프트 키를 사용하도록 하기 위한 편법 시작

//컨트롤키나 쉬프트 키가 눌려졌음을 체크하는 FLAG
var PressCtrlKey = false;
var PressShiftKey = false;
//모질라 계열의 브라우저에서는 event.ctrlKey 등이 작동하지 않는다.
//따라서 List의 SetMulSelectable 속성의 값이 true인 경우에만
//document 객체에 keydown, keyup 이벤트를 등록하여 FLAG의 값을 지정한다.
var m_strColorSelect = "#DBE1E7";
var m_strColorDefault =  "#FFFFFF";
var m_strColorOver = "#f4f5f5";
var m_UrgentColor = "#E9101A";
var listEventCheckbox = false;

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
    //disable_browser_selection();
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

// 컨트롤, 쉬프트 키를 이용하여 다중 선택을 하는 경우
// 브라우저 기본 셀렉트 이벤트를 막기위한 방편
function disable_browser_selection() {
    if (typeof (document.body.onselectstart) != "undefined") //IE route
        document.body.onselectstart = function() { return false; }
    else if (typeof (document.body.style.MozUserSelect) != "undefined") //Firefox route
        document.body.style.MozUserSelect = "none";
    else //All other route (ie: Opera)
        document.body.onmousedown = function() { return false; }

    document.body.style.cursor = "default";
}

// 컨트롤, 쉬프트 키를 사용하도록 하기 위한 편법 끝
//###########################################################################################


//###########################################################################################
// ListView 클래스 시작
function ListView() {
    /* Public Member 선언 시작 */
    this.DataSource = DataSource;
    this.DataBind = DataBind;
    this.SetID = SetID;
    this.GetID = GetID;
    this.SetMulSelectable = SetMulSelectable;
    this.GetRowCount = GetRowCount;
    this.GetDataRows = GetDataRows;
    this.LoadFromID = LoadFromID;
    this.AddRow = AddRow;
    this.DeleteRow = DeleteRow;
    this.GetSelectedRows = GetSelectedRows;
    this.GetSelectedIndexes = GetSelectedIndexes;
    this.GetUnSelectedIndexes = GetUnSelectedIndexes;
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
    
    //사용자 정의 이벤트 지정
    this.SetHeaderOnClick = SetHeaderOnClick;
    this.SetHeaderOnDblClick = SetHeaderOnDblClick;
    this.SetRowOnClick = SetRowOnClick;
    this.SetRowOnDblClick = SetRowOnDblClick;
    this.SetContextHandler = SetContextHandler;

    this.SetDebugMode = SetDebugMode;
    this.toString = ListView_ToString;
    this.SetHeightFree = SetHeightFree;
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
            alert("리스트의 ID가 지정되지 않았습니다.");
            return;
        }

        if (_dataSource == null) {
            alert("데이터가 지정되지 않았습니다.");
            return;
        }
        //RemoveDataBody()
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

                /*if (_WidthFlag && _TableWidth > 835 && _titleIdx == null)
                    oTable.setAttribute("width", _TableWidth);
                else*/
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
                
                //비 IE 브라우저에서 table-layout:fixed;를 지정하기 위해서는 
                //테이블의 width가 반드시 지정되어 있어야 한다.
                //비 IE 브라우저에서 헤더가 고정된 테이블을 사용하기 위해서는
                //tBody에 높이가 지정되어 있어야 한다.
                //oTBody.style.height = objElm.style.height.replace("px", "") - 35;
            }
            else {
                oTable.border = 0;
                oTable.cellSpacing = 0;
                oTable.cellPadding = 0;
                //oTable.className = "mainlist";
                if(_SetHeightFree)
                {
                    oTable.className = "mainlist_free";
                }
                else
                {
                    oTable.className = "mainlist";
                }

                /*oTable.style.tableLayout = "fixed";
                if (_WidthFlag && _TableWidth > 835  && _titleIdx == null)
                    oTable.width = _TableWidth;
                else*/
                    oTable.width = "100%";
            }

            objElm.appendChild(oTable);

            if (_debugMode) yjTest("oTable", objElm.innerHTML);

            objElm = null;
        }
    }

    //헤더없이 Row만 존재하는 DataSource를 위한 메소드
    function RowDataBind() {
        if (_thisID == "") {
            alert("리스트의 ID가 지정되지 않았습니다.");
            return;
        }

        if (_dataSource == null) {
            alert("데이터가 지정되지 않았습니다.");
            return;
        }

        var oList = document.getElementById(_thisID);
        if (!oList)
            return;

        RemoveDataBody();

        var newTBody = GetTableBodyObj();


       // if (!new RegExp(/MSIE/).test(navigator.userAgent) && !_SetHeightFree)
       //    newTBody.style.height = oList.parentNode.style.height;

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
        var Chkbox = false;
        for (var i = 0; i < oHeaders.length; i++) {
            var strWidth = SelectSingleNodeValue(oHeaders[i], "WIDTH");
            
            if (strWidth != "0") { //2011.07.05 Header의 width가 0이면 td를 만들지 않는다.
                var strName = SelectSingleNodeValue(oHeaders[i], "NAME");

                var strStyle = SelectSingleNodeValue(oHeaders[i], "STYLE");
                var strClass = "";  // 현재는 header에 class가 없으므로 고정함. //SelectSingleNodeValue(oHeaders[i], "CLASSNAME");	

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
                                objTd.setAttribute("width", "80%");// objTd.setAttribute("width", strWidth + "px");
                            }
                            else {
                                objTd.width = "80%";// objTd.width = strWidth + "px";
                            }
                        }
                        else
                            objTd.width = strWidth + "px";
                    }
                    _TableWidth = _TableWidth + parseInt(strWidth);
                }

                if (strColName == "ITEMID") {
                    var _HeaderCheckBox = document.createElement("INPUT");
                    _HeaderCheckBox.type = "checkbox";
                    _HeaderCheckBox.id = "HeaderAllCheckBox";
                    _HeaderCheckBox.style.margin = "0px";
                    _HeaderCheckBox.style.padding = "0px";
                    _HeaderCheckBox.style.width = "16px";
                    _HeaderCheckBox.style.height = "16px";
                    _HeaderCheckBox.onclick = function () { event_HeaderCheckBoxClick(this); };
                    objTd.appendChild(_HeaderCheckBox);
                    strName = "";
                }

                if (strColName.indexOf("WRITERNAME") > -1) {
                    objTd.setAttribute("writerindex", i);
                }

                if (strColName == "ATTACHMENTS" || strColName == "READCOUNT" || strColName == "TITLE") {
                    objTd.style.textAlign = "CENTER";
                }

                if (strColName == "TITLE")
                    objTd.style.width = "80%";

                var oText = document.createTextNode(strName);
                objTd.appendChild(oText);

                if (OrderCell != "" && OrderCell == strName) {
                    var _HeaderSpanimg = document.createElement("IMG");
                    if (OrderOption == "DESC")
                        _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
                    else
                        _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");

                    _HeaderSpanimg.setAttribute("align", "absmiddle");
                    objTd.appendChild(_HeaderSpanimg);
                }

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

    //리스트뷰 바디 생성
    function GetTableBodyObj() {
        var oTbody = document.createElement("TBODY");
        oTbody.style.backgroundColor = m_strColorDefault;

        var oRows = _dataSource.getElementsByTagName("ROW");
        _rowCount = oRows.length;
        
        var oHeaders = _dataSource.getElementsByTagName("HEADER");
        var colCount = oHeaders.length;
       
        if (oRows.length == 0) {
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + "noItems");
            oTbody.appendChild(objTr);

            var oText = document.createTextNode(strLang43);
            var objTd = document.createElement("TD");
            objTd.align = "center";
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
                objTr.ondblclick = new Function(_rowondblclick);

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

            var chkbox = false;
            for (var j = 0; j < oCells.length; j++)
            {
                var strValue = SelectSingleNodeValue(oCells[j], "VALUE");
                var strStyle = SelectSingleNodeValue(oCells[j], "STYLE");
                var strClass = SelectSingleNodeValue(oCells[j], "CLASSNAME");
                              
                var oText = document.createTextNode(strValue);
                var objTd = document.createElement("TD");

                objTd.setAttribute("style", "text-align:left; padding-top:2px; padding-bottom:2px; ");

                //objTd.style.textAlign = "left";
                
                if (SelectSingleNodeValue(oHeaders[j], "COLNAME") == "ITEMID") {
                    var _TDCheckBox_Sub = document.createElement("INPUT");
                    _TDCheckBox_Sub.type = "checkbox";
                    _TDCheckBox_Sub.id = strValue + "," + getNodeText(oDatas[2]) + ";";
                    _TDCheckBox_Sub.style.margin = "0px";
                    _TDCheckBox_Sub.style.padding = "0px";
                    _TDCheckBox_Sub.style.width = "13px";
                    _TDCheckBox_Sub.style.height = "13px";
                    _TDCheckBox_Sub.onclick = new Function("chk_onselect(this)");
                    objTd.appendChild(_TDCheckBox_Sub);

                    objTr.appendChild(objTd);
                }
                else if (SelectSingleNodeValue(oHeaders[j], "COLNAME") == "TITLE") {
                    var Table = document.createElement("TABLE");
                    var Tbody = document.createElement("TBODY");

                    var tr = document.createElement("TR");

                    var NewCell = document.createElement("TD");
                    NewCell.setAttribute("style", "text-align:left; border-bottom:0px;");
                   
                    var NewElement = document.createElement("IMG");
                    NewElement.src = "/images/i_new.gif";
                    NewCell.appendChild(NewElement);
                    
                    var ImgElement = document.createElement("IMG");
                    //ImgElement.src = "/Upload_BoardSTD/" + getNodeText(oDatas[4]);
                    // {1e342793-61f7-9538-1906-1e213e7408f1}/UploadFile/s_{8fe616a9-dcf7-47d7-8624-73bd96043a70}.jpg
                    var Filename = getNodeText(oDatas[4]).split('/')[2];
                    ImgElement.src = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + encodeURI(getNodeText(oDatas[0])) + "&fileName=" + encodeURI(Filename);
                    ImgElement.style.height = "40px"
                    ImgElement.style.width = "60px"

                    var imgCell = document.createElement("TD");
                    imgCell.style.width = "70px";
                    imgCell.style.verticalAlign = "middle";
                    imgCell.style.borderBottom = "0px";
                    imgCell.appendChild(ImgElement);
                    
                    var ContentTable = document.createElement("TABLE");
                    ContentTable.setAttribute("style", "table-layout:fixed; width:100%");
                    var ContentTbody = document.createElement("TBODY");

                    var Contenttr1 = document.createElement("TR");
                    var Contenttr2 = document.createElement("TR");

                    var ContentNewCell1 = document.createElement("TD");
                    ContentNewCell1.setAttribute("style", "text-overflow:ellipsis; overflow:hidden; white-space:nowrap; border-bottom:0px;");

                    var TextCell1 = document.createElement("SPAN");
                    TextCell1.id = "spn_title" + i;
                    if(getNodeText(oDatas[7]) == "0")
                        TextCell1.setAttribute("style", "font-weight:bold; font-size:12px; padding-left:5px;");
                    else
                        TextCell1.setAttribute("style", "font-size:12px; padding-left:5px;");

                    var Text1 = document.createTextNode(strValue);
                    //TextCell1.appendChild(Text1);
                    TextCell1.innerHTML += strValue;

                    var TitleImage = document.createElement("IMG");
                    TitleImage.setAttribute("style", "padding-bottom:3px;");
                    TitleImage.src = "/images/dot_photoTitle.gif";

                    ContentNewCell1.appendChild(TitleImage);
                    ContentNewCell1.appendChild(TextCell1);

                    if (getNodeText(oDatas[6]) != "0") {
                        var TextCell_OneLineCnt = document.createElement("SPAN");
                        TextCell_OneLineCnt.setAttribute("style", "color:#c64200");
                        TextCell_OneLineCnt.innerHTML = "&nbsp;[" + getNodeText(oDatas[6]) + "]";
                        ContentNewCell1.appendChild(TextCell_OneLineCnt);
                    }

                    var ContentNewCell2 = document.createElement("TD");
                    ContentNewCell2.setAttribute("style", "text-overflow:ellipsis; overflow:hidden; white-space:nowrap; border-bottom:0px;");

                    var TextCell2 = document.createElement("SPAN");
                    TextCell2.id = "spn_content" + i;
                    if (getNodeText(oDatas[7]) == "0")
                        TextCell2.setAttribute("style", "font-weight:bold;");

                    TextCell2.innerHTML = ReplaceText(getNodeText(oDatas[5]), "<br>", "&nbsp;");
                    ContentNewCell2.appendChild(TextCell2);

                    Contenttr1.appendChild(ContentNewCell1);
                    Contenttr2.appendChild(ContentNewCell2);
                    ContentTbody.appendChild(Contenttr1);
                    ContentTbody.appendChild(Contenttr2);
                    ContentTable.appendChild(ContentTbody);

                    var ContentCell = document.createElement("TD");
                    ContentCell.setAttribute("style", "border-bottom-width: 0px; width:100%;");
                    ContentCell.appendChild(ContentTable);

                    tr.appendChild(NewCell);
                    tr.appendChild(imgCell);
                    tr.appendChild(ContentCell);
                    Tbody.appendChild(tr);
                    Table.appendChild(Tbody);
                    objTd.appendChild(Table);
                    objTd.style.textAlign = "left";
                    objTr.appendChild(objTd);

                    strValue = "";
                }
                else {

                    if (SelectSingleNodeValue(oHeaders[j], "COLNAME") == "READCOUNT") {
                        objTd.style.textAlign = "center";
                    }

                    objTd.innerHTML = strValue;
                    objTr.appendChild(objTd);
                }                                             

                if (strStyle != "") {
                    if (new RegExp(/MSIE/).test(navigator.userAgent)) {
                        objTd.style.setAttribute("cssText", strStyle);
                    }
                    else {
                        strStyle = strStyle.replace(/center/, "-moz-center");
                        objTd.setAttribute("style", strStyle);
                    }
                }
            }
            objTd = null;
            oText = null;
            objTr = null;
            oCells = null;
            oDatas = null;
        }
        oRows = null;

        return oTbody;
    }

    //리스트뷰에 Row 추가
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
                /*
                if (_titleIdx == j || (_titleIdx == null && j == oCells.length - 1)) {
                    //objTd.className = "kt_li_left";
                    objTd.title = strValue;
                }
                
                else
                    objTd.className = "kt_li_center";

                objTd.style.overflow = "hidden";
                objTd.style.textOverflow = "ellipsis";
                objTd.style.whiteSpace = "nowrap";
                */
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

    //리스트뷰 DataSource에서 DATA1, DATA2, DATA3 ... 등의 데이터 가져오기
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

    //리스트뷰 바디 전부 삭제
    function RemoveDataBody() {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;
            
         if (oList.childNodes.length <=1)
            return;
        
        //firefox에서 리스트구분선이 보이지 않는 오류로 중첩된 tbody제거 2011.07.25
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

    //Row 개수 가져오기
    //Row Count는 헤더를 포함하지 않는다.
    function GetRowCount() {
        var arrRow = GetDataRows();
        if (arrRow != null)
            _rowCount = arrRow.length;
        else
            _rowCount = 0;

        arrRow = null;

        return _rowCount;
    }

    //리스트뷰 바디의 모든 ROW 가져오기
    //헤더는 제외한다.
    function GetDataRows() {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;

        var elements = null;

        if (oList.rows.length > 0) {
            elements = new Array();
            var idx = 0;
            for (var i = 0; i < oList.rows.length; i++) {
                //헤더를 제거하기 위해 ID를 검사한다.
                if (oList.rows[i].id.indexOf("TR") >= 0)
                    elements[idx++] = oList.rows[i];
            }
        }
        oList = null;

        return elements;
    }

    //Attribute를 이용하여 이미 존재하는 Row인지 체크하기
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

    //리스트뷰에 Row 추가
    function AddRow(pIdx) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return null;

        if (pIdx == null || pIdx == "undefined")
            pIdx = 0;

        var objTr = null;
        if (new RegExp(/MSIE/).test(navigator.userAgent)) {
            //테이블 객체의 인덱스는 헤더를 포함하기 때문에 1을 더해서 인서트 한다.
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

    //리스트 뷰 Row 삭제
    function DeleteRow(pIds) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return null;

        var arrIds = pIds.split(",");
        for (var i = 0; i < arrIds.length; i++) {
            var arrRow = GetDataRows();

            for (var j = 0; j < arrRow.length; j++) {
                if (arrRow[j].id == arrIds[i]) {
                    //리스트뷰와 테이블 개체의 인덱스가 다르기 때문에 1을 더해준다.
                    //리스트뷰 인덱스는 헤더를 제외하지만 테이블 개체의 인텍스는 헤더를 포함한다.
                    var tmpIdx = j + 1;
                    oList.deleteRow(tmpIdx);
                    break;
                }
            }
            
            //if(_rowCount < 1)
            //{
                //var objTr = oList.insertRow(1);
                //objTr.setAttribute("id", _thisID + "_TR_" + "noItems");
                //var oText = document.createTextNode(strLang535);
                //var objTd = document.createElement("TD");
                //objTd.align = "center";
                //objTd.colSpan = colCount;
                //objTd.appendChild(oText);
                //objTr.appendChild(objTd);
            //}
        }
    }    
    
    //선택한 Row에 대한 ID값을 반환
    function GetSelectedRowID(pIdx) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return;
        return oList.childNodes[1].childNodes[pIdx].id;
    }

    //리스트뷰 셀 만들기
    function CreateTabelCell(pText) {
        var oText = document.createTextNode(pText);
        var objTd = document.createElement("TD");
        objTd.appendChild(oText);

        oText = null;
        return objTd;
    }

    //선택된 ROW 가져오기
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

    //선택된 ROW의 Index 가져오기 (헤더 제외)
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

    //지정한 Index에 해당하는 Row 선택
    function SetSelectedIndex(pIdx) {
        tr_unselectedAll(_thisID);

        var strRowID = _thisID + "_TR_" + pIdx;
        var objTr = document.getElementById(strRowID);

        if (objTr) {
            objTr.setAttribute("selected", "true");
            objTr.style.backgroundColor=m_strColorSelect;
            //objTr.className = "kt_li_tr";

            //마지막 선택 ID 지정
            var oList = document.getElementById(_thisID);
            oList.setAttribute("lastSelectedRowID", strRowID);
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
        //return "영준이가 자바스크립트로 만든 리스트 뷰 v0.5";
    }    
} // ListView 클래스 끝

// 리스트 클래스 끝
//###########################################################################################

//ROW 선택 함수
function tr_select(pRowID, pTableID, callbackFunc) {
    if (!listEventCheckbox) {
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

        //멀티선택이 가능한 리스트이고 쉬프트키가 눌려져 있으면
        //구간을 모두 선택한다.
        if (bMultiSelectable && PressShiftKey) {
            tr_selectBlock(pRowID, pTableID);
            return;
        }

        //멀티선택이 불가능한 리스트이거나 컨트롤키가 눌려있지 않으면 
        //모든 선택된 Row를 Unselect 한다.
        if (bMultiSelectable == false || PressCtrlKey == false)
            tr_unselectedAll(pTableID);

        //현재 클릭한 Row를 Select 한다.
        //strAttribute = GetAttribute(oSourceTr, "selected");

        if (oSourceTr.childNodes[0].childNodes[0].checked) {
            oSourceTr.setAttribute("selected", "false");
            oSourceTr.childNodes[0].childNodes[0].checked = false;
            oSourceTr.style.backgroundColor = m_strColorDefault;
            strListInfo = ReplaceText(strListInfo, oSourceTr.childNodes[0].childNodes[0].id, "");
        }
        else {
            oSourceTr.setAttribute("selected", "true");
            oSourceTr.childNodes[0].childNodes[0].checked = true;
            oSourceTr.style.backgroundColor = m_strColorSelect;
            strListInfo += oSourceTr.childNodes[0].childNodes[0].id;
        }

        //각 리스트마다 마지막으로 선택한 ID를 보관한다.
        oList.setAttribute("lastSelectedRowID", pRowID);

        oList = null;
        oSourceTr = null;

        //리스트에 onclick 이벤트를 지정한 경우 해당 함수를 호출한다.
        if (PressCtrlKey == false && PressShiftKey == false) {
            if (callbackFunc && typeof (callbackFunc) == "function")
                callbackFunc(pRowID);
        }

        //리스트에 onclick 이벤트를 지정한 경우 해당 함수를 호출한다.
        if (PressCtrlKey == true || PressShiftKey == true) {
            if (callbackFunc && typeof (callbackFunc) == "function")
                callbackFunc(pRowID);
        }
    }
    else
        listEventCheckbox = false;
}

function event_HeaderCheckBoxClick(obj) {

    var SelList = new ListView();
    SelList.LoadFromID("BoardList");

    if (obj.checked) {
        for (var i = 0; i < SelList.GetRowCount() ; i++) {
            SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = true;
            SelList.GetDataRows()[i].style.backgroundColor = m_strColorSelect;
            strListInfo += SelList.GetDataRows()[i].childNodes[0].childNodes[0].id;
        }
    }
    else {
        for (var i = 0; i < SelList.GetRowCount() ; i++) {
            SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = false;
            SelList.GetDataRows()[i].style.backgroundColor = m_strColorDefault;
            strListInfo = "";
        }
    }
}

//모든 ROW를 선택 해제하는 함수
function tr_unselectedAll(pTableID) {
    var oList = document.getElementById(pTableID);
    if (!oList)
        return;

    if (document.getElementById("HeaderAllCheckBox").checked) {
    }
    else {

        var SelList = new ListView();
        SelList.LoadFromID("BoardList");

        for (var i = 0; i < SelList.GetRowCount() ; i++) {
            SelList.GetDataRows()[i].childNodes[0].childNodes[0].checked = false;
            SelList.GetDataRows()[i].style.backgroundColor = m_strColorDefault;
            strListInfo = "";
        }
    }
}

//컨트롤 혹은 쉬프트 키를 이용한 멀티 선택 함수
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

//마우스 오버
function tr_mouseover(pRow) {
    //var strAttribute = GetAttribute(pRow, "selected");
    if (pRow.childNodes[0].childNodes[0].checked != true) {
        pRow.style.backgroundColor = m_strColorOver;

    }

    pRow = null;
}

//마우스 아웃
function tr_mouseout(pRow) {
    var strAttribute = GetAttribute(pRow, "selected");
    if (pRow.childNodes[0].childNodes[0].checked != true)
        pRow.style.backgroundColor = m_strColorDefault;
    else
        pRow.style.backgroundColor = m_strColorSelect;

    pRow = null;
}

//마우스 오버
function td_mouseover(td) {

    //td.style.backgroundColor = m_strColorOver;
    //td = null;
}

//마우스 아웃
function td_mouseout(td, titIdx) {
//    //2010.05.04 제목 긴급결재시 마우스아웃시에도 붉은색 처리
//    if (td.parentNode.DATA14 == "Y" && titIdx == td.cellIndex) {
//        td.style.color = m_UrgentColor;
//    }
//    else {
//        td.style.color = m_strColorDefault;
//    }

//    td = null;
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
    // 비 IE 브라우저에서 사용 가능하도록 innerText 구현
    // IE에서는 HTMLElement 타입이 존재하지 않아 오류가 발생함.
    HTMLElement.prototype.__defineGetter__
	(
		"innerText", function()
		//define a getter method to get the value of innerText, 
		//so you can read it now! 
		{
		    var textRange = this.ownerDocument.createRange();
		    //Using range to retrieve the content of the object
		    textRange.selectNodeContents(this);
		    //only get the content of the object node
		    return textRange.toString().trim();
		    // give innerText the value of the node content
		}
	);
}
catch (e)
{ }
String.prototype.trim = function() {
    var str = this.replace(/(\s+$)/g, "");
    return str.replace(/(^\s*)/g, "");
}
//new RegExp(/MSIE/).test(navigator.userAgent)
//new RegExp(/Netscape/).test(navigator.userAgent)
//new RegExp(/Firefox/).test(navigator.userAgent)
//new RegExp(/Opera/).test(navigator.userAgent)
function getOriginXML(pTagetID)
{    
    var objElm = document.getElementById(pTagetID);
        
    //objElm.getElementsByTagName("TH")[0]
    //objElm.getElementsByTagName("TH").length
    //var objTable = SelectNodes(objElm, "TABLE");
    //var objTable = GetChildNodes(objElm.documentElement);    
    var objHeader = objElm.getElementsByTagName("TH");
    var objBody = objElm.getElementsByTagName("TBODY");
    var objBodyData = objElm.getElementsByTagName("TR"); //0번은 헤더, 1번부터 body
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
        //colname 어떻게 할까?
        xmlHeader += "<COLNAME></COLNAME>";
        xmlHeader += "</HEADER>";
    }
    for(var i=1; i<objBodyData.length; i++)
    {
        //alert(objBody[i].innerHTML);
       
        alert(objBodyData[i].cells.length);
        xmlBody += "<ROW><CELL>";
        xmlBody += "<VALUE>" + objBodyData[i].innerText + "</VALUE>";
        for(var x=0; x<1; x++)
        {
            //debugger;
        }
        
        xmlBody += "</CELL></ROW>";
    } 
    //alert(xmlHeader + "\r\n" + xmlBody);
}
