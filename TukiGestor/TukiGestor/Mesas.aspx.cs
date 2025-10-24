using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TukiGestor
{
    public partial class Mesas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        // Clases para el manejo de datos de mesas
        public class Mesa
        {
            public int Numero { get; set; }
            public string Seccion { get; set; }
            public string Estado { get; set; }
            public int CantidadPersonas { get; set; }
            public string Camarero { get; set; }
            public DateTime FechaApertura { get; set; }
            public List<ProductoOrden> Orden { get; set; }

            public Mesa()
            {
                Orden = new List<ProductoOrden>();
            }
        }

        public class ProductoOrden
        {
            public string Nombre { get; set; }
            public int Cantidad { get; set; }
            public decimal Precio { get; set; }
            public decimal Subtotal => Cantidad * Precio;
        }

        // Métodos para persistencia de datos (se pueden implementar con base de datos)
        public static List<Mesa> ObtenerMesas()
        {
            // Por ahora retorna una lista vacía
            // En el futuro se puede conectar a una base de datos
            if (HttpContext.Current.Session["Mesas"] == null)
            {
                HttpContext.Current.Session["Mesas"] = new List<Mesa>();
            }
            return (List<Mesa>)HttpContext.Current.Session["Mesas"];
        }

        public static void GuardarMesa(Mesa mesa)
        {
            List<Mesa> mesas = ObtenerMesas();
            Mesa existente = mesas.FirstOrDefault(m => m.Seccion == mesa.Seccion && m.Numero == mesa.Numero);

            if (existente != null)
            {
                // Actualizar mesa existente
                existente.Estado = mesa.Estado;
                existente.CantidadPersonas = mesa.CantidadPersonas;
                existente.Camarero = mesa.Camarero;
                existente.FechaApertura = mesa.FechaApertura;
                existente.Orden = mesa.Orden;
            }
            else
            {
                // Agregar nueva mesa
                mesas.Add(mesa);
            }

            HttpContext.Current.Session["Mesas"] = mesas;
        }

        public static void EliminarMesa(string seccion, int numero)
        {
            List<Mesa> mesas = ObtenerMesas();
            Mesa mesa = mesas.FirstOrDefault(m => m.Seccion == seccion && m.Numero == numero);

            if (mesa != null)
            {
                mesas.Remove(mesa);
                HttpContext.Current.Session["Mesas"] = mesas;
            }
        }

        public static Mesa ObtenerMesa(string seccion, int numero)
        {
            List<Mesa> mesas = ObtenerMesas();
            return mesas.FirstOrDefault(m => m.Seccion == seccion && m.Numero == numero);
        }
    }
}