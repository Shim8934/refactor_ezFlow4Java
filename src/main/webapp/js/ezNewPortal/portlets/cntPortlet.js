/**
 * 
 */

$("#NewMail3").on("click", {"menu" : "NewMail"}, quickMenuOpen);
$("#Schedule3").on("click", {"menu" : "Schedule"}, quickMenuOpen);
$("#Poll3").on("click", {"menu" : "Poll"}, quickMenuOpen);
var useCircular = $('#useCircularValue').val();
if (useCircular == 'YES') {
	$("#Circular3").on("click", {"menu" : "Circular"}, quickMenuOpen);
}
$("#AprSign3").on("click", {"menu" : "ApprG"}, quickMenuOpen);
$("#AprProcessing").on("click", {"menu" : "AprProcessing"}, quickMenuOpen);
$("#AprDraft").on("click", {"menu" : "AprDraft"}, quickMenuOpen);
$("#AprDeptSusin").on("click", {"menu" : "AprDeptSusin"}, quickMenuOpen);