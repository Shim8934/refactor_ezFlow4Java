﻿﻿function TreeView(thisobjid, elobjid) {
    window[thisobjid] = this;
    var thisid = thisobjid;
    var element = document.getElementById(elobjid);
    this.attachEvent = function (eventname, eventhandler) {
        this['on' + eventname] = eventhandler;
    }

    this.config = function (a) {
        if (!a) {
            return;
        }
        return put_config.call(this, a);
    };
    function put_config(configXML) {
        g_configXML = configXML;
    }

    this.source = function (a) {
        if (!a) {
            return;
        }
        return put_source.call(this, a);
    };
    function put_source(sourceXML) {
        if (typeof (sourceXML) == "object") {
            g_treeXML = sourceXML;
            return;
        }
        g_treeXML = loadXMLString(sourceXML);
    }

    this.selectedIndex = function (a) {
        if (!a) {
            return get_selectedIndex.call(this);
        }
        return;
    };
    function get_selectedIndex() {
        return g_selectedIdx;
    }

    this.selectedNode = function (a) {
        if (!a) {
            return get_selectedNode.call(this);
        }
        return;
    };
    function get_selectedNode() {
        return g_selectedNode;
    }

    this.dragdrop = function (a) {
        if (!a) {
            return;
        }
        return put_dragdrop.call(this, a);
    };
    function put_dragdrop(bdragdrop) {
        g_bdragdrop = bdragdrop;
    }

    this.nodecount = function (a) {
        if (!a) {
            return get_nodecount.call(this);
        }
        return;
    };
    function get_nodecount() {
        return g_nodeCount;
    }


    this.update = ex_update;
    function ex_update() {
        if (g_treeXML == null)
            return;

        g_nodeCount = 0;
        g_selectedIdx = -1;

        set_initvalue();

        var SPAN = document.createElement("SPAN");
        SPAN.appendChild(make_childHtml(0));
        element.innerHTML = "";
        element.appendChild(SPAN);
    }

    this.toggle = ex_toggle;
    function ex_toggle(nodeIdx) {
        if (nodeIdx > g_nodeCount || nodeIdx < 1)
            return;
        
       /* if (document.getElementById(g_toggleid + nodeIdx).className.indexOf(g_baseImage["plus_normal"]) == -1 &&
                document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["minus_normal"]) == -1 &&
                document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["plus_end"]) == -1 &&
                document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["minus_end"]) == -1)
                return;*/
        if (document.getElementById(g_toggleid + nodeIdx)) {
	        if (document.getElementById(g_childid + nodeIdx).style.display == "none") {
	            document.getElementById(g_childid + nodeIdx).style.display = "block";
	            if (document.getElementById(g_toggleid + nodeIdx).className.indexOf("sub_iconLNB tree_plus") >= 0)
	                document.getElementById(g_toggleid + nodeIdx).className = "sub_iconLNB tree_minus";
	            else
	            	document.getElementById(g_toggleid + nodeIdx).className = "sub_iconLNB tree_minus";
	
	            if (document.getElementById(g_childid + nodeIdx).innerHTML == "") {
	                if (g_nodeArray["nodeXML"][nodeIdx].childNodes.length == 0) {
	                    var oEvent = {};
	                    oEvent.nodeIdx = nodeIdx;
	                    window[thisid].onrequestdata(oEvent);
	                }
	                else {
	                    document.getElementById(g_childid + nodeIdx).appendChild(make_childHtml(nodeIdx));
	                }
	            }
	        }
	        else {
	            document.getElementById(g_childid + nodeIdx).style.display = "none";
	            if (document.getElementById(g_toggleid + nodeIdx).className.indexOf("sub_iconLNB tree_minus") >= 0)
	            	document.getElementById(g_toggleid + nodeIdx).className = "sub_iconLNB tree_plus";
	            else
	            	document.getElementById(g_toggleid + nodeIdx).className = "sub_iconLNB tree_plus";
	        }
        }

        /*if (document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["plus_normal"]) == -1 &&
            document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["minus_normal"]) == -1 &&
            document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["plus_end"]) == -1 &&
            document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["minus_end"]) == -1)
            return;

        if (document.getElementById(g_childid + nodeIdx).style.display == "none") {
            document.getElementById(g_childid + nodeIdx).style.display = "inline-block";
            if (document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["plus_normal"]) >= 0)
                document.getElementById(g_toggleid + nodeIdx).src = g_baseImage["minus_normal"];
            else
                document.getElementById(g_toggleid + nodeIdx).src = g_baseImage["minus_end"];

            if (document.getElementById(g_childid + nodeIdx).innerHTML == "") {
                if (g_nodeArray["nodeXML"][nodeIdx].childNodes.length == 0) {
                    var oEvent = {};
                    oEvent.nodeIdx = nodeIdx;
                    window[thisid].onrequestdata(oEvent);
                }
                else {
                    document.getElementById(g_childid + nodeIdx).appendChild(make_childHtml(nodeIdx));
                }
            }
        }
        else {
            document.getElementById(g_childid + nodeIdx).style.display = "none";
            if (document.getElementById(g_toggleid + nodeIdx).src.indexOf(g_baseImage["minus_normal"]) >= 0)
                document.getElementById(g_toggleid + nodeIdx).src = g_baseImage["plus_normal"];
            else
                document.getElementById(g_toggleid + nodeIdx).src = g_baseImage["plus_end"];
        }*/
    }

    this.getvalue = ex_getvalue;
    function ex_getvalue(nodeIdx, valueName) {
        if (nodeIdx > g_nodeCount || nodeIdx < 1)
            return "";

        if (g_nodeArray["nodeXML"][nodeIdx].attributes.getNamedItem(valueName) == null)
            return "";

        return GetAttribute(g_nodeArray["nodeXML"][nodeIdx], valueName);
    }

    this.putvalue = ex_putvalue;
    function ex_putvalue(nodeIdx, valueName, value) {
        if (nodeIdx > g_nodeCount || nodeIdx < 1)
            return "";

        SetAttribute(g_nodeArray["nodeXML"][nodeIdx], valueName, value);
    }

    this.onnodeselect = function () { };

    this.select = ex_select;
    function ex_select(nodeIdx, event) {
        if (nodeIdx > g_nodeCount || nodeIdx < 1)
            return;

        if (g_selectedIdx != -1) {
            document.getElementById(g_nodeid + g_selectedIdx).className = g_baseClass["normal"];
        }

        // 2023-06-28 황인경 - 디자인 개선 > 메일 / 주소록 / 회람판 > 좌측메뉴 > 기존에 선택한 span 태그(node_selected) 해제 
    	$(".list_text.node_selected").removeClass("node_selected");
        document.getElementById(g_nodeid + nodeIdx).className = g_baseClass["selected"];
        g_selectedIdx = nodeIdx;
        g_selectedNode = document.getElementById(g_nodeid + nodeIdx);

        window[thisid].onnodeselect(event);
    }

    this.putcaption = ex_putcaption;
    function ex_putcaption(nodeIdx, caption) {
        document.getElementById(g_nodeid + nodeIdx).innerHTML = caption;
    }

    this.putstyle = ex_putstyle;
    function ex_putstyle(nodeIdx, style) {
        document.getElementById(g_nodeid + nodeIdx).style.cssText = style;
    }

    this.putchildxml = ex_putchildxml;
    function ex_putchildxml(nodeIdx, childxml) {
        var toggleel = document.getElementById(g_toggleid + nodeIdx);
        var childel = document.getElementById(g_childid + nodeIdx);
        if (childxml == "") {
            childel.style.display = "none";
            /*if (toggleel.src.indexOf(g_baseImage["minus_normal"]) >= 0)
                toggleel.src = g_baseImage["dot_normal"];
            else
                toggleel.src = g_baseImage["dot_end"];*/
            if (GetAttribute(toggleel, 'class').indexOf("tree_minus") >= 0)
            	toggleel.setAttribute("class", "sub_iconLNB tree_blank");
        }
        else {
            var childXML = loadXMLString("<nodes>" + childxml + "</nodes>");
            var NodeCount = g_nodeArray["nodeXML"][nodeIdx].childNodes.length;
            for (var i = 0; i < NodeCount ; i++)
                g_nodeArray["nodeXML"][nodeIdx].removeChild(g_nodeArray["nodeXML"][nodeIdx].childNodes.item(0));

            var childLength = childXML.documentElement.childNodes.length
            for (var i = 0; i < childLength; i++)
                g_nodeArray["nodeXML"][nodeIdx].appendChild(childXML.documentElement.childNodes.item(0));

            if (childLength) {
                childel.style.display = "block";
                /*if (GetAttribute(toggleel, 'src').indexOf(g_baseImage["dot_normal"]) >= 0)
                    toggleel.setAttribute('src', g_baseImage["minus_normal"]);*/
                if (GetAttribute(toggleel, 'class').indexOf("tree_blank") >= 0){
                	toggleel.setAttribute("class", "sub_iconLNB tree_minus");
                }
                if (childel.id.indexOf("AddressTreeView_child") != -1) {
                	childel.style.width = "100%";
                }
            }

            childXML = null;
            
            while (childel.hasChildNodes()) {
            	childel.removeChild(childel.firstChild);       
            }
            childel.appendChild(make_childHtml(nodeIdx));
        }
    }
    
    this.deletenode = ex_deletenode;
    function ex_deletenode(nodeIdx) {        
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            var node = document.getElementById(g_nodeid + nodeIdx).parentElement.parentElement;
            var children = node.parentElement.children;

            if (children.item(children.length - 1) == node) {
                if (children.length > 1) {
                    var child = children.item(children.length - 2)
                    var depth = g_nodeArray["depth"][nodeIdx].length;
                    var imgnode = child.children.item(0).children.item(depth - 1);

                    /*if (imgnode.src.indexOf(g_baseImage["dot_normal"]) >= 0) {
                        imgnode.src = g_baseImage["dot_end"];
                    }
                    else {
                        if (imgnode.src.indexOf(g_baseImage["plus_normal"]) >= 0)
                            imgnode.src = g_baseImage["plus_end"];
                        else
                            imgnode.src = g_baseImage["minus_end"];

                        changeRecursiveImg(child.children.item(1), true, depth - 1, 0);
                    }*/

                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 1).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depthlist.length - 1) + "0";
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 1).id.split(g_nodeid)[1]] = depthlist;
                    node.parentElement.removeChild(node);

                    imgnode = null;
                    child = null;
                }
                else { // 하위편지함이 하나만 있을 경우
                    var depth = g_nodeArray["depth"][nodeIdx].length;
                    imgnode = node.parentElement.parentElement.parentElement.children.item(0).children.item(depth - 2);
                   /* if (imgnode.src.indexOf(g_baseImage["plus_normal"]) >= 0 || imgnode.src.indexOf(g_baseImage["minus_normal"]) >= 0)
                        imgnode.src = g_baseImage["dot_normal"];
                    else
                        imgnode.src = g_baseImage["dot_end"];*/

                	imgnode.className = "sub_iconLNB tree_blank"; // - 아이콘 없애기
                    node.parentElement.parentElement.style.display = "none";
                    node.parentElement.parentElement.innerHTML = "";

                    imgnode = null;
                }
            }
            else
                node.parentElement.removeChild(node);

            g_nodeArray["nodeXML"][nodeIdx].parentNode.removeChild(g_nodeArray["nodeXML"][nodeIdx]);
            g_nodeArray["nodeXML"][nodeIdx] = null;
            g_nodeArray["depth"][nodeIdx] = "";
            node = null;
            children = null;
            g_selectedIdx = -1;
    }

    this.addnode = ex_addnode;
    function ex_addnode(nodeIdx, nodeXML) {
        if (nodeIdx > g_nodeCount || nodeIdx < 1)
            return "";

        var depth = g_nodeArray["depth"][nodeIdx].length;
        var node = document.all(g_nodeid + nodeIdx)
        var childNodes = document.all(g_nodeid + nodeIdx).parentElement.parentElement.children.item(1);

        if (childNodes.innerHTML == "") {
            var imgnode = node.parentElement.children.item(depth - 1);

            if (imgnode.src.indexOf(g_baseImage["dot_normal"]) >= 0)
                imgnode.src = g_baseImage["plus_normal"];
            else if (imgnode.src.indexOf(g_baseImage["dot_end"]) >= 0)
                imgnode.src = g_baseImage["plus_end"];

            imgnode = null;
        }
        else {
            var childXML = loadXMLString(nodeXML);
            var depth = g_nodeArray["depth"][nodeIdx].length;

            g_nodeCount++;

            var SPAN3 = document.createElement("SPAN");
            if (CrossYN()) {
                SPAN3.style.height = "20px";
                SPAN3.style.overflowY = "hidden";
                SPAN3.style.whiteSpace = "nowrap";
                SPAN3.style.display = "inline-block";
            }
            else {
                SPAN3.style.height = "18px";
                SPAN3.style.overflowY = "hidden";
                SPAN3.style.whiteSpace = "nowrap";
                SPAN3.style.display = "inline-block";
            }

            for (var j = 0; j < depth; j++) {
                var IMG_TAG = document.createElement("IMG");
                if (g_nodeArray["depth"][nodeIdx].charAt(j) == "1") {
                    IMG_TAG.setAttribute("src", g_baseImage["dot_continue"]);
                    IMG_TAG.setAttribute("width", g_imageWidth);
                    IMG_TAG.setAttribute("height", g_imageHeight);
                }
                else {
                    IMG_TAG.setAttribute("src", g_baseImage["space"]);
                    IMG_TAG.setAttribute("width", g_imageWidth);
                    IMG_TAG.setAttribute("height", g_imageHeight);
                }

                SPAN3.appendChild(IMG_TAG);
                IMG_TAG = null;
            }

            var IMG_TAG = document.createElement("IMG");
            if (childXML.documentElement.attributes.getNamedItem("hassub") != null) {
                IMG_TAG.setAttribute("src", g_baseImage["plus_end"]);
            }
            else {
                IMG_TAG.setAttribute("src", g_baseImage["dot_end"]);
            }
            IMG_TAG.setAttribute("id", g_toggleid + g_nodeCount);
            IMG_TAG.setAttribute("name", g_toggleid + g_nodeCount);

            SPAN3.appendChild(IMG_TAG);
            IMG_TAG = null;

            var IMG_TAG = document.createElement("IMG");
            IMG_TAG.setAttribute("id", g_imageid + g_nodeCount);
            IMG_TAG.setAttribute("name", g_imageid + g_nodeCount);
            IMG_TAG.setAttribute("src", "/images/ImgIcon/fldr.gif");

            SPAN3.appendChild(IMG_TAG);
            IMG_TAG = null;

            var SPAN_TAG = document.createElement("SPAN");
            SPAN_TAG.setAttribute("id", g_nodeid + g_nodeCount);
            SPAN_TAG.setAttribute("name", g_nodeid + g_nodeCount);
            SPAN_TAG.setAttribute("class", g_baseClass["normal"]);
            SPAN_TAG.setAttribute("style", "display:inline-block;");

            if (GetAttribute(childNode, "title") != null) {
                SPAN_TAG.setAttribute("title", GetAttribute(childNode, "title"));
            }

            SPAN_TAG.innerText = GetAttribute(childNode, "caption");
            try {
                SPAN_TAG.addEventListener('dragover', event_ondragover_span, false);
                SPAN_TAG.addEventListener('drop', event_ondrop_span, false);
            } catch (e) {
                console.log(e);
            }
            
            SPAN3.appendChild(SPAN_TAG);
            SPAN_TAG = null;

            var SPAN_TAG = document.createElement("SPAN");
            SPAN_TAG.style.display = "NONE";
            SPAN_TAG.setAttribute("id", g_childid + g_nodeCount);
            SPAN_TAG.setAttribute("name", g_childid + g_nodeCount);

            var nodeDIV = document.createElement("SPAN");
            nodeDIV.style.display = "block";
            nodeDIV.appendChild(SPAN3);
            nodeDIV.appendChild(SPAN_TAG);

            childNodes.children.item(0).appendChild(nodeDIV);

            var prelastnode = childNodes.children.item(0).children.item(childNodes.children.item(0).children.length - 2);
            if (prelastnode.children.item(0).children.item(depth).src.indexOf(g_baseImage["dot_end"]) >= 0) {
                prelastnode.children.item(0).children.item(depth).src = g_baseImage["dot_normal"];
            }
            else {
                if (prelastnode.children.item(0).children.item(depth).src.indexOf(g_baseImage["plus_end"]) >= 0)
                    prelastnode.children.item(0).children.item(depth).src = g_baseImage["plus_normal"];
                else
                    prelastnode.children.item(0).children.item(depth).src = g_baseImage["minus_normal"];

                changeRecursiveImg(prelastnode.children.item(1), false, depth, 0);
            }

            var depthlist = g_nodeArray["depth"][prelastnode.children.item(0).children.item(depth + 2).id.split(g_nodeid)[1]];
            depthlist = depthlist.substr(0, depthlist.length - 1) + "1";
            g_nodeArray["depth"][prelastnode.children.item(0).children.item(depth + 2).id.split(g_nodeid)[1]] = depthlist;

            g_nodeArray["nodeXML"][g_nodeCount] = g_nodeArray["nodeXML"][nodeIdx].appendChild(childXML.documentElement);
            g_nodeArray["depth"][g_nodeCount] = g_nodeArray["depth"][nodeIdx] + "0";

            nodeDIV = null;
            prelastnode = null;
            childXML = null;
        }

        node = null;
        childnodes = null;
    }

    this.findindex = ex_findindex;
    function ex_findindex(valueName, value) {
        for (var i = 1; i <= g_nodeCount; i++) {
            if (g_nodeArray["nodeXML"][i] != null)
                if (GetAttribute(g_nodeArray["nodeXML"][i], valueName) == value)
                    return i;
        }

        return -1;
    }

    this.haschild = ex_haschild;
    function ex_haschild(nodeIdx) {
        var depth = g_nodeArray["depth"][nodeIdx].length;
        var src = document.getElementById(g_nodeid + nodeIdx).parentElement.children.item(depth - 1).src;

        if (src.indexOf(g_baseImage["plus_normal"]) > 0 ||
            src.indexOf(g_baseImage["plus_end"]) > 0 ||
            src.indexOf(g_baseImage["minus_normal"]) > 0 ||
            src.indexOf(g_baseImage["minus_end"]) > 0)
            return true;
        else
            return false;
    }

    function event_onselectstart(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        if (!event) event = window.event;
        event.cancelBubble = true;
        event.returnValue = false;
    }

    function event_onmousedown(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function (event) {
            if (!event) event = window.event;
            var targetEl = event.target;
            var elementid = targetEl.id;
            if (elementid.indexOf(g_toggleid) == 0)
                this.toggle(elementid.split(g_toggleid)[1]);
            else if (elementid.indexOf(g_nodeid) == 0)
                this.select(elementid.split(g_nodeid)[1], event);
        }).call(this, event) :
        (function (event) {
            var elementid = window.event.srcElement.id;
            if (elementid.indexOf(g_toggleid) == 0)
                this.toggle(elementid.split(g_toggleid)[1]);
            else if (elementid.indexOf(g_nodeid) == 0)
                this.select(elementid.split(g_nodeid)[1], event);
        }).call(this, event);
    }

    function event_ondblclick(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function (event) {
            if (!event) event = window.event;
            var targetEl = event.target;
            var elementid = targetEl.id;
            if (elementid.indexOf(g_nodeid) == 0) {
                this.onnodedblclick();
            }
        }).call(this, event) :
        (function () {
            var elementid = window.event.srcElement.id;

            if (elementid.indexOf(g_nodeid) == 0) {
                this.onnodedblclick();
            }
        }).call(this);
    }

    function event_onmouseover(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function (event) {
            if (!event) event = window.event;
            var targetEl = event.target;
            var elementid = targetEl.id;
            /*if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "") {
                document.getElementById(elementid).setAttribute('class', g_baseClass["hover"]);
            }*/
        }).call(this, event) :
        (function () {
            var elementid = window.event.srcElement.id;

            /*if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "") {
                document.getElementById(elementid).className = g_baseClass["hover"];
            }*/
        }).call(this);
    }

    function event_onmouseout(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function (event) {
            if (!event) event = window.event;
            var targetEl = event.target;

            var elementid = targetEl.id;
            if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "") {
                // 이게 꼭 필요한 건지? (TODO: 무엇을 위한 건지 확인 필요.)
                // 메일,주소록>left> div.tree 영역 밖의 '메일검색'등을 클릭한 후 div.tree 영역에 hover 시 selected가 원복되는 현상 발생.
                // document.getElementById(elementid).setAttribute('class', (g_selectedIdx == elementid.split(g_nodeid)[1] ? g_baseClass["selected"] : g_baseClass["normal"]));
            }

        }).call(this, event) :
        (function () {
            var elementid = window.event.srcElement.id;

            if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "") {
                if (g_selectedIdx == elementid.split(g_nodeid)[1])
                    document.getElementById(elementid).className = g_baseClass["selected"];
                else
                    document.getElementById(elementid).className = g_baseClass["normal"];
            }
        }).call(this);

    }    

    function event_ondragover(event) {
        event.preventDefault();
    }

    function event_ondragover_span(event) {
        event.preventDefault();
    }

    function event_ondrop(event) {
    }

    function event_ondrop_span(event) {
        if (!event) event = window.event;
        var targetEl = event.target;
        var elementid;
        if (GetAttribute(targetEl, "id") == "" || GetAttribute(targetEl, "id") == null) {
            for (var i = 0; i < GetChildNodes(targetEl).length; i++) {
                if (GetChildNodes(targetEl)[i].id.indexOf(treeviewStr + "_node") > -1) 
                    elementid = GetAttribute(GetChildNodes(targetEl)[i], "id");
            }
        }
        else
            elementid = GetAttribute(targetEl, "id");

        if (elementid.indexOf(g_nodeid) == 0) {
            event.returnValue = false;
            if (window.event.ctrlKey)
                parent.frames["right"].Mail_CopyPostSend("COPY", window[treeviewStr].getvalue(elementid.split(g_nodeid)[1], "href"), event.dataTransfer.getData("text"));
            else
                parent.frames["right"].Mail_CopyPostSend("MOVE", window[treeviewStr].getvalue(elementid.split(g_nodeid)[1], "href"), event.dataTransfer.getData("text"));
        }
    }

    function event_onbeforeunload() {
        g_treeXML = null;
    }
   
    try {
        element.addEventListener('selectstart', event_onselectstart, false);
        element.addEventListener('mousedown', event_onmousedown, false);
        element.addEventListener('dblclick', event_ondblclick, false);
        element.addEventListener('mouseover', event_onmouseover, false);
        element.addEventListener('mouseout', event_onmouseout, false);
        element.addEventListener('beforeunload', event_onbeforeunload, false);
    } catch (e) {
        console.log(e);
    }
    
   
    var g_configXML = null;
    var g_treeXML = null;
    var g_nodeArray = { "nodeXML": new Array(), "depth": new Array() };
    var g_nodeCount = 0;
    var g_baseImage = new Array();
    var g_baseClass = new Array();
    var g_images = new Array();
    var g_selectedIdx = -1;
    var g_imageid = element.id + "_icon_";
    var g_toggleid = element.id + "_img_";
    var g_nodeid = element.id + "_node_";
    var g_childid = element.id + "_child_";
    var g_bdragdrop = false;
    var g_imageWidth = -1;
    var g_imageHeight = -1;
    var g_selectedNode = null;    

    function make_childHtml(nodeIdx) {

    	var nodeXML;
        var depth = "";
        if (nodeIdx == 0)
        {
            nodeXML = GetChildNodes(SelectNodes(g_treeXML, "tree/nodes")[0]);
        }
        else
        {
            nodeXML = GetChildNodes(g_nodeArray["nodeXML"][nodeIdx]);
            depth = g_nodeArray["depth"][nodeIdx];
        }
        
        var SPAN1 = document.createElement("SPAN");
        SPAN1.style.display = "block";
        //SPAN1.style.width = "150px";
        var childLength = nodeXML.length;

        for (var i = 0; i < childLength; i++) {
            g_nodeCount++;
            var mydepth = depth;
            var childNode = nodeXML[i];

            var SPAN2 = document.createElement("SPAN");
            SPAN2.style.display = "block";
            var SPAN3 = document.createElement("DIV");
            SPAN3.setAttribute("class", "node_div");
            
            for (var j = 0; j < depth.length; j++) {
            	var imgSpan = document.createElement("SPAN");
                imgSpan.setAttribute("class", "sub_iconLNB tree_blank");
                SPAN3.appendChild(imgSpan);	
            }

            var bParent = (GetChildNodes(childNode).length > 0) ? true : false;
            var bEndNode = (i == childLength - 1) ? true : false;
            if (GetAttribute(childNode, "hassub") != null && GetAttribute(childNode, "hassub") != "")
                bParent = true;

            var IMG_TAG = document.createElement("IMG");
            if (bParent) {
            	var imgSpan = document.createElement("SPAN");
            	
                if (!bEndNode) {                	
                	imgSpan.setAttribute("class", "sub_iconLNB tree_plus");
                    mydepth += "1";                    
                }
                else {
                	imgSpan.setAttribute("class", "sub_iconLNB tree_plus");
                    mydepth += "0";                    
                }
                
                imgSpan.setAttribute("id", g_toggleid + g_nodeCount);
                imgSpan.setAttribute("name", g_toggleid + g_nodeCount);

                SPAN3.appendChild(imgSpan);
                IMG_TAG = null;
            }
            else {
                if (!bEndNode) {
                    mydepth += "1";
                }
                else {
                    mydepth += "0";
                }

                var imgSpan = document.createElement("SPAN");
                imgSpan.setAttribute("class", "sub_iconLNB tree_blank");
                imgSpan.setAttribute("id", g_toggleid + g_nodeCount);
                imgSpan.setAttribute("name", g_toggleid + g_nodeCount);
                SPAN3.appendChild(imgSpan);
            }

            var _imgsrc;
            var spanId;
            var _foldername = GetAttribute(childNode, 'href') != null ? GetAttribute(childNode, 'fullcaption') : null;
            var _tempStatus;
            
            switch (_foldername) {
                case '_ALLMAIL':
                    spanClass = "sub_iconLNB";
                    spanId = "allMail";
                    _tempStatus = "Y";
                    break;
                case '_INBOX':
                    // 2023-06-22 황인경 - 디자인 개선 > 메일 > 좌측메뉴 > 트리구조 LNB 이미지 삭제
                    spanClass = "sub_iconLNB";
                    spanId = "inboxMail";
                    _tempStatus = "Y";
                    break;
                case '_SENT':
                    spanClass = "sub_iconLNB";
                    spanId = "sentMail";
                    _tempStatus = "Y";
                    break;
                case '_DRAFT':
                    spanClass = "sub_iconLNB";
                    spanId = "draftMail";
                    _tempStatus = "Y";
                    break;
                case '_JUNK':
                    spanClass = "sub_iconLNB";
                    spanId = "junkMail";
                    _tempStatus = "Y";
                    break;
                case '_DELETE':
                    spanClass = "sub_iconLNB";
                    spanId = "deleteMail";
                    _tempStatus = "Y";
                    break;
                case '_PERSONAL':
                    spanClass = "sub_iconLNB";
                    spanId = "personalMail";
                    _tempStatus = "Y";
                    break;
                default:
                    spanClass = "sub_iconLNB";
                	spanId = "defaultMail";
                	_tempStatus = "N";
                    break;
            }
            
            if (g_nodeid + g_nodeCount == "AddressTreeView_node_1") {
            } else if (g_nodeid + g_nodeCount == "AddressTreeView_node_2") {
            } else if (g_nodeid + g_nodeCount == "AddressTreeView_node_3") {
            }
            
            var imgSpan2 = document.createElement("SPAN");
            imgSpan2.setAttribute("class", spanClass);
            imgSpan2.setAttribute("id", spanId);
            SPAN3.appendChild(imgSpan2);
            
            IMG_TAG = null;

            var SPAN_TAG = document.createElement("SPAN");
            SPAN_TAG.setAttribute("id", g_nodeid + g_nodeCount);
            SPAN_TAG.setAttribute("name", g_nodeid + g_nodeCount);
            SPAN_TAG.setAttribute("class", g_baseClass["normal"]);
            
            if (GetAttribute(childNode, "title") != null) {
            	if (mydepth != "1") {
            		SPAN_TAG.setAttribute("title", GetAttribute(childNode, "caption"));
            	} else if (typeof window !== "undefined" && window.location && window.location.href && window.location.href.includes("addressFolderManage.do")) {
                    SPAN_TAG.setAttribute("title", GetAttribute(childNode, "caption"));
                }
            }
            
            
            var folderCount = GetAttribute(childNode, "foldercount");
            if (folderCount > 0) {
            	// 2023-06-23 황인경 - 디자인 개선 > 메일 > 좌측메뉴 > 카운트 괄호 추가
            	SPAN_TAG.innerHTML = GetAttribute(childNode, "caption") + "(" + folderCount + ")"; 
            } else {
            	SPAN_TAG.innerHTML = GetAttribute(childNode, "caption");
            }
            
            try {
                SPAN_TAG.addEventListener('dragover', event_ondragover_span, false);
                SPAN_TAG.addEventListener('drop', event_ondrop_span, false);
            } catch (e) {
                console.log(e);
            }
            
            SPAN3.appendChild(SPAN_TAG);
            
            if (document.getElementById("left")) {
	            if (_foldername == "_INBOX") {
	            	if (shareId == "" || managePermission == "Y") {
	            		var SPAN_TAG_MNG = document.createElement("SPAN");
			            SPAN_TAG_MNG.setAttribute("class", "sub_iconLNB tree_manage");
			            SPAN_TAG_MNG.setAttribute("onclick", "folder_manage()");
			            
			            SPAN3.appendChild(SPAN_TAG_MNG);
	            	}
	            }
	            
	            if (g_nodeid + g_nodeCount == "AddressTreeView_node_1") {
	            	var SPAN_TAG_MNG = document.createElement("SPAN");
	            	SPAN_TAG_MNG.setAttribute("class", "sub_iconLNB tree_manage");
		            SPAN_TAG_MNG.setAttribute("onclick", "address_foldermanage()");
		            
		            SPAN3.appendChild(SPAN_TAG_MNG);
	            }
            }
            
            //2017-06-15 이효민 : 편지함관리 > 구독지정 관련 추가 start
            var subscribeImg = '/images/ImgIcon/subscribe.png';
            var subscribe = GetAttribute(childNode, 'subscribe');
            if (subscribe != null && subscribe == "1") {
        		var IMG_TAG2 = document.createElement("IMG");
            	IMG_TAG2.setAttribute("src", subscribeImg);
            	IMG_TAG2.style.marginLeft = "10px";
            	SPAN3.appendChild(IMG_TAG2);
            }
            //2017-06-15 이효민 : 편지함관리 > 구독지정 관련 추가 end
            
            SPAN2.appendChild(SPAN3);

            var SPAN_TAG = document.createElement("SPAN");
            SPAN_TAG.style.display = "NONE";
            SPAN_TAG.setAttribute("id", g_childid + g_nodeCount);
            SPAN_TAG.setAttribute("name", g_childid + g_nodeCount);
            SPAN2.appendChild(SPAN_TAG);

            g_nodeArray["nodeXML"][g_nodeCount] = childNode;
            g_nodeArray["depth"][g_nodeCount] = mydepth;

            SPAN1.appendChild(SPAN2);
        }

        return SPAN1;
    }

    function changeRecursiveImg(node, bspace, depth, recuringCount) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function (node, bspace, depth, recuringCount) {
            if (node.innerHTML == "")
                return;

            for (var i = 0; i < node.children.item(0).children.length; i++) {
                var child = node.children.item(0).children.item(i);
                if (bspace) {
                    child.children.item(0).children.item(depth).setAttribute('src', g_baseImage["space"]);
                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "0" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                else {
                    child.children.item(0).children.item(depth).setAttribute('src', g_baseImage["dot_continue"]);
                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "1" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                child = null;
            }
        }).call(this, node, bspace, depth, recuringCount) :
        (function (node, bspace, depth, recuringCount) {
            if (node.innerHTML == "")
                return;

            for (var i = 0; i < node.children.item(0).children.length; i++) {
                var child = node.children.item(0).children.item(i);
                if (bspace) {
                    child.children.item(0).children.item(depth).src = g_baseImage["space"];
                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "0" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                else {
                    child.children.item(0).children.item(depth).src = g_baseImage["dot_continue"];
                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "1" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 3 + recuringCount).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                child = null;
            }
        }).call(this, node, bspace, depth, recuringCount);
    }

    function set_initvalue() {
        var bimageNodes = GetChildNodes(SelectNodes(g_configXML, "tree/config/baseimage")[0]);
        for (var i = 0; i < bimageNodes.length; i++)
            g_baseImage[bimageNodes[i].nodeName.toLowerCase()] = GetAttribute(bimageNodes[i], "path");

        bimageNodes = null;

        var classNodes = GetChildNodes(SelectNodes(g_configXML, "tree/config/baseclass")[0]);
        for (var i = 0; i < classNodes.length; i++)
            g_baseClass[classNodes[i].nodeName.toLowerCase()] = GetAttribute(classNodes[i], "name"); 

        classNodes = null;

        var imageNodes = GetChildNodes(SelectNodes(g_configXML, "tree/config/images")[0]);
        for (var i = 0; i < imageNodes.length; i++)
            g_images[GetAttribute(imageNodes[i], "idx").toLowerCase()] = GetAttribute(imageNodes[i], "path");

        imageNodes = null;

        g_imageWidth = GetAttribute(SelectNodes(g_configXML, "tree/config/size")[0], "width");
        g_imageHeight = GetAttribute(SelectNodes(g_configXML, "tree/config/size")[0], "height");
    }

    function MakeHTMLStr(orgStr) {
        return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "&amp;"), "\"", "&quot;"), "<", "&lt;"), ">", "&gt;");
    }

    function ReplaceText(orgStr, findStr, replaceStr) {
        var re = new RegExp(findStr, "gi");
        return (orgStr.replace(re, replaceStr));
    }

    function IsOwaPremiumBrowser() {
        var b = navigator.userAgent, c = navigator.appVersion, g = c.indexOf("Mac") != -1, h = c.indexOf("Win") != -1 || c.indexOf("NT") != -1, f = b.indexOf("MSIE ") != -1, d = b.indexOf("Firefox/") != -1 && b.indexOf("Gecko/") != -1 && Array.every, e = b.indexOf("Safari") != -1 && b.indexOf("WebKit") != -1, a = 2;
        if (f) a = parseFloat(b.replace(/^.*MSIE /, ""));
        else if (d) a = parseFloat(b.replace(/^.*Firefox\//, ""));
        else if (e) a = parseFloat(b.replace(/^.*Version\//, ""));
        else a = parseInt(c);
        if (h) { if (f) return a >= 7; else if (e) return a >= 3; else if (d) return a >= 3 } else if (g) if (e) return a >= 2; else if (d) return a >= 3; return false
    }

    function iterator(node, func) {
        var childnode = node.firstElementChild;
        while (childnode) {
            func(childnode);
            childnode = childnode.nextElementSibling;
        }
    }
}