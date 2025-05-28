<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t1012' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">    
    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/excanvas.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.barRenderer.min.js')}"></script>    
<!--     <script type="text/javascript" src="${util.addVer('/js/showModalDialog.js')}"></script>     -->
    <script type="text/javascript">
    var xmlHttp = null;
    var Tab1_flag = true;
    var adminCompany = "${adminCompany}";
    var typeId = "";
	
	document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
            return false;
        } else {
            return true;
        }
    };
	
    window.onload = function () {
        if (CrossYN()) {
            document.getElementById("topmenu").style.cssFloat = "";
        } else {
            document.getElementById("topmenu").style.whiteSpace = "nowrap";
        }

      	//년도 설정(조회기간)
        makeoptionyear();

        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${deptId}");
        createNodeAndInsertText(xmlpara, objNode, "TOPID", "${companyId}");
        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2");
        createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(xmlpara);
        xmlTree = loadXMLString(xmlHTTP.responseText);
        var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
        document.getElementById('TreeView').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetConfig(treeXML);
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestData");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.DataSource(xmlTree);
        treeView.DataBind("TreeView");
        
        //처음 select는 관리자로 되어있으니까 관리자 회사의 근태유형 출력.
        company_typeList(adminCompany, typeId);
    }

    //조직도 회사/부서 클릭시
    var selDeptID;
    var selDeptName;
    function TreeViewNodeClick() {
        var nodeIdx = 1;
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");
        var selnode = treeView.GetSelectNode();
        selDeptID = selnode.GetNodeData("CN");
        selDeptName = selnode.GetNodeData("value");
        
		//부서별 근태유형 리스트
        company_typeList(selnode.GetNodeData("extensionattribute2"), typeId);
        //통계
        getAttitudeStatistics();
    }

    //[+] 버튼
    function RequestData(pNodeID, pTreeID) {
        var TreeIdx = pNodeID;
        var treeNode = new TreeNode();
        treeNode.LoadFromID(TreeIdx);
        var deptID = treeNode.GetNodeData("CN");
        GetDeptSubTreeInfo(deptID, TreeIdx);
    }

    //하위부서 정보
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

    //조회기간 년도 (현재년도에서 -5년까지)
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
            document.getElementById("selyear").innerHTML = "";
            tempyear = selyear + 2;
            for (var i = 0; i < 5; i++) {
            	if (tempyear > year) {
                	tempyear--;
                	continue;
                }
            	
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
    
    //회사 클릭시마다 근태유형 selectbox 변경
    function company_typeList(companyId, typeId) {
    	if (companyId == null || companyId == "") {
    		return;
    	}
    	if (typeId == null || typeId == "") {
    		typeId = 'A01';
    	}
    	$.ajax({
        	type : "POST",
        	dataType : "json",
        	url : "/ezStatistics/attitudeTypeList.do",
        	async : false,
        	data : {companyId : companyId},
        	success : function(result){
        		var html = "";
        		if (result.length != null && result.length != 0) {
	                for (var i = 0; i < result.length; i++) {
		        		html += "<option value='" + result[i].typeId + "'>" + result[i].typeName + "</option>";
	                }
        		}
        		$("#attitudeType").html(html);
        		if(typeId != "" || typeId != null) {
        			$("#attitudeType").val(typeId);
        		}
        	},
        	error : function(error){
//         		OpenAlertUI(linealt2 + error)
        	}
        });
    }

    //부서클릭시
    function getAttitudeStatistics() {
    	typeId = $("#attitudeType").val();
    	if (typeId == null || typeId == "") {
    		typeId = 'A01';
    	}
    	$.ajax({
        	type : "POST",
        	dataType : "json",
        	url : "/ezStatistics/getAttitudeDept.do",
        	async : false,
        	data : {deptId : selDeptID, typeId : typeId, year : $("#selyear").val() },
        	success : function(result){
        		event_getAttitudeStatistics(result);
        		chartTable(result, selDeptName);
        		
//         		$("#attitudeType").val(typeId);
        	},
        	error : function(error){
        		
        	}
        });
    }
    
    function event_getAttitudeStatistics(result) {
        $("#statisticschart").html("");
        $("#statisticstable").html("");
        $("#chartdiv").css({"display":"none"});

	    var data = new Array();
	    var zeroCnt = 0;
        for (var i = 0; i < result.length; i++) {
        	data.push(result[i].count);
        	
        	if (result[i].count == 0) {
        		zeroCnt++;
        	}
        }
        
        if (zeroCnt == 12) {
            $("#nodata").css({"display":""});
            $("#viewdata").css({"display":"none"});
        } else {
            $("#nodata").css({"display":"none"});
            $("#viewdata").css({"display":""});
            
	        drawingchart(data);
        }
    }

    //차트그리기
    function drawingchart(data) {
        if (data == undefined || data.length == 0) {
            return;
        }
        $("#statisticschart").html("");
        $("#chartdiv").css({"display" : ""});
        var ticks = "<spring:message code='ezStatistics.t218' />".split(";");
        plot2 = $.jqplot('statisticschart', [data], {
            animate: false,
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
    
    function chartTable(result, selectUserName) {
    	var months = "<spring:message code='ezStatistics.t218' />".split(";");
    	var html = "";
    	html += "<table class='tstyle2' style='text-align: center; width: 100%; border: 1px solid rgb(218, 218, 218);'>";
    	html += "<tr>";
		html += "<th style='text-align: center;'><spring:message code='ezStatistics.t83' /> </th>";
		html += "<th style='text-align: center;'><spring:message code='ezStatistics.t1000' /> </th>";
		html += "<th style='text-align: center;'>" + months[0] + "</th>";
		html += "<th style='text-align: center;'>" + months[1] + "</th>";
		html += "<th style='text-align: center;'>" + months[2] + "</th>";
		html += "<th style='text-align: center;'>" + months[3] + "</th>";
		html += "<th style='text-align: center;'>" + months[4] + "</th>";
		html += "<th style='text-align: center;'>" + months[5] + "</th>";
		html += "</tr>";
		html += "<tr>";
		html += "<td rowspan='3'>"+selectUserName+"</td>";
		html += "<td><spring:message code='ezStatistics.kbm2' /></td>";
		html += "<td>" + result[0].count + "</td>";
		html += "<td>" + result[1].count + "</td>";
		html += "<td>" + result[2].count + "</td>";
		html += "<td>" + result[3].count + "</td>";
		html += "<td>" + result[4].count + "</td>";
		html += "<td>" + result[5].count + "</td>";
		html += "</tr>";
		html += "<tr>";
		html += "<th style='text-align: center;'><spring:message code='ezStatistics.t1000' /></th>";
		html += "<th style='text-align: center;'>" + months[6] + "</th>";
		html += "<th style='text-align: center;'>" + months[7] + "</th>";
		html += "<th style='text-align: center;'>" + months[8] + "</th>";
		html += "<th style='text-align: center;'>" + months[9] + "</th>";
		html += "<th style='text-align: center;'>" + months[10] + "</th>";
		html += "<th style='text-align: center;'>" + months[11] + "</th>";
		html += "</tr>";
		html += "<tr>";
		html += "<td><spring:message code='ezStatistics.kbm2' /></td>";
		html += "<td>" + result[6].count + "</td>";
		html += "<td>" + result[7].count + "</td>";
		html += "<td>" + result[8].count + "</td>";
		html += "<td>" + result[9].count + "</td>";
		html += "<td>" + result[10].count + "</td>";
		html += "<td>" + result[11].count + "</td>";
		html += "</tr>";
		html += "</table>";
		$('#statisticstable').html(html);
    }
    
    
    function btnexportexcel_onclick() {
    	//데이터가 없으면
    	if ($("#viewdata").css("display") == "none") {
    		alert("<spring:message code='ezStatistics.t1008' />");
    		return;
    	}
    	
        document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
        document.getElementById("formAgent").target = "saveExcel";
        document.getElementById("formAgent").submit();

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

    var searchdept_cross_dialogArguments = new Array();
    function searchdept() {
        if (deptkeyword.value.trim() == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            deptkeyword.focus();
            return;
        }
        
        var xmlDom = createXmlDom();
        
        $.ajax({
        	type : "POST",
        	dataType : "text",
        	url : "/ezOrgan/getSearchList.do",
        	async : false,
        	data : {search : "displayname::" + deptkeyword.value, cell : "extensionAttribute3;displayName;extensionAttribute9;", prop : "", type : "group"},
        	success : function(result){
        		xmlDom = loadXMLString(result);
                adCount = xmlDom.getElementsByTagName("ROW").length;
        	},
        	error : function(error){
        		alert(strLang17 + error);
        		xmlDom = null;
        	}
        });
        
        if (adCount == 0) {
            alert("<spring:message code='ezStatistics.t1011' />");
            return;
		} else if (adCount == 1) {
            bSearch = true;
            g_xmlHTTP = createXMLHttpRequest();

            if (CrossYN()) {
                var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute2</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
            } else {
                var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute2</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
            }

            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
            g_xmlHTTP.send(strQuery);
        } else {
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
				window.showModalDialog("/ezStatistics/statisticsCheckName2.do", rgParams, feature);
			}
         	
            if (rgParams["deptid"] != "") {
                bSearch = true;
                g_xmlHTTP = createXMLHttpRequest();
                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute2</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
            var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute2</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
                            opener.opener.top.organview = g_xmlHTTP.responseXML;
                        else
                            window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
                    } catch (e) { }
                }

                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
                document.getElementById('TreeView').innerHTML = "";

                var treeView = new TreeView();
                treeView.SetConfig(treeXML);
                treeView.SetID("FromTreeView");
                treeView.SetUseAgency(true);
                treeView.SetRequestData("RequestData");
                treeView.SetNodeClick("TreeViewNodeClick");
                treeView.DataSource(g_xmlHTTP.responseXML);
                treeView.DataBind("TreeView");
            }
            else {
                alert(g_xmlHTTP.statusText)
                g_xmlHTTP = null;
            }
        }
    }
    
	//근태유형,년도 변경시 이벤트
	function selectBox_change() {	
		var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");
        var selnode = treeView.GetSelectNode();
	    
    	if (selnode != undefined) {
    		getAttitudeStatistics();
    	}
	}

    </script>
</head>
<body class="mainbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <h1><spring:message code='ezStatistics.t1012' /></h1>
	<table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
        <tr>
            <td style="width: 99%">
                <span id="topmenu" style="width: 500px">
                &nbsp;<spring:message code='ezStatistics.t1002' /> : 
                <select style="height:24px" id="selyear" onchange="makeoptionyear(); selectBox_change()"></select>
                    <spring:message code='ezStatistics.t55' />
		            &nbsp;&nbsp;
					<spring:message code='ezStatistics.t1013' /> : 
                    <input id="deptkeyword" type="text" style="width: 100px;height:24px" onkeypress="search_press(event)" />
                    <a class="imgbtn" style="height:22px"><span onclick="searchdept()"><spring:message code='ezStatistics.t36' /></span></a>
                    &nbsp;&nbsp;
                    	<spring:message code='ezStatistics.kbm3' /> : 
	                <select name="attitudeType" id="attitudeType" onchange="selectBox_change()" style="width: 120px; padding-right:40px;height:24px">
		      		</select>
                </span>
                </span>
            </td>
            <td>
                <div id="mainmenu" style="height: 31px;margin:3px 0px !important">
                    <ul>
                        <li><span class="btnexportexcel" style="width: 110px;text-align:center;background-color: white" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003' /></span></li>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <br />
    <h2 id="ToTitle" class="receiver_tltype01" style="border: 0px">
        <span style="min-width: 45px;"><spring:message code='ezStatistics.t1014' /></span>
    </h2>
    <table style="width: 1150px;height:640px ;border:1px solid #ddd"> 
        <tr>
            <td style="vertical-align:top">
                <div style="width: 300px; height: 640px; overflow-x: auto; overflow-y: auto;border-right:1px solid #ddd;" id="TreeView"></div>
            </td>
            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
                <div id="viewdata">
	                <div class="statistics_addition">
	                    <dl>
	                        <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
	                        <dd id="colorbox" class="additiontext"><spring:message code='ezStatistics.kbm2' /></dd>
	                    </dl>
	                </div>
                	<div id="chartdiv" style="width: 100%; text-align: center; display: none;">
                    	<div id="statisticschart" style="width: 820px; height: 480px; float: left; font-size: 16px;">
                    	</div>
					</div>
					<br/>
					<br/>
<!-- 					<table id="statisticstable" class="tstyle2" style="text-align: center; width: 100%; border: 1px solid rgb(218, 218, 218);"></table> -->
					<div id="statisticstable"></div>
                </div>
                <div id="nodata" class="statistics_nodata" style="display:none;margin:0 auto">
                    <dl class="statistics_txt">
                        <dt><spring:message code='ezStatistics.t1008' /></dt>
                        <dd><spring:message code='ezStatistics.t1009' /></dd>
                    </dl>
                </div>
            </td>
        </tr>
    </table>
     <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXlsWA.do">
        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
        <input type="hidden" id="userAgent" name="userAgent" value="">
    </form>
    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
    <script type="text/javascript">
        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
    </script>
</html>