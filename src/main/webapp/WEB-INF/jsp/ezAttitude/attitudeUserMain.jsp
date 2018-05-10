<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/css/ezAttitude/Calendar_cross.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-+d0P83n9kaQMCwj8F4RJB66tzIwOKmrdb46+porD/OvrJ+37WqIM7UoBtwHO6Nlg" crossorigin="anonymous">
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
/* 				color : red; */
			}
			
			#attiCalendar td[modappl='1'][typeId=A02] {
				color : black;
			}
			
			#attiCalendar td[typeId=A01], #attiCalendar td[typeId=A03] {
				cursor : context-menu;
			}
			
			.span_list table td:hover, .td_day:hover {
				background-color:#edf4fd;
			}
			
			.attiVacation {
			    border-radius: 2px;
			    display: inline-block;
			    width: 11px;
			    height: 11px;
			    border: 1px solid #35b07e;
			    background: #35b07e;
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
			    border: 1px solid #ccc31f;
			    background: #e9de13;
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
			    border: 1px solid #ff4b00;
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
		</style>
		<script>
			var pMode = "";
			var uselang = "<c:out value='${userInfo.lang}'/>";
			var LunarUse = false;
			var deptFlag = "${deptFlag}";
			var adminFlag = "${adminFlag}";
			var companyHoliday = "";        // 회사 휴무일
			var closedDateAttitude = true;  // 휴일근태등록 유무
			var attitudeModAppl = true;     // 근태수정신청 유무
			var modAttitudeId = "";         // 수정신청 근태ID
			var modChangeDate = "";         // 수정신청 변경일자
			var modContent = "";            // 수정신청 내용
						
			$(function(){
				//개인근태현황에서만 근태 등록 가능
				if (deptFlag != "true") {
					$(document).on('dblclick', '.td_day td', function(){
						pMode = "new";
						attitudeNewItem(this);
					})	
				} else { // 부서근태현황에서는 당일의 근태를 조회.
					$(document).on('dblclick', '.td_day td', function(){
						pMode = "new";
						searchByDay(this);
					})
				}
				
				$('#attiCalendar').on('dblclick', 'tr td[typeid]:not(td[typeid=A01], td[typeid=A02], td[typeid=A03])', function(){
					attitudeItemView(this);
				})
				
				$('#attiCalendar').on('dblclick', 'tr td[typeid=A02]', function(){
					//근태수정신청은 개인근태현황에서만 가능
					var modappl = $(this).attr('modappl');
					var attitudeid = $(this).attr('attitudeid');
					if (deptFlag != "true") {
						if (modappl == 0) {
							attitudeModItem(this);	
						} else {
							mod_detail(attitudeid);
						}
						
					} else {
						if (modappl == 0) {
							console.log(this);
						} else {
							mod_detail(attitudeid);
						}
					}
				})
			})
			
			window.onload = function() {
				select_memorialDays(uselang); // 공식 휴일 설정 => 언어에 따라 memorialDays에 변수가 담김
				
				scheduleGetLunarUse();
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
			    
			var monthMsg = "<spring:message code='ezAttitude.bbhs1'/>";
			var monthStr = monthMsg.split(";");		    
			var dayMsg = "<spring:message code='ezAttitude.bbhs2'/>";
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
			
			function scheduleGetLunarUse() {
			    $.ajax({
		    		type : "POST",
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
			}
			
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
					var objTable = $("<table style='table-layout:fixed'></table>").css({"cellpadding":"0", "cellspacing":"0", "border":"0", "width":"100%", "height":$("#attiCalendar").css("height")});
					var objTbody = $("<tbody></tbody>");
					var objTr = "";
					var objTd = "";
					var calendarHeight = $("#attiCalendar").css("height");
					var tdHeight = parseInt(calendarHeight.substr(0, calendarHeight.length - 2)/(result.length + 1 - 2));
					
// 					objTbody.prepend($("<tr></tr>").append($("<th></th>").attr("colspan","2").css({"height":"34px", "background-color": "#edf4fd"}).text($("#calTitle").text())));
					objTbody.prepend($("<tr></tr>").append($("<th></th>").attr("colspan","2").css({"height":"34px", "background-color": "#edf4fd"}).text("<spring:message code='ezAttitude.bbhs38'/>")));
					for (var i = 0; i < result.length; i++) {
						
						if (result[i].typeId == 'A01' || result[i].typeId == 'A03') {
							continue;
						}
						objTr = $("<tr></tr>").append($("<th style='width:74px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + result[i].typeName.replace(/'/gi, "&apos;").replace(/"/gi, "&quot;") + "'></th>").text(result[i].typeName));
						objTd = $("<td nowrap></td>").css({"width" : "80px", "cursor" : "pointer"})
						.attr("id",result[i].typeId).text("0" + "<spring:message code='ezAttitude.t21'/>")
						.attr("parentId",result[i].parentId)
						.attr("onmouseover","this.style.color='#164aad'")
						.attr("onmouseout","this.style.color='#666'")
						.click(function() {
							searchByTypeId(this);
						});	
						objTr.append(objTd);
						objTbody.append(objTr);
					}
					
					objTable.append(objTbody);
					$("#attiStatis").append(objTable);
					
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
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
						$("#attiStatis td").text("0" + "<spring:message code='ezAttitude.t21'/>");
						for (var i = 0; i < result.length; i++) {
							$("#" + result[i].typeId).text(result[i].count + "<spring:message code='ezAttitude.t21'/>");
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
						deptFlag : deptFlag,
						selectedDeptID : encodeURIComponent(authDeptList.value)
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
						 
						if (result[i].dateType == '4' || result[i].dateType == '5') { 
							subDate = calDateRange(startDate, endDate); 
							betweenDate = new Date(startDate); 
							 
							for (var j = 0; j<= subDate; j++) {
								betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1)); 
								var tdDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2);
								var resultRegion = result[i].region.length >= 12 ? result[i].region.substring(0,12) + ".." : result[i].region;
								$("td[day=" + tdDay + "]").find("table#TD_" + tdDay + "_Value").append(
										"<tr><td attitudeId='" + result[i].attitudeId+ "' typeId='" + result[i].typeId + "'>" + 
										result[i].typeName + (resultRegion != "" ? " : " + resultRegion : "") + "</td></tr>"); 
							} 
						} else if (result[i].dateType == '3') { 
							$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append( 
									"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + " ~ " + result[i].endDate.split(" ")[1].substring(0, 5) + "</td></tr>"); 
						} else if (result[i].dateType == '1') { 
							$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append( 
									"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + result[i].typeName + "</td></tr>"); 
						} else { 
							$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append(
									"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "' modappl='" + result[i].modAppl + "'>" + result[i].typeName + " : " + result[i].startDate.split(" ")[1].substring(0, 5) + (result[i].modAppl  == '1' && result[i].typeId  == 'A01' ? "  <i class='fas fa-pencil-alt'></i>" : "") + "</td></tr>"); 
						} 
					}
					setAttitudeSquare();
				} else {
					for (var i = 0; i < result.length; i++) {
						if (result[i].typeId != 'A01' && result[i].typeId != 'A03') {
							startDate = result[i].startDate.split(" ")[0];
							endDate = (result[i].endDate != undefined ? result[i].endDate.split(" ")[0] : "");
							
							if (result[i].dateType == '4' || result[i].dateType == '5') {
								subDate = calDateRange(startDate, endDate);
								betweenDate = new Date(startDate);
								
								for (var j = 0; j<= subDate; j++) {
									betweenDate.setDate(betweenDate.getDate() + (j == 0 ? 0 : 1));
									var tdDay = betweenDate.getFullYear() + "-" + leadingZeros(betweenDate.getMonth() + 1, 2) + "-" + leadingZeros(betweenDate.getDate(), 2);
									$("td[day=" + tdDay + "]").find("table#TD_" + tdDay + "_Value").append(
											"<tr><td attitudeId='" + result[i].attitudeId+ "' typeId='" + result[i].typeId + "'>" +
											result[i].writerName + " : " + result[i].typeName + "</td></tr>");
								}
							} else if (result[i].dateType == '3') {
								$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append(
										"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + result[i].writerName + " : " + result[i].typeName + "</td></tr>");
							} else if (result[i].dateType == '1') {
								$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append(
										"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "'>" + result[i].writerName + " : " + result[i].typeName + "</td></tr>");
							} else {
								$("td[day=" + startDate + "]").find("table#TD_" + startDate + "_Value").append(
										"<tr><td attitudeId='" + result[i].attitudeId + "' typeId='" + result[i].typeId + "' modappl='" + result[i].modAppl + "'>" + result[i].writerName + " : " + result[i].typeName + "</td></tr>");
							}	
						}
					}
					$("td[typeid=A02][modappl=0]").css('cursor','context-menu');
					setAttitudeSquare();
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
			* 근태수정신청
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
					 alert("<spring:message code='ezAttitude.bbhs39'/>");
				}
			}
			
			function layerHidden() {
		        $.modal.close();
		    }
			
			function excelDown() {
				console.log("excelDown started");
				var pDate = $("#calTitle").text().trim();
				var startDate = pDate + "-01 00:00:00";
				var endDate = pDate + "-" + ( new Date(pDate.split("-")[0],pDate.split("-")[1], 0) ).getDate() + " 23:59:59";
				
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
						console.log(attList);
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
		    			console.log("excelDown ended");
		    			btnexportexcel_onclick();
					}
				});
			}
			
			function btnexportexcel_onclick() {
	            document.getElementById("saveExcelData").value = $("#ExcelAttList")[0].outerHTML;
	            document.getElementById("formAgent").target = "saveExcel";
	            document.getElementById("formAgent").submit();
	        }
			
			function sendMail() {
				$.ajax({
					type : "POST",
					async : true,
					url : "/ezAttitude/absentedListSendMail.do",
					data : {
						companyId : '${userInfo.companyID}',
	   					userName : '',
	   					deptName : '',
	   					title : '',
	   					startDate : '',
	   					endDate : '',
	   					deptId : encodeURIComponent(authDeptList.value)
					},
					success : function(result) {
						if (result == "ok") {
							alert("메일이 발송되었습니다.");
						} else {
							alert("메일 발송에 실패하였습니다.");
						}
					}
				});
			}
	
			function searchByTypeId(t) {
				var typeName = t.parentElement.getElementsByTagName("th").item(0).innerText;
				var pDate = $("#calTitle").text().trim();
				var startDate = pDate + "-01 00:00:00";
				var endDate = pDate + "-" + ( new Date(pDate.split("-")[0],pDate.split("-")[1], 0) ).getDate() + " 23:59:59";

				document.getElementById("popup_title").innerText = "<spring:message code='ezAttitude.bbhs3'/>" + "[" + typeName + "]";
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getAttitudeList.do",
					data : {
						startDate : pDate + "-01 00:00:00",
						endDate : endDate,
						deptFlag : deptFlag,
						typeId : t.getAttribute("id"),
						selectedDeptID : encodeURIComponent(authDeptList.value)
					},
					success : function(json) {
						
				    	$('#addpopup_list tbody').children('tr').not(":first").remove();
				    	
				    	if (json.length == 0) {
				    		var uvobjTr = $("<tr style=''></tr>").append($("<td style='width:5%;height:0px;border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:20%; height:0px; border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:70%; height:0px; border:none;'></td>"));
				    		$("#addpopup_list tbody").append(uvobjTr);
				    		
				    		var objTr = $("<tr></tr>").append($("<td colspan='5' style='text-align:center; width:500px; border-top:none;'></td>").text("<spring:message code='ezAttitude.bbhs4'/>"));
				    		$("#addpopup_list tbody").append(objTr);
				    	}
				    	
				    	for(var i = 0; i < json.length; i++) {
				    		if (json[i].apprStatus == 1) {
				    			json[i].apprStatus = "승인";
				    		} else {
				    			json[i].apprStatus = "반려";
				    		}

				    		var objTr = $("<tr></tr>").append($("<td style='width:5%'></td>").text("\u00a0" + (i+1)));

				    		if (json[i].writerName.length > 3) {
				    			objTr.append($("<td style='max-width:10%; width:10%; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + json[i].writerName + "'></td>").text(json[i].writerName.substring(0,2) + "..."));	
				    		} else {
				    			objTr.append($("<td style='max-width:10%; width:10%; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></td>").text(json[i].writerName));
				    		}
				    		if (json[i].writerDeptName.length > 6) {
				    			objTr.append($("<td style='width:20%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + json[i].writerDeptName + "'></td>").text("\u00a0" + json[i].writerDeptName.substring(0,5) + "..."));
				    		} else {
				    			objTr.append($("<td style='width:20%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></td>").text("\u00a0" + json[i].writerDeptName));
				    		}
				    		if (json[i].endDate == null) {
				    			objTr.append($("<td style='width:70%; text-align:center'></td>").text("\u00a0" + json[i].startDate));
				    		} else {
					    		objTr.append($("<td style='width:70%; text-align:center'></td>").text("\u00a0" + json[i].startDate+ "\u00a0~\u00a0" + json[i].endDate));				    			
				    		}

				    		$("#addpopup_list tbody").append(objTr);
				    	}
				    },
				    complete : function() {
				    	try {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);	
				    	} catch(e) {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"attitude_main\"].layerHidden()'></div>").appendTo(parent.frames["attitude_menu"].document.body);
				    	}
			        	
			        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			        	
			        	$("#popup").css("left", popupX);
			        	
						$("#popup").modal({
							  escapeClose: false,
							  clickClose: false,
							  showClose: false
						});
				    }
			    });
			}
			
			function searchByDay(t) {
				var date = $(t).attr('dispdate');
				var startDate = date + " 00:00:00";
				var endDate = date + " 23:59:59";
				
				document.getElementById("popupDay_title").innerText = "근태내역확인 [" + date + "]";
				
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
					success : function(json) {
				    	$('#addpopupDay_list tbody').children('tr').not(":first").remove();
				    	
				    	var j = 0;
				    	
				    	for(var i = 0; i < json.length; i++) {
// 				    		if (json[i].typeId == "A01" || json[i].typeId == "A03") {
// 								console.log(j);
// 								j++;
// 								continue;
// 							}
				    		
				    		if (json[i].apprStatus == 1) {
				    			json[i].apprStatus = "승인";
				    		} else {
				    			json[i].apprStatus = "반려";
				    		}

				    		var objTr = $("<tr></tr>").append($("<td style='width:5%'></td>").text("\u00a0" + (i-j+1)));
				    		objTr.append($("<td style='max-width:10%; width:10%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></td>").text("\u00a0" + json[i].typeName));
				    		if (json[i].writerName.length > 3) {
				    			objTr.append($("<td style='max-width:10%; width:10%; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title ='" + json[i].writerName + "'></td>").text(json[i].writerName.substring(0,2) + "..."));	
				    		} else {
				    			objTr.append($("<td style='max-width:10%; width:10%; padding-left:5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></td>").text(json[i].writerName));
				    		}
				    		
				    		if (json[i].writerDeptName.length > 6) {
				    			objTr.append($("<td style='width:20%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;' title='" + json[i].writerDeptName + "'></td>").text("\u00a0" + json[i].writerDeptName.substring(0,5) + "..."));
				    		} else {
				    			objTr.append($("<td style='width:20%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'></td>").text("\u00a0" + json[i].writerDeptName));
				    		}
				    		if (json[i].endDate == null) {
				    			objTr.append($("<td style='width:60%; text-align:center'></td>").text("\u00a0" + json[i].startDate));
				    		} else {
					    		objTr.append($("<td style='width:60%; text-align:center'></td>").text("\u00a0" + json[i].startDate+ "\u00a0~\u00a0" + json[i].endDate));				    			
				    		}

				    		$("#addpopupDay_list tbody").append(objTr);
				    	}
				    	
// 				    	if (json.length == j) {
						if (i == 0) {
				    		var uvobjTr = $("<tr></tr>").append($("<td style='width:5%; height:0px; border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:10%; height:0px; border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:20%; height:0px; border:none;'></td>"));
				    		uvobjTr.append($("<td style='width:60%; height:0px; border:none;'></td>"));
				    		$("#addpopupDay_list tbody").append(uvobjTr);
				    		
				    		var objTr = $("<tr></tr>").append($("<td colspan='5' style='text-align:center; width:500px; border-top:none;'></td>").text("내역이 없습니다."));
				    		$("#addpopupDay_list tbody").append(objTr);
				    	}
				    },
				    complete : function() {
				    	try {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);	
				    	} catch(e) {
				    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"attitude_main\"].layerHidden()'></div>").appendTo(parent.frames["attitude_menu"].document.body);
				    	}
			        	
			        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			        	
			        	$("#popupDay").css("left", popupX);
			        	
						$("#popupDay").modal({
							  escapeClose: false,
							  clickClose: false,
							  showClose: false
						});
				    }
			    });
			}
			
			function mod_detail(modAttId) {
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
				var feature = GetOpenPosition(790, 760);
				
				if (adminFlag == "true") {
					window.open("/ezAttitude/attModAppDetail.do?attModId=" + modAttId +"&adminFlag=" + adminFlag, "",
				 			"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				} else {
					window.open("/ezAttitude/attModAppDetail.do?attModId=" + modAttId, "",
				 			"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);	
				}
		    }
			
			function setAttitudeSquare(){
				//tdClassName = attiVacation, attiDefault, attiOutCom, attiLate, attiModLate, attiWeekCom
				$("span[name=span_list] td[attitudeid]").each(function(index){
					var squareSpan = $("<span></span>");
					var tdTypeId = $(this).attr("typeid");
					var tdParentId = $("#attiStatis td[typeid=" + tdTypeId + "]").attr("parentid");
					var tdClassName = "";
					switch(tdTypeId)
					{
						case "A01": case "A03": case "A06": //출근, 퇴근, 외출, 조퇴
						    tdClassName = "attiDefault";
							break;
						case "A04": case "A09": case "A10": //외근, 출장, 휴가
							tdClassName = "attiOutCom";
							break;
						case "A07": //휴근
							tdClassName = "attiWeekCom";
							break;
						case "A02": case "A08": //지각
							tdClassName = $(this).attr("modAppl") == 1 ? "attiModLate" : "attiLate";
							break;
						default: //나머지 휴가
							tdClassName = "attiVacation";
							break;
					}
					$(this).prepend(squareSpan.addClass(tdClassName));
				});
				
				checkAttiModAppl();
			}
			
			function checkAttiModAppl(){
				$('#attiCalendar tr td[typeid=A02]').each(function(){
					if (!attitudeModAppl) {
						$(this).css("cursor", "context-menu");
						$('#attiCalendar').off('dblclick', "tr td[typeid=A02]");
					}
				});
			}
			
			function deptChange() {
				if (authDeptList.value == "")
		            window.location.href = "/ezAttitude/attitudeDeptMain.do";
		        else {
		            window.location.href = "/ezAttitude/attitudeDeptMain.do?deptid=" + encodeURIComponent(authDeptList.value);
		        }
			}
		</script>
	</head>
	<body class="mainbody" style="overflow:auto; margin-bottom:0px;" marginwidth="0" marginheight="0">
		<c:if test="${deptFlag != 'true'}">
			<h1 id="titleimg"><spring:message code='ezAttitude.bbhs5'/></h1>
		</c:if>
		<c:if test="${deptFlag == 'true'}">
			<h1 id="titleimg"><spring:message code='ezAttitude.bbhs6'/></h1>
		</c:if>
		<div id="mainmenu">
			<ul>
				<c:if test="${adminFlag == 'true'}">
					<li>
						<select id="authDeptList" style="width:100px; margin-top:5px;" onchange="deptChange()">
							<c:forEach var="dept" items="${deptList}">
								<c:if test="${dept.mine != 'yes' }">
									<c:if test="${selectedDeptID == dept.deptId}">
										<option value="<c:out value='${dept.deptId}'/>" selected><c:out value='${dept.deptName}'/></option>
									</c:if>
									<c:if test="${selectedDeptID != dept.deptId}">
										<option value="<c:out value='${dept.deptId}'/>"><c:out value='${dept.deptName}'/></option>
									</c:if>
								</c:if>
							</c:forEach>
<%-- 						<c:if test="${deptList ne null }"> --%>
<%-- 							<c:forEach items="${deptList}" var="dept"> --%>
<%-- 							<c:choose> --%>
<%-- 								<c:when test="${dept.mine ne 'yes' }"> --%>
<%-- 									<option value="<c:out value='${dept.deptId}'/>"><c:out value='${dept.deptName}'/></option> --%>
<%-- 								</c:when> --%>
<%-- 							</c:choose> --%>
<%-- 							</c:forEach> --%>
<%-- 						</c:if> --%>
						</select>
					</li>
		        	<li id="search"><span onClick="excelDown()"><spring:message code='ezAttitude.bbhs7'/></span></li>
		        	<li id="search"><span onClick="sendMail()"><spring:message code='ezAttitude.bbhs8'/></span></li>
				</c:if>
				<c:if test="${adminFlag != 'true'}">
					<select id="authDeptList" style="width:100px; margin-top:5px; display:none;" onchange="deptChange()">
						<option value="<c:out value='${selectedDeptID}'/>" selected><c:out value='${selectedDeptID}'/></option>
					</select>
				</c:if>
				<li style="background:none;margin-left:7px;cursor:context-menu"><span style="display:inline-block; width:11px; height:11px; border:1px solid #017ddf; background:#018bfa; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;출/퇴근</li>
	            <li style="background:none;cursor:context-menu"><span style="display:inline-block; width:11px; height:11px; border:1px solid #049c37; background:#01b43f; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;휴가</li>
	            <li style="background:none;cursor:context-menu"><span style="display:inline-block; width:11px; height:11px; border:1px solid #e01662; background:#ff1c71; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;지각, 조퇴</li>
                <li style="background:none;cursor:context-menu"><span style="display:inline-block; width:11px; height:11px; border:1px solid #ccc31f; background:#e9de13; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;외근</li>
			</ul>
		</div>
		
		<table>
			<tr>
				<td style="vertical-align:top; width:91%;">
					<div style="vertical-align:top;" id="attiCalendar"></div>
				</td>
				<td style="vertical-align:top; width:10px;">&nbsp;</td>
				<td style="vertical-align:top; width:9%; margin-left:5px;">
					<div style="vertical-align:top; height:739px;" id="attiStatis">
					</div>
				</td>
			</tr>
		</table>
		
		<table class="mainlist" style="width:100%; display:none;" id="ExcelAttList">
	       	<tr>
				<th>NO.</th>
				<th><spring:message code='ezAttitude.bbhs9'/></th>
				<th><spring:message code='ezAttitude.bbhs10'/></th>
				<th><spring:message code='ezAttitude.bbhs11'/></th>
				<th><spring:message code='ezAttitude.bbhs12'/></th>
			</tr>
		</table>

		<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezAttitude/saticGetXlsAtt.do">
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value=""/>
	        <input type="hidden" id="userAgent" name="userAgent" value=""/>
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<!-- 근태유영별 팝업창 -->
		<div id="popup" class="popupwrap2" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:50px;">
			<div class="popupwrap3">
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="display:block; width:500px; margin:10px 0px 0px 1px;">
				    <thead>
				    	<tr>
						<th class="layerHeader" colspan="4" style="width:500px;">
							<img src="/images/kr/left/left_schedule.png" style="vertical-align: middle;padding-bottom:1px"/>
							<span id="popup_title">&nbsp;<spring:message code='ezAttitude.bbhs3'/></span>
						</th>
						</tr>
				    </thead>
				    <tbody style="max-height:500px; width:500px; display:block; overflow-y:auto;">
				    	<tr>
				    		<th style="height:30px">No.</th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t10'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t9'/></th>
				    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.bbhs12'/></th>
						</tr>
				    </tbody>
				</table>
				<br />
			</div>
			<a href="#close-modal" rel="modal:close" class="close-modal ">Close</a>
		</div>
		
		<!-- 근태날짜별 팝업창 -->
		<div id="popupDay" class="popupwrap4" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:50px;">
			<div class="popupwrap5">
				<!-- 내용 -->
			    <table class="popuplist" id="addpopupDay_list" style="display:block; width:560px; margin:10px 0px 0px 1px;">
				    <thead>
				    	<tr>
						<th class="layerHeader" colspan="5" style="width:560px;">
							<img src="/images/kr/left/left_schedule.png" style="vertical-align: middle;padding-bottom:1px"/>
							<span id="popupDay_title">&nbsp;<spring:message code='ezAttitude.bbhs3'/></span>
						</th>
						</tr>
				    </thead>
				    <tbody style="max-height:500px; width:560px; display:block; overflow-y:auto;">
				    	<tr>
				    		<th style="height:30px">No.</th>
				    		<th style="height:30px"><spring:message code='ezAttitude.bbhs15'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t10'/></th>
				    		<th style="height:30px"><spring:message code='ezAttitude.t9'/></th>
				    		<th style="height:30px; text-align:center"><spring:message code='ezAttitude.bbhs12'/></th>
						</tr>
				    </tbody>
				</table>
				<!-- /내용 -->
				<br />
			<a href="#close-modal" rel="modal:close" class="close-modal ">Close</a>
		</div>
		<div class="shadow"></div>
	</body>
</html>