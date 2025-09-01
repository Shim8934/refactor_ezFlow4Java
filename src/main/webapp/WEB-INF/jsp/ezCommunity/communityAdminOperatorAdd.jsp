<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.lyj34' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<!-- 페이징 -->
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/lang/ezCommunity.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ListView_list.js')}"></script>
		<script type="text/javascript">
			var code = "<c:out value = '${fn:escapeXml(code)}' />";
			var CurPage = "<c:out value = '${curPage}' />";
			var totalPage = "<c:out value = '${totalPage}' />";
			var totalCount = "<c:out value = '${keywordCount}' />";
			var keyword = "<c:out value = '${keyword}' />";
			var type = "<c:out value = '${type}' />";

			window.onload = function () {
				makePageSelPage();
			}
		   
		   function add(userId) {
			   $.ajax({
				   type : "POST",
				   url : "/ezCommunity/adminOperatorGradeUpdate.do",
				   dataType : "text",
				   data : {
					   code : code,
					   userId : userId
				   },
				   success : function(result) {
					   if (result == "true") {
						   alert("<spring:message code = 'ezCommunity.lyj45' />");
						   window.location.reload();
					   } else {
						   alert("<spring:message code = 'ezCommunity.t283' />");
					   }
				   },
				   error : function(e) {
					   alert("<spring:message code = 'ezCommunity.t283' />");
					   console.log(e);
				   }
			   });
		   }
			
		   function search() {
			   var inputVal = document.getElementById("searchUser").value;
			   var selectVal = document.getElementById("s_radio").value;
			   window.location.href = "/ezCommunity/adminAddOperator.do?code=" + code + "&keyword=" + inputVal + "&type=" + selectVal;
		   }

			function search_onkeydown(event) {
				if (event.keyCode == 13) {
					search();
				}
			}

			function back() {
				window.location.href = "/ezCommunity/adminOperatorManage.do?code=" + encodeURIComponent(code);
			}

			var BlockSize = 10;

			function td_Create1(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			}

			function makePageSelPage() {
				var strtext;
				var PagingHTML = "";
				document.getElementById("tblPageRayer").innerHTML = "";
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
				var href = "/ezCommunity/adminAddOperator.do?sRadio="
						+"&code="+encodeURIComponent('<c:out value="${code}"/>')
						+"&keyword="+encodeURIComponent('<c:out value="${keyword}"/>')
						+"&type="+encodeURIComponent('<c:out value="${type}"/>')
						+"&block="+encodeURIComponent("${nowBlock}");

				if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
					document.location.href = href + "&goToPage=" + encodeURIComponent(parseInt(newPage));
				}
			}

			function goToPage(page) {
				var href = "/ezCommunity/adminAddOperator.do?sRadio="
						+"&code="+encodeURIComponent('<c:out value="${code}"/>')
						+"&keyword="+encodeURIComponent('<c:out value="${keyword}"/>')
						+"&type="+encodeURIComponent('<c:out value="${type}"/>')
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
		</script>
	</head>
	<body class = "mainbody communityMain">
		<h1><spring:message code = 'ezCommunity.lyj31' /></h1>
		<div class="point"><spring:message code = 'ezCommunity.lyj33' /></div>
		<hr style="margin-top:10px;">
		<div style="display:flex;justify-content: flex-start;margin-top:10px;">
			<div style="margin-top:2px;">
				▒ <spring:message code = 'ezCommunity.lyj06' /> <span class="point"><c:out value = '${fn:escapeXml(postCount)}' /></span><spring:message code = 'ezCommunity.lyj32' />
			</div>
			<div style="margin-left:10px;">
				<a class="imgbtn" style="vertical-align:middle;"><span id="btn_return_List" onclick="back()"><spring:message code = 'ezCommunity.t987' /></span></a>
			</div>
			<div class="content" style="border:0px;margin-left: auto;">
				<select id="s_radio" name="s_radio" style="font-size: 13px;vertical-align: middle;text-align: center;height: 24px;cursor: pointer;">
					<option value="id">아이디</option>
					<option selected="" value="name">이름</option>
				</select>
				<input class="inputText" type="text" id="searchUser" name="keyword" onkeydown="return search_onkeydown(event)" style="width:200px">
				<a class="imgbtn imgbck" style="vertical-align: middle;height:22px;margin:0px">
					<span onclick="javascript:search();" style="height:22px;line-height:22px"><spring:message code = 'ezCommunity.t31' /></span>
				</a>
			</div>
		</div>
		<div style="width:100%;" id="divList">
			<div style="margin-top:10px; margin-left: 5px;margin-right: 5px;">
				<table class="mainlist" style ="width:100%;text-align:center;margin-top:15px;">
					<tr>
						<th style="width:20px;text-align: center;"></th>
						<th style="width:70px;text-align: center;"><spring:message code = 'ezCommunity.t10' /></th>
						<th style="width:70px;text-align: center;">아이디</th>
						<th style="width:70px;text-align: center;">부서</th>
						<th style="width:80px;text-align: center;"><spring:message code = 'ezCommunity.lyj16' /></th>
					</tr>
					<tbody id="idSpan">${idSpanValue}</tbody>
				</table>
			</div>
		</div>
		<div id="tblPageRayer" style="margin-top:10px"></div>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"	name="Submit2"	onclick="parent.parent.window.close()" ><span><spring:message code ='ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>