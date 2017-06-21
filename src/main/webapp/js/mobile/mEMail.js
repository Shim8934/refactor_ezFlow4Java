function getMail(FolderId){
  $.ajax({
            type : 'post',
            url : '/mobile/ezEmail/mailGetList.do',
            data : {FOLDERID:FolderId,START:1,END:10,SEARCH:""},
            dataType : "json",
            contentType : "application/json; charset=UTF-8",
            error: function(xhr, status, error){
                alert(error);
            },
            success : function(json){ 
            	for (var x = 1; x < json.length-1; x++) {
                   	alert(json[x].attach + json[x].contentclass + json[x].flag + json[x].fromemail);
            	}
            },
        });
}

function moveMail(){
	  $.ajax({
	            type : 'post',
	            url : '/mobile/ezEmail/mailMoveMessage.do',
	            data : {UNIQUEID:"INBOX/67",FOLDERID:"개인 편지함"},
	            dataType : "text",
	            contentType : "application/json; charset=UTF-8",
	            error: function(xhr, status, error){
	                alert(error);
	            },
	            success : function(data){
	                alert(data)
	            },
	        });
}

function deleteMail(){
	  $.ajax({
	            type : 'post',
	            url : '/mobile/ezEmail/mailDelete.do',
	            data : {UNIQUEID:"INBOX/66",FOLDERID:"INBOX"},
	            dataType : "text",
	            contentType : "application/json; charset=UTF-8",
	            error: function(xhr, status, error){
	                alert(error);
	            },
	            success : function(data){
	                alert(data)
	            },
	        });
}

function readMail(params){
	//params 
	//ex){iptURL:'INBOX/16', PNFlag:'Y', CONTENTCLASS:'IPM.Note'}
	var form = document.createElement("form");
    
	form.setAttribute("method", "get");
    form.setAttribute("action", "/mobile/ezEmail/mailRead.do");
    
    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
         }
    }
    document.body.appendChild(form);
    form.submit();
}

function Get_MailReceiverList(param) {
	var form = document.createElement("form");
    
	form.setAttribute("method", "POST");
    form.setAttribute("action", "/mobile/ezEmail/mailGetReceiveList.do");
    
    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", "MESSAGEID");
    hiddenField.setAttribute("value", param);
    
    form.appendChild(hiddenField);
    
    document.body.appendChild(form);
    form.submit();    
}

function toggleCc(parma){

}

function loadAddress(){
	
}