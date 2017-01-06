var wTable;
var xmlhttp;

var delFlag = false;

function CalViewSource() {
   /* xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "DATA");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATE", sStartDate);
    createNodeAndInsertText(xmlpara, objNode, "ENDDATE", sEndDate);
    createNodeAndInsertText(xmlpara, objNode, "APP", idtype);
    createNodeAndInsertText(xmlpara, objNode, "GROUPID", groupid);
    createNodeAndInsertText(xmlpara, objNode, "IDLIST", (idlist == "") ? idtype : idlist);*/
    	
    $.ajax({
		type : "POST",
		dataType : "text",
		async : (!delFlag ? true : false),
		url : "/ezSchedule/scheduleGetList.do",
		data : {
			STARTDATE : sStartDate,
			ENDDATE : sEndDate,
			APP : idtype,
			GROUPID : groupid,
			IDLIST : (idlist == "") ? idtype : idlist
		},
		success: function(text){
			if (typeCal == 0) {
				getCalMonthViewSource_after(text);
			} else if (typeCal == 1) {
				getCalWeekViewSource_after(text);
			} else if (typeCal == 2) {
				getCalDayViewSource_after(text);
			}
			delFlag = false;
		}
    });    
    
    /*if (!delFlag)
        xmlhttp.open("POST", "/myoffice/ezSchedule/remote/schedule_get_list.aspx", true);
    else
        xmlhttp.open("POST", "/myoffice/ezSchedule/remote/schedule_get_list.aspx", false);

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
    delFlag = false;*/
}

function sDataTemp() {
}

//월보기
var OrgDataSDT;
var OrgDataEDT;
function getCalMonthViewSource_after(text) {
	var tempData = new Array();
	
    try {        
        var listNode = loadXMLString(text);
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
  
            if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
                var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
                var day = 1000 * 60 * 60 * 24;
                betweenDay = parseInt(betweenDay / day, 10);
                
                String tmp = parseInt(DataSDT.getHours(), 10) + (parseInt(UserOffset.split(':')[0]) - 9);
alert(tmp);                
                
                
                for (var j = 0; j <= betweenDay; j++) {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    CalMonthDataBind(tempData[k]);
                    DataSDT.setDate(DataSDT.getDate() + 1);
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
    }
    catch (e) {
        alert("getCalMonthViewSource_after : " + e.description);
    }
}//월보기

//주보기
function getCalWeekViewSource_after(text) {
	var tempData = new Array();
	
    try {
        var listNode = loadXMLString(text);
        var nlength = SelectNodes(listNode, "DATA/ROW").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
            var objNodes = SelectNodes(listNode, "DATA/ROW")[i];
            var _Dtstart = SelectSingleNodeValue(objNodes, "STARTDATE");
            var _Dtend = SelectSingleNodeValue(objNodes, "ENDDATE");
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));
            sStartDate = sStartDate.split("-")[0] + "-" + leadingZeros(sStartDate.split("-")[1], 2) + "-" + leadingZeros(sStartDate.split("-")[2], 2)
            sEndDate = sEndDate.split("-")[0] + "-" + leadingZeros(sEndDate.split("-")[1], 2) + "-" + leadingZeros(sEndDate.split("-")[2], 2)
            OrgDataSDT = new Date(DataSDT);
            OrgDataEDT = new Date(DataEDT);
            
            if (SelectSingleNodeValue(objNodes, "DATETYPE") != "2") {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
                    var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
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
                        DataSDT.setDate(DataSDT.getDate() + 1);
                        k += 1;
                    }
                } else {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    aheadDataCell(tempData[k], k)
                    CalWeekDataBind(tempData[k], k);
                    k += 1;
                }
            }
            else {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
                    var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
                    var day = 1000 * 60 * 60 * 24;
                    betweenDay = parseInt(betweenDay / day, 10);
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
    }
    catch (e) {
        alert("getCalWeekViewSource_after : " + e.description);
    }
}//주보기

//일보기
function getCalDayViewSource_after(text) {
    var tempData = new Array();    

    try {
        var listNode = loadXMLString(text);
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
            
            if (SelectSingleNodeValue(objNodes, "DATETYPE") != "2") {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
                    var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
                    var day = 1000 * 60 * 60 * 24;
                    betweenDay = parseInt(betweenDay / day, 10);
                    
                    for (var j = 0; j <= betweenDay; j++) {
                        var toDay = sDate.getFullYear() + "-" + leadingZeros((sDate.getMonth() + 1), 2) + "-" + leadingZeros(sDate.getDate(), 2);
                        var DataDay = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2);
                        
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

                            k += 1;
                        }
                        DataSDT.setDate(DataSDT.getDate() + 1);
                    }
                } else {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    aheadDataCell(tempData[k], k);
                    CalDayDataBind(tempData[k], k);
                    k += 1;
                }
            }
            else {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
                    var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
                    var day = 1000 * 60 * 60 * 24;
                    betweenDay = parseInt(betweenDay / day, 10);
                } else
                    betweenDay = 0;

                for (var j = 0; j <= betweenDay; j++) {
                    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    CalDayAllDataBind(tempData[k], k);
                    DataSDT.setDate(DataSDT.getDate() + 1);
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
    }
    catch (e) {
        alert("getCalDayViewSource_after : " + e.description);
    }
}//일보기


function tempInsert(objNodes, DataSDT, DataEDT) {
    var startHour = parseInt(DataSDT.getHours(), 10) + (parseInt(UserOffset.split(':')[0]) - 9);
    var endHour = parseInt(DataEDT.getHours(), 10) + (parseInt(UserOffset.split(':')[0]) - 9);
    var startMin = parseInt(DataSDT.getMinutes(), 10) + parseInt(UserOffset.split(':')[1]);
    var endMin = parseInt(DataEDT.getMinutes(), 10) + parseInt(UserOffset.split(':')[1]);

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
    pTempData.ModifierID = SelectSingleNodeValue(objNodes, "MODIFIERID");
    pTempData.ScheduleType = SelectSingleNodeValue(objNodes, "SCHEDULETYPE");
    pTempData.Importance = SelectSingleNodeValue(objNodes, "IMPORTANCE");
    pTempData.IsReadOnly = SelectSingleNodeValue(objNodes, "ISREADONLY");
    pTempData.DateType = SelectSingleNodeValue(objNodes, "DATETYPE");
    pTempData.Subject = SelectSingleNodeValue(objNodes, "TITLE");
    pTempData.StartDate = mfGetUTFIsoDate(DataSDT.getFullYear(), DataSDT.getMonth(), DataSDT.getDate(), DataSDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9), DataSDT.getMinutes());
    pTempData.EndDate = mfGetUTFIsoDate(DataEDT.getFullYear(), DataEDT.getMonth(), DataEDT.getDate(), DataEDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9), DataEDT.getMinutes());
    pTempData.RepeatCount = SelectSingleNodeValue(objNodes, "REPEATCOUNT");
    pTempData.Location = SelectSingleNodeValue(objNodes, "LOCATION"); // 임시 주석
    pTempData.dtstartUTC = mfGetUTFIsoDate(DataSDT.getFullYear(), DataSDT.getMonth(), DataSDT.getDate(), DataSDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9), DataSDT.getMinutes());
    pTempData.dtendUTC = mfGetUTFIsoDate(DataEDT.getFullYear(), DataEDT.getMonth(), DataEDT.getDate(), DataEDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9), DataEDT.getMinutes());
    pTempData.dtstartHour = DataSDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9);
    pTempData.dtstartMinute = DataSDT.getMinutes() + parseInt(UserOffset.split(':')[1]);
    pTempData.dtendHour = DataEDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9);
    pTempData.dtendMinute = DataEDT.getMinutes() + parseInt(UserOffset.split(':')[1]);
    pTempData.dtstartDisplay = mfFormatTime(((OrgDataSDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9)) * 60) + OrgDataSDT.getMinutes());
    pTempData.dtendDisplay = mfFormatTime(((OrgDataEDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9)) * 60) + OrgDataEDT.getMinutes());

    pTempData.OrgStartDate = mfGetUTFIsoDate(OrgDataSDT.getFullYear(), OrgDataSDT.getMonth(), OrgDataSDT.getDate(), OrgDataSDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9), OrgDataSDT.getMinutes());
    pTempData.OrgEndDate = mfGetUTFIsoDate(OrgDataEDT.getFullYear(), OrgDataEDT.getMonth(), OrgDataEDT.getDate(), OrgDataEDT.getHours() + (parseInt(UserOffset.split(':')[0]) - 9), OrgDataEDT.getMinutes());

    pTempData.timeCount = timeCnt;
    pTempData.o_start = DataSDT;
    pTempData.o_end = DataEDT;
    pTempData.endDiv = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2) + "_" + endHour + ":" + endMin.toString().substring(0, 1);

    return pTempData;
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
                //sTd.style.position = "relative";
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
                           // fTd.style.position = "relative";
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
                sTable.setAttribute("id", "T" + oAppointment.ScheduleID + a + order);
                sTable.style.display = "inline-block";
                sTable.style.top = "0";
                var sTr = document.createElement("TR");
                var sTd = document.createElement("TD");
                sTd.innerHTML = "<p></p>";
                sTd.setAttribute("id", oAppointment.ScheduleID + a + order);
                sTd.setAttribute("name", oAppointment.ScheduleID);
                //sTd.style.position = "relative";
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
                            //fTd.style.position = "relative";
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
            var sData = document.getElementById("T" + oAppointment.ScheduleID + c + order)
            if (sData) {
                var sItem = sData.parentNode.childNodes;
                for (var f = 0; f < sItem.length; f++) {
                    if (sCnt < sItem.item(f).getAttribute("listCnt"))
                        sCnt = sItem.item(f).getAttribute("listCnt")

                }
            } else
                break;
        }

        var sData = document.getElementById("T" + oAppointment.ScheduleID + "0" + order)
        if (sData) {
            sData.setAttribute("listCnt", sCnt);
        }


        for (var i = 0; i < objCell.childNodes.length; i++) {
            if (sCC < objCell.childNodes.item(i).getAttribute("listCnt"))
                sCC = objCell.childNodes.item(i).getAttribute("listCnt")
        }

        for (var i = 0; i < objCell.childNodes.length; i++) {
            objCell.childNodes.item(i).setAttribute("width", (95 / sCC) + "%");
        }


    }
    //objCell = null;
    oAppointment = null;
}


function CalDataSize(oAppointment, order, tempData) {

    var objCell = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objCell) {
        var pListCnt = 0;
        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("T" + oAppointment.ScheduleID + c + order)
            if (sData) {
                if (pListCnt < sData.parentNode.childNodes.length)
                    pListCnt = sData.parentNode.childNodes.length;
            } else
                break;
        }

        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("T" + oAppointment.ScheduleID + c + order)
            if (sData) {
                sData.setAttribute("listCnt", pListCnt);
            } else
                break;

        }
    }
    //objCell = null;
    oAppointment = null;
}

//월보기
function CalMonthDataBind(oAppointment) {

    var objElm = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objElm) {

        var oTr = document.createElement("TR");
        var oTd = document.createElement("TD");
        var oSpan = document.createElement("SPAN");
        
        if (oAppointment.ScheduleType == 3) {
            oTd.className = "company";
            oSpan.className = "company";
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5) {
            oTd.className = "individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 6) {
            oTd.className = "individual";
            oSpan.className = "individual";
        }
        else if (oAppointment.ScheduleType == 7) {
            oTd.className = "Group";
            oSpan.className = "Group";
        }
        else {
            oTd.className = "department";
            oSpan.className = "department";
        }

        oTd.appendChild(oSpan);

        var pTime = "";
        var pSubject;

        if (oAppointment.DateType != 2) {
            pTime = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay
            pSubject = oAppointment.Subject + " " + oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay;
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
        //oTd.setAttribute("onclick", "SelectSchedule(this);Schedule_onMouseClick(this);showTooltip(\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\", event,'" + pTime + "', '" + oAppointment.Subject + "', '" + oAppointment.ScheduleType + "', '" + oAppointment.ScheduleID + "');");
        //oTd.setAttribute("onmouseover", "TooltipMouseOver(this)");
        oTd.onmouseover = function (event) { TooltipMouseOver(this, event); };
        oTd.setAttribute("onmouseout", "hideTooltip()");
        var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
        oTd.setAttribute("ondblclick", "ReadSchedule(" + divID + ")");

        var oText = document.createTextNode(pSubject);
        oTd.innerHTML += pSubject;
        //oTd.appendChild(oText);
        oTr.appendChild(oTd);
        objElm.appendChild(oTr);
    }
    objElm = null;
    oAppointment = null;
}//월보기

//주보기
function CalWeekDataBind(oAppointment, order) {

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
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5) {
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
        else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
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
            pTime = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay
            pSubject = oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oText = document.createTextNode(pSubject);
        oTd.innerHTML += pSubject;
        //oTd.appendChild(oText);
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
        //oDiv.setAttribute("onclick", "SelectSchedule(this);Schedule_onMouseClick(this);showTooltip(\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\", event,'" + pTime + "', '" + oAppointment.Subject + "', '" + oAppointment.ScheduleType + "', '" + oAppointment.ScheduleID + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this)");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
        oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");

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
        oDiv.style.height = hSize - 3 + "px";
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
}//주보기

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
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5) {
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
        else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
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
            pTime = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay
            pSubject = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay + " " + oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oText = document.createTextNode(pSubject);
        //oDiv.appendChild(oText);
        oDiv.innerHTML += pSubject;

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
        //oDiv.setAttribute("onclick", "SelectSchedule(this);Schedule_onMouseClick(this);showTooltip(\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\", event,'" + pTime + "', '" + oAppointment.Subject + "', '" + oAppointment.ScheduleType + "', '" + oAppointment.ScheduleID + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this)");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
        oDiv.setAttribute("ondblclick", "ReadSchedule(" + divID + ")");

        objDivS.appendChild(oDiv);

    }
    objDivS = null;
    oAppointment = null;
}//주보기

//일보기
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
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5) {
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
        else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
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
            pTime = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay
            pSubject = oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oText = document.createTextNode(pSubject);
        oTd.innerHTML += pSubject;
        //oTd.appendChild(oText);
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
        //oDiv.setAttribute("onclick", "SelectSchedule(this);Schedule_onMouseClick(this);showTooltip(\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\", event,'" + pTime + "', '" + oAppointment.Subject + "', '" + oAppointment.ScheduleType + "', '" + oAppointment.ScheduleID + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this)");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
        oDiv.setAttribute("ondblclick", "event.cancelBubble=true;ReadSchedule(" + divID + ")");

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
        oDiv.style.height = hSize - 3 + "px";
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
}//일보기

function CalDayAllDataBind(oAppointment, order) {

    var objDivS = document.getElementById(oAppointment.trID.substring(0, 10) + "ALL");
    if (objDivS) {

        var oDiv = document.createElement("DIV");

        var oSpan = document.createElement("SPAN");

        if (oAppointment.ScheduleType == 3) {

            oDiv.className = "calendar_data_company";
            oSpan.className = "company";
        }
        else if (oAppointment.ScheduleType == 1 || oAppointment.ScheduleType == 5) {
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
        else {
            oDiv.className = "calendar_data_department";
            oSpan.className = "department";
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
            pTime = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay
            pSubject = oAppointment.dtstartDisplay + " ~ " + oAppointment.dtendDisplay + " " + oAppointment.Subject;
        }
        else {
            pTime = strLang39;
            pSubject = oAppointment.Subject;
        }

        var oText = document.createTextNode(pSubject);
        //oDiv.appendChild(oText);
        oDiv.innerHTML += pSubject;

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
        //oDiv.setAttribute("onclick", "SelectSchedule(this);Schedule_onMouseClick(this);showTooltip(\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\", event,'" + pTime + "', '" + oAppointment.Subject + "', '" + oAppointment.ScheduleType + "', '" + oAppointment.ScheduleID + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this)");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        var divID = "\"div_" + oAppointment.trID + "_" + oAppointment.ScheduleID + "\"";
        oDiv.setAttribute("ondblclick", "ReadSchedule(" + divID + ")");

        objDivS.appendChild(oDiv);

    }
    objDivS = null;
    oAppointment = null;
}//일보기

//자원 클릭이벤트시 툴팁
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
    else if (pScheduleType == "1" || pScheduleType == "5") {
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
    }
    else {
        sSpan.className = "department";
        sTd.className = "department";
    }
    sTd.appendChild(sSpan);

    if (pScheduleType == 1 || pScheduleType == 5)
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
    sLi.setAttribute("onclick", "ReadSchedule(\"" + thisID + "\");hideTooltip();");
    sSpan.innerHTML = strLang119;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "DeleteSchedule();hideTooltip();");
    sSpan.innerHTML = strLang118;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "hideTooltip();");
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

function hideTooltip() {
    document.getElementById('tooltip').style.visibility = 'hidden';
}//자원 클릭이벤트시 툴팁

function getMouseXLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    var tTip = document.getElementById("tooltip");
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (E.clientX > 1000) {
            var locationX = E.clientX + document.documentElement.scrollLeft - tTip.clientWidth;
        } else {
            if (E.clientX > 300) {
                var locationX = E.clientX + document.documentElement.scrollLeft - tTip.clientWidth;
            }
            else
                var locationX = E.clientX + document.documentElement.scrollLeft;
        }
    }
    else {
        if (E.clientX > 1000) {
            var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
        } else {
            if (E.clientX > 300) {
                var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
            }
            else
                var locationX = E.clientX + document.body.scrollLeft;
        }
    }

    return locationX
}

//function getMouseYLocation(e) {
//    if (e)
//        var E = e;
//    else
//        var E = window.event;

//    var tTip = document.getElementById("tooltip");
//    if (navigator.userAgent.indexOf('Firefox') != -1) {
//        if (E.clientY > 500) {
//            var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
//        }
//        else {
//            if (document.documentElement.scrollTop > 0)
//                var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
//            else
//                var locationY = E.clientY + document.documentElement.scrollTop;
//        }
//    }
//    else {
//        if (E.clientY > 500) {
//            var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
//        }
//        else {
//            if (document.body.scrollTop > 0) {
//                var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
//            }
//            else
//                var locationY = E.clientY + document.body.scrollTop;
//        }
//    }

//    return locationY
//}
function getMouseYLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    var tTip = document.getElementById("tooltip");
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (E.clientY > 500) {
            var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
        }
        else {
            if (document.documentElement.scrollTop > 0) {
                //var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                var locationY
                //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면
                if (tTip.clientHeight > E.clientY) {
                    locationY = E.clientY + document.documentElement.scrollTop;
                } else {
                    locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                }
            }
            else {
                var locationY = E.clientY + document.documentElement.scrollTop;
            }
        }
    }
    else {
        if (E.clientY > 500) {
            var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
        }
        else {
            if (document.body.scrollTop > 0) {
                var locationY
                //이벤트 발생 Y좌표보다 toolTip의 높이가 더 크면
                if (tTip.clientHeight > E.clientY) {
                    locationY = E.clientY + document.body.scrollTop;
                } else {
                    locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
                }
            }
            else {
                var locationY = E.clientY + document.body.scrollTop;
            }
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
    var szMonth = oDate.getMonth() + 1; //0 offset adjustment
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



//날짜에 마우스 오버시
function MonthlyViewHeader_onMouseOver(pThis) {
    pThis.style.backgroundColor = "#c0cae5";
}

//마우스 아웃시
function MonthlyViewHeader_onMouseOut(pThis) {
    pThis.style.backgroundColor = "";
}

//자원데이터에 마우스 클릭시
function Schedule_onMouseClick(event) {

    if (event.style.backgroundColor == "") {
        if (g_szCurrentApptDivID != null && document.getElementById(g_szCurrentApptDivID)) {
            document.getElementById(g_szCurrentApptDivID).style.backgroundColor = "";
        }

        event.style.backgroundColor = "#c0cae3";

        g_szCurrentApptDivID = event.getAttribute("id");
    }
    else {
        if (g_szCurrentApptDivID == event.getAttribute("id"))
            return;

        event.style.backgroundColor = "";
    }
}

//tooltip 마우스오버 이벤트 추가
function TooltipMouseOver(obj, event) {
    SelectSchedule(obj);
    Schedule_onMouseClick(obj);

    var id = obj.getAttribute("id");
    var pTime = obj.getAttribute("ptime");
    var subject = obj.getAttribute("subject");
    var scheduletype = obj.getAttribute("scheduletype");
    var scheduleid = obj.getAttribute("scheduleid");
    var location = obj.getAttribute("Location");

    var sDate = new Date(obj.getAttribute("OrgStartDate").split("T")[0]);
    var sDateMD = (sDate.getMonth() + 1) + "." + sDate.getDate();

    var eDate = new Date(obj.getAttribute("OrgEndDate").split("T")[0]);
    var eDateMD = (eDate.getMonth() + 1) + "." + eDate.getDate();

    if (sDateMD != eDateMD)
        pTime = sDateMD + " " + obj.getAttribute("dtstartDisplay") + " ~ " + eDateMD + " " + obj.getAttribute("dtendDisplay");

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

    //일정 시간
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    var sSpan = document.createElement("SPAN");
    //sSpan.className = "width_11";
    sTd.appendChild(sSpan);
    sTd.innerHTML += "[" + strLang270 + "]<br/>" + pTime;
    sTr.appendChild(sTd);
    sTable.appendChild(sTr);

    //위치
    if (pLocation != "") {
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_11";
        sTd.appendChild(sSpan);
        sTd.innerHTML += "[" + strLang11 + "]<br/>" + pLocation;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
    }

    //테이블 추가
    tTd.appendChild(sTable);
    tTr.appendChild(tTd);
    tTable.appendChild(tTr);

    //toolTip에 추가
    tTip.appendChild(tTable);
    tTip.style.left = getMouseXLocation(e) + 'px';
    tTip.style.top = getMouseYLocation(e) + 'px';
    tTip.style.visibility = 'visible';
}