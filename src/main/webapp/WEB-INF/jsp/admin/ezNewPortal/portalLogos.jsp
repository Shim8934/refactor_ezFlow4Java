<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezNewPortal.t057' /></title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<style type="text/css">
			.logoTitle {padding:0px;font-size: 14px !important;font-weight:bold;margin: 0px 0px 5px 0px;}
	         .logoIconInfo {display:inline-block;vertical-align:top;margin:10px 10px 20px 0px;}
	         .logoIcon {width:250px;height:135px;border:1px solid #d9d9d9;margin-bottom:10px;text-align:center;vertical-align:middle;}
	         .logoIcon span, .logoIcon img {margin:48px;}
	         .logoContent {display:inline-block; }
	         .btnpositionJsp {display : inline-block;}
	         .logoContent ul {margin-top:5px;padding-left:7px;}
	         .logoContent ul li {font-size: 12px;display:block;padding: 2px 0px;}
	         .deleteLogoBtn {display : none;}
	         .loginLogo .logoIcon img {width:137px; height:38px;}
	         .portalLogo .logoIcon img {width:106px; height:42px;}
		</style>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezNewPortal.t057' />
			<select class="companySelect" id="ListCompany"></select>
		</h1>
		<div class="loginLogo" style="margin-top:30px">
			<div class="logoInfo">
				<div class='logoIconInfo'>
					<div class='logoIcon'><img></img></div>
				</div>
				<div class="logoContent">
					<c:if test="${adminCheck eq true }">
						<div id = "imgLogin" class='btnpositionJsp'><a class='imgbtn updateLogoBtn'><span><spring:message code='ezNewPortal.t058' /></span></a> <a class='imgbtn deleteLogoBtn'><span><spring:message code='ezNewPortal.t059' /></span></a></div>
					</c:if>
					<c:if test="${adminCheck eq false }">
						<div class='btnpositionJsp'></div>
					</c:if>
					<ul>
						<li class="logoTitle"><spring:message code='ezNewPortal.t060' /></li>
						<li><spring:message code='ezNewPortal.t061' /></li>
						<li><spring:message code='ezNewPortal.t062' /></li>
						<li><spring:message code='ezNewPortal.t063' /></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="portalLogo">
			<div class="logoInfo">
				<div class="logoInfo">
					<div class='logoIconInfo'>
					<div class='logoIcon'><img></img></div>
					</div>
					
					<div class="logoContent">
						<div id="imgTop" class='btnpositionJsp'><a class='imgbtn updateLogoBtn'><span><spring:message code='ezNewPortal.t058' /></span></a> <a class='imgbtn deleteLogoBtn'><span><spring:message code='ezNewPortal.t059' /></span></a></div>
						<ul>
							<li class="logoTitle"><spring:message code='ezNewPortal.t064' /></li>
							<li><spring:message code='ezNewPortal.t065' /></li>
							<li><spring:message code='ezNewPortal.t066' /></li>
						</ul>
					</div>
				</div>
			</div>
		</div>

		<input id="imgFile" type="file" style="display:none" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			window.onload = function(){
				getCompanies();
				getLogos();
				var updateLogoList = document.getElementsByClassName("updateLogoBtn");
				var deleteLogoList = document.getElementsByClassName("deleteLogoBtn");
				var updateLogoListCount = updateLogoList.length;
				
				for (var i = 0; i < updateLogoListCount; i++) {
					updateLogoList[i].addEventListener("click", uploadImgBtn);
					deleteLogoList[i].addEventListener("click", deleteLogo);
				}
	
				document.getElementById("imgFile").addEventListener("change", imgUpload);
			}

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
						var logoDefault = result[i].logoDefault;
						
						if (logoType == "L") {
							
							document.getElementsByClassName("loginLogo")[0].querySelectorAll(".logoIcon")[0].querySelector("img").src = logoUrl;
							
							if (!logoDefault) {
								if (document.getElementById("imgLogin")) {
									document.getElementById("imgLogin").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t067' />";
									document.getElementById("imgLogin").querySelectorAll(".deleteLogoBtn")[0].style.display = "inline-block";
								}
							} else {
								if (document.getElementById("imgLogin")) {
									document.getElementById("imgLogin").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t058' />";
									document.getElementById("imgLogin").querySelectorAll(".deleteLogoBtn")[0].style.display = "none";
								}
							}
							
						} else if (logoType == "P") {
							document.getElementsByClassName("portalLogo")[0].querySelectorAll(".logoIcon")[0].querySelector("img").src = logoUrl;
							
							if (!logoDefault) {
								document.getElementById("imgTop").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t067' />";
								document.getElementById("imgTop").querySelectorAll(".deleteLogoBtn")[0].style.display = "inline-block";
							} else {
								document.getElementById("imgTop").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t058' />";
								document.getElementById("imgTop").querySelectorAll(".deleteLogoBtn")[0].style.display = "none";
							}
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
				document.getElementById("imgFile").setAttribute("data1", this.parentElement.id);
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
    			}
    
    			fd.append("file", _file);
    			fd.append("companyId", companyValue);
    			fd.append("logoType", logoType);
    			
    			var request = new XMLHttpRequest();
    
    			if ( ext == "jpeg" || ext == "jpg" || ext == "png" || ext == "bmp" || ext == "gif") {
	    			request.open("POST", "/admin/ezNewPortal/uploadLogo.do");
	    			request.send(fd);
	    
	    			request.onload = function() {
	    				var result = request.responseText;
	    	
	    				if (result == "rejected") {
	    					alert("<spring:message code='ezNewPortal.t068' />");
	    					return;
	    				}
	    				
	    				if (logoType == "L") {
	    					document.getElementsByClassName("loginLogo")[0].querySelectorAll(".logoIcon")[0].querySelector("img").src = result;
	    					
	    					if (document.getElementById("imgLogin")) {
								document.getElementById("imgLogin").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t067' />";
								document.getElementById("imgLogin").querySelectorAll(".deleteLogoBtn")[0].style.display = "inline-block";
	    					}
	    				} else if (logoType == "P") {
	    					document.getElementsByClassName("portalLogo")[0].querySelectorAll(".logoIcon")[0].querySelector("img").src = result;
	    					
							document.getElementById("imgTop").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t067' />";
							document.getElementById("imgTop").querySelectorAll(".deleteLogoBtn")[0].style.display = "inline-block";
	    				}
	    			}
    			} else {
    				alert("<spring:message code = 'ezCommunity.lhj03' /> (jpg, png, bmp, jpeg, gif)");
    				return false;
    			}
			}

			var deleteLogo = function() {
				var response = confirm("<spring:message code='ezNewPortal.t069' />");
	
				if (response) {
					var companiesObj = document.getElementById("ListCompany");
					var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
					var logoType = this.parentElement.getAttribute("id");
	    
					if (logoType == "imgLogin") {
						logoType = "L";
					} else if (logoType == "imgTop") {
						logoType = "P";
					}
					
					var request = new XMLHttpRequest();
					request.open("POST", "/admin/ezNewPortal/deleteLogo.do", true);
					request.setRequestHeader('content-type', 'application/json');
	    
					request.onload = function() {
						var logoUrl = "";
	    	
						if (logoType == "L") {
							document.getElementById("imgLogin").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t058' />";
							document.getElementById("imgLogin").querySelectorAll(".deleteLogoBtn")[0].style.display = "none";
							logoUrl = "/images/kr/login/logo.gif";
							document.getElementsByClassName("loginLogo")[0].querySelector(".logoIcon").querySelector("img").src = logoUrl;
							
						} else if (logoType == "P") {
							document.getElementById("imgTop").querySelectorAll(".updateLogoBtn")[0].querySelector("span").textContent = "<spring:message code='ezNewPortal.t058' />";
							document.getElementById("imgTop").querySelectorAll(".deleteLogoBtn")[0].style.display = "none";
	    					logoUrl = "/files/upload_portal/Top/Logo/logo.gif";
	    					document.getElementsByClassName("portalLogo")[0].querySelector(".logoIcon").querySelector("img").src = logoUrl;
							
	    				}
	    			}
					var data = JSON.stringify({
						companyId : companyValue,
						logoType : logoType
					});
		
	    			request.send(data);
				} else {
					return;
				}
	
			}
		</script>
	</body>
</html>