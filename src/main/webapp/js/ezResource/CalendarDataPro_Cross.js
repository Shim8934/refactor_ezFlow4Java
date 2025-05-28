var wTable;
var xmlhttp;
var delFlag = false;

function CalViewSource() {

    xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();
    var objNode;
    
    sStartDate = sStartDate.split("-")[0] + "-" + leadingZeros(sStartDate.split("-")[1], 2) + "-" + leadingZeros(sStartDate.split("-")[2], 2);
    sEndDate = sEndDate.split("-")[0] + "-" + leadingZeros(sEndDate.split("-")[1], 2) + "-" + leadingZeros(sEndDate.split("-")[2], 2);
    
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", sStartDate);
    createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", sEndDate);
    createNodeAndInsertText(xmlpara, objNode, "APP", "1");

    if (!delFlag) {
    	xmlhttp.open("POST", "/ezResource/scheduleGet.do?cmd=get&resID=" + ResID, true);
    } else {
    	xmlhttp.open("POST", "/ezResource/scheduleGet.do?cmd=get&resID=" + ResID, false);
    }

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

function sDataTemp() {
}

//월보기
function getCalMonthViewSource_after() {

    var tempData = new Array();
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {

        if (xmlhttp.responseText == "") return;

        var listNode = loadXMLString(xmlhttp.responseText);
        var nlength = SelectNodes(listNode, "root/appointment").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
            var objNodes = SelectNodes(listNode, "root/appointment")[i];

            var _Dtstart = SelectSingleNodeValue(objNodes, "dtstart");
            var _Dtend = SelectSingleNodeValue(objNodes, "dtend");
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));

            //if (SelectSingleNodeValue(objNodes, "instancetype") == "1") { // 반복일정

            var betweenDay = new Date(_Dtend.substring(0, 10)) - new Date(_Dtstart.substring(0, 10));
                var day = 1000 * 60 * 60 * 24;
                betweenDay = parseInt(betweenDay / day, 10);
                var _tempData = "";
                for (var j = 0; j <= betweenDay; j++) {
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
                    if (betweenDay > 0 && j == 0)
                        _tempData = tempData[k];
                    CalMonthDataBind(tempData[k], _tempData);
                    DataSDT.setDate(DataSDT.getDate() + 1);
                    k += 1;
                }
            //} else {
            //    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
            //    CalMonthDataBind(tempData[k]);
            //    k += 1;
            //}
            DataSDT = null;
            DataEDT = null;
        }
        xmlhttp = null;
        tempData = null;
    }
    catch (e) {
        alert("getCalMonthViewSource_after : " + e.description);
    }
}//월보기


//주보기
function getCalWeekViewSource_after() {

    var tempData = new Array();
	var tempData2 = new Array();
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {

        if (xmlhttp.responseText == "") return;

        var listNode = loadXMLString(xmlhttp.responseText);
        var nlength = SelectNodes(listNode, "root/appointment").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
            var objNodes = SelectNodes(listNode, "root/appointment")[i];

            var _Dtstart = SelectSingleNodeValue(objNodes, "dtstart");
            var _Dtend = SelectSingleNodeValue(objNodes, "dtend");
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));

            var DataSDT2 = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT2 = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));

            sStartDate = sStartDate.split("-")[0] + "-" + leadingZeros(sStartDate.split("-")[1], 2) + "-" + leadingZeros(sStartDate.split("-")[2], 2)
            sEndDate = sEndDate.split("-")[0] + "-" + leadingZeros(sEndDate.split("-")[1], 2) + "-" + leadingZeros(sEndDate.split("-")[2], 2)

            if (SelectSingleNodeValue(objNodes, "alldayevent") == "0") {
                //if (_Dtstart.substring(0, 10) >= sStartDate && _Dtend.substring(0, 10) <= sEndDate) {
                    //if (SelectSingleNodeValue(objNodes, "instancetype") == "1") { // 반복일정

                var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
                        var day = 1000 * 60 * 60 * 24;
                        betweenDay = parseInt(betweenDay / day, 10);

                        for (var j = 0; j <= betweenDay; j++) {
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
                            tempData2[k] = tempInsert(objNodes, DataSDT2, DataEDT2);
                            aheadDataCell(tempData[k], k)
                            CalWeekDataBind(tempData[k], k, tempData2[k]);
                            DataSDT.setDate(DataSDT.getDate() + 1);
                            k += 1;

                        //}
                    //} else {
                    //    tempData[k] = tempInsert(objNodes, DataSDT, DataEDT);
                    //    aheadDataCell(tempData[k], k)
                    //    CalWeekDataBind(tempData[k], k);
                    //    k += 1;
                    //}
                }
            }
            else {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { 
                    var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
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
            if (tempData[i].oAlldayevent == "0")
                CalDataSize(tempData[i], i, tempData);
        }

        for (var i = 0; i < tempData.length; i++) {
            if (tempData[i].oAlldayevent == "0")
                CalDataWidth(tempData[i], i, tempData);
        }

        xmlhttp = null;
        tempData = null;
    }
    catch (e) {
        alert("getCalWeekViewSource_after : " + e.description);
    }
}//주보기

//일보기
function getCalDayViewSource_after() {
    var tempData = new Array();
    var tempData2 = new Array();
    if (xmlhttp == null || xmlhttp.readyState != 4) return;

    try {

        if (xmlhttp.responseText == "") return;

        var listNode = loadXMLString(xmlhttp.responseText);
        var nlength = SelectNodes(listNode, "root/appointment").length;
        var k = 0;
        for (var i = 0; i < nlength; i++) {
            var objNodes = SelectNodes(listNode, "root/appointment")[i];

            var _Dtstart = SelectSingleNodeValue(objNodes, "dtstart");
            var _Dtend = SelectSingleNodeValue(objNodes, "dtend");
            var DataSDT = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));

            var DataSDT2 = new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10), parseInt(_Dtstart.substring(11, 13), 10), parseInt(_Dtstart.substring(14, 16), 10));
            var DataEDT2 = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10), parseInt(_Dtend.substring(11, 13), 10), parseInt(_Dtend.substring(14, 16), 10));
            
            if (SelectSingleNodeValue(objNodes, "alldayevent") == "0") {
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
                        tempData2[k] = tempInsert(objNodes, DataSDT2, DataEDT2);
                        aheadDataCell(tempData[k], k);
                        CalDayDataBind(tempData[k], k, tempData2[k]);

                        k += 1;
                    }
                    DataSDT.setDate(DataSDT.getDate() + 1);
                }
            } else {
                if (_Dtstart.substring(0, 10) != _Dtend.substring(0, 10)) { // 반복일정
                    var betweenDay = new Date(_Dtend.substring(0, 4), parseInt(_Dtend.substring(5, 7), 10) - 1, parseInt(_Dtend.substring(8, 10), 10)) - new Date(_Dtstart.substring(0, 4), parseInt(_Dtstart.substring(5, 7), 10) - 1, parseInt(_Dtstart.substring(8, 10), 10));
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
            if (tempData[i].oAlldayevent == "0")
                CalDataSize(tempData[i], i, tempData);
        }

        for (var i = 0; i < tempData.length; i++) {
            if (tempData[i].oAlldayevent == "0")
                CalDataWidth(tempData[i], i, tempData);
        }
        xmlhttp = null;
        tempData = null;
    }
    catch (e) {
        alert("getCalDayViewSource_after : " + e.description);
    }
}//일보기


function tempInsert(objNodes, DataSDT, DataEDT) {

    var startHour = parseInt(DataSDT.getHours(), 10);
    var endHour = parseInt(DataEDT.getHours(), 10);
    var startMin = parseInt(DataSDT.getMinutes(), 10);
    var endMin = parseInt(DataEDT.getMinutes(), 10);

    //var nextDayFlag = false;
    //if ((SelectSingleNodeValue(objNodes, "dtstart").substring(0, 10) != SelectSingleNodeValue(objNodes, "dtend").substring(0, 10)) && (SelectSingleNodeValue(objNodes, "instancetype") == "0")) {
    //    endHour = 23;
    //    endMin = 30;
    //    nextDayFlag = true;
    //}

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

    if (oHour == 0 && oMin == 0) {
        oMin = 1;
    }

    var timeCnt = oHour + oMin;

    if (endMin == 30)
        endMin = 3;

    if (typeCal == 0)
        var trID = DataSDT.getFullYear() + "-" + leadingZeros(parseInt(DataSDT.getMonth() + 1, 10), 2) + "-" + leadingZeros(DataSDT.getDate(), 2);
    else
        var trID = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2) + "_" + parseInt(startHour, 10) + ":" + startMin.toString().substring(0, 1);

    pTempData = new sDataTemp();
    pTempData.trID = trID;
    pTempData.oNumber = SelectSingleNodeValue(objNodes, "number");
    pTempData.oPnumber = SelectSingleNodeValue(objNodes, "pnumber");
    pTempData.oOwner_id = SelectSingleNodeValue(objNodes, "owner_id");
    pTempData.oWriter_id = SelectSingleNodeValue(objNodes, "writer_id");
    pTempData.oSubject = ConvertEntityReferenceToChar(SelectSingleNodeValue(objNodes, "subject")); 
    pTempData.oInstancetype = SelectSingleNodeValue(objNodes, "instancetype");
    pTempData.oLocation = SelectSingleNodeValue(objNodes, "location");
    pTempData.oDtstart = mfGetUTFIsoDate(DataSDT.getFullYear(), DataSDT.getMonth(), DataSDT.getDate(), DataSDT.getHours(), DataSDT.getMinutes());
    pTempData.oDtend = mfGetUTFIsoDate(DataEDT.getFullYear(), DataEDT.getMonth(), DataEDT.getDate(), DataEDT.getHours(), DataEDT.getMinutes());
    pTempData.odtstartHour = DataSDT.getHours();
    pTempData.odtstartMinute = DataSDT.getMinutes();
    pTempData.odtendHour = DataEDT.getHours();
    pTempData.odtendMinute = DataEDT.getMinutes();
    pTempData.o_start = DataSDT;
    pTempData.o_end = DataEDT;
//    pTempData.odtstartDisplay = mfFormatTime((DataSDT.getHours() * 60) + DataSDT.getMinutes());
//    pTempData.odtendDisplay = mfFormatTime((DataEDT.getHours() * 60) + DataEDT.getMinutes());
    pTempData.odtstartDisplay = sbFormatTime(DataSDT.getHours() , DataSDT.getMinutes());
    pTempData.odtendDisplay = sbFormatTime(DataEDT.getHours() , DataEDT.getMinutes());
    pTempData.oAlldayevent = SelectSingleNodeValue(objNodes, "alldayevent");
    pTempData.oBusystatus = SelectSingleNodeValue(objNodes, "busystatus");
    pTempData.oGroupflag = SelectSingleNodeValue(objNodes, "groupflag");
    pTempData.oImportance = SelectSingleNodeValue(objNodes, "importance");
    pTempData.oApproveFlag = SelectSingleNodeValue(objNodes, "approveFlag");
    pTempData.oReturnFlag = SelectSingleNodeValue(objNodes, "returnFlag");
    //if (uselang == "1") {
        pTempData.oOwner_nm = SelectSingleNodeValue(objNodes, "owner_nm");
        pTempData.oDept_name = SelectSingleNodeValue(objNodes, "dept_name");
    //}
    /*else {
        pTempData.oOwner_nm = SelectSingleNodeValue(objNodes, "owner_nm2");
        pTempData.oDept_name = SelectSingleNodeValue(objNodes, "dept_name2");
    }*/
    pTempData.timeCount = timeCnt;
    pTempData.endDiv = DataSDT.getFullYear() + "-" + leadingZeros((DataSDT.getMonth() + 1), 2) + "-" + leadingZeros(DataSDT.getDate(), 2) + "_" + parseInt(endHour, 10) + ":" + endMin.toString().substring(0, 1);

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

    var sS = parseInt(oAppointment.oDtstart.substring(11, 13), 10)
    var eS = parseInt(oAppointment.oDtstart.substring(14, 15), 10)
    var sE = parseInt(oAppointment.oDtend.substring(11, 13), 10)
    var eE = parseInt(oAppointment.oDtend.substring(14, 15), 10)

    var nextDayFlag = false;
    if ((oAppointment.oDtstart.substring(0, 10) != oAppointment.oDtend.substring(0, 10)) && (oAppointment.oInstancetype == "0")) {
        sE = 23;
        eE = 3;
        nextDayFlag = true;
    }

    var a = 0;
    var objCnt = 0;
    for (var p = 0 ; p < Math.round(oAppointment.timeCount / 2) ; p++) {
        var e = true;
        var s = true;
        if ((a == p - 1 && eE == 0) || (sS == sE && eE == 3)) {
            e = false
        }

        if ((sS == sE && eE == 0) || (a == 0 && eS == 3)) {
            s = false
        }

        if (nextDayFlag)
            e = true;

        if (s) {
            var objElm = document.getElementById("TD_" + oAppointment.oDtstart.substring(0, 10) + "_" + sS + ":0_Value");
            if (objElm) {
                var sTable = document.createElement("TABLE");
                sTable.setAttribute("cellpadding", "0");
                sTable.setAttribute("cellspacing", "0");
                sTable.setAttribute("border", "0");
                sTable.setAttribute("id", "T" + oAppointment.oNumber + a + order);
                sTable.style.position = "relative";
                sTable.style.display = "inline-block";
                sTable.style.top = "0";
                var sTr = document.createElement("TR");
                var sTd = document.createElement("TD");
                sTd.setAttribute("id", oAppointment.oNumber + a + order);
                sTd.setAttribute("name", oAppointment.oNumber);
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
                            //fTd.style.position = "relative";
                            fTr.appendChild(fTd);
                            fTable.appendChild(fTr)
                            objElm.appendChild(fTable);
                        }
                    }
                }
                objElm.appendChild(sTable);
            }
            a += 1;
        }

        if (e) {
            var objElm = document.getElementById("TD_" + oAppointment.oDtstart.substring(0, 10) + "_" + sS + ":3_Value");
            if (objElm) {
                var sTable = document.createElement("TABLE");
                sTable.setAttribute("cellpadding", "0");
                sTable.setAttribute("cellspacing", "0");
                sTable.setAttribute("border", "0");
                sTable.setAttribute("id", "T" + oAppointment.oNumber + a + order);
                sTable.style.position = "relative";
                sTable.style.display = "inline-block";
                sTable.style.top = "0";
                var sTr = document.createElement("TR");
                var sTd = document.createElement("TD");
                sTd.innerHTML = "<p></p>";
                sTd.setAttribute("id", oAppointment.oNumber + a + order);
                sTd.setAttribute("name", oAppointment.oNumber);
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
                objElm.appendChild(sTable);
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
            var sData = document.getElementById("T" + oAppointment.oNumber + c + order)
            if (sData) {
                var sItem = sData.parentNode.childNodes;
                for (var f = 0; f < sItem.length; f++) {
                    if (sCnt < GetAttribute(sItem.item(f),"listCnt"))
                        sCnt = GetAttribute(sItem.item(f),"listCnt")

                }
            } else
                break;
        }

        var sData = document.getElementById("T" + oAppointment.oNumber + "0" + order)
        if (sData) {
            sData.setAttribute("listCnt", sCnt);
        }


        for (var i = 0; i < objCell.childNodes.length; i++) {
            if (sCC < GetAttribute(objCell.childNodes.item(i),"listCnt"))
                sCC = GetAttribute(objCell.childNodes.item(i),"listCnt")
        }

        for (var i = 0; i < objCell.childNodes.length; i++) {
            objCell.childNodes.item(i).width = (95 / sCC) + "%"
        }


    }
    objCell = null;
    oAppointment = null;
}


function CalDataSize(oAppointment, order, tempData) {

    var objCell = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objCell) {
        var pListCnt = 0;
        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("T" + oAppointment.oNumber + c + order)
            if (sData) {
                if (pListCnt < sData.parentNode.childNodes.length)
                    pListCnt = sData.parentNode.childNodes.length;
            } else
                break;
        }

        for (var c = 0; c < 48; c++) {
            var sData = document.getElementById("T" + oAppointment.oNumber + c + order)
            if (sData) {
                sData.setAttribute("listCnt", pListCnt);
            } else
                break;

        }
    }
    objCell = null;
    oAppointment = null;
}

//월보기
function CalMonthDataBind(oAppointment, oAppointment2) {

    var objElm = document.getElementById("TD_" + oAppointment.trID + "_Value");
    if (objElm) {

        var oTr = document.createElement("TR");
        var oTd = document.createElement("TD");
        var oSpan = document.createElement("SPAN");
        
        var d = new Date();
        
       // 승인자원
       if(oAppointment.oApproveFlag == 1) {
    	   // 대여중
    	   if(oAppointment.o_start <= d && oAppointment.o_end >= d) {
    		   oTd.className = "company";
    		   oSpan.className = "resource_rental";
    	   }
    	   // 대여종료
    	   else if(oAppointment.o_end < d) {		
    		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
    		   if(returnFlag == 0) {
		        	oTd.className = "company";
		            oSpan.className = "resource_return";
	        	}
	        	else {
	        		if(oAppointment.oReturnFlag == 0) {		// 반납 자원
	        			oTd.className = "company";
	        			oSpan.className = "resource_return";
	        		}
	        		else {													// 미반납 자원
	        			oTd.className = "company";
	        			oSpan.className = "resource_noreturn";
	        		}
	        	}
    	   }
    	   else {
    		   if(returnFlag == 1 && oAppointment.oReturnFlag == 0) {	// 이미 반납한 자원
    			   	oTd.className = "company";
       				oSpan.className = "resource_return";
    		   }
    		   else {
	    		   oTd.className = "company";
	    		   oSpan.className = "resource_ok";
    		   }
    	   }
       }
       else if(oAppointment.oApproveFlag == 2) {	// 승인거부
    		   oTd.className = "department";
    		   oSpan.className = "resource_refuse";
       }
       else {
    	   oTd.className = "department";
    	   oSpan.className = "resource_no";
       }
        
        oTd.appendChild(oSpan);

        var pTime = "";
        // 05-02 민지수 ellipsis 적용
        var pSubject = document.createElement("SPAN");
        //pSubject.setAttribute("style","margin:0; padding:0; display:inline-block;");

        if (oAppointment.oAlldayevent != 1) {
            if(oAppointment2 != "")
                pTime = oAppointment2.oDtstart.replace('T', ' ').substring(0, 16) + " - " + oAppointment.oDtend.replace('T', ' ').substring(0, 16);
            else
                pTime = oAppointment.oDtstart.replace('T', ' ').substring(0, 16) + " - " + oAppointment.oDtend.replace('T', ' ').substring(0, 16);
          
            /*2018.02.21 김기하 #11638*/
            //pSubject.innerHTML = oAppointment.odtstartDisplay + " - " + oAppointment.odtendDisplay + "<p style='display:inline-block; width:10px; margin:0; padding:0;'></P>" + oAppointment.oSubject;
            
            var timesSplit = oAppointment.odtstartDisplay.split(":");
            var timeeSplit = oAppointment.odtendDisplay.split(":");
            var timeofStart = timesSplit[0]+ ":" + ((timesSplit[1].length == 1)?("0" + timesSplit[1]):timesSplit[1]); 
            var timeofEnd = timeeSplit[0] + ":" + ((timeeSplit[1].length == 1)?("0" + timeeSplit[1]):timeeSplit[1]); 
            pSubject.innerHTML = timeofStart + " - " + timeofEnd + "  " + ConvertCharToEntityReference(oAppointment.oSubject);		// 2018-07-04 김민성 - 특수문자 태그 적용 안되도록 수정
        }
        else {
            pTime = strLang126;
            pSubject.innerHTML = ConvertCharToEntityReference(oAppointment.oSubject);
        }

        if (oAppointment.oImportance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oTd.appendChild(oSpan);
        } else if (oAppointment.oImportance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oTd.appendChild(oSpan);
        }

        oTd.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.oNumber);
        oTd.setAttribute("dtstart", oAppointment.o_start);
        oTd.setAttribute("dtend", oAppointment.o_end);
        oTd.setAttribute("dtstartHour", oAppointment.odtstartHour);
        oTd.setAttribute("dtstartMinute", oAppointment.odtstartMinute);
        oTd.setAttribute("dtendHour", oAppointment.odtendHour);
        oTd.setAttribute("dtendMinute", oAppointment.odtendMinute);
        oTd.setAttribute("_start", oAppointment.o_start);
        oTd.setAttribute("_end", oAppointment.o_end);
        oTd.setAttribute("dtstartDisplay", oAppointment.o_start);
        oTd.setAttribute("dtendDisplay", oAppointment.o_end);
        oTd.setAttribute("num", oAppointment.oNumber);
        oTd.setAttribute("pnum", oAppointment.oPnumber);
        oTd.setAttribute("owner_id", oAppointment.oOwner_id);
        oTd.setAttribute("writer_id", oAppointment.oWriter_id);
        oTd.setAttribute("groupflag", oAppointment.oGroupflag);
        oTd.setAttribute("instancetype", oAppointment.oInstancetype);
        oTd.setAttribute("approveFlag", oAppointment.oApproveFlag);
        oTd.setAttribute("command", "open");
        oTd.setAttribute("ptime", pTime);
        oTd.setAttribute("subject",  oAppointment.oSubject.split("'").join("&apos;"));
        //이벤트변경 - 마우스오버
        //oTd.setAttribute("onclick", "Schedule_onMouseClick(this);showTooltip(this, event, '" + pTime + "', '" + oAppointment.oSubject.split("'").join("&apos;") + "', '" + oAppointment.oApproveFlag + "');");
        //oTd.setAttribute("onmouseover", "TooltipMouseOver(this, \"M\")");
        oTd.onmouseover = function (event) { TooltipMouseOver(this,"M", event); };
        oTd.setAttribute("onmouseout", "hideTooltip()");
        oTd.setAttribute("onclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oTd.setAttribute("ondblclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");

        oTd.setAttribute("titletext", oAppointment.oOwner_nm + "(" + oAppointment.oDept_name + ")");

        oTd.setAttribute("returnFlag", oAppointment.oReturnFlag);
//        var oText = document.createTextNode(pSubject);
        oTd.appendChild(pSubject);
        oTr.appendChild(oTd);
        objElm.appendChild(oTr);
    }
    objElm = null;
    oAppointment = null;
}//월보기

//주보기
function CalWeekDataBind(oAppointment, order, oAppointment2) {

    var objDivS = document.getElementById("TD_" + oAppointment.trID + "_Value");
    var objDivE = document.getElementById("TD_" + oAppointment.endDiv + "_Value");
    if (objDivS) {

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
        
        var d = new Date();

        // 승인자원
        if(oAppointment.oApproveFlag == 1) {
     	   // 대여중
     	   if(oAppointment.o_start <= d && oAppointment.o_end >= d) {
     		   oDiv.className = "calendar_data_ok";
     		   oSpan.className = "resource_rental";
     	   }
     	   // 대여종료
     	   else if(oAppointment.o_end < d) {		
     		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
     		   if(returnFlag == 0) {
     			    oDiv.className = "calendar_data_ok";
 		            oSpan.className = "resource_return";
 	        	}
 	        	else {
 	        		if(oAppointment.oReturnFlag == 0) {		// 반납 자원
 	        			oDiv.className = "calendar_data_ok";
 	        			oSpan.className = "resource_return";
 	        		}
 	        		else {													// 미반납 자원
 	        			oDiv.className = "calendar_data_ok";
 	        			oSpan.className = "resource_noreturn";
 	        		}
 	        	}
     	   }
     	   else {
     		   if(returnFlag == 1 && oAppointment.oReturnFlag == 0) {	// 이미 반납한 자원
     			    oDiv.className = "calendar_data_ok";
        			oSpan.className = "resource_return";
     		   }
     		   else {
     			   oDiv.className = "calendar_data_ok";
 	    		   oSpan.className = "resource_ok";
     		   }
     	   }
        }
        else if(oAppointment.oApproveFlag == 2) {	// 승인거부
        	   oDiv.className = "calendar_data_no";
     		   oSpan.className = "resource_refuse";
        }
        else {
        	oDiv.className = "calendar_data_no";
     	   oSpan.className = "resource_no";
        }
        
        oTd.appendChild(oSpan);

        var pTime = "";
        var pSubject;
        if (oAppointment.oAlldayevent != 1) {
            //pTime = oAppointment.odtstartDisplay + " - " + oAppointment.odtendDisplay;
            pTime = oAppointment2.oDtstart.replace('T', ' ').substring(0, 16) + " - " + oAppointment2.oDtend.replace('T', ' ').substring(0, 16);
            pSubject = oAppointment.oSubject;
        }
        else {
            pTime = strLang126;
            pSubject = oAppointment.oSubject;
        }

        if (oAppointment.oImportance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oTd.appendChild(oSpan);
        } else if (oAppointment.oImportance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oTd.appendChild(oSpan);
        }

        var oText = document.createTextNode(pSubject);
        oTd.appendChild(oText);
        oTr.appendChild(oTd);
        oTable.appendChild(oTr);
        oDiv.appendChild(oTable);
        var oText = document.createTextNode(oAppointment2.odtstartDisplay + " - " + oAppointment2.odtendDisplay);
        oDiv.appendChild(oText);

        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.oNumber);
        oDiv.setAttribute("dtstart", oAppointment.o_start);
        oDiv.setAttribute("dtend", oAppointment.o_end);
        oDiv.setAttribute("dtstartHour", oAppointment2.odtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment2.odtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment2.odtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment2.odtendMinute);
        oDiv.setAttribute("_start", oAppointment.o_start);
        oDiv.setAttribute("_end", oAppointment.o_end);
        oDiv.setAttribute("dtstartDisplay", oAppointment.o_start);
        oDiv.setAttribute("dtendDisplay", oAppointment.o_end);
        oDiv.setAttribute("num", oAppointment.oNumber);
        oDiv.setAttribute("pnum", oAppointment.oPnumber);
        oDiv.setAttribute("owner_id", oAppointment.oOwner_id);
        oDiv.setAttribute("writer_id", oAppointment.oWriter_id);
        oDiv.setAttribute("groupflag", oAppointment.oGroupflag);
        oDiv.setAttribute("instancetype", oAppointment.oInstancetype);
        oDiv.setAttribute("approveFlag", oAppointment.oApproveFlag);
        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        oDiv.setAttribute("subject", oAppointment.oSubject.split("'").join("&apos;"));
        //oDiv.setAttribute("onclick", "Schedule_onMouseClick(this);showTooltip(this, event, '" + pTime + "', '" + oAppointment.oSubject.split("'").join("&apos;") + "', '" + oAppointment.oApproveFlag + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this, \"W\")");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, "W", event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        oDiv.setAttribute("onclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("ondblclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("titletext", oAppointment.oOwner_nm + "(" + oAppointment.oDept_name + ")");
        oDiv.setAttribute("returnFlag", oAppointment.oReturnFlag);
        
        if (objDivE) {
            var DivSRect = objDivS.getBoundingClientRect();
            var DivERect = objDivE.getBoundingClientRect();

            var hSize = DivERect.top - DivSRect.top;

            if (hSize < 21)
                hSize = 21

            if (oAppointment.odtendMinute >= 45)
                hSize = hSize + 20;
        }
        else
            var hSize = (21 * oAppointment.timeCount) - oAppointment.timeCount;

        oDiv.style.top = "0";
        oDiv.style.overflow = "hidden";
        oDiv.style.width = "100%";
        oDiv.style.height = hSize - 3 + "px";
        oDiv.style.position = "absolute";
        oDiv.style.zIndex = "1";
        oDiv.style.top = "0";

        var sid = document.getElementById(oAppointment.oNumber + "0" + order);
        if (sid) {
            sid.appendChild(oDiv);
        }
    }
    objDivS = null;
    oAppointment = null;
}//주보기

function CalWeekAllDataBind(oAppointment, order) {

    var objElm = document.getElementById(oAppointment.trID.substring(0, 10) + "ALL");
    if (objElm) {

        var oDiv = document.createElement("DIV");
        var oSpan = document.createElement("SPAN");

        var d = new Date();
        
        // 승인자원
        if(oAppointment.oApproveFlag == 1) {
     	   // 대여중
     	   if(oAppointment.o_start <= d && oAppointment.o_end >= d) {
     		   oTd.className = "company";
     		   oSpan.className = "resource_rental";
     	   }
     	   // 대여종료
     	   else if(oAppointment.o_end < d) {		
     		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
     		   if(returnFlag == 0) {
 		        	oTd.className = "company";
 		            oSpan.className = "resource_return";
 	        	}
 	        	else {
 	        		if(oAppointment.oReturnFlag == 0) {		// 반납 자원
 	        			oTd.className = "company";
 	        			oSpan.className = "resource_return";
 	        		}
 	        		else {													// 미반납 자원
 	        			oTd.className = "company";
 	        			oSpan.className = "resource_noreturn";
 	        		}
 	        	}
     	   }
     	   else {
     		   if(returnFlag == 1 && oAppointment.oReturnFlag == 0) {	// 이미 반납한 자원
     			   	oTd.className = "company";
        				oSpan.className = "resource_return";
     		   }
     		   else {
 	    		   oTd.className = "company";
 	    		   oSpan.className = "resource_ok";
     		   }
     	   }
        }
        else if(oAppointment.oApproveFlag == 2) {	// 승인거부
     		   oTd.className = "department";
     		   oSpan.className = "resource_refuse";
        }
        else {
     	   oTd.className = "department";
     	   oSpan.className = "resource_no";
        }
        
        oDiv.appendChild(oSpan);

        var pTime = "";
        var pSubject;
        if (oAppointment.oAlldayevent != 1) {
            //pTime = oAppointment.odtstartDisplay + " - " + oAppointment.odtendDisplay;
            pTime = oAppointment.oDtstart.replace('T', ' ').substring(0, 16) + " - " + oAppointment.oDtend.replace('T', ' ').substring(0, 16);
            pSubject = oAppointment.oSubject;
        }
        else {
            pTime = strLang126;
            pSubject = oAppointment.oSubject;
        }

        if (oAppointment.oImportance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oDiv.appendChild(oSpan);
        } else if (oAppointment.oImportance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oDiv.appendChild(oSpan);
        }

        var oText = document.createTextNode(pSubject);
        oDiv.appendChild(oText);
        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.oNumber);
        oDiv.setAttribute("dtstart", oAppointment.o_start);
        oDiv.setAttribute("dtend", oAppointment.o_end);
        oDiv.setAttribute("dtstartHour", oAppointment.odtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.odtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.odtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.odtendMinute);
        oDiv.setAttribute("_start", oAppointment.o_start);
        oDiv.setAttribute("_end", oAppointment.o_end);
        oDiv.setAttribute("dtstartDisplay", oAppointment.o_start);
        oDiv.setAttribute("dtendDisplay", oAppointment.o_end);
        oDiv.setAttribute("num", oAppointment.oNumber);
        oDiv.setAttribute("pnum", oAppointment.oPnumber);
        oDiv.setAttribute("owner_id", oAppointment.oOwner_id);
        oDiv.setAttribute("writer_id", oAppointment.oWriter_id);
        oDiv.setAttribute("groupflag", oAppointment.oGroupflag);
        oDiv.setAttribute("instancetype", oAppointment.oInstancetype);
        oDiv.setAttribute("approveFlag", oAppointment.oApproveFlag);
        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        oDiv.setAttribute("subject", oAppointment.oSubject.split("'").join("&apos;"));
        //oDiv.setAttribute("onclick", "Schedule_onMouseClick(this);showTooltip(this, event, '" + pTime + "', '" + oAppointment.oSubject.split("'").join("&apos;") + "', '" + oAppointment.oApproveFlag + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this, \"W\")");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, "W", event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        oDiv.setAttribute("onclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("ondblclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("titletext", oAppointment.oOwner_nm + "(" + oAppointment.oDept_name + ")");
        oDiv.setAttribute("returnFlag", oAppointment.oReturnFlag);
        
        objElm.appendChild(oDiv);

    }
    objElm = null;
    oAppointment = null;
}//주보기

//일보기
function CalDayDataBind(oAppointment, order, oAppointment2) {

    var objDivS = document.getElementById("TD_" + oAppointment.trID + "_Value");
    var objDivE = document.getElementById("TD_" + oAppointment.endDiv + "_Value");
    if (objDivS) {

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
        oTd.style.textOverflow = "ellipsis";
        var oSpan = document.createElement("SPAN");
        
        var d = new Date();

        // 승인자원
        if(oAppointment.oApproveFlag == 1) {
     	   // 대여중
     	   if(oAppointment.o_start <= d && oAppointment.o_end >= d) {
     		   oDiv.className = "calendar_data_ok";
     		   oSpan.className = "resource_rental";
     	   }
     	   // 대여종료
     	   else if(oAppointment.o_end < d) {		
     		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
     		   if(returnFlag == 0) {
     			    oDiv.className = "calendar_data_ok";
 		            oSpan.className = "resource_return";
 	        	}
 	        	else {
 	        		if(oAppointment.oReturnFlag == 0) {		// 반납 자원
 	        			oDiv.className = "calendar_data_ok";
 	        			oSpan.className = "resource_return";
 	        		}
 	        		else {													// 미반납 자원
 	        			oDiv.className = "calendar_data_ok";
 	        			oSpan.className = "resource_noreturn";
 	        		}
 	        	}
     	   }
     	   else {
     		   if(returnFlag == 1 && oAppointment.oReturnFlag == 0) {	// 이미 반납한 자원
 			   		oDiv.className = "calendar_data_ok";
    				oSpan.className = "resource_return";
     		   }
     		   else {
     			   oDiv.className = "calendar_data_ok";
 	    		   oSpan.className = "resource_ok";
     		   }
     	   }
        }
        else if(oAppointment.oApproveFlag == 2) {	// 승인거부
        		oDiv.className = "calendar_data_no";
     		   oSpan.className = "resource_refuse";
        }
        else {
        	oDiv.className = "calendar_data_no";
     	   oSpan.className = "resource_no";
        }
        
        oTd.appendChild(oSpan);

        var pTime = "";
        var pSubject;
        if (oAppointment.oAlldayevent != 1) {
            //pTime = oAppointment.odtstartDisplay + " - " + oAppointment.odtendDisplay;
            pTime = oAppointment2.oDtstart.replace('T', ' ').substring(0, 16) + " - " + oAppointment2.oDtend.replace('T', ' ').substring(0, 16);
            pSubject = oAppointment.oSubject;
        }
        else {
            pTime = strLang126;
            pSubject = oAppointment.oSubject;
        }

        if (oAppointment.oImportance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oTd.appendChild(oSpan);
        } else if (oAppointment.oImportance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oTd.appendChild(oSpan);
        }

        var oText = document.createTextNode(pSubject);
        oTd.appendChild(oText);
        oTr.appendChild(oTd);
        oTable.appendChild(oTr);

        oDiv.appendChild(oTable);
        var oText = document.createTextNode(oAppointment2.odtstartDisplay + " - " + oAppointment2.odtendDisplay);
        oDiv.appendChild(oText);

        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.oNumber);
        oDiv.setAttribute("dtstart", oAppointment.o_start);
        oDiv.setAttribute("dtend", oAppointment.o_end);
        oDiv.setAttribute("dtstartHour", oAppointment2.odtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment2.odtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment2.odtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment2.odtendMinute);
        oDiv.setAttribute("_start", oAppointment.o_start);
        oDiv.setAttribute("_end", oAppointment.o_end);
        oDiv.setAttribute("dtstartDisplay", oAppointment.o_start);
        oDiv.setAttribute("dtendDisplay", oAppointment.o_end);
        oDiv.setAttribute("num", oAppointment.oNumber);
        oDiv.setAttribute("pnum", oAppointment.oPnumber);
        oDiv.setAttribute("owner_id", oAppointment.oOwner_id);
        oDiv.setAttribute("writer_id", oAppointment.oWriter_id);
        oDiv.setAttribute("groupflag", oAppointment.oGroupflag);
        oDiv.setAttribute("instancetype", oAppointment.oInstancetype);
        oDiv.setAttribute("approveFlag", oAppointment.oApproveFlag);
        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        oDiv.setAttribute("subject", oAppointment.oSubject.split("'").join("&apos;"));
        //oDiv.setAttribute("onclick", "Schedule_onMouseClick(this);showTooltip(this, event, '" + pTime + "', '" + oAppointment.oSubject.split("'").join("&apos;") + "', '" + oAppointment.oApproveFlag + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this, \"D\")");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, "D", event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        oDiv.setAttribute("onclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("ondblclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("titletext", oAppointment.oOwner_nm + "(" + oAppointment.oDept_name + ")");
        oDiv.setAttribute("returnFlag", oAppointment.oReturnFlag);

        oDiv.style.top = "0";
        oDiv.style.overflow = "hidden";
        oDiv.style.width = "100%";

        if (objDivE) {
            var DivSRect = objDivS.getBoundingClientRect();
            var DivERect = objDivE.getBoundingClientRect();

            var hSize = DivERect.top - DivSRect.top;

            if (hSize < 21)
                hSize = 21

            if (oAppointment.odtendMinute >= 45)
                hSize = hSize + 20;
        }
        else
            var hSize = (21 * oAppointment.timeCount) - oAppointment.timeCount;

        oDiv.style.height = hSize - 3 + "px";
        oDiv.style.position = "absolute";
        oDiv.style.zIndex = "1";
        oDiv.style.top = "0";

        var sid = document.getElementById(oAppointment.oNumber + "0" + order);
        if (sid) {
            sid.appendChild(oDiv);
        }
    }
    objElm = null;
    oAppointment = null;
}//일보기


function CalDayAllDataBind(oAppointment, order) {

    var objElm = document.getElementById(oAppointment.trID.substring(0, 10) + "ALL");
    if (objElm) {

        var oDiv = document.createElement("DIV");
        var oSpan = document.createElement("SPAN");
        
        var d = new Date();

        // 승인자원
        if(oAppointment.oApproveFlag == 1) {
     	   // 대여중
     	   if(oAppointment.o_start <= d && oAppointment.o_end >= d) {
     		   oDiv.className = "calendar_data_ok";
     		   oSpan.className = "resource_rental";
     	   }
     	   // 대여종료
     	   else if(oAppointment.o_end < d) {		
     		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
     		   if(returnFlag == 0) {
     			    oDiv.className = "calendar_data_ok";
 		            oSpan.className = "resource_return";
 	        	}
 	        	else {
 	        		if(oAppointment.oReturnFlag == 0) {		// 반납 자원
 	        			oDiv.className = "calendar_data_ok";
 	        			oSpan.className = "resource_return";
 	        		}
 	        		else {													// 미반납 자원
 	        			oDiv.className = "calendar_data_ok";
 	        			oSpan.className = "resource_noreturn";
 	        		}
 	        	}
     	   }
     	   else {
     		   if(returnFlag == 1 && oAppointment.oReturnFlag == 0) {	// 이미 반납한 자원
     			   		oDiv.className = "calendar_data_ok";
        				oSpan.className = "resource_return";
     		   }
     		   else {
     			   oDiv.className = "calendar_data_ok";
 	    		   oSpan.className = "resource_ok";
     		   }
     	   }
        }
        else if(oAppointment.oApproveFlag == 2) {	// 승인거부
        		oDiv.className = "calendar_data_no";
        		oSpan.className = "resource_refuse";
        }
        else {
        	oDiv.className = "calendar_data_no";
     	   	oSpan.className = "resource_no";
        }
        oDiv.appendChild(oSpan);

        var pTime = "";
        var pSubject;
        if (oAppointment.oAlldayevent != 1) {
            //pTime = oAppointment.odtstartDisplay + " - " + oAppointment.odtendDisplay;
            pTime = oAppointment.oDtstart.replace('T', ' ').substring(0, 16) + " - " + oAppointment.oDtend.replace('T', ' ').substring(0, 16);
            pSubject = oAppointment.oSubject;
        }
        else {
            pTime = strLang126;
            pSubject = oAppointment.oSubject;
        }

        if (oAppointment.oImportance == 1) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_l";
            oDiv.appendChild(oSpan);
        } else if (oAppointment.oImportance == 3) {
            var oSpan = document.createElement("SPAN");
            oSpan.className = "icon_h";
            oDiv.appendChild(oSpan);
        }

        var oText = document.createTextNode(pSubject);
        oDiv.appendChild(oText);
        oDiv.setAttribute("ID", "div_" + oAppointment.trID + "_" + oAppointment.oNumber);
        oDiv.setAttribute("dtstart", oAppointment.o_start);
        oDiv.setAttribute("dtend", oAppointment.o_end);
        oDiv.setAttribute("dtstartHour", oAppointment.odtstartHour);
        oDiv.setAttribute("dtstartMinute", oAppointment.odtstartMinute);
        oDiv.setAttribute("dtendHour", oAppointment.odtendHour);
        oDiv.setAttribute("dtendMinute", oAppointment.odtendMinute);
        oDiv.setAttribute("_start", oAppointment.o_start);
        oDiv.setAttribute("_end", oAppointment.o_end);
        oDiv.setAttribute("dtstartDisplay", oAppointment.o_start);
        oDiv.setAttribute("dtendDisplay", oAppointment.o_end);
        oDiv.setAttribute("num", oAppointment.oNumber);
        oDiv.setAttribute("pnum", oAppointment.oPnumber);
        oDiv.setAttribute("owner_id", oAppointment.oOwner_id);
        oDiv.setAttribute("writer_id", oAppointment.oWriter_id);
        oDiv.setAttribute("groupflag", oAppointment.oGroupflag);
        oDiv.setAttribute("instancetype", oAppointment.oInstancetype);
        oDiv.setAttribute("approveFlag", oAppointment.oApproveFlag);
        oDiv.setAttribute("command", "open");
        oDiv.setAttribute("ptime", pTime);
        oDiv.setAttribute("subject", oAppointment.oSubject.split("'").join("&apos;"));
        //oDiv.setAttribute("onclick", "Schedule_onMouseClick(this);showTooltip(this, event, '" + pTime + "', '" + oAppointment.oSubject.split("'").join("&apos;") + "', '" + oAppointment.oApproveFlag + "');");
        //oDiv.setAttribute("onmouseover", "TooltipMouseOver(this, \"D\")");
        oDiv.onmouseover = function (event) { TooltipMouseOver(this, "D", event); };
        oDiv.setAttribute("onmouseout", "hideTooltip()");
        oDiv.setAttribute("onclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("ondblclick", "event.cancelBubble=true;OnDoubleClickAppointment(this);");
        oDiv.setAttribute("titletext", oAppointment.oOwner_nm + "(" + oAppointment.oDept_name + ")");
        oDiv.setAttribute("returnFlag", oAppointment.oReturnFlag);

        objElm.appendChild(oDiv);

    }
    objElm = null;
    oAppointment = null;
}//주보기

//자원 클릭이벤트시 툴팁
function showTooltip(nextTo, e, pTime, pSubject, pApproveFlag) {
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
    setNodeText(tTh,pSubject.split("&apos;").join("'"));
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
    sTd.className = "individual";
    
    var d = new Date();

    var sSpan = document.createElement("SPAN");
    // 승인자원
    if(oAppointment.oApproveFlag == 1) {
 	   // 대여중
 	   if(oAppointment.o_start <= d && oAppointment.o_end >= d) {
 		   oTd.className = "rent";
 		   oSpan.className = "resource_rental";
 	   }
 	   // 대여종료
 	   else if(oAppointment.o_end < d) {		
 		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
 		   if(returnFlag == 0) {
		        	oTd.className = "rent_end";
		            oSpan.className = "resource_return";
	        	}
	        	else {
	        		if(oAppointment.oReturnFlag == 0) {		// 반납 자원
	        			oTd.className = "return_ok";
	        			oSpan.className = "resource_return";
	        		}
	        		else {													// 미반납 자원
	        			oTd.className = "return_no";
	        			oSpan.className = "resource_noreturn";
	        		}
	        	}
 	   }
 	   else {
 		   if(returnFlag == 1 && oAppointment.oReturnFlag == 0) {	// 이미 반납한 자원
 			   	oTd.className = "return_ok";
    				oSpan.className = "resource_return";
 		   }
 		   else {
	    		   oTd.className = "company";
	    		   oSpan.className = "resource_ok";
 		   }
 	   }
    }
    else if(oAppointment.oApproveFlag == 2) {	// 승인거부
 		   oTd.className = "person";
 		   oSpan.className = "resource_refuse";
    }
    else {
 	   oTd.className = "department";
 	   oSpan.className = "resource_no";
    }

    sTr.appendChild(sTd);
    sTable.appendChild(sTr);

    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    var sSpan = document.createElement("SPAN");
    sSpan.className = "width_16";
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
    sLi.setAttribute("onclick", "OnDoubleClickAppointment(document.getElementById(\"" + GetAttribute(nextTo,"id") + "\"));hideTooltip();");
    sSpan.innerHTML = strLang301;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "btnDel_onclick();hideTooltip();");
    sSpan.innerHTML = strLang300;
    sLi.appendChild(sSpan);
    sUl.appendChild(sLi);
    var sLi = document.createElement("LI");
    var sSpan = document.createElement("SPAN");
    sLi.setAttribute("onclick", "hideTooltip()");
    sSpan.innerHTML = strLang302;
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


//function getMouseXLocation(e) {
//    if (e)
//        var E = e;
//    else
//        var E = window.event;

//    if (E.clientX > 1000) {
//        var tTip = document.getElementById("tooltip");
//        var locationX = E.clientX + document.body.scrollLeft - tTip.clientWidth;
//    } else
//        var locationX = E.clientX + document.body.scrollLeft + 20;

//    return locationX
//}

//function getMouseYLocation(e) {
//    if (e)
//        var E = e;
//    else
//        var E = window.event;

//    if (E.clientY > 500) {
//        var tTip = document.getElementById("tooltip");
//        var locationY = E.clientY - tTip.clientHeight;
//    }
//    else
//        var locationY = E.clientY;

//    return locationY
//}

//2018-08-07 김민성 - 자원관리 tooltip 윈도우 사이즈 별 위치 수정
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

function getMouseYLocation(e) {
    if (e)
        var E = e;
    else
        var E = window.event;

    var tTip = document.getElementById("tooltip");
    if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (E.clientY > 500) {
            var locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
            locationY -= 12;
        }
        else {
            if (document.documentElement.scrollTop > 0) {
                
                var locationY
                
                if (tTip.clientHeight > E.clientY) {
                    locationY = E.clientY + document.documentElement.scrollTop;
                } else {
                    locationY = E.clientY + document.documentElement.scrollTop - tTip.clientHeight;
                }
            }
            else {
                var locationY = E.clientY + document.documentElement.scrollTop;
            }
            locationY += 12;
        }
    }
    else {
        if (E.clientY > 500) {
            var locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
            locationY -= 12;
        }
        else {
            if (document.body.scrollTop > 0) {
                var locationY
                
                if (tTip.clientHeight > E.clientY) {
                    locationY = E.clientY + document.body.scrollTop;
                } else {
                    locationY = E.clientY + document.body.scrollTop - tTip.clientHeight;
                }
            }
            else {
                var locationY = E.clientY + document.body.scrollTop;
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

mfFormatTime.szFormat = (null == this.timeFormat) ? "[tt] [h]:[mm]" : this.timeFormat;
function mfFormatTime(iMin) {
    var iHr = Math.floor(iMin / 60);
    var iMn = iMin % 60;
    var L_AM_Text = strLang238;
    var L_PM_Text = strLang239;
    var szRet = mfFormatTime.szFormat;
    if (-1 < szRet.search(/\[t/g)) {
        szRet = szRet.replace(/\[tt\]/g, (iHr > 11 && iHr < 24) ? L_PM_Text : L_AM_Text);
        szRet = szRet.replace(/\[t\]/g, (iHr > 11 && iHr < 24) ? L_PM_Text : L_AM_Text);
    }
    if (-1 < szRet.search(/\[h/g)) //12 hour format
    {
        if (iHr > 12) iHr -= 12;
        if (iHr == 0) iHr = 12;
        szRet = szRet.replace(/\[hh\]/g, iHr > 9 ? iHr : "0" + iHr);
        szRet = szRet.replace(/\[h\]/g, iHr);
    }
    if (-1 < szRet.search(/\[H/g)) //24 hour	format
    {
        szRet = szRet.replace(/\[HH\]/g, iHr > 9 ? iHr : "0" + iHr);
        szRet = szRet.replace(/\[H\]/g, iHr);
    }
    if (-1 < szRet.search(/\[m/g)) {
        szRet = szRet.replace(/\[mm\]/g, iMn > 9 ? iMn : "0" + iMn);
        szRet = szRet.replace(/\[m\]/g, iMn);
    }
    return (szRet);
}




//날짜에 마우스 오버시
function MonthlyViewHeader_onMouseOver(pThis) {
    pThis.style.backgroundColor = "#f1f8ff";
}

//마우스 아웃시
function MonthlyViewHeader_onMouseOut(pThis) {
    pThis.style.backgroundColor = "";
}

//자원데이터에 마우스 클릭시
// 보기형태 파라미터 주가
// 승인된 자원이면 모두 같은 예약현황을 표시하도록 추가
var calendarOk = document.getElementsByClassName("calendar_data_ok");
var calendarNo = document.getElementsByClassName("calendar_data_no");
function Schedule_onMouseClick(event, type) {

    if (event.style.backgroundColor == "") {
        if (g_szCurrentApptDivID != null && document.getElementById(g_szCurrentApptDivID))
            document.getElementById(g_szCurrentApptDivID).style.backgroundColor = "";

        event.style.backgroundColor = "#f1f8ff";

        //M:월, W:주, D:일
        if (type == "M") {
            //월보기 시 - 같은 num면 배경색을 보두 바꾼다. 
            var resDate = (document.getElementsByClassName) ? document.getElementsByClassName("resource_ok") : document.querySelectorAll('.resource_ok'); //월에 표시된 승인된 자원들
            var eventOwnerID = GetAttribute(event,"num");
            for (var i = 0; i < resDate.length; i++) {
                var bgColor = "rgb(250, 255, 243)";
                var checkOwnerID = GetAttribute(resDate[i].parentNode,"num");
                if (eventOwnerID == checkOwnerID) {
                    //resDate[i].parentNode.style.backgroundColor = bgColor;
                } else {
                    resDate[i].parentNode.style.backgroundColor = "";
                }
            }
        } else if (type == "W") {
            //주보기 시 - 같은 num면 배경색을 보두 바꾼다. 
            var resDate = (document.getElementsByClassName) ? document.getElementsByClassName("calendar_data_ok") : document.querySelectorAll('.calendar_data_ok'); //주에 표시된 승인된 자원들
            var eventOwnerID = GetAttribute(event,"num");
            for (var i = 0; i < resDate.length; i++) {
                var bgColor = "rgb(250, 255, 243)";

                //시간영역
                var checkOwnerID = GetAttribute(resDate[i],"num");
                if (eventOwnerID == checkOwnerID) {
                    //resDate[i].style.backgroundColor = bgColor;
                } else {
                    resDate[i].style.backgroundColor = "";
                }
            }
        } else {
            //일보기 시 - 같은 num면 배경색을 보두 바꾼다. 
            //일보기 시 하루종일 일정은 D로 생성함.
            var resDate = (document.getElementsByClassName) ? document.getElementsByClassName("calendar_data_ok") : document.querySelectorAll('.calendar_data_ok'); //일에 표시된 승인된 자원들
            var eventOwnerID = GetAttribute(event,"num");

            for (var i = 0; i < resDate.length; i++) {
                var bgColor = "rgb(250, 255, 243)";
                
                if (calendarOk != null){//일보기 일정에 마우스오버 시 색변경 수정
                	calendarOk[i].style.backgroundColor = "rgb(250, 255, 243)";
                }else if (calendarNo != null){
                	calendarNo[i].style.backgroundColor = "rgba(255, 250, 250, 1)";
                }

                //시간영역
                var checkOwnerID = GetAttribute(resDate[i],"num");
                if (eventOwnerID == checkOwnerID) {
                    //헤더영역 - 하루종일 일때는 하위태그가 SPAN으로 되어있음 
                    if (resDate[i].childNodes[0].tagName == "SPAN") {
                        //resDate[i].style.backgroundColor = bgColor;
                    }
                } else {
                    resDate[i].style.backgroundColor = "";
                    //헤더영역 - 하루종일 일때는 하위태그가 SPAN으로 되어있음
                    if (resDate[i].childNodes[0].tagName == "SPAN") {
                        resDate[i].style.backgroundColor = "";
                    }
                }
            }
        }

        g_szCurrentApptDivID = GetAttribute(event,"id");
        g_szCurrentApptNum = GetAttribute(event,"num");
        g_szCurrentApptPNum = GetAttribute(event,"pnum");
        g_szCurrentApptOwnerID = GetAttribute(event,"owner_id");
        g_szCurrentApptWriterID = GetAttribute(event,"writer_id");
        g_szCurrentApptInsType = GetAttribute(event,"instancetype");
        g_szCurrentApptGFlag = GetAttribute(event,"groupflag");
        g_szCurrentApptSDate = GetAttribute(event,"dtend");
        g_szCurrentApptEDate = GetAttribute(event,"dtend");
    }
    else {
        if (g_szCurrentApptDivID == GetAttribute(event,"id"))
            return;

        event.style.backgroundColor = "";

        //M:월, W:주, D:일
        if (type == "M") {
            //월보기 시 - 같은 num면 배경색을 보두 바꾼다. 
            var resDate = (document.getElementsByClassName) ? document.getElementsByClassName("resource_ok") : document.querySelectorAll('.resource_ok'); //월에 표시된 모든 자원들
            var eventOwnerID = GetAttribute(event,"num");
            for (var i = 0; i < resDate.length; i++) {
                var bgColor = "rgb(250, 255, 243)";
                var checkOwnerID = GetAttribute(resDate[i].parentNode,"num");
                if (eventOwnerID == checkOwnerID) {
                    //resDate[i].parentNode.style.backgroundColor = bgColor;
                } else {
                    resDate[i].parentNode.style.backgroundColor = "";
                }
            }
        } else if (type == "W") {
            //주보기 시 - 같은 num면 배경색을 보두 바꾼다. 
            var resDate = (document.getElementsByClassName) ? document.getElementsByClassName("calendar_data_ok") : document.querySelectorAll('.calendar_data_ok'); //주에 표시된 모든 자원들
            var eventOwnerID = GetAttribute(event,"num");
            for (var i = 0; i < resDate.length; i++) {
                var bgColor = "rgb(250, 255, 243)";

                //시간영역
                var checkOwnerID = GetAttribute(resDate[i],"num");
                if (eventOwnerID == checkOwnerID) {
                    //resDate[i].style.backgroundColor = bgColor;
                } else {
                    resDate[i].style.backgroundColor = "";
                }
            }
        } else {
            //일보기 시 - 같은 num면 배경색을 보두 바꾼다. 
            //일보기 시 하루종일 일정은 D로 생성함.
            var resDate = (document.getElementsByClassName) ? document.getElementsByClassName("calendar_data_ok") : document.querySelectorAll('.calendar_data_ok'); //일에 표시된 모든 자원들
            var eventOwnerID = GetAttribute(event,"num");

            for (var i = 0; i < resDate.length; i++) {
                var bgColor = "rgb(250, 255, 243)";
                
                if (calendarOk != null){//일보기 일정에 마우스오버 시 색변경 수정
                	calendarOk[i].style.backgroundColor = "rgb(250, 255, 243)";
                }else if (calendarNo != null){
                	calendarNo[i].style.backgroundColor = "rgba(255, 250, 250, 1)";
                }
                //시간영역
                var checkOwnerID = GetAttribute(resDate[i],"num");
                if (eventOwnerID == checkOwnerID) {
                    //헤더영역 - 하루종일 일때는 하위태그가 SPAN으로 되어있음 
                    if (resDate[i].childNodes[0].tagName == "SPAN") {
                        //resDate[i].style.backgroundColor = bgColor;
                    }
                } else {
                    resDate[i].style.backgroundColor = "";
                    //헤더영역 - 하루종일 일때는 하위태그가 SPAN으로 되어있음
                    if (resDate[i].childNodes[0].tagName == "SPAN") {
                        resDate[i].style.backgroundColor = "";
                    }
                }
            }
        }

        g_szCurrentApptNum = null;
        g_szCurrentApptPNum = null;
        g_szCurrentApptOwnerID = null;
        g_szCurrentApptWriterID = null;
        g_szCurrentApptInsType = null;
        g_szCurrentApptGFlag = null;
        g_szCurrentApptSDate = null;
        g_szCurrentApptEDate = null;
    }
}

//tooltip 마우스오버
function TooltipMouseOver(obj, type, event) {
    Schedule_onMouseClick(obj, type);
    var pTime = GetAttribute(obj,"ptime");
    var subject = GetAttribute(obj,"subject");
    var approveFlag = GetAttribute(obj,"approveFlag");
    showTooltip_MouseOver(obj, event, pTime, subject, approveFlag);
}

function showTooltip_MouseOver(nextTo, e, pTime, pSubject, pApproveFlag) {
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
    setNodeText(tTh,pSubject.split("&apos;").join("'"));
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
    sTd.className = "individual";
    
    var sTime;
    var eTime;
    
    if (pTime == strLang126) {
    	sTime = new Date(GetAttribute(nextTo, "_start"));
        eTime = new Date(GetAttribute(nextTo, "_end"));
    }
    else {
	    sTime = new Date(pTime.split(" - ")[0].replace(" ", "T"));
	    eTime = new Date(pTime.split(" - ")[1].replace(" ", "T"));
    }
    var nTime = new Date();
    
    var sSpan = document.createElement("SPAN");
    //var _img = document.createElement("IMG");
    /* if (pApproveFlag == "1") {
        //_img.src = "/images/calendar/icon_resource_ok.png"
        //_img.style.verticalAlign = "bottom";
        //sSpan.appendChild(_img);
    	sSpan.className = "sub_iconLNB tree_resource_ok";
    	sSpan.style.marginTop = "0px";
    	sSpan.style.marginRight = "3px";
        sTd.appendChild(sSpan);
        sTd.innerHTML += strLang307;
    }
    else {
        //_img.src = "/images/calendar/icon_resource_no.png"
        //_img.style.verticalAlign = "middle";
        //sSpan.appendChild(_img);
    	sSpan.className = "sub_iconLNB tree_resource_no";
    	sSpan.style.marginTop = "0px";
    	sSpan.style.marginRight = "3px";
        sTd.appendChild(sSpan);
        sTd.innerHTML += strLang308;
    } */
    
    // 승인자원
    if(pApproveFlag == "1") {
 	   // 대여중
 	   if(sTime <= nTime && eTime >= nTime) {
		  sSpan.className = "resource_rental";
		  sSpan.style.marginTop = "0px";
		  sSpan.style.marginRight = "3px";
		  sTd.appendChild(sSpan);
		  sTd.innerHTML += strLang324;
 	   }
 	   // 대여종료
 	   else if(eTime < nTime) {		
 		// 자원 반납 상태(0 : 자동반납 1 : 담당확인)
 		   if(returnFlag == 0) {
 			    sSpan.className = "resource_return";
		    	sSpan.style.marginTop = "0px";
		    	sSpan.style.marginRight = "3px";
		        sTd.appendChild(sSpan);
		        sTd.innerHTML += strLang327;
        	}
        	else {
        		if(GetAttribute(nextTo,"returnFlag") == "0") {		// 반납 자원
        			sSpan.className = "resource_return";
	    	    	sSpan.style.marginTop = "0px";
	    	    	sSpan.style.marginRight = "3px";
	    	        sTd.appendChild(sSpan);
	    	        sTd.innerHTML += strLang325;
        		}
        		else {													// 미반납 자원
        			sSpan.className = "resource_noreturn";
	    	    	sSpan.style.marginTop = "0px";
	    	    	sSpan.style.marginRight = "3px";
	    	        sTd.appendChild(sSpan);
	    	        sTd.innerHTML += strLang326;
        		}
        	}
 	   }
 	   else {
 		   if(returnFlag == 1 && GetAttribute(nextTo,"returnFlag") == "0") {	// 이미 반납한 자원
 			    sSpan.className = "resource_return";
 		    	sSpan.style.marginTop = "0px";
 		    	sSpan.style.marginRight = "3px";
 		        sTd.appendChild(sSpan);
 		        sTd.innerHTML += strLang325;
 		   }
 		   else {
 			    sSpan.className = "resource_ok";
	        	sSpan.style.marginTop = "0px";
	        	sSpan.style.marginRight = "3px";
	            sTd.appendChild(sSpan);
	            sTd.innerHTML += strLang323;
 		   }
 	   }
    }
    else if(pApproveFlag == "2") {	// 승인거부
    	sSpan.className = "resource_refuse";
    	sSpan.style.marginTop = "0px";
    	sSpan.style.marginRight = "3px";
        sTd.appendChild(sSpan);
        sTd.innerHTML += strLang322;
    }
    else {
    	sSpan.className = "resource_no";
    	sSpan.style.marginTop = "0px";
    	sSpan.style.marginRight = "3px";
        sTd.appendChild(sSpan);
        sTd.innerHTML += strLang321;
    }

    sTr.appendChild(sTd);
    sTable.appendChild(sTr);

    //자원시간
    //반복이면 반복이라고 표현한다.
    var reFlag = "";
    if (GetAttribute(nextTo,"instancetype") == "1") {
        reFlag = " (" + strLang572 + ")";
    }
    //하루종일이면
    if (pTime == strLang126) {
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_16";
        sTd.appendChild(sSpan);
        sTd.innerHTML += "[" + strLang573 + "]<br />" + pTime + reFlag;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);
    } else {
        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_16";
        sTd.appendChild(sSpan);

        var cTime1 = "";
        cTime1 = pTime.split(" - ")[0];			// 2019-01-15 김민성 - 자원관리 예약 시간 조회 12시간->24시간제로 변경
        /*try {
            if (pTime.split(" - ")[0].split(" ").length > 1) {
                cTime1 = ChangeTime(pTime.split(" - ")[0].split(" ")[1].split(":")[0], pTime.split(" - ")[0].split(" ")[1].split(":")[1]);
                cTime1 = pTime.split(" - ")[0].split(" ")[0] + " " + cTime1;
            }
        } catch (e) {
            cTime1 = pTime.split(" - ")[0];
        }*/

        sTd.innerHTML += "[" + strLang569 + "]<br />" + cTime1 + reFlag;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);

        var sTr = document.createElement("TR");
        var sTd = document.createElement("TD");
        var sSpan = document.createElement("SPAN");
        //sSpan.className = "width_16";
        sTd.appendChild(sSpan);

        var cTime2 = "";
        cTime2 = pTime.split(" - ")[1];			// 2019-01-15 김민성 - 자원관리 예약 시간 조회 12시간->24시간제로 변경
        /*try {
            if (pTime.split(" - ")[1].split(" ").length > 1) {
                cTime2 = ChangeTime(pTime.split(" - ")[1].split(" ")[1].split(":")[0], pTime.split(" - ")[1].split(" ")[1].split(":")[1]);
                cTime2 = pTime.split(" - ")[1].split(" ")[0] + " " + cTime2;
            }
        } catch (e) {
            cTime2 = pTime.split(" - ")[1];
        }*/

        sTd.innerHTML += "[" + strLang570 + "]<br />" + cTime2 + reFlag;
        sTr.appendChild(sTd);
        sTable.appendChild(sTr);
        tTd.appendChild(sTable);
        tTr.appendChild(tTd);
        tTable.appendChild(tTr);
    }

    //예약자
    var sTr = document.createElement("TR");
    var sTd = document.createElement("TD");
    sTd.style.height = '16px';
    var sSpan = document.createElement("SPAN");
    //sSpan.className = "width_16";
    sTd.appendChild(sSpan);
    sTd.innerHTML += "<span>[" + strLang571 + "]</span><br /><span style='margin-top:2px;display:block;'>" + GetAttribute(nextTo,"titletext") + "</span>";
    sTr.appendChild(sTd);
    sTable.appendChild(sTr);
    tTd.appendChild(sTable);
    tTr.appendChild(tTd);
    tTable.appendChild(tTr);

    tTip.appendChild(tTable);
    tTip.style.left = getMouseXLocation(e) + 'px';
    tTip.style.top = getMouseYLocation(e) + 'px';
    tTip.style.visibility = 'visible';
}

function ChangeTime(h, n) {
    var reVal = "";

    h = parseInt(h);

    if (h == 0) {
        reVal = strLang15+ " " + "12:" + n;
    }
    else if (h == 12) {
        reVal = strLang116 + " " + String(h) + ":" + n;
    }
    else if (h < 12) {
        reVal = strLang15 + " " + String(h) + ":" + n;
    }
    else if (h > 12) {
        h -= 12;
        reVal = strLang116 + " " + String(h) + ":" + n;
    }

    return reVal;
}