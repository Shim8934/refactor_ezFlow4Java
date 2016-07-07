<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>right</title>
	</head>
	
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="" name="comm_top" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		<c:choose>
			<c:when test="${cID == '' }">
				<frame src="/admin/ezCommunity/bbsList.do&bName=c_board&type=board" name="comm_main" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
			</c:when>
			
			<c:otherwise>
				<frame src="/ezCommunity/commHome/commHome.do?code = <c:out value = '${cID }' />" name="comm_main" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
			</c:otherwise>
		</c:choose>
	</frameset>
</html>