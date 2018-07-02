<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
		<script type="text/javascript">
		function fileModify() {
			var cabId    = "";
			window.location.href = "/ezCabinet/addCabinetFile.do?cabId=" + cabId;
			window.resizeTo(600, 530);
		}
		</script>
	</head>
	<body class="popup cabDetail">
		<h1><spring:message code='ezCabinet.t108'/></h1>
		
		<div class="divInfo">
			<table class="tblFileInf">
				<tr><th><spring:message code='ezCabinet.t109'/></th><td>응웬바오</td><tr>
				<tr><th><spring:message code='ezCabinet.t110'/></th><td>2018-06-26 12:00</td><tr>
				<tr><th><spring:message code='ezCabinet.t51'/></th><td>전자결재버그 수정 관련</td></tr>
				<tr><th><spring:message code='ezCabinet.t52'/></th><td>전자결재 버그 수정 관련 파일 첨부</td></tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td>메신저 관련 전자결재, 메신저 관련 메일</td>
				</tr>
			</table>
		</div>
		
		<div class="htmlDiv">
			<div class="divInform">
				<span>연동된 모듈 html의 태그</span>
			</div>
		</div>
		
		<div class="fileDetailDiv">
			<div class="divInform">
				<span>첨부 파일 영역</span>
			</div>
		</div>
		
		<div class="cabBttnDiv" id="cabAddBttn">
			<a class="cabBttn"><span onclick="fileModify()"><spring:message code='ezCabinet.t78'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
	</body>
</html>