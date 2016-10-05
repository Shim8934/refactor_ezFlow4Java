<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>ImagePortlet</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script language="javascript" type="text/javascript">
			var g_ImageType = "${result.imageType}";
		
			function window_onload() {
				// 포틀릿 크기에 맞게 늘리기
				if (g_ImageType == "2") {
					PortletImage.width = document.body.clientWidth;
					PortletImage.height = document.body.clientHeight;
				}
				// 한쪽 방향에 맞게 늘리기 (작은쪽으로)
				else if (g_ImageType == "3") {
					var pWidth = document.body.clientWidth;
					var pHeight = document.body.clientHeight;
				
					if (pWidth >= pHeight) {
						PortletImage.width = pHeight;
						PortletImage.height = pHeight;
					} else if (pWidth < pHeight) {
						PortletImage.width = pWidth;
						PortletImage.height = pWidth;
					}
				}
			}
		
			function OpenURL(pURL, pMode) {
				if (pURL == "") {
					return;
				}
			
				if (pMode == "1") {
					window.open(pURL, "", "${result.windowOption}");
				} else {
					parent.location.href = pURL;
				}
			}
		</script>
	</head>
	<body onload="javascript:window_onload()">
		<img id="PortletImage" src="${result.imagePath}" onclick="OpenURL('${result.maxURL}', '${result.openMode}')" style="cursor:pointer" width="${result.imageWidth}" height="${result.imageHeight}">
	</body>
</html>