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

function getMail(FolderId){
var obj = new Object();
	
    obj.FolderId = FolderId;
    obj.start = 0;
    obj.end = 29;
    obj.search = "";
    obj.filter = "";
	  $.ajax({
	            type : 'get',
	            url : '/mobile/ezEmail/mailGetList.do',
	            data : obj,
	            dataType : "json",
	            error: function(xhr, status, error){
	                alert(error);
	            },
	            success : function(json){               	
	                   	$("#con").html(""); // div를 일단 공백으로 초기화해줌 , 왜냐면 버튼 여러번 눌리면 중첩되니깐
						
	                   	$("<table/>").css({
							backgroundColor : "#E4F7BA",
							border : "solid 3px #E4F7BA",
						}).appendTo("#con"); // 테이블을 생성하고 그 테이블을 div에 추가함
	                   	
						$("<tr>" , {
							html : "<th>" + "attach" + "</th>"+  // 컬럼명들
									"<th>" + "contentclass" + "</th>"+
									"<th>" + "flag" + "</th>"+
									"<th>" + "fromemail" + "</th>"+
									"<th>" + "href" + "</th>"+
									"<th>" + "importance" + "</th>"+
									"<th>" + "read" + "</th>"+
									"<th>" + "receivedt" + "</th>"+
									"<th>" + "sender" + "</th>"+
									"<th>" + "size" + "</th>"+
									"<th>" + "subject" + "</th>"	
						}).appendTo("#con table") // 이것을 테이블에붙임

						for (var x = 1; x < json.length-1; x++) {
	                	
		                   	var items = [];
							items.push("<td>" + json[x].attach + "</td>"); // 여기에 id pw addr tel의 값을 배열에 넣은뒤
							items.push("<td>" + json[x].contentclass + "</td>");
							items.push("<td>" + json[x].flag + "</td>");
							items.push("<td>" + json[x].fromemail + "</td>");
							items.push("<td>" + json[x].href + "</td>");
							items.push("<td>" + json[x].importance + "</td>");
							items.push("<td>" + json[x].read + "</td>");
							items.push("<td>" + json[x].receivedt + "</td>");
							items.push("<td>" + json[x].sender + "</td>");
							items.push("<td>" + json[x].size + "</td>");
							items.push("<td onclick=readMail(" + "'" + encodeURIComponent(json[x].href.split('/')[0]) + "'" 
										+ ',' + "'" + json[x].href.split('/')[1]  + "')>" + json[x].subject + "</td>");
							
							$("<tr/>", {
								html : items // 티알에 붙임,
							}).appendTo("#con table");
						
						}
//	            	}
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