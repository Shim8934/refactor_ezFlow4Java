<%@page contentType="text/html; charset=UTF-8" %>
<%@page import="java.io.*"%>
<%@page import ="java.net.*"%>
<%@page import="java.util.regex.PatternSyntaxException"%>
<%	String ce_domain = ""; String ce_exp = ""; %>
<%@include file="EditorInformation.jsp"%>
<%@include file="Util.jsp"%>
<%@include file="SecurityTool.jsp"%>
<%
	String check_uri = "http://crosseditor.namo.co.kr/application/CELicenseCheck.php";
	String authHostInfo = "";
	String conkey =  detectXSSEx(request.getParameter("connection"));
	
	if(conkey != null && conkey.equalsIgnoreCase("ServerGr")){
		try {
                InetAddress addr = InetAddress.getByName(request.getHeader("host"));
                byte[] ipAddr = addr.getAddress();
                // Convert to dot representation
                String ipAddrStr = "";
                for (int i=0; i<ipAddr.length; i++) {
                          if (i > 0) {
                                     ipAddrStr += ".";
                          }
                          ipAddrStr += ipAddr[i]&0xFF;
                }                               
                authHostInfo = ipAddrStr;
		 } catch (UnknownHostException e) {
				authHostInfo = "";
		 }
	}
	else {
		authHostInfo =  request.getHeader("host");
	}
	
	check_uri += "?editordomain=" + authHostInfo;
	check_uri += "&serial=" + ce_serial;
	check_uri += "&editorkey=" + ce_editorkey;
	String editorkey = request.getParameter("editorkey");	
	String conval = ce_domain + "|" + ce_use + "|" + ce_exp + "|" + authHostInfo;

	if (editorkey != "" && editorkey != null){
		if (editorkey.equalsIgnoreCase("ProductInfo")){
			String returnParam = ce_company + "|";
			returnParam += ce_use + "|";
			returnParam += ce_serial + "|";
			returnParam += ce_lkt;
			response.getWriter().println(detectXSSEx(returnParam));
		}else{
			if (createEncodeEditorKey(ce_editorkey).equalsIgnoreCase(editorkey)){
				response.getWriter().println("SUCCESS");
			}else{
				response.getWriter().println("NULL");
			}
		}
	}else{
		String checkAuth = getEditorAuth(check_uri, conkey, conval);
		if (!checkAuth.equalsIgnoreCase("false")){
			if (checkAuth.equalsIgnoreCase("true")){
				response.getWriter().println(detectXSSEx(createEncodeEditorKey(ce_editorkey)));
			}else{
				response.getWriter().println(detectXSSEx(checkAuth));
			}
		}else{
			response.getWriter().println("NULL");
		}
	}

%>