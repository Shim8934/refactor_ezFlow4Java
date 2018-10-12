<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<div class="layDIV">
	<dl class="portlet_title photo_board">
		<dt class="portletText" data1="${boardId }"><c:out value="${portletName }"/></dt>
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
<div class="layDIV">
    <dl class="portlet_title">
        <dt class="portletText"><c:out value="${portletName }"/></dt>
        <dd class="portletPlus" id="communityPlus"><img src="/images/kr/main/portlet_Plus.png"></dd>
    </dl>
    <div class="community_list">
    	<c:choose>
			<c:when test = "${fn:length(CommunityList) == 0 }">
				<ul class="portlet_list">
					<dl class="comListDL01">
						<dt class="comPic"><img src="/images/kr/main/comImg_none.png"></dt>
                        <dd class="comTit_none">"<spring:message code='main.t00026' />"</dd>
                    </dl>
                    <dl class="comListDL02">
                        <dt class="comPic"><img src="/images/kr/main/comImg_none.png"></dt>
                        <dd class="comTit_none">"<spring:message code='main.t00026' />"</dd>
                    </dl>
				</ul>
			</c:when>
			<c:when test = "${fn:length(CommunityList) == 1 }">
				<c:forEach var="commu" items="${CommunityList }" varStatus="i">
			        <dl class="comListDL0${i.count}" style="cursor:pointer" onclick="go_best('${commu.c_ClubNo}','${memberChk}')">
			        	<dt class="comPic">
			        		<span class="best"><img src="/images/kr/main/com_best.png"></span>
			        		<img src="/ezCommon/downloadAttach.do?filePath=/fileroot/0/files/upload_community/logo/C_5_thumbnail.png">
			        	</dt>
			        	<dd class="comTit">"${commu.c_ClubName } }"</dd>
			        	<dd class="comText">${commu.c_ClubDesc }</dd>
			        </dl>
		    	</c:forEach>
       			  <dl class="comListDL02">
                        <dt class="comPic"><img src="/images/kr/main/comImg_none.png"></dt>
                        <dd class="comTit_none">"<spring:message code='main.t00026' />"</dd>
                    </dl>
			</c:when>
			<c:otherwise>
				<c:forEach var="commu" items="${CommunityList }" varStatus="i">
			        <dl class="comListDL0${i.count}" style="cursor:pointer" onclick="go_best('${commu.c_ClubNo}','${memberChk}${i.count}')">
			        	<dt class="comPic">
			        		<span class="best"><img src="/images/kr/main/com_best.png"></span>
			        		<img src="/ezCommon/downloadAttach.do?filePath=/fileroot/0/files/upload_community/logo/C_5_thumbnail.png">
			        	</dt>
			        	<dd class="comTit">"${commu.c_ClubName } }"</dd>
			        	<dd class="comText">${commu.c_ClubDesc }</dd>
			        </dl>
		    	</c:forEach>
			</c:otherwise>
		</c:choose>	    	
    </div>
    
</div>
</body>
</html>