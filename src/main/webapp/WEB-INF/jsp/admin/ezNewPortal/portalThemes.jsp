<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalThemes</title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
<!-- 		opensource css -->
<!-- 		opensource css -->
		
	</head>
	
	<body class="mainbody">
		<h1>테마관리</h1>
		
		<div id="mainmenu">    
		    <span><b>회사선택 :</b> 
			    <select id="ListCompany">
			    </select><br /><br />
		    </span>
		</div>
		
		<div id="thumbnailGrid" class="main">
			<ul id="og-grid" class="og-grid">
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="1번 테마 제목" data-description="1번 테마 설명">
						<img src="/images/kr/main/nodata.png" alt="img01"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="2번 테마 제목" data-description="2번 테마 설명">
						<img src="/images/kr/main/nodata.png" alt="img02"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="3번 테마 제목" data-description="3번 테마 설명">
						<img src="/images/kr/main/nodata.png" alt="img03"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="Azuki bean" data-description="Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage soko coriander sweet pepper water spinach winter purslane shallot tigernut lentil beetroot.">
						<img src="/images/kr/main/nodata.png" alt="img01"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="Veggies sunt bona vobis" data-description="Komatsuna prairie turnip wattle seed artichoke mustard horseradish taro rutabaga ricebean carrot black-eyed pea turnip greens beetroot yarrow watercress kombu.">
						<img src="/images/kr/main/nodata.png" alt="img02"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="Dandelion horseradish" data-description="Cabbage bamboo shoot broccoli rabe chickpea chard sea lettuce lettuce ricebean artichoke earthnut pea aubergine okra brussels sprout avocado tomato.">
						<img src="/images/kr/main/nodata.png" alt="img03"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="Azuki bean" data-description="Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage soko coriander sweet pepper water spinach winter purslane shallot tigernut lentil beetroot.">
						<img src="/images/kr/main/nodata.png" alt="img01"/>
					</a>
				</li>
				<li>
					<a href="http://cargocollective.com/jaimemartinez/" data-largesrc="/images/kr/main/nodata.png" data-title="Veggies sunt bona vobis" data-description="Komatsuna prairie turnip wattle seed artichoke mustard horseradish taro rutabaga ricebean carrot black-eyed pea turnip greens beetroot yarrow watercress kombu.">
						<img src="/images/kr/main/nodata.png" alt="img02"/>
					</a>
				</li>
			</ul>
			
			<a id="og-additems" href="#">add more</a>
		</div>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	
	<!-- thumbGrid opensource -->
	<script type="text/javascript" src="${util.addVer('/js/thumbnailGrid/modernizr.custom.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/thumbnailGrid/grid.js')}"></script>
	
	<script type="text/javascript">
		$(function() {
			getCompanies();
			Grid.init();
		});
		
		var getCompanies = function() {
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getCompanies.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					
					var userCompany = result.userCompany;
					var companyList = result.list;
					var companiesHTML = "";
					
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
		
		var getThemes = function () {
			var companiesObj = document.getElementById("ListCompany");
			var companyValue = companiesObj.options[companiesObj.selectedIndex].value;
			
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/getThemes.do', true);
			request.setRequestHeader('Content-Type', 'application/json');
	
			request.onload = function() {
				if (request.status >= 200 && request.status < 400) {
					var result = JSON.parse(request.responseText);
					
					var themes = result.list;
					var themesHTML = "";
					
					themes.forEach(function (item, index) {
alert(index);
						//class 보고 찾아서  html 그림 그리면 그림 나오냐
						themesHTML += "<ul id='og-grid' class='og-grid'>";
						
						themesHTML += "<li>";
						themesHTML += "<a href='http://cargocollective.com/jaimemartinez/' data-largesrc='/images/kr/main/nodata.png' data-title='Veggies sunt bona vobis' data-description='Komatsuna prairie turnip wattle seed artichoke mustard horseradish taro rutabaga ricebean carrot black-eyed pea turnip greens beetroot yarrow watercress kombu.'>";
						themesHTML += "<img src='/images/kr/main/nodata.png' alt='img02'/>";
						themesHTML += "</a>";
						themesHTML += "</li>";
					
						themesHTML += "</ul>";
					});
					
					document.getElementById("thumbnailGrid").innerHTML = companiesHTML;
				} else {
					// We reached our target server, but it returned an error
				}
			};
	
			request.onerror = function() {
			  // There was a connection error of some sort
			};
			
			var data = JSON.stringify({
				companyId : companyValue
			});
			
			request.send(data);
		}
	</script>
</html>