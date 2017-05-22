<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
    	<link rel="stylesheet" href="/css/Tab.css" type="text/css" />
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
	 		$(document).ready(function() {	 		
		 	var HListUser = $('#HListUser option:selected').val();
		 	$("#HListUser").val("<c:out value="${boardListConfig.previewHList}"/>").attr("selected", "selected");
		 
		 	var WListUser = $('#WListUser option:selected').val();
		 	$("#WListUser").val("<c:out value="${boardListConfig.previewWList}"/>").attr("selected", "selected");
		 
		 	var HPreUser = $('#HPreUser option:selected').val();
		 	$("#HPreUser").val("<c:out value="${boardListConfig.previewHContent}"/>").attr("selected", "selected");
		 
		 	var WPreUser = $('#WPreUser option:selected').val();
		 	$("#WPreUser").val("<c:out value="${boardListConfig.previewWContent}"/>").attr("selected", "selected");	    
		 		});
	 		
         	document.onselectstart = function () { return false; };
        	window.onload = function () {
           		if (navigator.userAgent.indexOf('Firefox') != -1) {
               		document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
       		        document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
               		document.body.style.UserSelect = 'none';
           		}           		
       		}
        	function PreviewOption(obj) {        		
            	if (obj.value == "0") {
                	document.getElementById("PreviewDiv").style.display = "none";                	
            	} else {                	
                	document.getElementById("PreviewDiv").style.display = "";
            	}
        	}
        	function HChange(obj) {
            	if (obj == document.getElementById("previewListValue")) {
                	document.getElementById("previewContentValue").value = 100 - parseInt(obj.value);
            	}
            	else {
                	document.getElementById("previewListValue").value = 100 - parseInt(obj.value);
            	}
        	}
        	function WChange(obj) {
            	if (obj == document.getElementById("previewContentValue")) {
                	document.getElementById("previewListValue").value = 100 - parseInt(obj.value);
            	}
            	else {
                	document.getElementById("previewContentValue").value = 100 - parseInt(obj.value);
            	}
        	}
        	function Cancel_Click() {
        		document.getElementById("isMailReceive").value = 0;
        		document.getElementById("listcount").value = 10;
        		document.getElementById("PreviewMode").value = 0;
      			document.getElementById("PreviewDiv").style.display = "none";        		
        	}
        	function Change_Click() {
        		var isMailReceive = document.getElementById("isMailReceive").value;
        		var listCount = document.getElementById("listcount").value;
     			var Preview = document.getElementById("PreviewMode").value;
     			var previewListValue = document.getElementById("previewListValue").value;
     			var previewContentValue = document.getElementById("previewContentValue").value;     			

     			$.ajax({
     				url : '/ezCircular/circular_generallist_save.do',
     				method : 'POST',
     				dataType : 'text',
     				data : {
     					isMailReceive : isMailReceive,
	     				listCnt : listCount ,
    	 				isPreview : Preview,
    	 				previewListValue : previewListValue,
    	 				previewContentValue : previewContentValue
     				},
	     			success : function(data, textStatus, jqXHR) {
	     				alert('<spring:message code="ezCircular.t27" />');
     				},
     				error : function(jqXHR, textStatus, errorThrown) {
                	    alert('Error : ' + jqXHR.status + ", " + textStatus);
     				}
     			});       
        	}            
    	</script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;">
			<br/>	
    		<h2><spring:message code="ezBoard.t0006" /></h2>
    		<span class="txt">▒ <spring:message code="ezCircular.t16" /></span>
        	<br />    
        	<table class="content" style="width: 623px;margin-top:5px">
        		<tr>
        			<th><spring:message code="ezCircular.t13" /></th>
        			<td>
	        			<select id="isMailReceive" style="width: 100px">
	        				<option value='0' ${circularListConfig.isMailReceive == '0' ? 'selected' : ''}><spring:message code="ezCircular.t14" /></option>
	        				<option value='1' ${circularListConfig.isMailReceive == '1' ? 'selected' : ''}><spring:message code="ezCircular.t15" /></option>
	        			</select>
        			</td>
        		</tr>
            	<tr>
                	<th><spring:message code="ezCircular.t18" /></th>
               		<td>               
                   		<select id="listcount" name="pListCount" style="WIDTH: 100px">
                				<option value='10' ${circularListConfig.listCnt == '10' ? 'selected' : ''}>10</option>
								<option value='20' ${circularListConfig.listCnt == '20' ? 'selected' : ''}>20</option>
                      			<option value='30' ${circularListConfig.listCnt == '30' ? 'selected' : ''}>30</option>
                      			<option value='40' ${circularListConfig.listCnt == '40' ? 'selected' : ''}>40</option>
                      			<option value='50' ${circularListConfig.listCnt == '50' ? 'selected' : ''}>50</option>                        
                   		</select>
                    	<spring:message code="ezBoard.t00019" />
                    </td>
            	</tr>
            	<tr>
                	<th><spring:message code="ezCircular.t19" /></th>
               		<td>
                   		<select id="PreviewMode" name="pPreview" style="WIDTH: 100px" onchange="PreviewOption(this);">
                   			<option value='0' ${circularListConfig.isPreview == '0' ? 'selected' : ''}><spring:message code="ezCircular.t20" /></option>
                   			<option value='1' ${circularListConfig.isPreview == '1' ? 'selected' : ''}><spring:message code="ezCircular.t21" /></option>
                   			<option value='2' ${circularListConfig.isPreview == '2' ? 'selected' : ''}><spring:message code="ezCircular.t22" /></option>             					                     
                   		</select>
                   		<span id="PreviewDiv" style="${circularListConfig.isPreview == '0' ? 'display: none;' : ''}">                   			
							&nbsp;<spring:message code="ezCircular.t23" /> : 
	     					<select id="previewListValue" name="pPreviewHList" style="width: 50px;" onchange="HChange(this);">	     						
	     						<c:forEach var="item" begin="39" end="64">
	           						<option value='${item}' ${item == circularListConfig.previewListValue ? 'selected' : '' }>${item}</option>
	       						</c:forEach>                                                 
							</select>							
	         				&nbsp;<spring:message code="ezCircular.t24" /> :	         					 
							<select id="previewContentValue" name="pPreviewHContent" style="width: 50px;" onchange="HChange(this);">
								<c:forEach var="item" begin="36" end="61">
		   							<option value='${item}' ${item == circularListConfig.previewContentValue ? 'selected' : '' }>${item}</option>
								</c:forEach>
							</select>		
						</span>
               		</td>
            	</tr>
        	</table>       
    		<br />
    		<div style="width:623px;text-align:center;">      
        		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezCircular.t25" /></span></a>
        		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezCircular.t26" /></span></a>
    		</div>
		</body>
</html>