<%@ Page ContentType="text/json" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Threading.Tasks" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Xml.Linq" %>
<%@ Import Namespace="System.Windows" %>
<%@ Import Namespace="System.Windows.Forms" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="Newtonsoft.Json.Linq" %>

<script language="C#" runat="server">    
    // JSON 객체 처리를 위한 변수 선언
	public string jsonObj;

    protected void Page_Load(object sender, EventArgs e)
    {
	
        NameValueCollection nvcObj = new NameValueCollection();
        nvcObj = HttpContext.Current.Request.Form;
        var jsonObj = nvcObj.Get(0);
        dynamic json  = JsonConvert.DeserializeObject(jsonObj);

        // 솔루션 구분 Flag
		string productNm = json[0]["solution"];
        
		// 저장 경로
		string savePath = json[0]["savePath"];      				
        savePath = Page.Server.MapPath(savePath);			

        // DOM 문서 생성
        XmlDocument doc = new XmlDocument();

        // 선언문
        XmlDeclaration dec = doc.CreateXmlDeclaration("1.0", "utf-8", "");

        string rootEleName = "edit";
        if (productNm == "xfeEnv") {
            rootEleName = "edit";
        }
        else if (productNm == "ad") {

        }
        else if (productNm == "xfuConfig") {
            rootEleName = "xFreeUploaderConfig";
        }
		else if (productNm == "xfuLanguage") {
            rootEleName = "xFreeUploader";
        }

        // 루트정보 생성
        XmlElement rootEle = doc.CreateElement(rootEleName);
        doc.AppendChild(dec);
        doc.AppendChild(rootEle);

        for (int i = 0; i < json.Count; i++) {
            string strRemark = json[i]["remark"];
            string strNodename = json[i]["nodename"];
            string strApply = json[i]["apply"];
            string strData = json[i]["data"];
            string strStyle = json[i]["style"];
            string strWidth = json[i]["width"];
            string strHeight = json[i]["height"];
            string strColor = json[i]["color"];
            string strSize = json[i]["size"];
            string strType = json[i]["type"];
            string strRepeat = json[i]["repeat"];
            string strTime = json[i]["time"];
			string strAction = json[i]["action"];
			string strLeft = json[i]["left"];
			string strAlert = json[i]["a_lert"];
			string strState = json[i]["state"];

            // X-Free Editor(env.xml)
            if (productNm == "xfeEnv") {
				
				// 아래와 같이 env.xml의 항목의 구성 중에서 통일된 패턴끼리 분기처리 시도함...
				
                // FontFamilyValue / FontSizeValue / LineHeightValue / LetterSpacingValue
                if(strNodename == "FontFamilyValue" || strNodename == "FontSizeValue" || strNodename == "LineHeightValue" || strNodename == "LetterSpacingValue"){
				
                    // 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);						
					
					// 데이터가져오기
                    child.InnerText = strData;																

                    // attribute가져오기
					child.SetAttribute("apply", strApply);												
                    child.SetAttribute("style", strStyle);
                    child.SetAttribute("width", strWidth);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
                // LimitImageSize
                else if(strNodename == "LimitImageSize"){
				
					// 주석정보가져오기
                    XmlComment comment = doc.CreateComment(strRemark);				
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기
                    //child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
                    child.SetAttribute("width", strWidth);
                    child.SetAttribute("height", strHeight);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
                // TableCellParagraph
                else if(strNodename == "TableCellParagraph"){
				
                    // 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기(데이터 없어서 주석처리)
                    //child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
                    child.SetAttribute("style", strStyle);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
				// SetInitParagraphStyle
                else if(strNodename == "SetInitParagraphStyle"){
                    
					// 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기(데이터 없어서 주석처리)
                    //child.InnerText = strData;

					// attribute가져오기
                    child.SetAttribute("apply", strApply);
					child.SetAttribute("action", strAction);
                    child.SetAttribute("style", strStyle);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
                // ShowGrid
                else if(strNodename == "ShowGrid"){
				
                    // 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
                    
					// 빈행 처리
					XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기(데이터 없어서 주석처리)
                    //child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
                    child.SetAttribute("color", strColor);
                    child.SetAttribute("size", strSize);
                    child.SetAttribute("type", strType);
                    child.SetAttribute("repeat", strRepeat);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
				// ShowVerticalLine
                else if(strNodename == "ShowVerticalLine"){
				
                    // 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기(데이터 없어서 주석처리)
                    //child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
					child.SetAttribute("left", strLeft);
                    child.SetAttribute("color", strColor);
                    child.SetAttribute("style", strStyle);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
                // IndentSize
                else if(strNodename == "IndentSize"){
				
                    // 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기
                    child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
                    child.SetAttribute("type", strType);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
                // AutoSave
                else if(strNodename == "AutoSave"){
				
                    // 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기(데이터 없어서 주석처리)
                    //child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
                    child.SetAttribute("time", strTime);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
				// ShowRuler
                else if(strNodename == "ShowRuler"){
                    
					// 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
                    
					// 데이터가져오기(데이터 없어서 주석처리)
					//child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);
                    child.SetAttribute("state", strState);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
				
                // ExceptionTagType
                else if(strNodename == "ExceptionTagType"){
                    
					// 주석정보가져오기
					XmlComment comment = doc.CreateComment(strRemark);
                    
					// 빈행 처리
					XmlComment empty = doc.CreateComment(null);
                    
					// 노드명
					XmlElement child = doc.CreateElement(strNodename);
                    
					// 데이터가져오기(데이터 없어서 주석처리)
					//child.InnerText = strData;

                    // attribute가져오기
					child.SetAttribute("apply", strApply);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);

                    
					// xml하위노드 추가
					string[] nodeArr = strData.Split(new string[] { "," }, StringSplitOptions.None);

                    for (int na = 0; na < nodeArr.Length; na++) {
                        XmlElement child2 = doc.CreateElement("nodeName");
                        child2.InnerText = nodeArr[na];
                        child.AppendChild(child2);
                    }
					
					// 빈 행 추가
                    //rootEle.AppendChild(empty);
                }
				
                // ReplaceExpression
                else if(strNodename == "ReplaceExpression"){
				
					// 주석정보가져오기
                    XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기
                    child.InnerText = strData;
                    
					// attribute가져오기
					child.SetAttribute("apply", strApply);
					child.SetAttribute("alert", strAlert);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    
					// xml하위노드 추가
                    var jsonDataObj = json[i]["objData"];                    
                    foreach (var element in jsonDataObj) {
                        string oKey = element.Name;
                        string oValue = element.Value;
                        
                        XmlElement child2 = doc.CreateElement("findExpression");
                        child2.InnerText = oValue;
                        child2.SetAttribute("Replace", oKey);

                        child.AppendChild(child2);
                    }
					
					// 빈 행 추가
                    //rootEle.AppendChild(empty);
                }
				
				// 위의 분기문과는 다르게 apply attribute키값과 데이터값 2가지만 존재하는 기본적인 경우에만 자동처리.
                else{
				
					// 주석정보가져오기
                    XmlComment comment = doc.CreateComment(strRemark);
					
					// 빈행 처리
                    XmlComment empty = doc.CreateComment(null);
					
					// 노드명
                    XmlElement child = doc.CreateElement(strNodename);
					
					// 데이터가져오기
                    if (!String.IsNullOrEmpty(strData)) {
                        child.InnerText = strData;
                    }
					
					// attribute가져오기
                    child.SetAttribute("apply", strApply);

                    // xml노드 추가
					rootEle.AppendChild(comment);
                    rootEle.AppendChild(child);
                    //rootEle.AppendChild(empty);
                }
            }
            // Active Designer
            else if (productNm == "ad") {

            }
			
            // X-Free Uploader(config.xml)
            else if (productNm == "xfuConfig") {
                XmlComment comment = doc.CreateComment(strRemark);
                XmlComment empty = doc.CreateComment(null);
                XmlElement child = doc.CreateElement(strNodename);
                child.InnerText = strData;
                child.SetAttribute("apply", strApply);

                rootEle.AppendChild(comment);
                rootEle.AppendChild(child);
                rootEle.AppendChild(empty);
            }
			
			// X-Free Uploader(다국어xml)
			else if (productNm == "xfuLanguage") {
                string strNodename2 = json[i]["key"];
				XmlElement child = doc.CreateElement(strNodename2);
                child.InnerText = strData;

                rootEle.AppendChild(child);
            }
        }

        /*
        string xmlcode = doc.OuterXml;
        xmlcode = xmlcode.Replace("<!---->", "");
        doc.WriteTo(xmlcode);
        Response.Write(xmlcode);
        */

        //출력
        doc.Save(savePath);
        Response.Write(doc.OuterXml);
    }
</script>