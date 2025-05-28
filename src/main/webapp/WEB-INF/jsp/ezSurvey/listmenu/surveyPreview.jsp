<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>

<div class="surveyinfo-wrap">
	<div class="survey-nminfo">
		<div id="svTitle" class="survey-title"></div>
	</div>
</div>

<div class="surveyinfo-wrap" id="surveyInfConfirm">
	<div class="surveyinfopp-wrap">
		<div class="survey-purpose" id="cf-purpose"></div>
	</div>
	<div class="survey-otherinf">
		<table class="content surveyContent">
			<tr>
				<th class="left-Th"><spring:message code="ezSurvey.t38"/></th> <%-- start date && end date setting --%>
				<td class="right-Td">
					<div class="surveyinf-divcf">
						<span id="cf-startDate"></span>
						<img class="ui-datepicker-trigger bnk" src="/images/ezSurvey/calendar-month.png">
						&nbsp;~&nbsp;
						<span id="cf-endDate"></span>
						<img class="ui-datepicker-trigger bnk" src="/images/ezSurvey/calendar-month.png">
					</div>
				</td>
				<th class="left-Th"><spring:message code="ezSurvey.t101"/></th> <%-- open public result days setting --%>
				<td class="right-Td"><div id="public-days" class="surveyinf-divcf"></div></td>
			</tr>
			<tr>
				<th class="left-Th"><spring:message code="ezSurvey.t41"/></th> <%-- public setting --%>
				<td class="right-Td"><div id="public-cfdiv" class="surveyinf-divcf"></div></td>
				<th class="left-Th"><spring:message code="ezSurvey.t46"/></th> <%-- anonymous setting --%>
				<td class="right-Td"><div id="cf-anoynymous" class="surveyinf-divcf"></div></td>
			</tr>
			<tr>
				<th class="left-Th"><spring:message code="ezSurvey.t112"/></th> <%-- mail setting --%>
				<td class="right-Td"><div id="cf-mail" class="surveyinf-divcf"></div></td>
				<th class="left-Th"><spring:message code="ezSurvey.t113"/></th> <%-- popup setting --%>
				<td class="right-Td"><div id="cf-popup" class="surveyinf-divcf"></div></td>
			</tr>
			<tr>
				<th class="left-Th"><spring:message code="ezSurvey.t30"/></th> <%-- respondent setting --%>
				<td class="right-Td"><div id="cf-userdiv" class="surveyinf-divcf flex-cf"></div></td>
				<th class="left-Th"><spring:message code="ezSurvey.t49"/></th> <%-- multiple select setting --%>
				<td class="right-Td"><div id="cf-multiple" class="surveyinf-divcf"></div></td>
			</tr>
		</table>
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
			<div class="popup-wrapdiv">
                <table class="mainlist user-tbl" id="userResult-tblmain"></table>
            </div>
		</div>
	</div>
</div>

<div class="attach-zone off" id="surveyAttConfirm">
	<div>
		<div class="mainzone">
			<div class="fileList">
				<ul class="ulFiles" id="cf-attach"></ul>
			</div>
		</div>
	</div>
</div>


<div class="confirmQsArea"></div>

<div class="survey-bttn-panel">
	<div class="btnpositionSurvey">
		<a class="imgbtnSurvey imgbtnSurvey gotoThirdTab"><span><spring:message code='ezSurvey.t92'/></span></a>
		<a class="imgbtnSurvey imgbtnSurvey_save" id="saveSurvey"><span><spring:message code='ezSurvey.t90'/></span></a>
		<a class="imgbtnSurvey cancelSurvey"><span><spring:message code='ezSurvey.t18'/></span></a>
	</div>
</div>