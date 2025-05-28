<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.ls06'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"> </script>
		
		<style type="text/css">
		<!-- datepicker 월 나타내는 selectbox안의 글자가 자꾸 밑으로 내려가는 현상때문에 스타일 줌. -->
		select {
			height: auto;
		}
		table td {
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		}
		</style>
		
		<script type="text/javascript">
		
			var strLang1 = "<spring:message code='ezSystem.x0030'/>";
			var strLang2 = "<spring:message code='ezSystem.x0031'/>";
			var strLang4 = "<spring:message code='ezSystem.x0034'/>";
			var strLang5 = "<spring:message code='ezSystem.x0035'/>";
			var strLang6 = "<spring:message code='ezSystem.x0036'/>";
			var strLang7 = "<spring:message code='main.t252'/>";
			var strLang8 = "<spring:message code='ezSystem.kyj2'/>";
			
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
			
			var startTime = "";
            var endTime = "";
			
			var companyID = "";
			
			// 화면 호출시 실행 함수
			window.onload = function(){
				document.getElementById("searchKeycodeForRoll").value = '';
				companyID = document.getElementById("ListCompany").value;
				getTime();
				getPermissionChHist(1, searchStartTime, searchEndTime);
				makePageSelPage();
			}
				
			// 검색값 입력 후 엔터키 입력 시 검색 호출
			function keyword_onkeydown(e) {
				
			    if (!window.ActiveXObject) {
			        var keyCode = e.keyCode;
			    } else {
			        var keyCode = event.keyCode;
			    }
			    
		        if (keyCode == 13) {
					search();
					return false;
				}
		        
				return true;
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
		    		buttonImage: "/images/ImgIcon/calendar-month.png",
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
		    		buttonImage: "/images/ImgIcon/calendar-month.png",
		    		buttonImageOnly: true,
		    		maxDate: 0,
		    		onSelect: function(selected) {
		    			compareDateEnd();
	    				std = $('#startDatepicker').val();
		    		}
		    	});    	
		    	
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
				document.getElementById("tblPageRayer").innerHTML = "";
				document.getElementById("listInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
				strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
				var pageNum = CurPage;

				if (totalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg first disabled'></span>"
					PagingHTML += strtext;
				}

				if (totalPage > BlockSize) {
					if (pageNum > BlockSize) {
						strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'>>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg prev disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg prev disabled'></span>";
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
								+ "<span class='btnimg next' onclick='return selafterBlock()'>-</span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext
								+ "<span class='btnimg next disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext
							+ "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
				}

				if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
					strtext = "<span class='btnimg last' onclick='return goToPageByNum("
							+ totalPage
							+ ")'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg last disabled'></span>";
					PagingHTML += strtext;
				}

				PagingHTML += "</div>";
				td_Create1(PagingHTML);
			}

			function goToPageByNum(Value) {
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

			// 2018-10-26 김민성 - 관리자 히스토리 새로고침 프로그래스 바 추가
			// 새로고침 클릭시 이벤트
			function reload() {
				ShowMailProgress();
				
				goToPage(CurPage);
				
				endTime = new Date();//프로그래스바 종료시간
				var timeDiff = endTime - startTime;
				timeDiff /= 1000;
				var seconds = (timeDiff % 60).toFixed(1);
				
				if (seconds <= 0.3) { //0.3초보다 적으면
					seconds = 300 - (timeDiff * 1000);
					setTimeout(function() {
						HiddenMailProgress();
					}, seconds);
				} else {
			        HiddenMailProgress();
				}

			}

			// 검색 버튼 클릭시 이벤트
			function search() {
				$(function() {

					if ($('#searchKeyword').val().trim() == "") {
						$('#searchKeyword').val('');
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

					searchStartTime = $('#startDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
					searchEndTime = $('#endDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
					getPermissionChHist(1, searchStartTime, searchEndTime);

				});
			}

			// 초기화버튼
			function reset() {
				$(function() {
					$('#searchKeyword').val('');
					getTime();
				});
			}

			// 페이지네이션 클릭시
			function goToPage(page) {
				getPermissionChHist(page, searchStartTime, searchEndTime);
			}

			function getPermissionChHist(pageNum, searchStartTime, searchEndTime) {

				var selectOption = document.getElementById("searchKeycode");
				var searchKeycode = selectOption.options[selectOption.selectedIndex].value;
				var searchKeyword = document.getElementById("searchKeyword").value;
				var selectOptionForRoll = document.getElementById("searchKeycodeForRoll");
				var searchKeycodeForRoll = selectOptionForRoll.options[selectOptionForRoll.selectedIndex].value;

				if (pageNum == "-1") {
					var pageSize = "-1";
					var params = 'startDate=' + searchStartTime	+ '&endDate=' + searchEndTime;
					params += '&searchKeycode=' + searchKeycode + '&searchKeyword=' + searchKeyword;
					params += '&searchKeycodeForRoll=' + searchKeycodeForRoll;
					params += '&pageNum=' + pageNum + '&pageSize='	+ pageSize + '&companyId='	+ companyID;
					var pURL = "/admin/ezSystem/permissionChHistExcelExport.do" + "?" + params;
					saveExcel.location.href = pURL;
				} else {
					var pURL = "/admin/ezSystem/permissionChangeHistList.do";

					$.ajax({
							url : pURL,
							type : "POST",
							async : false,
							dataType : 'json',
							data : {
								'startDate' : searchStartTime,
								'endDate' : searchEndTime,
								'searchKeycode' : searchKeycode,
								'searchKeyword' : searchKeyword,
								'searchKeycodeForRoll' : searchKeycodeForRoll,
								'pageNum' : pageNum,
								'companyId' : companyID
							},
							success : function(res) {
								var html = "";

								if (res.itemCnt < 1) {
									html += "<tr><td colspan=\"9\" style=\"text-align:center;\">" + strLang155 + "</td></tr>";
								} else {
									var j = ((pageNum - 1) * 20) + 1;

									if (res.lang == "primary") {
										
										res.permissionChHistList.forEach(function(i, v) {
											var type = adminTypeCheck(i.adminType);
											html += "<tr>";
											html += "   <td>"	+ j 										+ "</td>";
											html += "	<td title=\'" + i.userNm + "(" + i.userId			+ ")'>"	+ i.userNm 	+ "(" + i.userId + ")" + "</td>";
											html += "	<td>"	+ i.deptNm									+ "</td>";
											html += "	<td>"	+ i.companyNm								+ "</td>";
											html += "	<td>"	+ i.authorizedTime							+ "</td>";
											html += "	<td>"	+ type										+ "</td>";
											html += "	<td>"	+ (i.status == 'Y' ? '<spring:message code="ezOrgan.ls07"/>' : '<spring:message code="ezOrgan.ls08"/>')	+ "</td>";
											html += "	<td>"	+ i.authorizerNm + "(" + i.authorizerId		+ ")" + "</td>";
											html += "	<td>"	+ i.authorizerIp + " ( " + i.countryName	+ " ) " + "</td>";
											html += "</tr>";
											j++;
										});
										
									} else {
										
										res.permissionChHistList.forEach(function(i, v) {
											var type = adminTypeCheck(i.adminType);
											html += "<tr>";
											html += "   <td>"	+ j		+ "</td>";
											html += "	<td title=\'" + i.userNm2 + "(" + i.userId			+ ")'>"	+ i.userNm2 + "(" + i.userId + ")" + "</td>";
											html += "	<td>"	+ i.deptNm2									+ "</td>";
											html += "	<td>"	+ i.companyNm2								+ "</td>";
											html += "	<td>"	+ i.authorizedTime							+ "</td>";
											html += "	<td>"	+ type										+ "</td>";
											html += "	<td>"	+ (i.status == 'Y' ? '<spring:message code="ezOrgan.ls07"/>' : '<spring:message code="ezOrgan.ls08"/>')	+ "</td>";
											html += "	<td>"	+ i.authorizerNm2 + "(" + i.authorizerId	+ ")" + "</td>";
											html += "	<td>"	+ i.authorizerIp + " ( " + i.countryName	+ " ) " + "</td>";
											html += "</tr>";
											j++;
										});
									}
								}

								$('#permissionChangeHistListBody').empty().append(html);

								CurPage = res.currPage;
								totalPage = res.totalPage;
								totalCount = res.itemCnt;

								if (res.searchKeycode != null) {
									var idx = parseInt(searchKeycode);
									$('#searchKeycode option[value='+ idx + ']').attr('selected', 'selected');
								}

								// $('#searchKeyword').val(res.searchKeyword);
								$('#startDatepicker').val(res.startDate);
								$('#endDatepicker').val(res.endDate);
							},
							error : function(err) {
								alert(err);
							}
						});
				
					makePageSelPage();
				}	
			}
			
			function adminTypeCheck(adminType) {
				var adminTypeVal ='';
				switch (adminType.slice(0,2)) {
					case 'c=' 	: adminTypeVal = '<spring:message code="ezOrgan.t291"/>'; break; <!--전체관리자 -->
					case 'k=' 	: adminTypeVal = '<spring:message code="ezOrgan.t293"/>'; break; <!--회사관리자-->
					case 'g='	: adminTypeVal = '<spring:message code="ezOrgan.t295"/>'; break; <!--부서관리자-->
					case 'a=' 	: adminTypeVal = '<spring:message code="ezOrgan.t292"/>'; break; <!--수발신담당자-->
					case 'i=' 	: adminTypeVal = '<spring:message code="ezOrgan.t294"/>'; break; <!--심사자-->
					case 'n='	: adminTypeVal = '<spring:message code="ezOrgan.t297"/>'; break; <!--게시관리자-->
					case 'l=' 	: adminTypeVal = '<spring:message code="ezOrgan.t296"/>'; break; <!--설문관리자-->
					case 'w=' 	: adminTypeVal = '<spring:message code="ezOrgan.t301"/>'; break; <!--업무담당자-->
					case 'm='	: adminTypeVal = '<spring:message code="ezOrgan.t300"/>'; break; <!--기록물관리책임자-->
					case 'f='	: adminTypeVal = '<spring:message code="ezOrgan.lhj1"/>'; break; <!--결제조회관리자-->
					case 'wf'	: adminTypeVal = '<spring:message code="ezOrgan.t303"/>'; break; <!--웹폴더관리자-->
					case 'e='	: adminTypeVal = '<spring:message code="ezOrgan.kbm01"/>'; break; <!--근태관리자-->
					case 's='	: adminTypeVal = '<spring:message code="ezOrgan.t9904"/>'; break; <!--준법지원인-->
					case 'v='	: adminTypeVal = '<spring:message code="ezOrgan.lhr01"/>'; break; <!--일정관리자-->
				}
				return adminTypeVal;
			}
			
			// 엑셀내려받기 버튼 클릭시 이벤트 호출
			function excelExport() {
				var pageNum = "-1";
				getPermissionChHist(pageNum, searchStartTime, searchEndTime);
			}
			
			function selectCompanyID() {
				if (companyID != document.getElementById("ListCompany").value) {
		            companyID = document.getElementById("ListCompany").value
	
		            getPermissionChHist(1, searchStartTime, searchEndTime);
					makePageSelPage();
		        }
			}
			
	        // 페이지 위치 고정
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 192;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		    
		    $(function(){
	    		windowResize();
		    });
		    
			 // 프로그래스 바
		    function ShowMailProgress() {
	        	startTime = new Date(); // 프로그래스바 시작시간
				CurrenWidth = document.body.clientWidth;
	        	
			    document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = "400px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
		    
			function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezOrgan.ls06"></spring:message><span id="listInfo"></span></h1>
		<table style="width: 100%; background-color: #f8f8f8; border-top: 1px solid #e8e8e8; border-bottom: 1px solid #e8e8e8;">
			<tr>
				<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
					<span id="topmenu" style="width: 500px">&nbsp;<spring:message code='ezStatistics.t195'/> :
		            <select style="height:24px" id="ListCompany" name="SCompID" onchange="selectCompanyID()">
						<c:if test="${isMasterAdmin}">
							<option value="Top/organ"><spring:message code="ezPoll.t237"/></option>
		           		</c:if>
		           		<c:forEach var="item" items="${list}">
							<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		            	</c:forEach>
		            </select>&nbsp;
					<span id="topmenu" style="width: 500px"><spring:message code='ezSystem.x0032'/> : &nbsp; 
						<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
						<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" />
					</span> 
					&nbsp;&nbsp;
					<span id="topmenu" style="width: 500px">
						<spring:message code="ezSystem.ls08"></spring:message> : &nbsp;
						<select id="searchKeycodeForRoll"> 
							<option value=""><spring:message code="ezEmail.t588"></spring:message></option>
							<%--  회사관리자도 전체관리자 변경 이력을 검색할 수 있는 것을 표준으로 함, 전체관리자만 전체관리자 변경이력을 확인할 수있게 하려면 아래 주석 해제
							<c:if test="${isMasterAdmin}"> --%>
								<option value="c"><spring:message code="ezOrgan.t291"></spring:message></option>
							<%-- </c:if> --%>
							<option value="k"><spring:message code="ezOrgan.t293"></spring:message></option>
							<option value="g"><spring:message code="ezOrgan.t295"></spring:message></option>
							<c:if test="${packageType == 'standard'}">
								<option value="a"><spring:message code="ezOrgan.t292"></spring:message></option>
								<option value="i" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><spring:message code="ezOrgan.t294"></spring:message></option>
							</c:if>
							<c:if test="${packageType != 'mail' and useBoard}">
								<option value="n"><spring:message code="ezOrgan.t297"></spring:message></option>
							</c:if>
							<c:if test="${packageType == 'standard'}">
								<c:if test="${useSurvey}">
									<option value="l"><spring:message code="ezOrgan.t296"></spring:message></option>
								</c:if>
								<option value="w" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><spring:message code="ezOrgan.t301"></spring:message></option>
								<option value="m" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><spring:message code="ezOrgan.t300"></spring:message></option>
								<c:if test="${approvalForDoc}">
									<option value="q"><spring:message code="ezOrgan.lhj1"></spring:message></option>
								</c:if>
								<c:if test="${useWebfolder}">
									<option value="f"><spring:message code="ezOrgan.t303"></spring:message></option>
								</c:if>
									<option value="e"<c:if test="${!use_attitude}">style="display:none;"</c:if>><spring:message code="ezOrgan.kbm01"></spring:message></option>
									<option value="s"<c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><spring:message code="ezOrgan.t9904"></spring:message></option>
							</c:if>
							<!-- 2025.04.03 한슬기 : 일정관리자옵션 추가 -->
							<c:if test="${useSchedule}">
								<option value="v"><spring:message code="ezOrgan.lhr01"></spring:message></option>
							</c:if>
						</select>	&nbsp;
						<spring:message code="ezStatistics.t1062"></spring:message> : &nbsp;
						<select id="searchKeycode"> 
							<option value="1"><spring:message code="ezStatistics.t1068"></spring:message></option>
							<option value="2"><spring:message code="ezSystem.x0023"></spring:message></option>
							<%-- 표준에서는 이름/부서만 검색조건으로 제공 but id 조건이 필요할 경우 주석 해제
							<option value="6"><spring:message code="ezOrgan.t218"></spring:message></option>
							--%>
						</select>
							<input type="text" id="searchKeyword" style="width: 150px;" onKeyDown="return keyword_onkeydown(event)"/>
						<a class="imgbtn" >
							<span onclick="javascript:search();"><spring:message code="ezSystem.x0029"></spring:message></span>
						</a>
						<a class="imgbtn" >
							<span onclick="javascript:reset();"><spring:message code="ezSystem.x0033"></spring:message></span>
						</a>
						<a class="imgbtn" >
							<span onclick="javascript:reload();"><spring:message code="ezSystem.x0037"></spring:message></span>
						</a>
					</span> 
				</td>
				<td width="5%">
					<a class="imgbtn" style="margin-right: 5px">
						<span onclick="javascript:excelExport();"><spring:message code='ezStatistics.t1003'/></span>
					</a>
				</td>
			</tr>
		</table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" >&nbsp;</div>
	    <div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 400px; left: 726.5px; display: none;" id="MailProgress">
            <img src="/images/email/progress_img.gif" style="padding-top:20px;">
            <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
        </div>
			<br>
		<div id="contentlist" style="width:100%; overflow: auto;">	
			<table class="mainlist" style="width:100%;">
				<thead style="">
					<tr>
						<th width="80px;"><spring:message code="ezSystem.kyj1"></spring:message></th>
						<th><spring:message code="main.t76"></spring:message></th>
						<th><spring:message code="main.t75"></spring:message></th>
						<th><spring:message code="main.t74"></spring:message></th>
						<th><spring:message code="ezOrgan.ls01"></spring:message></th>
						<th><spring:message code="ezOrgan.ls02"></spring:message></th>
						<th><spring:message code="ezOrgan.ls03"></spring:message></th>
						<th><spring:message code="ezOrgan.ls04"></spring:message></th>
						<th><spring:message code="ezOrgan.ls05"></spring:message></th>
					</tr>
				</thead>
				<tbody id="permissionChangeHistListBody" style="overflow: auto;"></tbody> 
			</table>
		</div>
		<div id="tblPageRayer" style="padding-top: 10px;"></div>
		<iframe id="saveExcel" name="saveExcel" style="display:none"></iframe>
	</body>
</html>