<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<!-- <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css"> -->	
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	</head>
	<body>
	<style>
		body {
			margin: 0;
		}
		#lmTop {
			width: 1200px;
			margin-top: 5px;
		}
		#lmTop > div {
			float: left;
			height:600px;
		}
		#lmTop button {
		    background: white;
		    border: 1px solid #c6c6c6;
		    border-radius: 3px;
		    font-size: 12px;
		    color: #393939;
		    cursor: pointer;
		    outline: none;
		    height: 20px;
   	 		line-height: 1;
		}
		#lmTop button:hover {
			color: #0B790E;
		}
		.lmtitle {
			height: 30px;
		    background: #f8f8f8;
		    border-bottom: 1px solid #cbcbcb;
		    font-weight: bold;
		    color: #777;
		    font-size: 12px;
		    line-height: 30px;
		    box-sizing: border-box;
		    padding: 0 4px;
	    }
		.lmleft {
			width: 360px;
			width: 30%;
			margin-right: 20px;
		}
		.lmLetterBox {
			height:32%;		
			border: #b6b6b6 1px solid;
		}
		.lmLetterBoxTitle > div{
			width: 70px;
	    	border-right: 1px solid #cbcbcb;
	    	display: inline-block;
		}
		.lmLetterBoxTitle > input{
			width: 170px; 
			color: #393939;
			border: 1px solid #cbcbcb;
		}
		.lmLetter {
			height:60%;		
			border: #b6b6b6 1px solid;
		}
		.lmBtns {
			height:5%;	
		}
		.lmleft > div:nth-child(2) {
			margin: 10px 0;
		}
		.lmright {
			width: 60%; 
			border: #b6b6b6 1px solid;
		}
		.lmLetterListUl {
			list-style: none;
		    padding: 0;
		    margin: 0;
		    font-size: 12px;
		    color: #5b5a5a;
		    text-align: left;
		}
		.lmNoData {
			text-align: center;
		}
		.lmLetterListUl li {
			height: 30px;
		    line-height: 30px;
		    box-sizing: border-box;
		    border-bottom: 1px solid #ebebed;
		    padding: 0 4px;
		}
		.lmLetterListUl li span { 
			width:250px;
			margin-right:10px;
		    display: inline-block;
		    cursor: pointer;
    		overflow: hidden;
    		text-overflow: ellipsis; 
    		white-space: nowrap;
    		float: left;
		}
		.lmBtns button {
			height: 25px !important;
		}
		.lmBtns div {
			float: right;
		}
		.lmBtns div button, img {
			float: left;
			margin: 0 3px;
		}
		.lmPreview {
			height: 100%;
		    overflow: auto;
		}
	</style>
		<div id="lmTop">
			
			<div class="lmleft">
				<!-- 편지지함 목록 -->
				<div class="lmLetterBox">
					<div class="lmtitle lmLetterBoxTitle">
						<div>편지지 검색</div>
						<input type="text" name="" id="lmSearchInput">
						<button id="lmSearch">검색</button>
						<button id="lmSearchReset">초기화</button>
					</div>	
					<div class="lmLetterBoxList">
						냠냠
					</div>
				</div>
				<!-- 편지지 목록 -->
				<div class="lmLetter">
					<div class="lmtitle lmLetterTitle">
						편지지 목록
					</div>
					<div class="lmLetterList">
						<ul class="lmLetterListUl">
							<li class="lmNoData">데이터가 없습니다.</li>
							<li>
								<span>결혼축하 편지지</span>
								<button class="lmLetterModifyBtn" onClick="letterEditPopUp()">수정</button>
								<button class="lmLetterDeleteBtn">삭제</button>
							</li>
							<li>
								<span>결혼축하 편지지 디디디ㅣ디디 냠냠냠냔ㅁfffffffff</span>
								<button class="lmLetterModifyBtn" onClick="letterEditPopUp()">수정</button>
								<button class="lmLetterDeleteBtn">삭제</button>
							</li>
						</ul>
					</div>
				</div>
				<!-- 버튼 -->
				<div class="lmBtns">
					<div>
						<button onClick="letterEditPopUp()">편지지 추가</button>
						<button>편지지 이동</button>
						<img src="/images/i_bar.gif" alt="line">
						<button class="lmBtnPrev"><img src="/images/ImgIcon/prev.gif" alt="prev"></button>
						<button class="lmBtnNext"><img src="/images/ImgIcon/next.gif" alt="next"></button>
						<button>순서 저장</button>
					</div>
				</div>
			</div>
			
			<div class="lmright">
				<div class="lmPreview">
					
				</div>
			</div>
			
		</div>
		
		<script type="text/javascript">
			var previewHtml = "<div style='text-align:center; position:relative; top:50%; tansform:translateY(-50%);'>미리보기</div>";
			
			$(document).ready(function(){
				
				$(".lmPreview").html(previewHtml); //미리보기 text

				//검색 버튼 클릭
				$("#lmSearch").on("click",function(){
					if($("#lmSearchInput").val().trim() == "") {
						alert("검색어를 입력해주세요.");
						return;
					}
					//ajax
					
				});
				//검색어 초기화
				$("#lmSearchReset").on("click",function(){
					$("#lmSearchInput").val("");
				});
				
				//편지지 삭제
				$(".lmLetterListUl lmLetterDeleteBtn").on("click",function(){
					var deleteChk = confirm("정말로 삭제하시겠습니까?");
					
					//ajax
					
					if(deleteChk) {
						alert("삭제 야호!");
					}
					
				});
				
				// 편지지 선택
				$(".lmLetterListUl li span").on("click",function(){
					$(this).parent("li").css("background","#e9f1ff");
					$(this).parents("ul").find(".lmLetterSelect").css("background","none").removeClass("lmLetterSelect");
					$(this).parent("li").addClass("lmLetterSelect");
				});
				
				// 편지지 마우스 올릴때 
				$(".lmLetterListUl li span").not(".lmLetterSelect").on("mouseover",function(){
					$(this).parent("li").not(".lmLetterSelect").css("background","#f8f8f8");
				});
				
				// 편지지 마우스 땔때
				$(".lmLetterListUl li span").not(".lmLetterSelect").on("mouseleave",function(){
					$(this).parent("li").not(".lmLetterSelect").css("background","none");
				});
				
			}); // document on ready
			
			function letterEditPopUp() {
				window.open("/admin/ezEmail/letterEditPopUp.do","_blank","width=890, height=660");
			}
			
					
		</script>
	</body>
</html>