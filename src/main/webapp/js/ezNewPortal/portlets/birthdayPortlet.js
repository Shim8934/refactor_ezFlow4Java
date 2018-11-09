/**
 * 김보미
 */
//main.t00046	=	이달의 생일
//main.t1002	=	월 생일자

var birthMonth = Number($("#nowMonth").val());
var birthCurPage = 0;
var birthTotalCount = 0;

//생일자 목록 month 세팅
function getMonthlyBirthday(event) {
	if (event  != undefined) {
		var isNext = event.data.isNext;
		
		if (isNext) {
			if (birthMonth === 12) {
				birthMonth = 1;
			} else {
				birthMonth += 1;
			}
		} else {
			if (birthMonth === 1) {
				birthMonth = 12;
			} else {
				birthMonth -= 1;
			}
		}
	}
	
	birthCurPage = 0;
	getBirthdayList();
}
//생일자 불러오기
function getBirthdayList() {
	window.clearTimeout(timer);
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
		dataType : "json",
		data : {"birthdayMonth" : birthMonth, "birthdayCurPage" : birthCurPage, "birthdayCount" : 6},
		success : function(result) {
			birthdayTotalCount = result.birthdayTotalCount;
			
			if (birthCurPage != 0) {
				birthCurPage = result.birthdayCurPage;
			}
			
			var birthdayList = result.birthdayList;
			
			var birth = birthMonth;
			
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
/*			timer = window.setInterval(function() {
				if (birthdayTotalCount > 6) {
					birthdayCurPage++;
					getBirthdayEmployeesList();
				}
			}, 5000);*/
		},
		error : function() {
			alert(messages.strLang2);
		}
	});
}