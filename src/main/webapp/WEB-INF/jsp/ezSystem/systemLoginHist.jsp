<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezSystem.x0021'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="<spring:message code='main.e15'/>" type="text/css">
<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
<script type="text/javascript">

	var strLang1 = "<spring:message code='ezSystem.x0030'/>";
	var strLang2 = "<spring:message code='ezSystem.x0031'/>";
	var strLang4 = "<spring:message code='ezSystem.x0034'/>";
	var strLang5 = "<spring:message code='ezSystem.x0035'/>";
	var strLang6 = "<spring:message code='ezSystem.x0036'/>";
	
	var CurPage = "";
	var totalPage = "";
	var totalCount = "";
	var BlockSize = 10;
	
	window.onload = function(){
		getLoginHist(1);
		makePageSelPage();
	}
		
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
    			$('#endDatepicker').datepicker("option", "minDate", selected)
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
    			$('#startDatepicker').datepicker("option", "maxDate", selected)
    		}
    	});    	    	
    });
    
    var monthMsg = "1월;2월;3월;4월;5월;6월;7월;8월;9월;10월;11월;12월";
    var monthStr = monthMsg.split(";");
    var dayMsg = "일;월;화;수;목;금;토";
    var dayStr = dayMsg.split(";");
   
    $(function() {
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
	
	//**/ 페이징처리
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

    //**/ 새로고침 클릭시 이벤트
    function reload() {
    	goToPage(CurPage);
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

			getLoginHist(1);
			
		});
    }
	
	//**/ 초기화버튼
	function reset() {
		$(function() {
 			$('#startDatepicker, #endDatepicker').datepicker('setDate', null);
			$('#searchKeyword').val('');
			$('#startDatepicker').val('');
			$('#endDatepicker').val('');
		});
	}
	
    //**/ 페이지네이션 클릭시
	function goToPage(page) {
		getLoginHist(page);
	}		

    function getLoginHist(pageNum){
    	$(function() {

    		var url = "/admin/ezSystem/systemLoginHistList.do";
			var startDate = $('#startDatepicker').datepicker({dateFormat: 'yyyy-mm-dd'}).val();
        	var endDate = $('#endDatepicker').datepicker({dateFormat:'yyyy-mm-dd'}).val();
			var selectOption = document.getElementById("searchKeycode");
			var searchKeycode = selectOption.options[selectOption.selectedIndex].value;
			var searchKeyword = document.getElementById("searchKeyword").value;
			
    		$.ajax({
    			 url: url
    			,type: "POST"
    			,async: false
    			,dataType: 'json'
    			,data: {  
    					  'startDate':startDate, 'endDate':endDate, 'searchKeycode':searchKeycode
    					  ,'searchKeyword':searchKeyword, 'GotoPage':pageNum 
    				   }    
    			,success: function(res) {
    				var html = "";
    				if (res.lang == 1) {
    					res.loginHistList.forEach(function(i,v){
    						html += "<tr>";
    						html += "	<td>" + i.usernm 			+ "</td>";
    						html += "	<td>" + i.deptnm 			+ "</td>";
    						html += "	<td>" + i.connectip 		+ "</td>";
    	    				html += "	<td>" + i.connecttime 		+ "</td>";
    	    				html += "	<td>" + i.connectbrowser 	+ "</td>";
    	    				html += "	<td>" + i.connectos 		+ "</td>";
    	    				html += "</tr>";
        				});
					} else {
						res.loginHistList.forEach(function(i,v){
							html += "<tr>";
							html += "	<td>" + i.usernm2 			+ "</td>";
							html += "	<td>" + i.deptnm2 			+ "</td>";
							html += "	<td>" + i.connectip 		+ "</td>";
		    				html += "	<td>" + i.connecttime 		+ "</td>";
		    				html += "	<td>" + i.connectbrowser 	+ "</td>";
		    				html += "	<td>" + i.connectos 		+ "</td>";
		    				html += "</tr>";
	    				});
					}
    				
    				$('#loginHistListBody').empty().append(html);
    				
    				CurPage = res.currPage;
    				totalPage = res.totalPage;
    				totalCount = res.itemCnt;
    				
    				if (res.searchKeycode != null) {
    					var idx = parseInt(searchKeycode) - 1;
	    				$('#searchKeycode option:eq('+idx+')').attr('selected','selected');
    				}
    				
    				$('#searchKeyword').val(res.searchKeyword);
    				$('#startDatepicker').val(res.startDate);
    				$('#endDatepicker').val(res.endDate);
    				
    			}
    			,error: function(err) {
    				alert(err);
    			}
    		})
    		makePageSelPage();
    	});
    }
    
</script>
</head>
<body class="mainbody">
	<h1><spring:message code="ezSystem.x0021"></spring:message></h1>
	<table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2;">
		<tr>
			<td style="margin-bottom: 10px; padding: 5px 5px;">
				<span id="topmenu" style="width: 500px"><spring:message code='ezSystem.x0032'/> : &nbsp;
					<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
					<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" />
				</span> 
				&nbsp;&nbsp;
				<span id="topmenu" style="width: 500px"><spring:message code="ezSystem.x0028"></spring:message> : &nbsp;
					<select id="searchKeycode"> 
						<option value="1"><spring:message code="ezSystem.x0022"></spring:message></option>
						<option value="2"><spring:message code="ezSystem.x0023"></spring:message></option>
						<option value="3"><spring:message code="ezSystem.x0024"></spring:message></option>
						<option value="4"><spring:message code="ezSystem.x0025"></spring:message></option>
						<option value="5"><spring:message code="ezSystem.x0026"></spring:message></option>
						<option value="6"><spring:message code="ezSystem.x0027"></spring:message></option>
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
		</tr>
	</table>
	<table class="mainlist" style="width:100%;">
		<thead>
			<tr>
				<th><spring:message code="ezSystem.x0022"></spring:message></th>
				<th><spring:message code="ezSystem.x0023"></spring:message></th>
				<th><spring:message code="ezSystem.x0024"></spring:message></th>
				<th><spring:message code="ezSystem.x0025"></spring:message></th>
				<th><spring:message code="ezSystem.x0026"></spring:message></th>
				<th><spring:message code="ezSystem.x0027"></spring:message></th>
			</tr>
		</thead>
		<tbody id="loginHistListBody"></tbody>
	</table>
	<div id="tblPageRayer" style="padding-top: 20px;"></div>
</body>
</html>