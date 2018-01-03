<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" >        		    
		    window.onload = function () {

		        
		    };		    
	    </script>
	</head>
	<body class="mainbody">
	   <h1><spring:message code='ezWebFolder.t102' /></h1>
	   <div id="companySelect" style="margin: 10px 10px;">
	   		<span style="font-size: 16px;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 14px;">
	   			<option>가온아이</option>
	   			<option>리딩</option>
	   			<option>아추 저죽은행</option>
	   			<option>테스트1</option>
	   			<option>테스트2</option>
	   		</select>
	   </div>
	   
	   <div id="mainSetting" style="margin: 10px 10px;">
		   <table class="content">
		   		<tr style="height: 40px;">
		   			<th>총용량</th>
		   			<th>
		   				<input type="text" style="height: 30px;" />
		   				<span>GB</span>
		   			</th>
		   		</tr>
		   </table>
	   </div>
	   <div style="margin: 10px 70px;">
		   <a class="imgbtn"><span onclick="">저장</span></a>
		   <a class="imgbtn"><span onclick="">취소</span></a>
	   </div>
	</body>
</html>