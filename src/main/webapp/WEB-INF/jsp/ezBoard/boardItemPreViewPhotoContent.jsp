<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE HTML>
<html>
	<head>
		<title><spring:message code="ezBoard.t293"/></title>
		<link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<STYLE title="ezform_style_1">
			P {
					MARGIN-TOP: 0mm;
					MARGIN-BOTTOM: 0mm;
			  }
		  	<%-- 2018-07-24 홍승비 - 썸네일/포토게시물 미리보기 이미지 클릭 시 레이어팝업 추가 --%>
			.imgPopup{position: relative; float: left; max-width: 400px; max-height: 400px; cursor:pointer;}
			.imgPopupMagnify{position: relative; float: left; cursor: pointer;}
			.imgPopupBox{width: 500px;height: 500px; position: absolute; background: rgba(0,0,0,0.4); border-radius: 30px;}
			.imgPopupBoxMagnify{width: 685px;height: 614px; position: absolute; background: rgba(0,0,0,0.4); border-radius: 30px; z-index: 5;}
			.imgPopupDivMagnify{width: 655px; max-width:650px; height:530px; overflow:auto; margin:0px auto;}
			.imgPopupDiv{width:400px; height:400px; margin:0px auto;}
			.imgPopupBoxOff, .imgPopupOff{display: none;}
			.imgNotAttached{vertical-align: middle; margin: 0px auto; display: block; border: 1px dotted #cfcfcf; width: 33px; padding: 5px 2px 2px 5px;}
			.iPBInnerDiv_Top{display:inline-block; float:right; width:40px; margin-top: 15px;}
			.iPBInnerDiv_Top i{font-size:25px; color:black; cursor:pointer;}
			.iPBInnerDiv_TopOff{display:none; float:right; width:40px;}
			.iPBInnerDiv{height:50px; padding-right: 15px}
		</STYLE>
		<script type="text/javascript">
		    window.offscreenBuffering = true;
		    var xmlhttp = createXMLHttpRequest();
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var pItemID = "${itemID}";
			var pBoardID = "${boardID}";
		    var pBoardName = "${boardInfo.boardName}";
		    var pTitle = "";
		    var strWriterID = "";
		    var strWriterName = "";
		    var strWriterDeptName = "";
		    var strWriterCompanyName = "";
		    var strWriteDate = "";
		    var strImportance = "";
		    var strEndDate = "";
		    var strContentLocation = "";
		    var strAttachList = "";
		    var SSUserID = "${userInfo.id}";
		    var SSUserName = "${userInfo.displayName}";
		    var Access_FG = "${boardInfo.access_FG}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var ListView_FG = "${boardInfo.listView_FG}";
		    var Read_FG = "${boardInfo.read_FG}";
		    var Write_FG = "${boardInfo.write_FG}";
		    var Reply_FG = "${boardInfo.reply_FG}";
		    var Delete_FG = "${boardInfo.delete_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var pReservedItem = "";
		    var g_progresswin;
		    var OneLineReplyFlag = "";
			var gubun = "${boardInfo.guBun}";
		    var ImageCount = "";
		    var viewimage = "";
		    var pListImage = "";
		    var pImageID = "";
		    var pListImageContent = "";
		    var resultimage = "";
		    var pPage = 1;
		    var imagepage = "0";
		    var imagetotalcount = "";
		    var imgWidth = "57px";
		    var imgHeight = "37px";
		    window.onresize = window_resize;
		    window.onload = function () {
		        imageViewInit();
		        pageimageout();
		        AddLinkTarget();
		
		        if (g_progresswin) {
		        	g_progresswin.close();
		        }
		
		        window_resize();
		        
		        /* 2018-07-24 홍승비 - 투표 모듈의 이미지 레이어팝업 포토+썸넬게시물 미리보기에도 적용 */
	            addThumbnailEvent();
		    }
		    function window_resize() {
		        CurrentHeight = document.documentElement.clientHeight;
		        if (CurrentHeight < 317)
		            document.getElementById("trheight").style.height = 317 + "px";
		        else
		            document.getElementById("trheight").style.height = (CurrentHeight - 287) + "px";
		
		    }
	        function generateGuid() {
	            var result = "";
	            for (var i = 0, j = 0; j < 32; j++) {
	                if (j == 8 || j == 12 || j == 16 || j == 20) {
	                    result = result + "-";
	                }
	                i = Math.floor(Math.random() * 16).toString(16).toUpperCase();
	                result = result + i;
	            }
	            return "{" + result + "}";
	        }
	        
	        function GoTopNDownView() {
	            AGoTop.style.display = "";
	            AGoDown.style.display = "";
	        }
	
	        
	        function GoTopNDownHidden() {
	            AGoTop.style.display = "none";
	            AGoDown.style.display = "none";
	        }
	        
	        function AddLinkTarget() {
	            try {
	                
	                var objTags = message.txtContent.all.tags("a");
	
	                for (var i = 0 ; i < objTags.length ; i++) {
	                    if (objTags.item(i).href.indexOf("javascript:") == -1)
	                        objTags.item(i).target = "_blink";
	                }
	            }
	            catch (e) { }
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
	
	        
	        function ImageUrl(pUrl, cnt) {
	            var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl + "&Cnt=" + cnt;
	
	            return link;
	        }
	
	        function CheckIfHasReplies() {
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + encodeURIComponent(pItemID) + ",;", false);
	            xmlhttp.send();
	            if (xmlhttp.responseText == "FALSE") {
	                xmlhttp = null;
	                return false;
	            }
	            xmlhttp = null;
	            return true;
	        }
	
	        function btn_Reply_Onclick() {
	            if (Reply_FG != "true") {
	                alert("<spring:message code='ezBoard.t303'/>");
				    return;
				}
	
	            window.location.href = "/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID) + "&mode=reply"
	        }
	
	        function OneLineReply_onkeydown(e) {
	            if (e.keyCode == 13) {
	                e.returnValue = false;
	                e.cancelBubble = true;
	                Save_OneLineReply(e);
	            }
	        }
	
	        function Save_OneLineReply(e) {
	            if (Reply_FG != "true") {
	                alert("<spring:message code='ezBoard.t303'/>");
				    return;
				}
	
	            e.returnValue = false;
	            e.cancelBubble = true;
			    
	            if (OneLineReplyFlag == "1") {
	                if (document.getElementById("onelinereply").value == "") {
	                    alert("<spring:message code='ezBoard.t307'/>");
				        return;
				    }
	            }
			    
	            if (gubun == "2" && trim(document.getElementById("txtPassWord").value) == "") {
	                alert("<spring:message code='ezBoard.t391'/>");
				    txtPassWord.focus();
				    return;
				}
	
	            var pReplyID = "";
			    
	            pReplyID = generateGuid();
	
	            var strXML = "";
	
	            strXML += "<DATA>";
	            strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	            strXML += "<ITEMID>" + pItemID + "</ITEMID>";
	            strXML += "<REPLYID>" + pReplyID + "</REPLYID>";
			    
	            if (OneLineReplyFlag == "1") {
	                strXML += "<CONTENT>" + MakeXMLString(document.getElementById("onelinereply").value) + "</CONTENT>";
	                
	            }
	            else {
	                strXML += "<CONTENT></CONTENT>";
	            }
			    
	            strXML += "<PASSWORD></PASSWORD>";
	            strXML += "</DATA>";
	
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezBoard/saveOneLineReply.do", false);
	            xmlhttp.send(strXML);
	
	            if (xmlhttp.status == 200) {
	                xmlhttp = null;
				    
				    if (OneLineReplyFlag == "1")
				        document.getElementById("onelinereply").value = "";
	
				    getOneLineReply();
				}
	
	            xmlhttp = null;
	        }
	
	        function delete_onelinereply(pReplyID) {
	            var xmlhttp = createXMLHttpRequest();
	
	            
	            if (BoardAdmin_FG != "true" && BoardGroupAdmin_FG != "OK") {
	
	                xmlhttp.open("POST", "/ezBoard/checkOneLineOwner.do?replyID=" + pReplyID, false);
	                xmlhttp.send();
	
	                if (xmlhttp.responseText.substr(0, 2) != "OK") {
	                    alert("<spring:message code='ezBoard.t310'/>");
				        return;
				    }
	
	                if (!confirm("<spring:message code='ezBoard.t311'/>")) return;
	
				} else {
	
				    if (!confirm("<spring:message code='ezBoard.t311'/>")) return;
				}
	
	            xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + pReplyID + "&guBun=" + gubun, false);
	            xmlhttp.send();
	            getOneLineReply();
	            xmlhttp = null;
	        }
	
	        function getOneLineReply() {
	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(pItemID), false);
	            xmlhttp.send();
	            var xmldom = createXmlDom();
	            
	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;
	            strHTML = "";
	            var temp;
	            for (var i = 0; i < xmldom.getElementsByTagName("REPLYID").length; i++) {
	                temp = i + 1;
	                /* 2018-06-29 홍승비 -댓글쓴 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정헤야함 */
	                strHTML += "<font color=blue>" + temp.toString() + ". " + "<span style='cursor:pointer' onclick='OpenUserInfo(\"" + getNodeText(xmldom.getElementsByTagName("USERID").item(i)) + "\")'><font color=blue>" + getNodeText(xmldom.getElementsByTagName("USERNAME").item(i)) + "</font></span>(" + getNodeText(xmldom.getElementsByTagName("WRITEDATE").item(i)) + ")" + " : </font>" + getNodeText(xmldom.getElementsByTagName("CONTENT").item(i)) + " <img src='/images/oneline_delete.gif' style='cursor:pointer' onclick='delete_onelinereply(\"" + getNodeText(xmldom.getElementsByTagName("REPLYID").item(i)) + "\")'><p>";
	            }
	            if (i == 0)
	                strHTML = "<spring:message code='ezBoard.t312'/>";
	
	            try {
	                document.getElementById("onelinereplylist").innerHTML = strHTML;
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
	
	        function GoTop() {
	            message.AGoTop.click();
	        }
	
	        
	        function GoDown() {
	            message.AGoDown.click();
	        }
	
	        function ImageMain(imagefilename) {
	            imageonmouse(imagefilename.id);
	
	            var mainfilename = imagefilename.src;
	            if (imagefilename.src.indexOf("s_") > -1) {
	                mainfilename = imagefilename.src.split("s_")[0] + imagefilename.src.split("s_")[1];
	            }
	            
	            viewimage = imagefilename.id;
	
				document.getElementById("mainimages").style.display = "none";
	            document.getElementById("mainimages").src = mainfilename;
	            document.getElementById("mainimages").name = imagefilename.name;
	            document.getElementById("MainContent").innerHTML = imagefilename.title;
	
	            imageloding();
	        }
	
	        function imageloding() { 
	        	var newimage = new Image();
	            newimage.src = document.getElementById("mainimages").src;
	           
	           /* 2018-04-25 홍승비 - 기존 setTimeout을 이미지.onload로 수정 */
	            newimage.onload = function() {
		            var we = newimage.width;
		            var he = newimage.height;
	 
		            if (we > 400) {
		                document.getElementById("mainimages").width = 400;
		            } else {
		                document.getElementById("mainimages").width = we;
		            }
		            if (he > 300) {
		                document.getElementById("mainimages").height = 280;
		            } else {
		                document.getElementById("mainimages").height = he;
		            }
		            
		            document.getElementById("mainimages").style.display = "";
		            
		            /* 2018-06-01 홍승비 - 미리보기 이미지 사이즈 계산 수정 */
		            var maxWidth = 400;
		            var maxHeight = 280;
		            var ratio = 0;
	
		            if (we > maxWidth) {
		                ratio = maxWidth / we;
		                document.getElementById("mainimages").width = maxWidth;
		                document.getElementById("mainimages").height = he * ratio;
		
		                if (document.getElementById("mainimages").height > maxHeight) {
		                    ratio = maxHeight / document.getElementById("mainimages").height;
		                    document.getElementById("mainimages").height = maxHeight;
		                    document.getElementById("mainimages").width = document.getElementById("mainimages").width * ratio;
		                }
		            }
		            else {
		                if (he > maxHeight) {
		                    ratio = maxHeight / he;
		                    document.getElementById("mainimages").height = maxHeight;
		                    document.getElementById("mainimages").width = we * ratio;
		                }
		            }	            
		        }
	        }
	
	        function Pagenationimage(page) {
	            var pageimage = "";
	
	            for (var i = 0; i < ImageCount; i++) {
	                if (viewimage == "image" + i) {
	                    if (page == "prevPage") {
	                        if (i == 0) {
	                            btn_SmallIamge("Prev");
	                            return;
	                        }
	
	                        pageimage = "image" + (i - 1);
	                    }
	                    else if (page == "nextPage") {
	                        if (i == (ImageCount - 1)) {
	                            btn_SmallIamge('Nextimage');
	                            return;
	                        }
	                        else
	                            pageimage = "image" + (i + 1);
	                    }
	                }
	            }
	            viewimage = pageimage;
	            imageonmouse(pageimage);
	            ImageMain(document.getElementById(pageimage));
	        }
	        function showHideLayers() {
	            showDiv.style.display = "block";
	        }
	
	        function bt(id, after) {
	        	document.getElementById(id).src = after;
	        }
	
	
	        function page_reload() {
	            window.location.reload();
	        }
	
	        function btn_SmallIamge(Page) {
	            xmlhttp = createXMLHttpRequest();
	
	            var NewPage = "";
	
	            if (Page == "Next") {
	                var endpage = pPage * 10;
	                if (imagetotalcount <= endpage) {
	                    return;
	                }
	                else {
	                    imagepage = 0;
	                    NewPage = parseInt(pPage) + 1;
	                }
	            }
	            else if (Page == "Nextimage") {
	                var endpage = pPage * 10;
	
	                if (imagetotalcount <= endpage) {
	                    imagepage = 0;
	                    NewPage = 1;         
	                    
	                }
	                else {
	                    imagepage = 0;
	                    NewPage = parseInt(pPage) + 1;
	                }
	            }
	            else if (Page == "Prev") {
	                imagepage = 9;
	                if (pPage == 1) {
	                    if (imagetotalcount % 10 > 0) {
	                        pPage = Number(imagetotalcount / 10) + 2;
	                    } else {
	                        pPage = Number(imagetotalcount / 10) + 1;
	                    }
	                    imagepage = imagetotalcount % 10 - 1;
	                                  
	                }
	                NewPage = parseInt(pPage) - 1;
	            }
	
	            pPage = NewPage;
	
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/imageViewList.do",
					data : { boardID   : pBoardID, 
							 itemID    : pItemID,
							 page      : NewPage
						   },
					success: function(result){
						ImageViewTable(result);
					}        			
				});
	            
	            pageimageout();
	        }
	
	        function imageViewInit() {
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/imageViewList.do",
					data : { boardID   : pBoardID, 
							 itemID    : pItemID,
							 page      : "1"
						   },
					success: function(result){
						ImageViewTable(result);
					}        			
				});
	        }
	
	        function ImageViewTable(result) {
	            var pImagename = "";
	            pListImageContent = "";
	            pListImage = "";
	            pImageID = "";
	            resultimage = "";
	
	            var obj = document.getElementById("viewBox");
	            var obj2 = document.getElementById("viewboxlist");
	            if (obj.childNodes.length > 0) {
	                obj2.parentNode.removeChild(obj2);
	            }
	
	            var xmldom = createXmlDom();
	            
	            xmldom = loadXMLString(result);
	
	            imagetotalcount = getNodeText(xmldom.getElementsByTagName("IMAGECOUNT")[0]);
	
	            for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
	                pListImageContent += getNodeText(xmldom.getElementsByTagName("FILECONTENT")[i]) + "\\";
	                pListImage += getNodeText(xmldom.getElementsByTagName("FILEPATH")[i]) + ";";
	                pImageID += getNodeText(xmldom.getElementsByTagName("IMAGEID")[i]) + ";";
	                pImagename += getNodeText(xmldom.getElementsByTagName("IMAGENAME")[i]) + ";";
	            }
	
	            ImageCount = xmldom.getElementsByTagName("ROW").length;
	            
	            var result = pListImage.split(";");
	            var resultcount = result.length - 1;
	            var imagecontet = pListImageContent.split("\\");
	            var imageid = pImageID.split(";");
	            var imagename = pImagename.split(";");
	
	            document.getElementById("viewBox").innerHTML += "<span id='viewboxlist'>";
	            for (var i = 0; i < ImageCount; i++) {
	                var imgSrc = "/ezBoard/getBoardThumbnailInfo.do?type=BOARDTHUM&boardID=" + encodeURI(pBoardID) + "&fileName=" + encodeURI(result[i].split('/')[7]);
	                document.getElementById("viewboxlist").innerHTML += "<img src='" + imgSrc + "' style='border:0' title='" + imagecontet[i] + "' id='image" + i + "' name='" + imageid[i] + "' style='cursor:pointer;' onclick='ImageMain(this)' onmouseover='imagemouseover(this)' onmouseout='imagemouseout(this)'/>";
	                if (CrossYN())
	                    document.getElementById("image" + i).style.opacity = "0.35";
	                else
	                    document.getElementById("image" + i).style.filter = 'Alpha(Opacity=35)';
	
	                document.getElementById("image" + i).style.width = imgWidth;
	                document.getElementById("image" + i).style.height = imgHeight;
	
	            }
	            document.getElementById("viewBox").innerHTML += "<span>";
	
	            if (ImageCount != 0) {
	                ImageMain(document.getElementById("image" + imagepage));
	            }
	        }
	
	        function imageonmouse(result) {
	            for (var i = 0; i < ImageCount; i++) {
	                document.getElementById("image" + i).style.border = "";
	                document.getElementById("image" + i).style.margin = "0px 4px";
	                document.getElementById("image" + i).style.width = imgWidth;
	                document.getElementById("image" + i).style.height = imgHeight;
	                if (CrossYN())
	                    document.getElementById("image" + i).style.opacity = "0.35";
	                else
	                    document.getElementById("image" + i).style.filter = "Alpha(Opacity=35)";
	            }
	
	            document.getElementById(result).style.border = "#888 1px solid";
	            document.getElementById(result).style.margin = "0px 4px";
	            document.getElementById(result).style.width = imgWidth;
	            document.getElementById(result).style.height = imgHeight;
	            if (CrossYN())
	                document.getElementById(result).style.opacity = "1";
	            else
	                document.getElementById(result).style.filter = "Alpha(Opacity=100)";
	        }
	
	        /* 2018-06-01 홍승비 - 포토/썸네일게시물 미리보기 하단 UI 수정 */
	        function imagemouseover(image) {
	            if (document.getElementById("mainimages").name == image.name) {
	            	return;
	            }
	            if (CrossYN()) {
	            	image.style.opacity = "1";
	            } else {
	            	image.style.filter = "Alpha(Opacity=100)";
	            }
	            
	            image.style.border = "#888 0.015px solid";
	            image.style.margin = "0px 4px";
	        }
	        function imagemouseout(image) {
	            if (document.getElementById("mainimages").name == image.name) {
	                return;
	            }
	            if (CrossYN()) {
	                image.style.opacity = "0.35";
	            } else {
	                image.style.filter = "Alpha(Opacity=35)";
	            }
	            
	            image.style.border = "none";
	            image.style.margin = "0px 4px";
	        }
	        
	        /* 2018-06-01 홍승비 - 페이징 코드 수정, 도달 불가능 코드 삭제 */
	        function pageimageover() {
	            var endpage = pPage * 10;
	            
	            if (imagetotalcount > endpage && pPage == 1) {
	                document.getElementById("SmallImageNext").style.display = "";
	            }
	            else if (pPage == 1 && imagetotalcount <= 10) {
	                document.getElementById("SmallImagePrev").style.display = "none";
	                document.getElementById("SmallImageNext").style.display = "none";
	            }
	            else if (pPage != 1 && imagetotalcount <= endpage) {
	                document.getElementById("SmallImagePrev").style.display = "";
	                document.getElementById("SmallImageNext").style.display = "none";
	            }
	            else {
	                document.getElementById("SmallImagePrev").style.display = "";
	                document.getElementById("SmallImageNext").style.display = "";
	            }
	        }
	
	        function pageimageout() {
	            document.getElementById("SmallImagePrev").style.display = "none";
	            document.getElementById("SmallImageNext").style.display = "none";
	        }
	        
	        /* 2018-07-24 홍승비 - 미리보기 이미지 클릭 시 투표 모듈에서 가져온 레이어팝업 동작 */
		    var tempTimer;
		    function addThumbnailEvent(){
		  		$(document)
		    	.on("click", ".thumbCloseBtn", function(e){
					toggleImgPopupBox(e);
				}).on("click", ".thumbnail", function(e){
					toggleImgPopupBox(e);
				}).on("click", "#thumbMagnifyBtn", function(e){
					magnifyThumbnailSize();
				}).on("click", "#thumbZoomInBtn", function(e){
					zoomInImgPopup();
				}).on("mousedown", "#thumbZoomInBtn", function(e){
					e.target.style.color = "#0470e4";
					tempTimer = setInterval(zoomInImgPopup, 150);
				}).on("mouseup mouseleave", "#thumbZoomInBtn", function(e){
					e.target.style.color = "";
					if(tempTimer){
						clearInterval(tempTimer);
					}
				}).on("click", "#thumbZoomOutBtn", function(e){
					zoomOutImgPopup();
				}).on("mousedown", "#thumbZoomOutBtn", function(e){
					e.target.style.color = "#0470e4";
					tempTimer = setInterval(zoomOutImgPopup, 150);
				}).on("mouseup mouseleave", "#thumbZoomOutBtn", function(e){
					e.target.style.color = "";
					if(tempTimer){
						clearInterval(tempTimer);
					}
				}).on("click", "#imgPopup", function(e){
					var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var htmlString = "";
		            var imgPopupWindow = window.open("" , "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height="+ pheight + ",width="+ pwidth + ",top=0,left=0", "");
		            
					htmlString = "<html><head><title><spring:message code='ezPortal.t49'/></title></head>";
					htmlString += "<body style='margin:0px;text-align:center;' onClick='window.close()'>";
					htmlString += "<div style='height:" + pheight + "px;width:" + pwidth + "px;vertical-align:middle;display:table-cell;'><img style='cursor:pointer;' src=" + e.target.src + "/></div>";
					htmlString += "</body></html>";
					
					imgPopupWindow.document.write(htmlString);
					imgPopupWindow.document.close();
				});
		    }
		    
		  //썸네일에 마우스 오버할 때 처리.(thumbnail클래스 클릭하여 확대 레이어팝업 띄우는 함수)
		  	function thumbnailImgMouseOver(e){
	    		$("#imgPopupDiv, #imgPopupBox, #imgPopup").attr("style","");
	    		$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","none");
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var imgPopupBox = $("#imgPopupBox");
		  		var imgPopupDiv = $("#imgPopupDiv");
		  		var imgPopup = $("#imgPopup");
		  		
		  		imgPopupBox.removeClass("imgPopupBoxOff imgPopupBoxMagnify").addClass("imgPopupBox");
	    		imgPopupDiv.removeClass("imgPopupDivMagnify").addClass("imgPopupDiv");
	    		imgPopup.removeClass("imgPopupOff imgPopupMagnify").addClass("imgPopup");
	    		imgPopup.attr("src", e.target.src);
	    		
	    		// src에 부여된 height값 읽어오지 못한 경우(창 두개에서 동시에 레이어팝업 조작할 경우)
	    		if (imgPopup.height() == 0){
		    		imgPopup.load (function() {
		    			$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","");
		    			
	    				var imgPB_LeftOffset = (window.innerWidth - imgPopupBox.width()) / 2;
	    	    		var imgPB_TopOffset = ((window.innerHeight - 118) - imgPopupBox.height()) / 2  + window.pageYOffset;
	    	    		var imgP_LeftOffset = (imgPopup.parent().width() - imgPopup.width()) / 2;
	    	    		
	    	    		imgPopupBox.css({"left": imgPB_LeftOffset, "top": imgPB_TopOffset});
	    	    		imgPopupDiv.css({"width": imgPopup.prop("offsetWidth")});
	    	    		imgPopup.css({"left": "", "top": ((imgPopupBox.height() - imgPopup.height()) / 2) - iPBInnerDivH});
	    	    		imgPopup.attr("zoom","1");
		    		});
	    		} else {
	    			$("#imgPopupDiv, #imgPopupBox, #imgPopup").css("display","");
	    			
	    			var imgPB_LeftOffset = (window.innerWidth - imgPopupBox.width()) / 2;
    	    		var imgPB_TopOffset = ((window.innerHeight - 118) - imgPopupBox.height()) / 2  + window.pageYOffset;
    	    		var imgP_LeftOffset = (imgPopup.parent().width() - imgPopup.width()) / 2;
    	    		
    	    		imgPopupBox.css({"left": imgPB_LeftOffset, "top": imgPB_TopOffset});
    	    		imgPopupDiv.css({"width": imgPopup.prop("offsetWidth")});
    	    		imgPopup.css({"left": "", "top": ((imgPopupBox.height() - imgPopup.height()) / 2) - iPBInnerDivH});
    	    		imgPopup.attr("zoom","1");
	    		}
	    		
	    		$("#thumbMagnifyBtn").removeClass("fa fa-minus-square").addClass("fa fa-plus-square");
	    		$("#thumbZoomInBtn, #thumbZoomOutBtn").parent().removeClass("iPBInnerDiv_Top").addClass("iPBInnerDiv_TopOff");
		  	}
		  
		  //썸네일 원본 크기로 보기 기능.
		  	function magnifyThumbnailSize(){
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var imgPopupDiv = document.getElementById("imgPopupDiv");
	    		var imgPopup = document.getElementById("imgPopup");
	    		var $imgPopupBox = $("#imgPopupBox");
		  		var $imgPopupDiv = $("#imgPopupDiv");
		  		var $imgPopup = $("#imgPopup");
	    		
		  		if($("#thumbMagnifyBtn").attr("class").indexOf("plus") != -1){
		  			$("#thumbMagnifyBtn").attr("class","fa fa-minus-square");
		  			$imgPopupDiv.css("overflow", "auto");
		  		}
		  		else{
		  			$("#thumbMagnifyBtn").attr("class","fa fa-plus-square");
		  			$imgPopup.css("width", "");
		  			$imgPopupDiv.css("overflow", "");
		  		}
		  		$imgPopup.attr("zoom","1")
		  		
	    		$("#thumbZoomInBtn, #thumbZoomOutBtn").parent().toggleClass("iPBInnerDiv_TopOff iPBInnerDiv_Top");
				$imgPopupBox.toggleClass("imgPopupBox imgPopupBoxMagnify");
	    		$imgPopupDiv.toggleClass("imgPopupDiv imgPopupDivMagnify");
	    		$imgPopup.toggleClass("imgPopup imgPopupMagnify");
	    		
	    		//imgPopupBox frame 가운데로 위치 조정.
	    		$imgPopupBox.css("left",(window.innerWidth - $imgPopupBox.width()) / 2);
	    		var iPBTopOffset = ((window.innerHeight - 118) - $imgPopupBox.height()) / 2 + window.pageYOffset;
	    		
	    		if(iPBTopOffset < 0){
	    			$imgPopupBox.css("top", 10);
	    		}
	    		else{
		    		$imgPopupBox.css("top", iPBTopOffset);
	    		}
	    		$imgPopupDiv.width(imgPopup.offsetWidth);
	    		
	    		var imgPopupDivSH = imgPopupDiv.scrollHeight;
	    		var imgPopupDivCH = imgPopupDiv.clientHeight;
	    		var imgPopupCH = imgPopup.clientHeight;
	    		
	    		//imgPopup 세로 위치 조정.
	    		if( imgPopupCH > imgPopupDivCH && imgPopup.naturalHeight > 700 ){
	    			$imgPopup.css("top", 0);
	    		}else{
	    			$imgPopup.css("top",(($imgPopupBox.height() - $imgPopup.height()) / 2) - iPBInnerDivH);
	    		}
		  	}
		  	
		  	//썸네일 이미지 팝업박스를 토글해준다.
		  	function toggleImgPopupBox(e){
		  		var imgPopupBox = $("#imgPopupBox");
		  		var imgPopupDiv = $("#imgPopupDiv");
		  		var imgPopup = $("#imgPopup");
		  		
		  		$("#imgPopupDiv, #imgPopupBox, #imgPopup").attr("style","");
		  		
		  		//마우스 오버 이벤트 없애는 작업과 함께 이미지 뷰어가 보이는 상태에서 다른 그림 선택했을 때 처리하기 위해 수정. 2018-06-19 홍대표
		  		if(e.target.id != "thumbCloseBtn"){
		  			thumbnailImgMouseOver(e);
		  			return;
		  		}
		  		
		  		if(imgPopup.attr("src")){
			  		imgPopupBox.removeClass("imgPopupBox").addClass("imgPopupBoxOff");
			  		imgPopupDiv.removeClass("imgPopupDivMagnify").addClass("imgPopupDiv");
			  		imgPopup.removeClass("imgPopup").addClass("imgPopupOff");
			  		imgPopup.removeAttr("src");
		  		}
		  		else if(e.target.getAttribute("class") === "thumbnail"){
		  			thumbnailImgMouseOver(e);
		  		}
		  	}
		  	
		  	//줌인버튼 기능.
		  	function zoomInImgPopup(){
		  		var zoom = 1;
		  		var zoomOffset = 0.1;
		  		var $imgPopupBox = $("#imgPopupBox");
		  		var $imgPopupDiv = $("#imgPopupDiv");
		  		var $imgPopup = $("#imgPopup");
		  		var imgPopupOrignW =  $imgPopup.prop("naturalWidth");
		  		
		  		//zoom이 숫자가 아닌 다른 형태로 넘어올 때 처리.
		  		if($imgPopup.attr("zoom").indexOf("%") != -1){
		  			zoom = parseFloat($imgPopup.attr("zoom").replace("%", "") / 100) + zoomOffset;
		  		}
		  		else if($imgPopup.attr("zoom").indexOf("normal") != -1){
		  			zoom = 1 + zoomOffset;
		  		}
		  		else{
			  		zoom = parseFloat($imgPopup.attr("zoom")) + zoomOffset;
		  		}
		  		zoom = zoom.toFixed(1);
		  		$imgPopup.attr("zoom", zoom);
		  		
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var thumbImgH = $imgPopup.prop("naturalHeight") * zoom;
		  		var imgPopupDiv = document.getElementById("imgPopupDiv");
	    		var imgPopup = document.getElementById("imgPopup");
		  		var imgPopupDivCH = imgPopupDiv.clientHeight;
				$imgPopup.width(imgPopupOrignW * zoom);
				$imgPopupDiv.width(imgPopupOrignW * zoom);
		  		
		  		//imgPopup 세로 위치 조정.
		  		if(thumbImgH < (imgPopupDivCH - 100)){
		  			var topOffset = "";
					topOffset = ((($imgPopupBox.height() - thumbImgH) / 2) - iPBInnerDivH);
					
		  			$imgPopup.css("top", topOffset);
		  		}
		  		else if(thumbImgH > (imgPopupDivCH - 100)){
		  			$imgPopup.css("top", 0);
		  			$imgPopupDiv.css("overflow", "auto");
		  		}		
		  	}
		  	
		  	//줌아웃 버튼 기능.
		  	function zoomOutImgPopup(){
		  		var zoom = 1;
		  		var zoomOffset = 0.1;
		  		var $imgPopupBox = $("#imgPopupBox");
		  		var $imgPopupDiv = $("#imgPopupDiv");
		  		var $imgPopup = $("#imgPopup");
		  		var imgPopupOrignW =  $imgPopup.prop("naturalWidth");
		  		
		  		//zoom이 숫자가 아닌 다른 형태로 넘어올 때 처리.
		  		if($imgPopup.attr("zoom").indexOf("%") != -1){
		  			zoom = parseFloat($imgPopup.attr("zoom").replace("%", "") / 100) - zoomOffset;
		  		}
		  		else if($imgPopup.attr("zoom").indexOf("normal") != -1){
		  			zoom = 1 - zoomOffset;
		  		}
		  		else{
			  		zoom = parseFloat($imgPopup.attr("zoom")) - zoomOffset;
		  		}
		  		zoom = zoom.toFixed(1);
		  		
		  		// 0.1보다 작은 비율로는 축소 불가능
		  		if ( zoom >= 0.1 ) {
			  		$imgPopup.attr("zoom", zoom);
		  		} else {
		  			return;
		  		}
		  		
		  		var thumbImgW = imgPopupOrignW * zoom;
		  		var thumbImgH = $imgPopup.prop("naturalHeight") * zoom;
		  		var iPBInnerDivH = $(".iPBInnerDiv").height();
		  		var imgPopupDiv = document.getElementById("imgPopupDiv");
	    		var imgPopup = document.getElementById("imgPopup");
		  		var imgPopupDivCW = imgPopupDiv.clientWidth;
	    		var imgPopupDivCH = imgPopupDiv.clientHeight;
				$imgPopup.width(thumbImgW);
		    	$imgPopupDiv.width(thumbImgW);
		    		
	    		
		  		if(thumbImgW > (imgPopupDivCW - 100)){
		  			$imgPopup.css("left","");
		  		}
		  		
		  		//imgPopup 세로 위치 조정
		  		if(thumbImgH < (imgPopupDivCH - 100)){
		  			var topOffset = "";
			  		topOffset = ((($imgPopupBox.height() - thumbImgH) / 2) - iPBInnerDivH);
			  		
		  			$imgPopup.css("top", topOffset);
		  		}
		  		else if(thumbImgH > (imgPopupDivCH - 100)){
		  			$imgPopup.css("top", 0);
		  			$imgPopupDiv.css("overflow", "auto");
		  		}
		  	}
			</script>
		</head>
		<body>
			<table class="layout" style="border-spacing:0; border-bottom:1px solid #ddd; border:0px; width:100%; margin-top:-1px;">
			  <tr>
			    <td style="width:100%;  text-align:center; vertical-align:top;" >
			        <table style="width:100%; border:1px solid #ddd; border-left:1px solid #FFFFFF;">
					  <tr>
			        	<td style="height:68px;" colspan="3">
			            </td>
			        </tr>
			        <tr id="trheight">
			            <td style="width:100px; padding-left:50px; text-align:center">
			                <img src="/images/previous.png" style="width:70px;height:70px;border:0;cursor:pointer;" onclick="Pagenationimage('prevPage');" />
			            </td>
			            <td style="padding-left:22px">
			                <table id="imagetable" style="text-align:center; border:0px;">
			                    <tr>  
			                        <td style="width:400px;height:300px; min-height:300px; border:1px solid #e3e1e2; text-align:center" id="imageTD">
			                            <img id="mainimages" class="thumbnail" style="background-color:#ffffff;cursor:pointer;" src=""/>            
			                        </td>
			                    </tr>
			                    
			            </table>
			            </td>
			            <td style="width:100px; padding-right:50px; text-align:center">
			                <img src="/images/next.png" style="width:70px;height:70px;border:0;cursor:pointer;" onclick="Pagenationimage('nextPage');" />
			            </td>
			        </tr>
			        <tr>
			        	<td style="padding:10px 0px; height:88px; text-align:center" colspan="3">
			            	<div id="MainContent" style="height:88px; padding-left:23%; padding-right:24%;"></div>
			            </td>
			        </tr>
			        </table>
			    </td>
			  </tr>
		    <tr style="display:none;">
		        <td style="text-align:center">
		            <span id="Span1" ></span>
		        </td>
		    </tr>
		    <tr>
		        <td>
					<div style="background:#f8f8fa; border:1px solid #ddd; border-left:0px; border-top:0px; height:70px; text-align:center; padding-top:27px;">
		            <table border="0">
		                <tr>
		                    <td style="width:30px; padding-left:14px;padding-right:2px;padding-bottom:5px; vertical-align:bottom; text-align:left" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/previous.png" id="SmallImagePrev" style="width:30px;height:30px;border:0;cursor:pointer;" onclick="btn_SmallIamge('Prev')" />
		                    </td>
		                    <td onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <div class="content" id="viewBox" style="width:100%; border:0;" ></div>
		                    </td>
		                    <td style="width:30px; padding-bottom:5px; vertical-align:bottom; text-align:right" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/next.png" id="SmallImageNext" style="width:30px;height:30px;border:0;cursor:pointer;" onclick="btn_SmallIamge('Next')" />
		                    </td>
		                </tr>
		            </table>
				</div>
		        </td>
		    </tr>
		</table>
		
		  <%-- 2018-07-20 홍승비 - 이미지 클릭 시 레이어팝업 표출 --%>
	    <div id="imgPopupBox" class="imgPopupBoxOff">
			<div style="height:50px;" class="iPBInnerDiv">
    			<div class="iPBInnerDiv_Top">
    				<i id="thumbCloseBtn" class="fa fa-times-circle thumbCloseBtn"></i>
    			</div>
    			<div class="iPBInnerDiv_Top">
    				<i id="thumbMagnifyBtn" class="fa fa-plus-square thumbMagnifyBtn"></i>
    			</div>
    			<div class="iPBInnerDiv_TopOff">
    				<i id="thumbZoomInBtn" class="fa fa-search-plus"></i>
   				</div>
   				<div class="iPBInnerDiv_TopOff">
    				<i id="thumbZoomOutBtn" class="fa fa-search-minus"></i>
   				</div>
   			</div>
   			<div id="imgPopupDiv" class="imgPopupDiv">
				<img id="imgPopup" class="imgPopup">
   			</div>
   		</div>
	</body>
</html>