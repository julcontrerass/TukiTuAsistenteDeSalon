using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using accesoDatos;
using dominio;

namespace Service
{
    public class AsignacionMesaService
    {
        private AccesoDatos datos;

        public AsignacionMesaService()
        {
            datos = new AccesoDatos();
        }

        public int CrearAsignacion(AsignacionMesa asignacion)
        {
            try
            {
                datos.SetearConsulta(@"INSERT INTO ASIGNACIONMESA (FechaAsignacion, MeseroId, MesaId, Activa)
                                      OUTPUT INSERTED.AsignacionId
                                      VALUES (@FechaAsignacion, @MeseroId, @MesaId, @Activa)");
                datos.setearParametro("@FechaAsignacion", asignacion.FechaAsignacion);
                datos.setearParametro("@MeseroId", asignacion.Mesero.MeseroId);
                datos.setearParametro("@MesaId", asignacion.Mesa.MesaId);
                datos.setearParametro("@Activa", asignacion.Activa);

                object resultado = datos.ejecutarScalar();
                return Convert.ToInt32(resultado);
            }
            catch (Exception ex)
            {
                throw new Exception("Error al crear la asignacion: " + ex.Message, ex);
            }
        }

        public void DesactivarAsignacion(int asignacionId)
        {
            try
            {
                datos.SetearConsulta("UPDATE ASIGNACIONMESA SET Activa = 0 WHERE AsignacionId = @AsignacionId");
                datos.setearParametro("@AsignacionId", asignacionId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al desactivar la asignacion: " + ex.Message, ex);
            }
        }

        public AsignacionMesa ObtenerAsignacionPorMesa(int mesaId)
        {
            AsignacionMesa asignacion = null;
            try
            {
                datos.SetearConsulta(@"SELECT TOP 1 AsignacionId, FechaAsignacion, MeseroId, MesaId, Activa
                                      FROM ASIGNACIONMESA
                                      WHERE MesaId = @MesaId AND Activa = 1
                                      ORDER BY FechaAsignacion DESC");
                datos.setearParametro("@MesaId", mesaId);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    asignacion = new AsignacionMesa
                    {
                        AsignacionId = (int)datos.Lector["AsignacionId"],
                        FechaAsignacion = (DateTime)datos.Lector["FechaAsignacion"],
                        Mesero = new Mesero { MeseroId = (int)datos.Lector["MeseroId"] },
                        Mesa = new Mesa { MesaId = (int)datos.Lector["MesaId"] },
                        Activa = (bool)datos.Lector["Activa"]
                    };
                }
                return asignacion;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener asignacion por mesa: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public AsignacionMesa ObtenerAsignacionPorId(int asignacionId)
        {
            AsignacionMesa asignacion = null;
            try
            {
                datos.SetearConsulta(@"SELECT AsignacionId, FechaAsignacion, MeseroId, MesaId, Activa
                                      FROM ASIGNACIONMESA
                                      WHERE AsignacionId = @AsignacionId");
                datos.setearParametro("@AsignacionId", asignacionId);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    asignacion = new AsignacionMesa
                    {
                        AsignacionId = (int)datos.Lector["AsignacionId"],
                        FechaAsignacion = (DateTime)datos.Lector["FechaAsignacion"],
                        Mesero = new Mesero { MeseroId = (int)datos.Lector["MeseroId"] },
                        Mesa = new Mesa { MesaId = (int)datos.Lector["MesaId"] },
                        Activa = (bool)datos.Lector["Activa"]
                    };
                }
                return asignacion;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener asignacion por ID: " + ex.Message, ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
