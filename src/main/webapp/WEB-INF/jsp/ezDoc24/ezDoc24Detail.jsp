<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t320'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	</head>
	<body class="popup">
		  <h1>상세보기</h1>
		  <div id="close">
		    <ul>
		      <li onClick="window.parent.DivPopUpHidden()"><span></span></li>
		    </ul>
		  </div>
		        <div style="width:100%; height:305px" id="divList">
		            <table id="doc24DetailTable" class="popuplist" style="width:100%">
		            	<tr>
		            		<th>
		            			사업장명
		            		</th>
		            		<td>
		            			${cmpnyNm }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			발신인명의
		            		</th>
		            		<td>
		            			${senderNm }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			사업자등록번호
		            		</th>
		            		<td>
		            			${bizrno }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			법인등록번호
		            		</th>
		            		<td>
		            			${jurirno }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			전화번호
		            		</th>
		            		<td>
		            			${telnum }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			FAX번호
		            		</th>
		            		<td>
		            			${fxnum }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			우편번호
		            		</th>
		            		<td>
		            			${zip }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			사업장 기본주소<br>
		            			(도로명주소)
		            		</th>
		            		<td>
		            			${adres }
		            		</td>
		            	</tr>
		            	<tr>
		            		<th>
		            			상세주소
		            		</th>
		            		<td>
		            			${detailAdres }
		            		</td>
		            	</tr>
		            </table>
	   	     </div>	
	</body>
</html>
