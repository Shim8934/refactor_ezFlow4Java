<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t1001' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
    <link rel="stylesheet" href="/js/ezStatistics/js/jquery.jqplot.min.css" type="text/css">
    <style type="text/css">
        .jqplot-table-legend {
        white-space:nowrap
        }
    </style>    
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
            getmailstatistics();
        };

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

        function Tab1_NewTabIni(pTabNodeID) {
            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
                if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
                    if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;

                        if (Tab1_flag) {
                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
                            Tab1_flag = false;
                        }

                    }
                }
            }
        }

        function Tab1_MouserOver(obj) {
            obj.className = "tabover";
        }
        function Tab1_MouserOut(obj) {
            if (Tab1_SelectID != obj.id)
                obj.className = "";
        }
        function Tab1_MouseClick(obj) {
            obj.className = "tabon";
            if (obj.id != Tab1_SelectID) {
                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
                    document.getElementById(Tab1_SelectID).className = "";

                obj.className = "tabon";
                Tab1_SelectID = obj.id;
                ChangeTab(obj);
            }
        }

        var tabledata = new Array("<spring:message code='ezStatistics.t38' />", "<spring:message code='ezStatistics.t40' />", "RECEIVEINCNT", "SENDINCNT");
        function ChangeTab(obj) {
            var pSelectTab = obj.getAttribute("divname");
            tabledata = new Array();
            switch (pSelectTab) {
                case "passTab": tabledata.push("<spring:message code='ezStatistics.t38' />", "<spring:message code='ezStatistics.t40' />", "RECEIVEINCNT", "SENDINCNT"); getmailstatistics(); break;
                case "bujaeTab": tabledata.push("<spring:message code='ezStatistics.t39' />", "<spring:message code='ezStatistics.t41' />", "RECEIVEOUTCNT", "SENDOUTCNT"); getmailstatistics(); break;
                case "bujaeGTab": tabledata.push("<spring:message code='ezStatistics.t42' />", "<spring:message code='ezStatistics.t44' />", "RECEIVEINSIZE", "SENDINSIZE"); getmailstatistics(); break;
                case "noticeTab": tabledata.push("<spring:message code='ezStatistics.t43' />", "<spring:message code='ezStatistics.t45' />", "RECEIVEOUTSIZE", "SENDOUTSIZE"); getmailstatistics(); break;
            }
        }

        function getmailstatistics() {
            xmlHttp = createXMLHttpRequest();
            var xmlDoc = createXmlDom();

            var objRoot, objNode
            objNode = createNodeInsert(xmlDoc, objNode, "PARAM");
            createNodeAndInsertText(xmlDoc, objNode, "COMPANY", document.getElementById("SCompID").value);
            createNodeAndInsertText(xmlDoc, objNode, "SDATE", document.getElementById("selyear").value);
            createNodeAndInsertText(xmlDoc, objNode, "EDATE", document.getElementById("selyear").value);
            xmlHttp.open("POST", "/ezStatistics/getMailMain.do", true);
            xmlHttp.onreadystatechange = event_getmailstatistics;
            xmlHttp.send(xmlDoc);
        }

        function event_getmailstatistics() {
            if (xmlHttp != null && xmlHttp.readyState == 4) {
                document.getElementById("statisticstable").innerHTML = "";
                var data = new Array();
                var data2 = new Array();
                var resultxml = loadXMLString(xmlHttp.responseText);

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
                _Th.innerHTML = "<spring:message code='ezStatistics.t88' />";
                _Tr.appendChild(_Th);

                _Th = document.createElement("TH");
                _Th.style.textAlign = "center";
                _Th.style.width = "130px";
                _Th.innerHTML = "<spring:message code='ezStatistics.t1000' />";

                var nowyear = new Date().getYear();
                var moncnt = 12;
            
                _Tr.appendChild(_Th);
                var ticks = "<spring:message code='ezStatistics.t218' />".split(";");
                for (var i = 0; i < moncnt; i++) {
                    var _Th2 = document.createElement("TH");
                    _Th2.style.textAlign = "center";
                    _Th2.innerHTML = ticks[i];
                    _Tr.appendChild(_Th2);
                }
                _Table.appendChild(_Tr);

                var _Tr2 = document.createElement("TR");
                var _Tr3 = document.createElement("TR");
                
                var _Td = document.createElement("TD");
                _Td.rowSpan = "2";

                if(CrossYN())
                    _Td.innerHTML = GetChildNodes(document.getElementById("SCompID"))[document.getElementById("SCompID").selectedIndex].textContent;
                else
                    _Td.innerHTML = GetChildNodes(document.getElementById("SCompID"))[document.getElementById("SCompID").selectedIndex].innerText;

                _Tr2.appendChild(_Td);

                _Td = document.createElement("TD");
                _Td.innerHTML = tabledata[0];

                var _Td2 = document.createElement("TD");
                _Td2.innerHTML = tabledata[1];

                _Tr2.appendChild(_Td);
                _Tr3.appendChild(_Td2);

                var j = 0;
                for (var i = 0; i < moncnt; i++) {
                    var _Td = document.createElement("TD");
                    var _Td2 = document.createElement("TD");

                    var mon = parseInt(i + 1);
                    if (mon < 10)
                        mon = "0" + mon;

                    var date = start + mon;

                    var yyyymm;

                    if (SelectNodes(resultxml, "DATA/ROW").length > j) {
                        if (CrossYN())
                            yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").textContent;
                        else
                            yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").text;
                    }

                    if (date == yyyymm) {
                        var maildata;
                        if (CrossYN())
                            maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[2]).textContent;
                        else
                            maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[2]).text;

                        if (maildata != "") {
                            if (tabledata[2] == "RECEIVEINSIZE" || tabledata[2] == "RECEIVEOUTSIZE") {
                                _Td.innerHTML = getmailsize(maildata);
                                data.push(parseInt(maildata) / 1024 / 1024);
                            }
                            else {
                                _Td.innerHTML = maildata;
                                data.push(parseInt(maildata));
                            }
                        }
                        else {
                            _Td.innerHTML = "0";
                            data.push(0);
                        }

                        if (CrossYN())
                            maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[3]).textContent;
                        else
                            maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[3]).text;

                        if (maildata != "") {
                            if (tabledata[2] == "RECEIVEINSIZE" || tabledata[2] == "RECEIVEOUTSIZE") {
                                _Td2.innerHTML = getmailsize(maildata);
                                data2.push(parseInt(maildata) / 1024 / 1024);
                            }
                            else {
                                _Td2.innerHTML = maildata;
                                data2.push(parseInt(maildata));
                            }
                        }
                        else {
                            _Td2.innerHTML = "0";
                            data2.push(0);
                        }

                        j++;
                    }
                    else {
                        data.push(0);
                        data2.push(0);
                        _Td.innerHTML = "0";
                        _Td2.innerHTML = "0";
                    }
                    _Tr2.appendChild(_Td);
                    _Tr3.appendChild(_Td2);
                }
                _Table.appendChild(_Tr);
                _Table.appendChild(_Tr2);
                _Table.appendChild(_Tr3);

                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                document.getElementById("statisticschart").innerHTML = "";
                if (CrossYN()) {
                    document.getElementById("colorbox").textContent = tabledata[0];
                    document.getElementById("colorbox2").textContent = tabledata[1];
                }
                else {
                    document.getElementById("colorbox").innerText = tabledata[0];
                    document.getElementById("colorbox2").innerText = tabledata[1];
                }

                var ticks = "<spring:message code='ezStatistics.t218' />".split(";");

                plot2 = $.jqplot('statisticschart', [data, data2], {
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

        function btnexportexcel_onclick() {
            document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
            document.getElementById("formAgent").target = "saveExcel";
            document.getElementById("formAgent").submit();
        }

    </script>
</head>
<body class="mainbody">
    <h1><spring:message code='ezStatistics.t1001' /></h1>
    <table style="width:100%;background-color: #e9e9e9;border:1px solid #d3d2d2;margin-bottom:5px">
        <tr>
            <td style="width: 99%">
                <span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t195' /> :
        <select id="SCompID" name="SCompID" onchange="return getmailstatistics()">${listCompany}</select>
                    &nbsp;&nbsp;&nbsp;<spring:message code='ezStatistics.t1002' /> : 
            <select id="selyear" onchange="makeoptionyear(); getmailstatistics()"></select>
                    <spring:message code='ezStatistics.t55' /></span>
            </td>
            <td>
                <div id="mainmenu" style="height: 28px; width: 100px"> 
                    <ul style="display:none;">
                        <li><span onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003' /></span></li>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <div class="portlet_tabpart01" style="margin-top: 3px;float:left">
        <div class="portlet_tabpart01_top" id="tab1">
            <p><span id="1tab1" divname="passTab"><spring:message code='ezStatistics.t1004' /></span></p>
            <p><span id="1tab2" divname="bujaeTab"><spring:message code='ezStatistics.t1005' /></span></p>
            <p><span id="1tab3" divname="bujaeGTab"><spring:message code='ezStatistics.t1006' /></span></p>
            <p><span id="1tab4" divname="noticeTab"><spring:message code='ezStatistics.t1007' /></span></p>
        </div>
    </div>
    <br />
    <br />
    <div id="viewdata" style="width:800px">
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
        <div id="statisticschart" style="width: 800px; height: 500px; float: left; font-size: 16px">
        </div>
        <br />
        <br />
        <br />
    </div>
    <div id="statisticstable" class="plot jqplot-target">
    </div>
    <div id="nodata" style="display: none; margin-top: 150px; text-align: center">
        <div class="statistics_nodata" style="margin: 0 auto">
            <dl class="statistics_txt">
                <dt><spring:message code='ezStatistics.t1008' /></dt>
                <dd><spring:message code='ezStatistics.t1009' /></dd>
            </dl>
        </div>
    </div>
    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/myoffice/ezStatistics/excelExportOut.aspx">
        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
        <input type="hidden" id="userAgent" name="userAgent" value="">
    </form>
    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
<script type="text/javascript">
    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
    Tab1_NewTabIni("tab1");
</script>
</html>