/*$(function() {
	$(".ladder").css("width", $(window).width() - 50);
	
	$(window).resize(function() {
		$(".ladder").css("width", $(window).width() - 50);
	});
	
	$("#draw_d").on("click", function() {
		setDefaultLad();
	});
	$("#draw_l").on("click", function() {
		setLadInfo();
		printLadLine();
		setUserPath();
	});
	$("#allpop").on("click", function() {
		popAllUser();
	});
	$("#allani").on("click", function() {
		aniAllUser();
	});
	$(document).on('click', 'div.users', function(e) {
		var _this = $(e.target);
		var usernum = _this.attr('num') * 1;
		
		$('.users').css('background', 'pink');
		_this.css('background', 'red');
		
		if(userStatus[usernum] === 0) {
			aniOneUser(usernum);
		} else {
			popOneUser(usernum);
		}
	});
	$("#fast").on("click", function() {
		changeSpeed(2, "fast");
	});
	$("#slow").on("click", function() {
		changeSpeed(2, "slow");
	});
	$("#add").on("click", function() {
		addUser(1);
	});
});*/

var userDiv = 100; 
var ladderlinecnt = 0;
var clickUserOrder = -1;
var resultOrder = -1;
var startXPoint = userDiv/2; // 시작 위치 왼쪽부터 떨어진 거리
var startYPoint = 1; // 시작 위치 위부터 떨어진 거리
var hInfo = 39 + 1; // 높이 수
var wInfo = 0; // 멤버 수
var hSize = 20; // 세로 간격
var wSize = 150; // 가로 간격
var moveSpeed = 4/*hSize / 10*/; // 애니메이션 속도
var lad = ""; // 사다리 정보
var ladArr = []; // 사다리 정보를 배열로 저장
var printLadInfo = []; // 사다리 방향 정보
var checkUserPath = []; // 유저별 사다리 이동 방향 정보
var userStatus = []; // 유저의 사다리 실행 상태 (처음 실행 : 0, 다시 실행 : 1)
var drawStatus = false;
var beforeStatus = 0;

function changeSpeed(speed, flag) { // 속도 변화
	if(flag === "fast") {
		moveSpeed += speed;
	} else {
		moveSpeed - speed > 0 ? moveSpeed -= speed : moveSpeed = 0;
	}
}

function changeUser(num) { // 유저 추가
	wInfo = num;
	/*if(flag === "add") {
		wInfo += num;
	} else {
		wInfo -= num;
	}*/
	setDefaultLad();
}

function setDefaultLad() { // 세로선, 유저, 아이템 나타나기
	/*if(wInfo * wSize + startXPoint * 2 > $("canvas").attr("width")) {
		$("canvas").attr("width", (wInfo - 1) * wSize + startXPoint * 2);
	}*/
	for(var i = 0; i < wInfo; i++) {
		drawLadLine('H', startXPoint + (wSize * i), startYPoint);
		
		/*$("#attendant").append("<div class='users' num='" + i + "' style='left: " + (wSize * i + startXPoint - userDiv / 2) + "px; top: " + (startYPoint - userDiv) + "px;'></div>");
		$("#item").append("<div class='items' num='" + i + "' style='left: " + (wSize * i + startXPoint - userDiv) + "px;'><input type='text'></div>");*/
		userStatus[i] = 0;
	}
}

function setLadInfo() { // 사다리 방향 정보 저장
	var ladNum = 0;
	
	for(var i = 1; i < hInfo; i++) {
		for(var j = 0; j < wInfo; j++) {
			if(ladArr[ladNum] == '1') {
				printLadInfo[j + "-" + i] = { "left" : false, "right" : true };
			} else if(ladArr[ladNum] == '2') {
				printLadInfo[j + "-" + i] = { "left" : true, "right" : false };
			} 
			ladNum++;
		}
	}
}

function printLadLine() { // 사다리 가로선 나타나기
	var dirInfo;
	
	for(var i = 1; i < hInfo; i++) {
		for(var j = 0; j < wInfo; j++) {
			dirInfo = printLadInfo[j + '-' + i];
			if(dirInfo !== undefined && dirInfo['right'])
				drawLadLine('W', startXPoint + wSize * j, startYPoint + hSize * i);
		}
	}
}

function setUserPath() { // 각 유저의 이동경로 저장
	var nowLadInfo;
	var leftLadInfo;
	var rightLadInfo;
	var locX;
	var locY;
	var userPathInfo;
	var colorArray = colors();
	var colorCnt = 60;
	
	for(var i = 0; i < wInfo; i++) {
		locX = i;
		locY = 0;
		userPathInfo = {};
		temp = Math.floor(Math.random()*colorCnt);
		userPathInfo['color'] = colorArray[temp];
		colorArray.splice(temp, 1);
		colorCnt--;
		
		if(colorCnt == 0) {
			colorArray = colors();
			colorCnt =60;
		}
		/*userPathInfo['color'] = '#' + Math.round(Math.random() * 0xffffff).toString(16);*/
		
		while(locY < hInfo) {
			nowLadInfo = printLadInfo[locX + '-' + locY];
			leftLadInfo = printLadInfo[(locX - 1) + '-' + locY];
			rightLadInfo = printLadInfo[(locX + 1) + '-' + locY];
			
			if(nowLadInfo) {
				if(nowLadInfo['left'] && leftLadInfo['right']) {
					userPathInfo[locX-- + '-' + locY] = { 'direction' : 'left' };
				} else if(nowLadInfo['right'] && rightLadInfo['left']) {
					userPathInfo[locX++ + '-' + locY] = { 'direction' : 'right' };
				}
			} 
			locY++;
		}
		checkUserPath[i] = userPathInfo;
	}
}

function colors() {
	var color = [ '#FF7100','#FF4B14','#FF1B1B','#FF144B','#FF0071','#FFB420','#FF9440','#FF6D52','#FF526D','#FF4094','#FF20B4','#FFF231','#FFD75E','#FFDBBF','#FF8D8D',
				  '#FF80B8','#FF5ED7','#FF31F2','#CEFF2F','#EAFF65','#FFF998','#FFDBBF','#FFBFDB','#FF98F9','#EA65FF','#CE2FFF','#8DFF1B','#A9FF54','#C6FF8D','#BFFFE3',
				  '#E2C6FF','#C68DFF','#C68DFF','#8D1BFF','#60FF2F','#7AFF65','#98FF9F','#BFFFE3','#BFE3FF','#989FFF','#7A65FF','#602FFF','#31FF3E','#5EFF86','#80FFC7',
			      '#8DFFFF','#80C7FF','#5E86FF','#313EFF','#20FF6B','#40FFAA','#52FFE4','#52E4FF','#40AAFF','#206BFF','#00FF8E','#14FFC8','#1BFFFF','#14C8FF','#008EFF'];
	return (color);
}
var moveImgHarfSize = 33;
var moveLeft = 0;
var moveTop = 0;
function moveUserPicImg(type) {
	var userImgHtml = $("#drag" + clickUserOrder + " span").html();
	
	
	if(type.substring(0, 3) == "pop") {
		$("#moveImgUser"  + clickUserOrder).remove();
		
		printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
		
		moveLeft = $("#drag0 img").offset().left + wSize * resultOrder;
		
		$("#lineDiv span").append(userImgHtml);
		$("#lineDiv img:last").attr("id", "moveImgUser" + clickUserOrder).css("position", "absolute").offset({"top": 1148, "left": moveLeft});

	} else {
		if(type.substring(3, 6) == "all") {
			$("#lineDiv span").empty();
		}
		moveLeft = $("#drag0 img").offset().left + wSize * clickUserOrder;
		moveTop = 0 - moveImgHarfSize;
		
		$("#lineDiv span").append(userImgHtml);
		$("#lineDiv img:last").attr("id", "moveImgUser" + clickUserOrder).css("position", "absolute").offset({"top": $("#drag0 img").offset().top, "left": moveLeft});
		
		$("#moveImgUser" + clickUserOrder).animate({"top": moveTop}, moveSpeed * 10, function() {
			moveTop = $("#moveImgUser" + clickUserOrder).offset().top;
			printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
		});
	}
	
}

function aniOneUser() { 
	if(beforeStatus == 0) {
		drawStatus = !drawStatus;
	}
	
	moveUserPicImg("anione");
	
	userStatus[clickUserOrder] = 1;
	beforeStatus = 0;
}

function aniAllUser() {
	// TODO printUserPath 함수가 끝난 다음에 실행될 수 있도록 해야함.... 속도조절시 문제... 한번 실행중일떄 버튼 클릭 막기 
	if(beforeStatus == 0) {
		drawStatus = !drawStatus;
	}
	
	moveUserPicImg("aniall" + clickUserOrder);
	
	userStatus[clickUserOrder] = 1;
}

function popOneUser() {
	drawStatus = !drawStatus;	
	moveUserPicImg("popone");
//	printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, 'popone');
	userStatus[clickUserOrder] = 1;
	beforeStatus = 1;
	ladderAnimationComplete();
}

function popAllUser() {
	drawStatus = !drawStatus;
	for(clickUserOrder = 0; clickUserOrder < wInfo; clickUserOrder++) {
		moveUserPicImg("popall");
//		printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, 'popall');
		userStatus[clickUserOrder] = 1;
	}
}

function printUserPath(user, locX, locY, moveX, moveY, type) { // 유저 경로 그리기
	locX = locX * 1;
	locY = locY * 1;
	var path = checkUserPath[user][locX + '-' + locY];
	var typeStr1 = type.substring(0, 3);
	var typeStr2 = type.substring(3, 6);
	
	if(typeStr1 == 'pop') {
		while(locY <= hInfo) {
			path = checkUserPath[user][locX + '-' + locY];
			
			drawPathLine(user, moveX, moveY, typeStr2);
			
			if(path) {
				if(path['direction'] == 'left') {
					moveX -= wSize;
					locX--;
				} else if(path['direction'] == 'right') {
					moveX += wSize;
					locX++;
				} 
			} else {
				moveY += hSize;
				locY++;
			}
		}
		resultOrder = locX;
	} else if(typeStr1 == 'ani') {
		drawPathLine(user, moveX, moveY, typeStr2);
		$("#moveImgUser" + clickUserOrder).offset({"top": moveTop, "left": moveLeft});
		
		if(locY >= hInfo) { 
			drawStatus = false;
			resultOrder = locX;
			ladderAnimationComplete(); // ladderGame.jsp
			
			if(typeStr2 == 'all' && user + 1 < wInfo) {
				clickUserOrder++;
				return aniAllUser();
			} else {
				return;
			}
		} 
		if(path) {
			if(path['direction'] == 'left') {
				moveX -= moveSpeed;
				moveLeft -= moveSpeed;
				if(moveX <= startXPoint + (locX - 1) * wSize) {
					locX--;
					moveX = startXPoint + locX * wSize;
					moveLeft = $("#drag0 img").offset().left + locX * wSize;
				}
			} else if(path['direction'] == 'right') {
				moveX += moveSpeed;
				moveLeft += moveSpeed;
				if(moveX >= startXPoint + (locX + 1) * wSize) {
					locX++;
					moveX = startXPoint + locX * wSize;
					moveLeft = $("#drag0 img").offset().left + locX * wSize;
				}
			} 
		} else {
			moveY += moveSpeed;
			moveTop += moveSpeed;
			if(moveY >= startYPoint + (locY + 1) * hSize) {
				locY++;
				moveY = startYPoint + locY * hSize;
				moveTop = $("#drag0 img").offset().top + 87 + locY * hSize;
			}
		}
		

		
		setTimeout(function(){ 
			if(!drawStatus) {
				drawStatus = true;
			} else {
				return printUserPath(user, locX, locY, moveX, moveY, type);
			}
		}, 5);
	}
}

function drawLadLine(flag, startX, startY) {
	var canvas = document.getElementById('ladderCanvas');
	
	if(canvas.getContext) {
		var cv = canvas.getContext('2d');
		
		cv.strokeStyle = 'DimGray';
		cv.lineWidth = 3;
		
		cv.beginPath();
		cv.moveTo(startX, startY);
		
		if(flag == 'H') { // 세로선
			cv.lineCap = 'square';
			cv.lineTo(startX, startY + hSize * hInfo);
		} else if(flag == 'W') { // 가로선
			cv.lineCap = 'butt';
			cv.lineTo(startX + wSize, startY);
		}
		
		cv.stroke();
	}
}

function drawPathLine(user, moveX, moveY, type) {
	var canvas = document.getElementById('ladderCanvasLine');
	
	if(canvas.getContext) {
		var cv = canvas.getContext('2d');
		
		cv.strokeStyle = checkUserPath[user]['color'];
		cv.lineWidth = 5;
		
		if(moveY == startYPoint) {
			if(type == 'one' || user == 0) {
				cv.clearRect(0, 0, canvas.width, canvas.height);
			}
			cv.beginPath();
			cv.moveTo(startXPoint + user * wSize, startYPoint);
		}
		
		cv.lineCap = 'round';
		cv.lineTo(moveX, moveY);
		cv.stroke();
	}
}