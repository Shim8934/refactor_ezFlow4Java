<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Portlet Setting</title>
<link href="${util.addVer('main.e15', 'msg')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript">
$(function() {
	$("#closeBtn").on("click", popupClose);
});

function popupClose() {
	parent.DivPopUpHidden();
	window.close();
}

</script>
</head>
<body>
<div id="close">
	<ul>
		<li><span id="closeBtn"></span></li>
	</ul>
</div>
</body>
</html>