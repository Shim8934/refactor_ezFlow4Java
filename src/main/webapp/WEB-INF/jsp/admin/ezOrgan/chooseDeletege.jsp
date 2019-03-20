<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t00008' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript">
		var ReturnFunction;
		var data1 = window.opener.testObj.dataList;
		var data2 = window.opener.testObj.dataList2;
		var data3 = window.opener.testObj.dataList3;
		var data4 = window.opener.testObj.dataList4;
		var type = "<c:out value='${type}'/>";

		function Schedule_Confirm(id) {
			
			if(radio1.checked) {
				ReturnFunction = "MODE";
			} else {
				ReturnFunction = "ALL";
			}
			
			var cData = "";
			if (ReturnFunction == "ALL") {
				cData = "<spring:message code='ezAddress.t362' />" + strLang20;
			} else {
				cData = type + " " + strLang20;
			}
			
			var checked = (confirm(cData));
			
			if(checked == true) {
			// 권한 전체삭제
			try {
				window.opener.Permissions_Del(ReturnFunction);
			} catch (e) {}
			end_confirm();
		}
	}
		//팝업창 닫기
		function end_confirm() {
			window.close();
		}
				
	    </script>
	</head>
	<body class="popup">
	<h1><spring:message code='ezOrgan.t00008' /></h1>
		<div id="close">
	  		<ul>
          		<li><span onclick="end_confirm()"></span></li>
        	</ul>
	  	</div>
	  	<!-- <table class="contentList" id="contentList" style="width:100%;">
	  		<th>이름</th>
	  		<th>부서</th>
	  	</table> -->
		<table class="content" style="width:100%">
			<tr>
		    	<td>
		    		<input type="radio" id="radio1" name="radiobutton" value="radiobutton"  checked>
		      		<label for="radio1"><spring:message code='ezOrgan.mse6' arguments='${type}' /></label>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td>
		    		<input type="radio" id="radio2" name="radiobutton" value="radiobutton" >
		      		<label for="radio2"><spring:message code='ezOrgan.mse7' /></label>
		      	</td>
		  	</tr>  
		</table>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="ContactOutButton" onClick="Schedule_Confirm()" ><span><spring:message code='ezOrgan.t142' /></span></a>
		</div> 
	</body>
</html>