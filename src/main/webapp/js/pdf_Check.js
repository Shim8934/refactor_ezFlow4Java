function isInstalledAcrobatReader() {
    var displayString;
    var acrobat = new Object();

    acrobat.installed = false;

    if (navigator.plugins && navigator.plugins.length) {
        for (x = 0; x < navigator.plugins.length; x++) {

            if (
                navigator.plugins[x].description.indexOf('Adobe Acrobat') != -1 ||
                navigator.plugins[x].description.indexOf('Adobe PDF') != -1 ||
                navigator.plugins[x].name.indexOf('Chrome PDF Viewer') != -1
            ) {
                acrobat.version = parseFloat(navigator.plugins[x].description.split('Version ')[1]);

                if (acrobat.version.toString().length == 1) acrobat.version += '.0';

                return "OK";
                break;
            }
        }
    }
    else if (window.ActiveXObject) {
        for (x = 2; x < 10; x++) {
            try {
                oAcro = eval("new ActiveXObject('PDF.PdfCtrl." + x + "');");
                if (oAcro) {
                    return "OK";
                }
            }
            catch (e) { }
        }

        try {
            oAcro4 = new ActiveXObject('PDF.PdfCtrl.1');
            if (oAcro4) {
                return "OK";
            }
        }
        catch (e) { }

        try {
            oAcro7 = new ActiveXObject('AcroPDF.PDF.1');
            if (oAcro7) {
                return "OK";
            }
        }
        catch (e) { }
    }

    return acrobat.installed;
}