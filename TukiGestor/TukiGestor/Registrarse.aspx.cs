using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TukiGestor
{
    public partial class Registrarse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegistrarse_Click(object sender, EventArgs e)
        {
            string usuario = txtUsuario.Text.Trim();
            string contrasena = txtContrasena.Text;
            string confirmar = TextRepetirContrasena.Text; // <-- aquí el ID correcto

            if (string.IsNullOrEmpty(usuario) || string.IsNullOrEmpty(contrasena) || string.IsNullOrEmpty(confirmar))
            {
                lblMensaje.Text = "Por favor, complete todos los campos.";
                lblMensaje.CssClass = "text-danger";
                return;
            }

            if (contrasena != confirmar)
            {
                lblMensaje.Text = "Las contraseñas no coinciden.";
                lblMensaje.CssClass = "text-danger";
                return;
            }

            // Acá podrías guardar el usuario en base de datos o archivo
            lblMensaje.Text = "¡Registro exitoso! Ahora podés iniciar sesión.";
            lblMensaje.CssClass = "text-success";
            Response.Redirect("About.aspx");
        }

    }
}