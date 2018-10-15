<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
var clubNo = "";
var CommuSize = "${CommuSize}";
for (var i=1; i < CommuSize; i ++) {	
	clubNo = $('.comListDL0'+i).attr('data1');
	
	$('.comListDL0'+i).on("click",{ clubNo : clubNo }, view_bestCommunity);
}

function view_bestCommunity(clubNo) {
	
	var clubType = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezNewPortal/getCommunityPermit.do",
		data : {
				clubNo	:	clubNo,
			   },
		success: function(result){
			clubType = result;
		}
	});
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezCommunity/remote/getACL.do",
		data : { cID	:	clubNo,
				 uID	:	"${userId}"
		},
		success: function(result){
			
			if (result == "ERR" || clubType == "1") {
				OpenAlertUI("<spring:message code='main.t1004'/><br><spring:message code='main.t1005'/>", null, "/ezPortal/wpNewCommunity.do.OpenAlertUI");
			} else {
				var wWeight = "1300";
                var wHeight = "900";

                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;

                var left = (width - wWeight) / 2;
                var top = (heigth - wHeight) / 2 - 30;

                var ret = window.open("/ezCommunity/checkCommHome.do?communityCD=" + idx, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			}
		}
	});
}
</script>
</head>
<body>
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
				<c:forEach var="commu" begin="0" end="1" items="${CommunityList }" varStatus="i">
			        <dl class="comListDL0${i.count}" data1="${commu.c_ClubNo}" style="cursor:pointer">
			        	<dt class="comPic">
			        		<span class="best"><img src="/images/kr/main/com_best.png"></span>
			        		<c:choose>
				        		<c:when test = "${commu.c_Logo_Thumbnail == 'default_logo_type'}">
				        			<img src="/images/ezCommunity/logo/${commu.c_Logo_Thumbnail}">
				        		</c:when>
				        		<c:otherwise>
					        		<img src="/ezCommon/downloadAttach.do?filePath=${commuPath}/${commu.c_Logo_Thumbnail}">
				        		</c:otherwise>
			        		</c:choose>
			        		
			        	</dt>
			        	<dd class="comTit">"${commu.c_ClubName }"</dd>
			        	<dd class="comText">${commu.c_ClubDesc }</dd>
			        </dl>
		    	</c:forEach>
       			  <dl class="comListDL02">
                        <dt class="comPic"><img src="/images/kr/main/comImg_none.png"></dt>
                        <dd class="comTit_none">"<spring:message code='main.t00026' />"</dd>
                    </dl>
			</c:when>
			<c:otherwise>
				<c:forEach var="commu" begin="0" end="1" items="${CommunityList }" varStatus="i">
			        <dl class="comListDL0${i.count}" data1="${commu.c_ClubNo}" style="cursor:pointer">
			        	<dt class="comPic">
						<c:if test="${i.count == 0}">
							<span class="best"><img src="/images/kr/main/com_best.png"></span>
						</c:if>
			        		<c:choose>
				        		<c:when test = "${commu.c_Logo_Thumbnail == 'default_logo_type'}">
				        			<img src="/images/ezCommunity/logo/${commu.c_Logo_Thumbnail}">
				        		</c:when>
				        		<c:otherwise>
					        		<img src="/ezCommon/downloadAttach.do?filePath=${commuPath}/${commu.c_Logo_Thumbnail}">
				        		</c:otherwise>
			        		</c:choose>
			        	</dt>
			        	<dd class="comTit">"${commu.c_ClubName }"</dd>
			        	<dd class="comText">${commu.c_ClubDesc }</dd>
			        </dl>
		    	</c:forEach>
			</c:otherwise>
		</c:choose>	    	
    </div>
    
</div>
</body>
</html>