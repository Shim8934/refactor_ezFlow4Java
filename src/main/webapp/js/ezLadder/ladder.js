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
var startXPoint = 100; // 시작 위치 왼쪽부터 떨어진 거리
var startYPoint = 200; // 시작 위치 위부터 떨어진 거리
var hInfo = 40 + 1; // 높이 수
var wInfo = 0; // 멤버 수
var hSize = 10; // 세로 간격
var wSize = 150; // 가로 간격
var moveSpeed = 10/*hSize / 10*/; // 애니메이션 속도
var lad = "0001212120001200012012012120120120000120120012012012121212120012000120121212120001212012001212000120"; // 사다리 정보
var ladArr = lad.split(''); // 사다리 정보를 배열로 저장
var printLadInfo = []; // 사다리 방향 정보
var checkUserPath = []; // 유저별 사다리 이동 방향 정보
var userStatus = []; // 유저의 사다리 실행 상태 (처음 실행 : 0, 다시 실행 : 1)
var drawStatus = false;

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
	if(wInfo * wSize + startXPoint * 2 > $("canvas").attr("width")) {
		$("canvas").attr("width", (wInfo - 1) * wSize + startXPoint * 2);
	}
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
	
	for(var i = 0; i < wInfo; i++) {
		locX = i;
		locY = 0;
		userPathInfo = {};
		userPathInfo['color'] = '#' + Math.round(Math.random() * 0xffffff).toString(16);
		
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

function aniOneUser(user) { 
	drawStatus = !drawStatus;
	printUserPath(user, user, 0, startXPoint + user * wSize, startYPoint, 'anione');
	userStatus[user] = 1;
}

function aniAllUser() {
	// TODO printUserPath 함수가 끝난 다음에 실행될 수 있도록 해야함.... 속도조절시 문제... 한번 실행중일떄 버튼 클릭 막기 
	for(var user = 0; user < wInfo; user++) {
		(function(x) {
			setTimeout(function() {
				drawStatus = !drawStatus;
				printUserPath(x, x, 0, startXPoint + x * wSize, startYPoint, 'aniall');
			}, 2000 / moveSpeed * wInfo * x);
		})(user);
		userStatus[user] = 1;
	}
}

function popOneUser(user) {
	drawStatus = !drawStatus;	
	printUserPath(user, user, 0, startXPoint + user * wSize, startYPoint, 'popone');
}

function popAllUser() {
	drawStatus = !drawStatus;
	for(var user = 0; user < wInfo; user++) {
		printUserPath(user, user, 0, startXPoint + user * wSize, startYPoint, 'popall');
		userStatus[user] = 1;
	}
}

function printUserPath(user, locX, locY, moveX, moveY, type) { // 유저 경로 그리기
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
	} else if(typeStr1 == 'ani') {
		drawPathLine(user, moveX, moveY, typeStr2);
		
		if(locY >= hInfo) { 
			drawStatus = false;
			return;
		} 
		if(path) {
			if(path['direction'] == 'left') {
				moveX -= moveSpeed;
				if(moveX <= startXPoint + (locX - 1) * wSize) {
					locX--;
					moveX = startXPoint + locX * wSize;
				}
			} else if(path['direction'] == 'right') {
				moveX += moveSpeed;
				if(moveX >= startXPoint + (locX + 1) * wSize) {
					locX++;
					moveX = startXPoint + locX * wSize;
				}
			} 
		} else {
			moveY += moveSpeed;
			if(moveY >= startYPoint + (locY + 1) * hSize) {
				locY++;
				moveY = startYPoint + locY * hSize;
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
			console.log('초기화');
			if(type == 'one') {
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