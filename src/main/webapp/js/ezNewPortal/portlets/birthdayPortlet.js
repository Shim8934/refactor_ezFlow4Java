/**
 * 김보미
 */
//main.t00046	=	이달의 생일
//main.t1002	=	월 생일자
var ptlTimer;
var ptlBirthMonth = Number($("#nowMonth").val());
var ptlBirthCurPage = 0;
var ptlBirthTotalCount = 0;

//생일자 목록 month 세팅
function ptlGetMonthlyBirthday(event) {
	if (event  != undefined) {
		var isNext = event.data.isNext;
		
		if (isNext) {
			if (ptlBirthMonth === 12) {
				ptlBirthMonth = 1;
			} else {
				ptlBirthMonth += 1;
			}
		} else {
			if (ptlBirthMonth === 1) {
				ptlBirthMonth = 12;
			} else {
				ptlBirthMonth -= 1;
			}
		}
	}
	
	ptlBirthCurPage = 0;
	getBirthdayList();
}
//생일자 불러오기
function getBirthdayList() {
	window.clearTimeout(ptlTimer);
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
		dataType : "json",
		data : {"birthdayMonth" : ptlBirthMonth, "birthdayCurPage" : ptlBirthCurPage, "birthdayCount" : 6},
		success : function(result) {
			ptlBirthTotalCount = result.birthdayTotalCount;
			
			if (ptlBirthCurPage != 0) {
				ptlBirthCurPage = result.birthdayCurPage;
			}
			
			var birthdayList = result.birthdayList;
			
			var birth = ptlBirthMonth;
			
			if (birth < 10) {
				birth = "0" + birth;
			}
			
			$("#curMonth").text(birth);
			
			if (birthdayList.length > 0 && birthdayList != null) {
				$("#nodata_NewBirthday").css("display", "none");
				$("#birthcount").css("display", "");
				
				var strHTML = "";
				var resultCount = birthdayList.length;
				
				for (var i = 0; i < resultCount; i++) {
					var userBirthday = birthdayList[i].userBirthday.substring(5);
					
					strHTML += "<li id='B" + birthdayList[i].userId + "'>";
					strHTML += "<dl class='birthListDL'>";
					strHTML += "<dt class='birthPic'>";
					strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
					strHTML += "</dt>";
					strHTML += "<dd class='birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
					strHTML += "<dd class='birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
					strHTML += "</dl>";
					strHTML += "</li>";
				}
				
				$("#birthdayList").html(strHTML);
				
				for (var i = 0; i< resultCount; i++) {
					var userInfo = birthdayList[i];
					$("#B" + userInfo.userId).on("click", {"userId" : userInfo.userId}, openUserInfo);
				}
			} else {
				$("#nodata_NewBirthday").css("display", "");
				$("#birthcount").css("display", "none");
			}
			// 프로젝트 종료 시 주석 해제
			ptlTimer = window.setInterval(function() {
				if (ptlBirthTotalCount > 6) {
					ptlBirthCurPage++;
					getBirthdayList();
				}
			}, 5000);
		},
		error : function() {
			alert(messages.strLang2);
		}
	});
}