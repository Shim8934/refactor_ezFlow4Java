//컨트롤키나 쉬프트 키가 눌려졌음을 체크하는 FLAG
var PressCtrlKey = false;
var PressShiftKey = false;
//모질라 계열의 브라우저에서는 event.ctrlKey 등이 작동하지 않는다.
//따라서 List의 SetMulSelectable 속성의 값이 true인 경우에만
//document 객체에 keydown, keyup 이벤트를 등록하여 FLAG의 값을 지정한다.
var m_strColorSelect = "#f1f8ff";
var m_strColorDefault = "#FFFFFF";
var m_strColorOver = "#f4f5f5";
var m_UrgentColor = "#E9101A";
var m_SecurityColor = "#999999";
var m_DelColor = "#E9101A";

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

function ListConstr(data) {
	
    var _thisID = "";
    var _bindID = "";
    var _headers;
    var _rows;
    var _isMultiSelectable = false;
    var _rowCount = 0;
    var _debugMode = false;
    var _useOcs = false;
    var _IE = true;
    var _title = null;

    var _headeronclick = null;
    var _headerondblclick = "";
    var _rowonclick = null;
    var _rowondblclick = "";
    var _rowDrag = null;  //2020-04-27 : 드래그앤드랍 추가
    var _rowDrop = null;  //2020-04-27 : 드래그앤드랍 추가    
    var _contextHandler = null;
    var _titleIdx = null;
    var _SecIdx = null;
    var _TableWidth = 0;
    var _WidthFlag = true;
    var _SelectFlag = true;  //2020-04-27 : 체크박스 추가
    var _firstRowID = "";
    var _AlignLeft = null;
    var _UrgentFlag = false;
    var _CheckBoxFlag = false;
    var _SecurityFlag = false;
    var _securityIdx = 9;
    var _Align = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1);
    var _ListType = 0;
    var _SetHeightFree = false;
    var _HeaderNode = "NAME";
    var _ApprovalFlag = "S";
    var _DelFalg = false;

    // 2020-02-18 천성준 - 결재문서리스트 의견표시여부
    var _ShowOpinionImg = true;
    
    //보안문서 체크 디폴트 data10 만약 data14 라면 _securityProp 값을 data14로 변경해 줘야 함.
    var _securityProp = 'data10';
    
    this.init = init;
    this.makeHeaders = makeHeaders;
    this.makeRows = makeRows;
    this.makeTable = makeTable;
    this.LoadFromID = LoadFromID;
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
    this.SetUrgentFlag = SetUrgentFlag;     //긴급결재  DATA14
    this.SetSecurityFlag = SetSecurityFlag; //보안결재  [DATA14, DATA10] 날짜비교 
    this.SetSecurityIdx = SetSecurityIdx; //보안결재관련, 보안결재 날짜가 DATA14에 있는 경우도 있고 DATA10에 있는 경우도 있어서 기본값은 DATA10을 조회하게 하되 필요에따라 조회할 DATA 인덱스를 정할수있음
    this.SetAlignArr = SetAlignArr;
    this.GetTableWidth = GetTableWidth;
    this.SetTableWidth = SetTableWidth;
    this.SetListType = SetListType;
    this.SetOrderbyCol = SetOrderbyCol; // Header order by 노드명 셋팅
    this.SetUnSelected = SetUnSelected;
    this.setDeleteRow = setDeleteRow;
    this.SetCheckBoxFlag = SetCheckBoxFlag; //2020-04-27 : 체크박스 추가 (true : 사용, false : 미사용)
    
    //사용자 정의 이벤트 지정
    this.SetHeaderOnClick = SetHeaderOnClick;
    this.SetHeaderOnDblClick = SetHeaderOnDblClick;
    this.SetRowOnClick = SetRowOnClick;
    this.SetRowOnDblClick = SetRowOnDblClick;
    this.SetContextHandler = SetContextHandler;
    //2020-04-27 : 드래그앤드랍 추가
    this.SetDrag = SetDrag;
    this.SetDrop = SetDrop;    

    this.SetDebugMode = SetDebugMode;
    this.toString = ListView_ToString;
    this.SetHeightFree = SetHeightFree;
    
    
    
    
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

    //왼쪽정렬이 필요한 필드
    function SetAlignLeft(pAlign) {
        _AlignLeft = pAlign;
    }
    // 긴급결재 표시처리
    function SetUrgentFlag(flag) {
        _UrgentFlag = flag;
    }

    //2020-04-27 : 체크박스 추가
    function SetCheckBoxFlag(flag) {
        _CheckBoxFlag = flag;
    }    

    //2020-04-27 : 드래그앤드랍 추가
    function SetDrag(SetDrag) {
        _rowDrag = SetDrag;
    }

    //2020-04-27 : 드래그앤드랍 추가
    function SetDrop(SetDrop) {
        _rowDrop = SetDrop;
    }    
   
    function SetSecurityFlag(flag) {
        _SecurityFlag = flag;
    }
    function SetSecurityIdx(idx) {
        _securityIdx = idx;
    }

    // 리스트헤더 정렬 배열
    function SetAlignArr(arry) {
        _Align = arry;
    }
    
    // 리스트 타입 추가  // 9 : 수신문서의 경우 읽지않은 문서 볼드처리를 위해 추가함.
    function SetListType(pListType) {
        _ListType = pListType;
    }
    
    function SetOrderbyCol(pOrderName)
    {
        _HeaderNode = pOrderName;
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
    
    
    //생성자
    init(data);

    function init(initData) {
    	if(initData != null) {
            _thisID = (initData.tableId == undefined)?"":initData.tableId;
            _headers = (initData.headers == undefined)?null:initData.headers;
            _rows = (initData.rows == undefined)?null:initData.rows;
            _bindID = (initData.bindId == undefined)?"":initData.bindId;
            _securityProp = (initData.securityProp == undefined)?"data10":initData.securityProp;
            _DelFlag = (initData.delFlag == undefined)?false:initData.delFlag;
            _rowonclick = (initData.rowOnClick == undefined)?null:initData.rowOnClick;
            _rowondblclick = (initData.rowOnDblClick == undefined)?"":initData.rowOnDblClick;
            
            //전자결재는 보통 approvalFlag를 전역으로 가지고 있음
            _ApprovalFlag = (approvalFlag== undefined)?"S":approvalFlag;
            
    	    if (document.getElementById("lvtDoclist").innerHTML != "") {
    	        document.getElementById("lvtDoclist").innerHTML = "";
    	    }
            
            var headerTag = makeHeaders(_headers);
            var rowTag = makeRows(_headers, _rows);
            makeTable(_bindID, headerTag, rowTag)
    	}

    }

    function makeHeaders(headerData) {

        var objTr = document.createElement("TR");
        objTr.id = _thisID + "_TH";
        
        //2020-02-18 천성준 - 결재문서리스트 의견표시여부
        if (_thisID == "DocList" && typeof(_ApprovalFlag) != "undefined" && _ApprovalFlag == "S") {
        	if (_ShowOpinionImg) {
        		var objTd = document.createElement("TH");
            	objTd.id = _thisID + "_TH_OP";
            	objTd.className = "h5_center";
            	objTd.style.textAlign = "center";
            	objTd.width = "15px";
            	
            	var oI = document.createElement("i");
            	oI.className = "fa fa-comments-o";
            	oI.style.fontSize = "17px";
            	oI.title = strLang171;
            	
            	objTd.appendChild(oI);
            	objTr.appendChild(objTd);
        	}
        }
        
        for (var i = 0; i < headerData.length; i++) {
    		var strWidth = headerData[i].width;
            
            if(strWidth != "0"){ //2011.07.05 Header의 width가 0이면 td를 만들지 않는다.
                var strName = (headerData[i].name == undefined)? "": headerData[i].name;
                var strStyle = (headerData[i].style == undefined)? "": headerData[i].style;
                var strClass = "h5_center";  // 현재는 header에 class가 없으므로 고정함. //GetSingleNodeValue(oHeaders[i], "CLASSNAME");	
                
                var strColName = headerData[i].colName;
                if(strColName == "DocTitle" || strColName === _title) {
                    _titleIdx = i;
                }
                       
                var objTd = document.createElement("TH");

                objTd.id = _thisID + "_TH_" + i;

                if (_headeronclick != null && _headeronclick != "" ) {
                    objTd.style.cursor = "pointer";
                    if(_HeaderNode == "COLNAME")     
                        objTd.onclick = new Function(_headeronclick + "('" + strColName + "');");
                    else
                        objTd.onclick = new Function(_headeronclick + "('" + strName + "');");
                }

                /* 2020-07-31 홍승비 - 리스트헤더 th에 colname 속성 부여 */
                objTd.setAttribute("COLNAME", strColName.toUpperCase());

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
                
                // 첨부파일버튼 클릭시 쪽수 안보이게 2018-03-21 강민수92
                if (strColName == "PageNum") {
                	objTd.style.display = "none";
                }
                
                /* 2020-07-09 홍승비 - 리스트헤더의 반려 칼럼 정렬 중앙으로 수정 (하위 td의 정렬이 center이므로) */
                if (strColName == "REJECTFLAG")
                    objTd.style.textAlign = "center";

                if (strColName == "HASATTACHYN")
                    objTd.style.textAlign = "center";
                
                if (strColName == "ISPUBLIC") {
                	objTd.style.textAlign = "center";
                }
                
                // 헤더에  컬럼 가운데정렬 2018-06-28 강민수92
                if (strColName == "ReSendFlag") {
                	objTd.style.textAlign = "center";
                }
                
                if (strColName == "AttachFlag") {
                	objTd.style.textAlign = "center";
                }
                
                if (strColName == "RejectFlag") {
                	objTd.style.textAlign = "center";
                }
                
                /* 2020-07-09 홍승비 - 리스트헤더의 이관여부 칼럼 정렬 좌측으로 수정 (하위 td의 정렬 스타일도 left로 수정) */
                if (strColName == "TransferFlag") {
//                	objTd.style.textAlign = "center";
                	objTd.style.textAlign = "left";
                }
               
                if (strColName == "DelayFlag") {
//                	objTd.style.textAlign = "center";
                }
                
                /* 2020-07-09 홍승비 - 리스트헤더의 비치 칼럼 중앙정렬 스타일 제거 (하위 td의 정렬 스타일이 left임) */
//                if (strName == "비치" || strName == "특수목록" || strName == "연기신청" || strName == "수신") {
            	if (strName == "특수목록" || strName == "수신") {
                	objTd.style.textAlign = "center";
                }

                if (strClass != "") {
                    if (i == 0) {       //// 현재는 header에 class가 없으므로 고정함.
                        objTd.className = "h4_center";
                        objTd.setAttribute("bgcolor", "#CCCCCC");
                    }
                    else
                        objTd.className = strClass;
                }        

                // 리스트 제목부분 width 제거
            	if (OrderCell == strName) {
              		objTd.width = strWidth + "px";
		        } else {
		        	if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
		        		objTd.setAttribute("width", strWidth + "px");
		            } else {
		                  objTd.width = strWidth + "px";
		            }
		        }  

                try{
            	   if (_HeaderNode == "COLNAME") {
            		   if(strColName != "") {
                           if (OrderCell == strColName) {
                               if (OrderOption.lastIndexOf("DESC") > -1)
                                   strName += "<img src='/images/view-sortdown.gif'>";
                               else
                                   strName += "<img src='/images/view-sortup.gif'>";
                           }
            		   }
                    } else {
                    	if (strName != "") {
                           if (OrderCell == strName) {
                               if (OrderOption.lastIndexOf("DESC") > -1)
                                   strName += "<img src='/images/view-sortdown.gif'>";
                               else
                                   strName += "<img src='/images/view-sortup.gif'>";
                           }
                    	}
                     }
                }catch(e){}

                var oText = document.createTextNode(strName);                
                objTd.innerHTML = strName;
                objTr.appendChild(objTd);

                objTd = null;
                oText = null;
                oNames = null;
                oWidths = null;
            }
        }

        if (_CheckBoxFlag) {
            var objTd = document.createElement("TH");
            objTd.width = "21px";
            var checkEle = document.createElement("INPUT");
            checkEle.setAttribute("type", "checkbox");
            checkEle.onclick = new Function("SetAllSelect('" + _thisID + "', this)");
            objTd.appendChild(checkEle);
            objTr.insertBefore(objTd, objTr.childNodes.item(0));
        }        

        var objTheader = document.createElement("THEAD");
        objTheader.id = _thisID + "_THEAD";

        objTheader.appendChild(objTr);

        objTr = null;

        return objTheader;
    }

    function makeRows(headerData, rowData) {
        var oTbody = document.createElement("TBODY");
        oTbody.style.backgroundColor = m_strColorDefault;
       
        _rowCount = rowData.length;
        
        var colCount = headerData.length;
        var strToday = GetTodayDate();
        
        if (_rowCount == 0) {
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + "noItems");
            oTbody.appendChild(objTr);
            var oText = document.createTextNode(strLang944);
            var objTd = document.createElement("TD");
            objTd.align = "center";
            
            try {
                if (colCount == 0)
                    colCount = document.getElementById(_thisID).getElementsByTagName("th").length;
                else{
                    if (_CheckBoxFlag)  //2020-04-27 : 체크박스 추가
                    colCount += 1;                
                }
            } catch (e) {}
            
            if(_thisID == "attachList") {
                colCount = 3;
            }
            
            // 변경내역 > 첨부파일이력 > 데이터 없을시 쪽수 컬럼 빈칸 안뜨게 2018-04-26 강민수92
            if(_thisID == "lvAttachList") {
                colCount = 5;
            }
            
            // 2020-02-18 천성준 - 결재문서리스트 의견표시여부
            if (_thisID == "DocList" && typeof(_ApprovalFlag) != "undefined" && _ApprovalFlag == "S") {
                if (_ShowOpinionImg) {
                    colCount++;
                }
            }
            
            objTd.setAttribute("colSpan", colCount);
            objTd.appendChild(oText);
            objTr.appendChild(objTd);
       
            return oTbody;
        }
       
        for (var i = 0; i < rowData.length; i++) {
            var objTr = document.createElement("TR");
            objTr.setAttribute("id", _thisID + "_TR_" + i);
            objTr.setAttribute("name", _thisID + "_TR");  //2020-04-27 : 체크박스 추가
            objTr.style.cursor = "pointer";
       
            //2020-04-27 : 드래그앤드랍 추가
            if (_rowDrag != null) {
                objTr.draggable = true;
                objTr.ondragstart = new Function(_rowDrag + "(event)");
            }            
       
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
       
            var checked = "";
            if (_SelectFlag && i == 0) {   //첫번째 row 선택지정 or 특정 row 선택
                objTr.setAttribute("selected", "true");
                objTr.style.backgroundColor = m_strColorSelect;
       
                _firstRowID = _thisID + "_TR_" + i;      
                checked = " checked='checked' ";
            }
            else {
                objTr.setAttribute("selected", "false");
                objTr.className = "";
                objTr.style.backgroundColor = m_strColorDefault;
            }
       
            var hasOpinionFlag = false;
            
            //DATA1, DATA2, DATA3... 등의 값 세팅
            var oData = rowData[i].cell[0];
            var oDatas = Object.keys(oData); 
            for (var j = 0; j < oDatas.length; j++) {
                var strData = oDatas[j];
                var strValue = "";
                if (oData[oDatas[j]] != null) {
                    strValue = oData[oDatas[j]];
                }
       
                objTr.setAttribute(strData, strValue);
                
                if (_thisID == "DocList" && typeof(_ApprovalFlag) != "undefined" && _ApprovalFlag == "S") {
                    if (_ShowOpinionImg) {
                        if (strData.toUpperCase() == "HASOPINIONYN" && strValue == "Y") {
                            hasOpinionFlag = true;
                        }
                    }
                }
            }
     
            oTbody.appendChild(objTr);
       
            //2020-04-27 : 체크박스 추가
       if(_CheckBoxFlag) {
       
                var objTd = document.createElement("TD");
                objTd.style.width = "21px";
                objTd.innerHTML = "<INPUT TYPE='CHECKBOX' id='" + _thisID + "_TD_CheckBox_" + i + "' onclick='SelectCheckBox(\"" + _thisID + "\", " + i + ", event);' " + checked + ">";
                objTd.onmouseover = new Function("td_mouseover(this)");
                objTd.onmouseout = new Function("td_mouseout(this)");
                objTr.appendChild(objTd);
            }             
       
            if (_thisID == "DocList" && typeof(_ApprovalFlag) != "undefined" && _ApprovalFlag == "S") {
                if (_ShowOpinionImg) {
                    var objTd = document.createElement("TD");
                    objTd.style.textAlign = "center";
                    objTd.width = "15px";
                    
                    if (hasOpinionFlag) {
                        var oI = document.createElement("i");
                        oI.className = "fa fa-comments-o";
                        oI.style.fontSize = "17px";
                        
                        objTd.appendChild(oI);
                    }
                    objTr.appendChild(objTd);
                }
            }           
            
            var oCells = rowData[i].cell;

            for (var j = 0; j < oCells.length; j++) {
                var strValue = (oCells[j].value == undefined)? "": oCells[j].value;
                var strStyle = (oCells[j].style == undefined)? "": oCells[j].style;
                var strClass = (oCells[j].classname == undefined)? "": oCells[j].classname;
       
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
                else {
                    objTd.setAttribute("style", "");
                }
                if (strClass != "") {
                    objTd.className = strClass;
                }
                else {
                        
                    if (_titleIdx == null) { //하단정보탭일경우
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
       
                            if(_DelFlag && oData['delflag'] == "Y") {
                                objTd.style.color = m_DelColor;
                            }  
                            
                        if (_titleIdx == j) {
                            //20120823 기록물배부대장은 oDatas length가 7까지 들어오므로 추가
                            if(oDatas.length > 13)
                            {
                                if(_UrgentFlag && oData['data14'] == "Y") {   //DATA14값
                                    objTd.style.color = m_UrgentColor;
                                }                            
                             }
                            if (!new RegExp(/MSIE/).test(navigator.userAgent)) {
                                objTd.setAttribute("width", "80%");
                            }
                            else {
                                objTd.width = "80%";
                            }
                        }
                        if(oData[_securityProp]){

                                if (_SecurityFlag && oData[_securityProp] != "" && !isNaN(Date.parse(oData[_securityProp])) && oData[_securityProp] >= strToday) {  
                                    objTd.style.color = m_SecurityColor;
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
                
                if (headerData.length > 0) {
                	var colNameUpperCase = headerData[j].colName.toUpperCase();
                	
                    objTd.setAttribute("headerName", colNameUpperCase); // 제목 TD임을 구분하기 위한 속성 추가
                    
                    if (headerData[j].colName == "AttachFlag") {
                        objTd.style.textAlign = "center";
                        if ( oCells[j].HASATTACHYN == "Y" || oCells[j].HASATTACHYN == "1") {
                            var _img = document.createElement("img");
                            _img.src = "/images/newAttach.gif";
                            objTd.appendChild(_img);
                        }
                    }
                    else if (headerData[j].colName == "HASATTACHYN") {
                        objTd.style.textAlign = "center";
                        if (oCells[j].HASATTACHYN == "Y" || oCells[j].HASATTACHYN == "1") {
                            var _img = document.createElement("img");
                            _img.src = "/images/newAttach.gif";
                            objTd.appendChild(_img);
                        }
                    }
                    else if (headerData[j].colName == "ISPUBLIC") {
                        objTd.style.textAlign = "center";
                        if (oCells[j].ISPUBLIC == "N") {
                            var _img = document.createElement("img");
                            _img.src = "/images/icon_lock.png";
                            objTd.appendChild(_img);
                        }
                    }
                    else if (headerData[j].colName == "REJECTFLAG" || headerData[j].colName == "RejectFlag") {
                        objTd.style.textAlign = "center";
                        if (oCells[j].REJECTFLAG == "1") {
                            strValue = "O";
                        } else {
                            strValue = "";
                        }
                        oText = document.createTextNode(strValue);
                        objTd.appendChild(oText);
                    }
                    // 전자결재G 한글로 하드코딩 해도 되겠지? 2018-07-03
                    else if (headerData[j].colName == "CreateDate" || headerData[j].colName == "등록일") {
                        objTd.style.textAlign = "left";
                        oText = document.createTextNode(strValue);
                        objTd.appendChild(oText);
                    }
                    else if (headerData[j].name == "비치" || headerData[j].name == "연기신청") {
                        objTd.style.textAlign = "left";
                        oText = document.createTextNode(strValue);
                        objTd.appendChild(oText);
                    }
                    else if (headerData[j].colName == "TransferFlag") { // TransferFlag(이관여부) 하위 td 스타일 추가
                        objTd.style.textAlign = "left";
                        objTd.align = "left";
                        oText = document.createTextNode(strValue);
                        objTd.appendChild(oText);
                    }
                    else {
                        objTd.appendChild(oText);
                    }
                }
                else {
                    objTd.appendChild(oText);
                }
                
                // 첨부파일리스트에 쪽수 컬럼 제거 2018-03-21 강민수92
                if (_thisID == "attachList") {
                    if (j == 1) {
                        objTd.title = strValue;
                    }
                    
                    if (j == 3) {
                        objTd.style.display = "none";
                    }
                }
                
                // 변경내역 > 첨부파일 이력 쪽수 컬럼 제거 2018-04-26 강민수92
                if (_thisID == "lvAttachList") {
                    if (j == 1) {
                        objTd.title = strValue;
                    }
                    
                    if (j == 5) {
                         objTd.style.display = "none";
                     }
                }
                
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

    function makeTable(pTagetID, oTHeader, oTBody) {
        
    	if (_thisID == "") {
            alert(strLang1130);
            return;
        }

        if (oTHeader == null) {
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

            if (_CheckBoxFlag)  //2020-04-27 : 체크박스 추가
                oTable.setAttribute("checkBox", _CheckBoxFlag);            

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

            //2020-04-27 : 드래그앤드랍 추가
            if (_rowDrop != null) {
                objElm.ondrop = new Function(_rowDrop + "(event)");
                objElm.ondragover = new Function("allowDrop(event)");
            }
           
            if (_debugMode) {
            	yjTest("oTable", objElm.innerHTML);
            }

            objElm = null;
        
        }
        
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
    
  //리스트뷰에 Row 추가
    function AddDataRow(objTr, addXml) {

        objTr.style.cursor = "pointer";
        objTr.onmouseover = new Function("tr_mouseover(this)");
        objTr.onmouseout = new Function("tr_mouseout(this)");
        
        //첨부파일일때 쪽수 컬럼 안보이기 위함 2018-04-26 강민수92
        var objTrArr = objTr.id.split("_");
        
        /* 2020-03-23 홍승비 - 리스트뷰에 새로운 로우 추가 시, tr_select 함수에 this.id가 아닌 고정된 ID값을 보내던 부분 수정  */
        if (_rowonclick != null)
            objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\", " + _rowonclick + ");");
        else
            objTr.onclick = new Function("tr_select(this.id, \"" + _thisID + "\");");

        var oCells = GetElementsByTagName(addXml, "CELL");

        var oDatas = GetDataElements(oCells[0]);
        for (var j = 0; j < oDatas.length; j++) {
            var strData = oDatas[j].tagName;
            var strValue = "";
            if (oDatas[j].firstChild != null && oDatas[j].firstChild.nodeValue != null)
                strValue = oDatas[j].firstChild.nodeValue;

            objTr.setAttribute(strData, strValue);
        }

        //2020-04-27 : 체크박스 추가
        if (document.getElementById(_thisID).getAttribute("checkBox") == "true") {
            var objTd = document.createElement("TD");
            objTd.style.width = "21px";
            var checkBoxIndex = objTr.id.split("_")[2];

            objTd.innerHTML = "<INPUT TYPE='CHECKBOX' id='" + _thisID + "_TD_CheckBox_" + checkBoxIndex + "' onclick='SelectCheckBox(\"" + _thisID + "\", " + checkBoxIndex + ", event);' >";
            objTd.onmouseover = new Function("td_mouseover(this)");
            objTd.onmouseout = new Function("td_mouseout(this)");
            objTr.appendChild(objTd);
            objTr.setAttribute("name", _thisID + "_TR");
        }        

        for (var j = 0; j < oCells.length; j++) {
            var strValue = SelectSingleNodeValue(oCells[j], "VALUE");
            var strStyle = SelectSingleNodeValue(oCells[j], "STYLE");
            var strClass = SelectSingleNodeValue(oCells[j], "CLASSNAME");


            var oText = document.createTextNode(strValue);
            var objTd = document.createElement("TD");
            
            if (objTrArr[0] == "attachList") {
            	if (j == 1) {
            		objTd.title = strValue;
            	}
            	if (j == 3) {
            		objTd.style.display = "none";
            	}
            }
            objTd.style.whiteSpace = "nowrap";
            objTd.style.overflow = "hidden";
            objTd.style.textOverflow = "ellipsis";

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

        if (oList.childNodes[1].childNodes[0] != undefined && oList.childNodes[1].childNodes[0].id.indexOf("noItems") > -1) {
            oList.deleteRow((pIdx + 1))
        }

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
    
    //리스트뷰에 Row 추가
    function NewAddRow(pIdx, id) {
        var oList = document.getElementById(_thisID);
        if (!oList)
            return null;

        if (pIdx == null || pIdx == "undefined")
            pIdx = 0;

        var objTr = null;
        if (new RegExp(/MSIE/).test(navigator.userAgent)) {
            //테이블 객체의 인덱스는 헤더를 포함하기 때문에 1을 더해서 인서트 한다.
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

            //마지막 선택 ID 지정
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

    //2020-04-27 : 체크박스 추가
    var rowCheckBox = document.getElementById(pRowID.split("_")[0] + "_TD_CheckBox_" + pRowID.split("_")[2]);
    if (rowCheckBox != null)
        rowCheckBox.checked = true;    

    oList = null;
    oSourceTr = null;

    //리스트에 onclick 이벤트를 지정한 경우 해당 함수를 호출한다.
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
       if(oList.rows[i].id.indexOf(pTableID)>-1)
        strID = oList.rows[i].id;
        var objTr = document.getElementById(strID);

        if (objTr) {
            //2020-04-27 : 체크박스 추가
            if (document.getElementById(pTableID + "_TD_CheckBox_" + i) != null) {
                document.getElementById(pTableID + "_TD_CheckBox_" + i).checked = false;
            }

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
function getOriginXML(pTagetID)
{    
    var objElm = document.getElementById(pTagetID);
        
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
        xmlHeader += "<COLNAME></COLNAME>";
        xmlHeader += "</HEADER>";
    }
    for(var i=1; i<objBodyData.length; i++)
    {
        xmlBody += "<ROW><CELL>";
        xmlBody += "<VALUE>" + objBodyData[i].innerText + "</VALUE>";
        for(var x=0; x<1; x++)
        {
        }
        
        xmlBody += "</CELL></ROW>";
    } 
}
function GetTodayDate()
{
	var objDate = new Date();
	var y = String(objDate.getFullYear());
	var m = String(objDate.getMonth() + 1);
	var d = String(objDate.getDate());
	
	m = "00".substring(0, 2 - m.length) + m;
	d = "00".substring(0, 2 - d.length) + d;
	
	return y + "-" + m + "-" + d;
}

function SetUnSelected(pTableID) {
    tr_unselectedAll(pTableID);
}

function setDeleteRow(nodeId) {
	var colCount = document.getElementById(nodeId).getElementsByTagName("th").length;
	var oTable = document.getElementById(nodeId);
	var oTbody = oTable.lastChild;
    // 2019.02.26 유은정 전자결재G인 경우에 colspan이 맞지 않는 경우 관련 수정
	var thCount = 0;
	var thList = document.getElementById(nodeId).getElementsByTagName("th");

	for (var i = 0; i < colCount; i++) {
		if (thList[i].style.display != "none") {
			thCount++;
		}
	}
	
	var objTr = document.createElement("TR");
    objTr.setAttribute("id", nodeId + "_TR_" + "noItems");
    oTbody.appendChild(objTr);
    var oText = document.createTextNode(strLang944);
    var objTd = document.createElement("TD");
    objTd.align = "center";
    objTd.setAttribute("colSpan", thCount);
    objTd.appendChild(oText);
    objTr.appendChild(objTd);
    
    oTable.setAttribute("lastSelectedRowID", "");
}

//2020-04-27 : 체크박스 추가
function SetAllSelect(pTableID, _this) {
    try {
        if (_this.checked) {
            var thisObj = document.getElementsByName(pTableID + "_TR");

            if (thisObj) {
                for (var i = 0; i < thisObj.length; i++) {
                    var pRowID = thisObj.item(i).getAttribute("id");

                    var oList = document.getElementById(pTableID);
                    if (!oList)
                        return;

                    var oSourceTr = document.getElementById(pRowID);
                    if (!oSourceTr)
                        return;

                    oSourceTr.setAttribute("selected", "true");
                    oSourceTr.style.backgroundColor = m_strColorSelect;

                    document.getElementById(pTableID + "_TD_CheckBox_" + i).checked = true;

                    oList.removeAttribute("lastSelectedRowID");

                    oList = null;
                    oSourceTr = null;
                }
            }
        } else {
            tr_unselectedAll(pTableID);
        }
        
        checkboxBtnShowCtl();
    } catch (e) {

    }
}

function SelectCheckBox(pTableID, pRowSN, event) {
    event.stopPropagation();

    var pSelCheckBox = document.getElementById(pTableID + "_TD_CheckBox_" + pRowSN);
    var oSourceTr = document.getElementById(pTableID + "_TR_" + pRowSN);

    var oList = document.getElementById(pTableID);
    if (!oList)
        return;

    if (!oSourceTr)
        return;

    if (pSelCheckBox.checked) {
        oSourceTr.setAttribute("selected", "true");
        oSourceTr.style.backgroundColor = m_strColorSelect;
    } else {
        oSourceTr.setAttribute("selected", "false");
        oSourceTr.style.backgroundColor = m_strColorDefault;
    }
    
	checkboxBtnShowCtl();
}

/* 2020-08-27 홍승비 - 체크박스 선택 또는 해제 시, 문서들의 상태를 체크하여 일부 버튼의 표출을 제어 (재기안, 삭제, 회송) */
function checkboxBtnShowCtl() {
	var DocList = new ListView();
    DocList.LoadFromID("DocList");
    var oArrRows = DocList.GetSelectedRows();
    
    var isDelShow = false;
    var isRedraftShow = false;
    var pFunctionType = "";
    var pDocState = "";
    if (oArrRows.length > 0) {
    	for (var i = 0; i < oArrRows.length; i++) {
    		pFunctionType = GetAttribute(oArrRows[i], "DATA10"); // DATA10 = APRSTATE(FUNCTIONTYPE)
    		pDocState = GetAttribute(oArrRows[i], "DATA12"); // DATA9 = 수신문 관련 플래그, DATA12 = DOCSTATE
    		
    		// 반송, 회수, 회송 타입이 하나라도 선택된 상태라면 재기안/삭제버튼을 표출
    		if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
    			// 내부결재가 아닌 수신문(011), 합의문(012)의 경우 삭제 불가능, 재기안 가능 (현재 체크박스가 결재할문서에만 존재하므로, 부서수신함 등의 다른 문서함은 고려하지 않음)
    			if (GetAttribute(oArrRows[i], "DATA9") == "0" && pDocState != "011" && pDocState != "012") {
    				isDelShow = true;
    			}
    			isRedraftShow = true;
    		}
    	}
    	
    	if (isDelShow == true) {
    		document.getElementById("tbtnRemoveDoc").style.display = "";
    	} else {
    		document.getElementById("tbtnRemoveDoc").style.display = "none";
    	}
    	if (isRedraftShow == true) {
    		document.getElementById("tbtnRedraft").style.display = "";
    	} else {
    		document.getElementById("tbtnRedraft").style.display = "none";
    	}
    }
}

//2020-04-27 : 드래그앤드랍 추가
function allowDrop(ev) {
    ev.preventDefault();
}