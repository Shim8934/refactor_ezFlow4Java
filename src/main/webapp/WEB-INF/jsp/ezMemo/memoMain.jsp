<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<title>memo</title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezMemo.c1', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	</head>
	
	<style>
		h1 {
			font-size:13px;margin:0px 0px 10px 0px;height:24px; line-height:15px; padding:0px; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
		}
		.individual-memo { 
			width:200px; height:200px; 
			background-color:#0470e4; 
			text-align:left; border:1px solid black; float: left; 
			margin: 10px 25px 10px 25px; overflow:hidden; 
			padding-top:5px; position:relative; 
		}
		.memo-text {
			margin-top:10px; padding-left:11px; padding-right: 25px; padding-bottom:5px; 
			border:0px; width:100%; height:81%; resize:none; 
			overflow-y:scroll; font-family:Malgun Gothic, Gulim, Dotum, Arial, Helvetica, sans-serif;
		}
	</style>
	
	<body class="mainbody" style="overflow: hidden;" marginwidth="0" marginheight="0">
		<h1><spring:message code='ezMemo.t001'/><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
		  <ul>
		        <li><span onClick=""><spring:message code='ezMemo.t0013'/></span></li>
		        <li><span onclick=""><spring:message code='ezMemo.t0014'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0015'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0016'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0022'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0017'/></span></li>
		        <li><span onClick=""><spring:message code='ezMemo.t0018'/></span></li> 
		        <li>
		        	<select id="memoType" style="height: 20px;" onchange="">
                           <option value="0"><spring:message code='ezMemo.t0019'/></option>
                           <option value="1"><spring:message code='ezMemo.t0020'/></option>
                           <option value="2"><spring:message code='ezMemo.t0021'/></option>
                    </select>    
		        </li>
		  </ul>
		</div>
		<div style="width:100%; overflow: hidden;">
 		 	<table class="mainlist" style="width:100%;">
 		 		<div style="width:100%; border-bottom: 1px solid #e8e8e8;"></div>
 		 		<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
 		 			<input type="checkbox" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
	 		 		<span class="write-date">2018-08-16 (목)</span>
	 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
	 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
	 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
	 		 	</div>
	 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
 		 			<input type="checkbox" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
	 		 		<span class="write-date">2018-08-16 (목)</span>
	 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
	 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
	 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
	 		 	</div>
	 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
 		 			<input type="checkbox" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
	 		 		<span class="write-date">2018-08-16 (목)</span>
	 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
	 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
	 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
	 		 	</div>
	 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
 		 			<input type="checkbox" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
	 		 		<span class="write-date">2018-08-16 (목)</span>
	 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
	 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
	 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
	 		 	</div>
	 		 	<div class="individual-memo" style="background-color:rgb(52, 152, 219)">
 		 			<input type="checkbox" style="width: 20px; height: 20px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; vertical-align:middle; margin-left: 10px;">
	 		 		<span class="write-date">2018-08-16 (목)</span>
	 		 		<img src="/images/close_xBtn.png" style="visibility: hidden; float: right; height: 20px; padding-right: 5px; cursor: pointer;">
	 		 		<img src="/images/ezMemo/more.png" style="visibility: hidden; float: right; height: 20px; padding-right: 10px; cursor: pointer;">
	 		 		<textarea class="memo-text" style="background-color:rgb(159, 212, 246)"></textarea>
	 		 	</div>
 		 	</table>
 		 </div>
	</body>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
</html>