﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Mesero:Usuario
    {
        public int MeseroId { get; set; }
        public string NombreMesero { get; set; }
        public string ApellidoMesero { get; set; }
        public bool Activo { get; set; }
    }
}
