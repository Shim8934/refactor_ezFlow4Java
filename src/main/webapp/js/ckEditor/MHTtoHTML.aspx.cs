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
//using MHTFORMATLib;

using mshtml;

// reform
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
// reform - end

namespace Kaoni
{
    namespace ezStandard
    {
        /// <summary>
        /// DHTMLCon에 대한 요약 설명입니다.
        /// </summary>
        public partial class MHTtoHTML : ezWebBase
        {
            protected void Page_Load(object sender, System.EventArgs e)
            {
                CreateUserInfo();
                try
                {
                    XmlDocument xmldom = new XmlDocument();
                    xmldom.LoadXml(GetRequestXML());

                    string strURL = xmldom.DocumentElement.ChildNodes.Item(0).InnerText;
                    string filepath = "";
                    string uploadModule = GetSystemConfigValue("LocalPath").ToString();
                    for (int i = 0; i < strURL.Split('/').Length; i++)
                    {
                        if (strURL.Split('/')[i].ToString().ToUpper().IndexOf("UPLOAD_") > -1)
                        {
                            filepath = Server.MapPath(uploadModule);
                            if (!System.IO.Directory.Exists(filepath))
                                System.IO.Directory.CreateDirectory(filepath);
                            break;
                        }
                    }
                    filepath = Server.MapPath(uploadModule);
                    string Url = GetSystemConfigValue("ServerPath").ToString();
                    ezMhtFormatlib.Mht2Html ezMhtFormat = new ezMhtFormatlib.Mht2Html();
                    ezMhtFormat.m_strLPath = filepath;
                    ezMhtFormat.m_strSPath = Url + "?TYPE=MHTIMAGE&ATTID=";

                    ezMhtFormat.LoadMHTFile(strURL);
                    string strHTML = ezMhtFormat.startMHT2HTML();

                    HTMLDocument iDoc = new HTMLDocument();
                    iDoc.designMode = "on";
                    object[] oPageText = { strHTML };
                    IHTMLDocument2 doc = (IHTMLDocument2)iDoc;
                    doc.write(oPageText);

                    // reform
                    IHTMLElement dataBindControlListElement = iDoc.getElementById("__reform_data_bind_list");
                    if (dataBindControlListElement != null)
                    {
                        string dataBindControlListElementValue = (string)dataBindControlListElement.getAttribute("value");
                        JArray dataBindControlList = JArray.Parse(dataBindControlListElementValue);
                        foreach (string item in dataBindControlList)
                        {
                            IHTMLElement dataBindControl = iDoc.getElementById(item);
                            if (dataBindControl != null)
                            {
                                string dataBindControlValue = (string)dataBindControl.getAttribute("value");
                                JObject dataBindControlValueObject = JObject.Parse(dataBindControlValue);
                                string sqlQuery = dataBindControlValueObject["sql"].ToString();
                                string encryptedSqlQuery = EncryptionHelper.getInstance().Encrypt(sqlQuery);
                                dataBindControlValueObject["sql"] = encryptedSqlQuery;
                                dataBindControl.setAttribute("value", dataBindControlValueObject.ToString());
                            }
                        }
                    }
                    // reform - end

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
                    Response.Write(XmlDoc.OuterXml);                    
                }
                catch (Exception Ex)
                {
                    WriteTextLog("MHTtoHTML", "Page_Load", Ex.ToString());
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