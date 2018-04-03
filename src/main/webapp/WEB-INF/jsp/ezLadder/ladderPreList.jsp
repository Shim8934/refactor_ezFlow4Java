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
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css" type="text/css">
		<link rel="stylesheet" href="/css/ezPoll/sort.css" type="text/css">	
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
			
			function showLadderPreview() {
				var previewSrc = "/ezLadder/getLadderGame.do?ladderId=" + ladderID + "&mode=preview";
				
				$("#ladPreviewWrap").scrollTop(0);
				$("#ladderPreview").attr("src", previewSrc);
				if($("#ladderPreview").css("height") === "0px") {
					$("#ladderPreview").css("height", "1100px");
				}
			}
			
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
				$("#ladderPreview").css("height", "0px");
				
				/** mouse event */
				var selecColor = "rgb(233, 241, 255)";
				var overColor = "rgb(244, 245, 245)";
				var origColor = "#FFF";
				$(document)
					.on("click", ".myBorder", function() {
						$(".myBorder").removeClass("clickactive");
						$(this).addClass("clickactive");
						$(".myBorder").css("background", origColor);
						$(this).css("background", selecColor);
						
						ladderID = $(this).attr("id");
						showLadderPreview();
					})
					.on("mouseenter", ".myBorder", function() {
						$(this).css("background", overColor);
					})
					.on("mouseleave", ".myBorder", function() {
						if($(this).hasClass("clickactive")) {
							$(this).css("background", selecColor);
						} else {
							$(this).css("background", origColor);
						}
					});
				
				/** sort list */
				$("#columnsbnk").sortable({
					activate: function(event, ui) {
						console.log(ui.helper[0]);
						var thisId = "#" + ui.helper[0].id; 
						$(thisId).css("border", "1px solid #ddd");
					}, 
					stop: function(event, ui) {
						console.log("sto");
						var thisId = "#" + ui.item[0].id; 
						$(thisId).css("border", "");
					}
				});
				$("#columnsbnk").disableSelection();
				
				/** 이전 리스트 순서 바꾸기 */
				/* $(".myBorder").draggable({ // 드래그 리스트
					revert: "invalid",
					revertDuration: 400,
					zIndex: 5,
					axis: "y",
					addClasses: false,
					start: function(event, ui) {
						$("#columnsbnk").css("background", "#ddd");
						$(this).css("border", "1px solid #ddd");
						dragloc = {"id": $(this).attr("id"), "top": $(this).css("top")};
					}, 
					stop: function() {
						$(this).css("border", "");
						$(this).css("border-bottom", "1px solid #ddd");
					}
				});
				$(".myBorder").droppable({ // 드랍 리스트
					accept: ".myBorder",
					addClasses: false,
					hoverClass: "nowOver",
					over: function(event, ui) {
						console.log("-");
						$(".myBorder").css("background", "white");
						$(this).css("background", "beige");
					},
					drop: function(event, ui) {
						droploc = {"id": $(this).attr("id"), "top": $(this).css("top")};
						$("#" + dragloc["id"]).css("z-index", "10").animate({"top": droploc["top"]}, 500, function() {
							$("#" + dragloc["id"]).css("z-index", "0")
						});
						$("#" + droploc["id"]).css("z-index", "10").animate({"top": dragloc["top"]}, 500, function() {
							$("#" + droploc["id"]).css("z-index", "0")
						});
						changeListOrder();
					}
				}); */
				
				$("#searchInput").on("keyup", function(e) {
					if(e.keyCode == "13") {
						searchLadder();
					}
				});
				
				$("#btn_SaveAprLineTempletName").on("click", function() {
					loadPreLadderSetting();
				});
				$("#btn_CancelAprLineTempletName").on("click", function() {
					window.close();
				});
			});
			
			function viewSearchList(ladderList) {
				var html = "";
				
				modeCheck = "pre";
				pageChange = 1;
				currPage = ladderList["currPage"];
				totalPage = ladderList["totalPage"];
				totalLadder = ladderList["totalLadder"];

				ladderList["list"].forEach(function(ladder, index) {
					html += '<li class="myBorder" name="preladder_' + index + '" id="' + ladder["ladderId"] + '" style="cursor: pointer;">';
					html += '<span>' + index + '</span>';
					html += '<div class="prelist" style="width: 15%">' + ladder["type"] + '</div>';
					html += '<div class="prelist" style="width: 60%">' + ladder["title"] + '</div></li>';
				});
				
				$("#columnsbnk").html(html);
				
				makePageSelPage();
				
			}
			
			function loadPreLadderSetting() {
				retladinfo = getPreLadder(ladderID);
				if(!!retFunc) {
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
			
			#columnsbnk .prelist  {
			    display: inline-block;
			    border: none;
			    height: 28px;
			    line-height: 30px;
			    margin: -2px 0px 0px 0px;
			    padding: 0px 7px 0px 7px;
			}
			
			.clickactive {
				background-color: rgb(233, 241, 255);
			}
		</style>
		
</head>
	<body class="popup">
		<h1 id="h1Title">이전 사다리 불러오기</h1>
		
		<table>
			<tbody>
				<tr>
					<td style="overflow: auto; width: 300px;">
						<table style="width: 99%; margin:10px 0px 10px 2px;"> 
							<tr>
								<td style="padding: 0px; border-bottom: none;" class="pollTd01">
									<div style="min-width: 300px;">
									<input id="searchInput" class="input" type="text" placeholder="제목 검색" style="margin-bottom: 10px; width: 245px;">
									<input id="searchOption" value="title" style="display: none;">
									<a class="imgbtn" style="height: 24px; float: right;"><span style="line-height: 24px;">검색</span></a>
									</div>
									<ul id="columnsbnk" class="content" style="border-bottom: none;">
										<c:forEach items="${list}" var="prelist" varStatus="status">
											<li class="myBorder" name="preladder_${status.index}" id="${prelist.ladderId}" style="cursor: pointer;">
												<span>${status.index }</span>
												<div class="prelist" style="width: 15%">${prelist.type}</div>
												<div class="prelist" style="width: 60%">${prelist.title}</div>
											</li>
										</c:forEach>
									</ul>
									<div id="tblPageRayer" style="margin-top: 10px;"></div>
								</td>
							</tr>
						</table>
			
			
						<%-- <div class="listview" style="overflow: auto;">
							<div id="ListViewid" style="overflow: auto; height: 500px; border: 0px;" >
								<table id="DLList" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="change_onClick" width="100%" border="0" class="mainlist" lastselectedrowid="DLList_TR_2">
									<thead id="DLList_THEAD">
										<tr id="DLList_TH" selected="false" class="" style="background-color: rgb(255, 255, 255);">
											<th id="DLList_TH_0" class="h4_center" bgcolor="#CCCCCC" width="30px">No</th>
											<th id="DLList_TH_1" class="h5_center" width="100px">타입</th>
											<th id="DLList_TH_2" class="h5_center" width="170px">제목</th>
										</tr>
									</thead>
									<tbody style="background-color: rgb(255, 255, 255);">
										<c:forEach items="${list}" var="prelist" varStatus="status">
											<tr id="DLList_TR_${status.index }" selected="false" style="cursor: pointer; background-color: rgb(255, 255, 255);">
												<td height="24" align="left" style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${status.index }</td>
												<td height="24" align="left" style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${prelist.type}</td>
												<td height="24" align="left" style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">${prelist.title}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div> --%>
					</td>
					<td>
						<div id="ladPreviewWrap" style="margin-left: 20px; width: 1000px; height: 700px; border: 1px solid #ddd; overflow-x: hidden; overflow-y: auto;">
							<iframe id="ladderPreview" src="" scrolling="no" frameborder="0" style="width: 1000px; height: 1100px;"></iframe>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
			
			<div class="btnposition btnpositionNew">
				<input type="submit" value="확인" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName">
				<input type="submit" value="취소" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
			</div>
		
			<%-- <div class="popupWrap">
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
			</div> --%>
			    
			                    
		
	</body>
</html>