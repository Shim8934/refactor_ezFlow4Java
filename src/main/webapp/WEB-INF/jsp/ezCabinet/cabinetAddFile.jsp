<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup">
		<h1><spring:message code="ezCabinet.t67"/></h1> 
<%-- 		<div id="close">
			<ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul>
		</div> --%>
		
		<div class="divInfo">
			<table class="tblFileInf">
				<tr><th>제목</th><td><input type="text" placeholder="<spring:message code='ezCabinet.t70'/>"></td></tr>
				<tr><th>요약</th><td><input type="text" placeholder="<spring:message code='ezCabinet.t71'/>"></td></tr>
				<tr>
					<th>연관문서</th>
					<td><div class="rlFileDiv"><input type="text"><a><span>선택</span></a></div></td>
				</tr>
			</table>
		</div>
		
		<div class="fileUploadDiv" id="fileDiv">
			<div class="fileList">
				<ul class="ulFiles">
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/hello.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/add.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/add.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/add.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/add.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/add.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
					<li>
						<div class="cabDivFile">
							<div class="cabImgAva"><img src="/images/add.png"></div>
							<div class="cabFileInf">
								<span>Nhung chu linh chi dung cam.pdf</span>
								<span>254 MB</span>
							</div>
						</div>
					</li>
				</ul>
			</div>
			<div class="divInform" style="display: none;">
				<span><spring:message code='ezCabinet.t68'/></span>
				<span><spring:message code='ezCabinet.t69'/></span>
			</div>
		</div>
		
		<div class="cabBttnDiv">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<script type="text/javascript">
			(function() {
				initEvents();
				
				function initEvents() {
					document.onselectstart = function () { return false;};
					//var closeBttn          = document.getElementById("close").firstElementChild.firstElementChild.firstElementChild;
					//closeBttn.onclick      = function(e) {closeWindow();};
					var cabdivBttnElmt      = document.getElementsByClassName("cabBttnDiv")[0];
					var listBttns           = cabdivBttnElmt.children;
					listBttns[0].onclick    = function(e) {};
					listBttns[1].onclick    = function(e) {closeWindow();};
				}
				
				function closeWindow() {window.close();}
				
			})();
		</script>
	</body>
</html>