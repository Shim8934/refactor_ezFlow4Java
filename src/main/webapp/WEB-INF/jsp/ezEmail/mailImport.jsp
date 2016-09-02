<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <title><spring:message code='ezEmail.t400' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
	    <script type="text/javascript" src="/js/ezEmail/js/kaoni_ActiveX.js"></script>
	    <script>
	        var totalCount = 0;
	        var Count = 0;
	        var folderpath = "";
	        var test = "";        
	        var attachxml = "";
	        var pNonActivX = "${pNonActivX}";
	        var ReturnFunction;
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        window.onload = function () {
	            if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
	                document.getElementById("file1").multiple = false;
	            }
	            try {
	                foldername.value = opener.mail_import_cross_dialogArguments[0]["foldername"];
	                folderpath = opener.mail_import_cross_dialogArguments[0]["href"];
	                document.getElementById("folderid").value = folderpath;
	                ReturnFunction = opener.mail_import_cross_dialogArguments[1];
	            } catch (e) {
	            }            
	        }
	        window.onunload = function () {
	            if (CrossYN() || pNonActivX == "YES")
	                ReturnFunction();
	        }
	        function selectMail() {
	            document.getElementById("filepath").innerHTML = "";
	            document.getElementById("form").value = "";
	            document.getElementById("cnt").value = "";
	            document.form.file1.click();
	        }
	        var mail_selectfolder_cross_dialogArguments = new Array();
	        function selectFolder() {
	            mail_selectfolder_cross_dialogArguments[1] = selectFolder_Complete;
	            mail_selectfolder_cross_dialogArguments[2] = DivPopUpHidden;
	            DivPopUpShow(400, 355, "/ezEmail/mailSelectFolder.do");
	        }
	        function selectFolder_Complete(mailBoxInfo) {
	            DivPopUpHidden();
	            if (typeof (mailBoxInfo) == "undefined")
	                return;
	
	            foldername.value = mailBoxInfo["name"];
	            folderpath = mailBoxInfo["url"];
	            document.getElementById("folderid").value = mailBoxInfo["url"];
	        }
	        function mailIn() {
	            if (foldername.value == "") {
	                alert("<spring:message code='ezEmail.t158' />");
	                return;
	            }
	            if (filepath.innerHTML == "") {
	                alert("<spring:message code='ezEmail.t401' />");
	                return;
	            }
	            upload_mail();
	        }
	        function window_Close() {
	            window.close();
	        }
	        function upload_mail() {
	            try {
	                var frm = document.getElementById('form');
	                frm.submit();
	            }
	            catch (e) {
	                alert("<spring:message code='ezEmail.t404' />" + e.description);
	                return;
	            }
	        }
	        function btn_AttachAdd_onclick() {
	            var cnt = document.getElementById("form").file1.files.length;
	            for (var i = 0; i < cnt; i++) {
	                var tempname = document.getElementById("form").file1.files[i].name;
	                var last = tempname.split(".").length;
	                var extension = tempname.split(".")[last - 1];
	
	                if (extension.toUpperCase() != "EML") {
	                    alert("<spring:message code='ezEmail.t401' />");
	                    return;
	                }
	                var _Span = document.createElement("SPAN");
	                _Span.style.width = "310px";
	                _Span.style.textOverflow = "epllipsis";
	                _Span.style.whiteSpace = "nowrap";
	                _Span.style.display = "inline-block";
	                _Span.innerHTML = document.getElementById("form").file1.files[i].name;
	                document.getElementById("filepath").innerHTML += _Span.outerHTML;
	            }
	            document.getElementById("cnt").value = cnt
	        }
	        function returnvalue(resultxml) {
	            if (resultxml == "OK") {
	                alert("<spring:message code='ezEmail.t403' />");
	                window_Close();
	            }
	            else {
	            	if (resultxml.indexOf("NO APPEND failed.") > -1) {
		        		alert(strLang241);
	            	}
	            	else {
	                	alert("<spring:message code='ezEmail.t404' />" + resultxml);
	            	}
	            }
	        }
	    </script>
	</head>
	<body class="popup" style="overflow: hidden">
	    <h1><spring:message code='ezEmail.t400' /></h1>
	    <table class="popuplist">
	        <tr>
	            <th><spring:message code='ezEmail.t148' /></th>
	            <td>
	                <input id="foldername" type="text" name="textfield" style="width: 98%" disabled></td>
	            <td><a class="imgbtn"><span onclick="selectFolder()" id="folderfindbutton"><spring:message code='ezEmail.t99000078' /></span></a></td>
	        </tr>
	        <tr style="height: 40px">
	            <th><spring:message code='ezEmail.t405' /></th>
	            <td>
	                <div id="filepath" style="overflow: auto; width: 310px; height: 260px; border: 1px solid #b6b6b6;"></div>
	            </td>
	            <td><a class="imgbtn"><span onclick="selectMail()" id="filefindbutton"><spring:message code='ezEmail.t99000079' /></span></a></td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn" id="mailInBtn" onclick="mailIn()"><span><spring:message code='ezEmail.t407' /></span></a>
	        <a class="imgbtn" id="cancelBtn" onclick="window_Close()"><span><spring:message code='ezEmail.t39' /></span></a>
	    </div>
	
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezEmail/mailImportUpload.do" target="ifrm">
	        <input type="file" name="file1" id="file1" accept="message/rfc822" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="true" />
	        <input type="hidden" name="folderid" id="folderid" />
	        <input type="hidden" name="cnt" id="cnt" />
	    </form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>



