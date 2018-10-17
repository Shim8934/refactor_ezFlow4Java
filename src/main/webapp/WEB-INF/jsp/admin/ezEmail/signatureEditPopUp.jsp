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
	    <link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<style>
		.inputInfoBtn {
		    float: left;
		    position: relative;
		    left: 36%;
		}
	</style>
	<script>
		var type = "${type}"
		var signNo = "${signNo}";
		var displayname = "${displayname}";
		var displayname2 = "${displayname2}";
		var defaultFontAndSize = "${defaultFontAndSize}";
		var m_strColorSelect = "#edf4fd";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		var m_strColorOpened = "#fafafa";
		
		window.onload = function() {
			$("#tbContentElement").attr("src", "/ezEditor/selectEditor.do?type=MAILSIGNTEMPLATE");
			var titleTxt = "추가";
			
			if (type == "modify") {
				titleTxt = "수정";
			} 
			
			document.title = "서명 템플릿 " + titleTxt;
			$(".leTitle")[0].innerText = "서명 템플릿 " + titleTxt;
			
			
			// 입력정보 클릭, mouse over 이벤트 추가
			// 입력정보 리스트 기준은 (조직도>사원추가>우편번호, 집주소 빼고 전부)
			inputInfoListEvent();
		}
		
		function inputInfoListEvent() {
			var infoBody = document.getElementById("inputInfoBody");
			var infoBodyChild = infoBody.children;
			
			for (var i = 0; i < infoBodyChild.length; i++) {
				infoBodyChild[i].onclick = function() { event_listclick(this); };
				infoBodyChild[i].onmouseover = function () { event_listMover(this); };
				infoBodyChild[i].onmouseout = function () { event_listMout(this); };
			}
		}
		
		function event_listclick(obj) {
			var prevSelected = $("#inputInfoBody tr[selected=true]")[0];
        	if (prevSelected != undefined) {
        		prevSelected.childNodes[1].style.backgroundColor = m_strColorDefault;
	        	prevSelected.setAttribute("selected", "false");
        	}
        	
			obj.childNodes[1].style.backgroundColor = m_strColorSelect;
        	obj.setAttribute("selected", "true");
        	
        	changeInfoTarget(obj);
		}
		
		function changeInfoTarget(obj) {
			document.getElementById("infoIdTarget").innerHTML = obj.getAttribute("infoid");
			document.getElementById("infoContentTarget").innerHTML = obj.getAttribute("infocontent");
			document.getElementById("infoTypeTarget").innerHTML = obj.getAttribute("infotype");
		}
		
		function event_listMover(obj) {
        	if (obj.getAttribute("selected") != "true") {
        		obj.childNodes[1].style.backgroundColor = m_strColorOver;
        	}
        	
        }
        
        function event_listMout(obj) {
        	if (obj.getAttribute("selected") != "true") {
        		obj.childNodes[1].style.backgroundColor = m_strColorDefault;
        	}
        }
		
		
		function saveSignTemplate() {
			displayname = document.getElementById("displayname").value;
			displayname2 = document.getElementById("displayname2").value;
			content = window.message.GetEditorContent();
			
			var disName1Chk = strChk(displayname);
			var disName2Chk = false;
			
			if (disName1Chk) {
				disName2Chk = strChk(displayname2);
			} else {
				return;
			} 
			
			if (disName1Chk && disName2Chk) {
				var url = "/admin/ezEmail/setSignatureTemplate.do?displayname=" + encodeURIComponent(displayname) + "&displayname2=" + encodeURIComponent(displayname2) + "&content=" + encodeURIComponent(content);
				
				if (type == "modify") {
					url += "&signNo=" + signNo + "&type=" + type;
				} else {
					url += "&type=" + type;
				}
				
				$.ajax({
	        		type : "POST",
	        		url : url,
	        		datatype : 'json',
	        		error : function(data) {
	        			alert("error");
	        			console.log(data);
	        		},
	        		complete : function(data) {
	        			alert("저장하였습니다.");
	        			window.close();
	        			$(opener.document).find("#signList *").remove();
	        			opener.signatureTemplateView();
	        	    }
	        	});
			}
		}
		
		// 템플릿명 체크
		function strChk(txt) {
			var strTrim = txt.trim();
			
			//var speCha = /[`~!<>@#$%^&*|\\\"\';:\/?]/gi;
			
			if (strTrim == '' || strTrim.length == 0) {
				alert("서명 템플릿명을 입력해주세요.");
				return;
			}
			
			if (txt.length > 50) {
				alert("템플릿명은 최대 50자를 넘을 수 없습니다.");
				return;
			}
			
			/* if (speCha.test(strTrim)) {
				alert("템플릿명을 정확히 입력해주세요.");
				return;
			} */
			
			return true;
		}
		
		// editor onload 됐을때
		function Editor_Complete() {
			if (type == "modify") {
				modifyDataView();
			}
			
			rebody();
		}
		
		function rebody() {
			if (type != "modify") {
				window.message.SetEditorContent("<P " + defaultFontAndSize + "></P><P " + defaultFontAndSize + "></P>");
			}
	    }
		
		function modifyDataView() {
			document.getElementById("displayname").value = displayname;
			document.getElementById("displayname2").value = displayname2;
			window.message.SetEditorContent(document.getElementById("signatureTemplate").innerHTML);
		}
		
		function previewSignTemplate() {
			var contentStr = window.message.GetEditorContent();
			
			if (contentStr !== undefined) {
				url = "/admin/ezEmail/signaturePreviewContent.do?content=" + encodeURIComponent(contentStr);
		    	window.open(url,"_blank","width=890, height=660");
			}
			
		}
	
	</script>
	
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
		<div id="close">
            <ul>
                <li><span onclick="letterPopUpClose()"></span></li>
            </ul>
        </div>
		<div id="leTop">
			<div class="leTitle" style="margin-left:5px;"></div>
			<div class="leLetter"  style="padding:8px; padding-top:3px;">
				<div class="leLetterInfo">
					<table>
						<colgroup>
							<col width="100">
							<col width="">
						</colgroup>
						<tr>
							<th style="font-weight: normal">서명 템플릿명 (한글)</th>
							<td><input type="text" id="displayname" name="displayname" maxlength="40" placeholder="서명 템플릿명을 입력해주세요."></td>
						</tr>
						<tr>
							<th style="font-weight: normal">서명 템플릿명 (영문)</th>
							<td><input type="text" id="displayname2" name="displayname2" maxlength="40" placeholder="서명 템플릿명을 입력해주세요."></td>
						</tr>
					</table>
				</div>
				
				<div>
				<div class="leLetterEditer" style="height:490px;">
					<iframe id="tbContentElement" class="viewbox" src="" name="message" style="padding:0; height:100%; width:70%;float:left; overflow:auto;"></iframe>
					<div style="margin-left:10px; float:left; height:100%; width:280px;">
						<table class="content" style="width:100%; border:none;">
							<thead id="inputInfoHeader">
								<tr>
									<th style="text-align:center;"><b>입력정보</b></th>
								</tr>
							</thead>
							
							<tbody id="inputInfoBody">
								<tr style="cursor: pointer;" infoId="signName" infoContent="사용자 이름" infoType="TD" >
									<td>이름</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signEmail" infoContent="이메일" infoType="TD">
									<td>이메일</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signDept" infoContent="부서" infoType="TD">
									<td>부서</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signPosition" infoContent="직위" infoType="TD">
									<td>직위</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signResponsibilities" infoContent="직책" infoType="TD">
									<td>직책</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signBirth" infoContent="생년월일" infoType="TD">
									<td>생년월일</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signCompanyNum" infoContent="사번" infoType="TD">
									<td>사번</td>
								</tr>
								<tr  style="cursor: pointer;"infoId="signComapnyPhone" infoContent="사내전화" infoType="TD">
									<td>사내전화</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signPhone" infoContent="전화번호" infoType="TD">
									<td>전화번호</td>
								</tr >
								<tr style="cursor: pointer;" infoId="signMovePhone" infoContent="이동전화" infoType="TD">
									<td>이동전화</td>
								</tr>
								<tr style="cursor: pointer;" infoId="signFaxNumber" infoContent="팩스번호" infoType="TD">
									<td>팩스번호</td>
								</tr>
							</tbody>
						</table>
						
						<table class="content" style="width:100%; border:none; margin-top:10px;">
							<tbody id="inputInfoDetail">
								<tr>
									<th style="text-align:center;"><b>ID</b></th>
									<td id="infoIdTarget"></td>
								</tr>
								<tr>
									<th style="text-align:center;"><b>내용</b></th>
									<td id="infoContentTarget"></td>
								</tr>
								<tr>
									<th style="text-align:center;"><b>타입</b></th>
									<td id="infoTypeTarget"></td>
								</tr>
								<tr>
									<td align="center" colspan="2" height="40px" style="border: 0px;">
										<div id="mainmenu" style="margin-top: 7px;">
											<ul style="width: 100%;">
												<li class="inputInfoBtn"><span>적 용 </span></li>
												<li class="inputInfoBtn"><span>취 소 </span></li>
											</ul>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				</div>
				
				<div class="btnpositionNew">
		            <a class="imgbtn"><span onClick="saveSignTemplate()"><spring:message code='main.sp09'/></span></a>
		            <a class="imgbtn"><span onClick="previewSignTemplate()">미리보기</span></a>
			    </div>
			</div>
		</div>
		
		<xml id="signatureTemplate" style="display: none;">${content}</xml>
	</body>
</html>
