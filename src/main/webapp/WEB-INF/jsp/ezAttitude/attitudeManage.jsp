<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>근태관리</title>
		<link rel="stylesheet" href="<spring:message code ='ezAttitude.i1' />" type="text/css"/>
	    <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
	    <link rel="stylesheet" href='/css/Tab.css' type="text/css" />
	    <link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezAttitude/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	    <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    
	    <style>
	    	.portlet_tabpart01{position:relative; margin:15px 0px 0px 0px; clear: both; z-index: 0;}
	    	.portlet_tabpart01_top p .tabover{position: relative; border:1px solid #999; border-bottom:1px solid #eee; background:white; color:#333; z-index: 0;}
			.portlet_tabpart01_top p .tabon {position: relative; border:1px solid #999; border-bottom:1px solid #eee; background:white; color:#333; z-index: 0;}
	    </style>
	    
		<script type="text/javascript" language="javascript">
			var Tab1_SelectID = "modify";
			var companyId = "${companyId}";
	    	//검색조건 저장 변수
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchAttitudeType = "total"; // 검색조건(근태유형)
	    	//검색조건 (근무시간) Hr,Min 묶음으로
	    	var searchStartDate = "${searchStartDate}";
	    	var searchEndDate = "${searchEndDate}";
	    	var initSearchStartDate = "${searchStartDate}";
	    	var initSearchEndDate = "${searchEndDate}";
	    	var pageNum = 1; // 페이지 ==> 초기값 설정
	    	var totalCount = "" // 게시물 총 갯수
	    	var totalPage = ""; // 게시판의 총 페이지갯수
	    	var orderCell = ""; // 정렬 명
	    	var orderOption = ""; // 정렬 형식(ASC, DESC)
	    	var selectedDeptID = "${selectedDeptID}";
	    	var listSize = 19;

	        $(function () {
	            //datepicker
				$("#Sdatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly : true
				});
				
				$("#Edatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly : true
				});

				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', "${searchStartDate}");

				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', "${searchEndDate}");
	        });
	        
			var monthMsg = "1월;2월;3월;4월;5월;6월;7월;8월;9월;10월;11월;12월";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "일;월;화;수;목;금;토";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["ko"] = {
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
	        
	        $(function() {
	            document.getElementById(Tab1_SelectID).setAttribute("class", "tabon");
	            
	            if (document.getElementById("ListDept").length == 0) {
		            alert("부서 정보가 없습니다.");
		        } else {
		    		if (selectedDeptID != null) {
		    			$('#ListDept').val("ALL");
		    		} else {
			            document.getElementById("ListDept").selectedIndex = 0;
		    		}
		        }

	            ChangeTab(document.getElementById(Tab1_SelectID));
			});
	        
	        $(window).on("resize", function(){
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
				
	        	$("#searchPopup").css("left", popupX);
	        });
	        
	        function ChangeTab(obj) {
	        	pSelectTab = obj.getAttribute("id");
	    		
	            getFullList();
	        }
	        
	        function dept_change() {
	    		pageNum = 1;
	    		totalPage = "";
	    		totalCount = "";
	    		
	    		getList();
	    	}
	        
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id){
	                obj.className = "";
	            }
	        }
	        
	        function Tab1_MouseClick(obj) {
	        	//검색 초기화
    			searchStartDate = "";
    			searchEndDate = "";
	    		searchUserName = "";
	    		searchTitle = "";
	    		
				$("#Sdatepicker").datepicker('setDate', initSearchStartDate);
				$("#Edatepicker").datepicker('setDate', initSearchEndDate);
	    		$("#searchUserName").val("");
	    		$("#searchTitle").val("");
	        	
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null){
	                    document.getElementById(Tab1_SelectID).className = "";
	                }
	                
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                if (Tab1_SelectID == "modify") {
	                	$("div#mainmenu ul li:nth-child(3)").show();
	                } else {
	                	$("div#mainmenu ul li:nth-child(3)").hide();
	                }
	                ChangeTab(obj);
	            }
	        }
	        
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	                    }
	                }
	            }
	        }
	        
	        function getFullList() {
	        	var resultHtml = "";
	        	
	        	switch (Tab1_SelectID) {
	    		case "modify":
					resultHtml += "<tr><th style='padding-left: 15px; width: 60px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;' colname='NO'>NO.</th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='displayname'><spring:message code='ezAttitude.t10' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='title'><spring:message code='ezAttitude.t11' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='description'><spring:message code='ezAttitude.t9' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='start_date'><spring:message code='ezAttitude.lhj17' /></th>";
					resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='type_name'><spring:message code='ezAttitude.lhj18' /></th></tr>";
	    			break;
	    		case "absent":
	    			resultHtml += "<tr><th style='padding-left: 15px; width: 60px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;' colname='NO'>NO.</th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='start_date'><spring:message code='ezAttitude.lhj17' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='displayname'><spring:message code='ezAttitude.t10' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='title'><spring:message code='ezAttitude.t11' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='description'><spring:message code='ezAttitude.t9' /></th></tr>";
	    			break;
	    		case "history":
	    			resultHtml += "<tr><th style='padding-left: 15px; width: 60px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;' colname='NO'>NO.</th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='writer_Name'><spring:message code='ezAttitude.t10' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='writer_Title'><spring:message code='ezAttitude.t11' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='writer_Dept_Name'><spring:message code='ezAttitude.t9' /></th>";
	    			resultHtml += "<th style='width:500px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='change_Startdate'>일시</th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='change_Type_Name'><spring:message code='ezAttitude.lhj18' /></th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='appr_User_Name'>수정자</th>";
	    			resultHtml += "<th style='overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor: pointer;' colname='appr_Date'>수정일시</th></tr>";
	    			break;
	    		}
	        	
	        	$("#contentlist .mainlist thead").html(resultHtml);
	        	
	        	pageNum = 1;
	    		totalPage = "";
	    		totalCount = "";
	    		orderCell = "";
	    		orderOption = "";
	    		
	        	getList();
	        }
	        
	        function getList() {
	        	layerHidden();
	        	
	        	switch (Tab1_SelectID) {
	    		case "modify":
	    			getAttitudeCheckList();
	    			break;
	    		case "absent":
	    			getAttitudeAbsentedList();
	    			break;
	    		case "history":
	    			getAttitudeHistoryList();
	    			break;
	    		}
	        }
	        
	        ///////
	        function getAttitudeCheckList(){
	        	searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
    			
	        	//페이지 로딩때 리스트 안가져오고 리스트뿌린다음 가져옴 수정필요.
	        	if ($('#searchAttitudeType').val() == null) {
	        		searchAttitudeType = "total";
	        	} else {
	        		searchAttitudeType = $('#searchAttitudeType').val();
	        	}
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("<spring:message code='ezAttitude.lhj15' />");
		            return;
				}
	    		
	    		$.ajax({
	    			data : "GET",
	    			dataType : "json",
	    			async : false,
	    			url : "/ezAttitude/attitudeCheckList.do",
	    			data : {
	    				companyId : companyId,
	    				deptId : $('#ListDept').val(),
	   					userName : searchUserName,
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
	    				getAttitudeCheckList_after(result.list);
	    				//근태유형 리스트
	    				getAttitudeTypeList(result.typeList, result.typeId);
	    			},
	    			error : function() {
	    				alert('리스트를 가져오는중 오류 발생');
	    			}
	    		});
	    	}
	        
	        function getAttitudeCheckList_after(result){
	    		var resultHtml = "";
	    		$("#contentlist .mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr attitudeId='" + vo.attitudeId + "' typeId='" + vo.typeId + "' userid='" + vo.writerId + "' ondblclick=attDetail(this); style='cursor : pointer;'>";
	    			resultHtml += "<td style='padding-left:15px'>" + i + "</td>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td>";
	    						
	    			if (vo.endDate == null || vo.endDate == "") {
	    				resultHtml += "<td>" + vo.startDate.substring(0,16) + "</td>";
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
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='6' style='text-align:center'><spring:message code='ezAttitude.lhj14' /></td></tr>";	
	    		}
	    		
	    		$("div#miniTitle").html("근태입력목록   &nbsp;[총 " 
	    				+ '<span style="color:#017BEC;font-weight:bold;">' + totalCount + '</span>' + " 개 - " 
	    				+ $("#Sdatepicker").val().split("-")[0] + "년 "
	    				+ $("#Sdatepicker").val().split("-")[1] + "월 "
	    				+ $("#Sdatepicker").val().split("-")[2] + "일"
	    				+ " ~ "
	    				+ $("#Edatepicker").val().split("-")[0] + "년 "
	    				+ $("#Edatepicker").val().split("-")[1] + "월 "
	    				+ $("#Edatepicker").val().split("-")[2] + "일]")
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	        
	        function getAttitudeAbsentedList() {
	    		searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("시작일을 종료일보다 빠르게 지정해주십시오.");
		            return;
				}
	    		
	    		$.ajax({
					type : "post",
					dataType : "json",
					async : false,
					url : "/ezAttitude/getAttitudeAbsentedList.do",
					data : {
						companyId : companyId,
	   					deptId : $('#ListDept').val(),
	   					userName : searchUserName,
	   					title : searchTitle,
	   					startDate : searchStartDate,
	   					endDate : searchEndDate,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption,
	   					duplicated : "duplicated"
					},
					success : function(result) {
						totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
						getAttitudeAbsentedList_after(result.list);
					}
				});
	    	}
	        
	        function getAttitudeAbsentedList_after(result){
	    		var resultHtml = "";
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
    				resultHtml += "<tr userid='" + vo.writerId + "' date='" + vo.startDate + "' ondblclick=attitudeNewItem(this); style='cursor : pointer;'>";
	    			resultHtml += "<td style='padding-left:15px'>" + i + "</td>";
	    			resultHtml += "<td>" + vo.startDate + "</td>";
	    			resultHtml += "<td>" + vo.userName + "</td>";
	    			resultHtml += "<td>" + vo.userTitle + "</td>";
	    			resultHtml += "<td>" + vo.deptName + "</td></tr>";
	    			
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='5' style='text-align:center'><spring:message code='ezAttitude.lhj23' /></td></tr>";	
	    		}
	    		
	    		$("div#miniTitle").html("근태미입력자   &nbsp;[총 " 
				+ '<span style="color:#017BEC;font-weight:bold;">' + totalCount + '</span>' + " 명 - " 
				+ $("#Sdatepicker").val().split("-")[0] + "년 "
				+ $("#Sdatepicker").val().split("-")[1] + "월 "
				+ $("#Sdatepicker").val().split("-")[2] + "일"
				+ " ~ "
				+ $("#Edatepicker").val().split("-")[0] + "년 "
				+ $("#Edatepicker").val().split("-")[1] + "월 "
				+ $("#Edatepicker").val().split("-")[2] + "일]")
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	        
	        function getAttitudeHistoryList(){
	        	searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	        	
	    		var typeId = $('#attitudeType').val();
	    		
	    		if (typeId == "total") {
	    			typeId = "";
	    		}
	    		
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
	    				companyId : companyId,
	    				deptId : $("#ListDept").val(),
	   					userName : searchUserName,
	   					title : searchTitle,
	   					startDate : searchStartDate,
	   					endDate : searchEndDate,
	   					pageNum : pageNum,
	   					listSize : listSize,
	   					orderCell : orderCell,
	   					orderOption : orderOption
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAttitudeHistoryList_after(result.list);
	    			},
	    			error : function() {
	    				alert('리스트를 가져오는중 오류 발생');
	    			}
	    		});
	    	}
	        
	        function getAttitudeHistoryList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr attitudeId='" + vo.attitudeId + "' userid='" + vo.writerId + "';>";
	    			resultHtml += "<td style='padding-left: 15px;'>" + i + "</td>";
		   			resultHtml += "<td>" + vo.writerName + "</td>";
		   			resultHtml += "<td>" + vo.writerTitle + "</td>";
		   			resultHtml += "<td>" + vo.writerDeptName + "</td>";
		   			//일시
		   			if (vo.originStartdate == null || vo.originStartdate == "") {
		   				resultHtml += "<td>미입력";
		   			} else {
		   				if (vo.originEnddate == null || vo.originEnddate == "") {
		   					resultHtml += "<td>" + vo.originStartdate;
		   				} else {
		   					resultHtml += "<td>" + vo.originStartdate + " ~ " + vo.originEnddate;
		   				}
		   			}
		   			if (vo.changeStartdate == null || vo.changeStartdate == "") {
		   				resultHtml += " -> 삭제</td>";
		   			} else {
			   			if (vo.changeEnddate == null || vo.changeEnddate == "") {
			   				resultHtml += " -> " + vo.changeStartdate + "</td>";
			   			} else {
			   				resultHtml += " -> " + vo.changeStartdate + " ~ " + vo.changeEnddate + "</td>";
			   			}
		   			}
		   			//근태유형
		   			if (vo.originTypeName == null || vo.originTypeName == "") {
		   				resultHtml += "<td>미입력 -> " + vo.changeTypeName + "</td>";
	    			} else {
	    				if (vo.changeTypeName == null || vo.changeTypeName == "") {
	    					resultHtml += "<td>" + vo.originTypeName + " -> 삭제</td>";
	    				} else {
		    				resultHtml += "<td>" + vo.originTypeName + " -> " + vo.changeTypeName + "</td>";
	    				}
	    			}
		   			
	    			resultHtml += "<td>" + vo.apprUserName + "</td>"
	    						+ "<td>" + vo.apprDate + "</td></tr>";
	    						
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='7' style='text-align:center'><spring:message code='ezAttitude.lhj14' /></td></tr>";	
	    		}
	    		
	    		$("div#miniTitle").html("관리내역   &nbsp;[총 " 
	    				+ '<span style="color:#017BEC;font-weight:bold;">' + totalCount + '</span>' + " 개 - " 
	    				+ $("#Sdatepicker").val().split("-")[0] + "년 "
	    				+ $("#Sdatepicker").val().split("-")[1] + "월 "
	    				+ $("#Sdatepicker").val().split("-")[2] + "일"
	    				+ " ~ "
	    				+ $("#Edatepicker").val().split("-")[0] + "년 "
	    				+ $("#Edatepicker").val().split("-")[1] + "월 "
	    				+ $("#Edatepicker").val().split("-")[2] + "일]")
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    	}
	        
	        
	        ////////
	        function attDetail(obj) {
				var pAttitudeId = obj.getAttribute("attitudeId"); 
				var pTypeId = obj.getAttribute("typeId")
				;
				if (CrossYN()) {
					var OpenWin = window.open("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", GetOpenWindowfeature(672, 640));
					
					try { OpenWin.focus(); } catch (e) { }
				} else {
					rtnValue = window.showModalDialog("/ezAttitude/attitudeItemDetail.do?attitudeId=" + pAttitudeId + "&typeId=" + pTypeId, "", 
					    "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
				}
		    }
	        
	        function attitudeNewItem(obj) {
				var userid = $(obj).attr("userid");
				var date = $(obj).attr("date");
				
				if (CrossYN()) {
                    var OpenWin = window.open("/ezAttitude/attAdminNewItem.do?date=" + date + "&mode=admin&userid=" + userid, "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attAdminNewItem.do?date=" + date + "&mode=admin&userid=" + userid, "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
	            }
			}
	        
	        function goToPageByNum(pCurPage){
	    		if (pCurPage == 0 || totalPage < pCurPage) {
	    			return;
	    		} else {
		    		pageNum = pCurPage;
	    		}
	    		
	    		getList();
	    	}
	        
	        //검색창 내부 근태유형 리스트 조회
	        function getAttitudeTypeList(typeList, typeId) {
	    		var html = "<option value='total'><spring:message code='ezAttitude.lhj8' /></option>";
	    		
	    		for (var i = 0; i < typeList.length; i ++) {
	    			html += "<option value='" + typeList[i].typeId + "'>" + typeList[i].typeName +  "</option>";
	    		}
	    		
	    		$('#searchAttitudeType').html(html);
	    		
	    		if (typeId != "") {
	    			$('#searchAttitudeType').val(typeId);
	    		}
	    	}
	        
	        function searchPopup() {
	        	//searchPopup 안에 OK넣고 온클릭에  전역변수:Tab1_SelectID로 구분해서 list가져오는거 분기
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#searchPopup").css("left", popupX);
	        	
	        	if (Tab1_SelectID == 'modify') {
		        	$("#searchAttitudeType").closest("tr").css("display", "");
	        	} else {
		        	$("#searchAttitudeType").closest("tr").css("display", "none");
	        	}
	        	
	        	$("#searchPopup").modal();
	        }
	        
	        function layerHidden() {
		        $.modal.close();
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
				
				var userid = "";
				var date = today;
				
				if (CrossYN()) {
                    var OpenWin = window.open("/ezAttitude/attAdminNewItem2.do?date=" + date + "&mode=admin&userid=" + userid, "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attAdminNewItem2.do?date=" + date + "&mode=admin&userid=" + userid, "",
                        "dialogHeight:520px;dialogwidth:800px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(672, 640));
	                
	                if (typeof (rtnValue) != "undefined") {
	                    company_change();
	                }
	            }
			}
	        
	        //th 정렬
	        $(function(){
				$(document).on('click', '#contentlist .mainlist th', function(){
					if ($(this).attr("colname") != "NO") {
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
		    			$("#contentlist .mainlist th").find("img").remove();
		    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
		    			
		    			getList();
					}
				});
			});
	        
			function exportExcel() {
	    		if ($('#contentlist table.mainlist tbody tr').eq(0).attr('id') == 'List_TR_noItems') {
					alert('출력할 내용이 없습니다');
					return;
				}
				
		    	exportExcelframe.location.href="/ezAttitude/adminManageExcel.do?companyId=" + companyId 
		    			+ "&userName=" + searchUserName 
		    			+ "&title=" + searchTitle 
		    			+ "&deptId="+ $('#ListDept').val()
		    			+ "&startDate=" + searchStartDate 
		    			+ "&endDate=" + searchEndDate 
		    			+ "&orderCell=" + orderCell 
		    			+ "&orderOption=" + orderOption 
		    			+ "&attitudeType=" + searchAttitudeType
		    			+ "&duplicated=duplicated&reqType="+Tab1_SelectID;
		    	exportExcelframe.target="_blank";
			}
	        
	        function searchPress(evt) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		            	search();
		            }
		        } else {
		            if (evt.which == 13)
		            	search();
		        }
		    }
	        
	        function search() {
    			searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	    		searchUserName = $("#searchUserName").val();
	    		searchTitle = $("#searchTitle").val();
	    		searchAttitudeType = $("#searchAttitudeType").val();
	    		
	        	goToPageByNum(1);
	        	getList();
	        }
	        
	        function refresh() {
	        	$("#searchUserName").val("");
	    		$("#searchTitle").val("");
	        	$("#Sdatepicker").datepicker('setDate', initSearchStartDate);
				$("#Edatepicker").datepicker('setDate', initSearchEndDate);
	        	$("#searchAttitudeType option:eq(0)").prop("selected", true);
	        	
				search();
	        }
	    </script>
	</head>
	<body class="mainbody">
		<h1><p style="padding-left:5px">근태관리</p></h1>
	    <div class="portlet_tabpart01" style="margin-bottom:16px;">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p><span id="modify" style="width:100px; text-align: center;">근태입력관리</span></p>
	            <p><span id="absent" style="width:100px; text-align: center;">미입력자관리</span></p>
	            <p><span id="history" style="width:100px; text-align: center;">관리내역</span></p>
	        </div>
	    </div>
	    <div>
	    	<div id="mainmenu">
	    		<div id="miniTitle" style="margin-bottom:10px;">근태입력목록</div>
				<ul>
		      		<li><span onclick="searchPopup();">검색</span></li>
		      		<li><span onclick="refresh();">새로고침</span></li>
		      		<c:if test="${manageFlag == 'M' }">
		      			<li><span onclick="addAtt();">근태작성</span></li>
		      		</c:if>
		      		<li>
		      			<span onclick="exportExcel();"><spring:message code='ezAttitude.bbhs7' /></span></a>
		      		</li>
					<li style="background:none; padding-right:2px; cursor:default;" class="off"><img src="/images/i_bar.gif" alt=""></li>
					<li>						
		      			<select name="ListDept" id="ListDept" onchange="dept_change()" style="margin-top:4px; padding-right:40px; width:100%">
		      				<option value="ALL" selected>전체</option>
							<c:forEach var = "dept" items="${deptList}">
								<c:if test="${dept.mine ne 'yes' }">
									<c:if test="${dept.authType == 'M'}">
										<option value="<c:out value='${dept.deptId}'/>" authType="${dept.authType}"><c:out value='${dept.deptName}'/></option>
									</c:if>
								</c:if>
							</c:forEach>
			      		</select>
		      		</li>
		      		<li></li>
		      	</ul>
		  	</div>
	    </div>
	    
	    <div id="contentlist" style="width:100%; height:620px;">
			<table class="mainlist" style="width:100%;">
				<thead></thead>
				<tbody></tbody>
			</table>
	  	</div>
	    
	    <div style="color: #666; padding-top: 10px"></div>
		<div id="tblPageRayer"></div>
	    
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
	    <div id="searchPopup" class="popupwrap2" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:50px;">
			<div class="popupwrap3">
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="width:490px; margin:10px 0px 0px 1px;">
			    	<tr>
						<th class="layerHeader" colspan="2"><img src="/images/kr/left/left_mail.png" style="vertical-align: middle;padding-bottom:1px"/>&nbsp;근태관리 검색</th>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">이름</th>
						<td><input type="text" id="searchUserName" name="searchUserName" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24" onkeypress="searchPress()"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">직위</th>
						<td><input type="text" id="searchTitle" name="searchTitle" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24" onkeypress="searchPress()"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:30px">검색기간</th>
						<td>
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center; float:left"/> 
							~
							<input type="text" id="Edatepicker" style="width:80px;text-align:center;"/>
						</td>
					</tr>
					<tr>
						<th style="width:90px;height:30px">근태유형</th>
						<td><select name="searchAttitudeType" id="searchAttitudeType" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px;"></select></td>
					</tr>
				</table>
				<!-- /내용 -->
				<br />
				<div style="text-align:center;">
					<a class="imgbtn"><span onclick="search();" >검색</span></a>
					<a class="imgbtn" rel="modal:close"><span onclick="layerHidden();">취소</span></a>
			    </div>
			</div>
		</div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>
