<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <title>TopMenu</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />               
        <link rel="stylesheet" href="${util.addVer('main.e6', 'msg')}" type="text/css" />
        <style type="text/css">
            <c:if test="${lang == '2'}">
                #input_search { background:#f2f2f2 url(/../images/us/cm/input_search_bg.gif) no-repeat 0 0 }
            </c:if>
            <c:if test="${lang == '3'} cd">
                #input_search { background:#f2f2f2 url(/../images/jp/cm/input_search_bg.gif) no-repeat 0 0 }
            </c:if>
            <c:if test="${lang == '4'}">
                #input_search { background:#f2f2f2 url(/../images/cn/cm/input_search_bg.gif) no-repeat 0 0 }
            </c:if>
        </style>    
        <script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>          
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript">
        var skinnum = "";
        
        var selectedCell = "";
        var selectedSubCell = "";
        var previousSubCell = null;
        var previousCell = null;
        var count = 1000;
        var pageid = "F3633607-8E8B-42A1-B777-6E2969072E58";
        var parentpageid = "top";
        var mode = "view";
        var editmode = "";
        var viewmode = "";
        var bInherit = false;
        var pressCount = 0;
        var selObjClass = "";
        var SkinExist = "NO";
        var pNoneActiveX = "YES";
        
        // 2009.11.25 - 소스보기시 개인정보 유출방지
        var pwd = "";
        document.onselectstart = function () { return false; };
        
        window.onload = function() {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
            if (editmode == "new_inherit") bInherit = true;
            
            // 2009.11.25 - 소스보기시 개인정보 유출방지
//            pwd = CheckPwd();
            
            // 검색UI 설정
            try {
                if (typeof(searchTD) == "object") {
                    searchTD.parentNode.parentNode.parentNode.style.width = "100%";
                    searchTD.innerHTML = "<table border=\"0\" height=\"41\" cellspacing=\"0\" cellpadding=\"0\"><tr>" +
                                        "<td width=\"44\"   height=\"40\" valign=\"middle\"><img src=\"/images/main/totalsearch.gif\" align=\"absmiddle\"></td>" +
                                        "<td width=\"140\"   height=\"40\" valign=\"middle\">   <input name=\"txtSearch\" type=\"text\"  class=\"search\" onkeydown=entercheck()></td>" +                                   
                                        "<td width=\"31\"  height=\"40\" valign=\"middle\"><img src=\"/images/top/bt_search.gif\" width=\"31\" height=\"21\" style='cursor:pointer' onclick=Search()></td>" +
                                        "</tr></table>";
                }
            }
            catch (e) {console.log(e);}
            
            // 수정(2007.03.14) : 사용자 정보 영역 UI 설정
            try {
                if (typeof(userInfoTD) == "object") {
                    userInfoTD.parentNode.parentNode.parentNode.style.marginTop = "10px";
                    userInfoTD.innerHTML = "<iframe width=300 height=31 border=0 src='/myoffice/ezPortal/filter/UserInfoPortlet.aspx' frameborder=0 scrolling=no></iframe>";
                }
            }
            catch (e) {console.log(e);}
    
            // 보기모드에서 미리보기가 아닌 경우 실행
            if (mode == "view" && viewmode != "preview") {
                var agentObj;
                 if (!CrossYN()) {
                     //브라우저 정보 가져오기
                    var userAgent = window.navigator.userAgent;
                    
                    //IE9 일때만 ActiveX 설치하게 설정
                    if (userAgent.indexOf("Trident/5.0") > 0) {
                         GetObject();
                         ezNotieSetting();
                    }
                    
                } 
//              window.setInterval("update_connectinfo()", 30000);  
            }
        }
        function ezNotieSetting() {
            
        }
        function GetObject() {
            var agentObj;
            try {
            } catch (e) {console.log(e);}

            var agentObj;
            i_icd2.SetDocumentDisp(window.document);
            i_icd2.xmlURL = "http://" + document.location.hostname + "/ezNewPortal/componentListTransfer.do";
            i_icd2.CheckVersion();
            var nCount = i_icd2.nNeedDownload;
            if (nCount) {
                if_Progress.StartOn();
            } else {
                finish_download();
            }
        }

        function finish_download() {
            OfficeBugPatch();   
            popupNotice();
        }

        function OfficeBugPatch()
        {
        }
        
        // 2009.11.25 - 소스보기시 개인정보 유출방지
        function CheckPwd() {
                var strPwd = "";
                var xmlhttp = createXMLHttpRequest();
                xmlhttp.open("POST", "interASP/CheckPwd.aspx", false);
                xmlhttp.send();        
                strPwd = xmlhttp.responseText;
                if(strPwd == "FALSE") {
                       xmlhttp = null;        
                       return "FALSE";
                }
                xmlhttp = null;
                return strPwd;
        }

        
        function popupNotice() {
            //document.all.ifmpopup.src ="popup_menu.aspx";
        }

        var xmlHTTP = null;
        var blogout = false;
    
    // 2016-07-27 임시로 주석    
    /*  function update_connectinfo()
        {
            if (blogout)
                return;
                
            xmlHTTP = createXMLHttpRequest();
            xmlHTTP.open("POST", "/myoffice/main/update_connectinfo.aspx", true);
            xmlHTTP.onreadystatechange = event_update_connectinfo;
            xmlHTTP.send();
        } */
        
        var bLogOutNOTICE = false;
        function event_update_connectinfo() {
            if (xmlHTTP.readyState != 4)
                return;
            
            if (xmlHTTP.status == 200 && xmlHTTP.responseText == "LOGOUT") {
                blogout = true;
                alert("<spring:message code='ezPortal.t346' />");
                window.top.location.href = "/user/login/actionLogout.do";
            }
        }
        
        function change_menu(idx, navigation_info) {
            
        }

        function OpenInformationUI(pInformationContent)
        {
            var parameter = pInformationContent;
            var url = "/myoffice/ezApproval/ezAPROPINION.htm";
            var feature = "status:no;dialogWidth:330px;dialogHeight:180px;help:no;scroll:no;edge:sunken";
            var RtnVal = window.showModalDialog(url,parameter,feature);
            return RtnVal;
        }

        function load()
        {
            var ret = window.showModalDialog("TopMenu_search.aspx?mode=load");
            if (typeof(ret) == "undefined") return;
            
            document.location.href = "/ezPortal/topMenu.do?pageID=" + ret[0];
        }

        function inherit()
        {
            var ret = window.showModalDialog("TopMenu_search.aspx?mode=inherit");
            if (typeof(ret) == "undefined") return;
            
            document.location.href = "/ezPortal/topMenu.do?parentPageID=" + ret[0];
        }

        function savesub(pObject, pPageID, pParentPageID, pDisplayName, pDisplayName2)
        {
            var strXML = "<DATA>";
            strXML += "<DISPLAYNAME>" + pDisplayName + "</DISPLAYNAME>";
            strXML += "<DISPLAYNAME2>" + pDisplayName2 + "</DISPLAYNAME2>";
            strXML += "<THEMEINFO>" + ReplaceValidString(document.getElementById("Themeinfo").value) + "</THEMEINFO>";
            strXML += "<WIDTH>" + pObject.getAttribute("width").toString().replace("px", "").replace("100%", "-1") + "</WIDTH>";
            strXML += "<HEIGHT>" + pObject.getAttribute("height").toString().replace("px", "").replace("100%", "-1") + "</HEIGHT>";
            strXML += "<PARENTPAGEID>" + pParentPageID + "</PARENTPAGEID>";
            
            // 대상테이블의 최상위td count
            for (var i=0; i<pObject.children.item(0).children.item(0).children.length; i++)
            {
                // 최상위td
                if (pObject.children.item(0).children.item(0).children.item(i).id == "") continue;
                if (pObject.children.item(0).children.item(0).children.item(i).id.substr(0, 2) == "td")
                {
                    strXML += "<CELL>";
                    var td_item = pObject.children.item(0).children.item(0).children.item(i);
                    strXML += "<WIDTH>" + td_item.style.width.toString().replace("px", "") + "</WIDTH>";
                    
                    // 해당td내의 tr의 카운트 (TABLE/TBODY/TR)
                    for (var j=0; j<td_item.children.item(0).children.item(0).children.length; j++)
                    {
                        // 해당 tr내의 td
                        var tdsub_item = td_item.children.item(0).children.item(0).children.item(j).children.item(0);
                            
            
                        if (tdsub_item.id == "") continue;
                        
                        
                        // td안에 컨텐츠가 존재하는 경우
                        if (tdsub_item.children.length > 0 && tdsub_item.children.item(0).id.toLowerCase().substr(0, 4) != "main")
                        {
                            strXML += "<ROW>";
                            strXML += "<TYPE>0</TYPE>";
                            strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
                            strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
                            strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
                            strXML += "<DISPLAYNAME>" + tdsub_item.firstChild.innerHTML+ "</DISPLAYNAME>";
                            strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
                            strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
                            strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
                            strXML += "<ROOTPAGEID>" + pageid + "</ROOTPAGEID>";
                            strXML += "</ROW>";
                        }
                        // td안에 테이블이 존재하는 경우
                        else {
                            strXML += "<ROW>";
                            strXML += "<TYPE>1</TYPE>";
                            strXML += "<UID>" + tdsub_item.getAttribute("uid") + "</UID>";
                            strXML += "<PAGEUID>" + tdsub_item.getAttribute("pageuid") + "</PAGEUID>";
                            strXML += "<HEIGHT>" + tdsub_item.parentElement.style.height.toString().replace("px", "") + "</HEIGHT>";
                            strXML += "<DISPLAYNAME>" + tdsub_item.getAttribute("pageuid") + "</DISPLAYNAME>";
                            strXML += "<CANREMOVE>" + tdsub_item.getAttribute("canremove") + "</CANREMOVE>";
                            strXML += "<CANRESIZE>" + tdsub_item.getAttribute("canresize") + "</CANRESIZE>";
                            strXML += "<CANREPLACE>" + tdsub_item.getAttribute("canreplace") + "</CANREPLACE>";
                            strXML += "<ROOTPAGEID>" + pageid + "</ROOTPAGEID>";
                            strXML += "</ROW>";
                            
                            // 하위테이블의 정보를 저장
                            savesub(tdsub_item.children.item(0), tdsub_item.getAttribute("uid"), "top", tdsub_item.getAttribute("uid"), tdsub_item.getAttribute("uid"));
                        }
                    }
                    strXML += "</CELL>";
                }
            }
            strXML += "</DATA>";

            var xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/admin/ezPortal/portalSaveTopMenu.do?pageID=" + pPageID + "&parentPageID=" + pParentPageID, false);
            xmlhttp.send(strXML);
            xmlhttp = null;
        }

        function save()
        {
            if (txtDisplayName.value == "")
            {               
                alert("<spring:message code='ezPortal.t361' />");
                txtDisplayName.focus();
                return;     
            }
            if (txtDisplayName2.value == "")
            {               
                txtDisplayName2.value = txtDisplayName.value;
            }
            
            savesub(main_table, pageid, parentpageid, txtDisplayName.value, txtDisplayName2.value);
            
            // 스킨정보 생성
            if (SkinExist == "NO")
                SaveSkin(pageid);
            
            alert("<spring:message code='ezPortal.t84' />");
            document.location.href = "/ezPortal/topMenu.do?pageID=" + pageid;
        }
        
        function SaveSkin(pPageID)
        {
            var xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/admin/ezPortal/portalSaveSkin.do?pageID=" + pPageID, false);
            xmlhttp.send();
            xmlhttp = null;
        }
        
        function CheckDuplicate(pUID)
        {
            for (var i=0; i<main_table.getElementsByTagName("td").length; i++)
            {
                if (main_table.getElementsByTagName("td").item(i).getAttribute("uid") == pUID) return true;
            }
            return false;
        }
        
        function OpenEditWindow(pUID)
        {
            if (pUID == "201") window.open("admin/edit/LogoArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
            if (pUID == "202") window.open("admin/edit/UtilMenuArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
            if (pUID == "203") window.open("admin/edit/MainMenuArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
            if (pUID == "205") window.open("admin/edit/SearchArea_Edit.aspx?pageid=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
        }
        
        function dblclicksubcell()
        {
            var obj = null;
            if (event.srcElement.id == "") obj = event.srcElement.parentElement;
            else obj = event.srcElement;
            
            if (typeof(obj.uid) != "undefined" && obj.uid != "") 
            {
                event.cancelBubble = true;  
                OpenEditWindow(obj.uid);
            }
        }

        function cellkeyup()
        {
            pressCount = 0;
        }

        function GetPageID(pCell) {
            if (typeof (pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid")) != "undefined") return pCell.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.getAttribute("uid");
            else return pageid;
        }
        var menuitem_search_dialogArguments = new Array();

        //크로스용 함수 추가
        function swapNodes(item1, item2) {
            var itemtmp = item1.cloneNode(1);
            var parent = item1.parentNode;
            item2 = parent.replaceChild(itemtmp, item2);
            parent.replaceChild(item2, item1);
            parent.replaceChild(item1, itemtmp);
            itemtmp = null;
        }
        function getNextSibling(node) {

            while (node.nodeType != 1) {
                node = node.nextSibling;
            }

            return node;
        }
        function getPreviousSibling(node) {

            while (node.nodeType != 1) {
                node = node.previousSibling;
            }

            return node;
        }

        function GetMainTable(pCell)
        {
            try {
                return pCell.parentElement.parentElement.parentElement.id;
            } catch (e) {console.log(e);}
        }
        
        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function GetGUID() {
            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
        }

        function GetID()
        {
            return count++;
        }

        function preview()
        {
            window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + pageid);
        }

        function OpenMaxURL(pURL)
        {
            if (pURL == "") return; 
            location.href = pURL;
        }

        function newpage() {
			location.href = "/ezPortal/topMenu.do?mode=new";
		}

        /* 2018-03-07 장진혁 서브메뉴 수정 현재 이미지 관리 및 롤오버시 이미지 변환 함수 */			
		var subPath = "";
		var menuName = "";
		var tempobj;
        
        function img_onMouseOver(obj) {			    
		    if (document.getElementById("menu_" + obj.id) != null) {
		        subPath = "menu_" + obj.id;
		        menuName = obj.id;
		        document.getElementById("menu_" + obj.id).style.left = 0;			        
		        document.getElementById("menu_" + obj.id).style.display = "";
		        var LeftMargin = parseInt(document.getElementById(menuName).offsetLeft) - 60;
		        
		        if (window.document.documentElement.clientWidth < document.getElementById(menuName).offsetLeft + document.getElementById("menu_" + obj.id).clientWidth) {
		            LeftMargin = LeftMargin - (document.getElementById(menuName).offsetLeft + document.getElementById("menu_" + obj.id).clientWidth - window.document.documentElement.clientWidth);
		            LeftMargin = LeftMargin - 20;
		        }
				var cw = document.getElementById(obj.id).clientWidth;
				
		        document.getElementById("menu_" + obj.id).style.left = LeftMargin + "px";
		        document.getElementById("menu_" + obj.id).style.width = cw + "px";
		    } else {
		        menuName = obj.id;
		        subPath = "";
		    }
		    
		    parent.document.getElementById("topFrame").style.position = "relative";
		}

        function img_onMouseOut(obj){
			tempobj = obj;
			
			if (document.getElementById("menu_"+obj.id)) {
				document.getElementById("menu_"+obj.id).style.display = "none";
			}
		    
		    parent.document.getElementById("topFrame").style.position = "";
		}

        function submenuover(subObj) {				
		    if (tempobj.id == subObj.id.replace("menu_", "")) {
				img_onMouseOver(tempobj);
		    }
		}

        function submenuout(subObj) {
		    img_onMouseOut(tempobj);
		}
        
        window.onresize = function () {
		    if (clickmenusub != "") {
		        document.getElementById(clickmenusub).style.left = 0;
		        var LeftMargin = parseInt(document.getElementsByName(clickmenuName)[0].offsetLeft);
		        
		        if (window.document.documentElement.clientWidth <= document.getElementsByName(clickmenuName)[0].offsetLeft + document.getElementById(clickmenusub).clientWidth) {
		            LeftMargin = LeftMargin - (document.getElementsByName(clickmenuName)[0].offsetLeft + document.getElementById(clickmenusub).clientWidth - window.document.documentElement.clientWidth);
		            LeftMargin = LeftMargin - 30;
		        }
		        
		        document.getElementById(clickmenusub).style.left = LeftMargin + "px";
		    }
		}

        function sub_toggle(subfolder) {
			try {
				for (var i=0; i<subfolder.parentElement.children.length; i++) {
					subfolder.parentElement.children.item(i).style.display = "none";
				}
			
				subfolder.style.display = "block";		
				//subfolder.firstChild.firstChild.firstChild.click();
			} catch(e) {console.log(e);}
		}
        
        function submenuclick(pSubMenuID) {
			
		}

     	// 통합검색
		function Search() {
			txtSearch.value = TrimText(ReplaceText(txtSearch.value, "'", ""));
			var pSearchString = txtSearch.value;
			
			parent.document.querySelector("iframe[name=main]").src = "/myoffice/ezsearch/index_search.aspx?Keyword=" + escape(pSearchString);
		}
        
        function keyword_Clear(obj) {
		    obj.value = "";
		}
        
        function Key_event(e,obj) {
		    var curevent = (typeof event == 'undefined' ? e : event)
		        if (curevent.keyCode == "13") {
		            Emp_Search();
		        }
		}

        function input_Onblur(obj) {
		    if (obj.value.length == 0) { obj.className = 'input_text' } else { obj.className = 'input_text focusnot' }
		}
        
     	// 직원조회
		function Emp_Search() {
		    if (document.getElementById('input_search').value != "") {
		        var wHeight = 670;
		        var wWidth = 880;
		        var wVertical = Math.floor(screen.height / 2) - (wHeight / 2);
		        var wHorizontal = Math.floor(screen.width / 2) - (wWidth / 2);

		        window.open("/ezPersonal/personSearch.do?searchString=" + encodeURI(document.getElementById('input_search').value), "", "height=" + wHeight + "px,width=" + wWidth + "px, left=" + wHorizontal + "px, top=" + wVertical + "px, status=no, toolbar=no, menubar=no,location=no, resizable=0");
		        document.getElementById('input_search').value = '';
		    }
		}

        var clickmenusub = "";
        var clickmenuPath = "";
        var clickmenuName = "";
        
        function OpenWindow(evt, url, location, option) {
			/* if (option != "") {
    			var width = 0, height = 0;
    			var leftPosition = "", topPosition = "";
    			var opt = option.split(',');
    			
    			for (var i = 0 ; i < opt.length ; i++) {
        			if (opt[i].indexOf('height') > -1) {
            			height = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
            			var top = (window.screen.height / 2) - ((height / 2) + 50);
            			topPosition = ", top=" + top + ", screenY=" + top;
        			}
        			
        			if (opt[i].indexOf('width') > -1) {
            			width = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
            			left = (window.screen.width / 2) - ((width / 2) + 10);
            			leftPosition = ", left=" + left + ", screenX=" + left;
        			}
    			}
    			option = option + topPosition + leftPosition;
			}
			
			if (evt != undefined) {
    			var targetid = evt.target ? evt.target.id : event.srcElement.id;

    			if (targetid != "") {
        			clickmenusub = subPath;
        			if (menuName != clickmenuName) {
            			clickmenuPath = oldPath;
            			clickmenuName = menuName;
        			}
    			}
    			
    			var targetName = evt.target ? evt.target.parentElement.id : event.srcElement.parentElement.id;

    			if (targetName.indexOf("menu_") > -1) {
 		        	clickmenusub = targetName;
 		        	var tName = targetName.replace("menu_", "");
 		        	
 		            if (menuName != clickmenuName) {	 		                
 		                if (clickmenuPath != "") {
 		                	if (tName == clickmenuName) {
								clickmenuPath = clickmenuPath;
 		                	} else {
 		                		clickmenuPath = oldPath;	
 		                	}
						} else {
 		                	clickmenuPath = oldPath;
						}
 		                clickmenuName = targetName.split("menu_")[1];
 		            }
 		        }
			} */
			if (location === "main") {
                parent.document.querySelector("iframe[name=main]").src = url;
            } else {
				window.open(url, location, option);
			}
		}
		
		function OpenWindow2(targetid, url, location, option) {
			/* if (option != "") {
    			var width = 0, height = 0;
    			var leftPosition = "", topPosition = "";
    			var opt = option.split(',');
    			
    			for (var i = 0 ; i < opt.length ; i++) {
        			if (opt[i].indexOf('height') > -1) {
            			height = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
            			var top = (window.screen.height / 2) - ((height / 2) + 50);
            			topPosition = ", top=" + top + ", screenY=" + top;
        			}
        			
        			if (opt[i].indexOf('width') > -1) {
            			width = opt[i].substring(opt[i].indexOf('=') + 1, opt[i].indexOf('px'))
            			left = (window.screen.width / 2) - ((width / 2) + 10);
            			leftPosition = ", left=" + left + ", screenX=" + left;
        			}
    			}
    			option = option + topPosition + leftPosition;
			}

			if (targetid != "") {
    			clickmenusub = subPath;
    			if (menuName != clickmenuName) {
        			clickmenuPath = oldPath;
        			clickmenuName = menuName;
    			}
			} */
            if (location === "main") {
                parent.document.querySelector("iframe[name=main]").src = url;
            } else {
                window.open(url, location, option);
            }
		}
        
        function showProgress() {
		    document.getElementById("progressPanel").style.display = "block";
		    document.getElementById("progressPanel").style.opacity = 0.5;
		    document.getElementById("progressPanel").style.background = "rgba(0,0,0,0.7)";
		}
        
        function hideProgress() {
        	document.getElementById("progressPanel").style.display = "none";
        }
        
        function topMenuToggle(menu) {
        	switch (menu) {
	        	case "NewMail" : 
	        		//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
					break;						
				case "ApprG" : 	
					// 문서Type 선택 1=결재할문서 2=기안할문서  3=결재진행문서  4=수신문서처리(접수기)
					var listType;
					listType = 1;
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu04o(1).gif', document.getElementById("top_menu04(1)"));
					OpenWindow2('top_menu04(1)', "/ezApprovalG/apprGMain.do?listType=" + listType, "main", " ");
					break;
				case "Appr" : 		
					var listType;
					listType = 1;
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu04o(1).gif', document.getElementById("top_menu04(1)"));
	        		OpenWindow2('top_menu04(1)', "/ezApprovalG/apprMain.do?listType=" + listType, "main", " ");	
					break;
				// 표준모듈 (2007.03.23) 수정 : 메모보고 
				case "Memo" : 					
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
					break;
					
				case "Schedule" :
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu03o(8).gif', document.getElementById("top_menu03(4)"));
	        		OpenWindow2('top_menu03(4)', "/ezSchedule/scheduleIndex.do?funCode=2", "main", " ");
					break;
					
				case "Poll" :
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu05o.gif', document.getElementById("top_menu05"));
	        		OpenWindow2('top_menu05', "/ezBoard/boardMain.do?func=1", "main", " ");
					break;
					
				case "pollnum" : 
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu05o.gif', document.getElementById("top_menu05"));
					OpenWindow2('top_menu05', "/ezBoard/boardMain.do?func=1", "main", " ");
					break;
				
				case "Env" :
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
					break;
				case "My_Board" :
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
					break;
				case "Address" : 
					//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
					break;
			    case "ModInfo":
			    	//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezEmail/mailMain.do", "main", " ");
			        break; 
			    case "Circular":
			    	//img_onMouseOver('/files/upload_portal/S907000/Menu/top_menu02o.gif', document.getElementById("top_menu02"));
	        		OpenWindow2('top_menu02', "/ezCircular/circularIndex.do", "main", " ");
			        break; 
        	}
        }
        </script>
    </head>
            
	<body> 
        <div id="objectDiv"></div>
        <div id= 'top'>
            <header>
                <div class='logo'>
                    <img src='/files/upload_portal/S907000/Logo/logo.gif' width='106' height='45'>
                </div>
                <article class='utmenu'>
                    <ul>
                        <c:if test="${checkAdmin}">
                        	<li><img title="<spring:message code='ezResource.t106' />" style="cursor: pointer;" onclick='OpenWindow(event, "/admin/main.do", "", "")' src="/images/kr/main/admin.png"></li>
                        </c:if>
                        <li><img title="<spring:message code='ezPersonal.t210' />" style="cursor: pointer;" onclick='OpenWindow(event, "/ezPersonal/personSearch.do", "", "height=670px,width=880px, status = no, toolbar=no, menubar=no,location=no, resizable=0")' src="/images/kr/main/person.png"></li>
                        <li><img title="<spring:message code='ezPersonal.t999900011' />" style="cursor: pointer;" onclick='OpenWindow(event, "/ezPortal/environmentMain.do", "main", "")' src="/images/kr/main/env.png"></li>
						<li><img title="<spring:message code='main.t00037' />" style="cursor: pointer;" onclick='OpenWindow(event, "/ezNewPortal/help/index.do", "helpWindow", "height=800px,width=1560px, status = no, toolbar=no, menubar=no, location=no, resizable=1")' src="/images/kr/main/help.png"></li>
						<li><img title="<spring:message code='ezPortal.t990043' />" style="cursor: pointer;" onclick='top.location.href = "/user/login/actionLogout.do"' src="/images/kr/main/logout.png"></li>
                    </ul>
                </article>
                <div class='top_search'>
                	<input class="input_text" id="input_search" onmousedown="keyword_Clear(this);" onkeyup="Key_event(event);" onfocus="this.className='input_text focus'; " onblur="input_Onblur(this)" type="text"><input class="topsearch_btn" onclick="Emp_Search()" type="image" alt="" src="/images/kr/cm/top_search_btn.gif">
                </div>
            </header>
            <nav>
                <ul class='topmenu'>                    
                    <li id="09e1d12c-5ffd-4240-8791-020431a5c47b" onmouseover="img_onMouseOver(this);" onmouseout="img_onMouseOut(this);" onclick='OpenWindow(event, "/ezEmail/mailMain.do", "main", " ")'><spring:message code='main.t78' /></li>
                    <c:if test="${packageType == 'basic'}">
                    	<li id="6cdb78b7-ae72-48ce-990f-5c0f6838fbbc" onmouseover="img_onMouseOver(this);" onmouseout="img_onMouseOut(this);" onclick='OpenWindow(event, "/ezSchedule/scheduleIndex.do?funCode=2", "main", " ")'><spring:message code='main.t14' /></li>
                    	<li id="1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d" onmouseover="img_onMouseOver(this);" onmouseout="img_onMouseOut(this);" onclick='OpenWindow(event, "/ezBoard/boardMain.do", "main", " ")'><spring:message code='ezBoard.t0006' /></li>
                    </c:if>                                                                                                                                                                                
                </ul>
            </nav> 
            <div class="topSubMenu">
                <ul id="menu_1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d" style="left: 875px; top: 0px; width: 111px; display: none;" onmouseover="submenuover(this)" onmouseout="submenuout(this)">
					<li class="left">
					<li onclick="OpenWindow(event, '/ezBoard/boardMain.do', 'main', ' ')"><spring:message code='ezBoard.t00010' /></li>
					<li onclick="OpenWindow(event, '/ezBoard/boardMain.do?subFunc=1', 'main', ' ')"><spring:message code='ezBoard.t10032' /></li>
					<li onclick="OpenWindow(event, '/ezBoard/boardMain.do?subFunc=2', 'main', ' ')"><spring:message code='ezBoard.t229' /></li>
					<li onclick="OpenWindow(event, '/ezBoard/boardMain.do?func=1', 'main', ' ')"><spring:message code='ezBoard.t365' /></li>
					<li onclick="OpenWindow(event, '/ezBoard/boardMain.do?func=3', 'main', ' ')"><spring:message code='ezBoard.t371' /></li>
					<li class="right"></li>
				</ul>
				<ul id="menu_6cdb78b7-ae72-48ce-990f-5c0f6838fbbc" style="left: 619px; top: 0px; width: 128px; display: none;" onmouseover="submenuover(this)" onmouseout="submenuout(this)">
					<li class="left">
					<li onclick="OpenWindow(event, '/ezSchedule/scheduleIndex.do?funCode=2', 'main', '')"><spring:message code='ezSchedule.t1010' /></li>
					<li onclick="OpenWindow(event, '/ezSchedule/scheduleIndex.do?funCode=3', 'main', ' ')"><spring:message code='ezSchedule.t1011' /></li>
					<li class="right"></li>
				</ul>
				<ul id="menu_09e1d12c-5ffd-4240-8791-020431a5c47b" style="left: 525px; top: 0px; width: 94px; display: none;" onmouseover="submenuover(this)" onmouseout="submenuout(this)">
					<li class="left">
					<li onclick="OpenWindow(event, '/ezEmail/mailMain.do?funCode=1', 'main', ' ')"><spring:message code='main.t78' /></li>
					<li onclick="OpenWindow(event, '/ezEmail/mailMain.do?funCode=2', 'main', ' ')"><spring:message code='main.t205' /></li>
					<li class="right"></li>
				</ul>
			</div>
        </div>
                       
		<div id="objectProgressDiv"></div>
		
		<iframe id="ifmpopup" src="" style="display: none;"></iframe>
		<div id="progressPanel" style="left: 0px; top: 0px; width: 100%; height: 100%; display: none; position: absolute; z-index: 1000;">&nbsp;</div>
	
	</body>
</html>
