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
