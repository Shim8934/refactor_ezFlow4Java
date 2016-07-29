var AddressTreeHttp;
function get_Address_childXML(parentid, ownerid, foldertype)
{
    var strXML = "<DATA><PARENTID>" + parentid + "</PARENTID><OWNERID>" + ownerid + "</OWNERID><FOLDERTYPE>" + foldertype + "</FOLDERTYPE></DATA>";
    AddressTreeHttp = createXMLHttpRequest();
    
    /*if(foldertype=="P")
    	AddressTreeHttp.open("POST", "/myoffice/ezAddress/RemoteEWS/address_get_childtree.aspx", false);
	else
    	AddressTreeHttp.open("POST", "/myoffice/ezAddress/remote/address_get_subtree.aspx", false);*/
    AddressTreeHttp.open("POST", "/ezAddress/addressGetSubTree.do", false);
    
    AddressTreeHttp.send(strXML);
    if (AddressTreeHttp.status == 200) {
        /*if (foldertype == "P") {
            var IDNodes = AddressTreeHttp.responseXML.getElementsByTagName("FOLDERID");
            var ChangeKeyNodes = AddressTreeHttp.responseXML.getElementsByTagName("CHANGEKEY");
            var OwnerNodes = AddressTreeHttp.responseXML.getElementsByTagName("OWNERID");
            var TypeNodes = AddressTreeHttp.responseXML.getElementsByTagName("FOLDERTYPE");
            var NameNodes = AddressTreeHttp.responseXML.getElementsByTagName("FOLDERNAME");
            var ChildNodes = AddressTreeHttp.responseXML.getElementsByTagName("CHILDCOUNT");
            var parentfolderid = parentid;
            AddressTreeHttp = null;
            var childXML = "";
            for (var i = 0; i < OwnerNodes.length; i++) {
                childXML += "<node imgidx='1' caption=\"";
                childXML += (MakeRightField(NameNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("ownerid=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("type=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("folderid=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("changekey=\"" + MakeRightField(ChangeKeyNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("parentfolderid=\"" + MakeRightField(parentfolderid) + "\" ");
                if (ChildNodes[i].firstChild.nodeValue != "0")
                    childXML += "hassub='1' ";

                childXML += "></node>";
            }
            return childXML;
        }
        else {*/
            var IDNodes = AddressTreeHttp.responseXML.getElementsByTagName("FOLDERID");
            var OwnerNodes = AddressTreeHttp.responseXML.getElementsByTagName("OWNERID");
            var TypeNodes = AddressTreeHttp.responseXML.getElementsByTagName("FOLDERTYPE");
            var NameNodes = AddressTreeHttp.responseXML.getElementsByTagName("FOLDERNAME");
            var ChildNodes = AddressTreeHttp.responseXML.getElementsByTagName("CHILDCOUNT");
            AddressTreeHttp = null;

            var childXML = "";

            for (var i = 0; i < NameNodes.length; i++) {
                childXML += "<node imgidx='1' caption=\"";
                childXML += (MakeRightField(NameNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("ownerid=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("type=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
                childXML += ("folderid=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
                if (ChildNodes[i].firstChild.nodeValue != "0")
                    childXML += "hassub='1' ";

                childXML += "></node>";
            }

            return childXML;
        /*}*/
    }
    else {
        AddressTreeHttp = null;
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
