using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using Service;
using Newtonsoft.Json;

namespace TukiGestor
{
    public partial class WebForm1 : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {

        }
                             

        protected void btnBuscarMesas_Click(object sender, EventArgs e)
        {
      
            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = ddlTurno.SelectedValue ?? "Todos";
                string rangoFecha = ddlRango.SelectedValue;

                (DateTime fechaInicio, DateTime fechaFin) = obtenerRango(rangoFecha);

                string ubicacion = ddlUbicacionMesas.SelectedValue ?? "Todos";
                string criterioOrdenMesas = ddlCriterioOrdenMesas.SelectedValue ?? "Mas";
                string criterioBusquedaMesas = ddlTipoBusqueda.SelectedValue ?? "Facturacion";

                if (string.IsNullOrEmpty(turno) ||
                    string.IsNullOrEmpty(ubicacion) ||
                    string.IsNullOrEmpty(criterioOrdenMesas) ||
                    string.IsNullOrEmpty(criterioBusquedaMesas))
                {
                    throw new Exception("Todos los criterios de busqueda deben ser completados");
                }



                List<MesaReporte> mesaReporte = reporteService.BuscarMesas(turno, ubicacion, fechaInicio, fechaFin, criterioOrdenMesas, criterioBusquedaMesas);

                gvMesas.DataSource = mesaReporte;
                gvMesas.DataBind();
                pnlResultadoMesas.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }


        }


        private (DateTime, DateTime) obtenerRango(string rango)
        {

            DateTime fechaInicio;
            DateTime fechaFin;

            switch (rango)
            {
                case "Hoy":
                    fechaInicio = DateTime.Now;
                    fechaFin = DateTime.Now;
                    break;
                case "Semana":
                    int diaActual = (int)DateTime.Today.DayOfWeek;
                    if (diaActual == 0) diaActual = 7;
                    fechaInicio = DateTime.Today.AddDays((diaActual - 1) * -1);
                    fechaFin = DateTime.Now;
                    break;
                case "Mes":
                    DateTime hoy = DateTime.Now;
                    fechaInicio = new DateTime(hoy.Year, hoy.Month, 1);
                    fechaFin = hoy;
                    break;
                case "Año":
                    fechaInicio = new DateTime(DateTime.Now.Year, 1, 1);
                    fechaFin = DateTime.Now;
                    break;
                case "Personalizado":

                    if (String.IsNullOrEmpty(txtFechaDesde.Text) || String.IsNullOrEmpty(txtFechaHasta.Text))
                    {
                        throw new Exception("Se deben seleccionar fechas para realizar la búsqueda");
                    }
                    fechaInicio = DateTime.Parse(txtFechaDesde.Text);
                    fechaFin = DateTime.Parse(txtFechaHasta.Text);

                    if (fechaFin < fechaInicio)
                    {
                        throw new Exception("La fecha de inicio del rango no puede ser anterior a la fecha de fin.");
                    }
                    break;
                default:
                    throw new Exception("Debés seleccionar fechas válidas para filtrar");

            }


            return (fechaInicio, fechaFin);
        }
        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.Style["display"] = "block";
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
            pnlMensaje.Style["display"] = "none";
        }


        protected void btnMeserosBuscar_Click(object sender, EventArgs e)
        {
            PnlResultadoMeseros.Visible = false;
            gvMeseros.DataSource = null;
            OcultarMensaje();


            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = ddlTurno.SelectedValue ?? "Todos";
                string rangoFecha = ddlRango.SelectedValue;

                (DateTime fechaInicio, DateTime fechaFin) = obtenerRango(rangoFecha);

                string ubicacion = ddlUbicacionMeseros.SelectedValue ?? "Todos";
                string criterioOrdenMeseros = ddlCriterioOrdenMeseros.SelectedValue ?? "Mas";
                string criterioBusquedaMeseros = ddlCriterioBusquedaMeseros.SelectedValue ?? "Facturacion";

                if (string.IsNullOrEmpty(turno) ||
                    string.IsNullOrEmpty(ubicacion) ||
                    string.IsNullOrEmpty(criterioOrdenMeseros) ||
                    string.IsNullOrEmpty(criterioBusquedaMeseros))
                {
                    throw new Exception("Todos los criterios de busqueda deben ser completados");
                }



                List<MeseroReporte> meserosReporte = reporteService.BuscarMeseros(turno, ubicacion, fechaInicio, fechaFin, criterioOrdenMeseros, criterioBusquedaMeseros);

                gvMeseros.DataSource = meserosReporte;
                gvMeseros.DataBind();
                PnlResultadoMeseros.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        protected void btnTabMesas_Click(object sender, EventArgs e)
        {
            MostrarTab("mesas");
            ocultarTablas();
            OcultarMensaje();
            LimpiarFiltrosMesas();
            CargarMesasIniciales();
        }

        protected void btnTabMeseros_Click(object sender, EventArgs e)
        {
            MostrarTab("meseros");
            ocultarTablas();
            OcultarMensaje();
            LimpiarFiltrosMeseros();
            CargarMeserosIniciales();
        }

        protected void btnTabProductos_Click(object sender, EventArgs e)
        {
            MostrarTab("productos");
            ocultarTablas();
            OcultarMensaje();
            LimpiarFiltrosProductos();
            CargarProductosIniciales();
        }

        protected void btnTabVentas_Click(object sender, EventArgs e)
        {
            MostrarTab("ventas");
            ocultarTablas();
            OcultarMensaje();
            LimpiarFiltrosVentas();
            CargarVentasIniciales();
        }

        protected void btnTabBalance_Click(object sender, EventArgs e)
        {
            MostrarTab("balance");
            ocultarTablas();
            OcultarMensaje();
            CargarBalanceInicial();
        }


        protected void ocultarTablas()
        {
            pnlResultadoMesas.Visible = false;
            PnlResultadoMeseros.Visible = false;
            pnlResultadosProductos.Visible = false;
            pnlResultadosVentas.Visible = false;
            gvMesas.DataSource = null;
            gvMeseros.DataSource = null;
            gvProductos.DataSource = null;
            gvVentas.DataSource = null;
        }
        private void MostrarTab(string tab)
        {
            // ocultamos todos los paneles
            pnlMesas.CssClass = "tab-pane fade";
            pnlMeseros.CssClass = "tab-pane fade";
            pnlProductos.CssClass = "tab-pane fade";
            pnlVentas.CssClass = "tab-pane fade";
            pnlBalance.CssClass = "tab-pane fade";

            // reseteamos las clases de los botones
            btnTabMesas.CssClass = "nav-link";
            btnTabMeseros.CssClass = "nav-link";
            btnTabProductos.CssClass = "nav-link";
            btnTabVentas.CssClass = "nav-link";
            btnTabBalance.CssClass = "nav-link";


            // mostramos el panel correspondiente
            switch (tab)
            {
                case "mesas":
                    pnlMesas.CssClass = "tab-pane fade active show";
                    btnTabMesas.CssClass = "nav-link active";
                    break;
                case "meseros":
                    pnlMeseros.CssClass = "tab-pane fade active show";
                    btnTabMeseros.CssClass = "nav-link active";
                    break;
                case "productos":
                    pnlProductos.CssClass = "tab-pane fade active show";
                    btnTabProductos.CssClass= "nav-link active";
                    break;
                case "ventas":
                    pnlVentas.CssClass = "tab-pane fade active show";
                    btnTabVentas.CssClass = "nav-link active";
                    break;
                case "balance":
                    pnlBalance.CssClass = "tab-pane fade active show";
                   btnTabBalance.CssClass = "nav-link active";
                    break;
                
            }

           // UpdatePanelContenido.Update();
        }

        protected void btnBuscarProductos_Click(object sender, EventArgs e)
        {

            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = ddlTurno.SelectedValue ?? "Todos";
                string rangoFecha = ddlRango.SelectedValue;

                (DateTime fechaInicio, DateTime fechaFin) = obtenerRango(rangoFecha);

                string ubicacion = ddlUbicacionProductos.SelectedValue ?? "Todos";
                int? cantidadProductos = int.Parse(ddlCantidadProductos.SelectedValue);
                string criterioOrdenProductos = ddlCriterioOrdenProductos.SelectedValue ?? "Mas";
                string criterioBusquedaProductos = ddlCriterioBusquedaProductos.SelectedValue ?? "Facturacion";
                string categoriaProducto = ddlCategoriaProductos.SelectedValue ?? "Todos";

                if (string.IsNullOrEmpty(turno) ||
                    string.IsNullOrEmpty(ubicacion) ||
                    cantidadProductos == null ||
                    string.IsNullOrEmpty(criterioOrdenProductos) ||
                    string.IsNullOrEmpty(criterioBusquedaProductos) ||
                    string.IsNullOrEmpty(categoriaProducto))
                {
                    throw new Exception("Todos los criterios de bùsqueda deben ser completados");
                }



                List<ProductoReporte> productoReporte = reporteService.BuscarProductos(turno, ubicacion, fechaInicio, fechaFin, cantidadProductos, criterioOrdenProductos, criterioBusquedaProductos, categoriaProducto);

                gvProductos.DataSource = productoReporte;
                gvProductos.DataBind();
                pnlResultadosProductos.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }

        }

        protected void btnBuscarVentas_Click(object sender, EventArgs e)
        {
            pnlResultadosVentas.Visible = false;
            gvVentas.DataSource = null;
            OcultarMensaje();

            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = ddlTurno.SelectedValue ?? "Todos";
                string rangoFecha = ddlRango.SelectedValue;

                (DateTime fechaInicio, DateTime fechaFin) = obtenerRango(rangoFecha);

                // Si el valor está vacío (disabled item seleccionado), usar "Todos"
                string ubicacion = string.IsNullOrEmpty(ddlUbicacionVentas.SelectedValue) ? "Todos" : ddlUbicacionVentas.SelectedValue;
                string tipoPago = string.IsNullOrEmpty(ddlTipoPagoVentas.SelectedValue) ? "Todos" : ddlTipoPagoVentas.SelectedValue;

                List<VentaReporte> ventaReporte = reporteService.BuscarVentas(turno, ubicacion, fechaInicio, fechaFin, tipoPago);

                gvVentas.DataSource = ventaReporte;
                gvVentas.DataBind();
                pnlResultadosVentas.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        protected void gvVentas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalle")
            {
                try
                {
                    int ventaId = Convert.ToInt32(e.CommandArgument);

                    // Obtener información de la venta
                    VentaService ventaService = new VentaService();
                    Venta venta = ventaService.ObtenerVentaPorId(ventaId);

                    if (venta == null)
                    {
                        MostrarMensaje("No se encontró la venta", "error");
                        return;
                    }

                    // Obtener información del pedido
                    PedidoService pedidoService = new PedidoService();
                    Pedido pedido = pedidoService.ObtenerPedidoPorId(venta.Pedido.PedidoId);

                    // Obtener detalles del pedido (productos)
                    List<DetallePedido> detalles = pedidoService.ObtenerDetallesPedido(venta.Pedido.PedidoId);

                    // Determinar ubicación y mesero
                    string ubicacion = "Mostrador";
                    string mesero = "N/A";
                    bool mostrarMesero = false;

                    if (!pedido.EsMostrador && pedido.AsignacionMesa != null)
                    {
                        AsignacionMesaService asignacionService = new AsignacionMesaService();
                        AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorId(pedido.AsignacionMesa.AsignacionId);

                        if (asignacion != null)
                        {
                            MesaService mesaService = new MesaService();
                            Mesa mesa = mesaService.ObtenerMesaPorId(asignacion.Mesa.MesaId);
                            ubicacion = mesa.Ubicacion + " - Mesa " + mesa.NumeroMesa;

                            MeseroService meseroService = new MeseroService();
                            Mesero meseroObj = meseroService.ObtenerPorId(asignacion.Mesero.MeseroId);
                            mesero = meseroObj.Nombre + " " + meseroObj.Apellido;
                            mostrarMesero = true;
                        }
                    }

                    // Generar HTML para productos
                    System.Text.StringBuilder htmlProductos = new System.Text.StringBuilder();
                    foreach (var detalle in detalles)
                    {
                        decimal subtotal = detalle.Cantidad * detalle.PrecioUnitario;
                        htmlProductos.AppendFormat(@"
                            <div style='padding: 10px; border-bottom: 1px solid #E7D9C2; display: flex; justify-content: space-between; align-items: center;'>
                                <div>
                                    <div style='font-weight: 600; color: #333;'>{0}</div>
                                    <div style='font-size: 12px; color: #666;'>Cantidad: {1} x ${2:N0}</div>
                                </div>
                                <div style='font-weight: 700; color: #8B7355;'>${3:N0}</div>
                            </div>",
                            detalle.NombreProducto,
                            detalle.Cantidad,
                            detalle.PrecioUnitario,
                            subtotal
                        );
                    }

                    // Crear script para mostrar el modal
                    string script = $@"
                        setTimeout(function() {{
                            document.getElementById('modalVentaId').textContent = '{ventaId}';
                            document.getElementById('modalVentaFecha').textContent = '{venta.FechaVenta.ToString("dd/MM/yyyy HH:mm")}';
                            document.getElementById('modalVentaUbicacion').textContent = '{ubicacion}';
                            document.getElementById('modalVentaTipoPago').textContent = '{venta.MetodoPago}';
                            document.getElementById('modalVentaTotal').textContent = '${venta.MontoTotal:N0}';
                            document.getElementById('modalVentaProductos').innerHTML = `{htmlProductos.ToString()}`;

                            var divMesero = document.getElementById('divVentaMesero');
                            if ({mostrarMesero.ToString().ToLower()}) {{
                                divMesero.style.display = 'block';
                                document.getElementById('modalVentaMesero').textContent = '{mesero}';
                            }} else {{
                                divMesero.style.display = 'none';
                            }}

                            var modal = new bootstrap.Modal(document.getElementById('modalDetalleVenta'));
                            modal.show();
                        }}, 100);
                    ";
                    ClientScript.RegisterStartupScript(this.GetType(), "MostrarDetalleVenta", script, true);
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al obtener detalle de venta: " + ex.Message, "error");
                }
            }
        }

        // Métodos para Mesas
        private void LimpiarFiltrosMesas()
        {
            // Establecer filtros globales a valores por defecto
            ddlTurno.SelectedValue = "Todos";
            ddlRango.SelectedValue = "Hoy";
            txtFechaDesde.Text = string.Empty;
            txtFechaHasta.Text = string.Empty;

            // Establecer filtros específicos de mesas
            ddlUbicacionMesas.SelectedValue = "Todos";
            ddlCriterioOrdenMesas.SelectedValue = "Mas";
            ddlTipoBusqueda.SelectedValue = "Facturacion";
        }

        private void CargarMesasIniciales()
        {
            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = "Todos";
                DateTime fechaInicio = DateTime.Now;
                DateTime fechaFin = DateTime.Now;
                string ubicacion = "Todos";
                string criterioOrdenMesas = "Mas";
                string criterioBusquedaMesas = "Facturacion";

                List<MesaReporte> mesaReporte = reporteService.BuscarMesas(turno, ubicacion, fechaInicio, fechaFin, criterioOrdenMesas, criterioBusquedaMesas);

                gvMesas.DataSource = mesaReporte;
                gvMesas.DataBind();
                pnlResultadoMesas.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        // Métodos para Meseros
        private void LimpiarFiltrosMeseros()
        {
            // Establecer filtros globales a valores por defecto
            ddlTurno.SelectedValue = "Todos";
            ddlRango.SelectedValue = "Hoy";
            txtFechaDesde.Text = string.Empty;
            txtFechaHasta.Text = string.Empty;

            // Establecer filtros específicos de meseros
            ddlUbicacionMeseros.SelectedValue = "Todos";
            ddlCriterioOrdenMeseros.SelectedValue = "Mas";
            ddlCriterioBusquedaMeseros.SelectedValue = "Facturacion";
        }

        private void CargarMeserosIniciales()
        {
            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = "Todos";
                DateTime fechaInicio = DateTime.Now;
                DateTime fechaFin = DateTime.Now;
                string ubicacion = "Todos";
                string criterioOrdenMeseros = "Mas";
                string criterioBusquedaMeseros = "Facturacion";

                List<MeseroReporte> meserosReporte = reporteService.BuscarMeseros(turno, ubicacion, fechaInicio, fechaFin, criterioOrdenMeseros, criterioBusquedaMeseros);

                gvMeseros.DataSource = meserosReporte;
                gvMeseros.DataBind();
                PnlResultadoMeseros.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        // Métodos para Productos
        private void LimpiarFiltrosProductos()
        {
            // Establecer filtros globales a valores por defecto
            ddlTurno.SelectedValue = "Todos";
            ddlRango.SelectedValue = "Hoy";
            txtFechaDesde.Text = string.Empty;
            txtFechaHasta.Text = string.Empty;

            // Establecer filtros específicos de productos
            ddlUbicacionProductos.SelectedValue = "Todos";
            ddlCantidadProductos.SelectedValue = "10";
            ddlCriterioOrdenProductos.SelectedValue = "Mas";
            ddlCriterioBusquedaProductos.SelectedValue = "Facturacion";
            ddlCategoriaProductos.SelectedValue = "Todos";
        }

        private void CargarProductosIniciales()
        {
            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = "Todos";
                DateTime fechaInicio = DateTime.Now;
                DateTime fechaFin = DateTime.Now;
                string ubicacion = "Todos";
                int? cantidadProductos = 10;
                string criterioOrdenProductos = "Mas";
                string criterioBusquedaProductos = "Facturacion";
                string categoriaProducto = "Todos";

                List<ProductoReporte> productoReporte = reporteService.BuscarProductos(turno, ubicacion, fechaInicio, fechaFin, cantidadProductos, criterioOrdenProductos, criterioBusquedaProductos, categoriaProducto);

                gvProductos.DataSource = productoReporte;
                gvProductos.DataBind();
                pnlResultadosProductos.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        // Métodos para Ventas
        private void LimpiarFiltrosVentas()
        {
            // Establecer filtros globales a valores por defecto
            ddlTurno.SelectedValue = "Todos";
            ddlRango.SelectedValue = "Hoy";
            txtFechaDesde.Text = string.Empty;
            txtFechaHasta.Text = string.Empty;

            // Establecer filtros específicos de ventas a "Todos"
            ddlUbicacionVentas.SelectedValue = "Todos";
            ddlTipoPagoVentas.SelectedValue = "Todos";
        }

        private void CargarVentasIniciales()
        {
            ReporteService reporteService = new ReporteService();

            try
            {
                // Cargar todas las ventas de hoy por defecto
                string turno = "Todos";
                DateTime fechaInicio = DateTime.Now;
                DateTime fechaFin = DateTime.Now;
                string ubicacion = "Todos";
                string tipoPago = "Todos";

                List<VentaReporte> ventaReporte = reporteService.BuscarVentas(turno, ubicacion, fechaInicio, fechaFin, tipoPago);

                gvVentas.DataSource = ventaReporte;
                gvVentas.DataBind();
                pnlResultadosVentas.Visible = true;
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        protected void btnBuscarBalance_Click(object sender, EventArgs e)
        {
            ReporteService reporteService = new ReporteService();

            try
            {
                string turno = ddlTurno.SelectedValue ?? "Todos";
                string rangoFecha = ddlRango.SelectedValue;

                (DateTime fechaInicio, DateTime fechaFin) = obtenerRango(rangoFecha);

                string ubicacion = "Todos"; // Balance muestra resumen general

                // Obtener datos del balance
                BalanceReporte balance = reporteService.ObtenerBalance(turno, ubicacion, fechaInicio, fechaFin);

                // Obtener datos de ventas por forma de pago
                List<VentaPorFormaPago> ventasPorFormaPago = reporteService.ObtenerVentasPorFormaPago(turno, ubicacion, fechaInicio, fechaFin);

                // Poblar las métricas principales
                lblTotalVentas.Text = balance.TotalVentas.ToString("C", new System.Globalization.CultureInfo("es-AR"));
                lblCantidadVentas.Text = balance.CantidadVentas.ToString();
                lblCantidadClientes.Text = balance.CantidadClientes.ToString();
                lblTicketPromedio.Text = balance.TicketPromedio.ToString("C", new System.Globalization.CultureInfo("es-AR"));
                lblProductosVendidos.Text = balance.ProductosVendidos.ToString();

                // Poblar el GridView con ventas por forma de pago
                gvFormaPago.DataSource = ventasPorFormaPago;
                gvFormaPago.DataBind();

                // Preparar datos para el gráfico
                if (ventasPorFormaPago != null && ventasPorFormaPago.Count > 0)
                {
                    var labels = new List<string>();
                    var datos = new List<decimal>();
                    var colores = new List<string>();

                    // Definir colores para cada forma de pago
                    var coloresPorFormaPago = new Dictionary<string, string>
                    {
                        { "Efectivo", "#28a745" },
                        { "Crédito", "#007bff" },
                        { "Débito", "#17a2b8" },
                        { "Transferencia", "#ffc107" },
                        { "MercadoPago", "#00b8d4" },
                        { "Otros", "#6c757d" }
                    };

                    foreach (var venta in ventasPorFormaPago)
                    {
                        labels.Add(venta.FormaPago);
                        datos.Add(venta.Monto);

                        // Asignar color según la forma de pago
                        if (coloresPorFormaPago.ContainsKey(venta.FormaPago))
                        {
                            colores.Add(coloresPorFormaPago[venta.FormaPago]);
                        }
                        else
                        {
                            colores.Add("#6c757d"); // Color por defecto
                        }
                    }

                    // Convertir a JSON para JavaScript
                    hfFormaPagoLabels.Value = JsonConvert.SerializeObject(labels);
                    hfFormaPagoData.Value = JsonConvert.SerializeObject(datos);
                    hfFormaPagoColors.Value = JsonConvert.SerializeObject(colores);
                }
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

        private void CargarBalanceInicial()
        {
            ReporteService reporteService = new ReporteService();

            try
            {
                // Cargar balance de hoy por defecto
                string turno = "Todos";
                DateTime fechaInicio = DateTime.Now;
                DateTime fechaFin = DateTime.Now;
                string ubicacion = "Todos";

                // Obtener datos del balance
                BalanceReporte balance = reporteService.ObtenerBalance(turno, ubicacion, fechaInicio, fechaFin);

                // Obtener datos de ventas por forma de pago
                List<VentaPorFormaPago> ventasPorFormaPago = reporteService.ObtenerVentasPorFormaPago(turno, ubicacion, fechaInicio, fechaFin);

                // Poblar las métricas principales
                lblTotalVentas.Text = balance.TotalVentas.ToString("C", new System.Globalization.CultureInfo("es-AR"));
                lblCantidadVentas.Text = balance.CantidadVentas.ToString();
                lblCantidadClientes.Text = balance.CantidadClientes.ToString();
                lblProductosVendidos.Text = balance.ProductosVendidos.ToString();

                // Poblar el GridView con ventas por forma de pago
                gvFormaPago.DataSource = ventasPorFormaPago;
                gvFormaPago.DataBind();

                // Preparar datos para el gráfico
                if (ventasPorFormaPago != null && ventasPorFormaPago.Count > 0)
                {
                    var labels = new List<string>();
                    var datos = new List<decimal>();
                    var colores = new List<string>();

                    // Definir colores para cada forma de pago
                    var coloresPorFormaPago = new Dictionary<string, string>
                    {
                        { "Efectivo", "#28a745" },
                        { "Crédito", "#007bff" },
                        { "Débito", "#17a2b8" },
                        { "Transferencia", "#ffc107" },
                        { "MercadoPago", "#00b8d4" },
                        { "Otros", "#6c757d" }
                    };

                    foreach (var venta in ventasPorFormaPago)
                    {
                        labels.Add(venta.FormaPago);
                        datos.Add(venta.Monto);

                        // Asignar color según la forma de pago
                        if (coloresPorFormaPago.ContainsKey(venta.FormaPago))
                        {
                            colores.Add(coloresPorFormaPago[venta.FormaPago]);
                        }
                        else
                        {
                            colores.Add("#6c757d"); // Color por defecto
                        }
                    }

                    // Convertir a JSON para JavaScript
                    hfFormaPagoLabels.Value = JsonConvert.SerializeObject(labels);
                    hfFormaPagoData.Value = JsonConvert.SerializeObject(datos);
                    hfFormaPagoColors.Value = JsonConvert.SerializeObject(colores);
                }
            }
            catch (Exception ex)
            {
                this.MostrarMensaje(ex.Message, "error");
            }
        }

    }
}