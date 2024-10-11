<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			    <script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<STYLE title="ezform_style_1">
			P {
					MARGIN-TOP: 0mm;
					MARGIN-BOTTOM: 0mm;
			  }
			.likeButton {
				padding:5px;
				cursor:pointer;
				display:inline-block;
				border:1px solid #c7c7c7;
			    border-radius:2px;
			}
			.likeButton:hover {
				background-color:#f1f8ff;
				border:1px solid #6793d8;
			}
		</STYLE>
		<script type="text/javascript">
		    window.offscreenBuffering = true;
		    var xmlhttp = createXMLHttpRequest();
		    var fontSize = new Array("10px", "12px", "15px", "20px", "30px");
		    var curFontSize = 1;
		    var pItemID = "<c:out value='${itemID}'/>";
			var pBoardID = "<c:out value='${boardID}'/>";
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
			var gubun = "${boardInfo.guBun}";
	        var isLikeChecked = "<c:out value='${isLikeChecked}'/>";
			var likeFlag = "<c:out value='${boardInfo.likeFlag}'/>";
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
		    /* 2019-11-06 홍승비 - 댓글기능관련 변수 추가 */
		    var OneLineReplyFlag = "${boardInfo.oneLineReply}";
		    var userInfoID = "${userInfo.id}";
		    var mode = "${mode}";
			var reactFlag = "<c:out value='${boardInfo.reactFlag}'/>"; // 2023-07-28 임정은 - 게시판 댓글 좋아요 기능 사용여부
			/* 2023-04-12 이가은 - 답글 기능을 위한 변수 추가 */
		    var userInfoName = "${userInfo.displayName1}";
			var replyOpenFlag = 0;
			var replyModifyFlag = 0;
			var replyModifyId = "";
			var replyTextarea = "";
			var delParentReply = 0;
			var delChildReply = 0;
			var delReplyLevel = "";
			var parentReplyID = "";
			var replyModifyArray = new Array(); // 2023-08-09 임정은 - 답글 수정 기능을 위한 배열 추가

		    window.onresize = window_resize;
		    window.onload = function () {
		        imageViewInit();
		        window_resize();
		        makeEmoticonPanel();

		        
		        /* 2019-11-06 홍승비 - 본문 하단에 댓글영역 표출 */
	            if (OneLineReplyFlag == "2" && mode != "temp") {
	            	getBoardComment();
	            }
		    }
		    
		    $(document).ready(function() {
				/* 2019-04-08 홍승비 - 좋아요 버튼이 존재한다면 본문 패딩과 height 조절 */
	            if (likeFlag != null && likeFlag == "Y") {
					$("#outerTable").css("min-height", "550px");
					
					/* 2020-04-09 홍승비 - 하단댓글과 좋아요 동시 사용 시 스타일 수정 */
					if (OneLineReplyFlag == "2") {
						$("#likeDiv").css("margin-top", "28px");
					}
	            } else { // 좋아요 미사용 + 하단댓글 사용
					if (OneLineReplyFlag == "2") {
						$("#onelineDiv").css("margin-top", "40px");
					}
	            }
	        });
		    
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
	        
	        /* 2019-04-08 홍승비 - 좋아요 버튼 클릭 동작 */
		    function clickLikeButton() {
		    	var mod = "";
		    	if (isLikeChecked == "Y") {
		    		mod = "DELETE";
		    	} else {
		    		mod = "INSERT";
		    	}
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/clickLikeMod.do",
					data : {
						mod: mod,
						itemID : pItemID
					},
					success: function(result){
						isLikeChecked = result;
						updateLikeCountImg(isLikeChecked);
					}
				});
		    }
		  	 
		    /* 2019-04-08 홍승비 - 좋아요 버튼 이미지 및 좋아요 갯수 업데이트 */
		    function updateLikeCountImg(isLikeChecked) {
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					cache : false,
					url : "/ezBoard/getLikeCount.do",
					data : {
						itemID : pItemID
					},
					success: function(result){
						if (parseInt(result) > 0) {
							document.getElementById("likeCountSpan").innerText = "(" + result + ")";
						} else {
							document.getElementById("likeCountSpan").innerText = "";
						}
						if (isLikeChecked == "Y") {
				    		document.getElementById("likeButtonImg").src = "/images/like_on.png";
				    	} else {
				    		document.getElementById("likeButtonImg").src = "/images/like_off.png";
				    	}
					}
				});
		    }
		    
			</script>
		</head>
		<body>
			<table class="layout" style="border-spacing:0; border-bottom:1px solid #ddd; border:0px; width:100%; margin-top:-1px;">
			  <tr>
			    <td style="width:100%;  text-align:center; vertical-align:top;" >
			        <table id="outerTable" style="width:100%; min-height:635px;">
				        <c:if test="${boardInfo.oneLineReply == '2' && mode != 'temp'}">
							<tr>
				        		<td style="height:65px;"></td>
							</tr>
						</c:if>
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
				            
							<%-- 2019-04-05 홍승비 - 본문, 사진소개 하단에 좋아요 버튼 추가 --%>
							<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y'}">
								<td style="text-align:center; display:block;">
									<div id="likeDiv" style="text-align:center; margin-top:40px;" colspan="3">
									  	<span class="likeButton" style="cursor:pointer; margin-left:-7px;" onclick="clickLikeButton()" title="<spring:message code='ezBoard.hsb10'/>">
										  	<c:choose>
										  		<c:when test="${isLikeChecked == 'Y'}">
										  			<img id="likeButtonImg" src="/images/like_on.png"/>
										  		</c:when>
										  		<c:otherwise>
										  			<img id="likeButtonImg" src="/images/like_off.png"/>
										  		</c:otherwise>
										  	</c:choose>
									  	<span id="likeCountSpan" style="vertical-align:top;"><c:if test="${likeCount > 0}"> (<c:out value="${likeCount}"/>)</c:if></span>
									  	</span>
									</div>
								</td>
							</c:if>		
				            
				            <%-- 2019-11-05 홍승비 - 하단댓글 영역 추가 --%>
				            <td>
						        <c:if test="${boardInfo.oneLineReply == '2' && mode != 'temp'}">
						        	<div id="onelineDiv" style='height:auto; margin-top:25px;'>
										<table class="mainlist emoticonLayerStaticPosition" style="width:100%; min-width:732px; margin-top:1px;" >
											<tr>
												<th style="width: 85%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
                                                    <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                                                    <div class="emoticonRelative">                                       
                                                          <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                                          <textarea id="onelinereply" rows="3" style = "resize:none; width:90%;" maxlength="600"></textarea>
                                                    </div>
                                                </th>
												<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2; width:15%;">
													<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t321' /></span></a>
												</th>
											</tr>
										</table>
										<table id="commentList" style="width:100%; min-width:732px; margin-top:2px; overflow:auto;border:1px solid rgb(225,225,225)"></table>
									</div>
						        </c:if>
				            </td>
				            <%-- 본문하단 댓글영역 끝 --%>
				        </tr>
			        </table>
			    </td>
			  </tr>
		</table>
		
		<div id = "basePanel">
            <%-- 2023-11-01 전인하 - 이모티콘 선택 팝업--%>
            <div id ="_stickerArea">					
                <div id="emoticonPanel" class="emoticonPanel">
                    <div id="emoticonGroup" style="display:block;width:100%; height: 45px;background-color: #fff; border-bottom:1px solid #ddd;">
                        <div style="float:left; display:block;">
                            <img id="previousEmoticon" src="/images/previous1.png" onclick="showNextGroupSticker(this);">
                        </div>
                        <div id="_ePresentors" style="float:left; display:block; ">
                        </div>
                        <div style="float: right; display:block;">
                            <img id="nextEmoticon" src="/images/next1.png" onclick="showNextGroupSticker(this);">
                        </div>
                    </div>						
                    <div id="emoticonList" style="display:inline-block;width:100%; background-color: #fff;">
                    </div>
                </div>					
            </div>
            
            <%-- 2023-11-01 전인하 - 선택된 이모티콘 조회 팝업 --%>
            <div id="uploadedFile" class="uploadedFile">
                <img id="cancelImg" class="cancelImg" src="/images/close.png"  onclick="closeEmoticonPreview();">
                <img id="previewImage" class="previewImage">
            </div>            
        </div>
	</body>
</html>
