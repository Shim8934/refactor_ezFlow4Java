<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_filter</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript">
			var mailAddressSearchOrder = "${mailAddressSearchOrder}";
			var mailAddressCount = "";
			
			document.onselectstart = function() {
				return false;
			};
			$(document).ready(function() { 
				if (navigator.userAgent.indexOf('Firefox') != -1) {
					document.body.style.MozUserSelect = 'none';
					document.body.style.WebkitUserSelect = 'none';
					document.body.style.khtmlUserSelect = 'none';
					document.body.style.oUserSelect = 'none';
					document.body.style.UserSelect = 'none';
				}
				makeAddressList();
			});
    
			function makeAddressList() {
				var _html = "";
				try {
					_html = "<table class='mainlist' style='width:100%;' id='contentTable'>";
					var mailAddressSearchOrderSplit = mailAddressSearchOrder.split(";");
			    	
			    	for (var i = 0; i < mailAddressSearchOrderSplit.length; i++) {
			    		_html += "<tr id='" + mailAddressSearchOrderSplit[i] + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);'>";
			    		_html += "<td style='width:100%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + setAddressName(mailAddressSearchOrderSplit[i]) + "</td></tr>";
			    	}
			    	_html += "</table>";
			    	document.getElementById("contentlist").innerHTML = _html;
			    	mailAddressCount = mailAddressSearchOrderSplit.length;
				} catch (e) {
		            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang202 + "</td></tr></table>";
		            mailAddressCount = 0;
				}
			}
			
			function event_Mover(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
		        }
		    }
			
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    
		    var _RowObject = null;
		    function event_click(obj) {
		        if (_RowObject != null) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		        }
		            
		        _RowObject = obj;
		        
		        $('#contentTable tr').each(function(){
		    		$(this).removeClass();
		    	});
		        
		        obj.setAttribute('class', 'currentObj');
		        obj.childNodes.item(0).style.backgroundColor = "#edf4fd";
		    }
		    
		    function priority_UpDown(selector) {
		    	if (_RowObject == null) {
	                alert(strLang214);
	                return;
	            }
		    	var $tr = _RowObject;
		    	
		    	if (selector == "UP") {
		    		if($tr.rowIndex == 0) {
		    			return;
		    		} else {
		    			$('.currentObj').prev().before($tr);
		    			setMailAddressSearchOrder();
		    		}
		    	} else {
		    		if($tr.rowIndex == mailAddressCount) {
		    			return;
		    		} else {
		    			$('.currentObj').next().after($tr);
		    			setMailAddressSearchOrder();
		    		}
		    	}
		    	setMailAddressSearchOrder();
		    }
		    
		    function setMailAddressSearchOrder() {
		    	var mailAddressSearchOrder = "";
		    	$('#contentTable tr').each(function(){
		    		mailAddressSearchOrder += $(this).attr('id') + ";"
		    	});
		    	mailAddressSearchOrder = mailAddressSearchOrder.substr(0, mailAddressSearchOrder.length-1);
		    	$.ajax({
					type : 'post',
					url : "/ezEmail/setMailAddressSearchOrder.do",
					dataType : "json",
					data : {
						mailAddressSearchOrder : mailAddressSearchOrder
					},
					success : function(result) {
						
					}
				});
		    }
		    
		    function setAddressName(name) {
		    	var rtnName = "";
		    	
		    	if (name == "organ") {
		    		rtnName = "<spring:message code='ezEmail.t591' />";
		    	} else if (name == "address") {
		    		rtnName = "<spring:message code='ezEmail.t592' />";
		    	} else if (name == "dl") {
		    		rtnName = "<spring:message code='ezEmail.t593' />";
		    	} else if (name == "shared") {
		    		rtnName = "<spring:message code='ezEmail.sharedMailbox02' />";
		    	}
		    	
		    	return rtnName;
		    }

		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;"> 
		<form method="post"> 
			<br>
		    <span class="txt">▒&nbsp; <spring:message code='ezEmail.t99000086' /></span><br />
			<span class="txt">▒ <img src="/images/ImgIcon/prev.gif" height="16" style="margin-top:-3px;vertical-align:middle;text-align:center;" alt="<spring:message code='ezEmail.t833' />"/><img src="/images/ImgIcon/next.gif" height="16" style="margin-top:-3px;vertical-align:middle;text-align:center;" alt="<spring:message code='ezEmail.t834' />" /><spring:message code='ezEmail.t99000085' /></span><br /><br /><br />
		    <div id="mainmenu">
		        <ul id="tb_Parent">
		          <li class="prevLi"><span onclick="priority_UpDown('UP')"><img src="/images/ImgIcon/prev.gif"  style="margin-top:-2px;" alt="<spring:message code='ezEmail.t833' />"/></span></li>
		          <li class="prevLi"><span onclick="priority_UpDown('DOWN')"><img src="/images/ImgIcon/next.gif"  style="margin-top:-2px;" alt="<spring:message code='ezEmail.t834' />" /></span></li>
		          </ul>        
			</div>
			<table style="width:750px;height:385px;" border="0">
				<tr>
					<td>
						<div style="border:1px solid #dbdbda;width:435px;height:397px;">
							<table class="mainlist" style="width:100%;">
			                    <tr>
			                        <td style="width:100%;background-color:#f8f8f8;border-right:1px solid #dbdbda;border-bottom:2px solid #dbdbda;cursor:pointer"><span><spring:message code='ezEmail.t99000083' /></span></td>
			                    </tr>
							</table>
							<div id="contentlist" name="contentlist" style="height:365px;overflow-y:auto;">
							</div>
						</div>
					</td>
				</tr>
			</table>
		</form> 
	</body>
</html>

