using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;

//URL 정보 이용할 때 필요
using System.Net;

//로컬패스 이용할 때 필요
using System.IO;
using System.Text;
using System.Configuration;


namespace Kaoni
{
	namespace ezStandard
	{
		/// <summary>
		/// DHTMLCon에 대한 요약 설명입니다.
		/// </summary>
        public partial class MHTtoHTML_Content : ezWebBase
		{
            protected void Page_Load(object sender, System.EventArgs e)
            {
                try
                {
                    string pHref = string.Empty;
                    string pType = string.Empty;
                    string pDocID = string.Empty;

                    if (Request.QueryString["href"] != null)
                        pHref = ReplaceXSS(Request.QueryString["href"]);
                    if (Request.QueryString["TYPE"] != null)
                        pType = ReplaceXSS(Request.QueryString["TYPE"]);
                    if (Request.QueryString["DOCID"] != null)
                        pDocID = ReplaceXSS(Request.QueryString["DOCID"]);
                    if(pType.Equals(""))
                        pHref = GetSystemConfigValue("ServerPath").ToString().Substring(0, GetSystemConfigValue("ServerPath").ToString().IndexOf("myoffice/") + 9) + "CKEditor/MHTtoHTML_Get.aspx?strURL=" + pHref;
                    else
                        pHref = GetSystemConfigValue("ServerPath").ToString().Substring(0, GetSystemConfigValue("ServerPath").ToString().IndexOf("myoffice/") + 9) + "CKEditor/MHTtoHTML_Get.aspx?strURL=" + pHref + "&TYPE=" + pType + "&DOCID=" + pDocID;
                    string Content = ConvertMHTtoHTML(pHref);
                    //Content = Content.Replace("#", "&#35;").Replace("%", "&#37;").Replace("(", "&#40;").Replace(")", "&#41;");
                    Response.Write(Content);
                }
                catch (Exception Ex)
                {
                    WriteTextLog("MHTtoHTML_Content", "Page_Load", Ex.ToString());
                }
            }

            private string ConvertMHTtoHTML(string pUrl)
            {
                try
                {
                    HttpWebRequest Request = (HttpWebRequest)WebRequest.Create(pUrl);
                    Request.MaximumAutomaticRedirections = 4;
                    Request.MaximumResponseHeadersLength = 4;

                    // 02120417_성수곤
                    // 권한오류로 인하여 Credentials 설정 변경
                    Request.Credentials = CredentialCache.DefaultCredentials;
                    //Request.Credentials = new NetworkCredential(
                    //    userinfo.UserID,
                    //    System.Web.HttpContext.Current.Request.ServerVariables["AUTH_PASSWORD"],
                    //    GetSystemConfigValue("DomainName"));

                    HttpWebResponse Response = (HttpWebResponse)Request.GetResponse();

                    Stream receiveStream = Response.GetResponseStream();
                    StreamReader readStream = new StreamReader(receiveStream, Encoding.UTF8);
                    string strResult = readStream.ReadToEnd();
                    
                    //20121120 MS문서에서 생성되는 스타일 문제 수정
                    return strResult.Replace("windowtext 0.5pt", "1px");
                }
                catch (Exception Ex)
                {
                    WriteTextLog("MHTtoHTML_Content", "ConvertMHTtoHTML", Ex.ToString());
                    return "";
                }
            }

		#region Web Form Designer generated code
			override protected void OnInit(EventArgs e)
			{
				//
				// CODEGEN: 이 호출은 ASP.NET Web Form 디자이너에 필요합니다.
				//
				InitializeComponent();
				base.OnInit(e);
			}
		
			/// <summary>
			/// 디자이너 지원에 필요한 메서드입니다.
			/// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
			/// </summary>
			private void InitializeComponent()
			{    
			}
		#endregion
		}
	}
}