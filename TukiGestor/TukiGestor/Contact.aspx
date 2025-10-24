<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TukiGestor.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="d-flex align-items-center justify-content-center vh-100 bg-light">
        <div class="card shadow-lg p-4 border-0" style="width: 22rem; border-radius: 1rem;">
            <h4 class="text-center mb-4 fw-bold text-primary">Iniciar Sesión</h4>

            <div class="mb-3 field-wrapper">
                <label for="txtUsuario" class="form-label fw-semibold text-center field-control d-block">Nombre de usuario</label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control input-focus field-control"></asp:TextBox>
            </div>

            <div class="mb-3 field-wrapper">
                <label for="txtContrasena" class="form-label fw-semibold text-center field-control d-block">Contraseña</label>
                <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control input-focus field-control" TextMode="Password"></asp:TextBox>
            </div>

            <div class="mt-3 field-wrapper">
                <asp:Button ID="btnIniciarSesion" runat="server" CssClass="btn btn-primary fw-bold py-2 field-control" Text="Iniciar Sesión" OnClick="btnIniciarSesion_Click" />
            </div>

            <div class="text-center mt-4">
                <asp:Label ID="lblMensaje" runat="server" CssClass="text-muted d-block mb-1">¿Es tu primera vez acá?</asp:Label>
                <asp:HyperLink ID="lnkRegistro" runat="server" NavigateUrl="~/Registrarse.aspx" CssClass="text-primary text-decoration-none fw-bold">Registrate</asp:HyperLink>
            </div>
        </div>
    </main>

    <style>
        body {
            background: linear-gradient(to right, #e3f2fd, #ffffff);
        }

        .field-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .field-control {
            max-width: 16.5rem;
            width: 100%;
        }

        .input-focus:focus {
            border-color: #0d6efd !important;
            box-shadow: 0 0 6px rgba(13, 110, 253, 0.35) !important;
            transition: all 0.2s ease-in-out;
        }

        .form-control {
            border-radius: 0.5rem;
        }

        .btn-primary {
            border-radius: 0.5rem;
        }

        .btn-primary:hover {
            background-color: #0b5ed7 !important;
            box-shadow: 0 4px 10px rgba(13, 110, 253, 0.25);
            transition: all 0.15s ease-in-out;
        }

        .form-control {
            border-radius: 0.5rem;
            border: 2px solid #90caf9; 
            background-color: #ffffff;
            transition: all 0.25s ease-in-out;
        }

    </style>
</asp:Content>
