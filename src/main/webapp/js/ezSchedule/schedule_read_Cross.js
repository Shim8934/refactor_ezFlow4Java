function makeScheduleTimeString(startDate, endDate) {
    var timeString = startDate.substring(0,16) + " ~ " + endDate.substring(0,16);
    return timeString;
}

function makeAllDayScheduleTimeString(startDate, endDate) {
    var timeString;
    if (startDate.substring(0,10) == endDate.substring(0,10)) {
        timeString = startDate.substring(0,10) + " (" + strLang105 + ")";
    } else {
        timeString = startDate.substring(0,10) + " ~ " + endDate.substring(0,10) + " (" + strLang105 + ")";
    }
    return timeString;
}

function makeStringDayofWeekInfo(dayOfWeek) {
    var dayOfWeekString;
    switch (dayOfWeek){
        case "0":
            dayOfWeekString = strLang48;
            break;
        case "1":
            dayOfWeekString = strLang49;
            break;
        case "2":
            dayOfWeekString = strLang50;
            break;
        case "3":
            dayOfWeekString = strLang51;
            break;
        case "4":
            dayOfWeekString = strLang52;
            break;
        case "5":
            dayOfWeekString = strLang53;
            break;
        case "6":
            dayOfWeekString = strLang54;
            break;
    }
    return dayOfWeekString;
}

function makeStringDayofWeekInfo2(dayOfWeek) {
    var dayOfWeekString2;
    switch (dayOfWeek){
        case "0":
            dayOfWeekString2 = strLang60;
            break;
        case "1":
            dayOfWeekString2 = strLang61;
            break;
        case "2":
            dayOfWeekString2 = strLang62;
            break;
        case "3":
            dayOfWeekString2 = strLang63;
            break;
        case "4":
            dayOfWeekString2 = strLang64;
            break;
        case "5":
            dayOfWeekString2 = strLang65;
            break;
        case "6":
            dayOfWeekString2 = strLang66;
            break;
    }
    return dayOfWeekString2;
}

function makeStringWeekNumber(number) {
    var weekNumber;
    switch (number){
        case "1":
            weekNumber = strLang55;
            break;
        case "2":
            weekNumber = strLang56;
            break;
        case "3":
            weekNumber = strLang57;
            break;
        case "4":
            weekNumber = strLang58;
            break;
        case "5":
            weekNumber = strLang59;
            break;
    }
    return weekNumber;
}


function makeRepetitionScheduleString(startDate, endDate, repetitionInfo) {
    var repeatinfo = '';
    var info = repetitionInfo.split("|");
    var repetitionType = info[2];
    
    if (repetitionType) {
        repeatinfo = strLang33;
    }
    
    switch (repetitionType) {
        case "0":
            if (info[3] == '0') {
                repeatinfo += strLang45;
            } else if (info[3] == '1') {
                repeatinfo += strLang34;
            } else {
                repeatinfo += info[3] + strLang81;
            }
            break;
        case "1":
            if(info[3] == '1'){				
                repeatinfo += strLang35 + " ";
                if(info[4]){
                    for (var i = 0; i< info[4].length; i++){
                        var eachDayOfWeek = info[4].substr(i, 1);
                        var dayOfWeekStringInfo = makeStringDayofWeekInfo(eachDayOfWeek);
                        if (i>0) {
                            repeatinfo += strLangGHA1;
                        }
                        repeatinfo += dayOfWeekStringInfo;
                    }
                }
            }else{
                repeatinfo += info[3] + strLang82 + " ";
                if(info[4]){
                    for (var i = 0; i< info[4].length; i++){
                        var eachDayOfWeek = info[4].substr(i, 1);
                        var dayOfWeekStringInfo = makeStringDayofWeekInfo(eachDayOfWeek);
                        if (i>0) {
                            repeatinfo += strLangGHA1;
                        }
                        repeatinfo += dayOfWeekStringInfo;
                    }
                }
            }
            break;
        case "2":
            if(info[3] == '1'){
                if(info[4] == '1') {
                    repeatinfo += strLang36 + " ";
                }
                else {
                    repeatinfo += info[4] + strLang83 + " ";
                }
                repeatinfo += info[5] + strLang80 + " ";
            }else{					
                if(info[4] == '1') {
                    repeatinfo += strLang36 + " ";
                }
                else {
                    repeatinfo += info[4] + strLang83 + " ";
                }
                for (var i = 0; i< info[5].length; i++){
                    var weekNumberInfo = makeStringWeekNumber(info[5]);
                    repeatinfo += weekNumberInfo; 
                }
                repeatinfo += " ";
                for (var i = 0; i < info[6].length; i++) {
                    var idx = info[6].substr(i, 1);
                    var dayOfWeekStringInfo = makeStringDayofWeekInfo2(idx);
                    if (i>0) {
                        repeatinfo += strLangGHA1;
                    }
                    repeatinfo += dayOfWeekStringInfo;
                }
            }
            break;
        case "3":
            if (info[3] == '1'){
                repeatinfo += strLang37 + " ";
                repeatinfo += info[4] + strLang122 + " ";
                repeatinfo += info[5] + strLang80;
            } else {	
                repeatinfo += strLang37 + " ";
                repeatinfo += info[4] + strLang122 + " ";
                for (var i = 0; i< info[5].length; i++){
                    var weekNumberInfo = makeStringWeekNumber(info[5]);
                    repeatinfo += weekNumberInfo;
                }
                repeatinfo += " ";
                for (var i = 0; i < info[6].length; i++) {
                    var idx = info[6].substr(i, 1);
                    var dayOfWeekStringInfo = makeStringDayofWeekInfo2(idx);
                    if (i > 0) {
                        repeatinfo += strLangGHA1;
                    }
                    repeatinfo += dayOfWeekStringInfo;
                }
            }
        break;
    }	

    repeatinfo += " ";
    
    if (info[1] == "1") {					// 하루종일 일정
        repeatinfo += strLang39;
    } else {
        repeatinfo += strLang38 + startDate.substring(11,16) + " ~ " +endDate.substring(11,16);
    }
    
    repeatinfo += " ";
    
    if (info[0] == -1) {
        repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + strLang46;
    } else if (info[0] == 0){
        repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + endDate.substring(0,10);
    } else {
        repeatinfo += " " + strLang79 + " : " + startDate.substring(0,10) + " ~ " + info[0] + strLang47;
    }
    
    return repeatinfo;
}