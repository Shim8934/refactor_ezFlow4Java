var condition = true;
var joinPoll = function (e) {
	var height = window.screen.availHeight;
	var width = window.screen.availWidth;		
	var itemseq = document.getElementById('pollBtn').getAttribute('data1');

	checkJoinPoll(itemseq);
	if (condition) {
		var top = (height - 370) / 2;
		var left = (width - 300) / 2;
		var option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=400px,width=455px,top=' + top + ',left=' + left;
		var url = '/ezPersonal/wpLightPoll.do';			
	} else {
		alert(messages.strLang34);
		var top = (height - 455) / 2;
		var left = (width - 400) / 2;
		var option = 'height=400px,width=455, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=' + top + ',left = ' + left; 
		var url = '/ezPersonal/pollResult.do?itemSeq=' + itemseq;
	}

	window.open(url, '', option, '');
}

var checkJoinPoll = function(itemSeq) {
	$.ajax({
		type: "POST",
		dataType: "text",
		async: false,
		url: "/admin/ezPersonal/checkJoinPoll.do",
		data: {itemseq: itemSeq},
		success: function(result) {
			if(result === "OK") {
				condition = true;
			} else {
				condition = false;
			}
		}
	});
}

var pollPlus = function () {
	var height = window.screen.availHeight;
	var width = window.screen.availWidth;
	var top = (height - 500) / 2;
	var left = (width - 765) / 2;
	   
	window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=665,width=765,top=" + top + ",left=" + left, "");
}

var nodata = function () {
	var str = '<dl class="nodata"><dt><img src="/images/kr/main/noData_sIcon.png"></dt><dd>'+ messages.strLang1 +'</dd></dl>';
	document.getElementById('pollInfo').innerHTML = str;
	document.getElementById('pollPlus').addEventListener('click', pollPlus);
}

var assemblePollList = function (poll) {
	HTMLCollection.prototype.forEach = Array.prototype.forEach;
	
	// document.getElementById('pollList').innerHTML = '';
	
	var answerList = poll.answerList;
	var str = '';
	var itemSeq = poll.pollInfo.itemSeq;
	
	/* 2023-06-01 홍승비 - 빠른설문 포틀릿 > 디자인 개선을 위해 전체적인 태그 구성 및 스타일 수정 */
	/*
	str += '<p class="pollTitle" id="pollTitle"></p>';
	str += '<p class="pollBtn" id="pollBtn" data1="' + itemSeq +'">' + messages.strLang24 + '</p>';	
	str += '<div class="pollList">';
	*/
	str += '<div class="voteTitle_all"><p class="voteTitle" id="pollTitle"></p>';
	str += '<p class="voteBtn" id="pollBtn" data1="' + itemSeq +'">' + messages.strLang24 + '</p></div>';
	str += '<ul class="portlet_list  voteList">';
	
	for (var i = 0; i < answerList.length; i++) {
		if (answerList[i].answer.trim() !== '') {
			var percentage = 0;
			
			if (answerList[i].count) {
				percentage = (answerList[i].count / poll.pollInfo.count * 1) * 100;	
			}
			/*
			str += '<li class="pollListLi pollList_0'+ answerList[i].result +'">';
			str += '<div class="pollT" style="width:22%"><span class="Vnum">'+ answerList[i].result +'</span><span class="Vtext">'+ answerList[i].answer +'</span></div>';
			str += '<div class="percent" id="percent1">' + Math.round(percentage) + '%</div>';
			str += '<div class="pollGraph" id="divGraph' + answerList[i].result + '" style="display: block;">';
			str += '	<span id="pollGraph' + answerList[i].result + '" style="width:'+ percentage +'%"></span>';
			str += '</div>';
			str += '</li>';
			*/
			str += '<li class="voteList_0'+ answerList[i].result +'">';
			str += '<div class="voteT"><span class="Vnum">'+ answerList[i].result +'</span><span class="Vtext"> ' + answerList[i].answer +'</span></div>';
			str += '<div class="percent" id="percent1">' + Math.round(percentage) + '%</div>';
			str += '<div class="voteGraph" id="divGraph' + answerList[i].result + '" style="display: block;">';
			str += '	<span id="pollGraph' + answerList[i].result + '" style="width:'+ percentage +'%"></span>';
			str += '</div>';
			str += '</li>';
		}
	}
	str += '</ul>';
	
	document.getElementById('pollInfo').innerHTML = str;
	document.getElementById('pollTitle').textContent = poll.pollInfo.pollTitle;
	document.getElementById('pollBtn').addEventListener('click', function() {
		if (poll.pollInfo.result != 0) {
			joinPoll(true, poll.pollInfo.itemSeq);
		} else {
			joinPoll(false, poll.pollInfo.itemSeq);
		}
		
	});
	document.getElementById('pollPlus').addEventListener('click', pollPlus);
};

/* 설문조사 리스트 */
var getPollPortletList = function () {
	var xhr = new XMLHttpRequest();
	xhr.onload = function () {
		if (xhr.status >= 200 && xhr.status < 300) {
			var poll = JSON.parse(xhr.responseText).poll;
			
			if(poll === undefined) {
				nodata();
			} else {
				assemblePollList(poll);	
			}
		} else {
			console.error(xhr.responseText);	
		}
	}
	xhr.open('GET', '/ezNewPortal/getPollPortlet.do');
	xhr.send();
};

var pollPortletLoadFunc = function () {
	getPollPortletList();
};

