<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<!-- <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css"> -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="/css/default_kr.css" type="text/css" />
	    <link rel="stylesheet" href="/css/ezEmail/style.css" />
	    <link rel="stylesheet" href="/js/dist/themes/default/style.min.css" />
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script src="/js/dist/jstree.min.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterBoxTree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterList.js"></script>
	</head>
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
	<style>
		.leLetterBtns {
			text-align: center;
			margin-top: 30px;
		}
		
		.divFolder {
			height: 280px;
			width: 470px;
			border: 1px solid #ccc;
			margin: auto;
			margin-top: 35px;
			overflow: auto;
			box-sizing: border-box;
    		padding: 5px;
		}
		
	</style>
	
		<div id="leTop">
			
			<div class="leTitle">
				편지지 이동
			</div>
			
			<div class="divFolder" id="divTree"></div>
			
			<div class="leLetter">
				 <div class="leLetterBtns">
				 	<button id="leSave" data-letterNo="${letterNo}" onclick="letterBoxSave()">저장</button>
				 	<button id="leClose" onclick="window.close()">취소</button>
				 </div>
			</div>
		
		</div>
		<script>
		    var pageType = "${pageType}";
		    var returnCompany = '${companyId}';
		    var userLang = '${userLang}';
		    var isDivPopUp = false;
		    
			var result = [];
		    var treeCollection = [];
		    var selectNode;
		    
			$(document).ready(function(){
				resultRead(); // 편지지함 목록
				isDivPopUp = true;
			});
			
			// 편지지함 이동(저장)
			function letterBoxSave() {
				var letterBoxNo = selectNode.node.id;
				var letterBox = ${letterBox};
				var letterNo = ${letterNo};
				var letterId = '${letterId}';
				var query = "/admin/ezEmail/updateLetterMove.do?letterBox=" + letterBox + "&letterNo=" + letterNo + "&parentLetterBoxNo=" + letterBoxNo +"&letterId=" + letterId;
				 
				$.ajax({
					type : "POST",
					url : query,
					datatype : 'text',
					error : function(data) {
						alert("error");
						//console.log(data);
					},
					success : function(data) {
						alert("편지지 이동하였습니다");
						window.close();
					}
				}); 
			}  
		</script>	
	</body>
</html>