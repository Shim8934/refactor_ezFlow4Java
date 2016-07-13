<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t28' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code = 'ezCommunity.e1' />"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		
		<style> 
	        .pagetd{
	        	padding-top:6px;
	        }
	        .pcol{
	        	padding-top:6px;
	        }
	        .right_point01 {
		        font:bold;
		        color:#017bec;
	        }
        </style>
        
        <script type="text/javascript">
	        var pKeyWord = "<c:out value = '${keyword}' />";
	        var CurPage = "<c:out value = '${curPage}' />";
		    var totalPage = "<c:out value = '${totalPage}' />";
		    var totalCount = "<c:out value = '${keywordCount}' />";
		    var pUse_Editor = "<c:out value = '${useEditor}' />";
		    
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
			
			function refresh_onclick() {
				window.location.reload(false);
			}
		</script>
		<script type="text/javascript">
		    document.onselectstart = function () { return false; };
	
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
					var strSearch = "sRadio=title&keyword=" + make_searchstring(document.page.keyword.value);
				} else if (document.page.s_radio.value == "titleContent" ) {
					var strSearch = "sRadio=titleContent&keyword=" + make_searchstring(document.page.keyword.value);
				} else {
					var strSearch = "sRadio=writer&keyword=" + make_searchstring(document.page.keyword.value);
				}
				
				strSearch = strSearch + "&code=" + "<c:out value = '${code}' />" + "&bname=" + "<c:out value = '${bname}' />" + "&key=" + make_searchstring(document.page.keyword.value);
				window.location.href = "/admin/ezCommunity/bbsList.do" + "?" + encodeURI(strSearch);
			}
	
			function comm_searchCheck() {
				if ( document.page.keyword.value.length < 2 || document.page.keyword.value.indexOf("%") != -1) {
					OpenAlertUI("<spring:message code = 'ezCommunity.t164' />");
					
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
	                    strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang80 + "</span>";
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
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                    strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                } else {
	                    strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
	                    strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                    PagingHTML += strtext;
	                }
	            } else {
	                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang81 + "</span>";
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
				var href = "/ezCommunity/board/bbsList.do?bName=<c:out value = '${bName}' />&code="+ encodeURIComponent("<c:out value = '${code}' />") + "&keyword=" + make_searchstring(pKeyWord) + "&s_radio=" + encodeURIComponent("<c:out value = '${sRadio}' />") + "&block="+encodeURIComponent("<c:out value = '${nowBlock}' />");
				if(parseInt(page) > 0 && parseInt(page) <= parseInt(totalPage)) {
					document.location.href = href + "&GotoPage=" + encodeURIComponent(parseInt(page));
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
	            window.open("/ezCommunity/board/bbsViewNew.do?mode=content&no=" + sURL + "&bName=" + ttt, "", feature);
			}
			
			function btn_write(bName){
			    var feature = "width=760,height=720";
			    feature = feature + GetOpenPosition(760, 720);
			    
			    if (CrossYN()) {
			        window.open("/ezCommunity/board/bbsEditNew.do?mode=write&bName=" + bName, "", feature);
			    } else {
			        if (pUse_Editor == "" || pUse_Editor == "CK") {
			            window.open("/ezCommunity/board/bbsEditNew.do?mode=write&bName=" + bName, "", feature);
			        } else {
			            window.open("/ezCommunity/board/bbsEditNew.do?mode=write&bName=" + bName, "", feature);
			        }
			    }
			}
			
			function btn_list(bname) {
				url = "/admin/ezCommunity/bbsList.do?bName=<c:out value = '${bName}' />";
				location.href = url;
			}
        </script>
	</head>
	
	<body class="mainbody" onload = "makePageSelPage()">
		<c:choose>
			<c:when test="${bName == 'c_notice' }">
				<h1><spring:message code = 'ezCommunity.t2001' /><span id="mailBoxInfo"></span></h1>
			</c:when>
			<c:when test="${bName == 'c_board' }">
				<h1><spring:message code = 'ezCommunity.t2001' /><span id="mailBoxInfo"></span></h1>
			</c:when>
			<c:otherwise>
				<h1><c:out value = '${titleName}' /><span id="mailBoxInfo"></span></h1>
			</c:otherwise>
		</c:choose>
	
		<div id="mainmenu">
  			<ul>
				<c:choose>
					<c:when test="${bName == 'c_board' }">
						<li><span onClick="btn_write('${bName}')"><spring:message code = 'ezCommunity.t167' /></span></li>
					</c:when>
					
					<c:when test="${(fn:indexOf(rollInfo, 'k=1') > -1 && fn:indexOf(rollInfo, 't=1') > -1) && bName == 'c_notice'}">
						<li><span onClick="btn_write('${bName}')"><spring:message code = 'ezCommunity.t167' /></span></li>
					</c:when>
				</c:choose>
				
				<c:if test="${keyword != '' }">
					<li><span onclick="btn_list('${bName}')"><spring:message code = 'ezCommunity.t168' /></span></li>
				</c:if>
				
  			</ul>
		</div>

		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>

		<table class="content" >
			<form name="page">
				<tr>
					<th><spring:message code = 'ezCommunity.t28' /></th>
					<td>
						<select name="s_radio" style="vertical-align:middle">
							<option value="title" selected><spring:message code = 'ezCommunity.t124' /></option>
							<option value="titleContent"><spring:message code = 'ezCommunity.t169' /></option>
							<option value="writer"><spring:message code = 'ezCommunity.t138' /></option>
						</select>
						
						<input type="text" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px;vertical-align:middle">
						<a class="imgbtn" style="vertical-align:middle"><span onClick="javascript:search();"><spring:message code = 'ezCommunity.t31' /></span></a>
					</td>
				</tr>
			</form>
		</table>
		
		<br>
		
		<table class="mainlist" style="width:100%">
			<span id="idSpan">${idSpanValue}</span>
		</table>
		
		<div id="tblPageRayer"></div>
	</body>
</html>