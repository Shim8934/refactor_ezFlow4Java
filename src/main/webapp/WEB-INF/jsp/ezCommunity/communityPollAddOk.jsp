<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
	</head>
	<body class="mainbody">
		<form name="poll_add" action="poll_add_ok_go.aspx" method="POST" runat="server">
			<input type="hidden" name="mode"			value="<c:out value = '${mode}' />">;
			<input type="hidden" name="code"			value="<c:out value = '${code}' />">
			<input type="hidden" name="startPollYear"	value="<c:out value = '${startPollYear}' />">
			<input type="hidden" name="startPollMonth"	value="<c:out value = '${startPollMonth}' />">
			<input type="hidden" name="startPollDay"	value="<c:out value = '${startPollDay}' />">
			<input type="hidden" name="endPollYear"		value="<c:out value = '${endPollYear}' />">
			<input type="hidden" name="endPollMonth"	value="<c:out value = '${endPollMonth}' />">
			<input type="hidden" name="endPollDay"		value="<c:out value = '${endPollDay}' />">
			<input type="hidden" name="selRes"			value="<c:out value = '${selRes}' />">
			<input type="hidden" name="answerCount"		value="<c:out value = '${answerCount}' />">
			<input type="hidden" name="sel"				value="<c:out value = '${sel}' />">
			<input type="hidden" name="selType"			value="<c:out value = '${selType}' />">
			<input type="hidden" name="selectedNo"		value="<c:out value = '${selectedNo}' />">
			<input type="hidden" name="selJU"			value="<c:out value = '${selJU}' />">
			<input type="hidden" name="answerViewType"	value="<c:out value = '${answerViewType}' />">
			
<%-- 			<h1><%=RM.GetString("t598")%></h1> --%>
<!-- 			<br> -->
<!-- 			<br> -->
			
<!-- 			<table class="content"> -->
<!-- 				<tr> -->
<%-- 					<th><%=RM.GetString("t599")%></th> --%>
<!-- 					<td><textarea id="pollSubject" name="pollSubject" style="width: 100%;height:130px" runat="server"></textarea></td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<%-- 					<th><%=RM.GetString("t600")%></th> --%>
<!-- 					<td><span id="idSpan" runat=server></span> </td> -->
<!-- 				</tr> -->
<!-- 			</table> -->
			  
<!-- 			<div class="btnposition"> -->
<%-- 				<a class="imgbtn" name="Submit2" onClick="fun_Prev();"><span><%=RM.GetString("t616")%></span></a> --%>
<%-- 				<a class="imgbtn" name="Submit" onClick="sendIt();"><span><%=RM.GetString("t680")%></span></a> --%>
<%-- 				<a class="imgbtn"  name="Submit2" onclick="cancel_click()" ><span><%=RM.GetString("t246")%></span></a> --%>
			</div>
		</form>
	</body>
</html>