var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction, type, selectType) {
    var parameter = pAlertContent;
    var url = "";

    if (typeof selectType != "undefined" && selectType) {
        /*
            n지선다 선택지 제공 팝업 추가
             : pAlertContent : alert message
             : CompeleteFunction :
               ex) var tmp = [
                   {
                        "msg" : 선택지 버튼 텍스트,
                        "rtnF" : 해당 버튼의 eventHandler,
                        "fl" : alert 팝업으로부터 ↑ 위 이벤트 function의 위치(parent, left 등... empty String일 경우 ""로 초기화),
                        "css" : tag style 속성. 없을 경우 ""로 초기화(버튼 개수에 따른 margin 등의 속성을 컨트롤 하기 위함.)
                   },
                   {
                        "msg" : 선택지 버튼 텍스트,
                        "rtnF" : 해당 버튼의 eventHandler,
                        "fl" : alert 팝업으로부터 ↑ 위 이벤트 function의 위치(parent, left 등... empty String일 경우 ""로 초기화),
                        "css" : tag style 속성. 없을 경우 ""로 초기화(버튼 개수에 따른 margin 등의 속성을 컨트롤 하기 위함.)
                   },
                   .
                   .
                   .
               ]
             : type = null
             : selectType = 선택지 팝업? or 기존 팝업? (true || false)
        */
        url = "/ezApprovalG/ezAprSelectAlert";
    } else {
        if (CompleteFunction == "OPEN")
            url = "/ezApprovalG/ezAprAlert.do?type=OPEN";
        else
            url = "/ezApprovalG/ezAprAlert.do";
    }

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        ezapralert_cross_dialogArguments[1] = CompleteFunction;

        if (CompleteFunction != undefined) {
            if (CompleteFunction == "OPEN")
            {
            	if (type != undefined) { //2018-09-20 김보미 - 윈도우 팝업창 확인 안닫히는 문제
            		ezapralert_cross_dialogArguments[2] = true;
            	}
            	ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
                setTimeout(function () {
                    var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
                }, 100);
            }
            else
                DivPopUpShow(330, 205, url);
        }
        else {            
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
            DivPopUpShow(330, 205, url);
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete(RtnVal) {
    DivPopUpHidden();
}

function OpenAlertUI_SUB(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArgument[0] = parameter;
        ezapralert_cross_dialogArgument[1] = OpenAlertUI_SUB_Complete;
        ezapralert_cross_dialogArgument[2] = "";
        DivPopUpShow_sub(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}
function OpenAlertUI_SUB_Complete(RtnVal) {
    DivPopUpHidden_sub();   
}

var apropinion_cross_dialogArgument = new Array();
function openOpinionUI(pOpinionFlag) {
    try {
        var parameter = new Array();
        parameter[0] = pDocID;
        parameter[1] = pOpinionFlag;
        parameter[2] = KuyjeType;
        parameter[3] = pDraftFlag;
        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
        parameter[99] = ext;
        
        var url = "/ezApprovalG/aprOpinion.do";
        apropinion_cross_dialogArgument[0] = parameter;
        apropinion_cross_dialogArgument[1] = openOpinionUI_Complete;
        DivPopUpShow(530, 520, url);
     
    } catch (e) {
        alert(e.description);
    }
}

var aprattach_dialogArgument = new Array();
function openFileAttachUI() {
    try {
        var parameter = pDocID;
        var url = "/myoffice/ezApproval/ezAPRATTACH/AprAttach2.aspx?pDocID=" + pDocID;
        aprattach_dialogArgument[0] = parameter;
        aprattach_dialogArgument[1] = openFileAttachUI_Complete;
        DivPopUpShow(580, 290, url);
    } catch (e) {
        alert("openFileAttachUI()" + e.description);
    }
}
function openFileAttachUI_Complete(RtnVal)
{
    if (RtnVal != "cancel") {
        setAttachInfo(pDocID, "APR", lstAttachLink);
    }
    DivPopUpHidden();
}

var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, FunctionName, Type) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (FunctionName != undefined)
            ezapropinion_cross_dialogArguments[1] = FunctionName;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        if (Type == undefined) {
            DivPopUpShow(330, 205, url);
        }
        else {
        	//2018-08-21 배현상, type에 대한 처리를 controller에서 하지않고 opener의 변수를 가지고 사용하기에 로직 수정
        	ezapropinion_cross_dialogArguments[2] = true;
            GetOpenWindow(url, "ezAPROPINION_Cross", 325, 200, "NO");
        }
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
        return RtnVal;
    }
}

function OpenInformationUI_Complete(RtnVal, Complete_Function)
{
    DivPopUpHidden();
    if (RtnVal) {
        Complete_Function(RtnVal);   
    }
}

function getEngMonth(month) {
	var engMonthStr = "";
	
	switch(Number(month)) {
		case 1 :
			engMonthStr = "Jan";
			break;
		case 2 :
			engMonthStr = "Feb";
			break;
		case 3 :
			engMonthStr = "Mar";
			break;
		case 4 :
			engMonthStr = "Apr";
			break;
		case 5 :
			engMonthStr = "May";
			break;
		case 6 :
			engMonthStr = "Jun";
			break;
		case 7 :
			engMonthStr = "Jul";
			break;
		case 8 :
			engMonthStr = "Aug";
			break;
		case 9 :
			engMonthStr = "Sep";
			break;
		case 10 :
			engMonthStr = "Oct";
			break;
		case 11 :
			engMonthStr = "Nov";
			break;
		case 12 :
			engMonthStr = "Dec";
			break;
	}
	
	return engMonthStr;
}

function getDatePeriod(userLang, startYear, startMonth, startDate, endYear, endMonth, endDate) {
	return getDateStrByLang(userLang, startYear, startMonth, startDate) + " ~ " + getDateStrByLang(userLang, endYear, endMonth, endDate);
}

function getDateStrByLang(userLang, year, month, date) {
	if (userLang == "2") {
		return getEngMonth(month) + " " + date + ", " + year;
	} else {
		return year + strLang1028 + " " + month + strLang1029 + " " + date + strLang1030
	}
}