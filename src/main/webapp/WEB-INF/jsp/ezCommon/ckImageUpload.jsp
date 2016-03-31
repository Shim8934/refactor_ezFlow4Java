<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t4002'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="<spring:message code='main.e15'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		    window.onload = function () {
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("imgwidth"));
		                KeEventControl(document.getElementById("imgheight"));
		            }
		        }
		        catch (e)
		        { }
		    };
		    function filesearch() {
		        document.getElementById("file1").click();
		    }
		    function btn_AttachAdd_onclick() {
		        var extension = document.getElementById("file1").value.split('.');
		        var check = false;
		        check = compareExtension(check, extension[extension.length - 1]);
		
		        if (!check) {
		            alert("<spring:message code='main.t4000'/>");
		            document.getElementById("file1").value = "";
		            return;
		        }
		    }
		    function btn_AttachAddText_onclick() {
		        document.getElementById("filapathtext").value = document.getElementById("file1").value;
		    }
		    function compareExtension(check, extension) {
		        var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp");
		        for (var i = 0; i < filterExtension.length; i++) {
		            if (extension.toLowerCase() == filterExtension[i]) {
		                check = true;
		                break;
		            }
		        }
		        return check;
		    }
		    var isuload = false;
		    function fileupload() {
		        if (isuload || document.form.file1.value == "")
		            return;
		        var frm = document.getElementById('form');
		        frm.action = "/ezCommon/ckUpload.do";
		        frm.submit();
		        isuload = true;
		        document.form.file1.value = "";
		    }
		
		    var fileinfo = "";
		    function UploadComplete(filepath) {
		        document.getElementById("previewtext").style.display = "none";
		        document.getElementById("previewimg").style.display = "";
		        fileinfo = filepath.split("|!|");
		        document.getElementById("previewimg").src = fileinfo[0];
		        document.getElementById("previewimg").outerHTML = document.getElementById("previewimg").outerHTML;
		        document.getElementById("imgwidth").value = fileinfo[1];
		        document.getElementById("imgheight").value = fileinfo[2];
		        isuload = false;
		    }
		    function btnSave_click() {
		        if (fileinfo == "")
		            return;
		        if (document.getElementById("imgwidth").value == 0 || isNaN(document.getElementById("imgwidth").value)) {
		            alert("<spring:message code='main.t4001'/>");
		            return;
		        }
		        if (document.getElementById("imgheight").value == 0 || isNaN(document.getElementById("imgheight").value)) {
		            alert("<spring:message code='main.t4001'/>");
		            return
		        }
		        fileinfo[1] = document.getElementById("imgwidth").value;
		        fileinfo[2] = document.getElementById("imgheight").value;
		        if (parent.message != null) {
		            if (parent.message.Insert_ImageCmd_Complete != undefined)
		                parent.message.Insert_ImageCmd_Complete(fileinfo);
		            else if (parent.message2 != null && parent.message2.Insert_ImageCmd_Complete != undefined)
		                parent.message2.Insert_ImageCmd_Complete(fileinfo);
		            else
		                parent.message.iframe_content.Insert_ImageCmd_Complete(fileinfo);
		        }
		        else if (parent.tbContentElement != null)
		            parent.tbContentElement.Insert_ImageCmd_Complete(fileinfo);
		
		        parent.DivPopUpHidden();
		        window.returnValue = fileinfo;
		        window.close();
		    }
		    function window_close() {
		        parent.DivPopUpHidden();
		        window.close();
		    }
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0)
		        {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
	    <h1><spring:message code='main.t4002'/></h1>
	    <table id="toggle_tbl1" class="content" style="width:450px;height:300px">
			<tr>
	            <td style="text-align:center;height:295px">
	                <span id="previewtext" style="width:100%;height:100%"><spring:message code='main.t4009'/></span>
	                <img id="previewimg" style="display:none;width:100%;height:100%" />
	            </td>
	            <td style="vertical-align:top">
	                <table style="vertical-align:top;width:230px" class="content">
	                    <tr>
	                        <th>
	                            <spring:message code='main.t4003'/>
	                        </th>
	                        <td colspan="3" style="border:1px solid rgb(182, 182, 182);">
	                            <input id="filapathtext" type="text" style="width:98%"/>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td colspan="4" style="border:1px solid rgb(182, 182, 182);">
	                            <div class="btnposition" style="padding-top:0px">
	                                <a href="#" class="imgbtn" onclick ="filesearch()"><span><spring:message code='main.t4004'/></span></a>
	                                <a href="#" class="imgbtn"><span onclick="fileupload()"><spring:message code='main.t4005'/></span></a>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th>
	                            <spring:message code='main.t4006'/>
	                        </th>
	                        <td style="width:50%">
	                            <input id="imgwidth" type="text" style="width:30px" />px
	                        </td>
	                        <th>
	                            <spring:message code='main.t4007'/>
	                        </th>
	                        <td>
	                            <input id="imgheight" type="text" style="width:30px" />px
	                        </td>
	                    </tr>
	                </table>
	            </td>
			</tr>
		</table>
	    <div class="btnposition">
	        <a href="#" class="imgbtn"><span onclick="btnSave_click();"><spring:message code='main.t4008'/></span></a>
	        <a href="#" class="imgbtn"><span onclick="return window_close();"><spring:message code='main.t135'/></span></a>
	    </div>
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	     <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezCommon/ckUpload.do" target="ifrm" style="width:1px;height:1px">
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAddText_onclick()" style="width: 1px; height: 1px;" />
	    </form>
	</body>
</html>