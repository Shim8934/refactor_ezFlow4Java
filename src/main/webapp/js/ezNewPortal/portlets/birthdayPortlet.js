/**
 * 김보미
 */
//main.t00046	=	이달의 생일
//main.t1002	=	월 생일자
var ptlTimer;
var ptlBirthMonth = Number($("#nowMonth").val());
var ptlBirthCurPage = 0;
var ptlBirthTotalCount = 0;

//2024-05-30 조수빈 - 공지사항 페이징 처리
var birthdayPortletObj = {};
var birthdayPorletPagingCnt = 0;

function initbirthdayPortletInfo(birthdayPortletId) {
	var newObj = {};
	var perCount = getbirthdayPagePerCount(birthdayPortletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	
	newObj.page.getPagePerCount = function () {
		return getbirthdayPagePerCount(birthdayPortletId);
	}
	
	newObj.portletCode = "birthday";
	newObj.getPortletList = function () {
		getBirthdayList(newObj.page.getPage());
	}
	portletInfoMap["portlet" + birthdayPortletId] = newObj;
	birthdayPortletObj.portletId = birthdayPortletId;
	
	getBirthdayList(1);
}

// 2024-05-30 조수빈 - 공지사항이 보여질 수 있는 개수에 비해 작은 경우 처리하기 위해 전역변수로 선언
var count = 0;

function getbirthdayPagePerCount(birthdayPortletId) {
	var portletSize = getPortletSize(birthdayPortletId);
	
	if (portletSize == GridSize.TWO_BY_ONE) {
		count = 10;
	} else {
		count = 4;
	}

	return count;
}

//생일자 목록 month 세팅
// 2024-06-14 조수빈 - 해당하는 달에 대해서만 해당 포틀릿을 사용하는 것으로 요구사항 변경됨에 따라 쓰이지 않음.
//function ptlGetMonthlyBirthday(event) {
//	if (event  != undefined) {
//		var isNext = event.data.isNext;
//		
//		if (isNext) {
//			if (ptlBirthMonth === 12) {
//				ptlBirthMonth = 1;
//			} else {
//				ptlBirthMonth += 1;
//			}
//		} else {
//			if (ptlBirthMonth === 1) {
//				ptlBirthMonth = 12;
//			} else {
//				ptlBirthMonth -= 1;
//			}
//		}
//	}
//	
//	ptlBirthCurPage = 0;
//	getBirthdayList();
//}
//생일자 불러오기
function getBirthdayList(currentPage) {
	//window.clearTimeout(ptlTimer); 2024-05-27 자동페이지 네이션 기능 사용하고자 할 때 주석 해제
	$.ajax({
		type : "GET",
		url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
		dataType : "json",
		data : {
			"birthdayMonth" : ptlBirthMonth, 
			"birthdayCurPage" : currentPage, 
			"birthdayCount" : count
		},
		success : function(result) {
			ptlBirthTotalCount = result.birthdayTotalCount;
			currentPage = result.birthdayCurPage;
			var birthdayList = result.birthdayList;
			
			// 2024-06-16 조수빈 - nn월의 생일자 > 이달의 생일자로 변경되면서 해당 코드 사용하지 않음.
//			var birth = ptlBirthMonth;
//			
//			if (userLang == '2') {
//				var monthMsg = "January;February;March;April;May;June;July;August;September;October;November;December";
//			    var monthStr = monthMsg.split(";");
//				birth = monthStr[birth-1] + " ";
//			} else if (birth < 10) {
//				birth = "0" + birth;
//			}
			
			// $("#curMonth").text(birth);
			
			if (birthdayList != null && birthdayList != undefined && birthdayList.length > 0) {
				$("#nodata_NewBirthday").css("display", "none");
				$("#birthcount").css("display", "");
				
				var strHTML = "";
				var resultCount = birthdayList.length;
				birthdayPorletPagingCnt = birthdayList.length;
				
				for (var i = 0; i < resultCount; i++) {
					var userBirthday = birthdayList[i].userBirthday.substring(5);
					
					strHTML += "<li id='P" + birthdayList[i].userId + "'>";
					strHTML += "<dl class='birthListDL'>";
					strHTML += "<dt class='birthPic'>";
					strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
					strHTML += "</dt>";
					strHTML += "<dd class='birthName'>" + birthdayList[i].userName  + " ";
                    if (birthdayList[i].title != null && birthdayList[i].title != "null") {
                        strHTML += birthdayList[i].title + "</dd>";
                    } else {
                        "</dd>"
                    }
                    var userBirthdayFormatSum = "";
                    var userBirthdayFormat1 = userBirthday.slice(0,1);
                    var userBirthdayFormat2 = userBirthday.slice(3,4);
                    if (userLang == 1) {
                        if (userBirthdayFormat1 == 0) {
                            userBirthdayFormatSum = userBirthday.slice(1,2) + messages.strLang5;
                            if (userBirthdayFormat2 == 0) {
                                userBirthdayFormatSum += userBirthday.slice(4) + messages.strLang6;
                            } else {
                                userBirthdayFormatSum += userBirthday.slice(3) + messages.strLang6;
                            }
                        } else {
                            userBirthdayFormatSum = userBirthday.slice(0,2) + messages.strLang5;
                            if (userBirthdayFormat2 == 0) {
                                userBirthdayFormatSum += userBirthday.slice(4) + messages.strLang6;
                            } else {
                                userBirthdayFormatSum += userBirthday.slice(3) + messages.strLang6;
                            }
                        }
                    } else {
                        userBirthdayFormatSum = userBirthday.replace("-", ".");
                    }
					strHTML += "<dd class='birthDate'>" + userBirthdayFormatSum + "</dd>";
					strHTML += "<dd class='birthTeam'>" + ConvertCharToEntityReference(birthdayList[i].userDeptName) + "</dd>";
					strHTML += "</dl>";
					strHTML += "</li>";
				}
				
				$("#birthdayList").html(strHTML);
				
				for (var i = 0; i< resultCount; i++) {
					var userInfo = birthdayList[i];
					$("#P" + userInfo.userId.replace(/[^\w\s]/gi, '\\$&')).on("click", {"userId" : userInfo.userId}, openUserInfo);
				}
			} else {
				$("#nodata_NewBirthday").css("display", "");
				$("#birthcount").css("display", "none");
			}
			
//			var totalCnt = birthdayList.length < birthdayPorletPagingCnt ? birthdayList.length : birthdayPorletPagingCnt;
//			var currentPage = 1;// currentPage 수정 필요
			resetPortletPaging(birthdayPortletObj.portletId, ptlBirthTotalCount, currentPage, "");
			
			/* 6명 이상일 시 5초마다 자동페이지 네이션 기능을 사용할 때  주석해제
			ptlTimer = window.setInterval(function() {
				if (ptlBirthTotalCount > 6) {
					ptlBirthCurPage++;
					getBirthdayList();
				}
			}, 5000);
			*/
		},
		error : function() {
			//alert(messages.strLang2);
		}
	});
}