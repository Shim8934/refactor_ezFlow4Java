<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezAttitude.t4' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>
	    
 	    <style> 
	    	#contentlist table.mainlist tr:not(.tr_noItems) td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		cursor : pointer;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR  {background-color: #FFFFFF;}
			#searchTable {
				border: 1px solid #e8e8e8;
				background-color: #f8f8fa;
			}
			#searchTable td {padding: 8px 5px;}
	    </style>

	    <script type="text/javascript">
	    	var pCompanyId = ""; //현재 선택된 회사의 아이디
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchGubun = ""; // 검색조건(구분)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartTime = "";
	    	var searchEndTime = "";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var selecUserList = "";//리스트에 선택된 userList(,로 구분)
	    	var adminCompany = "${adminCompany}";
	    	var listSize = 15;
	    	
	    	$(function(){
	    		windowResize();
	    		
	    		$('#searchStartTime').timepicker({ 'timeFormat': 'H:i' });
        		$('#searchEndTime').timepicker({ 'timeFormat': 'H:i' });
        		
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("<spring:message code = 'ezAttitude.t32' />");
		        } else {
		    		if (adminCompany != null) {
		    			$('#ListCompany').val(adminCompany);
		    			if (document.getElementById("ListCompany").selectedIndex < 0) {
				            document.getElementById("ListCompany").selectedIndex = 0;
		    			}
		    		} else {
			            document.getElementById("ListCompany").selectedIndex = 0;
		    		}
		    		
		            company_change();
		        }
	    		
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '#contentlist table.mainlist th', function(){
	    			if (totalCount != 0) {
		    			if (!$(this).find("input[type=checkbox]").length) { // checkbox는 sort에서 제외
		    				if (!$(this).find("img").length) { // 새로운 th를 클릭한 경우
		    					src = "";
		    					orderOption = "";
		    					orderCell = $(this).attr("colname");
		    				}
		    			
			    			if (orderOption == "" || orderOption == "DESC") {
			    				src = '/images/etc/view-sortup.gif';
			    				orderOption = "ASC";
			    			} else {
			    				src = '/images/etc/view-sortdown.gif';
			    				orderOption = "DESC";
			    			}
			    			
			    			$("#contentlist table.mainlist th").find("img").remove();
			    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
			    			
			    			getUserConfList();
		    			}
	    			}
	    		});
	    	});
	    	
	    	$(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 212 - document.getElementById("mainmenu").clientHeight;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
	    	
	    	function company_change() {
	    		pCompanyId = $("select[name=ListCompany]").val();
	    		
    			//검색초기화
    			$("#searchUserName").val("");
    			$("#searchDeptName").val("");
    			$("#searchTitle").val("");
    			$("#searchStartTime").val("");
    			$("#searchEndTime").val("");
    			$("[type='radio'][value='']").prop("checked", true);
    			
    			searchUserName = "";
    			searchDeptName = "";
    			searchTitle = "";
    			searchStartTime = "";
    			searchEndTime = "";
    			searchGubun = "";
	    		
	    		getUserConfList();
	    	}
	    	
	    	function ShowMailProgress() {
				var CurrenWidth = window.innerWidth;
	        	
			    document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = "330px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
	    	
	    	function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}
	    	
	    	function getUserConfList() {
	    		if (!checkPattern()) {
	    			alert("<spring:message code= 'ezAttitude.t117' />")
	    			return;
	    		}
	    		
	    		if (searchStartTime > searchEndTime) {
					alert("<spring:message code='ezAttitude.t131' />");
		            return;
				}
	    		
	    		$.ajax({
	    			type : "post",
	    			dataType : "json",
	    			async : false,
	    			url : "/admin/ezAttitude/attitudeUserConfList.do",
	    			data : {
	    				companyId : pCompanyId,
	   					userName : searchUserName,
	   					deptName : searchDeptName,
	   					title : searchTitle,
	   					startTime : searchStartTime,
	   					endTime : searchEndTime,
	   					gubun : searchGubun,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
	   				},
					beforeSend : function() {
	   					ShowMailProgress();
					},
	   				success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				
	    				getUserConfList_after(result.list);
	    				if (totalCount != 0) {
		    				//더블클릭 이벤트
		    				addTrDblclickEvent(userDbClick);
	    				}
	    				
	    				$("#HeaderAllCheckBox").prop("checked",false);
	    				
	    			},
	    			complete : function() {
	    				HiddenMailProgress();
	    			}
	    		});
	    	}
	    	
	    	function getUserConfList_after(result) {
	    		var resultHtml = "";
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr userid='" + vo.userId + "'><td><div class='custom_checkbox'><input type='checkbox' style='margin: 0px; padding: 0px; width:13px; height: 13px;'/></div></td>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td>";
	    			resultHtml += "<td>" + vo.workStartTime + " ~ " + vo.workEndTime + "</td>";
	    			resultHtml += "<td>" + (vo.gubun == "0" ? "<spring:message code='ezAttitude.t118' />" : "<spring:message code='ezAttitude.t119' />") + "</td></tr>";
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr class='tr_noItems'><td colspan='6' style='text-align:center;cursor: ;'><spring:message code='ezAttitude.t130' /></td></tr>";
	    		}
	    		
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	    	
	    	function searchUserConfList(searchType) {
	    		if (searchType == "search") {
	    			searchUserName = $("#searchUserName").val();
	    			searchDeptName = $("#searchDeptName").val();
	    			searchTitle = $("#searchTitle").val();
	    			searchStartTime = $("#searchStartTime").val();
	    			searchEndTime = $("#searchEndTime").val();
	    			searchGubun = $("[type='radio']:checked").val();
	    		} else {
	    			//새로고침
	    			$("#searchUserName").val("");
	    			$("#searchDeptName").val("");
	    			$("#searchTitle").val("");
	    			$("#searchStartTime").val("");
	    			$("#searchEndTime").val("");
	    			$("[type='radio'][value='']").prop("checked", true);
	    			
	    			searchUserName = "";
	    			searchDeptName = "";
	    			searchTitle = "";
	    			searchStartTime = "";
	    			searchEndTime = "";
	    			searchGubun = "";
	    		}
	    		
	    		$("#contentlist table.mainlist th").find("img").remove();
	    		orderOption = "";
    			orderCell = "";
    			
	    		pageNum = 1;
    			getUserConfList();
	    	}
	    	
	    	//페이지 이동 함수
	    	function goToPageByNum(pCurPage) {
	    		if (pCurPage == 0 || totalPage < pCurPage) {
	    			return;
	    		} else {
		    		pageNum = pCurPage;
	    		}
	    		
	    		getUserConfList();
	    	}
	    	
	    	function editUserConfList() {
	    		selectedUserIdList = "";
	    		var trIdx = $('#contentlist .mainlist tbody').find('tr').length;
	   			for (var i = 0; i < trIdx; i++) {
	   				if ($('#contentlist .mainlist tbody tr').eq(i).find("input[type='checkbox']").is(":checked")) {
	   					selectedUserIdList += $('#contentlist .mainlist tbody tr').eq(i).attr('userid') + ", ";
	   				}
	   			}
	   			
	   			selectedUserIdList = selectedUserIdList.slice(0, -2);
	   			
	   			if (selectedUserIdList == "") {
	   				alert("<spring:message code = 'ezAttitude.t120' />");
	   			} else {
		   			editUserConf(selectedUserIdList);
	   			}
	    	}
	    	
	    	function editUserConf(selectedUserIdList) {
    			var url = "/admin/ezAttitude/editAttitudeUserConf.do?selectedUserIdList=" + selectedUserIdList + "&companyId=" + pCompanyId;
	    		
    			window.open(url, "", GetOpenWindowfeature(450, 180));
    			
// 	    		if (CrossYN()) {
// 	    			OpenWin = GetOpenWindow2(url, "", "340", "180");
	    			
// 	    			try { OpenWin.focus();} catch (e) { }
// 	    		} else {
// 	    			showModalDialog(url, null, "dialogWidth:340px; dialogHeight:180px; status:no; help:no; scroll:no; edge:sunken");
// 	    		}
	    	}
	    	
	    	function userDbClick() {
	    		if ($("#HeaderAllCheckBox").is(":checked") == true) {
	    			$("#HeaderAllCheckBox").prop("checked", false);
	    		}
	    		//선택한 tr외에 체크를 푼다.
	    		var trIdx = $('#contentlist .mainlist tbody').find('tr').length;
	   			for (var i = 0; i < trIdx; i++) {
	   				if ($('#contentlist .mainlist tbody tr').eq(i).find("input[type='checkbox']").is(":checked")) {
	   					$('#contentlist .mainlist tbody tr').eq(i).find("input[type='checkbox']").prop('checked', false);
	   					$('#contentlist .mainlist tbody tr').eq(i).removeClass();
	   					$('#contentlist .mainlist tbody tr').eq(i).css("background-color", m_strColorDefault);
	   				}
	   			}
	   			//선택한 tr체크
	   			$(this).find("input[type='checkbox']").prop("checked", true);
	   			$(this).addClass("selectTR");
	   			$(this).css("background-color", m_strColorSelect);
	   			
	    		editUserConf($(this).attr('userid'));
	    	}
	    	
	    	function checkPattern() {
				var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/;
				
				if ((timePattern.test($("#searchStartTime").val()) && timePattern.test($("#searchEndTime").val())) || ($("#searchStartTime").val() == "" && $("#searchEndTime").val() == "")) {
					return true;
				} else {
					if (!timePattern.test($("#searchStartTime").val())&& !timePattern.test($("searchEndTime").val())) {
						$("#searchStartTime").focus();
						return false;
					} else if (!timePattern.test($("#searchStartTime").val())) {
						$("#searchStartTime").focus();
						return false;
					} else if (!timePattern.test($("#searchEndTime").val())) {
						$("#searchEndTime").focus();
						return false;
					}
				}
			}
	    	
	    	function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	searchUserConfList('search');
		            }
		        } else {
		            if (evt.which == 13)
		            	searchUserConfList('search');
		        }
		    }
	    	
	    	function editDeptConfList() {
    			var url = "/admin/ezAttitude/editAttitudeDeptConf.do?companyId=" + pCompanyId;
	    		
    			window.open(url, "", GetOpenWindowfeature(555, 652));
    			
// 	    		if (CrossYN()) {
// 	    			OpenWin = GetOpenWindow2(url, "", "500", "652");
	    			
// 	    			try { OpenWin.focus();} catch (e) { }
// 	    		} else {
// 	    			showModalDialog(url, null, "dialogWidth:500px; dialogHeight:652px; status:no; help:no; scroll:no; edge:sunken");
// 	    		}
	    	}
	    </script>
	</head>
	
	<body class="mainbody">
	    <h1>
	    	<spring:message code = 'ezAttitude.t4' /><span id="mailBoxInfo"></span>
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
	    	<select class="companySelect" name="ListCompany" id="ListCompany" onchange="company_change()">
				<c:forEach var = "companyItem" items="${list }">
					<option value="<c:out value = '${companyItem.cn }' />"><c:out value = '${companyItem.displayName }'/></option>
				</c:forEach>
     		</select>
	    </h1>
		<div id="mainmenu"></div>
	  	
	  	<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t9' /></td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t10' /></td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t13' /></td>
					<td style="width: 20%;">
						<span style="width: 90%;">
							<div class="custom_radio"><input type="radio" name="searchGubun" value="" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;" checked="checked"/></div>&nbsp;<spring:message code='ezAttitude.t124' />
							<div class="custom_radio"><input type="radio" name="searchGubun" value="0" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;"/></div>&nbsp;<spring:message code='ezAttitude.t118' />
							<div class="custom_radio"><input type="radio" name="searchGubun" value="1" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle;"/></div>&nbsp;<spring:message code='ezAttitude.t119' />
						</span>
					</td>
				</tr>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t11' /></td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t12' /></td>
					<td style="width: 12%;">
						<span id="topmenu"><input id="searchStartTime" type="text" style="width:50px; text-align:center;"/>&nbsp; ~ &nbsp;<input id="searchEndTime" type="text" style="width:50px; text-align:center;"/></span>
					</td>
					<td style=" width:*;" colspan=2>
						<a class="imgbtn"><span onclick="searchUserConfList('search');"><spring:message code='ezAttitude.t121' /></span></a>
						<a class="imgbtn"><span onclick="searchUserConfList('refresh');"><spring:message code='ezAttitude.t122' /></span></a>
						<a class="imgbtn"><span onclick="editUserConfList();"><spring:message code='ezAttitude.t123' /></span></a>
						<a class="imgbtn"><span onclick="editDeptConfList();"><spring:message code='ezAttitude.t225' /></span></a>
					</td>
				</tr>
			</tbody>
		</table>
		
		<div id="contentlist" style="width:100%; height:590px;margin-top:5px">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="width:20px;"><div class="custom_checkbox"><input id="HeaderAllCheckBox" type="checkbox" style="margin: 0px; padding: 0px; width:13px; height: 13px;"/></div></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9'/></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="workstarttime"><spring:message code='ezAttitude.t12' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="gubun"><spring:message code='ezAttitude.t13' /></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		
		
		<div id="tblPageRayer"></div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
	</body>
</html>