<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>mail_list</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" type="text/css" href="/css/default_kr.css"> 
	<link rel="stylesheet" type="text/css" href="/css/previewmail.css">
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezEmail/lang/ezEmail_ko.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/ezEmail/js/NewMailList.js"></script>
	<script type="text/javascript" src="/js/ezEmail/js/Newemail.js"></script>
	<script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
	<script type="text/javascript" src="/js/Common.js"></script>
	<script type="text/javascript" src="/js/NameControl.js"></script>	
</head>
<body style="overflow:hidden;" id="theBody" class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);"  onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
	<h1>받은 편지함<span id="mailBoxInfo"></span>
      <span style="float:right;font-weight:normal;color:black;">
          <input name="searchCheck" id="Radio1" type="radio" value="SUBJECT" checked style="margin:0px;padding:0px;width:13px;height:13px;">제목
		  <input name="searchCheck" id="Radio3" type="radio" value="FROM" style="margin:0px;padding:0px;width:13px;height:13px;">보낸 사람
		  &nbsp;
		  <input name="keyword" class="Mail_Input" style="width:150px;ime-mode: active;" onKeyPress="onkeydown_start_search(event);"  onmousedown="keyword_Clear();" /> 
          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" align="absmiddle" onClick="start_search()"></a>
      </span>
    </h1>	
</body>
</html>