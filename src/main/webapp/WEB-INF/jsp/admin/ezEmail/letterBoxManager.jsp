<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
	    <link rel="stylesheet" href="/css/ezEmail/style.css" />
	    <link rel="stylesheet" href="/js/dist/themes/default/style.min.css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script src="/js/dist/jstree.min.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterBoxTree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterList.js"></script>
	    
	</head>
	<body style="height: 95%; overflow:hidden;">
	    <h5 style="padding: 10px 1px;">편지지함 관리  · 수정 · 삭제</h5>
	    <div id="mainmenu">
		    <ul class="on">
		        <li><span onclick="addLetterBox()">&nbsp;&nbsp;+ 편지지함 <spring:message code='ezQuestion.t176'/>&nbsp;&nbsp;</span></li>
		        <li><span onclick="deleteLetterBox()">&nbsp;&nbsp;- 편지지함 <spring:message code='ezQuestion.t177'/>&nbsp;&nbsp;</span></li>
		    </ul>
		</div>
		<div id="divTree" class="myScrollableBlock">
		</div>
		<div id="divInput">
			<form id="myForm" action="/admin/ezEmail/updateLetterBox.do" method="post">
				<label for="display">
					<b><spring:message code='main.t76'/></b>
				</label>
				<input type="text" id="display" name="displayname" size="30" maxlength="40">
				
				<br><br>
				
				<label for="display2">
					<b><spring:message code='main.t76'/>(<spring:message code='ezSchedule.t4014'/>)</b>
				</label>
				<input type="text" id="display2" name="displayname2" size="30" maxlength="40">
				
				<br>
				
				<input type="hidden" id="letterbox_no" name="letterBoxNo">
				<input type="hidden" id="parent_letterbox_no" name="parentLetterBoxNo">
				<input type="hidden" id="company_id" name="companyID" value="${companyId}">
				
				<div class="divInputBtn">
					<input type="button" id="submitBtn" onclick="submitClick()" value=" 확인 ">
				</div>
			</form>
		</div>
		
		<script type="text/javascript">
		    var result = [];
		    var letter_displayname;
		    var letter_displayname2;
		    var treeCollection = [];
		    var xmlhttp;
		    var responseResult;
		    var selectNode;
		    var addCheck = 0;
		    var pageType = "${pageType}";
		    var returnCompany = '${companyId}';
		    
		    window.onload = window_onload;
		    
		    function window_onload() {
		    	resultRead();
		    }
		    
		    // 이름, 이름(영문)뿌려주는애
		    function setDisplay(letter_displayname, letter_displayname2) {
		    	document.getElementById("display").value = letter_displayname;
		    	document.getElementById("display2").value = letter_displayname2;
		    }
	    
	    </script>
	</body>
</html>