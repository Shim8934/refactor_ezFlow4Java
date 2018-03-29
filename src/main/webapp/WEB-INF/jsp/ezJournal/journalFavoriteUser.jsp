<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
	<c:choose>
		<c:when test="${fn:length(userList) > 0}">
			<c:forEach items="${userList}" var="user" varStatus="status">
				<tr id="${user.receiverId}" name="${user.receiverName}" class="hover" onclick="setUserAuthorDept(this)" ondblclick="setAuthorViewUser()">
					<td>${status.count }</td>
					<td>${user.receiverName }</td>
					<td>${user.jikwi }</td>
					<td>${user.deptName }</td>
					<td>${user.mail }</td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>

