<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>근태작성</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		
		<script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/Calendar/TabMenu.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/lang/ezSchedule.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/Calendar.js"></script>
		<script type="text/javascript" src="/js/Holiday.js"></script>
		
		<!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		
		<script type="text/javascript">
			var writerName = "${userInfo.displayName}";
			var uselang = "${userInfo.lang}";
			var userOffset = "${userOffset}";
			var companyId = "${companyId}";
			var date = "${date}";
			var mode = "${mode}";
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
				select_memorialDays(uselang);
				setHoliday();
				
				
			}
			
			window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 250 + "PX";
		    }
			
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
			function setDatePicker(type) {
				$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        
		        var uploadSDate = "";
		        var uploadEDate = "";
		        if (mode == "mod" && modFirstFlag) {
					uploadSDate = pStartDate;
					uploadEDate = pEndDate;					
		        } else if (!modFirstFlag) {
		        	uploadSDate = startDate;
		        	uploadEDate = endDate == "" ? startDate.split(" ")[0] + " 23:59:59" : endDate;
		        } else {
					uploadSDate = date + " 00:00:00";
					uploadEDate = date + " 23:59:59";
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
		        $.datepicker.setDefaults($.datepicker.regional["ko"]);
		        
		        $("#Sdatepicker").change(function(){
		        	checkHoliday($(this).val());
		        })
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
					type : "POST",
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
						
						$("#attiwriteForm tr").not("tr:first").remove();
						$("#attiwriteForm tbody").after(result.formHtml);
						$("#writerName").closest("tr").remove();
						setDatePicker($("#periodblock").attr("datetype"));
					    
						checkHoliday($("#Sdatepicker").val());
						if ($("input[name=region]").length != 0) {
							$("input[name=region]").val(region);
						}
						$("input[name=mobile]").val(mobile);
						$("input[name=bizsub]").val(bizSub);
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
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
						endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";
						break;
					case "5":
						startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
						endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd'}).val() + " " + $('#Etimepicker').val();
						break;
				}
			}
			
			//저장
			function save_attitude() {
				dateTypeCheck();
				attRegCheck();
				return;
				$.ajax({
		        	type : "POST",
		        	url : "/ezAttitude/attitudeSave.do",
		        	async : false,
		        	data : {
		        		attitudeId : attitudeId,
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
		        		alert("근태가 저장되었습니다.");
		        		window.opener.getAttitudeMainList();
		        		window.close();
		        	}
		        });
			}
			
			function setHoliday() {
				$.ajax({
					type:"POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getHolidayList.do",
					data : {},
					success : function(result) {
						holidayAttReg = result.attitudeConfigVO.closedDateAttitude;
						closedDay = result.attitudeConfigVO.closedDay.split(",");
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
						form_change();
					}
				});
			}
			
			function checkHoliday(pDate){
				var checkDate = new Date(pDate);
				//휴무일근태등록이 0인 경우만 생각햇다, 1인 경우도 생각해야된다.
				
				//공휴일부터 체크
				var todayLunar = lunarCalc(checkDate.getFullYear(), checkDate.getMonth() + 1, checkDate.getDate(), 1);
				var todayMemorialDayList = memorialDayCheck(checkDate, todayLunar);
				var todayYearMemorialDayList = yearmemorialDayCheck(checkDate, todayLunar);
				
				if (todayMemorialDayList != 0 || todayYearMemorialDayList.length != 0 || closedDay[checkDate.getDay()] == "1") {
					$("#selectAtti option[value=A07]").css("display", "");
				} else {
					if ($('#selectAtti').val() == "A07") {
						$("#selectAtti").val("A04");
						form_change($("#selectAtti"));
					}
					$("#selectAtti option[value=A07]").css("display", "none");
				}
				
// 				if (holidayAttReg == "0" && $("#Edatepicker").length == 0) {
// 					//길이비교, 요일비교
// 					if (todayMemorialDayList != 0 || todayYearMemorialDayList.length != 0 || closedDay[checkDate.getDay()] == "1") {
// 						$("#selectAtti").val("A07");
// 						$("#selectAtti option").not(":selected").css("display", "none");
// 						$("#selectAtti option[value=A07]").css("display", "");
// 						form_change($("#selectAtti"));
// 						alert("휴일에는 휴근만 등록이 가능합니다. 다른 근태를 등록하시려면 날짜를 이동해주세요.");
// 						//저 alert을 휴일에는 휴근만 등록이 가능하다고 하고, 휴근으로 돌려주지말고 아예 날짜를 선택을 못하게 막아버리는 건 또 어떻까 생각이 드네요.
// 					} else if($("#selectAtti").val() == "A07") {
// 						$("#selectAtti").val("A04");
// 						$("#selectAtti option").css("display", "");
// 						$("#selectAtti option[value=A07]").css("display", "none");
// 						form_change($("#selectAtti"));
// 					}
// 				} else 
// 				if ($("Edatepicker").length == 0){
					//1인 경우에 휴근 열어주는 작업도 해야겟다.
// 				}
			}
			
			function attRegCheck() {
				//만약에 날짜데로 나눠 줄꺼면 여기서 나눠서 들고가는게 맞는거 같은데.. 휴무일 다 나눌 수 있으니까
				//안나눠주면 for문 돌려서 하나씩 체크하면 되구, 체크를 해서 돌린다음에 휴일이 잇으면 팅기게 하면 되구
				//eDate가 ""면 파라미터 던질 때 sDate 던져버려
				var subDate = "";
				if (endDate == "") {
					
				} else {
					subDate = calDateRange(startDate, endDate);
				}
				
				alert(subDate);
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
	                                <li><span onclick="save_attitude()">저장 후 닫기</span></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"><spring:message code='ezSchedule.t16'/></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <table id="attiwriteForm" class="content">
								<tr id="selectTR">
									<th>구분</th>
									<td colspan="2" id="selectTD">
										<select id="selectAtti" style="width:80px;" onchange="form_change(this)">
											<c:forEach var="item" items="${attitudeTypeList }">
												<c:if test="${item.parentId ne 'A05' && item.typeId ne 'A01' && item.typeId ne 'A02' && item.typeId ne 'A03'}">
													<option value="<c:out value='${item.typeId }'/>"><c:out value="${item.typeName }"/></option>
												</c:if>
											</c:forEach>
										</select>
										<select id="subSelectAtti" style="width:80px; margin-left:10px; display: none;" onchange="form_change(this)">
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
	                    <td style="vertical-align:top;height:100%;" id="EdtorSize">
		                    <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
	                    </td>
	                </tr>
	            </table>
	        </div>
	        <script type="text/javascript">
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 250 + "PX";
		    </script>
	    </form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>