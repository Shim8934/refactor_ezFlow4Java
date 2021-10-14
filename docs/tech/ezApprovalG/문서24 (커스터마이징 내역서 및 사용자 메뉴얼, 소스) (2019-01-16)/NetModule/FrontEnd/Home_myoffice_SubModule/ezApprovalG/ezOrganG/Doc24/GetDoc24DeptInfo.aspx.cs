using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace Kaoni.ezStandard
{
    public partial class GetDoc24DeptInfo : ezApprovalGBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CreateAprUserInfo();
            XmlDocument xmldom = new XmlDocument();
            string jsonData = string.Empty;
            string rtnData = string.Empty;
            try
            {
                xmldom = GetXmlReaderString(GetRequestXML());
                
                string DeptCD = xmldom.SelectSingleNode("DATA/ORGCD").InnerText;
                jsonData = GetRecData(DeptCD);
                //rtnData = "[\r\n  {\r\n    \"cmpnyNm\": \"문서24테스트_법인2\",\r\n    \"zip\": \"03171\",\r\n    \"senderNm\": \"문서24테스트_법인1\",\r\n    \"detailAdres\": \"문서24\",\r\n    \"adres\": \"서울특별시 종로구 세종대로 209 (세종로)\",\r\n    \"fxnum\": \"02-0000-0000\",\r\n    \"telnum\": \"02-6006-5024\",\r\n    \"jurirno\": \"\",\r\n    \"bizrno\": \"000-00-00000\",\r\n    \"orgCd\": \"M999999\"\r\n  }\r\n]";
                if (!string.IsNullOrWhiteSpace(jsonData))
                {
                    dynamic dynObj = JsonConvert.DeserializeObject(jsonData);

                    if (dynObj["header"].code.ToString().Equals("LNK000000"))
                    {
                        rtnData = dynObj["result"].ToString();
                    }
                    else
                    {
                        WriteTextLog("GetDoc24DeptInf6o", "Page_Load", jsonData.ToString());
                        rtnData = string.Empty;
                    }
                }
            }
            catch (Exception ex)
            {
                WriteTextLog("GetDoc24DeptInf6o", "Page_Load", ex.ToString());
               rtnData = string.Empty;
            }
            Response.Write(rtnData);
        }

        private void WriteTextLog(string v, string jsonData)
        {
            throw new NotImplementedException();
        }

        protected string GetRecData(string SelDeptID)
        {
            string resultPost = string.Empty;
            try
            {
                StringBuilder postParams = new StringBuilder();
                postParams.Append("orgCd=" + SelDeptID);

                Encoding encoding = Encoding.UTF8;
                byte[] result = encoding.GetBytes(postParams.ToString());

                string Url = GetSystemConfigValue("REQURL");
                HttpWebRequest wReqFirst = (HttpWebRequest)WebRequest.Create(Url);

                wReqFirst.Method = "POST";
                wReqFirst.ContentType = "application/x-www-form-urlencoded";
                wReqFirst.ContentLength = result.Length;
                wReqFirst.Headers.Add("API_KEY", GetSystemConfigValue("API_KEY"));

                Stream postDataStream = wReqFirst.GetRequestStream();
                postDataStream.Write(result, 0, result.Length);
                postDataStream.Close();

                HttpWebResponse wRespFirst = (HttpWebResponse)wReqFirst.GetResponse();
                Stream respPostStream = wRespFirst.GetResponseStream();
                StreamReader readerPost = new StreamReader(respPostStream, Encoding.UTF8);

                resultPost = readerPost.ReadToEnd();
            }
            catch (Exception ex)
            {
                WriteTextLog("GetDoc24DeptInfo", "GetRecData", ex.ToString());
                resultPost = string.Empty;
            }

            return resultPost;
        }
    }
}