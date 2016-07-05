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

            var result = imgColl.item(i).style.width != "" ? imgColl.item(i).style.height : imgColl.item(i).height;
            if (result.toString().indexOf("px") > -1) result = result.replace("px", "");
            if (result != null) ImgHeight = result;

            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }

    }
    var BodyHTMLContent = HTMLtoMHT_MakeTag(tempDiv);
    return BodyHTMLContent;
}

function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
	$.ajax({
		url : "/ezCommon/convertSaveImage.do",
		type : "POST",
		async : false,
		data : {
			"url" : pUrl,
			"height" : pImgHeight,
			"width" : pImgWidth,
			"type" : 2
		}
	});
}