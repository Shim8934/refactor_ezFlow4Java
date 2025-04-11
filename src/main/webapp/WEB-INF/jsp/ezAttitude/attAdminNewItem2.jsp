<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t51'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/lang/ezSchedule.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/Calendar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<style>
		</style>
		<script type="text/javascript">
			var userId = "<c:out value='${userInfo.id }'/>";
			var writerName = "${userInfo.displayName}";
			var uselang = "${userInfo.lang}";
			var userOffset = "${userOffset}";
			var companyId = "${companyID}";
			var date = "<c:out value='${date}'/>";
			var time = "${time}";//현재시간
			var nowTime = time.split(":");
			var mode = "<c:out value='${mode}'/>";
			var pStartDate = "<c:out value='${attitudeInfo.startDate}'/>";
			var pEndDate = "<c:out value='${attitudeInfo.endDate}'/>";
			var typeId = "<c:out value='${attitudeInfo.typeId}'/>";
			var region = "<c:out value='${attitudeInfo.region}'/>";
			var mobile = "<c:out value='${attitudeInfo.mobile}'/>";
			var bizSub = "<c:out value='${attitudeInfo.bizSub}'/>";
 			var content = '${attitudeInfo.content}';
			var attitudeId = "<c:out value='${attitudeInfo.attitudeId}'/>";
			var dateType = "<c:out value='${attitudeInfo.dateType}'/>";
			var pAttitudeTypeList = ${attitudeTypeList}; 
			var holidayFlag = false;
			var closedDay = "";
			var holidayAttReg = true;
			
			window.onload = function () {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
				/* select_memorialDays(uselang); */
				setHoliday();
				setTypeName();
			}
			
			window.onresize = function () {   	
				$("#EdtorSize").css("height", document.documentElement.clientHeight - $("#normalScreen tr:eq(1)").css("height").substring(0, $("#normalScreen tr:eq(1)").css("height").length - 2) - 105 + "PX");
		    }
			
		    var monthMsg = "<spring:message code='ezAttitude.t139'/>";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezAttitude.t140'/>";
		    var dayStr = dayMsg.split(";");
		    
			function setDatePicker(type) {
				$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        
		        var uploadSDate = "";
		        var uploadEDate = "";
		        if (mode == "mod" && modFirstFlag) {
					uploadSDate = pStartDate;
					uploadEDate = pEndDate;					
		        } else if (!modFirstFlag) {
		        	uploadSDate = startDate;
		        	uploadEDate = endDate == "" ? startDate.split(" ")[0] + " 23:30:00" : endDate;
		        } else {
					uploadSDate = date + " " + nowTime[0] + ":00:00";
					uploadEDate = date + " " + nowTime[0] + ":30:00";
		        }
		        
		        modFirstFlag = false;
				var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);
							
				var eYear = uploadEDate.substring(0, 4);
				var eMonth = uploadEDate.substring(5, 7);
				var eDay = uploadEDate.substring(8, 10);
				var eHour = uploadEDate.substring(11, 13);
				var eMin = uploadEDate.substring(14, 16);
				
		        var SDate = new Date();
		        SDate.setFullYear(sYear, sMonth-1, sDay);
		        SDate.setHours(sHour, sMin, 0, 0);
		        
		        var EDate = new Date();
		        EDate.setFullYear(eYear, eMonth-1, eDay);
		        EDate.setHours(eHour, eMin, 0, 0);
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);

		        $("input[id=Stimepicker]").attr("oninput", "this.value=this.value.replace(/[^0-9.\:]/g, '')");
		        $("input[id=Etimepicker]").attr("oninput", "this.value=this.value.replace(/[^0-9.\:]/g, '')");
		        
		        if (type == 2 || type == 3 || type == 5) {
			        $('#Stimepicker').timepicker();
			        $('#Stimepicker').timepicker('setTime', SDate);
			        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
			        if (type == 3 || type == 5) {
				        $('#Etimepicker').timepicker();
				        $('#Etimepicker').timepicker('setTime', EDate);
				        $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
			        }
		        }
		        
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
		        
		        if (typeId == 'A04' && dateType == 4) {
		        	$('#Stimepicker').timepicker();
			        $('#Stimepicker').timepicker('setTime', SDate);
			        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
			        $('#Etimepicker').timepicker();
			        $('#Etimepicker').timepicker('setTime', EDate);
			        $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
			        
			        $("#periodblock").attr("datetype", dateType);
		        	$("#Stimepicker").css("display", "none");
					$("#Etimepicker").css("display", "none");
					$("#alldaycheck").prop("checked",true);
		        }
			}
			
			function Editor_Complete() {
				message.SetEditorContent(content);
		    }
			
			var selectType = "";
			var modFirstFlag = true;
			function form_change(obj) {
				// 근태종류를 선택하면 폼이 바뀌어야 된다.
				// A05일 경우 subSelectAtti에서 변경해준다.
				if ($(obj).val() == 'A05') {
					$("#subSelectAtti").css("display","");
					selectType = $("#subSelectAtti").val();
				} else if ($(obj).attr("id") == "selectAtti" && $(obj).val() != 'A05') {
					$("#subSelectAtti").css("display","none");
					selectType = $(obj).val();
				} else {
					selectType = $(obj).val();
				}
				
				if (mode == "mod" && modFirstFlag) {
					selectType = typeId;
					if ($("#selectAtti option[value='" + selectType + "']").length == 0) {
						$("#selectAtti").val("A05");
						$("#subSelectAtti").css("display","").val(selectType);
					} else {
						$("#selectAtti").val(selectType);
					}
				}
				
				if (selectType == "" || selectType == undefined) {
					selectType = $("#selectAtti").val();
				}
				
				getFormBody();
			}
			
			function getFormBody() {
				$.ajax({
					type : "get",
					url : "/ezAttitude/getFormBody.do",
					async : false,
					data : {
						typeId : selectType
					},
					success : function (result) {
						if (!modFirstFlag) {
							dateTypeCheck();
							if ($("input[name=region]").length != 0) {
								region = $("input[name=region]").val();
							}
							mobile = $("input[name=mobile]").val();
							bizSub = $("input[name=bizsub]").val();
						}
						
// 						$("#attiwriteForm tr").not("tr:first").remove();
						var trs = $("#attiwriteForm tr");
						for (var i = 0; i < trs.length; i++) {
							if (i > 2) {
								trs.eq(i).remove();	
							}
						}
						$("#attiwriteForm tbody").after(result.formHtml);
						$("#writerName").closest("tr").remove();
						setDatePicker($("#periodblock").attr("datetype"));
					    
						if ($("input[name=region]").length != 0) {
							$("input[name=region]").val(region);
						}
						$("input[name=mobile]").val(mobile);
						$("input[name=bizsub]").val(bizSub);
						
						//언어
						if (uselang != "1") {							
							$("#attiTime").siblings("th").text("<spring:message code='ezAttitude.t149'/>");
							$("#region").siblings("th").text("<spring:message code='ezAttitude.t47'/>");
							$("#mobile").siblings("th").text("<spring:message code='ezOrgan.t285'/>");
							$("#bizsub").siblings("th").text("<spring:message code='ezAttitude.t311'/>");
							$("#bizsub").siblings("th").text("<spring:message code='ezAttitude.t311'/>");
							document.querySelector('#periodblock input[type="checkbox"]').nextSibling.nodeValue = "<spring:message code='ezAttitude.t333'/>";
						}
						editorResize();
					}
				})
			}
			
			var startDate = "";
			var endDate = "";
			function dateTypeCheck() {
				var dateType = $("#periodblock").attr("datetype");
				startDate = "";
				endDate = "";
				
				switch (dateType) {
					case "1":
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
						break;
					case "2":
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
						break;
					case "3":
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
						endDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
						break;
					case "4":
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00:00";
						endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "23:59:59";
						break;
					case "5":
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
						endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd'}).val() + " " + $('#Etimepicker').val();
						break;
				}
			}
			
			//저장
			function save_attitude() {
				//글자 수 제한
				if (!CheckStrLen()) {
					return;
				}
				
				dateTypeCheck();
				
				var timeValid = /^(2[0-3]|[01][0-9]):?([0-5][0-9])$/;
				
				//미입력자 등록 시 사원 추가 여부
				if ($("#forId").text() == "") {
					alert("<spring:message code='ezAttitude.t52'/>");
					return;
				}
				
				//달력 정규식
				if ($('#Stimepicker').length && !timeValid.test($('#Stimepicker').val()) || $('#Etimepicker').length && !timeValid.test($('#Etimepicker').val())) {
					alert("<spring:message code='ezAttitude.t170'/>");
					return;
				}
				//달력 유효성 검사
				if (!check_time()) {
					alert("<spring:message code='ezAttitude.t131'/>");
					return;
				}
				
				//근무지 입력 여부
				if ($("#region").length != 0 && $.trim($("input[name=region]").val()) == "") {
					$("input[name=region]").focus();
					alert("<spring:message code='ezAttitude.t49'/>");
					return;
				}
				
				//조퇴 등록시 출근여부 확인
				if (selectType == 'A08') {
					var returnValue = getIsAttitude('A01');
					if (returnValue == 0) {
						alert("<spring:message code='ezAttitude.t224'/>");
						return;
					}
				}
				
				//외출 등록시 출근여부 확인
				if (selectType == 'A06') {
					var returnValue = getIsAttitude('A01');
					if (returnValue == 0) {
						alert("<spring:message code='ezAttitude.t306'/>");
						return;
					}
				}
				
				//퇴근시 출근여부 확인
		    	if (selectType == "A03") {
		    		var returnValue = getIsAttitude("A01");
		    		if (returnValue == 0) {
		    			alert("<spring:message code='ezAttitude.t168'/>");
			    		return;
		    		}
		    	}
				
				$.ajax({
		        	type : "POST",
		        	url : "/ezAttitude/attAdminSave.do",
		        	dataType : "text",
		        	async : false,
		        	data : {
		        		attitudeId : attitudeId,
		        		userId : $("#forId").text(),
		        		typeId : selectType,
		        		region : $("input[name=region]").val(),
		        		mobile : $("input[name=mobile]").val(),
		        		bizSub : $("input[name=bizsub]").val(),
		        		content : message.GetEditorContent().replace(/(\s+)|(\s+)/gi, " "),
		        		dateType : $("#periodblock").attr("datetype"),
		        		startDate : startDate,
		        		endDate : endDate,
		        		mode : mode
		        	},
		        	success : function (result) {
		        		if (result == "dupl") {
		        			alert("<spring:message code='ezAttitude.t50'/>");
		        		} else if (result == "success") {
			        		alert("<spring:message code='ezAttitude.t155'/>");
							try {
								window.opener.getList();	
							} catch (e) {
								window.opener.getAttitudeCheckList();
							}
			        		window.close();
		    			} else {
		    				alert("<spring:message code='ezAttitude.t175' />");
		    			}
		        	},
		        	error : function() {
		        		alert("<spring:message code='ezAttitude.t175' />");
		        	}
		        });
			}
			
			function setHoliday() {
				$.ajax({
					type:"GET",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getHolidayList.do",
					data : {
						isRest : "rest"
					},
					success : function(result) {
						holidayAttReg = result.attitudeConfigVO.closedDateAttitude;
						closedDay = result.attitudeConfigVO.closedDay.split(",");
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
						form_change();
					}
				});
			}
			
			//휴무일이 있는 경우 근태를 등록하지 못하게 변경
			function attRegCheck() {
				var lunar = "";
				var isMemorialDay = "";
				var isYearMemorialDay = "";
				var subDate = "";
				if (endDate == "") {
					subDate = 0;
				} else {
					subDate = calDateRange(startDate.split(" ")[0], endDate.split(" ")[0]);
				}
				
				var betweenDate = new Date(startDate.split(" ")[0]);
				for (var i = 0; i <= subDate; i++) {
					betweenDate.setDate(betweenDate.getDate() + (i == 0 ? 0 : 1));
					lunar = lunarCalc(betweenDate.getFullYear(), betweenDate.getMonth() + 1, betweenDate.getDate(), 1);
					isMemorialDay = memorialDayCheck(betweenDate, lunar);
					isYearMemorialDay = yearmemorialDayCheck(betweenDate, lunar);
					
					//휴무일이 있는 경우
					if (isMemorialDay.length != 0 || isYearMemorialDay != 0 || closedDay[betweenDate.getDay()] == "1") {
						return true;
					}
				}
				return false;
			}
			
			//휴근등록시
			function weekWorkCheck() {
				var lunar = "";
				var isMemorialDay = "";
				var isYearMemorialDay = "";
				var dayList = "";
				
				var betweenDate = new Date(startDate.split(" ")[0]);
				lunar = lunarCalc(betweenDate.getFullYear(), betweenDate.getMonth() + 1, betweenDate.getDate(), 1);
				isMemorialDay = memorialDayCheck(betweenDate, lunar);
				isYearMemorialDay = yearmemorialDayCheck(betweenDate, lunar);
				
				//휴무일이 있는 경우
				if (isMemorialDay.length != 0 || isYearMemorialDay.length != 0 || closedDay[betweenDate.getDay()] == "1") {
					if (isMemorialDay.length != 0 ) {
						dayList = isMemorialDay;
					} else if (isYearMemorialDay.length != 0) {
						dayList = isYearMemorialDay;
					}
					//기념일 휴무여부 체크
					if (dayList.length != 0 ) {
						for (var i = 0; i < dayList.length; i++) {
							if (dayList[i].holiday == false) {//휴무일은 아닐경우
								return false;
							}
						}
					}
					return true;
				}
				return false;
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
			
			function check_time() {
				var checkStartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var checkEndDate = $("#Edatepicker").length == 0 ? checkStartDate : $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    
			    var startYear = checkStartDate.split("-")[0];
			    var startMonth = checkStartDate.split("-")[1];
			    var startDay = checkStartDate.split("-")[2];
			    var endYear = checkEndDate.split("-")[0];
			    var endMonth = checkEndDate.split("-")[1];
			    var endDay = checkEndDate.split("-")[2];
			    
			    
			    if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) > parseInt(endDay))) {
			        return false;
			    }
			    else if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) == parseInt(endDay))) {
			        if ($("#periodblock").attr("datetype") != "1" && $("#periodblock").attr("datetype") != "2" && $("#periodblock").attr("datetype") != "4") {
			        	var stime = $('#Stimepicker').val();
					    var etime = $('#Etimepicker').val();
					    
					    var shour, sminute;
					    var ehour, eminute;
					    
					    shour = stime.split(':')[0];
					    sminute = stime.split(':')[1];
					    ehour = etime.split(':')[0];
					    eminute = etime.split(':')[1];
			            if (shour > ehour || (shour == ehour && sminute >= eminute)) {
			                return false;
			            }
			            else
			                return true;
			        }
			        return true;
			    }
			    
			    return true;
			}
			
			function editorResize() {
				$("#EdtorSize").css("height", document.documentElement.clientHeight - $("#normalScreen tr:eq(1)").css("height").substring(0, $("#normalScreen tr:eq(1)").css("height").length - 2) - 105 + "PX");
				if ($("#EdtorSize").css("display") == "none") {
					$("#EdtorSize").css("display", "");
				}
			}
			
			function allday_change() {
				if ($("#alldaycheck").prop("checked") == true) {
					$("#Stimepicker").css("display", "none");
					$("#Etimepicker").css("display", "none");
					$("#periodblock").attr("datetype", 4);
					
				} else {
					$("#Stimepicker").css("display", "");
					$("#Etimepicker").css("display", "");
					$("#periodblock").attr("datetype", 5);
				}
			}
			
			function inputCheck() {
				var inputCheckFlag = true;
				if ($("#region").length != 0 && $.trim($("input[name=region]").val()) == "") {
					$("input[name=region]").focus();
				} else if ($("#mobile").length != 0 && $.trim($("input[name=mobile]").val()) == "") {
					$("input[name=mobile]").focus();
				} else if ($("#bizsub").length != 0 && $.trim($("input[name=bizsub]").val()) == "") {
					$("input[name=bizsub]").focus();
				} else {
					inputCheckFlag = false;
				}
				return inputCheckFlag;
			}
			
			var mail_newreceiverchoose_dialogArguments = new Array();
			
	        function SelectReceiver_onClick() {
	            var type = "auto";
	            var receiverData = new Array();
	            
	            receiverData["addReceiver"] = addReceiver;
	            receiverData["window"] = this;
	            mail_newreceiverchoose_dialogArguments[0] = receiverData;
	            mail_newreceiverchoose_dialogArguments[1] = addReceiver;
	            
	            var OpenWin = window.open("/ezAttitude/attNewReceiverChoose.do?defaultwin=&type=" + type + "&rulekind=" + "&companyID=" + companyId, "mail_foldermanage_Cross", GetOpenWindowfeature(690, 630));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	
	        function addReceiver(strId, strName, strDeptName) {
	            $("#forId").text(strId);
	            $("#forName").text("").append($("<span></span>").css({"display":"inline-block", "margin-right":"4px"}).text(strDeptName + " " + strName));
	        }
	        
	      	//특수문자
			function setTypeName() {
				$('#subSelectAtti option').each(function(){
					var typeName = $(this).text();
					typeName = ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(typeName, "&#39;", "'"), "&lt;", "<"), "&gt;", ">"), "&quot;", '"'), "&amp;", "&");
					$(this).text(typeName);
				})
			}
			
			//글자 수 제한
			function CheckStrLen() {
				var temp; //들어오는 문자값...
				var msglen = 500;
				var value = message.GetEditorContent().replace(/(\s+)|(\s+)/gi, " ");

				len = message.GetEditorContent().replace(/(\s+)|(\s+)/gi, " ").length;
				
				if (len > 500) {
					alert("<spring:message code='ezAttitude.t82'/>");
					return false;
				} else {
					return true;
				}
			}
			
			//조퇴시 출/퇴근 여부 체크
		    function getIsAttitude(typeId) {
				var isAttitudeReturn = "";
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezAttitude/getIsAttitude.do",
		    		data : {
		    			typeId : typeId,
		    			selectUserId : $("#forId").text(),
		    			startDate : $("#Sdatepicker").val()
		    		},
		    		success : function(result) {
		    			isAttitudeReturn = result;
		    		},
		    		complete : function() {
		    			
		    		}
		    	})
		    	return isAttitudeReturn;
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                        	<ul id="menuTable">	
	                                <li class="sel"><h1 style="padding:0px; margin-top:-5px;"><spring:message code='ezAttitude.t51'/></h1></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <table id="attiwriteForm" class="content" style="margin-top:5px">
	                        	<tr id="userName" fixed="fix">
	                        		<th><a class="imgbtn"><span onclick="SelectReceiver_onClick()" style="width: 35px; text-align: center;"><spring:message code='ezAttitude.t219'/></span></a></th>
	                        		<td id="forName"></td>
	                        	</tr>
	                        	<tr id="userId" fixed="fix" style="display:none;">
	                        		<th>ID</a>
	                        		<td id="forId"></td>
	                        	</tr>
								<tr id="selectTR" fixed="fix">
									<c:choose>
										<c:when test="${userInfo.lang == 1}">
											<th><div style="width:48px;"><spring:message code='ezAttitude.t134'/></div></th>
										</c:when>
										<c:otherwise>
											<th><div style="width:100px;"><spring:message code='ezAttitude.t134'/></div></th>
										</c:otherwise>
									</c:choose>
									<td colspan="2" id="selectTD">
										<select id="selectAtti" style="width:130px;" onchange="form_change(this)">
											<c:forEach var="item" items="${attitudeTypeList }">
												<c:if test="${item.parentId ne 'A05'}">
													<c:if test="${item.typeId ne 'A25'}">
														<option value="<c:out value='${item.typeId }'/>"><c:out value="${item.typeName }"/></option>
													</c:if>
												</c:if>
											</c:forEach>
										</select>
										<select id="subSelectAtti" style="width:130px; margin-left:10px; display: none;" onchange="form_change(this)">
											<c:forEach var="item" items="${attitudeTypeList }">
												<c:if test="${item.parentId eq 'A05'}">
													<option value="<c:out value='${item.typeId }'/>"><c:out value="${item.typeName }"/></option>
												</c:if>
											</c:forEach>
										</select>
									</td>
								</tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="vertical-align:top;height:100%;display:none;" id="EdtorSize">
		                    <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
	                    </td>
	                </tr>
	            </table>
	            <div class="btnpositionNew" id="menuTable">
	            	<a class="imgbtn"><span onclick="save_attitude()"><spring:message code='ezAttitude.t16'/></span></a>					
				</div>
	        </div>
	        <script type="text/javascript">
		        //document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 180+ "PX";
		    </script>
	    </form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>