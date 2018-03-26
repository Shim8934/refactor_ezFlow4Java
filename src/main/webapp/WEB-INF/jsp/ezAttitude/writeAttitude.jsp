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
			var companyId = "${companyId}";
			
			
			window.onload = function () {
				if (datetype == "1") {
	                document.getElementById("alldaycheck").checked = false;
	                allday_change();
	            }
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
				var uploadSDate = "2018-03-22 17:30:00";
				var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);
							
				var uploadEDate = "2018-03-22 18:00:00";
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
// 		        			window.opener.company_change();
							window.close();
		        	}
		        });
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
				<li><span onClick="close_onclick()">닫기</span></li>
			</ul>
		</div>
		<table class="content"> 
			<tr> 
    			<th>구분</th> 
    			<td>
					<select id="select" style="width:80px;" onchange="form_change()">
						<c:forEach var="item" items="${attitudeTypeList}">
							<option value="<c:out value='${item.typeId}'/>"><c:out value='${item.typeName}'/></option>
						</c:forEach>
					</select> 
				</td> 
  			</tr>
  			<tr> 
    			<th>성명</th> 
    			<td style="">
					<p>배현상</p>
    			</td> 
  			</tr>
  			<tr>
  				<th>일시 </th>
<!--   				<td style="height:45px;"> -->
<!--   					<table width="100%;"> -->
<!--   						<tr> -->
<!-- 	  						<td style=""> -->
<!-- 	  							<input type="checkbox"/>하루종일 <input id="startDate" type="text" style="width:100px;"/> <input id="endDate" type="text" style="width:100px;"/> -->
<!-- 	  						</td> -->
<!-- 	  					</tr> -->
<!--   						<tr> -->
<!-- 	  						<td colspan="2" width="70%"> -->
<!-- 	  							<input id="startTime" type="text" style="width:100px;"/> ~ <input id="endTime" type="text" style="width:100px;"/> -->
<!-- 	  						</td> -->
<!-- 	  					</tr> -->
<!--   					</table> -->
<!--   				</td> -->
                    <td colspan="2">
                        <span id="periodblock">
                        <input name="checkbox" type="checkbox" id="alldaycheck" onclick="allday_change()" value="1" checked>
                                                               하루종일
                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;display:none" />
                        ~
                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;display:none" />
                        </span>
                	</td>
  			</tr>
  			<tr> 
    			<th>근무지</th> 
    			<td style="">
					<input id="region" type="text" style="width:98%" value="">
    			</td> 
  			</tr>
  			<tr> 
    			<th>연락처</th> 
    			<td style="">
					<input id="mobile" type="text" style="width:98%" value="">
    			</td> 
  			</tr>
  			<tr> 
    			<th>업무대리</th> 
    			<td style="">
					<input id="bizsub" type="text" style="width:98%" value="">
    			</td> 
  			</tr>
		</table>
		<table id="contentTb" class="content" style="width:100%; margin-top: 10px;">
		  	<tr>
  				<td style="height: 300px;">
  				</td>  
  			</tr>
		</table>
	</body>
</html>