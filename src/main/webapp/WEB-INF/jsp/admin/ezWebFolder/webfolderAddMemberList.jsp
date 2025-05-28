<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript">
		function isValid(str){
			var regex = /[*:"\\|<>\/?]/g;
			return regex.test(str);
		}
		
        var returnFunction = "";
        var addMemberList = new Array();
        
		window.onload = function(){
			DivPopUpHidden = parent.webfolderAddUserList_parm[0];
			addMemberList = parent.webfolderAddUserList_parm[1];
			returnFunction = parent.webfolderAddUserList_parm[2];
			
			var div = document.getElementById("memberList");
			var ulElmt = document.createElement("ul");
			div.appendChild(ulElmt);
			for (var i=0; i<addMemberList.length; i++){
				var liElmt = document.createElement("li");
				liElmt.innerText= addMemberList[i].username;
				div.appendChild(liElmt);
			}
		}
		
		function wClose() {
			parent.closeAllPopup();
// 			window.close();
		}
		
		function click_type(type) {
			try {
				parent.returnFunction(type);
			} catch (e) {};
			wClose();
		}
		
	</script>
	<style> 
		.margin ul, li{ margin-left:15px;} 
		#memberList { margin-left:15px;overflow:auto; height:100px;}
		@media screen and (-webkit-min-device-pixel-ratio:0){ 
			#memberList { margin-left:0px;overflow:auto; height:100px;} } 
	</style>

</head>
<body class="popup" style="overflow: hidden;">
    <h1 id="topMenu" ><spring:message code="ezWebFolder.ksa39" /></h1><!--style삭제-->
    <div id="close">
        <ul>
            <li><span id="btnCancel" onclick="wClose()"></span></li>
        </ul>
    </div>
    <div > <!--style삭제-->
        <div class="txt mb10" id="divTop"> <!-- clss추가 style삭제--><spring:message code="ezWebFolder.ksa40" /></div>
        <div class="txt mb10" id="divBottom"> <spring:message code="ezWebFolder.ksa41" /></div>
        <div class="txt mb10" id="memberList" style="overflow:auto; height:100px;"> <!-- clss추가 style삭제--></div>
    </div>
    <div class="btnpositionNew">
        <a id="btnSave" class="imgbtn" onclick="click_type(1);"><span><spring:message code="ezWebFolder.ksa42" /></span></a>
        <a id="btnSave" class="imgbtn" onclick="click_type(0);"><span><spring:message code="ezWebFolder.ksa43" /></span></a>
    </div>
</body>
</html>