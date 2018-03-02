<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<c:choose>
		<c:when test="${fn:length(formList) > 0}">
			<c:forEach items="${formList}" var="fList" varStatus="status">
				<tr formid="${fList.formId}" onclick="listClick(this)">
					<td style="text-align: center;">${status.count }</td>
					<td>${fList.formName }</td>
					<c:choose>
						<c:when test="${fn:length(fList.depts) > 1 }">
							<td>${fList.depts[0].deptName }&nbsp;<spring:message code="ezJournal.t124"/>&nbsp;${fn:length(fList.depts) -1}</td>
						</c:when>
						<c:otherwise>
							<td>${fList.depts[0].deptName }</td>
						</c:otherwise>
					</c:choose>
					<td>${fList.formInfo }</td>
					<td>${fn:substring(fList.formDate, 0, 10) }</td>
				</tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr><td colspan="5" style="text-align: center;"><spring:message code='ezJournal.t125'/></td></tr>
		</c:otherwise>
	</c:choose>

