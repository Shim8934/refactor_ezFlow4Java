<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />
	    <link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script src="${util.addVer('/js/dist/jstree.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterBoxTree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterList.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    
	</head>
	
	<style>
		.jstree-container-ul {
			margin:2px;
		}
		.jstree-default .jstree-themeicon {
 			width:0px !important;
 			height:0px !important;
		}
		.jstree-default>.jstree-no-dots .jstree-closed>.jstree-ocl{
			background-image: url(/images/OrganTree_cross/plus.png) !important;
			background-position: center !important;
		}
		.jstree-default>.jstree-no-dots .jstree-open>.jstree-ocl {
			background-image: url(/images/OrganTree_cross/minus.png) !important;
    		background-position: center !important;
		}
	</style>
	
	<body style="height: 95%; overflow:hidden;">
	    <%-- <h5 style="padding: 10px 1px;"><spring:message code='ezEmail.letter21'/></h5> --%>
	    <h1 style="padding: 5px"> </h1>
	    <div id="mainmenu">
		    <ul class="on">
		        <li class="important"><span onclick="addLetterBox()"><spring:message code='ezEmail.letter17'/></span></li>
		        <li><span class="icon16 icon16_delete" onclick="deleteLetterBox()"></span></li>
		    </ul>
		</div>
		<div id="letterContentDiv" style="width:639px;">
			<div id="divTree" class="myScrollableBlock" style="border:1px solid #ddd">
			</div>
			<div id="divInput" style="border:1px solid #ddd; padding:15px; height:319px">
				<form id="myForm" action="/admin/ezEmail/updateLetterBox.do" method="post">
					<label for="display">
						<spring:message code='ezEmail.letter35'/> (${primary})
					</label>
					<input type="text" id="display" name="displayname" size="30" maxlength="40">
					
					<br><br>
					
					<label for="display2">
						<spring:message code='ezEmail.letter36'/> (${secondary})
					</label>
					<input type="text" id="display2" name="displayname2" size="30" maxlength="40">
					
					<br>
					
					<input type="hidden" id="letterbox_no" name="letterBoxNo">
					<input type="hidden" id="parent_letterbox_no" name="parentLetterBoxNo">
					<input type="hidden" id="company_id" name="companyID" value="<c:out value='${companyId}'/>">
				</form>
			</div>
			<div class="btnpositionJsp" style="width:100%;text-align:center;float:left;margin-top:10px;padding:7px;">
		        <a class="imgbtn" onclick="submitClick()"><span><spring:message code="ezEmail.t48"/></span></a>
		    </div>
		</div>
		<script>
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<script type="text/javascript">
			var pageType = "${pageType}";
	    	var returnCompany = "<c:out value='${companyId}'/>";
	    	var userLang = '${userLang}';
		    var result = [];
		    var letter_displayname;
		    var letter_displayname2;
		    var treeCollection = [];
		    var xmlhttp;
		    var responseResult;
		    var selectNode;
		    var addCheck = 0;
		    
		    var letterStr20 = "<spring:message code='ezEmail.letter20'/>"; 
		    var letterStr22 = "<spring:message code='ezEmail.letter22'/>"; 
		    var letterStr23 = "<spring:message code='ezEmail.letter23'/>";
		    var letterStr24 = "<spring:message code='ezEmail.letter24'/>";
		    var letterStr25 = "<spring:message code='ezEmail.letter25'/>";
		    var letterStr26 = "<spring:message code='ezEmail.letter26'/>";
		    var letterStr27 = "<spring:message code='ezEmail.letter27'/>";
		    var letterStr28 = "<spring:message code='ezEmail.letter28'/>";
			var specialMsg = "<spring:message code='ezEmail.kyj17'/>"; // 해당 특수문자는 입력할 수 없습니다.
			var specialMsg2 = "<spring:message code='ezEmail.letter9'/>"; //
			var lengthMsg = "<spring:message code='ezEmail.letter14'/>"; // 자 이하로 입력 가능합니다.
			var contentMsg = "<spring:message code='ezEmail.letter11'/>"; // 이름을 입력해주세요.
			var letterBoxNameMsg = "<spring:message code='ezEmail.letter31'/>"; // 이름은
			var letterBoxDelMsg = "<spring:message code='ezBoard.t54'/>"; // 삭제되었습니다.
			var selectLetterboxMsg = "<spring:message code='ezEmail.letter39'/>";
		    
		    window.onload = window_onload;
		    
		    function window_onload() {
		    	resultRead();
		    }
		    
		    // 한글, 영문 이름 대입하는 함수
		    function setDisplay(letter_displayname, letter_displayname2) {
		    	document.getElementById("display").value = letter_displayname;
			    document.getElementById("display2").value = letter_displayname2;
		    }
	    </script>
	</body>
</html>