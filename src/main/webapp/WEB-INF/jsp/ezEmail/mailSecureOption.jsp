<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<title><spring:message code='ezEmail.lhm63' /></title>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<!-- crypt -->
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		
		<script type="text/javascript">
			var offsetMin = "${offsetMin}";
			var rsa = new RSAKey();
			
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Sdatepicker').datepicker("option", "minDate", NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', utcDate2(offsetMin));
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i', 'disableTextInput': true});
		        
				// timepicker input 요소에 키보드 입력할 수 없도록 수정
				$("#Stimepicker").on("focus", function() {
					$(this).trigger("blur");
				});
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
		    	rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
		    	
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
		        document.getElementById("securePasswordCheck").value = RetValue["securePassword"];
		        
		        if (RetValue["secureReadCount"] != "" && RetValue["secureReadCount"] != "0") {
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
	            	alert("<spring:message code='ezEmail.lhm42' />");
	            	document.getElementById("securePassword").focus();
	            	return;
	            }
	            
	            if (document.getElementById("securePassword").value != document.getElementById("securePasswordCheck").value) {
	            	alert("<spring:message code='ezEmail.lhm62' />");
	            	document.getElementById("securePasswordCheck").focus();
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
		            	alert("<spring:message code='ezEmail.lhm43' />");
		            	return;
		            }
	            }
	            
	            var secureReadCount = null;
	            if (document.getElementById("countUnlimit").checked == false) {
	            	secureReadCount = Number(document.getElementById("maxReadCount").value);
	            	
	            	if (isNaN(secureReadCount) || secureReadCount > 1000 || secureReadCount < 1) {
	            		alert("<spring:message code='ezEmail.lhm60' />");
	            		return;
	            	}
	            }
	            
	            RetValue["securePassword"] = rsa.encrypt(document.getElementById("securePassword").value);
				RetValue["securePasswordHint"] = document.getElementById("securePasswordHint").value;
	            
	            if (document.getElementById("countUnlimit").checked == true) {
	            	RetValue["secureReadCount"] = 0;
	            } else {
	            	RetValue["secureReadCount"] = secureReadCount;
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
	            	document.getElementById("maxReadCount").focus();
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
			
			function digitCheck(event) {
				if ((event.keyCode < 48)||(event.keyCode > 57)) {
					return false;
				}
			}
			
			function cancel() {
		    	if (!isDivPopUp) {
	                window.close();
		    	} else {
	                CancelFunction();
		    	}
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.lhm63' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<span>▒ <spring:message code='ezEmail.lhm39' /></span><br>
		<span>▒ <spring:message code='ezEmail.lhm41' /></span><br>
		<br>
		
		<table style="width:100%;" class="content">
		  <tr>
		    <th><spring:message code='ezEmail.lhm64' /></th>
		    <td><input type="password" id="securePassword" maxlength="20" /></td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezEmail.lhm61' /></th>
		    <td><input type="password" id="securePasswordCheck" maxlength="20" /></td>
		  </tr>
			<tr>
				<th><spring:message code='ezEmail.kdh04' /></th>
				<td><input type="text" id="securePasswordHint" maxlength="20" />
					<p style="margin: 0 0 0 5px; color: #666; font-size: 10px; display: inline-block;"><spring:message code="ezEmail.kdh05"/></p>
				</td>
			</tr>
		  <tr>
		    <th><spring:message code='ezEmail.lhm65' /></th>
		    <td>
		    	<input type="text" id="maxReadCount" maxlength="3" style="width:50px;-webkit-ime-mode:mode:disabled;-moz-ime-mode:mode:disabled;-ms-ime-mode:mode:disabled;ime-mode:disabled;" 
		    		onkeypress="return digitCheck(event)" disabled />
		    	<spring:message code='ezEmail.lhm68' />
		    	<input type="checkbox" id="countUnlimit" onclick="chkMaxReadCount()" checked /><label for="countUnlimit"><spring:message code='ezEmail.lhm67' /></label>
		    </td>
		  </tr>
		  <tr>
		  	<th><spring:message code='ezEmail.lhm66' /></th>
		  	<td>
		  		<input type="text" id="Sdatepicker" style="width:80px;text-align:center" disabled readonly />
		  		<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" disabled /> <spring:message code='ezEmail.lhm37' />
		  		<input type="checkbox" id="dateUnlimit" onclick="chkMaxReadDate()" checked /><label for="dateUnlimit"><spring:message code='ezEmail.lhm67' /></label>
		  	</td>
		  </tr>
		</table>
		
		<div class="btnposition btnpositionNew">
		   <a class="imgbtn" onClick="confirm()" ><span><spring:message code='ezEmail.t38' /></span></a>
		</div>
		
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
	</body>
</html>



