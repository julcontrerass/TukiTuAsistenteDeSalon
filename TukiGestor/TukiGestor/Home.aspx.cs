using dominio;
using Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TukiGestor
{
    public partial class About : Page
    {
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
                CargarAlertasStockBajo();
                CargarOrdenesAbiertas();

            }
        }

        private void CargarOrdenesAbiertas()
        {
            PedidoService servicio = new PedidoService();
            AsignacionMesaService asignacionService = new AsignacionMesaService();
            MeseroService meseroService = new MeseroService();
            MesaService mesaService = new MesaService();

            List<Pedido> pedidos = servicio.ObtenerPedidosActivos();

            if (pedidos.Count > 0)
            {
                var pedidosConInfo = new List<object>();

                foreach (var p in pedidos)
                {
                    var detalles = servicio.ObtenerDetallesPedido(p.PedidoId);

                    string resumen = string.Join(", ",
                        detalles.Select(d => d.NombreProducto + " x" + d.Cantidad));

                    if (resumen.Length > 60)
                        resumen = resumen.Substring(0, 60) + "...";

                    string ubicacion = "N/A";
                    string mesero = "";
                    bool mostrarMesero = false;

                    if (p.EsMostrador)
                    {
                        ubicacion = "Mostrador";
                    }
                    else if (p.AsignacionMesa != null && p.AsignacionMesa.AsignacionId > 0)
                    {
                        AsignacionMesa asignacion = asignacionService.ObtenerAsignacionPorId(p.AsignacionMesa.AsignacionId);

                        if (asignacion != null)
                        {
                            if (asignacion.Mesa != null)
                            {
                                Mesa mesa = mesaService.ObtenerMesaPorId(asignacion.Mesa.MesaId);
                                if (mesa != null)
                                {
                                    ubicacion = (mesa.Ubicacion == "salon" ? "Salón" : "Patio") + " - Mesa " + mesa.NumeroMesa;
                                }
                            }

                            if (asignacion.Mesero != null)
                            {
                                Mesero meseroObj = meseroService.ObtenerPorId(asignacion.Mesero.MeseroId);
                                if (meseroObj != null)
                                {
                                    mesero = meseroObj.Nombre + " " + meseroObj.Apellido;
                                    mostrarMesero = true;
                                }
                            }
                        }
                    }

                    pedidosConInfo.Add(new {
                        PedidoId = p.PedidoId,
                        FechaPedido = p.FechaPedido,
                        Total = p.Total,
                        DescripcionResumen = resumen,
                        Ubicacion = ubicacion,
                        Mesero = mesero,
                        MostrarMesero = mostrarMesero
                    });
                }

                pnlOrdenesAbiertas.Visible = true;
                RepeaterOrdenes.DataSource = pedidosConInfo;
                RepeaterOrdenes.DataBind();
            }
            else
            {
                pnlOrdenesAbiertas.Visible = false;
            }
        }




        private void CargarAlertasStockBajo()
        {
            ProductoService service = new ProductoService();
            List<Producto> alertas = service.ListarStockBajo(20);
            if (alertas != null && alertas.Count > 0)
            {
                pnlStockBajo.Visible = true;
                RepeaterAlertas.DataSource = alertas;
                RepeaterAlertas.DataBind();
            }
            else
            {
                pnlStockBajo.Visible = false;
            }
        }

    }



}