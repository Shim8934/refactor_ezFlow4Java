<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
    <head>
    <title><spring:message code='ezStatistics.t1018' /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
    <link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
    
<!--     <link rel="stylesheet" href="/js/ezStatistics/js/jquery.jqplot.min.css" type="text/css"> -->

    <script type="text/javascript" src="<spring:message code='ezStatistics.e1' />"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <!-- 조직도 -->
    <script type="text/javascript" src="/js/jstree/jstree.js"></script>
    
<!--     <script type="text/javascript" src="/js/ezStatistics/js/excanvas.js"></script> -->
<!--     <script type="text/javascript" src="/js/ezStatistics/js/jquery.jqplot.min.js"></script> -->
<!--     <script type="text/javascript" src="/js/ezStatistics/js/jqplot.categoryAxisRenderer.min.js"></script> -->
<!--     <script type="text/javascript" src="/js/ezStatistics/js/jqplot.barRenderer.min.js"></script> -->
    <script type="text/javascript">
	    var treeContent;
	    var companyId = '${companyId}';
	    var adminCompany = '${adminCompany}';
	    var selectedUserId;
		
// 		document.onselectstart = function () {
// 	    if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
// 	        return false;
// 	    else
// 	        return true;
// 		};
		
	    $(function(){
	    	//회사선택 selectbox
	        if (document.getElementById("ListCompany").length == 0) {
	            alert("<spring:message code = 'ezAttitude.t32' />");
	        } else {
	    		if (adminCompany != null) {
	    			$('#ListCompany').val(adminCompany);
	    		} else {
		            document.getElementById("ListCompany").selectedIndex = 0;
	    		}
	            company_change();
	        }
	        
// 	        if (CrossYN())
// 	            document.getElementById("topmenu").style.cssFloat = "";
// 	        else
// 	            document.getElementById("topmenu").style.whiteSpace = "nowrap";
	
	        makeoptionyear();
	    })
	    
	    function company_change() {
			$.ajax({
				type:"post",
				dataType:"html",
				url:"/ezStatistics/deptList.do",
				data:{"companyId":$('#ListCompany').val()},
				success: function(result){
					alert('성공');
					treeContent = result.deptList;
				},
				error:function(){
					alert('실패');
				}
			});
	    }

  		//부서 리스트
		function setDeptList(){
			$('#treeView').on('changed.jstree', function (e, data) {
		     	var id = data.instance.get_node(data.selected).id;
				setUserList("DEPARTMENT",id);
			  })
			.jstree({ 
				'core' : {'data' : treeContent},
				'plugins': ["wholerow"],
				 'themes' : {'responsive' : true}
			});
		}
		//사원 리스트 뿌리기
		function setUserList(key,value){
//			selectedUserId = "";
			$.ajax({
				type:"post",
				dataType:"html",
				url:"/admin/ezAttitude/deptUserList.do",
				data:{"key":key, "value":value},
				success: function(result){
					$("#orglistView").html(result);
				}
			});
		}
		//사원선택
		function setAuthorViewUser(){
			var userId = selectedUser;
		var url = "/admin/ezJournal/authorView.do";
		var companyId = opener.companyId;
		url+="?companyId="+companyId;
		if (userId) {
			url+="&userId="+userId+"&userName="+selectedUserName;
		} else {
			alert("<spring:message code='ezPortal.t85' />");
		}
		window.open(url, "authorView", "width=500, height=180");
		window.close();
		}
//		//선택된 사원
		function setUserAuthorDept(elem){
			selectedUserId = $(elem).attr("id");
			$("*").removeClass("selectTR");
			$(elem).addClass("selectTR");
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


	    var data = new Array();
	    var data2 = new Array();
	    function event_getmailstatistics() {
	        if (xmlHttp != null && xmlHttp.readyState == 4) {
	            data = new Array();
	            data2 = new Array();
	            document.getElementById("statisticschart").innerHTML = "";
	            document.getElementById("statisticstable").innerHTML = "";
	            document.getElementById("chartdiv").style.display = "none";
	
	            var resultxml = loadXMLString(xmlHttp.responseText);
	
	            if (SelectNodes(resultxml, "DATA/ROW").length == 0) {
	                if (document.getElementById("seluser").style.display == "none")
	                    document.getElementById("nodata").style.display = "";
	                document.getElementById("viewdata").style.display = "none";
	                return;
	            }
	            document.getElementById("seluser").style.display = "none";
	            document.getElementById("nodata").style.display = "none";
	            document.getElementById("viewdata").style.display = "";
	
	            var _Table = document.createElement("TABLE");
	            _Table.style.textAlign = "center";
	            _Table.style.width = "100%";
	            _Table.className = "tstyle2";
	            _Table.style.border = "1px solid #dadada"
	
	            var _Tr = document.createElement("TR");
	
	            var start = document.getElementById("selyear").value;
	
	            var _Th = document.createElement("TH");
	            _Th.style.textAlign = "center";
	            _Th.innerHTML = "<spring:message code='ezStatistics.t1015' />";
	            _Tr.appendChild(_Th);
	
	            _Th = document.createElement("TH");
	            _Th.style.textAlign = "center";
	            _Th.style.width = "130px";
	            _Th.innerHTML = "<spring:message code='ezStatistics.t1000' />";
	
	            var nowyear = new Date().getYear();
	            var moncnt = 12;
	
	            _Tr.appendChild(_Th);
	            var ticks = "<spring:message code='ezStatistics.t218' />".split(";");
	            for (var i = 0; i < 6; i++) {
	                var _Th2 = document.createElement("TH");
	                _Th2.style.textAlign = "center";
	                _Th2.innerHTML = ticks[i];
	                _Tr.appendChild(_Th2);
	            }
	            _Table.appendChild(_Tr);
	
	            var tempcn = "";
	            var j = 0;
	
	            for (var k = 0; k < SelectNodes(resultxml, "DATA/ROW").length; k++) {
	                var tempdata = new Array();
	                var tempdata2 = new Array();
	                var curcn;
	                if (CrossYN())
	                    curcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "CN").textContent;
	                else
	                    curcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "CN").text;
	                if (tempcn != curcn) {
	                    tempcn = curcn
	                    var _Tr2 = document.createElement("TR");
	                    var _Tr3 = document.createElement("TR");
	                    var _Tr4 = document.createElement("TR");
	                    var _Tr5 = document.createElement("TR");
	                    var _Tr6 = document.createElement("TR");
	
	                    var _Td = document.createElement("TD");
	                    _Td.rowSpan = "5";
	
	                    if (CrossYN())
	                        _Td.innerHTML = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "DISPLAYNAME").textContent;
	                    else
	                        _Td.innerHTML = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[k], "DISPLAYNAME").text;
	
	                    _Tr2.appendChild(_Td);
	
	                    for (var i = 0; i < moncnt; i++) {
	                        if (i == 6) {
	                            var _Th = document.createElement("TH");
	                            _Th = document.createElement("TH");
	                            _Th.style.textAlign = "center";
	                            _Th.innerHTML = "<spring:message code='ezStatistics.t1000' />";
	
	                            var nowyear = new Date().getYear();
	
	                            _Tr4.appendChild(_Th);
	                            for (var l = 6; l < 12; l++) {
	                                var _Th2 = document.createElement("TH");
	                                _Th2.style.textAlign = "center";
	                                _Th2.innerHTML = ticks[l];
	                                _Tr4.appendChild(_Th2);
	                            }
	                        }
	                        if (i == 0) {
	                            _Td = document.createElement("TD");
	                            _Td.innerHTML = tabledata[0];
	                            var _Td2 = document.createElement("TD");
	                            _Td2.innerHTML = tabledata[1];
	
	                            _Tr2.appendChild(_Td);
	                            _Tr3.appendChild(_Td2);
	                        }
	                        else if (i == 6) {
	                            _Td = document.createElement("TD");
	                            _Td.innerHTML = tabledata[0];
	                            var _Td2 = document.createElement("TD");
	                            _Td2.innerHTML = tabledata[1];
	
	                            _Tr5.appendChild(_Td);
	                            _Tr6.appendChild(_Td2);
	                        }
	
	                        var start = document.getElementById("selyear").value;
	                        var _Td = document.createElement("TD");
	                        var _Td2 = document.createElement("TD");
	
	                        var mon = parseInt(i + 1);
	                        if (mon < 10)
	                            mon = "0" + mon;
	
	                        var date = start + mon;
	
	                        var yyyymm;
	                        var selcn;
	                        if (SelectNodes(resultxml, "DATA/ROW").length > j) {
	                            if (CrossYN()) {
	                                yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").textContent;
	                                selcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "CN").textContent;
	                            }
	                            else {
	                                yyyymm = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "DT_MM").text;
	                                selcn = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], "CN").text;
	                            }
	                        }
	
	                        if (date == yyyymm.trim() && curcn == selcn) {
	                            var maildata;
	                            if (CrossYN())
	                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[2]).textContent;
	                            else
	                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[2]).text;
	
	                            if (maildata != "0") {
	                                if (tabledata[2] == "RECEIVEINSIZE" || tabledata[2] == "RECEIVEOUTSIZE") {
	                                    _Td.innerHTML = getmailsize(maildata);
	                                    tempdata.push(parseInt(maildata) / 1024 / 1024);
	                                }
	                                else {
	                                    _Td.innerHTML = maildata;
	                                    tempdata.push(parseInt(maildata));
	                                }
	                            }
	                            else {
	                                _Td.innerHTML = "0";
	                                tempdata.push(0);
	                            }
	
	                            if (CrossYN())
	                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[3]).textContent;
	                            else
	                                maildata = SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[j], tabledata[3]).text;
	
	                            if (maildata != "0") {
	                                if (tabledata[2] == "RECEIVEINSIZE" || tabledata[2] == "RECEIVEOUTSIZE") {
	                                    _Td2.innerHTML = getmailsize(maildata);
	                                    tempdata2.push(parseInt(maildata) / 1024 / 1024);
	                                }
	                                else {
	                                    _Td2.innerHTML = maildata;
	                                    tempdata2.push(parseInt(maildata));
	                                }
	                            }
	                            else {
	                                _Td2.innerHTML = "0";
	                                tempdata2.push(0);
	                            }
	
	                            j++;
	                        }
	                        else {
	                            tempdata.push(0);
	                            tempdata2.push(0);
	                            _Td.innerHTML = "0";
	                            _Td2.innerHTML = "0";
	                        }
	                        if (i > 5) {
	                            _Tr5.appendChild(_Td);
	                            _Tr6.appendChild(_Td2);
	                        }
	                        else {
	                            _Tr2.appendChild(_Td);
	                            _Tr3.appendChild(_Td2);
	                        }
	                    }
	                    data.push(tempdata);
	                    data2.push(tempdata2);
	                    _Table.appendChild(_Tr2);
	                    _Table.appendChild(_Tr3);
	                    _Table.appendChild(_Tr4);
	                    _Table.appendChild(_Tr5);
	                    _Table.appendChild(_Tr6);
	                }
	
	            }
	            document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
	
	            if (CrossYN()) {
	                document.getElementById("colorbox").textContent = tabledata[0];
	                document.getElementById("colorbox2").textContent = tabledata[1];
	            }
	            else {
	                document.getElementById("colorbox").innerText = tabledata[0];
	                document.getElementById("colorbox2").innerText = tabledata[1];
	            }
	
	            drawingchart();
	        }
	    }

	    function drawingchart(type) {
	        if (data[0] == undefined) {
	            return;
	        }
	        document.getElementById("statisticschart").innerHTML = "";
	        document.getElementById("chartdiv").style.display = "";
	        var ticks = "<spring:message code='ezStatistics.t218' />".split(";");
	        plot2 = $.jqplot('statisticschart', [data[0], data2[0]], {
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

	    function btnexportexcel_onclick() {
	        document.getElementById("saveExcelData").value = document.getElementById("statisticstable").innerHTML;
	        
	        if (document.getElementById("saveExcelData").value == "") {
	        	alert("<spring:message code='ezStatistics.t1019' />");
	        	return ;
	        }
	        
	        document.getElementById("formAgent").target = "saveExcel";
	        document.getElementById("formAgent").submit();
	
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
	        	data : {search : "displayname::" + keyword.value, cell : "extensionAttribute3;displayName;extensionAttribute9", prop : "", type : "group"},
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
	        }
	        else if (adCount == 1) {
	//             bSearch = true;
	//             g_xmlHTTP = createXMLHttpRequest();
	
	//             if (CrossYN())
	//                 var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	//             else
	//                 var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	
	//             g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	//             g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	//             g_xmlHTTP.send(strQuery);
	        }
	        else {
	//             var rgParams = new Array();
	//             rgParams["addrBook"] = xmlDom;
	//             rgParams["deptid"] = "";
	//             var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	//             feature = feature + GetShowModalPosition(540, 460);
	//             window.showModalDialog("/ezStatistics/statisticsCheckName2.do", rgParams, feature);
	
	//             if (rgParams["deptid"] != "") {
	//                 bSearch = true;
	//                 g_xmlHTTP = createXMLHttpRequest();
	//                 var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
	//                 g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	//                 g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	//                 g_xmlHTTP.send(strQuery);
	//             }
	        }
	    }
	
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
	        		if (xmlDom.getElementsByTagName("ROW").length == 0)
	                    alert("<spring:message code='ezStatistics.t1016' />");
	                else {
	                    var retXml = createXmlDom();
	
	                    if (document.getElementById("UserList").innerHTML != "")
	                        document.getElementById("UserList").innerHTML = "";
	
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
	                    pUserList.SetRowOnClick("getmailstatistics");
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


    </script>
</head>
<body class="mainbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <h1><spring:message code='ezStatistics.t1018' /></h1>
    <table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
        <tr>
            <td style="width: 99%">
                <span id="topmenu" style="width: 500px">
                 	회사선택 : 
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-top:4px; padding-right:40px;">
					<c:forEach var = "companyItem" items="${companyList }">
						<option value="<c:out value = '${companyItem.cn }' />"><c:out value = '${companyItem.displayName }'/></option>
					</c:forEach>
	      		</select>
                 &nbsp;&nbsp;
                <spring:message code='ezStatistics.t1002' /> : 
                <select id="selyear" onchange="makeoptionyear(); getmailstatistics()"></select>
                    <spring:message code='ezStatistics.t55' />
		            &nbsp;&nbsp;
					<select id="searchopt">
		            	<option value="1"><spring:message code='ezStatistics.t1017' /></option>
		            	<option value="2"><spring:message code='ezStatistics.t113' /></option>
					</select>
                    <input id="keyword" type="text" style="width: 100px" onkeypress="search_press(event)" />
                    <a class="imgbtn" style="vertical-align: middle"><span onclick="search()"><spring:message code='ezStatistics.t36' /></span></a>
                    &nbsp;&nbsp;
                    	근태유형 : 
                    <select>
                    	<option>구분1</option>
                    </select>
                </span>
            </td>
            <td>
                <div id="mainmenu" style="height: 28px;">
                    <ul>
                        <li><span style="width: 110px;text-align:center" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003' /></span></li>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <h2 id="ToTitle" class="receiver_tltype01" style="border: 0px">
        <span style="min-width: 45px;"><spring:message code='ezStatistics.t1014' /></span>
    </h2>
    <table style="width: 1150px;height:640px ;border:1px solid #ddd"> 
        <tr>
            <td style="vertical-align:top">
            	<!-- 조직도 -->
                <div style="width: 310px; height: 310px; overflow-x: auto; overflow-y: auto; border-right: 1px solid #ddd;" id="treeView"></div>
                <!-- 선택한 혹은 검색한 사원리스트 -->
                <div id="UserList" style="Width: 310px; Height: 330px; overflow: auto; border-right: 1px solid #ddd"></div>
            </td>
            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
                <div id="viewdata" style="display:none">
                    <div class="statistics_addition">
                        <dl>
                            <dt class="colorbox_wrap"><span style="background: #4bb2c5" class="colorbox"></span></dt>
                            <dd id="colorbox" class="additiontext"><spring:message code='ezStatistics.t38' /></dd>
                        </dl>
                        <dl>
                            <dt class="colorbox_wrap"><span style="background: #eaa229" class="colorbox"></span></dt>
                            <dd id="colorbox2" class="additiontext"><spring:message code='ezStatistics.t40' /></dd>
                        </dl>
                    </div>
                    <div id="chartdiv" style="width: 100%; text-align: center; display: none;">
                        <div id="statisticschart" style="width: 800px; height: 480px; float: left; font-size: 16px;">
                        </div>
                    </div>
                    <div id="statisticstable"></div>
                </div>
                <div id="seluser" class="statistics_select" style="margin:0 auto">
                    <dl class="statistics_txt">
                        <dt><spring:message code='ezStatistics.t1019' /></dt>
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
    <form id="formAgent" name="formAgent" method="POST" target="saveExcel" action="/ezStatistics/saticGetXlsM.do">
        <input type="hidden" id="saveExcelData" name="saveExcelData" value="">
        <input type="hidden" id="userAgent" name="userAgent" value="">
    </form>
    <iframe id="saveExcel" name="saveExcel" style="display: none"></iframe>
</body>
<script type="text/javascript">
    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
//     Tab1_NewTabIni("tab1");
</script>
</html>