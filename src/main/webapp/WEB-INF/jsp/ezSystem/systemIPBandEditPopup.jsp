<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezSystem.jje12'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />
	    <link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
	    <script src="${util.addVer('/js/dist/jstree.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    
	</head>
	<script>
		var _type = "<c:out value = '${type}' />";
		var _ipNo = "${ipNo}";
		var _ipAddress = "${ipAddress}";
		var _access = "${access}";
		var _explanation = "${explanation}";
		var _pageType = "<c:out value = '${pageType}' />";
		var _companyId = "<c:out value='${param.companyId}'/>";
	
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
			if (txt.indexOf("*") != -1 && txt.length == 1) {
				return true;
			}
			
			var regexp = /^[0-9]*$/;
			
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
					alert("<spring:message code='ezSystem.jje14'/>");
					return;
				}
				
				ipAddress = ipAddress + "." + formData[i];
				
			}
			ipAddress = ipAddress.substring(1, ipAddress.length);
			
			var allIPList = window.opener.allIPList;
			
			for (var i = 0; i < allIPList.length; i++) {
				if (allIPList[i].ipAddress == ipAddress && ipAddress != _ipAddress) { // IP 중복 되었을때
					alert("<spring:message code='ezSystem.jje15'/>");
					return;
				}
			}
			
			formData = "";
			if (!document.getElementById("ipAllow1").checked) {
				access = "NO";
			}
			
			explanation = document.getElementById("explanText").value;
			
			if (explanation.length > 100) {
				alert("<spring:message code='ezSystem.jje16'/>");
				return;
			}
			
			formData = "ipAddress=" + ipAddress + "&access=" + access + "&explanation=" + encodeURIComponent(explanation);
			
			if (_pageType == "adminIpAccess" && _type == "add") {
				formUrl = "/ezSystem/insertAdminIPBand.do";
			} else if (_pageType == "adminIpAccess" && _type == "modify") {
				formUrl = "/ezSystem/updateAdminIPBand.do";
				formData += "&ipNo=" + _ipNo;
			} else if (_pageType == "fidoAuthentication" && _type == "add") {
				formUrl = "/ezSystem/insertFidoIPBand.do";
				formData += "&companyId=" + _companyId;
			} else if (_pageType == "fidoAuthentication" && _type == "modify") {
				formUrl = "/ezSystem/updateFidoIPBand.do";
				formData += "&ipNo=" + _ipNo;
			} else if (_type == "modify") {
				formUrl = "/ezSystem/updateIPBand.do";
				formData += "&ipNo=" + _ipNo;
			}
			
			$.ajax({
				type : "POST",
				url : formUrl,
				cache : false,
				data : formData,
				error : function(data) {
					alert("<spring:message code='ezSystem.jje17'/>");
					console.log(data);
				},
				complete : function(data) {
					alert("<spring:message code='ezWebFolder.t182'/>");
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
			<div class="leTitle" style="padding-left:10px"><spring:message code='ezSystem.jje12'/></div>
			
			<table class="content" style="width:95%; margin:auto; margin-top: 2px;">
					<tr>
						<th><spring:message code='ezSystem.jje3'/></th>
						<td>
							<label id="la1"><div class='custom_radio'><input type="radio" id="ipAllow1" name="ipAllow" Checked>&nbsp;</div><span style="vertical-align:middle;"><spring:message code='ezSystem.jje21'/></span></label>
							<label id="la2"><div class='custom_radio'><input type="radio" id="ipAllow2" name="ipAllow">&nbsp;</div><span style="vertical-align:middle;"><spring:message code='ezSystem.jje22'/></span></label>
						</td>
					</tr>
			    <tr>
					<th><spring:message code='ezSystem.jje5'/></th>
					<td style="padding:3px 5px;"><form id="myForm"><input name="ipBand" type="text" size="3" maxlength="3" id="ipBand1">.<input name="ipBand" type="text" size="3" maxlength="3" id="ipBand2">.<input name="ipBand" type="text" size="3" maxlength="3" id="ipBand3">.<input name="ipBand" type="text" size="3" maxlength="3" id="ipBand4"></form>
						&nbsp;<span style="display:block; margin-top:3px;"><spring:message code='ezSystem.jje13'/></span>
			    </tr>
			    <tr>
					<th><spring:message code='ezBoard.t155'/></th>
					<td><input type="text" id="explanText" maxlength="50" style="width: 100%;"></td>
					<!-- <td><textarea style="width:96%;resize:none;"id="explanText" rows="3"> </textarea></td> -->
			    </tr>
			</table>
			
			<div class="btnpositionNew" style="margin:0px">
			 	<a class="imgbtn"><span onclick="saveBtn()"><spring:message code='main.sp09'/></span></a> 	
			 </div>
		</div>
	</body>
</html>