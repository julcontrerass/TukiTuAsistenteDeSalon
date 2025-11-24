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