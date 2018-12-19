/**
 * 
 */
var mailPercent = "";

function getMailList() {
	$.ajax({
		type : "POST",
		dataType : "json",
		async : true,
		url : "/ezNewPortal/receivedMailPortletList.do",
		data : {
		},
		success: function(result){
			mailPercent = result.mailPercent
			var mailboxDetail = result.mailboxDetail;
			var mailboxQuotaStr = result.mailboxQuotaStr;
			var mailList = result.mailList;
			var readClass = "";
			var href = "";
			var subject = "";
			var receivedDateStr = "";
			var sender = "";
			var listHTML = "";
			var listHTML2 = "";
			var mailListCount = mailList.length;
			if (mailListCount > 5) {
				mailListCount = 5;
			}
			
			listHTML += "<p class='mGraph'><span id='mGraphSpan'></span></p>";
			listHTML += "<span class='mGraph_text' id='UseMailBox'>";
			listHTML += mailboxDetail;
			listHTML += "<span>/"+mailboxQuotaStr+"</span>";
			listHTML += "</span>";
			
			document.getElementById("mailGraph").innerHTML = listHTML;

			if (!mailPercent || mailPercent == "") {
				mailPercent = 0;
			}
			$("#mGraphSpan").css("width", mailPercent + "px");
			
			if (mailList.length < 1) {
				listHTML2 += "<dl class='nodata'>";
				listHTML2 += "<dt><img src='/images/kr/main/nodata.png'></dt>";
				listHTML2 += "<dd>&#34;" + messages.strLang1 + "&#34;</dd>";
				listHTML2 += "</dl>";
				
			} else {
				for (var i = 0; i < mailListCount; i++) {
					readClass = mailList[i].readClass;
					href = mailList[i].href;
					subject = mailList[i].subject;
					receivedDateStr = mailList[i].receivedDateStr;
					sender = mailList[i].sender;
					listHTML2 += "<li class="+readClass+" onclick='open_mail(&#39;" + href + "&#39;)'>";
					listHTML2 += "<span class='txt'>"+ MakeXMLString(subject) +"</span>";		
					listHTML2 += "<span class='date'>"+MakeXMLString(receivedDateStr)+"</span>";		
					listHTML2 += "<span class='name'>"+MakeXMLString(sender)+"</span>";	
					listHTML2 += "</li>";	
				}
			}
			
			document.getElementById("MailList").innerHTML = listHTML2;
		},
		error:function(request,status,error){
    	    console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	   }
	});
}

function open_mail(url) {
	setTimeout(function(){
		getMailList(); 
	}, 1000);
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;

    var newwin;
    var pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";

    newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
//    newwin.focus();    
}
	
function Mailmore_btnClick() {
    window.open("/ezEmail/mailMain.do", "main");
}