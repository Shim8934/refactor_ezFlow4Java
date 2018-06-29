var writeboardselect_modal_dialogArguments = new Array();
function CircularWrite_onclick() {
	var feature = GetOpenPosition(820, 900);
	url = "/ezCircular/circularWrite.do?mode=write";
	var OpenWin = window.open(url, "", "width=820, height=900, status=no, toolbar=no, menubar=no,location=no,resizable=1" + feature);
    OpenWin.focus();     
}