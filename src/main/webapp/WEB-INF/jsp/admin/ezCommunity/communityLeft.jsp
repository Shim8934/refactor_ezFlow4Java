<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title>left</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	
	<script type="text/javascript">
	document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
		};
		
		function goPage(idx)
		{
			var url = "";
			switch(idx)
			{
				case 1:
					url = "/admin/ezCommunity/bbsList.do?bName=c_board";
					break;
				case 2:
					url ="/admin/ezCommunity/searchKey.do?sRadio=C_ClubName&keyword=&key&pDivi=admin";
					break;
				case 3:
					url = "/admin/ezCommunity/closeCom.do";
					break;
				case 4:
					url = "/admin/ezCommunity/admitCom.do" ;
					break;
			}				
			window.open(url,"comm_main");
		}
	</script>
	</head>
	<body class="leftbody"> 
		<div id="left">
			<div class="left_admin" title="Community"><spring:message code = 'ezCommunity.t1529' /></div>
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(1)"><spring:message code = 'ezCommunity.t2001' /></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(2)"><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t31' /></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(3)"><spring:message code = 'ezCommunity.t39' /></span><ul></ul></h2>	
			<h2><span style="display:inline-block;width:100%;" onClick="goPage(4)"><spring:message code = 'ezCommunity.t25' /></span><ul></ul></h2>			
		</div>
		
		<script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>