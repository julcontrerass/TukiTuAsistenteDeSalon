<%@ Page Title="Login" Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TukiGestor.Contact" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - TUKI</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #F6EFE0;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-container {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
        }

        .login-card {
            background-color: #fff;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-container img {
            max-width: 150px;
            height: auto;
        }

        .login-title {
            text-align: center;
            color: #333;
            font-size: 1.8em;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .field-wrapper {
            margin-bottom: 20px;
        }

        .field-wrapper label {
            display: block;
            color: #666;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 0.95em;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #E7D9C2;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #d4c5ae;
            outline: none;
            box-shadow: 0 0 0 3px rgba(231, 217, 194, 0.2);
        }

        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: #E7D9C2;
            color: #333;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-login:hover {
            background-color: #d4c5ae;
            color: #000;
        }

        .register-link {
            text-align: center;
            margin-top: 25px;
            color: #666;
        }

        .register-link a {
            color: #333;
            font-weight: 600;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            display: block;
            color: #d32f2f;
            background-color: #ffebee;
            padding: 10px 15px;
            border-radius: 8px;
            text-align: center;
            margin-top: 15px;
            font-size: 0.9em;
            border: 1px solid #ef9a9a;
        }
    </style>
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
