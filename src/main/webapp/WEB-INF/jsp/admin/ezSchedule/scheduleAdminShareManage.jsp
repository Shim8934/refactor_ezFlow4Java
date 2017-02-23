<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />		
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript">			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			
	        window.onload = function() {
	            schedule_get_sharemanage();
	        }
	        
	        function schedule_get_sharemanage() {	            
	            $.ajax({
	            	url : "/admin/ezSchedule/scheduleGetShareManage.do",
	            	dataType : "xml",
	            	async : true,
	            	success : function(text){
	            		MakeSliderList(text);
	            	}	            	
	            });	           
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
	                            _html += "<tr id='" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "IDX")[0].textContent + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
	                            _html += "<td style='width:38%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USERNAME")[0].textContent + "</td>";
	                            _html += "<td style='width:32%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DESCRIPTION")[0].textContent + "</td>";
	                            _html += "<td style='width:30%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DEPTNAME")[0].textContent + "</td>";
	                            _html += "</tr>";
	                            _html += "</html>";
	                            document.getElementById("contentlist").innerHTML = _html;
	                        }
	                    } else {
	                        for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                               	 var _Value;
	                                _html += "<tr id='" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "IDX")[0].text + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
	                                _html += "<td style='width:38%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USERNAME")[0].text + "</td>";
	                                _html += "<td style='width:32%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DESCRIPTION")[0].text + "</td>";
	                                _html += "<td style='width:30%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DEPTNAME")[0].text + "</td>";
	                                _html += "</tr>";
	                                _html += "</html>";
	                                document.getElementById("contentlist").innerHTML = _html;
	                            }
	                        }
	                    }
	                } else {
	                    document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + strLang263 + "</td></tr></table>";
	                }	
		        } catch (e) {
		            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang263 + "</td></tr></table>";
		        }	        
		    }
	
		    function event_Mover(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
		            obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
		        }
		    }
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    var _RowObject = null;
		    function event_click(obj) {
		        if (_RowObject != null) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
		        }
		
		        _RowObject = obj;
		        obj.childNodes.item(0).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(1).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(2).style.backgroundColor = "#DBE1E7";
		    }
		
		    function event_dbclick() {}
		
	        var schedule_admin_popup_sharedept_dialogArguments = new Array();
	        function share_new()
	        {
	            if (CrossYN()) {
	                schedule_admin_popup_sharedept_dialogArguments[1] = share_new_Complete;
	                var OpenWin = window.open("/admin/ezSchedule/scheduleAdminPopupShareDept.do", "scheduleAdminPopupShareDept", GetOpenWindowfeature(360, 180));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var feature = GetShowModalPosition(360, 180);
	                var rtnValue = window.showModalDialog("/admin/ezSchedule/scheduleAdminPopupShareDept.do", "","dialogHeight:180px;dialogwidth:360px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                
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
	
	        function share_delete() {   
	            if (_RowObject == null) {
	                alert(strLang84);
	                return;
	            }
				if(confirm("<spring:message code='ezSchedule.t33' />")){
					$.ajax({
						url : "/admin/ezSchedule/scheduleDelShareDept.do",
						dataType : "html",
						async : false,
						data : {
							id : _RowObject.id
						},
						success : function(text){
							alert(strLang85);
							window.location.reload(false);	
						},
						error : function(err){
							alert(strLang86);	
						}
					});
				}
	        }
		</script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezSchedule.t36' /></h1>
	    <div id="mainmenu">
		    <ul>
		        <li><span onClick="share_new()"><spring:message code='ezSchedule.t6' /></span></li>
		        <li><span onClick="share_delete()"><spring:message code='ezSchedule.t41' /></span></li>
		    </ul>
		</div>
	    <br />
	    <table style="width: 750px; height: 385px;" >
            <tr>
                <td>
                    <div style="border: 1px solid #dbdbda;border-top:0px; width: 750px; height: 396px;">
                        <table class="mainlist" style="width: 100%;">
                            <tr>
                                <th style="width: 38%;"><span><spring:message code='ezSchedule.t999' /></span></th>
                                <th style="width: 32%;"><span><spring:message code='ezSchedule.t12' /></span></th>
                                <th style="width: 30%;"><span><spring:message code='ezSchedule.t205' /><spring:message code='ezSchedule.t12' /></span></th>
                            </tr>
                        </table>
                        <div id="contentlist" name="contentlist" style="height: 365px; overflow-y: auto;">
                            <table class="mainlist" style="width: 100%;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="/images/email/progress_img.gif" />
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
	</body>
</html>

