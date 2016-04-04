<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:100%">
	<head>
		<title><spring:message code='ezBoard.t293' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/common.js"></script>
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/Common.js" ></script>
		<script type="text/javascript" src="/js/NameControl.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script  type="text/javascript">
		    window.onbeforeunload = function () {
		        try {
		            window.opener.document.Script.refresh_onclick2();
		        } catch (e) { }
		    };
		    window.offscreenBuffering = true;
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var pItemID = "${itemID}";
			var pBoardID = "${boardID}";
		    var pBoardName = "${boardInfo.boardName}";
		    var strWriterID = "${boardItem.writerID}";
		    var strWriterName = '${boardItem.writerName}'.replace("\"", "");
		    var strWriterDeptName = "${boardItem.writerDeptName}";
		    var strWriterCompanyName = "${boardItem.writerCompanyName}";
		    var strWriteDate = "${boardItem.writeDate}";
		    var strImportance = "${boardItem.importance}";
		    var strEndDate = "${boardItem.endDate}";
		    var strContentLocation = "${boardItem.contentLocation}";
		    var strAttachList = "${boardItem.attachments}";
		    var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName1}";
		    var Access_FG = "${boardInfo.access_FG}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var ListView_FG = "${boardInfo.listView_FG}";
		    var Read_FG = "${boardInfo.read_FG}";
		    var Write_FG = "${boardInfo.write_FG}";
		    var Reply_FG = "${boardInfo.reply_FG}";
		    var Delete_FG = "${boardInfo.delete_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var pReservedItem = "${pReservedItem}";
		    var g_progresswin;
		    var OneLineReplyFlag = "${boardPropertyVO.oneLineReply}";
			var gubun = "${guBun}";
		    var pUse_Editor = "${useEditor}";
		    var pUse_IE11Browser = "${useIE11Browser}";
			var pNoneActiveX = "YES";
		    //추가항목 유무
		    var pAttributeYN = "${boardInfo.attributeYN}";
		    var AtttributeCount = 0; 
		    window.onload = function () {
		        try {
// 		            initKey();
		
// 		            var fullPath = document.location.protocol + "//" + document.location.hostname + "/ezCommon/ezCommonInterFace.do&type=BOARDCONTENT&docID=" + escape(pItemID);
					var html = "";
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : { type   : "BOARDCONTENT", 
								 itemID 	 : pItemID
							   },
						success: function(result){
							html = result;
						}        			
					});	
		            //document.getElementById('message').src = "/ezCommon/mhtToHTMLContent.do?type=BOARDCONTENT&itemID=" + escape(pItemID);
					var doc = document.getElementById('message').contentWindow.document;
					doc.open();
					doc.write(html);
					doc.close();
					
		            AddLinkTarget();
		            SetAttachmentInfo();
		            
		            //추가항목 창 사이즈 조절
		            var addheight = 0;
		            //아직 추가 안함
// 					addheight = AtttributeCount * 40;
		
		            if (OneLineReplyFlag == "1") {
		                getOneLineReply();
		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    self.resizeTo(765, (768 + addheight));
		                else
		                    self.resizeTo(765, (795 + addheight));
		            }
		            else {
		                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1)
		                    self.resizeTo(765, (690 + addheight));
		                else
		                    self.resizeTo(775, (715 + addheight));
		            }
		
		            var Div = document.createElement("DIV");
		            var Span = document.createElement("SPAN");
		            if ("${useOcs}" == "YES" && gubun != 2) {
		                var pSIPUriList = getSIPUri(strWriterID + ";", "").split(';');
		             
		                var Img = document.createElement("IMG");            
		                Img.style.verticalAlign = "middle";
		                Img.src = "/images/Presence/unknown.gif";
		                Img.type = "smtp";
		                Img.onload = "PresenceControl(\"" + pSIPUriList[0] + "\", this)";
		                Img.id = GetGUID();
		                Div.appendChild(Img);
		                var Span = document.createElement("SPAN");
		                Span.style.verticalAlign = "middle";
		                Span.style.cursor = "pointer";
		                Span.setAttribute("onclick", "OpenUserInfo('" + strWriterID + "')");
		                Span.innerText = strWriterName;
		                Div.appendChild(Span);
		                document.getElementById("WriteUserNM").innerHTML = Div.outerHTML;     
		                pSIPUriList = null;
		            }
		            else {
		                Span = document.createElement("SPAN");
		                Span.style.verticalAlign = "middle";
		                Span.style.cursor = "pointer";
		                Span.setAttribute("onclick", "OpenUserInfo('" + strWriterID + "')");
		                Span.innerText = strWriterName;
		                Div.appendChild(Span);
		                document.getElementById("WriteUserNM").innerHTML = Div.outerHTML;
		            }
		            if (g_progresswin) g_progresswin.close();
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    };
		
		    window.onresize = function ()
		    {        
	        	if (gubun != "3") { 
		        	if (OneLineReplyFlag == "1") { 
			            if (pAttributeYN == "Y") {
			                document.getElementById("message").style.height = document.documentElement.clientHeight - 450 + "PX";
			                document.getElementById("pad1").style.height = document.documentElement.clientHeight - 450 + "PX";
			            } else {
			                document.getElementById("message").style.height = document.documentElement.clientHeight - 320 + "PX";
			                document.getElementById("pad1").style.height = document.documentElement.clientHeight - 320 + "PX";
			            }
			            } else { 
			            if (pAttributeYN == "Y") {
			                document.getElementById("message").style.height = document.documentElement.clientHeight - 260 + "PX";
			                document.getElementById("pad1").style.height = document.documentElement.clientHeight - 260 + "PX";
			            }
			            else {
			                document.getElementById("message").style.height = document.documentElement.clientHeight - 240 + "PX";
			                document.getElementById("pad1").style.height = document.documentElement.clientHeight - 240 + "PX";
			            }
		         	}
	        	}
		    };
		
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
		        var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl + "&Cnt=" + cnt;
		        return link;
		    }
		    function CheckIfHasReplies() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + pItemID + ",;", false);
		        xmlhttp.send();
		        if (xmlhttp.responseText == "FALSE") {
		            xmlhttp = null;
		            return false;
		        }
		        xmlhttp = null;
		        return true;
		    }
		    var checkpassword_dialogArguments = new Array();
		    function btn_Delete_Onclick() {
		        if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezBoard.t196' />");
		            return;
		        }
		
		        if (Delete_FG != "true") {
		            alert("<spring:message code='ezBoard.t265' />");
		            return;
		        }
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
		            if (gubun == "2") {
		                if (CrossYN()) {
		                    checkpassword_dialogArguments[1] = btn_Delete_Onclick_Complete;
		                    var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + pItemID, "CheckPassWord", GetOpenWindowfeature(340, 200));
		                    try { OpenWin.focus(); } catch (e) { }
		                } else {
		                    var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
		                    feature = feature + GetShowModalPosition(330, 200);
		                    var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + pItemID, "", "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no");
		                    if (typeof (ret) == "undefined") {
		                        alert("<spring:message code='ezBoard.t265' />");
		                        return;
		                    }
		
		                    if (ret != "OK") {
		                        alert("<spring:message code='ezBoard.t265' />");
		                        return;
		                    }
		
		                    if (!confirm("<spring:message code='ezBoard.t197' />")) return;
		                    var xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + pItemID + ";", false);
		                    xmlhttp.send();
		
		                    if (xmlhttp.responseText == "NO") {
		                        alert("<spring:message code='ezBoard.t265' />");
		                        return;
		                    }
		
		                    xmlhttp = null;
		                    try {
		                        window.opener.refresh_onclick();
		                    } catch (e) {
		                    }
		                    window.close();
		                }
		            }
		            else {
		                alert("<spring:message code='ezBoard.t265' />");
		                return;
		            }
		
		        }
		        else {
		            if (BoardAdmin_FG == "true" || gubun != "2") {
		                if (!confirm("<spring:message code='ezBoard.t197' />")) return;
		                var xmlhttp = createXMLHttpRequest();
		                xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + pItemID + ";", false);
		                xmlhttp.send();
		
		                if (xmlhttp.responseText == "NO") {
		                    alert("<spring:message code='ezBoard.t265' />");
		                    return;
		                }
		
		                xmlhttp = null;
		                try {
		                    window.opener.refresh_onclick();
		                } catch (e) {
		                }
		                window.close();
		            }
		        }
		    }
		    function btn_Delete_Onclick_Complete(ret) {
		        if (ret == "cancel") {
		            alert("<spring:message code='ezBoard.t999022' />");
		            return;
		        }
		
		        if (ret != "OK") {
		            alert("<spring:message code='ezBoard.t265' />");
		            return;
		        }
		
		        if (!confirm("<spring:message code='ezBoard.t197' />")) return;
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?boardID=" + pBoardID + "&itemList=" + pItemID + ";", false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265' />");
		            return;
		        }
		
		        xmlhttp = null;
		        try {
		            window.opener.refresh_onclick();
		        } catch (e) {
		        }
		        window.close();
		    }
		    function btn_Reply_Onclick() {
		        if (Reply_FG != "true") {
		            alert("<spring:message code='ezBoard.t303' />");
		            return;
		        }
// 		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.location.href = "/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply";
// 		        }
// 		        else {
// 		            if (pUse_IE11Browser == "CK") {
// 		                window.location.href = "NewBoardItem_Cross.aspx?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply";
// 		            }
// 		            else {
// 		                if(pUse_Editor == "")
// 		                    window.location.href = "NewBoardItem.aspx?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply";
// 		                else
// 		                    window.location.href = "NewBoardItem_IE.aspx?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply";
// 		            }
// 		        }
		        window.resizeTo(785, 780);
		    }
		    function btn_Modify_Onclick() {
		        if (Write_FG != "true" && gubun != "2") {
		            alert("<spring:message code='ezBoard.t304' />");
		            return;
		        }
		        if (strWriterID != SSUserID && gubun != "2" && BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
		            alert("<spring:message code='ezBoard.t304' />");
		            return;
		        }
		        //익명게시판
		        if (gubun == "2") {
		            if (CrossYN()) {
		                checkpassword_dialogArguments = new Array();
		                checkpassword_dialogArguments[1] = btn_Modify_Onclick_Complete;
		                var OpenWin = window.open("/ezBoard/checkPassWord.do?itemID=" + pItemID, "CheckPassWord", GetOpenWindowfeature(340, 200));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
		                feature = feature + GetShowModalPosition(330, 200);
		                var ret = window.showModalDialog("/ezBoard/checkPassWord.do?itemID=" + pItemID, "", "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no");
		                if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		                if (ret == "NO") {
		                    alert("<spring:message code='ezBoard.t267' />");
		                    return;
		                }
		
// 		                if (CrossYN() || pNoneActiveX == "YES") {
		                    window.location.href = "/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;
// 		                }
// 		                else {
// 		                    if (pUse_IE11Browser == "CK") {
// 		                        window.location.href = "NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                    }
// 		                    else {
// 		                        if (pUse_Editor == "")
// 		                            window.location.href = "NewBoardItem.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                        else
// 		                            window.location.href = "NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                    }
// 		                }
		                window.resizeTo(785, 780);
		            }
		        }
		        if (gubun != "2") {
// 		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.location.href = "/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;
// 		            }
// 		            else {
		
// 		                if (pUse_IE11Browser == "CK") {
// 		                    window.location.href = "NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                }
// 		                else {
// 		                    if(pUse_Editor == "")
// 		                        window.location.href = "NewBoardItem.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                    else
// 		                        window.location.href = "NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                }
// 		            }
		            window.resizeTo(785, 780);
		        }
		    }
		    function btn_Modify_Onclick_Complete(ret) {
		        if (typeof (ret) == "undefined" || ret == "cancel" || ret == "") return;
		
		        if (ret == "NO") {
		            alert("<spring:message code='ezBoard.t267' />");
		            return;
		        }
		
// 		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.location.href = "/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=" + pReservedItem;
// 		        }
// 		        else {
		
// 		            if (pUse_IE11Browser == "CK") {
// 		                window.location.href = "/myOffice/ezBoardSTD/NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		            }
// 		            else {
// 		                if(pUse_Editor == "")
// 		                    window.location.href = "/myOffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		                else
// 		                    window.location.href = "/myOffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID + "&Mode=modify" + "&ReservedItem=" + pReservedItem;
// 		            }
// 		        }
		        window.resizeTo(785, 780);
		    }
		    function btn_Copy_Onclick() {
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
		            alert("<spring:message code='ezBoard.t202' />");
				    return;
		        }
		
		        if (pAttributeYN == "Y") {
		            alert("<spring:message code='ezBoard.t999071' />");
		            return;
		        }
		
		        var pheigth = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheigth = parseInt(pheigth) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheigth = pheigth - 200;
		        pwidth = pwidth - 127;
		        var feature = "height=656,width=340px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + pheigth + ",left = " + pwidth;
		        feature = feature + GetOpenPosition(340,656);
		        window.open("/ezBoard/copyBoardItem.do?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID, "", feature, "");
		    }
		
		    var moveboarditem_cross_dialogArguments = new Array();
		    function btn_Move_Onclick() {
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
		            alert("<spring:message code='ezBoard.t202' />");
				    return;
		        }
		
		        if (pAttributeYN == "Y") {
		            alert("<spring:message code='ezBoard.t999072' />");
		            return;
		        }
		
		        if (CheckIfHasReplies()) {
		            alert(strLang26);
		            return;
		        }
		
		
		        if (CrossYN()) {
		            moveboarditem_cross_dialogArguments[1] = btn_Move_Onclick_Complete;
		            var OpenWin = window.open("/ezBoard/moveBoardItem.do?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID, "MoveBoardItem", GetOpenWindowfeature(340, 600));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		
		            var pheigth = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            pheigth = parseInt(pheigth) / 2;
		            pwidth = parseInt(pwidth) / 2;
		            pheigth = pheigth - 200;
		            pwidth = pwidth - 127;
		            var ret = window.showModalDialog("/ezBoard/moveBoardItem.do?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID, "", "DialogHeight:656px;DialogWidth:340px;status:no;help:no;edge:sunken;scroll:no");
		            if (typeof (ret) != "undefined") {
		                if (ret == "OK") {
		                    window.opener.location.reload();
		                    window.close();
		                }
		            }
		        }
		    }
		    function btn_Move_Onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            if (ret == "OK") {
		                window.opener.location.reload();
		                window.close();
		            }
		        }
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    function SetAttachmentInfo() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + pItemID, false);
		        xmlhttp.send();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        var i = 0;
		        var pos = 0;
		        var filename = "";
		        var filepath = "";
		        var strAttach = "";
		        var fileImage = "";
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        var regData = GetbrowserLanguage();
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
		            filename = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
		            var strTarget = "target=''";
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
		
		            strAttach = strAttach + "<input type='checkbox' name='fileSelect' value='" + filename + "' >";
		            
		            strAttach = strAttach + "<img src='" + fileImage + "'> <a href='/ezBoard/boardAttachDown.do?filePath="+ filepath +"&fileName="+ filename +"'\">";
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
		        checks = lstAttachLink.getElementsByTagName("input");
		        downloadAll(checks);
		    }
		
		    var suffix = 0;
		    function downloadAll(checks) {
		        if (checks.item(suffix)) {
		            if (checks.item(suffix).checked) {
		                location.href = GetAttribute(checks.item(suffix++), "filehref");
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
		        var feature = "height=490px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
		        feature = feature + GetOpenPosition(420, 490);
		        window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID, "", feature);
		    }
		    function btn_SaveToPC_Onclick() {
		        var fPath;
		        var objMHT = new ActiveXObject("MhtFormat.Convert");
		        var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(strContentLocation);
		        objMHT.sync = true;
		        var strMht = objMHT.DownloadURL(fullPath);
		        if (strMht.length > 200000) {
		            g_progresswin = window.showModelessDialog("show_progress.aspx?fileinfo=" + escape("<spring:message code='ezBoard.t297' />"), "", "dialogWidth=390px; dialogHeight:170px; center:yes; status:no; help:no; edge:sunken;");
				}
		        objMHT.mhtData = strMht;
		        objMHT.filterIn();
		        var objSave = new ActiveXObject("EzUtil.MiscFunc");
		        objSave.UseUTF8 = true;
		        var strFilter;
		        strFilter = objSave.OpenSaveDlg("MHT", "", strTitle.replace("\\", "").replace("/", "").replace(":", "").replace("*", "").replace("?", "")
		                .replace("\"", "").replace("<", "").replace(">", "").replace("|", "")
		                .replace("#", "").replace("!", "").replace(".", ""));
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
				    alert("<spring:message code='ezBoard.t79' />");
		        }
		    }
		    function mail_boarditem() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?boardid=" + pBoardID + "&itemid=" + pItemID + "&cmd=board";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		        window.close();
		    }
		    var item_readlist_cross_dialogArguments = new Array();
		    function ReaderList() {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        var szHref = "/ezBoard/itemReadList.do?boardID=" + pBoardID + "&itemID=" + pItemID;
		        var strFeature = "status:no;dialogHeight: 400px;dialogWidth: 520px;help: no;resizable:yes";
		        if (CrossYN()) {
		            item_readlist_cross_dialogArguments[0] = "";
		            item_readlist_cross_dialogArguments[1] = ReaderList_Complete;
		            DivPopUpShow(520, 400, szHref);
		        }
		        else
		            window.open(szHref, "", "width=520, height=400, resizable=yes, scrollbars=yes, top="+top+", left=" + left);
		    }
		    function ReaderList_Complete() {
		        DivPopUpHidden();
		    }
		    var boarditemview_cross_print_option_dialogArguments = new Array();
		    var url = window.location.href;
		    function btn_Print_Onclick() {
		        if (CrossYN()) {
		            url = window.location.href;
		            url = url.replace(".do", "PrintOption.do");
		            boarditemview_cross_print_option_dialogArguments[1] = btn_Print_Onclick_Complete;
		            var OpenWin = window.open(url, "boarditemview_print_option", GetOpenWindowfeature(380, 200));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var parameter = "";
		            url = window.location.href;
		            url = url.replace(".do", "PrintOption.do");
		            var feature = "status:no;dialogWidth:380px;dialogHeight:200px;help:no;";
		            feature = feature + GetShowModalPosition(380, 200);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		            if (RtnVal[0] != "0" && RtnVal[1] != "0") {
		                url = url.replace("PrintOption.do", "Print.do");
		                url = url + "&oneline=" + RtnVal[0] + "&attach=" + RtnVal[1];
		                window.open(url, "", "top=0, left=0, height=700px, width=840px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1");
		            }
		        }
		    }
		    function btn_Print_Onclick_Complete(RtnVal) {
		        if (RtnVal[0] != "0" && RtnVal[1] != "0") {
		            url = url.replace("PrintOption.do", "Print.do");
		            url = url + "&oneline=" + RtnVal[0] + "&attach=" + RtnVal[1];
		            window.open(url, "", "top=0, left=0, height=700px, width=840px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1");
		        }
		    }
		    function OpenUserInfo(pUserID) {
		        var result = GetOpenWindow("/myoffice/common/ShowPersonInfo.aspx?id=" + pUserID, "UserInfo", 420, 450, "NO");
		    }
		    function OneLineReply_onkeydown() {
		        if (event.keyCode == 13) Save_OneLineReply();
		    }
		    function Save_OneLineReply() {
		        if (Reply_FG != "true") {
		            alert("<spring:message code='ezBoard.t303' />");
				    return;
				}
		        if (OneLineReplyFlag == "1") {
		            if (document.getElementById('onelinereply').value == "") {
		                alert("<spring:message code='ezBoard.t307' />");
				        return;
				    }
		        }
		        if (gubun == "2" && trim(document.getElementById('txtPassWord').value) == "") {
		            alert("<spring:message code='ezBoard.t391' />");
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
				    strXML += "<PASSWORD>" + Crypt_Encrytion(document.getElementById("txtPassWord").value) + "</PASSWORD>";
				}
				strXML += "</DATA>";
				var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "interASP/SaveOneLineReply.aspx", false);
				xmlhttp.send(strXML);
		
				if (xmlhttp.status == 200) {
				    xmlhttp = null;
				    if (OneLineReplyFlag == "1")
				        document.getElementById('onelinereply').value = "";
				    if (gubun == "2")
				        document.getElementById('txtPassWord').value = "";
				    getOneLineReply();
				}
				xmlhttp = null;
		    }
		    var delpReplyID = "";
		    function delete_onelinereply(pReplyID) {
		        delpReplyID = pReplyID;
		        var xmlhttp = createXMLHttpRequest();
		        if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
		            if (gubun == "2") {
		
		                if (CrossYN()) {
		                    checkpassword_dialogArguments = new Array();
		                    checkpassword_dialogArguments[1] = delete_onelinereply_Complete;
		                    var OpenWin = window.open("interASP/CheckPassWord.aspx?ItemID=" + pItemID + "&ReplyID=" + pReplyID, "CheckPassWord", GetOpenWindowfeature(340, 200));
		                    try { OpenWin.focus(); } catch (e) { }
		                }
		                else {
		
		                    var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no";
		                    feature = feature + GetShowModalPosition(330, 200);
		                    var ret = window.showModalDialog("interASP/CheckPassWord.aspx?ItemID=" + pItemID + "&ReplyID=" + pReplyID, "", feature);
		
		                    if (ret == "NO") {
		                        alert("<spring:message code='ezBoard.t267' />");
		                        return;
		                    }
		                    else if (ret == "cancel" || ret == undefined) {
		                        alert(strLang27);
		                        return;
		                    }
		
		                    xmlhttp.open("POST", "interASP/DeleteOneLineReply.aspx?ReplyID=" + pReplyID + "&gubun=" + gubun, false);
		                    xmlhttp.send();
		                    if (xmlhttp.responseText == "FAILFAIL") {
		                        alert("<spring:message code='ezBoard.t310' />");
		                    }
		
		                    getOneLineReply();
		                    xmlhttp = null;
		                }
		            }
		            else {
		                xmlhttp.open("POST", "interASP/CheckOneLineOwner.aspx?ReplyID=" + pReplyID, false);
		                xmlhttp.send();
		                if (xmlhttp.responseText.substr(0, 2) != "OK") {
		                    alert("<spring:message code='ezBoard.t310' />");
		                    return;
		                }
		                if (!confirm("<spring:message code='ezBoard.t311' />")) return;
		            }
		        } else {
		            if (!confirm("<spring:message code='ezBoard.t311' />")) return;
		        }
		        xmlhttp.open("POST", "interASP/DeleteOneLineReply.aspx?ReplyID=" + pReplyID + "&gubun=" + gubun, false);
		        xmlhttp.send();
		        if (xmlhttp.responseText == "FAILFAIL") {
		            alert("<spring:message code='ezBoard.t310' />");
		        }
		        getOneLineReply();
		        xmlhttp = null;
		    }
		    function delete_onelinereply_Complete(ret) {
		        var xmlhttp = createXMLHttpRequest();
		        if (ret == "NO") {
		            alert("<spring:message code='ezBoard.t267' />");
		            return;
		        }
		        else if (ret == "cancel" || ret == undefined) {
		            alert(strLang27);
		            return;
		        }
		
		        xmlhttp.open("POST", "interASP/DeleteOneLineReply.aspx?ReplyID=" + delpReplyID + "&gubun=" + gubun, false);
		        xmlhttp.send();
		        getOneLineReply();
		        xmlhttp = null;
		    }
		    function getOneLineReply() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "interASP/ReadOneLineReply.aspx?BoardID=" + pBoardID + "&ItemID=" + pItemID, false);
		        xmlhttp.send();
		        var xmldom = createXmlDom();
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
		        strHTML = "";
		        var temp;
		        for (var i = 0; i < xmldom.getElementsByTagName("REPLYID").length; i++) {
		            temp = i + 1;
		            if (gubun != "2")
		                strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
		            else
		                strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick=''><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><br>";
		        }
		        if (i == 0)
		            strHTML = "<spring:message code='ezBoard.t312' />";
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
		        if (strItemID != "") window.location.href = window.location.href.replace(pItemID, strItemID);
		    }
		    function Item_View_New(pBoardID, pItemID) {
		        var pheigth = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        pheigth = parseInt(pheigth) / 2;
		        pwidth = parseInt(pwidth) / 2;
		        pheigth = pheigth - 284;
		        pwidth = pwidth - 359;
		        window.open("/myoffice/ezBoardSTD/BoardItemView_Cross.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID, "", "height=700,width=1000, status = no, toolbar=no, menubar=no,scrollbars=1, location=no, resizable=1, top=0, left=0", "");
		    }
		    function ToKMS() {
		        var url = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezKMS/kasset/KAssetConvert.aspx?Mode=new&Flag=board&ItemID=" + pItemID + "&boardid=" + pBoardID + "&url=" + strContentLocation;
		        window.open(url, "KAssetConvert", GetOpenWindowfeature(780, 800));
		    }
		    function trim(parm_str) {
		        if (parm_str == "")
		            return "";
		        else
		            return rtrim(ltrim(parm_str));
		    }
		    function ltrim(parm_str) {
		        var str_temp = parm_str;
		        while (str_temp.length != 0) {
		            if (str_temp.substring(0, 1) == " ") {
		                str_temp = str_temp.substring(1, str_temp.length);
		            }
		            else {
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
		            }
		            else {
		                return str_temp;
		            }
		        }
		        return str_temp;
		    }
		
		    var board_retransoption_dialogArguments = new Array();
		    function btn_Retrans_Onclick() {
		        if (CrossYN()) {
		            board_retransoption_dialogArguments[0] = "";
		            board_retransoption_dialogArguments[1] = btn_Retrans_Onclick_Complete;
		            DivPopUpShow(310, 200, "/ezBoard/boardRetransOption.do");
		
		        }
		        else {
		            var parameter = "";
		            var url = "/ezBoard/boardRetransOption.do";
		            var feature = "status:no;dialogWidth:300px;dialogHeight:200px;help:no;";
		            feature = feature + GetShowModalPosition(300, 200);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		            if (RtnVal != undefined) {
		                switch (RtnVal) {
		                    case "boardContent":
		                        Retrans_boardContent();
		                        break;
		                    case "boardAttach":
		                        Retrans_boardAttach();
		                        break;
		                    case "mailContent":
		                        Retrans_mailContent();
		                        break;
		                    case "mailAttach":
		                        Retrans_mailAttach();
		                        break;
		                    default:
		                }
		            }
		        }
		    }
		    function btn_Retrans_Onclick_Complete(RtnVal) {
		        DivPopUpHidden();
		
		        if (RtnVal != undefined) {
		            switch (RtnVal) {
		                case "boardContent":
		                    Retrans_boardContent();
		                    break;
		                case "boardAttach":
		                    Retrans_boardAttach();
		                    break;
		                case "mailContent":
		                    Retrans_mailContent();
		                    break;
		                case "mailAttach":
		                    Retrans_mailAttach();
		                    break;
		                default:
		            }
		        }
		    }
		    function Retrans_boardContent() {
		        var feature = GetOpenWindowfeature(765, 820);
// 		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&mode=boardContent&itemID=" + pItemID, "", feature, "");
// 		        }
// 		        else {
// 		            if (pUse_IE11Browser == "CK") {
// 		                window.open("NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&Mode=boardContent&ItemID=" + pItemID, "", feature, "");
// 		            }
// 		            else {
// 		                if(pUse_Editor == "")
// 		                    window.open("NewBoardItem.aspx?BoardID=" + pBoardID + "&Mode=boardContent&ItemID=" + pItemID, "", feature, "");
// 		                else
// 		                    window.open("NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mode=boardContent&ItemID=" + pItemID, "", feature, "");
// 		            }
// 		        }
		    }
		    function Retrans_boardAttach() {
		        var feature = GetOpenWindowfeature(765, 820);
// 		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/ezBoard/newBoardItem.do?boardID=" + pBoardID + "&mode=boardAttach&itemID=" + pItemID, "", feature, "");
// 		        }
// 		        else {
// 		            if (pUse_IE11Browser == "CK") {
// 		                window.open("NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&Mode=boardAttach&ItemID=" + pItemID, "", feature, "");
// 		            }
// 		            else {
// 		                if(pUse_Editor == "")
// 		                    window.open("NewBoardItem.aspx?BoardID=" + pBoardID + "&Mode=boardAttach&ItemID=" + pItemID, "", feature, "");
// 		                else
// 		                    window.open("NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mode=boardAttach&ItemID=" + pItemID, "", feature, "");
// 		            }
// 		        }
		    }
		    function Retrans_mailContent() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?boardid=" + pBoardID + "&itemid=" + pItemID + "&cmd=board";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }
		    function Retrans_mailAttach() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var szUrl = "/myoffice/ezEmail/mail_write_Cross.aspx?boardid=" + pBoardID + "&itemid=" + pItemID + "&cmd=board&RetransType=boardAttach";
		        window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
		    }
		    function Appr_onclick(pFlag) {
		        if (pFlag == "C") {
		            var OpenWin = window.open("/myoffice/ezBoardSTD/admin/BoardApprOpinion.aspx?ItemList=" + pItemID + ";&Mode=" + pFlag, "BoardApprOpinion", GetOpenWindowfeature(540, 300));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var xmlhttp = createXMLHttpRequest();
		            xmlhttp.open("POST", "interASP/ApprBoardItem.aspx?ItemList=" + pItemID + ";&Mode=" + pFlag, false);
		            xmlhttp.send();
		
		            if (xmlhttp.responseText == "OK") {
		                if (pFlag == "Y")
		                    alert("<spring:message code='ezBoard.t999002' />");
		                else
		                    alert("<spring:message code='ezBoard.t999009' />");
		            }
		
		            try {
		                window.opener.refresh_onclick();
		            } catch (e) {
		            }
		            window.close();
		        }
		    }
		    function refresh_onclick() {
		        try {
		            window.opener.refresh_onclick();
		        } catch (e) {
		        }
		        window.close();
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden; height:98%;">
	<table class="layout" style="height:100%">
	  <tr>
	    <td style="vertical-align: top; height: 20px;">
	      <div id="menu">
	        <ul>
	        	<c:choose>
	        		<c:when test="${boardID == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
	        			<c:if test="${guBun != '3'}">
		        			<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
	        			</c:if>
	        		</c:when>
	        		<c:when test="${pReservedItem == 'true'}">
	        			<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
	                    <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
	        		</c:when>
	        		<c:when test="${apprFlag == 'N'}">
	        			<li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005' /></span></li>
	                    <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014' /></span></li>
	                    	<c:if test="${boardItem.writerID == userInfo.id}">
		                        <li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		                        <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
	                    	</c:if>
	        		</c:when>
	        		<c:when test="${apprFlag == 'C'}">
	        			<li><span onClick="btn_Modify_Onclick()"><spring:message code='ezBoard.t999021' /></span></li>
	        		</c:when>
	        		<c:when test="${apprFlag == 'W'}">
	        			<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
	                    <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
	        		</c:when>
	        		<c:otherwise>
	        			<c:choose>
		        			<c:when test="${guBun == '2'}">
		        				<c:choose>
			        				<c:when test="${guBun != '3'}">
			        					<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
			        				</c:when>
		        				</c:choose>
		        				<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		                        <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
		                        <c:if test="${guBun != '3'}">
		                        	<li ID='btn_Move' ><span onclick='mail_boarditem()' ><spring:message code='ezBoard.t317' /></span></li>
		                        	<li ID='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezBoard.t318' /></span></li>
		                        </c:if>
		        			</c:when>
		        			<c:when test="${boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK'}">
		        				<c:if test="${guBun != '3'}">
		        					<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
		        				</c:if>
		        				<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		                        <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
		                        <c:if test="${guBun != '3'}">
		                        	<c:if test="${guBun != '2'}">
				                        <li ID='btn_Move'><span onclick='btn_Copy_Onclick()' ><spring:message code='ezBoard.t274' /></span></li>
							            <%--게시물이동추가--%>
							            <li><span onClick="btn_Move_Onclick()"><spring:message code='ezBoard.t134' /></span></li>
		                        	</c:if>
		                      		<li ID='btn_Move' ><span onclick='mail_boarditem()' ><spring:message code='ezBoard.t317' /></span></li>
		                    	</c:if>
		                    	<c:if test="${guBun != '2'}">
		                        	<li ID='btn_Move'><span onclick='ReaderList()' ><spring:message code='ezBoard.t320' /></span></li>
		                    	</c:if>
		                    	<c:if test="${guBun != '3'}">
		                        	<li ID='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezBoard.t318' /></span></li>
		                        </c:if>
		        			</c:when>
		        			<c:otherwise>
		        				<c:if test="${guBun != '3'}">
			                        <li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
			                        <li ID='btn_Move' style="display:none;"><span onclick='mail_boarditem()' ><spring:message code='ezBoard.t317' /></span></li>
			                        <li ID='btn_Move' style="display:none;"><span onclick='ReaderList()' ><spring:message code='ezBoard.t320' /></span></li>
			                        <li ID='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezBoard.t318' /></span></li>
			                    </c:if>
		        			</c:otherwise>
	        			</c:choose>
	        		</c:otherwise>
	        	</c:choose>
	        	<c:if test="${useEzKMS == 'YES' && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
	        		<c:if test="${boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK'}">
	        			<li  ID='btn_KMS' style="display:none;"><span onclick='ToKMS()'>KMS <spring:message code='ezBoard.t321' /></span></li>
	        		</c:if>
	        	</c:if>
	        	<c:if test="${(boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
	        		<li ID='Retrans'><span onclick='btn_Retrans_Onclick()'><spring:message code='ezBoard.t10100' /></span></li>
	        	</c:if>
	        </ul>
	      </div>    
	      <div id="close">
	        <ul>
	          <li><span onClick="btnClose_onclick()"><spring:message code='ezBoard.t12' /></span></li>
	        </ul>
	      </div>
	<script type="text/javascript">
		selToggleList(document.getElementById("menu"), "ul", "li", "0");
		selToggleList(document.getElementById("close"), "ul", "li", "0");
	</script>
	    </td>
	    </tr>
	    <tr>
	    <c:choose>
			<c:when test="${guBun != '3'}">
				<td style="vertical-align: top; height: 80px;">
				<table class="content2" style="width:100%;">
					<tr>
					<th><spring:message code='ezBoard.t223' /></th>
					<c:choose>
						<c:when test="${guBun != '2'}">
							<td id="WriteUserNM" style="width:190px; white-space:nowrap"><div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer" onclick='OpenUserInfo("${boardItem.writerID}")'>${boardItem.writerName}</div></td>
						</c:when>
						<c:otherwise>
							<td id="WriteUserNM" style="width:190px; white-space:nowrap"><div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;">${boardItem.writerName}</div></td>
						</c:otherwise>
					</c:choose>
					<th><spring:message code='ezBoard.t224' /></th>
					<td id="PostDate" style="width:120px; white-space:nowrap; padding-right:5px"><div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;">${boardItem.writeDate}</div></td>
					<th><spring:message code='ezBoard.t288' /></th>
					<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
					<c:choose>
						<c:when test="${boardItem.endDate.substring(0,4) == '9999'}">
							<td id="EndDate" style="padding-right:5px; width:120px; white-space:nowrap"><div style="vertical-align:middle;width:100px;height:16px;overflow-y:auto;"><spring:message code='ezBoard.t287' /></div></td>
						</c:when>
						<c:otherwise>
							<td id="EndDate" style="padding-right:15px; width:120px; white-space:nowrap"><div style="vertical-align:middle;width:100px;height:16px;overflow-y:auto;">${boardItem.endDate.split(' ')[0]}</div></td>
						</c:otherwise>
					</c:choose>
					</tr>
					<c:choose>
						<c:when test="${guBun != '2'}">
							<tr>
							<th><spring:message code='ezBoard.t322' /></th>
							<c:choose>
								<c:when test="${guBun != '2'}">
									<td id="User_DeptNM" style="width:100px; white-space:nowrap"><span>${boardItem.writerDeptName}</span></td>
								</c:when>
								<c:otherwise>
									<td id="User_DeptNM" style="width:100px; white-space:nowrap"><span>&nbsp;</span> </td>
								</c:otherwise>
							</c:choose>
							<th><spring:message code='ezBoard.t290' /></th>
							<c:choose>
								<c:when test="${guBun != '2'}">
									<td id="User_JobTitle"><span>${boardItem.extensionAttribute3}</span> </td>
								</c:when>
								<c:otherwise>
									<th id="User_JobTitle"><span>&nbsp; </span> </th>
								</c:otherwise>
							</c:choose>
							<th><spring:message code='ezBoard.t38' /></th>
							<c:choose>
								<c:when test="${guBun != '2'}">
									<td id="Telephone"><span>${boardItem.extensionAttribute4} </span> </td>
								</c:when>
								<c:otherwise>
									<td id="Telephone"><span>&nbsp; </span> </td>
								</c:otherwise>
							</c:choose>
							</tr>
						</c:when>
					</c:choose>
		        <tr>
		          <th><spring:message code='ezBoard.t323' /></th>
		             <td width="100%" id="cTitle" style="WORD-WRAP: break-word;word-break:break-all;" colspan=5><div style="overflow-y:auto;WIDTH: 100%; height:16px; vertical-align: middle">${boardItem.title}</div></td>
		        </tr>
		      </table>
		    </td>
		    </c:when>
		    <c:otherwise>
			    <td style="vertical-align: top; height: 80px;">
			        <table style="width:100%" class="content">
			        <tr>
			          <th><spring:message code='ezBoard.t223' /></th>
			          <td id="WriteUserNM" style="white-space:nowrap; width:100%;"><div style="OVERFLOW-Y:auto;WIDTH:100%;cursor:pointer;HEIGHT:16px; vertical-align:middle;" onclick='OpenUserInfo("${boardItem.writerID}")'>${boardItem.writerName}</div>
			          <th><spring:message code='ezBoard.t289' /></th>
			          <td id="User_DeptNM" style="padding-right:10px; white-space:nowrap; width:100px;">${boardItem.writerDeptName}</td>
			          <th><spring:message code='ezBoard.t290' /></th>
			          <td id="User_JobTitle" style="padding-right:10px; white-space:nowrap; width:100px;">${boardItem.extensionAttribute3}</td>
			        </tr>
			        <tr>
			          <th><spring:message code='ezBoard.t291' /></th>
			          <td style="width:100%;" id="cTitle" colSpan="5"><div id="title" style="OVERFLOW-Y: auto; PADDING-LEFT: 5px; WIDTH: 100%; HEIGHT: 16px; vertical-align:middle;">${boardItem.title}</div></td>
			        </tr>
			      </table>
			    </td>
		    </c:otherwise>
	  </c:choose>
	  </tr>
	  <tr>
	  <c:choose>
		  <c:when test="${guBun != '3'}">
		    <td class="pad1" id="pad1" style="vertical-align: top; height:460px;">
		        <iframe id="message" class="viewbox" name="message" style="padding:0; width:100%; height:460px; overflow:auto;"></iframe>
		    </td>
		  </c:when>
		  <c:otherwise>
		    <td class="pad1" style="vertical-align: top;">
<%-- 		      <div class="viewbox"><img src='<%=g_ImageUrl%>' border=0 width='<%=g_Width%>' height ='<%=g_Height%>' name=zb_target_resize style='cursor:pointer'  onclick=window.open(this.src,"_blank","","false") > --%>
		        <div id="ItemOverflow">
		           <iframe id="message" name="message"  style="padding: 0;width:100%; overflow:auto;"></iframe>
		        </div>
<!-- 		      </div> -->
		    </td>
		  </c:otherwise>
	  </c:choose>
	  </tr>
	  <c:choose>
		  <c:when test="${boardPropertyVO.oneLineReply == '1'}">
			  <tr>
			  <c:choose>
			      <c:when test="${guBun != '2'}">
				    <td style="vertical-align: top;">
				        <table class="content">
				        <tr>
				          <td style="height:50px;" colspan="3"><div id="onelinereplylist" style="OVERFLOW: auto; HEIGHT: 51px; background-color:white; text-align:left"></div></td>
				        </tr>
				        <tr>
				          <th><spring:message code='ezBoard.t324' /></th>
				          <td class="pos1"><input id="onelinereply" style="WIDTH: 99%" type="text" maxLength="100" onKeyDown="OneLineReply_onkeydown()"></td>
				          <td class="pos2"><a class="imgbtn"><span onClick="Save_OneLineReply()"><spring:message code='ezBoard.t321' /></span></a></td>
				        </tr>
				      </table>
				    </td>
			  	</c:when>
			    <c:otherwise><!-- 2011.04.13 익명게시판의 경우 한줄답변 등록시 password 추가  -->
			        <td style="vertical-align: top; height:10%;">
			            <table class="content">
			            <tr>
			              <td style="height:50px" colspan="5">
			                  <div id="onelinereplylist" style="OVERFLOW: auto; HEIGHT: 51px; background-color:white; text-align:left"></div>
			              </td>
			            </tr>
			            <tr>
			              <th><spring:message code='ezBoard.t324' /></th>
			              <td class="pos1"><input id="onelinereply" style="WIDTH: 99%" type="text" maxLength="100" onKeyDown="OneLineReply_onkeydown()"></td>
			              <th><spring:message code='ezBoard.t438' /></th>
			              <td><INPUT type="password" id="txtPassWord" style="WIDTH:80px" maxlength="15"></td>
			              <td class="pos2"><a class="imgbtn"><span onClick="Save_OneLineReply()"><spring:message code='ezBoard.t321' /></span></a></td>
			            </tr>
			          </table>
			        </td>
			    </c:otherwise>
		    </c:choose>
		  </tr>
		  <tr>
		  <c:choose>
			  <c:when test="${guBun != '3'}">
			    <td class="pad1" style="vertical-align: top;">
			        <table class="file">
			        <tr>
			          <th><spring:message code='ezBoard.t292' /></th>
			            <td>
			            	<div style="text-align:left; OVERFLOW: auto; HEIGHT: 50px; background-color:white" id="lstAttachLink" ></div>
			            </td>
			        <td class="pos2">
			        <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
			        <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a> 
			        </td>
			        <td id="ItemLevel" style="display:none"></td>
			        </tr>
			      </table>
			    </td>
			  </c:when>
			  <c:otherwise>
			    <td class="pad1" style="vertical-align: top; DISPLAY:none;">
			        <table class="file">
			        <tr>
			          <th><spring:message code='ezBoard.t292' /></th>
			          <td class="pos2">
			          	  <div style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left" id="lstAttachLink"></div>
			          </td>
			          <td class="pos2">
			              <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
			              <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
			          </td>
			          <td id="Td1"></td>
			        </tr>
			      </table>
			    </td>
			  </c:otherwise>
		  </c:choose>
		  </tr>
		  </c:when>
		  <c:otherwise>
		  	<c:choose>
			  	<c:when test="${guBun != '3'}">
			 	<tr>
				    <td class="pad1" style="vertical-align: top; ">
				        <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t292' /></th>
		                     <td >
				            <div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;background-color:white; text-align:left"></div>
				          </td>
				          <td class="pos2">
				             <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
				             <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
				          </td>
				          <td id="Td2" style="display:none"></td>
				        </tr>
				      </table>
				    </td>
				</tr>
				</c:when>
				<c:otherwise>
				  <tr style="DISPLAY:none">
				    <td class="pad1" style="vertical-align: top;">
				        <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t292' /></th>
	                      <td class="pos2">
				            <div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left"></div></td>
  				          <td class="pos2">'
				          <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
				          <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
				          </td>
				          <td id="Td3"></td>
				        </tr>
				      </table>
				    </td> 
				  </tr>
				</c:otherwise>
			</c:choose>
		  </c:otherwise>
	  </c:choose>
<%-- 	  <c:when test="${adjacentItemsEnableFlag == '1' && showAdjacent == '1'}"> --%>
<!-- 	  <tr> -->
<!-- 	    <td style="vertical-align: top;"> -->
<!-- 	        <table class="content"> -->
<!-- 	        <tr> -->
<%-- 	          <th><spring:message code='ezBoard.t327' /></th> --%>
<%-- 	          <% if (PreviousItemID == "") { %> --%>
<%-- 	          <td width="100%"><% } else { %> --%>
<%-- 	          <td style="cursor:pointer" width="100%"><% } %> --%>
<%-- 	              <% if(Request.UserAgent.IndexOf("Firefox") > -1 ) { %> --%>
<%-- 	            <div align="left" style="overflow:-moz-scrollbars-vertical; WIDTH: 100%; height:inherit" onClick="OpenItem('<%=PreviousItemID%>')"><%=PreviousTitle%></div></td> --%>
<%-- 	            <%}else{ %> --%>
<%-- 	            <div align="left" style="overflow-y:auto;WIDTH: 100%; height:18px" onClick="OpenItem('<%=PreviousItemID%>')"><%=PreviousTitle%></div></td> --%>
<%-- 	            <%} %> --%>
<!-- 	        </tr> -->
<!-- 	        <tr> -->
<%-- 	          <th><spring:message code='ezBoard.t328' /></th> --%>
<%-- 	          <% if (NextItemID == "") { %> --%>
<%-- 	          <td><% } else { %> --%>
<%-- 	          <td style="cursor:pointer"><% } %> --%>
<%-- 	              <% if(Request.UserAgent.IndexOf("Firefox") > -1 ) { %> --%>
<%-- 	            <div align="left" style="overflow:-moz-scrollbars-vertical;WIDTH: 100%; height:inherit" onClick="OpenItem('<%=NextItemID%>')"><%=NextTitle%></div></td> --%>
<%-- 	            <%}else{ %> --%>
<%-- 	            <div align="left" style="overflow-y:auto;WIDTH: 100%; height:18px" onClick="OpenItem('<%=NextItemID%>')"><%=NextTitle%></div></td> --%>
<%-- 	            <%} %> --%>
<!-- 	        </tr> -->
<!-- 	      </table> -->
<!-- 	    </td> -->
<!-- 	  </tr> -->
<%-- 	  </c:when> --%>
	</table>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>