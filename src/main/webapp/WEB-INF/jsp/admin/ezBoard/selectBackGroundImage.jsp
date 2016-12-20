<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t5000" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.form.js"></script>
		<script type="text/javascript" language="javascript">
			$(document).ready(function(){				
				if("<c:out value='${fileName}'/>" != ""){		
					var path = "<c:out value='${filePath}'/>" + "/S_" + "<c:out value='${fileName}'/>";

					document.getElementById("imagewidth").value = "<c:out value='${width}'/>";
		            document.getElementById("imageheight").value = "<c:out value='${height}'/>";
					document.getElementById("UploadSliderImage").style.display = "";
					document.getElementById("UploadSliderImage").src = path;
				}
			});
			
			function S4() {
		        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		    }

		    function GetGUID() {
		        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		    }
			
			function SliderImage() {		     
				document.getElementById("file1").click();
			}
			
			function btn_AttachAdd_onclick() {
		        var extension = document.getElementById("file1").value.split('.');
		        var check = false;
		        check = compareExtension(check, extension[1]);		         
		        
		        if (!check) {
		            document.getElementById("file1").value = "";
		        }
		        var guid = "{" + GetGUID() + "}";
		        document.form.guid.value = guid;	       
		        
		        $('#form').ajaxSubmit({
		        	type : 'POST',
					dataType : 'text',
		        	url : "/admin/ezBoard/uploadBackGroundImage.do",					
					success : function(result) {
						var splitData = result.split(",");						
						var filePath = splitData[0];
						var fileName = splitData[1];
						var width = splitData[2].split("/")[0];
						var height = splitData[2].split("/")[1];						
												
						document.getElementById("UploadSliderImage").style.display = "";
						document.getElementById("UploadSliderImage").src = filePath + "/S_" + fileName;
						document.getElementById("imagewidth").value = width;
			            document.getElementById("imageheight").value = height;
			            document.getElementById("saveFileName").value = fileName;			            		            
					},
					error : function(){
						alert("upload error");						
					}
		        });						           
		    }
			
			function compareExtension(check, extension) {
		        var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
		        for (var i = 0; i < filterExtension.length; i++) {
		            if (extension.toLowerCase() == filterExtension[i]) {
		                check = true;
		                break;
		            }
		        }
		        return check;
		    }
			
			function btnSave_click(){
				if($("#backgroundID").val() == ""){
					var guid = "{" + GetGUID() + "}";
					$("#backgroundID").val(guid);
				}
				
				$('#form').ajaxSubmit({
					type : "POST",
					dataType : "text",
					url : "/admin/ezBoard/saveBackGroundImage.do",					
					success : function(){
						 alert("<spring:message code='ezBoard.t79'/>");
				         window.opener.location.reload(false);
				         window.close();	
					}
				}); 
			}
	    </script>
	</head>
	<body class="popup" style="overflow:hidden">		
		<h1><spring:message code="ezBoard.t5000"/></h1>
		<table style="width:500px" id="toggle_tbl1" class="content">
			<tr>
				<th>
					<spring:message code="ezBoard.t5011"/>
				</th>
				<td colspan="3">
					<table style="width:471px;height:217px" border="0">
						<tr>
							<td id="tdNormalImage" style="width:467px;height:200px">
								<img id="UploadSliderImage" src="" style="width:467px;height:200px;display:none" />								
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<form id="form" name="form" style="width:1px;height:1px" enctype="multipart/form-data">
			<tr>
				<th><spring:message code="ezBoard.t5001"/></th>
				<td colspan="3">					
					<input type="file" name="file1" id="file1" style="width:85%;margin-left:3px" onchange="btn_AttachAdd_onclick()" multiple="false" />
					<input type="hidden" name="backgroundID" id="backgroundID" value="<c:out value='${backgroundID}'/>"/>
					<input type="hidden" name="saveFileName" id="saveFileName" />
					<input type="hidden" name="guid" />
					<input type="hidden" name="type" value="<c:out value='${type}'/>" /> 
				</td>
			</tr>
	        <tr>
	            <th><spring:message code="ezBoard.t5002"/></th>
	            <td>&nbsp;<input type="text" name="width" id="imagewidth" />&nbsp;px</td>
	            <th><spring:message code="ezBoard.t5003"/></th>
	            <td>&nbsp;<input type="text" name="height" id="imageheight" />&nbsp;px</td>
	        </tr>
	        </form>	
		</table>
	    <div class="btnposition">	    	
	        <a href="#" class="imgbtn"><span onclick="btnSave_click();"><spring:message code="ezBoard.t98"/></span></a>
	        <a href="#" class="imgbtn"><span onclick="return window.close();"><spring:message code="ezBoard.t15"/></span></a>
	    </div>	    
	</body>
</html>