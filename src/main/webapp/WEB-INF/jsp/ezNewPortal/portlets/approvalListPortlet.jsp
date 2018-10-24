<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>approvalListPortlet</title>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
	</head>
	<body>
		<div class="layDIV approval">
            <dl class="portlet_tab sortablePortlet">
                <dt id="doingTab" class="on" onclick="apprChangeTab(this)"><span><spring:message code='main.t00003' /></span></dt>
                <dt id="rejectTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00004' /></span></dt>
                <dt id="draftTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00005' /></span></dt>
                <dd class="portletPlus" onclick="Appmore_btnClick()"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
            </dl>
            <ul id ="ApprList" class="portlet_list">
				<dl class='nodata'>
					<dt><img src='/images/ezNewPortal/nodata.png'></dt>
					<dd><spring:message code='main.t00026' /></dd>
				</dl>

            </ul>
        </div>
		
		<script type="text/javascript">
			var getApprovalList = function(type) {
				var request = new XMLHttpRequest();
				request.open('POST', '/ezNewPortal/getApprovalList.do', true);
				request.setRequestHeader('Content-Type', 'application/json');
	
				request.onload = function() {
					if (request.status >= 200 && request.status < 400) {
						var result = JSON.parse(request.responseText);
						
						var docList = result.resultList;
						var docsHTML = "";
						
						if (docList) {
							switch (type) {
							case "doing":
								docList.forEach(function(item, index) {
	// 								index === 0 ? $('#ApprList').append(dataAssemblerApprLine(item, res.listDtl, res.imgPath)) : $('#ApprList').append(dataAssembler(item));
								});
									
				                break;
	
				            case "reject":
								docList.forEach(function(item, index) {
									docsHTML += dataAssembler(item);
								});
								
				                break;
	
				            case "draft":
								docList.forEach(function(item, index) {
									docsHTML += dataAssembler(item);
								});
				            	
				                break;
							}
						} else {
							docsHTML += "<dl class='nodata'>";
							docsHTML += "<dt><img src='/images/kr/main/nodata.png'></dt>";
							docsHTML += "<dd><spring:message code='main.t00026' /></dd>";
							docsHTML += "</dl>";
						}
						
						document.getElementById('ApprList').innerHTML = docsHTML;
					} else {
						// We reached our target server, but it returned an error
					}
				};
	
				request.onerror = function() {
				  // There was a connection error of some sort
				};
				
				var data = JSON.stringify({
					type : type
				});
				
				request.send(data);
			}
			
			var apprChangeTab = function(obj) {
				var type = "";
		        switch (obj.id) {
	            case "doingTab":
	            	type = "doing";
	                document.getElementById("doingTab").className = "on";
	                document.getElementById("rejectTab").className = "";
	                document.getElementById("draftTab").className = "";
	                break;

	            case "rejectTab":
	            	type = "reject";
	                document.getElementById("doingTab").className = "";
	                document.getElementById("rejectTab").className = "on";
	                document.getElementById("draftTab").className = "";
	                break;

	            case "draftTab":
	            	type = "draft";
	                document.getElementById("doingTab").className = "";
	                document.getElementById("rejectTab").className = "";
	                document.getElementById("draftTab").className = "on";
	                break;
		        }
		        
		        getApprovalList(type);
		    }
			
			var Appmore_btnClick = function() {
				if (document.querySelector("div.layDIV.approval dl.portlet_tab.sortablePortlet dt.on").id == "doingTab") {
					window.open("/ezApprovalG/apprGMain.do?listType=1", "main");
				} else {
					window.open("/ezApprovalG/apprGMain.do?listType=2", "main");
				}
		    }
			
			var dataAssembler = function(object) {
				var str = "";
				
				str += '<li onclick=\'opendocview("'+ object.docID +'", "'+ object.href +'", "'+ object.aprMemberID +'", "'+ object.aprMemberName +'", "'+ object.aprMemberDeptID +'", "'+ object.docState +'", "'+ object.functionType +'")\'>';
				str += '	<span class="txt">'+ object.docTitle +'</span>';
				str += '	<span class="date">'+ object.startDate.substr(5, 11).replace(/-/gi,'.')+'</span>';				
				str += '	<span class="name">'+ object.writerName +'</span>';
				str += '</li>';
				
				return str;
			}
		</script>
	</body>
</html>