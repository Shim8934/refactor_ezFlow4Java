<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title><spring:message code='ezAttitude.t73'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAttitude/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- date Format -->		
		<script type="text/javascript" src="${util.addVer('/js/ezAttitude/moment.min.js')}"></script>
	    <style>
	    	.portlet_tabpart01{position:relative; margin:15px 0px 0px 0px; clear: both; z-index: 0;}
	    	.portlet_tabpart01_top p .tabover{position: relative; border:1px solid #999; border-bottom:1px solid #eee; background:white; color:#333; z-index: 0;}
			.portlet_tabpart01_top p .tabon {position: relative; border:1px solid #999; border-bottom:1px solid #eee; background:white; color:#333; z-index: 0;}
			
			.popupwrapAtt {
			  display: inline-block;
			  vertical-align: middle;
			  position: relative;
			  z-index: 2;
			  max-width: 565px;
			  box-sizing: border-box;
			  width: 90%;
			  background: #fff;
			  padding: 15px 30px;
			  -webkit-border-radius: 8px;
			  -moz-border-radius: 8px;
			  -o-border-radius: 8px;
			  -ms-border-radius: 8px;
			  border-radius: 8px;
			  -webkit-box-shadow: 0 0 10px #000;
			  -moz-box-shadow: 0 0 10px #000;
			  -o-box-shadow: 0 0 10px #000;
			  -ms-box-shadow: 0 0 10px #000;
			  box-shadow: 0 0 10px #000;
			  text-align: left;
			}	
			td, th {
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
			}		
	    </style>
	    
		<script type="text/javascript" language="javascript">
			var Tab1_SelectID = "modify";
			var companyId = "${companyId}";
	    	//검색조건 저장 변수
	    	var searchUserName = ""; // 검색조건 (사원명)
	    	var searchDeptName = ""; // 검색조건 (부서명)
	    	var searchTitle = ""; // 검색조건 (직위)
	    	var searchAttitudeType = "ALL"; // 검색조건(근태유형)
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
	    	var listSize = 20;
	    	var today = "${searchEndDate}"; //오늘날짜 
            var adminFlag = "${adminFlag}";

	        $(function () {
	            //datepicker
	            if (adminFlag == "false" && window.parent.name == "main") {
	                alert("<spring:message code='ezAttitude.nbh01'/>");
                    window.parent.location.reload();
                }
				$("#Sdatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.png",
					buttonImageOnly : true
				});
				
				$("#Edatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.png",
					buttonImageOnly : true
				});

				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', "${searchStartDate}");

				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', "${searchEndDate}");
	        });
	        
			var monthMsg = "<spring:message code='ezAttitude.t139'/>";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezAttitude.t140'/>";
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
	        
	        /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
	        	if (parent.frames["left"]) {
	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	        			$(parent.frames["left"].document.body).css("overflow", "");
	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	        		}
	        	} else if (parent.frames["attitude_menu"]) {
	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	        		}
	        	}
	        	      
	        	if (parent.parent.frames["left"]) {
	        		if (parent.parent.frames["board_menu"]) {  		  
	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	        		}
	        	}
	        }
	        
	        $(function() {
	        	windowResize();
	        	
	            document.getElementById(Tab1_SelectID).setAttribute("class", "tabon");
	            
	            if (document.getElementById("ListDept").length == 0) {
		            alert("<spring:message code='ezAttitude.t53'/>");
		        } else {
// 		    		if (selectedDeptID != null) {
// 		    			$('#ListDept').val("ALL");
// 		    		} else {
// 			            document.getElementById("ListDept").selectedIndex = 0;
// 		    		}
					if ($('#ListDept option').length == 2) { //권한 있는 부서가 한개밖에 없으면 "전체" 옵션을 지운다.
						$('#ListDept option').eq(0).remove();
					}
					
		    		if (selectedDeptID != null) {
		    			$('#ListDept option').each(function() {
		    				if ($(this).val() == selectedDeptID) { //선택한 부서가 옵션에 있을 경우에만 선택되도록
				    			$('#ListDept').val(selectedDeptID);
		    				}
		    			});
		    		} else {
		    			$('#ListDept option').eq(0).prop("selected", true);
		    		}
		        }

	            ChangeTab(document.getElementById(Tab1_SelectID));
			});
	        
	        $(window).on("resize", function(){
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
				
	        	$("#searchPopup").css("left", popupX);
	        	
	            windowResize();
	        });
	        
	        function windowResize() {
	        	var height = document.documentElement.clientHeight - 92 - document.getElementById("mainmenu").clientHeight;
	        	document.getElementById("contentlist").style.height = (height - 118) + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
	        
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
	                	$("div#mainmenu ul li:nth-child(1)").show();
	                } else {
	                	$("div#mainmenu ul li:nth-child(1)").hide();
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
					resultHtml += "<tr><th style='width: 60px; cursor:default;' colname='NO'>NO.</th>";
					resultHtml += "<th style='width: 24%; cursor: pointer;' colname='displayname'><spring:message code='ezAttitude.t10' /></th>";
					resultHtml += "<th style='width: 22%; cursor: pointer;' colname='title'><spring:message code='ezAttitude.t11' /></th>";
					resultHtml += "<th style='width: 24%; cursor: pointer;' colname='description'><spring:message code='ezAttitude.t9' /></th>";
					resultHtml += "<th style='width: 30%; cursor: pointer;' colname='start_date'><spring:message code='ezAttitude.t133' /></th>";
					resultHtml += "<th style='width: 200px; cursor: pointer;' colname='type_name'><spring:message code='ezAttitude.t134' /></th></tr>";
	    			break;
	    		case "absent":
	    			resultHtml += "<tr><th style='width: 60px; cursor:default;' colname='NO'>NO.</th>";
	    			resultHtml += "<th style='width: 25%; cursor: pointer;' colname='start_date'><spring:message code='ezAttitude.t133' /></th>";
	    			resultHtml += "<th style='width: 25%; cursor: pointer;' colname='displayname'><spring:message code='ezAttitude.t10' /></th>";
	    			resultHtml += "<th style='width: 24%; cursor: pointer;' colname='title'><spring:message code='ezAttitude.t11' /></th>";
	    			resultHtml += "<th style='width: 26%; cursor: pointer;' colname='description'><spring:message code='ezAttitude.t9' /></th></tr>";
	    			break;
	    		case "history":
	    			resultHtml += "<tr><th style='width: 60px; cursor:default;' colname='NO'>NO.</th>";
	    			resultHtml += "<th style='width: 13%; cursor: pointer;' colname='writer_Name'><spring:message code='ezAttitude.t10' /></th>";
	    			resultHtml += "<th style='width: 13%; cursor: pointer;' colname='writer_Title'><spring:message code='ezAttitude.t11' /></th>";
	    			resultHtml += "<th style='width: 13%; cursor: pointer;' colname='writer_Dept_Name'><spring:message code='ezAttitude.t9' /></th>";
	    			resultHtml += "<th style='width: 35%; cursor: pointer;' colname='change_Startdate'><spring:message code='ezAttitude.t149'/></th>";
	    			resultHtml += "<th style='width: 13%; cursor: pointer;' colname='change_Type_Name'><spring:message code='ezAttitude.t134' /></th>";
	    			resultHtml += "<th style='width: 13%; cursor: pointer;' colname='appr_User_Name'><spring:message code='ezAttitude.t62'/></th>";
	    			resultHtml += "<th style='width: 180px; cursor: pointer;' colname='appr_Date'><spring:message code='ezAttitude.t63'/></th></tr>";
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
	        	searchAttitudeType = $('#searchAttitudeType').val();
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("<spring:message code='ezAttitude.t131' />");
		            return;
				}
	    		layerHidden();
	    		
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
    				beforeSend : function() {
    					ShowMailProgress();
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAttitudeCheckList_after(result.list);
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			},
	    			complete : function() {
	    				HiddenMailProgress();
	    			}
	    		});
	    	}
	        
	        function getAttitudeCheckList_after(result){
	    		var resultHtml = "";
	    		$("#contentlist .mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr attitudeId='" + vo.attitudeId + "' typeId='" + vo.typeId + "' userid='" + vo.writerId + "' ondblclick=attDetail(this); style='cursor : pointer;'>";
	    			resultHtml += "<td style='width: 60px;'>" + i + "</td>";
	    			resultHtml += "<td style='width: 24%;' >" + vo.userName + "</td>";
	    			resultHtml += "<td style='width: 22%;'>" + vo.userTitle + "</td>";
	    			resultHtml += "<td style='width: 24%;'>" + vo.deptName + "</td>";
	    						
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
	    					resultHtml += "<td style='width: 30%;'>" + vo.startDate.substring(0,11) + " ~ " + vo.endDate.substring(0,11) + "</td>";
	    				} else {
		    				resultHtml += "<td style='width: 30%;'>" + vo.startDate.substring(0,16) + " ~ " + vo.endDate.substring(0,16) + "</td>";
	    				}
	    			}
	    			
	    			resultHtml += "<td style='width: 200px;' >" + vo.typeName + "</td></tr>";
	    			
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='6' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>";	
	    		}
	    		
	    		if(document.title =='Attendance Information Management'){
		    		console.log("month = " +$("#Sdatepicker").val().split("-")[1])
		    		var monthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
		    		             "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		    		var month = monthList[$("#Sdatepicker").val().split("-")[1]-1];
		    		console.log("test" + month);
		    		$("div#miniTitle").html("<img src='/images/ImgIcon/circular_opinion.gif' style='vertical-align:text-bottom' />&nbsp;<spring:message code='ezAttitude.t75'/>   &nbsp;[<spring:message code='ezAttitude.t76'/> " 
					+ '<span class="txt_color" style="font-weight:bold;">' + totalCount + '</span>' + " <spring:message code='ezAttitude.t78'/> - " 
					+ $("#Sdatepicker").val().split("-")[2] +" "
					+ month +", "
					+ $("#Sdatepicker").val().split("-")[0] 								 
					+ " ~ "
					+ $("#Edatepicker").val().split("-")[2] +" "
					+ month +", "
					+ $("#Edatepicker").val().split("-")[0] +"]"				 
					 )
		    		$("#contentlist table.mainlist tbody").append(resultHtml);
		    		makePageSelPageAtti();
		    		}else{
			    		$("div#miniTitle").html("<img src='/images/ImgIcon/circular_opinion.gif' style='vertical-align:text-bottom' />&nbsp;<spring:message code='ezAttitude.t75'/>   &nbsp;[<spring:message code='ezAttitude.t76'/> " 
			    		+ '<span class="txt_color" style="font-weight:bold;">' + totalCount + '</span>' + " <spring:message code='ezAttitude.t78'/> - " 
			    		+ $("#Sdatepicker").val().split("-")[0] + "<spring:message code='ezAttitude.t66'/> "
		 				+ $("#Sdatepicker").val().split("-")[1] + "<spring:message code='ezAttitude.t67'/> "
		   				+ $("#Sdatepicker").val().split("-")[2] + "<spring:message code='ezAttitude.t68'/>"
		   				+ " ~ "
			    		+ $("#Edatepicker").val().split("-")[0] + "<spring:message code='ezAttitude.t66'/> "
	     				+ $("#Edatepicker").val().split("-")[1] + "<spring:message code='ezAttitude.t67'/> "
			    		+ $("#Edatepicker").val().split("-")[2] + "<spring:message code='ezAttitude.t68'/>]")
			    	 	$("#contentlist table.mainlist tbody").append(resultHtml);
			    	    makePageSelPageAtti();	
		    			
		    		}
	    	}
	        
	        function getAttitudeAbsentedList() {
	    		searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("<spring:message code='ezAttitude.t55'/>");
		            return;
				}
	    		layerHidden();
	    		
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
					beforeSend : function() {
						ShowMailProgress();
					},
					success : function(result) {
						totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
						getAttitudeAbsentedList_after(result.list);
					},
					complete : function() {
						HiddenMailProgress();
					}
				});
	    	}
	        
	        function getAttitudeAbsentedList_after(result){
	    		var resultHtml = "";
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
    				resultHtml += "<tr userid='" + vo.writerId + "' date='" + vo.startDate + "' ondblclick=attitudeNewItem(this); style='cursor : pointer;'>";
	    			resultHtml += "<td style='width: 60px;'>" + i + "</td>";
	    			resultHtml += "<td style='width: 25%;'>" + vo.startDate + "</td>";
	    			resultHtml += "<td style='width: 25%;'>" + vo.userName + "</td>";
	    			resultHtml += "<td style='width: 24%;'>" + vo.userTitle + "</td>";
	    			resultHtml += "<td style='width: 26%;'>" + vo.deptName + "</td></tr>";
	    			
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='5' style='text-align:center'><spring:message code='ezAttitude.t138' /></td></tr>";	
	    		}
	    		
	    		if(document.title =='Attendance Information Management'){
	    		console.log("month = " +$("#Sdatepicker").val().split("-")[1])
	    		var monthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
	    		             "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	    		var month = monthList[$("#Sdatepicker").val().split("-")[1]-1];
	    		console.log("test" + month);
	    		$("div#miniTitle").html("<img src='/images/ImgIcon/circular_opinion.gif' style='vertical-align:text-bottom' />&nbsp;<spring:message code='ezAttitude.t75'/>   &nbsp;[<spring:message code='ezAttitude.t76'/> " 
				+ '<span class="txt_color" style="font-weight:bold;">' + totalCount + '</span>' + " <spring:message code='ezAttitude.t77'/> - " 
				+ $("#Sdatepicker").val().split("-")[2] +" "
				+ month +", "
				+ $("#Sdatepicker").val().split("-")[0] 								 
				+ " ~ "
				+ $("#Edatepicker").val().split("-")[2] +" "
				+ month +", "
				+ $("#Edatepicker").val().split("-")[0] +"]"				 
				 )
	    		$("#contentlist table.mainlist tbody").append(resultHtml);
	    		makePageSelPageAtti();
	    		}else{
		    		$("div#miniTitle").html("<img src='/images/ImgIcon/circular_opinion.gif' style='vertical-align:text-bottom' />&nbsp;<spring:message code='ezAttitude.t75'/>   &nbsp;[<spring:message code='ezAttitude.t76'/> " 
		    		+ '<span class="txt_color" style="font-weight:bold;">' + totalCount + '</span>' + " <spring:message code='ezAttitude.t77'/> - " 
		    		+ $("#Sdatepicker").val().split("-")[0] + "<spring:message code='ezAttitude.t66'/> "
	 				+ $("#Sdatepicker").val().split("-")[1] + "<spring:message code='ezAttitude.t67'/> "
	   				+ $("#Sdatepicker").val().split("-")[2] + "<spring:message code='ezAttitude.t68'/>"
	   				+ " ~ "
		    		+ $("#Edatepicker").val().split("-")[0] + "<spring:message code='ezAttitude.t66'/> "
     				+ $("#Edatepicker").val().split("-")[1] + "<spring:message code='ezAttitude.t67'/> "
		    		+ $("#Edatepicker").val().split("-")[2] + "<spring:message code='ezAttitude.t68'/>]")
		    	 	$("#contentlist table.mainlist tbody").append(resultHtml);
		    	    makePageSelPageAtti();	
	    			
	    		}
	    		
	    	}
	        
	        function getAttitudeHistoryList(){
	        	searchStartDate = $("#Sdatepicker").val();
    			searchEndDate = $("#Edatepicker").val();
	        	
	    		var typeId = $('#attitudeType').val();
	    		
	    		if (typeId == "total") {
	    			typeId = "";
	    		}
	    		
	    		if (searchStartDate > searchEndDate) {
					alert("<spring:message code='ezAttitude.t131' />");
		            return;
				}
	    		layerHidden();
	    		
	    		$.ajax({
	    			type : "POST",
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
    				beforeSend : function() {
    					ShowMailProgress();
    				},
	    			success : function(result){
	    				totalCount = result.totalCount;
	    				totalPage = parseInt(totalCount / listSize) + (totalCount % listSize != 0 ? 1 : 0);
	    				getAttitudeHistoryList_after(result.list);
	    			},
	    			error : function() {
	    				alert("<spring:message code='ezAttitude.t59'/>");
	    			},
	    			complete : function() {
	    				HiddenMailProgress();
	    			}
	    		});
	    	}
	        
	        function getAttitudeHistoryList_after(result){
	    		var resultHtml = "";
	    		
	    		$("#contentlist table.mainlist tbody").html("");
	    		
	    		var i = ((pageNum - 1) * listSize) + 1;
	    		
	    		result.forEach(function(vo, index) {
	    			resultHtml += "<tr attitudeId='" + vo.attitudeId + "' userid='" + vo.writerId + "';>";
	    			resultHtml += "<td style='width: 60px;'>" + i + "</td>";
		   			resultHtml += "<td style='width: 13%;'>" + vo.writerName + "</td>";
		   			resultHtml += "<td style='width: 13%;'>" + vo.writerTitle + "</td>";
		   			resultHtml += "<td style='width: 13%;'>" + vo.writerDeptName + "</td>";
		   			//일시
		   			if (vo.originStartdate == null || vo.originStartdate == "") {
		   				resultHtml += "<td style='width: 35%;'><spring:message code='ezAttitude.t61'/>";
		   			} else {
		   				if (vo.originEnddate == null || vo.originEnddate == "") {
		   					resultHtml += "<td style='width:35%;'>" + vo.originStartdate;
		   				} else {                                
		   					resultHtml += "<td style='width:35%;'>" + vo.originStartdate + " ~ " + vo.originEnddate;
		   				}
		   			}
		   			if (vo.changeStartdate == null || vo.changeStartdate == "") {
		   				resultHtml += " -> <spring:message code='ezAttitude.t164'/></td>";
		   			} else {
			   			if (vo.changeEnddate == null || vo.changeEnddate == "") {
			   				resultHtml += " -> " + vo.changeStartdate + "</td>";
			   			} else {
			   				resultHtml += " -> " + vo.changeStartdate + " ~ " + vo.changeEnddate + "</td>";
			   			}
		   			}
		   			//근태유형
		   			if (vo.originTypeName == null || vo.originTypeName == "") {
		   				resultHtml += "<td style='width: 13%;'><spring:message code='ezAttitude.t61'/> -> " + vo.changeTypeName + "</td>";
	    			} else {
	    				if (vo.changeTypeName == null || vo.changeTypeName == "") {
	    					resultHtml += "<td style='width: 13%;'>" + vo.originTypeName + " -> <spring:message code='ezAttitude.t164'/></td>";
	    				} else {
		    				resultHtml += "<td style='width: 13%;'>" + vo.originTypeName + " -> " + vo.changeTypeName + "</td>";
	    				}
	    			}
		   			
	    			resultHtml += "<td style='width: 13%;'>" + vo.apprUserName + "</td>"
	    						+ "<td style='width: 180px;'>" + vo.apprDate + "</td></tr>";
	    						
	    			i++;
	    		});
	    		
	    		if (resultHtml == "") {
	    			resultHtml = "<tr id='List_TR_noItems'><td colspan='8' style='text-align:center'><spring:message code='ezAttitude.t130' /></td></tr>";	
	    		}
	    		
	    		if(document.title =='Attendance Information Management'){
		    		console.log("month = " +$("#Sdatepicker").val().split("-")[1])
		    		var monthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
		    		             "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		    		var month = monthList[$("#Sdatepicker").val().split("-")[1]-1];
		    		console.log("test" + month);
		    		$("div#miniTitle").html("<img src='/images/ImgIcon/circular_opinion.gif' style='vertical-align:text-bottom' />&nbsp;<spring:message code='ezAttitude.t75'/>   &nbsp;[<spring:message code='ezAttitude.t76'/> " 
					+ '<span class="txt_color" style="font-weight:bold;">' + totalCount + '</span>' + " <spring:message code='ezAttitude.t78'/> - " 
					+ $("#Sdatepicker").val().split("-")[2] +" "
					+ month +", "
					+ $("#Sdatepicker").val().split("-")[0] 								 
					+ " ~ "
					+ $("#Edatepicker").val().split("-")[2] +" "
					+ month +", "
					+ $("#Edatepicker").val().split("-")[0] +"]"				 
					 )
		    		$("#contentlist table.mainlist tbody").append(resultHtml);
		    		makePageSelPageAtti();
		    		}else{
			    		$("div#miniTitle").html("<img src='/images/ImgIcon/circular_opinion.gif' style='vertical-align:text-bottom' />&nbsp;<spring:message code='ezAttitude.t75'/>   &nbsp;[<spring:message code='ezAttitude.t76'/> " 
			    		+ '<span class="txt_color" style="font-weight:bold;">' + totalCount + '</span>' + " <spring:message code='ezAttitude.t78'/> - " 
			    		+ $("#Sdatepicker").val().split("-")[0] + "<spring:message code='ezAttitude.t66'/> "
		 				+ $("#Sdatepicker").val().split("-")[1] + "<spring:message code='ezAttitude.t67'/> "
		   				+ $("#Sdatepicker").val().split("-")[2] + "<spring:message code='ezAttitude.t68'/>"
		   				+ " ~ "
			    		+ $("#Edatepicker").val().split("-")[0] + "<spring:message code='ezAttitude.t66'/> "
	     				+ $("#Edatepicker").val().split("-")[1] + "<spring:message code='ezAttitude.t67'/> "
			    		+ $("#Edatepicker").val().split("-")[2] + "<spring:message code='ezAttitude.t68'/>]")
			    	 	$("#contentlist table.mainlist tbody").append(resultHtml);
			    	    makePageSelPageAtti();	
		    			
		    		}
	    	}
	        
	        
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
	       /* function getAttitudeTypeList(typeList, typeId) {
	    		var html = "<option value='total'><spring:message code='ezAttitude.t124' /></option>";
	    		
	    		for (var i = 0; i < typeList.length; i ++) {
	    			html += "<option value='" + typeList[i].typeId + "'>" + typeList[i].typeName +  "</option>";
	    		}
	    		
	    		$('#searchAttitudeType').html(html);
	    		
	    		if (typeId != "") {
	    			$('#searchAttitudeType').val(typeId);
	    		}
	    	}*/
	        
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
                    var OpenWin = window.open("/ezAttitude/attAdminNewItemTwo.do?date=" + date + "&mode=admin&userid=" + userid, "attitudeNewItem", GetOpenWindowfeature(672, 640));
                    
                    try { OpenWin.focus(); } catch (e) { }
	            } else {
                	rtnValue = window.showModalDialog("/ezAttitude/attAdminNewItemTwo.do?date=" + date + "&mode=admin&userid=" + userid, "",
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
					alert("<spring:message code='ezAttitude.t56'/>");
					return;
				}
	    		
	    		switch (Tab1_SelectID) {
	    		case "modify":
	    			url = "/ezAttitude/excelAttitudeListExport.do";
	    			break;
	    		case "absent":
	    			url = "/ezAttitude/excelAbsentedListExport.do";
	    			break;
	    		case "history":
	    			url = "/ezAttitude/excelHistoryListExport.do";
	    			break;
	    		}
				
		    	exportExcelframe.location.href=url + "?companyId=" + encodeURIComponent(companyId) 
		    			+ "&userName=" + encodeURIComponent(searchUserName) 
		    			+ "&title=" + encodeURIComponent(searchTitle) 
		    			+ "&deptId="+ encodeURIComponent($('#ListDept').val())
		    			+ "&startDate=" + encodeURIComponent(searchStartDate) 
		    			+ "&endDate=" + encodeURIComponent(searchEndDate) 
		    			+ "&orderCell=" + encodeURIComponent(orderCell) 
		    			+ "&orderOption=" + encodeURIComponent(orderOption)
		    			+ "&attitudeType=" + encodeURIComponent(searchAttitudeType)
		    			+ "&duplicated=duplicated";
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
	    		
	    		if (Tab1_SelectID == "absent") {
	    			//오늘 이후 날짜가 포함되어 있으면 검색이 안되게끔.
	    			if (searchEndDate > today) {
	    				alert("<spring:message code='ezAttitude.t226'/>");
	    				return;
	    			}
	    		}
	    		
	        	goToPageByNum(1);
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
		<h1><p style="padding-left:5px"><spring:message code='ezAttitude.t73'/></p></h1>
	    <div class="portlet_tabnew01" style="margin-bottom:16px;">
	        <div class="portlet_tabnew01_top" id="tab1">
	            <p><span id="modify" <c:if test="${useLang == '2'}"></c:if><c:if test="${useLang != '2'}">style="width:100px;</c:if> text-align: center;"><spring:message code='ezAttitude.t5'/></span></p>
	            <p><span id="absent" <c:if test="${useLang == '2'}"></c:if><c:if test="${useLang != '2'}">style="width:100px;</c:if> text-align: center;"><spring:message code='ezAttitude.t6'/></span></p>
	            <p><span id="history" <c:if test="${useLang == '2'}"></c:if><c:if test="${useLang != '2'}">style="width:100px;</c:if> text-align: center;"><spring:message code='ezAttitude.t57'/></span></p>
	        </div>
	    </div>
	    <div>
	    	<div id="mainmenu">
				<ul>
					<li class="important"><span onclick="addAtt();"><spring:message code='ezAttitude.t51'/></span></li>
		      		<li><span onclick="exportExcel();"><spring:message code='ezAttitude.t145' /></span></li>
		      		<li onclick="searchPopup();"><span class="icon16 icon16_search switchIcon"></span><span class="iconTexts"><spring:message code='ezAttitude.t121'/></span></li>
					<li onclick="refresh();"><span class="icon16 icon16_refresh switchIcon"></span><span class="iconTexts"><spring:message code='ezAttitude.t122'/></span></li>
					<li>						
		      			<select name="ListDept" id="ListDept" onchange="dept_change()" style="padding-right:40px; width:100%; height:28px;">
		      				<option value="ALL" selected><spring:message code='ezAttitude.t124'/></option>
							<c:forEach var = "dept" items="${deptList}">
								<c:if test="${dept.authType == 'M'}">
										<option value="<c:out value='${dept.deptId}'/>" authType="${dept.authType}"><c:out value='${dept.deptName}'/></option>
								</c:if>
							</c:forEach>
			      		</select>
		      		</li>
		      	</ul>
		      	<div id="miniTitle" style="margin-bottom:10px;padding-left:2px;margin-top:15px"><spring:message code='ezAttitude.t74'/></div>
		  	</div>
	    </div>
	    <div id="contentlist" style="width:100%; overflow:auto; height:642px;">
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
		
		<!-- 검색 팝업 -->
	    <div id="searchPopup" class="popupwrap1" style="display:none;margin-bottom:50px;">
	  		<div class="popupJQLayer">
				<div class="title"><spring:message code='ezAttitude.t79'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="layerHidden()"></span></a></li>
		            </ul>
		        </div>
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="width:510px; margin:10px 0px 0px 1px;">
					<tr>
			  			<th style="width:90px;height:26px"><spring:message code='ezAttitude.t10'/></th>
						<td><input type="text" id="searchUserName" name="searchUserName" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24" onkeypress="searchPress()"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:26px"><spring:message code='ezAttitude.t11'/></th>
						<td><input type="text" id="searchTitle" name="searchTitle" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="24" onkeypress="searchPress()"></td>
					</tr>
					<tr>
			  			<th style="width:90px;height:26px"><spring:message code='ezAttitude.t137'/></th>
						<td>
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center; float:left;margin-left:3px"/> 
							~
							<input type="text" id="Edatepicker" style="width:80px;text-align:center;"/>
						</td>
					</tr>
					<tr>
						<th style="width:90px;height:26px"><spring:message code='ezAttitude.t134'/></th>
						<td>
							<select name="searchAttitudeType" id="searchAttitudeType" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px">
								<option value="ALL" selected><spring:message code='ezAttitude.t124'/></option>
								<c:forEach var = "type" items="${typeList}">
									<c:if test="${type.typeId ne 'A25'}">
										<option value="<c:out value='${type.typeId }'/>">${type.typeName }</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
				</table>
				<!-- /내용 -->
				<div class="btnpositionLayer" style="text-align:center;">
					<a class="imgbtn"><span onclick="search();" ><spring:message code='ezAttitude.t121'/></span></a>
			    </div>
			</div>
		</div>
		<iframe name="exportExcelframe" src="about:blank" style="width:0px; height:0px; display:none;"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>
