<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <title><spring:message code='ezSchedule.ljeGs003' /></title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
  <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
  <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
  <style>
    .mainlist tr td:first-child {
      padding-left:15px;
    }
    /* 조직도 #SelectDeptNM(부서명[사원수]) 부분 */
    #spn_deptName {
      text-overflow: ellipsis;
      white-space: nowrap;
      overflow: hidden;
      display: inline-block;
    }
    #countInfo {
      overflow: hidden;
      display: inline-block;
    }
    .countColor {
      color:#017BEC;
    }
  </style>
  <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/ezSchedule/TreeView.js')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/ezSchedule/ListView_list.js')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/NameControl.js')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
  <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
  <script type="text/javascript">
    var UserAgentState = navigator.userAgent.toLowerCase();
    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
    var pListType = "TXT";
    var pListXML_Info = null;
    var CurPage = "1";
    var lang = "<c:out value='${userInfo.primary}'/>";

    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
      window.onblur = function () {
        window.focus();
      }
    }

    document.onkeydown = function (evt) {
      var e = evt;
      if (e == null) e = window.event;
      if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
        if ((e.keyCode > 47) && (e.keyCode < 58)) {
          e.preventDefault();
        }
        else if ((e.keyCode > 95) && (e.keyCode < 106)) {
          e.preventDefault();
        }
        else if ((e.keyCode > 64) && (e.keyCode < 91)) {
          e.preventDefault();
        }
        else if ((e.keyCode == 106) ||
                (e.keyCode == 107) ||
                (e.keyCode == 109) ||
                (e.keyCode == 110) ||
                (e.keyCode == 111) ||
                (e.keyCode == 186) ||
                (e.keyCode == 187) ||
                (e.keyCode == 188) ||
                (e.keyCode == 189) ||
                (e.keyCode == 190) ||
                (e.keyCode == 191) ||
                (e.keyCode == 192) ||
                (e.keyCode == 219) ||
                (e.keyCode == 220) ||
                (e.keyCode == 221) ||
                (e.keyCode == 222)) {
          e.preventDefault();
        }
        else if ((e.keyCode == 229)) {
          e.returnValue = false;
        }
      }
    }

    var ReturnFunction;
    window.onload = function () {
      try {
        ReturnFunction = parent.schedule_group_write_dialogArguments[1];
      } catch (e) {
        try {
          ReturnFunction = opener.schedule_group_write_dialogArguments[1];
        } catch (e) {}
      }

      if (navigator.userAgent.indexOf('Firefox') != -1) {
        document.body.style.MozUserSelect = 'none';
        document.body.style.WebkitUserSelect = 'none';
        document.body.style.khtmlUserSelect = 'none';
        document.body.style.oUserSelect = 'none';
        document.body.style.UserSelect = 'none';
      }

      ListTypeChangeIcon();
      recevieListview("MsgToList", "ListViewMsgTo");

      try {
        var xmlpara = createXmlDom();
        var xmlTree = createXmlDom();
        var xmlHTTP = createXMLHttpRequest();
        var objNode;
        createNodeInsert(xmlpara, objNode, "DATA");
        createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
        createNodeAndInsertText(xmlpara, objNode, "TOPID", "${userInfo.companyID}");
        createNodeAndInsertText(xmlpara, objNode, "PROP", "");
        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
        xmlHTTP.send(xmlpara);
        xmlTree = loadXMLString(xmlHTTP.responseText);
        var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
        document.getElementById('TreeView').innerHTML = "";
        var treeView = new TreeView();
        treeView.SetConfig(treeXML);
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("RequestData");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.DataSource(xmlTree);
        treeView.DataBind("TreeView");
      }
      catch (ErrMsg) {
        alert(" TreeViewinitialize : " + ErrMsg.description);
      }

      ChangeListView_onClick(getOrganListType());
    }

    function ListTypeChangeIcon() {
      if (pListType == "IMG") {
        document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
        document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
      }
      else {
        document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
        document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
      }
    }

    function recevieListview(pID, pListView) {
      var listview = new ListView();
      listview.SetID(pID);
      listview.SetHeightFree(true);
      listview.SetSelectFlag(false);
      listview.SetMulSelectable(true);
      listview.SetRowOnDblClick("DeleteReceiver");
      listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
      listview.DataBind(pListView);
      listview.RowDataBind();
    }

    function ChangeListView_onClick(Div) {
      pListType = Div;
      ListTypeChangeIcon();
      DisplayUserImageList();
      setOrganListType(pListType);
    }

    function onDragEnter(evt) {
      evt.stopPropagation();
      evt.preventDefault();
      evt.dataTransfer.dropEffect = "copy";
      evt.dataTransfer.effectAllowed = "copy";
    }
    function onDrop(evt, element) {
      evt.stopPropagation();
      evt.preventDefault();
      InsertReceiver(element);
    }

    function RequestData(pNodeID, pTreeID) {
      var TreeIdx = pNodeID;
      var treeNode = new TreeNode();
      treeNode.LoadFromID(TreeIdx);
      var deptID = treeNode.GetNodeData("CN");
      GetDeptSubTreeInfo(deptID, TreeIdx);
    }

    function GetDeptSubTreeInfo(deptID, TreeIdx) {
      var xmlHTTP = createXMLHttpRequest();
      var xmlRtn = createXmlDom();
      var xmlpara = createXmlDom();
      var objNode;
      createNodeInsert(xmlpara, objNode, "DATA");
      createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
      createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
      xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
      xmlHTTP.send(xmlpara);
      xmlRtn = loadXMLString(xmlHTTP.responseText);
      if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
        if (CrossYN()) {
          xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
        } else {
          xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
        }
      }
      var treeView = new TreeView();
      treeView.LoadFromID("FromTreeView");
      treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
    }

    var nodeIdx;
    function TreeViewNodeClick() {
      issearch = false;
      CurPage = "1";
      p_ListOrderObject = "";
      var treeView = new TreeView();
      treeView.LoadFromID("FromTreeView");
      var nodeIdx = treeView.GetSelectNode();
      document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
              + "<span id='spn_deptName' title='" + ReplaceText(nodeIdx.GetNodeData("VALUE"), "&", "&amp;") + "'>" + ReplaceText(nodeIdx.GetNodeData("VALUE"), "&", "&amp;") + "</span>"
              + "<span id='countInfo'></span>";
      SelectDeptNM.setAttribute("countinfo", "")
      displayUserList(nodeIdx.GetNodeData("CN"));
    }
    var tempDeptID = "";
    function displayUserList(DeptID) {
      if (DeptID != undefined) {
        tempDeptID = DeptID;
      }

      $.ajax({
        url : '/ezOrgan/getDeptMemberList.do',
        method : 'POST',
        dataType : "text",
        data : {
          deptID : tempDeptID ,
          cell : "company;description;displayName;title;telephoneNumber",
          prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department",
          page : CurPage ,
          type : "user"
        } ,
        success : function(xml) {
          event_displayUserList(loadXMLString(xml));
          /*
          //2016-10-17 자바스크립트 실행순서때문에 자꾸 getDeptMemberList.do리스트가 나중에 나와서 window.onload 밑에있던부분 이쪽으로 위치 이동
             if (strSearch != "") {
              document.getElementById('keyword').value = strSearch;
              search_click("search");
              strSearch = "";
            } */
        },
        error : function(jqXHR, textStatus, errorThrown) {
          alert(error);
        }
      });

      $.ajax({
        url : "/ezOrgan/getDeptMemberListCount.do",
        method : "POST",
        dataType : "json",
        data : {
          deptID : tempDeptID
        },
        success : function(result) {
          if (SelectDeptNM.getAttribute("countinfo") != "1" && !pSeach ) {
            var id = $("span[class=node_selected]").eq(0).closest("div").attr("id");
            var strIsLeaf = $("div#" + id + "").attr("isleaf");

            if (result.containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
              document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='countColor'>" + result.totalCount + "</span> / <span class='countColor'>" + parseInt(result.totalCount + result.totalCount2) + "</span>";
            } else {
              document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='countColor'>" + result.totalCount + "</span>";
            }
            //2018-08-01 김보미 - 부서명 [사원수] 가 넘치는지 확인하는 함수
            deptNameLong(result.containLow, strIsLeaf);

            SelectDeptNM.setAttribute("countinfo","1")
          }
        },
        error : function(jqXHR, textStatus, errorThrown) {
          alert(error);
        }
      });
    }
    function event_displayUserList(xml) {
      if (xml != null) {
        pListXML_Info = xml;
        xml = null;
        pSeach = false;
        DisplayUserImageList();
        makePageSelPage();
      }
    }

    var pSeach = false;
    function DisplayUserImageList() {
      var xmlRtn = pListXML_Info;
      document.getElementById("DeptUserImgList").innerHTML = "";
      document.getElementById("txtlist_Layer").scrollTop = "0";
      document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;

      var totalCount = new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]));
      totalPage = Math.ceil(totalCount / 50);

      while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
      }

      while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
        document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
      }

      var UserListHTML = "";
      /* if (SelectDeptNM.getAttribute("countinfo") != "1" && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) != null && getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0])!= "") {
          //SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + totalCount + strLang256 + "</span>]";
          if (getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
              SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang256 + "</span>]";
          } else {
              SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang256 + "</span>]";
          }

          SelectDeptNM.setAttribute("countinfo", "1")
      } */

      if (pListType == "IMG") {
        document.getElementById("DeptUserImgList").style.display = "";
        document.getElementById("txtlist_Layer").style.display = "none";
        document.getElementById("txtlist_table").style.display = "none";
        document.getElementById("Search_txtlist_table").style.display = "none";

        if (pSeach) {
          document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + strLang257 + "</span>" + "<span id='countInfo' style='color:#017BEC;'>&nbsp;&nbsp;<span style='color:#017BEC;'>" + totalCount + "</span></span>";
          SelectDeptNM.setAttribute("countinfo", "1");
        }
      } else {
        document.getElementById("DeptUserImgList").style.display = "none";
        document.getElementById("txtlist_Layer").style.display = "";

        if (!pSeach) {
          document.getElementById("txtlist_table").style.display = "";
          document.getElementById("Search_txtlist_table").style.display = "none";
        } else {
          document.getElementById("Search_txtlist_table").style.display = "";
          document.getElementById("txtlist_table").style.display = "none";
          document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px;\" >" + "<span id='spn_deptName'>" + strLang257 + "</span>" + "<span id='countInfo' style='color:#017BEC;'>&nbsp;&nbsp;<span style='color:#017BEC;'>" + totalCount + "</span></span>";
          SelectDeptNM.setAttribute("countinfo", "1")
        }
      }

      for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
        if (pListType == "IMG") {
          var MainTable = document.createElement("TABLE");
          MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
          MainTable.setAttribute("cellspacing", "0");
          MainTable.setAttribute("cellpadding", "0");

          if (pListType == "IMG") {
            MainTable.style.marginTop = "5px";
          }
          MainTable.style.marginLeft = "auto";
          MainTable.style.marginRight = "auto";
          var M_TR = document.createElement("TR");
          M_TR.setAttribute("id", "MailUserlist_" + i);
          M_TR.style.cursor = "pointer";
          M_TR.onmouseover = function () { event_listMover(this); };
          M_TR.onmouseout = function () { event_listMout(this); };
          M_TR.onclick = function () { event_listclick(this); };
          M_TR.ondblclick = function () { event_listDBclick(this); };
          M_TR.setAttribute("draggable", true);
          M_TR.onselectstart = function () { return false; };

          if (CrossYN()) {
            for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
              if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                        trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
              }
            }
          } else {
            for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
              M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                      SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
            }
          }

          var M_TR_TD = document.createElement("TD");
          M_TR_TD.setAttribute("class", "pictd");
          var M_TR_DIV = document.createElement("DIV");
          M_TR_DIV.setAttribute("class", "pic");

          if (M_TR.getAttribute("_DATA9") != "") {
            var M_TR_IMG = document.createElement("IMG");
            M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
            M_TR_IMG.setAttribute("width", "90px");
            M_TR_IMG.setAttribute("height", "90px");
            M_TR_DIV.appendChild(M_TR_IMG);
          }
          M_TR_TD.appendChild(M_TR_DIV);
          M_TR.appendChild(M_TR_TD);

          var M_TR_TD2 = document.createElement("TD");
          M_TR_TD2.style.width = "300px";

          var M_TR_TDS_Table = document.createElement("TABLE");
          M_TR_TDS_Table.setAttribute("class", "organinfo");
          M_TR_TD2.appendChild(M_TR_TDS_Table);

          var Sub_TR1 = document.createElement("TR");
          var Sub_TD1 = document.createElement("TD");
          Sub_TD1.style.textAlign = "left";
          Sub_TD1.setAttribute("class", "name");
          var pDisplayName = "";
          if ("<c:out value='${use_ocs}'/>" == "YES") {
            pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
          }
          pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
          pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
          Sub_TD1.innerHTML = pDisplayName;
          Sub_TR1.appendChild(Sub_TD1);

          var Sub_TR2 = document.createElement("TR");
          var Sub_TD2 = document.createElement("TD");
          Sub_TD2.style.textAlign = "left";
          Sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
          Sub_TR2.appendChild(Sub_TD2);

          var Sub_TR3 = document.createElement("TR");
          var Sub_TD3 = document.createElement("TD");
          Sub_TD3.style.textAlign = "left";
          var Sub_TD3_Img = document.createElement("IMG");
          Sub_TD3_Img.setAttribute("class", "icon");
          Sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
          Sub_TD3.appendChild(Sub_TD3_Img);
          Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
          Sub_TR3.appendChild(Sub_TD3);

          var Sub_TR4 = document.createElement("TR");
          var Sub_TD4 = document.createElement("TD");
          Sub_TD4.style.textAlign = "left";
          var Sub_TD4_Img = document.createElement("IMG");
          Sub_TD4_Img.setAttribute("class", "icon");
          Sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
          Sub_TD4.appendChild(Sub_TD4_Img);
          Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
          Sub_TR4.appendChild(Sub_TD4);

          M_TR_TDS_Table.appendChild(Sub_TR1);
          M_TR_TDS_Table.appendChild(Sub_TR2);
          M_TR_TDS_Table.appendChild(Sub_TR3);
          M_TR_TDS_Table.appendChild(Sub_TR4);

          M_TR.appendChild(M_TR_TD2);
          MainTable.appendChild(M_TR);

          document.getElementById("DeptUserImgList").appendChild(MainTable);
        } else {
          var M_TR = document.createElement("TR");
          M_TR.setAttribute("id", "MailUserlist_" + i);
          M_TR.style.cursor = "pointer";
          M_TR.onmouseover = function () { event_listMover(this); };
          M_TR.onmouseout = function () { event_listMout(this); };
          M_TR.onclick = function () { event_listclick(this); };
          M_TR.ondblclick = function () { event_listDBclick(this); };
          M_TR.setAttribute("draggable", true);
          M_TR.onselectstart = function () { return false; };

          if (CrossYN()) {
            for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
              if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                        trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
              }
            }
          } else {
            for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
              M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
                      SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
            }
          }

          if (pSeach) {
            var M_TR_TD1 = document.createElement("TD");
            M_TR_TD1.style.overflow = "hidden";
            M_TR_TD1.style.textOverflow = "ellipsis";
            M_TR_TD1.style.whiteSpace = "nowrap";
            M_TR_TD1.style.width = "110px";
            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");

            var M_TR_TD2 = document.createElement("TD");
            M_TR_TD2.style.overflow = "hidden";
            M_TR_TD2.style.textOverflow = "ellipsis";
            M_TR_TD2.style.whiteSpace = "nowrap";
            M_TR_TD2.style.width = "90px";
            if ("<c:out value='${use_ocs}'/>" == "YES") {
              M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
            } else {
              M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
            }
            var M_TR_TD3 = document.createElement("TD");
            M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
            M_TR_TD3.style.width = "80px";

            var M_TR_TD4 = document.createElement("TD");
            M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

            M_TR.appendChild(M_TR_TD1);
            M_TR.appendChild(M_TR_TD2);
            M_TR.appendChild(M_TR_TD3);
            M_TR.appendChild(M_TR_TD4);
            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
          } else {
            var M_TR_TD1 = document.createElement("TD");
            M_TR_TD1.style.overflow = "hidden";
            M_TR_TD1.style.textOverflow = "ellipsis";
            M_TR_TD1.style.whiteSpace = "nowrap";
            M_TR_TD1.style.width = "150px";

            if ("<c:out value='${use_ocs}'/>" == "YES") {
              M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
            } else {
              M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
            }
            var M_TR_TD2 = document.createElement("TD");
            M_TR_TD2.style.width = "80px";
            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");

            var M_TR_TD3 = document.createElement("TD");
            M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

            M_TR.appendChild(M_TR_TD1);
            M_TR.appendChild(M_TR_TD2);
            M_TR.appendChild(M_TR_TD3);
            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
          }
        }
      }
    }

    var listContentArry = new Array();
    var listSubContentArry = new Array();
    var listEventCheckbox = false;
    var listSubEventCheckbox = false;
    function event_listclick(obj) {
      if (!listEventCheckbox) {
        if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
          for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
            p_ListOrderObject = document.getElementById(listContentArry[Cnt]);

            if (p_ListOrderObject != null) {
              for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
              }
            }
          }
          listContentArry = new Array();
        }
        if (PressShiftKey) {
          var SelectedPreObj = null;
          for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
            p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
            if (Cnt == 0)
              SelectedPreObj = p_ListOrderObject;

            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
              p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
            }
          }

          listContentArry = new Array();
          if (p_ListOrderObject == null || p_ListOrderObject == "")
            return;

          var PrelistContent;
          if (SelectedPreObj == null)
            PrelistContent = p_ListOrderObject.getAttribute("id");
          else
            PrelistContent = SelectedPreObj.getAttribute("id");

          p_ListOrderObject = obj;

          var CurlistContent = GetAttribute(obj, "id");
          var PrePoint = parseInt(PrelistContent.replace("MailUserlist_", ""));
          var CurPoint = parseInt(CurlistContent.replace("MailUserlist_", ""));
          if (PrePoint < CurPoint) {

            for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
              p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
              for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
              }
              listContentArry[listContentArry.length] = GetAttribute(p_ListOrderObject, "id");
            }

          }
          else if (PrePoint > CurPoint) {
            for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
              p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
              for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
              }
              listContentArry[listContentArry.length] = GetAttribute(p_ListOrderObject, "id");
            }
          }
          else
            return;

        }
        else {
          p_ListOrderObject = obj;
          var insertFlag = true;
          for (var i = 0; i < listContentArry.length; i++) {
            if (listContentArry[i] == GetAttribute(p_ListOrderObject, "id")) {
              insertFlag = false;
              if (PressCtrlKey) {
                listContentArry.splice(i, 1);
                for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
                  p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
                }
                if (listContentArry.length == 0)
                  p_ListOrderObject = "";
              }
            }
          }
          if (insertFlag) {
            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
              p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
            }

            listContentArry[listContentArry.length] = GetAttribute(p_ListOrderObject, "id");
          }
        }
      }
      else
        listEventCheckbox = false;
    }
    function event_listDBclick(obj) {
      InsertReceiver("MsgToList");
    }

    var m_strColorSelect = "#f1f8ff";
    var m_strColorOver = "#f4f5f5";
    var m_strColorDefault = "#ffffff";
    var p_ListOrderObject = null;
    function event_listMover(obj) {
      for (var i = 0; i < listContentArry.length; i++) {
        if (document.getElementById(listContentArry[i]) == obj) {
          return;
        }
      }
      if (p_ListOrderObject != obj) {
        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
          obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
        }
      }
    }
    function event_listMout(obj) {

      for (var i = 0; i < listContentArry.length; i++) {
        if (document.getElementById(listContentArry[i]) == obj) {
          return;
        }
      }
      if (p_ListOrderObject != obj) {
        for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
          obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
        }
      }
    }
    var PressShiftKey = false;
    var PressCtrlKey = false;
    function event_listOnkeyUp(event) {
      if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
      }
      switch (event.keyCode) {
        case 16: PressShiftKey = false; break;
        case 17: PressCtrlKey = false; break;
        case 46: deleteWork(false); break;
      }

    }
    function event_listOnkeyDown(event) {
      if (navigator.userAgent.indexOf('Firefox') != -1) {
        if (!event) event = window.event;
      }
      switch (event.keyCode) {
        case 16: PressShiftKey = true; break;
        case 17: PressCtrlKey = true; break;
      }
    }

    function add_member() {
      var length = document.all("OrganListView").multiSelects.length;

      for (var count1 = 0; count1 < length; count1++) {
        var selRow = document.all("OrganListView").multiSelects.item(count1);

        if (selRow) {
          lastindex = document.all("ListMember").length;
          var isExist = false;

          for (var i = 0; i < lastindex; i++) {
            if (document.all("ListMember").options[i].value.split(";")[0] == selRow.cells[0].DATA3) {
              alert("'" + selRow.cells[0].innerText + "'<spring:message code='ezSchedule.t194' />");
              isExist = true;
              break;
            }
          }

          if (!isExist) {
            newoption = new Option(selRow.cells[0].innerText, selRow.cells[0].DATA3 + ";" + selRow.cells[0].DATA7 + ";" + selRow.cells[0].DATA9 + ";" + selRow.cells[0].DATA10 + ";" + selRow.cells[0].DATA8);
            document.all("ListMember").options[lastindex] = newoption;
          }
        }
      }
    }

    function delete_member() {
      while (true) {
        selectindex = document.all("ListMember").selectedIndex;

        if (selectindex < 0 || selectindex >= document.all("ListMember").length)
          return;

        document.all("ListMember").options[selectindex] = null;
      }
    }

    function close_onclick() {
      /* if (specialChk(document.all("groupname").value) || specialChk(document.all("description").value)) {
          alert("<spring:message code='ezResource.special' />");
		    		return;
		    	} */

      if (document.all("groupname").value.replace(/\s/g, '') == "") {
        alert("<spring:message code='ezSchedule.t195' />");
        document.all("groupname").value = "";
        document.all("groupname").focus();
        return;
      }

      if (document.all("description").value.replace(/\s/g, '') == "") {
        alert("<spring:message code='ezSchedule.t196' />");
        document.all("description").value = "";
        document.all("description").focus();
        return;
      }

      if (!check_length(document.all("groupname").value, 50, "<spring:message code='ezSchedule.t159' />")) return;
      if (!check_length(document.all("description").value, 250, "<spring:message code='ezSchedule.t160' />")) return;

      var listid = "MsgToList";
      var selList = new ListView();
      selList.LoadFromID(listid);
      var totalRows = selList.GetDataRows();
      var totalLen = totalRows.length;

      if (totalLen == 0) {
        alert("<spring:message code='ezSchedule.t197' />");
        return;
      }

      var memberList = new Array();

      for (var i = 0; i < totalLen; i++) {
        var data = new Object();
        data.memberID = GetAttribute(totalRows[i], "DATA1");
        data.memberName1 = GetAttribute(totalRows[i], "DATA2");
        data.memberName2 = GetAttribute(totalRows[i], "DATA3");
        data.memberDeptId = GetAttribute(totalRows[i], "DATA9");
        memberList.push(data);
      }

      $.ajax({
        url : '/ezSchedule/scheduleGatherSave.do',
        method : 'POST',
        async : false,
        dataType : "text",
        data : {
          groupName : document.all("groupname").value,
          description : document.all("description").value,
          memberList : JSON.stringify(memberList),
          displayName : "<c:out value='${userInfo.displayName1}' />",
          displayName2 : "<c:out value='${userInfo.displayName2}' />"
        },
        success : function(text) {
          alert("<spring:message code='ezSchedule.ljeGs006' />");

          if (ReturnFunction != null) {
            ReturnFunction("");
            window.close();
          } else {
            window.returnValue = "";
            window.close();
          }
        },
        error : function(jqXHR, textStatus, errorThrown) {
          alert("<spring:message code='ezSchedule.ljeGs007' />");
        }
      });
    }

    function check_length(chkstr, maxlength, fieldname) {
      var length = 0;
      var i;

      length = chkstr.length;

      if (length > maxlength) {
        alert(fieldname + "<spring:message code='ezSchedule.t200' /> " + maxlength + "<spring:message code='ezSchedule.t201' />");
        return false;
      }

      return true;
    }

    function search_press(e) {
      if (window.event) {
        if (window.event.keyCode == 13) {
          search_click("search");
        }
      }
      else {
        if (e.which == 13)
          search_click("search");
      }

    }
    var issearch = false;
    function search_click(type) {
      listContentArry = new Array();
      var keywordObj = document.getElementById('keyword');

      if (specialChk(keywordObj.value)) {
        alert("<spring:message code='ezResource.special' />");
        return;
      }

      if (keywordObj.value.trim() == "") {
        alert("<spring:message code='ezSchedule.t8' />");
        keywordObj.focus();
        return;
      }
      if (type == "search") {
        CurPage = "1";
        issearch = true;
      }

      $.ajax({
        url : '/ezOrgan/getSearchList.do',
        method : 'POST',
        dataType : "text",
        data : {
          search : document.getElementById("search_type").value + "::" + keywordObj.value,
          cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
          prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department",
          page : CurPage ,
          type : "user"
        } ,
        success : function(xml) {
          event_displayUserList2(loadXMLString(xml));
        },
        error : function(jqXHR, textStatus, errorThrown) {
          alert("<spring:message code="ezResource.t2"/>" + textStatus);
        }
      });

      var usedefault;
      if (browserIE) {
        usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
      }
      else {
        usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
      }
      // 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용.
      PressShiftKey = false;
    }

    function event_displayUserList2(xml) {
      if (xml != null) {
        if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length == 0) {
          alert("<spring:message code='ezPersonal.t211'/>");
        } else {
          pListXML_Info = xml;
          pSeach = true;
          DisplayUserImageList();
          makePageSelPage();
        }
      }
    }

    function keyword_Clear() {
      document.getElementById("keyword").value = "";
    }

    function infoview_click() {
      if (p_ListOrderObject == null || p_ListOrderObject == "") {
        alert("<spring:message code='ezSchedule.t1053' />");
        return;
      }
      var id = p_ListOrderObject.getAttribute("_DATA2");
      var dept = p_ListOrderObject.getAttribute("_DATA10");
      var pheight = window.screen.availHeight;
      var pwidth = window.screen.availWidth;
      var pTop = (pheight - 450) / 2;
      var pLeft = (pwidth - 420) / 2;
      window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
    }

    function InsertReceiver(pListView) {
      var pparsingXML = "";
      var pparsingXML2 = "";
      var strSIP = "";
      var pAddFlag = false;
      if (listContentArry != "") {
        for (var i = 0; i < listContentArry.length; i++) {
          var strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
          var strName = document.getElementById(listContentArry[i]).getAttribute("_data11");
          var strDeptNM = document.getElementById(listContentArry[i]).getAttribute("_data5");
          var strEmail = document.getElementById(listContentArry[i]).getAttribute("_data3");
          var strName2 = document.getElementById(listContentArry[i]).getAttribute("_data12");
          var strDeptNM2 = document.getElementById(listContentArry[i]).getAttribute("_data13");
          var jickwe = document.getElementById(listContentArry[i]).getAttribute("_data14");
          var phone = document.getElementById(listContentArry[i]).getAttribute("_data8");
          var department = document.getElementById(listContentArry[i]).getAttribute("_data10");

          var listid = "MsgToList";
          var getlistview = new ListView();
          getlistview.LoadFromID(listid);
          var IsInsert = CheckMailReceiver(strId, "3");
          if (strId == "<c:out value='${userInfo.id}' />") {
            alert("<spring:message code='ezSchedule.t352' />");
            continue;
          }

          if (!IsInsert) {
            pparsingXML2 = "";
            pparsingXML = "";
            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";

            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
            pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
            pparsingXML = pparsingXML + "<DATA4><![CDATA[" + strDeptNM + "]]></DATA4>";
            pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
            pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
            pparsingXML = pparsingXML + "<DATA7><![CDATA[" + jickwe + "]]></DATA7>";
            pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
            pparsingXML = pparsingXML + "<DATA9><![CDATA[" + department + "]]></DATA9>";


            /* 		                    if("<c:out value='${userInfo.lang}' />" == "1")
                                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " (" + strDeptNM + ") " + "]]></VALUE></CELL></ROW>";
		                    else
                                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + " (" + strName2 + ") " + "]]></VALUE></CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";

		                    Resultxml = loadXMLString(pparsingXML2); */

            if(lang == "1")
              pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
            else
              pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName2 + "]]></VALUE></CELL></ROW>";
            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
            Resultxml = loadXMLString(pparsingXML2);


            var listview = new ListView();
            listview.LoadFromID(listid);

            var MaxID = 0;
            var InitTr = listview.GetDataRows();
            var MaxCntNum = 0;
            for (var j = 0  ; j < InitTr.length  ; j++) {
              var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
              if (MaxID < curnum) {
                MaxID = curnum;
                MaxCntNum = j;
              }
            }

            var objTr = listview.AddRow(InitTr.length);
            if (MaxCntNum != 0)
              MaxCntNum = MaxCntNum + 1;
            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml);

            var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
            for (var y = 0; y < _tdlength; y++) {
              document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
              document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
            }
          }
        }
      }
      else {
        if (p_ListOrderObject == "") {
          alert("<spring:message code='ezSchedule.t1053' />");
          return;
        }
        if (p_ListOrderObject != "") {
          var strId = p_ListOrderObject.getAttribute("_data2");
          var strName = p_ListOrderObject.getAttribute("_data4");
          var strDeptNM = p_ListOrderObject.getAttribute("_data5");
          var strEmail = p_ListOrderObject.getAttribute("_data3");
          var strName2 = p_ListOrderObject.getAttribute("_data11");
          var strDeptNM2 = p_ListOrderObject.getAttribute("_data13");
          var jickwe = p_ListOrderObject.getAttribute("_data14");
          var phone = p_ListOrderObject.getAttribute("_data8");
          var department = p_ListOrderObject.getAttribute("_data10");

          var listid = "MsgToList";

          var getlistview = new ListView();
          getlistview.LoadFromID(listid);
          var bFlag = getlistview.ExistRow("DATA2", strEmail);

          if (bFlag) {
            pAddFlag = true;
          }
          else {
            pparsingXML2 = "";
            pparsingXML = "";
            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
            pparsingXML = pparsingXML + "<DATA2><![CDATA[" + strName + "]]></DATA2>";
            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + strName2 + "]]></DATA3>";
            pparsingXML = pparsingXML + "<DATA4><![CDATA[" + department + "]]></DATA4>";
            pparsingXML = pparsingXML + "<DATA5><![CDATA[" + strDeptNM2 + "]]></DATA5>";
            pparsingXML = pparsingXML + "<DATA6><![CDATA[" + strName + "]]></DATA6>";
            pparsingXML = pparsingXML + "<DATA7><![CDATA[" + jickwe + "]]></DATA7>";
            pparsingXML = pparsingXML + "<DATA8>" + phone + "</DATA8>";
            pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
            Resultxml = loadXMLString(pparsingXML2);

            var listview = new ListView();
            listview.LoadFromID(listid);

            var MaxID = 0;
            var InitTr = listview.GetDataRows();
            var MaxCntNum = 0;
            for (var j = 0  ; j < InitTr.length  ; j++) {
              var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
              if (MaxID < curnum) {
                MaxID = curnum;
                MaxCntNum = j;
              }
            }

            var objTr = listview.AddRow(InitTr.length);
            if (MaxCntNum != 0)
              MaxCntNum = MaxCntNum + 1;
            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml);

            var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
            for (var y = 0; y < _tdlength; y++) {
              document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
              document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
            }
          }
        }
      }
      var listid = "MsgToList";
    }

    function CheckMailReceiver(selRow, option) {
      var rtnValue = false;
      var email;
      if (option == "1")
        email = selRow.cells[0].DATA3;
      else if (option == "2")
        email = selRow.cells[0].DATA2;
      else if (option == "3")
        email = selRow;

      var _listview = new ListView();
      _listview.LoadFromID("MsgToList");
      var arrRows = _listview.GetDataRows();
      for (count2 = 0; count2 < arrRows.length; count2++) {
        if (email == arrRows[count2].getAttribute("data1"))
          rtnValue = true;
      }
      return rtnValue
    }

    function DeleteReceiver(pListView) {
      var selList = new ListView();
      selList.LoadFromID("MsgToList");
      var arrRows = selList.GetSelectedRows();
      var strName = "";
      for (var i = 0; i < arrRows.length; i++) {
        selList.DeleteRow(arrRows[i].id);
      }
    }

    function Add_Dept() {
      var treeView = new TreeView();
      treeView.LoadFromID("FromTreeView");
      var nodeIdx = treeView.GetSelectNode();
      var chk_Sub = "N";

      <%-- 2018-05-07 천성준 - 하위부서포함 체크박스 주석처리 (하위부서 쿼리 에러 관련 주석처리) --%>
      /* if (document.getElementById('chk_subTree').checked) {
          chk_Sub = "Y";} */

      $.ajax({
        url : '/ezSchedule/getDeptUserList.do',
        method : 'GET',
        async : false,
        dataType : "xml",
        data : {
          deptID : nodeIdx.GetNodeData("CN"),
          subDept : chk_Sub
        },
        success : function(text) {
          xmlRtn = text;

          for (var i = 0 ; i < SelectNodes(xmlRtn, "DATA/ROW").length ; i++) {
            pparsingXML2 = "";
            pparsingXML = "";
            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + getNodeText(xmlRtn.getElementsByTagName("CN")[i]) + "</DATA1>";
            pparsingXML = pparsingXML + "<DATA2><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DISPLAYNAME")[i]) + "]]></DATA2>";
            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DISPLAYNAME2")[i]) + "]]></DATA3>";
            pparsingXML = pparsingXML + "<DATA4><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DESCRIPTION")[i]) + "]]></DATA4>";
            pparsingXML = pparsingXML + "<DATA5><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DESCRIPTION2")[i]) + "]]></DATA5>";
            pparsingXML = pparsingXML + "<DATA6><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DISPLAYNAME")[i]) + "]]></DATA6>";
            pparsingXML = pparsingXML + "<DATA7><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("TITLE")[i]) + "]]></DATA7>";
            pparsingXML = pparsingXML + "<DATA8>" + getNodeText(xmlRtn.getElementsByTagName("TELEPHONENUMBER")[i]) + "</DATA8>";
            pparsingXML = pparsingXML + "<DATA9>" + nodeIdx.GetNodeData("CN") + "</DATA9>";
            pparsingXML = pparsingXML + "<DATA10>" + nodeIdx.GetNodeData("CN") + "</DATA10>";

            if (lang == "1") {
            	pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DISPLAYNAME")[i]) + "]]></VALUE></CELL></ROW>";
            } else {
            	pparsingXML = pparsingXML + "<VALUE><![CDATA[" + getNodeText(xmlRtn.getElementsByTagName("DISPLAYNAME2")[i]) + "]]></VALUE></CELL></ROW>";
            }

            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
            Resultxml = loadXMLString(pparsingXML2);

            var listid = "MsgToList";
            var listview = new ListView();
            listview.LoadFromID(listid);

            var MaxID = 0;
            var InitTr = listview.GetDataRows();

            if (getNodeText(xmlRtn.getElementsByTagName("CN")[i]) == "<c:out value='${userInfo.id}' />") {
              	continue;
            }
            //else {}
            if (listview.ExistRow("DATA1", getNodeText(xmlRtn.getElementsByTagName("CN")[i]))) {
            	continue;
            }

            var MaxCntNum = 0;
            for (var j = 0  ; j < InitTr.length  ; j++) {
              var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
              if (MaxID < curnum) {
                MaxID = curnum;
                MaxCntNum = j;
              }
            }

            var objTr = listview.AddRow(InitTr.length);
            if (MaxCntNum != 0) {
            	MaxCntNum = MaxCntNum + 1;
            }
            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
            listview.AddDataRow(objTr, Resultxml);

            var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
            for (var y = 0; y < _tdlength; y++) {
            	document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
            	document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
            }
          }
        },
        error : function(jqXHR, textStatus, errorThrown) {

        }
      });
    }
    var BlockSize = 10;
    function td_Create1(strtext) {
      document.getElementById("tblPageRayer").innerHTML = strtext;
    }
    function makePageSelPage() {
      var strtext;
      var PagingHTML = "";
      document.getElementById("tblPageRayer").innerHTML = "";
      strtext = "<div class='pagenavi'>";
      PagingHTML += strtext;
      var pageNum = CurPage;
      if (totalPage > 1 && pageNum != 1) {
        strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
        PagingHTML += strtext;
      }
      else {
        strtext = "<span class='btnimg first disabled'></span>";
        PagingHTML += strtext;
      }
      if (totalPage > BlockSize) {
        if (pageNum > BlockSize) {
          strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
          PagingHTML += strtext;
        }
        else {
          strtext = "<span class='btnimg prev disabled'></span>";
          PagingHTML += strtext;
        }
      }
      else {
        strtext = "<span class='btnimg prev disabled'></span>";
        PagingHTML += strtext;
      }
      var MaxNum;
      var i;
      var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
      if (totalPage >= (startNum + parseInt(BlockSize))) {
        MaxNum = (startNum + parseInt(BlockSize)) - 1;
      }
      else {
        MaxNum = totalPage;
      }
      for (i = startNum; i <= MaxNum; i++) {
        if (i == pageNum) {
          strtext = "<span class='on'>" + i + "</span>";
          PagingHTML += strtext;
        }
        else {
          strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
          PagingHTML += strtext;
        }
      }
      if (totalPage > BlockSize) {
        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
          strtext = "";
          strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
          PagingHTML += strtext;
        }
        else {
          strtext = "";
          strtext = strtext + "<span class='btnimg next disabled'></span>";
          PagingHTML += strtext;
        }
      }
      else {
        strtext = "";
        strtext = strtext + "<span class='btnimg next disabled'></span>";
        PagingHTML += strtext;
      }
      if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
        strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
        PagingHTML += strtext;
      }
      else {
        strtext = "<span class='btnimg last disabled'></span>";
        PagingHTML += strtext;
      }
      PagingHTML += "</div>";
      td_Create1(PagingHTML);
    }
    function goToPageByNum(Value) {
      p_ListOrderObject = "";
      listContentArry = new Array();

      CurPage = Value;
      makePageSelPage();
      movePage(CurPage);
    }
    function selbeforeBlock() {
      var pageNum = parseInt(CurPage);
      pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
      goToPageByNum(pageNum);
    }
    function selbeforeBlock_one() {
      var pageNum = parseInt(CurPage);
      if (parseInt(pageNum - 1) > 0)
        goToPageByNum(parseInt(pageNum - 1));
      else
        return;
    }
    function selafterBlock() {
      var pageNum = parseInt(CurPage);
      pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
      goToPageByNum(pageNum);
    }
    function selafterBlock_one() {
      var pageNum = parseInt(CurPage);
      if (parseInt(pageNum + 1) <= totalPage)
        goToPageByNum(parseInt(pageNum + 1));
      else
        return;
    }
    function movePage(newPage) {
      if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
        CurPage = newPage;
        if (issearch)
          search_click();
        else
          displayUserList();
      }
    }
    function prevPage_onclick() {
      newPage = parseInt(CurPage) - 1;
      if (newPage > 0) {
        CurPage = newPage;
        if (issearch)
          search_click();
        else
          displayUserList();
      }
    }
    function nextPage_onclick() {
      newPage = parseInt(CurPage) + 1;
      if (newPage <= parseInt(totalPage)) {
        CurPage = newPage;
        if (issearch)
          search_click();
        else
          displayUserList();
      }
    }

    function setOrganListType(pListType) {
      $.ajax({
        type : "POST",
        dataType : "text",
        url : "/ezOrgan/setListType.do",
        async : false,
        data : {
          listType : pListType
        },
        success : function(result) {

        }

      })
    }

    function getOrganListType() {
      var organListType = "TXT";
      $.ajax({
        type : "POST",
        dataType : "text",
        url : "/ezOrgan/getListType.do",
        async : false,
        success : function(result) {
          organListType = result;
        }
      })
      return organListType;
    }

    //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
    function deptNameLong(containLow, strIsLeaf) {
      var deptNameWidth = "";
      var sum = $("#spn_deptName").width() + $("#countInfo").width();

      if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
        if (sum > 359) {
          deptNameWidth = 360 - $("#countInfo").width();
        }
      } else {
        if (sum > 357) {
          deptNameWidth = 358 - $("#countInfo").width();
        }
      }

      $("#spn_deptName").css("width", deptNameWidth);
    }
  </script>
</head>
<body class="popup" style="overflow:hidden">
<form method="post">
  <h1><spring:message code='ezSchedule.ljeGs003' /></h1>
  <div id="close">
    <ul>
      <li><span onclick="window.close()"></span></li>
    </ul>
  </div>
  <table class="popuplist" width="100%">
    <tr>
      <th style="width:120px; white-space:nowrap; text-align:center"><spring:message code='ezSchedule.ljeGs004' /></th>
      <td style="width:200px">
        <input type="text" id="groupname" style="WIDTH:200px; height: 23px;">
      </td>
      <th style="width:120px; white-space:nowrap; text-align:center"><spring:message code='ezSchedule.ljeGs005' /></th>
      <td>
        <input name="text" type="text" id="description" style="WIDTH:100%; height: 23px;">
      </td>
    </tr>
  </table>
  <br/>
  <table style="width:100%;margin-top: -6px;">
    <tr>
      <td>
        <table id="TreeViewTD">
          <tr>
            <td>
              <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
                  <table style="margin-top: 3px; width: 100%;">
                    <tr>
                      <td>
                        <div style="margin-left: 5px;">
                          <select id="search_type" style="height: 22px;">
                            <option selected value="displayname" usedefault="1"><spring:message code='ezSchedule.t18' /></option>
                            <option value="description" usedefault="1"><spring:message code='ezSchedule.t12' /></option>
                            <option value="title" usedefault="1"><spring:message code='ezSchedule.t14' /></option>
                            <option value="telephonenumber" usedefault="1"><spring:message code='ezSchedule.t1050' /></option>
                            <option value="mobile" usedefault="0"><spring:message code='ezSchedule.t1051' /></option>
                            <option value="HomePhone" usedefault="0"><spring:message code='ezSchedule.t20' /></option>
                            <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezSchedule.t21' /></option>
                            <option value="mail" usedefault="0"><spring:message code='ezSchedule.t22' /></option>
                            <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezSchedule.t23' /></option>
                          </select>
                          <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px; height: 22px;">
                          <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezSchedule.t24' /></span></a>
                        </div>
                      </td>
                      <td>
                        <div style="float: right; margin-right: 5px;">
                          <%-- 2018-05-07 천성준 - 하위부서포함 체크박스 주석처리 (하위부서 쿼리 에러 관련 주석처리) --%>
                          <%-- <input type="checkbox" id="chk_subTree" /><span style="vertical-align:top; padding-top:3px;display:inline-block"><spring:message code='ezSchedule.t39' /></span> --%>
                          <a class="imgbtn"><span onclick="Add_Dept()"><spring:message code='ezSchedule.t00004' /></span></a>
                          <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezSchedule.t1052' /></span></a>
                        </div>
                      </td>
                    </tr>
                  </table>
                </div>
              </div>
              <table style="margin-top: 3px;">
                <tr>
                  <td class="box" style="border-right:0px;">
                    <div style="width: 220px; height: 467px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
                  </td>
                  <td></td>
                  <td class="listview" style="width: 426px" id="orglistView">
                    <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
                      <tr>
                        <th style="white-space:normal;background-color: white;border-top:1px solid #ddd;border-bottom:1px solid #eaeaea">
                          <span id="SelectDeptNM" style="font-weight: normal; width: 380px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
                          <span style="float:right;margin-top: 1px;margin-right: 1px;">
		                                                        <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
		                                                        <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
		                                                    </span>
                        </th>
                      </tr>
                    </table>
                    <div style="vertical-align: top; height: 391px; overflow: auto; width: 440px;" id="txtlist_Layer">
                      <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
                        <tr>
                          <td style="width: 150px;color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezSchedule.t18' /></td>
                          <td style="width: 130px;color:#333;background-color: #f8f8fa"><spring:message code='ezSchedule.t14' /></td>
                          <td style="color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezSchedule.t1050' /></td>
                        </tr>
                      </table>
                      <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
                        <tr>
                          <td style="width: 130px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezSchedule.t12' /></td>
                          <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezSchedule.t18' /></td>
                          <td style="width: 90px; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezSchedule.t14' /></td>
                          <td class="td_gray" style="color:#333;background-color: #f8f8fa"><spring:message code='ezSchedule.t1050' /></td>
                        </tr>
                      </table>
                    </div>
                    <div style="vertical-align: top; text-align: center; height: 391px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
                    <div id="tblPageRayer" style="text-align:center;border-top:1px;"></div>
                  </td>
                </tr>
              </table>
            </td>
            <td style="width: 30px; text-align: center;">
              <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
              <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
            </td>
            <td style="vertical-align: top;">
              <h2 id="ToTitle" class="receiver_tltype01">
                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezSchedule.t00001' /></span>
              </h2>
              <div class="receiver_borderbox">
                <div id="ListViewMsgTo" ondragover ="onDragEnter(event)" ondrop ="onDrop(event, this)" style="width: 267px; Height: 478px; overflow-x: auto; overflow-y: auto;"  ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
              </div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
  <div class="btnposition btnpositionNew">
    <a class="imgbtn" onClick="close_onclick()" ><span><spring:message code='ezSchedule.t4' /></span></a>
  </div>
</form>
</body>
</HTML>
