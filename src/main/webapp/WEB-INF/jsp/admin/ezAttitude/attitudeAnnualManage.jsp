<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezAttitude.t5' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css"/>
	    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>
	    <style>
	    	#contentlist table.mainlist tr:not(.tr_noItems) td {
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    	}
	    	tr.hover:hover {background:#eee; color:#fff;}
			.selectTR {background-color: #f1f8ff;}
			#searchTable {
				border: 1px solid #e8e8e8;
				background-color: #f8f8fa;
			}
			#searchTable td {padding: 8px 5px;}
			.mainlist a.imgbtn {
				background: none;
			}
			.mainlist a.imgbtn:hover {
				border: 1px solid #8e8e8e;
				background: white;
			}
			.mainlist a.link {
				text-decoration: underline;
			}
			.mainlist a.link:hover {
				font-weight: bold;
			}
	    </style>
	    
	    <script type="text/javascript">
	    	var pCompanyId = ""; //현재 선택된 회사의 아이디
	    	//검색조건 저장 변수
	    	//var searchYear = ""; //검색조건 (년도)
	    	var searchUserName = ""; //검색조건 (사원명)
	    	var searchDeptName = ""; //검색조건 (부서명)
	    	var searchTitle = ""; //검색조건 (직위)
	    	var searchAttitudeType = "ALL"; //검색조건(근태유형)
	    	var pageNum = 1; //페이지 ==> 초기값 설정
	    	var totalCount = "" //게시물 총 갯수
	    	var totalPage = ""; //게시판의 총 페이지갯수
	    	var orderCell = ""; //정렬 명
	    	var orderOption = ""; //정렬 형식(ASC, DESC)
	    	var adminCompany = "${adminCompany}";
	    	var listSize = 15;
	    	//년도 셀렉트 박스
			var isfirst = true;
            var maxyear = "";
	    	
	    	$(function(){	
	    		windowResize();
	    		
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
		    		
		    		//makeoptionyear();
		    		
		    		company_change();
		        }
	    		
	    		//헤더 클릭 시 정렬
	    		$(document).on('click', '#contentlist table.mainlist th', function(){
	    			if ($(this).attr("colname") != "") {
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
		    			
		    			getAnnualList();
	    			}
	    		});
	    		
	    		//총 연차 수 링크 클릭
	    		$(document).on('click', '.mainlist .additionalAnnualCnt', function(){
	    			var userId = $(this).closest("tr").attr("userid");
	    			var userName = $(this).closest("tr").children("td:eq(1)").text();
	    			var userTitle = $(this).closest("tr").children("td:eq(2)").text();
	    			var userDeptName = $(this).closest("tr").children("td:eq(3)").text();
	    			var additionalAnnualCnt = $(this).closest("tr").children("td:eq(6)").text();
	    			modifyPrsnAnnualPop(userId , userName, userTitle, userDeptName, additionalAnnualCnt);
	    		})
	    		//입사일 클릭
	    		$(document).on('click', '.mainlist .joinDate', function(){
	    			var userId = $(this).closest("tr").attr("userid");
	    			var mode = "modify";
	    			var date = $(this).closest("tr").children("td:eq(4)").text();
	    			setJoinDatePop(userId , mode , date);
	    		})
	    	});
			    
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    //리사이즈
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 216 - document.getElementById("mainmenu").clientHeight;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		    
		    //년도 생성
	        /* function makeoptionyear() {
	            var date = new Date()
	            var year = date.getFullYear();
		        var tempyear = "";
                var selyear = "";
                
	            if (isfirst) {
	            	searchYear = year;
	                selyear = year;
	                tempyear = year + 4;
	                maxyear = year + 4;
	                isfirst = false;
	            }
	            else {
	                selyear = parseInt(document.getElementById("searchYear").value);
                    tempyear = selyear + 4;
	            }
	            
	            if (selyear <= maxyear) {
	                document.getElementById("searchYear").innerHTML = "";
	                for (var i = 0; i < 10; i++) {
	                	if (tempyear > maxyear) {
	                		tempyear--;
	                		continue;
	                	}
	                
	                    var option = document.createElement("OPTION");
	                    option.value = tempyear;
	                    option.innerHTML = tempyear;
	
	                    if (selyear == tempyear)
	                        option.selected = true;
	
	                    document.getElementById("searchYear").appendChild(option);
	                    tempyear--;
	                }
	                tempyear = selyear + 4;
	            }
	        } */
			
		    //회사변경시
	    	function company_change() {
	    		pCompanyId = document.getElementById("ListCompany").value;
	    		getAnnualList();
	    	}
	    	
		    //리스트 가져오기
	    	function getAnnualList() {
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			url : "/admin/ezAttitude/attitudeAnnualList.do",
	    			data : {
	    				companyId : pCompanyId,
	   					userName : searchUserName,
	   					deptName : searchDeptName,
	   					title : searchTitle,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAnnualList_after(result.list);
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			}
	    		});
	    	}
	    	
	    	function getAnnualList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr userid='" + vo.userId + "'>";
	    			resultHtml += "<td style='padding-left: 15px;'>" + i + "</td>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.userDeptName + "</td>";
	    			
	    			if(vo.joinDate == "0") {
		    			resultHtml += "<td><a class='imgbtn'><span onclick=\"setJoinDatePop('" + vo.userId + "', 'new', '0')\"><spring:message code='ezAttitude.t288'/></span></a></td>";
	    			} else {
		    			resultHtml += "<td><a class='link joinDate'>" + vo.joinDate + "</td>";
	    			}
	    			
	    			/* resultHtml += "<td><a class='link useAnnualCnt'>";
	    			if (Number(vo.useAnnualCnt.split(".")[1]) > 0) {
	    				resultHtml += vo.useAnnualCnt;
	    			} else {
		    			resultHtml += vo.useAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</a></td>"; */
	    			
	    			resultHtml += "<td>";
	    			if (Number(vo.basicAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.basicAnnualCnt;
	    			} else {
		    			resultHtml += vo.basicAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</td>";
	    			resultHtml += "<td><a class='link additionalAnnualCnt'>";
	    			if (Number(vo.additionalAnnualCnt.split(".")[1]) > 0) {
		    			resultHtml += vo.additionalAnnualCnt;
	    			} else {
		    			resultHtml += vo.additionalAnnualCnt.split(".")[0];
	    			}
	    			resultHtml += "</a></td>";
	    			resultHtml += "<td><a class='imgbtn'><span onclick=\"annualHistoryPop('" + vo.userId + "')\"><spring:message code='ezAttitude.t241' /></span></a></td>";
	    			
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems' class='tr_noItems'><td colspan='7' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>";	
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
	    		
	    		getAnnualList();
	    	}
	    	
	    	//엔터로 검색되도록
			function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	searchAnnualList('search');
		            }
		        } else {
		            if (evt.which == 13)
		            	searchAnnualList('search');
		        }
		    }
			
	    	//검색시 조건
			function searchAnnualList(searchType){
	    		if (searchType == "search") { //검색
	    			//searchYear = document.getElementById("searchYear").value;
	    			searchUserName = $("#searchUserName").val();
	    			searchDeptName = $("#searchDeptName").val();
	    			searchTitle = $("#searchTitle").val();
	    		} else { //새로고침
	    			//searchYear = maxyear - 2;
	    			$("#searchUserName").val("");
	    			$("#searchDeptName").val("");
	    			$("#searchTitle").val("");
	    			
	    			searchUserName = "";
	    			searchDeptName = "";
	    			searchTitle = "";
	    		}
	    		
	    		$("#contentlist table.mainlist th").find("img").remove();
	    		orderOption = "";
	    		orderCell = "";
	    		
	    		pageNum = 1;
    			getAnnualList();
	    	}
			
			//엑셀 다운로드
			function exportExcel() {
				if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert("<spring:message code='ezAttitude.t56'/>");
					return;
				}
				
		    	exportExcelframe.location.href="/admin/ezAttitude/excelAnnualListExport.do?companyId=" + encodeURIComponent(pCompanyId) + "&userName=" + encodeURIComponent(searchUserName) + "&deptName=" + encodeURIComponent(searchDeptName) + "&title=" + encodeURIComponent(searchTitle) + "&orderCell=" + encodeURIComponent(orderCell) + "&orderOption=" + encodeURIComponent(orderOption);
		    	exportExcelframe.target="_blank";
			}
			
			/* //엑셀로 등록 팝업
	    	function annualExcelUploadPop(userId, year) {
	        	var url = "/admin/ezAttitude/annualExcelUploadPop.do?companyId=" + encodeURIComponent($("#ListCompany").val());
				window.open(url, "annualExcelUploadPop", GetOpenWindowfeature(500, 230));
	        } */
			
			//전체 연차 변경 팝업
	    	function modifyAllAnnualPop() {
	        	var url = "/admin/ezAttitude/modifyAllAnnualPop.do?companyId=" + encodeURIComponent($("#ListCompany").val());
				window.open(url, "modifyAllAnnualPop", GetOpenWindowfeature(500, 175));
	        }
	    	
			//사용연차 수 팝업
			/* function useAnnualHistory (obj) {
				var userId = $(obj).closest("tr").attr("userid");
				var url = "/admin/ezAttitude/useAnnualHistoryPop.do?userId=" + userId + "&year=" + searchYear + "&companyId=" + pCompanyId;
				window.open(url, "useAnnualHistoryPop", GetOpenWindowfeature(665, 535));
			} */
	    	
			//로우의 총 연차수 링크 클릭 시
	    	function modifyPrsnAnnualPop(userId , userName, userTitle, userDeptName, additionalAnnualCnt) {
	        	var url = "/admin/ezAttitude/modifyPrsnAnnualPop.do?userName=" + encodeURIComponent(userName) + "&userId=" + encodeURIComponent(userId) + "&userTitle=" + encodeURIComponent(userTitle) +  "&userDeptName=" + encodeURIComponent(userDeptName) +  "&additionalAnnualCnt=" + encodeURIComponent(additionalAnnualCnt) + "&companyId=" + encodeURIComponent($("#ListCompany").val());
				window.open(url, "modifyPrsnAnnualPop", GetOpenWindowfeature(500, 274));
	        }
	    	
			//수정내역팝업
	    	function annualHistoryPop(userId) {
	        	var url = "/admin/ezAttitude/annualHistoryPop.do?userId=" + userId + "&companyId=" + encodeURIComponent($("#ListCompany").val());
				window.open(url, "annualHistoryPop", GetOpenWindowfeature(750, 510));
	        }
			
			//입사일 입력 팝업
	    	function setJoinDatePop(userId, mode, date) {
	        	var url = "/admin/ezAttitude/setJoinDatePop.do?userId=" + userId + "&mode=" + mode + "&date=" + date + "&companyId=" + encodeURIComponent($("#ListCompany").val());
	        	GetOpenWindow2(url, "setJoinDatePop", 210, 370);
	        }
			
	    </script>
	</head>
	<body class="mainbody">
	    <h1>
	    	<spring:message code='ezAttitude.t237' />
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
					<td style="width: 3%;"><spring:message code='ezAttitude.t10' /></td>
					<td style="width: 12%;"><input type="text" id="searchUserName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t9'/></td>
					<td style="width: 12%;"><input type="text" id="searchDeptName" style="width: 90%;" onkeypress="searchPress()"></td>
					<td style="width: 3%;"></td>
					<td style="width: 12%;">
				</tr>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t11' /></td>
					<td style="width: 12%;"><input type="text" id="searchTitle" style="width: 90%;" maxlength="50" onkeypress="searchPress()"></td>
					</td>
					<td style="width: *;" colspan=2>
						<a class="imgbtn"><span onclick="searchAnnualList('search');"><spring:message code='ezAttitude.t121' /></span></a>
						<a class="imgbtn"><span onclick="searchAnnualList('refresh');"><spring:message code='ezAttitude.t122' /></span></a>
						<a class="imgbtn"><span onclick="exportExcel();"><spring:message code='ezAttitude.t145' /></span></a>
						<%-- <a class="imgbtn"><span onclick="annualExcelUploadPop();"><spring:message code='ezAttitude.t235' /></span></a> --%>
						<a class="imgbtn"><span onclick="modifyAllAnnualPop();"><spring:message code='ezAttitude.t236' /></span></a>
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
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="joinDate"><spring:message code='ezAttitude.t289' /></th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="basicAnnualCnt"><spring:message code='ezAttitude.t290' /></th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;" colname="additionalAnnualCnt"><spring:message code='ezAttitude.t291' /></th>
						<th style="width:10%;overflow: hidden; white-space: nowrap; text-overflow: ellipsis; padding-left: 8px;" colname=""><spring:message code='ezAttitude.t241' /></th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
	  	</div>
	  		  	
		<div id="tblPageRayer"></div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
</html>