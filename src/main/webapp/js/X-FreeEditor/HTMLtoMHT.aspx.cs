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


namespace Kaoni.ezStandard
{
    public partial class HTMLtoMHT_Cross : ezWebBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CreateUserInfo();
                string strText;

                XmlDocument xmldom = new XmlDocument();
                xmldom.LoadXml(GetRequestXML());
                string strHTML = xmldom.DocumentElement.ChildNodes.Item(0).InnerText;



                while (strHTML.IndexOf("src=\"http") > 0)
                {
                    int pos1 = strHTML.IndexOf("src=\"http") + 5;
                    int pos2 = strHTML.Substring(pos1).IndexOf("\"");
                    string ImgurlOrg = strHTML.Substring(pos1, pos2);
                    if (ImgurlOrg.IndexOf("ezEmail") > 0)
                    {
                        string Imgurl = ImgurlOrg.Replace(@"&amp;", @"&");
                        string ConverImgurl = MailContentDownload(Imgurl);
                        ConverImgurl = @"file:///" + ConverImgurl.Replace(@"\", @"\\");
                        strHTML = strHTML.Replace(ImgurlOrg, ConverImgurl);
                    }
                    else
                    {
                        break;
                    }
                }

                ezMhtFormatlib.Html2Mht ezMhtFormat = new ezMhtFormatlib.Html2Mht();
                ezMhtFormat.m_strHTML = strHTML;

                string mhtData = ezMhtFormat.startHtml2Mht();

                Response.ContentType = "text/xml; charset=utf-8";
                Response.Write(mhtData);
            }
            catch (Exception Ex)
            {
                WriteTextLog("HTMLtoMHT_Cross", "Page_Load", Ex.ToString());
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
                WriteTextLog("HTMLtoMHT_Cross", "getapiesb", Ex.ToString());
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
                WriteTextLog("HTMLtoMHT_Cross", "getexchangeservice", Ex.ToString());
            }
            return esb;
        }

        private string MailContentDownload(string pUrl)
        {
            string Rvalue = "";
            string TempPath = GetSystemConfigValue(("MAIL_TEMPPATH_FE") + "\\" + Guid.NewGuid() + ".jpg");
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
                foreach (Attachment MsgAttach in message.Attachments)
                {
                    if (MsgAttach.ContentId.Equals(pAttachID))
                    {
                        FileAttachment AttachFile = MsgAttach as FileAttachment;
                        AttachFile.Load();
                        byte[] buffer = AttachFile.Content;
                        using (FileStream Fs = new FileStream(TempPath, FileMode.OpenOrCreate, FileAccess.ReadWrite))
                        {
                            Fs.Write(buffer, 0, buffer.Length);
                            Rvalue = TempPath;
                        }
                        break;
                    }
                }
            }
            catch (Exception Ex)
            {
                WriteTextLog("HTMLtoMHT_Cross", "MailContentDownload", Ex.ToString());
            }
            return Rvalue;
        }
    }
}