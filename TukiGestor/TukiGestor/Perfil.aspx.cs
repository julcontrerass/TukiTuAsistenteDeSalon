using dominio;
using Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Service;

namespace TukiGestor
{
    public partial class WebForm2 : System.Web.UI.Page
    {

        private MeseroService meseroService = new MeseroService();
        private GerenteService gerenteService = new GerenteService();
        
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


                string rol = usuarioLoggeado.Rol;


                if (rol == "mesero")
                {
                    Mesero mesero = meseroService.BuscarPorUsuarioId(usuarioLoggeado.Id);

                    Session["meseroLoggeado"] = mesero;
                    txtNombreUsuario.Text = usuarioLoggeado.NombreUsuario;
                    txtNombre.Text = mesero.Nombre;
                    txtApellido.Text = mesero.Apellido;
                    txtEmail.Text = mesero.Email;
                }
                else
                {
                    Gerente gerente = gerenteService.BuscarPorUsuarioId(usuarioLoggeado.Id);
                    Session["gerenteLoggeado"] = gerente;
                    txtNombreUsuario.Text = usuarioLoggeado.NombreUsuario;
                    txtNombre.Text = gerente.Nombre;
                    txtApellido.Text = gerente.Apellido;
                    txtEmail.Text = gerente.Email;
                }

            }


           


        }


        private void ActualizarDatosUsuario()
        {
            try
            {

             UsuarioService usuarioService = new UsuarioService();
                Usuario usuarioLoggeado = (Usuario)Session["usuarioLoggeado"];

                int usuarioId = usuarioLoggeado.Id;
                string nombreUsuario = txtNombreUsuario.Text;
                string email = txtEmail.Text;
                string nombre = txtNombre.Text;
                string apellido = txtApellido.Text;
                string contraseña = txtContraseña.Text;
                string rol = usuarioLoggeado.Rol;

                Gerente gerente = (Gerente)Session["gerenteLoggeado"]; 
                Mesero mesero = mesero = (Mesero)Session["meseroLoggeado"]; 

                                                     
                                         

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

                if (rol == "gerente")
                {

                    Gerente gerenteModificado = new Gerente();

                    gerenteModificado.Id = usuarioId;
                    gerenteModificado.GerenteId = gerente.GerenteId;
                    gerenteModificado.NombreUsuario = nombreUsuario;
                    gerenteModificado.Nombre = nombre;
                    gerenteModificado.Apellido = apellido;
                    gerenteModificado.Email = email;
                    usuarioLoggeado.NombreUsuario = nombreUsuario;
                    usuarioLoggeado.Email = email;
                    usuarioLoggeado.Rol = rol;
                    if (cambiarContrasenia)
                    {
                    gerenteModificado.Contraseña = usuarioService.hashearContraseña(contraseña);
                        usuarioLoggeado.Contraseña = gerenteModificado.Contraseña;
                    }
                    else
                    {
                        gerenteModificado.Contraseña = gerente.Contraseña;
                    }

                    gerenteModificado.Rol = rol;
                    gerenteService.Modificar(gerenteModificado, cambiarContrasenia);
                    MostrarMensaje($"Usuario actualizado correctamente.", "success");
                    Session["gerenteLoggeado"] = gerenteModificado;
                    Session["usuarioLoggeado"] = usuarioLoggeado;

                }
                else
                {
                    Mesero meseroModificado = new Mesero();

                    meseroModificado.Id = usuarioId;
                    meseroModificado.MeseroId = mesero.MeseroId;
                    meseroModificado.NombreUsuario = nombreUsuario;
                    meseroModificado.Nombre = nombre;
                    meseroModificado.Apellido = apellido;
                    meseroModificado.Email = email;
                    usuarioLoggeado.NombreUsuario = nombreUsuario;
                    usuarioLoggeado.Email = email;
                    usuarioLoggeado.Rol = rol;
                    if (cambiarContrasenia)
                    {
                        meseroModificado.Contraseña = usuarioService.hashearContraseña(contraseña);
                        usuarioLoggeado.Contraseña = meseroModificado.Contraseña;

                    }
                    else
                    {
                        meseroModificado.Contraseña = mesero.Contraseña;
                    }

                    mesero.Rol = rol;
                    meseroService.Modificar(meseroModificado, cambiarContrasenia);
                    MostrarMensaje($"Usuario actualizado correctamente.", "success");
                    Session["meseroLoggeado"] = meseroModificado;
                    Session["usuarioLoggeado"] = usuarioLoggeado;
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al actualizar mesero: " + ex.Message, "error");
            }
            
        }
        
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
           
        }

        protected void btnActualizarMesero_Click(object sender, EventArgs e)
        {
            this.ActualizarDatosUsuario();
        }

        protected void btnCancelarActualizarMesero_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Home.aspx");
        }

        private void OcultarMensaje()
        {
            pnlMensaje.Visible = false;
        }



    }
}