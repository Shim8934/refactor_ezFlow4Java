/**
 * 
 */
var mailPercent = $('#mailPercent').val();

function open_mail(url) {
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
    newwin.focus();
    getMailGraph();
}
	
function Mailmore_btnClick() {
    window.open("/ezEmail/mailMain.do", "main");
}