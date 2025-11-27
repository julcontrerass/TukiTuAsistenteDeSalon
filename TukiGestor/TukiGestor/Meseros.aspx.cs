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
            pnlModificar.CssClass = "tab-pane fade";
            pnlInactivos.CssClass = "tab-pane fade";
            // reseteamos las clases de los botones
            btnTabListado.CssClass = "nav-link";
            btnTabNuevo.CssClass = "nav-link";
            btnTabModificar.CssClass = "nav-link";
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
                case "modificar":
                    pnlModificar.CssClass = "tab-pane fade active show";
                    btnTabModificar.CssClass = "nav-link active";
                    btnTabModificar.Visible = true;
                    break;
                case "inactivos":
                    pnlInactivos.CssClass = "tab-pane fade active show";
                    btnTabInactivos.CssClass = "nav-link active";
                    break;
            }

            UpdatePanelContenido.Update();
        }

        // Evento click de la solapa modificar
        protected void btnTabModificar_Click(object sender, EventArgs e)
        {
            MostrarTab("modificar");
            OcultarMensaje();
        }

        // Modificar el RepeaterMeseros_ItemCommand para agregar el caso "Editar"
        protected void RepeaterMeseros_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                try
                {
                    int meseroId = int.Parse(e.CommandArgument.ToString());
                    CargarDatosMeseroParaEditar(meseroId);
                    MostrarTab("modificar");
                    OcultarMensaje();
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar mesero: " + ex.Message, "error");
                }
            }
            else if (e.CommandName == "Desactivar")
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

        // cargar datos del mesero en el formulario de edición
        private void CargarDatosMeseroParaEditar(int meseroId)
        {
            Mesero mesero = meseroService.ObtenerPorId(meseroId);

            if (mesero != null)
            {
                hfMeseroId.Value = mesero.MeseroId.ToString();
                hfUsuarioId.Value = mesero.Id.ToString();
                lblMeseroIdMod.Text = mesero.MeseroId.ToString();
                txtNombreUsuarioMod.Text = mesero.NombreUsuario;
                txtEmailMod.Text = mesero.Email;
                txtNombreMeseroMod.Text = mesero.Nombre;
                txtApellidoMeseroMod.Text = mesero.Apellido;
                txtContraseniaMod.Text = ""; // No mostramos la contraseña actual
            }
        }

        // botón de actualizar mesero
        protected void btnActualizarMesero_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }
            try
            {
                int meseroId = int.Parse(hfMeseroId.Value);
                int usuarioId = int.Parse(hfUsuarioId.Value);
                Mesero mesero = new Mesero();
                mesero.MeseroId = meseroId;
                mesero.Id = usuarioId;
                mesero.NombreUsuario = txtNombreUsuarioMod.Text.Trim();
                mesero.Email = txtEmailMod.Text.Trim().ToLower();
                mesero.Nombre = txtNombreMeseroMod.Text.Trim();
                mesero.Apellido = txtApellidoMeseroMod.Text.Trim();
                mesero.Contraseña = txtContraseniaMod.Text;
                // validaciones
                if (string.IsNullOrEmpty(mesero.NombreUsuario) || string.IsNullOrEmpty(mesero.Email) || string.IsNullOrEmpty(mesero.Nombre) || string.IsNullOrEmpty(mesero.Apellido))
                {
                    MostrarMensaje("Por favor complete todos los campos obligatorios.", "warning");
                    return;
                }
                // Validamos el formato de email
                if (!System.Text.RegularExpressions.Regex.IsMatch(mesero.Email, @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                {
                    MostrarMensaje("El formato del email no es válido.", "warning");
                    return;
                }
                // Validamos si el nombre de usuario ya existe para otro usuario
                if (meseroService.ExisteNombreUsuarioParaOtro(mesero.NombreUsuario, usuarioId))
                {
                    MostrarMensaje("El nombre de usuario ya está en uso por otro mesero.", "warning");
                    return;
                }
                // Validar si el email ya existe para otro usuario
                if (meseroService.ExisteEmailParaOtro(mesero.Email, usuarioId))
                {
                    MostrarMensaje("El email ya está registrado por otro mesero.", "warning");
                    return;
                }
                // validamos contraseña si se ingresó una nueva
                bool cambiarContrasenia = !string.IsNullOrEmpty(mesero.Contraseña);
                if (cambiarContrasenia && mesero.Contraseña.Length < 6)
                {
                    MostrarMensaje("La contraseña debe tener al menos 6 caracteres.", "warning");
                    return;
                }
                // actualizamos
                meseroService.Modificar(mesero, cambiarContrasenia);
                // recargamos y volvemos al listado
                CargarMeseros();
                MostrarTab("listado");
                btnTabModificar.Visible = false;

                MostrarMensaje($"Mesero '{mesero.Nombre} {mesero.Apellido}' actualizado correctamente.", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al actualizar mesero: " + ex.Message, "error");
            }
        }

        // Botón de cancelar modificación
        protected void btnCancelarMod_Click(object sender, EventArgs e)
        {
            MostrarTab("listado");
            btnTabModificar.Visible = false;
            OcultarMensaje();
        }

        private void CargarMeseros()
        {
            List<Mesero> lista = meseroService.ListarActivos();
            RepeaterMeseros.DataSource = lista;
            RepeaterMeseros.DataBind();
        }


        protected void btnGuardarMesero_Click(object sender, EventArgs e)
        {
            // Validación de servidor (por si acaso se bypasea el cliente)
            if (!Page.IsValid)
            {
                return;
            }
            UsuarioService usuarioService = new UsuarioService();
            MeseroService servicio = new MeseroService();
            Mesero nuevo = new Mesero();

            try
            {
                // Capturamos y limpiamos los datos
                nuevo.NombreUsuario = txtNombreUsuario.Text.Trim();                
                string contraseñahash = usuarioService.hashearContraseña(txtContrasenia.Text);
                nuevo.Contraseña = contraseñahash;
                nuevo.Email = txtEmail.Text.Trim().ToLower(); // email en minúsculas
                nuevo.Nombre = txtNombreMesero.Text.Trim();
                nuevo.Apellido = txtApellidoMesero.Text.Trim();
                // Validación de campos vacíos
                if (string.IsNullOrEmpty(nuevo.NombreUsuario) ||
                    string.IsNullOrEmpty(nuevo.Contraseña) ||
                    string.IsNullOrEmpty(nuevo.Email) ||
                    string.IsNullOrEmpty(nuevo.Nombre) ||
                    string.IsNullOrEmpty(nuevo.Apellido))
                {
                    MostrarMensaje("Por favor complete todos los campos obligatorios.", "warning");
                    return;
                }
                // Validación de longitud de contraseña
                if (nuevo.Contraseña.Length < 6)
                {
                    MostrarMensaje("La contraseña debe tener al menos 6 caracteres.", "warning");
                    return;
                }

                // Validación de formato de email
                if (!System.Text.RegularExpressions.Regex.IsMatch(nuevo.Email,
                    @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                {
                    MostrarMensaje("El formato del email no es válido.", "warning");
                    return;
                }
                // Validación de nombre de usuario existente
                if (servicio.ExisteNombreUsuario(nuevo.NombreUsuario))
                {
                    MostrarMensaje("El nombre de usuario ya está en uso. Por favor elija otro.", "warning");
                    return;
                }
                // Validación de email existente
                if (servicio.ExisteEmail(nuevo.Email))
                {
                    MostrarMensaje("El email ya está registrado. Por favor use otro.", "warning");
                    return;
                }
                // Si llegamos acá, todo está bien
                servicio.Agregar(nuevo);
                // Limpiamos los campos
                txtNombreUsuario.Text = "";
                txtContrasenia.Text = "";
                txtEmail.Text = "";
                txtNombreMesero.Text = "";
                txtApellidoMesero.Text = "";
                // Recargamos listado
                CargarMeseros();
                // Mostramos mensaje de éxito
                MostrarMensaje($"Mesero '{nuevo.Nombre} {nuevo.Apellido}' creado correctamente.", "success");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al crear el mesero: " + ex.Message, "error");
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

       



    }
}
