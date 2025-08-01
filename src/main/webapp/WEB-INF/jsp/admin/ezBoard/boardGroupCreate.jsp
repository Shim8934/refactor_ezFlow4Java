<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code="ezBoard.jjh04" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>	
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" language="javascript">
			function hasSpecialCharacters(str){
				for(var i=0; i<str.length; i++){
				    if(str.charCodeAt(i) != 40 && str.charCodeAt(i) != 41 && str.charCodeAt(i) != 91 && str.charCodeAt(i) != 93 && str.charCodeAt(i) != 38 && str.charCodeAt(i) == 47){
				    	if (str.charCodeAt(i) >= 33 & str.charCodeAt(i) <= 47) return true;
					    if (str.charCodeAt(i) >= 58 & str.charCodeAt(i) <= 59) return true;
					    if (str.charCodeAt(i) >= 60 & str.charCodeAt(i) <= 64) return true;
					    if (str.charCodeAt(i) >= 91 & str.charCodeAt(i) <= 95) return true;
					    if (str.charCodeAt(i) >= 123 & str.charCodeAt(i) <= 125) return true;
				    }				    
				}
				return false;			
			}
			
			function Save(){
				var name1 = $.trim($("#txtNewGroupName").val());
				var name2 = $.trim($("#txtNewGroupName2").val());
				var name3 = $.trim($("#txtNewGroupName3").val());
				var name4 = $.trim($("#txtNewGroupName4").val());		
				
				if (document.getElementById("allGroupBoard") != null) {
					var isAllGroupBoard = document.getElementById("allGroupBoard").checked;
				}
				
				var guBun = 0;
				
				if (name1 == ""){
					alert("<spring:message code='ezBoard.t119'/>");
					return;
				}
				
				if (hasSpecialCharacters(name1) || hasSpecialCharacters(name2) || hasSpecialCharacters(name3) || hasSpecialCharacters(name4)){
					alert("<spring:message code='ezBoard.t120'/>");
					return;
				}
				
				// 2023-11-27 조소정 - 게시판그룹이름 영어, 일본어, 중국어칸 공백 시 한국어 버전으로 삽입
				if (name2 == "") {
					name2 = name1;
				}
				if (name3 == "") {
					name3 = name1;
				}
				if (name4 == "") {
					name4 = name1;
				}
				
				if (isAllGroupBoard != null && isAllGroupBoard == true) {
					guBun = 99;
				}
				
				var newID = "{" + GetGUID() + "}";
				var selectedComp = !!parent.frames['board_menu'] ? !!parent.frames['board_menu'].companySelectID ? parent.frames['board_menu'].companySelectID : "" : "";

				$.ajax({
					type : "POST",
					url : "/admin/ezBoard/createBoardGroup.do",
					data : {
						boardGroupID : newID,
						boardGroupName : encodeURIComponent(name1),
						boardGroupName2 : encodeURIComponent(name2),
						boardGroupName3 : encodeURIComponent(name3),
						boardGroupName4 : encodeURIComponent(name4),
						companyID : selectedComp,
						guBun : guBun
					},
					success: function(result){						
						alert("<spring:message code='ezBoard.t121'/>");	
						window.parent.frames[0].refreshLeft();
					}  
				});				
			}
	    </script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezBoard.t122" /><br /></h1>
		<div style="max-width: 800px;">
		<table class="content">
			<tr>
		    	<th><spring:message code="ezBoard.t123" /></th>
		    	<td style="padding:0">
		        	<table style="width:100%">
		        		<c:if test="${use_multiData == 'YES'}">
			          		<tr class="primary">
			            		<th><c:out value='${lang_primary}' /></th>
			            		<td><input name="text" type="text" id="txtNewGroupName" style="width:100%" maxlength=20></td>
			          		</tr>
			          		<tr class="primary">
			            		<th><c:out value='${lang_secondary}' /></th>
			            		<td><input type="text" name="textfield" id="txtNewGroupName2" style="width:100%" maxlength=20></td>
			          		</tr>
			          		<c:if test="${useJapanese == 'YES' && lang_primary ne lang_tertiary}">
				          		<tr class="primary">
				            		<th><c:out value='${lang_tertiary}' /></th>
				            		<td><input type="text" name="textfield" id="txtNewGroupName3" style="width:100%" maxlength=20></td>
				          		</tr>
			          		</c:if>
			          		<c:if test="${useChinese == 'YES'}">
				          		<tr class="secondary">
				            		<th><c:out value='${lang_quaternary}' /></th>
				            		<td><input type="text" name="textfield" id="txtNewGroupName4" style="width:100%" maxlength=20></td>
				          		</tr>
				          	</c:if>
		          		</c:if>
		          		<c:if test="${use_multiData != 'YES'}">
		          			<tr>
			        			<td><input name="text" type="text" id="txtNewGroupName" style="width:100%" maxlength=20></td>
			        		</tr>	
			    		</c:if>
		        	</table>
		    	</td>
		    <%-- 2018-10-15 홍승비 - 그룹사게시판 선택 옵션 추가 --%>
    		<c:if test="${isCompanyAdmin == true}">
	    		<tr>
	    			<th style="border-left:none; border-bottom:none;"><spring:message code ="ezCircular.t118" /></th>
	    			<td style="border-top:1px solid #dedede;"><div class="custom_checkbox"><input type="checkbox" name="allGroupBoard" id="allGroupBoard"><label for="allGroupBoard"><spring:message code ="ezBoard.hsb03" /> <spring:message code ="ezBoard.hsb04" /></label></div></td>
	    		</tr>
    		</c:if>
		  	</tr>
		</table>
		<div class="btnpositionJsp"><a class="imgbtn"><span onclick="Save()"><spring:message code="ezBoard.t98" /></span></a></div>	
		</div>
	</body>
</html>