<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=9" />
    	<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
    	<link rel="stylesheet" href="/css/Tab.css" type="text/css" />
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    	<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
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
            	if (obj.value == "OFF") {
                	document.getElementById("PreviewHSizeDiv").style.display = "none";
                	document.getElementById("PreviewWSizeDiv").style.display = "none";
            	}
            	else if (obj.value == "H") {
                	document.getElementById("PreviewHSizeDiv").style.display = "";
                	document.getElementById("PreviewWSizeDiv").style.display = "none";
            	}
            	else {
                	document.getElementById("PreviewHSizeDiv").style.display = "none";
                	document.getElementById("PreviewWSizeDiv").style.display = "";
            	}
        	}
        	function HChange(obj) {
            	if (obj == document.getElementById("HListUser")) {
                	document.getElementById("HPreUser").value = 100 - parseInt(obj.value);
            	}
            	else {
                	document.getElementById("HListUser").value = 100 - parseInt(obj.value);
            	}
        	}
        	function WChange(obj) {
            	if (obj == document.getElementById("WListUser")) {
                	document.getElementById("WPreUser").value = 100 - parseInt(obj.value);
            	}
            	else {
                	document.getElementById("WListUser").value = 100 - parseInt(obj.value);
            	}
        	}
        	function Cancel_Click() {
            	window.location.reload(true);
        	}
        	function Change_Click() {
        		var listCount = document.getElementById("listcount").value;
     			var PreviewMode = document.getElementById("PreviewMode").value;
     			var PreviewWList = document.getElementById("WListUser").value;
     			var PreviewWContent = document.getElementById("WPreUser").value;
     			var PreviewHList = document.getElementById("HListUser").value;
     			var PreviewHContent = document.getElementById("HPreUser").value;
     		
     			$.ajax({
     				url : '/ezBoard/board_generallist_save.do',
     				method : 'POST',
     				dataType : 'text',
     				data : {
	     				listCount : listCount ,
    	 				preview : PreviewMode,
     					previewWList : PreviewWList,
     					previewWContent : PreviewWContent,
     					previewHList : PreviewHList,
     					previewHContent : PreviewHContent	
     				} ,
	     			success : function(data, textStatus, jqXHR) {
	     				alert('<spring:message code="ezBoard.t0014" />');
     				},
     				error : function(jqXHR, textStatus, errorThrown) {
                	    alert('Error : ' + jqXHR.status + ", " + textStatus);
     				}
     			});       
        	}            
    	</script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;">	
    		<h2 class="h2_dot"><spring:message code="ezBoard.t0006" /></h2>
    		<span class="txt" style="margin-left: 13px;" >* <spring:message code="ezBoard.t0007" /></span>
        	<br />    
        	<table class="content" style="width: 623px; margin-left: 13px;">
            	<tr>
                	<th><spring:message code="ezBoard.t10021" /></th>
                		<td>               
                    		<select id="listcount" name="pListCount" style="WIDTH: 100px">
                     			<c:choose>
                    				<c:when test="${boardListConfig.listCount eq '10'}">
                    					<option value='10'  selected >10</option>
										<option value='20' >20</option>
	                        			<option value='30' >30</option>
	                        			<option value='40' >40</option>
	                        			<option value='50' >50</option>
                    				</c:when>
                    				<c:when test="${boardListConfig.listCount eq '20'}">
                    					<option value='10' >10</option>
										<option value='20' selected>20</option>
	                        			<option value='30' >30</option>
	                        			<option value='40' >40</option>
	                        			<option value='50' >50</option>
                    				</c:when>
                    				<c:when test="${boardListConfig.listCount eq '30'}">
                    					<option value='10' >10</option>
										<option value='20' >20</option>
	                        			<option value='30' selected>30</option>
	                        			<option value='40' >40</option>
	                        			<option value='50' >50</option>
                    				</c:when>
                    				<c:when test="${boardListConfig.listCount eq '40'}">
                    					<option value='10' >10</option>
										<option value='20' >20</option>
	                        			<option value='30' >30</option>
	                        			<option value='40' selected>40</option>
	                        			<option value='50' >50</option>
                    				</c:when>
                    				<c:when test="${boardListConfig.listCount eq '50'}">
                    					<option value='10' >10</option>
										<option value='20' >20</option>
	                        			<option value='30' >30</option>
	                        			<option value='40' >40</option>
	                        			<option value='50' selected>50</option>
                    				</c:when>
                    				<c:otherwise>
                    					<option value='10'  selected >10</option>
										<option value='20' >20</option>
	                        			<option value='30' >30</option>
	                        			<option value='40' >40</option>
	                        			<option value='50' >50</option>
                    				</c:otherwise>
                      		</c:choose>                        
                    	</select>
                    <spring:message code="ezBoard.t00019" />
                    </td>
            	</tr>
            	<tr>
                	<th><spring:message code="ezBoard.t431" /></th>
                		<td>
                    		<select id="PreviewMode" name="pPreview" style="WIDTH: 100px" onchange="PreviewOption(this);">
                     			<c:choose>
                    				<c:when test="${boardListConfig.preview eq 'H'}">
	                        			<option value="OFF"><spring:message code="ezBoard.t00011" /></option>
										<option value="H" selected><spring:message code="ezBoard.t00012" /></option>
	                        			<option value="W" ><spring:message code="ezBoard.t00013" /></option>
                    				</c:when>
                    				<c:when test="${boardListConfig.preview eq 'OFF'}">
                    					<option value="OFF" selected><spring:message code="ezBoard.t00011" /></option>
										<option value="H" ><spring:message code="ezBoard.t00012" /></option>
	                        			<option value="W" ><spring:message code="ezBoard.t00013" /></option>
                    				</c:when>
                    				<c:when test="${boardListConfig.preview eq 'W'}">
                    					<option value="OFF"><spring:message code="ezBoard.t00011" /></option>
										<option value="H" ><spring:message code="ezBoard.t00012" /></option>
	                        			<option value="W" selected><spring:message code="ezBoard.t00013" /></option>
                    				</c:when>
                    			</c:choose>               					                     
                    		</select>
                    		               
                     			<c:choose>
                    				<c:when test= "${boardListConfig.preview ne 'H'}">
                      					<span id="PreviewHSizeDiv" style="display:none;">                         	
                    						<spring:message code="ezBoard.t0008" /> : 
                    						<select id="HListUser" name="pPreviewHList" style="width: 50px;" onchange="HChange(this);">
              		 							<% for (int i = 39; i <= 64; i++) { %>
	                        					<option value='<%=i %>' > <%=i %></option>
                     							<% } %>                                                  
              								</select>
                        					<spring:message code="ezBoard.t0009" /> : 
              								<select id="HPreUser" name="pPreviewHContent" style="width: 50px;" onchange="HChange(this);">
                  								<% for (int i = 36; i <= 61; i++) { %>
                        						<option value='<%=i %>' > <%=i %></option>
                     							<% } %>                               
              								</select>
                      					</span>
                    				</c:when>
                    				<c:otherwise>
                      					<span id="PreviewHSizeDiv">                                 	
                    						<spring:message code="ezBoard.t0008" /> : 
                    						<select id="HListUser" name="pPreviewHList" style="width: 50px;" onchange="HChange(this);">
              		 							<% for (int i = 39; i <= 64; i++) { %>                               
                        						<option value='<%=i %>' > <%=i %></option>
                     							<% } %>                                 
              								</select>
                        					<spring:message code="ezBoard.t0009" /> : 
              								<select id="HPreUser" name="pPreviewHContent" style="width: 50px;" onchange="HChange(this);">
                  								<% for (int i = 36; i <= 61; i++) { %>
                        						<option value='<%=i %>' > <%=i %></option>  
                     							<% } %>
			  								</select>                     
                     					</span>
                    				</c:otherwise>
                				</c:choose>
				                   
                     			 <c:choose>
                 				 	<c:when test= "${boardListConfig.preview ne 'W'}">	 
                      					<span id="PreviewWSizeDiv" style="display:none;">                            
                    						<spring:message code="ezBoard.t0008" /> : 
              								<select id="WListUser" name="pPreviewWList" style="width: 50px;" onchange="WChange(this);">
                  								<% for (int i = 24; i <= 65; i++) { %>
                        						<option value='<%=i %>' > <%=i %></option>
                     							<% } %>
              								</select>       	            
              								<spring:message code="ezBoard.t0009" /> :                    
              								<select id="WPreUser"  name="pPreviewWContent" style="width: 50px;" onchange="WChange(this);">
                  								<% for (int i = 35; i <= 76; i++) { %>
                        						<option value='<%=i %>' > <%=i %></option>
                     							<% } %>
              								</select>
                      					</span>
                 				 	</c:when>
                 				 	<c:otherwise>
                      					<span id="PreviewWSizeDiv">                               
                    						<spring:message code="ezBoard.t0008" /> : 
              								<select id="WListUser" name="pPreviewWList" style="width: 50px;" onchange="WChange(this);">
                  								<% for (int i = 24; i <= 65; i++) { %>
                        						<option value='<%=i %>' > <%=i %></option>
                     							<% } %>
              								</select>     	            
              								<spring:message code="ezBoard.t0009" /> :                    
              								<select id="WPreUser"  name="pPreviewWContent" style="width: 50px;" onchange="WChange(this);">
                  								<% for (int i = 35; i <= 76; i++) { %>
                        						<option value='<%=i %>' > <%=i %></option>
                     							<% } %>
              								</select>
                      					</span>
                 				 	</c:otherwise>
                     			 </c:choose>
                		</td>
            	</tr>
        	</table>       
    		<br />
    		<div style="width:623px;text-align:center;">      
        		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezBoard.t98" /></span></a>
        		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezBoard.t15" /></span></a>
    		</div>
		</body>
</html>