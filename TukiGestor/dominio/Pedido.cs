using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Pedido
    {
        public int PedidoId { get; set; }
        public DateTime FechaPedido { get; set; }
        public DateTime FechaCierre { get; set; }
        public bool EstadoPedido { get; set; }
        public decimal Total { get; set; }
        public AsignacionMesa AsignacionMesa { get; set; }
        public bool EsMostrador { get; set; }
        public string DescripcionResumen { get; set; }

    }
}
