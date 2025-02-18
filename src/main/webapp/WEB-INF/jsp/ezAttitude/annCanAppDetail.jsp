<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezAttitude.t278' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Tab.css')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
        <script type="text/javascript">
        	var userId = "${userId}";
	        var writerid = "<c:out value='${data.writerId}'/>";
	        var username = "<c:out value='${data.writerName}'/>";
	        var username2 = "<c:out value='${data.writerName2}'/>";
	        var attid = "<c:out value='${data.attitudeId}'/>";
 	        var content = '${data.content}'
	        var contentpath = "${contentPath}";
	        var pageFrom = "<c:out value='${pageFrom}'/>";
	        var timecheckstring = "<spring:message code='ezSchedule.t60' />";
	        var companyID = "<c:out value='${companyId}'/>";
	        var deptName = "<c:out value='${deptName}'/>";
	        var deptID = "<c:out value='${deptID}'/>";
	        var offSetMin = "<c:out value='${offSetMin}'/>";
	        var adminFlag = "<c:out value='${adminFlag}'/>";
		    var timeCheck = false;
		    var font = "<c:out value='${font}'/>";
		    var pageInfo = "<c:out value='${pageInfo}'/>";
		    
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        var doc = document.getElementById('message').contentWindow.document;
				doc.open();
 				doc.write('${data.content}');
				doc.close();
				
				var fontFamily = font.split("|")[0];
				var fontSize = font.split("|")[1];
				$("#message").contents().find("p").each(function(){
					$(this).css({"font-size":fontSize, "font-family":fontFamily});	
				});
		    }
		    
		    window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 235 + "PX";
		    }
		    
		    function modify() {
		    	window.location.href = "/ezAttitude/attModAppMod.do?attModId=" + attid;
		    }
		    
		    function modApprove() {
		    	if (confirm("<spring:message code='ezAttitude.t84'/>")) {
			    	if ("${data.apprStatus}" == 1) {
			    		alert("<spring:message code='ezAttitude.t85'/>");
			    		return;
			    	}
			    	
			    	var obj = new Object();
			    	
				    obj.idList = attid;
				    obj.changeStatus = "appr";
				    obj.companyID = companyID; 
					
				    $.ajax({
						type : 'post',
					    url : '/ezAttitude/changeAnnCanApp.do',
					    data : obj,
					    dataType : "text",
					    error: function(xhr, status, error){
					    	ajaxRunning = false;
					    	alert("<spring:message code='ezAttitude.t86'/>");
					    },
					    success : function(json){
					    	if (json == "ok") {
					    		//alert("승인되었습니다.");	
					    	} else {
					    		//alert("승인 중 오류 발생");
					    	}
				            try {
				                window.opener.att_refresh();
				            } catch (e) {
				            	window.opener.getAttitudeMainList();
			        		}
				            window.close();
					    }
				    });
		    	}
		    }
		    
		  	//반려
		    function modReturn() {
		    	if (confirm("<spring:message code='ezAttitude.t87'/>")) {
			    	if ("${data.apprStatus}" == 2) {
			    		alert("<spring:message code='ezAttitude.t88'/>");
			    		return;
			    	}
			  		
			  		var obj = new Object();
			    	
				    obj.idList = attid;
				    obj.changeStatus = "ret";
				    obj.companyID = companyID;
					
				    $.ajax({
						type : 'post',
					    url : '/ezAttitude/changeAnnCanApp.do',
					    data : obj,
					    dataType : "text",
					    error: function(xhr, status, error){
					    	ajaxRunning = false;
					    	alert("<spring:message code='ezAttitude.t89'/>")
					    },
					    success : function(json){
					    	if (json == "ok") {
					    		//alert("반려되었습니다.");	
					    	} else {
					    		//alert("반려 중 오류 발생");
					    	}
					    	try {
				                window.opener.att_refresh();
				            } catch (e) {
				            	window.opener.getAttitudeMainList();
			        		}
				            window.close();
					    }
				    });
		    	}
		    }
		  	
	    </script>
	</head>

	<body class="popup" style="overflow:hidden;">
	    <form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                        	<ul id="menuTable">	
	                                <li class="sel"><h1 style="padding:0px; margin-top:-5px;"><spring:message code='ezAttitude.t278' /></h1></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <div id="tabShecdule" style="margin-top:5px;">
	                            <div id="schedule1">
	                                <table class="content">
                                        <tr id="HolderWrite">
                                            <th><spring:message code='ezAttitude.t134'/></th>
                                            <td colspan="2" readonly>
                                            	<c:out value='${data.typeName}' />
                                            </td>
                                        </tr>
                                        <tr id="HolderWrite">
                                            <th><spring:message code='ezAttitude.t93'/></th>
                                            <td colspan="2" readonly title="<c:out value='${data.writerDeptName}' /> <c:out value='${data.writerName}' /> <c:out value='${data.writerTitle}' />">
                                            	<c:out value='${data.writerName}' />
                                            </td>
                                        </tr>
	                                    <tr>
	                                        <th><spring:message code='ezAttitude.t276' /></th>
	                                        <td colspan="2">
	                                        	<c:out value='${data.originDate.substring(0,10)}' /> 
	                                        	<c:if test="${data.typeId == 'A11'}">
	                                        		~ <c:out value='${data.changeDate.substring(0,10)}' />
	                                        	</c:if>
	                                        </td>
	                                    </tr>
	                                    <c:if test="${attitudeConfigVO.attitudeModAppl == 1}">
		                                    <tr>
		                                        <th><spring:message code='ezAttitude.t208'/></th>
	                                        	<c:if test="${data.apprStatus == 0}">
									          		<td colspan="2"><spring:message code='ezAttitude.t209'/></td>	
									          	</c:if>
									          	<c:if test="${data.apprStatus == 1}">
									          		<td colspan="2"><spring:message code='ezAttitude.t210'/></td>	
									          	</c:if>
									          	<c:if test="${data.apprStatus == 2}">
									          		<td colspan="2"><spring:message code='ezAttitude.t211'/></td>	
									          	</c:if>
		                                    </tr>
	                                    </c:if>
	                                </table>
	                            </div>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
		                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
		                    <iframe id="message" style="border: #ddd 1px solid; padding-left: 5px; overflow: auto;width: 99.1%; padding-top: 6px; height: 315px; background-color: white"></iframe>	                    
		                </td>
	            	</tr>
	            </table>
	            <div class="btnpositionNew" id="menuTable">
	            	<c:if test="${attitudeConfigVO.attitudeModAppl == 1}">
                    	<c:if test="${authFlag == 'M' && adminFlag == 'true' && data.apprStatus == 0 && deptFlag == 'true'}">
                     		<a class="imgbtn"><span onclick="modApprove()"><spring:message code='ezAttitude.kje02'/></span></a>
                         	<a class="imgbtn"><span onclick="modReturn()"><spring:message code='ezAttitude.kje03'/></span></a>
                    	</c:if>
                   	</c:if>
	            </div>
	        </div>
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
