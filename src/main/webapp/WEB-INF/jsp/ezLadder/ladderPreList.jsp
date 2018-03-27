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
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderList.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		
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
			var retladinfo = [];
			var ladderID = "";
			
			var dragloc = {};
			var droploc = {};
			var changeLadId1 = [];
			var changeLadId2 = [];
						
			function changeListOrder() {
				var ladId1 = dragloc["id"].substring(9);
				var ladId2 = droploc["id"].substring(9);
				
				changeLadId1.push(ladId1);
				changeLadId2.push(ladId2);
			}
			
			function changeListOrderComplete() {
				$.ajax({
					type: "POST",
					url: "/ezLadder/setListOrder.do",
					dataType: "json",
					traditional: true,
					data: {
						"ladderIds": changeLadId1,
						"changeLadderIds": changeLadId2
					},
					success: function(result) {
						changeLadId1 = [];
						changeLadId2 = [];
					}
				});
			}
			
			$(function() {
				/** 이전 리스트 순서 바꾸기 */
				$(".rowDiv").draggable({ // 드래그 리스트
					revert: "invalid",
					revertDuration: 400,
					zIndex: 100,
					axis: "y",
					addClasses: false,
					start: function(event, ui) {
						dragloc = {"id": $(this).attr("id"), "top": $(this).css("top")};
					}
				});
				$(".rowDiv").droppable({ // 드랍 리스트
					accept: ".rowDiv",
					addClasses: false,
					hoverClass: "nowOver",
					drop: function(event, ui) {
						droploc = {"id": $(this).attr("id"), "top": $(this).css("top")};
						$("#" + dragloc["id"]).css("z-index", "10").animate({"top": droploc["top"]}, 100, function() {
							$("#" + dragloc["id"]).css("z-index", "0")
						});
						$("#" + droploc["id"]).css("z-index", "10").animate({"top": dragloc["top"]}, 100, function() {
							$("#" + droploc["id"]).css("z-index", "0")
						});
						changeListOrder();
					}
				});
				
				$(document).on("click", "#myLadderList", function() {
					ladderID = $(this).attr("ladid");
					retladinfo = getPreLadder(ladderID);
				});
				
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
				$("#okBtn").on("click", function() {
					/* opener.window.location.href = '/ezLadder/setLadder.do?ladderId=' + ladderID;
					window.close(); */
					loadPreLadderSetting();
				});
				
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
	            
				//makePageSelPage();
				
				$(document).on("click", "#myLadderList", function() {
					var ladderID = $(this).attr("ladid");
					retladinfo = getPreLadder(ladderID);
				});
				
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
			});
			
			function loadPreLadderSetting() {
				console.log(retladinfo);
				if(typeof retFunc !== "undefined" && retFunc !== "") {
					retFunc(retladinfo["lad"], retladinfo["ladline"]);
				}
				
				window.close();
			}
		</script>
		<style type="text/css">
			.allWrapDiv {
			    height:  620px;
			    display: block;
			}
			
			.listWrapDiv {
			    position:  relative;
			    height: 500px;
			    overflow-y:  auto;
			    border:  1px solid black;
			}
			
			.rowDiv {
				position: absolute;
				width: 100%;
				height: 60px;
				padding: 5px 20px;
				outline:  1px solid black;
				background: white;
			}
			
			#title {padding-left:  20px;display:  table-cell;vertical-align:  middle;}
			
			.rowDiv .icondiv {display:  table-cell;}
			
			.rowWrap {position:  relative;width:  100%;height:  100%;display: table;}
			
			.popupWrap {
				margin-top: 30px;
			    padding: 10px 25px;
			}
			
			.nowOver {
				background: beige;
			}
			
			.nowMove {
				background: beige;
				z-index: 100;
			}
			
		</style>
		
</head>
	<body class="popup">
		<h1 id="h1Title" style="height: 20px;">이전 사다리 불러오기</h1>
		
			<div class="popupWrap">
			<button onclick="changeListOrderComplete()">순서바꾸기 테스트</button>
			    <table style="width:  100%;">
			        <tbody>
			        	<tr>
							<td style="width:  300px; min-width: 200px;">
								<div class="allWrapDiv">
									<div class="listWrapDiv">
										<c:forEach items="${list}" var="prelist" varStatus="status">
											<div class="rowDiv" id="prelistId${prelist.ladderId}" style="top: ${60 * status.index}px">
												<div class="rowWrap">
													<div class="icondiv">${prelist.type}</div>
													<div id="title">${prelist.title}</div>
												</div>
											</div>
										</c:forEach>
									</div>
								</div>
							</td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			    
			    <div style="
			    height:  45px;
			    margin-bottom:  15px;
			    position:  relative;
			"><div style="
			    height: 100%;
			    display: inline-block;
			    position: absolute;
			    left: 0;
			    right: 45px;
			    margin-right: 10px;
			"><input type="text" class="input" style="
			    height:  100%;
			    width:  100%;
			    "></div><div style="
			    height:  100%;
			    display:  inline-block;
			    float: right;
			    width: 45px;
			    background:  beige;
			">검색</div></div>
			                    
		
			<%-- <div class="popWrap">
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
				<button id="okBtn">ok</button>
				<button onclick="window.close()">close</button>
			</div> --%>
	</body>
</html>