<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCircular.t180" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circularComment.js')}"></script>
		
		<style type="text/css">
			.portlet_tabpart01_top p .tabon { border-bottom-color: white !important}
		/* 18-05-25 김민성 - commentConfirmDiv 사용 안해서 주석 처리 & 의견란 placeholder style 추가*/
			/* .commentConfirmDiv {
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
			}  */
			textarea {
				border: 0px solid white;
			}
			
			textarea::placeholder {
 				 color: #b4b4b4;
 			}
 			
 			textarea::-webkit-input-placeholder {
  				color: #b4b4b4;
			}

			textarea:-ms-input-placeholder {
				color: #b4b4b4;
			}
			
			#commentSendMail{
				float: right;
			}
}
		</style>
		
		<script type="text/javascript">
			var circularID = "<c:out value='${vo.circularID}'/>";
			var circularUserID = "<c:out value='${vo.memberID}'/>";
			var status = "<c:out value='${vo.status}'/>";
			var userInfoID = "<c:out value='${userInfo.id}'/>";
			var option = "<c:out value='${vo.option}'/>";
			var commentStatus = "<c:out value='${vo.commentStatus}'/>";
			var shareStatus = "<c:out value='${vo.shareStatus}'/>";
			var commentType = "totalComment";
			var selSpan = "";
			
			$(document).ready(function(){
				getCircularComment();
				selSpan = "selSpan1";
				
				if (commentStatus == "1" || shareStatus == "1") {
					$(".commentConfirmDiv").show();
				}
				
				$("#searchValue").keypress(function(e) {
					if (e.keyCode == 13) {
						getCircularComment();
					}
				});
				
				$("#popup1").height(parseInt(parent.document.getElementById("iFrameLayer").style.height)-118);
				$("#popup2").height(parseInt(parent.document.getElementById("iFrameLayer").style.height)-70);
			});
			
			function swapTab(type) {
				$("#searchValue").val("");
// 				$(".searchType[value='content']").attr("checked", true);
				
		        if (type == 'totalComment') {
		        	//전체의견 가져오면서
		        	//$("#tab1").attr("class", "on");
		        	//$("#tab2").attr("class", "off");
		        	$("#tab1").children("span").attr("class" , "tabon");
		        	$("#tab2").children("span").attr("class" , "");
		        	selSpan = "selSpan1";
		        	
		        	commentType = type;
		        	
		        	getCircularComment();
		        } else if (type == 'myComment') {
		        	//내게 달린 의견 및 공유된 의견
		        	//앞쪽 아이콘 삭제하고 작성자 내용 작성일
		        	//$("#tab2").attr("class", "on");
		        	//$("#tab1").attr("class", "off");
		        	$("#tab1").children("span").attr("class" , "");
		        	$("#tab2").children("span").attr("class" , "tabon");
		        	selSpan = "selSpan2";
		        	
		        	commentType = type;
		        	
		        	getCircularComment();
		        }
		    }
			
			function commentRefresh() {
				getCircularComment();
			}
			
			function getCommentCount() {				
			}
			
			/* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != selSpan) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
		</script>
		
	</head>
	<body class="popup">
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 2000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 3000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<h1><spring:message code='ezCircular.t180'/>[<c:out value='${myCommentCount}'/>/<c:out value='${totalCommentCount }'/>]</h1>
		<div id="close">
			<ul>				
				<li><span onclick="closePopup();"></span></li>
			</ul>
		</div>
<%-- 		<div id="menu" style="position:absolute;right:12px;top:60px">
			<ul>				
				<li><span onclick="commentSendMail();" style="border:1px solid #d2d2d2"><spring:message code='ezCircular.t83'/></span></li>
			</ul>
		</div> --%>
		
		<!-- 18-05-24 김민성 - 회람판 > 상세정보 > 의견목록 검색 부분 UI 수정 -->
		<c:choose>
			<c:when test="${myCommentCount != 0 }">
				<div id="popup1" style='overflow-y:auto;'>
			</c:when>
			<c:otherwise>
				<div id="popup2" style='overflow-y:auto;'>
			</c:otherwise>
		</c:choose>
			<%-- <table class="mainlist" style="width:99.5%;">
				<tr>
					<th style="width:51.5px;middle;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-left:1px solid #e2e2e2;">&nbsp;<spring:message code='ezCircular.t85' /></th>
					<th style="text-align:right;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
						<input style="vertical-align:middle; " type="radio" name='searchType' class='searchType' value='userID' checked="checked" /><spring:message code='ezCircular.t34' />
						<input style="vertical-align:middle; " type="radio" name='searchType' class='searchType' value='content' /><spring:message code='ezCircular.t188' />&nbsp;
						<input type='text' id='searchValue' />
						<a class='imgbtn' style="vertical-align: middle"><span onclick="getCircularComment()"><spring:message code='ezCircular.t85' /></span></a>
						<a class='imgbtn' style="vertical-align: middle"><span onclick="commentRefresh()"><spring:message code='ezCircular.t173' /></span></a>
					</th>
				</tr>
			</table> --%>
			
			<%-- <div id="tabnav" style="width:99%; margin-top:15px;">
				<ul class="on">
					<li id="tab1" class="on"><span onclick="swapTab('totalComment')"><spring:message code='ezCircular.t141' /></span></li>
					<li id="tab2" class="off"><span onclick="swapTab('myComment')"><spring:message code='ezCircular.t142' /></span></li>
				</ul>
			</div> --%>
			
			<div class="portlet_tabpart01" style="margin-top:10px;padding-right:5px">
	       		<div class="portlet_tabpart01_top">
	       			<p id="tab1"><span id="selSpan1" onclick="swapTab('totalComment')" class="tabon" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezCircular.t141' /></span></p>
	       			<p id="tab2"><span id="selSpan2" onclick="swapTab('myComment')" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezCircular.t142' /></span></p>
	       			<div id="commentSendMail">
	       				<a id="" class="imgbtn imgbck"><span onclick="commentSendMail();"><spring:message code='ezCircular.t83'/></span></a>
	       			</div>
	       		</div>
      	 	</div>			
			<table id="circularUserList" style="width:99.5%;margin-top:0px;table-layout: fixed; overflow:auto;border:1px solid rgb(225,225,225);margin-top:10px; word-break:break-all;"></table>
		</div>
	
		<!-- 18-05-25 김민성 - 회람판 > 상세정보 > 의견목록 회람확인 UI 수정  -->
		<%-- <div style="width:100%;margin-left:-10px;position: fixed; bottom: 0px; z-index: 1000;height:45px;background-color: #f8f8fa;">
			<div class="commentConfirmDiv" style="right:330px; display:none;">
		        <ul style="padding-top:2px">
		            <li><span id="commentConfirm" onClick="commentConfirm()"><spring:message code='ezCircular.t54' /></span></li>
		        </ul>
		    </div>
		</div> --%>
		
		<c:if test="${myCommentCount != 0 }">
			<div style="width:100%;margin-left:-10px;position: fixed; bottom: 0px; z-index: 1000;height:45px;background-color:#f8f8f8;border-top:1px solid #eee">
				<div id="menu" style="margin-top:8px; margin-left:45%; position:relative;">
			        <ul>
			            <li><span style="border: 1px solid #777; border-image: none;" onClick="commentConfirm()"><spring:message code='ezCircular.t54' /></span></li>
			        </ul>
			    </div>
			</div>
		</c:if>
		
		<script type="text/javascript" >
			var myCommentCount = "<c:out value='${myCommentCount}'/>";
			if(myCommentCount != 0) {
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
			} 
		</script>
	</body>
</html>