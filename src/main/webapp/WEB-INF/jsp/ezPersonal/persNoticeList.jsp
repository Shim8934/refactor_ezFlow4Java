<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t170' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var page = "${currentPage}";
			var pagecount = "${pageCount}";

			function pagemove(direction) {
				if (direction == 0)
				{
					if (event.keyCode == 13)
					{
						var newpage = document.all["SearchPage"].value;
						if (parseInt(newpage) == newpage)
						{
							newpage = parseInt(newpage);
							if (newpage > 0 && newpage <= pagecount)
								window.setTimeout("window.location.href = 'NoticeList.aspx?page=" + newpage + "'", 1);
						}
					}
				}
				else
				{
					var newpage = page + direction;
					if (newpage > 0 && newpage <= pagecount)
						window.location.href = "NoticeList.aspx?page=" + newpage;
				}
				
				return false;
			}
	
			function open_notice(itemseq) {
				if (itemseq == "0")
					return;
	
				window.open("/ezPersonal/showNotice.do?itemSeq=" + itemseq, "", "height=570px,width=570px, status = no, toolbar=no, menubar=no,location=no, resizable=1"+GetOpenPosition(570, 570));
			}	
	        
			var TotalCount = "${totalCount}";
			var PageSize = "15";
			var totalPage = "";
			var pTotalCnt = "";
			var BlockSize = "15";
			var pageNum = "${currentPage}";
	        
			window.onload = function () {
			    totalPage = Math.ceil(new Number(TotalCount / PageSize));
			    makePageSelPage();
			}
	
	
			function td_Create1(strtext) {
			    document.getElementById("tblPageRayer").innerHTML = strtext;
			}
			
			function makePageSelPage() {
			    var strtext;
			    var PagingHTML = "";
			    document.getElementById("tblPageRayer").innerHTML = "";
			    document.getElementById("mailBoxInfo").innerHTML = " &nbsp;[" + "<spring:message code='ezPersonal.t999900032'/>" + "<span style='color:#017BEC;'> " + TotalCount + " </span>" + "ezPersonal.t999900033" + "]";
			    strtext = "<div class='pagenavi'>";
			    PagingHTML += strtext;
			    if (totalPage > 1 && pageNum != 1) {
			        strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
			        PagingHTML += strtext;
			    }
			    if (totalPage > BlockSize) {
			        if (pageNum > BlockSize) {
			            strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezApproval.t931'/>" + "</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezApproval.t931'/>" + "</span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezApproval.t931'/>" + "</span>";
			        PagingHTML += strtext;
			    }
			    var MaxNum;
			    var i;
			    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
			    if (totalPage >= (startNum + parseInt(BlockSize))) {
			        MaxNum = (startNum + parseInt(BlockSize)) - 1;
			    }
			    else {
			        MaxNum = totalPage;
			    }
			    for (i = startNum; i <= MaxNum; i++) {
			        if (i == pageNum) {
			            strtext = "<span class='on'>" + i + "</span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
			            PagingHTML += strtext;
			        }
			    }
			    if (totalPage > BlockSize) {
			        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezApproval.t932'/>" + "</span>";
			            strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			        else {
			            strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezApproval.t932'/>" + "</span>";
			            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			            PagingHTML += strtext;
			        }
			    }
			    else {
			        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezApproval.t932'/>" + "</span>";
			        strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
			        strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    else {
			        strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
			        PagingHTML += strtext;
			    }
			    PagingHTML += "</div>";
			    td_Create1(PagingHTML);
			}
			function goToPageByNum(Value) {
			    pageNum = Value;
			    makePageSelPage();
	
			    window.location.href = "NoticeList.aspx?page=" + pageNum;
			}
			function selbeforeBlock() {
			    pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
			function selbeforeBlock_one() {
			    if (parseInt(pageNum - 1) > 0)
			        goToPageByNum(parseInt(pageNum - 1));
			    else
			        return;
			}
			function selafterBlock() {
			    pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
			    goToPageByNum(pageNum);
			}
			function selafterBlock_one() {
			    if (parseInt(pageNum + 1) <= totalPage)
			        goToPageByNum(parseInt(pageNum + 1));
			    else
			        return;
			}
			function selNum(pselNum) {
			    pageNum = pselNum;
	
			    window.location.href = "/ezPersonal/noticeList.do?page=" + pageNum;
			}
			function selNext() {
			    pageNum = pageNum + 1;
	
			    window.location.href = "ezPersonal/noticeList.do?page=" + pageNum;
			}
			function selPrev() {
			    pageNum = pageNum - 1;
	
			    window.location.href = "ezPersonal/noticeList.do?page=" + pageNum;
			}
			function td_Create(strtext) {
			    tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
			}
		</script>
	</head>
	<body class="mainbody" style="margin:0">
		<form method="post">
  			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
    			<tr>
      				<td valign="top" style="padding-left:10px">
      					<h1><spring:message code='ezPersonal.t157'/><span id="mailBoxInfo"></span></h1>
			        	<br>
        				<table border="0" cellspacing="0" cellpadding="0" class="mwidth">
          					<tr>
            					<td  class="line"></td>
          					</tr>
          					<tr>
            					<td height="1" bgcolor="#FFFFFF"></td>
          					</tr>
        				</table>
        				<table class="mainlist" style="width:100%;">
          					<tr>
            					<th><spring:message code='ezPersonal.t167'/></th>
            					<th width="80"><spring:message code='ezPersonal.t168'/></th>
          					</tr>
          
          					<c:forEach var="item" items="${list}" varStatus="status">
          						<tr>
          							<td  wrap><span style="cursor:pointer" onClick="open_notice('${item.itemSeq}')">&nbsp; ${item.title} </span></td>
          							<td width="80">${fn:substring(item.postDate, 0, 10)}</td>
          						</tr>
          					</c:forEach>
        				</table>
          				<div id="tblPageRayer" style="text-align:center"></div>
      				</td>
    			</tr>
  			</table>
		</form>
	</body>
</html>