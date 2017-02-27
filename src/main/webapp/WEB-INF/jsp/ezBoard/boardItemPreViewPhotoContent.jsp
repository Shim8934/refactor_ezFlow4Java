<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE HTML>
<html>
	<head>
		<title><spring:message code="ezBoard.t293"/></title>
		<link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<STYLE title="ezform_style_1">
		P {
				MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm
		  }
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
		
		        if (g_progresswin) g_progresswin.close();
		
		        window_resize();
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
	            xmlhttp.open("POST", "/ezBoard/checkIfHasReply.do?itemList=" + pItemID + ",;", false);
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
	
	            window.location.href = "/ezBoard/boardNewItem.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&mode=reply"
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
	            xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
	            xmlhttp.send();
	            var xmldom = createXmlDom();
	            
	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;
	            strHTML = "";
	            var temp;
	            for (var i = 0; i < xmldom.getElementsByTagName("REPLYID").length; i++) {
	                temp = i + 1;
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
	
	            var mainfilename = imagefilename.src.split("s_")[0] + imagefilename.src.split("s_")[1];
	
	            viewimage = imagefilename.id;
	
	            document.getElementById("mainimages").src = mainfilename;
	            document.getElementById("mainimages").name = imagefilename.name;
	            document.getElementById("MainContent").innerHTML = imagefilename.title;
	
	            imageloding();
	            
	        }
	
	        function imageloding() {
	            var loading = 1000;
	
	            var newiamge = new Image();
	            newiamge.src = document.getElementById("mainimages").src;
	            var we = newiamge.width;
	            var he = newiamge.height;
	
	            if (we == 0 && he == 0) {
	                var endloading = loading + loading;
	                setTimeout("imageloding()", endloading);
	            }
	            
	            if (we > 400)
	                document.getElementById("mainimages").width = 400;
	            else
	                document.getElementById("mainimages").width = we;
	
	            if (he > 300)
	                document.getElementById("mainimages").height = 280;
	            else
	                document.getElementById("mainimages").height = he;
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
	
	            var mainfilename = document.getElementById(pageimage).src.split("s_")[0] + document.getElementById(pageimage).src.split("s_")[1];
	            ImageMain(document.getElementById(pageimage));
	        }
	        function showHideLayers() {
	            showDiv.style.display = "block";
	        }
	
	        function bt(id, after) { document.getElementById(id).src = after; }
	
	
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
	
	        function imageonmouse(reslut) {
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
	
	            document.getElementById(reslut).style.border = "#2e71ff 3px solid";
	            document.getElementById(reslut).style.margin = "0px 4px";
	            document.getElementById(reslut).style.width = imgWidth;
	            document.getElementById(reslut).style.height = imgHeight;
	            if (CrossYN())
	                document.getElementById(reslut).style.opacity = "1";
	            else
	                document.getElementById(reslut).style.filter = "Alpha(Opacity=100)";
	        }
	
	        function imagemouseover(image) {
	            if (document.getElementById("mainimages").name == image.name)
	                return;
	            if (CrossYN())
	                image.style.opacity = "1";
	            else
	                image.style.filter = "Alpha(Opacity=100)";
	            image.style.border = "#2e71ff 3px solid";
	            image.style.margin = "0px 4px";
	        }
	        function imagemouseout(image) {
	            if (document.getElementById("mainimages").name == image.name)
	                return;
	
	            if (CrossYN())
	                image.style.opacity = "0.35";
	            else
	                image.style.filter = "Alpha(Opacity=35)";
	            image.style.border = "1px solid #ffffff";
	            image.style.margin = "0px 4px";
	        }
	
	        function pageimageover() {
	            var endpage = pPage * 10;
	            if (imagetotalcount >= endpage && pPage == 1) {
	                document.getElementById("SmallImageNext").style.display = "";
	
	            }
	            else if (pPage == 1 && imagetotalcount < 10) {
	                document.getElementById("SmallImagePrev").style.display = "none";
	                document.getElementById("SmallImageNext").style.display = "none";
	            }
	            else if (pPage == 1 && endpage > 10) {
	                document.getElementById("SmallImagePrev").style.display = "none";
	                document.getElementById("SmallImageNext").style.display = "";
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
			</script>
		</head>
		<body>
			<table class="layout" style="border-spacing:0; border-bottom:1px solid #b6b6b6; border:0px; width:100%; margin-top:-1px;">
			  <tr>
			    <td style="width:100%;  text-align:center; vertical-align:top;" >
			        <table style="width:100%; border:1px solid #b6b6b6; border-left:1px solid #FFFFFF;">
					  <tr>
			        	<td style="height:68px;" colspan="3">
			            </td>
			        </tr>
			        <tr id="trheight">
			            <td style="width:100px; padding-left:50px; text-align:center">
			                <img src="/images/etc/btn_005.gif" style="border:0;cursor:pointer;" onclick="Pagenationimage('prevPage');" />
			            </td>
			            <td style="padding-left:15px">
			                <table id="imagetable" style="text-align:center; border:0px;">
			                    <tr>  
			                        <td style="width:400px;height:300px; min-height:300px; border:8px solid #e3e1e2; text-align:center" id="imageTD">
			                            <img id="mainimages" onclick="window.open(this.src)" style="background-color:#ffffff;cursor:pointer;" src=""/>            
			                        </td>
			                    </tr>
			                    
			            </table>
			            </td>
			            <td style="width:100px; padding-right:50px; text-align:center">
			                <img src="/images/etc/btn_006.gif" style="border:0;cursor:pointer;" onclick="Pagenationimage('nextPage');" />
			            </td>
			        </tr>
			        <tr>
			        	<td style="padding:10px 0px; height:88px; text-align:center" colspan="3">
			            	<div id="MainContent" style="height:88px;overflow:auto;"></div>
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
					<div style="background:#e5e5e5; border:1px solid #b6b6b6; border-top:0 none; height:70px; text-align:center; padding-top:30px;">
		            <table border="0">
		                <tr>
		                    <td style="width:30px; padding-bottom:5px; vertical-align:bottom; text-align:left" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/etc/btn_001.gif" id="SmallImagePrev" style="border:0;cursor:pointer;" onclick="btn_SmallIamge('Prev')" />
		                    </td>
		                    <td onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <div class="content" id="viewBox" style="width:100%; border:0;" ></div>
		                    </td>
		                    <td style="width:30px; padding-bottom:5px; vertical-align:bottom; text-align:right" onmouseover="pageimageover()" onmouseout="pageimageout()">
		                        <img src="/images/etc/btn_002.gif" id="SmallImageNext" style="border:0;cursor:pointer;" onclick="btn_SmallIamge('Next')" />
		                    </td>
		                </tr>
		            </table>
				</div>
		        </td>
		    </tr>
		</table>
	</body>
</html>