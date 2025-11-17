using accesoDatos;
using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public void Agregar(Categoria nueva)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("INSERT INTO CATEGORIA (Nombre, Activa) VALUES (@Nombre, @Activa)");
                datos.setearParametro("@Nombre", nueva.Nombre);
                datos.setearParametro("@Activa", nueva.Activa);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar categoría: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public bool ExisteNombreCategoria(string nombre)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM CATEGORIA WHERE Nombre = @Nombre AND Activa = 1");
                datos.setearParametro("@Nombre", nombre);
                int cantidad = Convert.ToInt32(datos.ejecutarScalar());
                return cantidad > 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al verificar existencia de la categoría: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }



        public void Modificar(Categoria categoria)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("UPDATE CATEGORIA SET Nombre = @Nombre WHERE CategoriaId = @CategoriaId");
                datos.setearParametro("@Nombre", categoria.Nombre);
                datos.setearParametro("@CategoriaId", categoria.CategoriaId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar categoría: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void Eliminar(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Siempre hacer baja lógica
                datos.SetearConsulta("UPDATE CATEGORIA SET Activa = 0 WHERE CategoriaId = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar categoría: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Categoria> ListarEliminadas()
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT CategoriaId, Nombre, Activa FROM CATEGORIA WHERE Activa = 0");
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
                throw new Exception("Error al listar categorías eliminadas: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void Reactivar(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("UPDATE CATEGORIA SET Activa = 1 WHERE CategoriaId = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al reactivar categoría: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public bool ExisteNombreCategoria(string nombre, int idExcluir)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM CATEGORIA WHERE Nombre = @Nombre AND CategoriaId <> @idExcluir AND Activa = 1");
                datos.setearParametro("@Nombre", nombre);
                datos.setearParametro("@idExcluir", idExcluir);
                int cantidad = Convert.ToInt32(datos.ejecutarScalar());
                return cantidad > 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al verificar existencia de la categoría: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}