using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;

namespace Service
{
    public class ReporteService
    {

       private AccesoDatos datos;
        public ReporteService() { 

            datos = new AccesoDatos();
        }


        public void BuscarMesas(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin,string criterioOrdenMesas, string criterioBusquedaMesas)
        {

        }
    }
}
