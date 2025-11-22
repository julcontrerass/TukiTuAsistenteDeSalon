using dominio;
using Service;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

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


        protected void RepeaterMeserosInactivos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Reactivar")
            {
                int idMesero = int.Parse(e.CommandArgument.ToString());
                meseroService.Reactivar(idMesero);

                // recargamos las listas
                CargarMeseros();
                CargarMeserosInactivos();
            }
        }

        protected void RepeaterMeseros_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Desactivar")
            {
                int meseroId = int.Parse(e.CommandArgument.ToString());
                meseroService.Desactivar(meseroId);
                // recargamos ambas listas
                CargarMeseros();
                CargarMeserosInactivos();
            }
        }



    }
}
