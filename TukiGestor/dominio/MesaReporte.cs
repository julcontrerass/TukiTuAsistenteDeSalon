using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class MesaReporte
    {
        public int MesaId { get; set; }
        public string NumeroMesa { get; set; }
        public string Ubicacion { get; set; }
        public decimal Facturacion { get; set; }
        public int Ocupacion { get; set; }
    }
}
