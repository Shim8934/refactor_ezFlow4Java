<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='main.kyj1'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="<spring:message code='main.e15'/>" type="text/css">
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript">

	//**/ 페이징처리
	var strLang1 = "<spring:message code='main.kyj8'/>";
	var strLang2 = "<spring:message code='main.kyj9'/>";
	var startDate = "<c:out value = '${startDate}' />";
	var endDate = "<c:out value = '${endDate}' />";
	var keyword = "<c:out value = '${keyword}' />";
	var keycode = "<c:out value = '${keycode}' />";
	var CurPage = "<c:out value = '${currPage}' />";
	var totalPage = "<c:out value = '${totalPage}' />";
	var totalCount = "<c:out value = '${itemCnt}' />";
	var BlockSize = 10;
	
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
	
	
	function td_Create1(strtext) {
        document.getElementById("tblPageRayer").innerHTML = strtext;
    }
    
    function makePageSelPage() {
        var strtext;
        var PagingHTML = "";
        document.getElementById("tblPageRayer").innerHTML = "";
        strtext = "<div class='pagenavi'>";
        PagingHTML += strtext;
        var pageNum = CurPage;
        
        if (totalPage > 1 && pageNum != 1) {
            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
            PagingHTML += strtext;
        } else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
            PagingHTML += strtext;
        }
        
        if (totalPage > BlockSize) {
            if (pageNum > BlockSize) {
                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang1 + "</span>";
                PagingHTML += strtext;
            } else {
                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang1 + "</span>";
                PagingHTML += strtext;
            }
        } else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang1 + "</span>";
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
        
        if (totalPage > BlockSize) {
            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang2 + "</span>";
                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
                PagingHTML += strtext;
            } else {
                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang2 + "</span>";
                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
                PagingHTML += strtext;
            }
        } else {
            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang2 + "</span>";
            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        
        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        } else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
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
        
        if( parseInt(pageNum + 1) <= totalPage) {
            goToPageByNum(parseInt(pageNum + 1));
        } else {
            return;
        }
    }

	//**/ 검색 버튼 클릭시 이벤트
    function search() {
		$(function(){
			var startDate = $('#startDatepicker').datepicker({dateFormat: 'yyyy-mm-dd'}).val();
        	var endDate = $('#endDatepicker').datepicker({dateFormat:'yyyy-mm-dd'}).val();
			var selectOption = document.getElementById("searchKeycode");
			var searchKeycode = selectOption.options[selectOption.selectedIndex].value;
			var searchKeyword = document.getElementById("searchKeyword").value;
	    	var strSearch = "keycode=" +  searchKeycode + "&keyword=" + searchKeyword + "&startDate=" + startDate + "&endDate=" + endDate;
			var href = "/admin/ezSystem/systemLoginHist.do";

			window.location.href = href + "?" + encodeURI(strSearch) ;
		});
    }

    //**/ 페이지 전환
	function goToPage(page) {
		var href = "/admin/ezSystem/systemLoginHist.do";
		var strPage = "?keycode=" + keycode + "&keyword=" + keyword + "&startDate=" + startDate + "&endDate=" + endDate; ;

		if (parseInt(page) > 0 && parseInt(page) <= parseInt(totalPage)) {
 			document.location.href = href + strPage + "&GotoPage=" + encodeURIComponent(parseInt(page));
 		}
	}		
    
    //**/ 날짜 아이콘 적용 및 날짜 검색
    var holidaydate = "";
    var holidayid = "";
    
    $(function(){
    	$('#startDatepicker').datepicker({
    		changeMonth: true,
    		changeYear: true,
    		autoSize: true,
    		showOn: "both",
    		
    		buttonImage: "/images/ImgIcon/calendar-month.gif",
    		buttonImageOnly: true    	
    	});
    	$('#endDatepicker').datepicker({
    		changeMonth: true,
    		changeYear: true,
    		autoSize: true,
    		showOn: "both",
    		buttonImage: "/images/ImgIcon/calendar-month.gif",
    		buttonImageOnly: true    	
    	});    	    	
    });
    
    var monthMsg = "1월;2월;3월;4월;5월;6월;7월;8월;9월;10월;11월;12월";
    var monthStr = monthMsg.split(";");
    var dayMsg = "일;월;화;수;목;금;토";
    var dayStr = dayMsg.split(";");
   
    $(function(){
    	$.datepicker.regional["ko"] = {
    			closeText: "닫기",
    			prevText: "이전달",
    			nextText: "다음달",
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
    	$.datepicker.setDefaults($.datepicker.regional["ko"]);	
    });
    
</script>
</head>
<body class="mainbody" onload="makePageSelPage()">
	<h1><spring:message code="main.kyj1"></spring:message></h1>
	<table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2;">
		<tr>
			<td style="margin-bottom: 10px; padding: 5px 5px;">
				<span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1002'/> : &nbsp;
					<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
					<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" />
				</span> 
				&nbsp;&nbsp;
				<span id="topmenu" style="width: 500px"><spring:message code="main.kyj6"></spring:message> : &nbsp;
					<select id="searchKeycode" > 
						<option value="1"><spring:message code="main.t76"></spring:message></option>
						<option value="2"><spring:message code="main.t75"></spring:message></option>
						<option value="3"><spring:message code="main.kyj2"></spring:message></option>
						<option value="4"><spring:message code="main.kyj3"></spring:message></option>
						<option value="5"><spring:message code="main.kyj4"></spring:message></option>
						<option value="6"><spring:message code="main.kyj5"></spring:message></option>
					</select>
					<input type="text" style="width: 150px;" onKeyDown="return keyword_onkeydown(event)" id="searchKeyword"/>
					<a class="imgbtn" >
						<span onclick="javascript:search();"><spring:message code="main.kyj7"></spring:message></span>
					</a>
				</span> 
			</td>
		</tr>
	</table>
	<table class="mainlist" style="width:100%;">
		<thead>
			<tr>
				<th><spring:message code="main.t76"></spring:message></th>
				<th><spring:message code="main.t75"></spring:message></th>
				<th><spring:message code="main.kyj2"></spring:message></th>
				<th><spring:message code="main.kyj3"></spring:message></th>
				<th><spring:message code="main.kyj4"></spring:message></th>
				<th><spring:message code="main.kyj5"></spring:message></th>
			</tr>
		</thead>
		<tbody id="loginHistListBody">
			<c:forEach items="${loginHistList }" var="list">
				<tr>
					<c:if test="${ (userLang == 1) && (sysLang == 1) }">
						<td><c:out value="${list.usernm }"></c:out></td>		
						<td><c:out value="${list.deptnm }"></c:out></td>
					</c:if>
					<c:if test="${ (userLang != 1) || (sysLang != 1) }">
						<td><c:out value="${list.usernm2 }"></c:out></td>		
						<td><c:out value="${list.deptnm2 }"></c:out></td>	
					</c:if>
						<td><c:out value="${list.connectip }"></c:out></td>		
						<td><c:out value="${list.connecttime }"></c:out></td>		
						<td><c:out value="${list.connectbrowser }"></c:out></td>		
						<td><c:out value="${list.connectos }"></c:out></td>		
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div id="tblPageRayer" style="padding-top: 20px;"></div>
</body>
</html>