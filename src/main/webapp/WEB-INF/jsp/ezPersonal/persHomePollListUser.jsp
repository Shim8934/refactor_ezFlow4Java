<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t245' /></title>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3' />" type="text/css">
		<script type="text/javascript">
			var currentpage = "${currentPage}";
		    var totalpage = "${pageCount}";
		    var totalcount   = "${totalCount}";
		    var votepoll   = "${votePoll}";

		    window.onload = function(){
		        makePageSelPage();
		    }

			function pagemove() {
			    window.location.href = "/ezPersonal/homePollListUser.do?page=" + currentpage;
			}

			function open_poll(itemseq) {
			    if(votepoll != "" && votepoll == itemseq){
			        var pheight = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        var pTop = (pheight - 370) / 2;
			        var pLeft = (pwidth - 300) / 2;
			        window.open("/ezPersonal/wpLightPoll.do", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=370,width=300,top=" + pTop + ",left=" + pLeft, "");
			        return;
			    }
				if (itemseq == "0")
					return;

				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;

				var left = (width - 455) / 2;
				var top = (heigth - 400) / 2;
				window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
		    }	
			var BlockSize = 10;
			function td_Create1(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			} function makePageSelPage() {
				var strtext;
				var PagingHTML = "";
				document.getElementById("tblPageRayer").innerHTML = "";
				document.getElementById("mailBoxInfo").innerHTML = " - [" + "<spring:message code='ezPersonal.t10002' />" + "<span style='color:#017BEC;'> " + totalcount + " </span>" + "<spring:message code='ezPersonal.t223' />" + "]";
			    strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
				var totalPage = totalpage;
				var pageNum = currentpage;
				if (totalPage > 1 && pageNum != 1) {
				    strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
				    PagingHTML += strtext;
				} else {
				    strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
				    PagingHTML += strtext;
				}
				if (totalPage > BlockSize) {
				    if (pageNum > BlockSize) {
				        strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezPersonal.t10000' />" + "</span>";
				        PagingHTML += strtext;
				    } else {
				        strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezPersonal.t10000' />" + "</span>";
				        PagingHTML += strtext;
				    }
				} else {
				    strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + "<spring:message code='ezPersonal.t10000' />" + "</span>";
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
				        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezPersonal.t10001' />" + "</span>";
				        strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
				        PagingHTML += strtext;
				    } else {
				        strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezPersonal.t10001' />" + "</span>";
				        strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
				        PagingHTML += strtext;
				    }
				} else {
				    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + "<spring:message code='ezPersonal.t10001' />" + "</span>";
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
				currentpage = Value;
				makePageSelPage();
				pagemove();
			}
			function selbeforeBlock() {
				var pageNum = currentpage;
				pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			} function selbeforeBlock_one() {
				var pageNum = currentpage;
				var totalPage = totalpage;
				if (parseInt(pageNum - 1) > 0) {
					goToPageByNum(parseInt(pageNum - 1));
				} else {
					return;
				}
			}
			function selafterBlock() {
				var pageNum = currentpage;
				pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}
			function selafterBlock_one() {
				var pageNum = currentpage;
				var totalPage = totalpage;
				if (parseInt(pageNum + 1) <= totalPage) {
					goToPageByNum(parseInt(pageNum + 1));
				} else {
					return;
				}
			}
		</script>
	</head>
	<body class="popup"> 
		<form method="post" runat="server"> 
			<h1>Quick Poll<span id="mailBoxInfo"></span></h1>
			<div id="close"><ul><li><span onClick="window.close()"><spring:message code='ezPersonal.t10' /></span></li></ul></div>
  			<table> 
    			<tr> 
      				<td class="mainbody" style="padding:3px 10px;vertical-align:top;background:none">
        				<table class="mainlist" style="width:100%;"> 
          					<tr> 
            					<th style="width:40px;text-align:center"><spring:message code='ezPersonal.t166' /></th> 
            					<th style="width:460px"><spring:message code='ezPersonal.t240' /></th> 
            					<th style="width:100px"><spring:message code='ezPersonal.t241' /></th> 
            					<th style="width:100px"><spring:message code='ezPersonal.t242' /></th> 
          					</tr> 
           					
            				<c:if test="${isPollEmpty != true}">
            					<c:forEach var="item"  items="${list}" >
	            					<tr> 
                						<td style="text-align:center">${item.itemSeq}</td> 
                						<td style="white-space:nowrap;width:100%;overflow:hidden;text-overflow:ellipsis;cursor:pointer"  onClick="open_poll('${item.itemSeq}')"><span> ${item.pollTitle} </span></td> 
                						<td> ${item.startDate} </td> 
                						<td> ${item.endDate} </td> 
              						</tr> 	
            					</c:forEach>
            				</c:if>
        				</table>
        			</td> 
    			</tr> 
  			</table> 
			<br />
			<div id="tblPageRayer"></div>
		</form> 
	</body>
</html>