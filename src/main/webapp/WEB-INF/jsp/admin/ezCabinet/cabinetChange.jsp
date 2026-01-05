<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="popup cabChgoff" id="perSettingPanel">
	<h3><spring:message code='ezCabinet.t115'/></h3>
	<div id="cabPChClose" class="cabClose"><ul><li><span></span></li></ul></div>
	
	<table class="content on">
		<tr>
			<th><spring:message code='ezCabinet.t21'/></th>
			<th class="white">
				<div class="custom_radio">
					<input type="radio" name="capType" id="limit" role="limit"   checked><label for="limit" style="cursor:pointer;"><spring:message code='ezCabinet.t113'/></label>
					<input type="radio" name="capType" id="unlimit" role="unlimit"      ><label for="unlimit" style="cursor:pointer;"><spring:message code='ezCabinet.t114'/></label>
				</div>
			</th>
		</tr>
		<tr>
			<th><spring:message code='ezCabinet.t16'/></th>
			<th class="white">
				<input id="basicValue" type="text"/>
				<span><spring:message code='ezCabinet.t17'/></span>
			</th>
		</tr>
	</table>
	<div class="cabdivBttn" id="chgDivBttn">
		<a class="cabBttn"><span><spring:message code='ezCabinet.t112'/></span></a>
		<a class="cabBttn"><span><spring:message code='ezCabinet.t15' /></span></a>
		<a class="cabBttn"><span><spring:message code='ezCabinet.t166'/></span></a>
	</div>
</div></html>