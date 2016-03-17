function EmbedContentIntoXML(ConValue) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = ConValue;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";

            var result = imgColl.item(i).style.width != "" ? imgColl.item(i).style.width : imgColl.item(i).width;
            if (result.toString().indexOf("px") > -1) result = result.replace("px", "");
            if (result != null) ImgWidth = result;

            var result2 = imgColl.item(i).style.height != "" ? imgColl.item(i).style.height : imgColl.item(i).height;
            if (result2.toString().indexOf("px") > -1) result2 = result2.replace("px", "");
            if (result2 != null) ImgHeight = result2;

            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }

    }
    var BodyHTMLContent = tempDiv.innerHTML;
    return BodyHTMLContent;
}

function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    createNodeAndInsertText(xmlDom, objNode, "HEIGHT", pImgHeight);
    createNodeAndInsertText(xmlDom, objNode, "WIDTH", pImgWidth);
    createNodeAndInsertText(xmlDom, objNode, "TYPE", "2");
    try {
        XmlHttp.open("POST", "/myoffice/Common/ConvertSaveImage.aspx", false);
        XmlHttp.send(xmlDom);
    }
    catch (e) { }
}