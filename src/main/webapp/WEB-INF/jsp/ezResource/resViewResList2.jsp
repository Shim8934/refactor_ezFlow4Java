<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezResource.t403" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezResource.e1' />"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezResource/Calendar_Action_cross.js"></script>
		<style type="text/css">
			.warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
			.warnintxt01 { position:relative ;padding-bottom:10px;}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
			.warningdl dt { height:40px; margin-top:10px;text-align:left;}
			.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}

			/* tooltip 추가*/
			.calendar_layer{width:200px; table-layout:fixed; border:1px solid #4e4e46; border-collapse:separate; border-spacing:0; overflow:hidden;}
			.calendar_layer th{margin:0; padding:8px 10px; border:0; font-size:13px; color:#383838; white-space:normal; text-align:left;word-break:break-all;}
			.calendar_layer td{margin:0; padding:0;}
			.calendar_layer .text{padding:10px; border:1px solid #e5e5e5; border-bottom:0 none; overflow:hidden;}
			.calendar_layer .text .td_list{border:0 none; overflow:hidden;}
			.calendar_layer .text .td_list td{padding:3px 0px; color:#393939;}
			.calendar_layer .btn{background:#fff; border:1px solid #e5e5e5; border-top:1px solid #dedede; padding:10px 0px 9px 0px; margin:0 auto; text-align:center;}
			.calendar_layer .btn ul{list-style:none; margin:0 25px; padding:0px 3px; overflow:hidden; text-align:center;clear:both;list-style-type:none}
			.calendar_layer .btn ul li{float:left; height:27px; line-height:27px; background:url(images/calendar/btn_calendar_l.gif) no-repeat left top; padding:0px 3px 0px 8px;}
			.calendar_layer .btn ul li span{display:inline-block; background:url(images/calendar/btn_calendar_r.gif) no-repeat right top; padding:0px 8px 0px 3px; font-weight:normal; color:#555555;}
		</style>
		<script type="text/javascript">
			var pBrdid = "${brdID}";
	    	var pBrdnm = "${brdNm}";
	    	var pAccessCode = "${accessCode}";
	    	var pCompanyID = "${companyID}";
	    	var pUserID = "${userID}";
	    	var pDeptID = "${deptID}";
	    	var pAdminFg = "${adminFg}";
		    var folder_Url = "/ezResource/scheduleGet.do";
		    var p_Type = "MAIN";
	    	var title_name = new Array();
	    	var pBrdCount = "${brdCount}";
	    	var pChildBrd = "${childBrd}";
		    var Mod = "";
		    var pUse_Editor = "${useEditor}";
	    	document.onselectstart = function () { return false; };
	    	window.onload = function () {
	        	try {
	            	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                	document.body.style.MozUserSelect = 'none';
	                	document.body.style.WebkitUserSelect = 'none';
	                	document.body.style.khtmlUserSelect = 'none';
	                	document.body.style.oUserSelect = 'none';
	                	document.body.style.UserSelect = 'none';
	            	}
	            	if (navigator.userAgent.indexOf("Chrome") > -1)
		                document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 110 + "px";
		            else
	    	            document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 130 + "px";

	        	    if (pBrdCount != 0) {
	            	    for (var i = 0; i < pBrdCount; i++) {
	                	    title_name[i] = pChildBrd.split(",")[i];
	                	}

	                	setweek_onload("WEEK");
	            	} else {
		                document.getElementById("ToDaybtn").style.display = "none";
	                	document.getElementById("Weekbtn").style.display = "none";
	                	document.getElementById("TR_Line2").style.display = "none";
	                	document.getElementById("tdDateCalendarViewer").innerHTML = document.getElementById("EmptyMsg").innerHTML;
	            	}
	        	}
	        	catch (e) {
	            	alert(strLang263);
	        	}
	    	}

	    	function setweek_onload(type) {
		        var date = new Date();
		        if (pBrdCount != 0) {
		            if (type == "WEEK") {
	    	            document.getElementById("TR_Line2").style.display = "";
	        	        weekonload(date.getFullYear(), parseInt(date.getMonth()) + 1, date.getDate());
		            }
		            else if (type == "TODAY") {
	    	            document.getElementById("TR_Line2").style.display = "";
	        	        todayonlaod(date.getFullYear(), parseInt(date.getMonth()) + 1, date.getDate());
	            	}
	        	} else {
	            	document.getElementById("TR_Line2").style.display = "none";
	            	document.getElementById("tdDateCalendarViewer").innerHTML = "<div style='padding-top:20px;'>" + strLang265 + "<div>";
	        	}
	    	}

		    function btnRefresh_onclick() {
		        if (Mod == "WEEK")
		            setweek_onload("WEEK")
	    	    else if (Mod == "TODAY")
	        	    setweek_onload("TODAY")
	    	}

	    	function pagenavi(datenavi) {
		        if (Mod == "WEEK")
		            nextWeek_onclick(datenavi)
	    	    else if (Mod == "TODAY")
	        	    nextToday_onclick(datenavi);
	    	}

	    	function btnView_Resource() {
		        var strUrl = "viewResList.do?brdID=" + pBrdid + "&accessCode=" + pAccessCode;
		        strUrl = strUrl + "&brdnm=" + encodeURI(pBrdnm);

	    	    window.open(strUrl, 'right');
	    	}

	    	window.onresize = function () {
	        	if (navigator.userAgent.indexOf("Chrome") > -1)
		            document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 110 + "px";
		        else
	    	        document.getElementById("mainlistlayout").style.height = document.documentElement.clientHeight - 130 + "px";
	    	}

	    	function btnAdd_Click() {
		        if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	}

	        	var pURL;
	        	pURL = "/ezReource/ClsItem/AddClsItem.do?brdID=" + pBrdid
	        	var openLocation = pURL;
	        	openwindow(openLocation, "", 580, 450);
	    	}

		    function CheckAdmin() {
		        if (pAdminFg == "Y")
	    	        return true;
	        	else
		            return false;
		    }

	    	function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
	        	try {
	            	var heigth = window.screen.availHeight;
	            	var width = window.screen.availWidth;
	            	var left = 0;
	            	var top = 0;

		            if (window.screen.width > 800) {
		                var pleftpos;
	    	            var pheightpos;
	        	        pleftpos = parseInt(width) - 700;
	            	    pheightpos = parseInt(heigth) - 700;
	                	width = parseInt(width) - pleftpos;
	                	heigth = parseInt(heigth) - pheightpos;
	                	left = pleftpos / 2;
	                	top = pheightpos / 2;
	            	} else {
		                heigth = parseInt(heigth) - 30;
		                width = parseInt(width) - 10;
	    	        }

	        	    window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

	        	} catch (e) {
		            alert("openwindow :: " + e.description);
		        }
	    	}

	    	function RefreshPageDoc() {
	        	window.parent.left.location.href = "/ezResource/leftResource.do?flag=SELECT_NO";
	        	window.parent.right.location.reload();
	    	}
		</script>
	</head>
	<body class="mainbody" style="overflow:hidden;">
		<h1>${brdNm}<span id="TitleInfo"></span></h1>
		<div id="mainmenu" onload = "makePageSelPage()">
  			<ul>
    			<c:if test="${adminFg eq 'Y'}">
    				<li><span onClick="btnAdd_Click();"><spring:message code="ezResource.t363" /></span></li>	
    			</c:if>
    			<li><span onClick="btnView_Resource();"><spring:message code="ezResource.t17" /></span></li>
    			<li id="tbar2" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif"></li>
    			<li id="ToDaybtn"><span onClick="setweek_onload('TODAY');"><spring:message code="ezResource.t251" /></span></li>
    			<li id="Weekbtn"><span onClick="setweek_onload('WEEK');"><spring:message code="ezResource.t253" /></span></li>
      			<li style="background:none;cursor:default"><img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
				<li style="background:none;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li>
  			</ul>
		</div>
		
		<script type="text/javascript">
    		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
    	<table style="width:100%;margin-top:-37px;" id="mainlist" >
        	<tr>
            	<div id="tdCalViewCell"></div>
            	<div id="TD_CaseOfMonthView"></div>
        	</tr>
        	<tr id="TR_Line2" style="text-align:center;vertical-align:middle;height:30px;font-weight:bold;margin-top:10px;">
            	<td>
                	<img src="/images/page_previous.gif"  style="cursor:pointer;width:15px;vertical-align:middle;" id=Img2 onClick="pagenavi('PREV');">
                	<span id="divViewHeader" style="color: #404040; text-align:center"></span>
                	<img src="/images/page_next.gif" style=" cursor:pointer;width:15px;vertical-align:middle;" id=Img3 onClick="pagenavi('NEXT');">
            	</td>
        	</tr>

        	<tr>
            	<td style="vertical-align:top;">
                	<div id="mainlistlayout" style="width:100%;height:780px;overflow-y: auto;overflow-x:hidden;" >
                		<table style="width:100%;margin-top:10px;">
                    		<tr style="display:none;" id="approval">
                        		<td colspan="2" style="font-weight:bold;padding-left:5px;vertical-align:top;"><h2 class="h2_dot">&nbsp;<spring:message code="ezResource.t401" /></h2></td>
                    		</tr>
                    		<tr>
                      			<td colspan="2" id='weekviewer' class='tdViewContainer' style="vertical-align:top;"><!-- 'exchangcalendar에서 일,월,주보기 쿼리를 가지고 FolderUrl경로를 사용한다.  ---->
                        			<div id="tooltip" style="position:absolute; visibility:hidden; z-index:1000; background-color:lightyellow;"></div>
                        			<div id="tdDateCalendarViewer" style="padding-bottom:20px;padding-top:10px;height:100%; text-align:center" > </div>
                        		</td>
                    		</tr>
                    		<tr id="noapproval" style="display:none;">
                        		<td colspan="2" style="font-weight:bold;padding-bottom:10px;padding-left:5px;vertical-align:top;" ><h2 class="h2_dot">&nbsp;<spring:message code="ezResource.t402" /></h2></td>
                    		</tr>
                    		<tr>
                      			<td colspan="2" id='tdCalViewCell2'  class='tdViewContainer' style="vertical-align:top;"><!-- 'exchangcalendar에서 일,월,주보기 쿼리를 가지고 FolderUrl경로를 사용한다.  ---->
                        			<div id="idCalendarViewer2" style='height:100%; text-align:center'> </div>
                        		</td>
                    		</tr>
                		</table>
                	</div>
            	</td>
          	</tr>
		</table>
		
    	<div id="EmptyMsg" style="display:none;">
        	<div class="warningbox01" style="margin-top:100px;">
          		<div class="warningbox02">
  	        		<div class="warnintxt01" >
	        			<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="136" height="112"></span>
	        			<dl class="warningdl">
	        				<dt><img src="/images/notify/warning01.gif" width="183" height="27"></dt>
	        				<dd>
	        					<spring:message code="ezResource.t9900001" />
	        				</dd>
	        			</dl>
	        		</div>
	        	</div>
        	</div>
        </div>
	</body>
</html>