<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Doc24DeptInfo.aspx.cs" Inherits="Kaoni.ezStandard.Doc24DeptInfo" %>
<!DOCTYPE html>
<html>
<head>
    <title>상세보기</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css"> 
</head>
<body class="popup" style="background-color: #ffffff; overflow: hidden">
    <h1>상세보기</h1>       
    <div id="close">
		<ul>
			<li><span style="width: 60px; text-align: center;" onclick="btncancel_onclick(true)"><%=RM.GetString("t1761")%></span></li>
        </ul>
    </div>
    <div class="layout" id="LayerPopupLayout">
        <table class="content">
            <tr>
                <th>사업장명</th>
                <td id="tdcmpnyNm"></td>
            </tr>
            <tr>
                <th>발신인명의</th>
                <td id="tdSenderNm"></td>
            </tr>
            <tr>
                <th>사업자등록번호</th>
                <td id="tdbizrno"></td>
            </tr>
            <tr>
                <th>법인등록번호</th>
                <td id="tdjurirno"></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td id="tdtelnum"></td>
            </tr>
            <tr>
                <th>FAX번호</th>
                <td id="tdfxnum"></td>
            </tr>
            <tr>
                <th>우편번호</th>
                <td id="tdzip"></td>
            </tr>
            <tr>
                <th>사업장 기본주소 <br />(도로명주소)</th>
                <td id="tdadres"></td>
            </tr>
            <tr>
                <th>사업장 상세주소</th>
                <td id="tddetailAdres"></td>
            </tr>
        </table>
    </div>
    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
     <script type="text/javascript">
         var RetValue;
         var ReturnFunction;
         window.onload = function () {
             //LayerPopupLayoutSize();
            try {
                RetValue = parent.Doc24Info__dialogArguments[0];
                ReturnFunction = parent.Doc24Info__dialogArguments[1];
            } catch (e) {
                try {
                    RetValue = opener.Doc24Info__dialogArguments[0];
                    ReturnFunction = opener.Doc24Info__dialogArguments[1];
                } catch (e) {
                    RetValue = window.dialogArguments;
                }
             }

             if (RetValue != null) {
                 initInfo(RetValue);
             }
         }

         function initInfo(info) {
            var  xmlhttp = createXMLHttpRequest();
            var xmlpara = createXmlDom();
            var objNode;
            createNodeInsert(xmlpara, objNode, "DATA");
            createNodeAndInsertText(xmlpara, objNode, "ORGCD", info);
            xmlhttp.open("POST", "/myoffice/ezApprovalG/ezOrganG/Doc24/GetDoc24Deptinfo.aspx", false);
            xmlhttp.send(xmlpara);

             if (xmlhttp.status == 200) {
			 
                 if (xmlhttp.responseText == "")
                 {
                     btncancel_onclick(false);
                 }
                 else {
                    var dates = JSON.parse(xmlhttp.responseText);
                     if (dates.length > 0) {
                         document.getElementById("tdcmpnyNm").innerHTML = dates[0].cmpnyNm;
                         document.getElementById("tdSenderNm").innerHTML = dates[0].senderNm;
                         document.getElementById("tdbizrno").innerHTML = dates[0].bizrno;
                         document.getElementById("tdjurirno").innerHTML = dates[0].jurirno;
                         document.getElementById("tdtelnum").innerHTML = dates[0].telnum;
                         document.getElementById("tdfxnum").innerHTML = dates[0].fxnum;
                         document.getElementById("tdzip").innerHTML = dates[0].zip;
                         document.getElementById("tdadres").innerHTML = dates[0].adres;
                         document.getElementById("tddetailAdres").innerHTML = dates[0].detailAdres; 
                     }
                }
            }
         }
         function btncancel_onclick(rtn) {
            try {               
                if (ReturnFunction != null)
                {
                    ReturnFunction(rtn);
                }
                else {
                    window.returnValue = rtn;
                    window.close();
                }
            }
            catch (e) {
                  ReturnFunction();
            }
        }
    </script>
</body>
</html>
