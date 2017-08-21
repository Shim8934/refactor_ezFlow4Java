<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<title>보안메일</title>
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/composeappt.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript">
			var offsetMin = "${offsetMin}";
			
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Sdatepicker').datepicker("option", "minDate", NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', utcDate2(offsetMin));
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		    });
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		            closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
		            currentText: "<spring:message code='main.t0606' />",
		            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
		            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
		            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
		            weekHeader: "Wk",
		            dateFormat: "yy-mm-dd",
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: "show",
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    
		    var RetValue;
		    var ReturnFunction;
		    var CancelFunction;
		    var isDivPopUp = false;
		    
		    window.onload = function () {
		        var rgParams;
		        try {
		            RetValue = parent.secureMail_dialogArguments[0];
		            ReturnFunction = parent.secureMail_dialogArguments[1];
		            CancelFunction = parent.secureMail_dialogArguments[2];
		            isDivPopUp = true;
		            rgParams = RetValue;
		        } catch (e) {
		            try {
		                RetValue = opener.secureMail_dialogArguments[0];
		                ReturnFunction = opener.secureMail_dialogArguments[1];
		                CancelFunction = opener.secureMail_dialogArguments[2];
		                rgParams = RetValue;
		            } catch (e) { rgParams = dialogArguments; }
		        }
		        
		        document.getElementById("securePassword").value = RetValue["securePassword"];
		        
		        if (RetValue["secureReadCount"] != "0") {
		        	document.getElementById("maxReadCount").value = RetValue["secureReadCount"];
		        	document.getElementById("maxReadCount").disabled = false;
		        	document.getElementById("countUnlimit").checked = false;
		        }
		        
		        if (RetValue["secureReadDate"] != "") {
		        	var secureDate = new Date(Number(RetValue["secureReadDate"]));
		        	$("#Sdatepicker").datepicker('setDate', secureDate);
		        	$('#Stimepicker').timepicker('setTime', secureDate);
		        	document.getElementById("Sdatepicker").disabled = false;
		        	document.getElementById("Stimepicker").disabled = false;
		        	document.getElementById("dateUnlimit").checked = false;
		        }
		        
		        document.getElementById("securePassword").focus();
		    }
		
		    function confirm() {
	            if (document.getElementById("securePassword").value.trim() == "") {
	            	alert("암호를 입력하세요.");
	            	document.getElementById("securePassword").focus();
	            	return;
	            }
	            
	            var secureReadDate = null;
	            if (document.getElementById("dateUnlimit").checked == false) {
	            	secureReadDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	            	secureReadDate = secureReadDate.replace(/-/gi, "/");
	            	
		            var now = utcDate2(offsetMin);
		            var nowmonth = now.getMonth() + 1;
		            var pTime = now.getFullYear() + "/" + nowmonth + "/" + now.getDate() + " " + now.getHours() + ":" + now.getMinutes();
		            if (Date.parse(secureReadDate) < Date.parse(pTime)) {
		            	alert("열람 허용 기간이 현재 시간보다 이전으로 설정되었습니다.\n다시 설정해주시기 바랍니다.");
		            	return;
		            }
	            }
	            
	            RetValue["securePassword"] = document.getElementById("securePassword").value;
	            
	            if (document.getElementById("countUnlimit").checked == true) {
	            	RetValue["secureReadCount"] = 0;
	            } else {
	            	RetValue["secureReadCount"] = document.getElementById("maxReadCount").value;
	            }
	            
	            if (document.getElementById("dateUnlimit").checked == true) {
	            	RetValue["secureReadDate"] = "";
	            } else {
	            	RetValue["secureReadDate"] = Date.parse(secureReadDate);
	            }
	            
		        if (ReturnFunction != null)
		            ReturnFunction(RetValue);
		        else
		            window.close();
		    }
			
		    function chkMaxReadCount() {
		    	if (document.getElementById("countUnlimit").checked == true) {
	                document.getElementById("maxReadCount").disabled = true;
	            } else {
	            	document.getElementById("maxReadCount").disabled = false;
	            }
		    }
		    
			function chkMaxReadDate() {
				if (document.getElementById("dateUnlimit").checked == true) {
	                document.getElementById("Sdatepicker").disabled = true;
	                document.getElementById("Stimepicker").disabled = true;
	            } else {
	            	document.getElementById("Sdatepicker").disabled = false;
	                document.getElementById("Stimepicker").disabled = false;
	            }
		    }
			
			function cancel() {
		    	if (!isDivPopUp)
	                window.close();
	            else
	                CancelFunction();
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1>보안메일</h1>
		<span>※ 보안메일 열람에 필요한 암호와 열람 허용 횟수, 열람 허용 기간을 설정합니다.</span><br>
		<span>※ 보안메일 암호는 수신자에게 따로 공지해야 합니다.</span><br>
		<span>※ 보안메일 열람 시 인터넷에 연결되어있어야 합니다.</span><br>
		<span>※ 보낸편지함에서 해당 보안메일을 삭제하면 열람 불가능합니다.</span><br>
		<br>
		
		<table style="width:100%;" class="content">
		  <tr>
		    <th>보안메일 암호</th>
		    <td><input type="text" id="securePassword" maxlength="50" /></td>
		  </tr>
		  <tr>
		    <th>열람 허용 횟수</th>
		    <td>
		    	<select id="maxReadCount" style="width:50px" disabled>
		    		<option value=1>1</option>
		    		<option value=2>2</option>
		    		<option value=3>3</option>
		    		<option value=4>4</option>
		    		<option value=5>5</option>
		    	</select>
		    	회/인
		    	<span class="right">
		    		<input type="checkbox" id="countUnlimit" onclick="chkMaxReadCount()" checked /><label for="countUnlimit">무제한</label>
		    	</span>
		    </td>
		  </tr>
		  <tr>
		  	<th>열람 허용 기간</th>
		  	<td>
		  		<input type="text" id="Sdatepicker" style="width:80px;text-align:center" disabled />
		  		<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" disabled />
		  		<input type="checkbox" id="dateUnlimit" onclick="chkMaxReadDate()" checked /><label for="dateUnlimit">무제한</label>
		  	</td>
		  </tr>
		</table>
		
		<div class="btnposition">
		   <a class="imgbtn" onClick="confirm()" ><span><spring:message code='ezEmail.t38' /></span></a>
		   <a class="imgbtn" onClick="cancel()" ><span><spring:message code='ezEmail.t39' /></span></a>
		</div>
	</body>
</html>



