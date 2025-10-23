<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t81" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		
		<style type="text/css">
			.commentConfirmDiv {
				position:absolute;
				right:10px;
				top:7px;
				height:35px;
			}
			
			.commentConfirmDiv ul li {
				display: block;
				float:left;
				margin:0 2px 0 0px;
				background:url(/images/kr/cm/btn_default_offleft.gif) no-repeat top left;
				height:28px;
				padding:0px 0px 0px 8px;
				vertical-align:top;
				cursor:pointer;
				vertical-align:middle
			}

			.commentConfirmDiv span {
				display:inline-block;
				background:url(/images/kr/cm/btn_default_offright.gif) no-repeat top right;
				height:28px;
				padding:0px 8px 0px 0px;
				line-height:28px;
				font-size:12px;
			}
			
			.commentConfirmDiv ul li.on {
				background:url(/images/kr/cm/btn_default_onleft.gif) no-repeat top left;
				color:#333;
			}
			
			.commentConfirmDiv ul li.on span {
				background:url(/images/kr/cm/btn_default_onright.gif) no-repeat top right;
				color:#333;
			}
			
			.commentConfirmDiv ul li.off {
				background:url(/images/kr/cm/btn_default_offleft.gif) no-repeat top left;
			}
		</style>
		
		<script type="text/javascript">
			var pItemID = "<c:out value='${boardItemVo.itemID}'/>";
			var pBoardID = "${boardItemVo.boardID}";
			var userInfoID = "${userInfo.id}";
			var commentType = "totalComment";
			var gubun = "${gubun}";
			var Reply_FG = "<c:out value='${Reply_FG}'/>";
			var OneLineReplyFlag = "<c:out value='${OneLineReplyFlag}'/>";
			var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
			var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
			var checkpassword_dialogArguments = new Array();
			var delpReplyID;
			var rsa = new RSAKey();
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
			
			var attachmentFlag = "${boardInfo.attachmentFlag}"; // 게시판 첨부파일 사용여부(Y/N)
			var attachLimit = "${boardInfo.attachSizeLimit}"; // 첨부파일 크기 limit
			var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");// 첨부파일명 글자수 제한 limit
			var totalFileSize = 0; // 현재 총 첨부파일 사이즈

			$(document).ready(function(){
				rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
				getBoardComment();
				makeEmoticonPanel();
				autoResize();
			});
			
			/* 2020-12-07 홍승비 - 제대로 높이를 가지고 오지 못해서 수정, 현재 페이지의 iframe에 리사이즈 적용할 필요 없으므로 댓글영역에만 적용 */
			function autoResize() {
				var commentDiv = document.getElementById("commentDiv");
				var commentDivH = window.parent.document.getElementById("iFrameLayer").style.height.replace("px", "");
			    commentDiv.style.height = commentDivH - 70 + "px";
			}
		</script>
		
	</head>
	<body class="popup">
		<div class="layerpopup"  style="z-index: 1000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<h1><spring:message code='ezBoard.t81'/><span id="headTitle" style="font-size: 14px">[${totalCommentCount}]</span></h1>
		<div id="close">
			<ul>
				<li><span onclick="closePopup();"></span></li>
			</ul>
		</div>
		
	<%-- 2018-11-07 홍승비 - 동영상게시판 구분 추가 --%>
	<c:choose>
		<c:when test="${gubun == 7}">
			<div id="commentDiv" style='height:540px;overflow-y:auto;'>
		</c:when>
		<c:otherwise>
			<div id="commentDiv" style='height:570px;overflow-y:auto;'>
		</c:otherwise>
	</c:choose>
			<table class="mainlist emoticonLayerStaticPosition" style="width:99.5%" >
				<c:choose>
					<c:when test="${gubun == 2}">
						<tr>
							<th colspan="2" style="text-align:center; width: 85%; border-left:1px solid #e2e2e2; border-right:1px solid #e2e2e2; width:85%;
									 border-top:1px solid #e2e2e2; border-bottom:1px solid #f8f8fa; padding-bottom:3px">
                                <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                                <div class="emoticonRelative">                                       
                                    <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                    <textarea id="onelinereply" rows="3" style = "resize:none; width: calc(100% - 45px);" maxlength="500"></textarea>
                                </div>
							</th>
					</c:when>
					<c:otherwise>
						<tr>
							<th style="text-align:center; width: 85%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; width:85%;">
                                <%-- 2023-11-07 전인하 - 게시판 > 이모티콘 아이콘 삽입 --%>
                                <div class="emoticonRelative">								    
                                    <img id="_addEmoticon" class="_addEmoticon" src="/images/poll/add_emo_vote.png" onclick="addSticker(this)">
                                    <textarea id="onelinereply" rows="3" style = "resize:none; width: 90%;" maxlength="500"></textarea>
                                </div>
							</th>
					</c:otherwise>	
				</c:choose>
				<c:choose>
					<c:when test="${gubun == 2}">
						</tr>
					</c:when>
					<c:otherwise>
							<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2; width:15%;">
							    <c:if test='${boardInfo.attachmentFlag eq "Y"}'>
                                    <a class='imgbtn comment' style="vertical-align: middle"><span onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span></a><br/>
                                </c:if>
								<a class='imgbtn comment' style="vertical-align: middle"><span onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></span></a>
							</th>
						</tr>
					</c:otherwise>
				</c:choose>
				</tr>
				<c:if test="${gubun == 2}">
					<tr>
						<th colspan="2" style="width: 90%; border-left:1px solid #e2e2e2; border-top:1px solid #f8f8fa; border-right:1px solid #e2e2e2; text-align:right;
								border-bottom:1px solid #e2e2e2; padding-top:0px; padding-bottom:4px; vertical-align: middle">
							<span style = "font-weight:normal; display:inline-block; margin-top:2px"><spring:message code='ezBoard.t438' />&nbsp;</span>
							<span><input type="password" id="txtPassWord" maxlength="20" size="20" />&nbsp;</span>
							<c:if test='${boardInfo.attachmentFlag eq "Y"}'>
                                <a class='imgbtn comment' style="vertical-align: middle"><span onclick="btnfileup('commentFile')"><spring:message code='ezBoard.commentAttach.JIH01' /></span></a>
                            </c:if>
							<a class='imgbtn comment' style="vertical-align: middle"><span id="replySaveBtn" onclick="Save_OneLineReply(this)"><spring:message code='ezBoard.t98' /></span></a>
						</th>
					</tr>
				</c:if>
			</table>
			
            <c:if test='${boardInfo.attachmentFlag eq "Y"}'>
                <%-- 첨부파일 버튼 --%>
                <input id="commentFile" type="file" multiple="multiple" onchange="filechange(event)" style="display:none"/>
                <input id="commentListFile" type="file" multiple="multiple" onchange="filechange(event)" style="display:none"/>
                <%-- 댓글 첨부 리스트 --%>
                <div id="commentAttach"></div>
            </c:if>
            <div class="commentSort">
                <span id="earliest" class="checked" onclick="boardCommentSort()"><spring:message code='ezBoard.commentSort.JIH001' /></span>
                <span id="latest" onclick="boardCommentSort()"><spring:message code='ezBoard.commentSort.JIH002' /></span>
            </div>
			<table id="commentList" style="width:99.5%;margin-top:10px; overflow:auto;border:1px solid rgb(225,225,225)"></table>
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel2">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer2"></iframe>
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
                <img id="cancelImg" class="cancelImg" src="/images/close.png" onclick="closeEmoticonPreview();">
                <img id="previewImage" class="previewImage">
            </div>            
        </div>
	</body>
</html>