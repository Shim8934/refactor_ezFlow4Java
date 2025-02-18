<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezTask.t91" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/jquery-hex-colorpicker.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezTask/jquery-hex-colorpicker.js')}"></script>
	    
	    <script type="text/javascript">
	    
		    var currentColor = window.opener.currentColor;
		    var statusName = window.opener.statusName;
		    
		    $(function() {
				$("#color-picker").hexColorPicker();
				$("#color-picker").click();
				$("div[color='" + currentColor + "']").click();
			});

			
			function ok_onclick() {
				var selectColor = $(".selected-color").val();
				
				$(opener.document).find("#" + statusName + "Display").css("background-color", selectColor);
				$(opener.document).find("#" + statusName).text(selectColor);

				window.close();
			}
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code="ezTask.t91" /></h1>
	    <!-- <table onClick="select_color(event)" border="1" cellspacing="2" id="ColorTable" style="width:259px;" class="box">
			<tr>
			    <td style="width:32px; background-color: #FF8080" title="#FF8080">&nbsp;</td>
			    <td style="width:32px; background-color: #FFFF80" title="#FFFF80">&nbsp;</td>
			    <td style="width:32px; background-color: #80FF80" title="#80FF80">&nbsp;</td>
			    <td style="width:32px; background-color: #00FF80" title="#00FF80">&nbsp;</td>
			    <td style="width:32px; background-color: #80FFFF" title="#80FFFF">&nbsp;</td>
			    <td style="width:32px; background-color: #0080FF" title="#0080FF">&nbsp;</td>
			    <td style="width:32px; background-color: #FF80C0" title="#FF80C0">&nbsp;</td>
			    <td style="width:32px; background-color: #FF80FF" title="#FF80FF">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td style="background-color: #FF0000" title="#FF0000">&nbsp;</td>
			    <td style="background-color: #FFFF00" title="#FFFF00">&nbsp;</td>
			    <td style="background-color: #80FF00" title="#80FF00">&nbsp;</td>
			    <td style="background-color: #00FF40" title="#00FF40">&nbsp;</td>
			    <td style="background-color: #00FFFF" title="#00FFFF">&nbsp;</td>
			    <td style="background-color: #0080C0" title="#0080C0">&nbsp;</td>
			    <td style="background-color: #8080C0" title="#8080C0">&nbsp;</td>
			    <td style="background-color: #FF00FF" title="#FF00FF">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td style="background-color: #804040" title="#804040">&nbsp;</td>
			    <td style="background-color: #FF8040" title="#FF8040">&nbsp;</td>
			    <td style="background-color: #00FF00" title="#00FF00">&nbsp;</td>
			    <td style="background-color: #008080" title="#008080">&nbsp;</td>
			    <td style="background-color: #004080" title="#004080">&nbsp;</td>
			    <td style="background-color: #8080FF" title="#8080FF">&nbsp;</td>
			    <td style="background-color: #800040" title="#800040">&nbsp;</td>
			    <td style="background-color: #FF0080" title="#FF0080">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td style="background-color: #800000" title="#800000">&nbsp;</td>
			    <td style="background-color: #FF8000" title="#FF8000">&nbsp;</td>
			    <td style="background-color: #008000" title="#008000">&nbsp;</td>
			    <td style="background-color: #008040" title="#008040">&nbsp;</td>
			    <td style="background-color: #0000FF" title="#0000FF">&nbsp;</td>
			    <td style="background-color: #0000A0" title="#0000A0">&nbsp;</td>
			    <td style="background-color: #800080" title="#800080">&nbsp;</td>
			    <td style="background-color: #8000FF" title="#8000FF">&nbsp;</td>
		  	</tr>
		  	<tr>
			    <td style="background-color: #400000" title="#400000">&nbsp;</td>
			    <td style="background-color: #804000" title="#804000">&nbsp;</td>
			    <td style="background-color: #004000" title="#004000">&nbsp;</td>
			    <td style="background-color: #004040" title="#004040">&nbsp;</td>
			    <td style="background-color: #000080" title="#000080">&nbsp;</td>
			    <td style="background-color: #000040" title="#000040">&nbsp;</td>
			    <td style="background-color: #400040" title="#400040">&nbsp;</td>
			    <td style="background-color: #400080" title="#400080">&nbsp;</td>
		  </tr>
		  <tr>
			    <td style="background-color: #000000" title="#000000">&nbsp;</td>
			    <td style="background-color: #808000" title="#808000">&nbsp;</td>
			    <td style="background-color: #808040" title="#808040">&nbsp;</td>
			    <td style="background-color: #808080" title="#808080">&nbsp;</td>
			    <td style="background-color: #408080" title="#408080">&nbsp;</td>
			    <td style="background-color: #C0C0C0" title="#C0C0C0">&nbsp;</td>
			    <td style="background-color: #400040" title="#400040">&nbsp;</td>
			    <td style="background-color: #FFFFFF" title="#FFFFFF">&nbsp;</td>
		  </tr>
		</table> -->
		<input type="text" id="color-picker" style="display:none;"></input>
<!-- 		<div class="box" style="width:239px;margin-top:2px">		 -->
<!-- 		    <table> -->
<!-- 		        <tr> -->
<!-- 		            <td id="Td1" style="padding-right:10px">Color : </td> -->
<!-- 		            <td><div id=selColorShow style="background-color:black; width:20px; height:21px; border:1px inset gray"></div></td> -->
<!-- 		            <td style="padding-left:10px"><input type="text" id=selColor></td> -->
<!-- 		        </tr> -->
<!-- 		    </table> -->
<!-- 		</div> -->
<!-- 		<div class="btnposition"> -->
<%-- 		    <a class="imgbtn"><span onclick="ok_onclick()" ><spring:message code="ezTask.t19" /></span></a> --%>
<%-- 		    <a class="imgbtn"><span onclick="window.close()" ><spring:message code="ezTask.t20" /></span></a> --%>
<!-- 		</div> -->
	</body>	
</html>