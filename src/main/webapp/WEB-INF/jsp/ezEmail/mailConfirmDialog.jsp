<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title>${caption}</title>
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript">
	        var ReturnFunction;
	        window.onload = function () {
	            try {
	                ReturnFunction = parent.mail_message_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.mail_message_cross_dialogArguments[1];
	                } catch (e) { }
	            }
	        }
	        function Button_Onclick(obj) {
	            var ReturnValue = obj.getAttribute("id");
	            if (ReturnFunction != null) {
	                ReturnFunction(ReturnValue);
	            }
	            else {
	                window.returnValue = ReturnValue;
	                window.close()
	            }
	        }
		</script>
		
	</head>
	<body style="overflow:hidden;"> 
	<div class="popup_noti">
		<div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content">
	       <div  style="padding:10px;">
	      <table>
	        <tr>
	          <td  class="cimg"></td>
	          <td  class="ctxt" ><span id="LabelMessage">${message}</span></td>
	        </tr>
	      </table>
	 	</div>
	    </div>
	<div class="popup_noti_btnarea"> 
	    <div class="btnposition"> 	                 
	        <input type='button' id='0' style='' value='${buttonName0}' onclick='Button_Onclick(this)'> 	                   
	        <input type='button' id='1' style='' value='${buttonName1}' onclick='Button_Onclick(this)'> 	                   
	        <input type='button' id='2' style='' value='${buttonName2}' onclick='Button_Onclick(this)'> 	                   
	    </div>
	<span class="bl"> </span> <span class="br"></span></div>
	</div>
	</body>	
</html>