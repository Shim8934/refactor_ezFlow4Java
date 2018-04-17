<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/Holiday.js"></script>  
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezAttitude/Calendar.js"></script>
		<!-- modal -->
		<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<style>
			#attiStatis table td {
				color : #777;
				font-size : 13px;
				text-align : center;
				border : 1px solid #dedede;
			}
			
			#attiCalendar td[typeId=A02], #attiCalendar td[typeId=A08] {
				color : red;
			}
			
			#attiCalendar td[typeId=A01], #attiCalendar td[typeId=A03] {
				cursor : context-menu;
				color : rgb(102,180,255);
			}
			
			.span_list table td:hover, .td_day:hover {
				background-color:#edf4fd;
			}
		</style>
		<script>
			var pMode = "";
			var uselang = "<c:out value='${userInfo.lang}'/>";
			var deptFlag = "${deptFlag}";
			var adminFlag = "${adminFlag}";
			var companyHoliday = "";        // 회사 휴무일
			var closedDateAttitude = true;  // 휴일근태등록 유무
			var attitudeModAppl = true;     // 근태수정신청 유무
			var modAttitudeId = "";         // 수정신청 근태ID
			var modChangeDate = "";         // 수정신청 변경일자
			var modContent = "";            // 수정신청 내용
			
			$(function(){
				$(document).on('dblclick', '.td_day td', function(){
					pMode = "new";
					attitudeNewItem(this);
				})
				
				$('#attiCalendar').on('dblclick', 'tr td[typeid]:not(td[typeid=A01], td[typeid=A02], td[typeid=A03])', function(){
					attitudeItemView(this);
				})
				
				//근태수정신청 팝업창
				$('#attiCalendar').on('dblclick', 'tr td[typeid=A02]', function(){
					showDialog(this);
				})
			})
			
			window.onload = function() {
				select_memorialDays(uselang); // 공식 휴일 설정 => 언어에 따라 memorialDays에 변수가 담김
				
				getHolidayList();
			}
			
			//datepicker
	    	$(function () {
			    $("#Sdatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.gif",
			        buttonImageOnly: true
			    });
			});
			    
			var monthMsg = "1월;2월;3월;4월;5월;6월;7월;8월;9월;10월;11월;12월";
			var monthStr = monthMsg.split(";");		    
			var dayMsg = "일;월;화;수;목;금;토";
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
			    $.datepicker.setDefaults($.datepicker.regional["ko"]);
			    
			    $("#Sdatepicker").datepicker('disable');
			});
			
			/**
			* 근태유형 메소드
			*/
			function getAttiTypeList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/attitudeTypeList.do",
					data : {},
					success : function(result) {
						getAttiTypeList_After(result);
					}
				})
			}
			
			/**
			* 통계바 메소드
			*/
			function getAttiTypeList_After(result) {
					var objTable = $("<table></table>").css({"cellpadding":"0", "cellspacing":"0", "border":"0", "width":"100%"});
					var objTbody = $("<tbody></tbody>");
					var objTr = "";
					var objTd = "";
					var calendarHeight = $("#attiCalendar").css("height");
					var tdHeight = parseInt(calendarHeight.substr(0, calendarHeight.length - 2)/(result.length + 1 - 2));
					
					objTbody.prepend($("<tr></tr>").append($("<th></th>").attr("colspan","2").css({"height":tdHeight, "background-color": "#edf4fd"}).text($("#calTitle").text())));
					for (var i = 0; i < result.length; i++) {
						if (result[i].typeId == 'A01' || result[i].typeId == 'A03') {
							continue;
						}
						objTr = $("<tr></tr>").append($("<th></th>").text(result[i].typeName));
						objTd = $("<td></td>").css({"height": tdHeight + "px", "width" : "80px"}).attr("id",result[i].typeId).text("0일");

						
						objTr.append(objTd);
						objTbody.append(objTr);
					}
					
					objTable.append(objTbody);
					$("#attiStatis").append(objTable);
					
					if (calendarHeight != $("#attiStatis").css("Height")) {
						var statisHeight = $("#attiStatis").css("Height");
						tdHeight = tdHeight + (calendarHeight.substr(0, calendarHeight.length - 2) - statisHeight.substr(0, statisHeight.length - 2));
						$("#attiStatis tr:eq(0) th").css("height", tdHeight + "px");
					}
			}
			
			/**
			* 통계 메소드
			*/
			function getAttiStatisList() {
				var pDate = $("#calTitle").text().trim(); 
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/attitudeStatisList.do",
					data : {
						date : pDate,
						deptFlag : deptFlag
					},
					success : function(result) {
						$("#attiStatis td").text("0일");
						for (var i = 0; i < result.length; i++) {
							$("#" + result[i].typeId).text(result[i].sumDate + "일");
						}
					}
				})
			}
			
			/**
			* holiday 메소드
			*/
			function getHolidayList() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getHolidayList.do",
					data : {
						
					},
					success : function(result) {
						closedDateAttitude = result.attitudeConfigVO.closedDateAttitude == "0" ? false : true;
						attitudeModAppl = result.attitudeConfigVO.attitudeModAppl == "0" ? false : true;
						companyHoliday = result.attitudeConfigVO.closedDay.split(",");
						for (var i = 0; i < result.holidayList.length; i++) {
							if (result.holidayList[i].isRepeat == 1) { //매년 반복되는 경우
								memorialDays.push(new memorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2, 
																  result.holidayList[i].holidayDate.substring(5,7), result.holidayList[i].holidayDate.substring(8,10),
																  result.holidayList[i].isSolar, result.holidayList[i].isRest == 1 ? true : false));
							} else if (result.holidayList[i].isRepeat == 0) { //해당 년에만 적용이 되는 경우
								yearmemorialDays.push(new yearmemorialDay(result.holidayList[i].holidayName, result.holidayList[i].holidayName2,
																		  result.holidayList[i].holidayDate.substring(0,4), result.holidayList[i].holidayDate.substring(5,7),
																		  result.holidayList[i].holidayDate.substring(8,10), result.holidayList[i].isSolar,
																		  result.holidayList[i].isRest == 1 ? true : false));
							}
						}
						
						CalendarView("attiCalendar");
						getAttiTypeList();
					}
				})
			}
			
			/**
			* 근태 메소드
			*/
			function getAttitudeMainList() {
				var startDate = $("#index_0").attr("day");
				var endDate = $("#index_41").attr("day");
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : startDate,
						endDate : endDate,
						deptFlag : deptFlag
					},
					success : function(result) {
						$("span[name=span_list] table tbody").remove();
						getAttitudeMainList_after(result);
						getAttiStatisList();
					}
				})
			}
			
			function getAttitudeMainList_after(result) {
				var startDate = "";   // 근태의 시작일
				var endDate = "";     // 근태의 종료일
				var betweenDate = ""; // 연속일자의 일자 저장
				var subDate = "";     // 연속일자로 등록된 근태의 날짜 차이를 저장
				var imgPath = "";	  // 이미지 경로
				if (deptFlag == false){
					for (var i = 0; i < result.length; i++) {
						startDate = result[i].startDate.split(" ")[0]; 
						endDate = (result[i].endDate != undefined ? result[i].endDate.split(" ")[0] : ""); 
						imgPath = "<img width='20px' height='20px' style='vertical-align:top; margin-right:3px' src='" + result[i].imgPath + "'/>"; 
						 
						if (result[i].dateType == '4' || result[i].dateType == '5') { 
						subDate = calDateRange(startDate, endDate); 
						betweenDate = new Date(startDate); 
						 
						for (var j = 0; j<= subDate; j++) { 
							betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1)); 
							var tdDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2); 
							$("td[day=" + tdDay + "]").find("table#TD_" + tdDay + "_Value").append(
									"<tr><td attitudeId='" + result[i].attitudeId+ "' typeId='" + result[i].typeId + "'>"  
									+ (result[i].imgPath != undefined ? imgPath : "") + result[i].typeName + " : " + result[i].region + "</td></tr>"); 
						} 
						} else if (result[i].dateType == '3') { 
							$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append( 
									"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + (result[i].imgPath != undefined ? imgPath : "") + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + " ~ " + result[i].endDate.split(" ")[1] + "</td></tr>"); 
						} else if (result[i].dateType == '1') { 
							$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append( 
									"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + (result[i].imgPath != undefined ? imgPath : "") + result[i].typeName + "</td></tr>"); 
						} else { 
							$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append("<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + (result[i].imgPath != undefined ? imgPath : "") + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + "</td></tr>"); 
						} 
					}	
				} else {
					for (var i = 0; i < result.length; i++) {
						if (result[i].typeId != 'A01' && result[i].typeId != 'A03') {
							startDate = result[i].startDate.split(" ")[0];
							endDate = (result[i].endDate != undefined ? result[i].endDate.split(" ")[0] : "");
							imgPath = "<img width='20px' height='20px' style='vertical-align:top; margin-right:3px' src='" + result[i].imgPath + "'/>";
							
							if (result[i].dateType == '4' || result[i].dateType == '5') {
								subDate = calDateRange(startDate, endDate);
								betweenDate = new Date(startDate);
								
								for (var j = 0; j<= subDate; j++) {
									betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1));
									var tdDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2);
									$("td[day=" + tdDay + "]").find("table#TD_" + tdDay + "_Value").append(
											"<tr><td attitudeId='" + result[i].attitudeId+ "' typeId='" + result[i].typeId + "'>" 
											+ (result[i].imgPath != undefined ? imgPath : "") + result[i].writerName + " : " + result[i].typeName + "</td></tr>");
								}
							} else if (result[i].dateType == '3') {
								$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append(
										"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + (result[i].imgPath != undefined ? imgPath : "") + result[i].writerName + " : " + result[i].typeName + "</td></tr>");
							} else if (result[i].dateType == '1') {
								$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append(
										"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + (result[i].imgPath != undefined ? imgPath : "") + result[i].writerName + "</td></tr>");
							} else {
								$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append("<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + (result[i].imgPath != undefined ? imgPath : "") + result[i].writerName + " : " + result[i].typeName + "</td></tr>");
							}	
						}
					}
				}
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
			* 근태작성
			*/
			function attitudeNewItem(obj) {
				var date = $(obj).attr("dispdate");
				
				if (CrossYN()) {
                    var OpenWin = window.open("/ezAttitude/attitudeNewItem.do?date=" + date + "&mode=new", "attitudeNewItem", GetOpenWindowfeature(650, 580));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attitudeNewItem.do?date=" + date + "&mode=new", "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 520));
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
			}
			
			function attitudeItemView(obj) {
				var pAttitudeId = $(obj).attr("attitudeId"); 
				var pTypeId = $(obj).attr("typeId");
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeItemView.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", GetOpenWindowfeature(650, 580));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemView.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(800, 520));
				}
			}
			
			//수정신청 레이어 팝업띄우깅
			function showDialog(obj) {
				if (attitudeModAppl) {
					$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
		        	
		        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
		        	
		        	$("#popup").css("left", popupX);
		        	
					$("#popup").modal({
						  escapeClose: false,
						  clickClose: false,
						  showClose: false
					});
					
					$("#originInCom").text($(obj).parents("td").attr("day") + $(obj).text().split(" :")[1]);
					
					var uploadSDate = $(obj).parents("td").attr("day") + " 00:00:00";
					var sYear = uploadSDate.substring(0, 4);
					var sMonth = uploadSDate.substring(5, 7);
					var sDay = uploadSDate.substring(8, 10);
					var sHour = uploadSDate.substring(11, 13);
					var sMin = uploadSDate.substring(14, 16);
					
			        var SDate = new Date();
			        SDate.setFullYear(sYear, sMonth-1, sDay);
			        SDate.setHours(sHour, sMin, 0, 0);
			        
			        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#Sdatepicker").datepicker('setDate', SDate);
				} else {
					 alert("수정신청이 불가능합니다.");
				}
			}
			
			function layerHidden() {
		        $.modal.close();
		    }
			
			function searchDept() {
				
			}
			
			function excelDown() {
				
			}
			
			function sendMail() {
	
			}
        	
			function attiModAppl() {
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/a.do",
					data : {
						attitudeId : modAttitudeId,
						changeDate : modChangeDate,
						content : modContent
					},
					success : function() {
						alert("근태 수정이 신청되었습니다.");
					}
				})
			}
		</script>
	</head>
	<body class="mainbody" style="overflow:auto" marginwidth="0" marginheight="0">
		<c:if test="${deptFlag != 'true'}">
			<h1 id="titleimg">개인근태현황</h1>
		</c:if>
		<c:if test="${deptFlag == 'true'}">
			<h1 id="titleimg">부서근태현황</h1>
		</c:if>
		<div id="mainmenu">
			<ul>
				<c:if test="${adminFlag == 'true'}">
					<li id="reply"><span onClick="searchDept()">부서검색</span></li>
		        	<li id="search"><span onClick="excelDown()">엑셀다운로드</span></li>
		        	<li id="search"><span onClick="sendMail()">근태미입력자 메일발송</span></li>
				</c:if>
			</ul>
		</div>
		
		<table>
			<tr>
				<td style="vertical-align:top; width:92%;">
					<div style="vertical-align:top;" id="attiCalendar"></div>
				</td>
				<td style="vertical-align:top; width:10px;">&nbsp;</td>
				<td style="vertical-align:top; width:8%; margin-left:5px;">
					<div style="vertical-align:top;" id="attiStatis">
					</div>
				</td>
			</tr>
		</table>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<!-- 근태수정신청 팝업창 -->
		<div id="popup" class="popupwrap1" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:50px;">
			<div class="popupwrap3">
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="width:440px;margin:10px 0px 0px 1px;">
			    	<tr>
						<th class="layerHeader" colspan="2"><img src="/images/kr/left/left_mail.png" style="vertical-align: middle;padding-bottom:1px"/>&nbsp;근태수정신청</th>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">구분
						<td>지각</td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">출근시각</th>
						<td id="originInCom"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">변경시각</th>
						<td id="transInCom">
							<span id="periodblock">
								<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
								<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> :<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
							</span>
						</td>
					</tr>
					<tr>
						<th style="width:90px;height:30px">승인상태</th>
						<td id="apprStatus">상태(진행, 반려)</td>
					</tr>
					<tr>
						<td colspan="2" style="margin:0px; padding:0px;"><textarea class="textarea" style="width:100%; height:120px; box-sizing:border-box;-moz-box-sizing:border-box; resize:none; border:none;"></textarea></td>
					</tr>
				</table>
				<!-- /내용 -->
				<br />
				<div style="text-align:center;">
					<a class="imgbtn"><span onclick="attiModAppl()" >신청</span></a>
					<a class="imgbtn" rel="modal:close"><span>취소</span></a>
			    </div>
			</div>
			<a href="#close-modal" rel="modal:close" class="close-modal ">Close</a>
		</div>
		<div class="shadow"></div>
	</body>
</html>