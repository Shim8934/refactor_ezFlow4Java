/*
<public:component urn="www.asitaka.com:organtreeview">

<public:property name="config" put="put_config" />
<public:property name="source" put="put_source" />
<public:property name="selectedIndex" get="get_selectedIndex" />
<public:property name="gnodeid" get="get_gnodeid" />
<public:property name="dragdrop" put="put_dragdrop" />
<public:property name="nodecount" get="get_nodecount" />
<public:property name="server" put="put_server" />

<public:method name="update" internalname="ex_update" />
<public:method name="toggle" internalname="ex_toggle" />
<public:method name="getvalue" internalname="ex_getvalue" />
<public:method name="putvalue" internalname="ex_putvalue" />
<public:method name="putcaption" internalname="ex_putcaption" />
<public:method name="select" internalname="ex_select" />
<public:method name="putchildxml" internalname="ex_putchildxml" />
<public:method name="deletenode" internalname="ex_deletenode" />
<public:method name="addnode" internalname="ex_addnode" />
<public:method name="findindex" internalname="ex_findindex" />
<public:method name="haschild" internalname="ex_haschild" />

<public:event name="onnodedblclick" id="nodedblclick" />
<public:event name="onnodeselect" id="nodeselect" />
<public:event name="onrequestdata" id="noderequestdata" />

<public:attach event="onselectstart" for="element" handler="event_onselectstart" />
<public:attach event="onmousedown" for="element" handler="event_onmousedown" />
<public:attach event="ondblclick" for="element" handler="event_ondblclick" />
<public:attach event="onmouseover" for="element" handler="event_onmouseover" />
<public:attach event="onmouseout" for="element" handler="event_onmouseout" />
<public:attach event="onkeydown" for="element" handler="event_onkeydown" />
<public:attach event="onbeforeunload" for="window" handler="event_onbeforeunload" />

<script language="JScript">
*/

function organtreeview(thisobjid, elobjid) {
    window[thisobjid] = this;
    var thisid = thisobjid;
    var element = document.getElementById(elobjid); // 추가
    this.attachEvent = function(eventname, eventhandler) {
        this['on' + eventname] = eventhandler;
    }

    // getter, setter
    this.config = function(a) {
        // get
        if (!a) {
            return;
        }
        // set
        return put_config.call(this, a);
    };
    function put_config(configXML) {
        g_configXML = configXML;
    }

    this.source = function(a) {
        // get
        if (!a) {
            return;
        }
        // set
        return put_source.call(this, a);
    };
    function put_source(sourceXML) {
        if (typeof (sourceXML) == "object") {
            g_treeXML = sourceXML;
            return;
        }

        if (navigator.userAgent.indexOf('MSIE') == -1) {
            g_treeXML = new DOMParser().parseFromString(sourceXML, "text/xml");
        }
        else {
            g_treeXML = createXmlDom();
            g_treeXML.loadXML(sourceXML);
        }
    }
    
    this.selectedIndex = function(a) {
        // get
        if (!a) {
            return get_selectedIndex.call(this);
        }
        // set
        return;
    };
    function get_selectedIndex() {
        return g_selectedIdx;
    }

    this.gnodeid = function(a) {
        // get
        if (!a) {
            return get_gnodeid.call(this);
        }
        // set
        return;
    };
    function get_gnodeid() {
        return g_nodeid;
    }

    this.dragdrop = function(a) {
        // get
        if (!a) {
            return;
        }
        // set
        return put_dragdrop.call(this, a);
    };
    function put_dragdrop() {
    }
    
    this.nodecount = function(a) {
        // get
        if (!a) {
            return get_nodecount.call(this);
        }
        // set
        return;
    };
    function get_nodecount() {
        return g_nodeCount;
    }

    this.server = function(a) {
        // get
        if (!a) {
            return;
        }
        // set
        return put_server.call(this, a);
    };
    function put_server(server) {
        g_serverName = server;
    }

    // method
    this.update = ex_update;
    function ex_update() {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            // safari
            if (g_treeXML == null)
                return;

            g_nodeCount = 0;
            g_selectedIdx = -1;
            set_initvalue();



            var tmp_treeXML = g_treeXML.documentElement.cloneNode(true);
            var nousenodes = new Array();
            iterator(
            tmp_treeXML,
            function(node) {
                if (node.nodeName != 'NODE') {
                    nousenodes[nousenodes.length] = node;
                    //tmp_treeXML.removeChild(node); // iterator 중 삭제 불가
                }
            }
            );
            for (var i = 0; i < nousenodes.length; i++) {
                tmp_treeXML.removeChild(nousenodes[i]);
                delete nousenodes[i];
            }


            element.innerHTML = make_childHtml(0, tmp_treeXML);


            if (g_selectedIdx != -1) {
                //nodeselect.fire();
                this.onnodeselect();

                var height = document.getElementById(g_nodeid + g_selectedIdx).clientHeight;
                height = height * g_selectedIdx - element.clientHeight / 2 - height / 2;

                if (height > 0) {
                    //this.scrollTop = height;
                    element.scrollTop = height;
                }
            }
        }).call(this) :
        (function() {
            // IE
            if (g_treeXML == null)
                return;

            g_nodeCount = 0;
            g_selectedIdx = -1;
            set_initvalue();
            element.innerHTML = make_childHtml(0, g_treeXML.selectSingleNode("TREEVIEWDATA").selectNodes("NODE"));

            if (g_selectedIdx != -1) {
                //nodeselect.fire();
                this.onnodeselect();

                var height = document.getElementById(g_nodeid + g_selectedIdx).clientHeight;
                height = height * g_selectedIdx - element.clientHeight / 2 - height / 2;

                if (height > 0) {
                    element.scrollTop = height;
                }
            }
        }).call(this);
    }
    
    this.toggle = ex_toggle;
    function ex_toggle(nodeIdx) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx) {
            // safari
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return;

            var toggleel = document.getElementById(g_toggleid + nodeIdx);
            if (toggleel.src.indexOf(g_baseImageName["plus_normal"]) == -1 &&
		    toggleel.src.indexOf(g_baseImageName["minus_normal"]) == -1 &&
		    toggleel.src.indexOf(g_baseImageName["plus_end"]) == -1 &&
		    toggleel.src.indexOf(g_baseImageName["minus_end"]) == -1)
                return;

            var childel = document.getElementById(g_childid + nodeIdx);
            if (childel.style.display == "none") {
                childel.style.display = "";
                if (toggleel.src.indexOf(g_baseImageName["plus_normal"]) >= 0)
                    toggleel.src = g_baseImage["minus_normal"];
                else
                    toggleel.src = g_baseImage["minus_end"];

                if (childel.innerHTML == "") {
                    var oEvent = {}; //createEventObject();
                    oEvent.nodeIdx = nodeIdx;
                    //noderequestdata.fire(oEvent);
                    this.onrequestdata(oEvent);
                }
            }
            else {
                childel.style.display = "none";
                if (toggleel.src.indexOf(g_baseImageName["minus_normal"]) >= 0)
                    toggleel.src = g_baseImage["plus_normal"];
                else
                    toggleel.src = g_baseImage["plus_end"];
            }
        }).call(this, nodeIdx) :
        (function(nodeIdx) {
            // IE
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return;

            var toggleel = document.getElementById(g_toggleid + nodeIdx);
            if (toggleel.src.indexOf(g_baseImageName["plus_normal"]) == -1 &&
		    toggleel.src.indexOf(g_baseImageName["minus_normal"]) == -1 &&
		    toggleel.src.indexOf(g_baseImageName["plus_end"]) == -1 &&
		    toggleel.src.indexOf(g_baseImageName["minus_end"]) == -1)
                return;

            var childel = document.getElementById(g_childid + nodeIdx);
            if (childel.style.display == "none") {
                childel.style.display = "";
                if (toggleel.src.indexOf(g_baseImageName["plus_normal"]) >= 0)
                    toggleel.src = g_baseImage["minus_normal"];
                else
                    toggleel.src = g_baseImage["minus_end"];

                if (childel.innerHTML == "") {
                    var oEvent = document.createEventObject();
                    oEvent.nodeIdx = nodeIdx;
                    //noderequestdata.fire(oEvent);
                    this.onrequestdata(oEvent);
                }
            }
            else {
                childel.style.display = "none";
                if (toggleel.src.indexOf(g_baseImageName["minus_normal"]) >= 0)
                    toggleel.src = g_baseImage["plus_normal"];
                else
                    toggleel.src = g_baseImage["plus_end"];
            }
        }).call(this, nodeIdx);
    }
    
    this.getvalue = ex_getvalue;
    function ex_getvalue(nodeIdx, valueName) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx, valueName) {
            // safari
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            return g_nodeArray["nodeXML"][nodeIdx][valueName];
        }).call(this, nodeIdx, valueName) :
        (function(nodeIdx, valueName) {
            // IE
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            return g_nodeArray["nodeXML"][nodeIdx][valueName];
        }).call(this, nodeIdx, valueName);
    }
    
    this.putvalue = ex_putvalue;
    // 수정(2007.05.30) : DATA 값 변경함수 추가
    function ex_putvalue(nodeIdx, valueName, value) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx, valueName, value) {
            // safari
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            g_nodeArray["nodeXML"][nodeIdx][valueName] = value;
        }).call(this, nodeIdx, valueName, value) :
        (function(nodeIdx, valueName, value) {
            // IE
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            g_nodeArray["nodeXML"][nodeIdx][valueName] = value;
        }).call(this, nodeIdx, valueName, value);
    }
    
    this.putcaption = ex_putcaption;
    // 수정(2007.05.30) : Text 값 변경함수 추가
    function ex_putcaption(nodeIdx, caption) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx, caption) {
            // safari
            document.getElementById(g_nodeid + nodeIdx).innerHTML = caption;
        }).call(this, nodeIdx, caption) :
        (function(nodeIdx, caption) {
            // IE
            document.getElementById(g_nodeid + nodeIdx).innerHTML = caption;
        }).call(this, nodeIdx, caption);
    }
    
    this.select = ex_select;
    function ex_select(nodeIdx) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx) {
            // safari
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return;

            if (g_selectedIdx != -1) {
                document.getElementById(g_nodeid + g_selectedIdx).className = g_baseClass["normal"];
            }

            document.getElementById(g_nodeid + nodeIdx).className = g_baseClass["selected"];
            g_selectedIdx = nodeIdx;
            //nodeselect.fire();
            this.onnodeselect();
        }).call(this, nodeIdx) :
        (function(nodeIdx) {
            // IE
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return;

            if (g_selectedIdx != -1)
                document.getElementById(g_nodeid + g_selectedIdx).className = g_baseClass["normal"];

            document.getElementById(g_nodeid + nodeIdx).className = g_baseClass["selected"];
            g_selectedIdx = nodeIdx;
            //nodeselect.fire();
            this.onnodeselect();
        }).call(this, nodeIdx);
    }
    
    this.putchildxml = ex_putchildxml;
    function ex_putchildxml(nodeIdx, childxml) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx, childxml) {
            // safari
            if (typeof (childxml) == "object")
                var childXML = childxml;
            else {
                var childXML = new DOMParser().parseFromString(childxml, 'text/xml');
            }

            var childHTML = make_childHtml(nodeIdx, childXML.documentElement);

            var childel = document.getElementById(g_childid + nodeIdx);
            var toggleel = document.getElementById(g_toggleid + nodeIdx);
            if (childHTML == "<div></div>") {
                childel.style.display = "none";
                if (toggleel.src.indexOf(g_baseImageName["minus_normal"]) >= 0)
                    toggleel.src = g_baseImage["dot_normal"];
                else
                    toggleel.src = g_baseImage["dot_end"];
            }
            else
                childel.innerHTML = childHTML;
        }).call(this, nodeIdx, childxml) :
        (function(nodeIdx, childxml) {
            // IE
            if (typeof (childxml) == "object")
                var childXML = childxml;
            else {
                var childXML = new ActiveXObject("Microsoft.XMLDom");
                childXML.loadXML(childxml);
            }

            var childHTML = make_childHtml(nodeIdx, childXML.documentElement.selectNodes("NODE"));

            var childel = document.getElementById(g_childid + nodeIdx);
            var toggleel = document.getElementById(g_toggleid + nodeIdx);
            if (childHTML == "<div></div>") {
                childel.style.display = "none";
                if (toggleel.src.indexOf(g_baseImageName["minus_normal"]) >= 0)
                    toggleel.src = g_baseImage["dot_normal"];
                else
                    toggleel.src = g_baseImage["dot_end"];
            }
            else
                childel.innerHTML = childHTML;
        }).call(this, nodeIdx, childxml);
    }

    this.deletenode = ex_deletenode;
    // 수정(2007.05.30) : 노드 삭제가 정상적으로 처리되지 않아 함수 변경
    function ex_deletenode(nodeIdx) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx) {
            // safari
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            var node = document.getElementById(g_nodeid + nodeIdx).parentElement.parentElement;
            var children = node.parentElement.parentElement.parentElement.children;

            if (children.item(0).children.item(children.item(0).children.length - 1).children.item(0) == node) {
                if (children.item(0).children.length > 1) {
                    var child = children.item(0).children.item(children.item(0).children.length - 2)
                    var depth = g_nodeArray["depth"][nodeIdx].length;
                    var imgnode = child.children.item(0).children.item(depth - 1);

                    if (imgnode.src.indexOf(g_baseImageName["dot_normal"]) >= 0) {
                        imgnode.src = g_baseImage["dot_end"];
                    }
                    else {
                        if (imgnode.src.indexOf(g_baseImageName["plus_normal"]) >= 0)
                            imgnode.src = g_baseImage["plus_end"];
                        else
                            imgnode.src = g_baseImage["minus_end"];

                        //changeRecursiveImg(child, true, depth-1, 0);
                    }

                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 1).children.item(0).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depthlist.length - 1) + "0";
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 1).children.item(0).id.split(g_nodeid)[1]] = depthlist;

                    node.parentElement.parentElement.removeChild(node.parentElement);

                    imgnode = null;
                    child = null;
                }
                else {
                    var depth = g_nodeArray["depth"][nodeIdx].length;

                    imgnode = node.parentElement.parentElement.parentElement.parentElement.children.item(0).children.item(depth - 2);
                    if (imgnode.src.indexOf(g_baseImageName["plus_normal"]) >= 0 || imgnode.src.indexOf(g_baseImageName["minus_normal"]) >= 0)
                        imgnode.src = g_baseImage["dot_normal"];
                    else
                        imgnode.src = g_baseImage["dot_end"];

                    node.parentElement.parentElement.parentElement.style.display = "none";
                    node.parentElement.parentElement.parentElement.innerHTML = "";

                    imgnode = null;
                }
            }
            else {
                node.parentElement.parentElement.removeChild(node.parentElement);
            }

            g_nodeArray["nodeXML"][nodeIdx] = null;
            g_nodeArray["depth"][nodeIdx] = "";
            node = null;
            children = null;
            g_selectedIdx = -1;
        }).call(this, nodeIdx) :
        (function(nodeIdx) {
            // IE
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            var node = document.getElementById(g_nodeid + nodeIdx).parentElement.parentElement;
            var children = node.parentElement.parentElement.parentElement.children;

            if (children.item(0).children.item(children.item(0).children.length - 1).children.item(0) == node) {
                if (children.item(0).children.length > 1) {
                    var child = children.item(0).children.item(children.item(0).children.length - 2)
                    var depth = g_nodeArray["depth"][nodeIdx].length;
                    var imgnode = child.children.item(0).children.item(depth - 1);

                    if (imgnode.src.indexOf(g_baseImageName["dot_normal"]) >= 0) {
                        imgnode.src = g_baseImage["dot_end"];
                    }
                    else {
                        if (imgnode.src.indexOf(g_baseImageName["plus_normal"]) >= 0)
                            imgnode.src = g_baseImage["plus_end"];
                        else
                            imgnode.src = g_baseImage["minus_end"];

                        //changeRecursiveImg(child, true, depth-1, 0);
                    }

                    var depthlist = g_nodeArray["depth"][child.children.item(0).children.item(depth + 1).children.item(0).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depthlist.length - 1) + "0";
                    g_nodeArray["depth"][child.children.item(0).children.item(depth + 1).children.item(0).id.split(g_nodeid)[1]] = depthlist;

                    node.parentElement.parentElement.removeChild(node.parentElement);

                    imgnode = null;
                    child = null;
                }
                else {
                    var depth = g_nodeArray["depth"][nodeIdx].length;

                    imgnode = node.parentElement.parentElement.parentElement.parentElement.children.item(0).children.item(depth - 2);
                    if (imgnode.src.indexOf(g_baseImageName["plus_normal"]) >= 0 || imgnode.src.indexOf(g_baseImageName["minus_normal"]) >= 0)
                        imgnode.src = g_baseImage["dot_normal"];
                    else
                        imgnode.src = g_baseImage["dot_end"];

                    node.parentElement.parentElement.parentElement.style.display = "none";
                    node.parentElement.parentElement.parentElement.innerHTML = "";

                    imgnode = null;
                }
            }
            else {
                node.parentElement.parentElement.removeChild(node.parentElement);
            }

            g_nodeArray["nodeXML"][nodeIdx] = null;
            g_nodeArray["depth"][nodeIdx] = "";
            node = null;
            children = null;
            g_selectedIdx = -1;
        }).call(this, nodeIdx);
    }
    
    this.addnode = ex_addnode;
    // 수정(2007.05.30) : 노드 추가가 정상적으로 처리되지 않아 함수 변경
    function ex_addnode(nodeIdx, nodeXML) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx, nodeXML) {
            // safari
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            var node = document.getElementById(g_nodeid + nodeIdx)
            var depth = g_nodeArray["depth"][nodeIdx].length;
            var childNodes = node.parentNode.parentNode.parentNode.children.item(1);

            if (childNodes.innerHTML == "") {
                var imgnode = node.parentElement.parentElement.children.item(depth - 1);

                if (imgnode != null) {
                    if (imgnode.src.indexOf(g_baseImageName["dot_normal"]) >= 0)
                        imgnode.src = g_baseImage["plus_normal"];
                    else if (imgnode.src.indexOf(g_baseImageName["dot_end"]) >= 0)
                        imgnode.src = g_baseImage["plus_end"];

                    imgnode = null;
                }
            }
            else {
                var childXML = createXmlDom();
                childXML.loadXML(nodeXML);

                g_nodeCount++;

                var childNode = childXML.childNodes.item(0);

                var nodeHtml = "<div style='height:" + g_imageHeight + "px;overflow-y:hidden;' noWrap>";
                for (var j = 0; j < depth; j++) {
                    if (g_nodeArray["depth"][nodeIdx].charAt(j) == "1")
                        nodeHtml += ("<img src='" + g_baseImage["dot_continue"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                    else
                        nodeHtml += ("<img src='" + g_baseImage["space"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }

                nodeHtml += ("<img src='" + g_baseImage["dot_end"]);
                nodeHtml += ("' id='" + g_toggleid + g_nodeCount + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");

                if (childXML.documentElement.selectSingleNode("SETNODEICONBYNAME") != null)
                    nodeHtml += ("<img src='" + g_images[childXML.selectSingleNode("SETNODEICONBYNAME").text] + "'>");
                else
                    nodeHtml += ("<img src='" + g_images["BASE"] + "'>");

                nodeHtml += ("<a href='#" + g_nodeCount + "'><span id='" + g_nodeid + g_nodeCount + "' class='" +
					g_baseClass["normal"] + "'>");

                nodeHtml += (childXML.documentElement.selectSingleNode("VALUE").text + "</span></a></div>");

                g_nodeArray["nodeXML"][g_nodeCount] = new Array();
                for (var j = 0; j < childNode.childNodes.length; j++) {
                    if (childNode.childNodes.item(j).nodeName != "NODES")
                        g_nodeArray["nodeXML"][g_nodeCount][childNode.childNodes.item(j).nodeName] = childNode.childNodes.item(j).text;
                }

                nodeHtml += ("<span style='display:none' id='" + g_childid + g_nodeCount + "'></span>");

                var nodeDIV = document.createElement("DIV");
                nodeDIV.innerHTML = nodeHtml;
                childNodes.children.item(0).appendChild(nodeDIV);

                var prelastnode = childNodes.children.item(0).children.item(0).children.item(childNodes.children.item(0).children.item(0).children.length - 2);
                if (prelastnode.children.item(depth).src.indexOf(g_baseImageName["dot_end"]) >= 0) {
                    prelastnode.children.item(depth).src = g_baseImage["dot_normal"];
                }
                else {
                    if (prelastnode.children.item(depth).src.indexOf(g_baseImageName["plus_end"]) >= 0)
                        prelastnode.children.item(depth).src = g_baseImage["plus_normal"];
                    else
                        prelastnode.children.item(depth).src = g_baseImage["minus_normal"];

                    //changeRecursiveImg(prelastnode.parentNode, false, depth, 0);
                }

                var depthlist = g_nodeArray["depth"][prelastnode.children.item(depth + 2).children.item(0).id.split(g_nodeid)[1]];
                depthlist = depthlist.substr(0, depthlist.length - 1) + "1";
                g_nodeArray["depth"][prelastnode.children.item(depth + 2).id.split(g_nodeid)[1]] = depthlist;
                g_nodeArray["depth"][g_nodeCount] = g_nodeArray["depth"][nodeIdx] + "0";

                nodeDIV = null;
                prelastnode = null;
                childXML = null;
            }

            node = null;
            childnodes = null;
        }).call(this, nodeIdx, nodeXML) :
        (function(nodeIdx, nodeXML) {
            // IE
            if (nodeIdx > g_nodeCount || nodeIdx < 1)
                return "";

            var node = document.getElementById(g_nodeid + nodeIdx)
            var depth = g_nodeArray["depth"][nodeIdx].length;
            var childNodes = node.parentNode.parentNode.parentNode.children.item(1);

            if (childNodes.innerHTML == "") {
                var imgnode = node.parentElement.parentElement.children.item(depth - 1);

                if (imgnode != null) {
                    if (imgnode.src.indexOf(g_baseImageName["dot_normal"]) >= 0)
                        imgnode.src = g_baseImage["plus_normal"];
                    else if (imgnode.src.indexOf(g_baseImageName["dot_end"]) >= 0)
                        imgnode.src = g_baseImage["plus_end"];

                    imgnode = null;
                }
            }
            else {
                var childXML = new ActiveXObject("Microsoft.XMLDom");
                childXML.loadXML(nodeXML);

                g_nodeCount++;

                var childNode = childXML.childNodes.item(0);

                var nodeHtml = "<div style='height:" + g_imageHeight + "px;overflow-y:hidden;' noWrap>";
                for (var j = 0; j < depth; j++) {
                    if (g_nodeArray["depth"][nodeIdx].charAt(j) == "1")
                        nodeHtml += ("<img src='" + g_baseImage["dot_continue"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                    else
                        nodeHtml += ("<img src='" + g_baseImage["space"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }

                nodeHtml += ("<img src='" + g_baseImage["dot_end"]);
                nodeHtml += ("' id='" + g_toggleid + g_nodeCount + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");

                if (childXML.documentElement.selectSingleNode("SETNODEICONBYNAME") != null)
                    nodeHtml += ("<img src='" + g_images[childXML.selectSingleNode("SETNODEICONBYNAME").text] + "'>");
                else
                    nodeHtml += ("<img src='" + g_images["BASE"] + "'>");

                nodeHtml += ("<a href='#" + g_nodeCount + "'><span id='" + g_nodeid + g_nodeCount + "' class='" +
					g_baseClass["normal"] + "'>");

                nodeHtml += (childXML.documentElement.selectSingleNode("VALUE").text + "</span></a></div>");

                g_nodeArray["nodeXML"][g_nodeCount] = new Array();
                for (var j = 0; j < childNode.childNodes.length; j++) {
                    if (childNode.childNodes.item(j).nodeName != "NODES")
                        g_nodeArray["nodeXML"][g_nodeCount][childNode.childNodes.item(j).nodeName] = childNode.childNodes.item(j).text;
                }

                nodeHtml += ("<span style='display:none' id='" + g_childid + g_nodeCount + "'></span>");

                var nodeDIV = document.createElement("DIV");
                nodeDIV.innerHTML = nodeHtml;
                childNodes.children.item(0).appendChild(nodeDIV);

                var prelastnode = childNodes.children.item(0).children.item(0).children.item(childNodes.children.item(0).children.item(0).children.length - 2);
                if (prelastnode.children.item(depth).src.indexOf(g_baseImageName["dot_end"]) >= 0) {
                    prelastnode.children.item(depth).src = g_baseImage["dot_normal"];
                }
                else {
                    if (prelastnode.children.item(depth).src.indexOf(g_baseImageName["plus_end"]) >= 0)
                        prelastnode.children.item(depth).src = g_baseImage["plus_normal"];
                    else
                        prelastnode.children.item(depth).src = g_baseImage["minus_normal"];

                    //changeRecursiveImg(prelastnode.parentNode, false, depth, 0);
                }

                var depthlist = g_nodeArray["depth"][prelastnode.children.item(depth + 2).children.item(0).id.split(g_nodeid)[1]];
                depthlist = depthlist.substr(0, depthlist.length - 1) + "1";
                g_nodeArray["depth"][prelastnode.children.item(depth + 2).id.split(g_nodeid)[1]] = depthlist;
                g_nodeArray["depth"][g_nodeCount] = g_nodeArray["depth"][nodeIdx] + "0";

                nodeDIV = null;
                prelastnode = null;
                childXML = null;
            }

            node = null;
            childnodes = null;
        }).call(this, nodeIdx, nodeXML);
    }
    
    this.findindex = ex_findindex;
    // 함수를 사용하는 페이지가 없음
    function ex_findindex(valueName, value) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(valueName, value) {
            // safari
            for (var i = 1; i <= g_nodeCount; i++) {
                try {
                    if (g_nodeArray["nodeXML"][i] != null)
                        if (g_nodeArray["nodeXML"][i].nodeName == valueName)
                        if (g_nodeArray["nodeXML"][i].nodeValue == value)
                        return i;
                } catch (e) { }
            }

            return -1;
        }).call(this, valueName, value) :
        (function(valueName, value) {
            // IE
            for (var i = 1; i <= g_nodeCount; i++) {
                try {
                    if (g_nodeArray["nodeXML"][i] != null)
                        if (g_nodeArray["nodeXML"][i].selectSingleNode(valueName) != null)
                        if (g_nodeArray["nodeXML"][i].selectSingleNode(valueName).text == value)
                        return i;
                } catch (e) { }
            }

            return -1;
        }).call(this, valueName, value);
    }
    
    this.haschild = ex_haschild;
    // 함수를 사용하는 페이지가 없음
    function ex_haschild(nodeIdx) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx) {
            // safari
            var depth = g_nodeArray["depth"][nodeIdx].length;
            var src = document.getElementById(g_nodeid + nodeIdx).parentElement.children.item(depth - 1).src;

            if (src.indexOf(g_baseImageName["plus_normal"]) > 0 ||
		    src.indexOf(g_baseImageName["plus_end"]) > 0 ||
		    src.indexOf(g_baseImageName["minus_normal"]) > 0 ||
		    src.indexOf(g_baseImageName["minus_end"]) > 0)
                return true;
            else
                return false;
        }).call(this, nodeIdx) :
        (function(nodeIdx) {
            // IE
            var depth = g_nodeArray["depth"][nodeIdx].length;
            var src = document.getElementById(g_nodeid + nodeIdx).parentElement.children.item(depth - 1).src;

            if (src.indexOf(g_baseImageName["plus_normal"]) > 0 ||
		    src.indexOf(g_baseImageName["plus_end"]) > 0 ||
		    src.indexOf(g_baseImageName["minus_normal"]) > 0 ||
		    src.indexOf(g_baseImageName["minus_end"]) > 0)
                return true;
            else
                return false;
        }).call(this, nodeIdx);
    }

    // 기본 이벤트 동작
    this.onnodedblclick = function() { };
    this.onnodeselect = function() { };
    this.onrequestdata = function() { };

    
    // event
    // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
    function event_onselectstart(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
        if (!event) event = window.event;
        event.cancelBubble = true;
        event.returnValue = false;
    }

    function event_onmousedown(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        (navigator.userAgent.indexOf('MSIE') == -1) ?
	    (function(event) { // safari
	        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
	        if (!event) event = window.event;
	        var targetEl = event.target;
	        var elementid = targetEl.id;
	        //var elementid = window.event.srcElement.id;
	        if (elementid.indexOf(g_toggleid) == 0)
	            ex_toggle.call(this, elementid.split(g_toggleid)[1]);
	        else if (elementid.indexOf(g_nodeid) == 0)
	            ex_select.call(this, elementid.split(g_nodeid)[1]);
	    }).call(this, event) :
	    (function() { // IE
	        var elementid = window.event.srcElement.id;
	        if (elementid.indexOf(g_toggleid) == 0)
	            ex_toggle.call(this, elementid.split(g_toggleid)[1]);
	        else if (elementid.indexOf(g_nodeid) == 0)
	            ex_select.call(this, elementid.split(g_nodeid)[1]);
	    }).call(this);
    }

    function event_ondblclick(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        (navigator.userAgent.indexOf('MSIE') == -1) ?
	    (function(event) { // safari
	        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
	        if (!event) event = window.event;
	        //var elementid = window.event.srcElement.id;
	        var targetEl = event.target;
	        var elementid = targetEl.id;

	        if (elementid.indexOf(g_nodeid) == 0) {
	            //nodedblclick.fire();
	            this.onnodedblclick();
	        }
	    }).call(this, event) :
	    (function() { // IE
	        var elementid = window.event.srcElement.id;

	        if (elementid.indexOf(g_nodeid) == 0) {
	            //nodedblclick.fire();
	            this.onnodedblclick();
	        }
	    }).call(this);
    }

    function event_onmouseover(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        (navigator.userAgent.indexOf('MSIE') == -1) ?
	    (function(event) { // safari
	        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
	        if (!event) event = window.event;
	        //var elementid = window.event.srcElement.id;
	        var targetEl = event.target;
	        var elementid = targetEl.id;

	        if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "")
	            document.getElementById(elementid).className = g_baseClass["hover"];
	    }).call(this, event) :
	    (function() { // IE
	        var elementid = window.event.srcElement.id;

	        if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "")
	            document.getElementById(elementid).className = g_baseClass["hover"];
	    }).call(this);
    }

    function event_onmouseout(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        (navigator.userAgent.indexOf('MSIE') == -1) ?
	    (function(event) { // safari
	        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
	        if (!event) event = window.event;
	        var targetEl = event.target;

	        var elementid = targetEl.id;

	        if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "") {
	            if (g_selectedIdx == elementid.split(g_nodeid)[1]) {
	                document.getElementById(elementid).className = g_baseClass["selected"];
	            }
	            else {
	                document.getElementById(elementid).className = g_baseClass["normal"];
	            }
	        }
	    }).call(this, event) :
	    (function() { // IE
	        var elementid = window.event.srcElement.id;

	        if (elementid.indexOf(g_nodeid) == 0 && g_baseClass["hover"] != "") {
	            if (g_selectedIdx == elementid.split(g_nodeid)[1])
	                document.getElementById(elementid).className = g_baseClass["selected"];
	            else
	                document.getElementById(elementid).className = g_baseClass["normal"];
	        }
	    }).call(this);
    }

    function event_onkeydown(event) {
        if (this != window[thisid]) {
            arguments.callee.call(window[thisid], event);
            return;
        }
        (navigator.userAgent.indexOf('MSIE') == -1) ?
	    (function(event) { // safari
	        // firefox 에서는 window.event 가 없어서 event object를 arguments[0]로 받음
	        if (!event) event = window.event;
	        var targetEl = event.target;
	        try {
	            var href = targetEl.href;
	            // tab키(9) : 노드 이동 (웹브라우저 이동 패턴 사용)
	            // enter키(13) : 노드 선택 (웹브라우저의 노드 선택 패턴 사용)
	            // right arrow(39)/left(37) arrow 키 : 노드 expand/fold
	            if (event.keyCode == 39 || event.keyCode == 37) {
	                ex_select.call(this, href.split('#')[1]);
	                ex_toggle.call(this, get_selectedIndex());
	            }
	            if (event.keyCode == 13) {
	                ex_select.call(this, href.split('#')[1]);
	            }
	        }
	        catch (e) {
	            ;
	        }
	    }).call(this, event) :
	    (function() { // IE
	        try {
	            var href = window.event.srcElement.href;
	            // tab키(9) : 노드 이동 (웹브라우저 이동 패턴 사용)
	            // enter키(13) : 노드 선택 (웹브라우저의 노드 선택 패턴 사용)
	            // right arrow(39)/left(37) arrow 키 : 노드 expand/fold
	            if (window.event.keyCode == 39 || window.event.keyCode == 37) {
	                ex_select.call(this, href.split('#')[1]);
	                ex_toggle.call(this, get_selectedIndex());
	            }
	            if (window.event.keyCode == 13) {
	                ex_select.call(this, href.split('#')[1]);
	            }
	        }
	        catch (e) {
	            ;
	        }
	    }).call(this);
    }

    function event_onbeforeunload() {
        g_treeXML = null;
    }


    if (navigator.userAgent.indexOf('MSIE') == -1) {
        element.addEventListener('selectstart', event_onselectstart, false);
        element.addEventListener('mousedown', event_onmousedown, false);
        element.addEventListener('dblclick', event_ondblclick, false);
        element.addEventListener('mouseover', event_onmouseover, false);
        element.addEventListener('mouseout', event_onmouseout, false);
        element.addEventListener('keydown', event_onkeydown, false);
    }
    else {
        element.attachEvent('onselectstart', event_onselectstart);
        element.attachEvent('onmousedown', event_onmousedown);
        element.attachEvent('ondblclick', event_ondblclick);
        element.attachEvent('onmouseover', event_onmouseover);
        element.attachEvent('onmouseout', event_onmouseout);
        element.attachEvent('onkeydown', event_onkeydown);
    }
    
    
    var g_configXML = null;
    var g_treeXML = null;
    var g_nodeArray = { "nodeXML": new Array(), "depth": new Array() };
    var g_nodeCount = 0;
    var g_baseImage = new Array();
    var g_baseImageName = new Array();
    var g_baseClass = new Array();
    var g_images = new Array();
    var g_selectedIdx = -1;
    var g_toggleid = element.id + "_img_";
    var g_nodeid = element.id + "_node_";
    var g_childid = element.id + "_child_";
    var g_imageWidth = -1;
    var g_imageHeight = -1;
    var g_serverName = "";




    function make_childHtml(nodeIdx, nodeXML) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(nodeIdx, nodeXML) {
            // safari
            if (nodeIdx == 0)
                var depth = "";
            else
                var depth = g_nodeArray["depth"][nodeIdx];

            var childHtml = "<div>";
            var childLength = nodeXML.childElementCount; //nodeXML.length;

            var i = 0;
            var childNode = nodeXML.firstElementChild;
            while (childNode) {
                g_nodeCount++;

                var nodeCount = g_nodeCount;
                var mydepth = depth;
                var nodeHtml = "<div><div style='height:" + g_imageHeight + "px;overflow-y:hidden;' noWrap>";

                for (var j = 0; j < depth.length; j++) {
                    if (depth.charAt(j) == "1")
                        nodeHtml += ("<img src='" + g_baseImage["dot_continue"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                    else
                        nodeHtml += ("<img src='" + g_baseImage["space"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }

                var bEndNode = (i == childLength - 1) ? true : false;
                //if (childNode.selectSingleNode("ISLEAF").text == "FALSE") {
                if (findchildnodevalue(childNode, 'ISLEAF') == "FALSE") {
                    bParent = true;
                } else {
                    bParent = false;
                }


                nodeHtml += "<img src='";
                if (bParent) {
                    if (!bEndNode) {
                        //if (childNode.selectSingleNode("NODES") == null)
                        if (findchildnodevalue(childNode, 'NODES') == null) {
                            nodeHtml += g_baseImage["plus_normal"];
                        }
                        else {
                            nodeHtml += g_baseImage["minus_normal"];
                        }
                        mydepth += "1";
                    }
                    else {
                        //if (childNode.selectSingleNode("NODES") == null)
                        if (findchildnodevalue(childNode, 'NODES') == null) {
                            nodeHtml += g_baseImage["plus_end"];
                        }
                        else {
                            nodeHtml += g_baseImage["minus_end"];
                        }

                        mydepth += "0";
                    }

                    nodeHtml += ("' style='cursor:pointer' id='" + g_toggleid + nodeCount + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }
                else {
                    if (!bEndNode) {
                        nodeHtml += g_baseImage["dot_normal"];
                        mydepth += "1";
                    }
                    else {
                        nodeHtml += g_baseImage["dot_end"];
                        mydepth += "0";
                    }

                    nodeHtml += ("' id='" + g_toggleid + nodeCount + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }

                //if (childNode.selectSingleNode("SETNODEICONBYNAME") != null)
                if (findchildnodevalue(childNode, "SETNODEICONBYNAME") != null) {
                    //nodeHtml += ("<img src='" + g_images[childNode.selectSingleNode("SETNODEICONBYNAME").text] + "'>");
                    nodeHtml += ("<img src='" + g_images[findchildnodevalue(childNode, "SETNODEICONBYNAME")] + "'>");
                }
                else {
                    nodeHtml += ("<img src='" + g_images["BASE"] + "'>");
                }

                //if (childNode.selectSingleNode("SELECT") != null) {
                if (findchildnodevalue(childNode, "SELECT") != null) {
                    nodeHtml += ("<a href='#" + nodeCount + "'><span id='" + g_nodeid + nodeCount + "' class='" +
						g_baseClass["selected"] + "'>");
                    g_selectedIdx = nodeCount;
                }
                else {
                    nodeHtml += ("<a href='#" + nodeCount + "'><span id='" + g_nodeid + nodeCount + "' class='" +
						g_baseClass["normal"] + "'>");
                }

                //nodeHtml += (childNode.selectSingleNode("VALUE").text + "</span></a></div>");
                nodeHtml += (findchildnodevalue(childNode, "VALUE") + "</span></a></div>");

                g_nodeArray["nodeXML"][nodeCount] = new Array();
                /*
                for (var j = 0; j < childNode.childNodes.length; j++) {
                if (childNode.childNodes.item(j).nodeName != "NODES")
                g_nodeArray["nodeXML"][nodeCount][childNode.childNodes.item(j).nodeName] = childNode.childNodes.item(j).text;
                }*/
                var hasnodes = false;
                var subnode = null;
                iterator(childNode, function(node) {
                    if (node.nodeName != 'NODES') {
                        g_nodeArray["nodeXML"][nodeCount][node.nodeName] = node.firstChild.nodeValue;
                    }
                    if (node.nodeName == 'NODES') {
                        hasnodes = true;
                        subnode = node;
                    }
                });

                g_nodeArray["depth"][nodeCount] = mydepth;

                if (hasnodes) {
                    //nodeHtml += ("<span id='" + g_childid + nodeCount + "'>" + make_childHtml(nodeCount, childNode.selectSingleNode("NODES").selectNodes("NODE")) + "</span>");
                    nodeHtml += ("<span id='" + g_childid + nodeCount + "'>" + make_childHtml(nodeCount, subnode) + "</span>");
                    nodeHtml += "</div>"
                }
                else {
                    nodeHtml += ("<span style='display:none' id='" + g_childid + nodeCount + "'></span>");
                    nodeHtml += "</div>"
                }
                childHtml += nodeHtml;


                i++;
                childNode = childNode.nextElementSibling;
            }
            childHtml += "</div>"

            nodeXML = null;
            return childHtml;
        }).call(this, nodeIdx, nodeXML) :
        (function(nodeIdx, nodeXML) {
            // IE
            if (nodeIdx == 0)
                var depth = "";
            else
                var depth = g_nodeArray["depth"][nodeIdx];

            var childHtml = "<div>";
            var childLength = nodeXML.length;

            for (var i = 0; i < childLength; i++) {
                g_nodeCount++;

                var nodeCount = g_nodeCount;
                var mydepth = depth;
                var childNode = nodeXML.item(i);
                var nodeHtml = "<div><div style='height:" + g_imageHeight + "px;overflow-y:hidden;' noWrap>";

                for (var j = 0; j < depth.length; j++) {
                    if (depth.charAt(j) == "1")
                        nodeHtml += ("<img src='" + g_baseImage["dot_continue"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                    else
                        nodeHtml += ("<img src='" + g_baseImage["space"] + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }

                var bEndNode = (i == childLength - 1) ? true : false;
                if (childNode.selectSingleNode("ISLEAF").text == "FALSE") {
                    bParent = true;
                } else {
                    bParent = false;
                }

                nodeHtml += "<img src='";
                if (bParent) {
                    if (!bEndNode) {
                        if (childNode.selectSingleNode("NODES") == null)
                            nodeHtml += g_baseImage["plus_normal"];
                        else
                            nodeHtml += g_baseImage["minus_normal"];
                        mydepth += "1";
                    }
                    else {
                        if (childNode.selectSingleNode("NODES") == null)
                            nodeHtml += g_baseImage["plus_end"];
                        else
                            nodeHtml += g_baseImage["minus_end"];

                        mydepth += "0";
                    }

                    nodeHtml += ("' style='cursor:pointer' id='" + g_toggleid + nodeCount + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }
                else {
                    if (!bEndNode) {
                        nodeHtml += g_baseImage["dot_normal"];
                        mydepth += "1";
                    }
                    else {
                        nodeHtml += g_baseImage["dot_end"];
                        mydepth += "0";
                    }

                    nodeHtml += ("' id='" + g_toggleid + nodeCount + "' width='" + g_imageWidth + "' height='" + g_imageHeight + "'>");
                }

                if (childNode.selectSingleNode("SETNODEICONBYNAME") != null)
                    nodeHtml += ("<img src='" + g_images[childNode.selectSingleNode("SETNODEICONBYNAME").text] + "'>");
                else
                    nodeHtml += ("<img src='" + g_images["BASE"] + "'>");

                if (childNode.selectSingleNode("SELECT") != null) {
                    nodeHtml += ("<a href='#" + nodeCount + "'><span id='" + g_nodeid + nodeCount + "' class='" +
						g_baseClass["selected"] + "'>");
                    g_selectedIdx = nodeCount;
                }
                else
                    nodeHtml += ("<a href='#" + nodeCount + "'><span id='" + g_nodeid + nodeCount + "' class='" +
						g_baseClass["normal"] + "'>");

                nodeHtml += (childNode.selectSingleNode("VALUE").text + "</span></a></div>");

                g_nodeArray["nodeXML"][nodeCount] = new Array();
                for (var j = 0; j < childNode.childNodes.length; j++) {
                    if (childNode.childNodes.item(j).nodeName != "NODES")
                        g_nodeArray["nodeXML"][nodeCount][childNode.childNodes.item(j).nodeName] = childNode.childNodes.item(j).text;
                }

                g_nodeArray["depth"][nodeCount] = mydepth;

                if (childNode.selectSingleNode("NODES") != null) {
                    nodeHtml += ("<span id='" + g_childid + nodeCount + "'>" + make_childHtml(nodeCount, childNode.selectSingleNode("NODES").selectNodes("NODE")) + "</span>");
                    nodeHtml += "</div>"
                }
                else {
                    nodeHtml += ("<span style='display:none' id='" + g_childid + nodeCount + "'></span>");
                    nodeHtml += "</div>"
                }

                childHtml += nodeHtml;
                childNode = null;
            }
            childHtml += "</div>"

            nodeXML = null;
            return childHtml;
        }).call(this, nodeIdx, nodeXML);
    }

    function set_initvalue() {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function() {
            // safari

            var protocol = window.location.protocol;
            var serverName = window.location.hostname;

            var downloadPath = "";

            iterator(
                g_configXML.evaluate('tree/config/baseimage', g_configXML, null, XPathResult.ANY_TYPE, null).iterateNext(),
                function(node) {
                // nodeName 이 대문자이므로 소문자 변환
                var nodename = node.nodeName;
                var nodepathval = node.attributes.getNamedItem("path").nodeValue;

                g_baseImageName[nodename.toLowerCase()] = nodepathval.substr(nodepathval.lastIndexOf("/") + 1);
                downloadPath = protocol + "//" + serverName + nodepathval;
                g_baseImage[nodename.toLowerCase()] = downloadPath;
                }
            );

            iterator(
                g_configXML.evaluate('tree/config/images', g_configXML, null, XPathResult.ANY_TYPE, null).iterateNext(),
                function(node) {
                var nodepathvalue = node.attributes.getNamedItem("path").nodeValue;
                var nodeidxvalue = node.attributes.getNamedItem("idx").nodeValue;

                downloadPath = protocol + "//" + serverName + nodepathvalue;
                g_images[nodeidxvalue] = downloadPath;
            }
            );

            iterator(
                g_configXML.evaluate('tree/config/baseclass', g_configXML, null, XPathResult.ANY_TYPE, null).iterateNext(),
                function(node) {
                var nodename = node.nodeName;
                var nodenamevalue = node.attributes.getNamedItem("name").nodeValue;
                g_baseClass[nodename.toLowerCase()] = nodenamevalue;
            }
            );

            (function() {
                var sizenode = g_configXML.getElementsByTagName('size')[0];
                g_imageWidth = sizenode.attributes.getNamedItem("width").nodeValue;
                g_imageHeight = sizenode.attributes.getNamedItem("height").nodeValue;
            })();

        }).call(this) :
        (function() {
            // IE
            var bimageNodes = g_configXML.selectSingleNode("tree/config/baseimage").childNodes;
            var protocol = window.location.protocol;
            var serverName = window.location.hostname;

            var downloadPath = "";
            for (var i = 0; i < bimageNodes.length; i++) {
                g_baseImageName[bimageNodes.item(i).nodeName] = bimageNodes.item(i).attributes.getNamedItem("path").text.substr(bimageNodes.item(i).attributes.getNamedItem("path").text.lastIndexOf("/") + 1);
                downloadPath = protocol + "//" + serverName + bimageNodes.item(i).attributes.getNamedItem("path").text;
                g_baseImage[bimageNodes.item(i).nodeName] = downloadPath;
            }

            bimageNodes = null;

            var imageNodes = g_configXML.selectSingleNode("tree/config/images").childNodes;
            for (var i = 0; i < imageNodes.length; i++) {
                downloadPath = protocol + "//" + serverName + imageNodes.item(i).attributes.getNamedItem("path").text;
                g_images[imageNodes.item(i).attributes.getNamedItem("idx").text] = downloadPath;
            }

            imageNodes = null;

            var classNodes = g_configXML.selectSingleNode("tree/config/baseclass").childNodes;
            for (var i = 0; i < classNodes.length; i++)
                g_baseClass[classNodes.item(i).nodeName] = classNodes.item(i).attributes.getNamedItem("name").text;

            classNodes = null;

            g_imageWidth = g_configXML.selectSingleNode("tree/config/size").attributes.getNamedItem("width").text;
            g_imageHeight = g_configXML.selectSingleNode("tree/config/size").attributes.getNamedItem("height").text;
        }).call(this);
    }
    

    // 수정(2007.05.30) : 노드 추가가 정상적으로 처리되지 않아 함수 변경
    // 함수를 사용하는 페이지가 없음
    function changeRecursiveImg(node, bspace, depth, recuringCount) {
        return (navigator.userAgent.indexOf('MSIE') == -1) ?
        (function(node, bspace, depth, recuringCount) {
            // safari
            if (node.innerHTML == "")
                return;

            for (var i = 0; i < node.children.length; i++) {
                var child = node.children.item(i);

                if (child.innerHTML == "")
                    continue;

                if (bspace) {
                    child.children.item(depth).src = g_baseImage["space"];
                    var depthlist = g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "0" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                else {
                    child.children.item(depth).src = g_baseImage["dot_continue"];
                    var depthlist = g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "1" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                child = null;
            }
        }).call(this, node, bspace, depth, recuringCount) :
        (function(node, bspace, depth, recuringCount) {
            // IE
            if (node.innerHTML == "")
                return;

            for (var i = 0; i < node.children.length; i++) {
                var child = node.children.item(i);

                if (child.innerHTML == "")
                    continue;

                if (bspace) {
                    child.children.item(depth).src = g_baseImage["space"];
                    var depthlist = g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "0" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                else {
                    child.children.item(depth).src = g_baseImage["dot_continue"];
                    var depthlist = g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]];
                    depthlist = depthlist.substr(0, depth) + "1" + depthlist.substr(depth + 1, depthlist.length - depth - 1);
                    g_nodeArray["depth"][child.children.item(depth + 2 + recuringCount).children.item(0).id.split(g_nodeid)[1]] = depthlist;
                    changeRecursiveImg(child.children.item(1), bspace, depth, recuringCount + 1);
                }
                child = null;
            }
        }).call(this, node, bspace, depth, recuringCount);
    }
    
    function findchildnode(node, childnodename)
    {
        var childnode = node.firstElementChild;
        while (childnode)
        {
            if (childnode.nodeName.toLowerCase() == childnodename.toLowerCase())
            {
                return childnode;
            }            
            childnode = childnode.nextElementSibling;
        }        
        return null;
    }
    
    // IE 가 아닐때 selectSingleNode('nodename') 이 구문 안되어서 대신 만들었음
    function findchildnodevalue(node, childnodename) {
        var childnode = findchildnode(node, childnodename);
        if (childnode != null) {
            //return childnode.nodeValue;
            return childnode.firstChild.nodeValue;
        }
        return null;
    }
    
    function iterator(node, func)
    {
        var childnode = node.firstElementChild;
        while (childnode) {
            func(childnode);
            childnode = childnode.nextElementSibling;
        }        
    
    }
    
}



/*
</script>
</public:htc>
*/