function ladder_window_resize() {
	var win_width = $(window).width() - 20;
	
	$(".setTable").css("width", win_width + "px");
	$("#ladderLineBox").css("width", (win_width - 40) + "px");
}

function add_user_change_ulsize(usernum) {
	$("#ladderLineBox ul").css("width", (usernum * 150) + "px");
	$("#ladderCanvas").attr("width", (usernum * 150) + "px");
}

/** 중복 처리 팝업 */
function popSelectUsertype(attendantList, setFunc) {
	console.log("popSelectUsertype");
   	$("#dialog").dialog({
   		modal: true,
   		buttons: [{
   			text: "조직도에서추가",
   			click: function() { // 조직도에서 추가
   				setFunc(attendantList, "real-xml");
   				$(this).dialog( "close" );
   			} 
   		}, {
   			text: "익명으로추가",
   			click: function() { // 익명으로 추가
				setFunc(attendantList, "anony-xml");
   				$(this).dialog( "close" );
   			}
   		}, {
   			text: "취소",
   			click: function() { // 취소
   				$(this).dialog( "close" );
   			}
   		}]
   	}); 
}
