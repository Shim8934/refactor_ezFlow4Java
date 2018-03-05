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
			background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top;
		}
		#leTop {
		}
		.leTitle {
		    padding: 3px;
		    color: white;
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
		
		
		/* .leLetterInfo ul {
			padding: 0;
			list-style: none;
			margin:10px 0;
		}
		.leLetterInfo ul li {
			margin-bottom: 5px;
			float: left;
    		width: 100%;
		}
		.leLetterInfo ul li * {
			float:left;
		}
		.leLetterInfo ul li span{ 
			width: 15%;
			display: inline-block;
			margin-left: 2px;
		}
		.leLetterInfo ul li input{ 
			width: 84%;
		} */
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
		
	</style>
		<div id="leTop">
			
			<div class="leTitle">
				편지지 추가
			</div>
			
			<div class="leLetter">
				 <div class="leLetterInfo">
				 	<table>
				 		<colgroup>
				 			<col width="100">
				 			<col width="">
				 		</colgroup>
				 		<tr>
				 			<th>편지지명</th>
				 			<td><input type="text" id="displayname" name="displayname" placeholder="편지지명을 입력해주세요"></td>
				 		</tr>
				 		<tr>
				 			<th>편지지명(영문)</th>
				 			<td><input type="text" id="displayname2" name="displayname2" placeholder="편지지명(영문)을 입력해주세요"></td>
				 		</tr>
				 	</table>
				 	<!-- <ul>
				 		<li>
				 			<span>편지지명</span>
				 			<input type="text" name="" placeholder="편지지명을 입력해주세요">
				 		</li>
				 		<li>
				 			<span>편지지명(영문)</span>
				 			<input type="text" name="" placeholder="편지지명을 입력해주세요">
				 		</li>
				 	</ul> -->
				 </div>
				 <div class="leLetterEditer">
				 	<iframe id="tbContentElement" class="viewbox" src="/ezEditor/selectEditor.do" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
				 	<textarea id="plainTextArea" style="height:100%; width:100%; overflow-y:scroll; font-size:13px; box-sizing:border-box; display:none;"></textarea>
				 </div>
				 <div class="leLetterBtns">
				 	<button id="leSave">저장</button>
				 	<button id="leClose">취소</button>
				 </div>
			</div>
		
		</div>
		<script>
			// 저장
			$("#leSave").on("click",function(){
				// 편지지명 없을때 return
				if ($("#displayname").val().trim() == "" || $("#displayname2").val().trim() == "") {
					alert("편지지명을 입력해주세요.");
					return;
				}
				
				// 편지지 본문
				var gEContent = document.getElementById("tbContentElement").contentWindow.GetEditorContent();
				// 편지지 작성 X
				if (gEContent.replace(/&nbsp;/gi,"").replace(/<br \/>/gi,"").trim() != "") {
					alert("편지지를 작성해주세요.");
					return;
				}
				
				
				
				
			});
			
			// 취소
			$("#leClose").on("click",function(){
				window.close();
			});
			
			
			/* function Editor_Complete(){
				console.log("솨솨");
			} */
		</script>	
	</body>
</html>