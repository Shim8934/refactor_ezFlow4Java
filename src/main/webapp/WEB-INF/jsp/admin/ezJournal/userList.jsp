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
			tr:hover{background:#eee; color:#fff;}
		</style>
	</head>
		<table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
			<tbody>
				<tr>
			    	<th style="white-space:normal">
			    		
			        </th>
			    </tr>
			</tbody>
		</table>
		<div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
			<table style="width:100%; border: 1px solid #B6B6B6; class="mainlist">
				<tr>
				    <th style="width: 130px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t68'/></th>
					<th style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></th>
					<th style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></th>
					<th style="font-weight: bold;"><spring:message code='main.t78'/></th>
		        </tr>
		        <c:forEach items="${userList}" var="user">
			        <tr id="${user.userId }">
				        <td style="width: 130px;"><c:out value="${user.deptName }" /></td>
						<td style="width: 90px;" ><c:out value="${user.userName }" /></td>
						<td style="width: 90px;" ><c:out value="${user.jikwi }" /></td>
						<td style="width: 90px;" ><c:out value="${user.mail }" /></td>
					</tr>
		        </c:forEach>
		    </table>
		</div>
		<div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
</html>

