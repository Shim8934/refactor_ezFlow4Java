<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<section class="body_bg1">
			<div id="featured">
				<c:choose>
	            	<c:when test="${not empty sliderList}">
	            		<c:forEach items="${sliderList}" var="slider">
							<img src="${slider.imagePath}" style="width:467px;height:200px"/>
						</c:forEach>
	            	</c:when>
	            	<c:otherwise>
		            	<img src="/images/WebPartSliderCI/img0.png" />
			    		<img src="/images/WebPartSliderCI/img1.png" />
			    		<img src="/images/WebPartSliderCI/img2.png" />
			    		<img src="/images/WebPartSliderCI/img3.png" />
	            	</c:otherwise>
	            </c:choose>
			</div>
		</section>
		
		<link rel="stylesheet" href="<spring:message code='main.e6' />" type="text/css" />
		<link rel="stylesheet" href="/css/orbit-1.2.3.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.orbit-1.2.3.min.js"></script>
		<style type="text/css">
		 	div {
				margin: auto;
		        padding-top:10px;
		    }
		</style>
		<script type="text/javascript">
		    $(window).load(function () {
		        $('#featured').orbit();
		    });
		</script>
	</head>
</html>