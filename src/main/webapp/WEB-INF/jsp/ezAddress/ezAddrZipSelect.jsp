<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezAddress.t2" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var ReturnFunction;
		    var isDivPopup = false;
		    
		    $(document).ready(function(){
		    	document.getElementById('dong').focus();
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("dong"));
		            }
		        }catch (e){ }
		        
		        try {
		            ReturnFunction = parent.address_zip_select_dialogArguments[1];
		            isDivPopup = true;
		        }catch (e) {
		            try {
		                ReturnFunction = opener.address_zip_select_dialogArguments[1];
		            } catch (e) {}
		        }
		    });
		    function KeEventControl(obj) {
				useragt = navigator.userAgent.toUpperCase();
		        //사파리 브라우저일 경우
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0){
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function (){
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126){
		                return false;
		            }
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32){
		                return false;
		            }
		        };
		    }
			function cancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction();
		            
		            if (!isDivPopup){
		                window.close();
		            }
		        }else{
		            window.close();
		        }
		    }
			function sendit() {
	            if (document.getElementById("dong").value == "") {
	                alert("<spring:message code='ezAddress.t369' />");
			    	return;
	            }			
	        	document.getElementById("ifrmAddrResult").src = "/ezAddress/address_zip_iframe.do?dong=" + encodeURI(document.getElementById("dong").value);
	    	}
			function dong_onkeydown() {
		        if (event.keyCode == 13) {
		            event.returnValue = false;
		            sendit();
		        }
		    }
			function Row_onClick(vThis) {
		        if (vThis) {
		            var para = new Array();
		            if (CrossYN()) {
		                para[0] = GetChildNodes(vThis)[0].textContent;
		                para[1] = GetChildNodes(vThis)[1].textContent;
		                para[2] = GetChildNodes(vThis)[2].textContent;
		                para[3] = GetChildNodes(vThis)[3].textContent;
		                para[4] = GetChildNodes(vThis)[4].textContent;
		            }
		            else {
		                para[0] = GetChildNodes(vThis)[1].innerText;
		                para[1] = GetChildNodes(vThis)[2].innerText;
		                para[2] = GetChildNodes(vThis)[3].innerText;
		                para[3] = GetChildNodes(vThis)[4].innerText;
		                para[4] = GetChildNodes(vThis)[5].innerText;
		            }
		            if (ReturnFunction != null) {
		                ReturnFunction(para);
		                if (!isDivPopup)
		                    window.close();
		            }
		            else {
		                window.returnValue = para;
		                window.close();
		            }

		        }
		    }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezAddress.t2' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="cancel_onclick()"><spring:message code='ezAddress.t5' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>	    
	    <c:if test="${lang != '3'}">
		    <div class="txt">
		        <spring:message code='ezAddress.t6' />
		    </div>
	    </c:if>
	    <table class="content">
	        <tr>
	            <td align="center">
	                <input id="dong" name="dong" size="20" maxlength="20" onkeydown="return dong_onkeydown()" />
	                <a class="imgbtn"><span onclick="return sendit()"><spring:message code='ezAddress.t8' /></span></a>
	                <a class="imgbtn"><span onclick="return cancel_onclick()"><spring:message code='ezAddress.t11' /></span></a>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding: 3px; padding-right: 0; padding-bottom: 0">
	                <iframe id="ifrmAddrResult" width="620" height="224" scrolling="no" frameborder="0" marginheight="0" marginwidth="0"></iframe>
	            </td>
	        </tr>
	    </table>
	</body>
</html>