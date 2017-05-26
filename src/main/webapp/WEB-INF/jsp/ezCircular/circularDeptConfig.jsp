<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t35' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css" />
		<link rel="stylesheet" href="<spring:message code='ezCircular.e1' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			
			$(document).ready(function() {
				$("#checkboxAll").click(function() {
					if ($("#checkboxAll").prop("checked")) {
						$("input[id=checkbox]").prop("checked", true);
					} else {
						$("input[id=checkbox]").prop("checked", false);
					}
				})
			})
			
			window.onload = function() {	
				get_circularDept();	
			}
			
			function get_circularDept() {
				$.ajax({
					url : "/ezCircular/getcircularDeptList.do",
					method : 'POST',
     				dataType : 'xml',
					async : false,
					success : function(data) {
						MakeSliderList(data)
					}
				})
			}
			
			function MakeSliderList(text) {		
				var _html = "";
				try {
	                var XmlNode = text;
	                var countValue = 0;
	                _html = "<table class='mainlist' style='width:100%;'>";

	                if (SelectNodes(XmlNode, "DATA/ROW").length > 0) {	                	
	                    if (CrossYN()) {
	                        for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                            var _Value;
	                            _html += "<tr id='" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "CIRCULARBMID")[0].textContent
	                            + "'title = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "TITLE")[0].textContent
	                            + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
	                            _html += "<td style='width:7%;padding-left:5px;'><input id='checkbox' type='checkbox' onclick='event_statuschange(this);'></td>";
	                            _html += "<td style='width:28%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "TITLE")[0].textContent + "</td>";
	                            _html += "<td style='width:25%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "REGDATE")[0].textContent + "</td>";
	                            
                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[1] != "0") {
	                            _html += "<td style='width:45%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[0]
	                            + "&nbsp<spring:message code='ezCircular.t50' />&nbsp" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[1] + "<spring:message code='ezCircular.t51' />" + "</td>";
                            } else {
                            	_html += "<td style='width:45%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[0] + "</td>";
                            }                            
	                            _html += "</tr>";
	                            _html += "</html>";
	                            document.getElementById("contentlist").innerHTML = _html;
	                        }
	                    } else {
	                        for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                               	 var _Value;
	                               	_html += "<tr id='" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "CIRCULARBMID")[0].textContent
		                            + "'title = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "TITLE")[0].textContent
		                            + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
		                            _html += "<td style='width:7%;padding-left:5px;'><input id='checkbox' type='checkbox' onclick='event_statuschange(this);'></td>";
		                            _html += "<td style='width:28%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "TITLE")[0].text + "</td>";
	                                _html += "<td style='width:25%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "REGDATE")[0].text + "</td>";
	                        
                                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[1] != "0") {
	                                _html += "<td style='width:45%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].text.split("/")[0]
    	                            + "&nbsp<spring:message code='ezCircular.t50' />&nbsp" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[1] + "<spring:message code='ezCircular.t51' />" + "</td>";
                                } else {
                                	_html += "<td style='width:45%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "MEMBERNAME")[0].textContent.split("/")[0] + "</td>";
                                } 
	                                _html += "</tr>";
	                                _html += "</html>";
	                                document.getElementById("contentlist").innerHTML = _html;
	                            }
	                        }
	                    }
	                } else {
	                    document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + "<spring:message code='ezCircular.t47'/>" + "</td></tr></table>";
	                }	
		        } catch (e) {
		            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + "<spring:message code='ezCircular.t47'/>" + "</td></tr></table>";
		        }
			}
			
			function event_Mover(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(3).style.backgroundColor = "#EDEDED";
		        }
		    }
			
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(3).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    
		    var _RowObject = null;
		    
		    function event_click(obj) {
		    	if (_RowObject != null) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(3).style.backgroundColor = "#ffffff";
		        }

		        _RowObject = obj;
		        obj.childNodes.item(0).style.backgroundColor = "rgb(233, 241, 244)";
		        obj.childNodes.item(1).style.backgroundColor = "rgb(233, 241, 244)";
		        obj.childNodes.item(2).style.backgroundColor = "rgb(233, 241, 244)";
		        obj.childNodes.item(3).style.backgroundColor = "rgb(233, 241, 244)";
		    }

		    function event_dbclick() {
		    	modify_circularDept();
		    }
		    
		    function event_statuschange(obj) {
		    	
		    }
			
			var schedule_admin_popup_sharedept_dialogArguments = new Array();
			
			function add_circularDept() {
		        if (CrossYN()) {
	                schedule_admin_popup_sharedept_dialogArguments[1] = share_new_Complete;
	                var OpenWin = window.open("/ezCircular/circularDeptadd.do", "", GetOpenWindowfeature(360, 180));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var feature = GetShowModalPosition(360, 180);
	                var rtnValue = window.showModalDialog("/ezCircular/circularDeptadd.do", "","dialogHeight:180px;dialogwidth:360px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                
	                if (typeof (rtnValue) != "unlimited" && rtnValue == "OK") {
	                    window.location.reload(false);
	                }
	            }
			}

			function share_new_Complete(retVal) {
	            if (typeof (retVal) != "unlimited" && retVal == "OK") {
	                window.location.reload(false);
	            }
	        }
			
			function modify_circularDept() {
				if (_RowObject == null) {
		        	alert("<spring:message code='ezCircular.t44' />");
		            return;
		        }
				
				if ($("#checkbox:checked").length > 1) {
					alert("<spring:message code='ezCircular.t49' />");
					return;
				}

				var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;

		        var circularBMId = _RowObject.id;
		        var title = _RowObject.getAttribute("title");
		        var memberList = _RowObject.getAttribute("memberList");

		        window.open("/ezCircular/circularDeptModify.do?id=" + circularBMId + "&title=" + title, "", "height = 280px, width = 450px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status=no, toolbar=no, menubar=no, location=no, resizable=no");		        	
		        
			}
			
			var circularBMIdList = new Array();
			
			function delete_circularDept() {
				if (_RowObject == null) {
		        	alert("<spring:message code='ezCircular.t44' />");
		            return;
		        }

				for (var i=0; i<$("#checkbox:checked").length; i++) {
					
				}
				
				if (confirm("<spring:message code='ezCircular.t46' />")) {
					$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezCircular/circularDeptDel.do",
			    		data : {
			    			circularBMId  : _RowObject.id
			    		},
			    		success: function() {
			    			alert("<spring:message code='ezCircular.t45' />");
			    		},
			    		error: function(err) {
			    			alert(strLang1);
			    		}
			        });					
				}
				
				window.location.reload(false);
			}
		</script>
	</head>
	<body> 
		<form id="Form1" method="post">
			<br />
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li style=><span onClick="add_circularDept()"><spring:message code='ezCircular.t28' /></span></li>
			        <li style=><span onClick="modify_circularDept()"><spring:message code='ezCircular.t29' /></span></li>
			        <li style=><span onClick="delete_circularDept()"><spring:message code='ezCircular.t30' /></span></li>
			    </ul>
			</div>
			<table style="width: 750px; height: 385px;" border="0">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 750px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                        <tr>
		                        	<th style="width: 7%; "><input id="checkboxAll" type="checkbox"></th>
		                            <th style="width: 28%; "><span><spring:message code='ezCircular.t32' /></span></th>
		                            <th style="width: 25%; "><span><spring:message code='ezCircular.t33' /></span></th>
		                            <th style="width: 45%; "><span><spring:message code='ezCircular.t34' /></span></th>
		                        </tr>
		                    </table>
		                    <div id="contentlist" name="contentlist" style="height: 365px; overflow-y: auto;">
		                        <table class="mainlist" style="width: 100%;">
		                            <tr>
		                                <td style="text-align: center;">
		                                    <spring:message code='ezCircular.t47'/>
		                                </td>
		                            </tr>
		                        </table>
		                    </div>
		                </div>
		            </td>
		        </tr>
		    </table>
			<script type="text/javascript">
			    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</form>
	</body>
</html>