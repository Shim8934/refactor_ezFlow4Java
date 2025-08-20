<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<c:if test="${mode == 'delete' }">
			<c:choose>
				<c:when test="${bIsMyContent == true || sysopCheck == '1' }">
					<script language="javascript">
						alert("<spring:message code='ezCommunity.t571' />");
						document.location.href="/ezCommunity/guestOne.do?code=" + '<c:out value="${code}"/>' + "&mode=list&goToPage=${curPage}&inviteFlag=${inviteFlag}";
					</script>					
				</c:when>
				
				<c:otherwise>
					<script language="javascript">
						alert("<spring:message code='ezCommunity.t572' />");
						document.location.href="/ezCommunity/guestOne.do?code=" + '<c:out value="${code}"/>' + "&mode=list&goToPage=${curPage}&inviteFlag=${inviteFlag}";
					</script>
				</c:otherwise>
			</c:choose>
			
		</c:if>
		
		<c:if test="${mode == 'write' }">
			<script language="javascript">
				alert("<spring:message code='ezCommunity.t573' />");
				document.location.href="/ezCommunity/guestOne.do?code=" + '<c:out value="${code}"/>' + "&mode=list&goToPage=${curPage}&inviteFlag=${inviteFlag}";
			</script>
		</c:if>
		
		<c:if test="${mode == 'edit' }">
			<c:choose>
				<c:when test="${bIsMyContent == true || sysopCheck == '1' }">
					<script language="javascript">
						alert("<spring:message code='ezCommunity.t574' />");
						document.location.href="/ezCommunity/guestOne.do?code=" + '<c:out value="${code}"/>' + "&mode=list&goToPage=${curPage}&inviteFlag=${inviteFlag}";
					</script>					
				</c:when>
				
				<c:otherwise>
					<script language="javascript">
						alert("<spring:message code='ezCommunity.t575' />");
						document.location.href="/ezCommunity/guestOne.do?code=" + '<c:out value="${code}"/>' + "&mode=list&goToPage=${curPage}&inviteFlag=${inviteFlag}";
					</script>
				</c:otherwise>
			</c:choose>
		</c:if>
		
	</head>
	<body>
		<c:out value="${mode}" /> + " : " + <c:out value="${code}" />
	</body>
</html>