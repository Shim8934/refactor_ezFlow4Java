<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>attitudeConfig</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">
	        $(document).ready(function(){
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezPersonal.t106' />");
		        } else {
		            document.getElementById("ListCompany").selectedIndex = 0;
		            company_change();
		        }
	        });
	    </script>
	</head>
	<body class="mainbody">
	    <h1>근태 규율 관리</h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none">
				<span><b>회사선택</b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<option>회사</option>
	      		</select>
	      		</li>
	      		<li><span onclick="save_config()">저장</span></li>
	      	</ul>
	  	</div>
	        <iframe id = "MailEnv_ifrm" style ="width:100%;height:100%;" frameborder="0" ></iframe>
	</body>
</html>
