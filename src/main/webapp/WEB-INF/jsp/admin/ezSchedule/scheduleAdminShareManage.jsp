<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />		
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>	    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">	
	    	var selectedCompanyID = "";
	    
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
	        	selectedCompanyID = $("#ListCompany").val();
	            $.ajax({
	            	url : "/admin/ezSchedule/scheduleGetShareManage.do",
	            	type : "GET",
	            	dataType : "xml",
	            	async : true,
	            	cache : false,
	            	data : {companyID : selectedCompanyID},	            	
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
	                            _html += "<td style='width:50%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "USERNAME")[0].textContent + "</td>";
								// 사간 겸직기능을 추가하며 기능상의 이상은 없으나, 표출 부서가 무조건 본직기준이므로 표출 부서를 제거 함.
	                            // _html += "<td style='width:32%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DESCRIPTION")[0].textContent + "</td>";
	                            _html += "<td style='width:50%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "DEPTNAME")[0].textContent + "</td>";
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
		            // obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
		        }
		    }
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
		            // obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    var _RowObject = null;
		    function event_click(obj) {
		        if (_RowObject != null && _RowObject.childNodes.length != 0) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
		            // _RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
		        }

		        _RowObject = obj;
		        obj.childNodes.item(0).style.backgroundColor = "#f1f8ff";
		        obj.childNodes.item(1).style.backgroundColor = "#f1f8ff";
		       //  obj.childNodes.item(2).style.backgroundColor = "#f1f8ff";
		    }
		
		    function event_dbclick() {}
		
	        var schedule_admin_popup_sharedept_dialogArguments = new Array();
	        function share_new()
	        {
	            if (CrossYN()) {
	                schedule_admin_popup_sharedept_dialogArguments[1] = share_new_Complete;
	                var OpenWin = window.open("/admin/ezSchedule/scheduleAdminPopupShareDept.do", "scheduleAdminPopupShareDept", GetOpenWindowfeature(460, 200));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	                var feature = GetShowModalPosition(500, 200);
	                var rtnValue = window.showModalDialog("/admin/ezSchedule/scheduleAdminPopupShareDept.do", "","dialogHeight:180px;dialogwidth:360px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
	                
	                if (typeof (rtnValue) != "unlimited" && rtnValue == "OK") {
	                	schedule_get_sharemanage();
	                    //window.location.reload(false);
	                }
	            }
	        }
	        function share_new_Complete(retVal) {
	            if (typeof (retVal) != "unlimited" && retVal == "OK") {
	            	schedule_get_sharemanage();
// 	                window.location.reload(false);
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
						type : "POST",
						dataType : "html",
						async : false,
						data : {
							id : _RowObject.id
						},
						success : function(text){
							alert(strLang85);
							//window.location.reload(false);	
							schedule_get_sharemanage();
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
	    <h1>
	    	<spring:message code='ezSchedule.t36' />
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
		    <select class="companySelect" id="ListCompany" onChange="schedule_get_sharemanage()">
	        	<c:forEach var="item" items="${companyList}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
		    </select>
	    </h1>
	    <div id="mainmenu">
		    <ul>
		        <li class="important"><span onClick="share_new()"><spring:message code='ezSchedule.t6' /></span></li>
		        <li><span class="icon16 icon16_delete" onClick="share_delete()"></span></li>
		    </ul>
		</div>
	    <table style="width: 750px; height: 500px; border-bottom:1px solid #e8e8e8" >
            <tr>
                <td>
                    <div style="border: 1px solid #e8e8e8;border-top:0px;border-bottom:0px; width: 750px; height: 500px;">
                        <table class="mainlist" style="width: 100%;">
                            <tr>
                                <th style="width: 50%;"><span><spring:message code='ezSchedule.t999' /></span></th>
<%--                                <th style="width: 32%;"><span><spring:message code='ezSchedule.t12' /></span></th>--%>
                                <th style="width: 50%;"><span><spring:message code='ezSchedule.t205' /><spring:message code='ezSchedule.t12' /></span></th>
                            </tr>
                        </table>
                        <div id="contentlist" name="contentlist" style="height: 468px; overflow-y: auto;">
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

