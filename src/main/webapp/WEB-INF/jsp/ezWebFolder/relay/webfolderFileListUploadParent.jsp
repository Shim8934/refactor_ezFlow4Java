<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezWebFolder.kes064' /></title>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			// 새창 호출 시 : 호출하는 곳에서 받을 첨부파일 정보.
			var paramKey = opener.paramKey;
			var sentDateStr = opener.sentDateStr;
			var mailAttachItems = opener.mailAttachItems;
			var shareId = opener.shareId;
		</script>
		<%@ include file="/WEB-INF/jsp/ezWebFolder/relay/webfolderFileListUploadParentHead.jsp" %>
		<script type="text/javascript">
			// 새창 호출 시 : 바로 팝업까지 띄우도록.
			$(document).ready(function() {
				filePick.open(pickerData);
			});

			// 새창을 호출했으므로, 완료시에는 창을 닫도록 설계함.
			function completeListener() {
				window.close();
			}
			duplicateFile.setOnCompleteListener(completeListener);
			pickerData.cancelBT = completeListener;
		</script>
	</head>
	<body>
		<%@ include file="/WEB-INF/jsp/ezWebFolder/relay/webfolderFileListUploadParentBody.jsp" %>
	</body>
</html>