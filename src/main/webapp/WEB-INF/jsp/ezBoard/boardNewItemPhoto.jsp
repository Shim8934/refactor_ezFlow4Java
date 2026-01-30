<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.t368'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <style type="text/css">
	         .preView {
	         	width: 70px;
	         	height: 70px;
	         	text-align: center;
	         	border:1px solid silver;
	         }
	         textarea {
	         	resize:none;
	         }
	     </style>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
   	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	    </c:if>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
	    <script type="text/javascript">
	        var pMode = "NEW";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pBoardID = "<c:out value='${boardID}'/>";
	        var pUrl = "${url}";
	        var PhotoBoard = "N";
	        var spanimagename = "";
	        var resultcmd = "";
	        var MHTLoadComplete = "true";
	        var strNow = "${strNow}";		
	        var bodycount = "0";
	        var pAttachListXml = "";
	        var gubun = "${boardInfo.guBun}";
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
	        var saveItemBoardId = "";
	        var SelBoard = false;
	        var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
		    var useKeywordFlag = "<c:out value='${useKeyword}'/>"; // 키워드 사용여부 (Y/N)
		    var keywordArr = []; // 키워드 배열
			var writerFlag = "${boardInfo.writerFlag}"; // 2025-01-21 임정은 - 게시판 게시물 게시자명선택 사용여부 플래그
	        
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
	            
	           // document.getElementById("addimagecontent").style.height = document.documentElement.clientHeight - 280 + "PX";
	        }
	        
	        /* 2018-08-08 홍승비 - 썸네일+포토게시물 등록창 세로길이 리사이즈 추가 */
	        window.onresize = function () {
	        	// document.getElementById("addimagecontent").style.height = document.documentElement.clientHeight - 280 + "PX";
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
	
	        function addimageline(imgpath, localFileName, imgUniqueID, imgSize) {
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
	
					var imagecontent = document.getElementById("addimagecontent");
	                insertImageHtml(imagecontent, imgpath, localFileName, imgUniqueID, imageid, imgSize);
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
	
					var imagecontent = document.getElementById("addimagecontent");
	                insertImageHtml(imagecontent, imgpath, localFileName, imgUniqueID, imageid, imgSize);
	                if (imagecontent != null && imagecontent != "") {
	                    document.getElementById(imageid).src = localFileName;
	                    bodycount = parseInt(bodycount) + 1;
	                }                
	            }
	        }
			
			function insertImageHtml(imagecontentDom, imgpath, localFileName, imgUniqueID, imageid, imgSize) {
				// 사진 개체 박스
				const wrapperAttr = { id: "M_" + imageid, name: imgpath, uniqueId: imgUniqueID };
				const wrapper = createEl("div", "album_list_cont", wrapperAttr);
				
				// 체크박스
				const spanCheck = createEl("span", "custom_checkbox");
				const checkboxAttr = { type: "checkbox", value: "M_" + imageid, id: "imagecheck" + bodycount, name: "checkmenuSub" }
				const checkbox = createEl("input", null, checkboxAttr);
				spanCheck.appendChild(checkbox);
				
				// 이미지
				const spanPhoto = createEl("span", "album_list_photo");
				const imgAttr = { id: imageid, title: localFileName, size: imgSize, uniqueId: imgUniqueID, name: "imgView" };
				const img = createEl("img", null, imgAttr);
				spanPhoto.appendChild(img);
				
				// 텍스트
				const spanText = createEl("span", "album_list_textarea");
				const textareaAttr = { rows: "3", maxLength: "50", name: "imgContent" }
				const textarea = createEl("textarea", null, textareaAttr);
				spanText.appendChild(textarea);
				
				// 라디오 버튼
				const spanRadio = createEl("span", "album_list_mainChk");
				const radioWrap = createEl("div", "custom_radio");
				radioWrap.appendChild(createEl("input", null, { type: "radio", name: "mainFG" }));
				
				spanRadio.appendChild(radioWrap);
				wrapper.append(spanCheck, spanPhoto, spanText, spanRadio);
				imagecontentDom.appendChild(wrapper);
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
	                        strRet += filepath.substr(0, idx + 1) + "s_" + filepath.substr(idx + 1) + "|";
	                    }
	
	                } else {
	                    if (saveItemBoardId != "" && saveItemBoardId == pBoardID)
	                        strRet += "tempUploadFile/s_" + getNodeText(xmldomNodes.item(i)) + "|";
	                    else
	                        strRet += saveItemBoardId + "/uploadFile/s_" + getNodeText(xmldomNodes.item(i)) + "|";
	                }
	            }
	            xmldom_attachlist = null;
	            return strRet;
	        }
	        
	        var isSubmit = false;
	        
	        function checkDuplicateSubmit(pMode) {
				if (!isSubmit) { 
					isSubmit = true;
					
					SaveItem(pMode);

					setTimeout(function() {
						isSubmit = false;
					}, 5000);
				}
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
	                    filename += document.getElementsByName('imgView')[i].title + "|";
	                }
	            } else {
	                for (var i = 0; i < bodycount; i++)
	                {
	                    var checkreuslt = document.getElementById("addimagecontent").childNodes[i].childNodes[0].childNodes[0].childNodes[0].childNodes[0];
	                    var checkreuslts = document.getElementById("addimagecontent").childNodes[i].childNodes[0].childNodes[0].childNodes[2].childNodes[0];
	                    
	                    file += GetAttribute(document.getElementById(checkreuslt.value),'name') + "|";
	                    content += checkreuslts.value + ";:;";

	                    var imagenamelength = GetAttribute(document.getElementById(checkreuslt.value),'name').lastIndexOf("\\");
	                    
	                    filename += GetAttribute(document.getElementById(checkreuslt.value),'name').substring(imagenamelength + 1, imagenamelength.length) + "|";
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
			
			    if (txtTitle.value == "" || trim(txtTitle.value) == "")
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
	                itemid = strItemID + "|";
	                strXML += "<ITEMID>" + itemid + "</ITEMID>";
			    }
	
			    var importance = "";
	            importance = "0";
			    
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
			
			    // 수정(2008.03.19) : 사용자 정보가 누락되는 경우 체크하는 부분 추가
	
				strXML += "<WRITERID>" + SSUserID + "</WRITERID>";
				if ('Y' == writerFlag) {
					var flagwriterName = $('#writerFlag').val().toString().split("\\");
					strXML += "<WRITERNAME>" + MakeXMLString(flagwriterName[0]) + "</WRITERNAME>";
					strXML += "<WRITERNAME2>" + MakeXMLString(flagwriterName[1]) + "</WRITERNAME2>";
					strXML += "<WRITERNAMETYPE>" + MakeXMLString(flagwriterName[2]) + "</WRITERNAMETYPE>";
				} else {
					strXML += "<WRITERNAME>" + MakeXMLString(SSUserName) + "</WRITERNAME>";
					strXML += "<WRITERNAME2>" + MakeXMLString(SSUserName2) + "</WRITERNAME2>";
				}
				strXML += "<DEPTID>" + SSDeptID + "</DEPTID>";
				strXML += "<DEPTNAME>" + MakeXMLString(SSDeptName) + "</DEPTNAME>";
				strXML += "<DEPTNAME2>" + MakeXMLString(SSDeptName2) + "</DEPTNAME2>";
				strXML += "<COMPANYID>" + SSCompanyID + "</COMPANYID>";
				strXML += "<COMPANYNAME>" + MakeXMLString(SSCompanyName) + "</COMPANYNAME>";
				strXML += "<COMPANYNAME2>" + MakeXMLString(SSCompanyName2) + "</COMPANYNAME2>";
	            strXML += "<IMPORTANCE>" + importance + "</IMPORTANCE>";
			    strXML += "<TITLE>" + MakeXMLString(txtTitle.value.replace(/[\t\n\r]+/g, ' ').trim()) + "</TITLE>";
			    strXML += "<STARTDATE>" + pStartDate + "</STARTDATE>";
			    strXML += "<ENDDATE>" + pEndDate + "</ENDDATE>";
			    strXML += "<ABSTRACT></ABSTRACT>"; // 게시요약, 포토 / 썸네일 사용안함
			    strXML += "<ATTACHMENTS>" + MakeXMLString(AttachFileList_Photo()) + "</ATTACHMENTS>";
				strXML += "<UPPERITEMIDTREE>" + newID + "</UPPERITEMIDTREE>";
				strXML += "<PARENTWRITEDATE></PARENTWRITEDATE>";
				strXML += "<ITEMLEVEL>1</ITEMLEVEL>";
	            strXML += "<FILEPATH>" + pUploadFilePath + "</FILEPATH>";
			    //확장 필드(필요에 따라 추가)
			    strXML += "<EXTENSIONATTRIBUTE1></EXTENSIONATTRIBUTE1>";
			    strXML += "<EXTENSIONATTRIBUTE2></EXTENSIONATTRIBUTE2>";

				if ('Y' == writerFlag && chkUseDept.checked) {
					strXML += "<EXTENSIONATTRIBUTE3>" + SSDeptName + "</EXTENSIONATTRIBUTE3>";
					strXML += "<EXTENSIONATTRIBUTE32>" + SSDeptName2 + "</EXTENSIONATTRIBUTE32>";
				} else {
					strXML += "<EXTENSIONATTRIBUTE3>" + strUserRank + "</EXTENSIONATTRIBUTE3>";	//직급으로 사용
					strXML += "<EXTENSIONATTRIBUTE32>" + strUserRank2 + "</EXTENSIONATTRIBUTE32>";	//직급으로 사용
				}

				strXML += "<EXTENSIONATTRIBUTE4></EXTENSIONATTRIBUTE4>"; // 포토 / 썸네일에서는 미사용
			    strXML += "<EXTENSIONATTRIBUTE5>" + MakeXMLString(GetSmallUrl()) + "</EXTENSIONATTRIBUTE5>";
			    
			    //20121018_[을지]_포토앨범 : 앨범소개 내용전달
	            strXML += "<CONTENT>" + MakeXMLString(photocontent.value) + "</CONTENT>";		    
	            strXML += "<DOCPASSWORD></DOCPASSWORD>";
	
	            //20121018_[을지]_포토앨범 : 각사진에 대한 이미지 ID를 부여
	            var filecount = document.getElementsByName('checkmenuSub').length;
	            var imageid = "";
	            /* 2018-06-08 홍승비 - 사진 순서 정렬을 위한 이미지ID 조정 (000~999) */
	            for (var i = 0; i < filecount ; i++) {
	            	var tmpId = getZeroNum(i);
	                tmpId += "{" + GetGUID() + "}";
	                
	                if (document.getElementsByName("mainFG")[i].checked) {
	                    mainImageID = tmpId;
	                }
	                imageid += tmpId + ";";
	            }
	            strXML += "<IMAGE_COUNT>" + filecount + "</IMAGE_COUNT>";
	            strXML += "<IMAGE_ID>" + imageid + "</IMAGE_ID>";
	            //20121018_[을지]_포토앨범 : 사진별 앨범 소개 글
	            strXML += "<CONTENT2>" + MakeXMLString(content) + "</CONTENT2>";
	            strXML += "<IMAGE_FILENAME>" + MakeXMLString(filename) + "</IMAGE_FILENAME>";
	            strXML += "<MAINIMAGEID>" + mainImageID + "</MAINIMAGEID>";
	            
	            /* 2018-11-06 홍승비 - 게시판 체크용 구분값 추가 */
	            strXML += "<GUBUN>" + gubun + "</GUBUN>";
	            
                /* 2024-08-13 전인하 - 키워드 추가 */
                if (useKeywordFlag != null && useKeywordFlag == 'Y') {
                    strXML += "<KEYWORDS>";
                    for (var keyword of keywordArr) {
                        // createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "KEYWORD", keyword);
                        strXML += "<KEYWORD>" + keyword + "</KEYWORD>";
                    }
                    strXML += "</KEYWORDS>";
                }
	            
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
				    	/* 2023-11-15 홍승비 - 승인게시판의 경우, 게시물 승인 전에 관리자에게 게시알림을 보내지 않도록 수정 + 답변알림을 보내지 않도록 수정 */
	                	if ("${boardInfo.apprFlag}" != "Y") {
							if (strItemID == "") {
							    xmlhttp = createXMLHttpRequest();
								xmlhttp.open("POST", "/ezBoard/sendPostNotiForAdmin.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(itemid), false);
								xmlhttp.send();
								xmlhttp = null;
							}
							if (pMode == "reply") {
							    xmlhttp = createXMLHttpRequest();
							    xmlhttp.open("POST", "/ezBoard/sendReplyNotice.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(itemid) + "&itemTreeID=" + encodeURIComponent(strUpperItemIDTree), false);
							    xmlhttp.send();
							    xmlhttp = null;
							}
							
							/* 2021-06-22 홍승비 - 게시판 게시알림(일반 사용자 대상 발송) 추가 (승인게시판의 경우, 게시물 승인 전에 게시알림 메일 사용안함) */
		                    if (pMode == "new") { // 게시알림
		                    	sendBoardAlert("new", pBoardID, itemid, isAllGroupBoard);
		                    }
	                	}
						
						/* 2019-05-07 홍승비 - 이미 승인된 게시물을 수정하는 경우, 승인요청 알림 발송하지 않도록 수정 */
						if (("${boardInfo.apprMail_FG}" == "Y") && (pMode != "modify")) {
						    xmlhttp = createXMLHttpRequest();
						    xmlhttp.open("POST", "/ezBoard/sendApprNotice.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(itemid), false);
						    xmlhttp.send();
						    xmlhttp = null;
						}
						
		                alert("<spring:message code='ezBoard.t399'/>");
				    } else {
		                alert("<spring:message code='ezBoard.t10033'/>");
				    }
				    
				    try {
				    	window.opener.leftCountRf();
					} catch (e) {}
					
	                try {
	                    window.opener.location.reload(false);
	                }
	                catch (e) { }
	
					window.close();
	            } else {
	                if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "INACCESSIBLE") {
						alert(strLang173);
	                } else if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "GUBUNCHANGED") {
	                    alert(strLangJIHgubunChange02);
	                } else {
						alert("<spring:message code='ezBoard.t403'/>" + loadXMLString(xmlhttp.responseText).text);
	                }
		        }
		
		        xmlhttp = null;
		        xmldom = null;
		    }
	        
	        /* 2018-10-11 홍승비 - 이미지파일 확장자체크 추가 */
		    function imgtemp_onclick() {
		        if (document.form.file1.value != "") {
		            var fd = new FormData();
		            
		            for (var i = 0; i < document.getElementById("form").file1.files.length; i++) {
		            	var file1val = document.getElementById("file1").files[i].name;
				        var exIndex = file1val.lastIndexOf('.');
						var extension = file1val.substring(exIndex+1, file1val.length);
				        var check = false;
				        check = compareExtension(check, extension);
				        
				        if (!check) {
				        	document.getElementById("file1").files[i] = "";
				        	alert("<spring:message code ='ezBoard.hsbImg01' />");
				        	return;
				        }
				        else {
		                	fd.append("file1", document.getElementById("form").file1.files[i]);
				        }
		            }
		            fd.append("mode", document.getElementById("mode").value);
		            isfileup = true;
		            xhr = new XMLHttpRequest();
		            xhr.upload.addEventListener("progress", uploadProgress, false);
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=PICTURE&boardID=" + encodeURIComponent(pBoardID) + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		            document.getElementById("progdiv").style.display = "";
		        }
		    }
		    
		    function returnvalue(strXML) {
				/* 2021-12-08 홍승비 - 포토, 썸네일 게시물 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
				if (strXML.split(";")[0] == "UPLOAD_EXT_ERROR") {
					if (parseInt(strXML.split(";")[1]) > 1) { // 업로드 파일이 2개 이상인 경우
			        	alert("<spring:message code ='ezJournal.kms01' />"); // 업로드 제한 확장자 파일이 있습니다.
			        } else {
			        	alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
			        }
					return;
				}
				
		        ImgaeReturnXml = loadXMLString(strXML);
		        var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
		        for (var i = 0; i < nodes.length ; i++) {
		
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert("" + strLang8 + "" + AttachLimit + "MB" + strLang9 + "");
		                return;
		            }
		            
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "Not Image file") {
		            	alert("<spring:message code ='ezBoard.jsw.01' />");
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
	
		                pAttachListXml = "";
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
		            fd.append("boardID", pBoardID);
					fd.append("uniqueIDs", uniqueIDs);
					
		            xmlhttp.open("POST", "/ezBoard/boardImageUpload.do?mode=DEL", false);
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
		    
		    /* 2018-06-08 홍승비 - 사진 순서 정렬을 위한 이미지ID 조정 (000~999)  */
		    function getZeroNum(count){
		    	var zeroNum = "000" + count;
		    	zeroNum = zeroNum.substring(zeroNum.length - 3);
		    	return zeroNum;
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
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=PICTURE&boardID=" + encodeURIComponent(pBoardID) + "&fileLimit=" + AttachLimit);
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
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var wWeight = "355";
		            var wHeight = "600";
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:600px;DialogWidth:355px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
		            if (typeof (ret) != "undefined" && typeof (ret) == "object") {
		                GetBoardInfo();
		                if (ret[2] != "3" && ret[2] != "4") {
		                    if (!confirm("<spring:message code='ezBoard.t10055'/>"))
		                        return;
		                    else {
	                            document.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(ret[0]) + "&mode=new&boardName=" + ret[1] + "&bType=SELECT";
		                    }
		                }
		                pBoardID = ret[0];
		                document.getElementById("BoardSpan").value = ret[1];
		
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
                            document.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(ret[0]) + "&mode=new&boardName=" + ret[1] + "&bType=SELECT";
	                    }
	                }
	                pBoardID = ret[0];
	                document.getElementById("BoardSpan").value = ret[1];
	
	                SelBoard = true;
	            }
	        }
		    function GetBoardInfo() {
		        var xmlhttp_boardinfo = createXMLHttpRequest();
		        xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + encodeURIComponent(pBoardID), false);
		        xmlhttp_boardinfo.send();
		        if (xmlhttp_boardinfo.status == 200) {
		            pBoardName = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BOARDNAME")[0]);
		            AttachLimit = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "ATTACHLIMIT")[0]);
		            ExpireDays = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "EXPIREDAYS")[0]);
		            gubun = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "GUBUN")[0]);
		        }
		        xmlhttp_boardinfo = null;
		    }
		    
		    /* 2018-10-11 홍승비 - 이미지파일 확장자체크 추가 */
		    function compareExtension(check, extension) {
	    		var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
	    		for (var i = 0; i < filterExtension.length; i++) {
	        		if (extension.toLowerCase() == filterExtension[i]) {
	            		check = true;
	            		break;
	        		}
	    		}
	    		return check;
			}
		    
	        /* 2021-06-22 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendBoardAlert(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/sendBoardAlert.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID,
						isAllGroupBoard : pIsAllGroupBoard
					}
				});
	        }

			function chkUseDept_onclick() {
				if (chkUseDept.checked) { // 팀/부서로 표시
					spUseDept.innerHTML = "${deptName}";
					document.getElementById("writerFlag").selectedIndex = 1;
				} else { // 이름으로 표시
					spUseDept.innerHTML = "${displayName}";
					document.getElementById("writerFlag").selectedIndex = 0;
				}
			}
	    </script>
	</head>
	<body class="popup newBoardPopup" onload="window_onload()">
		<div id="menu">
			<ul>
				<li><span onClick="checkDuplicateSubmit('new');"><spring:message code='ezBoard.t98'/></span></li>
		  		<li><span  onClick="checkDuplicateSubmit('temp');"><spring:message code='ezBoard.t10034'/></span></li>
			</ul>
	  	</div>
		<div id="close">
			<ul>
				<li><span onclick="window.close();"></span></li>
			</ul>
	  	</div>
		<div class="flex_contentBox">
			<%-- 게시판명 --%>
			<div class="flex_content">
				<div class="flex_content_tit"><spring:message code='ezBoard.t142'/></div>
				<div class="flex_content_cont">
					<input type="text" id="BoardSpan" value="<c:out value='${boardName}'/>" disabled="disabled" />
				</div>
			</div>
			<%-- 게시자 --%>
			<c:if test="${'Y' == boardInfo.writerFlag}">
				<div class="flex_content">
					<div class="flex_content_tit"><spring:message code='ezBoard.t223'/></div>
					<div class="flex_content_cont">
						<input type="checkbox" id="chkUseDept" onclick="chkUseDept_onclick()">
						<label id="spUseDept" for="chkUseDept"><c:out value="${userInfo.displayName}"/></label>
						<select id="writerFlag" style="display: none;">
							<option value="<c:out value='${writerOption.N}\\${writerOption.N2}\\0' />"></option>
							<option value="<c:out value='${writerOption.T}\\${writerOption.T2}\\1' />"></option>
							<option value="<c:out value='${writerOption.D}\\${writerOption.D2}\\2' />"></option>
						</select>
					</div>
				</div>
			</c:if>
            <%-- 키워드 --%>
            <c:if test="${not empty useKeyword && useKeyword eq 'Y'}">
				<div class="flex_content">
					<div class="flex_content_tit"><spring:message code="ezApprovalG.t1200" /></div>
					<div class="flex_content_cont">
						<div class="flex_content_keyword" id="keyWordResult" onclick="keywordInput('txtKeyword')">
							<label for="txtKeyword">
								<input type="text" id="txtKeyword" maxlength="70" style="width:auto" placeholder="<spring:message code='ezBoard.newDesign07' />" onblur="keyword_blur(event)" onkeyup="keyword_onkeyUp(event)" >
							</label>
						</div>
					</div>
				</div>
			</c:if>
			<!-- 제목 -->
			<div class="flex_content">
                <div class="flex_content_tit"><spring:message code='ezBoard.t208'/></div>
                <div class="flex_content_cont">
                    <input type="text" id="txtTitle" maxlength="100" placeholder="<spring:message code='ezBoard.t390' />" value="" />
                </div>
            </div>
			<!-- 앨범소개 -->
            <div class="flex_content">
                <div class="flex_content_tit"><spring:message code='ezBoard.t1008'/></div>
                <div class="flex_content_cont">
                    <textarea id="photocontent" name="textarea" rows="2"></textarea>
                </div>
            </div>
			<div class="flex_content_album">
				<div class="flex_content">
					<div class="flex_content_tit"></div>
					<div class="flex_content_cont">
						<span id='btn_Reply' onclick='btn_PhotoAttachAdd()'></span>
						<button type="button" id='btn_Reply' class="form_btn3" onclick='btn_PhotoAttachAdd()'><spring:message code='ezBoard.t1001'/></button>
						<button type="button" id="Span2" class="form_btn3" onClick="return btn_PhotoAttachDel()"><spring:message code='ezBoard.t1003'/></button>
					</div>
				</div>
				<div class="album_list">
					<div class="album_top_cont">
						<span class="custom_checkbox">
							<input type="checkbox" id="checkmenu" name="checkmenu" onclick="imagecheckAll(this)">
						</span>
						<span class="album_top_photo"><spring:message code='ezAddress.t301'/></span>
						<span class="album_top_textarea"><spring:message code='ezBoard.t1012'/></span>
						<span class="album_top_main"><spring:message code='ezBoard.t1022'/></span>
					</div>
					<!-- 사진 표출 영역 -->
					<div id="addimagecontent" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)"></div>
				</div>
			</div>
		</div>
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="" target="ifrm" style="display: none">
			<input type="file" name="file1" id="file1"  style="display:none;" onchange="imgtemp_onclick()" accept="image/*" multiple />
			<input type="hidden" name="mode" id="mode" />
		</form>
		<div id="progdiv" class="progarea" style="z-index: 6000; position:absolute; top:370px; left:227px; display: none;">
			<p class="prog_bar"><span id="prog_bar" style="width:0%;"></span></p> <span class="prog_num"><strong id="prog_num"></strong>%</span>
		</div>
	</body>
</html>