/* 2018-11-12 홍승비 - 동영상게시판 js 작성(포토게시판 js 카피 후 수정) */
/*
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
	
	var boardId = $("#movieDt").attr("data1");
	var portletId = $("#movieArticle").parent().attr("id");
	portletId = portletId.substring(0, portletId.indexOf("P"));
	
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "/ezNewPortal/getPhotoItemList.do",
		data : {"boardId" : boardId, "page" : photoBoardPage, "photoCount" : 2, "portletId" : portletId},
		success : function(result) {
			if (result.length > 0) {
				var resultCount = result.length;
				var strHTML = "";
				
				strHTML += '<li id="li_0" style="width:50%; height:92%; padding:15px 5px 0px 3px; display:inline-flex; align-items:center;">';
				strHTML += '<video style="width:100%; height:100%; cursor:pointer;" id="video_0" src="' + result[0].filePath + '" data1="' + result[0].boardID + '" data2="' + result[0].itemID + '"'; 
				strHTML += 'onclick="movieItemRead(this)" onmouseover="moviePrePlay(this)" onmouseout="moviePreStop(this)" preload="metadata" muted loop />';
				strHTML += '<img src="/images/ezLadder/btn_play.png" onclick="movieItemRead2(this)" style="position:absolute; display:list-item; width:20%; height:30%; left:16%; top:42%;"/>';
				strHTML += '</li>';				
				strHTML += '<li id="li_1" style="width:50%; height:92%; padding:15px 5px 0px 3px; display:inline-flex; align-items:center;">';
				strHTML += '<video style="width:100%; height:100%; cursor:pointer;" id="video_1" src="' + result[1].filePath + '" data1="' + result[1].boardID + '" data2="' + result[1].itemID + '"'; 
				strHTML += 'onclick="movieItemRead(this)" onmouseover="moviePrePlay(this)" onmouseout="moviePreStop(this)" preload="metadata" muted loop />';
				strHTML += '<img src="/images/ezLadder/btn_play.png" onclick="movieItemRead2(this)" style="position:absolute; display:list-item; width:20%; height:30%; left:64%; top:42%;"/>';
				strHTML += '</li>';

				$("#movieUl").html(strHTML);
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

//동영상 플레이버튼 이미지 클릭 시 게시물읽기
function movieItemRead2(elem) {
	var videoDom = elem.previousElementSibling;
	var ShowAdjacent = "";
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 679) / 2;
	var pLeft = (pwidth - 765) / 2;
	var height = 679;
	
	window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=" + ShowAdjacent + "&itemID=" + videoDom.getAttribute("data2") + "&boardID=" + videoDom.getAttribute("data1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
}

// 동영상에 마우스오버 시 미리보기 플레이
function moviePrePlay(elem) {
	elem.play();
	
}
// 마우스아웃 시 미리보기 일시정지 + 되감기
function moviePreStop(elem) {
	elem.pause();
	elem.currentTime = 0;
}
*/

// 동영상 하나만 띄워줄 경우의 이벤트 핸들러
var video = document.getElementById("mainVideo");
var playButton = document.getElementById("playButton");
var titleDiv = document.getElementById("titleDiv");
var layDiv = document.getElementById("layDIV");
var addThumbnailDiv = document.getElementById("addThumbnail");
function videoHandler(e) {
	if (e.type == 'playing' ) {
		// 재생 중 컨트롤 활성화, 버튼이미지+제목 안보임
		video.controls = true;
		playButton.style.display = "none";
		titleDiv.style.display = "none";
		layDiv.classList.remove("sortablePortlet");
	} else if (e.type == 'pause') {
		// 정지 시 컨트롤 비활성화, 버튼이미지+제목 보임 (하단의 progress bar를 이동하는 경우는 이벤트 제외)
		if (video.seeking == false) {
			video.controls = false;
			playButton.style.display = "";
			titleDiv.style.display = "";
			layDiv.classList.add("sortablePortlet");
		}
	}
}
//동영상이 있는 경우에만 이벤트 리스너/핸들러 추가
if (video != null) {
	video.addEventListener('playing', videoHandler, false);
	video.addEventListener('pause', videoHandler, false);
}

function moviePlay() {
	if (addThumbnailDiv.getAttribute("value") == "Y") {
		document.getElementById("thumbnail").style.display = "none";
		video.style.display = "";
		video.play();
	} else {
		video.play();
	}
	
}
