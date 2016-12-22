function UserDocCount() {
    docMode = "";
    curpage = 1;
    nowblock = 0;
    totalPage = 0;
    
    var result = "";
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getUserDocCount.do",
		data : {
			startYear  : document.getElementById("SYear").value,
			startMonth : document.getElementById("SMonth").value,
			endYear    : document.getElementById("EYear").value,
			endMonth   : document.getElementById("EMonth").value,
			userFlag   : pUserFlag,
			companyID  : document.getElementById("ListCompany").value
		},
		success: function(text){
			result = text;
		}
	});    

    resultXML = loadXMLString(result);

    if (resultXML.xml != "") {
        StatistList = resultXML;
        NodeList = SelectNodes(resultXML, "LISTVIEWDATA/ROWS/ROW");
        Headers = SelectNodes(resultXML, "LISTVIEWDATA/HEADERS/HEADER");

        NodeListLen = 0;

        if (NodeList != null) {
            NodeListLen = NodeList.length;
        }
        var listview = new ListView();
        document.getElementById("lvtForm").innerHTML = "";
        listview.SetID("lvtFormID");
        listview.SetMulSelectable(false);
        listview.DataSource(resultXML);
        listview.DataBind("lvtForm");

    }
    LISTTYPE = "ADMINUSERCOUNT";
}
function DeptDocCount(pMode) {
    docMode = pMode;
    curpage = 1;
    nowblock = 0;
    totalPage = 0;

    var result = "";
    
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApproval/getDeptTranSendDocCount.do",
		data : {
			startYear  : document.getElementById("SYear").value,
			startMonth : document.getElementById("SMonth").value,
			endYear    : document.getElementById("EYear").value,
			endMonth   : document.getElementById("EMonth").value,
			mode       : pMode,
			companyID  : document.getElementById("ListCompany").value
		},
		success: function(text){
			result = text;
		}
	});   
	
    resultXML = loadXMLString(result);
    if (resultXML.xml != "") {
        StatistList = resultXML;

        NodeList = SelectNodes(resultXML, "LISTVIEWDATA/ROWS/ROW");
        Headers = SelectNodes(resultXML, "LISTVIEWDATA/HEADERS/HEADER");

        NodeListLen = 0;

        if (NodeList != null) {
            NodeListLen = NodeList.length;
        }

        if (NodeListLen > 15) {
            paging(curpage, nowblock);
        }
        else {
            var listview = new ListView();
            document.getElementById("lvtForm").innerHTML = "";
            listview.SetID("lvtFormID");
            listview.SetMulSelectable(false);
            listview.DataSource(resultXML);
            listview.DataBind("lvtForm");
        }
    }
    LISTTYPE = "ADMINDEPTCOUNT";
}
function td_Create(strtext) {
    td = PageNum.insertCell();
    td.width = "17px";
    td.height = "17px";
    td.align = "center";
    td.valign = "center";
    td.innerHTML = strtext;
}