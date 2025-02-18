<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t28' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style> 
	        .pagetd {
	        	padding-top:6px;
	        }
	        .pcol {
	        	padding-top:6px;
	        }
	        .right_point01 {
		        font:bold;
		        color:#017bec;
	        }
			.mainlist tr:hover {background-color: #f4f5f5;}
        </style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
        <script type="text/javascript">
	        var pKeyWord = "<c:out value = '${keyword}' />";
	        var CurPage = "<c:out value = '${curPage}' />";
		    var totalPage = "<c:out value = '${totalPage}' />";
		    var totalCount = "<c:out value = '${keywordCount}' />";
		    var pUse_Editor = "<c:out value = '${useEditor}' />";
		    
		    /* 2019-01-02 홍승비 - IE > 로딩 속도 개선용 DOM 로드 리스너 추가(IE8 이상 지원) */
		    document.addEventListener("DOMContentLoaded", makePageSelPage);
		    
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

			function search() {
				if (document.page.s_radio.value == "title" ) {
					var strSearch = "sRadio=title&keyword=" + encodeURIComponent(document.page.keyword.value);
				} else {
					var strSearch = "sRadio=writer&keyword=" + encodeURIComponent(document.page.keyword.value);
				}
				/// else if (document.page.s_radio.value == "titleContent" ) {
				//	var strSearch = "sRadio=titleContent&keyword=" + make_searchstring(document.page.keyword.value);
				// } 
				
				// key파마리터 없어도 되므로 삭제
				strSearch = strSearch + "&code=" + "<c:out value = '${code}' />" + "&bName=" + "<c:out value = '${bName}' />";
				window.location.href = "/admin/ezCommunity/bbsList.do?" + strSearch + "&companyID=" + encodeURIComponent(companySelectID);
			}

			function changeCompany() {
				document.page.keyword.value = "";
				search();
			}
	
			function comm_searchCheck() {
				if ( document.page.keyword.value.length < 2 || document.page.keyword.value.indexOf("%") != -1) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
					//OpenAlertUI("<spring:message code = 'ezCommunity.t164' />");
					alert("<spring:message code = 'ezCommunity.t164' />");
					
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
	            var pageNum = CurPage;
	            
	            if (totalPage > 1 && pageNum != 1) {
	                strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg first disabled'></span>";
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

                if (MaxNum == 0) {
	            	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
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
				var href = "/admin/ezCommunity/bbsList.do?bName=" + encodeURIComponent("${bName}") + "&code="+ encodeURIComponent("${code}") + "&keyword=" + encodeURIComponent(pKeyWord) + "&sRadio=" + encodeURIComponent("${sRadio}") + "&block="+encodeURIComponent("${nowBlock}");
				if(parseInt(page) > 0 && parseInt(page) <= parseInt(totalPage)) {
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
	            window.open("/ezCommunity/board/bbsViewNew.do?mode=content&no=" + sURL + "&bName=" + ttt, "", feature);
			}
			
			function btn_write(bName){
			    var feature = "width=760,height=720";
			    feature = feature + GetOpenPosition(760, 720);
			    
			    if (CrossYN()) {
			        window.open("/ezCommunity/board/bbsEditNew.do?mode=write&companyID=" + encodeURIComponent(companySelectID) + "&bName=" + bName, "", feature);
			    } else {
		            window.open("/ezCommunity/board/bbsEditNew.do?mode=write&companyID=" + encodeURIComponent(companySelectID) + "&bName=" + bName, "", feature);
			    }
			}
			
			function btn_list(bname) {
				url = "/admin/ezCommunity/bbsList.do?bName=<c:out value = '${bName}' />";
				location.href = url;
			}
			
			//페이지네이션 위치 고정
			$(window).on("resize", function(){
				windowResize();
			});
			
			function windowResize() {
				var height = document.documentElement.clientHeight - 200;
				if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
					height = height - 30;
				}
					document.getElementById("contentlist").style.overflow = "auto";
					document.getElementById("contentlist").style.height = height + "px";
			}
			
			$(function(){
				windowResize();
			});
        </script>
	</head>
	
	<body class="mainbody">
	<h1>
		<c:choose>
			<c:when test="${bName == 'tbl_c_notice' }">
				<spring:message code='ezCommunity.khj07'/>
			</c:when>
			<c:when test="${bName == 'tbl_c_board' }">
				<spring:message code='ezCommunity.khj07'/>
			</c:when>
			<c:otherwise>
				<c:out value='${titleName}'/>
			</c:otherwise>
		</c:choose>
		<span id="mailBoxInfo"></span>
		<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp">
			<jsp:param name="companySelectID" value="${companySelectID}"/>
		</jsp:include>
	</h1>
	</body>
	
		<div id="mainmenu">
  			<ul>
				<c:choose>
					<c:when test="${bName == 'tbl_c_board' }">
						<li class="important"><span onClick="btn_write('${bName}')"><spring:message code = 'ezCommunity.t958' /></span></li>
					</c:when>
					
					<c:when test="${fn:indexOf(rollInfo, 'k=1') > -1 && bName == 'tbl_c_notice'}">
						<li class="important"><span onClick="btn_write('${bName}')"><spring:message code = 'ezCommunity.t958' /></span></li>
					</c:when>
				</c:choose>
  			</ul>
		</div>

		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>

		<table class="content">
			<form name="page">
				<tr>
					<th style="background-color: #f1f3f5; border: 1px solid #e2e3e6;"><spring:message code = 'ezCommunity.t28' /></th>
					<td style="border: 1px solid #e2e3e6;">
						<c:choose>
							<c:when test="${sRadio == '' || sRadio == 'title'}">
								<select name="s_radio" style="vertical-align: middle; height: 22px;">
									<option value="title" selected><spring:message code = 'ezCommunity.t124' /></option>
									<option value="writer"><spring:message code = 'ezCommunity.t138' /></option>
								</select>
							</c:when>
							<c:when test="${sRadio == 'writer'}">
								<select name="s_radio" style="vertical-align: middle; height: 22px;">
									<option value="title"><spring:message code = 'ezCommunity.t124' /></option>
									<option value="writer" selected><spring:message code = 'ezCommunity.t138' /></option>
								</select>
							</c:when>
						</c:choose>
						
						<input type="text" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px; height: 25px; vertical-align:middle;">
						<a class="imgbtn imgbck" style="vertical-align: middle; margin-bottom: 0px;"><span onClick="javascript:search();"><spring:message code = 'ezCommunity.t31' /></span></a>
					</td>
				</tr>
			</form>
		</table>
		
		<div id="contentlist" style="margin-top: 10px;">
			<table class="mainlist" style="width:100%;">
				<span id="idSpan">${idSpanValue}</span>
			</table>
		</div>
		
		<div id="tblPageRayer"></div>
	</body>
</html>