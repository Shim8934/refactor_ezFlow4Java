<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalMenus</title>
		<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<style type="text/css">
			body {background-color : white;}
			#menuList li {display : inline-block;width : 100px; border : 1px solid #000000; margin : 10px;}
			.menu dl dt {text-align : center;display : block;height : 42px;margin : 0px;	padding : 0px;}
			.menu dl dd {display:table-cell; width : 98px; height:56px; margin:0px; padding:0px 5px; text-align:center; vertical-align:middle; font-size:15px; font-weight:bold; letter-spacing:-1px;}
			span.icon_topmenu {margin-top : 20px;}
			.menuUsed {background-color : #b0e4ff;}
			.menuNotUsed {background-color : #cbcbcb;}
		</style>
	</head>
	
	<body class="mainbody">
		<h1>메뉴관리</h1>
		
		<div id="mainmenu">    
		    <span><b>회사선택 :</b> 
			    <select id="ListCompany">
			    </select><br /><br />
		    </span>
		</div>
		
		<ul id="menuList">
		</ul>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		$(function(){
			getCompanies();
			getMenus();
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
		
		var getMenus = function() {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getMenus.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					var menuList = result.list;
					var menusHTML = "";
					
					menuList.forEach(function (item, index) {
						menusHTML += "<li class='menu' id='menu" + item.menuId + "'>";
						menusHTML += "<dl>";
						menusHTML += "<dt><span class='" + item.iconUrl + "'>";
						menusHTML += "</span></dt>";
						menusHTML += "<dd>" + item.menuName + "</dd>";
						menusHTML += "</li>";
					});
					
					$("#menuList").html(menusHTML);
					
					menuList.forEach(function (item, index) {
						if (item.menuUsed) {
							$("#menu" + item.menuId).addClass("menuUsed");
						} else {
							$("#menu" + item.menuId).addClass("menuNotUsed");
						}
						
					});
				}
			};
			
			request.onerror = function() {}
			
			var data = JSON.stringify({
				companyId : companyValue
			});
			
			request.send(data);
		}
	</script>
</html>