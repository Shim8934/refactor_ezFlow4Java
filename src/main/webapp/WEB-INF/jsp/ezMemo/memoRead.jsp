<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('ezMemo.c1', 'msg')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<title></title>
</head>
<script>
			function close_onclick() {
				// delete_flag 변경 후 창 닫기
				   window.close();
			}
			
			window.onbeforeunload = function() {
				// 창 닫을 때 값 저장
			}
</script>
<body class="popup" style="overflow:hidden">
		<div id="menu">
			<ul>
		      <li>
		      	<span onClick=""><spring:message code='ezMemo.t0015'/></span>
		      </li>
		    </ul>
		 </div>
		 <div id="close">
		    <ul>
		      <li><span onClick="close_onclick()"></span></li>
		    </ul>
		 </div>
		  <script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		  </script>
		<table class="content">
			<textarea style="margin: 0px; width: 320px; height: 430px; resize: none;"></textarea>
		</table>
</body>
</html>