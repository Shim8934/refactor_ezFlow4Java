<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
        <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>        
		<title><spring:message code='ezSchedule.jjh01'/></title>
		<script>
			var optionStr = "";
		    var ReturnFunction;
	
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.schedule_delete_confirm_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.schedule_delete_confirm_cross_dialogArguments[1];
		            } catch (e) {}
		        }
		    }
		    
		    function Schedule_Confirm(id) {
		        if (radio1.checked) {
		            optionStr = "0";
		        } else {
		            optionStr = "1";
		        }
		        
		        if (ReturnFunction != null)
		            ReturnFunction(optionStr);
		        else
		            window.retutnValue = optionStr;
		        window.close();
		    }
	
		    function Scehdule_Close() {
		        if (ReturnFunction != null)
		            ReturnFunction("2");
		        else
		            window.retutnValue = "2";
		        window.close();
		    }
		</script>
	</head>
	
	<body class="popup">
		<h1><spring:message code='ezSchedule.jjh01'/></h1>
		<table class="content" style="width:100%">
			<tr>
		    	<td colspan="3">
		    		<input type="radio" id="radio1" name="radiobutton" value="radiobutton"  checked>
		      		<spring:message code='ezSchedule.jjh02'/>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td colspan="3">
		    		<input type="radio" id="radio2" name="radiobutton" value="radiobutton" >
		      		<spring:message code='ezSchedule.jjh03'/>
		      	</td>
		  	</tr>  
		</table>
		<div class="btnposition">
		    <a class="imgbtn" id="ContactOutButton" onClick="Schedule_Confirm()" ><span><spring:message code='ezSchedule.t215'/></span></a>
		    <a class="imgbtn" id="ContactOutButtonExit" onClick="Scehdule_Close()" ><span><spring:message code='ezSchedule.t5'/></span></a>
		</div>
	</body>
</html>