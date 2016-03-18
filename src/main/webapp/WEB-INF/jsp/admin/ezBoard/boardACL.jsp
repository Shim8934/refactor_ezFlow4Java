<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t75" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">
			var pBoardID = "${boardID}";
	        var pParentBoardID = "${parentBoardID}";
	        <%-- var strList = "<%=strList%>"; --%>
	        var userLang = "${strUserLang}";
	        var pBoardName = "${pBoardName}";
	        var pType = "${pType}";
	        var pParentNeed = "${pParentNeed}";
	        var selectedTargetID = "";
	        var selectedTargetName = "";
	        var selectedTargetName2 = "";
	        var selectTargetListXML = "";
	        
			$(document).ready(function(){			
				
			});
	    </script>
	</head>
	<c:if test="${pParentNeed == 'Y'}">
		<body class="mainbody">
	</c:if>
	<c:if test="${pParentNeed != 'Y'}">
		<body>
	</c:if>
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<TYPE>NONE</TYPE>
		        		<NAME><spring:message code='ezBoard.t39'/></NAME>
		        		<WIDTH>35</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>353</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
		        		<TYPE>NONE</TYPE>
		        		<NAME><spring:message code='ezBoard.t9'/></NAME>
		        		<WIDTH>35</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
		        		<RESIZIBLE>TRUE</RESIZIBLE>
		        		<MINSIZE>10</MINSIZE>
		        		<MAXSIZE>353</MAXSIZE>
		        		<NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t11'/></NAME>
				        <WIDTH>35</WIDTH>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>353</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t37'/></NAME>
				        <WIDTH>35</WIDTH>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>353</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t84'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t83'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t102'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t86'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t87'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t88'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t00051'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t00052'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		    	</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<c:if test="${pParentNeed == 'Y'}">	
	        <h1><spring:message code='ezBoard.t63'/></h1>
		</c:if>
		<c:if test="${pParentNeed != 'Y'}">
			<br />
		</c:if>
		<c:if test="${adminType == 'y'}">
			<div id="mainmenu">
	            <ul>
	                <li><span onclick="goBoardList()"><spring:message code='ezBoard.t72'/></span></li>
	            </ul>
	        </div>
		</c:if>
	    <script type="text/javascript">
		    try{
		        parent.document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t63'/>";
		    }
		    catch (e){
		        document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t63'/>";
		    }
		</script>   
		<table class="content">
			<tr>
		    	<th><spring:message code='ezBoard.t92'/></th>
		        <td class="point">${boardName}</td>
			</tr>
		</table>
		<br/>
		<div class="listview">
		    <div id="AccessList" style="BORDER: 0; HEIGHT: 250px; WIDTH: 100%; overflow:auto;"></div>
		</div>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="SelectTarget()"><spring:message code='ezBoard.t602'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="SaveACL()"><spring:message code='ezBoard.t98'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="DeleteACL('one')"><spring:message code='ezBoard.t89'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="DeleteACL('type')"><spring:message code='ezBoard.t603'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="AclCopy()"><spring:message code='ezBoard.t604'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="UnderBoardCopy()"><spring:message code='ezBoard.t605'/></span></a>
		<br/>
		<table class="content" style="width:100%;">
			<tr style="display: none">
		        <th>
		        	<spring:message code='ezBoard.t93'/><br/>(<spring:message code='ezBoard.t94'/>)
		        </th>
		        <td>
		            <input type="checkbox" id="inherit_OK" onclick="checkbox_onclick(event)" />
		            <spring:message code='ezBoard.t95'/>
		            <input type="checkbox" id="inherit_NO" onclick="checkbox_onclick(event)" />
		            <spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th style="">
		            <spring:message code='ezBoard.t606'/>
		        </th>
		        <td style="vertical-align: middle;">
		            <span id="selectedTarget" style="vertical-align: middle;"></span>&nbsp;
		        </td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t84'/></th>
		        <td>
		            <input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t100'/>
		            <span id="PostSpan">
		            	<input type="checkbox" id="PostNotice" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t101'/>
		            </span>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t83'/></th>
		        <td>
		            <input type="checkbox" id="access_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="access_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t102'/></th>
		        <td>
		            <input type="checkbox" id="list_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="list_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t86'/></th>
		        <td>
		            <input type="checkbox" id="read_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>
		            <input type="checkbox" id="read_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t87'/></th>
		        <td>
		            <input type="checkbox" id="write_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="write_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr id="replyTR">
		        <th><spring:message code='ezBoard.t88'/></th>
		        <td>
		            <input type="checkbox" id="reply_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="reply_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t103'/></th>
		        <td>
		            <input type="checkbox" id="delete_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="delete_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		</table>
		<br/>
	</body>        
</html>