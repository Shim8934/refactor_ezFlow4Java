<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
	    <title><spring:message code='ezStatistics.t2' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    <script type="text/javascript">
		
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			
		    window.onload = function()
		    {
		        parent.document.querySelectorAll("iframe")[1].src = "/ezStatistics/statisticsPerSonalMain.do";        
		    };
			
		    function menu_change(Item) 
		    {
			    var this_menu ;
			    var this_sub_menu ;
			    if(Item == '')
				    this_menu = event.srcElement.id;
			    else
			        this_menu = Item;
		
			    switch(this_menu)
			    {	
			    	case "PERSONAL":
		           		parent.document.querySelectorAll("iframe")[1].src = "/ezStatistics/statisticsPerSonalMain.do";
		           	 	break;
			        case "MAIL":
			            parent.document.querySelectorAll("iframe")[1].src = "/ezStatistics/statisticsMailMain.do";
			            break;
			        case "APPROVAL":
			            parent.document.querySelectorAll("iframe")[1].src = "/ezStatistics/statisticsApprMain.do";
			            break;
			        case "PAGELOG":
			            parent.document.querySelectorAll("iframe")[1].src = "PageLog/PageLog_Main.aspx";
			            break;
			        case "WEBLOG":
			            parent.document.querySelectorAll("iframe")[1].src = "WebLog_Statistics/WebLog_Main.aspx";
			            break;
			        case "ATTITUDE": //개인별 근태통계
			            parent.document.querySelectorAll("iframe")[1].src = "/ezStatistics/statisticsAttitudeMain.do";
			            break;
			    }
			    liSelected();
		    }
		
		    function goPage(idx)
		    {
			    var url = "";
			    switch(idx)
			    {
				    case 1:
				        url = "/ezStatistics/statisticsMailDept.do";
					    break;
			        case 2:
			            url = "/ezStatistics/statisticsMailUser.do";
			            break;
			        case 4:
			            url = "/ezStatistics/statisticsQuantityDept.do";
			            break;
			        case 5:
			            url = "/ezStatistics/statisticsQuantityUser.do";
			            break;
			        case 6:
			            url = "/ezStatistics/statisticsMonForm.do";
			            break;
			        case 7:
			            url = "/ezStatistics/statisticsMonDept.do";
			            break;
			        case 8:
			            url = "/ezStatistics/statisticsMonUser.do";
			            break;
			        case 9:
			            url = "/ezStatistics/statisticsTimeForm.do";
			            break;
			        case 10:
			            url = "/ezStatistics/statisticsTimeDept.do";
			            break;
			        case 11:
			            url = "/ezStatistics/statisticsTimeUser.do";
			            break;
			        case 12:
			            url = "/ezStatistics/statisticsForm.do";
			            break;
			        case 13:
			            url = "/ezStatistics/statisticsDept.do";
			            break;
			        case 14:
			            url = "/ezStatistics/statisticsUser.do";
			            break;
			        case 15:
			            url = "/ezStatistics/statisticsApprMain.do";
			            break;
			        case 16:
			            url = "/ezStatistics/statisticsPerSonalMain.do";
			            break;
			        case 17:
			            url = "/ezStatistics/statisticsConnBrowser.do";
			            break;
			        case 18:
			            url = "/ezStatistics/statisticsConnOS.do";
			            break;
			        case 19:
			            url = "PageLog/PageLog_Dept.aspx";
			            break;
			        case 20:
			            url = "PageLog/PageLog_User.aspx";
			            break;
			        case 21:
			            url = "WebLog_Statistics/WebLog_Module.aspx";
			            break;
			        case 22:
			        	url = "/ezStatistics/statisticsMailRecieveLogList.do";
			        	break;
			        case 23:
			        	url = "/ezStatistics/statisticsMailSendLogList.do";
			        	break;
			        case 24: //부서별 근태통계
			        	url = "/ezStatistics/statisticsAttitudeDept.do";
			        	break;
					case 25:
						url = "/ezStatistics/statisticsMenuUser.do";
						break;
                    case 26:
                        url = "/ezStatistics/statisticsMenuDept.do";
                        break;
			    }
		
			    window.open(url,"stat_main");
			    liSelected();
		    }
		
		    $(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
		    
		    function leftResize(){
		    	$(".adminListBox").height(window.innerHeight-58);
		    }
		    
		    $( window ).resize(function() {
		    	leftResize();
			});
		    
		    // 2023-07-04 황인경 - 디자인 개선 > 관리자 > 통계 > 좌측메뉴 > 트리구조 LNB 이미지 추가
		    function openFolder(val01) {
		    	if ($("#" + val01 + "H2").attr("class") == "on") {	        	
		    		$("#" + val01 + "H2").attr("class", "off");
		    		$("#" + val01 + "UL").attr("class", "lnbUL off");
		    		$("#" + val01 + "H2").children().eq(0).attr("class", "sub_iconLNB tree_plus");
		    	} else {
		    		$(".lnb H2").attr("class", "off");
		    		$(".lnb UL").attr("class", "lnbUL off");
		    		
		    		$("#" + val01 + "H2").attr("class", "on")
		    		$("#" + val01 + "UL").attr("class", "lnbUL");
		    		$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
		    		$("#" + val01 + "H2").children().eq(0).attr("class", "sub_iconLNB tree_arrow_down");
		    	}
		    }
		    
		 	// 2023-07-03 황인경 - 디자인 개선 > 관리자 > 통계 > 좌측메뉴 > 트리구조 메뉴선택 클래스 제어 
		    function liSelected() {
		        $("li.on").attr("class", "");
				$(event.target).parent().attr("class", "on");
	        }
		 	
	    </script>
    </head>

    <body class="newLeft"> 
	    <div id="left" class="lnb" style="overflow: auto">
		    <div class="admin_left_title" title="<spring:message code='ezStatistics.t124' />"><spring:message code='ezStatistics.t124' /></div>      
		    <div class="adminListBox" style="overflow:hidden; padding-right: 0;">
	            <h2 class="on" id="menu1H2">
            		<span class="sub_iconLNB tree_arrow_down"></span><span class="h2Title" id="PERSONAL" onclick="openFolder('menu1')" ><spring:message code='ezStatistics.t1049' /></span>
	            </h2>
	            <ul class="lnbUL" id="menu1UL">
           			<li class="on"><span class="h2_text list_text" onclick="goPage(16)"><spring:message code='ezStatistics.t1047' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(17)"><spring:message code='ezStatistics.t1045' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(18)"><spring:message code='ezStatistics.t1048' /></span></li>
	            </ul>
	            <c:if test="${useExternalMailServer == 'NO' }">
	      	    <h2 class="off" id="menu2H2">
            		<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="MAIL" onclick="openFolder('menu2')" ><spring:message code='ezStatistics.t2' /></span>
	      	    </h2>
			    <ul class="lnbUL off" id="menu2UL">
           			<li><span class="h2_text list_text" onClick="menu_change('MAIL')"><spring:message code='ezStatistics.t1001' /></span></li>
           			<li><span class="h2_text list_text" onClick="goPage(1)"><spring:message code='ezStatistics.t1012' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(2)"><spring:message code='ezStatistics.t1018' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(4)"><spring:message code='ezStatistics.t1023' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(5)"><spring:message code='ezStatistics.t1025' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(22)"><spring:message code='ezStatistics.kyj1' /></span></li>
           			<li><span class="h2_text list_text" onclick="goPage(23)"><spring:message code='ezStatistics.kyj2' /></span></li>
			    </ul>
			    </c:if>
	            <c:if test="${packageType == 'standard'}">
	            	<c:if test="${use_approvalG == 'YES'}">
	            		<h2 class="off" id="menu3H2">
		            		<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="APPROVAL" onclick="openFolder('menu3')" ><spring:message code='ezStatistics.t1030' /></span>
			            </h2>
					    <ul class="lnbUL off" id="menu3UL">
                   			<li><span class="h2_text list_text" onclick="goPage(15)"><spring:message code='ezStatistics.t1030' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(6)"><spring:message code='ezStatistics.t1031' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(7)"><spring:message code='ezStatistics.t1033' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(8)"><spring:message code='ezStatistics.t1034' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(9)"><spring:message code='ezStatistics.t1036' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(10)"><spring:message code='ezStatistics.t1037' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(11)"><spring:message code='ezStatistics.t1038' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(12)"><spring:message code='ezStatistics.t1039' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(13)"><spring:message code='ezStatistics.t1040' /></span></li>
                   			<li><span class="h2_text list_text" onclick="goPage(14)"><spring:message code='ezStatistics.t1041' /></span></li>
					    </ul>
	           	 	</c:if>
	      <!--
	            <h2><span id="Span2" style="display:inline-block;width:100%;" onClick="menu_change('WEBLOG')" ><spring:message code='ezStatistics.t2004' /></span></h2>
	            <ul>
	                <li><span style="display: inline-block; width: 100%;" onclick="menu_change('WEBLOG')"><spring:message code='ezStatistics.t2004' /></span></li>
	                <li><span style="display: inline-block; width: 100%;" onclick="goPage(21)"><spring:message code='ezStatistics.t2005' /></span></li>
	            </ul>
	            -->
		            <c:if test="${use_attitude == 'YES'}">
			            <h2 class="off" id="menu4H2">
		            		<span class="sub_iconLNB tree_plus"></span><span class="h2Title" id="ATTITUDE" onclick="openFolder('menu4')" ><spring:message code='ezStatistics.kbm1' /></span>
			            </h2>
					    <ul class="lnbUL off" id="menu4UL">
	              			<li><span class="h2_text list_text" onClick="menu_change('ATTITUDE')"><spring:message code='ezStatistics.t1018' /></span></li>
	              			<li><span class="h2_text list_text" onClick="goPage(24)"><spring:message code='ezStatistics.t1012' /></span></li>
						    <%-- <li><span style="display:inline-block;width:100%;" onClick="menu_change('ATTITUDE')"><spring:message code='ezStatistics.t1018' /></span></li>
						    <li><span style="display:inline-block;width:100%;" onClick="goPage(24)"><spring:message code='ezStatistics.t1012' /></span></li> --%>
					    </ul>
				    </c:if>
	            </c:if>
				<c:if test="${useStatMenu == 'YES'}">
					<h2 class="off" id="menu5H2">
						<span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="openFolder('menu5')" ><spring:message code='ezStatistics.pgb02' /></span>
					</h2>
					<ul class="lnbUL off" id="menu5UL">
						<li><span class="h2_text list_text" onclick="goPage(25)"><spring:message code='ezStatistics.pgb04' /></span></li>
						<li><span class="h2_text list_text" onclick="goPage(26)"><spring:message code='ezStatistics.pgb05' /></span></li>
					</ul>
				</c:if>
		    </div>
	    </div>
		<div style="width:100%; height:100%; position:absolute; top:0; left:0; z-index:1000;
		    background:none rgba(0,0,0,0.4); display:none;" class="progressPanel" id="progressPanel">&nbsp;
		</div>        
    </body>
</html>
