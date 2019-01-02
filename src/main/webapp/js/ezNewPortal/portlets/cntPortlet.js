/**
 * 
 */

var useMail = document.getElementById("useMailValue").value;
var useSchedule = document.getElementById("useScheduleValue").value;
var useQuestion = document.getElementById("useQuestionValue").value;
var useApproval = document.getElementById("useApprovalValue").value;
var useCircular = document.getElementById("useCircularValue").value;

if (useMail === "YES") {
	document.getElementById("NewMail3").addEventListener('click', function(){quickMenuOpen('NewMail');});
}

if (useSchedule === "YES") {
	document.getElementById("Schedule3").addEventListener("click", function(){quickMenuOpen('Schedule');});
} 

if (useQuestion === "YES") {
	document.getElementById("Poll3").addEventListener("click", function(){quickMenuOpen('Poll');});
}

if (useCircular === 'YES') {
	document.getElementById("Circular3").addEventListener('click', function(){quickMenuOpen('Circular');});
}

if (useApproval === 'YES') {
	document.getElementById("AprSign3").addEventListener('click', function(){quickMenuOpen('ApprG');});
	document.getElementById("AprProcessing").addEventListener('click', function(){quickMenuOpen('AprProcessing');});
	document.getElementById("AprDraft").addEventListener('click', function(){quickMenuOpen('AprDraft');});
	document.getElementById("AprDeptSusin").addEventListener('click', function(){quickMenuOpen('AprDeptSusin');});
}
