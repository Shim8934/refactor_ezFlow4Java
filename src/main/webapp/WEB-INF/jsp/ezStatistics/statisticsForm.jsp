<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><spring:message code='ezStatistics.t1039'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/js/ezStatistics/js/jquery.jqplot.min.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
	    <style>
	    	.mainlist_free tr th { border-top:0px }
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezStatistics.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezStatistics/control_Cross/ListView_list.js')}"></script>
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
	
	        function getforminfo() {
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getFormInfo.do",
					data : {
							company : document.getElementById("SCompID").value,
							endDate : $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
							startDate : $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
							searchList : document.getElementById("formname").value,
							type : "1"
							},
					success: function(text) {
						event_getforminfo(text);
					},
					error: function() {
						OpenAlertUI(linealt2)
					}
				});
	        }
	
	        function event_getforminfo(text) {
                document.getElementById("formlist").style.display = "";
                var retXml = createXmlDom();

                if (document.getElementById("formlist").innerHTML != "")
                    document.getElementById("formlist").innerHTML = "";

                var headerData = createXmlDom();
                headerData = loadXMLString(forminfoxml.innerHTML.toUpperCase());
                if (text != "") {
                    var xmlRtn = loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0];
                    headerData.documentElement.appendChild(xmlRtn);
                }
                var pUserList = new ListView();
                pUserList.SetID("lvformlist");
                pUserList.SetRowOnClick("getapprovalstatistics");
                pUserList.SetSelectFlag(false);
                pUserList.SetHeightFree(true);
                pUserList.DataSource(headerData);
                pUserList.DataBind("formlist");
                
                pUserList.SetSelectedIndex(0);
	              
            	 if (loadXMLString(text).documentElement.getElementsByTagName("ROWS")[0].textContent != "") {
	          	  	getapprovalstatistics();
             	 }
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
	        
	            var pformList = new ListView();
	            pformList.LoadFromID("lvformlist");
	            
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezStatistics/getStatisticsAprSearch.do",
					data : {
							company : document.getElementById("SCompID").value,
							endDate : $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
							startDate : $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
							searchID : GetAttribute(pformList.GetSelectedRows()[0],"DATA1"),
							type : "FORM"
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
                var _Table = document.createElement("TABLE");
                _Table.style.textAlign = "center";
                _Table.style.width = "100%";
                _Table.className = "tstyle2";
                _Table.style.border = "1px solid #dadada"

                var _Tr = document.createElement("TR");

                var _Th = document.createElement("TH");
                _Th.innerHTML = "<spring:message code='ezStatistics.t1032'/>";
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
                _Tr.appendChild(_Th);
                
                if ("${userInfo.lang}" != "1") {
	                _Th.classList.add("processTimeTH");
                }
                
                _Table.appendChild(_Tr);

                var resultxml = loadXMLString(text);
                for (var i = 0; i < SelectNodes(resultxml, "DATA/ROW").length; i++) {
                    var _Tr2 = document.createElement("TR")
                    ;
                    var _Td = document.createElement("TD");
                    _Td.innerHTML = getnodetext(SelectSingleNode(SelectNodes(resultxml, "DATA/ROW")[i], "FORMINFO"));
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

                document.getElementById("statisticstable").innerHTML = _Table.outerHTML;
                drawingchart();
	        }
	
	        function drawingchart() {
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
	                    getforminfo();
	                }
	            }
	            else {
	                if (e.which == 13)
	                    getforminfo();
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
	    </script>
	</head>
	<body class="mainbody" style="text-align:left">
	   <xml id="forminfoxml" style="display: none">
	    <LISTVIEWDATA>
	    <HEADERS>
	        <HEADER>
	        <NAME><spring:message code='ezStatistics.t1032'/></NAME>
	        <WIDTH>70</WIDTH>
	        </HEADER>
	    </HEADERS>
	    </LISTVIEWDATA>
	</xml>
	    <h1><spring:message code='ezStatistics.t1039'/></h1>
	     <table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2; margin-bottom: 5px">
	         <tr>
	             <td style="width: 99%">
	                 <span id="topmenu" style="float: left; width: 500px">
	                     &nbsp;<spring:message code='ezStatistics.t195'/> :
	       		 <select style="height:24px" id="SCompID" name="SCompID" onchange="return getforminfo()">
	       			<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            		</c:forEach>
	       		 </select>
	                     &nbsp;&nbsp;<spring:message code='ezStatistics.t1002'/> : 
	             <input type="text" id="Sdatepicker" style="width: 80px; text-align: center" onchange="getapprovalstatistics('sDate')" readonly="readonly">
	                     ~ 
	             <input type="text" id="Sdatepicker2" style="width: 80px; text-align: center" onchange="getapprovalstatistics('eDate')" readonly="readonly">
	                     &nbsp;&nbsp;<spring:message code='ezStatistics.t1032'/> : 
	        			<input id="formname" type="text" style="width: 100px;" onkeypress="search_press(event)" />
	                     <a class="imgbtn" style="height:22px"><span onclick="getforminfo()"><spring:message code='ezStatistics.t36'/></span></a>
	                 </span>
	             </td>
	             <td>
	                 <div id="mainmenu" style="float: right; height: 31px;margin:3px 0px !important">
	                     <ul>
	                         <li><span class="btnexportexcel" style="width: 110px;text-align:center;background-color: white" onclick="return btnexportexcel_onclick()"><spring:message code='ezStatistics.t1003'/></span></li>
	                     </ul>
	                 </div>
	             </td>
	         </tr>
	     </table>
	    <br />
	    <br />
	  <table style="width: 1150px;height:630px ;border:1px solid #ddd">
	        <tr>
	            <td style="vertical-align:top">
	                <div id="formlist" style="Width: 300px; Height: 630px; overflow: auto;display:none;border-right:1px solid #ddd;"></div>
	            </td>
	            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
	                <div id="chartdiv" style="width: 100%; text-align: center; display: none">
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