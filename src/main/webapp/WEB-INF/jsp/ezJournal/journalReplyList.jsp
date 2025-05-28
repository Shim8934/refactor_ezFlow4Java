<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezJournal.t102" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
		
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
			var journalId = <c:out value="${journalId}"/>;
			$(document).ready(function(){
				
			});
			
			// iframe resize
			function autoResize(i)
			{
			    var iframeHeight=
			    (i).contentWindow.document.body.scrollHeight;
			    (i).height=iframeHeight + 20;
			}
			
			//댓글 저장
			function saveJournalReply(){
				var replyContent = $("#replyContent").val();
				if(replyContent == null || replyContent==""){
					alert('<spring:message code='ezJournal.t206' />');
				}else{
					$.ajax({
						type:"post",
						async : false,
						data:{"replyContent":replyContent,"journalId":journalId},
						url:"/ezJournal/saveJournalReply.do",
						success: function(result){
							var journalTitle = parent.journalTitle;
							try {
								parent.opener.setJournalList();
							} catch (e) { }
							location.reload();
							parent.addReplyCount();
							replyContent = MakeXMLString(replyContent);
							sendJournalReplyMail(replyContent,journalId,result,journalTitle);
						}
					});
				}
			}
			
			// 메일보내기
			function sendJournalReplyMail(replyContent,journalId,journalWriter,journalTitle){
				$.ajax({
					type : "post",
				//	async : false,
					data : {
						"replyContent" : replyContent,
						"journalId" : journalId,
						"journalTitle" : journalTitle,
						"journalWriter" : journalWriter
					},
					url : "/ezJournal/sendJournalReplyMail.do",
					success : function(){
					}
				});
			}
			
			//댓글 삭제
			function deleteJournalReply(replyId){
				var replyContent = $("#replyContent").val();
				$.ajax({
					type:"post",
					data:{"replyId":replyId,"journalId":journalId},
					url:"/ezJournal/removeJournalReply.do",
					success: function(){
						try {
// 							parent.openJournalReply();
							parent.opener.setJournalList();
						} catch(e) { }
						location.reload();
						parent.minusReplyCount();
					}
				});
			}
			
			//작성자 정보창
		    function OpenUserInfo(pUserID) {
		        GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID, "UserInfo", 420, 450, "NO");
		    }
			
			function closeJournalPopup(){
//				if(parent.viewType=='detail'){
					closePopup();
//				} else {
//					parent.setJournalList();
//					parent.DivPopUpHidden_sub();
//				}
			}
		</script>
		<% pageContext.setAttribute("newLineChar", "\n"); %>
	</head>
	<body class="popup">
		<div class="layerpopup"  style="z-index: 1000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer" onload="autoResize(this)"></iframe>
		</div>
		<h1><spring:message code='ezJournal.t102'/><span id="headTitle" style="font-size: 14px">[<c:out value="${fn:length(replyList) }"></c:out>]</span></h1>
		<div id="close">
			<ul>
				<li><span onclick="closeJournalPopup();"></span></li>
			</ul>
		</div>
		
		<div style='height:100%;overflow-y:auto;'>
			<table class="mainlist" style="width:99.5%" >
				<tr>
					<th style="text-align:center; width: 88%; border-left:1px solid #e2e2e2; border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2;">
						<textarea id="replyContent" rows="3" style = "resize:none; width:98%" maxlength="600"></textarea>
					</th>
					<th style="text-align:center;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
						<a class='imgbtn' style="vertical-align: middle"><span onclick="saveJournalReply();"><spring:message code='ezJournal.t73' /></span></a>
					</th>
				</tr>
			</table>
			
			<table style="width:99.5%;margin-top:10px;table-layout: fixed; overflow:auto;border:1px solid rgb(225,225,225)">
				<colgroup><col width="20%"><col width="62%"><col width="18%"></colgroup>
				<tbody>
					<c:choose>
						<c:when test="${fn:length(replyList) eq 0 }">
							<tr style="height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white;">
								<td colspan="3" style="padding:10px;border-top:0px;border-bottom:1px solid #e2e2e2;border-right:0px;border-left:0px;text-align:center;background-color:white;">
								<spring:message code='ezJournal.t125' />
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach items="${replyList }" var="reply">
							<tr class="boardComment" 
								style="height: 40px; text-align: left; border: 1px solid #e2e2e2; background-color: #white;">
								<td style="padding-left: 3px;"><span
									style="cursor: pointer"
									onclick="OpenUserInfo(${reply.replyWriter});"><c:out value='${reply.replyWriterName }'/></span></td>
								<td
									style="text-align: left; vertical-align: middle; padding: 10px; word-wrap: break-word; line-height: 1.5">
									<!-- 2018-07-16 구해안 #13097 엔터&특문 동시처리 -->
									${fn:replace(fn:escapeXml(reply.replyContent),newLineChar,"<br/>") }
									<c:if test="${reply.mine eq 'Y' }">
									<img src="/images/ImgIcon/comment_del.gif"
									style="cursor: pointer; vertical-align: middle; inline-block; padding-bottom: 1.6px"
									onclick="deleteJournalReply(${reply.replyId })">
									</c:if>
									</td>
								<td style="text-align: right; padding-right: 8px"><c:out value='${fn:substring(reply.replyDate, 0, 16) }'/></td>
							</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel2">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
	        <iframe src="<spring:message code='ezJournal.t185' />" style="border:none;" id="iFrameLayer2"></iframe>
	    </div>
	</body>
</html>