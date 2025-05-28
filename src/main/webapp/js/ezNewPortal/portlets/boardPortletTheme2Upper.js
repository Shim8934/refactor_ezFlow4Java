/* 2023-06-07 홍승비 - 테마2 > 상단 사용자 정보 영역 좌측 하단 > 회사별 공지사항 게시판 표출 영역 추가 */
var theme2NotiBoardID = getTheme2NotiBoardID(); // 게시판 이동을 위해 게시판ID 전역변수 사용

// 회사별 공지사항 게시판의 ID를 리턴
function getTheme2NotiBoardID() {
	var result = "";
	
	$.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezBoard/getDefaultBoardID.do",
		success : function(resultStr) {
			if (resultStr != "") {
				result = resultStr.split(";")[1];
			}
		},
		error : function(e) {
			result = "";
			console.log(e);
		}
	});
	
	return result;
}

// 회사별 공지사항 게시판의 게시물 데이터를 가져오는 함수
function getTheme2NotiBoardItem() {
	if (theme2NotiBoardID != "") {
		// 공지사항 게시판 ID가 존재하는 경우, 버튼 클릭 시 게시판 이동 이벤트 바인드
		$("#theme2Sec1NoticePlusBtn").on("click", theme2NotiBoardBtnClick);
		
		$.ajax({
			type : "GET",
			dataType : "json",
			data : {boardID : theme2NotiBoardID},
			url : "/ezNewPortal/getTheme2NotiBoardItemList.do",
			success : function(result) { 
				// access(접근권한)가 true인 경우에만 게시물 리스트가 리턴됨
				getTheme2NotiBoardItemList_after(result);
			},
			error : function(e) {
				console.log(e);
			}
		});
	}
}

// 회사별 공지사항 게시판의 게시물 데이터를 전달받아 화면에 표출하는 함수
function getTheme2NotiBoardItemList_after(data) {
	var boardList = data.boardList;
	var userLang = data.userLang;
	var boardCount = boardList.length;
	var boardHTML = "";
	
	// 정상적으로 게시물 리스트가 리턴된 경우에만 화면상에 표출, 리턴되지 않은 경우 "데이터가 없습니다" 표출을 유지
	if (boardCount > 0) {
		for (var i = 0; i < boardCount; i++) {
			var item = boardList[i];
			var writer = "";
			if (userLang === "1") {
				writer= item.writerName;
			} else {
				writer = item.writerName2;
			}
			
			boardHTML += "<li onclick='openTheme2NotiBoardItem(\"" + item.itemID + "\", \"" + item.guBun + "\", \"" + item.boardID + "\")'>";
			boardHTML += "<span class='txt'>" + MakeXMLString(item.title) + "</span>";
			boardHTML += "<span class='date'>" + item.startDate.substring(5, 16) + "</span>";
			boardHTML += "<span class='name'>" + writer + "</span>";
			boardHTML += "</li>";
		}

		$("#theme2Sec1NoticeBoardUL").html(boardHTML);
	}
}

function openTheme2NotiBoardItem(pItemID, pType, oBoardID) {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 720) / 2;
    var pLeft = (pwidth - 765) / 2;
    var winPopup = "";
    
    if (pType == "3" || pType == "4") {
	    if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
			var height = 789;
		} else {
			var height = 785;
		}
	    
		pTop = (pheight - 789) / 2;
		pLeft = (pwidth - 790) / 2;

		winPopup = window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=790,top=" + pTop + ",left=" + pLeft, "");
   } else if (pType == "7") {
	   var height = 679;
	   pTop = (pheight - 679) / 2;
	   pLeft = (pwidth - 764) / 2;

	   winPopup = window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
   } else {
	   winPopup = window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
   }
    
    // 게시물 읽기 팝업창 닫히는 경우 게시물 리스트 갱신 이벤트 동작
    winPopup.addEventListener("beforeunload", getTheme2NotiBoardItem);
}

function theme2NotiBoardBtnClick() {
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + encodeURIComponent(theme2NotiBoardID), "main", "");
}
