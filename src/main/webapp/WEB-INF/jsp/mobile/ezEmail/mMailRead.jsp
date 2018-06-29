<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="btn">
		<button id="back_to_list" onclick="clickcr(this,'rtp.mailbox','','',event);mRead.backToList($Event(event));" class="tx prev"><em></em><span>전체메일</span></button>
	</div>
	<div id="sendbox_header">
		<span class="detatil" onclick="">상세열기</span>
	</div>
	<div class="subject" id="read_title_div">
	<p class="txt"></p>
	<p class="date"></p>
	</div>
	<div class="content" id="read_content_div"></div>
</body>
</html>