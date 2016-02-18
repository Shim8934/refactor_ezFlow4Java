<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>BoardOrder</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	    
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" language="javascript">
			var UpperBoardID = "${upperBoardID}";
	    		    	
	    	$(document).ready(function(){
	    		//GetSubBoards();
	    	});
	    </script>
	</head>
	<body class="mainbody">
		<xml id="listviewheader" style="display: none">
		    <LISTVIEWDATA>
			    <HEADERS>
				    <HEADER>
					    <TYPE>NONE</TYPE>
					    <NAME><spring:message code="ezBoard.t142"/></NAME>
					    <WIDTH>70</WIDTH>
					    <SORTABLE>TRUE</SORTABLE>
					    <RESIZIBLE>FALSE</RESIZIBLE>
					    <MINSIZE>10</MINSIZE>
					    <MAXSIZE>200</MAXSIZE>
					    <NOWRAP>TRUE</NOWRAP>
					</HEADER>
			    </HEADERS>
		    </LISTVIEWDATA>
		</xml>
		
		<h1><spring:message code="ezBoard.t64"/></h1>
		<table class="content">
			<tr>
	            <th><spring:message code="ezBoard.t92"/></th>
	            <td class="point">${boardName}</td>
	        </tr>
	    </table><br />
	    <div id="mainmenu">
	        <ul id="tb_Parent">
	            <li>
	                <span onclick="GetSubBoards()">
	                    <img src="/images/ImgIcon/recur.gif" style="margin-top: -2px;" />
	                    <spring:message code="ezBoard.t205"/>
	                </span>
	            </li>
	            <li>
	                <span onclick="MoveUp_onclick()">
	                    <img src="/images/ImgIcon/prev.gif" style="margin-top: -2px;" alt="위로" />
	                </span>
	            </li>
	            <li>
	                <span onclick="MoveDown_onclick()">
	                    <img src="/images/ImgIcon/next.gif" style="margin-top: -2px;" alt="아래로" />
	                </span>
	            </li>
	        </ul>
	    </div>
	    <table style="width: 100%">
	        <tr>
	            <td class="listview">
	                <div id="BoardList" style="BACKGROUND-COLOR: #ffffff; BORDER: 0px; HEIGHT: 250px; WIDTH: 100%; overflow: auto;"></div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="Save()"><spring:message code="ezBoard.t98"/></span></a>
	    </div>
	</body>
</html>