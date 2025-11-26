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

        public List<VentaReporte> BuscarVentas(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin, string tipoPago)
        {
            try
            {
                List<VentaReporte> ventaReporte = new List<VentaReporte>();

                datos.SetearStoredProcedure("sp_ReporteVentas");
                datos.setearParametro("@Turno", turno);
                datos.setearParametro("@FechaDesde", fechaInicio);
                datos.setearParametro("@FechaHasta", fechaFin);
                datos.setearParametro("@Ubicacion", ubicacion);
                datos.setearParametro("@TipoPago", tipoPago);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    VentaReporte venta = new VentaReporte();

                    venta.VentaId = (int)datos.Lector["VentaId"];
                    venta.Fecha = (DateTime)datos.Lector["Fecha"];
                    venta.NumeroMesa = (string)datos.Lector["NumeroMesa"];
                    venta.Mesero = (string)datos.Lector["Mesero"];
                    venta.TipoPago = (string)datos.Lector["TipoPago"];
                    venta.MontoTotal = (decimal)datos.Lector["MontoTotal"];
                    venta.Turno = (string)datos.Lector["Turno"];

                    ventaReporte.Add(venta);
                }

                return ventaReporte;
            }
            catch (Exception ex)
            {
                throw new Exception("Fallo la busqueda por ventas: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public BalanceReporte ObtenerBalance(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                BalanceReporte balance = new BalanceReporte();

                datos.SetearStoredProcedure("sp_ReporteBalance");
                datos.setearParametro("@Turno", turno);
                datos.setearParametro("@FechaDesde", fechaInicio);
                datos.setearParametro("@FechaHasta", fechaFin);
                datos.setearParametro("@Ubicacion", ubicacion);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    balance.TotalVentas = (decimal)datos.Lector["TotalVentas"];
                    balance.CantidadVentas = (int)datos.Lector["CantidadVentas"];
                    balance.CantidadClientes = (int)datos.Lector["CantidadClientes"];
                    balance.TicketPromedio = (decimal)datos.Lector["TicketPromedio"];
                    balance.ProductosVendidos = (int)datos.Lector["ProductosVendidos"];
                }

                return balance;
            }
            catch (Exception ex)
            {
                throw new Exception("Fallo al obtener balance: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<VentaPorFormaPago> ObtenerVentasPorFormaPago(string turno, string ubicacion, DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                List<VentaPorFormaPago> ventas = new List<VentaPorFormaPago>();

                datos.SetearStoredProcedure("sp_ReporteVentasPorFormaPago");
                datos.setearParametro("@Turno", turno);
                datos.setearParametro("@FechaDesde", fechaInicio);
                datos.setearParametro("@FechaHasta", fechaFin);
                datos.setearParametro("@Ubicacion", ubicacion);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    VentaPorFormaPago venta = new VentaPorFormaPago();
                    venta.FormaPago = (string)datos.Lector["FormaPago"];
                    venta.Monto = (decimal)datos.Lector["Monto"];
                    venta.Cantidad = (int)datos.Lector["Cantidad"];
                    venta.Porcentaje = (decimal)datos.Lector["Porcentaje"];

                    ventas.Add(venta);
                }

                return ventas;
            }
            catch (Exception ex)
            {
                throw new Exception("Fallo al obtener ventas por forma de pago: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
 

