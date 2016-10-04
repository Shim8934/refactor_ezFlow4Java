<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t228" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var ReturnFunction;
			
			$(document).ready(function(){
				try {
	                ReturnFunction = opener.inputpassword_dialogArguments[1];
	            } catch (e) {}     
			});		
			
			function OK_Click(){
				if (NewPassword.value == ""){
					alert("<spring:message code='ezOrgan.t229' />");
					return;
				}
				if (NewPassword.value != ConfirmPassword.value){
					alert("<spring:message code='ezOrgan.t230' />");
					return;
				}
			    if(ReturnFunction != null){
			        ReturnFunction(NewPassword.value);
			    }else{
			        window.returnValue = NewPassword.value;
			    }
				window.close();
			}
	    </script>
	</head>
	<body class="popup">
		<h1><spring:message code="ezOrgan.t231" /></h1>
		  <table class="content"> 
		  <tr> 
		    <th><spring:message code="ezOrgan.t232" /></th>
		    <td><input id=NewPassword type=password style="width:98%"></td>
		  </tr>        
		  <tr> 
		    <th><spring:message code="ezOrgan.t233" /></th>
		    <td><input id=ConfirmPassword type=password style="width:98%"></td>
		  </tr>        
		</table>
		  <div class="btnposition">
		    <a class="imgbtn" onClick="OK_Click()"><span><spring:message code="ezOrgan.t124" /></span></a>
		    <a class="imgbtn" onClick="window.close()"><span><spring:message code="ezOrgan.t125" /></span></a>
		</div>
	</body>
</html>