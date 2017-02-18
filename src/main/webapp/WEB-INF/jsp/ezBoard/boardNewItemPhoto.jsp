<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t368'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
	    <style type="text/css">
	         .preView { width: 70px; height: 70px; text-align: center; border:1px solid silver; }
	     </style>
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
   	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="/js/ezBoard/AttachMain.js"></script>
		    <script type="text/javascript" src="/js/ezBoard/AttachItem.js"></script>
		    <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="/js/ezBoard/AttachMain_CK.js"></script>
		    <script type="text/javascript" src="/js/ezBoard/AttachItem_CK.js"></script>
	    </c:if>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
	    <script type="text/javascript">
	        var pMode = "NEW";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pBoardID = "${boardID}";
	        var pUrl = "${url}";
	        var PhotoBoard = "N";
	        var spanimagename = "";
	        var resultcmd = "";
	        var MHTLoadComplete = "true";
	        var strNow = "${strNow}";		
	        var bodycount = "0";
	        var pAttachListXml = "";
	        var gubun = "3";
	        var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName1}";
		    var SSUserName2 = "${userInfo.displayName2}";
		    var SSDeptID = "${userInfo.deptID}";
		    var SSDeptName = "${userInfo.deptName1}";
		    var SSDeptName2 = "${userInfo.deptName2}";
		    var SSCompanyID = "${userInfo.companyID}";
		    var SSCompanyName = "${userInfo.companyName1}";
		    var SSCompanyName2 = "${userInfo.companyName2}";
	        var strUserRank = "${userInfo.title1}";
		    var strUserRank2 = "${userInfo.title2}";
		    var strUserPhone = "${userInfo.phone}";
	        var pUploadFilePath = "${uploadFilePath}";
	        var isdad = false;
	        var isfileup = false;
	        var pUse_Editor = "${useEditor}";
	        var pNoneActiveX = "YES";
	        var pUse_IE11Browser = "CK";
	        var saveItemBoardId = "";
	        var SelBoard = false;
	        function window_onload() {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                document.getElementById("file1").multiple = false;
	                window.resizeTo(780, 750);
	            }
	            try{
	                new FormData();
	                isdad = true;
	            }
	            catch (e) {
	            }
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
	
	        function addimageline(imgpath, localFileName, imgUniqueID, imgSize)
	        {
	            var imagecount = "";
	            var imageid = "";
	
	            if (isdad || CrossYN()) {
	                imagecount = imgpath.split("/").length - 1;
	                imageid = imgpath.split("/")[imagecount];
	                tmpContents = new Array();
	                for(var i = 0 ; i < document.getElementsByName("imgContent").length ; i++)
	                {
	                    tmpContents[i] = document.getElementsByName("imgContent")[i].value;
	                }
	
	                if (document.getElementById(imageid) != "" && document.getElementById(imageid) != null)
	                    return "false";
	
	                var resultHTML = "";
	                var ua = navigator.userAgent;
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    resultHTML = "<table width='100%' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + imageid + "' name='" + imgpath + "' uniqueId='" + imgUniqueID + "' ><tr>" +
	                                     "<td style='width:25px;background:rgb(245, 245, 245);border-top:0 none;'><input type='checkbox' value='" + "M_" + imageid + "' id='imagecheck" + bodycount + "'  name='checkmenuSub' /></td>" +
	                                     "<td style='width:113px; height: 100px;border-top:0 none; padding:6px;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 100px; height: 100px;' name='imgView'></img></td>" +
	                                     "<td style='border-top:0 none; padding:6px 8px 6px 6px;'><textarea type=/text' style='width:100%; height:100px; border:1px solid #b6b6b6; margin:0; padding:0;' maxlength='50' name='imgContent'></textarea></td>" +
	                                     "<td style='width:72px; border-top:0 none; padding:0px 6px; text-align:center;'><input type='radio' name=mainFG /></td></tr></table>";
	                }
	                else {
	                    resultHTML = "<table width='100%' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + imageid + "' name='" + imgpath + "' uniqueId='" + imgUniqueID + "' ><tr>" +
	                                     "<td style='width:20px;background:rgb(245, 245, 245);border-top:0 none;'><input type='checkbox' value='" + "M_" + imageid + "' id='imagecheck" + bodycount + "'  name='checkmenuSub' /></td>" +
	                                     "<td style='width:100px; height: 100px;border-top:0 none; padding:6px;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 100px; height: 100px;' name='imgView'></img></td>" +
	                                     "<td style='border-top:0 none; padding:6px 8px 6px 6px;'><textarea type=/text' style='width:100%; height:100px; border:1px solid #b6b6b6; margin:0; padding:0;' maxlength='50' name='imgContent'></textarea></td>" +
	                                     "<td style='width:72px; border-top:0 none; padding:0px 6px; text-align:center;'><input type='radio' name=mainFG /></td></tr></table>";
	                }
	                var imagecontent = document.getElementById("addimagecontent");
	                imagecontent.innerHTML += resultHTML;
	                for (var i = 0 ; i < tmpContents.length ; i++) {
	                    document.getElementsByName("imgContent")[i].value = tmpContents[i];
	                }
	
	                if (imagecontent != null && imagecontent != "") {
	                    var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(imgpath);
	                    document.getElementById(imageid).src = imgSrc;
	                    bodycount = parseInt(bodycount) + 1;
	                }
	            } else {
	                imagecount = imgpath.split("\\").length - 1;
	                imageid = imgpath.split("\\")[imagecount];
	
	                if (document.getElementById(imageid) != "" && document.getElementById(imageid) != null)
	                    return "false";
	
	                var resultHTML = "<table width='100%' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + imageid + "' name='" + imgpath + "' uniqueId='" + imgUniqueID + "' ><tr>" +
	                                     "<td style='width:25px;background:rgb(245, 245, 245);border-top:0 none;'><input type='checkbox' value='" + "M_" + imageid + "' id='imagecheck" + bodycount + "'  name='checkmenuSub' /></td>" +
	                                     "<td style='width:113px; height: 100px;border-top:0 none; padding:6px;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 100px; height: 100px;' name='imgView'></img></td>" +
	                                     "<td style='border-top:0 none; padding:6px 8px 6px 6px;'><textarea type=/text' style='width:100%; height:100px; border:1px solid #b6b6b6; margin:0; padding:0;' maxlength='50' name='imgContent'></textarea></td>" +
	                                     "<td style='width:72px; border-top:0 none; padding:0px 6px; text-align:center;'><input type='radio' name=mainFG /></td></tr></table>";
	
	                var imagecontent = document.getElementById("addimagecontent");
	                imagecontent.innerHTML += resultHTML;
	                if (imagecontent != null && imagecontent != "") {
	                    document.getElementById(imageid).src = localFileName;
	                    bodycount = parseInt(bodycount) + 1;
	                }                
	            }
	        }
	
	        function GetSmallUrl() {
	            var xmldom_attachlist = createXmlDom();
	            var strRet = "";
	            var filepath = "";
	
	            if (typeof (pAttachListXml) == "string")
	                xmldom_attachlist = loadXMLString(pAttachListXml);
	            else
	                xmldom_attachlist = pAttachListXml;
	
	            if (isdad || CrossYN()) {
	                if (xmldom_attachlist == false) {
	                    xmldom_attachlist = null;
	                    return "";
	                }
	            }
	            var xmldomNodes = xmldom_attachlist.getElementsByTagName('DATA2');
	
	            for (var i = 0; i < xmldomNodes.length; i++) {
	                filepath = getNodeText(xmldomNodes.item(i));
	                if (filepath.indexOf(pBoardID) != -1) {
	                    var idx = filepath.lastIndexOf("/");
	                    if (idx != -1) {
	                        strRet += filepath.substr(0, idx + 1) + "s_" + filepath.substr(idx + 1) + ";";
	                    }
	
	                } else {
	                    if (saveItemBoardId != "" && saveItemBoardId == pBoardID)
	                        strRet += "tempUploadFile/s_" + getNodeText(xmldomNodes.item(i)) + ";";
	                    else
	                        strRet += saveItemBoardId + "/uploadFile/s_" + getNodeText(xmldomNodes.item(i)) + ";";
	                }
	            }
	            xmldom_attachlist = null;
	            return strRet;
	        }
	        function SaveItem(pMode)
	        {
	            if (pBoardID == "") {
	                if (!SelBoard) {
	                    alert("<spring:message code='ezBoard.t173'/>");
	                    return;
	                }
	            }
	
	            var bodycount = document.getElementById("addimagecontent").childNodes.length;
	            var file = "";
	            var content = "";
	            var filename = "";
	            var mainImageID = "";
	            if(bodycount == 0)
	            {
	                alert(strLang44);
	                return;
	            }
	
	            if (isdad || CrossYN()) {
	                for (var i = 0; i < bodycount; i++) {
	                    content += document.getElementsByName('imgContent')[i].value + ";:;";
	                    filename += document.getElementsByName('imgView')[i].title + ";";
	                }
	            } else {
	                for (var i = 0; i < bodycount; i++)
	                {
	                    var checkreuslt = document.getElementById("addimagecontent").childNodes[i].childNodes[0].childNodes[0].childNodes[0].childNodes[0];
	                    var checkreuslts = document.getElementById("addimagecontent").childNodes[i].childNodes[0].childNodes[0].childNodes[2].childNodes[0];
	                    
	                    file += GetAttribute(document.getElementById(checkreuslt.value),'name') + "|";
	                    content += checkreuslts.value + ";:;";

	                    var imagenamelength = GetAttribute(document.getElementById(checkreuslt.value),'name').lastIndexOf("\\");
	                    
	                    filename += GetAttribute(document.getElementById(checkreuslt.value),'name').substring(imagenamelength + 1, imagenamelength.length) + ";";
	                }
	            }
			
	            if(MHTLoadComplete != "true") 
	            {
				    alert("<spring:message code='ezBoard.t377'/>");		
				    return;
			    }
			
			    var strXML = "";
			    var newID = "";
			    var pStartDate = "";
			    var pEndDate ="9999-12-30 23:59:59";
			
			    if (txtTitle.value == "")
			    {
				    alert("<spring:message code='ezBoard.t390'/>");
				    txtTitle.focus();
				    return;				
			    }
	
	            var check = true;
	            for (var i = 0 ; i < document.getElementsByName("mainFG").length ; i++) {
	                if (document.getElementsByName("mainFG")[i].checked)
	                    check = false;
	            }
	            if (check) {
	                alert(strLang45);
	                return;
	            }
	
	            if (bodycount == 0) {
	                alert("<spring:message code='ezBoard.t454'/>");
	                return;
	            }
			    
	            if (bodycount == 0)
			    {
				    alert("<spring:message code='ezBoard.t454'/>");
				    return;	
			    }
	            
	            if (document.getElementsByName('checkmenuSub').length > 100) {
	            	alert("<spring:message code='ezBoard.hyj05'/>");
				    return;
	            }
			    
			    newID = "{" + GetGUID() + "}";
	
			    var xmlhttp = createXMLHttpRequest();
			    var xmldom = createXmlDom();
			
			    strXML += "<NODES>";
			    strXML += "<NODE>";
			    
			    //2006.11.28 포토게시물 5건까지 등록할 수 있도록 수정
	            var itemid = "";
	            itemid = "{" + GetGUID() + "}";
	
			    //멀티 이미지 추가시 
	            if(pMode != "modify") {		
	                strXML += "<ITEMID>" + itemid + "</ITEMID>";
	            } else {		
	                itemid = strItemID +";";
	                strXML += "<ITEMID>" + itemid + "</ITEMID>";
			    }
	
			    var importance = "";
				
	            importance = "0";
			    
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
			
			    // 수정(2008.03.19) : 사용자 정보가 누락되는 경우 체크하는 부분 추가
	
				strXML += "<WRITERID>" + SSUserID + "</WRITERID>";
				strXML += "<WRITERNAME>" + MakeXMLString(SSUserName) + "</WRITERNAME>";
				strXML += "<WRITERNAME2>" + MakeXMLString(SSUserName2) + "</WRITERNAME2>";
				strXML += "<DEPTID>" + SSDeptID + "</DEPTID>";
				strXML += "<DEPTNAME>" + MakeXMLString(SSDeptName) + "</DEPTNAME>";
				strXML += "<DEPTNAME2>" + MakeXMLString(SSDeptName2) + "</DEPTNAME2>";
				strXML += "<COMPANYID>" + SSCompanyID + "</COMPANYID>";
				strXML += "<COMPANYNAME>" + MakeXMLString(SSCompanyName) + "</COMPANYNAME>";
				strXML += "<COMPANYNAME2>" + MakeXMLString(SSCompanyName2) + "</COMPANYNAME2>";
	            strXML += "<IMPORTANCE>" + importance + "</IMPORTANCE>";
			    strXML += "<TITLE>" + MakeXMLString(txtTitle.value) + "</TITLE>";
			    strXML += "<STARTDATE>" + pStartDate + "</STARTDATE>";
			    strXML += "<ENDDATE>" + pEndDate + "</ENDDATE>";
			    strXML += "<ABSTRACT>" + MakeXMLString(txtAbstract.value) + "</ABSTRACT>";
			    strXML += "<ATTACHMENTS>" + MakeXMLString(AttachFileList_Photo()) + "</ATTACHMENTS>";
				strXML += "<UPPERITEMIDTREE>" + newID + "</UPPERITEMIDTREE>";
				strXML += "<PARENTWRITEDATE></PARENTWRITEDATE>";
				strXML += "<ITEMLEVEL>1</ITEMLEVEL>";
	            strXML += "<FILEPATH>" + pUploadFilePath + "</FILEPATH>";
			    //확장 필드(필요에 따라 추가)
			    strXML += "<EXTENSIONATTRIBUTE1></EXTENSIONATTRIBUTE1>";
			
			    // 20090913 : 게시판 공지게시 기능
			    //strXML += "<EXTENSIONATTRIBUTE2></EXTENSIONATTRIBUTE2>";
			    strXML += "<EXTENSIONATTRIBUTE2></EXTENSIONATTRIBUTE2>";
	
				strXML += "<EXTENSIONATTRIBUTE3>" + strUserRank + "</EXTENSIONATTRIBUTE3>";	//직급으로 사용
				strXML += "<EXTENSIONATTRIBUTE32>" + strUserRank2 + "</EXTENSIONATTRIBUTE32>";	//직급으로 사용
				strXML += "<EXTENSIONATTRIBUTE4>" + MakeXMLString(txtPhotoFile.value) + "</EXTENSIONATTRIBUTE4>";//이미지명으로 사용함
			    strXML += "<EXTENSIONATTRIBUTE5>" + MakeXMLString(GetSmallUrl()) + "</EXTENSIONATTRIBUTE5>";
			    
			    //20121018_[을지]_포토앨범 : 앨범소개 내용전달
	            strXML += "<CONTENT>" + MakeXMLString(photocontent.value) + "</CONTENT>";		    
	            strXML += "<DOCPASSWORD></DOCPASSWORD>";
	
	            //20121018_[을지]_포토앨범 : 각사진에 대한 이미지 ID를 부여
	            var filecount = document.getElementsByName('checkmenuSub').length;
	            var imageid = "";
	            for (var i = 0; i < filecount ; i++) {  
	                var tmpId = "{" + GetGUID() + "}";
	                if(document.getElementsByName("mainFG")[i].checked)
	                    mainImageID = tmpId;
	
	                imageid += tmpId + ";";
	            }
	            strXML += "<IMAGE_COUNT>" + filecount + "</IMAGE_COUNT>";
	            strXML += "<IMAGE_ID>" + imageid + "</IMAGE_ID>";
	            //20121018_[을지]_포토앨범 : 사진별 앨범 소개 글
	            strXML += "<CONTENT2>" + MakeXMLString(content) + "</CONTENT2>";
	            strXML += "<IMAGE_FILENAME>" + MakeXMLString(filename) + "</IMAGE_FILENAME>";
	            strXML += "<MAINIMAGEID>" + mainImageID + "</MAINIMAGEID>";
			    strXML += "</NODE>";
			    strXML += "</NODES>";
			    
	            xmldom.async = false;
			    xmldom.preserveWhiteSpace = true;
			    xmldom = loadXMLString(strXML);
			    xmlhttp.open("POST", "/ezBoard/saveItemPhoto.do?mode=" + pMode + "&guBun=" + gubun, false);
			    xmlhttp.send(xmldom);
	            
	            var strItemID = "";
	
	            if (SelectSingleNodeValue(loadXMLString(xmlhttp.responseText), "RESULT") == "OK") {
				    xmlhttp = null;
				    xmldom = null;
				    if (pMode != "temp") {
						if (strItemID == "")
						{
						    xmlhttp = createXMLHttpRequest();
							xmlhttp.open("POST", "/ezBoard/sendPostNotiMail.do?boardID=" + pBoardID + "&itemID=" + itemid, false);
							xmlhttp.send();		
							xmlhttp = null;
						}
						if (pMode == "reply")
						{
						    xmlhttp = createXMLHttpRequest();
						    xmlhttp.open("POST", "/ezBoard/sendReplyNoticeMail.do?boardID=" + pBoardID + "&itemID=" + itemid + "&itemTreeID=" + strUpperItemIDTree, false);
						    xmlhttp.send();
						    xmlhttp = null;
						}
						if ("${boardInfo.apprMail_FG}" == "Y") {
						    xmlhttp = createXMLHttpRequest();
						    if (pMode != "modify") {
						        xmlhttp.open("POST", "/ezBoard/sendApprNoticeMail.do?boardID=" + pBoardID + "&itemID=" + itemid, false);
						    } else {
						        xmlhttp.open("POST", "/ezBoard/sendApprNoticeMail.do?boardID=" + pBoardID + "&itemID=" + itemid, false);
						    }
						    xmlhttp.send();
						    xmlhttp = null;
						}
						
		                alert("<spring:message code='ezBoard.t399'/>");
				    } else {
		                alert("<spring:message code='ezBoard.t10033'/>");
				    }
	
	                try {
	                    window.opener.location.reload(false);
	                }
	                catch (e) { }
	
	                try {
						window.opener.leftCountRf();
					} catch (e) {
					}
					
					window.close();
	            } else {
	                if (loadXMLString(xmlhttp.responseText).text == "INACCESSIBLE")
	                    alert(strLang73);
	                else
	                    alert("<spring:message code='ezBoard.t403'/>" + loadXMLString(xmlhttp.responseText).text);
		        }
		
		        xmlhttp = null;
		        xmldom = null;
		    }
		
		    function imgtemp_onclick() {
		        if (document.form.file1.value != "") {
		            var extension = document.getElementById("file1").value.split('.');
		            var check = false;
		            check = compareExtension(check, extension[1]);

		            if (!check) {
		                document.getElementById("file1").value = "";
		                alert("<spring:message code='main.t4000'/>");
		                return;
		            }
		            
		            var fd = new FormData();
		            for (var i = 0; i < document.getElementById("form").file1.files.length; i++) {
		                fd.append("file1", document.getElementById("form").file1.files[i]);
		            }
		            fd.append("mode", document.getElementById("mode").value);
		            isfileup = true;
		            xhr = new XMLHttpRequest();
		            xhr.upload.addEventListener("progress", uploadProgress, false);
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=PICTURE&boardID=" + pBoardID + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		            document.getElementById("progdiv").style.display = "";
		        }
		    }
		    
		    function returnvalue(strXML) {
		        ImgaeReturnXml = loadXMLString(strXML);
		        var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
		        for (var i = 0; i < nodes.length ; i++) {
		
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert("" + strLang8 + "" + AttachLimit + "MB" + strLang9 + "");
		                return;
		            }
		            saveItemBoardId = pBoardID;
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
		            attachXml += "<DATA1>" + "/upload_board/tempUploadFile/" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA1>";
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
		
		    //사진추가
		    function btn_PhotoAttachAdd() {
		    	pAttachListXml = "";
		    	
		        if (CrossYN()) {
		        	document.getElementById('mode').value = "PICTURE";
		            document.form.file1.click();
		        } else {
		            if (isdad || CrossYN()) {
		            	document.getElementById('mode').value = "PICTURE";
		                document.form.file1.click();
		            } else {
		                var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		                ezUtil.UseUTF8 = true;
	
		                var file = ezUtil.OpenLoadDlgMultiNew("", "");
		                if (!file)
		                    return;
	
		                g_fileList = file.split("|");
	
		                var fileSize = 0;
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
		                saveItemBoardId = pBoardID;
		                show_progress_photo(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\") + 1) + "" + strLang10 + "" + 1 + "/" + (g_fileList.length - 1));
		            }
		        }
		    }
		
		    //사진삭제
		    function btn_PhotoAttachDel()
		    {
		        if (isdad || CrossYN()) {
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
		            
		            if (uniqueIDs == null || uniqueIDs == "") {
		            	alert("<spring:message code='ezBoard.t601'/>");
			    		return;	
		            }
		            
		            xmlhttp.open("POST", "/ezBoard/boardImageUpload.do?mode=DEL&boardID=" + pBoardID +"&uniqueIDs=" + uniqueIDs, false);
		            xmlhttp.send(fd);
		
		            document.getElementById("checkmenu").checked = false;
		        } else {
		            for (var i = document.getElementsByName('checkmenuSub').length - 1 ; i >= 0 ; i--) {
		                if (document.getElementsByName('checkmenuSub')[i].checked) {
		                    var obj = document.getElementById(document.getElementsByName('checkmenuSub')[i].value);
		                    obj.parentNode.removeChild(obj);
		                }
		            }
		            
		            if (uniqueIDs == null || uniqueIDs == "") {
		            	alert("<spring:message code='ezBoard.t601'/>");
			    		return;	
		            }
		            
		            document.getElementById("checkmenu").checked = false;
		        }
		
		        var attachXml = "<LISTVIEWDATA><ROWS>";
		        for (var i = 0 ; i < document.getElementById("addimagecontent").childNodes.length ; i++) {
		            attachXml += "<ROW><CELL>";
		            attachXml += "<DATA1>" + "/files/upload_board/" + pBoardID + "/uploadFile/" + GetAttribute(document.getElementsByName('imgView')[i], 'uniqueId') + "</DATA1>";
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
		
		        xmldom = null;
		        xmlHTTP = null;
		    }
		
		    function imagecheckAll(checkeds)
		    {
		        if (document.getElementsByName('checkmenu')[0].checked) {
		            for(var i = 0 ; i <document.getElementsByName('checkmenuSub').length ; i++)
		                document.getElementsByName('checkmenuSub')[i].checked = true;
		        } else {
		            for (var i = 0 ; i < document.getElementsByName('checkmenuSub').length ; i++)
		                document.getElementsByName('checkmenuSub')[i].checked = false;
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
		
		    function onDragEnter(evt) {
		        try{
		            evt.dataTransfer.dropEffect = "copy";
		            evt.stopPropagation();
		            evt.preventDefault();
		        }
		        catch (e) {
		            evt.dataTransfer.dropEffect = "none";
		        }
		    }
		    function onDragOver(evt) {
		        try{
		            evt.dataTransfer.dropEffect = "copy";
		            evt.stopPropagation();
		            evt.preventDefault();
		        }
		        catch(e){
		            evt.dataTransfer.dropEffect = "none";
		        }
		    }
		    var xhr = null;
		    function onDrop(evt) {
		        try{
		            evt.stopPropagation();
		            evt.preventDefault();
		
		            if (isfileup) {
		                alert("<spring:message code='ezBoard.t2000'/>");
		                return;
		            }
		
		            var file = evt.dataTransfer.files;
		
		            var fd = new FormData();
		            for (var i = 0; i < file.length; i++) {
		                fd.append("file1", file[i]);
		            }
		            fd.append("mode", document.getElementById("mode").value);
		            isfileup = true;
		            xhr = new XMLHttpRequest();
		            xhr.upload.addEventListener("progress", uploadProgress, false);
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=PICTURE&boardID=" + pBoardID + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		
		            document.getElementById("progdiv").style.display = "";
		        }
		        catch(e){
		        }
		    }
		    function uploadProgress(evt) {
		        if (evt.lengthComputable) {
		            var percentComplete = Math.round(evt.loaded * 100 / evt.total);
		            document.getElementById('prog_bar').style.width = percentComplete + "%";
		            document.getElementById('prog_num').innerHTML = percentComplete;
		        }
		    }
		    function uploadComplete() {
		        document.getElementById("progdiv").style.display = "none";
		        document.getElementById("prog_bar").style.width = "0%";
		        document.getElementById("prog_num").innerHTML = "";
		        //document.getElementById("file1").type = "text";
		        //document.getElementById("file1").type = "file";
		
		        document.getElementById("file1").value = "";
		        returnvalue(xhr.responseText);
		        isfileup = false;
		    }
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var wWeight = "345";
		            var wHeight = "660";
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
		            if (typeof (ret) != "undefined" && typeof (ret) == "object") {
		                GetBoardInfo();
		                if (ret[2] != "3" && ret[2] != "4") {
		                    if (!confirm("<spring:message code='ezBoard.t10055'/>"))
		                        return;
		                    else {
	                            document.location.href = "/ezBoard/boardNewItem.do?boardID=" + ret[0] + "&mode=new&boardName=" + ret[1] + "&bType=SELECT";
		                    }
		                }
		                pBoardID = ret[0];
		                document.getElementById("BoardSpan").innerHTML = ret[1];
		
		                SelBoard = true;
		            }
		        }
		    }
	        function NewItem_onclick_Complete(ret) {
	            if (typeof (ret) != "undefined" && typeof (ret) == "object") {
	                GetBoardInfo();
	                if (ret[2] != "3" && ret[2] != "4") {
	                    if (!confirm("<spring:message code='ezBoard.t10055'/>"))
	                        return;
	                    else {
                            document.location.href = "/ezBoard/boardNewItem.do?boardID=" + ret[0] + "&mode=new&boardName=" + ret[1] + "&bType=SELECT";
	                    }
	                }
	                pBoardID = ret[0];
	                document.getElementById("BoardSpan").innerHTML = ret[1];
	
	                SelBoard = true;
	            }
	        }
		    function GetBoardInfo() {
		        var xmlhttp_boardinfo = createXMLHttpRequest();
		        xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + pBoardID, false);
		        xmlhttp_boardinfo.send();
		        if (xmlhttp_boardinfo.status == 200) {
		            pBoardName = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BOARDNAME")[0]);
		            AttachLimit = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "ATTACHLIMIT")[0]);
		            ExpireDays = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "EXPIREDAYS")[0]);
		            gubun = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "GUBUN")[0]);
		        }
		        xmlhttp_boardinfo = null;
		    }
	    </script>
	</head>
	<c:if test="${!isCrossBrowser}">
		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
		    Append_AttachAdd(filename);
		</script>
	</c:if>
	<body class="popup" onload="javascript:window_onload()">
	    <table border="0" class="layout">
	        <tr>
	            <td style="height:20px">
	              <div id="menu">
	                <ul>
	                  <li ><span onClick="SaveItem('new');"><spring:message code='ezBoard.t98'/></span></li>
	                  <li ><span ID='btn_Reply' onclick='btn_PhotoAttachAdd()'><spring:message code='ezBoard.t1001'/></span></li>
	                  <li ><span id="Span2" onClick="return btn_PhotoAttachDel()"><spring:message code='ezBoard.t1003'/></span></li>
	                  <li><span  onClick="SaveItem('temp');"><spring:message code='ezBoard.t10034'/></span></li>
	                </ul>
	              </div>
	              <div id="close">
	                <ul>
	                    <li ><span onclick="window.close();"><spring:message code='ezBoard.t12'/></span></li>
	                </ul>
	              </div>
	<script type="text/javascript">
	    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    selToggleList(document.getElementById("close"), "ul", "li", "0");
	</script>
	        </td>
	  </tr>
	  <tr>
	      <td>
	      <table border="0" cellspacing="0" cellpadding="0" class="content" style="table-layout:fixed;">
	        <tr>
	          <th style="width:100px;">
	          	<c:choose>
	          		<c:when test="${boardType != 'SELECT'}">
		                <spring:message code='ezBoard.t142'/>
	          		</c:when>
	          		<c:otherwise>
		                <a class="imgbtn" onclick="NewItem_onclick()"><span><spring:message code='ezBoard.t171'/></span></a>
	          		</c:otherwise>
	          	</c:choose>
	          </th>
	          <td style="width:70%" id="tdBoardName">
	          	<c:choose>
	          		<c:when test="${boardType != 'SELECT'}">
	          			${boardInfo.boardName}
	          		</c:when>
	          		<c:otherwise>
	          			<c:choose>
	          				<c:when test="${boardID == ''}">
			                    <span id="BoardSpan"><spring:message code='ezBoard.t57'/></span>
	          				</c:when>
	          				<c:otherwise>
			                    <span id="BoardSpan">${boardInfo.boardName}</span>
	          				</c:otherwise>
	          			</c:choose>
	          		</c:otherwise>
	          	</c:choose>
	          </td>
	          <th style="width:80px; text-align:center"><spring:message code='ezBoard.t207'/></th>
	          <td style="width:120px; text-align:center">${userID}</td>
	        </tr>
	        <tr>
	          <th style="text-align:center"><spring:message code='ezBoard.t208'/></th>
	          <td colspan="3" style="width:100%; vertical-align:middle; padding:0px 5px 0px 3px; margin:0;"><INPUT type="text" id="txtTitle" style="WIDTH:100%;word-wrap:break-word;word-break:break-all; border:1px solid #b6b6b6; margin:0px; padding:2px 0px 2px 0px;" value="" maxlength="100" /></td>
	        </tr>
	        <tr style="display:none;">
	          <th><spring:message code='ezBoard.t1001'/></th>
	          <td class="pos1" colspan="3" style="width:100%;"><input style="width:600px;" id="fileData" name="fileData" type="file" onchange="fileUploadPreview(this, 'preView')" /></td>
	        </tr>
	        <tr style="display:none;">
	          <th><spring:message code='ezBoard.t1021'/></th>
	          <td class="pos1" colspan="3" style="width:100%"><input type="text" id="txtPhotoFile" style="width:85%" readonly ></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezBoard.t1008'/></th>
	            <td colspan="3" style="height:100px; margin:0; padding:3px 5px 3px 3px;"><textarea style="width:100%; height:100px; margin:0; padding:0; border:1px solid #b6b6b6;" id="photocontent" wrap="hard"></textarea></td>
	        </tr>
	      </table>
	      </td>
	  </tr>
	  <tr>
	    <td>
	        <table style="width:100%; border:1px solid #b6b6b6; border-top:0 none; table-layout:fixed;" border="0" cellspacing="0" cellpadding="0">
	        <tr>
	            <th width="60" style="text-align:left;padding-left:3px;border:0;"><input id="checkmenu" type="checkbox" onclick="imagecheckAll(this)" name="checkmenu"/></th>
	            <th style="text-align:center ;padding-left:2px;border:0;"><spring:message code='ezBoard.t1012'/></th>
	            <th width="72" style="text-align:center;padding-left:2px;border:0;"><spring:message code='ezBoard.t1022'/></th>
	        </tr>
	      </table>
	    </td>
	  </tr>
	  <tr>
	    <td colspan="4">
	        <div id="addimagecontent" style="overflow:auto;width:100%;height:415px; vertical-align:top" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)"></div>
	    </td>
	  </tr>
	  <tr>
	    <td>
	        <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	        <form method="post" id="form" name="form" enctype="multipart/form-data" action="" target="ifrm">
	        <input type="file" name="file1" id="file1"  style="width: 1px; height: 1px;" onchange="imgtemp_onclick()" accept="image/*" multiple />
	        <input type="hidden" name="mode" id="mode" />
	        </form>
	    </td>
	  </tr>
	  <tr style="display:none">
	    <th><spring:message code='ezBoard.t209'/></th>
	    <td style="vertical-align:middle" colspan="2"><input type="text" id="txtAbstract"  style="width:100%;word-break:break-all" value="" maxlength=100></td>
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
	    <div id="progdiv" class="progarea" style="z-index:6000;position:absolute;top:370px;left:227px;display:none">
	        <P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
	    </div>
	</body>
</html>