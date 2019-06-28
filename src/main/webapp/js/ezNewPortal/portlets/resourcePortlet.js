// init
function initResource() {
	dateMapping();
	getPersPortlet();
}

// 날짜 매핑
function dateMapping() {
	$("#Sdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ezNewPortal/calIcon.png",
		buttonImageOnly: true
	});
	
	var SDate = new Date();
	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#Sdatepicker").datepicker('setDate', SDate);

	$.datepicker.regional[strLang602] = {
		closeText: strLang601,
		prevText: strLang599,
		nextText: strLang600,
		currentText: strLang598,
		monthNames: [strLang586, strLang587, strLang588, strLang589, strLang590, strLang591, strLang592, strLang593, strLang594, strLang595, strLang596, strLang597],
		monthNamesShort: [strLang586, strLang587, strLang588, strLang589, strLang590, strLang591, strLang592, strLang593, strLang594, strLang595, strLang596, strLang597],
		dayNames: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesShort: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		dayNamesMin: [dSun, dMon, dTue, dWed, dThu, dFri, dSat],
		weekHeader: "Wk",
		dateFormat: "yy-mm-dd",
		firstDay: 0,
		isRTL: false,
		duration: 200,
		showAnim: "show",
		showMonthAfterYear: true,
		onSelect: function(dateText, inst) {
			var date = $(this).val();
			getPersPortlet();
		}
	};
	$.datepicker.setDefaults($.datepicker.regional[strLang602]);
}

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
            var url = "/ezResource/resPersPortlet.do";

            schedule_add_select_cross_dialogArguments[0] = "";
            schedule_add_select_cross_dialogArguments[1] = btnWrite_onclick_Complete;
            var Schedule_Add_Select_Cross = GetOpenWindow(url, "Schedule_Add_Select_Cross", 552, 435);
            try { Schedule_Add_Select_Cross.focus(); } catch (e) {
            }
        } else {
            var url = "/ezResource/resPersPortlet.do";
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
	var timeTable = vo.makeDate.split(";");
	var num       = vo.brdExplain.split(";");
	var cnt       = timeTable.length; 
	if(cnt>4)     {cnt=4;} // 포틀릿 스크롤바 때문에 최대 3개로 고정
	
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
	spanTxt.addEventListener('click', function(event) {reserveSavePopup(vo.brdID)});
	spanTxt.textContent = vo.brdNm;
	if(cnt==1) {	// 예약이 없을 경우
		p.setAttribute("class", "resource_list_add");
		spanIcon.setAttribute("class", "icon_resource_add");
		p.appendChild(spanIcon);
		p.addEventListener('click', function(event) {reserveSavePopup(vo.brdID)});
		dd.appendChild(p);
	} else {		// 예약 있음
		for(var i=0; i<cnt-1; i++) {
			var span = document.createElement('span');
			var arr  = new Array();
			arr[0] = num[i];
			arr[1] = vo.brdID;
			span.setAttribute("class", "resource_list_item");
			span.textContent = timeTable[i];
			span.addEventListener('click', function(event) {reserveViewPopup(arr)});
			dd.appendChild(span);
		}
	}

	dt.appendChild(spanImg);
	dt.appendChild(spanTxt);
	dl.appendChild(dt);
	dl.appendChild(dd);
	li.appendChild(dl);

	document.getElementById("Resource_Portlet_List").appendChild(li);
}

// 사용하는 자원이 없음
function resourceNodata() {
	var dl  = document.createElement("dl");
	var dt  = document.createElement("dt");
	var dd  = document.createElement("dd");
	var img = document.createElement("img");

	img.setAttribute("src", "/images/kr/main/noData_sIcon.png");
	dl.setAttribute("class", "nodata");
	dd.textContent = "\"" + strLang500 + "\"";
	
	dt.appendChild(img);
	dl.appendChild(dt);
	dl.appendChild(dd);

	document.getElementById("Resource_Portlet_List").appendChild(dl);
}

// 예약 등록 팝업
function reserveSavePopup(id) {
	 var url = "/ezResource/persPortletAdd.do?cmd=add&from=schedule&selsd=" + Sdatepicker.value + "&seled=" + Sdatepicker.value + "&dayView=&ownerID=" + id;
     var feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
     feature = feature + GetShowModalPosition(700, 700);
     window.showModalDialog(url, "", feature);
}

// 예약 보기/수정 팝업
function reserveViewPopup(arr) {//0 num //1 id
	var url = "/ezResource/persPortletRead.do?cmd=mod&from=schedule&num=" + arr[0] + "&ownerID=" + arr[1] + "&type=Master&startDate=" + Sdatepicker.value+ "&endDate=" + Sdatepicker.value
    var feature = "status:no;dialogWidth:770px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
    feature = feature + GetShowModalPosition(700, 700);
    window.showModalDialog(url, "", feature);
}