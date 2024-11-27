<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*" %>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.parser.ParseException"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="org.w3c.dom.*,javax.xml.parsers.*,javax.xml.transform.*, javax.xml.transform.dom.*, javax.xml.transform.stream.*,  java.util.*"%>
<%@page import="javax.xml.XMLConstants"%>
<%
request.setCharacterEncoding("utf-8");
response.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8"); 

// JSON객체 처리를 위한 변수 선언
StringBuffer jsonBuffer = new StringBuffer();
JSONObject jsonObj = null;
String json = null;

String line = null;

// X-Free Editor(env.xml)
Element edit = null;

// X-Free Uploader(config.xml)
Element xFreeUploaderConfig = null;

// X-Free Uploader(다국어xml)
Element xFreeUploaderLang = null;

try {
    BufferedReader reader = request.getReader();
    
    while((line = reader.readLine()) != null) {
        jsonBuffer.append(line);
    }
	//out.println(jsonBuffer.toString());
	
	JSONParser parser = new JSONParser();	
	JSONArray jsonArr = (JSONArray) parser.parse(jsonBuffer.toString());
	int jsonArrCnt = jsonArr.toArray().length;
	
	// 제품 분기 처리
	jsonObj = (JSONObject) jsonArr.get(0);
	String product = (String) jsonObj.get("solution");
	
	// 저장할 xml경로
	String savePath = getServletContext().getRealPath("/") + (String) jsonObj.get("savePath");
	
	DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
	DocumentBuilder docBuilder = builderFactory.newDocumentBuilder();
	Document doc = docBuilder.newDocument();
	
	// 루트정보 생성
	// X-Free Editor(env.xml)
	if(product.equals("xfeEnv")){
		
		// 최상위 노드 생성(XFU)
		edit = doc.createElement("edit");
		doc.appendChild(edit);		
	}
	
	// AD
	else if(product.equals("ad")){
				
	}
	
	// X-Free Uploader(config.xml)
	else if(product.equals("xfuConfig")){		
	
		// 최상위 노드 생성(XFU)
		xFreeUploaderConfig = doc.createElement("xFreeUploaderConfig");
		doc.appendChild(xFreeUploaderConfig);
	}
	
	// X-Free Uploader(다국어xml)
	else if(product.equals("xfuLanguage")){		
	
		// 최상위 노드 생성(XFU)
		xFreeUploaderLang = doc.createElement("xFreeUploader");
		doc.appendChild(xFreeUploaderLang);
	}
	
	
	// 자식노드를 생성
	for(int i=0; i<jsonArrCnt; i++){
		jsonObj = (JSONObject) jsonArr.get(i);
		
		// X-Free Editor(env.xml)
		if(product.equals("xfeEnv")){
			
			// json데이터 요소 세팅
			String nodename = (String) jsonObj.get("nodename");
			String apply = (String) jsonObj.get("apply");
			String data = (String) jsonObj.get("data");
			String remark = (String) jsonObj.get("remark");
			
			// 클라이언트단에 출력
			//out.println(nodename + "\t" + apply + "\t" + data);
			
			// 하위 노드 생성
			Element nodeKey = doc.createElement(nodename);			
			edit.appendChild(nodeKey);
			
			// 아래와 같이 env.xml의 항목의 구성 중에서 통일된 패턴끼리 분기처리 시도함...
			// env.xml의 항목추가시 "apply"키값을 제외한 새로운 attribute 항목이 존재한다면 아래와 같이 분기문의 추가가 필요합니다.
			
			if(nodename.equals("FontFamilyValue") || nodename.equals("FontSizeValue") || nodename.equals("LineHeightValue") || nodename.equals("LetterSpacingValue")){
				
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("style", (String) jsonObj.get("style"));
				nodeKey.setAttribute("width", (String) jsonObj.get("width"));
				
				// 데이터가져오기
				nodeKey.setTextContent(data);
			}
			
			else if(nodename.equals("LimitImageSize")){				
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("width", (String) jsonObj.get("width"));
				nodeKey.setAttribute("height", (String) jsonObj.get("height"));
				
				// 데이터가져오기
				nodeKey.setTextContent(data);
			}
			
			else if(nodename.equals("TableCellParagraph")){
				
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("style", (String) jsonObj.get("style"));
			}
			
			else if(nodename.equals("SetInitParagraphStyle")){				
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("action", (String) jsonObj.get("action"));
				nodeKey.setAttribute("style", (String) jsonObj.get("style"));
			}
			
			else if(nodename.equals("ShowGrid")){				
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("color", (String) jsonObj.get("color"));
				nodeKey.setAttribute("size", (String) jsonObj.get("size"));
				nodeKey.setAttribute("type", (String) jsonObj.get("type"));
				nodeKey.setAttribute("repeat", (String) jsonObj.get("repeat"));
				
				// 데이터가져오기
				nodeKey.setTextContent(data);
			}
			
			else if(nodename.equals("ShowVerticalLine")){			
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("left", (String) jsonObj.get("left"));
				nodeKey.setAttribute("color", (String) jsonObj.get("color"));
				nodeKey.setAttribute("style", (String) jsonObj.get("style"));
			}
			
			else if(nodename.equals("IndentSize")){				
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("type", (String) jsonObj.get("type"));
				
				// 데이터가져오기
				nodeKey.setTextContent(data);
			}
			
			else if(nodename.equals("AutoSave")){				
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("time", (String) jsonObj.get("time"));
			}
			
			else if(nodename.equals("ShowRuler")){				
			
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("state", (String) jsonObj.get("state"));
			}
			
			// ExceptionTagType
			else if(nodename.equals("ExceptionTagType")){
				
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				
				// 하위 노드(nodeName) 생성
				String[] nodeArr = data.split(",");
				for(int na=0; na<nodeArr.length; na++){
					Element childNodeET = doc.createElement("nodeName");
					nodeKey.appendChild(childNodeET);
					childNodeET.setTextContent(nodeArr[na]);
				}
			}
			
			// ReplaceExpression
			else if(nodename.equals("ReplaceExpression")){
				
				// 하위 노드 데이터 가져오기
				JSONObject jsonDataObj = (JSONObject) jsonObj.get("objData");		

				// key set 받아오기 
				Set key = jsonDataObj.keySet();

				// Iterator 설정
				Iterator<String> iter = key.iterator();

				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				nodeKey.setAttribute("alert", (String) jsonObj.get("a_lert"));

				// 각각 키 값 출력. 
				// 하위 노드(findExpression) 생성
				while(iter.hasNext())
				{
					String keyname = iter.next();
					//out.println("key : "+keyname+" value : "+jsonDataObj.get(keyname));					
					Element childNodeRE = doc.createElement("findExpression");
					nodeKey.appendChild(childNodeRE);
					childNodeRE.setAttribute("Replace", keyname);
					childNodeRE.setTextContent(jsonDataObj.get(keyname).toString());
				}				
			}
			
			// 위의 분기문과는 다르게 apply attribute키값과 데이터값 2가지만 존재하는 기본적인 경우에만 자동처리.
			else{
				
				// attribute가져오기
				nodeKey.setAttribute("apply", apply);
				
				// 데이터가져오기
				nodeKey.setTextContent(data);
			}	

			
			if(!remark.equals("")){
				
				// 주석내용 세팅의 패턴이 통일성 있기 때문에 이 시점에서 한꺼번에 세팅한다.
				Comment comment = doc.createComment(remark);
				
				// 여태까지 만들었던 항목들(nodeKey) 을 이 시점에서 세팅한다.
				nodeKey.getParentNode().insertBefore(comment, nodeKey);			
			}
			
			// 각 노드 항목끼리의 구분을 위해 빈 행을 넣어 구분
			Comment comment2 = doc.createComment("");
			nodeKey.getParentNode().appendChild(comment2);			
		}
		// AD
		else if(product.equals("ad")){
					
		}
		// X-Free Uploader(config.xml)
		else if(product.equals("xfuConfig")){		
			// json데이터 요소 세팅
			String nodename = (String) jsonObj.get("nodename");
			String apply = (String) jsonObj.get("apply");
			String data = (String) jsonObj.get("data");
			String remark = (String) jsonObj.get("remark");
			
			// 클라이언트단에 출력
			//out.println(nodename + "\t" + apply + "\t" + data);
			
			// 하위 노드 생성
			Element nodeKey = doc.createElement(nodename);
			
			xFreeUploaderConfig.appendChild(nodeKey);
			nodeKey.setAttribute("apply", apply);
			nodeKey.setTextContent(data);
			
			// 주석 세팅
			if(!remark.equals("")){
				Comment comment = doc.createComment(remark);
				nodeKey.getParentNode().insertBefore(comment, nodeKey);						
			}
			Comment comment2 = doc.createComment("");
			nodeKey.getParentNode().appendChild(comment2);
		}
		
		// X-Free Uploader(다국어xml)
		else if(product.equals("xfuLanguage")){		
			// json데이터 요소 세팅
			String nodename = (String) jsonObj.get("key");
			String data = (String) jsonObj.get("data");
			
			// 하위 노드 생성
			Element nodeKey = doc.createElement(nodename);
			
			xFreeUploaderLang.appendChild(nodeKey);
			nodeKey.setTextContent(data);	
		}
	}
	
	// 파일생성 부분
	TransformerFactory transformerFactory = TransformerFactory.newInstance();
	//commiro - 20240430
	transformerFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
	transformerFactory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
	
	transformerFactory.setAttribute("indent-number", new Integer(4));	
	Transformer transfomer = transformerFactory.newTransformer();
	
	// doctype 설정
	DOMImplementation domImpl = doc.getImplementation();
	DocumentType doctype = domImpl.createDocumentType("doctype", "-//Oberon//YOUR PUBLIC DOCTYPE//EN", "configuration");
	//transfomer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, doctype.getPublicId());
	transfomer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, doctype.getSystemId());
	
	// 옵션정의
	transfomer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	transfomer.setOutputProperty(OutputKeys.INDENT, "yes");
	
	// xml문서를 DOM에 담는다.
	DOMSource source = new DOMSource(doc);	
	StringWriter sw = new StringWriter();	
	StreamResult result = new StreamResult(sw);
	
	// xml이 담긴 dom, 저장될 파일경로
	transfomer.transform(source, result);
	
	// xml파일 생성
	// 노드간의 구분을 위한 빈행 처리를 위한 차선책
	String xmlString = sw.toString().replaceAll("<!---->", "");
	
	// 클라이언트단에 출력
	out.println(xmlString);
		
	//한글 인코딩 에러 발생(주석 처리)
	/*
	File file = null;		
	file = new File(savePath);			
	BufferedWriter bw = new BufferedWriter(new FileWriter(file, false));		
	*/
	
	// SW취약점 - 외부 입력 변수 값에 대하여 공격의 위험이 있는 문자( “ / ￦ .. 등 )를 제거할 수 있는 조작 방지 필터 처리
	savePath = cleanXSS(savePath);
	
	// 한글 인코딩 가능(UTF-8)
	BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(savePath), "UTF-8"));	
	bw.write(xmlString);
	bw.flush();	
	bw.close();		
}

catch(Exception e) {
	
    System.out.println("Error reading JSON string: " + e.toString());
	out.println(e.toString());
}



%>
<%!
private String cleanXSS(String value) {
	
	value = value.replaceAll("<", "& lt;").replaceAll(">", "& gt;");
	value = value.replaceAll("\\(", "& #40;").replaceAll("\\)", "& #41;");
	value = value.replaceAll("'", "& #39;");
	value = value.replaceAll("eval\\((.*)\\)", "");
	value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
	value = value.replaceAll("script", "");
	value = value.replaceAll("\\.{2,}[/\\\\]", "");

	return value;
}
%>