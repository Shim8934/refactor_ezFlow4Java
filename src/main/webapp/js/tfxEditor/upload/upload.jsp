
<%@ page contentType = "text/html;charset=utf-8" %>
<%@ page import = "java.io.*,
                   java.util.*,
                   com.oreilly.servlet.MultipartRequest,
                   com.oreilly.servlet.multipart.DefaultFileRenamePolicy"
%>
<%
	//Refused to display 'http://...../upload.jsp' in a frame because it set 'X-Frame-Options' to 'DENY'.
	// 위의 메세지가 나올 경우 아래 참조.
	//http://dev.naver.com/projects/smarteditor/issue/86534
	//response.setHeader("X-Frame-Options", "SAMEORIGIN");

%>
<%!
	public String usf_replace(String src, String oldstr, String newstr)
	{
		if (src == null) return null;
		StringBuffer dest = new StringBuffer("");
		try
		{
			int  len = oldstr.length();
			int  srclen = src.length();
			int  pos = 0;
			int  oldpos = 0;

			while ((pos = src.indexOf(oldstr, oldpos)) >= 0)
			{
				dest.append(src.substring(oldpos, pos));
				dest.append(newstr);
				oldpos = pos + len;
			}

			if (oldpos < srclen)
				dest.append(src.substring(oldpos, srclen));
		}
		catch ( Exception e )
		{
			e.printStackTrace();
		}
		return dest.toString();
	}

	public boolean FileExists(String sPath) throws Exception
	{
		File file = new File(sPath);
		if (file.exists())
			return true;
		else
			return false;
	}
	
	 /**
     * 파일의 확장자를 체크하여 필터링된 확장자를 포함한 파일인 경우에 true를 리턴한다.
     * @param extension
     * */
    public static boolean checkWhiteList(String extension) {
		 
        String ext = extension.substring(extension.lastIndexOf(".") + 1, extension.length());
        
        final String[] WHITE_EXTENSION = { "jpg", "jpeg", "gif", "png", "mp4", "swf" };
 
        int len = WHITE_EXTENSION.length;
        
        for (int i = 0; i < len; i++) {
        	
            if (ext.equalsIgnoreCase(WHITE_EXTENSION[i])) {
                return true; 
            }
        }
        
        return false;
    }
	 
%>
<%
	// 파일 용량 제한 : JSP 단에서는 2^31-1 bytes로 (integer max, 2147483647 bytes == 2GB - 1 byte)
	int sizeLimit = (2 * 1024 * 1024 * 1024 - 1);

	// 업로드 폴더 경로 : 날짜별로 폴더 생성
	String sDate = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	String savePath = getServletContext().getRealPath(request.getServletPath());
	int pos = -1;
	if ((pos = savePath.lastIndexOf("/")) > 0)
	{
		savePath = savePath.substring(0, pos+1) + sDate;
	}
	else if ((pos = savePath.lastIndexOf("\\")) > 0)
	{
		savePath = savePath.substring(0, pos+1) + sDate;
	}

	String saveRelativePath = request.getRequestURI();
	pos = saveRelativePath.lastIndexOf("/");
	saveRelativePath = saveRelativePath.substring(0, pos+1) + sDate;

	// 업로드 폴더 생성
	File dir = new File(savePath);
	dir.mkdir();

	// Windows file system인 경우 MultipartRequest에서 인식할 수 있는 경로 스타일로 바꿔줘야..
	if ((pos = savePath.lastIndexOf("/")) == -1)
	{
		if ((pos = savePath.indexOf(":\\")) > 0)
		{
			// TOMCAT에서는 드라이브 명 ("D:\\") 굳이 제거하지 않아도 잘 인식하는 듯..
			// 나중에 혹시나 싶어서 코멘트 남겨 둠..
			// savePath = "/" + savePath.substring(pos+2, savePath.length());
			savePath = usf_replace(savePath, "\\", "/");
		}
	}

	// cos(com.oreilly.servlet)의 MultipartRequest를 이용해서 업로드 !!!
	MultipartRequest single = new MultipartRequest( request, savePath, sizeLimit, "UTF-8", new DefaultFileRenamePolicy() );

	
	// 업로드 후 파일 정보 가져오기
	// MultipartRequest로 전송받은 데이터를 불러온다.
	// enctype을 "multipart/form-data"로 선언하고 submit한 데이터들은 request객체가 아닌 MultipartRequest객체로 불러와야 한다.
	Enumeration eFileNames = single.getFileNames();
	String sParamName = eFileNames.nextElement().toString();
	String sFileName_Org = single.getOriginalFileName(sParamName);
	String sFileName_Gen = single.getFilesystemName(sParamName);
	String sExtension = sFileName_Org.substring(sFileName_Org.lastIndexOf("."));

	// content type
	// 2009.12.22 bhkwon : multipart/form-data로 POST한 경우,
	//                     일반 request.getParameter() 메소드로는 인자 값을 받아올 수 없다.
	//                     ==> cos(com.oreilly.servlet)의 MultipartRequest 객체를 사용하면 된다.
	String sContentType = single.getParameter("content_type");
	String sFileNameHead = "";
	
	if (sContentType.equals("flash")) {
		sFileNameHead = "FLA_";
	} else {
		sFileNameHead = "IMG_";
	}

	String sUploadedPath = "";
	String sErrorLog = "";
	
	if(checkWhiteList(sExtension)) {
	
		// 파일 이름 규칙 적용
		String sTime = new java.text.SimpleDateFormat("HHmmss").format(new java.util.Date());
		String sNewFName = sFileNameHead + sTime + sExtension;
		
		int index = 1;
		
		
		while (FileExists(savePath + "/" + sNewFName) && index < 100) {
			
			sNewFName = sFileNameHead + sTime + "_" + index + sExtension;
			index += 1;
		}
	
		// 파일 이름 변경
		File file1 = new File(savePath + "/" + sFileName_Gen);
		File file2 = new File(savePath + "/" + sNewFName);
		file1.renameTo(file2);
		
		sUploadedPath = saveRelativePath + "/" + sNewFName;
		
	}
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!--script src="../config/crossdomain.js" type="text/javascript" language="javascript"></script-->
		<title>XFE UPLOAD</title>
		<script type="text/javascript">
			window.onload = function() {
				
				var strContentType = document.getElementById("divContentType").innerHTML;
				var strImagePath = document.getElementById("divImagePath").innerHTML;
				
				if (strImagePath != undefined && strImagePath != "") {
					
					var strLocation = "<%=sUploadedPath%>";
					
					if(strLocation) {						
						
						/**
						 * http://, https:// 프로토콜 체크 후 없을 경우 절대 경로.
						 * 절대 경로 일 경우 앞에 / 가 여러개 들어 갈 경우 처리.  
						 */
						if(strLocation.indexOf('http://') < 0 && strLocation.indexOf('https://') < 0) {
							
							if(/^[\/]{2,}/img.test(strLocation)) {
								strLocation = strLocation.replace(/^[\/]{2,}/img, function() {
									return '/';
								});
							}								
						}
	
						if (strContentType == "flash") {						
							//parent.insertFlash.setFlash(strLocation);
							
							if(parent.insertFlash) {
								parent.insertFlash.setFlash(strLocation);
							} else {
								parent.parent.insertFlash.setFlash(strLocation);
							}
							
						} else if (strContentType == "image") {						
							//parent.insertImage.setImage(strLocation);
							
							if(parent.insertImage) {
								parent.insertImage.setImage(strLocation);
							} else {
								parent.parent.insertImage.setImage(strLocation);	
							}
							
						}
						
					} else {
						
					}
					
				} else {
					alert("<%=sErrorLog%>");
				}
								
		
			};
		</script>
	</head>
	<body>
		<div id="divContentType"><%=sContentType%></div>
		<div id="divImagePath"><%=sUploadedPath%></div>
		<div><%=sErrorLog%></div>
	</body>
</html>
