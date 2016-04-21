<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.jjh02" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/common.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var ParentBoardID = "${parentBoardID}";
	    	var BoardGroupID = "${boardGroupID}";
	    	
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
				
				if (name1 == ""){
					alert("<spring:message code='ezBoard.t107' />");
					return;
				}
			    var newID = "{" + GetGUID() + "}";

			    $.ajax({
					type : "POST",
					url : "/admin/ezBoard/createBoard.do",
					data : { boardID : newID, boardName : encodeURIComponent(name1), boardName2 : encodeURIComponent(name2), parentBoardID : ParentBoardID, boardGroupID : BoardGroupID },
					success: function(result){						
						alert("<spring:message code='ezBoard.t109' />");	
						
						var pDiv, pId, pValue;
					    var h2 = window.parent.frames[0].document.getElementsByTagName("h2");
					    
					    for (var i = 0; i < h2.length; i++) {
					        if (h2[i].className == "on") {
					            pId = h2[i].getElementsByTagName("div")[0].id;
					            pId = pId.replace("TreeCtr", "TreeCtrl");
					            pValue = h2[i].getElementsByTagName("div")[0].getAttribute("value");
					            window.parent.frames[0].TopBoard_onclick(pId, pValue);
					            break;
					        }
					    }
					    window.location.reload(true);
					}  
				});			   
			}	    	
	    </script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezBoard.t62" /><br /></h1>
		<table class="content">
			<tr>
		    	<th><spring:message code="ezBoard.t110" /></th>
		    	<td><b class="point"><c:out value='${parentBoardName}' /></b></td>
		    </tr>
		    <tr>		
		    	<th><spring:message code="ezBoard.t111" /></th>
		    	<td style="padding:0">
		    		<c:if test="${use_multiData == 'YES'}">				    
				    	<table style="width:100%">
				        	<tr class="primary">
				        		<th><c:out value='${lang_primary}'/></th>
				          		<td><input name="text" type="text" id="txtNewName" style="WIDTH:200px" maxlength="30"></td>
				        	</tr>
				        	<tr class="secondary">
				          		<th><c:out value='${lang_secondary}'/></th>
				          		<td><input name="text" type="text" id="txtNewName2" style="WIDTH:200px" maxlength="30"></td>
				        	</tr>
				      	</table>
				 	</c:if>
				 	<c:if test="${use_multiData != 'YES'}">
				    	<input name="text" type="text" id="txtNewName" style="WIDTH:200px">
				    </c:if>  
			    </td>
		  	</tr>
		</table>
		<div class="btnposition"><a class="imgbtn"><span onclick="Save()"><spring:message code="ezBoard.t98"/></span></a></div>	
	</body>
</html>