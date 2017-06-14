/**
 * 
 */

$(document).ready(function() {
	$.searchApprove = function() {
		alert("Search!");
	}
});

function searchApprove() {
	if ($("#searchApprove").css("display") == "none") {
   		$("#searchApprove").slideDown(250);
   	} else {	
   		$("#searchApprove").slideUp(250);
	} 
}