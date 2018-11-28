<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>EmployeeofMonth</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/slick.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPersonal/slick-theme.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/slick.js')}"></script>
		<style type="text/css">
		* {box-sizing: border-box;}
		.calSlider {width: 85% !important; margin-left: 25px; border-top: 2px solid; border-bottom: 1px solid #c8ccd0;}
		.slick-slide {margin: 0px 3px;}
		.slick-slide img {width: 100% !important;}
		.slick-prev:before, .slick-next:before {color: black;}
		.slick-center {color: red;}
		.yearDiv {height: 38px; /* border: 1px solid #c8ccd0; */ }
		.yearSpan {text-align: center; font-size: 20px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden; letter-spacing: -1px; line-height: 31px;}
		.employee {vertical-align: top; display: inline-block; width: 180px; border: 1px solid #d9d9d9; margin: 20px 60px 0px 0px; height: 240px;}
		.empBttn {text-align: right; padding: 10px 10px 0px 0px; height: 27px;}
		.empBttn > img:first-child {margin-right: 7px;}
		.empAdd dl dt {margin: 0px;}
		.empAdd dl dt img {margin: 10px 0px 20px 60px; cursor: pointer;}
		.empAdd dl dd {color: #999; font-size: 15px; line-height: 21px; text-align: center; margin: 0px;}
		.empImg dl dd {font-size: 15px; line-height: 19px; text-align: center; margin: 0px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
		.empImg dl dt img {margin-left: 40px; height: 95px; width: 95px; cursor:pointer;}
		.empInfo {border-bottom: 3px solid; margin: 0px 25px 0px 25px;}
		.empInfo p {margin: 0px; text-align: center; font-size: 20px; font-weight: bold;}
		.empCompany {font-weight: bold; font-size: 20px;}
		.calendarleft {margin: 0px;}
		.calendarright {margin: 0px;}
		</style>
		<script type="text/javascript">
			var selectedYear;
			var selectedTerm;
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
			$(document).on('ready', function() {
				var regular = document.getElementById("regular");
				
				var nowYear = new Date().getFullYear();
				for (var i = nowYear - 20; i < nowYear + 21; i++) {
					var sliderDiv  = document.createElement("div");
					var sliderSpan = document.createElement("span");
					
					sliderDiv.className = "yearDiv";
					sliderSpan.className = "yearSpan";
					sliderSpan.setAttribute("id", i);
					sliderSpan.textContent = i;
					
					sliderDiv.appendChild(sliderSpan);
					regular.appendChild(sliderDiv);
				}
				
				$(".regular").slick({
					dots: false,
					infinite: false,
					slidesToShow: 5,
					initialSlide: 20,
					slidesToScroll: 5,
					focusOnSelect: true,
					centerMode: true,
					speed: 500,
					centerPadding: '0px',
					draggable: false,
					allow: true,
					prevArrow: '<div class="slick-prev"><span class="icon16 calendarleft"></span></div>',
					nextArrow: '<div class="slick-next"><span class="icon16 calendarright"></span></div>',
				});
				
				initList();
				getEmployeeList(nowYear);
				
				$(".regular").on('afterChange', function(event, slick, currentSlide, nextSlide){
					var centerElmt = document.getElementsByClassName("slick-center")[0];
					var centerYear = centerElmt.getElementsByClassName("yearSpan")[0].innerHTML;
					getEmployeeList(centerYear);
				});
			});
			function initList() {
				var mainList = document.getElementById("mainlist");
				
				for (var month = 1; month < 13; month++) {
					var liElmt         = document.createElement("li");
					var empBttnDivElmt = document.createElement("div");
					var empInfoDivElmt = document.createElement("div");
					var empAddDivElmt  = document.createElement("div");
					var addBttnElmt    = document.createElement("img");
					var titleElmt      = document.createElement("p");
					var dlElmt         = document.createElement("dl");
					var dtElmt         = document.createElement("dt");
					var imgElmt        = document.createElement("img");
					var ddElmt1        = document.createElement("dd");
					var ddElmt2        = document.createElement("dd");
					
					liElmt.setAttribute("id", month);
					liElmt.className = "employee";
					
					empBttnDivElmt.className = "empBttn";
					empInfoDivElmt.className = "empInfo";
					empAddDivElmt.className = "empAdd";
					
					titleElmt.textContent = month + "월";
					
					ddElmt1.textContent = month + "월의 우수사원을";
					ddElmt2.textContent = "등록하세요.";
					
					addBttnElmt.setAttribute("id", "add_" + month);
					addBttnElmt.setAttribute("src", "/images/admin/slideAdd.png");
					addBttnElmt.addEventListener("click", function(event) {btn_add(this);});

					dtElmt.appendChild(addBttnElmt);
					dtElmt.appendChild(ddElmt1);
					dtElmt.appendChild(ddElmt2);
					dlElmt.appendChild(dtElmt);
					
					empInfoDivElmt.appendChild(titleElmt);
					empAddDivElmt.appendChild(dlElmt);
					
					liElmt.appendChild(empBttnDivElmt);
					liElmt.appendChild(empInfoDivElmt);
					liElmt.appendChild(empAddDivElmt);
					
					mainList.appendChild(liElmt);
				}
			}
			function getEmployeeList(year) {
				selectedYear = year;
				
				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/getEmployeeOfMonthList.do",
					dataType : "JSON",
					data : {year: selectedYear},
					success : function(result) {
						renderList(result.list);
					}
				});
			}
			function renderList(result) {
				
				for (var month = 1; month < 13; month++) {
					var liElmt   = document.getElementById(month);
					var bttnElmt = liElmt.getElementsByClassName("empBttn")[0];
					var addElmt  = liElmt.getElementsByClassName("empAdd")[0];
					var imgElmt  = liElmt.getElementsByClassName("empImg")[0];
					
					while (bttnElmt.firstChild) {
						bttnElmt.removeChild(bttnElmt.firstChild);
					}
					
					if (imgElmt) {
						addElmt.style.display = ""; 
						liElmt.removeChild(imgElmt);
					}
					
					result.forEach(function(item, index) {
						if (month == item.term.substring(5)) {
							if (addElmt) { addElmt.style.display = "none"; }
							
							var liElmt  = document.getElementById(month);
							
							var updBttnElmt   = document.createElement("img");
							var delBttnElmt   = document.createElement("img");
							var empImgDivElmt = document.createElement("div");
							var dlElmt        = document.createElement("dl");
							var dtElmt        = document.createElement("dt");
							var imgElmt       = document.createElement("img");
							var ddElmt1       = document.createElement("dd");
							var ddElmt2       = document.createElement("dd");
							var ddElmt3       = document.createElement("dd");
							
							updBttnElmt.setAttribute("src", "/images/admin/slideUpdate.png");
							delBttnElmt.setAttribute("src", "/images/admin/slideDelete.png");
							
							updBttnElmt.addEventListener("click", function(event) {btn_modify(item.term);});
							delBttnElmt.addEventListener("click", function(event) {btn_delete(item.term);});
							
							empImgDivElmt.className = "empImg";
							
							imgElmt.style.border = "1px solid #999";
							imgElmt.setAttribute("src", item.filePath);
							imgElmt.addEventListener("click", function(event) {OpenUserInfo(item.cn);});
							
							ddElmt1.className = "empCompany"
							ddElmt1.textContent = item.company;
							ddElmt2.textContent = item.description;
							ddElmt3.textContent = item.title + " " + item.displayName;
							
							bttnElmt.appendChild(updBttnElmt);
							bttnElmt.appendChild(delBttnElmt);
							
							dtElmt.appendChild(imgElmt);
							dlElmt.appendChild(dtElmt);
							dlElmt.appendChild(ddElmt1);
							dlElmt.appendChild(ddElmt2);
							dlElmt.appendChild(ddElmt3);
							empImgDivElmt.appendChild(dlElmt);
							
							liElmt.appendChild(empImgDivElmt);
						}
					});
				}
			}
			function OpenUserInfo(pUserID) {
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = (width - 500) / 2;
				var top = (heigth - 400) / 2;
				window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
			}
			var selectperson_cross_dialogArguments = new Array();
			function btn_add(obj) {
				selectperson_cross_dialogArguments[1] = btn_add_Complete;
				
				var month = obj.getAttribute("id");
				var term = selectedYear + "-" + month.substring(4);
				selectedTerm = term;
				
				selectperson_cross_dialogArguments[1] = btn_add_Complete;
				var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(760, 535));
				try { SelectPerson_cross.focus(); } catch (e) { }
				
			}
			function btn_add_Complete(rtv) {
				if (typeof (rtv) != "undefined") {
					var userId = rtv.split(":")[0];
					var deptId = rtv.split(":")[4];
				}
				
				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/setEmployeeMonth.do",
					async : false,
					data : {type : "INS", userID : userId, deptID : deptId, term : selectedTerm},
					dataType : "text",
					success : function (result) {
						if (result != "OK") {
							alert("<spring:message code = 'ezPersonal.t00005' />");
						} else {
							alert("<spring:message code = 'ezPersonal.t191' />");
							window.close();
							window.location.reload(false);
						}
					}
				});
			}
			function btn_modify(term) {
				selectperson_cross_dialogArguments[1] = btn_modify_Complete;
				selectedTerm = term;
				
				var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(760, 535));
				try { SelectPerson_cross.focus(); } catch (e) { }
			}
			function btn_modify_Complete(rtv) {
				if (typeof (rtv) != "undefined") {
					var userId = rtv.split(":")[0];
					var deptId = rtv.split(":")[4];
				}
				
				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/setEmployeeMonth.do",
					async : false,
					data : {type : "UPD", userID : userId, deptID : deptId, term : selectedTerm},
					dataType : "text",
					success : function (result) {
						if (result != "OK") {
							alert("<spring:message code = 'ezPersonal.t00005' />");
						} else {
							alert("<spring:message code = 'ezPersonal.t191' />");
							window.close();
							window.location.reload(false);
						}
					}
				});
			}
			
			function btn_delete(term) {
				if (confirm("<spring:message code = 'ezPersonal.t00003' />")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezPersonal/setEmployeeMonth.do",
						async : false,
						data : {type : "DEL", userID : "", deptID : "", term : term},
						dataType : "text",
						success : function (result) {
							if (result != "OK") {
								alert("<spring:message code = 'ezPersonal.t302' />");
							} else {
								alert("<spring:message code = 'ezPersonal.t00004' />");
								window.location.reload(false);
							}
						}
					});
				}
			}
		</script>
	</head>
	<body class = "mainbody">
		<form id="form1">
			<h1><spring:message code = 'ezPersonal.t299' /></h1>
			<div style="width:100%;">
				<!-- 달력슬라이더 영역 -->
				<div class="regular calSlider" id="regular"></div>
				
				<!-- 이달의우수사원 리스트 영역 -->
				<ul id="mainlist"></ul>
			</div>
	    </form>
	</body>
</html>