<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCircular.t180" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezCircular.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		
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
			var circularID = "${vo.circularID}";
			var circularUserID = "${vo.memberID}";
			var status = "${vo.status}";
			var userInfoID = "${userInfo.id}";
			var option = "${vo.option}";
			var commentStatus = "${vo.commentStatus}";
			var shareStatus = "${vo.shareStatus}";
			var commentType = "totalComment";
			
			$(document).ready(function(){
				getCircularComment();
				
				if (commentStatus == "1" || shareStatus == "1") {
					$(".commentConfirmDiv").show();
				}
				
				$("#searchValue").keypress(function(e) {
					if (e.keyCode == 13) {
						getCircularComment();
					}
				});
			});
			
			function swapTab(type) {
				$("#searchValue").val("");
				
		        if (type == 'totalComment') {
		        	//전체의견 가져오면서
		        	$("#tab1").attr("class", "on");
		        	$("#tab2").attr("class", "off");
		        	
		        	commentType = type;
		        	
		        	getCircularComment();
		        } else if (type == 'myComment') {
		        	//내게 달린 의견 및 공유된 의견
		        	//앞쪽 아이콘 삭제하고 작성자 내용 작성일
		        	$("#tab2").attr("class", "on");
		        	$("#tab1").attr("class", "off");
		        	
		        	commentType = type;
		        	
		        	getCircularComment();
		        }
		    }
		</script>
		
	</head>
	<body class="popup">
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 2000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 3000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<h1><spring:message code='ezCircular.t180'/></h1>
		<div id="close">
			<ul>
				<c:if test="${vo.memberID == userInfo.id}">
					<li><span onclick="commentSendMail();"><spring:message code='ezCircular.t83'/></span></li>
				</c:if>
				<li><span onclick="closePopup();"><spring:message code='ezCircular.t84' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript" >
   			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<div style='height:702px;overflow-y:auto;'>
			<table class="mainlist" style="width:99.5%;">
				<tr>
					<th style="width:51.5px;middle;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-left:1px solid #e2e2e2;">&nbsp;<spring:message code='ezCircular.t85' /></th>
					<th style="text-align:right;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
						<input type='text' id='searchValue' />&nbsp;<a class='imgbtn'><span onclick="getCircularComment()"><spring:message code='ezCircular.t85' /></span>&nbsp;</a>
					</th>
				</tr>
			</table>
			
			<div id="tabnav" style="width:99%; margin-top:15px;">
				<ul class="on">
					<li id="tab1" class="on"><span onclick="swapTab('totalComment')"><spring:message code='ezCircular.t141' /></span></li>
					<li id="tab2" class="off"><span onclick="swapTab('myComment')"><spring:message code='ezCircular.t142' /></span></li>
				</ul>
			</div>
			
			<table id="circularUserList" style="width:99.5%;margin-top:10px;table-layout: fixed; overflow:auto;border:1px solid rgb(225,225,225)"></table>
		</div>
		
		<div style="width:100%;margin-left:-10px;position: absolute; bottom: 0px; z-index: 1000;height:50px;">
			<div class="commentConfirmDiv" style="right:330px; display:none;">
		        <ul style="padding-top:2px">
		            <li><span id="commentConfirm" onClick="commentConfirm()"><spring:message code='ezCircular.t54' /></span></li>
		        </ul>
		    </div>
		</div>
	</body>
</html>