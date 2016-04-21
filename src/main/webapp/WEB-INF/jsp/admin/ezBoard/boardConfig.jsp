<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <link rel="stylesheet" href='/css/Tab.css' type="text/css" />
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">			
			var pUse_Editor = "${use_Editor}";	        
	        var p_Use_IE11Browser = "${use_IE11Browser}";
	        var pBoardID = "${boardID}";
	        var pBoardName = "${boardName}";
	        var pBoardType = "${boardType}";
	        var pParentBoardID = "${parentBoardID}";
	        var TabId = "${tabID}";
	        
	        document.onselectstart = function () { return false; };
	        window.onresize = window_resize;
	        
	        $(document).ready(function(){
	        	if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }   	
	            document.getElementById(TabId).setAttribute("class", "tabon");
	            Tab1_SelectID = TabId;

	            ChangeTab(document.getElementById(TabId));
	            window_resize();
	        });	        

	        function window_resize() {
	            document.getElementById("BoardEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "PX";
	        }
	        function ChangeTab(obj) {
	            var pSelectTab = obj.getAttribute("divname");
	            
	            switch (pSelectTab) {
	                case "BoardEnv_div1":
	                    if (pBoardType == 3){
	                        document.getElementById("BoardEnv_ifrm").src = "/ezBoard/boardItemListPhoto.do?boardID=" + pBoardID + "&boardName=" + encodeURI(pBoardName) + "&boardType=" + pBoardType + "&adminType=y";
	                    }else if (pBoardType == 4){
	                        document.getElementById("BoardEnv_ifrm").src = "/ezBoard/boardItemListThumbnail.do?boardID=" + pBoardID + "&boardName=" + encodeURI(pBoardName) + "&boardType=" + pBoardType + "&adminType=y";
	                    }else{                  	
	                        document.getElementById("BoardEnv_ifrm").src = "/ezBoard/boardItemList.do?boardID=" + pBoardID + "&boardName=" + encodeURI(pBoardName) + "&boardType=" + pBoardType + "&adminType=y";
	                    }
	                    break;
	                case "BoardEnv_div2":
	                    document.getElementById("BoardEnv_ifrm").src = "/admin/ezBoard/boardProperty.do?boardID=" + pBoardID + "&adminType=y";
	                    break;
	                case "BoardEnv_div3":
	                    document.getElementById("BoardEnv_ifrm").src = "/admin/ezBoard/boardACL.do?boardID=" + pBoardID + "&parentBoardID=" + pParentBoardID;
	                    break;
	                case "BoardEnv_div4":
	                    document.getElementById("BoardEnv_ifrm").src = "/admin/ezBoard/boardHeader.do";
	                    break;
	                case "BoardEnv_div5":
	                    //if (CrossYN()){
	                    // 2016-04-11 장진혁과장 Cross 단일 파일로 적용   
	                    document.getElementById("BoardEnv_ifrm").src = "/admin/ezBoard/boardFormSave.do?boardID=" + pBoardID;	
	                    /*} else {
	                        if (pUse_Editor == "TAGFREE" || pUse_Editor == "DEXT")
	                            document.getElementById("BoardEnv_ifrm").src = "/myoffice/ezBoardSTD/admin/BoardForm_save_IE.aspx?BoardID=" + pBoardID;
	                        else {
	                            document.getElementById("BoardEnv_ifrm").src = "/myoffice/ezBoardSTD/admin/BoardForm_save.aspx?BoardID=" + pBoardID;
	                        }
	                    }*/
	                    break;
	            }
	        }
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id){
	                obj.className = "";
	            }
	        }
	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null){
	                    document.getElementById(Tab1_SelectID).className = "";
	                }
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	    </script>
	</head>
	<body class="mainbody">
		<h1><p style="padding-left:5px"><c:out value='${boardName}' /></p></h1>
	    <div class="portlet_tabpart01">
	        <div class="portlet_tabpart01_top" id="tab1">
	            <p id="BoardEnv_sub1"><span divname="BoardEnv_div1" id="1tab1"><spring:message code="ezBoard.t338" /></span></p>
	            <p id="BoardEnv_sub2"><span divname="BoardEnv_div2" id="1tab2"><spring:message code="ezBoard.t60" /></span></p>
	            <p id="BoardEnv_sub3"><span divname="BoardEnv_div3" id="1tab3"><spring:message code="ezBoard.t63" /></span></p>
	            <p id="BoardEnv_sub4" style="display:none;"><span divname="BoardEnv_div4" id="1tab4"><spring:message code="ezBoard.t0003" /></span></p>
	            <p id="BoardEnv_sub5"><span divname="BoardEnv_div5" id="1tab5"><spring:message code="ezBoard.t999026" /></span></p>
	        </div>
	    </div>
	    <iframe id="BoardEnv_ifrm" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>