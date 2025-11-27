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
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
	    <script type="text/javascript">
	        var pMode = "NEW";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pBoardID = "${boardID}";
	        var pUrl = "${url}";
	        var PhotoBoard = "N";
	        var strNow = "${strNow}";		
	        var bodycount = "0";
	        var pAttachListXml = "";
	        var pAttachListXml2 = "";
	        var gubun = "7";
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
	        var isfileup = false;
	        var pUse_Editor = "${useEditor}";
	        var pNoneActiveX = "YES";
	        var saveItemBoardId = "";
	        var SelBoard = false;
	        var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
		    var useKeywordFlag = "<c:out value='${useKeyword}'/>"; // 키워드 사용여부 (Y/N)
		    var keywordArr = []; // 키워드 배열
		    var isThumbnailUp = false;
			var writerFlag = "${boardInfo.writerFlag}"; // 2025-01-21 임정은 - 게시판 게시물 게시자명선택 사용여부 플래그
	        
	        function window_onload() {
	            try{
	                new FormData();
	                thumbnailInit();
	            }
	            catch (e) {
	            }
	            window.onresize();
	            
	            if(parseInt(autoSaveTime) > 0)
	            	autoSaveTempItem();
	        }
	        
	        /* 2018-08-08 홍승비 - 썸네일+포토게시물 등록창 세로길이 리사이즈 추가 */
	        window.onresize = function () {
	        	 document.getElementById("addimagecontent").style.height = document.documentElement.clientHeight - 280 + "PX";
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
	
	        function addMovieLine(moviePath, localFileName, movieUniqueID, movieSize)
	        {
	            var movieid = moviePath;
                tmpContents = new Array();

                if (document.getElementById(movieid) != "" && document.getElementById(movieid) != null) {
                    return "false";
                }

                var resultHTML = "";
				resultHTML = "<table width='100%' height='420px' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + movieid + "' name='" + moviePath + "' uniqueId='" + movieUniqueID + "' >" +
				"<tr><td style='border-top:0 none; padding:6px; text-align:center;'><video id='" + movieid + "' title='" + localFileName + "' size='" + movieSize + "' uniqueId='" + movieUniqueID + 
				"' style='width: 640px; height: 360px;' name='movieView' controls /></td></tr></table>";

                var movieContent = document.getElementById("addimagecontent");
                movieContent.innerHTML += resultHTML;
                
                /* 2023-09-14 홍승비 - 게시물 작성창에서 동영상 업로드 시 동영상 재생바 클릭으로 시간 이동되지 않는 현상 수정 (기존 getBoardMovieInfo.do URL이 아닌 실제 파일경로를 사용) */
				if (movieContent != null && movieContent != "") {
					var movieSrc = getBoardMoviePath("BOARDMOVIETEMP", pBoardID, movieUniqueID);
					
                    document.getElementById(movieid).src = movieSrc;
                    bodycount = parseInt(bodycount) + 1;
				}
	        }
	        
	        function GetSmallUrl() {
	            var xmldom_attachlist = createXmlDom();
	            var strRet = "";
	            var filepath = "";
	
	            if (typeof (pAttachListXml) == "string") {
	                xmldom_attachlist = loadXMLString(pAttachListXml);
	            } else {
	                xmldom_attachlist = pAttachListXml;
				}

                if (xmldom_attachlist == false) {
                    xmldom_attachlist = null;
                    return "";
                }
                
	            var xmldomNodes = xmldom_attachlist.getElementsByTagName('DATA2');
	            
                filepath = getNodeText(xmldomNodes.item(0));
                if (filepath.indexOf(pBoardID) != -1) {
                    var idx = filepath.lastIndexOf("/");
                    if (idx != -1) {
                        strRet += filepath.substr(0, idx + 1) + filepath.substr(idx + 1) + "|";
                    }
                } else {
                    if (saveItemBoardId != "" && saveItemBoardId == pBoardID) {
                        strRet += "tempUploadFile/" + getNodeText(xmldomNodes.item(0));
					} else {
                        strRet += saveItemBoardId + "/uploadFile/" + getNodeText(xmldomNodes.item(0));
					}
                }
                
	            xmldom_attachlist = null;
	            return strRet;
	        }
	        
	        function SaveItem(pMode)
	        {
	        	/* 2023-09-14 홍승비 - 동영상 업로드 동작이 완료되기 전까지는 상단 버튼의 동작을 방지 (업로드는 비동기로 동작함) */
	        	if (isfileup == true) {
	        		return;
	        	}
	        	
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
	                alert("<spring:message code='ezBoard.hsb07'/>");
	                return;
	            }
	
				filename = document.getElementsByName('movieView')[0].title;
				
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
			        
			    // 저장조건체크 이후, 동영상에서 썸네일 추출하여 업로드 (동기적으로 사용하므로 false 처리)
	            var fd2 = new FormData();
	            xhr2 = new XMLHttpRequest();
	            var thumbnail;
	            var addThumbnail = "";
			    if (isThumbnailUp) {
			    	thumbnail = GetAttribute(document.getElementsByName('imgView')[0], 'id');
			    	addThumbnail = "Y";
			    } else {
			        thumbnail = makeThumbnail(document.getElementsByName('movieView')[0].id);
			        addThumbnail = "N";
			    }
			    
			    fd2.append("thumbnail", thumbnail);
	            xhr2.open("POST", "/ezBoard/boardMovieThumb.do?thumbnailID=" + encodeURIComponent(document.getElementsByName('movieView')[0].id) + "&fileLimit=" + AttachLimit + "&addThumbnail=" + addThumbnail, false);
	            xhr2.send(fd2);
	            
	            var thumbnailPath = getNodeText(SelectNodes(loadXMLString(xhr2.responseText), "ROOT/NODES/NODE/THUMBNAILNAME")[0]);
	            
			    newID = "{" + GetGUID() + "}";
	
			    var xmlhttp = createXMLHttpRequest();
			    var xmldom = createXmlDom();
			
			    strXML += "<NODES>";
			    strXML += "<NODE>";
			    
			    //2006.11.28 포토게시물 5건까지 등록할 수 있도록 수정
	            var itemid = "";
	            itemid = "{" + GetGUID() + "}";
                strXML += "<ITEMID>" + itemid + "</ITEMID>";
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	            
	            var importance = "0";
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
			    strXML += "<ABSTRACT></ABSTRACT>";
			    strXML += "<ATTACHMENTS></ATTACHMENTS>";
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
				strXML += "<EXTENSIONATTRIBUTE4></EXTENSIONATTRIBUTE4>";			
			    strXML += "<EXTENSIONATTRIBUTE5>" + MakeXMLString(GetSmallUrl()) + "</EXTENSIONATTRIBUTE5>";
			    
			    //20121018_[을지]_포토앨범 : 앨범소개 내용전달 // = 동영상소개
	            strXML += "<CONTENT>" + MakeXMLString(movieContent.value) + "</CONTENT>";
	            strXML += "<DOCPASSWORD></DOCPASSWORD>";
	            strXML += "<IMAGE_FILENAME>" + MakeXMLString(filename) + "</IMAGE_FILENAME>";
	            
	            var imageID =  "{" + GetGUID() + "}";
	            // 저장될 동영상의 ID를 썸네일 이미지와 동일하게 사용한다. 무조건 메인플래그로 지정한다.
	            strXML += "<CONTENT2></CONTENT2>";
	            strXML += "<IMAGE_COUNT>1</IMAGE_COUNT>";
	            strXML += "<IMAGE_ID>" + imageID + "</IMAGE_ID>";
	            strXML += "<MAINIMAGEID>" + imageID + "</MAINIMAGEID>";
	            
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
	            
                strXML += "<THUMBNAILEXT>" + thumbnailPath.substring(thumbnailPath.lastIndexOf(".") + 1) + "</THUMBNAILEXT>";
                strXML += "<ADDTHUMBNAIL>" + addThumbnail + "</ADDTHUMBNAIL>";
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
							
							/* 2021-06-22 홍승비 - 게시판 게시알림(일반 사용자 대상 발송), 수정알림 추가 (승인게시판의 경우, 게시물 승인 전에 게시알림 사용안함) */
		                    if (pMode == "new") { // 게시알림
		                    	sendBoardAlert("new", pBoardID, itemid, isAllGroupBoard);
		                    }
	                	}
				    	
						/* 2019-05-08 홍승비 - 이미 승인된 게시물을 수정하는 경우, 승인요청 알림 발송하지 않도록 수정 */
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
	                	window.opener.getBoardList();
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
	        
	        /* 2018-11-05 홍승비 - 동영상파일 확장자체크 추가 */
		    function MovieTemp_onclick() {
		        if (document.form.file1.value != "") {
		            var fd = new FormData();		            
	            	var file1val = document.getElementById("file1").files[0].name;
			        var exIndex = file1val.lastIndexOf('.');
					var extension = file1val.substring(exIndex+1, file1val.length);
			        var check = false;
			        check = compareExtension(check, extension);
			        
			        if (!check) {
			        	document.getElementById("file1").files[0] = "";
			        	alert("<spring:message code ='ezBoard.hsb05' />");
			        	return;
			        } else {
	                	fd.append("file1", document.getElementById("form").file1.files[0]);
			        }
			        
		            isfileup = true;
		            xhr = new XMLHttpRequest();
		            xhr.upload.addEventListener("progress", uploadProgress, false);
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardMovieUpload.do?mode=MOVIE&boardID=" + encodeURIComponent(pBoardID) + "&fileLimit=" + AttachLimit, true);
		            xhr.send(fd);
		            document.getElementById("progdiv").style.display = "";
		        }
		    }
		    
	        // 동영상 임시 업로드 이후 동작2 
		    function returnvalue(strXML) {
				/* 2021-12-08 홍승비 - 동영상 게시물 동영상 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
				if (strXML == "UPLOAD_EXT_ERROR") {
			        alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					return;
				}
		    	
		        ImgaeReturnXml = loadXMLString(strXML);
		        var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
		        
	            if (getNodeText(GetChildNodes(nodes[0])[1]) == "overflow") {
	                alert("" + strLang8 + "" + AttachLimit + "MB" + strLang9 + "");
	                return;
	            }
	            saveItemBoardId = pBoardID;
	            var rtnMode = getNodeText(GetChildNodes(nodes[0])[5]); // MODE
	            var movieFileName = getNodeText(GetChildNodes(nodes[0])[0]); // THUMBNAILNAME (s_{GUID})
	            var localFileName = getNodeText(GetChildNodes(nodes[0])[2]); // PFILENAME
	            var movieFileSize = getNodeText(GetChildNodes(nodes[0])[3]); // FILESIZE
	            var movieUniqueID = getNodeText(GetChildNodes(nodes[0])[6]); // UNIQUEID ({GUID})

	            addMovieLine(movieFileName, localFileName, movieUniqueID, movieFileSize);
	            
		        var attachXml = "<LISTVIEWDATA><ROWS>";
	            attachXml += "<ROW><CELL>";
	            attachXml += "<DATA1>" + "/upload_board/tempUploadFile/" + GetAttribute(document.getElementsByName('movieView')[0], 'uniqueId') + "</DATA1>";
	            attachXml += "<DATA2>" + GetAttribute(document.getElementsByName('movieView')[0], 'uniqueId') + "</DATA2>";
	            attachXml += "<DATA3></DATA3>";
	            attachXml += "<DATA4></DATA4>";
	            attachXml += "<DATA5>Y</DATA5>";
	            attachXml += "<DATA6>" + GetAttribute(document.getElementsByName('movieView')[0], 'size') + "</DATA6>";
	            attachXml += "</CELL></ROW>";
		        attachXml += "</ROWS></LISTVIEWDATA>";  //pAttachListXml
		        
		        var xmlDom = createXmlDom();
		        xmlDom = loadXMLString(attachXml);
		        pAttachListXml = xmlDom;

		    }
		
		    // 동영상 추가는 한개만 가능
		    function btn_MovieAttachAdd() {
	        	if (isfileup == true) {
	        		return;
	        	}
		    	
	        	if (document.getElementById("addimagecontent").childNodes.length > 0) {
	        		alert("<spring:message code ='ezBoard.hsb06' />");
		        	return;
	        	}
		    	
	        	document.getElementById('mode').value = "MOVIE";
	            document.form.file1.click();
		    }
		
		    // 동영상 삭제
		    function btn_MovieAttachDel()
		    {
	        	if (isfileup == true) {
	        		return;
	        	}
		    	
				var xmlhttp = createXMLHttpRequest();
	            var uniqueID = "";
	            var fd = new FormData();
	            var imgDiv = document.getElementById("addimagecontent");
	            uniqueID =  GetAttribute(document.getElementsByName('movieView')[0], 'uniqueid');
	            
	            if (uniqueID == null || uniqueID == "") {
	            	alert("<spring:message code='ezBoard.t601'/>");
		    		return;	
	            }
	            
	            xmlhttp.open("POST", "/ezBoard/boardMovieUpload.do?mode=DEL&boardID=" + encodeURIComponent(pBoardID) +"&uniqueID=" + encodeURIComponent(uniqueID), false);
	            xmlhttp.send(fd);
	            
				pAttachListXml = "";
				imgDiv.removeChild(imgDiv.childNodes[0]);
				
		        xmldom = null;
		        xmlHTTP = null;
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
		        document.getElementById("file1").value = "";
		        returnvalue(xhr.responseText);
		        isfileup = false;
		    }
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
	            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
	            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
	            try { OpenWin.focus(); } catch (e) { }
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
	                document.getElementById("BoardSpan").innerHTML = ret[1];
	
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
		    
		    /* 2018-11-05 홍승비 - HTML5 지원 동영상파일 확장자체크 추가 */
		    function compareExtension(check, extension) {
	    		var filterExtension = new Array("mp4", "webm");
	    		for (var i = 0; i < filterExtension.length; i++) {
	        		if (extension.toLowerCase() == filterExtension[i]) {
	            		check = true;
	            		break;
	        		}
	    		}
	    		return check;
			}
		    
		    /* 2018-11-06 홍승비 - 동영상 파일에서 썸네일 이미지 추출 */
		    function makeThumbnail(videoID) {
			    var canvas = document.createElement("CANVAS");
			    var video = document.getElementById(videoID);
			 	// 썸네일 이미지의 크기는 200px * 160px
			 	canvas.width = 200;
			 	canvas.height = 160;
			    canvas.getContext("2d").drawImage(video, 0, 0, 200, 160);
			    
			 	return canvas.toDataURL();
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
	        
			/* 2023-09-14 홍승비 - 게시물 작성창에서 동영상 업로드 시 동영상 재생바 클릭으로 시간 이동되지 않는 현상 수정 (getBoardMovieInfo.do URL이 아닌 실제 파일경로를 사용하도록 수정) */
	        function getBoardMoviePath(pType, pBoardID, movieUniqueID) {
				var path = "";
				
	        	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezBoard/getBoardMoviePath.do",
					data : {
						type : pType,
						boardID : pBoardID,
						fileName : movieUniqueID
					},
					success : function(result) {
						path = result;
					},
					error : function(err) {
						console.log(err);
					}
				});
	        	
	        	return path;
	        }
			
	        function imgtemp_onclick() {
		        if (document.form2.file2.value != "") {
		            var fd = new FormData();
		            
		            for (var i = 0; i < document.getElementById("form2").file2.files.length; i++) {
		            	var file1val = document.getElementById("file2").files[i].name;
				        var exIndex = file1val.lastIndexOf('.');
						var extension = file1val.substring(exIndex+1, file1val.length);
				        var check = false;
				        check = compareExtension2(check, extension);
				        
				        if (!check) {
				        	document.getElementById("file2").files[i] = "";
				        	alert("<spring:message code ='ezBoard.hsbImg01' />");
				        	return;
				        }
				        else {
		                	fd.append("file2", document.getElementById("form2").file2.files[i]);
				        }
		            }
		            fd.append("mode2", document.getElementById("mode2").value);
		            isThumbnailUp = true;
		            xhr2 = new XMLHttpRequest();
		            xhr2.upload.addEventListener("progress", uploadProgress, false);
		            xhr2.addEventListener("load", uploadComplete2, false);
		            xhr2.open("POST", "/ezBoard/boardImageUpload.do?mode=THUMBNAIL&boardID=" + encodeURIComponent(pBoardID) + "&fileLimit=" + AttachLimit);
		            xhr2.send(fd);
		            document.getElementById("progdiv").style.display = "";
		        }
		    }
	        
	        function returnvalue2(strXML) {
				/* 2021-12-08 홍승비 - 포토, 썸네일 게시물 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
				if (strXML.split(";")[0] == "UPLOAD_EXT_ERROR") {
					if (parseInt(strXML.split(";")[1]) > 1) { // 업로드 파일이 2개 이상인 경우
			        	alert("<spring:message code ='ezJournal.kms01' />"); // 업로드 제한 확장자 파일이 있습니다.
			        } else {
			        	alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
			        }
					return;
				}
				
		        ImgaeReturnXml2 = loadXMLString(strXML);
		        var nodes = SelectNodes(ImgaeReturnXml2, "ROOT/NODES/NODE");
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
		        for (var i = 0 ; i < document.getElementById("addimagecontent2").childNodes.length ; i++) {
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
		        pAttachListXml2 = xmlDom;
		    }
		        
	        function uploadComplete2() {
		        document.getElementById("progdiv").style.display = "none";
		        document.getElementById("prog_bar").style.width = "0%";
		        document.getElementById("prog_num").innerHTML = "";
		        document.getElementById("file2").value = "";
		        returnvalue2(xhr2.responseText);
		    }
		        
	        function btn_thumbAttachAdd() {
	            if (CrossYN()) {
	            	document.getElementById('mode2').value = "THUMBNAIL";
	                document.form2.file2.click();
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
		        
	        function compareExtension2(check, extension) {
	    		var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
	    		for (var i = 0; i < filterExtension.length; i++) {
	        		if (extension.toLowerCase() == filterExtension[i]) {
	            		check = true;
	            		break;
	        		}
	    		}
	    		return check;
			}
		        
	        function addimageline(imgpath, localFileName, imgUniqueID, imgSize)
	        {
	            var imagecount = "";
	            var imageid = "";
	
                imagecount = imgpath.split("/").length - 1;
                imageid = imgpath.split("/")[imagecount];
                tmpContents = new Array();
                for(var i = 0 ; i < document.getElementsByName("imgContent").length ; i++)
                {
                    tmpContents[i] = document.getElementsByName("imgContent")[i].value;
                }

                if (document.getElementById(imageid) != "" && document.getElementById(imageid) != null)
                    return "false";

                var resultHTML = "<table width='100%' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + imageid + "' name='" + imgpath + "' uniqueId='" + imgUniqueID + "' ><tr>" +
	                             "<td style='width:200px; height: 100px;border-top:0 none; padding:6px; text-align:center;'><img id='" + imageid + "' title='" + localFileName + "' size='" + imgSize + "' uniqueId='" + imgUniqueID + "' style='width: 200px; height: 100px;' name='imgView'></img></td>" +
	                             "</tr></table>";
                var imagecontent = document.getElementById("addimagecontent2");
                imagecontent.innerHTML = "";
                imagecontent.innerHTML += resultHTML;
                for (var i = 0 ; i < tmpContents.length ; i++) {
                    document.getElementsByName("imgContent")[i].value = tmpContents[i];
                }

                if (imagecontent != null && imagecontent != "") {
                    var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(imgpath);
                    document.getElementById(imageid).src = imgSrc;
                    bodycount = parseInt(bodycount) + 1;
                }
	            thumbnailChange();
	        }
		        
	        function thumbnailInit() {
	        	document.getElementById("titleTD").colSpan = 3;
	        	document.getElementById("titleTD").style.width = "100%";
	    		document.getElementById("thumbnailTH").style.display = "none";
	    		document.getElementById("movieContentTD").colSpan = 3;
	        	document.getElementById("movieContentTD").style.width = "100%";
	        	document.getElementById("imageContentTD").style.display = "none";
	        }
	        
	        function thumbnailChange() {
	        	document.getElementById("titleTD").colSpan = 1;
	        	document.getElementById("titleTD").style.width = "70%";
	    		document.getElementById("thumbnailTH").style.display= "";
	    		document.getElementById("movieContentTD").colSpan = 1;
	        	document.getElementById("movieContentTD").style.width = "70%";
	        	document.getElementById("imageContentTD").style.display= "";
	        }
		        
	        function btn_thumbAttachDel()
		    {
	            var xmlhttp = createXMLHttpRequest();
	            var uniqueIDs = "";
	            var fd = new FormData();
	            
	            for (var i = 0; i < document.getElementsByName("imgView").length; i++) {
	            	uniqueIDs += document.getElementsByName('imgView')[i].getAttribute("uniqueid") + ";";
	            }
	            
	            if (uniqueIDs == null || uniqueIDs == "") {
	            	alert("<spring:message code='ezBoard.thumbnail.kwc002'/>");
		    		return;	
	            }
	            
	            xmlhttp.open("POST", "/ezBoard/boardImageUpload.do?mode=DEL&boardID=" + encodeURIComponent(pBoardID) +"&uniqueIDs=" + encodeURIComponent(uniqueIDs), false);
	            xmlhttp.send(fd);
		        
		        var imagecontent = document.getElementById("addimagecontent2");
		        imagecontent.innerHTML = "";
		        
		        var attachXml = "<LISTVIEWDATA><ROWS>";
		        for (var i = 0 ; i < document.getElementById("addimagecontent2").childNodes.length ; i++) {
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
		        pAttachListXml2 = xmlDom;
		
		        xmldom = null;
		        xmlHTTP = null;
		        
		        thumbnailInit();
		        isThumbnailUp = false;
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
	<c:if test="${!isCrossBrowser}">
		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
		    Append_AttachAdd(filename);
		</script>
	</c:if>
	<body class="popup" onload="window_onload()">
	    <table border="0" class="layout">
	        <tr>
	            <td style="height:20px">
	              <div id="menu">
	                <ul>
	                  <li ><span onClick="SaveItem('new');"><spring:message code='ezBoard.t98'/></span></li>
	                  <li ><span ID='btn_add' onclick='btn_MovieAttachAdd()'><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t602'/></span></li>
	                  <li ><span id="btn_del" onClick="return btn_MovieAttachDel()"><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t89'/></span></li>
	                  <li ><span ID='btn_thumbAdd' onclick='btn_thumbAttachAdd()'><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t602'/></span></li>
	                  <li ><span id="btn_thumbDel" onClick="return btn_thumbAttachDel()"><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t89'/></span></li>
	                  <li><span  onClick="SaveItem('temp');"><spring:message code='ezBoard.t10034'/></span></li>
	                </ul>
	              </div>
	              <div id="close">
	                <ul>
	                    <li ><span onclick="window.close();"></span></li>
	                </ul>
	              </div>
				<script type="text/javascript">
				    selToggleList(document.getElementById("menu"), "ul", "li", "0");	    
				</script>
	        </td>
	  </tr>
	  <tr>
	      <td>
	      <table border="0" cellspacing="0" cellpadding="0" class="content" style="table-layout:fixed;">
	        <tr>
	          <th style="width:100px; text-align:center">
	          	<c:choose>
	          		<c:when test="${boardType != 'SELECT'}">
		                <spring:message code='ezBoard.t142'/>
	          		</c:when>
	          		<c:otherwise>
		                <a class="imgbtn" onclick="NewItem_onclick()"><span><spring:message code='ezBoard.t171'/></span></a>
	          		</c:otherwise>
	          	</c:choose>
	          </th>
	          <td style="width:45%" id="tdBoardName">
	          	<c:choose>
	          		<c:when test="${boardType != 'SELECT'}">
	          			${boardName}
	          		</c:when>
	          		<c:otherwise>
	          			<c:choose>
	          				<c:when test="${boardID == ''}">
			                    <span id="BoardSpan"><spring:message code='ezBoard.t57'/></span>
	          				</c:when>
	          				<c:otherwise>
			                    <span id="BoardSpan">${boardName}</span>
	          				</c:otherwise>
	          			</c:choose>
	          		</c:otherwise>
	          	</c:choose>
	          </td>
	          <th style="width:100px; text-align:center"><spring:message code='ezBoard.t223'/></th>
				<td style="width:48%;">
					<span id="spUseDept">${userInfo.displayName}</span>
					<c:if test="${'Y' == boardInfo.writerFlag}">
						<div class="custom_checkbox"><input type="checkbox" id="chkUseDept" style="margin-left: 0px !important;" onclick="chkUseDept_onclick()"></div>
						<select id="writerFlag" style="display: none;">
							<option value="<c:out value='${writerOption.N}\\${writerOption.N2}\\0' />"></option>
							<option value="<c:out value='${writerOption.T}\\${writerOption.T2}\\1' />"></option>
							<option value="<c:out value='${writerOption.D}\\${writerOption.D2}\\2' />"></option>
						</select>
					</c:if>
				</td>
	        </tr>
            <!-- 키워드 시작 -->
            <c:if test="${not empty useKeyword && useKeyword eq 'Y'}">
                <tr>
                    <th><spring:message code="ezApprovalG.t1200" /></th>
                    <td colspan="3" id="keyWordResult">
                        <input type="text" id="txtKeyword" style="WIDTH: 20%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeyup="keyword_onkeyUp(event)" >
                    </td>
                </tr>
            </c:if>
            <!-- 키워드 끝 -->
	        <tr>
	          <th style="text-align:center"><spring:message code='ezBoard.t208'/></th>
	          <td id="titleTD" colspan="1" style="width:70%; vertical-align:middle; padding:0px 5px 0px 3px; margin:0;"><INPUT type="text" id="txtTitle" style="WIDTH:100%;word-wrap:break-word;word-break:break-all; border:1px solid #ddd; margin:0px; padding:2px 0px 2px 0px;" value="" maxlength="100" /></td>
	          <th id="thumbnailTH" colspan="2" style="width:30%; text-align:center">
	          	<spring:message code='ezBoard.thumbnail.kwc001'/>
	          </th>
	        </tr>
	        <tr style="display:none;">
	          <th><spring:message code='ezBoard.t1001'/></th>
	          <td class="pos1" colspan="3" style="width:100%;"><input style="width:600px;" id="fileData" name="fileData" type="file" onchange="fileUploadPreview(this, 'preView')" /></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezQuestion.t180'/><spring:message code='ezCommunity.t18'/></th>
	            <td id="movieContentTD" colspan="1" style="width:70%; height:100px; margin:0; padding:3px 5px 3px 3px;"><textarea style="width:100%; height:100px; margin:0; padding:0; border:1px solid #ddd;" id="movieContent" wrap="hard"></textarea></td>
	            <td id="imageContentTD" colspan="2" style="width:30%;">
			        <div id="addimagecontent2" style="overflow:auto; vertical-align:top;"></div>
			    </td>
	        </tr>
	      </table>
	      </td>
	  </tr>
	  <tr>
	    <td>
	        <table style="width:100%; border:1px solid #ddd; border-top:0 none; table-layout:fixed;" border="0" cellspacing="0" cellpadding="0">
	        <tr>
	            <th style="text-align:center ;padding-left:2px;border:0;"><spring:message code='ezBoard.t431'/></th>
	        </tr>
	      </table>
	    </td>
	  </tr>
	  <tr>
	    <td colspan="4">
	        <div id="addimagecontent" style="overflow:auto;width:100%;height:415px; vertical-align:top"></div>
	    </td>
	  </tr>
	  <tr>
	    <td>
	        <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	        <form method="post" id="form" name="form" enctype="multipart/form-data" action="" target="ifrm" style="display: none">
	        <input type="file" name="file1" id="file1"  style="width: 1px; height: 1px;" onchange="MovieTemp_onclick()" accept="video/*"/>
	        <input type="hidden" name="mode" id="mode" />
	        </form>
	    </td>
	    <td>
	        <iframe name="ifrm2" src="about:blank" style="display: none"></iframe>
	        <form method="post" id="form2" name="form2" enctype="multipart/form-data" action="" target="ifrm2" style="display: none">
	        <input type="file" name="file2" id="file2"  style="width: 1px; height: 1px;" onchange="imgtemp_onclick()" accept="image/*"/>
	        <input type="hidden" name="mode2" id="mode2" />
	        </form>
    	</td>
	  </tr>

	    </table>
	    <div id="progdiv" class="progarea" style="z-index:6000;position:absolute;top:370px;left:227px;display:none">
	        <P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
	    </div>
	</body>
</html>