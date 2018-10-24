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
             <tr>
               <th>조회결과&nbsp</th>
               <th>전신환 받으실때&nbsp</th>
               <th>전신환 보내실때&nbsp</th>
               <th>10일환가료율 &nbsp</th>
               <th>통화코드&nbsp</th>
               <th>장부가격&nbsp</th>
               <th>매매기준율&nbsp</th>
               <th>국가/통화명&nbsp</th>
               <th>서울외국환중계장부가격&nbsp</th>
               <th>년환가료율&nbsp</th>
               <th>서울외국환중계매매기준율 &nbsp</th>
             </tr>
        <c:forEach var="i" begin="0" end="30">
        <tr>
        <c:forEach var="entry" items="${json[i]}">
          <td>${entry.value}</td>
        </c:forEach>
        </tr>
        </c:forEach>
        </table>
	</head>
	<body>
	</body>
</html>