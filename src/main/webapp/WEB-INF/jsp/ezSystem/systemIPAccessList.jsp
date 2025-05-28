<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
	
		var m_strColorSelect = "#f1f8ff";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		var m_strColorOpened = "#fafafa";
		var allComJson;
		
		window.parent.onresize = function () {
			windowResize();
		}
		
		window.onload = function() {
			getAccessList_http(document.getElementById("ListCompany").value);
			getAllAccessComList();
		}
		
		function getAllAccessComList() {
			$.ajax({
				type : "POST",
				url : "/ezSystem/getAllAccessListCom.do",
				datatype : 'json',
				error : function(data) {
					console.log("error");
				},
				complete : function(data) {
					allComJson = data.responseJSON;
			    }
			});
		}
		
		function getAccessList_http(companyId) {
			$.ajax({
				type : "POST",
				url : "/ezSystem/getAllAccessList.do?companyID=" + companyId,
				datatype : 'json',
				error : function(data) {
					console.log("error");
				},
				complete : function(data) {
					document.getElementById("HeaderAllCheckBox").checked = false;
					IPBandListRemove();
					makeAccessIdList(data.responseJSON);
					windowResize();
			    }
			});
		}
		
		// 접속 허용 리스트들 지우기 (refresh)
		function IPBandListRemove() {
			var ipListElement = $("#tblIP tbody tr[id^=AccessId]");
			
			for (var i = 0; i < ipListElement.length; i++) {
				document.getElementById("tblIP").childNodes[1].removeChild(ipListElement[i]);
			}
		}
		
		function deleteAccessList() {
			var selectedList = $("#tblIP tbody tr[selected=true]");
			var accessNo = "";
			
			if (selectedList.length == 0) {
				alert("<spring:message code='ezSystem.jje18'/>");
				return;
			} else if (selectedList.length == 1) {
				accessNo = selectedList[0].getAttribute("accessno");
			} else {
				for (var i = 0; i < selectedList.length; i++) {
					accessNo += selectedList[i].getAttribute("accessno");
					
					if (i < selectedList.length - 1) {
						accessNo += ",";
					}
				}
			}
			
			var con = confirm("<spring:message code='ezCircular.t46'/>");
			
			if (con) {
				$.ajax({
					type : "POST",
					url : "/ezSystem/deleteAccessList.do?accessNo=" + accessNo,
					error : function(data) {
						alert("<spring:message code='ezSystem.jje11'/>");
					},
					success : function(data) {
					    if (data == "setAccess") {
                            alert("<spring:message code='ezSystem.yja05'/>");
                            return;
                        }
						alert("<spring:message code='ezAttitude.t161'/>");
						IPBandListRemove();
						getAccessList_http(document.getElementById("ListCompany").value);
				    }
				});
			}
		}
		
		function makeAccessIdList(json) {
			var _TBODY = document.getElementById("tblIP").childNodes[1];
			
			if (json.length == 0) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "AccessIdNoData");
				
				var _NODATA = document.createElement("TD");
                _NODATA.colSpan = "3";
                _NODATA.style.textAlign = "center";
                _NODATA.innerHTML = "<spring:message code='ezJournal.t125'/>";
                
				_TR.appendChild(_NODATA);
                _TBODY.appendChild(_TR);
                return;
			}
			
			for (var Cnt = 0; Cnt < json.length; Cnt++) {
				var _TR = document.createElement("TR");
				var cn = json[Cnt].cn;
				_TR.setAttribute("id", "AccessId_" + Cnt);
				_TR.setAttribute("accessno", json[Cnt].accessNo);
				_TR.setAttribute("cn", cn);
				_TR.onclick = function() { event_listclick(this); };
				_TR.onmouseover = function () { event_listMover(this); };
				_TR.onmouseout = function () { event_listMout(this); };
				_TR.style.cursor = "pointer";
				
				var _TDCheckBox = document.createElement("TD");
				_TDCheckBox.onclick = function() { event_listclick(this); };
                _TDCheckBox.style.width = "22px";
                _TDCheckBox.style.textAlign = "center";
                _TDCheckBox.style.cursor = "default";
                
                var _TDCheckBox_Sub = document.createElement("INPUT");
                _TDCheckBox_Sub.type = "checkbox";
                _TDCheckBox_Sub.style.margin = "0px";
                _TDCheckBox_Sub.style.padding = "0px";
                _TDCheckBox_Sub.style.width = "13px";
                _TDCheckBox_Sub.style.height = "13px";
                _TDCheckBox_Sub.style.cursor = "pointer";
                
                _TDCheckBox.appendChild(_TDCheckBox_Sub);
                _TR.appendChild(_TDCheckBox);
                
                var _CN = document.createElement("TD");
                _CN.style.width = "45%";
                _CN.innerText = json[Cnt].name + "(" + json[Cnt].cn + ")";
                _TR.appendChild(_CN);
                
                var _DEPARTMENT = document.createElement("TD");
                _DEPARTMENT.innerText = json[Cnt].department
                _TR.appendChild(_DEPARTMENT);
                
                _TBODY.appendChild(_TR);
			}
		}
		
		function selectCompanyID() {
			getAllAccessComList();
			getAccessList_http(document.getElementById("ListCompany").value);
		}
		
		var tdChk = false;
		function event_listclick(obj) {
			if (obj.tagName == "TD") {
		        obj = obj.parentElement;
		        tdChk = true;
		    } else {
		    	if (!tdChk) {
		    		var selectedList = $("#tblIP tbody tr[selected=true]");
			    	
			    	for (var i = 0; i < selectedList.length; i++) {
			    		selectedList[i].style.backgroundColor = m_strColorDefault;
			    		selectedList[i].childNodes.item(0).childNodes.item(0).checked = false;
			    		selectedList[i].setAttribute("selected", false);
			    	}
		    	}
		    	tdChk = false;
		    }
			
			if (obj.childNodes.item(0).childNodes.item(0).checked) {
				obj.style.backgroundColor = m_strColorDefault;
				obj.childNodes.item(0).childNodes.item(0).checked = false;
				obj.setAttribute("selected", false);
			} else {
				obj.style.backgroundColor = m_strColorSelect;
				obj.childNodes.item(0).childNodes.item(0).checked = true;
				obj.setAttribute("selected", true);
			}
		}
		
		function event_HeaderCheckBoxClick(obj) {
			var accessListElement = $("#tblIP tbody tr[id^=AccessId_]");
			
			if (accessListElement.length == 0) {
				return;
			}
			
			if (obj.checked) {
				for (var i = 0; i < accessListElement.length; i++) {
		        	var accessNode = accessListElement[i];
		        	accessNode.style.backgroundColor = m_strColorSelect;
		        	accessNode.childNodes[0].childNodes[0].checked = true;
		        	accessNode.setAttribute("selected", true);
		        }
			} else {
				for (var i = 0; i < accessListElement.length; i++) {
		        	var accessNode = accessListElement[i];
		        	accessNode.style.backgroundColor = m_strColorDefault;
		        	accessNode.childNodes[0].childNodes[0].checked = false;
		        	accessNode.setAttribute("selected", false);
		        }
			}
		}
		
		function event_listMover(obj) {
		    if (!obj.childNodes.item(0).childNodes.item(0).checked) {
		        obj.style.backgroundColor = m_strColorOver;
		    }
		}
		
		function event_listMout(obj) {
		    if (!obj.childNodes.item(0).childNodes.item(0).checked) {
		        obj.style.backgroundColor = m_strColorDefault;
		    }
		}
		
		function ipListAddPopUp() {
			var companyId = document.getElementById("ListCompany").value;
			var url = "/ezSystem/systemAddAccessList.do?companyId=" + companyId;
			var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(970, 600));
		}
		
		function windowResize() {
			var mainContentDiv = document.getElementById("contentlist");
			var mainContentTable = mainContentDiv.getElementsByTagName("table")[0];
			var mainContentDivTableH = mainContentTable.offsetHeight;
			var mainContentDivMaxH = mainContentDiv.getAttribute("data-maxH");
			
			if (mainContentDivTableH > mainContentDivMaxH) {
				mainContentDiv.style.height = mainContentDivMaxH + "px";
			}
			
			var iframeH = parent.document.getElementById("ipManager_ifrm").offsetHeight;
			var bodyH = document.body.offsetHeight;
			var iframeMH = parent.document.getElementById("ipManager_ifrm").style.maxHeight.split("px")[0];
			
			if (iframeH <= bodyH) {
				if (iframeMH < bodyH) {
					parent.document.getElementById("ipManager_ifrm").style.height = iframeMH + "px";
				} else {
					parent.document.getElementById("ipManager_ifrm").style.height = bodyH + "px";
				}
			} else {
				parent.document.getElementById("ipManager_ifrm").style.height = bodyH + "px";
			}
			
        	/* var height = parent.document.documentElement.clientHeight - 270;
        	var width = parent.document.documentElement.clientWidth - 30;
        	/* if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
        		height = height - 10;
        	} *
        	document.getElementById("contentHeader").style.width = width + "px";
        	document.getElementById("contentlist").style.width = width + "px";
        	document.getElementById("contentlist").style.height = height + "px";
        	document.getElementById("contentlist").style.overflow = "auto"; */
        }
		
		/* $(function(){
    		windowResize();
	    }); */
		
	</script>
</head>
<body class="mainbody" style="overflow:hidden;">
	<br><span><b><spring:message code = 'ezApprovalG.t1566' /> : </b>
	    <select id="ListCompany" onchange="selectCompanyID()" style="height:29px">
        	<c:forEach var="item" items="${list}">
        		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
    </span><br>
	<br><span class="txt">▒ <spring:message code='ezSystem.jje19'/></span><br><br>
	<div id="mainmenu">
	    <ul class="on">
	        <li><span onclick="ipListAddPopUp()"><spring:message code='ezBoard.t602'/></span></li>
	        <li><span onclick="deleteAccessList()"><spring:message code='ezBoard.t89'/></span></li>
	    </ul>
	</div>
	
	<div id="contentHeader" style="width:100%;">
		<table class="mainlist" style="width:100%;">
			<thead id="accessHeader">
				<tr>
	 			<th style="width: 22px; text-align: center;"><input type="checkbox" id="HeaderAllCheckBox" onclick="event_HeaderCheckBoxClick(this)" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
	 			<th width="45%;"><spring:message code='ezEmail.t31'/>(ID)</th>
	 			<th><spring:message code='ezOrgan.t68'/></th>
			</tr>
			</thead>
		</table>
	</div>
	
	
	<div id="contentlist" style="overflow:auto; "data-maxH="350">
		<table id="tblIP" class="mainlist" style="width:100%;">	
			<tbody id="accessBody">
			</tbody>
		</table>
	</div>
	<br>
	
</body>
</html>