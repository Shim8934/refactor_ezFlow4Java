<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${e1}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style> 
			P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm } 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/reademail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript">	
			var g_fromEmail = "${fromEmail}";
		    var IsAttach = "${pIsAttach}";
		    window.onresize = window_onresize;
		    
			function window_onload() {
			    window_onresize();
			    
			    form1.secureKey.value = "${secureKey}";
		        form1.securePassword.value = "${securePassword}";
		        form1.submit();
			}
			
			function window_onresize() {
		        if (document.getElementById('message').style.width != document.documentElement.clientWidth - 20) {
		            if (document.body.clientWidth - 20 > 0) {
		                document.getElementById('message').style.width = document.documentElement.clientWidth - 20;
		            }
		        }
		
		        if ("${pIsCCFg}"!="N") {
		            document.getElementById("message").style.height = document.documentElement.clientHeight - 200 + "px";
		        } else {
			        document.getElementById("message").style.height = document.documentElement.clientHeight - 170 + "px";
		        }
			}
			
			function OnBtnClose() {
				window.close();
			}	
			
		    function ShowHiddenTo(obj) {
		    	var currHeight = $(".content tbody tr:nth-child(2)").outerHeight();
		    	var heightForChange = "";
		    	
		        if (MsgToGotHidden.style.display=="none") {
		        	MsgToGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		            heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        } else {
		        	MsgToGotHidden.style.display = "none";
		            obj.src ="/images/expnd.gif";
		            heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		    }
		    
		    function ShowHiddenCc(obj) {
		    	var currHeight = $(".content tbody tr:nth-child(3)").outerHeight();
		    	var heightForChange = "";
		    	
		        if(MsgCCGotHidden.style.display=="none") {
		            MsgCCGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		            heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        } else {
		            MsgCCGotHidden.style.display = "none";    
		            obj.src ="/images/expnd.gif";
		            heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		    }
		</script>
	</head>

	<body id="parentBody" class="popup" onload="javascript:window_onload()"   style="overflow:hidden;"> 
		<form method="post">
		<table id="normalScreen" class="layout"> 
		    <tr> 
		        <td height="20">
		        	<div id="menu"></div>
		            <div id="close" style="display: none;"><ul><li><span onClick="OnBtnClose()">${t63}</span></li></ul></div>	
		        </td> 
		    </tr>  
		    <tr> 
		        <td>
		            <table class="content">
		                <tr>
		                    <th>${t161}</th>
		                    <td class="pos1" style="vertical-align:middle;">
		                        <div id="MsgToPut" title="${fromEmail}" style="padding-left: 5px; vertical-align: middle;">	
		                            <span id="LabelFromName">${fromStr}</span>
		                            <span id="LabelSenderInfo"></span>	
		                        </div>
		                    </td>
		                    <th>${t704}</th>
		                    <td style="border-right:0px;">
		                        <div id="ReceiveDate" style="OVERFLOW-Y: auto;padding-top:2px;padding-left:5px;padding-right:5px; width:200px;"> 
		                        <span id="LabelReceiveDate">${dateStr}</span> 
		                        </div>
		                    </td>
		                </tr>
		                <tr>
		                    <th>${t66}</th>
		                    <td style="OVERFLOW-Y:auto;">
			                    <div id="MsgToGot" style="padding-left:5px;"> 
			                    	<span id="LabelTo">${toStr}</span> 
			                    </div> 
			                    <div id="MsgToGotHidden" style="margin-bottom:5px;display:none;padding-left:8px;padding-left:5px;"> 
			                    	<span id="LabelToHidden">${toHiddenStr}</span> 
			                    </div>
		                    </td>
		                    <th>${lhm65}</th>
		                    <td>
		                    	<div style="padding-left:5px;">${readCountStr}</div>
		                    </td>
		                </tr>
		        
						<c:if test="${pIsCCFg != 'N'}">
			                <tr>
				                <th>${t555}</th>
				                <td style="OVERFLOW-Y:auto;height:100%;">
				                	<div id="MsgCCGot" style="padding-left:5px;"> 
				                		<span id="LabelCC">${ccStr}</span> 
					                </div>
					                <div id="MsgCCGotHidden" style="margin-bottom:5px;display:none;padding-left:5px;"> 
					                	<span id="LabelCCHidden">${ccHiddenStr}</span> 
					                </div>
				                </td>
				                <th>${lhm66}</th>
			                    <td>
		                    		<div style="padding-left:5px;">${readDateStr}</div>
		                    	</td>
			                </tr>
			                
			                <tr>
				                <th>${t556}</th>
			                	<td colspan="3">
			                		<div id="mailSubject" style="OVERFLOW-Y: auto;padding-left:5px;"> 
			                			<span id="LabelSubject">${subject}</span>
			                		</div>
			                	</td>
			                </tr>
						</c:if>
		        		
		        		<c:if test="${pIsCCFg == 'N'}">
		                <tr>
			                <th>${t556}</th>
		                	<td>
		                		<div id="mailSubject" style="OVERFLOW-Y: auto;padding-left:5px;"> 
		                			<span id="LabelSubject">${subject}</span>
		                		</div>
		                	</td>
	                		<th>${lhm66}</th>
	                    	<td>
	                    		<div style="padding-left:5px;">${readDateStr}</div>
	                    	</td>
	                    		
		                </tr>
		                </c:if>
		            </table>
		        </td>
		    </tr>
		    <tr>
		        <td class="pad1">
		        <iframe  id="message" name="message" frameborder="0" style="width:100%;height:100%;BORDER:#ddd 1px solid; background:#fff;" ></iframe>
		        </td>
		    </tr>
		</table>
		<script type="text/javascript">
			if("${pIsCCFg}"!="N") {
				document.getElementById("message").style.height = document.documentElement.clientHeight - 200 + "px";
			} else {
		    	document.getElementById("message").style.height = document.documentElement.clientHeight - 170 + "px";
			}
		</script>
		</form>
		<form name="form1" action="/ezEmail/readSecureMailContent.do" method="post" target="message" >
			<input  type="hidden" id="secureKey"  name="secureKey" value="">
		    <input  type="hidden" id="securePassword"  name="securePassword" value="">
		</form>
	</body>
</html>
