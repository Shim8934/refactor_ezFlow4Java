<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezOrgan.t238" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var fileName = "";
		    var ReturnFunction;
		    var RetValue;
	    	
			$(document).ready(function(){
				try {
		            RetValue = parent.personpicture_cross_dialogArguments[0];
		            ReturnFunction = parent.personpicture_cross_dialogArguments[1];
		        }catch(e){
		            try {
		                RetValue = opener.personpicture_cross_dialogArguments[0];
		                ReturnFunction = opener.personpicture_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
			});
			
			function btnimagefile_onclick(){
			    try {
			        document.form.file1.click();
				}catch(e){
					alert(e.discription);
				}
			}
			
			function imgtemp_onclick() {
	            if (document.form.file1.value != "") {
	            	if (document.getElementById("form").file1.files.length > 1) {
			            alert("<spring:message code='ezOrgan.t9902' />");
			        }
	            	
		            var fd = new FormData();		            
		            fd.append("file1", document.getElementById("form").file1.files[0]);
		            
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            
		            xhr.open("POST", "/admin/ezOrgan/signImageUpload.do?mode=PICTURE&userID=" + RetValue);
		            xhr.send(fd);
		        }
	        }
			
			function uploadComplete() {		        
		        if(xhr.responseText == "UPLOAD_ERROR"){
		        	alert("<spring:message code='fail.common.msg' />");
		        	
		        	document.getElementById("file1").value = "";
		        	document.getElementById("tempFilePath").value = "";
		        }else{
		        	document.getElementById("tempFilePath").value = xhr.responseText;
		        	document.getElementById("imagefile").value = xhr.responseText;
		        }
		        //returnvalue(xhr.responseText);
		    }
			
			function imgConfirm_onclick(obj) {
				if (document.getElementById("form").file1.files.length == 0) {
		            alert("<spring:message code='ezOrgan.t9903' />");
		            return;
		        }
				
				var fileName = document.getElementById("tempFilePath").value;
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveUserInfo.do",
					data : {parentCn : "", cn : RetValue, prop : "", extensionAttribute2 : fileName},
					success : function(result){
						if(result != "OK"){
							alert("<spring:message code='ezOrgan.t119' />");
						}else{
							if (ReturnFunction != null){
				                ReturnFunction(fileName);
							}else{
				                window.returnValue = fileName;
							}
				            window.close();
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t269' />");
					}
				});
			}
			
			function close_Click() {
			    //if(CrossYN()){
			    parent.DivPopUpHidden();
			    /* }else{
			        window.close();
			    } */
			}
			
			function divImageFile_onclick() {
			    if (document.form.file1.value != "") {
			        preview.src = "";
					preview.style.visibility = "hidden";
					preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + document.getElementById("tempFilePath").value;
					preview.style.visibility = "visible";
				}
			}
	    </script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezOrgan.t240' /></h1>		
		<table class="content"> 
			<tr>
		    	<th width="119" height="128"><img <spring:message code='ezOrgan.i6' />></th>
		    	<td>
		    		<spring:message code='ezOrgan.t241' /><br/>
		      		119*128px<spring:message code='ezOrgan.t10000' />
		      		<br/>
			  		<a class="imgbtn"><span onClick="divImageFile_onclick()"><spring:message code='ezOrgan.t244' /></span></a>
			  	</td>
		  	</tr>
		</table>
		<table class="content" style="margin-top:5px" > 
			<tr>
		    	<th><spring:message code='ezOrgan.t245' /></th>
		    	<td width="100%">
		    		<input id=imagefile name=imagefile style=" WIDTH: 210px" readonly="readonly" />
		    		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		    		<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
		  				<input type="file" name="file1" id="file1" style="width: 1px; height: 1px;" onchange="imgtemp_onclick()" multiple="true" />
		    			<input type="hidden" name="mode" id="mode" />
		    			<input type="hidden" name="tempFilePath" id="tempFilePath" />
		    		</form>
					<a class="imgbtn"><span id="btnimagefile" onClick="btnimagefile_onclick()" style="width:25px"><spring:message code='ezOrgan.t101' /></span></a>
				</td>
		  	</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onClick="imgConfirm_onclick()"><spring:message code='ezOrgan.t246' /></span></a>
		    <a class="imgbtn"><span onClick="close_Click()"><spring:message code='ezOrgan.t111' /></span></a>
		</div>		
	</body>
</html>