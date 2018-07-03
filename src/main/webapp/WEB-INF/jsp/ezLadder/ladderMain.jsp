<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			var change = "dddsdfsdfsdf";
			var currPage = <c:out value="${currPage}" />;
			var pageChange = 1;
			var totalPage = <c:out value="${totalPage}" />;
			var totalLadder = <c:out value="${totalLadder}" />;
			var blockSize = 10;
			var mode = "";
			var modeCheck = "<c:out value='${mode}' />";
			var searchSelect = "<c:out value='${searchSelect}' />";
			var searchInput = "<c:out value='${searchInput}' />";
			var searchOption = "off";
			var allData = [];
			var id = "<c:out value='${id}' />";
			var back = "none";
			var sort = "<c:out value='${sort}' />";
			var sortFlag = "<c:out value='${sortFlag}' />";
			
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
				$(".div_scroll").css("height", win_height + "px");
			}
			// 사다리 종류 드롭박스
			function checkSearchOption() {
				if($("#searchOption option:selected").val()==='kind') {
					$("#searchInput").css("display", "none");
					$("#searchInput").val("");
					$("#ladderType").css("display", "block");
				} else {
					$("#ladderType").css("display", "none");
					$("#searchInput").val("");
					$("#searchInput").css("display", "block");
				} 
			}
		
		</script>
		<style type="text/css">
			.effect {width:30px; height:30px;}
			#mainmenu li {border-color: #ddd; border-radius:0px; }
			.mainlist th {cursor: pointer;}
			#mainmenu li a:HOVER span{color:#0072c6;border-color:#0072c6;}
			#cmt {color:#c64200;}
			label {position:relative; top: -3px;}
			.participantBtn:HOVER, label:HOVER {cursor: pointer;}
		</style>
	</head>
	<body class="mainbody" style="overflow: hidden;">
		<h1><spring:message code="ezLadder.t001"/>
			<span id="mailBoxInfo"></span>
			<span style="float: right; font-weight:normal;color:black;">
				<select id="searchOption" style="height:20px; ">
				  <option value="title" <c:if test = "${searchSelect eq 'title' }" >selected="selected"</c:if>><spring:message code="ezLadder.t003"/></option>
				  <option value="kind" <c:if test = "${searchSelect eq 'kind' }" >selected="selected"</c:if>><spring:message code="ezLadder.t002"/></option>
				  <option value="writer" <c:if test = "${searchSelect eq 'writer' }" >selected="selected"</c:if>><spring:message code="ezLadder.t004"/></option>
				  <option value="participant" <c:if test = "${searchSelect eq 'participant' }" >selected="selected"</c:if>><spring:message code="ezLadder.t013"/></option>
				</select>
				
				<a href="#"><img src="/images/sub/bsearch.gif" border="0" width='20px' height='20px' style="vertical-align:middle; float:right;" onclick="searchLadder()" ></a>
				<input type="text" name="searchInput" id="searchInput" style="width:150px; height:20px; margin-left:10px; float:right; border-right: 0px;" value="<c:out value='${searchInput}'/>">
				<select id="ladderType" style="height: 20px; width:150px; margin-left:10px; float:right;">
				  <option value="0" <c:if test = "${searchInput eq '0' }" >selected="selected"</c:if>><spring:message code="ezLadder.t101"/></option>
				  <option value="1" <c:if test = "${searchInput eq '1' }" >selected="selected"</c:if>><spring:message code="ezLadder.t102"/></option>
				  <option value="2" <c:if test = "${searchInput eq '2' }" >selected="selected"</c:if>><spring:message code="ezLadder.t103"/></option>
				  <option value="3" <c:if test = "${searchInput eq '3' }" >selected="selected"</c:if>><spring:message code="ezLadder.t104"/></option>
				</select>
			</span>
		</h1>
		<div id="mainmenu">
			<ul style="width:100%;">
				<li id="btnInsert" onClick="newLad()" ><a><span><spring:message code="ezLadder.t018"/></span></a></li>
				<li style="float:right; font-weight:normal; position: relative; top:4px; right:22px;">
					<input type="radio" class="participantBtn" id="part" onclick="participant(this.value)" value="part">
					<label for="part"><spring:message code='ezLadder.t012' /></label>	
					<input type="radio" class="participantBtn" id="all" onclick="participant(this.value)" value="all">
					<label for="all"><spring:message code='ezLadder.t011' /></label>	
				</li>
			</ul>
		</div>
		<div style="width:100%; overflow: hidden;">
 		 	<table class="mainlist" style="width:100%;">
			    <tr class="header" style="height=20px;">
					<th onClick="listSort(0)" width="50px"><spring:message code="ezLadder.t002"/> <span id="sort_0" ></span></th> 
					<th onClick="listSort(1)"><spring:message code="ezLadder.t003"/> <span id="sort_1" ></span></th> 
					<th onClick="listSort(2)" width="100px"><spring:message code="ezLadder.t004"/> <span id="sort_2" ></span></th>
					<th onClick="listSort(3)" width="140px"><spring:message code="ezLadder.t025"/> <span id="sort_3" ></span></th> 
					<th onClick="listSort(4)" width="50px"><spring:message code="ezLadder.t006"/> <span id="sort_4" ></span></th> 
					<th onClick="listSort(5)" width="50px"><spring:message code="ezLadder.t106"/> <span id="sort_5" ></span></th>
					<th onClick="listSort(6)" width="50px"><spring:message code="ezLadder.t008"/> <span id="sort_6" ></span></th>
			    </tr>
			</table>
		</div> 
		<div class="div_scroll" style="width:100%; overflow: auto" id="divList">
			<table class="mainlist" style="width:100%; overflow: auto"> 
		 		<c:forEach items="${list }" var="vo">
					<tr class="black" style="height=30px;" onClick="getLadderGame(<c:out value="${vo.ladderId}" />)">
						<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t10${vo.type+1}'/>" src ='/images/ezLadder/icon_game_thirty0${vo.type}.png' /></td>
					
						<td style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">
							<c:if test="${vo.newFlag == 1 }"><img src="/images/i_new.gif">&nbsp;</c:if>
							<c:out value ="${vo.title }" />
							<c:if test="${vo.cmt>0 }"><span id="cmt">[<c:out value="${vo.cmt}" />]</span></c:if>
						</td>
						<td style="text-align: left;" width="100px"><a style="cursor:pointer" onClick="menuQst_DetailUserInfo('<c:out value='${vo.writerId}' />', event)"><c:out value="${vo.writerName }" /></a></td>
						<td style="text-align: left;" width="140px"><c:out value="${vo.writeDate.substring(0,16) }" /></td>
						
						<c:choose>
							<c:when test="${vo.status eq 0 }">
								<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t074'/>" src ='/images/ezLadder/icon_wait_thirty.png' /></td>
							</c:when>
							<c:otherwise>
								<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t075'/>" src ='/images/ezLadder/icon_complete_thirty.png' /></td>
							</c:otherwise>
						</c:choose>
						
						<c:choose>
							<c:when test="${vo.secretFlag eq 0 }">
								<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t007'/>" src ='/images/ezLadder/icon_public_thirty.png' /></td>
							</c:when>
							<c:otherwise>
								<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t076'/>" src ='/images/ezLadder/icon_private_thirty.png' /></td>
							</c:otherwise>
						</c:choose>
						
						<c:choose>
							<c:when test="${id eq vo.writerId}">
								<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t053'/>" src ='/images/ezLadder/icon_posDelete_thirty.png' onclick="deleteLadder(<c:out value="${vo.ladderId}" />, event);" /></td>
							</c:when>
							<c:otherwise>
								<td width="50px"><img class="effect" title="<spring:message code='ezLadder.t078'/>" src ='/images/ezLadder/icon_imposDelete_thirty.png' /></td>
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