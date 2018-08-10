<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
        <link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/${e1}"></script>
        <script language="JavaScript" src="<%=CommonUtil.addVer(application, "/js/ezEmail/js_cross/reademail.js")%>"></script>
    	<script language="javascript" type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
    	<script language="javascript" type="text/javascript">
		    var objLink = document.all("BigSizeFileLink");
		    
			if (objLink != null) {
				if (typeof(objLink.length) == "undefined" ) {
					objLink.target = "";
				} else {
					for( var n = 0 ; n < objLink.length ; n++ ) {
						objLink(n).target = "";
					}
				}
			}
			
			function window_onload() {
			}
			
		    function AttachDetail_view(obj) {
		        if (obj.className == "icon_graydown") {
		            obj.className = "icon_grayup"
		            document.getElementById("PreviewAttachList").style.display = "";
		        }
		        else {
		            obj.className = "icon_graydown"
		            document.getElementById("PreviewAttachList").style.display = "none";
		        }
		    }
		    
		    function DownloadAttach(DownloadUrl) {
		        AttachDownFrame.location.href = DownloadUrl;
		    }
		    
		    var suffix = 0;
		    function AttachAllDownload() {
		        if (suffix < document.getElementsByName("MailAttachDownloadItems").length)
		            setTimeout(function () { FileDownload(document.getElementsByName("MailAttachDownloadItems").item(suffix++).getAttribute("_filehref")) }, 2000);
		        else {
		            suffix = 0;
		            return;
		        }
		    }
		    
		    function FileDownload(pFileUrl) {
		        if (pFileUrl != null) {
		            location.href = pFileUrl;
		            AttachAllDownload();
		        }
		        else {
		            suffix = 0;
		            return;
		        }
		    }
		    
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	
	        var MozNowZoom = 1;
	        var MozMaxZoom = 2;
	        var MozMinZoom = 0.8;
	        function Bigger() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom < MozMaxZoom) {
	                    MozNowZoom += 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("normalScreen").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("normalScreen").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom < maxZoom) {
	                    nowZoom += 10;
	                } else {
	                    return;
	                }
	                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
	            }
	        }
	        function Smaller() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom > MozMinZoom) {
	                    MozNowZoom -= 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("normalScreen").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("normalScreen").style.MozTransformOrigin = "0 0";
	
	            }
	            else {
	                if (nowZoom > minZoom) {
	                    nowZoom -= 10;
	                } else {
	                    return;
	                }
	                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
	            }
	        }
		</script>
	</head>
	<body style="margin-left:10px;margin-top:10px" onload="javascript:window_onload()">
		<img src='/images/minus.png' title="${t99000065}" onclick='Smaller()' style='cursor: pointer;' />
		<img src='/images/plus.png' title="${t99000064}" onclick='Bigger()' style='cursor: pointer; margin-left: -4px;' />
		<span id="ContentClassbtn" style="float:right;display:none;" >
			<img src='/images/mtgrsp-accept.gif' width="20" height="20" title="${t901}" onclick="Schedule_btn('ACCEPT');" style='cursor:pointer;' />
			<img src='/images/mtgrsp-tent.gif' width="20" height="20" title="${t903}" onclick="Schedule_btn('TENT');" style='cursor:pointer;' />
			<img src='/images/mtgrsp-decline.gif' width="20" height="20" title="${t902}" onclick="Schedule_btn('DECLINE');" style='cursor:pointer;' />
		</span>
		<div class="previewmail_addfile" id="ifrmPreViewRayer" style="<c:if test="${isAttach != 'OK'}">display:none;</c:if>margin-bottom:10px;font-family:${t246}">
			<p class="title">${t99000003}
				<span>${pAttachListHtmlSub}</span>
				<span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);"></span>
				<span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload();">${t99000004}</span>
			</p>
			<ul class="list" id="PreviewAttachList">${pAttachListHtml}</ul>
		</div>
		<div id="MailBigAttachRayer" class="previewmail_addfile">
		</div>
		<div class='margin' id="normalScreen" style="margin-top:5px; word-wrap:break-word;">${htmlBody}<!--  --></div>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>  
	</body>
</html>