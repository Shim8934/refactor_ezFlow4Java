<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>chartPortlet</title>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/moment.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/chart.js')}"></script>
<style>
#chartPortletList{
	display: flex;
}
#chartLeft{
	z-index: 0;
	width: 190px;
	height: 190px;
}
#countsDiv{
	float: left;
    bottom: 141px;
    position: relative;
    height: 164px;
    width: 188px;
    text-align: center;
    z-index: -10;
}
#yearProduceCountsSpan{
    color: rgb(63 76 95);
    font-size: 15px;
    font-weight: bold;
    height: 164px;
    vertical-align: middle;
    display: table-cell;
    width: 188px;
}
#chartRight{
	border-left: 1px solid #dbdbdb;
    padding: 10px;
	width: 100%;
	height: 172px;
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
	           <div id="chartLeft" style="display: none">
	           		<canvas id="canvas2"></canvas>
	           		<div id="countsDiv">
	           			<span id="yearProduceCountsSpan"></span>
	           		</div>
	           </div>
	           <div id="chartRight">
		           	<canvas id="canvas"></canvas>
	           </div>
			</div>
    	</div>
    </article>
</body>
</html>