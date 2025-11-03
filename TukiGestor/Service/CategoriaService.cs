using accesoDatos;
using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;

namespace Service
{
    public class CategoriaService
    {
        public List<Categoria> Listar()
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT CategoriaId, Nombre, Activa FROM CATEGORIA WHERE Activa = 1");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Categoria cat = new Categoria();
                    cat.CategoriaId = (int)datos.Lector["CategoriaId"];
                    cat.Nombre = (string)datos.Lector["Nombre"];
                    cat.Activa = (bool)datos.Lector["Activa"];
                    lista.Add(cat);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar categorías: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}