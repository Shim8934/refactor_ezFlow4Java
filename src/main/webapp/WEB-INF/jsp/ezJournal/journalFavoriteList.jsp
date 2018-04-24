<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<c:choose>
		<c:when test="${fn:length(favoriteList) > 0}">
			<c:forEach items="${favoriteList}" var="favorite" varStatus="status">
				<tr favoriteid="${favorite.favoriteId}" class="hover" onclick="getFavoriteUser(this)">
					<td>${status.count }</td>
					<td>${favorite.favoriteName }</td>
					<td>${fn:substring(favorite.favoriteDate, 0, 10) }</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr><td colspan="3" style="text-align: center;"><spring:message code='ezJournal.t125'/></td></tr>
		</c:otherwise>
	</c:choose>

