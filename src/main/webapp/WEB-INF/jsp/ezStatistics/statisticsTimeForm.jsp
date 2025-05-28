<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code='ezStatistics.t1036'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist_free tr th { border-top:0px }
		</style>
		<script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/ListView_list.js')}"></script>
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
	
	            makeoptionyear();
	            getforminfo();
	        }
	
	        function getforminfo() {
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getFormInfo.do",
					data : {
							company : document.getElementById("SCompID").value,
							date : document.getElementById("selyear").value,
							searchList : document.getElementById("formname").value,
							type : "2"
							},
					success: function(text) {
						event_getforminfo(text);
					},
					error: function() {
						OpenAlertUI(linealt2)
					}
				});
	        }
	
	        function event_getforminfo(text) {
                document.getElementById("formlist").style.display = "";
                var retXml = createXmlDom();

                if (document.getElementById("formlist").innerHTML != "")
                    document.getElementById("formlist").innerHTML = "";

                var headerData = createXmlDom();
                headerData = loadXMLString(forminfoxml.innerHTML.toUpperCase());
                if (text != "") {
                    var xmlRtn = loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0];
                    headerData.documentElement.appendChild(xmlRtn);
                }
                var pUserList = new ListView();
                pUserList.SetID("lvformlist");
                pUserList.SetRowOnClick("getapprovalstatistics");
                pUserList.SetSelectFlag(false);
                pUserList.SetHeightFree(true);
                pUserList.DataSource(headerData);
                pUserList.DataBind("formlist");
                
                pUserList.SetSelectedIndex(0);
	              
             	 if (loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0].textContent != "") {
	          	  	getapprovalstatistics();
              	 }
	        }
	
	        function search_press(e) {
	            if (window.event) {
	                if (window.event.keyCode == 13) {
	                    getforminfo();
	                }
	            }
	            else {
	                if (e.which == 13)
	                    getforminfo();
	            }
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
	        	var objTd2 = document.getElementById("timeForm");
	        	objTd2.style.display = "";
	        	
	            var pformList = new ListView();
	            pformList.LoadFromID("lvformlist");

	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getStatisticsAprTime.do",
					data : {
							company : document.getElementById("SCompID").value,
							date : document.getElementById("selyear").value,
							searchID : GetAttribute(pformList.GetSelectedRows()[0],"DATA1"),
							type : "FORM"
							},
					success: function(text) {
						event_getapprovalstatistics(text);
					}
				});
	        }
	
	        function event_getapprovalstatistics(text) {
                document.getElementById("statisticstable").innerHTML = "";
                document.getElementById("colorbox").style.display = "";
                var _Table = document.createElement("TABLE");
                _Table.style.textAlign = "center";
                _Table.style.width = "100%";
                _Table.className = "tstyle2";
                _Table.style.border = "1px solid #dadada"

                var _Tr = document.createElement("TR");
                var _Tr2 = document.createElement("TR");
                var _Tr3 = document.createElement("TR");
                var _Tr4 = document.createElement("TR");
                var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");

                for (var i = 1; i < 13; i++) {
                    var _Th = document.createElement("TH");
                    _Th.innerHTML = ticks[i - 1];

                    if (i < 7) {
                        _Tr.appendChild(_Th);
                    }
                    else {
                        _Tr2.appendChild(_Th);
                    }
                }

                var resultxml = loadXMLString(text);
                if (SelectNodes(resultxml, "DATA/ROW").length == 0)
                    return;

                var j = 0;
                for (var i = 0; i < SelectNodes(resultxml, "DATA/ROW").length; i++) {
                    var formid = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "FORMID"));
                    var regdate = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "REGDATE"));
                    var mon;
                    if (j + 1 < 10)
                        mon = "0" + (j + 1);
                    else
                        mon = j + 1;

                    var _Td = document.createElement("TD");

                    if (regdate == document.getElementById("selyear").value + "-" + mon && (i == 0 || formid == getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i - 1], "FORMID")))) {
                        _Td = document.createElement("TD");
                        _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DTIME"));
                    }
                    else {
                        _Td = document.createElement("TD");
                        _Td.innerHTML = "0";
                        i--;
                    }
                    if (j < 6) {
                        _Tr3.appendChild(_Td);
                    }
                    else {
                        _Tr4.appendChild(_Td);
                    }
                    j++;
                }

                for (; j < 12; j++) {
                    _Td = document.createElement("TD");
                    _Td.innerHTML = "0";

                    if (j < 6) {
                        _Tr3.appendChild(_Td);
                    }
                    else {
                        _Tr4.appendChild(_Td);
                    }
                }
                _Tr3.id = "mon";
                _Tr4.id = "mon2";

                _Table.appendChild(_Tr);
                _Table.appendChild(_Tr3);
                _Table.appendChild(_Tr2);
                _Table.appendChild(_Tr4);

                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                drawingchart();
	        }
	
	        function drawingchart(obj) {
	            document.getElementById("statisticschart").innerHTML = "";
	            document.getElementById("chartdiv").style.display = "";
	
	            var data = new Array();
	            var data2 = new Array();
	            var data3 = new Array();
	            var data4 = new Array();
	            for (var i = 0; i < 6; i++) {
	                data.push(parseFloat(getnodetext(GetChildNodes(document.getElementById("mon"))[i])));
	            }
	            for (var i = 0; i < 6; i++) {
	                data.push(parseFloat(getnodetext(GetChildNodes(document.getElementById("mon2"))[i])));
	            }
	
	            var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");
	            plot2 = $.jqplot('statisticschart', [data], {
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
	
	        function search_press(e) {
	            if (window.event) {
	                if (window.event.keyCode == 13) {
	                    getforminfo();
	                }
	            }
	            else {
	                if (e.which == 13)
	                    getforminfo();
	            }
	        }
	    </script>
	</head>
	<body class="mainbody">
	   <xml id="forminfoxml" style="display: none">
	    <LISTVIEWDATA>
	    <HEADERS>
	        <HEADER>
	        <NAME><spring:message code='ezStatistics.t1032'/></NAME>
	        <WIDTH>70</WIDTH>
	        </HEADER>
	    </HEADERS>
	    </LISTVIEWDATA>
	</xml>
	    <h1><spring:message code='ezStatistics.t1036'/></h1>
	    <table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
	        <tr>
	            <td style="width: 99%">
	                <span id="topmenu" style="float: left; width: 800px">&nbsp;<spring:message code='ezStatistics.t195'/> :
	        <select style="height:24px" id="SCompID" name="SCompID" onchange="return getforminfo()">
	        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
	        </select>
	                    &nbsp;&nbsp;&nbsp;<spring:message code='ezStatistics.t1002'/> : 
	            <select style="height:24px" id="selyear" onchange="makeoptionyear(); getforminfo()"></select>
	                    <spring:message code='ezStatistics.t55'/>
	        &nbsp;&nbsp;<spring:message code='ezStatistics.t1032'/> : 
	            <input id="formname" type="text" style="width: 100px;" onkeypress="search_press(event)" />
	                    <a class="imgbtn" style="height:22px"><span onclick="getforminfo()"><spring:message code='ezStatistics.t36'/></span></a>
	                </span>
	            </td>
	            <td>
	                <div id="mainmenu" style="float: right; height: 31px;margin:3px 0px !important">
	                    <ul>
	                        <li><span class="btnexportexcel" style="width: 110px;text-align:center;background-color: white" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <br />
	    <br />
	   <table style="width: 1150px;height:630px ;border:1px solid #ddd">
	        <tr>
	            <td style="vertical-align:top">
	                <div id="formlist" style="Width: 300px; Height: 630px; overflow: auto;display:none;border-right:1px solid #ddd;"></div>
	            </td>
	            <td id="timeForm" style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
	                <div id="colorbox" class="statistics_addition" style="display: none">
	                    <dl>
	                        <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
	                        <dd class="additiontext"><spring:message code='ezStatistics.t1035'/></dd>
	                    </dl>
	                </div>
	                <div id="chartdiv" style="width: 100%; text-align: center; display: none">
	                    <div id="statisticschart" style="width: 800px; height: 500px; float: left; font-size: 16px;">
	                    </div>
	                </div>
	                <div id="statisticstable"></div>
	            </td>
	        </tr>
	    </table>
	    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXlsApprovalTime.do">
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
	        <input type="hidden" id="userAgent" name="userAgent" value="">
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>