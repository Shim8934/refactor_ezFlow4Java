<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code='ezStatistics.t1037'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezStatistics.e2'/>" type="text/css" />
	    <link rel="stylesheet" href="/js/ezStatistics/js/jquery.jqplot.min.css" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezStatistics.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezStatistics/control_Cross/TreeView.js"></script>
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
	
	        var selDeptID;
	        function TreeViewNodeClick() {
	            var nodeIdx = 1;
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var selnode = treeView.GetSelectNode();
	            selDeptID = selnode.GetNodeData("CN");
	            getapprovalstatistics();
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
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getStatisticsAprTime.do",
					data : {
							company : "",
							date : document.getElementById("selyear").value,
							searchID : selDeptID,
							type : "DEPT"
							},
					success: function(text) {
						event_getapprovalstatistics(text);
					}        			
				});
	        }
	
	        function event_getapprovalstatistics(text) {
                document.getElementById("statisticstable").innerHTML = "";
                document.getElementById("colorbox").style.display = "";
                var resultxml = loadXMLString(text);

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
                var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");

                for (var i = 1; i < 13; i++) {
                    var _Th = document.createElement("TH");
                    _Th.innerHTML = ticks[i - 1];

                    if (i < 7) {
                        _Tr.appendChild(_Th);
                    }
                    else {
                        _Tr2.appendChild(_Th);
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

                    if (regdate == document.getElementById("selyear").value + "-" + mon && (i == 0 || formid == getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i - 1], "CN")))) {
                        _Td = document.createElement("TD");
                        _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DTIME"));
                    }
                    else {
                        _Td = document.createElement("TD");
                        _Td.innerHTML = "0";
                        i--;
                    }
                    if (j < 6) {
                        _Tr3.appendChild(_Td);
                    }
                    else {
                        _Tr4.appendChild(_Td);
                    }
                    j++;
                }

                for (; j < 12; j++) {
                    _Td = document.createElement("TD");
                    _Td.innerHTML = "0";

                    if (j < 6) {
                        _Tr3.appendChild(_Td);
                    }
                    else {
                        _Tr4.appendChild(_Td);
                    }
                }
                _Tr3.id = "mon";
                _Tr4.id = "mon2";

                _Table.appendChild(_Tr);
                _Table.appendChild(_Tr3);
                _Table.appendChild(_Tr2);
                _Table.appendChild(_Tr4);

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
	                data.push(parseFloat(getnodetext(GetChildNodes(document.getElementById("mon"))[i])));
	            }
	            for (var i = 0; i < 6; i++) {
	                data.push(parseFloat(getnodetext(GetChildNodes(document.getElementById("mon2"))[i])));
	            }
	
	            var ticks = "<spring:message code='ezStatistics.t218'/>".split(";");
	            plot2 = $.jqplot('statisticschart', [data], {
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
	                    searchdept();
	                }
	            }
	            else {
	                if (e.which == 13)
	                    searchdept();
	            }
	        }
	
	        function searchdept() {
	            if (deptkeyword.value == "") {
	                alert("<spring:message code='ezStatistics.t1010'/>");
	                deptkeyword.focus();
	                return;
	            }
	            var xmlDom = createXmlDom();
	            
            	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezOrgan/getSearchList.do",
            		data : {
            			search : "displayname::" + deptkeyword.value,
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
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezStatistics.t1037'/></h1>
	    <table style="width: 100%; background-color: #e9e9e9; border: 1px solid #d3d2d2; margin-bottom: 5px">
	        <tr>
	            <td style="width: 99%">
	                <span id="topmenu" style="float: left; width: 500px"><spring:message code='ezStatistics.t1002'/> : 
	            <select id="selyear" onchange="makeoptionyear(); getapprovalstatistics()"></select>
	                    <spring:message code='ezStatistics.t55'/>
	       &nbsp;&nbsp;<spring:message code='ezStatistics.t1013'/> : 
	             <input id="deptkeyword" type="text" style="width: 100px" onkeypress="search_press(event)" />
	                    <a class="imgbtn" style="vertical-align: middle"><span onclick="searchdept()"><spring:message code='ezStatistics.t36'/></span></a>
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
	  <table style="width: 1150px;height:630px ;border:1px solid #b6b6b6">
	      <tr>
	          <td style="vertical-align: top">
	              <div style="width: 300px; height: 630px; overflow-x: auto; overflow-y: auto;border-right:1px solid #b6b6b6;" id="TreeView"></div>
	          </td>
	          <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
	             <div id="viewdata">
	                 <div id="colorbox" class="statistics_addition" style="display: none">
	                     <dl>
	                         <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
	                         <dd class="additiontext"><spring:message code='ezStatistics.t1035'/>(<spring:message code='ezStatistics.t57'/>)</dd>
	                     </dl>
	                 </div>
	                    <div id="chartdiv" style="width: 100%; text-align: center;">
	                      <div id="statisticschart" style="width: 800px; height: 500px; float: left; font-size: 16px;">
	                      </div>
	                  </div>
	                    <div id="statisticstable"></div>
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