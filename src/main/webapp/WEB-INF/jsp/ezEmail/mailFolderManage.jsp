<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezEmail.t455' /></title>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
        
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var lang = "${userinfo.lang}";
			var PostTreeView = null;
			var treeconfig = "";
			var EventCheck = false;
			var CurrentHeight = 0;
			var CurrenWidth = 0;
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    window.onunload = function () {
		        if(ReturnFunction != null)
			        ReturnFunction(EventCheck);
			}
			var ReturnFunction;
			window.onload = function () {
			    CurrentHeight = document.body.clientHeight;
			    CurrenWidth = document.body.clientWidth;
			    try {
			        ReturnFunction = opener.mail_foldermanage_Cross_dialogArguments[1];
			    } catch (e) { }
                PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
                PostTreeView.attachEvent('requestdata', requestdata);
                PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
                var xmlHTTP = createXMLHttpRequest();
                xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
                xmlHTTP.send();
                var treeconfig;
                if (navigator.userAgent.indexOf('MSIE') == -1) {
                    treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
                }
                else
                    treeconfig = xmlHTTP.responseXML;

                PostTreeView.config(treeconfig);
                PostTreeView.source("<tree><nodes>" + get_childXML("", true, false) + "</nodes></tree>");
                PostTreeView.update();
                if (PostTreeView.selectedIndex() == -1) {
                    PostTreeView.select(5);
                }
            }
            function requestdata(event) {
                if (!event) event = window.event;
                var nodeIdx = event.nodeIdx;
                if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                    nodeIdx = arguments[0].nodeIdx;
                }
                var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false)
                PostTreeView.putchildxml(nodeIdx, childxml);
            }
            var inputNameDlg_cross_dialogArguments = new Array();
            function add_onclick() {
                if (PostTreeView.selectedIndex() == -1) {
                    alert("<spring:message code='ezEmail.t158' />");
                    return;
                }
                inputNameDlg_cross_dialogArguments[0] = "";
                inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
                inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
                DivPopUpShow(330, 150, "/ezEmail/inputNameDlg.do");
            }
		    function add_onclick_Complete(szName) {
		        DivPopUpHidden();
		        if (checkBadFolderName(szName))
		            return;

		        var szURL = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
		        var result = make_folder_2010(szURL, szName);
		        if (result != true) {
		            if (result == 405)
		                alert("<spring:message code='ezEmail.t456' />");
		             else
		                alert("<spring:message code='ezEmail.t457' />");
		            return;
		        }
		        var childXML = "<node imgidx='1' caption='" + MakeRightField(szName) + "' ";
		        childXML += ("href='" + szURL + "' ");
		        childXML += "></node>";
		        var childxml = get_childXML(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), false, false)
		        PostTreeView.putchildxml(PostTreeView.selectedIndex(), childxml);
		        EventCheck = true;
		    }
		    function LoadAddressTree(idx) {
		        PostTreeView.config(treeconfig);
		        PostTreeView.source("<tree><nodes>" + get_childXML("", true, false) + "</nodes></tree>");
		        PostTreeView.update();
		        PostTreeView.toggle(idx);
		    }
		    function modify_onclick() {
		        if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		        else if (PostTreeView.selectedIndex() < 6) {
		            alert("<spring:message code='ezEmail.t458' />");
		            return;
		        }
		        inputNameDlg_cross_dialogArguments[0] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption");
		        inputNameDlg_cross_dialogArguments[1] = modify_onclick_Complete;
		        inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
		        DivPopUpShow(330, 150,"/ezEmail/inputNameDlg.do");
		    }
		    function modify_onclick_Complete(szName) {
		        DivPopUpHidden();
		        if (typeof (szName) == "undefined" || ReplaceText(szName, " ", "") == "" || szName == PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption"))
		            return;
		        if (checkBadFolderName(szName))
		            return;

		        var orgURL = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href")
		        var szURL = CutAfterText(CutAfterText(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), "/"), "/");
		        var result = Modify_folder_2010(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), szName);
		        if (result != true) {
		            if (result == 412 || result == 500)
		                alert("<spring:message code='ezEmail.t459' />");

		            return;
		        }
		        PostTreeView.putcaption(PostTreeView.selectedIndex(), szName);
		        PostTreeView.putvalue(PostTreeView.selectedIndex(), "href", orgURL);
		        PostTreeView.putvalue(PostTreeView.selectedIndex(), "caption", szName);
		        EventCheck = true;
		    }
		    function CheckRootFolder(currentnode) {
		        if (currentnode.parentNode.parentNode.parentNode.parentNode.id == "PostTreeView")
		            return true;
		        else
		            return false;
		    }
		    function delete_onclick() {
		        if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		        if (CheckRootFolder(PostTreeView.selectedNode())) {
		            alert("<spring:message code='ezEmail.t460' />");
		            return;
		        }
		        var deleteURL = "${pDeleteBoxID }";
		        var deleteboxname = "${pDeleteBoxName}";
		        if(gettopvalue(PostTreeView.selectedNode(), 'href') == deleteURL){
		            if (confirm("<spring:message code='ezEmail.t461' />")) {
		                if (delete_folder(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href")) != true) {
		                    alert("<spring:message code='ezEmail.t462' />");
		                    return;
		                }
		                PostTreeView.deletenode(PostTreeView.selectedIndex());
		                EventCheck = true;
		            }
		        }
		        else {
		            if (confirm("<spring:message code='ezEmail.t463' />")) {
		                var szName = PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption");
		                var szURL = deleteURL;
		                var result = move_folder(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), szURL);
		                if (result != true) {
		                    if (result == 412 || result == 500)		                        
		                        alert("<spring:message code='ezEmail.t464' />");
		                    return;
		                }
		                var haschild = PostTreeView.haschild(PostTreeView.selectedIndex());
		                var childXML = "<node imgidx='1' caption='" + szName + "' ";
		                childXML += ("href='" + szURL + "/' ");
		                if (haschild)
		                    childXML += "hassub='1' />";
		                else
		                    childXML += "/>";

		                PostTreeView.deletenode(PostTreeView.selectedIndex());
		                EventCheck = true;
		            }
		        }
		    }
		    var mail_movecopy_cross_dialogArguments = new Array();
		    function move_onclick() {
		        if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		        if (getparentnode(PostTreeView.selectedNode()) == null) {
		            alert("<spring:message code='ezEmail.t465' />");
		            return;
		        }
		        mail_movecopy_cross_dialogArguments[1] = move_onclick_Complete;
		        mail_movecopy_cross_dialogArguments[2] = DivPopUpHidden;
		        DivPopUpShow(320, 375,"/ezEmail/mailMoveCopy.do");
		    }
		    function move_onclick_Complete(moveUrl) {
		        DivPopUpHidden();
		        if (typeof (moveUrl) == "undefined")
		            return;

		        var szName = PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption");
		        var szURL = moveUrl["url"];

		        if (moveUrl["url"] == PostTreeView.getvalue(PostTreeView.selectedIndex(), "href")) {
		            alert("<spring:message code='ezEmail.t466' />");
		            return;
		        }
		        var oldurl = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
		        oldurl = oldurl.substring(0, oldurl.length - 1);
		        oldurl = oldurl.substring(0, oldurl.lastIndexOf("/") + 1);

		        if (szURL == oldurl) {
		            alert("<spring:message code='ezEmail.t467' />");
		            return;
		        }
		        if (moveUrl["cmd"] == "MOVE") {
		            var result = move_folder(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), szURL);
		            if (result != true) {
		                if (result == 412 || result == 500)		                    
		                    alert("<spring:message code='ezEmail.t468' />");
		                return;
		            }

		            var childXML = "<node imgidx='1' caption='" + szName + "' ";
		            childXML += ("href='" + szURL + "/' ");
		            childXML += "/>";
		            PostTreeView.deletenode(PostTreeView.selectedIndex());
		            var nodeIdx = PostTreeView.findindex("href", moveUrl["url"]);
		            PostTreeView.addnode(nodeIdx, childXML);
		        }
		        else if (moveUrl["cmd"] == "COPY") {
		            var result = copy_folder(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), szURL);
		            if (result != true) {
		                if (result == 412 || result == 500)
		                    alert("<spring:message code='ezEmail.t469' />");
		                return;
		            }
		            var childXML = "<node imgidx='1' caption='" + szName + "' ";
		            childXML += ("href='" + szURL + "/' ");
		            childXML += "/>";
		            var nodeIdx = PostTreeView.findindex("href", moveUrl["url"]);
		            PostTreeView.addnode(nodeIdx, childXML);
		        }
		        LoadAddressTree(moveUrl["idx"]);
		        EventCheck = true;
		    }
		    function delete_mail_onclick() {
		        if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		        var deleteURL = "${pDeleteBoxID}";
		        var deleteboxname = "${pDeleteBoxName}";
		        if (PostTreeView.getvalue(PostTreeView.selectedIndex(), 'href') == deleteURL) {
		            if (confirm("<spring:message code='ezEmail.t470' />")) {
		                delete_mail_2010(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), true, "");
		            }
		        }
		        else {
		            if (confirm("<spring:message code='ezEmail.t475' />")) {
		                delete_mail_2010(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), false, deleteURL);
		            }
		        }
		    }

		    var xmlHTTP2;
		    var tmpURL;
		    function delete_mail_2010(szURL, bDelete, DestURL) {
		        xmlHTTP2 = createXMLHttpRequest();
		        tmpURL = DestURL;
		        var xmlDOM = createXmlDom();
		        var objNode;
		        var deltype = "";
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", szURL);
		        if (bDelete)
		            deltype = "MAILREALDEL";
		        else
		            deltype = "MAILDEL";

		        createNodeAndInsertText(xmlDOM, objNode, "CMD", deltype);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", DestURL);
		        xmlHTTP2.open("POST", "/ezEmail/mailMakeFolder.do", true);
		        xmlHTTP2.onreadystatechange = delete_mail_2010_complete;
		        xmlHTTP2.send(xmlDOM);
		        ShowMailProgress();
		    }

		    function delete_mail_2010_complete() {
		        if (xmlHTTP2 != null && xmlHTTP2.readyState == 4) {
		            HiddenMailProgress();
		            if (tmpURL == "") {
		                if (xmlHTTP2.status == 100)
		                    alert("<spring:message code='ezEmail.t471' />");
		                else if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300)
		                    alert("<spring:message code='ezEmail.t473' />");
		                else
		                    alert("<spring:message code='ezEmail.t472' />");
		            }
		            else {
		                if (xmlHTTP2.status == 100)
		                    alert("<spring:message code='ezEmail.t476' />");
		                else if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300)
		                    alert("<spring:message code='ezEmail.t478' />");
		                else
		                    alert("<spring:message code='ezEmail.t477' />");
		            }
		        }
		    }

			function checkBadFolderName(szName) 
			{
				var szBadChars = /[\<\>\~\#\%\&\*\+\|\\\.\/]/g;
				var szChangedName = szName.replace(szBadChars, "");
				if(szChangedName != szName)
				{
					alert("<spring:message code='ezEmail.t479' />< ~ # % & * + | \\ . / >)<spring:message code='ezEmail.t480' />");
					return true;
				}
				return false;
			}
			
		    function make_folder_2010(szURL, szName) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "NAME", szName);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", "NEW");
		        xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
		        xmlHTTP.send(xmlDOM);
		        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
		            return true;
		        else
		            return xmlHTTP.status;
		    }
		    function move_folder_2010(szOriURL, szURL) {

		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szOriURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", "MOVE");
		        xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
		        xmlHTTP.send(xmlDOM);

		        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
		            return true;
		        else
		            return xmlHTTP.status;
		    }
		    function move_folder(szOriURL, szURL) {
		        return move_folder_2010(szOriURL, szURL);
		    }
		    function copy_folder_2010(szOriURL, szURL) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szOriURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", "COPY");
		        xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
		        xmlHTTP.send(xmlDOM);

		        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
		            return true;
		        else
		            return xmlHTTP.status;
		    }
			
		    function copy_folder(szOriURL, szURL) {
		        return copy_folder_2010(szOriURL, szURL);
		    }
		    function delete_folder_2010(szURL) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", "DEL");
		        xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
		        xmlHTTP.send(xmlDOM);

		        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
		            return true;
		        else
		            return xmlHTTP.status;
		    }

			function delete_folder(szURL)
			{
			    return delete_folder_2010(szURL);
			}

			//function delete_mail(szURL, bDelete, DestURL) {
			//    return delete_mail_2010(szURL, bDelete, DestURL);
			//}
            		
			function Modify_folder_2010(szOriURL, szURL) {
			    var xmlHTTP = createXMLHttpRequest();
			    var xmlDOM = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlDOM, objNode, "DATA");
			    createNodeAndInsertText(xmlDOM, objNode, "URL", szOriURL);
			    createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", szURL);
			    createNodeAndInsertText(xmlDOM, objNode, "CMD", "MODIFY");
			    xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
			    xmlHTTP.send(xmlDOM);
			    if (xmlHTTP.status >= 200 && xmlHTTP.status < 300)
			        return true;
			    else
			        return xmlHTTP.status;
			}
			function getparentnode(currentnode) {
			    var tmpnode = currentnode.parentNode.parentNode.parentNode.parentNode.previousSibling;
			    if (tmpnode == null) return null;

			    var parentnode = tmpnode.lastChild;
			    return parentnode;
			}
			function getnodeidx(currentnode) {
			    var nodeidval = currentnode.attributes.getNamedItem('id').nodeValue;
			    var nodeidvalsubstrstart = nodeidval.lastIndexOf('_') + 1;
			    var nodeidvalsubstrend = nodeidval.length;
			    var nodeidx = parseInt(nodeidval.substring(nodeidvalsubstrstart, nodeidvalsubstrend), 10);
			    return nodeidx;
			}
			function gettopvalue(currentnode, attrname) {

			    if (!CheckRootFolder(currentnode)) {
			        var parentnode = getparentnode(currentnode);
			        if (CheckRootFolder(parentnode)) {
			            return PostTreeView.getvalue(getnodeidx(parentnode), attrname);
			        }
			        else {
			            return gettopvalue(parentnode, attrname);
			        }

			    }
			    else
			        return PostTreeView.getvalue(getnodeidx(currentnode), attrname);
			}
			function HiddenMailProgress() {
			    document.getElementById("mailPanel").style.display = "none";
			    document.getElementById("MailProgress").style.display = "none";
			}
			function ShowMailProgress() {
			    //document.getElementById("mailPanel").style.display = "";
			    document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("MailProgress").style.display = "";
			}
        </script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1 style="margin-bottom:0px;"><spring:message code='ezEmail.t481' /></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.close()"><spring:message code='ezEmail.t63' /></span></li>
		  </ul>
		</div>
		<div style="margin-bottom:5px;">
		    <a class="imgbtn"><span onClick="add_onclick()" style="width:40px;text-align:center;"><spring:message code='ezEmail.t308' /></span></a>
		    <a class="imgbtn"><span onClick="modify_onclick()" style="width:40px;text-align:center;"><spring:message code='ezEmail.t149' /></span></a>
		    <a class="imgbtn"><span onClick="delete_onclick()" style="text-align:center;"><spring:message code='ezEmail.t95' /></span></a>
		    <a class="imgbtn"><span onClick="move_onclick()" style="width:70px;text-align:center;"><spring:message code='ezEmail.t482' /></span></a>
		    <a class="imgbtn"><span onClick="delete_mail_onclick()" style="width:70px;text-align:center;"><spring:message code='ezEmail.t483' /></span></a>
		</div>
		<table class="popuplist" style="width:100%">
		  <tr>
		    <td>
		        <div style="height:400px;width:100%;overflow-x:auto;overflow-y:auto;background-color:#FFFFFF;padding-left:2px;padding-top:5px;" id="PostTreeView">
				</div>
		    </td>
		  </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>



