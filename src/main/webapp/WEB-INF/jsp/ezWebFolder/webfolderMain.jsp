<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
        var folderType = "<c:out value='${folderType}'/>";
        window.onload = function () {
            if (folderType == "") {
                folderType = "C"
            }
            var url = "/ezWebFolder/webfolderLeft.do?folderType=" + folderType;
            document.getElementById("left").src = url;
        }
	</script>
</head>
<body>
<iframe id="left" class="fold" src="" name="left"
		style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>
