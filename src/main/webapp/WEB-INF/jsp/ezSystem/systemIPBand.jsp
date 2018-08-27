<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript">
	
		// IP 대역 등록 및 수정
		function ipBandEidtPopUp(type) {
			if (type === "add") {
	
			} else {
				
			}
			
			var url = "/ezSystem/systemIPBandEditPopup.do";
			var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(460, 210));
		}
		
	</script>
</head>
<body class="mainbody">
	<br><span class="txt">▒ IP 주소를 사용하여 허용된 IP(IP대역)에서만 접속 할 수 있습니다.</span><br><br>
	
	<table class="content" style="width:600px;">
		<tr>
			<th rowspan="2" style="width: 60px;">사용여부선택</th>
			<td>&nbsp;<input name="ipRadio" type="radio" id="ipRadio0" checked><span style="vertical-align:middle;">&nbsp;사용안함</span></td>
	    </tr>
	    <tr>
			<td>&nbsp;<input name="ipRadio" type="radio" id="ipRadio1"><span style="vertical-align:middle;">&nbsp;사용함</span></td>
		</tr>
	</table>
	
	<div style="width:600px;">
		<div class="btnpositionJsp">
	    	<a class="imgbtn" onClick="alert('저장')"><span>저장</span></a>
	    	<a class="imgbtn" onClick="alert('취소')"><span>취소</span></a>
	    </div>
	</div>
	<div id="mainmenu">
	    <ul class="on">
	        <li><span onclick="ipBandEidtPopUp('add')">추가</span></li>
	        <li><span onclick="ipBandEidtPopUp('modify')">수정</span></li>
	        <li><span onclick="alert('삭제')">삭제</span></li>
	    </ul>
	</div>
	
	<table class="mainlist" style="width:100%;">	
		<tr>
 			<th width="22px; text-algin:center;"><input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
 			<th width="230px;">IP 주소</th>
 			<th width="100px; text-algin:center;">허용여부</th>
 			<th>설명</th>
		</tr>
	</table>
	
</body>
</html>