<%@ Page Title="Registrarse" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registrarse.aspx.cs" Inherits="TukiGestor.Registrarse" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Content/registrarse") %>
</asp:Content>
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
       
</asp:Content>
