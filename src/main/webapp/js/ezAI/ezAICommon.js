/**
 * ai로 부터 응답 완료 후 연동 처리
 */
function setResponseEndFromAi(newResponseId) {
    var bMenuShow = false;

    var area = document.getElementById(newResponseId);
    if (!area) {
        return bMenuShow;
    }

    var resultText = area.innerText;
    if (!resultText) {
        return bMenuShow;
    }

    // 휴가계 처리
    if (resultText.indexOf("vacation_date:") == 0) {
        vacationProc(area);
        return bMenuShow;
    }



    bMenuShow = true;
    return bMenuShow;
}

/**
 * 휴가계 처리
 */
function vacationProc(area) {
    if (!area) {
        return;
    }

    loading_progress("show");
    try {
        var resultText = area.innerText;
        area.innerHTML = "";  // 초기화

        var vacation_date = resultText.replace("vacation_date:", "");
        var arrDate = vacation_date.split("~");
        var sDate = arrDate[0];
        var eDate = arrDate[1];

        var guid = GetGUID();
        var newSDateId = "Sdatepicker_" + guid;
        var newEDateId = "Edatepicker_" + guid;

        var formHtml = "<div style='text-align:center;'>";
        formHtml += "<input id='" + newSDateId + "' class='datepicker_input' name='Datepicker_name' readonly value='" + sDate + "'> ~ ";
        formHtml += "<input id='" + newEDateId + "' class='datepicker_input' name='Datepicker_name' readonly value='" + eDate + "'>";
        formHtml += "<p>&nbsp;</p>";
        formHtml += "<input type='button' style='cursor:pointer; padding:10px;' value='휴가계 기안' onclick='vacationDraft(\"" + newSDateId + "\", \"" + newEDateId + "\")'>";
        formHtml += "</div>";

        area.innerHTML = formHtml;

        // 달력컨트롤 활성화
        setAiDatePicker();


    }
    catch (e) {
        console.log("vacationProc error: ", e.message);
    }
    finally {
        loading_progress("hidden");
    }
}

/**
 * 달력컨트롤 활성화
 */
function setAiDatePicker() {
    
    removeDatePicker("ui-datepicker-div", $ContentDivAi);
    $ContentDivAi("input[name='Datepicker_name']").each(function () {
        var _this = this.id;
        $ContentDivAi('#' + _this).datepicker({
            changeMonth: true,
            changeYear: true,
            autoSize: true,
            showOn: "both",
            //buttonImage: getCoreAppPath() + "/images/ImgIcon/calendar-month.gif",
            buttonImageOnly: false
        }).on("change", function () {
            DatePicker_parseInputDate(this, $ContentDivAi(this).val().trim(), $ContentDivAi(this).attr("defaultdt"), "", AiDatePicker_parseInputDate_completed);
        });

        // 달력 다국어
        setDatePickerLang(userLang, $ContentDivAi);
    });

    // 버튼 표시되지 않도록 처리
    $ContentDivAi(".ui-datepicker-trigger").remove();
}

/**
 * datepicker 날짜 변경 후 callback
 * @param {any} elm
 * @param {any} selected
 */
function AiDatePicker_parseInputDate_completed(elm, selected) {
    // 시작일과 종료일 설정시 min, max 설정
    AiDatepickerOnSelect(elm.id, selected);
}

/**
 * 시작일과 종료일 설정시 min, max 설정
 * @param {any} thisId
 * @param {any} selected
 */
function AiDatepickerOnSelect(thisId, selected) {
    if (thisId && thisId.indexOf("Sdatepicker_") == 0) {
        var SdatepickerId = "#" + thisId;
        var EdatepickerId = "#" + thisId.replace("Sdatepicker_", "Edatepicker_");

        /*
            1. 시작일자가 종료일자보다 빠른 경우
            - 시작일자의 MaxDate를 종료일자로 설정.
            - 종료일자의 MinDate를 시작일자로 설정.
            2. 시작일자와 종료일자가 같은 경우
            - 시작일자의 MaxDate를 설정하지 않음.
            - 종료일자의 MinDate를 설정하지 않음.
            3. 시작일자가 종료일자보다 늦은 경우
            - 종료일자를 시작일자로 설정.
            - 시작일자의 MaxDate를 설정하지 않음.
            - 종료일자의 MinDate를 설정하지 않음.
        */
        if ($ContentDivAi(SdatepickerId).datepicker("getDate") < $ContentDivAi(EdatepickerId).datepicker("getDate")) {
            $ContentDivAi(SdatepickerId).datepicker("option", "maxDate", $ContentDivAi(EdatepickerId).datepicker("getDate"));
            $ContentDivAi(EdatepickerId).datepicker("option", "minDate", selected);
        }
        else if ($ContentDivAi(SdatepickerId).datepicker("getDate") > $ContentDivAi(EdatepickerId).datepicker("getDate")) {
            $ContentDivAi(EdatepickerId).datepicker("setDate", selected);
            $ContentDivAi(SdatepickerId).datepicker("option", "maxDate", null);
            $ContentDivAi(EdatepickerId).datepicker("option", "minDate", null);
        }
        else {
            // 시작일자가 종료일자보다 빠른 경우
            $ContentDivAi(SdatepickerId).datepicker("option", "maxDate", null);
            $ContentDivAi(EdatepickerId).datepicker("option", "minDate", null);
        }
    }
    else if (thisId && thisId.indexOf("Edatepicker_") == 0) {
        var SdatepickerId = "#" + thisId.replace("Edatepicker_", "Sdatepicker_");
        var EdatepickerId = "#" + thisId;

        /*
            1. 시작일자가 종료일자보다 빠른 경우
            - 시작일자의 MaxDate를 종료일자로 설정.
            - 종료일자의 MinDate를 시작일자로 설정.
            2. 시작일자와 종료일자가 같은 경우
            - 시작일자의 MaxDate를 설정하지 않음.
            - 종료일자의 MinDate를 설정하지 않음.
            3. 시작일자가 종료일자보다 늦은 경우
            - 시작일자를 종료일자로 설정.
            - 시작일자의 MaxDate를 설정하지 않음.
            - 종료일자의 MinDate를 설정하지 않음.
        */
        if ($ContentDivAi(SdatepickerId).datepicker("getDate") < $ContentDivAi(EdatepickerId).datepicker("getDate")) {
            $ContentDivAi(SdatepickerId).datepicker("option", "maxDate", selected);
            $ContentDivAi(EdatepickerId).datepicker("option", "minDate", $ContentDivAi(SdatepickerId).datepicker("getDate"));
        }
        else if ($ContentDivAi(SdatepickerId).datepicker("getDate") > $ContentDivAi(EdatepickerId).datepicker("getDate")) {
            $ContentDivAi(SdatepickerId).datepicker("setDate", selected);
            $ContentDivAi(SdatepickerId).datepicker("option", "maxDate", null);
            $ContentDivAi(EdatepickerId).datepicker("option", "minDate", null);
        }
        else {
            // 시작일자가 종료일자보다 빠른 경우
            $ContentDivAi(SdatepickerId).datepicker("option", "maxDate", null);
            $ContentDivAi(EdatepickerId).datepicker("option", "minDate", null);
        }
    }

    // 버튼 표시되지 않도록 처리
    $ContentDivAi(".ui-datepicker-trigger").remove();
}

/**
 * 휴가계 기안
 * @param {any} sDateId  휴가시작일Id
 * @param {any} eDateId  휴가종료일Id
 */
function vacationDraft(sDateId, eDateId) {
    var sDate = document.getElementById(sDateId).value;  // 휴가시작일
    var eDate = document.getElementById(eDateId).value;  // 휴가종료일

    var message = "기안기(휴가계양식) 팝업, " + "sDate: " + sDate + " ~ " + "eDate: " + eDate;
    Alert_Message(message, null, "2");
}
