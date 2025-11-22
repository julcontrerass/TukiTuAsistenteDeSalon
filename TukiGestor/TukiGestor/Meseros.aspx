<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Meseros.aspx.cs" Inherits="TukiGestor.Meseros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- SOLAPAS -->
    <ul class="nav nav-tabs" id="tabsMeseros" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="tab-listado" data-bs-toggle="tab" href="#contenidoListado" role="tab">Meseros Activos
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-nuevo" data-bs-toggle="tab" href="#contenidoNuevo" role="tab">Nuevo Mesero
            </a>
        </li>
    </ul>
    <div class="tab-content mt-3">
        <!-- LISTADO -->
        <div class="tab-pane fade show active" id="contenidoListado" role="tabpanel">
            <asp:Repeater ID="RepeaterMeseros" runat="server">
                <HeaderTemplate>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre Completo</th>
                                <th>Usuario</th>
                                <th>Email</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("MeseroId") %></td>
                        <td><%# Eval("Nombre") + " " + Eval("Apellido") %></td>
                        <td><%# Eval("NombreUsuario") %></td>
                        <td><%# Eval("Email") %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <!-- NUEVO MESERO -->
        <div class="tab-pane fade" id="contenidoNuevo" role="tabpanel">
            <div class="card p-4">
                <h4>Nuevo Mesero</h4>
                <hr />
                <!-- Usuario -->
                <div class="form-group">
                    <label>Nombre de Usuario</label>
                    <asp:TextBox ID="txtNombreUsuario" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Contraseña</label>
                    <asp:TextBox ID="txtContrasenia" TextMode="Password" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <hr />
                <!-- Mesero -->
                <div class="form-group">
                    <label>Nombre</label>
                    <asp:TextBox ID="txtNombreMesero" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Apellido</label>
                    <asp:TextBox ID="txtApellidoMesero" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
                <asp:Button ID="btnGuardarMesero" runat="server" CssClass="btn btn-primary mt-3" Text="Guardar Mesero" OnClick="btnGuardarMesero_Click" />
                <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mt-3"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
