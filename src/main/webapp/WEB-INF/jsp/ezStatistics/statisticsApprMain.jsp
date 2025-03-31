<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code='ezStatistics.t1030'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.tstyle2 td {padding:4px 0px; text-overflow:none}
		</style>
		<script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/composeappt.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/datepicker.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/excanvas.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.barRenderer.min.js')}"></script>
	    <script type="text/javascript">
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
	
	            if ("${userInfo.lang}" == "2") {
	                document.getElementById("eng").style.display = "inline-block";
	                document.getElementById("colordra").innerHTML = "Draft";
	                document.getElementById("colorapp").innerHTML = "Approval";
	                document.getElementById("colorpro").innerHTML = "Progress";
	                document.getElementById("colorrej").innerHTML = "Rejecting";
	            }
	            
	            makeoptionyear();
	            getapprovalstatistics();
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
	                } else if (selyear + 1 == year){
	                	document.getElementById("selyear").innerHTML = "";
	                    tempyear = selyear + 1;
	                    for (var i = 0; i < 5; i++) {
	                        var option = document.createElement("OPTION");
	                        option.value = tempyear;
	                        option.innerHTML = tempyear;

	                        if (selyear == tempyear)
	                            option.selected = true;

	                        document.getElementById("selyear").appendChild(option);
	                        tempyear--;
	                    }
	                    tempyear = selyear + 1;
	                }
	            }
	        }
	
	        function getapprovalstatistics() {
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getStatisticsAprMain.do",
					data : {
							company : document.getElementById("SCompID").value,
							date : document.getElementById("selyear").value
							},
					success: function(text) {
						event_getapprovalstatistics(text);
					}        			
				});
	        }
	
	        function event_getapprovalstatistics(text) {
                document.getElementById("statisticstable").innerHTML = "";
                var _Table = document.createElement("TABLE");
                _Table.style.textAlign = "center";
                _Table.style.width = "100%";
                _Table.className = "tstyle2";
                _Table.style.border = "1px solid #dadada"

                var _Tr = document.createElement("TR");
                var _Tr2 = document.createElement("TR");
                var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");

                for (var i = 0; i < 13; i++) {
                    var _Th = document.createElement("TH");
                    var _Th2 = document.createElement("TH");
                    if (i == 0) {
                        _Th.style.width = "100px";
                        _Tr.appendChild(_Th);
                        _Th2.innerHTML = "<spring:message code='ezStatistics.t88'/>";
                        _Tr2.appendChild(_Th2);
                    }
                    else {
                        _Th.colSpan = "4";
                        _Th.innerHTML = ticks[i - 1];
                        _Tr.appendChild(_Th);

                        _Th2 = document.createElement("TH");
                        _Th2.style.whiteSpace = "normal";
                        _Th2.style.wordBreak = "break-all";
                        _Th2.innerHTML = "<spring:message code='ezStatistics.t1026'/>";
                        _Tr2.appendChild(_Th2);

                        _Th2 = document.createElement("TH");
                        _Th2.style.whiteSpace = "normal";
                        _Th2.style.wordBreak = "break-all";
                        _Th2.innerHTML = "<spring:message code='ezStatistics.t1027'/>";
                        _Tr2.appendChild(_Th2);

                        _Th2 = document.createElement("TH");
                        _Th2.style.whiteSpace = "normal";
                        _Th2.style.wordBreak = "break-all";
                        _Th2.innerHTML = "<spring:message code='ezStatistics.t1028'/>";
                        _Tr2.appendChild(_Th2);

                        _Th2 = document.createElement("TH");
                        _Th2.style.whiteSpace = "normal";
                        _Th2.style.wordBreak = "break-all";
                        _Th2.innerHTML = "<spring:message code='ezStatistics.t1029'/>";
                        _Tr2.appendChild(_Th2);
                    }
                }
                _Table.appendChild(_Tr);
                _Table.appendChild(_Tr2);
                var resultxml = loadXMLString(text);

                var j = 12;
                var _Tr3;
                if (SelectNodes(resultxml, "DATA/ROW").length > 0 && getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[0], "REGDATE")).trim() == "") {
                    document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                    return;
                }
                for (var i = 0; i < SelectNodes(resultxml, "DATA/ROW").length; i++) {
                    if (j == 12) {
                        if (i != 0)
                            _Table.appendChild(_Tr3);
                        j = 0;
                        var _Td = document.createElement("TD");
                        _Td.innerHTML = document.getElementById("SCompID")[document.getElementById("SCompID").selectedIndex].text;
                        _Tr3 = document.createElement("TR");
                        _Tr3.id = "datarow";
                        _Tr3.appendChild(_Td);
                        i--;
                    }
                    else {
                        var regdate = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "REGDATE"));
                        var mon;
                        if (j + 1 < 10)
                            mon = "0" + (j + 1);
                        else
                            mon = j + 1;

                        if (regdate == document.getElementById("selyear").value + "-" + mon) {
                            var _Td = document.createElement("TD");
                            _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTCNT"));
                            _Tr3.appendChild(_Td);

                            _Td = document.createElement("TD");
                            _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTENDCNT"));
                            _Tr3.appendChild(_Td);

                            _Td = document.createElement("TD");
                            _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTINGCNT"));
                            _Tr3.appendChild(_Td);

                            _Td = document.createElement("TD");
                            _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "RETURNCNT"));
                            _Tr3.appendChild(_Td);
                        }
                        else {
                            var _Td = document.createElement("TD");
                            _Td.innerHTML = "0";
                            _Tr3.appendChild(_Td);

                            _Td = document.createElement("TD");
                            _Td.innerHTML = "0";
                            _Tr3.appendChild(_Td);

                            _Td = document.createElement("TD");
                            _Td.innerHTML = "0";
                            _Tr3.appendChild(_Td);

                            _Td = document.createElement("TD");
                            _Td.innerHTML = "0";
                            _Tr3.appendChild(_Td);
                            i--;
                        }
                        j++;
                    }
                }
                if (SelectNodes(resultxml, "DATA/ROW").length == 0) {
                    _Tr3 = document.createElement("TR");
                    _Tr3.id = "datarow";
                    var _Td = document.createElement("TD");
                    _Td.innerHTML = document.getElementById("SCompID")[document.getElementById("SCompID").selectedIndex].getAttribute("value2");
                    _Tr3.appendChild(_Td);
                    j = 0;
                }
                if (j != 12) {
                    for (; j < 12; j++) {
                        var _Td = document.createElement("TD");
                        _Td.innerHTML = "0";
                        _Tr3.appendChild(_Td);

                        _Td = document.createElement("TD");
                        _Td.innerHTML = "0";
                        _Tr3.appendChild(_Td);

                        _Td = document.createElement("TD");
                        _Td.innerHTML = "0";
                        _Tr3.appendChild(_Td);

                        _Td = document.createElement("TD");
                        _Td.innerHTML = "0";
                        _Tr3.appendChild(_Td);
                    }
                }
                _Table.appendChild(_Tr3);

                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                drawingchart();
	        }
	
	        function drawingchart() {
	            document.getElementById("statisticschart").innerHTML = "";
	            document.getElementById("chartdiv").style.display = "";
	
	            var data = new Array();
	            var data2 = new Array();
	            var data3 = new Array();
	            var data4 = new Array();
	            for (var i = 0; i < 12; i++) {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("datarow"))[i * 4 + 1])));
	                data2.push(parseInt(getnodetext(GetChildNodes(document.getElementById("datarow"))[i * 4 + 2])));
	                data3.push(parseInt(getnodetext(GetChildNodes(document.getElementById("datarow"))[i * 4 + 3])));
	                data4.push(parseInt(getnodetext(GetChildNodes(document.getElementById("datarow"))[i * 4 + 4])));
	            }
	
	            var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");
	            plot2 = $.jqplot('statisticschart', [data, data2, data3, data4], {
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
	
	        function getnodetext(obj) {
	            if (CrossYN())
	                return obj.textContent;
	            else
	                if (obj.text == undefined)
	                    return obj.innerText;
	                else
	                    return obj.text;
	        }
	    </script>
	</head>
	<body  class="mainbody">
	    <h1><spring:message code='ezStatistics.t1030'/></h1>
	    <table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
	        <tr>
	            <td style="width: 99%">
	                <span id="topmenu" style="width: 500px">&nbsp;<spring:message code='ezStatistics.t195'/> :
	            <select style="height:24px" id="SCompID" name="SCompID" onchange="return getapprovalstatistics()">
					<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            		</c:forEach>
	            </select>
	                    &nbsp;<spring:message code='ezStatistics.t1002'/> : 
	                <select style="height:24px" id="selyear" onchange="makeoptionyear(); getapprovalstatistics()"></select>
	                    <spring:message code='ezStatistics.t55'/></span>
	            </td>
	            <td>
	                <div id="mainmenu" style="height: 31px;margin:3px 0px !important">
	                    <ul>
	                        <li><span class="btnexportexcel" style="width: 110px;text-align:center;background-color: white" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <br />
	    <div id="chartdiv" style="width: 1000px; text-align: center;">
	        <div id="colorbox" class="statistics_addition">
	            <dl>
	                <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
	                <dd id="colordra" class="additiontext"><spring:message code='ezStatistics.t1026'/></dd>
	            </dl>
	            <dl>
	                <dt class="colorbox_wrap"><span style="background: #eaa229" class="colorbox"></span></dt>
	                <dd id="colorapp" class="additiontext"><spring:message code='ezStatistics.t1027'/></dd>
	            </dl>
	            <dl>
	                <dt class="colorbox_wrap"><span style="background: #c2b483" class="colorbox"></span></dt>
	                <dd id="colorpro" class="additiontext"><spring:message code='ezStatistics.t1028'/></dd>
	            </dl>
	            <dl>
	                <dt class="colorbox_wrap"><span style="background: #58966f" class="colorbox"></span></dt>
	                <dd id="colorrej" class="additiontext"><spring:message code='ezStatistics.t1029'/></dd>
	            </dl>
	        </div>
	        <div id="statisticschart" style="width: 1000px; height: 500px; float: left; font-size: 16px;">
	        </div>
	        <br />
	        <br />
	        <br />
	    </div>
	    <div id="eng" style="display:none">
	        <span style="padding-right:5px">D = Draft</span>
	        <span style="padding-right:5px">A = Approval</span>
	        <span style="padding-right:5px">P = Progress</span>
	        <span>R = Rejecting</span>
	    </div>
	    <div id="statisticstable" style="width:1635px;">
	    </div>
	     <div id="nodata" style="display: none; margin-top: 150px; text-align: center">
	        <div class="statistics_nodata" style="margin: 0 auto">
	            <dl class="statistics_txt">
	                <dt><spring:message code='ezStatistics.t1008'/>.</dt>
	                <dd><spring:message code='ezStatistics.t1009'/></dd>
	            </dl>
	        </div>
	    </div>
	    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXlsTotalA.do">
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
	        <input type="hidden" id="userAgent" name="userAgent" value="">
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>