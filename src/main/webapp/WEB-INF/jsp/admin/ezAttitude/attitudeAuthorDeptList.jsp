<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
		<table class="mainlist_free">
			<c:if test="${authorDeptList ne null }">
				<c:forEach items="${authorDeptList}" var="dept">
				<c:choose>
					<c:when test="${dept.mine eq 'yes' }">
						<tr targetId="${dept.deptId }" mine="Y" style="display: none;">
							<td align="left" style="width:250px;">${dept.deptName }</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr targetId="${dept.deptId }" style="cursor: pointer;" class="hover">
							<td align="left" style="width:250px;">${dept.deptName }</td>
						</tr>
					</c:otherwise>
				</c:choose>
				</c:forEach>
			</c:if>
		</table>