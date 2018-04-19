function add_user_change_ulsize(usernum) {
	$("#ladderLineBox ul").css("width", (usernum * 150) + "px");
	$("#ladderCanvas").attr("width", (usernum * 150) + "px");
	
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