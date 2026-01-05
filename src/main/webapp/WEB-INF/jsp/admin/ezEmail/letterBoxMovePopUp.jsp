<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezEmail.letter4'/></title>
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
	    <style>
			.leLetterBtns {
				text-align: center;
				margin-top: 30px;
			}
			
			.divFolder {
				height: 345px;
				border: 1px solid #ccc;
				margin: 10px;
				overflow: auto;
				box-sizing: border-box;
	    		padding: 5px;
			}
			
		</style>
	</head>
	<body style="background: url(/images/kr/cm/popup_bg.gif) #ffffff repeat-x left top">
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<div id="leTop">			
			<div class="leTitle" style="padding-left:10px">
				<spring:message code='ezEmail.letter4'/>
			</div>
			
			<div class="divFolder" id="divTree"></div>
			
			
			 <div class="btnpositionNew" style="margin:0px">
			 	<a class="imgbtn"><span id="leSave" data-letterNo="${letterNo}" onclick="letterBoxSave()"><spring:message code='main.sp09'/></span></a>
			 	
			 </div>
		</div>
		<script>
		    var pageType = "${pageType}";
		    var returnCompany = '${companyId}';
		    var userLang = '${userLang}';
		    var isDivPopUp = false;
		    
			var result = [];
		    var treeCollection = [];
		    var selectNode;
		    var modifyMsg = "";
		    var deleteMsg = "";
		    var letterMoveMsg = "<spring:message code='ezEmail.letter29'/>";
			var dataNoMsg = "<spring:message code='main.t00026'/>";
		    
			$(document).ready(function(){
				resultRead(); // 편지지함 목록
				isDivPopUp = true;
			});
			
			// 편지지함 이동(저장)
			function letterBoxSave() {
				var letterBoxNo = selectNode.node.id;
				var letterBox = '<c:out value="${letterBox}"/>';
				var letterNo = '<c:out value="${letterNo}"/>';
				var letterId = '<c:out value="${letterId}"/>';
				var query = "/admin/ezEmail/updateLetterMove.do";

				if(letterBox == letterBoxNo){
				    alert("<spring:message code='ezEmail.letter40'/>");
				    return;
				}
				$.ajax({
					type : "POST",
					url : query,
					datatype : 'text',
					data : {"letterBox" : letterBox ,
							"letterNo" : letterNo , 
							"parentLetterBoxNo" : letterBoxNo,
							"letterId" : letterId},
					error : function(data) {
						alert("error");
					},
					success : function(data) {
						alert(letterMoveMsg);
						window.close();
					}
				}); 
			}  
		</script>	
	</body>
</html>