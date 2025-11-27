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
        private PedidoService pedidoService = new PedidoService();
        private AsignacionMesaService asignacionService = new AsignacionMesaService();
        private MeseroService meseroService = new MeseroService();
        private VentaService ventaService = new VentaService();

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

            // Detectar postback de guardar posiciones
            if (IsPostBack)
            {
               

                string eventTarget = Request.Form["__EVENTTARGET"];
                string eventArgument = Request.Form["__EVENTARGUMENT"];

                if (eventArgument == "SavePositions" && !string.IsNullOrEmpty(HdnPosicionesMesas.Value))
                {
                    GuardarPosicionesMesas();
                    Session["MensajeExito"] = "Posiciones de mesas guardadas exitosamente";

                    // Guardar tab activo en Session antes del redirect
                    if (!string.IsNullOrEmpty(HdnTabActivo.Value))
                    {
                        Session["TabActivo"] = HdnTabActivo.Value;
                    }

                    // Redirigir para refrescar y salir del modo edicion
                    Response.Redirect(Request.Url.AbsolutePath, false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }
                else if (!string.IsNullOrEmpty(HdnPosicionesMesas.Value))
                {
                    // Guardado automático legacy (por si acaso)
                    GuardarPosicionesMesas();
                }
            }

            // Sincronizar el estado de las mesas con los pedidos activos
            mesaService.SincronizarEstadoMesasConPedidos();

            CargarMesasEnRepeaters();
            CargarCategoriasYProductos();

            // Solo cargar meseros en la primera carga, no en postbacks
            // para no perder la selección del usuario
            if (!IsPostBack)
            {
                if (Session["usuarioLoggeado"] == null)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                Usuario usuarioLoggeado = (Usuario)Session["usuarioLoggeado"];
                if (usuarioLoggeado.Rol != "gerente")
                {
                    divEditarMesas.Visible = false;
                    divEditarMesasPatio.Visible = false;
                }


                CargarMeseros();
            }

            CargarOrdenesActivas();

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

            // Restaurar modo edicion desde Session
            if (!IsPostBack && Session["ModoEdicionActivo"] != null)
            {
                string ubicacion = Session["ModoEdicionActivo"].ToString();

                // Registrar script para activar modo edicion
                string script = $@"
                    window.addEventListener('DOMContentLoaded', function() {{
                        setTimeout(function() {{
                            toggleEditMode('{ubicacion}');
                        }}, 200);
                    }});
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "RestaurarModoEdicion", script, true);

                Session.Remove("ModoEdicionActivo");
            }

            // Si el HdnTabActivo tiene un valor, asegurarse de que se use ese tab
            // Esto es importante después de postbacks para mantener el tab activo
            if (!string.IsNullOrEmpty(HdnTabActivo.Value))
            {
                // El tab activo se mantendrá por el JavaScript, pero registramos el valor en el servidor
                System.Diagnostics.Debug.WriteLine($"Tab activo en Page_Load: {HdnTabActivo.Value}");
            }

            // Abrir modal de orden si se acaba de abrir una mesa
            if (!IsPostBack && Session["MesaAbrir"] != null)
            {
                string numeroMesa = Session["MesaAbrir"].ToString();
                int meseroId = 0;
                string nombreMesero = "";

                // IMPORTANTE: Restaurar TODOS los datos de la mesa desde Session al ViewState
                if (Session["MesaIdAbrir"] != null)
                {
                    ViewState["MesaIdSeleccionada"] = (int)Session["MesaIdAbrir"];
                    ViewState["NumeroMesaSeleccionada"] = numeroMesa;
                    ViewState["UbicacionSeleccionada"] = Session["UbicacionAbrir"]?.ToString();
                    ViewState["EsMostrador"] = false;

                    if (Session["AsignacionIdAbrir"] != null)
                    {
                        ViewState["AsignacionIdActual"] = (int)Session["AsignacionIdAbrir"];
                    }

                    if (Session["MeseroIdAbrir"] != null)
                    {
                        meseroId = (int)Session["MeseroIdAbrir"];
                        ViewState["MeseroIdSeleccionado"] = meseroId;
                    }
                }

                // Obtener nombre del mesero
                if (meseroId > 0)
                {
                    Mesero mesero = meseroService.ObtenerPorId(meseroId);
                    if (mesero != null)
                    {
                        nombreMesero = mesero.Nombre + " " + mesero.Apellido;
                    }
                }

                // Limpiar Session después de restaurar
                Session.Remove("MesaAbrir");
                Session.Remove("MesaIdAbrir");
                Session.Remove("AsignacionIdAbrir");
                Session.Remove("UbicacionAbrir");
                Session.Remove("MeseroIdAbrir");

                AbrirModalOrden(numeroMesa, nombreMesero);
            }
        }

        private void CargarOrdenesActivas()
        {
            try
            {
                // Obtener todas las órdenes activas
                List<Pedido> ordenesActivas = pedidoService.ObtenerPedidosActivos();

                // Filtrar SOLO las órdenes de mostrador (EsMostrador = true)
                var ordenesParaMostrador = new List<object>();

                foreach (var orden in ordenesActivas)
                {
                    // SOLO agregar si es orden de mostrador
                    if (orden.EsMostrador)
                    {
                        ordenesParaMostrador.Add(new
                        {
                            PedidoId = orden.PedidoId,
                            FechaPedido = orden.FechaPedido,
                            Ubicacion = "Mostrador",
                            NumeroMesa = "N/A",
                            Total = orden.Total,
                            MostrarMesa = false
                        });
                    }
                }

                RepOrdenesMostrador.DataSource = ordenesParaMostrador;
                RepOrdenesMostrador.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar ordenes: " + ex.Message, "danger");
            }
        }

        protected string GenerarDetallesOrden(int pedidoId)
        {
            try
            {
                List<DetallePedido> detalles = pedidoService.ObtenerDetallesPedido(pedidoId);
                System.Text.StringBuilder html = new System.Text.StringBuilder();

                foreach (var detalle in detalles)
                {
                    html.AppendFormat(@"
                        <div class='orden-mostrador-producto'>
                            <span>{0} x {1}</span>
                            <span>${2:N0}</span>
                        </div>",
                        detalle.Cantidad,
                        detalle.NombreProducto,
                        detalle.Subtotal
                    );
                }

                return html.ToString();
            }
            catch
            {
                return "<p>Error al cargar detalles</p>";
            }
        }

        protected void SeleccionarOrdenMostrador_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string[] args = btn.CommandArgument.Split('|');
                int pedidoId = int.Parse(args[0]);
                string numeroMesa = args[1];
                string ubicacion = args[2];

                // LIMPIAR ViewState antes de establecer nuevos valores para evitar contaminacion cruzada
                LimpiarViewState();

                // Establecer contexto de mostrador
                ViewState["EsMostrador"] = true;
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = "Mostrador";
                ViewState["UbicacionSeleccionada"] = "mostrador";

                // IMPORTANTE: Guardar tab activo como "mostrador"
                HdnTabActivo.Value = "mostrador";

                // Mostrar resumen del pedido - siempre usar "mostrador" como ubicacion
                MostrarResumenPedido(pedidoId, numeroMesa, "mostrador");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al seleccionar orden: " + ex.Message, "danger");
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

        private void CargarMesasPorUbicacion(string ubicacion)
        {
            try
            {
                List<Mesa> mesas = mesaService.ListarMesasPorUbicacion(ubicacion);

                if (ubicacion == "salon")
                {
                    RepMesasSalon.DataSource = mesas;
                    RepMesasSalon.DataBind();
                }
                else if (ubicacion == "patio")
                {
                    RepMesasPatio.DataSource = mesas;
                    RepMesasPatio.DataBind();
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al actualizar las mesas: " + ex.Message, "danger");
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
                MostrarMensaje("Error al cargar productos y categorias: " + ex.Message, "danger");
            }
        }

        private void CargarMeseros()
        {
            try
            {
                // Cargar meseros activos desde la base de datos
                List<Mesero> meseros = meseroService.ListarActivos();

                // Limpiar el dropdown
                DdlCamarero.Items.Clear();

                // Agregar opción por defecto
                DdlCamarero.Items.Add(new ListItem("Seleccione un camarero", ""));

                // Agregar los meseros activos
                foreach (var mesero in meseros)
                {
                    string nombreCompleto = mesero.Nombre + " " + mesero.Apellido;
                    DdlCamarero.Items.Add(new ListItem(nombreCompleto, mesero.MeseroId.ToString()));
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar meseros: " + ex.Message, "danger");
            }
        }

        // Método auxiliar para obtener productos de una categoría específica
        public List<Producto> ObtenerProductosPorCategoria(int categoriaId)
        {
            if (Productos == null) return new List<Producto>();
            // Solo mostrar productos con stock disponible
            return Productos.Where(p => p.Categoria.CategoriaId == categoriaId && p.Stock > 0).ToList();
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

                // LIMPIAR ViewState antes de establecer nuevos valores para evitar contaminacion cruzada
                LimpiarViewState();

                // Guardar información en ViewState para usar en otros métodos
                ViewState["MesaIdSeleccionada"] = mesaId;
                ViewState["NumeroMesaSeleccionada"] = numeroMesa;
                ViewState["UbicacionSeleccionada"] = ubicacion;
                ViewState["EstadoMesaSeleccionada"] = estado;
                ViewState["EsMostrador"] = false;

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
                    // Si está ocupada, verificar si tiene un pedido activo
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorMesa(mesaId);

                    // DEBUG: Mostrar información de la asignación
                    System.Diagnostics.Debug.WriteLine($"=== DEBUG Mesa {numeroMesa} en {ubicacion} ===");
                    System.Diagnostics.Debug.WriteLine($"MesaId: {mesaId}, Estado: {estado}");

                    if (asignacion != null)
                    {
                        System.Diagnostics.Debug.WriteLine($"Asignación encontrada - AsignacionId: {asignacion.AsignacionId}");
                        System.Diagnostics.Debug.WriteLine($"Asignación Activa: {asignacion.Activa}");

                        // Buscar pedido activo para esta asignacion
                        List<Pedido> pedidos = pedidoService.ObtenerPedidosActivos();
                        System.Diagnostics.Debug.WriteLine($"Total pedidos activos en sistema: {pedidos.Count}");

                        // DEBUG: Mostrar todos los pedidos activos
                        foreach (var p in pedidos)
                        {
                            System.Diagnostics.Debug.WriteLine($"  - Pedido #{p.PedidoId}, AsignacionId: {p.AsignacionMesa?.AsignacionId}, EsMostrador: {p.EsMostrador}");
                        }

                        Pedido pedidoActivo = pedidos.FirstOrDefault(p => p.AsignacionMesa?.AsignacionId == asignacion.AsignacionId);

                        if (pedidoActivo != null)
                        {
                            System.Diagnostics.Debug.WriteLine($"✓ Pedido activo encontrado: #{pedidoActivo.PedidoId}");
                            // Tiene pedido activo, mostrar resumen
                            MostrarResumenPedido(pedidoActivo.PedidoId, numeroMesa, ubicacion);
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"✗ NO se encontró pedido activo para AsignacionId: {asignacion.AsignacionId}");

                            // Cargar nombre del mesero para mostrarlo en el modal
                            ViewState["AsignacionIdActual"] = asignacion.AsignacionId;
                            string nombreMesero = "";
                            Mesero mesero = meseroService.ObtenerPorId(asignacion.Mesero.MeseroId);
                            if (mesero != null)
                            {
                                nombreMesero = mesero.Nombre + " " + mesero.Apellido;
                            }

                            // No tiene pedido, abrir modal de orden para agregar productos
                            AbrirModalOrden(numeroMesa, nombreMesero);
                        }
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine($"✗ NO se encontró asignación activa para MesaId: {mesaId}");
                        // No tiene asignacion activa, abrir modal de orden para agregar productos
                        AbrirModalOrden(numeroMesa);
                    }
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

                // Guardar meseroId en ViewState para usarlo después
                ViewState["MeseroIdSeleccionado"] = meseroId;

                // Mantener tab activo
                HdnTabActivo.Value = ubicacion;

                // Actualizar estado de la mesa a "ocupada"
                mesaService.ActualizarEstadoMesa(mesaId, "ocupada");

                // Crear la asignación de mesa
                AsignacionMesa nuevaAsignacion = new AsignacionMesa
                {
                    Mesa = new Mesa { MesaId = mesaId },
                    Mesero = new Mesero { MeseroId = meseroId },
                    FechaAsignacion = DateTime.Now,
                    Activa = true
                };

                int asignacionId = asignacionService.CrearAsignacion(nuevaAsignacion);

                // IMPORTANTE: Guardar TODOS los datos en Session para que sobrevivan el redirect
                Session["TabActivo"] = ubicacion;
                Session["MesaAbrir"] = numeroMesa;
                Session["MesaIdAbrir"] = mesaId;
                Session["AsignacionIdAbrir"] = asignacionId;
                Session["UbicacionAbrir"] = ubicacion;
                Session["MeseroIdAbrir"] = meseroId;
                Session["MensajeExito"] = "Mesa " + numeroMesa + " abierta exitosamente.";

                // Redireccionar para evitar el problema de reenvío de formulario
                Response.Redirect(Request.Url.AbsolutePath, false);
                Context.ApplicationInstance.CompleteRequest();
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

        private void AbrirModalOrden(string numeroMesa, string nombreMesero = "")
        {
            // Abrir modal de orden para una NUEVA orden (no agregar más productos)
            string scriptMesero = "";
            if (!string.IsNullOrEmpty(nombreMesero))
            {
                scriptMesero = $@"
                    var panelMesero = document.getElementById('{PanelMeseroOrden.ClientID}');
                    var litMesero = document.getElementById('{LitNombreMeseroOrden.ClientID}');
                    if (panelMesero && litMesero) {{
                        litMesero.innerHTML = '<strong>{nombreMesero}</strong>';
                        panelMesero.style.display = 'block';
                    }}";
            }
            else
            {
                scriptMesero = $@"
                    var panelMesero = document.getElementById('{PanelMeseroOrden.ClientID}');
                    if (panelMesero) {{
                        panelMesero.style.display = 'none';
                    }}";
            }

            string script = $@"
                setTimeout(function() {{
                    // Limpiar variables globales de productos existentes
                    window.productosExistentesOrden = [];
                    window.totalExistenteOrden = 0;

                    // Limpiar atributo de tiene-existentes
                    var resumenOrden = document.getElementById('resumenOrden');
                    if (resumenOrden) {{
                        resumenOrden.removeAttribute('data-tiene-existentes');
                        resumenOrden.innerHTML = '<p style=""color: #999; font-style: italic;"">No hay productos seleccionados</p>';
                    }}

                    // Limpiar total
                    var totalOrden = document.getElementById('totalOrden');
                    if (totalOrden) {{
                        totalOrden.textContent = '$0';
                    }}

                    // Limpiar todas las cantidades de productos
                    document.querySelectorAll('.producto-item input[type=""number""]').forEach(function(input) {{
                        input.value = 0;
                    }});

                    // Configurar mesero
                    {scriptMesero}

                    // Abrir modal de orden
                    document.getElementById('modal-orden-mesa-numero').textContent = '{numeroMesa}';
                    var modal = new bootstrap.Modal(document.getElementById('modalOrden'));
                    modal.show();
                }}, 100);
            ";
            ClientScript.RegisterStartupScript(this.GetType(), "AbrirModalOrden", script, true);
        }

        private void MostrarResumenPedido(int pedidoId, string numeroMesa, string ubicacion)
        {
            try
            {
                // IMPORTANTE: Establecer el tab activo ANTES de abrir el modal
                HdnTabActivo.Value = ubicacion;
                ViewState["UbicacionSeleccionada"] = ubicacion;

                // Obtener el pedido
                Pedido pedido = pedidoService.ObtenerPedidoPorId(pedidoId);
                if (pedido == null)
                {
                    MostrarMensaje("No se encontro el pedido.", "warning");
                    return;
                }

                // Obtener los detalles del pedido
                List<DetallePedido> detalles = pedidoService.ObtenerDetallesPedido(pedidoId);

                // Guardar pedidoId en HiddenField Y ViewState para asegurar persistencia
                HdnPedidoIdActual.Value = pedidoId.ToString();
                ViewState["PedidoIdActual"] = pedidoId;

                // Obtener y mostrar el nombre del mesero
                string nombreMesero = "N/A";
                if (pedido.EsMostrador)
                {
                    nombreMesero = "Mostrador";
                }
                else if (pedido.AsignacionMesa?.AsignacionId > 0)
                {
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorId(pedido.AsignacionMesa.AsignacionId);
                    if (asignacion != null)
                    {
                        Mesero mesero = meseroService.ObtenerPorId(asignacion.Mesero.MeseroId);
                        if (mesero != null)
                        {
                            nombreMesero = mesero.Nombre + " " + mesero.Apellido;
                        }
                    }
                }
                LitNombreMesero.Text = nombreMesero;

                // Generar HTML con los productos
                System.Text.StringBuilder htmlProductos = new System.Text.StringBuilder();
                foreach (var detalle in detalles)
                {
                    decimal subtotal = detalle.Cantidad * detalle.PrecioUnitario;
                    htmlProductos.AppendFormat(@"
                        <div class='resumen-item'>
                            <div class='resumen-item-info'>
                                <div class='resumen-item-nombre'>{0}</div>
                                <div class='resumen-item-cantidad'>Cantidad: {1} x ${2:N0}</div>
                            </div>
                            <div class='resumen-item-precio'>${3:N0}</div>
                        </div>",
                        detalle.NombreProducto,
                        detalle.Cantidad,
                        detalle.PrecioUnitario,
                        subtotal
                    );
                }

                // Abrir el modal con JavaScript
                string script = $@"
                    setTimeout(function() {{
                        // Establecer datos del modal
                        document.getElementById('modal-numero-orden').textContent = '{pedidoId}';
                        document.getElementById('modal-resumen-mesa-numero').textContent = '{numeroMesa}';
                        document.getElementById('modal-ubicacion-mesa').textContent = '{ubicacion.ToUpper()} - Mesa {numeroMesa}';
                        document.getElementById('modal-fecha-orden').textContent = '{pedido.FechaPedido.ToString("dd/MM/yyyy HH:mm")}';
                        document.getElementById('resumenCompleto').innerHTML = `{htmlProductos.ToString()}`;
                        document.getElementById('totalPagar').textContent = '${pedido.Total:N0}';

                        // Abrir modal de resumen
                        var modal = new bootstrap.Modal(document.getElementById('modalResumenPago'));
                        modal.show();
                    }}, 100);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "MostrarResumenPedido", script, true);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al mostrar el resumen del pedido: " + ex.Message, "danger");
            }
        }

        protected void AbrirModalEliminarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string[] args = btn.CommandArgument.Split('|');
                int mesaId = int.Parse(args[0]);
                string numeroMesa = args[1];
                string ubicacion = args[2];

                // Guardar datos en HiddenFields
                HdnMesaIdEliminar.Value = mesaId.ToString();
                HdnMesaNumeroEliminar.Value = numeroMesa;
                HdnMesaUbicacionEliminar.Value = ubicacion;

                // Guardar tab activo
                HdnTabActivo.Value = ubicacion;

                // Abrir modal de confirmación
                string script = @"
                    setTimeout(function() {
                        document.getElementById('modalEliminarNumero').textContent = '" + numeroMesa + @"';
                        var modal = new bootstrap.Modal(document.getElementById('modalEliminarMesa'));
                        modal.show();
                    }, 100);
                ";
                ClientScript.RegisterStartupScript(this.GetType(), "AbrirModalEliminar", script, true);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al abrir modal de eliminacion: " + ex.Message, "danger");
            }
        }

        protected void AgregarMesa_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                string ubicacion = btn.CommandArgument;

                // Crear nueva mesa (el número se asigna automáticamente en el servicio)
                Mesa nuevaMesa = new Mesa
                {
                    Ubicacion = ubicacion,
                    Estado = "libre"
                };

                mesaService.AgregarMesa(nuevaMesa);

                // Guardar tab activo, mensaje y modo edicion en Session
                Session["TabActivo"] = ubicacion;
                Session["MensajeExito"] = "Mesa agregada exitosamente en " + ubicacion + ".";
                Session["ModoEdicionActivo"] = ubicacion; // Mantener modo edicion

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

                    // Guardar tab activo, mensaje y modo edicion en Session
                    Session["TabActivo"] = ubicacion;
                    Session["MensajeExito"] = "Mesa " + numeroMesa + " eliminada exitosamente.";
                    Session["ModoEdicionActivo"] = ubicacion; // Mantener modo edicion

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
                // LIMPIAR ViewState antes de establecer nuevos valores para evitar contaminacion cruzada
                LimpiarViewState();

                // Guardar tab activo
                HdnTabActivo.Value = "mostrador";

                // Guardar que es mostrador
                ViewState["EsMostrador"] = true;
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = "Mostrador";
                ViewState["UbicacionSeleccionada"] = "mostrador";

                // Abrir modal de orden (sin mesero, ya que es mostrador)
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

        // Metodo auxiliar para limpiar ViewState y evitar contaminacion cruzada entre secciones
        private void LimpiarViewState()
        {
            ViewState["MesaIdSeleccionada"] = null;
            ViewState["NumeroMesaSeleccionada"] = null;
            ViewState["UbicacionSeleccionada"] = null;
            ViewState["EstadoMesaSeleccionada"] = null;
            ViewState["EsMostrador"] = null;
            ViewState["MeseroIdSeleccionado"] = null;
            HdnPedidoIdActual.Value = string.Empty;
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
                MostrarMensaje("Error al limpiar busqueda: " + ex.Message, "danger");
            }
        }

        // Metodo para generar HTML de productos filtrados (busqueda)
        protected string GenerarProductosBusqueda()
        {
            if (Productos == null || Productos.Count == 0)
            {
                return "<div style='text-align: center; padding: 40px; color: #999;'><i class='bi bi-search' style='font-size: 3rem;'></i><p style='margin-top: 20px;'>No se encontraron productos</p></div>";
            }

            // Filtrar solo productos con stock disponible
            var productosConStock = Productos.Where(p => p.Stock > 0).ToList();

            if (productosConStock.Count == 0)
            {
                return "<div style='text-align: center; padding: 40px; color: #999;'><i class='bi bi-inbox' style='font-size: 3rem;'></i><p style='margin-top: 20px;'>No hay productos con stock disponible</p></div>";
            }

            System.Text.StringBuilder html = new System.Text.StringBuilder();
            html.Append("<div class='productos-busqueda' style='display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 15px; padding: 10px;'>");

            foreach (var prod in productosConStock)
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
                ", prod.Nombre, prod.Precio, prod.Categoria.CategoriaId, prod.ProductoId);
            }

            html.Append("</div>");
            return html.ToString();
        }

        protected void ConfirmarOrden_Click(object sender, EventArgs e)
        {
            try
            {
                string productosJson = HdnProductosOrden.Value;

                // Si no hay productos nuevos PERO hay un pedido activo, mostrar resumen directamente
                if ((string.IsNullOrEmpty(productosJson) || productosJson == "[]") &&
                    !string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    int pedidoIdExistente = int.Parse(HdnPedidoIdActual.Value);
                    string numeroMesaExistente = ViewState["NumeroMesaSeleccionada"]?.ToString() ?? "Mostrador";
                    string ubicacionExistente = ViewState["UbicacionSeleccionada"]?.ToString() ?? "salon";

                    MostrarResumenPedido(pedidoIdExistente, numeroMesaExistente, ubicacionExistente);
                    return;
                }

                if (string.IsNullOrEmpty(productosJson))
                {
                    MostrarMensaje("No se recibieron productos en la orden", "warning");
                    return;
                }

                var productosSeleccionados = Newtonsoft.Json.JsonConvert.DeserializeAnonymousType(
                    productosJson,
                    new[] { new { ProductoId = 0, Cantidad = 0, PrecioUnitario = 0m, Nombre = "" } }
                );

                if (productosSeleccionados == null || productosSeleccionados.Length == 0)
                {
                    MostrarMensaje("No se seleccionaron productos", "warning");
                    return;
                }

                // Instancias de servicios
                PedidoService pedidoService = this.pedidoService ?? new PedidoService();
                MesaService mesaService = this.mesaService ?? new MesaService();
                ProductoService productoService = new ProductoService();
                AsignacionMesaService asignacionService = new AsignacionMesaService();

                // VALIDAMOS STOCK PARA TODOS los productos antes de insertar nada
                foreach (var p in productosSeleccionados)
                {
                    int stock = productoService.ObtenerStock(p.ProductoId);
                    if (stock < p.Cantidad)
                    {
                        MostrarMensaje($"No hay stock suficiente para {p.Nombre} (Id {p.ProductoId}). Stock: {stock}, Pedido: {p.Cantidad}", "warning");
                        return;
                    }
                }

                // CALCULAR TOTAL
                decimal total = 0m;
                foreach (var producto in productosSeleccionados)
                    total += producto.Cantidad * producto.PrecioUnitario;

                int pedidoId;

                // Ubicación / mostrador
                string ubicacion = !string.IsNullOrEmpty(HdnTabActivo.Value) ? HdnTabActivo.Value : "salon";
                bool esMostrador = ViewState["EsMostrador"] != null && (bool)ViewState["EsMostrador"];
                if (ViewState["UbicacionSeleccionada"] == null || string.IsNullOrEmpty(ViewState["UbicacionSeleccionada"].ToString()))
                    ViewState["UbicacionSeleccionada"] = ubicacion;
                else
                    ubicacion = ViewState["UbicacionSeleccionada"].ToString();

                string numeroMesa = ViewState["NumeroMesaSeleccionada"]?.ToString() ?? "Mostrador";

                
                if (!string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    pedidoId = int.Parse(HdnPedidoIdActual.Value);

                    // Obtener el pedido actual para sumar al total existente
                    Pedido pedidoActual = pedidoService.ObtenerPedidoPorId(pedidoId);
                    if (pedidoActual == null)
                    {
                        MostrarMensaje("No se encontró el pedido existente.", "danger");
                        return;
                    }
                    decimal totalAnterior = pedidoActual.Total;

                    foreach (var producto in productosSeleccionados)
                    {
                        DetallePedido detalle = new DetallePedido
                        {
                            Pedido = new Pedido { PedidoId = pedidoId },
                            Producto = new Producto { ProductoId = producto.ProductoId },
                            Cantidad = producto.Cantidad,
                            PrecioUnitario = producto.PrecioUnitario,
                            Subtotal = producto.Cantidad * producto.PrecioUnitario
                        };

                        pedidoService.AgregarDetallePedido(detalle);

                        // DESCONTAR STOCK
                        productoService.DescontarStock(detalle.Producto.ProductoId, detalle.Cantidad);
                    }

                    // Actualizar total del pedido
                    decimal totalNuevo = totalAnterior + total;
                    pedidoService.ActualizarTotalPedido(pedidoId, totalNuevo);
                }
                else
                {
                    // Pedido nuevo
                    int asignacionId = 0;
                    if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                    {
                        if (ViewState["AsignacionIdActual"] != null)
                        {
                            asignacionId = (int)ViewState["AsignacionIdActual"];
                        }
                        else
                        {
                            int mesaId = (int)ViewState["MesaIdSeleccionada"];
                            AsignacionMesa asignacionExistente = asignacionService.ObtenerAsignacionPorMesa(mesaId);
                            if (asignacionExistente != null)
                            {
                                asignacionId = asignacionExistente.AsignacionId;
                                ViewState["AsignacionIdActual"] = asignacionId;
                            }
                            else
                            {
                                int meseroId = 1;
                                if (ViewState["MeseroIdSeleccionado"] != null)
                                    meseroId = (int)ViewState["MeseroIdSeleccionado"];

                                AsignacionMesa nuevaAsignacion = new AsignacionMesa
                                {
                                    Mesa = new Mesa { MesaId = mesaId },
                                    Mesero = new Mesero { MeseroId = meseroId },
                                    FechaAsignacion = DateTime.Now,
                                    Activa = true
                                };
                                asignacionId = asignacionService.CrearAsignacion(nuevaAsignacion);
                                ViewState["AsignacionIdActual"] = asignacionId;
                            }
                        }
                    }

                    // Crear pedido (usa tu método existente)
                    Pedido nuevoPedido = new Pedido
                    {
                        FechaPedido = DateTime.Now,
                        EstadoPedido = true,
                        Total = total,
                        AsignacionMesa = asignacionId > 0 ? new AsignacionMesa { AsignacionId = asignacionId } : null,
                        EsMostrador = esMostrador
                    };

                    pedidoId = pedidoService.CrearPedido(nuevoPedido);

                    // Agregar detalles y descontar stock
                    foreach (var producto in productosSeleccionados)
                    {
                        DetallePedido detalle = new DetallePedido
                        {
                            Pedido = new Pedido { PedidoId = pedidoId },
                            Producto = new Producto { ProductoId = producto.ProductoId },
                            Cantidad = producto.Cantidad,
                            PrecioUnitario = producto.PrecioUnitario,
                            Subtotal = producto.Cantidad * producto.PrecioUnitario
                        };

                        pedidoService.AgregarDetallePedido(detalle);

                        // DESCONTAR STOCK
                        productoService.DescontarStock(detalle.Producto.ProductoId, detalle.Cantidad);
                    }

                    // Si no es mostrador, marcar mesa ocupada
                    if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                    {
                        int mesaId = (int)ViewState["MesaIdSeleccionada"];
                        mesaService.ActualizarEstadoMesa(mesaId, "ocupada");
                    }
                }

                // Guardar y limpiar
                HdnPedidoIdActual.Value = pedidoId.ToString();
                ViewState["PedidoIdActual"] = pedidoId;
                HdnProductosOrden.Value = string.Empty;
                HdnTabActivo.Value = ubicacion;

                // Actualizaciones de UI / resumen
                if (esMostrador)
                    CargarOrdenesActivas();

                MostrarResumenPedido(pedidoId, numeroMesa, ubicacion);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al confirmar la orden: " + ex.Message, "danger");
            }
        }





        protected void RealizarPago_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener el pedidoId del HiddenField
                if (string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    MostrarMensaje("No se encontro el pedido", "warning");
                    return;
                }

                int pedidoId = int.Parse(HdnPedidoIdActual.Value);

                // Finalizar el pedido
                pedidoService.FinalizarPedido(pedidoId);

                // Obtener ubicación del HiddenField (fuente de verdad)
                string ubicacion = !string.IsNullOrEmpty(HdnTabActivo.Value) ? HdnTabActivo.Value : "salon";

                // Liberar la mesa (si no es mostrador)
                bool esMostrador = ViewState["EsMostrador"] != null && (bool)ViewState["EsMostrador"];

                if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                {
                    int mesaId = (int)ViewState["MesaIdSeleccionada"];

                    // Cambiar estado de la mesa a libre
                    mesaService.ActualizarEstadoMesa(mesaId, "libre");

                    // Desactivar la asignación
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorMesa(mesaId);
                    if (asignacion != null)
                    {
                        asignacionService.DesactivarAsignacion(asignacion.AsignacionId);
                    }
                }

                // Limpiar ViewState
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = null;
                ViewState["UbicacionSeleccionada"] = null;
                ViewState["EsMostrador"] = null;
                HdnPedidoIdActual.Value = string.Empty;

                // Guardar mensaje y tab activo en Session
                Session["TabActivo"] = ubicacion;
                Session["MensajeExito"] = "Pago realizado exitosamente. Orden #" + pedidoId + " finalizada.";

                // Redirigir para evitar reenvío de formulario
                Response.Redirect(Request.Url.AbsolutePath, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al procesar el pago: " + ex.Message, "danger");
            }
        }

        protected void ConfirmarPago_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener el pedidoId del HiddenField
                if (string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    MostrarMensaje("No se encontro el pedido", "warning");
                    return;
                }

                int pedidoId = int.Parse(HdnPedidoIdActual.Value);

                // Obtener el pedido para obtener el total
                Pedido pedido = pedidoService.ObtenerPedidoPorId(pedidoId);
                if (pedido == null)
                {
                    MostrarMensaje("No se encontro el pedido", "warning");
                    return;
                }

                // Obtener metodo de pago y monto recibido de los hidden fields
                string metodoPago = HdnMetodoPago.Value;
                decimal montoRecibido = 0;

                if (!string.IsNullOrEmpty(HdnMontoRecibido.Value))
                {
                    montoRecibido = decimal.Parse(HdnMontoRecibido.Value, System.Globalization.CultureInfo.InvariantCulture);
                }

                // Validar que el metodo de pago no este vacio
                if (string.IsNullOrEmpty(metodoPago))
                {
                    MostrarMensaje("Debe seleccionar un metodo de pago", "warning");
                    return;
                }

                // Crear el registro de venta
                Venta venta = new Venta
                {
                    Pedido = new Pedido { PedidoId = pedidoId },
                    FechaVenta = DateTime.Now,
                    MontoTotal = pedido.Total,
                    MetodoPago = metodoPago,
                    MontoRecibido = montoRecibido > 0 ? (decimal?)montoRecibido : null,
                    Gerente = null // Por ahora no hay gerente asignado
                };

                // Registrar la venta en la base de datos
                int ventaId = ventaService.RegistrarVenta(venta);

                // Finalizar el pedido
                pedidoService.FinalizarPedido(pedidoId);

                // Obtener ubicacion del HiddenField (fuente de verdad)
                string ubicacion = !string.IsNullOrEmpty(HdnTabActivo.Value) ? HdnTabActivo.Value : "salon";

                // Liberar la mesa (si no es mostrador)
                bool esMostrador = ViewState["EsMostrador"] != null && (bool)ViewState["EsMostrador"];

                if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                {
                    int mesaId = (int)ViewState["MesaIdSeleccionada"];

                    // Cambiar estado de la mesa a libre
                    mesaService.ActualizarEstadoMesa(mesaId, "libre");

                    // Desactivar la asignacion
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorMesa(mesaId);
                    if (asignacion != null)
                    {
                        asignacionService.DesactivarAsignacion(asignacion.AsignacionId);
                    }
                }

                // Limpiar ViewState y HiddenFields
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = null;
                ViewState["UbicacionSeleccionada"] = null;
                ViewState["EsMostrador"] = null;
                HdnPedidoIdActual.Value = string.Empty;
                HdnMetodoPago.Value = string.Empty;
                HdnMontoRecibido.Value = string.Empty;

                // Guardar tab activo en Session (no mostramos mensaje, usamos el modal de JavaScript)
                Session["TabActivo"] = ubicacion;

                // Redirigir para evitar reenvio de formulario
                Response.Redirect(Request.Url.AbsolutePath, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al confirmar el pago: " + ex.Message, "danger");
            }
        }

        protected void AgregarMasProductos_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== EJECUTANDO AgregarMasProductos_Click ===");

                // Intentar obtener el pedidoId del HiddenField primero, luego del ViewState
                int pedidoId = 0;

                if (!string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    pedidoId = int.Parse(HdnPedidoIdActual.Value);
                    System.Diagnostics.Debug.WriteLine($"PedidoId desde HiddenField: {pedidoId}");
                }
                else if (ViewState["PedidoIdActual"] != null)
                {
                    pedidoId = (int)ViewState["PedidoIdActual"];
                    System.Diagnostics.Debug.WriteLine($"PedidoId desde ViewState: {pedidoId}");
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: No se encontró PedidoId en HiddenField ni ViewState");
                    MostrarMensaje("No se encontro el pedido", "warning");
                    return;
                }

                // Guardar pedidoId en ViewState y HiddenField para el siguiente postback
                ViewState["PedidoIdActual"] = pedidoId;
                HdnPedidoIdActual.Value = pedidoId.ToString();

                // Obtener los detalles del pedido actual
                List<DetallePedido> detalles = pedidoService.ObtenerDetallesPedido(pedidoId);

                // Obtener el pedido para saber la mesa y reconstruir el contexto correcto
                Pedido pedido = pedidoService.ObtenerPedidoPorId(pedidoId);
                string numeroMesa = "Mostrador";
                string ubicacion = "mostrador";

                // Reconstruir el ViewState basado en el pedido actual para mantener el contexto correcto
                if (pedido.EsMostrador)
                {
                    // Es mostrador
                    ViewState["EsMostrador"] = true;
                    ViewState["MesaIdSeleccionada"] = null;
                    ViewState["NumeroMesaSeleccionada"] = "Mostrador";
                    ViewState["UbicacionSeleccionada"] = "mostrador";
                    numeroMesa = "Mostrador";
                    ubicacion = "mostrador";
                }
                else if (pedido.AsignacionMesa?.AsignacionId > 0)
                {
                    // Es una mesa
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorId(pedido.AsignacionMesa.AsignacionId);
                    if (asignacion != null)
                    {
                        Mesa mesa = mesaService.ObtenerMesaPorId(asignacion.Mesa.MesaId);
                        if (mesa != null)
                        {
                            numeroMesa = mesa.NumeroMesa;
                            ubicacion = mesa.Ubicacion;

                            // Establecer ViewState para mantener contexto
                            ViewState["EsMostrador"] = false;
                            ViewState["MesaIdSeleccionada"] = mesa.MesaId;
                            ViewState["NumeroMesaSeleccionada"] = mesa.NumeroMesa;
                            ViewState["UbicacionSeleccionada"] = mesa.Ubicacion;
                        }
                    }
                }

                // Guardar tab activo
                HdnTabActivo.Value = ubicacion;

                // Obtener nombre del mesero
                string nombreMesero = "";
                if (!pedido.EsMostrador && pedido.AsignacionMesa?.AsignacionId > 0)
                {
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorId(pedido.AsignacionMesa.AsignacionId);
                    if (asignacion != null)
                    {
                        Mesero mesero = meseroService.ObtenerPorId(asignacion.Mesero.MeseroId);
                        if (mesero != null)
                        {
                            nombreMesero = mesero.Nombre + " " + mesero.Apellido;
                        }
                    }
                }

                // Generar JavaScript para abrir modal
                // IMPORTANTE: Mostrar productos existentes en el RESUMEN DE LA ORDEN
                System.Text.StringBuilder scriptProductos = new System.Text.StringBuilder();

                scriptProductos.Append(@"
                    // Esperar a que Bootstrap esté disponible
                    (function ejecutarCuandoBootstrapEsteDisponible() {
                        if (typeof bootstrap === 'undefined') {
                            setTimeout(ejecutarCuandoBootstrapEsteDisponible, 100);
                            return;
                        }

                        // Función para abrir el modal de orden con productos existentes
                        function abrirModalConProductosExistentes() {
                ");

                // Limpiar todos los inputs (ponerlos en 0) para agregar solo productos NUEVOS
                scriptProductos.Append(@"
                    document.querySelectorAll('.producto-item input[type=""number""]').forEach(function(input) {
                        input.value = 0;
                    });
                ");

                // Construir HTML del resumen con productos existentes Y datos JSON para JavaScript
                System.Text.StringBuilder htmlResumen = new System.Text.StringBuilder();
                System.Text.StringBuilder jsonProductosExistentes = new System.Text.StringBuilder();
                jsonProductosExistentes.Append("[");
                decimal totalExistente = 0;
                bool primero = true;

                foreach (var detalle in detalles)
                {
                    totalExistente += detalle.Subtotal;
                    htmlResumen.AppendFormat(@"
                        <div class='resumen-item' data-tipo='existente'>
                            <div class='resumen-item-info'>
                                <div class='resumen-item-nombre'>{0}</div>
                                <div class='resumen-item-cantidad'>Cantidad: {1} x ${2:N0}</div>
                            </div>
                            <div class='resumen-item-precio'>${3:N0}</div>
                        </div>",
                        detalle.NombreProducto.Replace("'", "\\'"),
                        detalle.Cantidad,
                        detalle.PrecioUnitario,
                        detalle.Subtotal
                    );

                    // Construir JSON de productos existentes para JavaScript
                    if (!primero) jsonProductosExistentes.Append(",");
                    jsonProductosExistentes.AppendFormat(
                        System.Globalization.CultureInfo.InvariantCulture,
                        @"{{""nombre"":""{0}"",""cantidad"":{1},""precio"":{2},""subtotal"":{3}}}",
                        detalle.NombreProducto.Replace("\"", "\\\""),
                        detalle.Cantidad,
                        detalle.PrecioUnitario,
                        detalle.Subtotal
                    );
                    primero = false;
                }

                jsonProductosExistentes.Append("]");

                // Script para mostrar/ocultar mesero
                string scriptMesero = "";
                if (!string.IsNullOrEmpty(nombreMesero))
                {
                    scriptMesero = $@"
                    var panelMesero = document.getElementById('{PanelMeseroOrden.ClientID}');
                    var litMesero = document.getElementById('{LitNombreMeseroOrden.ClientID}');
                    if (panelMesero && litMesero) {{
                        litMesero.innerHTML = '<strong>{nombreMesero}</strong>';
                        panelMesero.style.display = 'block';
                    }}";
                }
                else
                {
                    scriptMesero = $@"
                    var panelMesero = document.getElementById('{PanelMeseroOrden.ClientID}');
                    if (panelMesero) {{
                        panelMesero.style.display = 'none';
                    }}";
                }

                // Establecer el HTML del resumen directamente (SIN llamar a actualizarResumenOrden)
                // porque esa funcion solo lee los inputs que estan en 0
                scriptProductos.AppendFormat(
                    System.Globalization.CultureInfo.InvariantCulture,
                    @"
                    // Guardar productos existentes en variable global para que actualizarResumenOrden pueda usarlos
                    window.productosExistentesOrden = {0};
                    window.totalExistenteOrden = {1};

                    // Establecer el resumen con los productos existentes
                    var resumenOrden = document.getElementById('resumenOrden');
                    if (resumenOrden) {{
                        resumenOrden.innerHTML = `{2}`;
                        // Marcar que hay productos existentes
                        resumenOrden.setAttribute('data-tiene-existentes', 'true');
                    }}

                    // Establecer el total
                    var totalOrden = document.getElementById('totalOrden');
                    if (totalOrden) {{
                        totalOrden.textContent = formatearPrecio({3});
                    }}

                    // Configurar mesero
                    {5}

                    // Establecer el numero de mesa en el modal
                    document.getElementById('modal-orden-mesa-numero').textContent = '{4}';

                    // Abrir el modal de orden
                    var modalOrden = document.getElementById('modalOrden');
                    var modal = new bootstrap.Modal(modalOrden);
                    modal.show();
                ", jsonProductosExistentes.ToString(), totalExistente, htmlResumen.ToString().Replace("`", "\\`"), totalExistente, numeroMesa, scriptMesero);

                scriptProductos.Append(@"
                        }

                        // Cerrar el modal de resumen usando Bootstrap
                        var modalResumen = document.getElementById('modalResumenPago');
                        var modalResumenInstance = bootstrap.Modal.getInstance(modalResumen);

                        if (modalResumenInstance) {
                            modalResumenInstance.hide();
                        }

                        // Esperar a que se cierre el modal antes de abrir el siguiente
                        setTimeout(abrirModalConProductosExistentes, 500);

                    })(); // Ejecutar la función inmediatamente
                ");

                ClientScript.RegisterStartupScript(this.GetType(), "AbrirModalConProductos", scriptProductos.ToString(), true);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al agregar mas productos: " + ex.Message, "danger");
            }
        }

        private void GuardarPosicionesMesas()
        {
            try
            {
                string jsonPosiciones = HdnPosicionesMesas.Value;

                // Parsear el JSON usando Newtonsoft.Json
                var posicionesPorUbicacion = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, List<PosicionMesa>>>(jsonPosiciones);

                if (posicionesPorUbicacion != null)
                {
                    foreach (var ubicacion in posicionesPorUbicacion)
                    {
                        foreach (var posicion in ubicacion.Value)
                        {
                            mesaService.ActualizarPosicion(int.Parse(posicion.mesaId), posicion.x, posicion.y);
                        }
                    }
                }

                // Limpiar el campo después de guardar
                HdnPosicionesMesas.Value = string.Empty;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al guardar posiciones: " + ex.Message);
            }
        }

        // Clase auxiliar para deserializar las posiciones
        private class PosicionMesa
        {
            public string mesaId { get; set; }
            public int x { get; set; }
            public int y { get; set; }
        }

        protected void CancelarOrden_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener el pedidoId del HiddenField
                if (string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    MostrarMensaje("No se encontro el pedido", "warning");
                    return;
                }

                int pedidoId = int.Parse(HdnPedidoIdActual.Value);

                // Cancelar el pedido (elimina pedido y detalles)
                pedidoService.CancelarPedido(pedidoId);

                // Obtener ubicación del HiddenField (fuente de verdad)
                string ubicacion = !string.IsNullOrEmpty(HdnTabActivo.Value) ? HdnTabActivo.Value : "salon";

                // Liberar la mesa (si no es mostrador)
                bool esMostrador = ViewState["EsMostrador"] != null && (bool)ViewState["EsMostrador"];

                if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                {
                    int mesaId = (int)ViewState["MesaIdSeleccionada"];

                    // Cambiar estado de la mesa a libre
                    mesaService.ActualizarEstadoMesa(mesaId, "libre");

                    // Desactivar la asignación
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorMesa(mesaId);
                    if (asignacion != null)
                    {
                        asignacionService.DesactivarAsignacion(asignacion.AsignacionId);
                    }
                }

                // Limpiar ViewState
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = null;
                ViewState["UbicacionSeleccionada"] = null;
                ViewState["EsMostrador"] = null;
                HdnPedidoIdActual.Value = string.Empty;

                // Guardar mensaje y tab activo en Session
                Session["TabActivo"] = ubicacion;
                Session["MensajeExito"] = "Orden #" + pedidoId + " cancelada exitosamente.";

                // Redirigir para evitar reenvío de formulario
                Response.Redirect(Request.Url.AbsolutePath, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cancelar la orden: " + ex.Message, "danger");
            }
        }
    }
}