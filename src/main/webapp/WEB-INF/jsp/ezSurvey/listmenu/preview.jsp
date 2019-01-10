<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="surveyCrtTt2">
	<div class="sryFirst2"></div>
	<span class="sryTxt"><spring:message code='ezSurvey.t39'/></span>
</div>

<div class="prevQsArea logic"></div>

<div class="navi-button logic">
	<div>
		<div id="gotoSecondTab" class="survey-infbttn gotoSecondTab"><img src="/images/ezSurvey/prevstep.png"></div>
		<div id="gotoForthTab"  class="survey-infbttn gotoForthTab" ><img src="/images/ezSurvey/nextstep.png"></div>
		<div id="showLogicMap"  class="survey-infbttn"              ><img src="/images/ezSurvey/logicmap.png"></div>
		<div id="cancelSurvey1" class="survey-infbttn cancelSurvey1"><img src="/images/ezSurvey/cancel.png"  ></div>
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

