/* 공지사항 데이터 조합 */
var assembleNoticeList = function(noticeList) {
	/* HTMLColllection에도 forEach 추가*/
	HTMLCollection.prototype.forEach = Array.prototype.forEach;
	var str = '';
	var viewCnt = 3; // 보여주는 공지사항 갯수
	var boardId = '';
	var noticeDetail = function() {
		var height = window.screen.availHeight;
		var width = window.screen.availWidth;
		var top = (height - 720) / 2;
		var left = (width - 765) / 2;
		var option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top='+top+',left='+left;
		
		if(this.getAttribute('data3') === "3" || this.getAttribute('data3') === "4") {
			window.open('/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID='+ this.getAttribute('data1')+'&boardID='+ this.getAttribute('data2'), "", option, "");
		} else if (this.getAttribute('data3') == "7") {
			 top = (height - 679) / 2;
			 left = (width - 765) / 2;
			 
			 option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=679,width=765,top='+top+',left='+left;
			 window.open('/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID='+ this.getAttribute('data1')+'&boardID='+ this.getAttribute('data2'), "", option, "");
		   } else {
			window.open('/ezBoard/boardItemView.do?showAdjacent=&itemID='+ this.getAttribute('data1')+'&boardID='+ this.getAttribute('data2'), "", option, "");
		}
	}
	
	var noticePlus = function() {
		//console.log('boardId', boardId);
		window.open("/ezBoard/boardMainRedirect.do?boardID=" + boardId, "main", "");
	}
	var dataAssembler = function(data, index) {	
		index = (index*1 + 1); // 혹시 모르니 int형태로 변환
		boardId = data.boardID;
		
		//오늘날짜 구하기
		var today = new Date();
		var writeDate = new Date(data.writeDate);
		var date = today.getDate();
		
		today.setDate(date - 1);
		
		var text = "";
		
		if (today < writeDate) {
			text = '<li class="notiLI" data1="'+data.itemID+'" data2="'+data.boardID+'" data3="'+data.guBun+'"><dl class="notiDL0'+index+'"><dt class="noti_num">'+index+'</dt><dt class="noti_new">N</dt><dd class="noti_text">' + ConvertCharToEntityReference(data.title) + '</dd></dl></li>';
		} else {
			text = '<li class="notiLI" data1="'+data.itemID+'" data2="'+data.boardID+'" data3="'+data.guBun+'"><dl class="notiDL0'+index+'"><dt class="noti_num">'+index+'</dt><dt class="N"></dt><dd class="noti_text">' + ConvertCharToEntityReference(data.title) + '</dd></dl></li>'; 
		}
		return text;
	};	
	if (noticeList) {
		str += "<ul class='noti_portlet_list'>";
		noticeList.forEach(function(item, index){
			str += dataAssembler(item, index);
		});
	} else {
		str += "<ul class='portlet_list'>";
		str += "<dl class='nodata'>"
		str += "<dt>"
		str += "<img src='/images/ezNewPortal/nodata.png'>"
		str += "</dt>"
		str += "<dd>&#34;"+messages.strLang14+"&#34;</dd>"
		str += "</dl>"
	}

	var noticeCnt = str.match(/notiLI/g); // 공지사항 갯수 확인.
	if (noticeCnt && noticeCnt.length < viewCnt) {
		var cnt = noticeCnt === null ? 0 : noticeCnt.length;
		for(var i=cnt; i<viewCnt; i++) {
			str += '<li class="notiLI"><p class="noti_nodata"></p></li>';
		}
	}
	
	str += "</ul>";
	document.getElementById('BoardList_NewBoard').innerHTML = str;
	
	document.getElementsByClassName('notiLI').forEach(function(item, index) {
		if(item.getAttribute('data1')) {
			item.addEventListener('click', noticeDetail);	
		}
	});
	
	document.getElementById('noticePlus').addEventListener('click', noticePlus);
}
var portletId = $(".notice").parent().attr("id");
portletId = portletId.substring(0, portletId.indexOf("P"));

/* [포틀릿] 공지사항 리스트 */ 
var getNoticePortletList = function () {
	var xhr = new XMLHttpRequest();
	xhr.onload = function () {
		if(xhr.status >= 200 && xhr.status < 300) {
			var noticeList = JSON.parse(xhr.responseText).noticeList;
			assembleNoticeList(noticeList);
		} else {
			console.error(xhr.responseText);
		}
	};
	xhr.open('GET', '/ezNewPortal/getNoticePortlet.do?portletId='+portletId);
	xhr.send();
};

var noticePortletLoadFunc = function () {
	getNoticePortletList();	
}
