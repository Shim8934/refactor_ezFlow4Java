<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="surveyCrtTt2">
	<div class="sryFirst2"></div>
	<span class="sryTxt"><spring:message code='ezSurvey.t39'/></span>
</div>
<div class="surveyinfo-wrap" id="surveyInfConfirm">
	<div class="survey-purpose" id="cf-purpose"></div>
	<div class="survey-otherinf">
		<div class="survey-infrow-pv">
			<span class="survey-bold"><spring:message code="ezSurvey.t38"/></span>
			<span class="inf-survey" id="cf-startDate"></span><span class="survey-pass">~</span><span class="inf-survey" id="cf-endDate"></span>
		</div>
		<div class="survey-infrow-pv" id="public-cfdiv"></div>
		<div class="survey-infrow-pv">
			<span class="survey-bold"><spring:message code="ezSurvey.t46"/></span>
			<span class="inf-survey" id="cf-anoynymous">기명</span>
			<span class="survey-bold"><spring:message code="ezSurvey.t49"/></span>
			<span class="inf-survey" id="cf-multiple">비허용</span>
		</div>
		<div class="survey-infrow-pv">
			<span class="survey-bold"><spring:message code="ezSurvey.t52"/></span>
			<div class="survey-user-pv" id="cf-userdiv">
				<!-- <span class="inf-survey">전체</span> -->
				<span class="inf-survey">응웬바오</span>
				<span class="total-user">[총 12 명]</span>
				<span class="user-more"></span>
			</div>
		</div>
	</div>
	
	<div id="userPanel" class="userPanel off">
		<div class="popup-header">
			<div class="popup-title"><spring:message code='ezSurvey.t75'/></div>
			<div id="closeUserPanel" class="closeImgBttn"><ul><li><span></span></li></ul></div>
		</div>
		<div class="popup-body">
			<table class="mainlist user-tbl">
				<tr>
					<th class="user-field2"><spring:message code='ezSurvey.t57'/></th>
					<th class="center-field" id="th-usertype"><spring:message code='ezSurvey.t76'/></th>
				</tr>
			</table>
			<div class="popup-wrapdiv">
				<table class="mainlist user-tbl" id="user-tblmain"></table>
			</div>
		</div>
	</div>
</div>

<div class="attach-zone off" id="surveyAttConfirm">
	<div class="mainzone">
		<div class="fileList">
			<ul class="ulFiles" id="cf-attach"></ul>
		</div>
	</div>
</div>

<div class="prevQsArea"></div>

<div id="prevBtn">
	<button id="prevQsButton">미리보기</button>
</div>
