<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>popupCommHome</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style>
			.btype_list ul li .date {
				-webkit-margin-start:20px;
			}
			/* ellipisis 추가 */
			.node_normal {
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:135px;
	    	}
	    	.node_selected {
	    		overflow:hidden;
	    		text-overflow:ellipsis;
	    		display:inline-block;
	    		width:135px;
	    	}
	    	#treediv div.tree {
	    		overflow-x:hidden;
	    		overflow-y:auto;
	    	}
			.admin_menu {
				width:100px;
			}
			#totalSearch {
				margin: auto;
				color: white;
				background: black;
				width: 40px;
				height: 25px;
				display: flex;
				justify-content: center;
				align-items: center;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
		<script type="text/javascript">
			var primary = "<c:out value='${primary}'/>";
			var xmlDomTreeView = createXmlDom();
			var treedate = "${retXML }";
			var code = "<c:out value='${code }'/>";
			var userLevel = "<c:out value='${userLevel }'/>";
			var chCheckSysop = "<c:out value='${checkSysop }'/>";
			var newMemberConfirmType = "<c:out value='${newMemberConfirmType }'/>";
			var joinFlag = "<c:out value='${joinFlag }'/>";
			var pastDate = "<c:out value = '${pastDate}' />";
			var xmlhttp;
			var lang = "<c:out value='${lang}'/>";
			
			var strLang1 = "<spring:message code='ezCommunity.t78' />";
		    var strLang2 = "<spring:message code='ezCommunity.t1082' />"; 
		    var strLang3 = "<spring:message code='ezCommunity.t1103' />"; 
		    var strLang4 = "<spring:message code='ezCommunity.t2009' />"; 
		    var strLang5 = "<spring:message code='ezCommunity.t1102' />"; 
		    var strLang6 =  "<spring:message code='ezCommunity.t431' />";
		    //2018-07-24 김보미
		    var strLang7 =  "<spring:message code='ezCommunity.kbm01' />";
		    
		    $(function () {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezCommunity/commHome/commHomeInfo.do",
					data : { code : code
					},
					success: function(result){
						event_get_commhomeinfo(result);
					}
				});
		        
		        getCommhomeBoardInfo();

		        var treedom = loadXMLString(treedate);
		        
		        if (SelectNodes(treedom, "TREEVIEWDATA/NODE").length > 0) {
		            for (var i = 0; i < SelectNodes(treedom, "TREEVIEWDATA/NODE").length; i++) {
		                var h2 = document.createElement("H2");
		                var span = document.createElement("SPAN");
		                /*var img = document.createElement("IMG");
		                img.src = "/images/kr/community/type1/icon_board.gif";
		                img.style.width = "16px";
		                img.style.height = "16px";
		                span.appendChild(img);*/
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
		                document.getElementById("treediv").appendChild(h2);
		                document.getElementById("treediv").appendChild(div);
		            }
		        }
		    });
		    
		    function getCommhomeBoardInfo() {
		    	$.ajax({
					type : "GET",
					dataType : "json",
// 					async : true,
					url : "/ezCommunity/commHome/commHomeBoardInfo.do",
					data : { code : code},
					success : function(result) {
						if (result.boardInfoList.length > 0) {
							document.getElementById("mainboard").style.display = "";
			                document.getElementById("makeguide").style.display = "none";
			                
			                var div = document.createElement("div");
		                    div.className = "board_area";
		                    
			                result.boardInfoList.forEach(function(infoVO, index) {
			                	var div2 = document.createElement("div");
			                	
			                	if (infoVO.showPosition == "1") {
			                		if (infoVO.gubun != "3") {
			                			div2.className = "f_left btype_list";
			                		} else {
			                			div2.className = "f_left btype_photo";
			                		}
			                	} else if (infoVO.showPosition == "2"){
			                		if (infoVO.gubun != "3") {
			                			div2.className = "f_right btype_list";
			                		} else {
			                			div2.className = "f_right btype_photo";
			                		}
			                	}
			                	
								var p = document.createElement("P");
	                            p.className = "title";
	                            
	                            /* 2020-06-24 홍승비 - 커뮤니티 팝업홈 홈 메인 표출 게시판 특수문자 처리 */
	                            if (primary == "1") {
	                                p.innerHTML= "<img src='/images/kr/community/type1/icon_board_big.gif' style='width:16px; height:16px; padding-right:5px; vertical-align:middle' />" + MakeXMLString(length_check(infoVO.boardName));
	                            } else {
	                            	p.innerHTML= "<img src='/images/kr/community/type1/icon_board_big.gif' style='width:16px; height:16px; padding-right:5px;vertical-align:middle' />" + MakeXMLString(length_check(infoVO.boardName2));
	                            }
	                            
	                            var span = document.createElement("span");
	                            span.className = "more";
	                            span.setAttribute("boardid", infoVO.boardID);
	                            span.setAttribute("boardname", infoVO.boardName);
	                            span.setAttribute("gubun", infoVO.gubun);
	                            span.onclick = function () { moreclick(this); };

	                            var img = document.createElement("img");
	                            img.src = "/images/kr/community/type1/btn_more.gif";
	                            img.style.width = "40px";
	                            img.style.height = "16px";

	                            span.appendChild(img);
	                            p.appendChild(span);

	                            var ul = document.createElement("ul");
	                            $.ajax({
	            					type : "GET",
	            					dataType : "text",
// 	            				async : true,
	            					url : "/ezCommunity/commHome/commHomeBoardItemList.do",
	            					data : { boardID   : infoVO.boardID
	            					},
	            					dataType : "json",
	            					success: function(result){
	            						var imageCnt = 0;
	            						result.boardItemList.forEach(function(itemVO, index) {
	            							var li = document.createElement("li");

		                                    var span2 = document.createElement("span");
		                                    var span3 = document.createElement("span");
		                                    
		                                    if (itemVO.gubun != "3") {
		                                    	span2.className = "txt";
		                                    	/* 2018-05-18 홍승비 - 커뮤니티 팝업홈 메인화면 일반/그룹/익명게시물 new 표시 */
		                                    	if (pastDate <= itemVO.writeDate) {
		                                    		span2.innerHTML = "<img src='/images/i_new.gif' style='margin-bottom:1px;'>&nbsp;";
                   		 						}
		                                    	/* 2019-02-21 홍승비 - 커뮤니티 팝업홈 메인화면 일반/그룹/익명게시물명 특문처리 */
		                                        span2.innerHTML += MakeXMLString(itemVO.title);
		                                        
		                                        /* 2018-05-04 홍승비 - 댓글수 표출 */
		                                        if (itemVO.oneLineCnt > 0) {
		                                        	span2.innerHTML += ("<SPAN style='color:#c64200'> [" + itemVO.oneLineCnt + "]</SPAN>");
		                                        }
		                                        
		                                        span2.setAttribute("itemid", itemVO.itemID);
		                                        span2.setAttribute("boardid", itemVO.boardID);
		                                        span2.setAttribute("gubun", itemVO.gubun);
		                                        span2.setAttribute("code", code);
		                                        span2.style.cursor = "pointer";
		                                        span2.onclick = function () { ItemRead_onclick(this); };

		                                        span3.className = "date";
		                                        span3.innerHTML = itemVO.writeDate.substring(0, 10);
		                                    } else {
		                                    	if (imageCnt < 4) {
		                                    		span2.className = "photo";
			                                        span2.setAttribute("itemid", itemVO.itemID);
			                                        span2.setAttribute("boardid", itemVO.boardID);
			                                        span2.setAttribute("gubun", itemVO.gubun);
			                                        span2.setAttribute("code", code);
			                                        span2.style.cursor = "pointer";
			                                        span2.onclick = function () { ItemRead_onclick(this); };

			                                        var img = document.createElement("IMG");
			                                        var imgUrl = itemVO.extensionAttribute5;
			                                        
			                                        /* 2018-05-04 홍승비 - 커뮤니티 팝업홈 메인화면 포토게시물 사진경로 수정 */
			                                        imgUrl = imgUrl.replace(/{/gi,"%7B").replace(/}/gi,"%7D");
			                                        img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYBOARD&boardID=" + encodeURIComponent(itemVO.boardID) + "&fileName=" + imgUrl;
			                                        img.style.width = "68px";
			                                        img.style.height = "68px";

			                                        span2.appendChild(img);
			                                        span3.className = "ptxt";
			                                        /* 2018-05-18 홍승비 - new 표시 */
			                                        if (pastDate <= itemVO.writeDate) {
			                                    		span3.innerHTML = "<img src='/images/new_icon.gif'>&nbsp;";
	                   		 						}
			                                        /* 2019-02-21 홍승비 - 커뮤니티 팝업홈 메인화면 포토게시물명 특문처리 */
			                                        span3.innerHTML += MakeXMLString(itemVO.title);
			                                        /* 2018-05-07 홍승비 - 댓글수 표출 */
			                                        if (itemVO.oneLineCnt > 0) {
			                                        	span3.innerHTML += ("<SPAN style='color:#c64200'> [" + itemVO.oneLineCnt + "]</SPAN>");
			                                        }
			                                        
			                                        span3.setAttribute("itemid", itemVO.itemID);
			                                        span3.setAttribute("boardid", itemVO.boardID);
			                                        span3.setAttribute("gubun", itemVO.gubun);
			                                        span3.setAttribute("code", code);
			                                        span3.onclick = function () { ItemRead_onclick(this); };
			                                        imageCnt++;
		                                    	}
		                                    }
		                                    
		                                    li.appendChild(span2);
		                                    li.appendChild(span3);
		                                    ul.appendChild(li);
	            						});
	            					}
	            				});
	                            
                                div2.appendChild(p);
                                div2.appendChild(ul);
                                div.appendChild(div2);
                                document.getElementById("mainboard").appendChild(div);
			                })
						} else {
							document.getElementById("makeguide").style.display = "";
						}
					}
				});
		    }
		    	    
		    function event_get_commhomeinfo(result) {
	            var xmldom = loadXMLString(result);
	            
	            var _img = document.createElement("img");
	            _img.id = "coplogo";
	            _img.style.width = "1200px";
	            _img.style.height = "100px";

	            if (SelectSingleNodeValueNew(xmldom, "DATA/C_LOGO").indexOf("default_logo_type") > -1) {
	                _img.src = "/images/ezCommunity/logo/" + SelectSingleNodeValueNew(xmldom, "DATA/C_LOGO");
	                //document.getElementById("coplogo").src = "/images/default_logo.jpg";
	            } else {
	                _img.src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" +  SelectSingleNodeValueNew(xmldom, "DATA/C_LOGO");
	            }
	            
	            document.getElementById("homeimg").appendChild(_img);

	            if (primary == "1") {
	                document.getElementById("copname").innerHTML = MakeXMLString(SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME"));
	                document.title = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME");
	            } else {
	                document.getElementById("copname").innerHTML = MakeXMLString(SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME2"));
	                document.title = SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBNAME2");
	            }

	            document.getElementById("mastericon").onclick = function () { openInfo(SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/USERID")); };
	            document.getElementById("mastername").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/USERNAME");
	            document.getElementById("master").innerHTML += "(" + SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/DEPTNAME") + ")";
	            
	            /* 2019-07-11 홍승비 - 일본어 환경에서 메세지 표출 일부 수정(생성일) */
	            if (lang == "3") {
	            	document.getElementById("regdate").innerHTML =  strLang1 + "：" + SelectSingleNodeValueNew(xmldom, "DATA/C_REGDATE").substring(0, 10);
	            } else {
	            	document.getElementById("regdate").innerHTML =  strLang1 + ": " + SelectSingleNodeValueNew(xmldom, "DATA/C_REGDATE").substring(0, 10);
	            }
	            
	            document.getElementById("membercnt").innerHTML =  SelectSingleNodeValueNew(xmldom, "DATA/C_MEMBERCNT");
	            //2018-07-11 김보미 - 공백 조정
	            countSpanPadding(document.getElementById("membercnt"), SelectSingleNodeValueNew(xmldom, "DATA/C_MEMBERCNT"));
	            document.getElementById("itemcnt").innerHTML = SelectSingleNodeValueNew(xmldom, "DATA/ITEMCNT");
	            //2018-07-11 김보미 - 공백 조정
	            countSpanPadding(document.getElementById("itemcnt"), SelectSingleNodeValueNew(xmldom, "DATA/ITEMCNT"));
	            
	            var userImage = SelectSingleNodeValueNew(xmldom, "DATA/MEMBER/USERIMAGE").trim();

	            var _img = document.createElement("img");

	            if (userImage != "") {
	                _img.src = "/admin/ezOrgan/getPersonalInfo.do?type=PERSONAL&fileName=" + userImage;
	            } else {
// 	                _img.src = "/images/OrganTree/porson_noimg.gif";
	                _img.src = "<spring:message code='main.e14' />";
	            }
	            
	            _img.style.width = "48px";
	            _img.style.height = "48px";

	            document.getElementById("pic").appendChild(_img);
				var sConfirmType = "";
				
	            switch (SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBCONFIRMTYPE").trim()) {
	                case "2":
	                    sConfirmType = "<spring:message code='ezCommunity.t699' />";
	                break;
	            case "3":
	                sConfirmType = "<spring:message code='ezCommunity.t14' />";
	                break;
	        	}
	            
	            /* 2019-07-11 홍승비 - 일본어 환경에서 메세지 표출 일부 수정(공개설정, 승인여부) */
	            var langBR = "";
	            if (lang == "3") {
	            	langBR = "<br>";
	            }
	        	switch (SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBGUBUN").trim()) {
		            case "1":
		                document.getElementById("cpublic").innerHTML = "<spring:message code='ezCommunity.t700' />" + "<spring:message code='ezCommunity.t701' />";
		                break;
		            case "2":
		                document.getElementById("cpublic").innerHTML = "<spring:message code='ezCommunity.t700' />" + "<spring:message code='ezCommunity.t702' />" + langBR + sConfirmType;
		                break;
		            case "3":
		                document.getElementById("cpublic").innerHTML = "<spring:message code='ezCommunity.t700' />" + "<spring:message code='ezCommunity.t703' />" + langBR + sConfirmType;
		                break;
	        	}
	        	
	        	document.getElementById("copdesc").innerHTML = MakeXMLString(SelectSingleNodeValueNew(xmldom, "DATA/C_CLUBDESC"));

		    }
		    
		    function openInfo(userid) {
		        var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=450";
		        feature = feature + GetOpenPosition(420, 450);
				window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", feature);
		    }
		    
		    var tempboard = "";
		    function TopBoard_onclick(val) {
		        if (tempmenuid != "") {
		            document.getElementById(tempmenuid).className = "off";
		        }
		        
		        tempmenuid = "";
		        
		        if (tempboard != "" && val.id != tempboard.id) {
		            tempboard.className = "off";
		            document.getElementById(tempboard.getAttribute("TreeCtrl") + "obj").style.display = "none";
		        }
		        
		        var obj = val.getAttribute("TreeCtrl");
		        var ID = val.id;
		        
		        if (val.className == "on") {
		            val.className = "off";
		            document.getElementById(obj + "obj").style.display = "none";
		        } else {
		            val.className = "on";
		            document.getElementById(obj + "obj").style.display = "";
		        }
		        
		        tempboard = val;
		        document.getElementById(obj + "obj").innerHTML = "";
		        SetTreeConfig();
		        var treeView = new TreeView();
		        treeView.SetID("TreeView" + obj);
		        treeView.SetRequestData("TreeCtrl_onNodeExpanded");
		        treeView.SetNodeClick("TreeCtrl_onNodeClick");
		        treeView.DataSource(GetSubBoard(ID, "1"));
		        treeView.DataBind(obj + "obj");
		        
		        applyEllipsis();
		        applyIsNewIconAll();
		    }
		    
		    function SetTreeConfig() {
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("GET", "/xml/ezCommunity/organtree_config2.xml", false);
		        xmlhttp.send();

		        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlhttp.responseXML);
		        }
		    }
		    
		    function GetSubBoard(pRootBoardID, pSubFlag) {
		    	var returnVal = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		async : false,
					url : "/ezCommunity/getSubBoards.do",
					dataType : "json",
					data : {	rootBoardID : pRootBoardID,
								subFlag : pSubFlag,
								selectFlag : 0,
								classID : code
							},
					success: function(result){
						returnVal = loadXMLString(result.result);
					}
		    	});
		    	
		        return returnVal;
		    }
		    
		    function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
		        var xmlRtn = createXmlDom();
		        var TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        xmlRtn = GetSubBoard(treeNode.GetNodeData("DATA1"), "1")

		        var treeView = new TreeView();
		        treeView.LoadFromID(pTreeID);
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		        
		        applyEllipsis();
		        applyIsNewIconAll();
		    }
		    
		    function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
		        try {
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(pNodeID);
		            
		            var SelectedBoardID = treeNode.GetNodeData("DATA1");
		            var SelectedBoardParentBoardID = treeNode.GetNodeData("DATA3");
		            var chkPhotoBrd = treeNode.GetNodeData("DATA6")
		            document.getElementById("copmaindesc").style.display = "none";
		            document.getElementById("rightfrm").style.display = "";
		            document.getElementById("mainboard").style.display = "none";
		            document.getElementById("makeguide").style.display = "none";
		            
		            //2018-07-02 김보미 - 클릭시 색 변경 안되게
			        var SelectedNodeID = treeNode.GetNodeData("id");
		            var boardColor = treeNode.GetNodeData("DATA4");
		            if (boardColor != "" && boardColor != null) {
		                var objSpan = document.getElementById("spn_" + SelectedNodeID);
		                if(CrossYN())
		                    objSpan.setAttribute("style", "color:" + boardColor);
		                else
		                    objSpan.style.color = boardColor;
		            }
		            
		            applyEllipsis();
		            applyIsNewIconAll();
		            
		            document.getElementById("rightfrm").style.height = "659px";
		            if (chkPhotoBrd != "3") {
		            	//2018-07-13 김보미 - 파라메터 추가
// 		                document.getElementById("rightfrm").src = "/ezCommunity/boardItemList.do?boardID=" + encodeURIComponent(treeNode.GetNodeData("DATA1")) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&code=" + code;
		                document.getElementById("rightfrm").src = "/ezCommunity/boardItemList.do?boardID=" + encodeURIComponent(treeNode.GetNodeData("DATA1")) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&code=" + code + "&treeCtrl=" + SelectedNodeID;
		            } else {
		                document.getElementById("rightfrm").src = "/ezCommunity/boardItemListPhoto.do?boardID=" + encodeURIComponent(treeNode.GetNodeData("DATA1")) + "&boardName=" + encodeURIComponent(treeNode.GetNodeData("DATA2")) + "&code=" + code;
		            }
		            
		            if (CrossYN()) {
		            }
		            else {
		                window.event.cancelBubble = true;
		                window.event.returnValue = false;
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    
		    var tempmenuid = "";
		    function go_menu(btn) {
		    	if (tempboard != "") {
		    		document.getElementById(tempboard.getAttribute("TreeCtrl") + "obj").style.display = "none";
		    	}
		    	
		    	/* 2019-10-24 홍승비 - 커뮤니티 팝업홈 중 좌측메뉴가 게시판이 아닌 경우, 동일 메뉴 클릭 시 하이라이트 유지 */
		        if (userLevel == "0" || userLevel == "9") {
		            switch (btn.id) {
		                case "btn_QsPoll": document.getElementById("rightfrm").src = "/ezCommunity/pollMain.do?code=" + code + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_QsPoll") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberInfo": alert(strLang6);
		                    break;
		                case "btn_MemberOut": alert(strLang5);
		                    break;
		                case "btn_home": document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_home") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_guest": document.getElementById("rightfrm").src = "/ezCommunity/guestOne.do?code=" + code, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_guest") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberIn":
		                    if (joinFlag.toUpperCase() == "TRUE") {
		                        alert(strLang2);
		                        return;
		                    }
		                    
		                    var wWeight = "330";
		                    var wHeight = "197";
		                    var heigth = window.screen.availHeight;
		                    var width = window.screen.availWidth;
		                    var left = (width - wWeight) / 2;
		                    var top = (heigth - wHeight) / 2;
		                    
		                    if (newMemberConfirmType == "2") {
		                        window.open("/ezCommunity/join1.do?no=" + code, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    } else if (newMemberConfirmType == "3") {
		                        window.open("/ezCommunity/join2.do?no=" + code, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    }
		                    
		                    break;
		                case "btn_MemberJoinIng":
		                    alert(strLang7);
		                    break;
		                case "btn_Manager_home1": open_admin_home(code, "2");
		                    break;
		                case "btn_Manager_home2": open_admin_home(code, "10");
		                    break;
		                default: document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		            }
		        } else {
		            switch (btn.id) {
		                case "btn_QsPoll": document.getElementById("rightfrm").src = "/ezCommunity/pollMain.do?code=" + code + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_QsPoll") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberInfo": document.getElementById("rightfrm").src = "/ezCommunity/commViewMember.do?code=" + code, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_MemberInfo") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberOut":
		                    if (chCheckSysop.toUpperCase() == "TRUE") {
		                        alert(strLang3);
		                    } else {
		                        go_MemberOut(code);
		                    }
		                    
		                    break;
		                case "btn_Manager": open_admin(code);
		                    break;
		                case "btn_Manager_home1": open_admin_home(code,"2");
		                    break;
		                case "btn_Manager_home2": open_admin_home(code,"10");
		                    break;
		                case "btn_home": document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_home") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_guest": document.getElementById("rightfrm").src = "/ezCommunity/guestOne.do?code=" + code, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "" && tempmenuid != "btn_guest") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		                case "btn_MemberIn":
		                    if (joinFlag.toUpperCase() == "TRUE") {
		                        alert(strLang2);
		                        return;
		                    }
		                    
		                    var wWeight = "330";
		                    var wHeight = "197";
		                    var height = window.screen.availHeight;
		                    var width = window.screen.availWidth;
		                    var left = (width - wWeight) / 2;
		                    var top = (height - wHeight) / 2;
		                    
		                    if (newMemberConfirmType == "2") {
		                        window.open("/ezCommunity/join1.do?no=" + code, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    } else if (newMemberConfirmType == "3") {
		                        window.open("/ezCommunity/join2.do?no=" + code, "", "location=0,toolbar=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		                    }
		                    
		                    break;
		                case "btn_MemberJoinIng":
		                    alert(strLang7);
		                    break;
		                default: document.getElementById("rightfrm").src = "/ezCommunity/commHome/commHome.do?code=" + code + "&userLevel=" + userLevel, "right";
		                    tempboard.className = "off";
		                    tempboard = "";
		                    document.getElementById(btn.id).className = "on";
		                    
		                    if (tempmenuid != "") {
		                        document.getElementById(tempmenuid).className = "off";
		                    }
		                    
		                    tempmenuid = btn.id;
		                    document.getElementById("copmaindesc").style.display = "none";
		                    document.getElementById("rightfrm").style.display = "";
		                    document.getElementById("rightfrm").style.height = "659px";
		                    document.getElementById("mainboard").style.display = "none";
		                    document.getElementById("makeguide").style.display = "none";
		                    break;
		            }
		        }
		    }
		    
		    function go_MemberOut(code) {
		    	$.ajax({
		    		type : "POST",
		    		url : "/ezCommunity/goAdminOk.do",
		    		async : false,
		    		data : {code : code},
		    		success: function (result) {
		    			resultXML = loadXMLString(result);
		    			
		    			var master = "";
		    			master = SelectSingleNodeValue(SelectNodes(resultXML, "COMMUNITY/MASTER")[0], "VALUE");
		    			
				        if (master == null) {
				        	master = "";
				        }
				        
				        master = master.toLowerCase();
				        userID = "<c:out value='${userInfo.id }'/>";
				        userID = userID.toLowerCase();

				        try {
				            if (userID == master) {
				                alert("Community <spring:message code='ezCommunity.t1103' />");
				            } else {
				            	//2018-07-09  김보미 - 너비값 조정
 				                //var wWeight = "425";
				                var wWeight = "475";
				                var wHeight = "395";
				                var heigth = window.screen.availHeight;
				                var width = window.screen.availWidth;
				                var left = (width - wWeight) / 2;
				                var top = (heigth - wHeight) / 2;

				                var Para = window.open("/ezCommunity/commOut.do?code=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
				            }
				        } catch (e) { }
		    		}
		    	});
		    }
		    
		    function open_admin(code) {
		        var wWeight = "860";
		        var wHeight = "567";
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - wWeight) / 2;
		        var top = (heigth - wHeight) / 2;

		        var comm = window.open("/ezCommunity/admin/index.do?code=" + code, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		    }

		    function open_admin_home(code, num) {
		        if (chCheckSysop.toUpperCase() == "FALSE") {
		            alert(strLang4);
		            return;
		        }
		        var wWeight = "860";
		        var wHeight = "510";
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - wWeight) / 2;
		        var top = (heigth - wHeight) / 2;

		        var comm = window.open("/ezCommunity/admin/index.do?code=" + code + "&num=" + num, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
		    }
		    
		    function ItemRead_onclick(val) {
		    	if (userLevel == "0" || userLevel == "9") {
    				alert("<spring:message code='ezCommunity.t899' />");
    				return;
    			}
		    	
		        var pItemID = val.getAttribute("itemid");
		        var pItemBoardID = val.getAttribute("boardid");
		        var gubun = val.getAttribute("gubun");
		        var copno = val.getAttribute("code");

		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;

		        if (gubun == "3") {
		        	GetOpenWindow("/ezCommunity/boardItemViewPhoto.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1, "", 750, 721);
		        } else {
		        	GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(pItemID) + "&boardID=" + encodeURIComponent(pItemBoardID) + "&code=" + encodeURIComponent(copno) + "&showAdjacent=" + 1, "", 750, 721);
		        }
		    }

		    function moreclick(val) {
		        var selectedBoardID = val.getAttribute("boardid");
		        var chkPhotoBrd = val.getAttribute("gubun");
		        var boardName = val.getAttribute("boardname");
		        document.getElementById("copmaindesc").style.display = "none";
		        document.getElementById("rightfrm").style.display = "";
		        document.getElementById("mainboard").style.display = "none";
		        document.getElementById("makeguide").style.display = "none";
		        document.getElementById("rightfrm").style.height = "659px";
		        if (chkPhotoBrd != "3") {
		            document.getElementById("rightfrm").src = "/ezCommunity/boardItemList.do?boardID=" + encodeURIComponent(selectedBoardID) + "&boardName=" + encodeURIComponent(boardName) + "&code=" + code;
		        } else {
		            document.getElementById("rightfrm").src = "/ezCommunity/boardItemListPhoto.do?boardID=" + encodeURIComponent(selectedBoardID) + "&boardName=" + encodeURIComponent(boardName) + "&code=" + code;
		        }
		        
		        if (CrossYN()) {
		        } else {
		            window.event.cancelBubble = true;
		            window.event.returnValue = false;
		        }
		    }
		    
		    function reload() {
		        window.location.reload();
		    }
		    
		    // 2018-02-13 천성준
		    function length_check(txt) {
		    	var temp = txt;
		    	// 커뮤니티 팝업 메인화면 게시판 이름이 22자를 넘길시 자르고 뒤에...을 붙인다.
		    	if(temp.length >= 22) {
		    		temp = temp.substring(0,22)+"...";
		    		return temp;
		    	}else{
		    		return temp;
		    	}
		    }
		    
		    /* 2018-05-11 홍승비 - 팝업홈 메인에서 글 삭제할 경우 새로고침 동작 */
		    function refresh_onclick() {
	            window.location.reload();
	        }
		    
//		    window.onload = function(){
		    	/* 2018-05-21 홍승비 - IE와 크롬에서 게시물 등록일 표시 동일하게 조정 */
//		    	if (navigator.userAgent.toLowerCase().indexOf("chrome") > -1) {
//		    		console.log("크롬이에요!");
//		    		$(".date").css('margin-left', '20px');
//		    	}	    	
//		    }

			//2018-07-11 김보미 - 공백 조정
			function countSpanPadding(elem, cnt) {
	            if (cnt.length == 1) {
	            	elem.style.paddingLeft = "30px";
	            } else if (cnt.length == 2) {
	            	elem.style.paddingLeft = "22px";
	            } else if (cnt.length == 3) {
	            	elem.style.paddingLeft = "16px";
	            } else if (cnt.length == 4) {
	            	elem.style.paddingLeft = "12px";
	            }
			}
			
	        /**
	        	게시판 트리 view  ellipsis 추가.
	        	박종균
	        */
	        function applyEllipsis() {
	        	
	        	//nodelevel 값을 가져와서 처리한다.
	        	$(".node_div").each(function(index, element){
	        		var nodelevel = $(element).attr("nodelevel");
	        		var title = $(element).attr("nodename");
	        		var nodeId = $(element).attr("id");
	        		
	        		$("#spn_"+nodeId).attr("title", title);
	        		
	        		if (nodelevel > 0) {
	        			var customWidth = 135 - (18 * nodelevel);
	        			if (customWidth < 0) {
	        				customWidth = 0;
	        			}
	        			$("#spn_"+nodeId).css("width", customWidth+"px");
	        		}
	        	});
	        }
	        
	        /* 2021-11-09 홍승비 - 커뮤니티 게시판에 자신이 읽지 않은 신규 게시물 존재 여부를 표출 ('N' 아이콘) */
	        function applyIsNewIconAll() {
	        	var onH2 = $("h2.on"); // 현재 열려있는 하위게시판들에 대해 신규 게시물 존재 여부를 체크
	        	
	        	if (onH2.length > 0) {
	        		$("#" + onH2.attr("treectrl") + "obj").find(".node_div").each(function(index, element) {
		        		var boardID = $(element).attr("data1");
		        		var nodeID = $(element).attr("id");
		        		var spanNodeID = "spn_" + nodeID;
		        		var spanImgNodeID = "img_" + nodeID;
		        		
		        		$.ajax({
				    		type : "GET",
				    		url : "/ezCommunity/getIsNewItemExists.do",
				    		async : true,
				    		data : {
				    			boardID : boardID
				    		},
				    		success: function (result) { // Y, N
				    			if (result == "Y" && $("#" + spanImgNodeID).length < 1) { // 게시판명 span 영역에 아이콘 추가 또는 제거
				    				$("#" + spanNodeID).append(" <img id='" + spanImgNodeID + "' src='/images/kr/community/communityPortlet_iconnew.gif' style='vertical-align:top; margin-top: 6px'>");
				    			} else if (result != "Y" && $("#" + spanImgNodeID).length > 0) {
				    				$("#" + spanImgNodeID).remove();
				    			}
				    		}
				    	});
		        	});
		        }
	        }
	        
			function commuTotalSearch() {
				var searchWord = document.getElementById("searchWord").value;
				
				if (searchWord.trim().length < 1) {
					alert("<spring:message code='ezCommunity.t504'/>");
					return;
				}
				
				document.getElementById("copmaindesc").style.display = "none";
				document.getElementById("rightfrm").style.display = "";
				document.getElementById("mainboard").style.display = "none";
				document.getElementById("makeguide").style.display = "none";
				
				// 2024-10-17 조수빈 - 왼쪽 메뉴 중 열려있는 메뉴가 있다면 닫기
				var leftMenus = document.getElementById("left");
				var openMenus = leftMenus.getElementsByClassName('on');
				
				if (openMenus[i]) {
					for (var i = 0; i < openMenus.length; i++) {
						if (openMenus[i]) {
							openMenus[i].click();
							openMenus[i].className = "off";
						}
					}
				}
				
				document.getElementById("totalSearchForm").submit();
				document.getElementById("searchWord").value = "";
			}
		</script>
	</head>
	
	<body class="cmhomebg_<c:out value='${copType }'/>">
		<div id ="cmhome_<c:out value='${copType }'/>">
			<div class="cmhome_top" onclick="reload()" style="cursor:pointer;">
   	  			<div class="homeimg" id="homeimg"></div>   	  
      			<h1 id="copname" class="homename"></h1>
			</div>
			<div class="cmhome_left">
        		<div class="info">
            		<div class="info_box">
            			<p class="pic" id="pic"></p>
                		<div class="master">
                    
	                    <c:choose>
	                    	<c:when test="${userInfo.lang != '3' }">
	                    		<span class="icon_gray"><span id="mastericon"><spring:message code='ezCommunity.t9' /></span></span>
	                    	</c:when>
	                    	<c:otherwise>
	                    		<span class="icon_gray"><span id="mastericon" style="font-size:7pt; line-height: 15px;"><spring:message code='ezCommunity.t9' /></span></span>		
	                    	</c:otherwise>
	                    </c:choose>
                    
		                    <p style="height:18px;"><strong id="mastername" style="width:93px; display:inline-block; text-overflow:ellipsis; white-space: nowrap; overflow:hidden;"></strong></p>
		                    <p id="master" style="width:93px; display:inline-block; text-overflow:ellipsis; white-space: nowrap; overflow:hidden;"></p>
		                </div>
		                
		                <c:if test="${checkSysop }">
		                	<div class="admin_menu" style="height:auto;width: auto;"><span id="btn_Manager" onclick ="go_menu(this)"><spring:message code='ezCommunity.t565' /></span></div>
		                </c:if>
		                
		            </div>
		            
		            <ul class="info_count">
		        		<li class="icon_member"><span class="txt"><spring:message code="ezCommunity.design02"/></span><span class="count" id="membercnt"></span></li>
		         		<li class="icon_board"><span class="txt"><spring:message code="ezCommunity.design01"/></span><span class="count" id="itemcnt"></span></li>
		          	</ul>
		            <ul class="info_list">
			            <li id="regdate"></li>
			            <li id="cpublic"></li>
		            </ul>

					<c:choose>
						<c:when test="${userLevel == '0' && joinFlag && newMemberConfirmType == 3 }">
							<div id="btn_MemberJoinIng" class="btn_join" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_rcheck.gif" width="20" height="17"><spring:message code='ezCommunity.t1080' /></div>
						</c:when>
						<c:when test="${userLevel == '0' || userLevel =='9' }">
							<div id="btn_MemberIn" class="btn_join" onclick ="go_menu(this)"><img src="/images/kr/community/type1/icon_rcheck.gif" width="20" height="17"><spring:message code='ezCommunity.t1080' /></div>
						</c:when>
					</c:choose>
				
        		</div>
       			<div id="left" class="leftmenu">
        			<div id="treediv">
        			</div>
         			<h3 id="btn_guest" onclick ="go_menu(this)"><spring:message code='ezCommunity.t570' /></h3>
         			<h3 id="btn_QsPoll" onclick ="go_menu(this)"><spring:message code='ezCommunity.t598' /></h3>
         			<h3 id="btn_MemberInfo" onclick ="go_menu(this)"><spring:message code='ezCommunity.t723' /></h3>
         			<c:if test="${joinFlag }">
         				<h3 id="btn_MemberOut" onclick ="go_menu(this)"><spring:message code='ezCommunity.t1108' /></h3>
         			</c:if>
      			</div>
				<div style="border: 1px solid #ddd;margin-top: 5px;display: flex;justify-content: center;">
				    <form id="totalSearchForm" method="post" target="rightfrm" action="/ezCommunity/communitySearchResult.do">
					    <input name="searchType" type="hidden" value="title">
					    <input name="code" type="hidden" value="<c:out value='${code }'/>">
					    <input id="searchWord" name="searchWord" type="text" style="margin: 5px 10px;">
				    </form>
				    <span id="totalSearch" onclick="commuTotalSearch()">
						<spring:message code='ezCommunity.t31'/>
				    </span>
				</div>
  			</div>
    		<div class="cmhome_right">
        		<div id="copmaindesc" class="introduce">
            		<span class="bgimg"></span>
            		<p id="copdesc"></p>
		        </div>
        		<div id="mainboard" style="overflow:auto; display:none;"></div>
				<iframe id="rightfrm" name="rightfrm" style="width:100%; height:650px; border:0; display:none" frameborder="0"></iframe>
        		<div class="makeguide" id="makeguide" style="display: none;">
            		<p><img src="<spring:message code='ezCommunity.i5' />"></p>
            		<p><a id="btn_Manager_home1" onclick ="go_menu(this)"><img src="<spring:message code='ezCommunity.i6' />" alt="<spring:message code='ezCommunity.t2010' />"></a></p>
            		<p><a id="btn_Manager_home2" onclick ="go_menu(this)"><img src="<spring:message code='ezCommunity.i7' />" alt="<spring:message code='ezCommunity.t2011' />"></a></p>
            		<p><img src="/images/kr/community/type1/makeguide_img04.gif"></p>
        		</div>
    		</div>
    	</div>
	</body>
	<script>
	    document.getElementById('searchWord').addEventListener('keydown', function(event) {
	        if (event.key === 'Enter') {
	            event.preventDefault();
	            commuTotalSearch();
	        }
	    });
	</script>
</html>