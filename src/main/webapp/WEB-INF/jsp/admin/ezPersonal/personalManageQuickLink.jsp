<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.e4', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezPersonal.h1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/admin/adminManageQuickLink.js')}"></script>
		<script type="text/javascript">
			var xmlhttp = null;
			var userLang;                     //언어
			var mode;                         //new, modify
			var guid;
			var mainTitleId;
			var subTitle1Id;
			var subTitle2Id;
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			$(document).ready(function() {
				makeList();
			});
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezPersonal.khj1"/>
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
		</h1>
		<!-- 빠른 링크 리스트 영역 -->
		<div class="admin_quicklink">
			<ul id="mainlist"></ul>
		</div>	
		<input type="hidden" id="quickUserLang" value="<c:out value='${userLang}'/>">
		<input type="hidden" id="quickUserPrimanry" value="<c:out value='${userPrimanryLang}'/>">
		<!-- 빠른 링크 추가 영역 -->
		<xml id="listviewheader" style="display: none;"></xml>
		<iframe name="ifrm" src="about:blank" style="display: none;"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPersonal/typeImageUpload.do?guid=" target="ifrm" style ="display:none">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" accept=".jpg, .gif, .png" />
			<input type="hidden" name="boardid" id="boardid" />
			<input type="hidden" name="maxsize" id="maxsize" />
			<input type="hidden" name="mode" id="mode" value="PHOTO"/>
			<input type="hidden" name="cnt" id="cnt" />
			<input type="hidden" name="guid" id="guid"  />
			<input type="hidden" name="mailgubun" id="mailgubun" />
		</form>
	</body>
</html>