<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <style type="text/css">
	    	#mCSB_1_container {
				margin-right: 0px;
			}  
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		
	    <script type="text/javascript">
	  		document.onselectstart = function () { return false; };
	        window.onload = function () {
	        	$("#fmenu").click();
	        	
	        	leftResize();
		        $(".journalListBox").mCustomScrollbar({
	        		theme : "dark"
	        	});
	        }
	        
	        function goJournalList(elem) {
				var url = "/ezJournal/journalListMain.do";
				
				var listType = $(elem).attr("listType");
				url = url + "?listType=" + listType;
				var typeId = $(elem).attr("typeId");
				if(typeId&&typeId!=undefined){
					url=url+"&typeId="+typeId;
				}
				window.open(url,"right");
				setRecvCount();
				
	        	// 2023-06-15 황인경 - 디자인 개선 > 업무일지 > 좌측메뉴 > 트리구조 LNB 이미지 수정, 메뉴선택 클래스 제어
	        	if (elem.id == "recvFolder" || elem.id == "tempFolder") {
	        		var activeH2 = document.querySelectorAll(".on");
	        		activeH2.forEach(function(h2) {
	        			$(h2).removeClass("on");
	        			$(h2).addClass("off");
	        		});
	        		
	        		$(elem).parent().removeClass("off");
	        		$(elem).parent().addClass("on");
	        		$(".list_text.node_selected").removeClass("node_selected");
	        		$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus")
	        	}
				
				var liSeleted = $(event.target);
				
				if (liSeleted.prop("tagName") == "SPAN" && liSeleted.hasClass("list_text")) {
					$(".node_selected").attr("class", "list_text");
					
					if (liSeleted.prop("tagName") == "LI") {
						var liChangeSpan = event.target.querySelector(".list_text");
						liChangeSpan.setAttribute("class", "list_text node_selected");
					} else {
						liSeleted.attr("class", "list_text node_selected");
					}
				}
			}
	        
	        function setRecvCount() {
        		$.ajax({
	   				type:"post",
	   				url:"/ezJournal/leftRecvCount.do",
	   				success: function(data){
	   					if(data != 0){
		   					$("#recvCount").html("&nbsp;&nbsp;" + data);
	   					}else{
		   					$("#recvCount").html("");
	   					}
	   				}
	   			});
	        }
	        
	        function journalConfig() {
	        	window.parent.frames["right"].location.href = "/ezJournal/journalConfig.do";
	        	setRecvCount();
	        }
	        
	        function writejournal() {
	        	var tID = window.parent.frames["right"].typeId;
	        	
	        	if(!tID){
	  				tID = "ezJournal.t05";
	        	}
        	
				var feature = GetOpenPosition(820, 850);
				var Openwin = window.open("/ezJournal/journalWrite.do?typeId=" + tID + "&mode=new", "", "width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
				
				Openwin.focus();
			}
	        
	        function openFolder(val01) {
	        	if ($("#"+val01+"UL").attr("class") == "lnbUL off") {
	        		$(".lnb H2").not("#option").attr("class", "off");
	        		$(".lnb UL").not("#option").attr("class", "lnbUL off");
	        		
	        		$("#"+val01+"H2").attr("class", "on");
	        		$("#"+val01+"UL").attr("class", "lnbUL on");
	        		// 2023-06-15 황인경 - 디자인 개선 > 업무일지 > 좌측메뉴 > 트리구조 LNB 이미지 수정 
	        		$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
	        		$("#"+val01).attr("class", "sub_iconLNB tree_arrow_down");
	        	} else {
	        		$("#"+val01+"H2").attr("class", "off");
	        		$("#"+val01+"UL").attr("class", "lnbUL off");	        		
	        		$("#"+val01).attr("class", "");
	        		$("#"+val01).attr("class", "sub_iconLNB tree_plus");
	        	}
	        }
	        
	        function leftResize(){
	        	$(".journalListBox").height(window.innerHeight-105);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
        	});
	        
	    </script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
	    	<!-- <div class="lnb_btn"></div> -->
	        <!-- <div class="lnb_btn_hidden"></div> lnb 숨기기 버튼-->
	    	<div class="left_title" title="<spring:message code='ezJournal.t1'/>"><spring:message code='ezJournal.t1'/>
	        	<span class="sub_iconLNB tree_leftconfig" onClick="journalConfig()" title="<spring:message code='ezJournal.t53'/>"></span>
	        </div>
	        <div class="btn_writeBox" onclick="writejournal()">
	        	<p class="btn_write01"><spring:message code='ezJournal.t57'/></p>
	        </div>
	        <div class="journalListBox mCustomScrollbar _mCS_1 mCS_no_scrollbar" style="overflow: hidden; padding-right: 0px; height: 854px;">
		        <div id="mCSB_1" class="mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside" tabindex="0" style="max-height: none;">
		        	<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
				        <h2 class="on" id="deptFolderH2">
							<span id="deptFolder" class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" onclick="openFolder('deptFolder')"><spring:message code='ezJournal.t49'/></span>
						</h2>
						<ul class="lnbUL on" id="deptFolderUL">
							<c:choose>
								<c:when test="${not empty typeList }">
									<c:forEach items="${typeList }" var="type">
										<li>
											<c:choose>
												<c:when test="${type.journaltypeId eq 'ezJournal.t05'}">
													<span class="list_text node_selected" id="fmenu" listType='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><spring:message code="${type.journaltypeId}"/></span>
												</c:when>
												<c:otherwise>
								    				<span class="list_text" id="fmenu" listType='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><spring:message code="${type.journaltypeId}"/></span>
												</c:otherwise>
											</c:choose>
					    				</li>
					    			</c:forEach>
					    		</c:when>
					    	</c:choose>
				        </ul>
				        <h2 class="off" id="myFolderH2">
				            <span id="myFolder" class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('myFolder')"><spring:message code='ezJournal.t50'/></span>
				        </h2>
				        <ul class="lnbUL off" id="myFolderUL">
			        		<c:choose>
					    		<c:when test="${not empty typeList }">
					    			<c:forEach items="${typeList }" var="type">
									    <li>
						    				<span class="list_text" listType='mine' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><spring:message code="${type.journaltypeId}"/></span>
									    </li>
					    			</c:forEach>
					    		</c:when>
					    	</c:choose>
				        </ul>
						<%-- 2023-06-14 황인경 - 디자인 개선 > 업무일지 > 좌측메뉴 > '수신일지함', '임시보관함' 태그 구조 수정, LNB 이미지 삭제 --%>
						<h2 class="off" id="recvFolderH2">
							<span class="sub_iconLNB tree_plus"></span><span class="h2Title" listType='recv' onClick="goJournalList(this);" id="recvFolder"><spring:message code='ezJournal.t51'/>
								<c:if test="${recvCount ne 0 }">
			                   		<span id="recvCount">&nbsp;&nbsp;${recvCount}</span>
			                   	</c:if>
		                   	</span>
						</h2>
						<h2 class="off" id="tempFolderH2">
		                	<span class="sub_iconLNB tree_plus"></span><span class="h2Title" listType='temp' onClick="goJournalList(this);" id="tempFolder"><spring:message code='ezJournal.t52'/></span>
						</h2>
					</div>
<%-- 					<ul id="option" class="lnbUL">
	                    	<li><span class="sub_iconLNB tree_businessLog_receive"></span><span class="list_text" listType='recv' onClick="goJournalList(this);"><spring:message code='ezJournal.t51'/><c:if test="${recvCount ne 0 }"><span id="recvCount">&nbsp;&nbsp;${recvCount}</span></c:if></span></li>
	                    	<li><span class="sub_iconLNB tree_outbox"></span><span class="list_text" listType='temp' onClick="goJournalList(this);"><spring:message code='ezJournal.t52'/></span></li>
	 		        	</ul> --%>
				</div>
	        </div>
	    </div>
	
	    <%-- <div id="left">
	        <div class="left_circular" title="<spring:message code='ezJournal.t1'/>">
	        	<span><spring:message code='ezJournal.t1'/></span>
	        </div>
		    <h2><span listType='department' id="fmenu" onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%;display:inline-block;"><spring:message code='ezJournal.t49'/></span></h2>
		    <ul id="iconul">
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li listType='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><span style="width:100%;display:inline-block;">
		    				<c:choose>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t05'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon01.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t06'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon02.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t07'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon03.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t08'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon04.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t09'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon05.png"/>
		    					</c:when>
		    					<c:otherwise>
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon06.png"/>
		    					</c:otherwise>
		    				</c:choose>
		    				<span style="display:inline-block; padding-top: 4px; padding-bottom: 1px;"><spring:message code="${type.journaltypeId}"/></span></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span listType='mine' onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%; display:inline-block;"><spring:message code='ezJournal.t50'/></span></h2>
		    <ul id="iconul">
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li listType='mine' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><span style="width:100%; display:inline-block;">
						    <c:choose>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t05'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon01.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t06'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon02.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t07'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon03.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t08'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon04.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t09'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon05.png"/>
		    					</c:when>
		    					<c:otherwise>
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon06.png"/>
		    					</c:otherwise>
		    				</c:choose>
						    <span style="display:inline-block; padding-top: 4px; padding-bottom: 1px;"><spring:message code="${type.journaltypeId}"/></span></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul> 
		    <h2><span listType='recv' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t51'/><c:if test="${recvCount ne 0 }"><span id="recvCount">(${recvCount })</span></c:if></span></h2>
		    <ul>
		    </ul>
		    <h2><span listType='temp' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t52'/></span></h2>
		    <ul>
		    </ul>
	        <h3><span listType='journalEnv' onClick="journalConfig()" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t53'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script> --%>
	    
	</body>
</html>