using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;

public partial class XFREEUpload : Kaoni.ezStandard.ezWebBase
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string strToday, strDir, strExtension, strFileName;
            HttpPostedFile file;

            strToday = DateTime.Now.ToString("yyyyMMdd");
            strDir = Server.MapPath("/Upload_Common");
            strDir = strDir + @"\" + strToday;
            if (!Directory.Exists(strDir))
            {
                Directory.CreateDirectory(strDir);
            }
            file = Request.Files[0];
            strFileName = file.FileName;

            strExtension = strFileName.Split('.')[strFileName.Split('.').Length - 1];

            if (!Directory.Exists(strDir))
                Directory.CreateDirectory(strDir);

            string NewFileName = Guid.NewGuid().ToString() + "." + strExtension;
            string PhysicalFilePath = strDir + "\\" + NewFileName;
            file.SaveAs(PhysicalFilePath);

            string pImageWidth = "", pImageHeight = "";
            using (System.Drawing.Image image = System.Drawing.Image.FromFile(PhysicalFilePath))
            {
                pImageHeight = image.Height.ToString();
                pImageWidth = image.Width.ToString();
            }

            string scheme = "http://";
            if (Request.ServerVariables["HTTPS"].ToString().ToLower() == "on")
            {
                scheme = "https://";
            }

            if (Request.QueryString["CKEditor"] != null)
            {
                string filepath = scheme + HttpContext.Current.Request.Url.Host + "/Upload_Common/" + strToday + "/" + NewFileName;
                Response.Write("<script>window.parent.CKEDITOR.tools.callFunction(2, '" + filepath + "', '')</script>");
            }
            else
            {
                divImagePath.Value = scheme + HttpContext.Current.Request.Url.Host + "/Upload_Common/" + strToday + "/" + NewFileName + "|!|" + pImageWidth + "|!|" + pImageHeight;
            }
        }
        catch (Exception Ex)
        {
            WriteTextLog("upload", "Page_Load", Ex.ToString());
            Response.Write("Error : " + Ex.Message + Ex.StackTrace.ToString());
        }
    }
}