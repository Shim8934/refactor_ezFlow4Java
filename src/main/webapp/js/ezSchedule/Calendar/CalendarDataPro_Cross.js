var wTable;
var xmlhttp;
var chk_usersearch = "";

var delFlag = false;

function CalViewSource(chk_str) {
	xmlhttp = createXMLHttpRequest();
	var xmlpara;

    if(chk_usersearch == "UserSearch"){
        xmlpara = "STARTDATE=" + sStartDate + "&ENDDATE=" + sEndDate + "&APP=" + chk_str + "&GROUPID=" + groupid + "&IDLIST=T" + "&resultUserID=" + encodeURIComponent(resultUserID) + "&chk_usersearch=" + encodeURIComponent(chk_usersearch) + "&resultDeptName=" + encodeURIComponent(resultDeptName)+ "&resultDeptID=" + encodeURIComponent(resultDeptID)+ "&resultCompanyID=" + encodeURIComponent(resultCompanyID);
    }else {
        xmlpara = "STARTDATE=" + sStartDate + "&ENDDATE=" + sEndDate + "&APP=" + chk_str + "&GROUPID=" + groupid + "&IDLIST=T";
    }

    if (!delFlag) {
    	xmlhttp.open("POST", "/ezSchedule/scheduleGetList.do", true);
    } else {
    	xmlhttp.open("POST", "/ezResource/scheduleGetList.do", false);
    }
    
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    
    if (typeCal == 0) {
        if (!delFlag) {
            xmlhttp.onreadystatechange = getCalMonthViewSource_after;
            xmlhttp.send(xmlpara);
        }
        else {
            xmlhttp.send(xmlpara);
            getCalMonthViewSource_after();
        }
    }
    else if (typeCal == 1) {
        if (!delFlag) {
            xmlhttp.onreadystatechange = getCalWeekViewSource_after;
            xmlhttp.send(xmlpara);
        }
        else {
        	xmlhttp.send(xmlpara);
            getCalWeekViewSource_after();
        }

    }
    else if (typeCal == 2) {
        if (!delFlag) {
            xmlhttp.onreadystatechange = getCalDayViewSource_after;
            xmlhttp.send(xmlpara);
        }
        else {
            xmlhttp.send(xmlpara);
            getCalDayViewSource_after();
        }
    }
    delFlag = false;
}

//2018-06-19 구해안 이동할때 css 적용하는 함수 제작
function chk_scheduleCSS() {
	if (typeCal == 0) {
		
		$("input[name=chk_schedule]", parent.frames["left"].document).each(function (index) {
			var chk_eachVal1 = $(this).val();
			var chk_type = $(this).data("schedule-type");
			
			if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
				$('.td_list td[scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).addClass('chk_noneDisplay');
				});
			} else {
				$('.td_list td[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).addClass('chk_noneDisplay');
				});
			}
		});
		
		$("input[name=chk_schedule]:checked", parent.frames["left"].document).each(function (index) {
			var test = $(this).val();
			var chk_type = $(this).data("schedule-type");
			
			if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
				$('.td_list td[scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).removeClass('chk_noneDisplay');
				});
			} else {
				$('.td_list td[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).removeClass('chk_noneDisplay');
				});
			}
		});
	} else if (typeCal == 1) {
		
		$("input[name=chk_schedule]", parent.frames["left"].document).each(function (index) {
			var chk_eachVal1 = $(this).val();
			var chk_type = $(this).data("schedule-type");
			
			if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
				$('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).addClass('chk_noneDisplay');
				});
			} else {
				$('div[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).addClass('chk_noneDisplay');
				});
			}
		});
		
		$("input[name=chk_schedule]:checked", parent.frames["left"].document).each(function (index) {
			var test = $(this).val();
			var chk_type = $(this).data("schedule-type");
			
			if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
				$('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).removeClass('chk_noneDisplay');
				});
			} else {
				$('div[ownerid = "'+test+'"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).removeClass('chk_noneDisplay');
				});
			}
		});
	} else {
		$("input[name=chk_schedule]", parent.frames["left"].document).each(function (index) {
			var chk_eachVal1 = $(this).val();
			var chk_type = $(this).data("schedule-type");
			
			if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
				$('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).addClass('chk_noneDisplay');
				});
			} else {
				$('div[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).addClass('chk_noneDisplay');
				});
			}
		});
		
		$("input[name=chk_schedule]:checked", parent.frames["left"].document).each(function (index) {
			var test = $(this).val();
			var chk_type = $(this).data("schedule-type");
			
			if (chk_type == "10" || chk_type == "1" || chk_type == "4") {
				$('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).removeClass('chk_noneDisplay');
				});
			} else {
				$('div[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
					$(value).removeClass('chk_noneDisplay');
				});
			}
		});
	}
}

function sDataTemp() {
}

function dateDiff(_date1, _date2) {
    var diffDate_1 = _date1 instanceof Date ? _date1 : new Date(_date1);
    var diffDate_2 = _date2 instanceof Date ? _date2 : new Date(_date2);
 
    diffDate_1 = new Date(diffDate_1.getFullYear(), diffDate_1.getMonth()+1, diffDate_1.getDate());
    diffDate_2 = new Date(diffDate_2.getFullYear(), diffDate_2.getMonth()+1, diffDate_2.getDate());
 
    var diff = Math.abs(diffDate_2.getTime() - diffDate_1.getTime());
    diff = Math.ceil(diff / (1000 * 3600 * 24));
 
    return diff;
}

var OrgDataSDT;
var OrgDataEDT;
function getCalMonthViewSource_after() {
    var tempData = new Array();
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    
    try {        
    	if (xmlhttp.responseText == "") return;
    	var listNode = loadXMLString(xmlhttp.responseText);
        var nlength = SelectNodes(listNode, "DATA/ROW").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
            var objNodes = SelectNodes(listNode, "DATA/ROW")[i];
            var _Dtstart = SelectSingleNodeValue(objNodes, "STARTDATE");
            var _Dtend = SelectSingleNodeValue(objNodes, "ENDDATE");    
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));
            OrgDataSDT = new Date(DataSDT);
            OrgDataEDT = new Date(DataEDT);
            if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { 

                var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
                var day = 1000 * 60 * 60 * 24;
                betweenDay = parseInt(betweenDay / day, 10);
                
                for (var j = 0; j <= betweenDay; j++) {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    CalMonthDataBind(tempData[k]);
                    DataSDT.setDate(DataSDT.getDate() + 1);
                    if (dateDiff(DataSDT, DataEDT) < 1 && _Dtend.substring(10) == " 00:00:00.0") {
                    	break;
                    }
                    k += 1;
                }
            } else {
                tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                CalMonthDataBind(tempData[k]);
                k += 1;
            }
            DataSDT = null;
            DataEDT = null;
        }        
        tempData = null;
        chk_scheduleCSS();
    }
    catch (e) {
        alert("getCalMonthViewSource_after : " + e.description);
    }
}



function getCalWeekViewSource_after() {
    var tempData = new Array();
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    
    try {        
    	if (xmlhttp.responseText == "") return;
    	var listNode = loadXMLString(xmlhttp.responseText);
        var nlength = SelectNodes(listNode, "DATA/ROW").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
        	var objNodes = SelectNodes(listNode, "DATA/ROW")[i];

        	// 2020-02-24 김정언 - 근태 현황은 [월보기]에서만 지원한다.
        	if (SelectSingleNodeValue(objNodes, "DATETYPE") == "4") {
        		continue;
        	}
        	
            var _Dtstart = SelectSingleNodeValue(objNodes, "STARTDATE");
            var _Dtend = SelectSingleNodeValue(objNodes, "ENDDATE");
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));

            sStartDate = sStartDate.split("-")[0] + "-" + leadingZeros(sStartDate.split("-")[1], 2) + "-" + leadingZeros(sStartDate.split("-")[2], 2)
            sEndDate = sEndDate.split("-")[0] + "-" + leadingZeros(sEndDate.split("-")[1], 2) + "-" + leadingZeros(sEndDate.split("-")[2], 2)
            OrgDataSDT = new Date(DataSDT);
            OrgDataEDT = new Date(DataEDT);
            if (SelectSingleNodeValue(objNodes, "DATETYPE") != "2") {
                    if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { 

                        var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
                        var day = 1000 * 60 * 60 * 24;
                        betweenDay = parseInt(betweenDay / day, 10);
                        for (var j = 0; j <= betweenDay; j++) {
                            if (j == 0) {
                                DataEDT.setHours(23);
                                DataEDT.setMinutes(59);
                            }
                            else if (j < betweenDay) {
                                DataSDT.setHours(0);
                                DataSDT.setMinutes(0);
                                DataEDT.setHours(23);
                                DataEDT.setMinutes(59);
                            }
                            else {
                                DataSDT.setHours(0);
                                DataSDT.setMinutes(0);
                                DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));
                            }
                            tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                            aheadDataCell(tempData[k], k)
                            CalWeekDataBind(tempData[k], k);
                            if (SelectSingleNodeValue(objNodes, "SHOWTOP") == "Y") {
                                CalWeekTopDataBind(tempData[k], k);
                            }
                            DataSDT.setDate(DataSDT.getDate() + 1);
                            k += 1;
                        }
                    } else {
                        tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                        aheadDataCell(tempData[k], k)
                        CalWeekDataBind(tempData[k], k);
                        if (SelectSingleNodeValue(objNodes, "SHOWTOP") == "Y") {
                            CalWeekTopDataBind(tempData[k], k);
                        }
                        k += 1;
                    }
            }
            else {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { 
                    var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
                    var day = 1000 * 60 * 60 * 24;
                    betweenDay = parseInt(betweenDay / day, 10);
                    if (_Dtend.substring(10) == " 00:00:00.0") {
                    	betweenDay = betweenDay - 1;
                    }
                } else
                    betweenDay = 0;

                for (var j = 0; j <= betweenDay; j++) {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    CalWeekAllDataBind(tempData[k], k);
                    DataSDT.setDate(DataSDT.getDate() + 1);
                    k += 1;
                }
            }
            DataSDT = null;
            DataEDT = null;
        }
        

        for (var i = 0; i < tempData.length; i++) {
            if (tempData[i].DateType != "2")
                CalDataSize(tempData[i], i, tempData);
        }

        for (var i = 0; i < tempData.length; i++) {
            if (tempData[i].DateType != "2")    
                CalDataWidth(tempData[i], i, tempData);
        }
        tempData = null;
        chk_scheduleCSS();
        
      if(chk_usersearch != "UserSearch") {
          //2018-11-05 김혜정  주보기화면에서 드래그앤드롭을 위해 추가 - 하루종일
          if (objNodes != undefined && SelectSingleNodeValue(objNodes, "scheduleFlag") != "google") {
              $("div[id$='ALL'").children().draggable({
                  addClasses: false,
                  revert: "invalid",
                  helper: function (event) {
                      return $(event.target).clone().css({
                          width: $(event.target).width()
                      });
                  },
                  appendTo: "body",
                  containment: "#calTR"
              });

              //2018-11-05 김혜정  주보기화면에서 드래그앤드롭을 위해 추가 - 시간지정
              $("#dayDiv").find("div[id^='div_']").draggable({
                  addClasses: false,
                  cursorAt: {top: 1, left: 1},
                  scroll: false,
                  handle: "td",
                  helper: "clone"
              });
          }
      }
    }
    catch (e) {
        alert("getCalWeekViewSource_after : " + e.description);
    }
}


function getCalDayViewSource_after() {
    var tempData = new Array();
    if (xmlhttp == null || xmlhttp.readyState != 4) return;
    
    try {        
    	if (xmlhttp.responseText == "") return;
    	var listNode = loadXMLString(xmlhttp.responseText);
        var nlength = SelectNodes(listNode, "DATA/ROW").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
            var objNodes = SelectNodes(listNode, "DATA/ROW")[i];

            // 2020-02-24 김정언 - 근태 현황은 [월보기]에서만 지원한다.
            if (SelectSingleNodeValue(objNodes, "DATETYPE") == "4") {
            	continue;
            }
            
            var _Dtstart = SelectSingleNodeValue(objNodes, "STARTDATE");
            var _Dtend = SelectSingleNodeValue(objNodes, "ENDDATE");
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));
            OrgDataSDT = new Date(DataSDT);
            OrgDataEDT = new Date(DataEDT);
            if (SelectSingleNodeValue(objNodes, "DATETYPE") != "2") {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) {

                    var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
                    var day = 1000 * 60 * 60 * 24;
                    betweenDay = parseInt(betweenDay / day, 10);
                    for (var j = 0; j <= betweenDay; j++) {
                        var toDay = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2)
                        var DataDay = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2)
                        if (toDay == DataDay) {
                            if (betweenDay >= 1) {
                                if (j == 0) {
                                    DataEDT.setHours(23);
                                    DataEDT.setMinutes(59);
                                }
                                else if (j < betweenDay) {
                                    DataSDT.setHours(0);
                                    DataSDT.setMinutes(0);
                                    DataEDT.setHours(23);
                                    DataEDT.setMinutes(59);
                                }
                                else {
                                    DataSDT.setHours(0);
                                    DataSDT.setMinutes(0);
                                    DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));
                                }
                            }
                            tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                            aheadDataCell(tempData[k], k);
                            CalDayDataBind(tempData[k], k);
                            if (SelectSingleNodeValue(objNodes, "SHOWTOP") == "Y") {
                                CalDayTopDataBind(tempData[k], k);
                            }

                            k += 1;
                        }
                        DataSDT.setDate(DataSDT.getDate() + 1);
                    }
                } else {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    aheadDataCell(tempData[k], k);
                    CalDayDataBind(tempData[k], k);
                    if (SelectSingleNodeValue(objNodes, "SHOWTOP") == "Y") {
                        CalDayTopDataBind(tempData[k], k);
                    }
                    k += 1;
                }
            }
            else {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { 
                    var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
                    var day = 1000 * 60 * 60 * 24;
                    betweenDay = parseInt(betweenDay / day, 10);
                    if (_Dtend.substring(10) == " 00:00:00.0") {
                    	betweenDay = betweenDay - 1;
                    }
                } else
                    betweenDay = 0;

                for (var j = 0; j <= betweenDay; j++) {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    CalDayAllDataBind(tempData[k], k);
                    DataSDT.setDate(DataSDT.getDate() + 1);
                    if (dateDiff(DataSDT, DataEDT) < 1 && _Dtend.substring(10) == " 00:00:00.0") {
                    	break;
                    }
                    k += 1;
                }

            }
            DataSDT = null;
            DataEDT = null;
        }

        for (var i = 0; i < tempData.length; i++) {
            if(tempData[i].DateType != "2")
                CalDataSize(tempData[i], i, tempData);
        }

        for (var i = 0; i < tempData.length; i++) {
            if (tempData[i].DateType != "2")
                CalDataWidth(tempData[i], i, tempData);
        }        
        tempData = null;
        chk_scheduleCSS();
        if(chk_usersearch != "UserSearch") {
            if (objNodes != undefined && SelectSingleNodeValue(objNodes, "scheduleFlag") != "google") {
                //2018-11-05 김혜정  일보기화면에서 드래그앤드롭을 위해 추가 - 시간지정
                $("#CalDiv").find("div[id^='div_']").draggable({
                    addClasses: false,
                    scroll: true,
                    helper: "clone",
                    cursorAt: {top: 1, left: 1}
                });
            }
        }
    }
    catch (e) {
        alert("getCalDayViewSource_after : " + e.description);
    }
}


function tempInsert(objNodes, DataSDT, DataEDT) {
    var startHour = parseInt(DataSDT.getHours(), 10);
    var endHour = parseInt(DataEDT.getHours(), 10);
    var startMin = parseInt(DataSDT.getMinutes(), 10);
    var endMin = parseInt(DataEDT.getMinutes(), 10);

    if (startMin < 30)
        startMin = 0
    else
        startMin = 30

    if (endMin < 30)
        endMin = 0
    else
        endMin = 30

    var oHour = (endHour - startHour) * 2;
    var oMin = (endMin - startMin);
    if (oMin == -30)
        oMin = -1
    else if (oMin == 30)
        oMin = 1
    
    var timeCnt = oHour + oMin

    if (typeCal != 0 && timeCnt <= 0) {
        timeCnt = 1;
        DataEDT.setHours(24);
        DataEDT.setMinutes(00);
    }

    if(typeCal == 0)
        var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1, 10), 2) + "-" + leadingZeros(DataSDT.getDate(), 2);
    else
        var trID = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2) + "_" + startHour + ":" + startMin.toString().substring(0, 1);

    pTempData = new sDataTemp();
    pTempData.trID = trID;
    pTempData.ScheduleID = SelectSingleNodeValue(objNodes, "SCHEDULEID");
    pTempData.ScheduleChangeKey = SelectSingleNodeValue(objNodes, "SCHEDULECHANGEKEY");
    pTempData.ParentID = SelectSingleNodeValue(objNodes, "PARENTID");
    pTempData.OwnerID = SelectSingleNodeValue(objNodes, "OWNERID");
    pTempData.CreatorID = SelectSingleNodeValue(objNodes, "CREATORID");
    pTempData.CreatorName = SelectSingleNodeValue(objNodes, "CREATORNAME");
    pTempData.ContentPath = SelectSingleNodeValue(objNodes, "CONTENTPATH");
    pTempData.ModifierID = SelectSingleNodeValue(objNodes, "MODIFIERID");
    pTempData.ScheduleType = SelectSingleNodeValue(objNodes, "SCHEDULETYPE");
    pTempData.Importance = SelectSingleNodeValue(objNodes, "IMPORTANCE");
    pTempData.IsReadOnly = SelectSingleNodeValue(objNodes, "ISREADONLY");
    pTempData.DateType = SelectSingleNodeValue(objNodes, "DATETYPE");
    pTempData.Subject = SelectSingleNodeValue(objNodes, "TITLE");
    pTempData.StartDate = mfGetUTFIsoDate(DataSDT.getFullYear(), DataSDT.getMonth(), DataSDT.getDate(), DataSDT.getHours(), DataSDT.getMinutes());
    pTempData.EndDate = mfGetUTFIsoDate(DataEDT.getFullYear(), DataEDT.getMonth(), DataEDT.getDate(), DataEDT.getHours(), DataEDT.getMinutes());
    pTempData.RepeatCount = SelectSingleNodeValue(objNodes, "REPEATCOUNT");
    pTempData.Location = SelectSingleNodeValue(objNodes, "LOCATION"); 
    pTempData.dtstartUTC = mfGetUTFIsoDate(DataSDT.getFullYear(), DataSDT.getMonth(), DataSDT.getDate(), DataSDT.getHours(), DataSDT.getMinutes());
    pTempData.dtendUTC = mfGetUTFIsoDate(DataEDT.getFullYear(), DataEDT.getMonth(), DataEDT.getDate(), DataEDT.getHours(), DataEDT.getMinutes());
    pTempData.dtstartHour = DataSDT.getHours();
    pTempData.dtstartMinute = DataSDT.getMinutes();
    pTempData.dtendHour = DataEDT.getHours();
    pTempData.dtendMinute = DataEDT.getMinutes();
//    pTempData.dtstartDisplay = mfFormatTime((OrgDataSDT.getHours() * 60) + OrgDataSDT.getMinutes());
//    pTempData.dtendDisplay = mfFormatTime((OrgDataEDT.getHours() * 60) + OrgDataEDT.getMinutes());
    pTempData.dtstartDisplay = sbFormatTime(OrgDataSDT.getHours() , OrgDataSDT.getMinutes());
    pTempData.dtendDisplay = sbFormatTime(OrgDataEDT.getHours() , OrgDataEDT.getMinutes());

    pTempData.OrgStartDate = mfGetUTFIsoDate(OrgDataSDT.getFullYear(), OrgDataSDT.getMonth(), OrgDataSDT.getDate(), OrgDataSDT.getHours(), OrgDataSDT.getMinutes());
    pTempData.OrgEndDate = mfGetUTFIsoDate(OrgDataEDT.getFullYear(), OrgDataEDT.getMonth(), OrgDataEDT.getDate(), OrgDataEDT.getHours(), OrgDataEDT.getMinutes());
    
    pTempData.timeCount = timeCnt;
    pTempData.o_start = DataSDT;
    pTempData.o_end = DataEDT;
    pTempData.endDiv = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2) + "_" + endHour + ":" + endMin.toString().substring(0, 1);

    /* 2021-11-26 홍승비 - 일정완료여부 데이터 추가 (html 태그 속성 부여 용도는 아님. 데이터 처리용도) */
    pTempData.CompleteFG = SelectSingleNodeValue(objNodes, "COMPLETEFG");
    pTempData.IsAllRep = SelectSingleNodeValue(objNodes, "ISALLREP");
    pTempData.StartDateNoTZ = SelectSingleNodeValue(objNodes, "STARTDATE").substring(0, 19);
    pTempData.RepStartDate = SelectSingleNodeValue(objNodes, "REPSTARTDATE");

    if(SelectSingleNodeValue(objNodes, "SCHEDULEFLAG") == "google") {
    	pTempData.scheduleFlag = SelectSingleNodeValue(objNodes, "SCHEDULEFLAG");
    	pTempData.googleId = SelectSingleNodeValue(objNodes, "GOOGLEID");
    }
    
    // 2023-09-06 조소정 - 그룹일정 그룹색상 데이터 추가
    pTempData.GroupColor = SelectSingleNodeValue(objNodes, "GROUPCOLOR");

    return pTempData;
}

function sbFormatTime(h,m){
	var hour;
	var min;
	if (h<10){
		hour = "0" + h ;
	} else {
		hour = h;
	}
	if (m==0){
		min = m+"0";
	} else {
		min = m;
	}
	
	return hour+":"+min;
}

function aheadDataCell(oAppointment, order) {

    var sS = parseInt(oAppointment.StartDate.substring(11, 13), 10)
    var eS = parseInt(oAppointment.StartDate.substring(14, 15), 10)
    var sE = parseInt(oAppointment.EndDate.substring(11, 13), 10)
    var eE = parseInt(oAppointment.EndDate.substring(14, 15), 10)
    var a = 0;
    var objCnt = 0;
    for (var p = 0 ; p < Math.round(oAppointment.timeCount / 2) ; p++) {
        var e = true;
        var s = true;
        if ((a == p - 1 && eE == 0) || (sS == sE && eE >= 3)) {
            e = false
        }   

        if ((sS == sE && eE == 0) || (a == 0 && eS >= 3)) {
            s = false
        }

        if (s) {
            var objElm = document.getElementById("TD_" + oAppointment.trID.substring(0, 10) + "_" + sS + ":0_Value");
            if (objElm) {
                var sTable = document.createElement("TABLE");
                sTable.setAttribute("cellpadding", "0");
                sTable.setAttribute("cellspacing", "0");
                sTable.setAttribute("border", "0");
                sTable.style.position = "relative";
                sTable.setAttribute("id", "t" + oAppointment.ScheduleID + a + order);
                sTable.style.display = "inline-block";
                sTable.style.top = "0";
                var sTr = document.createElement("TR");
                var sTd = document.createElement("TD");
                sTd.setAttribute("id", oAppointment.ScheduleID + a + order);
                sTd.setAttribute("name", oAppointment.ScheduleID);
                
                sTd.style.height = "0px"
                sTd.innerHTML = "<p></p>";
                sTr.appendChild(sTd);
                sTable.appendChild(sTr)
                

                if (a == 0)
                    objCnt = objElm.childNodes.length;

                if (a > 0) {
                    if (objCnt > objElm.childNodes.length) {
                        for (var h = 0; h < objCnt; h++) {
                            var fTable = document.createElement("TABLE");
                            fTable.setAttribute("cellpadding", "0");
                            fTable.setAttribute("cellspacing", "0");
                            fTable.setAttribute("border", "0");
                            fTable.setAttribute("listCnt", "0");
                            fTable.style.display = "inline-block";
                            var fTr = document.createElement("TR");
                            var fTd = document.createElement("TD");
                            fTd.style.height = "0px"
                            fTd.innerHTML = "<p></p>";
                           
                            fTr.appendChild(fTd);
                            fTable.appendChild(fTr)
                            objElm.appendChild(fTable);
                        }
                    }
                }
                if (a == 0)
                    objElm.appendChild(sTable);
                else
                    objElm.innerHTML = sTable.outerHTML + objElm.innerHTML;
            }
            a += 1;
        }

        if (e) {
            var objElm = document.getElementById("TD_" + oAppointment.trID.substring(0, 10) + "_" + sS + ":3_Value");
            if (objElm) {
                var sTable = document.createElement("TABLE");
                sTable.setAttribute("cellpadding", "0");
                sTable.setAttribute("cellspacing", "0");
                sTable.setAttribute("border", "0");
                sTable.style.position = "relative";
                sTable.setAttribute("id", "t" + oAppointment.ScheduleID + a + order);
                sTable.style.display = "inline-block";
                sTable.style.top = "0";
                var sTr = document.createElement("TR");
                var sTd = document.createElement("TD");
                sTd.innerHTML = "<p></p>";
                sTd.setAttribute("id", oAppointment.ScheduleID + a + order);
                sTd.setAttribute("name", oAppointment.ScheduleID);
                
                sTd.style.height = "0px"
                sTr.appendChild(sTd);
                sTable.appendChild(sTr)
                

                if (a == 0)
                    objCnt = objElm.childNodes.length;

                if (a > 0) {
                    if (objCnt > objElm.childNodes.length) {
                        for (var h = 0; h < objCnt; h++) {
                            var fTable = document.createElement("TABLE");
                            fTable.setAttribute("cellpadding", "0");
                            fTable.setAttribute("cellspacing", "0");
                            fTable.setAttribute("border", "0");
                            fTable.setAttribute("listCnt", "0");
                            fTable.style.display = "inline-block";
                            var fTr = document.createElement("TR");
                            var fTd = document.createElement("TD");
                            fTd.style.height = "0px"
                            fTd.innerHTML = "<p></p>";
                            
                            fTr.appendChild(fTd);
                            fTable.appendChild(fTr)
                            objElm.appendChild(fTable);
                        }
                    }
                }
                if (a == 0)
                    objElm.appendChild(sTable);
                else
                    objElm.innerHTML = sTable.outerHTML + objElm.innerHTML;
            }
            a += 1;
        }
        sS += 1;
    }
}


function CalDataWidth(oAppointment, order, tempData) {

    var objCell = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objCell) {
        var sCnt = 0;
        var sC = 0;
        var sCC = 1;

        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("t" + oAppointment.ScheduleID + c + order)
            if (sData) {
                var sItem = sData.parentNode.childNodes;
                for (var f = 0; f < sItem.length; f++) {
                    if (sCnt < GetAttribute(sItem.item(f), "listCnt"))
                        sCnt = GetAttribute(sItem.item(f), "listCnt")

                }
            } else
                break;
        }

        var sData = document.getElementById("t" + oAppointment.ScheduleID + "0" + order)
        if (sData) {
            sData.setAttribute("listCnt", sCnt);
        }


        for (var i = 0; i < objCell.childNodes.length; i++) {
            if (sCC < GetAttribute(objCell.childNodes.item(i), "listCnt"))
                sCC = GetAttribute(objCell.childNodes.item(i), "listCnt")
        }

        for (var i = 0; i < objCell.childNodes.length; i++) {
            objCell.childNodes.item(i).setAttribute("width", (95 / sCC) + "%");
        }


    }
    
    oAppointment = null;
}


function CalDataSize(oAppointment, order, tempData) {

    var objCell = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objCell) {
        var pListCnt = 0;
        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("t" + oAppointment.ScheduleID + c + order)
            if (sData) {
                if (pListCnt < sData.parentNode.childNodes.length)
                    pListCnt = sData.parentNode.childNodes.length;
            } else
                break;
        }

        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("t" + oAppointment.ScheduleID + c + order)
            if (sData) {
                sData.setAttribute("listCnt", pListCnt);
            } else
                break;

        }
    }
    
    oAppointment = null;
}


function CalMonthDataBind(oAppointment) {
	
    var objElm = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objElm) {    	

        var oTr = document.createElement("TR");
        var oTd = document.createElement("TD");
        var oSpan = document.createElement("SPAN");
        
        if (oAppointment.ScheduleType == 3) {
            oTd.className = "company";
            oSpan.className = "company";
			
			var tagConf = personalScheConfigList.find(function(elem) {
				return elem.scheduleType == 3
			});
			
			if (tagConf.tagColor) {
				oSpan.style.backgroundColor = tagConf.tagColor;
				oSpan.style.border = "1px solid " + tagConf.tagColor;
            }
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oTd.className = "individual";
            oSpan.className = "individual";
            
			if (oAppointment.ScheduleType == 1) {
				var tagConf = personalScheConfigList.find(function(elem) {
					return elem.scheduleType == 1
				});
				
				if (tagConf.tagColor) {
					oSpan.style.backgroundColor = tagConf.tagColor;
					oSpan.style.border = "1px solid " + tagConf.tagColor;
				}
			}
        }
        else if (oAppointment.ScheduleType == 6) {
            oTd.className = "individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oTd.className = "Group";
            oSpan.className = "Group";
            // 2023-09-06 조소정 - 일정관리 월보기 시 그룹일정 그룹색상 표출
            if(oAppointment.GroupColor == null || oAppointment.GroupColor == "") {
            	var groupColor = "#e9de13";
            	oSpan.style.backgroundColor = groupColor;
                oSpan.style.border = "1px solid " + groupColor;
            }
            else {
                oSpan.style.backgroundColor = oAppointment.GroupColor;
                oSpan.style.border = "1px solid " + oAppointment.GroupColor;
            }
        }
        else if (oAppointment.ScheduleType == 4) {
            oTd.className = "collaboration";
            oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oTd.className = "executive";
            oSpan.className = "executive";
        } else {
            oTd.className = "department";
            oSpan.className = "department";
			
			if (oAppointment.ScheduleType == 2) {
				var tagConf = personalScheConfigList.find(function(elem) {
					return (elem.scheduleType == 2) && (oAppointment.OwnerID == elem.relatedId)
				});
				
				if (tagConf.tagColor) {
					oSpan.style.backgroundColor = tagConf.tagColor;
					oSpan.style.border = "1px solid " + tagConf.tagColor;
				}
			}
        }
        
        /* 2021-09-07 홍승비 - 일정관리 월보기 시 각 일정제목에 말줄임표 적용 */
        oTd.style.textOverflow = "ellipsis";
        
        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
        		oTd.className = "calendar_data_public_department";
                oSpan.className = "public_department";
                break;
        	}
        }

        oTd.appendChild(oSpan);

        var pTime = "";
        var pSubject;
        var pImg = document.createElement('img');
        
        // 2020-02-24 김정언
        if (oAppointment.DateType == 4) {
        	pImg.src = '/images/ezAttitude/' + oAppointment.ContentPath + '.png';
        	pImg.className = "attiImg";
        	pImg.style["vertical-align"] = "sub";
        	pImg.style["margin-right"] = "3px";
        	oTd.appendChild(pImg);
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay;
            pSubject = oAppointment.Subject + " : " + oAppointment.CreatorName;
        }
        else if (oAppointment.DateType != 2) {
        	pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay;
        	pSubject = oAppointment.dtstartDisplay+ " " + oAppointment.Subject + " " ;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        if (oAppointment.Importance == 1)
        {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oTd.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oTd.appendChild(oSpan);
        }
        oTd.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oTd.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oTd.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oTd.setAttribute("ParentID", oAppointment.ParentID);
        oTd.setAttribute("OwnerID", oAppointment.OwnerID);
        oTd.setAttribute("CreatorID", oAppointment.CreatorID);
        oTd.setAttribute("CreatorName", oAppointment.CreatorName);
        oTd.setAttribute("ContentPath", oAppointment.ContentPath);
        oTd.setAttribute("ModifierID", oAppointment.ModifierID);
        oTd.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oTd.setAttribute("Importance", oAppointment.Importance);
        oTd.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oTd.setAttribute("DateType", oAppointment.DateType);
        oTd.setAttribute("Subject", oAppointment.Subject);
        oTd.setAttribute("StartDate", oAppointment.StartDate);
        oTd.setAttribute("EndDate", oAppointment.EndDate);
        oTd.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oTd.setAttribute("Location", oAppointment.Location);
        oTd.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oTd.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oTd.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oTd.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oTd.setAttribute("dtendHour", oAppointment.dtendHour);
        oTd.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oTd.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oTd.setAttribute("dtendDisplay", oAppointment.dtendDisplay);

        oTd.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oTd.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oTd.setAttribute("command", "open");
        oTd.setAttribute("ptime", pTime);
        
        /* 2021-11-26 홍승비 - 일정완료여부 데이터 추가 */
        oTd.setAttribute("completefg", oAppointment.CompleteFG);
        
        // 2020-02-24 김정언 - 근태 현황일 경우에는 근태 상세보기로 이동 (DateType 4 : 근태 현황)
        if(oAppointment.DateType == 4) {
        	var divID = "\"" + oAppointment.ScheduleID + ":" + oAppointment.ParentID + "\"";
            oTd.setAttribute("onclick", "ReadAttitude(" + divID + ")");
        	oTd.setAttribute("ondblclick", "ReadAttitude(" + divID + ")");
        }
        else {
        	var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
            if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
                if(oAppointment.scheduleFlag == "google") {
                    oTd.setAttribute("isGoogle", "Y");
                    oTd.setAttribute("googleId", oAppointment.googleId);
                        oTd.setAttribute("onclick", "ReadGoogleSchedule(" + divID + ")");
                        oTd.setAttribute("ondblclick", "ReadGoogleSchedule(" + divID + ")");
                } else {
                        oTd.setAttribute("onclick", "ReadSchedule(" + divID + ")");
                        oTd.setAttribute("ondblclick", "ReadSchedule(" + divID + ")");
                }
                if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
                    oTd.onmouseover = function (event) { TooltipMouseOver(this, event); };
                    oTd.setAttribute("onmouseout", "hideTooltip(this)");
                } 
            }
        }
        
        // 일정완료 시 취소선 표출하기 위해 span 추가
        var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);
        
        // 단일. 특정 반복일정, 전체 반복일정에 따라 분기처리
        if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
        	oTextSpan.style.textDecoration = "line-through";
        }
        
        //oTd.innerHTML += pSubject;
        oTextSpan.appendChild(oText);
       	oTd.appendChild(oTextSpan);
        
        oTr.appendChild(oTd);
        objElm.appendChild(oTr);

        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            if(chk_usersearch != "UserSearch") {
                //2018-11-05 김혜정 월보기
                if (oAppointment.scheduleFlag != 'google') {
                    $("#" + "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID).parent("tr").draggable({
                        addClasses: false,
                        containment: $("#dayDiv"),
                        revert: "invalid",
                        helper: function (event) {
                            return $(event.currentTarget).clone().css({
                                width: $(event.currentTarget).width()
                            });
                        },
                        scroll: false
                    });
                }
            }
        }
    }
    objElm = null;
    oAppointment = null;
}


function CalWeekDataBind(oAppointment, order) {
	
    var objDivS = document.getElementById("TD_" + oAppointment.trID + "_Value");
    var objDivE = document.getElementById("TD_" + oAppointment.endDiv + "_Value");
    if (objDivS && objDivE) {
        // 05-02 민지수 ellipsis 적용
        var oDiv = document.createElement("DIV");

        var oTable = document.createElement("TABLE");
        oTable.setAttribute("cellpadding", "0");
        oTable.setAttribute("cellspacing", "0");
        oTable.setAttribute("width", "100%");
        oTable.style.display = "block";
        var oTr = document.createElement("TR");
        oTr.style.display = "block";
        var oTd = document.createElement("TD");
        oTd.style.display = "block";
        oTd.style.height = "21px";
        oTd.style.whiteSpace = "noWrap";
        oTd.style.overflow = "hidden";
        oTd.style.textOverflow = "ellipsis";

        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
            
			var tagConf = personalScheConfigList.find(function(elem) {
				return elem.scheduleType == 3
			});
			
			if (tagConf.tagColor) {
				oSpan.style.backgroundColor = tagConf.tagColor;
				oSpan.style.border = "1px solid " + tagConf.tagColor;
            }
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
            
			if (oAppointment.ScheduleType == 1) {
				var tagConf = personalScheConfigList.find(function(elem) {
					return elem.scheduleType == 1
				});
				
				if (tagConf.tagColor) {
					oSpan.style.backgroundColor = tagConf.tagColor;
					oSpan.style.border = "1px solid " + tagConf.tagColor;
				}
			}
        }
        else if (oAppointment.ScheduleType == 6) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oDiv.className = "calendar_data_Group";
            oSpan.className = "Group";
            // 2023-09-06 조소정 - 일정관리 주보기 시 그룹일정 그룹색상 표출
            if(oAppointment.GroupColor == null || oAppointment.GroupColor == "") {
            	var groupColor = "#e9de13";
            	oSpan.style.backgroundColor = groupColor;
                oSpan.style.border = "1px solid " + groupColor;
            }
            else {
                oSpan.style.backgroundColor = oAppointment.GroupColor;
                oSpan.style.border = "1px solid " + oAppointment.GroupColor;
            }
        }
        else if (oAppointment.ScheduleType == 4) {
        	oDiv.className = "calendar_data_collaboration";
        	oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oDiv.className = "calendar_data_executive";
            oSpan.className = "executive";
        } else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
			
			if (oAppointment.ScheduleType == 2) {
				var tagConf = personalScheConfigList.find(function(elem) {
					return (elem.scheduleType == 2) && (oAppointment.OwnerID == elem.relatedId)
				});
				
				if (tagConf.tagColor) {
					oSpan.style.backgroundColor = tagConf.tagColor;
					oSpan.style.border = "1px solid " + tagConf.tagColor;
				}
			}
        }
        
        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
                oSpan.className = "public_department";
                break;
        	}
        }

        oTd.appendChild(oSpan);

        if (oAppointment.Importance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oTd.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oTd.appendChild(oSpan);
        }

        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay
            pSubject = oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

    	var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);
        
    	if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
    		oTextSpan.style.textDecoration = "line-through";
    	}
    	
        //oTd.innerHTML += pSubject;
    	oTextSpan.appendChild(oText);
    	oTd.appendChild(oTextSpan);
        
        oTr.appendChild(oTd);
        oTable.appendChild(oTr);
        oDiv.appendChild(oTable);
        
        var oText = document.createTextNode(pTime);
        oDiv.appendChild(oText);
        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oDiv.setAttribute("ParentID", oAppointment.ParentID);
        oDiv.setAttribute("OwnerID", oAppointment.OwnerID);
        oDiv.setAttribute("CreatorID", oAppointment.CreatorID);
        oDiv.setAttribute("ModifierID", oAppointment.ModifierID);
        oDiv.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oDiv.setAttribute("Importance", oAppointment.Importance);
        oDiv.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oDiv.setAttribute("DateType", oAppointment.DateType);
        oDiv.setAttribute("Subject", oAppointment.Subject);
        oDiv.setAttribute("StartDate", oAppointment.StartDate);
        oDiv.setAttribute("EndDate", oAppointment.EndDate);
        oDiv.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oDiv.setAttribute("Location", oAppointment.Location);
        oDiv.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oDiv.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oDiv.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.dtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oDiv.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oDiv.setAttribute("dtendDisplay", oAppointment.dtendDisplay);

        oDiv.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oDiv.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        
        oTd.setAttribute("completefg", oAppointment.CompleteFG);
        
        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
            oDiv.setAttribute("onmouseout", "hideTooltip(this)");
            var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
            if(oAppointment.scheduleFlag == "google") {
                oDiv.setAttribute("isGoogle", "Y");
                oDiv.setAttribute("googleId", oAppointment.googleId);
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
            } else {
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            }
        }
        
        if (objDivE) {
            var DivSRect = objDivS.getBoundingClientRect();
            var DivERect = objDivE.getBoundingClientRect();

            var hSize = DivERect.top - DivSRect.top;

            if (hSize < 21)
                hSize = 21

            if (oAppointment.dtendMinute >= 45)
                hSize = hSize + 20;
        }
        else
            var hSize = (21 * oAppointment.timeCount) - oAppointment.timeCount;

        oDiv.style.top = "0";
        oDiv.style.overflow = "hidden";
        oDiv.style.width = "95%"
        oDiv.style.height = hSize - 5 + "px";
        oDiv.style.position = "absolute";
        oDiv.style.zIndex = "1";
        oDiv.style.textOverflow = "ellipsis";
        var sItem = document.getElementById(oAppointment.ScheduleID + "0" + order);
        if (sItem) {
            sItem.appendChild(oDiv);
        }
    }
    objDivS = null;
    objDivE = null;
    oAppointment = null;
}

function CalWeekAllDataBind(oAppointment, order) {

    var objDivS = document.getElementById(oAppointment.trID.substring(0, 10) + "ALL");
    if (objDivS) {

        var oDiv = document.createElement("DIV");
        oDiv.style.whiteSpace = "noWrap";
        oDiv.style.overflow = "hidden";
        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 6) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oDiv.className = "calendar_data_Group";
            oSpan.className = "Group";
        }
        else if (oAppointment.ScheduleType == 4) {
            oDiv.className = "calendar_data_collaboration";
            oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oDiv.className = "calendar_data_executive";
            oSpan.className = "executive";
        } else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
        }
        
        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
                oSpan.className = "public_department";
                break;
        	}
        }

        oDiv.appendChild(oSpan);
        oDiv.style.overflow = "hidden";
        oDiv.style.textOverflow = "ellipsis";
        if (oAppointment.Importance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oDiv.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oDiv.appendChild(oSpan);
        }

        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay
            pSubject = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay + " " + oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);
        
    	if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
    		oTextSpan.style.textDecoration = "line-through";
    	}
        
        //oDiv.innerHTML += pSubject;
    	oTextSpan.appendChild(oText);
    	oDiv.appendChild(oTextSpan);
        
        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oDiv.setAttribute("ParentID", oAppointment.ParentID);
        oDiv.setAttribute("OwnerID", oAppointment.OwnerID);
        oDiv.setAttribute("CreatorID", oAppointment.CreatorID);
        oDiv.setAttribute("ModifierID", oAppointment.ModifierID);
        oDiv.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oDiv.setAttribute("Importance", oAppointment.Importance);
        oDiv.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oDiv.setAttribute("DateType", oAppointment.DateType);
        oDiv.setAttribute("Subject", oAppointment.Subject);
        oDiv.setAttribute("StartDate", oAppointment.StartDate);
        oDiv.setAttribute("EndDate", oAppointment.EndDate);
        oDiv.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oDiv.setAttribute("Location", oAppointment.Location);
        oDiv.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oDiv.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oDiv.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.dtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oDiv.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oDiv.setAttribute("dtendDisplay", oAppointment.dtendDisplay);

        oDiv.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oDiv.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        
        oDiv.setAttribute("completefg", oAppointment.CompleteFG);
        
        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
            oDiv.setAttribute("onmouseout", "hideTooltip(this)");
            
            var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
            
            if(oAppointment.scheduleFlag == "google") {
                oDiv.setAttribute("isGoogle", "Y");
                oDiv.setAttribute("googleId", oAppointment.googleId);
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
            } else {
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            }
        }
        objDivS.appendChild(oDiv);

    }
    objDivS = null;
    oAppointment = null;
}

// 상단표시 (주보기)
function CalWeekTopDataBind(oAppointment, order) {

    var objDivS = document.getElementById(oAppointment.trID.substring(0, 10) + "TOP");
    if (objDivS) {

        var oDiv = document.createElement("DIV");
        oDiv.style.whiteSpace = "noWrap";
        oDiv.style.overflow = "hidden";
        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 6) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oDiv.className = "calendar_data_Group";
            oSpan.className = "Group";
        }
        else if (oAppointment.ScheduleType == 4) {
            oDiv.className = "calendar_data_collaboration";
            oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oDiv.className = "calendar_data_executive";
            oSpan.className = "executive";
        } else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
        }

        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
                oSpan.className = "public_department";
                break;
        	}
        }

        oDiv.appendChild(oSpan);
        oDiv.style.overflow = "hidden";
        oDiv.style.textOverflow = "ellipsis";
        if (oAppointment.Importance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oDiv.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oDiv.appendChild(oSpan);
        }

        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay
            pSubject = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay + " " + oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);

    	if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
    		oTextSpan.style.textDecoration = "line-through";
    	}

        //oDiv.innerHTML += pSubject;
    	oTextSpan.appendChild(oText);
    	oDiv.appendChild(oTextSpan);

        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oDiv.setAttribute("ParentID", oAppointment.ParentID);
        oDiv.setAttribute("OwnerID", oAppointment.OwnerID);
        oDiv.setAttribute("CreatorID", oAppointment.CreatorID);
        oDiv.setAttribute("ModifierID", oAppointment.ModifierID);
        oDiv.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oDiv.setAttribute("Importance", oAppointment.Importance);
        oDiv.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oDiv.setAttribute("DateType", oAppointment.DateType);
        oDiv.setAttribute("Subject", oAppointment.Subject);
        oDiv.setAttribute("StartDate", oAppointment.StartDate);
        oDiv.setAttribute("EndDate", oAppointment.EndDate);
        oDiv.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oDiv.setAttribute("Location", oAppointment.Location);
        oDiv.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oDiv.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oDiv.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.dtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oDiv.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oDiv.setAttribute("dtendDisplay", oAppointment.dtendDisplay);

        oDiv.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oDiv.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);

        oDiv.setAttribute("completefg", oAppointment.CompleteFG);
        
        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
            oDiv.setAttribute("onmouseout", "hideTooltip(this)");
            
            var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
            
            if(oAppointment.scheduleFlag == "google") {
                oDiv.setAttribute("isGoogle", "Y");
                oDiv.setAttribute("googleId", oAppointment.googleId);
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
            } else {
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            }
        }
        objDivS.appendChild(oDiv);

    }
    objDivS = null;
    oAppointment = null;
}


function CalDayDataBind(oAppointment, order) {
    
    var objDivS = document.getElementById("TD_" + oAppointment.trID + "_Value");
    var objDivE = document.getElementById("TD_" + oAppointment.endDiv + "_Value");
    if (objDivS && objDivE) {

        var oDiv = document.createElement("DIV");

        var oTable = document.createElement("TABLE");
        oTable.setAttribute("cellpadding", "0");
        oTable.setAttribute("cellspacing", "0");
        oTable.setAttribute("width", "100%");
        var oTr = document.createElement("TR");
        var oTd = document.createElement("TD");
        oTd.style.height = "21px";
        oTd.style.whiteSpace = "noWrap";
        oTd.style.overflow = "hidden";

        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
			
			var tagConf = personalScheConfigList.find(function(elem) {
				return elem.scheduleType == 3
			});
			
			if (tagConf.tagColor) {
				oSpan.style.backgroundColor = tagConf.tagColor;
				oSpan.style.border = "1px solid " + tagConf.tagColor;
            }
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
            
			if (oAppointment.ScheduleType == 1) {
				var tagConf = personalScheConfigList.find(function(elem) {
					return elem.scheduleType == 1
				});
				
				if (tagConf.tagColor) {
					oSpan.style.backgroundColor = tagConf.tagColor;
					oSpan.style.border = "1px solid " + tagConf.tagColor;
				}
			}
        }
        else if (oAppointment.ScheduleType == 6) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oDiv.className = "calendar_data_Group";
            oSpan.className = "Group";
            // 2023-09-06 조소정 - 일정관리 일보기 시 그룹일정 그룹색상 표출
            if(oAppointment.GroupColor == null || oAppointment.GroupColor == "") {
            	var groupColor = "#e9de13";
            	oSpan.style.backgroundColor = groupColor;
                oSpan.style.border = "1px solid " + groupColor;
            }
            else {
                oSpan.style.backgroundColor = oAppointment.GroupColor;
                oSpan.style.border = "1px solid " + oAppointment.GroupColor;
            }
        }
        else if (oAppointment.ScheduleType == 4) {
            oDiv.className = "calendar_data_collaboration";
            oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oDiv.className = "calendar_data_executive";
            oSpan.className = "executive";
        } else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
			
			if (oAppointment.ScheduleType == 2) {
				var tagConf = personalScheConfigList.find(function(elem) {
					return (elem.scheduleType == 2) && (oAppointment.OwnerID == elem.relatedId)
				});
				
				if (tagConf.tagColor) {
					oSpan.style.backgroundColor = tagConf.tagColor;
					oSpan.style.border = "1px solid " + tagConf.tagColor;
				}
			}
        }
        
        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
                oSpan.className = "public_department";
                break;
        	}
        }

        oTd.appendChild(oSpan);

        if (oAppointment.Importance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oTd.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oTd.appendChild(oSpan);
        }


        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay
            pSubject = oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);
        
        if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
    		oTextSpan.style.textDecoration = "line-through";
    	}
        
        //oTd.innerHTML += pSubject;
        oTextSpan.appendChild(oText);
        oTd.appendChild(oTextSpan);
        
        oTr.appendChild(oTd);
        oTable.appendChild(oTr);

        oDiv.appendChild(oTable);
        var oText = document.createTextNode(pTime);
        oDiv.appendChild(oText);

        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oDiv.setAttribute("ParentID", oAppointment.ParentID);
        oDiv.setAttribute("OwnerID", oAppointment.OwnerID);
        oDiv.setAttribute("CreatorID", oAppointment.CreatorID);
        oDiv.setAttribute("ModifierID", oAppointment.ModifierID);
        oDiv.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oDiv.setAttribute("Importance", oAppointment.Importance);
        oDiv.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oDiv.setAttribute("DateType", oAppointment.DateType);
        oDiv.setAttribute("Subject", oAppointment.Subject);
        oDiv.setAttribute("StartDate", oAppointment.StartDate);
        oDiv.setAttribute("EndDate", oAppointment.EndDate);
        oDiv.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oDiv.setAttribute("Location", oAppointment.Location);
        oDiv.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oDiv.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oDiv.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.dtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oDiv.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oDiv.setAttribute("dtendDisplay", oAppointment.dtendDisplay);

        oDiv.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oDiv.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        
        /* 2021-11-26 홍승비 - 일정완료여부 데이터 추가 */
        oDiv.setAttribute("completefg", oAppointment.CompleteFG)
        
        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
            oDiv.setAttribute("onmouseout", "hideTooltip(this)");
            
            var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
         
            if(oAppointment.scheduleFlag == "google") {
                oDiv.setAttribute("isGoogle", "Y");
                oDiv.setAttribute("googleId", oAppointment.googleId);
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadGoogleSchedule(" + divID + ")");
            } else {
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            }
        }
        
        if (objDivE) {
            var DivSRect = objDivS.getBoundingClientRect();
            var DivERect = objDivE.getBoundingClientRect();

            var hSize = DivERect.top - DivSRect.top;

            if (hSize < 21)
                hSize = 21

            if (oAppointment.dtendMinute >= 45)
                hSize = hSize + 20;
        }
        else
            var hSize = (21 * oAppointment.timeCount) - oAppointment.timeCount;

        oDiv.style.top = "0";
        oDiv.style.overflow = "hidden";
        oDiv.style.width = "95%"
        oDiv.style.height = hSize - 5 + "px";
        oDiv.style.position = "absolute";
        oDiv.style.zIndex = "1";
        var sItem = document.getElementById(oAppointment.ScheduleID + "0" + order);
        if (sItem) {
            sItem.appendChild(oDiv);
        }
    }
    objDivS = null;
    objDivE = null;
    oAppointment = null;
}

function CalDayAllDataBind(oAppointment, order) {
	
    var objDivS = document.getElementById(oAppointment.trID.substring(0, 10) + "ALL");
    if (objDivS) {

        var oDiv = document.createElement("DIV");

        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 6) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oDiv.className = "calendar_data_Group";
            oSpan.className = "Group";
        }
        else if (oAppointment.ScheduleType == 4) {
            oDiv.className = "calendar_data_collaboration";
            oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oDiv.className = "calendar_data_executive";
            oSpan.className = "executive";
        } else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
        }
        
        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
                oSpan.className = "public_department";
                break;
        	}
        }

        oDiv.appendChild(oSpan);

        if (oAppointment.Importance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oDiv.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oDiv.appendChild(oSpan);
        }

        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay
            pSubject = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay + " " + oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);
        
    	if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
    		oTextSpan.style.textDecoration = "line-through";
    	}
    	
        //oDiv.innerHTML += pSubject;
    	oTextSpan.appendChild(oText);
    	oDiv.appendChild(oTextSpan);
       
        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oDiv.setAttribute("ParentID", oAppointment.ParentID);
        oDiv.setAttribute("OwnerID", oAppointment.OwnerID);
        oDiv.setAttribute("CreatorID", oAppointment.CreatorID);
        oDiv.setAttribute("ModifierID", oAppointment.ModifierID);
        oDiv.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oDiv.setAttribute("Importance", oAppointment.Importance);
        oDiv.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oDiv.setAttribute("DateType", oAppointment.DateType);
        oDiv.setAttribute("Subject", oAppointment.Subject);
        oDiv.setAttribute("StartDate", oAppointment.StartDate);
        oDiv.setAttribute("EndDate", oAppointment.EndDate);
        oDiv.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oDiv.setAttribute("Location", oAppointment.Location);
        oDiv.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oDiv.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oDiv.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.dtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oDiv.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oDiv.setAttribute("dtendDisplay", oAppointment.dtendDisplay);

        oDiv.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oDiv.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        
        oDiv.setAttribute("completefg", oAppointment.CompleteFG);
        
        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
            oDiv.setAttribute("onmouseout", "hideTooltip(this)");
            
            var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
            
            if(oAppointment.scheduleFlag == "google") {
                oDiv.setAttribute("isGoogle", "Y");
                oDiv.setAttribute("googleId", oAppointment.googleId);
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            } else {
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            }
        }
        objDivS.appendChild(oDiv);

    }
    objDivS = null;
    oAppointment = null;
}

// 상단표시 (일보기)
function CalDayTopDataBind(oAppointment, order) {

    var objDivS = document.getElementById(oAppointment.trID.substring(0, 10) + "TOP");
    if (objDivS) {

        var oDiv = document.createElement("DIV");

        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5 || oAppointment.ScheduleType == 9) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 6) {
            oDiv.className = "calendar_data_individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oDiv.className = "calendar_data_Group";
            oSpan.className = "Group";
        }
        else if (oAppointment.ScheduleType == 4) {
            oDiv.className = "calendar_data_collaboration";
            oSpan.className = "collaboration";
        } else if (oAppointment.ScheduleType == 10) { // 임원일정
            oDiv.className = "calendar_data_executive";
            oSpan.className = "executive";
        } else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
        }

        for (var i = 0; i < publicIds.length; i++) {
        	if (oAppointment.OwnerID == publicIds[i].id) {
                oSpan.className = "public_department";
                break;
        	}
        }

        oDiv.appendChild(oSpan);

        if (oAppointment.Importance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oDiv.appendChild(oSpan);
        } else if (oAppointment.Importance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oDiv.appendChild(oSpan);
        }

        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay
            pSubject = oAppointment.dtstartDisplay + " - " + oAppointment.dtendDisplay + " " + oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oTextSpan = document.createElement("SPAN");
        var oText = document.createTextNode(pSubject);
        
    	if (oAppointment.CompleteFG == "Y" && ((oAppointment.RepStartDate == oAppointment.StartDateNoTZ && oAppointment.IsAllRep == "N") || (oAppointment.IsAllRep == "Y"))) {
    		oTextSpan.style.textDecoration = "line-through";
    	}
    	
        //oDiv.innerHTML += pSubject;
    	oTextSpan.appendChild(oText);
    	oDiv.appendChild(oTextSpan);
       
        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleID", oAppointment.ScheduleID);
        oDiv.setAttribute("ScheduleChangeKey", oAppointment.ScheduleChangeKey);
        oDiv.setAttribute("ParentID", oAppointment.ParentID);
        oDiv.setAttribute("OwnerID", oAppointment.OwnerID);
        oDiv.setAttribute("CreatorID", oAppointment.CreatorID);
        oDiv.setAttribute("ModifierID", oAppointment.ModifierID);
        oDiv.setAttribute("ScheduleType", oAppointment.ScheduleType);
        oDiv.setAttribute("Importance", oAppointment.Importance);
        oDiv.setAttribute("IsReadOnly", oAppointment.IsReadOnly);
        oDiv.setAttribute("DateType", oAppointment.DateType);
        oDiv.setAttribute("Subject", oAppointment.Subject);
        oDiv.setAttribute("StartDate", oAppointment.StartDate);
        oDiv.setAttribute("EndDate", oAppointment.EndDate);
        oDiv.setAttribute("RepeatCount", oAppointment.RepeatCount);
        oDiv.setAttribute("Location", oAppointment.Location);
        oDiv.setAttribute("dtstartUTC", oAppointment.dtstartUTC);
        oDiv.setAttribute("dtendUTC", oAppointment.dtendUTC);
        oDiv.setAttribute("dtstartHour", oAppointment.dtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.dtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.dtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.dtendMinute);
        oDiv.setAttribute("dtstartDisplay", oAppointment.dtstartDisplay);
        oDiv.setAttribute("dtendDisplay", oAppointment.dtendDisplay);
        oDiv.setAttribute("showtop", oAppointment.showtop);

        oDiv.setAttribute("OrgStartDate", oAppointment.OrgStartDate);
        oDiv.setAttribute("OrgEndDate", oAppointment.OrgEndDate);

        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        
        oDiv.setAttribute("completefg", oAppointment.CompleteFG);
        
        if (window.location.href.indexOf('schedulePrintCalendar') == -1) {
            oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
            oDiv.setAttribute("onmouseout", "hideTooltip(this)");
            
            var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
            
            if(oAppointment.scheduleFlag == "google") {
                oDiv.setAttribute("isGoogle", "Y");
                oDiv.setAttribute("googleId", oAppointment.googleId);
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            } else {
                oDiv.setAttribute("onclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
                oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");
            }
        }
        objDivS.appendChild(oDiv);

    }
    objDivS = null;
    oAppointment = null;
}

function showTooltip(thisID, e, pTime, pSubject, pScheduleType, pScheduleID) {
    tip = (!e.target ? event.srcElement.value : e.target.value)

    var tTip = document.getElementById('tooltip');
    tTip.innerHTML = "";
    var tTable = document.createElement("TABLE");
    var tTr = document.createElement("TR");
    var tTh = document.createElement("TH");
    tTable.className = "calendar_layer";
    tTable.setAttribute("cellpadding", "0");
    tTable.setAttribute("cellspacing", "0");
    tTable.setAttribute("border", "0");
    tTable.setAttribute("width", "100%");
    tTh.setAttribute("scope", "col");
    tTh.innerHTML = pSubject;
    tTr.appendChild(tTh);
    tTable.appendChild(tTr);

    var tTr = document.createElement("TR");
    var tTd = document.createElement("TD");
    tTd.className = "text";

    var sTable = document.createElement("TABLE");
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    sTable.className = "td_list";
    sTable.setAttribute("cellpadding", "0");
    sTable.setAttribute("cellspacing", "0");
    sTable.setAttribute("border", "0");
    sTable.setAttribute("width", "100%");


    var sSpan = document.createElement("SPAN");
    if (pScheduleType == "3") {
        sSpan.className = "company";
        sTd.className = "company";
    }
    else if (pScheduleType == "1" || pScheduleType == "5" || pScheduleType == "9") {
        sSpan.className = "individual";
        sTd.className = "individual";
    }
    else if (pScheduleType == "6") {
        sSpan.className = "individual";
        sTd.className = "individual";
    }
    else if (pScheduleType == "7") {
        sSpan.className = "Group";
        sTd.className = "Group";
    } else if (pScheduleType == "10") { // 임원일정
        sSpan.className = "executive";
        sTd.className = "executive";
    } else {
        sSpan.className = "department";
        sTd.className = "department";
    }
    sTd.appendChild(sSpan);

    if (pScheduleType == 1 || pScheduleType == 5 || pScheduleType == 9)
        sTd.innerHTML += strLang125;
    else if (pScheduleType == 3)
        sTd.innerHTML += strLang127;
    else if (pScheduleType == 6)
        sTd.innerHTML += strLang125;
    else if (pScheduleType == 7)
        sTd.innerHTML += strLang130;
    else
        sTd.innerHTML += strLang126;

    sTr.appendChild(sTd);
    sTable.appendChild(sTr);

    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    var sSpan = document.createElement("SPAN");
    sSpan.className = "width_11";
    sTd.appendChild(sSpan);
    sTd.innerHTML += pTime;
    sTr.appendChild(sTd);
    sTable.appendChild(sTr);
    tTd.appendChild(sTable);
    tTr.appendChild(tTd);
    tTable.appendChild(tTr);

    var tTr = document.createElement("TR");
    var tTd = document.createElement("TD");
    tTd.className = "btn";
    var sUl = document.createElement("UL");
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "ReadSchedule(\"" + thisID + "\");hideTooltip(this);");
    sSpan.innerHTML = strLang119;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "DeleteSchedule();hideTooltip(this);");
    sSpan.innerHTML = strLang118;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "hideTooltip(this);");
    sSpan.innerHTML = strLang120;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    tTd.appendChild(sUl);
    tTr.appendChild(tTd);
    tTable.appendChild(tTr);

    tTip.appendChild(tTable);
    tTip.style.left = getMouseXLocation(e) + 'px';
    tTip.style.top = getMouseYLocation(e) + 'px';
    tTip.style.visibility = 'visible';
}

function hideTooltip(obj) {
    document.getElementById('tooltip').style.visibility = 'hidden';
    obj.style.backgroundColor = "";
}

function getMouseXLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    var tTip = document.getElementById("tooltip");
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (E.pageX > 1000) {
            var locationX = E.pageX + document.documentElement.scrollLeft - tTip.clientWidth;
        } else {
            if (E.pageX > 300) {
                var locationX = E.pageX + document.documentElement.scrollLeft - tTip.clientWidth;
            }
            else
                var locationX = E.pageX + document.documentElement.scrollLeft;
        }
    }
    else {
        if (E.pageX > 1000) {
            var locationX = E.pageX + document.body.scrollLeft - tTip.clientWidth;
        } else {
            if (E.pageX > 300) {
                var locationX = E.pageX + document.body.scrollLeft - tTip.clientWidth;
            }
            else
                var locationX = E.pageX + document.body.scrollLeft;
        }
    }

    return locationX
}

function getMouseYLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    var tTip = document.getElementById("tooltip");
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (E.pageY > 500) {
            var locationY = E.pageY + document.documentElement.scrollTop - tTip.clientHeight;
            locationY -= 12;
        }
        else {
            if (document.documentElement.scrollTop > 0) {
                
                var locationY
                
                if (tTip.clientHeight > E.pageY) {
                    locationY = E.pageY + document.documentElement.scrollTop;
                } else {
                    locationY = E.pageY + document.documentElement.scrollTop - tTip.clientHeight;
                }
            }
            else {
                var locationY = E.pageY + document.documentElement.scrollTop;
            }
            locationY += 12;
        }
    }
    else {
        if (E.pageY > 500) {
            var locationY = E.pageY + document.body.scrollTop - tTip.clientHeight;
            locationY -= 12;
        }
        else {
            if (document.body.scrollTop > 0) {
                var locationY
                
                if (tTip.clientHeight > E.pageY) {
                    locationY = E.pageY + document.body.scrollTop;
                } else {
                    locationY = E.pageY + document.body.scrollTop - tTip.clientHeight;
                }
            }
            else {
                var locationY = E.pageY + document.body.scrollTop;
            }
            locationY += 12;
        }
    }

    return locationY
}

function getPageLeft(el) {
    var left = 0;
    do
        left += el.offsetLeft;
    while ((el = el.offsetParent));
    return left;
}

function getPageTop(el) {
    var top = 0;
    do
        top += el.offsetTop;
    while ((el = el.offsetParent));
    return top;
}


function mfGetUTFIsoDate(iYr, iMon, iDate, iHr, iMin) {
    var oDate = new Date();
    oDate.setFullYear(iYr, iMon, iDate);
    oDate.setHours(iHr, iMin, 0);

    var iYear = oDate.getFullYear();
    var szMonth = oDate.getMonth() + 1; 
    var szDate = oDate.getDate();
    var szHours = oDate.getHours();
    var szMinutes = oDate.getMinutes();

    if (szMonth < 10) {
        szMonth = "0" + szMonth;
    }

    if (szDate < 10) {
        szDate = "0" + szDate;
    }

    if (szHours < 10) {
        szHours = "0" + szHours;
    }

    if (szMinutes < 10) {
        szMinutes = "0" + szMinutes;
    }

    return (String(iYear + "-" + szMonth + "-" + szDate + "T" + szHours + ":" + szMinutes + ":00.000Z"));
}

function leadingZeros(n, digits) {
    var zero = '';
    n = n.toString();

    if (n.length < digits) {
        for (var i = 0; i < digits - n.length; i++)
            zero = '0' + zero;
    }
    return zero + n;
}

function MonthlyViewHeader_onMouseOver(pThis) {
    pThis.style.backgroundColor = "#f1f8ff";
}


function MonthlyViewHeader_onMouseOut(pThis) {
    pThis.style.backgroundColor = "";
}

function Schedule_onMouseClick(event) {

    if (event.style.backgroundColor == "") {
        if (g_szCurrentApptDivID != null && document.getElementById(g_szCurrentApptDivID)) {
            document.getElementById(g_szCurrentApptDivID).style.backgroundColor = "";
        }

        event.style.backgroundColor = "#f1f8ff";

        g_szCurrentApptDivID = GetAttribute(event, "id");
    }
    else {
        if (g_szCurrentApptDivID == GetAttribute(event, "id"))
            return;

        event.style.backgroundColor = "";
    }
}

function TooltipMouseOver(obj, event) {
    SelectSchedule(obj);
    Schedule_onMouseClick(obj);

    var id = GetAttribute(obj, "id");
    var pTime = GetAttribute(obj, "ptime");
    var subject = GetAttribute(obj, "subject");
    var scheduletype = GetAttribute(obj, "scheduletype");
    var scheduleid = GetAttribute(obj, "scheduleid");
    var location = GetAttribute(obj, "Location");

    var sDate = new Date(GetAttribute(obj, "OrgStartDate").split("T")[0]);
    var sDateMD = (sDate.getMonth() + 1) + "." + sDate.getDate();

    var eDate = new Date(GetAttribute(obj, "OrgEndDate").split("T")[0]);
    var eDateMD = (eDate.getMonth() + 1) + "." + eDate.getDate();

    if (GetAttribute(obj, "datetype") != "2") {
        if (sDateMD != eDateMD) {
            pTime = sDateMD + " " + GetAttribute(obj, "dtstartDisplay") + " - " + eDateMD + " " + GetAttribute(obj, "dtendDisplay");
        } else {
            if (pTime == "00:00 - 23:59") {
                pTime = strLang39;
            }
        }
    }

    showTooltip_MouseOver(id, event, pTime, subject, scheduletype, scheduleid, location);
}

function showTooltip_MouseOver(thisID, e, pTime, pSubject, pScheduleType, pScheduleID, pLocation) {
    tip = (!e.target ? event.srcElement.value : e.target.value)

    var tTip = document.getElementById('tooltip');
    tTip.innerHTML = "";
    var tTable = document.createElement("TABLE");
    var tTr = document.createElement("TR");
    var tTh = document.createElement("TH");
    tTable.className = "calendar_layer";
    tTable.setAttribute("cellpadding", "0");
    tTable.setAttribute("cellspacing", "0");
    tTable.setAttribute("border", "0");
    tTable.setAttribute("width", "100%");
    tTable.setAttribute("style", "word-break : break-all");
    tTh.setAttribute("scope", "col");
    tTh.style.background = "#f1f8ff";
    tTh.style.border = "1px solid #d1ddec";
    var oText = document.createTextNode(pSubject);        
    //tTh.innerHTML = pSubject;
    tTh.appendChild(oText);
    tTr.appendChild(tTh);
    tTable.appendChild(tTr);

    var tTr = document.createElement("TR");
    var tTd = document.createElement("TD");
    tTd.className = "text";
    tTd.style.borderTop = "0px";

    var sTable = document.createElement("TABLE");
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    sTable.className = "td_list";
    sTable.setAttribute("cellpadding", "0");
    sTable.setAttribute("cellspacing", "0");
    sTable.setAttribute("border", "0");
    sTable.setAttribute("width", "100%");

    
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    var sSpan = document.createElement("SPAN");
    
    sTd.appendChild(sSpan);
    sTd.innerHTML += "[" + strLang270 + "]<br/>" + pTime;
    sTr.appendChild(sTd);
    sTable.appendChild(sTr);

    
    if (pLocation != "") {
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        var oText2 = document.createTextNode(pLocation); 
        
        sTd.appendChild(sSpan);
        //sTd.innerHTML += "[" + strLang11 + "]<br/>" + pLocation;
        sTd.innerHTML += "[" + strLang11 + "]<br/>";
        sTd.appendChild(oText2);
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
    }
    
    tTd.appendChild(sTable);
    tTr.appendChild(tTd);
    tTable.appendChild(tTr);

    
    tTip.appendChild(tTable);
    tTip.style.left = getMouseXLocation(e) + 'px';
    tTip.style.top = getMouseYLocation(e) + 'px';
    tTip.style.visibility = 'visible';
}
