<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
		<title><spring:message code="ezBoard.t293"/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
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
			.video_visual {
			    display: flex;
			    justify-content: center;  
			    align-items: center;    
			}
			
			.video_visual video {
			    max-width: 100%;
			    height: auto;
			}
			.preview_video {
			    border-bottom: 1px solid #D6E0EB;
    			box-sizing: border-box;
    			min-height: 380px;
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
			var likeCount = "<c:out value='${likeCount}'/>";
			var isDisLikeChecked = "<c:out value='${isDisLikeChecked}'/>";
			var disLikeFlag = "<c:out value='${boardInfo.disLikeFlag}'/>";
			var disLikeCount = "<c:out value='${disLikeCount}'/>";
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
			var commentSort = "earliest"; // 댓글 정렬 기준 : earliest(등록순) / latest(최신순)
			
            var attachmentFlag = "${boardInfo.attachmentFlag}"; // 게시판 첨부파일 사용여부
            var attachLimit = "${boardInfo.attachSizeLimit}"; // 개별 첨부파일 limit
            var attachFileNameMaxLength = Number("${attachFileNameMaxLength}"); // 첨부파일명 글자수 제한 limit
            var totalFileSize = 0; // 현재 총 첨부파일 사이즈
            var starRatingFlag = "<c:out value='${boardInfo.starRatingFlag}'/>"; // 별점 평가하기 기능 사용여부
			var rating = "${itemStarRating.rating}"; // 별점 평가하기 기능 > 별점

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
						$("#disLikeDiv").css("margin-top", "28px");
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
	
	            xmlhttp.open("POST", "/ezBoard/deleteOneLineReply.do?replyID=" + pReplyID + "&itemID=" + encodeURIComponent(pItemID) +  "&guBun=" + gubun, false);
	            xmlhttp.send();
	            getOneLineReply();
	            xmlhttp = null;
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
	        /* 2023-04-06 기민혁 - 좋아요 버튼 클릭 동작 (수정) */
		     function clickLikeButton() {
		    	var mod = "";

		    	if(isDisLikeChecked == "Y"){
		    		mod = "DELETE";
		    		$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezBoard/clickDisLikeMod.do",
						data : {
							mod: mod,
							itemID : pItemID
						},
						success: function(result){
							isDisLikeChecked = result;

							if($("#disLikeDiv").length > 0){
								updateDisLikeCountImg(isDisLikeChecked);
							}
						}
					});
		    	}
		    	
		    	if (isLikeChecked == "Y" && isDisLikeChecked != "Y") {
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
							document.getElementById("likeCountSpan").innerText = result;
						} else {
							document.getElementById("likeCountSpan").innerText = "";
						}
						if (isLikeChecked == "Y") {
				    		document.getElementById("likeButtonImg").src = "/images/like_on.png";
				    	} else {
				    		document.getElementById("likeButtonImg").src = "/images/like_off.png";
				    	}
						try {parent.refreshLikeAndDisLikeOpen(result,isLikeChecked,"like");}catch (e) {}

					}
				});
		    }
		    
		    /* 2023-04-06 기민혁 - 싫어요 버튼 클릭 동작 */
		    function clickDisLikeButton() {
		    	var mod = "";
		    	
		    	if(isLikeChecked == "Y"){
		    		mod = "delect";
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

							if($("#likeDiv").length > 0){
								updateLikeCountImg(isLikeChecked);
							}
						}
					});
		    	}
		    		
		    	if (isDisLikeChecked == "Y" && isLikeChecked != "Y") {
		    		mod = "DELETE";
		    	} else {
		    		mod = "INSERT";
		    	}
		    	
		    	$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/clickDisLikeMod.do",
					data : {
						mod: mod,
						itemID : pItemID
					},
					success: function(result){
						isDisLikeChecked = result;
						updateDisLikeCountImg(isDisLikeChecked);
					}
				});
		    }
		    
		    /* 2023-04-06 기민혁 - 싫어요 버튼 이미지 및 싫어요 갯수 업데이트 */
		    function updateDisLikeCountImg(isDisLikeChecked) {
		    	$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					cache : false,
					url : "/ezBoard/getDisLikeCount.do",
					data : {
						itemID : pItemID
					},
					success: function(result){
						disLikeCountAfter = result;
						if (parseInt(result) > 0) {
							document.getElementById("disLikeCountSpan").innerText = result;
						} else {
							document.getElementById("disLikeCountSpan").innerText = "";
						}
						if (isDisLikeChecked == "Y") {
				    		document.getElementById("disLikeButtonImg").src = "/images/disLike_on.png";
				    	} else {
				    		document.getElementById("disLikeButtonImg").src = "/images/disLike_off.png";
				    	}
						try {parent.refreshLikeAndDisLikeOpen(result,isDisLikeChecked,"disLike");}catch (e) {}

					}
				});
			}
		    
		    /* 2023-04-06 기민혁 - itemview 에서  좋아요/싫어요 버튼 클릭시  이미지 및  개수 업데이트 */
		    function refreshLikeAndDisLike(result,checked,gubun){
		    	if(gubun === "disLike"){
		    		isDisLikeChecked = checked ;
			    	if (parseInt(result) > 0) {
						document.getElementById("disLikeCountSpan").innerText = result;
					} else {
						document.getElementById("disLikeCountSpan").innerText = "";
					}
					if (isDisLikeChecked == "Y") {
			    		document.getElementById("disLikeButtonImg").src = "/images/disLike_on.png";
			    	} else {
			    		document.getElementById("disLikeButtonImg").src = "/images/disLike_off.png";
			    	}
		    	}else if(gubun === "like"){
		    		isLikeChecked = checked;
		    		if (parseInt(result) > 0) {
						document.getElementById("likeCountSpan").innerText = result;
					} else {
						document.getElementById("likeCountSpan").innerText = "";
					}
					if (isLikeChecked == "Y") {
			    		document.getElementById("likeButtonImg").src = "/images/like_on.png";
			    	} else {
			    		document.getElementById("likeButtonImg").src = "/images/like_off.png";
			    	}
		    	}
		    };
		    
			</script>
		</head>
		<body class="popup newBoardPopup" >
			<div class="layout">
				  <!-- 동영상 영역 -->
		          <div class="preview_video" id="trheight" >
		              <div class="preview_album media">
		                  <div>
		                      <div class="video_visual">
		                          <video id="mainVideo" style="width: 640px; height: 360px;" src="" controls />            
		                      </div>
		                  </div>
		         	    </div>
		          </div>
		          <!-- //동영상 영역 -->
	        	<!-- 좋아요/평가하기 -->
	        	<div class="evaluate_cont" <c:if test="${boardInfo.likeFlag == 'N' && boardInfo.disLikeFlag == 'N'}">  style="display: block;" </c:if>>
			        <%-- 2019-04-05 홍승비 - 본문, 사진소개 하단에 좋아요 버튼 추가 --%>
			        <%-- 2023-04-06 기민혁 - 싫어요 버튼 추가  --%>
					<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y' || boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
						<div class="likeDivBox" <c:if test="${not empty boardInfo.starRatingFlag && boardInfo.starRatingFlag == 'Y'}">style="margin-left: 255px;"</c:if>>
							<c:if test="${boardInfo.likeFlag != null && boardInfo.likeFlag == 'Y'}">
								<div id="likeDiv">	
					  				<span class="likeButton" onclick="clickLikeButton()" title="<spring:message code='ezBoard.hsb10'/>">
						  				<c:choose>
						  					<c:when test="${isLikeChecked == 'Y'}">
						  						<img id="likeButtonImg" src="/images/like_on.png"/>
						  					</c:when>
						  					<c:otherwise>
						  						<img id="likeButtonImg" src="/images/like_off.png"/>
						  					</c:otherwise>
						  				</c:choose>
						  				<span id="likeCountSpan"><c:if test="${boardItem.likeCount > 0}"> <c:out value="${boardItem.likeCount}"/></c:if></span>
					  				</span>
								</div>
							</c:if>
							<c:if test="${boardInfo.disLikeFlag != null && boardInfo.disLikeFlag == 'Y'}">
								<div id="disLikeDiv">	
					 			 	<span class="disLikeButton" onclick="clickDisLikeButton()" title="<spring:message code='ezBoard.kmh07'/>" >
									  	<c:choose>
						  					<c:when test="${isDisLikeChecked == 'Y'}">
						  						<img id="disLikeButtonImg" src="/images/disLike_on.png"/>
						  					</c:when>
						  					<c:otherwise>
						  						<img id="disLikeButtonImg" src="/images/disLike_off.png"/>
						  					</c:otherwise>
									  	</c:choose>
									  	<span id="disLikeCountSpan"><c:if test="${boardItem.disLikeCount > 0}"> <c:out value="${boardItem.disLikeCount}"/></c:if></span>
					  				</span>
								</div>
						   </c:if>
	         			</div>
				   </c:if>
				   <!-- 앰범에서 별점 평가 사용안할시 제거 -->
                   <%-- 2024-09-24 이혜림 - 본문 하단, 첨부파일/한줄댓글 상단에 별점 평가하기 추가 --%>
                   <c:if test="${not empty boardInfo.starRatingFlag && boardInfo.starRatingFlag == 'Y'}">
                      <div id="ratingContainer" class="rating_div" onclick="clickRatingButton()">
                          <div>
                              <span id="avgScore"><b>${itemStarRating.averageScore}</b><spring:message code='ezBoard.lhr004'/></span>
                              <span>(<span id="totalRaters">${itemStarRating.totalRaters}</span><spring:message code='ezBoard.lhr003'/>)</span>
                          </div>
                          <span class="ratingButton" title="<spring:message code='ezBoard.lhr001'/>">
                          <c:forEach var="i" begin="1" end="5">
                              <c:set var="srcIconFlag" value="${itemStarRating.rating >= i}" />
                              <label for="rate${i}">
                                  <input type="radio" name="reviewStar" value="${i}" id="rate${i}" <c:if test="${itemStarRating.rating == i}"> checked </c:if> />
                                  <img draggable="false" src="/images/ImgIcon/${srcIconFlag ? 'icon-flag.gif' : 'view-flag.gif'}"/>
                              </label>
                          </c:forEach>
                          </span>
                          <a class="imgbtn"><span onclick="clickSaveRatingButton()"><spring:message code='ezBoard.lhr001'/></span></a>
                     </div>
                   </c:if>
                   <!-- //앰범에서 별점 평가 사용안할시 제거 -->
            	</div>
            	
		<%-- 2019-11-05 홍승비 - 하단댓글 영역 추가 --%>
	        <c:if test="${boardInfo.oneLineReply == '2' && mode != 'temp'}">
	        	<div class="comment_cont reNewalCmt">
    				<div class="comment_textarea">
						<textarea id="onelinereply" rows="3" maxlength="500" placeholder="<spring:message code='ezBoard.newDesign01'/>"></textarea>
					</div>
	        	
					<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
						<div id="commentAttach"></div>
					</c:if>

					<div class="comment_function">	
						<div>
							<span id="_addEmoticon" class="btn_emoticon" onclick="addSticker(this)"><spring:message code='ezBoard.newDesign02' /></span>
							<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
								<span class="btn_attachFile" onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span>
							</c:if>
						</div>
						<div>
							<button class='btn_registration' onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></button>
						</div>
					</div>
				</div>
				<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
                       <%-- 첨부파일 버튼 --%>
                       <input id="commentFile" type="file" multiple="multiple" onchange="filechange(event)" style="display:none"/>
                       <input id="commentListFile" type="file" multiple="multiple" onchange="filechange(event)" style="display:none"/>
                       <%-- 댓글 첨부 리스트 --%>
				</c:if>
				<div class="comment_listBox">
					<div class="portlet_tabpart02_top">
						<p>
							<span id="earliest" class="tabon" onclick="boardCommentSort()"><spring:message code='ezBoard.commentSort.JIH001' /></span>
						</p>
						<p>
							<span id="latest" onclick="boardCommentSort()"><spring:message code='ezBoard.commentSort.JIH002' /></span>
						</p>
					</div>
					<div id="commentList"></div>
				</div>
	        </c:if>
	        <%-- 본문하단 댓글영역 끝 --%>
            	
            	
               </div>
				            
	


		
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
