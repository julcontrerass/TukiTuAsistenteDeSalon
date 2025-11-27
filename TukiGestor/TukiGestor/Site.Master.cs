using dominio;
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

            if (Session["usuarioLoggeado"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            Usuario usuarioLoggeado = (Usuario)Session["usuarioLoggeado"];
            bool esMesero = usuarioLoggeado.Rol == "mesero";

            if (esMesero)
            {
                linkMeseros.Visible = false;
            }

            lblNombreUsuario.Text = usuarioLoggeado.NombreUsuario;
            lblRolUsuario.Text = usuarioLoggeado.Rol;


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
            else if (fileName.Contains("productos") || currentPage.Contains("/productos"))
            {
                linkStock.Attributes["class"] = "active";
            }
            else if (fileName.Contains("meseros") || currentPage.Contains("/meseros"))
            {
                linkMeseros.Attributes["class"] = "active";
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

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }

      

        protected void btnModificarPerfil_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Perfil.aspx");
        }
    }
}