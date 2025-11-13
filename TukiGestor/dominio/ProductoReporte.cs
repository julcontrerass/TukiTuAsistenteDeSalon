using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class ProductoReporte
    {
        public string NombreProducto {get; set;}
        public string Categoria { get; set;}
        public decimal Facturacion { get; set;} 
        public int CantidadVendida {  get; set;}

    }
}
