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
	<body>
	<style>
		body {
			background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top;
		}
		#leTop {
		}
		.leTitle {
		    /* padding: 3px;
		    color: white; */
		    
		    font-size: 11pt;
		    font-weight: bold;
		    color: rgb(125, 145, 171);
		    height: 44px;
		    margin-left: 1px;
		    margin-bottom: 8px;
		    line-height: 36px;
		}
		.leLetter {
			margin-top: 15px;
		}
		.leLetterInfo {
		    height: 50px;
		}
		.leLetterInfo table {
			width: 100%;
			border-collapse: collapse;
		    empty-cells: show;
		    padding: 0;
		    margin: 0;
		    font-size: 12px;
		    font-family: 'Gulim', 'arial', 'verdana';
		}
		.leLetterInfo th {
			white-space: nowrap;
		    word-break: keep-all;
		    word-wrap: normal;
		    color: #777;
		    background-color: #f8f8f8;
		    border: 1px solid #b6b6b6;
		    padding: 2px 10px;
		}
		.leLetterInfo td {
		    padding: 0px 2px 0px 2px;
		    background: #FFF;
		    border: 1px solid #b6b6b6;
		    height: 29px;
		    word-break: break-all;
		}
		.leLetterInfo table input {
			width: 100%;
			box-sizing: border-box;
		}
		.leLetterEditer {
			width: 100%;
			height: 500px;
			//border: 1px solid black;
			//clear: both;
    		margin: 15px 0;
		}
		.leLetterEditer > iframe {
		    border: none;
	    }
		.leLetterBtns {
			text-align: center;
			margin-top: 30px;
		}
		.leLetterBtns button {
		    background: linear-gradient(#3a5382,#28416d);
		    color: white;
		    border: 1px solid #223151;
		    padding: 3px 10px;
		    border-radius: 4px;
		    cursor: pointer;
	    }
		.leLetterBtns button:hover {
			background: linear-gradient(white,#f3f2f2);
		    color: #393939;
		    border: 1px solid #a5a3a3;
		}
		
		.divFolder {
			height: 280px;
			width: 470px;
			border: 1px solid #ccc;
			margin: auto;
			margin-top: 50px;
			overflow: auto;
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
				 	<button id="leClose">취소</button>
				 </div>
			</div>
		
		</div>
		<script>
			
			// 취소
			$("#leClose").on("click",function(){
				window.close();
			});
			
		    var pageType = "${pageType}";
		    var returnCompany = '${companyId}';
		    var isDivPopUp = false;
		    
		 // 편지지 목록 ===========================================================================================
			var result = [];
		    var treeCollection = [];
		    var selectNode;
		    
			$(document).ready(function(){
				resultRead(); // 편지지함 목록
				isDivPopUp = true;
				
			});
			
			//편지지함 이동(저장)
			function letterBoxSave() {
				var letterBoxNo = selectNode.node.id;
				var letterNo = ${letterNo};
				var query = "/admin/ezEmail/updateLetterMove.do?letterNo=" + letterNo + "&parentLetterBoxNo=" + letterBoxNo;
				$.ajax({
					type : "POST",
					url : query,
					datatype : 'text',
					error : function(data) {
						alert("error");
						console.log(data);
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