var text = new Array();

text['today'] = 'Today';
text['time'] = 'Time';

text['dayNamesShort'] = new Array(
'Sun',
'Mon',
'Tue',
'Wed',
'Thu',
'Fri',
'Sat'
);
text['dayNames'] = new Array(
'Sunday',
'Monday',
'Tuesday',
'Wednesday',
'Thursday',
'Friday',
'Saturday'
);

text['monthNamesShort'] = new Array(
'Days',
'This',
'Three',
'Four',
'Five',
'Six',
'Seven',
'Eight',
'Nine',
'Ten',
'Eleven',
'Twelve'
);
/*
text['monthNames'] = new Array(
'January',
'February',
'March',
'April',
'May',
'June',
'July',
'August',
'September',
'October',
'November',
'December'
);
*/
text['monthNames'] = new Array(
'1',
'2',
'3',
'4',
'5',
'6',
'7',
'8',
'9',
'10',
'11',
'12'
);


//text['footerDateFormat'] = '%D, %F %j %Y',
text['footerDateFormat'] = '%Y-%m-%d',
text['dateFormat'] = '%n-%j-%Y',
text['footerDefaultText'] = 'Select',

text['clear'] = 'Clear Date',
text['prev_year'] = 'Previous year',
text['prev_month'] = 'Previous month',
text['next_month'] = 'Next month',
text['next_year'] = 'Next year',
text['close'] = 'Close',


// weekend days (0 - sunday, ... 6 - saturday)
text['weekend'] = "0,6";
text['make_first'] = "Start with %s";


RichCalendar.rc_lang_data['kr'] = text;

var objcal = null;
var format = '%Y-%m-%d';
var textField = "";
// show calendar
function show_cal(obj,txtName) {
    textField = txtName;
    if (objcal) return;

    var text_field = document.getElementById(textField);

    objcal = new RichCalendar();
    objcal.start_week_day = 0;
    objcal.language = 'kr';
    objcal.user_onchange_handler = cal_on_change;
    objcal.user_onclose_handler = cal_on_close;
    objcal.user_onautoclose_handler = cal_on_autoclose;
    objcal.parse_date(text_field.value, format);
    objcal.show_at_element(obj, "left-center");

}
function show_cal_posi(obj,txtName, posi) {

    var position = "left-center";
    switch (posi) {
        case p_adj_right_top: position = "adj_right-top"; break;
        case p_adj_right_center: position = "adj_right-center"; break;
        case p_adj_right_bottom: position = "adj_right-bottom"; break;
        case p_adj_right_adj_bottom: position = "adj_right-adj_bottom"; break;
        case p_right_top: position = "right-top"; break;
        case p_right_center: position = "right-center"; break;
        case p_right_bottom: position = "right-bottom"; break;
        case p_right_adj_bottom: position = "right-adj_bottom"; break;
        case p_center_top: position = "center-top"; break;
        case p_center_center: position = "center-center"; break;
        case p_center_bottom: position = "center-bottom"; break;
        case p_center_adj_bottom: position = "center-adj_bottom"; break;
        case p_left_top: position = "left-top"; break;
        case p_left_center: position = "left-center"; break;
        case p_left_bottom: position = "left-bottom"; break;
        case p_left_adj_bottom: position = "left-adj_bottom"; break;        
        default:break;
    }

    textField = txtName;
    if (objcal) return;

    var text_field = document.getElementById(textField);

    objcal = new RichCalendar();
    objcal.start_week_day = 0;
    objcal.language = 'kr';
    objcal.user_onchange_handler = cal_on_change;
    objcal.user_onclose_handler = cal_on_close;
    objcal.user_onautoclose_handler = cal_on_autoclose;
    objcal.parse_date(text_field.value, format);
    objcal.show_at_element(obj, position);
}



function cal_on_change(cal, object_code) {
    if (object_code == 'day') {
        document.getElementById(textField).value = cal.get_formatted_date(format);
        cal.hide();
        objcal = null;
    }
}
function cal_on_close(cal) {
    cal.hide();
    objcal = null;
}
function cal_on_autoclose(cal) {
    objcal = null;
}

var p_adj_right_top = 0;
var p_adj_right_center = 1;
var p_adj_right_bottom = 2;
var p_adj_right_adj_bottom = 3;
var p_right_top = 4;
var p_right_center = 5;
var p_right_bottom = 6;
var p_right_adj_bottom = 7;
var p_center_top = 8;
var p_center_center = 9;
var p_center_bottom = 10;
var p_center_adj_bottom = 11;
var p_left_top = 12;
var p_left_center = 13;
var p_left_bottom = 14;
var p_left_adj_bottom = 15;

