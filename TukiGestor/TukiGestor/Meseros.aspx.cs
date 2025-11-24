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

        // ========== Manejo de mensajes ==========
        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;
            pnlMensaje.CssClass = "alert-custom";

            if (tipo == "success")
                pnlMensaje.CssClass += " alert-success";
            else if (tipo == "error")
                pnlMensaje.CssClass += " alert-danger";
            else if (tipo == "warning")
                pnlMensaje.CssClass += " alert-warning";

            UpdatePanelMensajes.Update();
        }

        private void OcultarMensaje()
        {
            pnlMensaje.Visible = false;
        }

        // ========== Manejo de solapas ==========
        protected void btnTabListado_Click(object sender, EventArgs e)
        {
            MostrarTab("listado");
            OcultarMensaje();
        }

        protected void btnTabNuevo_Click(object sender, EventArgs e)
        {
            MostrarTab("nuevo");
            OcultarMensaje();
        }

        protected void btnTabInactivos_Click(object sender, EventArgs e)
        {
            CargarMeserosInactivos();
            MostrarTab("inactivos");
            OcultarMensaje();
        }

        private void MostrarTab(string tab)
        {
            // ocultamos todos los paneles
            pnlListado.CssClass = "tab-pane fade";
            pnlNuevo.CssClass = "tab-pane fade";
            pnlInactivos.CssClass = "tab-pane fade";

            // reseteamos las clases de los botones
            btnTabListado.CssClass = "nav-link";
            btnTabNuevo.CssClass = "nav-link";
            btnTabInactivos.CssClass = "nav-link";

            // mostramos el panel correspondiente
            switch (tab)
            {
                case "listado":
                    pnlListado.CssClass = "tab-pane fade active show";
                    btnTabListado.CssClass = "nav-link active";
                    break;
                case "nuevo":
                    pnlNuevo.CssClass = "tab-pane fade active show";
                    btnTabNuevo.CssClass = "nav-link active";
                    break;
                case "inactivos":
                    pnlInactivos.CssClass = "tab-pane fade active show";
                    btnTabInactivos.CssClass = "nav-link active";
                    break;
            }

            UpdatePanelContenido.Update();
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
                nuevo.NombreUsuario = txtNombreUsuario.Text.Trim();
                nuevo.Contraseña = txtContrasenia.Text;
                nuevo.Email = txtEmail.Text.Trim();
                // Datos de mesero
                nuevo.Nombre = txtNombreMesero.Text.Trim();
                nuevo.Apellido = txtApellidoMesero.Text.Trim();

                // Validaciones básicas
                if (string.IsNullOrEmpty(nuevo.NombreUsuario) || string.IsNullOrEmpty(nuevo.Contraseña) ||
                    string.IsNullOrEmpty(nuevo.Email) || string.IsNullOrEmpty(nuevo.Nombre) ||
                    string.IsNullOrEmpty(nuevo.Apellido))
                {
                    MostrarMensaje("Por favor complete todos los campos.", "warning");
                    return;
                }

                servicio.Agregar(nuevo);

                // Limpiamos campos
                txtNombreUsuario.Text = "";
                txtContrasenia.Text = "";
                txtEmail.Text = "";
                txtNombreMesero.Text = "";
                txtApellidoMesero.Text = "";

                // recargamos listado
                CargarMeseros();
                MostrarMensaje("Mesero creado correctamente.", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, "error");
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
                try
                {
                    int idMesero = int.Parse(e.CommandArgument.ToString());
                    meseroService.Reactivar(idMesero);

                    // recargamos las listas
                    CargarMeseros();
                    CargarMeserosInactivos();

                    MostrarMensaje("Mesero reactivado correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al reactivar mesero: " + ex.Message, "error");
                }
            }
        }

        protected void RepeaterMeseros_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Desactivar")
            {
                try
                {
                    int meseroId = int.Parse(e.CommandArgument.ToString());
                    meseroService.Desactivar(meseroId);

                    // recargamos ambas listas
                    CargarMeseros();
                    CargarMeserosInactivos();

                    MostrarMensaje("Mesero desactivado correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al desactivar mesero: " + ex.Message, "error");
                }
            }
        }



    }
}
