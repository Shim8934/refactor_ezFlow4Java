<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PhotoBoard Portlet</title>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
</head>
<body>
<div class="layDIV">
	<dl class="portlet_title photo_board">
		<dt class="portletText">포토 갤러리</dt>
		<dd class="portletPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
		<dd class="nextBtn"><img src="/images/ezNewPortal/photo_next.png"></dd>
		<dd class="preBtn"><img src="/images/ezNewPortal/photo_pre.png"></dd>
	</dl>
	<ul class="photoList" id="photoul">
			<li><img src="/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&amp;boardID=%7Bded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c%7D&amp;fileName=s_{6c8cc7e6-e533-4ead-8d36-bd877aa3b03b}.jpg" onclick="ItemRead_onclick(this)" data1="{ded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c}" data2="{d49768a5-d94e-b5ef-9333-9b6069ba2fd9}"></li>
			<li><img src="/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&amp;boardID=%7Bded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c%7D&amp;fileName=s_{ebf75b2d-57ba-42d0-be5e-20db4c89974e}.jpg" onclick="ItemRead_onclick(this)" data1="{ded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c}" data2="{9916d44e-51ce-2828-9c7d-35121d54cb7e}"></li>
			<li><img src="/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&amp;boardID=%7Bded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c%7D&amp;fileName=s_{868bd6e2-c06a-45a1-b875-0b45ed9de78f}.jpg" onclick="ItemRead_onclick(this)" data1="{ded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c}" data2="{52f1611f-57da-a9bb-d560-c727902b63d8}"></li>
			<li><img src="/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&amp;boardID=%7Bded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c%7D&amp;fileName=s_{4ef0470b-8924-4050-8a8f-e070353e28ad}.jpg" onclick="ItemRead_onclick(this)" data1="{ded4ccd7-79f7-f6e5-b37a-51c29a4fdc3c}" data2="{0beb815c-fff2-920f-0614-653fecf77619}"></li>
	</ul>
</div>
</body>
</html>