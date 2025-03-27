<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezStatistics.t1047'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
  	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" media="screen" charset="utf-8">
    <style type="text/css">
        .jqplot-table-legend {
        white-space:nowrap
        }
    </style>
    <script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/excanvas.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.barRenderer.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>    
    <script type="text/javascript">
        var Tab1_flag = true;
        var xmlHttp = createXMLHttpRequest();
		
		document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
		};
		
        $(function () {
            $("#Sdatepicker").datepicker({
                changeMonth: true,
                changeYear: true,
                autoSize: true,
                showOn: "both",
                buttonImage: "/images/ImgIcon/calendar-month.png",
                buttonImageOnly: true
            });
            $("#Sdatepicker2").datepicker({
                changeMonth: true,
                changeYear: true,
                autoSize: true,
                showOn: "both",
                buttonImage: "/images/ImgIcon/calendar-month.png",
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
        $(function () {
        	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
        		closeText: "<spring:message code='main.t3' />",
 		        prevText: "<spring:message code='main.t0604' />",
 		        nextText: "<spring:message code='main.t0605' />",
 		        currentText: "<spring:message code='main.t0606' />",
 		        monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
 		                     "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
 		                     "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
 		                     "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
 		        monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
 		                          "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
 		                          "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
 		                          "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
 		        dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
 		                   "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
 		                   "<spring:message code='main.t0627' />"],
 		        dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
 				                   "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
 				                   "<spring:message code='main.t0627' />"],
 		        dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
 			                   "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
 			                   "<spring:message code='main.t0627' />"],
 		        weekHeader: "Wk",
 		        dateFormat: "yy-mm-dd",
 		        firstDay: 0,
 		        isRTL: false,
 		        duration: 200,
 		        showAnim: "show",
 		        showMonthAfterYear: true
            };
        	$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
        });

        window.onload = function () {
            if (CrossYN())
                document.getElementById("topmenu").style.cssFloat = "";
            else
                document.getElementById("topmenu").style.whiteSpace = "nowrap";

            getpersonalstatistics();
        }

        function getpersonalstatistics(mode) {
        	/* #14421 - 천성준 (시작일이 종료일이 느린경우, 종료일이 시작일보다 빠른경우) 두날짜를 맞추는 로직 추가 */
        	var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
        	var eDate = $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val();
        	if (sDate > eDate) {
        		if (typeof(mode) != "undefined" && mode != null) {
	        		if (mode == "sDate") {$("#Sdatepicker2").val($("#Sdatepicker").val());}
	        		if (mode == "eDate") {$("#Sdatepicker").val($("#Sdatepicker2").val());}
        		}
        	}
        	
            xmlHttp = createXMLHttpRequest();
            var xmlDoc = createXmlDom();

            var objRoot, objNode
            objNode = createNodeInsert(xmlDoc, objNode, "PARAM");
            createNodeAndInsertText(xmlDoc, objNode, "SDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            createNodeAndInsertText(xmlDoc, objNode, "EDATE", $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val());
            createNodeAndInsertText(xmlDoc, objNode, "COMPANY", $("#SCompID").val());
            xmlHttp.open("POST", "/ezStatistics/getPersonalMain.do", true);
            xmlHttp.onreadystatechange = event_getpersonalstatistics;
            xmlHttp.send(xmlDoc);
       }

        function event_getpersonalstatistics() {
            if (xmlHttp != null && xmlHttp.readyState == 4) {
                document.getElementById("statisticstable").innerHTML = "";
                var resultxml = loadXMLString(xmlHttp.responseText);

                if (SelectNodes(resultxml, "DATA/ROW").length == 0) {
                    document.getElementById("nodata").style.display = "";
                    document.getElementById("viewdata").style.display = "none";
                    return;
                }else{
                	document.getElementById("nodata").style.display = "none";
                    document.getElementById("viewdata").style.display = "";               
                }
                	
                var _Table = document.createElement("TABLE");
                _Table.style.textAlign = "center";
                _Table.style.width = "800px";
                _Table.className = "tstyle2";
                _Table.style.border = "1px solid #dadada"

                var _Tr = document.createElement("TR");

                var _TH = document.createElement("TH");
                var _TH2 = document.createElement("TH");
                var _TH3 = document.createElement("TH");
                var _TH4 = document.createElement("TH");

                _TH = document.createElement("TH");
                _TH.style.whiteSpace = "normal";
                _TH.style.wordBreak = "break-all";
                _TH.innerHTML = "<spring:message code='ezStatistics.t214'/>";
                _Tr.appendChild(_TH);

                _TH2 = document.createElement("TH");
                _TH2.style.whiteSpace = "normal";
                _TH2.style.wordBreak = "break-all";
                _TH2.innerHTML = "<spring:message code='ezStatistics.t1043'/>";
                _Tr.appendChild(_TH2);

                _TH3 = document.createElement("TH");
                _TH3.style.whiteSpace = "normal";
                _TH3.style.wordBreak = "break-all";
                _TH3.innerHTML = "<spring:message code='ezStatistics.t1046'/>";
                _Tr.appendChild(_TH3);

                _TH4 = document.createElement("TH");
                _TH4.style.whiteSpace = "normal";
                _TH4.style.wordBreak = "break-all";
                _TH4.innerHTML = "<spring:message code='ezStatistics.t1044'/>";
                _Tr.appendChild(_TH4);

                _Table.appendChild(_Tr);

                var j = 0;
                for (var i = 0; i < 24; i++) {
                    var _Tr2 = document.createElement("TR");
                    _Tr2.id = "TR" + i;
                    var _TD = document.createElement("TD");
                    var _TD2 = document.createElement("TD");
                    var _TD3 = document.createElement("TD");
                    var _TD4 = document.createElement("TD");

                    var date;
                    var date2;
                    if (i < 10) {
                        date = "0" + i;
                    }
                    else {
                        date = i;
                    }
                    if (i < 9) {
                        date2 = "0" + (i + 1);
                    }
                    else {
                        date2 = i + 1;
                    }
                    _TD.innerHTML = date + ":00 ~ " + date2 + ":00";

                    if (j < SelectNodes(resultxml, "DATA/ROW").length && getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DATE")).trim() == date) {
                        var tempdata = 0;
                        var tempdata2 = 0;
                        if (getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DAY")) == "DAY") {
                            tempdata = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "CONNECTCNT"));
                            tempdata2 = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "TOTAL"));
                            _TD2.innerHTML = tempdata;
                            j++;
                        }
                        else{
                            _TD2.innerHTML = "0";
                        }

                        if (getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DAY")) == "TOTAL") {
                            _TD3.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "CONNECTCNT"));
                            j++;
                        }
                        if(tempdata == "0")
                            _TD4.innerHTML = "0%";
                        else
                            _TD4.innerHTML = parseFloat(parseInt(tempdata) / parseInt(tempdata2) * 100).toFixed(2) + "%";
                    }
                    else {
                        _TD2.innerHTML = "0";
                        _TD3.innerHTML = "0";
                        _TD4.innerHTML = "0%";
                    }
                    _Tr2.appendChild(_TD);
                    _Tr2.appendChild(_TD2);
                    _Tr2.appendChild(_TD3);
                    _Tr2.appendChild(_TD4);
                    _Table.appendChild(_Tr2);
                }
                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                drawingchart();
            }
        }

        function drawingchart(type) {
            document.getElementById("statisticschart").innerHTML = "";

            var line1 = new Array();
            var line2 = new Array();

            for (var i = 0; i < 10 ; i++) {
            	line1.push(new Array((i + '<br/>≀<br/>' + (i+1)), parseInt(getnodetext(GetChildNodes(document.getElementById("TR" + i))[1]))));
	            line2.push(new Array((i + '<br/>≀<br/>' + (i+1)), parseInt(getnodetext(GetChildNodes(document.getElementById("TR" + i))[2]))));
            }

            for (var i = 10; i < 24 ; i++) {
            	line1.push(new Array((i + '<br/> ≀<br/>' + (i+1)), parseInt(getnodetext(GetChildNodes(document.getElementById("TR" + i))[1]))));
	            line2.push(new Array((i + '<br/> ≀<br/>' + (i+1)), parseInt(getnodetext(GetChildNodes(document.getElementById("TR" + i))[2]))));
            }


            plot2 = $.jqplot('statisticschart', [line1, line2], {
                animate: false,
                series: [{
                    renderer: $.jqplot.BarRenderer
                },
                { xaxis: 'x2axis', yaxis: 'y2axis' }],
                axesDefaults: {
                    tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                    tickOptions: {
                        angle: 50
                    }
                },
                axes: {
                    xaxis: {
                        renderer: $.jqplot.CategoryAxisRenderer
                    },
                    x2axis: {
                        renderer: $.jqplot.CategoryAxisRenderer,
                        axesDefaults: {
                            show : false
                        }
                    },
                    yaxis: {
                        autoscale: true
                    },
                    y2axis: {
                        autoscale: true
                    }
                }
            });
        }

        function btnexportexcel_onclick() {
            document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
            document.getElementById("formAgent").target = "saveExcel";
            document.getElementById("formAgent").submit();
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

        function callyearlydoccount() {

            $.ajax({
                type : "POST",
                dataType : "text",
                async : true,
                url : "/ezStatistics/callYearlyDocCount.do",
                data : {
                    search : ""
                },
                success: function(text) {
                    console.log(text);
                },
                error: function() {
                    console.log('error');
                }
            });
        }
    </script>
</head>
<h1><spring:message code='ezStatistics.t1047'/></h1>
<body class="mainbody">
    <table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
        <tr>
            <td style="width: 99%">
            <span id="topmenu" style="width: 500px">&nbsp;<spring:message code='ezStatistics.t195'/> :
            <select style="height:24px" id="SCompID" name="SCompID" onchange="return getpersonalstatistics()">
           		<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
            </select>&nbsp;
            <span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1002'/> : 
            <input type="text" id="Sdatepicker" style="width: 80px; text-align: center" onchange="getpersonalstatistics('sDate')" readonly="readonly">
                    ~ 
            <input type="text" id="Sdatepicker2" style="width: 80px; text-align: center" onchange="getpersonalstatistics('eDate')" readonly="readonly">
                </span>
            </td>
            <td style="display: none;">
                <button onclick="callyearlydoccount()">callYearlyDocCount</button>
            </td>
            <td>
                <div id="mainmenu" style="height: 31px;margin:3px 0px !important">
                    <ul>
                        <li><span style="width: 110px;text-align:center;background-color: white" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <div id="viewdata" style="width:800px">
        <div class="statistics_addition">
            <dl>
                <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
                <dd id="colorbox" class="additiontext"><spring:message code='ezStatistics.t1043'/></dd>
            </dl>
            <dl>
                <dt class="colorbox_wrap"><span style="background: #eaa229" class="colorbox"></span></dt>
                <dd id="colorbox2" class="additiontext"><spring:message code='ezStatistics.t1046'/></dd>
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
                <dt><spring:message code='ezStatistics.t1008'/></dt>
                <dd><spring:message code='ezStatistics.t1009'/></dd>
            </dl>
        </div>
    </div>
    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXls.do">
        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
        <input type="hidden" id="userAgent" name="userAgent" value="">
    </form>
    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
<script type="text/javascript">
    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
</script>
</html>
