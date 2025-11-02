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
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado, Activa FROM MESA WHERE Activa = 1");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Mesa mesa = new Mesa
                    {
                        MesaId = (int)datos.Lector["MesaId"],
                        NumeroMesa = (string)datos.Lector["NumeroMesa"],
                        Ubicacion = (string)datos.Lector["Ubicacion"],
                        Estado = (string)datos.Lector["Estado"],
                        Activa = (bool)datos.Lector["Activa"]
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
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado, Activa FROM MESA WHERE Ubicacion = @ubicacion AND Activa = 1");
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
                        Activa = (bool)datos.Lector["Activa"]
                    };
                    mesas.Add(mesa);
                }
                return mesas;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar las mesas por ubicación: " + ex.Message, ex);
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
                datos.SetearConsulta("SELECT MesaId, NumeroMesa, Ubicacion, Estado, Activa FROM MESA WHERE MesaId = @mesaId");
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
                        Activa = (bool)datos.Lector["Activa"]
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
                datos.SetearConsulta("INSERT INTO MESA (NumeroMesa, Ubicacion, Estado, Activa) VALUES (@numeroMesa, @ubicacion, @estado, @activa)");
                datos.setearParametro("@numeroMesa", mesa.NumeroMesa);
                datos.setearParametro("@ubicacion", mesa.Ubicacion);
                datos.setearParametro("@estado", mesa.Estado);
                datos.setearParametro("@activa", mesa.Activa);
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
                datos.SetearConsulta("UPDATE MESA SET Activa = 0 WHERE MesaId = @mesaId");
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
                datos.SetearConsulta("SELECT COUNT(*) FROM MESA WHERE Ubicacion = @ubicacion AND Estado = @estado AND Activa = 1");
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
    }
}
