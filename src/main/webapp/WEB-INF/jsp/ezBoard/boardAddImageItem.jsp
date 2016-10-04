<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <style type="text/css">
	         .preView { width: 70px; height: 70px; text-align: center; border:1px solid silver; }
	    </style>
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/AttachMain_CK.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/AttachItem_CK.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
	    <script type="text/javascript">
	        var pMode = "new";
	        var bodycount = "0";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pItemID = "${itemID}";
	        var pBoardID = "${boardID}";
	        var PhotoBoard = "N";
	        var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName1}";
		    var SSUserName2 = "${userInfo.displayName2}";
		    var SSDeptID = "${userInfo.deptID}";
		    var SSDeptName = "${userInfo.deptName1}";
		    var SSDeptName2 = "${userInfo.deptName2}";
		    var SSCompanyID = "${userInfo.companyID}";
		    var SSCompanyName = "${userInfo.companyName1}";
		    var SSCompanyName2 = "${userInfo.companyName2}";
	        var g_fileList;
	        var pNoneActiveX = "YES";
	        var pUrl = "";
	        window.onload = function () {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                document.getElementById("file1").multiple = false;
	            }
	        };
	
	        function btn_PhotoAttachAdd() {
                document.getElementById('mode').value = "PHOTO";
                document.form.file1.click();
	        }
	        
	        function uploadComplete() {
		        document.getElementById("file1").value = "";
		        returnvalue(xhr.responseText);
		    }
	
	        //사진 이미지 추가
	        function returnvalue(strXML) {
	            ImgaeReturnXml = loadXMLString(strXML);
	            var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
	
	            for (var i = 0; i < nodes.length ; i++) {
	                var rtnMode = getNodeText(GetChildNodes(nodes[i])[5]);
	
	                var imgFileName = getNodeText(GetChildNodes(nodes[i])[0]);
	                var localFileName = getNodeText(GetChildNodes(nodes[i])[2]);
	                var imgFileSize = getNodeText(GetChildNodes(nodes[i])[3]);
	                var imgUniqueID = getNodeText(GetChildNodes(nodes[i])[6]);
	
	                addimageline(imgFileName, localFileName, imgUniqueID, imgFileSize);
	            }
	
	            var attachXml = "<LISTVIEWDATA><ROWS>";
	            for (var i = 0 ; i < document.getElementById("addimagecontent").childNodes.length ; i++) {
	                attachXml += "<ROW><CELL>";
	                attachXml += "<DATA1>" + "/upload_board/" + pBoardID + "/uploadFile/" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA1>";
	                attachXml += "<DATA2>" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA2>";
	                attachXml += "<DATA3></DATA3>";
	                attachXml += "<DATA4></DATA4>";
	                attachXml += "<DATA5>Y</DATA5>";
	                attachXml += "<DATA6>" + GetAttribute(document.getElementsByName('imgView')[i], 'size') + "</DATA6>";
	                attachXml += "</CELL></ROW>";
	            }
	            attachXml += "</ROWS></LISTVIEWDATA>";  //pAttachListXml
	
	            var xmlDom = createXmlDom();
	            xmlDom = loadXMLString(attachXml);
	            pAttachListXml = xmlDom;
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
	
	        function addimageline(imgpath, localFileName, imgUniqueID, imgSize) {
	            var imagecount = "";
	            var imageid = "";
	
                imagecount = imgpath.split("/").length - 1;
                imageid = imgpath.split("/")[imagecount];

                if (document.getElementById(imageid) != "" && document.getElementById(imageid) != null)
                    return "false";

                var resultHTML = "<table width='100%' class='content' id='" + "M_" + imageid + "' name='" + imgpath + "'  uniqueId='" + imgUniqueID + "' ><tr>" +
                                 "<td style='width:25px;padding:0px; margin:0px;'><input type='checkbox' value='" + "M_" + imageid + "' id='imagecheck" + bodycount + "'  name='checkmenuSub' /></td>" +
                                 "<td style='width:100px; height: 100px;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 100px; height: 100px;' name='imgView'></img></td>" +
                                 "<td><textarea id='getcontent' style='width:97%; height:80px' maxlength='50' name='imgContent' ></textarea></input></td></tr></table>";

                var imagecontent = document.getElementById("addimagecontent");

                imagecontent.innerHTML += resultHTML;

                if (imagecontent != null && imagecontent != "") {
                    var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(imgpath);
                    document.getElementById(imageid).src = imgSrc;
                    bodycount = parseInt(bodycount) + 1;
                }
	        }
	
	        function btn_ImgAddOnclick() { 
	            var bodycount = document.getElementById("addimagecontent").childNodes.length;
	            var content = "";
	            var filename = "";
	
	            if(bodycount == 0)
	            {
	                alert(strLang44);
	                return;
	            }
                for (var i = 0; i < bodycount; i++) {
                    content += document.getElementsByName('imgContent')[i].value + " ;:;";
                    filename += document.getElementsByName('imgView')[i].title + ";";
                }
	            
	            var strXML = "";
	            var pStartDate = "";
	
	            var xmldom = createXmlDom();
	            var filecount = document.getElementsByName('checkmenuSub').length;
	            var imageid = "";
	            
			    strXML += "<NODES>";
			    strXML += "<NODE>";
	            strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	            
	            if(filecount > 0)
	            {
	                for (var i = 0; i < filecount ; i++) {
	                    imageid += "{" + GetGUID() + "} " + ";";
	                }
	            }
	            else{
	                alert(strLang74);
	                return;
	            }
	            
	            strXML += "<IMAGE_ID>" + imageid + "</IMAGE_ID>";
	
	            var filepath = MakeXMLString(GetSmallUrl());
	
				strXML += "<WRITERID>" + SSUserID + "</WRITERID>";
				strXML += "<WRITERNAME>" + MakeXMLString(SSUserName) + "</WRITERNAME>";
				strXML += "<DEPTID>" + SSDeptID + "</DEPTID>";
	            strXML += "<STARTDATE>" + pStartDate + "</STARTDATE>";
	            strXML += "<CONTENT2>" + content + "</CONTENT2>";
	            strXML += "<FILEPATH>" + filepath + "</FILEPATH>";
	            strXML += "<IMAGE_FILENAME>" + MakeXMLString(filename) + "</IMAGE_FILENAME>";
			    strXML += "</NODE>";
			    strXML += "</NODES>";
			    
	            xmldom.async = false;
			    xmldom.preserveWhiteSpace = true;
			    xmldom = loadXMLString(strXML);
	            //20121018_[을지]_포토앨범 : 업로드 실행 FileData에 저장
	            
			    var xmlhttp = createXMLHttpRequest();
			    xmlhttp.open("POST", "/ezBoard/saveImageItem.do", false);
	            xmlhttp.send(xmldom);
	
			    if(xmlhttp.responseText == "OK") 
	            {
				    xmlhttp = null;
				    xmldom = null;
				    alert(strLang46);
	                window.opener.page_reload();
	                window.close();
				}
	            else 
	            {
			        alert(strLang47);
				}
			
			    xmlhttp = null;
			    xmldom = null;
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
	
	        function GetSmallUrl() {
	            var xmldom_attachlist = createXmlDom();
	            var strRet = "";
	            var filepath = "";
	
	            if (typeof (pAttachListXml) == "string")
	                xmldom_attachlist = loadXMLString(pAttachListXml);
	            else
	                xmldom_attachlist = pAttachListXml;
	
	            if (CrossYN()) {
	                if (xmldom_attachlist == false) {
	                    xmldom_attachlist = null;
	                    return "";
	                }
	            }
	
	            //var xmldomNodes = xmldom_attachlist.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
	            var xmldomNodes = xmldom_attachlist.getElementsByTagName('DATA2');
	
	            for (var i = 0; i < xmldomNodes.length; i++) {
	                filepath = getNodeText(xmldomNodes.item(i));
	                if (filepath.indexOf(pBoardID) != -1) {
	                    var idx = filepath.lastIndexOf("/");
	                    if (idx != -1) {
	                        strRet += filepath.substr(0, idx + 1) + "s_" + filepath.substr(idx + 1) + ";";                        
	                    }
	
	                } else {
	                    //strRet += pBoardID + "/UploadFile/s_" + getNodeText(xmldomNodes.item(i)) + ";";
	                    strRet += "tempUploadFile/s_" + getNodeText(xmldomNodes.item(i)) + ";";
	                }
	            }
	            xmldom_attachlist = null;
	            return strRet;
	        }
	
	        function imagecheckAll(checkeds)
	        {
	            if (document.getElementsByName('checkmenu')[0].checked) {
	                for (var i = 0 ; i < document.getElementsByName('checkmenuSub').length ; i++)
	                    document.getElementsByName('checkmenuSub')[i].checked = true;
	            } else {
	                for (var i = 0 ; i < document.getElementsByName('checkmenuSub').length ; i++)
	                    document.getElementsByName('checkmenuSub')[i].checked = false;
	            }
	        }
	
	        function btn_PhotoAttachDel()
	        {
	            if (CrossYN()) {
	                var xmlhttp = createXMLHttpRequest();
	                var uniqueIDs = "";
		            var fd = new FormData();
		            for (var i = document.getElementsByName('checkmenuSub').length - 1 ; i >= 0 ; i--) {
		                if (document.getElementsByName('checkmenuSub')[i].checked) {
		                    var obj = document.getElementById(document.getElementsByName('checkmenuSub')[i].value);
		                    uniqueIDs += obj.getAttribute('uniqueID') + ";";
		                    obj.parentNode.removeChild(obj);
		                }
		            }
	                xmlhttp.open("POST", "/ezBoard/boardImageUpload.do?mode=DEL&boardID=" + pBoardID +"&uniqueIDs=" + uniqueIDs, false);
	                xmlhttp.send(xmldom);
	
	                document.getElementById("checkmenu").checked = false;
	
	                if (document.getElementsByName('checkmenuSub').length == 0)
	                    txtPhotoFile.value = "";
	
	                xmlHTTP = null;
	
	            } else {
	                for (var i = document.getElementsByName('checkmenuSub').length - 1 ; i >= 0 ; i--) {
	                    if (document.getElementsByName('checkmenuSub')[i].checked) {
	                        var obj = document.getElementById(document.getElementsByName('checkmenuSub')[i].value);
	                        obj.parentNode.removeChild(obj);
	                    }
	                }
	                document.getElementById("checkmenu").checked = false;
	
	                if (document.getElementsByName('checkmenuSub').length == 0)
	                    txtPhotoFile.value = "";
	            }
	        }
	
	        //create guid
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
	        //
	    
	    </script>
	</head>
	<body class="popup">
	    <table class="layout" >
	        <tr>
	            <td style="vertical-align:top" colspan="4">
	                <div id="menu">
	                <ul>
	                    <li ID='btn_Modify' ><span  onclick="btn_ImgAddOnclick()" ><spring:message code='ezBoard.t279'/></span></li>
	                    <li ID='Li1' ><span  onclick="btn_PhotoAttachAdd()" ><spring:message code='ezBoard.t1001'/></span></li>
	                    <li ID='Li2' ><span  onclick="btn_PhotoAttachDel()" ><spring:message code='ezBoard.t1003'/></span></li>
	                </ul>
	                </div>
	                <div id="close">
	                <ul>
	                    <li ><span  onClick="window.close();"><spring:message code='ezBoard.t12'/></span></li>
	                </ul>
	              </div>
	            </td>
	        </tr>
	    </table>
	    <table>
	        <tr style="display:none">
	          <th><spring:message code='ezBoard.t1009'/></th>
	          <td style="vertical-align:top; width:100%; padding-left:2px">
	              <INPUT type="text" id="txtPhotoFile" style="WIDTH:70%;" readonly="true" >
	              <%--<a class="imgbtn"><span id="Span1" onClick="return btn_PhotoAttachAdd()"><%=RM.GetString("t1001")%></span></a>--%>
	          </td>
	        </tr>
	        <tr>
	            <th style="text-align:left; margin: 0px; padding-left:2px; width:25px; border-right: 0px">
	                <input id="checkmenu" type="checkbox" onClick="imagecheckAll(this)"  name="checkmenu"/>
	            </th>  
	            <th style="text-align:center; height:25px; width:100%; border-left:0px"><spring:message code='ezBoard.t1010'/></th>
	        </tr>       
	        <tr style="vertical-align:top">
	            <td style="vertical-align:top; padding:0px; margin:0px" colspan="2">
	                <div id="addimagecontent" style="overflow:auto;width:100%;height:415px; vertical-align:top; text-align:left; border:0px; margin:0px; padding:0px"></div>
	            </td>
	        </tr>
	    </table>
	    <table>
	        <tr style="display:none;">
	            <td>
	                <div id="lstAttachLink">&nbsp;</div>
	            </td>
	        </tr>
	        <tr>
	            <td>
	                <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	                <form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
	                <input type="file" name="file1" id="file1"  style="width: 1px; height: 1px;" onchange="imgtemp_onclick()" multiple />
	                <input type="hidden" name="mode" id="mode" />
	                </form>
	            </td>
	        </tr>
	    </table>
	</body>
</html>