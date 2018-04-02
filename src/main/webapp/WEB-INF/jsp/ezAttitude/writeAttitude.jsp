<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>근태작성!!!!!!!!!!!!!</title>
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
			var companyId = "${companyId}";
			var date = "${date}"
			
			window.onload = function () {
// 				if (datetype == "1") {
// 	                document.getElementById("alldaycheck").checked = false;
// 	                allday_change();
// 	            }

				form_change();
			}
			
			$(function () {
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
				var uploadSDate = date + " 00:00:00";
				var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);
							
				var uploadEDate = date + " 23:59:59";
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
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', SDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });

		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		        $('#Etimepicker').timepicker();
		        $('#Etimepicker').timepicker('setTime', EDate);
		        $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
		    });
		    
		    var monthMsg = "1월;2월;3월;4월;5월;6월;7월;8월;9월;10월;11월;12월";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "일;월;화;수;목;금;토";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["ko"] = {
		        	closeText: "닫기",
		            prevText: "이전달",
		            nextText: "다음달",
					currentText: "오늘",
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
		    });
			
			//저장
			function save_attitude() {
				$.ajax({
		        	type : "POST",
		        	url : "/ezAttitude/",
		        	async : false,
		        	data : {
		        		companyId : companyId
		        	},
		        	success : function (result) {
		        		
		        	}
		        });
			}
			
			// 근태종류 선택 시 이벤트
			var selectType = "";
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
						alert(result);
					}
				})
			}
			
		</script>
	</head>
	<body class = "popup">
<!-- 		<h1>근태 작성</h1> -->
		<div id="menu">
			<ul>
				<li><span onClick="save_attitude()">저장</span></li>
			</ul>
		</div>
		<div id="close">
			<ul>
				<li><span onClick="window.close()">닫기</span></li>
			</ul>
		</div>
		<table class="content"> 
			<tr> 
    			<th>구분</th> 
    			<td>
					<select id="selectAtti" style="width:80px;" onchange="form_change(this)">
						<c:forEach var="item" items="${attitudeTypeList }">
							<c:if test="${item.parentId ne 'A05'}">
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
  			<tr> 
    			<th>성명</th> 
    			<td id="writerName" style=""> 배현상 </td> 
  			</tr>
  			<tr>
  				<th>일시 </th>
                    <td colspan="2">
                        <span id="periodblock">
                        <input name="checkbox" type="checkbox" id="alldaycheck" onclick="allday_change()" value="1" checked>
                                                               하루종일
                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
                        ~
                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
                        </span>
                	</td>
  			</tr>
  			<tr> 
    			<th>근무지</th> 
    			<td id="region" style="">
					<input name="region" type="text" style="width:98%" value="">
    			</td> 
  			</tr>
  			<tr> 
    			<th>연락처</th> 
    			<td id="mobile" style="">
					<input name="mobile" type="text" style="width:98%" value="">
    			</td> 
  			</tr>
  			<tr> 
    			<th>업무대리</th> 
    			<td id="bizsub" style="">
					<input name="bizsub" type="text" style="width:98%" value="">
    			</td> 
  			</tr>
		</table>
		<table id="content" class="content" style="width:100%; margin-top: 10px;">
		  	<tr>
  				<td style="height: 300px;">
  				</td>  
  			</tr>
		</table>
	</body>
</html>