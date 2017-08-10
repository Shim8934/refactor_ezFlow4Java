	function updateOptionAjax(){
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
	
	function searchOptionAjax(){
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
				var obj = JSON.parse(e);
				console.log(obj);
				var detail = obj.Detail;
				setOptionValue(detail);
    		}
        });
 	}
	
	function saveOptionButton() {
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
  
  function setOptionValue(t){

	  var lang = '1';
	  var timeZone = '235|+09:00';
	  var listCnt = '5';
	  var useSearch = 'Y';
	  var useSecurity = 'N';
	  
	  if(t.hasOwnProperty('lang')){
		  lang = t.lang
	  }
	  
	  if(t.hasOwnProperty('timeZone')){
		  timeZone = t.timeZone
	  }
	  
	  if(t.hasOwnProperty('listCnt')){
		  listCnt = t.listCnt
	  }
	  
	  if(t.hasOwnProperty('useSearch')){
		  useSearch = t.useSearch
	  }
	  
	  if(t.hasOwnProperty('useSecurity')){
		  useSecurity = t.useSecurity
	  }	  
	  
	  if(lang == '1'){
		  $('#radio-view-a').val(lang); 
	  }else if(lang == '2'){
		  $('#radio-view-b').val(lang); 
	  }else if(lang == '3'){
		  
	  }
	  
      $('#select-custom-1').val(timeZone);
      $('#slider-2').val(listCnt);
      $('#radio-view3').val(useSearch);
      $('#radio-view4').val(useSecurity); 
		  
  }