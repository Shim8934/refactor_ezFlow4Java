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
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
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
			var pItemID = "${boardItemVo.itemID}";
			var pBoardID = "${boardItemVo.boardID}";
			var userInfoID = "${userInfo.id}";
			var commentType = "totalComment";
			var gubun = "${gubun}";
			var Reply_FG = parent.Reply_FG;
			var OneLineReplyFlag = parent.OneLineReplyFlag;
			var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
			var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
			var checkpassword_dialogArguments = new Array();
			var delpReplyID;
			var rsa = new RSAKey();
			var mailFG_Comment = "<c:out value = '${boardInfo.mailFG_Comment}'/>"; // 댓글알림
			
			$(document).ready(function(){
				rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
				getBoardComment();
			});
			

			
			// iframe resize
			function autoResize(i)
			{
			    var iframeHeight=
			    (i).contentWindow.document.body.scrollHeight;
			    (i).height=iframeHeight + 20;
			}
		</script>
		
	</head>
	<body class="popup">
		<div class="layerpopup"  style="z-index: 1000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer" onload="autoResize(this)"></iframe>
		</div>
		<h1><spring:message code='ezBoard.t81'/><span id="headTitle" style="font-size: 14px">[${totalCommentCount}]</span></h1>
		<div id="close">
			<ul>
				<li><span onclick="closePopup();"></span></li>
			</ul>
		</div>
		
		<div style='height:590px;overflow-y:auto;'>
			<table class="mainlist" style="width:99.5%" >
				<c:choose>
					<c:when test="${gubun == 2}">
						<tr>
							<th colspan="2" style="text-align:center; width: 90%; border-left:1px solid #e2e2e2; border-right:1px solid #e2e2e2;
									 border-top:1px solid #e2e2e2; border-bottom:1px solid #f8f8fa; padding-bottom:3px" class="en_style">
								<textarea id="onelinereply" rows="3" style = "resize:none; width:98%" maxlength="600"></textarea>
							</th>
					</c:when>
					<c:otherwise>
						<tr>
							<th style="text-align:center; width: 88%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;" class="en_style">
								<textarea id="onelinereply" rows="3" style = "resize:none; width:98%" maxlength="600"></textarea>
							</th>
					</c:otherwise>	
				</c:choose>
				<c:choose>
					<c:when test="${gubun == 2}">
						</tr>
					</c:when>
					<c:otherwise>
							<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
								<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply()"><spring:message code='ezBoard.t321' /></span></a>
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
							<a class='imgbtn' style="vertical-align: middle"><span onclick="Save_OneLineReply()"><spring:message code='ezBoard.t321' /></span></a>
						</th>
					</tr>
				</c:if>
			</table>
			
			<table id="commentList" style="width:99.5%;margin-top:10px;table-layout: fixed; overflow:auto;border:1px solid rgb(225,225,225)"></table>
		</div>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel2">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer2"></iframe>
	    </div>
	</body>
</html>