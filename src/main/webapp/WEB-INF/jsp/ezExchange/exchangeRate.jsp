<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<title><spring:message code='ezPortal.pjg11'/></title>
	</head>
	<style>
		.popup{overflow:scroll; -ms-overflow-style: scroll; overflow-x: auto; overflow-x:hidden; background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top; padding: 5px 10px 10px; margin: 0;}
		th {font-size:12px; text-overflow: ellipsis; white-space: nowrap;}
		div {display: block;}
		#menu {display: block; padding-left: 0px; height: 28px; margin-bottom: 15px; margin-top: 3px; vertical-align: middle; padding-bottom:10px;}
		#close{position: absolute; right: 10px; top: 8px; height: 35px; z-index: 1000;}
		#close ul {margin: 0; padding: 0; list-style:none;}
		#close ul li span{overflow:hidden; display: inline-block; width: 25px; height: 28px; background-image: url(/images/close_xBtn.png); background-repeat: no-repeat; background-position: 4px 6px;}
		#exchangeList{width:100%; min-width:400px; table-layout:fixed; border:1px solid #eaeaea; font-family:Gulim, Verdana, Arial, Helvetica, sans-serif;font-size:12px; border-spacing:0; border-collapse:collapse;}
		#exchangeList #title{background-color: #f8f8fa;}
		#exchangeList tr, th, td{border-bottom: 1px solid #f6f6f6; text-align:center; height: 31px; overflow:hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 85%;}
	</style>
	<body class="popup">
	<div id="normalScreen">
	<div id="menu" style="width:730px"></div>
	<div id="close"><ul><li><span onclick="window.close()"></span></li></ul></div>
	<table id="exchangeList">
			<tr id="title">
				<th>조회결과</th>
				<th>전신환 받을때</th>
				<th>전신환 보낼때</th>
				<th>10일환가료율 </th>
				<th>통화코드</th>
				<th>장부가격</th>
				<th>매매기준율</th>
				<th>국가/통화명</th>
				<th>서울외국환중계장부가격</th>
				<th>년환가료율</th>
				<th>서울외국환중계매매기준율 </th>
			</tr>
		<c:forEach var="i" begin="0" end="20">
			<tr>
				<c:forEach var="entry" items="${json[i]}">
					<td>${entry.value}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</table>
	</div>
	</body>
</html>