<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t199' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
		 	var UserAgentState = navigator.userAgent.toLowerCase();
	        var ReturnFunction;
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        
	        if (browserIE) {
	            document.write("<link rel='stylesheet' href='<spring:message code='ezPersonal.e3'/>' type='text/css'>");
	        } else {
	            document.write("<link href='<spring:message code='ezPersonal.e3'/>' rel='stylesheet' type='text/css'>");
	        }
	        
	        window.onload = function () {
	            try {
	                ReturnFunction = opener.personpicture_cross_dialogArguments[1];
	            } catch (e) {
	            }

	        }
	        
	    	function imgConfirm_onclick() {
	        	var doc = iframe.document;
	        	var form = doc.all("logoform");

	        	if (form != null) {
		            var input = form.imagefile;
	            	input = form.imagefile;
	            	if (input.value != "") {
		                if (CheckExt(input.value))
	                    	form.submit();
	                	else
		                    alert("<spring:message code='ezPersonal.t202'/>\n119(width) * 128(height) <spring:message code='ezPersonal.t203'/>\n<spring:message code='ezPersonal.t204'/>");
	        		} else {
	            		alert("<spring:message code='ezPersonal.t200'/>");
			    		return;
					}
	    		}
			}

	        function NotifyResult(filename) {
	            if (ReturnFunction!= null)
	                ReturnFunction(filename);
	            else
	                window.returnValue = filename;
	            window.close();
	        }

			function btnimagefile_onclick() {
	    		document.getElementById("file1").click();
			}

			function divImageFile_onclick() {
	    		if (imagefile.value != "") {
	        		preview.src = "";
	        		preview.style.visibility = "hidden";
			        preview.src = imagefile.value;
	        		preview.style.visibility = "visible";
	    		}
			}

			function CheckExt(pValue) {
	    		var dot = pValue.lastIndexOf(".");
	    		var ext = pValue.substring(dot).toLowerCase();

			    if (ext != ".jpg" && ext != ".gif")
	    		    return false;
	    		else
	        		return true;
			}

			function fileupafter() {
	    		imagefile.value = this.value;
			}

			function btn_AttachAdd_onclick() {
			    var extension = document.getElementById("file1").value.split('.');
			    var check = false;
			    check = compareExtension(check, extension[1]);

			    if (!check) {
	    		    alert("<spring:message code='ezPersonal.t206'/>" + " <spring:message code='ezPersonal.t200'/>");
	        		document.getElementById("file1").value = "";
	    		}

			    var frm = document.getElementById('form');
	    		frm.action = "/ezPersonal/photoUploadByUser.do";
	    		frm.submit();
	    		document.form.file1.value = "";
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
			
			function cancel_onclick() {
	    		if (ReturnFunction != null)
	        		ReturnFunction();
	    		else
	        		window.returnValue = "OK";
	    		window.close();
			}
		</script>
	</head>
	<body class="popup">
    	<h1><spring:message code='ezPersonal.t201'/></h1>
    	<div id="close">
        	<ul>
            	<li><span onclick="cancel_onclick()"><spring:message code='ezPersonal.t12'/></span></li>
        	</ul>
    	</div>
	    <table class="content">
    	    <tr>
        	    <th width="119" height="128" nowrap>
        	    <%String userLang = (String)request.getAttribute("userLang"); %>
            	    <% if (userLang.equals("1")) { %>
                		<img id="preview" name="preview" src="/images/default_pic.jpg" width="119" height="128" alt="" border="0">
                	<%} else { %>
                		<img id="preview" name="preview" src="/images_en/default_pic.jpg" width="119" height="128" alt="" border="0">
                	<%} %>
            	</th>
            	<td style="padding: 5px"><spring:message code='ezPersonal.t202'/><br>
                	119(width) * 128(height)<spring:message code='ezPersonal.t100001'/><br><br>
            	</td>
        	</tr>
    	</table>
    	<br>
    	<table class="content">
        	<tr>
            	<th><a class="imgbtn"><span id="btnimagefile" onclick="btnimagefile_onclick()"><spring:message code='ezPersonal.t20003'/></span></a></th>
            	<td class="pos1" colspan="2">
	                <input id="imagefile" name="imagefile" style="WIDTH: 100%">
				</td>
			</tr>
    	</table>
    	<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
    	<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezPersonal/photoUploadByUser.do" target="ifrm" style="width: 1px; height: 1px;display:none">
        	<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="false" />
    	</form>
	</body>
</html>