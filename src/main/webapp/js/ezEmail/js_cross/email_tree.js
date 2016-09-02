function get_childXML_2010(url, broot, bcount) {
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
        xmlHTTP.open("POST", "/ezEmail/getFolderList.do", false);
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

        xmlHTTP.open("POST", "/ezEmail/getFolderList.do", false);
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

function get_childXML(url, broot, bcount)
{
    return get_childXML_2010(url, broot, bcount);
    
	var strXML = "<?xml version='1.0'?>" + 
					"<d:searchrequest xmlns:d='DAV:'>" +
					"<d:sql>" +
					"Select \"DAV:displayname\", \"DAV:href\", \"DAV:hassubs\", " +
					"\"urn:schemas:httpmail:unreadcount\" " +
					"From scope('Shallow traversal of \"" + url + "\"')" +
					"Where \"DAV:isfolder\" = True And " +
					"\"DAV:ishidden\" = False " +
					"Order By \"DAV:displayname\"" +
					"</d:sql>" +
					"</d:searchrequest>";
		     
		     
	var xmlHTTP = new ActiveXObject("Microsoft.XMLHttp");
	xmlHTTP.open("SEARCH", url, false);
	xmlHTTP.setRequestHeader("Content-Type", "text/xml; charset=utf-8");		
	xmlHTTP.send(strXML);
	
	if( xmlHTTP.Status == 207 || xmlHTTP.Status == 200 )
	{
		var NameNodes = xmlHTTP.responseXML.selectNodes("a:multistatus/a:response/a:propstat/a:prop/a:displayname");
		var HrefNodes = xmlHTTP.responseXML.selectNodes("a:multistatus/a:response/a:propstat/a:prop/a:href");
		var HasSubNodes = xmlHTTP.responseXML.selectNodes("a:multistatus/a:response/a:propstat/a:prop/a:hassubs");
		var UnreadNodes = xmlHTTP.responseXML.selectNodes("a:multistatus/a:response/a:propstat/a:prop/d:unreadcount");
		xmlHTTP = null;
        
		var childXML = "";

		if (broot)
		{
		    if(lang != "3")
		    {
			    var FolderNameKo = new Array( strLang63 ,  strLang64 ,  strLang65 ,  strLang66 ,  strLang67 );
			    var FolderNameEn = new Array("Inbox", "Sent Items", "Drafts", "Deleted Items", "PERSONAL");
			    var DispName = new Array(strLang68, strLang69, strLang70, strLang4, strLang71);
			}
			else
			{
			    var FolderNameKo = new Array( strLang63, strLang65,  strLang64 ,  strLang66 ,  strLang67 );
			    var FolderNameEn = new Array("Inbox", "Drafts", "Sent Items", "Deleted Items", "PERSONAL");
			    var DispName = new Array(strLang68, strLang70, strLang69, strLang4, strLang71);
			}
			
			var PersonalExist = false;

			for (var j=0; j<5; j++)
				for (var i=0; i<NameNodes.length; i++)
				{
					if (NameNodes.item(i).text != FolderNameKo[j] && NameNodes.item(i).text != FolderNameEn[j])
						continue;
					
					if (NameNodes.item(i).text == "PERSONAL")
						PersonalExist = true;
					
					if (NameNodes.item(i).text ==  strLang67)
						PersonalExist = true;
					

					childXML += "<node imgidx='1' caption=\"";
					if (UnreadNodes.item(i).text != "0" && bcount)
						childXML += (MakeRightField(DispName[j]) + "(" + UnreadNodes.item(i).text + ")");
					else
						childXML += (MakeRightField(DispName[j]) + "\" ");
			
					childXML += ("foldername=\"" + MakeRightField(DispName[j]) + "\" ");
					childXML += ("href='" + HrefNodes.item(i).text + "' ");
					if (HasSubNodes.item(i).text == "1")
						childXML += "hassub='1' ";
		
					childXML += "/>";
					break;
				}

			if (!PersonalExist)
			{
				CreateFolder(url + "/PERSONAL");
				childXML += "<node imgidx='1' caption='" + strLang71 + "' href='" + url + "/PERSONAL" + "' />"
			}
		}
		else
			for (var i=0; i<NameNodes.length; i++)
			{
				childXML += "<node imgidx='1' caption=\"";
				if (UnreadNodes.item(i).text != "0" && bcount)
					childXML += (MakeRightField(NameNodes.item(i).text) + "(" + UnreadNodes.item(i).text + ")");
				else
					childXML += (MakeRightField(NameNodes.item(i).text) + "\" ");
			
				childXML += ("foldername=\"" + MakeRightField(NameNodes.item(i).text) + "\" ");
				childXML += ("href='" + HrefNodes.item(i).text + "' ");
				if (HasSubNodes.item(i).text == "1")
					childXML += "hassub='1' ";
	
				childXML += "/>";
			}

		return childXML;
	}
	else
	{
		xmlHTTP = null;
		return "";
	}
}

function MakeRightField(orgStr)
{
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "&amp;"), "\"", "&quot;"), "<", "&lt;"), ">", "&gt;");
}

function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	
	return ( orgStr.replace( re, replaceStr ) );
}

function CreateFolder(url) {
    var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    xmlHttp.Open("MKCOL", url, false);
    xmlHttp.send();
    xmlHttp = null;
}

