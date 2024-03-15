<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezAddress.t2" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<% 
			String inputYn = request.getParameter("inputYn"); 
			String roadFullAddr = request.getParameter("roadFullAddr"); 
			String roadAddrPart1 = request.getParameter("roadAddrPart1"); 
			String roadAddrPart2 = request.getParameter("roadAddrPart2"); 
			String engAddr = request.getParameter("engAddr"); 
			String jibunAddr = request.getParameter("jibunAddr"); 
			String zipNo = request.getParameter("zipNo"); 
			String addrDetail = request.getParameter("addrDetail"); 
			String admCd    = request.getParameter("admCd");
			String rnMgtSn = request.getParameter("rnMgtSn");
			String bdMgtSn  = request.getParameter("bdMgtSn");
		%>
	</head>
	<script language="javascript">
		function init() {
			try {
                ReturnFunction = opener.address_zip_select_dialogArguments[1];
            } catch (e) {
                try{
                    ReturnFunction = parent.address_zip_select_dialogArguments[1];
                }
                catch (e) {console.log(e);}
            }
            
			var url = location.href;
			var confmKey = "${confirmKey}";
			var resultType = "4"; // 도로명주소 검색결과 화면 출력내용, 1 : 도로명, 2 : 도로명+지번, 3 : 도로명+상세건물명, 4 : 도로명+지번+상세건물명
			var inputYn= "<%=inputYn%>";
			
			if (inputYn != "Y") {
				document.form.confmKey.value = confmKey;
				document.form.returnUrl.value = url;
				document.form.resultType.value = resultType;
				document.form.action="http://www.juso.go.kr/addrlink/addrLinkUrl.do"; //인터넷망
				document.form.submit();
			} else {
	            ReturnFunction("<%=roadFullAddr%>","<%=roadAddrPart1%>","<%=addrDetail%>","<%=roadAddrPart2%>",
	            		"<%=engAddr%>","<%=jibunAddr%>","<%=zipNo%>", "<%=admCd%>", "<%=rnMgtSn%>", "<%=bdMgtSn%>");
				window.close();
			}
		}	
	</script>
	<body onload="init();">
	    <form id="form" name="form" method="post">
			<input type="hidden" id="confmKey" name="confmKey" value=""/>
			<input type="hidden" id="returnUrl" name="returnUrl" value=""/>
			<input type="hidden" id="resultType" name="resultType" value=""/>
		</form>
	</body>
</html>