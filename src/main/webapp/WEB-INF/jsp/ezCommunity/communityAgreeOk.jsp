<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>agree_ok</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:choose>
			<c:when test="${bCanJoin == 'true' }">
				<script type="text/javascript">
					<!--
					window.resizeTo(435,495);
					document.location.href = "join.do?code=<c:out value = '${code}' />";
					//-->
				</script>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${userLevel == '1' || userLevel == '4' }">
						<script type="text/javascript">
							<!--
							alert("<c:out value = '${userInfo.displayName}' /><spring:message code = 'ezCommunity.tt886' />");
							history.go(-1);
							//-->
						</script>
					</c:when>
					
					<c:when test="${userLevel == '0' }">
						<script type="text/javascript">
							<!--
							alert("<c:out value = '${userInfo.displayName}' /><spring:message code = 'ezCommunity.tt887' />");
							history.go(-1);
							//-->
						</script>
					</c:when>
					
					<c:otherwise>
						<c:when test="${userLevel == '3' }">
							<script type="text/javascript">
								<!--
								alert("<c:out value = '${userInfo.displayName}' /><spring:message code = 'ezCommunity.tt888' />");
								self.close();
								//-->
							</script>
						</c:when>
						
						<c:otherwise>
							<script type="text/javascript">
								<!--
								alert("<spring:message code = 'ezCommunity.tt889' />");
								self.close();
								//-->
							</script>
						</c:otherwise>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</head>
	<body>
	
	</body>
</html>