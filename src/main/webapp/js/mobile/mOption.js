	function updateOption(){
 		console.log("in updateOption");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/ezOption/updateOption.do",
    		data : {
    			id  : "1",
    			timeZone: "",
    			lang: "",
    			listCnt: "",
    			useSearch: "",
    			useSecurity: ""
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function searchOption(){
 		console.log("in updateOption");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/ezOption/searchOption.do",
    		data : {
    			id  : "1",
    			timeZone: "",
    			lang: "",
    			listCnt: "",
    			useSearch: "",
    			useSecurity: ""
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}