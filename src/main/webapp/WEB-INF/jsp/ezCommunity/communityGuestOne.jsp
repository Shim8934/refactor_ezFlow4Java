<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t570' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<style>
			.pagetd{padding-top:6px; }
	        .pcol{padding-top:6px; }
	        .Right_Point01 {
		        font:bold;
		        color:#017bec;
	        }
		</style>

		<script type="text/javascript">
			var CurPage = '<c:out value="${curpage}" />';
			var totalPage = '<c:out value="${totalPage}" />';
		    var totalCount = '<c:out value="${keywordCount}" />';
		    var code = '<c:out value="${code}" />';
		    var strXML = "${strXML}";
		    var lang = '<c:out value="${lang}" />';
		    var xmlDoc = loadXMLString(strXML);
		    
		    document.onselectstart = function () {
		    	return false;
		    };

		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        makePageSelPage();
		        
		        var html = "";
		        
		        for(var i = 0; i < SelectNodes(xmlDoc, "DATA/ROW").length; i++) {
		        	html += "<table class=\"content\" style=\"margin-top:10px;border-left:1px solid none;border-right:1px solid none;\">";
		        	html += "<tr style=\"border-left:1px solid none;border-right:1px solid none;\" >";
		        	html += "<th style=\"border-left:1px solid none;border-right:1px solid none;width:20px;\" nowrap><input type=\"checkbox\" name=\"c_no\" value=\"" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_NO") + "\"></th>";
		        	html += "<th style=\"border-left:1px solid none;border-right:1px solid none;width:50px;\" nowrap>" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "C_NO") + "</th>";
		        	html += "<th style=\"width:100%; text-align:left;border-left:1px solid none;border-right:1px solid none;\" >";
		        	
		        	if(SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "NEW") == 'NEW') {
		        		html += "<img src=\"/images/i_new.gif\" border=\"0\" hspace=\"5\" align=\"absmiddle\">";
		        	}
		        		
					html += SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "USERNAME"+lang);
					html += "<spring:message code='ezCommunity.t587' />";
					html += SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "WRITEDAY");
					html += " " + "<spring:message code='ezCommunity.t588' /></th>";
					html += "</tr>";
					html += "<tr style=\"border-left:1px solid none;border-right:1px solid none;\">";
					html += "<td  colspan=\"3\" style=\"word-break:break-all; height:100px; border-left:1px solid none;border-right:1px solid none;\">";
					html += "<textarea style=\"height:100px;width:98%; border:0; overflow-y:auto;\" readonly=\"readonly\" id=textarea1 name=textarea1>" + SelectSingleNodeValue(SelectNodes(xmlDoc, "DATA/ROW")[i], "CONTENT").replace(/<br>/gi, "\n") + "</textarea></td>";
					html += "</tr>";
					html += "</table>";
		        }
		        
		        document.getElementById("formDel").innerHTML = document.getElementById("formDel").innerHTML + html; 
		    }
		    
		    function keyword_onkeydown(e) {
				var keycode;
		        if (!window.ActiveXObject)
		            keycode = e.keyCode;
		        else
		            keycode = event.keyCode;
		        if (keycode == 13) {
		            search();
		            return false;
		        }
		        return true;
		    }
		    
			function search() {
				if( !comm_searchCheck()) {
					return;
				}
					
				if (document.getElementById("s_radio").value == "title") {
					var strSearch = "sRadio=title&keyword=" + document.getElementById("keyword").value;
				} else if (document.getElementById("s_radio").value == "titleContent") {
					var strSearch = "sRadio=titleContent&keyword=" + document.getElementById("keyword").value;
				} else {
					var strSearch = "sRadio=writer&keyword=" + document.getElementById("keyword").value;
				}
				
				strSearch = strSearch + "&key=" + document.getElementById("keyword").value;
				window.location.href = "/ezCommunity/guestOne.do?code=" + code + "&" + encodeURI(strSearch);
			}

			function comm_searchCheck() {
				//[2006.06.21] 특수문자가 검색어에 들어올 경우 오류 메시지 처리
			    var pKeyword = document.getElementById("keyword").value;
				var pLen = pKeyword.length;
				
				for( var i = 0; i < pLen ; i++) {
					if( pKeyword.charAt(i) == "\"" || pKeyword.charAt(i) == "+" ) {
						alert("<spring:message code='ezCommunity.t580' />(\\\"+)<spring:message code='ezCommunity.t581' />");
						return false;
					}
				}
				
			    if (pKeyword.length < 2 || pKeyword.indexOf("%") != -1) {
					alert("<spring:message code='ezCommunity.t164' />");
					return false;
				}
			    
				return true;
			}
			
			function Chk1() {
				if (document.FIND.Find.value=="") {
					alert("<spring:message code='ezCommunity.t582' />");
					document.FIND.Find.focus();
					return false;
				}
				
				document.FIND.submit();
				
				return
			}
			
			function mo_onclick() {
				var count = 0;
				var ingNo;

				for(var i = 0; i < del.elements.length; i++ ) {
					if ( del.elements[i].name == "c_no" && del.elements[i].checked == true) {
						ingNo = del.elements[i].value;
						count++;
					}
				}

				if (count == 0) {
					alert("<spring:message code='ezCommunity.t583' />");
				} else if( count >= 2 ) {
					alert("<spring:message code='ezCommunity.t584' />");
				} else {
					document.location.href = "/ezCommunity/guestEdit.do?code=" + code + "&mode=edit&no="+ingNo;
				}
			}
			
		    function delete1() {
		        var count = 0;
		        for (var i = 0; i < del.elements.length; i++) {
		            if (del.elements[i].name == "c_no" && del.elements[i].checked == true) {
		                ingNo = del.elements[i].value;
		                count++;
		            }
		        }

		        if (count == 0) {
		            alert("<spring:message code='ezCommunity.t583' />");
		            return;
		        }
		        
		        var result;
		        result = confirm("<spring:message code='ezCommunity.t136' />");
		        
		        if (result) {
		            document.del.submit();
		        }
		    }
			
			function alertMessage() {
				alert("<spring:message code='ezCommunity.t181' />");
			}
			
			var BlockSize = 10;
			
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
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
	                strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
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
	            // 20060628 준호수정
	            // 숫자 아닌 문자 들어갔을 경우 에러 남.
	    		var href = "/ezCommunity/guestOne.do?bName=" + encodeURIComponent("${mode}")
				            + "&sRadio=" + encodeURIComponent("${sRadio}")
				            + "&code=" + encodeURIComponent("${code}")
				            + "&keyword=" + "${keyword}"
				            + "&block=" + encodeURIComponent("${nowBlock}");
				            
	            if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	                document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(newPage));
	            }
			}
	        
	        //########################################페이지네이션 변경 ##############################################
		    function goToPage(page) {
		        var href = "/ezCommunity/guestOne.do?bName=" + encodeURIComponent("${mode}")
					+ "&sRadio=" + encodeURIComponent("${sRadio}")
					+ "&code=" + encodeURIComponent("${code}")
					+ "&keyword=" + "${keyword}"
					+ "&block=" + encodeURIComponent("${nowBlock}");

		        if (page == "front") {
		            if (parseInt(CurPage) - 1 < 1)
		                return;
		            document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(CurPage) - 1);
		        }
		        else if (page == "next") {
		            if (parseInt(CurPage) + 1 > parseInt(totalPage))
		                return;
		            document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(CurPage) + 1);
		        }
		        else if (page == "page") {
		            if (event.keyCode == 13) {
		                var goPage = document.all.txt_PageInputNum.value;

		                // 20060628 준호수정
		                // 숫자 아닌 문자 들어갔을 경우 에러 남.
		                if (parseInt(goPage) > 0 && parseInt(goPage) <= parseInt(totalPage)) {
		                    document.location.href = href + "&gotoPage=" + encodeURIComponent(parseInt(goPage));
		                }
		            }
		        }
		    }

		    function goPage(idx) {
		        var url = "";
		        
		        switch (idx) {
		            case 1:
		                url = "/ezCommunity/guestEdit.do?mode=write&code=" + code;
		                break;
		            case 2:
		                url = "/ezCommunity/guestOne.do?mode=list&code=" + code;
		                break;
		        }
		        
		        window.location.href = url;
		    }
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t570' /><span id="mailBoxInfo"></span></h1>
			<div id="mainmenu" >
				<ul>
					<c:if test="${guest != '1' }">
						<c:choose>
							<c:when test="${disable == false }">
								<li><span onClick="goPage(1)"><spring:message code='ezCommunity.t167' /></span></li>
							</c:when>
							
							<c:otherwise>
								<li><span onClick="alertMessage();"><spring:message code='ezCommunity.t167' /></span></li>
							</c:otherwise>
						</c:choose>
						
						<li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
						<li><span onClick="javascript:mo_onclick()"><spring:message code='ezCommunity.t6' /></span></li>
						<li><span onClick="javascript:delete1()"><spring:message code='ezCommunity.t208' /></span></li>
					</c:if>
					<c:if test="${keyword != '' }">
						<li><span onClick="goPage(2)" ><spring:message code='ezCommunity.t168' /></span></li>
					</c:if>
    			</ul>
			</div>
			
			<script type="text/javascript">
			    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>

		<table class="content"  >
			<tr>          
				<th><spring:message code='ezCommunity.t28' /></th>
	  			<td>
					<select name="s_radio" id ="s_radio">
						<option selected value="titleContent" ><spring:message code='ezCommunity.t585' /></option>
						<option value="writer"><spring:message code='ezCommunity.t445' /></option>
					</select>
					<input type="text" name="keyword" id ="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px">
					<a class="imgbtn"><span onClick="search();"><spring:message code='ezCommunity.t31' /></span></a>
	  			</td>
			</tr>
		</table>
		
		<form name="del" id= "formDel" action = "/ezCommunity/guestEditOk.do" method = "post">
			<input type=hidden name=code value="<c:out value='${code}' />">
			<input type=hidden name=mode value=delete>

		</form>
<div id="tblPageRayer"></div>
	</body>
</html>