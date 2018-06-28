var Imageflag = null;
function CanvasInit() {
    var head_div;
    var head_table;
    var element = document.getElementById("SIGNVIEW");

    doc = window.document;
    head_div = doc.createElement("DIV");
    element.appendChild(head_div);
    head_div.width = "100%";

    if (element.style.border == "") {
        element.style.border = "1px inset gray";
        element.style.backgroundColor = "#FFFFFF";
    }
    element.style.overflow = "hidden";
}

function AddImage(Imagesrc) {
    var img;
    var SIGNVIEW = document.getElementById("SIGNVIEW");
    if (Imageflag != null) {
        document.getElementById("SIGNVIEW").innerHTML = "";
    }

    var signWidth = SIGNVIEW.offsetWidth
    var signHeight = SIGNVIEW.offsetHeight
    if (signWidth > signHeight) {
        signHeight = signHeight;
        signWidth = signHeight;
    }
    else {
        signWidth = signWidth;
        sighHeight = signWidth
    }
    pIMG = "<img src='" + window.document.location.protocol + "//" + window.document.location.hostname + "/ezCommon/DownloadAttach.aspx?filePath=" + encodeURI(Imagesrc)
        + "' width=" + signWidth + " height=" + sighHeight + ">";
    SIGNVIEW.innerHTML = pIMG;

    Imageflag = "exist";
}