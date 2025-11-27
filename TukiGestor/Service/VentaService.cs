using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;
using dominio;

namespace Service
{
    public class VentaService
    {
        private AccesoDatos datos;

        public VentaService()
        {
            datos = new AccesoDatos();
        }

        public int RegistrarVenta(Venta venta)
        {
            try
            {
                datos.SetearConsulta(@"INSERT INTO VENTA (PedidoId, FechaVenta, MontoTotal, MetodoPago, MontoRecibido, GerenteId)
                                      OUTPUT INSERTED.VentaId
                                      VALUES (@PedidoId, @FechaVenta, @MontoTotal, @MetodoPago, @MontoRecibido, @GerenteId)");
                datos.setearParametro("@PedidoId", venta.Pedido.PedidoId);
                datos.setearParametro("@FechaVenta", venta.FechaVenta);
                datos.setearParametro("@MontoTotal", venta.MontoTotal);
                datos.setearParametro("@MetodoPago", venta.MetodoPago);
                datos.setearParametro("@MontoRecibido", venta.MontoRecibido.HasValue ? (object)venta.MontoRecibido.Value : DBNull.Value);
                datos.setearParametro("@GerenteId", venta.Gerente?.GerenteId ?? (object)DBNull.Value);

                object resultado = datos.ejecutarScalar();
                return Convert.ToInt32(resultado);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al registrar la venta: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
