<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t403" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<link href="${util.addVer('/css/Calendar_cross.css')}" rel="stylesheet" type="text/css" />
		<style>
			#resourceDataTable tr td {
				border : 1px solid #ccc;				
			}
						
			#resourceDataTable tr td{
				padding-left : 7px;
			}
			
			#resourceDataTable tr th{
				font-weight: normal;
			}
			
			.table_layout th {
				color:#2f2f2f;height: 32px;background:#e4e8ec;border: 1px solid #c8ccd0;padding:0;margin:0;
				
			}
			
		</style>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/Calendar_Action_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/CalendarView_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>

		<style type="text/css">
			.warningbox{margin:240px auto 0px auto; padding:40px 20px 0px 20px; width:625px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box;}
			.warningbox .warningimg{margin:0px; padding:0px 0px 0px 40px; float:left;}
			.warningbox .warningDL{margin:0px; padding:0px 0px 0px 30px; float:left; overflow:hidden;}
			.warningbox .warningDL dt{margin:0px; padding:12px 0px 5px 0px; font-size:24px; font-weight:bold; color:#3d8fea; letter-spacing:-1px; text-align: left;}
			.warningbox .warningDL dd{margin:0px; padding:0px; font-size:20px; color:#333; letter-spacing:-1px;}
			.warningbox .warningDL dd span{ font-size:20px; font-weight:bold;}
			
			.warningbox01 { width:540px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;}
			.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-bottom:10px;margin-top:20px}
			/* .warningimg { position:absolute; top:0px; left:0px;} */
			.warningdl { width:75%; padding:10px 10px 5px 114px; margin:0px; display:inline-block; text-align:left;}
			.warningdl dt { height:40px; padding-left:6px; margin-top:10px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
			.today { background-color:#f0f6ff;}

			/* tooltip 추가*/
			.calendar_layer{width:250px; table-layout:fixed; border:1px solid #4e4e46; border-collapse:separate; border-spacing:0; overflow:hidden;}
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
			var pBrdid = "<c:out value='${carID}'/>";
	    	var pBrdnm = "<c:out value='${carName}'/>";
	    	var pAccessCode = "<c:out value='${accessCode}'/>";
	    	var pCompanyID = "${companyID}";
	    	var pUserID = "${userID}";
	    	var pDeptID = "${deptID}";
	    	var pAdminFg = "${adminFg}";
		   // var folder_Url = "/ezResource/scheduleGet.do";
		    var p_Type = "MAIN";
	    	var title_name = new Array();
	    	//var pBrdCount = "${brdCount}";
	    	//var pChildBrd = "${childBrd}";
		    var Mod = "";
		    var pUse_Editor = "${useEditor}";
		    //var pStartday = "${startDay}";		
		    //var lunarUseFlag = "${lunarUseFlag}";
		    //var lunarUse = "${lunarUse}";
		    /* select_memorialDays("${lang}"); */
		    var dayView = "";
		    var TotalCnt = ${TotalCnt};
	    	 /* 2019-01-11 김민성 - 접근 권한 없는 경우 메시지 출력 수정 */
		    if(pAdminFg == "") {
		    	var msg = "<spring:message code='ezResource.t58' />";
		        window.location.href = "/ezCar/nonResList.do?msg=" + encodeURIComponent(msg);
		    }
	    	 
		    window.onload = function () { 
		    	document.getElementById("TitleInfo").innerHTML = " - [" + strLang1002 + "<span class='txt_color' style='font-weight:bold;'> " + TotalCnt + " </span>" + strLang1003 + "]";
		    }
		    
	    	function btnAdd_Click() {
		        if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	}

	        	var pURL;
	        	pURL = "/ezCar/addClsItem.do?carID=" + pBrdid
	        	var openLocation = pURL;
	        	openwindow(openLocation, "", 580, 450);
	    	}
	    	
	    	function btnModify_Click() {
		        if (CheckAdmin() == false) {
	            	alert("<spring:message code='ezResource.t345' />");
	            	return;
	        	}

	        	var i, intChkCnt = 0;

	        	var objChk = document.getElementsByTagName("INPUT");
	        	for (i = 0; i < objChk.length; i++) {
	            	if (objChk[i].name == "chk" && objChk[i].checked == true) {
	                	intChkCnt = intChkCnt + 1;
	                	var intChkNum = 0;
	                	var strResID = objChk[i].value;
	                	var strOwnerID = objChk[i].getAttribute("OwnerID", "0");
	            	}
	        	}

		        if (intChkCnt == 0) {
		            alert("<spring:message code='ezCar.smb14' />");
		        } else if (intChkCnt > 1) {
	    	        alert("<spring:message code='ezCar.shb65' />");
	        	} else if (intChkCnt = 1) {
		            if (pUserID == strOwnerID || pAdminFg == "Y") {
		                var pURL;
		                pURL = "/ezCar/modClsItem.do?carID=" + strResID + "&brdID=" + pBrdid;
	    	            var openLocation = pURL;
	        	        openwindow(openLocation, "", 580, 550);
	            	    objChk[intChkNum].checked = false;
	            	} else {
		                alert("<spring:message code='ezCar.smb14' />");
		            }
		        }
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
	        	        pheightpos = parseInt(heigth) - 350;
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
	        	window.parent.left.location.href = "/ezCar/leftCar.do?flag=SELECT_NO";
	        	window.parent.right.location.reload();
	    	}
	    	
	 		$(window).on("resize", function(){
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;	        	
     			$("#CarInfo").css("left", popupX);
     		});
	  
	 		
	 		
	    	function btnDelete_Click() {
		        if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	}
	    		var strListInfo = "";
				var checkId = $("input[name=chk]:checked");
		    	
		    	if(checkId.length == 0){
		    		 alert("<spring:message code='ezCar.shb69' />");
			         return;
		    	}
		        var objChk = document.getElementsByName("chk");
		       
				for(var i=0; i<$("input[name=chk]:checked").length; i++){
				    strListInfo += $("input[name=chk]:checked")[i].value;
				    strListInfo += ";";
				}
				console.log('strListInfo : ' + strListInfo);
				var count = $("input[name=chk]:checked").length;
			
				if (!confirm(count + "<spring:message code='ezCar.shb70' />"))
				   return; 

				 $.ajax({
				    	type : "POST",
				    	dataType : "html",
				    	async : false,
				    	data : {
				    		carID : strListInfo
				    	},
				    	url : "/ezCar/deleteCar.do",
				    	success: function(text){
				    	alert(count + "<spring:message code='ezCar.shb71' />");
					    window.location.reload(false);
					    window.parent.left.location.reload();
				    	},
				    	error: function(err){
				    		alert("<spring:message code='ezCar.shb72' />");
				    	}
				  });
	    	}
	    	
	    	function btnView_Car() {
		        /* if (CheckAdmin() == false) {
		            alert("<spring:message code="ezResource.t345" />");
	    	        return;
	        	} */
	    		var strListInfo = "";
				var checkId = $("input[name=chk]:checked");
		    	
		    	if(checkId.length == 0){
		    		 alert("<spring:message code='ezCar.shb73' />");
			         return;
		    	}
		    	
		    	if(checkId.length > 1){
		    		 alert("<spring:message code='ezCar.shb74' />");
			         return;
		    	}
		    	
		        var objChk = document.getElementsByName("chk");
		       
				for(var i=0; i<$("input[name=chk]:checked").length; i++){
				    strListInfo = $("input[name=chk]:checked")[i].value;
				}
				Item_View(strListInfo);
	    	}

		    function CheckAdmin() {
		        if (pAdminFg == "Y")
	    	        return true;
	        	else
		            return false;
		    }

		    function Item_View(carID) {
		        pURL = "/ezCar/viewClsItem.do?carID=" + carID
		        var openLocation = pURL;
		        openwindow(openLocation, "", 580, 450);
	    	}
		    
		   
	    	
	    	// 2018-10-19 김민성 - 작성자 이름 클릭 시 사원정보보기 팝업
			function OpenUserInfo(userID, deptID) {
	        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + userID + "&dept=" + deptID, "", feature);
	        }
	    	
	    	
	    	
			function reverse(chkedVal) {
		        var i;
		        var objChk = document.getElementsByTagName("INPUT");

	        	if (objChk.length == undefined) {
	            	objChk.checked = chkedVal;
	        	} else {
		            for (i = 0; i < objChk.length; i++) {
		                if (document.getElementsByTagName("INPUT")[i].name == "chk") {
		                    document.getElementsByTagName("INPUT")[i].checked = chkedVal;
	    	            }
	        	    }
	        	}
	    	}		
	    	
	    		
		</script>
	</head>
	<body class="mainbody" style="overflow:hidden; padding-right: 6px;">
		<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
		<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;"><c:out value='${carName}'/><span id="TitleInfo"></span></h1>
		<div id="mainmenu" onload = "makePageSelPage()">
            <ul class="on">
            	<c:if test="${adminFg eq 'Y'}">
            		 <li class="important"><span onClick="btnAdd_Click();"><spring:message code="ezCar.shb02" /></span></li> 
    				<li class="off"><span class="icon16 icon16_delete" onclick="btnDelete_Click();"></span></li>
    				 <li><span onClick="btnView_Car();"><spring:message code="ezCar.shb05" /></span></li> 
					<li><span onClick="btnModify_Click();"><spring:message code='ezCar.shb06' /></span></li>              	
				</c:if>
				<c:if test="${adminFg ne 'Y'}">
    				 <li><span onClick="btnView_Car();"><spring:message code="ezCar.shb05" /></span></li> 
				</c:if>
              	<!-- <span id = "noResListSpan"> -->
              		<%-- <li style="background:none;float:right;cursor:default;border:0px;color:#393939">&nbsp;<img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
					<li style="background:none;float:right;cursor:default;border:0px;color:#393939"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li> --%>
				<!-- </span> -->
            </ul>
		</div>
		<!-- <div class="calendar_pagenav" id="weeklyline">
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"><span class="icon16 calendarleft" onclick="pagenavi('PREV');"></span></li>
	            <li class="contentlayout_right" id="preN"><span class="icon16 calendarright" onclick="pagenavi('NEXT');"></span></li>
	            <li class="contentlayout_none"><span class="spanText" id="divViewHeader"></span>
	            </li>
	        </ul>
	    </div> -->

	    <%-- <div class="mainmenuTab" id="noResListSpan">
	    	<ul class="mainmenuTabUL_left">  <li><span class="sub_iconLNB tree_resource_ok"></span><spring:message code='ezResource.t191'/></li><li><span class="sub_iconLNB tree_resource_no"></span><spring:message code='ezResource.kmsr21'/></li> <li><span class="sub_iconLNB tree_resource_refuse"></span><spring:message code='ezResource.kmsr22'/></li> </ul>
	        <ul class="mainmenuTabUL">
	            <li id="ToDaybtn" class="off"><span onClick="setweek_onload('TODAY');"><spring:message code='ezSchedule.t140'/></span></li><li id="Weekbtn" class="on"><span onClick="setweek_onload('WEEK');"><spring:message code='ezSchedule.t141'/></span></li>
	        </ul>
	    </div> --%>
		<%-- <div id="mainmenu" onload = "makePageSelPage()">
  			<ul>
    			<c:if test="${adminFg eq 'Y'}">
    				<li><span onClick="btnAdd_Click();"><spring:message code="ezResource.t363" /></span></li>	
    				<li><span onClick="btnView_Resource();"><spring:message code="ezResource.t17" /></span></li>
    				<!-- <li id="tbar2" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif"></li> -->
    			</c:if>
    			<span id = "noResListSpan">
    			<li id="ToDaybtn"><span onClick="setweek_onload('TODAY');"><spring:message code="ezResource.t251" /></span></li>
    			<li id="Weekbtn"><span onClick="setweek_onload('WEEK');"><spring:message code="ezResource.t253" /></span></li>
    			<!-- 2018-06-05 구해안 허가,비허가 오른쪽으로 ui 수정 -->
				<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t370" /></li>
      			<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code="ezResource.t369" /></li>
  				</span>
  			</ul>
		</div> --%>
		
		<script type="text/javascript">
    		//selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div style="overflow:auto; width:99.5%; height:800px;">
    	<table class="mainlist" style="width:100%; min-width:700px;">
	  			<tr>
	    			<th style="padding:0px; width:30px"><input type="checkbox" name="checkbox" onClick="reverse(this.checked)" id="Checkbox1"></th>
	    			<th> <spring:message code='ezCar.shb03' /></th>
	    			<th style="width:200px"> <spring:message code='ezResource.t106' /></th>
	    			<th style="width:200px"> <spring:message code='ezResource.t367' /></th>
	    			<th style="width:120px"> <spring:message code='ezPersonal.t1024' /></th>		
	  			</tr>
				 <c:if test="${!empty carBrdList}" >
					<c:forEach var="list"  items="${carBrdList}" begin="${start}" varStatus="value">
	  					<tr>
	    					<td style="padding:0;"><input type="checkbox" name="chk" id="chk" value="${list.carID}"></td>
							<td ondblclick="Item_View('${list.carID}');"	style="cursor: pointer; word-wrap:break-word;" align="left">
								
								<c:out value='${list.carName}' />
							</td>
							<td id="OwnerID"  style="word-wrap:break-word;" value="${list.ownerID}" nowrap>${list.ownerNm}
								<c:set var="ownerList" value="${fn:split(list.ownerID, ',') }"/>
								<c:if test="${fn:length(ownerList) > 1 }">
									<spring:message code='ezCircular.t50'/> <c:out value="${fn:length(ownerList)-1}"/><spring:message code='ezCircular.t51'/>
								</c:if>
							</td>
							<td id="OwnerCall" style="word-wrap:break-word;">${list.ownerCall} </td>			
							<td id="makeDate" style="word-wrap:break-word;">${list.car_register_date} </td>		
							
						</tr> 
					</c:forEach>
				</c:if>
				<c:if test="${empty carBrdList}">
					<tr>
	    				<td colspan="5" style="text-align: center"><spring:message code='main.t00026' /></td>
	    			</tr>
				</c:if> 
			</table>
			</div>		
    	<div id="EmptyMsg" style="display:none;">
    	<div class="warningbox">
	        <p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
	        <dl class="warningDL">
	        	<dt>WARNING</dt>
	        	<dd><spring:message code="ezResource.t9900001" /></dd>
	        </dl>
	    </div>
        	<%-- <div class="warningbox01" style="margin-top:155px;">
          		<div class="warningbox02">
  	        		<div class="warnintxt01" >
	        			<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin: 18px 0px 18px 34px;"></span>
	        			<dl class="warningdl">
	        				<dt><img src="/images/notify/warning01.gif" width="183" height="27"></dt>
	        				<dd>
	        					<spring:message code="ezResource.t9900001" />
	        				</dd>
	        			</dl>
	        		</div>
	        	</div>
        	</div> --%>
        </div>
        <!-- layer 팝업 -->
        <!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
        <div id="ResourceInfo" style="display: none; max-width: 700px">
        	<div class="popupJQLayer" style="padding-top:6px">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:650px; white-space:nowrap; margin-bottom:2px;"></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span></span></a></li>
		            </ul>
		        </div>
	        	<table id="resourceDataTable" style="width:680px; /* margin-top:10px; */">
					<tr>
						<th width="22%" style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t153'/></th>
						<td colspan="2"><span id="ownerNm"><span id="ownerInfo" style="cursor:pointer"></span></span></td>
					</tr>
					<%-- <tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.rkms01'/></th>
						<td><span id="submanager"></span></td>
					</tr> --%>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t155'/></th>
						<td colspan="2"><span id="ownerCall"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t148'/></th>
						<td colspan="2" style="word-break:break-all;" id="resLocation"><%-- ${resLocation} --%></td>
					</tr>							
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td colspan="2" id="approveFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.kmsr11'/></th>
						<td colspan="2" id="returnFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezBoard.t5007'/></th>
						<td colspan="2"><span id="resDate"></span></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code="ezPortal.t202"/></th>
						<td style="width:39%; border-right: 0"><img id="preview1" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block; border-right: 0px;"></td>
						<td style="border-left: 0"><img id="preview2" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block;"></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code='ezResource.t271'/></th>
						<td colspan="2"><div style="overflow-y: auto; height: 200px; word-break:break-all; white-space:pre-wrap;" id="brdExplain"></div></td>
					</tr>
	         	</table>
	         </div>	
        </div>
	</body>
</html>
