<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
<div class="layDIV">
	<dl class="portlet_title sortablePortlet" style="position: relative; width: 100%; bottom: 0px; z-index: 1000; border-bottom:none;"></dl>
	<div style="position:relative; top:-46px; height:100%; overflow:hidden;">
		<div class="rolling" id="roll_featured">
		<c:choose>
			<c:when test="${not empty sliderList}">
				<c:forEach items="${sliderList}" var="slider">
					<c:choose>
						<c:when test="${fn:substring(slider.url, 0, 4) eq 'http' }">
							<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('${slider.url }')"/>
						</c:when>
						<c:otherwise> 
							<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('http://${slider.url }')" />
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
				<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
			</c:otherwise>
		</c:choose>
	</div>
</div>
</body>
</html>