<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t143" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
		<script type="text/javascript" language="javascript">
			var BoardID = "${model.boardID}";
	        var brd_color = "${model.boardColor}";
	        var portlet = "${model.portlet}";
	        var background = "${model.backGround}";
	        var pAdminType = "${adminType}";
	        var FormFlag = "${model.formFlag}";	        
	        
	        document.onselectstart = function (){
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	    	};
        
			$(document).ready(function(){			
				
			});
			
			
	    </script>
	</head>	
	<c:if test="${adminType != 'y'}">
		<body class="mainbody">		
			<h1><spring:message code="ezBoard.t60"/></h1>
	</c:if>	
	<c:if test="${adminType == 'y'}">
		<body>
	</c:if>
		<br/>
		<xml id="listviewheader" style ="display:none"></xml>
		<table class="content">
	        <tr>
	            <th><spring:message code="ezBoard.t114"/></th>
	            <td style="padding: 0;">
	            	<c:if test="${use_multiData == 'YES'}">
		                <table style="width: 100%">
		                    <tr class="primary">
		                        <th>${lang_primary}</th>
		                        <td style="border-bottom:1px solid #b6b6b6;">${model.boardName}</td>
		                    </tr>
		                    <tr class="secondary">
		                        <th>${lang_secondary}</th>
		                        <td>${model.boardName2}</td>
		                    </tr>
		                </table>
		            </c:if>
		            <c:if test="${use_multiData != 'YES'}">${model.boardName}</c:if>                	    
	            </td>
	        </tr>
	    </table>
	    <br/>
	    <table class="content">
	        <tr>
	            <th><spring:message code="ezBoard.t111"/></th>
	            <!-- 20060613 준호 수정 -->
	            <!-- 게시판명 특수문자 있을때 깨지는 현상 수정 -->
	            <td style="padding: 0;">
	                <c:if test="${use_multiData == 'YES'}">
		                <table style="width: 100%">
		                    <tr class="primary">
		                        <th>${lang_primary}</th>
		                        <td style="border-bottom:1px solid #b6b6b6;">
		                            <input type="text" id="txtBoardName" style="width: 99%" value="${model.boardName}" maxlength="25" />
		                        </td>
		                    </tr>
		                    <tr class="secondary">
		                        <th>${lang_secondary}</th>
		                        <td>
		                            <input type="text" id="txtBoardName2" style="width: 99%" value="${model.boardName2}" maxlength="25" />
		                        </td>
		                    </tr>
		                </table>
		            </c:if>    
	          		<c:if test="${use_multiData != 'YES'}">
	                	<input type="text" id="txtBoardName" style="width: 100%" value="${model.boardName}" maxlength="25" />
	                </c:if>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code="ezBoard.t154"/></th>
	            <td>${model.boardNo}</td>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t155"/></th>
	            <td>
	                <input type="text" id="txtBoardDescription" style="width: 99%" value="${model.boardDescription}" maxlength="99" />
	            </td>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t156"/></th>
	            <td>
	            	<c:if test="${model.itemExpires == '-1'}">	            
		                <input type="checkbox" id="chkPermanent" onclick="chkPermanent_onclick()" checked />
		                <spring:message code="ezBoard.t157"/>
		                <input type="checkbox" id="chkExpires" onclick="chkExpires_onclick()" />
		                <input type="text" id="txtExpires" value="365" style="width: 35px" />
		                <spring:message code="ezBoard.t158"/>
	            	</c:if>
	                <c:if test="${model.itemExpires != '-1'}">   
		                <input type="checkbox" id="chkPermanent" onclick="chkPermanent_onclick()" />
		                <spring:message code="ezBoard.t157"/>
		                <input type="checkbox" id="chkExpires" onclick="chkExpires_onclick()" checked />
		                <input type="text" id="txtExpires" style="width: 35px" value="${model.itemExpires}" />
		                <spring:message code="ezBoard.t158"/>
	                </c:if> 
				</td>
	        </tr>
	        <tr style="${style}">	        
	        	<c:if test="${model.deleteAfter == '-1'}">
		            <th><spring:message code="ezBoard.t159"/></th>
		            <td>
		            	<spring:message code="ezBoard.t160"/>
	                	<input type="inputbox" id="deleteafter" style="width: 50px"/>
	                	<spring:message code="ezBoard.t161"/><br/>
	                	<input type="checkbox" id="usedeleteafter"/>
	                	<spring:message code="ezBoard.t162"/>
	                </td>
	            </c:if>
	            <c:if test="${model.deleteAfter != '-1'}">
	            	<th><spring:message code="ezBoard.t159"/></th>
	            	<td>
	            		<spring:message code="ezBoard.t160"/>
	                	<input type="inputbox" id="deleteafter" style="width: 50px" value="${model.deleteAfter}"/>
	                	<spring:message code="ezBoard.t161"/><br/>
	                	<input type="checkbox" id="usedeleteafter" checked />
	                	<spring:message code="ezBoard.t162"/>
	                </td>
	            </c:if>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t163"/></th>
	            <td>
	            	<c:if test="${model.guBun == '0'}">
	                	<input type="checkbox" id="chkGeneralBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t00053" />
	                </c:if>
	                <c:if test="${model.guBun != '0'}">
	                	<input type="checkbox" id="chkGeneralBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t00053"/>
	                </c:if>
	                <c:if test="${model.guBun == '1'}">	                   
	                	<input type="checkbox" id="chkGroupBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t164"/>
	                </c:if>
	                <c:if test="${model.guBun != '1'}">
	                	<input type="checkbox" id="chkGroupBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t164"/>
	                </c:if>
	                <c:if test="${model.guBun == '2'}">	                   
	                	<input type="checkbox" id="chkAnonyBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t165"/>
	                </c:if>
	                <c:if test="${model.guBun != '2'}">	                   
	                	<input type="checkbox" id="chkAnonyBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t165"/>
	                </c:if>
	                <c:if test="${model.guBun == '3'}">	                   
	                	<input type="checkbox" id="chkPhotoBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t166"/>
	                </c:if>
	                <c:if test="${model.guBun != '3'}">
	                	<input type="checkbox" id="chkPhotoBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t166"/>
	                </c:if>
	                <c:if test="${model.guBun == '4'}">	                   
	                	<input type="checkbox" id="chkThumbBoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t3000"/>
	                </c:if>
	                <c:if test="${model.guBun != '4'}">
	                	<input type="checkbox" id="chkThumbBoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t3000"/>
	                </c:if>
	                <c:if test="${model.guBun == '5'}">	                   
	                	<input type="checkbox" id="chkQnABoard" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t00054" />
	                </c:if>
					<c:if test="${model.guBun != '5'}">	                   
	                	<input type="checkbox" id="chkQnABoard" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t00054" />
	                </c:if>
	            </td>
	        </tr>
	        <tr id="tr3" style="${style}">
	            <th><spring:message code="ezBoard.t999020" /></th>
	            <td>
	                <input type="checkbox" id="chkApprBoard" onclick="checkApprBoard()"><spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="chkApprListMail" style="display:none;">
	            <th><spring:message code="ezBoard.t999019" /></th>
	            <td>
	                <input type="checkbox" id="chkApprBoardMail" onclick="checkApprMail()"><spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="chkApprList" style="display:none;">
	            <th>
	            	<a class="imgbtn"><span onclick="SelectTarget()"><spring:message code="ezBoard.t999003" /></span></a>
	            </th>
	            <td>
	                <span id="selectedTarget" style="vertical-align: middle;display:none;"></span>
	                <div class="listview" style="height:100px;overflow-y:auto;overflow-x:hidden;" id="AccessList"></div>
	            </td>
	        </tr>
	        <tr id="trPortlet" style="${style}">
	            <th><spring:message code="ezBoard.t481" /></th>
	            <td>
	                <input type="checkbox" id="chkPortletBoard" onclick="checkboardtype()" />
	                <spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="tr1" style="${style}">
	            <th><spring:message code="ezBoard.t5011" /></th>
	            <td>
	                <input type="checkbox" id="chkbackgroundimage" onclick="checkboardtype()" />
	                <spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr id="tr2" style="${style}">
	            <th><spring:message code="ezBoard.t999027" /></th>
	            <td>
	                <input type="checkbox" id="chkform" onclick="checkboardtype()" />
	                <spring:message code="ezBoard.t162" />
	            </td>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t167" /></th>
	            <td>
	                <input type="text" id="txtAttachLimit" style="width: 25px" value="${model.attachLimit}" />&nbsp;MB
	            </td>
	        </tr>
	        <tr style="${style}">
	            <th>URL</th>
	            <td>
	                <input type="text" id="txtURL" style="width: 99%" value="${model.url}" />
	            </td>
	        </tr>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t168" /></th>
	            <td>
	            	<c:if test="${model.replyNotify == '1'}">	            	
	                	<input type="checkbox" id="chkNotify" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t95" />
	                </c:if>
	                <c:if test="${model.replyNotify != '1'}">	                   
	                	<input type="checkbox" id="chkNotify" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t95" />
	                </c:if>		                 
	            </td>
	        </tr>
	        <%--2011-04 : 한줄 답변 옵션화 처리.--%>
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t324" /></th>
	            <td>
	            	<c:if test="${model.oneLineReply == '1'}">	                
	                	<input type="checkbox" id="chkOneLine" onclick="checkboardtype()" checked />
	                	<spring:message code="ezBoard.t496" />
	                </c:if>
	                <c:if test="${model.oneLineReply != '1'}">	                  
	                	<input type="checkbox" id="chkOneLine" onclick="checkboardtype()" />
	                	<spring:message code="ezBoard.t496" />
	                </c:if>
	            </td>
	        </tr>	
	        <tr id="trAttribute" style="${style}">
	            <th><spring:message code="ezBoard.t999028" /></th>
	            <td>
	            	<a class="imgbtn"><span onClick="ExtensionAttribute_onClick()"><spring:message code="ezBoard.t999029" /></span></a>
	            </td>
	        </tr>	
	        <tr style="${style}">
	            <th><spring:message code="ezBoard.t169" /></th>
	            <td style="height: 100%">
	                <table style="width: 300px">
	                    <tr>
	                        <td style="width: 100px;">
	                            <div id="selColor" style="width: 100px; height: 100%; background-color: ${model.boardColor}; border: 1px solid #686868;"></div>
	                        </td>
	                        <td style="width: 100px;">
	                            <span id="colorID" style="width: 80px;">${model.boardColor}</span>
	                        </td>
	                        <td style="text-align: right; width: 100px">
	                            <a class="imgbtn"><span onclick="change_brdColor()"><spring:message code="ezBoard.t170" /></span></a>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
		</table>
    	<br/>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return Save()"><spring:message code="ezBoard.t98" /></span></a>
	    </div>
	</body>
</html>