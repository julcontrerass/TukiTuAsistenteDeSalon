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
                CargarAlertasStockBajo();
                CargarOrdenesAbiertas();

            }
        }

        private void CargarOrdenesAbiertas()
        {
            PedidoService servicio = new PedidoService();
            List<Pedido> pedidos = servicio.ObtenerPedidosActivos();

            if (pedidos.Count > 0)
            {
                // Armar un pequeño resumen por pedido
                foreach (var p in pedidos)
                {
                    var detalles = servicio.ObtenerDetallesPedido(p.PedidoId);

                    string resumen = string.Join(", ",
                        detalles.Select(d => d.NombreProducto + " x" + d.Cantidad));

                    // Si es muy largo, lo recortamos
                    if (resumen.Length > 60)
                        resumen = resumen.Substring(0, 60) + "...";

                    p.DescripcionResumen = resumen; // propiedad extendida (la agregamos más abajo)
                }

                pnlOrdenesAbiertas.Visible = true;
                RepeaterOrdenes.DataSource = pedidos;
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
            // Límite de alerta <= 20
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