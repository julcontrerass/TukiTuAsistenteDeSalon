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
       // public string NombreMesa { get; set; }
        //public int NumeroMesa { get; set; }
        public int Capacidad { get; set; }
        public string Ubicacion { get; set; }
        public string Estado { get; set; }
        public bool Activa { get; set; }
    }
}
