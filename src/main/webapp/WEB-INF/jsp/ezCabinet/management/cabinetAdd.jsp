<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="popup cabAddoff" id="cabAddDiv">
	<h1 id="addCabTtl"></h1>
	<div id="cabAddClose" class="cabClose"><ul><li><span></span></li></ul></div>
	
	<div class="cbNameInputDiv">
		<span>▒&nbsp;<spring:message code='ezCabinet.t153'/></span>
		<input id="cabNameTxt1" type="text" maxlength="50">
		<br>
		
	</div>
	<div class="cabdivBttn" id="cabAddBttn">
		<a class="imgbtn"><span><spring:message code='ezCabinet.t79'/></span></a>
		<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
	</div>
</div>