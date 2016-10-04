<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admit_com</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code = 'ezCommunity.e1' />"></script>
		
		<script type="text/javascript">
			var lang = "<c:out value = '${lang}' />";
			var sCurPage = "<c:out value = '${curpage}' />";
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
				
				if (document.comm_search.s_radio.value == "1" ) {
					strSearch = "sRadio=C_SysopID&keyword=" + make_searchstring(document.comm_search.keyword.value);
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
			    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=380,height=350";
			    feature = feature + GetOpenPosition(380, 350);
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
                document.getElementById("TitleInfo").innerHTML = " - [" + "<spring:message code = 'ezCommunity.t26' />" + "<span style='color:#017BEC;font-weight:bold;'> " + totalCount + " </span>" + "<spring:message code = 'ezCommunity.t27' />" + "]";
                strtext = "<div class='pagenavi'>";
                PagingHTML += strtext;
                var pageNum = sCurPage;
                
                if (sTotalPage > 1 && pageNum != 1) {
                    strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
                    PagingHTML += strtext;
                }
                
                if (sTotalPage > BlockSize) {
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
                
                if (sTotalPage > BlockSize) {
                    if (sTotalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
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
                
                if (sTotalPage > 1 && sTotalPage != 1 && (sTotalPage != pageNum)) {
                    strtext = "<span class='btnimg' onclick='return goToPageByNum(" + sTotalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
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
					window.location.href = "/admin/ezCommunity/admitCom.do?bName=&sRadio=${sRadio}&code=${code}&keyword=" + make_searchstring("${keyword}") + "&block=${nowBlock}&goToPage=" + sCurPage;
				}
			}
		          //########################################페이지네이션 변경 ##############################################
		            
		</script>
	</head>
	<body class="mainbody" onload="makePageSelPage()">
		<h1><spring:message code = 'ezCommunity.t25' />  <span id="TitleInfo" style="color:#666;font-weight:normal;"></span></h1>
		<%--<div class="page"><spring:message code = 'ezCommunity.t26' /><span class="point">${keywordCount}</span><spring:message code = 'ezCommunity.t27' /></div>--%>
        <table class="content" >
			<form name="comm_search" method="post">
			<tr>
				<th><spring:message code = 'ezCommunity.t28' /></th>
			  	<td>
			  		<select name="s_radio" style="WIDTH:115px; HEIGHT:19px;vertical-align:middle" class="text">
						<option value="1"><spring:message code = 'ezCommunity.t29' /></option>
						<option value="2" selected><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t10' /></option>
					</select>
					<input name="keyword" onkeydown="return keyword_onkeydown()" style="vertical-align:middle">
					<a class="imgbtn" style="vertical-align:middle"><span onClick="javascript:search();"><spring:message code = 'ezCommunity.t31' /></span></a>
				</td>
			</tr>
			</form>
		</table>

        <br />
        
        <table class="mainlist" style="width:100%">
			<tr>
				<th style="width:70px;"><spring:message code = 'ezCommunity.t32' /></th>
				<th><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t10' /></th>
				<th style="width:200px"><spring:message code = 'ezCommunity.t33' /></th>
				<th style="width:150px"><spring:message code = 'ezCommunity.t24' /></th>
			</tr>
			<span id="idSpan">${idSpanValue }</span>
		</table>
		<br/>
		
	    <div id="tblPageRayer"></div>
	</body>
</html>