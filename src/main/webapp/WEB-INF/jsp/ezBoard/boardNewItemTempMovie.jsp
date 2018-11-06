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
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
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
	    <script type="text/javascript">
		    var pUploadFilePath = "${uploadFilePath}";
	        var pBoardID = "${boardID}";
	        var pBoardName = "${boardInfo.boardName}";
	        var pMode = "${mode}";
	        var orgMode = "${mode}";
	        var PhotoBoard = "N";
	        var spanimagename = "";
	        var resultcmd = "";
	        var MHTLoadComplete = "true";
	        var bodycount = "0";
	        var pAttachListXml = "";
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
		    var strItemID = "${itemID}";
		    var strWriterName = "${boardListVO.writerName}";
		    var strWriterDeptName = "${boardListVO.writerDeptName}";
		    var strWriterCompanyName = "${boardListVO.writerCompanyName}";
		    var strWriteDate = "${boardListVO.writeDate}";
		    var strParentWriteDate = "${boardListVO.parentWriteDate}";
		    var strImportance = "${boardListVO.importance}";
		    var strStartDate = "${boardListVO.startDate}";
		    var strEndDate = "${boardListVO.endDate}";
		    var strAttachments = "${boardListVO.attachments}";
		    var strContentLocation = "${boardListVO.contentLocation}";
		    var strUpperItemIDTree = "${boardListVO.upperItemIDTree}";
		    var strItemLevel = "${boardListVO.itemLevel}";
		    var strWriterTitle = "${boardListVO.title}";
		    var strWriterFakeName = "${strWriterFakeName}";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
		    var ExpireDays = "${expireDays}";
		    var ExpireItem = "${expireItem}";
		    var gubun = "${boardInfo.guBun}";
		    var pUrl = "${url}";
		    var pDocID = "${docID}";
	        var PhotoBoard = "";
	        var flag = false;
	        var _hasattach = "${hasAttach}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
	        var idDatepicker_Temp = "";
	        var _T1_Temp = "";
	        var NewGuid = "${newGuid}";
		    var mgubun = "";
		    var attachxml = "";
	        var isdad = false;
	        var isfileup = false;
	        var saveItemBoardId = "";
	        var SelBoard = false;
	        var pNoneActiveX = "YES";
		        
	        function window_onload() {
	            try{
	                new FormData();
	                isdad = true;
	            }
	            catch (e) {
	            }
	            imageViewInit();
	            saveItemBoardId = pBoardID;
	        }
		        
	        var xmlhttp = createXMLHttpRequest();
	        var strXML;
	        function imageViewInit() {
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/imageViewList.do",
					data : { boardID   : pBoardID, 
							 itemID    : strItemID,
							 page      : "1"
						   },
					success: function(result){
						ImageViewTable(result);
					}        			
				});
	        }
	        var saveImageIds = "";
	        var saveImageId_main = "";
	        function ImageViewTable(result) {
                var xmldom = createXmlDom();

                xmldom = loadXMLString(result);
                imagetotalcount = getNodeText(xmldom.getElementsByTagName("IMAGECOUNT")[0]);

                var attachXml = "<LISTVIEWDATA><ROWS>";
				var moviePath = getNodeText(xmldom.getElementsByTagName("FILEPATH")[0]).replace("/s_", "/");
				var movieID = getNodeText(xmldom.getElementsByTagName("IMAGEID")[0]);
				var movieUniqueID = moviePath.substring(moviePath.lastIndexOf("/") + 1, moviePath.length);
				var localFileName = getNodeText(xmldom.getElementsByTagName("IMAGENAME")[0]);
				var movieContent = getNodeText(xmldom.getElementsByTagName("movieContent")[0]);
				
				moviePath = moviePath.split('/')[7];
				
				attachXml += "<ROW><CELL>";
				attachXml += "<DATA1><![CDATA[" + moviePath + "]]></DATA1>";
				attachXml += "<DATA2><![CDATA[" + movieUniqueID +"]]></DATA2>";
				attachXml += "<DATA3></DATA3>";
				attachXml += "<DATA4></DATA4>";
				attachXml += "<DATA5>Y</DATA5>";
				attachXml += "<DATA6></DATA6>";
				attachXml += "</CELL></ROW>";
				
				saveImageIds += movieID + " ;";
				
				if (flag == "Y") {
				    saveImageId_main = movieID + " ";
				}
				
				console.log("moviePath     ::     " + moviePath);
				console.log("movieUniqueID     ::     " + movieUniqueID);
				
				addMovieLine(moviePath, localFileName, movieUniqueID, movieContent);

                attachXml += "</ROWS></LISTVIEWDATA>";  //pAttachListXml

                var xmlDom = createXmlDom();
                xmlDom = loadXMLString(attachXml);
                pAttachListXml = xmlDom;
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
	
	        function addMovieLine(moviePath, localFileName, movieUniqueID, movieContent)
	        {
	            var movieid = moviePath;
                tmpContents = new Array();

                if (document.getElementById(movieid) != "" && document.getElementById(movieid) != null) {
                    return "false";
                }

                var resultHTML = "";
				resultHTML = "<table width='100%' height='420px' class='content' style='border-top:0 none; table-layout:fixed;' id='" + "M_" + movieid + "' name='" + moviePath + "' uniqueId='" + movieUniqueID + "' >" +
				"<tr><td style='border-top:0 none; padding:6px; text-align:center;'><video id='" + movieid + "' title='" + localFileName + "' uniqueId='" + movieUniqueID + 
				"' style='max-width: 640px; max-height: 360px;' name='movieView' controls /></td></tr></table>";

                var movieContent = document.getElementById("addimagecontent");
                movieContent.innerHTML += resultHTML;
                
                console.log("movieid     ::    " + movieid);

                 if (movieContent != null && movieContent != "") {
                    var movieSrc = "/ezBoard/getBoardMovieInfo.do?type=BOARDMOVIETEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(movieUniqueID);
                    console.log("movieSrc     ::    " + movieSrc);
                    
                    document.getElementById(movieid).src = movieSrc;
                    bodycount = parseInt(bodycount) + 1;
                }
	        }
	
	        // pAttachListXml은 여기에서 사용된다!
	        // 앞부분 파일패스(tempUploadFile, uploadFile)와 s_가 붙은 경로를 생성한다.
	        // s_부분은 필요없으므로 제거한다.
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
				
	            console.log(xmldomNodes);
	            
                filepath = getNodeText(xmldomNodes.item(0));
                if (filepath.indexOf(pBoardID) != -1) {
                    var idx = filepath.lastIndexOf("/");
                    if (idx != -1) {
                        strRet += filepath.substr(0, idx + 1) + filepath.substr(idx + 1) + "|";
                    }
                } else {
                    if (saveItemBoardId != "" && saveItemBoardId == pBoardID) { // 아직 동영상이 임시 업로드 파일패스에만 존재
                        strRet += "tempUploadFile/" + getNodeText(xmldomNodes.item(0));
					} else { // 동영상이 실제 업로드되어 존재
                        strRet += saveItemBoardId + "/uploadFile/" + getNodeText(xmldomNodes.item(0));
					}
                }
	            
	            console.log("GetSmallUrl()의 strRet    ::    " + strRet);
	            
	            xmldom_attachlist = null;
	            return strRet;
	        }
	        
	        // 저장 버튼을 누른 뒤, 조건을 체크하고 영상에서 썸네일을 추출한다.
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
	                alert("<spring:message code='ezBoard.hsb07'/>");
	                return;
	            }
	
				filename = document.getElementsByName('movieView')[0].title;
				
				console.log("filename    ::   " + filename);
			
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
		        var thumbnail = makeThumbnail(document.getElementsByName('movieView')[0].id);
		        fd2.append("thumbnail", thumbnail);
		        
		        xhr2 = new XMLHttpRequest();
	            xhr2.open("POST", "/ezBoard/boardMovieThumb.do?thumbnailID=" + document.getElementsByName('movieView')[0].id + "&fileLimit=" + AttachLimit, false);
	            xhr2.send(fd2);
			    
	            console.log(thumbnail);
	            
			    newID = "{" + GetGUID() + "}";
	
			    var xmlhttp = createXMLHttpRequest();
			    var xmldom = createXmlDom();
			
			    strXML += "<NODES>";
			    strXML += "<NODE>";
			    
	            /* 2018-08-07 홍승비 - 포토+썸네일게시물 임시저장 시 새로운 itemID 생성하는 조건 수정 */
	            if (pMode != "temp") {
	                strXML += "<ITEMID>" + newID + "</ITEMID>";
	            } else {
	                itemid = strItemID + ";"
	                strXML += "<ITEMID>" + strItemID + "</ITEMID>";
	            }
	            
	            console.log("strItemID     ::     " + strItemID); // undefined 현상
	            
	            var importance = "0";
			    // 수정(2008.03.19) : 사용자 정보가 누락되는 경우 체크하는 부분 추가
	
			     strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
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
			    strXML += "<ABSTRACT></ABSTRACT>";
			    strXML += "<ATTACHMENTS></ATTACHMENTS>"; // 동영상게시판은 첨부파일 안씀// 공백처리
				strXML += "<UPPERITEMIDTREE>" + newID + "</UPPERITEMIDTREE>";
				strXML += "<PARENTWRITEDATE></PARENTWRITEDATE>";
				strXML += "<ITEMLEVEL>1</ITEMLEVEL>";
	            strXML += "<FILEPATH>" + pUploadFilePath + "</FILEPATH>";
			    //확장 필드(필요에 따라 추가)
			    strXML += "<EXTENSIONATTRIBUTE1></EXTENSIONATTRIBUTE1>";
			    strXML += "<EXTENSIONATTRIBUTE2></EXTENSIONATTRIBUTE2>";
				strXML += "<EXTENSIONATTRIBUTE3>" + strUserRank + "</EXTENSIONATTRIBUTE3>";	//직급으로 사용
				strXML += "<EXTENSIONATTRIBUTE32>" + strUserRank2 + "</EXTENSIONATTRIBUTE32>";	//직급(다국어)으로 사용
				strXML += "<EXTENSIONATTRIBUTE4></EXTENSIONATTRIBUTE4>"; // 사용하지 않는 속성(기존첨부)				
				// pAttachListXml은 여기에서 사용됨!! photoSaveDB 메서드에서 이 경로를 이용해 DB에 저장한다.
			    strXML += "<EXTENSIONATTRIBUTE5>" + MakeXMLString(GetSmallUrl()) + "</EXTENSIONATTRIBUTE5>";
			    
			    //20121018_[을지]_포토앨범 : 앨범소개 내용전달 // = 동영상소개
	            strXML += "<CONTENT>" + MakeXMLString(movieContent.value) + "</CONTENT>";
	            strXML += "<DOCPASSWORD></DOCPASSWORD>";
	            strXML += "<IMAGE_FILENAME>" + MakeXMLString(filename) + "</IMAGE_FILENAME>";
	            
	            var imageID =  "{" + GetGUID() + "}";
	            // 저장될 동영상의 ID를 썸네일 이미지와 동일하게 사용한다. 무조건 메인플래그로 지정한다.
	            strXML += "<CONTENT2></CONTENT2>"; // 사진 별 소개이므로 제거
	             strXML += "<IMAGE_COUNT>1</IMAGE_COUNT>";
	            strXML += "<IMAGE_ID>" + imageID + "</IMAGE_ID>";
	            strXML += "<MAINIMAGEID>" + imageID + "</MAINIMAGEID>";
	            
	            /* 2018-11-06 홍승비 - 게시판 체크용 구분값 추가 */
	            strXML += "<GUBUN>" + gubun + "</GUBUN>";
			    strXML += "</NODE>";
			    strXML += "</NODES>";
			    
	            xmldom.async = false;
			    xmldom.preserveWhiteSpace = true;
			    xmldom = loadXMLString(strXML);
			    xmlhttp.open("POST", "/ezBoard/saveItemPhoto.do?mode=" + pMode + "&guBun=" + gubun, false);
			    xmlhttp.send(xmldom);
	
	            if (SelectSingleNodeValue(loadXMLString(xmlhttp.responseText), "RESULT") == "OK") {
				    xmlhttp = null;
				    xmldom = null;
				    if (pMode != "temp") {
				    	var xmlhttp = createXMLHttpRequest();
				    	
	                    xmlhttp.open("POST", "/ezBoard/deleteTempItem.do?mode=PHOTO", false);
	                    xmlhttp.send(strItemID);
	                    
						if (strItemID == "")
						{
						    xmlhttp = createXMLHttpRequest();
							xmlhttp.open("POST", "/ezBoard/sendPostNotiMail.do?boardID=" + pBoardID + "&itemID=" + strItemID, false);
							xmlhttp.send();		
							xmlhttp = null;
						}
						if (pMode == "reply")
						{
						    xmlhttp = createXMLHttpRequest();
						    xmlhttp.open("POST", "/ezBoard/sendReplyNoticeMail.do?boardID=" + pBoardID + "&itemID=" + strItemID + "&itemTreeID=" + strUpperItemIDTree, false);
						    xmlhttp.send();
						    xmlhttp = null;
						}
						if ("${boardInfo.apprMail_FG}" == "Y") {
						    xmlhttp = createXMLHttpRequest();
						    if (pMode != "modify") {
						        xmlhttp.open("POST", "/ezBoard/sendApprNoticeMail.do?boardID=" + pBoardID + "&itemID=" + newID, false);
						    } else {
						        xmlhttp.open("POST", "/ezBoard/sendApprNoticeMail.do?boardID=" + pBoardID + "&itemID=" + strItemID, false);
						    }
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
	                if (loadXMLString(xmlhttp.responseText).text == "INACCESSIBLE")
	                    alert(strLang173);
	                else
	                    alert("<spring:message code='ezBoard.t403'/>" + loadXMLString(xmlhttp.responseText).text);
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
			        }
			        else {
	                	fd.append("file1", document.getElementById("form").file1.files[0]);
			        }
				        
		            fd.append("mode", document.getElementById("mode").value);
		            isfileup = true;
		            xhr = new XMLHttpRequest();
		            xhr.upload.addEventListener("progress", uploadProgress, false);
		            xhr.addEventListener("load", uploadComplete, false); // uploadComplete() 메서드에서 업로드된 동영상으로 썸네일을 생성한다.
		            xhr.open("POST", "/ezBoard/boardMovieUpload.do?mode=MOVIE&boardID=" + pBoardID + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		            document.getElementById("progdiv").style.display = "";
		        }
		    }
		    
	        // 동영상 임시 업로드 이후 동작2 
		    function returnvalue(strXML) {
		        ImgaeReturnXml = loadXMLString(strXML);
		        var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
		        
		        console.log("동영상 임시 업로드 이후");
		        console.log(nodes.length);
		        console.log(ImgaeReturnXml);
		        
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
	            
	            console.log("addMovieLine 종료");

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
		        
		      	console.log("attachXml      ::      " + attachXml);
		
		        var xmlDom = createXmlDom();
		        xmlDom = loadXMLString(attachXml);
		        pAttachListXml = xmlDom;

		    }
		
		    // 동영상 추가는 한개만 가능
		    function btn_MovieAttachAdd() {
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
				var xmlhttp = createXMLHttpRequest();
	            var uniqueID = "";
	            var fd = new FormData();
	            var imgDiv = document.getElementById("addimagecontent");
	            uniqueID =  GetAttribute(document.getElementsByName('movieView')[0], 'uniqueid');
	            
	            if (uniqueID == null || uniqueID == "") {
	            	alert("<spring:message code='ezBoard.t601'/>");
		    		return;	
	            }
	            
	            console.log("uniqueID in delete      ::     " + uniqueID);
	            
	            xmlhttp.open("POST", "/ezBoard/boardMovieUpload.do?mode=DEL&boardID=" + pBoardID +"&uniqueID=" + uniqueID, false);
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
		            xhr.open("POST", "/ezBoard/boardMovieUpload.do?mode=MOVIE&boardID=" + pBoardID + "&fileLimit=" + AttachLimit);
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
		        document.getElementById("file1").value = "";
		        returnvalue(xhr.responseText);
		        isfileup = false;
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
		    
		    /* 2018-11-05 홍승비 - HTML5 지원 동영상파일 확장자체크 추가 */
		    function compareExtension(check, extension) {
	    		var filterExtension = new Array("mp4", "ogg", "webm");
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
			 	// 썸네일 이미지의 크기는 71.4px * 50px
			 	// png가 네모의 좌측상단에 붙어서? 생성되므로 캔버스 트기를 조정한다.
			 	canvas.width = 71.4;
			 	canvas.height = 50;
			    canvas.getContext("2d").drawImage(video, 0, 0, 71.4, 50);
			 	
			 	console.log(video);
			 	
			 	return canvas.toDataURL();
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
	          <th style="width:100px; text-align:center""> </th>
	          <td style="width:70%" id="tdBoardName">${boardInfo.boardName}</td>
	          <th style="width:80px; text-align:center"><spring:message code='ezBoard.t207'/></th>
	          <td style="width:120px; text-align:center">${userInfo.displayName1}</td>
	        </tr>
	        <tr>
	          <th style="text-align:center"><spring:message code='ezBoard.t208'/></th>
	          <td colspan="3" style="width:100%; vertical-align:middle; padding:0px 5px 0px 3px; margin:0;"><INPUT type="text" id="txtTitle" style="WIDTH:100%;word-wrap:break-word;word-break:break-all; border:1px solid #ddd; margin:0px; padding:2px 0px 2px 0px;" value="<c:out value='${boardListVO.title}'/>" maxlength="100" /></td>
	        </tr>
	        <tr style="display:none;">
	          <th><spring:message code='ezBoard.t1001'/></th>
	          <td class="pos1" colspan="3" style="width:100%;"><input style="width:600px;" id="fileData" name="fileData" type="file" onchange="fileUploadPreview(this, 'preView')" /></td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezQuestion.t180'/><spring:message code='ezCommunity.t18'/></th>
	            <td colspan="3" style="height:100px; margin:0; padding:3px 5px 3px 3px;"><textarea style="width:100%; height:100px; margin:0; padding:0; border:1px solid #ddd;" id="movieContent" wrap="hard">${boardListVO.mainContent}</textarea></td>
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
	        <div id="addimagecontent" style="overflow:auto;width:100%;height:423px; vertical-align:top" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)"></div>
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
	  </tr>

	    </table>
	    <div id="progdiv" class="progarea" style="z-index:6000;position:absolute;top:370px;left:227px;display:none">
	        <P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
	    </div>
	</body>
</html>