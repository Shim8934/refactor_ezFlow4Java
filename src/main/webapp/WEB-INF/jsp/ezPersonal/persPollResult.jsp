<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t380' /></title>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3' />" type="text/css">
		<script src="/js/mouseefect.js" type="text/javascript" ></script>
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<style type="text/css">
        	.question {
	            background: url(/images/kr/main/popup_pollimg.gif) no-repeat #f2f2f2 0px 0px;
            	padding: 5px 0px 5px 55px;
            	margin-top: 0px;
            	height: 60px;
            	word-break: break-all;
            	border: 1px solid #b8b6b6;
        	}
        	.question p {
	            margin: 0px;
            	padding: 0px;
            	font-size: 12px;
            	font-weight: bold;
            	color: #4a83d5;
        	}
    	</style>
		<script type="text/javascript">
			var ReturnFunction;
        	window.onload = function () {
	            try {
                	ReturnFunction = opener.PollResult_Cross_dialogArguments[1];
            	} catch (e) {}
        	}
        	function close_btn() {
	            if(ReturnFunction!= null)
                	ReturnFunction();
            	window.close();
        	}
		</script>
	</head>
	<body class="popup" style="overflow:hidden"> 
  		<h1>Quick Poll</h1>
  		<div id="close"><ul><li><span onClick="close_btn()"><spring:message code='ezPersonal.t10' /></span></li></ul></div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script> 
    	<table>
	        <tr>
    	        <td>
        	        <div class="question" style="overflow-y:auto;width:375px">
	        	        <p><spring:message code='ezPersonal.t2000' />:</p>
                    	<span>${subject}</span>
                	</div>
            	</td>
        	</tr>
        	<tr style="height:100%">
            	<td>
                	<div id="receivelist" style="OVERFLOW-X: hidden; padding:10px;overflow-y:auto;height:225px;width:410px" class="box"> 
                    	<%-- <asp:repeater id="ListPoll" Runat="server"> 
                      		<ItemTemplate> 
                       			<span class="txt"><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TITLE").InnerText) %></b>(<b><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("COUNT").InnerText %></b><spring:message code='ezPersonal.t247' /><span class="point"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("PERCENT").InnerText %></span>%)</span>
                          		<table style="border:1px solid #c9c9c9;width:100%;height:12px;background-image:url(/images/quickpoll_bg.gif);"> 
									<tr> 
                                		<td style="width:<%# Convert.ToDouble(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("PERCENT").InnerText)*4 %>px;background-color:#68bbef""></td> 
                                		<td style="width:<%# 400-Convert.ToDouble(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("PERCENT").InnerText)*4 %>px;"></td> 
                              		</tr> 
                            	</table><br>
                      		</ItemTemplate> 
                    	</asp:repeater>  --%>
                	</div>
            	</td>
        	</tr>
    	</table>
	</body>
</html>