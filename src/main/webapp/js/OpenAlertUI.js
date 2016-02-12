function OpenAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "ezAPRALERT.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}