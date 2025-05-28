// plus 버튼 클릭 이벤트

var surveyPortletObj = {};

function initSurveyPortletInfo(surveyPortletId) {
	var newObj = (function() {
		var portletId = surveyPortletId;
		var perCount = getSurveyPagePerCount(portletId); 
		var obj = {};
		obj.page = new Paging().setPageStart(1).init(perCount);
		obj.page.getPagePerCount = function () {
			return getSurveyPagePerCount(portletId);
		}
		obj.portletCode = "survey";
		obj.getPortletList = function () {
			var currentPage = obj.page.getPage();
			getPotletSurveyList(currentPage);
		}
		
		return obj;
	})();
	
	portletInfoMap["portlet" + surveyPortletId] = newObj;
	surveyPortletObj.portletId = surveyPortletId;
	
	getPotletSurveyList(1);
}

function reloadSurveyPage() {
	portletInfoMap["portlet" + surveyPortletObj.portletId].getPortletList();
}

function getSurveyPagePerCount(surveyPortletId) {
	var portletSize = getPortletSize(surveyPortletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 7;
	} else {
		count = 3;
	}

	return count;
}

var plusBtn = document.getElementById("surveyPlus");
plusBtn.addEventListener('click', goSurveyPage, false);

function goSurveyPage() {
	window.open('/ezSurvey/surveyMain.do', 'main', '');
}

// 진행중인 설문 데이터 가져오기
function getPotletSurveyList(currentPage) {
	var searchObj = {
			currentPage : currentPage,
			pageMode 	: 'processing',
			srchMode 	: 0,
			title       : "",
			creatorName : "",
			startDate   : "",
			endDate     : "",
			column      : "",
			order       : "",
			srchMode    : 0,
			srchOption  : "title",
			listCntSize : getSurveyPagePerCount(surveyPortletObj.portletId)
			};
	
	$.ajax({
		type: "GET",
		url: "/ezSurvey/getSurveyItems.do",
		data: searchObj,
		dataType: "JSON",
		success : function(data) {
			setListByDataList(data.itemList);
			var totalCnt = data.totalRows;
			var currentPage = data.currentPage;
			resetPortletPaging(surveyPortletObj.portletId, totalCnt, currentPage, "");
		},
		error : function(error) {
			alert(messages.strLang2 + error);
		}
	});
}

// 위에서 가져온 데이터로 리스트 생성
function setListByDataList(surveys) {
	var ulEl = document.getElementById("surveyUl");
	ulEl.innerHTML = "";
	
	if (surveys.length > 0) {
		var title;
		var endDate;
		var creator;
		var responseCnt;
		
		for (var i = 0, leng = surveys.length; i < leng; i++) {
			var survey = surveys[i];
			
			responseCnt = checkRespondentBySurveyId(survey.surveyId);
			
			if (survey.useStatus === 1) {
				title = survey.title;
				endDate = "~" + survey.endDate.substr(5, 5).replace(/-/g, ".");
				creator = survey.creatorName;
				
				var liEl = document.createElement("li");

				if (responseCnt <= 0) {
					liEl.style.fontWeight = 'bold';
				}
				liEl.className = 'survey_ing';
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
		var dlEl = document.createElement('dl');
		dlEl.className = 'nodata';
		
		var dtEl = document.createElement('dt');
		
		var imgEl = document.createElement('img');
		imgEl.src = '/images/kr/main/noData_sIcon.png';
		
		var ddEl = document.createElement('dd');
		ddEl.innerHTML = messages.strLang1;
		
		dtEl.appendChild(imgEl);
		
		dlEl.appendChild(dtEl);
		dlEl.appendChild(ddEl);
		
		ulEl.appendChild(dlEl);
	}
}

// 응답 안 한 설문은 굵게 표시
function checkRespondentBySurveyId(surveyId) {
	var cnt;
	
	$.ajax({
		type : "GET",
		url : "/ezSurvey/checkRespondent.do",
		data : {surveyId : surveyId},
		async : false,
		dataType : "JSON",
		success : function(result) {
			cnt = result.responseCnt;
		},
		error : function(error) {
			alert(messages.strLang2);
		}
		
	});
	return cnt;
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
}