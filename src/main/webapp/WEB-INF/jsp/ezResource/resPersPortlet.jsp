<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
   <head>
      <title><spring:message code="ezResource.t375" /></title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
      <link type="text/css" rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" />
      <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
      <style>
         .box{border:1px solid #ddd; padding:1px 18px 1px 1px; background-color:#fff;}
      </style>
      <script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
      <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
      <script type="text/javascript" src="${util.addVer('/js/ezResource/organtreeview.htc.js')}"></script>
      <script type="text/javascript" src="${util.addVer('/js/ezResource/control/ListView.htc.js')}"></script>
      <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
      <script id="clientEventHandlersJS" type="text/javascript">
         var Brd_Id      = "${brdID}";      
         var Brd_Nm      = "<c:out value='${brdNm}' />";      
         var brdGubun   = '${brdGubun}';      
         var g_UserID   = "${userInfo.id}";
         var g_DeptID   = "${userInfo.deptID}";
         var g_DeptPath   = "${userInfo.deptPathCode}";
         var pCompanyID    = "${userInfo.companyID}";
         var pLang    = "${userInfo.lang}";
         var g_AccessCode = "${accessCode}"; 
         var g_ServerName = "${serverName}";
         var selectNo = "${selectNo}";
         var ReturnValue_CN = new Array();
         var ReturnValue_Name = new Array();
         var ReturnValue_NameEng = new Array();
         var boolfirstlist = true;
         var pUse_Editor = "${useEditor}";
         var pNoneActiveX = "${noneActiveX}";
         var ReturnFunction;
         var m_Arguments;

          window.onload = function () {
              try {
                  m_Arguments = parent.schedule_add_select_cross_dialogArguments[0];
                  ReturnFunction = parent.schedule_add_select_cross_dialogArguments[1];
              } catch (e) {
                  try {
                      m_Arguments = opener.schedule_add_select_cross_dialogArguments[0];
                      ReturnFunction = opener.schedule_add_select_cross_dialogArguments[1];
                  } catch (e) {
                      m_Arguments = window.dialogArguments;
                  }
              }
             var TreeView = new organtreeview('TreeView', 'TreeView');
             TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
             TreeView.attachEvent('nodeselect', TreeView_onNodeClick);
             TreeView.attachEvent('nodedblclick', InsertReceiver);

             var xmlHTTP = createXMLHttpRequest();
             xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
             xmlHTTP.send();

             if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
                 TreeView.server('${serverName}');
                 TreeView.config(xmlHTTP.responseXML);
                 TreeView.update();
             }

             var pListView = new ListView('pListView', 'pListView');
             pListView.attachEvent('RowClick', onRowClick);
             pListView.attachEvent('HeaderClick', onHeaderClick);
             pListView.attachEvent('RowDblClick', DeleteReceiver);
             pListView.headerSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));

             if (m_Arguments != undefined && m_Arguments.length == 2) {
                 boolfirstlist = false;
                 var xmlString = "<LISTVIEWDATA><ROWS>";
                 for (var i = 0 ; i < m_Arguments[0].length ; i++) {
                     xmlString += "<ROW><CELL><VALUE>" + m_Arguments[1][i] + "</VALUE><CN>" + m_Arguments[0][i] + "</CN><NAME>" + m_Arguments[1][i] + "</NAME></CELL></ROW>";
                 }

                 xmlString += "</ROWS></LISTVIEWDATA>";
                 var emptyxml = createXmlDom();
                 emptyxml = loadXMLString(xmlString);
                 pListView.source(emptyxml);
                 pListView.make();
             } else {
                 var xmlString = "<LISTVIEWDATA><ROWS>";
                 xmlString += "<ROW><CELL><VALUE></VALUE><CN></CN><NAME></NAME></CELL></ROW>";
                 xmlString += "</ROWS></LISTVIEWDATA>";
                 var emptyxml = createXmlDom();
                 emptyxml = loadXMLString(xmlString);
                 pListView.source(emptyxml);
                 pListView.make();
                 pListView.DelRow(0);
                 pListView.make();
             }
             BoardLoad();
             getPersPortlet();
         }

         function onRowClick() {
             return;
         }
         function onHeaderClick() {
             return;
         }
         function locationInfo(pBrdNm) {
             var idx = "7";

             navigation_info = "<a href='/ezResource/resMain.do' target='main' class='n'><spring:message code='ezResource.t334' /></a>"

             if (pBrdNm != "") {
              navigation_info += " > " + pBrdNm + "</a>";
             }
         }

         function BoardLoad() {
             initTreeInfo("", g_UserID, g_DeptID);
         }

         function initTreeInfo(p_Flag, p_UserID, p_DeptID) {
             g_DeptBoardYN = false;

             var objRoot;
             var objNode;

             var xmlhttp = createXMLHttpRequest();
             var xmlpara = createXmlDom()
             var xmlRtn = createXmlDom()

             var objNode;

             createNodeInsert(xmlpara, objNode, "BRDLIST");
             createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", "1");
             createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
             createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
             createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "Y");
             createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
             createNodeAndInsertText(xmlpara, objNode, "USER_ID", p_UserID);
             createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
             createNodeAndInsertText(xmlpara, objNode, "ADMIN_CHECK", "N");
   
             xmlhttp.open("POST", "/ezResource/callNodeTreeData.do?flag=" + selectNo, false);
             xmlhttp.send(xmlpara);

             var xmlRtn = loadXMLString(xmlhttp.responseText);
             TreeView.source(xmlRtn);
             TreeView.update();
         }

         function GetTreeBrdsInfo() {
             var selnode = TreeView.selectedIndex();
             nodeIdx = selnode;

             var brd_id = TreeView.getvalue(nodeIdx, "DATA1");

             if (brd_id == "1") {
                return;
             }

             var brdGubun = TreeView.getvalue(nodeIdx, "DATA7");

             if (brdGubun == 1) {
                 var brd_url = TreeView.getvalue(nodeIdx, "DATA8");
                 if (brd_url != "" && brd_url != document.location.protocol + "//") {
                     strUrl = brd_url;
                     if (strUrl.indexOf(document.location.protocol + "//") == -1) {
                         strUrl = document.location.protocol + "//" + strUrl;
                     }
                     if (strUrl.indexOf("target=") != -1) {
                         var strTarget = "";
                         strTarget = strUrl.substr(strUrl.indexOf("target=") + 7);
                         window.open(strUrl, strTarget);
                     } else {
                         window.open(strUrl);
                     }
                 } else {
                     var rep = new RegExp("&", "gi");
                     var brd_nm = TreeView.getvalue(nodeIdx, "DATA2");
                     var brd_nm = brd_nm.replace(rep, "chr(38)");

                     var strUrl = "/ezResource/viewResList.do?brdID=" + brd_id + "&accessCode=" + g_AccessCode;
                     strUrl = strUrl + "&brdNm=" + encodeURIComponent(brd_nm);
                 }
             } else {
                 strUrl = "/ezResource/scheduleMain.do?resID=" + brd_id + "&accessCode=" + g_AccessCode;
             }
         }

         function Navigate(url) {
             window.open(url, 'right');
         }

         function TreeView_onNodeExpanded(event) {
             displayBrdTree(g_UserID, g_DeptID, event);
         }

         function displayBrdTree(p_UserID, p_DeptID, event) {
             if (!event) event = window.event;
             var nodeIdx = event.nodeIdx;
             var p_BrdID = TreeView.getvalue(nodeIdx, "DATA1");

             AddSubBrdTree(p_UserID, p_DeptID, p_BrdID, nodeIdx);
         }

         function AddSubBrdTree(p_UserID, p_DeptID, p_BrdID, nodeIdx) {
            // try {
                 var xmlhttp = createXMLHttpRequest();
                 var xmlpara = createXmlDom();
                 var xmlRtn = createXmlDom();

                 var objNode;

                 createNodeInsert(xmlpara, objNode, "BRDLIST");
                 createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_BrdID);
                 createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
                 createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
                 createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
                 createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
                 createNodeAndInsertText(xmlpara, objNode, "USER_ID", p_UserID);
                 createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
                 createNodeAndInsertText(xmlpara, objNode, "ADMIN_CHECK", "N");

                 xmlhttp.open("POST", "/ezResource/callNodeTreeData.do", false);
                 xmlhttp.send(xmlpara);
                 xmlRtn = xmlhttp.responseXML;

                 if (getXmlString(xmlRtn) == "") return;

                 if (CrossYN()) {
                     //TreeView.putchildxml(nodeIdx, new XMLSerializer().serializeToString(xmlhttp.responseXML));
                    TreeView.putchildxml(nodeIdx, xmlhttp.responseXML);
                 } else {
                     if (xmlRtn.selectNodes("NODES/NODE/SELECT").length > 0) {
                         xmlRtn.selectNodes("NODES/NODE")[0].removeChild(xmlRtn.selectNodes("NODES/NODE/SELECT")[0]);
                     }
                     TreeView.putchildxml(nodeIdx, xmlRtn.xml);
                 }
             //} catch (Err_Msg) {
          //}
      }

      var nodeIdx;
      function InsertReceiver() {
    	  
    	  if(pListView.listlength()>=5) {
				alert(strLang603);
				return;
    	  }
          nodeIdx = TreeView.selectedIndex();
          var p_BrdID = TreeView.getvalue(nodeIdx, "DATA1");
          var brdGubun = TreeView.getvalue(nodeIdx, "DATA7");

          var Addflg = true;
          var getACL = "";
          if (brdGubun == 2) {
              if (!boolfirstlist) {
                  for (var i = 0; i < pListView.listlength() ; i++) {
                      if (pListView.getvalue2(i, "CN") == TreeView.getvalue(nodeIdx, "DATA1")) {
                          Addflg = false;
                          break;
                      }
                  }
              }

              if (Addflg == true) {
                  getACL = fun_GetACL(TreeView.getvalue(nodeIdx, "DATA1"));

                  if (getACL == "Y" || getACL == "U") {
                      if (!boolfirstlist) {
                          var xmlHttp = createXMLHttpRequest();
                          var xmlDoc = createXmlDom();
                          var rtn = "";
                          var conVal = "";
                          var objNode;
                          createNodeInsert(xmlDoc, objNode, "PARAMETER");
                          createNodeAndInsertText(xmlDoc, objNode, "RESID", TreeView.getvalue(nodeIdx, "DATA1"));

                          xmlHttp.open("POST", "/ezResource/scheduleGetForm.do", false);
                          xmlHttp.send(xmlDoc);

                          rtn = xmlHttp.responseText;
                      }
                      if (boolfirstlist) {
                          var xmlString = "<LISTVIEWDATA><ROWS>";
                          xmlString += "<ROW><CELL><VALUE>" + TreeView.getvalue(nodeIdx, "VALUE") + "</VALUE><CN>" + TreeView.getvalue(nodeIdx, "DATA1") + "</CN><NAME>" + TreeView.getvalue(nodeIdx, "DATA2") + "</NAME></CELL></ROW>";
                          xmlString += "</ROWS></LISTVIEWDATA>";
                          var emptyxml = createXmlDom();
                          emptyxml = loadXMLString(xmlString);
                          pListView.source(emptyxml);
                          pListView.make();
                          boolfirstlist = false;
                      } else {
                          var emptyxml = createXmlDom();
                          emptyxml = loadXMLString("<ROW><CELL><VALUE>" + TreeView.getvalue(nodeIdx, "VALUE") + "</VALUE><CN>" + TreeView.getvalue(nodeIdx, "DATA1") + "</CN><NAME>" + TreeView.getvalue(nodeIdx, "DATA2") + "</NAME></CELL></ROW>");
                          pListView.AddRow(emptyxml);
                          pListView.make();
                      }
                  } else {
                      alert(strLang249);
                  }
              } else {
                  alert(strLang250);
              }
          } else {
              alert(strLang251);
          }
      }

      function InsertReceiver_Complete(retVal) {
          DivPopUpHidden();

          if (!retVal)
              return;

          if (boolfirstlist) {
              var xmlString = "<LISTVIEWDATA><ROWS>";
              xmlString += "<ROW><CELL><VALUE><![CDATA[" + TreeView.getvalue(nodeIdx, "VALUE") + "]]></VALUE><CN>" + TreeView.getvalue(nodeIdx, "DATA1") + "</CN><NAME><![CDATA[" + TreeView.getvalue(nodeIdx, "DATA2") + "]]></NAME></CELL></ROW>";
              xmlString += "</ROWS></LISTVIEWDATA>";
              var emptyxml = createXmlDom();
              emptyxml = loadXMLString(xmlString);
              pListView.source(emptyxml);
              pListView.make();
              boolfirstlist = false;
          } else {
              var emptyxml = createXmlDom();
              emptyxml = loadXMLString("<ROW><CELL><VALUE><![CDATA[" + TreeView.getvalue(nodeIdx, "VALUE") + "]]></VALUE><CN>" + TreeView.getvalue(nodeIdx, "DATA1") + "</CN><NAME><![CDATA[" + TreeView.getvalue(nodeIdx, "DATA2") + "]]></NAME></CELL></ROW>");
              pListView.AddRow(emptyxml);
              pListView.make();
          }
      }

      function DeleteReceiver() {
          var curRowidx = pListView.getMultiRowIndex();

          if (m_Arguments != undefined && m_Arguments.length == 2) {
              if (pListView.getvalue2(curRowidx[0], "CN") == m_Arguments[0][0] && curRowidx.length == 1) {
                  alert(strLang254);
                  return;
              }
              var sellength = curRowidx.length - 1;

              for (var i = sellength  ; i > -1  ; i--) {
                  if (pListView.getvalue2(curRowidx[i], "CN") == m_Arguments[0][0]) {
                      alert(strLang254);
                      return;
                  } else {
                      pListView.DelRow(curRowidx[i]);
                      pListView.make();
                  }
              }
          } else {
              var sellength = curRowidx.length - 1;
              for (var i = sellength  ; i > -1  ; i--) {
                  pListView.DelRow(curRowidx[i]);
                  pListView.make();
              }
          }
          
          if (pListView.listlength() < 1) {
        	  boolfirstlist = true;
          }
      }

      function TreeViewNodeClick() {
          var nodeIdx = TreeView.selectedIndex();
          displayUserList(TreeView.getvalue(nodeIdx, "CN"));
      }

      function TreeView_onNodeClick() {
          var i = "";
          var arrName = "";
          var RealPath = "";
          var brdId = "";
          var chkVal = false;

          g_SelTree = TreeView;

          var selNode = TreeView.selectedIndex();

          if (selNode == null) {
              var strUrl = "/ezResource/nonResList.do";

              locationInfo(RealPath);
              Navigate(strUrl);
          } else {
              nodeIdx = selNode;
              var OriginNode = selNode;

              if (g_AccessCode != "0") g_AccessCode = TreeView.getvalue(nodeIdx, "DATA14");

              var number = parseInt(TreeView.getvalue(nodeIdx, "DATA3"))

              for (i = 2; i <= number; i++) {
                  var brdId = TreeView.getvalue(nodeIdx, "DATA1");
                  var brdnm = TreeView.getvalue(nodeIdx, "DATA2");
                  var boardGubun = TreeView.getvalue(nodeIdx, "DATA7");

                  if (boardGubun == "1") {
                      if ((!chkVal && i == 2) || (chkVal && i == 3)) {
                          RealPath = "&nbsp;<a href=" + "/ezResource/listResource.do?brdID=" + brdId + "&brdNm=" + encodeURIComponent(brdnm) + "&accessCode=" + g_AccessCode + " target='right' class='n'>" + brdnm + "</a>" + RealPath;
                      } else {
                          RealPath = "&nbsp;<a href=" + "/ezResource/listResource.do?brdID=" + brdId + "&brdNm=" + encodeURIComponent(brdnm) + "&accessCode=" + g_AccessCode + " target='right' class='n'>" + brdnm + "&nbsp;></a>" + RealPath;
                      }
                  } else {
                      chkVal = true;
                  }
              }

              locationInfo(RealPath);
              GetTreeBrdsInfo();
          }
      }

      // 포틀릿 조회
         function getFormatDate(date){
             var year = date.getFullYear();              //yyyy
             var month = (1 + date.getMonth());          //M
             month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
             var day = date.getDate();                   //d
             day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
             return  year + '-' + month + '-' + day;       //'-' 추가하여 yyyy-mm-dd 형태 생성 가능
         }

      function getPersPortlet(){
          var date = new Date();
          date = getFormatDate(date);
          var xmlStr = "<PARAMETER><STARTDATETIME>" + date  + "</STARTDATETIME><ENDDATETIME>" + date + "</ENDDATETIME><APP>1</APP></PARAMETER>";
          $.ajax({
              type : "GET",
              data : {
                  date : xmlStr
              },
              dataType : "JSON",
              url : "/ezResource/getResourcePortlet.do",
              async : false, 
              success : function(result) {
                  if (result.status == 'ok') {
                      var _list = result["list"];
                      _list.forEach(function(vo, index) {
                    	  mappingResourcePortlet(vo.brdID , vo.brdNm , vo.brdNm2);  
                      })
                  }
              },
              error : function() {}
          });
      }

      // 포틀릿 listView 매핑
      function mappingResourcePortlet(id, name, name2){
		if (boolfirstlist) {
			var xmlString = "<LISTVIEWDATA><ROWS>";
            if(typeof(pLang) != "undefined" && pLang != "1"){
                xmlString += "<ROW><CELL><VALUE>" + name2 + "</VALUE><CN>" + id + "</CN><NAME>" + name2 + "</NAME></CELL></ROW>";
            }else{
                xmlString += "<ROW><CELL><VALUE>" + name + "</VALUE><CN>" + id + "</CN><NAME>" + name + "</NAME></CELL></ROW>";
            }
			xmlString += "</ROWS></LISTVIEWDATA>";
			var emptyxml = createXmlDom();
			emptyxml = loadXMLString(xmlString);
			pListView.source(emptyxml);
			pListView.make();
			boolfirstlist = false;
		} else {
			var emptyxml = createXmlDom();
            if(typeof(pLang) != "undefined" && pLang != "1"){
				emptyxml = loadXMLString("<ROW><CELL><VALUE>" + name2 + "</VALUE><CN>" + id + "</CN><NAME>" + name2 + "</NAME></CELL></ROW>");
                xmlString += "<ROW><CELL><VALUE>" + name2 + "</VALUE><CN>" + id + "</CN><NAME>" + name2 + "</NAME></CELL></ROW>";
            }else{
				emptyxml = loadXMLString("<ROW><CELL><VALUE>" + name + "</VALUE><CN>" + id + "</CN><NAME>" + name + "</NAME></CELL></ROW>");
            }
			pListView.AddRow(emptyxml);
			pListView.make();
		}
      }
      
      // 포틀릿 자원관리 리스트 저장
      var schedule_add_tfx_dialogArguments = new Array();
      var schedule_add_ck_dialogArguments = new Array();
      function btn_OK() {
/*           if (pListView.listlength() == 0) {
              alert(strLang252);
              return;
          } */

          ReturnValue_CN = [];
          for (var i = 0 ; i < pListView.listlength() ; i++) { 
              ReturnValue_CN[i] = pListView.getvalue2(i, "CN");
          }
              
          var resources = ReturnValue_CN.toString();
          $.ajax({
              type : "POST",
              data : {
                  resources : resources
              },
              dataType : "JSON",
              url : "/ezResource/saveResourcePortlet.do",
              success : function(result) {
                  if (result.status == 'ok') {
                      window_close();
                  }
              },
              error : function() {}
          });
      }

      function window_close(){
			try {
				window.opener.getPersPortlet();
				window.close();
			} catch(e) {
				console.log(e);
				window.close();
			}
      }
     

      function btn_close() {
          if (ReturnFunction != null) {
              ReturnFunction("close");
              window.close();
          } else {
              window.close();
          }
      }

      function fun_GetACL(pBordID) {
          var xmlHttp = createXMLHttpRequest();
          var Return = "";
          try {
              xmlHttp.open("POST", "/ezResource/scheduleAddGetACL.do?brdID=" + pBordID, false);
              xmlHttp.send();

              if (xmlHttp.status == "200") {
                  var dataNodes = GetChildNodes(xmlHttp.responseXML);
                  Return = getNodeText(dataNodes[0]);
              } else {
                  Return = "ERROR"
              }
          }
          catch (e) {
              alert(e.description);
              Return = "ERROR"
          }
          xmlHttp = null;
          return Return;
      }

      var apropinion_cross_dialogArguments = new Array();
      function OpenInformationUI(pAlertContent) {
          if (CrossYN()) {
              apropinion_cross_dialogArguments[0] = pAlertContent;
              apropinion_cross_dialogArguments[1] = InsertReceiver_Complete;

              DivPopUpShow(330, 205, "/ezResource/apropinion.do");
          } else {
              var parameter = pAlertContent;
              var url = "/ezResource/apropinion.do";
              var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
              feature = feature + GetShowModalPosition(330, 205);
              return window.showModalDialog(url, parameter, feature);
          }
      }
      </script>
      <style>
      	.mainlist tr th { border-top:0px }
      </style>
   </head>
   <body class="popup" style="width:470px;height:400px">
      <xml id="listviewheader" style="display:none">
           <LISTVIEWDATA>
             <HEADERS>
                  <HEADER>
                    <NAME><spring:message code="ezResource.t376" /></NAME>
                    <WIDTH>200</WIDTH>
                  </HEADER>      
             </HEADERS>
           </LISTVIEWDATA>
      </xml>
      <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>   
      <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
         <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
      </div>
       <h1><spring:message code="ezResource.t375" /></h1>
       <div id="close">
            <ul>
                <li><span onclick="btn_close()"></span></li>
            </ul>
        </div>
       <table>
           <tr>
               <td>
                   <h2><span id="menu01" ><spring:message code="ezResource.t342" /></span></h2>
                   <div class="box" id="TreeView" style="height:285px;width:230px;overflow-x:auto;overflow-y:auto; vertical-align:top"></div>             
               </td>
               <td style="padding:26px 6px 6px 6px">
                   <img src="/images/kr/cm/arr_right.gif" alt="" style="cursor:pointer; width:16px; height:16px; border:0px" onClick="InsertReceiver()"><br/>
                   <img src="/images/kr/cm/arr_left.gif" alt="" style="cursor:pointer; width:16px; height:16px; border:0px" onClick="DeleteReceiver()">
               </td>
               <td>
                   <h2><span id="Span1" ><spring:message code="ezResource.t374" /></span></h2>
                   <div class="listview">
                       <div id="pListView" STYLE="border:0px solid #ddd; Width:242px; Height:288px; overflow : auto;"  ></div>
                   </div>
               </td>
           </tr>
           <tr>
               <td colspan="3" style="text-align:center">
	               <div class="btnposition btnpositionNew">	
	                   <a class="imgbtn"><span onClick="btn_OK()"><spring:message code="ezResource.t114" /></span></a>
	               </div>    
               </td>
           </tr>        
       </table>      
   </body>
</html>