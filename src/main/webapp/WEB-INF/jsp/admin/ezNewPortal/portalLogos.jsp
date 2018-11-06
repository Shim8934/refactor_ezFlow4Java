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
.logoIcon span, .logoIcon img {margin:50px;}
img {width:150px; height:100px;}
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
			<div class='logoIcon'><img></img></div>
		</div>
		<div class="logoContent">
			<div id = "imgLogin" class='btnpositionJsp updateLogo'><a class='imgbtn updateLogoBtn'><span>등록</span></a></div>
			<ul>
				<li># 로그인 로고의 이미지를 변경합니다.</li>
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
			<div class='logoIcon'><img></img></div>
			</div>
			
			<div class="logoContent">
				<div id="imgTop" class='btnpositionJsp updateLogo'><a class='imgbtn updateLogoBtn'><span>등록</span></a></div>
				<ul>
					<li># 홈페이지 접속 후, 상단의 로고의 이미지를 변경합니다.</li>
					<li># 가로 x 세로의 크기는 000(px) x 000(px) 입니다.</li>
				</ul>
			</div>
		</div>
	</div>
</div>

<input id="imgFile" type="file" style="display:none" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">
$(function(){
	getCompanies();
	getLogos();
	var updateLogoList = document.getElementsByClassName("updateLogo");
	var updateLogoListCount = updateLogoList.length;
	
	for (var i = 0; i < updateLogoListCount; i++) {
		updateLogoList[i].addEventListener("click", uploadImgBtn);
	}
	
	document.getElementById("imgFile").addEventListener("change", imgUpload);
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
				getLogos();
			});
			
			if (companyList.length > 1) {
				var companyLogoHTML = "";
				
				companyLogoHTML += "<div class='companyLogo'>";
				companyLogoHTML += "<div class='logoTitle'>대표 메뉴 로고 설정</div>";
				companyLogoHTML += "<div class='logoInfo'>";
				companyLogoHTML += "<div class='logoInfo'>";
				companyLogoHTML += "<div class='logoIconInfo'>";
				companyLogoHTML += "<div class='logoIcon'><img></img></div>";
				companyLogoHTML += "</div>";
				companyLogoHTML += "<div class='logoContent'>";
				companyLogoHTML += "<div id='imgCompany' class='btnpositionJsp updateLogo'><a class='imgbtn updateLogoBtn'><span>등록</span></a></div>";
				companyLogoHTML += "<ul>";
				companyLogoHTML += "<li># 회사의 대표 로그인 로고의 이미지를 변경합니다.</li>";
				companyLogoHTML += "<li># 가로 x 세로의 크기는 000(px) x 000(px) 입니다.</li>";
				companyLogoHTML += "</ul></div></div></div></div>";
				
				$("body").append(companyLogoHTML);
			}
		} else {
			// We reached our target server, but it returned an error
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	request.send();
}

var getLogos = function() {
	var companiesObj = document.getElementById("ListCompany");
	var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
	
	var request = new XMLHttpRequest();
	request.open('POST', '/admin/ezNewPortal/getCompanyLogos.do', true);
	request.setRequestHeader('content-type', 'application/json');
	
	request.onload = function() {
		var result = JSON.parse(request.responseText);
		var logoCount = result.length;
		
		for (var i = 0; i < logoCount; i++) {
			var logoType = result[i].logoType;
			var logoUrl = result[i].logoUrl;
			
			if (logoType == "L") {
				$(".loginLogo").find(".logoIcon").find("img").attr("src", logoUrl);
			} else if (logoType == "P") {
				$(".portalLogo").find(".logoIcon").find("img").attr("src", logoUrl);
			} else if (logoType == "R") {
				$(".companyLogo").find(".logoIcon").find("img").attr("src", logoUrl);
			}
		}
		
	}

	request.onerror = function() {}
	
	var data = JSON.stringify({
		companyId : companyValue
	});
	 
	request.send(data);
}

var uploadImgBtn = function (obj){
	tempObj = obj;
	console.log(tempObj);
	console.log(this.id);
	document.getElementById("imgFile").setAttribute("data1", this.id);
    document.getElementById("imgFile").click();
}

var imgUpload = function () {
	var companiesObj = document.getElementById("ListCompany");
	var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
	
	var fd = new FormData();		    	
	var _file = document.getElementById("imgFile").files[0];    	
	var ext = _file.name.split('.').pop().toLowerCase();
	
	if (_file.size / 1024 / 1024 > 5) {
        alert("<spring:message code = 'ezPoll.t208' />");
        return;
    }	 
    var logoType = document.getElementById("imgFile").getAttribute("data1");
    
    if (logoType == "imgLogin") {
    	logoType = "L";
    } else if (logoType == "imgTop") {
    	logoType = "P";
    } else if (logoType == "imgCompany") {
    	logoType = "R";
    }
    
    fd.append("file", _file);
    fd.append("companyId", companyValue);
    fd.append("logoType", logoType);
    
    var request = new XMLHttpRequest();
    
    if ( ext=="jpeg" || ext == "jpg" || ext == "png" || ext == "bmp") {
	    request.open("POST", "/admin/ezNewPortal/uploadLogo.do");
	    request.send(fd);
	    
	    request.onload = function() {
	    	var result = request.responseText;
	    	
	    	if (logoType == "L") {
	    		$(".loginLogo").find(".logoIcon").find("img").attr("src", result);
	    	} else if (logoType == "P") {
	    		$(".portalLogo").find(".logoIcon").find("img").attr("src", result);
	    	} else if (logoType == "R") {
	    		$(".companyLogo").find(".logoIcon").find("img").attr("src", result);
	    	}
	    	
	    }
    } else {
    	alert("<spring:message code = 'ezCommunity.lhj03' /> (jpg, png, bmp)");
    	return false;
    }
}
</script>
</body>
</html>