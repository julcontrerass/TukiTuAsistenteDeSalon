﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Gerente:Usuario
    {
        public int GerenteId { get; set; }
        public string NombreGerente { get; set; }
        public string ApellidoGerente { get; set; }
        public bool Activo { get; set; }
    }
}
