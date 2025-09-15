<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.jjh02" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			#nameTable tr:last-child th,
			#nameTable tr:last-child td {
				border-bottom: none;
			}
		</style>
		<script type="text/javascript" language="javascript">
			var ParentBoardID = "<c:out value='${parentBoardID}'/>";
	    	var BoardGroupID = "<c:out value='${boardGroupID}'/>";
	    	
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
	    		var name1 = $.trim($("#txtNewName").val());
				var name2 = $.trim($("#txtNewName2").val());
	    		var name3 = $.trim($("#txtNewName3").val());
				var name4 = $.trim($("#txtNewName4").val());
				
				if (name1 == "") {
					alert("<spring:message code='ezBoard.t107' />");
					return;
				}

				// 2023-11-27 조소정 - 게시판이름 영어, 일본어, 중국어칸 공백 시 한국어 버전으로 삽입
				if (name2 == "") {
					name2 = name1;
				}
				if (name3 == "") {
					name3 = name1;
				}
				if (name4 == "") {
					name4 = name1;
				}
				
			    var newID = "{" + GetGUID() + "}";

				/* 그룹게시판 설정여부 */
				var useGroupFlag = document.getElementById("useGroup").checked ? "Y" : "N";
				if (useGroupFlag == "Y") {
					if (chkGroupBoardExist() == "true") { // 상위게시판에 그룹게시판이 존재하는 경우 그룹게시판으로 등록 불가
						alert("<spring:message code='ezBoard.lyj13'/>");
						return;
					}
				}

			    $.ajax({
					type : "POST",
					url : "/admin/ezBoard/createBoard.do",
					data : {
						boardID : newID,
						boardName : encodeURIComponent(name1),
						boardName2 : encodeURIComponent(name2),
						boardName3 : encodeURIComponent(name3),
						boardName4 : encodeURIComponent(name4),
						parentBoardID : ParentBoardID,
						boardGroupID : BoardGroupID,
						useGroupFlag : useGroupFlag
					},
					success: function(result){						
						alert("<spring:message code='ezBoard.t109' />");	
						
						var pDiv, pId, pValue;
					    var h2 = window.parent.frames[0].document.getElementsByTagName("h2");
					    
					    /* 2018-12-28 홍승비 - 게시판그룹명 > div -> span 태그로 변경된 부분 id 찾도록 수정 */
					    for (var i = 0; i < h2.length; i++) {
					        if (h2[i].className == "on") {
					            pId = h2[i].getElementsByClassName("h2Title")[0].id;
					            pId = pId.replace("TreeCtr", "TreeCtrl");
					            pValue = h2[i].getElementsByClassName("h2Title")[0].getAttribute("value");
					            
					            // 열려있는 게시판그룹 닫히는 부분 수정
					            // window.parent.frames[0].TopBoard_onclick(pId, pValue);
					            window.parent.frames[0].treeViewRefresh(pId, pValue);
					            break;
					        }
					    }
					    window.location.reload(true);
					}  
				});			   
			}

			function chkGroupBoardExist() {
				var result = "";

				$.ajax({
					type: "POST",
					dataType: "text",
					async: false,
					url: "/ezBoard/chkGroupBoardExist.do",
					data: {
						boardID: ParentBoardID,
						type: "CREATE"
					},
					success: function (res) {
						result = res;
					}
				});

				return result;
			}
	    </script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezBoard.t62" /><br /></h1>
		<div style="max-width:800px;">
		<table class="content">
			<tr>
		    	<th><spring:message code="ezBoard.t110" /></th>
  			  	<td><b>&nbsp;<c:out value='${parentBoardName}' /></b></td>
		    </tr>
		    <tr>		
		    	<th><spring:message code="ezBoard.t111" /></th>
		    	<td style="padding:0">
		    		<c:if test="${use_multiData == 'YES'}">				    
				    	<table id="nameTable" style="width:100%">
				        	<tr class="primary">
				        		<th><c:out value='${lang_primary}'/></th>
				          		<td><input name="text" type="text" id="txtNewName" style="WIDTH:100%" maxlength="30"></td>
				        	</tr>
				        	<tr class="primary">
				          		<th><c:out value='${lang_secondary}'/></th>
				          		<td><input name="text" type="text" id="txtNewName2" style="WIDTH:100%" maxlength="30"></td>
				        	</tr>
			          		<c:if test="${useJapanese == 'YES' && lang_primary ne lang_tertiary}">
					        	<tr class="primary">
					        		<th><c:out value='${lang_tertiary}'/></th>
					          		<td><input name="text" type="text" id="txtNewName3" style="WIDTH:100%" maxlength="30"></td>
					        	</tr>
				        	</c:if>
		                    <c:if test="${useChinese == 'YES'}">
					        	<tr class="secondary">
					          		<th><c:out value='${lang_quaternary}'/></th>
					          		<td><input name="text" type="text" id="txtNewName4" style="WIDTH:100%" maxlength="30"></td>
					        	</tr>
					        </c:if>
				      	</table>
				 	</c:if>
				 	<c:if test="${use_multiData != 'YES'}">
				    	<input name="text" type="text" id="txtNewName" style="WIDTH:100%">
				    </c:if>  
			    </td>
		  	</tr>
			<tr>
				<th><spring:message code="ezBoard.lyj04" /></th>
				<td><input id="useGroup" type="checkbox" style="margin-top:5px"><span style="vertical-align:middle"><spring:message code="ezBoard.lyj05" /> <spring:message code="ezBoard.lyj09" /></span></td>
			</tr>
		</table>
		<div class="btnpositionJsp"><a class="imgbtn"><span onclick="Save()"><spring:message code="ezBoard.t98"/></span></a></div></div>
	</body>
</html>