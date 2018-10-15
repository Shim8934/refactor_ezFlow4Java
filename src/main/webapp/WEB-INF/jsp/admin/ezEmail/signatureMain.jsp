<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height: 99%;">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
		<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript">
	    	var companyID = "${userInfo.companyID}";
			var m_strColorSelect = "#edf4fd";
			var m_strColorOver = "#f4f5f5";
			var m_strColorDefault = "#ffffff";
			var m_strColorOpened = "#fafafa";
			var searchMode = false; 
	    	
	        window.onload = function () {
	        	companyID = document.getElementById("ListCompany") != null ? document.getElementById("ListCompany").value : companyID;
	        	signatureTemplateView();
	        };
	        
	        // 초기화면
	        function signatureTemplateView() {
	        	
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezEmail/readSignList.do?companyId=" + companyID,
	        		datatype : 'json',
	        		error : function(data) {
	        			alert("error");
	        			console.log(data);
	        		},
	        		complete : function(data) {
	        			makeSignatureList(data.responseJSON);
	        	    }
	        	});
	        }
	        
	        // 목록 보여주기
	        function makeSignatureList(json) { 
	        	var _TBODY = document.getElementById("signList");
				
				if (json.length == 0) {
					var _TR = document.createElement("TR");
					_TR.setAttribute("id", "signatureTemplateNoData");
					
					var _NODATA = document.createElement("TD");
	                _NODATA.style.textAlign = "center";
	                _NODATA.style.border = "none";
	                _NODATA.style.borderBottom = "1px solid #f2f2f2";
	                _NODATA.style.padding = "0";
	                _NODATA.innerHTML = "<spring:message code='ezStatistics.t1008'/>";
	                
					_TR.appendChild(_NODATA);
	                _TBODY.appendChild(_TR);
	                return;
				}
				
				for (var Cnt = 0; Cnt < json.length; Cnt++) {
					var _TR = document.createElement("TR");
					_TR.setAttribute("id", "signTemplate_" + Cnt);
					_TR.setAttribute("signNo", json[Cnt].signNo);
					_TR.onclick = function() { event_listclick(this); };
					_TR.onmouseover = function () { event_listMover(this); };
					_TR.onmouseout = function () { event_listMout(this); };
					_TR.style.cursor = "pointer";
					var _TD = document.createElement("TD");
	                var _SPAN = document.createElement("span");
	                _TD.style.border = "none";
	                _TD.style.borderBottom = "1px solid #f2f2f2";
	                _TD.style.padding = "0";
	                
	                _SPAN.innerText = json[Cnt].displayname;
	                _SPAN.title = json[Cnt].displayname;
	                _SPAN.style.lineHeight = "30px";
	                _SPAN.style.float = "left";
	                _SPAN.style.display = "inline-block";
	                _SPAN.style.width = "70%";
	                _SPAN.style.whiteSpace = "nowrap";
	                _SPAN.style.overflow = "hidden";
	                _SPAN.style.textOverflow = "ellipsis";
	                _TD.appendChild(_SPAN);
	                _TR.appendChild(_TD);
	                
	                var _DIV = document.createElement("DIV")
	                _DIV.style.float = "left";
	                _DIV.style.marginLeft = "13px";
	                _DIV.style.lineHeight = "30px";
	                var _EDIT = document.createElement("BUTTON");
	                var _DEL = document.createElement("BUTTON");
	                _EDIT.innerHTML = "수정";
	                _EDIT.style.marginRight = "3px";
	                _EDIT.setAttribute("class", "lmLetterModifyBtn");
	                _EDIT.onclick = function() { signEditPopUp(this, "modify"); };
	                _DEL.innerHTML = "삭제";
	                _DEL.setAttribute("class", "lmLetterDeleteBtn");
	                _DEL.onclick = function() { deleteSignTemplate(this); };
	                
	                _DIV.appendChild(_EDIT);
	                _DIV.appendChild(_DEL);
	                
	                _TD.appendChild(_DIV);
	                _TBODY.appendChild(_TR);
				}
	        }
	        
	        // 서명 템플릿 삭제
	        function deleteSignTemplate(obj) {
	        	var signNo = obj.parentElement.parentElement.parentElement.getAttribute("signno");
	        	
	        	var deleteConfirm = confirm("정말로 삭제하시겠습니까?");
	        	
	        	if (deleteConfirm) {
	        		$.ajax({
		        		type : "POST",
		        		url : "/admin/ezEmail/deleteSignTemplate.do?signNo=" + signNo,
		        		datatype : 'json',
		        		error : function(data) {
		        			alert("error");
		        			console.log(data);
		        		},
		        		complete : function(data) {
		        			alert("삭제 하였습니다.");
		        			if (searchMode) {
		        				// 검색 중 삭제한 리스트만 없애기
		        				$("#signList tr[signno=" + signNo +"]").remove();
		        				
		        				// 검색 중 데이터 다 삭제 되었을 때
		        				if ($("#signList tr").length == 0) {
		        					var _TBODY = document.getElementById("signList");
	        						var _TR = document.createElement("TR");
	        						_TR.setAttribute("id", "signatureTemplateNoData");
	        						
	        						var _NODATA = document.createElement("TD");
	        		                _NODATA.style.textAlign = "center";
	        		                _NODATA.style.border = "none";
	        		                _NODATA.style.borderBottom = "1px solid #f2f2f2";
	        		                _NODATA.style.padding = "0";
	        		                _NODATA.innerHTML = "<spring:message code='ezStatistics.t1008'/>";
	        		                
	        						_TR.appendChild(_NODATA);
	        		                _TBODY.appendChild(_TR);
		        				}
		        				
		        			} else {
		        				$("#signList *").remove();
			        			signatureTemplateView();
		        			}
		        			
		        	    }
		        	});
	        	} else {
	        		return;
	        	}
	        }
	        
	        // 템플릿 추가, 수정
			function signEditPopUp(obj, type) {
	        	var signno = 0;
	        	if (obj.getAttribute("class") == 'lmLetterModifyBtn') {
	        		signno = obj.parentElement.parentElement.parentElement.getAttribute("signno");
	        	}
	        	
				var popUpType = "";
				var url = "/admin/ezEmail/signEditPopUp.do?type=" + type + "&paramSignNo=" + signno;
				var signPopUp = window.open(url, "signPopUp", GetOpenWindowfeature(1000, 660));
			}
	        
	        // 검색 리스트 가져오기
	        function searchSignList() {
	        	var search = document.getElementById("signSearchInput").value;
	        	
	        	if (search == '' || search.length == 0) {
	        		alert("검색어를 입력해주세요.");
	        		return;
	        	}
	        	
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezEmail/searchSignList.do?companyId=" + companyID + "&search=" + encodeURIComponent(search),
	        		datatype : 'json',
	        		error : function(data) {
	        			alert("error");
	        			console.log(data);
	        		},
	        		complete : function(data) {
	        			searchMode = true;
	        			$("#signList *").remove();
	        			makeSignatureList(data.responseJSON);
	        	    }
	        	});
	        	searchMode = false;
	        	
	        }
	        
	        // 검색 엔터 기능 
	        function signSearchEnter() {
	        	if (event.keyCode == 13) {
	        		searchSignList();
	        	}
	        }
	        
	        // 검색어 초기화
	        function inputReset(){
	        	document.getElementById("signSearchInput").value = "";
	        }
	        
	        // 서명 개별조회 (클릭 시)
	        function event_listclick(obj) {
	        	var prevSelected = $("#signList tr[selected=true]")[0];
	        	if (prevSelected != undefined) {
	        		prevSelected.childNodes[0].style.backgroundColor = m_strColorDefault;
		        	prevSelected.setAttribute("selected", "false");
	        	}
	        	
	        	obj.childNodes[0].style.backgroundColor = m_strColorSelect;
	        	obj.setAttribute("selected", "true");
	        	
	        	signPreview(obj.getAttribute("signno"));
	        	
	        }
	        
	        // 서명 미리보기 
	        function signPreview(signno) {
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezEmail/signaturePreview.do?signNo=" + signno,
	        		datatype : 'json',
	        		error : function(data) {
	        			alert("error");
	        			console.log(data);
	        		},
	        		complete : function(data) {
	        			signPreviewChange(data.responseJSON);
	        	    }
	        	});
	        }
	        
	        function signPreviewChange(data) {
	        	var preTxt = $(".signPreViewTxt")[0];
	        	var preIframe = $(".signPreViewIframe");
	        	var txtDisplay = "block";
	        	var iframeDisplay = "none";
	        	var txtText = data[0].content;
	        	//var strLang = typeof(userLang) == "undefined" ? 1 : userLang;
	        	
	        	if (data !== undefined) {
	        		preTxt.style.textAlign = "justify";
	        		preTxt.style.position = "none";
	        		preTxt.style.top = "0";
	        		preTxt.style.transform = "none";
	        		preTxt.style.display = txtDisplay;
		        	preIframe[0].style.display = iframeDisplay;
		        	preTxt.innerHTML = txtText;
	        	}
	        	
	        	
	        }
	        
	        function event_listMover(obj) {
	        	if (obj.getAttribute("selected") != "true") {
	        		obj.childNodes[0].style.backgroundColor = m_strColorOver;
	        	}
	        	
	        }
	        
	        function event_listMout(obj) {
	        	if (obj.getAttribute("selected") != "true") {
	        		obj.childNodes[0].style.backgroundColor = m_strColorDefault;
	        	}
	        	
	        }
	        
	        
	    </script>
	    
	    <style>
	    	.lmtitle {
				font-weight: normal;
			}
			
			.lmLetterModifyBtn, .lmLetterDeleteBtn {
				background-color: #e8e8ea !important;
			}
			
			button {
				background: white;
				border: 1px solid #d2d2d2;
				border-radius: 3px;
				font-size: 12px;
				color: #393939;
				cursor: pointer;
				outline: none;
				height: 22px;
				line-height: 17px;
				vertical-align: middle;
			}
			
			.lmTop button:hover {
				/* color: #0B790E; */
			}
	    </style>
	</head>
	<body class="mainbody" style="height: 95%;">
	    <h1>서명 템플릿 관리<span></span></h1>
	    <span><b><spring:message code = 'ezApprovalG.t1566' /> : </b>
		    <select id="ListCompany" style="height:29px">
	        	<c:forEach var="item" items="${list}">
	        		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
		    </select><br>
	    </span><br><br>
	    
	    
	    <div style="float: left; margin-right: 10px;">
	    <!-- 서명 템플릿 목록 -->
			<table >
				<tr>
					<td>
						<div class="lmLetterBox" style="width: 360px;" > 
							<div class="lmtitle lmLetterBoxTitle">
								<div style="border-top: 0px">
									서명 템플릿
								</div>
									<input type="text" id="signSearchInput" onkeydown="signSearchEnter()" style="height:22px;">
									<button class="lmTop" onclick="searchSignList()">
										검색
									</button>
									<button class="lmTop" onclick="inputReset()">
										초기화
									</button>
							</div>
							<div style="height:418px; overflow:auto;">
								<table class="content" style="width:100%; border:none;">
									<tbody id="signList">
									</tbody>
								</table>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<!-- 미리보기 -->
		<div style="float: left;">
			<table>
			<tr>
				<td>
					<div class="lmright" style="width: 578px; height: 448px">
						<div class="lmPreview">
							<div class="signPreViewTxt"
								style='text-align: center; position: relative; top: 48%; transform: translateY(-50%); font-size:13px'>
								<spring:message code='ezBoard.t431' />
							</div>
							<iframe src="" class="signPreViewIframe lmPre" id="lmPreViewIframe"
								onload=""style="display: none; border: none; width: 100%; height: 100%;"></iframe>
						</div>
					</div>
				</td>
			</tr>
		</table>
		</div>
		
		<!-- 버튼 -->
		<div style="width:950px">
			<div class="boxNo btnpositionJsp" >
				<a class="imgbtn" onClick="signEditPopUp(this, 'add')" style="margin-top: 15px;"><span>서명 템플릿 추가</span></a>
			</div>
		</div>
			
			
	</body>
</html>
