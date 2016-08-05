<%@page import="egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<section  class="body_bg1">
			<article class="portletbox graphbox ">
				<div class="title_nb"><span class="tl_nb"></span><span class="tr_nb"></span><span class="title_txt"><spring:message code='ezHome.t00002' /></span></div>
				<div class="graphcont">
    				<!-- 그래프영역 -->
    				<!-- UI Object -->
        			<div class="v_graph">
        				<%-- <% if(xmldom.SelectNodes("DATA/ROW").Count > 0 ){ %> --%>
        					<span class="r_arrow"> ^</span>
        					<span class="l_arrow"> ^</span>
        					<span class="maxtxt">${dMaxCount } max</span>
	        				<ul>
                				<%-- <% for (int i = 0; i < xmldom.SelectNodes("DATA/ROW").Count; i++){ %> --%>
						            <li>
  					                    <%-- <span class="g_term"><%= xmldom.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("DISPLAYNAME").InnerText %></span>
					                    <span class="g_bar1" style="height:<%= xmldom.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("DRAFTCOUNT").InnerText %>%"></span>
					                    <span class="g_bar2" style="height:<%= xmldom.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("SUSINCOUNT").InnerText%>%"></span></li> --%> 
				                <%-- <%} %> --%>
	        				</ul>
        					<%-- <% } else { %> --%>
        						<div class="nodata_portlet">
        							<p><img src="/images/kr/main/nodata_white.gif" width="107" height="70"></p>
        							<p><spring:message code='ezHome.t00026' /></p>
        						</div>
       					<%-- <% } %> --%>
        			</div>
					<!-- //UI Object -->
    			</div>
				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section>
		
		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			window.onload = window_onload_NewGraph;
	    	function window_onload_NewGraph(){
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            	document.body.style.MozUserSelect = 'none';
	            	document.body.style.WebkitUserSelect = 'none';
	            	document.body.style.khtmlUserSelect = 'none';
	            	document.body.style.oUserSelect = 'none';
	            	document.body.style.UserSelect = 'none';
	        	}
	    	}
	    	window_onload_NewGraph();
		</script>
	</head>
</html>