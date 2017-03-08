<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <link href="/css/previewmail.css" rel="stylesheet" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        var MozNowZoom = 1;
	        var MozMaxZoom = 2;
	        var MozMinZoom = 0.8;
	
	        var strLang1 = "<spring:message code='ezBoard.t10025'/>";
	        var strLang2 = "<spring:message code='ezBoard.t10023'/>";
	        var strLang3 = "<spring:message code='ezBoard.t10024'/>";
	        window.onload = function () {
	            document.getElementById("txtContent").style.textAlign = "center";
	            window.parent.previewItemSet();
	        };
	
	        function Bigger() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom < MozMaxZoom) {
	                    MozNowZoom += 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("divContent").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom < maxZoom) {
	                    nowZoom += 10;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.zoom = nowZoom + "%";
	            }
	        }
	
	        function Smaller() {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (MozNowZoom > MozMinZoom) {
	                    MozNowZoom -= 0.1;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.MozTransform = "scale(" + MozNowZoom + ")";
	                document.getElementById("divContent").style.MozTransformOrigin = "0 0";
	            }
	            else {
	                if (nowZoom > minZoom) {
	                    nowZoom -= 10;
	                } else {
	                    return;
	                }
	                document.getElementById("divContent").style.zoom = nowZoom + "%";
	            }
	        }
	
	        function makeWriteContent(responseText, AttachText) {
	            try {
	                nowZoom = 100;
	                maxZoom = 200;
	                minZoom = 80;
	                MozNowZoom = 1;
	                MozMaxZoom = 2;
	                MozMinZoom = 0.8;
	
	                document.getElementById("txtContent").style.textAlign = "";
	                document.getElementById("txtContent").innerHTML = "";
	                var _img1;
	                var _img2;
	
	                _img1 = document.createElement("IMG");
	                _img1.id = "smallImg";
	                //_img1.setAttribute("onclick", "Smaller()");
	                _img1.onclick = function () { Smaller(); };
	
	                _img1.style.cursor = "pointer";
	                _img1.style.margin = "5px";
	                _img1.src = "/images/minus.png";
	
	                _img2 = document.createElement("IMG");
	                _img2.id = "biglImg";
	                //_img2.setAttribute("onclick", "Bigger()");
	                _img2.onclick = function () { Bigger(); };
	                
	                
	                _img2.style.cursor = "pointer";
	                _img2.style.margin = "5px";
	                _img2.style.marginLeft = "-4px";
	                _img2.src = "/images/plus.png";
	
	                document.getElementById("txtContent").appendChild(_img1);
	                document.getElementById("txtContent").appendChild(_img2);
	
	                var xmldom = loadXMLString(AttachText);
	                var _attchDIV;
	                if (SelectNodes(xmldom, "NODES/NODE").length > 0) {
	                    var AttchHTML = SetAttachmentInfo(xmldom);
	                    _attchDIV = document.createElement("DIV");
	                    _attchDIV.id = "attchdivContent";
	                    _attchDIV.innerHTML = AttchHTML;
	                    document.getElementById("txtContent").appendChild(_attchDIV);
	                }
	
	                var _div = document.createElement("DIV");
	                _div.id = "divContent";
	                _div.innerHTML = responseText;
	                document.getElementById("txtContent").appendChild(_div);
	                
	            } catch (e) {}
	        }
	
	        function SetAttachmentInfo(responseText) {
	            var xmldom = responseText;
	            var i = 0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";
	            var strAttach = "";
	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	            var regData = GetbrowserLanguage();
	
	            strAttach += "<div class='previewmail_addfile' id='ifrmPreViewRayer' style='margin-bottom:10px;'>";
	
	            var totalSize = 0;
	            for (var j = 0; j < xmldomNodes.length; j++) {
	                totalSize += parseInt(getNodeText(SelectSingleNode(xmldomNodes[j], "FileSize2")));
	            }
	
	            var strSize = "";
	            strAttach += "<p class='title'>" + strLang1+" - " + "<span><b>" + xmldomNodes.length + strLang2 + "(" + File_Size(totalSize) + ")</b></span><span class='icon_grayup' id='BtnAttachDetail' onclick='AttachDetail_view(this);'></span>";
	            strAttach += "<span class='title_btn' onmouseover=this.style.color='#164aad' onmouseout=this.style.color='#666' style='cursor:pointer' onclick='AttachAllDownload();'>" + strLang3 + "</span></p>";
	            strAttach += "<ul class='list' id='PreviewAttachList'>";
	
	
	            for (i = 0; i < xmldomNodes.length; i++) {
	            	filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	            	filename = filepath.substr(120, filepath.length - 119);
// 	                filename = filepath.substr(filepath.indexOf("}_") + 2);
// 	                filename = ReplaceText(filename, "%2b", "+");
// 	                filename = ReplaceText(filename, "%3b", ";");
// 	                filename = ReplaceText(filename, "%7e", "~");
// 	                filename = ReplaceText(filename, "%3d", "=");
	                filepath = "/upload_board/" + filepath;
	                filesize = parseInt(getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize2")));
	
	                var strTarget = "target=''";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
	                    strTarget = "target=''";
	                }
	                
	                strAttach += "<li>";
	                strAttach += "<span id='MailAttachDownloadItems' name='MailAttachDownloadItems' onclick=\"DownloadFile('/ezBoard/getBoardAttachInfo.do?type=BOARD&itemID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "ItemID")) + "&attID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "GUID")) + "')\"><img style='cursor:pointer' src='/images/icon_adddownload.gif' width='16' height='16' /></span>";
	                strAttach += "&nbsp;";
	                strAttach += "<span onmouseover=\"this.style.color='#164aad'\" onmouseout=\"this.style.color='#666'\" style='cursor: pointer; color: rgb(102, 102, 102);'>";
	                strAttach += "<a name='filename' href='/ezBoard/getBoardAttachInfo.do?type=BOARD&itemID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "ItemID")) + "&attID=" + getNodeText(SelectSingleNode(xmldomNodes[i], "GUID")) + "'>" + filename + " (" + File_Size(filesize) + ")</a>";
	                strAttach += "</span>";
	                strAttach += "</li>";
	            }
	            strAttach += "</ul></div>";
	            return strAttach;
	        }
	
	        function File_Size(totalSize) {
	            var strSize = "";
	            if (totalSize > 1024 * 1024) {
	                totalSize = parseInt(totalSize / 1024 / 1024);
	                strSize = totalSize + "MB";
	            }
	            else if (totalSize > 1024) {
	                totalSize = parseInt(totalSize / 1024);
	                strSize = totalSize + "KB";
	            }
	            else
	                strSize = parseInt(totalSize) + "B";
	
	            return strSize;
	        }
	
	        function DownloadFile(href)
	        {
	            location.href = href;
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function AttachDetail_view(obj) {
	            if (obj.className == "icon_graydown") {
	                obj.className = "icon_grayup";
	                document.getElementById("PreviewAttachList").style.display = "";
	            }
	            else {
	                obj.className = "icon_graydown";
	                document.getElementById("PreviewAttachList").style.display = "none";
	            }
	        }
	
	        function AttachAllDownload(attachObj) {
	            var allobj = document.getElementsByName("filename");
	            downloadAll(allobj);
	        }
	
	        var suffix = 0;
	        function downloadAll(allobj) {
	            if (allobj[suffix]) {
	                location.href = GetAttribute(allobj[suffix], "href");
	                suffix++;
	                setTimeout(function () { downloadAll(allobj) }, 1000);
	            }
	            else
	                suffix = 0;
	        }
	    </script>
	</head>
	<body>
		<div id="txtContent" name="txtContent" style="height:100%;margin-left:5px;margin-right:5px;">
			<span style="margin-top:50px;height:10px;display:inline-block;"></span>    
		</div>
	</body>
</html>