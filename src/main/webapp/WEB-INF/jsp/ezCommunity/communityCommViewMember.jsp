<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<style>
			.pagetd {
				padding-top:6px; 
			}
       		.pcol {
       			padding-top:6px;
       		}
        	.Right_Point01 {
	        	font:bold;
	        	color:#017bec;
	        }
	        .cmhomelist tr td {
	        	overflow:hidden;
	        	text-overflow:ellipsis;
	        	white-space:nowrap;
	        }
		</style>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var g_draftpath = window.frames.top.draftspath;
			var g_outboxpath = window.frames.top.outboxpath;
		    var CurPage = "<c:out value = '${curPage}' />";
		    var totalPage = "<c:out value = '${totalPage}' />";
		    var totalCount = "<c:out value = '${keywordCount}' />";
		    var code = "<c:out value = '${code}' />"
		    document.onselectstart = function () { return false; };
		    
		    window.onload =function () {		        
			    makePageSelPage();
			}
			
		    /* 2018-06-29 홍승비 - 커뮤니티 회원을 해당 회사에 겸직하고 있는 정보로 표출하기 */
		    // deptid = d
			function openinfo1(a,b,c, d) {
			    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=450";
			    feature = feature + GetOpenPosition(420, 450);
				rts60 = window.open("/ezCommon/showPersonInfo.do?id=" + b + "&dept=" + d, "", feature);
	            
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
	            document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
	            strtext = "<div class='pagenavi'>";
	            PagingHTML += strtext;
	            var pageNum = CurPage;
	            
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
				var href = "/ezCommunity/commViewMember.do?sRadio="+encodeURIComponent('<c:out value="${sRadio}"/>')
					+"&code="+encodeURIComponent("${code}")
					+"&keyword="+encodeURIComponent('<c:out value="${keyword}"/>')
					+"&block="+encodeURIComponent("${nowBlock}");
				
	            if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
					document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt(newPage));
				}
			}
	        
/* 			function gopage() {
				document.location.href="/ezCommunity/noticeOne.do?mode=list&code=${code}&goToPage="+document.page.sel.value;
			} */

			function goToPage(page) {
				var href = "/ezCommunity/commViewMember.do?sRadio="+encodeURIComponent('<c:out value="${sRadio}"/>')
					+"&code="+encodeURIComponent('<c:out value="${code}"/>')
					+"&keyword="+encodeURIComponent('<c:out value="${keyword}"/>')
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
		<form name="page">
			<table class="content" style="width:100%;border:0px">			
				<tr>
					<td style="border:1px solid #ddd;border:0px;padding:0px">
						<select id="s_radio" name="s_radio" style="font-size: 13px;vertical-align: middle;text-align: center;height: 24px;cursor: pointer;">
							<option value="id"><spring:message code = 'ezCommunity.t512' /></option>
							<option selected value="name"><spring:message code = 'ezCommunity.t10' /></option>
						</select>						
						<input class="inputText" type="text" id="keyword" name="keyword" onKeyDown="return keyword_onkeydown(event)" style="width:200px">
						<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;margin:0px"><span onClick="javascript:search();" style="height:22px;line-height:22px"><spring:message code = 'ezCommunity.t31' /></span></a>						
						<c:if test="${keyword != '' }">
							<a class="imgbtn" style="vertical-align: middle;height:22px;margin:0px"><span onClick="searchList()" style="height:22px;line-height:22px"><spring:message code = 'ezCommunity.t724' /></span></a>
						</c:if>						
					</td>
				</tr>			
			</table>
		</form>
		<div  style = "height:370px;">
		<table id="tblList" class="cmhomelist" style="width:100%;margin-top:10px">
			<tr> 
				<th style="width:40px"><spring:message code = 'ezCommunity.t32' /></th>
				<th style="width:110px"><spring:message code = 'ezCommunity.t10' /></th>
				<th style="width:100px"><spring:message code = 'ezCommunity.t241' /></th>
				<th style="width:100px"><spring:message code = 'ezCommunity.t512' /></th>
				<th style="width:85px"><spring:message code = 'ezCommunity.t725' /></th>
				<th style="width:85px"><spring:message code = 'ezCommunity.t726' /></th>
				<th style="width:60px"><spring:message code = 'ezCommunity.t727' /></th>
			</tr>
			${strXML}
		</table>
		</div>		
		<div id="tblPageRayer" style="margin-top:10px"></div>
	</body>
</html>