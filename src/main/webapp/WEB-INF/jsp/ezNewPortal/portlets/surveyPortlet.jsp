<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
	<article class="box_shadow">
		<div class="layDiv pollLay">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
					<c:out value='${portletName }'/>
				</dt>
				<dd class="portletPlus" id="surveyPlus">
					<img src="/images/ezNewPortal/portlet_Plus<c:out value='${usedTheme }'/>.png">
				</dd>
			</dl>
			<div class="vote_contents">
				<div id="surveyInfo">
					<ul id="surveyUl" class="portlet_list">
						<!-- <li class="mail_open" ></li> -->
					</ul>
				</div>
			</div>
		</div>
	</article>
	<script type="text/javascript">
		$(function() {
			var plusBtn = document.getElementById("surveyPlus");
			plusBtn.addEventListener('click', goSurveyPage, false);
			
			function goSurveyPage() {
				window.open('/ezSurvey/surveyMain.do', 'main', '');
			}
			
			function getPotletSurveyList() {
				
				var searchObj = {
						currentPage : 1,
						pageMode 	: 'processing',
						srchMode 	: 0,
						listCnt  	: 5,
						title       : "",
						creatorName : "",
						startDate   : "",
						endDate     : "",
						column      : "",
						order       : "",
						srchMode    : 0,
						srchOption  : "title",
						listCntSize : 5
						};
				
				$.ajax({
					type: "GET",
					url: "/ezSurvey/getSurveyItems.do",
					data: searchObj,
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						setListByDataList(data.itemList);
					},
					error : function(error) {
						console.log(error);
						alert(messages.strLang2 + error);
					}
				});
			}
			
			function setListByDataList(surveys) {
				//console.log(surveys);
				if (surveys.length > 0) {
					var title;
					var endDate;
					var creator;
					
					var ulEl = document.getElementById("surveyUl");
					
					for (var i = 0, leng = surveys.length; i < leng; i++) {
						var survey = surveys[i];
						if (survey.useStatus === 1) {
							title = survey.title;
							endDate = "~ " + survey.endDate.substr(5, 5);
							creator = survey.creatorName;
							
							var liEl = document.createElement("li");
							liEl.className = 'mail_open';
							liEl.setAttribute('surveyId', survey.surveyId);
							liEl.addEventListener('click', function(event) { getDetailSurvey(event, this); }, false);
							
							var spanEl1 = document.createElement("span");
							spanEl1.className = 'txt';
							spanEl1.textContent = title;
							
							var spanEl2 = document.createElement("span");
							spanEl2.className = 'date';
							spanEl2.textContent = endDate;
							
							var spanEl3 = document.createElement("span");
							spanEl3.className = 'name';
							spanEl3.textContent = creator;
							
							liEl.appendChild(spanEl1);
							liEl.appendChild(spanEl2);
							liEl.appendChild(spanEl3);
							
							ulEl.appendChild(liEl);
						}
						
					}
				} else {
					
					var dlEl = docuemnt.createElement('dl');
					dlEl.className = 'nodata';
					
					var dtEl = docuemnt.createElement('dt');
					
					var imgEl = docuemnt.createElement('img');
					imgEl.src = '/images/kr/main/noData_sIcon.png';
					
					var ddEl = docuemnt.createElement('dd');
					ddEl.innerHTML = '/"' + messages.strLang1 + '/"';
					
					dtEl.appendChild(imgEl);
					
					dlEl.appendChild(dtEl);
					dlEl.appendChild(ddEl);
					
					ulEl.appendChild(liEl);
				}
				
			}
			
			function getDetailSurvey(event, thisEl) {
				event.stopPropagation();
				
				var surveyId = thisEl.getAttribute('surveyId');
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - 780;
				var heigth   = parseInt(heigth) - 750;
				var left     = pleftpos / 2;
				var top      = heigth / 2;
				
				var itemPopup;
				itemPopup = window.open("/ezSurvey/surveyDetail.do?itemId=" + surveyId, "fileDetail", "height = " + 750 + "px, width = " + 780 + "px, left=" + left + ", top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes");
				console.log(itemPopup);
			}
			
			getPotletSurveyList();
		});
	</script>
</body>
</html>