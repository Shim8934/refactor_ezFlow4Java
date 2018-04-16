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
			var sort = "${sort}";
			var sortFlag = "${sortFlag}";
			
			$(function() {
				
				mouseCursor();
				changeBtnColor();
				makePageSelPage();
				$("#header img").hide();
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
				$(".deleteLadder").on("click", function(e) {
					e.stopPropagation();
					deleteLadder($(this).attr("_ladderId"));
				});
				
				ladder_main_resize();
				$(window).resize(function() {
					ladder_main_resize();
				});
				
				checkSearchOption();	// select Option 초기 설정
				$("#searchOption").on('change', function() { // // select Option값 바뀔시
					checkSearchOption();
				});
				sortViews();
			});
			// 윈도우 창 조절
			function ladder_main_resize() {
				var win_height = $(window).height() - 220;
				if(win_height>220){
					$(".div_scroll").css("height", win_height + "px");
				}
			}
			// 사다리 종류 드롭박스
			function checkSearchOption() {
				if($("#searchOption option:selected").val()==='kind') {
					$("#searchInput").hide();
					$("#searchInput").val("");
					$("#ladderType").show();
				} else {
					$("#ladderType").hide();
					$("#searchInput").val("");
					$("#searchInput").show();
				} 
			}
			
			
		</script>
		<style type="text/css">
			.effect img {
				width:30px;
				height:30px;
				border:1px solid #a9a9a9;
				border-radius:30px;
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
			.mainlist th {
			    cursor: pointer;
			}
			
		</style>
	</head>
	<body class="mainbody" style="min-width: 750px;">
		<h1><spring:message code="ezLadder.t001"/>
			<span id="mailBoxInfo"></span>
			<span style="float: right; font-weight:normal;color:black;">
				<select id="searchOption" style="height:24px;">
				  <option value="title" <c:if test = "${searchSelect eq 'title' }" >selected="selected"</c:if>><spring:message code="ezLadder.t125"/></option>
				  <option value="kind" <c:if test = "${searchSelect eq 'kind' }" >selected="selected"</c:if>><spring:message code="ezLadder.t126"/></option>
				  <option value="writer" <c:if test = "${searchSelect eq 'writer' }" >selected="selected"</c:if>><spring:message code="ezLadder.t004"/></option>
				  <option value="participant" <c:if test = "${searchSelect eq 'participant' }" >selected="selected"</c:if>><spring:message code="ezLadder.t127"/></option>
				</select>

				<select id="ladderType" style="margin-left: 10px; height: 24px;">
				  <option value="0" <c:if test = "${searchInput eq '0' }" >selected="selected"</c:if>><spring:message code="ezLadder.t101"/></option>
				  <option value="1" <c:if test = "${searchInput eq '1' }" >selected="selected"</c:if>><spring:message code="ezLadder.t102"/></option>
				  <option value="2" <c:if test = "${searchInput eq '2' }" >selected="selected"</c:if>><spring:message code="ezLadder.t103"/></option>
				  <option value="3" <c:if test = "${searchInput eq '3' }" >selected="selected"</c:if>><spring:message code="ezLadder.t104"/></option>
				</select>
				
				<input type="text" name="searchInput" id="searchInput" style="width:150px; margin-left: 10px;" value="<c:out value='${searchInput}'/>">
				<a href="#"><img src="/images/ezLadder/btn_search.png" width='24px' height='24px' style="vertical-align:middle; float:right;" onclick="searchLadder()" ></a>
			</span>
		</h1>
		<div id="mainmenu">
			<ul style="width:100%;">
				<li id="btnInsert" onClick="newLad()" ><a><span><spring:message code="ezLadder.t013"/></span></a></li>
				<li style="float:right; font-weight:normal; ">
					<button class="participantBtn" id="part" onclick="participant(this.value)" value="part" style="position:relative; left:6px;"><spring:message code="ezLadder.t012"/></button>
					<button class="participantBtn" id="all" onclick="participant(this.value)" value="all"><spring:message code="ezLadder.t011"/></button>
				</li>
			</ul>
		</div>
		
		<div class="div_scroll" style="width:100%; overflow: auto" id="divList">
			 <table class="mainlist" style="width:100%; overflow: auto"> 
			    <tr class="header" style="height=20px;"> 
					<th width="20px" onClick="listSort(0)"><spring:message code="ezLadder.t002"/><span id="sort_0" ></span></th> 
					<th width="80px" onClick="listSort(1)"><spring:message code="ezLadder.t003"/><span id="sort_1" ></span></th> 
					<th width="40px" onClick="listSort(2)"><spring:message code="ezLadder.t004"/><span id="sort_2" ></span></th>
					<th width="40px" onClick="listSort(3)"><spring:message code="ezLadder.t005"/><span id="sort_3" ></span></th> 
					<th width="30px" onClick="listSort(4)"><spring:message code="ezLadder.t006"/><span id="sort_4" ></span></th> 
					<th width="30px" onClick="listSort(5)"><spring:message code="ezLadder.t007"/><span id="sort_5" ></span></th>
					<th width="30px" onClick="listSort(6)"><spring:message code="ezLadder.t008"/><span id="sort_6" ></span></th>
			    </tr>
				 <c:forEach items="${list }" var="vo">
					<tr class="black" style="height=30px;" onClick="getLadderGame(${vo.ladderId})">
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
						
						<td><div class="effect">${vo.title }</div></td>
						<td><div class="effect">${vo.writerName }</div></td>
						<td><div class="effect">${vo.writeDate.substring(0,16) }</div></td>
						
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
								<td><div class="effect"><img src ='/images/ezLadder/icon_posDelete.png' class="deleteLadder" _ladderId="<c:out value='${vo.ladderId}' />" /></div></td>
							</c:when>
							<c:otherwise>
								<td><div class="effect"><img src ='/images/ezLadder/icon_imposDelete.png' /></div></td>
							</c:otherwise>
						</c:choose>
					</tr>
				</c:forEach>
			    <c:if test="${list.size() == 0}"> 
					<td colspan="7" align="center"  bgcolor="#FFFFFF"> <spring:message code="ezLadder.t010" /></td> 
		        </c:if> 
			</table>  
		</div>
		<div id="tblPageRayer" style="margin-top: 40px;"></div>
	</body>
</html>