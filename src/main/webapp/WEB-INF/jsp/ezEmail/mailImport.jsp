<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t400' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<c:if test="${isCrossBrowser != true}">
	    <script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	    </c:if>
	    <script>
	        var g_fileList;
	        var folderpath = "";
	        var test = "";        
	        var attachxml = "";
	        var isCrossBrowser = "${isCrossBrowser}";
	        var ReturnFunction;
	        var maxAllowMailMsg = "<spring:message code='ezEmail.jje04'/>";
	        var CurrentWidth = "";
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        window.onload = function () {
	        	
	        	CurrentWidth = window.innerWidth;
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
	                ReturnFunction();
	        }
	        function selectMail() {
	            document.getElementById("filepath").innerHTML = "";
	            document.getElementById("mailCount").innerHTML = "";
	            
	            if (CrossYN()) {
	            	document.getElementById("form").value = "";
		            document.getElementById("cnt").value = "";
	            	document.form.file1.click();
	            } else {
	            	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	        		ezUtil.UseUTF8 = true;
	        		var file = ezUtil.OpenLoadDlgMultiNew("Outlook Express Mail Message\0*.eml\0\0", "")
	        		
	        		if (!file) {
	        			return;
	        		}
	        		
	        		g_fileList = file.split("|");
		            for (var i = 0; i < g_fileList.length - 1; i++) {
		            	var last = g_fileList[i].split("\\").length;
		                var tempname = g_fileList[i].split("\\")[last - 1];
		                last = tempname.split(".").length;
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
		                _Span.innerHTML = tempname;
		                document.getElementById("filepath").innerHTML += _Span.outerHTML;
		            }
	        		
	            }
	        }
	        var mail_selectfolder_cross_dialogArguments = new Array();
	        function selectFolder() {
	            mail_selectfolder_cross_dialogArguments[1] = selectFolder_Complete;
	            DivPopUpShow(400, 355, "/ezEmail/mailSelectFolder.do");
	        }
	        function selectFolder_Complete(mailBoxInfo) {
	            DivPopUpHidden();
	            
	            if (typeof (mailBoxInfo) == "undefined") {
	                return;
	            }
	            
	            if (typeof (mailBoxInfo["name"]) != "undefined") {
	            	foldername.value = mailBoxInfo["name"];
	            }
	            
	            if (typeof (mailBoxInfo["url"]) != "undefined") {
	            	folderpath = mailBoxInfo["url"];
		            document.getElementById("folderid").value = folderpath;
	            }
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
	        	if (CrossYN()) {
	        		try {
		                var frm = document.getElementById('form');
		                try {
		                	frm.submit();
		                } catch (e) {
		                		setTimeout(function () { 
		                			try {
		                				frm.submit();
		                			} catch (e) {
		                				setTimeout(function () { frm.submit(); }, 50);
		                			}
		                		}, 50);
		                }
		            }
		            catch (e) {
		                alert("<spring:message code='ezEmail.t404' />" + e.description);
		                return;
		            }
	        	} else {
	        		try {
	                    mailInBtn.disabled = true;
	                    
	                    EzHTTPTrans.AddUploadFile("", "");
	                    
	                    var totalCount = g_fileList.length - 1;
						for (var i = 0; i < totalCount; i++) {
	                    	EzHTTPTrans.AddUploadFile(g_fileList[i], "N");
						}

	                    var RemotePath = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezEmail/mailImportUploadX.do";
	                    var nCount = EzHTTPTrans.StartUpload(RemotePath, encodeURIComponent(folderpath), "DocManagement", "", "");

	                    if (nCount == 0) {
	                    	alert("<spring:message code='ezEmail.t404' />");
	                        return false;
	                    }
						
	                    for (var i = 0; i < nCount; i++) {
	                    	var fileinfo = EzHTTPTrans.GetReturn(i);
		                    var infos = fileinfo.split('/');
		                    var Result = infos[1];
		                    
		                    if (Result.length > 1000) {
		                        alert(g_fileList[i] + " <spring:message code='ezEmail.t112' />");
		                        return;
		                    }
		                    else if (Result != "OK") {
		                        if (Result == "FULL") {
		                            alert(strLang241);
		                        }
		                        else {
		                            alert(g_fileList[i] + " <spring:message code='ezEmail.t402' />" + Result);
		                        }
		                        return;
		                    }
	                    }
	                    
	                    alert("<spring:message code='ezEmail.t403' />");
	                    window.close();
	                    
	                }
	                catch (e) {
	                    alert("<spring:message code='ezEmail.t404' />" + e.description);
	                    return;
	                }
	        	}
	        }
	        function btn_AttachAdd_onclick() {
        		var cnt = document.getElementById("form").file1.files.length;
        		
        		if (cnt == 0) {
        			document.getElementById("mailCount").innerText = "";
        			return;
        		}
        		
        		if (cnt > 100) {
        			alert(maxAllowMailMsg);
        			document.getElementById("mailCount").innerText = "";
        			return;
        		}
        		
        		ShowMailProgress();
        		for (var i = 0; i < cnt; i++) {
	                var tempname = document.getElementById("form").file1.files[i].name;
	                var last = tempname.split(".").length;
	                var extension = tempname.split(".")[last - 1];
	
	                if (extension.toUpperCase() != "EML") {
	                	HiddenMailProgress();
	                    alert("<spring:message code='ezEmail.lsd05' />");
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
        		document.getElementById("mailCount").innerText = "[" + cnt + "] <spring:message code='ezBoard.t339'/>";
        		HiddenMailProgress(); 
	            document.getElementById("cnt").value = cnt;
	        }
	        
	        function ShowMailProgress() {
	            document.getElementById("mailPanel").style.display = "";
	            document.getElementById("MailProgress").style.top = "190px";
	            document.getElementById("MailProgress").style.left = (CurrentWidth / 2) - 80 + "px";
	            document.getElementById("MailProgress").style.display = "";
	        }
	        
	        function HiddenMailProgress() {
	            document.getElementById("mailPanel").style.display = "none";
	            document.getElementById("MailProgress").style.display = "none";
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
	    <h1><spring:message code='ezEmail.t400' />&nbsp;&nbsp;<span id="mailCount"></span></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window_Close()"></span></li>
            </ul>
        </div>
	    <table class="popuplist" style="width:100%">
	        <tr>
	            <th><spring:message code='ezEmail.t148' /></th>
	            <td>
	                <input id="foldername" type="text" name="textfield" style="width: 100%" disabled></td>
	            <td style="text-align:center;"><a class="imgbtn imgbck" style="margin-top:2px"><span onclick="selectFolder()" id="folderfindbutton"><spring:message code='ezEmail.t99000078' /></span></a></td>
	        </tr>
	        <tr>
	        	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		            <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
		            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
		        </div>
		    </tr>
	        <tr style="height: 40px">
	            <th><spring:message code='ezEmail.t405' /></th>
	            <td>
	                <div id="filepath" style="overflow: auto; width: 310px; height: 260px; padding-top:5px">
	                </div>
	            </td>
	            <td style="text-align:center;"><a class="imgbtn imgbck"><span onclick="selectMail()" id="filefindbutton"><spring:message code='ezEmail.t99000079' /></span></a></td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn" id="mailInBtn" onclick="mailIn()"><span><spring:message code='ezEmail.t407' /></span></a>
	    </div>
	
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezEmail/mailImportUpload.do" target="ifrm">
	        <input type="file" name="file1" id="file1" accept="message/rfc822" onchange="btn_AttachAdd_onclick();" style="width: 1px; height: 1px; display:none;" multiple="true" />
	        
	        <input type="hidden" name="folderid" id="folderid" />
	        <input type="hidden" name="cnt" id="cnt" />
	    </form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<c:if test="${isCrossBrowser != true}">
		<script type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</script>
		</c:if>
		
	</body>
</html>



