<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	   	<script type="text/javascript">
		   	window.onload=function(){
		   	}
		</script>
		<style>
		</style>
	</head>
		<table class="mainlist_free">
			<tbody style="background-color: rgb(255, 255, 255);">
				<c:if test="${authorDeptList ne null }">
					<c:forEach items="${authorDeptList}" var="dept">
						<tr id="${dept.deptId }" style="cursor: pointer;" class="hover">
							<td align="left" style="width:250px;">${dept.deptName }</td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
		</table>
</html>

