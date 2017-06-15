function boardItemList(obj) {	
	location.href = '/mobile/ezBoard/boardItemList.do?type=' + $(obj).attr("type") + '&boardID=' + $(obj).attr("boardID");
}

function getBoardItemList() {
	$.ajax({
		type : "POST",
		url : "/mobile/ezBoard/getBoardItemList.do",
		dataType : "json",
		data : {
			type : type,
			boardID : boardID
		},
		success : function(result) {
			var contentList = "";
			
			list = result.mBoardItemList;
			list.forEach(function(vo, index) {
				contentList += "<li>";
				contentList += "<a class='ui-btn ui-btn-icon-right ui-icon-carat-r' href='/mobile/ezBoard/getBoardItem.do?'>";
				contentList += "<label>";
				contentList += "<h2 style='font-size:12px'>" + vo.title + "</h2>";
				contentList += "<p class='ui-li-aside'>" + vo.writeDate + "</p>";
				contentList += "<p>" + vo.writerName + "(" + vo.writerDeptName + ")</p>";
				contentList += "</label>";
				contentList += "</a>";
				contentList += "</li>";
			});
			
			contentList += "<li style='background-color: transparent;text-align:center'>";
			contentList += "P A G I N G";
			contentList += "</li>";
			

			$("#boardItemList > div[class='ui-content'] > ul[data-role='listview']").html("");
			$("#boardItemList > div[class='ui-content'] > ul[data-role='listview']").append(contentList);
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
	});
}