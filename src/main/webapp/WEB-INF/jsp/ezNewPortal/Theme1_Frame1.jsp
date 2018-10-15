<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>PortalPage</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/orbit-1.2.3.css')}" type="text/css" />
<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/raphael-min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
<!-- 종균 시작-->
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/helpPortlet.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/noticePortlet.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/pollPortlet.js')}"></script>
<!-- 종균 끝 -->
<!-- 해안 시작 -->
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/portlets/communityPortlet.js')}"></script>
<!-- 해안 끝 -->
<script type="text/javascript">

	var portletOrder = JSON.parse('${portletOrder}');
	var pollCount = "<c:out value='${pollCount}'/>";
	var circularCount = "<c:out value='${circularCount}'/>";
	var scheduleCount = "<c:out value='${scheduleCount}' />";
	var approvalCount = "<c:out value='${approvalCount}'/>";
	var unreadMailCount = "<c:out value='${unreadMailCount}'/>";
	var photoBoardPage = 1;
	var photoCount = 4;
 	var nowAttiTime = "";
 	var serverTime = "<c:out value='${serverTime}'/>";
 	var birthdayMonth = Number("<c:out value='${nowMonth}'/>");
 	var birthdayCurPage = 0;
 	var birthdayTotalCount = 0;
 	var timer;
	
	$(function() {
		$("#featured").orbit();
		
		var portletCount = portletOrder.length;
		
		for (var i = 0; i < portletCount; i++) {
			var strHTML = "";
			strHTML += "<div class='box_shadow' id='";
			strHTML += portletOrder[i].portletId + "Portlet'>";
			strHTML += "</div>";
			
			$(".portlet_area").append(strHTML);
			
			//해당 포틀릿 관련 js 추가
			var head = document.getElementsByTagName("head")[0];
			var js = document.createElement("script");
			js.type = "text/javascript";
			
			if (portletOrder[i].portletId == 4) {
				js.src = "/js/ezNewPortal/portlets/votePortlet.js";
			} else if (portletOrder[i].portletId == 9) {
				js.src = "/js/ezNewPortal/portlets/photoBoardPortlet.js";
			}
			
			head.appendChild(js);
		}
		
		for (var i = 0; i < portletCount; i++) {
			var portletId = portletOrder[i].portletId;
			var portletUrl = portletOrder[i].portletUrl;
			var portletName = portletOrder[i].portletName;
			
			(function (portletId, portletUrl, portletName) {
				$.ajax({
					type : "POST",
					dataType : "html",
					data : {"portletId" : portletId, "portletName" : portletName},
					url : portletUrl,
					success : function(result) {
						$("#" + portletId + "Portlet").append(result);
						eventSetting(portletId);
					}
				});
			}(portletId, portletUrl, portletName));
		}
		
		//ajax로 count 불러오기
		getCountSetting();
		//근태관리 연동
		parseDate();
		attiClock();
		
		//생일자 조회 기능 연동
		$("#birthdayNext").on("click", {isNext : true}, getMonthlyBirthdayEmployees);
		$("#birthdayPrev").on("click", {isNext : false}, getMonthlyBirthdayEmployees);
		
		//이번달 생일자 목록 불러오기
		getMonthlyBirthdayEmployees();
		
		//개인환경설정으로 이동 동작 연결
		$("#personalEnv").on("click", viewPersonalEnv);
		
		//포틀릿 드래그 앤 드롭
		$(".portlet_area").sortable({
			handle : ".sortablePortlet",
			update : function(event, ui) {
				updatePortletOrderUser();
			}
		});
		
		$(".portlet_area").disableSelection();
	});
	
	function updatePortletOrderUser() {
		var portlets = $(".box_shadow");
		var updateOrder = [];
		var portletsCount = portlets.length;
		
		for (var i = 0; i < portletsCount; i++) {
			var portletId = portlets.eq(i).attr("id");
			portletId = portletId.substring(0, portletId.indexOf("P"));
			
			updateOrder.push({"portletOrder" : i + 1, "portletId" : portletId});
		}
		
		var data = {
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
					alert("오류가 발생하였습니다.");
				}
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});
	}
	
	function parseDate() {
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
		
		//$("#todayTime").html(nowAttiTime.getFullYear() + "."  + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "." + leadingZeros(nowAttiTime.getDate(), 2));
		
	}
	
	function attiClock() {
        var h, m;
        var s;
        var time = " ";
        
        nowAttiTime.setSeconds(nowAttiTime.getSeconds() + 1);
        time = leadingZeros(nowAttiTime.getHours(), 2) + ':' + leadingZeros(nowAttiTime.getMinutes(), 2) + ':' + leadingZeros(nowAttiTime.getSeconds(), 2);
        document.getElementById("timeFlow").innerHTML = time;
        if (time == "00:00:00") {
        	//$("#todayTime").html(nowAttiTime.getFullYear() + "<spring:message code='ezAttitude.t66'/> " + leadingZeros((nowAttiTime.getMonth() + 1), 2) + "<spring:message code='ezAttitude.t67'/> " + leadingZeros(nowAttiTime.getDate(), 2) + "<spring:message code='ezAttitude.t68'/>");
        }
        gizmo = setTimeout("attiClock()", 1000);
        
    }
	
	function eventSetting(portletId) {
		if (portletId == 4) { //투표
			$("#votePlus").on("click", viewQstList);
			$(".voteBtn").on("click", votePoll);
		} else if (portletId == 9) { //포토게시판
			$(".nextBtn").on("click", {isNext : true}, photoBoardMovePage);
			$(".preBtn").on("click", {isNext : false}, photoBoardMovePage);
			$("#photoBoardPlus").on("click", viewPhotoBoardList);
		} else if (portletId === 10) {
			getTabList();
		} else if (portletId === 12) { // 도움말
			helpPortletLoadFunc();
		} else if (portletId === 2) {  // 공지사항
			noticePortletLoadFunc();
		} else if (portletId === 5) {  // 설문조사
			pollPortletLoadFunc();
		} else if (portletId === 11) {  // 커뮤니티
			$("#communityPlus").on("click", viewCommuList);
		}
	}
	
	//개인 환경설정으로 이동
	function viewPersonalEnv() {
	    window.open("/ezPortal/environmentMain.do?topMenuID=F3633607-8E8B-42A1-B777-6E2969072E58", "main", "");
	}
	
	function getCountSetting() {
		if (pollCount > 99) {
			pollCount = "99+";
			$("#pollCount").addClass("iconCount");
		} else if (pollCount == 0) {
			$("#pollCount").addClass("iconCount_none");
		} else {
			$("#pollCount").addClass("iconCount");
		}
		
		if (circularCount > 99) {
			circularCount = "99+";
			$("#circularCount").addClass("iconCount");
		} else if (circularCount == 0) {
			$("#circularCount").addClass("iconCount_none");
		} else {
			$("#circularCount").addClass("iconCount");
		}
		
		if (scheduleCount > 99) {
			scheduleCount = "99+";
			$("#scheduleCount").addClass("iconCount");
		} else if (scheduleCount == 0) {
			$("#scheduleCount").addClass("iconCount_none");
		} else {
			$("#scheduleCount").addClass("iconCount");
		}
		
		if (approvalCount > 99) {
			approvalCount = "99+";
			$("#approvalCount").addClass("iconCount");
		} else if (approvalCount == 0) {
			$("#approvalCount").addClass("iconCount_none");
		} else {
			$("#approvalCount").addClass("iconCount");
		}
		
		if (unreadMailCount > 99) {
			unreadMailCount = "99+";
			$("#unreadMailCount").addClass("iconCount");
		} else if (unreadMailCount == 0) {
			$("#unreadMailCount").addClass("iconCount_none");
		} else {
			$("#unreadMailCount").addClass("iconCount");
		}
		
		$("#pollCount").text(pollCount);
		$("#circularCount").text(circularCount);
		$("#scheduleCount").text(scheduleCount);
		$("#approvalCount").text(approvalCount);
		$("#unreadMailCount").text(unreadMailCount);
	}
	
	//생일자 불러오기
	function getMonthlyBirthdayEmployees(event) {
		if (event  != undefined) {
			var isNext = event.data.isNext;
			
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
	
	function getBirthdayEmployeesList() {
		window.clearTimeout(timer);
		
		$.ajax({
			type : "POST",
			url : "/ezNewPortal/getMonthlyBirthdayEmployees.do",
			dataType : "json",
			data : {"birthdayMonth" : birthdayMonth, "birthdayCurPage" : birthdayCurPage, "birthdayCount" : 6},
			success : function(result) {
				birthdayTotalCount = result.birthdayTotalCount;
				
				if (birthdayCurPage != 0) {
					birthdayCurPage = result.birthdayCurPage;
				}
				
				var birthdayList = result.birthdayList;
				
				var birth = birthdayMonth;
				
				if (birth < 10) {
					birth = "0" + birth;
				}
				
				$("#curMon").text(birth);
				
				if (birthdayList.length > 0 && birthdayList != null) {
					$("#nodata_NewBirth").css("display", "none");
					$("#birthcont").css("display", "");
					
					var strHTML = "";
					var resultCount = birthdayList.length;
					
					for (var i = 0; i < resultCount; i++) {
						var userBirthday = birthdayList[i].userBirthday.substring(5);
						
						strHTML += "<li>";
						strHTML += "<dl class='birthListDL'>";
						strHTML += "<dt class='birthPic'>";
						strHTML += "<img src='" + birthdayList[i].userImg + "' width = '32' height='32'>";
						strHTML += "</dt>";
						strHTML += "<dd class='birthName'>[" + userBirthday + "] " + birthdayList[i].userName + "</dd>";
						strHTML += "<dd class='birthTeam'>" + birthdayList[i].userDeptName + "</dd>";
						strHTML += "</dl>";
						strHTML += "</li>";
					}
					
					$("#userList").html(strHTML);
				} else {
					$("#nodata_NewBirth").css("display", "");
					$("#birthcont").css("display", "none");
				}
				
				timer = window.setInterval(function() {
					if (birthdayTotalCount > 6) {
						birthdayCurPage++;
						getBirthdayEmployeesList();
					}
				}, 5000);
			},
			error : function() {
				alert("오류가 발생하였습니다.");
			}
		});
	}
	
	</script>
	<style type="text/css">
		.notEmptySlider {
			width : 280px;
			height : 515px;
			cursor : pointer;
		}
		
		#myImg {
			width : 36px;
			height : 36px;
		}
		.mainbg {
			min-width : 1280px;
		}
	</style>
</head>

	<body class="mainbg">
		<div id="center">
			<section class="section_left" style="height:1130px;">
				<article class="rolling_info">
					<div class="rolling" id="featured">
            		<c:choose>
	            		<c:when test="${not empty sliderList}">
	            			<c:forEach items="${sliderList}" var="slider">
		            			<c:choose>
		            				<c:when test="${fn:substring(slider.url, 0, 4) eq 'http' }">
		            					<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('${slider.url }')" />
		            				</c:when>
		           		 			<c:otherwise> 
										<img src="${slider.imagePath}" class="notEmptySlider" onclick="window.open('http://${slider.url }')" />
									</c:otherwise>
								</c:choose>
							</c:forEach>
	            		</c:when>
	            		<c:otherwise>
		            		<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
		            		<img src="/images/ezNewPortal/rolling01.png" width="280" height="515" />
	            		</c:otherwise>
	            	</c:choose>
           	 		</div>
           	 		<dl class="info">
            			<dt class="infoImg"><c:if test='${userPhoto == ""}'><img src="/images/ezNewPortal/info_pic_none.png"  width="36px" height="36px" /></c:if><c:if test='${userPhoto != ""}'><img id="myImg" src="/ezCommon/downloadAttach.do?filePath=${userPhoto }"></c:if></dt>
               			<dd class="infoName">${userName} ${userTitle}</dd>
                		<dd class="infoTeam">${deptName}</dd>
                		<%-- <dd class="infoTeam"><spring:message code="main.t00016" /> ${lastLogin }</dd> --%>
                		<dd class="infoSet" id="personalEnv"><img src="/images/kr/main/info_set.png"></dd>
                		<dd class="infoSet" style="color:white;right : 30px;">포틀릿/프레임 설정</dd><!-- 임시용 -->
           			</dl>
				</article>
				<article class="time_check">
					<div id="timeinput" class="presentTime">
	               		<p class="timeTit" id="todayTime">현재시간</p>
						<div id="timeFlow" class="timeText"></div>
			    	</div>
			    	<div id="atti_area" class="main_time">
	            	<dl class="timeCheckIn">
	                	<dd id="inAttiBtn" class="out" type="A01" datetype="2" onclick="checkHoliday(this)">출근</dd>
	                </dl>
	                <dl class="timeCheckOut">
	                   	<dd id="outAttiBtn" class="out" type="A03" datetype="2" onclick="checkHoliday(this)">퇴근</dd>
	                </dl>
		    	</div>
				</article>
				
				<article class="countingIcon">
					<div class="countingIcon01">
						<dl id="NewMail" onclick="btnSumming_click(this)">
                			<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon01.png"></dt>
                    		<dd class="iconText">새메일</dd>
                    		<dd id="unreadMailCount">0</dd>
                		</dl>
                		<dl id="AprSign" onclick="btnSumming_click(this)">
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon03.png"></dt>
                    
                    		<dd class="iconText">결재문서</dd>
                    		<dd id="approvalCount">0</dd>
                		</dl>
                		<dl id="Schedule" onclick="btnSumming_click(this)">
                  		  	<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon02.png"></dt>
                    		<dd class="iconText">오늘일정</dd>
                		    <dd id="scheduleCount">0</dd>
               			</dl>
					</div>
					<div class="countingIcon02">
            			<dl id="Poll" onclick="btnSumming_click(this)">
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon05.png"></dt>
                    		<dd class="iconText">전자설문</dd>                        
                    		<dd id="pollCount">0</dd>
                		</dl>
            	
                		<dl id="Circular" onclick="btnSumming_click(this)"> 
                    		<dt class="iconImg"><img src="/images/ezNewPortal/countingIcon04.png"></dt>
                    		<dd class="iconText">회람판</dd>
                    		<dd id="circularCount">0</dd>
                		</dl>
                	</div>
				</article>
				<article class="birthday">
					<div class="birthTit">
               			<p class="birthText"><span id="curMon"></span>월 생일자</p>
           	    		<span class="birthRighttbtn" id="birthdayNext"><img src="/images/ezNewPortal/birthday_next.png"></span>
                		<span class="birthLeftbtn" id="birthdayPrev"><img src="/images/ezNewPortal/birthday_pre.png"></span>
            		</div>
            		<div id="birthcont" style="display: none;">
            			<ul class="birthList" id="userList"></ul>
            		</div>
            		<div id="nodata_NewBirth" style="">
            			<dl class="nodata">
	            			<dt style="padding-top:33px"><img src="/images/ezNewPortal/nodata.png"></dt>
	            			<dd>"데이터가 없습니다"</dd>
            			</dl>
            		</div>
				</article>
				<article class="bestEmployee">
					<p class="emPic"><img src="/images/ezNewPortal/bestEmployee_pic_none.png"></p>
					<dl class="emDL">
            			<dt class="emTit">이달의 우수사원</dt>
                			<dl class="nodata" style="margin-top:8px">
		            			<dd>"데이터가 없습니다"</dd>
	            			</dl>
            		</dl>
				</article>
			</section>
		</div>
		<aside id="quickSide">
			<p class="linkBtn_open"></p>
			<div class="aside_quick">퀵메뉴</div>
			<div class="aside_link">퀵링크</div>
		</aside>
		<section class="section_main">
			<div class="portlet_area">
			</div>
		</section>
	</body>
</html>