<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var folderType = "${folderType}";
			var subTypeC = "${subTypeC}";
			var PortletFolderId = "${PortletFolderId}";
			window.onload = function() {
				if(folderType == "") {
					folderType = "C"
				}
				// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: isDean으로 구분 추가
				// 2020-11-25 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: subTypeC으로 구분 수정
				var url = "/ezWebFolder/webfolderLeft.do?folderType=" + folderType + "&subTypeC=" + subTypeC + "&PortletFolderId=" + PortletFolderId;
				document.getElementById("left").src = url;
			}
		</script>
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="350,*" frameborder="0" border="0" scrolling="no">
			    <frame id="left" name="left" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" noresize>
	            <frame name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize>
		    </frameset>
    </frameset>
</html>
