<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t316'/></title>
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
        <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
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
	    <script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script> 
        <script type="text/javascript">
	        var movieID = "${movieID}";
	        var pBoardID = "${boardID}";
	        var AttachLimit = "${boardInfo.attachSizeLimit}";
	        var pMod = "Mod";
	        var PhotoBoard = "N";
	        var pAttachListXml = "";
	        var moviePath = "${moviePath}";
	        var ImgaeReturnXml = "";
	        var pItemID = "${itemID}";
	        var pGubun = "${guBun}";
	        var pNoneActiveX = "YES";
	        function window_onload() {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                document.getElementById("file1").multiple = false;
	            }
	            
	            document.getElementById("mainVideo").setAttribute("movieid", movieID);
	        }
	        
	        function uploadComplete() {
				document.getElementById("file1").value = "";
				returnvalue(xhr.responseText);
		    }
	        
	        function MovieTemp_onclick() {
	        	if (document.form.file1.value != "") {
	        		var fd = new FormData();
	        		var file1val = document.getElementById("file1").files[0].name;
	        		var exIndex = file1val.lastIndexOf('.');
		            var extension = file1val.substring(exIndex+1, file1val.length);
		            var check = false;
		            check = compareExtension(check, extension);
		            
		            console.log("수정 시 동영상 확장자     ::    " + extension);

		            if (!check) {
		            	document.getElementById("file1").files[0] = "";
			        	alert("<spring:message code ='ezBoard.hsb05' />");
		                return;
		            } else {
	                	fd.append("file1", document.getElementById("form").file1.files[0]);
			        }
		            
		         //   fd.append("mode", document.getElementById("mode").value);
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            xhr.open("POST", "/ezBoard/boardMovieUpload.do?mode=MOVIE&boardID=" + pBoardID + "&fileLimit=" + AttachLimit);
		            xhr.send(fd);
		        }
	        }
	        
	        function btn_MovieSave() {
				pFlag = "Y"; // 동영상게시물은 무조건 메인플래그 사용(썸네일 이미지가 하나이므로)
                var nodes;
                var rtnMode;
                var movieFileName;
                var moviePath;
                var orgFileName = "";
                
                if (ImgaeReturnXml != "") {
                    nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
/* 
                    rtnMode = getNodeText(GetChildNodes(nodes[0])[5]);
                    movieFileName = getNodeText(GetChildNodes(nodes[0])[0]); // THUMBNAILNAME (s_{GUID})*/
                    
                    var rtnMode = getNodeText(GetChildNodes(nodes[0])[5]); // MODE
    	            var movieFileName = getNodeText(GetChildNodes(nodes[0])[0]); // THUMBNAILNAME (s_{GUID})
    	            var localFileName = getNodeText(GetChildNodes(nodes[0])[2]); // PFILENAME
    	            var movieFileSize = getNodeText(GetChildNodes(nodes[0])[3]); // FILESIZE
    	            var movieUniqueID = getNodeText(GetChildNodes(nodes[0])[6]); // UNIQUEID ({GUID})
    	            orgFileName = getNodeText(GetChildNodes(nodes[0])[7]);
    	            
                    moviePath = "tempUploadFile/" + movieUniqueID;

                } else {
                    if (pFlag == "Y"){
                    	pMod = "FLAG";
                    }
                }
                
                // 저장조건체크 이후, 동영상에서 썸네일 추출하여 업로드 (동기적으로 사용하므로 false 처리)
	            var fd2 = new FormData();
		        var thumbnail = makeThumbnail("mainVideo");
		        fd2.append("thumbnail", thumbnail);
		        
		        xhr2 = new XMLHttpRequest();
	            xhr2.open("POST", "/ezBoard/boardMovieThumb.do?thumbnailID=" + movieFileName + "&fileLimit=" + AttachLimit, false);
	            xhr2.send(fd2);
			    
	            console.log(thumbnail);
                
                var strXML = "";
                strXML = "<DATA>";
                strXML += "<NODE>";
                strXML += "<IMAGEID>" + movieID + "</IMAGEID>"; // 기존 IMAGEID를 조건으로 걸어 PHOTO테이블 업데이트하므로
                strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
                if (moviePath == undefined) {
                    strXML += "<FILEPATH></FILEPATH>";
                }
                else {
					strXML += "<FILEPATH><![CDATA[" + moviePath + "]]></FILEPATH>";
                }
                strXML += "<CONTENT></CONTENT>";
                strXML += "<MAINFG>" + pFlag + "</MAINFG>";
                strXML += "<ITEMID>" + pItemID + "</ITEMID>";
                strXML += "<OFILENAME>" + orgFileName + "</OFILENAME>";
                strXML += "</NODE>";
                strXML += "</DATA>";

                var xmlhttp = createXMLHttpRequest();
                var xmldom = createXmlDom();

                xmldom.async = false;
                xmldom.preserveWhiteSpace = true;
                xmldom = loadXMLString(strXML);

                xmlhttp.open("POST", "/ezBoard/deleteImageItem.do?mod=" + pMod + "&gubun=" + pGubun, false);
                xmlhttp.send(xmldom);

                if (xmlhttp.responseText == "OK") {
                    alert("<spring:message code='ezBoard.hsb08'/>");
                    window.opener.window_reload();
                    window.close();
                }
                else {
                    alert("<spring:message code='ezBoard.hsb09'/>");
                }
	        }
	
	        function returnvalue(strXML) {
	            ImgaeReturnXml = loadXMLString(strXML);
	            var nodes = SelectNodes(ImgaeReturnXml, "ROOT/NODES/NODE");
	            var rtnMode = getNodeText(GetChildNodes(nodes[0])[5]); // MODE
	            var movieFileName = getNodeText(GetChildNodes(nodes[0])[0]); // THUMBNAILNAME (s_{GUID})
	            var movieUniqueID = getNodeText(GetChildNodes(nodes[0])[6]); // UNIQUEID ({GUID})
	            
	            console.log("동영상 임시 업로드 이후");
		        console.log(nodes.length);
		        console.log(ImgaeReturnXml);
		        console.log("rtnMode    ::    " + rtnMode);
		        console.log("movieFileName    ::    " + movieFileName);

	            document.getElementById("mainVideo").src = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUMTEMP&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(movieUniqueID);
	            document.getElementById("mainVideo").name = movieUniqueID;
	        }
	
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
	        
	        function btn_movieChange() {
				document.getElementById('mode').value = "PHOTO";
				document.form.file1.click();
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
   		<c:if test="${!isCrossBrowser}">
	   		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
		        Append_AttachAdd(filename);
			</script>
   		</c:if>
	</head>
	<body class="popup" onLoad="window_onload()" style="overflow:hidden;">
	    <table class="layout">
	        <tr>
	            <td style="vertical-align:top">
	                <div id="menu">
	                    <ul>
	                        <li><span onClick="btn_MovieSave()"><spring:message code='ezBoard.t98'/></span></li>
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
	    	        <ul id = "btnUl"><li><span style="border:1px solid #d2d2d2" onClick="btn_movieChange()"><spring:message code='ezQuestion.t180'/><spring:message code='ezBoard.t47'/></span></li></ul>
	            </th>
	        </tr>
	        <tr>
	            <td style="width:100%; height:250px; border:1px solid #ddd; padding:5px;background:#e5e5e5;" >
	                <div class="viewbox" style="width:100%; border:0 none; padding:0; background:none;">
	                	<%-- 2018-06-12 홍승비 - 사진수정 시 이미지 비율 유지 --%>
		                    <table style="width:100%; min-height:241px;">
		                        <tr>
		                            <td style="text-align:center">
		                                <span id='imagechange1' class='preView' style='display:none;' value=""></span>
		                                <video src="${moviePath}" id="mainVideo" style="cursor:pointer;max-width:430px; min-height:241px;" controls />
		                            </td>
		                        </tr>
		                    </table>
	                </div>
	            </td>
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
	    <input type="text" id="txtPhotoFile" style="WIDTH:85%; display:none" readonly >
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	
	    <form method="post" id="form" name="form" enctype="multipart/form-data" action="" target="ifrm">
	    <input type="file" name="file1" id="file1"  style="display: none;" onChange="MovieTemp_onclick()" accept="video/*"/>
	    <input type="hidden" name="mode" id="mode" />
	    </form>
	</body>
</html>