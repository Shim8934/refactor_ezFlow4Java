<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezAttitude/Calendar_cross.css')}" type="text/css" />
<%-- 		<link rel="stylesheet" href="${util.addVer('/css/ezAttitude/timecheck.css')}" type="text/css" /> --%>
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i2', 'msg')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >		
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>  
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
		<!-- modal -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<!-- month picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/monthpicker.js')}"></script>
		<!-- date Format -->		
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/moment.min.js')}"></script>
		<style>
			body {
				overflow: auto !important;
			}

			#attiStatis table td {
				color : #777;
				font-size : 13px;
				text-align : center;
				border : 1px solid #dedede;
			}
			
			#attiCalendar td[typeId=A02] {
				/* color : red; */
			}
			
			#attiCalendar td[modappl='1'][typeId=A01],[modappl='2'][typeId=A01],[modappl='3'][typeId=A01] {
				cursor : pointer;
			}
			
			#attiCalendar td[modappl='1'][typeId=A02] {
				color : black;
			}
			
			#attiCalendar td[typeId=A01][modappl='0'], #attiCalendar td[typeId=A03], #attiCalendar td[typeId=A25] {
				cursor : default;
			}
			
			.span_list table td:hover, .td_day:hover {
				background-color:#f0f6ff;
			}
			
			.attiVacation {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid #049c37;
			    background: #01b43f;
			    overflow: hidden;
			    margin: -2px 5px 0px 0px;
			    padding: 0;
			    vertical-align: middle;
			}
			
			.attiDefault {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid #017ddf;
			    background: #018bfa;
			    overflow: hidden;
			    margin: -2px 5px 0px 0px;
			    padding: 0;
			    vertical-align: middle;
			}
			
			.attiOutCom {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid #eede23;
			    background: #feee33;
			    overflow: hidden;
			    margin: -2px 5px 0px 0px;
			    padding: 0;
			    vertical-align: middle;
			}
			
			.attiLate {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid #df2b00;
			    background: #ff4b00;
			    overflow: hidden;
			    margin: -2px 5px 0px 0px;
			    padding: 0;
			    vertical-align: middle;
			}
			
			.attiModLate {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid black;
			    overflow: hidden;
			    margin: -2px 5px 0px 0px;
			    padding: 0;
			    vertical-align: middle;
			}
			
			.attiWeekCom {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid #aaa9ed;
			    background: #aaa9ed;
			    overflow: hidden;
			    margin: -2px 5px 0px 0px;
			    padding: 0;
			    vertical-align: middle;
			}
			
			.pencil {
				vertical-align: middle;
				margin-left: 5px;
			}
			
			.attiImg {
				vertical-align: middle;
				margin-top:-1px;
				margin-right : 3px;
			}
			
			.popupwrapAtt {
			  display: inline-block;
			  vertical-align: middle;
			  position: relative;
			  z-index: 2;
			  max-width: 565px;
			  box-sizing: border-box;
			  width: 90%;
			  background: #fff;
			  padding: 15px 30px;
			  -webkit-border-radius: 8px;
			  -moz-border-radius: 8px;
			  -o-border-radius: 8px;
			  -ms-border-radius: 8px;
			  border-radius: 8px;
			  -webkit-box-shadow: 0 0 10px #000;
			  -moz-box-shadow: 0 0 10px #000;
			  -o-box-shadow: 0 0 10px #000;
			  -ms-box-shadow: 0 0 10px #000;
			  box-shadow: 0 0 10px #000;
			  text-align: left;
			}
			
			.AttRedText {
				color : #ee1c25;
			}
			
			.AttBlueText {
				color : rgb(4, 112, 227);
			}
			
			.dateDiv {
				text-align: left;
				padding-left: 8px;
			}
			
			.popupwrapAtt {
			  display: inline-block;
			  vertical-align: middle;
			  position: relative;
			  z-index: 2;
			  max-width: 565px;
			  box-sizing: border-box;
			  width: 90%;
			  background: #fff;
			  padding: 15px 30px;
			  -webkit-border-radius: 8px;
			  -moz-border-radius: 8px;
			  -o-border-radius: 8px;
			  -ms-border-radius: 8px;
			  border-radius: 8px;
			  -webkit-box-shadow: 0 0 10px #000;
			  -moz-box-shadow: 0 0 10px #000;
			  -o-box-shadow: 0 0 10px #000;
			  -ms-box-shadow: 0 0 10px #000;
			  box-shadow: 0 0 10px #000;
			  text-align: left;
			}
			
			.AttRedText {
				color : red;
			}

			/* month picker */
			.ui-monthpicker>.ui-datepicker-header>.ui-datepicker-title>.ui-datepicker-year{ 
	 			margin: 0 auto; 
	 		}  
					
	 		.ui-monthpicker>.ui-datepicker-header>.ui-datepicker-title>.ui-datepicker-month { 
	 		  display: none; 
	 		} 
	 		
			.ui-monthpicker td span {
			  padding: 5px;
			  cursor: pointer;
			  text-align: center;
			}
			
			.popupJQLayer {
				padding : 9px 13px 5px
			}
			
			
			/*리스트형 테이블 관련 css*/
			.mainlist tr td.borderLeft {
				border-left :1px solid #e2e2e1;
			}
			
			#contentlist .mainlist tr.sat {
				background:#f7f9fd;
			}
			
			#contentlist .mainlist tr.sun {
				background:#fdf7f7;
			}
			
			#contentlist .mainlist tr.today {
				background:#f0f6ff;
			}
			
			#contentlist .mainlist td span.sat {
				color:rgb(0, 72, 149);
			}
			
			#contentlist .mainlist td span.sun {
				color:#ee1c25;
			}
			#contentlist .mainlist th.hideTd {
			    height: 0px;
			    padding: 0px;
			    font-size: 0px;
			    empty-cells: hide;
			    border: none;
			}
			#contentlist .mainlist tr.hideTr {
			    height: 0px;
			    width: 0px;
			    padding: 0px;
			    margin: 0px;
			}
			#attiTableListTB .mainlist th {
				text-align: center;
				overflow: hidden; 
				text-overflow: ellipsis; 
				white-space: nowrap;
				border: 1px solid #c8ccd0;
				background: #e4e8ec;
			}
			#attiTableListTB .mainlist td.textCenter {
				text-align: center;
			}
			#attiTableListTB .mainlist td.textLeft {
				padding-left: 20px;
			}
			.iconStrClass {
				padding-left: 15px;
			}
		</style>
		<script>
			var pMode = "";
			var uselang = "<c:out value='${userInfo.lang}'/>";
			var LunarUse = false;
			var deptFlag = "${deptFlag}";
			var adminFlag = "${adminFlag}";
			var companyHoliday = "${attitudeConfigVO.closedDay}"; //회사 휴무일
			var closedDateAttitude = "${attitudeConfigVO.closedDateAttitude}" == "0" ? false : true; //휴일근태등록 유무
			var attitudeModAppl = "${attitudeConfigVO.attitudeModAppl}" == "0" ? false : true; //근태수정신청 유무
			var modAttitudeId = "";         //수정신청 근태ID
			var modChangeDate = "";         //수정신청 변경일자
			var modContent = "";            //수정신청 내용
			var pageInfo = "viewCalendar";
			var week = "<spring:message code='ezAttitude.t140' />";
			var weekArray;
			var attitudeMapApiKey = "<c:out value='${attitudeMapApiKey}'/>";
			
			$(function(){
				authBtn();
				companyHoliday = companyHoliday.split(",");
				
				//개인근태현황에서만 근태 등록 가능
				if (deptFlag != "true") {
					$(document).on('dblclick', '.td_day td', function() {
						pMode = "new";
						attitudeNewItem(this);
					});
					$(document).on('dblclick', '.td_day2', function() {//표형식
						pMode = "new";
						attitudeNewItem(this);
					}); 
				} else { //부서근태현황에서는 당일의 근태를 조회.
					$(document).on('click', '.td_day td', function() {
						pMode = "new";
						searchByDay(this);
					});
				}
				
				$('#attiCalendar').on('dblclick', 'tr td[typeid]:not(td[typeid=A01], td[typeid=A02], td[typeid=A03], td[typeid=A25])', function() {
					attitudeItemView(this);
				});
				$(document).on('dblclick', '.td_day3', function() {//표형식 상세보기
					if($(this).attr("attitudeid")){						
						attitudeItemView(this);
					}
				});
				
				$(window).on("resize", function() {
					var popupX = parent.document.body.clientWidth/2 - (883/2) - 220;
					var popupDayX = parent.document.body.clientWidth/2 - (883/2) - 220;
					
		        	$("#popup").css("left", popupX);
		        	$("#popupDay").css("left", popupDayX);
		        	
		        	//테이블 리스트 resize조정.
		        	var height = parseInt(document.documentElement.clientHeight - 235);
		        	$("#contentlist").css("height", height +"px");
		        });
				
				//개인근태일경우 표보기 크롬일경우 테이블 ui틀어짐 조정
				if (deptFlag != "true") {
					if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
						$("#attiTableListTB th:eq(5)").css("border-right-color","#e4e8ec");
						//$("#attiTableListTB th:eq(6)").css("width","12px");
					}
				}
			});
			
			window.onload = function() {
				weekArray = week.split(";");
				
				/* select_memorialDays(uselang); */ // 공식 휴일 설정 => 언어에 따라 memorialDays에 변수가 담김
				
				scheduleGetLunarUse();
				
				
				CalendarView("attiCalendar");
				getAttiTypeList();
				
				$("#btnTableList span").click();
				
	        	var height = parseInt(document.documentElement.clientHeight - 235);
	        	$("#contentlist").css("height", height +"px");
			}
			
	        /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
	        	if (parent.frames["left"]) {
	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	        			$(parent.frames["left"].document.body).css("overflow", "");
	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	        		}
	        	} else if (parent.frames["attitude_menu"]) {
	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	        		}
	        	}
	        	      
	        	if (parent.parent.frames["left"]) {
	        		if (parent.parent.frames["board_menu"]) {  		  
	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	        		}
	        	}
	        }
			
			//datepicker
	    	$(function () {
			    $("#Sdatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
			    });
			});
			    
			var monthMsg = "<spring:message code='ezAttitude.t139'/>";
			var monthStr = monthMsg.split(";");		    
			var dayMsg = "<spring:message code='ezAttitude.t140'/>";
			var dayStr = dayMsg.split(";");
			
			$(function () {
				$.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
			    $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			    
			    $("#Sdatepicker").datepicker('disable');
			});
			
			function scheduleGetLunarUse() {
				if (uselang == 1) {
				    $.ajax({
			    		type : "GET",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezSchedule/scheduleGetLunarUse.do",
			    		data : {
			    			COMPANYID  : "${userInfo.companyID}"		    			
			    		},
			    		success: function(result) {		    			
			    			if (result == "0") {
			    				LunarUse = true;
			    			} else if(result == "1") {
			    				LunarUse = true;
			    			} else {
			    				LunarUse = false;
			    			}		    			
			    			getHolidayList();
			    		}
			        });
				} else {
					getHolidayList();
				}
			}
			
			/**
			* [개인근태현황, 부서근태현황] 근태유형 메소드
			*/
			function getAttiTypeList() {
				$.ajax({
					type : "get",
					dataType : "json",
					async : true,
					url : "/ezAttitude/attitudeTypeList.do",
					success : function(result) {
						getAttiTypeList_After(result);
					}
				})
			}
			
			/**
			* [개인근태현황, 부서근태현황] 통계바 메소드
			*/
			function getAttiTypeList_After(result) {
				//, "height":$("#attiCalendar").css("height")
				var objDiv = $("<div></div>").addClass("time_stats");
				var objP = $("<p></p>").addClass("statsP").text("<spring:message code='ezAttitude.t171'/>");
				var objUl = $("<ul></ul>").addClass("statsUL");
				var objLi = $("<li></li>");
				var objDl = "";
				var objDt = "";
				var objDd = "";
				
				objDiv.append(objP);
				for (var i = 0; i < result.length; i++) {
					objDl = $("<dl></dl>").addClass("statsDL");
					objDt = $("<dt></dt>");
					
					if (result[i].typeId == 'A01' || result[i].typeId == 'A03' || result[i].typeId == 'A05' || result[i].typeId == 'A25') {
						continue;
					} else {
						objDt.addClass(result[i].imgPath);
					}
// 					else if (result[i].typeId == 'A02') {
// 						objDt.addClass("inOut");
// 					} else if (result[i].typeId == 'A04' || result[i].typeId == 'A06' || result[i].typeId == 'A09' || result[i].typeId == 'A10') { //외근, 외출, 출장, 파견
// 						objDt.addClass("trip");
// 					} else if (result[i].typeId == 'A08' || result[i].typeId == 'A17') { //조퇴, 결근
// 						objDt.addClass("absence");
// 					} else { //휴근, 연차종류
// 						objDt.addClass("refresh");
// 					}
					objDt.html($("<div style='width:70px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + result[i].typeName.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></div>").html(result[i].typeName));
					objDd = $("<dd></dd>")
					 .text("0")
					 .attr("id", result[i].typeId)
					 .attr("parentId", result[i].parentId)
					 .click(function() {
						 searchByTypeId(this);
					 });
					
					objDl.append(objDt);
					objDl.append(objDd);
					objLi.append(objDl);
				}
				
				objUl.append(objLi);
				$("#attiStatis").append(objP);
				$("#attiStatis").append(objUl);
				
// 				window.onresize = function () {
// 			        $("#statisTB").css("height",$("#attiCalendar").css("height"));
// 			    }
			}
			
			/**
			* [개인근태현황, 부서근태현황] 통계 메소드
			*/
			function getAttiStatisList() {
				var pDate = $("#calTitle").text().trim(); 
				$.ajax({
					type : "get",
					dataType : "json",
					async : true,
					url : "/ezAttitude/attitudeStatisList.do",
					data : {
						date : pDate,
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
						$(".statsUL dd").text("0");
						$(".timeCountR").text("0");
						
						for (var i = 0; i < result.length; i++) {
							$("#" + result[i].typeId).text(result[i].count);
							
							if (result[i].typeId == "A02" || result[i].typeId == "A11" || result[i].typeId == "A12" || result[i].typeId == "A13" || result[i].typeId == "A21") {
								$("#F" + result[i].typeId).text(result[i].count);
							}
						}
					}
				})
			}
			
			/**
			* [개인근태현황, 부서근태현황] holiday 메소드
			*/
			function getHolidayList() {
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
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
																  isSolar, result.holidayList[i].isRest == 1 ? true : false, holidayFlag, repetition));
							} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
								yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
																		  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
																		  result.holidayList[i].holidayDate.substring(8,10), isSolar,
																		  result.holidayList[i].isRest == 1 ? true : false, holidayFlag, repetition));
							}
						}
					}
				})
			}
			
			/**
			* [개인근태현황, 부서근태현황] 근태 메소드
			*/
			function getAttitudeMainList() {
				var curYear = $("#calTitle").text().split("-")[0].trim();
				var curMonth = $("#calTitle").text().split("-")[1].trim();
				var startDate = curYear + "-" + curMonth + "-" + "01";
				var endDate = curYear + "-" + curMonth + "-" + (new Date(curYear, curMonth, 0)).getDate();
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : startDate,
						endDate : endDate,
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
						$("span[name=span_list] table tbody").remove();
						$("#index_0 > table > tbody > tr").not(':first').remove();
						getAttitudeMainList_after(result);
						getAttiStatisList();
					}
				})
			}
			
			/**
			* [개인근태현황, 부서근태현황] 근태 메소드
			*/
			function getAttitudeMainList_after(result) {
				console.time("attitudeTime");
				var startDate = "";   // 근태의 시작일
				var endDate = "";     // 근태의 종료일
				var betweenDate = ""; // 연속일자의 일자 저장
				var subDate = "";     // 연속일자로 등록된 근태의 날짜 차이를 저장
				var imgPath = "";	  // 이미지 경로
				var calendarHTML = document.getElementById("attiCalendar").innerHTML;
				var resultLength = result.length;
				var pDate = $("#calTitle").text().trim(); 
				if (deptFlag == false){ //개인근태현황일때
					for (var i = 0; i < resultLength; i++) {
						var tdHTML = "";
						var iconStr = "";
						//0과 2는 icon을 추가하지 않는다.
						if (result[i].modAppl  == '2') {
							iconStr = " <img class='pencil' src='/images/ezAttitude/change.png' />";
						} else if (result[i].modAppl  == '3') {
							iconStr = " <img class='pencil' src='/images/ezAttitude/change.png' />";
						}
						
						startDate = result[i].startDate.split(" ")[0]; 
						endDate = (result[i].endDate != undefined ? result[i].endDate.split(" ")[0] : "");
						if(pDate != startDate.substring(0, 7)) {
							continue;
						}
						 
						if (result[i].dateType == '4' || result[i].dateType == '5') { 
							subDate = calDateRange(startDate, endDate); 
							betweenDate = new Date(startDate); 
							 
							for (var j = 0; j<= subDate; j++) {
								betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1)); 
								var tdDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2);
								tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png'/>" + result[i].typeName + (result[i].region.trim() != "" ? " : " + result[i].region.trim() : "") + iconStr + "</td></tr>";
								calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>",calendarHTML.indexOf("TD_" + tdDay + "_Value")), tdHTML);
							}
						} else if (result[i].dateType == '3') { 
							tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png' style='vertical-align:middle'/>" + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + " ~ " + result[i].endDate.split(" ")[1].substring(0, 5) + iconStr + "</td></tr>";
							calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);
						} else if (result[i].dateType == '1') { 
							tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png' style='vertical-align:middle'/>" + result[i].typeName + iconStr + "</td></tr>";
							calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);
						} else {
							if(result[i].typeId == 'A25'){ //전일퇴근일 경우
								var date = new Date(startDate.substring(0,4), Number(startDate.substring(5,7))-1 , Number(startDate.substring(8,10)));
								date.setDate(date.getDate()-1);
								tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "' modappl='" + result[i].modAppl + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png' style='vertical-align:middle'/>" + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + " (" + Number(startDate.substring(8,10)) + "일)" + iconStr + "</td></tr>";
								calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + moment(date).format('YYYY-MM-DD') + "_Value")), tdHTML);																
							}else {
								tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "' modappl='" + result[i].modAppl + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png' style='vertical-align:middle'/>" + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + iconStr + "</td></tr>";
								calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);								
							}
						} 
					}
				} else { //부서근태현황일때
					for (var i = 0; i < resultLength; i++) {
						var iconStr = "";
						if (result[i].modAppl  == '2') {
							iconStr = " <img class='pencil' src='/images/ezAttitude/change.png' />";
						} else if (result[i].modAppl  == '3') {
							iconStr = " <img class='pencil' src='/images/ezAttitude/change.png' />";
						}
						if (result[i].typeId != 'A01' && result[i].typeId != 'A03' && result[i].typeId != null && result[i].typeId != 'A25') {
							startDate = result[i].startDate.split(" ")[0];
							endDate = (result[i].endDate != undefined ? result[i].endDate.split(" ")[0] : "");
							
							if (result[i].dateType == '4' || result[i].dateType == '5') {
								subDate = calDateRange(startDate, endDate);
								betweenDate = new Date(startDate);
								
								for (var j = 0; j<= subDate; j++) {
									betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1));
									var tdDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2);
									tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png'/>" + result[i].typeName + " : " + result[i].writerName + iconStr + "</td></tr>";
									calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>",calendarHTML.indexOf("TD_" + tdDay + "_Value")), tdHTML);
								}
							} else if (result[i].dateType == '3') {
								tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png'/>" + result[i].typeName + " : " + result[i].writerName + iconStr + "</td></tr>";
								calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);
							} else if (result[i].dateType == '1') {
								tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png'/>" + result[i].typeName + " : " + result[i].writerName + iconStr + "</td></tr>";
								calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);
							} else {
								if (result[i].typeId == "A02") {
									tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "' modappl='" + result[i].modAppl + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png'/>" + result[i].typeName + " (" + result[i].startDate.split(" ")[1].substring(0, 5) + ")" + " : " + result[i].writerName + iconStr + "</td></tr>";
									calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);
								} else {
									tdHTML = "<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "' modappl='" + result[i].modAppl + "'><img class='attiImg' src='/images/ezAttitude/" + result[i].imgPath + ".png'/>" + result[i].typeName + " : " + result[i].writerName + iconStr + "</td></tr>";
									calendarHTML = insertCalendarData(calendarHTML, calendarHTML.indexOf("</table>", calendarHTML.indexOf("TD_" + startDate + "_Value")), tdHTML);
								}
							}	
						}
					}
					if ($("#authDeptList option:selected").attr("authtype") != "M") {
						$("td[typeid=A02][modappl=0]").css('cursor','default');
					}
					
				}
				document.getElementById("attiCalendar").innerHTML = calendarHTML;
				checkAttiModAppl();
				console.timeEnd("attitudeTime");
			}
			
			function insertCalendarData(str, index, value) {
			    return str.substr(0, index) + value + str.substr(index);
			}
			
			/**
			* 두 날짜의 차이를 구하는 메소드
			* val1 = startDate, val2 = endDate
			*/
		    function calDateRange(val1, val2)
		    {
		        var FORMAT = "-";

		        // 년도, 월, 일로 분리
		        var start_dt = val1.split(FORMAT);
		        var end_dt = val2.split(FORMAT);

		        // Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
		        start_dt[1] = (Number(start_dt[1]) - 1) + "";
		        end_dt[1] = (Number(end_dt[1]) - 1) + "";

		        var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
		        var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

		        return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
		    }
			
			/**
			* [개인근태현황] 근태작성
			*/
			function attitudeNewItem(obj) {
				var date = $(obj).attr("dispdate");
				
				if (CrossYN()) {
                    var OpenWin = window.open("/ezAttitude/attitudeNewItem.do?date=" + date + "&mode=new", "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attitudeNewItem.do?date=" + date + "&mode=new", "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
			}
			
			/**
			* [개인근태현황] 근태수정신청
			*/
			function attitudeModItem(obj) {
				var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
				var feature = GetOpenPosition(790, 760);
				
				var attitudeId = $(obj).attr("attitudeId"); 
				var pTypeId = $(obj).attr("typeId");
				
				if (CrossYN()) {
                    var OpenWin = window.open("/ezAttitude/attitudeModItem.do?attitudeId=" + attitudeId, "attitudeNewItem",
                    		"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attitudeModItem.do?attitudeId=" + attitudeId, "",
                			"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
			}
			
			/**
			* [개인근태현황, 부서근태현황] 근태상세보기
			*/
			function attitudeItemView(obj) {
				var pAttitudeId = $(obj).attr("attitudeId"); 
				var pTypeId = $(obj).attr("typeId");
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeItemView.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", GetOpenWindowfeature(672, 640));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemView.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
				}
			}
			
			/**
			* [개인근태현황, 부서근태현황] 지각 수정 위한 상세보기
			*/
			function attitudeItemDetail(obj) {
				var pAttitudeId = obj.getAttribute("attitudeId"); 
				var pTypeId = obj.getAttribute("typeId")
				;
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", GetOpenWindowfeature(672, 640));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
				}
			}
			
			function layerHidden() {
		        $.modal.close();
		    }
			
			/*
				[개인근태현황, 부서근태현황] 근태 통계바 클릭시 뜨는 레이어 팝업창  출력
			*/
			function searchByTypeId(t) {
				var typeId = t.getAttribute("id");
				var typeName = t.previousSibling.innerText;
				var pDate = $("#calTitle").text().trim();
				var startDate = pDate + "-01";
				var endDate = pDate + "-" + ( new Date(pDate.split("-")[0],pDate.split("-")[1], 0) ).getDate();
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : startDate,
						endDate : endDate,
						deptFlag : deptFlag,
						typeId : t.getAttribute("id"),
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
				    	if (typeId == "A02" || typeId == "A07") {
				    		onlyTimePopup(result);
				    	} else if (typeId == "A04" || typeId == "A09" || typeId == "A10") {
				    		regionPopup(result);
				    	} else {
				    		contentPopup(result);
				    	}
				    },
				    complete : function() {
				    	try {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);	
				    	} catch(e) {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"attitude_main\"].layerHidden()'></div>").appendTo(parent.frames["attitude_menu"].document.body);
				    	}
			        	
						var popupName = "";
			        	if (typeId == 'A02' || typeId == 'A07') {
			        		popupName = "onlyTimePopup";
			        	} else if (typeId == "A04" || typeId == "A09" || typeId == "A10") {
			        		popupName =	"regionPopup";
					    } else {
			        		popupName = "contentPopup";
			        	}
			        	
			        	var popupX = parent.document.body.clientWidth / 2 - ($("#" + popupName).width() / 2) - 220;
			        	$("#" + popupName).css("left", popupX);

			        	document.getElementById(popupName + "_title").innerText = "<spring:message code='ezAttitude.t141'/>" + "[" + typeName.trim() + "]";
						
			        	$("#" + popupName).modal();
				    }
			    });
			}

			//지각,휴근
			function onlyTimePopup(result) {
				$('#onlyTimePopup_list tbody').children('tr').not(":first").remove();
				
				if (deptFlag == 'true') {
					if (result.length == 0) {
						var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:30%; height:0px; border:none;'></td>"));
			    		$("#onlyTimePopup_list tbody").append(uvobjTr);
			    		
			    		var objTr = $("<tr></tr>").append($("<td colspan='4' style='text-align:center; width:500px; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
			    		$("#onlyTimePopup_list tbody").append(objTr);
			    	}
					
			    	
			    	result.forEach(function(vo, index) {
			    		//no,이름,부서
						var objTr = $("<tr></tr>").append($("<td style='width:5%;'></td>").append($("<div style='width:36px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(index + 1)));
		    			objTr.append($("<td style='max-width:10%; width:10%;' title='" + vo.writerName + "'></td>").append($("<div style='width:72px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
		    			objTr.append($("<td style='width:10%;' title='" + vo.writerDeptName + "'></td>").append($("<div style='width:72px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerDeptName)));
			    		
			    		//일시
						if (vo.dateType == 2) {
			    			objTr.append("<td style='width:15%;'><div class='dateDiv' style='width:131px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>"+ vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div></td>");	
			    		} else if (vo.dateType == 3) {
			    			objTr.append("<td style='width:25%;'><div class='dateDiv' style='width:160px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
					    }
			    		
			    		$("#onlyTimePopup_list tbody").append(objTr);
			    	});
				} else {
					if (result.length == 0) {
			    		var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:25%; height:0px; border:none;'></td>"));
			    		$("#onlyTimePopup_list tbody").append(uvobjTr);
			    		
			    		var objTr = $("<tr></tr>").append($("<td colspan='2' style='text-align:center; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
			    		$("#onlyTimePopup_list tbody").append(objTr);
			    	}
			    	
			    	result.forEach(function(vo, index) {
			    		//no
			    		var objTr = $("<tr></tr>").append($("<td style='width:5%;'></td>").append($("<div style='width:36px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(index + 1)));
			    		
			    		//일시
			    		if (vo.dateType == 2) { //지각
			    			objTr.append("<td style='width:20%;'><div class='dateDiv' style='width:131px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>"+ vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div></td>");	
			    		} else if (vo.dateType == 3) { //휴근
			    			objTr.append("<td style='width:20%;'><div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
			    		}
			    		
			    		$("#onlyTimePopup_list tbody").append(objTr);
			    	});
				}
				
			}
			
			//외근,출장,파견
			function regionPopup(result) {
				$('#regionPopup_list tbody').children('tr').not(":first").remove();
				if (deptFlag == 'true') {
					if (result.length == 0) {
						var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:30%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:30%; height:0px; border:none;'></td>"));
			    		$("#regionPopup_list tbody").append(uvobjTr);
			    		
			    		var objTr = $("<tr></tr>").append($("<td colspan='5' style='text-align:center; width:500px; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
			    		$("#regionPopup_list tbody").append(objTr);
			    	}
					
			    	
			    	result.forEach(function(vo, index) {
			    		var statusContent = $("<p></p>").html((vo.region == "" ? "" : trim(vo.region))).text();
			    		
			    		//no,이름,부서
						var objTr = $("<tr></tr>").append($("<td style='width:5%;'></td>").append($("<div style='width:36px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(index + 1)));
		    			objTr.append($("<td style='max-width:10%; width:10%;' title='" + vo.writerName + "'></td>").append($("<div style='width:72px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
		    			objTr.append($("<td title='" + vo.writerDeptName + "'></td>").append($("<div style='width:72px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerDeptName)));
			    		
			    		//일시
			    		if (vo.dateType == 4 && vo.typeId != 'A04') { //출장,파견
			    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));

			    			//근무지
			    			if (result.length >= 15) {
			    				objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:189px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
			    				objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:205px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.typeId == 'A04') {//외근
			    			if (vo.dateType == 4) {
			    				objTr.append("<td><div class='dateDiv' style='width:239px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + "</div></td>");
			    			} else if (vo.dateType == 5) {
			    				objTr.append("<td><div class='dateDiv' style='width:239px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
			    			}
			    		
				    		//근무지
			    			if (result.length >= 15) {
			    				objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:134px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
			    				objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:140px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		}

		    			
			    		$("#regionPopup_list tbody").append(objTr);
			    	});
				} else {
			    	if (result.length == 0) {
			    		var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:235px; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:160px; height:0px; border:none;'></td>"));
			    		$("#regionPopup_list tbody").append(uvobjTr);
			    		
			    		var objTr = $("<tr></tr>").append($("<td colspan='3' style='text-align:center; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
			    		$("#regionPopup_list tbody").append(objTr);
			    	}
			    	
			    	result.forEach(function(vo, index) {
			    		var statusContent = $("<p></p>").html((vo.region == "" ? "" : trim(vo.region))).text();
			    		
			    		//no
			    		var objTr = $("<tr></tr>").append($("<td style='width:5%;'></td>").append($("<div style='width:36px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(index + 1)));
			    		
			    		//일시
			    		if (vo.dateType == 4 && vo.typeId != 'A04') { //출장,파견
			    			objTr.append($("<td style='width:20%;'></td>").append($("<div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));

			    			//근무지
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:174px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
			    				objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:190px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.typeId == 'A04') { //외근
			    			if (vo.dateType == 4) {
			    				objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:235px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));
			    			} else if (vo.dateType == 5) {
			    				objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>&nbsp;</div></td>");
			    			}
			    		
				    		//근무지
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:109px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
			    				objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:125px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		}
			    		
			    		
			    		$("#regionPopup_list tbody").append(objTr);
			    	});
				}
			}
			
			//외출,조퇴,결근,휴가유형들
			function contentPopup(result) {
				$('#contentPopup_list tbody').children('tr').not(":first").remove();
				if (deptFlag == 'true') {
					if (result.length == 0) {
						var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:30%; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:30%; height:0px; border:none;'></td>"));
			    		$("#contentPopup_list tbody").append(uvobjTr);
			    		
			    		var objTr = $("<tr></tr>").append($("<td colspan='5' style='text-align:center; width:500px; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
			    		$("#contentPopup_list tbody").append(objTr);
			    	}
		    		
			    	result.forEach(function(vo, index) {
			    		var statusContent = $("<p></p>").html((vo.content == null || vo.content == "" ? "" : trim(vo.content))).text();
			    		
			    		//no,이름,부서
						var objTr = $("<tr></tr>").append($("<td style='width:5%;'></td>").append($("<div style='width:36px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(index + 1)));
		    			objTr.append($("<td style='max-width:10%; width:10%;' title='" + vo.writerName + "'></td>").append($("<div style='width:72px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
		    			objTr.append($("<td title='" + vo.writerDeptName + "'></td>").append($("<div style='width:72px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerDeptName)));
			    		
			    		//일시
			    		if (vo.dateType == 1) { //결근,오전반차, 오후반차, 오전공가, 오후공가
			    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,11))));

			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:144px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:160px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.dateType == 2) { //조퇴
			    			if (vo.typeId == 'A02' || vo.typeId == 'A08') {
			    				objTr.append("<td><div class='dateDiv' style='width:170px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>"+ vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div></td>");	
			    			} else {
			    				objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:170px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,16))));
			    			}
			    		
			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:144px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:160px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.dateType == 3) { //외출
			    			objTr.append("<td style='width:20%;'><div class='dateDiv' style='width:170px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
			    		
			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:154px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:170px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.dateType == 4) { //연차,공가,경조,병가,추가된유형
			    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:170px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));
				    		
			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:144px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:160px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		}
			    		
			    		
			    		$("#contentPopup_list tbody").append(objTr);
			    	});
				} else {
			    	if (result.length == 0) {
			    		var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:175px; height:0px; border:none;'></td>"));
			    		uvobjTr.append($("<td style='width:227px; height:0px; border:none;'></td>"));
			    		$("#contentPopup_list tbody").append(uvobjTr);
			    		
			    		var objTr = $("<tr></tr>").append($("<td colspan='3' style='text-align:center; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
			    		$("#contentPopup_list tbody").append(objTr);
			    	}
			    	
			    	result.forEach(function(vo, index) {
			    		var statusContent = $("<p></p>").html((vo.content == null || vo.content == "" ? "" : trim(vo.content))).text();
			    		
			    		//no
			    		var objTr = $("<tr></tr>").append($("<td style='width:5%;'></td>").append($("<div style='width:36px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(index + 1)));
			    		
			    		//일시
			    		if (vo.dateType == 1) { //결근,오전반차, 오후반차, 오전공가, 오후공가
			    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:85px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,11))));

			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:301px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:317px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.dateType == 2) { //조퇴
			    			if (vo.typeId == 'A02' || vo.typeId == 'A08') {
			    				objTr.append("<td><div class='dateDiv' style='width:120px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>"+ vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div></td>");	
			    			} else {
			    				objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,16))));
			    			}

			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:266px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:282px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.dateType == 3) { //외출
			    			objTr.append("<td><div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");

			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:211px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:227px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		} else if (vo.dateType == 4) { //연차,공가,경조,병가,추가된유형
			    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:175px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));

			    			//내용
							if (result.length >= 15) {
								objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:211px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
					    		objTr.append($("<td title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:227px; padding:0px 5px 0px 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			}
			    		}
			    		
			    		$("#contentPopup_list tbody").append(objTr);
			    	});
				}


			}
			
			/*
				[부서근태현황] 일자 레이어팝업 출력
			*/
			function searchByDay(t) {
				
				var date = $(t).attr('dispdate');
				
				document.getElementById("popupDay_title").innerText = "<spring:message code='ezAttitude.t141'/> [" + date + "]";
				
				var result2;
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : date,
						endDate : date,
						deptFlag : deptFlag,
						typeId : "A25",
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
						result2 = result;
					}
				});
					
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : date,
						endDate : date,
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
				    	$('#addpopupDay_list tbody').children('tr').not(":first").remove();
				    	
				    	var len = result.length;
				    	
				    	if (len == 0) {
				    		var objTr = $("<tr></tr>").append($("<td colspan='7' style='text-align:center; width:820px; border-top:none;'></td>").text("<spring:message code='ezAttitude.t142'/>"));
				    		$("#addpopupDay_list tbody").append(objTr);
				    	} else {
				    		//전일퇴근과 기존 근태내역을 합친다.
				    		result2 = result2.concat(result);
				    		inoutAttitudeList(result2);
				    		attitudeList(result);
				    		
			    			var i = 1;
				    		$("#addpopupDay_list tr:not(tr:eq(0))").each(function() {
				    			if ($(this).attr("id") != null && $(this).attr("id") != "") {
					    			$(this).children("td").eq(0).html("<div style='width:35px; text-align:center; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + i + "</div>");
					    			i++;
				    			}
				    		});
				    	}
				    },
				    complete : function() {
				    	try {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);	
				    	} catch(e) {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"attitude_main\"].layerHidden()'></div>").appendTo(parent.frames["attitude_menu"].document.body);
				    	}
			        	
			        	var popupDayX = parent.document.body.clientWidth/2 - (883/2) - 220;
			        	
			        	$("#popupDay").css("left", popupDayX);
			        	
						$("#popupDay").modal();
				    }
			    });
			}
			
			function inoutAttitudeList(result) {
				var endTimeList = []; //퇴근시간 배열
				
		    	result.forEach(function(vo, index) {
		    		if (vo.typeId == "A01" || vo.typeId == "A03" || vo.typeId == "A02" || vo.typeId == "A07" || vo.typeId == "A08" || vo.typeId == "A25") { //출근, 퇴근/전일퇴근, 지각, 휴근, 조퇴
			    		//no, 이름, 출근, 퇴근, 근태유형, 일시, 근무지 및 내용
		    			if (vo.typeId == "A01") { //출근리스트
				    		var objTr = $("<tr id='TR_" + vo.writerId + "'></tr>").append($("<td style='width:5%'></td>"));
			    			objTr.append($("<td style='max-width:10%; width:10%;' title ='" + vo.writerName + "'></td>").append($("<div style='width:60px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
			    			if(attitudeMapApiKey != "" && vo.latitude != "") {
			    				objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").html("<span>" + vo.startDate.substring(11,16) + "</span><img style='cursor:pointer;vertical-align: bottom;' onclick='geolocation(" + vo.latitude + "," + vo.longitude +")' src='/images/ezSurvey/survey_result.png'>")));
			    			} else {
			    				objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").html("<span>" + vo.startDate.substring(11,16) + "</span>")));
			    			}
			    			objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
				    		objTr.append($("<td style='max-width:8%; width:8%;' title ='" + "<spring:message code='ezAttitude.t231'/>" + "'></td>").append($("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text("<spring:message code='ezAttitude.t231'/>")));
			    			objTr.append($("<td style='max-width:10%; width:30%;'></td>").append($("<div style='width:75px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    				objTr.append($("<td style='width:30%;'></td>").append($("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    			} else if (vo.typeId == "A03" || vo.typeId == "A08" || vo.typeId == "A25") { //퇴근/전일퇴근, 조퇴
		    				endTimeList.push(vo);
		    			} else if (vo.typeId == "A02") { //지각
				    		var objTr = $("<tr id='TR_" + vo.writerId + "'></tr>").append($("<td style='width:5%'></td>"));
			    			objTr.append($("<td style='max-width:10%; width:10%;' title ='" + vo.writerName + "'></td>").append($("<div style='width:60px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
			    			if(attitudeMapApiKey != "" && vo.latitude != "") {
			    				objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").html("<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span><img style='cursor:pointer;vertical-align: bottom;' onclick='geolocation(" + vo.latitude + "," + vo.longitude + ")' src='/images/ezSurvey/survey_result.png'>")));
			    			} else {
			    				objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").html("<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span>")));
			    			}
			    			objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
			    			objTr.append($("<td style='max-width:8%; width:8%;' title ='" + vo.typeName + "'></td>").append($("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.typeName)));
			    			objTr.append($("<td style='max-width:10%; width:30%;'></td>").append($("<div style='width:75px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    				objTr.append($("<td style='width:30%;'></td>").append($("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    			} else { //휴근
				    		var objTr = $("<tr id='TR_" + vo.writerId + "'></tr>").append($("<td style='width:5%'></td>"));
			    			objTr.append($("<td style='max-width:10%; width:10%;' title ='" + vo.writerName + "'></td>").append($("<div style='width:60px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
			    			objTr.append($("<td style='max-width:10%; width:10%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").html("<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>")));
			    			objTr.append($("<td style='max-width:10%; width:10%;'></td>").append($("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").html("<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>")));
			    			objTr.append($("<td style='max-width:8%; width:8%;' title ='" + vo.typeName + "'></td>").append($("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.typeName)));
			    			objTr.append($("<td style='max-width:10%; width:30%;'></td>").append($("<div style='width:75px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    				objTr.append($("<td style='width:30%;'></td>").append($("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    			}
		    		}
		    		
		    		if (vo.typeId == null || vo.typeId == "") {
		    			objTr = $("<tr id='TR_" + vo.writerId + "'></tr>").append($("<td style='width:5%'></td>"));
		    			objTr.append($("<td style='max-width:10%; width:10%;' title ='" + vo.writerName + "234'></td>").append($("<div style='width:60px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
		    			objTr.append($("<td style='max-width:10%; width:10%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    			objTr.append($("<td style='max-width:10%; width:10%;'></td>").append($("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));

		    			if (uselang == 1) {
							objTr.append($("<td style='max-width:8%; width:8%;' title ='" + "<spring:message code='ezAttitude.t61'/>" + "'></td>").append($("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text("<spring:message code='ezAttitude.t61'/>")));
		    			} else {
			    			objTr.append($("<td style='max-width:8%; width:8%;' title ='" + "<spring:message code='ezAttitude.t61'/>" + "'></td>").append($("<div style='width:100px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text("<spring:message code='ezAttitude.t61'/>")));
		    			}

		    			objTr.append($("<td style='max-width:10%; width:30%;'></td>").append($("<div style='width:75px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    			objTr.append($("<td style='width:30%;'></td>").append($("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
		    		} 
		    		if (objTr) {
			    		$("#addpopupDay_list tbody").append(objTr);
		    		}
		    		
	    		});		    	
		    	//퇴근 리스트
		    	endTimeList.forEach(function(vo, index) {
		    		if (vo.typeId == "A08") { //조퇴
		    			if(attitudeMapApiKey != "" && vo.latitude != "") {
		    				$("#TR_" + vo.writerId + " td:eq(3)").html("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><span class='AttRedText'>" + vo.startDate.substring(11,16) + "</span><img style='cursor:pointer;vertical-align: bottom;' onclick='geolocation(" + vo.latitude + "," + vo.longitude +")' src='/images/ezSurvey/survey_result.png'></div>")
		    			} else {
			    			$("#TR_" + vo.writerId + " td:eq(3)").html("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><span class='AttRedText'>" + vo.startDate.substring(11,16) + "</span></div>");
		    			}
		    		
			    		if ($("#TR_" + vo.writerId + " td:eq(4)").text() == "<spring:message code='ezAttitude.t113' />") {//지각이면 "지각,조퇴" 형태로 되게끔.
		    				$("#TR_" + vo.writerId + " td:eq(4)").html("<div style='width:55px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><spring:message code='ezAttitude.t113' />" + ", " + vo.typeName + "</div>");
			    			$("#TR_" + vo.writerId + " td:eq(4)").attr("title", "<spring:message code='ezAttitude.t113' />" + ", " + vo.typeName);
		    			} else {
		    				$("#TR_" + vo.writerId + " td:eq(4)").html("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.typeName + "</div>");
			    			$("#TR_" + vo.writerId + " td:eq(4)").attr("title", vo.typeName);
		    			}
		    		} else if (vo.typeId == "A25") { //전일퇴근
		    			if(attitudeMapApiKey != "" && vo.latitude != "") {
		    				$("#TR_" + vo.writerId + " td:eq(3)").html("<div style='width:86px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(11,16) + " (" + Number(vo.startDate.substring(8,10)) + "일)" + "<img style='cursor:pointer;vertical-align: bottom;' onclick='geolocation(" + vo.latitude + "," + vo.longitude +")' src='/images/ezSurvey/survey_result.png'></div>");
		    			} else {
		    				$("#TR_" + vo.writerId + " td:eq(3)").html("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(11,16) + " (" + Number(vo.startDate.substring(8,10)) + "일)" + "</div>");		    				
		    			}
		    		} else { //퇴근
		    			if(attitudeMapApiKey != "" && vo.latitude != "") {
		    				$("#TR_" + vo.writerId + " td:eq(3)").html("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(11,16) + "<img style='cursor:pointer;vertical-align: bottom;' onclick='geolocation(" + vo.latitude + "," + vo.longitude +")' src='/images/ezSurvey/survey_result.png'></div>");
		    			} else {
		    				$("#TR_" + vo.writerId + " td:eq(3)").html("<div style='width:70px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(11,16) + "</div>");		    				
		    			}
		    		}
		    	});
			}
			function attitudeList(result) {
		    	result.forEach(function(vo, index) {
					if (vo.typeId != "A01" && vo.typeId != "A03" && vo.typeId != "A02" && vo.typeId != "A07" && vo.typeId != "A08" && vo.typeId != null && vo.typeId != "A25") { //출근, 퇴근/전일퇴근, 지각, 휴근, 조퇴가 아니면
			    		var contentTrim = $.trim($("<p></p>").html(vo.content).text());
			    		var statusContent = "";
			    		
			    		if (vo.typeId == "A04" || vo.typeId == "A09" || vo.typeId == "A10") { //근무지
				    		statusContent = $("<p></p>").html((vo.region == "" ? "" : vo.region)).text();
				    	} else {
				    		statusContent = $("<p></p>").html((contentTrim == "" ? "" : contentTrim)).text();
				    	}
		    			
			    		var listTrId = "";
			    		//리스트에 이미 있는지 체크
			    		$("#addpopupDay_list tr:not(tr:eq(0))").each(function() {
			    			var trId = $(this).attr("id");
				    		if (trId && $(this).attr("id").split("_")[1] == vo.writerId) {
				    			listTrId = $(this).attr("id");
				    		}
			    		});
			    		
			    		if (listTrId != "") { //리스트에 이미 있는 경우
			    			if ($("#" + listTrId + " td:eq(5) div").text() == null || $("#" + listTrId + " td:eq(5) div").text() == "") { //
				    			//유형
				    			$("#" + listTrId + " td:eq(4)").html("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.typeName + "</div>");
				    			$("#" + listTrId + " td:eq(4)").attr("title",vo.typeName);
				    			
				    			//일시
				    			if (vo.dateType == 1) {
					    			$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "</div>");
					    		} else if (vo.dateType == 2) {
					    			if (vo.typeId == 'A08') {
					    				$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div>");	
					    			} else {
						    			$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,16) + "</div>");
					    			}
					    		} else if (vo.dateType == 3) { //외출
					    			$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div>");
					    		} else if (vo.dateType == 4 && vo.typeId != 'A04') { //출장,파견,공가
					    			$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + "</div>");
					    		} else if (vo.typeId == 'A04') { //외근
					    			if (vo.dateType == 4) {
						    			$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + "</div>")
					    			} else if (vo.dateType == 5) {
						    			$("#" + listTrId + " td:eq(5)").html("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div>");
					    			}
					    		}
				    			
					    		//근무지 및 내용
				    			if (result.length >= 15) {
					    			$("#" + listTrId + " td:eq(6)").html("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + statusContent + "</div>")
				    			} else {
					    			$("#" + listTrId + " td:eq(6)").html("<div style='width:235px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + statusContent + "</div>")
				    			}
				    			$("#" + listTrId + " td:eq(6)").attr("title",statusContent);
			    			} else {
				    			var objTr = $("<tr></tr>").append($("<td style='max-width:8%; width:8%;' title ='" + vo.typeName + "'></td>").append($("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.typeName)));
					    		//일시
				    			if (vo.dateType == 1) {
					    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,11))));
					    		} else if (vo.dateType == 2) { //조퇴
					    			if (vo.typeId == 'A08') {
					    				objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>"+ vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div></td>");	
					    			} else {
						    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,16))));
					    			}
					    		} else if (vo.dateType == 3) {
					    			objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
					    		} else if (vo.dateType == 4 && vo.typeId != 'A04') {
					    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));
					    		} else if (vo.typeId == 'A04') {
					    			if (vo.dateType == 4) {
					    				objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));
					    			} else if (vo.dateType == 5) {
					    				objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
					    			}
					    		}
				    			
					    		//근무지 및 내용
				    			if (result.length >= 15) {
				    				objTr.append($("<td style='width:30%;' title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
				    			} else {
				    				objTr.append($("<td style='width:30%;' title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:235px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));			    				
				    			}
					    		
				    			$("#" + listTrId).after(objTr);
				    			
				    			if ($("#" + listTrId + " td:eq(0)").attr("rowspan") == null || $("#" + listTrId + " td:eq(0)").attr("rowspan") == "") {
					    			$("#" + listTrId + " td:eq(0)").attr("rowspan",2);
					    			$("#" + listTrId + " td:eq(1)").attr("rowspan",2);
					    			$("#" + listTrId + " td:eq(2)").attr("rowspan",2);
					    			$("#" + listTrId + " td:eq(3)").attr("rowspan",2);
				    			} else {
				    				var rowspanVal = Number($("#" + listTrId + " td:eq(0)").attr("rowspan")) + 1;
					    			$("#" + listTrId + " td:eq(0)").attr("rowspan",rowspanVal);
					    			$("#" + listTrId + " td:eq(1)").attr("rowspan",rowspanVal);
					    			$("#" + listTrId + " td:eq(2)").attr("rowspan",rowspanVal);
					    			$("#" + listTrId + " td:eq(3)").attr("rowspan",rowspanVal);
				    			}
			    			}
			    		} else {
			    			//no, 이름, 출근, 퇴근, 근태유형, 일시, 근무지 및 내용
			    			var objTr = $("<tr id='TR_" + vo.writerId + "'></tr>").append($("<td style='width:5%'></td>"));
			    			objTr.append($("<td style='max-width:10%; width:10%;' title ='" + vo.writerName + "'></td>").append($("<div style='width:60px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.writerName)));	
			    			objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
			    			objTr.append($("<td style='max-width:7%; width:7%;'></td>").append($("<div style='width:55px; padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>")));
				    		objTr.append($("<td style='max-width:8%; width:8%;' title ='" + vo.typeName + "'></td>").append($("<div style='width:55px; padding-left:8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.typeName)));
				    		
				    		//일시
			    			if (vo.dateType == 1) {
				    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,11))));
				    		} else if (vo.dateType == 2) { //조퇴
				    			if (vo.typeId == 'A08') {
				    				objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>"+ vo.startDate.substring(0,11) + "<span class='AttRedText'>" +vo.startDate.substring(11,16) + "</span></div></td>");	
				    			} else {
					    			objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,16))));
				    			}
				    		} else if (vo.dateType == 3) {
				    			objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
				    		} else if (vo.dateType == 4 && vo.typeId != 'A04') {
			    				objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));
				    		} else if (vo.typeId == 'A04') {
				    			if (vo.dateType == 4) {
				    				objTr.append($("<td></td>").append($("<div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10))));
				    			} else if (vo.dateType == 5) {
				    				objTr.append("<td><div class='dateDiv' style='width:240px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span></div></td>");
				    			}
				    		}
			    			
				    		//근무지 및 내용
			    			if (result.length >= 15) {
			    				objTr.append($("<td style='width:30%;' title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:221px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));
			    			} else {
			    				objTr.append($("<td style='width:30%;' title='" + statusContent.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></td>").append($("<div style='width:235px; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></div>").text(statusContent)));			    				
			    			}
				    		
				    		$("#addpopupDay_list tr:eq(0)").after(objTr);
			    		}
					}
	    		});
			}
			
			/**
			* [개인근태현황, 부서근태현황] 지각 상세보기
			*/
			function mod_detail(modAttId) {
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
				var feature = GetOpenPosition(790, 760);
				
				if (adminFlag == "true") {
					window.open("/ezAttitude/attModAppDetail.do?attModId=" + modAttId +"&adminFlag=" + adminFlag + "&pageInfo=" + pageInfo, "",
				 			"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				} else {
					window.open("/ezAttitude/attModAppDetail.do?attModId=" + modAttId + "&pageInfo=" + pageInfo, "",
				 			"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);	
				}
		    }
			
			/**
			* 정사각형 색 아이콘 표기
			*/
// 			function setAttitudeSquare(){
// 				//tdClassName = attiVacation, attiDefault, attiOutCom, attiLate, attiModLate, attiWeekCom
// 				$("span[name=span_list] td[attitudeid]").each(function(index){
// 					var squareSpan = $("<span></span>");
// 					var tdTypeId = $(this).attr("typeid");
// 					var tdParentId = $("#attiStatis td[typeid=" + tdTypeId + "]").attr("parentid");
// 					var tdClassName = "";
// 					switch(tdTypeId)
// 					{
// 						case "A01": case "A03": case "A06": case "A07"://출근, 퇴근, 외출, 조퇴
// 							if ($(this).attr("modAppl") == 1 || $(this).attr("modAppl") == 2) {
// 								tdClassName = "attiModLate";
// 							} else {
// 							    tdClassName = "attiDefault";
// 							}
// 							break;
// 						case "A04": case "A09": case "A10": //외근, 출장, 휴가
// 							tdClassName = "attiOutCom";
// 							break;
// 						case "A02": case "A08": //지각
// 							if ($(this).attr("modAppl") == 1 || $(this).attr("modAppl") == 2) {
// 								tdClassName = "attiModLate";
// 							} else {
// 							    tdClassName = "attiLate";
// 							}
// 							break;
// 						default: //나머지 휴가
// 							tdClassName = "attiVacation";
// 							break;
// 					}
// 					$(this).prepend(squareSpan.addClass(tdClassName));
// 				});
				
// 				checkAttiModAppl(); //근태수정신청 비허용인 경우 dblclick 제거
// 			}
			
			//근태수정신청 비허용인 경우 dblclick 제거
			function checkAttiModAppl(){
				if (!attitudeModAppl) {
					$('#attiCalendar tr td[typeid=A02],[typeid=A01]').each(function(){
							if ($(this).attr("modappl") == 0) {
								$(this).css("cursor", "default");
							}
					});
				}
				
				$('#attiCalendar').off('dblclick', 'tr td[typeid=A02],[typeid=A01]');
				
				$('#attiCalendar').on('dblclick', 'tr td[typeid=A02],[typeid=A01]', function(){
					//근태수정신청은 개인근태현황에서만 가능
					var typeid = $(this).attr('typeid');
					var modappl = $(this).attr('modappl');
					var attitudeid = $(this).attr('attitudeid');
					if (deptFlag != "true") {
						if (attitudeModAppl && modappl == 0 && typeid == 'A02') {
							attitudeModItem(this);	
						}
						if (modappl == 1 || modappl == 2 || modappl == 3 || modappl == 4) {
							mod_detail(attitudeid);
						}
					} else {
						if (modappl == 0 && typeid == 'A02') {
		 					if ($("#authDeptList option:selected").attr("authtype") == "M") { //관리자의 경우 지각인 근태는 수정할 수 있도록
	 							attitudeItemDetail(this);
	 						}	
						} else if (modappl == 1 || modappl == 2 || modappl == 3 || modappl == 4) {
		 					if ($("#authDeptList option:selected").attr("authtype") == "M") { //관리자의 경우 지각인 근태는 수정할 수 있도록
	 							attitudeItemDetail(this);
	 						} else {
								mod_detail(attitudeid);
	 						}
						}
					}
				});
				
			}
			
			/**
			* [부서근태현황] 미입력자관리 버튼 클릭시
			*/
			function popupAbsentedList() {
    			var url = "/ezAttitude/popupAbsentedList.do?deptId=" + encodeURIComponent(authDeptList.value) + "&date=" + $("#calTitle").text().trim();
	    		
	    		if (CrossYN()) {
	    			OpenWin = GetOpenWindow(url, "", "600", "700");
	    			
	    			try { OpenWin.focus();} catch (e) { }
	    		} else {
	    			showModalDialog(url, null, "dialogWidth:600px; dialogHeight:700px; status:no; help:no; scroll:no; edge:sunken");
	    		}
	    	}
			
			/**
			* [부서근태현황] 엑셀다운로드버튼 클릭시
			*/
			function excelDown() {
				var pDate = $("#calTitle").text().trim();
				var startDate = pDate + "-01";
				var endDate = pDate + "-" + ( new Date(pDate.split("-")[0],pDate.split("-")[1], 0) ).getDate();
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : startDate,
						endDate : endDate,
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(attList) {
						$('#ExcelAttList tbody').children( 'tr:not(:first)' ).remove();
						for (var i = 0 ; i < attList.length; i ++) {
				    		var htmlStr = "";
				    		htmlStr += '<tr>';
			    			htmlStr += '<td>' + (parseInt(i) + 1) + '</td>';
			    			htmlStr += '<td>' + attList[i].typeName + '</td>';
		    				htmlStr += '<td>' + attList[i].writerName + '</td>';
		    				htmlStr += '<td>' + attList[i].writerDeptName + '</td>';
		    				if (attList[i].endDate == null) {
		    					htmlStr += '<td>' + attList[i].startDate + '</td>';
				    		} else {
				    			htmlStr += '<td>' + attList[i].startDate + '\u00a0~\u00a0' + attList[i].endDate + '</td>';
				    		}
		    				htmlStr += '</tr>';
		    				$('#ExcelAttList tbody').append(htmlStr);
						}
		    			btnexportexcel_onclick();
					}
				});
			}
			
			/**
			* [부서근태현황] 엑셀다운로드버튼 클릭시
			*/
			function btnexportexcel_onclick() {
	            document.getElementById("saveExcelData").value = $("#ExcelAttList")[0].outerHTML;
	            document.getElementById("formAgent").target = "saveExcel";
	            document.getElementById("formAgent").submit();
	        }
			
			/**
			* [부서근태현황] 부서 셀렉트 박스 변경시
			*/
			function deptChange() {
				if (authDeptList.value == "")
					getAttitudeMainList();
		        else {
		        	authBtn();
		        	getAttitudeMainList();
		        }
			}
			
			/**
			* [부서근태현황] 권한에따라 버튼 보이기 유무
			*/
			function authBtn() { // 권한이 없을 때
				if ($("#authDeptList option:selected").attr("authType") == "" || $("#authDeptList option:selected").attr("authType") == null || $("#authDeptList option:selected").attr("authType") == "R") {
					if ($("#btnAbsentedList")) {
						$("#btnAbsentedList").remove();
						$("#btnExcelDown").remove();
					}
				} else { // 권한이 있을 때
					if (!$("#btnAbsentedList")) { // 이미 버튼이 있을때
						var absentedList = $("<li>", { id: "btnAbsentedList" }).append(
							$("<span>", {
								on: {
									click: function () {
										popupAbsentedList();
									}
								}
							}).append(
								$("<spring\\:message>", { code: "ezAttitude.t6" })
							)
						);
						var excelDown = $("<li>", { id: "btnExcelDown" }).append(
							$("<span>", {
								on: {
									click: function () {
										excelDown();
									}
								}
							}).append(
								$("<spring\\:message>", { code: "ezAttitude.t145" })
							)
						);
						$("#mainmenu .on").append(absentedList);
						$("#mainmenu .on").append(excelDown);
					}
				}
			}
			
			function popup_close() {
		    	$.modal.close();
		    }
			
			//month picker
		    $('.ui-datepicker-trigger').click(function(){
		    	$('.ui-datepicker-month').css('display','none');
		    });	
			
			
			
			/**
			* [개인근태현황] 달력형보기, 리스트형보기
			*/
			
			//달력형
			function getAttitudeCalList() {
				getAttitudeMainList();
				
				$("#attiCalendarTB").css("display","");
				$("#attiTableListTB").css("display","none");
				$("#btnCalList").addClass("on");
				$("#btnTableList").removeClass("on");
			}
			
			//리스트형
			function getAttitudeTableList() {
				var curYear = $("#calTitle").text().split("-")[0].trim();
				var curMonth = $("#calTitle").text().split("-")[1].trim();
				var startDate = curYear + "-" + curMonth + "-" + "01";
				var endDate = curYear + "-" + curMonth + "-" + (new Date(curYear, curMonth, 0)).getDate();
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : startDate,
						endDate : endDate,
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
						getAttitudeTableList_after(result, endDate);
					}
				})
				
				$("#attiCalendarTB").css("display","none");
				$("#attiTableListTB").css("display","");
				$("#btnCalList").removeClass("on");
				$("#btnTableList").addClass("on");
				
				//month picker 호출함수    
			    var WstartDate, WendDate; 
			    var monthCssHidden = function(){
					window.setTimeout(function(){
						 $('.ui-datepicker-month').css('display','none');
						 $('.ui-datepicker-year').css('margin','0 auto');
					}, 1);
				}
			    var monthCssShow = function(){
					window.setTimeout(function(){
						 $('.ui-datepicker-month').css('display','');
						 $('.ui-datepicker-year').css('margin','');
					}, 1);
				}
			    var removeMonthClass = function(){
					window.setTimeout(function(){
						 $('#ui-datepicker-div').removeClass('ui-monthpicker');
					}, 1);
				}
			       
			    $(".datePick").monthpicker({
			    	showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true,
					onSelect: function (dateText, inst) {
						var iMonth = parseInt($('.datePick').val().substring(5,7),10)-1;
						var iYear = $('.datePick').val().substring(0,4);
						var iDay = $('.datePick').val().substring(8,10);
						
						var beforeMonth = leadingZeros((sDate.getMonth() + 1), 2) - 1; 	   
						var beforeYear = sDate.getFullYear();
						
						sDate.setFullYear(iYear, iMonth, iDay); 
						if(iYear == beforeYear && iMonth == beforeMonth){
							return;   			   
						}else CalendarView("attiCalendar");

					}
			    }); 
			}
			
			function getAttitudeTableList_after(result, endDate) {
				var tbodyHtml = "";
								
				//td
				var cal = new Date();
				var today = cal.getFullYear() + "-" + (cal.getMonth()+1) + "-" + cal.getDate();
				var year = endDate.substring(0,4);
				var month  = endDate.substring(5,7);
				var endDay = Number(endDate.split("-")[2]) + 1;
	    		for (var i = 1; i < endDay; i++) {
	    			//한자리 숫자면 앞에 0을 붙여준다.
	    			var j = i + "";
	    			if (j.length == 1) {
	    				j = "0" + j
	    			}
					var oThisDate = new Date(year + "-" + month + "-" + j);
	    			var memorialResult = setMemorial(oThisDate);
	    			var isholiday = memorialResult[0];
	    			var holidayname = memorialResult[1];
	    			var holidayname2 = memorialResult[2];
	    			
	    			//토요일 일요일은 text색상이 다름.
	    			var dayClass = "";
	    			var dayIdx = new Date(year + "-" + month + "-" + j).getDay();
	    			if (dayIdx == 0 || isholiday || (dayIdx != 6 && companyHoliday[dayIdx] == "1")) {
	    				dayClass = "sun";
	    			} else if (dayIdx == 6) {
	    				dayClass = "sat";	
	    			}
	    			
	    			if (year + "-" + month + "-" + j == today) {
	    				if (isholiday) {
		    				dayClass = "today sun";
	    				} else {
	    					dayClass = "today";
	    				}
	    			}
	    			
	    			//음력
					var lunarDate2; // 음력월.음력일 => 달력에 음력일을 표시해주기 위한 변수
	    			if (LunarUse) {
						var lunarDate; // 음력 날짜를 저장하기 위한 변수
						if (year > 1800 && year <= 2101) { // 음력에 대한 날짜 제공은 1800 ~ 2101
							lunarDate = lunarCalc(year, month, i, 1);
							
							lunarDate2 = lunarDate.month + "." + lunarDate.day;
							if (lunarDate.leapMonth) {
								lunarDate2 = "윤" + lunarDate2;
							}
						}
	    			}
	    			
	    			tbodyHtml += "<tr class='" + dayClass + "' id='" + year + "-" + month + "-" + j + "'>";
	    			if (LunarUse) {
    					tbodyHtml += "<td class='borderLeft textCenter td_day2' style='width:12%;cursor:pointer' dispdate='" + year + "-" + month + "-" + j + "'><span class='" + dayClass + "'>" + month + "-" + j + " (" + lunarDate2 + ") </span></td>";//날짜
	    			} else {
    					tbodyHtml += "<td class='borderLeft textCenter td_day2' style='width:12%;cursor:pointer' dispdate='" + year + "-" + month + "-" + j + "'><span class='" + dayClass + "'>" + month + "-" + j + "</span></td>";//날짜
	    			}
	    			tbodyHtml += "<td class='borderLeft textCenter' style='width:12%'></td>";
	    			tbodyHtml += "<td class='borderLeft textCenter' style='width:12%'></td>";
	    			tbodyHtml += "<td class='borderLeft textCenter' style='width:12%'></td>";
	    			tbodyHtml += "<td class='borderLeft textLeft td_day3' style='width:20%'></td>";
	    			tbodyHtml += "<td class='borderLeft textLeft' style='width:32%'></td>";
	    			tbodyHtml += "</tr>";
	    		}

				
				$("#contentlist .mainlist").html(tbodyHtml);
				
				
				result.forEach(function(vo, index) {
					//수정신청 아이콘
	    			var iconStr = "";
					var iconStrClass = "";
					if (vo.modAppl  == '2') {
						iconStr = " <img class='pencil' src='/images/ezAttitude/change.png' />";
						iconStrClass = "iconStrClass";
					} else if (vo.modAppl  == '3') {
						iconStr = " <img class='pencil' src='/images/ezAttitude/change.png' />";
						iconStrClass = "iconStrClass";
					}
					
					if(vo.typeId == "A25") {
						var date = new Date(vo.startDate.substring(0,4), Number(vo.startDate.substring(5,7))-1 , Number(vo.startDate.substring(8,10)));
						date.setDate(date.getDate()-1);						
					}
					
					var typeText = (vo.typeId == "A25") ? $("#contentlist .mainlist tr#" + moment(date).format('YYYY-MM-DD') + " td:eq(3)").text() : $("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").text();
					
					//출근, 퇴근/전일퇴근, 지각, 휴근, 조퇴
		    		if (vo.typeId == "A01" || vo.typeId == "A03" || vo.typeId == "A02" || vo.typeId == "A07" || vo.typeId == "A08" || vo.typeId == "A25") { 
			    		// 출근, 퇴근/전일퇴근, 근태유형
		    			if (vo.typeId == "A01") { //출근리스트
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").html("<span class='" + iconStrClass + "'>" + vo.startDate.substring(11,16) + "</span>" + iconStr);
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", "<spring:message code='ezAttitude.t64' />");
			    			var attitudeTypeText = $("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").text();
			    			if (attitudeTypeText == "" || attitudeTypeText == "<spring:message code='ezAttitude.t113' />") {			    				
					    		$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").html("<spring:message code='ezAttitude.t64' />");
			    			}
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").attr({typeid : vo.typeId, attitudeid : vo.attitudeId, modappl : vo.modAppl, style : "cursor:pointer; width:12%"});
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").on('dblclick',function(){
			    				var typeid = $(this).attr('typeid');
								var modappl = $(this).attr('modappl');
								var attitudeid = $(this).attr('attitudeid');
								if (deptFlag != "true") {
									if (attitudeModAppl && modappl == 0 && typeid == 'A02') {
										attitudeModItem(this);	
									}
									if (modappl == 1 || modappl == 2 || modappl == 3 || modappl == 4) {
										mod_detail(attitudeid);
									}
								} else {
									if (modappl == 0 && typeid == 'A02') {
					 					if ($("#authDeptList option:selected").attr("authtype") == "M") { //관리자의 경우 지각인 근태는 수정할 수 있도록
				 							attitudeItemDetail(this);
				 						}	
									} else if (modappl == 1 || modappl == 2 || modappl == 3 || modappl == 4) {
					 					if ($("#authDeptList option:selected").attr("authtype") == "M") { //관리자의 경우 지각인 근태는 수정할 수 있도록
				 							attitudeItemDetail(this);
				 						} else {
											mod_detail(attitudeid);
				 						}
									}
								}
			    			});

		    			} else if (vo.typeId == "A02") { //지각
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").html("<span class='AttRedText " + iconStrClass + "'>" + vo.startDate.substring(11,16) + "</span>" + iconStr);
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").attr({typeid : vo.typeId, attitudeid : vo.attitudeId, modappl : vo.modAppl, style : "cursor:pointer; width:12%"});
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").on('dblclick',function(){
			    				var typeid = $(this).attr('typeid');
								var modappl = $(this).attr('modappl');
								var attitudeid = $(this).attr('attitudeid');
								if (deptFlag != "true") {
									if (attitudeModAppl && modappl == 0 && typeid == 'A02') {
										attitudeModItem(this);	
									}
									if (modappl == 1 || modappl == 2 || modappl == 3 || modappl == 4) {
										mod_detail(attitudeid);
									}
								} else {
									if (modappl == 0 && typeid == 'A02') {
					 					if ($("#authDeptList option:selected").attr("authtype") == "M") { //관리자의 경우 지각인 근태는 수정할 수 있도록
				 							attitudeItemDetail(this);
				 						}	
									} else if (modappl == 1 || modappl == 2 || modappl == 3 || modappl == 4) {
					 					if ($("#authDeptList option:selected").attr("authtype") == "M") { //관리자의 경우 지각인 근태는 수정할 수 있도록
				 							attitudeItemDetail(this);
				 						} else {
											mod_detail(attitudeid);
				 						}
									}
								}
			    			});
			    			
			    			if (typeText != "" || typeText.indexOf("<spring:message code='ezAttitude.t114' />") > -1
			    							   || typeText.indexOf("<spring:message code='ezAttitude.kje29' />") > -1
			    							   || typeText.indexOf("<spring:message code='ezAttitude.kje30' />") > -1) {//조퇴면 "지각,조퇴" 형태로 되게끔.
			    				$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").html(vo.typeName + ", " + typeText);
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", vo.typeName + ", " + typeText);
			    			} else {
			    				$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").html(vo.typeName);
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", vo.typeName);
			    			}
		    			} else if (vo.typeId == "A03") { //퇴근
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(2)").html("<span class='" + iconStrClass + "'>" + vo.startDate.substring(11,16) + "<span>" +  iconStr);
		    				
			    			var typeName = "";
			    			switch(vo.workStatus){
			    				case "D": typeName = "<spring:message code='ezAttitude.kje29' />"; break;
			    				case "H": typeName = "<spring:message code='ezAttitude.kje30' />"; break;
			    				default : break;
			    			}

							if (typeText != "" || typeText.indexOf("<spring:message code='ezAttitude.t113' />") > -1) {
								if (typeText.indexOf("<spring:message code='ezAttitude.t64' />") == -1) {
									typeText = (typeName == "") ? typeText : typeText + ", " + typeName;
				    			} else {				    				
				    				typeText = (typeName == "") ? typeText : typeName;
				    			}
			    			} else {
			    				typeText = (typeName == "") ? typeText : typeName;
			    			}
		    				$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").html(typeText);
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", typeText);			    					
			    		} else if(vo.typeId == "A25") { //전일 퇴근
			    			$("#contentlist .mainlist tr#" + moment(date).format('YYYY-MM-DD') + " td:eq(2)").html("<span class='" + iconStrClass + "'>" + vo.startDate.substring(11,16) + " (" + Number(vo.startDate.substring(8,10)) + "일)" + "<span>" +  iconStr);
			    			var typeName = "";
			    			switch(vo.workStatus){
			    				case "D": typeName = "<spring:message code='ezAttitude.kje29' />"; break;
			    				case "H": typeName = "<spring:message code='ezAttitude.kje30' />"; break;
			    				default : break;
			    			}

			    			if (typeText != "" || typeText.indexOf("<spring:message code='ezAttitude.t113' />") > -1) {
			    				if (typeText.indexOf("<spring:message code='ezAttitude.t64' />") == -1) {
									typeText = (typeName == "") ? typeText : typeText + ", " + typeName;
			    				} else {
				    				typeText = (typeName == "") ? typeText : typeName;			    					
			    				}
			    			} else {
			    				typeText = (typeName == "") ? typeText : typeName;
			    			}
			    			$("#contentlist .mainlist tr#" + moment(date).format('YYYY-MM-DD') + " td:eq(3)").html(typeText);
				    		$("#contentlist .mainlist tr#" + moment(date).format('YYYY-MM-DD') + " td:eq(3)").attr("title", typeText);
			    		} else if (vo.typeId == "A08") { //조퇴
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(2)").html("<span class='AttRedText " + iconStrClass + "'>" + vo.startDate.substring(11,16) + "</span>" + iconStr);
			    			var typeName = "";
			    			switch(vo.workStatus){
			    				case "D": typeName = "<spring:message code='ezAttitude.kje29' />"; break;
			    				case "H": typeName = "<spring:message code='ezAttitude.kje30' />"; break;
			    				default : break;
			    			}
							
			    			if (typeText != "" || typeText.indexOf("<spring:message code='ezAttitude.t113' />") > -1) { //지각이면 "지각,조퇴" 형태로 되게끔.
				    			if (typeText.indexOf("<spring:message code='ezAttitude.t64' />") == -1) {
			    					typeText = (typeName == "") ? typeText + ", " + vo.typeName : typeText + ", " + vo.typeName + ", " + typeName;				    				
				    			} else {				    				
				    				typeText = (typeName == "") ? vo.typeName : vo.typeName + ", " + typeName;
				    			}
			    			} else {
			    				typeText = (typeName == "") ? vo.typeName : vo.typeName + ", " + typeName;
			    			}
		    				$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").html(typeText);
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", typeText);
			    			
			    		} else { //휴근
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").html("<span class='AttBlueText " + iconStrClass + "'>" + vo.startDate.substring(11,16) + "</span>" + iconStr);
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(2)").html("<span class='AttBlueText " + iconStrClass + "'>" + vo.endDate.substring(11,16) + "</span>" + iconStr);

			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").text(vo.typeName);
			    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", vo.typeName);
		    			}
		    		}
		    		//출근, 퇴근, 지각, 휴근, 조퇴 가 아니면
		    		else {						
						if (vo.dateType == '4' || vo.dateType == '5') { //당일이 아닌 여러일일 경우 (외근, 출장, 파견 등의 경우)
							subDate = calDateRange(vo.startDate.substring(0,10), vo.endDate.substring(0,10)); 
						    var y = vo.startDate.substr(0, 4);
						    var m = vo.startDate.substr(5, 2);
						    var d = vo.startDate.substr(8, 2);
							betweenDate = new Date(y, (Number(m)-1), d);
							 
							for (var j = 0; j<= subDate; j++) {
								betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1)); 
								var trDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2);
					    		
					    		//근무지 및 사유
					    		var contentTrim = $.trim($("<p></p>").html(vo.content).text());
					    		var statusContent = "";
					    		
					    		if (vo.typeId == "A04" || vo.typeId == "A09" || vo.typeId == "A10") { //근무지
						    		statusContent = $("<p></p>").html((vo.region == "" ? "" : vo.region)).text();
						    	} else {
						    		statusContent = $("<p></p>").html((contentTrim == "" ? "" : contentTrim)).text();
						    	}
				    			
					    		if ($("#contentlist .mainlist tr#" + trDay + " td:eq(4)").text() != "") { //만약 해당 tr이 이미 존재하면
					    			var objTds = "";
					    			//근태유형
					 				objTds += "<td class='borderLeft textCenter' title='" + vo.typeName + "'>" + vo.typeName + "</td>";
					 				//일시
					 				objTds += "<td attitudeid='" + vo.attitudeId + "' typeid='" + vo.typeId + "' class='borderLeft textLeft' style='cursor:pointer;'>";
					    			if (vo.dateType == 4 && vo.typeId != 'A04') {
						 				objTds += vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + " " +  iconStr;
						    		}
					    			else if (vo.typeId == 'A04') {
						    			if (vo.dateType == 4) {
							 				objTds += vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + " " +  iconStr;
						    			} else if (vo.dateType == 5) {
							 				objTds += vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>" + " " +  iconStr;
						    			}
					    			}
					 				objTds += "</td>";
						    		//근무지 및 내용
					 				objTds += "<td class='borderLeft textLeft' title='" + statusContent + "'>" + statusContent + "</td>";
					    			
					    			$("#contentlist .mainlist tr#" + trDay).after("<tr>" + objTds + "</tr>");
					    			
					    			//rowspan처리
				    				var rowspanVal = 0;
					    			if ($("#contentlist .mainlist tr#" + trDay + " td:eq(0)").attr("rowspan") == null || $("#contentlist .mainlist tr#" + trDay + " td:eq(0)").attr("rowspan") == "") {
					    				rowspanVal = 2;
					    			} else {
					    				rowspanVal = Number($("#contentlist .mainlist tr#" + trDay + " td:eq(0)").attr("rowspan")) + 1;
					    			}
					    			$("#contentlist .mainlist tr#" + trDay + " td:eq(0)").attr("rowspan",rowspanVal);
					    			$("#contentlist .mainlist tr#" + trDay + " td:eq(1)").attr("rowspan",rowspanVal);
					    			$("#contentlist .mainlist tr#" + trDay + " td:eq(2)").attr("rowspan",rowspanVal);
					    		} else { //만약 해당 tr이 이미 존재하지 않으면
					    			//근태유형
					    			var typeText = $("#contentlist .mainlist tr#" + trDay + " td:eq(3)").text();
					    			//지각이나 조퇴일 경우 "지각,외근" 혹은 "지각,조퇴,외근" 의 형태로 나오게끔
					    			if (typeText.indexOf("<spring:message code='ezAttitude.t113' />") > -1
					    					|| typeText.indexOf("<spring:message code='ezAttitude.t114' />") > -1
					    					|| typeText.indexOf("<spring:message code='ezAttitude.kje29' />") > -1
					    					|| typeText.indexOf("<spring:message code='ezAttitude.kje30' />") > -1) {
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(3)").text(typeText + ", " + vo.typeName);
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(3)").attr("title", typeText + ", " + vo.typeName);
					    			} else {
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(3)").text(vo.typeName);
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(3)").attr("title", vo.typeName);
					    			}
					    			
						    		//일시
					    			if (vo.dateType == 4 && vo.typeId != 'A04') {
					    				//2020-03-13 김정언 : 반반차
					    				if(vo.typeId == 'A21') {
					    					$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").html(vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>" + " " +  iconStr);
					    				} else {
							    			$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").html(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + " " +  iconStr);
					    				}
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").attr("attitudeid", vo.attitudeId);
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").attr("typeid", vo.typeId);
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").css("cursor", "pointer");
						    		}
					    			else if (vo.typeId == 'A04') {
						    			if (vo.dateType == 4) {
							    			$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").html(vo.startDate.substring(0,10)+ "\u00a0~\u00a0" + vo.endDate.substring(0,10) + " " +  iconStr);
						    			} else if (vo.dateType == 5) {
							    			$("#contentlist .mainlist tr#" + trDay + " td:eq(4)").html(vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16)+ "</span>\u00a0~\u00a0" + vo.endDate.substring(0,11) + "<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>" + " " +  iconStr);
						    			}
						    		}
						    		//근무지 및 내용
						    		if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(5)").html("<div style='max-width::810px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><span>" + statusContent + "</div></span>");
						    		} else {
						    			$("#contentlist .mainlist tr#" + trDay + " td:eq(5)").html("<div style='max-width::773px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><span>" + statusContent + "</div></span>");
						    		}
					    			$("#contentlist .mainlist tr#" + trDay + " td:eq(5)").attr("title",statusContent);
					    		}
							}
						} else {  //여러일이 아닌 당일의 경우 (외근, 출장, 파견, 등등 외에)    		
// 				    		//근무지 및 사유
				    		var contentTrim = $.trim($("<p></p>").html(vo.content).text());
				    		var statusContent = "";
				    		
				    		if (vo.typeId == "A04" || vo.typeId == "A09" || vo.typeId == "A10") { //근무지
					    		statusContent = $("<p></p>").html((vo.region == "" ? "" : vo.region)).text();
					    	} else {
					    		statusContent = $("<p></p>").html((contentTrim == "" ? "" : contentTrim)).text();
					    	}
				    		
				    		if ($("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(4)").text() != "") {//만약 해당 tr이 이미 존재하면
				    			var objTds = "";
				    			//근태유형
				 				objTds += "<td class='borderLeft textCenter' title='" + vo.typeName + "'>" + vo.typeName + "</td>";
				 				//일시
				 				objTds += "<td attitudeid='" + vo.attitudeId + "' typeid='" + vo.typeId + "' class='borderLeft textLeft' style='cursor:pointer;'>";
					    		//일시
				    			if (vo.dateType == 1 || vo.dateType == 2) {
				    				objTds += vo.startDate.substring(0,10) + " " +  iconStr;
					    		}
				    			else if (vo.dateType == 3) {
				    				objTds += vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>" + " " +  iconStr;
					    		}
				 				objTds += "</td>";
					    		//근무지 및 내용
				 				objTds += "<td class='borderLeft textLeft' title='" + statusContent + "'>" + statusContent + "</td>";
				    			
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10)).after("<tr>" + objTds + "</tr>");
				    			
				    			//rowspan처리
			    				var rowspanVal = 0;
				    			if ($("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(0)").attr("rowspan") == null || $("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(0)").attr("rowspan") == "") {
				    				rowspanVal = 2;
				    			} else {
				    				rowspanVal = Number($("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(0)").attr("rowspan")) + 1;
				    			}
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(0)").attr("rowspan",rowspanVal);
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(1)").attr("rowspan",rowspanVal);
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(2)").attr("rowspan",rowspanVal);
				    		} else { //만약 해당 tr이 이미 존재하지 않으면
				    			//근태유형
				    			var typeText = $("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").text();
				    			//지각이나 조퇴일 경우 "지각,외근" 혹은 "지각,조퇴,외근" 의 형태로 나오게끔
				    			if (typeText.indexOf("<spring:message code='ezAttitude.t113' />") > -1
				    					|| typeText.indexOf("<spring:message code='ezAttitude.t114' />") > -1
				    					|| typeText.indexOf("<spring:message code='ezAttitude.kje29' />") > -1
				    					|| typeText.indexOf("<spring:message code='ezAttitude.kje30' />") > -1) {
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").text(typeText + ", " + vo.typeName);
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", typeText + ", " + vo.typeName);
				    			} else {
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").text(vo.typeName);
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(3)").attr("title", vo.typeName);
				    			}
				    			
					    		//일시
				    			if (vo.dateType == 1 || vo.dateType == 2) {
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(4)").html(vo.startDate.substring(0,10) + " " +  iconStr);
					    		}
				    			else if (vo.dateType == 3) {
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(4)").html(vo.startDate.substring(0,11) + "<span class='AttBlueText'>" + vo.startDate.substring(11,16) + "</span>\u00a0~\u00a0<span class='AttBlueText'>" + vo.endDate.substring(11,16) + "</span>" + " " +  iconStr);
					    		}
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(4)").attr("attitudeid", vo.attitudeId);
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(4)").attr("typeid", vo.typeId);
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(4)").css("cursor", "pointer");
					    		
					    		//근무지 및 내용
					    		if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(5)").html("<div style='max-width::810px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><span>" + statusContent + "</div></span>");
					    		} else {
					    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(5)").html("<div style='max-width::773px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'><span>" + statusContent + "</div></span>");
					    		}
				    			$("#contentlist .mainlist tr#" + vo.startDate.substring(0,10) + " td:eq(5)").attr("title",statusContent);				    			
				    		}
						}
					}
				});
				getAttiStatisList();
			}
			
			function slideTd() {
				if ($("#slideImg").attr("src") == "/images/ImgIcon/slideLeft.png") {
					$("#attiStatis").css("height", "");
					
					$("#attiStatis").animate({
						width: "151px"
					}, 500);
					
					$("#slideBtn").animate({
						right: "147px"
					}, 500, function(){
						$("#slideImg").attr("src", "/images/ImgIcon/slideRight.png");
					});
				} else {
					$("#attiStatis").animate({
						width: "0px"
					}, 500, function(){
						$("#attiStatis").css("height", "0px");
					});
					
					$("#slideBtn").animate({
						right: "2px"
					}, 500, function(){
						$("#slideImg").attr("src", "/images/ImgIcon/slideLeft.png");
					});
				}
			}
			
			function setMemorial(oThisDate) {
				var tempyear = oThisDate.getFullYear();
				var lunarDate; // 음력 날짜를 저장하기 위한 변수
				var lunarDate2; // 음력월.음력일 => 달력에 음력일을 표시해주기 위한 변수
				if (tempyear > 1800 && tempyear <= 2101) { // 음력에 대한 날짜 제공은 1800 ~ 2101
					lunarDate = lunarCalc(tempyear, oThisDate.getMonth() + 1, oThisDate.getDate(), 1);
					
					lunarDate2 = lunarDate.month + "." + lunarDate.day;
					if (lunarDate.leapMonth) {
						lunarDate2 = "윤" + lunarDate2;
					}
				}
				
				var tempmemorial = memorialDayCheck(oThisDate, lunarDate); // 날짜에 해당하는 휴일을 가져온다.
				var tempyearmemorial = yearmemorialDayCheck(oThisDate, lunarDate);
				
				var isholiday = false;
				var holidayname = "";
				var holidayname2 = "";
				
				for (var i = 0; i < tempmemorial.length; i++) {
			        memorial = tempmemorial[i];
			        if (uselang == "1") {
			            if (i == tempmemorial.length - 1) {
			            	holidayname += memorial.name;
			            } else {
			            	holidayname += memorial.name + ", ";
			            }
			        } else {
			            if (i == tempmemorial.length - 1) {
			            	holidayname += memorial.name2;
			            } else {
			            	holidayname += memorial.name2 + ", ";
			            }
			        }
			        if (memorial.holiday) {
			        	isholiday = true;
			        }
			    }
	
			    for (var i = 0; i < tempyearmemorial.length; i++) {
			        yearmemorial = tempyearmemorial[i];
			        if (uselang == "1") {
			            if (i == tempyearmemorial.length - 1) {
			            	holidayname2 += yearmemorial.name;
			            } else {
			            	holidayname2 += yearmemorial.name + ", ";
			            }
			        } else {
			            if (i == tempyearmemorial.length - 1) {
			            	holidayname2 += yearmemorial.name2;
			            } else {
			            	holidayname2 += yearmemorial.name2 + ", ";
			            }
			        }
			        if (yearmemorial.holiday) {
			        	isholiday = true;
			        }
		    	}
			    
			    var result = [isholiday, holidayname, holidayname2];
			    
			    return result;
			}
		</script>
	</head>
	<body class="mainbody" marginwidth="0" marginheight="0" onselectstart="return false" style="min-width: 950px;">
		<c:if test="${deptFlag != 'true'}">
			<h1 id="titleimg"><spring:message code='ezAttitude.t143'/></h1>
		</c:if>
		<c:if test="${deptFlag == 'true'}">
			<h1 id="titleimg"><spring:message code='ezAttitude.t144'/></h1>
		</c:if>
		<div id="mainmenu">
			<ul class="on">
				<c:if test="${adminFlag == 'true'}">
		        	<li id="btnAbsentedList"><span onClick="popupAbsentedList()"><spring:message code='ezAttitude.t6'/></span></li>
		        	<li id="btnExcelDown"><span onClick="excelDown()"><spring:message code='ezAttitude.t145'/></span></li>
					<li style="float:right; <c:if test="${displayFlag == 'false'}"> display:none </c:if>">
						<select id="authDeptList" style="min-width:130px; max-width:200px; width:auto; height:28px;" onchange="deptChange()">
							<c:forEach var="dept" items="${deptList}">
								<c:if test="${dept.mine != 'yes' }">
									<c:if test="${selectedDeptID == dept.deptId}">
										<option value="<c:out value='${dept.deptId}' />" authType="<c:out value='${dept.authType}' />" selected><c:out value='${dept.deptName}'/></option>
									</c:if>
									<c:if test="${selectedDeptID != dept.deptId}">
										<option value="<c:out value='${dept.deptId}' />" authType="<c:out value='${dept.authType}' />"><c:out value='${dept.deptName}'/></option>
									</c:if>
								</c:if>
							</c:forEach>
						</select>
					</li>
				</c:if>
				<c:if test="${adminFlag != 'true'}">
					<select id="authDeptList"
						style="min-width:100px; width:auto; height: 28px; display: none;"
						onchange="deptChange()">
						<option value="<c:out value='${selectedDeptID}'/>" selected><c:out
								value='${selectedDeptID}' /></option>
					</select>
				</c:if>
			</ul>
		</div>

		<div class="calendar_pagenav" style="width:180px;margin-left:-89px; left: max(50%, 550px);">
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"></li>
	            <li class="contentlayout_right" id="preN"></li>
	            <li class="contentlayout_none"><span class="spanText" id="calTitle"></span>
	            </li>
	        </ul>
	    </div>
    
	    <c:if test="${deptFlag != 'true'}">
		    <div class="mainmenuTab">
		        <ul class="mainmenuTabUL">
					<li id="btnTableList"><span onClick="getAttitudeTableList()"><spring:message code="ezAttitude.t309" /></span></li>
		            <li id="btnCalList"><span onClick="getAttitudeCalList()"><spring:message code="ezAttitude.t310" /></span></li>
		        </ul>
		    </div>
		    <div class="timecheck_info">
		    	<dl class="timeInfo">
		        	<dt class="timeInfoPic">
		        		<c:choose>
							<c:when test="${not empty userInfo.userFileUrl }">
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${userInfo.userFileUrl }" onerror="this.src='/images/kr/main/bestEmployee_pic_none.png'" width="48px" height="48px">
							</c:when>
							<c:otherwise>
								<img src="/images/kr/main/bestEmployee_pic_none.png" width="48px" height="48px">
							</c:otherwise>
						</c:choose>
		        	</dt>
		            <dd class="timeInfoText"><span>${userInfo.displayName }</span><span>${userInfo.title }</span><span style="color:#aaa9a9">${userInfo.deptName }</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/late_icon.png"></dt>
		            <dd class="timeIconDD"><spring:message code="ezAttitude.t113"/><span class="timeCountR" id="FA02">0</span></dd>
		        </dl>
		        <c:if test="${A11typeInfo.isuse eq '1' }">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
			            <dd class="timeIconDD"><spring:message code="ezAttitude.t254"/><span class="timeCountR" id="FA11">0</span></dd>
			        </dl>
		        </c:if>
		        <c:if test="${A12typeInfo.isuse eq '1' }">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
			            <dd class="timeIconDD"><spring:message code="ezAttitude.t255"/><span class="timeCountR" id="FA12">0</span></dd>
			        </dl>
			    </c:if>
			    <c:if test="${A13typeInfo.isuse eq '1' }">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
			            <dd class="timeIconDD"><spring:message code="ezAttitude.t256"/><span class="timeCountR" id="FA13">0</span></dd>
			        </dl>
			    </c:if>
			    <!-- 2020-03-12  김정언 : 반반차 -->
			    <c:if test="${A21typeInfo.isuse eq '1' }">
			        <dl class="timeIcconDL">
			        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm02.png"></dt>
			            <dd class="timeIconDD"><spring:message code="ezAttitude.kje04"/><span class="timeCountR" id="FA21">0</span></dd>
			        </dl>
			    </c:if>
		    </div>
	    </c:if>
		
		<!-- 근태관리 달력형 테이블(개인근태현황, 부서근태현황)-->
		<!-- 2020.01.10 김정언 - 부서근태현황의 근태통계에 silde 추가 -->
		<table id="attiCalendarTB">
			<tr>
				<td style="vertical-align:top; width:100%;">
					<div style="vertical-align:top;" id="attiCalendar"></div>
				</td>
				<td style="vertical-align:top;">
					<c:if test="${deptFlag != 'true'}">
						<div style="vertical-align:top;width:0px;height:0px;overflow:hidden;" class="time_stats" id="attiStatis"></div>
						<div id="slideBtn" style="position:absolute;top:164px;right:2px;"><img id="slideImg" onclick="javascript:slideTd()" src="/images/ImgIcon/slideLeft.png" /></div>
					</c:if>
					<c:if test="${deptFlag == 'true'}">
						<div style="vertical-align:top;width:0px;height:0px;overflow:hidden;" class="time_stats" id="attiStatis"></div>
						<div id="slideBtn" style="position:absolute;top:83px;right:2px;"><img id="slideImg" onclick="javascript:slideTd()" src="/images/ImgIcon/slideLeft.png" /></div>
					</c:if>	
				</td>
			</tr>
		</table>		
		
		<!-- 근태관리 리스트형 테이블(개인근태현황)-->
		<c:if test="${deptFlag != 'true'}">
		<div id="attiTableListTB" style="width: 100%;">
			<table class='mainlist' style='width: 100%;'>
				<tr>
					<th style='width:12%'><spring:message code='ezAttitude.t133'/></th>
					<th style='width:12%'><spring:message code='ezAttitude.t232'/></th>
					<th style='width:12%'><spring:message code='ezAttitude.t233'/></th> 
					<th style='width:12%'><spring:message code='ezAttitude.t134'/></th>
					<th style='width:20%;padding-left: 20px;'><spring:message code='ezAttitude.t149'/></th>
					<th style="width:32%; border-right-color:transparent;padding-left: 20px;"><spring:message code='ezAttitude.t46'/></th>
					<th style='border-left:0px;width: 2px;'>&nbsp;</th>
				</tr> 
			</table>
			
			<div id='contentlist' name='contentlist' style='overflow-y: auto;'>
				<table class='mainlist' style='width: 100%;'>
				</table>
			</div>
		</div>
		</c:if>
		
		<table class="mainlist" style="width:100%; display:none;" id="ExcelAttList">
	       	<tr>
				<th>NO.</th>
				<th><spring:message code='ezAttitude.t40'/></th>
				<th><spring:message code='ezAttitude.t10'/></th>
				<th><spring:message code='ezAttitude.t9'/></th>
				<th><spring:message code='ezAttitude.t149'/></th>
			</tr>
		</table>
		

		<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezAttitude/saticGetXlsAtt.do">
		<c:if test="${deptFlag != 'true'}">
	        <input type="hidden" id="saveFileName" name="saveFileName" value="<spring:message code='ezAttitude.t143'/>"/>
		</c:if>
		<c:if test="${deptFlag == 'true'}">
	        <input type="hidden" id="saveFileName" name="saveFileName" value="<spring:message code='ezAttitude.t144'/>"/>
		</c:if>
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value=""/>
	        <input type="hidden" id="userAgent" name="userAgent" value=""/>
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		
		<!-- 근태날짜 팝업창 -->
		<!-- 
		<div id="popupDay" class="popupwrap1" style="display:none;margin-bottom:50px; max-width:822px;">
			<div class="popupJQLayer">
				<div id="popupDay_title" class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				!-- 내용 --
				<div style="max-height:466px; overflow-y:auto;">
				<table class="popuplist" id="addpopupDay_list" style="table-layout:fixed; display:block;">
				    <tbody style="max-height:466px; display:block; overflow-y:auto;">
				    	<tr>
				    		<th style="height:30px">No.</th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t134'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t10'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t9'/></th>
				    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t46'/></th>
						</tr>
				    </tbody>
				</table>
				</div>
				<br />
			</div>
		</div>
		<div class="shadow"></div>
		 -->
		<div id="popupDay" class="popupwrap1" style="display:none;margin-bottom:50px; max-width:870px;">
			<div class="popupJQLayer">
				<div id="popupDay_title" class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				<!-- 내용 -->
				<div style="max-height:466px; overflow-y:auto;">
				<table class="popuplist" id="addpopupDay_list" style="table-layout:fixed; display:block;">
				    <tbody style="max-height:466px; display:block; overflow-y:auto;">
						<tr>
				    		<th style="height:30px">No.</th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t10'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t232'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t233'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t134'/></th>
				    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t46'/></th>
						</tr>
					</tbody>
				</table>
				</div>
				<br />
			</div>
		</div>
		<div class="shadow"></div>
		
		<!-- 근태유형 팝업창 -->
<!--		
 		<div id="popup" class="popupwrap1" style="display:none;margin-bottom:50px;max-width:800px;">
			<div class="popupJQLayer">
				<div id="popup_title" class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				<div style="max-height:466px; overflow-y:auto;">
				<table class="popuplist" id="addpopup_list" style="table-layout:fixed; display:block;">
				    <tbody style="max-height:466px; overflow-y:auto; display:block;">
				    	<tr>
				    		<c:if test="${deptFlag == 'true'}">
				    			<th style="height:30px">No.</th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t10'/></th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t9'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t46'/></th>
				    		</c:if>
				    		<c:if test="${deptFlag != 'true'}">
				    			<th style="height:30px;">No.</th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t46'/></th>
				    		</c:if>
						</tr>
				    </tbody>
				</table>
				</div>
				<br />
			</div>
		</div>
 -->		
		<!-- NO,일시만 존재 - 지각,휴근  -->
		<div id="onlyTimePopup" class="popupwrap1" style="display:none;margin-bottom:50px;<c:if test="${deptFlag == 'true'}">max-width:515px;</c:if><c:if test="${deptFlag != 'true'}">max-width:400px;</c:if>">
			<div class="popupJQLayer">
				<div id="onlyTimePopup_title" class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				<div style="max-height:466px; overflow-y:auto;">
				<table class="popuplist" id="onlyTimePopup_list" style="table-layout:fixed; display:block;">
				    <tbody style="max-height:466px; overflow-y:auto; display:block;">
				    	<tr>
				    		<c:if test="${deptFlag == 'true'}">
				    			<th style="height:30px">No.</th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t10'/></th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t9'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    		</c:if>
				    		<c:if test="${deptFlag != 'true'}">
				    			<th style="height:30px;">No.</th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    		</c:if>
						</tr>
				    </tbody>
				</table>
				</div>
				<br />
			</div>
		</div>
		<!-- NO,일시,근무지 - 외근,출장,파견  -->
 		<div id="regionPopup" class="popupwrap1" style="display:none;margin-bottom:50px;<c:if test="${deptFlag == 'true'}">max-width:642px;</c:if><c:if test="${deptFlag != 'true'}">max-width:465px;</c:if>">
			<div class="popupJQLayer">
				<div id="regionPopup_title" class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				<div style="max-height:466px; overflow-y:auto;">
				<table class="popuplist" id="regionPopup_list" style="table-layout:fixed; display:block;">
				    <tbody style="max-height:466px; overflow-y:auto; display:block;">
				    	<tr>
				    		<c:if test="${deptFlag == 'true'}">
				    			<th style="height:30px">No.</th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t10'/></th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t9'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t47'/></th>
				    		</c:if>
				    		<c:if test="${deptFlag != 'true'}">
				    			<th style="height:30px;">No.</th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t47'/></th>
				    		</c:if>
						</tr>
				    </tbody>
				</table>
				</div>
				<br />
			</div>
		</div>
		<!-- NO,일시,내용 - 외출,조퇴,결근,휴가유형들  -->
 		<div id="contentPopup" class="popupwrap1" style="display:none;margin-bottom:50px;<c:if test="${deptFlag == 'true'}">max-width:600px;</c:if><c:if test="${deptFlag != 'true'}">max-width:550px;</c:if>">
			<div class="popupJQLayer">
				<div id="contentPopup_title" class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				<div style="max-height:466px; overflow-y:auto;">
				<table class="popuplist" id="contentPopup_list" style="table-layout:fixed; display:block;">
				    <tbody style="max-height:466px; overflow-y:auto; display:block;">
				    	<tr>
				    		<c:if test="${deptFlag == 'true'}">
				    			<th style="height:30px">No.</th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t10'/></th>
					    		<th style="height:30px;"><spring:message code='ezAttitude.t9'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
					    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t230'/></th>
				    		</c:if>
				    		<c:if test="${deptFlag != 'true'}">
				    			<th style="height:30px;">No.</th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t149'/></th>
				    			<th style="height:30px; text-align:center"><spring:message code='ezAttitude.t230'/></th>
				    		</c:if>
						</tr>
				    </tbody>
				</table>
				</div>
				<br />
			</div>
		</div>
	</body>
	<c:if test="${!empty attitudeMapApiKey}">
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${attitudeMapApiKey}&libraries=services"></script>
	<script>
		function geolocation(x, y) {
			var geocoder = new kakao.maps.services.Geocoder();

			var coord = new kakao.maps.LatLng(x, y);
			var callback = function(result, status) {
			    if (status === kakao.maps.services.Status.OK) {
					var ret = window.open("https://map.kakao.com/link/map/" + result[0].address.address_name +"," +x+","+y, "", GetOpenWindowfeature(1000, 700));
			    }
			};

			geocoder.coord2Address(coord.getLng(), coord.getLat(), callback);
		}
	</script>
	</c:if>
</html>