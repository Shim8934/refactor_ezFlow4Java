<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<c:choose>
		<c:when test="${fn:length(formList) > 0}">
			<c:forEach items="${formList}" var="form" varStatus="status">
				<tr formid="${form.formId}" formstatus="${form.formStatus}" onclick="listClick(this)">
					<td style="text-align: center;"><c:out value='${status.count }'/></td>
					<td><c:out value='${form.formName }'/></td>
					<c:choose>
						<c:when test="${fn:length(form.depts) > 1 }">
							<td><c:out value='${form.depts[0].deptName }'/><spring:message code="ezJournal.t124"/>${fn:length(form.depts) -1}</td>
						</c:when>
						<c:otherwise>
							<td><c:out value='${form.depts[0].deptName }'/></td>
						</c:otherwise>
					</c:choose>
					<td><c:out value='${form.formInfo }'/></td>
					<td><c:out value='${fn:substring(form.formDate, 0, 10) }'/></td>
				</tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr><td colspan="5" style="text-align: center;"><spring:message code='ezJournal.t125'/></td></tr>
		</c:otherwise>
	</c:choose>

