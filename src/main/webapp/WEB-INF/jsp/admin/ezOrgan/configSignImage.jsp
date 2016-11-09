<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t185" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var userid = "<c:out value='${userID}'/>";
		    var SignImageSize = "<c:out value='${signImageSize}'/>";
		    var SignPath = "<c:out value='${signPath}'/>";
			
			$(document).ready(function(){
				GetSignInfo();
			});
			
			function GetSignInfo(){				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/getEntryInfo.do",
					async : false,
					data : {cn : userid, prop : "extensionAttribute3", pMode : "user" },
					success : function(xml){
						result=loadXMLString(xml);
						xmlDom = result;
			            var signinfo = SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE3");
						imagelist = signinfo.split(";");

						var length = signlist.length;
						for (var i=0; i<length; i++){
							signlist.options[0] = null;
						}
						if (signinfo != "" && trim(signinfo).replace('\n', '') != ""){
							for (var i=0; i<imagelist.length; i++){
								var newoption = new Option("<spring:message code='ezOrgan.t186' />" + i, imagelist[i]);
								signlist.options[i] = newoption;
							}
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t187' />");
					}
				});
			}			
			function trim(str){
		        while (str && str.indexOf(" ") == 0){
		            str = str.substring(1);
		        }
		        while (str && str.lastIndexOf(" ") == str.length - 1){
		            str = str.substring(0, str.length - 1);
		        }
		        return str;
		    }
			function sign_change() {
				/* if(SignPath == "APPROVAL"){
		        	signimage.innerHTML = "<img src=" + window.document.location.protocol + "//" + window.document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=" + SignPath + "&FILENAME=" + signlist.value + " width=50 height=50>";
				}else{
					signimage.innerHTML = "<img src=" + window.document.location.protocol + "//" + window.document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=" + SignPath + "&FILENAME=" + signlist.value + " width=50 height=50>";
				} */				
				var imgSrc = "/admin/ezOrgan/getApprovalSignInfo.do?type="+SignPath+"&fileName="+encodeURI(signlist.value);
				signimage.innerHTML = "<img src="+imgSrc+" width=50 height=50 />";
		    }			
			function add_sign(ocx_file) {
		        document.getElementById('mode').value = "PHOTO";
		        document.form.file1.click();
		    }
			function del_sign()	{
				if (signlist.selectedIndex == -1) {
					alert("<spring:message code='ezOrgan.t188' />");
					return;
				}
				
				if (!confirm("'" + signlist.options[signlist.selectedIndex].innerText + "'<spring:message code='ezOrgan.t130' />")) {
					return;
				}
				
				var imagelist = "";
				for (var i=0; i<signlist.length; i++) {
					if (i != signlist.selectedIndex) {
						if (imagelist != "") {
							imagelist += ";" + signlist.options[i].value;
						} else {
							imagelist = signlist.options[i].value;
						}
					}
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveUserInfo.do",
					data : {parentCn : "", cn : userid, prop : "", extensionAttribute3 : imagelist},
					success : function(result){
						if(result != "OK"){
							alert("<spring:message code='ezOrgan.t189' />");
						}else{
							alert("<spring:message code='ezOrgan.t190' />");
							signimage.innerHTML ="<B><spring:message code='ezOrgan.t191' /></B>";
							GetSignInfo();
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t189' />");
					}
				});			   
			}			
			function btn_AttachAdd_onclick(obj) {
		        if (document.form.file1.value != "") {
		        	// TODO : 2016-04-22 장진혁과장 --우선적으로 서명 1개만 등록할 수 있도록 구현
		            if (document.getElementById('mode').value == "PHOTO") {
		                if (document.getElementById("form").file1.files.length > 1) {
				            alert("<spring:message code='ezOrgan.t9902' />");
				        }
		            } 
        
		            var fd = new FormData();
		            var mode = "";
		         	// TODO : 2016-04-22 장진혁과장 --우선적으로 서명 1개만 등록할 수 있도록 구현
		            fd.append("file1", document.getElementById("form").file1.files[0]);
		            
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            
		            if (SignPath == "APPROVALGSIGN") {
		            	mode = "GLOGO";
		            } else {
		            	mode = "LOGO";
		            }
		            
		            xhr.open("POST", "/admin/ezOrgan/signImageUpload.do?mode="+mode+"&userID=" + userid);
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
		        	var fileName = encodeURI(xhr.responseText);
					
					$.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/saveUserInfo.do",
						data : {parentCn : "", cn : userid, prop : "", extensionAttribute3 : encodeURI(fileName)},
						success : function(result){
							if(result != "OK"){
								alert("<spring:message code='ezOrgan.t119' />");
							}else{
								GetSignInfo();
							}
						},
						error : function(){
							alert("<spring:message code='ezOrgan.t269' />");
						}
					});
		        }		      
		    }
	    </script>
	</head>
	<body class="popup"> 
		<h1><spring:message code='ezOrgan.t194' /></h1>		 
		<table class="popuplist"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t195' /></th> 
		    	<th><h2><spring:message code='ezOrgan.t140' /></h2></th> 
		  	</tr> 
		  	<tr> 
		    	<td> 
		    		<select id="signlist" size="10" style="width:150px;height:150px" onChange="sign_change()"> </select>
		    	</td> 
		    	<td id="signimage" style="width:150px;height:150px;text-align:center" class="point"><spring:message code='ezOrgan.t191' /></td> 
		  	</tr> 
		</table> 
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" />
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="tempFilePath" id="tempFilePath" />
		</form>		
		<div class="btnposition">
		    <a class="imgbtn" onClick="add_sign()"><span><spring:message code='ezOrgan.t141' /></span></a>
		    <a class="imgbtn" onClick="del_sign()"><span><spring:message code='ezOrgan.t142' /></span></a>
		    <a class="imgbtn" onClick="window.close()"><span><spring:message code='ezOrgan.t143' /></span></a>
		</div>		
	</body>
</html>