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
			
			$(function() {
				try {
					retVal = parent.retBmGroupInfo[0];
					retFunc = parent.retBmGroupInfo[1];
				} catch(e) {
					retVal = opener.retBmGroupInfo[0]
					retFunc = opener.retBmGroupInfo[1];
				}
				
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
		<h1 id="h1Title">
			<c:choose>
				<c:when test="${popupType == 'addBmGroup'}">
					사다리 즐겨찾기 그룹 추가
				</c:when>
			</c:choose>
		</h1>
		<span>▒ 저장할 즐겨찾기 그룹의 이름을 입력하세요.</span>
		<div class="nobox" style="margin-top:10px">
		<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="7">
		</div>		
			
		<div class="btnposition btnpositionNew">
		<input type="submit" value="확인" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName">
		<input type="submit" value="취소" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>