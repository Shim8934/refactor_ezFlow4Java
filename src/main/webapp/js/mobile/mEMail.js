function sendMail(){
	
	var obj = new Object();
    
	obj.subject = $('#subject').val();
    obj.to = '"강민석" <rkd1395@svn.opensol2014.com>';
    obj.cc = '"강민석" <rkd1395@svn.opensol2014.com>';
    obj.bcc = '"강민석" <rkd1395@svn.opensol2014.com>';
    obj.textbody = $('#textbody').val();
    obj.from = '"강민석" <rkd1395@svn.opensol2014.com>';
    
    var jsonData = JSON.stringify(obj);
  $.ajax({
            type : 'post',
            url : '/mobile/ezEmail/mailSendMessage.do',
            data : 
//            		subject:"테스트 메일",
//            		to:"강민석<rkd1395@svn.opensol2014.com>",
//            		cc:"강민석<rkd1395@svn.opensol2014.com>",
//            		bcc:"강민석<rkd1395@svn.opensol2014.com>",
//            		textbody:"zzzzz",
//            		from:"강민석<rkd1395@svn.opensol2014.com>"
            	jsonData
            		,
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

function goMailWrite() {
	$.mobile.changePage("/mobile/ezEmail/mMailWrite.do", {
		type: "post",
		transition: "pop",
		changeHash: true
	});
}

function tempSave(){
	
	var obj = new Object();
    
	obj.subject = $('#subject').val();
    obj.to = '"강민석" <rkd1395@svn.opensol2014.com>';
    obj.cc = '"강민석" <rkd1395@svn.opensol2014.com>';
    obj.bcc = '"강민석" <rkd1395@svn.opensol2014.com>';
    obj.textbody = $('#textbody').val();
    obj.from = '"강민석" <rkd1395@svn.opensol2014.com>';
    
    var jsonData = JSON.stringify(obj);
  $.ajax({
            type : 'post',
            url : '/mobile/ezEmail/mailSaveMessage.do',
            data : jsonData,
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

function getMail(FolderId){
var obj = new Object();
	
    obj.FolderId = FolderId;
    obj.start = 0;
    obj.end = 9;
    obj.search = "";
    obj.filter = $("#filter option:selected").val();

	$.ajax({
		type : 'get',
	    url : '/mobile/ezEmail/mailGetList.do',
	    data : obj,
	    dataType : "json",
	    error: function(xhr, status, error){
	    	alert(error);
	    },
	    success : function(json){               	
	    var messages = json.messages;
	    var tag = "<ul data-role='listview' data-inset='false' data-theme='a' class='ui-listview ui-group-theme-a'>"
					
		for (var x = 0; x < messages.length; x++) {
			tag =  tag + "<li><a href='/mobile/ezEmail/mailRead.do?folderId=" + encodeURIComponent(messages[x].folderId) + "&messageId="+ messages[x].href.split('/')[1] 
				+"' class ='ui-btn ui-btn-icon-right ui-icon-carat-r'><h2 style='font-size:12px'><i class='fa fa-envelope' style='font-size:12px;'>" +  messages[x].sender 
				+ "</i></h2><p class='ui-li-aside'>" +  messages[x].receivedt + "</p><p>" +  messages[x].subject + "</p></a></li>"
		}
		
		$('.content').html(tag);
		$("#unReadCount").text(json.unReadCount);
		$("h1").text(json.folderId)
        },
        
	});
}

function getSubFolder(FolderId){
	
	var obj = new Object();
	
    obj.FolderId = FolderId;

	  $.ajax({
	            type : 'get',
	            url : '/mobile/ezEmail/getFolderList.do',
	            data : obj,
	            dataType : "html",
//	            contentType : "application/json; charset=UTF-8",
	            error: function(xhr, status, error){
	                alert(error);
	            },
	            success : function(data){ 
	            	alert(data)
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

function readMail(folderId,messageId){
	
	var obj = new Object();
    
	obj.folderId = folderId
	obj.messageId = messageId;
   
  $.ajax({
            type : 'get',
            url : '/mobile/ezEmail/mailRead.do',
            data : obj,
            dataType : "text",
            error: function(xhr, status, error){
                alert(error);
            },
            success : function(data){ 
            	alert(data)
            },
        });
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