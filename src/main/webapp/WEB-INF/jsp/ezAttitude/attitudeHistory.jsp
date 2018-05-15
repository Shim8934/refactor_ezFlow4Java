<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>관리내역</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
	    <link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	    <!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <style>
	    	#contentlist table.mainlist td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		cursor : pointer;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR {background-color: rgb(233, 241, 255);}
			#searchTable {
				border-top: 1px solid #e8e8e8;
				border-left: 1px solid #e8e8e8;
				border-right: 1px solid #e8e8e8;
				background-color: #fcfcfc;
			}
			#searchTable td {padding: 8px 5px;}
	    </style>
	    
	    <script type="text/javascript">
	    	var pCompanyId = "${adminCompany}";
	    	var pDeptId = ""; //현재 선택된 부서의 아이디
	    	//검색조건 저장 변수
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchAttitudeType = "total"; // 검색조건(근태유형)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartDate = "${searchStartDate}";
	    	var searchEndDate = "${searchEndDate}";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var selectedDept = "${selectedDept}";
	    	var listSize = 19;
	    	
	    	$(function(){
	    		$("#Sdatepicker").val("${searchStartDate}");
	    		$("#Edatepicker").val("${searchEndDate}");
	    		
	    		//부서리스트
		        if (document.getElementById("ListDept").length == 0) {
		            alert("부서 정보가 없습니다.");
		        } else {
		    		if (selectedDept != null) {
		    			$('#ListDept').val(selectedDept);
		    		} else {
			            document.getElementById("ListDept").selectedIndex = 0;
		    		}
		    		
		    		dept_change();
		        }
	    		
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '#contentlist table.mainlist th', function(){
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
			        buttonImage: "/images/ImgIcon/calendar-month.gif",
			        buttonImageOnly: true
			    });
			    $("#Edatepicker").datepicker({
			        changeMonth: true,
			        changeYear: true,
			        autoSize: true,
			        showOn: "both",
			        buttonImage: "/images/ImgIcon/calendar-month.gif",
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
			
// 	    	function company_change(){
// 	    		$('#receiverlist').empty();
// 	    		pCompanyId = $("select[name=ListCompany]").val();
// // 	    		getAttitudeCheckList();
// 	    	}
	    	
	    	function dept_change(){
	    		$('#receiverlist').empty();
// 	    		pDeptId = $("select[name=ListDept]").val();
	    		getAttitudeHistoryList();
	    	}
	    	
	    	function getAttitudeHistoryList(){
	    		var typeId = $('#attitudeType').val();
	    		
	    		if (typeId == "total") {
	    			typeId = "";
	    		}
	    		
    			searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("<spring:message code='ezAttitude.lhj15' />");
		            return;
				}
	    		
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			async : false,
	    			url : "/ezAttitude/attitudeHistoryList.do",
	    			data : {
	    				companyId : pCompanyId,
	    				deptId : $("#ListDept").val(),
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
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAttitudeHistoryList_after(result.list);
	    				//근태유형 리스트
// 	    				getAttitudeTypeList(result.typeList, result.typeId);
	    				$('#searchAttitudeType').val(typeId);
	    			},
	    			error : function() {
	    				alert('리스트를 가져오는중 오류 발생');
	    			}
	    		});
	    	}
	    	
// 	    	//검색 > 근태유형selectBox
// 	    	function getAttitudeTypeList(typeList, typeId) {
// 	    		var html = "<option value='total'><spring:message code='ezAttitude.lhj8' /></option>";
	    		
// 	    		for (var i = 0; i < typeList.length; i ++) {
// 	    			html += "<option value='" + typeList[i].typeId + "'>" + typeList[i].typeName +  "</option>";
// 	    		}
	    		
// 	    		$('#searchAttitudeType').html(html);
	    		
// 	    		if (typeId != "") {
// 	    			$('#searchAttitudeType').val(typeId);
// 	    		}
// 	    	}
	    	
	    	function getAttitudeHistoryList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		for (var i = 0; i < result.length; i ++) {
	    			resultHtml += "<tr attitudeId='" + result[i].attitudeId + "' userid='" + result[i].writerId + "';>"
	    			   			+ "<td>" + result[i].writerName + "</td>"
	    			   			+ "<td>" + result[i].writerTitle + "</td>"
	    			   			+ "<td>" + result[i].writerDeptName + "</td>";
	    						
	    			if (result[i].originStartdate == null || result[i].originStartdate == "") {
	    				resultHtml += "<td> 미입력  ->  " + result[i].changeStartdate;
	    				if (result[i].changeEnddate == null || result[i].changeEnddate == "") {
	    					resultHtml += "</td>";
	    				} else {
	    					resultHtml += "  ~  " + result[i].changeEnddate + "</td>";
	    				}
	    			} else {
	    				resultHtml += "<td>" + result[i].originStartdate;
	    				if (result[i].originEnddate == null || result[i].originEnddate == "") {
	    					resultHtml += "  ->  " + result[i].changeStartdate + "</td>";
	    				} else {
	    					resultHtml += "  ~  " + result[i].originEnddate + "  ->  " + result[i].changeStartdate + "  ~  " + result[i].changeEnddate + "</td>";
	    				}
	    			}
	    			
	    			if (result[i].originTypeName == null || result[i].originTypeName == "") {
	    				resultHtml += "<td> 미입력  ->  " + result[i].changeTypeName + "</td>";
	    			} else {
	    				resultHtml += "<td>" + result[i].originTypeName + "  ->  " + result[i].changeTypeName + "</td>";
	    			}
	    			resultHtml += "<td>" + result[i].apprUserName + "</td>"
	    						+ "<td>" + result[i].ApprDate + "</td></tr>";
	    		}
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='6' style='text-align:center'><spring:message code='ezAttitude.lhj14' /></td></tr>";	
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
	    		
	    		getAttitudeHistoryList();
	    	}
	    	
			function searchAttitudeHistoryList(searchType){
				if (!checkPattern()) {
					alert("<spring:message code='ezAttitude.lhj16' />")
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
	    			$("select[id='searchAttitudeType']").val('total');
	    			
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
	    		getAttitudeHistoryList();
	    	}
			
			function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	searchAttitudeHistoryList('search');
		            }
		        } else {
		            if (evt.which == 13)
		            	searchAttitudeHistoryList('search');
		        }
		    }
			
			function checkPattern() {
				var datePattern =  /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
				/* var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/; */
				
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
			
// 			function attDetail(t) {
// 				var pAttitudeId = t.getAttribute("attitudeId"); 
// 				var pTypeId = t.getAttribute("typeId");
// 				if (CrossYN()) {
// 					var OpenWin = window.open("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", GetOpenWindowfeature(672, 640));
					
// 					try { OpenWin.focus(); } catch (e) { }
// 				} else {
// 					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
// 					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
// 				}
// 		    }
	    </script>
	</head>
	<body class="mainbody">
	    <h1>관리내역<span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none;"><span style="border: none;"><b>부서선택</b></span></li>
				<li>
	      			<select name="ListDept" id="ListDept" onchange="dept_change()" style="margin-top:4px; padding-right:40px; width:100%">
						<c:forEach var = "dept" items="${deptList}">
							<c:if test="${dept.mine ne 'yes' }">
								<option value="<c:out value='${dept.deptId}'/>"><c:out value='${dept.deptName}'/></option>
							</c:if>
						</c:forEach>
		      		</select>
	      		</li>
	      	</ul>
	  	</div> 	
	  	<table id="searchTable" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t10' /></td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t11' /></td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.lhj22' /></td>
					<td style="width: 20%;">
						<input type="text" id="Sdatepicker" style="width:80px;text-align:center"/> ~
						<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
					</td>
				</tr>
				<tr>
					<td style="width: 3%"><spring:message code='ezAttitude.lhj18' /></td>
					<td style="width: *;"  colspan=3>
						<select name="searchAttitudeType" id="searchAttitudeType" style="padding-right:50px;"></select>
					</td>
					<td colspan=2>
						<a class="imgbtn"><span onclick="searchAttitudeCheckList('search');"><spring:message code='ezAttitude.lhj5' /></span></a>&nbsp;
						<a class="imgbtn"><span onclick="searchAttitudeCheckList('refresh');"><spring:message code='ezAttitude.lhj6' /></span></a>&nbsp;
					</td>
				</tr>
			</tbody>
		</table>
		
	  	<div id="contentlist" style="width:100%; height:620px;">
			<table class="mainlist" style="width:100%;">
				<thead>
					<tr>
						<th style="width:10%; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="displayname"><spring:message code='ezAttitude.t10' /></th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="title"><spring:message code='ezAttitude.t11' /></th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="description"><spring:message code='ezAttitude.t9' /></th>
						<th style="width:30%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="start_date">일시</th>
						<th style="width:15%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="type_name"><spring:message code='ezAttitude.lhj18' /></th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="type_name">수정자</th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="type_name">수정일시</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	  	</div>
	  	
	  	<div style="color: #666; padding-top: 10px"></div>
		<div id="tblPageRayer"></div>
	</body>
</html>