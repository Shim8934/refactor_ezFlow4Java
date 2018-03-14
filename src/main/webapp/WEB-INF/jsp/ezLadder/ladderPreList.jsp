<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/ezLadder/string_component.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderList.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderPopUp.js"></script>
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		
		<script type="text/javascript">
			$(function() {
				$(document).on("click", "#myLadderList", function() {
					/* ajax로 디테일뷰 가져와 preview div에 뿌리기 */
				});
			});
		</script>
		
</head>
	<body class="popup">
		<h1 id="h1Title" style="height: 20px;">이전 사다리 불러오기</h1>
			<div class="wrap">
				<div class="ladderdiv preList">
					<table class="mainlist">
						<tbody>
							<tr>
								<td colspan="2" style="padding: 0px;">
									<div>
										<input type="text" placeholder="search..." id="searchInput"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="td_gray">ladder title</td>
								<td class="td_gray">ladder type</td>
							</tr>
							<c:forEach items="${list }" var="list">
							<tr id="myLadderList" ladId="${list.ladderId }">
								<td>${list.title }</td>
								<td>${list.type }</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="page_td">
						<%-- <span id="pageL">←</span>
						<c:forEach var="page" begin="1" end="5" varStatus="status">
							<span>${page }, ${status.index } * </span>
						</c:forEach>
						<span id="pageR">→</span>
						페이징...
						 --%>
					</div>
				</div>
				<div class="ladderdiv preview">
				</div>
			</div>
		<button onclick="pop_close_btn()">close</button>
	</body>
</html>