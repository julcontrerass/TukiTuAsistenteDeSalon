using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class AsignacionMesa
    {
        public int AsignacionId { get; set; }
        public int MesaId { get; set; }
        public int MeseroId { get; set; }
        public DateTime FechaAsignacion { get; set; }
        public bool Activa { get; set; }
    }
}
