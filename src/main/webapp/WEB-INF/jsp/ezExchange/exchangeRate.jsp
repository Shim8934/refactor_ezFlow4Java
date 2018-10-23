<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <title><spring:message code='ezPortal.pjg11'/></title>
        <table>
          <td>
             <tr>조회결과&nbsp</tr>
             <tr>통화코드&nbsp </tr>
             <tr>국가/통화명 &nbsp</tr>
             <tr>전신환 받으실때&nbsp </tr>
             <tr>전신환 보내실때 &nbsp</tr>
             <tr>매매 기준율&nbsp</tr>
             <tr>장부가격&nbsp</tr>
             <tr>년환가료율&nbsp</tr>
             <tr>10년일환가료율&nbsp</tr>
             <tr>서울외국환중계매매기준율&nbsp</tr>
             <tr>서울외국환중계장부가격&nbsp</tr>
          </td>
        </table>
        <c:forEach var="i" begin="0" end="15">
        <c:forEach var="entry" items="${json[i]}">
        <tr>
          <td>${entry.value}</td>
        </tr>
        </c:forEach></br>
        </c:forEach>
	</head>
	<body>
	</body>
</html>