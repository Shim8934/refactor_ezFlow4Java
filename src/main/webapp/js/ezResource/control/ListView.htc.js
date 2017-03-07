/*
<public:component urn="www.asitaka.com:documentList">

<public:property name="config" put="put_config" />
<public:property name="source" put="put_source" />
<public:property name="headerSource" put="put_headerSource" />
<public:property name="selectedIndex" get="get_selectedIndex" />
<public:property name="width" put="put_width" />
<public:property name="urgent" put="put_urgent" />

<!--// 20091123 : 전자결재 리스트 변경-->
<public:property name="tblName" put="put_tblName" />

<!--// 20091201 : 결재리스트 다국어 처리-->
<public:property name="selectLang" put="put_selectLang" />

<public:method name="make" internalname="ex_makelist" />

<public:method name="firstselect" internalname="ex_firstselect" />
<public:method name="getvalue" internalname="ex_getvalue" />
<public:method name="getvalue2" internalname="ex_getvalue2" />
<public:method name="getvalue3" internalname="ex_getvalue3" />
<public:method name="getInnerText" internalname="ex_getText" /> <!-- //2011.05.11 결재알림메일 기능 추가 -->
<!--// 20091123 : 전자결재 리스트 변경-->
<public:method name="setvalue3" internalname="ex_setvalue3" />
<public:method name="listlength" internalname="ex_listlength" />
<public:method name="getCheckValue" internalname="ex_getCheckValue" />
<public:method name="getRowIndex" internalname="ex_getRowIndex" />
<public:method name="check" internalname="ex_check" />
<public:method name="getMultiRowIndex" internalname="ex_getMultiRowIndex" />
<public:method name="getheader" internalname="ex_getheader" />

<public:event name="onRowDblClick" id="listdblclick" />
<public:event name="onRowClick" id="listclick" />
<public:event name="onHeaderClick" id="headerclick" />
<public:event name="onrequestdata" id="noderequestdata" />

<public:attach event="onclick" for="element" handler="event_onclick" />
<public:attach event="onmousedown" for="element" handler="event_onmousedown" />
<public:attach event="ondblclick" for="element" handler="event_ondblclick" />
<public:attach event="onmouseover" for="element" handler="event_onmouseover" />
<public:attach event="onmouseout" for="element" handler="event_onmouseout" />
<public:attach event="onbeforeunload" for="window" handler="event_onbeforeunload" />


<public:attach event="onselectstart" for = "element" handler = "event_onselectstart" />
<attach	id="_ideventonkeydown" event="onkeydown" handler="event_onkeydown"/>


<script language="javascript">
*/


function ListView(thisobjid, elobjid) {
    window[thisobjid] = this;
    var thisid = thisobjid;
    var element = document.getElementById(elobjid); // 추가
    this.attachEvent = function(eventname, eventhandler) {
        this['on' + eventname] = eventhandler; // PostTreeView['on...']();
        //this['on' + eventname] = function() { return eventhandler.call(this); } // PostTreeView['on...']();
    }


    var g_listXML = null;
    var listXML = null;
    var headerXml = null;
    var overRow = null;
    var selectedRow = null;
    var selectedRowIndex;
    var listWidth;
    var g_colSize = new Array();
    var g_colSort = new Array();
    var g_colType = new Array();
    var g_colValue = new Array();
    var g_colCheck = new Array();
    var WIDTH = "100%";
    var URGENT = "N";
    var selectedHeader = null;

    // 20091123 : 전자결재 리스트 변경
    var TABLENAME = "";

    /* Color Settings */
    var m_strColorSelect = "#ECF3BA";
    var m_strColorDefault = "#FFFFFF";
    var m_strColorOver = "#F7FAE0";

    /* Selected Nodes */
    var m_dicSelected = new Object(); //new ActiveXObject("Scripting.Dictionary"); // 교체

    var m_strEmptyListXML = "<LISTVIEWDATA><ROWS/></LISTVIEWDATA>";
    // page count per screen

    //추가
    var m_objAnchorsSelected = null;
    var TitleIndex = null;

    //20081013 고성민 추가
    var HComment = -1;

    // 20091201 : 결재리스트 다국어 처리
    var langData_1 = strLang253;//"문서가 없습니다.";


    // getter, setter
    this.config = put_config;
    this.source = put_source;
    this.headerSource = put_headerSource;
    this.selectedIndex = get_selectedIndex;
    this.width = put_width;
    this.urgent = put_urgent;
    //2011.08.10
    this.AddRow = Put_AddRow;
    this.DelRow = Put_DelRow;
    // 20091123 : 전자결재 리스트 변경
    this.tblName = put_tblName;

    // 20091201 : 결재리스트 다국어 처리
    this.selectLang = put_selectLang;

    function put_config() {
    }

    function get_selectedIndex() {
    }

    function put_headerSource(sourceXML) {

        if (typeof (sourceXML) == "object")
            headerXml = sourceXML;
        else {
            headerXml = createXmlDom();
            headerXml.loadXML(sourceXML);
        }

        element.innerHTML = "<div class='ta'  id='listheader'></div><div class='ta'  id='listbody'></div>";
        make_header(headerXml);
    }

    function put_source(sourceXML) {
        if (typeof (sourceXML) == "object") {
            g_listXML = sourceXML;
        }
        else {
            g_listXML = createXmlDom();
            g_listXML.loadXML(sourceXML);
        }

        //put_headerSource(sourceXML);

    }

    function put_width(pWidth) {
        WIDTH = pWidth;
    }

    // 20091123 : 전자결재 리스트 변경
    function put_tblName(Name) {
        TABLENAME = Name;
    }

    function put_urgent(pUrgent) {
        URGENT = pUrgent;
    }
    
    function Put_AddRow(addxml) {
    
        if(CrossYN())
	    { 
	        
	        var xmlRtn = addxml.documentElement;
	        var Node = g_listXML.importNode(xmlRtn,true);
            g_listXML.documentElement.getElementsByTagName("ROWS")[0].appendChild(Node);
	    }
	    else
	    {
	         var xmlRtn = addxml.documentElement;
             g_listXML.documentElement.getElementsByTagName("ROWS")[0].appendChild(xmlRtn);
	    }
       
        // prompt("", getXmlString(g_listXML)) ;
    }
    
    function Put_DelRow(selidx)
    {
        if(CrossYN())
	    { 
	        var xmlRtn = g_listXML.documentElement.getElementsByTagName("ROW")[selidx];
	        g_listXML.documentElement.getElementsByTagName("ROWS")[0].removeChild(xmlRtn);
	    }
	    else
	    {
	         var xmlRtn = g_listXML.documentElement.getElementsByTagName("ROW")[selidx];
             g_listXML.documentElement.getElementsByTagName("ROWS")[0].removeChild(xmlRtn);
	    }
	    
	   // prompt("",getXmlString(g_listXML));
    }
    // 20091201 : 결재리스트 다국어 처리
    function put_selectLang(strLang) {
        if (strLang == "1") {
            if (TABLENAME == "")
                langData_1 = strLang253;//"문서가 없습니다.";
            else
                langData_1 = strLang253;//"데이터가 없습니다.";
        }
        else if (strLang == "2") {
            langData_1 = strLang253;//"No data found.";
        }
        else if (strLang == "3") {
            langData_1 = strLang253;//"データが存在しないです。";
        }
        else if (strLang == "4") {
            langData_1 = strLang253;//"有沒有數據。";
        }
    }


    // method
    this.make = ex_makelist;

    this.firstselect = ex_firstselect;
    this.getvalue = ex_getvalue;
    this.getvalue2 = ex_getvalue2;
    this.getvalue3 = ex_getvalue3;
    this.getInnerText = ex_getText; //2011.05.11 결재알림메일 기능 추가
    // 20091123 : 전자결재 리스트 변경
    this.setvalue3 = ex_setvalue3;
    this.listlength = ex_listlength;
    this.getCheckValue = ex_getCheckValue;
    this.getRowIndex = ex_getRowIndex;
    this.check = ex_check;
    this.getMultiRowIndex = ex_getMultiRowIndex;
    this.getheader = ex_getheader;

    function ex_getvalue(name) {
        if (CrossYN()) {
            return ex_getvalue_safari(name);
        }
        else {
            return ex_getvalue_IE(name);
        }
    }
    function ex_getvalue_safari(name) {
        //현재 선택된 Row에 속한 데이터 받기.
        var result;
        try {
            //result = listXML.item(selectedRowIndex).childNodes.item(0).selectSingleNode(name).text;
            result = SelectSingleNodeValue(GetChildNodes(listXML[selectedRowIndex])[0], name);
        } catch (e) { result = null; }
        return result;
    }
    function ex_getvalue_IE(name) {
        //현재 선택된 Row에 속한 데이터 받기.
        var result;
        try {
            result = listXML.item(selectedRowIndex).childNodes.item(0).selectSingleNode(name).text;
        } catch (e) { result = null; }
        return result;
    }

    //특정위치의 값 가져오기
    function ex_getvalue2(listidx, name) {
        if (CrossYN()) {
            return ex_getvalue2_safari(listidx, name);
        }
        else {
            return ex_getvalue2_IE(listidx, name);
        }
    }
    function ex_getvalue2_safari(listidx, name) {
        var result;
        try {
            //result = listXML.item(listidx).childNodes.item(0).selectSingleNode(name).text;
            result = SelectSingleNodeValue(GetChildNodes(listXML[listidx])[0], name);
        } catch (e) { result = null; }
        return result;
    }
    function ex_getvalue2_IE(listidx, name) {
        var result;
        try {
            result = listXML.item(listidx).childNodes.item(0).selectSingleNode(name).text;
        } catch (e) { result = null; }
        return result;
    }

    //특정위치의 값 가져오기
    function ex_getvalue3(row, col, name) {
        if (CrossYN()) {
            return ex_getvalue3_safari(row, col, name);
        }
        else {
            return ex_getvalue3_IE(row, col, name);
        }
    }
    function ex_getvalue3_safari(row, col, name) {
        var result;
        try {
            //result = listXML.item(row).childNodes.item(col).selectSingleNode(name).text;
            result = SelectSingleNodeValue(GetChildNodes(listXML[row])[col], name);
        } catch (e) { result = null; }

        return result;
    }
    function ex_getvalue3_IE(row, col, name) {
        var result;
        try {
            result = listXML.item(row).childNodes.item(col).selectSingleNode(name).text;
        } catch (e) { result = null; }

        return result;
    }

    //2011.05.11 결재알림메일 기능 추가
    function ex_getText(row, col) {
        if (CrossYN()) {
            return ex_getText_safari(row, col);
        }
        else {
            return ex_getText_IE(row, col);
        }
    }
    function ex_getText_safari(row, col) {
        var result;
        try {
            //result = listXML.item(row).childNodes.item(col).childNodes.item(0).text;
            result = GetChildNodes(GetChildNodes(listXML[row])[col])[0].text;
        } catch (e) { result = null; }

        return result;
    }
    function ex_getText_IE(row, col) {
        var result;
        try {
            result = listXML.item(row).childNodes.item(col).childNodes.item(0).text;
        } catch (e) { result = null; }

        return result;
    }

    // 20091123 : 전자결재 리스트 변경
    //특정위치의 값 수정오기
    function ex_setvalue3(row, col, name, strData) {
        if (CrossYN()) {
            return ex_setvalue3_safari(row, col, name, strData);
        }
        else {
            return ex_setvalue3_IE(row, col, name, strData);
        }
    }
    function ex_setvalue3_safari(row, col, name, strData) {
        try {
            //listXML.item(row).childNodes.item(col).selectSingleNode(name).text = strData;
            SelectSingleNode(GetChildNodes(listXML[row])[col], name).text = strData;
        }
        catch (e) {
        }
    }
    function ex_setvalue3_IE(row, col, name, strData) {
        try {
            listXML.item(row).childNodes.item(col).selectSingleNode(name).text = strData;
        }
        catch (e) {
        }
    }

    //선택된 열의 index 반환
    function ex_getMultiRowIndex() {
        if (CrossYN()) {
            return ex_getMultiRowIndex_safari();
        }
        else {
            return ex_getMultiRowIndex_IE();
        }    
    }
    function ex_getMultiRowIndex_safari() {
        var idx = new Array();
        var j = 0;

        for (var i = 0; i < listXML.length; i++) {
            var cur = TABLENAME + "row_" + i;

            //var rowColor = element.all(cur);
            var rowColor = document.getElementById(cur);
            if (rowColor.selected) {
                idx[j] = i;
                //idx[j] = listXML.item(i).childNodes.item(0).selectSingleNode(name).text;
                j = j + 1;
            }
        }

        return idx;
    }
    function ex_getMultiRowIndex_IE() {
        var idx = new Array();
        var j = 0;

        for (var i = 0; i < listXML.length; i++) {
            var cur = TABLENAME + "row_" + i;

            //var rowColor = element.all(cur);
            var rowColor = document.getElementById(cur);
            if (rowColor.selected) {
                idx[j] = i;
                //idx[j] = listXML.item(i).childNodes.item(0).selectSingleNode(name).text;
                j = j + 1;
            }
        }

        return idx;
    }

    function ex_getheader(name) {
        if (CrossYN()) {
            return ex_getheader_safari(name);
        }
        else {
            return ex_getheader_IE(name);
        }
    }
    function ex_getheader_safari(name) {
        //현재 선택된 Row에 속한 데이터 받기.
        var result;
        try {
            //result = headerXml.item(selectedHeader).selectSingleNode(name).text;
            result = SelectSingleNodeValue(headerXml[selectedHeader], name);

        } catch (e) { result = null; }
        return result;
    }
    function ex_getheader_IE(name) {
        //현재 선택된 Row에 속한 데이터 받기.
        var result;
        try {
            result = headerXml.item(selectedHeader).selectSingleNode(name).text;

        } catch (e) { result = null; }
        return result;
    }

    function ex_getCheckValue() {
        event_checkbox();
        return g_colCheck;
    }

    function ex_check() {
        if (listXML.length > 0)
            return true;
        else
            return false;
    }
    function ex_getRowIndex() {
        return selectedRowIndex;
    }

    function ex_firstselect(rowindex) {
        if (CrossYN()) {
            return ex_firstselect_safari(rowindex);
        }
        else {
            return ex_firstselect_IE(rowindex);
        }
    }
    function ex_firstselect_safari(rowindex) {
        //var rows = g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes;
        var rows = GetChildNodes(SelectSingleNodeNew(g_listXML, 'LISTVIEWDATA/ROWS'));
        if (rows.length <= 0) selectedRowIndex = null;
        if (rowindex == null) rowindex = "0";

        for (i = 0; i < rows.length; i++) {
            var cur = TABLENAME + "row_" + i;

            //element.all(cur).style.backgroundColor = "#FFFFFF";
            document.getElementById(cur).style.backgroundColor = "#FFFFFF";
        }

        if (rows.length > 0) {
            var currow = TABLENAME + "row_" + rowindex;

            //selectedRow = element.all(currow);
            selectedRow = document.getElementById(currow);
            selectedRowIndex = rowindex;
            selectedRow.style.backgroundColor = "#ECF3BA";
            selectedRow.selected = true;
        }
    }
    function ex_firstselect_IE(rowindex) {
        if (g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes.length <= 0) selectedRowIndex = null;
        if (rowindex == null) rowindex = "0";

        for (i = 0; i < g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes.length; i++) {
            var cur = TABLENAME + "row_" + i;

            //element.all(cur).style.backgroundColor = "#FFFFFF";
            document.getElementById(cur).style.backgroundColor = "#FFFFFF";
        }

        if (g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes.length > 0) {
            var currow = TABLENAME + "row_" + rowindex;

            //selectedRow = element.all(currow);
            selectedRow = document.getElementById(currow);
            selectedRowIndex = rowindex;
            selectedRow.style.backgroundColor = "#ECF3BA";
            selectedRow.selected = true;
        }
    }

    function ex_listlength() {
        if (CrossYN()) {
            return ex_listlength_safari();
        }
        else {
            return ex_listlength_IE();
        }
    }
    function ex_listlength_safari() {
        //var rows = g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes;
        var rows = GetChildNodes(SelectSingleNodeNew(g_listXML, 'LISTVIEWDATA/ROWS'));
        return rows.length;
    }
    function ex_listlength_IE() {
        return g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes.length;
    }


    function ex_makelist() {
        if (CrossYN()) {
            return ex_makelist_safari();
        }
        else {
            return ex_makelist_IE();
        }
    }
    function ex_makelist_safari() {
        var listHtml;
        var rowXML;

        if (g_listXML == null)
            return;

        //listXML = g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes;
        listXML = GetChildNodes(SelectSingleNodeNew(g_listXML, 'LISTVIEWDATA/ROWS'));

        // 20091123 : 전자결재 리스트 변경, ocs처리로 id추가
        listHtml = "<table id='" + TABLENAME + "MakeListView' class='mainlist' style='width:" + WIDTH + "'>";
        if (listXML.length > 0) {
            //overflow: hidden; text-overflow:ellipsis를 사용하기 위해서 td에 width속성을 넣어줄 수 없다. 따라서 위에 안보이는tr로 width를 잡는다.
            //bini
            listHtml += "<tr height='0' style=display:none>";
            //for (var j = 0; j < listXML.item(0).childNodes.length; j++)
            for (var j = 0; j < GetChildNodes(listXML[0]).length; j++)
                listHtml += "<td width='" + g_colSize[j] + "' </td>";
            listHtml += "</tr>";

            for (var i = 0; i < listXML.length; i++) {
                listHtml += "<tr id='" + TABLENAME + "row_" + i + "' style='cursor:pointer;'>";

                //for (var j = 0; j < listXML.item(i).childNodes.length; j++) {
                for (var j = 0; j < GetChildNodes(listXML[i]).length; j++) {
                    var color = "";

                    if (URGENT == "Y") {
                        //var chkUgent = listXML.item(i).childNodes.item(0).selectSingleNode("DATA14").text;
                        var chkUgent = SelectSingleNodeValue(GetChildNodes(listXML[i])[0], 'DATA14');

                        if (chkUgent == "Y")
                            color = " color:red;";
                    }

                    var coltext = "";
                    var colalign = (g_colSort[j] != "") ? g_colSort[j] : "left";
                    //coltext = listXML.item(i).childNodes.item(j).selectSingleNode("VALUE").text;
                    coltext = SelectSingleNodeValue(GetChildNodes(listXML[i])[j], 'VALUE');

                    // 20100108 : 보안 처리, 관련 추가작업(XSS)
                    coltext = coltext.replace(/&/gi, "&amp;").replace(/</gi, "&lt;").replace(/>/gi, "&gt;");

                    if ((HComment == j) && (coltext == "Y")) {
                        coltext = "<img src='/images/board_comment.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        listHtml += "<td style='overflow: hidden; text-overflow:ellipsis;padding-left:0px;" + color + "'  id='" + TABLENAME + "row_" + i + "_col" + j + "' align='center' noWrap>";
                    }
                    else {
                        listHtml += "<td style='overflow: hidden; text-overflow:ellipsis;padding-left:0px;" + color + "'  id='" + TABLENAME + "row_" + i + "_col" + j + "' align='left' noWrap>";
                    }

                    listHtml += coltext;
                    listHtml += "</td>";

                }

                listHtml += "</tr>";
                //rowXML = null;			
            }
        } else {
            // 20091201 : 결재리스트 다국어 처리
            //listHtml += "<tr><td class='ta'  align='center'>No data found.</td></tr>"
            listHtml += "<tr><td class='ta'  align='center'>" + langData_1 + "</td></tr>"
        }

        listHtml += "</table>";
        //element.all('listbody').innerHTML = listHtml;
        element.firstElementChild.nextElementSibling.innerHTML = listHtml;
        
    }
    function ex_makelist_IE() {
        var listHtml;
        var rowXML;

        if (g_listXML == null)
            return;

        listXML = g_listXML.selectSingleNode("LISTVIEWDATA/ROWS").childNodes;
        
        // 20091123 : 전자결재 리스트 변경, ocs처리로 id추가
        listHtml = "<table id='" + TABLENAME + "MakeListView' class='mainlist' style='width:" + WIDTH + "'>";
        if (listXML.length > 0) {
            //overflow: hidden; text-overflow:ellipsis를 사용하기 위해서 td에 width속성을 넣어줄 수 없다. 따라서 위에 안보이는tr로 width를 잡는다.
            //bini
            listHtml += "<tr height='0' style=display:none>";
            for (var j = 0; j < listXML.item(i).childNodes.length; j++)
                listHtml += "<td width='" + g_colSize[j] + "' </td>";
            listHtml += "</tr>";

            for (var i = 0; i < listXML.length; i++) {
                listHtml += "<tr id='" + TABLENAME + "row_" + i + "' style='cursor:pointer;'>";

                for (var j = 0; j < listXML.item(i).childNodes.length; j++) {
                    var color = "";

                    if (URGENT == "Y") {
                        var chkUgent = listXML.item(i).childNodes.item(0).selectSingleNode("DATA14").text;

                        if (chkUgent == "Y")
                            color = " color:red;";
                    }

                    var coltext = "";
                    var colalign = (g_colSort[j] != "") ? g_colSort[j] : "left";
                    coltext = listXML.item(i).childNodes.item(j).selectSingleNode("VALUE").text;

                    // 20100108 : 보안 처리, 관련 추가작업(XSS)
                    coltext = coltext.replace(/&/gi, "&amp;").replace(/</gi, "&lt;").replace(/>/gi, "&gt;");

                    if ((HComment == j) && (coltext == "Y")) {
                        coltext = "<img src='/images/board_comment.gif'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        listHtml += "<td style='overflow: hidden; text-overflow:ellipsis;padding-left:0px;" + color + "'  id='" + TABLENAME + "row_" + i + "_col" + j + "' align='center' noWrap>";
                    }
                    else {
                        listHtml += "<td style='overflow: hidden; text-overflow:ellipsis;padding-left:0px;" + color + "'  id='" + TABLENAME + "row_" + i + "_col" + j + "' align='left' noWrap>";
                    }

                    listHtml += coltext;
                    listHtml += "</td>";

                }

                listHtml += "</tr>";
                //rowXML = null;			
            }
        } else {
            // 20091201 : 결재리스트 다국어 처리
            //listHtml += "<tr><td class='ta'  align='center'>No data found.</td></tr>"
            listHtml += "<tr><td class='ta'  align='center'>" + langData_1 + "</td></tr>"
        }

        listHtml += "</table>";
        //element.all('listbody').innerHTML = listHtml;
        element.firstChild.nextSibling.innerHTML = listHtml;
    }





    // event
    // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
    function event_ondblclick(e) {
        //listdblclick.fire();
        window[thisid].ondblclick(e);
    }
    this.ondblclick = function(event) {
        this['onRowDblClick'](event);
    }

    function event_onmousedown(e) {
        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
        window[thisid].onmousedown(e);
    }
    this.onmousedown = (CrossYN()) ?
    function(event) { // safari
        if (listXML == null) return;
        try {
            // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
            if (!event) event = window.event;
            var targetEl = event.target;
            var elementid = targetEl.id;
            //var Event = e ? e : window.event;
            //var Element = Event.target ? Event.target : Event.srcElement;


            if (elementid == "headerctl") {
                event_headerctl(targetEl.id);
                return;
            }

            if (event.ctrlKey != true) {

                for (var i = 0; i < listXML.length; i++) {
                    //var obj = eval("window.document.all." + TABLENAME + "row_" + i);
                    var obj = document.getElementById(TABLENAME + 'row_' + i);
                    obj.selected = null;
                    obj.style.backgroundColor = '#FFFFFF';
                }
            }

            if (targetEl.tagName == "TD" && elementid.indexOf("col") > 0) {
                elementid = elementid.substr(0, elementid.indexOf("col") - 1);
                //selectedRow = element.all(elementid);
                selectedRow = document.getElementById(elementid);


                /*	if (selectedRow != null && window.event.ctrlKey != true) 
                {
                selectedRow.style.backgroundColor="#FFFFFF";
                selectedRow.selected = null;
                }
                */
                if (selectedRow.selected && event.ctrlKey) {
                    selectedRow.style.backgroundColor = "#FFFFFF";
                    selectedRow.selected = null;
                }
                else {

                    selectedRow.selected = true;
                    // 20091123 : 전자결재 리스트 변경
                    selectedRowIndex = elementid.substr(TABLENAME.length + 4, (elementid.length - (elementid.indexOf("_") + 1)))
                    selectedRow.style.backgroundColor = "#ECF3BA";
                }

            }
        }
        catch (e) {
            OpenAlertUI("event_onmousedown : " + e.description);
        }

    } :
    function() { // IE
        if (listXML == null) return;
        try {
            var elementid = window.event.srcElement.id;

            if (elementid == "headerctl") {
                event_headerctl(window.event.srcElement.id);
                return;
            }

            if (window.event.ctrlKey != true) {

                for (var i = 0; i < listXML.length; i++) {
                    //var obj = eval("window.document.all." + TABLENAME + "row_" + i);
                    var obj = document.getElementById(TABLENAME + "row_" + i);
                    obj.selected = null;
                    obj.style.backgroundColor = '#FFFFFF';
                }
            }

            if (window.event.srcElement.tagName == "TD" && elementid.indexOf("col") > 0) {
                elementid = elementid.substr(0, elementid.indexOf("col") - 1);
                //selectedRow = element.all(elementid);
                selectedRow = document.getElementById(elementid);


                /*	if (selectedRow != null && window.event.ctrlKey != true) 
                {
                selectedRow.style.backgroundColor="#FFFFFF";
                selectedRow.selected = null;
                }
                */
                if (selectedRow.selected && window.event.ctrlKey) {
                    selectedRow.style.backgroundColor = "#FFFFFF";
                    selectedRow.selected = null;
                }
                else {

                    selectedRow.selected = true;
                    // 20091123 : 전자결재 리스트 변경
                    selectedRowIndex = elementid.substr(TABLENAME.length + 4, (elementid.length - (elementid.indexOf("_") + 1)))
                    selectedRow.style.backgroundColor = "#ECF3BA";
                }

            }
        }
        catch (e) {
            OpenAlertUI("event_onmousedown : " + e.description);
        }

    }

    function event_headerctl(elementid) {

        //var obj = eval("window.document.all." + elementid);
        var obj = document.getElementById(elementid);

        for (var i = 0; i < listXML.length; i++) {
            //var chkobj = (listXML.length == 1) ? window.document.all.ctl : window.document.all.ctl[i];
            var chkobj = (listXML.length == 1) ? document.getElementById(ctl) : document.getElementById(ctl)[i];

            if (obj.checked == false)
                chkobj.checked = true;
            else
                chkobj.checked = false;
        }
    }

    function event_checkbox() {
        for (var i = 0; i < listXML.length; i++) {
            //var chkobj = (listXML.length == 1) ? window.document.all.ctl : window.document.all.ctl[i];
            var chkobj = (listXML.length == 1) ? document.getElementById(ctl) : document.getElementById(ctl)[i];

            if (chkobj.checked == true) {
                g_colCheck[i] = chkobj.value;
            } else
                g_colCheck[i] = "";

        }
    }

    function event_onmouseover(e) {
        window[thisid].onmouseover(e);
    }
    this.onmouseover = (CrossYN()) ?
    function(event) { // safari
        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
        if (!event) event = window.event;
        var targetEl = event.target;
        var elementid = targetEl.id;
        if (targetEl.tagName == "TD" && elementid.indexOf("col") > 0) {
            elementid = elementid.substr(0, elementid.indexOf("col") - 1);
            //overRow = element.all(elementid);
            overRow = document.getElementById(elementid);

            if (overRow.selected != true)
                overRow.style.backgroundColor = "#F7FAE0";
        }
    } :
    function() { // IE
        var elementid = window.event.srcElement.id;
        if (window.event.srcElement.tagName == "TD" && elementid.indexOf("col") > 0) {
            elementid = elementid.substr(0, elementid.indexOf("col") - 1);
            //overRow = element.all(elementid);
            overRow = document.getElementById(elementid);

            if (overRow.selected != true)
                overRow.style.backgroundColor = "#F7FAE0";
        }
    }

    /*function event_onmouseover()
    {
    var objRow = event.returnValue;
    if(typeof(objRow) == "undefined")
    return;
	
	if(objRow.id == "unSelected")
    {
    if(m_szViewType != "card")
    {
    objRow.runtimeStyle.backgroundColor = g_hotTrackColor;
    } else {
    objRow.childNodes.item(0).childNodes.item(0).childNodes.item(0).childNodes.item(0).runtimeStyle.backgroundColor = g_hotTrackColor;
    }
    } 
    }*/

    function event_onmouseout(e) {
        if (overRow == null) return;
        if (overRow.selected) return;

        overRow.selected = null;
        overRow.style.backgroundColor = "#FFFFFF";

    }

    function event_onclick(e) {
        window[thisid].onclick(e);
    }
    this.onclick = (CrossYN()) ?
    function(event) { // safari
        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
        if (!event) event = window.event;
        var targetEl = event.target;
        var elementid = targetEl.id;
        if (elementid.lastIndexOf("header") > -1) {
            selectedHeader = elementid.substr(6);
            //headerclick.fire();
            this['onHeaderClick'](event);
        }
        else {
            //listclick.fire();
            this['onRowClick'](event);
        }
    } :
    function() { // IE
        var elementid = window.event.srcElement.id;
        if (elementid.lastIndexOf("header") > -1) {
            selectedHeader = elementid.substr(6);
            //headerclick.fire();
            this['onHeaderClick']();
        }
        else {
            //listclick.fire();
            this['onRowClick']();
        }
    }

    function event_onselectstart(e) {
        var event = e;
        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
        if (!event) event = window.event;
    
        event.cancelBubble = true;
        event.returnValue = false;
    }



    if (CrossYN()) {
        if (!element.addEventListener) {
            element.onclick = event_onclick;
            element.onmousedown = event_onmousedown;
            element.ondblclick = event_ondblclick;
            element.onmouseover = event_onmouseover;
            element.onmouseout = event_onmouseout;
            element.onselectstart = event_onselectstart;
        }
        else {
            element.addEventListener('click', event_onclick, false);
            element.addEventListener('mousedown', event_onmousedown, false);
            element.addEventListener('dblclick', event_ondblclick, false);
            element.addEventListener('mouseover', event_onmouseover, false);
            element.addEventListener('mouseout', event_onmouseout, false);
            //window.addEventListener('beforeunload', event_onbeforeunload, false);
            element.addEventListener('selectstart', event_onselectstart, false);
        }
    }
    else {
        element.attachEvent('onclick', event_onclick);
        element.attachEvent('onmousedown', event_onmousedown);
        element.attachEvent('ondblclick', event_ondblclick);
        element.attachEvent('onmouseover', event_onmouseover);
        element.attachEvent('onmouseout', event_onmouseout);
        //window.attachEvent('onbeforeunload', event_onbeforeunload, false);
        element.attachEvent('onselectstart', event_onselectstart);
    }    
    
    
    
    
    function make_header(g_HeaderXml) {
        if (CrossYN()) {
            return make_header_safari(g_HeaderXml);
        }
        else {
            return make_header_IE(g_HeaderXml);
        }
    }
    function make_header_safari(g_HeaderXml) {
        var headerHtml;

        if (g_HeaderXml == null)
            return;

        //headerXml = g_HeaderXml.selectSingleNode("LISTVIEWDATA/HEADERS").childNodes;
        //headerXml = GetChildNodes(GetSelectSingleNode(g_HeaderXml, 'LISTVIEWDATA/HEADERS')); // js/xmlhttprequest.js
        headerXml = GetChildNodes(SelectSingleNodeNew(g_HeaderXml, 'LISTVIEWDATA/HEADERS'));

        listWidth = 0;

        if (headerXml.length > 0) {
            for (var i = 0; i < headerXml.length; i++) {
                // 20091209 : 결재리스트 사이즈 조절
                if (TABLENAME == "") {
                    //if (headerXml.item(i).selectSingleNode("COLNAME").text == "DocTitle") {
                    if (SelectSingleNodeValue(headerXml[i], "COLNAME") == "DocTitle") {
                        g_colSize[i] = "80%";
                        listWidth += parseInt(SelectSingleNodeValue(headerXml[i], "WIDTH")) - 1;
                    }
                    else {
                        g_colSize[i] = parseInt(SelectSingleNodeValue(headerXml[i], "WIDTH")) - 1;
                        listWidth += g_colSize[i];
                    }
                }
                else {
                    if (headerXml.length - 1 == i) {
                        g_colSize[i] = "80%";
                        listWidth += parseInt(SelectSingleNodeValue(headerXml[i], "WIDTH")) - 1;
                    }
                    else {
                        g_colSize[i] = parseInt(SelectSingleNodeValue(headerXml[i], "WIDTH")) - 1;
                        listWidth += g_colSize[i];
                    }
                }

                //if (headerXml.item(i).selectSingleNode("ALIGN") != null)
                if (SelectSingleNode(headerXml[i], "ALIGN") != null)
                    g_colSort[i] = SelectSingleNodeValue(headerXml[i], "ALIGN");

                //if (headerXml.item(i).selectSingleNode("TYPE") != null && headerXml.item(i).selectSingleNode("TYPE").attributes.getNamedItem("name") != null) {
                if (SelectSingleNode(headerXml[i], "TYPE") != null && SelectSingleNode(headerXml[i], "TYPE").attributes.getNamedItem("name") != null) {
                    g_colType[i] = SelectSingleNode(headerXml[i], "TYPE").attributes.getNamedItem("name").text
                    g_colValue[i] = SelectSingleNodeValue(headerXml[i], "TYPE")
                } else
                    g_colType[i] = "";

                //if (headerXml.item(i).selectSingleNode("COLNAME").text == "DocTitle")
                if (SelectSingleNodeValue(headerXml[i], "COLNAME") == "DocTitle")
                    TitleIndex = i;

            }
        }

        headerHtml = "<table id='" + TABLENAME + "MakeListHeader' class='mainlist' style='width:" + WIDTH + "'>";
        headerHtml += "	<tr>";

        if (headerXml.length > 0) {

            for (var i = 0; i < headerXml.length; i++) {
                //var color = (i % 2 == 0)? "bgcolor=red":"";	
                if (g_colType[i] == "checkbox") {
                    headerHtml += "<th width='" + g_colSize[i] + "' ><input type='checkbox' id='headerctl' value=''></th>";
                } else {
                    headerHtml += "<th width='" + g_colSize[i] + "'  align='" + g_colSort[i] + "' ID='header" + i + "'>";
                    //if (headerXml.item(i).selectSingleNode("NAME").text == "Comment")
                    if (SelectSingleNodeValue(headerXml[i], "NAME") == "Comment")
                        headerHtml += "";
                    else
                        headerHtml += SelectSingleNodeValue(headerXml[i], "NAME");

                    /*if (OrderCell != null && OrderCell == "") {
                        OrderCell = "Date,End Date,Save Date,Date recevied,Arrived";
                        //OrderCell = "Date";
                        OrderOption = "DESC";
                    }*/

                    //고성민추가 코멘트 이미지 처리
                    //if (headerXml.item(i).selectSingleNode("NAME").text == "Comment")
                    if (SelectSingleNodeValue(headerXml[i], "NAME") == "Comment")
                        HComment = i;

                    //if (OrderCell.lastIndexOf(headerXml.item(i).selectSingleNode("NAME").text) > -1) {
                    /*if (OrderCell != null && OrderCell.lastIndexOf(SelectSingleNodeValue(headerXml[i], "NAME")) > -1) {
                        if (OrderOption != null && OrderOption.lastIndexOf("DESC") > -1)
                            headerHtml += "<img src='/images/view-sortdown.gif'>";
                        else
                            headerHtml += "<img src='/images/view-sortup.gif'>";
                    }*/

                    headerHtml += "</th>";
                }
            }

        }

        headerHtml += "	</tr>";
        headerHtml += "</table>";

        //headerHtml = headerHtml;

        //element.all('listheader').innerHTML = headerHtml;
        element.firstElementChild.innerHTML = headerHtml;
    }


    function make_header_IE(g_HeaderXml) {
        var headerHtml;

        if (g_HeaderXml == null)
            return;

        headerXml = g_HeaderXml.selectSingleNode("LISTVIEWDATA/HEADERS").childNodes;

        listWidth = 0;

        if (headerXml.length > 0) {
            for (var i = 0; i < headerXml.length; i++) {
                // 20091209 : 결재리스트 사이즈 조절
                if (TABLENAME == "") {
                    if (headerXml.item(i).selectSingleNode("COLNAME") != null &&
                    headerXml.item(i).selectSingleNode("COLNAME").text == "DocTitle") {
                        g_colSize[i] = "80%";
                        listWidth += parseInt(headerXml.item(i).selectSingleNode("WIDTH").text) - 1;
                    }
                    else {
                        g_colSize[i] = parseInt(headerXml.item(i).selectSingleNode("WIDTH").text) - 1;
                        listWidth += g_colSize[i];
                    }
                }
                else {
                    if (headerXml.length - 1 == i) {
                        g_colSize[i] = "80%";
                        listWidth += parseInt(headerXml.item(i).selectSingleNode("WIDTH").text) - 1;
                    }
                    else {
                        g_colSize[i] = parseInt(headerXml.item(i).selectSingleNode("WIDTH").text) - 1;
                        listWidth += g_colSize[i];
                    }
                }

                if (headerXml.item(i).selectSingleNode("ALIGN") != null)
                    g_colSort[i] = headerXml.item(i).selectSingleNode("ALIGN").text

                if (headerXml.item(i).selectSingleNode("TYPE") != null && headerXml.item(i).selectSingleNode("TYPE").attributes.getNamedItem("name") != null) {
                    g_colType[i] = headerXml.item(i).selectSingleNode("TYPE").attributes.getNamedItem("name").text
                    g_colValue[i] = headerXml.item(i).selectSingleNode("TYPE").text
                } else
                    g_colType[i] = "";

                if (headerXml.item(i).selectSingleNode("COLNAME") != null &&
                 headerXml.item(i).selectSingleNode("COLNAME").text == "DocTitle")
                    TitleIndex = i;

            }
        }

        headerHtml = "<table id='" + TABLENAME + "MakeListHeader' class='mainlist' style='width:" + WIDTH + "'>";
        headerHtml += "	<tr>";

        if (headerXml.length > 0) {

            for (var i = 0; i < headerXml.length; i++) {
                //var color = (i % 2 == 0)? "bgcolor=red":"";	
                if (g_colType[i] == "checkbox") {
                    headerHtml += "<th width='" + g_colSize[i] + "' ><input type='checkbox' id='headerctl' value=''></th>";
                } else {
                    headerHtml += "<th width='" + g_colSize[i] + "'  align='" + g_colSort[i] + "' ID='header" + i + "'>";
                    if (headerXml.item(i).selectSingleNode("NAME").text == "Comment")
                        headerHtml += "";
                    else
                        headerHtml += headerXml.item(i).selectSingleNode("NAME").text;

                    /*if (OrderCell != null && OrderCell == "") {
                        OrderCell = "Date,End Date,Save Date,Date recevied,Arrived";
                        //OrderCell = "Date";
                        OrderOption = "DESC";
                    }
                    */
                    //고성민추가 코멘트 이미지 처리
                    if (headerXml.item(i).selectSingleNode("NAME").text == "Comment")
                        HComment = i;
                    /*
                    if (OrderCell != null && OrderCell.lastIndexOf(headerXml.item(i).selectSingleNode("NAME").text) > -1) {
                        if (OrderOption != null && OrderOption.lastIndexOf("DESC") > -1)
                            headerHtml += "<img src='/images/view-sortdown.gif'>";
                        else
                            headerHtml += "<img src='/images/view-sortup.gif'>";
                    }
                    */
                    headerHtml += "</th>";
                }
            }

        }

        headerHtml += "	</tr>";
        headerHtml += "</table>";

        headerHtml = headerHtml;

        //element.all('listheader').innerHTML = headerHtml;
        element.firstChild.innerHTML = headerHtml;
    }

}








function SubStrByte(input, len) {
    var i, j = 0;
    var retv = "";
    for (i = 0; i < input.length; i++) {
        val = escape(input.charAt(i)).length;
        if (val == 6) // kor
            j++;

        j++;

        if (j > len) {
            retv += '...';
            break;
        }

        retv += input.charAt(i).toString();
    }

    return retv;
}



function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApproval/ezAPRALERT.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

