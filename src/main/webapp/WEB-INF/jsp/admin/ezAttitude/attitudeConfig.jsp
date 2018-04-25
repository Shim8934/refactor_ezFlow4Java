<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>attitudeConfig</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript">
	    	var adminCompany = "${adminCompany}";
	    
	        $(document).ready(function() {
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		            company_change();
		        }
		        
		        //timepicker
        		$('#start_hr').timepicker({ 
        			timeFormat: 'H:i',
        			step: 30,
        			scrollbar: true
        		});
        		$('#end_hr').timepicker({ 
        			timeFormat: 'H:i',
        			step: 30,
        			scrollbar: true
        		});
//         		$('#start_min').timepicker({ 
//         		    timeFormat: 'i',
//         		    step: 5,
//         		    maxTime: '00:59am',
//         		    startTime: '00:00am'
//         		});
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeConfigInfo.do",
	            	dataType : "json",
	            	data : {companyId : encodeURI($("#ListCompany").val())},
	            	success : function(result) {
	            		attitudeConfigSet(result);
	            	},
	            	error : function() {
	            		
	            	}
	            });
	        }
	        
	        function attitudeConfigSet(result) {
        		//근무시간
//         		var startTime = result.workStartTime.split(':');
//         		var endTime = result.workEndTime.split(':');
//         		$('#start_hr').val(startTime[0]);
//         		$('#start_min').val(startTime[1]);
//         		$('#end_hr').val(endTime[0]);
//         		$('#end_min').val(endTime[1]);
				
        		$('#start_hr').val(result.workStartTime);
        		$('#end_hr').val(result.workEndTime);
        		//휴무요일
        		var closedDays = result.closedDay.split(',');
        		for (var i = 0; i < closedDays.length; i++) {
        			$('#dayChkBox input[type=checkbox]').eq(i).val(closedDays[i]);
        			if(closedDays[i] == 1){
        				$('#dayChkBox input[type=checkbox]').eq(i).prop('checked', true);
        			} else {
        				$('#dayChkBox input[type=checkbox]').eq(i).prop('checked', false);
        			}
        		}
        		//근태수정신청
        		var attitudeModAppl = result.attitudeModAppl;
        		if (attitudeModAppl == 0) {
        			$('input[name=attitude_mod_appl]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=attitude_mod_appl]').eq(0).prop('checked', true);
        		}
        		//휴무일근태등록
        		var closedDateAttitude = result.closedDateAttitude;
        		if (closedDateAttitude == 0) {
        			$('input[name=close_date_attitude]').eq(1).prop('checked', true);
        		} else {
        			$('input[name=close_date_attitude]').eq(0).prop('checked', true);
        		}
	        }
	        
	        function save_config() {
	        	//시간
// 	        	if($("#end_hr").val() > $("#start_hr").val()) {
// 	        		alert('종료시간은 시작시간보다 늦어야 합니다.');
// 	        		return;
// 	        	}
	        	
	        	var closedDaysLength = $('#dayChkBox').find('input[type=checkbox]').length;
	        	var closedDays = "";
	        	for (var i = 0; i < closedDaysLength; i++) {
	        		closedDays += $('#dayChkBox input[type=checkbox]').eq(i).val() + ",";
	        	}
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezAttitude/updateAttitudeConfInfo.do",
	            	data : {companyId : encodeURI($("#ListCompany").val()),
	            			workStartTime : $("#start_hr").val(),
	            			workEndTime : $("#end_hr").val(),
	            			closedDay : closedDays.slice(0, -1),
	            			attitudeModAppl : $('input[name=attitude_mod_appl]:checked').val(),
	            			closedDateAttitude : $('input[name=close_date_attitude]:checked').val()},
	            	success : function() {
	            		alert('저장되었습니다.');
	            		company_change();
	            	},
	            	error : function() {
	            		alert('에러발생');
	            	}
	            });
	        }
	        
	     	//체크박스 변경시 값 변경
		    $(document).on('click', 'input[type=checkbox]' ,function() {
		    	if ($(this).is(":checked")) {
			    	$(this).attr('value','1');
		    	} else {
		    		$(this).attr('value','0');
		    	}
		    })
		    
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezAttitude.t10' /></h1>
	  	<div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
					</c:forEach>
	      		</select>
	      		</li>
	      	</ul>
	      	<ul>
	      		<li><span onclick="save_config()"><spring:message code='ezAttitude.t16' /></span></li>
	      	</ul>
	  	</div>
	  	
		<table class="content" style="width:500px">
			<tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t17' />
	            </th>
	            <td style="width: 500px; text-align:left; padding-left: 5px;">
<%-- 	            	<input id="start_hr" type="text" style="width:50px;"/><spring:message code='ezAttitude.t18' />&nbsp;<input id="start_min" type="text" style="width:50px;"/><spring:message code='ezAttitude.t19' /> ~ <input id="end_hr" type="text" style="width:50px;"/><spring:message code='ezAttitude.t18' />&nbsp;<input id="end_min" type="text" style="width:50px;"/><spring:message code='ezAttitude.t19' /> --%>
	            	<input id="start_hr" type="text" style="width:50px;"/> ~ <input id="end_hr" type="text" style="width:50px;"/>
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t20' />
	            </th> 
	            <td id="dayChkBox" style="width: 500px; text-align:left">
	            	<input type="checkbox"/><spring:message code='ezAttitude.t21' />
	            	<input type="checkbox"/><spring:message code='ezAttitude.t22' />
	            	<input type="checkbox"/><spring:message code='ezAttitude.t23' />
	            	<input type="checkbox"/><spring:message code='ezAttitude.t24' />
	            	<input type="checkbox"/><spring:message code='ezAttitude.t25' />
	            	<input type="checkbox"/><spring:message code='ezAttitude.t26' />
	            	<input type="checkbox"/><spring:message code='ezAttitude.t27' />
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t31' />
	            </th>
	            <td style="width: 500px; text-align:left">
	            	<input type="radio" name="close_date_attitude" value="1"/><spring:message code='ezAttitude.t29' />
	            	<input type="radio" name="close_date_attitude" value="0"/><spring:message code='ezAttitude.t30' />
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t28' />
	            </th>
	            <td style="width: 500px; text-align:left">
	            	<input type="radio" name="attitude_mod_appl" value="1"/><spring:message code='ezAttitude.t29' />
	            	<input type="radio" name="attitude_mod_appl" value="0"/><spring:message code='ezAttitude.t30' />
	            </td>
	        </tr>
		</table>
	</body>
</html>
