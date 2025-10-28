<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
		<title><spring:message code='ezAttitude.t165' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/previewmail.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<!-- modal -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<style>
		#contentlist table.mainlist td {
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
		<%-- 2018-07-19 홍승비 - 관리자 > 근태관리 헤더 겹치는 부분 수정, datePicker 스타일 추가 --%>
		#headerList th {
			overflow:hidden;
			text-overflow:ellipsis;
		}
		#sDateSpan, #eDateSpan {
			display:inline-block;
			vertical-align:middle;
		}
		#sDateSpan img {
			margin-top:3px;
		}
		</style>
		<script type="text/javascript">
		var pCompanyId = ""; //현재 선택된 회사의 아이디
		var totalAtt 		  = "";
		var currentPage		  = ${currentPage};
		var totalPages 		  = "";
	    var blockSize 		  = 10;
	    var orderCell = ""; // 정렬 명
    	var orderOption = ""; // 정렬 형식(ASC, DESC)
		var g_userLang 		  = "${userLang}";
		var g_timezone 		  = "${userTimeSet}";
		var offsetMin 		  = "${offsetMin}";
		var type 			  = "all";
		var m_strColorSelect = "#f1f8ff";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		var adminFlag = "${adminFlag}";
		var checkAdmin = "${checkAdmin}";
		var authFlag = "${authFlag}";
		var usepostDate = false;
		var searchAppr = ""; //#appr_search
		var searchWriter = ""; //#writer_search
		var searchStartDate = "<c:out value='${startDate}'/>";
		var searchEndDate = "<c:out value='${endDate}'/>";
		var pageInfo = "modList";
		var adminCompany = "${adminCompany}";
		
		$(function(){
			windowResize();
			
			$(document).on('click', '#AttList th', function(){
				if (!($(this).find("input[type=checkbox]").length) && ($(this).attr("colname") != "NO") && $(this).attr("colname") != "ORIGIN_TIME") { // checkbox는 sort에서 제외
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
	    			$("#AttList th").find("img").remove();
	    			$(this).append("<img src='" + src + "' align='absmiddle'/>");
	    			
	    			get_att_list();
				}
			});
			
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

			if (checkAdmin == 'true') {
				authFlag = 'M';
			}
			if (authFlag == 'M') {
				
			} else {
				if (adminFlag == "true"){
					$("#appr").hide();
					$("#ret").hide();
				}
			}
		})
		
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
	        var NowDate = utcDate2(offsetMin);
	        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Sdatepicker").datepicker('setDate', NowDate);
	        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Edatepicker").datepicker('setDate', NowDate);
	        
			if (checkAdmin == 'true') {
				$("#Sdatepicker").val("${startDate}");
	    		$("#Edatepicker").val("${endDate}");
	    		usepostDate = true;
			}
			
			// ie인 경우, 달력 이미지 위치 수정
			if (navigator.userAgent.toLowerCase().indexOf("chrome") == -1) {
				$('#sDateSpan').children('img.ui-datepicker-trigger').first().attr("style", "margin-top:2px;");
				$('#eDateSpan').children('img.ui-datepicker-trigger').first().attr("style", "margin-bottom:2px;");
    	    }
	    });
	    
	    $(function () {
	        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
	            closeText: "<spring:message code='main.t3' />",
	            prevText: "<spring:message code='main.t0604' />",
	            nextText: "<spring:message code='main.t0605' />",
	            currentText: "<spring:message code='main.t0606' />",
	            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
	                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
	                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
	                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
	            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
	                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
	                       "<spring:message code='main.t0627' />"],
	            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
	            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
	            weekHeader: "Wk",
	            dateFormat: "yy-mm-dd",
	            firstDay: 0,
	            isRTL: false,
	            duration: 200,
	            showAnim: "show",
	            showMonthAfterYear: true
	        };
	        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	    });

		window.onload = function() {
			var obj = $("#search").offset();
			
			if (checkAdmin != 'true') {
				$("#Sdatepicker").datepicker('disable');
		        $("#Edatepicker").datepicker('disable');	
			}
		}
		
		$(window).on("resize", function(){
			var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			
        	$("#popup").css("left", popupX);
        	$("#popup2").css("left", popupX);
        	
        	windowResize();
        });
		
	    function windowResize() {
        	var height = document.documentElement.clientHeight - 215 - document.getElementById("mainmenu").clientHeight;
        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
        		height = height - 30;
        	}
        	document.getElementById("contentlist").style.height = height + "px";
        	document.getElementById("contentlist").style.overflow = "auto";
        }
		
		function company_change(){
    		pCompanyId = $("select[name=ListCompany]").val();
    		get_att_list();
    	}
		
		function makePageSelPage(){
	        var strtext;
	        var PagingHTML = "";
	        document.getElementById("tblPageRayer").innerHTML = "";

	        strtext = "<div class='pagenavi'>";
	        PagingHTML += strtext;
	        var pageNum = currentPage;
	        
	        if (totalPages > 1 && pageNum != 1) {
	            strtext = "<span class='btnimg first' onClick= 'return goToPageByNum(1)'></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg first disabled'></span>";
	            PagingHTML += strtext;
	        }
	        
	        if (totalPages > blockSize) {
	            if (pageNum > blockSize) {
	                strtext = "<span class='btnimg prev' onClick= 'return selbeforeBlock()'></span>";
	                PagingHTML += strtext;
	            }
	            else {
	                strtext = "<span class='btnimg prev disabled'></span>";
	                PagingHTML += strtext;
	            }
	        }
	        else {
	            strtext = "<span class='btnimg prev disabled'></span>";
	            PagingHTML += strtext;
	        }
	        
	        var MaxNum;
	        var i;
	        var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;

	        if (totalPages >= (startNum + parseInt(blockSize))) {
	            MaxNum = (startNum + parseInt(blockSize)) - 1;
	        }
	        else {
	            MaxNum = totalPages;
	        }

	        for (i = startNum; i <= MaxNum; i++) {
	            if (i == pageNum) {
	                strtext = "<span class='on'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	            else {
					strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	        }
	        
	        if (totalPages > blockSize) {
	        	if (totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
	        	    strtext = "";
	        	    strtext = strtext + "<span class='btnimg next' onClick='return selafterBlock()'></span>";
	                PagingHTML += strtext;
	        	}
	        	else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	        	}
	        }
	        else {
	            strtext = "";
	            strtext = strtext + "<span class='btnimg next disabled'></span>";
	            PagingHTML += strtext;
	        }
	        
	        if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
	            strtext = "<span class='btnimg last' onClick='return goToPageByNum(" + totalPages + ")'></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg last disabled'></span>";
	            PagingHTML += strtext;
	        }
	        
	        PagingHTML += "</div>";
	        td_Create1(PagingHTML);
	    }
	
	    function td_Create1(strtext) {
	        document.getElementById("tblPageRayer").innerHTML = strtext;
	    }
	    
	    function search_popup() {
	    	try {
	    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].layerHidden()'></div>").appendTo(parent.frames["left"].document.body);	
	    	} catch(e) {
	    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"attitude_main\"].layerHidden()'></div>").appendTo(parent.frames["attitude_menu"].document.body);
	    	}
        	
        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
        	
        	$("#popup2").css("left", popupX);
        	
			$("#popup2").modal();
	    }
	    
	    function popup_close() {
	    	$.modal.close();
	    }
	    
	    function att_search(r) {
			if (r == "refresh") {
				$("#writer_search").val("");
				if (checkAdmin != 'true' && adminFlag == true) {
										
				} else if (checkAdmin == 'true') {
	    			$("#writerDept_search").val("");
				}
    			$("#appr_search").val("");
    			if (usepostDate) {
    				date_reset();
    			}
//     			$(Radio1).prop("checked", true);
    			type_set();
			}
			
			//정렬 초기화
			orderCell = "";
	    	orderOption = "";
	    	$("#AttList th").find("img").remove();
	    	
 	    	searchAppr = $("#appr_search").val();
 	    	searchWriter = $('#writer_search').val();
 	    	if (checkAdmin != 'true') {
 	    		$("#appr_search").val("");
	 	    	if (adminFlag == 'true'){
		 	    	$("#writer_search").val("");
	 	    	}
	 	    	if (usepostDate) {
	 	    		searchStartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	 	    		searchEndDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            if (searchStartDate > searchEndDate) {
		                alert("<spring:message code='ezAttitude.t131'/>");
		                return;
		            } else {
		            	date_reset();
		            }
		        } else {
		        	searchStartDate = "";
		        	searchEndDate = "";
		        }
 	    	} else {
 	    		searchStartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
 	    		searchEndDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	            if (searchStartDate > searchEndDate) {
	                alert("<spring:message code='ezAttitude.t131'/>");
	                return;
	            }
 	    	}
 	    	
 	    	
			popup_close();
			goToPageByNum("1");
	    }
	    
	    function att_refresh() {
	    	get_att_list(currentPage);
	    }
	    
	    function get_att_list(pageNum) {
	    	$("#HeaderAllCheckBox").prop("checked",false);
	    	
	    	var obj = new Object();
	    	
		    obj.apprUserName = searchAppr;
		    if (adminFlag == 'true') {
		    	if (checkAdmin == 'true') {
		    		obj.writerDeptName = writerDept_search.value;
		    	} else {
		    		obj.writerDeptId = writerDept_search.value;
			    	obj.writerDeptName = "";	
		    	}
		    	obj.writerName = searchWriter;
		    }
		    obj.companyId = $('#ListCompany').val();
		    obj.startDate = searchStartDate;
		    obj.endDate = searchEndDate;
			obj.pageNum = pageNum;
			obj.totalPages = totalPages;
			obj.totalAtt = totalAtt;
			obj.type = type;
			obj.orderCell = orderCell;
			obj.orderOption = orderOption;
			obj.adminFlag = adminFlag;
			obj.checkAdmin = checkAdmin;
			
		    $.ajax({
				type : 'get',
			    url : '/ezAttitude/getAttModAppList.do',
			    data : obj,
			    dataType : "json",
			    beforeSend : function() {
   					ShowAttProgress();
				},
			    error: function(xhr, status, error){
			    	ajaxRunning = false;
			    },
			    success : function(json){
			    	getAttList_after(json);
			    },
				complete : function() {
					HiddenAttProgress();
				}
		    });
	    }
	    
	    function get_excelAtt_list() {
	    	if (usepostDate) {
	            if (searchStartDate > searchEndDate) {
	                alert("<spring:message code='ezAttitude.t131'/>");
	                HiddenAttProgress();
	                return;
	            }
	        }
	    	var obj = new Object();
			
		    obj.apprUserName = searchAppr;
		    if (adminFlag == 'true') {
		    	if (checkAdmin == 'true') {
		    		obj.writerDeptName = writerDept_search.value;
		    	} else {
		    		obj.writerDeptId = writerDept_search.value;
			    	obj.writerDeptName = "";	
		    	}
		    	obj.writerName = $('#writer_search').val();
		    }
		    obj.companyId = $('#ListCompany').val();
		    obj.startDate = searchStartDate;
		    obj.endDate = searchEndDate;
			obj.totalPages = totalPages;
			obj.totalAtt = totalAtt;
			obj.type = type;
			obj.orderCell = orderCell;
			obj.orderOption = orderOption;
			obj.excelReq = "true";
			obj.adminFlag = adminFlag;
			obj.checkAdmin = checkAdmin;
		    
		    $.ajax({
				type : 'get',
			    url : '/ezAttitude/getAttModAppList.do',
			    data : obj,
			    dataType : "json",
			    beforeSend : function() {
   					ShowAttProgress();
				},
			    error: function(xhr, status, error){
			    	ajaxRunning = false;
			    },
			    success : function(json){
			    	
			    	// 2025-02-20 조수빈 - 다운로드할 내용 없을 경우 동작이 없어 분기 추가
			    	if (json.list.length < 1) {
			    		alert('<spring:message code="ezAttitude.t56"/>');
			    		return;
			    	}
			    	
			    	getAttList_after(json, true);
			    },
				complete : function() {
					HiddenAttProgress();
				}
		    });
	    }
	    
	    function getAttList_after(data, excel) {
	    	var attList = data.list;
	    	var infoStr = "";
	    	listContentArry = new Array();
	    	
	    	if (excel == true) {
	    		$('#ExcelAttList tbody').children( 'tr:not(:first)' ).remove();
	    	} else {
	    		if (adminFlag == "true"){
	    			authFlag = data.authFlag;
	    			
	    			if(checkAdmin == 'true') {
		    			authFlag = 'M'; 
		    		}
	    			
		    		if (authFlag == 'M') {
						$("#appr").show();
						$("#ret").show();
					} else {
						$("#appr").hide();
						$("#ret").hide();
					}
	    		}	
	    		
	    		totalAtt = data.totalAtt;
		    	totalPages = data.totalPages;
		    	makePageSelPage();
		    	
		    	infoStr += '&nbsp;&nbsp;<span class="txt_color">' + data.totalAtt;
		    	
		    	if (data.startDate != "" && data.endDate != "") {
		    		infoStr += '</span>';
		    		if (checkAdmin != 'true') {
		    			infoStr += ' / ' + data.startDate.substring(0,4) + '<spring:message code="ezAttitude.t66"/>' + 
				    	data.startDate.substring(5,7) + '<spring:message code="ezAttitude.t67"/>' + 
				    	data.startDate.substring(8,10) + '<spring:message code="ezAttitude.t68"/>~';
				    	infoStr += data.endDate.substring(0,4) + '<spring:message code="ezAttitude.t66"/>' + 
				    	data.endDate.substring(5,7) + '<spring:message code="ezAttitude.t67"/>' + 
				    	data.endDate.substring(8,10) + '<spring:message code="ezAttitude.t68"/>]</span>';	
		    		} else {
		    			infoStr += '</span>'
		    		}
		    	} else {
		    		infoStr += '</span> <spring:message code="ezAttitude.t78"/>]';
		    	}
		    	
		    	$("#mailBoxInfo").html(infoStr);
		    	$('#AttList tbody').children( 'tr:not(:first)' ).remove();
	    	}
	    	
	    	if (excel != true) {
		    	if (attList.length == 0) {
		    		if (adminFlag != "true") {
		    			$('#AttList tbody').append('<tr><td colspan="8" align="center"  bgcolor="#FFFFFF"><spring:message code="ezAttitude.t96"/></td></tr>');
		    		} else {
		    			$('#AttList tbody').append('<tr><td colspan="11" align="center"  bgcolor="#FFFFFF"><spring:message code="ezAttitude.t96"/></td></tr>');	
		    		}
		    	}
	    	}
	    	
	    	for (var i = 0 ; i < attList.length; i ++) {
	    		var htmlStr = "";
	    		htmlStr += '<tr id="attList_' + (i+1) + '" class="white" onclick="event_listclick(this, event)" ondblclick="mod_detail(this)" draggable="true" style="cursor:pointer;">';
	    		if (excel == true) {
	    		} else {
	    			htmlStr += '<td style="padding:0; text-align: center;"><div class="custom_checkbox"><input type="checkbox" class="checkAtt"' 
	    	    	htmlStr += 'id="attCheck_' + attList[i].attitudeId + '_' + attList[i].applCnt +'"';
	    	    	htmlStr += 'value="' + attList[i].attitudeId + '_' + attList[i].applCnt +'"';
	    	    	htmlStr += 'status="' + attList[i].apprStatus + '"';
	    	    	htmlStr += ' onclick="event_listCheckboxclick(this)"/></div></td>';	
	    		}
	    		if (excel == true) {
	    			htmlStr += '<td>' + (parseInt(i) + 1 + (parseInt(1)-1) * 15) + '</td>';
	    			htmlStr += '<td>' + attList[i].originDate.substring(0,10) + '</td>';
	    		} else {
	    			if (checkAdmin == 'true') {
		    			htmlStr += '<td>' + (parseInt(i) + 1 + (parseInt(currentPage)-1) * 15) + '</td>';
	    			} else {
	    				htmlStr += '<td>' + (parseInt(i) + 1 + (parseInt(currentPage)-1) * 19) + '</td>';
	    			}
	    			htmlStr += '<td>' + attList[i].originDate.substring(0,10) + '</td>';	
	    		}
    			
    			if (adminFlag == 'true') {
    				htmlStr += '<td>' + attList[i].writerName + '</td>';
    				htmlStr += '<td>' + attList[i].writerDeptName + '</td>';
    			}
    			
    			htmlStr += '<td>' + attList[i].originDate.substring(11,16) + '</td>';
    			htmlStr += '<td>' + attList[i].changeDate.substring(11,16) + '</td>';
    			
    			if (attList[i].apprStatus == 0) {
    				htmlStr += '<td id="attStauts"><spring:message code="ezAttitude.t209"/></td>';	
    			}
    			if (attList[i].apprStatus == 1) {
    				htmlStr += '<td id="attStauts"><spring:message code="ezAttitude.t210"/></td>';	
    			}
    			if (attList[i].apprStatus == 2) {
    				htmlStr += '<td id="attStauts"><spring:message code="ezAttitude.t211"/></td>';	
    			}
    			if (attList[i].apprUserName == null) {
    				htmlStr += '<td>' + "" + '</td>';
    			} else {
    				htmlStr += '<td>' + attList[i].apprUserName + '</td>';	
    			}
    			if (attList[i].applDate == null) {
    				htmlStr += '<td></td>';
    			} else {
    				htmlStr += '<td>' + attList[i].applDate.substring(0,16) + '</td>';
    			}
    			
    			if  (excel != true) {
    				htmlStr += '<td><a class="imgbtn" id="mailInBtn" onclick="getHistory(this)"><span><spring:message code="ezAttitude.t97"/></span></a></td>';	
    			}
    			
    			htmlStr += '</tr>';
    			if  (excel == true) {
    				$('#ExcelAttList tbody').append(htmlStr);
    				btnexportexcel_onclick();
    			} else {
    				$('#AttList tbody').append(htmlStr);
    			}
	    	}
	    }
	    
	    function date_reset() {
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
	        var NowDate = utcDate2(offsetMin);
	        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        
	        if (checkAdmin == 'true') {
	        	$("#Sdatepicker").val("${startDate}");
	    		$("#Edatepicker").val("${endDate}");
	        } else {
	        	$(usepostdate).prop('checked', false);
		        usepostDate = false;
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $("#Edatepicker").datepicker('setDate', NowDate);
	            $("#Sdatepicker").datepicker('disable');
	            $("#Edatepicker").datepicker('disable');
	        }
	    }
	    
	    function search_keypress(evt)
		{	
	        var curevent = (typeof event == 'undefined' ? evt : event)

			if (curevent.keyCode == "13") {
	        	att_search();
	        }
		}
	    
	    function HiddenAttProgress() {
	        document.getElementById("attPanel").style.display = "none";
	        document.getElementById("AttProgress").style.display = "none";
	    }
	    
	    function ShowAttProgress() {
	    	var CurrenWidth = window.innerWidth;
        	
		    document.getElementById("attPanel").style.display = "";
		    document.getElementById("AttProgress").style.top = "330px";
		    document.getElementById("AttProgress").style.left = (CurrenWidth / 2) - 100 + "px";
		    document.getElementById("AttProgress").style.display = "";
	    }
	    
	    function goToPageByNum(Value){
	    	currentPage = Value;
	        makePageSelPage();
	        get_att_list(currentPage);
	    }
	    
	    function selbeforeBlock(){
	        var pageNum = parseInt(currentPage);
	        pageNum = ((parseInt(pageNum / blockSize) - 1) * blockSize) + 1;
	        goToPageByNum(pageNum);
	    }
	    
	    function selbeforeBlock_one(){
	        var pageNum = parseInt(currentPage);

	        if(parseInt(pageNum - 1) > 0)
	            goToPageByNum(parseInt(pageNum - 1));
	        else
	            return;
	    }
	    
	    function selafterBlock(){
	        var pageNum = parseInt(currentPage);

	        pageNum = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
	        goToPageByNum(pageNum);
	    }
	    
	    function selafterBlock_one(){
	        var pageNum = parseInt(currentPage);
	        if(parseInt(pageNum + 1) <= totalPages)
	            goToPageByNum(parseInt(pageNum + 1));
	        else
	            return;
	    }
	    
	    function DateSearch_Click() {
	        if(usepostDate){
	            usepostDate = false;
	            $("#Sdatepicker").datepicker('disable');
	            $("#Edatepicker").datepicker('disable');
	        }
	        else {
	            usepostDate = true;
	            $("#Sdatepicker").datepicker('enable');
	            $("#Edatepicker").datepicker('enable');
	        }
	    }
	    
	    function btnexportexcel_onclick() {
            document.getElementById("saveExcelData").value = $("#ExcelAttList")[0].outerHTML;
            document.getElementById("formAgent").target = "saveExcel";
            document.getElementById("formAgent").submit();
        }
	    
	    function type_change(){
	    	type = $("input:radio[name=searchCheck]:checked").val();
	    	goToPageByNum(1);
	    }
	    
	    function type_set(){
	    	type = $("input:radio[name=searchCheck]:checked").val();
	    }
	    
	    function dept_change() {
	    	type = $("input:radio[name=searchCheck]:checked").val();
	    	att_search('refresh');
	    }
	    
	    var PressShiftKey = false;
	    var PressCtrlKey = false;
	    
	    function event_listOnkeyUp(event) {
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            if (!event) event = window.event;
	        }

	        switch (event.keyCode) {
	            case 16: PressShiftKey = false; break;
	            case 17: PressCtrlKey = false; break;
	            case 46:
	                if (event.shiftKey) {
	                    PressShiftKey = false;
	                }
	                else {
	                }
	                break;
	        }

	    }
	    
	    function event_listOnkeyDown(event) {
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            if (!event) event = window.event;
	        }
	        switch (event.keyCode) {
	            case 16: PressShiftKey = true; break;
	            case 17: PressCtrlKey = true; break;
	        }
	    }
	    
	    var listContentArry = new Array();
	    var listSubContentArry = new Array();
	    var listEventCheckbox = false;
	    var listSubEventCheckbox = false;

	    function event_listclick(obj, event) {
	    	if (obj.tagName == "TD") {
	            obj = obj.parentElement;
	        }

	        if (!listEventCheckbox) {
	            if (document.getElementById("HeaderAllCheckBox").checked) {
	                var TemplistArray = new Array();
	                if (obj.getElementsByTagName("td").item(0).querySelector('input').checked) {
	                    for (var i = 0; i < listContentArry.length; i++) {
	                        if (obj.getAttribute("id") == listContentArry[i]) {
	                            obj.childNodes.item(0).querySelector('input').checked = false;
	                            obj.style.backgroundColor = m_strColorDefault;
	                        }
	                        else {
	                            TemplistArray[TemplistArray.length] = listContentArry[i];
	                        }
	                    }
	                    listContentArry = TemplistArray;
	                }
	                else {
	                    obj.childNodes.item(0).querySelector('input').checked = true;
	                    obj.style.backgroundColor = m_strColorSelect;
	                    listContentArry[listContentArry.length] = obj.getAttribute("id");
	                }
	            }
	            else {
	                if (!event.shiftKey && !event.ctrlKey && listContentArry.length > 0) {
	                	
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        _RowObject = document.getElementById(listContentArry[Cnt]);
							_RowObject.style.backgroundColor = m_strColorDefault;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                    }
	                    listContentArry = new Array();
	                }
	                if (event.shiftKey) {
	                    var SelectedPreObj = null;
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        _RowObject = document.getElementById(listContentArry[Cnt]);
	                        if (Cnt == 0){
	                            SelectedPreObj = _RowObject;	
	                        }
	                        _RowObject.style.backgroundColor = m_strColorDefault;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                    }
	                    listContentArry = new Array();
	                    _RowObject = obj;
	                    var PrelistContent;
	                    if (SelectedPreObj == null)
	                        PrelistContent = _RowObject.getAttribute("id");
	                    else
	                        PrelistContent = SelectedPreObj.getAttribute("id");
	                    var CurlistContent = obj.getAttribute("id");
	                    var PrePoint = parseInt(PrelistContent.replace("attList_", ""));
	                    var CurPoint = parseInt(CurlistContent.replace("attList_", ""));

	                    if (PrePoint < CurPoint) {
	                        for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
	                            _RowObject = document.getElementById("attList_" + Cnt);
	                            _RowObject.style.backgroundColor = m_strColorSelect;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                            listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
	                        }

	                    }
	                    else if (PrePoint > CurPoint) {
	                        for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                            _RowObject = document.getElementById("attList_" + Cnt);
	                            _RowObject.style.backgroundColor = m_strColorSelect;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                            listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
	                        }
	                    }
	                    else if (PrePoint == CurPoint) {
	                        if (_RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked) {
	                            _RowObject.style.backgroundColor = m_strColorDefault;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                            listContentArry = ArrayDelete(listContentArry, _RowObject.id);
	                        }
	                        else {
	                            _RowObject.style.backgroundColor = m_strColorSelect;
	                            _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                            listContentArry[listContentArry.length] = GetAttribute(_RowObject, "id");
	                        }
	                    }
	                    else
	                        return;
	                }
	                else {
	                	
	                    _RowObject = obj;
	                    
	                    if (_RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked) {
	                    	
	                        _RowObject.style.backgroundColor = m_strColorDefault;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	                        listContentArry = ArrayDelete(listContentArry, _RowObject.id);
	                    }
	                    else {
	                    	
	                        _RowObject.style.backgroundColor = m_strColorSelect;
	                        _RowObject.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	                        listContentArry[listContentArry.length] = _RowObject.getAttribute("id");
	                    }
	                }
	            }
	        }
	        else
	            listEventCheckbox = false;
	    }
	    
	    function attList_del() {
	    	var attList = $(".checkAtt:checked");
	    	var idList = "";
	    	
	    	if (attList.length == 0) {
	    		alert("<spring:message code='ezAttitude.t98'/>");
	    		return;
	    	}
	    	
	    	for (var i = 0; i < attList.length; i++) {
	    		idList += attList[i].getAttribute("id").split("_")[1] + ","
	    	}
	    	
	    	var obj = new Object();
	    	
		    obj.idList = idList.slice(0,-1);
			
		    if (confirm("<spring:message code='ezAttitude.t183'/>")) {
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/delAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	ajaxRunning = false;
				    	alert("<spring:message code='ezAttitude.t175'/>")
				    },
				    success : function(json){
				    	get_att_list(currentPage);
				    	if (json == "error") {
				    		alert("<spring:message code='ezAttitude.t99'/>");			    			
				    	} else {
				    	
				    	}
				    },
					complete : function() {
						HiddenAttProgress();
					}
			    });
		    } else {
		    	HiddenAttProgress();
		    }
	    }
	    
		//승인
	    function modApprove() {
			if (authFlag != "M") {
				alert("<spring:message code='ezAttitude.t100'/>");
				return;
			}
	    	var attList = $(".checkAtt:checked");
	    	var idList = "";
	    	
	    	for (var i = 0; i < attList.length; i++) {
	    		if (attList[i].getAttribute("status") == "0") {
	    			idList += attList[i].getAttribute("id").split("_")[1] 
	    			+ "_" + attList[i].getAttribute("id").split("_")[2] + ",";	
	    		}
	    	}
	    	
	    	if (attList.length == 0) {
				alert("<spring:message code='ezAttitude.t101'/>");
				return;
			}
	    	
	    	var obj = new Object();
	    	
		    obj.idList = idList.slice(0,-1);
		    obj.changeStatus = "appr";
		    obj.companyID = pCompanyId;
			
		    if (confirm("<spring:message code='ezAttitude.t84'/>")) {
	 	    	if (idList == "") {
	    			alert("<spring:message code='ezAttitude.t99'/>");
		    		get_att_list(currentPage);
		    		HiddenAttProgress();
		    		return;
		    	}
	 	    	
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/changeAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	ajaxRunning = false;
				    	alert("<spring:message code='ezAttitude.t175'/>");
				    },
				    success : function(json){
				    	get_att_list(currentPage);
						alert("<spring:message code='ezAttitude.t214'/>");
				    },
					complete : function() {
						HiddenAttProgress();
					}
			    });
		    }
	    }
	    
	  	//반려
	    function modReturn() {
	    	if (authFlag != "M") {
				alert("<spring:message code='ezAttitude.t100'/>");
				return;
			}
	  		
	    	var attList = $(".checkAtt:checked");
	    	var idList = "";
	    	
	    	for (var i = 0; i < attList.length; i++) {
	    		if (attList[i].getAttribute("status") == "0") {
	    			idList += attList[i].getAttribute("id").split("_")[1] + ",";	
	    		}
	    	}
	    	if (attList.length == 0) {
				alert("<spring:message code='ezAttitude.t102'/>");
				return;
			}
	    	
	    	var obj = new Object();
	    	
		    obj.idList = idList.slice(0,-1);
		    obj.changeStatus = "ret";
		    obj.companyID = pCompanyId;
			
		    if (confirm("<spring:message code='ezAttitude.t87'/>")) {
		    	if (idList == "") {
	    			alert("<spring:message code='ezAttitude.t99'/>");
		    		get_att_list(currentPage);
		    		HiddenAttProgress();
		    		return;
		    	}
		    	
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/changeAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	ajaxRunning = false;
				    	alert("<spring:message code='ezAttitude.t175'/>");
				    },
				    success : function(json){
				    	get_att_list(currentPage);
						alert("<spring:message code='ezAttitude.t215'/>");
				    },
					complete : function() {
						HiddenAttProgress();
					}
			    });
		    }
	    }
	    
	    function ArrayDelete(TargetArray, DeleteNodeStr) {
	        var TempArray = new Array();
	        for (var i = 0; i < TargetArray.length; i++) {
	            if (TargetArray[i] != DeleteNodeStr)
	                TempArray[TempArray.length] = TargetArray[i];
	        }
	        TargetArray = TempArray;
	        return TargetArray;
	    }
	    
	    function event_HeaderCheckBoxClick(obj) {
	    	// tr 노드들 (메일 리스트의 전체 행)
			var attNodes = $('#AttList tbody').children( 'tr:not(:first)' );
	    	
	    	// tr 노드 (하나의 행)
	    	var attNode;
	    	// tr 노드 개수
	    	var nodeCount = attNodes.length;
	        if (obj.checked) {
	        	
	            for (var i = 0; i < nodeCount; i++) {
	            	attNode = attNodes.get(i);
	            	attNode.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = true;
	            	attNode.style.backgroundColor = m_strColorSelect;
	                //TODO: 테스트해보기 2016-06-02
	                // dhlee: modified so that existing elements aren't merged with new ones.
	                //listContentArry[listContentArry.length] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
	                listContentArry[i] = attNode.getAttribute("id");
	            }
	        } else {
	        	
	            for (var i = 0; i < nodeCount; i++) {
	            	attNode = attNodes.get(i);
	            	attNode.getElementsByTagName("td").item(0).getElementsByTagName("input").item(0).checked = false;
	            	attNode.style.backgroundColor = m_strColorDefault;
	            }
	            
	            listContentArry = new Array();
	        }
	    }
	    
	    function event_listCheckboxclick(obj) {
	        if (obj.checked) {
				obj.closest('tr').style.backgroundColor = m_strColorSelect;
	            listContentArry[listContentArry.length] = obj.closest('tr').getAttribute("id");
	        }
	        else {
	            var TemplistArray = new Array();
	            for (var i = 0; i < listContentArry.length; i++) {
	                if (obj.closest('tr').getAttribute("id") == listContentArry[i]) {
	                	obj.closest('tr').style.backgroundColor = m_strColorDefault;
	                }
	                else {
	                    TemplistArray[TemplistArray.length] = listContentArry[i];
	                }
	            }
	            listContentArry = TemplistArray;
	        }
	        listEventCheckbox = true;
	    }
	    
	    function mod_detail(t) {
	    	var pheight = window.screen.availHeight;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - 760) / 2;
	        var pLeft = (pwidth - 790) / 2;
			var feature = GetOpenPosition(790, 760);
			var tds =  t.getElementsByTagName("td");
			var modAttId;
			var applCnt;
			
			modAttId = tds[0].getElementsByTagName("input").item(0).getAttribute("value");
			applCnt = modAttId.split("\_")[1];
			modAttId = modAttId.split("\_")[0];
			
			window.open("/admin/ezAttitude/attModAppDetail.do?attModId=" + modAttId + "&applCnt=" + applCnt +"&adminFlag=" + adminFlag + "&pageInfo=" + pageInfo + "&companyId=" + pCompanyId, "",
				"height = 593px, width = 672px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    }
	    
	    function getHistory(t) {
		    var attModId = $(t).parent().parent().find('td input').attr("value");
			var companyId = $("#ListCompany").val();
			window.open("/ezAttitude/attitudeModHistory.do?attModId=" + attModId + "&companyId=" + companyId, "history", GetOpenWindowfeature(700, 300));
	    }
	    
	    function layerHidden() {
	        $.modal.close();
	        $('#addpopup_list tbody').children('tr').not(":first").remove();
	    }
		</script>
</head>
	<body style="overflow:hidden;" id="theBody" class="mainbody" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);">
		<h1>
			<spring:message code = 'ezAttitude.t7' /><span id="mailBoxInfo"></span>
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
					<td style="width: 3%;"><spring:message code='ezAttitude.t103'/></td>
					<td style="width: 12%;"><input type="text" id="writer_search" style="width: 90%;" onkeyup="search_keypress(event);"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t148'/></td>
					<td style="width: 11%;"><input type="text" id="writerDept_search" style="width: 90%;" onkeyup="search_keypress(event);"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.kje01'/></td>
					<td style="width: 11%;">
						<div class="custom_radio">
							<input name="searchCheck" id="Radio1" type="radio" value="all" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_set()"/><label for="Radio1">&nbsp;<spring:message code='ezAttitude.t124'/></label>
							<input name="searchCheck" id="Radio2" type="radio" value="0" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_set()"/><label for="Radio2">&nbsp;<spring:message code='ezAttitude.t209'/></label>
							<input name="searchCheck" id="Radio3" type="radio" value="1" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_set()"/><label for="Radio3">&nbsp;<spring:message code='ezAttitude.t210'/></label>
							<input name="searchCheck" id="Radio4" type="radio" value="2" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onchange="type_set()"/><label for="Radio4">&nbsp;<spring:message code='ezAttitude.t211'/></label>
						</div>
					</td>
				</tr>
				<tr>
					<td style="width: 3%;"><spring:message code='ezAttitude.t104'/></td>
					<td style="width: 12%;"><input type="text" id="appr_search" style="width: 90%;" maxlength="50" onkeyup="search_keypress(event);"></td>
					<td style="width: 3%;"><spring:message code='ezAttitude.t137'/></td>
					<td style="width: 9%;">
                    	<span id="sDateSpan"><input type="text" id="Sdatepicker" style="width:80px;text-align:center; float:left"/></span> <span style="vertical-align:middle;">~</span> <span id="eDateSpan"><input type="text" id="Edatepicker" style="width:80px;text-align:center;"/></span>
					</td>
					<td colspan="2">
						<a class="imgbtn" id="cancelBtn" onclick="att_search()" style="margin-top:3px;"><span><spring:message code='ezAttitude.t121'/></span></a>
						<a class="imgbtn" id="cancelBtn" onclick="att_search('refresh')" style="margin-top:3px;"><span><spring:message code='ezAttitude.t122'/></span></a>
						<a class="imgbtn" id="cancelBtn" onclick="get_excelAtt_list()" style="margin-top:3px;"><span><spring:message code='ezAttitude.t145'/></span></a>
						<a class="imgbtn" id="cancelBtn" onclick="modApprove()" style="margin-top:3px;"><span><spring:message code='ezAttitude.kje02'/></span></a>
						<a class="imgbtn" id="cancelBtn" onclick="modReturn()" style="margin-top:3px;"><span><spring:message code='ezAttitude.kje03'/></span></a>
					</td>
				</tr>
			</tbody>
		</table>
		<div id="contentlist" name="contentlist" style="border:0px solid blue;height:600px;width:100%;overflow-y:auto;margin-top:5px" onblur>
			<table class="mainlist" style="width:100%;" id="AttList" listpageCount="${mailGeneral.listCount}" curPage="1">
				<tr id="headerList">
					<th width="20px" align="center" style="text-align: center;"> <%-- <spring:message code="ezPoll.t105"/> --%>
						<div class="custom_checkbox">
							<input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;" onchange="javascript:event_HeaderCheckBoxClick(this)"/>
						</div>
					</th>
					<th width="60px" colname="NO">NO.</th>
					<th style="cursor:pointer" colname="START_DATE"><spring:message code='ezAttitude.t107'/></th>
					
					<th style="cursor:pointer" colname="WRITER_NAME"><spring:message code='ezAttitude.t147'/></th>
					<th style="cursor:pointer" colname="WRITER_DEPT_NAME"><spring:message code='ezAttitude.t148'/></th>
					<th width="125px" style="cursor:pointer" colname="ORIGIN_TIME"><spring:message code='ezAttitude.t206'/></th>
					<th width="125px" style="cursor:pointer" colname="NO"><spring:message code='ezAttitude.t207'/></th>
					<th width="125px" style="cursor:pointer" colname="APPR_STATUS" ><spring:message code='ezAttitude.kje01'/></th>
					<th width="100px" style="cursor:pointer" colname="APPR_USER_NAME"><spring:message code='ezAttitude.t104'/></th>
					<th width="130px" style="cursor:pointer" colname="APPL_DATE"><spring:message code='ezAttitude.t108'/></th>
					<th width="125px" style="cursor:pointer" colname="NO"><spring:message code='ezAttitude.t97'/></th>
				</tr>		
			    <c:if test="${list.size() == 0}"> 
			        <tr>
			        	<td colspan="10" align="center"  bgcolor="#FFFFFF"><spring:message code='ezAttitude.t96'/></td>
		       		</tr>
		        </c:if>
			</table>
		</div>
		<div id="tblPageRayer"></div>
        <div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="attPanel" onclick="ContextMenuHidden();" ></div>
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="AttProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div id ="forExcel">
		</div>
        <table class="mainlist" style="width:100%;display:none;" id="ExcelAttList">
	       	<tr>
				<th>NO.</th>
				<th><spring:message code='ezAttitude.t107'/></th>
				<th><spring:message code='ezAttitude.t147'/></th>
				<th><spring:message code='ezAttitude.t148'/></th>
				<th><spring:message code='ezAttitude.t206'/></th>
				<th><spring:message code='ezAttitude.t207'/></th>
				<th><spring:message code='ezAttitude.t208'/></th>
				<th><spring:message code='ezAttitude.t104'/></th>
				<th><spring:message code='ezAttitude.t108'/></th>				
			</tr>
		</table>
<!-- 		팝업 -->
		<div id="popup" class="popupwrap1" style="display:none;margin-bottom:50px;max-width:550px;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezAttitude.t141'/></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="popup_close()"></span></a></li>
		            </ul>
		        </div>
				<!-- 내용 -->
			    <table class="popuplist" id="addpopup_list" style="display:block;margin:10px 0px 0px 1px;">
				    <tbody style="max-height:500px; display:block; overflow-y:auto;">
				    	<tr>
							<th style="width:120px;height:30px"><spring:message code='ezAttitude.t107'/></th>
				    		<th style="width:30px; height:30px"><spring:message code='ezAttitude.t206'/></th>
				    		<th style="width:30px; height:30px"><spring:message code='ezAttitude.t207'/></th>
				  			<th style="height:30px"><spring:message code='ezAttitude.t104'/></th>
				  			<th style="width:120px;height:30px"><spring:message code='ezAttitude.t116'/></th>
				  			<th style="height:30px"><spring:message code='ezAttitude.t208'/></th>
						</tr>
				    </tbody>
				</table>
				<!-- /내용 -->
				<br />
			</div>
		</div>
		
		<form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezAttitude/saticGetXlsAtt.do">
	        <input type="hidden" id="saveFileName" name="saveFileName" value="<spring:message code = 'ezAttitude.t7' />"/>
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value=""/>
	        <input type="hidden" id="userAgent" name="userAgent" value=""/>
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	</body>
</html>