<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t272'/>&nbsp;<spring:message code='ezCommunity.t863'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
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
			function keyword_onkeydown(e) {
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
			function search() {
				if (document.page.sRadio.value == "title" ) {
					var strSearch = "sRadio=title&keyword=" + document.page.keyword.value;
				} else if (document.page.sRadio.value == "titleContent" ) {
					var strSearch = "sRadio=titleContent&keyword=" + document.page.keyword.value;
				} else {
					var strSearch = "sRadio=writer&keyword=" + document.page.keyword.value;
				}
				
				strSearch = strSearch + "&code=" + "${code}" + "&bName=" + "${bName}";
				
				window.location.href = "/ezCommunity/board/bbsList.do" + "?" + encodeURI(strSearch);
			}

			function comm_searchCheck() {
				if ( document.page.keyword.value.length < 2 || document.page.keyword.value.indexOf("%") != -1) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 					//OpenAlertUI("<spring:message code = 'ezCommunity.t164'/>");
					alert("<spring:message code = 'ezCommunity.t164'/>");
					
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
	            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
	            strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
	            var pageNum = curPage;
	            
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg first disabled'></span>"
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > BlockSize) {
	                if (pageNum > BlockSize) {
	                    strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
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
	                    strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                    PagingHTML += strtext;
	                }
	            }
	            
	            if (totalPage > BlockSize) {
	                if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "";
	                    strtext = strtext + "<span class='btnimg next disabled'></span>";
	                    PagingHTML += strtext;
	               }
	            } else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	            }
	            
	            if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	                strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg last disabled'></span>";
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
	            
	            if (parseInt(pageNum - 1) > 0) {
	                goToPageByNum(parseInt(pageNum - 1));
	            } else {
	                return;
	            }
	        }
	        
	        function selafterBlock() {
	            var pageNum = parseInt(curPage);
	            pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	            goToPageByNum(pageNum);
	        }
	         
			function selafterBlock_one() {
	            var pageNum = parseInt(curPage);
	            
	            if( parseInt(pageNum + 1) <= totalPage) {
	                goToPageByNum(parseInt(pageNum + 1));
	            } else {
	                return;
	            }
	        }
			
			function goToPage(page) {
				var href = "/ezCommunity/board/bbsList.do?bName=${bName}&code="+ encodeURIComponent("${code}") + "&keyword=" + pKeyWord + "&sRadio=" + encodeURIComponent("${sRadio}") + "&block="+encodeURIComponent("${nowblock}");
				
				if(parseInt(page) > 0 && parseInt(page) <= parseInt(totalPage))  {
					document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt(page));
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
	            window.open("/ezCommunity/board/bbsViewNew.do?no=" + sURL + "&bName=" + ttt, "<spring:message code = 'ezCommunity.t166'/>", feature);						        
				
			}
			
			function btn_write(bname) {
			    var feature = "width=760,height=720";
			    feature = feature + GetOpenPosition(760, 720);
		        window.open("/ezCommunity/board/bbsEditNew.do?mode=write&bName=" + bname + "&code=" + "${code}" , "<spring:message code = 'ezCommunity.t166'/>", feature);
			}
			
			function btn_list(bname) {
				url = "/ezCommunity/board/bbsList.do?bName=" + bname;
				location.href = url;
			}
		</script>
	</head>
	<body class="mainbody" onload="makePageSelPage()">
		<c:choose>
			<c:when test="${bName == 'tbl_c_notice'}">
				<h1><spring:message code = "ezCommunity.t73"/><span id="mailBoxInfo"></span></h1>
			</c:when>
			<c:when test="${bName == 'tbl_c_board'}">
				<h1><spring:message code='main.t272'/>&nbsp;<spring:message code='ezCommunity.t863'/><span id="mailBoxInfo"></span></h1>
			</c:when>
			<c:otherwise>
				<h1>${titleName }<span id="mailBoxInfo"></span></h1>
			</c:otherwise>
		</c:choose>
		
		<div id="mainmenu">
			<ul>
				<c:choose>
					<c:when test="${bName == 'tbl_c_board'}">
						<li><span onClick="btn_write('${bName }')"><spring:message code = "ezCommunity.t167"/></span></li>
					</c:when>
					<c:when test="${fn:indexOf(userInfo.rollInfo, 'k=1') > -1 && bName == 'tbl_c_notice'}">
						<li><span onClick="btn_write('${bName }')"><spring:message code = "ezCommunity.t167"/></span></li>
					</c:when>
				</c:choose>
				
				<c:if test="${keyword != '' }">
					<li><span onclick="btn_list('${bName }')"><spring:message code = "ezCommunity.t168"/></span></li>
				</c:if>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content" >
			<form name="page">
				<tr>
					<th><spring:message code = "ezCommunity.t28"/></th>
					<td>
						<select name="sRadio" style="vertical-align:middle">
							<option value="title" selected><spring:message code = "ezCommunity.t124"/></option>
							<option value="titleContent"><spring:message code = "ezCommunity.t169"/></option>
							<option value="writer"><spring:message code = "ezCommunity.t138"/></option>
						</select>
						<input type="text" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px;vertical-align:middle">
						<a class="imgbtn" style="vertical-align:middle"><span onClick="javascript:search();"><spring:message code = "ezCommunity.t31"/></span></a></td>
				</tr>
			</form>
		</table>
		
		<br>
		
		<table class="mainlist" style="width:100%">
			<span id="idSpan" >${idSpanVal } </span>
		</table>
		
		<div id="tblPageRayer"></div>
	</body>
</html>