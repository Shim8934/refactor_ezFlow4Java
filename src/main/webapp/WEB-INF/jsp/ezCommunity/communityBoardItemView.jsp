<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t293' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ErrorHandler.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style type="text/css">
			/* 첨부파일 아이콘 변경 */
			#lstAttachLink img{width: 18px;height: 18px;vertical-align: middle;margin: 0 2px 4px 0;}
		</style>
		<script type="text/javascript">
			window.offscreenBuffering = true;
	        var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
	        var curFontSize = 1;
	        var pItemID = "<c:out value='${itemID}' />";
			var pBoardID = "<c:out value='${boardID}' />";
	        var pBoardName = "<c:out value='${boardInfo.boardName}' />";
	        var strWriterID = "<c:out value='${item.writerID}' />";
	        var strWriterName = "<c:out value='${item.writerName}' />";
	        var strWriterDeptName = "<c:out value='${item.writerDeptName}' />";
	        var strWriterCompanyName = "<c:out value='${item.writerCompanyName}' />";
	        var strWriteDate = "<c:out value='${item.writeDate}' />";
	        var strImportance = "<c:out value='item.importance}' />";
	        var strEndDate = "<c:out value='${item.endDate}' />";
	        var strContentLocation = "<c:out value='${item.contentLocation}' />";
	        var strAttachList = "<c:out value='${item.attachments}' />";
	        var SSUserID = "<c:out value='${userInfo.id}' />";
	        var SSUserName = "<c:out value='${userInfo.displayName1}' />";
	        var Access_FG = "<c:out value='${boardInfo.access_FG}' />";
	        var BoardAdmin_FG = "<c:out value='${boardInfo.boardAdmin_FG}' />";
	        var ListView_FG = "<c:out value='${boardInfo.listView_FG}' />";
	        var Read_FG = "<c:out value='${boardInfo.read_FG}' />";
	        var Write_FG = "<c:out value='${boardInfo.write_FG}' />";
	        var Reply_FG = "<c:out value='${boardInfo.reply_FG}' />";
	        var Delete_FG = "<c:out value='${boardInfo.delete_FG}' />";
	        var BoardGroupAdmin_FG = "<c:out value='${boardInfo.boardGroupAdmin_FG}' />";
	        var pReservedItem = "<c:out value='${pReservedItem}' />";
	        var g_progresswin;
	        var OneLineReplyFlag = "<c:out value='${oneLineReplyFlag}' />";
			var gubun = "<c:out value='${boardInfo.gubun}' />";
	        var userlang = "<c:out value='${userInfo.lang}' />";
	        var cadmin = "<c:out value='${cAdmin}' />";
	        var gcadmin = "<c:out value='${gcAdmin}' />";
	        var code = "<c:out value='${code}' />";
// 	        var ch_CommunityAdmin = "<c:out value='${chCommunityAdmin}' />";
	    	var pUse_Editor = "<c:out value='${useEditor}' />";
	    	var rsa = new RSAKey();
	    	var commentCount = "<c:out value='${commentCount}' />";
	    	//2018-07-13 김보미
	    	var treeCtrl = "<c:out value='${treeCtrl}' />";
	    	
	    	window.onload = function () {
	    		try {
	    			if (pUse_Editor != "HWP") {
	    				var html = "";
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezCommon/mhtToHTMLContent.do",
							data : { type	:	"COMMUNITYCONTENT", 
									 href	:	strContentLocation,
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
						
						/* 2020-01-15 홍승비 - 게시물 본문의 스타일 적용 시점 변경 */
			    		$("#message").contents().find("body").css("word-wrap", "break-word");
			    		//$("#message").contents().find("body").css("font-family", "Gulim, arial, verdana");
						$("#message").contents().find("body").css("font-size", "13px");
						
//	 					if (gubun == "2") {
//	 						$("#messagePad").css("height","460px");
//	 					} else {
//	 						$("#messagePad").contents().find("body").css("height", "430px");
//	 					}
						
		    	        AddLinkTarget();	
		    	    }
	    	        
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
	    	    
	    	    rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
	    	    
	    	    /* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
				if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
					window.opener.parent.applyIsNewIconAll(); // 리스트, 팝업홈 메인에서 읽기창 접근
				}
	    	}
			
	    	/* 2018-08-03 홍승비 - 커뮤니티 게시물(포토게시물 제외) 리사이즈 수정*/
		    window.onresize = function () {
		    	if (pUse_Editor != "HWP") {
		    		if (gubun != "3") { 
			            var contentHeight;
			            if (gubun == "2") {
			                contentHeight = document.documentElement.clientHeight - 261;
			            } else {
			                contentHeight = document.documentElement.clientHeight - 281;
			            }
			            if(contentHeight < 40){
			            	contentHeight = 40;
			            }
			            document.getElementById("messagePad").style.height = contentHeight + "PX";
			            document.getElementById("message").style.height = contentHeight + "PX";
			        }
		    	} else {
		    		var mHeight = document.getElementById("messagePad").clientHeight - 27 + "px";
		    		message.Resize(mHeight);
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
	            var link = "/ezCommon/imgFileRead.do?pUrl=" + pUrl + "&cnt=" + cnt;

	            return link;
	        }

	        var checkpassword_dialogArguments = new Array();
	        function btn_Delete_Onclick() {
	        	if (Delete_FG != "true" && strWriterID != SSUserID && gubun != "2") {
	                alert("<spring:message code='ezCommunity.t901'/>");
				    return;
				}
	        	
	        	if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezCommunity.t425' />");
		            return;
		        }

	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID && Delete_FG != "true") {
	                if (gubun == "2") {
	                	if(CrossYN()) {
	                		checkpassword_dialogArguments[1] = btn_Delete_Onclick_Complete;
	                        var OpenWin = window.open("/ezCommunity/checkPassword.do?itemID=" + encodeURIComponent(pItemID), "CheckPassWord", GetOpenWindowfeature(470, 200));
	                        try {
	                        	OpenWin.focus();
	                        } catch (e) { }
	                	} else {
	                		var feature = "status:no;dialogWidth:470px;dialogHeight:200px;help:no;scroll:no";
		                    feature = feature + GetShowModalPosition(470, 200);
		                    var ret = window.showModalDialog("/ezCommunity/checkPassword.do?itemID=" + encodeURIComponent(pItemID), "", feature);

	                		if (typeof (ret) == "undefined") {
		                        alert("<spring:message code = 'ezCommunity.t901' />");
		                        return;
		                    }

		                    if (ret == "NO") {
		                        alert("<spring:message code = 'ezCommunity.t921' />");
		                        return;
		                    } else if (ret == "cancel") {
		    	                return;
		    	            }
		                    
		                    if (!confirm("<spring:message code='ezCommunity.t426'/>")) {
			            		return;
		                    }
		                    
		                    var xmlhttp = createXMLHttpRequest();
			 			    xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + encodeURIComponent(pItemID) + ";", false);
			 			    xmlhttp.send();
			 			    xmlhttp = null;
			 			    
			 			    try {
								// 게시물 보기창에서 삭제한 경우, 부모창의 카운트 새로고침 추가
								if (window.opener.location.href.indexOf("ezCommunity/boardItemList.do") > -1 || window.opener.location.href.indexOf("ezCommunity/searchBoardItem.do") > -1) {
									var cntDom = window.opener.parent.document.getElementById("itemcnt");
									var code = window.opener.parent.code;
									if (typeof(cntDom) != "undefined" && cntDom != null && typeof(code) != "undefined" && code != null) {
										reloadLeftCount(code, cntDom);
									}
								}
			 			    	window.opener.location.reload(true);
			 			    	
			 			    	/* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
			 					if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
			 						window.opener.parent.applyIsNewIconAll();
			 					}
			 			    	
			 			    } catch (e) {
			 			    }
			 			    
			 			    window.close();
	                	}
	                } else {
	                	alert("<spring:message code='ezCommunity.t901'/>");
	                	return;
	                }
	            } else {
	            	if (!confirm("<spring:message code='ezCommunity.t426'/>")) {
	            		return;
                    }
                    
                    var xmlhttp = createXMLHttpRequest();
	 			    xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + encodeURIComponent(pItemID) + ";", false);
	 			    xmlhttp.send();
	 			    xmlhttp = null;
	 			    
	 			    try {
						if (window.opener.location.href.indexOf("ezCommunity/boardItemList.do") > -1 || window.opener.location.href.indexOf("ezCommunity/searchBoardItem.do") > -1) {
							var cntDom = window.opener.parent.document.getElementById("itemcnt");
							var code = window.opener.parent.code;
							if (typeof(cntDom) != "undefined" && cntDom != null && typeof(code) != "undefined" && code != null) {
								reloadLeftCount(code, cntDom);
							}
						}
	 			    	window.opener.refresh_onclick();
	 			    	
	 			    	/* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
	 					if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
	 						window.opener.parent.applyIsNewIconAll();
	 					}
	 			    } catch (e) {
	 			    }
	 			    
	 			    window.close();
                }
	        }
	        
	        function CheckIfHasReplies() {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("GET", "/ezCommunity/checkIfHasReply.do?itemList=" + encodeURIComponent(pItemID) + ";", false);
				xmlhttp.send();
				
				if (xmlhttp.responseText == "TRUE") {
		            xmlhttp = null;
		            return true;
		        } else {
			        xmlhttp = null;
			        return false;
		        }
			}
	        
	        function btn_Delete_Onclick_Complete(ret) {
	            if (typeof (ret) == "undefined") {
	            	alert("<spring:message code='ezCommunity.t901'/>");
	                return;
	            }

	            if (ret != "OK" && ret == "FALSE") {
                    alert("<spring:message code = 'ezCommunity.t921' />");
                    return;
                } else if (ret == "cancel") {
	            	alert("<spring:message code='ezCommunity.t60'/>");
	                return;
	            }
	            
	            if (CheckIfHasReplies()) {
		            alert("<spring:message code='ezCommunity.t425' />");
		            return;
		        }

	            if (!confirm("<spring:message code='ezCommunity.t426'/>")) { 
	            	return;
	            }

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezCommunity/deleteItem.do?itemList=" + encodeURIComponent(pItemID) + ";", false);
	            xmlhttp.send();
	            xmlhttp = null;
	            try {
	            	window.opener.location.reload(true);
	            	
 			    	/* 2021-11-10 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
 					if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
 						window.opener.parent.applyIsNewIconAll();
 					}
	            } catch (e) {
	            }
	            window.close();
	        }
	        

			function btn_Reply_Onclick() {
			    if (Write_FG != "true") {
			        alert("<spring:message code='ezCommunity.t431'/>");
				    return;
				}

	            if (Reply_FG != "true") {
	                alert("<spring:message code='ezCommunity.t938'/>");
				    return;
				}
	            
                window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=reply"
	        }

	        function btn_Modify_Onclick() {
	            if (Write_FG != "true" && gubun != "2" && strWriterID != SSUserID) {
	                alert("<spring:message code='ezCommunity.t939'/>");
				    return;
				}

	            if (cadmin != "admin" && BoardAdmin_FG != "true") {
	                if (strWriterID != SSUserID && gubun != "2") {
	                    alert("<spring:message code='ezCommunity.t939'/>");
					    return;
					}
	            }

	            if (gubun == "2") {
	            	if (CrossYN()) {
						checkpassword_dialogArguments = new Array();
	                    checkpassword_dialogArguments[1] = btn_Modify_Onclick_Complete;
	                    var OpenWin = window.open("/ezCommunity/checkPassword.do?itemID=" + encodeURIComponent(pItemID), "CheckPassWord", GetOpenWindowfeature(470, 200));
	                    try { OpenWin.focus(); } catch (e) { }
	            	} else {
	 					var feature = "status:no;dialogWidth:470px;dialogHeight:200px;help:no;scroll:no";
	                    feature = feature + GetShowModalPosition(470, 200);
	                    var ret = window.showModalDialog("/ezCommunity/checkPassword.do?itemID=" + encodeURIComponent(pItemID), "", feature);
	                    
	                    if (typeof (ret) == "undefined") {
	                        alert("<spring:message code = 'ezCommunity.t939' />");
	                        return;
	                    }
	                    if (ret != "OK") {
	                        alert("<spring:message code = 'ezCommunity.t939' />");
	                        return;
	                    }

	                    if ("${pModify}" == "ON") {
	                        alert("<spring:message code = 'ezCommunity.t941' />");
	                        return;
	                    }
	                    
	                    window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=" + pReservedItem;

	            	}
	            } else {
	            	if ("${pModify}" == "ON") {
	                	alert("<spring:message code = 'ezCommunity.t941' />");
	                    return;
					}	                 
	                 if (CrossYN()) {
	                     window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=" + pReservedItem;
	                 } else {
                         window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=" + pReservedItem;
	                 }
	            }
	        }
	        
	        function btn_Modify_Onclick_Complete(ret){
	            if (typeof (ret) == "undefined") {
	            	alert("<spring:message code='ezCommunity.t939'/>");
	                return;
	            }
	            
	            if (ret != "OK" && ret == "FALSE") {
                    alert("<spring:message code = 'ezCommunity.t921' />");
                    return;
                } else if (ret == "cancel") {
	            	alert("<spring:message code='ezCommunity.t60'/>");
	                return;
	            }

	            if ("${pModify}" == "ON") {
                    alert("<spring:message code = 'ezCommunity.t941' />");
                    return;
                }

                window.location.href = "/ezCommunity/newBoardItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=modify" + "&reservedItem=" + pReservedItem;	            
	        }

	        function btn_Copy_Onclick() {
	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK" && strWriterID != SSUserID) {
	                alert("<spring:message code='ezCommunity.t431'/>");
				    return;
				}
	            
	            var wWeight = "355";
    			var wHeight = "600";

	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            
	        	var left = (pwidth - wWeight) / 2;
    			var top = (pheigth - wHeight) / 2;
				//2018-07-13 김보미 - 파라메터 추가
// 	            window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + pItemID + ";" + "&boardID=" + pBoardID + "&code=" + code, "", "height=600,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + top + ",left = " + left, "");
	            window.open("/ezCommunity/copyBoardItem.do?itemIDList=" + encodeURIComponent(pItemID) + ";" + "&boardID=" + encodeURIComponent(pBoardID) + "&code=" + code + "&treeCtrl=" + treeCtrl, "", "height=600,width=355px, status = no, toolbar=no, menubar=no, location=no, resizable=0, top=" + top + ",left = " + left, "");
	        }

	        function btnClose_onclick() {
	            window.close();
	        }

	        function SetAttachmentInfo() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();

	            xmlhttp.open("GET", "/ezCommunity/getItemAttachments.do?itemID=" + encodeURIComponent(pItemID), false);
	            xmlhttp.send();

	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;

	            var i = 0;
	            var pos = 0;
	            var filepath = "";
	            var filenameOrg = "";
		        var filenameView = "";
	            var strAttach = "";
	            var fileImage = "";

	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	            var regData = GetbrowserLanguage();

	            for (i = 0; i < xmldomNodes.length; i++) {
	                filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
	                /* 2018-04-30 홍승비 - 커뮤니티 게시판 첨부파일명 특문처리 수정 */
	                filenameOrg = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
		            filenameView = ReplaceText(ReplaceText(ReplaceText(filenameOrg, ">", "&gt;"), "<", "&lt;"), "&", "&amp;");		           
	                filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));
	                var strTarget = "target='_blank'";
	                var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();

	                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
	                    strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
	                    strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
	                    strFileExt == ".xlsx" || strFileExt == ".rtf" || strFileExt == ".mht") {
	                    strTarget = "target=''";
	                }

	                if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
	                    fileImage = "/images/image.svg";
	                else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
	                    fileImage = "/images/doc.svg";
	                else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
	                    fileImage = "/images/xls.svg";
	                else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
	                    fileImage = "/images/ppt.svg";
	                else if (strFileExt.indexOf(".txt") != -1)
	                    fileImage = "/images/txt.svg";
	                else if (strFileExt.indexOf(".zip") != -1)
	                    fileImage = "/images/zip.svg";
	                else if (strFileExt.indexOf(".pdf") != -1)
	                    fileImage = "/images/pdf.svg";
					else if (strFileExt.indexOf(".ecm") != -1)
						fileImage = "/images/ecm.svg";
	                else if (strFileExt.indexOf(".hwp") != -1 || strFileExt.indexOf(".hwpx") != -1)
	                    fileImage = "/images/hwp.svg";
	                else if (strFileExt.indexOf(".mht") != -1)
	                    fileImage = "/images/mht.png";
	                else
	                    fileImage = "/images/etc.svg";

	                var protocol = window.location.protocol;
	                var serverName = window.location.hostname;

	                strAttach = strAttach + "<input type='checkbox' name='fileSelect' value='" + filenameView + "' filepath='"+ filepath +"' filehref=\"/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filenameOrg) + "&filePath=" + encodeURIComponent(filepath)  + "\">";
	                strAttach = strAttach + "<img src='" + fileImage + "'> <a href=/ezCommunity/getCommunityAttachInfo.do?fileName=" + encodeURIComponent(filenameOrg) + "&filePath=" + encodeURIComponent(filepath) + ">";
	                strAttach = strAttach + filenameView + "&nbsp;(" + filesize + ")</a><br>";
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
		        var checks = document.getElementById('lstAttachLink');
		        //downloadAll(checks);
		        AttachAllDownload(checks);
	        }

	        var suffix = 0;
	        function downloadAll(checks) {
	        	checks = checks.getElementsByTagName("input");
	            if (checks.item(suffix)) {
	                if (checks.item(suffix).checked) {
	                    location.href = checks.item(suffix++).getAttribute("filehref");
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

		    /* 2020-01-30 홍승비 - 체크한 파일이 1개 이상인 경우, zip 파일로 다운받는 함수 */
	        function AttachAllDownload(checks) {
	            var checkedFiles = $("#lstAttachLink").find("input:checkbox[name='fileSelect']:checked");
	            var checkedFilesLength = checkedFiles.length;
	            var filePath = ""; // 전체파일경로
	            var filePathTemp = "";
				var fileNames = ""; // 파일이름
				var fileNamesUID = ""; // 파일이름(UID 포함)
				
				if (checkedFilesLength == 1) { // 하나만 저장
					downloadAll(checks);
				}
				else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
					filePath = GetAttribute(checkedFiles.get(0), "filepath");
					filePath = filePath.substr(0, filePath.lastIndexOf("/") + 1);
					
					for (var i = 0; i < checkedFilesLength; i++) {
						filePathTemp = GetAttribute(checkedFiles.get(i), "filepath"); // 각 파일의 풀경로
						fileNames += MakeXMLString(checkedFiles.get(i).value) + ":"; // 각 파일의 이름을 :로 이어붙인 것
						fileNamesUID += MakeXMLString(filePathTemp.substr(filePathTemp.lastIndexOf("/"), filePathTemp.length)) + ":"; // 각 파일의 이름+UID를 :로 이어붙인 것
					}
					
					var $frm = $("<form></form>");
			    	$frm.attr('action', "/ezCommunity/downloadAttachAll.do");
			    	$frm.attr('method', 'post');
			    	$frm.appendTo('body');
			
			    	param1 = $('<input type="hidden" value="' + filePath + '" name="filePath" />');
			    	param2 = $("<input type='hidden' value='" + fileNames + "' name='fileNames' />");
			    	param3 = $("<input type='hidden' value='" + fileNamesUID + "' name='fileNamesUID' />");
			    	
			    	$frm.append(param1).append(param2).append(param3);
			    	$frm.submit();
				}
				else { // 체크된 파일 없음
					return;
				}
	        }
		    
	        function MemberInfo_onclick(pUserID) {
	            var feature = "height=290px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 290);
	            window.open("/myoffice/main/common/get_userinfo.aspx?id=" + pUserID, "", feature);
	        }
	        
	        
	        //이효진
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

                var szUrl = "/ezEmail/mailWrite.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&cmd=Community";

	            window.open(szUrl, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no,resizable=1");
	            window.close();
	        }
		    var item_readlist_cross_dialogArguments = new Array();

		    /* 2018-07-02 홍승비 - 커뮤니티 게시물 조회자 정보 > 겸직부서의 정보로 표출 */
	        function ReaderList() {
// 	        	var szHref = "/ezCommunity/itemReadList.do?boardID=" + pBoardID + "&itemID=" + pItemID;
// 	            GetOpenWindow(szHref, "", 520, 400);
	        	var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 620) / 2;
		        var top = (heigth - 425) / 2;
		        var szHref = "/ezCommunity/itemReadList.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID);
		        var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";
		        if (CrossYN()) {
		            item_readlist_cross_dialogArguments[0] = "";
		            item_readlist_cross_dialogArguments[1] = ReaderList_Complete;
		            DivPopUpShow(620, 425, szHref);
		        }
		        else
		            window.open(szHref, "", "width=620, height=425, resizable=yes, scrollbars=yes, top="+top+", left=" + left);
		    }
		    function ReaderList_Complete() {
		        DivPopUpHidden();
	        }

	        function btn_Print_Onclick() {
	        	var url = window.location.href;
	            url = url.replace(".do", "Print.do");
	            var feature = "height=720px, width=640px, location=0, menubar=0, toolbar=1, resizable=1, scrollbars=1";
	            feature = feature + GetOpenPosition(640, 720);
	            window.open(url, "", feature);
	        }

	        function OpenUserInfo(pUserID, pDeptID) {
	        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", feature);
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
	                strXML += "<CONTENT>" + encodeURIComponent(document.getElementById('onelinereply').value) + "</CONTENT>";
	            else
	                strXML += "<CONTENT></CONTENT>";

	            if (gubun != "2") {
	                strXML += "<PASSWORD></PASSWORD>";
	            }
	            else {
	                strXML += "<PASSWORD>" + rsa.encrypt(document.getElementById('txtPassWord').value) + "</PASSWORD>";
	            }
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

	        var checkreplypassword_dialogArguments = new Array();
	        function delete_onelinereply(pReplyID) {
	            var xmlhttp = createXMLHttpRequest();

	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
	                if (gubun == "2") {
                        checkreplypassword_dialogArguments = new Array();
                        checkreplypassword_dialogArguments[1] = delete_onelinereply_Complete;
                        var OpenWin = window.open("/ezCommunity/checkReplyPassword.do?itemID=" + encodeURIComponent(pItemID) + "&replyID=" + encodeURIComponent(pReplyID), "checkReplyPassword", GetOpenWindowfeature(340, 200));
                        try {
                        	OpenWin.focus();
                        } catch (e) { }
                        
	                } else {
	                    xmlhttp.open("GET", "/ezCommunity/checkOneLineOwner.do?replyID=" + encodeURIComponent(pReplyID), false);
	                    xmlhttp.send();

	                    if (xmlhttp.responseText.substr(0, 2) != "OK") {
	                        alert("<spring:message code='ezCommunity.t944'/>");
				            return;
				        }
	                    
	                    if (!confirm("<spring:message code='ezCommunity.t945'/>")) {
	                    	return;
	                    }

	                    xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + encodeURIComponent(pReplyID) + "&gubun=" + gubun, false);
	                    xmlhttp.send();
	                    getOneLineReply();
	                    xmlhttp = null;
			        }
	            } else {
                    if (!confirm("<spring:message code='ezCommunity.t945'/>")) {
                    	return;
                    }

	                xmlhttp.open("POST", "/ezCommunity/deleteOneLineReply.do?replyID=" + encodeURIComponent(pReplyID) + "&gubun=" + gubun, false);
	                xmlhttp.send();
	                getOneLineReply();
	                xmlhttp = null;
				}
	        }
	        
	        function delete_onelinereply_Complete(ret, pReplyID) {
	            if (ret == "NO") {
	            	alert("<spring:message code='ezCommunity.t921'/>");
	                return;
	            } else if (ret == "cancel") {
	            	alert("<spring:message code='ezCommunity.t60'/>");
	                return;
	            }

	            $.ajax({
					type : "POST",
					async : false,
					url : "/ezCommunity/deleteOneLineReply.do",
					data : { replyID	:	pReplyID, 
							 gubun		:	gubun
					}
	            });
	            
	            getOneLineReply();
	        }

	        // 댓글 작성자 클릭 시 정보 보여주는 부분 필요!
	        function getOneLineReply() {
	        	$.ajax({
					type : "GET",
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

	        function OpenItem(strItemID) {
	            if (strItemID != "") {
	            	window.location.href = window.location.href.replace(encodeURIComponent(pItemID), encodeURIComponent(strItemID));
	            }
	        }

	        function history_list() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 520) / 2;
	            var pLeft = (pwidth - 500) / 2;

	            window.open("/myoffice/ezBoardSTD/BoardHistoryList.aspx?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pBoardID), "", "height=500,width=587, status = no, toolbar=no, menubar=no, scrollbars=1,location=no, resizable=0, top=" + pTop + ", left=" + pLeft, "");
	        }

	        function UpdateUserList() {
	            var pheight = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            var pTop = (pheight - 520) / 2;
	            var pLeft = (pwidth - 400) / 2;

	            var strUrl = "/ezCommunity/updateUserList.do?itemID=" + encodeURIComponent(pItemID) + "&pBoardID=" + encodeURIComponent(pBoardID);
	            var strstate = "status:no;dialogHeight: 390px;dialogWidth: 520px;help: no;resizable:no"

	            window.open(strUrl, "", "width=400, height=400, resizable=yes, scrollbars=yes , top=" + pTop + ", left=" + pLeft, "");
	        }

	        function ToKMS() {
	        	var url = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezKMS/kasset/KAssetConvert_Cross.aspx?Mode=new&Flag=cop&ItemID=" + pItemID + "&boardid=" + pBoardID + "&url=" + strContentLocation + "&clubid=" + SSUserID;
	            var OpenWin = window.open(url, "KAssetConvert_Cross", GetOpenWindowfeature(780, 800));
	            
	            try {
	            	OpenWin.focus();
	            } catch (e) {
	            }
	        }

	        function trim(parm_str) {
	            if (parm_str == "") {
	                return ""
	            } else {
	                return rtrim(ltrim(parm_str));
	            }
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
	        
		 	 //강민수92
		    function btn_One_Line_Reply_Onclick() {
		    	openCommunityBoardComment();
	    		return;
		    }
			function addRelatedCabinet() {
				window.open("/ezCabinet/cabinetAddRelated.do?module=commu", "addRelated", getOpenWindowfeature(480, 505));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
				return feature;
			}
			
	        /* 2021-05-03 홍승비 -  커뮤니티 팝업홈 좌측 전체 게시물 개수 갱신 */
	        function reloadLeftCount(pCode, pCntDom) {
            	$.ajax({
			    	type : "GET",
			    	url : "/ezCommunity/getCommunityBoardItemCnt.do",
			    	async : false,
			    	data : {
			    		code : pCode
			    	},
			    	success : function (result) {
			    		pCntDom.innerText = result;
			    	}
			    });
	        }
	        
	        function Editor_Complete() {
	        	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(strContentLocation);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
	        }
	        
	        function FieldsAvailable(isTrue) {
	        	if (isTrue) {
	        		message.EditMode(0);
	        		message.ShowToolBar(false);
	        		message.ShowRibbon(false);
					message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            window.onresize();
	        	}
	        }
	        
		</script>
	</head>
	<body class = "popup">
		<table class="layout">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81'/>[${commentCount}]</span></li>
	                    	<c:choose>
	                    		<c:when test="${pBoardID == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
	                    			<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
	                    		</c:when>
	                    		
	                    		<c:when test="${pReservedItem == 'true' }">
									<li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
			                        <li id='btn_Delete'><span class="icon16 popup_icon16_delete" onclick='btn_Delete_Onclick()'></span></li>
								</c:when>
								
								<c:otherwise>
									<c:choose>
										<c:when test="${boardInfo.gubun == '2' }">
											<c:if test="${boardInfo.write_FG == 'true'}">
												<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
											</c:if>
					                        <li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
					                        <li id='btn_Delete'><span class="icon16 popup_icon16_delete" onclick='btn_Delete_Onclick()'></span></li>
					                        <li id='btn_Print'><span class="icon16 popup_icon16_print" onclick='btn_Print_Onclick()'></span></li>
					                        <li id='btn_Mail'><span class="icon16 popup_icon16_mail_gray" onclick='mail_boarditem()'></span></li>
										</c:when>
										
										<c:when test="${item.writerID == userInfo.id}">
											<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
					                        <li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
					                        
					                        <c:if test="${boardInfo.gubun != '2' }">
					                        	<li id='btn_Move'><span onclick='btn_Copy_Onclick()'><spring:message code='ezCommunity.t911'/></span></li>
					                        </c:if>
					                        
					                        <c:if test="${boardInfo.gubun != '2' }">
					                        	<li id='btn_ReaderList'><span onclick='ReaderList()'><spring:message code='ezCommunity.t952'/></span></li>
					                        </c:if>
					                        
					                        <li id='btn_Delete'><span class="icon16 popup_icon16_delete" onclick='btn_Delete_Onclick()'></span></li>
					                        <li id='btn_Print'><span class="icon16 popup_icon16_print" onclick='btn_Print_Onclick()'></span></li>
					                        <li id='btn_Mail'><span class="icon16 popup_icon16_mail_gray" onclick='mail_boarditem()'></span></li>
										</c:when>
										
										<c:otherwise>
											<c:if test="${boardInfo.write_FG == 'true'}">
				                        		<li id='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezCommunity.t207'/></span></li>
											</c:if>
				                        	
				                        	<c:if test="${cAdmin == 'admin' || gcAdmin == 'OK' || boardInfo.boardAdmin_FG == 'true' }">
				                        		<li id='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezCommunity.t6'/></span></li>
				                        	</c:if>
					                        
				                        	<li id='btn_ReaderList'><span onclick='ReaderList()'><spring:message code='ezCommunity.t952'/></span></li>
				                        	
				                        	<c:if test="${cAdmin == 'admin' || gcAdmin == 'OK' || boardInfo.boardAdmin_FG == 'true' || boardInfo.delete_FG == 'true'}">
				                        		<li id='btn_Delete'><span class="icon16 popup_icon16_delete" onclick='btn_Delete_Onclick()'></span></li>
				                        	</c:if>
				                        	
					                        <li id='btn_Print'><span class="icon16 popup_icon16_print" onclick='btn_Print_Onclick()'></span></li>
					                        <li id='btn_Mail'><span class="icon16 popup_icon16_mail_gray" onclick='mail_boarditem()'></span></li>
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
							<c:if test="${useCabinet == 'YES'}">
								<li><span onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t125'/></span></li>
							</c:if>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span onclick="btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="height:20px">
	                <table class="content" style="width:100%">
	                    <tr>
	                    	<!-- 작성자 -->
	                        <th style="width:10%"><spring:message code='ezCommunity.t138'/></th>
	                        <c:choose>
	                        	<c:when test="${boardInfo.gubun != '2' }">
	                        		<td id="WriteUserNM" style="white-space: nowrap; width:40%;">
	                        		<%-- 게시글 작성자 클릭 시 겸직정보 표출 --%>
	                            		<div id="Div1" style="vertical-align: middle; overflow-y: auto; cursor: pointer" onclick='OpenUserInfo("${item.writerID}", "${item.writerDeptID}")'><c:out value='${item.writerName}' /></div>
	                            	</td>
	                        	</c:when>
	                        	
	                        	<c:otherwise>
	                        		<td id="Td7" style="white-space: nowrap; width:40%" colspan="3">
	                            		<div id="Div2" style="vertical-align: middle; height: 16px; overflow-y: auto;"><c:out value='${item.writerName}' /></div>
	                            	</td>
	                        	</c:otherwise>
	                        </c:choose>
	                        <!-- 작성자 end -->
							<!-- 부서명 (익명게시판이 아닌 경우에만 표출) -->
	                        <c:if test="${boardInfo.gubun != '2' }">
	                        		<th style="width:10%"><spring:message code='ezCommunity.t959'/></th>
	                        		<td id="Td1" style="white-space: nowrap; width: 40%;"><span><c:out value='${item.writerDeptName}' /></span></td>
	                        </c:if>
	                        <!-- 부서명 end -->
		                </tr>
		                
                       	<c:if test="${boardInfo.gubun != '2' }">
		                    <tr>    
		                        <!-- 직위 -->
		                        <th style="width:10%"><spring:message code='ezCommunity.t960'/></th>
		                        
		                        <c:choose>
		                        	<c:when test="${boardInfo.gubun != '2' }">
		                        		<td id="Td3" style="width:40%"><span><c:out value='${item.extensionAttribute3}' /></span></td>
		                        	</c:when>
		                        	
		                        	<c:otherwise>
		                        		<td id="Td4" style="width:40%"><span>&nbsp; </span></td>
		                        	</c:otherwise>
		                        </c:choose>
		                        <!-- 직위 end -->
		                        <!-- 전화번호 -->
		                        <th style="width:10%"><spring:message code='ezCommunity.t269'/></th>
		                        
		                        <c:choose>
		                        	<c:when test="${boardInfo.gubun != '2' }">
		                        		<td id="Td5" style="padding-right: 15px; white-space: nowrap; width: 40%;"><span><c:out value='${item.extensionAttribute4}' /></span></td>
		                        	</c:when>
		                        	
		                        	<c:otherwise>
		                        		<td id="Td6" style="padding-right: 15px; white-space: nowrap; width: 40%;"><span>&nbsp; </span></td>
		                        	</c:otherwise>
		                        </c:choose>
		                        <!-- 전화번호  end-->
	                        </tr>
                    	</c:if>
		                
	                    <tr>    
	                        <!-- 게시일 -->
	                        <th style="width:10%"><spring:message code='ezCommunity.t209'/></th>
	                        <td id="PostDate" style="padding-right: 15px; white-space: nowrap; width:40%">
	                        	<div id="Div3" style="vertical-align: middle; width: 100%; height: 16px;"><c:out value='${item.writeDate.substring(0, 16)}' /></div>
	                        </td>
	                        <!-- 게시일 end -->
	                        <!-- 게시종료일 -->
	                        <th style="width:10%"><spring:message code='ezCommunity.t931'/></th>
	                        <c:set var="t930"><spring:message code='ezCommunity.t930'/></c:set>
	                        <c:choose>
	                        	<c:when test="${item.endDate == t930}">
	                        		<td id="EndDate" style="padding-right: 15px; white-space: nowrap; width: 40%;">
			                            <div id="Div4" style="vertical-align: middle; width: 100%; height: 16px;"><spring:message code='ezCommunity.t930'/></div>
			                        </td>
	                        	</c:when>
	                        	
	                        	<c:otherwise>
	                        		<td id="Td8" style="padding-right: 15px; white-space: nowrap; width: 40%;">
	                            		<div id="Div5" style="vertical-align: middle; width: 100%; height: 16px; overflow-y: auto;"><c:out value='${item.endDate.split(" ")[0]}' /></div>
	                        		</td>
	                        	</c:otherwise>
	                        </c:choose>
	                        <!-- 게시종료일  end -->
	                    </tr>
	                    
	                    <tr>
	                        <th style="width:10%"><spring:message code='ezCommunity.t210'/></th>
	                        <td id="cTitle" colspan="6">
	                            <div id="title" style="WORD-WRAP: break-word; word-break: break-all; OVERFLOW-Y: auto; WIDTH: 100%;"><c:out value='${item.title}' /></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr> 
		        <c:if test="${useEditor ne 'HWP'}">
		        	<c:choose>
			        	<c:when test="${boardInfo.gubun == '2'}"> 
			            	<td class="pad1" id="messagePad" style="vertical-align:top; height:460px">
			          			<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:100%; overflow:auto; border:1px solid #ddd;"></iframe>
			            	</td>
		            	</c:when>
		            	<c:otherwise>
			           		<td class="pad1" id="messagePad" style="vertical-align:top; height:440px">
			          			<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:100%; overflow:auto; border:1px solid #ddd;"></iframe>
			            	</td>
		            	</c:otherwise>
					</c:choose>
		        </c:if>
		        <c:if test="${useEditor eq 'HWP'}">
		        	<c:choose>
			        	<c:when test="${boardInfo.gubun == '2'}"> 
			            	<td class="pad1" id="messagePad" style="vertical-align:top; height:460px">
			          			<iframe id="message" class="viewbox" src="/ezCommunity/WHWPEditor.do?type=${mode}" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto; border:1px solid #ddd;"></iframe>
			            	</td>
		            	</c:when>
		            	<c:otherwise>
			           		<td class="pad1" id="messagePad" style="vertical-align:top; height:440px">
			          			<iframe id="message" class="viewbox" src="/ezCommunity/WHWPEditor.do?type=${mode}" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto; border:1px solid #ddd;"></iframe>
			            	</td>
		            	</c:otherwise>
					</c:choose>
		        </c:if>
	        </tr>

			<tr>
				<td class="pad1" style="height:20px; vertical-align:top">
			   		<table class="file">
			   			<tr>
			        		<th><spring:message code='ezCommunity.t141'/></th>
			               	<td class="pos1">
			               		<div align="left" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white" id="lstAttachLink"></div>
			              	</td>
		                  	<td class="pos2" style ="white-space:normal;">
		                   		<a class="imgbtn imgbck" style="margin-bottom: 3px;"><span onclick="attach_SelectAll()" style="width:70px;"><spring:message code='ezCommunity.t962'/></span></a>
		                        <br>
		                        <a class="imgbtn imgbck"><span onclick="attach_Download_Cross()" style="width:70px;"><spring:message code='ezCommunity.t20'/></span></a>
		               		</td>
			           	</tr>
			       	</table>
			    </td>
			</tr>
			<%-- 2018-05-04 홍승비 - 일반/익명게시판 다음글, 이전글 테이블 삭제 --%>		
	    </table>
	    
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
		<input id="publicExponent" value="${publicExponent}" type="hidden"/>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
