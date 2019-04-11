<%@page import="org.w3c.dom.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t246' />${title}</title>
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<!-- 2018-07-25 김보미 - 투표모듈 css맞추기 위해 추가 -->
		<link rel="stylesheet" href="${util.addVer('/css/ezPoll/vote.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/admin.css')}">
		<script type="text/javascript">
			var ReturnFunction;
			var parent;
			var paparent;

			window.onload = function () {
				try {
					ReturnFunction = opener.PollResult_Cross_dialogArguments[1];

					if(ReturnFunction!= null) {
						if(window.opener.opener != null) {
							parent = window.opener.opener;

								if(window.opener.opener.opener != null) {
									paparent = window.opener.opener.opener;
								}
						}
						window.opener.close();
					}
				} catch (e) {}
			}

			function close_btn() {
				if(ReturnFunction!= null) {
					if(parent != null) {
						parent.location.reload();
					}

					if(paparent != null) {
						paparent.location.reload();
					}
				}
				window.close();
			}
		</script>
	</head>
	<body class="popup" style="overflow: hidden; background: none;">
		<table id="popupContentTb" align="center" style="margin-top:25px;">
			<tr>
				<td>
					<div class="question">
						<span class="spanPollTitle" title='${subject}'>"${subject}"</span>
						<span class="spanPollCount">${subjectCont}</span>
					</div>
				</td>
			</tr>
			<tr style="height: 100%">
				<td>
					<div id="receivelist" class="box">${strHtml}</div>
				</td>
			</tr>
		</table>
	</body>
</html>