<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />		
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterList.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	</head>
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
		<div id="close">
            <ul>
                <li><span onclick="letterPopUpClose()"></span></li>
            </ul>
        </div>
		<div id="leTop">
			<div class="leTitle" style="margin-left:5px;"></div>
			<div class="leLetter"  style="padding:8px; padding-top:3px;">
				<!-- 편지지명, 편지지명(영문) input -->
				<div class="leLetterInfo">
					<table>
						<colgroup>
							<col width="100">
							<col width="">
						</colgroup>
						<tr>
							<th style="font-weight: normal"><spring:message code='ezEmail.letter8'/> (${primary})</th>
							<td><input type="text" id="displayname" name="displayname" maxlength="40" ></td>
						</tr>
						<tr>
							<th style="font-weight: normal"><spring:message code='ezEmail.letter8'/> (${secondary})</th>
							<td><input type="text" id="displayname2" name="displayname2" maxlength="40" ></td>
						</tr>
					</table>
				</div> <!-- leLetterInfo End -->
				<!-- editor -->
				<div class="leLetterEditer" style="height:490px;">
					<iframe id="tbContentElement" class="viewbox" src="" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
					<textarea id="plainTextArea" style="height:100%; width:100%; overflow-y:scroll; font-size:13px; box-sizing:border-box; display:none;"></textarea>
				</div>
				<!-- 에디터에서 사용 -->
				<div style="width: 100%; height: 90%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0); display: none;" id="mailPanel">&nbsp;</div>
				<div class="layerpopup"  style="top: 10px; z-index: 2000; position: absolute;display: none;" id="iFramePanel">
					<iframe src="<spring:message code='main.kms4' />" style="border:1px solid #b6b6b6;" id="iFrameLayer"></iframe>
				</div>
				<!-- btns -->
				<%-- <div class="leLetterBtns">
					<button id="leSave" onClick="letterSave(this)"><spring:message code='main.sp09'/></button>
					<button id="leClose" onClick="letterPopUpClose()"><spring:message code='main.t135'/></button>
				</div> --%>
				
				<div class="btnpositionNew">
		            <a class="imgbtn"><span onClick="letterSave(this)"><spring:message code='main.sp09'/></span></a>
			    </div>
			</div> <!-- leLetter End -->
		</div>
		<script>
			var popUpType = "<c:out value='${popUpType}'/>"; // add 작성, modify 수정
			var popLetterBoxNo = "<c:out value='${letterBoxNo}'/>";
			var popLetterId = "${letterId}"; // 수정일 경우  처음에는 null 이후 modifyLoad()에서 저장됨
			var popLetterNo = "<c:out value='${letterNo}'/>"; // 저장일 경우 -1
			var modifyData = ""; // modifyLoad()에서 저장
			var specialMsg = "<spring:message code='ezEmail.kyj17'/>"; // 해당 특수문자는 입력할 수 없습니다.
			var specialMsg2 = "<spring:message code='ezEmail.letter9'/>"; //
			var lengthMsg = opener.lengthMsg; // "<spring:message code='ezEmail.letter14'/>"; // 자 이하로 입력 가능합니다.
			var contentMsg = "<spring:message code='ezEmail.letter10'/>"; // "<spring:message code='ezEmail.letter15'/>"; // 내용을 입력해주세요.
			var letterNameMsg = "<spring:message code='ezEmail.letter32'/>"; // "<spring:message code='ezEmail.letter32'/>"; // 편지지명은
			var defaultFontAndSize = "${defaultFontAndSize}";
			
			window.onload = function() {
				console.log(popUpType);
				if (popUpType == "modify") {
					document.title = "<spring:message code='ezEmail.letter12'/>";
					$(".leTitle").text("<spring:message code='ezEmail.letter12'/>");
					
					modifyLoad(popLetterNo);
				} else {
					document.title = "<spring:message code='ezEmail.letter3'/>";
					$(".leTitle").text("<spring:message code='ezEmail.letter3'/>");
				}
				
				$("#tbContentElement").attr("src", "/ezEditor/selectEditor.do?type=MAILLETTER"); // 에디터
			}
			
			// editor onload 됐을때
			function Editor_Complete() {
				if (popUpType == "modify") {
					modifyDataView();
				}
				
				rebody();
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
					async: false,
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
				
				// p 태그 margin 
				var pTagmargin = "<style>p {margin-top:0; margin-bottom:0;}</style>";
				
				if (letterContent.indexOf("<style") == -1) {
					letterContent = pTagmargin + letterContent;
				}
				
				
				var disName = strChk(displayname, true, 40, letterNameMsg);
				var disName2 = strChk(displayname2, true, 40, letterNameMsg);
				var msg = disName.msg != "" ? disName.msg : disName2.msg != "" ? disName2.msg : "";
				
				if (msg != "") { // 편지지명 없을때 return
					alert(msg);
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
						/* if (type != "add") { // 수정일때 미리보기창 다시 보여주기
							opener.letterPreView(letterJson.letterNo);	
						} */
						if (opener.searchTxt != "") {
							opener.letterSearch();
						} else {
							opener.getLetterList(letterJson.letterBoxNo); // 편지지 리스트
						}
						alert("<spring:message code='ezEmail.t42'/>");
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
			
			function rebody() {
				if (popUpType != "modify") {
					window.message.SetEditorContent("");
				}
		    }
		</script>	
	</body>
</html>
