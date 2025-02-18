<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admit_com</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
		.mainlist tr th:first-child{
			padding-left: 10px;
		}
		.mainlist tr td:first-child{
			padding-left: 10px;
		}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var lang = "<c:out value = '${lang}' />";
			var sCurPage = "<c:out value = '${curPage}' />";
			var sTotalPage = "<c:out value = '${totalPage}' />";
			var totalCount = "<c:out value = '${keywordCount}' />";
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
			};
				
			function keyword_onkeydown() {
				if (event.keyCode==13) {
					search();
					
					return false;
				}
				return true;
			}

			function search()  {	//[this.selectedIndex].value
				var strSearch = "";
				
				/* 2018-12-03 홍승비 - 마스터이름 검색 시 sysopID가 아니라 USERNAME > DISPLAYNAME 넘기도록 수정*/
				if (document.comm_search.s_radio.value == "1" ) {
					strSearch = "sRadio=DISPLAYNAME&keyword=" + make_searchstring(document.comm_search.keyword.value);
				} else if (document.comm_search.s_radio.value == "2" ) {
					strSearch = "sRadio=C_ClubName" + lang + "&keyword=" + make_searchstring(document.comm_search.keyword.value);
				}
			
				strSearch = strSearch + "&key=" + make_searchstring(document.comm_search.keyword.value);
				window.location.href = "/admin/ezCommunity/admitCom.do" + "?" + encodeURI(strSearch);
			}

			function comm_searchCheck() {
				if ( document.comm_search.keyword.value.length < 2 || document.comm_search.keyword.value.indexOf("%") != -1) {
					alert("<spring:message code = 'ezCommunity.t23' />");
					
					return false;
				}
				return true;
			}
			
			function open_info( code ) {
				if (CrossYN() && new RegExp(/Chrome/).test(navigator.userAgent)) {
					var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=550,height=370";
				    feature = feature + GetOpenPosition(550, 370);
				} else {
					var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=550,height=360";
				    feature = feature + GetOpenPosition(550, 360);
				}
			    
			    comm = window.open("/admin/ezCommunity/commInfo.do?code=" + code + "&type=New&title=" + encodeURI("<spring:message code = 'ezCommunity.t24' />") + "", "", feature);
			}
		
            var BlockSize = 10;
            
            function td_Create1(strtext) {
                document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
            }
            
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                document.getElementById("tblPageRayer").innerHTML = "";
                document.getElementById("TitleInfo").innerHTML = "&nbsp;<span class='txt_color' style='font-weight:bold;'>" + totalCount + "</span>";
                strtext = "<div class='pagenavi'>";
                PagingHTML += strtext;
                var pageNum = sCurPage;
                
                if (sTotalPage > 1 && pageNum != 1) {
                    strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg first disabled'></span>";
                    PagingHTML += strtext;
                }
                
                if (sTotalPage > BlockSize) {
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
                
                if (sTotalPage >= (startNum + parseInt(BlockSize))) {
                    MaxNum = (startNum + parseInt(BlockSize)) - 1;
                } else {
                    MaxNum = sTotalPage;
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
                
                if (sTotalPage > BlockSize) {
                    if (sTotalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
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
                
                if (sTotalPage > 1 && sTotalPage != 1 && (sTotalPage != pageNum)) {
                    strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + sTotalPage + ")'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg last disabled'></span>";
                    PagingHTML += strtext;
                }
                
                PagingHTML += "</div>";
                td_Create1(PagingHTML);
            }
            
            function goToPageByNum(Value) {
                sCurPage = Value;
                makePageSelPage();
				moveToPage(sCurPage);
            }
            
            function selbeforeBlock() {
                var pageNum = parseInt(sCurPage);
                pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
                goToPageByNum(pageNum);    
            }
            
            function selbeforeBlock_one() {
                var pageNum = parseInt(sCurPage);
                
                if (parseInt(pageNum - 1) > 0) {
                    goToPageByNum(parseInt(pageNum - 1));
                } else {
                    return;
                }
            }
            
            function selafterBlock() {
                var pageNum = parseInt(sCurPage);
                pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
                goToPageByNum(pageNum);
            }
            
            function selafterBlock_one() {
                var pageNum = parseInt(sCurPage);
                
                if( parseInt(pageNum + 1) <= sTotalPage) {
                    goToPageByNum(parseInt(pageNum + 1));
                } else {
                    return;
                }
            }
            
            function moveToPage(sCurPage) {
                if(parseInt(sCurPage) > 0 && parseInt(sCurPage) <= parseInt(sTotalPage)) {
					window.location.href = "/admin/ezCommunity/admitCom.do?bName=&sRadio=${sRadio}&code=${code}&keyword=" + make_searchstring('<c:out value="${keyword}"/>') + "&block=${nowBlock}&goToPage=" + sCurPage;
				}
			}
		          //########################################페이지네이션 변경 ##############################################
		    //2018-08-06 김보미 - 페이지 위치 고정
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 172;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		    
		    $(function(){
	    		windowResize();
		    });       
		</script>
	</head>
	<body class="mainbody" onload="makePageSelPage()">
		<h1><spring:message code = 'ezCommunity.t25' />  <span id="TitleInfo"></span></h1>
		<%--<div class="page"><spring:message code = 'ezCommunity.t26' /><span class="point">${keywordCount}</span><spring:message code = 'ezCommunity.t27' /></div>--%>
        <table class="content" style="height:35px">
			<form name="comm_search" method="post">
			<tr>
				<th style="border:0px"><spring:message code = 'ezCommunity.t31' /></th>
			  	<td style="border-left:0px;background-color: #f8f8fa">
			  		<select name="s_radio" style="vertical-align:middle; height: 22px; margin-left:2px;width:100px;" class="text">
						<option value="1"><spring:message code = 'ezCommunity.t33' /></option>
						<option value="2" selected><spring:message code = 'ezCommunity.t9991' /></option>
					</select>
					<input name="keyword" onkeydown="return keyword_onkeydown()" style="width:200px;vertical-align:middle; height: 22px;">
					<a class="imgbtn" style="vertical-align:middle; margin-bottom:0px;"><span onClick="javascript:search();"><spring:message code = 'ezCommunity.t31' /></span></a>
				</td>
			</tr>
			</form>
		</table>

        <div id="contentlist" style="width:100%; overflow: auto; margin-top:5px">
	        <div>
		        <table class="mainlist" style="width:100%">
					<tr>
						<th style="width:70px;"><spring:message code = 'ezCommunity.t32' /></th>
						<th><spring:message code = 'ezCommunity.t9991' /></th>
						<th style="width:200px"><spring:message code = 'ezCommunity.t33' /></th>
						<th style="width:150px"><spring:message code = 'ezCommunity.t24' /></th>
					</tr>
					<c:if test="${idSpanValue ne null && idSpanValue ne ''}">
						<span id="idSpan">${idSpanValue }</span>
					</c:if>
					<c:if test="${idSpanValue eq null || idSpanValue eq ''}">
					<tr>
						<td colspan="4" style='text-align: center;'><spring:message code = 'main.t00026' /></td>
					</tr>
					</c:if>
				</table>
			</div>
		</div>
		
	    <div id="tblPageRayer"></div>
	</body>
</html>