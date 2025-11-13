using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;
using dominio;

namespace Service
{
    public class ReporteService
    {

       private AccesoDatos datos;
        public ReporteService() { 

            datos = new AccesoDatos();
        }


        public List<MesaReporte> BuscarMesas(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin,string criterioOrdenMesas, string criterioBusquedaMesas)
        {


            try
            {

                List<MesaReporte> mesaReporte = new List<MesaReporte>();

            datos.SetearStoredProcedure("sp_ReporteMesas");
            datos.setearParametro("@Turno", turno);
            datos.setearParametro("@Cantidad", criterioOrdenMesas);
            datos.setearParametro("@FechaDesde", fechaInicio);
            datos.setearParametro("@FechaHasta", fechaFin);
            datos.setearParametro("@Ubicacion", ubicacion);
            datos.setearParametro("@OrdenPor", criterioBusquedaMesas);
            datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    MesaReporte mesa = new MesaReporte();

                    mesa.MesaId = (int)datos.Lector["mesaId"];
                    mesa.NumeroMesa = (string)datos.Lector["NumeroMesa"];
                    mesa.Ubicacion = (string)datos.Lector["Ubicacion"];
                    mesa.Facturacion = (decimal)datos.Lector["Facturacion"];
                    mesa.Ocupacion = (int)datos.Lector["Ocupacion"];

                    mesaReporte.Add(mesa);
                }

                return mesaReporte;
            }
            catch (Exception ex)
            {

                throw new Exception("Fallo la busqueda por mesas" + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
            

        }
    
        public List<MeseroReporte>BuscarMeseros(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin, string criterioOrdenMeseros, string criterioBusquedaMeseros)
        {

            try
            {

                List<MeseroReporte> mesaReporte = new List<MeseroReporte>();

                datos.SetearStoredProcedure("sp_ReporteMeseros");
                datos.setearParametro("@Turno", turno);
                datos.setearParametro("@Cantidad", criterioOrdenMeseros);
                datos.setearParametro("@FechaDesde", fechaInicio);
                datos.setearParametro("@FechaHasta", fechaFin);
                datos.setearParametro("@Ubicacion", ubicacion);
                datos.setearParametro("@OrdenPor", criterioBusquedaMeseros);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    MeseroReporte mesero = new MeseroReporte();

                    mesero.MeseroId = (int)datos.Lector["meseroId"];
                    mesero.NombreApellido = (string)datos.Lector["NombreApellido"];
                    mesero.Facturacion = (decimal)datos.Lector["Facturacion"];
                    mesero.MesasAtendidas = (int)datos.Lector["MesasAtendidas"];

                    mesaReporte.Add(mesero);
                }

                return mesaReporte;
            }
            catch (Exception ex)
            {

                throw new Exception("Fallo la busqueda por meseros" + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    
    
    public List<ProductoReporte> BuscarProductos(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin, int? cantidadProductos, string criterioOrdenProductos, string criterioBusquedaProducto, string categoriaProducto)
        {

            try
            {

                List<ProductoReporte> productoReporte = new List<ProductoReporte>();

                datos.SetearStoredProcedure("sp_ReporteProducto");
                datos.setearParametro("@Turno", turno);
                datos.setearParametro("@FechaDesde", fechaInicio);
                datos.setearParametro("@FechaHasta", fechaFin);
                datos.setearParametro("@Ubicacion", ubicacion);
                datos.setearParametro("@CantidadProductos", cantidadProductos);
                datos.setearParametro("@MasOMenos", criterioOrdenProductos);
                datos.setearParametro("@OrdenPor", criterioBusquedaProducto);
                datos.setearParametro("@CategoriaProducto", categoriaProducto);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ProductoReporte producto = new ProductoReporte();

                    producto.NombreProducto = (string)datos.Lector["Nombre"];
                    producto.Categoria = (string)datos.Lector["Categoria"];
                    producto.Facturacion = (decimal)datos.Lector["Facturacion"];
                    producto.CantidadVendida = (int)datos.Lector["CantidadVendida"];

                    productoReporte.Add(producto);
                }

                return productoReporte;
            }
            catch (Exception ex)
            {

                throw new Exception("Fallo la busqueda por productos" + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
 

