<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />
	    <link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
	    <script src="${util.addVer('/js/dist/jstree.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    
	</head>
	<script>
		function saveBtn() {
			// 허용여부, ip주소, 설명 가져오기
			var formData = $("#myForm").serialize();
			var formUrl = "/ezSystem/insertIPBand.do";
			
			// 먼저 &!@#$%^ 이런거 체크 후, 아이피 중복되는지 체크
			// 메서드 만들어서 하기
			
			//ip주소
			formData = formData.split("ipBand=");
			var ipAddress = "";
			var access = "YES";
			var explanation = "";
			
			// ip주소
			for (var i = 1; i < formData.length; i++) {
				ipAddress += formData[i];
			}
			formData = "";
			ipAddress = replaceAll(ipAddress, "&", ".");
			// 허용 여부
			if (!document.getElementById("ipAllow1").checked) {
				access = "NO";
			}
			// 설명
			explanation = document.getElementById("explanText").value;
			formData = "ipAddress=" + ipAddress + "&access=" + access + "&explanation=" + explanation;
			
			$.ajax({
				type : "POST",
				url : formUrl,
				cache : false,
				data : formData,
				error : function(data) {
					alert("저장을 실패하였습니다.");
					console.log(data);
				},
				complete : function(data) {
					alert("저장하였습니다."); // 저장 후 parentWindow refresh하기
				}
			});
			
		}
		
		function replaceAll(str, searchStr, replaceStr) {
			return str.split(searchStr).join(replaceStr);
		}
		
	</script>
	
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
        <div id="leTop">			
			<div class="leTitle" style="padding-left:10px">IP 주소 설정</div>
			
			<table class="content" style="width:95%; margin:auto;">
				<tr>
					<th>허용여부</th>
					<td>
						<label id="la1"><input type="radio" id="ipAllow1" name="ipAllow" Checked>&nbsp;<span style="vertical-align:middle;">허용</span></label>
	                	<label id="la2"><input type="radio" id="ipAllow2" name="ipAllow">&nbsp;<span style="vertical-align:middle;">거부</span></label>
	                </td>
			    </tr>
			    <tr>
					<th>IP주소</th>
					<td><form id="myForm"><input name="ipBand" type="text" size="3" maxlength="3" id="ipBand1">.<input name="ipBand" type="text" size="3" maxlength="3" id="ipBand2">.<input name="ipBand" type="text" size="3" maxlength="3" id="ipBand3">.<input name="ipBand" type="text" size="3" maxlength="3" id="ipBand4"></form>
						&nbsp;<span>예)10.0.0.* 또는 127.0.0.1</span>
			    </tr>
			    <tr>
					<th>설명</th>
					<td><textarea style="width:96%;resize:none;"id="explanText" rows="3"> </textarea></td>
			    </tr>
			</table>
			
			<div class="btnpositionNew" style="margin:0px">
			 	<a class="imgbtn"><span onclick="saveBtn()"><spring:message code='main.sp09'/></span></a> 	
			 </div>
		</div>
	</body>
</html>