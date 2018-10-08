<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PhotoBoard Portlet</title>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
<script type="text/javascript">
var page = 1;
var photoCount = 4;
var boardId = "<c:out value='${boardId}'/>";
var portletId = "<c:out value='${portletId}'/>";

$(function(){
	$(".nextBtn").on("click", moveNextPage);
	$(".preBtn").on("click", movePrevPage);
	$("#photoBoardPlus").on("click", viewBoardList);
})

function moveNextPage() {
	page = page + 1;
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/getPhotoItemList.do",
		data : {"boardId" : boardId, "page" : page, "photoCount" : photoCount, "portletId" : portletId},
		success : function(result) {
			if (result.length > 0) {
				var resultCount = result.length;
				var strHTML = "";
				
				for (var i = 0; i < resultCount; i++) {
					strHTML += "<li>";
					strHTML += "<img src='" + result[i].filePath + "', data1='" + result[i].boardID + "' data2='" + result[i].itemID + "' onclick='photoItemRead(this)'>";
					strHTML += "</li>";
					
				}
				
				$("#photoul").html(strHTML);
			} else {
				page = page - 1;
			}
		}
	})
}

function movePrevPage() {
	if (page !== 1) {
		page = page - 1;
		
		$.ajax({
			type : "POST",
			dataType : "json",
			url : "/ezNewPortal/getPhotoItemList.do",
			data : {"boardId" : boardId, "page" : page, "photoCount" : photoCount, "portletId" : portletId},
			success : function(result) {
				var resultCount = result.length;
				var strHTML = "";
				
				for (var i = 0; i < resultCount; i++) {
					strHTML += "<li>";
					strHTML += "<img src='" + result[i].filePath + "', data1='" + result[i].boardID + "' data2='" + result[i].itemID + "' onclick='photoItemRead(this)'>";
					strHTML += "</li>";
					
				}
				
				$("#photoul").html(strHTML);
			}
		})
	}
}

function viewBoardList() {
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + boardId, "main", "");
}

function photoItemRead(elem) {
	var ShowAdjacent = "";
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 789) / 2;
	var pLeft = (pwidth - 765) / 2;
	
	if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
		var height = 789;
	} else {
		var height = 785;
	}
	
	window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=" + ShowAdjacent + "&itemID=" + elem.getAttribute("data2") + "&boardID=" + elem.getAttribute("data1"), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
}
</script>
</head>
<body>
<div class="layDIV">
	<dl class="portlet_title photo_board">
		<dt class="portletText"><c:out value="${portletName }"/></dt>
		<dd class="portletPlus" id="photoBoardPlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
	<c:if test="${access eq 'true' }">
		<dd class="nextBtn"><img src="/images/ezNewPortal/photo_next.png"></dd>
		<dd class="preBtn"><img src="/images/ezNewPortal/photo_pre.png"></dd>
	</dl>
	<ul class="photoList" id="photoul">
		<c:forEach items="${photoBoardList }" var="photo">
		 	<li><img src="${photo.filePath }" data1="${photo.boardID }" data2="${photo.itemID }" onclick="photoItemRead(this)"></li>
		</c:forEach>
	</ul>
	</c:if>
	<c:if test="${access eq 'false' }">
	</dl>
	<ul class="portlet_list">
		<dl class="nodata">
			<dt><img src="/images/ezNewPortal/nodata.png"></dt>
			<dd>해당 게시판의 접근 권한이 없습니다.</dd>
		</dl>
	</ul>
	</c:if>
</div>
</body>
</html>