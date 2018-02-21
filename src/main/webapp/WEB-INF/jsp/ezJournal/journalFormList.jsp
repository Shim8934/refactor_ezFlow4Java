<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>jquery this 넘기기
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<c:choose>
		<c:when test="${fn:length(formList) > 0}">
			<c:forEach items="${formList}" var="fList" varStatus="status">
				<option value="<c:out value='${fList.formId}'/>">
					<c:out value="${fList.formName}"/>
				</option>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<option><spring:message code='ezJournal.t134'/></option>
		</c:otherwise>
	</c:choose>

