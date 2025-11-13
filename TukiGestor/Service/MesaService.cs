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
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado FROM MESA");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Mesa mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"]
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
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado FROM MESA WHERE Ubicacion = @ubicacion");
                datos.setearParametro("@ubicacion", ubicacion);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Mesa mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"]
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
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado FROM MESA WHERE MesaId = @mesaId");
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"]
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


        public void AgregarMesa(Mesa mesa)
        {
            try
            {
                // Obtener el siguiente número de mesa disponible para la ubicación
                datos.SetearConsulta(@"SELECT ISNULL(MAX(CAST(NumeroMesa AS INT)), 0) + 1 AS ProximoNumero
                                      FROM MESA
                                      WHERE Ubicacion = @ubicacion");
                datos.setearParametro("@ubicacion", mesa.Ubicacion);

                object resultado = datos.ejecutarScalar();
                int proximoNumero = Convert.ToInt32(resultado);
                mesa.NumeroMesa = proximoNumero.ToString();

                // Insertar la nueva mesa
                datos.SetearConsulta("INSERT INTO MESA (NumeroMesa, Ubicacion, Estado) VALUES (@numeroMesa, @ubicacion, @estado)");
                datos.setearParametro("@numeroMesa", mesa.NumeroMesa);
                datos.setearParametro("@ubicacion", mesa.Ubicacion);
                datos.setearParametro("@estado", mesa.Estado);
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
                    throw new Exception("No se encontró la mesa a eliminar");
                }

                // Verificar si la mesa está ocupada (tiene pedidos activos)
                if (mesaEliminar.Estado.ToLower() == "ocupada")
                {
                    throw new Exception("No se puede eliminar una mesa ocupada. Por favor, cierre primero todos los pedidos activos.");
                }

                string ubicacion = mesaEliminar.Ubicacion;
                int numeroMesaEliminar = int.Parse(mesaEliminar.NumeroMesa);

                // PASO 1: Desasociar todos los pedidos (activos y cerrados) de las asignaciones de esta mesa
                // Esto preserva el historial de ventas pero rompe el vínculo con la mesa específica
                datos.SetearConsulta(@"
                    UPDATE PEDIDO
                    SET AsignacionId = NULL, EsMostrador = 1
                    WHERE AsignacionId IN (
                        SELECT AsignacionId
                        FROM ASIGNACIONMESA
                        WHERE MesaId = @mesaId
                    )
                ");
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarAccion();

                // PASO 2: Ahora eliminar todas las asignaciones de esta mesa (ya no tienen pedidos vinculados)
                datos.SetearConsulta("DELETE FROM ASIGNACIONMESA WHERE MesaId = @mesaId");
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarAccion();

                // PASO 3: Eliminar la mesa
                datos.SetearConsulta("DELETE FROM MESA WHERE MesaId = @mesaId");
                datos.setearParametro("@mesaId", mesaId);
                datos.ejecutarAccion();

                // PASO 4: Renumerar las mesas siguientes en la misma ubicación
                RenumerarMesasDespuesDeEliminar(ubicacion, numeroMesaEliminar);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar la mesa: " + ex.Message, ex);
            }
        }

        private void RenumerarMesasDespuesDeEliminar(string ubicacion, int numeroEliminado)
        {
            try
            {
                // Obtener todas las mesas de la ubicación con número mayor al eliminado
                datos.SetearConsulta(@"SELECT MesaId, NumeroMesa
                                      FROM MESA
                                      WHERE Ubicacion = @ubicacion
                                      AND CAST(NumeroMesa AS INT) > @numeroEliminado
                                      ORDER BY CAST(NumeroMesa AS INT)");
                datos.setearParametro("@ubicacion", ubicacion);
                datos.setearParametro("@numeroEliminado", numeroEliminado);
                datos.ejecutarLectura();

                List<int> mesasIds = new List<int>();
                while (datos.Lector.Read())
                {
                    mesasIds.Add((int)datos.Lector["MesaId"]);
                }
                datos.cerrarConexion();

                // Actualizar cada mesa restando 1 a su número
                foreach (int id in mesasIds)
                {
                    AccesoDatos datosUpdate = new AccesoDatos();
                    datosUpdate.SetearConsulta(@"UPDATE MESA
                                                 SET NumeroMesa = CAST((CAST(NumeroMesa AS INT) - 1) AS VARCHAR(50))
                                                 WHERE MesaId = @mesaId");
                    datosUpdate.setearParametro("@mesaId", id);
                    datosUpdate.ejecutarAccion();
                    datosUpdate.cerrarConexion();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error al renumerar las mesas: " + ex.Message, ex);
            }
        }

        public int ContarMesasPorEstado(string ubicacion, string estado)
        {
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM MESA WHERE Ubicacion = @ubicacion AND Estado = @estado");
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
