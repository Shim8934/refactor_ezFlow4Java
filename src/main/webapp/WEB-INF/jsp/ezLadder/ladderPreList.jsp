<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t073" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezLadder/ladderPreList.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezLadder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezLadder/ladderList.js')}"></script>
		
		<script type="text/javascript">
			var currPage = <c:out value="${currPage}" />;
			var pageChange = 1;
			var totalPage = <c:out value="${totalPage}" />;
			var totalLadder = <c:out value="${totalLadder}" />;
			var blockSize = 5;
			var mode = "";
			var modeCheck = "<c:out value='${mode}' />";
			var searchSelect = "<c:out value='${searchSelect}' />";
			var searchInput = "<c:out value='${searchInput}' />";
			var searchOption = "off";
			var allData = [];
			var id = "<c:out value='${id}' />";
			var back = "none";
			var retVal;
			var retFunc;
			var retladinfo = [];
			var ladderID = "";
			
			var dragloc = {};
			var droploc = {};
			var changeLadId1;
			var changeLadId2;
			
			document.onkeydown = function (evt) {
	            var e = evt;
	            if (e == null) e = window.event;
	            if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
	                if ((e.keyCode > 47) && (e.keyCode < 58)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode > 95) && (e.keyCode < 106)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode > 64) && (e.keyCode < 91)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode == 106) ||
	                    (e.keyCode == 107) ||
	                    (e.keyCode == 109) ||
	                    (e.keyCode == 110) ||
	                    (e.keyCode == 111) ||
	                    (e.keyCode == 186) ||
	                    (e.keyCode == 187) ||
	                    (e.keyCode == 188) ||
	                    (e.keyCode == 189) ||
	                    (e.keyCode == 190) ||
	                    (e.keyCode == 191) ||
	                    (e.keyCode == 192) ||
	                    (e.keyCode == 219) ||
	                    (e.keyCode == 220) ||
	                    (e.keyCode == 221) ||
	                    (e.keyCode == 222)) {
	                    e.preventDefault();
	                }
	                else if ((e.keyCode == 229)) {
	                    e.returnValue = false;
	                }
	            }
	        }
			
			function changeListOrder() {
				console.log(dragloc["id"]);
				console.log(droploc["id"]);
				var ladId1 = dragloc["id"];
				var ladId2 = droploc["id"]
				changeLadId1 = ladId1;
				changeLadId2 = ladId2;
				changeListOrderComplete();
			}
			
			function changeListOrderComplete() {
				console.log(changeLadId1);
				console.log(changeLadId2);
				$.ajax({
					type: "POST",
					url: "/ezLadder/setListOrder.do",
					dataType: "json",
					traditional: true,
					data: {
						"ladderIds": changeLadId1,
						"changeLadderIds": changeLadId2,
						"mode": modeCheck,
						"currPage": currPage,
						"searchSelect": searchSelect,
						"searchInput": searchInput
					},
					success: function(result) {
						var lines = "";
						$("#columnsbnk").html("");
						$.each(result.list, function(index, value) {
							var preType; 
							switch(value.type) {
								case 0: preType = strLang10;
									break;
								case 1: preType = strLang11;
									break;
								case 2: preType = strLang12;
									break;
								case 3: preType = strLang13;
									break;
							}
							
							lines = '<li name="preladder_' + index + '" id="' + value.ladderId + '" class="myBorder"><span class="icon"><img src="/images/ezLadder/icon_game0' + value.type + '.png" title="' + preType +'"></span><span class="txt"></span></li>';
							$("#columnsbnk").append(lines);
							$("#" + value.ladderId).find(".txt").text(value.title);
						});
						drag(); 
	
					}
				});
			}
			
			function showLadderPreview() {
				var previewSrc = "/ezLadder/getLadderGame.do?ladderId=" + ladderID + "&mode=preview";
				
				var $ladderPreview = $("#ladderPreview");
				$(".ladderPreList_right").scrollTop(0);
				$ladderPreview.attr("src", previewSrc);
			}
			function onMyFrameLoad(obj) {
				var previewObj = obj.contentWindow || obj.contentDocument;
				if(previewObj.document) {
					previewObj = previewObj.document;
				}
				
				var finalH;
				if(navigator.userAgent.toLowerCase().indexOf("msie") != -1) {
					finalH = previewObj.body.offsetHeight + 10;
				} else {
					finalH = previewObj.documentElement.offsetHeight;
				}
				
				obj.style.height = finalH + "px";
				$("#ladderPreviewLayer").css("height", (finalH - 30) + "px")
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
				$("#ladderPreview, #ladderPreviewLayer").css("height", "0px");
				
				/** mouse event */
				var selecColor = "#f1f8ff";
				var overColor = "rgb(244, 245, 245)";
				var origColor = "#FFF";
				$(document)
					.on("click", ".myBorder", function() {
						ladderID = $(this).attr("id");
						showLadderPreview();
					});
				
				/** 이전 리스트 순서 바꾸기 */
				$("#btn_SaveAprLineTempletName").on("click", function() {
					loadPreLadderSetting();
				});
				$("#btn_CancelAprLineTempletName").on("click", function() {
					window.close();
				});
				
				drag();
			});
			
			function viewSearchList(ladderList) {
				var html = "";
				
				modeCheck = "pre";
				pageChange = 1;
				currPage = ladderList["currPage"];
				totalPage = ladderList["totalPage"];
				totalLadder = ladderList["totalLadder"];
				
				$("#columnsbnk").html("");
				ladderList["list"].forEach(function(ladder, index) {
					var searchLadderType;
					switch (ladder["type"]) {
					case 0: searchLadderType = strLang10;
							break;
					case 1: searchLadderType = strLang11;
							break;
 					case 2: searchLadderType = strLang12;
							break;
					case 3: searchLadderType = strLang13;
							break;
					} 
					
					html = '<li name="preladder_' + index + '" id="' + ladder["ladderId"] + '" class="myBorder"><span class="icon"><img src="/images/ezLadder/icon_game0' + ladder["type"] + '.png" title="' + searchLadderType + '" ></span><span class="txt"></span></li>';
					$("#columnsbnk").append(html);
					$("#" + ladder["ladderId"]).find(".txt").text(ladder["title"]);
				});
				
				drag();
				makePageSelPage();
				
			}
			
			function loadPreLadderSetting() {
				if(!!retFunc) {
					retFunc(ladderID);
				}
				
				window.close();
			}
			
			function drag() {
				 $(".myBorder").draggable({ // 드래그 리스트
					revert: "invalid",
					revertDuration: 400,
					zIndex: 5,
					axis: "y",
					addClasses: false,
					start: function(event, ui) {
						var divEl = $(this);
						
						divEl.css("border-top", "1px solid #CCC");
						dragloc = {"id": $(this).attr("id"), "top": divEl.offset().top}; 
						
					}, 
					stop: function() {
						var divEl = $(this);
						
						divEl.css("border-top", "");
					}
				});
				$(".myBorder").droppable({ // 드랍 리스트
					accept: ".myBorder",
					addClasses: false,
					over: function(event, ui) {
						$(this).css("background", "beige");
					},
					out: function() {
						$(this).css("background", "#FFFFFF");
					},
					drop: function(event, ui) {
						var divEl = $(this);
						droploc = {"id": $(this).attr("id"), "top": divEl.offset().top}; 
						
						$("#" + dragloc["id"]).css("z-index", "10").animate({"top": droploc["top"]}, 10, function() {
							$("#" + dragloc["id"]).css("top", (droploc["top"]-dragloc["top"]));
						});
						$("#" + droploc["id"]).css("z-index", "10").animate({"top": dragloc["top"]}, 10, function() {
							$("#" + droploc["id"]).css("top", (dragloc["top"]-droploc["top"]));
						});
						changeListOrder();
					}
				}); 
			}
			
			function Key_event(event) {
				if (window.event) {
					if (window.event.keyCode == 13) {
						searchLadder();
					}
				}
				else {
					if (e.which == 13)
						searchLadder();
				}
			}
			
			function keyword_Clear() {
				$("#searchInput").val("");
			}
			
			function window_close() {
	             window.returnValue = 0;
	             window.close();
	        } 
		</script>
</head>
	<body class="popup">
		<h1 id="h1Title"><spring:message code="ezLadder.t073" /></h1>
		<div id="close">
		    <ul>
		    	<li><span onclick="window_close()"></span></li>
		    </ul>
	    </div>
			<div class="ladderPreList_wrap">
				<div class="ladderPreList_contents">
					<div class="ladderPreList_left">
						<div class="search_title">
							<input type="text" id="searchInput" class="input_text" onfocus="this.className='input_text focus';" onkeyup="Key_event(event);" onmousedown="keyword_Clear();" />
							<input id="searchOption" value="title" style="display: none;">
							<input type="image" src="/images/ezLadder/search_btn.gif" alt="" class="search_btn" onclick="searchLadder();" />
						</div>
						<ul id="columnsbnk" class="game_list content">
							<c:forEach items="${list}" var="prelist" varStatus="status">
								<li name="preladder_${status.index}" id="${prelist.ladderId}" class="myBorder"><span class="icon"><img src="/images/ezLadder/icon_game0${prelist.type}.png" title="<spring:message code='ezLadder.t10${prelist.type+1}'/>"></span><span class="txt"><c:out value="${prelist.title}" /></span></li>
							</c:forEach>
						</ul>
						<div id="tblPageRayer" style="margin-top: 10px;"></div>
					</div>
					<div class="ladderPreList_right" style="position: relative;">
						<div id="ladderPreviewLayer" style="width: 894px; position: absolute; z-index: 1000; background: white; opacity: 0;"></div>
						<iframe id="ladderPreview" src="" scrolling="no" frameborder="0" style="width: 877px;" onload="onMyFrameLoad(this)"></iframe>
					</div>
				</div>
			</div>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName"><span><spring:message code='ezEmail.t38' /></span></a>
			<%-- <input type="submit" value="<spring:message code='ezEmail.t38' />" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName"> --%>
		</div>
	</body>
</html>