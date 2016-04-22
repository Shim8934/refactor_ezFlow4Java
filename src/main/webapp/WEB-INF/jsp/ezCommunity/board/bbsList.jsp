<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>bbs_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<style> 
	        .pagetd{padding-top:6px; }
	        .pcol{padding-top:6px; }
	        .Right_Point01 {
		        font:bold;
		        color:#017bec;
	        }
        </style>
        
		<script type="text/javascript">
			var pKeyWord = "<c:out value='${keyword}'/>";
	        var curPage = "<c:out value='${curPage}'/>";
		    var totalPage = "<c:out value='${totalPage}'/>";
		    var totalCount = "<c:out value='${keywordCount}'/>";
			function keyword_onkeydown(e) 
			{
				alert(window.ActiveXObject);
			    if (!window.ActiveXObject) {
			        var keyCode = e.keyCode;
			    }

	            if (keyCode == 13) {
					search();
					return false;
				}
				return true;
			}
			
			function refresh_onclick() {
				window.location.reload(false);
			}
		</script>
		
		<script type="text/javascript">
			<%-- document.onselectstart = function () { return false; };

		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
		    
			function search() {
				if (document.page.s_radio.value == "title" ) {
					var strSearch = "s_radio=title&keyword=" + document.page.keyword.value;
				} else if (document.page.s_radio.value == "titleContent" ) {
					var strSearch = "s_radio=titleContent&keyword=" + document.page.keyword.value;
				} else {
					var strSearch = "s_radio=writer&keyword=" + document.page.keyword.value;
				}
				
				strSearch = strSearch + "&code=" + "<%=code%>" + "&bname=" + "<%=bname%>" + "&key=" + document.page.keyword.value;
				window.location.href = "bbs_list.aspx" + "?" + encodeURI(strSearch);
			}

			function comm_searchCheck() {
				if ( document.page.keyword.value.length < 2 || document.page.keyword.value.indexOf("%") != -1) {
					OpenAlertUI("<%=RM.GetString("t164")%>");
					
					return false;
				}
				return true;
			}
			
	         var BlockSize = 10;
	         function td_Create1(strtext) {
	             document.getElementById("tblPageRayer").innerHTML = strtext;
	         }
	         function makePageSelPage() {
	             var strtext;
	             var PagingHTML = "";
	             document.getElementById("tblPageRayer").innerHTML = "";
	             document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang82 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang83 + "]";
	             strtext = "<div class='pagenavi'>";
	             PagingHTML += strtext;
	             var pageNum = curPage;
	             if (totalPage > 1 && pageNum != 1) {
	                 strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/Sub/btn_p_prev.gif' width='16' height='16'></span>"
	                 PagingHTML += strtext;
	             }
	             else {
	                 strtext = "<span class='btnimg'><img src='/images/Sub/btn_p_prev01.gif' width='16' height='16'></span>"
	                 PagingHTML += strtext;
	             }
	             if (totalPage > BlockSize) {
	                 if (pageNum > BlockSize) {
	                     strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/Sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                     PagingHTML += strtext;
	                 }
	                 else {
	                     strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                     PagingHTML += strtext;
	                 }
	             }
	             else {
	                 strtext = "<span class='btnimg'><img src='/images/Sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
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
	                     strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                     strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/Sub/btn_next.gif' width='16' height='16'></span>";
	                     PagingHTML += strtext;
	                 }
	                 else {
	                     strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                     strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
	                     PagingHTML += strtext;
	                 }
	             }
	             else {
	                 strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                 strtext = strtext + "<span class='btnimg'><img src='/images/Sub/btn_next01.gif' width='16' height='16'></span>";
	                 PagingHTML += strtext;
	             }
	             if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                 strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/Sub/btn_n_next.gif' width='16' height='16'></span>";
	                 PagingHTML += strtext;
	             }
	             else {
	                 strtext = "<span class='btnimg'><img src='/images/Sub/btn_n_next01.gif' width='16' height='16'></span>";
	                 PagingHTML += strtext;
	             }
	             PagingHTML += "</div>";
	             td_Create1(PagingHTML);
	         }
	         
	         function goToPageByNum(Value) {
	             curPage = Value;
	             makePageSelPage();
					goToPage(curPage);
	         }
	         
	         function selbeforeBlock() {
	             var pageNum = parseInt(curPage);
	             pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	             goToPageByNum(pageNum);    
	         }
	         
	         function selbeforeBlock_one() {
	             var pageNum = parseInt(curPage);
	             if (parseInt(pageNum - 1) > 0)
	                 goToPageByNum(parseInt(pageNum - 1));
	             else
	                 return;
	         }
	         
	         function selafterBlock() {
	             var pageNum = parseInt(curPage);
	             pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	             goToPageByNum(pageNum);
	         }
	         
	         function selafterBlock_one() {
	             var pageNum = parseInt(curPage);
	             if( parseInt(pageNum + 1) <= totalPage)
	                 goToPageByNum(parseInt(pageNum + 1));
	             else
	                 return;
	         }
				
			function goToPage(page) {
				var href = "bbs_list.aspx?bname=<%=bname%>&code="+ escape("<%=code%>") + "&keyword=" + pKeyWord + "&s_radio=" + escape("<%=s_radio%>") + "&block="+escape("<%=nowblock%>");
				if(parseInt(page) > 0 && parseInt(page) <= parseInt(totalPage))  {
					document.location.href = href + "&GotoPage=" + escape(parseInt(page));
				}	
			}				
			
			function btn_bbsView(sURL, ttt) {
			    var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 200;
	            pwidth = pwidth - 127;
	            
	            var feature = "width=760,height=720";
	            feature = feature + GetOpenPosition(760, 720);
	            window.open("bbs_view_new.aspx?mode=content&no=" + sURL + "&bname=" + ttt, "<%=RM.GetString("t166")%>", feature);						        
				
			}
			
			function btn_write(bname) {
			    var feature = "width=760,height=720";
			    feature = feature + GetOpenPosition(760, 720);
	            
			    if (CrossYN() || pNoneActiveX == "YES") {
			        window.open("bbs_edit_new_Cross.aspx?mode=write&bname=" + bname, "<%=RM.GetString("t166")%>", feature);
			    } else {
			        if (pUse_Editor == "" || pUse_Editor == "CK") {
			            window.open("bbs_edit_new.aspx?mode=write&bname=" + bname, "<%=RM.GetString("t166")%>", feature);
			        } else {
			            window.open("bbs_edit_new_IE.aspx?mode=write&bname=" + bname, "<%=RM.GetString("t166")%>", feature);
			        }
			    }
	            
			}
			
			function btn_list(bname) {
				url = "bbs_list.aspx?bname=<%=bname%>"
				location.href = url;
			}			 --%>
		</script>
	</head>
	<body class="mainbody" onload="makePageSelPage()">
		<%-- <%		switch(bname) { %>
				<%			case "c_notice" :  %>		
                                            <h1><%=RM.GetString("t73")%><span id="mailBoxInfo"></span></h1>
				<%				            break; 
			                case "c_board" :   %>
                                            <h1><%=RM.GetString("t2001")%><span id="mailBoxInfo"></span></h1>
				<%				            break; 
			                default :  %>			
                                            <h1><%=titleName%><span id="mailBoxInfo"></span></h1>
				<%				            break;  } %> --%>
		<c:choose>
			<c:when test="${bname == 'c_notice'}">
				<h1><spring:message code = "ezCommunity.t73"/><span id="mailBoxInfo"></span></h1>
			</c:when>
		</c:choose>
				
		<div id="mainmenu">
			<ul>
<%-- 			    <%if (bname == "c_board") {  %> --%>
<%-- 						<li><span onClick="btn_write('<%=bname%>')"><%=RM.GetString("t167")%></span></li> --%>
<%-- 				<%   }else if ( (userinfo.RollInfo.IndexOf("k=1") > -1 || userinfo.RollInfo.IndexOf("t=1") > -1 ) && bname == "c_notice") {   %> --%>
<%-- 						<li><span onClick="btn_write('<%=bname%>')"><%=RM.GetString("t167")%></span></li> --%>
<%-- 				<%	}%> --%>
<%-- 				<%if (keyword != "" ) {  %> --%>
<%-- 				<li><span onclick="btn_list('<%=bname%>')"><%=RM.GetString("t168")%></span></li> --%>
<%-- 				<%	}%> --%>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<%-- <table class="content" >
			<form name="page">
				<tr>
					<th><%=RM.GetString("t28")%></th>
					<td>
						<select name="s_radio" style="vertical-align:middle">
							<option value="title" selected><%=RM.GetString("t124")%></option>
							<option value="titleContent"><%=RM.GetString("t169")%></option>
							<option value="writer"><%=RM.GetString("t138")%></option>
						</select>
						<input type="text" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px;vertical-align:middle">
						<a class="imgbtn" style="vertical-align:middle"><span onClick="javascript:search();"><%=RM.GetString("t31")%></span></a></td>
				</tr>
			</form>
		</table> --%>
		
		<br>
		
		<!-- <table class="mainlist" style="width:100%">
			<span id="idSpan" runat="server"></span>
		</table> -->
		
		<div id="tblPageRayer"></div>
	</body>
</html>