using System;
using System.Net;
using System.Net.Mail;

namespace Service
{
    public class EmailService
    {
        private MailMessage email;
        private SmtpClient server;

        public EmailService()
        {
            server = new SmtpClient();
            server.Credentials = new NetworkCredential("noresponderprogramacion@gmail.com", "kucd duvx wbhz sboi");
            server.EnableSsl = true;
            server.Port = 587;
            server.Host = "smtp.gmail.com";
        }

        public void armarCorreo(string emailDestino, string asunto, string cuerpo)
        {
            email = new MailMessage();
            email.From = new MailAddress("noresponderprogramacion@gmail.com");
            email.To.Add(emailDestino);
            email.Subject = asunto;
            email.IsBodyHtml = true;
            email.Body = cuerpo;
        }

        public void enviarCorreo()
        {
            try
            {
                server.Send(email);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                email.Dispose();
            }
        }

        public void EnviarEmailNuevoMesero(string emailDestino, string nombre, string apellido, string usuario, string password)
        {
            string asunto = "¡Bienvenido a TUKI, tu asistente de salón!";
            string cuerpo = $@"
                <h2>¡Hola {nombre} {apellido}!</h2>
                <p>Tu cuenta fue creada exitosamente.</p>
                <p>Estos son tus datos para iniciar sesión:</p>
                <ul>
                    <li><strong>Usuario:</strong> {usuario}</li>
                    <li><strong>Contraseña:</strong> {password}</li>
                    <li><strong>Email registrado:</strong> {emailDestino}</li>
                </ul>
                <p>¡Bienvenido al equipo de TUKI!</p>";

            armarCorreo(emailDestino, asunto, cuerpo);
            enviarCorreo();
        }
    }
}
