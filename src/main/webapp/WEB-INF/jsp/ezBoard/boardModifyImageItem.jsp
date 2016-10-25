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
	    <script type="text/javascript" src="/js/ezBoard/AttachMain_CK.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/AttachItem_CK.js"></script>
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
		        document.getElementById("file1").value = "";
		        returnvalue(xhr.responseText);
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
	                document.getElementById('mode').value = "PHOTO";
	                document.form.file1.click();
	        }
   		</script>
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