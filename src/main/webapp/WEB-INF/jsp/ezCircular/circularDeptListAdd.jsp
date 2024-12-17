<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCircular.t36" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>

		<script type="text/javascript">
			var userInfoID = "<c:out value='${userInfo.id}'/>";

			window.onload = function () {
					
			}

			function event_Mover(obj) {
		        if (obj != _RowObject) {
		        	obj.style.backgroundColor = "#EDEDED";
		        }
		    }
			
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		        	obj.style.backgroundColor = "#FFFFFF";
		        }
		    }
		    
		    var _RowObject = null;
		    
		    function event_click(obj) {
		    	if (_RowObject != null) {
		            _RowObject.style.backgroundColor = "#ffffff";
		    	}

		        _RowObject = obj;
		        obj.style.backgroundColor = "#f1f8ff";
		    }
		    
		    function memberList() {
				var circularBMId = _RowObject.id;
		    	
		    	var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 280) / 2;
		        var pLeft = (pwidth - 450) / 2;
		    	
		    	window.open("/ezCircular/circularCheckName.do?id=" + circularBMId, "", "height = 300px, width = 650px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status=no, toolbar=no, menubar=no, location=no, resizable=no");
		    }
		    
			function closeDeptListAdd() {
				parent.DivPopUpHidden();
			}
		</script>
	</head>
	<body class="popup" style="overflow: hidden;">
		<h1><spring:message code='ezCircular.t87'/></h1>
		
		<div id="close">
			<ul>
				<li><span onclick="closeDeptListAdd();"></span></li>
			</ul>
		</div>

		<table style="width: 550px; height: 250px;" border="0">
	        <tr>
	            <td>
	                <div style="border: 1px solid #dbdbda; border-top:0px; width: 550px; height: 250px; display: inline-table;">
	                    <table class="mainlist" style="width: 100%;">
	                        <tr>
	                            <th style="width: 250px; "><span style="margin-left: 40px;"><spring:message code='ezCircular.t32' /></span></th>
	                            <th style="width: 80px; "><span><spring:message code='ezCircular.t34' /></span></th>
	                            <th style="width: 30px; "></th>
	                        </tr>
	                    </table>
	                    <div id="contentlist" name="contentlist" style="height: 220px; overflow-y: auto;">
	                        <table class="mainlist" style="width: 100%;">
	                            <c:forEach var="item" items="${result}">
		                            <tr id="${item.circularBMID }" style="cursor:pointer" onmouseover="event_Mover(this);" onmouseout="event_Mout(this);" onclick="event_click(this);">
		                            	<td style="width:250px;color:gray;padding-left: 20px;"><c:out value='${item.title }'/></td>
		                            	<c:if test="${item.memberNameCount != 0}">
		                        			<td style="width: 80px;color:gray;" align="center"><c:out value='${item.memberName }'/> <spring:message code='ezCircular.t50' /> <c:out value='${item.memberNameCount }'/> <spring:message code='ezCircular.t51' /></td>    		
		                            		<td id="pop" style="width: 80px;"><a href="javascript:memberList();" style="color:gray;">[<spring:message code='ezCircular.t50' />]</a></td>
		                            	</c:if>
	                            		<c:if test="${item.memberNameCount == 0}">
	                            			<td style='width: 80px;color:gray;'><c:out value='${item.memberName }'/></td>
	                            		</c:if>
		                            </tr>
	                            </c:forEach>
	                            <c:if test="${circularbmid == 0 }">
		                            <tr>
		                                <td style="text-align: center;">
		                                    <spring:message code='ezCircular.t47'/>
		                                </td>
		                            </tr>	                            
	                            </c:if>
	                        </table>
	                    </div>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>