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
	
	function saveOption() {
		var resourceChk = "";
		
        $("input[name=resourceChk]:checked").each(function() {
        	resourceChk += $(this).val() + ",";
        });
        
        var lang = $('input[name = radio-view]:checked').val();
        var timeZone = $('#select-custom-1 option:selected').val();
        var listCnt = $('input[name = slider-2]').val();
        var useSearch = $('input[name = radio-view3]:checked').val();
        var useSecurity = $('input[name = radio-view4]:checked').val(); 
        
        console.log(lang);
        console.log(timeZone);
        console.log(listCnt);
        console.log(useSearch);
        console.log(useSecurity);
        

	}
	
  function addPlus(flag) {
	  if (flag == '1') {
	  	$('#plus').closest('.ui-btn').hide(); 
	  } else {
		$('#plus').closest('.ui-btn').show(); 
	  }
  }