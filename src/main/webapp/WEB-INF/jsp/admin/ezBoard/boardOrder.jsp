<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.jjh05" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	    
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/common.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" language="javascript">
			var UpperBoardID = "<c:out value='${upperBoardID}'/>";						
	        var xmldom = createXmlDom();
	        var pboardList;
	        var OrderCell = "";
	    		    	
	    	$(document).ready(function(){
	    		GetSubBoards();
	    	});
	    	
	    	function Save(){
	            var iRowCount = pboardList.GetRowCount();
	            var strBoardList = "";

	            if (iRowCount != 0) {
	                for (i = 0; i < iRowCount; i++) {
	                    strBoardList += pboardList.GetDataRows()[i].getAttribute("DATA1") + ";";
	                }

	                $.ajax({
	                	type :	"POST",
	                	dataType : "text",
	                	url : "/admin/ezBoard/saveBoardOrder.do",
	                	data : { boardList : strBoardList },
	                	success : function(){
               				alert("<spring:message code='ezBoard.t79'/>");
               				parent.window.location.reload();
	                	},
	                	error : function(){
	                		alert("<spring:message code='ezBoard.t80'/>");
	                	}	                	
	                });
	            }
	        }
	    	
	    	function GetSubBoards() {
                document.getElementById("BoardList").innerHTML = "";

                $.ajax({
                	type :	"POST",
                	dataType :	"text",
                	async : false,
                	url :	"/admin/ezBoard/getSubBoards.do",
                	data :	{ upperBoardID : UpperBoardID },
                	success : function(result){
                		xmldom = loadXMLString(result);
                        var boardList = new ListView();
                        boardList.SetID("lvBoardList2");
                        boardList.DataSource(listviewheader);
                        boardList.DataBind("BoardList");
                        DisplayBoardList();	
                	}                	
                });                
            }	    	
	    	function listAdd(boardName, boardId) {
                pparsingXML = "<ROW><CELL>";
                pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(boardName) + "</VALUE>";
                pparsingXML = pparsingXML + "<DATA1>" + boardId + "</DATA1>";
                pparsingXML = pparsingXML + "</CELL></ROW>";

                return pparsingXML;
            }	    	
	    	function DisplayBoardList() {
                var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
                var strXML = "<LISTVIEWDATA><ROWS>";
                for (i = 0; i < xmldomNode.length; i++) {
                    var boardName = SelectSingleNodeValue(xmldomNode.item(i), "DATA2");
                    var boardId = SelectSingleNodeValue(xmldomNode.item(i), "DATA1");

                    strXML += listAdd(boardName, boardId);
                }
                strXML += "</ROWS></LISTVIEWDATA>";
                var xmlRtn = loadXMLString(strXML);


                pboardList = new ListView();
                pboardList.SetID("lvBoardList");
                pboardList.SetMulSelectable(false);
                pboardList.DataSource(xmlRtn);
                pboardList.DataBind("BoardList");


                NewBoardID = GetGUID();
                ezUtil = null;
                xmldomNode = null;
                xmldom = null;
            }	    	
	    	function MakeXMLString(pOrgString) {
                return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
            }
            function ReplaceText(orgStr, findStr, replaceStr) {
                try {
                    if (findStr == ".") {
                        var a = 0;
                        for (a = 0; a < 10; a++)
                            orgStr = orgStr.replace(".", replaceStr);
                        return orgStr;
                    }
                    else {
                        var re = new RegExp(findStr, "gi");
                        return (orgStr.replace(re, replaceStr));
                    }
                } catch (e) {
                    return orgStr
                }
            }
            function MoveUp_onclick() {
                pboardList.RowMoveUp();
            }
            function MoveDown_onclick() {
                pboardList.RowMoveDown();
            }
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
	            <td class="point"><c:out value='${boardName}'/></td>
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