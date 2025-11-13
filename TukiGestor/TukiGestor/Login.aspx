<%@ Page Title="Login" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TukiGestor.Contact" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - TUKI</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <%: Styles.Render("~/Content/login") %>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-card">
                <div class="logo-container">
                    <img src="Assets/LogoTransparente.png" alt="TUKI Logo" />
                </div>

                <h2 class="login-title">Iniciar Sesión</h2>

                <div class="field-wrapper">
                    <label for="txtUsuario">Nombre de usuario</label>
                    <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="field-wrapper">
                    <label for="txtContrasena">Contraseña</label>
                    <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                </div>

                <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>

                <asp:Button ID="btnIniciarSesion" runat="server" CssClass="btn-login" Text="Iniciar Sesión" OnClick="btnIniciarSesion_Click" />
            </div>
        </div>
    </form>
</body>
</html>
