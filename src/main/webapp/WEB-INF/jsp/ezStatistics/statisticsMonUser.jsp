<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code='ezStatistics.t1034'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezStatistics.e2'/>" type="text/css" />
	    <link rel="stylesheet" href="/js/ezStatistics/js/jquery.jqplot.min.css" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezStatistics.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/control_Cross/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/control_Cross/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/js/excanvas.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/js/jquery.min.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/js/jquery.jqplot.min.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/js/jqplot.barRenderer.min.js"></script>
	    <script type="text/javascript">
	        var xmlHttp = createXMLHttpRequest();
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
	        window.onload = function () {
	            if (CrossYN())
	                document.getElementById("topmenu").style.cssFloat = "";
	            else
	                document.getElementById("topmenu").style.whiteSpace = "nowrap";
	
	            makeoptionyear();
	
	            var xmlpara = createXmlDom();
	            var xmlTree = createXmlDom();
	            var xmlHTTP = createXMLHttpRequest();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
	            createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
	            createNodeAndInsertText(xmlpara, objNode, "PROP", "");
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	            xmlTree = loadXMLString(xmlHTTP.responseText);
	            
	            var treeXML = loadXMLFile("/xml/organtree_config3.xml");
	            document.getElementById('TreeView').innerHTML = "";
	            
	            var treeView = new TreeView();
	            treeView.SetConfig(treeXML);
	            treeView.SetID("FromTreeView");
	            treeView.SetUseAgency(true);
	            treeView.SetRequestData("RequestData");
	            treeView.SetNodeClick("TreeViewNodeClick");
	            treeView.DataSource(xmlTree);
	            treeView.DataBind("TreeView");
	        }
	
	        function TreeViewNodeClick() {
	            var nodeIdx = 1;
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var selnode = treeView.GetSelectNode();
	            DeptID = selnode.GetNodeData("CN");
	            displayUserList(DeptID);
	        }
	
	        function RequestData(pNodeID, pTreeID) {
	            var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            var deptID = treeNode.GetNodeData("CN");
	            GetDeptSubTreeInfo(deptID, TreeIdx);
	        }
	
	        function GetDeptSubTreeInfo(deptID, TreeIdx) {
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlRtn = createXmlDom();
	            var xmlpara = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
	            createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");
	
	
	            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	
	
	            xmlRtn = loadXMLString(xmlHTTP.responseText);
	            {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
	                }
	            }
	
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        function displayUserList(DeptID) {
	    		$.ajax({
	    			type : "POST",
	    			dataType : "text",
	    			async : false,
	    			url : "/ezOrgan/getDeptMemberList.do",
	    			data : {
	    					deptID   : DeptID, 
	    					cell 	 : "displayName;description",
	    					prop     : "department;displayName;description;title",
	    					type 	 : "user"
	    					},
	    			success: function(text){
		                var retXml = createXmlDom();
		
		                if (document.getElementById("UserList").innerHTML != "")
		                    document.getElementById("UserList").innerHTML = "";
		
		                var headerData = createXmlDom();
		                headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
		                
		                if (text != "") {
		                    var xmlRtn = loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0];
		                        headerData.documentElement.appendChild(xmlRtn);
		                }
		                
		                var pUserList = new ListView();
		                pUserList.SetID("lvUserList");
		                pUserList.SetRowOnClick("getapprovalstatistics");
		                pUserList.SetSelectFlag(false);
		                pUserList.SetHeightFree(true);
		                pUserList.DataSource(headerData);
		                pUserList.DataBind("UserList");
	    			},
	    			error: function() {
		                OpenAlertUI(linealt2);
	    			}
	    		});
	        }
	
	        var isfirst = true;
	        var tempyear;
	        function makeoptionyear() {
	            var date = new Date()
	            var year = date.getFullYear();
	
	            if (isfirst) {
	                tempyear = year;
	                for (var i = 0; i < 5; i++) {
	                    var option = document.createElement("OPTION");
	                    option.value = year;
	                    option.innerHTML = year;
	
	                    document.getElementById("selyear").appendChild(option);
	                    year--;
	                }
	                isfirst = false;
	            }
	            else {
	                var selyear = parseInt(document.getElementById("selyear").value);
	                if ((selyear < tempyear - 2 || selyear < tempyear + 2) && selyear + 2 <= year) {
	                    document.getElementById("selyear").innerHTML = "";
	                    tempyear = selyear + 2;
	                    for (var i = 0; i < 5; i++) {
	                        var option = document.createElement("OPTION");
	                        option.value = tempyear;
	                        option.innerHTML = tempyear;
	
	                        if (selyear == tempyear)
	                            option.selected = true;
	
	                        document.getElementById("selyear").appendChild(option);
	                        tempyear--;
	                    }
	                    tempyear = selyear + 2;
	                }
	            }
	        }
	
	        function getapprovalstatistics() {
	            var pUserList = new ListView();
	            pUserList.LoadFromID("lvUserList");
	
	            if (pUserList.GetSelectedRows().length == 0)
	                return;
	            
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getStatisticsAprMon.do",
					data : {
							company : "",
							date : document.getElementById("selyear").value,
							searchID : GetAttribute(pUserList.GetSelectedRows()[0],"DATA2"),
							type : "USER"
							},
					success: function(text) {
						event_getapprovalstatistics(text);
					}        			
				});
	        }
	
	        function event_getapprovalstatistics(text) {
                document.getElementById("statisticstable").innerHTML = "";
                document.getElementById("colorbox").style.display = "";
                if ("${userInfo.lang}" == "2") {
                    document.getElementById("eng").style.display = "inline-block";
                    document.getElementById("colordra").innerHTML = "Draft";
                    document.getElementById("colorapp").innerHTML = "Approval";
                    document.getElementById("colorpro").innerHTML = "Progress";
                    document.getElementById("colorrej").innerHTML = "Rejecting";
                }

                var resultxml = loadXMLString(text);

                document.getElementById("seluser").style.display = "none";
                if (SelectNodes(resultxml, "DATA/ROW").length == 0) {
                    document.getElementById("nodata").style.display = "";
                    document.getElementById("viewdata").style.display = "none";
                    return;
                }
                document.getElementById("nodata").style.display = "none";
                document.getElementById("viewdata").style.display = "";

                var _Table = document.createElement("TABLE");
                _Table.style.textAlign = "center";
                _Table.style.width = "100%";
                _Table.className = "tstyle2";
                _Table.style.border = "1px solid #dadada"

                var _Tr = document.createElement("TR");
                var _Tr2 = document.createElement("TR");
                var _Tr3 = document.createElement("TR");
                var _Tr4 = document.createElement("TR");
                var _Tr5 = document.createElement("TR");
                var _Tr6 = document.createElement("TR");
                var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");

                for (var i = 1; i < 13; i++) {
                    var _Th = document.createElement("TH");
                    _Th.colSpan = "4";
                    _Th.innerHTML = ticks[i - 1];

                    var _Th2 = document.createElement("TH");
                    _Th2.style.whiteSpace = "normal";
                    _Th2.innerHTML = "<spring:message code='ezStatistics.t1026'/>";

                    var _Th3 = document.createElement("TH");
                    _Th3.style.whiteSpace = "normal";
                    _Th3.innerHTML = "<spring:message code='ezStatistics.t1027'/>";

                    var _Th4 = document.createElement("TH");
                    _Th4.style.whiteSpace = "normal";
                    _Th4.innerHTML = "<spring:message code='ezStatistics.t1028'/>";

                    var _Th5 = document.createElement("TH");
                    _Th5.style.whiteSpace = "normal";
                    _Th5.innerHTML = "<spring:message code='ezStatistics.t1029'/>";

                    if (i < 7) {
                        _Tr.appendChild(_Th);
                        _Tr2.appendChild(_Th2);
                        _Tr2.appendChild(_Th3);
                        _Tr2.appendChild(_Th4);
                        _Tr2.appendChild(_Th5);
                    }
                    else {
                        _Tr3.appendChild(_Th);
                        _Tr4.appendChild(_Th2);
                        _Tr4.appendChild(_Th3);
                        _Tr4.appendChild(_Th4);
                        _Tr4.appendChild(_Th5);
                    }
                }

                var j = 0;
                for (var i = 0; i < SelectNodes(resultxml, "DATA/ROW").length; i++) {
                    var formid = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "CN"));
                    var regdate = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "REGDATE"));
                    var mon;
                    if (j + 1 < 10)
                        mon = "0" + (j + 1);
                    else
                        mon = j + 1;

                    var _Td = document.createElement("TD");
                    var _Td2 = document.createElement("TD");
                    var _Td3 = document.createElement("TD");
                    var _Td4 = document.createElement("TD");

                    if (regdate == document.getElementById("selyear").value + "-" + mon && (i == 0 || formid == getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i - 1], "CN")))) {
                        _Td = document.createElement("TD");
                        _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTCNT"));

                        _Td2 = document.createElement("TD");
                        _Td2.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTENDCNT"))

                        _Td3 = document.createElement("TD");
                        _Td3.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTINGCNT"));

                        _Td4 = document.createElement("TD");
                        _Td4.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "RETURNCNT"));
                    }
                    else {
                        _Td = document.createElement("TD");
                        _Td.innerHTML = "0";

                        _Td2 = document.createElement("TD");
                        _Td2.innerHTML = "0";

                        _Td3 = document.createElement("TD");
                        _Td3.innerHTML = "0";

                        _Td4 = document.createElement("TD");
                        _Td4.innerHTML = "0";
                        i--;
                    }
                    if (j < 6) {
                        _Tr5.appendChild(_Td);
                        _Tr5.appendChild(_Td2);
                        _Tr5.appendChild(_Td3);
                        _Tr5.appendChild(_Td4);
                    }
                    else {
                        _Tr6.appendChild(_Td);
                        _Tr6.appendChild(_Td2);
                        _Tr6.appendChild(_Td3);
                        _Tr6.appendChild(_Td4);
                    }
                    j++;
                }

                for (; j < 12; j++) {
                    _Td = document.createElement("TD");
                    _Td.innerHTML = "0";

                    _Td2 = document.createElement("TD");
                    _Td2.innerHTML = "0";

                    _Td3 = document.createElement("TD");
                    _Td3.innerHTML = "0";

                    _Td4 = document.createElement("TD");
                    _Td4.innerHTML = "0";

                    if (j < 6) {
                        _Tr5.appendChild(_Td);
                        _Tr5.appendChild(_Td2);
                        _Tr5.appendChild(_Td3);
                        _Tr5.appendChild(_Td4);
                    }
                    else {
                        _Tr6.appendChild(_Td);
                        _Tr6.appendChild(_Td2);
                        _Tr6.appendChild(_Td3);
                        _Tr6.appendChild(_Td4);
                    }
                }
                _Tr5.id = "mon";
                _Tr6.id = "mon2";

                _Table.appendChild(_Tr);
                _Table.appendChild(_Tr2);
                _Table.appendChild(_Tr5);
                _Table.appendChild(_Tr3);
                _Table.appendChild(_Tr4);
                _Table.appendChild(_Tr6);

                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                drawingchart();
	        }
	
	        function drawingchart(obj) {
	            document.getElementById("statisticschart").innerHTML = "";
	            document.getElementById("chartdiv").style.display = "";
	
	            var data = new Array();
	            var data2 = new Array();
	            var data3 = new Array();
	            var data4 = new Array();
	            for (var i = 0; i < 6; i++) {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon"))[i * 4])));
	                data2.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon"))[i * 4 + 1])));
	                data3.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon"))[i * 4 + 2])));
	                data4.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon"))[i * 4 + 3])));
	            }
	            for (var i = 0; i < 6; i++) {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon2"))[i * 4])));
	                data2.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon2"))[i * 4 + 1])));
	                data3.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon2"))[i * 4 + 2])));
	                data4.push(parseInt(getnodetext(GetChildNodes(document.getElementById("mon2"))[i * 4 + 3])));
	            }
	
	            var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");
	            plot2 = $.jqplot('statisticschart', [data, data2, data3, data4], {
	                animate: true,
	                seriesDefaults: {
	                    renderer: $.jqplot.BarRenderer,
	                    pointLabels: { show: true }
	                },
	                axes: {
	                    xaxis: {
	                        renderer: $.jqplot.CategoryAxisRenderer, ticks: ticks
	                    }
	                }
	            });
	        }
	
	        function btnexportexcel_onclick() {
	            document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
	            document.getElementById("formAgent").target = "saveExcel";
	            document.getElementById("formAgent").submit();
	        }
	
	        function getnodetext(obj) {
	            if (CrossYN())
	                return obj.textContent;
	            else
	                if (obj.text == undefined)
	                    return obj.innerText;
	                else
	                    return obj.text;
	        }
	
	        function search_press(e) {
	            if (window.event) {
	                if (window.event.keyCode == 13) {
	                    search();
	                }
	            }
	            else {
	                if (e.which == 13)
	                    search();
	            }
	        }
	
	        function search() {
	            if (document.getElementById("searchopt").value == "1")
	                searchuser();
	            else
	                searchdept();
	        }
	
	        function searchdept() {
	            if (keyword.value == "") {
	                alert("<spring:message code='ezStatistics.t1010'/>");
	                keyword.focus();
	                return;
	            }
	            var xmlDom = createXmlDom();
	            
	            $.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezOrgan/getSearchList.do",
            		data : {
            			search : "displayname::" + keyword.value,
            			cell   : "extensionAttribute3;displayName;extensionAttribute9",
            			prop   : "",
            			type   : "group"
            		},
            		success: function(text) {
            			xmlDom = loadXMLString(text);
            			adCount = xmlDom.getElementsByTagName("ROW").length;
            		},
            		error: function() {
            			alert(strLang17);
            			xmlDom = null;
            		}
            	});
	            
	            if (adCount == 0) {
	                alert("<spring:message code='ezStatistics.t1011'/>");
	                return;
	            }
	            else if (adCount == 1) {
	                bSearch = true;
	                g_xmlHTTP = createXMLHttpRequest();
	
	                var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDom.getElementsByTagName("DATA2").item(0)) + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	                
	                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            }
	            else {
	                var rgParams = new Array();
	                rgParams["addrBook"] = xmlDom;
	                rgParams["deptid"] = "";
	                var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	                feature = feature + GetShowModalPosition(540, 460);
	                window.showModalDialog("/ezStatistics/checkName2.do", rgParams, feature);
	
	                if (rgParams["deptid"] != "") {
	                    bSearch = true;
	                    g_xmlHTTP = createXMLHttpRequest();
	                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                    g_xmlHTTP.send(strQuery);
	                }
	            }
	        }
	
	        function event_getDeptFullTree() {
	            if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	                if (g_xmlHTTP.statusText == "OK") {
	                    if (!bSearch) {
	                        try {
	                            if (CrossYN())
	                                opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
	                            else
	                                window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
	                        } catch (e) { }
	                    }
	
	                    var treeXML = loadXMLFile("/xml/organtree_config3.xml");
	                    document.getElementById('TreeView').innerHTML = "";
	
	                    var treeView = new TreeView();
	                    treeView.SetConfig(treeXML);
	                    treeView.SetID("FromTreeView");
	                    treeView.SetUseAgency(true);
	                    treeView.SetRequestData("RequestData");
	                    treeView.SetNodeClick("TreeViewNodeClick");
	                    treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
	                    treeView.DataBind("TreeView");
	                }
	                else {
	                    alert(g_xmlHTTP.statusText)
	                    g_xmlHTTP = null;
	                }
	            }
	        }
	
	        function searchuser() {
	            if (keyword.value == "") {
	                alert("<spring:message code='ezStatistics.t1010'/>");
	                keyword.focus();
	                return;
	            }
	            
	            $.ajax({
            		type : "POST",
            		dataType : "text",
            		async : true,
            		url : "/ezOrgan/getSearchList.do",
            		data : {
            			search : "displayName::" + keyword.value,
            			cell   : "displayName;description",
            			prop   : "department;displayName;description;title",
            			type   : "user"
            		},
            		success: function(text) {
            			event_displayUserList2(text);
            		}
            	});
	            
	        }
	        function event_displayUserList2(text) {
                 if (loadXMLString(text).getElementsByTagName("ROW").length == 0)
                     alert("<spring:message code='ezStatistics.t1016'/>");
                 else {
                     var retXml = createXmlDom();

                     if (document.getElementById("UserList").innerHTML != "")
                         document.getElementById("UserList").innerHTML = "";

                     var headerData = createXmlDom();
                     headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                     
                     if (text != "") {
                         var xmlRtn = loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0];
                         headerData.documentElement.appendChild(xmlRtn);
                     }
                     
                     var pUserList = new ListView();
                     pUserList.SetID("lvUserList");
                     pUserList.SetRowOnClick("getapprovalstatistics");
                     pUserList.SetSelectFlag(false);
                     pUserList.SetHeightFree(true);
                     pUserList.DataSource(headerData);
                     pUserList.DataBind("UserList");
                 }
	        }
	    </script>
	</head>
	<body class="mainbody">
	    <xml id="userlist_h" style="display: none">
	    <LISTVIEWDATA>
	    <HEADERS>
	        <HEADER>
	        <NAME><spring:message code='ezStatistics.t1017'/></NAME>
	        <WIDTH>70</WIDTH>
	        </HEADER>
	        <HEADER>
	        <NAME><spring:message code='ezStatistics.t113'/></NAME>
	        <WIDTH>100</WIDTH>
	        </HEADER>
	    </HEADERS>
	    <ROWS></ROWS>
	    </LISTVIEWDATA>
	</xml>
	    <h1><spring:message code='ezStatistics.t1034'/></h1>
	     <table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2; margin-bottom: 5px">
	         <tr>
	             <td style="width: 99%">
	                 <span id="topmenu" style="float: left; width: 500px"><spring:message code='ezStatistics.t1002'/> : 
	            <select id="selyear" onchange="makeoptionyear(); getapprovalstatistics()"></select>
	                     <spring:message code='ezStatistics.t55'/>
	          &nbsp;&nbsp;
	         <select id="searchopt">
	             <option value="1"><spring:message code='ezStatistics.t1017'/></option>
	             <option value="2"><spring:message code='ezStatistics.t113'/></option>
	         </select>
	                     <input id="keyword" type="text" style="width: 100px" onkeypress="search_press(event)" />
	                     <a class="imgbtn" style="vertical-align: middle"><span onclick="search()"><spring:message code='ezStatistics.t36'/></span></a>
	                 </span>
	             </td>
	             <td>
	                 <div id="mainmenu" style="float: right; height: 28px; width: 110px">
	                     <ul>
	                         <li><span onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
	                     </ul>
	                 </div>
	             </td>
	         </tr>
	     </table>
	    <br />
	    <h2 id="ToTitle" class="receiver_tltype01" style="border:0px">
	        <span style="min-width: 45px;"><spring:message code='ezStatistics.t1014'/></span>
	    </h2>
	  <table style="width: 1250px;height:680px ;border:1px solid #b6b6b6"> 
	        <tr>
	            <td style="vertical-align:top">
	                <div style="width:310px;height:330px;overflow-x:auto;overflow-y:auto;border-right:1px solid #b6b6b6;" id="TreeView" ></div>
	                <div id="UserList" style="Width: 310px; Height: 350px; overflow: auto;border-right:1px solid #b6b6b6"></div>
	            </td>
	            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
	               <div id="viewdata" style="display:none">
	                    <div id="colorbox" class="statistics_addition" style="display: none">
	                        <dl>
	                            <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
	                            <dd id="colordra" class="additiontext"><spring:message code='ezStatistics.t1026'/></dd>
	                        </dl>
	                        <dl>
	                            <dt class="colorbox_wrap"><span style="background: #eaa229" class="colorbox"></span></dt>
	                            <dd id="colorapp" class="additiontext"><spring:message code='ezStatistics.t1027'/></dd>
	                        </dl>
	                        <dl>
	                            <dt class="colorbox_wrap"><span style="background: #c2b483" class="colorbox"></span></dt>
	                            <dd id="colorpro" class="additiontext"><spring:message code='ezStatistics.t1028'/></dd>
	                        </dl>
	                        <dl>
	                            <dt class="colorbox_wrap"><span style="background: #58966f" class="colorbox"></span></dt>
	                            <dd id="colorrej" class="additiontext"><spring:message code='ezStatistics.t1029'/></dd>
	                        </dl>
	                    </div>
	                   <div id="chartdiv" style="width: 100%; text-align: center; display: none;">
	                       <div id="statisticschart" style="width: 900px; height: 490px; float: left; font-size: 16px;">
	                       </div>
	                   </div>
	                   <div id="eng" style="display: none; float: left">
	                       <br />
	                       <span style="padding-right: 5px">D = Draft</span>
	                       <span style="padding-right: 5px">A = Approval</span>
	                       <span style="padding-right: 5px">P = Progress</span>
	                       <span>R = Rejecting</span>
	                   </div>
	                    <div id="statisticstable"></div>
	                </div>
	                <div id="seluser" class="statistics_select" style="margin: 0 auto">
	                    <dl class="statistics_txt">
	                        <dt><spring:message code='ezStatistics.t1019'/></dt>
	                        <dd><spring:message code='ezStatistics.t1020'/><br>
	                            <spring:message code='ezStatistics.t1021'/></dd>
	                    </dl>
	                </div>
	                <div id="nodata" class="statistics_nodata" style="display: none; margin: 0 auto">
	                    <dl class="statistics_txt">
	                        <dt><spring:message code='ezStatistics.t1008'/></dt>
	                        <dd><spring:message code='ezStatistics.t1009'/></dd>
	                    </dl>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/excelExportOut.do">
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
	        <input type="hidden" id="userAgent" name="userAgent" value="">
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>