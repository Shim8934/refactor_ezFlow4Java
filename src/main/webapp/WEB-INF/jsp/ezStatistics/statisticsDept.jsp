<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code='ezStatistics.t1040'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
	    <script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/TreeView.js')}"></script>
	    <script src="${util.addVer('/js/ezStatistics/js/raphael-min.js')}" type="text/javascript" charset="utf-8"></script>
	    <script src="${util.addVer('/js/ezStatistics/js/g.raphael.js')}" type="text/javascript" charset="utf-8"></script>
	    <script src="${util.addVer('/js/ezStatistics/js/g.pie.js')}" type="text/javascript" charset="utf-8"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <script type="text/javascript">
	        var xmlHttp = createXMLHttpRequest();
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
	        $(function () {
	            $("#Sdatepicker").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true
	            });
	            $("#Sdatepicker2").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true
	            });
	            var NowDate = new Date();
	            var NowDate2 = new Date();
	            NowDate2.setDate(NowDate2.getDate() - 10);
	            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker").datepicker('setDate', NowDate2);
	            $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker2").datepicker('setDate', NowDate);
	        });
	        
	        var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
	
	        window.onload = function () {
	            if (CrossYN())
	                document.getElementById("topmenu").style.cssFloat = "";
	            else {
	                document.getElementById("topmenu").style.whiteSpace = "nowrap";
	            }
	            getforminfo();
	        }
	
	        window.onload = function () {
	            if (CrossYN())
	                document.getElementById("topmenu").style.cssFloat = "";
	            else {
	                document.getElementById("topmenu").style.whiteSpace = "nowrap";
	            }
	
	            var xmlpara = createXmlDom();
	            var xmlTree = createXmlDom();
	            var xmlHTTP = createXMLHttpRequest();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
	            createNodeAndInsertText(xmlpara, objNode, "TOPID", "${companyID}");
	            createNodeAndInsertText(xmlpara, objNode, "PROP", "");
	            createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
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
	        var selNodeParentId;
	        function TreeViewNodeClick() {
	            var nodeIdx = 1;
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var selnode = treeView.GetSelectNode()
	            var selnodeId = treeView.GetSelectNodeID();
	            var selnodeLevel = selnode.GetNodeData("nodelevel");
	            selDeptID = selnode.GetNodeData("CN");
	            
	            selNodeParentId = selnode.GetNodeData("CN");
	            
	            for (var i =0 ;i < selnodeLevel ; i++ ) {
	     	      	if($("#" + selnodeId).parent().parent().attr("setnodeiconbyname")=="ICONCOMP"){
	     	      		selNodeParentId = $("#" + selnodeId).parent().parent().attr("cn");
	     	      		break;
	     	      	}
	     	      	selnodeId = $("#" + selnodeId).parent().parent().attr("id");
	            }
	            
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
	
	        /* 2019-02-21 홍승비 - 잘못된 기간으로 검색되지 않도록 재수정 (사용자 통계 참고) */
	        function getapprovalstatistics(mode) {
	        	
	        	var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        	var eDate = $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        	if (sDate > eDate) {
	        		if (mode != null && typeof(mode) != "undefined") {
		        		if (mode == "sDate") {
		        			$("#Sdatepicker2").val($("#Sdatepicker").val());
		        		}
		        		if (mode == "eDate") {
		        			$("#Sdatepicker").val($("#Sdatepicker2").val());
		        		}
	        		}
	        	}
	        	
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getStatisticsAprSearch.do",
					data : {
							company : selNodeParentId,
							endDate : $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
							startDate : $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
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
                if ("${userInfo.lang}" == "2") {
                    document.getElementById("eng").style.display = "inline-block";
                }
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

                var _Th = document.createElement("TH");
                _Th.innerHTML = "<spring:message code='ezStatistics.t83'/>";
                _Tr.appendChild(_Th);

                _Th = document.createElement("TH");
                _Th.innerHTML = "<spring:message code='ezStatistics.t1026'/>";
                _Tr.appendChild(_Th);

                _Th = document.createElement("TH");
                _Th.innerHTML = "<spring:message code='ezStatistics.t1027'/>";
                _Tr.appendChild(_Th);

                _Th = document.createElement("TH");
                _Th.innerHTML = "<spring:message code='ezStatistics.t1028'/>";
                _Tr.appendChild(_Th);

                _Th = document.createElement("TH");
                _Th.innerHTML = "<spring:message code='ezStatistics.t1029'/>";
                _Tr.appendChild(_Th);

                _Th = document.createElement("TH");
                _Th.style.width = "170px"
                _Th.innerHTML = "<spring:message code='ezStatistics.t1035'/>";
                
                if ("${userInfo.lang}" != "1") {
	                _Th.classList.add("processTimeTH");
                }
                
                _Tr.appendChild(_Th);

                _Table.appendChild(_Tr);

                for (var i = 0; i < SelectNodes(resultxml, "DATA/ROW").length; i++) {
                	console.log(resultxml);
                    var _Tr2 = document.createElement("TR");
                    var _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DISPLAYNAME"))
                    _Tr2.appendChild(_Td);

                    _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTCNT"));
                    _Tr2.appendChild(_Td);

                    _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTENDCNT"));
                    _Tr2.appendChild(_Td);

                    _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DRAFTINGCNT"));
                    _Tr2.appendChild(_Td);

                    _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "RETURNCNT"));
                    _Tr2.appendChild(_Td);

                    _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "DTIME"));
                    _Tr2.appendChild(_Td);

                    _Tr2.id = "formdata";
                    _Table.appendChild(_Tr2);
                }
                if (SelectNodes(resultxml, "DATA/ROW").length == 0)
                    return;

                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                drawingchart();
	        }
	
	        function drawingchart(obj) {
	            document.getElementById("statisticschart").innerHTML = "";
	            document.getElementById("chartdiv").style.display = "";
	
	            var data = new Array();
	            var data2 = new Array();
	
	            if (getnodetext(GetChildNodes(document.getElementById("formdata"))[1]) != "0") {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("formdata"))[1])));
	                data2.push("<spring:message code='ezStatistics.t1026'/>");
	            }
	            if (getnodetext(GetChildNodes(document.getElementById("formdata"))[2]) != "0") {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("formdata"))[2])));
	                data2.push("<spring:message code='ezStatistics.t1027'/>");
	            }
	            if (getnodetext(GetChildNodes(document.getElementById("formdata"))[3]) != "0") {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("formdata"))[3])));
	                data2.push("<spring:message code='ezStatistics.t1028'/>");
	            }
	            if (getnodetext(GetChildNodes(document.getElementById("formdata"))[4]) != "0") {
	                data.push(parseInt(getnodetext(GetChildNodes(document.getElementById("formdata"))[4])));
	                data2.push("<spring:message code='ezStatistics.t1029'/>");
	            }
	
	
	            var r = Raphael("statisticschart"),
	                     pie = r.piechart(320, 240, 200, data, { legend: data2, legendpos: "east" });
	            pie.hover(function () {
	                this.sector.stop();
	                if (this.sector.matrix.a < 1.05)
	                    this.sector.scale(1.1, 1.1, this.cx, this.cy);
	
	                if (this.label) {
	                    this.label[0].stop();
	                    this.label[0].attr({ r: 7.5 });
	                    this.label[1].attr({ "font-weight": 800 });
	                }
	            }, function () {
	                this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");
	
	                if (this.label) {
	                    this.label[0].animate({ r: 5 }, 500, "bounce");
	                    this.label[1].attr({ "font-weight": 400 });
	                }
	            });
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
	
	        var searchdept_cross_dialogArguments = new Array();
	        function searchdept() {
	            if (deptkeyword.value.trim() == "") {
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
	
	                var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDom.getElementsByTagName("DATA2").item(0)) + "</DEPTID><TOPID>Top</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	                
	
	                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            }
	            else {
	                var rgParams = new Array();
	                rgParams["addrBook"] = xmlDom;
	                rgParams["deptid"] = "";

	             	var agent = navigator.userAgent.toLowerCase(); 
	    			if (CrossYN()) {
	    				searchdept_cross_dialogArguments[0] = rgParams;
	    				searchdept_cross_dialogArguments[1] = SelelctDept_complite;
	    				var OpenWin = window.open("/ezStatistics/statisticsCheckName2.do", "", GetOpenWindowfeature(609, 372));    
	    				try { OpenWin.focus(); } catch (e) { }				
	    			} 
	    			else {
		                var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(540, 460);
		                window.showModalDialog("/ezStatistics/checkName2.do", rgParams, feature);
	    			}
	    			
	                if (rgParams["deptid"] != "") {
	                    bSearch = true;
	                    g_xmlHTTP = createXMLHttpRequest();
	                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                    g_xmlHTTP.send(strQuery);
	                }
	            }
	        }
	        
	        function SelelctDept_complite(deptid) {
	       	 if (deptid != "") {
	                bSearch = true;
	                g_xmlHTTP = createXMLHttpRequest();
	                var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            }
	       }
	
	        function event_getDeptFullTree() {
	            if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	                if (g_xmlHTTP.status == 200) {
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
	<body class="mainbody" style="text-align:left">
	    <h1><spring:message code='ezStatistics.t1040'/></h1>
	     <table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
	         <tr>
	             <td style="width: 99%">
	                 <span id="topmenu" style="float: left; width: 500px">
	                     &nbsp;<spring:message code='ezStatistics.t1002'/> : 
	             <input type="text" id="Sdatepicker" style="width: 80px; text-align: center" onchange="getapprovalstatistics('sDate')" readonly="readonly">
	                     ~ 
	             <input type="text" id="Sdatepicker2" style="width: 80px; text-align: center" onchange="getapprovalstatistics('eDate')" readonly="readonly">
	                     &nbsp;&nbsp;<spring:message code='ezStatistics.t1013'/> : 
	       		 <input id="deptkeyword" type="text" style="width: 100px;" onkeypress="search_press(event)" />
	                     <a class="imgbtn" style="height:22px"><span onclick="searchdept()"><spring:message code='ezStatistics.t36'/></span></a>
	                 </span>
	             </td>
	             <td>
	                 <div id="mainmenu" style="float: right; height: 28px;margin:3px 0px !important">
	                     <ul>
	                         <li><span class="btnexportexcel" style="width: 110px;text-align:center;background-color: white" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
	                     </ul>
	                 </div>
	             </td>
	         </tr>
	     </table>
	    <br />
	    <h2 id="ToTitle" class="receiver_tltype01" style="border:0px">
	        <span style="min-width: 45px;"><spring:message code='ezStatistics.t1014'/></span>
	    </h2>
	    <table style="width: 1150px;height:630px ;border:1px solid #ddd">
	      <tr>
	          <td style="vertical-align: top">
	              <div style="width: 300px; height: 630px; overflow-x: auto; overflow-y: auto;border-right:1px solid #ddd;" id="TreeView"></div>
	          </td>
	          <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
	              <div id="viewdata">
	                  <div id="chartdiv" style="width: 100%; text-align: center;">
	                      <div id="statisticschart" style="width: 800px; height: 500px; float: left; font-size: 16px;">
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
	                <div id="nodata" class="statistics_nodata" style="display: none; margin: 0 auto">
	                    <dl class="statistics_txt">
	                        <dt><spring:message code='ezStatistics.t1008'/></dt>
	                        <dd><spring:message code='ezStatistics.t1009'/></dd>
	                    </dl>
	                </div>
	          </td>
	      </tr>
	    </table>
	    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXlsApproval.do">
	        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
	        <input type="hidden" id="userAgent" name="userAgent" value="">
	    </form>
	    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	    </script>
	</body>
</html>