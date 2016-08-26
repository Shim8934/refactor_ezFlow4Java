<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t175' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>		
		<script type="text/javascript" src="/js/ezCommunity/ErrorHandler.js"></script>
 		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			window.offscreenBuffering = true;
	
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var pItemID = "<c:out value = '${item.itemID}' />";
		    var pBoardID = "<c:out value = '${boardInfo.boardID}' />";
		    var pBoardName = "<c:out value = '${boardInfo.boardName}' />";
		    var strWriterID = "<c:out value = '${item.writerID}' />";
		    var strWriterName = "<c:out value = '${item.writerName}' />";
		    var strWriterDeptName = "<c:out value = '${item.writerDeptName}' />";
		    var strWriterCompanyName = "<c:out value = '${item.writerCompanyName}' />";
		    var strWriteDate = "<c:out value = '${item.writeDate}' />";
		    var strImportance = "<c:out value = '${item.importance}' />";
		    var strEndDate = "<c:out value = '${item.endDate}' />";
		    var strContentLocation = "<c:out value = '${item.contentLocation}' />";
		    var strAttachList = "<c:out value = '${strAttachments}' />";
		    var SSUserID = "<c:out value = '${userInfo.id}' />";
		    var SSUserName = "<c:out value = '${userInfo.displayName1}' />";
		    var Access_FG = "<c:out value = '${boardInfo.access_FG}' />";
		    var BoardAdmin_FG = "<c:out value = '${boardInfo.boardAdmin_FG}' />";
		    var ListView_FG = "<c:out value = '${boardInfo.listView_FG}' />";
		    var Read_FG = "<c:out value = '${boardInfo.read_FG}' />";
		    var Write_FG = "<c:out value = '${boardInfo.write_FG}' />";
		    var Reply_FG = "<c:out value = '${boardInfo.reply_FG}' />";
		    var Delete_FG = "<c:out value = '${boardInfo.delete_FG}' />";
		    var BoardGroupAdmin_FG = "<c:out value = '${boardInfo.boardGroupAdmin_FG}' />";
		    var pReservedItem = "<c:out value = '${pReservedItem}' />";
		    var g_progresswin;
		    var OneLineReplyFlag = "<c:out value = '${ oneLineReplyFlag }' />";
		    var gubun = "<c:out value = '${boardInfo.gubun }' />";
		    var lang = "<c:out value = '${ strUserLang }' />";
		    var pUse_Editor = "<c:out value = '${ userEditor}' />";
		    
		    window.onload = function () {
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
				
				var doc = document.getElementById("message").contentWindow.document;
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
	
		    function AddLinkTarget() {
		        try {
		            var objTags = txtContent.all.tags("a");
	
		            for (var i = 0 ; i < objTags.length ; i++) {
		                if (objTags.item(i).href.indexOf("javascript:") == -1) {
		                	objTags.item(i).target = "_blink";
		                }
		            }
		        } catch (e) { }
		    }
	
	
		    function ExtractBetweenPattern(orgStr, firstPattern, lastPattern) {
		        var sIndex, eIndex;
		        var copyStr = new String(orgStr);
		        var retStr = "", subStr;
	
		        var regFExp = new RegExp(firstPattern, "i");
		        var regEExp = new RegExp(lastPattern, "i");
	
		        var loop = 0;
	
		        sIndex = copyStr.search(regFExp);
		        if (sIndex == -1) {
		            return orgStr;
		        }
	
		        copyStr = copyStr.substr(sIndex + firstPattern.length);
	
		        eIndex = copyStr.search(regEExp);
		        if (eIndex == -1) {
		            return copyStr;
		        }
	
		        retStr = copyStr.substr(0, eIndex);
	
		        return retStr;
		    }
	
		    function MhtConvert() {
		        var fullPath = "/ezCommon/downloadAttach.do?filepath=" + encodeURIComponent(strContentLocation);
		        objMHT.sync = true;
		        var strMht = objMHT.DownloadURL(fullPath);
		        
		        if (strMht.length > 200000) {
		            g_progresswin = window.showModelessDialog("show_progress.aspx?fileinfo=" + encodeURIComponent("<spring:message code = 'ezCommunity.t206' />"), "", "dialogWidth=390px; dialogHeight:170px; center:yes; status:no; help:no; edge:sunken;");
		        }
	
		        objMHT.mhtData = strMht;
		        objMHT.filterIn();
	
		        var ret = objMHT.htmlData;
	
		        return ret;
		    }
	
		    function CheckIfHasReplies() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezCommunity/checkIfHasReply.do?itemList=" + pItemID + ",;", false);
		        xmlhttp.send();
		        
		        if (xmlhttp.responseText == "FALSE") {
		            xmlhttp = null;
		            
		            return true;
		        }
		        
		        xmlhttp = null;
		        
		        return false;
		    }
	
		    function btn_Delete_Onclick() {
		        if (CheckIfHasReplies()) {
		            alert("<spring:message code = 'ezCommunity.t425' />");
		            
		            return;
	            }

	            if (Delete_FG != "true") {
	                alert("<spring:message code = 'ezCommunity.t901' />");
	                
	                return;
	            }


	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
	                if (gubun == "2") {
	                    var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
	                    feature = feature + GetShowModalPosition(330, 200);
	                    var ret = window.showModalDialog("/ezCommunity/checkPassword.do?itemID=" + pItemID, "", feature);
	                    
	                    if (typeof (ret) == "undefined") {
	                        alert("<spring:message code = 'ezCommunity.t901' />");
	                        return;
	                    }

	                    if (ret != "OK") {
	                        alert("<spring:message code = 'ezCommunity.t901' />");
	                        return;
	                    }
	                } else {
	                    alert("<spring:message code = 'ezCommunity.t901' />");
	                    return;
	                }
	            }

	            if (!confirm("<spring:message code = 'ezCommunity.t426' />")) {
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
	            if (Reply_FG != "true") {
	                alert("<spring:message code = 'ezCommunity.t938' />");
			        return;
			    }

	            window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply";
	        }

	        function btn_Modify_Onclick() {
	            if (Write_FG != "true" && gubun != "2") {
	                alert("<spring:message code = 'ezCommunity.t939' />");
	                return;
	            }

	            if (strWriterID != SSUserID && gubun != "2" && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
	                alert("<spring:message code = 'ezCommunity.t939' />");
	                return;
	            }

	            if (gubun == "2") {
	                var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
	                feature = feature + GetShowModalPosition(330, 200);
	                var ret = window.showModalDialog("/ezCommunity/checkPassword.do?itemID=" + pItemID, "", feature);

	                if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") {
	                	return;
	                }
	                
	                if (ret == "NO") {
	                    alert("<spring:message code = 'ezCommunity.t921' />");
	                    return;
	                }
	            }

				window.location.href = "/ezCommunity/newBoardItemPhoto.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;
	            
	            
	        }

	        function btn_Copy_Onclick() {
	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
	                alert("<spring:message code = 'ezCommunity.t431' />");
	                return;
	            }

	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 200;
	            pwidth = pwidth - 127;

	            window.open("/ezCommunity/copyBoardItem.dp?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID, "", "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth, "");
	        }

	        function btnClose_onclick() {
	            window.close();
	        }

	        function SetAttachmentInfo() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();

	            xmlhttp.open("POST", "/ezCommunity/getItemAttachments.do?itemID=" + pItemID, false);
	            xmlhttp.send();

	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;

	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;

	            var i = 0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";
	            var strAttach = "";
	            var bUseDext = true;

	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");

	            for (i = 0; i < xmldomNodes.length; i++) {
	                filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
	                filename = filepath.substr(89, filepath.length - 88);
	                filename = ReplaceText(filename, "%2b", "+");
	                filename = ReplaceText(filename, "%3b", ";");

	                filepath = "/upload_community/" + filepath;
	                filesize = SelectSingleNodeValue(xmldomNodes[i], "FileSize");

	                var target = "_blank";
	                var Ext = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();

	                if (Ext == ".xls" || Ext == ".doc" || Ext == ".ppt" || Ext == ".eml" || Ext == ".pdf" || Ext == ".hwp" || Ext == ".ppt" || Ext == ".docx" || Ext == ".pptx" || Ext == ".xlsx" || Ext == ".rtf") {
	                    target = "";
	                }

	                strAttach = strAttach + "<input type='checkbox' name='fileSelect' value='" + filename + "' filehref='/ezCommon/downloadAttach.do?filename=" + encodeURIComponent(filename) + "&filepath=" + encodeURIComponent(filepath) + "'>";
	                strAttach = strAttach + "<img src='/images/email/mail_006.gif'> <a href='/ezCommon/downloadAttach.do?filename=" + encodeURIComponent(filename) + "&filepath=" + encodeURIComponent(filepath) + "' target='" + target + "'>";

	                strAttach = strAttach + filename + "&nbsp;(" + filesize + ")</a><br>";
	            }

	            lstAttachLink.innerHTML = strAttach;
	        }

	        function encodeBase64(p_str) {
	        	alert(1);
	            var objEzUtil = new ActiveXObject("EzUtil.MiscFunc");
	            ret = objEzUtil.EncodeBase64(p_str);
	            objEzUtil = null;
	            return ret;
	        }

	        function attach_SelectAll() {
	            var checks = lstAttachLink.all.tags("input");
	            
	            for (var i = 0; i < checks.length; i++) {
	                checks.item(i).checked = true;
	            }
	        }

	        function attach_Download() {
	            var param = { "href": new Array(), "name": new Array(), "folderpath": new String() };
	            var count = 0;
	            var checks = lstAttachLink.all.tags("input");

	            for (var i = 0; i < checks.length; i++) {
	                if (checks.item(i).checked == true) {
	                    param["href"][count] = checks.item(i).filehref;
	                    param["name"][count] = checks.item(i).value;
	                    count++;
	                }
	            }
	            
	            if (count == 0) {
	                alert("<spring:message code = 'ezCommunity.t184' />");
	                return;
	            }

	            var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	            var folderpath = ezUtil.BrowseFolder();
	            
	            if (folderpath != "") {
	                param["folderpath"] = folderpath;
	                var feature = "dialogWidth:430px; dialogHeight:170px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(430, 170);
	                
	                window.showModalDialog("aspx/attach_download.aspx", param, feature);
	            }
	        }
	
		    function MemberInfo_onclick(pUserID) {
		        var feature = "height=290px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 290);
		        
		        window.open("/myoffice/main/common/get_userInfo.aspx?id=" + pUserID, "", feature);
		    }
	
		    function btn_SaveToPC_Onclick() {
	            var fPath;
	            var objSave = new ActiveXObject("EzUtil.MiscFunc");
	            var strFilter;
	            strFilter = objSave.OpenSaveDlg("MHT files (*.mht)\0*.mht\0HTML files (*.html)\0*.html");

	            if (strFilter != "") {
	                var arryFileNM = strFilter.split(".");

	                var cnt = arryFileNM.length;

	                var FileExtensionNM = arryFileNM[cnt - 1].toLowerCase();

	                if (FileExtensionNM == "mht") {
	                    objSave.SaveTextToFile(strFilter, objMHT.mhtData);
	                } else {
	                    objSave.SaveTextToFile(strFilter, objMHT.htmlData);
	                }
	                
	                alert("<spring:message code = 'ezCommunity.t282' />");
	            }

	        }

	        function Bigger() {
	            if (curFontSize < 4) {
	                curFontSize += 1;
	            }
	            
	            txtContent.style.fontSize = fontSize[curFontSize];
	        }

	        function Smaller() {
	            if (curFontSize > 0) {
	                curFontSize -= 1;
	            }
	            
	            txtContent.style.fontSize = fontSize[curFontSize];
	        }

	        document.onselectstart = function () {
	        }

	        //mail
	        function mail_boarditem() {
	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;
	            var szUrl = "/myoffice/ezEmail/mail_write.aspx?boardid=" + pBoardID + "&itemid=" + pItemID + "&cmd=board";

	            window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
	            window.close();
	        }

	        function ReaderList() {
	            var szHref = "/ezCommunity/itemReadList.do?boardID=" + pBoardID + "&itemID=" + pItemID;
	            var strFeature = "status:no;dialogHeight: 400px;dialogWidth: 520px;help: no;resizable:yes";
	            var feature = "width=520, height=400, resizable=yes, scrollbars=0";
	            feature = feature + GetOpenPosition(520, 400);
	            window.open(szHref, "", feature);
	        }

	        function btn_Print_Onclick() {
	            var url = window.location.href;
	            url = url.replace(".aspx", "_Print.aspx");
	            var feature = "height=700px, width=840px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1";
	            feature = feature + GetOpenPosition(840, 700);
	            window.open(url, "", feature);
	        }

	        function OpenUserInfo(pUserID) {
	            var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", feature);
	        }

	        function OneLineReply_onkeydown() {
	            if (event.keyCode == 13) {
	            	Save_OneLineReply();
	            }
	        }

	        function Save_OneLineReply() {
	            if (Reply_FG != "true") {
	                alert("<spring:message code = 'ezCommunity.t938' />");
			        return;
			    }

	            if (document.getElementById("onelinereply").value == "") {
	                alert("<spring:message code = 'ezCommunity.t942' />");
	                return;
	            }

	            var pReplyID = "";
	            pReplyID = "{" + GetGUID().toUpperCase() + "}";

	            var strXML = "";

	            strXML += "<DATA>";
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	            strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	            strXML += "<REPLYID>" + pReplyID + "</REPLYID>";
	            strXML += "<CONTENT>" + MakeXMLString(document.getElementById("onelinereply").value) + "</CONTENT>";
	            strXML += "<PASSWORD></PASSWORD>";
	            strXML += "</DATA>";

	            $.ajax({
					type : "POST",
					async : false,
					url : "/ezCommunity/saveOneLineReply.do",
					data : { "strXML"	:	strXML, 
						   },
					success: function(){
						alert("<spring:message code='ezCommunity.t943'/>");
						document.getElementById('onelinereply').value = "";
						
						if (gubun == "2") {
							document.getElementById('txtPassWord').value = "";
						}
						    
						getOneLineReply();
					}
	            });
	        }

	        function delete_onelinereply(pReplyID) {
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/checkOneLineOwner.do?replyID=" + pReplyID, false);
	            xmlhttp.send();

	            if (xmlhttp.responseText.substr(0, 2) != "OK") {
	                alert("<spring:message code = 'ezCommunity.t944' />");
	                return;
	            }

	            if (!confirm("<spring:message code = 'ezCommunity.t945' />")) {
	            	return;
	            }

	            xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + pReplyID, false);
	            xmlhttp.send();
	            getOneLineReply();
	            xmlhttp = null;
	        }

	        function getOneLineReply() {
	        	$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezCommunity/readOneLineReply.do",
					data : { boardID	:	pBoardID, 
							 itemID		:	pItemID
						   },
					success: function(result){
						strHTML = "";
		 	            var temp = 0;
		 	            
		 	           $.each(result["oneLineReplyList"], function(idx, item){
		 	            	temp = temp+1;
		 	            	if (gubun != "2") {
		 	            		strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + item.userID + "\")'><font color=blue>" + item.userName + "</font></span>(" + item.writeDate + ")" + " : </font>" + item.content + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + item.replyID + "\")'><br>";
		 	            	} else if (gubun == "2") {
		 	            		strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + item.userName + "</font></span>(" + item.writeDate + ")" + " : </font>" + item.content + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + item.replyID + "\")'><br>";
		 	            	}
		 	           });
		 	           
		 	           if (temp == 0){
		 	        	  strHTML = "<spring:message code='ezCommunity.t946'/>";
		 	           }
		 	                
		 	           try {
		 	               document.getElementById('onelinereplylist').innerHTML = strHTML;
		 	           }
		 	           catch (e) {
		 	           }
					}
				});
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

	        function Item_View_New(pBoardID, pItemID) {
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 284;
	            pwidth = pwidth - 359;

	            if (CrossYN()) {
	                GetOpenWindow("/myoffice/ezBoardSTD/BoardItemView_Cross.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID, "", 700, 1000);
	            }
	            else {
	                window.open("/myoffice/ezBoardSTD/BoardItemView.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID, "", "height=700,width=1000, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
	            }
	        }

	        window.onbeforeunload = function () {
	            try {
	                window.opener.document.Script.refresh_onclick2();
	            } catch (e) { }
	        }
		</script>
		
		

	</head>
	<body class="popup" style ="overflow-x:hidden">
		<table class="layout">
			<tr>
			
		    	<td style="height:20px">
		    		<div id="menu">
			        	<ul>
			        	
					        <c:choose>
					        	<c:when test="${boardInfo.boardID == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}' }">
					        		<li ID='btn_Reply' style="display:none"><span onclick='btn_Reply_Onclick()'><spring:message code = 'ezCommunity.t207' /></span></li>
					          		<li ID='btn_Move' style="display:none"><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code = 'ezCommunity.t20' /></span></li>
					        	</c:when>
					        	
					        	<c:when test="${pReservedItem == 'true' }">
						        	<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code = 'ezCommunity.t6' /></span></li>
									<li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code = 'ezCommunity.t208' /></span></li>
									<li ID='Li1' style="display:none"><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code = 'ezCommunity.t20' /></span></li>
					        	</c:when>
					        	<c:otherwise>
					        		<c:choose>
					        			<c:when test="${boardInfo.gubun == '2' }">
					        				<li ID='Li2' style="display:none"><span onclick='btn_Reply_Onclick()'><spring:message code = 'ezCommunity.t207' /></span></li>
											<li ID='Li3'><span onclick='btn_Modify_Onclick()'><spring:message code = 'ezCommunity.t6' /></span></li>
											<li ID='Li4'><span onclick='btn_Delete_Onclick()'><spring:message code = 'ezCommunity.t208' /></span></li>
											<li ID='Li5' style="display:none"><span onclick='mail_boarditem()'><spring:message code = 'ezCommunity.t950' /></span></li>
											<li ID='Li6' style="display:none"><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code = 'ezCommunity.t20' /></span></li>
											<li ID='btn_Print' style="display:none"><span onclick='btn_Print_Onclick()'><spring:message code = 'ezCommunity.t951' /></span></li>
					        			</c:when>
					        			
					        			<c:when test="${item.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK' }">
					        				<c:choose>
					        					<c:when test="${boardInfo.gubun != '2' }">
					        						<li ID='Li7' style="display:none"><span onclick='btn_Reply_Onclick()'> <spring:message code = 'ezCommunity.t207' /></span></li>
													<li ID='Li8'><span onclick='btn_Modify_Onclick()'><spring:message code = 'ezCommunity.t6' /></span></li>
													<li ID='Li9'><span onclick='btn_Delete_Onclick()'><spring:message code = 'ezCommunity.t208' /></span></li>
													<li ID='Li10' style="display:none"><span onclick='btn_Copy_Onclick()'><spring:message code = 'ezCommunity.t911' /></span></li>
													<li ID='Li11' style="display:none"><span onclick='mail_boarditem()'><spring:message code = 'ezCommunity.t950' /></span></li>
					          						<li ID='Li12' style="display:none"><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code = 'ezCommunity.t20' /></span></li>
					          						<li ID='Li13'><span onclick='ReaderList()'><spring:message code = 'ezCommunity.t952' /></span></li>
					          						<li ID='Li14' style="display:none"><span onclick='btn_Print_Onclick()'> <spring:message code = 'ezCommunity.t951' /></span></li>
					        					</c:when>
					        					
					        					<c:otherwise>
					        						<li ID='Li7' style="display:none"><span onclick='btn_Reply_Onclick()'> <spring:message code = 'ezCommunity.t207' /></span></li>
													<li ID='Li8'><span onclick='btn_Modify_Onclick()'><spring:message code = 'ezCommunity.t6' /></span></li>
													<li ID='Li9'><span onclick='btn_Delete_Onclick()'><spring:message code = 'ezCommunity.t208' /></span></li>
													
													<li ID='Li11' style="display:none"><span onclick='mail_boarditem()'><spring:message code = 'ezCommunity.t950' /></span></li>
					          						<li ID='Li12' style="display:none"><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code = 'ezCommunity.t20' /></span></li>
					          						
					          						<li ID='Li14' style="display:none"><span onclick='btn_Print_Onclick()'> <spring:message code = 'ezCommunity.t951' /></span></li>	
					        					</c:otherwise>
					        				</c:choose>
					        			</c:when>
					        			
					        			<c:otherwise>
											<li ID='Li15' style="display:none"><span onclick='btn_Reply_Onclick()'><spring:message code = 'ezCommunity.t207' /></span></li>
									        <li ID='Li16' style="display:none"><span onclick='mail_boarditem()'><spring:message code = 'ezCommunity.t950' /></span></li>
									        
									        <c:if test="${boardInfo.gubun != 2 }">
									        	<li ID='Li17' style="display:none"><span onclick='btn_SaveToPC_Onclick()'>PC<spring:message code = 'ezCommunity.t20' /></span></li>
									        </c:if>
			
											<li ID='Li18' style="display:none"><span onclick='ReaderList()'> <spring:message code = 'ezCommunity.t952' /></span></li>
									        <li ID='Li19' style="display:none"><span onclick='btn_Print_Onclick()'><spring:message code = 'ezCommunity.t951' /></span></li>
					        			</c:otherwise>
					        		</c:choose>
					        	</c:otherwise>
					        </c:choose>
					    </ul>
					</div>
					
		        	<div id="close">
			        	<ul>
			          		<li><span onClick="btnClose_onclick()"><spring:message code = 'ezCommunity.t21' /></span></li>
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
				        	<th><spring:message code = 'ezCommunity.t138' /></th>
				          	<td id="WriteUserNM" style="white-space:nowrap"><div id = title style="OVERFLOW-Y:auto;WIDTH:%;cursor:pointer;HEIGHT:16px;vertical-align:middle" onclick='OpenUserInfo("${item.writerID}")'><c:out value = '${item.writerName}' /></div></td>
				          	<th><spring:message code = 'ezCommunity.t932' /></th>
				          	<td id="User_DeptNM" style="padding-right:10px;white-space:nowrap"><span><c:out value = '${item.writerDeptName }' /></span></td>
				          	<th><spring:message code = 'ezCommunity.t960' /></th>
				          	<td id="User_JobTitle" style="padding-right:10px;white-space:nowrap;"><span><c:out value = '${item.extensionAttribute3}' /></span></td>
				        </tr>
				        <tr>
				        	<th><spring:message code = 'ezCommunity.t210' /></th>
				          	<td width="100%" id="cTitle" colSpan="5"><div id="Div1" style="OVERFLOW-Y: auto; PADDING-LEFT: 5px; WIDTH: 100%; HEIGHT: 16px; overflow-y:auto;"><c:out value = '${item.title}' /></div></td>
				        </tr>
			    	</table>
			   	</td>
			</tr>
			<tr>
			
			<c:choose>
				<c:when test="${boardInfo.gubun != '3' }">
					<td class="pad1">
				        <iframe id="message" class="margin" name="message" style="padding:0; height:100%; width:100%; overflow:auto;border:0px"></iframe>
				    </td>
				</c:when>
				
				<c:otherwise>
				    <td class="pad1">
				    	<div class="viewbox"><img src='${gImageUrl}' border=0 width='${gWidth }' height ='${gHeight}' name=zb_target_resize style='cursor:pointer' onclick=window.open(this.src,"_blank","","false") >
				        	<iframe id="message" class='margin' name="message" style="padding: 0;width:100%;height:100%;border:0px"></iframe>      
				    	</div>
				    </td>
				</c:otherwise>
			</c:choose>
		    
			</tr>
			
			<c:choose>
				<c:when test="${oneLineReplyFlag == '1' }">
					<tr>
		    			<td style="height:20px">
		    				<table class="content">
		        				<tr>
		          					<td style="height:50px" colspan="3">
		          						<div align="left" id="onelinereplylist" style="MARGIN-TOP:0px;OVERFLOW:auto;PADDING-TOP:0px;HEIGHT:58px;BACKGROUND-COLOR:white"></div>
		          					</td>
		        				</tr>
		        				<tr>
		          					<th><spring:message code = 'ezCommunity.t961' /></th>
		          					<td class="pos1"><input id="onelinereply" style="WIDTH: 100%" type="text" maxLength="100" onKeyDown="OneLineReply_onkeydown()"></td>
		          					<td class="pos2"><a class="imgbtn"><span onClick="Save_OneLineReply()" style="width:40px" ><spring:message code = 'ezCommunity.t958' /></span></a></td>
		        				</tr>
		      				</table>
		      			</td>
		  			</tr>
		  			<tr>
		    			<td style="DISPLAY:none;height:20px" class="pad1">
		    				<table class="file">
		        				<tr>
		          					<th><spring:message code = 'ezCommunity.t141' /></th>
		          					<td class="pos1"><div id="lstAttachLink"></div></td>
		          					<td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code = 'ezCommunity.t962' /></span></a><a class="imgbtn"><span onClick="attach_Download()"><spring:message code = 'ezCommunity.t20' /></span></a> </td>
		          					<td id="ItemLevel"></td>
		        				</tr>
		      				</table>
		      			</td>
		  			</tr>
				</c:when>
				
				<c:otherwise>
					<tr style="DISPLAY:none">
		    			<td style="DISPLAY:none;height:20px" class="pad1">
		    				<table class="file">
		        				<tr>
						        	<th><spring:message code = 'ezCommunity.t141' /></th>
						        	<td class="pos1"><div id="Div2"></div></td>
						        	<td class="pos2"><a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code = 'ezCommunity.t962' /></span></a><a class="imgbtn"><span onClick="attach_Download()"><spring:message code = 'ezCommunity.t20' /></span></a> </td>
						        	<td id="Td1"></td>
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
		          				<th><spring:message code = 'ezCommunity.t192' /></th>
		          				
		          				<c:choose>
		          					<c:when test="${previoutItemID == '' }">
		          						<td style="width:100%">
		          					</c:when>
		          					<c:otherwise>
		          						<td style="cursor:pointer">
		          					</c:otherwise>
		          				</c:choose>
		          				
		          					<div align="left" style="MARGIN-TOP:0px;OVERFLOW:auto;PADDING-TOP:0px;HEIGHT:16px;BACKGROUND-COLOR:white" onClick="OpenItem('${previousItemID}')"><c:out value = '${previousTitle}' /></div>
		          				</td>
		        			</tr>
		        			<tr>
		          				<th><spring:message code = 'ezCommunity.t190' /></th>
		          				
		          				<c:choose>
		          					<c:when test="${nextItemID == '' }">
		          						<td>
		          					</c:when>
		          					
		          					<c:otherwise>
		          						<td style="cursor:pointer">
		          					</c:otherwise>
		          				</c:choose>
		          				
		          					<div align="left" style="MARGIN-TOP:0px;OVERFLOW:auto;PADDING-TOP:0px;HEIGHT:16px;BACKGROUND-COLOR:white" onClick="OpenItem('${nextItemID}')"><c:out value = '${nextTitle }' /></div>
		          				</td>
		        			</tr>
		      			</table>
		      		</td>
		  		</tr>
			</c:if>

		</table>
	</body>
</html>