using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Kaoni
{
    namespace ezStandard
    {
        public partial class ImageUpload : ezWebBase
        {
            protected void Page_Load(object sender, EventArgs e)
            {
                CreateUserInfo();
            }
        }
    }
}