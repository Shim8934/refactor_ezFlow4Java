function get_childXML_2010(url, broot, bcount, isFolderManager) {
    get_childXML_2010(url, broot, bcount, isFolderManager, false);
}

function get_childXML_2010(url, broot, bcount, isFolderManager, showAllMail) {
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
        var requestUrl = "";
        var href = url;
        
        if (href.indexOf("shared_mailFolder")== 0){
        	requestUrl = "/ezEmail/getFolderListForShareMailBox.do";
        } else {
        	if(typeof(folderRefreshForSharer) != "undefined" && folderRefreshForSharer == "Y"){
        		requestUrl = "/ezEmail/getFolderListForShareMailBox.do";
        	} else {
        		requestUrl = "/ezEmail/getFolderList.do";
        	}
        }
        
        if (isFolderManager) {
        	requestUrl += "?fm=1";
        } else {
        	requestUrl += "?fm=0";
        }
        
        if (showAllMail) {
            requestUrl += "&am=y";
        } else {
            requestUrl += "&am=n";
        }
        
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		requestUrl += "&shareId=" + encodeURIComponent(shareId);
    	}
       
        if (href.indexOf("shared_mailFolder")== 0 && href != "shared_mailFolder") {
        	requestUrl += "&sharer=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "sharer"));
        	requestUrl += "&userName=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "userName"));
        	requestUrl += "&deptName=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "deptName"));
        }
        
        xmlHTTP.open("POST", requestUrl, false);
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
        
        var requestUrl = "";
        var href = url;
        
        if (href.indexOf("shared_mailFolder")== 0){
        	requestUrl = "/ezEmail/getFolderListForShareMailBox.do";
        } else {
        	requestUrl = "/ezEmail/getFolderList.do";
        }
        
        if (isFolderManager) {
        	requestUrl += "?fm=1";
        } else {
        	requestUrl += "?fm=0";
        }
        
        if (showAllMail) {
            requestUrl += "&am=y";
        } else {
            requestUrl += "&am=n";
        }
        
    	if (typeof(shareId) != "undefined" && shareId != "") {
    		requestUrl += "&shareId=" + encodeURIComponent(shareId);
    	}
    	
        if (href.indexOf("shared_mailFolder")== 0 && href != "shared_mailFolder") {
        	requestUrl += "&sharer=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "sharer"));
        	requestUrl += "&userName=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "userName"));
        	requestUrl += "&deptName=" + encodeURIComponent(window[treeviewStr].getvalue(nodeIdx, "deptName"));
        }
    	
        xmlHTTP.open("POST", requestUrl, false);
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

function get_childXML(url, broot, bcount, isFolderManager) {
    return get_childXML(url, broot, bcount, isFolderManager, false);
}

function get_childXML(url, broot, bcount, isFolderManager, showAllMail)
{
    return get_childXML_2010(url, broot, bcount, isFolderManager, showAllMail);
    
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
						childXML += (DispName[j] + "(" + UnreadNodes.item(i).text + ")");
					else
						childXML += (DispName[j] + "\" ");
			
					childXML += ("foldername=\"" + DispName[j] + "\" ");
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
					childXML += (NameNodes.item(i).text + "(" + UnreadNodes.item(i).text + ")");
				else
					childXML += (NameNodes.item(i).text + "\" ");
			
				childXML += ("foldername=\"" + NameNodes.item(i).text + "\" ");
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

function CreateFolder(url) {
    var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    xmlHttp.Open("MKCOL", url, false);
    xmlHttp.send();
    xmlHttp = null;
}

var treeviewStr = "PostTreeView";
var g_childid = treeviewStr + '_child_';
let getAllSubTree = true; // 트리구조 전체를 가져오는 로직을 호출해야할때
function previewSubTreeCall(isFolderManager) {
	var treePlusElements = $('#' + treeviewStr + ' .tree_plus');
	var element = treePlusElements[0];
	var getSubtree = $(element).attr('name');
	
	if (getSubtree  === undefined) {
		return;
	}
	
	if (getAllSubTree) {
		ShowMailProgress();
		setTimeout(function() {
			while (treePlusElements.length > 0) {
				var firstElement = treePlusElements.eq(0);
				var getSubtree = firstElement.attr('name');
				var idx = getSubtree.split(treeviewStr + '_img_');

				if (typeof idx[1] !== "undefined") {
					
					if (!isFolderManager) {
						var childxml = get_childXML(window[treeviewStr].getvalue(idx[1], "href"), false, true, false);
					} else {
						//편지함 관리일때
						var childxml = get_childXML(window[treeviewStr].getvalue(idx[1], "href"), false, false, true);
					}
					
					window[treeviewStr].putchildxml(idx[1], childxml);
					$('#' + treeviewStr + '_img_' + idx[1]).attr("class", "sub_iconLNB tree_minus");
				}

				treePlusElements = $('#' + treeviewStr + ' .tree_plus');
			}
			getAllSubTree = false;
			HiddenMailProgress();
		}, 5); // 5ms 후에 실행
	} else {
		for (var i = 0; i < treePlusElements.length; i++) {
			var currentElement = treePlusElements.eq(i);
			var currentGetSubtree = currentElement.attr('name');
			var currentIdx = currentGetSubtree.split(treeviewStr + '_img_');

			var currentChildId = g_childid + currentIdx[1];
			document.getElementById(currentChildId).style.display = "block";

			if (document.getElementById(currentGetSubtree).className.indexOf("sub_iconLNB tree_plus") >= 0)
				document.getElementById(currentGetSubtree).className = "sub_iconLNB tree_minus";
			else
				document.getElementById(currentGetSubtree).className = "sub_iconLNB tree_minus";
		}
	}
}

// 접기 기능 추가
function collapseSubTree() {
	var treeMinusElements = $('#' + treeviewStr + ' .tree_minus');

	for (var i = 0; i < treeMinusElements.length ; i++) {
		var element = treeMinusElements[i];
		var getSubtree = $(element).attr('name');
		var idx = getSubtree.split(treeviewStr + '_img_');
		var g_childid = treeviewStr + '_child_';

		if (typeof idx[1] !== "undefined") {
			document.getElementById(g_childid + idx[1]).style.display = "none";
			if (document.getElementById(getSubtree).className.indexOf("sub_iconLNB tree_minus") >= 0)
				document.getElementById(getSubtree).className = "sub_iconLNB tree_plus";
			else
				document.getElementById(getSubtree).className = "sub_iconLNB tree_plus";
		}
	}
}

// 접기와 펼치기를 모두 포함하는 함수
function toggleTreeNode(isFolderManager) {

	var openTree = document.getElementById('toggleTreeNode')
	if (openTree.className.indexOf('on') === -1) {
		previewSubTreeCall(isFolderManager);
		openTree.className = openTree.className.replace('off', 'on');
	} else {
		collapseSubTree();
		openTree.className = openTree.className.replace('on', 'off');
	}

}

function HiddenMailProgress() {
	var mailPanel = document.getElementById("mailPanel");
	if (mailPanel) {
		document.getElementById("mailPanel").style.display="none";
	} else {
		document.getElementById("mailPanel_sub").style.display="none";
	}
	document.getElementById("MailProgress").style.display = "none";
}
function ShowMailProgress() {
	var mailPanel = document.getElementById("mailPanel");
	if (mailPanel) {
		document.getElementById("mailPanel").style.display='';
	} else {
		document.getElementById("mailPanel_sub").style.display='';
	} 
	document.getElementById("MailProgress").style.top = (document.body.clientHeight / 2) + "px";
	document.getElementById("MailProgress").style.width = (document.body.clientWidth) + "px";
	document.getElementById("MailProgress").style.display = '';
}