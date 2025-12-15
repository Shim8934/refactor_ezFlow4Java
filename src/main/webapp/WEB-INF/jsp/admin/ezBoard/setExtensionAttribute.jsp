<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t999029" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
		<style type="text/css">
	    	.tpNmTxt {
	    		width: calc(100% - 60px);
	    	}
	    	
	    	.tpNmBtn {
	    		vertical-align: middle;
	    		width: 16px;
	    		height: 16px;
	    		cursor: pointer;
	    		margin-left: 4px;
	    	}
	    	<c:if test="${useJapanese != 'YES'}">.JPN { display: none; }</c:if>
			<c:if test="${useChinese != 'YES'}">.CHN { display: none; }</c:if>
			<c:if test="${useIndonesian != 'YES'}">.IDN { display: none; }</c:if>
			
			.ui-sortable-helper td{display: flex; align-items: center; box-sizing: border-box;}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	    <script type="text/javascript">
        var noAttrFlag = ["text", "cal", "textArea", "people", "", null];
		var editTr = window.opener.updateTr ? window.opener.updateTr[0] : window.opener.updateTr;
    	var langs = ["KOR"
			, "ENG"
			<c:if test="${useJapanese == 'YES'}"> , "JPN"</c:if>
			<c:if test="${useChinese == 'YES'}"> , "CHN"</c:if>
			<c:if test="${useIndonesian == 'YES'}"> , "IDN"</c:if>
			];
		
        $(document).ready(function(){
        	// 수정인 경우 미리 세팅
        	if (window.location.href.indexOf("edit") > -1) {
        		
        		var korName = editTr.querySelector('.KOR').innerText;
        		var engName = editTr.querySelector('.ENG').innerText;
        		var jpnName = editTr.querySelector('.JPN').innerText;
        		var chnName = editTr.querySelector('.CHN').innerText;
        		var idnName = editTr.querySelector('.IDN').innerText;
        		
        		var isMust = editTr.querySelector('.MUST').innerText;
        		var colType = editTr.querySelector('.TYPE').innerText;
        		var colValue = editTr.querySelector('.VALUE').innerText;
        		
        		var korInput = document.getElementById('KOR');
        		var engInput = document.getElementById('ENG');
        		var jpnInput = document.getElementById('JPN');
        		var chnInput = document.getElementById('CHN');
        		var idnInput = document.getElementById('IDN');
        		
        		var mustCheck = document.getElementById('must');
        		var colTypeSelect = document.getElementById('type');
        		
        		if (korInput) {
	        		korInput.value = korName ? korName : "";
        		}
        		
        		if (engInput) {
        			engInput.value = engName ? engName : "";
        		}
        		
        		if (jpnInput) {
        			jpnInput.value = jpnName ? jpnName : "";
        		}
        		
        		if (chnInput) {
        			chnInput.value = chnName ? chnName : "";
        		}
        		
        		if (idnInput) {
        			idnInput.value = idnName ? idnName : "";
        		}
        		
        		if (must && isMust == "Y") {
        			mustCheck.checked = true;
        		}
        		
        		if (colType) {
        			colTypeSelect.value = colType;
        			colTypeSelect.onchange();
        		}
        		
        		if (colValue) {
        			var valArr = colValue.split("|")
        			
        			for (var i = 0; i < valArr.length - 1; i++) {
        				addTypeNameRow();
        			}
        			
        			for (var i = 0; i < valArr.length; i++) {
        				document.querySelectorAll(".tpNmTxt")[i].value = valArr[i];
        			}
        		}
        		
        		
        	}
        	
        	// input 요소에 붙여넣기 시 탭, 줄바꿈, 캐리지 리턴 등의 문자 제거 (JSON Parse 과정에서 에러 유발함.)
        	window.addEventListener('DOMContentLoaded', function () {
	        	var inputs = document.querySelectorAll('input[type="text"]');
	        	
				for (var i = 0; i < inputs.length; i++) {
					
					inputs[i].addEventListener('paste', function (event) {
						var clipboardData = event.clipboardData || window.clipboardData;
						var pastedData = clipboardData.getData('text');
						
						pastedData = pastedData.replace(/[\t\n\r]/g, '');
						event.preventDefault();
						
						var start = this.selectionStart;
						var end = this.selectionEnd;
						var original = this.value;
						
						this.value = original.substring(0, start) + pastedData + original.substring(end);
						this.setSelectionRange(start + pastedData.length, start + pastedData.length);
					});
				}
			})
		});
        
		// 타입명을 입력하는 유형인지 확인하는 메소드
	    function checkExtColType(pValue) {
	        
	    	if (noAttrFlag.includes(pValue)) {
	            document.getElementById("typeNames").style.display = "none";
	        } else {
	            document.getElementById("typeNames").style.display = "";
	            
	            if (document.querySelectorAll(".tpNmTxt").length < 1) {
	            	// Drag&Drop 등록
					$("#typeNamesTable").sortable({
						items: ".nameRow",
						scroll: true,
						handle: ".tpNmBtnMove"
					});
	            	
	            	addTypeNameRow();
	            }
	        }
	    }
	    
	    // 타입명을 입력하는 행을 추가하는 메소드
	    function addTypeNameRow() {
	    	var newTr = document.createElement("tr");
			newTr.className = "nameRow";

			var newTd = document.createElement("td");
			
			var newInput = document.createElement("input");
			newInput.type = "text";
			newInput.className = "tpNmTxt";
			newInput.maxLength = "50";
			
			var newPlusBtn = document.createElement("img");
			newPlusBtn.className = "tpNmBtn tpNmBtnPlus";
			newPlusBtn.src = "/images/plusicon.png";
			newPlusBtn.addEventListener("click", addTypeNameRow);

			var imgMinusBtn = document.createElement("img");
			imgMinusBtn.className = "tpNmBtn tpNmBtnMinus";
			imgMinusBtn.src = "/images/minusicon.png";
			imgMinusBtn.addEventListener("click", removeTypeNameRow);

			var imgMoveBtn = document.createElement("img");
			imgMoveBtn.className = "tpNmBtn tpNmBtnMove";
			imgMoveBtn.src = "/images/ezSurvey/move.png";
			imgMoveBtn.setAttribute("draggable", "false");
			imgMoveBtn.style.cursor = "move";
			
			newTd.appendChild(newInput);
			newTd.appendChild(newPlusBtn);
			newTd.appendChild(imgMinusBtn);
			newTd.appendChild(imgMoveBtn);

			newTr.appendChild(newTd);

			document.getElementById("typeNamesTable").appendChild(newTr);
			
			$("#typeNamesTable").sortable("refresh");
	    }

	    // 현재의 타입명을 입력하는 행을 제거하는 메소드
		function removeTypeNameRow(target) {
			if (document.getElementById("typeNamesTable").rows.length > 1) {
				target.currentTarget.closest('tr').remove();
			} else {
				alert("<spring:message code='ezPoll.t148'/>");
			}
		}
	    
	    // 실제 DB에 저장되진 않고, 프론트에서의 데이터 검증 진행 후 부모 팝업인 확장컬럼 설정으로 데이터 반환.
	    function btnOK_onclick() {
	    	var names = [].slice.call(document.getElementsByClassName("extAttrNm"));
	    	
	    	var filtered = names.filter(function(name){
	    		for (var i = 0; i < langs.length; i++) {
	    			if (name.id === langs[i]) {
	    				return true;
	    			}
	    		}
	    		return false;
	    	});
	    	
	    	for (var i = 0; i < filtered.length; i++) {
	    		if (filtered[i].value.trim().length < 1) {
		    		alert("<spring:message code='ezBoard.hsbEx02'/>");
		    		filtered[i].focus();
		    		filtered[i].select();
	    			return;
	    		}
	    	}
	    	
	    	if (checkDuplicateTypeNames()) {
	    		alert("<spring:message code='ezBoard.t999057'/>");
    			return;
	    	}
	    	
   			var extColType = document.getElementById("type").value;
	    	var strTypeNames = "";
	    	
	    	if (!noAttrFlag.includes(extColType)) {
	    		
	    		var strTypeNmArr = document.querySelectorAll(".tpNmTxt");
	    		var values = [];
	    		
	    		for (var i = 0; i < strTypeNmArr.length; i++) {
	    		    var val = strTypeNmArr[i].value.trim();
	    		    if (val != "") {
	    		    	values.push(val);
	    		    }
	    		}
	    		
	    		strTypeNames = values.join("|");
	    		
	    		if (strTypeNames.length < 1) {
	    			alert("<spring:message code='ezPoll.t148'/>");
	    			return false;
	    		}
	    		
	    		if (MakeXMLString(strTypeNames).length > 510) {
	    			alert("<spring:message code='ezBoard.extAttrNmSizeOver'/>");
	    			return false;
	    		}
	    	}
	    	
	    	var column = {
	    		txtNameKor: document.getElementById("KOR").value,
	    		txtNameEng: document.getElementById("ENG").value,
	    		txtNameJpn: document.getElementById("JPN") ? document.getElementById("JPN").value : document.getElementById("ENG").value,
	    		txtNameChn: document.getElementById("CHN") ? document.getElementById("CHN").value : document.getElementById("ENG").value,
	    		txtNameIdn: document.getElementById("IDN") ? document.getElementById("IDN").value : document.getElementById("ENG").value,
	    		must: document.getElementById("must").checked,
	    		colType: document.getElementById("type").value,
	    		value: strTypeNames
	    	};
	    	
			// url로 추가/수정 구분하기
			if (window.location.href.indexOf("edit") > -1) {
				window.opener.receivedEditExtCol(column);
			} else {
				window.opener.receivedNewExtCol(column);
			}
			
			window.close();
	    }
	    
	    // 사용하는 언어별로 항목명 중복 검증 메소드
    	// 한 언어의 열에 대해서라도 중복이 있다면 return true;
	    function checkDuplicateTypeNames() {
			var rows = [].slice.call(window.opener.document.querySelectorAll("#lvSelectList tbody tr"));
			rows = rows.filter(function(row) {
				return row !== editTr;
			});
			
			if (rows.length < 1) {
				return false;
			}
			
	    	var chkVals = {};
    		var langInputs = document.getElementsByClassName("extAttrNm");
			
	    	for (var i = 0; i < langs.length; i++) {
				var input = document.querySelector('input.extAttrNm#' + langs[i]);
				chkVals[langs[i]] = input ? input.value.trim() : "";
			}
	    	
        	for (var i = 0; i < rows.length; i++) {
        		for (var j = 0; j < langs.length; j++) {
        			var td = rows[i].querySelector("." + langs[j]);
        			var tdTxt = td ? td.textContent.trim() : "";
        			
        			if (chkVals[langs[j]] && chkVals[langs[j]] == tdTxt) {
        				document.querySelector('input.extAttrNm#' + langs[j]).focus();
        				document.querySelector('input.extAttrNm#' + langs[j]).select();
        				return true;
        			}
        		}
        	}
	    	
			return false;
	    }
		
	    </script>
	    
	</head>
	<body class="popup" style="overflow-x:hidden;">
		<h1><spring:message code='ezBoard.t999029'/></h1>
		<div id="close">
            <ul>
                <li><span id="btncancel" onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
		<div>
			<table class="content">
				<tr class="KOR">
					<th><spring:message code="ezBoard.extAttrNm" arguments="${lang_primary }" /></th>
					<td>
						<input id="KOR" class="extAttrNm" style="width:100%" maxlength="20"/>
					</td>
				</tr>
				<tr class="ENG">
					<th><spring:message code="ezBoard.extAttrNm" arguments="${lang_secondary }" /></th>
					<td>
						<input id="ENG"  class="extAttrNm" style="width:100%" maxlength="20"/>
					</td>
				</tr>
				<tr class="JPN">
					<th><spring:message code="ezBoard.extAttrNm" arguments="${lang_tertiary }" /></th>
					<td>
						<input id="JPN" class="extAttrNm" style="width:100%" maxlength="20"/>
					</td>
				</tr>
				<tr class="CHN">
					<th><spring:message code="ezBoard.extAttrNm" arguments="${lang_quaternary }" /></th>
					<td>
						<input id="CHN"  class="extAttrNm" style="width:100%" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code="ezBoard.extAttrNm" arguments="${lang_Senary }" /></th>
					<td class="IDN">
						<input id="IDN"  class="extAttrNm" style="width:100%" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<th><spring:message code="ezBoard.t999033" /></th>
					<td>
						<div class="custom_checkbox">
							<input type="checkbox" id="must" style="vertical-align: -6px;">
						</div>
					</td>
				</tr>
				<tr>
					<th><spring:message code="ezBoard.t999038" /></th>
					<td>
						<select id="type" onchange="checkExtColType(this.value)" style="width:99%">
<%-- 						<option value=""><spring:message code='ezBoard.t74'/></option> --%>
						<option value="text"><spring:message code='ezBoard.hyj06'/></option>
						<option value="radio"><spring:message code='ezBoard.hyj07'/></option>
						<option value="check"><spring:message code='ezBoard.hyj08'/></option>
						<option value="cal"><spring:message code='ezBoard.MJSBC01'/></option>
						<option value="select"><spring:message code='ezBoard.MJSBC02'/></option>
						<option value="people"><spring:message code='ezBoard.extensionAttr.JIH01'/></option>
						<option value="textArea"><spring:message code='ezBoard.extensionAttr.JIH02'/></option>
					</select>
					</td>
				</tr>
				<tr id="typeNames" style="display: none;">
					<th><spring:message code="ezBoard.t999039" /></th>
					<td style="padding:0px;">
						<div style="overflow-y: auto; height: 150px;">
							<table style="width: 100%">
								<tbody id="typeNamesTable">
								</tbody>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick ="return btnOK_onclick()" id="btnOK"><span><spring:message code='ezBoard.t98'/></span></a>
		</div>
	</body>
</html>