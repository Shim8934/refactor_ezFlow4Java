<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mailCopyright</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<style>
			#copyrightTextArea {
				width : 100%;
				height : 150px;
				margin-top : 15px;
				resize : none;
				box-sizing : border-box;
				padding: 5px;
				line-height : 18px;
			} 
			
			#copyrightExam {
				width : 100%;
				height : 120px;
				border : 1px solid #dedede;
				box-sizing : border-box;
				padding: 5px;
				line-height : 18px;
				
			}
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezEmail.ksa05' /></h1>
		
		<div style="width:680px">
			<span class="txt">▒ <spring:message code='ezEmail.ksa06'/></span><br><br>
			<table class="content" style="width:100%;">
				<tr>
					<th rowspan="2" style="width: 60px;"><spring:message code='ezSystem.jje4'/></th>
					<td>&nbsp;
						<label id="radioFalse">
							<input name="copyrightRadio" type="radio" id="copyRadio0" value="NO">
							<span style="vertical-align:middle;">&nbsp;<spring:message code='ezEmail.t99000009'/></span>
						</label>
					</td>
			    </tr>
			    <tr>
					<td>&nbsp;
						<label id="radioTrue">
							<input name="copyrightRadio" type="radio" id="copyRadio1"  value="YES">
							<span style="vertical-align:middle;">&nbsp;<spring:message code='ezBoard.t162'/></span>
						</label>
					</td>
				</tr>
			</table>
			
			<div>
				<textarea id="copyrightTextArea" placeholder = "내용을 입력해주세요."></textarea>
			</div>
			
			<!-- 수취인안내설정 예시 -->
			<br></br>
			<span class="txt">▒ <spring:message code='ezEmail.ksa07'/></span><br><br>
			<div id = "copyrightExam">
				<spring:message code='ezEmail.ksa08'/>
			</div>
			
			<div class="btnpositionJsp">
				<a id="btn1" class="imgbtn" onClick="saveBtn()"><span><spring:message code='main.sp09'/></span></a>	&nbsp;
				<a id="btn1" class="imgbtn" onClick="resetBtn()"><span><spring:message code='main.t135'/></span></a>	
			</div>
		</div>
		
	</body>
	<script>
		window.onload = function() {
			getData();
		}
		
		// 수취인안내설정 가져오기
		function getData() {
			$.ajax({
				type : "post",
				url : "/admin/ezEmail/mailCopyrightData.do",
				dataType : "json",
				success : function(data) {
					var copyrightText = data[0].copyrightText;
					var useCopyright = data[0].useCopyright;
					
					$("#copyrightTextArea").val(copyrightText);
					
					if (useCopyright == "YES") {
						copyRadio1.checked = true;
					} else {
						copyRadio0.checked = true;
					}
				},
				error : function () {
					alert("error");
				}
			});
		}
		
		// 저장 
		function saveBtn() {
			var copyrightText = $("#copyrightTextArea").val();
			var useCopyright = $("input[name=copyrightRadio]:checked").val()
			
			$.ajax({
				type:"post",
				url:"/admin/ezEmail/mailCopyrightSave.do",
				data:{
					"copyrightText" : copyrightText, 
					"useCopyright" : useCopyright
				},
				success:function() {
					alert("<spring:message code='main.sp10' />");
					getData();
				},
				error:function() {
					alert("error");
				}
			});
		}
		
		// 취소
		function resetBtn() {
			location.reload();
		}
	</script>
</html>