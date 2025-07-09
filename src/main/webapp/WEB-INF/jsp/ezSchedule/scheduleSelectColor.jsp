<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.csj02' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <style>
	    	.popup_color {
	    		box-sizing: border-box;
	    		background-color: white;
	    	}
	    	
	    	.popup_color_footer .btn {
	    		width: 70%; 
	    		height: 53%;
	    		margin-top: 12px; 
	    		margin-right: 8px; 
	    		border: none; 
	    		border-radius: 5px; 
	    		cursor: pointer;
	    	}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script>			
		    var color = "<c:out value='${color}' />";
		    var type = "<c:out value='${type}' />";
		    var relatedID = "<c:out value='${relatedID}' />";
	        var DefaultColor = "";
	
		    window.onload = function () {
		    	DefaultColor = color;
		        
		        document.getElementById("sel_color").value = (DefaultColor == "" ? "#ff8080" : DefaultColor);
		    	document.getElementById("selected_color").style.backgroundColor = document.getElementById("sel_color").value;
			}
		    
		    function select_color(e) {
        		sel_color.value = event.srcElement.title;
	        	document.getElementById("selected_color").style.backgroundColor = document.getElementById("sel_color").value;
            }
           
            function ok_onclick() {
		        if (document.all("sel_color").value == "") {
		        	alert("<spring:message code='ezSchedule.csj03' />");
		        	return;
		        }

         		window.returnValue = sel_color.value;
         		select_color_complete(type, window.returnValue);
         	    parent.DivPopUpHidden();
            }

		    function btn_close() {
		        parent.DivPopUpHidden();
		    }
		    
		    function select_color_complete(scheduleType, color) {
		    	
		    	var selector = "div[data-schedule-type='" + scheduleType + "']";
		    	
		    	if (scheduleType !== 4) {
		    		selector += "[data-related-id='" + relatedID + "']";
		    	}
		    	
		    	parent.document.querySelector(selector).style.backgroundColor = color;
		    	parent.document.querySelector(selector).nextElementSibling.innerHTML = color;
		    }
		</script>
	</head>
	<body class="popup_color">
		<div class="popup_color_header" style="width: 100%;height: 50px;float: left;">
			<div class="popup_color_title" style="width: 150px;height: 30px;margin: auto;margin-top: 10px;text-align: center;">
				<span style="font-size: 20px;"><b><spring:message code='ezSchedule.csj02'/></b></span>
			</div>
		</div>
		<div class="popup_color_body" style="width: 100%;float: left;margin-top: 10px;margin-bottom: 10px;">
			<div class="popup_color_table" style="width: 85%; height: 70%; margin: auto; border: 1px solid #d2d2d2;">
				<table onclick="select_color(event)" id="colorTable" style="width:100%; height:100%; cursor: pointer; border-collapse: separate; table-layout:fixed; border-spacing: 2px;">
		            <tr>
		                <td style="background-color: #e9de13" title="#e9de13">&nbsp;</td>
		                <td style="background-color: #ff8080" title="#ff8080">&nbsp;</td>
		                <td style="background-color: #80ff80" title="#80ff80">&nbsp;</td>
		                <td style="background-color: #00ff80" title="#00ff80">&nbsp;</td>
		                <td style="background-color: #80ffff" title="#80ffff">&nbsp;</td>
		                <td style="background-color: #0080ff" title="#0080ff">&nbsp;</td>
		                <td style="background-color: #ff80c0" title="#ff80c0">&nbsp;</td>
		                <td style="background-color: #ff80ff" title="#ff80ff">&nbsp;</td>
		            </tr>
		            <tr>
		                <td style="background-color: #ffff00" title="#ffff00">&nbsp;</td>
		                <td style="background-color: #ff8040" title="#ff8040">&nbsp;</td>
		                <td style="background-color: #80ff00" title="#80ff00">&nbsp;</td>
		                <td style="background-color: #00ff40" title="#00ff40">&nbsp;</td>
		                <td style="background-color: #00ffff" title="#00ffff">&nbsp;</td>
		                <td style="background-color: #0080c0" title="#0080c0">&nbsp;</td>
		                <td style="background-color: #8080c0" title="#8080c0">&nbsp;</td>
		                <td style="background-color: #ff00ff" title="#ff00ff">&nbsp;</td>
		            </tr>
		            <tr>
		                <td style="background-color: #804040" title="#804040">&nbsp;</td>
		                <td style="background-color: #f27405" title="#f27405">&nbsp;</td>
		                <td style="background-color: #00ff00" title="#00ff00">&nbsp;</td>
		                <td style="background-color: #008080" title="#008080">&nbsp;</td>
		                <td style="background-color: #004080" title="#004080">&nbsp;</td>
		                <td style="background-color: #8080ff" title="#8080ff">&nbsp;</td>
		                <td style="background-color: #800040" title="#800040">&nbsp;</td>
		                <td style="background-color: #ff0080" title="#ff0080">&nbsp;</td>
		            </tr>
		            <tr>
		                <td style="background-color: #800000" title="#800000">&nbsp;</td>
		                <td style="background-color: #ff0000" title="#ff0000">&nbsp;</td>
		                <td style="background-color: #008000" title="#008000">&nbsp;</td>
		                <td style="background-color: #008040" title="#008040">&nbsp;</td>
		                <td style="background-color: #0000ff" title="#0000ff">&nbsp;</td>
		                <td style="background-color: #0000a0" title="#0000a0">&nbsp;</td>
		                <td style="background-color: #800080" title="#800080">&nbsp;</td>
		                <td style="background-color: #8000ff" title="#8000ff">&nbsp;</td>
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
		                <td style="background-color: #c0c0c0" title="#c0c0c0">&nbsp;</td>
		                <td style="background-color: #400040" title="#400040">&nbsp;</td>
		                <td style="background-color: #ffffff" title="#ffffff">&nbsp;</td>
		            </tr>
		        </table>
			</div>
			<div class="popup_color_text" style="width: 85%; height: 18%; margin: auto; margin-top: 10px;">
				<table class="popup_color_content" style="width: 100%; height: 100%; border: 1px solid #d2d2d2;">
                    <tr>
                        <th style="width: 20%; font-size: 13px; font-weight: bold; color: black;">Color:</th>
                        <td>
                        	<div id="selected_color" style="width: 28px; height: 25px; float: left; margin-top: 1px; margin-left: 8px; background-color: #e9de13;"></div>
                        	<div id="selected_color_text" style="width: 150px; height: 25px; float: left; margin-top: 1px; margin-left: 8px;">
                        		<input type="text" id="sel_color" style="width: 100px;" readonly>
                        	</div>
                         </td>
                    </tr>
                </table>
			</div>
		</div>
		<div class="popup_color_footer" style="width: 100%; height: 50px; float: left;">
			<div style="width: 50%; height: 100%; float: left;">
				<button type="button" class="btn" onClick="return ok_onclick()" style="background-color: #0684f9; float: right;">
					<span style="font-size: 14px; font-weight: bold; color: #ffffff;"><spring:message code='ezSchedule.t4'/></span>
				</button>
			</div>
			<div style="width: 50%; height: 100%; float: right;">
				<button type="button" class="btn" onClick="return btn_close()" style="background-color: #d2d2d2; float: left;">
					<span style="font-size: 14px; font-weight: bold; color: #666;"><spring:message code='ezSchedule.t5'/></span>	
				</button>
			</div>
		</div>
	</body>
</html>