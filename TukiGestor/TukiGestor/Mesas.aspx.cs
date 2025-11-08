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
        private ProductoService productoService = new ProductoService();
        private CategoriaService categoriaService = new CategoriaService();

        // Listas públicas para binding
        public List<Categoria> Categorias { get; set; }
        public List<Producto> Productos { get; set; }

        // Propiedad para controlar si hay búsqueda activa
        public bool HayBusquedaActiva
        {
            get { return ViewState["HayBusquedaActiva"] != null && (bool)ViewState["HayBusquedaActiva"]; }
            set { ViewState["HayBusquedaActiva"] = value; }
        }

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
            CargarCategoriasYProductos();

            // Manejar mensajes del patrón Post-Redirect-Get
            if (!IsPostBack && Session["MensajeExito"] != null)
            {
                MostrarMensaje(Session["MensajeExito"].ToString(), "success");
                Session.Remove("MensajeExito");
            }

            // Restaurar tab activo desde Session
            if (!IsPostBack && Session["TabActivo"] != null)
            {
                HdnTabActivo.Value = Session["TabActivo"].ToString();
                Session.Remove("TabActivo");
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

        private void CargarCategoriasYProductos()
        {
            try
            {
                // Cargar categorías desde la base de datos
                Categorias = categoriaService.Listar();

                // Cargar todos los productos (búsqueda se hace en JavaScript)
                Productos = productoService.Listar();

                // Bind a los repeaters de tabs
                RepCategorias.DataSource = Categorias;
                RepCategorias.DataBind();

                // Bind al repeater de contenido
                RepCategoriasContenido.DataSource = Categorias;
                RepCategoriasContenido.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar productos y categorías: " + ex.Message, "danger");
            }
        }

        // Método auxiliar para obtener productos de una categoría específica
        public List<Producto> ObtenerProductosPorCategoria(int categoriaId)
        {
            if (Productos == null) return new List<Producto>();
            return Productos.Where(p => p.CategoriaId == categoriaId).ToList();
        }

        // Método para generar HTML de productos por categoría
        protected string GenerarProductosCategoria(int categoriaId)
        {
            var productos = ObtenerProductosPorCategoria(categoriaId);
            if (productos == null || productos.Count == 0)
            {
                return "<p style='color: #999; text-align: center; padding: 20px;'>No hay productos en esta categoría</p>";
            }

            System.Text.StringBuilder html = new System.Text.StringBuilder();
            foreach (var prod in productos)
            {
                html.AppendFormat(@"
                    <div class='producto-item' data-nombre='{0}' data-precio='{1}' data-categoria='categoria-{2}' data-productoid='{3}'>
                        <div class='producto-info'>
                            <div class='producto-nombre'>{0}</div>
                            <div class='producto-precio'>${1:N0}</div>
                        </div>
                        <div class='cantidad-control'>
                            <button type='button' onclick='cambiarCantidad(this, -1, event)'>-</button>
                            <input type='number' value='0' min='0' readonly>
                            <button type='button' onclick='cambiarCantidad(this, 1, event)'>+</button>
                        </div>
                    </div>
                ", prod.Nombre, prod.Precio, categoriaId, prod.ProductoId);
            }
            return html.ToString();
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

                // Guardar tab activo y mensaje en Session
                Session["TabActivo"] = ubicacion;
                Session["MensajeExito"] = "Mesa " + proximoNumero + " agregada exitosamente en " + ubicacion + ".";

                // Redirigir a URL limpia para evitar reenvío de formulario
                Response.Redirect(Request.Url.AbsolutePath, false);
                Context.ApplicationInstance.CompleteRequest();
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
                string ubicacion = args[2];

                mesaService.EliminarMesa(mesaId);

                // Guardar tab activo y mensaje en Session
                Session["TabActivo"] = ubicacion;
                Session["MensajeExito"] = "Mesa " + numeroMesa + " eliminada exitosamente.";

                // Redirigir a URL limpia para evitar reenvío de formulario
                Response.Redirect(Request.Url.AbsolutePath, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al eliminar la mesa: " + ex.Message, "danger");
            }
        }

        protected void ConfirmarEliminarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener los valores de los HiddenFields
                if (!string.IsNullOrEmpty(HdnMesaIdEliminar.Value))
                {
                    int mesaId = int.Parse(HdnMesaIdEliminar.Value);
                    string numeroMesa = HdnMesaNumeroEliminar.Value;
                    string ubicacion = HdnMesaUbicacionEliminar.Value;

                    mesaService.EliminarMesa(mesaId);

                    // Guardar tab activo y mensaje en Session
                    Session["TabActivo"] = ubicacion;
                    Session["MensajeExito"] = "Mesa " + numeroMesa + " eliminada exitosamente.";

                    // Redirigir a URL limpia para evitar reenvío de formulario
                    Response.Redirect(Request.Url.AbsolutePath, false);
                    Context.ApplicationInstance.CompleteRequest();
                }
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
                    string ubicacion = ViewState["UbicacionSeleccionada"]?.ToString() ?? "salon";

                    mesaService.EliminarMesa(mesaId);

                    // Guardar tab activo y mensaje en Session
                    Session["TabActivo"] = ubicacion;
                    Session["MensajeExito"] = "Mesa " + numeroMesa + " eliminada exitosamente.";

                    // Redirigir a URL limpia para evitar reenvío de formulario
                    Response.Redirect(Request.Url.AbsolutePath, false);
                    Context.ApplicationInstance.CompleteRequest();
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
                    string ubicacion = ViewState["UbicacionSeleccionada"]?.ToString() ?? "salon";

                    mesaService.ActualizarEstadoMesa(mesaId, "ocupada");

                    // Guardar tab activo y mensaje en Session
                    Session["TabActivo"] = ubicacion;
                    Session["MensajeExito"] = "Mesa " + numeroMesa + " ocupada exitosamente.";

                    // Redirigir a URL limpia para evitar reenvío de formulario
                    Response.Redirect(Request.Url.AbsolutePath, false);
                    Context.ApplicationInstance.CompleteRequest();
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
                    string ubicacion = ViewState["UbicacionSeleccionada"]?.ToString() ?? "salon";

                    mesaService.ActualizarEstadoMesa(mesaId, "libre");

                    // Guardar tab activo y mensaje en Session
                    Session["TabActivo"] = ubicacion;
                    Session["MensajeExito"] = "Mesa " + numeroMesa + " liberada exitosamente.";

                    // Redirigir a URL limpia para evitar reenvío de formulario
                    Response.Redirect(Request.Url.AbsolutePath, false);
                    Context.ApplicationInstance.CompleteRequest();
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

        protected void BuscarProducto_TextChanged(object sender, EventArgs e)
        {
            try
            {
                string textoBusqueda = TxtBuscarProducto.Text.Trim();

                if (!string.IsNullOrWhiteSpace(textoBusqueda))
                {
                    // Activar modo búsqueda
                    HayBusquedaActiva = true;

                    // Filtrar productos usando el servicio (busca directamente en la BD)
                    Productos = productoService.BuscarProductos(textoBusqueda);

                    // Mostrar botón de limpiar
                    BtnLimpiarBusqueda.Style["display"] = "inline-block";
                }
                else
                {
                    // Si está vacío, mostrar todos los productos
                    HayBusquedaActiva = false;
                    CargarCategoriasYProductos();

                    // Ocultar botón de limpiar
                    BtnLimpiarBusqueda.Style["display"] = "none";
                }

                // Actualizar el UpdatePanel
                UpdatePanelProductos.Update();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al buscar productos: " + ex.Message, "danger");
            }
        }

        protected void LimpiarBusqueda_Click(object sender, EventArgs e)
        {
            try
            {
                // Limpiar el textbox
                TxtBuscarProducto.Text = string.Empty;

                // Desactivar modo búsqueda
                HayBusquedaActiva = false;

                // Ocultar botón de limpiar
                BtnLimpiarBusqueda.Style["display"] = "none";

                // Recargar todos los productos
                CargarCategoriasYProductos();

                // Actualizar el UpdatePanel
                UpdatePanelProductos.Update();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al limpiar búsqueda: " + ex.Message, "danger");
            }
        }

        // Método para generar HTML de productos filtrados (búsqueda)
        protected string GenerarProductosBusqueda()
        {
            if (Productos == null || Productos.Count == 0)
            {
                return "<div style='text-align: center; padding: 40px; color: #999;'><i class='bi bi-search' style='font-size: 3rem;'></i><p style='margin-top: 20px;'>No se encontraron productos</p></div>";
            }

            System.Text.StringBuilder html = new System.Text.StringBuilder();
            html.Append("<div class='productos-busqueda' style='display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 15px; padding: 10px;'>");

            foreach (var prod in Productos)
            {
                html.AppendFormat(@"
                    <div class='producto-item' data-nombre='{0}' data-precio='{1}' data-productoid='{3}'>
                        <div class='producto-info'>
                            <div class='producto-nombre'>{0}</div>
                            <div class='producto-precio'>${1:N0}</div>
                        </div>
                        <div class='cantidad-control'>
                            <button type='button' onclick='cambiarCantidad(this, -1, event)'>-</button>
                            <input type='number' value='0' min='0' readonly>
                            <button type='button' onclick='cambiarCantidad(this, 1, event)'>+</button>
                        </div>
                    </div>
                ", prod.Nombre, prod.Precio, prod.CategoriaId, prod.ProductoId);
            }

            html.Append("</div>");
            return html.ToString();
        }
    }
}