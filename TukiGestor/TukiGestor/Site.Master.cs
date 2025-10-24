using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TukiGestor
{
    public partial class SiteMaster : MasterPage
    {
        protected bool log = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            SetActiveMenuItem();
        }

        private void SetActiveMenuItem()
        {
            string currentPage = Request.Url.AbsolutePath.ToLower();
            string fileName = System.IO.Path.GetFileName(currentPage);

            // Aplicar la clase active según la página actual
            if (fileName.Contains("home.aspx") || fileName == "home" || currentPage.EndsWith("/home"))
            {
                linkInicio.Attributes["class"] = "active";
            }
            else if (fileName.Contains("mesas") || currentPage.Contains("/mesas"))
            {
                linkMesas.Attributes["class"] = "active";
            }
            else if (fileName.Contains("stock"))
            {
                linkStock.Attributes["class"] = "active";
            }
            else if (fileName.Contains("reporte"))
            {
                linkReporte.Attributes["class"] = "active";
            }
            else
            {
                // Por defecto, si no coincide con ninguna, activar Inicio
                linkInicio.Attributes["class"] = "active";
            }
        }
    }
}