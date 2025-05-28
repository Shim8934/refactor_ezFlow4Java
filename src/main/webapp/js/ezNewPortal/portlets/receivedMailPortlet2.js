/**
 * 
 */
var mailPercent = "";
var mailPortletObj = {};
var pageNum = 1;

function initMailPortletInfo2(MailPortletId) {
	var newObj = {};
	var perCount = getMailPagePerCount(MailPortletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.page.getPagePerCount = function () {
		return getMailPagePerCount(MailPortletId);
	}
	newObj.portletCode = "receivedmail2";
	newObj.getPortletList = function () {
		getMailList2(newObj.page.getPage());
	}
	portletInfoMap["portlet" + MailPortletId] = newObj;
	mailPortletObj.portletId = MailPortletId;

	getMailList2(1, MailPortletId);
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

function getMailList2(currPage, portletId) {
	$.ajax({
		type : "GET",
		dataType : "json",
		async : true,
		url : "/ezNewPortal/receivedMailPortletList2.do",
		data : {
            mailCount: getMailPagePerCount(portletId),
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

            listHTML += "<p class='mGraph sortablePortlet'><span id='mGraphSpan2'></span></p>";
            listHTML += "<span class='mGraph_text sortablePortlet' id='UseMailBox2'>";
            listHTML += mailboxDetail;
            listHTML += "<span class='sortablePortlet'>/"+mailboxQuotaStr+"</span>";
            listHTML += "</span>";

            document.getElementById("mailGraph2").innerHTML = listHTML;

            if (!mailPercent || mailPercent == "") {
                mailPercent = 0;
            }
            $("#mGraphSpan2").css("width", mailPercent + "px");

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
                    listHTML2 += "<li class="+readClass+" onclick='open_mail2(&#39;" + result.MailServerURL2 +"&#39;,&#39;" + href + "&#39;)'>";
                    listHTML2 += "<span class='txt'>"+ MakeXMLString(subject) +"</span>";
                    listHTML2 += "<span class='date'>"+MakeXMLString(receivedDateStr).replace(/-/g, ".")+"</span>";
                    listHTML2 += "<span class='name'>"+MakeXMLString(sender)+"</span>";
                    listHTML2 += "</li>";
                }
            }

            document.getElementById("MailList2").innerHTML = listHTML2;
            resetPortletPaging(portletId, totalCount, pageNum, "");
		},
		error:function(request,status,error){
    	    console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	   }
	});
}

function open_mail2(mailServerURL2,url) {
	setTimeout(function(){
		getMailList2(pageNum);
	}, 1000);
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;

    var pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";

	$.ajax({
		type: "GET",
		url: "/ezAuth/getSSORedirectUrl.do",
		data: {
			redirectDomain:mailServerURL2,
			redirectResource:pURI
		},
		async: false,
		cache: false,
		success : function(data) {
    		window.open(data, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		},
		error : function(error) {
			console.log(error);
			returnList = null;
		}
	});
}
	
function Mailmore_btnClick2(mailServerURL2) {
	$.ajax({
		type: "GET",
		url: "/ezAuth/getSSORedirectUrl.do",
		data: {
			redirectDomain:mailServerURL2,
			redirectResource:'/ezNewPortal/newPortalMain.do'
		},
		async: false,
		cache: false,
		success : function(data) {
			window.open(data, '_blank');
		},
		error : function(error) {
			console.log(error);
			returnList = null;
		}
	});
}