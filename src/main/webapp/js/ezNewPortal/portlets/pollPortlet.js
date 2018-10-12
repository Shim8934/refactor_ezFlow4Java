var assemblePollList = function (poll) {
	HTMLCollection.prototype.forEach = Array.prototype.forEach;

	document.getElementById('pollTitle').textContent = '"'+ poll.pollTitle +'"';
	
	var cnt = 4; // 포틀릿에 뿌려지는 갯수
	var str = '';
	for(var i=0; i<4; i++) {
		str += '<li class="voteList_0"' + (i+1) + '>';
		str += '	<div class="voteT">';
		str += '		<span class="Vnum">'+ (i+1) +'</span>';
		str += '		<span class="Vtext" id="pollName">'+ poll.answer1 +'</span>';
		str += '	</div>';
		str += '	<div class="percent" id="pollPercent'+ (i+1) +'">100%</div>';
		str += '	<div class="voteGraph" id="pollDivGraph'+ (i+1) +'">'; 
		str += '		<span id="graph'+ (i+1) +'" style="width :100%"></span>';
		str += '	</div>';
		str += '</li>';
	}
	// document.getElementById('pollList').innerHTML = str;
};

/* 설문조사 리스트 */
var getPollPortletList = function () {
	var xhr = new XMLHttpRequest();
	xhr.onload = function () {
		if (xhr.status >= 200 && xhr.status < 300) {
			var poll = JSON.parse(xhr.responseText).poll;
			assemblePollList(poll);
		} else {
			console.error(xhr.responsText);	
		}
	}
	xhr.open('GET', '/ezNewPortal/getPollPortlet.do');
	xhr.send();
};

var pollPortletLoadFunc = function () {
	getPollPortletList();
};

