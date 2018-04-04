function ladder_window_resize() {
	/*var win_width = $(window).width() - 17;
	
	$(".setTable").css("width", win_width + "px");
	$("#ladderLineBox").css("width", win_width + "px");*/
	var win_width = $(window).width() - 70;
	
	$(".setTable").css("width", win_width + "px");
	$("#ladderLineBox").css("width", win_width + "px");
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

/** 재사용 사다리 정보 가져오기 */
function getPreLadder(ladderID) {
	var templist = [];
	var ladinfo = [];
	
	$.ajax({
		type: "GET",
		url: "/ezLadder/getLadderGame.do",
		traditional: true,
		dataType: "json",
		async : false,
		data: {
			"ladderId": ladderID,
			"mode": "pre"
		},
		success: function(result) {
			ladinfo["lad"] = result.vo;
			templist = result.list;
			
			console.log(templist);
		}
	});
	
	ladinfo["ladline"] = [];
	for(var i = 0; i < templist.length; i++) {
		ladinfo["ladline"][i] = { "id": templist[i]["userId"], "name": templist[i]["userName"], "name2": templist[i]["userName2"], "item": templist[i]["item"] };
	}
	
	return ladinfo;
}