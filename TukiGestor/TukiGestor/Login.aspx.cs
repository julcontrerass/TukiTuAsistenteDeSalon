using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Service;
using dominio;

namespace TukiGestor
{
    public partial class Contact : Page
    {
        private UsuarioService service = new UsuarioService();

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["usuarioLoggeado"] != null)
            {
                Response.Redirect("~/Home.aspx");
            }

        }

        protected void btnIniciarSesion_Click(object sender, EventArgs e)
        {

            try
            {

                string usuario = txtUsuario.Text;
                string contraseña = txtContrasena.Text;
                string mensajeError = ""; 
                bool credencialesCorrectas = service.validarCredenciales(usuario, contraseña, out mensajeError);

                if (!credencialesCorrectas) {

                    lblError.Text = mensajeError;
                    lblError.Visible = true;
                }
                else
                {

                Usuario usuarioLoggeado =  service.buscarUsuario(usuario);                    
                Session["usuarioLoggeado"]  = usuarioLoggeado;
                Response.Redirect("Home.aspx");

                }

            }
            catch (Exception ex)
            {

                lblError.Text = ex.Message;
                lblError.Visible = true;
            }

           
        }

        protected void btnRegistrarse_Click(object sender, EventArgs e)
        {
            Response.Redirect("Registrarse.aspx");
        }


    }
}