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
		
		window.onload = function() {
			if (type == "modify") {
				document.title = "서명 템플릿 수정";
				$(".leTitle")[0].innerText = "서명 템플릿 수정";
				document.getElementById("displayname").value = displayname;
				document.getElementById("displayname2").value = displayname2;
				
			} else {
				document.title = "서명 템플릿 추가";
				$(".leTitle")[0].innerText = "서명 템플릿 추가";
			}
			
			$("#tbContentElement").attr("src", "/ezEditor/selectEditor.do?type=MAILLETTER");
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
								<tr>
									<td>이름</td>
								</tr>
								<tr>
									<td>이메일</td>
								</tr>
								<tr>
									<td>부서</td>
								</tr>
								<tr>
									<td>직위</td>
								</tr>
								<tr>
									<td>직책</td>
								</tr>
								<tr>
									<td>생년월일</td>
								</tr>
								<tr>
									<td>사번</td>
								</tr>
								<tr>
									<td>사내전화</td>
								</tr>
								<tr>
									<td>전화번호</td>
								</tr>
								<tr>
									<td>이동전화</td>
								</tr>
								<tr>
									<td>팩스번호</td>
								</tr>
							</tbody>
						</table>
						
						<table class="content" style="width:100%; border:none; margin-top:10px;">
							<thead id="inputInfoDetail">
								<tr>
									<th style="text-align:center;"><b>ID</b></th>
									<td></td>
								</tr>
								<tr>
									<th style="text-align:center;"><b>내용</b></th>
									<td></td>
								</tr>
								<tr>
									<th style="text-align:center;"><b>타입</b></th>
									<td></td>
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
							</thead>
						</table>
					</div>
				</div>
				
				</div>
				
				<div class="btnpositionNew">
		            <a class="imgbtn"><span onClick=""><spring:message code='main.sp09'/></span></a>
		            <a class="imgbtn"><span onClick="">미리보기</span></a>
			    </div>
			</div>
		</div>
	</body>
</html>
