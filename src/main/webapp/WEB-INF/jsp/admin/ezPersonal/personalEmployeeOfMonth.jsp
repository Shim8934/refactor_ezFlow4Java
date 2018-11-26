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
		.empBttn {text-align: right; padding: 10px 10px 0px 0px;}
		.empBttn > img:first-child {margin-right: 5px;}
		.empBttn > img {height: 14px; width: 14px;}
		.empAdd dl dt {margin: 0px;}
		.empAdd dl dt img {height: 60px; width: 60px; margin: 10px 0px 20px 60px; cursor: pointer;}
		.empAdd dl dd {color: #999; font-size: 15px; line-height: 21px; text-align: center; margin: 0px;}
		.empImg dl dd {font-size: 15px; line-height: 19px; text-align: center; margin: 0px;}
		.empImg dl dt img {margin-left: 40px; height: 95px; width: 95px;}
		.empInfo {border-bottom: 3px solid; margin: 0px 25px 0px 25px;}
		.empInfo p {margin: 0px; text-align: center; font-size: 20px; font-weight: bold;}
		.empCompany {font-weight: bold; font-size: 20px;}
		.calendarleft {margin: 0px;}
		.calendarright {margin: 0px;}
		</style>
		<script type="text/javascript">
			var year;
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
	
			var select_best_dialogArguments = new Array();
		    function btn_Select() {
		        if (CrossYN()) {
		            select_best_dialogArguments[1] = btn_Select_Complete;
		            //크롬일때 alert창 크기때문에 크롬일때 구별
		            var agent = navigator.userAgent.toLowerCase();
		            if (agent.indexOf("chrome") != -1) {
		            	var Select_Best = window.open("/admin/ezPersonal/selectBest.do", "SelectBest", GetOpenWindowfeature(460, 200));	
		            } else {
		            	var Select_Best = window.open("/admin/ezPersonal/selectBest.do", "SelectBest", GetOpenWindowfeature(400, 200));
		            }
		            
		            try { Select_Best.focus(); } catch (e) {
		            }
		        }  else {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (width - 500) / 2;
		            var top = (heigth - 400) / 2;
		            var rtnValue = window.showModalDialog("/admin/ezPersonal/selectBest.do", "",
		                  "dialogHeight:200px;dialogwidth:400px;dialogleft:left = " + left + ";dialogtop:" + top + ", status:no;toolbar:no;location:no;scroll:no;edge:sunken, top=" + top + ",left = " + left);
		            window.location.reload(false);
		        } 
		    }
	
		    function btn_Select_Complete(){
		        window.location.reload(false);
		    }
	
		    function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
			
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
					dots: false,     //도트안보이게설정
					infinite: false, //무한반복
					slidesToShow: 5, //5개씩보여줌
					initialSlide: 20,
					slidesToScroll: 5,
					focusOnSelect: true,
					centerMode: true,
					speed: 500,
					centerPadding: '0px',
					allow: true,
					prevArrow: '<div class="slick-prev"><span class="icon16 calendarleft"></span></div>',
					nextArrow: '<div class="slick-next"><span class="icon16 calendarright"></span></div>',
				});
				
				initList();
				getEmployeeList(nowYear);
				
				$(".regular").on('afterChange', function(event, slick, currentSlide, nextSlide){
					var centerElmt = document.getElementsByClassName("slick-center")[0];
					var centerYear = centerElmt.getElementsByClassName("yearSpan")[0].innerHTML;
					console.log(centerYear);
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
					var updBttnElmt    = document.createElement("img");
					var delBttnElmt    = document.createElement("img");
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
					
					ddElmt1.textContent = month + "의 우수사원을";
					ddElmt2.textContent = "등록하세요.";
					
					addBttnElmt.setAttribute("src", "/images/admin/menuAdd.png");
					updBttnElmt.setAttribute("src", "/images/email/popup_icon.gif");
					delBttnElmt.setAttribute("src", "/images/close_xBtn.png");
					
					addBttnElmt.addEventListener("click", function(event) {btn_add(month);});
					updBttnElmt.addEventListener("click", function(event) {btn_modify(month);});
					delBttnElmt.addEventListener("click", function(event) {btn_delete(month);});
					
					dtElmt.appendChild(addBttnElmt);
					dtElmt.appendChild(ddElmt1);
					dtElmt.appendChild(ddElmt2);
					dlElmt.appendChild(dtElmt);
					
					empBttnDivElmt.appendChild(updBttnElmt);
					empBttnDivElmt.appendChild(delBttnElmt);
					empInfoDivElmt.appendChild(titleElmt);
					empAddDivElmt.appendChild(dlElmt);
					
					liElmt.appendChild(empBttnDivElmt);
					liElmt.appendChild(empInfoDivElmt);
					liElmt.appendChild(empAddDivElmt);
					
					mainList.appendChild(liElmt);
				}
			}
			function getEmployeeList(selectedYear) {
				year = selectedYear;
				
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
					
					console.log(bttnElmt);
					
					if (imgElmt) {
						addElmt.style.display = ""; 
						liElmt.removeChild(imgElmt);
					}
					
					result.forEach(function(item, index) {
						if (month == item.term.substring(5)) {
							if (addElmt) { addElmt.style.display = "none"; }
							
							var liElmt  = document.getElementById(month);
							
							var empImgDivElmt = document.createElement("div");
							var dlElmt        = document.createElement("dl");
							var dtElmt        = document.createElement("dt");
							var imgElmt       = document.createElement("img");
							var ddElmt1       = document.createElement("dd");
							var ddElmt2       = document.createElement("dd");
							var ddElmt3       = document.createElement("dd");
							
							empImgDivElmt.className = "empImg";
							imgElmt.style.border = "1px solid #999";
							imgElmt.setAttribute("src", item.filePath);
							
							ddElmt1.className = "empCompany"
							
							ddElmt1.textContent = item.company;
							ddElmt2.textContent = item.description;
							ddElmt3.textContent = item.title + " " + item.displayName;
							
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
			function btn_add(month) {
				var term = year + "-" + month;
				console.log(term);
				
				/* if (CrossYN()) {
					var SelectPerson_cross = window.open("/ezPersonal/selectPerson.do?type=EMP", "SelectPerson", GetOpenWindowfeature(760, 535));
					try { SelectPerson_cross.focus(); } catch (e) { }
				} else {
					var rtnValue = window.showModalDialog("/ezPersonal/selectPerson.do?type=EMP", "", "dialogHeight:535px;dialogwidth:760px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken");
				} */
			}
			function btn_delete(month) {
				var term = year + "-" + month;
				console.log(term);
				
				/* if (confirm("<spring:message code = 'ezPersonal.t00003' />")) {
					$.ajax({
						type : "POST",
						url : "/admin/ezPersonal/setEmployeeMonth.do",
						async : false,
						data : {type : "DEL", userID : "", deptID : "", term : temp},
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
				} */
			}
		</script>
	</head>
	<body class = "mainbody">
		<form id="form1">
		    <h1><spring:message code = 'ezPersonal.t299' /></h1>
		
		    <%-- <div id="mainmenu">
				<ul>
		            <li class="important"><span onClick="btn_Select()"><spring:message code = 'ezPersonal.t105' /></span></li>
				</ul>
		    </div>
		    <script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script> --%>
		    <div style="width:100%;/* border-right:1px solid #e8e8e8; border-left:1px solid #e8e8e8; */">
		        <%-- <table class="mainlist" style="width:100%;"> 
					<tr> 
						<th style="width:10%; text-align:center"><spring:message code = 'ezPersonal.t290' />/<spring:message code = 'ezPersonal.t291' /></th> 
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t304' /></th> 
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t69' /></th> 
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t7' /></th>
						<th style="width:20%; text-align:center"><spring:message code = 'ezPersonal.t67' /></th> 
				        <th style="width:10%; text-align:center"></th> 
					</tr> 
					<c:if test="${list == '[]'}">
						<tr>
							<td colspan="6" style="text-align: center; color:#5b5a5a;">
		  						<spring:message code='main.t00026'/>
							</td>
						</tr>
					</c:if>
					<c:forEach var="item" items="${list }">
						<tr> 
							<td style="text-align:center">
								<c:if test="${fn:length(item.term) > 6}">${item.term}</c:if>
								<c:if test="${fn:length(item.term) <= 6}">${fn:substring(item.term,0,5)}0${fn:substring(item.term,5,6)}</c:if>
							</td> 
							<td style="text-align:center">
								<span style="cursor:pointer;" onclick="OpenUserInfo('${item.cn}')">${item.displayName }</span>
					        </td> 
					        <td style="text-align:center">${item.title}</td> 
							<td style="text-align:center">${item.description}</td> 
							<td style="text-align:center">${item.company}</td>
					        <td style="text-align:center"><a class="imgbtn"><span onClick="btnDel_click('${item.term}')" ><spring:message code = 'ezPersonal.t99' /></span></a></td>
						</tr> 
					</c:forEach>
				</table> --%>
				
				<!-- 달력슬라이더 영역 -->
				<div class="regular calSlider" id="regular"></div>
				
				<!-- 이달의우수사원 리스트 영역 -->
				<ul id="mainlist"></ul>
		    </div>   
	    </form>
	</body>
</html>