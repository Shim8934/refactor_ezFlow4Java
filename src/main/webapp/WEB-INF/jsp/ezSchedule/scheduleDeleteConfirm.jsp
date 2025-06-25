<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>        
		<title><spring:message code='ezSchedule.jjh01'/></title>
		<script>
			var optionStr = new Array();
			var ResourceInfo = "<c:out value='${resourceInfo}' />";	
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
		    	if (confirm("<spring:message code='ezSchedule.t209' />")) {
			        var ResourceDel = "FALSE";
			        if (radio1.checked) {
			            optionStr[0] = "0";
			        } else {
			            optionStr[0] = "1";
				        /* 2018-12-17 김민성 - 부모창에서 confirm창 뜨도록 변경 */
			            if (ResourceInfo != "0") {
			                confirm("<spring:message code='ezSchedule.t1300' />") ? ResourceDel = "TRUE" : ResourceDel = "FALSE";
			            }
			        }
			        
		            
		            optionStr[1] = ResourceDel; 
			        
			        if (ReturnFunction != null)
			            ReturnFunction(optionStr);
			        else
			            window.retutnValue = optionStr;
		        	window.close();
		    	} else {
		    		return;
		    	}
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
		<div id="close">
	  		<ul>
          		<li><span onclick="Scehdule_Close()"></span></li>
        	</ul>
	  	</div>
		<table class="content" style="width:100%">
			<tr>
		    	<td colspan="3">
		    		<div class="custom_radio">
			    		<input type="radio" id="radio1" name="radiobutton" value="radiobutton"  checked>
		    		</div>
		      		<label for="radio1"><spring:message code='ezSchedule.jjh02'/></label>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td colspan="3">
		    		<div class="custom_radio">
			    		<input type="radio" id="radio2" name="radiobutton" value="radiobutton" >
		    		</div>
		      		<label for="radio2"><spring:message code='ezSchedule.jjh03'/></label>
		      	</td>
		  	</tr>  
		</table>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="ContactOutButton" onClick="Schedule_Confirm()" ><span><spring:message code='ezSchedule.t215'/></span></a>
		</div>
	</body>
</html>