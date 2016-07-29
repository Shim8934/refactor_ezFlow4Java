<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<title><spring:message code='ezEmail.t408' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="<spring:message code='ezEmail.c3' />" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript">
	    var ReturnFunction;
	    window.onload = function()
	    {
	        try {
	            ReturnFunction = parent.manycolor_dialogArguments[1];
	        } catch (e) {
	            try {
	                ReturnFunction = opener.manycolor_dialogArguments[1];
	            } catch (e) {
	                
	            }
	        }
	
			selColor.value = "#ffffff";
			document.getElementById("selColorShow").style.backgroundColor = document.getElementById("selColor").value;
		}
		
		function select_color(e)
		{
		    if (window.ActiveXObject) {
			    selColor.value = event.srcElement.title;
			    document.getElementById("selColorShow").style.backgroundColor = document.getElementById("selColor").value;
			}
			else {
			    selColor.value = e.target.title;
			    document.getElementById("selColorShow").style.backgroundColor = document.getElementById("selColor").value;
			}
		}
	
		function ok_onclick()
		{
		    if (ReturnFunction != null)
	            ReturnFunction(selColor.value);
	        else
	            window.returnValue = selColor.value;
			window.close();
		}
	</script>
	</head>
	
	<body class="popup">
		<h1><spring:message code='ezEmail.t408' /></h1>
	    <div class="box" style="width: 256px;">
			<table onClick="select_color(event)" id="ColorTable"  style="cursor:pointer;width:256px;border-collapse:separate; border-spacing:2px;">
			  <tr>
			    <td style="width:32px;background-color:#ff8080" title="#ff8080">&nbsp;</td>
			    <td style="width:32px;background-color:#ffff80" title="#ffff80">&nbsp;</td>
			    <td style="width:32px;background-color:#80ff80" title="#80ff80">&nbsp;</td>
			    <td style="width:32px;background-color:#00ff80" title="#00ff80">&nbsp;</td>
			    <td style="width:32px;background-color:#80ffff" title="#80ffff">&nbsp;</td>
			    <td style="width:32px;background-color:#0080ff" title="#0080ff">&nbsp;</td>
			    <td style="width:32px;background-color:#ff80c0" title="#ff80c0">&nbsp;</td>
			    <td style="width:32px;background-color:#ff80ff" title="#ff80ff">&nbsp;</td>
			  </tr>
			  <tr>
			    <td style="background-color:#ff0000" title="#ff0000">&nbsp;</td>
			    <td style="background-color:#ffff00" title="#ffff00">&nbsp;</td>
			    <td style="background-color:#80ff00" title="#80ff00">&nbsp;</td>
			    <td style="background-color:#00ff40" title="#00ff40">&nbsp;</td>
			    <td style="background-color:#00ffff" title="#00ffff">&nbsp;</td>
			    <td style="background-color:#0080c0" title="#0080c0">&nbsp;</td>
			    <td style="background-color:#8080c0" title="#8080c0">&nbsp;</td>
			    <td style="background-color:#ff00ff" title="#ff00ff">&nbsp;</td>
			  </tr>
			  <tr>
			    <td style="background-color:#804040" title="#804040">&nbsp;</td>
			    <td style="background-color:#ff8040" title="#ff8040">&nbsp;</td>
			    <td style="background-color:#00ff00" title="#00ff00">&nbsp;</td>
			    <td style="background-color:#008080" title="#008080">&nbsp;</td>
			    <td style="background-color:#004080" title="#004080">&nbsp;</td>
			    <td style="background-color:#8080ff" title="#8080ff">&nbsp;</td>
			    <td style="background-color:#800040" title="#800040">&nbsp;</td>
			    <td style="background-color:#ff0080" title="#ff0080">&nbsp;</td>
			  </tr>
			  <tr>
			    <td style="background-color:#800000" title="#800000">&nbsp;</td>
			    <td style="background-color:#ff8000" title="#ff8000">&nbsp;</td>
			    <td style="background-color:#008000" title="#008000">&nbsp;</td>
			    <td style="background-color:#008040" title="#008040">&nbsp;</td>
			    <td style="background-color:#0000ff" title="#0000ff">&nbsp;</td>
			    <td style="background-color:#0000a0" title="#0000a0">&nbsp;</td>
			    <td style="background-color:#800080" title="#800080">&nbsp;</td>
			    <td style="background-color:#8000ff" title="#8000ff">&nbsp;</td>
			  </tr>
			  <tr>
			    <td style="background-color:#400000" title="#400000">&nbsp;</td>
			    <td style="background-color:#804000" title="#804000">&nbsp;</td>
			    <td style="background-color:#004000" title="#004000">&nbsp;</td>
			    <td style="background-color:#004040" title="#004040">&nbsp;</td>
			    <td style="background-color:#000080" title="#000080">&nbsp;</td>
			    <td style="background-color:#000040" title="#000040">&nbsp;</td>
			    <td style="background-color:#400040" title="#400040">&nbsp;</td>
			    <td style="background-color:#400080" title="#400080">&nbsp;</td>
			  </tr>
			  <tr>
			    <td style="background-color:#000000" title="#000000">&nbsp;</td>
			    <td style="background-color:#808000" title="#808000">&nbsp;</td>
			    <td style="background-color:#808040" title="#808040">&nbsp;</td>
			    <td style="background-color:#808080" title="#808080">&nbsp;</td>
			    <td style="background-color:#408080" title="#408080">&nbsp;</td>
			    <td style="background-color:#c0c0c0" title="#c0c0c0">&nbsp;</td>
			    <td style="background-color:#400040" title="#400040">&nbsp;</td>
			    <td style="background-color:#ffffff" title="#ffffff">&nbsp;</td>
			  </tr>
			</table>
	    </div>
		<div class="box" style="width: 256px; margin-top: 2px;">
	        <table>
	            <tr style="height: 21px;">
	                <td>Color:</td>
	                <td id="selColorShow" style="width: 28px; height: 21px; background-color: black; border: 1px inset gray"></td>
	                <td>&nbsp;&nbsp;<input type="text" id="selColor">
	                </td>
	            </tr>
	        </table>
	
	    </div>
		<div class="btnposition">
		    <a class="imgbtn" id="ok"  onClick="ok_onclick()"><span><spring:message code='ezEmail.t38' /></span></a>
		    <a class="imgbtn" onClick="window.close()"><span><spring:message code='ezEmail.t39' /></span></a>
		
		</div>
	
	</body>
</html>



