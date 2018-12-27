<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div id="svInfoWrapper" class="svInfoWrapper">
	<div id="wtInfoArea" class="wtInfoArea">
		<div id="wtImgArea" class="wtImgArea">
			<img id="wtImg" class="wtImg" alt="" src="" style="background-color: white;"/>
		</div>
		<div id="wtInfo" class="wtInfo">
			<strong id="wtName" class="wtName" >작성자 이름</strong>
			<strong id="wtTime" class="wtTime" >설문 작성 시간</strong>
		</div>
	</div>
	<!-- 
	<div id="infoBtns" class="infoBtns" style="float:right;width: 220px;height: 100%;">
		<img id="suvyMdf" class="suvyMdf" alt="" src="/images/ezSurvey/xBtn.png" style="width: 50px;height: 50px;padding: 10px;" />
		<img id="suvyDlt" class="suvyDlt" alt="" src="/images/ezSurvey/xBtn.png" style="width: 50px;height: 50px;padding: 10px;" />
		<img id="suvyInfo" class="suvyInfo" alt="" src="/images/ezSurvey/xBtn.png" style="width: 50px;height: 50px;padding: 10px;" />
	</div>
	 -->
</div>

<div id="svTitle" class="svTitle">
	<div class="sryFirst2"></div>
	<span class="sryTxt"><spring:message code='ezSurvey.t39'/></span>
</div>

<div id="svPurpose" class="svPurpose">
	<div id="ppContent" class="ppContent"></div>
</div>

<div class="prevQsArea"></div>

<div class="navi-button">
	<div>
		<div id="gotoSecondTab" class="survey-infbttn gotoSecondTab"><img src="/images/ezSurvey/prevstep.png"></div>
		<div id="gotoThirdTab" class="survey-infbttn gotoThirdTab"><img src="/images/ezSurvey/prevstep.png"></div>
		<div id="saveSurvey" class="survey-infbttn"><img src="/images/ezSurvey/save.png"></div>
		<div id="cancelSurvey1" class="survey-infbttn cancelSurvey1"><img src="/images/ezSurvey/cancel.png"  ></div>
	</div>
</div>