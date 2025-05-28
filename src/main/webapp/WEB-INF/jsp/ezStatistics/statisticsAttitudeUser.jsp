<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t1018' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">    
    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/ListView_list.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/excanvas.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/js/jqplot.barRenderer.min.js')}"></script>    
    <script type="text/javascript">
    var Tab1_flag = true;
    var xmlHttp = createXMLHttpRequest();
    var adminCompany = "${adminCompany}";
    var typeId = "";
	
	document.onselectstart = function () {
	    if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
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
        
		//조직도 뿌리기
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

    //조직도 회사,부서 클릭
    function TreeViewNodeClick() {
        var nodeIdx = 1;
        var treeView = new TreeView();
        treeView.LoadFromID("FromTreeView");
        var selnode = treeView.GetSelectNode();
        DeptID = selnode.GetNodeData("CN");
        displayUserList(DeptID);
        //회사별 근태유형 리스트
        company_typeList(selnode.GetNodeData("extensionattribute2"), typeId);
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

    //부서클릭시 사원리스트 뿌리기
    function displayUserList(DeptID) {
    	$.ajax({
        	type : "POST",
        	dataType : "text",
        	url : "/ezOrgan/getDeptMemberList.do",
        	async : false,
        	data : {deptID : DeptID, cell : "displayName;description", prop : "department;displayName;description;title", type : "user"},
        	success : function(result){
        		var retXml = createXmlDom();

                if (document.getElementById("UserList").innerHTML != "")
                    document.getElementById("UserList").innerHTML = "";

                var headerData = createXmlDom();
                headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                if (result != "") {
                	var xmlDom = loadXMLString(result);
                    if (CrossYN()) {
                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                        var Node = headerData.importNode(xmlRtn, true);
                        headerData.documentElement.appendChild(Node);
                    }
                    else {
                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                        headerData.documentElement.appendChild(xmlRtn);
                    }
                }
                var pUserList = new ListView();
                pUserList.SetID("lvUserList");
                //사원리스트 클릭 이벤트 주기
                pUserList.SetRowOnClick("getAttitudeStatistics");
                pUserList.SetSelectFlag(false);
                pUserList.SetHeightFree(true);
                pUserList.DataSource(headerData);
                pUserList.DataBind("UserList");
        	},
        	error : function(error){
        		OpenAlertUI(linealt2 + error)
        	}
        });

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
        	data : {"companyId" : companyId},
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

                if (selyear == tempyear) {
                    option.selected = true;
                }

                document.getElementById("selyear").appendChild(option);
                tempyear--;
            }
            tempyear = selyear + 2;
        }
    }

    //사원선택시
    function getAttitudeStatistics() {
    	xmlHttp = createXMLHttpRequest();
	    var xmlDoc = createXmlDom();
	
	    var pUserList = new ListView();
	    pUserList.LoadFromID("lvUserList");
    	var selectUserId = pUserList.GetSelectedRows()[0].getAttribute("DATA2");
    	var selectUserName = pUserList.GetSelectedRows()[0].getElementsByTagName("td")[0].childNodes[0].nodeValue;
    	var typeId = $("#attitudeType").val();
    	$.ajax({
        	type : "POST",
        	dataType : "json",
        	url : "/ezStatistics/getAttitudeUser.do",
        	async : false,
        	data : {userId : selectUserId, typeId : typeId, year : $("#selyear").val() },
        	success : function(result){
        		company_typeList(result.companyId, typeId);
        		
        		event_getAttitudeStatistics(result.list);
        		chartTable(result.list, selectUserName);
        	},
        	error : function(error){
        		
        	}
        });
    }

	//사원선택시와 관련 이벤트 함수
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
            if ($("#seluser").css("display") == "none"){
                $("#nodata").css({"display":""});
            	$("#viewdata").css({"display":"none"});
            	return;
            } else {
                $("#seluser").css({"display":"none"});
                $("#nodata").css({"display":""});
                $("#viewdata").css({"display":"none"});
            }
        } else {
            $("#seluser").css({"display":"none"});
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
		html += "<th style='text-align: center;'><spring:message code='ezStatistics.t1015' /> </th>";
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

    //엑셀내려받기 버튼 클릭시
    function btnexportexcel_onclick() {
        document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
        
        if (document.getElementById("saveExcelData").value == "") {
        	alert("<spring:message code='ezStatistics.t1019' />");
        	return ;
        }
        //데이터가 없으면
        if ($("#viewdata").css("display") == "none") {
    		alert("<spring:message code='ezStatistics.t1008' />");
    		return;
    	}
        
        document.getElementById("formAgent").target = "saveExcel";
        document.getElementById("formAgent").submit();
    }

    //검색
    function search_press(e) {
        if (window.event) {
            if (window.event.keyCode == 13) {
                search();
            }
        }
        else {
            if (e.which == 13){
                search();
            }
        }
    }

    //검색
    function search() {
        if (document.getElementById("searchopt").value == "1") {
            searchuser();
        } else {
            searchdept();
        }
    }

    //부서로 검색
    var searchdept_cross_dialogArguments = new Array();
    function searchdept() {
        if (keyword.value.trim() == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            keyword.focus();
            return;
        }
        
		var xmlDom = createXmlDom();
        
        $.ajax({
        	type : "POST",
        	dataType : "text",
        	url : "/ezOrgan/getSearchList.do",
        	async : false,
        	data : {search : "displayname::" + keyword.value, cell : "extensionAttribute3;displayName;extensionAttribute9;", prop : "", type : "group"},
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
			} else {
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
    
    function SelelctDept_complite(deptid){
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
                        if (CrossYN()) {
                            opener.opener.top.organview = g_xmlHTTP.responseXML;
                        } else {
                            window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
                        }
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
            } else {
                alert(g_xmlHTTP.statusText);
                g_xmlHTTP = null;
            }
        }
    }

    //사원으로 검색시
    function searchuser() {
        if (keyword.value == "") {
            alert("<spring:message code='ezStatistics.t1010' />");
            keyword.focus();
            return;
        }
        
        $.ajax({
        	type : "POST",
        	dataType : "text",
        	url : "/ezOrgan/getSearchList.do",
        	async : true,
        	data : {search : "displayname::" + keyword.value, cell : "displayName;description", prop : "", type : "user"},
        	success : function(result){	
        		var xmlDom = loadXMLString(result);
        		if (xmlDom.getElementsByTagName("ROW").length == 0) {
                    alert("<spring:message code='ezStatistics.t1016' />");
        		} else {
                    var retXml = createXmlDom();

                    if (document.getElementById("UserList").innerHTML != "") {
                        document.getElementById("UserList").innerHTML = "";
                    }

                    var headerData = createXmlDom();
                    headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
                    if (result != "") {
                        if (CrossYN()) {
                            var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                            var Node = headerData.importNode(xmlRtn, true);
                            headerData.documentElement.appendChild(Node);
                        }
                        else {
                            var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
                            headerData.documentElement.appendChild(xmlRtn);
                        }
                    }
                    var pUserList = new ListView();
                    pUserList.SetID("lvUserList");
                    pUserList.SetRowOnClick("getAttitudeStatistics");
                    pUserList.SetSelectFlag(false);
                    pUserList.SetHeightFree(true);
                    pUserList.DataSource(headerData);
                    pUserList.DataBind("UserList");
                }
        	},
        	error : function(error){
        		alert(error);
        	}
        });
    }

	//근태유형,년도 변경시 이벤트
	function selectBox_change() {	
	    var pUserList = new ListView();
	    pUserList.LoadFromID("lvUserList");
	    
    	if (pUserList.GetSelectedRows()[0] != undefined) {
    		getAttitudeStatistics();
    	}
	}

    </script>
</head>
<body class="mainbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <xml id="userlist_h" style="display: none">
    <LISTVIEWDATA>
    <HEADERS>
        <HEADER>
        <NAME><spring:message code='ezStatistics.t1017' /></NAME>
        <WIDTH>70</WIDTH>
        </HEADER>
        <HEADER>
        <NAME><spring:message code='ezStatistics.t113' /></NAME>
        <WIDTH>100</WIDTH>
        </HEADER>
    </HEADERS>
    <ROWS></ROWS>
    </LISTVIEWDATA>
</xml>
	<h1><spring:message code='ezStatistics.t1018' /></h1>
	<table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
        <tr>
            <td style="width: 99%">
                <span id="topmenu" style="width: 500px">
                &nbsp;<spring:message code='ezStatistics.t1002' /> : 
                <select style="height:24px" id="selyear" onchange="makeoptionyear(); selectBox_change()"></select>
                    <spring:message code='ezStatistics.t55' />
		            &nbsp;&nbsp;
					<select id="searchopt" style="height:24px">
		            	<option value="1"><spring:message code='ezStatistics.t1017' /></option>
		            	<option value="2"><spring:message code='ezStatistics.t113' /></option>
					</select>
                    <input id="keyword" type="text" style="width: 100px;height:24px" onkeypress="search_press(event)" />
                    <a class="imgbtn" style="height:22px"><span onclick="search()"><spring:message code='ezStatistics.t36' /></span></a>
                    &nbsp;&nbsp;
                    	<spring:message code='ezStatistics.kbm3' /> : 
	                <select name="attitudeType" id="attitudeType" onchange="selectBox_change()" style="width: 120px; height:24px; padding-right:40px;">
		      		</select>
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
                <div style="width: 310px; height: 310px; overflow-x: auto; overflow-y: auto; border-right: 1px solid #ddd;" id="TreeView"></div>
                <div id="UserList" style="Width: 310px; Height: 330px; overflow: auto; border-right: 1px solid #ddd"></div>
            </td>
            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
                <div id="viewdata" style="display:none">
	                <div class="statistics_addition">
	                    <dl>
	                        <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
	                        <dd id="colorbox" class="additiontext"><spring:message code='ezStatistics.kbm2' /></dd>
	                    </dl>
	                </div>
                    <div id="chartdiv" style="width: 100%; text-align: center; display: none;">
                        <div id="statisticschart" style="width: 800px; height: 480px; float: left; font-size: 16px;">
                        </div>
                    </div>
                    <br/>
					<br/>
					<div id="statisticstable"></div>
                </div>
                <div id="seluser" class="statistics_select" style="margin:0 auto">
                    <dl class="statistics_txt">
                        <dt><spring:message code='ezStatistics.hsbUs01' /></dt>
                        <dd><spring:message code='ezStatistics.t1020' /><br>
                            <spring:message code='ezStatistics.t1021' /></dd>
                    </dl>
                </div>
                <div id="nodata" class="statistics_nodata" style="display: none;margin:0 auto">
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