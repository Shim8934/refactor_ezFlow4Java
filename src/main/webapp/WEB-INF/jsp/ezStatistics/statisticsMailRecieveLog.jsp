<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><spring:message code='ezStatistics.t1050'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script type="text/javascript">

	var strLang1 = "<spring:message code='ezStatistics.t1063'/>";
	var strLang2 = "<spring:message code='ezStatistics.t1064'/>";
	var strLang3 = "KB";
	var strLang7 = "<spring:message code='main.t252'/>";
	var strLang8 = "<spring:message code='ezSystem.kyj2'/>";
	var currPage = "";
	var totalPage = "";
	var totalCount = "";
	var BlockSize = 10;
	var searchStartTime = "";
	var searchEndTime = "";
	
	//**/ 화면 호출시 실행 함수
	window.onload = function() {
		getTime();
		getMailLogList(1, searchStartTime, searchEndTime);
		makePageSelPage();
		windowResize();
	}

	//**/ 검색값 입력 후 엔터키 입력 시 검색 호출
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

	//**/ 날짜 아이콘 적용 및 날짜 검색
	function getTime() {
		
		var dateObj = new Date();
		var year = dateObj.getFullYear();
		var month = dateObj.getMonth() + 1;
		var date = dateObj.getDate();
		
		if (date<10) {
			date = '0' + date;
		}
		if (month<10) {
			month = '0' + month;
		}
		
		dateObj = year +"-"+ month +"-" + date;
		searchStartTime = dateObj;
    	searchEndTime = dateObj;
    	
    	$('#startDatepicker').val(dateObj);
		$('#endDatepicker').val(dateObj);
		
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
				$('#endDatepicker').datepicker("option", "minDate", selected);
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
				$('#startDatepicker').datepicker("option", "maxDate", selected)
			}
		});    	    	
	});
	
	
	var dayMsg = "<spring:message code='main.kyj1'/>";
	var dayStr = dayMsg.split(";");
	var monthMsg = "<spring:message code='main.kyj2'/>";
	var monthStr = monthMsg.split(";");
	
	$(function() {
		$.datepicker.regional["<spring:message code='main.t0619'/>"] = {
				closeText: "<spring:message code='main.t3'/>",
				prevText: "<spring:message code='main.t0604'/>",
				nextText: "<spring:message code='main.t0605'/>",
				currentText: "<spring:message code='main.t0606' />",
				monthNames: monthStr,
				monthNamesShort: monthStr,
				dayNames: dayStr,
				dayNamesShort: dayStr,
				dayNamesMin: dayStr,
				weekHeader: 'Wk',
				dateFormat: 'yy-mm-dd',
	   			firstDay:0,
				isRTL: false,
				duration: 200,
				showAnim: 'show',
				showMonthAfterYear: true
		};
		
		$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]);	
			
	});

	//**/ 페이징처리
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
        var pageNum = currPage;
        
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
                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
                PagingHTML += strtext;
            }
        }
        
        if (MaxNum == 0) {
        	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
        }
        
        if (totalPage > BlockSize) {
            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
                strtext = "";
                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
                PagingHTML += strtext;
            } else {
                strtext = "";
                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
                PagingHTML += strtext;
            }
        } else {
            strtext = "";
            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
            PagingHTML += strtext;
        }
        
        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
            PagingHTML += strtext;
        } else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
            PagingHTML += strtext;
        }
        
        PagingHTML += "</div>";
        td_Create1(PagingHTML);
    }
    
    function goToPageByNum(Value) {
        currPage = Value;
        makePageSelPage();
		goToPage(currPage);
    }
    
    function selbeforeBlock() {
        var pageNum = parseInt(currPage);
        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
        goToPageByNum(pageNum);    
    }
    
    function selbeforeBlock_one() {
        var pageNum = parseInt(currPage);
        
        if (parseInt(pageNum - 1) > 0) {
            goToPageByNum(parseInt(pageNum - 1));
        } else {
            return;
        }
    }
    
    function selafterBlock() {
        var pageNum = parseInt(currPage);
        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
        goToPageByNum(pageNum);
    }
    
    function selafterBlock_one() {
        var pageNum = parseInt(currPage);
        
        if( parseInt(pageNum + 1) <= totalPage) {
            goToPageByNum(parseInt(pageNum + 1));
        } else {
            return;
        }
    }
    

    //**/ 새로고침 클릭시 이벤트
    function reload() {
    	goToPage(currPage);
    }
    
	//**/ 검색 버튼 클릭시 이벤트
    function search() {
		$(function() {
			
			if ($('#startDatepicker').val() != '' && $('#endDatepicker').val() == '') {
				alert(strLang5);
				return false;
			} 
			if ($('#startDatepicker').val() == '' && $('#endDatepicker').val() != '') {
				alert(strLang6);
				return false;
			} 
			
			searchStartTime = $('#startDatepicker').datepicker({dateFormat: 'yyyymmdd'}).val();
        	searchEndTime = $('#endDatepicker').datepicker({dateFormat:'yyyymmdd'}).val();
			
			getMailLogList(1, searchStartTime, searchEndTime);
			
		});
    }
	
	//**/ 초기화버튼
	function reset() {
		$(function() {
			$('#searchValue').val('');
			getTime();
		});
	}

	//**/ 페이지네이션 클릭시
	function goToPage(pageNo) {
		getMailLogList(pageNo, searchStartTime, searchEndTime);
	}		

	//**/ 메일 수신 로그내역 리스트 호출
    function getMailLogList(pageNo, searchStartTime, searchEndTime ){
    	$(function() {

    		var url = "/ezStatistics/statisticsMailLogList.do";
			var mailLogType = "receiveAll";
			var selectOption = document.getElementById("searchField");
			var searchValue = document.getElementById("searchValue").value;
			var searchField = "";

			if (searchValue != "") {
				searchField = selectOption.options[selectOption.selectedIndex].value;
			}
			
			if (pageNo == "-1") {
				var pageSize = "-1"; // 전체
				var params = 'searchStartTime=' + searchStartTime +'&searchEndTime=' + searchEndTime;
				 	params += '&searchField=' + searchField + '&searchValue=' + searchValue ; 
					params += '&pageNo=' + pageNo + '&mailLogType=' + mailLogType + '&pageSize=' + pageSize;
				var pURL = "/ezStatistics/statisticsMailLogExcelExport.do" + "?" + params;

				saveExcel.location.href = pURL;
			
			} else {
			
	    		$.ajax({
	    			 url: url
	    			,type: "POST"
	    			,async: false
	    			,dataType: 'json'
	    			,data: {  
	    					  'searchStartTime' : searchStartTime, 'searchEndTime' : searchEndTime, 'searchField' : searchField
	    					  ,'searchValue' : searchValue, 'pageNo' : pageNo, 'mailLogType' : mailLogType
	    				   }    
	    			,success: function(res) {
	    				var html = "";
	   					res.mailLogList.forEach(function(i,v){
	   	    				var attStr = i.attachedFileName;
	   	    				var attStrArr = attStr.split('|');
	   	    				
	   						html += "<tr>";
	   						html += "	<td>" + i.LogTime 									    + "</td>";
	   	    				html += "	<td>" + i.recipientDeptName 						    + "</td>";
	   						html += "	<td>" + i.recipientName + " (" + i.recipientEmail + ")" + "</td>";
	   	    				
	   	    				if (i.senderName == "") {
		   	    				html += "	<td>" +  i.senderEmail 								+ "</td>";
	   	    				} else {
		   	    				html += "	<td>" + i.senderName + " (" + i.senderEmail + ")" 	+ "</td>";
	   	    				}
	   	    				
	   	    				html += "	<td style='width:100%;overflow:hidden;text-overflow:ellipsis;' title='"+i.subject+"'>";
	   	    				html += "		<nobr>" + i.subject + "</nobr>";
	   	    				html += "   </td>";
	   	    				
	   	    				if (attStrArr.length > 1) {
								html += "<td title='";
								
								for ( var j = 1; j < attStrArr.length; j++ ) {
									html += attStrArr[j]; 
									var next = j + 1;
								
									if (attStrArr.length > next) {
										html += "&#10;"; //&#13;
									}
								}	
								
								var num = parseInt(attStrArr.length) - 1 ;
								
								html += "'>" + attStrArr[0] +" <spring:message code='ezStatistics.t1066'/>"	;
								html += num + "<spring:message code='ezStatistics.t1067'/>" + "</td>";	
								
	   	    				} else {
	   	    					html += " 	<td>" + attStrArr[0] 							+ "</td>";
	   	    				}
	   	    				
	   	    				html += "		<td>" + i.mailSize + strLang3 					+ "</td>";
	   	    				html += "</tr>";
	       				});
	    				
	    				$('#mailLogListBody').empty().append(html);
	    				
	    				currPage = res.currentPage;
	    				totalPage = res.totalPage;
	    				totalCount = res.totalCount;
	    				
	    				if (res.searchValue != "") {
		    				$('#searchField').val(res.searchField).prop("selected", true);
	    				} else {
	    					$('#searchField option:eq('+ 0 +')').attr('selected', "selected");
	    				}
	    				
	    				$('#searchValue').val(res.searchValue);
	    				$('#startDatepicker').val(res.startDate);
	    				$('#endDatepicker').val(res.endDate);
	    			}
	    			,error: function(err) {
	    				alert(err);
	    			}
	    		})
	    		makePageSelPage();
			}
    	});
    }

  	//**/ 엑셀내려받기 버튼 클릭시 이벤트 호출
    function excelExport() {
		var pageNo = "-1";
    	getMailLogList(pageNo, searchStartTime, searchEndTime);
    }

    $(window).on("resize", function(){
        windowResize();
    });
    
    function windowResize() {
    	var height = document.documentElement.clientHeight - 177 - document.getElementById("mainmenu").clientHeight;
    	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
    		height = height - 30;
    	}
    	document.getElementById("contentlist").style.height = height + "px";
    	document.getElementById("contentlist").style.overflow = "auto";
    }
</script>
</head>
<body class="mainbody">
<h1><spring:message code="ezStatistics.kyj1"/><span id="listInfo"></span></h1>
	<table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2;">
		<tr>
			<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
				<span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1061'/> : &nbsp;
					<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
					<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" />
				</span> 
				&nbsp;&nbsp;
				<span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1062'/>: &nbsp;
					<select id="searchField" style="height:24px"> 
						<option value="recipientName"><spring:message code='ezStatistics.kyj6'/></option>
						<option value="recipientDeptName"><spring:message code='ezStatistics.t83'/></option>
						<option value="recipientEmail"><spring:message code='ezStatistics.kyj7'/></option>
						<option value="senderName"><spring:message code='ezStatistics.kyj3'/></option>
						<option value="senderEmail"><spring:message code='ezStatistics.kyj4'/></option>
						<option value="subject"><spring:message code='ezStatistics.t1056'/></option>
						<option value="attachedFileName"><spring:message code='ezStatistics.t1057'/></option>
					</select>
					<input type="text" id="searchValue" style="width: 150px;" onKeyDown="return keyword_onkeydown(event)"/>
					<a class="imgbtn" style="height:22px">
						<span onclick="javascript:search();"><spring:message code='ezStatistics.t36'/></span>
					</a>
					<a class="imgbtn" style="height:22px">
						<span onclick="javascript:reset();"><spring:message code='ezStatistics.t1059'/></span>
					</a>
					<a class="imgbtn" style="height:22px">
						<span onclick="javascript:reload();"><spring:message code='ezStatistics.t1060'/></span>
					</a>
				</span> 
			</td>
			<td width="5%">
				<div id="mainmenu" style="height: 28px;margin:3px 0px !important">
                    <ul>
						<li><span style="width: 110px;text-align:center;background-color: white" onclick="javascript:excelExport();"><spring:message code='ezStatistics.t1003'/></span></li>
					</ul>
				</div>	
			</td>
		</tr>
	</table>
	<table style="margin: 10px 0px;">
		<tr>
			<td width="98%" style="font-weight: bold; color: gray;">▒ ${mailLogKeepPeriodMessage}</td>
		</tr>
	</table>
	
	<div id="contentlist" style="width: 100%; overflow: auto;">
		<table class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th width='12%'><spring:message code='ezStatistics.kyj10'/></th>
					<th width='8%'><spring:message code='ezStatistics.t83'/></th>
					<th width='15%'><spring:message code='ezStatistics.t1054'/> (<spring:message code='ezStatistics.t1055'/>)</th>
					<th width='15%'><spring:message code='ezStatistics.t1053'/> (<spring:message code='ezStatistics.t1055'/>)</th>
					<th width='17%'><spring:message code='ezStatistics.t1056'/></th>
					<th width='15%'><spring:message code='ezStatistics.t1057'/></th>
					<th width='5%'><spring:message code='ezStatistics.t1058'/></th>
				</tr>
			</thead>
			<tbody id="mailLogListBody"></tbody>
		</table>
	</div>
	<div id="tblPageRayer" style="padding-top: 20px;"></div>
	<iframe id=saveExcel name=saveExcel style="display:none"></iframe>
</body>
</html>