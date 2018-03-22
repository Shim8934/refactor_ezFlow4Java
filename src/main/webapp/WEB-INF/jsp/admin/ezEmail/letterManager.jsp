<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
	    <link rel="stylesheet" href="/js/dist/themes/default/style.min.css" />
	    <link rel="stylesheet" href="/css/ezEmail/style.css" />	
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script src="/js/dist/jstree.min.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterBoxTree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterList.js"></script>
	</head>
	<body>
		<div id="lmTop">
			
			<div class="lmleft">
				<!-- 편지지함 목록 -->
				<div class="lmLetterBox">
					<div class="lmtitle lmLetterBoxTitle">
						<div>편지지 검색</div>
						<input type="text" name="" id="lmSearchInput" class="searchInput">
						<button id="lmSearch" onclick="letterSearch()">검색</button>
						<button id="lmSearchReset" onclick="inputReset()">초기화</button>
					</div>	
					<div id="divTree" class="lmLetterBoxList"></div>
				</div>
				<!-- 편지지 목록 -->
				<div class="lmLetter">
					<div class="lmtitle lmLetterTitle">
						편지지 목록 
					</div> 
					<div class="lmLetterList boxNo" data-boxNo=""> <!-- boxNo -->
						<ul class="lmLetterListUl lmLetterListWrap"></ul>
					</div>
				</div>
				<!-- 버튼 -->
				<div class="lmBtns">
					<div class="boxNo" data-boxNo=""> <!-- boxNo -->
						<button onClick="letterEditPopUp(this, 'add')">편지지 추가</button>
						<button onClick="letterBoxMove(this)">편지지 이동</button>
						<img src="/images/i_bar.gif" alt="line">
						<button class="lmBtnPrev" onclick="orderPrev()"><img src="/images/ImgIcon/prev.gif" alt="prev"></button>
						<button class="lmBtnNext" onclick="orderNext()"><img src="/images/ImgIcon/next.gif" alt="next"></button>
						<button onclick="orderChange()">순서 저장</button>
					</div>
				</div>
			</div>
			
			<div class="lmright">
				<div class="lmPreview">
					<div class="lmPreViewTxt"style='text-align:center; position:relative; top:50%; tansform:translateY(-50%);'>미리보기</div>
					<iframe src="" class="lmPreViewIframe" id="lmPreViewIframe" name="lmPreViewIframe" style="display:none; border:none; width:100%; height:100%;"></iframe>
				</div>
			</div>			
		</div>
		
		<script type="text/javascript">
			// resultRead() 사용 *
			var result = [];
		    var treeCollection = [];
		    var xmlhttp;
		    var responseResult;
		    var selectNode;
		    var noResult = false; 
			var pageType = "${pageType}"; // letter
			var returnCompany = '${companyId}'; // companyId
			
			$(document).ready(function(){
				resultRead(); // 편지지함 목록  (/js/ezEmail/js_cross/letterBoxTree.js)
			});
			
			// 순서 번경(위로 올리기)
			function orderPrev() {
				var select= $('body').find('.lmLetterSelect');
				
				if (select.length == 0) {
					alert("편지지를 선택하세요!");
					return;
				}
				
				select.prev().before(select);
			}
			
			// 순서 변경(아래로 내리기)
			function orderNext() {
				var select = $('body').find('.lmLetterSelect');
				
				if (select.length == 0) {
					alert("편지지를 선택하세요!");
					return;
				}
					
				select.next().after(select);
			}
			
			// 순서 저장 버튼 눌렀을때
			function orderChange() {
				var liArr = $('div.lmLetter').find('li');
				
				for (var i = 0; i < liArr.length; i++) {
					var letterNo = $(liArr[i]).attr("data-letterno");
					
					$.ajax({
						type:"POST",
						url:"/admin/ezEmail/updateLetterOrder.do?letterOrder=" + (i + 1) + "&" + "letterNo=" + letterNo,
						dataType:"text",
						error:function(data) {
							alert("error");
							console.log(data);
							return;
						}
					});
				}
				
				alert("순서를 저장하였습니다");
				getLetterList(selectNode.node.id);
			}
			
			// 편지지 이동
			function letterBoxMove(btn){
				var letterBox = selectNode.node.id;
				var letterNo = $(".lmLetterSelect").attr("data-letterno");
				var letterId = $(".lmLetterSelect").attr("data-letterid");
				
				if (typeof letterNo !== "undefined") {
					
					url = "/admin/ezEmail/letterBoxMovePopUp.do?letterBox=" + letterBox + "&letterNo=" + letterNo + "&letterId=" + letterId;  
					var win = window.open(url,"_blank","width=550, height=450");
					
					var interval = window.setInterval(function() {
				        try {
				            if (win == null || win.closed) {
								getLetterList(selectNode.node.id);
				            	window.clearInterval(interval);
				                closeCallback(win);
				            }
				        } catch (e) {
				        }
				    }, 100);
					
				} else {
					alert("이동할 편지지를 선택해주세요!");
					return;
				}
			}

			// 편지지 추가, 수정 btn 클릭 시     btn -> this, type -> 추가=add, modify일때 type 안받음
			function letterEditPopUp(btn, type) {
				var popUpType = type == "add" ? type : "modify"; // 클릭된 버튼 구분(추가 or 수정)
				var letterBoxNo = $(btn).parents(".boxNo").attr("data-boxNo"); // 편지지함 no
				var letterNo = type == "add" ? -1 : $(btn).parents("li").attr("data-letterno");
				
				var url = "/admin/ezEmail/letterEditPopUp.do?" + "letterBoxNo=" + letterBoxNo + "&popUpType=" + popUpType + "&letterNo=" + letterNo;
				var letterPopUp = window.open(url, "letterPopUp", "width=890, height=660");
			}
			
			
			$(document).on("mouseover", ".lmPreview > .lmPreViewIframe", function(){
				var letterName = $(this).attr("data-letterName");
				var letterNameSpan = "<span class='preViewLetterName'>" + letterName + "</span>";
				
				$(".lmPreview").prepend(letterNameSpan);
				$(".preViewLetterName").css({
					"padding" : "3px 10px",
					"color" : "white",
					"background" : "rgba(0,0,0,0.5)",
					"position" : "absolute",
					"right" : "5px",
					"top" : "5px",
					"font-size" : "14px"
				});
				
			})
			
			
			
			/* $(".lmPreview > .lmPreViewIframe").on("mousemove",function(event){
				
				var letterName = $(this).attr("data-letterName");
				var letterNameSpan = "<span class='preViewLetterName'>" + letterName + "</span>";
				
				$(".lmPreview").prepend(letterNameSpan);
				$(".preViewLetterName").css({
					"padding" : "3px 10px",
					"color" : "white",
					"background" : "rgba(0,0,0,0.5)",
					"position" : "absolute"
				});
				
				var mouseX = event.pageX;
				var mouseY = event.pageY;

				$(".preViewLetterName").css({
					"left" : mouseX + 10 + "px",
					"top" : mouseY + 10 + "px"
				});
				
				
			}) */
			
			$(document).on("mouseleave", ".lmPreview > .lmPreViewIframe:not(.preViewLetterName)", function(){
				$(".lmPreview .preViewLetterName").remove();
			})
				
		</script>
	</body>
</html>
