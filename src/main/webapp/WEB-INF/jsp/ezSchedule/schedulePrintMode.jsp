<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t261'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script>
		    var ReturnFunction;
		    window.onload = function () {
		         try {
                     ReturnFunction = parent.schedule_print_dialogArguments;
                 } catch (e) {
                     try {
                         ReturnFunction = opener.schedule_print_dialogArguments;
                     } catch (e) {
                     }
                 }
                
                 //LayerPopupLayoutSize(); 뭔지 모르겠음
		    };
		    
		    function ok_click() {
                if (document.getElementById("list").checked) {
                    var leftFrameDocument = parent.parent.frames["left"].document;
                    var blockLeftDiv = leftFrameDocument.getElementById("blockLeft");
                    if (blockLeftDiv) {
                        blockLeftDiv.parentNode.removeChild(blockLeftDiv);
                    }
                    leftFrameDocument.body.style.overflow = "";
                    
                    ReturnFunction("list");
                }
                else if (document.getElementById("calendar").checked) {
                    var leftFrameDocument = parent.parent.frames["left"].document;
                    var blockLeftDiv = leftFrameDocument.getElementById("blockLeft");
                    if (blockLeftDiv) {
                        blockLeftDiv.parentNode.removeChild(blockLeftDiv);
                    }
                    leftFrameDocument.body.style.overflow = "";
                    
                    ReturnFunction("calendar");
                }
                else {
                    alert("<spring:message code='ezSchedule.lhr02' />");
                    return;
                }
            }
		    
		    function Cancel() {
               if (typeof parent.DivPopUpHidden === "function") {
                    parent.DivPopUpHidden();
               }
               
               var leftFrameDocument = parent.parent.frames["left"].document;
               var blockLeftDiv = leftFrameDocument.getElementById("blockLeft");
               if (blockLeftDiv) {
                   blockLeftDiv.parentNode.removeChild(blockLeftDiv);
               }
               leftFrameDocument.body.style.overflow = "";
		    }
		
		    window.onbeforeunload = function () {
		        //if (rvalue[0] == null) {
		        //    rvalue[0] = "0";
		        //    rvalue[1] = "0";
		        //    rvalue[2] = "0";
		        //}
		
		        if (!CrossYN()) {
		            window.returnValue = rvalue;
		            window.close();
		        }
		        
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezSchedule.t261'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return Cancel()"></span></li>
            </ul>
        </div>
		<span id=pMessageContent></span>
		<table class="content" style="margin-top:10px">
			<tr><th><div class="custom_radio" ><input id='list' name ='radioBtn'  type='radio' ></div></th>
			<td><label for="list"><spring:message code='ezSchedule.t261'/></span></td></tr>
			<tr><th ><div class="custom_radio" ><input id='calendar' name='radioBtn'  type='radio' ></div></th>
			<td><label for="calendar"><spring:message code='ezSchedule.lhr01'/></span></td> </tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a id="okbtn" class="imgbtn" onClick="return ok_click()" ><span><spring:message code='ezSchedule.t4'/></span></a>
		    <a id="cancelbtn" class="imgbtn" onClick="return Cancel()" ><span><spring:message code='ezSchedule.t16'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>