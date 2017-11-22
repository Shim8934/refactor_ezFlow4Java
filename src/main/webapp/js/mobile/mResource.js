function scheduleGet() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/mobile/ezResource/scheduleGet.do",
		success: function(result){
			var list = result["resultList"];
			var strHTML = "";
			for (var i=0; i<list.length; i++) {
				strHTML += "<li>";
				strHTML += "<a class='ui-btn ui-btn-icon-right ui-icon-carat-r' href='/mobile/ezResource/resourceDetail.do?ownerID="+list[i].ownerID+"&num="+list[i].num+"'>";
				strHTML += "<label>";
				strHTML += "<h2>"+list[i].title+"</h2>";
				strHTML += "<p>"+list[i].ownerNm+"</p>";
				strHTML += "<span>"+list[i].startDate+"</span>~";
				strHTML += "<span>"+list[i].endDate+"</span>";
				strHTML += "</label>";
				strHTML += "</a>";
				strHTML += "</li>";
			}
			$("#resourceList > div[class='ui-content'] > ul[data-role='listview']").html("");
			$("#resourceList > div[class='ui-content'] > ul[data-role='listview']").append(strHTML);
		}
	});
}

function searchResSchMainList(){
		console.log("in searchResSchMainList");
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/mobile/resource/SearchResMainList.do",
		data : {
			firstWriteDay: "2017-08-02 10:00:00",
			lastWriteDay: "2017-08-02 09:00:00"
		},
		success: function(e) {		    			
			console.log(e);
		}
    });
	}

	function searchResSchList(){
 		console.log("in searchResSchList");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/SearchResSchList.do",
    		data : {
    			startDate  : "2017-07-01 09:00:00",
    			endDate: "2017-07-01 10:00:00",
    			ownerId: "11",
    			type: "date"
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function searchResFolderList(){
 		console.log("in searchResFolderList");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/SearchResFolderList.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function searchResFavoriteList(){
 		console.log("in searchResFavoriteList");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/SearchResFavoriteList.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function searchResSchDetail(){
 		console.log("in searchResSchDetail");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/SearchResSchDetail.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function checkResSchRepeat(){
 		console.log("in checkResSchRepeat");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/CheckResSchRepeat.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function insertResSchedule(){
 		console.log("in insertResSchedule");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/InsertResSchedule.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function updateResSchedule(){
 		console.log("in updateResSchedule");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/UpdateResSchedule.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function deleteResSchedule(){
 		console.log("in deleteResSchedule");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/DeleteResSchedule.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function insertResFavorite(){
 		console.log("in insertResFavorite");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/InsertResFavorite.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	function deleteResFavorite(){
 		console.log("in deleteResFavorite");
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/mobile/resource/DeleteResFavorite.do",
    		data : {
    			id  : "1"		    			
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	

	
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
    			useSecurity: ""
    		},
    		success: function(e) {		    			
				console.log(e);
    		}
        });
 	}
	
	