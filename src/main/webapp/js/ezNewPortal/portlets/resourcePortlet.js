// date -> string (parse yyyy-mm-dd)
function DateFormat(obj) {

    var yy = String(obj.getFullYear()).substring(0, 4);

    if (String(obj.getMonth() + 1).length == 1) var mm = "0" + (obj.getMonth() + 1);
    else var mm = obj.getMonth() + 1;

    if (String(obj.getDate()).length == 1) var dd = "0" + obj.getDate();
    else var dd = obj.getDate();

    var date = String(yy) + "-" + String(mm) + "-" + String(dd);
    return date;
}

// 자원관리 페이지로 이동
function viewResource() {
    document.getElementById("resourcePlus").addEventListener("click", function() {
        window.open("/ezResource/resMain.do", "main", "");
    });
}

function showPersResource() {
    document.getElementById("resourceSetting").addEventListener("click", function() {
    	var schedule_add_select_cross_dialogArguments = new Array();
    	if (CrossYN()) {
            var url = "/ezResource/scheduleAddSelect.do";

            schedule_add_select_cross_dialogArguments[0] = "";
            schedule_add_select_cross_dialogArguments[1] = btnWrite_onclick_Complete;
            var Schedule_Add_Select_Cross = GetOpenWindow(url, "Schedule_Add_Select_Cross", 552, 435);
            try { Schedule_Add_Select_Cross.focus(); } catch (e) {
            }
        } else {
            var url = "/ezResource/scheduleAddSelect.do";
            var feature = "status:no;dialogWidth:552px;dialogHeight:430px;help:no;scroll:no;edge:sunken";
            feature = feature + GetShowModalPosition(552, 422);
            var ret = window.showModalDialog(url, "", feature);

            if (ret != undefined && ret[0][0] != undefined) {
                url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];
                feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
                feature = feature + GetShowModalPosition(700, 700);
                window.showModalDialog(url, ret, feature);
            }
        }
    });
}

function btnWrite_onclick_Complete(ret) {
    if (ret != "close" && ret != undefined && ret[0][0] != undefined) {
        url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=&seled=&dayView=&ownerID=" + ret[0][0];

        var Schedule_Add_ck = window.open(url, "Schedule_Add_Cross", GetOpenWindowfeature(820, 700));
        
        try { Schedule_Add_ck.focus(); } catch (e) {}
    }
}

// 포틀릿 조회
function getPersPortlet(){
	var xmlStr = "<PARAMETER><STARTDATETIME>" + Sdatepicker.value  + "</STARTDATETIME><ENDDATETIME>" + Sdatepicker.value + "</ENDDATETIME><APP>1</APP></PARAMETER>";
    $.ajax({
        type : "GET",
        data : {date : xmlStr},
        dataType : "JSON",
        url : "/ezResource/getResourcePortlet.do",
        async : false,
        success : function(result) {
            if (result.status == 'ok') {
                var _list = result["list"];
            	var pNode = document.getElementById("Resource_Portlet_List"); 
            	while ( pNode.hasChildNodes() ) { pNode.removeChild( pNode.firstChild ); } 
                _list.forEach(function(vo, index) {		// list mapping
                	mappingResourcePortlet(vo);  
                });
                if(_list.length == 0) resourceNodata();	// nodata
            }
        },
        error : function() {}
    });
}

function mappingResourcePortlet(vo){
	var timeTable = vo.rsPortletTime.split(";");
	var num       = vo.rsPortletNum.split(";");
	var cnt       = timeTable.length; 
	// if(cnt>4)     {cnt=4;} // 포틀릿 스크롤바 때문에 최대 3개로 고정 // 2024-06-07 디자인 변경사항 : 예약 시간 추가한 것 다 보이도록 수정
	
	var li       = document.createElement("li");
	var dl       = document.createElement("dl");
	var dt       = document.createElement("dt");
	var spanImg  = document.createElement("span");
	var spanTxt  = document.createElement("span");
	var dd       = document.createElement("dd");
	var p        = document.createElement("p");
	var spanIcon = document.createElement("span");


	dl.setAttribute("class", "resource_listBoxDL");
	if(vo.approveFlag == 1) { spanImg.setAttribute("class", "sub_iconLNB tree_resource_ok");}
	else if(vo.approveFlag == 0) { spanImg.setAttribute("class", "sub_iconLNB tree_resource_standard");}
	else { spanImg.setAttribute("class", "sub_iconLNB tree_resource_no");}
	spanTxt.setAttribute("class", "resource_list_text");
	spanTxt.addEventListener('click', function(event) {reserveInfoPopup(vo.brdID)});
	if(typeof(userLang2) != "undefined" && userLang2 != "1"){
		spanTxt.textContent = vo.brdNm2;
	}else{
		spanTxt.textContent = vo.brdNm;
	}
	if(cnt==1) { // 예약이 없을 경우 
		p = makeEmptyList(vo.brdID);
		dd.appendChild(p);
	} else {		// 예약 있음
		for(var i=0; i<cnt-1; i++) {
			var p = document.createElement('p');
			var arr  = new Array();
			p.setAttribute("class", "resource_list_item");
			p.setAttribute("num", num[i]);
			p.setAttribute("ownerID", vo.brdID);
			p.textContent = timeTable[i];
			p.addEventListener('click', function(event) {reserveViewPopup()});
			dd.appendChild(p);
		}
		// if(cnt<4) {
			p = makeEmptyList(vo.brdID);
			dd.appendChild(p);
		// }
	}

	dt.appendChild(spanImg);
	dt.appendChild(spanTxt);
	dl.appendChild(dt);
	dl.appendChild(dd);
	li.appendChild(dl);

	document.getElementById("Resource_Portlet_List").appendChild(li);
}

// 
function makeEmptyList(brdID) {
	var p        = document.createElement("p");
	var spanIcon = document.createElement("span");
	
	p.setAttribute("class", "resource_list_add");
	spanIcon.setAttribute("class", "icon_resource_add");
	p.appendChild(spanIcon);
	p.addEventListener('click', function(event) {reserveSavePopup(brdID)});
	return p;
}

// 사용하는 자원이 없음
function resourceNodata() {
	var dl  = document.createElement("dl");
	var dt  = document.createElement("dt");
	var dd  = document.createElement("dd");
	var img = document.createElement("img");

	img.setAttribute("src", "/images/kr/main/noData_sIcon.png");
	dl.setAttribute("class", "nodata");
	dd.textContent = messages.strLang1;
	
	dt.appendChild(img);
	dl.appendChild(dt);
	dl.appendChild(dd);

	document.getElementById("Resource_Portlet_List").appendChild(dl);
}

//예약 등록 팝업
function reserveInfoPopup(id) {
	 var url = "/ezResource/viewClsItem.do?brdID=" + id;
     var feature =  "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1"
     feature = feature + GetOpenPosition(820, 700);
     window.open(url, "", feature);
}

// 예약 등록 팝업
function reserveSavePopup(id) {
	 var selectedDate = Sdatepicker.value.replace(/\./g, "-");
	 var url = "/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selectedDate + "&seled=" + selectedDate + "&dayView=&ownerID=" + id;
     var feature =  "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1"
     feature = feature + GetOpenPosition(820, 700);
     window.open(url, "", feature);
}

// 예약 보기/수정 팝업
function reserveViewPopup() {//0 num //1 id
	var _this    = event.target;
	var _num     = _this.getAttribute('num');
	var _ownerID = _this.getAttribute('ownerID');
	var selectedDate = Sdatepicker.value.replace('/\./g', '-');
	var url     = "/ezResource/scheduleRead.do?cmd=mod&from=schedule&num=" + _num + "&ownerID=" + _ownerID + "&type=Master&startDate=" + selectedDate + "&endDate=" + selectedDate
    var feature =  "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1"
    
	feature = feature + GetOpenPosition(820, 700);
    window.open(url, "", feature);
}

function settingResourceCalendar() {
	var dayList = messages.strLangSchedule01.split(";");
 	var dSun = dayList[0];
	var dMon = dayList[1];
	var dTue = dayList[2];
	var dWed = dayList[3];
	var dThu = dayList[4];
	var dFri = dayList[5];
	var dSat = dayList[6];
	$("#Sdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ezNewPortal/calIcon.png",
		buttonImageOnly: true,
		closeText: messages.strLang601,
		prevText: messages.strLang599,
		nextText: messages.strLang600,
		currentText: messages.strLang598,
		monthNames: [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597],
		monthNamesShort: [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597],
		dayNames: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesShort: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesMin: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		weekHeader: "Wk",
		dateFormat: "yy.mm.dd",
		firstDay: 0,
		isRTL: false,
		duration: 200,
		showAnim: "show",
		showMonthAfterYear: true,
		onSelect: function(dateText, inst) {
			var date = $(this).val();
			getPersPortlet();
		}
	});
	
	var SDate = new Date();
	$("#Sdatepicker").datepicker('setDate', SDate);
}