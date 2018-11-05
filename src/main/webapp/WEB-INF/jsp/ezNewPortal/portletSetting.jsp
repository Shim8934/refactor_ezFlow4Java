<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Portlet Setting</title>
<link href="${util.addVer('main.e15', 'msg')}" rel="stylesheet" type="text/css">
<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">
<link rel="stylesheet"  href="${util.addVer('/css/ezNewPortal/jquery.flipster.min.css')}" type="text/css">
<link rel="stylesheet"  href="${util.addVer('/css/ezMemo/jquery.mCustomScrollbar.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/jquery-flipster-master/dist/jquery.flipster.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style type="text/css">
html { height: 100%; }
#set-body { background-color: white; }
h3 { padding-left: 20px; padding-top: 15px; padding-bottom: 10px; }

.set-head { background-color: #E5EFFF; height: 5%; display: flex; align-items: center; padding-top: 5px; padding-bottom: 5px;}
.set-head h1 { font-size: 20px; margin-left: 20px;}
.set-frame { height: 45%; }
.set-portlet { height: 40%; display: inline; }
.set-action { height: 10%; display: flex; justify-content: center; align-items: center;} 
.ui-portlet { position:relative; border: 1px solid #aaaaaa; width: 272px; height: 40px; /* background-color: rgb(176, 228, 255); */ background-color: #E0E3E4; border-radius: 5px; padding-left: 10px; margin: 10px; line-height: 40px;}
.ui-portlet-content { font-weight: bold; display: inline-block;}
.ui-portlet-list { padding-left: 20px; height: 200px; width: 97%;}
.flipsterLi { width:330px; height: 240px; }

.frameList { height: 250px; background-color: #e0e3e4; margin-left: 20px; margin-right: 20px; padding-top: 15px; padding-bottom: 10px;}
.select-flipster img{ border:5px solid #0088CC; }

.paginationBtn { border: 1px solid black; width: 100px; height: 30px; margin-left:20px; margin-right:20px;}

/* switch */
.switch {position: absolute; display: inline-block; width: 60px; height: 25px; margin-left: 150px; margin-top: 6px;}
.switch input {opacity: 0;width: 0;height: 0;}
.slider {  position: absolute;  cursor: pointer;  top: 0;  left: 0;  right: 0;  bottom: 0;  background-color: #ccc;  -webkit-transition: .4s;  transition: .4s;}
.slider:before {  position: absolute;  content: "";  height: 17px;  width: 18px;  left: 4px;  bottom: 4px;  background-color: white;  -webkit-transition: .4s;  transition: .4s;}
input:checked + .slider {  background-color: #2196F3;}
input:focus + .slider { box-shadow: 0 0 1px #2196F3;}
input:checked + .slider:before {-webkit-transform: translateX(26px); -ms-transform: translateX(26px);transform: translateX(26px);}
/* Rounded sliders */
.slider.round {border-radius: 15px;}
.slider.round:before {border-radius: 50%;}
</style>
<script type="text/javascript">

var portletSetting = {
	selectedFrame: '',	
};

$(function() {
	
	$("#closeBtn").on("click", popupClose);
	$("#cancelBtn").on("click", popupClose);

	$(".frameList").flipster({
		style: 'carousel',
	    spacing: -0.4,
	    nav: false,
	    buttons: true,
	    fadeIn : 0,
	});
	
	$('#frameList').on('click', function() {
		console.log(this);
	});

	 $(".ui-portlet-list").mCustomScrollbar({
		theme : "dark",
		mouseWheelPixels: 70, 
		//scrollInertia: 60,
	});		
	
	var selectFrame = function () {
		var selectedFrame = document.querySelector('div.select-flipster');
		selectedFrame && selectedFrame.classList.remove('select-flipster');
		
		var currentLi = document.querySelector('li.flipster__item--current').firstChild;
		var currentFrame = currentLi.firstElementChild;
		currentFrame.classList.add('select-flipster');
		console.log(currentFrame.dataset.frameid);
		
		// 설정된 프레임id
		portletSetting.selectedFrame = currentFrame.dataset.frameid; 
	}	
	
	var frameUl = document.getElementById('frameUl');
	HTMLCollection.prototype.forEach = Array.prototype.forEach;
	frameUl.children.forEach(function(item, index) {
		item.addEventListener('click', selectFrame);
	});
	
	// 프레임 리스트 출력
	var getUserFrameList = function () {
		var xhr = new XMLHttpRequest();
		xhr.onload = function () {
			if (xhr.status >= 200 && xhr.status < 300) {
				var ul = document.getElementById('frameUl');
				var frameList = JSON.parse(xhr.responseText).data.frameList;
				console.log('frameList!!!!!!!!!',frameList);
				frameList.forEach(function(item, index) {
					var li = document.createElement('li');
					var div = document.createElement('div');
					div.className = 'flipsterLi';
					div.setAttribute('data-frameid', frameId);
					
					// 프레임 이미지 나오면 변경하자!!
					var img = document.createElement('img');
					img.src = 'https://fakeimg.pl/330x240/282828';
					div.appendChild(img);
					
					li.appendChild(div);
					
					ul.appendChild(li);
				});
			} else {
				console.error(xhr.responseText);	
			}
		}
		xhr.open('GET', '/ezNewPortal/getUserFrameList.do');
		xhr.send();
	}
	// 포틀릿 리스트 출력
	
	var getUserPortletList = function () {
		var xhr = new XMLHttpRequest();
		xhr.onload = function () {
			if (xhr.status >= 200 && xhr.status < 300) {
				console.log('user\'s portlet list... ', xhr.responseText)
			} else {
				console.error(xhr.responseText);	
			}
		}
		xhr.open('GET', '/ezNewPortal/getUserPortletList.do');
		xhr.send();	
	}
	
	getUserFrameList();
	//getUserPortletList();
	
});


function popupClose() {
	parent.DivPopUpHidden();
	window.close();
}

</script>
</head>
<body id="set-body">
<section class="set-head">
	<h1>▒&nbsp;포틀릿 설정</h1>
</section>
<section class="set-frame">
	<h3>⊙&nbsp;화면 프레임 설정</h3>
	<div class="frameList">
		<ul id="frameUl">
<!-- 			<li>
				<div class="flipsterLi" data-frameid='1'><img src="https://fakeimg.pl/330x240/282828/"></div>
			</li>	
			<li>
				<div class="flipsterLi" data-frameid='2'><img src="https://fakeimg.pl/330x240/282828/"></div>
			</li>	
			<li>
				<div class="flipsterLi" data-frameid='3'><img src="https://fakeimg.pl/330x240/282828/"></div>
			</li>	 -->	
		</ul>
	</div>
</section>
<section class="set-portlet">
	<h3>⊙&nbsp;포틀릿 설정</h3>
	<div class="ui-portlet-list">
  		<div class="ui-portlet ui-portlet-content">
  			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div> 		
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>
 		<div class="ui-portlet ui-portlet-content">
 			<span>포틀릿 1</span>
 			<label class='switch'><input type='checkbox'><span class='slider round'></span></label></li>
 		</div>		
	</div>
</section>
<section class="set-action">
	<div class="button-location">
		<p class="pollBtn" id="cancelBtn">취소</p>
		<p class="pollBtn" id="saveBtn">저장</p>
	</div>
</section>
<div id="close">
	<ul>
		<li><span id="closeBtn"></span></li>
	</ul>
</div>
</body>
</html>