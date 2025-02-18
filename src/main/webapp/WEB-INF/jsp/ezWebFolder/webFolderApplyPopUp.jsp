<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
<style>
	.memList {
		width:100%; height:75px; border: 1px solid #ccc; overflow:auto;
	}
	.memList ul {
		list-style: none; padding: 0;
	}
	.memList ul > li{
		box-sizing: border-box; padding: 5px;
	}
	#applicationPopup th {
		text-align: center;
	}
</style>
<!-- 웹폴더 개설신청 팝업 -->
<div id="applicationPopup" class="popupwrap3" style="display:none;margin-bottom:70px">
	<div class="popupJQLayer">
		<div class="title"><spring:message code='ezWebFolder.ksa15' /></div>
		<div id="close">
            <ul>
                <li><a rel="modal:close"><span onclick="closeApplicationPopUp()"></span></a></li>
            </ul>
        </div>
        
        <table class="content" style="margin-top:10px ">
        	<tr>
        		<th>
        			<span id="popTitle"><spring:message code="ezWebFolder.ksa04"/></span>
        			<span style="color:red;">*</span>
        		</th>
        		<td><input type="text" id="wfName" class="wfAppformINPUT" style="width:100%;" maxlength="50"></td>
        	</tr>
        	<tr style="height:80px;">
        		<th>
        			<div style="margin-bttom: 3px;">
	        			<a class="imgbtn"><span onClick="showAppliMembersPopUp('master')"><spring:message code="ezWebFolder.ksa07"/></span></a>
	        			<span style="color:red;">*</span>
        			</div>
        			<span class="masterCnt"></span>
        		</th>
        		<td>
        			<div id="wfMaster" class="memList wfAppformHTML"></div>
        		</td>
        	</tr>
        	<tr style="height:80px;">
        		<th>
        			<div style="margin-bttom: 3px;">
        				<a class="imgbtn"><span onClick="showAppliMembersPopUp('member')"><spring:message code="ezWebFolder.ksa08"/></span></a>
        			</div>
        			<span class="memberCnt"></span>
        		</th>
        		<td>
        			<div id="wfMember" class="memList wfAppformHTML"></div>
        		</td>
        	</tr>
        	<tr style="height:150px;">
        		<th>
        			<spring:message code="ezWebFolder.ksa14"/>
        		</th>
        		<td><textarea id="wfContent" maxlength="300" class="wfAppformINPUT" style="resize:none;width: 100%;height: 150px;box-sizing: border-box; overflow:auto;"></textarea></td>
        	</tr>
        </table>
        
        <table style="width:100%">
			<tr>
				<td style="text-align:center;">
					<div class="btnpositionLayer">
						<a class="imgbtn"><span onClick="applyForWebFolder()"><spring:message code='ezWebFolder.ksa16' /></span></a>
						<a class="imgbtn"><span onClick="closeApplicationPopUp()"><spring:message code='ezWebFolder.ksa17' /></span></a>
					</div>	
				</td>
			</tr>
		</table>
	</div>
	<div style="position:absolute;top:0;left:0;z-index:5000;display:none;background:rgba(0,0,0,0.5)" id="dimPanel">
		<div id="listload_div" class="loadingBox2" style="z-index: 7500;">
			<div class="loader loader-3">
				<div class="dot dot1"></div>
				<div class="dot dot2"></div>
				<div class="dot dot3"></div>
				<div class="dot dot4"></div>
			</div>
		</div>
	</div>
</div>	

<script>
	var popTypemsg = "<spring:message code='ezWebFolder.ksa04'/>";
	var memTypeMsg = {"JIKWI":"<spring:message code='main.t77'/>","JIKCHEK":"<spring:message code='ezOrgan.t1500'/>",
        "GROUP":"<spring:message code='ezOrgan.zNo001'/>","DEPT":"<spring:message code='main.t75'/>"};
	var peopleMsg = "<spring:message code='ezWebFolder.ksa65' />";
	var appMasterArr = [];
	var appMemberArr = [];
	var appliMembersPopUp;
	
	function applicationPopUp() {
		$("#popTitle").text(popTypemsg);
		//$("#usage_period").css("display","none");
		
		showApplicationPopUp();
	}
	
	function showApplicationPopUp(obj) {
        var leftBody = parent.frames["left"].document.body;
        leftBody.style.overflow = "hidden";
    	$("<div id='blockLeft' class='blockLeft' style='position: fixed;' onclick='parent.frames[\"right\"].closeApplicationPopUp();'></div>").appendTo(leftBody);        	
    	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
    	
    	$("#applicationPopup").css("left", popupX);
    	
    	$("#applicationPopup").modal();
    	$("#applicationPopup").off("modal:close").on("modal:close", function() {
    		clearApplicationPopUp();
    		parent.frames["left"].document.body.style.overflow = "auto";
    	});
    }
	
	function clearApplicationPopUp() {
		appMasterArr = [];
		appMemberArr = [];
		
		//$("#Sdatepicker_meeting, #Edatepicker_meeting").datepicker("option", {minDate: 0, maxDate: null});
		
		$(".wfAppformINPUT").val("");
		$(".wfAppformHTML").html("");
		$(".masterCnt, .memberCnt").text("");
	}

	function closeApplicationPopUp() {
		if (appliMembersPopUp != null && !appliMembersPopUp.closed) {
			appliMembersPopUp.close();
		}
		
		clearApplicationPopUp();
		$.modal.close();
	}
	
	function applyForWebFolder() {
		var wfName = $("#wfName").val();
		var wfContent = $("#wfContent").val();
		//var wfUsingS = $("#Sdatepicker_meeting").val();
		//var wfUsingE = $("#Edatepicker_meeting").val();
		
		if (isEmptyStr(wfName) || appMasterArr.length <= 0) {
			alert("<spring:message code='ezWebFolder.ksa21' />");
			return;
		} else if (isValidName(wfName)) {
			alert('<spring:message code="ezWebFolder.t211"/>');
			return;
		}
		
		setDim(true);
		var sTimeOut = setTimeout(function() { // setTimeout 안하면 dim 처리가 안됨..
			$.ajax({
				type: "post",
				url: "/ezWebFolder/applyForWebFolder.do",
				async: false,
				data: {
					wfName : wfName,
					wfContent : wfContent,
					//wfUsingS : wfUsingS,
					//wfUsingE : wfUsingE,
					appMasterArr : JSON.stringify(appMasterArr),
					appMemberArr : JSON.stringify(appMemberArr)
				},success: function(data) {
					if (data == "OK") {
						alert("<spring:message code='ezWebFolder.ksa22'/>");
						closeApplicationPopUp();
					} else if (data == "DUPLICATE_NAME") {
						alert("<spring:message code='ezWebFolder.ksa53' />");
					} else {
						alert("<spring:message code='ezWebFolder.ksa23' /> : " + data);
					}
				}, error: function() {
					alert("<spring:message code='ezWebFolder.ksa23' />");
				}
			});
		
			setDim(false);
			clearTimeout(sTimeOut);
		}, 500);
	}

	function showAppliMembersPopUp(type) {
		var url = "/ezWebFolder/personalPopUpUser.do";
		var param = "?type="+encodeURIComponent(type);
		
		var popW = 970;
		var popH = 680;
		var popLeft = (window.screen.width - popW) / 2; 
		    popLeft += window.screenLeft;
		var popTop = (screen.availHeight / 2) - (popH / 2);
		
		var option = "left=" + popLeft + ", top=" + popTop + ", width=" + popW + ", height=" + popH;
		
		appliMembersPopUp = window.open(url+param, "appliMembers", option);
	}

	function getAppliMembers(type) {
		var tt = type == "master" ? appMasterArr : appMemberArr;
		tt = (typeof tt == "undefined") ? [] : tt;
		return tt;
	}
	
	function setAppliMembers(type, userList) {
		var setDIV = (type=="master") ? $("#wfMaster") : $("#wfMember");
		var tempArr = JSON.parse(JSON.stringify(userList));
		var setDIVHtml = "<ul>";
		
		$.each(userList, function(i,e) {
			var strTemp = "";
			var eUserName = e.userName;
			var eUserType = e.userType;
			
			if (eUserType == "USER") { 
				strTemp = eUserName + "("+e.deptName+")"; 
			} else { // jikwi, jikchek, gruop, dept
				var tt = memTypeMsg[eUserType];
				strTemp = tt + " : " + eUserName;
			}
			
			tempArr[i].sUserName = strTemp;
			setDIVHtml += "<li>"+strTemp+"</li>";
		});
		
		setDIVHtml += "</ul>";
		setDIV.html(setDIVHtml);
		
		if (type=="master") {
			appMasterArr = JSON.parse(JSON.stringify(tempArr));
		} else {
			appMemberArr = JSON.parse(JSON.stringify(tempArr));
		}
		
		memListCnt();
	}

	function isEmptyStr(str) {
		return (str.trim().length > 0) ? false : true;
	}
	
	function setDim(dim) {
		var dimPanelDIV = document.getElementById("dimPanel");
		if (dim) {
			dimPanelDIV.style.display = "block";
			dimPanelDIV.style.width = "100%";
			
			// 크롬/ie dim 크기차이 때문에 라인 생기는 문제 수정 
			var agent = navigator.userAgent.toLowerCase();
			if (agent.indexOf("chrome") != -1) {
				dimPanelDIV.style.height = "100%";
			} else {
				dimPanelDIV.style.left = "-0.3px";
				dimPanelDIV.style.top = "+0.1px";
				dimPanelDIV.style.height = "100.1%";
			}
			dimPanelDIV.style.borderRadius  = "4px";
		} else {
			dimPanelDIV.style.display = "none";
		}
	}
	
	function isValidName(str) {
		var regex = /[*:"\\|<>\/?]/g;
		return regex.test(str);
	}
	
	var memList = {"#wfMaster" : ".masterCnt", "#wfMember" : ".memberCnt"};
	function memListCnt() {
		$.each(memList, function(i, e) {
			var cnt = $(i).find("li").length;
			var msTxt = cnt == 0 ? "" : "(" + cnt + peopleMsg + ")";
			
			$(e).text(msTxt);
		});
	}
	
	/* $("#Sdatepicker_meeting").datepicker({
		changeYear: true,
		changeMonth: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.png",
		buttonImageOnly: true,
		minDate: 0,
		onClose: function(sDate) {
			sDate = sDate=="" ? 0 : sDate;
			$("#Edatepicker_meeting").datepicker("option", "minDate", sDate);
		}
	});
	$("#Edatepicker_meeting").datepicker({
		changeYear: true,
		changeMonth: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.png",
		buttonImageOnly: true,
		minDate: 0,
		onClose: function(eDate) {
			$("#Sdatepicker_meeting").datepicker("option", "maxDate", eDate);
		}
	});
	
	
	var monthMsg = "<spring:message code='ezSchedule.t110' />";
    var monthStr = monthMsg.split(";");		    
    var dayMsg = "<spring:message code='ezSchedule.t108' />";
    var dayStr = dayMsg.split(";");
    
    $.datepicker.regional["<spring:message code='main.t0619' />"] = {
    	closeText: "<spring:message code='main.t3' />",
        prevText: "<spring:message code='main.t0604' />",
        nextText: "<spring:message code='main.t0605' />",
		currentText: "<spring:message code='main.t0606' />",
        monthNames: monthStr,
        monthNamesShort: monthStr,
        dayNames: dayStr,
        dayNamesShort: dayStr,
        dayNamesMin: dayStr,
        weekHeader: 'Wk',
        dateFormat: 'yy-mm-dd',
        firstDay: 0,
        isRTL: false,
        duration: 200,
        showAnim: 'show',
        showMonthAfterYear: true
    };
    
    $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);*/
</script>
