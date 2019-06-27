<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t5000" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css" />	    
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.form.js')}"></script>
		<script type="text/javascript" language="javascript">
			$(document).ready(function(){				
				if("<c:out value='${fileName}'/>" != ""){		
					var path = "<c:out value='${filePath}'/>" + "/S_" + "<c:out value='${fileName}'/>";
					document.getElementById("imagewidth").value = "720";
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
				var file1val = document.getElementById("file1").value;
		        var exIndex = file1val.lastIndexOf(".");
				var extension = file1val.substring(exIndex+1, file1val.lenght);
				var filetxt = file1val.substring(file1val.lastIndexOf("\\")+1, file1val.lenght);
				var check = false;
		        check = compareExtension(check, extension);		         

		        if (!check) {
		        	 document.getElementById("file1").value = "";
		        	 document.getElementById("saveFileName").value = "";
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
						var widthOrigin = splitData[2].split("/")[0];
						var heightOrigin = splitData[2].split("/")[1];				
						var per = 720 / widthOrigin;
						var height = Math.floor(heightOrigin * per);
						
						document.getElementById("UploadSliderImage").style.display = "";
						document.getElementById("UploadSliderImage").src = filePath + "/S_" + fileName;
						document.getElementById("imagewidth").value = "720";
			            document.getElementById("imageheight").value = height;
			            document.getElementById("saveFileName").value = fileName;	
			            document.getElementById("filetxt").value = filetxt;
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
				if (document.getElementById("imagewidth").value < 1 || isNaN(document.getElementById("imagewidth").value) 
						|| document.getElementById("imageheight").value < 1 || isNaN(document.getElementById("imageheight").value)) {
		            return;
		        }
				if ((document.getElementById("saveFileName").value == "" || document.getElementById("saveFileName").value == null) && (document.getElementById("type").value != "UPT")) {
		            return;
		        }
				
				if($("#backgroundID").val() == ""){
					var guid = "{" + GetGUID() + "}";
					$("#backgroundID").val(guid);
				}
				
				$('#form').ajaxSubmit({
					type : "POST",
					async : true,
					dataType : "text",
					url : "/admin/ezBoard/saveBackGroundImage.do",					
					success : function() {
						 alert("<spring:message code='ezBoard.t79'/>");
						 
						 try {
					         window.opener.GetBackGroundImage();
						 } catch (e) {
							 try {
								 window.opener.location.reload(false);
							 } catch (e) { }
						 }
						 
				         window.close();
					}
				}); 
			}
	    </script>
	</head>
	<body class="popup" style="overflow:hidden">		
		<h1><spring:message code="ezBoard.t5000"/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return window.close();"></span></li>
            </ul>
        </div>
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
					<input type="file" name="file1" id="file1" style="width:85%;margin-left:3px; display:none;" onchange="btn_AttachAdd_onclick()"/>
					<input type="text" name="filetxt" id="filetxt" style="width:78%;cursor:default;"
					 readonly onclick="SliderImage()"/>
					<a class="imgbtn imgbck" style="height:22px"><span onclick="SliderImage();"><spring:message code="ezBoard.t5010"/></span></a>
					<input type="hidden" name="backgroundID" id="backgroundID" value="<c:out value='${backgroundID}'/>"/>
					<input type="hidden" name="saveFileName" id="saveFileName" />
					<input type="hidden" name="guid" />
					<input type="hidden" name="type" id ="type"  value="<c:out value='${type}'/>" /> 
				</td>
			</tr>
	        <tr>
	            <th><spring:message code="ezBoard.t5002"/></th>
	            <td><input type="text" name="width" id="imagewidth" readonly style="cursor:default; background-color:#f8f8fa;"/>&nbsp;px</td>
	            <th><spring:message code="ezBoard.t5003"/></th>
	            <td><input type="text" name="height" id="imageheight" />&nbsp;px</td>
	        </tr>
	        </form>	
		</table>
	    <div class="btnpositionNew">	    	
	        <a class="imgbtn"><span onclick="btnSave_click();"><spring:message code="ezBoard.t98"/></span></a>
	    </div>	    
	</body>
</html>