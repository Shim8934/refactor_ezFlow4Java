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
			
			$(function() {
				changeBtnColor();
				makePageSelPage();
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
				ladder_main_resize();
				$(window).resize(function() {
					ladder_main_resize();
				});
			});
			// 윈도우 창 조절
			function ladder_main_resize() {
				var win_height = $(window).height() - 300;
				$(".mainlist").css("height", win_height + "px");
				/* $(".mainlist tr").css("height", 30 + "px");
				$(".mainlist th").css("height", 20 + "px");  */
			}
			
		</script>
		<style type="text/css">
			.pagenavi .ptxt {
			    border-color:white;
			    color: #B5B3B3;
			    background-color: grey;
			    border-radius: 3px;
			    color:white;
			}	
			.pagenavi .on {
			    color: white;
			    border-color: white;
			    background-color: grey;
			}
			.pagenavi span {
			    font-size: 12px;
			    display: inline-block;
			    cursor: pointer;
			    border: 1px solid #eee;
			    height: 19px;
			    margin: 0px 3px;
			    padding: 0px 6px 0px 5px;
			    text-align: center;
			    line-height: 19px;
			    border-radius: 3px;
			    font-weight: normal;
			    color: #666;
			    font-family: arial;
			    vertical-align: top;
			}
			
			.effect {
				width:30px;
				height:30px;
				border:1px solid black;
				border-radius:25px;
			}
			.effect img {
				width:30px;
				height:30px;
			}
			#mainmenu li span {
				border-color: #B5B3B3;
				border-radius:0px;
			}
			.participantBtn {
				height:28px;
				border-color:#B5B3B3; 
				border:1px solid #B5B3B3;
			}
		</style>
	</head>
	<body class="mainbody" style="min-width: 750px;">
		<h1><spring:message code="ezLadder.t001"/>
			<span id="mailBoxInfo"></span>
			<span style="float: right; font-weight:normal;color:black; margin-right: 30px;">
				<select id="searchOption">
				  <option value="title" <c:if test = "${searchSelect eq 'title' }" >selected="selected"</c:if>>사다리 제목</option>
				  <option value="kind" <c:if test = "${searchSelect eq 'kind' }" >selected="selected"</c:if>>사다리 종류</option>
				  <option value="writer" <c:if test = "${searchSelect eq 'writer' }" >selected="selected"</c:if>>작성자</option>
				  <option value="participant" <c:if test = "${searchSelect eq 'participant' }" >selected="selected"</c:if>>참여자</option>
				</select>

				<input type="text" name="searchInput" id="searchInput" style="width:150px; margin-left: 10px;" onkeypress="check_key(event);" value="<c:out value='${searchInput}'/>">
				<a href="#"><img src="/images/ezLadder/btn_search.png" width='24px' height='24px' style="vertical-align:middle; float:right;" onclick="searchLadder()" ></a>
			</span>
		</h1>
		<div id="mainmenu" style="margin-top:70px;">
			<ul style="width:98%;">
				<li id="btnInsert" onClick="newLad()" style="margin-left: 10px"><a><span><spring:message code="ezLadder.t013"/></span></a></li>
				<li style="float:right; font-weight:normal; ">
					<button class="participantBtn" id="part" onclick="participant(this.value)" value="part" style="position:relative; left:6px;"><spring:message code="ezLadder.t012"/></button>
					<button class="participantBtn" id="all" onclick="participant(this.value)" value="all"><spring:message code="ezLadder.t011"/></button>
				</li>
			</ul>
		</div>
		
		<div class="div_scroll" style="width:100%; overflow: auto" id="divList">
			 <table class="mainlist" style="width:98%; margin-left: 10px; margin-right: 10px; overflow: auto"> 
			    <tr class="header" style="height=20;"> 
					<th width="20px"><spring:message code="ezLadder.t002"/></th> 					
					<th width="80px"><spring:message code="ezLadder.t003"/></th> 
					<th width="40px"><spring:message code="ezLadder.t004"/></th>
					<th width="40px"><spring:message code="ezLadder.t005"/></th> 
					<th width="30px"><spring:message code="ezLadder.t006"/></th> 
					<th width="30px"><spring:message code="ezLadder.t007"/></th>
					<th width="30px"><spring:message code="ezLadder.t008"/></th>		
			    </tr>
				 <c:forEach items="${list }" var="vo">
					<tr class="black" style="height=30px;">
						<c:choose>
							<c:when test="${vo.type eq 0 }">
								<td><div class="effect"><img src ='/images/ezLadder/icon_bomb.png' /></div></td>
							</c:when>
							<c:when test="${vo.type eq 1 }">
								<td><div class="effect"><img src ='/images/ezLadder/icon_money.png' /></div></td>
							</c:when>
							<c:when test="${vo.type eq 2 }">
								<td><div class="effect"><img src ='/images/ezLadder/icon_order.png' /></div></td>
							</c:when>
							<c:otherwise>
								<td><div class="effect"><img src ='/images/ezLadder/icon_handwork.png' /></div></td>
							</c:otherwise>
						</c:choose>
						<td><a href="#" onClick="getLadderGame(${vo.ladderId})">${vo.title }</a></td>
						<td>${vo.writerName }</td>
						<td>${vo.writeDate.substring(0,16) }</td>
						
						<c:choose>
							<c:when test="${vo.status eq 0 }">
								<td><div class="effect"><img src ='/images/ezLadder/icon_wait.png' /></div></td>
							</c:when>
							<c:otherwise>
								<td><div class="effect"><img src ='/images/ezLadder/icon_complete.png' /></div></td>
							</c:otherwise>
						</c:choose>
						
						<c:choose>
							<c:when test="${vo.secretFlag eq 0 }">
								<td><div class="effect"><img src ='/images/ezLadder/icon_public.png' /></div></td>
							</c:when>
							<c:otherwise>
								<td><div class="effect"><img src ='/images/ezLadder/icon_private.png' /></div></td>
							</c:otherwise>
						</c:choose>
						
						<c:choose>
							<c:when test="${id eq vo.writerId}">
								<td><div class="effect"><a href="#" onclick="deleteLadder(${vo.ladderId})"><img src ='/images/ezLadder/icon_posDelete.png' /></a></div></td>
							</c:when>
							<c:otherwise>
								<td><div class="effect"><img src ='/images/ezLadder/icon_imposDelete.png' /></div></td>
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
		<div id="tblPageRayer" style="margin-top: 30px;"></div>
	</body>
</html>