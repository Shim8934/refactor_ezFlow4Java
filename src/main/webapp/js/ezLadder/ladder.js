var userDiv = 100;
var clickUserOrder = -1;
var resultOrder = -1;
var startXPoint = userDiv/2; // 시작 위치 왼쪽부터 떨어진 거리
var startYPoint = 1; // 시작 위치 위부터 떨어진 거리
var hInfo = 39 + 6; // 높이 수
var wInfo = 0; // 멤버 수
var hSize = 15; // 세로 간격
var wSize; // 가로 간격
var ladLeftPadding;
var moveSpeed = 4/*hSize / 10*/; // 애니메이션 속도
var lad = ""; // 사다리 정보
var ladArr = []; // 사다리 정보를 배열로 저장
var printLadInfo = []; // 사다리 방향 정보
var checkUserPath = []; // 유저별 사다리 이동 방향 정보
var userStatus = []; // 유저의 사다리 실행 상태 (처음 실행 : 0, 다시 실행 : 1)
var drawStatus = false; // true:애니메이션 진행 false:애니메이션 정지
var beforeStatus = 0; // 0: 직전에 애니메이션 진행 1: 직전에 팝 진행
var colors 	= ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",		
			   "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",     
          	   "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];

function changeUser(len) {
	wInfo = len;
	
	$("canvas").attr("width", wInfo * wSize + ladLeftPadding);
	setDefaultLad();
}

function changeSpeed(speed, flag) { // 속도 변화
	if(flag === "fast") {
		moveSpeed += speed;
	} else {
		moveSpeed - speed > 0 ? moveSpeed -= speed : moveSpeed = 0;
	}
}

function setDefaultLad() { // 세로선 나타나기
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
	/*var colorArray = colors();
	var colorCnt = 60;*/
	
	for(var i = 0; i < wInfo; i++) {
		locX = i;
		locY = 0;
		userPathInfo = {};
		/*temp = Math.floor(Math.random()*colorCnt);
		userPathInfo['color'] = colorArray[temp];*/
		userPathInfo['color'] = colors[i % 30];
		/*colorArray.splice(temp, 1);
		colorCnt--;
		
		if(colorCnt == 0) {
			colorArray = colors();
			colorCnt =60;
		}*/
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
/*
function colors() {
	var color = [ '#FF7100','#FF4B14','#FF1B1B','#FF144B','#FF0071','#FFB420','#FF9440','#FF6D52','#FF526D','#FF4094','#FF20B4','#FFF231','#FFD75E','#FFDBBF','#FF8D8D',
	              '#FF80B8','#FF5ED7','#FF31F2','#CEFF2F','#EAFF65','#FFF998','#FFDBBF','#FFBFDB','#FF98F9','#EA65FF','#CE2FFF','#8DFF1B','#A9FF54','#C6FF8D','#BFFFE3',
	              '#E2C6FF','#C68DFF','#C68DFF','#8D1BFF','#60FF2F','#7AFF65','#98FF9F','#BFFFE3','#BFE3FF','#989FFF','#7A65FF','#602FFF','#31FF3E','#5EFF86','#80FFC7',
	              '#8DFFFF','#80C7FF','#5E86FF','#313EFF','#20FF6B','#40FFAA','#52FFE4','#52E4FF','#40AAFF','#206BFF','#00FF8E','#14FFC8','#1BFFFF','#14C8FF','#008EFF'];
	return (color);
}*/

var moveImgHalfHeight;
var canvasTop;
var canvasBottom;
var canvasLeft;
var moveTop;
var moveLeft;
var $moveImg;

function ladderDrawInitSettingVar() {
	var $userImg = $("#drag0").find("img");
	moveImgHalfHeight = ($userImg.height() + Number($userImg.css("border-width").split("px")[0]) * 2) / 2;
	canvasTop = $("canvas").position().top + startYPoint - moveImgHalfHeight;
	canvasBottom = canvasTop + $("canvas").height();
	canvasLeft = ($("canvas").position().left + moveImgHalfHeight / 2) + 1;
	moveTop = 0;
	moveLeft = 0;
}

function moveUserPicImg(type) {
	if(!!$(".goLadder").length && clickUserOrder != $(".goLadder").parent().attr("id").slice(4)) {
		$("[id^='drag']").find("div").removeClass("goLadder").css({"background": "#ffffff"})
	}
	
	if(type != "popall") {
		$("#drag" + clickUserOrder).find("div").addClass("goLadder").css({"background": "#ffffff", "color" : "#2568b3"});
	}
	
	pathUser = checkUserPath[clickUserOrder];
	var userImgHtml;
	if($("#drag" + clickUserOrder + " span").hasClass("userPicWraper_d")) {
		userImgHtml = '<span class="userPicWraper" style="border-color: #2568b3"><img src="/images/ezLadder/icon_defaultAttendant_hover.png" width="48px" height="48px" style="display: block;"></span>';
	} else {
		userImgHtml = document.getElementById("drag"+clickUserOrder).children[0].outerHTML;
	}
	if($("[_result='0']").length > 0) {
		userStatus[$("[_result='0']").attr("id").slice(11)] = 0;
		$("[_result='0']").remove();
	}
	
	if(type.substring(0, 3) == "pop") {
		
		printUserPath(clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
		
		if(userStatus[clickUserOrder] == 0) {
			$("#moveImgUser" + clickUserOrder).remove();
			
			moveLeft = canvasLeft + wSize * resultOrder + 12;
			
			$("#lineDiv span:eq(0)").append(userImgHtml);
			$("#lineDiv span:last")
				.attr({"id": "moveImgUser" + clickUserOrder, "_result": userStatus[clickUserOrder]})
				.css({"position": "absolute", "top": canvasBottom, "left": moveLeft});
			userStatus[clickUserOrder] = 1;
		}
		
		ladderAnimationComplete(type);
	} else {
		
		moveLeft = canvasLeft + wSize * clickUserOrder + 12;
		moveTop = canvasTop;
		
		$("#lineDiv span:eq(0)").append(userImgHtml);
		if(userStatus[clickUserOrder] == 0) {
			$("#lineDiv span:last")
				.attr({"id": "moveImgUser" + clickUserOrder, "_result": userStatus[clickUserOrder]})
				.css({"position": "absolute", "top": canvasTop - 80, "left": moveLeft, "border-color": "#2568b3"});
			
			$moveImg = $("#moveImgUser" + clickUserOrder);
			
			userStatus[clickUserOrder] = 1;
		} else {
			$("#lineDiv span:last")
				.attr({"id": "copyUser", "_result": "0"})
				.css({"position": "absolute", "top": canvasTop - 80, "left": moveLeft, "border-color": "#2568b3"});
			
			$moveImg = $("#copyUser");
		}
		
		$moveImg.animate({"top": canvasTop}, moveSpeed * 10, function() {
			printUserPath(clickUserOrder, 0, startXPoint + clickUserOrder * wSize, startYPoint, type);
		});
	}
}

function aniOneUser() { 
	drawStatus = !drawStatus;
	beforeStatus = 0;
	
	moveUserPicImg("anione");
}

function aniAllUser(tempOrder) {
	drawStatus = !drawStatus;
	beforeStatus = 0;
	
	moveUserPicImg("aniall" + tempOrder);
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

var pathUser;

function printUserPath(locX, locY, moveX, moveY, type) { // 유저 경로 그리기
	locX = locX * 1;
	locY = locY * 1;
	var path = pathUser[locX + '-' + locY];
	var typeStr1 = type.substring(0, 3);
	var typeStr2 = type.substring(3, 6);
	
	if(typeStr1 == 'pop') {
		while(locY <= hInfo) {
			path = pathUser[locX + '-' + locY];
			
			drawPathLine(clickUserOrder, moveX, moveY, typeStr2);
			
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
		drawPathLine(clickUserOrder, moveX, moveY, typeStr2);
		
		$moveImg.css({"top": moveTop, "left": moveLeft});
		
		if(locY >= hInfo) { 
			drawStatus = false;
			resultOrder = locX;
			ladderAnimationComplete(type); // ladderGame.jsp
			
			if(typeStr2 == 'all' && clickUserOrder + 1 < wInfo) {
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
					moveLeft = canvasLeft + locX * wSize + 12;
				}
			} else if(path['direction'] == 'right') {
				moveX += moveSpeed;
				moveLeft += moveSpeed;
				if(moveX >= startXPoint + (locX + 1) * wSize) {
					locX++;
					moveX = startXPoint + locX * wSize;
					moveLeft = canvasLeft + locX * wSize + 12;
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
				return printUserPath(locX, locY, moveX, moveY, type);
			}
		}, 5);
	}
}

function drawLadLine(flag, startX, startY) {
	var canvas = document.getElementById('ladderCanvas');
	
	if(canvas.getContext) {
		var cv = canvas.getContext('2d');
		
		cv.strokeStyle = '#999';
		cv.lineWidth = 1;
		
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
		
		cv.strokeStyle = pathUser['color'];
		cv.lineWidth = 1;
		
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