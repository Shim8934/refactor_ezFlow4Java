<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.jjh03" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />	    
	    <style type="text/css">
			.warningbox{margin:240px auto 0px auto; padding:40px 20px 0px 20px; font-family:Meiryo UI; width:625px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box;}
			.warningbox .warningimg{margin:0px; padding:3px 0px 0px 40px; float:left;}
			.warningbox .warningDL{margin:0px; padding:0px 0px 0px 30px; overflow:hidden;}
			.warningbox .warningDL dt{margin:0px; padding:0px 0px 5px 0px; font-size:24px; font-weight:bold; color:#3d8fea; letter-spacing:-1px;}
			.warningbox .warningDL dd{margin:0px; padding:0px; font-size:20px; color:#333; letter-spacing:-1px;}
			.warningbox .warningDL dd span{ font-size:20px; font-weight:bold;}
		</style>
			
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
		<script type="text/javascript" language="javascript">
			var SelectedBoardID = "<c:out value='${boardID}'/>";
	    	var BoardGroupID = "<c:out value='${boardGroupID}'/>";
	    	
	    	function Delete(){
	    		var ret = confirm("<spring:message code='ezBoard.t112'/>");
	    		
	    		if(ret) {	    			
	    			$.ajax({
	    				type : "POST",
	    				dataType : "text",
	    				url : "/admin/ezBoard/deleteBoard.do",
	    				data : { boardID : SelectedBoardID },
	    				success : function(result){
	    					alert("<spring:message code='ezBoard.t54'/>");
	    					
	    					if (SelectedBoardID == BoardGroupID) {
		    			        window.parent.frames[0].location.reload();
		    			        window.location.reload(true);
	    					} else {
		    			    	var pDiv, pId, pValue;
		    			        var h2 = window.parent.frames[0].document.getElementsByTagName("h2");

		    			        /* 2018-12-28 홍승비 - 게시판그룹명 > div -> span 태그로 변경된 부분 id 찾도록 수정 */
		    			        for(var i = 0; i < h2.length; i++){
		    			            if (h2[i].getAttribute("class") == "on"){
		    			                pId = h2[i].getElementsByClassName("h2Title")[0].id;
		    			                pId = pId.replace("TreeCtr", "TreeCtrl");
		    			                pValue = h2[i].getElementsByClassName("h2Title")[0].getAttribute("value");
		    			                
		    			             	// 열려있는 게시판그룹 닫히는 부분 수정
										// window.parent.frames[0].TopBoard_onclick(pId, pValue);
		 		    			     	window.parent.frames[0].treeViewRefresh(pId, pValue);
		 		    			     	break;
		    			            }
		    			        }
		    			        window.location.reload(true);
	    					}
	    				}
	    			});
	    		}
	    	}
	    </script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezBoard.t113"/></h1>
		<div style="max-width:800px;">
		<c:if test="${hasSubBoard == '1'}">		
			<table  class="content">
				<tr>
			    	<th><spring:message code="ezBoard.kje01"/></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table><br/>
				<div id="EmptyMsg">
	    			<div class="warningbox">
				        <p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
				        <dl class="warningDL">
				        	<dt>WARNING</dt>
				        	<dd><spring:message code="ezBoard.t115"/></dd>
				        </dl>
				    </div>
				</div>
		</c:if>
		<c:if test="${hasSubBoard != '1'}">			
			<table class="content">
				<tr>
			    	<th><spring:message code="ezBoard.kje01"/></th>
			    	<td class="point"><c:out value='${boardName}'/></td>
			  	</tr>
			</table><br/>			
			<div class="box" style="padding:10px" >
			  	<spring:message code="ezBoard.t118"/>
			</div>			
			<div class="btnpositionJsp">
			    <a class="imgbtn"><span onclick="Delete()" ><spring:message code="ezBoard.t89"/></span></a>
			</div>
		</c:if>
		</div>
	</body>
</html>