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
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
			
		<script type="text/javascript">

			var mode;
			if(mode==null) {
				mode = "all";
			}
			var searchSelect;
			var searchInput;
			
			function searchLadder() {
				searchSelect = document.getElementById("searchOption").value;
				searchInput = document.getElementById("searchInput").value;
				
				var allData = [searchSelect, searchInput, mode];
				
				jQuery.ajaxSettings.traditional = true;
				
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezLadder/searchLadder.do",
					data : {
						"allData":allData
					},
					success: function(data) {
						viewList(data);
					}
				});
			}
	
			function newLad() {
				window.location.href = '/ezLadder/selectLadderType.do';
			}
	
			function participant(){
				mode = $('#part').val();
				// 일부 참여자 리스트
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezLadder/viewLadderModeList.do",
					data : {
						mode : mode
					},
					success: function(data) {
						viewList(data);
					}

				});
			}
			
			function allPart(){
				mode = $('#all').val();
				// 전체 참여자 리스트 (particpant&all 합쳐야 하는데 방법이 안떠오름...)
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezLadder/viewLadderModeList.do",
					data : {
						mode : mode
					},
					success: function(data) {
						viewList(data);
					}
				});
			}
			
			function viewList(data){
				var list="";
					list += "<table class='mainlist' style='width:100%;margin-top:30px;'>" + 
					    	"<tr><th width='30px'><spring:message code='ezLadder.t002'/></th>" + 					
							"<th width='20px'><spring:message code='ezLadder.t003'/></th>" +
							"<th width='60px'><spring:message code='ezLadder.t004'/></th>" +
							"<th width='40px'><spring:message code='ezLadder.t005'/></th>" + 
							"<th width='50px'><spring:message code='ezLadder.t006'/></th>" +
							"<th width='50px'><spring:message code='ezLadder.t007'/></th>" +
							"<th width='50px'><spring:message code='ezLadder.t008'/></th></tr>";
				if (data.list.length > 0) {
					$.each(data.list, function(key, value) {
						list += "<tr class='white'>" +
								"<td>" + value.type + "</td>" +
								"<td>" + value.title + "</td>" +
								"<td>" + value.writerName + "</td>" +
								"<td>" + value.writeDate.substring(0,16) + "</td>" +
								"<td>" + value.status + "</td>" +
								"<td>" + value.secretFlag + "</td>" +
								"<td>" + value.deleteFlag + "</td></tr>";
					});
				} else {
					list += "<tr><td colspan='7' align='center' bgcolor='#FFFFFF'> <spring:message code='ezLadder.t010' /></td></tr>";
				}
				list+="</table>";
				$("#divList").html(list);
			}
		</script>
	</head>
	<body class="mainbody" style="min-width: 750px;">
		<h1><spring:message code="ezLadder.t001"/>
			
			<span style="float: right; font-weight:normal;color:black;">
				<select id="searchOption">
				  <option value="title">사다리 제목</option>
				  <option value="kind">사다리 종류</option>
				  <option value="writer">작성자</option>
				  <option value="participant">참여자</option>
				</select>

				<input type="text" name="searchInput" id="searchInput" style="width:150px; margin-left: 10px;" onkeypress="check_key(event);" value="<c:out value='${strSearch1}'/>">
				<a href="#"><img src="/images/sub/bsearch.gif" border="0" style="vertical-align:middle;" onclick="searchLadder()" ></a>
			</span>
		</h1>
		<div id="mainmenu">
			<ul>
				<li id="btnInsert" onClick="newLad()"><a  style="margin-top: 3px;"><span><spring:message code="ezLadder.t013"/></span></a></li>
				<li style="float:right; font-weight:normal; color:black; padding-right: 20px;">
					<button id="part" onclick="participant()" value="part"><spring:message code="ezLadder.t012"/></button>
					<button id="all" onclick="allPart()" value="all"><spring:message code="ezLadder.t011"/></button>
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
					<tr class="white">
						<td>${vo.type }</td>
						<td>${vo.title }</td>
						<td>${vo.writerName }</td>
						<td>${vo.writeDate.substring(0,16) }</td>
						<td>${vo.status }</td>
						<td>${vo.secretFlag }</td>
						<td>${vo.deleteFlag }</td>
					</tr>
				</c:forEach>
		        
			    <c:if test="${vo.size() == 0}"> 
			        <tr> 
						<td colspan="9" align="center"  bgcolor="#FFFFFF"> <spring:message code="ezLadder.t010" /></td>
		       		</tr> 
		        </c:if> 
			</table> 
			
		</div>
		 
	</body>
</html>