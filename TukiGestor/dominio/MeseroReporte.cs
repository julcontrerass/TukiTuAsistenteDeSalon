using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class MeseroReporte
    {
        public int MeseroId { get; set; }
        public string NombreApellido { get; set; }
        public string Ubicacion { get; set; }
        public decimal Facturacion { get; set; }
        public int MesasAtendidas { get; set; }

    }
}
