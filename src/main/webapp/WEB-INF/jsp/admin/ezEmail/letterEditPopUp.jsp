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
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
	</head>
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
	<div id="leTop">
		<div class="leTitle">
			편지지 추가
		</div>
		<div class="leLetter">
			<!-- 편지지명, 편지지명(영문) input -->
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
			<!-- editor -->
			<div class="leLetterEditer">
				<iframe id="tbContentElement" class="viewbox" src="/ezEditor/selectEditor.do?type=MAILLETTER" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
				<textarea id="plainTextArea" style="height:100%; width:100%; overflow-y:scroll; font-size:13px; box-sizing:border-box; display:none;"></textarea>
			</div>
			<!-- 에디터에서 사용 -->
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0); display: none;" id="mailPanel">&nbsp;</div>
			<div class="layerpopup"  style="top: 10px; z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:1px solid #b6b6b6;" id="iFrameLayer"></iframe>
			</div>
			<!-- btns -->
			<div class="leLetterBtns">
				<button id="leSave" onClick="letterSave(this)" data-letterId="${letterId }" data-boxNo="${letterBoxNo }">저장</button>
				<button id="leClose" onClick="letterPopUpClose()">취소</button>
			</div>
		</div> <!-- leLetter End -->
	</div>
		
		<script>
			var letterPopUp = true; // 에디터에서 이미지 업로드 할때 편지지 팝업인지 구분 (ckImageUpload.jsp -> fileupload())
			var letterId = $("#leSave").attr("data-letterId");
			var letterBoxNo = $("#leSave").attr("data-boxNo");
			
			// 저장 버튼 클릭시                  btn -> this
			function letterSave(btn) {
				//편지지명, 편지지명(영문), 편지지 내용, 편지지함, 편지지 고유 id
				var letterEditor = document.getElementById("tbContentElement").contentWindow;
				var letterEditorIframe = letterEditor.document.getElementsByTagName("iframe")[0].contentDocument.documentElement;
				
				letterEditorIframe.getElementsByTagName("body")[0].setAttribute("contenteditable",false); // 에디터 작성
				var letterContentChk = letterEditor.GetEditorContent(); // 에디터에 작성한 내용
				var letterContent = letterEditorIframe.outerHTML; // 에디터 html
	
				var letterJson = {
					"displayname" : $("#displayname").val(),
					"displayname2" : $("#displayname2").val(),
					"letterContent" : letterContent,
					"letterBoxNo" : $(btn).attr("data-boxNo"),
					"letterId" : $(btn).attr("data-letterId")
				};
				
				// 편지지명 없을때 return
				if (letterJson.displayname.trim() == "" || letterJson.displayname2.trim() == "") {
					alert("편지지명을 입력해주세요.");
					return;
				}
				// 편지지 작성 X
				if (letterContentChk.replace(/&nbsp;/gi,"").replace(/<br \/>/gi,"").trim() == "") {
					alert("편지지를 작성해주세요.");
					return;
				}
				
				letterUpload(letterJson);
			}
			
			// 저장 기능
			function letterUpload(letterJson) {
				$.ajax({
					type:"POST",
					data:{	displayname:letterJson.displayname,
							displayname2:letterJson.displayname2,
							letterBoxNo:letterJson.letterBoxNo,
							letterId:letterJson.letterId,
							letterContent:letterJson.letterContent},
					url:"/admin/ezEmail/createLetter",
					success:function(data){
						alert("저장했습니다.");
						opener.getLetterList(letterJson.letterBoxNo); // 편지지 리스트
						letterPopUpClose(); // 편지지 팝업 닫기
					},
					error:function(e){
						alert(e);
					}
				});
			}
			
			function letterPopUpClose() {
				window.close();
			}
			
			/* function Editor_Complete(){
				console.log("솨솨");
			} */
		</script>	
	</body>
</html>