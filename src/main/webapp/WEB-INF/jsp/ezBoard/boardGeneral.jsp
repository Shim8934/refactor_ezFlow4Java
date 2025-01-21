<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
    	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
	 		$(document).ready(function() {	 		
			 	$("#HListUser").val("<c:out value="${boardListConfig.previewHList}"/>").attr("selected", "selected");
			 	var HListUser = $('#HListUser option:selected').val();
			 
			 	$("#WListUser").val("<c:out value="${boardListConfig.previewWList}"/>").attr("selected", "selected");
			 	var WListUser = $('#WListUser option:selected').val();
			 
			 	$("#HPreUser").val("<c:out value="${boardListConfig.previewHContent}"/>").attr("selected", "selected");
			 	var HPreUser = $('#HPreUser option:selected').val();
			 
			 	$("#WPreUser").val("<c:out value="${boardListConfig.previewWContent}"/>").attr("selected", "selected");	    
			 	var WPreUser = $('#WPreUser option:selected').val();
		 		
		 		if (HListUser == undefined || HPreUser == undefined) {
		 			$("#HListUser").val("50").attr("selected", "selected");
		 			$("#HPreUser").val("50").attr("selected", "selected");
		 		}
		 		if (WListUser == undefined || WPreUser == undefined) {
		 			$("#WListUser").val("50").attr("selected", "selected");
		 			$("#WPreUser").val("50").attr("selected", "selected");
		 		}
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
        		document.getElementById("listcount").value = "${boardListConfig.listCount}";
        		document.getElementById("PreviewMode").value = "<c:out value='${boardListConfig.preview}'/>";
        		//2018-10-30 김보미 - 리스트 영역, 미리보기 영역 갯수도 초기화
        		PreviewOption(document.getElementById("PreviewMode"));
        		document.getElementById("HListUser").value = "${boardListConfig.previewHList}";
        		document.getElementById("WListUser").value = "${boardListConfig.previewWList}";
        		document.getElementById("HPreUser").value = "${boardListConfig.previewHContent}";
        		document.getElementById("WPreUser").value = "${boardListConfig.previewWContent}";    

			 	if("<c:out value='${boardListConfig.preview}'/>"=="OFF"){
        			document.getElementById("PreviewHSizeDiv").style.display = "none";
                  	document.getElementById("PreviewWSizeDiv").style.display = "none";
        		}
        	}
        	function Change_Click() {
        		var listCount = document.getElementById("listcount").value;
     			var PreviewMode = document.getElementById("PreviewMode").value;
     			var PreviewWList = document.getElementById("WListUser").value;
     			var PreviewWContent = document.getElementById("WPreUser").value;
     			var PreviewHList = document.getElementById("HListUser").value;
     			var PreviewHContent = document.getElementById("HPreUser").value;
     			var allNewBoardListDate = document.getElementById("allNewBoardListDate").value;
     		
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
     					previewHContent : PreviewHContent,
						allNewBoardListDate : allNewBoardListDate
     				} ,
	     			success : function(data, textStatus, jqXHR) {
	     				alert('<spring:message code="ezEmail.t42" />');
     				},
     				error : function(jqXHR, textStatus, errorThrown) {
                	    alert('Error : ' + jqXHR.status + ", " + textStatus);
     				}
     			});       
        	}            
    	</script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;" class="boardGeneral">
			<br/>	
    		<span class="txt">▒ <spring:message code="ezBoard.t0007" /></span>
        	<br />    
        	<table class="content" style="width: 623px;margin-top:5px">
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
				<tr>
					<th><spring:message code="ezBoard.lyj01" /></th>
					<td>
						<select id="allNewBoardListDate" name="pAllNewBoardListDate" style="WIDTH: 100px">
							<option value='5' <c:if test="${boardListConfig.allNewBoardListDate eq '5'}">selected</c:if>>5</option>
							<option value='10' <c:if test="${boardListConfig.allNewBoardListDate eq '10'}">selected</c:if>>10</option>
						</select>
						<spring:message code="ezBoard.t158"/>
					</td>
				</tr>
        	</table>
    		<div class="btnpositionJsp" style="width:623px;">      
        		<a class="imgbtn" onclick="Change_Click()"><span><spring:message code="ezBoard.t98" /></span></a>
        		<a class="imgbtn" onclick="Cancel_Click()"><span><spring:message code="ezBoard.t15" /></span></a>
    		</div>
		</body>
</html>