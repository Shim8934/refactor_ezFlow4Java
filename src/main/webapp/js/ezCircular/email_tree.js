function get_childXML(url, broot, bcount)
{
    if (navigator.userAgent.indexOf('Trident') == -1) {
        var xmlDOM = createXmlDom();

        var objRoot = xmlDOM.createElement("DATA");
        xmlDOM.appendChild(objRoot);

        var objNode = xmlDOM.createElement("URL");
        objNode.appendChild(xmlDOM.createTextNode(url));
        objRoot.appendChild(objNode);

        var objNode = xmlDOM.createElement("BCOUNT");
        if(bcount)
            objNode.appendChild(xmlDOM.createTextNode("-1"));
        else
            objNode.appendChild(xmlDOM.createTextNode("0"));
        objRoot.appendChild(objNode);

        var xmlHTTP = new XMLHttpRequest();
        xmlHTTP.open("POST", "/ezCircular/getCircularFolderList.do", false);
	    xmlHTTP.send(xmlDOM);

	    if( xmlHTTP.status != 207 && xmlHTTP.status != 200 )
	    {
	        xmlHTTP = null;
	        return '';
	    }
    	
	    return xmlHTTP.responseText;
    }
    else {
        var xmlHTTP = new ActiveXObject("Microsoft.XMLHttp");
        var xmlDOM = new ActiveXObject("Microsoft.XMLDOM");

        var objRoot = xmlDOM.createNode(1, "DATA", "");
        xmlDOM.appendChild(objRoot);

        var objNode = xmlDOM.createNode(1, "URL", "");
        objNode.text = url;
        objRoot.appendChild(objNode);

        var objNode = xmlDOM.createNode(1, "BCOUNT", "");
        objNode.text = bcount;
        objRoot.appendChild(objNode);

        xmlHTTP.open("POST", "/ezCircular/getCircularFolderList.do", false);
	    xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
	    xmlHTTP.send(xmlDOM.xml);

	    if( xmlHTTP.Status != 207 && xmlHTTP.Status != 200 )
	    {
	        xmlHTTP = null;
	        return '';
	    }
    	
	    return xmlHTTP.responseText;
    }
}