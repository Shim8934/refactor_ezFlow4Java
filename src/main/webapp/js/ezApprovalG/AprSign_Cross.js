function GetImageXml(pUserID, pDeptID) {
	var result = "";
	var tUrl = "";
	var tData = "";
	
	if (pUserID == "seal") {
        tUrl = "/ezApprovalG/getSealRequest.do";
        tData = pDeptID;
    }
    else {
        tUrl = "/ezApprovalG/getSignRequest.do";
        tData = pUserID;
    }
	
	$.ajax({
		type : "POST",
		dataType : "xml",
		async : false,
		url : tUrl,
		data : {
			userID : tData
		},
		success: function(xml){
			result = xml;
		}        			
	});

    Resultxml = result;
    CheckImageExist(Resultxml);
}

function CheckImageExist(pSignInfo) {
    var SignNodeList = SelectNodes(pSignInfo, "LISTVIEWDATA/ROWS/ROW");
    if (SignNodeList.length == 0) {
        window.returnValue = "NAME";
    } else {
        var pLVlist = new ListView();                          
        pLVlist.SetID("listSIGNLIST");                              
        pLVlist.SetMulSelectable(false);                       
        
        pLVlist.SetRowOnClick("SIGNLIST_onfocus");
        pLVlist.DataSource(pSignInfo);                            
        pLVlist.DataBind("SIGNLIST");
    }
}

function DisplaySeuMyung() {
    var psignxml;
    psignxml = "<LISTVIEWDATA><HEADERS>";
    psignxml = psignxml + "<HEADER><NAME>" + strLang418 + "</NAME><WIDTH>140</WIDTH></HEADER>";
    psignxml = psignxml + "</HEADERS><ROWS>";
    psignxml = psignxml + "<ROW><CELL><VALUE>" + strLang419 + "</VALUE></CELL>";
    psignxml = psignxml + "</ROW></ROWS></LISTVIEWDATA>";

    Resultxml = loadXMLString(psignxml);

    var objNodes = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW/CELL");
    objNodes[0].childNodes[1].text = "NAME";

    SIGNLIST.dataSource = Resultxml;
    SelectSeuMyung();
}

function SelectSeuMyung() {
    var CurSel = SIGNLIST.rows;
    CurSel[0].select();
}