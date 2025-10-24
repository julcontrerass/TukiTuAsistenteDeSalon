<%@ Page Title="Registrarse" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registrarse.aspx.cs" Inherits="TukiGestor.Registrarse" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main class="d-flex align-items-center justify-content-center vh-100 bg-light">
        <div class="card shadow-lg p-4 border-0" style="width: 22rem; border-radius: 1rem;">
            <h4 class="text-center mb-4 fw-bold text-primary">Registrarse</h4>

            <!-- Campo usuario -->
            <div class="mb-3 field-wrapper">
                <label for="txtUsuario" class="form-label fw-semibold text-center field-control d-block">Ingrese nombre de usuario</label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control input-focus field-control"></asp:TextBox>
            </div>

            <!-- Campo contraseña -->
            <div class="mb-3 field-wrapper">
                <label for="txtContrasena" class="form-label fw-semibold text-center field-control d-block">Ingrese contraseña</label>
                <asp:TextBox ID="txtContrasena" runat="server" CssClass="form-control input-focus field-control" TextMode="Password"></asp:TextBox>
            </div>
            <div class="mb-3 field-wrapper">
                <label for="txtRepetirContrasena" class="form-label fw-semibold text-center field-control d-block">Repita la contraseña</label>
                <asp:TextBox ID="TextRepetirContrasena" runat="server" CssClass="form-control input-focus field-control" TextMode="Password"></asp:TextBox>
            </div>

            <!-- Botón centrado -->
            <div class="mt-3 field-wrapper">
                <asp:Button ID="btnRegistrarse" runat="server" CssClass="btn btn-primary fw-bold py-2 field-control" Text="Registrarse" OnClick="btnRegistrarse_Click" />
            </div>

            <!-- Enlace a registro -->
            <div class="text-center mt-4">
                <asp:Label ID="lblMensaje" runat="server" CssClass="text-muted d-block mb-1">¿Ya tenes una cuenta?</asp:Label>
                <asp:HyperLink ID="lnkRegistro" runat="server" NavigateUrl="~/About.aspx" CssClass="text-primary text-decoration-none fw-bold">Iniciar sesión</asp:HyperLink>
            </div>
        </div>
    </main>


    <style>


         body {
     background: linear-gradient(to right, #e3f2fd, #ffffff);
 }

 /* Centrado del bloque label+input+botón */
 .field-wrapper {
     display: flex;
     flex-direction: column;
     align-items: center;
 }

 /* Ancho común para campos y botón */
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

 /* Borde colorido por defecto */
 .form-control {
     border-radius: 0.5rem;
     border: 2px solid #90caf9; /* azul suave */
     background-color: #ffffff;
     transition: all 0.25s ease-in-out;
 }



    </style>

</asp:Content>
