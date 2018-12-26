<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div id="writeInfo" class="writeInfo" style="height: 70px; width: auto;">
	<div id="infoWrapper" class="infoWrapper" style="float: left;width: 70%; height: 100%;">
		<div id="piturWrap" class="piturWrap" style="float: left;height: 50px; padding: 10px; width: 50px;">
			<img alt="" src="/images/ezSurvey/nextstep.png" style="width: 50px; height: 50px;"/>
		</div>
		<div id="infoWrap" class="infoWrap" style="float: left; width: auto; height: 50px; padding: 10px;">
			<strong id="infoName" class="infoName" style="height: 50%;font-size: 17px;color: rgba(0, 115, 230, 0.64);float: left;width: 100%;">작성자 이름</strong>
			<strong id="infoTime" class="infoTime" style="height: 50%;font-size: 17px;width: 100%;float: left;">설문 작성 시간</strong>
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

<div id="" class="" style="height: 70px; background-color: #fff; border: 1px solid #d7d7d7; display: flex;">
	<div class="sryFirst2" style=" width: 10px; background-color: rgba(0, 115, 230, 0.64);"></div>
	<span class="sryTxt" style="height: 70px; line-height: 70px; padding: 0px 10px; font-weight: bold; font-size: 20px;"><spring:message code='ezSurvey.t39'/></span>
</div>

<div id="surveyPurPose" class="surveyPurPose" style="width: auto; height: auto; padding: 15px 0px;">
	<div id="ppContent" class="ppContent" style="width: auto; height: 200px; background-color:white; padding:15px 10px;"></div>
</div>

<div id="prevSurveyWrap" class="prevSurveyWrap">
	<div id="prevSurvey" class="prevSurvey" style="background-color: #fff; padding: 20px; min-height: 400px; margin-bottom: 15px; padding: 15px 0px;"></div>	
</div>


<div class="navi-button">
	<div>
		<div id="gotoForthTab" class="survey-infbttn"><img src="/images/ezSurvey/nextstep.png"></div>
		<div id="cancelSurvey1" class="survey-infbttn"><img src="/images/ezSurvey/cancel.png"  ></div>
	</div>
</div>