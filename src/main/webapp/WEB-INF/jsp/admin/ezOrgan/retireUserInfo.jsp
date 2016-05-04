<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezOrgan.t309' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
	    	var OrgUserID = "<c:out value='${userID}'/>";
	    	
	    	$(document).ready(function(){
	    		$.ajax({
	    			type : "POST",
	    			dataType : "json",
	    			url : "/admin/ezOrgan/getRetireEntryInfo.do",
	    			async : false,
	    			data : {cn : OrgUserID},
	    			success: function(result){
	    				var info = result["info"];

	    				UserID.innerText = ifNull(OrgUserID);
	    				UserName.innerText = ifNull(info.displayName1);
	    				UserName2.innerText = ifNull(info.displayName2);
	    				JobTitle.innerText = ifNull(info.title1);
	    				JobTitle2.innerText = ifNull(info.title2);
	    				SortNum.innerText = ifNull(info.extensionAttribute15);
	    				PhoneNumber.innerText = ifNull(info.telephoneNumber);	    				
	    				HomePhone.innerText = ifNull(info.homePhone);
	    				FaxNum.innerText = ifNull(info.facsimileTelephoneNumber);
	    				Mobile.innerText = ifNull(info.mobile);
	    				MailAlias.innerText = ifNull(info.mail);
	    				JobPosition.innerText = ifNull(info.extensionAttribute101);
	    				JobPosition2.innerText = ifNull(info.extensionAttribute102);
	    				DeptName.innerText = ifNull(info.description1);
	    				DeptName2.innerText = ifNull(info.description2);
	    				SocialNum.innerText = ifNull(info.extensionAttribute14);
	    			 
	    				var AclList = ifNull(info.extensionAttribute1);
	    				SecurityLevel.value = ifNull(info.extensionAttribute6);
	    				
	    				for (var i = 1; i < 12; i++) {	    				
	    					try {
	    						if (AclList.indexOf(eval("Check" + i).value + "=1") > -1) {
	    							eval("Check" + i).checked = true;
	    						}
	    				  	} catch(e) {}
	    				}
	    				
	    				if (ifNull(info.extensionAttribute2) != "") {	    					
	    					document.getElementById("UserPhotoDiv").innerHTML = "<IMG style='width:119px; height:128px;' SRC='/admin/ezOrgan/getPersonalInfo.do?fileName=" + ifNull(info.extensionAttribute2) + "'>";
	    				}
					}
	    		});
	    	});
	    				
	    	function ifNull(obj){
	    		if(obj == null){
	    			return "";
	    		}else{
	    			return obj;
	    		}
	    	}			
	    	
	    	function window_close() {
	    	    window.close();
	    	}
	    </script>
	</head>
	<body class="popup">		
		<h1 id="subtitle"><spring:message code='ezOrgan.t309'/></h1>
		<div id="close">
        	<ul>
            	<li>
              		<span onClick="window_close()"><spring:message code='ezOrgan.t143'/></span>              
            	</li>
          	</ul>
		</div>
		<h2><spring:message code='ezOrgan.t274'/></h2>		
		<table class="content">
			<tr>
		        <td rowspan="3" align="center" nowrap ID="UserPhotoDiv" style="width:160px"><b><spring:message code='ezOrgan.t272'/></b> </td>
		        <th style="width:60px"><spring:message code='ezOrgan.t275'/></th>
		        <td style="width:100%"><span id="UserID" style="ime-mode:disabled; width:100%"></span></td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezOrgan.t276'/></th>
		        <td style=" padding:0">
		            <table width="100%">
		                <tr class="primary">
		                    <th><c:out value='${primary}'/></th>
		                    <td><span id="UserName" style="width:100%"></span></td>
		                </tr>
		                <tr class="secondary">
		                    <th><c:out value='${secondary}'/></th>
		                    <td><span  id="UserName2" style="width:100%"></span></td>
		                </tr>
		            </table>
		        </td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezOrgan.t278'/></th>
		        <td style="padding:0">
		            <table width="100%">
		            	<tr class="primary">
		                    <th><c:out value='${primary}'/></th>
		                    <td><span name="Input3" id="DeptName" style="width:100%"></span></td>
		                </tr>
		                <tr class="secondary">
		                    <th><c:out value='${secondary}'/></th>
		                    <td><span id="DeptName2" style="width:100%"></span></td>
		                </tr>
		            </table>
		        </td>
		    </tr>
		    <tr>
		    	<th rowspan="2"><div>img size</div><div style="margin-top:3px;">(w:119 h:128)</div></th>		    	
		        <th><spring:message code='ezOrgan.t279'/></th>
		        <td style="padding:0">
		            <table width="100%">
		                <tr class="primary">
		                    <th><c:out value='${primary}'/></th>
		                    <td><span id="JobTitle" name="txtUserJobTitle" style="width:100%" ></span></td>
		                </tr>
		                <tr class="secondary">
		                    <th><c:out value='${secondary}'/></th>
		                    <td><span id="JobTitle2" style="width:100%"></span></td>
		                </tr>
		            </table>
		        </td>
		    </tr>
		    <tr>		    		    	
		        <th><spring:message code='ezOrgan.t280'/></th>
		        <td style="padding:0">
		            <table width="100%">
		                <tr class="primary">
		                    <th><c:out value='${primary}'/></th>
		                    <td><span name="Input2" id="JobPosition" style="width:100%" ></span></td>
		                </tr>
		                <tr class="secondary">
		                    <th><c:out value='${secondary}'/></th>
		                    <td><span id="JobPosition2" style="width:100%"></span></td>
		                </tr>
		            </table>
		        </td>
		    </tr>		   
		    <tr>
		        <th><spring:message code='ezOrgan.t283'/></th>
		        <td colspan=2><span id="SocialNum" style="width:100%" ></span></td>
		    </tr>
			<tr>
		    	<th><spring:message code='ezOrgan.t284'/></th>
		    	<td colspan=2><span id="SecurityLevel" style="width:100%" ></span></td>
		  	</tr>
			<tr>
		    	<th><spring:message code='ezOrgan.t226'/></th>
		    	<td colspan=2><span id="SortNum" style="width:100%" maxlength="15"></span></td>
		  	</tr>
		</table><br/>		
		<h2><spring:message code='ezOrgan.t285'/></h2>
		<table class="content">
			<tr>
		    	<th><spring:message code='ezOrgan.t95'/></th>
		    	<td style="width:50%" ><span id="PhoneNumber" style="width:150px" ></span></td>
		    	<th><spring:message code='ezOrgan.t97'/></th>
		    	<td width="100%"><span id="HomePhone" style="width:100%" ></span></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code='ezOrgan.t98'/></th>
		    	<td style="width:150px" ><span id="FaxNum" style="width:150px" ></span></td>
		    	<th><spring:message code='ezOrgan.t96'/></th>
		    	<td><span id="Mobile" style="width:100%" ></span></td>
		  	</tr>
		  	<tr style="display:none">
		    	<th><spring:message code='ezOrgan.t286'/></th>
		    	<td colspan="3">
		    		<input id="ZipCode" style="WIDTH: 100px;" maxlength="6" readonly />
		      		<a href="#" class="imgbtn"><span onClick="GetPostCode()"><spring:message code='ezOrgan.t286'/></span></a>
		      	</td>
		 	</tr>
		  	<tr style="display:none">
				<th><spring:message code='ezOrgan.t287'/></th>
		    	<td colspan="3"><input id="HomeAddr" style="WIDTH: 100%;" /></td>
		  	</tr>
		  	<tr>
		    	<th id="mailtitle"><spring:message code='ezOrgan.t288'/></th>
		    	<td colspan="3"><span id="MailAlias" style="WIDTH:100%"></span></td>
		  	</tr> 
		</table><br/>		
		<h2><spring:message code='ezOrgan.t290'/></h2>
		<table class="content">
			<tr>
		    	<th><spring:message code='ezOrgan.t291'/></th>
		    	<td nowrap style="padding-right:70px"><input type="checkbox" value="c" id="Check1" disabled=true /></td>
		    	<th><spring:message code='ezOrgan.t292'/></th>
		    	<td style="padding-right:90px" ><input type="checkbox" value="a" id="Check2" disabled=true /></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code='ezOrgan.t293'/></th>
		    	<td><input type="checkbox" value="k" id="Check3" disabled=true /></td>
		    	<th><spring:message code='ezOrgan.t294'/></th>
		    	<td><input type="checkbox" value="i" id="Check4" disabled=true /></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code='ezOrgan.t295'/></th>
		    	<td><input type="checkbox" value="g" id="Check5" disabled=true /></td>
		    	<th><spring:message code='ezOrgan.t296'/></th>
		    	<td><input type="checkbox" value="l" id="Check6" disabled=true /></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code='ezOrgan.t297'/></th>
		    	<td><input type="checkbox" value="n" id="Check7" disabled=true /></td>
		    	<th><spring:message code='ezOrgan.t299'/></th>
		    	<td><input type="checkbox" value="t" id="Check10" disabled=true /></td>
		  	</tr>
		  	<tr>
		    	<th><spring:message code='ezOrgan.t300'/></th>
		    	<td><input type="checkbox" value="m" id="Check8" disabled=true /></td>
		    	<th><spring:message code='ezOrgan.t301'/></th>
		    	<td><input type="checkbox" value="w" id="Check9" disabled=true /></td>
		  	</tr>
		   	<tr style="display:none">
		    	<th><spring:message code='ezOrgan.t304'/></th>
		    	<td><input type="checkbox" value="h" id="Check11" /></td>
		    	<th style="display:none"><spring:message code='ezOrgan.t299'/></th>
		    	<td style="display:none"><input type="checkbox" value="x" id="Check12" /></td>
		  	</tr>
		</table>
	</body>
</html>