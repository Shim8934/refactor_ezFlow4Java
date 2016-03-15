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
using System.Net;
using System.IO;
using System.Text;
using System.Configuration;
using mshtml;

namespace Kaoni
{
    namespace ezStandard
    {
        /// <summary>
        /// DHTMLCon에 대한 요약 설명입니다.
        /// </summary>
        public partial class MHTtoHTML_Get : ezWebBase
        {
            protected void Page_Load(object sender, System.EventArgs e)
            {
                try
                {
                    string strURL = "";
                    string pType = string.Empty;
                    string pDocID = string.Empty;
                    if (Request.QueryString["strURL"] != null)
                        strURL = ReplaceXSS(Request.QueryString["strURL"]);
                    if (Request.QueryString["TYPE"] != null)
                        pType = ReplaceXSS(Request.QueryString["TYPE"]);
                    if (Request.QueryString["DOCID"] != null)
                        pDocID = ReplaceXSS(Request.QueryString["DOCID"]);
                    string filepath = "";
                    string uploadModule = GetSystemConfigValue("LocalPath").ToString();

                    filepath = Server.MapPath(uploadModule);
                    if (!System.IO.Directory.Exists(filepath))
                        System.IO.Directory.CreateDirectory(filepath);
                            
                    string Url = GetSystemConfigValue("ServerPath").ToString();
                    ezMhtFormatlib.Mht2Html ezMhtFormat = new ezMhtFormatlib.Mht2Html();
                    ezMhtFormat.m_strLPath = filepath;
                    ezMhtFormat.m_strSPath = Url + "?TYPE=MHTIMAGE&ATTID=";

                    if (!pType.Equals(""))
                        strURL = strURL + "?TYPE=" + pType + "&DOCID=" + pDocID;

                    ezMhtFormat.LoadMHTFile(strURL);
                    string strHTML = ezMhtFormat.startMHT2HTML();

                    if (strHTML.Trim().Length > 0)
                    {
                        HTMLDocument iDoc = new HTMLDocument();
                        iDoc.designMode = "on";
                        object[] oPageText = { strHTML };
                        IHTMLDocument2 doc = (IHTMLDocument2)iDoc;
                        doc.write(oPageText);
                        
                        XmlDocument XmlDoc;
                        XmlNode XmlNode;
                        XmlElement XmlElem1;
                        XmlElement XmlElem2;
                        XmlElement XmlElem3;
                        XmlText XmlText;

                        XmlDoc = new XmlDocument();
                        XmlNode = XmlDoc.CreateNode(XmlNodeType.XmlDeclaration, "", "");
                        XmlDoc.AppendChild(XmlNode);

                        XmlElem1 = XmlDoc.CreateElement("", "ROOT", "");
                        XmlDoc.AppendChild(XmlElem1);

                        XmlElem2 = XmlDoc.CreateElement("", "BODYATTS", "");
                        XmlDoc.SelectSingleNode("ROOT").AppendChild(XmlElem2);


                        string strBODYatt = "";
                        string DocumentStyleSheets = "";
                        if (doc.styleSheets != null)
                        {
                            HTMLStyleSheetsCollection STyleColl = doc.styleSheets;
                            for (int i = 0; i < STyleColl.length; i++)
                            {
                                IHTMLStyleSheet styleSheet = STyleColl.item(i) as IHTMLStyleSheet;
                                DocumentStyleSheets += styleSheet.cssText;
                            }
                        }
                        else
                            DocumentStyleSheets = "P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; }";

                        if (doc.body != null)
                        {
                            HTMLBody body = doc.body as HTMLBody;
                            IHTMLAttributeCollection atts = (IHTMLAttributeCollection)body.attributes;
                            foreach (IHTMLDOMAttribute2 att in atts)
                            {
                                if (((IHTMLDOMAttribute)att).specified)
                                {
                                    if (att.value.ToUpper() != "NULL" && att.value.Trim().Length > 0 && att.expando == true && att.name.ToUpper() != "XMLNS")
                                    {
                                        XmlElem3 = XmlDoc.CreateElement("", "NODE", "");
                                        XmlDoc.SelectSingleNode("ROOT/BODYATTS").AppendChild(XmlElem3);

                                        XmlElem3 = XmlDoc.CreateElement("", "NODENAME", "");
                                        XmlText = XmlDoc.CreateTextNode(att.name);
                                        XmlElem3.AppendChild(XmlText);
                                        XmlDoc.SelectNodes("ROOT/BODYATTS").Item(0).ChildNodes.Item(XmlDoc.SelectNodes("ROOT/BODYATTS").Item(0).ChildNodes.Count - 1).AppendChild(XmlElem3);

                                        XmlElem3 = XmlDoc.CreateElement("", "NODEVALUE", "");
                                        XmlText = XmlDoc.CreateTextNode(att.value);
                                        XmlElem3.AppendChild(XmlText);
                                        XmlDoc.SelectNodes("ROOT/BODYATTS").Item(0).ChildNodes.Item(XmlDoc.SelectNodes("ROOT/BODYATTS").Item(0).ChildNodes.Count - 1).AppendChild(XmlElem3);
                                    }
                                }
                            }

                            XmlElem2 = XmlDoc.CreateElement("", "BODYDATA", "");
                            XmlText = XmlDoc.CreateTextNode(doc.body.innerHTML);
                            XmlElem2.AppendChild(XmlText);
                            XmlDoc.SelectSingleNode("ROOT").AppendChild(XmlElem2);

                        }
                        else
                        {
                            XmlElem2 = XmlDoc.CreateElement("", "BODYDATA", "");
                            XmlText = XmlDoc.CreateTextNode(strHTML);
                            XmlElem2.AppendChild(XmlText);
                            XmlDoc.SelectSingleNode("ROOT").AppendChild(XmlElem2);
                        }

                        System.Runtime.InteropServices.Marshal.ReleaseComObject(doc);
                        Response.ContentType = "text/xml; charset=utf-8";
                        Response.Write("<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>" + DocumentStyleSheets + "</STYLE>" + XmlDoc.SelectSingleNode("ROOT/BODYDATA").InnerText + "</HTML>");
                    }
                    else
                    {
                        Response.ContentType = "text/xml; charset=utf-8";
                        Response.Write("<HTML><HEAD><TITLE></TITLE><META content=\"text/html; charset=utf-8\" http-equiv=Content-Type><META name=GENERATOR content=\"MSHTML 8.00.7601.17622\"></HEAD><STYLE title=ezform_style_1>P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; *font-size:x-small; } </STYLE><BODY></BODY></HTML>");
                    }
                }
                catch (Exception Ex)
                {
                    WriteTextLog("MHTtoHTML_Get", "Page_Load", Ex.ToString());
                    Response.Write("Error : " + Ex.Message + Ex.StackTrace.ToString());
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