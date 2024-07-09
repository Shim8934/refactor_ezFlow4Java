/**
 * 구해안
 */
var CommuSize = $('#CommuSize').val();
var userId = $('#userId').val();

var communityPortletObj = {};

function initCommunityPortletInfo(communityPortletId) {
	var newObj = {};
	var perCount = getCommmunityPagePerCount(communityPortletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.portletCode = "community";
	newObj.page.getPagePerCount = function () {
		return getCommmunityPagePerCount(communityPortletId);
	}
	newObj.getPortletList = function () {
		var currentPage = portletInfoMap["portlet" + communityPortletId].page.getPage();
		getCommunityList(currentPage);
	}

	portletInfoMap["portlet" + communityPortletId] = newObj;
	
	communityPortletObj.portletId = communityPortletId;
	var totalCnt = CommuSize;
	var currentPage = 1;
	resetPortletPaging(communityPortletObj.portletId, totalCnt, currentPage, "");
}

function reloadCommunityPortlet() {
	var portletId = communityPortletObj.portletId;

	var newObj = {};
	var perCount = getCommmunityPagePerCount(portletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.portletCode = "community";
	newObj.page.getPagePerCount = function () {
		return getCommmunityPagePerCount(portletId);
	}
	newObj.getPortletList = function () {
		var currentPage = portletInfoMap["portlet" + portletId].page.getPage();
		getCommunityList(currentPage);
	}

	getCommunityList(1);
}

function getCommmunityPagePerCount(communityPortletId) {
	var portletSize = getPortletSize(communityPortletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 5;
	} else {
		count = 2;
	}

	return count;
}

function view_bestCommunity(event) {
	var $target = $(event.target);
	$target = $target.is('dl') ? $target : $target.closest('dl');
	
	var clubType = "";
	$.ajax({
		type : "GET",
		dataType : "text",
		async : true,
		url : "/ezNewPortal/getCommunityPermit.do",
		data : {
				//꺼내쓸때 event.data.변수명 으로 꺼낸다
				clubNo	:	$target.data("clubno"),
			   },
		success: function(result){
			clubType = result;
		}
	});
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezCommunity/remote/getACL.do",
		data : { cID	:	$target.data("clubno"),
				 uID	:	userId
		},
		success: function(result){
			if (result == "ERR" && clubType != "1") {
				OpenAlertUI(messages.strLang11+"<br>"+messages.strLang12, null, "/ezPortal/wpNewCommunity.do.OpenAlertUI");
			} else {
				var wWeight = "1300";
                var wHeight = "900";

                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;

                var left = (width - wWeight) / 2;
                var top = (heigth - wHeight) / 2 - 30;

                var ret = window.open("/ezCommunity/checkCommHome.do?communityCD=" + encodeURIComponent($target.data("clubno")), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			}
		}
	});
}

function viewCommuList() {
    window.open("/ezCommunity/communityMain.do?funCode=5", "main", "");
}

var ezapralert_cross_dialogArguments = new Array();

function OpenAlertUI(NewWinContent, NewWinCallFunction, NewWinName) {
    var parameter = NewWinContent;

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;

        if (NewWinCallFunction != undefined || NewWinCallFunction != null)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;

        var windowopenfeature = "height=205px,width=330px,status=no,toolbar=no,menubar=no,location=no,resizable=1";
        windowopenfeature = windowopenfeature + GetOpenPosition(205, 330);

        window.open("/ezCommunity/ezAprAlert.do", NewWinName, windowopenfeature);
    } else {
        var windowshomodalDialogfeature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
        windowshomodalDialogfeature = windowshomodalDialogfeature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog("/ezCommunity/ezAprAlert.do", parameter, windowshomodalDialogfeature);
    }
}

function OpenAlertUI_Complete() {
    //Source Code...
}

var getCommunityList = function(currentPage) {
    var listSize = getCommmunityPagePerCount(communityPortletObj.portletId);

	var request = new XMLHttpRequest();
	request.open('GET', '/ezNewPortal/getCommunityList.do?currentPage=' + currentPage + "&listSize=" + listSize, false);
	request.setRequestHeader('Content-Type', 'application/json');
	var companiesHTML = "";

	request.onload = function() {
		if (request.status >= 200 && request.status < 400) {
			if (request.responseText == null) {
				return;
			}
			
			var result = JSON.parse(request.responseText);

			var commuPath = result.commuPath;
			
			var commuElem = document.getElementById("communityList");
			commuElem.innerHTML = "";
			
			if (result.CommuSize == 0) {
				var noDataList = setCommunityNoData();
				commuElem.appendChild(noDataList);
			} else {
				var communityList = result.CommunityList;
				
				for (var i = 0; i < communityList.length; i++) {
					var list = setCommunityData(communityList[i], commuPath, "0" + (i + 1));
					commuElem.appendChild(list);
					$('.comListDL0'+i).on("click", view_bestCommunity);
				}
			}

			var totalCnt = result.CommuSize;
			var currentPage = result.currentPage;
			resetPortletPaging(communityPortletObj.portletId, totalCnt, currentPage, "");
			
		}
	};

	request.onerror = function() {
	  // There was a connection error of some sort
	};
	
	request.send();
}

var setCommunityNoData = function() {
	var comListDL = document.createElement("dl");
	comListDL.className = "nodata";
	var comDT = document.createElement("dt");
	var noImage = document.createElement("img");
	noImage.src = "/images/kr/main/noData_sIcon.png";
	var titleDD = document.createElement("dd");
	titleDD.textContent = messages.strLang1;
	
	comDT.appendChild(noImage);
	comListDL.appendChild(comDT);
	comListDL.appendChild(titleDD);
	
	return comListDL;
}

var setCommunityData = function(commuInfo, commuPath, classTag) {
	var communityPortletPage = portletInfoMap["portlet" + communityPortletObj.portletId].page;
	var currentPage = communityPortletPage.getPage();

	var comListDL = document.createElement("dl");
	comListDL.className = "comListDL" + classTag;
	comListDL.style.cursor = "pointer";
	comListDL.setAttribute("data-clubno", commuInfo.c_ClubNo);
	var comDT = document.createElement("dt");
	comDT.className = "comPic";
	
	if (classTag === "01" && currentPage == 1) {
		var comSpan = document.createElement("span");
		comSpan.className = "best";
		var bestImg = document.createElement("img");
		bestImg.src = "/images/kr/main/com_best.png";
		comSpan.appendChild(bestImg);
		comDT.appendChild(comSpan);
	}
	var comImg = document.createElement("img");
	
	if (commuInfo.c_Logo_Thumbnail == 'default_logo_type') {
		comImg.src = "/images/ezCommunity/logo/" + commuInfo.c_Logo_Thumbnail;
	} else {
		comImg.src = "/ezCommon/downloadAttach.do?filePath=" + commuPath + "/" + commuInfo.c_Logo_Thumbnail;
	}
	
	
	var comTitle = document.createElement("dd");
	comTitle.textContent = commuInfo.c_ClubName;
	comTitle.className = "comTit";
	var comText = document.createElement("dd");
	comText.textContent = commuInfo.c_ClubDesc;
	comText.className = "comText";
	
	var comPerson = document.createElement("dd");
	comPerson.textContent = messages.strLangCommunity01 + " " + commuInfo.c_memberCnt + messages.strLangCommunity02;
	comPerson.className = "comPerson";
	
	comDT.appendChild(comImg);
	
	comListDL.appendChild(comDT);
	comListDL.appendChild(comTitle);
	comListDL.appendChild(comText);
	comListDL.appendChild(comPerson);
	
	return comListDL;
}