using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Service;

namespace TukiGestor
{
    public partial class WebForm1 : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void ddlRango_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void btnRangoDiario_Click(object sender, EventArgs e)
        {

        }

        protected void btnBuscarMesas_Click(object sender, EventArgs e)
        {
            ReporteService reporteService = new ReporteService();

            string turno = ddlTurno.SelectedValue ?? "Todos";
            string rangoFecha = ddlRango.SelectedValue;
            DateTime fechaInicio;
            DateTime fechaFin;

            switch (rangoFecha)
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
                    fechaInicio = DateTime.Parse(txtFechaDesde.Text);
                    fechaFin = DateTime.Parse(txtFechaHasta.Text);
                    if (fechaFin < fechaInicio)
                    {
                        throw new Exception("La fecha de inicio del rango no puede ser anterior a la fecha de fin.");
                    }
                    break;
                default:
                    fechaInicio = DateTime.Now;
                    fechaFin = DateTime.Now;
                    break;
            }

            string ubicacion = ddlUbicacion.SelectedValue ?? "Todos";
            string criterioOrdenMesas = ddlCriterioOrdenMesas.SelectedValue ?? "Mas";
            string criterioBusquedaMesas = ddlTipoBusqueda.SelectedValue ?? "Facturacion";

            if (string.IsNullOrEmpty(turno) ||                 
                string.IsNullOrEmpty(ubicacion) ||
                string.IsNullOrEmpty(criterioOrdenMesas) || 
                string.IsNullOrEmpty(criterioBusquedaMesas))
            {
                throw new Exception("Todos los criterios de busqueda deben ser completados");
            }


            reporteService.BuscarMesas(turno, ubicacion, fechaInicio, fechaFin, criterioOrdenMesas, criterioBusquedaMesas)
        }
    }
}