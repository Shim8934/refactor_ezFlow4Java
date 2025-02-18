<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style>iframe { margin-top: 10px; width: 100%; border: none; }</style>
<title></title>
</head>
<body class="mainbody" style="height:80vh">
	<h1><spring:message code='ezPersonal.noti.title' /></h1>
	<div class="portlet_tabpart01" style="margin-top: 3px; text-align: right">
		<div class="portlet_tabpart01_top">
			<p><span class="tabon" data-target="#item_content"><spring:message code='ezPersonal.noti.title' /></span></p>
			<p><span data-target="#preferences_content"><spring:message code='ezPersonal.noti.tab.preference' /></span></p>
		</div>
	</div>
	<div id="item_content"style="height:100%;">
		<iframe src="notificationItemTab.do" style="height:100%;"></iframe>
	</div>
	<div id="preferences_content" style="display: none;">
		<iframe style="height:200px;" src="notificationPreferenceTab.do"></iframe>
	</div>
	<script>
		Array.prototype.slice.call(document.querySelectorAll(".portlet_tabpart01_top span")).forEach(function(el) {
			el.addEventListener("mouseover", function() { if (this.className.indexOf("tabon") < 0) this.className = "tabover"; });
			el.addEventListener("mouseout", function() { if (this.className.indexOf("tabon") < 0) this.className = ""; });

			el.addEventListener("click", function() {
				if (this.className.indexOf("tabon") > -1) return;

				var previousTab = document.querySelector(".tabon");
				var previousContent = document.querySelector(previousTab.getAttribute("data-target"));

				previousContent.style.display = "none";
				document.querySelector(this.getAttribute("data-target")).style.display = "";

				previousTab.className = "";
				this.className = "tabon";

				// 이전 탭 리로드로 데이터 초기화
				previousContent.querySelector("iframe").contentWindow.location.reload();
			});
		});
	</script>
</body>
</html>