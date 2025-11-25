using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;
using dominio;

namespace Service
{
    public class MesaService
    {
        private AccesoDatos datos;

        public MesaService()
        {
            datos = new AccesoDatos();
        }

        public List<Mesa> ListarMesas()
        {
            List<Mesa> mesas = new List<Mesa>();
            try
            {
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado, ISNULL(PosicionX, 0) AS PosicionX, ISNULL(PosicionY, 0) AS PosicionY, ISNULL(Activo, 1) AS Activo FROM MESA WHERE Activo = 1");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Mesa mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"],
                        PosicionX = (int)datos.Lector["PosicionX"],
                        PosicionY = (int)datos.Lector["PosicionY"],
                        Activo = (bool)datos.Lector["Activo"]
                    };
                    mesas.Add(mesa);
                }
                return mesas;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las mesas: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Mesa> ListarMesasPorUbicacion(string ubicacion)
        {
            List<Mesa> mesas = new List<Mesa>();
            try
            {
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado, ISNULL(PosicionX, 0) AS PosicionX, ISNULL(PosicionY, 0) AS PosicionY, ISNULL(Activo, 1) AS Activo FROM MESA WHERE Ubicacion = @ubicacion AND Activo = 1");
                datos.setearParametro("@ubicacion", ubicacion);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Mesa mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"],
                        PosicionX = (int)datos.Lector["PosicionX"],
                        PosicionY = (int)datos.Lector["PosicionY"],
                        Activo = (bool)datos.Lector["Activo"]
                    };
                    mesas.Add(mesa);
                }
                return mesas;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las mesas por ubicacion: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public Mesa ObtenerMesaPorId(int mesaId)
        {
            Mesa mesa = null;
            try
            {
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado, ISNULL(PosicionX, 0) AS PosicionX, ISNULL(PosicionY, 0) AS PosicionY, ISNULL(Activo, 1) AS Activo FROM MESA WHERE MesaId = @mesaId");
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"],
                        PosicionX = (int)datos.Lector["PosicionX"],
                        PosicionY = (int)datos.Lector["PosicionY"],
                        Activo = (bool)datos.Lector["Activo"]
                    };
                }
                return mesa;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener la mesa: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

  
        public void ActualizarEstadoMesa(int mesaId, string estado)
        {
            try
            {
                datos.SetearConsulta("UPDATE MESA SET Estado = @estado WHERE MesaId = @mesaId");
                datos.setearParametro("@estado", estado);
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al actualizar el estado de la mesa: " + ex.Message, ex);
            }
        }

        public void ActualizarPosicion(int mesaId, int posicionX, int posicionY)
        {
            try
            {
                datos.SetearConsulta("UPDATE MESA SET PosicionX = @posicionX, PosicionY = @posicionY WHERE MesaId = @mesaId");
                datos.setearParametro("@posicionX", posicionX);
                datos.setearParametro("@posicionY", posicionY);
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al actualizar la posicion de la mesa: " + ex.Message, ex);
            }
        }


        public void AgregarMesa(Mesa mesa)
        {
            try
            {
                // Obtener el siguiente número de mesa disponible para la ubicación (solo activas)
                datos.SetearConsulta(@"SELECT ISNULL(MAX(CAST(NumeroMesa AS INT)), 0) + 1 AS ProximoNumero
                                      FROM MESA
                                      WHERE Ubicacion = @ubicacion AND Activo = 1");
                datos.setearParametro("@ubicacion", mesa.Ubicacion);

                object resultado = datos.ejecutarScalar();
                int proximoNumero = Convert.ToInt32(resultado);
                mesa.NumeroMesa = proximoNumero.ToString();

                // Calcular posición inicial para la nueva mesa (evitar solapamiento)
                // 150px de ancho + 20px de gap = 170px de separación
                // 4 mesas por fila
                int posicionX = 20 + ((proximoNumero - 1) % 4) * 170;
                int posicionY = 20 + ((proximoNumero - 1) / 4) * 170;

                // Insertar la nueva mesa
                datos.SetearConsulta("INSERT INTO MESA (NumeroMesa, Ubicacion, Estado, PosicionX, PosicionY, Activo) VALUES (@numeroMesa, @ubicacion, @estado, @posicionX, @posicionY, 1)");
                datos.setearParametro("@numeroMesa", mesa.NumeroMesa);
                datos.setearParametro("@ubicacion", mesa.Ubicacion);
                datos.setearParametro("@estado", mesa.Estado);
                datos.setearParametro("@posicionX", posicionX);
                datos.setearParametro("@posicionY", posicionY);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar la mesa: " + ex.Message, ex);
            }
        }


        public void EliminarMesa(int mesaId)
        {
            try
            {
                // Primero obtener la mesa para saber su ubicación y número
                Mesa mesaEliminar = ObtenerMesaPorId(mesaId);
                if (mesaEliminar == null)
                {
                    throw new Exception("No se encontro la mesa a eliminar");
                }

                // Verificar si la mesa está ocupada (tiene pedidos activos)
                if (mesaEliminar.Estado.ToLower() == "ocupada")
                {
                    throw new Exception("No se puede eliminar una mesa ocupada. Por favor, cierre primero todos los pedidos activos.");
                }

                // Eliminación lógica: marcar como inactiva
                datos.SetearConsulta("UPDATE MESA SET Activo = 0 WHERE MesaId = @mesaId");
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar la mesa: " + ex.Message, ex);
            }
        }


        public int ContarMesasPorEstado(string ubicacion, string estado)
        {
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM MESA WHERE Ubicacion = @ubicacion AND Estado = @estado AND Activo = 1");
                datos.setearParametro("@ubicacion", ubicacion);
                datos.setearParametro("@estado", estado);

                object resultado = datos.ejecutarScalar();
                return Convert.ToInt32(resultado);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al contar las mesas: " + ex.Message, ex);
            }
        }

        public void SincronizarEstadoMesasConPedidos()
        {
            try
            {
                // Primero, marcar todas las mesas como libres
                datos.SetearConsulta("UPDATE MESA SET Estado = 'libre'");
                datos.ejecutarAccion();

                // Luego, marcar como ocupadas las mesas que tienen asignaciones activas
                // (independientemente de si tienen pedidos o no, porque la mesa se ocupa al asignar mesero)
                datos.SetearConsulta(@"
                    UPDATE MESA
                    SET Estado = 'ocupada'
                    WHERE MesaId IN (
                        SELECT DISTINCT MesaId
                        FROM ASIGNACIONMESA
                        WHERE Activa = 1
                    )
                ");
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al sincronizar estado de mesas: " + ex.Message, ex);
            }
        }
    }
}
