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
        GerenteService gerenteService = new GerenteService();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
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
                    Response.Redirect("~/Home.aspx");
                }

                CargarMeseros();
                CargarMeserosInactivos();
                CargarGerentes();
                CargarGerentesInactivos();
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

        protected void btnTabListadoGerentes_Click(object sender, EventArgs e)
        {
            MostrarTab("listadoGerentes");
            OcultarMensaje();
        }


        private void MostrarTab(string tab)
        {
            // ocultamos todos los paneles
            pnlListado.CssClass = "tab-pane fade";
            PnlListadoGerentes.CssClass = "tab-pane fade";
            pnlNuevo.CssClass = "tab-pane fade";
            pnlModificar.CssClass = "tab-pane fade";
            pnlInactivos.CssClass = "tab-pane fade";
            PnlGerentesInactivos.CssClass = "tab-pane fade";
            // reseteamos las clases de los botones
            btnTabListado.CssClass = "nav-link";
            btnTabListadoGerentes.CssClass = "nav-link";
            btnTabNuevo.CssClass = "nav-link";
            btnTabModificar.CssClass = "nav-link";
            btnTabInactivos.CssClass = "nav-link";
            btnTabGerentesInactivos.CssClass = "nav-link";
            // mostramos el panel correspondiente
            switch (tab)
            {
                case "listado":
                    pnlListado.CssClass = "tab-pane fade active show";
                    btnTabListado.CssClass = "nav-link active";
                    break;
                case "listadoGerentes":
                    PnlListadoGerentes.CssClass = "tab-pane fade active show";
                    btnTabListadoGerentes.CssClass= "nav-link active";
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
                case "gerentes-inactivos":
                    PnlGerentesInactivos.CssClass = "tab-pane fade active show";
                    btnTabGerentesInactivos.CssClass= "nav-link active";
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

                UsuarioService service = new UsuarioService();

                int meseroOGerenteId = int.Parse(hfMeseroId.Value);
                int usuarioId = int.Parse(hfUsuarioId.Value);
                string nombreUsuario = txtNombreUsuarioMod.Text.Trim();
                string email = txtEmailMod.Text.Trim().ToLower();
                string nombre = txtNombreMeseroMod.Text.Trim();
                string apellido = txtApellidoMeseroMod.Text.Trim();
                string contraseña = txtContraseniaMod.Text;
                Usuario usuario = service.buscarUsuario(nombreUsuario);
                string rol = usuario.Rol;
                Mesero mesero = new Mesero();
                Gerente gerente = new Gerente();
            
                // validaciones
                if (string.IsNullOrEmpty(nombreUsuario) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(apellido))
                {
                    MostrarMensaje("Por favor complete todos los campos obligatorios.", "warning");
                    return;
                }
                // Validamos el formato de email
                if (!System.Text.RegularExpressions.Regex.IsMatch(email, @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                {
                    MostrarMensaje("El formato del email no es válido.", "warning");
                    return;
                }
                // Validamos si el nombre de usuario ya existe para otro usuario
                if (meseroService.ExisteNombreUsuarioParaOtro(nombreUsuario, usuarioId))
                {
                    MostrarMensaje("El nombre de usuario ya está en uso por otro usuario.", "warning");
                    return;
                }
                // Validar si el email ya existe para otro usuario
                if (meseroService.ExisteEmailParaOtro(email, usuarioId))
                {
                    MostrarMensaje("El email ya está registrado por otro mesero.", "warning");
                    return;
                }
                // validamos contraseña si se ingresó una nueva
                bool cambiarContrasenia = !string.IsNullOrEmpty(contraseña);
                if (cambiarContrasenia && contraseña.Length < 6)
                {
                    MostrarMensaje("La contraseña debe tener al menos 6 caracteres.", "warning");
                    return;
                }

                if(rol == "gerente")
                {
                    gerente.Id = usuarioId;
                    gerente.GerenteId = meseroOGerenteId;
                    gerente.NombreUsuario = nombreUsuario;
                    gerente.Nombre = nombre;
                    gerente.Apellido = apellido;
                    gerente.Email = email;
                    gerente.Contraseña = service.hashearContraseña(contraseña);
                    gerente.Rol = rol;
                    gerenteService.Modificar(gerente, cambiarContrasenia);

                    CargarGerentes();
                    MostrarTab("listado-gerentes");
                    btnTabModificar.Visible = false;
                    MostrarMensaje($"Gerente '{gerente.Nombre} {gerente.Apellido}' actualizado correctamente.", "success");
                }
                else
                {
                    mesero.Id = usuarioId;
                    mesero.MeseroId = meseroOGerenteId;
                    mesero.NombreUsuario = nombreUsuario;
                    mesero.Nombre = nombre;
                    mesero.Apellido = apellido;
                    mesero.Email = email;
                    mesero.Contraseña = service.hashearContraseña(contraseña);
                    mesero.Rol = rol;
                    // actualizamos
                    meseroService.Modificar(mesero, cambiarContrasenia);
                    // recargamos y volvemos al listado
                CargarMeseros();
                MostrarTab("listado");
                btnTabModificar.Visible = false;
                MostrarMensaje($"Mesero '{mesero.Nombre} {mesero.Apellido}' actualizado correctamente.", "success");
                }



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
            List<Mesero> listaMeseros = meseroService.ListarActivos();
            RepeaterMeseros.DataSource = listaMeseros;
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
            MeseroService servicioMesero = new MeseroService();
            GerenteService servicioGerente = new GerenteService();
            Mesero nuevoMesero = new Mesero();
            Gerente nuevoGerente = new Gerente();

            try
            {
                string contraseñaPlana = txtContrasenia.Text.Trim();
                string nombreUsuario = txtNombreUsuario.Text.Trim();
                string email = txtEmail.Text.Trim().ToLower();
                string nombre = txtNombreMesero.Text.Trim();
                string apellido = txtApellidoMesero.Text.Trim();    
                string rol = ddlFiltroRol.SelectedValue.ToLower();

                if (rol == "gerente")
                {
                    nuevoGerente.NombreUsuario = nombreUsuario;
                    string contraseñahash = usuarioService.hashearContraseña(contraseñaPlana);
                    nuevoGerente.Contraseña = contraseñahash;                    
                    nuevoGerente.Email = email; // email en minúsculas
                    nuevoGerente.Nombre = nombre;
                    nuevoGerente.Apellido = apellido;
                    nuevoGerente.Rol = rol;

                }
                else
                {
                    nuevoMesero.NombreUsuario = nombreUsuario;
                    string contraseñahash = usuarioService.hashearContraseña(contraseñaPlana);
                    nuevoMesero.Contraseña = contraseñahash;
                    nuevoMesero.Email = email; // email en minúsculas
                    nuevoMesero.Nombre = nombre;
                    nuevoMesero.Apellido = apellido;
                    nuevoMesero.Rol = rol;
                }

                    // Validación de campos vacíos

                    if (string.IsNullOrEmpty(nombreUsuario) ||
                    string.IsNullOrEmpty(contraseñaPlana) ||
                    string.IsNullOrEmpty(email) ||
                    string.IsNullOrEmpty(nombre) ||
                    string.IsNullOrEmpty(apellido) ||
                    string.IsNullOrEmpty(rol))
                {
                    MostrarMensaje("Por favor complete todos los campos obligatorios.", "warning");
                    return;
                }
                

                // Validación de longitud de contraseña
                if (contraseñaPlana.Length < 6 )
                {
                    MostrarMensaje("La contraseña debe tener al menos 6 caracteres.", "warning");
                    return;
                }

                // Validación de formato de email

              
                    if (!System.Text.RegularExpressions.Regex.IsMatch(email,
                   @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"))
                    {
                        MostrarMensaje("El formato del email no es válido.", "warning");
                        return;
                    }
                
               
                // Validación de nombre de usuario existente
                if (servicioMesero.ExisteNombreUsuario(nombre))
                {
                    MostrarMensaje("El nombre de usuario ya está en uso. Por favor elija otro.", "warning");
                    return;
                }
                // Validación de email existente
                if (servicioMesero.ExisteEmail(email))
                {
                    MostrarMensaje("El email ya está registrado. Por favor use otro.", "warning");
                    return;
                }
                // Si llegamos acá, todo está bien
                if(rol == "gerente")
                {
                    servicioGerente.Agregar(nuevoGerente);
                }
                else
                {
                    servicioMesero.Agregar(nuevoMesero);

                }
                               
                // Enviamos email al nuevo mesero
                try
                {
                    EmailService emailService = new EmailService();
                    emailService.EnviarEmailNuevoMesero(email, nombre, apellido, nombreUsuario, contraseñaPlana);
                }
                catch (Exception ex)
                {
                    if(rol == "gerente")
                    {
                        lblMensaje.Text = "El gerente fue creado, pero no se pudo enviar el email: " + ex.Message;
                    }
                    else
                    {
                    lblMensaje.Text = "El mesero fue creado, pero no se pudo enviar el email: " + ex.Message;

                    }

                        lblMensaje.CssClass = "text-warning fw-bold";
                }

                // Limpiamos los campos
                txtNombreUsuario.Text = "";
                txtContrasenia.Text = "";
                txtEmail.Text = "";
                txtNombreMesero.Text = "";
                txtApellidoMesero.Text = "";
                // Recargamos listado
                CargarMeseros();
                // Mostramos mensaje de éxito
                if(rol == "gerente")
                {
                    MostrarMensaje($"Gerente '{nombre} {apellido}' creado correctamente.", "success");

                }
                else
                {

                MostrarMensaje($"Mesero '{nombre} {apellido}' creado correctamente.", "success");
                }

            }
            catch (Exception ex)
            {
                
                MostrarMensaje("Error al crear el usuario: " + ex.Message, "error");
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


        private void CargarGerentesInactivos()
        {
            List<Gerente> lista = gerenteService.ListarInactivos();
            RepeaterGerentesInactivos.DataSource = lista;
            RepeaterGerentesInactivos.DataBind();
        }

        private void CargarDatosGerenteParaEditar(int gerenteId)
        {
            Gerente gerente = gerenteService.ObtenerPorId(gerenteId);

            if (gerente != null)
            {
                hfMeseroId.Value = gerente.GerenteId.ToString();
                hfUsuarioId.Value = gerente.Id.ToString();
                lblMeseroIdMod.Text = gerente.GerenteId.ToString();
                txtNombreUsuarioMod.Text = gerente.NombreUsuario;
                txtEmailMod.Text = gerente.Email;
                txtNombreMeseroMod.Text = gerente.Nombre;
                txtApellidoMeseroMod.Text = gerente.Apellido;
                txtContraseniaMod.Text = ""; // No mostramos la contraseña actual
            }
        }

        private void CargarGerentes()
        {
            List<Gerente> listaGerentes = gerenteService.ListarActivos();
            RepeaterGerentes.DataSource = listaGerentes;
            RepeaterGerentes.DataBind();
        }

        protected void RepeaterGerentes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                try
                {
                    int gerenteId = int.Parse(e.CommandArgument.ToString());
                    CargarDatosGerenteParaEditar(gerenteId);
                    MostrarTab("modificar");
                    OcultarMensaje();
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al cargar gerente: " + ex.Message, "error");
                }
            }
            else if (e.CommandName == "Desactivar")
            {
                try
                {
                    int gerenteId = int.Parse(e.CommandArgument.ToString());
                    gerenteService.Desactivar(gerenteId);
                    // recargamos ambas listas
                    CargarGerentes();
                    CargarGerentesInactivos();
                    MostrarMensaje("Gerente desactivado correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al desactivar mesero: " + ex.Message, "error");
                }
            }
        }

        protected void RepeaterGerentesInactivos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Reactivar")
            {
                try
                {
                    int idgerente = int.Parse(e.CommandArgument.ToString());
                    gerenteService.Reactivar(idgerente);
                    // recargamos las listas
                    CargarGerentes();
                    CargarGerentesInactivos();
                 
                    MostrarMensaje("Gerente reactivado correctamente.", "success");
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al reactivar mesero: " + ex.Message, "error");
                }
            }
        }

        protected void btnTabGerentesInactivos_Click(object sender, EventArgs e)
        {
            CargarGerentesInactivos();
            MostrarTab("gerentes-inactivos");
            OcultarMensaje();
        }
    }
}
