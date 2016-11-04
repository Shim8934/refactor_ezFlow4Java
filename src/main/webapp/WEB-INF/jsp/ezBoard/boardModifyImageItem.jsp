<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <style type="text/css">
	         .preView { width: 150px; height: 150px; text-align: center; border:1px solid silver; }
	    </style>
        <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
   	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="/js/ezBoard/AttachMain.js"></script>
		    <script type="text/javascript" src="/js/ezBoard/AttachItem.js"></script>
		    <script type="text/javascript" src="/js/ezBoard/kaoni_ActiveX.js"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="/js/ezBoard/AttachMain_CK.js"></script>
		    <script type="text/javascript" src="/js/ezBoard/AttachItem_CK.js"></script>
	    </c:if>
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script> 
        <script type="text/javascript">
	        var pListImagePath = "";
	        var pListCount = "${listCount}";
	        var pListImage = "${listImage}";
	        var pBoardID = "${boardID}";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var ImageID = "";
	        var DelCount = 0;
	        var pMod = "Mod";
	        var pUrl = "";
	        var PhotoBoard = "N";
	        var pMode = "";
	        var pAttachListXml = "";
	        var ListImages = "${listImages}";
	        var ImgaeReturnXml = "";
	        var pMainFg = "${mainFg}";
	        var pItemID = "${itemID}";
	        var pGubun = "${guBun}";
	        var orgImagePath = "${orgImagePath}";
	        var pNoneActiveX = "YES";
	        function window_onload() {
	            if (pGubun != "3")
	            {
	                document.getElementById("mainimage").style.display = "";
	            }
	
	            if (pMainFg == "Y") {
	                document.getElementById("mainFG").checked = true;
	                document.getElementById("mainFG").disabled = true;
	            }
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                document.getElementById("file1").multiple = false;
	            }
	        }
	        
	        function uploadComplete() {
	            if (CrossYN()) {
	                document.getElementById("file1").value = "";
	                returnvalue(xhr.responseText);
	            }
	            else {
	                document.getElementById("file1").type = "text";
	                document.getElementById("file1").type = "file";
	                returnvalue(xhr.responseText);
	            }
		    }
	
	        function imagecheckAll(checked) {
	            for (var i = 0; i < pListCount; i++) {
	
	                if (checked)
	                    document.getElementById("imagecheck" + i).checked = true;
	                else
	                    document.getElementById("imagecheck" + i).checked = false;
	            }
	        }
	
	        function imgtemp_onclick() {
	        	if (document.form.file1.value != "") {            
		            var fd = new FormData();
		            for (var i = 0; i < document.getElementById("form").file1.files.length; i++) {
		                fd.append("file1", document.getElementById("form").file1.files[i]);
		            }
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=PICTURE&boardID=" + pBoardID + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		        }
	        }
	        
	        function btn_ImgOnclick() {
	            var pFlag = "N";
	            if (document.getElementById("mainFG").checked)
	                pFlag = "Y";
	
	            if (CrossYN()) {
	                var nodes;
	                var rtnMode;
	                var imgFileName;
	                var ImagePath;
	                var orgFileName = "";
	                
	                if (ImgaeReturnXml != "") {
	                    nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
	
	                    rtnMode = getNodeText(GetChildNodes(nodes[0])[5]);
	                    imgFileName = getNodeText(GetChildNodes(nodes[0])[0]);
	                    orgFileName = getNodeText(GetChildNodes(nodes[0])[7]);
	                    ImagePath = "tempUploadFile/" + imgFileName;
	
	                } else {
	                    if (pFlag == "Y" && !document.getElementById("mainFG").disabled) pMod = "FLAG";
	                }
	                content = document.getElementById("getcontent").value;
	
	                var strXML = "";
	                strXML = "<DATA>";
	                strXML += "<NODE>";
	                strXML += "<IMAGEID>" + pListImage + "</IMAGEID>";
	                strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	                if (ImagePath == undefined) {
	                    strXML += "<FILEPATH></FILEPATH>";
	                }
	                else
	                    strXML += "<FILEPATH><![CDATA[" + ImagePath + "]]></FILEPATH>";
	                
	                strXML += "<CONTENT><![CDATA[" + content + "]]></CONTENT>";
	                strXML += "<MAINFG>" + pFlag + "</MAINFG>";
	                strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	                strXML += "<OFILENAME>" + orgFileName + "</OFILENAME>";
	                strXML += "</NODE>";
	                strXML += "</DATA>";
	
	                var xmlhttp = createXMLHttpRequest();
	                var xmldom = createXmlDom();
	
	                xmldom.async = false;
	                xmldom.preserveWhiteSpace = true;
	                xmldom = loadXMLString(strXML);
	
	                xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=" + pMod, false);
	                xmlhttp.send(xmldom);
	
	                if (xmlhttp.responseText == "OK") {
	                    alert(strLang50);
	                    window.opener.page_reload();
	                    window.close();
	                }
	                else {
	                    alert(strLang51);
	                }
	            } else {
	                var file = "";
	                var content = "";
	                var filepath = "";

	                if (pMod == "Mod") {
	                    content = document.getElementById("getcontent").value;

	                    var ImagePath = "";

	                    if (document.getElementById("imagechange1").value != null && document.getElementById("imagechange1").value != "") {
	                        file = document.getElementById("imagechange1").value + "|";                        
	                        filepath = MakeXMLString(GetSmallUrl());
	                        ImagePath = filepath.split(";")[0];
	                    }
	                    else
	                        ImagePath = ListImages.substring(17, ListImages.length).split(";")[0].replace("/uploadFile/", "/tempUploadFile/s_");

	                    var strXML = "";
	                    strXML = "<DATA>";
	                    strXML += "<NODE>";
	                    strXML += "<IMAGEID>" + pListImage + "</IMAGEID>";
	                    strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	                    strXML += "<FILEPATH><![CDATA[" + imagefilepath + "]]></FILEPATH>";
	                    strXML += "<CONTENT>" + content + "</CONTENT>";
	                    strXML += "<MAINFG>" + pFlag + "</MAINFG>";
	                    strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	                    strXML += "<OFILENAME>" + imagefilepath.substring(imagefilepath.indexOf("_") + 1, imagefilepath.indexOf(".")) + "</OFILENAME>";
	                    strXML += "</NODE>";
	                    strXML += "</DATA>";

	                    var xmldom = createXmlDom();
	                    xmldom = loadXMLString(strXML);

	                    var xmlhttp = createXMLHttpRequest();
	                    xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=" + pMod, false)
	                    xmlhttp.send(xmldom);

	                    if (xmlhttp.responseText == "OK") {
	                        alert(strLang50);
	                        window.opener.page_reload();
	                        window.close();
	                    }
	                    else {
	                        alert(strLang51);
	                    }
	                }
	            }
	        }
	
	        function returnvalue(strXML) {
	            ImgaeReturnXml = loadXMLString(strXML);
	            var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
	            var rtnMode = getNodeText(GetChildNodes(nodes[0])[5]);
	
	            var imgFileName = getNodeText(GetChildNodes(nodes[0])[0]);

	            document.getElementsByTagName("IMG")[0].src = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(imgFileName);
	        }
	
	        function S4() {
	            return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
	        }
	
	        function GetGUID() {
	            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
	        }
	
	        function CustomRandom() {
	            var now = new Date();
	            var seed = now.getMilliseconds();
	            return Math.random(seed) + 1;
	        }
	
	        function MakeXMLString(str)
		    {
			    str = ReplaceText(str, "&", "&amp;");
			    str = ReplaceText(str, "<", "&lt;");
			    str = ReplaceText(str, ">", "&gt;");
			    return str;
		    }
		    
	        function ReplaceText( orgStr, findStr, replaceStr )
		    {
			    var re = new RegExp( findStr, "gi" );
			    return ( orgStr.replace( re, replaceStr ) );
		    }
	
	        var g_fileList;
	        var imagefilepath = "";
	        function btn_PhotoChange() {
	        	if (CrossYN()) {
	                document.getElementById('mode').value = "PHOTO";
	                document.form.file1.click();

	            } else {
	                var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	                ezUtil.UseUTF8 = true;
	                var file = "";

	                file = ezUtil.OpenLoadDlgMultiNew("" + strLang22 + "", "");

	                if (!file)
	                    return;

	                pAttachListXml = "";

	                g_fileList = file.split("|");

	                var fileSize = 0;

	                if (g_fileList.length > 20) {
	                    alert("" + strLang23 + "")
	                    return;
	                }

	                if (g_fileList.length > 2) {
	                    alert(strLang49);
	                    return;
	                }

	                for (var i = 0; i < g_fileList.length - 1; i++) {
	                    if (ezUtil.GetFileSize(g_fileList[i]) == 0) {
	                        alert("" + strLang6 + "");
	                        return;
	                    }
	                    
	                    var temp = ezUtil.ExtractFileName(g_fileList[i]);

	                    if (temp.length > 111) {
	                        alert("" + strLang7 + "");
	                        return;
	                    }
	                    
	                    fileSize = ezUtil.GetFileSize(g_fileList[i]);

	                    
	                    if (fileSize > parseInt(AttachLimit) * 1024 * 1024) {
	                        alert("" + strLang8 + "" + AttachLimit + "MB" + strLang9 + "");
	                        return;
	                    }
	                }

	                ezUtil = null;
	                var fileNamelist = "";
	                var fileName = "";
	        
	                document.all.EzHTTPTrans.AddUploadFile("", "");
	                for (var i = 0; i < g_fileList.length - 1; i++) {
	                    try {
	                        document.all.EzHTTPTrans.AddFilename(encodeURIComponent(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1)));
	                        document.all.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");
	                    }
	                    catch (e) {
	                        if (e.number == -2147352567)
	                            alert("" + strLang12 + "");
	                        else
	                            alert(g_fileList[i] + " " + strLang13 + "" + "\n\n" + e.number + " - " + e.description);
	                        return;
	                    }
	                }

	                var RemotePath = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezBoard/itemAttachFile.do";
	                var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath, "/upload_board", pBoardID, "", "");

	                for (var i = 0; i < nCount; i++) {
	                    var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
	                    
	                    var attachFilePath = attachFileResult.substr(0, attachFileResult.indexOf("/"));
	                    var attachFilename = attachFileResult.substr(attachFileResult.indexOf("/") + 1);
	                    attachFilename = attachFilename.substr(0, attachFilename.lastIndexOf("/"));

	                    if (attachFilename.substr(0, 2) != "OK") {
	                        try {
	                            txtPhotoFile.value = "";
	                        }
	                        catch (e) {
	                        }
	                        alert(g_fileList[i] + " " + strLang24 + "");
	                        txtPhotoFile.value = "";
	                        return;
	                    }
	                    else {
	                        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1"); 
	                        ezUtil.UseUTF8 = true;
	                        fileSize = ezUtil.GetFileSize(g_fileList[i]);
	                        txtPhotoFile.value = ezUtil.ExtractFileName(g_fileList[i]);	
	                        ezUtil = null;
	                        var Result = attachFilename.substr(3, attachFilename.length - 3);

	                        imagefilepath = attachFilename.replace("OK_", "");
	                        var imgFileName = imagefilepath.split('/')[0];
	                        imagefilepath = "tempUploadFile/" + imgFileName;

	                        var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + pBoardID + "&fileName=" + imgFileName;
	                        document.getElementsByTagName("IMG")[0].src = imgSrc;
	                    }
	                }        
	            }
	        }
   		</script>
   		<c:if test="${!isCrossBrowser}">
	   		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
		        Append_AttachAdd(filename);
			</script>
   		</c:if>
	</head>
	<body class="popup" onLoad="window_onload()" style="overflow:hidden;">
	    <table class="layout">
	        <tr>
	            <td style="vertical-align:top">
	                <div id="menu">
	                    <ul>
	                        <li ID='btn_Modify'><span onClick="btn_ImgOnclick()"><spring:message code='ezBoard.t316'/></span></li>
	                        <li ID='Li1'><span onClick="btn_PhotoChange()"><spring:message code='ezBoard.t1002'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onClick="window.close()"><spring:message code='ezBoard.t12'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr id="mainimage" style="display:none">
	            <td>
	                <input type="checkbox" id="mainFG" /><spring:message code='ezBoard.t00003'/>
	            </td>
	        </tr>
	        <tr>
	            <th style="height:28px; line-height:28px; border-bottom:0 none; background:#fff;"><spring:message code='ezBoard.t1012'/></th>
	        </tr>
	        <tr>
	            <td style="width:100%; height:250px; border:1px solid #b6b6b6; padding:5px;background:#e5e5e5;" >
	                <div class="viewbox" style="width:100%; border:0 none; padding:0; background:none;">
	                	<c:set var="result" value="${fn:split(listImages, ';')}"/>
	                	<c:forEach var="res" items="${result}" varStatus="vs">
		                    <table style="width:100%">
		                        <tr>
		                            <td style="text-align:center">
		                                <span id='imagechange1' class='preView' style='display:none;' value=""></span>
		                                <img src='${res}' width='${g_Width}' height ='${g_Height}' id='image${vs.count}' name='zb_target_resize' style='cursor:pointer;'/>
		                            </td>
		                        </tr>
		                    </table>
	                	</c:forEach>
	                    <table style="width:100%">
	                    	<tr>
	                        	<td style="width:100%; padding:3px 0px 0px 0px;">
	                                <input type="text" id='getcontent' style='width:98%; border:1px solid #bbbbbb; background:#fff; height:21px; line-height:21px; padding:0px 0px 0px 4px;' maxlength="50" value="${imageContent}" />
	                            </td>
	                        </tr>
	                    </table>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="width:100%; display:none;">
	                <input type="text" id='getcontent' style='width:100%' maxlength="50" value="${imageContent}"/>
	            </td>         
	        </tr>
	        <tr>
	    <td style="display:none;">
	    	<c:if test="${!isCrossBrowser}">
		    	<SCRIPT type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</SCRIPT>
	    	</c:if>
	    	<div id="lstAttachLink">&nbsp;</div>
	    </td>
	  </tr>
	    </table>
	    <input type="text" id="txtPhotoFile" style="WIDTH:85%; display:none" readonly >
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="" target="ifrm">
	    <input type="file" name="file1" id="file1"  style="width: 1px; height: 1px;" onChange="imgtemp_onclick()"/>
	    <input type="hidden" name="mode" id="mode" />
	    </form>
	</body>
</html>