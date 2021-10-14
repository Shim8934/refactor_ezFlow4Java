using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Kaoni.ezStandard
{
    public partial class Doc24DeptInfo : ezApprovalGBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CreateAprUserInfo();
            try
            {

            }
            catch (Exception ex)
            {
                WriteTextLog("Doc24DeptInfo", "Page_Load", ex.ToString());
            }          
        }
        
    }
}