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
		var _type = "${type}";
		var _ipNo = "${ipNo}";
		var _ipAddress = "${ipAddress}";
		var _access = "${access}";
		var _explanation = "${explanation}";
	
		window.onload = function () {
			if (_type === 'modify') {
				var ipAddressTemp = _ipAddress.split(".");
				
				for (var i = 1; i <= ipAddressTemp.length; i++) {
					document.getElementById("ipBand" + i).value = ipAddressTemp[i-1];
				}
				
				if (_access == "YES") {
					document.getElementById("ipAllow1").checked = true;
					document.getElementById("ipAllow2").checked = false;
				} else {
					document.getElementById("ipAllow2").checked = true;
					document.getElementById("ipAllow1").checked = false;
				}
				
				document.getElementById("explanText").value = _explanation;
			}
		}
		
		// IP주소에 들어갈수 있는 값 체크 (숫자/*만 가능)
		function textChk(txt) {
			var regexp = /^[0-9*]*$/;
			
			if(!regexp.test(txt)) {
				return false;
			} else{
				return true;
			}
		}
	
		function saveBtn() {
			var formData = $("#myForm").serialize();
			var formUrl = "/ezSystem/insertIPBand.do";
			
			formData = formData.split("ipBand=");
			var ipAddress = "";
			var access = "YES";
			var explanation = "";
			
			for (var i = 1; i < formData.length; i++) {
				
				if (i != formData.length - 1) {
					formData[i] = formData[i].substring(0, formData[i].length - 1);
				}
				
				if (!textChk(formData[i]) || formData[i].length == 0 || formData[i] == "") {
					alert("IP주소를 정확히 입력해주세요.");
					return;
				}
				
				ipAddress = ipAddress + "." + formData[i];
				
			}
			ipAddress = ipAddress.substring(1, ipAddress.length);
			
			var allIPList = window.opener.allIPList;
			
			for (var i = 0; i < allIPList.length; i++) {
				if (allIPList[i].ipAddress == ipAddress) { // IP 중복 되었을때
					alert("IP주소가 중복되었습니다.");
					return;
				}
			}
			
			formData = "";
			if (!document.getElementById("ipAllow1").checked) {
				access = "NO";
			}
			
			explanation = document.getElementById("explanText").value;
			formData = "ipAddress=" + ipAddress + "&access=" + access + "&explanation=" + explanation;
			
			if (_type == "modify") {
				formUrl = "/ezSystem/updateIPBand.do";
				formData = "ipNo=" + _ipNo + "&ipAddress=" + ipAddress + "&access=" + access + "&explanation=" + explanation;
			}
			
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
					alert("저장하였습니다.");
					window.close();
					window.opener.IPBandListRemove(); // 리스트 삭제 후 다시 refresh -> 삭제 안하면 이어서 붙여짐
					window.opener.getIPList_http();
					
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