<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	p {
		margin-top: 0px;
		margin-bottom: 0px;
	}
</style>
</head>
<body>
	<div style="text-align: left;">
		<img onclick="parent.Smaller();" style="cursor: pointer; margin: 5px;" src="/images/minus.png"> 
		<img onclick="parent.Bigger();" style="cursor: pointer; margin: 5px; margin-left: -9px;" src="/images/plus.png">
	</div>
	<div id="journalContent" class="txtContent" style="width: 100%; height: 10px; display: inline-block;">
		${journalContent }
	</div>
</body>
</html>