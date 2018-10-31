<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSystem.x0021'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
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
			
			var companyID = "";
			
			// 화면 호출시 실행 함수
			window.onload = function(){
				companyID = document.getElementById("ListCompany").value;
				getTime();
				getLoginHist(1, searchStartTime, searchEndTime);
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
				document.getElementById("listInfo").innerHTML = " &nbsp;["
						+ strLang7 + "<span style='color:#017BEC;'> "
						+ totalCount + " </span>" + strLang8 + "]";
				strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
				var pageNum = CurPage;

				if (totalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>"
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>"
					PagingHTML += strtext;
				}

				if (totalPage > BlockSize) {
					if (pageNum > BlockSize) {
						strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
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
								+ "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext
								+ "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
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
							+ ")'><img src='/images/sub/btn_n_next.gif' ></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
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

			// 새로고침 클릭시 이벤트
			function reload() {
				goToPage(CurPage);
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
					getLoginHist(1, searchStartTime, searchEndTime);

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
				getLoginHist(page, searchStartTime, searchEndTime);
			}

			function getLoginHist(pageNum, searchStartTime, searchEndTime) {

				var selectOption = document.getElementById("searchKeycode");
				var searchKeycode = selectOption.options[selectOption.selectedIndex].value;
				var searchKeyword = document.getElementById("searchKeyword").value;

				if (pageNum == "-1") {
					var pageSize = "-1";
					var params = 'startDate=' + searchStartTime	+ '&endDate=' + searchEndTime;
					params += '&searchKeycode=' + searchKeycode + '&searchKeyword=' + searchKeyword;
					params += '&pageNum=' + pageNum + '&pageSize='	+ pageSize + '&companyId='	+ companyID;
					var pURL = "/admin/ezSystem/systemLoginHistExcelExport.do" + "?" + params;
					saveExcel.location.href = pURL;
				} else {
					var pURL = "/admin/ezSystem/systemLoginHistList.do";

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
								'pageNum' : pageNum,
								'companyId' : companyID
							},
							success : function(res) {
								var html = "";

								if (res.itemCnt < 1) {
									html += "<tr><td colspan=\"7\" style=\"text-align:center;\">" + strLang155 + "</td></tr>";
								} else {
									var j = ((pageNum - 1) * 20) + 1;

									if (res.lang == "primary") {
										
										res.loginHistList.forEach(function(i, v) {
											html += "<tr>";
											html += "   <td>"	+ j 								+ "</td>";
											html += "	<td title=\'" + i.usernm + "'>"	+ i.usernm	+ "</td>";
											html += "	<td>"	+ i.deptnm							+ "</td>";
											html += "	<td>"	+ i.connectip						+ "</td>";
											html += "	<td>"	+ i.connecttime						+ "</td>";
											html += "	<td>"	+ i.connectbrowser					+ "</td>";
											html += "	<td>"	+ i.connectos						+ "</td>";
											html += "</tr>";
											j++;
										});
										
									} else {
										
										res.loginHistList.forEach(function(i, v) {
											html += "<tr>";
											html += "   <td>"	+ j		+ "</td>";
											html += "	<td title=\'" + i.usernm2 + "'>"  + i.usernm2 	+ "</td>";
											html += "	<td>"	+ i.deptnm2								+ "</td>";
											html += "	<td>"	+ i.connectip							+ "</td>";
											html += "	<td>"	+ i.connecttime							+ "</td>";
											html += "	<td>"	+ i.connectbrowser						+ "</td>";
											html += "	<td>"	+ i.connectos							+ "</td>";
											html += "</tr>";
											j++;
										});
										
									}
								}

								$('#loginHistListBody').empty().append(html);

								CurPage = res.currPage;
								totalPage = res.totalPage;
								totalCount = res.itemCnt;

								if (res.searchKeycode != null) {
									var idx = parseInt(searchKeycode) - 1;
									$('#searchKeycode option:eq('+ idx + ')').attr('selected', 'selected');
								}

								$('#searchKeyword').val(res.searchKeyword);
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

			// 엑셀내려받기 버튼 클릭시 이벤트 호출
			function excelExport() {
				var pageNum = "-1";
				getLoginHist(pageNum, searchStartTime, searchEndTime);
			}
			
			function selectCompanyID() {
				if (companyID != document.getElementById("ListCompany").value) {
		            companyID = document.getElementById("ListCompany").value
	
					getLoginHist(1, searchStartTime, searchEndTime);
					makePageSelPage();
		        }
			}
			
	        //2018-08-06 김보미 - 페이지 위치 고정
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
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezSystem.x0021"></spring:message><span id="listInfo"></span></h1>
		<div id="" style="display:none"> <!-- mainmenu -->
		    <span><b><spring:message code = 'ezApprovalG.t1512' /></b> 
			    <select id="ListCompany" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
			    </select><br /><br />
		    </span>
		</div>
		<table style="width: 100%; background-color: #f8f8f8; border-top: 1px solid #e8e8e8; border-bottom: 1px solid #e8e8e8;">
			<tr>
				<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
					<span id="topmenu" style="width: 500px"><spring:message code='ezSystem.x0032'/> : &nbsp; 
						<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
						<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" />
					</span> 
					&nbsp;&nbsp;
					<span id="topmenu" style="width: 500px"><spring:message code="ezStatistics.t1062"></spring:message> : &nbsp; 
						<select id="searchKeycode"> 
						<option value="1"><spring:message code="ezStatistics.t1068"></spring:message></option>
						<option value="2"><spring:message code="ezSystem.x0023"></spring:message></option>
						<option value="3"><spring:message code="ezSystem.x0024"></spring:message></option>
						<option value="4"><spring:message code="ezSystem.x0026"></spring:message></option>
						<option value="5"><spring:message code="ezSystem.x0027"></spring:message></option>
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
					<a class="imgbtn">
						<span onclick="javascript:excelExport();"><spring:message code='ezStatistics.t1003'/></span>
					</a>
				</td>
			</tr>
		</table>
		<table style="margin: 10px 0px;">
			<tr>
				<td width="98%" style="color: #333;">▒ ${mailLogKeepPeriodMessage}</td>
			</tr>
		</table>
		<div id="contentlist" style="width:100%; overflow: auto;">	
			<table class="mainlist" style="width:100%;">
				<thead style="">
					<tr>
						<th width="80px;"><spring:message code="ezSystem.kyj1"></spring:message></th>
						<th><spring:message code="ezStatistics.t1068"></spring:message></th>
						<th><spring:message code="ezStatistics.t113"></spring:message></th>
						<th><spring:message code="ezSystem.x0024"></spring:message></th>
						<th><spring:message code="ezSystem.x0025"></spring:message></th>
						<th><spring:message code="ezSystem.x0026"></spring:message></th>
						<th><spring:message code="ezSystem.x0027"></spring:message></th>
					</tr>
				</thead>
				<tbody id="loginHistListBody" style="overflow: auto;"></tbody> 
			</table>
		</div>
		<div id="tblPageRayer" style="padding-top: 10px;"></div>
		<iframe id=saveExcel name=saveExcel style="display:none"></iframe>
	</body>
</html>
