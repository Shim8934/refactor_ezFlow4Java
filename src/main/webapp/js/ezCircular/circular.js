var writeboardselect_modal_dialogArguments = new Array();
function CircularWrite_onclick() {
	var feature = GetOpenPosition(820, 900);
	url = "/ezCircular/circularWrite.do";
	var OpenWin = window.open(url, "", "width=820, height=900, status=no, toolbar=no, menubar=no,location=no,resizable=1" + feature);
    OpenWin.focus();     
}

function confirmCircular() {
	if(!confirm("<spring:message code='ezCircular.t66' />")) {
		return;
	} else {
		$.ajax({
			type : "POST",
			url : "/ezCircular/confirmCircular.do",
			dataType : "json",
			data : {
				circularID : circularID
			},
			success : function(result) {
				alert("회람을 확인완료했습니다.")
			},error : function(jqXHR, textStatus, errorThrown) {
				alert("회람을 확인하지 못했습니다.")
			}
		})
	}
	
	
}