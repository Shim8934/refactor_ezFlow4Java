<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<style>
			.pagetd{
				padding-top:6px; 
			}
       		.pcol{
       			padding-top:6px;
       		}
        	.Right_Point01 {
	        	font:bold;
	        	color:#017bec;
	        }
		</style>
		
		<script type="text/javascript">
			var g_draftpath = window.frames.top.draftspath;
			var g_outboxpath = window.frames.top.outboxpath;
		    var CurPage = "<c:out value = '${curPage}' />";
		    var totalPage = "<c:out value = '${totalPage}' />";
		    var totalCount = "<c:out value = '${keywordCount}' />";
		    var code = "<c:out value = '${code}' />"
		    document.onselectstart = function () { return false; };
		    
		    window.onload =function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
			    makePageSelPage();
			}
			
			
			function openinfo1(a,b,c) {
			    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=440";
			    feature = feature + GetOpenPosition(420, 440);
				rts60 = window.open("/ezCommon/showPersonInfo.do?id=" + b, "", feature);
	            
			}
			
			//호출하는곳X
			function sendMail( toMailAddr, userDispName, fromMailAddr, fromDipName ) {
				toEmail = "\"" + userDispName + "\"" + " <" + toMailAddr + ">";
				url = "/eoffice/owa/email/newMail.aspx?cmd=new&MsgTo=" + toEmail + "&draftpath=" + g_draftpath + "&outboxpath=" + g_outboxpath;
	
				var feature = "height = 566px, width = 552px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
				feature = feature + GetOpenPosition(552, 566);
				toMail = window.open(url, "sendMail", feature);
			}
			
			function keyword_onkeydown(e) {
			    var kecode = e.keyCode;

				if (kecode==13) {
					search();
					
					return false;
				}
				
				return true;
			}
			
			function search() {
			    var strSearch = "";
			    
			    if (document.getElementById("s_radio").value == "id") {
				    strSearch = "sRadio=id&keyword=" + encodeURIComponent(document.getElementById("keyword").value);
			    } else {
				    strSearch = "sRadio=name&keyword=" + encodeURIComponent(document.getElementById("keyword").value);
			    }
			    
				strSearch = strSearch + "&key=" + encodeURIComponent(document.getElementById("keyword").value) + "&code="+ encodeURIComponent(code);
				window.location.href = "/ezCommunity/commViewMember.do?" + strSearch;
			}
			
	        var BlockSize = 10;
	        
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext; 
	        }
	        
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang82 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang5351 + "]";
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
				movePage(CurPage);
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
	        
	        function movePage(newPage) {	
				var href = "/ezCommunity/commViewMember.do?sRadio="+encodeURIComponent("${sRadio}")
					+"&code="+encodeURIComponent("${code}")
					+"&keyword="+encodeURIComponent("${keyword}")
					+"&block="+encodeURIComponent("${nowBlock}");
				
	            if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
					document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt(newPage));
				}
			}
	        
/* 			function gopage() {
				document.location.href="/ezCommunity/noticeOne.do?mode=list&code=${code}&goToPage="+document.page.sel.value;
			} */

			function goToPage(page) {
				var href = "/ezCommunity/commViewMember.do?sRadio="+encodeURIComponent("${sRadio}")
					+"&code="+encodeURIComponent("${code}")
					+"&keyword="+encodeURIComponent("${keyword}")
					+"&block="+encodeURIComponent("${nowBlock}");
					
				if (page == "front") {
					if (parseInt("${curPage}") - 1 < 1) {
						return;
					}
					
					document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt("${curPage}") - 1);
				} else if (page == "next") {
					if (parseInt("${curPage}") + 1 > parseInt("${totalPage}")) {
						return;
					}
					
					document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt("${curpage}") + 1);
				} else if (page == "page") {
					if (event.keyCode == 13) {
						var goPage = document.all.txt_PageInputNum.value;
						
						if(parseInt(goPage) > 0 && parseInt(goPage) <= parseInt("${totalPage}")) {
							document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt(goPage));
						}
					}
				}
			}
			
			function searchList() {
					var url = "/ezCommunity/commViewMember.do?code=${code}";
					location.href = url;
			}
			
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code = 'ezCommunity.t723' /><span id="mailBoxInfo"></span></h1>
		<table class="content"> 
			<form name="page">
				<tr>
      				<th><spring:message code = 'ezCommunity.t28' /></th>
					<td>
						<select id="s_radio" name="s_radio" style="font-size: 13px;vertical-align: middle;text-align: center;height: 18px;cursor: pointer;">
							<option value="id"><spring:message code = 'ezCommunity.t512' /></option>
							<option selected value="name"><spring:message code = 'ezCommunity.t10' /></option>
						</select>
						
						<input type="text" id="keyword" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px">
						<a class="imgbtn"><span onClick="javascript:search();"><spring:message code = 'ezCommunity.t31' /></span></a>
						
						<c:if test="${keyword != '' }">
							<a class="imgbtn"><span onClick="searchList()"><spring:message code = 'ezCommunity.t724' /></span></a>
						</c:if>
						
					</td>
				</tr>
			</form>
		</table>
		
		<br>
		
		<table id="tblList" class="cmhomelist" width="100%">
			<tr> 
				<th style="width:55px"><spring:message code = 'ezCommunity.t32' /></th>
				<th style="width:100px"><spring:message code = 'ezCommunity.t10' /></th>
				<th style="width:85px"><spring:message code = 'ezCommunity.t241' /></th>
				<th style="width:85px"><spring:message code = 'ezCommunity.t512' /></th>
				<th style="width:110px"><spring:message code = 'ezCommunity.t725' /></th>
				<th style="width:120px"><spring:message code = 'ezCommunity.t726' /></th>
				<th style="width:70px"><spring:message code = 'ezCommunity.t727' /></th>
			</tr>
			${strXML }
		</table>
		
		<div id="tblPageRayer"></div>

	</body>
</html>