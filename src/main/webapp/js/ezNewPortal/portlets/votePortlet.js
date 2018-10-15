/**
 * 
 */
function viewQstList() {
	window.open("/ezBoard/boardMain.do?func=3","main");		    	
}

function votePoll() {
	var qstId = $(".voteBtn").attr("id");
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
				alert("투표를 수정하고 있습니다.기다려주세요.");
				window.location.reload();
			}
		},
		error: function(error) {
			alert(error);
		}
	});

}