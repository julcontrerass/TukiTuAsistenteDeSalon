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
    public partial class Mesas : System.Web.UI.Page
    {
        private MesaService mesaService = new MesaService();

        // Propiedades para controlar modales
        public string MostrarModalAbrirMesa
        {
            get { return ViewState["MostrarModalAbrirMesa"] != null ? ViewState["MostrarModalAbrirMesa"].ToString() : "false"; }
            set { ViewState["MostrarModalAbrirMesa"] = value; }
        }

        public string MostrarModalOrden
        {
            get { return ViewState["MostrarModalOrden"] != null ? ViewState["MostrarModalOrden"].ToString() : "false"; }
            set { ViewState["MostrarModalOrden"] = value; }
        }

        public string MostrarModalResumen
        {
            get { return ViewState["MostrarModalResumen"] != null ? ViewState["MostrarModalResumen"].ToString() : "false"; }
            set { ViewState["MostrarModalResumen"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // SIEMPRE cargar desde la base de datos (incluso en postbacks y refresh)
            // Esto asegura que los datos estén actualizados en todo momento
            CargarMesasEnRepeaters();

            // Manejar mensajes del patrón Post-Redirect-Get
            if (!IsPostBack && Session["MensajeExito"] != null)
            {
                MostrarMensaje(Session["MensajeExito"].ToString(), "success");
                Session.Remove("MensajeExito");
            }
        }

        private void CargarMesasEnRepeaters()
        {
            try
            {
                // Cargar mesas del salón
                List<Mesa> mesasSalon = mesaService.ListarMesasPorUbicacion("salon");
                RepMesasSalon.DataSource = mesasSalon;
                RepMesasSalon.DataBind();

                // Cargar mesas del patio
                List<Mesa> mesasPatio = mesaService.ListarMesasPorUbicacion("patio");
                RepMesasPatio.DataSource = mesasPatio;
                RepMesasPatio.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar las mesas: " + ex.Message, "danger");
            }
        }

        protected void SeleccionarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string[] args = btn.CommandArgument.Split('|');
                int mesaId = int.Parse(args[0]);
                string numeroMesa = args[1];
                string ubicacion = args[2];
                string estado = args[3];

                // Guardar información en ViewState para usar en otros métodos
                ViewState["MesaIdSeleccionada"] = mesaId;
                ViewState["NumeroMesaSeleccionada"] = numeroMesa;
                ViewState["UbicacionSeleccionada"] = ubicacion;
                ViewState["EstadoMesaSeleccionada"] = estado;

                // Guardar tab activo
                HdnTabActivo.Value = ubicacion;

                // Si la mesa está libre, mostrar modal para abrir mesa
                if (estado.ToLower() == "libre")
                {
                    LitNumeroMesaModal.Text = numeroMesa;
                    TxtCantidadPersonas.Text = "1";
                    DdlCamarero.SelectedIndex = 0;

                    // Registrar script para abrir el modal
                    string script = @"
                        setTimeout(function() {
                            var modal = new bootstrap.Modal(document.getElementById('modalAbrirMesa'));
                            modal.show();
                        }, 100);
                    ";
                    ClientScript.RegisterStartupScript(this.GetType(), "AbrirModalMesa", script, true);
                }
                else
                {
                    // Si está ocupada, abrir modal de orden directamente
                    AbrirModalOrden(numeroMesa);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al seleccionar la mesa: " + ex.Message, "danger");
            }
        }

        protected void ConfirmarAbrirMesa_Click(object sender, EventArgs e)
        {
            try
            {
                // Validar campos
                if (string.IsNullOrEmpty(TxtCantidadPersonas.Text) || int.Parse(TxtCantidadPersonas.Text) < 1)
                {
                    MostrarMensaje("Por favor ingrese la cantidad de personas.", "warning");
                    ReabrirModalAbrirMesa();
                    return;
                }

                if (string.IsNullOrEmpty(DdlCamarero.SelectedValue))
                {
                    MostrarMensaje("Por favor seleccione un camarero.", "warning");
                    ReabrirModalAbrirMesa();
                    return;
                }

                // Obtener datos de ViewState
                int mesaId = (int)ViewState["MesaIdSeleccionada"];
                string numeroMesa = ViewState["NumeroMesaSeleccionada"].ToString();
                string ubicacion = ViewState["UbicacionSeleccionada"].ToString();
                int cantidadPersonas = int.Parse(TxtCantidadPersonas.Text);
                int meseroId = int.Parse(DdlCamarero.SelectedValue);

                // Mantener tab activo
                HdnTabActivo.Value = ubicacion;

                // Actualizar estado de la mesa a "ocupada"
                mesaService.ActualizarEstadoMesa(mesaId, "ocupada");

                // TODO: Aquí debería crear la asignación de mesa y el pedido en la BD
                // Por ahora solo actualizamos el estado de la mesa

                // Después de abrir la mesa, ir directo al modal de orden
                MostrarMensaje("Mesa " + numeroMesa + " abierta exitosamente.", "success");
                AbrirModalOrden(numeroMesa);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al abrir la mesa: " + ex.Message, "danger");
                ReabrirModalAbrirMesa();
            }
        }

        private void ReabrirModalAbrirMesa()
        {
            string script = @"
                setTimeout(function() {
                    var modal = new bootstrap.Modal(document.getElementById('modalAbrirMesa'));
                    modal.show();
                }, 100);
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "ReabrirModalMesa", script, true);
        }

        private void AbrirModalOrden(string numeroMesa)
        {
            // TODO: Aquí se debería configurar el modal de orden con los productos
            // Por ahora solo abrimos el modal
            string script = $@"
                setTimeout(function() {{
                    document.getElementById('modal-orden-mesa-numero').textContent = '{numeroMesa}';
                    var modal = new bootstrap.Modal(document.getElementById('modalOrden'));
                    modal.show();
                }}, 100);
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "AbrirModalOrden", script, true);
        }

        protected void AgregarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string ubicacion = btn.CommandArgument;

                // Guardar tab activo
                HdnTabActivo.Value = ubicacion;

                // Obtener el próximo número de mesa para esta ubicación
                List<Mesa> mesasExistentes = mesaService.ListarMesasPorUbicacion(ubicacion);
                int proximoNumero = mesasExistentes.Count + 1;

                // Crear nueva mesa
                Mesa nuevaMesa = new Mesa
                {
                    NumeroMesa = proximoNumero.ToString(),
                    Ubicacion = ubicacion,
                    Estado = "libre",
                    Activa = true
                };

                mesaService.AgregarMesa(nuevaMesa);

                Session["MensajeExito"] = "Mesa " + proximoNumero + " agregada exitosamente en " + ubicacion + ".";
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al agregar la mesa: " + ex.Message, "danger");
            }
        }

        protected void EliminarMesaDirecta_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string[] args = btn.CommandArgument.Split('|');
                int mesaId = int.Parse(args[0]);
                string numeroMesa = args[1];

                mesaService.EliminarMesa(mesaId);

                Session["MensajeExito"] = "Mesa " + numeroMesa + " eliminada exitosamente.";
                Response.Redirect(Request.RawUrl);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al eliminar la mesa: " + ex.Message, "danger");
            }
        }

        protected void EliminarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                if (ViewState["MesaIdSeleccionada"] != null)
                {
                    int mesaId = (int)ViewState["MesaIdSeleccionada"];
                    string numeroMesa = ViewState["NumeroMesaSeleccionada"].ToString();

                    mesaService.EliminarMesa(mesaId);

                    Session["MensajeExito"] = "Mesa " + numeroMesa + " eliminada exitosamente.";
                    Response.Redirect(Request.RawUrl);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al eliminar la mesa: " + ex.Message, "danger");
            }
        }

        protected void OcuparMesa_Click(object sender, EventArgs e)
        {
            try
            {
                if (ViewState["MesaIdSeleccionada"] != null)
                {
                    int mesaId = (int)ViewState["MesaIdSeleccionada"];
                    string numeroMesa = ViewState["NumeroMesaSeleccionada"].ToString();

                    mesaService.ActualizarEstadoMesa(mesaId, "ocupada");

                    Session["MensajeExito"] = "Mesa " + numeroMesa + " ocupada exitosamente.";
                    Response.Redirect(Request.RawUrl);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al ocupar la mesa: " + ex.Message, "danger");
            }
        }

        protected void LiberarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                if (ViewState["MesaIdSeleccionada"] != null)
                {
                    int mesaId = (int)ViewState["MesaIdSeleccionada"];
                    string numeroMesa = ViewState["NumeroMesaSeleccionada"].ToString();

                    mesaService.ActualizarEstadoMesa(mesaId, "libre");

                    Session["MensajeExito"] = "Mesa " + numeroMesa + " liberada exitosamente.";
                    Response.Redirect(Request.RawUrl);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al liberar la mesa: " + ex.Message, "danger");
            }
        }

        protected void AbrirMostrador_Click(object sender, EventArgs e)
        {
            try
            {
                // Guardar tab activo
                HdnTabActivo.Value = "mostrador";

                // Guardar que es mostrador
                ViewState["EsMostrador"] = true;
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = "Mostrador";

                // Abrir modal de orden
                AbrirModalOrden("Mostrador");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al abrir mostrador: " + ex.Message, "danger");
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            PanelMensaje.Visible = true;
            PanelMensaje.CssClass = "alert alert-" + tipo + " alert-dismissible fade show";
            LitMensaje.Text = mensaje;
        }
    }
}