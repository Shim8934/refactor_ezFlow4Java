<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
			window.onload = function () {
				var useragentstr = navigator.userAgent;
				var _MSIE = 'MSIE';
				if (useragentstr.indexOf(_MSIE) == -1) {
					download_attach2()
				}
			}
			function download_attach2() {
<%-- 				document.location.href = "/ezQuetion/qstInterFace.do?TYPE=QUESTION&BOARDID=<%=v_brd_id%>&ITEMID=<%=v_item_no%>&QSTNO=<%=strQuestionNo%>&ANSNO=<%=strAnswer%>&ATTID=<%=strAttID%>"; --%>
			}
		</script>
		<title>Insert title here</title>
	</head>
	<body>

	</body>
</html>