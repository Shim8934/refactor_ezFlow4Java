/**
 * 
 */
function viewQstList() {
	window.open("/ezBoard/boardMain.do?func=3","main");		    	
}

function votePoll() {
	var qstId = $(".votePortlet").attr("id");
	qstId = qstId.substring(1);

	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezPoll/checkPoll.do",
		data : {
			qstId : qstId
		},
		success: function(data) {		    			
			var result = JSON.parse(data).result;					

			if (result == "Normal") {
				window.open("/ezBoard/boardMain.do?func=3&qstId=" + qstId, "main");
			}
			else {
				alert(messages.strLang13);
				window.location.reload();
			}
		},
		error: function(error) {
			alert(error);
		}
	});

}