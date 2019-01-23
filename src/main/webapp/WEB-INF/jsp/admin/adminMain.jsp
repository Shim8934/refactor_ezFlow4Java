<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<title><spring:message code="ezBoard.t84" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
	</head>
	<script type="text/javascript">
	    function reloadLoginPage(multiLoginFlag, url) {
	    	var frm = "";
	    	
	    	frm = "<form action='" + url + "' method='post' style='display:none;' id='reloadLogin' onsubmit='return false;'>";
	    	if(!!multiLoginFlag) {
	    		frm += "<input type='hidden' name='multiLoginFlag' value='" + multiLoginFlag + "'>";
	    	}
	    	frm += "</form>";
	    	
	    	var wrapper = document.createElement("div");
	    	wrapper.innerHTML = frm;
	    	document.body.appendChild(wrapper);
	    	document.getElementById("reloadLogin").submit();
	    	
	    }
	</script>
	<frameset rows="42,*" border="0" framespacing="0" frameborder="NO">
		<frame src="/admin/top.do" id="topFrame" marginwidth="0" marginheight="0" frameborder="NO" name="top" noresize scrolling="no">
		<frame src="" marginwidth="0" marginheight="0" frameborder="NO" name="bottom" scrolling="auto">
	</frameset>
	<noframes></noframes>
</html>

