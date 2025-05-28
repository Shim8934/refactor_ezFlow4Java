<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="<spring:message code='main.e6' />" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}"><c:if test="${memoFlag eq 'YES'}">
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/memo.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}"></c:if>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script><c:if test="${memoFlag eq 'YES'}">
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memo.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memoPortal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script></c:if>
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
			.ui-slider-handle{
				/* outline:none; select-dummy: expression(this.hideFocus=true); */
				border:0;
				outline:none;
			}	/* IE slider 점선 처리 */
    	</style>

		<script type="text/javascript">
			var topHeight = "${topHeight}";
			var topUrl = "${topUrl}";
			var mainUrl = "${mainUrl}";
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
	    	var memoFlag = "<c:out value='${memoFlag}' />";
	    	
			topHeight = "56";

		 	window.onresize = function () {
		        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
		        document.getElementById("mainFrame").style.height = MainHeight + "px";
		 	}
		 	
		 	$(window).resize(function() {
		 		if(memoFlag === "YES") {
			 		browserResize();
			 		setGadgetPositionResize();
		 		}
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
			    
			     	// 메모함 비어있을 시, 추가 이미지 클릭으로 새 메모 추가 
			        $(".memo_main").on("click", "#addFirstMemo", function() {
			        	newMemo();
			        });
			     	
			        $(document).on("click", ".saveBtn", function(){
				    	  var obj = $(this).parent().next();
				    	  modifyMemo(obj[0]);
					});
		    	
			    	$(document).on("click", ".color_list", function(){
			    		   defaultColor = $(this).index()+1;
			    	   		modifyMemoColor($(this).parent().parent(), $(this).index()+1);
			    	   		var obj = $(this).parent().parent();
			    	   		obj[0].setAttribute("class", "mamo0"+defaultColor+ " memoLay");
			    	   		$(this).parent().css("visibility", "hidden");
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
			    	
			    	/* 2018-12-18 김민성 - 메모 레이어 팝업 드래그시 화면 밀림 현상 수정 */
			    	$("#layer-popup").draggable("option", "scroll", false);
		    	} else {
		    		$(".noteBlock").css("pointer-events", "none");
		    	}
		    });

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
		</script>
	</head>
	<body style="margin:0px 0px 0px 0px;padding: 0px 0px 0px 0px;overflow:hidden;">
		<div style="height:56px;"><iframe src="${topUrl}" name="top" id="topFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;min-height:260px;" frameborder="0"></iframe></div>
		<iframe src="${mainUrl}" name="main" id="mainFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;height:100%;min-width:1280px" frameborder="0"></iframe>
		<%-- <div style="height:${topHeight}px"><iframe src="${topUrl}" name="top" id="topFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe></div>
		<iframe src="${mainUrl}" name="main" id="mainFrame"  style="margin:0px 0px 0px 0px; padding:0px 0px 0px 0px;border:none;width:100%;" frameborder="0"></iframe> --%>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
    		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<c:if test="${memoFlag eq 'YES'}">
			<!-- memo note -->
			<div class="noteBlock">
				
				<!-- 메모 레이어 -->
				<div id="layer-popup" class="memo_wrap layerControl" style="display:none; ">
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
				<div id="open-memo" class="memoBtn" style="display: none;"><span><spring:message code='ezMemo.t001'/></span></div>
			</div>
		</c:if>
	</body>
	<script type="text/javascript">
    	var Main_DialogArguments = new Array();
    	var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
    	/* var MainHeight = document.documentElement.clientHeight - parseInt("${topHeight}"); */
    	document.getElementById("mainFrame").style.height = MainHeight + "px";
	</script>
</html>