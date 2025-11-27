using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using Service;

namespace TukiGestor
{
    public partial class WebForm1 : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
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
            btnTabVentas.Visible = false;
            btnTabBalance.Visible = false;
            }

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
        }

        protected void btnTabMeseros_Click(object sender, EventArgs e)
        {
            MostrarTab("meseros");
            ocultarTablas();
            OcultarMensaje();

        }

        protected void btnTabProductos_Click(object sender, EventArgs e)
        {
            MostrarTab("productos");
            ocultarTablas();

            OcultarMensaje();
        }

        protected void btnTabVentas_Click(object sender, EventArgs e)
        {
            MostrarTab("ventas");
            ocultarTablas();
            OcultarMensaje();

        }

        protected void btnTabBalance_Click(object sender, EventArgs e)
        {
            MostrarTab("balance");
            ocultarTablas();
            OcultarMensaje();

        }


        protected void ocultarTablas()
        {
            pnlResultadoMesas.Visible = false;
            PnlResultadoMeseros.Visible = false;
            pnlResultadosProductos.Visible = false;
            gvMesas.DataSource = null;
            gvMeseros.DataSource = null;
            gvProductos.DataSource = null;
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

        
    }
}