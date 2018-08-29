<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var useIPAccess = "${useIPAccess}";
		var httpRequest;
		
		var m_strColorSelect = "#edf4fd";
		var m_strColorOver = "#f4f5f5";
		var m_strColorDefault = "#ffffff";
		var m_strColorOpened = "#fafafa";
		
		window.onload = function () {
			if (useIPAccess === "NO") {
				document.getElementById("ipRadio0").checked = true;
			} else {
				document.getElementById("ipRadio1").checked = true;
			}
			
			getIPList_http();
	    }
		
		// 사용여부 저장 버튼 클릭
		function saveBtn() {
			var allowResult = false;
			if (!document.getElementById("ipRadio0").checked) {
				allowResult = true;
			}
			
			$.ajax({
				type : "POST",
				url : "/ezSystem/setUseIPAccess.do?allowResult=" + allowResult,
				cache : false,
				error : function(data) {
					console.log(data);
					alert("실패하였습니다.");
				},
				complete : function(data) {
					alert("저장하였습니다.");
				}
			});
		}
		
		// 설정된 IP 대역 리스트 뿌리기
		function getIPList_http() {
			$.ajax({
				type : "POST",
				url : "/ezSystem/getAllIPBands.do",
				datatype : 'json',
				error : function(data) {
					console.log("error");
				},
				complete : function(data) {
					makeIPBands(data.responseJSON);
			    }
			});
		}
		
		function makeIPBands(json) {
			var _TBODY = document.getElementById("tblIP").childNodes[1];
			
			if (json.length == 0) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "noData");
				
				var _NODATA = document.createElement("TD");
                _NODATA.colSpan = "4";
                _NODATA.style.textAlign = "center";
                _NODATA.innerHTML = "데이터가 없습니다.";
                
				_TR.appendChild(_NODATA);
                _TBODY.appendChild(_TR);
                return;
			}
			
			for (var Cnt = 0; Cnt < json.length; Cnt++) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "IPBand_" + Cnt);
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
                
                var _IPADDRESS = document.createElement("TD");
                _IPADDRESS.style.width = "230px";
                _IPADDRESS.innerHTML = json[Cnt].ipAddress;
                _TR.appendChild(_IPADDRESS);
                
                var _ACCESS = document.createElement("TD");
                _ACCESS.style.width = "100px";
                _ACCESS.innerHTML = json[Cnt].access == "YES" ? "허용" : "거부";
                _TR.appendChild(_ACCESS);
                
                var _EXPLANATION = document.createElement("TD");
                _EXPLANATION.innerHTML = json[Cnt].explanation;
                _TR.appendChild(_EXPLANATION);
                
                _TBODY.appendChild(_TR);
			}
		}
		
		function cancleBtn() {
			if (useIPAccess === "NO") {
				document.getElementById("ipRadio0").checked = true;
			} else {
				document.getElementById("ipRadio1").checked = true;
			}
		}
	
		// IP 대역 등록 및 수정
		function ipBandEidtPopUp(type) {
			var url = "/ezSystem/systemIPBandEditPopup.do";
			if (type === "add") {
				url += "?type=add";
			} else {
				var selectedList = $("#tblIP tbody tr[selected=true]");
				if (selectedList.length > 1) {
					alert("수정할 IP대역 리스트를 한개만 선택해주세요.");
					return;
				} else if (selectedList.length == 0) {
					alert("수정할 IP대역 리스트를 선택해주세요.");
					return;
				} else {
					var ipAddress = selectedList[0].childNodes[1].innerText;
					var access = selectedList[0].childNodes[2].innerText == "허용" ? "YES" : "NO";
					var explanation = selectedList[0].childNodes[3].innerText;
					
					url += "?type=modify&ipAddress=" + ipAddress + "&access=" + access + "&explanation=" + explanation;
				}
			}
			
			var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(460, 210));
		}
		
		function deleteIPBand() {
			var selectedList = $("#tblIP tbody tr[selected=true]");
			
			if (selectedList.length == 0) {
				alert("삭제할 IP대역 리스트를 선택해주세요.");
				return;
			}
			var ipAddress = selectedList[0].childNodes[1].innerText;
			var con = confirm("삭제하시겠습니까?");
			
			if (con) {
				$.ajax({
					type : "POST",
					url : "/ezSystem/deleteIPBand.do",
					data : "ipAddress=" + ipAddress,
					error : function(data) {
						console.log("error");
						alert("삭제 실패");
					},
					complete : function(data) {
						alert("삭제하였습니다.");
				    }
				});
			}
			
		}
		
		function event_listclick(obj) {
			if (obj.tagName == "TD") {
		        obj = obj.parentElement;
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
			var ipListElement = $("#tblIP tbody tr[id^=IPBand]");
			
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
		
	</script>
</head>
<body class="mainbody">
	<br><span class="txt">▒ IP 주소를 사용하여 허용된 IP(IP대역)에서만 접속 할 수 있습니다.</span><br><br>
	
	<table class="content" style="width:600px;">
		<tr>
			<th rowspan="2" style="width: 60px;">사용여부선택</th>
			<td>&nbsp;<label id="radioFalse"><input name="ipRadio" type="radio" id="ipRadio0"><span style="vertical-align:middle;">&nbsp;사용안함</span></label></td>
	    </tr>
	    <tr>
			<td>&nbsp;<label id="radioTrue"><input name="ipRadio" type="radio" id="ipRadio1"><span style="vertical-align:middle;">&nbsp;사용함</span></label></td>
		</tr>
	</table>
	
	<div style="width:600px;">
		<div class="btnpositionJsp">
	    	<a class="imgbtn" onClick="saveBtn()"><span>저장</span></a>
	    	<a class="imgbtn" onClick="cancleBtn()"><span>취소</span></a>
	    </div>
	</div> 
	<div id="mainmenu">
	    <ul class="on">
	        <li><span onclick="ipBandEidtPopUp('add')">추가</span></li>
	        <li><span onclick="ipBandEidtPopUp('modify')">수정</span></li>
	        <li><span onclick="deleteIPBand()">삭제</span></li>
	    </ul>
	</div>
	
	<table id="tblIP" class="mainlist" style="width:100%;">	
		<tr>
			<th style="width: 22px; text-align: center;"><input type="checkbox" id="HeaderAllCheckBox" onclick="event_HeaderCheckBoxClick(this)" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
 			<th width="230px;">IP 주소</th>
 			<th width="100px; text-algin:center;">허용여부</th>
 			<th>설명</th>
		</tr>
	</table>
	
</body>
</html>