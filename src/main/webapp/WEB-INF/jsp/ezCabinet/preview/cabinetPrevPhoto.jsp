<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height: 100%; width: 100%;">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="cabphotfull">
		<div class="cabphotowrap">
			<div class="cabphotomain">
				<div class="cabphotobttn2"><img id="mainprevious" class="cabphotooff" src="/images/previous.png"></div>
				<div class="cabphotslide" ><img id="mainPhoto"    class="cabmainphoto"                          ></div>
				<div class="cabphotobttn2"><img id="mainnext"     class="cabphotooff" src="/images/next.png"    ></div>
			</div>
			<div class="cabphotodes" id="photoDescription"></div>
			<div class="cabphotoprev">
				<div class="cabphotobttn"><img id="prevprevious" class="cabphotooff" src="/images/previous.png"></div>
				<div class="cabphotoprevmain">
					<div class="cabphotowrp">
						<ul class="cabphotoul">
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
							<li><img></li>
						</ul>
					</div>
				</div>
				<div class="cabphotobttn"><img id="prevnext" class="cabphotooff" src="/images/next.png"></div>
			</div>
		</div>
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')}"></script>
		<script type="text/javascript">
			(function() {
				var imageList   = null;
				var crrPhotoIdx = 0;
				var blockImg    = 10;
				var totalImg    = -1;
				
				initEvents();
				function initEvents() {
					document.onselectstart = function() {return false;};
					window.addEventListener("resize", function(e) {windowResize();}, false);
					getImageList();
					
					var mainnxtbttn  = document.getElementById("mainnext");
					var mainprvbttn  = document.getElementById("mainprevious");
					var slidenxtbttn = document.getElementById("prevnext");
					var slideprebttn = document.getElementById("prevprevious");
					totalImg         = imageList.length;
					
					if (totalImg > 1) {
						mainnxtbttn.removeAttribute("class");
						if (totalImg > blockImg) {
							slidenxtbttn.removeAttribute("class");
						}
					}
					
					showNewMainPhoto(crrPhotoIdx);
					var ulElmt  = document.querySelector("ul[class='cabphotoul']");
					var liList  = ulElmt.children;
					liList[0].firstElementChild.className = "selectedImg";
					
					if (totalImg < 10) {
						var unnecessaryLiCnt = 10 - totalImg;
						for (var i = 0; i < unnecessaryLiCnt; i++) {
							ulElmt.removeChild(ulElmt.lastElementChild);
						}
					}
					
					for (var i = 0, len = liList.length; i < len; i++) {
						var imgElmt = liList[i].firstElementChild;
						if (i < totalImg) {
							imgElmt.src     = imageList[i]["filePath"];
							imgElmt.onclick = function(e) {selectPhoto(this);};
						}
						else {
							imgElmt.style.display = "none";
						}
					}
					
					mainnxtbttn.onclick  = function(e) {displayNextPhoto();};
					mainprvbttn.onclick  = function(e) {displayPreviousPhoto();};
					slidenxtbttn.onclick = function(e) {displayNextBlockPhoto();};
					slideprebttn.onclick = function(e) {displayPreviousBlockPhoto();};
				}
				
				function getImageList() {
					var imageObj = null;
					if (parent.CabinetItem)           {imageObj  = parent.CabinetItem.getContent();}
					else if (parent.CabinetBoardPhoto) {imageObj = parent.CabinetBoardPhoto.getContent();}
					else {alert(CabinetMessages.strError);}
					
					if (imageObj) {imageList = imageObj.attach;}
				}
				
				function displayNextPhoto() {
					if (crrPhotoIdx == totalImg - 1) {return;}
					if (((crrPhotoIdx + 1) % blockImg) == 0) {
						displayNextBlockPhoto();
					}
					else {
						crrPhotoIdx = crrPhotoIdx + 1;
						showNewMainPhoto(crrPhotoIdx);
					}
				}
				
				function displayPreviousPhoto() {
					if (crrPhotoIdx == 0) {return;}
					if (crrPhotoIdx > 1 && (crrPhotoIdx % blockImg) == 0) {
						displayPreviousBlockPhoto();
					}
					else {
						crrPhotoIdx = crrPhotoIdx - 1;
						showNewMainPhoto(crrPhotoIdx);
					}
				}
				
				function displayNextBlockPhoto() {
					var currentPage = Math.floor(crrPhotoIdx/blockImg) + 1;
					var totalPage   = Math.floor((totalImg - 1)/blockImg) + 1;
					
					if (currentPage < 1 || currentPage >= totalPage) {return;}
					
					if ((currentPage + 1) >= totalPage) {
						document.getElementById("prevnext").className = "cabphotooff";
					}
					else {
						document.getElementById("prevnext").removeAttribute("class");
					}
					
					document.getElementById("prevprevious").removeAttribute("class");
					
					crrPhotoIdx = currentPage * blockImg;
					reloadImagesByNext(crrPhotoIdx);
					showNewMainPhoto(crrPhotoIdx)
				}
				
				function displayPreviousBlockPhoto() {
					var currentPage = Math.floor(crrPhotoIdx/blockImg) + 1;
					var totalPage   = Math.floor((totalImg - 1)/blockImg) + 1;
					
					if (currentPage <= 1 || currentPage > totalPage) {return;}
					
					if (currentPage == 2) {
						document.getElementById("prevprevious").className = "cabphotooff";
					}
					else {
						document.getElementById("prevprevious").removeAttribute("class");
					}
					
					document.getElementById("prevnext").removeAttribute("class");
					
					crrPhotoIdx = (currentPage - 1) * blockImg - 1;
					reloadImagesByPrevious(crrPhotoIdx);
					showNewMainPhoto(crrPhotoIdx)
				}
				
				function windowResize() {
					var ulElmt   = document.querySelector("ul[class='cabphotoul']");
					var ulWidth  = ulElmt.offsetWidth;
					var newBlock = Math.floor(ulWidth/68);
					
					if (newBlock > 10) {newBlock = 10;}
					
					if (newBlock != blockImg) {
						blockImg        = newBlock;
						var currentPage = Math.floor(crrPhotoIdx/newBlock) + 1;
						var totalPage   = Math.floor((totalImg - 1)/newBlock) + 1;
						var newStartIdx = (currentPage - 1) * newBlock;
						var newSltIdx   = crrPhotoIdx - newStartIdx;
						
						if ((currentPage + 1) > totalPage) {
							document.getElementById("prevnext").className = "cabphotooff";
						}
						else {
							document.getElementById("prevnext").removeAttribute("class");
						}
						
						if (currentPage == 1) {
							document.getElementById("prevprevious").className = "cabphotooff";
						}
						else {
							document.getElementById("prevprevious").removeAttribute("class");
						}
						
						reloadImagesByNext(newStartIdx);
						showNewMainPhoto(crrPhotoIdx);
					}
				}
				
				function showNewMainPhoto(index) {
					if (index < 0 || index >= totalImg) {return;}
					if (index == 0) {
						document.getElementById("mainprevious").className = "cabphotooff";
					}
					else {
						if (index == (totalImg - 1)) {
							document.getElementById("mainnext").className = "cabphotooff";
						}
						else {
							document.getElementById("mainnext").removeAttribute("class");
							document.getElementById("mainprevious").removeAttribute("class");
						}
					}
					
					document.getElementById("photoDescription").textContent = imageList[index]["fileDescription"];
					document.getElementById("mainPhoto").src                = imageList[index]["filePath"];
					var ulElmt = document.querySelector("ul[class='cabphotoul']");
					var liList = ulElmt.children;
					for (var i = 0, len = liList.length; i < len; i++) {
						liList[i].firstElementChild.removeAttribute("class");;
					}
					
					liList[index % blockImg].firstElementChild.className = "selectedImg";
				}
				
				function reloadImagesByNext(index) {
					var ulElmt = document.querySelector("ul[class='cabphotoul']");
					var liList = ulElmt.children;
					var imgCnt = totalImg - index;
					var len    = liList.length;
					
					if (imgCnt <= 10) {
						for (var i = 0; i < imgCnt; i++) {
							var imgElmt = liList[i].firstElementChild;
							imgElmt.removeAttribute("style");
							imgElmt.src = imageList[i + index]["filePath"];
						}
						
						for (var i = imgCnt; i < len; i++) {
							liList[i].firstElementChild.style.display = "none";
						}
					}
					else {
						var crrIdx = index;
						for (var i = 0; i < len; i++, crrIdx++) {
							var imgElmt = liList[i].firstElementChild;
							imgElmt.removeAttribute("style");
							imgElmt.src = imageList[crrIdx]["filePath"];
						}
					}
				}
				
				function reloadImagesByPrevious(index) {
					var ulElmt = document.querySelector("ul[class='cabphotoul']");
					var liList = ulElmt.children;
					var crrIdx = index;
					for (var i = blockImg - 1; i >= 0; i--, crrIdx--) {
						var imgElmt = liList[i].firstElementChild;
						imgElmt.removeAttribute("style");
						imgElmt.src = imageList[crrIdx]["filePath"];
					}
				}
				
				function selectPhoto(imgElmt) {
					var liElmt      = imgElmt.parentElement;
					var ulElmt      = liElmt.parentElement;
					var selectedImg = ulElmt.querySelector("img[class='selectedImg']");
					
					if (selectedImg == imgElmt) {return;}
					
					var selectedLi  = selectedImg.parentElement;
					var liIndex     = getLiIndex(liElmt);
					var slIndex     = getLiIndex(selectedLi);
					var distance    = liIndex - slIndex ;
					crrPhotoIdx     = crrPhotoIdx + distance;
					
					showNewMainPhoto(crrPhotoIdx);
				}
				
				function getLiIndex(liElmt) {
					for (var i = 0; liElmt = liElmt.previousElementSibling ; i++);
					return i;
				}
			})();
		</script>
	</body>
</html>