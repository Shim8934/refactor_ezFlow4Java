<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezLadder/string_component.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
		
		<script type="text/javascript">
			var retVal;
			var retFunc;
			var poptype = "${popupType}";
			
			$(function() {
				try {
					retVal = parent.retAttendantPopInfo[0];
					retFunc = parent.retAttendantPopInfo[1];
				} catch(e) {
					retVal = opener.retAttendantPopInfo[0]
					retFunc = opener.retAttendantPopInfo[1];
				}
				
				/* if(poptype === "overlap") {
					console.log(retVal);
					var html = "";
					retVal.forEach(function(uservo, index) {
						if(index === 0) {
							html = "<p>" + uservo["name1"];
						} else {
							html += ", " + uservo["name1"];
						}
					});
					$("#usernames").html(html + "</p>");
				} */ // 중복유저 알려주는거??
				
				$("#btn_addRealUser").on("click", function() {
					if(typeof retFunc === "function") {
						retFunc(retVal, "real-xml");
					}
				});
				$("#btn_addAnonyUser").on("click", function() {
					if(typeof retFunc === "function") {
						retFunc(retVal, "anony-xml");
					}
				});
				
				$("#btn_SaveAprLineTempletName").on("click", function() {
					var bmName = $("#TxtAprLineTempletName").val();
					if(retFunc !== null || retFunc !== "") {
						retFunc(bmName, retVal);
					}
				});
				$("#btn_CancelAprLineTempletName").on("click", function() {
					parent.DivPopUpHidden();
				});
			});
		</script>
		
	</head>
	<body class="popup">
			<c:choose>
				<c:when test="${popupType == 'add'}">
					<h1 id="h1Title">사다리 즐겨찾기 그룹 추가</h1>
					<span>▒ 저장할 즐겨찾기 그룹의 이름을 입력하세요.</span>
					<div class="nobox" style="margin-top:10px">
						<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="7">
					</div>
				</c:when>
				<c:when test="${popupType == 'modify'}">
					<h1 id="h1Title">사다리 즐겨찾기 그룹 수정</h1> 
					<span>▒ 수정할 즐겨찾기 그룹의 이름을 입력하세요.</span>
					<div class="nobox" style="margin-top:10px">
						<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="7">
					</div>
				</c:when>
				<c:when test="${popupType == 'delete'}">
					<h1 id="h1Title" style="margin-bottom: 30px;">사다리 즐겨찾기 그룹 삭제</h1>
					<span>▒ 즐겨찾기 그룹을 삭제하시겠습니까?</span>
				</c:when>
				<c:when test="${popupType == 'overlap'}">
					<h1 id="h1Title" style="margin-bottom: 30px;">중복 유저 추가</h1>
					<span>▒ 이미 추가된 유저입니다.</span>
					<!-- <span id="usernames"></span> -->
				</c:when>
				<c:when test="${popupType == 'cmtdelete'}">
					<h1 id="h1Title" style="margin-bottom: 30px;">댓글 삭제</h1>
					<span>▒ 이 댓글을 삭제하시겠습니까?</span>
				</c:when>
			</c:choose>
			
		<div class="btnposition btnpositionNew">
			<c:choose>
				<c:when test="${popupType == 'overlap'}">
					<input type="submit" value="조직도에서 추가" id="btn_addRealUser">
					<input type="submit" value="익명으로 추가" id="btn_addAnonyUser">
					<input type="submit" value="취소" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
				</c:when>
				<c:otherwise>
					<input type="submit" value="확인" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName">
					<input type="submit" value="취소" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
				</c:otherwise>
			</c:choose>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>