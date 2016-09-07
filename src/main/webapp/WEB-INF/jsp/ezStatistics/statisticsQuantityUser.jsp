<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
    <title><spring:message code='ezStatistics.t1025' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
    <link rel="stylesheet" href="/js/ezStatistics/js/jquery.jqplot.min.css" type="text/css">
    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">    
    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
    <script type="text/javascript" src="<spring:message code='ezStatistics.e1' />"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/excanvas.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/jquery.min.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/jquery.jqplot.min.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/jqplot.barRenderer.min.js"></script>    
    <script type="text/javascript">
    var xmlHttp = null;
	
	document.onselectstart = function () {
    if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
        return false;
    else
        return true;
	};
	
    window.onload = function () {
        if (CrossYN())
            document.getElementById("topmenu").style.cssFloat = "";
        else
            document.getElementById("topmenu").style.whiteSpace = "nowrap";

        makeoptionyear();
        
        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${deptID}");
        createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
        createNodeAndInsertText(xmlpara, objNode, "PROP", "");
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(xmlpara);
        xmlTree = loadXMLString(xmlHTTP.responseText);
        var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
        document.getElementById('TreeView').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetConfig(treeXML);
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestData");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.DataSource(xmlTree);
        treeView.DataBind("TreeView");
    }

    function TreeViewNodeClick() {
        var nodeIdx = 1;
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");
        var selnode = treeView.GetSelectNode();
        DeptID = selnode.GetNodeData("CN");
        displayUserList(DeptID);
    }

    function RequestData(pNodeID, pTreeID) {
        var TreeIdx = pNodeID;
        var treeNode = new TreeNode();
        treeNode.LoadFromID(TreeIdx);
        var deptID = treeNode.GetNodeData("CN");
        GetDeptSubTreeInfo(deptID, TreeIdx);
    }

    function GetDeptSubTreeInfo(deptID, TreeIdx) {
        var xmlHTTP = createXMLHttpRequest();
        var xmlRtn = createXmlDom();
        var xmlpara = createXmlDom();

        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");


        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
        xmlHTTP.send(xmlpara);


        xmlRtn = loadXMLString(xmlHTTP.responseText);
        {
            if (CrossYN()) {
                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
            }
            else {
                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
            }
        }


        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");
        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
    }

    function displayUserList(DeptID) {
    	
    	$.ajax({
        	type : "POST",
        	dataType : "xml",
        	url : "/ezOrgan/getDeptMemberList.do",
        	async : false,
        	data : {deptID : DeptID, cell : "displayName;description", prop : "department;displayName;description;title", type : "user"},
        	success : function(result){
        		var retXml = createXmlDom();

                if (document.getElementById("UserList").innerHTML != "")
                    document.getElementById("UserList").innerHTML = "";

                var headerData = createXmlDom();
                headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                if (result != "") {
                    if (CrossYN()) {
                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
                        var Node = headerData.importNode(xmlRtn, true);
                        headerData.documentElement.appendChild(Node);
                    }
                    else {
                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
                        headerData.documentElement.appendChild(xmlRtn);
                    }
                }
                var pUserList = new ListView();
                pUserList.SetID("lvUserList");
                pUserList.SetRowOnClick("getmailstatistics");
                pUserList.SetSelectFlag(false);
                pUserList.SetHeightFree(true);
                pUserList.DataSource(headerData);
                pUserList.DataBind("UserList");
        	},
        	error : function(error){
        		OpenAlertUI(linealt2 + error)
        	}
        });

    }

    var isfirst = true;
    var tempyear;
    function makeoptionyear() {
        var date = new Date()
        var year = date.getFullYear();

        if (isfirst) {
            tempyear = year;
            for (var i = 0; i < 5; i++) {
                var option = document.createElement("OPTION");
                option.value = year;
                option.innerHTML = year;

                document.getElementById("selyear").appendChild(option);
                year--;
            }
            isfirst = false;
        }
        else {
            var selyear = parseInt(document.getElementById("selyear").value);
            if ((selyear < tempyear - 2 || selyear < tempyear + 2) && selyear + 2 <= year) {
                document.getElementById("selyear").innerHTML = "";
                tempyear = selyear + 2;
                for (var i = 0; i < 5; i++) {
                    var option = document.createElement("OPTION");
                    option.value = tempyear;
                    option.innerHTML = tempyear;

                    if (selyear == tempyear)
                        option.selected = true;

                    document.getElementById("selyear").appendChild(option);
                    tempyear--;
                }
                tempyear = selyear + 2;
            }
        }
    }

    var seluserid;
    function getmailstatistics() {
        xmlHttp = createXMLHttpRequest();
        var xmlDoc = createXmlDom();

        var pUserList = new ListView();
        pUserList.LoadFromID("lvUserList");

        if (pUserList.GetSelectedRows()[0] != undefined)
            seluserid = pUserList.GetSelectedRows()[0].getAttribute("DATA2");

        var objRoot, objNode
        objNode = createNodeInsert(xmlDoc, objNode, "PARAM");
        createNodeAndInsertText(xmlDoc, objNode, "USERID", seluserid);
        createNodeAndInsertText(xmlDoc, objNode, "SDATE", document.getElementById("selyear").value);
        createNodeAndInsertText(xmlDoc, objNode, "EDATE", document.getElementById("selyear").value);
        xmlHttp.open("POST", "/ezStatistics/getQuantityUser.do", true);
        xmlHttp.onreadystatechange = event_getmailstatistics;
        xmlHttp.send(xmlDoc);
    }

    var data = new Array();
    var data2 = new Array();
    function event_getmailstatistics() {
        if (xmlHttp != null && xmlHttp.readyState == 4) {
            data = new Array();
            data2 = new Array();
            document.getElementById("statisticschart").innerHTML = "";
            document.getElementById("statisticstable").innerHTML = "";
            document.getElementById("chartdiv").style.display = "none";

            var resultxml = loadXMLString(xmlHttp.responseText);

            document.getElementById("seluser").style.display = "none";
            if (SelectNodes(resultxml, "DATA/ROW").length == 0) {
                document.getElementById("nodata").style.display = "";
                document.getElementById("viewdata").style.display = "none";
                return;
            }
            document.getElementById("nodata").style.display = "none";
            document.getElementById("viewdata").style.display = "";

            var _Table = document.createElement("TABLE");
            _Table.style.textAlign = "center";
            _Table.style.width = "100%";
            _Table.className = "tstyle2";
            _Table.style.border = "1px solid #dadada"

            var _Tr = document.createElement("TR");

            var start = document.getElementById("selyear").value;

            var _Th = document.createElement("TH");
            _Th.style.textAlign = "center";
            _Th.innerHTML = "<spring:message code='ezStatistics.t1015' />";
            _Tr.appendChild(_Th);

            _Th = document.createElement("TH");
            _Th.style.textAlign = "center";
            _Th.innerHTML = "<spring:message code='ezStatistics.t1000' />";

            var nowyear = new Date().getYear();
            var moncnt = 12;

            _Tr.appendChild(_Th);
            var ticks = "<spring:message code='ezStatistics.t218' />".split(";");
            for (var i = 0; i < 6; i++) {
                var _Th2 = document.createElement("TH");
                _Th2.style.textAlign = "center";
                _Th2.innerHTML = ticks[i];
                _Tr.appendChild(_Th2);
            }
            _Table.appendChild(_Tr);

            var tempcn = "";
            var j = 0;
            for (var k = 0; k < SelectNodes(resultxml, "DATA/ROW").length; k++) {
                var tempdata = new Array();
                var tempdata2 = new Array();
                var curcn;
                if (CrossYN())
                    curcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "USERID").textContent;
                else
                    curcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "USERID").text;
                if (tempcn != curcn) {
                    tempcn = curcn
                    var _Tr2 = document.createElement("TR");
                    var _Tr3 = document.createElement("TR");
                    var _Tr4 = document.createElement("TR");
                    var _Tr5 = document.createElement("TR");
                    var _Tr6 = document.createElement("TR");

                    var _Td = document.createElement("TD");
                    _Td.rowSpan = "5";

                    if (CrossYN())
                        _Td.innerHTML = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "DISPLAYNAME").textContent;
                    else
                        _Td.innerHTML = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "DISPLAYNAME").text;

                    _Tr2.appendChild(_Td);

                    for (var i = 0; i < moncnt; i++) {
                        if (i == 6) {
                            var _Th = document.createElement("TH");
                            _Th = document.createElement("TH");
                            _Th.style.textAlign = "center";
                            _Th.innerHTML = "<spring:message code='ezStatistics.t1000' />";

                            var nowyear = new Date().getYear();

                            _Tr4.appendChild(_Th);
                            for (var l = 6; l < 12; l++) {
                                var _Th2 = document.createElement("TH");
                                _Th2.style.textAlign = "center";
                                _Th2.innerHTML = ticks[l];
                                _Tr4.appendChild(_Th2);
                            }
                        }
                        if (i == 0) {
                            _Td = document.createElement("TD");
                            _Td.innerHTML = "<spring:message code='ezStatistics.t1022' />";
                            var _Td2 = document.createElement("TD");
                            _Td2.innerHTML = "<spring:message code='ezStatistics.t1024' />";

                            _Tr2.appendChild(_Td);
                            _Tr3.appendChild(_Td2);
                        }
                        else if (i == 6) {
                            _Td = document.createElement("TD");
                            _Td.innerHTML = "<spring:message code='ezStatistics.t1022' />";
                            var _Td2 = document.createElement("TD");
                            _Td2.innerHTML = "<spring:message code='ezStatistics.t1024' />";

                            _Tr5.appendChild(_Td);
                            _Tr6.appendChild(_Td2);
                        }

                        var _Td = document.createElement("TD");
                        var _Td2 = document.createElement("TD");

                        var mon = parseInt(i + 1);
                        if (i < 10)
                            mon = "0" + mon;

                        var date = start + mon;

                        var yyyymm;

                        if (SelectNodes(resultxml, "DATA/ROW").length > j) {
                            if (CrossYN()) {
                                yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").textContent;
                                selcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "USERID").textContent;
                            }
                            else {
                                yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").text;
                                selcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "USERID").text;
                            }
                        }

                        if (date == yyyymm.trim() && curcn == selcn) {
                            var maildata;
                            if (CrossYN())
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "QTY").textContent;
                            else
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "QTY").text;

                            if (maildata != "") {
                                _Td.innerHTML = getmailsize(maildata);
                                tempdata.push(parseInt(maildata) / 1024 / 1024);
                            }
                            else {
                                _Td.innerHTML = "0";
                                tempdata.push(0);
                            }

                            if (CrossYN())
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "ALLOT").textContent;
                            else
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "ALLOT").text;

                            if (maildata != "") {
                                _Td2.innerHTML = getmailsize(maildata);
                                tempdata2.push(parseInt(maildata) / 1024 / 1024);
                            }
                            else {
                                _Td2.innerHTML = "0";
                                tempdata2.push(0);
                            }

                            j++;
                        }
                        else {
                            tempdata.push(0);
                            tempdata2.push(0);
                            _Td.innerHTML = "0";
                            _Td2.innerHTML = "0";
                        }
                        if (i > 5) {
                            _Tr5.appendChild(_Td);
                            _Tr6.appendChild(_Td2);
                        }
                        else {
                            _Tr2.appendChild(_Td);
                            _Tr3.appendChild(_Td2);
                        }
                    }
                    data.push(tempdata);
                    data2.push(tempdata2);
                    _Table.appendChild(_Tr2);
                    _Table.appendChild(_Tr3);
                    _Table.appendChild(_Tr4);
                    _Table.appendChild(_Tr5);
                    _Table.appendChild(_Tr6);
                }

            }
            document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
            drawingchart();
        }
    }

    function getmailsize(size) {
        if (parseInt(size) / 1024 / 1024 / 1024 > 1)
            return (parseInt(size) / 1024 / 1024 / 1024).toFixed(1) + "GB";
        else if (parseInt(size) / 1024 / 1024 > 1)
            return (parseInt(size) / 1024 / 1024).toFixed(1) + "MB";
        else if (parseInt(size) / 1024 > 1)
            return (parseInt(size) / 1024).toFixed(1) + "KB";
        else
            return (parseInt(size)).toFixed(1) + "B";
    }

    function drawingchart(type) {
        if (data[0] == undefined) {
            return;
        }
        document.getElementById("statisticschart").innerHTML = "";
        document.getElementById("chartdiv").style.display = "";
        var ticks = "<spring:message code='ezStatistics.t218' />".split(";");
        plot2 = $.jqplot('statisticschart', [data[0], data2[0]], {
            animate: false,
            seriesDefaults: {
                renderer: $.jqplot.BarRenderer,
                pointLabels: { show: true }
            },
            axes: {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer, ticks: ticks
                }
            }
        });
    }
    function btnexportexcel_onclick() {
        document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
        document.getElementById("formAgent").target = "saveExcel";
        document.getElementById("formAgent").submit();
    }

    function search_press(e) {
        if (window.event) {
            if (window.event.keyCode == 13) {
                search();
            }
        }
        else {
            if (e.which == 13)
                search();
        }
    }

    function search() {
        if (document.getElementById("searchopt").value == "1")
            searchuser();
        else
            searchdept();
    }

    function searchdept() {
        if (keyword.value == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            keyword.focus();
            return;
        }
        
        var xmlDom = createXmlDom();
        
        $.ajax({
        	type : "POST",
        	dataType : "xml",
        	url : "/ezOrgan/getSearchList.do",
        	async : false,
        	data : {search : "displayname::" + keyword.value, cell : "extensionAttribute3;displayName;extensionAttribute9", prop : "", type : "group"},
        	success : function(result){	
        		xmlDom = result;
                adCount = xmlDom.getElementsByTagName("ROW").length;
        	},
        	error : function(error){
        		alert(strLang17 + error);
        		xmlDom = null;
        	}
        });
        
        if (adCount == 0) {
            alert("<spring:message code='ezStatistics.t1011' />");
            return;
        }
        else if (adCount == 1) {
            bSearch = true;
            g_xmlHTTP = createXMLHttpRequest();

            if (CrossYN())
                var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
            else
                var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";

            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
            g_xmlHTTP.send(strQuery);
        }
        else {
            var rgParams = new Array();
            rgParams["addrBook"] = xmlDom;
            rgParams["deptid"] = "";
            var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
            feature = feature + GetShowModalPosition(540, 460);
            window.showModalDialog("/ezStatistics/statisticsCheckName2.do", rgParams, feature);

            if (rgParams["deptid"] != "") {
                bSearch = true;
                g_xmlHTTP = createXMLHttpRequest();
                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
                g_xmlHTTP.send(strQuery);
            }
        }
    }

    function event_getDeptFullTree() {
        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
            if (g_xmlHTTP.statusText == "OK") {
                if (!bSearch) {
                    try {
                        if (CrossYN())
                            opener.opener.top.organview = g_xmlHTTP.responseXML;
                        else
                            window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
                    } catch (e) { }
                }

                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
                document.getElementById('TreeView').innerHTML = "";

                var treeView = new TreeView();
                treeView.SetConfig(treeXML);
                treeView.SetID("FromTreeView");
                treeView.SetUseAgency(true);
                treeView.SetRequestData("RequestData");
                treeView.SetNodeClick("TreeViewNodeClick");
                treeView.DataSource(g_xmlHTTP.responseXML);
                treeView.DataBind("TreeView");
            }
            else {
                alert(g_xmlHTTP.statusText)
                g_xmlHTTP = null;
            }
        }
    }

    function searchuser() {
        if (keyword.value == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            keyword.focus();
            return;
        }
        
        $.ajax({
        	type : "POST",
        	dataType : "xml",
        	url : "/ezOrgan/getSearchList.do",
        	async : true,
        	data : {search : "displayname::" + keyword.value, cell : "displayName;description", prop : "department;displayName;description;title", type : "user"},
        	success : function(result){	
        		if (result.getElementsByTagName("ROW").length == 0)
                    alert("<spring:message code='ezStatistics.t1016' />");
                else {
                    var retXml = createXmlDom();

                    if (document.getElementById("UserList").innerHTML != "")
                        document.getElementById("UserList").innerHTML = "";

                    var headerData = createXmlDom();
                    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                    if (result != "") {
                        if (CrossYN()) {
                            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
                            var Node = headerData.importNode(xmlRtn, true);
                            headerData.documentElement.appendChild(Node);
                        }
                        else {
                            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
                            headerData.documentElement.appendChild(xmlRtn);
                        }
                    }
                    var pUserList = new ListView();
                    pUserList.SetID("lvUserList");
                    pUserList.SetRowOnClick("getmailstatistics");
                    pUserList.SetSelectFlag(false);
                    pUserList.SetHeightFree(true);
                    pUserList.DataSource(headerData);
                    pUserList.DataBind("UserList");
                }
        	},
        	error : function(error){
        		alert(error);
        	}
        });
        
    }
</script>
</head>
<body class="mainbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<xml id="userlist_h" style="display: none">
<LISTVIEWDATA>
<HEADERS>
    <HEADER>
    <NAME><spring:message code='ezStatistics.t1017' /></NAME>
    <WIDTH>70</WIDTH>
    </HEADER>
    <HEADER>
    <NAME><spring:message code='ezStatistics.t113' /></NAME>
    <WIDTH>100</WIDTH>
    </HEADER>
</HEADERS>
<ROWS></ROWS>
</LISTVIEWDATA>
</xml>
<h1><spring:message code='ezStatistics.t1025' /></h1>
<table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2; margin-bottom: 5px">
    <tr>
        <td style="width: 99%">
            <span id="topmenu" style="float: left; width: 500px"><spring:message code='ezStatistics.t1002' /> : 
                <select id="selyear" onchange="makeoptionyear(); getmailstatistics()"></select>
                <spring:message code='ezStatistics.t55' />
          &nbsp;&nbsp;
         <select id="searchopt">
             <option value="1"><spring:message code='ezStatistics.t1017' /></option>
             <option value="2"><spring:message code='ezStatistics.t113' /></option>
         </select>
                <input id="keyword" type="text" style="width: 100px" onkeypress="search_press(event)" />
                <a class="imgbtn" style="vertical-align: middle"><span onclick="search()"><spring:message code='ezStatistics.t36' /></span></a>
            </span>
        </td>
        <td>
            <div id="mainmenu" style="float: right; height: 28px; width: 100px">
                <ul style="display:none;">
                    <li><span onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003' /></span></li>
                </ul>
            </div>
        </td>
    </tr>
</table>
<br />
<h2 id="ToTitle" class="receiver_tltype01" style="border:0px">
    <span style="min-width: 45px;"><spring:message code='ezStatistics.t1014' /></span>
</h2>
<table style="width: 1150px;height:670px ;border:1px solid #b6b6b6"> 
    <tr>
        <td style="vertical-align: top">
            <div style="width:310px;height:330px;overflow-x:auto;overflow-y:auto;border-right:1px solid #b6b6b6;" id="TreeView" ></div>
            <div id="UserList" style="Width: 310px; Height: 350px; overflow: auto;border-right:1px solid #b6b6b6"></div>
        </td>
        <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
            <div id="viewdata" style="display: none">
                <div class="statistics_addition">
                    <dl>
                        <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
                        <dd id="colorbox" class="additiontext"><spring:message code='ezStatistics.t1022' /></dd>
                    </dl>
                    <dl>
                        <dt class="colorbox_wrap"><span style="background: #eaa229" class="colorbox"></span></dt>
                        <dd id="colorbox2" class="additiontext"><spring:message code='ezStatistics.t1024' /></dd>
                    </dl>
                </div>
                <div id="chartdiv" style="width: 100%; text-align: center; display: none;">
                    <div id="statisticschart" style="width: 800px; height: 500px; float: left; font-size: 16px;">
                    </div>
                </div>
                <div id="statisticstable"></div>
            </div>
            <div id="seluser" class="statistics_select" style="margin: 0 auto">
                <dl class="statistics_txt">
                    <dt><spring:message code='ezStatistics.t1019' /></dt>
                    <dd><spring:message code='ezStatistics.t1020' /><br>
                        <spring:message code='ezStatistics.t1021' /></dd>
                </dl>
            </div>
            <div id="nodata" class="statistics_nodata" style="display: none; margin: 0 auto">
                <dl class="statistics_txt">
                    <dt><spring:message code='ezStatistics.t1008' /></dt>
                    <dd><spring:message code='ezStatistics.t1009' /></dd>
                </dl>
            </div>
        </td>
    </tr>
</table>
<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/myoffice/ezStatistics/excelExportOut.aspx">
    <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
    <input type="hidden" id="userAgent" name="userAgent" value="">
</form>
<iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
<script type="text/javascript">
selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
</script>
</html>
