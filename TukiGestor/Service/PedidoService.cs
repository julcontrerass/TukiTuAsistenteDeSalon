using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;
using dominio;

namespace Service
{
    public class PedidoService
    {
        private AccesoDatos datos;

        public PedidoService()
        {
            datos = new AccesoDatos();
        }

        public int CrearPedido(Pedido pedido)
        {
            try
            {
                datos.SetearConsulta(@"INSERT INTO PEDIDO (FechaApertura, Estado, Total, AsignacionId, CantidadPersonas, EsMostrador) OUTPUT INSERTED.PedidoId  VALUES (@FechaApertura, @Estado, @Total, @AsignacionId, @CantidadPersonas, @EsMostrador)");
                datos.setearParametro("@FechaApertura", pedido.FechaPedido);
                datos.setearParametro("@Estado", pedido.EstadoPedido);
                datos.setearParametro("@Total", pedido.Total);
                datos.setearParametro("@AsignacionId", pedido.AsignacionMesa?.AsignacionId ?? (object)DBNull.Value);
                datos.setearParametro("@CantidadPersonas", 1);
                datos.setearParametro("@EsMostrador", pedido.EsMostrador);

                object resultado = datos.ejecutarScalar();
                return Convert.ToInt32(resultado);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al crear el pedido: " + ex.Message, ex);
            }
        }

        public void AgregarDetallePedido(DetallePedido detalle)
        {
            try
            {
                datos.SetearConsulta(@"INSERT INTO DETALLEPEDIDO (PedidoId, ProductoId, Cantidad, PrecioUnitario, Estado, Subtotal)  VALUES (@PedidoId, @ProductoId, @Cantidad, @PrecioUnitario, @Estado, @Subtotal)");
                datos.setearParametro("@PedidoId", detalle.Pedido.PedidoId);
                datos.setearParametro("@ProductoId", detalle.Producto.ProductoId);
                datos.setearParametro("@Cantidad", detalle.Cantidad);
                datos.setearParametro("@PrecioUnitario", detalle.PrecioUnitario);
                datos.setearParametro("@Estado", true);
                datos.setearParametro("@Subtotal", detalle.Subtotal);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar detalle de pedido: " + ex.Message, ex);
            }
        }

        public void FinalizarPedido(int pedidoId)
        {
            try
            {
                datos.SetearConsulta(@"UPDATE PEDIDO SET Estado = 0, FechaCierre = @FechaCierre WHERE PedidoId = @PedidoId");
                datos.setearParametro("@FechaCierre", DateTime.Now);
                datos.setearParametro("@PedidoId", pedidoId);
                datos.ejecutarAccion();

                datos.SetearConsulta(@"UPDATE DETALLEPEDIDO SET Estado = 0 WHERE PedidoId = @PedidoId");
                datos.setearParametro("@PedidoId", pedidoId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al finalizar el pedido: " + ex.Message, ex);
            }
        }

        public void CancelarPedido(int pedidoId)
        {
            try
            {
                datos.SetearConsulta(@"UPDATE PEDIDO SET Estado = 0, FechaCierre = @FechaCierre WHERE PedidoId = @PedidoId");
                datos.setearParametro("@FechaCierre", DateTime.Now);
                datos.setearParametro("@PedidoId", pedidoId);
                datos.ejecutarAccion();

                datos.SetearConsulta(@"UPDATE DETALLEPEDIDO SET Estado = 0 WHERE PedidoId = @PedidoId");
                datos.setearParametro("@PedidoId", pedidoId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al cancelar el pedido: " + ex.Message, ex);
            }
        }

        public List<Pedido> ObtenerPedidosActivos()
        {
            List<Pedido> pedidos = new List<Pedido>();
            try
            {
                datos.SetearConsulta(@"SELECT PedidoId, FechaApertura, FechaCierre, Estado, Total, AsignacionId, EsMostrador FROM PEDIDO WHERE Estado = 1 ORDER BY FechaApertura DESC");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido pedido = new Pedido
                    {
                        PedidoId = (int)datos.Lector["PedidoId"],
                        FechaPedido = (DateTime)datos.Lector["FechaApertura"],
                        FechaCierre = datos.Lector["FechaCierre"] != DBNull.Value ? (DateTime)datos.Lector["FechaCierre"] : DateTime.MinValue,
                        EstadoPedido = (bool)datos.Lector["Estado"],
                        Total = (decimal)datos.Lector["Total"],
                        AsignacionMesa = datos.Lector["AsignacionId"] != DBNull.Value ? new AsignacionMesa { AsignacionId = (int)datos.Lector["AsignacionId"] } : null,
                        EsMostrador = (bool)datos.Lector["EsMostrador"]
                    };
                    pedidos.Add(pedido);
                }
                return pedidos;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener pedidos activos: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<DetallePedido> ObtenerDetallesPedido(int pedidoId)
        {
            List<DetallePedido> detalles = new List<DetallePedido>();
            try
            {
                datos.SetearConsulta(@"SELECT d.DetalleId, d.PedidoId, d.ProductoId, d.Cantidad, d.PrecioUnitario, d.Subtotal, p.Nombre  FROM DETALLEPEDIDO d INNER JOIN PRODUCTO p ON d.ProductoId = p.ProductoId  WHERE d.PedidoId = @pedidoId");
                datos.setearParametro("@pedidoId", pedidoId);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    DetallePedido detalle = new DetallePedido
                    {
                        DetalleId = (int)datos.Lector["DetalleId"],
                        Pedido = new Pedido { PedidoId = (int)datos.Lector["PedidoId"] },
                        Producto = new Producto { ProductoId = (int)datos.Lector["ProductoId"] },
                        Cantidad = (int)datos.Lector["Cantidad"],
                        PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"],
                        Subtotal = (decimal)datos.Lector["Subtotal"],
                        NombreProducto = (string)datos.Lector["Nombre"]
                    };
                    detalles.Add(detalle);
                }
                return detalles;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener detalles del pedido: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public Pedido ObtenerPedidoPorId(int pedidoId)
        {
            Pedido pedido = null;
            try
            {
                datos.SetearConsulta(@"SELECT PedidoId, FechaApertura, FechaCierre, Estado, Total, AsignacionId, CantidadPersonas, EsMostrador FROM PEDIDO  WHERE PedidoId = @pedidoId");
                datos.setearParametro("@pedidoId", pedidoId);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    pedido = new Pedido
                    {
                        PedidoId = (int)datos.Lector["PedidoId"],
                        FechaPedido = (DateTime)datos.Lector["FechaApertura"],
                        FechaCierre = datos.Lector["FechaCierre"] != DBNull.Value ? (DateTime)datos.Lector["FechaCierre"] : DateTime.MinValue,
                        EstadoPedido = (bool)datos.Lector["Estado"],
                        Total = (decimal)datos.Lector["Total"],
                        AsignacionMesa = datos.Lector["AsignacionId"] != DBNull.Value ? new AsignacionMesa { AsignacionId = (int)datos.Lector["AsignacionId"] } : null,
                        EsMostrador = (bool)datos.Lector["EsMostrador"]
                    };
                }
                return pedido;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener pedido por ID: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void ActualizarTotalPedido(int pedidoId, decimal nuevoTotal)
        {
            try
            {
                datos.SetearConsulta("UPDATE PEDIDO SET Total = @Total WHERE PedidoId = @PedidoId");
                datos.setearParametro("@Total", nuevoTotal);
                datos.setearParametro("@PedidoId", pedidoId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al actualizar total del pedido: " + ex.Message, ex);
            }
        }
    }
}
