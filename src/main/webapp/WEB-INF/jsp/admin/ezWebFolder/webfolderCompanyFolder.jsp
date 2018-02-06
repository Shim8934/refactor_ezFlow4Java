<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" >        
			var g_windowReference = null;
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var primary			  = "<c:out value='${primary}' />";
			
			window.onload = function () {
				getData();
		    }
			
			function getData() {
				 $.ajax({
						type: "POST",
						url: "/admin/ezWebFolder/getCompanyFolderTree.do",
						data: {							
							"companyId" : document.getElementById("companyList").value						
						},
						dataType: "JSON",
						async: true,
						success : function(data) {
							var result = data.companyTree;		
							renderData(result);
						},
		 				error : function(error) {	 					
							alert("<spring:message code='ezWebFolder.t134' />" + error);
						}
					});		
			}
			
			function renderData(result) {
				if (!result) {
					alert("<spring:message code='ezWebFolder.t134' />");
					return;
				} 
				
				var divTree = document.getElementById("folderTree");				
				var divComp = document.createElement("div");
				
				displaySubFolder(divTree, divComp, result);		
	
			}
			
			function displaySubFolder(divTree, divElmt, list) {
				var level = list["folderLevel"];
				
				if (level > 0) {
					for (var j = 0; j < level; j++) {
						var imgTag = document.createElement("img");
						imgTag.setAttribute("class", "webfolderImg");
						imgTag.src="/images/OrganTree_cross/dot_continue.gif";
						divElmt.appendChild(imgTag);
					}
				}				
				
				var imgElmt = document.createElement("img");				
				imgElmt.setAttribute("id" , list["folderId"]);
				
				var imgElmt2 = document.createElement("img");
				imgElmt2.setAttribute("class", "webfolderImg");
				imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
				
				var spanFolderName = document.createElement("span");
				spanFolderName.innerHTML = list["folderName"];
				spanFolderName.setAttribute("class", "spanName");
				spanFolderName.setAttribute("name", list["folderId"]);				
				spanFolderName.onclick = function() {getSelected(this);};
				
				divElmt.appendChild(imgElmt);
				divElmt.appendChild(imgElmt2);
				divElmt.appendChild(spanFolderName);
				divTree.appendChild(divElmt);
				
				if (list["hasSubFolder"] == "0") {	
					imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
					imgElmt.setAttribute("class", "webfolderImg");
				}
				else {
					imgElmt.onclick = function() {getDetailTree(this);};
					
					if (list["listSubFolders"] == null) {
						imgElmt.src = "/images/OrganTree_cross/plus_normal.gif";
						imgElmt.setAttribute("class", "webfolderPlus");
						return;
					}
					
					imgElmt.src = "/images/OrganTree_cross/minus_normal.gif";
					imgElmt.setAttribute("class", "webfolderMinus");
					
					var len = list["listSubFolders"].length;
					arrSubFolder.push(list["folderId"]);
					
					var newDivElmt = document.createElement("div");
					divElmt.appendChild(newDivElmt);
					
					for (var i = 0; i < len; i++) {
						var subDivElmt = document.createElement("div");
						displaySubFolder(newDivElmt, subDivElmt, list["listSubFolders"][i]);
					}
				}		
			}
			
			function getSelected(obj) {				
				var previousElmt = document.getElementsByName(selectedFolder)[0];
				
				if (previousElmt != null && previousElmt.getAttribute("name") != obj.getAttribute("name")) {
					previousElmt.style.color = "";					
				}
				
				selectedFolder = obj.getAttribute("name");
				obj.style.color = "#e04343";
				
			    $.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFolderUsers.do",
					data: {							
						"folderId" : selectedFolder				
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.folderUsers;						
						processUsersList(result, obj.innerHTML);
					},
	 				error : function(error) {	 					
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});
			}
			
			function processUsersList(result, folerName) {
				document.getElementById("fldName").value = folerName;
				
				if(result == null || result.length == 0) {
					document.getElementById("RangeXMLStr").value = "";				
				}
				else {
					var target   = "";
					var xmlStr   = "<RANGE>";
					var xmlUsers = "<MEMBER>";
					var xmlDepts = "<DEPT>";
					
					for (var i = 0; i < result.length; i++) {
						target = primary == "1" ? (target + result[i]["displayName1"] + ",") : (target + result[i]["displayName2"] + ",");
						
						if (result[i]["userType"] == "user") {
							xmlUsers += "<DATA id=\"" + result[i]["userId"] + "\" nm=\"" + result[i]["displayName1"] + 
		        			"\" nm2=\"" + result[i]["displayName2"] + "\">" + result[i]["userId"] + "</DATA>";
						}
						else {
							xmlDepts += "<DATA id=\"" + result[i]["userId"] + "\" nm=\"" + result[i]["displayName1"] + 
		        			"\" nm2=\"" + result[i]["displayName2"] + "\">" + result[i]["userId"] + "</DATA>";
						}
						
					}
					
					xmlDepts += "</DEPT>";
					xmlUsers += "</MEMBER>";			
					xmlStr	 += xmlDepts;
					xmlStr	 += xmlUsers;
					xmlStr   += "</RANGE>";
					updateTarget(target.slice(0, -1));
					document.getElementById("RangeXMLStr").value = xmlStr;					
				}
				
			}
			
			function getDetailTree(obj) {
				//Check if already in arrSubFolder
				var uniqueId = obj.getAttribute("id");
				
				if (arrSubFolder.indexOf(uniqueId) != -1) {
					var childElmt = obj.parentElement.lastElementChild;
					
					if (obj.className == "webfolderMinus") {
						obj.src= "/images/OrganTree_cross/plus_normal.gif";
						obj.setAttribute("class", "webfolderPlus");						
						childElmt.style.display = "none";
					}
					else {
						obj.src= "/images/OrganTree_cross/minus_normal.gif";
						obj.setAttribute("class", "webfolderMinus");
						childElmt.style.display = "";
					}
				}
				else {
					obj.src = "/images/OrganTree_cross/minus_normal.gif";
					obj.setAttribute("class", "webfolderMinus");
					
					$.ajax({
						type: "POST",
						url: "/admin/ezWebFolder/getSubFolderTree.do",
						data: {
							"folderId"	: uniqueId
						},
						dataType: "JSON",
						async: true,
						success: function(data) {
							var result = data.subTree;
							displaySubTree(result, obj.parentElement);
							arrSubFolder.push(uniqueId);
						},
						error: function (xhr, status, e){
							alert("<spring:message code='ezWebFolder.t134' />");
						}
					});	
				}
			}
			
			function displaySubTree(result, divElmt) {				
				if (result["listSubFolders"] == null) {
					alert("<spring:message code='ezWebFolder.t134' />");
					return;
				}
				
				var len = result["listSubFolders"].length;				
				var newDivElmt = document.createElement("div");
				divElmt.appendChild(newDivElmt);
				
				for (var i = 0; i < len; i++) {
					var subDiv = document.createElement("div");
					displaySubFolder(newDivElmt, subDiv, result["listSubFolders"][i]);					
				}
			}
			
			function menu_SelectRange() {
		         if (CrossYN()) {
		            var szUrl = "/admin/ezWebFolder/targetSelect.do";        		  
		            var _MSIE = 'MSIE';
		            var useragentstr = navigator.userAgent;
		            
		            if (useragentstr.indexOf(_MSIE) != -1) {	            	
		                var szParam = "dialogHeight:705px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 705);
		                var rv = window.showModalDialog(szUrl, document.getElementById("RangeXMLStr").value, szParam);
		                
		                if (rv[0] == "OK") {
		                    document.getElementById("RangeXMLStr").value = rv[1];
		                } 
		                else if (rv[0] == "NO") {
		                    document.getElementById("RangeXMLStr").value = "";
		                }
		            } 
		            else {	            	
		                if ((g_windowReference == null) || (g_windowReference.closed == true)) {
		                    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
		                        var feature = GetOpenPosition(560, 730);
		                        g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
		                    } 
		                    else {
		                        var feature = GetOpenPosition(730, 700);
		                        g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
		                    }
		                }
		                
		                g_windowReference.focus();
		            }
		        } 
		        else {
		            menu_SelectRange_IE();
		        } 
		    }
			
			function menu_SelectRange_IE() {		 
		        var szUrl = "/admin/ezWebFolder/targetSelect.do"; 
		        
		        if ((g_windowReference == null) || (g_windowReference.closed == true)) {
		            if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
		                var feature = GetOpenPosition(560, 630);
		                g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
		            } 
		            else {
		                var feature = GetOpenPosition(560, 700);
		                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
		            }
		        }
		        
		        g_windowReference.focus();
		    }
			
	    	function GetRangeValue() {
		        return document.getElementById("RangeXMLStr").value;
		    }
			
		    function updateParent(_element, _value, _Type) {
		        var elementRef = document.getElementsByName(_element);
		
		        if (elementRef.length > 0) {
		            switch (_Type) {
		                case "selectedIndex":
		                    elementRef[0].selectedIndex = _value;
		                    break;
		                case "value":
		                    elementRef[0].value = _value;
		                    break;
		            }
		        }
		    }
		    
		    function updateTarget(listOfTarget) {	    	    	
		    	var newTargetDiv = document.getElementById("newTargetDiv");
		    	newTargetDiv.innerHTML = listOfTarget;
		    	newTargetDiv.setAttribute("title", listOfTarget);
		    	newTargetDiv.style.display = "";	    	
		    }
		    
		    function closeWindow() {
		        if ((g_windowReference != null) && (g_windowReference.closed == false)) {
		            g_windowReference.close();
		            g_windowReference = null;
		        }
		    }
			
	    </script>
	</head>
	<body class="mainbody">	
	   <h1><spring:message code='ezWebFolder.t126' /></h1>
	   <div id="companySelect" style="margin: 10px 0px;">
	   		<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
		        	<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		        </c:forEach>
	   		</select>
	   </div>
	   
	   <div style="height: 450px; width: 100%;">
	   		<table style="border-collapse: collapse; width: 100%;">
	   			<tr>
	   				<td style="width: 350px; min-width: 350px;">
	   					<div id="folderTree" style="width: 350px; height: 450px; border: 1px solid #666666;"></div>
	   				</td>
	   				<td>
	   					<div style="width: 500px; height: 450px; border: 1px solid #cccccc; margin-left: 10px;">
	   						<table>
	   							<tr>
	   								<td>
		   								<div style="margin: 100px 20px 20px 20px;">
		   									<span>폴더명: </span>
		   									<input id="fldName" type="text" style="height: 25px; border-radius: 3px; border: 1px solid #666; width: 200px; margin-left: 2px;">
		   								</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 10px 20px;">
	   										<span>구성원:</span>
	   										<span id="newTargetDiv"></span>
	   									</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 20px 20px 100px 20px;">
	   										<a class="webfolderBttn2"><span onclick="menu_SelectRange();">조직도</span></a>
	   									</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 0px 96px;">
	   										<a class="webfolderBttn"><span onclick="">저장</span></a>
		   									<a class="webfolderBttn"><span onclick="">하위폴더</span></a>
		   									<a class="webfolderBttn"><span onclick="">이동</span></a>
		   									<a class="webfolderBttn"><span onclick="">삭제</span></a>
	   									</div>
	   								</td>
	   							</tr>
	   						</table>
	   					</div>
	   				</td>
	   			</tr>	   			
	   		</table>
	   		
	   </div>
	   
	   <input type="text" name="RangeXMLStr" id="RangeXMLStr" style="display:none">
	</body>
</html>