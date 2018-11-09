/**
 * 
 */
function photoBoardMovePage(event) {
	var isNext = event.data.isNext;
	
	if (isNext === true) {
		photoBoardPage += 1;
	} else {
		if (photoBoardPage == 1) {
			return;
		} else {
			photoBoardPage -= 1;
		}
	}
	
	var boardId = $(".photo_board").find(".portletText").attr("data1");
	var portletId = $(".photo_board").parent().parent().attr("id");
	portletId = portletId.substring(0, portletId.indexOf("P"));

	$.ajax({
		type : "POST",
		dataType : "json",
		url : "/ezNewPortal/getPhotoItemList.do",
		data : {"boardId" : boardId, "page" : photoBoardPage, "photoCount" : photoCount, "portletId" : portletId},
		success : function(result) {
			if (result.length > 0) {
				var resultCount = result.length;
				var strHTML = "";

				for (var i = 0; i < resultCount; i++) {
					strHTML += "<li>";
					strHTML += "<img src='" + result[i].filePath + "', data1='" + result[i].boardID + "' data2='" + result[i].itemID + "' onclick='photoItemRead(this)'>";
					strHTML += "</li>";

				}

				$("#photoul").html(strHTML);
			} else {
				photoBoardPage = photoBoardPage - 1;
			}
		}
	})
}

function viewMovieBoardList() {
	var boardId = $(".photo_board").find(".portletText").attr("data1");
	window.open("/ezBoard/boardMainRedirect.do?boardID=" + boardId, "main", "");
}

function movieItemRead(elem) {
	var ShowAdjacent = "";
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 679) / 2;
	var pLeft = (pwidth - 765) / 2;
	var height = 679;
	
	window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + elem.getAttribute("data2") + "&boardID=" + elem.getAttribute("data1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
}

// 동영상에 마우스오버 시 미리보기 플레이
function moviePrePlay(elem) {
	elem.play();
	
}

function moviePreStop(elem) {
	elem.pause();
}