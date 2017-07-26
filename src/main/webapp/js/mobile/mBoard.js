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
				titleImage = "";
				titleImage2 = "";
				oneLineCnt = "";
				style = "font-size:12px;";
				
				contentList += "<li>";
				contentList += "<a class='ui-btn ui-btn-icon-right ui-icon-carat-r' href='/mobile/ezBoard/getBoardItem.do?'>";
				contentList += "<label>";
				
//                if (getNodeText(oDatas[3]) == "1") {
//                    titleImage = titleImage + "<img src='/images/i_urgency.gif'>&nbsp;";
//                }
//                if (getNodeText(oDatas[6]) == "Y") {
//                    titleImage = titleImage + "<img src='/images/i_new.gif'>&nbsp;";                        
//                }
//                if (getNodeText(oDatas[4]) == "0") 
//                    objTd.style.fontWeight = "BOLD";
//
//                if (getNodeText(oDatas[10]) != "0" && Use_OneLineCount == "YES")
//                    titleOneLineCnt = "<span style='color:#c64200'>[" + getNodeText(oDatas[10]) + "]</span>";
				
				if (vo.notice == "1") {
					titleImage = "<img src='/images/i_notice.gif'>";
				}
				
				//긴급게시일때 제목앞에 느낌표 image
				if (vo.importance == "1") {
					titleImage2 = "<img src='/images/i_urgency.gif'>";
				}
				
				//writeDate 오늘날짜 1일보다 작게 차이나면 new
//				if (getNodeText(oDatas[6]) == "Y") {
//					titleImage = titleImage + "<img src='/images/i_new.gif'>&nbsp;";                        
//				}
				
				for (var i = 1; i < parseInt(vo.itemLevel); i++) {
					titleImage += "&nbsp;";
					
					if (i == parseInt(vo.itemLevel) - 1) {
						titleImage += "<img src='/images/i_rep.gif'>&nbsp;";
					}
				}
				
                if (vo.oneLineCnt != 0) {
                	oneLineCnt = "[" + vo.oneLineCnt + "]";
                }
                
				contentList += "<h2 style='" + style + "'>" + titleImage + titleImage2 + vo.title + oneLineCnt + "</h2>";
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

//글읽기 화면
function boardItem() {
	
}

//글정보 조회
function getBoardItem() {
	
}

//글 수정화면
function editBoardItem() {
	
}

//글 저장
function saveBoardItem() {
	
}