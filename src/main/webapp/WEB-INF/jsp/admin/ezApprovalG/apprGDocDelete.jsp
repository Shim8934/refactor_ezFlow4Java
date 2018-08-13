<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<HTML>
	<HEAD>
		<title><spring:message code='ezApprovalG.t1569'/></title>
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link type="text/css" rel="stylesheet" href="/css/Tab.css" />
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/admin/DocDelete_Cross.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"> </script>
		<style type="text/css">
			<!-- datepicker 월 나타내는 selectbox안의 글자가 자꾸 밑으로 내려가는 현상때문에 스타일 줌. -->
			select {
				height: auto;
			}
			/* 2018-08-02 김보미 - 검색 테이블 ui수정 */
			/*
			table, td {
				white-space: nowrap;
				/* overflow: hidden; */
			/*	text-overflow: ellipsis;
			}
			*/
			.mainlist, .mainlist th, .mainlist td {
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
			}
			td {
				padding: 8px 5px;
			}
			.mainlist tr th {border-top:0px}
		</style>
		<SCRIPT type="text/javascript" ID="clientEventHandlersJS" >
		    var Check = false, PeriodDocList;
		    var ScontID;
		    var P_CompanyID = "";
		    var ListIdx;
		    var text1 = "<spring:message code='ezStatistics.t1008'/>";
		    var deleteTimes = 0;		    
		    var pUse_Editor = "${useEditor}";
		    
		    var CurPage = "";
			var totalPage = "";
			var totalCount = "";
			var BlockSize = 10;
			var searchStartTime = "";
			var searchEndTime = "";
			var std = "";
			var etd = "";
			var startDate = "";
			var endDate = "";
			var usedate = false;
			var strListIDInfo = "";
			var strListWriterNameInfo = "";
			var strListDocNoInfo = "";
			var strListDocTitleInfo = "";
			var strListDeptNameInfo = "";
			var changeTab = "completedoclist";
			var pSelectTab = "completedoclist";
			var Tab1_SelectID = "";
		    var Tab1_flag = true;
			
			var selectelem = null;
			
		    function window_onload() {
		   	
		    	P_CompanyID = $('#ListCompany').val();
		    	getDocDeleteHist(1);
		    	makePageSelPage();
		    	getTime();
		    	
		    	if (changeTab == "completedoclist") {
				        ChangeTab(document.getElementById("1tab1"));
				        $("#1tab1").click();
			        } else {
			        	ChangeTab(document.getElementById("1tab2"));
			        	$("#1tab2").click();
			        }
		    	
	    	    $("#startDatepicker").datepicker('disable');
		        $("#endDatepicker").datepicker('disable');
		        
		        //더블클릭으로 셀선택 방지
		        $(document).bind("selectstart", function(event){event.preventDefault();});
		        //드래그 방지
		        $(document).bind("dragstart", function(event){event.preventDefault();});
		    }
		    
			// 검색값 입력 후 엔터키 입력 시 검색 호출
			 function search_keypress(evt) {
	        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
	
	        
	        if (evtKeyCode == "13") {
	            search(1);
	        }
	    }
		    
		    // 날짜 아이콘 적용 및 날짜 검색
			 function getTime() {
				
				var dateObj = new Date();
				var year = dateObj.getFullYear();
				var month = dateObj.getMonth() + 1;
				var date = dateObj.getDate();
				
				if (date < 10) {
					date = '0' + date;
				}
				
				if (month < 10) {
					month = '0' + month;
				}
				
				dateObj = year + "-" + month + "-" + date;
				searchStartTime = dateObj;
		    	searchEndTime = dateObj;
		    	
		    	$('#startDatepicker').val(dateObj);
				$('#endDatepicker').val(dateObj);
				
				std = $('#startDatepicker').val();
				etd = $('#endDatepicker').val();
				
			}
		
		    $(function() {
		    	$('#startDatepicker').datepicker({
		    		changeMonth: true,
		    		changeYear: true,
		    		autoSize: true,
		    		showOn: "both",
		    		buttonImage: "/images/ImgIcon/calendar-month.gif",
		    		buttonImageOnly: true,
		    		maxDate: 0,
		    		onSelect: function(selected) {
		    			compareDateStart();
	    				etd = $('#endDatepicker').val();
		    		}
		    	});
		    	
		    	$('#endDatepicker').datepicker({
		    		changeMonth: true,
		    		changeYear: true,
		    		autoSize: true,
		    		showOn: "both",
		    		buttonImage: "/images/ImgIcon/calendar-month.gif",
		    		buttonImageOnly: true,
		    		maxDate: 0,
		    		onSelect: function(selected) {
		    			compareDateEnd();
	    				std = $('#startDatepicker').val();
		    		}
		    	});  
		    	
		    	 	var SDate = new Date();
			        var EDate = new Date();
			        
			        $("#startDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#startDatepicker").datepicker('setDate', SDate);
			
			        $("#endDatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#endDatepicker").datepicker('setDate', EDate);
		    	
		    });
		    
			function compareDateStart() {
				startDate = new Date($("#startDatepicker").datepicker("getDate"));
				endDate = new Date($("#endDatepicker").datepicker("getDate"));
				
				if (startDate - endDate > 0) {
					std = $('#startDatepicker').val();
    				$('#endDatepicker').val(std);
				}		
				
			}
		   	
		   	function compareDateEnd() {
				startDate = new Date($("#startDatepicker").datepicker("getDate"));
				endDate = new Date($("#endDatepicker").datepicker("getDate"));
				
				if (endDate - startDate < 0) {
					etd = $('#endDatepicker').val();
					$('#startDatepicker').val(etd);
				} 
				
			}
		   	
		   	var dayMsg = "<spring:message code='main.kyj1'/>";
			var dayStr = dayMsg.split(";");
			var monthMsg = "<spring:message code='main.kyj2'/>";
			var monthStr = monthMsg.split(";");
		    
			$(function() {
				$.datepicker.regional["<spring:message code='main.t0619'/>"] = {
					closeText : "<spring:message code='main.t3'/>",
					prevText : "<spring:message code='main.t0604'/>",
					nextText : "<spring:message code='main.t0605'/>",
					currentText : "<spring:message code='main.t0606' />",
					monthNames : monthStr,
					monthNamesShort : monthStr,
					dayNames : dayStr,
					dayNamesShort : dayStr,
					dayNamesMin : dayStr,
					weekHeader : 'Wk',
					dateFormat : 'yy-mm-dd',
					firstDay : 0,
					isRTL : false,
					duration : 200,
					showAnim : 'show',
					showMonthAfterYear : true
				};
				$.datepicker
						.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]);
			});
			
			// 페이징처리
			function td_Create1(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			}

			function makePageSelPage() {
				var strtext;
				var PagingHTML = "";
				$("#tblpageRayer").html("");
				$("#listInfo").html(" &nbsp;[<spring:message code='main.t252'/><span style='color:#017BEC;'> "
						+ totalCount + " </span><spring:message code='ezSystem.kyj2'/>]")
				strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
				var pageNum = CurPage;

				if (totalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif'></span>"
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif'></span>"
					PagingHTML += strtext;
				}

				if (totalPage > BlockSize) {
					if (pageNum > BlockSize) {
						strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
					PagingHTML += strtext;
				}

				var MaxNum;
				var i;
				var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;

				if (totalPage >= (startNum + parseInt(BlockSize))) {
					MaxNum = (startNum + parseInt(BlockSize)) - 1;
				} else {
					MaxNum = totalPage;
				}

				for (i = startNum; i <= MaxNum; i++) {
					if (i == pageNum) {
						strtext = "<span class='on'>" + i + "</span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span onclick='goToPageByNum(" + i + ")'>"
								+ i + "</span>";
						PagingHTML += strtext;
					}
				}

				if (totalPage > BlockSize) {
					if (totalPage >= parseInt(((parseInt((pageNum - 1)
							/ BlockSize) + 1) * BlockSize) + 1)) {
						strtext = "";
						strtext = strtext
								+ "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext
								+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext
							+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
					PagingHTML += strtext;
				}

				if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
					strtext = "<span class='btnimg' onclick='return goToPageByNum("
							+ totalPage
							+ ")'><img src='/images/sub/btn_n_next.gif'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif'></span>";
					PagingHTML += strtext;
				}

				PagingHTML += "</div>";
				td_Create1(PagingHTML);
			}
			
			function goToPageByNum(Value) {
				
				if ($("#checkboxAll").is(":checked")) {
		    		$("#checkboxAll").prop("checked", false);
		    		$(".row_body").css("background", "");
		    	}
				
				strListIDInfo = "";
				strListWriterNameInfo = "";
				strListDocNoInfo = "";
				strListDocTitleInfo = "";
				strListDeptNameInfo = "";
				
				CurPage = Value;
				makePageSelPage();
				goToPage(CurPage);
			}
			
			function selbeforeBlock() {
				var pageNum = parseInt(CurPage);
				pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}

			function selbeforeBlock_one() {
				var pageNum = parseInt(CurPage);

				if (parseInt(pageNum - 1) > 0) {
					goToPageByNum(parseInt(pageNum - 1));
				} else {
					return;
				}
			}

			function selafterBlock() {
				var pageNum = parseInt(CurPage);
				pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}

			function selafterBlock_one() {
				var pageNum = parseInt(CurPage);

				if (parseInt(pageNum + 1) <= totalPage) {
					goToPageByNum(parseInt(pageNum + 1));
				} else {
					return;
				}
			}
			
			function goToPage(page) {
				getDocDeleteHist(page);
			}
			
			function getDocDeleteHist(pageNum) {
				
				var docnumber = $("#DocNumber").val();
				var doctitle = $("#DocTitle").val();
				var drafter = $("#drafter").val();
				var drafterdept = $("#drafterdept").val();
				
				if (!$("#usedate").prop("checked")) {
					searchStartTime = "";
					searchEndTime = "";
				} else {
					searchStartTime = $('#startDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
					searchEndTime = $('#endDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
				}
				
					var pURL = "/admin/ezApprovalG/getDocListjson.do";

					$.ajax({
							url : pURL,
							type : "POST",
							async : false,
							dataType : 'json',
							data : {
								contID     : ScontID,
								pageNum    : pageNum,
								companyID  : P_CompanyID,
								docNO  	   : docnumber,//문서번호
								docTitle   : doctitle,//문서제목
								drafter    : drafter,//기안자
								aprFrom    : searchStartTime,//완료일자
								aprTo      : searchEndTime,//완료일자
								deptName   : drafterdept,//기안부서
								pSelectTab : pSelectTab//탭구분	
							},
							success : function(res) {
								if (res.pSelectTab == "completedoclist") {
									$("#doclist").empty().append(
											/* 2018-07-31 김보미 - style에 ellipsis 추가 */
//												  '<th style="width:3%;"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 4px; vertical-align:middle"/></th>'
//												+ '<th style="width:15%;"><spring:message code="ezApproval.t434"></spring:message></th>'
//												+ '<th style="width:2%;"><img src="/images/newAttach.gif"></th>'
//												+ '<th style="width:*;"><spring:message code="ezApprovalG.t106"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApproval.t433"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApproval.t437"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApprovalG.t445"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezStatistics.t1042"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezTask.t210"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApproval.t448"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezApprovalG.t47"></spring:message></th>'
											  '<th style="width:3%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 4px; vertical-align:middle"/></th>'
											+ '<th style="width:15%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t434"></spring:message></th>'
											+ '<th style="width:2%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><img src="/images/newAttach.gif"></th>'
											+ '<th style="width:25%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.t106"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t433"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t437"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.t445"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezStatistics.t1042"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezTask.t210"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t448"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.t47"></spring:message></th>'
											)
								} else {
									$("#doclist").empty().append(
											/* 2018-07-31 김보미 - style에 ellipsis 추가 */
//												  '<th style="width:3%;"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 4px; vertical-align:middle"/></th>'
//												+ '<th style="width:15%;"><spring:message code="ezApproval.t434"></spring:message></th>'
//												+ '<th style="width:2%;"><img src="/images/newAttach.gif"></th>'
//												+ '<th style="width:*;"><spring:message code="ezApprovalG.t106"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApproval.t433"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApproval.t437"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApprovalG.t445"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezStatistics.t1042"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezTask.t210"></spring:message></th>'
//												+ '<th style="width:10%;"><spring:message code="ezApproval.t368"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezApprovalG.kes03"></spring:message></th>'
//												+ '<th style="width:5%;"><spring:message code="ezApprovalG.t47"></spring:message></th>'
											  '<th style="width:3%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 4px; vertical-align:middle"/></th>'
											+ '<th style="width:15%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t434"></spring:message></th>'
											+ '<th style="width:2%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><img src="/images/newAttach.gif"></th>'
											+ '<th style="width:25%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.t106"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t433"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t437"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.t445"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezStatistics.t1042"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezTask.t210"></spring:message></th>'
											+ '<th style="width:10%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApproval.t368"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.kes03"></spring:message></th>'
											+ '<th style="width:5%;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><spring:message code="ezApprovalG.t47"></spring:message></th>'
											)
								}
								
								var html = "";

								if (res.totalcnt < 1) {
									if (res.pSelectTab == "completedoclist") {
										html += "<tr><td colspan='11' style='text-align:center;'>"+text1+"</td></tr>";
									} else {
										html += "<tr><td colspan='12' style='text-align:center;'>"+text1+"</td></tr>";
									}
								} else {
									res.DocDeleteHistList.forEach(function(i, v) {
										html += "<tr class='row_body' onclick='select_row(this)' ondblclick='openDoc(this)' docid='docID_" + i.docID + "' id='" + i.docID + "' writerName='" + i.writerName + "' " 
											 + "DocTitle='" + i.docTitle + "' DocNo='" + i.docNo + "' DeptName='" + i.writerDeptName + "' style='cursor: pointer; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;'"
											 + "formid='"+i.formID+"' dochref='"+i.href+"' orgdocid='"+i.orgDocID+"' >";
										/* 2018-07-31 김보미 - style에 ellipsis 추가 */
										/*html += "   <td><input type ='checkbox' name='myCheckbox' id='" + i.docID + "' onclick='chk_onselect(this)' writerName='" 
											 + i.writerName + "' DocTitle='" + i.docTitle + "' DocNo='" + i.docNo + "' DeptName='" + i.writerDeptName + "'></td>";
										html += "	<td title=\'" + i.docNo + "'>"	+ i.docNo	+ "</td>";
										if (i.hasAttachYn != "N") {
											html += '<td><img src="\/images\/newAttach.gif"></td>';
										} else {
											html += "<td>"  +   		 " "   	 				+ "</td>";
										}
										html += "	<td>"	+ i.docTitle						+ "</td>";
										html += "	<td>"	+ i.formName						+ "</td>";
										html += "	<td>"	+ i.writerDeptName					+ "</td>";
										html += "	<td>"	+ i.writerName						+ "</td>";
										html += "	<td>"	+ i.docstateName					+ "</td>";
										html += "	<td>"	+ i.sendFlag						+ "</td>";
										html += "	<td>"	+ i.endDate					        + "</td>";
										if (res.pSelectTab != "completedoclist") {
											html += "	<td>"	+ i.receiptPointName			+ "</td>";
										}
										html += "	<td>"	+ i.isPublic						+ "</td>";*/
										html += "   <td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'><input type ='checkbox' name='myCheckbox' id='" + i.docID + "' onclick='chk_onselect(this)' writerName='" 
											 + i.writerName + "' DocTitle='" + i.docTitle + "' DocNo='" + i.docNo + "' DeptName='" + i.writerDeptName + "'></td>";
										html += "	<td title=\'" + i.docNo + "' style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.docNo	+ "</td>";
										if (i.hasAttachYn != "N") {
											html += '<td style="white-space: nowrap;overflow: hidden;text-overflow: ellipsis;"><img src="\/images\/newAttach.gif"></td>';
										} else {
											html += "<td>"  +   		 " "   	 				+ "</td>";
										}
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.docTitle		+ "</td>";
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.formName		+ "</td>";
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.writerDeptName	+ "</td>";
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.writerName		+ "</td>";
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.docstateName	+ "</td>";
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.sendFlag		+ "</td>";
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.endDate			+ "</td>";
										if (res.pSelectTab != "completedoclist") {
											html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.receiptPointName			+ "</td>";
										}
										html += "	<td style='white-space: nowrap;overflow: hidden;text-overflow: ellipsis;'>"	+ i.isPublic						+ "</td>";
										html += "</tr>";
									});
								}
								
								$('#DocCompleteListBody').empty().append(html);
								
								CurPage = res.currPage;
								totalPage = res.totalPage;
								totalCount = res.totalcnt;
								searchStartTime = res.startdate;
								searchEndTime = res.endDate;
							},
							error : function(err) {
								alert(err);
							}
						});
					makePageSelPage();
			}
			
			function chk_onselect(obj) {
				if (obj.checked) {
		            strListIDInfo += $(obj).attr("id") + ";";
		            strListWriterNameInfo += $(obj).attr("writerName") + ";";
		            strListDocNoInfo += $(obj).attr("DocNo") + ";";
		            strListDocTitleInfo += $(obj).attr("DocTitle") + ";";
		            strListDeptNameInfo += $(obj).attr("DeptName") + ";";
		            
		            selectelem = null;
		        } else {
		            strListIDInfo = ReplaceText(strListIDInfo, $(obj).attr("id") + ";", "");
		            strListWriterNameInfo = ReplaceText(strListWriterNameInfo, $(obj).attr("writerName") + ";", "");
		            strListDocNoInfo = ReplaceText(strListDocNoInfo, $(obj).attr("DocNo") + ";", "");
		            strListDocTitleInfo = ReplaceText(strListDocTitleInfo, $(obj).attr("DocTitle") + ";", "");
		            strListDeptNameInfo = ReplaceText(strListDeptNameInfo, $(obj).attr("DeptName") + ";", "");
		            selectelem = obj.parentNode.parentNode;
		        }
		    }
			
			function select_row(elem) {		    	
				if ($("#checkboxAll").is(":checked")) {					
					if ($("input[id='" + $(elem).attr("id") + "']").prop("checked") == true && selectelem != null) {//전체 선택 후 개별 선택 시 선택한것 해제
						$("input[id='" + $(elem).attr("id") + "']").prop("checked", false);
						$(".row_body[id='" + $(elem).attr("id") + "']").css("background", "#ffffff");
						strListIDInfo = ReplaceText(strListIDInfo, $(elem).attr("id") + ";", "");
			            strListWriterNameInfo = ReplaceText(strListWriterNameInfo, $("input[id='" + $(elem).attr("id") + "']").attr("writerName") + ";", "");
			            strListDocNoInfo = ReplaceText(strListDocNoInfo, $("input[id='" + $(elem).attr("id") + "']").attr("DocNo") + ";", "");
			            strListDocTitleInfo = ReplaceText(strListDocTitleInfo, $("input[id='" + $(elem).attr("id") + "']").attr("DocTitle") + ";", "");
			            strListDeptNameInfo = ReplaceText(strListDeptNameInfo, $("input[id='" + $(elem).attr("id") + "']").attr("DeptName") + ";", "");
			    		return;
					}
					
					// 목록에서 하나씩 다른거 선택할 때
					if ((selectelem != null && selectelem != elem)) {
						strListIDInfo += $(elem).attr("id") + ";";
			            strListWriterNameInfo += $(elem).find("input").attr("writerName") + ";";
			            strListDocNoInfo += $(elem).find("input").attr("DocNo") + ";";
			            strListDocTitleInfo += $(elem).find("input").attr("DocTitle") + ";";
			            strListDeptNameInfo += $(elem).find("input").attr("DeptName") + ";";
			            
			        	selectelem = null;
			    	}
				} else {					
					// 목록에서 하나씩 다른거 선택할 때
			    	if ((selectelem != null && selectelem != elem)) {
	 					$("input[name=myCheckbox]").prop("checked", false);
	 					$(".row_body").css("background", "#ffffff");	 					
						strListIDInfo = $(elem).attr("id") + ";";
			            strListWriterNameInfo = $(elem).find("input").attr("writerName") + ";";			            
			            strListDocNoInfo = $(elem).find("input").attr("DocNo") + ";";			            
			            strListDocTitleInfo = $(elem).find("input").attr("DocTitle") + ";";			            
			            strListDeptNameInfo = $(elem).find("input").attr("DeptName") + ";";			            
			        	selectelem = null;
			    	}
				}

				// 체크 후 체크박스 눌러서 체크 해제할 때
		        if (selectelem != null) {
					if ($("#checkboxAll").is(":checked")) {
			        	$("input[id='" + $(elem).attr("id") + "']").prop("checked", false);
			        	$(".row_body[id='" + $(elem).attr("id") + "']").css("background", "#ffffff");
						return;
					} else {
			        	selectelem.style.backgroundColor = "#ffffff";
			        	$("input[id='" + $(selectelem).attr("id") + "']").prop("checked", false);
			            selectelem = null;
			            return;
					}
		        }

		        selectelem = elem;
		        elem.style.backgroundColor = "#edf4fd";
		        $("input[id='" + $(elem).attr("id") + "']").prop("checked", true);

		        // 목록화면 나오고 처음 선택할 때 strListIDInfo 값 셋팅
		        if (strListIDInfo == "") {
		        	strListIDInfo = $(elem).attr("id") + ";";
		        	strListWriterNameInfo = $(elem).find("input").attr("writerName") + ";";
		        	strListDocNoInfo = $(elem).find("input").attr("DocNo") + ";";
		        	strListDocTitleInfo = $(elem).find("input").attr("DocTitle") + ";";
		        	strListDeptNameInfo = $(elem).find("input").attr("DeptName") + ";";
		        	
		        }
		    }
			
			  function selectAll() {
					$(selectelem).css("background", "#ffffff");

					var deleteListID = [];
					var deleteListWriterName = [];
					var deleteListDocNo = [];
					var deleteListDocTitle = [];
					var deleteListDeptName = [];
					console.log('$("#checkboxAll").is(":checked") : '+$("#checkboxAll").is(":checked"));
					if ($("#checkboxAll").is(":checked")) {
						strListIDInfo = "";
						strListWriterNameInfo = "";
						strListDocNoInfo = "";
						strListDocTitleInfo = "";
						strListDeptNameInfo = "";

						$(":checkbox[name=myCheckbox]").prop("checked", true);
						$(".row_body").css("background", "#edf4fd");

						$(":checkbox[name=myCheckbox]:checked").each(function(){
							deleteListWriterName.push($(this).attr("writerName") + ";");
							deleteListID.push($(this).attr("id") + ";")
							deleteListDocNo.push($(this).attr("DocNo") + ";");
							deleteListDocTitle.push($(this).attr("DocTitle") + ";");
							deleteListDeptName.push($(this).attr("DeptName") + ";");
						});

						for (var i = 0; i < deleteListID.length; i++) {
							strListWriterNameInfo += deleteListWriterName[i];
							strListDocNoInfo += deleteListDocNo[i];
							strListDocTitleInfo += deleteListDocTitle[i];
							strListDeptNameInfo += deleteListDeptName[i];
							strListIDInfo += deleteListID[i];
						}
					} else {
						strListIDInfo = "";
						strListWriterNameInfo = "";
						strListDocNoInfo = "";
						strListDocTitleInfo = "";
						strListDeptNameInfo = "";
						selectelem = null;

						$(":checkbox[name=myCheckbox]").prop("checked", false);
						$(".row_body").css("background", "");
					}
					
			    }
			  
			// 검색 버튼 클릭시 이벤트
			function search(pageNum) {
				$(function() {

					if ($('#DocNumber').val().trim() == "") {
						$('#DocNumber').val('');
					}

					if ($('#startDatepicker').val() != ''
							&& $('#endDatepicker').val() == '') {
						alert(strLang5);
						return false;
					}

					if ($('#startDatepicker').val() == ''
							&& $('#endDatepicker').val() != '') {
						alert(strLang6);
						return false;
					}
					
					getDocDeleteHist(pageNum);
				});
			}
			
			function DateSearch_Click() {
		        if(usedate){
		        	usedate = false;
		            $("#startDatepicker").datepicker('disable');
		            $("#endDatepicker").datepicker('disable');
		        } else {
		        	usedate = true;
		            $("#startDatepicker").datepicker('enable');
		            $("#endDatepicker").datepicker('enable');
		        }
		    }
			
			 function DeleteDoc() {
			        if (strListWriterNameInfo == null || strListWriterNameInfo == "") {
			            alert("<spring:message code='ezApproval.t232' />");
			            return;
			        }
					var now = new Date();
					var DeleteDay = now.getFullYear();
					DeleteDay += '-'+(now.getMonth()+1);
					DeleteDay += '-'+now.getDate();
					DeleteDay += ' '+now.getHours();
					DeleteDay += ':'+now.getMinutes();
					DeleteDay += ':'+now.getSeconds();
					
					if (confirm("<spring:message code='ezApprovalG.t1728' />")) {
						$.ajax({
							type : "POST",
							dataType : "text",
							url : "/admin/ezApprovalG/delDocListjson.do",
							data : {
								docIDList      : strListIDInfo,
								docNoList      : strListDocNoInfo,
								docTitleList   : strListDocTitleInfo,
								WriterNameList : strListWriterNameInfo,
								DeptNameList   : strListDeptNameInfo,
								deleteDay      : DeleteDay,
								companyID      : P_CompanyID
							},
							success : function() {
								RefreshView();
								$("#checkboxAll").prop("checked", false);

							},
							error : function() {
								alert("<spring:message code='ezApproval.t131' />");
							}
						})
					}
			    }
			 
			 function RefreshView(){
			 
				 strListIDInfo = "";
				 strListWriterNameInfo = "";
			     strListDocNoInfo = "";
				 strListDocTitleInfo = "";
				 strListDeptNameInfo = "";
					
				 getDocDeleteHist(CurPage);
				 search(CurPage);
				 
			 }
			function reload() {
				
				$(":checkbox[id=usedate]").prop("checked", false);
				usedate = false;
				$("#checkboxAll").prop("checked", false);
				$("#startDatepicker").datepicker('disable');
		        $("#endDatepicker").datepicker('disable');
		        
		        $("#DocNumber").val("");
				$("#DocTitle").val("");
				$("#drafter").val("");
				$("#drafterdept").val("");
				
				getDocDeleteHist(1);
		    	makePageSelPage();
			}
			
			function openDoc(obj) {
				
				var DocID = $(obj).attr("id");
				var pURL = $(obj).attr("dochref");
				var formID = $(obj).attr("formid");
				var orgDocid = $(obj).attr("orgdocid");
				
				if ($(obj).attr("orgdocid") == "" || $(obj).attr("orgdocid") == "null" ||escape(orgDocid.replace(/ /gi, "")) == "%0A")
		            orgDocid = "";
		        else
		            orgDocid = $(obj).attr("orgdocid");
				
				var openLocation = "/ezApprovalG/contDocView.do";
				openLocation += "?docID=" + encodeURIComponent(DocID) + "&docHref=" + encodeURIComponent(pURL) + "&formID=" + encodeURIComponent(formID) + "&orgDocID=" + encodeURIComponent(orgDocid) + "&admin=Y";
				console.log(openLocation);
				GetOpenWindow(openLocation, "", 1000, 950, "YES");
			}
			
			function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {
		            	document.getElementById(Tab1_SelectID).className = "";
		            }
		
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		            show_page(obj);
		        }
		    }
			
			function show_page(obj) {
				
				if(obj.id == "1tab2") {
					
					$("#delbtn").css("display","none");
					
				} else {
				
					$("#delbtn").css("display","");
					
				}
				reload();
			}
		    
			function ChangeTab(obj) {
			        pSelectTab = $(obj).attr("divname");

			        switch (pSelectTab) {
			            case "completedoclist":
			                type = "1";
			                break;
			            case "deletedoclist":
			                type = "2";
			                break;
			        }

			    }
			
			  function Tab1_NewTabIni(pTabNodeID) {
			        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
			            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
			                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
			                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
			                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
			                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
			
			                    if (Tab1_flag) {
			                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
			                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
			                        Tab1_flag = false;
			                    }
			
			                }
			            }
			        }
			    }
			  
			  function Tab1_MouserOver(obj) {
			        obj.className = "tabover";
			    }
			    
			    function Tab1_MouserOut(obj) {
			        if (Tab1_SelectID != obj.id) {
			            obj.className = "";
			        } else {
			        	obj.className = "tabon";
			        }
			    }
			
			    function changeCompID() {				
				    if (P_CompanyID != $("#ListCompany").val()) {
				        P_CompanyID = $("#ListCompany").val();
				
				        $("#DocNumber").val("");
						$("#DocTitle").val("");
						$("#drafter").val("");
						$("#drafterdept").val("");

						strListIDInfo = "";
						strListWriterNameInfo = "";
						strListDocNoInfo = "";
						strListDocTitleInfo = "";
						strListDeptNameInfo = "";
						
						$('#DocCompleteListBody').empty().append("<tr><td colspan='11' style='text-align:center;'>"+text1+"</td></tr>");
			            
						$("#checkboxAll").prop("checked", false);
			            getDocDeleteHist(1);
				    }
				}
			    
			    var organ_dialogArguments = new Array();
			    function bt_TDeptSelect_onclick() {
			    	organ_dialogArguments[0] = P_CompanyID;
		            organ_dialogArguments[1] = bt_TDeptSelect_onclick_Complete;
		            var result = GetOpenWindow("/admin/ezApprovalG/apprGOrgan.do", "Organ_Cross", 400, 485, "NO");
		        }
		        
		        function bt_TDeptSelect_onclick_Complete(retVal) {
		            if (typeof (retVal) != "undefined") {
		                $("#drafterdept").val(retVal[1]);
		            }
		        }
			    
		</script>
	</head>
	
	<body class="mainbody" onLoad="javascript:window_onload()">
		<h1><spring:message code='ezApprovalG.t1569'/><span id="listInfo"></span></h1>
		<input type="hidden" id="ListCompany" value="${userInfo.companyID }" >
		<div class="portlet_tabpart01" style="margin-top:3px;text-align:right;">
		    <div class="portlet_tabpart01_top" id="tab1">
		        <p><span id="1tab1" divname="completedoclist"><spring:message code='ezApprovalG.kes01' /></span></p>
		        <p><span id="1tab2" divname="deletedoclist"><spring:message code='ezApprovalG.kes02' /></span></p>		        
		    </div>
		</div>
		<!-- 2018-08-02 김보미 - 검색 테이블 ui수정 -->
	<!-- <table style="width: 100%; background-color: #fcfcfc;">
			<tr>
				<table style="width:100%; background-color: #fcfcfc; border-right: 1px solid #e8e8e8; border-left: 1px solid #e8e8e8;">
					<tr>
						<td style="width:60px;">
							<spring:message code='ezApproval.t434'/> 
						</td>
						<td style="width:80px;">
							<input type="text" id="DocNumber" name="DocNumber" style="width:110px; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)" />
						</td>
						<td style="width:50px;">
							<spring:message code='ezApproval.t435'/> 
						</td>
						<td style="width:80px;">
							<input type="text" id="DocTitle" name="DocTitle" style="width:110px; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>
						</td>
						<td style="width:250px; margin-bottom: 10px;">
							<span id="topmenu" style="width: 500px">
								<input type="checkbox" id="usedate" value="1" onclick="DateSearch_Click();"><label for="usedate"><spring:message code='ezSystem.x0032'/></label>&nbsp;
								<input type="text" id="startDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />&nbsp; ~ &nbsp;
								<input type="text" id="endDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />
							</span>
						</td>
						<td style="width:*;"></td>
					</tr>
				</table>
			</tr>
			<tr>
				<table style="width:100%; background-color: #fcfcfc; border-left: 1px solid #e8e8e8;border-right: 1px solid #e8e8e8;">
					<tr>
						<td style="width:60px;">
							 <spring:message code='ezApproval.t437'/>
						</td>
						<td style="width:170px;">
							<input type="text" id="drafterdept" name="drafterdept" style="width:110px; height: 23px;" maxlength="50" readonly="readonly"/>
							<a class="imgbtn" name="TDeptSelect"><span id = "spandept" onclick="bt_TDeptSelect_onclick()"><spring:message code='ezApprovalG.t105'/></span></a>
						</td>
						<td style="width:40px;">
						    <spring:message code='ezApproval.t436'/> 
						</td>
						<td style="width:80px;">
							<input type="text" id="drafter" name="drafter" style="width:110px; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>&nbsp;
						</td>
						<td style="width:*; margin-bottom: 10px;">
							<a class="imgbtn" >
								<span onclick="javascript:search(1);"><spring:message code="ezApproval.t236"></spring:message></span>
							</a>&nbsp; 
							<a class="imgbtn">
								<span onClick="reload()"><spring:message code='ezApprovalG.t165' /></span>
							</a>&nbsp;
							<a class="imgbtn" id ="delbtn">
								<span onClick="DeleteDoc()"><spring:message code='ezApprovalG.t266' /></span>
							</a>&nbsp;
						</td>
					</tr>
				</table>
			</tr>
		</table>  -->
		<table style="width:100%; background-color: #fcfcfc; border-right: 1px solid #e8e8e8; border-left: 1px solid #e8e8e8; border-bottom:1px solid #e8e8e8">
			<tr>
				<td style="width:6%;">
					<spring:message code='ezApproval.t434'/> 
				</td>
				<td style="width:25%;">
					<input type="text" id="DocNumber" name="DocNumber" style="width:82%; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)" />
				</td>
				<td style="width:6%;">
					<spring:message code='ezApproval.t435'/> 
				</td>
				<td style="width:25%;">
					<input type="text" id="DocTitle" name="DocTitle" style="width:85%; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>
				</td>
				<td style="width:7%; margin-bottom: 10px;">
					<span id="topmenu" style="width: 500px">
						<input type="checkbox" id="usedate" value="1" onclick="DateSearch_Click();"><label for="usedate"><spring:message code='ezSystem.x0032'/></label>&nbsp;
					</span>
				</td>
				<td style="width:31%; margin-bottom: 10px;">
					<span id="topmenu" style="width: 500px">
						<input type="text" id="startDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />&nbsp; ~ &nbsp;
						<input type="text" id="endDatepicker" class="hasDatapicker" style="width:90px; text-align: center" readonly="readonly" />
					</span>
				</td>
			</tr>
			<tr>
				<td style="width:3%;">
					 <spring:message code='ezApproval.t437'/>
				</td>
				<td style="width:12%;">
					<input type="text" id="drafterdept" name="drafterdept" style="width:82%; height: 23px;" maxlength="50" readonly="readonly"/>
					<a class="imgbtn" name="TDeptSelect"><span id = "spandept" onclick="bt_TDeptSelect_onclick()"><spring:message code='ezApprovalG.t105'/></span></a>
				</td>
				<td style="width:3%;">
				    <spring:message code='ezApproval.t436'/> 
				</td>
				<td style="width:11%;">
					<input type="text" id="drafter" name="drafter" style="width:85%; height: 23px;" maxlength="50" onkeypress="return search_keypress(event)"/>&nbsp;
				</td>
				<td style="width:*; margin-bottom: 10px;" colspan="2">
					<a class="imgbtn" >
						<span onclick="javascript:search(1);"><spring:message code="ezApproval.t236"></spring:message></span>
					</a> 
					<a class="imgbtn">
						<span onClick="reload()"><spring:message code='ezApprovalG.t165' /></span>
					</a>
					<a class="imgbtn" id ="delbtn">
						<span onClick="DeleteDoc()"><spring:message code='ezApprovalG.t266' /></span>
					</a>
				</td>
			</tr>
		</table>
		
		<table class="mainlist" style="width:100%; height: 100%;">
			<thead>
				<tr id ="doclist">
					<th style="width:1%;"><input id="checkboxAll" type="checkbox" onclick="selectAll()" style="width:13px; height:13px;padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 4px; vertical-align:middle"/></th>
					<th style="width:15%;"><spring:message code="ezApproval.t434"></spring:message></th>
					<th style="width:3%;"><spring:message code="ezApprovalG.t56"></spring:message></th>
					<th style="width:*;"><spring:message code="ezApprovalG.t106"></spring:message></th>
					<th style="width:10%;"><spring:message code="ezApproval.t433"></spring:message></th>
					<th style="width:10%;"><spring:message code="ezApproval.t437"></spring:message></th>
					<th style="width:10%;"><spring:message code="ezApprovalG.t445"></spring:message></th>
					<th style="width:5%;"><spring:message code="ezStatistics.t1042"></spring:message></th>
					<th style="width:5%;"><spring:message code="ezTask.t210"></spring:message></th>
					<th style="width:10%;"><spring:message code="ezApproval.t448"></spring:message></th>
					<th style="width:5%;"><spring:message code="ezApprovalG.t47"></spring:message></th>
				</tr>
			</thead>
			<tbody id="DocCompleteListBody" style="overflow: auto;"></tbody> 
		</table>
		<div id="tblPageRayer" style="padding-top: 10px;"></div>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</HTML>