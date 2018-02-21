<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
		<title><spring:message code="ezLadder.t009" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezLadder.i1' />" type="text/css">

		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<!-- 	<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
		<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>	 -->			
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
				
	
	</head>
	<body class="mainbody" style="min-width: 750px;">
		<h1><spring:message code="ezLadder.t001"/>
			
			<span style="float: right; font-weight:normal;color:black;">
				<c:if test="${mode1 != 'wri'}">
					<input name="searchCheck" id="radio1" type="radio" value="sub" checked style="margin:0px;padding:0px;width:13px;height:13px; "> <span><spring:message code="ezPoll.t106"/></span>
					<input name="searchCheck" id="radio2" type="radio" value="wri" style="margin:0px;padding:0px;width:13px;height:13px; "> <span><spring:message code="ezPoll.t107"/></span>
				</c:if>
				<c:if test="${mode1 == 'wri'}">
					<input name="searchCheck" id="radio1" type="radio" value="sub" style="margin:0px;padding:0px;width:13px;height:13px; "> <span><spring:message code="ezPoll.t106"/></span>
					<input name="searchCheck" id="radio2" type="radio" value="wri" checked style="margin:0px;padding:0px;width:13px;height:13px; "> <span><spring:message code="ezPoll.t107"/></span>
				</c:if>
					<input type="text" name="searchInput" id="searchInput" style="width:150px; margin-left: 10px;" onkeypress="check_key(event);" value="<c:out value='${strSearch1}'/>">
					<a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle;" ></a>
			</span>
		</h1>
		<div id="mainmenu">
			<ul>
				<li id="btnInsert"><a  style="margin-top: 3px;"><span><spring:message code="ezLadder.t013"/></span></a></li>
				<li style="float:right; font-weight:normal; color:black; padding-right: 20px;">
					<input id="btnRadio1" type="radio" name="processCheck" style="width:13px;height:13px;vertical-align:middle; padding-right: 20px;" onclick="selectCheck()" value="2" checked="checked" >
					<label for="btnRadio1"><spring:message code='ezLadder.t011' /></label>					
				</li>
				<li style="float:right; font-weight:normal; color:black;">
					<input id="btnRadio2" type="radio" name="processCheck" style="width:13px;height:13px;vertical-align:middle;" onclick="selectCheck()" value="1" >
					<label for="btnRadio2"><spring:message code='ezLadder.t012' /></label>					
				</li>
			
			</ul>
		</div>

			 
		<div class="div_scroll" style="width:100%; height:500px; overflow: auto" id="divList">
			<table  class="mainlist" style="width:100%;margin-top:5px"> 
			    <tr> 
					<th width="30px"><spring:message code="ezLadder.t002"/></th> 					
					<th width="20px"><spring:message code="ezLadder.t003"/></th> 
					<th width="60px"><spring:message code="ezLadder.t004"/></th>
					<th width="40px"><spring:message code="ezLadder.t005"/></th> 
					<th width="50px"><spring:message code="ezLadder.t006"/></th> 
					<th width="50px"><spring:message code="ezLadder.t007"/></th>
					<th width="50px"><spring:message code="ezLadder.t008"/></th>		
			    </tr>
				 <c:forEach items="${list }" var="vo">
					<tr class="white">
						<td>${vo.ladderId }</td>
						<td>${vo.title }</td>
						<td>${vo.writerName }</td>
						<td>${vo.writeDate.substring(0,16) }</td>
						<td>${vo.status }</td>
						<td>${vo.secretFlag }</td>
						<td>휴지통</td>
					</tr>
				</c:forEach>
		        
			    <c:if test="${vo.size() == 0}"> 
			        <tr> 
						<td colspan="9" align="center"  bgcolor="#FFFFFF"> <spring:message code="ezLadder.t010" /></td>
		       		</tr> 
		        </c:if> 
			</table> 
			<div style="display:none">
				<input type="text" name="hiddenSeeAll" id="hiddenSeeAll" value="" style="display:none">
			</div>
		</div>
	</body>
</html>