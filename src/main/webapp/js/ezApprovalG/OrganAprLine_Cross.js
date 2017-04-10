function isgetUser(DeptID, DeptLPath) {
    var rtnVal = true;
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezOrgan/getDeptMemberList.do",
		data : {
				deptID   : DeptID, 
				cell 	 : "displayName;description;title;telephonenumber",
				prop     : "department",
				type 	 : "user"
		},
		success: function(text){
			result = text;
		}        			
	});
    
    if (result == "") rtnVal = false;
    var nodes = SelectNodes(loadXMLString(result), "LISTVIEWDATA/ROWS");

    if (rtnVal) {
        if (nodes.length > 0)
            rtnVal = true;
        else
            rtnVal = false;
    }
    return rtnVal;
}
