using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace Kaoni.ezStandard
{
    public partial class GetDoc24DeptList : ezApprovalGBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CreateAprUserInfo();
            XmlDocument xmldom = new XmlDocument();
            string strXML = string.Empty;
            try
            {
                xmldom = GetXmlReaderString(GetRequestXML());
                string search = string.Empty;
                if (xmldom.GetElementsByTagName("SEARCH").Count > 0 )
                    search = xmldom.SelectSingleNode("DATA/SEARCH").InnerText;
              
                string strSQL = string.Empty;
                if (!string.IsNullOrEmpty(search))
                {
                    string[] SearchList = search.Split(':');
                    if (SearchList.Length > 0)
                    {
                        strSQL = "  AND  " + SearchList[0] + " LIKE  '%" + SearchList[1] + "%' ";
                    }
                }
                strXML = GetDoc24List(strSQL, userinfo.CompanyID);
            }
            catch (Exception ex)
            {
                WriteTextLog("GetDoc24DeptList", "Page_Load", ex.ToString());
                Response.End();
            }

            XmlDocument xmlResult = new XmlDocument();
            xmlResult = GetXmlReaderString(strXML);
            Response.ContentType = "text/xml;charset=utf-8";
            xmlResult.Save(Response.OutputStream);
        }

        protected string GetDoc24List(string strSQL, string companyID)
        {
            XmlDocument resultXML = new XmlDocument();
            SqlCommand cmd = null;
            try
            {
                XmlElement LIST, HEADERS, ROWS, HEAD, NAME,  ROW, CELL, CELLVALUE, CUSTOMDATA;

                LIST = resultXML.CreateElement("LISTVIEWDATA");
                resultXML.AppendChild(LIST);

                HEADERS = resultXML.CreateElement("HEADERS");
                LIST.AppendChild(HEADERS);

                ROWS = resultXML.CreateElement("ROWS");
                LIST.AppendChild(ROWS);


                HEAD = resultXML.CreateElement("HEADER");
                HEADERS.AppendChild(HEAD);
                NAME = resultXML.CreateElement("NAME");
                HEAD.AppendChild(NAME);
                NAME.InnerText = "사업장명";


                cmd = new SqlCommand("EZSP_DOC24_GETDEPTLIST");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@SERACHQUERY", SqlDbType.VarChar, 1000).Value = strSQL;

                string DeptList = GetQueryResultSP(ref cmd, true, companyID);
                XmlDocument deptXML = new XmlDocument();
                deptXML = GetXmlReaderString(DeptList);
                cmd.Dispose();

                for (int i = 0; i < deptXML.SelectNodes("DATA/ROW").Count; i++)
                {
                    ROW = resultXML.CreateElement("ROW");
                    ROWS.AppendChild(ROW);

                    CELL = resultXML.CreateElement("CELL");
                    ROW.AppendChild(CELL);
                    CELLVALUE = resultXML.CreateElement("VALUE");
                    CELL.AppendChild(CELLVALUE);
                    string FieldValue = deptXML.GetElementsByTagName("CMPNYNM").Item(i).InnerText;
                    CELLVALUE.InnerText = FieldValue;

                    CUSTOMDATA = resultXML.CreateElement("DATA1");
                    CELL.AppendChild(CUSTOMDATA);
                    CUSTOMDATA.InnerText = deptXML.GetElementsByTagName("ORGCD").Item(i).InnerText;

                    CUSTOMDATA = resultXML.CreateElement("DATA2");
                    CELL.AppendChild(CUSTOMDATA);
                    CUSTOMDATA.InnerText = MakeListField(deptXML.GetElementsByTagName("CMPNYNM").Item(i).InnerText);

                    CUSTOMDATA = resultXML.CreateElement("DATA3");
                    CELL.AppendChild(CUSTOMDATA);
                    CUSTOMDATA.InnerText = MakeListField(deptXML.GetElementsByTagName("SENDERNM").Item(i).InnerText);
                }
            }
            catch (Exception ex)
            {
                WriteTextLog("GetDoc24DeptList", "GetDoc24List", ex.ToString());
            }
            finally
            {
                if (cmd != null)
                    cmd.Dispose();
            }

            return resultXML.OuterXml;
        }
    }
}