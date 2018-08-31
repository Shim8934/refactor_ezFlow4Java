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
		
		window.onload = function() {
			getAccessList_http(document.getElementById("ListCompany").value);
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
		
		function makeAccessIdList(json) {
			var _TBODY = document.getElementById("tblIP").childNodes[1];
			
			if (json.length == 0) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "AccessIdNoData");
				
				var _NODATA = document.createElement("TD");
                _NODATA.colSpan = "3";
                _NODATA.style.textAlign = "center";
                _NODATA.innerHTML = "데이터가 없습니다.";
                
				_TR.appendChild(_NODATA);
                _TBODY.appendChild(_TR);
                return;
			}
			
			for (var Cnt = 0; Cnt < json.length; Cnt++) {
				var _TR = document.createElement("TR");
				_TR.setAttribute("id", "AccessId_" + Cnt);
				_TR.setAttribute("accessno", json[Cnt].accessNo);
				/* _TR.onclick = function() { event_listclick(this); };
				_TR.onmouseover = function () { event_listMover(this); };
				_TR.onmouseout = function () { event_listMout(this); };
				_TR.ondblclick = function () { ipBandUpdateInfo(this); }; */
				_TR.style.cursor = "pointer";
				
				var _TDCheckBox = document.createElement("TD");
				//_TDCheckBox.onclick = function() { event_listclick(this); };
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
                _CN.style.width = "230px";
                _CN.innerText = json[Cnt].cn;
                _TR.appendChild(_CN);
                
                var _DEPARTMENT = document.createElement("TD");
                _DEPARTMENT.style.width = "100px";
                _DEPARTMENT.innerText = json[Cnt].department
                _TR.appendChild(_DEPARTMENT);
                
                _TBODY.appendChild(_TR);
			}
		}
		
		function selectCompanyID() {
			getAccessList_http(document.getElementById("ListCompany").value);
		}
		
		function ipListAddPopUp() {
			var url = "/ezSystem/systemAddAccessList.do";
			var ipPopUp = window.open(url, "ipPopUp", GetOpenWindowfeature(970, 600));
		}
	</script>
</head>
<body class="mainbody">
	<br><span><b><spring:message code = 'ezApprovalG.t1566' /> : </b>
	    <select id="ListCompany" onchange="selectCompanyID()" style="height:29px">
        	<c:forEach var="item" items="${list}">
        		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
           	</c:forEach>
	    </select>
    </span><br>
	<br><span class="txt">▒ 거부된 IP(IP대역)에서도 접속 가능한 사용자 및 부서 리스트</span><br><br>
	<div id="mainmenu">
	    <ul class="on">
	        <li><span onclick="ipListAddPopUp()">추가</span></li>
	        <li><span onclick="alert('삭제')">삭제</span></li>
	    </ul>
	</div>
	
	<table id="tblIP" class="mainlist" style="width:50%;">	
		<tr>
 			<th style="width: 22px; text-align: center;"><input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
 			<th width="45%;">이름(ID)</th>
 			<th>부서</th>
		</tr>
	</table>
	
</body>
</html>