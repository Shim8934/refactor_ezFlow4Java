/**
 * json test
 */

function InitJsonListView() {

    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprGJson/aprLineRequest.do",
    		data : {
    				docID    : "00000000000001001369", 
    				userID 	 : "min001",
    				formID   : "2019000002",
    				deptID 	 : "s908008",
    				reDraft  : "DRAFT",
    				isUsed   : "",
    				mode     : "",
    				orgCompanyID : "S908000"
    				},
    		success: function(xml){
    			result = JSON.parse(xml);
    			console.log(result);
    		}        			
    	});

}