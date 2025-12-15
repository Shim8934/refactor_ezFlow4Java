/**
 * 
 */

//포틀릿 순서 업데이트

function updatePortletOrderUser(usedTheme) {
	var portlets = $(".portlet");
	var updateOrder = [];
	var portletsCount = portlets.length;
	
	for (var i = 0; i < portletsCount; i++) {
		var portletId = portlets.eq(i).attr("id");
		
		if (portletId) { // 테마3의 경우 class가 box_shadow인것이 한 포틀릿 안에 있으므로 아이디가 존재 하는 경우에만 하도록.
			portletId = portletId.substring(0, portletId.indexOf("P"));
		}	
		updateOrder.push({"portletOrder" : i + 1, "portletId" : portletId});
	}
	
	var data = {
		themeId : usedTheme,
		updateOrder : updateOrder
	};
	
	//ajax로 순서 변경
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/updatePortletOrderUser.do",
		contentType : "application/json",
		dataType : "text",
		data : JSON.stringify(data),
		success : function(result) {
			if (result === "failed") {
				//alert(messages.strLang2);
			}
		},
		error : function() {
			//alert(messages.strLang2);
		}
	});
}

function parseDate(themeId) {
	
	var _strDate = "";
	nowAttiTime = new Date(serverTime);
	
	if (nowAttiTime.toString() == 'Invalid Date') {
	    var _parts = serverTime.split(' ');
	
	    var _dateParts = _parts[0];
	    nowAttiTime = new Date(_dateParts);
	
	    if (_parts.length > 1) {
	        var _timeParts = _parts[1].split(':');
	        nowAttiTime.setHours(_timeParts[0]);
	        nowAttiTime.setMinutes(_timeParts[1]);
	        if (_timeParts.length > 2) {
	        	nowAttiTime.setSeconds(_timeParts[2]);
	        }
	    }
	}
	
	var clientTime = new Date();
	timeDiff = nowAttiTime.getTime() - clientTime.getTime();
	//$("#todayTime").html(nowAttiTime.getFullYear() + "."  + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "." + leadingZeros(nowAttiTime.getDate(), 2));
	
}

function attiClock() {
    var h, m;
    var s;
    var time = " ";
    var nowClientTime = new Date();
    var nowServerTime = new Date(nowClientTime.getTime() + timeDiff);
    
    time = leadingZeros(nowServerTime.getHours(), 2) + ':' + leadingZeros(nowServerTime.getMinutes(), 2) + ':' + leadingZeros(nowServerTime.getSeconds(), 2);
    document.getElementById("timeFlow").innerHTML = time;
    
    gizmo = setTimeout("attiClock()", 500);
    
}

function eventSetting(portletId, themeId, portletCode, isReload) { //포틀릿 아이디별로 자바스크립트 로드 
	var nowTheme = themeId;
	var url = "";
	
	var portletDiv = document.getElementById(portletId + "Portlet");
	var portletPagingArea = portletDiv.querySelector('.portletPagingArea');
	var prevBtn = portletDiv.querySelector('.portlet_list_nav.prev');
	var nextBtn = portletDiv.querySelector('.portlet_list_nav.next');
	if (portletPagingArea) {
		prevBtn.addEventListener('click', function(event) {
			portletMovePage(portletId, 'prev');
		});
		
		nextBtn.addEventListener('click', function(event) {
			portletMovePage(portletId, 'next');
		});
	}
	
	switch (portletCode) {
		case "receivedmail" : // 메일
			if (isReload) {
				getMailList();
			} else {
				url = "/js/ezNewPortal/portlets/receivedMailPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							initMailPortletInfo(portletId);
						} catch (err) {
							console.log(err);
						}
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
        case "receivedmail2" : // 메일
            if (isReload) {
                getMailList2();
            } else {
                url = "/js/ezNewPortal/portlets/receivedMailPortlet2.js";

                $.getScript(url)
                .done(function(script, textStatus) {
                    try {
                        initMailPortletInfo2(portletId);
                    } catch(err) {
                        console.log(err);
                    }
                })
                .fail(function(jqxhr, settings, exception) {
                    console.log(exception);
                });
            }

            break;
		case "notice" : // 공지사항
			if (isReload) {
				initNoticePortletInfo(portletId);
			} else {
				url = "/js/ezNewPortal/portlets/noticePortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							initNoticePortletInfo(portletId);
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "vote" : // 투표
			if (isReload) {
				getVoteInfo();
			} else {
				url = "/js/ezNewPortal/portlets/votePortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							$("#" + portletId + "Portlet").find("#votePlus").on("click", viewQstList);
							$("#" + portletId + "Portlet").find(".voteBtn").on("click", votePoll);
						} catch (err) {
							console.log(err);
						}
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "poll" : // 설문조사
			if (isReload) {
				pollPortletLoadFunc();
			} else {
				url = "/js/ezNewPortal/portlets/pollPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							pollPortletLoadFunc();
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "schedule" : // 일정관리
			if (isReload) {
				getScheduleList(newDate, "P");
			} else {
				url = "/js/ezNewPortal/portlets/schedulePortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							settingScheduleCalendar();
							
							openerCalendarMiniView = CalendarMiniView;
							openerCalendarMiniDataSource = CalendarMiniDataSource;
							schedule_get_holiday();

//					today();

							getScheduleList(nowDay, "P");

							if (navigator.userAgent.indexOf('Firefox') != -1) {
								document.body.style.MozUserSelect = 'none';
								document.body.style.WebkitUserSelect = 'none';
								document.body.style.khtmlUserSelect = 'none';
								document.body.style.oUserSelect = 'none';
								document.body.style.UserSelect = 'none';
							}

							if (nowTheme == 3) {
								$("#6portlet").css("background", "");
							}
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "photoboard" : //포토게시판
			if (isReload) {
				reloadPhotoPortlet();
			} else {
				url = "/js/ezNewPortal/portlets/photoBoardPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							initPhotoBoardPortlet(portletId);
							/*
							$("#" + portletId + "Portlet").find(".nextBtn").on("click", {isNext: true}, photoBoardMovePage);
							$("#" + portletId + "Portlet").find(".preBtn").on("click", {isNext: false}, photoBoardMovePage);
							*/
							$("#" + portletId + "Portlet").find("#photoBoardPlus").on("click", viewPhotoBoardList);
						} catch (err) {
							console.log(err);
						}
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "favoriteboard" : // 즐겨찾기
			if (isReload) {
				initFavoritePortlet(portletId);
			} else {
				url = "/js/ezNewPortal/portlets/favoriteBoardPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							initFavoritePortlet(portletId);
						} catch (err) {
							console.log(err);
						}
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "community" : // 커뮤니티
			if (isReload) {
				reloadCommunityPortlet();
			} else {
				url = "/js/ezNewPortal/portlets/communityPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							initCommunityPortletInfo(portletId);
							$("#communityPlus").on("click", viewCommuList);
							var communityPortletListSize = document.querySelectorAll('.communityPortletList').length;
							for (var i = 1; i <= communityPortletListSize; i++) {
								$('.comListDL0' + i).on("click", view_bestCommunity);
							}
						} catch (err) {
							console.log(err);
						}
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "help" : // 도움말
			if (!isReload) {
				url = "/js/ezNewPortal/portlets/helpPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							helpPortletLoadFunc();
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "birthday" : // 생일자
			if (isReload) {
				initbirthdayPortletInfo(portletId);
			} else {
				url = "/js/ezNewPortal/portlets/birthdayPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							//생일자 조회 기능 연동
							// 2024-06-14 조수빈 - 해당하는 달에 대해서만 해당 포틀릿을 사용하는 것으로 요구사항 변경됨에 따라 호출 함수 변경
//							$("#birthNext").on("click", {isNext: true}, ptlGetMonthlyBirthday);
//							$("#birthPrev").on("click", {isNext: false}, ptlGetMonthlyBirthday);

							initbirthdayPortletInfo(portletId);
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "slideimage" : // 슬라이드 이미지
			if (isReload) {

			} else {
				url = "/js/ezNewPortal/portlets/slideImagePortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							$("#roll_featured").orbit(); //슬라이드 포틀릿

							imageSizeControl(); //이미지 사이즈 조절
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "userinfo" : // 유저정보
			if (isReload) {

			} else {
				url = "/js/ezNewPortal/portlets/userInfoPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							//근태관리 연동
							var useAttitude = $("#useAttitude").val();

							if (useAttitude === "YES") {
								ptlParseDate();
								ptlAttiClock();
								ptlGetAttitudeList(nowTheme);
								getHolidayList();
								ptlAmPmCheck(ptlNowAttiTime.getHours());
							} else {
								//$(".time_check .main_time").css("display", "none");
								//$(".time_check .presentTime").addClass("presentTime_commuteNone");
								ptlParseDate();
								ptlAttiClock();
								ptlAmPmCheck(ptlNowAttiTime.getHours());
							}

							if (nowTheme == 3) {
								$("#36portlet").css("background", "");
							}
							frameSetting(frameId);
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "count" : //미독 포틀릿
			if (isReload) {
				getCountList();
			} else {
				url = "/js/ezNewPortal/portlets/cntPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {

						} catch (err) {
							console.log(err);
						}
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "movieboard" : //동영상게시판
			if (isReload) {

			} else {
				url = "/js/ezNewPortal/portlets/movieBoardPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						/*try {
                            $("#" + portletId + "Portlet").find(".nextBtn").on("click", {isNext : true}, photoBoardMovePage);
                            $("#" + portletId + "Portlet").find(".preBtn").on("click", {isNext : false}, photoBoardMovePage);
                            $("#" + portletId + "Portlet").find("#movieBoardPlus").on("click", viewMovieBoardList);
                        } catch(err) {
                            console.log(err);
                            alert(messages.strLang2);
                        }*/
					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}

			break;
		case "favoriteforms" : //즐겨찾기 양식
			if (isReload) {
				getFavoriteForms();
				getApprovalStatistics();
			}

			break;

		case "webfolder" : // 웹폴더
			url = "/js/ezNewPortal/portlets/webFolderPortlet.js";

			$.getScript(url)
				.done(function (script, textStatus) {
					try {
						initWebFolderPortletInfo(portletId);
					} catch (err) {
						console.log(err);
					}
				})
				.fail(function (jqxhr, settings, exception) {
					console.log(exception);
				});

			break;

		case "resource" : // 자원관리
			url = "/js/ezNewPortal/portlets/resourcePortlet.js";

			$.getScript(url)
				.done(function (script, textStatus) {
					try {
						settingResourceCalendar();
						viewResource();
						showPersResource();
						getPersPortlet();
					} catch (err) {
						console.log(err);
					}
				})
				.fail(function (jqxhr, settings, exception) {
					console.log(exception);
				});

			break;

		case "survey" : // 전자설문
			url = "/js/ezNewPortal/portlets/surveyPortlet.js";

			$.getScript(url)
				.done(function (script, textStatus) {
					try {
						initSurveyPortletInfo(portletId);
					} catch (err) {
						console.log(err);
					}

				})
				.fail(function (jqxhr, settings, exception) {
					console.log(exception);
				});

			break;

		case "tabBoard" : // 탭게시판
			url = "/js/ezNewPortal/portlets/tabBoardPortlet.js";

			$.getScript(url)
				.done(function (script, textStatus) {
					try {
						initTabPortletInfo(portletId);
					} catch (err) {
						console.log(err);
					}

				})
				.fail(function (jqxhr, settings, exception) {
					console.log(exception);
				});

			break;

		case "chart" : // 차트 2021-02-22 박기범
			url = "/js/ezNewPortal/portlets/chartPortlet.js";

			$.getScript(url)
				.done(function (script, textStatus) {
					try {
						initChartPortlet();
					} catch (err) {
						console.log(err);
					}

				})
				.fail(function (jqxhr, settings, exception) {
					console.log(exception);
				});

			break;
		case "connectPortlet" : // 연계 포틀릿 추가
			if (isReload) {
				getConnectList();
			} else {
				url = "/js/ezNewPortal/portlets/connectPortlet.js";

				$.getScript(url)
					.done(function (script, textStatus) {
						try {
							initConnectionPortlet(portletId);
						} catch (err) {
							console.log(err);
						}

					})
					.fail(function (jqxhr, settings, exception) {
						console.log(exception);
					});
			}
			break;
	}
}

//개인 환경설정으로 이동
function viewPersonalEnv() {
    window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
}

//읽지않은 메일, 설문조사, 회람판, 결재할 문서, 오늘일정 개수 ajax가져오기
//function getUnreadCounts(useQuestion, useCircular, useMail, useApproval, useSchedule) {
function getUnreadCounts(useSurvey, useCircular, useMail, useApproval, useSchedule) {
	var data = {
//		"useQuestion" : useQuestion,
		"useSurvey" : useSurvey,
		"useCircular" : useCircular,
		"useMail"  : useMail,
		"useApproval" : useApproval,
		"useSchedule" : useSchedule
	};
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/unreadCounts.do",
		data : JSON.stringify(data),
		contentType : "application/json",
		dataType : "json",
		success : function(result) {
			/*if (useQuestion === "YES") {
				setCountSetting("poll", result.pollCount);
			}*/
			if (useSurvey === "YES") {
				setCountSetting("survey", result.surveyCnt);
			}
			
			if (useCircular === "YES") {
				setCountSetting("circular", result.circularCount);
			}
			
			if (useMail === "YES") {
				setCountSetting("unreadMail", result.unreadMailCount);
			}
			
			if (useApproval === "YES") {
				setCountSetting("approval", result.approvalCount);
			}
			
			if (useSchedule === "YES") {
				setCountSetting("schedule", result.scheduleCount);
			}
		}
	});
}

//읽지않은 메일, 설문조사, 회람판, 결재할 문서, 오늘일정 개수 setting
function setCountSetting(countName, count) {
	switch (countName) {
	/*
	case "poll" : 
		if (count > 999) {
			count = "999+";
			document.getElementById("pollCount").classList.remove("iconCount_none");
			document.getElementById("pollCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("pollCount").classList.remove("iconCount");
			document.getElementById("pollCount").classList.add("iconCount_none");
		} else {
			document.getElementById("pollCount").classList.remove("iconCount_none");
			document.getElementById("pollCount").classList.add("iconCount");
		}

		document.getElementById("pollCount").textContent = count;
		
		break;
	*/
	case "survey" : 
		if (count > 999) {
			count = "999+";
			document.getElementById("surveyCount").classList.remove("iconCount_none");
			document.getElementById("surveyCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("surveyCount").classList.remove("iconCount");
			document.getElementById("surveyCount").classList.add("iconCount_none");
		} else {
			document.getElementById("surveyCount").classList.remove("iconCount_none");
			document.getElementById("surveyCount").classList.add("iconCount");
		}
		
		document.getElementById("surveyCount").textContent = count;
		
		break;
	case "circular" :
		if (count > 999) {
			count = "999+";
			document.getElementById("circularCount").classList.remove("iconCount_none");
			document.getElementById("circularCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("circularCount").classList.remove("iconCount");
			document.getElementById("circularCount").classList.add("iconCount_none");
		} else {
			document.getElementById("circularCount").classList.remove("iconCount_none");
			document.getElementById("circularCount").classList.add("iconCount");
		}

		document.getElementById("circularCount").textContent = count;
		
		break;
	case "schedule" :  
		if (count > 999) {
			count = "999+";
			document.getElementById("scheduleCount").classList.remove("iconCount_none");
			document.getElementById("scheduleCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("scheduleCount").classList.remove("iconCount");
			document.getElementById("scheduleCount").classList.add("iconCount_none");
		} else {
			document.getElementById("scheduleCount").classList.remove("iconCount_none");
			document.getElementById("scheduleCount").classList.add("iconCount");
		}

		document.getElementById("scheduleCount").textContent = count;
		
		break;
	case "approval" :
		if (count > 999) {
			count = "999+";
			document.getElementById("approvalCount").classList.remove("iconCount_none");
			document.getElementById("approvalCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("approvalCount").classList.remove("iconCount");
			document.getElementById("approvalCount").classList.add("iconCount_none");
		} else {
			document.getElementById("approvalCount").classList.remove("iconCount_none");
			document.getElementById("approvalCount").classList.add("iconCount");
		}

		document.getElementById("approvalCount").textContent = count;
		
		break;
	case "unreadMail" :
		if (count > 999) {
			count = "999+";
			document.getElementById("unreadMailCount").classList.remove("iconCount_none");
			document.getElementById("unreadMailCount").classList.add("iconCount");
		} else if (count == 0) {
			document.getElementById("unreadMailCount").classList.remove("iconCount");
			document.getElementById("unreadMailCount").classList.add("iconCount_none");
		} else {
			document.getElementById("unreadMailCount").classList.remove("iconCount_none");
			document.getElementById("unreadMailCount").classList.add("iconCount");
		}
		
		document.getElementById("unreadMailCount").textContent = count;
		
		break;
	}
}

//생일자 목록 month 세팅
function getMonthlyBirthdayEmployees(isNext) {
	if (isNext  != undefined) {
		if (isNext) {
			if (birthdayMonth === 12) {
				birthdayMonth = 1;
			} else {
				birthdayMonth += 1;
			}
		} else {
			if (birthdayMonth === 1) {
				birthdayMonth = 12;
			} else {
				birthdayMonth -= 1;
			}
		}
	}
	
	birthdayCurPage = 0;
	getBirthdayEmployeesList();
}

//생일자 불러오기
function getBirthdayEmployeesList() {
	window.clearTimeout(timer);
	
	$.ajax({
		type : "GET",
		url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
		dataType : "json",
		data : {"birthdayMonth" : birthdayMonth, "birthdayCurPage" : birthdayCurPage, "birthdayCount" : 6},
		success : function(result) {
			birthdayTotalCount = result.birthdayTotalCount;
			
			birthdayCurPage = result.birthdayCurPage;
			
			var birthdayList = result.birthdayList;
			
			var birth = birthdayMonth;
			
			if (userLang == '2') { 
				var monthMsg = "January;February;March;April;May;June;July;August;September;October;November;December";
			    var monthStr = monthMsg.split(";");
				birth = monthStr[birth-1] + " ";
			} else if (birth < 10) {
				birth = "0" + birth;
			}
			
			$("#curMon").text(birth);
			
			if (birthdayList != null && birthdayList != undefined && birthdayList.length > 0) {
				$("#nodata_NewBirth").css("display", "none");
				$("#birthcont").css("display", "");
				var chkList = 0;
				var strHTML = "";
				var resultCount = birthdayList.length;
				var resultMaxCount = birthdayList.length;
				if(resultCount <6){
				for (var i = 0; i < resultCount; i++) {
					var userBirthday = birthdayList[i].userBirthday.substring(5);
					
					strHTML += "<li id='B" + birthdayList[i].userId + "'>";
					strHTML += "<dl class='theme1_birthListDL'>";
					strHTML += "<dt class='theme1_birthPic'>";
					strHTML += "<img src='" + birthdayList[i].userImg + "' onerror=\"this.src='/images/ezNewPortal/info_pic_none.png'\" width = '32' height='32'>";
					strHTML += "</dt>";
					strHTML += "<dd class='theme1_birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
					strHTML += "<dd class='theme1_birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
					strHTML += "</dl>";
					strHTML += "</li>";
				}
				
				$("#userList").html(strHTML);
				
				for (var i = 0; i< resultCount; i++) {
					var userInfo = birthdayList[i];
					$("#B" + userInfo.userId.replace(/[^\w\s]/gi, '\\$&')).on("click", {"userId" : userInfo.userId}, openUserInfo);
				}
				}else{
					getBirthdayEmployeesLists(birthdayList, resultCount, resultMaxCount, chkList);
				}
			} else {
				$("#nodata_NewBirth").css("display", "block");
				$("#birthcont").css("display", "none");
			}
			// 프로젝트 종료 시 주석 해제
//			timer = window.setInterval(function() {
//				if (birthdayTotalCount > 6) {
//					//birthdayCurPage++;
//					getBirthdayEmployeesList();
//				}
//			}, 5000);
		},
		error : function() {
			//alert(messages.strLang2);
		}
	});
}



function getBirthdayEmployeesLists(birthdayList, resultCount, resultMaxCount, chkList){
	window.clearTimeout(timer);
	var strHTML = "";
	var chkListMax = chkList + 6;
	if(resultMaxCount > chkListMax){
		for (var i = chkList; i < chkListMax; i++) {
			var userBirthday = birthdayList[i].userBirthday.substring(5);
			
			strHTML += "<li id='B" + birthdayList[i].userId + "'>";
			strHTML += "<dl class='theme1_birthListDL'>";
			strHTML += "<dt class='theme1_birthPic'>";
			strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
			strHTML += "</dt>";
			strHTML += "<dd class='theme1_birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
			strHTML += "<dd class='theme1_birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
			strHTML += "</dl>";
			strHTML += "</li>";
		}
		$("#userList").html(strHTML);
		
		for (var i = chkList; i< chkListMax; i++) {
			var userInfo = birthdayList[i];
			$("#B" + userInfo.userId.replace(/[^\w\s]/gi, '\\$&')).on("click", {"userId" : userInfo.userId}, openUserInfo);
		}
	}else{
		for (var i = chkList; i < resultMaxCount; i++) {
			var userBirthday = birthdayList[i].userBirthday.substring(5);
			
			strHTML += "<li id='B" + birthdayList[i].userId + "'>";
			strHTML += "<dl class='theme1_birthListDL'>";
			strHTML += "<dt class='theme1_birthPic'>";
			strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
			strHTML += "</dt>";
			strHTML += "<dd class='theme1_birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
			strHTML += "<dd class='theme1_birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
			strHTML += "</dl>";
			strHTML += "</li>";
		}
		$("#userList").html(strHTML);
		
		for (var i = chkList; i< resultMaxCount; i++) {
			var userInfo = birthdayList[i];
			$("#B" + userInfo.userId.replace(/[^\w\s]/gi, '\\$&')).on("click", {"userId" : userInfo.userId}, openUserInfo);
		}
	}
		
	
	
		resultCount = resultCount - 6;
		chkList = chkList + 6;
	timer = window.setInterval(function() {
		if (resultCount > 0) {
			getBirthdayEmployeesLists(birthdayList, resultCount, resultMaxCount, chkList);
		}else{
			resultCount = resultMaxCount;
			chkList = 0;
		}
	}, 5000);
}
//사용자 정보 불러오기(윈도우 팝업)
function openUserInfo(event) {
	var userId = event.data.userId;
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 500) / 2;
	var top = (heigth - 400) / 2;
	
	window.open("/ezCommon/showPersonInfo.do?id=" + userId, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

//월별 우수사원 정보 호출
function getMonthlyBestEmployee() {
	$.ajax({
		type : "GET",
		url : "/ezNewPortal/getMonthlyBestEmployee.do",
		dataType : "json",
		success : function(result) {
			var bestEmployee = result.bestEmployee;
			var strHTML = "";
			
			if (bestEmployee == null) {
				$("#emPic").find("img").attr("src", "/images/ezNewPortal/info_pic_none.png");
				strHTML += "<dl class='nodata' style='margin-top:8px'>";
				strHTML += "<dd>" + messages.strLang1 + "</dd>";
				strHTML += "</dl>";
			} else {
				$("#emPic").find("img").attr("src", bestEmployee.userImg);
				$("#emPic").find("img").attr("onerror","this.src='/images/default_pic.gif'"); // ezNewPortalService.getMonthlyBestEmployee의 default값.
				strHTML += "<dd class='emName'>" + bestEmployee.userName + " " + bestEmployee.title + "</dd>";
				strHTML += "<dd class='emTeam'>" + bestEmployee.userDeptName + "</dd>";
			}
			
			$(".emDL").append(strHTML);
		}
	});
}

//포틀릿 및 프레임 환경설정 열기
function viewPortletEnv() {
	
	var feature = GetOpenPosition(760, 645);
	
//	DivPopUpShow($('body').prop('scrollWidth') * 0.9, 435, "/ezNewPortal/portletSetting.do", "",
//		"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
	DivPopUpShow(1000, 590, "/ezNewPortal/portletSetting.do", "",
		"height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);	
}

//근태관리 연동
function getAttitudeList(themeId) {
	var nowTheme = themeId
	
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezAttitude/getAttitudeList.do",
		data : {},
		success : function(result) {
			for (var i = 0; i < result.length; i++) {
				if (result[i].typeId == "A01") {
 					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
 					
 					if (nowTheme == 2) {
 	 					$("#inAttiBtn_txt").attr("onclick", "").unbind("mouseenter");
 						$("#inAttiBtn").parent().addClass("commute_on");
 					}
 					
 					if ($('#36Portlet')) {
 						$("#ptlInAttiBtn").attr("onclick", "").unbind("mouseenter");
 						$("#ptlInAttiBtn").removeClass("out").addClass("in");
 						$("#ptlInAttiBtn dt").css("margin-bottom","5px");
 						$("#ptlInAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
 					
 					/* 2023-06-01 홍승비 - 테마2 > 디자인 개선을 위해 출근, 퇴근 버튼 클릭 시 표출 수정 (inAttiBtn_txt 영역 대신 inAttiBtn 영역에 시간 표출) */
					if (nowTheme == 2) {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_in");
 						//$("#inAttiBtn_txt").removeClass("main_out").addClass("main_in");
						//$("#inAttiBtn_txt").text(result[i].startDate.split(" ")[1].substring(0,5));
 						$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					} else {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_in");
 						$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
					
				} else if (result[i].typeId == "A02") {
					$("#inAttiBtn").attr("onclick", "").unbind("mouseenter");
					
					if (nowTheme == 2) {
 	 					$("#inAttiBtn_txt").attr("onclick", "").unbind("mouseenter");
 						$("#inAttiBtn").parent().addClass("commute_on");
 					}
					
					if ($('#36Portlet')) {
						$("#ptlInAttiBtn").attr("onclick", "").unbind("mouseenter");
						$("#ptlInAttiBtn").removeClass("out").addClass("lateIn");
						$("#ptlInAttiBtn").addClass("commute_on");
						$("#ptlInAttiBtn dt").css("margin-bottom","5px");
						$("#ptlInAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
					
					if (nowTheme == 2) {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_lateIn");
 						//$("#inAttiBtn_txt").removeClass("main_out").addClass("main_lateIn");
						//$("#inAttiBtn_txt").text(result[i].startDate.split(" ")[1].substring(0,5));
						$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					} else {
 						$("#inAttiBtn").removeClass("main_out").addClass("main_lateIn");
 						$("#inAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
				} else if (result[i].typeId == "A03") {
//					$("#outAttiBtn").attr("onclick", "").unbind("mouseenter");
					
					if (nowTheme == 2) {
//						$("#outAttiBtn_txt").attr("onclick", "").unbind("mouseenter");
 						$("#outAttiBtn").parent().addClass("commute_on");
 					}
					
					if ($('#36Portlet')) {
//						$("#ptlOutAttiBtn").attr("onclick", "").unbind("mouseenter");
						$("#ptlOutAttiBtn").removeClass("out").addClass("in");
						$("#ptlOutAttiBtn").addClass("commute_on");
						$("#ptlOutAttiBtn dt").css("margin-bottom","5px");
						$("#ptlOutAttiBtn dd").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
					
					if (nowTheme == 2) {
						$("#outAttiBtn").removeClass("main_out").addClass("main_in");
						//$("#outAttiBtn_txt").removeClass("main_out").addClass("main_in");
						//$("#outAttiBtn_txt").text(result[i].startDate.split(" ")[1].substring(0,5));
						$("#outAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					} else {
 						$("#outAttiBtn").removeClass("main_out").addClass("main_in");
 						$("#outAttiBtn").text(result[i].startDate.split(" ")[1].substring(0,5));
 					}
				}
			}
		}
	})
}

//시간놓고 alert내용을 파라미터로 던져서 체크
function addAttitude(obj, themeId) {
	var pTypeId = obj.getAttribute("type");
	var pDateType = obj.getAttribute("datetype");
	if (pTypeId == "A03") {
		var returnValue = getIsAttitude("A01"); //오늘 날짜의 출근이 있는지 체크
		if (returnValue == 0) { //오늘 날짜의 출근이 없을 경우
			var inAtt = getIsAttitude("A26"); //전날 출근이 있는지 확인한다.
			if(inAtt != 0) { // 전날 출근이 있는 경우
				var outAtt = getIsAttitude("A25"); //전날 퇴근이 있는지 확인한다.
				var outAtt2 = getIsAttitude("A27"); //오늘 날짜로 전날 퇴근이 있는지 체크한다.
				if(outAtt == 0 && outAtt2 == 0){ //전날 퇴근이 없고 오늘 날짜로 퇴근이 없는 경우
					getAttitudeList(themeId);
					pTypeId = "A25";
				}else { //전날 출,퇴근 기록이 있고 아직 출근을 안찍은 경우
					alert(messages.strLang3);
					return;
				}
			}else { //전날 출근이 없는 경우
				alert(messages.strLang3);
				return;				
			}
		} else {
			getAttitudeList(themeId);
		}
	}
	
	beforeAlertDate = new Date();
	var dateAlert = nowAttiTime.getFullYear() + messages.strLang4 + (nowAttiTime.getMonth() + 1) + messages.strLang5 + (nowAttiTime.getDate()) + messages.strLang6 + leadingZeros(nowAttiTime.getHours(), 2) + ":" + leadingZeros(nowAttiTime.getMinutes(), 2) + ":"+ leadingZeros(nowAttiTime.getSeconds(), 2);
//	var saveFlag = confirm(messages.strLang7 + dateAlert + messages.strLang8);
//	if (!saveFlag) {
//		afterAlertDate = new Date();
//		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
//		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
//		return;
//	} 
	$.ajax({
		type : "POST",
		async : true,
		url : "/ezAttitude/attitudeSave.do",
		data : {
			typeId : pTypeId,
			dateType : pDateType,
			mode : "new"
		},
		success : function(result) {
			if(result == "outAttError"){
				alert(messages.strLang33);
			}else {
				getAttitudeList(themeId);				
			}
		},
		complete : function() {
			afterAlertDate = new Date();
    		overTime = (afterAlertDate.getTime() - beforeAlertDate.getTime());
    		nowAttiTime.setMilliseconds(nowAttiTime.getMilliseconds() + overTime);
		}
	})
}

function getHolidayList() {
	$.ajax({
		type:"GET",
		dataType : "json",
		async : true,
		url : "/ezAttitude/getHolidayList.do",
		data : {
			isRest : "all"
		},
		success : function(result) {
			for (var i = 0; i < result.holidayList.length; i++) {
				var isSolar = "";
				var holidayFlag = "";
				var repetition = "";
				
				if (result.holidayList[i].isSolar == "1") {
					isSolar = "1";
				} else {
					isSolar = "2";
				}
				
				if (result.holidayList[i].holidayDate == null) {
					result.holidayList[i].holidayDate = '';
				}
				
				if (result.holidayList[i].holidayRepeat == null) {
					repetition = '';
				} else {
					repetition = result.holidayList[i].holidayRepeat;
				}
				
				if (result.holidayList[i].holidayFlag == 'Y') {
					holidayFlag = "Y";			                    
                } else {
                    holidayFlag = "D";
                }
				
				if (result.holidayList[i].isRepeat == 1) { //매년 반복되는 경우
					memorialDays.push(new memorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2, 
													  result.holidayList[i].holidayDate.substring(5,7), result.holidayList[i].holidayDate.substring(8,10),
													  isSolar, result.holidayList[i].isRest == 1 ? true : false), holidayFlag, repetition);
				} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
					yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
															  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
															  result.holidayList[i].holidayDate.substring(8,10), isSolar,
															  result.holidayList[i].isRest == 1 ? true : false), holidayFlag, repetition);
				}
			}
			closedDay = result.attitudeConfigVO.closedDay.split(",");
		}
	});
}

//휴일 체크
function checkHoliday(obj, themeId) {
	var useHolidayCheckYN;
	
	$.ajax({
		type : "POST",
		async : false,
		url : "/ezAttitude/holidayCheck.do",
		data : {},
		success : function(result) {
			useHolidayCheckYN = result;
		}
	});
	
	var todayLunar = lunarCalc(nowAttiTime.getFullYear(), nowAttiTime.getMonth() + 1, nowAttiTime.getDate(), 1);
	var todayMemorialDayList = memorialDayCheck(nowAttiTime, todayLunar);
	var todayYearMemorialDayList = yearmemorialDayCheck(nowAttiTime, todayLunar);
	var addAttitude = true; // true 등록 가능
	
	//휴일 체크 미사용
	if(useHolidayCheckYN == "0"){	
		if (closedDay[nowAttiTime.getDay()] == "1"){ //회사지정 휴일인지 체크
			addAttitude = false;				
		} else if (todayMemorialDayList.length != 0 || todayYearMemorialDayList.length != 0) { //기념일체크
			if (todayMemorialDayList.length != 0 ) {
				for (var i = 0; i < todayMemorialDayList.length; i++) {
					if (todayMemorialDayList[i].holiday ==  true) { //휴무일인 기념일일때
						addAttitude = false;
					}
				}
			} 
			if (todayYearMemorialDayList.length != 0) {
				for (var i = 0; i < todayYearMemorialDayList.length; i++) {
					if (todayYearMemorialDayList[i].holiday == true) { //휴무일인 기념일일때
						addAttitude = false;
					}
				}
			}
		}
	}
	
	if(addAttitude) {
		checkAttitude(obj, themeId);
	} else {
		alert(messages.strLang9);
	}
}

//근태 중복 체크
function checkAttitude(obj, themeId) {
	var returnValue = getIsAttitude(obj.getAttribute("type"));
	
	if (returnValue == 0) {
		addAttitude(obj, themeId);
	} else {
		alert(messages.strLang10);
		getAttitudeList(themeId);
		try{parent.frames["right"].getAttitudeMainList();}catch(e){}
	}
}

function getIsAttitude(typeId) {
	var isAttitudeReturn = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezAttitude/getIsAttitude.do",
		data : {
			typeId : typeId
		},
		success : function(result) {
			isAttitudeReturn = result;
		},
		complete : function() {
			
		}
	})
	return isAttitudeReturn;
}

function setAttiBtnHover() {
	$("#inAttiBtn, #outAttiBtn").hover(function(){
		$(this).addClass("btn_hover");
	}, function(){
		$(this).removeClass("btn_hover");
	})
}

//메뉴 열기
function quickMenuOpen(menu) {
	var url = "";
	var location = "";
	var option = " ";
	console.log(menu);
	switch (menu) {
		case "NewMail" : 
			url = "/ezEmail/mailMain.do";
			location = "main";
			break;						
		case "ApprG" : 	
			// 문서Type 선택 1=결재할문서 2=기안할문서  3=결재진행문서  4=수신문서처리(접수기)
			var listType = 1;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "AprDraft" : 	
			var listType = 2;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "AprProcessing" : 	
			var listType = 3;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "AprDeptSusin" : 	
			var listType = 4;
			url = "/ezApprovalG/apprGMain.do?listType=" + listType;
			location = "main";
			break;
		case "Schedule" :
			url = "/ezSchedule/scheduleIndex.do?funCode=2";
			location = "main";
			break;
		case "Survey" :
			url = "/ezSurvey/surveyMain.do";
			location = "main";
			break;
	    case "Circular":
			url = "/ezCircular/circularIndex.do";
			location = "main";
	        break;
	        
	    /* 2023-06-05 홍승비 - 테마2 상단 사용자 영역 > 조직도, 커뮤니티, 메모 메뉴 연결 추가 */
	    case "Organ":
			var height = window.screen.availHeight;
			var width = window.screen.availWidth;
			var top = (height - 670) / 2;
			var left = (width - 880) / 2;
			url = '/ezPersonal/personSearch.do';
			option = 'height=670px,width=880px,top=' + top + ',left = ' + left + ',status = no, toolbar=no, menubar=no, location=no, resizable=0';
	    	break;
	    case "Community":
	    	url = "/ezCommunity/communityMain.do";
	    	location = "main";
	    	break;
	    case "Memo":
	    	url = "/ezMemo/memoMainPage.do";
	    	location = "main";
	    	break;
	}

	if (location === "main") {
		parent.document.querySelector("iframe[name=main]").src = url;
	} else {
		window.open(url, location, option);
	}
}

function viewQuick() {
	
	var openPx;
	var closePx;
	var leftSide = false;
	
	if(usedTheme == 3) {
		openPx = '100px';
		closePx = '0px';
	} else {
		openPx = '82px';
		closePx = '3px';
	}
	
	// 프레임에 퀵링크가 좌측에 위치한 경우
	if(usedTheme == '1' && (frameId === 'Frame2' || frameId === 'Frame4')) {
		leftSide = true;
	}

	if (document.getElementById("quickSide").style.width == "0px") {
		$(document.getElementById("quickSide")).animate({width: '100px'});
		if(leftSide) {
			$(".linkBtn_close").animate({left: openPx}, function(){
				$(".linkBtn_close").attr("class", "linkBtn_open");
				viewQuickResizePortlet();
			});			
		} else {
			$(".linkBtn_close").animate({right: openPx}, function(){
				$(".linkBtn_close").attr("class", "linkBtn_open");
				viewQuickResizePortlet();
			});			
		}
	} else {
		$(document.getElementById("quickSide")).animate({width: '0px'});
		if(leftSide) {
			$(".linkBtn_open").animate({left: closePx}, function(){
				$(".linkBtn_open").attr("class", "linkBtn_close");
				viewQuickResizePortlet();
			});					
		} else {
			$(".linkBtn_open").animate({right: closePx}, function(){
				$(".linkBtn_open").attr("class", "linkBtn_close");
				viewQuickResizePortlet();
			});	
		}
	}
}

function viewQuickResizePortlet() {
	if (typeof usePortletSize != 'undefined' && usePortletSize && typeof resizePortlet != 'undefined') {
		resizePortlet();
	}
}

// 퀵메뉴
//function quickMenuOpenRight(menu) {
//	var url = '';
//	var location = '';
//	var option = '';
//	//var menu = event.data.menu;
//	
//	var pheight = window.screen.availHeight;
//	var conHeight = pheight * 0.8;
//	var pwidth = window.screen.availWidth;
//	var conWidth = pwidth * 0.8;			
//			
//	if (conWidth > 890) conWidth = 890;
//		        
//	var pTop = (pheight - conHeight) / 2;
//	var pLeft = (pwidth - 890) / 2;			
//
//	switch (menu) {
//		case 'mail':    
//		    url = '/ezEmail/mailWrite.do?cmd=NEW';
//			location = '';
//			option = 'top='+pTop+', left='+pLeft+', height='+conHeight+', width='+conWidth+', status=no, toolbar=no, menubar=no, location=no, resizable=1';
//			break;
//		case 'appr':
//			openForm();
//			break;
//		case 'schedule':		
//			url = '/ezSchedule/scheduleWrite.do?defaultid=0';
//			location = '';
//			pTop = (pheight - 819) / 2;
//			pLeft = (pwidth - 890) / 2;	
//			option = 'top='+pTop+', left='+pLeft+ ',height='+ '802' +', width='+'890'+', status=no, toolbar=no, menubar=no, location=no, resizable=1';			
//			break;
//		case 'organ':
//			url = '/ezPersonal/personSearch.do';
//			pTop = (pheight - 659) / 2;
//			pLeft = (pwidth - 715) / 2;	
//			option = 'top='+pTop+', left='+pLeft+ ',height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0';			
//			break;
//	}
//	
//	if(menu!=='appr') window.open(url, location, option);
//}
//
//var formURL = "";
//var formDocType = "";
//var getformcont_cross_dialogArguments = new Array();
//var url = "";
//
//function openForm() {
//    var parameter = new Array();
//    parameter[0] = "${userInfo.deptID}";
//    parameter[1] = "A01000";
//    
//    url = "/ezApprovalG/getFormCont.do";
//    
//    if (CrossYN()) {
//        getformcont_cross_dialogArguments[0] = parameter;
//        getformcont_cross_dialogArguments[1] = openForm_Complete;
//        var getFormCont_Cross = window.open(url, "/ezApprovalG/getFormCont.do", GetOpenWindowfeature(713, 570));
//        
//        try { getFormCont_Cross.focus(); } catch (e) {}
//    } else {
//        var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
//        var ret = window.showModalDialog(url, parameter, feature);
//        formURL = ret[0];
//        formDocType = ret[1];
//        
//        if (formURL != "cancel") {
//            openDraftUI(formURL, formDocType);
//        }
//    }
//}
//
//function openForm_Complete(ret) {
//    formURL = ret[0];
//    formDocType = ret[1];
//
//    if (formURL != "cancel") {
//        openDraftUI();
//    }
//}
//
//function openDraftUI() {
//    var pArgument = new Array();
//    var gb = "";
//    
//    if ("${userApprovalG}" == ("YES"))
//        gb = "G";
//    
//	pArgument[0] = "${userInfo.id}";
//    pArgument[1] = formURL;
//    pArgument[2] = "DRAFT";
//    pArgument[3] = formDocType;
//    pArgument[4] = "0"
//    pArgument[5] = ""
//    pArgument[6] = ""
//    pArgument[7] = "";
//
//    var openLocation = "";
//    if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
//        if (!isIE()) {
//            alert(messages.strLang16);
//            return;
//        } else {
//           var openLocation = "/ezApprovalG/draftuiHWP.do";
//        }
//    } else {
//        var openLocation = "/ezApprovalG/draftui.do";
//    }
//    
//    openLocation = openLocation + "?formURL=" + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
//    openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1" + "&aprState=" + escape(pArgument[6]);
//    openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
//    
//    openwindow(openLocation, "", 890, 620);
//}

// 협업 관련 추가
function ezWorkspaceData(workspaceContextRootUrl) {
	var workSpace = document.getElementById('ezWorkspace');
	if (!workSpace) return;

	//협업 카운트
	if (typeof (GetWorkspaceUserActLogCount) === "function") {
	    GetWorkspaceUserActLogCount("workspaceCnt", 1);
	}
	    
	var checkBrowser = function () {
		var agent = navigator.userAgent.toLowerCase();
		
	  	if (agent.indexOf('msie') !== -1) {
	   		return false;
	   	} else {
	   		return true;
	   	}
	};
	   
	// ie 10일 경우는 다르게 해야겠음.		
	if (!checkBrowser()) {
		$("#workspaceCnt").one("DOMSubtreeModified", function() {
		   	var workspaceCnt = document.getElementById("workspaceCnt").innerHTML * 1;
		   	if (workspaceCnt > 999) {
		   		workspaceCnt = "999+";
				document.getElementById("workspaceCnt").classList.remove("iconCount_none");
				document.getElementById("workspaceCnt").classList.add("iconCount");
			} else if (workspaceCnt == 0) {
				document.getElementById("workspaceCnt").classList.remove("iconCount");
				document.getElementById("workspaceCnt").classList.add("iconCount_none");
			} else {
				document.getElementById("workspaceCnt").classList.remove("iconCount_none");
				document.getElementById("workspaceCnt").classList.add("iconCount");
			}
		   	
		   	document.getElementById("workspaceCnt").innerHTML = workspaceCnt;
		});		    	
	} else {
		var target = document.getElementById('workspaceCnt');

		var observer = new MutationObserver(function(mutations) {
			mutations.forEach(function(mutation) {
	  		    var workspaceCnt = mutation.target.innerHTML * 1;
			   	if (workspaceCnt > 999) {
			   		workspaceCnt = "999+";
					document.getElementById("workspaceCnt").classList.remove("iconCount_none");
					document.getElementById("workspaceCnt").classList.add("iconCount");
				} else if (workspaceCnt == 0) {
					document.getElementById("workspaceCnt").classList.remove("iconCount");
					document.getElementById("workspaceCnt").classList.add("iconCount_none");
				} else {
					document.getElementById("workspaceCnt").classList.remove("iconCount_none");
					document.getElementById("workspaceCnt").classList.add("iconCount");
				}
			   	
			   	document.getElementById("workspaceCnt").innerHTML = workspaceCnt;
			    observer.disconnect();
			});    
		});
			
		var config = { attributes: true, childList: true, characterData: true };
		observer.observe(target, config);		    	
	}

	workSpace.addEventListener('click', function() {
		/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace) */
		window.open(workspaceContextRootUrl + "/Account/SSO", "main", "");
	});	

}

function schedule_get_holiday() {		        
    $.ajax({
		type : "GET",
		dataType : "text",
		async : true,
		url : "/ezSchedule/scheduleGetHoliday.do",
		data : {
			COMPANYID  : "VIEW"		    			
		},
		success: function(text){
			XmlNodeText = text;
            XmlNode = loadXMLString(XmlNodeText);
            
            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
                    var issolar;
                    var holiday;
                    var holidayFlag;
                    
                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1") {
                        issolar = "1";
                    } else {
                        issolar = "2";
                    }
                    
                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1") {
                        holiday = true;			                    
                    } else {
                        holiday = false;
                    }
                    
                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYFLAG")[0].textContent == "Y") {
                        holidayFlag = "Y";			                    
                    } else {
                        holidayFlag = "D";
                    }
                    
                    var repetition = GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYREPEAT")[0].textContent;	                    
                    
                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
                    } else {                   	
                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
                    }
                }
            }			  	            
            CalendarMiniView("CalendarMini");
			CalendarMiniDataSource();
		}		    		
    });
}

var notice_all_close = function () {
	var popupList = parent.document.getElementsByClassName("popup_notice");
	var popupListCount = popupList.length;
	
	for (var i = 0; i < popupListCount; i++) {
		var popupId = popupList[0].id; 
		var popup = parent.document.getElementById(popupId);
		
		popup.parentNode.removeChild(popup);
	}
}

var refreshPortlet = function(useQuestion, useCircular, useMail, useApproval, useSchedule) {
	if (portletOrder != null && portletOrder.length != 0) {
		var portletCount = portletOrder.length;
		var portletHTML = "";
		
		for (var i = 0; i < portletCount; i++) {
			portletHTML += "<div class='portlet' id='" + portletOrder[i].portletId + "Portlet'></div>";
		}
		
		//$(".portlet_area").html(portletHTML);
		document.getElementsByClassName("portlet_area")[0].innerHTML = portletHTML;
		
 		//포틀릿별로 정보 및 포틀릿 jsp불러오기
		for (var i = 0; i < portletCount; i++) {
			var portletId = portletOrder[i].portletId;
			var portletUrl = portletOrder[i].portletUrl;
			var portletName = portletOrder[i].portletName;
			var portletCode = portletOrder[i].portletCode;
			
			/* if (portletUrl.indexOf("ezNewPortal") != -1) { */
		  		(function (portletId, portletUrl, portletName, portletCode) {
					$.ajax({
						type : "GET",
						dataType : "html",
						data : {"uniq_param" : (new Date()).getTime(), "portletId" : portletId, "portletName" : portletName, "usedTheme" : usedTheme},
						url : portletUrl,
						tryCount : 0,
						retryLimit : 3,
						success : function(result) {
							$("#" + portletId + "Portlet").append(result);
							
							if (portletId == 6) {
								document.getElementById(portletId + "Portlet").style.background = "none";
							}
							
							eventSetting(portletId, usedTheme, portletCode, false);
							
							if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
								sortableEvent();
							}
						},
						error : function() {
							this.url = "/ezNewPortal/errorPortlet.do";
							this.tryCount++;
							
							if (this.tryCount <= this.retryLimit) {
								//try again
								$.ajax(this);
								return;
							}
							
							if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
								sortableEvent();
							}
							
							return;
						}
					});
				}(portletId, portletUrl, portletName, portletCode));
			/* } */
		}
	} 
	
	//메뉴 이동(왼쪽)
	if (useMail !== "NO") {
		var newMailDom = document.getElementById("NewMail");
		if (!!newMailDom) newMailDom.addEventListener('click', function(){quickMenuOpen('NewMail');}, false);
	}
	
	if (useSchedule !== "NO") {
		var scheduleDom = document.getElementById("Schedule");
		if (!!scheduleDom) scheduleDom.addEventListener('click', function(){quickMenuOpen('Schedule');}, false);
	}
	
	if (useQuestion !== "NO") {
		var pollDom = document.getElementById("Poll");
		if (!!pollDom) pollDom.addEventListener('click', function(){quickMenuOpen('Poll');}, false);
	}
	
	if (useCircular !== "NO") {
		var circularDom = document.getElementById("Circular");
		if (!!circularDom) circularDom.addEventListener('click', function(){quickMenuOpen('Circular');}, false);
	}
	
	if (useApproval !== "NO") {
		var aprDraftDom = document.getElementById("AprDraft");
		if (!!aprDraftDom) aprDraftDom.addEventListener('click', function(){quickMenuOpen('AprDraft');}, false);
	}
	
	//ajax로 count 불러오기
	getUnreadCounts(useQuestion, useCircular, useMail, useApproval, useSchedule);
	
	//근태관리 연동
	if (useAttitude === "YES") {
		parseDate(usedTheme);
		attiClock();
		setAttiBtnHover();
		getAttitudeList(usedTheme);
		getHolidayList();
	} else {
		parseDate(usedTheme);
		attiClock();
		//$(".time_check").css("display", "none");
	}
	
	
	//이번달 생일자 목록 불러오기
	getMonthlyBirthdayEmployees();
	
	//이달의 우수사원 불러오기
	getMonthlyBestEmployee();
	//포틀릿 드래그 앤 드롭
	if (navigator.userAgent.toLowerCase().indexOf("firefox") == -1) {
		sortableEvent();
	}
}

// 포탈에서 게시판 팝업 오픈 용
var openBoard = function (pItemID, pType, oBoardID, password) {
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 720) / 2;
	var pLeft = (pwidth - 765) / 2;

	/* 2018-09-19 홍승비 - 포탈 포틀릿에서 포토/썸네일게시물 보기 시 창 크기 수정 */
	if (pType == "3" || pType == "4") {
		if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
			var height = 789;
		} else {
			var height = 785;
		}

		pTop = (pheight - 789) / 2;
		pLeft = (pwidth - 826) / 2;

		window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=826,top=" + pTop + ",left=" + pLeft, "");
	} else if (pType == "7") {
		var height = 679;
		pTop = (pheight - 679) / 2;
		pLeft = (pwidth - 764) / 2;
		window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
	} else {
		var parser = new DOMParser();
		var normalHeight = 720;
		var normalWidth = 765;
		pTop = (pheight - normalHeight) / 2;
		pLeft = (pwidth - normalWidth) / 2;

		$.ajax({
			url: "/ezBoard/boardViewAccessCheck.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID) + "&location=GENERAL",
			headers: !!password ? {
				'Authorization': 'Basic ' + btoa(password)
			} : {},
			success: function(response) {
				if (!response) {
					alert(!!password ? strWrongPassword : strLang1132);
					return;
				}
				var openUrl = "/ezBoard/boardItemView.do?showAdjacent=&itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(oBoardID);
				window.open(openUrl, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + normalHeight + ",width=" + normalWidth + ",top=" + pTop + ",left=" + pLeft);
			},
			error: function(xhr, status, error) {
				console.error('Error:', error);
			}
		});
	}
}