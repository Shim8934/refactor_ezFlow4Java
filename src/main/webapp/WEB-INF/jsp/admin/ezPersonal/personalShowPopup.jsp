<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t157' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/popup.css')}">
		
		<style type="text/css">
			P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm }
		    .Line {
		        background: url('/images/kr/cm/popup_bg.gif') repeat-x left top;
		    }
		    .Line h1{
				font-size:11pt;
				font-weight:bold;
				color:#fff;
				height:44px;
				margin-left:15px;
				margin-bottom:8px;
				line-height:36px;
		    }
		</style>
		
		<script type="text/javascript">
			var flag = "<c:out value = '${flag}' />";
			// skinValue 0 ~ 3
			var skinValue = "<c:out value = '${skinValue}' />";
			
			window.onload = function () {
				//setPopupSkin(); 
			}
			
			$(document).ready(function() {
				var popupContent = document.getElementsByClassName("popup_noticeList")[0];
				popupContent.style.height = document.documentElement.clientHeight - 186 + "px";
			});
			
			window.onresize = function(event) {
				var popupContent = document.getElementsByClassName("popup_noticeList")[0];
				popupContent.style.height = document.documentElement.clientHeight - 186 + "px";
			};
	
			function setCookie(name, value, expiredays) {
				var todayDate = new Date();
				todayDate.setDate( todayDate.getDate() + expiredays );
				document.cookie = name + "=" + encodeURIComponent( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
			}
	
			function closepopup() {
				setCookie("POPUP_${itemSeq}_${user}", "1", 1); 
				window.close();
			}
			
			// skinValue 값에 따라 styleSheet 호출
			var setPopupSkin = function() {

				var linkElem = document.createElement('link');
				linkElem.rel = 'stylesheet';
				linkElem.type = 'text/css';
				
				switch (Number(skinValue)) {
					case 0 : 
						linkElem.href = '/css/ezPersonal/type1.css';
						break;
					case 1 :
						linkElem.href = '/css/ezPersonal/type2.css';
						break;
					case 2 : 
						linkElem.href = '/css/ezPersonal/type3.css';
						break;
					case 3 : 
						linkElem.href = '/css/ezPersonal/type4.css';
						break;
				}
				
				document.getElementsByTagName('head')[0].appendChild(linkElem);
			}
		</script>
		
	</head>
	<body class = "popup_notice popup_type${skinValue}">
		<!--  popup 해더 사이즈 : 33px;	bottom 사이즈 : 49px;본문 내용 위아래 여백 : 54px;	총 height 사이즈 : 136px; -->
		<form style="height:100%;">
		<div class="popup_noticeLayout">
			<dl class="popup_noticeTitle">
				<dt class="title_type${skinValue}"></dt>
				<dd class="name_type${skinValue }"><c:out value='${title }'/></dd>
			</dl>
			<div class='popup_noticeList'>${content }</div>
				<c:if test = "${flag ne 'preview' }" >
					<div class="notice_btn">
						<p class="btn_checkbox">
							<input type="checkbox" name="checkbox" class="inp_noticeCheck" id="inp_noticeCheck" onClick="closepopup()" /> 
							<label class="name_type${skinValue }" for="inp_noticeCheck"><spring:message code = 'ezPersonal.t267' /></label></p>
						<p class="notice_btnClose close_type${skinValue}"><span onclick=window.close() ></span></p>
						</div>
				</c:if> 
		</div>
		</form>
		<!--  //popup -->
	</body>
</html>