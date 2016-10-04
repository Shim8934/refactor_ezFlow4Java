<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e3' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var CurPage = "<c:out value='${pPage}'/>";
			var totalPage = "<c:out value='${totalPage}'/>";
			var strListInfo = "";
			var CheckBoxArr = new Array();
	    	
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
				}
			};
	        
			function prevPage_onclick()	{
				newPage = parseInt(CurPage) - 1;
				if (newPage > 0) {
					window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + newPage.toString();
				}
			}

			function nextPage_onclick()	{
				newPage = parseInt(CurPage) + 1;
				if (newPage <= parseInt(totalPage)) {
					window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + newPage.toString();
				}
			}
			
			function moveToPage() {
				if (window.event.keyCode == 13) {
					var newPage = txt_PageInputNum.value;	
					if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
						window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + parseInt(newPage);
					}
				}
			}
	       
			function Delete_onclick() {
			    funCheckBox('get');
			    
			    if (CheckBoxArr.length == 0) {
			        alert("<spring:message code='ezOrgan.t28'/>"); 
			        return;
			    }			    
		        var ret = confirm(CheckBoxArr.length + strLang5);
		        
			    if (ret) {
			        var data = "";
			        for (var i = 0; i < CheckBoxArr.length; i++) {
		            	data += CheckBoxArr[i];
		            	
		            	if(i != CheckBoxArr.length-1){
		            		data = data + ",";
		            	}		                
		            }

			        $.ajax({
		            	type : "POST",
		            	dataType : "html",
		            	url : "/admin/ezOrgan/delUser.do",
		            	async : false,
		            	data : {cn : data},
		            	success : function(result){
		            		alert(CheckBoxArr.length + "<spring:message code='ezOrgan.t31' />");
		            	},
		            	error : function(){
		            		alert("<spring:message code='ezOrgan.t30' />");
		            	}
		            });
					
				    refresh_onclick();
			    }
			}
			
			function funCheckBox(mode) {
			    CheckBoxArr = new Array();
			    
			    if (mode == 'get') {
			        for (var i = 0 ; i < document.getElementsByName("chk").length ; i++) {
			            if (document.getElementsByName("chk").item(i).checked == true) {
			                CheckBoxArr[CheckBoxArr.length] = document.getElementsByName("chk").item(i).value;
			            }
			        }
			    }
			    if (mode == 'set') {
			        for (var i = 0 ; i < document.getElementsByName("chk").length ; i++) {
			            if (document.getElementsByName('checkbox').item(0).checked == true) {
			                document.getElementsByName("chk").item(i).checked = true;
			            } else {
			                document.getElementsByName("chk").item(i).checked = false;
			            }
			        }
			    }
			}
			
			//2016-05-04일 까지 구현
			var selectdept_cross_dialogArguments = new Array();
			function Restore_onclick() {
			    funCheckBox('get');
			    
			    if (CheckBoxArr.length == 0) {
			        alert(strLang6); 
			        return;
			    }
			    var ret = confirm(CheckBoxArr.length + strLang7);
			    
				if (ret) {
				    //if (CrossYN()) {
			        selectdept_cross_dialogArguments[0] = strLang8;
			        selectdept_cross_dialogArguments[1] = Restore_onclick_Complete;
			        var OpenWin = window.open("/admin/ezOrgan/selectDept.do", "SelectDept_Cross", GetOpenWindowfeature(302, 390));
			        try { OpenWin.focus(); } catch (e) { }
				    /* } else {
				        var rtnValue = '';
				        rtnValue = window.showModalDialog("/admin/ezOrgan/selectDept.do", strLang8, "dialogHeight:390px; dialogWidth:302px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(302, 390));

				        if (typeof (rtnValue) != "undefined") {
				            var xmlHTTP = createXMLHttpRequest();
				            var xmlDom = createXmlDom();

				            var objNode;
				            createNodeInsert(xmlDom, objNode, "DATA");
				            createNodeAndInsertText(xmlDom, objNode, "DEPTID", rtnValue);
				            
				            for (var i = 0 ; i < CheckBoxArr.length ; i++) {
				                createNodeAndInsertText(xmlDom, objNode, "CN", CheckBoxArr[i]);
				            }
				            xmlHTTP.open("POST", "Restore_RetireUser.aspx", false);
				            xmlHTTP.send(xmlDom);

				            if (xmlHTTP.status != 200 || SelectSingleNodeValueNew(xmlHTTP.responseXML, "DATA") != "OK") {
				                alert(strLang10);
				            } else {
				                alert(strLang9);
				            }
				            refresh_onclick();
				        }
				    } */
				}
			}
			
			function Restore_onclick_Complete(rtnValue) {
			    if (typeof (rtnValue) != "undefined") {
			    	var data = "";
			    	
			        for (var i = 0 ; i < CheckBoxArr.length ; i++) {
			        	data += CheckBoxArr[i];
			        	
			        	if (i != CheckBoxArr.length-1) {
			        		data += ",";
			        	}
			        }

			        $.ajax({
			        	type : "POST",
			        	dataType : "xml",
			        	url : "/admin/ezOrgan/restoreRetireUser.do",
			        	async : false,
			        	data : {deptID : rtnValue, cn : data},
			        	success : function(result){
			        		alert(strLang9);
			        	},
			        	error : function(){
			        		alert(strLang10);	
			        	}
			        });

			        refresh_onclick();
			    }
			}
			
			function refresh_onclick() {
				window.location.reload(false);
			}
			
			function ShowUserInfo(UserID) {
			    window.open("/admin/ezOrgan/retireUserInfo.do?id=" + UserID, "", "height=800px,width=530px,status=no,toolbar=no,menubar=no,location=no,resizable=0"+GetOpenPosition(530, 800));
			}
	    </script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezOrgan.t311'/></h1>
		<div id="mainmenu">
			<ul>
		    	<li><span onClick="Restore_onclick()"><spring:message code='ezOrgan.t312'/></span></li>
		        <li><span onClick="Delete_onclick()"><spring:message code='ezOrgan.t142'/></span></li>
		  	</ul>
		</div>
		<div class="page">
			<img src="/images/page_previous.gif" width="15" height="16" align="absmiddle" id=td_Previous onClick="prevPage_onclick()"/> <spring:message code='ezOrgan.t314'/>: <c:out value='${totalPage}'/>&nbsp;&nbsp; -
		  	<input name="txt_PageInputNum" type="text" value="<c:out value='${pPage}'/>" onKeyDown="moveToPage()"/>
		  	<img src="/images/page_next.gif" width="15" height="16" align="absmiddle" id="Img1" style="cursor:pointer;" onClick="nextPage_onclick()"/>
		</div>
		<table class="mainlist" style="width:100%">
			<form name="frmOutbox" action="BoardItemList.aspx" method="post">
		    	<tr>
		      		<th style="padding:0;width:20px;"><input type='checkbox' name="checkbox" onclick="funCheckBox('set','a')" /></th>
		      		<th style="width:150px;"><spring:message code='ezOrgan.t68'/></th>
		      		<th style="width:100px;"><spring:message code='ezOrgan.t67'/></th>
		      		<th style="width:100px;"><spring:message code='ezOrgan.t69'/></th>
		      		<th style="width:100px;"><spring:message code='ezOrgan.t1500'/></th>
		      		<th><spring:message code='ezOrgan.t313'/></th>
		   		</tr>
			   	<!-- list -->
				<c:forEach var="item" items="${list}">
					<tr>
						<td width="20" style="padding:0">
							<input type="checkbox" name="chk" id="chk" value="<c:out value='${item.cn}'/>" />
						</td>
						<c:if test="${lang == '' || lang == 1}">
							<td><c:out value='${item.description}'/></td>
							<td style="cursor:pointer" onclick="ShowUserInfo('<c:out value='${item.cn}'/>')"><c:out value='${item.displayName}'/></td>
							<td><c:out value='${item.title}'/></td>
							<td><c:out value='${item.extensionAttribute10}'/></td>
						</c:if>
						<c:if test="${lang != '' && lang != 1}">
							<td><c:out value='${item.description2}'/></td>
							<td style="cursor:pointer" onclick="ShowUserInfo('<c:out value='${item.cn}'/>')"><c:out value='${item.displayName2}'/></td>
							<td><c:out value='${item.title2}'/></td>
							<td><c:out value='${item.extensionAttribute102}'/></td>
						</c:if>
						<td><c:out value='${item.updateDT}'/></td>
					</tr>	
				</c:forEach>	   
			</form>
		</table>		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>