
<%@ page pageEncoding = "UTF-8" contentType = "text/html; charset=UTF-8" %>
<%@ page import = "java.io.*,
                   java.util.*"
%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment; filename=Untitled.htm");

	out.clear();
	out = pageContext.pushBody();

	BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
	outs.write(0xEF);
	outs.write(0xBB);
	outs.write(0xBF);
	String sContent;
	if(request.getParameter("mime_contents") != null)
		sContent = request.getParameter("mime_contents");
	else
		return;
	outs.write(sContent.getBytes("UTF-8"), 0, sContent.getBytes("UTF-8").length);
	outs.flush(); 
	outs.close();
%>
