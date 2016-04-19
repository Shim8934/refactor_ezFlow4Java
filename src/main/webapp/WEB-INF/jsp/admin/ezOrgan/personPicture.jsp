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
		    		<input id=imagefile name=imagefile style=" WIDTH: 210px" />
		    		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		    		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/myoffice/ezOrgan/admin/signImange_upload_Cross.aspx?mode=PICTURE" target="ifrm">
		  				<input type="file" name="file1" id="file1"  style="width: 1px; height: 1px;" onchange="imgtemp_onclick()" multiple="true" />
		    			<input type="hidden" name="mode" id="mode" />
		    		</form>
					<a class="imgbtn"><span id="btnimagefile" onClick="btnimagefile_onclick()" style="width:25px"><spring:message code='ezOrgan.t101' /></span></a>
				</td>
		  	</tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn"><span onClick="imgConfirm_onclick()"><spring:message code='ezOrgan.t246' /></span></a>
		    <a class="imgbtn"><span onClick="close_Click()"><spring:message code='ezOrgan.t111' /></span></a>
		</div>
		<IFRAME id=iframe style="DISPLAY:none" src="Uploadform.aspx"></IFRAME>
	</body>
</html>