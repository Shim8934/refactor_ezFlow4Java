<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezAttitude.t5' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
	    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>
	    <!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- date Format -->		
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/moment.min.js')}"></script>
	    <style>
	    	#contentlist table.mainlist tr:not(.tr_noItems) td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		cursor : pointer;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR {background-color: #f1f8ff;}
			#searchTable {
				border: 1px solid #e8e8e8;
				background-color: #f8f8fa;
			}
			#searchTable td {padding: 8px 5px;}
	    </style>
	    
	    <script type="text/javascript">
	    	var pCompanyId = ""; //현재 선택된 회사의 아이디
	    	//검색조건 저장 변수
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchAttitudeType = "ALL"; // 검색조건(근태유형)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartDate = "${searchStartDate}";
	    	var searchEndDate = "${searchEndDate}";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var adminCompany = "${adminCompany}";
	    	var listSize = 15;
	    	
	    	$(function(){
	    		windowResize();
	    		
	    		$("#Sdatepicker").val("${searchStartDate}");
	    		$("#Edatepicker").val("${searchEndDate}");
	    		
	    		//회사리스트
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
	    			if (!$(this).find("input[type=checkbox]").length && $(this).attr("colname") != "NO") { // checkbox는 sort에서 제외
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
		    			
		    			getAttitudeCheckList();
	    			}
	    		});
	    	});
	    	
	    	//datepicker
	    	$(function () {
			    $("#Sdatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
			    });
			    $("#Edatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.png",
			        buttonImageOnly: true
			    });
			});
			    
	    	var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
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
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
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
			
	    	function company_change(){
	    		pCompanyId = $("select[name=ListCompany]").val();
	    		getAttitudeCheckList();
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
	    	
	    	function getAttitudeCheckList(){
    			searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("<spring:message code='ezAttitude.t131' />");
		            return;
				}
	    		
	    		$.ajax({
	    			type : "GET",
	    			dataType : "json",
	    			async : false,
	    			url : "/admin/ezAttitude/attitudeCheckList.do",
	    			data : {
	    				companyId : pCompanyId,
	   					userName : searchUserName,
	   					deptName : searchDeptName,
	   					title : searchTitle,
	   					startDate : searchStartDate,
	   					endDate : searchEndDate,
	   					attitudeType : searchAttitudeType,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
    				},
    				beforeSend : function(){
    					ShowMailProgress();
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAttitudeCheckList_after(result.list);
	    				//근태유형 리스트
// 	    				getAttitudeTypeList(result.typeList, result.typeId);
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			},
	    			complete : function() {
	    				HiddenMailProgress();
	    			}
	    		});
	    	}
	    	
	    	//검색 > 근태유형selectBox
	    	/*
	    	function getAttitudeTypeList(typeList, typeId) {
	    		var html = "<option value='total'><spring:message code='ezAttitude.t124' /></option>";
	    		
	    		for (var i = 0; i < typeList.length; i ++) {
	    			html += "<option value='" + typeList[i].typeId + "'>" + typeList[i].typeName +  "</option>";
	    		}
	    		
	    		$('#searchAttitudeType').html(html);
	    		
	    		if (typeId != "") {
	    			$('#searchAttitudeType').val(typeId);
	    		}
	    	}
	    	*/
	    	
	    	function getAttitudeCheckList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr attitudeId='" + vo.attitudeId + "' typeId='" + vo.typeId + "' userid='" + vo.writerId + "' ondblclick=attDetail(this);>";
	    			resultHtml += "<td style='padding-left: 15px;'>" + i + "</td>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td>";
	    			
	    			if (vo.endDate == null || vo.endDate == "") {
	    				if(vo.typeId == "A25") {
	    					var date = new Date(vo.startDate.substring(0,4), Number(vo.startDate.substring(5,7))-1 , Number(vo.startDate.substring(8,10)));
							date.setDate(date.getDate()+1);	    					
		    				resultHtml += "<td style='width: 30%;'>" + moment(date).format('YYYY-MM-DD') + " " + vo.startDate.substring(11,16) + "</td>";
	    				} else {
		    				resultHtml += "<td style='width: 30%;'>" + vo.startDate.substring(0,16) + "</td>";
	    				}
	    			} else {
	    				if (vo.dateType == 4) {
	    					resultHtml += "<td>" + vo.startDate.substring(0,11) + " ~ " + vo.endDate.substring(0,11) + "</td>";
	    				} else {
		    				resultHtml += "<td>" + vo.startDate.substring(0,16) + " ~ " + vo.endDate.substring(0,16) + "</td>";
	    				}
	    			}
	    			
	    			resultHtml += "<td>" + vo.typeName + "</td></tr>";
	    			
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems' class='tr_noItems'><td colspan='6' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>";	
	    		}
	    		
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	    	
	    	//페이지 이동 함수
	    	function goToPageByNum(pCurPage){
	    		if (pCurPage == 0 || totalPage < pCurPage) {
	    			return;
	    		} else {
		    		pageNum = pCurPage;
	    		}
	    		
	    		getAttitudeCheckList();
	    	}
	    	
			function searchAttitudeCheckList(searchType){
				if (!checkPattern()) {
					alert("<spring:message code='ezAttitude.t132' />")
					return;
				}
				
	    		if (searchType == "search") {
	    			searchUserName = $("#searchUserName").val();
	    			searchDeptName = $("#searchDeptName").val();
	    			searchTitle = $("#searchTitle").val();
	    			searchStartDate = $("#Sdatepicker").val();
	    			searchEndDate = $("#Edatepicker").val();
	    			searchAttitudeType = $("select[id='searchAttitudeType']").val();
	    		} else {
	    			//새로고침
	    			$("#searchUserName").val("");
	    			$("#searchDeptName").val("");
	    			$("#searchTitle").val("");
	    			$("#Sdatepicker").val("${searchStartDate}");
	    			$("#Edatepicker").val("${searchEndDate}");
	    			$("select[id='searchAttitudeType']").val('ALL');
	    			
	    			searchUserName = "";
	    			searchDeptName = "";
	    			searchTitle = "";
	    			searchStartDate = "${searchStartDate}";
	    			searchEndDate = "${searchEndDate}";
	    			searchAttitudeType = "total";
	    		}
	    		
	    		$("#contentlist table.mainlist th").find("img").remove();
	    		orderOption = "";
	    		orderCell = "";
	    		
	    		pageNum = 1;
    			getAttitudeCheckList();
	    	}
			
			//엑셀 다운로드
			function exportExcel() {
				if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert("<spring:message code='ezAttitude.t56'/>");
					return;
				}
				
		    	exportExcelframe.location.href="/ezAttitude/excelAttitudeListExport.do?companyId=" + encodeURIComponent(pCompanyId) + "&userName=" + encodeURIComponent(searchUserName) + "&deptName=" + encodeURIComponent(searchDeptName) + "&title=" + encodeURIComponent(searchTitle) + "&startDate=" + encodeURIComponent(searchStartDate) + "&endDate=" + encodeURIComponent(searchEndDate) + "&attitudeType=" + encodeURIComponent(searchAttitudeType) + "&orderCell=" + encodeURIComponent(orderCell) + "&orderOption=" + encodeURIComponent(orderOption);
		    	exportExcelframe.target="_blank";
			}
			
			function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	searchAttitudeCheckList('search');
		            }
		        } else {
		            if (evt.which == 13)
		            	searchAattitudeCheckList('search');
		        }
		    }
			
			function checkPattern() {
				var datePattern =  /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
				
				if (datePattern.test($("#Sdatepicker").val()) && datePattern.test($("#Edatepicker").val())) {
					return true;
				} else {
					if (!datePattern.test($("#Sdatepicker").val())&& !datePattern.test($("Edatepicker").val())) {
						$("#Sdatepicker").focus();
						return false;
					} else if (!datePattern.test($("#Sdatepicker").val())) {
						$("#Sdatepicker").focus();
						return false;
					} else if (!datePattern.test($("#Edatepicker").val())) {
						$("#Edatepicker").focus();
						return false;
					}
				}
			}
			
			function attDetail(obj) {
				var pAttitudeId = obj.getAttribute("attitudeId"); 
				var pTypeId = obj.getAttribute("typeId");
				
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId + "&companyID=" + pCompanyId, "", GetOpenWindowfeature(672, 640));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
				}
		    }
			
			function addAtt() {
				today = new Date();
		    	dd = today.getDate();
		    	mm = today.getMonth()+1; //January is 0!
		    	yyyy = today.getFullYear();

		    	if(dd<10) {
		    	    dd='0'+dd
		    	} 

		    	if(mm<10) {
		    	    mm='0'+mm
		    	} 

		    	today = yyyy + '-' + mm + '-' + dd;
				
				var date = today;
				
				if (CrossYN()) {
                    var OpenWin = window.open("/ezAttitude/attAdminNewItemTwo.do?date=" + date + "&mode=admin&userid="  + "&companyID=" + pCompanyId, "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attAdminNewItemTwo.do?date=" + date + "&mode=admin&userid=" + "&companyID=" + pCompanyId, "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
			}
			
			/**
			* [근태입력관리] 일근무/반근무 세팅 스케줄러 동작
			*/
			function attScheduler() {
				$.ajax({
					type : "POST",
					async : true,
					url : "/admin/ezAttitude/setDailyWork.do",
					success : function(result) {
						if(result != "success"){
							alert("<spring:message code='ezCommunity.t47'/>");
						} else {
							alert("<spring:message code='ezAttitude.m01' />");
						}
					}
				});
			}
	    </script>
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code = 'ezAttitude.t5' /><span id="mailBoxInfo"></span>
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
					<td style="width: 3%;"><spring:message code='ezAttitude.t9'/></td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t10' /></td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%"><spring:message code='ezAttitude.t134' /></td>
					<td style="width: 12%;">
						<select name="searchAttitudeType" id="searchAttitudeType" style="padding-right:50px;height:24px">
							<option value="ALL" selected><spring:message code='ezAttitude.t124'/></option>
							<c:forEach var = "type" items="${typeList}">
								<c:if test="${type.typeId ne 'A25'}">
									<option value="<c:out value='${type.typeId }'/>">${type.typeName }</option>
								</c:if>
							</c:forEach>							
						</select>
					</td>
				</tr>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t11' /></td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t137' /></td>
					<td style="width: 12%;">
						<input type="text" id="Sdatepicker" style="width:80px;text-align:center"/> ~
						<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
					</td>
					<td style="width: *;" colspan=2>
						<a class="imgbtn"><span onclick="searchAttitudeCheckList('search');"><spring:message code='ezAttitude.t121' /></span></a>
						<a class="imgbtn"><span onclick="searchAttitudeCheckList('refresh');"><spring:message code='ezAttitude.t122' /></span></a>
						<a class="imgbtn"><span onclick="exportExcel();"><spring:message code='ezAttitude.t145' /></span></a>
						<a class="imgbtn"><span onclick="addAtt();"><spring:message code='ezAttitude.t51' /></span></a>
						<a class="imgbtn"><span onclick="attScheduler();"><spring:message code='ezAttitude.kje31' /></span></a>
					</td>
				</tr>
			</tbody>
		</table>
		
	  	<div id="contentlist" style="width:100%; height:610px;margin-top:5px">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="padding-left: 15px; width: 60px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;" colname="NO">NO.</th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="start_date"><spring:message code='ezAttitude.t133' /></th>
						<th style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="type_name"><spring:message code='ezAttitude.t134' /></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	  	</div>
	  		  	
		<div id="tblPageRayer"></div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
	</body>
</html>