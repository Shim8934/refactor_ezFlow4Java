<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezBoard.i1', 'msg')}" type="text/css">
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
		        
	            Open_Func(1);
		
		        leftResize();
		        $(".boardListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});	
		    };
		    
		    function Open_Func(idx) {
		    	$("h2.on").attr("class", "off");
		    	$("#TopBoardsList .lnbUL").attr("class","lnbUL off");
	            $("#TreeCtrl_MyBoardTree_ul").attr("class","lnbUL off");
				
				if (typeof window.parent.frames["right"] == "undefined") {
					if (idx == 1) {
						rightFrame.src = "/ezQuestion/qstList.do?brdID=5";
					}
					else {
						rightFrame.src = "/ezQuestion/qstStep1.do?brdID=5";
					}
				}
				else {
			        if (CrossYN()) {
			            if (idx == 1) {
			                window.parent.frames["right"].location.href = "/ezQuestion/qstList.do?brdID=5";
			            }
			            else {
			                window.parent.frames["right"].location.href = "/ezQuestion/qstStep1.do?brdID=5";
			            }
			        } else {
			            if (idx == 1)
			                window.parent.frames["right"].location.href = "/ezQuestion/qstList.do?brdID=5";
			            else
							window.parent.frames["right"].location.href = "/ezQuestion/qstStep1.do?brdID=5";
			            SetTreeviewUnSelect("");
			        }
				}
		    }
		    
		    function qstWrite(){
		    	window.parent.frames["right"].qstWhite();
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
		<div id="left" class="lnb" style="overflow: auto">
	    	<div class="left_title" title="<spring:message code='ezBoard.t365'/>">
	    		<spring:message code='ezBoard.t365'/>
	        </div>
	        <div class="btn_writeBox">
	        	<p class="btn_write01" onclick="qstWrite();"><span class="sub_iconLNB tree_write"></span><spring:message code="ezBoard.t367" /></p>
	        </div>
	        <div class="boardListBox" style="overflow:hidden; padding-right: 0;">
		        <div class="lnb_lay">
			        <h2 onclick="Open_Func(1);">
			        	<span class="sub_iconLNB tree_board_qst"></span><span class="h2Title"><spring:message code="ezBoard.t365" /></span>
			        </h2>
				</div>	
			</div>	        
	    </div>
	</body>
</html>
