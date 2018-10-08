<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>notice Portlet</title>
<script type="text/javascript">

var noticePortletLoadFunc = function() {
	/* HTMLColllection에도 forEach 추가*/
	HTMLCollection.prototype.forEach = Array.prototype.forEach;	
	var noticeList = JSON.parse('${noticeList}');
	var str = '';
	var viewCnt = 3; // 보여주는 공지사항 갯수

	var noticeDetail = function() {
		var height = window.screen.availHeight;
		var width = window.screen.availWidth;
		var top = (height - 720) / 2;
		var left = (width - 765) / 2;
		var option = 'toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top='+top+',left='+left;
		
		if(this.getAttribute('data3') === "3" || this.getAttribute('data3') === "4") {
			window.open('/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID='+ this.getAttribute('data1')+'&boardID='+ this.getAttribute('data2'), "", option, "");
		} else {
			window.open('/ezBoard/boardItemView.do?showAdjacent=&itemID='+ this.getAttribute('data1')+'&boardID='+ this.getAttribute('data2'), "", option, "");
		}
	}
	
	var dataAssembler = function(data, index) {
		index = (index*1 + 1); // 혹시 모르니 int형태로 변환
		return '<li class="notiLI" data1="'+data.itemID+'" data2="'+data.boardID+'" data3="'+data.guBun+'"><dl class="notiDL0'+index+'"><dt class="noti_num">'+index+'</dt><dt class="N"></dt><dd class="noti_text">'+data.title+'</dd></dl></li>';
	};	
	
	noticeList.forEach(function(item, index){
		str += dataAssembler(item, index);
	});

	var noticeCnt = str.match(/notiLI/g); // 공지사항 갯수 확인.
	if (noticeCnt === null || noticeCnt.length < viewCnt) {
		var cnt = noticeCnt === null ? 0 : noticeCnt.length;
		
		for(var i=cnt; i<viewCnt; i++) {
			str += '<li class="notiLI"><p class="noti_nodata"></p></li>';
		}
	}
	
	document.getElementById('BoardList_NewBoard').innerHTML = str;
	
	document.getElementsByClassName('notiLI').forEach(function(item, index) {
		if(item.getAttribute('data1')) {
			item.addEventListener('click', noticeDetail);	
		}
	});
}


// 즉시실행함수처럼 사용하기.
noticePortletLoadFunc();

</script>
</head>
<body>
<div class="layDIV">
    <dl class="portlet_title">
	    <dt class="portletText">공지사항</dt>
   		<dd class="portletPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
    </dl>
    <ul class="noti_portlet_list" id="BoardList_NewBoard">
    </ul>
</div>
</body>
</html>