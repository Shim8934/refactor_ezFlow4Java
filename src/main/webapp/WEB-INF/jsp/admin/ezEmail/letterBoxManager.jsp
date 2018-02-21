<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
	    
	    <style>
	    #divBox {
	    	height:350px;
	    	width:250px;
	    	background-color:#f5f6f6;
	    	float:left;
	    }
	    
	    #divInput {
	    	float:left;
	    	width:350px;
	    	height:350px;
	    	margin-left:20px;
	    	position:relative;
	    }
	    
	    </style>
	    
	    <script type="text/javascript">
	    	
	    function addLetterBox() {
	    	alert("편지지함 추가 입니다");
	    }
	    
	    function deleteLetterBox() {
	    	alert("편지지함 삭제 입니다.");
	    }
	    
	    </script>
	</head>
	<body style="height: 95%; overflow:hidden;">
	    <br><div><h3><b>편지지함 관리  · 수정 · 삭제</b></h3></div><br>
	    <div id="mainmenu">
		    <ul class="on">
		        <li><span onclick="addLetterBox()">&nbsp;&nbsp;+ 편지지함 <spring:message code='ezQuestion.t176'/>&nbsp;&nbsp;</span></li>
		        <li><span onclick="deleteLetterBox()">&nbsp;&nbsp;- 편지지함 <spring:message code='ezQuestion.t177'/>&nbsp;&nbsp;</span></li>
		    </ul>
		</div>
		<div id="divBox">
			<!-- 여기에 jstree 넣을 것 -->
		</div>
		<div id="divInput">
			<form action=""><br>
				<b><spring:message code='main.t76'/></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="display" size="30" value="편지지함"><br><br>
				<b><spring:message code='main.t76'/>(<spring:message code='ezSchedule.t4014'/>)</b>&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="display" size="30" value="내용을 입력해주세요"><br>
			
				<div style="position:absolute; bottom:20px; right:50px;"><input type="submit" value=" 확인 "></div>
			</form>
		</div>
	</body>
</html>