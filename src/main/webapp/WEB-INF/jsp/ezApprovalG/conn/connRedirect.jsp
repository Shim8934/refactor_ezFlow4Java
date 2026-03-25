<%@ page language="java" contentType="text/html; charset=UTF-8" 
         pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %> 
<!DOCTYPE html> 
<html> 
<head> 
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
    <meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
    <title>redirect...</title> 
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <style>
        #iFramePanel {
            position : fixed;
            top : 50%;
            left : 50%;
            transform : translate(-50%, -50%);
        }
        .popup_noti {
            width : 330px;
        }
    </style>
</head> 
<body> 
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    <div class="popup_noti">
		    <div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
	 	<div class="popup_noti_content">
	        <div  style="padding:10px 10px 0px 10px;">
	          <table>
	            <tr>
	              <td  class="cimg"></td>
	              <td  class="ctxt" ><span id="pMessageContent" >팝업이 차단되어 있습니다.<br>팝업 차단 해제 후 확인을 눌러주세요.</span></td>
	            </tr>
	     </table>
	 	    </div>
	    </div>
	    <div class="popup_noti_btnarea"> 
	   	    <div class="btnposition"> 
	               <input type="submit"  value="<spring:message code='ezApprovalG.t20'/>" id="Submit1" name="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()" >
		    </div>
	        <span class="bl"> </span> <span class="br"></span>
	    </div>
	    </div>
    </div>
<input type="hidden" id="redUrl" value="${redUrl}"> 
<script type="text/javascript"> 
    window.onload = function() { 
        var redUrl = document.querySelector("#redUrl").value; 
        try { 
            var heigth = window.screen.availHeight; 
            var width = window.screen.availWidth; 
 
            var left = 0; 
            var top = 0; 
 
            if (window.screen.width > 800) { 
                var pleftpos; 
 
                pleftpos = parseInt(width) - 1150; 
                heigth = parseInt(heigth) - 25; 
 
                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) 
                    heigth = parseInt(heigth) - 40; 
 
                width = parseInt(width) - pleftpos; 
 
                left = pleftpos / 2; 
            } 
            else { 
 
                heigth = parseInt(heigth) - 25; 
 
                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) 
                    heigth = parseInt(heigth) - 40; 
 
                width = parseInt(width) - 10; 
            } 
 
            const newWin = window.open("", "_blank", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left); 
            if (!newWin) {
                document.getElementById("iFramePanel").style.display = "";
                document.getElementById("mailPanel").style.display = "";
                return;
            } else {
                newWin.location.href = redUrl;
                window.close();
            }

        }catch (e) { 
        } 
    } 
    
    function btn_OpinionOK_onclick() {
        window.location.reload();
    }
</script> 
</body> 
</html>