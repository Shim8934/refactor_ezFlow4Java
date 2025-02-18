<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t403" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
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
			.warningbox{margin:240px auto 0px auto; padding:40px 20px 0px 20px; font-family:Malgun Gothic; width:625px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box;}
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
			var pBrdid = "<c:out value='${brdID}'/>";
	    	var pBrdnm = "<c:out value='${brdNm}'/>";
	    	var pAccessCode = "<c:out value='${accessCode}'/>";
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
		    var pStartday = "${startDay}";		
		    var lunarUseFlag = "${lunarUseFlag}";
		    var lunarUse = "${lunarUse}";
		    /* select_memorialDays("${lang}"); */
		    var dayView = "";
		    var rID = "<c:out value='${ownerID}'/>";

	
	    	window.onload = function () {
	    		showRes(rID);
	    	}
	    	

		    function CheckAdmin() {
		        if (pAdminFg == "Y")
	    	        return true;
	        	else
		            return false;
		    }
	    	
	    	function showRes(val01) {
	    		$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezResource/scheduleResourceData.do",
					data : { 
						resourceId   : val01						
					},
					success: function(result){
						// 2018-10-30 김민성 - 자원 정보 레이어 팝업 관리자 리스트, 관리자 정보 조회, 등록일 정보 추가
						var ownerID = result.resBrd.ownerID;
						var subOwner = result.ownerList;
						var strOwnerList = "";
						
						for(var i=0; i<subOwner.length; i++) {
							strOwnerList += "<span onclick=\"OpenUserInfo('" + subOwner[i].cn + "','" + subOwner[i].department + "')\">"+subOwner[i].displayName+"</span>";
							if(i != subOwner.length-1) {
								strOwnerList += ", ";
							}
						}
						
						$("#brdNm").html(MakeXMLString(result.resBrd.brdNm));
						$("#ownerCall").html(MakeXMLString(result.resBrd.ownerCall));
						$("#resLocation").html(MakeXMLString(result.resBrd.resLocation));					
						
						$("#ownerInfo").html(strOwnerList);
						
						var approveFlag = result.resBrd.approveFlag;
						
						if (approveFlag == "1") {
							$("#approveFlag").html("<spring:message code='ezResource.t272'/>");
						} else {
							$("#approveFlag").html("<spring:message code='ezResource.t273'/>");
						}

						// 반복예약허용 Flag
						var repeatFlag = result.resBrd.repeatFlag;

						if (repeatFlag == "1") {
							$("#repeatFlag").html("<spring:message code="ezResource.lyj02"/>");
						} else {
							$("#repeatFlag").html("<spring:message code="ezResource.lyj03"/>");
						}
						
						$("#resDate").html(result.resBrd.makeDate);
						
						var resbrdExc = "";
						if (result.resBrd.brdExplain != null) {
							resbrdExc = MakeXMLString(result.resBrd.brdExplain);
						}
						
						$("#brdExplain").html(resbrdExc);
						
						if(result.attachList1 != null) {
							document.getElementById("preview1").src = "/ezResource/getResourceThumbnailInfo.do?brdID=" + val01 + "&fileName=" + encodeURIComponent(result.attachList1);
							document.getElementById("preview1").width = 200;
							document.getElementById("preview1").height = 200;
						}
						else {
							document.getElementById("preview1").src = "/images/default_pic.jpg";
							document.getElementById("preview1").width = 120;
							document.getElementById("preview1").height = 120;
						}
						
						if(result.attachList2 != null) {
							document.getElementById("preview2").src = "/ezResource/getResourceThumbnailInfo.do?brdID=" + val01 + "&fileName=" + encodeURIComponent(result.attachList2);
							document.getElementById("preview2").width = 200;
							document.getElementById("preview2").height = 200;
						}
						else {
							document.getElementById("preview2").src = "/images/default_pic.jpg";
							document.getElementById("preview2").width = 120;
							document.getElementById("preview2").height = 120;
						}
						
					}, 
					error: function() {
						
					}
				});	    		
	        }
			
			// 18-10-19 김민성 - 작성자 이름 클릭 시 사원정보보기 팝업
			function OpenUserInfo(userID, deptID) {
	        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
	            feature = feature + GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + userID + "&dept=" + deptID, "", feature);
	        }
			
			function btnClose_onclick() {
		        window.close();
		    }
		</script>
	</head>
	<body class="mainbody" style="overflow:hidden; margin: 0; padding: 0;">
        <div id="ResourceInfo" style="display: auto; width: 100%;">
        	<div class="popupJQLayer">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:100%; white-space:nowrap; margin-bottom:2px;"></div>
				<div id="close">
		        <ul>
		          <li><span onclick="btnClose_onclick()"></span></li>
		        </ul>
		      </div>
	        	<table id="resourceDataTable" style="width:100%;">
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
						<th style="height:30px;background-color: #fafafa"><spring:message code="ezResource.lyj01"/></th>
						<td colspan="2" id="repeatFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td colspan="2" id="approveFlag"></td>
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
