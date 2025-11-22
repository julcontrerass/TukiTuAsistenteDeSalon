using Service;
using dominio;
using System;
using System.Collections.Generic;

namespace TukiGestor
{
    public partial class Meseros : System.Web.UI.Page
    {
        MeseroService meseroService = new MeseroService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarMeseros();
                CargarMeserosInactivos();
            }

        }

        private void CargarMeseros()
        {
            List<Mesero> lista = meseroService.ListarActivos();
            RepeaterMeseros.DataSource = lista;
            RepeaterMeseros.DataBind();
        }
               

        protected void btnGuardarMesero_Click(object sender, EventArgs e)
        {
            MeseroService servicio = new MeseroService();
            Mesero nuevo = new Mesero();

            try
            {
                // Datos de usuario
                nuevo.NombreUsuario = txtNombreUsuario.Text;
                nuevo.Contraseña = txtContrasenia.Text;
                nuevo.Email = txtEmail.Text;
                // Datos de mesero
                nuevo.Nombre = txtNombreMesero.Text;
                nuevo.Apellido = txtApellidoMesero.Text;
                servicio.Agregar(nuevo);
                lblMensaje.Text = "Mesero creado correctamente.";
                lblMensaje.CssClass = "text-success";
                // recargamos listado
                CargarMeseros();
                // Limpiamos campos
                txtNombreUsuario.Text = "";
                txtContrasenia.Text = "";
                txtEmail.Text = "";
                txtNombreMesero.Text = "";
                txtApellidoMesero.Text = "";
            }
            catch (Exception ex)
            {
                lblMensaje.Text = "Error: " + ex.Message;
                lblMensaje.CssClass = "text-danger";
            }
        }

        private void CargarMeserosInactivos()
        {
            List<Mesero> lista = meseroService.ListarInactivos();
            RepeaterMeserosInactivos.DataSource = lista;
            RepeaterMeserosInactivos.DataBind();
        }


    }
}
