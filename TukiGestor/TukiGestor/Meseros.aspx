<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Meseros.aspx.cs" Inherits="TukiGestor.Meseros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- SOLAPAS -->
    <ul class="nav nav-tabs" id="tabsMeseros" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="tab-listado" data-bs-toggle="tab" href="#contenidoListado" role="tab">Meseros Activos</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-nuevo" data-bs-toggle="tab" href="#contenidoNuevo" role="tab">Nuevo Mesero</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-inactivos" data-bs-toggle="tab" href="#contenidoInactivos" role="tab">Meseros Inactivos</a>
        </li>
    </ul>
    <div class="tab-content mt-3">
        <!-- LISTADO -->
        <div class="tab-pane fade show active" id="contenidoListado" role="tabpanel">
            <asp:Repeater ID="RepeaterMeseros" runat="server" OnItemCommand="RepeaterMeseros_ItemCommand">
                <HeaderTemplate>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre Completo</th>
                                <th>Usuario</th>
                                <th>Email</th>
                                <th>Acciones</th>
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
                        <td>
                            <asp:Button ID="btnDesactivar" runat="server" CssClass="btn btn-danger btn-sm" Text="Desactivar" CommandName="Desactivar" CommandArgument='<%# Eval("MeseroId") %>' />
                        </td>
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
        <!-- MESEROS INACTIVOS -->
        <div class="tab-pane fade" id="contenidoInactivos" role="tabpanel">
            <h4>Meseros Inactivos</h4>
            <asp:Repeater ID="RepeaterMeserosInactivos" runat="server" OnItemCommand="RepeaterMeserosInactivos_ItemCommand">
                <HeaderTemplate>
                    <table class="table table-striped mt-3">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre Completo</th>
                                <th>Usuario</th>
                                <th>Email</th>
                                <th>Acciones</th>
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
                        <td>
                            <asp:Button ID="btnReactivar" runat="server" Text="Reactivar" CssClass="btn btn-success btn-sm" CommandName="Reactivar" CommandArgument='<%# Eval("MeseroId") %>' />
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody>
            </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
