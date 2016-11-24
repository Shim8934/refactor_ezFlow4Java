<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="<spring:message code = 'ezCommunity.e1' />"></script>
		
		<script type="text/javascript">
			var sCurPage = "<c:out value = '${curPage}' />";
			var sTotalPage = "<c:out value = '${totalPage}' />";
			var totalCount = "<c:out value = '${totalCount}' />";
			
			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
					return false;
				} else {
					return true;
				}
			};	
			
			function view_CommunityInfo(pcode) {
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 720) / 2;
				var pLeft = (pwidth - 765) / 2;
				window.open("/admin/ezCommunity/admCommunityInfoEdit.do?code=" + pcode, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=360,width=480,top=" + pTop + ",left=" + pLeft, "");
			}
			
			function prevPage_onclick() {
				newPage = parseInt(sCurPage) - 1;
				
				if(newPage > 0) {
					window.location.href = "/admin/ezCommunity/searchKey.do?select=${select}&query=" + make_searchstring('${query}') + "&page=" + newPage.toString();
				}
			}
	
			function nextPage_onclick() {
				newPage = parseInt(sCurPage) + 1;
				
				if(newPage <= parseInt(sTotalPage)) {
					window.location.href = "/admin/ezCommunity/searchKey.do?select=${select}&query=" + make_searchstring('${query}') + "&page=" + newPage.toString();
				}
			}
	
			function moveToPage(sCurPage) {
	            if(parseInt(sCurPage) > 0 && parseInt(sCurPage) <= parseInt(sTotalPage)) {
					window.location.href = "/admin/ezCommunity/searchKey.do?select=${select}&query=" + make_searchstring('${query}') + "&page=" + sCurPage;
				}
			}
			
			function get_search_CommunityInfo(e) {
			    var kecode = e.keyCode;
			    
			    if (kecode == 13) {
			        search_CommunityInfo();
	
			        return false;
			    }
			    return true;
			}
			
			function search_CommunityInfo() {
			    var strSelect = document.getElementById("QuerySelect").value;
			    var strQuery = document.getElementById("txt_SearchQuery").value;
	
				if( strQuery == "") {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 					//OpenAlertUI("<spring:message code = 'ezCommunity.t75' />");
					alert("<spring:message code = 'ezCommunity.t75' />");
					return;
				}
				
				window.location.href = "/admin/ezCommunity/searchKey.do?select=" + strSelect + "&query=" + encodeURI(make_searchstring(strQuery));
			}
			
			function openinfo_userinfo(pCN) {
				window.open("/ezCommon/showPersonInfo.do?id=" + pCN, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
			    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=440";
			    feature = feature + GetOpenPosition(420, 440);
			    rts60 = window.open("/ezCommon/showPersonInfo.do?id=" + pCN, "", feature);
			}
			
			//########################################페이지네이션 변경 ##############################################
	        var BlockSize = 10;
	        function td_Create1(strtext) {
	            document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
	        }
	        
	        function makePageSelPage() {
	            var strtext;
	            var PagingHTML = "";
	            document.getElementById("tblPageRayer").innerHTML = "";
	            document.getElementById("TitleInfo").innerHTML = " - [" + strLang82 + "<span style='color:#017BEC;font-weight:bold;'> " + totalCount + " </span>" + strLang83 + "]";
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
	                }
	                else {
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
	        //########################################페이지네이션 변경 ##############################################
		</script>
	</head>
	<body class="mainbody" onload = "makePageSelPage()">
		<h1><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t31' /><span id="TitleInfo" style="color:#666;font-weight:normal;"></span></h1>
		<form name="adm_search_key" method="post" ID="Form1">
	    	<table class="content">
				<tr>
					<th ><spring:message code = 'ezCommunity.t31' /></th>
			  		<td>
						<select id="QuerySelect" name="QuerySelect" style="vertical-align:middle">
							<option selected value="pCommunityName"><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t10' /></option>
							<option value="pCommuintyDesc" ><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t18' /></option>
						</select>
						
						<input name="text" type="text" style="WIDTH:200px;vertical-align:middle" id="txt_SearchQuery" onKeyPress="return get_search_CommunityInfo(event)"> 
						<a class="imgbtn" style="vertical-align:middle"><span onClick="search_CommunityInfo()"><spring:message code = 'ezCommunity.t31' /></span></a>
			  		</td>
				</tr>
			</table>
		
			<%--<div class="page">
			<img src="/images/page_previous.gif" width="15" height="16" align="absmiddle" id="td_Previous"  onClick="prevPage_onclick()">
			<spring:message code = 'ezCommunity.t76' /><span>${ iTotalPage }</span>&nbsp;&nbsp;<spring:message code = 'ezCommunity.t77' />
			<input type="text" id="txt_inputPageNum" style="WIDTH:35px" value='${ iPage }' onKeyDown="moveToPage()">
			<img src="/images/page_next.gif" width="15" height="16" align="absmiddle" id="Img1"  onClick="nextPage_onclick()"></div>--%>
			
			<br />
			
			<table class="mainlist" style="width:100%">
				<tr>
					<th style="width:50px; height:23px"><spring:message code = 'ezCommunity.t32' /></th>
					<th style="width:250px;"><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t10' /></th>
					<th><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t18' /></th>
					<th style="width:100px;"><spring:message code = 'ezCommunity.t33' /></th>
					<th style="width:80px;"><spring:message code = 'ezCommunity.t78' /></th>
				</tr>

				<c:forEach var = "club" items = "${clubList }" varStatus="status">
					<tr>
						<td style="width:50px; height:23px">${status.count }</td>
						<!--// 20100108 : 보안 처리, 관련 추가작업(XSS)-->
						<td style="cursor:pointer; text-overflow:ellipsis; white-space:nowrap; overflow:hidden" onClick="view_CommunityInfo('${club.c_ClubNo}')"><nobr ><c:out value = '${club.c_ClubName }' /></nobr></td>
						<td style="cursor:pointer; width:300px; text-overflow:ellipsis; white-space:nowrap; overflow:hidden" onClick="view_CommunityInfo('${club.c_ClubNo}')"><c:out value = '${club.c_ClubDesc}' /></td>
						<td style="cursor:pointer; width:80px" onClick="openinfo_userinfo('${club.c_SysopID}')"><c:out value = '${club.userName }' /></td>
						<td style="width:80px"><c:out value = '${fn:substring(club.c_RegDate, 0, 10) }' /></td>
					</tr>
				</c:forEach>
				
			</table>
			
			<br />
			
			<div id="tblPageRayer"></div>
		</form>
	</body>
</html>