<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="surveyinfo-wrap">
	<div>
		<div>
			<input class="info-input-ttl" placeholder="<spring:message code='ezSurvey.t39'/>">
			<input class="info-input-pp"  placeholder="<spring:message code='ezSurvey.t40'/>">
		</div>
		
		<div class="survey-otherinf">
			<div class="survey-infrow">
				<span><spring:message code="ezSurvey.t38"/></span>
				<div>
					<input type="text" id="Sdatepicker" class="srchDate" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" class="srchDate" readonly="readonly">
				</div>
			</div>
			<div class="survey-infrow">
				<span><spring:message code="ezSurvey.t41"/></span>
				<select>
					<option><spring:message code="ezSurvey.t42"/></option>
					<option><spring:message code="ezSurvey.t43"/></option>
				</select>
				<span><spring:message code="ezSurvey.t44"/></span>
				<input class="date-input">
				<span><spring:message code="ezSurvey.t45"/></span>
			</div>
			<div class="survey-infrow">
				<span><spring:message code="ezSurvey.t46"/></span>
				<select>
					<option><spring:message code="ezSurvey.t47"/></option>
					<option><spring:message code="ezSurvey.t48"/></option>
				</select>
				<span><spring:message code="ezSurvey.t49"/></span>
				<select>
					<option><spring:message code="ezSurvey.t50"/></option>
					<option><spring:message code="ezSurvey.t51"/></option>
				</select>
			</div>
			<div class="survey-infrow">
				<span><spring:message code="ezSurvey.t52"/></span>
				<select id="selectTarget">
					<option><spring:message code="ezSurvey.t53"/></option>
					<option><spring:message code="ezSurvey.t54"/></option>
				</select>
				<span class="target-select" id="targetBttn"><spring:message code="ezSurvey.t55"/></span>
			</div>
		</div>
	</div>
</div>

<div class="survey-attach">
	<div class="survey-dropzone">
		<div class="mainzone"></div>
	</div>
	<div class="survey-attbttn"><div><spring:message code="ezSurvey.t56"/></div></div>
</div>

<div style="float: left;">
	<div class="survey-infbttn">
		<img src="/images/ezSurvey/nextstep.png">
	</div>
	<div class="survey-infbttn">
		<img src="/images/ezSurvey/cancel.png">
	</div>
</div>











