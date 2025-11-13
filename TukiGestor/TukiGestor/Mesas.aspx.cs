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

            // Sincronizar el estado de las mesas con los pedidos activos
            mesaService.SincronizarEstadoMesasConPedidos();

            CargarMesasEnRepeaters();
            CargarCategoriasYProductos();
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
                        ViewState["MeseroIdSeleccionado"] = (int)Session["MeseroIdAbrir"];
                    }
                }

                // Limpiar Session después de restaurar
                Session.Remove("MesaAbrir");
                Session.Remove("MesaIdAbrir");
                Session.Remove("AsignacionIdAbrir");
                Session.Remove("UbicacionAbrir");
                Session.Remove("MeseroIdAbrir");

                AbrirModalOrden(numeroMesa);
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
                            System.Diagnostics.Debug.WriteLine($"  - Pedido #{p.PedidoId}, AsignacionId: {p.AsignacionId}, EsMostrador: {p.EsMostrador}");
                        }

                        Pedido pedidoActivo = pedidos.FirstOrDefault(p => p.AsignacionId == asignacion.AsignacionId);

                        if (pedidoActivo != null)
                        {
                            System.Diagnostics.Debug.WriteLine($"✓ Pedido activo encontrado: #{pedidoActivo.PedidoId}");
                            // Tiene pedido activo, mostrar resumen
                            MostrarResumenPedido(pedidoActivo.PedidoId, numeroMesa, ubicacion);
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"✗ NO se encontró pedido activo para AsignacionId: {asignacion.AsignacionId}");
                            // No tiene pedido, abrir modal de orden para agregar productos
                            AbrirModalOrden(numeroMesa);
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
                    MesaId = mesaId,
                    MeseroId = meseroId,
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

        private void AbrirModalOrden(string numeroMesa)
        {
            // Abrir modal de orden para una NUEVA orden (no agregar más productos)
            string script = $@"
                setTimeout(function() {{
                    // Restaurar tab activo
                    restaurarTab();

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

                // Guardar pedidoId en HiddenField
                HdnPedidoIdActual.Value = pedidoId.ToString();

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
                        // Restaurar tab activo
                        restaurarTab();

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
                        restaurarTab();
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

                // Guardar tab activo y mensaje en Session
                Session["TabActivo"] = ubicacion;
                Session["MensajeExito"] = "Mesa agregada exitosamente en " + ubicacion + ".";

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
                // LIMPIAR ViewState antes de establecer nuevos valores para evitar contaminacion cruzada
                LimpiarViewState();

                // Guardar tab activo
                HdnTabActivo.Value = "mostrador";

                // Guardar que es mostrador
                ViewState["EsMostrador"] = true;
                ViewState["MesaIdSeleccionada"] = null;
                ViewState["NumeroMesaSeleccionada"] = "Mostrador";
                ViewState["UbicacionSeleccionada"] = "mostrador";

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

        protected void ConfirmarOrden_Click(object sender, EventArgs e)
        {
            try
            {
                // Obtener los datos del HiddenField
                string productosJson = HdnProductosOrden.Value;

                if (string.IsNullOrEmpty(productosJson))
                {
                    MostrarMensaje("No se recibieron productos en la orden", "warning");
                    return;
                }

                // Deserializar el JSON a una lista de objetos
                var productosSeleccionados = Newtonsoft.Json.JsonConvert.DeserializeAnonymousType(
                    productosJson,
                    new[] { new { ProductoId = 0, Cantidad = 0, PrecioUnitario = 0m, Nombre = "" } }
                );

                if (productosSeleccionados == null || productosSeleccionados.Length == 0)
                {
                    MostrarMensaje("No se seleccionaron productos", "warning");
                    return;
                }

                // Calcular el total
                decimal total = 0;
                foreach (var producto in productosSeleccionados)
                {
                    total += producto.Cantidad * producto.PrecioUnitario;
                }

                int pedidoId;

                // Obtener ubicación del HiddenField (fuente de verdad) en lugar de ViewState
                string ubicacion = !string.IsNullOrEmpty(HdnTabActivo.Value) ? HdnTabActivo.Value : "salon";

                bool esMostrador = ViewState["EsMostrador"] != null && (bool)ViewState["EsMostrador"];

                // Si el ViewState no tiene la ubicación, usarla del HiddenField
                if (ViewState["UbicacionSeleccionada"] == null || string.IsNullOrEmpty(ViewState["UbicacionSeleccionada"].ToString()))
                {
                    ViewState["UbicacionSeleccionada"] = ubicacion;
                }
                else
                {
                    ubicacion = ViewState["UbicacionSeleccionada"].ToString();
                }

                string numeroMesa = ViewState["NumeroMesaSeleccionada"]?.ToString() ?? "Mostrador";

                // Verificar si es una actualización de pedido existente (agregar más productos)
                if (!string.IsNullOrEmpty(HdnPedidoIdActual.Value))
                {
                    // Es una actualización - agregar productos al pedido existente
                    pedidoId = int.Parse(HdnPedidoIdActual.Value);

                    // Obtener el pedido actual para sumar al total existente
                    Pedido pedidoActual = pedidoService.ObtenerPedidoPorId(pedidoId);
                    decimal totalAnterior = pedidoActual.Total;

                    // Agregar los nuevos detalles del pedido
                    foreach (var producto in productosSeleccionados)
                    {
                        DetallePedido detalle = new DetallePedido
                        {
                            PedidoId = pedidoId,
                            ProductoId = producto.ProductoId,
                            Cantidad = producto.Cantidad,
                            PrecioUnitario = producto.PrecioUnitario,
                            Subtotal = producto.Cantidad * producto.PrecioUnitario
                        };
                        pedidoService.AgregarDetallePedido(detalle);
                    }

                    // Actualizar el total del pedido sumando el nuevo total al anterior
                    decimal totalNuevo = totalAnterior + total;
                    pedidoService.ActualizarTotalPedido(pedidoId, totalNuevo);
                }
                else
                {
                    // Es un pedido nuevo
                    // Obtener asignación de mesa (si no es mostrador)
                    int asignacionId = 0;

                    if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                    {
                        // PRIMERO: Intentar usar el AsignacionId que fue guardado al abrir la mesa
                        if (ViewState["AsignacionIdActual"] != null)
                        {
                            asignacionId = (int)ViewState["AsignacionIdActual"];
                            System.Diagnostics.Debug.WriteLine($"✓ Usando AsignacionId del ViewState: {asignacionId}");
                        }
                        else
                        {
                            // SEGUNDO: Si no está en ViewState, buscar en la BD
                            int mesaId = (int)ViewState["MesaIdSeleccionada"];
                            AsignacionMesa asignacionExistente = asignacionService.ObtenerAsignacionPorMesa(mesaId);

                            if (asignacionExistente != null)
                            {
                                asignacionId = asignacionExistente.AsignacionId;
                                System.Diagnostics.Debug.WriteLine($"✓ Asignación encontrada en BD: {asignacionId}");
                            }
                            else
                            {
                                // TERCERO: Si no existe, crear nueva asignación
                                int meseroId = 1; // Por defecto
                                if (ViewState["MeseroIdSeleccionado"] != null)
                                {
                                    meseroId = (int)ViewState["MeseroIdSeleccionado"];
                                }

                                AsignacionMesa nuevaAsignacion = new AsignacionMesa
                                {
                                    MesaId = mesaId,
                                    MeseroId = meseroId,
                                    FechaAsignacion = DateTime.Now,
                                    Activa = true
                                };

                                asignacionId = asignacionService.CrearAsignacion(nuevaAsignacion);
                                System.Diagnostics.Debug.WriteLine($"✓ Nueva asignación creada: {asignacionId}");
                            }
                        }
                    }

                    // Crear el pedido
                    Pedido nuevoPedido = new Pedido
                    {
                        FechaPedido = DateTime.Now,
                        EstadoPedido = true,
                        Total = total,
                        AsignacionId = asignacionId > 0 ? asignacionId : 0,
                        EsMostrador = esMostrador
                    };

                    pedidoId = pedidoService.CrearPedido(nuevoPedido);

                    // Agregar los detalles del pedido
                    foreach (var producto in productosSeleccionados)
                    {
                        DetallePedido detalle = new DetallePedido
                        {
                            PedidoId = pedidoId,
                            ProductoId = producto.ProductoId,
                            Cantidad = producto.Cantidad,
                            PrecioUnitario = producto.PrecioUnitario,
                            Subtotal = producto.Cantidad * producto.PrecioUnitario
                        };
                        pedidoService.AgregarDetallePedido(detalle);
                    }

                    // Si NO es mostrador, actualizar estado de la mesa a ocupada
                    if (!esMostrador && ViewState["MesaIdSeleccionada"] != null)
                    {
                        int mesaId = (int)ViewState["MesaIdSeleccionada"];
                        mesaService.ActualizarEstadoMesa(mesaId, "ocupada");
                    }
                }

                // Guardar el pedidoId para el modal de resumen
                HdnPedidoIdActual.Value = pedidoId.ToString();

                // Limpiar el HiddenField de productos
                HdnProductosOrden.Value = string.Empty;

                // Recargar las órdenes de mostrador si es una orden de mostrador
                if (esMostrador)
                {
                    CargarOrdenesActivas();
                }

                // Guardar tab activo
                HdnTabActivo.Value = ubicacion;

                // Mostrar el modal de resumen usando el método del servidor
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

        protected void AgregarMasProductos_Click(object sender, EventArgs e)
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
                else if (pedido.AsignacionId > 0)
                {
                    // Es una mesa
                    AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorId(pedido.AsignacionId);
                    if (asignacion != null)
                    {
                        Mesa mesa = mesaService.ObtenerMesaPorId(asignacion.MesaId);
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

                // Generar JavaScript para abrir modal
                // IMPORTANTE: Mostrar productos existentes en el RESUMEN DE LA ORDEN
                System.Text.StringBuilder scriptProductos = new System.Text.StringBuilder();
                scriptProductos.Append("setTimeout(function() {");
                scriptProductos.Append("restaurarTab();");

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
                    jsonProductosExistentes.AppendFormat(@"{{""nombre"":""{0}"",""cantidad"":{1},""precio"":{2},""subtotal"":{3}}}",
                        detalle.NombreProducto.Replace("\"", "\\\""),
                        detalle.Cantidad,
                        detalle.PrecioUnitario,
                        detalle.Subtotal
                    );
                    primero = false;
                }

                jsonProductosExistentes.Append("]");

                // Establecer el HTML del resumen directamente (SIN llamar a actualizarResumenOrden)
                // porque esa funcion solo lee los inputs que estan en 0
                scriptProductos.AppendFormat(@"
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
                        totalOrden.textContent = '${3:N0}';
                    }}

                    // Establecer el numero de mesa en el modal
                    document.getElementById('modal-orden-mesa-numero').textContent = '{4}';

                    // Abrir el modal
                    var modal = new bootstrap.Modal(document.getElementById('modalOrden'));
                    modal.show();
                ", jsonProductosExistentes.ToString(), totalExistente, htmlResumen.ToString().Replace("`", "\\`"), totalExistente, numeroMesa);

                scriptProductos.Append("}, 100);");

                ClientScript.RegisterStartupScript(this.GetType(), "AbrirModalConProductos", scriptProductos.ToString(), true);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al agregar mas productos: " + ex.Message, "danger");
            }
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