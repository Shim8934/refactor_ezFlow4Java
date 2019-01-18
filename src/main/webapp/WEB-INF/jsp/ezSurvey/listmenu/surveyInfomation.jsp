<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="surveyinfo-wrap">
	<div class="survey-nminfo">
		<div>
			<input id="info-input-ttl" class="info-input-ttl" placeholder="<spring:message code='ezSurvey.t39'/>">
		</div>
		
		<div class="survey-otherinf">
			<%-- <div class="survey-infrow">
				<span><spring:message code="ezSurvey.t38"/></span>
				<div>
					<input type="text" id="startDate" class="srchDate" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="endDate" class="srchDate" readonly="readonly">
				</div>
			</div>
			<div class="survey-infrow">
				<span><spring:message code="ezSurvey.t41"/></span>
				<select id="public-slbox">
					<option><spring:message code="ezSurvey.t42"/></option>
					<option><spring:message code="ezSurvey.t43"/></option>
				</select>
				<span><spring:message code="ezSurvey.t44"/></span>
				<input class="date-input" value="0">
				<span><spring:message code="ezSurvey.t45"/></span>
			</div>
			<div class="survey-infrow">
				<span><spring:message code="ezSurvey.t46"/></span>
				<select id="anonymous-slbox">
					<option><spring:message code="ezSurvey.t47"/></option>
					<option><spring:message code="ezSurvey.t48"/></option>
				</select>
				<span><spring:message code="ezSurvey.t49"/></span>
				<select id="multiple-slbox">
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
				
				<div id="userWrapDiv" class="user-mainDiv">
					<button class="target-select" id="targetBttn"><spring:message code="ezSurvey.t55"/></button>
					<div class="target-wrapper"><div id="userListDiv" class="user-listDiv"></div></div>
				</div>
			</div> --%>
			<table class="content surveyContent" style="width:100%;">
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t38"/></th> <%-- start date && end date setting --%>
					<td class="right-Td">
						<input type="text" id="startDate" class="srchDate" readonly size="10">
						&nbsp;~&nbsp;
						<input type="text" id="endDate" class="srchDate" readonly size="10">
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t46"/></th> <%-- anonymous setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><input type="radio" name="anonymousSpan" value="0" checked><spring:message code="ezSurvey.t47"/></span>
							<span class="inf-spanTxt"><input type="radio" name="anonymousSpan" value="1"><spring:message code="ezSurvey.t48"/></span>
						</div>
					</td>
				</tr>
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t52"/></th> <%-- respondent setting --%>
					<td class="right-Td">
						<div class="survey-flexdiv">
							<span class="inf-spanTxt"><input type="radio" name="targetSpan" value="0" checked><spring:message code="ezSurvey.t53"/></span>
							<span class="inf-spanTxt"><input type="radio" name="targetSpan" value="1"><spring:message code="ezSurvey.t54"/></span>
							<div id="userWrapDiv" class="user-mainDiv">
								<a class="imgbtn inf-surveyimg" id="targetBttn"><span><spring:message code="ezSurvey.t55"/></span></a>
								<div class="target-wrapper"><div id="userListDiv" class="user-listDiv"></div></div>
							</div>
						</div>
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t49"/></th> <%-- multiple select setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><input type="radio" name="multipleSpan" value="1" checked><spring:message code="ezSurvey.t51"/></span>
							<span class="inf-spanTxt"><input type="radio" name="multipleSpan" value="0"><spring:message code="ezSurvey.t50"/></span>
						</div>
					</td>
				</tr>
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t41"/></th> <%-- public setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><input type="radio" name="publicSpan" value="1" checked><spring:message code="ezSurvey.t42"/></span>
							<span class="inf-spanTxt"><input type="radio" name="publicSpan" value="0"><spring:message code="ezSurvey.t43"/></span>
						</div>
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t44"/></th> <%-- open public result days setting --%>
					<td class="right-Td">
						<input type="text" class="date-input" value="0" tabindex="1">
						<span><spring:message code="ezSurvey.t45"/></span>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="helpTxt" class="uploadHelp off"><spring:message code='ezSurvey.t74'/></div>
	<div class="survey-attach">
		<div class="attach-bttn-div">
			<span style="float:left;">
				<a class="imgbtn imgbck" id="addFileBttn"><span><spring:message code="ezSurvey.t56"/></span></a>
				<a class="imgbtn imgbck" id="addUrlBttn" ><span><spring:message code="ezSurvey.t85"/></span></a>
			</span>
		</div>
		<div class="survey-dropzone">
			<div class="mainzone" id="fileDiv">
				<div class="fileList off">
					<ul class="ulFiles"></ul>
				</div>
				<div class="divInform">
					<span><spring:message code='ezSurvey.t72'/></span>
					<span><spring:message code='ezSurvey.t73'/></span>
				</div>
			</div>
		</div>
		<input type="file" id="fileBttn" multiple="multiple" class="hiddenBttn">
	</div>
</div>

<div class="survey-infpp-wrap" id="editorWrap">
	<iframe id="info-input-pp" class="surey-frameeditor" name="info-input-pp" src="/ezEditor/selectEditor.do"></iframe>
</div>

<div class="survey-bttn-panel">
	<div class="btnpositionSurvey">
		<a class="imgbtnSurvey imgbtnSurvey_save gotoSecondTab"><span><spring:message code='ezSurvey.t89'/></span></a>
		<a class="imgbtnSurvey cancelSurvey"><span><spring:message code='ezSurvey.t18'/></span></a>
	</div>
</div>