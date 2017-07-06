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
<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>

<script type="text/javascript">

	// 페이징처리
	var strLang1 = "<spring:message code='main.kyj8'/>";
	var strLang2 = "<spring:message code='main.kyj9'/>";

	var CurPage = "<c:out value = '${currPage}' />";
	var totalPage = "<c:out value = '${totalPage}' />";
	var BlockSize = 10;
	
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
		
	function goToPage(page) {
 		var href = "/admin/ezSystem/systemLoginHist.do" ;
 		if(parseInt(page) > 0 && parseInt(page) <= parseInt(totalPage)) {
 			document.location.href = href + "?GotoPage=" + encodeURIComponent(parseInt(page));
 		}
	}				
    // 페이징처리 완료
	
</script>
</head>
<body class="mainbody" onload="makePageSelPage()">
	<h1><spring:message code="main.kyj1"></spring:message></h1>
	<table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2;">
		<tr>
			<td style="margin-bottom: 10px; padding: 5px 5px;">
				<span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1002'/> : &nbsp;
					<input type="text" id="start_datepicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
					<input type="text" id="ended_datepicker" style="width: 100px; text-align: center" readonly="readonly" />
				</span> 
				&nbsp;&nbsp;
				<span id="topmenu" style="width: 500px"><spring:message code="main.kyj6"></spring:message> : &nbsp;
					<select> 
						<option><spring:message code="main.t76"></spring:message></option>
						<option><spring:message code="main.t75"></spring:message></option>
						<option><spring:message code="main.kyj2"></spring:message></option>
						<option><spring:message code="main.kyj3"></spring:message></option>
						<option><spring:message code="main.kyj4"></spring:message></option>
						<option><spring:message code="main.kyj5"></spring:message></option>
					</select>
					<input type="text" style="width: 150px;" />
					<a class="imgbtn" id="btnSearchLoginHist">
						<span><spring:message code="main.kyj7"></spring:message></span>
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