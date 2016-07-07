<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t414' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		
		<script type="text/javascript">
		 window.onload = function () {
		        document.getElementById("selColor").value = "#ffffff";
		        document.getElementById("selColorShow").style.backgroundColor = document.getElementById("selColor").value;
			}
			
		    //인자 추가 _event
			function select_color(event) {
			    //document.getElementById("selColor").value = event.srcElement.title;
			    //파이어폭스에서 event.srcElement를 찾을 수 없어서 조건문 추가_2013.01.29
			    var target = event.target ? event.target : event.srcElement;
			    document.getElementById("selColor").value = target.title;
			    document.getElementById("selColorShow").style.backgroundColor = document.getElementById("selColor").value;
			}

			function ok_onclick() {
			    window.returnValue = document.getElementById("selColor").value;
				window.close();
			}

		    document.getElementById
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code = 'ezCommunity.t414' /></h1>
		<%--파이어폭스에서 이벤트를 못 찾아서 onclick="select_color()"이벤트에서 onmousedown="select_color(event)"이벤트로 수정_2013.01.29--%>
		<table width="100%" cellspacing="2" onmousedown="select_color(event)" id="ColorTable" class="box" border="1">
			<tr>
			    <td width="32" bgcolor="#ff8080" title="#ff8080">&nbsp;</td>
			    <td width="32" bgcolor="#ffff80" title="#ffff80">&nbsp;</td>
			    <td width="32" bgcolor="#80ff80" title="#80ff80">&nbsp;</td>
			    <td width="32" bgcolor="#00ff80" title="#00ff80">&nbsp;</td>
			    <td width="32" bgcolor="#80ffff" title="#80ffff">&nbsp;</td>
			    <td width="32" bgcolor="#0080ff" title="#0080ff">&nbsp;</td>
			    <td width="32" bgcolor="#ff80c0" title="#ff80c0">&nbsp;</td>
			    <td width="32" bgcolor="#ff80ff" title="#ff80ff">&nbsp;</td>
			</tr>
		  	<tr>
			    <td bgcolor="#ff0000" title="#ff0000">&nbsp;</td>
			    <td bgcolor="#ffff00" title="#ffff00">&nbsp;</td>
			    <td bgcolor="#80ff00" title="#80ff00">&nbsp;</td>
			    <td bgcolor="#00ff40" title="#00ff40">&nbsp;</td>
			    <td bgcolor="#00ffff" title="#00ffff">&nbsp;</td>
			    <td bgcolor="#0080c0" title="#0080c0">&nbsp;</td>
			    <td bgcolor="#8080c0" title="#8080c0">&nbsp;</td>
			    <td bgcolor="#ff00ff" title="#ff00ff">&nbsp;</td>
			</tr>
			<tr>
			    <td bgcolor="#804040" title="#804040">&nbsp;</td>
			    <td bgcolor="#ff8040" title="#ff8040">&nbsp;</td>
			    <td bgcolor="#00ff00" title="#00ff00">&nbsp;</td>
			    <td bgcolor="#008080" title="#008080">&nbsp;</td>
			    <td bgcolor="#004080" title="#004080">&nbsp;</td>
			    <td bgcolor="#8080ff" title="#8080ff">&nbsp;</td>
			    <td bgcolor="#800040" title="#800040">&nbsp;</td>
			    <td bgcolor="#ff0080" title="#ff0080">&nbsp;</td>
			</tr>
			<tr>
			    <td bgcolor="#800000" title="#800000">&nbsp;</td>
			    <td bgcolor="#ff8000" title="#ff8000">&nbsp;</td>
			    <td bgcolor="#008000" title="#008000">&nbsp;</td>
			    <td bgcolor="#008040" title="#008040">&nbsp;</td>
			    <td bgcolor="#0000ff" title="#0000ff">&nbsp;</td>
			    <td bgcolor="#0000a0" title="#0000a0">&nbsp;</td>
			    <td bgcolor="#800080" title="#800080">&nbsp;</td>
			    <td bgcolor="#8000ff" title="#8000ff">&nbsp;</td>
			</tr>
			<tr>
			    <td bgcolor="#400000" title="#400000">&nbsp;</td>
			    <td bgcolor="#804000" title="#804000">&nbsp;</td>
			    <td bgcolor="#004000" title="#004000">&nbsp;</td>
			    <td bgcolor="#004040" title="#004040">&nbsp;</td>
			    <td bgcolor="#000080" title="#000080">&nbsp;</td>
			    <td bgcolor="#000040" title="#000040">&nbsp;</td>
			    <td bgcolor="#400040" title="#400040">&nbsp;</td>
			    <td bgcolor="#400080" title="#400080">&nbsp;</td>
			</tr>
			<tr>
			    <td bgcolor="#000000" title="#000000">&nbsp;</td>
			    <td bgcolor="#808000" title="#808000">&nbsp;</td>
			    <td bgcolor="#808040" title="#808040">&nbsp;</td>
			    <td bgcolor="#808080" title="#808080">&nbsp;</td>
			    <td bgcolor="#408080" title="#408080">&nbsp;</td>
			    <td bgcolor="#c0c0c0" title="#c0c0c0">&nbsp;</td>
			    <td bgcolor="#400040" title="#400040">&nbsp;</td>
			    <td bgcolor="#ffffff" title="#ffffff">&nbsp;</td>
			</tr>
		</table>
		<%--<div class="box" style="width:100%;margin-top:2px">
		  <span id=selColorShow style="background-color:black; width:28px; height:21px; border:1px inset gray"></span>
		  &nbsp;<input type="text" id=selColor>
		</div>--%>
		<%--크롬, 파이어폭스에서 span태그에 배경색이 지정되지 않아서 테이블구조의 div태그로 수정 _2013.01.29--%>
		<table style="width:100%;margin-top:2px" cellspacing="2" class="box">
		    <tr>
		        <td>Color:</td>
		        <td><div id=selColorShow style="background-color:black; width:28px; height:21px; border:1px inset gray"></div></td>
		        <td><input type="text" id=selColor></td>
		    </tr>
		</table>
		
		<div class="btnposition" > 
			<input id="ok" onClick="ok_onclick();" type="button"  value="<spring:message code = 'ezCommunity.t245' />">
			<input onClick="window.close();" type="button"  value="<spring:message code = 'ezCommunity.t246' />">
		</div>
</body>
</html>