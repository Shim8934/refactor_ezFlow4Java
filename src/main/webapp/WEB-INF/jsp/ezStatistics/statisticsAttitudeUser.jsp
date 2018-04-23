<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t1018' /></title>
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
    var Tab1_flag = true;
    var xmlHttp = createXMLHttpRequest();
//     var adminCompany = "${adminCompany}";
	
	document.onselectstart = function () {
    if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
        return false;
    else
        return true;
	};
	
    window.onload = function () {
        if (CrossYN()) {
            document.getElementById("topmenu").style.cssFloat = "";
        } else {
            document.getElementById("topmenu").style.whiteSpace = "nowrap";
        }
		
		//년도 설정(조회기간)
        makeoptionyear();
        
        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${deptID}");
        createNodeAndInsertText(xmlpara, objNode, "TOPID", "${companyID}");
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

    //조직도 회사,부서 클릭
    function TreeViewNodeClick() {
        var nodeIdx = 1;
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");
        var selnode = treeView.GetSelectNode();
        DeptID = selnode.GetNodeData("CN");
        displayUserList(DeptID);
        //만약 회사 클릭시
        if (selnode.GetNodeData("SETNODEICONBYNAME") != "") {
        	company_typeList(DeptID);
        }
    }

    //하위부서?
    function RequestData(pNodeID, pTreeID) {
        var TreeIdx = pNodeID;
        var treeNode = new TreeNode();
        treeNode.LoadFromID(TreeIdx);
        var deptID = treeNode.GetNodeData("CN");
        GetDeptSubTreeInfo(deptID, TreeIdx);
    }

    //하위부서 정보
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

    //부서클릭시 사원리스트 뿌리기
    function displayUserList(DeptID) {
    	$.ajax({
        	type : "POST",
        	dataType : "text",
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
                	var xmlDom = loadXMLString(result);
                    if (CrossYN()) {
                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                        var Node = headerData.importNode(xmlRtn, true);
                        headerData.documentElement.appendChild(Node);
                    }
                    else {
                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                        headerData.documentElement.appendChild(xmlRtn);
                    }
                }
                var pUserList = new ListView();
                pUserList.SetID("lvUserList");
                //사원리스트 클릭 이벤트 주기
                pUserList.SetRowOnClick("getAttitudeStatistics");//////////////////////////////////////////////////////////////////////
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
    
    //회사 클릭시마다 근태유형 selectbox 변경
    function company_typeList(companyId) {
    	$.ajax({
        	type : "POST",
        	dataType : "json",
        	url : "/ezStatistics/attitudeTypeList.do",
        	async : false,
        	data : {companyId : companyId},
        	success : function(result){
        		var html = "";
        		if (result.length != null && result.length != 0) {
	                for (var i = 0; i < result.length; i++) {
		        		html += "<option value='" + result[i].typeId + "'>" + result[i].typeName + "</option>";
	                }
        		}
        		$("#attitudeType").html(html);
        	},
        	error : function(error){
//         		OpenAlertUI(linealt2 + error)
        	}
        });
    }
    
    //조회기간 년도 (현재년도에서 -5년까지)
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

    //사원선택시
    function getAttitudeStatistics() {
    	var selectUserId = pUserList.GetSelectedRows()[0].getAttribute("DATA2");
    	$.ajax({
        	type : "POST",
        	dataType : "json",
        	url : "/ezStatistics/getAttitudeUser.do",
        	async : false,
        	data : {userId : selectUserId, typeId : $("#attitudeType").val(), year : $("#selyear").val() },
        	success : function(result){
        		
        	},
        	error : function(error){
        		
        	}
        });
    }
//     var seluserid;
//     function getmailstatistics() {
//         xmlHttp = createXMLHttpRequest();
//         var xmlDoc = createXmlDom();

//         var pUserList = new ListView();
//         pUserList.LoadFromID("lvUserList");

//         if (pUserList.GetSelectedRows()[0] != undefined)
//             seluserid = pUserList.GetSelectedRows()[0].getAttribute("DATA2");

//         var objRoot, objNode
//         objNode = createNodeInsert(xmlDoc, objNode, "PARAM");
//         createNodeAndInsertText(xmlDoc, objNode, "USERID", seluserid);
//         createNodeAndInsertText(xmlDoc, objNode, "SDATE", document.getElementById("selyear").value);
//         createNodeAndInsertText(xmlDoc, objNode, "EDATE", document.getElementById("selyear").value);
//         xmlHttp.open("POST", "/ezStatistics/getMailUser.do", true);
//         xmlHttp.onreadystatechange = event_getmailstatistics;
//         xmlHttp.send(xmlDoc);
//     }

	//사원선택시와 관련 이벤트 함수
	/*
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

            if (SelectNodes(resultxml, "DATA/ROW").length == 0) {
                if (document.getElementById("seluser").style.display == "none")
                    document.getElementById("nodata").style.display = "";
                document.getElementById("viewdata").style.display = "none";
                return;
            }
            document.getElementById("seluser").style.display = "none";
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
            _Th.style.width = "130px";
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
                    curcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "CN").textContent;
                else
                    curcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "CN").text;
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
                            _Td.innerHTML = tabledata[0];
                            var _Td2 = document.createElement("TD");
                            _Td2.innerHTML = tabledata[1];

                            _Tr2.appendChild(_Td);
                            _Tr3.appendChild(_Td2);
                        }
                        else if (i == 6) {
                            _Td = document.createElement("TD");
                            _Td.innerHTML = tabledata[0];
                            var _Td2 = document.createElement("TD");
                            _Td2.innerHTML = tabledata[1];

                            _Tr5.appendChild(_Td);
                            _Tr6.appendChild(_Td2);
                        }

                        var start = document.getElementById("selyear").value;
                        var _Td = document.createElement("TD");
                        var _Td2 = document.createElement("TD");

                        var mon = parseInt(i + 1);
                        if (mon < 10)
                            mon = "0" + mon;

                        var date = start + mon;

                        var yyyymm;
                        var selcn;
                        if (SelectNodes(resultxml, "DATA/ROW").length > j) {
                            if (CrossYN()) {
                                yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").textContent;
                                selcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "CN").textContent;
                            }
                            else {
                                yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").text;
                                selcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "CN").text;
                            }
                        }

                        if (date == yyyymm.trim() && curcn == selcn) {
                            var maildata;
                            if (CrossYN())
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[2]).textContent;
                            else
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[2]).text;

                            if (maildata != "0") {
                                if (tabledata[2] == "RECEIVEINSIZE" || tabledata[2] == "RECEIVEOUTSIZE") {
                                    _Td.innerHTML = getmailsize(maildata);
                                    tempdata.push(parseInt(maildata) / 1024 / 1024);
                                }
                                else {
                                    _Td.innerHTML = maildata;
                                    tempdata.push(parseInt(maildata));
                                }
                            }
                            else {
                                _Td.innerHTML = "0";
                                tempdata.push(0);
                            }

                            if (CrossYN())
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[3]).textContent;
                            else
                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[3]).text;

                            if (maildata != "0") {
                                if (tabledata[2] == "RECEIVEINSIZE" || tabledata[2] == "RECEIVEOUTSIZE") {
                                    _Td2.innerHTML = getmailsize(maildata);
                                    tempdata2.push(parseInt(maildata) / 1024 / 1024);
                                }
                                else {
                                    _Td2.innerHTML = maildata;
                                    tempdata2.push(parseInt(maildata));
                                }
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

            if (CrossYN()) {
                document.getElementById("colorbox").textContent = tabledata[0];
                document.getElementById("colorbox2").textContent = tabledata[1];
            }
            else {
                document.getElementById("colorbox").innerText = tabledata[0];
                document.getElementById("colorbox2").innerText = tabledata[1];
            }

            drawingchart();
        }
    }
    */

    //차트그리기
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

    //엑셀내려받기 버튼 클릭시
    function btnexportexcel_onclick() {
        document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
        
        if (document.getElementById("saveExcelData").value == "") {
        	alert("<spring:message code='ezStatistics.t1019' />");
        	return ;
        }
        
        document.getElementById("formAgent").target = "saveExcel";
        document.getElementById("formAgent").submit();
    }

    //검색
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

    //검색
    function search() {
        if (document.getElementById("searchopt").value == "1")
            searchuser();
        else
            searchdept();
    }

    //부서로 검색
    var searchdept_cross_dialogArguments = new Array();
    function searchdept() {
        if (keyword.value.trim() == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            keyword.focus();
            return;
        }
        
		var xmlDom = createXmlDom();
        
        $.ajax({
        	type : "POST",
        	dataType : "text",
        	url : "/ezOrgan/getSearchList.do",
        	async : false,
        	data : {search : "displayname::" + keyword.value, cell : "extensionAttribute3;displayName;extensionAttribute9", prop : "", type : "group"},
        	success : function(result){	
        		xmlDom = loadXMLString(result);
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
            
            var agent = navigator.userAgent.toLowerCase(); 
			if (CrossYN()) {
				searchdept_cross_dialogArguments[0] = rgParams;
				searchdept_cross_dialogArguments[1] = SelelctDept_complite;
				var OpenWin = window.open("/ezStatistics/statisticsCheckName2.do", "", GetOpenWindowfeature(609, 372));    
				try { OpenWin.focus(); } catch (e) { }				
			} 
			else {
	            var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	            feature = feature + GetShowModalPosition(540, 460);
	            window.showModalDialog("/ezStatistics/statisticsCheckName2.do", rgParams, feature);
			}
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
    //?
//     function SelelctDept_complite(deptid){
//    		if (deptid != "") {
//             bSearch = true;
//             g_xmlHTTP = createXMLHttpRequest();
//             var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
//             g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
//             g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
//             g_xmlHTTP.send(strQuery);
//         }
//    }
    
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
            } else {
                alert(g_xmlHTTP.statusText)
                g_xmlHTTP = null;
            }
        }
    }

    //사원으로 검색시
    function searchuser() {
        if (keyword.value == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            keyword.focus();
            return;
        }
        
        $.ajax({
        	type : "POST",
        	dataType : "text",
        	url : "/ezOrgan/getSearchList.do",
        	async : true,
        	data : {search : "displayname::" + keyword.value, cell : "displayName;description", prop : "", type : "user"},
        	success : function(result){	
        		var xmlDom = loadXMLString(result);
        		if (xmlDom.getElementsByTagName("ROW").length == 0)
                    alert("<spring:message code='ezStatistics.t1016' />");
                else {
                    var retXml = createXmlDom();

                    if (document.getElementById("UserList").innerHTML != "")
                        document.getElementById("UserList").innerHTML = "";

                    var headerData = createXmlDom();
                    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                    if (result != "") {
                        if (CrossYN()) {
                            var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                            var Node = headerData.importNode(xmlRtn, true);
                            headerData.documentElement.appendChild(Node);
                        }
                        else {
                            var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
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
//     function event_displayUserList2() {
//         if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
//             if (g_xmlHTTP.statusText == "OK") {
//                 if (g_xmlHTTP.responseXML.getElementsByTagName("ROW").length == 0)
//                     alert("<spring:message code='ezStatistics.t1016' />");
//                 else {
//                     var retXml = createXmlDom();

//                     if (document.getElementById("UserList").innerHTML != "")
//                         document.getElementById("UserList").innerHTML = "";

//                     var headerData = createXmlDom();
//                     headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
//                     if (g_xmlHTTP.responseText != "") {
//                         if (CrossYN()) {
//                             var xmlRtn = g_xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
//                             var Node = headerData.importNode(xmlRtn, true);
//                             headerData.documentElement.appendChild(Node);
//                         }
//                         else {
//                             var xmlRtn = g_xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
//                             headerData.documentElement.appendChild(xmlRtn);
//                         }
//                     }
//                     var pUserList = new ListView();
//                     pUserList.SetID("lvUserList");
//                     pUserList.SetRowOnClick("getmailstatistics");
//                     pUserList.SetSelectFlag(false);
//                     pUserList.SetHeightFree(true);
//                     pUserList.DataSource(headerData);
//                     pUserList.DataBind("UserList");
//                 }
//             }
//             else
//                 alert(g_xmlHTTP.statusText)

//             g_xmlHTTP = null;
//         }
//     }

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
	<h1><spring:message code='ezStatistics.t1018' /></h1>
	<table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
        <tr>
            <td style="width: 99%">
                <span id="topmenu" style="width: 500px">
<!--                  	회사선택 :  -->
<!-- 				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-top:4px; padding-right:40px;"> -->
<%-- 					<c:forEach var = "companyItem" items="${companyList }"> --%>
<%-- 						<option value="<c:out value = '${companyItem.cn }' />"><c:out value = '${companyItem.displayName }'/></option> --%>
<%-- 					</c:forEach> --%>
<!-- 	      		</select> -->
<!--                  &nbsp;&nbsp; -->
                <spring:message code='ezStatistics.t1002' /> : 
                <select id="selyear" onchange="makeoptionyear(); getmailstatistics()"></select>
                    <spring:message code='ezStatistics.t55' />
		            &nbsp;&nbsp;
					<select id="searchopt">
		            	<option value="1"><spring:message code='ezStatistics.t1017' /></option>
		            	<option value="2"><spring:message code='ezStatistics.t113' /></option>
					</select>
                    <input id="keyword" type="text" style="width: 100px" onkeypress="search_press(event)" />
                    <a class="imgbtn" style="vertical-align: middle"><span onclick="search()"><spring:message code='ezStatistics.t36' /></span></a>
                    &nbsp;&nbsp;
                    	근태유형 : 
	                <select name="attitudeType" id="attitudeType" style="margin-top:4px; padding-right:40px;">
<%-- 						<c:forEach var = "typeItem" items="${typeList }"> --%>
<%-- 							<option value="<c:out value = '${typeItem.typeId }' />"><c:out value = '${typeItem.typeName }'/></option> --%>
<%-- 						</c:forEach> --%>
		      		</select>
                </span>
            </td>
            <td>
                <div id="mainmenu" style="height: 28px;">
                    <ul>
                        <li><span style="width: 110px;text-align:center" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003' /></span></li>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <br />
    <h2 id="ToTitle" class="receiver_tltype01" style="border: 0px">
        <span style="min-width: 45px;"><spring:message code='ezStatistics.t1014' /></span>
    </h2>
    <table style="width: 1150px;height:640px ;border:1px solid #ddd"> 
        <tr>
            <td style="vertical-align:top">
                <div style="width: 310px; height: 310px; overflow-x: auto; overflow-y: auto; border-right: 1px solid #ddd;" id="TreeView"></div>
                <div id="UserList" style="Width: 310px; Height: 330px; overflow: auto; border-right: 1px solid #ddd"></div>
            </td>
            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
                <div id="viewdata" style="display:none">
                    <div class="statistics_addition">
                        <dl>
                            <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
                            <dd id="colorbox" class="additiontext"><spring:message code='ezStatistics.t38' /></dd>
                        </dl>
                        <dl>
                            <dt class="colorbox_wrap"><span style="background: #eaa229" class="colorbox"></span></dt>
                            <dd id="colorbox2" class="additiontext"><spring:message code='ezStatistics.t40' /></dd>
                        </dl>
                    </div>
                    <div id="chartdiv" style="width: 100%; text-align: center; display: none;">
                        <div id="statisticschart" style="width: 800px; height: 480px; float: left; font-size: 16px;">
                        </div>
                    </div>
                    <div id="statisticstable"></div>
                </div>
                <div id="seluser" class="statistics_select" style="margin:0 auto">
                    <dl class="statistics_txt">
                        <dt><spring:message code='ezStatistics.t1019' /></dt>
                        <dd><spring:message code='ezStatistics.t1020' /><br>
                            <spring:message code='ezStatistics.t1021' /></dd>
                    </dl>
                </div>
                <div id="nodata" class="statistics_nodata" style="display: none;margin:0 auto">
                    <dl class="statistics_txt">
                        <dt><spring:message code='ezStatistics.t1008' /></dt>
                        <dd><spring:message code='ezStatistics.t1009' /></dd>
                    </dl>
                </div>
            </td>
        </tr>
    </table>
    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXlsM.do">
        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
        <input type="hidden" id="userAgent" name="userAgent" value="">
    </form>
    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
<script type="text/javascript">
    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
</script>
</html>