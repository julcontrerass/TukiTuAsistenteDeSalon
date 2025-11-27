using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class VentaReporte
    {
        public int VentaId { get; set; }
        public DateTime Fecha { get; set; }
        public string NumeroMesa { get; set; }
        public string Mesero { get; set; }
        public string TipoPago { get; set; }
        public decimal MontoTotal { get; set; }
        public string Turno { get; set; }
    }
}
