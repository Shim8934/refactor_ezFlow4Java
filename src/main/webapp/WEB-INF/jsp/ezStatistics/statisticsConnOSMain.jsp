<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title><spring:message code='ezStatistics.t1001'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />"" type="text/css" />
    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
    <link rel="stylesheet" href="/js/ezStatistics/js/jquery.jqplot.min.css" type="text/css">
  	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
    <link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
    <link rel="stylesheet" href="/css/ezStatistics/demo.css" type="text/css" media="screen" charset="utf-8">
	<link rel="stylesheet" href="/css/ezStatistics/demo-print.css" type="text/css" media="print" charset="utf-8">
    <style type="text/css">
        .jqplot-table-legend {
        white-space:nowrap
        }
    </style>
    <script type="text/javascript" src="<spring:message code='ezStatistics.e1' />"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/jquery.min.js"></script>
    <script type="text/javascript" src="/js/ezStatistics/js/raphael-min.js"></script>
    <script src="/js/ezStatistics/js/g.raphael.js" type="text/javascript" charset="utf-8"></script>
    <script src="/js/ezStatistics/js/g.pie.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
    <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
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

            getpersonalstatistics();
        }

        $(function () {
            $("#Sdatepicker").datepicker({
                changeMonth: true,
                changeYear: true,
                autoSize: true,
                showOn: "both",
                buttonImage: "/images/ImgIcon/calendar-month.gif",
                buttonImageOnly: true
            });
            $("#Sdatepicker2").datepicker({
                changeMonth: true,
                changeYear: true,
                autoSize: true,
                showOn: "both",
                buttonImage: "/images/ImgIcon/calendar-month.gif",
                buttonImageOnly: true
            });
            var NowDate = new Date();
            var NowDate2 = new Date();
            NowDate2.setDate(NowDate2.getDate() - 10);
            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
            $("#Sdatepicker").datepicker('setDate', NowDate2);
            $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
            $("#Sdatepicker2").datepicker('setDate', NowDate);
        });
    if("${userInfo.lang}"=="1"){
        $(function () {
            $.datepicker.regional['ko'] = {
                closeText: '닫기',
                prevText: '이전달',
                nextText: '다음달',
                currentText: '오늘',
                monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
                '7월', '8월', '9월', '10월', '11월', '12월'],
                monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
                '7월', '8월', '9월', '10월', '11월', '12월'],
                dayNames: ['일', '월', '화', '수', '목', '금', '토'],
                dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
                dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
                weekHeader: 'Wk',
                dateFormat: 'yy-mm-dd',
                firstDay: 0,
                isRTL: false,
                duration: 200,
                showAnim: 'show',
                showMonthAfterYear: true
            };
            $.datepicker.setDefaults($.datepicker.regional['ko']);
        });
    }else {
        $(function () {
            $.datepicker.regional['en'] = {
                dateFormat: 'yy-mm-dd',
                firstDay: 0,
                isRTL: false,
                duration: 200,
                showAnim: 'show',
                showMonthAfterYear: true
            };
            $.datepicker.setDefaults($.datepicker.regional['en']);
        });
        }

        function getpersonalstatistics() {
            xmlHttp = createXMLHttpRequest();
            var xmlDoc = createXmlDom();

            var objRoot, objNode
            objNode = createNodeInsert(xmlDoc, objNode, "PARAM");
            createNodeAndInsertText(xmlDoc, objNode, "SDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            createNodeAndInsertText(xmlDoc, objNode, "EDATE", $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            createNodeAndInsertText(xmlDoc, objNode, "COMPANY", $("#SCompID").val());
            xmlHttp.open("POST", "/ezStatistics/getStatConnOS.do", true);
            xmlHttp.onreadystatechange = event_getpersonalstatistics;
            xmlHttp.send(xmlDoc);
        }

        var rowcnt;
        function event_getpersonalstatistics() {
        	 var view_flag = false;
        	
            if (xmlHttp != null && xmlHttp.readyState == 4) {
                document.getElementById("statisticstable").innerHTML = "";
                document.getElementById("statisticstable2").innerHTML = "";
                var resultxml = loadXMLString(xmlHttp.responseText);
                rowcnt = SelectNodes(resultxml, "DATA/ROW").length;
                
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

                var _TH = document.createElement("TH");
                var _TH2 = document.createElement("TH");
                var _TH3 = document.createElement("TH");

                _TH = document.createElement("TH");
                _TH.style.whiteSpace = "normal";
                _TH.style.wordBreak = "break-all";
                _TH.innerHTML = "<spring:message code='ezStatistics.t1042'/>";
                _Tr.appendChild(_TH);

                _TH2 = document.createElement("TH");
                _TH2.style.whiteSpace = "normal";
                _TH2.style.wordBreak = "break-all";
                _TH2.innerHTML = "<spring:message code='ezStatistics.t1043'/>";
                _Tr.appendChild(_TH2);

                _TH3 = document.createElement("TH");
                _TH3.style.whiteSpace = "normal";
                _TH3.style.wordBreak = "break-all";
                _TH3.innerHTML = "<spring:message code='ezStatistics.t1044'/>";
                _Tr.appendChild(_TH3);

                _Table.appendChild(_Tr);

                var _Table2 = document.createElement("TABLE");
                _Table2.style.textAlign = "center";
                _Table2.style.width = "100%";
                _Table2.className = "tstyle2";
                _Table2.style.border = "1px solid #dadada"

                var _Tr3 = document.createElement("TR");

                var _TH5 = document.createElement("TH");
                var _TH6 = document.createElement("TH");
                var _TH7 = document.createElement("TH");

                _TH5 = document.createElement("TH");
                _TH5.style.whiteSpace = "normal";
                _TH5.style.wordBreak = "break-all";
                _TH5.innerHTML = "<spring:message code='ezStatistics.t1042'/>";
                _Tr3.appendChild(_TH5);

                _TH6 = document.createElement("TH");
                _TH6.style.whiteSpace = "normal";
                _TH6.style.wordBreak = "break-all";
                _TH6.innerHTML = "<spring:message code='ezStatistics.t1043'/>";
                _Tr3.appendChild(_TH6);

                _TH7 = document.createElement("TH");
                _TH7.style.whiteSpace = "normal";
                _TH7.style.wordBreak = "break-all";
                _TH7.innerHTML = "<spring:message code='ezStatistics.t1044'/>";
                _Tr3.appendChild(_TH7);

                _Table2.appendChild(_Tr3);

                if (rowcnt > 0)
                    total = parseInt(getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[0], "TOTAL")).trim());
                for (var i = 0; i < rowcnt; i++) {
                    var _Tr2 = document.createElement("TR");
                    var _TD = document.createElement("TD");
                    var _TD2 = document.createElement("TD");
                    var _TD3 = document.createElement("TD");

                    _TD.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "CONNECTOS")).trim();
                    _TD2.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "CONNECTCNT")).trim();
                    _TD3.innerHTML = parseFloat(parseInt(getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "CONNECTCNT")).trim()) / total * 100).toFixed(2) + "%";

                    if (getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "TYPE")) == "OS") {
                        _Tr2.id = "TR" + i;
                        _Tr2.appendChild(_TD);
                        _Tr2.appendChild(_TD2);
                        _Tr2.appendChild(_TD3);
                        _Table.appendChild(_Tr2);
                    }
                    else {
                        if (parseInt(getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "CONNECTCNT"))) == 0) {
                            _Tr2.style.display = "none";
                        }else{
                        	view_flag=true;
                        }
                        _Tr2.id = "TROS" + i;
                        _Tr2.appendChild(_TD);
                        _Tr2.appendChild(_TD2);
                        _Tr2.appendChild(_TD3);
                        _Table2.appendChild(_Tr2);
                    }
                }
                if(!view_flag){
                	document.getElementById("nodata").style.display = "";
                    document.getElementById("viewdata").style.display = "none";
                    return;
                }
                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                document.getElementById("statisticstable2").innerHTML = _Table2.outerHTML;
                drawingchart();
            }
        }

        function drawingchart() {
            document.getElementById("statisticschart").innerHTML = "";
            document.getElementById("statisticschart2").innerHTML = "";

            var data = new Array();
            var data2 = new Array();
            var data3 = new Array();
            var data4 = new Array();
            for (var i = 0; i < rowcnt; i++) {
                if (i < rowcnt - 2) {
                    data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("TR" + i))[1])));
                    data2.push(getnodetext(GetChildNodes(document.getElementById("TR" + i))[0]) + " - %%.%%");
                }
                else {
                    if (parseInt(getnodetext(GetChildNodes(document.getElementById("TROS" + i))[1])) > 0) {
                        data3.push(parseInt(getnodetext(GetChildNodes(document.getElementById("TROS" + i))[1])));
                        data4.push(getnodetext(GetChildNodes(document.getElementById("TROS" + i))[0]) + " - %%.%%");
                    }
                }
            }

            var r = Raphael("statisticschart"),
                   pie = r.piechart(320, 180, 150, data, { legend: data2, legendpos: "east" });
            pie.hover(function () {
                this.sector.stop();
                if (this.sector.matrix.a < 1.05)
                    this.sector.scale(1.1, 1.1, this.cx, this.cy);

                if (this.label) {
                    this.label[0].stop();
                    this.label[0].attr({ r: 7.5 });
                    this.label[1].attr({ "font-weight": 800 });
                }
            }, function () {
                this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");

                if (this.label) {
                    this.label[0].animate({ r: 5 }, 500, "bounce");
                    this.label[1].attr({ "font-weight": 400 });
                }
            });

            var r = Raphael("statisticschart2"),
                   pie = r.piechart(320, 180, 150, data3, { legend: data4, legendpos: "east" });
            pie.hover(function () {
                this.sector.stop();
                if (this.sector.matrix.a < 1.05)
                    this.sector.scale(1.1, 1.1, this.cx, this.cy);

                if (this.label) {
                    this.label[0].stop();
                    this.label[0].attr({ r: 7.5 });
                    this.label[1].attr({ "font-weight": 800 });
                }
            }, function () {
                this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");

                if (this.label) {
                    this.label[0].animate({ r: 5 }, 500, "bounce");
                    this.label[1].attr({ "font-weight": 400 });
                }
            });
        }

        function getnodetext(obj) {
            if (CrossYN())
                return obj.textContent;
            else
                if (obj.text == undefined)
                    return obj.innerText;
                else
                    return obj.text;
        }

        function btnexportexcel_onclick() {
            document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML + "<BR />" + document.getElementById("statisticstable2").innerHTML;
            document.getElementById("formAgent").target = "saveExcel";
            document.getElementById("formAgent").submit();
        }

    </script>
</head>
<body class="mainbody" style="text-align:left">
    <h1><spring:message code='ezStatistics.t1048'/></h1>
    <table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2; margin-bottom: 5px">
        <tr>
            <td style="width: 99%">
            <span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t195'/> :
            <select id="SCompID" name="SCompID" onchange="return getpersonalstatistics()">${companySel}</select>
                <span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1002'/> : 
        <input type="text" id="Sdatepicker" style="width: 80px; text-align: center" onchange="getpersonalstatistics()" readonly="readonly">
                    ~ 
        <input type="text" id="Sdatepicker2" style="width: 80px; text-align: center" onchange="getpersonalstatistics()" readonly="readonly">
                </span>
            </td>
            <td>
                <div id="mainmenu" style="height: 28px; width: 110px">
                    <ul>
                        <li><span onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <div id="viewdata" style="width:800px">
        <table>
            <tr>
                <td>
                    <div id="statisticschart" style="width: 700px; height: 370px; float: left; font-size: 16px">
                    </div>
                    <div id="statisticstable" style="width: 680px;height:300px;padding-left:10px">
                    </div>
                </td>
                <td>
                    <div id="statisticschart2" style="width: 700px; height: 370px; float: right; font-size: 16px">
                    </div>
                    <div id="statisticstable2" style="width: 680px;height:300px;padding-left:13px">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div id="nodata" style="display: none; margin-top: 150px; text-align: center">
        <div class="statistics_nodata" style="margin: 0 auto">
            <dl class="statistics_txt">
                <dt><spring:message code='ezStatistics.t1008'/></dt>
                <dd><spring:message code='ezStatistics.t1009'/></dd>
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
</script>
</html>
