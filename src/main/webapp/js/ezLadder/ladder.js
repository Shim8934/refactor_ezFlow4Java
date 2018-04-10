var userDiv = 101;
var ladderlinecnt = 0;
var clickUserOrder = -1;
var resultOrder = -1;
var startXPoint = userDiv/2; // 시작 위치 왼쪽부터 떨어진 거리
var startYPoint = 1; // 시작 위치 위부터 떨어진 거리
var hInfo = 39 + 1; // 높이 수
var wInfo = 0; // 멤버 수
var hSize = 20; // 세로 간격
var wSize = 150; // 가로 간격
var moveSpeed = 6/*hSize / 10*/; // 애니메이션 속도
var lad = ""; // 사다리 정보
var ladArr = []; // 사다리 정보를 배열로 저장
var printLadInfo = []; // 사다리 방향 정보
var checkUserPath = []; // 유저별 사다리 이동 방향 정보
var userStatus = []; // 유저의 사다리 실행 상태 (처음 실행 : 0, 다시 실행 : 1)
var drawStatus = false; // true:애니메이션 진행 false:애니메이션 정지
var beforeStatus = 0; // 0: 직전에 애니메이션 진행 1: 직전에 팝 진행
function ladderInitSettingVar() {
}

function changeSpeed(speed, flag) { // 속도 변화
	if(flag === "fast") {
		moveSpeed += speed;
	} else {
		moveSpeed - speed > 0 ? moveSpeed -= speed : moveSpeed = 0;
	}
}

function setDefaultLad() { // 세로선, 유저, 아이템 나타나기
	for(var i = 0; i < wInfo; i++) {
		drawLadLine('H', startXPoint + (wSize * i), startYPoint);
		
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

var moveImgHalfHeight;
var canvasTop;
var canvasBottom;
var canvasLeft;
var moveTop;
var moveLeft;
function ladderDrawInitSettingVar() {
	moveImgHalfHeight = ($("#drag0 img").height() + Number($("#drag0 img").css("border-width").split("px")[0]) * 2) / 2;
	canvasTop = $("canvas").position().top + startYPoint - moveImgHalfHeight;
	canvasBottom = canvasTop + $("canvas").height();
	canvasLeft = $("canvas").position().left + moveImgHalfHeight / 2;
	moveTop = 0;
	moveLeft = 0;
}

function moveUserPicImg(type) {
	var userImgHtml = $("#drag" + clickUserOrder + " span").html();
	if($("[_result='0']").length > 0) {
		userStatus[$("[_result='0']").attr("id").slice(11)] = 0;
		$("[_result='0']").remove();
	}
	
	if(type.substring(0, 3) == "pop") {
		
		printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
		
		if(userStatus[clickUserOrder] == 0) {
			$("#moveImgUser" + clickUserOrder).remove();
			
			moveLeft = canvasLeft + wSize * resultOrder;
			
			$("#lineDiv span").append(userImgHtml);
			$("#lineDiv img:last").attr("id", "moveImgUser" + clickUserOrder).attr("_result", userStatus[clickUserOrder]).css("position", "absolute").css("top", canvasBottom).css("left", moveLeft);/*offset({"top": canvasBottom, "left": $("#drag0 img").offset().left + wSize * resultOrder});*/
			userStatus[clickUserOrder] = 1;
			
			ladderAnimationComplete();
		}
	} else {
		
		moveLeft = canvasLeft + wSize * clickUserOrder;
		moveTop = canvasTop;
		
		if(userStatus[clickUserOrder] == 0) {
			$("#lineDiv span").append(userImgHtml);
			$("#lineDiv img:last").attr("id", "moveImgUser" + clickUserOrder).attr("_result", userStatus[clickUserOrder]).css("position", "absolute").css("top", canvasTop - 80).css("left", moveLeft);/*.offset({"top": $("#drag0 img").offset().top, "left": moveLeft});*/
			
			userStatus[clickUserOrder] = 1;
			
			$("#moveImgUser" + clickUserOrder).animate({"top": canvasTop}, moveSpeed * 10, function() {
				printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
			});
		} else {
			$("#lineDiv span").append(userImgHtml);
			$("#lineDiv img:last").attr("id", "copyUser").attr("_result", "0").css("position", "absolute").css("top", canvasTop - 80).css("left", moveLeft);
			
			$("#copyUser").animate({"top": canvasTop}, moveSpeed * 10, function() {
				printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
			});
		}
	}
}

/*function moveUserPicImg(type) {
	var userImgHtml = $("#drag" + clickUserOrder + " span").html();
	if($("[_result='0']").length > 0) {
		userStatus[$("[_result='0']").attr("id").slice(11)] = 0;
		$("[_result='0']").remove();
	}
	
	if(type.substring(0, 3) == "pop") {
		
		printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
		
		if(userStatus[clickUserOrder] == 0) {
			$("#moveImgUser"  + clickUserOrder).remove();
			$("#lineDiv span").append(userImgHtml);
			$("#lineDiv img:last").attr("id", "moveImgUser" + clickUserOrder).attr("_result", userStatus[clickUserOrder]).css("position", "absolute").offset({"top": canvasBottom, "left": canvasLeft + wSize * resultOrder});
			userStatus[clickUserOrder] = 1;
			
			ladderAnimationComplete();
		}
	} else {
		
		moveLeft = canvasLeft + wSize * clickUserOrder;
		moveTop = canvasTop;
		
		if(userStatus[clickUserOrder] == 0) {
			$("#lineDiv span").append(userImgHtml);
			$("#lineDiv img:last").attr("id", "moveImgUser" + clickUserOrder).attr("_result", userStatus[clickUserOrder]).css("position", "absolute").offset({"top": $("#drag0 img").offset().top, "left": moveLeft});
			userStatus[clickUserOrder] = 1;
			
			$("#moveImgUser" + clickUserOrder).animate({"top": 0 - moveImgHalfHeight}, moveSpeed * 10, function() {
				printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
			});
		} else {
			$("#lineDiv span").append(userImgHtml);
			$("#lineDiv img:last").attr("id", "copyUser").attr("_result", "0").css("position", "absolute").offset({"top": $("#drag0 img").offset().top, "left": moveLeft});
			
			$("#copyUser").animate({"top": 0 - moveImgHalfHeight}, moveSpeed * 10, function() {
				printUserPath(clickUserOrder, clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
			});
		}
	}
}*/

function aniOneUser() { 
	drawStatus = !drawStatus;
	beforeStatus = 0;
	
	moveUserPicImg("anione");
}

function aniAllUser() {
	drawStatus = !drawStatus;
	beforeStatus = 0;
	
	moveUserPicImg("aniall" + clickUserOrder);
}

function popOneUser() {
	drawStatus = false;
	beforeStatus = 1;
	
	moveUserPicImg("popone");
}

function popAllUser() {
	drawStatus = false;
	beforeStatus = 1;
	
	for(clickUserOrder = 0; clickUserOrder < wInfo; clickUserOrder++) {
		moveUserPicImg("popall");
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
		if($("#copyUser").length != 0) {
			$("#copyUser").css("top", moveTop).css("left", moveLeft);
			/*$("#copyUser").offset({"top": moveTop, "left": moveLeft});*/
		} else {
			$("#moveImgUser" + clickUserOrder).css("top", moveTop).css("left", moveLeft);
			/*$("#moveImgUser" + clickUserOrder).offset({"top": moveTop, "left": moveLeft});*/
		}
		
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
					moveLeft = canvasLeft + locX * wSize;
				}
			} else if(path['direction'] == 'right') {
				moveX += moveSpeed;
				moveLeft += moveSpeed;
				if(moveX >= startXPoint + (locX + 1) * wSize) {
					locX++;
					moveX = startXPoint + locX * wSize;
					moveLeft = canvasLeft + locX * wSize;
				}
			} 
		} else {
			moveY += moveSpeed;
			moveTop += moveSpeed;
			if(moveY >= startYPoint + (locY + 1) * hSize) {
				locY++;
				moveY = startYPoint + locY * hSize;
				moveTop = canvasTop + locY * hSize;
			}
		}
		

		
		setTimeout(function(){ 
			if(!drawStatus) {
				if(beforeStatus == 0) {
					drawStatus = true;
				}
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