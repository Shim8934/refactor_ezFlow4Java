<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="surveyCrtTt2">
	<div class="sryFirst2"></div>
	<span class="sryTxt"><spring:message code='ezSurvey.t39'/></span>
</div>
<div class="questions-wrap">
	<div class="quesBacgr"></div>
	
	<div id="addURLPanel" class="searchPanel off">
		<div class="popupMenu searchDiv">
			<div class="srchTtl"><spring:message code='ezSurvey.t25'/></div>
			<div id="surveyClose" class="closeImgBttn"><ul><li><span></span></li></ul></div>
			<table class="content searchtable">
				<tr>
					<th class="cabSearchTh"><spring:message code='ezSurvey.t82'/></th>
					<td class="searchTblTd"><input id="attfileName" type="text"></td>
				</tr>
				<tr>
					<th class="cabSearchTh"><spring:message code='ezSurvey.t83'/></th>
					<td class="searchTblTd"><input id="attfileUrl" type="text"></td>
				</tr>
			</table>
			<div class="srchBttnDiv" id="searchDivBttn">
				<a class="srchBttn" id="addUrlAttach"  ><span><spring:message code='ezSurvey.t84'/></span></a>
				<a class="srchBttn" id="removeUrlPopup"><span><spring:message code='ezSurvey.t18'/></span></a>
			</div>
		</div>
	</div>
</div>

<div class="navi-button">
	<div>
		<div id="gotoFirstTab" class="survey-infbttn"><img src="/images/ezSurvey/prevstep.png"></div>
		<div id="gotoThirdTab" class="survey-infbttn gotoThirdTab"><img src="/images/ezSurvey/nextstep.png"></div>
		<div id="gotoForthTab" class="survey-infbttn gotoForthTab"><img src="/images/ezSurvey/nextstep.png"></div>
		<div id="cancelSurvey1" class="survey-infbttn cancelSurvey1"><img src="/images/ezSurvey/cancel.png"  ></div>
	</div>
</div>