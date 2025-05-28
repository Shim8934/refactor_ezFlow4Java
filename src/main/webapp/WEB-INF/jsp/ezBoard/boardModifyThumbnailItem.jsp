<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t316'/></title>
	    <style type="text/css">
	         .preView { 
	         	width: 150px; 
	         	height: 150px; 
	         	text-align: center; 
	         	border:1px solid silver; 
	         }
	         #btnUl {
	         	display:table;
	         	margin:0px auto 0px auto;
	         }
	         #btnUl  li {
	         	display: inline-block;
				margin:0px;
				cursor:pointer;
	         }
	         #btnUl li span {
	         	display:inline-block; 
	         	background:white; 
	         	border:1px solid rgba(188, 211, 224, 1); 
	         	height:25px;
	         	padding:0px 8px 0px 8px;
	         	border-radius:3px; 
	         	line-height:25px;
	         	font-weight: normal;
	         	color:#333;
	         	vertical-align:middle;
	         }  
	    </style>
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
        <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script> 
        <script type="text/javascript">
	        var movieID = "${movieID}";
	        var pBoardID = "${boardID}";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pMod = "Mod";
	        var PhotoBoard = "N";
	        var pAttachListXml = "";
	        var thumbnailPath = "${thumbnailPath}";
	        var ImgaeReturnXml = "";
	        var pItemID = "${itemID}";
	        var pGubun = "${guBun}";
	        var pNoneActiveX = "YES";
	        var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
	        var addThumbnail = "${addThumbnail}";
	        var thumbnailExt = "${thumbnailExt}"
	        var movieVal = "${movieVal}"
	        var imgUniqueID = "";
	        var imageName = "${imageName}";
	        
	        function window_onload() {
                var imgSrc = thumbnailPath.replace(/{/gi,"%7B").replace(/}/gi,"%7D");
                document.getElementById("image1").src = imgSrc;
                if (addThumbnail == "N") {
                	document.getElementById("image1").style.height = "200px";
                }
	        }
	        
	        function uploadComplete() {
				document.getElementById("file1").value = "";
				returnvalue(xhr.responseText);
		    }
	        
	        function imgtemp_onclick() {
	        	if (document.form.file1.value != "") {
	        		var fd = new FormData();
	        		var file1val = document.getElementById("file1").files[0].name;
	        		var exIndex = file1val.lastIndexOf('.');
		            var extension = file1val.substring(exIndex+1, file1val.length);
		            var check = false;
		            check = compareExtension(check, extension);
		            
		            if (!check) {
		            	document.getElementById("file2").files[0] = "";
		            	alert("<spring:message code ='ezBoard.hsbImg01' />");
		                return;
		            } else {
	                	fd.append("file2", document.getElementById("form").file1.files[0]);
			        }
		            
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardImageUpload.do?mode=THUMBNAIL&boardID=" + encodeURIComponent(pBoardID) + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		        }
	        }
	        
	        function btn_ThumbnailSave() {
				pFlag = "Y"; // 동영상게시물은 무조건 메인플래그 사용(썸네일 이미지가 하나이므로)
                var nodes;
                var rtnMode;
                var movieFileName;
                var thumbnailPath;
                var orgFileName = "";
                
                if (ImgaeReturnXml != "") {
                    nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
                    
                    var rtnMode = getNodeText(GetChildNodes(nodes[0])[5]); // MODE
    	            var movieFileName = getNodeText(GetChildNodes(nodes[0])[0]); // THUMBNAILNAME (s_{GUID})
    	            var localFileName = getNodeText(GetChildNodes(nodes[0])[2]); // PFILENAME
    	            var movieFileSize = getNodeText(GetChildNodes(nodes[0])[3]); // FILESIZE
    	            var movieUniqueID = getNodeText(GetChildNodes(nodes[0])[6]); // UNIQUEID ({GUID})
    	            orgFileName = getNodeText(GetChildNodes(nodes[0])[7]);
    	            
    	            
                } else {
                    if (pFlag == "Y"){
                    	pMod = "FLAG";
                    }
                }
                
                // 저장조건체크 이후, 동영상에서 썸네일 추출하여 업로드 (동기적으로 사용하므로 false 처리)
	            var fd2 = new FormData();
		        //var thumbnail = makeThumbnail("mainVideo");
		        var thumbnail = movieFileName;
		        fd2.append("thumbnail", thumbnail);
		        
		        xhr2 = new XMLHttpRequest();
	            xhr2.open("POST", "/ezBoard/boardMovieThumb.do?thumbnailID=" + encodeURIComponent(movieVal) + "&fileLimit=" + AttachLimit + "&addThumbnail=Y", false);
	            xhr2.send(fd2);
	            
	            var thumbnailResult = getNodeText(SelectNodes(loadXMLString(xhr2.responseText), "ROOT/NODES/NODE/THUMBNAILNAME")[0]);
	            var thumbnailExt = thumbnailResult.substring(thumbnailResult.lastIndexOf(".") + 1);
	            thumbnailPath = "tempUploadFile/" + thumbnailResult;
	            
                var strXML = "";
                strXML = "<DATA>";
                strXML += "<NODE>";
                strXML += "<IMAGEID>" + movieID + "</IMAGEID>"; // 기존 IMAGEID(movieID)를 조건으로 걸어 PHOTO테이블 업데이트
                strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
                if (thumbnailPath == undefined) {
                    strXML += "<FILEPATH></FILEPATH>";
                }
                else {
					strXML += "<FILEPATH><![CDATA[" + thumbnailPath + "]]></FILEPATH>";
                }
                strXML += "<CONTENT></CONTENT>";
                strXML += "<MAINFG>" + pFlag + "</MAINFG>";
                strXML += "<ITEMID>" + pItemID + "</ITEMID>";
                strXML += "<OFILENAME>" + imageName + "</OFILENAME>";
                strXML += "<EXT>" + thumbnailExt + "</EXT>";
                strXML += "<ADDTHUMBNAIL>Y</ADDTHUMBNAIL>";
                strXML += "</NODE>";
                strXML += "</DATA>";

                var xmlhttp = createXMLHttpRequest();
                var xmldom = createXmlDom();

                xmldom.async = false;
                xmldom.preserveWhiteSpace = true;
                xmldom = loadXMLString(strXML);

                xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=" + pMod + "&gubun=" + pGubun + "&modifyThumb=Y", false);
                xmlhttp.send(xmldom);

                if (xmlhttp.responseText == "OK") {
                	sendBoardAlert("modify", pBoardID, pItemID, isAllGroupBoard); // 창이 닫히기 전 지연 시간이 필요하므로 alert 이전에 동작시킴
                	
                	parent.addThumbnail = "Y";

                    alert("<spring:message code='ezBoard.thumbnail.kwc003'/>");
                    
                    window.opener.window_reload();
                    window.opener.opener.getBoardList();
                    window.close();
                }
                else {
                    alert("<spring:message code='ezBoard.thumbnail.kwc004'/>");
                }
	        }
	
	        function returnvalue(strXML) {
	        	/* 2021-12-08 홍승비 - 동영상 게시물 동영상 수정 시 서버단에서도 이미지 확장자 체크 진행 */
				if (strXML == "UPLOAD_EXT_ERROR") {
			        alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					return;
				}
	        	
	            ImgaeReturnXml = loadXMLString(strXML);
	            var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
	            var rtnMode = getNodeText(GetChildNodes(nodes[0])[5]); // MODE
	            var imageFileName = getNodeText(GetChildNodes(nodes[0])[0]); // THUMBNAILNAME (s_{GUID})
	            var localFileName = getNodeText(GetChildNodes(nodes[0])[2]);
	            var imgFileSize = getNodeText(GetChildNodes(nodes[0])[3]);
	            imgUniqueID = getNodeText(GetChildNodes(nodes[0])[6]); // UNIQUEID ({GUID})
	            
	            document.getElementsByTagName("IMG")[0].src = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(imageFileName);
	        }
	       	
	        function btn_movieChange() {
				document.form.file1.click();
			}
	        
	        /* 2018-11-05 홍승비 - HTML5 지원 동영상파일 확장자체크 추가 */
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
			
   		</script>
	</head>
	<body class="popup" onLoad="window_onload()" style="overflow:hidden;">
	    <table class="layout">
	        <tr>
	            <td style="vertical-align:top">
	                <div id="menu">
	                    <ul>
	                        <li><span onClick="btn_ThumbnailSave()"><spring:message code='ezBoard.t98'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li ><span onClick="window.close()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <th style="height:28px; line-height:28px; border-bottom:0 none; background:#fff;">
	    	        <ul id = "btnUl"><li><span style="border:1px solid #d2d2d2" onClick="btn_movieChange()"><spring:message code='ezBoard.thumbnail.kwc001'/><spring:message code='ezBoard.t47'/></span></li></ul>
	            </th>
	        </tr>
	        <tr>
	            <td style="width:100%; height:250px; border:1px solid #ddd; padding:5px;background:#e5e5e5;" >
	                <div class="viewbox" style="width:100%; border:0 none; padding:0; background:none;">
						<table style="width:100%; min-height:241px;">
	                        <tr>
	                            <td style="text-align:center">
	                                <span id='imagechange1' class='preView' style='display:none;' value=""></span>
	                                <!-- <div id="addimagecontent" style="cursor:pointer;max-width:430px; min-height:241px;" /> -->
	                                <img src='' id='image1' name='zb_target_resize' style='cursor:pointer;max-height:230px;max-width:429px;'/>
	                            </td>
	                        </tr>
	                    </table>
	                </div>
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
	    <input type="file" name="file1" id="file1"  style="display: none;" onChange="imgtemp_onclick()" accept="image/*"/>
	    <input type="hidden" name="mode" id="mode" />
	    </form>
	</body>
</html>