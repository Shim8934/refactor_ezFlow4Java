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
		
		<!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		
		<script type="text/javascript">
			var writerName = "${userInfo.displayName}";
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
			
			window.onload = function () {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
				
				form_change();
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
		        if (mode == "mod") {
					uploadSDate = pStartDate;
					uploadEDate = pEndDate;
		        } else {
					uploadSDate = date + " 00:00:00";
					uploadEDate = date + " 23:59:59";
		        }
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
							if ($("input[name=region]").length != 0) {
								region = $("input[name=region]").val();
							}
							mobile = $("input[name=mobile]").val();
							bizSub = $("input[name=bizsub]").val();
						} else {
							modFirstFlag = false;
						}
						
						$("#attiwriteForm tr").not("tr:first").remove();
						$("#attiwriteForm tbody").after(result.formHtml);
						$("#writerName").text(writerName);
						setDatePicker($("#periodblock").attr("datetype"));
						
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
				
				save_attitude();
			}
			
			//저장
			function save_attitude() {
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
		        		content : message.GetEditorContent().replace(/(^\s+)|(\s+$)/gi, ""),
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
			
			function checkHoliday(obj) {
				var now = new Date();
				var tz = now.getTime() + (now.getTimezoneOffset() * 60000) + (parseInt(userOffset.split(':')[0]) * 3600000) + (parseInt(userOffset.split(':')[1]) * 60000);
				now.setTime(tz);
				$.ajax({
					type:"POST",
					dataType : "json",
					async : true,
					url : "/ezAttitude/getHolidayList.do",
					data : {},
					success : function(result) {
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
						
						var todayLunar = lunarCalc(now.getFullYear(), now.getMonth() + 1, now.getDate(), 1);
						var todayMemorialDayList = memorialDayCheck(now, todayLunar);
						var todayYearMemorialDayList = yearmemorialDayCheck(now, todayLunar);
						
						closedDay = result.attitudeConfigVO.closedDay.split(",");
						if (todayMemorialDayList.length != 0 || todayYearMemorialDayList.length != 0 || closedDay[now.getDay()] == "1") {
							holidayFlag = true;
						}
					}
				});
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
	                                <li><span onclick="dateTypeCheck()">저장 후 닫기</span></li>
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