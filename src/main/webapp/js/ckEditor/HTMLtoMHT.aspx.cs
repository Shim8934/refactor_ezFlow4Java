using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Net;
using System.IO;
using Microsoft.Exchange.WebServices.Data;
using Microsoft.Exchange.WebServices;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;

// reform
using mshtml;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
// reform - end

namespace Kaoni.ezStandard
{
    public partial class HTMLtoMHT : ezWebBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CreateUserInfo();
                XmlDocument xmldom = new XmlDocument();
                xmldom.LoadXml(GetRequestXML());
                string strHTML = xmldom.DocumentElement.ChildNodes.Item(0).InnerText;

                string scheme = "http://";
                if (Request.ServerVariables["HTTPS"].ToString().ToLower() == "on")
                {
                    scheme = "https://";
                }

                while (strHTML.IndexOf("src=\"http") > 0)
                {
                    int pos1 = strHTML.IndexOf("src=\"http") + 5;
                    int pos2 = strHTML.Substring(pos1).IndexOf("\"");
                    string ImgurlOrg = strHTML.Substring(pos1, pos2);
                    if (ImgurlOrg.IndexOf("ezEmail") > 0)
                    {
                        string Imgurl = ImgurlOrg.Replace(@"&amp;", @"&");
                        string ConverImgurl = MailContentDownload(Imgurl);
                        ConverImgurl = "replace_"+scheme + HttpContext.Current.Request.Url.Host + ConverImgurl;
                        strHTML = strHTML.Replace(ImgurlOrg, ConverImgurl);
                    }
                    else
                    {
                        break;
                    }
                }
                strHTML = strHTML.Replace("replace_" + scheme, scheme);

                // reform
                if (strHTML.IndexOf("__reform_data_bind_list") > -1)
                {
                    HTMLDocument iDoc = new HTMLDocument();
                    iDoc.designMode = "on";
                    object[] oPageText = { strHTML };
                    IHTMLDocument2 doc = (IHTMLDocument2)iDoc;
                    doc.write(oPageText);

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
                                sqlQuery = EncryptionHelper.getInstance().Decrypt(sqlQuery);
                                dataBindControlValueObject["sql"] = sqlQuery;
                                dataBindControl.setAttribute("value", dataBindControlValueObject.ToString());
                            }
                        }
                        strHTML = iDoc.documentElement.outerHTML;
                    }

                    System.Runtime.InteropServices.Marshal.ReleaseComObject(doc);
                }
                // reform - end

                ezMhtFormatlib.Html2Mht ezMhtFormat = new ezMhtFormatlib.Html2Mht();
                ezMhtFormat.m_strHTML = strHTML;

                string mhtData = ezMhtFormat.startHtml2Mht();

                Response.ContentType = "text/xml; charset=utf-8";
                Response.Write(mhtData);
            }
            catch (Exception Ex)
            {
                WriteTextLog("HTMLtoMHT", "Page_Load", Ex.ToString());
            }
        }

        private static ExchangeService getapiesb(WebCredentials credential)
        {
            ExchangeService esb = new ExchangeService(ExchangeVersion.Exchange2010_SP1);
            try
            {
                esb.UseDefaultCredentials = true;
                esb.PreAuthenticate = true;
                esb.Credentials = credential;
                esb.Url = new Uri(GetSystemConfigValue("EWSUri"));
            }
            catch (Exception Ex)
            {
                WriteTextLog("HTMLtoMHT", "getapiesb", Ex.ToString());
            }
            return esb;

        }
        private static ExchangeService getexchangeservice(string impersonaddr)
        {
            ExchangeService esb = null;

            try
            {
                string isimpersonation = GetSystemConfigValue("IsImpersonation");

                esb =
                    getapiesb(new WebCredentials(
                        impersonaddr,
                        System.Web.HttpContext.Current.Request.ServerVariables["AUTH_PASSWORD"],
                        GetSystemConfigValue("DomainName")
                ));
            }
            catch (Exception Ex)
            {
                WriteTextLog("HTMLtoMHT", "getexchangeservice", Ex.ToString());
            }
            return esb;
        }

        private string MailContentDownload(string pUrl)
        {
            string Rvalue = "";
            try
            {
                
                int AttachIDPos1 = pUrl.IndexOf(@"ATTID=") + 6;
                int AttachIDPos2 = pUrl.IndexOf(@"&ID=");
                string pMessageID = Server.UrlDecode(pUrl.Substring(AttachIDPos2 + 4));
                string pAttachID = Server.UrlDecode(pUrl.Substring(AttachIDPos1, AttachIDPos2 - AttachIDPos1));
                ServicePointManager.ServerCertificateValidationCallback = delegate(
                Object obj,
                X509Certificate certificate,
                X509Chain chain,
                SslPolicyErrors errors)
                {
                    return true;
                };
                ExchangeService esb = getexchangeservice(userinfo.UserPrincipalName);
                EmailMessage message = EmailMessage.Bind(esb, new ItemId(pMessageID));


                string strDir = Server.MapPath("/Upload_Common");
                string strToday = DateTime.Now.ToString("yyyyMMdd");
                
                strDir = strDir + @"\" + strToday;
                if (!Directory.Exists(strDir))
                {
                    Directory.CreateDirectory(strDir);
                }
                
                foreach (Attachment MsgAttach in message.Attachments)
                {
                    if (MsgAttach.ContentId.Equals(pAttachID))
                    {
                        string fileGuid = Guid.NewGuid().ToString();
                        strDir = strDir + "\\" + fileGuid + ".jpg";
                        FileAttachment AttachFile = MsgAttach as FileAttachment;
                        AttachFile.Load();
                        byte[] buffer = AttachFile.Content;
                        using (FileStream Fs = new FileStream(strDir, FileMode.OpenOrCreate, FileAccess.ReadWrite))
                        {
                            Fs.Write(buffer, 0, buffer.Length);
                            string tempPath = "/Upload_Common/" + strToday + "/" + fileGuid + ".jpg";
                            Rvalue = tempPath;
                        }
                        break;
                    }
                }
            }
            catch (Exception Ex)
            {
                WriteTextLog("HTMLtoMHT", "MailContentDownload", Ex.ToString());
            }
            return Rvalue;
        }
    }
}