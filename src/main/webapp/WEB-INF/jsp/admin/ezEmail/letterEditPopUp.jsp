<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
	    <link rel="stylesheet" href="/css/ezEmail/style.css" />		
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	</head>
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
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
				 </div> <!-- leLetterInfo End -->
				 <div class="leLetterEditer">
				 	<iframe id="tbContentElement" class="viewbox" src="/ezEditor/selectEditor.do?type=MAILLETTER" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
				 	<textarea id="plainTextArea" style="height:100%; width:100%; overflow-y:scroll; font-size:13px; box-sizing:border-box; display:none;"></textarea>
				 </div>
				 <div class="leLetterBtns">
				 	<button id="leSave" data-letterId="${letterId }" data-boxNo="${letterBoxNo }">저장</button>
				 	<button id="leClose">취소</button>
				 </div>
			</div> <!-- leLetter End -->
		
		</div>
		<script>
			// 저장
			$("#leSave").on("click",function(){
				//편지지명, 편지지명(영문), 편지지 내용, 편지지함, 편지지 고유 id
				var displayname = $("#displayname").val();
				var displayname2 = $("#displayname2").val();
				var letterContent = document.getElementById("tbContentElement").cotentWindow.GetEditorContent();
				var letterBoxNo = $(this).attr("data-boxNo");
				var letterId = $(this).attr("data-letterId");
				
				// 편지지명 없을때 return
				if (displayname.trim() == "" || displayname2.trim() == "") {
					alert("편지지명을 입력해주세요.");
					return;
				}
				// 편지지 작성 X
				if (letterContent.replace(/&nbsp;/gi,"").replace(/<br \/>/gi,"").trim() != "") {
					alert("편지지를 작성해주세요.");
					return;
				}
				
				alert(letterBoxNo + "   " + letterId);
		
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