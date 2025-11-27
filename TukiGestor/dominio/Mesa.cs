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
        public string Ubicacion { get; set; }
        public string Estado { get; set; }
        public int PosicionX { get; set; } 
        public int PosicionY { get; set; } 
        public bool Activo { get; set; } 
    }
}
