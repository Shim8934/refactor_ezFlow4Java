<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Board Portlet</title>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/boardPortlet.js')}"/>
<script type="text/javascript">
$(function(){
	console.log("${access}");
})
</script>
</head>
<body>
	<article class="customBoard box_shadow" >
		<div class="layDIV">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value="${portletName }"/>
				</dt>
				<dd class="portletPlus" data1="<c:out value='${boardId }'/>">
					<img src="/images/ezNewPortal/portlet_Plus${usedTheme }.png">
				</dd>
			</dl>
			<c:choose>
			<c:when test="${not empty boardList}">
			<ul id="customBoardList" class="portlet_list">
				<c:forEach items="${boardList }" var="item">
					<li onclick="openDoc_section4_Type('${item.itemID}', '${item.guBun }', '${item.boardID}')">
						<span class='txt'>${item.title }</span>
						<span class='date'>${item.startDate }</span>
						<span class='name'>${item.writerName }</span>
					</li>
				</c:forEach>
			</ul>
			</c:when>
			<c:when test="${access eq false }">
					<ul class="portlet_list">
						<dl class="nodata">
							<dt>
								<img src="/images/ezNewPortal/nodata.png">
							</dt>
							<dd>해당 게시판에 대한 권한이 없습니다.</dd>
						</dl>
					</ul>
			</c:when>
			<c:otherwise>
					<ul class="portlet_list">
						<dl class="nodata">
							<dt>
								<img src="/images/ezNewPortal/nodata.png">
							</dt>
							<dd>데이터가 없습니다.</dd>
						</dl>
					</ul>
			</c:otherwise>
			</c:choose>
		</div>
	</article>
</body>
</html>