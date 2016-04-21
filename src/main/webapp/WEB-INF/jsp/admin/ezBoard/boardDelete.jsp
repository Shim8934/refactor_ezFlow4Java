<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.jjh03" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">
			var SelectedBoardID = "<c:out value='${boardID}'/>";
	    	var BoardGroupID = "<c:out value='${boardGroupID}'/>";
	    	
	    	function Delete(){
	    		var ret = confirm("<spring:message code='ezBoard.t112'/>");
	    		
	    		if(ret) {	    			
	    			$.ajax({
	    				type : "POST",
	    				dataType : "text",
	    				url : "/admin/ezBoard/deleteBoard.do",
	    				data : { boardID : SelectedBoardID },
	    				success : function(result){
	    					alert("<spring:message code='ezBoard.t54'/>");
	    					
	    					if(SelectedBoardID == BoardGroupID)
		    			        window.parent.frames[0].location.reload();
		    			    else{
		    			    	var pDiv, pId, pValue;
		    			        var h2 = window.parent.frames[0].document.getElementsByTagName("h2");

		    			        for(var i = 0; i < h2.length; i++){
		    			            if (h2[i].getAttribute("class") == "on"){
		    			                pId = h2[i].getElementsByTagName("div")[0].id;
		    			                pId = pId.replace("TreeCtr", "TreeCtrl");
		    			                pValue = h2[i].getElementsByTagName("div")[0].getAttribute("value");
		    			            }
		    			        }
		    			        window.parent.frames[0].TopBoard_onclick(pId, pValue);
		    			        window.location.reload(true);
	    					}
	    				}
	    			});
	    		}
	    	}
	    </script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezBoard.t113"/></h1>
		<c:if test="${hasSubBoard == '1'}">		
			<table  class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114"/></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table><br/>
			<h2><spring:message code="ezBoard.t115"/></h2>
		</c:if>
		<c:if test="${hasSubBoard != '1'}">			
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114"/></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table><br/>			
			<div class="box" style="padding:10px" >
				<spring:message code="ezBoard.t116"/><b>'<c:out value="${boardName}"/>'</b>
				<spring:message code="ezBoard.t117"/><br/>
			  	<spring:message code="ezBoard.t118"/>
			</div><br/>			
			<div class="btnposition">
			    <a class="imgbtn"><span onclick="Delete()" ><spring:message code="ezBoard.t89"/></span></a>
			</div>
		</c:if>
	</body>
</html>