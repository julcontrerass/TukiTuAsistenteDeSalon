using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TukiGestor
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnIniciarSesion_Click(object sender, EventArgs e)
        {
            
            string usuario = txtUsuario.Text;
            string contrasena = txtContrasena.Text;

           
            if (usuario == "admin" && contrasena == "1234")
            {
                Response.Redirect("About.aspx"); 
            }
        }

        protected void btnRegistrarse_Click(object sender, EventArgs e)
        {
            Response.Redirect("Registrarse.aspx");
        }


    }
}