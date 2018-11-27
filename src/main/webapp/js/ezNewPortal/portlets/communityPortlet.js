/**
 * 구해안
 */
var clubNo = "";
var CommuSize = $('#CommuSize').val();
var userId = $('#userId').val();

function view_bestCommunity(event) {
	console.log('clubNo : ' + clubNo + ' ,  userId : '+userId);
	var clubType = "";
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezNewPortal/getCommunityPermit.do",
		data : {
				//꺼내쓸때 event.data.변수명 으로 꺼낸다
				clubNo	:	event.data.iClubNo,
			   },
		success: function(result){
			console.log('clubType : ' + result);
			clubType = result;
		}
	});
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezCommunity/remote/getACL.do",
		data : { cID	:	event.data.iClubNo,
				 uID	:	userId
		},
		success: function(result){
			console.log('OK or ERR      :     ' + result);
			if (result == "ERR" && clubType != "1") {
				OpenAlertUI(messages.strLang11+"<br>"+messages.strLang12, null, "/ezPortal/wpNewCommunity.do.OpenAlertUI");
			} else {
				var wWeight = "1300";
                var wHeight = "900";

                var heigth = window.screen.availHeight;
                var width = window.screen.availWidth;

                var left = (width - wWeight) / 2;
                var top = (heigth - wHeight) / 2 - 30;

                var ret = window.open("/ezCommunity/checkCommHome.do?communityCD=" + encodeURIComponent(clubNo), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			}
		}
	});
}

function viewCommuList() {
    window.open("/ezCommunity/communityMain.do?funCode=5", "main", "");
}

var ezapralert_cross_dialogArguments = new Array();

function OpenAlertUI(NewWinContent, NewWinCallFunction, NewWinName) {
    var parameter = NewWinContent;

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;

        if (NewWinCallFunction != undefined || NewWinCallFunction != null)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;

        var windowopenfeature = "height=205px,width=330px,status=no,toolbar=no,menubar=no,location=no,resizable=1";
        windowopenfeature = windowopenfeature + GetOpenPosition(205, 330);

        window.open("/ezCommunity/ezAprAlert.do", NewWinName, windowopenfeature);
    } else {
        var windowshomodalDialogfeature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
        windowshomodalDialogfeature = windowshomodalDialogfeature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog("/ezCommunity/ezAprAlert.do", parameter, windowshomodalDialogfeature);
    }
}

function OpenAlertUI_Complete() {
    //Source Code...
}