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
	    	
	        window.onload = function () {
	        	companyID = document.getElementById("ListCompany") != null ? document.getElementById("ListCompany").value : companyID;
	        	signatureTemplateView();
	        };
	        
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
	        
	        function makeSignatureList(json) { 
	        	var _TBODY = document.getElementById("signList");
				
				if (json.length == 0) {
					var _TR = document.createElement("TR");
					_TR.setAttribute("id", "signatureTemplateNoData");
					
					var _NODATA = document.createElement("TD");
	                _NODATA.style.textAlign = "center";
	                _NODATA.innerHTML = "<spring:message code='ezStatistics.t1008'/>";
	                
					_TR.appendChild(_NODATA);
	                _TBODY.appendChild(_TR);
	                return;
				}
				
				for (var Cnt = 0; Cnt < json.length; Cnt++) {
					var _TR = document.createElement("TR");
					_TR.setAttribute("id", "signTemplate_" + Cnt);
					_TR.setAttribute("signNo", json[Cnt].signNo);
					/* _TR.onclick = function() { event_listclick(this); };
					_TR.onmouseover = function () { event_listMover(this); };
					_TR.onmouseout = function () { event_listMout(this); }; */
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
	                _DEL.innerHTML = "삭제";
	                _DEL.setAttribute("class", "lmLetterDeleteBtn");
	                _EDIT.setAttribute("class", "lmLetterModifyBtn");
	                _DIV.appendChild(_EDIT);
	                _DIV.appendChild(_DEL);
	                
	                _TD.appendChild(_DIV);
	                _TBODY.appendChild(_TR);
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
									<input type="text" id="lmSearchInput" onkeydown="" style="height:22px;">
									<button class="lmTop">
										검색
									</button>
									<button class="lmTop">
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
							<div class="lmPreViewTxt"
								style='text-align: center; position: relative; top: 48%; transform: translateY(-50%); font-size:13px'>
								<spring:message code='ezBoard.t431' />
							</div>
							<iframe src="" class="lmPreViewIframe lmPre" id="lmPreViewIframe"
								onload="onloadPreview(this)" name="lmPreViewIframe"
								style="display: none; border: none; width: 100%; height: 100%;"></iframe>
						</div>
					</div>
				</td>
			</tr>
		</table>
		</div>
		
		<!-- 버튼 -->
		<div style="width:950px">
			<div class="boxNo btnpositionJsp" data-boxNo="">
				<a class="imgbtn" onClick="" style="margin-top: 15px;"><span>서명 템플릿 추가</span></a>
			</div>
		</div>
			
			
	</body>
</html>
