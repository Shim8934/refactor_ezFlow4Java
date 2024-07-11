/**
 * 
 */

var useMail = document.getElementById("useMailValue").value;
var useSchedule = document.getElementById("useScheduleValue").value;
//var useQuestion = document.getElementById("useQuestionValue").value;
var useSurvey = document.getElementById("useSurveyValue").value;
var useApproval = document.getElementById("useApprovalValue").value;
var useCircular = document.getElementById("useCircularValue").value;

if (useMail === "YES") {
	document.getElementById("NewMail3").addEventListener('click', function(){quickMenuOpen('NewMail');});
}

if (useSchedule === "YES") {
	document.getElementById("Schedule3").addEventListener("click", function(){quickMenuOpen('Schedule');});
} 
/*
if (useQuestion === "YES") {
	document.getElementById("Poll3").addEventListener("click", function(){quickMenuOpen('Poll');});
}
*/
if (useSurvey === "YES") {
	document.getElementById("Survey3").addEventListener("click", function(){quickMenuOpen('Survey');});
}

// 2024-05-28 조수빈 - 디자인 개선에서 회람판 버튼이 제거되어 주석처리
//if (useCircular === 'YES') {
//	document.getElementById("Circular3").addEventListener('click', function(){quickMenuOpen('Circular');});
//}

if (useApproval === 'YES') {
	document.getElementById("AprSign3").addEventListener('click', function(){quickMenuOpen('ApprG');});
	document.getElementById("AprProcessing").addEventListener('click', function(){quickMenuOpen('AprProcessing');});
	document.getElementById("AprDraft").addEventListener('click', function(){quickMenuOpen('AprDraft');});
	// 2024-05-28 조수빈 - 디자인 개선에서 부서수신함 버튼이 제거되어 주석처리
	//	document.getElementById("AprDeptSusin").addEventListener('click', function(){quickMenuOpen('AprDeptSusin');});
}

var getCountList = function () {
	var request = new XMLHttpRequest();
	request.open('GET', '/ezNewPortal/getCountList.do', false);
	request.setRequestHeader('Content-Type', 'application/json');
	var companiesHTML = "";

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			if (request.responseText == null) {
				return;
			}
			
			var result = JSON.parse(request.responseText);
			
			var useMail = result.useMail;
			var useApproval = result.useApproval;
			var useCircular = result.useCircular;
			var useQuestion = result.useQuestion;
			var useSchedule = result.useSchedule;
			
			if (useMail === "YES") {
				document.getElementById("NewMail3").innerHTML = "";
				var iconDT = document.createElement("dt");
				iconDT.className = "icon";
				
				var iconSpan = document.createElement("span");
				iconSpan.className = "icon_mail";
				
				iconDT.appendChild(iconSpan);
				
				var textDT = document.createElement("dt");
				textDT.className = "txt";
				textDT.textContent = messages.strLang25;
				
				var targetElem = document.getElementById("NewMail3");
				targetElem.appendChild(iconDT);
				targetElem.appendChild(textDT);
				
				var unreadMailCount = Number(result.unreadMailCount);
				
				if (unreadMailCount == 0) {
					setZeroIcon("NewMail3");
				} else if (unreadMailCount > 999) {
					setCountPlusIcon("NewMail3");
				} else {
					setCount("NewMail3", unreadMailCount);
				}
			} else {
				noUseMenu("NewMail3");
			}
			
			if (useApproval === "YES") {
				document.getElementById("AprSign3").innerHTML = "";
				var iconDT = document.createElement("dt");
				iconDT.className = "icon";
				
				var iconSpan = document.createElement("span");
				iconSpan.className = "icon_approval";
				
				iconDT.appendChild(iconSpan);
				
				var textDT = document.createElement("dt");
				textDT.className = "txt";
				textDT.textContent = messages.strLang26;
				
				var targetElem = document.getElementById("AprSign3");
				targetElem.appendChild(iconDT);
				targetElem.appendChild(textDT);
				
				var approvalCount = Number(result.approvalCount);
				
				if (approvalCount == 0) {
					setZeroIcon("AprSign3");
				} else if (approvalCount > 999) {
					setCountPlusIcon("AprSign3");
				} else {
					setCount("AprSign3", approvalCount);
				}
				
				document.getElementById("AprProcessing").innerHTML = "";
				var iconDT2 = document.createElement("dt");
				iconDT2.className = "iconCircle iconcToward";
				
				var iconSpan2 = document.createElement("span");
				iconSpan2.className = "iconCommon iconToward";
				
				iconDT2.appendChild(iconSpan2);
				
				var textDT2 = document.createElement("dt");
				textDT2.className = "iconText";
				textDT2.textContent = messages.strLang30;
				
				var targetElem2 = document.getElementById("AprProcessing");
				targetElem2.appendChild(iconDT2);
				targetElem2.appendChild(textDT2);
				
				var approvalProgressingCount = Number(result.approvalProgressingCount);
				
				if (approvalProgressingCount == 0) {
					setZeroIcon("AprProcessing");
				} else if (approvalProgressingCount > 999) {
					setCountPlusIcon("AprProcessing");
				} else {
					setCount("AprProcessing", approvalProgressingCount);
				}

				document.getElementById("AprDraft").innerHTML = "";
				var iconDT3 = document.createElement("dt");
				iconDT3.className = "iconCircle iconcReturn";
				
				var iconSpan3 = document.createElement("span");
				iconSpan3.className = "iconCommon iconReturn";
				
				iconDT3.appendChild(iconSpan3);
				
				var textDT3 = document.createElement("dt");
				textDT3.className = "iconText";
				textDT3.textContent = messages.strLang31;
				
				var targetElem3 = document.getElementById("AprDraft");
				targetElem3.appendChild(iconDT3);
				targetElem3.appendChild(textDT3);
				
				var approvalDraftCount = Number(result.approvalDraftCount);
				
				if (approvalDraftCount == 0) {
					setZeroIcon("AprDraft");
				} else if (approvalDraftCount > 999) {
					setCountPlusIcon("AprDraft");
				} else {
					setCount("AprDraft", approvalDraftCount);
				}

				document.getElementById("AprDeptSusin").innerHTML = "";
				var iconDT4 = document.createElement("dt");
				iconDT4.className = "iconCircle iconcReceive";
				
				var iconSpan4 = document.createElement("span");
				iconSpan4.className = "iconCommon iconReceive";
				
				iconDT4.appendChild(iconSpan4);
				
				var textDT4 = document.createElement("dt");
				textDT4.className = "iconText";
				textDT4.textContent = messages.strLang32;
				
				var targetElem4 = document.getElementById("AprDeptSusin");
				targetElem4.appendChild(iconDT4);
				targetElem4.appendChild(textDT4);
				
				var approvalDeptSusinCount = Number(result.approvalDeptSusinCount);
				
				if (approvalDeptSusinCount == 0) {
					setZeroIcon("AprDeptSusin");
				} else if (approvalDeptSusinCount > 999) {
					setCountPlusIcon("AprDeptSusin");
				} else {
					setCount("AprDeptSusin", approvalDeptSusinCount);
				}
			} else {
				noUseMenu("AprSign3");
				noUseMenu("AprProcessing");
				noUseMenu("AprDraft");
				noUseMenu("AprDeptSusin");
			}
			
			if (useCircular === "YES") {
				document.getElementById("Circular3").innerHTML = "";
				var iconDT = document.createElement("dt");
				iconDT.className = "iconCircle iconcBoard";
				
				var iconSpan = document.createElement("span");
				iconSpan.className = "iconCommon iconBoard";
				
				iconDT.appendChild(iconSpan);
				
				var textDT = document.createElement("dt");
				textDT.className = "iconText";
				textDT.textContent = messages.strLang29;
				
				var targetElem = document.getElementById("Circular3");
				targetElem.appendChild(iconDT);
				targetElem.appendChild(textDT);
				
				var circularCount = Number(result.circularCount);
				
				if (circularCount == 0) {
					setZeroIcon("Circular3");
				} else if (circularCount > 999) {
					setCountPlusIcon("Circular3");
				} else {
					setCount("Circular3", circularCount);
				}
			} else {
				noUseMenu("Circular3");
			}
			
			if (useQuestion === "YES") {
				document.getElementById("Poll3").innerHTML = "";
				var iconDT = document.createElement("dt");
				iconDT.className = "iconCircle iconcVote";
				
				var iconSpan = document.createElement("span");
				iconSpan.className = "iconCommon iconVote";
				
				iconDT.appendChild(iconSpan);
				
				var textDT = document.createElement("dt");
				textDT.className = "iconText";
				textDT.textContent = messages.strLang28;
				
				var targetElem = document.getElementById("Poll3");
				targetElem.appendChild(iconDT);
				targetElem.appendChild(textDT);
				var pollCount = Number(result.pollCount);
				
				if (pollCount == 0) {
					setZeroIcon("Poll3");
				} else if (pollCount > 999) {
					setCountPlusIcon("Poll3");
				} else {
					setCount("Poll3", pollCount);
				}
			} else {
				noUseMenu("Poll3");
			}
			
			if (useSchedule === "YES") {
				document.getElementById("Schedule3").innerHTML = "";
				var iconDT = document.createElement("dt");
				iconDT.className = "iconCircle iconcSchedule";
				
				var iconSpan = document.createElement("span");
				iconSpan.className = "iconCommon iconSchedule";
				
				iconDT.appendChild(iconSpan);
				
				var textDT = document.createElement("dt");
				textDT.className = "iconText";
				textDT.textContent = messages.strLang27;
				
				var targetElem = document.getElementById("Schedule3");
				targetElem.appendChild(iconDT);
				targetElem.appendChild(textDT);
				
				var scheduleCount = Number(result.scheduleCount);
				
				if (scheduleCount == 0) {
					setZeroIcon("Schedule3");
				} else if (scheduleCount > 999) {
					setCountPlusIcon("Schedule3");
				} else {
					setCount("Schedule3", scheduleCount);
				}
			} else {
				noUseMenu("Schedule3");
			}
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	request.send();
}

var noUseMenu = function(targetId) {
	var menuDT = document.createElement("dt");
	menuDT.className = "iconCircle icon";
	var iconCommon = document.createElement("span");
	iconCommon.className = "iconCommon";
	
	menuDt.appendChild(iconCommon);
	
	var textDT = document.createElement("dt");
	textDT.className = "txt";
	textDT.innerHTML = "&nbsp;";
	
	var target = document.getElementById(targetId);
	target.innerHTML = "";
	target.appendChild(menuDT);
	target.appendChild(textDT);
}

var setZeroIcon = function(targetId) {
	var countDD = document.createElement("dd");
	countDD.className = "count countZero";
	countDD.textContent = 0;
	
	document.getElementById(targetId).appendChild(countDD);
}

var setCount = function(targetId, count) {
	var countDD = document.createElement("dd");
	countDD.className = "count";
	countDD.textContent = count;
	
	document.getElementById(targetId).appendChild(countDD);
} 

var setCountPlusIcon = function(targetId) {
	var countDD = document.createElement("dd");
	countDD.className = "count";
	countDD.textContent = "999+";
	
	document.getElementById(targetId).appendChild(countDD);
}