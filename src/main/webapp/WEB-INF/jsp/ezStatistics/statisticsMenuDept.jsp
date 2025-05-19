<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezStatistics.pgb05'/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/chart.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/common_statistics.js')}"></script>
	<script>
        var adminOrganVal = "<c:out value='${adminOrganVal}'/>";

        window.onload = function () {
            initCommonStatistics(initMsg, statMenuDept, "dept");
        }

        function initMsg() {
            CommonUtilsMsg.SEARCH_INSERT_PLZ = "<spring:message code='ezStatistics.t1010' />";
            CommonUtilsMsg.SEARCH_NO_DEPT = "<spring:message code='ezStatistics.t1011' />";
            CommonUtilsMsg.SEARCH_NO_USER = "<spring:message code='ezStatistics.t1016' />";
        }

        function statMenuDept() {
            var treeView = new TreeView();
            treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
            var selnode = treeView.GetSelectNode();
            if (!selnode) return;
            var selDeptId = selnode.GetNodeData("CN");
            var selDeptName = selnode.NodeName;
            var yearNode = $("#searchYear option:selected")[0];
            var monthNode = $("#searchMonth option:selected")[0];
            var dayNode = $("#searchDay option:selected")[0];
            var selTab = document.querySelector('#tabStatistics .tabover').id;
            var callUrl = "";
            var tableRows = 1;
            var tableTitle = "";
            var titleTexts = [];

            switch (selTab) {
                case "tabMonthly" :
                    callUrl = "/ezStatistics/statMenuDeptMonthly.do";
                    tableRows = 2;
                    tableTitle = "<spring:message code='ezStatistics.pgb06' />";
                    titleTexts.push(yearNode.innerText + "<spring:message code='ezStatistics.t55'/>");
                    break;
                case "tabDaily" :
                    callUrl = "/ezStatistics/statMenuDeptDaily.do";
                    tableRows = 4;
                    tableTitle = "<spring:message code='ezStatistics.pgb07' />";
                    titleTexts.push(yearNode.innerText + "<spring:message code='ezStatistics.t55'/>" +
                        ' ' + monthNode.innerText);
                    break;
                case "tabHourly" :
                    callUrl = "/ezStatistics/statMenuDeptHourly.do";
                    tableRows = 4;
                    tableTitle = "<spring:message code='ezStatistics.pgb08' />";
                    titleTexts.push(yearNode.innerText + "<spring:message code='ezStatistics.t55'/>" +
                        ' ' + monthNode.innerText + ' ' + dayNode.innerText);
                    break;
            }
            titleTexts.push(selDeptName);
            titleTexts.push($("#menuId option:selected").text());

            $.ajax({
                type: "GET",
                url: callUrl,
                async: false,
                data: {
                    companyId: companySelectID,
                    deptId: selDeptId,
                    year: yearNode.value,
                    month: monthNode.value,
                    day: dayNode.value,
                    menuId: document.getElementById("menuId").value
                },
                success: function (json) {
                    drawChart(json.labels, json.datasets);
                    drawTable(json.labels, json.datasets[0].data, tableRows, tableTitle, titleTexts);
                },
                error: function (e) {
                    frontLogging("statMenuUserMonthly error:", e, e.stack)
                    onNoDataArea();
                }
            });
        }

        function statMenuDeptMonthly() {
            var treeView = new TreeView();
            treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
            var selnode = treeView.GetSelectNode();
            if (!selnode) return;
            var selDeptId = selnode.GetNodeData("CN");
            var selDeptName = selnode.NodeName;
            var yearNode = document.getElementById("searchYear");

            $.ajax({
                type: "GET",
                url: "/ezStatistics/statMenuDeptMonthly.do",
                async: false,
                data: {
                    companyId: companySelectID,
                    deptId: selDeptId,
                    year: yearNode.value,
                    menuId: document.getElementById("menuId").value
                },
                success: function (json) {
                    drawChart(json.labels, json.datasets);
                    drawTable(json.labels, json.datasets[0].data, 2,
                        "<spring:message code='ezStatistics.pgb06' />",
                        yearNode.innerText + "<spring:message code='ezStatistics.t55'/>", selDeptName, $("#menuId option:selected").text()
                    );
                },
                error: function (e) {
                    frontLogging("statMenuDeptMonthly error:", e, e.stack)
                    onNoDataArea();
                }
            });
        }

        function statMenuDeptDaily() {
            var treeView = new TreeView();
            treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
            var selnode = treeView.GetSelectNode();
            if (!selnode) return;
            var selDeptId = selnode.GetNodeData("CN");
            var selDeptName = selnode.NodeName;
            var yearNode = document.getElementById("searchYear");
            var monthNode = document.getElementById("searchMonth");

            $.ajax({
                type: "GET",
                url: "/ezStatistics/statMenuDeptDaily.do",
                async: false,
                data: {
                    companyId: companySelectID,
                    deptId: selDeptId,
                    year: yearNode.value,
                    month: monthNode.value,
                    menuId: document.getElementById("menuId").value
                },
                success: function (json) {
                    drawChart(json.labels, json.datasets);
                    drawTable(json.labels, json.datasets[0].data, 5,
                        "<spring:message code='ezStatistics.pgb07' />",
                        yearNode.innerText + "<spring:message code='ezStatistics.t55'/>" + ' ' +
                        monthNode.innerText, selDeptName, $("#menuId option:selected").text()
                    );
                },
                error: function (e) {
                    frontLogging("statMenuDeptMonthly error:", e, e.stack)
                    onNoDataArea();
                }
            });
        }

        function statMenuDeptHourly() {
            var treeView = new TreeView();
            treeView.LoadFromID(ConstantsConstant.TREE_VIEW_DEPT_ID);
            var selnode = treeView.GetSelectNode();
            if (!selnode) return;
            var selDeptId = selnode.GetNodeData("CN");
            var selDeptName = selnode.NodeName;
            var yearNode = document.getElementById("searchYear");
            var monthNode = document.getElementById("searchMonth");
            var dayNode = document.getElementById("searchDay");

            $.ajax({
                type: "GET",
                url: "/ezStatistics/statMenuDeptHourly.do",
                async: false,
                data: {
                    companyId: companySelectID,
                    deptId: selDeptId,
                    year: yearNode.value,
                    month: monthNode.value,
                    day: dayNode.value,
                    menuId: document.getElementById("menuId").value
                },
                success: function (json) {
                    drawChart(json.labels, json.datasets);
                    drawTable(json.labels, json.datasets[0].data, 4,
                        "<spring:message code='ezStatistics.pgb08' />",
                        yearNode.innerText + "<spring:message code='ezStatistics.t55'/>" + ' ' +
                        monthNode.innerText + ' ' + dayNode.innerText, selDeptName, $("#menuId option:selected").text()
                    );
                },
                error: function (e) {
                    frontLogging("statMenuDeptMonthly error:", e, e.stack)
                    onNoDataArea();
                }
            });
        }
	</script>
</head>
<body class="mainbody">
<h1><spring:message code='ezStatistics.pgb05'/>
	<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
</h1>
<table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin: 15px 0;">
	<tr>
		<td style="width: 99%">
			<span id="topmenu" style="width: 500px">&nbsp;<spring:message code='ezStatistics.t1002'/> : 
				<select style="height:24px" id="searchYear"></select>
					<spring:message code='ezStatistics.t55'/>
				<select style="height:24px; display: none;" id="searchMonth">
					<c:forEach var="month" items="${monthList}" varStatus="status">
						<option value="${status.count}" ${status.count == monthVal ? 'selected' : ''}><c:out
								value='${month}'/></option>
					</c:forEach>
				</select>
				<select style="height:24px; display: none;" id="searchDay">
					<c:forEach var="day" items="${dayList}" varStatus="status">
						<option value="${status.count}" ${status.count == dayVal? 'selected' : ''}><c:out
								value='${day}'/></option>
					</c:forEach>
				</select>
				<a class="imgbtn" style="height:22px"><span onclick="refreshDate()"><spring:message
						code='ezBoard.t220'/></span></a>
				<span class="title_bar"><img src="/images/name_bar.gif"></span>
				<select id="searchopt" style="display: none">
					<option value="2"><spring:message code='ezStatistics.t113'/></option>
				</select>
				&nbsp;&nbsp;<spring:message code='ezStatistics.t1013'/> : 
				<input id="keyword" type="text" style="width: 100px" onkeypress="search_press(event)"/>
				<a class="imgbtn" style="height:22px"><span onclick="search()"><spring:message
						code='ezStatistics.t36'/></span></a>
			</span>
		</td>
		<td>
			<div id="mainmenu" style="height: 28px;margin:3px 0px !important">
				<ul>
					<li>
						<span style="width: 110px;text-align:center;background-color: white"
							  onclick="return btnexportexcel_onclick()">
						<spring:message code='ezStatistics.t1003'/></span>
					</li>
				</ul>
			</div>
		</td>
	</tr>
</table>
<div class="portlet_tabpart01" style="margin-top: 3px;float:left">
	<div class="portlet_tabpart01_top" id="tabStatistics">
		<p><span id="tabMonthly" class="tabover"><spring:message code='ezStatistics.pgb06'/></span></p>
		<p><span id="tabDaily"><spring:message code='ezStatistics.pgb07'/></span></p>
		<p><span id="tabHourly"><spring:message code='ezStatistics.pgb08'/></span></p>
	</div>
</div>
<br/>
<h2 id="ToTitle" class="receiver_tltype01" style="border:0px">
	<span style="min-width: 45px;"><spring:message code='ezStatistics.t1014'/></span>
</h2>
<table style="width: 1200px;height:670px ;border:1px solid #ddd">
	<tr>
		<td style="vertical-align: top">
			<div style="width:310px;height:100%;overflow-x:auto;overflow-y:auto;border-right:1px solid #ddd;"
				 id="TreeView"></div>
		</td>
		<td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center; position:relative;">
			<div id="areaChartMenu">
				<div id="areaSelMenu" class="flex_row_center">
					<label for="menuId"><spring:message code='ezStatistics.pgb09'/> : &nbsp;</label>
					<select id="menuId">
						<option value=""><spring:message code='ezStatistics.pgb01'/></option>
					</select>
					<span class="emphasis_sentence">* <spring:message code='ezStatistics.pgb11'/></span>
				</div>
				<a id="goBackDou" class="imgbtn" style="height:22px; display: none;">
					<span><spring:message code='ezStatistics.pgb10'/></span>
				</a>
			</div>
			<div id="viewdata" style="display: none">
				<div id="chartDiv" style="width: 100%; text-align: center;">
					<canvas id="chartCanvas"></canvas>
				</div>
				<div id="statisticstable"></div>
			</div>
			<div id="seluser" class="statistics_select" style="margin: 0 auto">
				<dl class="statistics_txt">
					<dt><spring:message code='ezStatistics.hsbUs01'/></dt>
					<dd><spring:message code='ezStatistics.t1020'/><br>
						<spring:message code='ezStatistics.t1021'/></dd>
				</dl>
			</div>
			<div id="nodata" class="statistics_nodata" style="display: none; margin: 0 auto">
				<dl class="statistics_txt">
					<dt><spring:message code='ezStatistics.t1008'/></dt>
					<dd><spring:message code='ezStatistics.t1009'/></dd>
				</dl>
			</div>
		</td>
	</tr>
</table>
<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saveExcel.do">
	<input type="hidden" id="saveExcelData" name="saveExcelData" value="">
	<input type="hidden" id="userAgent" name="userAgent" value="">
	<input type="hidden" id="headerFlag" name="headerFlag" value="TRUE">
</form>
<iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
</html>
