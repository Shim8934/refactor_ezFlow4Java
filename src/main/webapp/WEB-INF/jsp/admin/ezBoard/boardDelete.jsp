<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.jjh03" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
	    <style type="text/css">
	    	.warningbox01 { width:520px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;}
			.warningbox02 { width:450px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-bottom:10px;margin-top:20px}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 10px 5px 115px; margin:0px; display:inline-block;}
			.warningdl dt { height:40px; padding-left:5px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
			</style>
			
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
	    					
	    					if (SelectedBoardID == BoardGroupID) {
		    			        window.parent.frames[0].location.reload();
		    			        window.location.reload(true);
	    					} else {
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
		<div style="max-width:800px;">
		<c:if test="${hasSubBoard == '1'}">		
			<table  class="content">
				<tr>
			    	<th><spring:message code="ezBoard.t114"/></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table><br/>
				<div id="EmptyMsg">
	    			<div class="warningbox01" style="margin-top:100px;">
	        			<div class="warningbox02">
	  	        			<div class="warnintxt01" style="text-align:left; display:inline-block;">
		        			<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin:18px 0px 18px 34px;"></span>
	        				<dl class="warningdl">
	        				<dt><img src="/images/notify/warning01.gif" width="183" height="27"></dt>
		        					<dd>
		        					 	<spring:message code="ezBoard.t115"/>
		        					</dd>
		        				</dl>
		        			</div>
		    			</div>
	    			</div>
				</div>
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
			</div>			
			<div class="btnpositionJsp">
			    <a class="imgbtn"><span onclick="Delete()" ><spring:message code="ezBoard.t89"/></span></a>
			</div>
		</c:if>
		</div>
	</body>
</html>