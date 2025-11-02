using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Mesa
    {
        public int MesaId { get; set; }
        public string NumeroMesa { get; set; }
        public string Ubicacion { get; set; } // 'salon' o 'patio'
        public string Estado { get; set; } // 'libre' o 'ocupada'
        public bool Activa { get; set; }
    }
}
