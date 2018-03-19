<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<script type="text/javascript" src="<spring:message code='ezLadder.e1'/>"></script>
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
			var retVal;
			var retFunc;
			var retLad;
			var retLadLine;
						
			$(function() {
				try {
					retVal = parent.ladder_pre_set_dialogArguments[0];
					retFunc = parent.ladder_pre_set_dialogArguments[1];                
	            } catch (e) {
	                try {
	                	retVal = opener.ladder_pre_set_dialogArguments[0];
	                	retFunc = opener.ladder_pre_set_dialogArguments[1];
	                } catch (e) {
	                	retVal = window.dialogArguments;
	                }
	            }
	            
				makePageSelPage();
				
				$(document).on("click", "#myLadderList", function() {
					var ladderID = $(this).attr("ladid");
					getPreLadderPreview(ladderID);
				});
				
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
			});
			
			function getPreLadderPreview(ladderID) {
				var allData = [];
				allData = getLadderGame(ladderID);
				
				$.ajax({
					type: "GET",
					url: "/ezLadder/getLadderGame.do",
					traditional: true,
					dataType: "json",
					data: {
						"allData": allData
					},
					success: function(result) {
						console.log(result);
						retLad = result.vo;
						retLadLine = result.list;
					}
				});
			}
			
			function loadPreLadderSetting() {
				console.log(retLad);
				console.log(retLadLine);
				console.log(retFunc);
				if(typeof retFunc !== "undefined" && retFunc !== "") {
					retFunc(retLad, retLadLine);
				}
				window.close();
			}
		</script>
		
</head>
	<body class="popup">
		<h1 id="h1Title" style="height: 20px;">이전 사다리 불러오기</h1>
			<div class="popWrap">
				<table style="height: 500px; width: 100%;">
					<tr>
						<td style="width: 300px;">
							<div class="pullHW">
								<table class="mainlist">
									<tbody>
										<tr>
											<td colspan="2" style="padding: 0px;">
												<div>
													<input type="text" disabled="disabled" style="display: none;" id="searchOption" value="title" />
													<input type="text" placeholder="search..." id="searchInput" />
												</div>
											</td>
										</tr>
										<tr>
											<td class="td_gray">title</td>
											<td class="td_gray">type</td>
											<td class="td_gray">secret</td>
											<td class="td_gray">writer</td>
										</tr>
										<c:forEach items="${list }" var="list">
										<tr id="myLadderList" ladId="${list.ladderId }">
											<td>${list.title }</td>
											<td>${list.type }</td>
											<td>${list.secretFlag }</td>
											<td>${list.writerName }</td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
								<div id="tblPageRayer"></div>
							</div>
						</td>
						<td>
							<div class="pullHW" style="background: silver;"></div>
						</td>
					</tr>			
				</table>
				<button onclick="loadPreLadderSetting()">ok</button>
				<button onclick="window.close()">close</button>
			</div>
	</body>
</html>