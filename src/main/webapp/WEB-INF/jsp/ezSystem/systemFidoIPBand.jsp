<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var useIPAccess = "${useIPAccess}";
		var useFido = "${useFido}";
		var companyID = "${companyId}";
		var permission = true;
		var allIPList = "";
		
		var m_strColorSelect = "#f1f8ff";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		var m_strColorOpened = "#fafafa";
		
		window.parent.onresize = function () {
			windowResize();
		}
		
		window.onload = function () {
			getIPList_http();
	    }
		
		// 설정된 IP 대역 리스트 가져오기
		function getIPList_http() {
			
			$.ajax({
				type : "POST",
				url : "/ezSystem/getfidoIPBandList.do",
				datatype : 'json',
				data : JSON.stringify({companyId : "${companyId}"}),
				contentType: "application/json; charset=UTF-8",
				error : function(data) {
					console.log("error");
				},
				complete : function(data) {
					allIPList = data.responseJSON
					document.getElementById("HeaderAllCheckBox").checked = false;
					makeIPBands(allIPList);
					windowResize();
				}
			});
		}
		
		// 설정된 IP 대역 리스트 삭제하기 (refresh할때 사용)
		function IPBandListRemove() {
			var ipListElement = $("#tblIP tbody tr[id^=IPBand]");
			
			for (var i = 0; i < ipListElement.length; i++) {
				document.getElementById("ipBody").removeChild(ipListElement[i]);
			}
		}
		
		function makeIPBands(json) {
			var _TBODY = document.getElementById("ipBody");
			
			if (json.length == 0) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "IPBandNoData");
				
				var _NODATA = document.createElement("TD");
                _NODATA.colSpan = "4";
                _NODATA.style.textAlign = "center";
                _NODATA.innerHTML = "<spring:message code='ezStatistics.t1008'/>";
                
				_TR.appendChild(_NODATA);
                _TBODY.appendChild(_TR);
                return;
			}
			
			for (var Cnt = 0; Cnt < json.length; Cnt++) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "IPBand_" + Cnt);
				_TR.setAttribute("ipno", json[Cnt].ipNo);
				_TR.onclick = function() { event_listclick(this); };
				_TR.onmouseover = function () { event_listMover(this); };
				_TR.onmouseout = function () { event_listMout(this); };
				_TR.ondblclick = function () {
					if (!permission) {
						alert("<spring:message code='ezSystem.jje7'/>");
						return;
					}
					ipBandUpdateInfo(this); 
				};
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
                
                var _IPADDRESS = document.createElement("TD");
                _IPADDRESS.style.width = "230px";
                _IPADDRESS.innerHTML = json[Cnt].ipAddress;
                _TR.appendChild(_IPADDRESS);
                
                var _ACCESS = document.createElement("TD");
                _ACCESS.style.width = "100px";
                _ACCESS.innerHTML = json[Cnt].access == "YES" ? "<spring:message code='ezSystem.jje21'/>" : "<spring:message code='ezSystem.jje22'/>";
                _TR.appendChild(_ACCESS);
                
                var _EXPLANATION = document.createElement("TD");
                var _SPAN = document.createElement("span");
                _EXPLANATION.title = json[Cnt].explanation;
                _SPAN.innerText = json[Cnt].explanation;
                _SPAN.style.display = "inline-block";
                _SPAN.style.width = "100%";
                _SPAN.style.whiteSpace = "nowrap";
                _SPAN.style.overflow = "hidden";
                _SPAN.style.textOverflow = "ellipsis";
                _EXPLANATION.appendChild(_SPAN);
                _TR.appendChild(_EXPLANATION);
                
                _TBODY.appendChild(_TR);
			}
		}
		
		// IP 대역 등록 및 수정
		function ipBandEidtPopUp(type) {
			var url = "/ezSystem/systemIPBandEditPopup.do";
			if (type === "add") {
				url += "?type=add&pageType=fidoAuthentication&companyId=" + companyID;
				var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(460, 210));
			} else {
				var selectedList = $("#tblIP tbody tr[selected=true]");
				if (selectedList.length > 1) {
					alert("<spring:message code='ezSystem.jje8'/>");
					return;
				} else if (selectedList.length == 0) {
					alert("<spring:message code='ezSystem.jje9'/>");
					return;
				} else {
					ipBandUpdateInfo(selectedList[0]);
				}
			}
		}
		
		function ipBandUpdateInfo(obj) {
			var ipNo = obj.getAttribute("ipNo");
			var ipAddress = obj.childNodes[1].innerText;
			var explanation = obj.childNodes[3].innerText;
			var url = "/ezSystem/systemIPBandEditPopup.do";
			
			url += "?type=modify&pageType=fidoAuthentication&ipNo=" + ipNo + "&ipAddress=" + ipAddress + "&companyId=" + companyID + "&explanation=" + encodeURIComponent(explanation);
			
			var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(460, 210));
		}
		
		function deleteIPBand() {
			var selectedList = $("#tblIP tbody tr[selected=true]");
			var ipNo = "";
			
			if (selectedList.length == 0) {
				alert("<spring:message code='ezSystem.jje10'/>");
				return;
			} else if (selectedList.length == 1) {
				ipNo = selectedList[0].getAttribute("ipno");
			} else {
				for (var i = 0; i <selectedList.length; i++) {
					ipNo += selectedList[i].getAttribute("ipno");
					
					if (i < selectedList.length - 1) {
						ipNo += ",";
					}
				}
			}
			
			var con = confirm("<spring:message code='ezCircular.t46'/>");
			
			if (con) {
				$.ajax({
					type : "POST",
					url : "/ezSystem/deleteFidoIPBand.do",
					data : "ipNo=" + ipNo,
					error : function(data) {
						alert("<spring:message code='ezSystem.jje11'/>");
					},
					complete : function(data) {
						alert("<spring:message code='ezAttitude.t161'/>");
						IPBandListRemove();
						getIPList_http();
				    }
				});
			}
			
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
			var ipListElement = $("#tblIP tbody tr[id^=IPBand_]");
			
			// 설정한 IP대역이 없을 경우
			if (ipListElement.length == 0) {
				return;
			}
			
			if (obj.checked) {
				for (var i = 0; i < ipListElement.length; i++) {
		        	var ipNode = ipListElement[i];
		        	ipNode.style.backgroundColor = m_strColorSelect;
		        	ipNode.childNodes[0].childNodes[0].checked = true;
		        	ipNode.setAttribute("selected", true);
		        }
			} else {
				for (var i = 0; i < ipListElement.length; i++) {
		        	var ipNode = ipListElement[i];
		        	ipNode.style.backgroundColor = m_strColorDefault;
		        	ipNode.childNodes[0].childNodes[0].checked = false;
		        	ipNode.setAttribute("selected", false);
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
		
		function windowResize() {
			var mainContentDiv = document.getElementById("contentlist");
			var mainContentTable = mainContentDiv.getElementsByTagName("table")[0];
			var mainContentDivTableH = mainContentTable.offsetHeight;
			var mainContentDivMaxH = mainContentDiv.getAttribute("data-maxH");
			
			if (mainContentDivTableH > mainContentDivMaxH) {
				mainContentDiv.style.height = mainContentDivMaxH + "px";
			}
			
			var iframeH = parent.document.getElementById("fidoIpManager_ifrm").offsetHeight;
			var bodyH = document.body.offsetHeight;
			var iframeMH = parent.document.getElementById("fidoIpManager_ifrm").style.maxHeight.split("px")[0];
			
			if (iframeH <= bodyH) {
				if (iframeMH < bodyH) {
					parent.document.getElementById("fidoIpManager_ifrm").style.height = iframeMH + "px";
				} else {
					parent.document.getElementById("fidoIpManager_ifrm").style.height = bodyH + "px";
				}
			} else {
				parent.document.getElementById("fidoIpManager_ifrm").style.height = bodyH + "px";
			}
        }
		
	</script>
</head>
<body class="mainbody" style="overflow:hidden; margin:0;" >
	<br>
	<div id="mainmenu">
	    <ul class="on">
	        <li class="important"><span id="btn3" onclick="ipBandEidtPopUp('add')"><spring:message code='ezBoard.t602'/></span></li>
	        <li><span id="btn4" onclick="ipBandEidtPopUp('modify')"><spring:message code='ezQuestion.t480'/></span></li>
	        <li><span class="" id="btn5" onclick="deleteIPBand()"><spring:message code='ezSystem.jhy05'/></span></li>
	    </ul>
	</div>
	
	<div id="contentHeader">
		<table class="mainlist" style="width:100%;">
			<thead id="ipHeader">
				<tr>
					<th style="width: 22px; text-align: center;"><input type="checkbox" id="HeaderAllCheckBox" onclick="event_HeaderCheckBoxClick(this)" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
		 			<th width="230px;"><spring:message code='ezSystem.jje5'/></th>
		 			<th width="100px; text-algin:center;"><spring:message code='ezSystem.jje3'/></th>
		 			<th><spring:message code='ezCommunity.t383'/></th>
				</tr>
			</thead>
		</table>
	</div>
	<div id="contentlist" style="overflow:auto;" data-maxH="350">
		<table id="tblIP" class="mainlist" style="width:100%;">	
			<tbody id="ipBody">
				
			</tbody>
			
		</table>
	</div>
	<br>
</body>
</html>