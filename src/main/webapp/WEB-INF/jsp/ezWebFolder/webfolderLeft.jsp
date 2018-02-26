<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" >
			var companyFolderId = "";
			var deptFolderId    = "";
			var persFolderId    = "";
			var userId          = "${userId}";
			var userName        = "${userName}";
			
			window.onload = function () {
			
			};
			
			function goPage(idx) {
				switch (idx) {
					case 3:
						var url = "/ezWebFolder/test.do";
						window.parent.frames["right"].location.href = url;
						break;
				}
			}
			
			function getCompanyList(folderType) {
				var folderID = null;
				switch(folderType) {
					case "1":
						folderID = companyFolderId;
						break;
					case "2":
						folderID = deptFolderId;
						break;
					case "3":
						folderID = persFolderId;
						break;
				}
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getFolderList.do",
					data: {
						"folderType" : folderType,
						"folderId"   : folderID
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.folderList;
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});	
			}
			function getFileList() {
				// + 버튼 누르면 오른쪽 화면 뜨고 오른쪽 화면에서 ajax로 띄움
				window.parent.frames["right"].location.href = "/ezWebFolder/main.do";
				
			}
			function treeTest() {
				window.parent.frames["right"].location.href = "/ezWebFolder/treeTest.do";
			}
			
			function getReceivedShare() {
				window.parent.frames["right"].location.href = "/ezWebFolder/getShareListPage.do";
			}
		</script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
		<div id="left" style="overflow: auto">
			<div class="left_webfolder" title="<spring:message code='ezWebFolder.t10' />"></div>
			<h2>
				<span style="display:inline-block;width:100%;" onclick="getCompanyList('1');">회사폴더</span>
			</h2>
			<ul>
				<li><span id="organ" style="width: 100%; display: inline-block;" onClick="" >가온아이</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onClick="" >하위폴더</span></li>
			</ul>
			<h2>
				<span style="display:inline-block;width:100%;">부서폴더</span>
			</h2>
			<ul>
				<li><span id="organ" style="width: 100%; display: inline-block;" onClick="goPage(3)">오픈솔루션팀</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onClick="">ezEKP</span></li>
			</ul>
				
			<h2>
				<span style="display:inline-block;width:100%;">개인폴더</span>
			</h2>
			<ul>
				<li><span id="organ" style="width: 100%; display: inline-block;" onClick="treeTest()">영화</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onClick="fileList()">문서</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onClick="getFileList()">파일</span></li>
			</ul>
			
			<h2>
				<span style="display:inline-block;width:100%;" onclick="getReceivedShare();">공유폴더</span>
			</h2>
			<ul>
				<li><span id="organ"     style="width: 100%; display: inline-block;" onclick="getReceivedShare();">공유받은 폴더</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onclick="getGivenShare();"   >공유한 폴더</span></li>
			</ul>
			
			<h2>
				<span style="display:inline-block;width:100%;">츨겨찾기</span>
			</h2>
			<ul>
				<li><span id="organ"     style="width: 100%; display: inline-block;" onClick="">테스트 5</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onClick="">테스트 6</span></li>
			</ul>
			
			<h2>
				<span style="display:inline-block;width:100%;" >휴지통</span>
			</h2>
			<ul>
				<li><span id="organ"     style="width: 100%; display: inline-block;" onClick="">테스트  7</span></li>
				<li><span id="privilege" style="width: 100%; display: inline-block;" onClick="">테스트  8</span></li>
			</ul>
			
			<h3>
				<span onclick="boardConfig()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.t0005" /></span>
			</h3>
			<c:if test="${applyFlag == 'OK'}">
				<h3 style="border-top:0px">
					<span onclick="Apprboard()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.t999001" /></span>
				</h3>
			</c:if>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>
