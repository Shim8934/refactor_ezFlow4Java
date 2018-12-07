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
				<button class="target-select" id="targetBttn"><spring:message code="ezSurvey.t55"/></button>
			</div>
		</div>
	</div>
</div>

<div id="helpTxt" class="uploadHelp off"><spring:message code='ezSurvey.t74'/></div>
<div class="survey-attach">
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
	<div class="survey-attbttn"><div id="addFileBttn"><spring:message code="ezSurvey.t56"/></div></div>
	<input type="file" id="fileBttn" multiple="multiple" class="hiddenBttn">
</div>

<div class="navi-button">
	<div>
		<div id="gotoSecondTab" class="survey-infbttn"><img src="/images/ezSurvey/nextstep.png"></div>
		<div id="cancelSurvey1" class="survey-infbttn"><img src="/images/ezSurvey/cancel.png"  ></div>
	</div>
</div>

<script type="text/javascript" src="${util.addVer('/js/ezSurvey/surveyFile.js')}"></script>
<script>
	(function () {
		var surveyFile = new SurveyFile();
		$.datepicker.regional["<spring:message code='main.t0619' />"] = {
			closeText: "<spring:message code='main.t3' />",
			prevText: "<spring:message code='main.t0604' />",
			nextText: "<spring:message code='main.t0605' />",
			currentText: "<spring:message code='main.t0606' />",
			monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
						"<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
						"<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
						"<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
			monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
							"<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
							"<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
							"<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
			dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
						"<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
						"<spring:message code='main.t0627' />"],
			dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
							"<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
							"<spring:message code='main.t0627' />"],
			dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
							"<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
							"<spring:message code='main.t0627' />"],
			weekHeader: "Wk",
			dateFormat: "yy-mm-dd",
			firstDay: 0,
			isRTL: false,
			duration: 200,
			showAnim: "show",
			showMonthAfterYear: true
		};
		
		$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]);
		initEvents();
		
		function initEvents() {
			var fileUploadBttn      = document.getElementById("fileBttn");
			fileUploadBttn.onchange = function(e) {surveyFile.upload();};
			var addFileBttn         = document.getElementById("addFileBttn");
			addFileBttn.onclick     = function(e) {startUpload();};
			var fileDivElmt         = document.getElementById("fileDiv");
			fileDivElmt.onclick     = function(e) {startUpload();};
			
			fileDivElmt.addEventListener("dragenter", function(e) {surveyFile.dragEnter(e);}, false);
			fileDivElmt.addEventListener("dragover" , function(e) {surveyFile.dragOver(e);} , false);
			fileDivElmt.addEventListener("drop"     , function(e) {surveyFile.upload(e);}   , false);
		}
		
		function startUpload() {document.getElementById("fileBttn").click();}
	}());
</script>