<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>agree_ok</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<c:choose>
			<c:when test="${bCanJoin == 'true'}">
				<script type="text/javascript">
					<%-- 2024-07-16 홍승비 - 실제로 동작하는 URL 호출부로 확인 (/ezCommunity/join.do) --%>
					<%-- 스크립트 태그 내부에서 html 주석을 사용하는 이유는 js엔진을 내장하지 않은 브라우저에 대응하기 위해서이나, 최근 대부분의 브라우저에서는 필요하지 않은 처리임 --%>
					<%-- 해당 페이지의 스크립트 태그 내부에 존재하는 html 주석(<!--...//-->) 내부 코드도 전부 동작하고 있으니 제거하지 않도록 주의 --%>
					<!--
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