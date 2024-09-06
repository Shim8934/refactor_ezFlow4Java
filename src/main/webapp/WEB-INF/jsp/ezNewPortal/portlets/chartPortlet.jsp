<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>chartPortlet</title>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/moment.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/chart.js')}"></script>
<style>
#chartLeft{
	z-index: 0;
	width: 0;
	height: calc(100% - 20px);;
	display: none;
	box-sizing: border-box;
}

#chartRight{
	padding: 10px;
	width: 100%;
	height: 100%;
	border: none;
	box-sizing: border-box;
}

.one_by_two #chartLeft {display: block; width: 25%;}
.one_by_two #chartRight {width: 75%;}

.one_by_two #chartRight:before {
	border-left: 1px solid #dbdbdb;
	content : "";
	position: absolute;
	height: calc(100% - 85px);
}

.two_by_one #chartLeft {
	display: block;
	width: 100%;
	height: calc(50% - 40px);
	margin:20px 0;
}
.two_by_one #chartRight {width: 100%; height: 50%;}
.two_by_one #chartPortletList {
	align-items: center;
	justify-content: space-around;
	flex-direction: column;
}

#chartPortletList {
	display: flex;
	align-items: center;
	height: calc(100% - 63px);
	width: 100%;
}
</style>
</head>
<body>
	<input type="hidden" value="<c:out value='${usedTheme }'/>" id="usedTheme">
	<article class="box_shadow">
		<div class="layDIV">
           <dl class="portlet_title sortablePortlet">
           		<dt class="portletText"><c:out value='${portletName }'/></dt>
           </dl>
			<div class="portlet_list" id="chartPortletList">
	           <div id="chartLeft">
	           		<canvas id="canvas2"></canvas>
	           </div>
	           <div id="chartRight">
		           	<canvas id="canvas"></canvas>
	           </div>
			</div>
    	</div>
    </article>
</body>
<script>
	var initFail = function() {
		var failSpace = document.getElementById("chartPortletList");
		failSpace.innerHTML =
				"<dl class='nodata'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd>"
				+ messages.strLang1
				+ "</dd></dl>";
		if (!!failSpace.firstChild) failSpace.firstChild.style.margin = "0 auto";
	}

	var getDataForSampleChart = function () {
		var request = new XMLHttpRequest();
		request.open('GET', '/ezNewPortal/sampleChartPortlet.do', true);
		request.responseType = 'text';

		request.onload = function () {
			if (request.status >= 200 && request.status < 400) {
				var jsonArr = JSON.parse(request.response);
				var canvas2 =  document.getElementById("canvas2");
				var douChart = new EzChartPortlet();
				douChart.draw(canvas2).initDou(jsonArr[1]).count();
				var canvas = document.getElementById("canvas");
				var stackChart = new EzChartPortlet();
				stackChart.draw(canvas).initStackBar(jsonArr[0]);
			} else {
				initFail();
			}
		}
		request.onerror = function () {
			initFail();
		};
		request.send();
	}

	var initChartPortlet = function () {
		getDataForSampleChart();
	}
</script>
</html>