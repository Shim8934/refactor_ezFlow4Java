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
	</head>
	<script>
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
					<td><input name="ipBand1" type="text" size="3" id="ipBand1">.<input name="ipBand2" type="text" size="3" id="ipBand2">.<input name="ipBand3" type="text" size="3" id="ipBand3">.<input name="ipBand4" type="text" size="3" id="ipBand4">
						&nbsp;<span>예)10.0.0.* 또는 127.0.0.1</span>
			    </tr>
			    <tr>
					<th>설명</th>
					<td><textarea style="width:96%;resize:none;"id="explanText" rows="3"> </textarea></td>
			    </tr>
			</table>
			
			<div class="btnpositionNew" style="margin:0px">
			 	<a class="imgbtn"><span onclick="alert('저장')"><spring:message code='main.sp09'/></span></a> 	
			 </div>
		</div>
	</body>
</html>