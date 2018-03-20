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
					<iframe id="tbContentElement" class="viewbox" src="" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
					<textarea id="plainTextArea" style="height:100%; width:100%; overflow-y:scroll; font-size:13px; box-sizing:border-box; display:none;"></textarea>
				</div>
				<!-- 에디터에서 사용 -->
				<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0); display: none;" id="mailPanel">&nbsp;</div>
				<div class="layerpopup"  style="top: 10px; z-index: 2000; position: absolute;display: none;" id="iFramePanel">
					<iframe src="<spring:message code='main.kms4' />" style="border:1px solid #b6b6b6;" id="iFrameLayer"></iframe>
				</div>
				<!-- btns -->
				<div class="leLetterBtns">
					<button id="leSave" onClick="letterSave(this)">저장</button>
					<button id="leClose" onClick="letterPopUpClose()">취소</button>
				</div>
			</div> <!-- leLetter End -->
		</div>
			
		<script>
			var popUpType = "${popUpType}"; // add 작성, modify 수정
			var popLetterBoxNo = "${letterBoxNo}";
			var popLetterId = "${letterId}"; // 수정일 경우  처음에는 null 이후 modifyLoad()에서 저장됨
			var popLetterNo = "${letterNo}"; // 저장일 경우 -1
			var modifyData = ""; // modifyLoad()에서 저장
			
			window.onload = function() {
				console.log(popUpType);
				if (popUpType == "modify") {
					modifyLoad(popLetterNo);
				}
				
				$("#tbContentElement").attr("src", "/ezEditor/selectEditor.do?type=MAILLETTER"); // 에디터
			}
			
			// editor onload 됐을때
			function Editor_Complete() {
				if (popUpType == "modify") {
					modifyDataView();
				}
			}
			
			function modifyDataView() {
				$("#displayname").val(modifyData.displayname);
				$("#displayname2").val(modifyData.displayname2);
				
				window.message.SetEditorContent(modifyData.letterHtml);
			}
			
			function modifyLoad(letterNo) {
				$.ajax({
					type:"POST",
					data:{
						letterNo:popLetterNo,
						popUpType:popUpType
					},
					url:"/admin/ezEmail/readLetter",
					dataType:"json",
					success:function(data){
						popLetterId = data.letterId;
						modifyData = data;
					}
				});
			}
			
			// 저장 버튼 클릭시                  btn -> this
			function letterSave(btn) {
				var letterContent = window.message.GetEditorContent(); // 에디터에 작성한 내용
				var displayname = $("#displayname").val();
				var displayname2 = $("#displayname2").val();
				var letterJson = {};
	
				if (displayname.trim() == "" || displayname2.trim() == "") { // 편지지명 없을때 return
					alert("편지지명을 입력해주세요.");
					return;
				} else if (letterContent.replace(/&nbsp;/gi,"").replace(/<br \/>/gi,"").trim() == "") { // 편지지 작성 X
					alert("편지지를 작성해주세요.");
					return;
				}
				
				letterJson = {
					"displayname" : displayname,
					"displayname2" : displayname2,
					"letterContent" : letterContent,
					"letterBoxNo" : popLetterBoxNo,
					"letterId" : popLetterId,
					"letterNo" : popLetterNo
				};
				
				letterUpload(letterJson, popUpType);
			}
			
			// 저장
			function letterUpload(letterJson, type) {
				var uploadUrl = type == "add" ? "/admin/ezEmail/createLetter.do" : "/admin/ezEmail/updateDisplayNameLetter.do";
				
				$.ajax({
					type:"POST",
					data:letterJson,
					url:uploadUrl,
					success:function(data){
						if (type != "add") { // 수정일때 미리보기창 다시 보여주기
							opener.letterPreView(letterJson.letterNo);	
						}
						
						opener.getLetterList(letterJson.letterBoxNo); // 편지지 리스트

						alert("저장했습니다.");
						letterPopUpClose(); // 편지지 팝업 닫기
					},
					error:function(e){
						console.log(e);
					}
				});
			}
			
			function letterPopUpClose() {
				window.close();
			}
			
		</script>	
	</body>
</html>
