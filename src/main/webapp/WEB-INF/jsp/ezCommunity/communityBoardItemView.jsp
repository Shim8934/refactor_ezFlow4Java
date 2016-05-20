<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			window.offscreenBuffering = true;
	        var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
	        var curFontSize = 1;
	        var pItemID = "${itemID}";
			var pBoardID = "${boardID}";
	        var pBoardName = "${boardInfo.boardName}";
	        var strWriterID = "${item.writerID}";
	        var strWriterName = "${item.writerName}";
	        var strWriterDeptName = "${item.writerDeptName}";
	        var strWriterCompanyName = "${item.writerCompanyName}";
	        var strWriteDate = "${item.writeDate}";
	        var strImportance = "item.importance}";
	        var strEndDate = "${item.endDate}";
	        var strContentLocation = "${item.contentLocation}";
	        var strAttachList = "${item.attachments}";
	        var SSUserID = "${userInfo.id}";
	        var SSUserName = "${userInfo.displayName1}";
	        var Access_FG = "${boardInfo.access_FG}";
	        var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}>";
	        var ListView_FG = "${boardInfo.listView_FG}";
	        var Read_FG = "${boardInfo.read_FG}";
	        var Write_FG = "${boardInfo.write_FG}";
	        var Reply_FG = "${boardInfo.reply_FG}";
	        var Delete_FG = "${boardInfo.delete_FG}";
	        var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
	        var pReservedItem = "${pReservedItem}";
	        var g_progresswin;
	        var OneLineReplyFlag = "${oneLineReplyFlag}";
			var gubun = "${boardInfo.gubun}";
	        var userlang = "${userInfo.lang}";
	        var cadmin = "${cAdmin}";
	        var gcadmin = "${gcAdmin}";
	        var code = "${code}";
	        var ch_CommunityAdmin = "${chCommunityAdmin}";
	        var userinfo_lang = "${strUserLang}";
	    	var objMHT = new ActiveXObject("MhtFormat.Convert");
	    	var pUse_Editor = "${useEditor}";
	    	
	    	window.onload = function () {
	    	    try {
	    	    	var html = "";
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : { type	:	"COMMUNITYCONTENT", 
								 itemID	:	pItemID
							   },
						success: function(result){
							html = result;
						}        			
					});
					var doc = document.getElementById('message').contentWindow.document;
					doc.open();
					doc.write(html);
					doc.close();
                	 
	    	        AddLinkTarget();
	    	        SetAttachmentInfo();
	    	        
	    	        if (OneLineReplyFlag == "1") {
	    	        	getOneLineReply();
	    	        }
	
	    	        if (g_progresswin) {
	    	        	g_progresswin.close();
	    	        }
	    	    }
	    	    catch (e) {
	    	        alert(e.description);
	    	    }
	    	}

	        function AddLinkTarget() {
	            try {
	                var objTags = document.getElementById('message').getElementsByTagName("a");
	                for (var i = 0 ; i < objTags.length ; i++) {
	                    if (objTags.item(i).href.indexOf("javascript:") == -1)
	                        objTags.item(i).target = "_blink";
	                }
	            }
	            catch (e) { }
	        }


	        function ImageUrl(pUrl, cnt) {
	            var link = "/ezCommon/imgFileRead.do?pUrl=" + pUrl + "&cnt=" + cnt;

	            return link;
	        }

	        var checkpassword_dialogArguments = new Array();
	        function btn_Delete_Onclick() {
	            if (Delete_FG != "true") {
	                alert("<spring:message code='ezCommunity.t901'/>");
				    return;
				}

	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
	                if (gubun == "2") {
                		checkpassword_dialogArguments[1] = btn_Delete_Onclick_Complete;
                        var OpenWin = window.open("/ezComunity/checkPassword.do?itemID=" + pItemID, "checkPassWord", GetOpenWindowfeature(340, 200));
                        try {
                        	OpenWin.focus();
                        } catch (e) { }
	                } else {
	                	alert("<spring:message code='ezCommunity.t901'/>");
	                	return;
	                }
	            } else {
	            	 if (!confirm("<spring:message code='ezCommunity.t426'/>")) {
	            		 return;
	            	 }

	 			    var xmlhttp = createXMLHttpRequest();
	 			    xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + pItemID + ";", false);
	 			    xmlhttp.send();
	 			    xmlhttp = null;
	 			    
	 			    try {
	 			        window.opener.refresh_onclick();
	 			    } catch (e) {
	 			    }
	 			    window.close();
	            }
	        }
	        
	        function btn_Delete_Onclick_Complete(ret) {
	            if (typeof (ret) == "undefined") {
	            	alert("<spring:message code='ezCommunity.t901'/>");
	                return;
	            }

	            if (ret != "OK") {
	            	alert("<spring:message code='ezCommunity.t901'/>");
	                return;
	            }

	            if (!confirm("<spring:message code='ezCommunity.t426'/>")) { 
	            	return;
	            }

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + pItemID + ";", false);
	            xmlhttp.send();
	            xmlhttp = null;
	            try {
	                window.opener.refresh_onclick();
	            } catch (e) {
	            }
	            window.close();
	        }
	        

			function btn_Reply_Onclick() {
			    if (ch_CommunityAdmin < 0 && Write_FG != "true") {
			        alert("<spring:message code='ezCommunity.t431'/>");
				    return;
				}

	            if (Reply_FG != "true") {
	                alert("<spring:message code='ezCommunity.t938'/>");
				    return;
				}
	            
                window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply"
	        }

	        function btn_Modify_Onclick() {
	            if (Write_FG != "true" && gubun != "2") {
	                alert("<spring:message code='ezCommunity.t939'/>");
				    return;
				}

	            if (cadmin != "admin" && BoardAdmin_FG != "true" && BoardAdmin_FG != "true") {
	                if (strWriterID != SSUserID && gubun != "2") {
	                    alert("<spring:message code='ezCommunity.t939'/>");
					    return;
					}
	            }

	            if (gubun == "2") {
					checkpassword_dialogArguments = new Array();
                    checkpassword_dialogArguments[1] = btn_Modify_Onclick_Complete;
                    var OpenWin = window.open("/ezCommunity/checkPassword.do?itemID=" + pItemID, "CheckPassWord", GetOpenWindowfeature(340, 200));
                    try { OpenWin.focus(); } catch (e) { }
	            	
					window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;
	            } else {
// 	            	if (${pModify == 'ON'}) {
// 	                    alert("<spring:message code='ezCommunity.t941'/>");
// 	                    return;
// 	                }
	                
	                window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;
	            }
	        }
	        
	        function btn_Modify_Onclick_Complete(ret){
	            if (typeof (ret) == "undefined") {
	            	alert("<spring:message code='ezCommunity.t939'/>");
	                return;
	            }
	            
	            if (ret != "OK") {
	            	alert("<spring:message code='ezCommunity.t939'/>");
	                return;
	            }

// 	            if (${pModify == 'ON'}) {
// 	            	alert("<spring:message code='ezCommunity.t941'/>");
// 	                return;
// 	            }

                window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;	            
	        }

	        function btn_Copy_Onclick() {
	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
	                alert("<spring:message code='ezCommunity.t431'/>");
				    return;
				}
	            
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 200;
	            pwidth = pwidth - 127;

	            window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID + "&code=" + code, "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth, "");
	        }

	        function btnClose_onclick() {
	            window.close();
	        }

	        function SetAttachmentInfo() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();

	            xmlhttp.open("POST", "/ezCommunity/getItemAttachments.do?itemID=" + pItemID, false);
	            xmlhttp.send();

	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;

	            var i = 0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";
	            var strAttach = "";
	            var fileImage = "";

	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	            var regData = GetbrowserLanguage();

	            for (i = 0; i < xmldomNodes.length; i++) {
	                filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	                filename = filepath.substr(89, filepath.length - 88);
	                filename = ReplaceText(filename, "%2b", "+");
	                filename = ReplaceText(filename, "%3b", ";");
	                filepath = "/files/upload_community/" + filepath;
	                filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
	                var strTarget = "target='_blank'";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();

	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                    strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                    strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                    strFileExt == ".xlsx" || strFileExt == ".rtf") {
	                    strTarget = "target=''";
	                }

	                if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
	                    fileImage = "/images/image.png";
	                else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
	                    fileImage = "/images/doc.png";
	                else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
	                    fileImage = "/images/xls.png";
	                else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
	                    fileImage = "/images/ppt.png";
	                else if (strFileExt.indexOf(".txt") != -1)
	                    fileImage = "/images/txt.png";
	                else if (strFileExt.indexOf(".zip") != -1)
	                    fileImage = "/images/zip.png";
	                else if (strFileExt.indexOf(".pdf") != -1)
	                    fileImage = "/images/pdf.png";
	                else if (strFileExt.indexOf(".ecm") != -1)
	                    fileImage = "/images/ecm.png";
	                else
	                    fileImage = "/images/email/mail_006.gif";

	                var protocol = window.location.protocol;
	                var serverName = window.location.hostname;

	                strAttach = strAttach + "<input type='checkbox' name='fileSelect' value='" + filename + "' filehref=\"/ezCommunity/getCommunityAttachInfo.do?fileName=" + filename + "&filePath=" + filepath  + "\">";
	                strAttach = strAttach + "<img src='" + fileImage + "'> <a href=/ezCommunity/getCommunityAttachInfo.do?fileName=" + filename + "&filePath=" + filepath + ">";
	                strAttach = strAttach + filename + "&nbsp;(" + filesize + ")</a><br>";
	            }
	            document.getElementById('lstAttachLink').innerHTML = strAttach;
	        }

	        function attach_SelectAll() {
	            var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");
	            for (var i = 0; i < checks.length; i++)
	                checks.item(i).checked = true;
	        }

	        function attach_Download() {
	            var param = { "href": new Array(), "name": new Array(), "folderpath": new String() };
	            var count = 0;

	            var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");

	            for (var i = 0; i < checks.length; i++) {
	                if (checks.item(i).checked == true) {
	                    param["href"][count] = checks.item(i).filehref;
	                    param["name"][count] = checks.item(i).value;
	                    count++;
	                }
	            }
	            
	            if (count == 0) {
	                alert("<spring:message code='ezCommunity.t184'/>");
				    return;
	            }

	            var feature = "dialogWidth:430px; dialogHeight:170px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	            feature = feature + GetShowModalPosition(430, 170);
	            window.showModalDialog("aspx/attach_download.aspx", param, feature);
	        }

	        function attach_Download_Cross() {
	            var param = { "href": new Array(), "name": new Array() };
	            var count = 0;

	            var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");

	            for (var i = 0; i < checks.length; i++) {
	                if (checks.item(i).checked == true) {
	                    count++;
	                }
	            }
	            if (count == 0) {
	                alert("<spring:message code='ezCommunity.t184'/>");
				    return;
				}
	            downloadAll(checks);
	        }

	        var suffix = 0;
	        function downloadAll(checks) {
	            if (checks.item(suffix)) {
	                if (checks.item(suffix).checked) {
	                    location.href = checks.item(suffix++).value;
	                    setTimeout(function () { downloadAll(checks) }, 1000);
	                }
	                else {
	                    suffix++;
	                    downloadAll(checks);
	                }
	            }
	            else
	                suffix = 0;
	        }

	        function MemberInfo_onclick(pUserID) {
	            var feature = "height=290px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 290);
	            window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID, "", feature);
	        }
	        
	        <%-- function btn_SaveToPC_Onclick() {
	            var fPath;
	            var objMHT = new ActiveXObject("MhtFormat.Convert");
	            var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(strContentLocation);
	            objMHT.sync = true;
	            var strMht = objMHT.DownloadURL(fullPath);
	
	            objMHT.mhtData = strMht;
	            objMHT.filterIn();
	            var objSave = new ActiveXObject("EzUtil.MiscFunc");
	            objSave.UseUTF8 = true;
	            var strFilter;
	            strFilter = objSave.OpenSaveDlg("MHT", "", "<%=FileNameConvert(strTitle)%>");
	            if (strFilter != "") {
	                var arryFileNM = strFilter.split(".");
	                var cnt = arryFileNM.length;
	                var FileExtensionNM = arryFileNM[cnt - 1].toLowerCase();
	                if (FileExtensionNM == "mht") {
	                    objSave.SaveTextToFile(strFilter, objMHT.mhtData);
	                }
	                else {
	                    objSave.SaveTextToFile(strFilter, objMHT.htmlData);
	                }
	                alert("<%=RM.GetString("t282")%>");
	            }
	        } --%>

	        function Bigger() {
	            if (curFontSize < 4) {
	                curFontSize += 1;
	            }
	            txtContent.style.fontSize = fontSize[curFontSize];
	        }

	        function mail_boarditem() {
	        	var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;

                var szUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?boardid=" + pBoardID + "&itemid=" + pItemID + "&cmd=Community";

	            window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
	            window.close();
	        }

	        function ReaderList() {
	        	var szHref = "Item_ReadList.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID;
	            GetOpenWindow(szHref, "", 520, 400);
	        }

	        function btn_Print_Onclick() {
	        	var url = window.location.href;
	            url = url.replace(".do", "Print.do");
	            var feature = "height=720px, width=640px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1";
	            feature = feature + GetOpenPosition(640, 720);
	            window.open(url, "", feature);
	        }

	        function OpenUserInfo(pUserID) {
	        	var feature = "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 438);
	            window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
	        }

	        function OneLineReply_onkeydown() {
	            if (event.keyCode == 13) {
	            	Save_OneLineReply();
	            }
	        }

	        function Save_OneLineReply() {
	            if (Reply_FG != "true") {
	                alert("<spring:message code='ezCommunity.t938'/>");
				    return;
				}


	            if (OneLineReplyFlag == "1") {
	                if (document.getElementById('onelinereply').value == "") {
	                    alert("<spring:message code='ezCommunity.t942'/>");
			            return;
			        }
	            }

	            if (gubun == "2" && trim(document.getElementById('txtPassWord').value) == "") {
	                alert("<spring:message code='ezCommunity.t1144'/>");
			        document.getElementById('txtPassWord').focus();
			        return;
			    }

	            var pReplyID = "";
	            pReplyID = "{" + GetGUID().toUpperCase() + "}";

	            var strXML = "";

	            strXML += "<DATA>";
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	            strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	            strXML += "<REPLYID>" + pReplyID + "</REPLYID>";
	            if (OneLineReplyFlag == "1")
	                strXML += "<CONTENT>" + MakeXMLString(document.getElementById('onelinereply').value) + "</CONTENT>";
	            else
	                strXML += "<CONTENT></CONTENT>";

	            if (gubun != "2") {
	                strXML += "<PASSWORD></PASSWORD>";
	            }
	            else {
	                strXML += "<PASSWORD>" + Crypt_Encrytion(document.getElementById('txtPassWord').value) + "</PASSWORD>";
	            }
	            strXML += "</DATA>";

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/saveOneLineReply.do", false);
	            xmlhttp.send(strXML);

	            if (xmlhttp.status == 200) {
	                xmlhttp = null;
	                alert("<spring:message code='ezCommunity.t943'/>");
					document.getElementById('onelinereply').value = "";
					
					if (gubun == "2") {
						document.getElementById('txtPassWord').value = "";
					}
					    
					getOneLineReply();
	            }

	            xmlhttp = null;
	        }

	        var checkreplypassword_dialogArguments = new Array();
	        function delete_onelinereply(pReplyID) {
	            var xmlhttp = createXMLHttpRequest();

	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {

	                if (gubun == "2") {
                        checkreplypassword_dialogArguments = new Array();
                        checkreplypassword_dialogArguments[1] = delete_onelinereply_Complete;
                        var OpenWin = window.open("/ezCommunity/checkReplyPassword.do?itemID=" + pItemID + "&replyID=" + pReplyID, "checkReplyPassword", GetOpenWindowfeature(340, 200));
                        try {
                        	OpenWin.focus();
                        } catch (e) { }
	                } else {
	                    xmlhttp.open("POST", "/ezCommunity/checkOneLineOwner.do?replyID=" + pReplyID, false);
	                    xmlhttp.send();

	                    if (xmlhttp.responseText.substr(0, 2) != "OK") {
	                        alert("<spring:message code='ezCommunity.t944'/>");
				            return;
				        }

	                    if (!confirm("<spring:message code='ezCommunity.t945'/>")) {
	                    	return;
	                    }

	                    xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + pReplyID + "&gubun=" + gubun, false);
	                    xmlhttp.send();
	                    getOneLineReply();
	                    xmlhttp = null;
			        }
	            } else {

                    if (!confirm("<spring:message code='ezCommunity.t945'/>")) {
                    	return;
                    }

	                xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + pReplyID + "&gubun=" + gubun, false);
	                xmlhttp.send();
	                getOneLineReply();
	                xmlhttp = null;
				}
	        }
	        
	        function delete_onelinereply_Complete(ret) {
	            if (ret == "NO") {
	            	alert("<spring:message code='ezCommunity.t921'/>");
	                return;
	            } else if (ret == "cancel") {
	            	alert("<spring:message code='ezCommunity.t60'/>");
	                return;
	            }

	            xmlhttp.open("POST", "ezCommunity/deleteOneLineReply.do?replyID=" + pReplyID + "&gubun=" + gubun, false);
	            xmlhttp.send();
	            getOneLineReply();
	            xmlhttp = null;
	        }

	        function getOneLineReply() {
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
	            xmlhttp.send();

	            var xmldom = createXmlDom();
	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;

	            strHTML = "";
	            var temp;

	            for (var i = 0; i < xmldom.getElementsByTagName("REPLYID").length; i++) {
	                temp = i + 1;
	                if (gubun != "2" && userinfo_lang == "")
	                    strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
	                else if (gubun == "2" && userinfo_lang == "")
	                    strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
	                else if (gubun != "2" && userinfo_lang != "1")
	                    strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME2").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
	                else if (gubun == "2" && userinfo_lang != "1")
	                    strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME2").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";

	            }

	            if (i == 0)
	                strHTML = "<spring:message code='ezCommunity.t946'/>";
	            try {
	                document.getElementById('onelinereplylist').innerHTML = strHTML;
	            }
	            catch (e) {
	            }
	        }

	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }

	        function MakeXMLString(p_str) {
	            p_str = ReplaceText(p_str, "&", "&amp;");
	            p_str = ReplaceText(p_str, "<", "&lt;");
	            p_str = ReplaceText(p_str, ">", "&gt;");

	            return p_str;
	        }

	        function OpenItem(strItemID) {
	            if (strItemID != "") {
	            	window.location.href = window.location.href.replace(pItemID, strItemID);
	            }
	        }

	        function history_list() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 520) / 2;
	            var pLeft = (pwidth - 500) / 2;

	            window.open("/myoffice/ezBoardSTD/BoardHistoryList.aspx?itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=500,width=587, status = no, toolbar=no, menubar=no, scrollbars=1,location=no, resizable=0, top=" + pTop + ", left=" + pLeft, "");
	        }

	        function UpdateUserList() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 520) / 2;
	            var pLeft = (pwidth - 400) / 2;

	            var strUrl = "/ezCommunity/updateUserList.do?itemID=" + pItemID + "&pBoardID=" + pBoardID;
	            var strstate = "status:no;dialogHeight: 390px;dialogWidth: 520px;help: no;resizable:no"

	            window.open(strUrl, "", "width=400, height=400, resizable=yes, scrollbars=yes , top=" + pTop + ", left=" + pLeft, "");
	        }

	        function ToKMS() {
	        	var url = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezKMS/kasset/KAssetConvert_Cross.aspx?Mode=new&Flag=cop&ItemID=" + pItemID + "&boardid=" + pBoardID + "&url=" + strContentLocation + "&clubid=" + SSUserID;
	            var OpenWin = window.open(url, "KAssetConvert_Cross", GetOpenWindowfeature(780, 800));
	            try { OpenWin.focus(); } catch (e) { }
	        }

	        function trim(parm_str) {
	            if (parm_str == "")
	                return ""
	            else
	                return rtrim(ltrim(parm_str));
	        }

	        function ltrim(parm_str) {
	            var str_temp = parm_str;
	            while (str_temp.length != 0) {
	                if (str_temp.substring(0, 1) == " ") {
	                    str_temp = str_temp.substring(1, str_temp.length);
	                } else {
	                    return str_temp;
	                }
	            }
	            return str_temp;
	        }


	        function rtrim(parm_str) {
	            var str_temp = parm_str;
	            while (str_temp.length != 0) {
	                int_last_blnk_pos = str_temp.lastIndexOf(" ");
	                if ((str_temp.length - 1) == int_last_blnk_pos) {
	                    str_temp = str_temp.substring(0, str_temp.length - 1);
	                } else {
	                    return str_temp;
	                }
	            }
	            return str_temp;
	        }
		</script>
	</head>
	<body class = "popup">
		<script type="text/javascript">
			var MSIE = window.navigator.userAgent.indexOf("MSIE");
			var Trident = window.navigator.userAgent.indexOf("Trident");
		</script>
		<table class="layout">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<c:choose>
	                    		<c:when test="${pBoardID == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
	                    			<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
	                    			
	                    			<c:if test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
	                    				<li id='btn_Move'><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code='ezCommunity.t20'/></span></li>
	                    			</c:if>
	                    		</c:when>
	                    		
	                    		<c:when test="${pReservedItem == 'true' }">
									<li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
			                        <li id='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezCommunity.t208'/></span></li>
			                        
			                        <c:if test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
 	                    				<li id='btn_Move'><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code='ezCommunity.t20'/></span></li>
 	                    			</c:if>
								</c:when>
								
								<c:otherwise>
									<c:choose>
										<c:when test="${boardInfo.gubun == '2' }">
											<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
					                        <li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
					                        <li id='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezCommunity.t208'/></span></li>
					                        <li id='btn_Move'><span onclick='mail_boarditem()'><spring:message code='ezCommunity.t950'/></span></li>
					                        
					                        <c:if test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
					                        	<li id='btn_Move'><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code='ezCommunity.t20'/></span></li>
					                        </c:if>
					                        
					                        <li id='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezCommunity.t951'/></span></li>
										</c:when>
										
										<c:when test="${item.writerID == userInfo.id}">
											<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
					                        <li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
					                        <li id='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezCommunity.t208'/></span></li>
					                        
					                        <c:if test="${boardInfo.gubun != '2' }">
					                        	<li id='btn_Move'><span onclick='btn_Copy_Onclick()'><spring:message code='ezCommunity.t911'/></span></li>
					                        </c:if>
					                        
					                        <li id='btn_Move'><span onclick='mail_boarditem()'><spring:message code='ezCommunity.t950'/></span></li>
					                        
					                        <c:if test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
					                        	<li id='btn_Move'><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code='ezCommunity.t20'/></span></li>
					                        </c:if>
					                        
					                        <c:if test="${boardInfo.gubun != '2' }">
					                        	<li id='btn_Move'><span onclick='ReaderList()'><spring:message code='ezCommunity.t952'/></span></li>
					                        </c:if>
					                        
					                        <li id='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezCommunity.t951'/></span></li>
										</c:when>
										
										<c:otherwise>
				                        	<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
				                        	
				                        	<c:if test="${cAdmin == 'admin' || gcAdmin == 'OK' || boardInfo.boardAdmin_FG == 'true' }">
				                        		<li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
					                        	<li id='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezCommunity.t208'/></span></li>
				                        	</c:if>
			                        		
					                        <c:if test="${boardInfo.gubun != '2' }">
					                        	<c:if test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
					                        		<li id='btn_Move'><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code='ezCommunity.t20'/></span></li>
					                        	</c:if>
					                        </c:if>	
					                        
				                        	<li id='btn_Move'><span onclick='ReaderList()'><spring:message code='ezCommunity.t952'/></span></li>
					                        <li id='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezCommunity.t951'/></span></li>
					                        <li id='btn_Move'><span onclick='mail_boarditem()'><spring:message code='ezCommunity.t953'/></span></li>
										</c:otherwise>
									</c:choose>
									
									<c:choose>
										<c:when test="${pVersionUse == '1' }">
											<li id='btn_Move'><span onclick='UpdateUserList()'><spring:message code='ezCommunity.t955'/></span></li>
										</c:when>
										
										<c:when test="${pVersionUse == '2' }">
											 <li id='btn_Move'><span onclick='history_list()'><spring:message code='ezCommunity.t957'/></span></li>
										</c:when>
									</c:choose>
								</c:otherwise>
	                    	</c:choose>
	                    	
	                    	<c:if test="${useKMS == 'YES' }">
	                    		<li id='btn_KMS'><span onclick='ToKMS()'>KMS <spring:message code='ezCommunity.t958'/></span></li>
	                    	</c:if>

	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span onclick="btnClose_onclick()"><spring:message code='ezCommunity.t21'/></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="height:20px">
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezCommunity.t138'/></th>
	                        <c:choose>
	                        	<c:when test="${boardInfo.gubun != '2' }">
	                        		<td id="WriteUserNM" style="white-space: nowrap">
	                            		<div id="Div1" style="vertical-align: middle; overflow-y: auto; cursor: pointer" onclick='OpenUserInfo("${item.writerID}")'>${item.writerName}</div>
	                            	</td>
	                        	</c:when>
	                        	
	                        	<c:otherwise>
	                        		<td id="Td7" style="white-space: nowrap">
	                            		<div id="Div2" style="vertical-align: middle; height: 16px; overflow-y: auto;">${item.writerName}</div>
	                            	</td>
	                        	</c:otherwise>
	                        </c:choose>
	                        
	                        <th><spring:message code='ezCommunity.t209'/></th>
	                        <td id="PostDate" style="padding-right: 15px; white-space: nowrap"><div id="Div3" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto;">${item.writeDate}</div></td>
	                        <th><spring:message code='ezCommunity.t931'/></th>
	                        
	                        <c:set var="t930" value="<spring:message code='ezCommunity.t930'/>" />
	                        
	                        <c:choose>
	                        	<c:when test="${item.endDate == t930}">
	                        		<td id="EndDate" style="padding-right: 15px; white-space: nowrap; width: 100%;">
			                            <div id="Div4" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto;"><spring:message code='ezCommunity.t930'/></div>
			                        </td>
	                        	</c:when>
	                        	
	                        	<c:otherwise>
	                        		<td id="Td8" style="padding-right: 15px; white-space: nowrap; width: 100%;">
	                            		<div id="Div5" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto;">${item.endDate}</div>
	                        		</td>
	                        	</c:otherwise>
	                        </c:choose>
	                        
	                    </tr>
	                    
	                   
                    	<c:if test="${boardInfo.gubun != '2' }">
							<tr>
		                        <th><spring:message code='ezCommunity.t959'/></th>
		                        
		                        <c:choose>
		                        	<c:when test="${boardInfo.gubun != '2' }">
		                        		<td id="Td1" style="white-space: nowrap; width: 100px;"><span>${item.writerDeptName}</span></td>
		                        	</c:when>
		                        	
		                        	<c:otherwise>
		                        		<td id="Td2" style="white-space: nowrap; width: 100px;"><span>&nbsp;</span></td>
		                        	</c:otherwise>
		                        </c:choose>
		                        
		                        <th><spring:message code='ezCommunity.t960'/></th>
		                        
		                        <c:choose>
		                        	<c:when test="${boardInfo.gubun != '2' }">
		                        		<td id="Td3"><span>${item.extensionAttribute3}</span></td>
		                        	</c:when>
		                        	
		                        	<c:otherwise>
		                        		<td id="Td4"><span>&nbsp; </span></td>
		                        	</c:otherwise>
		                        </c:choose>
		                        
		                        <th><spring:message code='ezCommunity.t269'/></th>
		                        
		                        <c:choose>
		                        	<c:when test="${boardInfo.gubun != '2' }">
		                        		<td id="Td5" style="padding-right: 15px; white-space: nowrap; width: 100%;"><span>${item.extensionAttribute4}</span></td>
		                        	</c:when>
		                        	
		                        	<c:otherwise>
		                        		<td id="Td6" style="padding-right: 15px; white-space: nowrap; width: 100%;"><span>&nbsp; </span></td>
		                        	</c:otherwise>
		                        </c:choose>
		                        
	                        </tr>
                    	</c:if>

	                    <tr>
	                        <th><spring:message code='ezCommunity.t210'/></th>
	                        <td id="cTitle" colspan="6">
	                            <div id="title" style="WORD-WRAP: break-word; word-break: break-all; OVERFLOW-Y: auto; WIDTH: 100%;">${item.title}</div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <td class="pad1" id="ItemOverflow">
	            
	            	<c:choose>
	            		<c:when test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
	            			<iframe id="message" class="viewbox" src="/ezCommunity/boardItemViewContent.do?type=COMMUNITYCONTENT&docID="${pItemID}" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            		</c:when>
	            		<c:otherwise>
	            			<iframe id="message" class="viewbox" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            		</c:otherwise>
	            	</c:choose>
	                
	            </td>
	        </tr>
	        
	        <c:choose>
	        	<c:when test="${oneLineReplyFlag == '1'}">
	        		<tr>
	        			
	        			<c:choose>
	        				<c:when test="${boardInfo.gubun != '2' }">
	        					<td style="height:20px">
					                <table class="content">
					                    <tr>
					                        <td height="50" colspan="3">
					                            <div align="left" id="onelinereplylist" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white"></div>
					                        </td>
					                    </tr>
					                    <tr>
					                        <th><spring:message code='ezCommunity.t961'/></th>
					                        <td class="pos1">
					                            <input id="onelinereply" style="WIDTH: 100%" type="text" maxlength="100" onkeydown="OneLineReply_onkeydown()"></td>
					                        <td class="pos2"><a class="imgbtn"><span onclick="Save_OneLineReply()">&nbsp&nbsp&nbsp&nbsp<spring:message code='ezCommunity.t958'/>&nbsp&nbsp&nbsp&nbsp</span></a></td>
					                    </tr>
					                </table>
					            </td>
	        				</c:when>
	        				
	        				<c:otherwise>
	        					<td style="height:20px">
					                <table class="content">
					                    <tr>
					                        <td height="50" colspan="5">
					                            <div align="left" id="onelinereplylist" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white"></div>
					                        </td>
					                    </tr>
					                    <tr>
					                        <th><spring:message code='ezCommunity.t961'/></th>
					                        <td class="pos1">
					                            <input id="onelinereply" style="WIDTH: 100%" type="text" maxlength="100" onkeydown="OneLineReply_onkeydown()"></td>
					                        <th><spring:message code='ezCommunity.t1175'/></th>
					                        <td>
					                            <input type="password" id="txtPassWord" style="WIDTH: 80px" maxlength="15"></td>
					                        <td class="pos2"><a class="imgbtn"><span onclick="Save_OneLineReply()">&nbsp&nbsp&nbsp&nbsp<spring:message code='ezCommunity.t958'/>&nbsp&nbsp&nbsp&nbsp</span></a></td>
					                    </tr>
					                </table>
					            </td>
	        				</c:otherwise>
	        			</c:choose>
			            
			        </tr>
			        <tr>
			            <td class="pad1" style="height:20px">
			                <table class="file">
			                    <tr>
			                        <th><spring:message code='ezCommunity.t141'/></th>
			                        <td class="pos1">
			                            <div align="left" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white" id="lstAttachLink"></div>
			                        </td>
			                        
			                        <c:choose>
			                        	<c:when test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
			                        		<td class="pos2"><a class="imgbtn"><span onclick="attach_SelectAll()"><spring:message code='ezCommunity.t962'/></span></a><br><a class="imgbtn"><span onclick="attach_Download()"><spring:message code='ezCommunity.t20'/></span></a> </td>
			                        	</c:when>
			                        	
			                        	<c:otherwise>
			                        		<td class="pos2"><a class="imgbtn"><span onclick="attach_SelectAll()"><spring:message code='ezCommunity.t962'/></span></a><br><a class="imgbtn"><span onclick="attach_Download_Cross()">&nbsp&nbsp&nbsp&nbsp<spring:message code='ezCommunity.t20'/>&nbsp&nbsp&nbsp&nbsp</span></a> </td>
			                        	</c:otherwise>
			                        </c:choose>
			                        
			                        <td id="ItemLevel" style="display: none"></td>
			                    </tr>
			                </table>
			            </td>
			        </tr>
	        	</c:when>
	        	
	        	<c:otherwise>
	        		<tr>
			            <td class="pad1" style="height:20px">
			                <table class="file">
			                    <tr>
			                        <th><spring:message code='ezCommunity.t141'/></th>
			                        <td class="pos1"><div align="left" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white" id="lstAttachLink"></div></td>
			                        
			                        <c:choose>
			                        	<c:when test="${MSIE.indexOf('MSIE') > -1 || Trident.IndexOf('Trident') > -1}">
			                        		<td class="pos2"><a class="imgbtn"><span onclick="attach_SelectAll()"><spring:message code='ezCommunity.t962'/></span></a><br><a class="imgbtn"><span onclick="attach_Download()"><spring:message code='ezCommunity.t20'/></span></a> </td>
			                        	</c:when>
			                        	
			                        	<c:otherwise>
			                        		<td class="pos2"><a class="imgbtn"><span onclick="attach_SelectAll()"><spring:message code='ezCommunity.t962'/></span></a><br><a class="imgbtn"><span onclick="attach_Download_Cross()">&nbsp&nbsp<spring:message code='ezCommunity.t20'/>&nbsp&nbsp</span></a> </td>
			                        	</c:otherwise>
			                        </c:choose>
			                        
			                        <td id="ItemLevel" style="display: none"></td>
			                    </tr>
			                </table>
			            </td>
		        	</tr>
	        	</c:otherwise>
	        </c:choose>

			<c:if test="${adjacentItemsEnableFlag == '1' && showAdjacent == '1'}">
	        
		        <tr>
		            <td style="height:20px">
		                <table class="content">
		                    <tr>
		                        <th><spring:message code='ezCommunity.t190'/></th>
		                        
		                        <c:choose>
		                        	<c:when test="${previousItemID == '' }">
		                        		<td style="width:100%">
		                        	</c:when>
		                        	
		                        	<c:otherwise>
		                        		<td style="width:100%">
		                        	</c:otherwise>
		                        </c:choose>
		                        
		                        	<div style="word-break: break-all; cursor: pointer; MARGIN-TOP: 0px; OVERFLOW: auto; PADDING-TOP: 0px" onclick="OpenItem('${previousItemID}')">${previousTitle}</div>
		                        </td>
		                    </tr>
		                    <tr>
		                        <th><spring:message code='ezCommunity.t192'/></th>
		                        
		                        <td>
		                            <div style="word-break: break-all; cursor: pointer; MARGIN-TOP: 0px; OVERFLOW: auto; PADDING-TOP: 0px; BACKGROUND-COLOR: white" onclick="OpenItem('${nextItemID}')">${nextTitle}</div>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
	        </c:if>
	        
	    </table>
	    
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	</body>
</html>