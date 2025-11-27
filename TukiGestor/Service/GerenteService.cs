using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;
using accesoDatos;

namespace Service
{
    public class GerenteService
    {


        public List<Gerente> ListarActivos()
        {
            List<Gerente> lista = new List<Gerente>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT G.GerenteId, G.Nombre, G.Apellido, G.Activo, " + "U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email " + "FROM GERENTE G " + "INNER JOIN USUARIO U ON U.UsuarioId = G.UsuarioId " + "WHERE G.Activo = 1");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Gerente aux = new Gerente();
                    aux.GerenteId = (int)datos.Lector["GerenteId"];
                    aux.Nombre = datos.Lector["Nombre"].ToString();
                    aux.Apellido = datos.Lector["Apellido"].ToString();
                    aux.Activo = (bool)datos.Lector["Activo"];
                    // Datos del usuario
                    aux.Id = (int)datos.Lector["UsuarioId"];
                    aux.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                    aux.Contraseña = datos.Lector["Contrasenia"].ToString();
                    aux.Email = datos.Lector["Email"].ToString();
                    lista.Add(aux);
                }
                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Gerente> ListarEliminados()
        {
            List<Gerente> lista = new List<Gerente>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT G.GerenteId, G.Nombre, G.Apellido, G.Activo, " + "U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email " + "FROM GERENTE G " + "INNER JOIN USUARIO U ON U.UsuarioId = G.UsuarioId " + "WHERE G.Activo = 0");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Gerente aux = new Gerente();
                    aux.GerenteId = (int)datos.Lector["GerenteId"];
                    aux.Nombre = datos.Lector["Nombre"].ToString();
                    aux.Apellido = datos.Lector["Apellido"].ToString();
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.Id = (int)datos.Lector["UsuarioId"];
                    aux.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                    aux.Contraseña = datos.Lector["Contrasenia"].ToString();
                    aux.Email = datos.Lector["Email"].ToString();
                    lista.Add(aux);
                }
                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void Agregar(Gerente nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // insertamos Usuario
                datos.SetearConsulta("INSERT INTO USUARIO (NombreUsuario, Contrasenia, Email, Rol) " + "OUTPUT INSERTED.UsuarioId " + "VALUES (@user, @pass, @mail, @rol)");
                datos.setearParametro("@user", nuevo.NombreUsuario);
                datos.setearParametro("@pass", nuevo.Contraseña);
                datos.setearParametro("@mail", nuevo.Email);
                datos.setearParametro("@rol", nuevo.Rol);
                int nuevoUsuarioId = (int)datos.ejecutarScalar();

                datos.SetearConsulta("INSERT INTO GERENTE (Nombre, Apellido, Activo, UsuarioId) " + "VALUES (@nom, @ape, 1, @uid)");
                datos.setearParametro("@nom", nuevo.Nombre);
                datos.setearParametro("@ape", nuevo.Apellido);
                datos.setearParametro("@uid", nuevoUsuarioId);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public void Desactivar(int gerenteId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("UPDATE Gerente SET Activo = 0 WHERE GerenteId = @id");
                datos.setearParametro("@id", gerenteId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }



        public void Reactivar(int gerenteId)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("UPDATE GERENTE SET Activo = 1 WHERE GerenteId = @id");
                datos.setearParametro("@id", gerenteId);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public List<Gerente> ListarInactivos()
        {
            AccesoDatos datos = new AccesoDatos();
            List<Gerente> lista = new List<Gerente>();

            datos.SetearConsulta("SELECT G.GerenteId, G.Nombre, G.Apellido, U.NombreUsuario, U.Email " + "FROM GERENTE G INNER JOIN Usuario u ON G.UsuarioId = u.UsuarioId " + "WHERE G.Activo = 0");
            datos.ejecutarLectura();
            while (datos.Lector.Read())
            {
                Gerente aux = new Gerente();
                aux.GerenteId = (int)datos.Lector["GerenteId"];
                aux.Nombre = datos.Lector["Nombre"].ToString();
                aux.Apellido = datos.Lector["Apellido"].ToString();
                aux.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                aux.Email = datos.Lector["Email"].ToString();
                lista.Add(aux);
            }
            datos.cerrarConexion();
            return lista;
        }


        public bool ExisteNombreUsuario(string nombreUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM USUARIO WHERE NombreUsuario = @user");
                datos.setearParametro("@user", nombreUsuario);
                int count = (int)datos.ejecutarScalar();
                return count > 0;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public bool ExisteEmail(string email)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM USUARIO WHERE Email = @mail");
                datos.setearParametro("@mail", email);
                int count = (int)datos.ejecutarScalar();
                return count > 0;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }



        public Gerente ObtenerPorId(int gerenteId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT G.GerenteId, G.Nombre, G.Apellido, G.Activo, U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email FROM GERENTE G INNER JOIN USUARIO U ON U.UsuarioId = G.UsuarioId WHERE G.GerenteId = @id");
                datos.setearParametro("@id", gerenteId);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    Gerente gerente = new Gerente();
                    gerente.GerenteId = (int)datos.Lector["GerenteId"];
                    gerente.Nombre = datos.Lector["Nombre"].ToString();
                    gerente.Apellido = datos.Lector["Apellido"].ToString();
                    gerente.Activo = (bool)datos.Lector["Activo"];
                    gerente.Id = (int)datos.Lector["UsuarioId"];
                    gerente.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                    gerente.Contraseña = datos.Lector["Contrasenia"].ToString();
                    gerente.Email = datos.Lector["Email"].ToString();
                    return gerente;
                }
                return null;
            }catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public Gerente BuscarPorUsuarioId(int usuarioId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT G.GerenteId, G.Nombre, G.Apellido, G.Activo, U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email FROM GERENTE G INNER JOIN USUARIO U ON U.UsuarioId = G.UsuarioId WHERE G.UsuarioId = @usuarioId");
                datos.setearParametro("@usuarioId", usuarioId);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    Gerente gerente = new Gerente();
                    gerente.GerenteId = (int)datos.Lector["GerenteId"];
                    gerente.Nombre = datos.Lector["Nombre"].ToString();
                    gerente.Apellido = datos.Lector["Apellido"].ToString();
                    gerente.Activo = (bool)datos.Lector["Activo"];
                    gerente.Id = (int)datos.Lector["UsuarioId"];
                    gerente.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                    gerente.Contraseña = datos.Lector["Contrasenia"].ToString();
                    gerente.Email = datos.Lector["Email"].ToString();
                    return gerente;
                }
                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        // validamos si existe el nombre de usuario (excluyendo el usuario actual)
        public bool ExisteNombreUsuarioParaOtro(string nombreUsuario, int usuarioIdActual)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM USUARIO WHERE NombreUsuario = @user AND UsuarioId != @id");
                datos.setearParametro("@user", nombreUsuario);
                datos.setearParametro("@id", usuarioIdActual);
                int count = (int)datos.ejecutarScalar();
                return count > 0;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        // validamos si existe el email (excluyendo el usuario actual)
        public bool ExisteEmailParaOtro(string email, int usuarioIdActual)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT COUNT(*) FROM USUARIO WHERE Email = @mail AND UsuarioId != @id");
                datos.setearParametro("@mail", email);
                datos.setearParametro("@id", usuarioIdActual);
                int count = (int)datos.ejecutarScalar();
                return count > 0;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void Modificar(Gerente gerente, bool cambiarContrasenia)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Actualizar Usuario
                if (cambiarContrasenia)
                {
                    datos.SetearConsulta("UPDATE USUARIO SET NombreUsuario = @user, Contrasenia = @pass, Email = @mail " + "WHERE UsuarioId = @id");
                    datos.setearParametro("@pass", gerente.Contraseña);
                }
                else
                {
                    datos.SetearConsulta("UPDATE USUARIO SET NombreUsuario = @user, Email = @mail " + "WHERE UsuarioId = @id");
                }
                datos.setearParametro("@user", gerente.NombreUsuario);
                datos.setearParametro("@mail", gerente.Email);
                datos.setearParametro("@id", gerente.Id);
                datos.ejecutarAccion();
                // Actualizar gerente
                datos.SetearConsulta("UPDATE GERENTE SET Nombre = @nom, Apellido = @ape " + "WHERE GerenteId = @gerenteId");
                datos.setearParametro("@nom", gerente.Nombre);
                datos.setearParametro("@ape", gerente.Apellido);
                datos.setearParametro("@gerenteId", gerente.GerenteId);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

    }


}

