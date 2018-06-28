<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code = 'ezAttitude.t2' /></title>
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
        		$('#startTime').timepicker({ 
        			timeFormat: 'H:i',
        			step: 30,
        			scrollbar: true
        		});
        		$('#endTime').timepicker({ 
        			timeFormat: 'H:i',
        			step: 30,
        			scrollbar: true
        		});
	        });
	        
	        function company_change() {
	            $.ajax({
	            	type : "GET",
	            	url : "/admin/ezAttitude/attitudeConfigInfo.do",
	            	dataType : "json",
	            	data : {companyId : encodeURIComponent($("#ListCompany").val())},
	            	success : function(result) {
	            		attitudeConfigSet(result);
	            	},
	            	error : function() {
	            		alert("<spring:message code='ezAttitude.t175' />");
	            	}
	            });
	        }
	        
	        function attitudeConfigSet(result) {
        		//근무시간
        		$('#startTime').val(result.workStartTime);
        		$('#endTime').val(result.workEndTime);
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
	        	if (!checkPattern()) {
	    			alert("<spring:message code='ezAttitude.t117' />");
	    			return;
	    		}
	        	//시간
	        	if( $("#endTime").val() < $("#startTime").val() ) {
	        		alert("<spring:message code='ezAttitude.t131' />");
	        		return;
	        	}
	        	//휴무요일
	        	var closedDaysLength = $('#dayChkBox').find('input[type=checkbox]').length;
	        	var closedDays = "";
	        	for (var i = 0; i < closedDaysLength; i++) {
	        		closedDays += $('#dayChkBox input[type=checkbox]').eq(i).val() + ",";
	        	}
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezAttitude/updateAttitudeConfInfo.do",
	            	dataType : "text",
	            	data : {
	            			companyId : encodeURIComponent($("#ListCompany").val()),
	            			workStartTime : $("#startTime").val(),
	            			workEndTime : $("#endTime").val(),
	            			closedDay : closedDays.slice(0, -1),
	            			attitudeModAppl : $('input[name=attitude_mod_appl]:checked').val(),
	            			closedDateAttitude : $('input[name=close_date_attitude]:checked').val()
	            	},
	            	success : function(resultStatus) {
	            		if (resultStatus == "success") {
		            		alert("<spring:message code='ezAttitude.t155' />");
		            		company_change();
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	            	error : function() {
	            		alert("<spring:message code='ezAttitude.t175' />");
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
		    
		    //시간 체크
		    function checkPattern() {
				var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/;
				
				if ((timePattern.test($("#startTime").val()) && timePattern.test($("#endTime").val())) || ($("#startTime").val() == "" && $("#endTime").val() == "")) {
					return true;
				} else {
					if (!timePattern.test($("#startTime").val())&& !timePattern.test($("endTime").val())) {
						$("#startTime").focus();
						return false;
					} else if (!timePattern.test($("#startTime").val())) {
						$("#startTime").focus();
						return false;
					} else if (!timePattern.test($("#endTime").val())) {
						$("#endTime").focus();
						return false;
					}
				}
			}
		    
	     	//숫자만 입력 가능하게끔 -------------특수문자(shift+숫자)는 안먹힌다 -> 해결할것.
			function filterNumber(event) {
				var code = event.keyCode;
				
				if (code > 47 && code < 58) { //숫자
					return;
				}
				
				if (event.ctrlKey || event.altKey) { //alt, ctrl키
				    return;
				}
				
				if (code === 9 || code === 36 || code === 35 || code === 37 || code === 39 || code === 8 || code === 46) { //특수키
					return;
				}
				
				if (code === 186) { //콜론(:)
					return;
				}
				
				event.preventDefault();
			}

	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezAttitude.t2' /></h1>
	  	<div id="mainmenu">
			<span style="border: none;"><b><spring:message code='ezAttitude.t15' /> : </b></span>
			<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
				<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>"><c:out value='${item.displayName}'/></option>
				</c:forEach>
      		</select>
      		<br>
	  	</div>
	  	<h2 style="font-weight: normal">▒&nbsp;휴무요일 외 휴일은 일정관리메뉴의 기념일관리에서 추가하실 수 있습니다.</h2>
		<table class="content" style="width:500px">
			<tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t12' />
	            </th>
	            <td style="width: 500px; text-align:left; padding-left: 5px;">
	            	<input id="startTime" type="text" style="width:50px; ime-mode:disabled;"/> 
<!-- 	            	<input id="startTime" type="text" style="width:50px; ime-mode:disabled;" onkeydown="filterNumber(event);"/>  -->
	            	~
	            	<input id="endTime" type="text" style="width:50px; ime-mode:disabled;"/>
<!-- 	            	<input id="endTime" type="text" style="width:50px; ime-mode:disabled;" onkeydown="filterNumber(event);"/> -->
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
		<table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; width: 500px;">
	        <tbody><tr>
	            <td style="height: 50px; text-align: center;">
	                <a class="imgbtn"><span onclick="save_config()"><spring:message code='ezAttitude.t16' /></span></a>
	                <a class="imgbtn"><span onclick="company_change()"><spring:message code='ezAttitude.t34' /></span></a>
	            </td>
	        </tr>
	    </tbody></table>
	</body>
</html>
