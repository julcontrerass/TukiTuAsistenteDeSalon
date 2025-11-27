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
                    prod.Categoria = new Categoria { CategoriaId = (int)datos.Lector["CategoriaId"] };
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
                datos.setearParametro("@CategoriaId", nuevo.Categoria.CategoriaId);
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

        public bool ExisteNombre(string nombre)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM PRODUCTO WHERE Nombre = @Nombre AND Disponible = 1");
                datos.setearParametro("@Nombre", nombre);
                int cantidad = Convert.ToInt32(datos.ejecutarScalar());
                return cantidad > 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al verificar existencia del producto: " + ex.Message);
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
                datos.setearParametro("@CategoriaId", producto.Categoria.CategoriaId);
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
                datos.SetearConsulta("UPDATE PRODUCTO SET Disponible = 0 WHERE ProductoId = @id");
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
        public List<Producto> ListarEliminados()
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock FROM PRODUCTO WHERE Disponible = 0");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Producto prod = new Producto();
                    prod.ProductoId = (int)datos.Lector["ProductoId"];
                    prod.Nombre = (string)datos.Lector["Nombre"];
                    prod.Precio = (decimal)datos.Lector["Precio"];
                    prod.Disponible = (bool)datos.Lector["Disponible"];
                    prod.Categoria = new Categoria { CategoriaId = (int)datos.Lector["CategoriaId"] };
                    prod.Stock = (int)datos.Lector["Stock"];
                    lista.Add(prod);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar productos eliminados: " + ex.Message);
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
                datos.SetearConsulta("UPDATE PRODUCTO SET Disponible = 1 WHERE ProductoId = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al reactivar producto: " + ex.Message);
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
                datos.SetearConsulta(@"SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock FROM PRODUCTO WHERE Disponible = 1 AND Nombre LIKE @texto");
                datos.setearParametro("@texto", "%" + textoBusqueda + "%");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto prod = new Producto();
                    prod.ProductoId = (int)datos.Lector["ProductoId"];
                    prod.Nombre = (string)datos.Lector["Nombre"];
                    prod.Precio = (decimal)datos.Lector["Precio"];
                    prod.Disponible = (bool)datos.Lector["Disponible"];
                    prod.Categoria = new Categoria { CategoriaId = (int)datos.Lector["CategoriaId"] };
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

        public bool ExisteNombre(string nombre, int idExcluir)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM PRODUCTO WHERE Nombre = @Nombre AND ProductoId <> @idExcluir AND Disponible = 1");
                datos.setearParametro("@Nombre", nombre);
                datos.setearParametro("@idExcluir", idExcluir);
                int cantidad = Convert.ToInt32(datos.ejecutarScalar());
                return cantidad > 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al verificar existencia del producto: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public void DescontarStock(int productoId, int cantidad)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("UPDATE PRODUCTO SET Stock = Stock - @cantidad WHERE ProductoId = @id");
                datos.setearParametro("@cantidad", cantidad);
                datos.setearParametro("@id", productoId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al descontar stock: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public int ObtenerStock(int productoId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT Stock FROM PRODUCTO WHERE ProductoId = @id");
                datos.setearParametro("@id", productoId);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                    return (int)datos.Lector["Stock"];

                return 0;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener stock: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }



        public List<Producto> BuscarYFiltrar(string textoBusqueda, string ordenamiento)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock FROM PRODUCTO WHERE Disponible = 1";
                if (!string.IsNullOrWhiteSpace(textoBusqueda))
                {
                    consulta += " AND Nombre LIKE @texto";
                }
                switch (ordenamiento)
                {
                    case "reciente":
                        consulta += " ORDER BY ProductoId DESC";
                        break;
                    case "nombre_asc":
                        consulta += " ORDER BY Nombre ASC";
                        break;
                    case "nombre_desc":
                        consulta += " ORDER BY Nombre DESC";
                        break;
                    case "precio_asc":
                        consulta += " ORDER BY Precio ASC";
                        break;
                    case "precio_desc":
                        consulta += " ORDER BY Precio DESC";
                        break;
                    case "stock_asc":
                        consulta += " ORDER BY Stock ASC";
                        break;
                    case "stock_desc":
                        consulta += " ORDER BY Stock DESC";
                        break;
                    default:
                        consulta += " ORDER BY Nombre ASC";
                        break;
                }
                datos.SetearConsulta(consulta);
                if (!string.IsNullOrWhiteSpace(textoBusqueda))
                {
                    datos.setearParametro("@texto", "%" + textoBusqueda + "%");
                }
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Producto prod = new Producto();
                    prod.ProductoId = (int)datos.Lector["ProductoId"];
                    prod.Nombre = (string)datos.Lector["Nombre"];
                    prod.Precio = (decimal)datos.Lector["Precio"];
                    prod.Disponible = (bool)datos.Lector["Disponible"];
                    prod.Categoria = new Categoria { CategoriaId = (int)datos.Lector["CategoriaId"] };
                    prod.Stock = (int)datos.Lector["Stock"];
                    lista.Add(prod);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al buscar y filtrar productos: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Producto> ListarStockBajo(int limite)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock " + "FROM PRODUCTO " + "WHERE Disponible = 1 AND Stock <= @limite");
                datos.setearParametro("@limite", limite);
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Producto p = new Producto();
                    p.ProductoId = (int)datos.Lector["ProductoId"];
                    p.Nombre = (string)datos.Lector["Nombre"];
                    p.Precio = (decimal)datos.Lector["Precio"];
                    p.Disponible = (bool)datos.Lector["Disponible"];
                    p.Categoria = new Categoria { CategoriaId = (int)datos.Lector["CategoriaId"] };
                    p.Stock = (int)datos.Lector["Stock"];
                    lista.Add(p);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar productos con stock bajo: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public List<Producto> BuscarYFiltrar(string textoBusqueda, string ordenamiento, int categoriaId = 0)
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"SELECT ProductoId, Nombre, Precio, Disponible, CategoriaId, Stock  FROM PRODUCTO  WHERE Disponible = 1";
                // Filtro por búsqueda de texto
                if (!string.IsNullOrWhiteSpace(textoBusqueda))
                {
                    consulta += " AND Nombre LIKE @texto";
                }
                // Filtro por categoría
                if (categoriaId > 0)
                {
                    consulta += " AND CategoriaId = @categoriaId";
                }
                switch (ordenamiento)
                {
                    case "reciente":
                        consulta += " ORDER BY ProductoId DESC";
                        break;
                    case "nombre_asc":
                        consulta += " ORDER BY Nombre ASC";
                        break;
                    case "nombre_desc":
                        consulta += " ORDER BY Nombre DESC";
                        break;
                    case "precio_asc":
                        consulta += " ORDER BY Precio ASC";
                        break;
                    case "precio_desc":
                        consulta += " ORDER BY Precio DESC";
                        break;
                    case "stock_asc":
                        consulta += " ORDER BY Stock ASC";
                        break;
                    case "stock_desc":
                        consulta += " ORDER BY Stock DESC";
                        break;
                    default:
                        consulta += " ORDER BY Nombre ASC";
                        break;
                }
                datos.SetearConsulta(consulta);
                if (!string.IsNullOrWhiteSpace(textoBusqueda))
                {
                    datos.setearParametro("@texto", "%" + textoBusqueda + "%");
                }
                if (categoriaId > 0)
                {
                    datos.setearParametro("@categoriaId", categoriaId);
                }
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Producto prod = new Producto();
                    prod.ProductoId = (int)datos.Lector["ProductoId"];
                    prod.Nombre = (string)datos.Lector["Nombre"];
                    prod.Precio = (decimal)datos.Lector["Precio"];
                    prod.Disponible = (bool)datos.Lector["Disponible"];
                    prod.Categoria = new Categoria { CategoriaId = (int)datos.Lector["CategoriaId"] };
                    prod.Stock = (int)datos.Lector["Stock"];
                    lista.Add(prod);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al buscar y filtrar productos: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

    }
}