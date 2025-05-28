// 회사 변경 method
function changeCompany() {
	makelist();
	showPreview(2, 0);
}

// managePoll 호출 method
function makelist() {
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/managePollList.do",
		dataType : "text",
		data : {
			companyID : encodeURIComponent(document
					.getElementById("ListCompany").value),
			page : pageNum
		},
		success : function(result) {
			event_PollList(loadXMLString(result));
		}
	});
}

// xml -> listView parsing method
function event_PollList(result) {
	try {
		document.getElementById("AccessList").innerHTML = "";
		var xmldom = result
		var headerData = createXmlDom();
		headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

		if (CrossYN()) {
			var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
			var Node = headerData.importNode(xmlRtn, true);
			headerData.documentElement.appendChild(Node);
		} else {
			var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
			headerData.documentElement.appendChild(xmlRtn);
		}

		var listview = new ListView();
		listview.SetID("AccessListView");
		listview.SetSelectFlag(false);
		listview.SetMulSelectable(true);
		listview.SetRowOnClick("PollList_onClick");
		listview.SetRowOnDblClick("PollList_onDblclick");
		listview.DataSource(headerData);
		listview.DataBind("AccessList");
		// listview.DataSource(xmldom);
		listview.RowDataBind();
		checkbox_header();
		xmldomNode = null;

		if (CrossYN() && navigator.userAgent.indexOf("Trident/7.0") < 0) {
			TotalCount = parseInt(SelectSingleNodeValueNew(xmldom, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom, "CURPAGE"));
		} else if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			// IE11일때 추가
			TotalCount = parseInt(SelectSingleNodeValueNew(
					xmldom.documentElement, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement,
					"CURPAGE"));
		} else {
			TotalCount = parseInt(SelectSingleNodeValueNew(
					xmldom.documentElement, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement,
					"CURPAGE"));
		}

		// 2018-08-02 김보미 - 데이터가 없을 때
		if (TotalCount == null || TotalCount == 0) {
			var TR_noItems = "<tr id='Poll_TR_noItems'><td style='text-align: center;' colspan='6'>"
					+ strLang5 + "</td></tr>";
			$("#AccessListView tbody").eq(0).html(TR_noItems);
		}

		totalPage = Math.ceil(new Number(TotalCount / PageSize));

		if (CrossYN()) {
			progressPollFlag = SelectSingleNodeValueNew(xmldom, "PROFLAG");
			progressSDate = SelectSingleNodeValueNew(xmldom, "PROFLAGSDATE");
			progressEDate = SelectSingleNodeValueNew(xmldom, "PROFLAGEDATE");
		} else {
			progressPollFlag = SelectSingleNodeValueNew(xmldom.documentElement,
					"PROFLAG");
		}
		rowListSelect();
		checkItems();
		makePageSelPage();
	} catch (e) {
	}
}

// xml data -> input checkbox method
var cnt;
function checkbox_header() {
	var doc = window.document;
	var th = doc.getElementById("AccessListView_TH_0");
	var acList = doc.getElementById("AccessListView");
	th.innerHTML = "<input type='checkbox' id = 'checkAll' onchange='checkboxHeaderClick()'></input>";

	cnt = acList.children[1].childElementCount;

	var i = 0;
	for (i; i < cnt; i++) {
		var seq = acList.children[1].children[i].children[0].innerHTML;
		var jinhangFlag = acList.children[1].children[i].children[5].innerHTML;
		acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='"
				+ seq
				+ "' value='"
				+ seq
				+ "' onchange='inputFunc(event,"
				+ seq + ")'></input>";
		if (jinhangFlag == 1) {
			acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse.png' border='0' class='jinhang' inuse='1'>";
		} else {
			acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse_end.png' border='0' class='jinhang' inuse='0'>";
		}
	}
}

// 체크박스 헤더 클릭 method
var checkFlag = false;
function checkboxHeaderClick() {
	
	var doc = window.document;
	var acList = doc.getElementById("AccessListView");
	// 데이터가 있을 경우에만
	if(acList.children[1].children[0].id !== 'Poll_TR_noItems'){
		if (checkFlag) {
			checkFlag = false;
			$(".checks").prop("checked", false);
			$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
		} else {
			checkFlag = true;
			$(".checks").prop("checked", true);
			$("#contentlist tr td").css("background-color", "rgb(241, 248, 255)");
		}
		checkItems();
	}
}

// 체크박스 itemseq 배열 조회 method
var rowList = new Array();
function checkItems() {
	rowList = [];
	$("input:checkbox[name='checks']").each(function() {
		if ($(this).is(":checked")) {
			rowList.push(this.value);
		}
	});
}

// 등록, 수정 , 삭제 후 rowSelect 선택 method
function rowListSelect() {
	var len = rowList.length;
	for (var i = 0; i < len; i++) {
		var tempItemSeq = rowList.pop();
		if (document.getElementById(tempItemSeq) != null) {
			$("#" + tempItemSeq).prop("checked", true);
			var tempID = $("#" + tempItemSeq)[0].parentNode.parentNode.id;
			$("#" + tempID + " td").css("background-color",
					"rgb(241, 248, 255)");
		}
	}

	if (checkFlag) {
		$("#checkAll").prop("checked", true);
	} else {
		$("#checkAll").prop("checked", false);
	}
}

// 체크박스 클릭 method
function inputFunc(event, itemseq) {
	checkItems();
	$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");

	for (var i = 0; i < rowList.length; i++) {
		var objID = $("#" + rowList[i])[0].parentNode.parentNode.id;
		$("#" + objID + " td").css("background-color", "rgb(241, 248, 255)");
		$("#" + rowList[i]).prop("checked", true);
	}
}

// row 클릭 method
var itemseq;
function PollList_onClick(obj) {
	var className = window.event.target.getAttribute('class');
	if(className === 'checks') {
		return;
	}

	var doc = window.document;
	itemseq = document.getElementById(obj).getAttribute("DATA1");
	if(itemseq == "0") {
		return;
	}
	
	if(checkFlag) {
		if($("#"+itemseq).prop("checked")) {
			$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
			$("#" + itemseq).prop("checked", false);
		} else {
			$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
			$("#" + itemseq).prop("checked", true);
		}
	} else {
		$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
		$(".checks").prop("checked",false);
		if($("#" + itemseq).is(":checked")) {
			$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
			$("#" + itemseq).prop("checked", false);
		} else {
			$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
			$("#" + itemseq).prop("checked", true);
		}
	}
	
	checkItems();
	doc.getElementById("ifrmPreViewH").style.display = "";
	showPreview(isPreview, itemseq);
}

// row 더블 클릭 method
function PollList_onDblclick(obj) {
	var itemseq = document.getElementById(obj).getAttribute("DATA1");
	if (itemseq == "0") {
		return;
	}

	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 455) / 2;
	var top = (heigth - 400) / 2;

	checkItems();
	window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455px, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
}

// 설문조사 팝업 호출 method
var showPollPage = function() {
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 455) / 2;
	var top = (heigth - 400) / 2;

	window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455px, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
}

// 등록, 수정, 삭제  method
function setFucntion() {
	var doc = window.document;
	var add = doc.getElementById("add");
	var mod = doc.getElementById("mod");
	var del = doc.getElementById("del");
	add.addEventListener("click", add_poll);
	mod.addEventListener("click", mod_poll);
	del.addEventListener("click", del_poll);
}

// 설문조사 등록 method
var addpoll_cross_dialogArguments = new Array();
var add_poll = function() {
	if (totalCount != "0" && progressPollFlag == "true") {
		if (!confirm(strLanghyh1)) {
			return;
		}
	}

	if (CrossYN()) {
		addpoll_cross_dialogArguments[0] = document.getElementById("ListCompany").value;
		addpoll_cross_dialogArguments[1] = add_poll_Complete;
		var AddPoll_Cross = window.open("/admin/ezPersonal/addPoll.do?flag=add", "AddPoll_Cross", GetOpenWindowfeature(450, 550));
		try {
			AddPoll_Cross.focus();
		} 
			catch (e) {
		}
	} else {
		rtnValue = window.showModalDialog("/admin/ezPersonal/addPoll.do?flag=add", document.getElementById("ListCompany").value, "dialogHeight:550px;dialogwidth:450px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(430, 550));

		if (typeof (rtnValue) != "undefined") {
			changeCompany();
		}
	}
}

// 등록 완료 method
function add_poll_Complete(rtv) {
	if (typeof (rtv) != "undefined") {
		changeCompany();
	}
}

// 수정 method
var mod_poll = function() {
	pollList = "";
	var modCnt = 0;
	$("input:checkbox[name='checks']").each(function(){
		if($(this).is(":checked")) {
			pollList += this.value;
			modCnt = modCnt + 1;
		}
	});

	if(!pollList) {
		alert(strLanghyh2);
		return;
	}

	if(modCnt>1) {
		alert(strLanghyh3)
		return;
	}

	if (CrossYN()) {
		addpoll_cross_dialogArguments[0] = document.getElementById("ListCompany").value;
		addpoll_cross_dialogArguments[1] = add_poll_Complete;
		var AddPoll_Cross = window.open("/admin/ezPersonal/addPoll.do?flag=mod&itemSeq=" + pollList, "AddPoll_Cross", GetOpenWindowfeature(450, 550));
		try {
			AddPoll_Cross.focus();
		} 
			catch (e) {
		}
	} else {
		rtnValue = window.showModalDialog("/admin/ezPersonal/addPoll.do?flag=mod&itemSeq=" + pollList, document.getElementById("ListCompany").value, "dialogHeight:550px;dialogwidth:450px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(430, 550));

		if (typeof (rtnValue) != "undefined") {
			changeCompany();
		}
	}
	pollList = "";
}

// 삭제 method
var pollList = "";
var del_poll = function() {
	var delCnt = 0;
	pollList = "";

	// 진행여부 설문 유무  체크
	var inUseFlag = false;
	$("input:checkbox[name='checks']").each(function(){
		if($(this).is(":checked")) {
			var tempID = $(this)[0].id;
			pollList += tempID + ";"
			delCnt = delCnt + 1;
			var tempUse = $("#" + tempID)[0].parentNode.parentNode.children[5].children[0].getAttribute('inuse');
			if(tempUse === "1") {
				inUseFlag = true;
			}
		}
	});

	if(!pollList) {
		alert(strLanghyh2);
		return;
	}

	// 삭제 여부 확인
	if(inUseFlag) {
		if (!confirm(strLanghyh4)){
			return;
		}
	} else {
		if (!confirm(strLanghyh5)){
			return;
		}
	}

	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/delPoll.do",
		async : false,
		data : {"pollList" : pollList},
		dataType : "text",
		success : function(result) {
			if (result == "OK") {
				alert(strLanghyh6);
				// 페이지가 1보다 크고, data가 없을 경우
				if((cnt - delCnt) == 0){
					if(pageNum > 1) {
						pageNum = pageNum -1 ;
					}
					checkFlag = false;
				}
				itemseq=0;
				//2021-08-24 김성준 - 관리자 빠른설문 삭제 후 미리보기 남아있는 부분 수정
				var doc = window.document;
				doc.getElementById("ifrmPreViewH").innerText = "";
				doc.getElementById("ifrmPreViewH").src = blankstr;
				showPreview(isPreview, 0);
				rowList = [];
				makelist();
			} else {
				alert(strLanghyh7);
			}
		}
	});
	pollList = "";
}

// 빠른 설문 config 조회 method
var isPreview = 0;
function getLightPollConfig() {
	$.ajax({
		type : "POST",
		dataType : "json",
		aysnc : false,
		url : "/admin/ezPersonal/getLightPollConfig.do",
		success : function(result) {
			isPreview = result["configVO"].isPreview;
			changeImg(isPreview);
			setPreview(isPreview);
		}, error: function(xhr, option, error){
			isPreview = 0;
		}
	});
}


// 빠른 설문 config 업데이트 method
var isPreview = 0;
function PreviewRayerChange(direction) {
	var temp = isPreview;
	switch(direction)
	{
		case "NONE" : 
			isPreview = 0;
			break;
		case "H" :
			isPreview = 2;
			break;
	}

	$.ajax({
		type : "POST",
		dataType : "text",
		data : {isPreview : isPreview},
		aysnc : false,
		url : "/admin/ezPersonal/setLightPollConfig.do",
		success : function(result) {
			changeImg(isPreview);
			setPreview(isPreview);
		}, error: function(xhr, option, error){
			isPreview = temp;
		}
	});
}


// 미리보기 버튼 교체 method
function changeImg(previewNum) {
	var doc = window.document;
	var noneImage = doc.getElementById("PreViewNone");
	var leftImage = doc.getElementById("PreViewleft");

	noneImage.className = "icon16 btn_noframe";
	leftImage.className = "icon16 btn_leftframe";

	switch(previewNum) {
		case 0 :
			noneImage.className = "icon16 btn_onnoframe";
			break;
		case 2 :
			leftImage.className = "icon16 btn_onleftframe";
			break;
	}
}


// 미리보기창  설정  method
function setPreview(previewNum) {
	var conlistH = conH
	var doc = window.document;
	var mainView = doc.getElementById("mainView");
	var previewH = doc.getElementById("previewH");
	var PreviewRayerH = doc.getElementById("PreviewRayerH");
	var contentlistH = doc.getElementById("contentlist");
	var previewmail_bar_h = doc.getElementById("previewmail_bar_h");

	switch(previewNum) {
	case 0 :
		previewH.style.display = "none";
		mainView.style.width = "100%";
		doc.getElementById("contentlist").style.height = conlistH + "px";					
		break;
	case 2 :
		if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			previewmail_bar_h.style.float = "left";
		} 
		doc.getElementById("contentlist").style.height = conlistH + "px";
		mainView.style.width = "calc(100% - 550px)";
		previewH.style.width = "550px";
		previewH.style.height = conlistH + 10 + "px";
		previewH.style.display = "";
		previewmail_bar_h.style.height = conlistH + 47 + "px";
		PreviewRayerH.style.display = "";
		if(itemseq!=0) {
			doc.getElementById("ifrmPreViewH").style.display = "";
		}
		doc.getElementById("ifrmPreViewH").style.height = conlistH + 9 + "px";
		break;
	}

	// row가 선택 되어 있다면
	if(itemseq) {
		showPreview(isPreview, itemseq);
	}
}


// preview창 show method
function showPreview(isPreview, itemseq) {
	var doc = window.document;

	// row 선택 X
	if(itemseq == 0) {
		doc.getElementById('Preview_HeaderH').style.visibility ="hidden";
//		doc.getElementById("ifrmPreViewH").src = "/blank_kr.htm"; //일본어일때 폰트 문제로 주석
		setTimeout(function(){
			ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLanghyh2;
		}, 500);
	} else { // row 선택
		if(isPreview == 2) {
			// 세로 모드
			var itemSeqTitle = $("#"+itemseq)[0].parentNode.parentNode.children[2].innerHTML;
			var itemSeqSDate = $("#"+itemseq)[0].parentNode.parentNode.children[3].innerHTML;
			doc.getElementById('Preview_HeaderH').style.visibility ="";
			doc.getElementById('Preview_HeaderH').title = itemSeqTitle;
			doc.getElementById('PreH_sub_subject').innerHTML = itemSeqTitle;
			doc.getElementById('PreH_date').innerHTML = itemSeqSDate;
			PrevViewFormH.itemSeq.value = itemseq;
			PrevViewFormH.submit();
			if(itemseq!=0) {
				if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
					doc.getElementById("ifrmPreViewH").style.height = conH - 21 + "px";
				} 
			}
		}
	}
}

// 페이징 객체 생성 method
function td_Create1(strtext) {
	document.getElementById("tblPageRayer").innerHTML = strtext;
}

// 페이징 method
function makePageSelPage() {
	// 페이지 이동시 체크박스 해제
	checkFlag = false;
	$("#checkAll").prop("checked", false);

	var strtext;
	var PagingHTML = "";
	document.getElementById("tblPageRayer").innerHTML = "";
	document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + TotalCount + "</span>";
	strtext = "<div class='pagenavi'>";
	PagingHTML += strtext;

		if (totalPage > 1 && pageNum != 1) {
		strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg first disabled'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > BlockSize) {
		if (pageNum > BlockSize) {
			strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='btnimg prev disabled'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "<span class='btnimg prev disabled'></span>";
		PagingHTML += strtext;
	}


	var MaxNum;
	var i;
	var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	if (totalPage >= (startNum + parseInt(BlockSize))) {
		MaxNum = (startNum + parseInt(BlockSize)) - 1;
	} else {
		MaxNum = totalPage;
	}


	for (i = startNum; i <= MaxNum; i++) {
		if (i == pageNum) {
			strtext = "<span class='on'>" + i + "</span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
			PagingHTML += strtext;
		}
	}


	//2018-08-02 김보미 - 데이터가 하나도 없을때 디폴트 페이징
	if (i == 1) {
		strtext = "<span class='on'>" + i + "</span>";
		PagingHTML += strtext;
	}


	if (totalPage > BlockSize) {
		if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
			strtext = "";
			strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "";
			strtext = strtext + "<span class='btnimg next disabled'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "";
		strtext = strtext + "<span class='btnimg next disabled'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg last disabled'></span>";
		PagingHTML += strtext;
	}

	PagingHTML += "</div>";
	td_Create1(PagingHTML);
}

function goToPageByNum(Value) {
	pageNum = Value;
	makePageSelPage();
	makelist();
}

function selbeforeBlock() {
	pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	goToPageByNum(pageNum);
}

function selbeforeBlock_one() {
	if (parseInt(pageNum - 1) > 0) {
		goToPageByNum(parseInt(pageNum - 1));
	} else {
		return;
	}
}

function selafterBlock() {
	pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	goToPageByNum(pageNum);
}

function selafterBlock_one() {
	if (parseInt(pageNum + 1) <= totalPage) {
		goToPageByNum(parseInt(pageNum + 1));
	} else {
		return;
	}
}

function selNum(pselNum) {
	pageNum = pselNum;
	makelist();
}

function selNext() {
	pageNum = pageNum + 1;
	makelist();
}

function selPrev() {
	pageNum = pageNum - 1;
	makelist();
}

function td_Create(strtext) {
	tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
}

// 윈도우 리사이즈 method
var conH;
function windowResize() {
	var doc = window.document;
	var mainView = doc.getElementById("mainView");
	var height = doc.documentElement.clientHeight - 122 - document.getElementById("mainmenu").clientHeight;
	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
		height = height - 30;
	}

	conH = height;
	if(isPreview == 0) {
		doc.getElementById("contentlist").style.height = height + "px";
		doc.getElementById("contentlist").style.overflow = "auto";
	} else if ( isPreview == 2) {
		doc.getElementById("contentlist").style.height = height + "px";
		doc.getElementById("contentlist").style.overflow = "auto";
		doc.getElementById("previewH").style.height = height + 30 + "px";
		doc.getElementById("previewmail_bar_h").style.height = height + 47 + "px";
		doc.getElementById("ifrmPreViewH").style.height = height + 9 + "px";
		if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			doc.getElementById("ifrmPreViewH").style.height = conH - 21 + "px";
		} 
	}
}