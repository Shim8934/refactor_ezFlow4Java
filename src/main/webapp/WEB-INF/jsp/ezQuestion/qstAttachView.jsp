<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezQuestion.t178' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
			window.onload = function () {
				var useragentstr = navigator.userAgent;
				var _MSIE = 'MSIE';
				if (useragentstr.indexOf(_MSIE) == -1) {
					download_attach();
				}
			}
			
			var type = "<c:out value='${qstAttachVO.attachType}'/>";
			var href = "<c:out value='${qstAttachVO.attachUrl}'/>";
			var title = "<c:out value='${title}'/>";
			var v_brd_id = "<c:out value='${qstAttachVO.brdID}'/>";
			var v_item_no = "<c:out value='${qstAttachVO.itemNo}'/>";
			var strQuestionNo = "<c:out value='${qstAttachVO.questionNo}'/>";
			var strAnswer = "<c:out value='${qstAttachVO.answerNo}'/>";
			var strAttID = "<c:out value='${qstAttachVO.attachNo}'/>";
			
			var useragentstr = navigator.userAgent;
		    var _MSIE = 'MSIE';
		
		    if (useragentstr.indexOf(_MSIE) != -1) {
		        ezQuestion_ActiveX(_href, type);
		    } else {
		        document.getElementById("Content2").style.margin = "10px 10px 10px 10px";
		        document.getElementById("Content2").innerHTML = "<b>" + '<spring:message code="ezQuestion.t564" />' + "</br>" + '<spring:message code="ezQuestion.t565" />' + " <a href = '#'><span onclick=\"download_attach();\">" + '<spring:message code="ezQuestion.t567" />' + "</span></a>" + '<spring:message code="ezQuestion.t568" />' + "</b>";
		        document.getElementById("Content").style.display = "none";
		        document.getElementById("download_att").style.display = "none";
		    }
		    
		    function download_attach() {
		        document.location.href = "/ezQuestion/getPollAttachInfo.do?type=QUESTION&boardID="+v_brd_id+"&itemID="+v_item_no+"&qstNo="+strQuestionNo+"&ansNo="+strAnswer+"&attID="+strAttID+"";
		    }
		</script>
	</head>
		<c:choose >
			<c:when test="${qstAttachVO.attachType==1}">
				<script type="text/javascript">
						window.onload = function(){
							var width = imgView.width;
							var height = imgView.height;
							if (width < 1024 && height < 768) {
								window.resizeTo(width + 30, height + 65);
							}
							var useragentstr = navigator.userAgent;
							download_attach();
						}
						function download_attach() {
							document.location.href = "/ezQuestion/getPollAttachInfo.do?type=QUESTION&boardID="+v_brd_id+"&itemID="+v_item_no+"&qstNo="+strQuestionNo+"&ansNo="+strAnswer+"&attID="+strAttID+"";
						}
				</script>
				<body onclick="window.close()" style="cursor:pointer">
					<img id="imgView" src="/ezQuestion/getPollAttachInfo.do?type=QUESTION&boardID=${qstAttachVO.brdID}&itemID=${qstAttachVO.itemNo}&qstNo=${qstAttachVO.questionNo}&ansNo=${qstAttachVO.answerNo}&attID=${qstAttachVO.attachNo}" border="0">
					
			</c:when>
			<c:otherwise>
				<body class="popup">
					<h1>title</h1>
					<div id="close">
					  <ul>
					    <li><span onclick="window.close()"><spring:message code="ezQuestion.t88" /></span></li>
					  </ul>
					</div>
					<script type="text/javascript">
					    selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
					<div id="Content2" style="font-size:small;">
					</div>
					<div class="box" id="Content" style = "display:none">
					</div>
					<div style="cursor:pointer" onclick="download_attach()" id = "download_att"><h2><spring:message code="ezQuestion.t163" /></h2></div>
					<form id="download_form" target="_blank" action=""></form>
			</c:otherwise>
		</c:choose>
	</body>
</html>