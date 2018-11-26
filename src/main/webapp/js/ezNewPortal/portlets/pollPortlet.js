var joinPoll = function (e) {
	var condition = true;
	var height = window.screen.availHeight;
	var width = window.screen.availWidth;		
	var itemseq = '50';
	
	if (condition) {
		var top = (height - 370) / 2;
		var left = (width - 300) / 2;
		var option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=400px,width=455px,top=' + top + ',left=' + left;
		var url = '/ezPersonal/wpLightPoll.do';			
	} else {
		var top = (height - 455) / 2;
		var left = (width - 400) / 2;
		var option = 'height=400px,width=455, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=' + top + ',left = ' + left; 
		var url = '/ezPersonal/pollResult.do?itemSeq=' + itemseq;
	}
	
	window.open(url, '', option, '');
}


var pollPlus = function () {
	var height = window.screen.availHeight;
	var width = window.screen.availWidth;
	var top = (height - 500) / 2;
	var left = (width - 765) / 2;
	   
	window.open("/ezPersonal/homePollListUser.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=665,width=765,top=" + top + ",left=" + left, "");
}

var nodata = function () {
	var str = '<dl class="nodata"><dt><img src="/images/ezNewPortal/nodata.png"></dt><dd>&#34;'+ messages.strLang1 +'&#34;</dd></dl>';
	document.getElementById('pollInfo').innerHTML = str;
	document.getElementById('pollPlus').addEventListener('click', pollPlus);
}

var assemblePollList = function (poll) {
	HTMLCollection.prototype.forEach = Array.prototype.forEach;
	
	// document.getElementById('pollList').innerHTML = '';
	
	var answerList = poll.answerList;
	var str = '';
	
	str += '<p class="pollTitle" id="pollTitle"></p>';
	str += '<p class="pollBtn" id="pollBtn">참여</p>';	
	str += '<div class="pollList">';
	for (var i=0; i<answerList.length; i++) {
		if(answerList[i].answer.trim() !== '') {
			var percentage = 0;
			if (answerList[i].count) {
				percentage = (answerList[i].count / poll.pollInfo.count * 1) * 100;	
			}
			str += '<li class="pollList_0'+ answerList[i].result +'">';
			str += '<div class="pollT" style="width:22%"><span class="Vnum">'+ answerList[i].result +'</span><span class="Vtext">'+ answerList[i].answer +'</span></div>';
			str += '<div class="percent" id="percent1">' + Math.round(percentage) + '%</div>';
			str += '<div class="pollGraph" id="divGraph' + answerList[i].result + '" style="display: block;">';
			str += '	<span id="pollGraph' + answerList[i].result + '" style="width:'+ percentage +'%"></span>';
			str += '</div>';
			str += '</li>';
		}
	}
	str += '</div>';
	document.getElementById('pollInfo').innerHTML = str;
	document.getElementById('pollTitle').textContent = '"'+ poll.pollInfo.pollTitle +'"';
	document.getElementById('pollBtn').addEventListener('click', joinPoll);
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

