<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="survey-title"></div>

<div class="prevQsArea logic"></div>

<div class="survey-bttn-panel">
	<div class="btnpositionSurvey">
		<a class="imgbtnSurvey gotoFirstTab"><span><spring:message code='ezSurvey.t91'/></span></a>
		<a class="imgbtnSurvey gotoSecondTab"><span><spring:message code='ezSurvey.t92'/></span></a>
		<a class="imgbtnSurvey imgbtnSurvey_save" id="showLogicMap"><span><spring:message code='ezSurvey.t93'/></span></a>
		<a class="imgbtnSurvey imgbtnSurvey_save gotoForthTab"><span><spring:message code='ezSurvey.t89'/></span></a>
		<a class="imgbtnSurvey cancelSurvey"><span><spring:message code='ezSurvey.t18'/></span></a>
	</div>
</div>

<div id="logicPanel" class="logicPanel off">
	<div class="popup-header">
		<div class="popup-title"><spring:message code='ezSurvey.t86'/></div>
		<div id="closeLogicPl" class="closeImgBttn"><ul><li><span></span></li></ul></div>
	</div>
	<div class="popup-body">
		<div class="logicMapWrap">
			<div class="logicTree" id="logicMap"></div>
		</div>
	</div>
</div>

