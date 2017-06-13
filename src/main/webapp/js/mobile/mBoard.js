function boardItemList(obj) {	
	location.href = '/mobile/ezBoard/boardItemList.do?boardID=' + $(obj).attr("boardID");
}

function getBoardItemList() {
	$.ajax({
		type : "POST",
		url : "/mobile/ezBoard/getBoardItemList.do",
		dataType : "json",
		data : {
			
		},
		success : function(result) {
			
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}