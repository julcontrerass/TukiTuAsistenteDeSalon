using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Venta
    {
        public int VentaId { get; set; }
        public int PedidoId { get; set; }
        public DateTime FechaVenta { get; set; }
        public decimal MontoTotal { get; set; }
        public string MetodoPago { get; set; }
        public decimal? MontoRecibido { get; set; }
        public int? GerenteId { get; set; }
    }
}
