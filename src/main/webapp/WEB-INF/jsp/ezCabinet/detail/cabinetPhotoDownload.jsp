<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="popup cabPhotooff" id="cabPhotoDiv">
	<h1><spring:message code='ezCabinet.t145'/></h1>
	<div id="cabDownClose" class="cabClose"><ul><li><span></span></li></ul></div>
	<ul id="photoSelect" class="cabphoselect"></ul>
	<div class="cabdivBttn" id="cabPhotoBttn">
		<a class="cabBttn"><span><spring:message code='ezCabinet.t146'/></span></a>
		<a class="cabBttn"><span><spring:message code='ezCabinet.t79' /></span></a>
		<a class="cabBttn"><span><spring:message code='ezCabinet.t15' /></span></a>
	</div>
</div>