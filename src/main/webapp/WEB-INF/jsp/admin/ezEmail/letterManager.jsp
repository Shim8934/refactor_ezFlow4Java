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
						<input type="text" name="" id="lmSearchInput">
						<button id="lmSearch">검색</button>
						<button id="lmSearchReset">초기화</button>
					</div>	
					<div id="divTree" class="lmLetterBoxList"></div>
				</div>
				<!-- 편지지 목록 -->
				<div class="lmLetter">
					<div class="lmtitle lmLetterTitle">
						편지지 목록
					</div> 
					<div class="lmLetterList boxNo" data-boxNo=""> <!-- boxNo -->
						<ul class="lmLetterListUl"></ul>
					</div>
				</div>
				<!-- 버튼 -->
				<div class="lmBtns">
					<div class="boxNo" data-boxNo=""> <!-- boxNo -->
						<button onClick="letterEditPopUp(this, 'add')">편지지 추가</button>
						<button onClick="letterBoxMove(this)">편지지 이동</button>
						<img src="/images/i_bar.gif" alt="line">
						<button class="lmBtnPrev"><img src="/images/ImgIcon/prev.gif" alt="prev"></button>
						<button class="lmBtnNext"><img src="/images/ImgIcon/next.gif" alt="next"></button>
						<button>순서 저장</button>
					</div>
				</div>
			</div>
			
			<div class="lmright">
				<div class="lmPreview"></div>
			</div>			
		</div>
		
		<script type="text/javascript">
			var pageType = "${pageType}";
			var returnCompany = '${companyId}';
			var previewHtml = "<div style='text-align:center; position:relative; top:50%; tansform:translateY(-50%);'>미리보기</div>";
			
			$(document).ready(function(){
				
				resultRead(); // 편지지함 목록
				
				$(".lmPreview").html(previewHtml); //미리보기 text

				
				
				
			}); // document on ready
			
			// 편지지 추가, 수정 클릭 시  || btn -> this, type -> 추가=add
			function letterEditPopUp(btn, type) {
				
				// 편지지함 no
				letterBoxNo = $(btn).parents(".boxNo").attr("data-boxNo");
				// 추가 or 수정 구분
				popUpType = type == "add" ? type : "modify";
				
				//url
				url = "/admin/ezEmail/letterEditPopUp.do?" + "letterBoxNo=" + letterBoxNo + "&type=" + popUpType;  
					
				window.open(url,"_blank","width=890, height=660");
			}
			
			
			// 편지지 목록 ===========================================================================================
			var result = [];
		    var treeCollection = [];
		    var xmlhttp;
		    var responseResult;
		    var selectNode;
		    
		    // ==========================================================================
		    	
			
					
		</script>
	</body>
</html>