<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
	
	<c:choose>
		<c:when test="${sysopCheck != '1' }">
			<spring:message code = 'ezCommunity.t447' />
			<%
				if (true) {
					return;
				}
			 %>
		</c:when>
		
		<c:otherwise>
			<c:choose>
				<c:when test="${mode == 'master' }">
					<script type="text/javascript">
					 	window.onload = function () { 
							OpenAlertUI("<spring:message code = 'ezCommunity.t540' />" + "${userName}"+")"+"<spring:message code = 'ezCommunity.t541' />");
							window.parent.parent.close();
							try{
								// 20060720 준호수정
								// 왼쪽 관리 메뉴 reload 에러 수정
								window.parent.parent.opener.location.reload();
							}catch(e){}	
					 	}
					</script>
				</c:when>
				
				<c:otherwise>
					<script type="text/javascript">
						OpenAlertUI("<spring:message code = 'ezCommunity.t540' />${userName}"+")"+"<spring:message code = 'ezCommunity.t543' />");
						window.location.href="/ezCommunity/adminMemberList.do?code=${code}&mode=${mode}";
					</script>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
		
	</c:choose>
	
		
	</head>
	<body>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>