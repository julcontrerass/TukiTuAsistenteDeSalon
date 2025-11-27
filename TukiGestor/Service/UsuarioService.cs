using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BCrypt.Net;
using accesoDatos;
using dominio;


namespace Service
{
    public class UsuarioService
    {

        private AccesoDatos datos = new AccesoDatos();

        public UsuarioService() { }
        public string hashearContraseña(string password)
        {
            return BCrypt.Net.BCrypt.HashPassword(password);
        }


        public bool validarCredenciales(string usuario, string password, out string mensajeError)
        {

            try
            {
                datos.SetearConsulta("SELECT TOP(1) NombreUsuario, Contrasenia from USUARIO where NombreUsuario = @usuario COLLATE Latin1_General_CS_AS;");
                datos.setearParametro("@usuario", usuario);
                datos.ejecutarLectura();
                if (!datos.Lector.Read())
                {
                    mensajeError = "El usuario ingresado no existe";
                    return false;
                }
                string user = (string)datos.Lector["NombreUsuario"];
                string passwordHash = (string)datos.Lector["Contrasenia"];
                bool passwordCorrecto = BCrypt.Net.BCrypt.Verify(password, passwordHash);

                if (!passwordCorrecto)
                {
                    mensajeError = "La contraseña ingresada no es correcta.";
                    return false;
                }

                mensajeError = "";
                return true;
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo obtener los datos del usuario ingresado, intentelo nuevamente" + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }

        }

        public Usuario buscarUsuario(string nombreUsuario)
        {

            try
            {
                datos.SetearConsulta("SELECT TOP(1) UsuarioId, NombreUsuario, Contrasenia, Email, Rol from USUARIO where NombreUsuario = @usuario COLLATE Latin1_General_CS_AS;");
                datos.setearParametro("@usuario", nombreUsuario);
                datos.ejecutarLectura();

                if (!datos.Lector.Read()) { 
                throw new Exception("No se pudieron obtener los datos del usuario que hizo login.");
                }

                Usuario usuario = new Usuario();
                usuario.Id = (int)datos.Lector["UsuarioId"];
                usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                usuario.Contraseña = (string)datos.Lector["Contrasenia"];
                usuario.Rol = (string)datos.Lector["Rol"];
                usuario.Email = (string)datos.Lector["Email"];

                return usuario; 
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally { datos.cerrarConexion(); }
        }
    }
}