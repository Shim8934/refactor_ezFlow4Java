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
		        
		        if (g_progresswin) {
		        	g_progresswin.close();
		        }
		        
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
	        
	        function ImageUrl(pUrl, cnt) {
	            var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl + "&Cnt=" + cnt;
	
	            return link;
	        }
	
	     // 한줄답변 코드 주석처리
	       /* function CheckIfHasReplies() {
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
	            xmlhttp.open("POST", "/ezBoard/readOneLineReply.do?boardID=" + pBoardID + "&itemID=" + pItemID + "&gubun=" + gubun, false);
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
	        } */
	
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
	        
	        function movieMain(movieID, moviePath, movieName) {
	            document.getElementById("mainVideo").src = moviePath;
	            document.getElementById("mainVideo").setAttribute("movieid", movieID);
	            document.getElementById("mainVideo").title = movieName;
	        }
	        
	        function page_reload() {
	            window.location.reload();
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
	            var xmldom = createXmlDom();           
	            xmldom = loadXMLString(result);
	            
                moviePath = getNodeText(xmldom.getElementsByTagName("FILEPATH")[0]);
                movieID = getNodeText(xmldom.getElementsByTagName("IMAGEID")[0]);
                movieName = getNodeText(xmldom.getElementsByTagName("IMAGENAME")[0]);
                
				movieMain(movieID, moviePath, movieName);
	        }
			</script>
		</head>
		<body>
			<table class="layout" style="border-spacing:0; border-bottom:1px solid #ddd; border:0px; width:100%; margin-top:-1px;">
			  <tr>
			    <td style="width:100%;  text-align:center; vertical-align:top;" >
			        <table style="width:100%; min-height:635px;">
				        <tr id="trheight" style="display:table-cell;">
				            <td style="display:inline-block;">
				                <table id="movieTable" style="text-align:center; border:0px;">
				                    <tr>
				                    	<td>
										<video id="mainVideo" style="width: 640px; height: 360px;" src="" controls /> 
				                        </td>
				                    </tr>			                    
				            </table>
				            </td>
				        </tr>
			        </table>
			    </td>
			  </tr>
		</table>
	</body>
</html>