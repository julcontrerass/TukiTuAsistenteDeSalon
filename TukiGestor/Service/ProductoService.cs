using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using System.Collections.Generic;
using dominio;
using accesoDatos;

namespace Service
{
    public class ProductoService
    {
        public List<Producto> Listar()
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock FROM PRODUCTO WHERE Disponible = 1");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Producto prod = new Producto();
                    prod.ProductoId = (int)datos.Lector["ProductoId"];
                    prod.Nombre = (string)datos.Lector["Nombre"];
                    prod.Precio = (decimal)datos.Lector["Precio"];
                    prod.Disponible = (bool)datos.Lector["Disponible"];
                    prod.CategoriaId = (int)datos.Lector["CategoriaId"];
                    prod.Stock = (int)datos.Lector["Stock"];
                    lista.Add(prod);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar productos: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void Agregar(Producto nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("INSERT INTO PRODUCTO (Nombre, Precio, Disponible, CategoriaId, Stock) " +"VALUES (@Nombre, @Precio, @Disponible, @CategoriaId, @Stock)");
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@Precio", nuevo.Precio);
                datos.setearParametro("@Disponible", nuevo.Disponible);
                datos.setearParametro("@CategoriaId", nuevo.CategoriaId);
                datos.setearParametro("@Stock", nuevo.Stock);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar producto: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void Modificar(Producto producto)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("UPDATE PRODUCTO SET Nombre = @Nombre, Precio = @Precio, " +"CategoriaId = @CategoriaId, Stock = @Stock " +"WHERE ProductoId = @ProductoId");
                datos.setearParametro("@Nombre", producto.Nombre);
                datos.setearParametro("@Precio", producto.Precio);
                datos.setearParametro("@CategoriaId", producto.CategoriaId);
                datos.setearParametro("@Stock", producto.Stock);
                datos.setearParametro("@ProductoId", producto.ProductoId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar producto: " + ex.Message);
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
                datos.SetearConsulta("DELETE FROM PRODUCTO WHERE ProductoId = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar producto: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Producto> BuscarProductos(string textoBusqueda)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                if (string.IsNullOrWhiteSpace(textoBusqueda))
                {
                    return Listar();
                }

                // Buscar productos por nombre usando LIKE
                datos.SetearConsulta(@"SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock
                                      FROM PRODUCTO
                                      WHERE Disponible = 1
                                      AND Nombre LIKE @texto");

                datos.setearParametro("@texto", "%" + textoBusqueda + "%");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto prod = new Producto();
                    prod.ProductoId = (int)datos.Lector["ProductoId"];
                    prod.Nombre = (string)datos.Lector["Nombre"];
                    prod.Precio = (decimal)datos.Lector["Precio"];
                    prod.Disponible = (bool)datos.Lector["Disponible"];
                    prod.CategoriaId = (int)datos.Lector["CategoriaId"];
                    prod.Stock = (int)datos.Lector["Stock"];

                    lista.Add(prod);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al buscar productos: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

    }
}