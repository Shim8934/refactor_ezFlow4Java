/** 날짜, 시간 구하기 */
function GetDateTimeFormatString() {
	var today = new Date();
	var year = today.getFullYear();
	var month = today.getMonth();
	var day = today.getDate();
	var hour = today.getHours();
	var minutes = today.getMinutes();
	var seconds = today.getSeconds();
	var resultDate = new Date(year, month, day);
	year = resultDate.getFullYear();
	month = resultDate.getMonth() + 1;
	day = resultDate.getDate();
	if (month < 10)
	    month = "0" + month;
	if (day < 10)
	    day = "0" + day;
	return year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds;
}

/** 중복 처리 팝업 */
function checkAttendant(overlapAttendantList, addfunction) {
	console.log("checkAttendant");
   	$("#dialog").dialog({
   		modal: true,
   		buttons: [{
   			text: "조직도에서추가",
   			click: function() { // 조직도에서 추가
   				if(typeof addfunction == "function") {
   					addfunction(overlapAttendantList);
   				}
   				$(this).dialog( "close" );
   			} 
   		}, {
   			text: "익명으로추가",
   			click: function() { // 익명으로 추가
   				if(typeof addfunction == "function") {
   					addfunction(overlapAttendantList, "anonyuser");
   				}
   				$(this).dialog( "close" );
   			}
   		}, {
   			text: "취소",
   			click: function() { // 취소
   				$(this).dialog( "close" );
   			}
   		}]
   	}); 
}
