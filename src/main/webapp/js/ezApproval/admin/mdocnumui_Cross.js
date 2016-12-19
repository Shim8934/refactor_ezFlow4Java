
function getGroupItem(pGroupID) {
    var result = "";
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/mGetDocNumItem.do",
		data : {
			groupID : pGroupID,
			listType : "YYY",
			companyID  : companyID
		},
		success: function(text){
			result = text;
		}
	});
	
    var listview = new ListView();
    listview.LoadFromID("lvtFormID");
    listview.DataSource(loadXMLString(result));
    document.getElementById('lvtForm').innerHTML = "";
    listview.DataBind("lvtForm");

    if (listview.GetRowCount() <= 0) {
        document.getElementById('lvtForm').innerHTML = "";
        listview.DataSource(ITEM);
        listview.DataBind("lvtForm");
    }
}

var ezapralert_cross_dialogArgument = new Array();
function OpenAlertUI(pAlertContent) {
    ezapralert_cross_dialogArgument[0] = pAlertContent;
    var url = "/admin/ezApproval/ezAprAlert.do";
    var result = GetOpenWindow(url, "ezAPRALERT_Cross", 330, 205, "NO");
}

var ezapropinion_cross_dialogArgument = new Array();
function OpenInformationUI(pInformationContent) {
    ezapropinion_cross_dialogArgument[0] = pInformationContent;
    var url = "/admin/ezApproval/ezAprOpinion.do?type=open";
    var result = GetOpenWindow(url, "ezAPROPINION_Cross", 330, 205, "NO");
}
