<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/reform/designProcessor.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style type="text/css">
.tbl_type {
	border: 0
}

.tbl_type {
	width: 100%;
	border-bottom: 1px solid #dddee2;
	font-family: '돋움', dotum;
	font-size: 12px;
	table-layout: fixed
}

#prop_select_value {
	font-family: Courier New, Helvetica, sans-serif;
	font-size: 14px;
	border: 1px solid #999;
	color: #333;
}

input, textarea {
	ime-mode: inactive;
}
</style>
<script type="text/javascript">
	var args = window.opener.argsForDialog;
	var selectValueList = args.selectValueList;
	var completionHandlerForDialog = args.completionHandlerForDialog;
	var returnValue = null; 
	
	function onLoadHandler() {
		var controlElement = document.getElementById("prop_select_value");
		var valueStr = selectValueList.join("\n");
		controlElement.value = valueStr;
	}

	function btnOK_onclick() {
		var controlElement = document.getElementById("prop_select_value");
		
		returnValue = controlElement.value;
		
		window.close();
	}

	function btncancel_onclick() {
		window.close();
	}

	window.onunload = function() {
		completionHandlerForDialog(returnValue);
	};
</script>
</head>
<body class="popup" onload="onLoadHandler()">
	<div class="popup_wrap" style="width: 100%; height: 100%; top: 0px; left: 0px; overflow: hidden;">
		<div class="popup_reform">
			<h1>값설정</h1>
			<div class="contents">
				<div id="directive_message">항목을 한 줄씩 입력하세요.</div>
				<textarea id="prop_select_value" class="textarea"></textarea>
				<!-- 버튼영역 -->
				<div class="btn_area">
					<a href="#" class="btn_type3" onclick="btnOK_onclick()">
						<span><strong>확인</strong></span>
					</a>
					<a href="#" class="btn_type3" onclick="btncancel_onclick()">
						<span>취소</span>
					</a>
				</div>
				<!--// 버튼영역 -->
			</div>
		</div>
		<div class="popup_shadow"></div>
	</div>
</body>
</html>
