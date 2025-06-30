<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="surveyinfo-wrap">
	<div class="survey-nminfo">
		<div>
			<input id="info-input-ttl" class="info-input-ttl" maxlength="40" placeholder="<spring:message code='ezSurvey.t39'/>">
		</div>
		
		<div class="survey-otherinf">
			<table class="content surveyContent">
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t38"/></th> <%-- start date && end date setting --%>
					<td class="right-Td">
						<input type="text" id="startDate" class="srchDate" readonly size="10">
						&nbsp;~&nbsp;
						<input type="text" id="endDate" class="srchDate" readonly size="10">
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t101"/></th> <%-- open public result days setting --%>
					<td class="right-Td">
						<span class='period-span'><spring:message code="ezSurvey.t44"/></span>
						<input type="number" class="date-input" value="0" tabindex="1" min="0" max=${maxPeriod}>
						<span><spring:message code="ezSurvey.t45"/></span>
					</td>
				</tr>
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t41"/></th> <%-- public setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="publicSpan" value="1" checked></div><spring:message code="ezSurvey.t42"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="publicSpan" value="0" ></div><spring:message code="ezSurvey.t43"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="publicSpan" value="2" ></div><spring:message code="ezSurvey.jih01"/></span>
						</div>
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t46"/></th> <%-- anonymous setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="anonymousSpan" value="0" checked></div><spring:message code="ezSurvey.t47"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="anonymousSpan" value="1"></div><spring:message code="ezSurvey.t48"/></span>
						</div>
					</td>
				</tr>
				<tr class='rspdtList' id='rspdtList2'>
                    <th class="left-Th"><spring:message code="ezSurvey.t41"/></th> <%-- respondent setting --%>
                    <td class="right-Td" colspan="3">
                        <div id="userWrapDiv2" class="user-mainDiv">
                            <a class="imgbtn inf-surveyimg" id="selectResultTargetBtn"><span><spring:message code="ezSurvey.t100"/></span></a>
                            <div class="target-wrapper"><div id="userResultList_div" class="user-listDiv"></div></div>
                        </div>
                    </td>
                </tr>
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t112"/></th> <%-- mail setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="mailSpan" value="1" checked></div><spring:message code="ezSurvey.t114"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="mailSpan" value="0"></div><spring:message code="ezSurvey.t115"/></span>
						</div>
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t113"/></th> <%-- popup setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="popupSpan" value="1" checked></div><spring:message code="ezSurvey.t114"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="popupSpan" value="0"></div><spring:message code="ezSurvey.t115"/></span>
						</div>
					</td>
				</tr>
				<tr>
					<th class="left-Th"><spring:message code="ezSurvey.t30"/></th> <%-- respondent setting --%>
					<td class="right-Td">
						<div class="survey-flexdiv">
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="targetSpan" value="0" checked></div><spring:message code="ezSurvey.t53"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="targetSpan" value="1"></div><spring:message code="ezSurvey.t54"/></span>
						</div>
					</td>
					<th class="left-Th"><spring:message code="ezSurvey.t49"/></th> <%-- multiple select setting --%>
					<td class="right-Td">
						<div>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="multipleSpan" value="1"></div><spring:message code="ezSurvey.t51"/></span>
							<span class="inf-spanTxt"><div class='custom_radio'><input type="radio" name="multipleSpan" value="0" checked></div><spring:message code="ezSurvey.t50"/></span>
						</div>
					</td>
				</tr>
				<tr class='rspdtList' id='rspdtList'>
					<th class="left-Th"><spring:message code="ezSurvey.t55"/></th> <%-- respondent setting --%>
					<td class="right-Td" colspan="3">
						<div id="userWrapDiv" class="user-mainDiv">
							<a class="imgbtn inf-surveyimg" id="targetBttn"><span><spring:message code="ezSurvey.t100"/></span></a>
							<div class="target-wrapper"><div id="userListDiv" class="user-listDiv"></div></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="helpTxt" class="uploadHelp"><spring:message code='ezSurvey.t74'/></div>
	<div class="survey-attach">
		<div class="attach-bttn-div">
			<span style="float:left;">
				<a class="imgbtn imgbck" id="addFileBttn"><span><spring:message code="ezSurvey.t56"/></span></a>
				<a class="imgbtn imgbck" id="addUrlBttn" ><span><spring:message code="ezSurvey.t85"/></span></a>
			</span>
		</div>
		<div class="survey-dropzone">
			<div class="mainzone" id="fileDiv" style="min-height:64px;">
				<div class="fileList off">
					<ul class="ulFiles"></ul>
				</div>
				<div class="divInform">
				</div>
			</div>
		</div>
		<input type="file" id="fileBttn" multiple="multiple" class="hiddenBttn">
	</div>
</div>

<div class="survey-infpp-wrap" id="editorWrap">
	<c:if test="${editor ne 'HWP'}">
		<iframe id="info-input-pp" class="surey-frameeditor" name="info-input-pp" src="/ezEditor/selectEditor.do"></iframe>
	</c:if>
	<c:if test="${editor eq 'HWP'}">
		<iframe id="info-input-pp" class="surey-frameeditor" name="info-input-pp" src="/ezBoard/WHWPEditor.do?type=${mode}"></iframe>
	</c:if>
</div>

<%--맺음말--%>
<div class="survey-otherinf" id="closingWrap">
	<div><span><spring:message code="ezSurvey.closing01"/></span></div>
	<textarea id="closingText"></textarea>
</div>

<div class="survey-bttn-panel">
	<div class="btnpositionSurvey">
		<a class="imgbtnSurvey imgbtnSurvey gotoSecondTab"><span><spring:message code='ezSurvey.t89'/></span></a>
		<a class="imgbtnSurvey cancelSurvey"><span><spring:message code='ezSurvey.t18'/></span></a>
	</div>
</div>