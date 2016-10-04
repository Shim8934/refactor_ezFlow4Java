<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezAddress.t266' /></title>
	    <link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="/css/email_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/ezAddress/address_tree_Cross.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezAddress/Controls/treeview.htc.js"></script>
	    <script>
	        var checkadmin = "${checkAdmin}";
	        var deptadmin = "${deptAdmin}";
	        var companyadmin = "${companyAdmin}";
	        var ReturnFunction;
	        var CancelFunction;
	        var isDivPopup = false;
	        window.onload = function () {
	            try {
	                ReturnFunction = parent.address_movecopy_dialogArguments[1];
	                CancelFunction = parent.address_movecopy_dialogArguments[2];
	                isDivPopup = true;
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.address_movecopy_dialogArguments[1];
	                    CancelFunction = opener.address_movecopy_dialogArguments[2];
	                } catch (e) { }
	            }
	            var AddressTreeView = new TreeView('AddressTreeView', 'AddressTreeView');
	            AddressTreeView.attachEvent('requestdata', requestdata);
	            AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	
	            var treeconfig;
	            if (navigator.userAgent.indexOf('MSIE') == -1) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else {
	                treeconfig = new ActiveXObject("Microsoft.XMLDOM");
	                treeconfig.async = false;
	                treeconfig.loadXML(xmlHTTP.responseText);
	            }
	            AddressTreeView.config(treeconfig);
	            AddressTreeView.source(document.getElementById("AddressFolderXML").innerHTML);
	            AddressTreeView.update();
	            if (AddressTreeView.selectedIndex() == -1) {
	                AddressTreeView.select(1);
	            }
	        }
	        function requestdata(event) {
	            if (!event) {
	                event = window.event;
	            }
	            var nodeIdx = event.nodeIdx;
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
	            AddressTreeView.putchildxml(nodeIdx, childxml);
	        }
	        function btn_Copy_onclick() {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            if (nodeIdx == -1) {
	                alert("<spring:message code='ezAddress.t267' />");
		        return;
		    }
	        if (AddressTreeView.getvalue(nodeIdx, "type") == "D" && deptadmin != "Y") {
	            alert("<spring:message code='ezAddress.t168' />");
		        return;
		    }
	        if (AddressTreeView.getvalue(nodeIdx, "type") == "C" && companyadmin != "Y") {
	            alert("<spring:message code='ezAddress.t169' />");
		        return;
		    }
	        var retVal = new Array();
	        retVal["cmd"] = "COPY";
	        retVal["folderid"] = AddressTreeView.getvalue(nodeIdx, "folderid");
	        retVal["foldertype"] = AddressTreeView.getvalue(nodeIdx, "type");
	        retVal["ownerid"] = AddressTreeView.getvalue(nodeIdx, "ownerid");
	        if (ReturnFunction!=null) {
	            ReturnFunction(retVal);
	            if (!isDivPopup)
	                window.close();
	        }
	        else {
	            window.returnValue = retVal;
	            window.close();
	        }
	    }
	    function btn_Move_onclick() {
	        var nodeIdx = AddressTreeView.selectedIndex();
	        if (nodeIdx == -1) {
	            alert("<spring:message code='ezAddress.t268' />");
		        return;
		    }
	        if (AddressTreeView.getvalue(nodeIdx, "type") == "D" && deptadmin != "Y") {
	            alert("<spring:message code='ezAddress.t168' />");
		        return;
		    }
	        if (AddressTreeView.getvalue(nodeIdx, "type") == "C" && companyadmin != "Y") {
	            alert("<spring:message code='ezAddress.t169' />");
		        return;
		    }
	        var retVal = new Array();
	        retVal["cmd"] = "MOVE";
	        retVal["folderid"] = AddressTreeView.getvalue(nodeIdx, "folderid");
	        retVal["foldertype"] = AddressTreeView.getvalue(nodeIdx, "type");
	        retVal["ownerid"] = AddressTreeView.getvalue(nodeIdx, "ownerid");
	        if (ReturnFunction != null) {
	            ReturnFunction(retVal);
	            if (!isDivPopup)
	                window.close();
	        }
	        else {
	            window.returnValue = retVal;
	            window.close();
	        }
	    }
	    function Window_Close() {
	        if (ReturnFunction != null) {
	            if (!isDivPopup)
	                window.close();
	            else
	                CancelFunction();
	        }
	        else
	            window.close();
	    }
	    </script>
	</head>
	<body class="popup" style="overflow: hidden">
	
	    <h1><spring:message code='ezAddress.t269' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="Window_Close()"><spring:message code='ezAddress.t5' /></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	    <div style="margin-top: -5px; margin-bottom: 5px;">
	        <a class="imgbtn"><span onclick="return btn_Move_onclick()"><spring:message code='ezAddress.t270' /></span></a>
	        <a class="imgbtn"><span onclick="return btn_Copy_onclick()"><spring:message code='ezAddress.t271' /></span></a>
	    </div>
	    <table class="content" style="width: 100%;">
	        <tr>
	            <td class="pos1" style="padding-right: 0">
	                <div class="tree" style="border: 0; margin-left: 5px; width: 98%; height: 270px; overflow: auto" id="AddressTreeView"></div>
	            </td>
	        </tr>
	    </table>
	    <xml id="AddressFolderXML" style="display: none;">
			${rootAddressXML}
		</xml>
	</body>
</html>

