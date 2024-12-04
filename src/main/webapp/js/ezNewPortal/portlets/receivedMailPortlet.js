/**
 * 
 */
var mailPercent = "";
var mailPortletObj = {};
var pageNum = 1;

function initMailPortletInfo(MailPortletId) {
	var newObj = {};
	var perCount = getMailPagePerCount(MailPortletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.page.getPagePerCount = function () {
		return getMailPagePerCount(MailPortletId);
	}
	newObj.portletCode = "receivedmail";
	newObj.getPortletList = function () {
		getMailList(newObj.page.getPage());
	}
	portletInfoMap["portlet" + MailPortletId] = newObj;
	mailPortletObj.portletId = MailPortletId;
	
	getMailList(1);
}


function getMailPagePerCount(MailPortletId) {
	var portletSize = getPortletSize(MailPortletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 7;
	} else {
		count = 3;
	}

	return count;
}

const surveyPorletPagingCnt = 21; // portlet 높이가 1일 때(3) 와 2일 때(7) 표출되는 리스트 개수의 최소공배수  

function getMailList(currPage) {
	$.ajax({
		type : "GET",
		dataType : "json",
		async : true,
		url : "/ezNewPortal/receivedMailPortletList.do",
		data : {
			mailCount: getMailPagePerCount(mailPortletObj.portletId),
			currPage: currPage
		},
		success: function(result){
			mailPercent = result.mailPercent
			var unreadCount = result.unreadCount;
			var totalCount = result.totalCount;
			var mailboxDetail = result.mailboxDetail;
			var mailboxQuotaStr = result.mailboxQuotaStr;
			pageNum = result.currPage;
			var mailList = !!result.mailList ? result.mailList : [];
			var readClass = "";
			var href = "";
			var subject = "";
			var receivedDateStr = "";
			var sender = "";
			var listHTML = "";
			var listHTML2 = "";
			var mailListCount = mailList.length;
			if (mailListCount > 21) {
				mailListCount = 21;
			}
			
			listHTML += "<p class='mGraph sortablePortlet'><span id='mGraphSpan'></span></p>";
			listHTML += "<span class='mGraph_text sortablePortlet' id='UseMailBox'>";
			listHTML += mailboxDetail;
			listHTML += "<span class='sortablePortlet'>/"+mailboxQuotaStr+"</span>";
			listHTML += "</span>";
			
			document.getElementById("mailGraph").innerHTML = listHTML;

			if (!mailPercent || mailPercent == "") {
				mailPercent = 0;
			}
			$("#mGraphSpan").css("width", mailPercent + "px");
			
			if (mailList.length < 1) {
				listHTML2 += "<dl class='nodata'>";
				listHTML2 += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
				listHTML2 += "<dd>" + messages.strLang1 + "</dd>";
				listHTML2 += "</dl>";
				
			} else {
				for (var i = 0; i < mailListCount; i++) {
					readClass = mailList[i].readClass;
					href = mailList[i].href;
					subject = mailList[i].subject;
					receivedDateStr = mailList[i].receivedDateStr;
					sender = mailList[i].sender;
					listHTML2 += "<li class="+readClass+" onclick='open_mail(&#39;" + href + "&#39;)'>";
					listHTML2 += "<span class='txt'>";
					if (mailList[i].securedMail === "true") {
						listHTML2 += "<span class='security_icon'></span>";
					}
					listHTML2 += MakeXMLString(subject) + "</span>";
					listHTML2 += "<span class='date'>"+MakeXMLString(receivedDateStr).replace(/-/g, ".")+"</span>";		
					listHTML2 += "<span class='name'>"+MakeXMLString(sender)+"</span>";	
					listHTML2 += "</li>";	
				}
			}
			
			document.getElementById("MailList").innerHTML = listHTML2;
//            var totalCnt = mailList.length < surveyPorletPagingCnt ? mailList.length : surveyPorletPagingCnt;
//            var currentPage = 1;
            resetPortletPaging(mailPortletObj.portletId, totalCount, pageNum, "");
		},
		error:function(request,status,error){
    	    console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	   }
	});
}

function open_mail(url) {

	if (checkBlockedMail(url) == '1') {
		alert(strLangLDH07);
		return;
	}
	
	setTimeout(function(){
		getMailList(pageNum); 
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

function checkBlockedMail(url) {
	var strQuery = "<URL>" + url + "</URL>";
	xmlhttp_mailCheckBlock = createXMLHttpRequest();

	var previewUrl = "/ezEmail/mailPrevShow.do?MSGFLAG=N";

	xmlhttp_mailCheckBlock.open("POST", previewUrl, false);
	xmlhttp_mailCheckBlock.send(strQuery);

	var pBlockedMail = 1;

	if (xmlhttp_mailCheckBlock.status == 200) {
		pBlockedMail = getNodeText(SelectNodes(xmlhttp_mailCheckBlock.responseXML, "DATA/BLOCKEDMAIL")[0]);
	}

	return pBlockedMail;
}