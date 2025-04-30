<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <style>
	    	.groupBoard {
				width:158px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
			#FromTreeView {
				height: 100%;
			}
			#mCSB_1_container {
				margin-right: 0px;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    
		<script type="text/javascript" >
	        var items = "${resultCount}";
	        var rightFrame = "";
	        var qstId = "<c:out value='${qstId}'/>";
	        var pollNum = "2";
	        
		    window.onresize = function () {
		        var menuSize = (parseInt(items) + 2) * 30;
		    };
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		    	rightFrame = window.parent.document.getElementsByName("right")[0];
		    	
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        Poll_Open(1);
		
		        leftResize();
		        $(".boardListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		    };
		    
		    function Poll_Open(idx) {
				$("h2.on").attr("class", "off");
				$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (typeof window.parent.frames["right"] == "undefined") {
					 if (idx == 1) {
						rightFrame.src = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
						qstId = "";
					}
					else {
						rightFrame.src = "/ezPoll/pollCreate.do?brdID=6";
					}
				}
				else {
					if (CrossYN()) {
			            if (idx == 1) {
			                window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
			                qstId = "";
			            }
			            else {
			                window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollCreate.do?brdID=6";
			            }
			        } else {
			            if (idx == 1) {
			            	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollList.do?brdID=6&qstId=" + qstId;
			            	qstId = "";
			            }
			            else {
			            	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollCreate.do?brdID=6";
			            }
			            SetTreeviewUnSelect("");
			        }
				}
		    }
		    
		    function resetNodeSelected(){
		    	$(".node_selected").attr("class","node_normal");
		    	$(".node_normal").eq(1).attr("class","node_selected");
		    }
		    
		    function pollClick(elem){
		    	var g_BrdID = "6";	
		    	
		    	$(".node_selected").attr("class","node_normal");
		    	
		    	var num = $(elem).attr("pollId");
		    	$(elem).attr("class","node_selected");
		    	
				var szUrl = "/ezPoll/pollList.do?brdID=" + g_BrdID + "&see=0&currPage=1&mode=&search=&mode1=sub&searchN=&pollType=" + num;			
				window.parent.document.querySelector("iframe[name=right]").src = szUrl;
		    }
		    
		    function pollConfig(){
		    	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollConfig.do";
		    }
		    
		    function pollWrite(){
		    	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollCreate.do?brdID=6";
		    }
		    
		    function leftResize(){
	        	$(".boardListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
		    
	 
	    </script>
	</head>
	<body class="newLeft">
		<%-- 2023-06-23 황인경 - 디자인 개선 > 투표 > 좌측메뉴 > 클래스 및 구조 수정, LNB 이미지 삭제 --%>
		<div id="left" class="lnb poll_left" style="overflow: auto">
	    	<div class="left_title" title="<spring:message code='ezBoard.t371'/>">
	    		<spring:message code='ezBoard.t371'/>
	    		<span onclick="pollConfig();" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezBoard.t0005" />"></span>
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write01" onclick="pollWrite();"><spring:message code="ezPoll.t144" /></p>
	        </div>
	        <div class="boardListBox mCustomScrollbar _mCS_1 mCS_no_scrollbar" style="overflow: hidden; padding-right: 0px; height: 911px;">
				<div id="mCSB_1" class="mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside" tabindex="0" style="max-height: none;">
					<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
						<ul class="lnbUL">
							<li class="pollDiv"><span class="node_normal" onclick="pollClick(this)" pollId="1"><spring:message code="ezPoll.hdp18" /></span></li>
							<li class="pollDiv"><span class="node_selected" onclick="pollClick(this)" pollId="2"><spring:message code="ezPoll.psb256" /></span></li>
							<li class="pollDiv"><span class="node_normal" onclick="pollClick(this)" pollId="4"><spring:message code="ezPoll.psb257" /></span></li>
							<li class="pollDiv"><span class="node_normal" onclick="pollClick(this)" pollId="3"><spring:message code="ezPoll.psb258" /></span></li>
						</ul>
					</div>
				</div>
			</div>
	    </div>
<%-- 	    <div id="left" class="lnb" style="overflow: auto">
	 	    	<div class="left_title" title="<spring:message code='ezBoard.t371'/>">
	 	    		<spring:message code='ezBoard.t371'/>
	 	    		<span onclick="pollConfig();" class="sub_iconLNB tree_leftconfig" title="<spring:message code="ezBoard.t0005" />"></span>
	 	        </div>
	 	        <div class="btn_writeBox">
	 	        	<p class="btn_write01" onclick="pollWrite();"><span class="sub_iconLNB tree_write"></span><spring:message code="ezPoll.t144" /></p>
	 	        </div>
	 	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
	 				<ul class="lnbUL">
	 					<li class="pollDiv"><span class="sub_iconLNB tree_poll_all"></span><span class="node_normal" onclick="pollClick(this)" pollId="1"><spring:message code="ezPoll.hdp18" /></span></li>
	 					<li class="pollDiv"><span class="sub_iconLNB tree_poll_ing"></span><span class="node_selected" onclick="pollClick(this)" pollId="2"><spring:message code="ezPoll.psb256" /></span></li>
	 					<li class="pollDiv"><span class="sub_iconLNB tree_poll_wait"></span><span class="node_normal" onclick="pollClick(this)" pollId="4"><spring:message code="ezPoll.psb257" /></span></li>
	 					<li class="pollDiv"><span class="sub_iconLNB tree_poll_ok"></span><span class="node_normal" onclick="pollClick(this)" pollId="3"><spring:message code="ezPoll.psb258" /></span></li>
	 				</ul>
	 			</div>	        
	 	    </div> --%>
	</body>
</html>
