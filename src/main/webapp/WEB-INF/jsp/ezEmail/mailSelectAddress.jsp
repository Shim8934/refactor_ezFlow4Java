<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t554' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script>
	    	var returnFunction;
	    	var shareId = "${shareId}";
	    	
	        window.onload = function () {
	        	returnFunction = parent.address_selectAddress_dialogArguments[1];
	            
	        	$('.tab').bind('click', tabMouseClick)
		   			 .bind('mouseenter', tabMouseOver)
		   			 .bind('mouseleave', tabMouseOut);
	        	
	            getMailAddressList();
	        }
	        
	        /*
	         * get address list of the mail.
	         */
	        function getMailAddressList() {
	        	var requestUrl ="/ezEmail/getMailAddressList.do";
	        	
	        	if (typeof(shareId) != "undefined" && shareId != "") {
	        		requestUrl += "?shareId=" + encodeURIComponent(shareId);
				}
	        	
	        	$.ajax({
	        		type : "POST",
	   				dataType : "json",
	   				async : false,
	   				data : {url : "${url}"},
	   				url : requestUrl,
	   				success : function(result) {
	   					if (result.status != "ok") {
	   						alert("<spring:message code='ezEmail.lhm14' />");
	   						return;
	   					}
	   					
   						renderData(result.data);
	   				}
	   			});
	        }
	        
	        /*
	         * mouse click event handler of tab
	         */
	        function tabMouseClick() {
	        	if (!$(this).find('span').hasClass('tabon')) {
	        		$('.tabon').attr('class','');
	        		$(this).find('span').attr('class','tabon');
	        		
	        		changeTab($(this).attr('addressType'));
	        	}
	        }
	        
	        /*
	         * tab mouse over event handler of tab
	         */
	        function tabMouseOver() {
	        	if (!$(this).find('span').hasClass('tabon')) {
	        		$(this).find('span').attr('class','tabover');
	        	}
	        }
	        
	        /*
	         * tab mouse out event handler of tab
	         */
	        function tabMouseOut() {
	        	if (!$(this).find('span').hasClass('tabon')) {
	        		$(this).find('span').attr('class','');
	        	}
	        }
	        
	        /*
	         * render data.
	         */
	        function renderData(data) {
	        	var typeList = ["from", "to", "cc", "bcc"];
	        	
	        	var listTable, dataList, type;
	        	var addressInfo, row, checkboxColumn, checkboxWrapper, nameColumn, mailColumn, checkboxInput;
	        	
	        	for (var i = 0; i < typeList.length; i++) {
	        		type = typeList[i];
		        	dataList = data[type];
	        		listTable = document.getElementById(type + "List");
					
	        		if (dataList.length == 0) {
		        		$('#' + type + 'Tab').css('display', 'none');
		        	}
	        		
		        	for (var j = 0; j < dataList.length; j++) {
		        		addressInfo = dataList[j];
		        		
		        		row = document.createElement("tr");
		        		checkboxColumn = document.createElement("td");
		        		nameColumn = document.createElement("td");
		        		mailColumn = document.createElement("td");
		        		
		        		row.setAttribute("_name", addressInfo["name"]);
		        		row.setAttribute("_email", addressInfo["email"]);
		        		
                        checkboxWrapper = document.createElement("div");
                        checkboxWrapper.classList.add("custom_checkbox");
            
                        // input 생성 및 설정
		        		if (addressInfo["email"] != "${myEmail}") {
		        			checkboxInput = document.createElement("input");
		        			checkboxInput.type = "checkbox";
		        			checkboxInput.style.margin = "0px";
		        			checkboxInput.style.padding = "0px";
		        			checkboxInput.style.width = "13px";
		        			checkboxInput.style.height = "13px";
		        			checkboxWrapper.appendChild(checkboxInput);
		        		}

		        		checkboxColumn.appendChild(checkboxWrapper);
		        		
		        		nameColumn.textContent = addressInfo["name"];
		        		nameColumn.style.width = "40%";
		        		nameColumn.style.overflow = "hidden";
		        		nameColumn.style.textOverflow = "ellipsis";
		        		nameColumn.style.whiteSpace = "nowrap";
		        		
		        		mailColumn.textContent = addressInfo["email"];
		        		mailColumn.style.width = "60%";
		        		mailColumn.style.overflow = "hidden";
		        		mailColumn.style.textOverflow = "ellipsis";
		        		mailColumn.style.whiteSpace = "nowrap";
		        		
		        		row.appendChild(checkboxColumn);
		        		row.appendChild(nameColumn);
		        		row.appendChild(mailColumn);
		        		listTable.appendChild(row);
		        	}
	        	}
	        	
	        	$('#tabGroup p').first().click();
	        }
	        
	        /*
	         * change tab according to the type.
	         * type : from | to | cc | bcc
	         */
	        function changeTab(type) {
	        	$('#fromList').css('display', 'none');
	        	$('#toList').css('display', 'none');
	        	$('#ccList').css('display', 'none');
	        	$('#bccList').css('display', 'none');
	        	
	        	$('#' + type + 'List').css('display', '');
	        }
	        
	        /*
	         * mouse click event handler of header checkbox
	         * element : checkbox element
	         * type : from | to | cc | bcc
	         */
	        function allCheck(element, type) {
	        	if ($(element).prop("checked")) {
	        		$('#' + type + 'List').find('input:checkbox').not(':first').prop('checked', true);
	        	} else {
	        		$('#' + type + 'List').find('input:checkbox').not(':first').prop('checked', false);
	        	}
	        }
	        
	        function confirm() {
	        	var selectedAddressList = [];
	        	
	        	$('.mainlist').find('input:checkbox:checked').not('.allCheckbox').each(function() {
	        		selectedAddressList.push({
	        			name : $(this).closest('tr').attr('_name'),
	        			email : $(this).closest('tr').attr('_email')
	        		});
				});
	        	
	        	if (selectedAddressList.length == 0) {
	        		alert("<spring:message code='ezAddress.t4' />");
	        		return;
	        	}
	        	
	        	parent.address_selectAddress_dialogArguments[2] = selectedAddressList;
	        	returnFunction(true);
	        }
	        
			function cancel() {
				returnFunction(false);
	        }
	    </script>
	</head>
	<body style="overflow:hidden;" class="popup chk_lower_4">
        <h1><spring:message code='ezEmail.t554' /></h1>
        <div id="close">
			<ul>
				<li><span onClick="cancel()"></span></li>
			</ul>
		</div>
        <div class="portlet_tabpart01">
            <div class="portlet_tabpart01_top" id="tabGroup">
                <p id="fromTab" class="tab" addressType="from"><span><spring:message code='ezEmail.t161' /></span></p>
                <p id="toTab" class="tab" addressType="to"><span><spring:message code='ezEmail.t66' /></span></p>
                <p id="ccTab" class="tab" addressType="cc"><span><spring:message code='ezEmail.t706' /></span></p>
                <p id="bccTab" class="tab" addressType="bcc"><span><spring:message code='ezEmail.t562' /></span></p>
            </div>
        </div>
        <div style="border: 0; width: 100%; height: 360px; vertical-align: top; overflow: auto;">
	        <table style="display: none; width: 100%; border: 1px solid #ddd;" id="fromList" class="mainlist">
	            <tr>
	                <th style="width: 20px;">
	                    <div class="custom_checkbox">
	                        <input type="checkbox" class="allCheckbox" onClick="allCheck(this, 'from')" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
	                    </div>
	                <th style="width:40%;"><spring:message code='ezEmail.t31' /></th>
	                <th style="width:60%;"><spring:message code='ezEmail.t1019' /></th>
	            </tr>
	        </table>
	        <table style="display: none; width: 100%; border: 1px solid #ddd;" id="toList" class="mainlist">
	            <tr>
	                <th style="width: 20px;">
	                    <div class="custom_checkbox">
	                        <input type="checkbox" class="allCheckbox" onClick="allCheck(this, 'to')" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
                        </div>
	                <th style="width:40%;"><spring:message code='ezEmail.t31' /></th>
	                <th style="width:60%;"><spring:message code='ezEmail.t1019' /></th>
	            </tr>
	        </table>
	        <table style="display: none; width: 100%; border: 1px solid #ddd;" id="ccList" class="mainlist">
	            <tr>
	                <th style="width: 20px;">
                        <div class="custom_checkbox">
                            <input type="checkbox" class="allCheckbox" onClick="allCheck(this, 'cc')" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
	                    </div>
	                <th style="width:40%;"><spring:message code='ezEmail.t31' /></th>
	                <th style="width:60%;"><spring:message code='ezEmail.t1019' /></th>
	            </tr>
	        </table>
	        <table style="display: none; width: 100%; border: 1px solid #ddd;" id="bccList" class="mainlist">
	            <tr>
	                <th style="width: 20px;">
	                    <div class="custom_checkbox">
	                        <input type="checkbox" class="allCheckbox" onClick="allCheck(this, 'bcc')" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
                        </div>
	                <th style="width:40%;"><spring:message code='ezEmail.t31' /></th>
	                <th style="width:60%;"><spring:message code='ezEmail.t1019' /></th>
	            </tr>
	        </table>
        </div>
        <div class="btnposition btnpositionNew">
			<a class="imgbtn" onClick="confirm()"><span><spring:message code='ezEmail.t38' /></span></a>
		</div>
	</body>
</html>