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
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezLadder.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>			
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderList.js"></script>
		
		<script type="text/javascript">
			var currPage = ${currPage};
			var pageChange = 1;
			var totalPage = ${totalPage};
			var totalLadder = ${totalLadder};
			var blockSize = 7;
			var mode = "";
			var modeCheck = "${mode}";
			var searchSelect = "${searchSelect}";
			var searchInput = "${searchInput}";
			var searchOption = "off";
			var allData = [];
			var id = "${id}";
			var back = "none";
			// onLoad시 페이징 블록 생성
			$(function() {
				makePageSelPage();
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
			});
			
			
			

			</script>
	</head>
	<body class="mainbody" style="min-width: 750px;">
		<h1><spring:message code="ezLadder.t001"/>
			<span id="mailBoxInfo"></span>
			<span style="float: right; font-weight:normal;color:black;">
				<select id="searchOption">
				  <option value="title" <c:if test = "${searchSelect eq 'title' }" >selected="selected"</c:if>>사다리 제목</option>
				  <option value="kind" <c:if test = "${searchSelect eq 'kind' }" >selected="selected"</c:if>>사다리 종류</option>
				  <option value="writer" <c:if test = "${searchSelect eq 'writer' }" >selected="selected"</c:if>>작성자</option>
				  <option value="participant" <c:if test = "${searchSelect eq 'participant' }" >selected="selected"</c:if>>참여자</option>
				</select>

				<input type="text" name="searchInput" id="searchInput" style="width:150px; margin-left: 10px;" onkeypress="check_key(event);" value="<c:out value='${searchInput}'/>">
				<a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle;" onclick="searchLadder()" ></a>
			</span>
		</h1>
		<div id="mainmenu">
			<ul>
				<li id="btnInsert" onClick="newLad()"><a  style="margin-top: 3px;"><span><spring:message code="ezLadder.t013"/></span></a></li>
				<li style="float:right; font-weight:normal; color:black; padding-right: 20px;">
					<button id="part" onclick="participant(this.value)" value="part"><spring:message code="ezLadder.t012"/></button>
					<button id="all" onclick="participant(this.value)" value="all"><spring:message code="ezLadder.t011"/></button>
				</li>
			</ul>
		</div>
		
		<div class="div_scroll" style="width:100%; height:500px; overflow: auto" id="divList">
			 <table  class="mainlist" style="width:100%;margin-top:30px;"> 
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
					<tr class="black">
						<td>${vo.type }</td>
						<td><a href="#" onClick="getLadderGame(${vo.ladderId})">${vo.title }</a></td>
						<td>${vo.writerName }</td>
						<td>${vo.writeDate.substring(0,16) }</td>
						<td>${vo.status }</td>
						<td>${vo.secretFlag }</td>
					<c:choose>
						<c:when test="${id eq vo.writerId}">
							<td><a href="#" onclick="deleteLadder(${vo.ladderId})"><img src ='/images/ezLadder/trash.png' width='30' height ='30'/></a></td>
						</c:when>
						<c:otherwise>
							<td><img src ='/images/ezLadder/trash.png' width='30' height ='30'/></td>
						</c:otherwise>
					</c:choose>
					</tr>
				</c:forEach>
		        
			    <c:if test="${vo.size() == 0}"> 
			        <tr> 
						<td colspan="9" align="center"  bgcolor="#FFFFFF"> <spring:message code="ezLadder.t010" /></td>
		       		</tr> 
		        </c:if> 
			</table>  
		</div>
		<div id="tblPageRayer"></div>
		 
	</body>
</html>