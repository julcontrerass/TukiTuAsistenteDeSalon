using dominio;
using accesoDatos;
using System;
using System.Collections.Generic;

namespace Service
{
    public class MeseroService
    {
        public List<Mesero> ListarActivos()
        {
            List<Mesero> lista = new List<Mesero>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("SELECT M.MeseroId, M.Nombre, M.Apellido, M.Activo, " + "U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email " + "FROM MESERO M " + "INNER JOIN USUARIO U ON U.UsuarioId = M.UsuarioId " + "WHERE M.Activo = 1");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Mesero aux = new Mesero();
                    aux.MeseroId = (int)datos.Lector["MeseroId"];
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

        public List<Mesero> ListarEliminados()
        {
            List<Mesero> lista = new List<Mesero>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT M.MeseroId, M.Nombre, M.Apellido, M.Activo, " + "U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email " +  "FROM MESERO M " + "INNER JOIN USUARIO U ON U.UsuarioId = M.UsuarioId " + "WHERE M.Activo = 0");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Mesero aux = new Mesero();
                    aux.MeseroId = (int)datos.Lector["MeseroId"];
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

        public void Agregar(Mesero nuevo)
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
                datos.SetearConsulta("INSERT INTO MESERO (Nombre, Apellido, Activo, UsuarioId) " + "VALUES (@nom, @ape, 1, @uid)");
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


        public void Desactivar(int meseroId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("UPDATE Mesero SET Activo = 0 WHERE MeseroId = @id");
                datos.setearParametro("@id", meseroId);
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



        public void Reactivar(int meseroId)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.SetearConsulta("UPDATE Mesero SET Activo = 1 WHERE MeseroId = @id");
                datos.setearParametro("@id", meseroId);
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


        public List<Mesero> ListarInactivos()
        {
            AccesoDatos datos = new AccesoDatos();
            List<Mesero> lista = new List<Mesero>();

            datos.SetearConsulta("SELECT m.MeseroId, m.Nombre, m.Apellido, u.NombreUsuario, u.Email " + "FROM Mesero m INNER JOIN Usuario u ON m.UsuarioId = u.UsuarioId " + "WHERE m.Activo = 0");
            datos.ejecutarLectura();
            while (datos.Lector.Read())
            {
                Mesero aux = new Mesero();
                aux.MeseroId = (int)datos.Lector["MeseroId"];
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



        public Mesero ObtenerPorId(int meseroId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT M.MeseroId, M.Nombre, M.Apellido, M.Activo, " + "U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email " + "FROM MESERO M " + "INNER JOIN USUARIO U ON U.UsuarioId = M.UsuarioId " + "WHERE M.MeseroId = @id");
                datos.setearParametro("@id", meseroId);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    Mesero mesero = new Mesero();
                    mesero.MeseroId = (int)datos.Lector["MeseroId"];
                    mesero.Nombre = datos.Lector["Nombre"].ToString();
                    mesero.Apellido = datos.Lector["Apellido"].ToString();
                    mesero.Activo = (bool)datos.Lector["Activo"];
                    mesero.Id = (int)datos.Lector["UsuarioId"];
                    mesero.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                    mesero.Contraseña = datos.Lector["Contrasenia"].ToString();
                    mesero.Email = datos.Lector["Email"].ToString();
                    return mesero;
                }
                return null;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public Mesero BuscarPorUsuarioId(int usuarioId)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.SetearConsulta("SELECT M.MeseroId, M.Nombre, M.Apellido, M.Activo, " + "U.UsuarioId, U.NombreUsuario, U.Contrasenia, U.Email " + "FROM MESERO M " + "INNER JOIN USUARIO U ON U.UsuarioId = M.UsuarioId " + "WHERE M.UsuarioId = @usuarioId");
                datos.setearParametro("@usuarioId", usuarioId);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    Mesero mesero = new Mesero();
                    mesero.MeseroId = (int)datos.Lector["MeseroId"];
                    mesero.Nombre = datos.Lector["Nombre"].ToString();
                    mesero.Apellido = datos.Lector["Apellido"].ToString();
                    mesero.Activo = (bool)datos.Lector["Activo"];
                    mesero.Id = (int)datos.Lector["UsuarioId"];
                    mesero.NombreUsuario = datos.Lector["NombreUsuario"].ToString();
                    mesero.Contraseña = datos.Lector["Contrasenia"].ToString();
                    mesero.Email = datos.Lector["Email"].ToString();
                    return mesero;
                }
                return null;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }



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

        public void Modificar(Mesero mesero, bool cambiarContrasenia)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                if (cambiarContrasenia)
                {
                    datos.SetearConsulta("UPDATE USUARIO SET NombreUsuario = @user, Contrasenia = @pass, Email = @mail " + "WHERE UsuarioId = @id");
                    datos.setearParametro("@pass", mesero.Contraseña);
                }
                else
                {
                    datos.SetearConsulta("UPDATE USUARIO SET NombreUsuario = @user, Email = @mail " + "WHERE UsuarioId = @id");
                }
                datos.setearParametro("@user", mesero.NombreUsuario);
                datos.setearParametro("@mail", mesero.Email);
                datos.setearParametro("@id", mesero.Id);
                datos.ejecutarAccion();
                datos.SetearConsulta("UPDATE MESERO SET Nombre = @nom, Apellido = @ape " + "WHERE MeseroId = @meseroId");
                datos.setearParametro("@nom", mesero.Nombre);
                datos.setearParametro("@ape", mesero.Apellido);
                datos.setearParametro("@meseroId", mesero.MeseroId);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

    }
}
