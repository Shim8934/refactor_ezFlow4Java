<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><spring:message code="ezResource.resFav.ygs11" /></title>
<link rel="stylesheet" href="${util.addVer('/css/organ_tree.css')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
</head>
<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style>
.node_normal {
	line-height: 26px;
	font-size: 14px;
}
</style>
<body class="popup" style="overflow: hidden;">
	<input type="hidden" id="selectCategoryId"
		placeholder="selectCategoryId">
	<input type="hidden" id="selectBrdId" placeholder="selectBrdId">
	<input type="hidden" id="brdId" value="${brdId}">
	<input type="hidden" id="selectBrdTopCatId"
		placeholder="selectBrdTopCatId">
	<div id="nomalScreen">
		<div id="menu">
			<h1>
				<spring:message code="ezResource.resFav.ygs11" />
			</h1>
		</div>
	</div>
	<div id="close">
		<ul>
			<li><span onclick="window.close()"></span></li>
		</ul>
	</div>
	<br>
	<table class="popuplist" style="width: 100%; margin-top: 5px">
		<tr>
			<td>
				<div class="tree"
					style='width: auto; overflow-x: auto; overflow-y: auto; margin-left: 5px; height: 280px;'
					id='TreeCtrl_MyFavoriteTree'></div>
			</td>
		</tr>
	</table>
	<div class="btnpositionNew">
		<a class="imgbtn"><span onclick="btn_clicked('CC');"> <spring:message
					code="ezResource.resFav.ygs03" />
		</span></a> <a class="imgbtn"><span onclick="btn_clicked('C');"><spring:message code="ezResource.resFav.ygs13" />
		</span></a> <a class="imgbtn"><span onclick="btn_clicked('U');"> <spring:message
					code="ezResource.resFav.ygs04" />
		</span></a> <a class="imgbtn" data-hide="1"><span onclick="btn_clicked('M');">
				<spring:message code="ezResource.resFav.ygs05" />
		</span></a> <a class="imgbtn" data-hide="1"><span onclick="btn_clicked('D');">
				<spring:message code="ezResource.resFav.ygs06" />
		</span></a>
		<c:if test="${not empty brdId }">
			<a data-brd-btn="T" class="imgbtn" ><span onclick="btn_clicked('B');"> <spring:message
						code="ezResource.resFav.ygs02" />
			</span></a>
		</c:if>
	</div>
	<div
		style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;"
		id="mailPanel">&nbsp;</div>
	<div class="layerpopup"
		style="z-index: 2000; position: absolute; display: none;"
		id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />"
			style="border: none;" id="iFrameLayer"></iframe>
	</div>
	<script type="text/javascript"
		src="${util.addVer('/js/ezResource/resFavoriteManage.js')}"></script>
</body>
</html>