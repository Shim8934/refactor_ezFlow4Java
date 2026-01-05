// 회사 변경 method
function changeCompany() {
	makelist();
	showPreview(2, 0);
}

//managePopup 호출 method
function makelist() {
	$.ajax({
		type : "POST",
		dataType : "text",
		url : "/admin/ezPersonal/managePopupList.do",
		async : false,
		data : {
			companyID : encodeURIComponent(document.getElementById("ListCompany").value),
			page : pageNum
		},
		success : function (result) {
			event_PopupList(loadXMLString(result));
		}
	});
}

//xml -> listView parsing method
function event_PopupList(result) {
	try {
		document.getElementById("AccessList").innerHTML = "";
		var xmldom = result;
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
		listview.SetRowOnClick("PopupList_onClick");
		listview.SetRowOnDblClick("PopupList_onDblclick");
		listview.DataSource(headerData);
		listview.DataBind("AccessList");
		//listview.DataSource(xmldom);
		listview.RowDataBind();
		checkbox_header();
		xmldomNode = null;
		
		if (CrossYN() && navigator.userAgent.indexOf("Trident/7.0") < 0) {
			TotalCount = parseInt(SelectSingleNodeValueNew(xmldom, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom, "CURPAGE"));
		} else if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			//IE11일때 추가
			TotalCount = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "CURPAGE"));
		} else {
			TotalCount = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "TOTALCNT"));
			pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "CURPAGE"));
		}

		totalPage = Math.ceil(new Number(TotalCount / PageSize));
		
		//2018-08-09 김보미 - 데이터가 없을 경우 출력
		if (headerData.getElementsByTagName("ROW").length == 0) {
			var TR_noItems = "<tr id='Link_TR_noItems'><td style='text-align: center;' colspan='7'>" + strLanghyh8 + "</td></tr>";
			$("#AccessListView tbody").eq(0).html(TR_noItems);
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
	th.innerHTML = "<div class='custom_checkbox'><input type='checkbox' id = 'checkAll' onchange='checkboxHeaderClick()'/></div>";
	
	cnt = acList.children[1].childElementCount;
	var i = 0;
	for(i;i<cnt;i++) {
		var seq = acList.children[1].children[i].getAttribute("data1");
		var inuse = acList.children[1].children[i].getAttribute("inuse");
		var jinhangFlag = acList.children[1].children[i].children[5].innerHTML;
		acList.children[1].children[i].children[0].innerHTML = "<div class='custom_checkbox'><input type='checkbox' name='checks' class='checks' id='" + seq + "' value='" + seq +"' onchange='inputFunc(event,"+seq+")'/>";
		acList.children[1].children[i].children[6].innerHTML = "<label class='switch' id='switch" + seq + "' inuse='" + inuse +"' onclick='inUseUpdate(event," + seq +")'><input type='checkbox'><span class='slider round'></span></label></div>";

		if(jinhangFlag == 1) {
			acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse.png' border='0' class='jinhang' progress='1'>";
		} else if(jinhangFlag == 0) {
			acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse_end.png' border='0' class='jinhang' progress='0'>";
		} else {
			acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse_schedule.png' border='0' class='jinhang' progress='2'>";
		}

		if(inuse == 1) {
			$("#switch"+seq).find("input").prop("checked", true);
		} else {
			$("#switch"+seq).find("input").prop("checked", false);
		}
	}
}

//체크박스 헤더 클릭 method
var checkFlag = false;
function checkboxHeaderClick() {

	var doc = window.document;
	var acList = doc.getElementById("AccessListView");
	// 데이터가 있을 경우에만
	if(acList.children[1].children[0].id !== 'Link_TR_noItems'){
		if(checkFlag){
			checkFlag = false;
			$(".checks").prop("checked",false);
			$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
		}else {
			checkFlag = true;
			$(".checks").prop("checked",true);
			$("#contentlist tr td").css("background-color", "rgb(241, 248, 255)");
		}
		checkItems();
	}
}

//체크박스 itemseq 배열 조회 method
var rowList = new Array();
function checkItems() {
	rowList = [];
	$("input:checkbox[name='checks']").each(function(){
		if($(this).is(":checked")) {
			rowList.push(this.value);
		}
	});
}

//등록, 수정 , 삭제 후 rowSelect 선택 method
function rowListSelect() {
	var len = rowList.length;
	for(var i=0; i<len; i++) {
		var tempItemSeq = rowList.pop();
		if(document.getElementById(tempItemSeq) != null) {
			$("#" + tempItemSeq).prop("checked", true);
			var tempID = $("#" + tempItemSeq)[0].closest('tr').id;
			$("#" + tempID + " td").css("background-color", "rgb(241, 248, 255)");
		}
	}
	
	if(checkFlag) {
		$("#checkAll").prop("checked",true);
	} else {
		$("#checkAll").prop("checked",false);
	}
}

//체크박스 클릭 method
function inputFunc(event, itemseq) {
	checkItems();
	$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");

	for(var i=0; i<rowList.length; i++) {
		var objID = $("#"+rowList[i])[0].closest('tr').id;
		$("#" + objID + " td").css("background-color", "rgb(241, 248, 255)");
		$("#" + rowList[i]).prop("checked", true);
	}
}

//row 클릭 method
var itemseq;
function PopupList_onClick(obj, event) {
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

//row 더블 클릭 method
function PopupList_onDblclick(obj) {
	var popup_number = document.getElementById(obj).getAttribute("DATA1");
	var wWidth = document.getElementById(obj).getAttribute("DATA2");
	var wHeight = document.getElementById(obj).getAttribute("DATA3");
	var wPosition = document.getElementById(obj).getAttribute("DATA4");
	var wVertical, wHorizontal;

	if (wPosition == 0) {
		wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
		wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	} else if (wPosition == 1) {
		wVertical = 100;
		wHorizontal = 100;
	} else if (wPosition == 2) {
		wVertical = screen.height - wHeight - 100;
		wHorizontal = 100;
	} else if (wPosition == 3) {
		wVertical = 100;
		wHorizontal = screen.width - wWidth - 100;
	} else if (wPosition == 4) {
		wVertical = screen.height - wHeight - 100;
		wHorizontal = screen.width - wWidth - 100;
	} else if (wPosition == 5) {
		wVertical = 100;
		wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	} else if (wPosition == 6) {
		wVertical = screen.height - wHeight - 100;
		wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	} else {
		wVertical = 0;
		wHorizontal = 0;
	}

	if (wVertical < 0) {
		wVertical = 0;
	}

	if (wHorizontal < 0) {
		wHorizontal = 0;
	}

	window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + popup_number +
		"&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
}

//공지사항 팝업 호출 method
var showPopupPage = function() {
	var wWidth = $("#"+itemseq)[0].closest('tr').getAttribute('DATA2');
	var wHeight = $("#"+itemseq)[0].closest('tr').getAttribute('DATA3');
	var wPosition = $("#"+itemseq)[0].closest('tr').getAttribute('DATA4');
	var wVertical, wHorizontal;

	if (wPosition == 0) {
		wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
		wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	} else if (wPosition == 1) {
		wVertical = 100;
		wHorizontal = 100;
	} else if (wPosition == 2) {
		wVertical = screen.height - wHeight - 100;
		wHorizontal = 100;
	} else if (wPosition == 3) {
		wVertical = 100;
		wHorizontal = screen.width - wWidth - 100;
	} else if (wPosition == 4) {
		wVertical = screen.height - wHeight - 100;
		wHorizontal = screen.width - wWidth - 100;
	} else if (wPosition == 5) {
		wVertical = 100;
		wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	} else if (wPosition == 6) {
		wVertical = screen.height - wHeight - 100;
		wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);
	} else {
		wVertical = 0;
		wHorizontal = 0;
	}

	if (wVertical < 0) {
		wVertical = 0;
	}

	if (wHorizontal < 0) {
		wHorizontal = 0;
	}

	window.open("/admin/ezPersonal/showPopup.do?itemSeq=" + itemseq +
		"&answer=", "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status = no, toolbar=no, menubar=no,location=no, resizable=0");
}

// 사용여부 업데이트
var useFlag =true;
function inUseUpdate(event, seq) {
	event.stopPropagation();

	if(!useFlag) {
		useFlag = true;
		return;
	}

	var inuse = $("#switch" + seq).attr("inuse");

	if(inuse == 0) {
		inuse = 1;
	} else {
		inuse = 0;
	}

	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/setPopupUse.do",
		async : false,
		data : {
			"itemSeq" : seq,
			"inUse" : inuse
		},
		dataType : "text",
		success : function (result) {
			if(result === "OK") {
				$("#switch" + seq).attr("inuse", inuse);
				$("#switch" + seq)[0].closest('tr').setAttribute("inuse", inuse);
			}
		}, error: function(xhr, option, error) {
			console.log(xhr.status);
			if(inuse == 1) {
				$("#switch"+seq).find("input").prop("checked", false);
			} else {
				$("#switch"+seq).find("input").prop("checked", true);
			}
		}
	});
	useFlag = false;
}

// 등록, 수정, 삭제  method
function setFucntion() {
	var doc = window.document;
	var add = doc.getElementById("add");
	var mod = doc.getElementById("mod");
	var del = doc.getElementById("del");
	add.addEventListener("click", add_popup);
	mod.addEventListener("click", mod_popup);
	del.addEventListener("click", del_popup);
}

// 등록 method
var add_popup = function() {
	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 680) / 2;
	var pLeft = (pwidth - 820) / 2;
	var compid = document.getElementById("ListCompany").value;

	if (browserIE) {
		if(pNoneActiveX == "YES") {
			window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&flag=add", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=690,width=720,top=" + pTop + ",left=" + pLeft, "");
		} else {
			window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&flag=add", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=690,width=720,top=" + pTop + ",left=" + pLeft, "");
		}
	} else {
		window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&flag=add", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=690,width=720,top=" + pTop + ",left=" + pLeft, "");
	}
}

// 수정 method
var mod_popup = function() {
	var modCnt = 0;
	popupList = "";
	$("input:checkbox[name='checks']").each(function(){
		if($(this).is(":checked")) {
			popupList += this.value;
			modCnt = modCnt + 1;
		}
	});

	if(!popupList) {
		alert(strLanghyh9);
		return;
	}

	if(modCnt>1) {
		alert(strLanghyh10);
		return;
	}

	var pheight = window.screen.availHeight;
	var pwidth = window.screen.availWidth;
	var pTop = (pheight - 620) / 2;
	var pLeft = (pwidth - 820) / 2;
	var compid = document.getElementById("ListCompany").value;

	if (CrossYN()) {
		window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&itemSeq=" + popupList + "&flag=mod", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=690,width=720,top=" + pTop + ",left=" + pLeft, "");
	} else {
		window.open("/admin/ezPersonal/addPopupCK.do?companyID=" + compid + "&itemSeq=" + popupList + "&flag=mod", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=690,width=720,top=" + pTop + ",left=" + pLeft, "");
	} 
	popupList = "";
}

// 삭제 method
var popupList ="";
var del_popup = function () {
	popupList = "";
	var delCnt = 0;
	var inUseFlag = false;
	$("input:checkbox[name='checks']").each(function(){
		if($(this).is(":checked")) {
			var tempID = $(this)[0].id;
			popupList += tempID + ";"
			delCnt = delCnt + 1;
			var tempUse = $("#" + tempID)[0].closest('tr').getAttribute('progress');
			if(tempUse === "1") {
				inUseFlag = true;
			}
		}
	});

	if(!popupList) {
		alert(strLanghyh11);
		return;
	}

	// 삭제 여부 확인
	if(inUseFlag) {
		if (!confirm(strLanghyh12)){
			return;
		}
	} else {
		if (!confirm(strLanghyh13)){
			return;
		}
	}

	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/delPopup.do",
		async : false,
		data : {"popupList" : popupList},
		dataType : "text",
		success : function (result) {
			if (result == "OK") {
				/*alert(strLanghyh15);*/
				
				if((cnt - delCnt) == 0) {
					if(pageNum > 1) {
						pageNum = pageNum -1 ;
					}
					checkFlag = false;
				}
				itemseq=0;
				//2021-08-24 김성준 - 관리자 팝업 공지사항 삭제 후 미리보기 남아있는 부분 수정
				var doc = window.document;
				doc.getElementById("ifrmPreViewH").innerText = "";
				doc.getElementById("ifrmPreViewH").src = blankstr;
				showPreview(isPreview, 0);
				makelist();
			} else {
				alert(strLanghyh14);
			}
		}
	});
	popupList = "";
}

// 팝업공지 config 조회 method
var isPreview = 0;
function getPopupConfig() {
	$.ajax({
		type : "POST",
		dataType : "json",
		aysnc : false,
		url : "/admin/ezPersonal/getPopupConfig.do",
		success : function(result) {
			isPreview = result["configVO"].isPreview;
			changeImg(isPreview);
			setPreview(isPreview);
		}, error: function(xhr, option, error){
			isPreview = 0;
		}
	});
}


// 팝업공지 config 업데이트 method
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
		url : "/admin/ezPersonal/setPopupConfig.do",
		success : function(result) {
			if(result === "OK") {
				changeImg(isPreview);
				setPreview(isPreview);
			}
		}, error: function(xhr, option, error){
			isPreview = temp;
		}
	});
}

// 미리보기 버튼 교체  method
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


// 미리보기창 set method
function setPreview(previewNum) {
	var conlistH = conH
	var doc = window.document;
	var mainView = doc.getElementById("mainView");
	var previewH = doc.getElementById("previewH");
	var PreviewRayerH = doc.getElementById("PreviewRayerH");
	var contentlistH = doc.getElementById("contentlist");
	var previewmail_bar_h = doc.getElementById("previewmail_bar_h");
	var porContent_RayerH = doc.getElementById("PreContent_RayerH");
	var frameDiv = doc.getElementById("frameDiv");
	var preview_area = doc.getElementById("preview_area");
	
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
		mainView.style.width = "50%";
		previewH.style.width = "49%";
		previewH.style.height = conlistH + 47 + "px";
		previewH.style.display = "";
		previewmail_bar_h.style.height = conlistH + 47 + "px";
		PreviewRayerH.style.display = "";
		
		/*doc.getElementById("ifrmPreViewH").style.display = "";
		doc.getElementById("ifrmPreViewH").style.height = conlistH + 47 + "px";
		if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			doc.getElementById("ifrmPreViewH").style.height = conH + 20 + "px";
		} */
		
		porContent_RayerH.style.height = conlistH + 47 + "px";
		frameDiv.style.height = conlistH - 10 + "px";
		preview_area.style.height = conlistH - 5 + "px";
		break;
	}

	//row가 선택 되어 있다면
	if(itemseq) {
		showPreview(isPreview, itemseq);
	}
}

//미리보기창 show method
function showPreview(isPreview, itemseq) {
	var doc = window.document;

	if(itemseq == 0) {
		doc.getElementById("ifrmPreViewH").style.display = "none";// 미리보기 화면에서 팝업이 커지면서(width=96%, height=96%) 없어지는 현상때문에 작성.
		doc.getElementById('Preview_HeaderH').style.visibility ="hidden";
		doc.getElementById("ifrmPreViewH").style.width = "96%";
		doc.getElementById("ifrmPreViewH").style.height = "96%";
//		doc.getElementById("ifrmPreViewH").src = "/blank_kr.htm"; //일본어일때 폰트 문제로 주석
		
		setTimeout(function(){
			doc.getElementById("ifrmPreViewH").style.display = "";
		}, 200);
		setTimeout(function(){
			ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLanghyh9
		}, 500);
	} else {
		if(isPreview == 2) {
			// 세로 모드
			doc.getElementById("ifrmPreViewH").style.width = "0px";
			doc.getElementById("ifrmPreViewH").style.height = "0px";
			var itemSeqTitle = $("#" + itemseq).closest("tr").find("td").eq(2).text().trim();
			var itemSeqSDate = $("#" + itemseq).closest("tr").find("td").eq(3).text().trim();
			doc.getElementById('Preview_HeaderH').style.visibility ="";
			doc.getElementById('Preview_HeaderH').title = itemSeqTitle;
			doc.getElementById('PreH_sub_subject').innerHTML = itemSeqTitle;
			doc.getElementById('PreH_date').innerHTML = itemSeqSDate;
			PrevViewFormH.itemSeq.value = itemseq;
			PrevViewFormH.submit();
			var conlistH = conH
			/*doc.getElementById("").style.height = conlistH + 11 + "px";
			if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
				doc.getElementById("ifrmPreViewH").style.height = conH - 20 + "px";
			}*/ 
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
	document.getElementById("mailBoxInfo").innerHTML = "<span class='txt_color'> " + TotalCount + " </span>";
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

//윈도우 리사이즈 method
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
		/*if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			doc.getElementById("ifrmPreViewH").style.height = conH - 20 + "px";
		}*/
	} else if ( isPreview == 2) {
		doc.getElementById("contentlist").style.height = height + "px";
		doc.getElementById("contentlist").style.overflow = "auto";
		doc.getElementById("previewH").style.height = height + 41 + "px";
		doc.getElementById("previewmail_bar_h").style.height = height + 47 + "px";
		doc.getElementById("PreContent_RayerH").style.height = height + 47 + "px";
		doc.getElementById("frameDiv").style.height = height - 10 + "px";
		doc.getElementById("preview_area").style.height = height - 5 + "px";
		/*doc.getElementById("ifrmPreViewH").style.height = height + 11 + "px";
		if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
			doc.getElementById("ifrmPreViewH").style.height = conH - 20 + "px";
		}*/
	}
}