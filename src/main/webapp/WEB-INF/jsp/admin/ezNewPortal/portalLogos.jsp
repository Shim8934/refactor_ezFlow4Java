<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Portal Logos</title>
<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
<style type="text/css">
.logoTitle {width:98%; padding:11px; background-color:#f3f2f2;font-size:15px;font-weight:bold;border:1px solid #747474;}
.logoIconInfo {display:inline-block;vertical-align:top;margin:23px;}
.logoIcon {width:250px;height:200px;border:1px solid black;margin-bottom:10px;text-align:center;vertical-align:middle;}
.logoIcon span, .logoIcon img {margin:36px;}
.logoContent {display:inline-block;margin-top:20px;}
.updateLogo {display : inline-block;}
.logoContent ul {margin-top:5px;padding-left:7px;}
.logoContent ul li {font-size:14px;font-weight:bold; display:block;padding:14px 0px;}
</style>
</head>
<body class="mainbody">
<h1>로고설정</h1>
<div id="mainmenu">    
	<span><b>회사선택 :</b> 
		<select id="ListCompany">
		</select><br /><br />
	</span>
</div>
<div class="loginLogo">
	<div class="logoTitle">로그인 페이지 로고 설정</div>
	<div class="logoInfo">
		<div class='logoIconInfo'>
			<div class='logoIcon'><span></span></div>
		</div>
		<div class="logoContent">
			<div class='btnpositionJsp updateLogo'><a class='imgbtn updateLogoBtn'><span>등록</span></a></div>
			<ul>
				<li># 홈페이지 접속 시, 로그인 상단의 로고의 이미지를 변경합니다.</li>
				<li># 가로 x 세로의 크기는 000(px) x 000(px) 입니다.</li>
			</ul>
		</div>
	</div>
</div>
<div class="portalLogo">
	<div class="logoTitle">상단 메뉴 로고 설정</div>
	<div class="logoInfo">
		<div class="logoInfo">
			<div class='logoIconInfo'>
			<div class='logoIcon'><span></span></div>
			</div>
			
			<div class="logoContent">
				<div class='btnpositionJsp updateLogo'><a class='imgbtn updateLogoBtn'><span>등록</span></a></div>
				<ul>
					<li># 홈페이지 접속 시, 로그인 상단의 로고의 이미지를 변경합니다.</li>
					<li># 가로 x 세로의 크기는 000(px) x 000(px) 입니다.</li>
				</ul>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">
$(function(){
	getCompanies();
});

var getCompanies = function() {
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/getCompanies.do', false);
	request.setRequestHeader('Content-Type', 'application/json');
	var companiesHTML = "";

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			var result = JSON.parse(request.responseText);
			
			var userCompany = result.userCompany;
			var companyList = result.list;
			
			companyList.forEach(function (item, index) {
				companiesHTML += "<option value=" + item.cn + ((item.cn == userCompany) ? ' selected>' : '>') + item.displayName + "</option>";
			});
			
			document.getElementById("ListCompany").innerHTML = companiesHTML;
			
			document.getElementById("ListCompany").addEventListener('change', function() {
				getThemes();
			});
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	request.send();
}
</script>
</body>
</html>