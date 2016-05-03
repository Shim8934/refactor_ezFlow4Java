<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
<!-- 		title 수정필요할듯-->
		<title id="cop_title"></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script type="text/javascript">
			var strlang = "<c:out value='${userInfo.lang }'/>";
			var xmlDomTreeView = createXmlDom();
			var treedate = "<c:out value='${retXML }'/>";
			var code = "<c:out value='${code }'/>";
			var UserLevel = "<c:out value='${userLevel }'/>";
// 			안될꺼같다
			var ch_CommunityAdmin = "<c:out value='${fn:indexOf(userInfo.rollInfo, \'t=1\') }'/>";
			var codeName = "<c:out value='${codeName }'/>";
			var ch_CheckSysop = "<c:out value='${checkSysop }'/>";
			var newmember_confirmtype = "<c:out value='${newMemberConfirmType }'/>";
			var JoinFlag = "<c:out value='${joinFlag }'/>";
// 			안쓰면 삭제
			var xmlhttp;
			var xmlhttp2;
			
			var strLang1 = "<spring:message code='ezCommunity.t78' />";
		    var strLang2 = "<spring:message code='ezCommunity.t1082' />"; 
		    var strLang3 = "<spring:message code='ezCommunity.t1103' />"; 
		    var strLang4 = "<spring:message code='ezCommunity.t2009' />"; 
		    var strLang5 = "<spring:message code='ezCommunity.t1102' />"; 
		    
		    window.onload = function () {
		        xmlhttp = createXMLHttpRequest();

		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "CODE", code);

		        xmlhttp.open("POST", "/ezCommunity/commHome/commHomeInfo.do", true);

		        xmlhttp.onreadystatechange = event_get_commhomeinfo;
		        xmlhttp.send(xmlDom);

		        xmlhttp2 = createXMLHttpRequest();

		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "CODE", code);

		        xmlhttp2.open("POST", "/ezCommunity/commHome/commHomeBoardInfo.do", true);

		        //이거 만들고 테스트
		        xmlhttp2.onreadystatechange = event_get_homeboardinfo;
		        xmlhttp2.send(xmlDom);
		        
		        var treedom = loadXMLString(treedate);
		        
		        if (SelectNodes(treedom, "TREEVIEWDATA/NODE").length > 0) {
		            for (var i = 0; i < SelectNodes(treedom, "TREEVIEWDATA/NODE").length; i++) {
		                var h2 = document.createElement("H2");
		                var span = document.createElement("SPAN");
		                var img = document.createElement("IMG");
		                img.src = "/images/kr/community/type1/icon_board.gif";
		                img.style.width = "16px";
		                img.style.height = "16px";
		                span.appendChild(img);
		                span.innerHTML += SelectSingleNodeValue(SelectNodes(treedom, "TREEVIEWDATA/NODE")[i], "DATA2");
		                h2.appendChild(span);
		                //h2.appendChild(img);
		                var treeid = SelectSingleNodeValue(SelectNodes(treedom, "TREEVIEWDATA/NODE")[i], "DATA1");
		                h2.className = "off";
		                h2.id = treeid;
		                h2.setAttribute("TreeCtrl", "TreeCtrl" + i);
		                //h2.innerHTML += SelectSingleNodeValue(SelectNodes(treedom, "TREEVIEWDATA/NODE")[i], "DATA2");
		                h2.onclick = function () { TopBoard_onclick(this); };

		                var div = document.createElement("DIV");
		                div.className = "tree";
		                div.id = "TreeCtrl" + i + "obj";
		                div.style.display = "none";
		                div.style.overflow = "auto";
		                document.getElementById("treediv").appendChild(h2);
		                document.getElementById("treediv").appendChild(div);
		            }
		        }
		    }
		</script>
	</head>
	<body>

	</body>
</html>