<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" id="viewport">
		<link rel="shortcut icon" href="/images/favicon.ico">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
		<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/memo.css')}">
		<link rel="stylesheet" href="${util.addVer('ezNewPortal.e2', 'msg')}">
		<!-- 컨텍스트 메뉴 관련 -->
		<link rel="stylesheet" href="${util.addVer('/css/contextMenu.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memo.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memoPortal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style>
			.layerpopup {
				-webkit-border-top-left-radius: 5px;
				-webkit-border-top-right-radius: 5px;
				-webkit-border-bottom-left-radius: 5px;
				-webkit-border-bottom-right-radius: 5px;

				-moz-border-radius-topleft: 5px;
				-moz-border-radius-topright: 5px;
				-moz-border-radius-bottomleft: 5px;
				-moz-border-radius-bottomright: 5px;
	 			background: url('/images/kr/cm/popup_bg2.gif') repeat-x left top #ffffff ;
     			box-shadow: 0 0 3px 3px #333333;
	 			padding:2px 2px;
	 			border:1px solid #ffffff;
			}
			
			#noticePopupArea {visibility:hidden;position:absolute;top:0;left:0;}
			.popup_notice{display:inline-block;position:absolute;}
			#popupArea {display:none;height: 100% !important; width: 100%; position: fixed;left: 0;overflow: auto; top: 0;}
			#noticePopupLayer {width: 100%; overflow: auto;}
    	</style>
		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var headerColor;
	    	var textColor;
	    	var currText;
	    	var bodyColor;
	    	var useDate;
			var fontSize;
			var defaultColor;
	    	var dayArray = ["<spring:message code='main.t00052'/>", "<spring:message code='main.t00053'/>", "<spring:message code='main.t00054'/>", "<spring:message code='main.t00055'/>", "<spring:message code='main.t00056'/>", "<spring:message code='main.t00057'/>", "<spring:message code='main.t00058'/>"];
	    	var fontSize;
	    	var useDate;
			var defaultColor;
	    	var layerRight;
	    	var memoList;
	    	var userGadget;
	    	var layerFlag;
	    	var memoFlag = "<c:out value='${useMemo}' />";
	    	var useMemoContextMenu = false;
	    	var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
	    	var useContextmenu = "<c:out value='${useContextmenu}'/>";
	    	
	    	var beforeMemoId;
	    	var beforeMemo;
	    	var memoInter;
	    	var memoClickTimer = 0;
	     	var memoDelay = 200;
	     	var memoPrevent = false;
	     	
			topHeight = "60";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("topFrame").style.height = document.documentElement.clientHeight + "px";
		        document.getElementById("mainFrame").style.height = "calc(100% - 60px)";
		        //contextMenuRePosition();
		    }
			
			window.addEventListener('resize', function() {
				fixLayout();
			});
			
			window.addEventListener('orientationchange', function() {
				fixLayout();
			});
			
			function fixLayout() {
				setTimeout(function() {
					var longSide = window.innerWidth > window.innerHeight ? window.innerWidth : window.innerHeight;
					var shortSide = window.innerWidth < window.innerHeight ? window.innerWidth : window.innerHeight;
					
					if (window.orientation == 0 || window.orientation == 180) {
						var ratio = longSide / document.body.clientHeight;
					} else if (window.orientation == 90 || window.orientation == -90) {
						var ratio = shortSide / document.body.clientHeight;
					}
					
					document.body.style.transformOrigin = 'top left';
					document.body.style.transform = 'scale('+ratio+')';
				}, 10);
			}

		    function Div_Close() {
		        document.getElementById("popup_layer").style.display = "none";
		    }
			
		    function changeCompany(TcompanyID,TdeptID){
		    	method = "post"; 
		    	
		        var form = document.createElement("form");
		        form.setAttribute("method", method);
		        form.setAttribute("action", "/ezPortal/portalMain.do");

                var companyIDField = document.createElement("input");
                companyIDField.setAttribute("type", "hidden");
                companyIDField.setAttribute("name", "companyID");
                companyIDField.setAttribute("value", TcompanyID);

                form.appendChild(companyIDField);
                
                var deptIDField = document.createElement("input");
                deptIDField.setAttribute("type", "hidden");
                deptIDField.setAttribute("name", "deptID");
                deptIDField.setAttribute("value", TdeptID);

                form.appendChild(deptIDField);

		        document.body.appendChild(form);
		        form.submit();
		    }
		    
		    function reloadLoginPage(multiLoginFlag, url) {
		    	var frm = "";
		    	
		    	frm = "<form action='" + url + "' method='post' style='display:none;' id='reloadLogin' onsubmit='return false;'>";
		    	if(!!multiLoginFlag) {
		    		frm += "<input type='hidden' name='multiLoginFlag' value='" + multiLoginFlag + "'>";
		    	}
		    	frm += "</form>";
		    	
		    	var wrapper = document.createElement("div");
		    	wrapper.innerHTML = frm;
		    	document.body.appendChild(wrapper);
		    	document.getElementById("reloadLogin").submit();
		    }
			
			document.addEventListener("DOMContentLoaded", function () {
			   var userAgent = navigator.userAgent.toLowerCase();
			   var isTabletOrMobile = /ipad|iphone|ipod|android|tablet/i.test(userAgent);

			   var metaTag = document.querySelector('meta[name="viewport"]');
			   if (isTabletOrMobile || navigator.maxTouchPoints > 4) {
				   metaTag.setAttribute("content", "width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0, user-scalable=no");
			   }
		   });
		</script>
	</head>
	<body style="margin:0px 0px 0px 0px;padding: 0px 0px 0px 0px;overflow:hidden;">
		<div id="iframeShawdowLayer" class="iframeShawdowLayer" onclick = "hidefunc(this)" style="display: none; width:100vw; right:0;">
			<div id="myNotificationUL" style="padding: 0px; margin: 0px;  width: 390px; height: 603px; right: 50px; z-index:20; position:absolute;">
				<iframe id="iframeNoti" style="width:100%; height:50vh;" frameborder="0" scrolling="NO" src="/ezNotification/notificationMain.do">
				</iframe>
			</div>
		</div>
		<div id="noticeLayer" onclick="hidefunc(this)" style="display:none; right: 0px; width: 100%; height: 100vh; background-color: rgba(0, 0, 0, 0.3); z-index: 9999; position: absolute;">
			<div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);">
	        	<iframe id="noticeLayerFrame" style="margin:0; padding:0; border:0 none; width:640px; height:430px; border-radius:20px; box-shadow:0 3px 6px rgba(0,0,0,0.16); background:#fff;" src=""></iframe>
	    	</div>
    	</div>
		<div style="height:60px;"><iframe src="/ezNewPortal/newPortalTopMenu.do" name="top" id="topFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe></div>
		<iframe src="<c:out value='${mainUrl }'/>" name="main" id="mainFrame" style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;overflow:auto;" frameborder="0" allowfullscreen="true"></iframe>
		<%-- <div style="height:${topHeight}px"><iframe src="${topUrl}" name="top" id="topFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe></div>
		<iframe src="${mainUrl}" name="main" id="mainFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe> --%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1005; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="popupArea"><div id="noticePopupLayer"></div></div>
		<div id="noticePopupArea"></div>
		<c:if test="${useMobileMailOnly != 'YES'}">
  		    <div id="contextMenuBlock" class="contextMenuBlock" <c:if test="${useContextmenu eq 'NO'}">style="display:none" </c:if>>
               <div id="contextMenuBtn" class="contextMenuBtn" style="display: block;">
                   <div class="contextMenu"></div>

               </div>
                <div id="popupMenuBtn" class="popupMenuBtn" style="display: block;">
                    <div id="quickMenuBtn" class="quickMenuBtn">
                        <span class="quickMenuTop_memo"><img src="/images/ezNewPortal/quick01.png"></span>
                        <span class="quickMenuMiddle_memo"><img src="/images/ezNewPortal/quick02.png"><img src="/images/ezNewPortal/quick03.png"></span>
                        <span class="quickMenuBottom_memo"><img src="/images/ezNewPortal/quick04.png"><img src="/images/ezNewPortal/quick04.png"></span>
                    </div>
                </div>
		    </div>

            <!-- memo note -->
            <div id="noteBlock" class="noteBlock">
                <!-- 메모 레이어 -->
                <div id="layer-popup" class="memo_wrap layerControl" style="visibility :hidden;">
                    <div class="memo_header_wrapper">
                        <input type="hidden" id="layerFlag" value="layer" />
                        <div class="memo_header">
                            <ul class="memoHeaderUL">
                                <li class="memoSelect">
                                    <select id="memoFolderList"></select>
                                </li>
                                <li class="memoClose memoIcon30"></li>
                                <li class="memoExpand_s memoIcon30" id="controllable" style="display:none;"></li>
                                <li class="memoExpand memoIcon30" id="fullScreen"></li>
                                <li class="memoPlus memoIcon30" id="addMemo"></li>
                             </ul>
                         </div>
                     </div>

                     <div class="memoListBox" id="mLBox" style="overflow:hidden;">
                        <div class="memo_main" id="memoMain"></div>
                     </div>

                     <div class="memobgBar">
                        <div id="slider-range"></div>
                     </div>
                </div>

                <!-- 큰 메모 -->
                <div id="detailMemo">
                    <div class="bigTop" id='dMWrapper'>
                        <dl class="memoTit" id='dMHeader'>
                            <dt class="mtitText" id="dMTime"></dt>
                            <dd class="memoIcon memoX" id='closeMemo'></dd>
                        </dl>
                        <textarea id="dMContents" style="padding:5px;"></textarea>
                        <div class="bigBottom_left" id='bottomLeft'></div>
                        <div class="bigBottom_right" id='bottomRight'></div>
                    </div>
                </div>
		    </c:if>
			<%-- <div id="open-memo" class="memoBtn" style="display: none;"><span><spring:message code='ezMemo.t001'/></span></div> --%>
		</div>
	</body>
	<!-- 컨텍스트 메뉴 관련 시작 -->
	<script type="text/javascript" src="${util.addVer('/js/TweenMax.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/portalContextMenu.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezNewPortal.e1', 'msg')}"></script>
  	<script type="text/javascript">

		if(!!createContextMenu) createContextMenu("${userDeptId}");
		
	 	$(window).resize(function() {
	 		//browserResize();
	 		memoLayerResize();
	 		setMenuPostionResize();
	 		// 브라우저 리사이즈시 큰 메모 리사이즈
	 		bigMemoResize();
	 		
	 		clearTimeout(window.resizedFinished);
		    window.resizedFinished = setTimeout(function(){
		        //setContextMenuGadgetPosition();
		    }, 750);	 		
		    
	 	});	
  	
	 	$(function() {
	    	if(memoFlag === "YES") {
	    		
		    	defaultPointer();
		    	setPanelPointer();
		    	layerPopupOpacity();
		    	checkDefaultFolder();
		    	layerPopupResize();
	    		checkMemoConfig();
		    	memoFoldersInfo();
		    	scrollUI();
		    	layerClose();
		    	memoSortable();
		    	layerExpand();
		    	memoAdd();
		    	noteClearSelection();
		    	
		    	addEventInBigMemo();
		    	
		     	// 메모함 비어있을 시, 추가 이미지 클릭으로 새 메모 추가 
		        $(".memo_main").on("click", "#addFirstMemo", function() {
		        	newMemo();
		        });
		     	
		     	// 클릭과 더블클릭 이벤트 구분
		     	$('#layer-popup').on('focus', '.memoText', function(event) {	// 클릭 -> 메모 자동 저장 시작
		     		var targetEl = event.target;
		     		
		     		draggableFalse();		// draggable 때문에 레이어 안에서의 blur 이벤트 안 먹혀서 잠시 죽임
		     		
		     		memoClickTimer = setTimeout(function() {
		     			
		     			if (!memoPrevent) {
		     				memoFocusEvent(targetEl);	// 클릭했을 때의 함수 실행 -> 자동 저장
		     			}
		     			// memoPrevent = false;
		     		}, memoDelay);
		     	}).on('dblclick', '.memoText', function (event, ui) {		// 더블 클릭 -> 큰 메모 열기
		     		var memoId = $(this).attr("memoid");
		     		
		     		clearTimeout(memoClickTimer);
		     		// memoPrevent = true;
					getMemoDetail(memoId);			// 더블 클릭했을 때의 함수 실행 -> 큰 메모 열기
		     		// memoPrevent = false;
		     	});
		     	
		     	$('#layer-popup').on('blur', '.memoText', function(evnet) {
		     		autoSaveStop();				// 자동 저장 멈춤
		     		draggableTrue();			// 메모 레이어 드래그 살림
		     		modifyMemo($(this)[0]);		// 메모 내용 수정
		     	});
		     	
		     	// 큰 메모  일정 간격으로 메모 자동 저장 시작, 취소
		     	$('#dMContents').on('focus', function(event) {
		     		var targetEl = event.target;
		     		
		     		draggableFalse();		// 큰 메모 열었을 때도 메모 레이어 클릭하면 blur 이벤트 실행시키기 위해 임시로 죽임
		     		
		     		memoFocusEvent(event.target);				// 클릭했을 때의 함수 실행 -> 자동 저장
		     		
		     	}).on('blur', function(evnet) {
		     		autoSaveStop();				// 자동 저장 멈춤
		     		draggableTrue();			// 메모 레이어 드래그 살림
		     		modifyMemo($(this)[0]);		// 메모 내용 수정
		     	});
		     	
		     	/* 위의 자동 저장 기능 추가하면서 주석처리
		        $(document).on("click", ".saveBtn", function(){
			    	  var obj = $(this).parent().next();
			    	  modifyMemo(obj[0]);
				});
	    		*/
	    		
	    		// 메모 숨김 기능
	    		$(document).on('click', '.hidden', function(e) {
	    			var thisEl = $(this)[0];
	    			hideMemo(thisEl);
	    		});
	    		
		    	$(document).on("click", ".color_list", function(){
		    		var thisEl = $(this);
		    		defaultColor = thisEl.index()+1;
		    		
		    	   	var obj = thisEl.parent().parent();
		    	   	modifyMemoColor(obj, defaultColor);
		    	});
		        
		    	$(document).on("mouseleave", ".color_popup", function(){
		           	$(this).css("visibility", "hidden");
		       	});
		    	
		    	$(document).on("mouseenter", ".pallete", function(){
		    		$(this).parent().nextAll(".color_popup").css("visibility", "");
		    	});
		    	
		    	$(document).on("mouseleave", ".pallete", function(e){
		    		e = e || event;
		    		var goingto = e.relatedTarget || e.toElement;
		    		if (!goingto || goingto.className != "color_popup") {
		    			$(this).parent().nextAll(".color_popup").css("visibility", "hidden"); 
		    		}
		    	});
		    	
		    	$("#layer-popup").draggable("option", "scroll", false);
	    	} else {
	    		$(".noteBlock").css("pointer-events", "none");
	    		$(".noteBlock").css("display", "none");
	    	}
	    });
	 	
	 	function hidefunc(element) {
	 		element.style.display = "none";
        }
	 	
	</script>
	<!-- 컨텍스트 메뉴 관련 끝 -->	    	
	<script type="text/javascript">
    	var Main_DialogArguments = new Array();
    	var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
    	/* var MainHeight = document.documentElement.clientHeight - parseInt("${topHeight}"); */
    	
    	document.getElementById("topFrame").style.height = document.documentElement.clientHeight + "px";
    	document.getElementById("mainFrame").style.height = MainHeight + "px";
	</script>
</html>